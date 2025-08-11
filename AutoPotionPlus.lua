local f = CreateFrame("Frame")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

-- Define item lists globally
local bandages = {
    23684, -- Crystal Infused Bandage
    20234, -- Defiler's Runecloth Bandage
    20243, -- Highlander's Runecloth Bandage
    19066, -- Warsong Gulch Runecloth Bandage
    19307, -- Alterac Heavy Runecloth Bandage
    20066, -- Arathi Basin Runecloth Bandage
    14530, -- Heavy Runecloth Bandage
    14529, -- Runecloth Bandage
    20065, -- Arathi Basin Mageweave Bandage
    20237, -- Highlander's Mageweave Bandage
    20232, -- Defiler's Mageweave Bandage
    19067, -- Warsong Gulch Mageweave Bandage
    8545,  -- Heavy Mageweave Bandage
    8544,  -- Mageweave Bandage
    20067, -- Arathi Basin Silk Bandage
    20235, -- Defiler's Silk Bandage
    19068, -- Warsong Gulch Silk Bandage
    20244, -- Highlander's Silk Bandage
    6451,  -- Heavy Silk Bandage
    6450,  -- Silk Bandage
    3531,  -- Heavy Wool Bandage
    3530,  -- Wool Bandage
    2581,  -- Heavy Linen Bandage
    1251   -- Linen Bandage
}

local manaPotions = {
    18253, -- Major Rejuvenation Potion
    13444, -- Major Mana Potion
    17351, -- Major Mana Draught
    13443, -- Superior Mana Potion
    18841, -- Combat Mana Potion
    6149,  -- Greater Mana Potion
    17352, -- Superior Mana Draught
    3827,  -- Mana Potion
    3385,  -- Lesser Mana Potion
    1072,  -- Full Moonshine
    2455,  -- Minor Mana Potion
    3087,  -- Mug of Shimmer Stout
    2456   -- Minor Rejuvenation Potion
}

local healthstones = {
    9421,  -- Major Healthstone (Rank 5)
    5510,  -- Greater Healthstone (Rank 4)
    5509,  -- Healthstone (Rank 3)
    5511,  -- Lesser Healthstone (Rank 2)
    5512  -- Minor Healthstone (Rank 1)
}

local potions = {
    13446, -- Major Healing Potion
    17348, -- Major Healing Draught
    3928,  -- Superior Healing Potion
    17349, -- Superior Healing Draught
    11951, -- Whipper Root Tuber
    18839, -- Combat Healing Potion
    1710,  -- Greater Healing Potion
    929,   -- Healing Potion
    858,   -- Lesser Healing Potion
    4596,  -- Discolored Healing Potion
    118    -- Minor Healing Potion
}

-- Add these new item lists after the existing ones
local drinks = {
    8079,  -- Conjured Crystal Water
    18300, -- Hyjal Nectar
    8078,  -- Conjured Sparkling Water
    8766,  -- Morning Glory Dew
    8077,  -- Conjured Mineral Water
    19300, -- Bottled Winterspring Water
    1645,  -- Moonberry Juice
    3772,  -- Conjured Spring Water
    4791,  -- Enchanted Water
    1708,  -- Sweet Nectar
    10841, -- Goldthorn Tea
    2136,  -- Conjured Purified Water
    9451,  -- Bubbling Water
    1205,  -- Melon Juice
    19299, -- Fizzy Faire Drink
    2288,  -- Conjured Fresh Water
    17404, -- Blended Bean Brew
    1179,  -- Ice Cold Milk
    5350,  -- Conjured Water
    159,   -- Refreshing Spring Water
    1401   -- Green Tea Leaf
}

local foods = {
    21215, -- Graccu's Mince Meat Fruitcake
    21537, -- Festival Dumplings
    23172, -- Refreshing Red Apple
    21235, -- Winter Veil Roast
    21240, -- Winter Veil Candy
    21236, -- Winter Veil Loaf
    19696, -- Harvest Bread
    19996, -- Harvest Fish
    19995, -- Harvest Boar
    19994, -- Harvest Fruit
    19301, -- Alterac Manna Biscuit
    22895, -- Conjured Cinnamon Roll
    20031, -- Essence Mango
    13724, -- Enriched Manna Biscuit
    8076,  -- Conjured Sweet Roll
    11415, -- Mixed Berries
    8932,  -- Alterac Swiss
    13935, -- Baked Salmon
    8953,  -- Deep Fried Plantains
    8957,  -- Spinefin Halibut
    13933, -- Lobster Stew
    16171, -- Shinsollo
    12763, -- Un'Goro Etherfruit
    11444, -- Grim Guzzler Boar
    21031, -- Cabbage Kimchi
    21033, -- Radish Kimchi
    19225, -- Deep Fried Candybar
    22324, -- Winter Kimchi
    23160, -- Friendship Bread
    8950,  -- Homemade Cherry Pie
    8948,  -- Dried King Bolete
    8952,  -- Roasted Quail
    8075,  -- Conjured Sourdough
    4601,  -- Soft Banana Bread
    3927,  -- Fine Aged Cheddar
    13546, -- Bloodbelly Fish
    18255, -- Runn Tum Tuber
    13893, -- Large Raw Mightfish
    13930, -- Filet of Redgill
    9681,  -- Grilled King Crawler Legs
    21030, -- Darnassus Kimchi Pie
    18635, -- Bellara's Nutterbar
    4608,  -- Raw Black Truffle
    21552, -- Striped Yellowtail
    17408, -- Spicy Beefstick
    19306, -- Crunchy Frog
    16766, -- Undermine Clam Chowder
    16168, -- Heaven Peach
    4602,  -- Moon Harvest Pumpkin
    6887,  -- Spotted Yellowtail
    4599,  -- Cured Ham Steak
    1487,  -- Conjured Pumpernickel
    4544,  -- Mulgore Spice Bread
    13755, -- Winter Squid
    4539,  -- Goldenbark Apple
    17407, -- Graccu's Homemade Meat Pie
    8543,  -- Underwater Mushroom Cap
    19224, -- Red Hot Wings
    16169, -- Wild Ricecake
    18632, -- Moonbrook Riot Taffy
    6807,  -- Frog Leg Stew
    1707,  -- Stormwind Brie
    4607,  -- Delicious Cave Mold
    3771,  -- Wild Hog Shank
    4594,  -- Rockscale Cod
    8364,  -- Mithril Head Trout
    1114,  -- Conjured Rye
    4542,  -- Moist Cornbread
    4538,  -- Snapvine Watermelon
    3770,  -- Mutton Chop
    7228,  -- Tigule's Strawberry Ice Cream
    422,   -- Dwarven Mild
    5526,  -- Clam Chowder
    2685,  -- Succulent Pork Ribs
    19305, -- Pickled Kodo Foot
    1119,  -- Bottled Spirits
    733,   -- Westfall Stew
    5478,  -- Dig Rat Stew
    16170, -- Steamed Mandu
    4606,  -- Spongy Morel
    4593,  -- Bristle Whisker Catfish
    5473,  -- Scorpid Surprise
    3448,  -- Senggin Root
    2682,  -- Cooked Crab Claw
    1113,  -- Conjured Bread
    4541,  -- Freshly Baked Bread
    12238, -- Darkshore Grouper
    4537,  -- Tel'Abim Banana
    414,   -- Dalaran Sharp
    6316,  -- Loch Frenzy Delight
    18633, -- Styleen's Sour Suckerpop
    16167, -- Versicolor Treat
    17406, -- Holiday Cheesewheel
    19304, -- Spiced Beef Jerky
    1326,  -- Sauteed Sunfish
    17119, -- Deeprun Rat Kabob
    5066,  -- Fissure Plant
    4605,  -- Red-speckled Mushroom
    6890,  -- Smoked Bear Meat
    5095,  -- Rainbow Fin Albacore
    2287,  -- Haunch of Meat
    4592,  -- Longjaw Mud Snapper
    5349,  -- Conjured Muffin
    4540,  -- Tough Hunk of Bread
    4536,  -- Shiny Red Apple
    2681,  -- Roasted Boar Meat
    2679,  -- Charred Wolf Meat
    5057,  -- Ripe Watermelon
    117,   -- Tough Jerky
    787,   -- Slitherskin Mackerel
    6290,  -- Brilliant Smallfish
    17344, -- Candy Cane
    19223, -- Darkmoon Dog
    961,   -- Healing Herb
    4656,  -- Small Pumpkin
    7097,  -- Leg Meat
    2070,  -- Darnassian Bleu
    4604,  -- Forest Mushroom Cap
    16166, -- Bean Soup
    6299,  -- Sickly Looking Fish
    11109  -- Special Chicken Feed
}

