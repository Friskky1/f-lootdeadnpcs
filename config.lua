Config = Config or {}

-- Time (in seconds) before a looted NPC despawns
Config.DespawnTime = 60

-- Loot items (example items, customize as needed)
Config.LootItems = {
    { name = "water", amount = 1, chance = 50 }, -- 50% chance to get water
    { name = "bread", amount = 1, chance = 30 }, -- 30% chance to get bread
    { name = "cash", amount = 100, chance = 20 } -- 20% chance to get $100
}

-- Debug mode (prints debug messages in the console)
Config.Debug = true