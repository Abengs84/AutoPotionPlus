local f = CreateFrame("Frame")
f:RegisterEvent("BAG_UPDATE")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_REGEN_ENABLED")

-- Define item lists globally
local bandages = {
    20065, -- Arathi Basin Mageweave Bandage
    20067, -- Arathi Basin Silk Bandage
    20066, -- Arathi Basin Runecloth Bandage
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
    9421  -- Major Healthstone (Rank 5)
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
    8075,  -- Conjured Sourdough
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
    2679,  -- Charred Wolf Meat
    422,   -- Dwarven Mild
    414,   -- Dalaran Sharp
    13935, -- Baked Salmon
    13933, -- Lobster Stew
    13930, -- Filet of Redgill
    117    -- Tough Jerky
}

local buffFoods = {
    13931, -- Nightfin Soup
    12214, -- Mystery Stew
    13928, -- Grilled Squid
    13927, -- Cooked Glossy Mightfish
    18045, -- Tender Wolf Steak
    18254, -- Runn Tum Tuber Surprise
    13932, -- Poached Sunscale Salmon
    13929, -- Hot Smoked Bass
    724,   -- Goretusk Liver Pie
    5525,  -- Boiled Clams
    2684,  -- Coyote Steak
    3666,  -- Gooey Spider Cake
    12209,  -- Lean Wolf Steak
    1017 -- Seasoned Wolf Kabob
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
    minimapPos = 45 -- Default angle position
}

-- Add this variable to track the currently selected category
local currentSelectedCategory = "Buff Foods" -- Default category

-- First, define the helper functions and data management functions
local function SaveItemLists()
    if not AutoPotionPlusDB.itemLists then
        AutoPotionPlusDB.itemLists = {}
    end
    if not AutoPotionPlusDB.removedItems then
        AutoPotionPlusDB.removedItems = {}
    end
    
    for category, list in pairs(categoryToList) do
        AutoPotionPlusDB.itemLists[category] = CopyTable(list)
    end
end

local function LoadItemLists()
    -- Initialize removedItems if it doesn't exist
    if not AutoPotionPlusDB.removedItems then
        AutoPotionPlusDB.removedItems = {}
    end

    if AutoPotionPlusDB.itemLists then
        for category, savedList in pairs(AutoPotionPlusDB.itemLists) do
            if categoryToList[category] then
                -- Start with default items, but filter out removed ones
                local newList = {}
                for _, id in ipairs(categoryToList[category]) do
                    if not AutoPotionPlusDB.removedItems[id] then
                        table.insert(newList, id)
                    end
                end
                
                -- Add saved custom items
                for _, id in ipairs(savedList) do
                    if not AutoPotionPlusDB.removedItems[id] then
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
    if not AutoPotionPlusDB then
        AutoPotionPlusDB = CopyTable(defaults)
    end
    -- Ensure removedItems exists
    if AutoPotionPlusDB.removedItems == nil then
        AutoPotionPlusDB.removedItems = {}
    end
    -- Add minimap position if it doesn't exist
    if AutoPotionPlusDB.minimapPos == nil then
        AutoPotionPlusDB.minimapPos = minimapDefaults.minimapPos
    end
end

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

-- Then define UpdateMacro and UpdateFoodMacro
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

    -- Get items from the current lists
    local drinkItem = FindFirstItem(categoryToList["Drinks"], AutoPotionPlusDB.useLowestDrink)
    local foodItem = FindFirstItem(categoryToList["Regular Foods"], AutoPotionPlusDB.useLowestFood)
    local buffFoodItem = FindFirstItem(categoryToList["Buff Foods"], AutoPotionPlusDB.useLowestFood)
    
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

-- Then define the item list management functions
local function UpdateItemListDisplay(category)
    local frame = AutoPotionPlusItemListManagerItemList
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
        local BUTTONS_PER_ROW = 5
        local BUTTON_SIZE = 32
        local BUTTON_SPACING = 4
        local ROW_SPACING = 4
        local PADDING = 8

        for i, itemId in ipairs(list) do
            local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemId)
            if itemName then
                local row = math.floor((i-1) / BUTTONS_PER_ROW)
                local col = (i-1) % BUTTONS_PER_ROW
                
                local button = CreateFrame("Button", frame:GetName().."Item"..i, frame)
                frame.buttons[i] = button
                button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
                button:SetPoint("TOPLEFT", 
                    PADDING + col * (BUTTON_SIZE + BUTTON_SPACING), 
                    -(PADDING + row * (BUTTON_SIZE + ROW_SPACING)))
                
                -- Register for right-click
                button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
                
                local icon = button:CreateTexture(nil, "ARTWORK")
                icon:SetAllPoints()
                icon:SetTexture(itemTexture)
                
                local highlight = button:CreateTexture(nil, "HIGHLIGHT")
                highlight:SetAllPoints()
                highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
                highlight:SetBlendMode("ADD")
                
                button:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(itemLink)
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine("Right-click to remove", 1, 0.82, 0)
                    GameTooltip:Show()
                end)
                
                button:SetScript("OnLeave", function()
                    GameTooltip:Hide()
                end)
                
                button:SetScript("OnClick", function(self, button)
                    if button == "RightButton" then
                        -- Add item to removed items list
                        if not AutoPotionPlusDB.removedItems then
                            AutoPotionPlusDB.removedItems = {}
                        end
                        AutoPotionPlusDB.removedItems[itemId] = true
                        
                        -- Remove item from current list
                        table.remove(list, i)
                        SaveItemLists()
                        UpdateItemListDisplay(category)
                        -- Update macros when removing items
                        UpdateMacro()
                        UpdateFoodMacro()
                    end
                end)
            end
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
            UpdateItemListDisplay(category)
        end)
        
        yOffset = yOffset - 25  -- Space between buttons
    end
    
    -- Select the first category by default
    if frame.buttons[1] then
        frame.buttons[1].selectedTexture:Show()
        UpdateItemListDisplay(currentSelectedCategory)
    end