local buffFoods = {
    21023, -- Dirge's Kickin' Chimaerok Chops
    20452, -- Smoked Desert Dumplings
    21254, -- Winter Veil Cookie
    20516, -- Bobbing Apple
    18254, -- Runn Tum Tuber Surprise
    13934, -- Mightfish Steak
    13810, -- Blessed Sunfruit
    18045, -- Tender Wolf Steak
    12215, -- Heavy Kodo Stew
    12216, -- Spiced Chili Crab
    12218, -- Monster Omelet
    17222, -- Spider Sausage
    16971, -- Clamlette Surprise
    13931, -- Nightfin Soup
    13928, -- Grilled Squid
    13929, -- Hot Smoked Bass
    4457,  -- Barbecued Buzzard Wing
    12214, -- Mystery Stew
    6038,  -- Giant Clam Scorcho
    12211, -- Spiced Wolf Ribs
    20074, -- Heavy Crocolisk Stew
    13851, -- Hot Wolf Ribs
    12213, -- Carrion Surprise
    13927, -- Cooked Glossy Mightfish
    12212, -- Jungle Stew
    3728,  -- Tasty Lion Steak
    3729,  -- Soothing Turtle Bisque
    12210, -- Roast Raptor
    13932, -- Poached Sunscale Salmon
    21217, -- Sagefish Delight
    3666,  -- Gooey Spider Cake
    5527,  -- Goblin Deviled Clams
    12209, -- Lean Wolf Steak
    1017,  -- Seasoned Wolf Kabob
    5479,  -- Crispy Lizard Tail
    1082,  -- Redridge Goulash
    5480,  -- Lean Venison
    3665,  -- Curiously Tasty Omelet
    3664,  -- Crocolisk Gumbo
    3727,  -- Hot Lion Chops
    3726,  -- Big Bear Steak
    3663,  -- Murloc Fin Soup
    21072, -- Smoked Sagefish
    724,   -- Goretusk Liver Pie
    5525,  -- Boiled Clams
    2684,  -- Coyote Steak
    5477,  -- Strider Stew
    3662,  -- Crocolisk Steak
    5476,  -- Fillet of Frenzy
    3220,  -- Blood Sausage
    2687,  -- Dry Pork Ribs
    2683,  -- Crab Cake
    6888,  -- Herb Baked Egg
    17197, -- Gingerbread Cookie
    7808,  -- Chocolate Square
    7807,  -- Candy Bar
    7806,  -- Lollipop
    5474,  -- Roasted Kodo Meat
    2888,  -- Beer Basted Boar Ribs
    11584, -- Cactus Apple Surprise
    5472,  -- Kaldorei Spider Kabob
    12224, -- Crispy Bat Wing
    17198, -- Egg Nog
    17199, -- Bad Egg Nog
    2680   -- Spiced Wolf Meat
}

-- Add these after the original item lists but before the defaults
local defaultLists = {
    ["Buff Foods"] = CopyTable(buffFoods),
    ["Regular Foods"] = CopyTable(foods),
    ["Drinks"] = CopyTable(drinks),
    ["Healing Potions"] = CopyTable(potions),
    ["Mana Potions"] = CopyTable(manaPotions),
    ["Bandages"] = CopyTable(bandages),
    ["Healthstones"] = CopyTable(healthstones)
}

-- Add after the existing global variables
local defaults = {
    useLowestHealing = false,
    useLowestMana = false,
    useLowestFood = false,
    useLowestDrink = false,
    useLowestBandage = false,
    warriorMode = false,
    useHealthstoneFirst = false,
    useAmountPriority = true, -- Choose least amount first when levels are same
    preferConjured = false, -- Always choose conjured food/drink first
    removedItems = {} -- Add this to track removed items
}

-- Add these variables after the existing item lists
local itemCategories = {
    "Buff Foods",
    "Regular Foods",
    "Drinks",
    "Healing Potions",
    "Mana Potions",
    "Bandages",
    "Healthstones"
}

local categoryToList = {
    ["Buff Foods"] = buffFoods,
    ["Regular Foods"] = foods,
    ["Drinks"] = drinks,
    ["Healing Potions"] = potions,
    ["Mana Potions"] = manaPotions,
    ["Bandages"] = bandages,
    ["Healthstones"] = healthstones
}

-- Add after the defaults table
local minimapDefaults = {
    minimapPos = 225 -- Default angle position (moved to bottom-left to avoid sun icon)
}

-- Add this variable to track the currently selected category
local currentSelectedCategory = "Buff Foods" -- Default category

-- Add variables for item selection and drag tracking
local selectedItemIndex = nil
local selectedItemId = nil
local dragSourceIndex = nil  -- The index of the item we want to move
local isReorderMode = false  -- Whether we're currently in reorder mode

-- Add this variable at the top with other globals
local frameRetryCount = 0
local MAX_RETRIES = 5

-- Add this variable near other global variables
local pendingItemCount = 0
local itemCacheFrame = CreateFrame("Frame")
itemCacheFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")

-- Add debug logging system
local DEBUG_MODE = false -- Disabled chat debug by default
local debugLog = {}

-- Add this variable near other global variables
local debugLogEditBox = nil

local function LogDebug(message)
    if DEBUG_MODE then
        table.insert(debugLog, message)
        print("AutoPotionPlus: " .. message)
    else
        -- Still add to debug log for UI, just don't print to chat
        table.insert(debugLog, message)
    end
end

local function SaveDebugLogToSavedVariables()
    local log = table.concat(debugLog, "\n")
    if log == "" then
        print("AutoPotionPlus: No debug log available to save.")
        return
    end
    
    -- Save to SavedVariables
    if not AutoPotionPlusDebugLogs then
        AutoPotionPlusDebugLogs = {}
    end
    
    local timestamp = date("%Y-%m-%d_%H-%M-%S")
    AutoPotionPlusDebugLogs[timestamp] = log
    
    -- Keep only last 5 logs to avoid bloat
    local count = 0
    for _ in pairs(AutoPotionPlusDebugLogs) do
        count = count + 1
    end
    
    if count > 5 then
        -- Remove oldest logs
        local timestamps = {}
        for ts in pairs(AutoPotionPlusDebugLogs) do
            table.insert(timestamps, ts)
        end
        table.sort(timestamps)
        
        for i = 1, count - 5 do
            AutoPotionPlusDebugLogs[timestamps[i]] = nil
        end
    end
    
    -- Force save to disk
    if SaveVariablesPerCharacter then
        SaveVariablesPerCharacter("AutoPotionPlus")
    end
    
    print("AutoPotionPlus: Debug log saved to SavedVariables with timestamp: " .. timestamp)
    print("AutoPotionPlus: Use /appshowlog " .. timestamp .. " to view it")
    print("AutoPotionPlus: Use /appexport " .. timestamp .. " to export it")
end

-- Add debug slash command
SLASH_AUTOPOTIONDEBUGLOG1 = "/appdebuglog"
SlashCmdList["AUTOPOTIONDEBUGLOG"] = function()
    local log = table.concat(debugLog, "\n")
    if log == "" then
        print("AutoPotionPlus: No debug log available. Try using the addon first.")
    else
        print("AutoPotionPlus: Debug log copied to chat:")
        print(log)
        SaveDebugLogToSavedVariables()
        debugLog = {} -- Clear log after saving
    end
end

-- Add command to show saved logs
SLASH_AUTOPOTIONSHOWLOG1 = "/appshowlog"
SlashCmdList["AUTOPOTIONSHOWLOG"] = function(msg)
    if not AutoPotionPlusDebugLogs then
        print("AutoPotionPlus: No saved debug logs found.")
        return
    end
    
    if msg == "" then
        -- Show list of available logs
        print("AutoPotionPlus: Available debug logs:")
        for timestamp in pairs(AutoPotionPlusDebugLogs) do
            print("  " .. timestamp)
        end
        print("AutoPotionPlus: Use /appshowlog TIMESTAMP to view a specific log")
        print("AutoPotionPlus: Use /appexport TIMESTAMP to export a log for copying")
    else
        -- Show specific log
        if AutoPotionPlusDebugLogs[msg] then
            print("AutoPotionPlus: Debug log for " .. msg .. ":")
            print(AutoPotionPlusDebugLogs[msg])
        else
            print("AutoPotionPlus: Debug log not found for timestamp: " .. msg)
        end
    end
end

-- Add command to clear saved logs
SLASH_AUTOPOTIONCLEARLOGS1 = "/appclearlogs"
SlashCmdList["AUTOPOTIONCLEARLOGS"] = function()
    AutoPotionPlusDebugLogs = {}
    print("AutoPotionPlus: All saved debug logs cleared.")
end

-- Add separate command to just save without clearing
SLASH_AUTOPOTIONSAVELOG1 = "/appsave"
SlashCmdList["AUTOPOTIONSAVELOG"] = function()
    SaveDebugLogToSavedVariables()
end

