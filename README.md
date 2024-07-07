# Custom Weapon Wheel Script

This script is designed to manage a custom weapon wheel for a game, allowing for dynamic adjustments based on screen resolution and aspect ratio. The script supports different weapon slots and automatically adjusts the position and size of weapon icons.

## Supported aspect ratios:

- 1920/1080 = 1.77
- 1760/990 = 1.77
- 1680/1050 = 1.6
- 1600/900 = 1.6
- 1280/1024 = 1.25
- 1366/768 = 1.77
- 1280/720 = 1.77
- 1024/768 = 1.33


| Original Icon         | Custom Icon          |
|-----------------|-----------------------------|
| ![image](https://github.com/draobrehtom/redm-weapon-wheel/assets/6503721/b2889341-b9b0-4e1b-b279-de6d1e460f82)       | ![image](https://github.com/draobrehtom/redm-weapon-wheel/assets/6503721/f6b02c51-8c47-4ff4-a5db-bb5aebcf4e19)              |


## Usage Examples

### Setting a Custom Weapon Icon
You can set a custom weapon icon for a specific slot using the `setWeaponWheelIcon` export.

#### Example

```lua
-- Set a custom weapon icon for the 'sidearms' slot
exports['redm-weapon-wheel']:setWeaponWheelIcon('sidearms', {'inventory_items', 'weapon_sniperrifle_carcano'})

-- Set a custom weapon icon for the 'longarm_shoulder' slot
exports['redm-weapon-wheel']:setWeaponWheelIcon('longarm_shoulder', {'inventory_items', 'weapon_pistol_volcanic'})
```
| Result |
|-|
|![image](https://github.com/draobrehtom/redm-weapon-wheel/assets/6503721/c1042bb2-1d5e-4faf-b5d7-189f5730a37c)|


### Resetting a Custom Weapon Icon
You can reset the custom weapon icon for a specific slot using the resetWeaponWheelIcon export.

#### Example
```lua
  -- Reset the custom weapon icon for the 'sidearms' slot
  exports['redm-weapon-wheel']:resetWeaponWheelIcon('sidearms')

  -- Reset the custom weapon icon for the 'longarm_shoulder' slot
  exports['redm-weapon-wheel']:resetWeaponWheelIcon('longarm_shoulder')
```

## Available Exports

### `setWeaponWheelIcon`

Sets a custom weapon icon for a specified slot in the weapon wheel.

#### Parameters

- `slot` (string): The slot to set the custom icon for (e.g., 'sidearms').
- `icon` (table): A table containing the texture dictionary and texture name (e.g., `{'inventory_items', 'weapon_sniperrifle_carcano'}`).

#### Example

```lua
exports['redm-weapon-wheel']:setWeaponWheelIcon('sidearms', {'inventory_items', 'weapon_sniperrifle_carcano'})
```

### `resetWeaponWheelIcon`

Resets the custom weapon icon for a specified slot in the weapon wheel.

#### Parameters

- `slot` (string): The slot to reset the custom icon for (e.g., 'sidearms').

#### Example

```lua
exports['redm-weapon-wheel']:resetWeaponWheelIcon('sidearms')
```
