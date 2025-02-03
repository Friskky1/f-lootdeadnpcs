local QBCore = exports['qb-core']:GetCoreObject()

-- Table to track looted NPCs client-side
local lootedNPCs = {}
local npcs = {}

-- Function to check if an NPC is dead
local function IsNPCDead(npc)
    return IsEntityDead(npc)
end

-- Function to add dead NPCs to qb-target
local function AddDeadNPCToTarget(npc, netId)
    -- Check if the NPC is already looted
    if lootedNPCs[netId] then return end

    exports['qb-target']:AddTargetEntity(npc, {
        options = {
            {
                type = "client",
                event = "f-lootDeadNPC:client:loot",
                icon = "fas fa-hand-paper",
                label = "Loot",
                netId = netId
            }
        },
        distance = 2.5
    })
end

-- Event to handle looting
RegisterNetEvent('f-lootDeadNPC:client:loot', function(data)
    local npc = NetworkGetEntityFromNetworkId(data.netId)
    if IsNPCDead(npc) then
        QBCore.Functions.Progressbar('looting', 'Looting NPC', Config.LootNPCTime * 1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
            }, {
                animDict = 'pickup_object',
                anim = 'pickup_low',
                flags = 0,
                task = nil,
            }, {}, {}, function()
                TriggerServerEvent('f-lootDeadNPC:server:loot', data.netId)
            end, function()
                -- Canceled action
        end)
    else
        QBCore.Functions.Notify("You can't loot this NPC.", 'error')
    end
end)

-- Event to sync looted NPCs
RegisterNetEvent('f-lootDeadNPC:client:syncLooted', function(netId)
    -- Mark the NPC as looted
    lootedNPCs[netId] = true

    -- Remove the NPC from qb-target
    local npc = NetworkGetEntityFromNetworkId(netId)
    exports['qb-target']:RemoveTargetEntity(npc)
end)

-- Thread to detect dead NPCs and add them to qb-target
CreateThread(function()
    while true do
        local sleep = 5000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local npcs = GetGamePool('CPed')
        
        for _, npc in ipairs(npcs) do
            if IsNPCDead(npc) and not IsEntityAMissionEntity(npc) then
                local npcCoords = GetEntityCoords(npc)
                local distance = #(playerCoords - npcCoords)
                if distance < 50.0 then
                    local netId = NetworkGetNetworkIdFromEntity(npc)
                    AddDeadNPCToTarget(npc, netId)
                    sleep = 2500
                end
            end
        end
        Wait(sleep)
    end
end)