-- Add command to export logs to chat in a copyable format
SLASH_AUTOPOTIONEXPORTLOG1 = "/appexport"
SlashCmdList["AUTOPOTIONEXPORTLOG"] = function(msg)
    if not AutoPotionPlusDebugLogs then
        print("AutoPotionPlus: No saved debug logs found.")
        return
    end
    
    if msg == "" then
        -- Show list of available logs
        print("AutoPotionPlus: Available debug logs:")
        for timestamp in pairs(AutoPotionPlusDebugLogs) do
            print("  " .. timestamp)
        end
        print("AutoPotionPlus: Use /appexport TIMESTAMP to export a specific log")
    else
        -- Export specific log
        if AutoPotionPlusDebugLogs[msg] then
            print("AutoPotionPlus: === EXPORTING DEBUG LOG ===")
            print("Timestamp: " .. msg)
            print("=== START LOG ===")
            print(AutoPotionPlusDebugLogs[msg])
            print("=== END LOG ===")
            print("AutoPotionPlus: Copy the log above and paste it into a text file")
        else
            print("AutoPotionPlus: Debug log not found for timestamp: " .. msg)
        end
    end
end

-- Add command to show SavedVariables location
SLASH_AUTOPOTIONLOCATION1 = "/applocation"
SlashCmdList["AUTOPOTIONLOCATION"] = function()
    local charName = UnitName("player")
    local realmName = GetRealmName()
    local accountName = GetRealmName() -- This might not work in Classic, but worth trying
    
    print("AutoPotionPlus: SavedVariables location:")
    print("World of Warcraft\\_classic_era_\\WTF\\Account\\[AccountName]\\[Realm]\\[Character]\\SavedVariables\\AutoPotionPlus.lua")
    print("Character: " .. charName)
    print("Realm: " .. realmName)
    print("AutoPotionPlus: Use /appexport TIMESTAMP to get logs in a copyable format")
end

-- Helper functions and data management functions
local function GetCharacterKey()
    local name = UnitName("player")
    local realm = GetRealmName()
    return name .. "-" .. realm
end

local function SaveItemLists()
    local charKey = GetCharacterKey()
    if not AutoPotionPlusDB then
        AutoPotionPlusDB = {}
    end
    if not AutoPotionPlusDB[charKey] then
        AutoPotionPlusDB[charKey] = {}
    end
    if not AutoPotionPlusDB[charKey].itemLists then
        AutoPotionPlusDB[charKey].itemLists = {}
    end
    if not AutoPotionPlusDB[charKey].removedItems then
        AutoPotionPlusDB[charKey].removedItems = {}
    end
    
    for category, list in pairs(categoryToList) do
        AutoPotionPlusDB[charKey].itemLists[category] = CopyTable(list)
    end
end

local function LoadItemLists()
    local charKey = GetCharacterKey()
    if not AutoPotionPlusDB then
        AutoPotionPlusDB = {}
    end
    if not AutoPotionPlusDB[charKey] then
        AutoPotionPlusDB[charKey] = {}
    end
    -- Initialize removedItems if it doesn't exist
    if not AutoPotionPlusDB[charKey].removedItems then
        AutoPotionPlusDB[charKey].removedItems = {}
    end

    if AutoPotionPlusDB[charKey].itemLists then
        for category, savedList in pairs(AutoPotionPlusDB[charKey].itemLists) do
            if categoryToList[category] then
                -- Start with default items, but filter out removed ones
                local newList = {}
                for _, id in ipairs(categoryToList[category]) do
                    if not AutoPotionPlusDB[charKey].removedItems[id] then
                        table.insert(newList, id)
                    end
                end
                
                -- Add saved custom items
                for _, id in ipairs(savedList) do
                    if not AutoPotionPlusDB[charKey].removedItems[id] then
                        local found = false
                        for _, existingId in ipairs(newList) do
                            if existingId == id then
                                found = true
                                break
                            end
                        end
                        if not found then
                            table.insert(newList, id)
                        end
                    end
                end
                
                -- Replace the category list with the filtered one
                categoryToList[category] = newList
            end
        end
    end
end

local function InitializeSettings()
    local charKey = GetCharacterKey()
    if not AutoPotionPlusDB then
        AutoPotionPlusDB = {}
    end
    if not AutoPotionPlusDB[charKey] then
        AutoPotionPlusDB[charKey] = CopyTable(defaults)
    end
    -- Ensure removedItems exists
    if AutoPotionPlusDB[charKey].removedItems == nil then
        AutoPotionPlusDB[charKey].removedItems = {}
    end
    -- Add minimap position if it doesn't exist
    if AutoPotionPlusDB[charKey].minimapPos == nil then
        AutoPotionPlusDB[charKey].minimapPos = minimapDefaults.minimapPos
    end
end

-- Function to get item level (quality)
local function GetItemLevel(itemId)
    local itemName, _, _, itemLevel = GetItemInfo(itemId)
    if itemName then
        return itemLevel or 0
    end
    return 0
end

