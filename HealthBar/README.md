# HealthBar

A simple HUD health bar with health numbers. Shifts from green to red as health drops.

---

## Overview

Builds a `ScreenGui` in the player's `PlayerGui` at runtime. The fill bar animates smoothly using `TweenService` and lerps between green and red based on health percentage. The health number updates every time health changes.

---

## Setup

1. Place `HealthBar.lua` in the `StarterPlayerScripts` as a `LocalScript`.
2. Adjust `CONFIG` at the top to your liking:

```lua
local CONFIG = {
	BarWidth     = 300,
	BarHeight    = 22,
	HealthyColor = Color3.fromRGB(80, 200, 100),
	LowColor     = Color3.fromRGB(220, 60, 60),
}
```

---

## Examples

```lua
-- Wider bar
BarWidth  = 500
BarHeight = 28

-- Blue health bar
HealthyColor = Color3.fromRGB(60, 140, 255)
LowColor     = Color3.fromRGB(180, 40, 200)
```

---

## Troubleshooting

**Bar isn't showing** - 
Make sure the script is a `LocalScript` in `StarterPlayerScripts`. It cannot be a regular `Script` or `ModuleScript`.

**Two health bars showing** - 
Roblox has a default health bar built in. Go to `StarterGui` and delete or disable the default `Health` ScreenGui.

**Bar doesn't reset on respawn** - 
The script reconnects automatically on `CharacterAdded`. Make sure `ResetOnSpawn` hasn't been changed somewhere else.

---

## Notes

- Drop it in and it works. No dependencies.
- Works with any `MaxHealth` value, not just 100.
- Automatically reconnects on respawn.