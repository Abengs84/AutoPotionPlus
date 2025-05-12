# AutoPotionPlus

A World of Warcraft Classic addon for automated potion, food, and bandage management with enhanced UI and quality-of-life features.

## Features

- **Automatic Consumables Management**: Creates macros for automatically using potions, food, drinks, bandages and healthstones
- **Smart Consumption Logic**: Options to use lowest quality items first or prioritize higher quality consumables
- **Class-Specific Mode**: "Warrior Mode" to swap food and drink behaviors for class-specific needs
- **Intuitive UI**: Clean interface for managing all settings and customizing consumable lists
- **Minimap Button**: Easy access button positioned to avoid conflicts with other addons

## Recent Enhancements

- **Improved UI**: Added scrollable item lists with proper frame styling and borders
- **Fixed Minimap Position**: Button now appears in a better position (bottom-left) to avoid overlapping the sun icon
- **Enhanced Item Selection**: Text-based item listings with icons for better readability
- **Customizable Lists**: 
  - Drag and drop items from bags to add them to lists
  - Shift+Click reordering system for organizing items
  - Right-click to remove items
- **Visual Improvements**:
  - Clear selection state indicators
  - Hover effects for better interaction feedback
  - Concise item names with tooltips for details
- **Reset Function**: "Reset to Defaults" option to restore original settings

## Usage

1. **Basic Usage**: The addon creates two macros:
   - `/cast AutoPotionPlus` - For healing, mana, bandages
   - `/cast AutoFoodPlus` - For food and drinks

2. **Modifiers**:
   - No modifier: Main item (healing potion/drink)
   - Shift: Use bandage/food
   - Control: Use mana potion/buff food

3. **Item Management**:
   - Open the addon with `/autopotionui` or the minimap button
   - Click "Manage Items" to customize your consumable lists
   - Drag items from your bags to add them
   - Shift+click an item then click another item to move it to that position
   - Right-click to remove items

## Installation

1. Download the addon
2. Extract to `World of Warcraft\_classic_era_\Interface\AddOns\`
3. Restart World of Warcraft if it's running
4. The addon will create macros automatically on first load

## Credits

Created by Uthenaria
Idea from Auto Potion by ollidiemaus