local function FindFirstItem(itemList, useLowest)
    local availableItems = {}
    
    -- Collect all available items with their counts and levels
    for i, itemId in ipairs(itemList) do
        local count = GetItemCount(itemId)
        if count > 0 then
            local itemName = GetItemInfo(itemId)
            local itemLevel = GetItemLevel(itemId)
            
            -- Handle nil item names (uncached items)
            if not itemName then
                itemName = "Item " .. itemId
            end
            
            table.insert(availableItems, {
                id = itemId, 
                count = count, 
                index = i, 
                name = itemName,
                level = itemLevel
            })
        end
    end
    
    if #availableItems == 0 then
        return nil
    end
    
    -- Sort by level first (respecting useLowest setting)
    table.sort(availableItems, function(a, b)
        if a.level == b.level then
            -- Same level, use original order (don't consider amount)
            if useLowest then
                return a.index > b.index
            else
                return a.index < b.index
            end
        else
            -- Different levels, sort by level
            if useLowest then
                return a.level < b.level  -- Lower level first
            else
                return a.level > b.level  -- Higher level first
            end
        end
    end)
    
    -- Return the first item after sorting
    return availableItems[1].id
end

-- New function to find items with least amount first when levels are same
local function FindFirstItemByAmount(itemList, useLowest)
    local availableItems = {}
    
    LogDebug("=== Starting FindFirstItemByAmount ===")
    LogDebug("useLowest: " .. tostring(useLowest))
    
    -- Collect all available items with their counts and levels
    for i, itemId in ipairs(itemList) do
        local count = GetItemCount(itemId)
        if count > 0 then
            local itemName = GetItemInfo(itemId)
            local itemLevel = GetItemLevel(itemId)
            
            -- Handle nil item names (uncached items)
            if not itemName then
                itemName = "Item " .. itemId
                LogDebug("Item " .. itemId .. " not cached yet, using fallback name")
            end
            
            table.insert(availableItems, {
                id = itemId, 
                count = count, 
                index = i, 
                name = itemName,
                level = itemLevel
            })
            LogDebug("Available: " .. itemName .. " (Level " .. itemLevel .. ", x" .. count .. ", index " .. i .. ")")
        end
    end
    
    if #availableItems == 0 then
        LogDebug("No available items found")
        return nil
    end
    
    -- First, sort by level (respecting useLowest setting)
    table.sort(availableItems, function(a, b)
        if a.level == b.level then
            -- Same level, use original order
            if useLowest then
                return a.index > b.index
            else
                return a.index < b.index
            end
        else
            -- Different levels, sort by level
            if useLowest then
                return a.level < b.level  -- Lower level first
            else
                return a.level > b.level  -- Higher level first
            end
        end
    end)
    
    LogDebug("After level sorting:")
    for i, item in ipairs(availableItems) do
        LogDebug("  " .. i .. ". " .. item.name .. " (Level " .. item.level .. ", x" .. item.count .. ")")
    end
    
    -- Find the best level items (first item after sorting)
    local bestLevel = availableItems[1].level
    local sameLevelItems = {}
    
    for _, item in ipairs(availableItems) do
        if item.level == bestLevel then
            table.insert(sameLevelItems, item)
        else
            break -- Stop when we hit a different level
        end
    end
    
    LogDebug("Items at level " .. bestLevel .. ":")
    for i, item in ipairs(sameLevelItems) do
        LogDebug("  " .. i .. ". " .. item.name .. " (x" .. item.count .. ")")
    end
    
    -- If we have multiple items at the same level, sort by amount
    if #sameLevelItems > 1 then
        table.sort(sameLevelItems, function(a, b)
            if a.count == b.count then
                return a.index < b.index  -- If same amount, use original order
            else
                return a.count < b.count  -- Sort by amount (ascending)
            end
        end)
        
        LogDebug("After amount sorting within level " .. bestLevel .. ":")
        for i, item in ipairs(sameLevelItems) do
            LogDebug("  " .. i .. ". " .. item.name .. " (x" .. item.count .. ")")
        end
    end
    
    local selectedItem = sameLevelItems[1]
    LogDebug("Selected: " .. selectedItem.name .. " (Level " .. selectedItem.level .. ", x" .. selectedItem.count .. ")")
    LogDebug("=== End FindFirstItemByAmount ===")
    
    return selectedItem.id
end

-- New function to find items with most amount first when levels are same (for when amount priority is disabled)
local function FindFirstItemByAmountReverse(itemList, useLowest)
    local availableItems = {}
    
    LogDebug("=== Starting FindFirstItemByAmountReverse ===")
    LogDebug("useLowest: " .. tostring(useLowest))
    
    -- Collect all available items with their counts and levels
    for i, itemId in ipairs(itemList) do
        local count = GetItemCount(itemId)
        if count > 0 then
            local itemName = GetItemInfo(itemId)
            local itemLevel = GetItemLevel(itemId)
            
            -- Handle nil item names (uncached items)
            if not itemName then
                itemName = "Item " .. itemId
                LogDebug("Item " .. itemId .. " not cached yet, using fallback name")
            end
            
            table.insert(availableItems, {
                id = itemId, 
                count = count, 
                index = i, 
                name = itemName,
                level = itemLevel
            })
            LogDebug("Available: " .. itemName .. " (Level " .. itemLevel .. ", x" .. count .. ", index " .. i .. ")")
        end
    end
    
    if #availableItems == 0 then
        LogDebug("No available items found")
        return nil
    end
    
    -- First, sort by level (respecting useLowest setting)
    table.sort(availableItems, function(a, b)
        if a.level == b.level then
            -- Same level, use original order
            if useLowest then
                return a.index > b.index
            else
                return a.index < b.index
            end
        else
            -- Different levels, sort by level
            if useLowest then
                return a.level < b.level  -- Lower level first
            else
                return a.level > b.level  -- Higher level first
            end
        end
    end)
    
    LogDebug("After level sorting:")
    for i, item in ipairs(availableItems) do
        LogDebug("  " .. i .. ". " .. item.name .. " (Level " .. item.level .. ", x" .. item.count .. ")")
    end
    
    -- Find the best level items (first item after sorting)
    local bestLevel = availableItems[1].level
    local sameLevelItems = {}
    
    for _, item in ipairs(availableItems) do
        if item.level == bestLevel then
            table.insert(sameLevelItems, item)
        else
            break -- Stop when we hit a different level
        end
    end
    
    LogDebug("Items at level " .. bestLevel .. ":")
    for i, item in ipairs(sameLevelItems) do
        LogDebug("  " .. i .. ". " .. item.name .. " (x" .. item.count .. ")")
    end
    
    -- If we have multiple items at the same level, sort by amount (MOST first)
    if #sameLevelItems > 1 then
        table.sort(sameLevelItems, function(a, b)
            if a.count == b.count then
                return a.index < b.index  -- If same amount, use original order
            else
                return a.count > b.count  -- Sort by amount (descending - most first)
            end
        end)
        
        LogDebug("After amount sorting within level " .. bestLevel .. " (most first):")
        for i, item in ipairs(sameLevelItems) do
            LogDebug("  " .. i .. ". " .. item.name .. " (x" .. item.count .. ")")
        end
    end
    
    local selectedItem = sameLevelItems[1]
    LogDebug("Selected: " .. selectedItem.name .. " (Level " .. selectedItem.level .. ", x" .. selectedItem.count .. ")")
    LogDebug("=== End FindFirstItemByAmountReverse ===")
    
    return selectedItem.id
end

-- New function to find conjured items first
local function FindConjuredItemFirst(itemList, useLowest)
    local conjuredItems = {}
    local regularItems = {}
    
    LogDebug("=== Starting FindConjuredItemFirst ===")
    LogDebug("useLowest: " .. tostring(useLowest))
    
    -- Separate conjured and regular items
    for i, itemId in ipairs(itemList) do
        local count = GetItemCount(itemId)
        if count > 0 then
            local itemName = GetItemInfo(itemId)
            local itemLevel = GetItemLevel(itemId)
            
            -- Handle nil item names (uncached items)
            if not itemName then
                itemName = "Item " .. itemId
                LogDebug("Item " .. itemId .. " not cached yet, using fallback name")
            end
            
            if itemName then
                -- More precise conjured item detection
                local isConjured = string.find(string.lower(itemName), "^conjured ")
                if isConjured then
                    table.insert(conjuredItems, {id = itemId, count = count, index = i, name = itemName, level = itemLevel})
                    LogDebug("Conjured: " .. itemName .. " (Level " .. itemLevel .. ", x" .. count .. ")")
                else
                    table.insert(regularItems, {id = itemId, count = count, index = i, name = itemName, level = itemLevel})
                    LogDebug("Regular: " .. itemName .. " (Level " .. itemLevel .. ", x" .. count .. ")")
                end
            end
        end
    end
    
    -- Sort conjured items by level first, then by amount
    table.sort(conjuredItems, function(a, b)
        if a.level == b.level then
            if a.count == b.count then
                if useLowest then
                    return a.index > b.index
                else
                    return a.index < b.index
                end
            else
                return a.count < b.count  -- Sort by amount (ascending)
            end
        else
            if useLowest then
                return a.level < b.level  -- Lower level first
            else
                return a.level > b.level  -- Higher level first
            end
        end
    end)
    
    -- Sort regular items by level first, then by amount
    table.sort(regularItems, function(a, b)
        if a.level == b.level then
            if a.count == b.count then
                if useLowest then
                    return a.index > b.index
                else
                    return a.index < b.index
                end
            else
                return a.count < b.count  -- Sort by amount (ascending)
            end
        else
            if useLowest then
                return a.level < b.level  -- Lower level first
            else
                return a.level > b.level  -- Higher level first
            end
        end
    end)
    
    LogDebug("Conjured items after sorting:")
    for i, item in ipairs(conjuredItems) do
        LogDebug("  " .. i .. ". " .. item.name .. " (Level " .. item.level .. ", x" .. item.count .. ")")
    end
    
    LogDebug("Regular items after sorting:")
    for i, item in ipairs(regularItems) do
        LogDebug("  " .. i .. ". " .. item.name .. " (Level " .. item.level .. ", x" .. item.count .. ")")
    end
    
    -- Return conjured item first if available, otherwise regular item
    if #conjuredItems > 0 then
        LogDebug("Selected conjured: " .. conjuredItems[1].name .. " (Level " .. conjuredItems[1].level .. ", x" .. conjuredItems[1].count .. ")")
        LogDebug("=== End FindConjuredItemFirst ===")
        return conjuredItems[1].id
    elseif #regularItems > 0 then
        LogDebug("Selected regular: " .. regularItems[1].name .. " (Level " .. regularItems[1].level .. ", x" .. regularItems[1].count .. ")")
        LogDebug("=== End FindConjuredItemFirst ===")
        return regularItems[1].id
    end
    
    LogDebug("No items available")
    LogDebug("=== End FindConjuredItemFirst ===")
    return nil
end

-- Then define UpdateMacro and UpdateFoodMacro
local function UpdateMacro()
    -- Check if settings are initialized
    if not AutoPotionPlusDB then
        AutoPotionPlusDB = {}
    end
    local charKey = GetCharacterKey()
    if not AutoPotionPlusDB[charKey] then
        AutoPotionPlusDB[charKey] = CopyTable(defaults)
    end

    -- Build lists of available items using new logic
    local bandageItem
    local manaItem
    local healItem
    
    -- Use appropriate item finding function based on settings
    if AutoPotionPlusDB[charKey].useAmountPriority then
        bandageItem = FindFirstItemByAmount(bandages, AutoPotionPlusDB[charKey].useLowestBandage)
        manaItem = FindFirstItemByAmount(manaPotions, AutoPotionPlusDB[charKey].useLowestMana)
    else
        bandageItem = FindFirstItem(bandages, AutoPotionPlusDB[charKey].useLowestBandage)
        manaItem = FindFirstItem(manaPotions, AutoPotionPlusDB[charKey].useLowestMana)
    end
    
    -- Changed healthstone logic
    if AutoPotionPlusDB[charKey].useHealthstoneFirst then
        -- If checkbox is checked, try healthstone first, then fallback to potion
        healItem = FindFirstItem(healthstones, false) or FindFirstItem(potions, AutoPotionPlusDB[charKey].useLowestHealing)
    else
        -- If checkbox is unchecked, try potion first, then fallback to healthstone
        healItem = FindFirstItem(potions, AutoPotionPlusDB[charKey].useLowestHealing) or FindFirstItem(healthstones, false)
    end
    
    -- Set appropriate defaults for each category
    local bandagesList = bandageItem and "item:" .. bandageItem or "item:1251" -- Default to Linen Bandage
    local manaList = manaItem and "item:" .. manaItem or "item:2455" -- Default to Minor Mana Potion
    local healList = healItem and "item:" .. healItem or "item:118" -- Default to Minor Healing Potion

    -- Create macro with conditionals
    local macroText = string.format(
        "#showtooltip [mod:shift] %s; [mod:ctrl] %s; %s\n/use [mod:shift] %s; [mod:ctrl] %s; %s",
        bandagesList, manaList, healList,
        bandagesList, manaList, healList
    )

    -- Update the macro
    local macroId = GetMacroIndexByName("AutoPotionPlus")
    if macroId > 0 then
        EditMacro(macroId, nil, nil, macroText)
    end
end

local function UpdateFoodMacro()
    -- Check if settings are initialized
    if not AutoPotionPlusDB then
        AutoPotionPlusDB = {}
    end
    local charKey = GetCharacterKey()
    if not AutoPotionPlusDB[charKey] then
        AutoPotionPlusDB[charKey] = CopyTable(defaults)
    end

    -- Get items from the current lists using appropriate logic
    local drinkItem
    local foodItem
    local buffFoodItem
    
    if AutoPotionPlusDB[charKey].preferConjured then
        -- Use conjured item preference
        drinkItem = FindConjuredItemFirst(categoryToList["Drinks"], AutoPotionPlusDB[charKey].useLowestDrink)
        foodItem = FindConjuredItemFirst(categoryToList["Regular Foods"], AutoPotionPlusDB[charKey].useLowestFood)
        buffFoodItem = FindConjuredItemFirst(categoryToList["Buff Foods"], AutoPotionPlusDB[charKey].useLowestFood)
    elseif AutoPotionPlusDB[charKey].useAmountPriority then
        -- Use amount priority (least amount first)
        drinkItem = FindFirstItemByAmount(categoryToList["Drinks"], AutoPotionPlusDB[charKey].useLowestDrink)
        foodItem = FindFirstItemByAmount(categoryToList["Regular Foods"], AutoPotionPlusDB[charKey].useLowestFood)
        buffFoodItem = FindFirstItemByAmount(categoryToList["Buff Foods"], AutoPotionPlusDB[charKey].useLowestFood)
    else
        -- Use reverse amount priority (most amount first)
        drinkItem = FindFirstItemByAmountReverse(categoryToList["Drinks"], AutoPotionPlusDB[charKey].useLowestDrink)
        foodItem = FindFirstItemByAmountReverse(categoryToList["Regular Foods"], AutoPotionPlusDB[charKey].useLowestFood)
        buffFoodItem = FindFirstItemByAmountReverse(categoryToList["Buff Foods"], AutoPotionPlusDB[charKey].useLowestFood)
    end
    
    -- Set appropriate defaults for each category
    local drinkList = drinkItem and "item:" .. drinkItem or "item:159" -- Default to Spring Water
    local foodList = foodItem and "item:" .. foodItem or "item:4536" -- Default to Apple
    local buffFoodList = buffFoodItem and "item:" .. buffFoodItem or foodList

    local macroText
    if AutoPotionPlusDB[charKey].warriorMode then
        -- Warrior mode: Food without modifier, drinks with shift
        macroText = string.format(
            "#showtooltip [mod:ctrl] %s; [mod:shift] %s; %s\n/use [mod:ctrl] %s; [mod:shift] %s; %s",
            buffFoodList, drinkList, foodList,
            buffFoodList, drinkList, foodList
        )
    else
        -- Normal mode: Drinks without modifier, food with shift
        macroText = string.format(
            "#showtooltip [mod:ctrl] %s; [mod:shift] %s; %s\n/use [mod:ctrl] %s; [mod:shift] %s; %s",
            buffFoodList, foodList, drinkList,
            buffFoodList, foodList, drinkList
        )
    end

    -- Update the macro
    local macroId = GetMacroIndexByName("AutoFoodPlus")
    if macroId > 0 then
        EditMacro(macroId, nil, nil, macroText)
    end
end

-- Then define the item list management functions
local function UpdateItemListDisplay(category, forceFull)
    -- The correct frame path includes "Scroll" parent frame
    local scrollFrame = _G["AutoPotionPlusItemListManagerItemListScroll"]
    local frame = nil
    
    -- Check if the scroll frame exists and try to get its scroll child
    if scrollFrame then
        frame = scrollFrame:GetScrollChild()
    end
    
    -- If we still don't have a valid frame
    if not frame then
        frameRetryCount = frameRetryCount + 1
        if frameRetryCount <= MAX_RETRIES then
            C_Timer.After(1, function() 
                UpdateItemListDisplay(category)
            end)
        else
            -- Reset retry count for next time
            frameRetryCount = 0
        end
        return
    end
    
    -- Reset retry count when successful
    frameRetryCount = 0
    
    local list = categoryToList[category]
    
    -- Clear existing items
    if frame.buttons then
        for _, button in pairs(frame.buttons) do
            button:Hide()
            button:SetParent(nil)
        end
    end
    frame.buttons = {}
    
    if list then
        local BUTTON_HEIGHT = 20
        local BUTTON_SPACING = 2
        local ICON_SIZE = 16
        local PADDING = 8
        local TEXT_PADDING = 5
        
        -- Adjust scroll frame width to account for the WoW scrollbar (16px)
        local frameWidth = scrollFrame:GetWidth() - 16
        
        -- Reset pending item count at the start of a full refresh
        if forceFull then
            pendingItemCount = 0
        end
        
        local displayedCount = 0
        
        for i, itemId in ipairs(list) do
            local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemId)
            
            if not itemName and not forceFull then
                -- Item not in cache, request it and increment pending count
                pendingItemCount = pendingItemCount + 1
                GameTooltip:SetHyperlink("item:" .. itemId)
                GameTooltip:Hide()
            elseif itemName then
                -- Only increment displayed count for items actually shown
                displayedCount = displayedCount + 1
                
                -- Create a button for the whole row
                local button = CreateFrame("Button", frame:GetName().."Item"..displayedCount, frame)
                frame.buttons[displayedCount] = button
                button:SetSize(frameWidth, BUTTON_HEIGHT)
                button:SetPoint("TOPLEFT", PADDING, -(PADDING + (displayedCount-1) * (BUTTON_HEIGHT + BUTTON_SPACING)))
                
                -- Create a background that shows when highlighted
                local bg = button:CreateTexture(nil, "BACKGROUND")
                bg:SetAllPoints()
                bg:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
                bg:SetBlendMode("ADD")
                bg:SetAlpha(0)
                button.bg = bg
                
                -- Set appropriate highlight based on selection/drag state
                if isReorderMode and i == dragSourceIndex then
                    -- This is the item being moved
                    bg:SetAlpha(1.0)
                    button:SetAlpha(0.7)  -- Make it partially transparent to indicate being moved
                elseif itemId == selectedItemId then
                    -- This is the selected item (but not being moved)
                    bg:SetAlpha(0.5)
                elseif isReorderMode then
                    -- All items are potential drop targets in reorder mode
                    bg:SetAlpha(0.2)
                end
                
                -- Create the item icon
                local icon = button:CreateTexture(nil, "ARTWORK")
                icon:SetSize(ICON_SIZE, ICON_SIZE)
                icon:SetPoint("LEFT", 0, 0)
                icon:SetTexture(itemTexture)
                icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- Trim the icon borders
                
                -- Create a text for the item name
                local text = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                text:SetPoint("LEFT", icon, "RIGHT", TEXT_PADDING, 0)
                text:SetJustifyH("LEFT")
                
                -- Limit item name to 20 characters
                local displayName = itemName
                if string.len(displayName) > 20 then
                    displayName = string.sub(displayName, 1, 17) .. "..."
                end
                text:SetText(displayName)
                
                -- Create a hidden move indicator that will only show on hover when in reorder mode
                local moveTextBg = button:CreateTexture(nil, "OVERLAY")
                moveTextBg:SetPoint("RIGHT", -5, 0)
                moveTextBg:SetSize(60, 18)  -- Reduced width from 80 to 50 pixels
                moveTextBg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
                
                -- Set dark background color with client version compatibility
                if moveTextBg.SetColorTexture then
                    moveTextBg:SetColorTexture(0.1, 0.1, 0.1, 0.9)  -- Very dark background
                else
                    moveTextBg:SetTexture(0.1, 0.1, 0.1, 0.9)  -- Fallback for older clients
                end
                
                moveTextBg:Hide()
                button.moveTextBg = moveTextBg
                
                local moveText = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                moveText:SetPoint("RIGHT", moveTextBg, "RIGHT", -5, 0)
                moveText:SetText(">> Move")
                moveText:SetTextColor(1, 0.82, 0)
                moveText:Hide()  -- Hide by default, only show on hover
                button.moveText = moveText
                
                -- Store item data on the button for reference
                button.itemId = itemId
                button.itemIndex = i
                button.itemLink = itemLink
                button.itemName = itemName
                button.itemTexture = itemTexture
                
                -- Handle mouse events
                button:SetScript("OnEnter", function(self)
                    -- Don't change highlight if this is the source of a move
                    if not (isReorderMode and self.itemIndex == dragSourceIndex) then
                        self.bg:SetAlpha(0.7)
                    end
                    
                    -- Show move text if in reorder mode and this isn't the source item
                    if isReorderMode and self.itemIndex ~= dragSourceIndex then
                        self.moveTextBg:Show()
                        self.moveText:Show()
                    end
                    
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(self.itemLink)
                    GameTooltip:AddLine(" ")
                    
                    if isReorderMode then
                        if self.itemIndex == dragSourceIndex then
                            GameTooltip:AddLine("Click another item to move here", 1, 0.82, 0)
                            GameTooltip:AddLine("Click this item again to cancel", 1, 0.82, 0)
                        else
                            GameTooltip:AddLine("Click to place the selected item here", 1, 0.82, 0)
                        end
                    else
                        GameTooltip:AddLine("Shift-click to reorder", 1, 0.82, 0)
                        GameTooltip:AddLine("Right-click to remove", 1, 0.82, 0)
                    end
                    
                    GameTooltip:Show()
                end)
                
                button:SetScript("OnLeave", function(self)
                    -- Restore appropriate highlight state
                    if isReorderMode and self.itemIndex == dragSourceIndex then
                        self.bg:SetAlpha(1.0)  -- Keep full highlight for drag source
                    elseif self.itemId == selectedItemId then
                        self.bg:SetAlpha(0.5)  -- Keep selected highlight
                    elseif isReorderMode then
                        self.bg:SetAlpha(0.2)  -- Keep potential drop target highlight
                    else
                        self.bg:SetAlpha(0)    -- No highlight
                    end
                    
                    -- Hide move text and background on mouseout
                    if self.moveText then
                        self.moveText:Hide()
                    end
                    if self.moveTextBg then
                        self.moveTextBg:Hide()
                    end
                    
                    GameTooltip:Hide()
                end)
                
                -- Handle clicks
                button:RegisterForClicks("AnyUp")
                button:SetScript("OnClick", function(self, mouseButton, down, ...)
                    local modifier = IsShiftKeyDown()
                    
                    -- Handle right-click (remove item)
                    if mouseButton == "RightButton" then
                        -- Exit reorder mode if active
                        if isReorderMode then
                            isReorderMode = false
                            dragSourceIndex = nil
                            UpdateItemListDisplay(category, true)
                            return
                        end
                        
                        -- Get character key locally to fix the nil error
                        local charKeyLocal = GetCharacterKey()
                        
                        -- Add item to removed items list
                        if not AutoPotionPlusDB[charKeyLocal].removedItems then
                            AutoPotionPlusDB[charKeyLocal].removedItems = {}
                        end
                        AutoPotionPlusDB[charKeyLocal].removedItems[self.itemId] = true
                        
                        -- Clear selection if removing selected item
                        if self.itemId == selectedItemId then
                            selectedItemId = nil
                            selectedItemIndex = nil
                        end
                        
                        -- Remove item from current list
                        for idx, id in ipairs(list) do
                            if id == self.itemId then
                                table.remove(list, idx)
                                break
                            end
                        end
                        
                        -- Save changes and update
                        SaveItemLists()
                        UpdateItemListDisplay(category, true)
                        UpdateMacro()
                        UpdateFoodMacro()
                        return
                    end
                    
                    -- Handle left-click
                    if mouseButton == "LeftButton" then
                        -- If we're in reorder mode...
                        if isReorderMode then
                            if self.itemIndex == dragSourceIndex then
                                -- Clicked the same item again, cancel reorder
                                isReorderMode = false
                                dragSourceIndex = nil
                            else
                                -- Clicked a different item, move the source item here
                                local fromIndex = dragSourceIndex
                                local toIndex = self.itemIndex
                                local itemId = list[fromIndex]
                                
                                -- Remove from original position
                                table.remove(list, fromIndex)
                                
                                -- Insert at new position
                                table.insert(list, toIndex, itemId)
                                
                                -- Exit reorder mode
                                isReorderMode = false
                                dragSourceIndex = nil
                                
                                -- Save and update
                                SaveItemLists()
                                
                                -- Update macros if needed
                                if currentSelectedCategory == "Buff Foods" or
                                   currentSelectedCategory == "Regular Foods" or
                                   currentSelectedCategory == "Drinks" then
                                    UpdateFoodMacro()
                                end
                                UpdateMacro()
                            end
                            
                            -- Refresh display after reorder action
                            UpdateItemListDisplay(category, true)
                        else
                            -- Normal click - either select or enter reorder mode
                            if modifier then
                                -- Shift+click initiates a move
                                isReorderMode = true
                                dragSourceIndex = self.itemIndex
                                selectedItemId = self.itemId
                                selectedItemIndex = self.itemIndex
                            else
                                -- Regular click just selects
                                selectedItemId = self.itemId
                                selectedItemIndex = self.itemIndex
                                isReorderMode = false
                                dragSourceIndex = nil
                            end
                            
                            -- Refresh display to show selection/reorder state
                            UpdateItemListDisplay(category, true)
                        end
                    end
                end)
            end
        end
        
        -- Dynamically set the scroll child height based on number of items
        local totalHeight = PADDING * 2 + displayedCount * (BUTTON_HEIGHT + BUTTON_SPACING)
        frame:SetHeight(math.max(totalHeight, scrollFrame:GetHeight()))
        
        -- Store the current category so we can refresh it when items are cached
        frame.currentCategory = category
        
        -- If we have pending items and this isn't a full refresh, set up to receive item updates
        if pendingItemCount > 0 and not forceFull then
            itemCacheFrame:SetScript("OnEvent", function(self, event, itemID, success)
                if success and pendingItemCount > 0 then
                    pendingItemCount = pendingItemCount - 1
                    
                    if pendingItemCount == 0 then
                        -- All pending items have been loaded, refresh display
                        C_Timer.After(0.1, function()
                            if frame.currentCategory then
                                UpdateItemListDisplay(frame.currentCategory, true)
                            end
                        end)
                    end
                end
            end)
        else
            itemCacheFrame:SetScript("OnEvent", nil)
        end
    end
