local QBCore = exports['qb-core']:GetCoreObject()

-- Function to check if an NPC is dead
local function IsNPCDead(npc)
    return IsEntityDead(npc)
end

-- Function to add dead NPCs to qb-target
local function AddDeadNPCToTarget(npc, netId)
    exports['qb-target']:AddTargetEntity(npc, {
        options = {
            {
                type = "client",
                event = "lootDeadNPC:client:loot",
                icon = "fas fa-hand-paper",
                label = "Loot",
                netId = netId
            }
        },
        distance = 2.5
    })
end

-- Event to handle looting
RegisterNetEvent('lootDeadNPC:client:loot', function(data)
    local npc = NetworkGetEntityFromNetworkId(data.netId)
    if IsNPCDead(npc) then
        TriggerServerEvent('lootDeadNPC:server:loot', data.netId)
    else
        QBCore.Functions.Notify("You can't loot this NPC.", 'error')
    end
end)

-- Thread to detect dead NPCs and add them to qb-target
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local npcs = GetGamePool('CPed')

        for _, npc in ipairs(npcs) do
            if IsNPCDead(npc) and not IsEntityAMissionEntity(npc) then
                local npcCoords = GetEntityCoords(npc)
                local distance = #(playerCoords - npcCoords)
                if distance < 5.0 then
                    local netId = NetworkGetNetworkIdFromEntity(npc)
                    AddDeadNPCToTarget(npc, netId)
                    sleep = 0
                end
            end
        end
        Wait(sleep)
    end
end)