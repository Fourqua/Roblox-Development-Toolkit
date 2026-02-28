# HealthBar

A simple HUD health bar with health numbers. Sits at the bottom center of the screen, animates on damage and healing, and shifts from green to red as health drops.

---

## Overview

Builds a `ScreenGui` directly in the player's `PlayerGui` at runtime — no UI setup needed in Studio. The fill bar animates smoothly using `TweenService` and lerps between green and red based on health percentage. The health number updates every time health changes.

---

## Setup

1. Place `HealthBar.lua` in `StarterPlayerScripts` as a `LocalScript`
2. Adjust `CONFIG` at the top to match your game's style:

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

**Bar isn't showing**
Make sure the script is a `LocalScript` in `StarterPlayerScripts`, not a regular `Script`.

**Two health bars showing**
Roblox has a default health bar built in. Go to `StarterGui` and delete or disable the default `Health` ScreenGui.

**Bar doesn't reset on respawn**
The script reconnects automatically on `CharacterAdded` — make sure `ResetOnSpawn` hasn't been changed elsewhere.

---

## Notes

- No dependencies — drop it in and it works
- Works with any `MaxHealth` value, not just 100
- Automatically reconnects on respawn