end

local function InitializeCategoryList()
    local frame = AutoPotionPlusItemListManagerCategoryList
    local yOffset = -25  -- Start below the title
    
    -- Clear existing buttons if any
    if frame.buttons then
        for _, button in pairs(frame.buttons) do
            button:Hide()
            button:SetParent(nil)
        end
    end
    frame.buttons = {}
    
    for i, category in ipairs(itemCategories) do
        local button = CreateFrame("Button", frame:GetName().."Button"..i, frame)
        frame.buttons[i] = button
        button:SetSize(130, 20)
        button:SetPoint("TOPLEFT", 10, yOffset)
        
        -- Create highlight texture
        local highlight = button:CreateTexture(nil, "HIGHLIGHT")
        highlight:SetAllPoints()
        highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        highlight:SetBlendMode("ADD")
        
        -- Create selected texture
        local selected = button:CreateTexture(nil, "BACKGROUND")
        selected:SetAllPoints()
        selected:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        selected:SetBlendMode("ADD")
        selected:SetVertexColor(0.5, 0.5, 0, 0.5)
        selected:Hide()
        button.selectedTexture = selected
        
        -- Create text
        local text = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        text:SetPoint("LEFT", 5, 0)
        text:SetText(category)
        
        -- Set up click handling
        button:SetScript("OnClick", function()
            -- Hide all selected textures
            for _, btn in pairs(frame.buttons) do
                btn.selectedTexture:Hide()
            end
            -- Show this button's selected texture
            selected:Show()
            -- Update the current category and item display
            currentSelectedCategory = category
            UpdateItemListDisplay(currentSelectedCategory, false) -- Don't force full refresh on initial click
        end)
        
        yOffset = yOffset - 25  -- Space between buttons
    end
    
    -- Select the first category by default
    if frame.buttons[1] then
        frame.buttons[1].selectedTexture:Show()
        UpdateItemListDisplay(currentSelectedCategory, false)
    end
