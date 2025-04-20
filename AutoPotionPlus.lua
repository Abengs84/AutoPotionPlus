local f = CreateFrame("Frame")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

-- Define item lists globally
local bandages = {
    20066, -- Arathi Basin Bandage
    20065, -- Warsong Gulch Bandage
    14530, -- Heavy Runecloth Bandage
    14529, -- Runecloth Bandage
    8545,  -- Heavy Mageweave Bandage
    8544,  -- Mageweave Bandage
    6451,  -- Heavy Silk Bandage
    6450,  -- Silk Bandage
    3531,  -- Heavy Wool Bandage
    3530,  -- Wool Bandage
    2581,  -- Heavy Linen Bandage
    1251   -- Linen Bandage
}

local manaPotions = {
    13444, -- Major Mana Potion
    13443, -- Superior Mana Potion
    6149,  -- Greater Mana Potion
    3827,  -- Mana Potion
    3385,  -- Lesser Mana Potion
    2455   -- Minor Mana Potion
}

local healthstones = {
    5512,  -- Minor Healthstone (Rank 1)
    5511,  -- Lesser Healthstone (Rank 2)
    5509,  -- Healthstone (Rank 3)
    5510,  -- Greater Healthstone (Rank 4)
    9421,  -- Major Healthstone (Rank 5)
    22103  -- Master Healthstone (Rank 6)
}

local potions = {
    13446, -- Major Healing Potion
    3928,  -- Superior Healing Potion
    1710,  -- Greater Healing Potion
    929,   -- Healing Potion
    858,   -- Lesser Healing Potion
    118    -- Minor Healing Potion
}

-- Add these new item lists after the existing ones
local drinks = {
    8079,  -- Conjured Crystal Water
    8078,  -- Conjured Sparkling Water
    3772,  -- Conjured Spring Water
    2136,  -- Conjured Purified Water
    2288,  -- Conjured Fresh Water
    5350,  -- Conjured Water
    8766,  -- Morning Glory Dew
    1401,  -- Green Tea Leaf
    1708,  -- Sweet Nectar
    1645,  -- Moonberry Juice
    1205,  -- Melon Juice
    1179,  -- Ice Cold Milk
    159    -- Refreshing Spring Water
}

local foods = {
    13724, -- Enriched Mana Biscuit
    8076,  -- Conjureds Sweet Roll
    8075,  -- Conjured Bread
    8074,  -- Conjured Tough Bread
    8073,  -- Conjured Bread
    8072,  -- Conjured Fresh Bread
    8071,  -- Conjured Rye
    5526,  -- Coyote Steak
    4601,  -- Soft Banana Bread
    4544,  -- Mulgore Spice Bread
    4542,  -- Moist Cornbread
    4541,  -- Freshly Baked Bread
    4540,  -- Tough Hunk of Bread
    4539,  -- Goldenbark Apple
    4538,  -- Snapvine Watermelon
    4537,  -- Tel'Abim Banana
    4536,  -- Shiny Red Apple
    2681,  -- Roasted Boar Meat
    2680,  -- Spiced Wolf Meat
    2679,  -- Charred Wolf Meat
    422,   -- Dwarven Mild
    414,   -- Dalaran Sharp
    117    -- Tough Jerky
}

local buffFoods = {
    13931, -- Nightfin Soup
    12214, -- Mystery Stew
    13928, -- Grilled Squid
    13927, -- Cooked Glossy Mightfish
    13934, -- Tender Wolf Steak
    18254, -- Runn Tum Tuber Surprise
    13935, -- Baked Salmon
    13933, -- Lobster Stew
    13932, -- Poached Sunscale Salmon
    13929, -- Hot Smoked Bass
    13930, -- Filet of Redgill
    724,   -- Goretusk Liver Pie
    5525,  -- Boiled Clams
    5526,  -- Coyote Steak
    3666,  -- Gooey Spider Cake
    12209,  -- Lean Wolf Steak
    1017 -- Seasoned Wolf Kabob
}

-- Add after the existing global variables
local defaults = {
    useLowestHealing = false,
    useLowestMana = false,
    useLowestFood = false,
    useLowestDrink = false,
    useLowestBandage = false,
    warriorMode = false,
    useHealthstoneFirst = false
}

-- Move these functions to the top, right after the item lists
local function FindFirstItem(itemList, useLowest)
    if useLowest then
        for i = #itemList, 1, -1 do
            if GetItemCount(itemList[i]) > 0 then
                return itemList[i]
            end
        end
    else
        for i = 1, #itemList do
            if GetItemCount(itemList[i]) > 0 then
                return itemList[i]
            end
        end
    end
    return nil
end

