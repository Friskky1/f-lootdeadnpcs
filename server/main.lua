local QBCore = exports['qb-core']:GetCoreObject()

-- Table to track looted NPCs
local lootedNPCs = {}

-- Function to give loot to the player
local function GiveLoot(playerId)
    local src = playerId
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    for _, item in pairs(Config.LootItems) do
        if math.random(1, 100) <= item.chance then
            if item.name == "cash" then
                local cashamount = item.amount
                Player.Functions.AddMoney("cash", cashamount)
                TriggerClientEvent('QBCore:Notify', src, "You found $" .. cashamount, 'success')
            else
                Player.Functions.AddItem(item.name, item.amount)
                TriggerClientEvent('QBCore:Notify', src, "You found " .. item.amount .. "x " .. item.name, 'success')
            end
        end
    end
end

-- Event to handle NPC looting
RegisterNetEvent('f-lootDeadNPC:server:loot', function(netId)
    local src = source
    local npc = NetworkGetEntityFromNetworkId(netId)
    local coords = GetEntityCoords(npc)
    if lootedNPCs[netId] then
        TriggerClientEvent('QBCore:Notify', src, "This NPC has already been looted.", 'error')
        return
    end
    if DoesEntityExist(npc) then
        lootedNPCs[netId] = true
        GiveLoot(src)
        SetTimeout(Config.LootedDespawnTime * 1000, function()
            DeleteEntity(npc)
            if Config.Debug then
                print("[DEBUG] NPC despawned at " ..coords)
            end
        end)
        TriggerClientEvent('f-lootDeadNPC:client:syncLooted', -1, netId)
    else
        TriggerClientEvent('QBCore:Notify', src, "You can't loot this NPC.", 'error')
    end
end)