end

-- Finally define HandleItemDrop which uses the above functions
local function HandleItemDrop()
    local cursorType, id, _, link = GetCursorInfo()
    
            -- Only process if there's an actual item
    if cursorType == "item" and id then
        -- Safety check
        if not currentSelectedCategory then
            ClearCursor()
            return
        end
        
        -- Get character key locally to fix the nil error
        local charKeyLocal = GetCharacterKey()
        if not charKeyLocal then
            ClearCursor()
            return
        end
        
        -- Safety check for DB
        if not AutoPotionPlusDB or not AutoPotionPlusDB[charKeyLocal] then
            InitializeSettings() -- Try to initialize if not done
        end
        
        local list = categoryToList[currentSelectedCategory]
        
        if list then
            -- Check if item already exists in list
            for _, existingId in ipairs(list) do
                if existingId == id then
                    ClearCursor()
                    return
                end
            end
            
            -- Remove from removedItems if it was previously removed
            if AutoPotionPlusDB[charKeyLocal].removedItems then
                AutoPotionPlusDB[charKeyLocal].removedItems[id] = nil
            end
            
            -- Add item to list
            table.insert(list, id)
            SaveItemLists()
            UpdateItemListDisplay(currentSelectedCategory, true)
            
            -- Always update both macros when food-related items are changed
            if currentSelectedCategory == "Buff Foods" or 
               currentSelectedCategory == "Regular Foods" or 
               currentSelectedCategory == "Drinks" then
                UpdateFoodMacro()
            end
            UpdateMacro()
        end
        ClearCursor()
    end