local function UpdateMacro()
    -- Check if settings are initialized
    if not AutoPotionPlusDB then
        InitializeSettings()
    end

    -- Build lists of available items
    local bandageItem = FindFirstItem(bandages, AutoPotionPlusDB.useLowestBandage)
    local manaItem = FindFirstItem(manaPotions, AutoPotionPlusDB.useLowestMana)
    
    -- Changed healthstone logic
    local healItem
    if AutoPotionPlusDB.useHealthstoneFirst then
        -- If checkbox is checked, try healthstone first, then fallback to potion
        healItem = FindFirstItem(healthstones, false) or FindFirstItem(potions, AutoPotionPlusDB.useLowestHealing)
    else
        -- If checkbox is unchecked, try potion first, then fallback to healthstone
        healItem = FindFirstItem(potions, AutoPotionPlusDB.useLowestHealing) or FindFirstItem(healthstones, false)
    end
    
    -- Set defaults for other categories if empty
    local bandagesList = bandageItem and "item:" .. bandageItem or "item:118" -- Default to Minor Healing Potion
    local manaList = manaItem and "item:" .. manaItem or "item:118"
    local healList = healItem and "item:" .. healItem or "item:118"

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
        InitializeSettings()
    end

    local drinkItem = FindFirstItem(drinks, AutoPotionPlusDB.useLowestDrink)
    local foodItem = FindFirstItem(foods, AutoPotionPlusDB.useLowestFood)
    local buffFoodItem = FindFirstItem(buffFoods, AutoPotionPlusDB.useLowestFood)
    
    -- Set defaults if empty
    local drinkList = drinkItem and "item:" .. drinkItem or "item:159" -- Default to Spring Water
    local foodList = foodItem and "item:" .. foodItem or "item:4536" -- Default to Apple
    local buffFoodList = buffFoodItem and "item:" .. buffFoodItem or foodList

    local macroText
    if AutoPotionPlusDB.warriorMode then
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

-- Add this function to initialize saved variables
local function InitializeSettings()
    if not AutoPotionPlusDB then
        AutoPotionPlusDB = CopyTable(defaults)
    end
end

-- Add this function to handle checkbox clicks
local function OnCheckboxClick(self)
    local name = self:GetName()
    if name:match("WarriorModeCheck") then
        AutoPotionPlusDB.warriorMode = self:GetChecked()
    elseif name:match("HealthstoneSectionLowestCheck") then
        AutoPotionPlusDB.useHealthstoneFirst = self:GetChecked()
    elseif name:match("HealingSectionLowestCheck") then
        AutoPotionPlusDB.useLowestHealing = self:GetChecked()
    elseif name:match("ManaSectionLowestCheck") then
        AutoPotionPlusDB.useLowestMana = self:GetChecked()
    elseif name:match("FoodSectionLowestCheck") then
        AutoPotionPlusDB.useLowestFood = self:GetChecked()
    elseif name:match("DrinkSectionLowestCheck") then
        AutoPotionPlusDB.useLowestDrink = self:GetChecked()
    elseif name:match("BandageSectionLowestCheck") then
        AutoPotionPlusDB.useLowestBandage = self:GetChecked()
    end
    UpdateMacro()
    UpdateFoodMacro()
end

-- Add this function to initialize the UI
local function InitializeUI()
    -- Set up checkbox labels
    _G[AutoPotionPlusFrame:GetName().."WarriorModeCheckText"]:SetText("Warrior Mode (Food without modifier)")

    -- Set up checkbox states
    AutoPotionPlusFrameHealingSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestHealing)
    AutoPotionPlusFrameManaSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestMana)
    AutoPotionPlusFrameFoodSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestFood)
    AutoPotionPlusFrameDrinkSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestDrink)
    AutoPotionPlusFrameBandageSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestBandage)
    AutoPotionPlusFrameWarriorModeCheck:SetChecked(AutoPotionPlusDB.warriorMode)
    AutoPotionPlusFrameHealthstoneSectionLowestCheck:SetChecked(AutoPotionPlusDB.useHealthstoneFirst)

    -- Update the healthstone checkbox label
    _G[AutoPotionPlusFrame:GetName().."HealthstoneSectionLowestCheckText"]:SetText("Use Healthstone before Healing Potion")

    -- Set up click handlers
    AutoPotionPlusFrameHealingSectionLowestCheck:SetScript("OnClick", OnCheckboxClick)
    AutoPotionPlusFrameManaSectionLowestCheck:SetScript("OnClick", OnCheckboxClick)
    AutoPotionPlusFrameFoodSectionLowestCheck:SetScript("OnClick", OnCheckboxClick)
    AutoPotionPlusFrameDrinkSectionLowestCheck:SetScript("OnClick", OnCheckboxClick)
    AutoPotionPlusFrameBandageSectionLowestCheck:SetScript("OnClick", OnCheckboxClick)
    AutoPotionPlusFrameWarriorModeCheck:SetScript("OnClick", OnCheckboxClick)
    AutoPotionPlusFrameHealthstoneSectionLowestCheck:SetScript("OnClick", OnCheckboxClick)
end

-- Create an empty macro named "AutoPotionPlus" if it doesn't exist
local function CreateMacroIfNeeded()
    local macroIndex = GetMacroIndexByName("AutoPotionPlus")
    if macroIndex == 0 then
        -- Create a global macro if there's space
        if select(2, GetNumMacros()) < 120 then
            CreateMacro("AutoPotionPlus", "INV_MISC_QUESTIONMARK", "", nil)
        end
    end
end

-- Add this new function after CreateMacroIfNeeded
local function CreateFoodMacroIfNeeded()
    local macroIndex = GetMacroIndexByName("AutoFoodPlus")
    if macroIndex == 0 then
        -- Create a global macro if there's space
        if select(2, GetNumMacros()) < 120 then
            CreateMacro("AutoFoodPlus", "INV_MISC_QUESTIONMARK", "", nil)
        end
    end
end

-- Modify the existing OnEvent script to include the new food macro
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        InitializeSettings()
        CreateMacroIfNeeded()
        CreateFoodMacroIfNeeded()
        InitializeUI()
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