end

-- Finally define HandleItemDrop which uses the above functions
local function HandleItemDrop()
    local type, id, _, link = GetCursorInfo()
    if type == "item" then
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
            if AutoPotionPlusDB.removedItems then
                AutoPotionPlusDB.removedItems[id] = nil
            end
            
            -- Add item to list
            table.insert(list, id)
            SaveItemLists()
            UpdateItemListDisplay(currentSelectedCategory)
            
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
    -- Set up checkbox labels
    _G[AutoPotionPlusFrame:GetName().."WarriorModeCheckText"]:SetText("Warrior Mode (Swap food and drink)")

    -- Set up checkbox states
    AutoPotionPlusFrameHealingSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestHealing)
    AutoPotionPlusFrameManaSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestMana)
    AutoPotionPlusFrameFoodSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestFood)
    AutoPotionPlusFrameDrinkSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestDrink)
    AutoPotionPlusFrameBandageSectionLowestCheck:SetChecked(AutoPotionPlusDB.useLowestBandage)
    AutoPotionPlusFrameWarriorModeCheck:SetChecked(AutoPotionPlusDB.warriorMode)
    AutoPotionPlusFrameHealthstoneSectionLowestCheck:SetChecked(AutoPotionPlusDB.useHealthstoneFirst)

    -- Update the healthstone checkbox label
    _G[AutoPotionPlusFrame:GetName().."HealthstoneSectionLowestCheckText"]:SetText("Healthstone priority")

    -- Set up click handlers with the global OnCheckboxClick function
    AutoPotionPlusFrameHealingSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB.useLowestHealing = self:GetChecked()
        UpdateMacro()
    end)
    
    AutoPotionPlusFrameManaSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB.useLowestMana = self:GetChecked()
        UpdateMacro()
    end)
    
    AutoPotionPlusFrameFoodSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB.useLowestFood = self:GetChecked()
        UpdateFoodMacro()
    end)
    
    AutoPotionPlusFrameDrinkSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB.useLowestDrink = self:GetChecked()
        UpdateFoodMacro()
    end)
    
    AutoPotionPlusFrameBandageSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB.useLowestBandage = self:GetChecked()
        UpdateMacro()
    end)
    
    AutoPotionPlusFrameWarriorModeCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB.warriorMode = self:GetChecked()
        UpdateFoodMacro()
    end)
    
    AutoPotionPlusFrameHealthstoneSectionLowestCheck:SetScript("OnClick", function(self)
        AutoPotionPlusDB.useHealthstoneFirst = self:GetChecked()
        UpdateMacro()
    end)

    -- Replace dropdown initialization with category list
    InitializeCategoryList()
    
    -- Set up drop zone
    local dropZone = AutoPotionPlusItemListManagerDropZone
    dropZone:EnableMouse(true)
    dropZone:RegisterForDrag("LeftButton")
    dropZone:SetScript("OnReceiveDrag", HandleItemDrop)
    dropZone:SetScript("OnMouseUp", HandleItemDrop)
    
    -- Load saved item lists
    LoadItemLists()
    UpdateItemListDisplay(currentSelectedCategory)
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
    local button = CreateFrame("Button", "AutoPotionPlusMinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameLevel(8)
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER", 0, 0)
    icon:SetTexture("Interface\\Icons\\INV_Potion_54")

    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(53, 53)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    overlay:SetPoint("TOPLEFT")

    -- Make the button movable around the minimap
    local function UpdatePosition()
        local angle = math.rad(AutoPotionPlusDB.minimapPos or 45)
        local x, y = math.cos(angle), math.sin(angle)
        button:SetPoint("CENTER", Minimap, "CENTER", x * 80, y * 80)
    end

    -- Minimap button dragging functionality
    local function OnUpdate(self, elapsed)
        local xpos, ypos = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        local minimapX, minimapY = Minimap:GetCenter()
        xpos = xpos / scale
        ypos = ypos / scale
        
        local angle = math.deg(math.atan2(ypos - minimapY, xpos - minimapX))
        AutoPotionPlusDB.minimapPos = angle
        UpdatePosition()
    end

    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", OnUpdate)
    end)

    button:SetScript("OnDragStop", function(self)
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
    return button
end

-- Modify the PLAYER_LOGIN event handler to create the minimap button
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        InitializeSettings()
        CreateMacroIfNeeded()
        CreateFoodMacroIfNeeded()
        InitializeUI()
        CreateMinimapButton()
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

-- Change from local function to global
function ResetItemLists()
    -- Show confirmation dialog
    StaticPopupDialogs["AUTOPOTIONPLUS_RESET_CONFIRM"] = {
        text = "Are you sure you want to reset all item lists to default?\nThis will remove any custom items and restore all default items.",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            -- Reset the removed items list
            AutoPotionPlusDB.removedItems = {}
            
            -- Restore all lists to their defaults
            for category, defaultList in pairs(defaultLists) do
                categoryToList[category] = CopyTable(defaultList)
            end
            
            -- Save the restored lists
            SaveItemLists()
            
            -- Update the display
            UpdateItemListDisplay(currentSelectedCategory)
            
            -- Update macros
            UpdateMacro()
            UpdateFoodMacro()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("AUTOPOTIONPLUS_RESET_CONFIRM")
end