end

-- Update InitializeUI to use the new function
local function InitializeUI()
    local charKey = GetCharacterKey()
    -- Set up checkbox labels
    _G[AutoPotionPlusFrame:GetName().."WarriorModeCheckText"]:SetText("Warrior Mode (Swap food and drink)")
    _G[AutoPotionPlusFrame:GetName().."AmountPrioritySectionLowestCheckText"]:SetText("Choose least amount first")
    _G[AutoPotionPlusFrame:GetName().."ConjuredPreferenceSectionLowestCheckText"]:SetText("Prefer conjured items")

    -- Set up checkbox states
    AutoPotionPlusFrameHealingSectionLowestCheck:SetChecked(AutoPotionPlusDB[charKey].useLowestHealing)
    AutoPotionPlusFrameManaSectionLowestCheck:SetChecked(AutoPotionPlusDB[charKey].useLowestMana)
    AutoPotionPlusFrameFoodSectionLowestCheck:SetChecked(AutoPotionPlusDB[charKey].useLowestFood)
    AutoPotionPlusFrameDrinkSectionLowestCheck:SetChecked(AutoPotionPlusDB[charKey].useLowestDrink)
    AutoPotionPlusFrameBandageSectionLowestCheck:SetChecked(AutoPotionPlusDB[charKey].useLowestBandage)
    AutoPotionPlusFrameWarriorModeCheck:SetChecked(AutoPotionPlusDB[charKey].warriorMode)
    AutoPotionPlusFrameHealthstoneSectionLowestCheck:SetChecked(AutoPotionPlusDB[charKey].useHealthstoneFirst)
    AutoPotionPlusFrameAmountPrioritySectionLowestCheck:SetChecked(AutoPotionPlusDB[charKey].useAmountPriority)
    AutoPotionPlusFrameConjuredPreferenceSectionLowestCheck:SetChecked(AutoPotionPlusDB[charKey].preferConjured)

    -- Update the healthstone checkbox label
    _G[AutoPotionPlusFrame:GetName().."HealthstoneSectionLowestCheckText"]:SetText("Healthstone priority")

    -- Set up individual click handlers for each checkbox
    AutoPotionPlusFrameHealingSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB[charKey].useLowestHealing = self:GetChecked()
        UpdateMacro()
    end)
    
    AutoPotionPlusFrameManaSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB[charKey].useLowestMana = self:GetChecked()
        UpdateMacro()
    end)
    
    AutoPotionPlusFrameFoodSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB[charKey].useLowestFood = self:GetChecked()
        UpdateFoodMacro()
    end)
    
    AutoPotionPlusFrameDrinkSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB[charKey].useLowestDrink = self:GetChecked()
        UpdateFoodMacro()
    end)
    
    AutoPotionPlusFrameBandageSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB[charKey].useLowestBandage = self:GetChecked()
        UpdateMacro()
    end)
    
    AutoPotionPlusFrameWarriorModeCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB[charKey].warriorMode = self:GetChecked()
        UpdateFoodMacro()
    end)
    
    AutoPotionPlusFrameHealthstoneSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB[charKey].useHealthstoneFirst = self:GetChecked()
        UpdateMacro()
    end)
    
    AutoPotionPlusFrameAmountPrioritySectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB[charKey].useAmountPriority = self:GetChecked()
        UpdateMacro()
        UpdateFoodMacro()
    end)
    
    AutoPotionPlusFrameConjuredPreferenceSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB[charKey].preferConjured = self:GetChecked()
        UpdateFoodMacro()
    end)

    -- Replace dropdown initialization with category list
    InitializeCategoryList()
    
    -- Set up drop zone
    local dropZone = AutoPotionPlusItemListManagerDropZone
    if not dropZone then
        return
    end
    
    dropZone:EnableMouse(true)
    dropZone:RegisterForDrag("LeftButton")
    
    -- Only use the core drag events that are fully supported in Classic
    dropZone:SetScript("OnReceiveDrag", function()
        -- Try to highlight the frame briefly to give feedback
        local texture = dropZone:GetRegions()
        if texture then
            local r, g, b, a = 0.3, 0.3, 0.8, 0.5
            if texture.SetColorTexture then
                texture:SetColorTexture(r, g, b, a)
            elseif texture.SetTexture then
                texture:SetTexture(r, g, b, a)
            end
            
            -- Restore original color after a short delay
            C_Timer.After(0.3, function()
                if texture.SetColorTexture then
                    texture:SetColorTexture(0, 0, 0, 0.3)
                elseif texture.SetTexture then
                    texture:SetTexture(0, 0, 0, 0.3)
                end
            end)
        end
        
        HandleItemDrop()
    end)
    
    -- Only respond to MouseUp events when an item is being dragged
    dropZone:SetScript("OnMouseUp", function()
        local cursorType = GetCursorInfo()
        if cursorType then
            HandleItemDrop()
        end
    end)
    
    -- Add drop capabilities to the entire scroll frame area for easier dropping
    local scrollFrame = _G["AutoPotionPlusItemListManagerItemListScroll"]
    if scrollFrame then
        scrollFrame:EnableMouse(true)
        scrollFrame:RegisterForDrag("LeftButton")
        scrollFrame:SetScript("OnReceiveDrag", HandleItemDrop)
        -- Only respond to MouseUp events when an item is being dragged
        scrollFrame:SetScript("OnMouseUp", function()
            local cursorType = GetCursorInfo()
            if cursorType then
                HandleItemDrop()
            end
        end)
    end
    
    -- Load saved item lists
    LoadItemLists()
    UpdateItemListDisplay(currentSelectedCategory, false)

    -- Add a tooltip to the drop zone
    dropZone:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine("Drop Items Here")
        GameTooltip:AddLine("Drag items from your bags and drop them here", 1, 1, 1)
        GameTooltip:Show()
    end)
    
    dropZone:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

-- Then the macro creation functions
local function CreateMacroIfNeeded()
    local macroIndex = GetMacroIndexByName("AutoPotionPlus")
    if macroIndex == 0 then
        -- Create a global macro if there's space
        if select(2, GetNumMacros()) < 120 then
            CreateMacro("AutoPotionPlus", "INV_MISC_QUESTIONMARK", "", nil)
        end
    end
end

local function CreateFoodMacroIfNeeded()
    local macroIndex = GetMacroIndexByName("AutoFoodPlus")
    if macroIndex == 0 then
        -- Create a global macro if there's space
        if select(2, GetNumMacros()) < 120 then
            CreateMacro("AutoFoodPlus", "INV_MISC_QUESTIONMARK", "", nil)
        end
    end
end

local function CreateMinimapButton()
    -- Create the button as a child of Minimap
    local button = CreateFrame("Button", "AutoPotionPlusMinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameLevel(Minimap:GetFrameLevel() + 1)
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    button:SetMovable(true)
    button:EnableMouse(true)
    button:RegisterForDrag("LeftButton")
    button:SetClampedToScreen(true)

    -- Create the icon
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER", 0, 0)
    icon:SetTexture("Interface\\Icons\\INV_Potion_54")

    -- Create the overlay
    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT")

    -- Make the button movable around the minimap
    local function UpdatePosition()
        if not AutoPotionPlusDB then
            AutoPotionPlusDB = {}
        end
        local charKey = GetCharacterKey()
        if not AutoPotionPlusDB[charKey] then
            AutoPotionPlusDB[charKey] = CopyTable(defaults)
        end
        local angle = math.rad(AutoPotionPlusDB[charKey].minimapPos or 45)
        local x, y = math.cos(angle), math.sin(angle)
        button:ClearAllPoints()
        button:SetPoint("CENTER", Minimap, "CENTER", x * 80, y * 80)
    end

    -- Minimap button dragging functionality
    local function OnUpdate(self, elapsed)
        if not AutoPotionPlusDB then
            AutoPotionPlusDB = {}
        end
        local charKey = GetCharacterKey()
        if not AutoPotionPlusDB[charKey] then
            AutoPotionPlusDB[charKey] = CopyTable(defaults)
        end
        
        local xpos, ypos = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        local minimapX, minimapY = Minimap:GetCenter()
        xpos = xpos / scale
        ypos = ypos / scale
        
        local angle = math.deg(math.atan2(ypos - minimapY, xpos - minimapX))
        AutoPotionPlusDB[charKey].minimapPos = angle
        UpdatePosition()
    end

    button:SetScript("OnDragStart", function(self)
        self:StartMoving()
        self:SetScript("OnUpdate", OnUpdate)
    end)

    button:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        self:SetScript("OnUpdate", nil)
    end)

    -- Show/hide menu on click
    button:SetScript("OnClick", function()
        if AutoPotionPlusFrame:IsShown() then
            AutoPotionPlusFrame:Hide()
        else
            AutoPotionPlusFrame:Show()
        end
    end)

    -- Tooltip
    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(button, "ANCHOR_LEFT")
        GameTooltip:AddLine("AutoPotion+")
        GameTooltip:AddLine("Click to open configuration", 1, 1, 1)
        GameTooltip:AddLine("Drag to move this button", 1, 1, 1)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Initial position
    UpdatePosition()
    
    -- Make sure the button is shown
    button:Show()
    
    return button
