local QBCore = exports['qb-core']:GetCoreObject()

-- Function to give loot to the player
local function GiveLoot(playerId)
    local src = playerId
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    for _, item in pairs(Config.LootItems) do
        if math.random(1, 100) <= item.chance then
            Player.Functions.AddItem(item.name, item.amount)
            TriggerClientEvent('QBCore:Notify', src, "You found " .. item.amount .. "x " .. item.name, 'success')
        end
    end
end

-- Event to handle NPC looting
RegisterNetEvent('lootDeadNPC:server:loot', function(netId)
    local src = source
    local npc = NetworkGetEntityFromNetworkId(netId)
    local coords = GetEntityCoords(npc)

    if DoesEntityExist(npc) and IsEntityDead(npc) then
        GiveLoot(src)
        SetTimeout(Config.DespawnTime * 1000, function()
            DeleteEntity(npc)
            if Config.Debug then
                print("[DEBUG] NPC despawned: " .. netId.. "at "..coords)
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, "You can't loot this NPC.", 'error')
    end
end)