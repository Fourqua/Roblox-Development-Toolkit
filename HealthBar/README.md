# HealthBar

A HUD health bar that displays current and max health with a smooth animated fill. Color shifts from green to red as health drops. Fades out when full and reappears on damage.

---

## Overview

Builds a `ScreenGui` directly in the player's `PlayerGui` at runtime — no need to create any UI in Studio. The bar sits at the bottom center of the screen and animates smoothly using `TweenService` on every health change. The fill color lerps between green and red based on the health percentage. When health is full the bar fades out after a short delay to keep the screen clean.

---

## Setup

1. Place `HealthBar.lua` in `StarterPlayerScripts` as a `LocalScript`
2. Adjust `CONFIG` at the top to match your game's style:

```lua
local CONFIG = {
	BarWidth        = 300,
	BarHeight       = 20,
	AnimationTime   = 0.15,
	HideWhenFull    = true,
	FadeDelay       = 2,
	HealthyColor    = Color3.fromRGB(80, 200, 100),
	LowColor        = Color3.fromRGB(220, 60, 60),
	BackgroundColor = Color3.fromRGB(20, 20, 20),
	TextColor       = Color3.fromRGB(240, 240, 240),
}
```

---

## Examples

```lua
-- Always visible, no fade
HideWhenFull = false

-- Wider bar for a survival game feel
BarWidth  = 500
BarHeight = 28

-- Custom colors — blue health bar
HealthyColor = Color3.fromRGB(60, 140, 255)
LowColor     = Color3.fromRGB(180, 40, 200)
```

---

## Troubleshooting

**Bar isn't showing up**
Make sure the script is a `LocalScript` in `StarterPlayerScripts`, not a regular `Script`.

**Bar stays on screen when dead**
This is default Roblox behavior on respawn. The script reconnects automatically when the character respawns — if it persists, make sure `ResetOnSpawn` isn't interfering with your game's respawn setup.

**Health number shows decimals**
Roblox's `HealthChanged` can fire with float values. The script uses `math.floor` to keep it clean — adjust to `math.round` if you prefer rounding.

**Bar overlaps other HUD elements**
Adjust the `Position` of the `Container` frame inside the script. The default sits at the bottom center — move it anywhere using `UDim2`.

---

## Notes

- No dependencies — drop it in and it works with any game
- Automatically reconnects on character respawn
- Roblox's default health bar is still active — disable it in `StarterGui` by setting `ShowDevelopmentGui` to false, or remove the `Health` `ScreenGui` from `StarterGui`
- The bar works with any `MaxHealth` value, not just 100