end

-- Add debug log UI functions
local function ShowDebugLogUI()
    local frame = AutoPotionPlusDebugLogFrame
    if not frame then
        return
    end
    
    -- Get current debug log
    local currentLog = table.concat(debugLog, "\n")
    if currentLog == "" then
        currentLog = "No current debug log available.\n\nUse the addon first to generate debug information.\n\nTry checking/unchecking settings to generate debug logs."
    end
    
    -- Try different possible edit box names
    local editBox = _G["AutoPotionPlusDebugLogFrameLogEditBox"]
    if not editBox then
        editBox = _G["AutoPotionPlusDebugLogFrameLogScrollLogEditBox"]
    end
    if not editBox then
        editBox = frame.LogEditBox
    end
    if not editBox then
        -- Try to find any EditBox in the frame
        for i = 1, 10 do
            local child = _G["AutoPotionPlusDebugLogFrameLogEditBox" .. i]
            if child and child:GetObjectType() == "EditBox" then
                editBox = child
                break
            end
        end
    end
    
    if editBox then
        -- Store the edit box reference globally
        debugLogEditBox = editBox
        editBox:SetText(currentLog)
        editBox:HighlightText(0, 0) -- Select all text
    end
    
    frame:Show()
end

local function InitializeDebugLogUI()
    local frame = AutoPotionPlusDebugLogFrame
    if not frame then
        return
    end
    
    -- Set up close button
    local closeButton = _G["AutoPotionPlusDebugLogFrameCloseButton"]
    if closeButton then
        closeButton:SetScript("OnClick", function()
            frame:Hide()
        end)
    end
    
    -- Set up copy button
    local copyButton = _G["AutoPotionPlusDebugLogFrameCopyButton"]
    if copyButton then
        copyButton:SetScript("OnClick", function()
            if debugLogEditBox then
                debugLogEditBox:HighlightText(0, 0) -- Select all text
            end
        end)
    end
    
    -- Set up clear button
    local clearButton = _G["AutoPotionPlusDebugLogFrameClearButton"]
    if clearButton then
        clearButton:SetScript("OnClick", function()
            debugLog = {}
            if debugLogEditBox then
                debugLogEditBox:SetText("Debug log cleared.")
            end
        end)
    end
    
    -- Set up refresh button
    local refreshButton = _G["AutoPotionPlusDebugLogFrameRefreshButton"]
    if refreshButton then
        refreshButton:SetScript("OnClick", function()
            -- Get current debug log
            local currentLog = table.concat(debugLog, "\n")
            if currentLog == "" then
                currentLog = "No current debug log available.\n\nUse the addon first to generate debug information.\n\nTry checking/unchecking settings to generate debug logs."
            end
            
            -- Update the edit box
            if debugLogEditBox then
                debugLogEditBox:SetText(currentLog)
                debugLogEditBox:HighlightText(0, 0) -- Select all text
            end
        end)
    end
    
    -- Make edit box read-only but selectable
    local editBox = _G["AutoPotionPlusDebugLogFrameLogEditBox"]
    if editBox then
        debugLogEditBox = editBox -- Store reference during initialization too
        editBox:SetScript("OnEditFocusGained", function(self)
            self:HighlightText(0, 0)
        end)
    end
end

-- Modify the PLAYER_LOGIN event handler to create the minimap button
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        InitializeSettings()
        CreateMacroIfNeeded()
        CreateFoodMacroIfNeeded()
        InitializeUI()
        InitializeDebugLogUI() -- Initialize debug log UI
        -- Create the minimap button after a short delay to ensure everything is loaded
        C_Timer.After(1, function()
            CreateMinimapButton()
        end)
        print("AutoPotionPlus loaded! Use /appdebugui to open the debug info")
    end
    UpdateMacro()
    UpdateFoodMacro()
end)

SLASH_AUTOPOTIONUI1 = "/autopotionui"
SlashCmdList["AUTOPOTIONUI"] = function()
    if AutoPotionPlusFrame:IsShown() then
        AutoPotionPlusFrame:Hide()
    else
        AutoPotionPlusFrame:Show()
    end
end

-- Debug function to check items
local function DebugItems()
    local function GetItemLink(itemID)
        local itemName = GetItemInfo(itemID)
        return itemName or ("ItemID: " .. itemID)
    end

    local function PrintDelayed(message, delay)
        C_Timer.After(delay, function()
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00" .. message .. "|r")
        end)
    end

    local function CheckList(list, listName, delay)
        local message = listName .. ": "
        local found = false
        for _, itemID in ipairs(list) do
            local count = GetItemCount(itemID)
            if count > 0 then
                found = true
                message = message .. GetItemLink(itemID) .. " (x" .. count .. "), "
            end
        end
        if not found then
            message = message .. "None found"
        end
        PrintDelayed(message, delay)
    end

    PrintDelayed("=== AutoPotionPlus Debug ===", 0.0)
    CheckList(healthstones, "Healthstones", 0.2)
    CheckList(potions, "Healing Potions", 0.4)
    CheckList(bandages, "Bandages", 0.6)
    CheckList(manaPotions, "Mana Potions", 0.8)
    
    -- Add these lines before the macro text check
    CheckList(drinks, "Drinks", 1.0)
    CheckList(foods, "Foods", 1.2)
    CheckList(buffFoods, "Buff Foods", 1.4)
    
    -- Update the delay for macro text display
    local macroId = GetMacroIndexByName("AutoPotionPlus")
    if macroId > 0 then
        local name, icon, body = GetMacroInfo(macroId)
        PrintDelayed("Potion macro:", 1.6)
        PrintDelayed(body, 1.8)
    end
    
    local foodMacroId = GetMacroIndexByName("AutoFoodPlus")
    if foodMacroId > 0 then
        local name, icon, body = GetMacroInfo(foodMacroId)
        PrintDelayed("Food macro:", 2.0)
        PrintDelayed(body, 2.2)
    end
end

-- Add debug slash command
SLASH_AUTOPOTIONPDEBUG1 = "/apdebug"
SlashCmdList["AUTOPOTIONPDEBUG"] = DebugItems

-- Keep only this
AutoPotionPlusFrameCloseButton:SetScript("OnClick", function()
    AutoPotionPlusFrame:Hide()
end)

-- Add near the end of the file, with the other UI scripts
AutoPotionPlusItemListManagerCloseButton:SetScript("OnClick", function()
    AutoPotionPlusItemListManager:Hide()
end)

-- Update the ResetItemLists function
function ResetAllSettings()
    -- Show confirmation dialog
    StaticPopupDialogs["AUTOPOTIONPLUS_RESET_CONFIRM"] = {
        text = "Are you sure you want to reset ALL settings to default?\nThis will reset item lists, minimap position, and all other settings.",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            local charKey = GetCharacterKey()
            
            -- Reset all settings to defaults
            AutoPotionPlusDB[charKey] = CopyTable(defaults)
            
            -- Reset minimap position
            AutoPotionPlusDB[charKey].minimapPos = minimapDefaults.minimapPos
            
            -- Reset the removed items list
            AutoPotionPlusDB[charKey].removedItems = {}
            
            -- Restore all lists to their defaults
            for category, defaultList in pairs(defaultLists) do
                categoryToList[category] = CopyTable(defaultList)
            end
            
            -- Save the restored lists
            SaveItemLists()
            
            -- Update the display
            UpdateItemListDisplay(currentSelectedCategory, true)
            
            -- Update macros
            UpdateMacro()
            UpdateFoodMacro()
            
            -- Update UI elements to reflect reset settings
            InitializeUI()
            
            -- Update minimap button position
            if AutoPotionPlusMinimapButton then
                local angle = math.rad(AutoPotionPlusDB[charKey].minimapPos)
                local x, y = math.cos(angle), math.sin(angle)
                AutoPotionPlusMinimapButton:ClearAllPoints()
                AutoPotionPlusMinimapButton:SetPoint("CENTER", Minimap, "CENTER", x * 80, y * 80)
            end
            
            print("AutoPotion+: All settings have been reset to defaults")
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("AUTOPOTIONPLUS_RESET_CONFIRM")
end

-- Update the button reference in XML
AutoPotionPlusItemListManagerResetButton:SetScript("OnClick", function()
    ResetAllSettings()
end)

-- Add command to open debug log UI
SLASH_AUTOPOTIONDEBUGUI1 = "/appdebugui"
SlashCmdList["AUTOPOTIONDEBUGUI"] = function()
    ShowDebugLogUI()
end