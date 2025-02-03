Config = Config or {}

Config.LootedDespawnTime = 1 -- Time (in seconds) before a looted NPC despawns LOWER TIMES MEANS BETTER OPTIMIZATION

Config.LootNPCTime = 2 -- Time (in seconds) it takes to loot NPC

Config.LootItems = { -- Loot items (example items, customize as needed)
    { name = "water_bottle", amount = 1, chance = 50 }, -- 50% chance to get water
    { name = "sandwich", amount = 1, chance = 30 }, -- 30% chance to get bread
    { name = "cash", amount = math.random(50, 100), chance = 20 } -- 20% chance to get a random amount inbetween what you set
}

Config.Debug = true -- Debug mode (prints debug messages in the console)