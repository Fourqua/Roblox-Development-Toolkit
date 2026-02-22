# StaminaManager

Sprint system with stamina. Hold shift to sprint. Stamina drains while sprinting and regenerates when you stop.

---

## Overview

While the player holds shift and is moving, the players stamina drains and speed increases. When shift is released or the stamina hits zero, the player returns to the default walk speed. Stamina waits a short delay before regenerating, then fills back up over time.

---

## Setup

1. Place `StaminaManager.lua` in `StarterCharacterScripts`. Must be a `LocalScript`
2. Adjust the `CONFIG` values to fit your game:

```lua
local CONFIG = {
	WalkSpeed    = 16,  -- default movement speed
	SprintSpeed  = 28,  -- speed while sprinting
	MaxStamina   = 100, -- max stamina
	DrainRate    = 20,  -- stamina lost per second while sprinting
	RegenRate    = 10,  -- stamina regained per second while not sprinting
	RegenDelay   = 1,   -- seconds after stopping sprint before regen kicks in
}
```

---

## Examples

```lua
-- Fast drain, slow regen
DrainRate  = 35
RegenRate  = 8
RegenDelay = 2

-- Slow drain, fast regen.
DrainRate  = 10
RegenRate  = 20
RegenDelay = 0.5
```

**Adding a UI stamina bar:**
In the script, uncomment the `staminaBar` line and link it to your UI element. The value `stamina / CONFIG.MaxStamina` gives you a 0–1 percentage you can apply to a frame's size.

---

## Troubleshooting

**Player sprints forever and stamina never drains**
Make sure the script is a `LocalScript` inside `StarterCharacterScripts`. It **CANNOT** be a regular `Script`.

**Speed doesn't reset after sprinting**
This can happen if the character respawns while sprinting. Since the script is in `StarterCharacterScripts`, it reloads on every respawn, so this should resolve itself automatically.

**Stamina regenerates too fast or too slow**
Adjust `RegenRate` and `RegenDelay` in the `CONFIG` table. Increasing `RegenDelay` makes the player wait longer before any regen starts.

---

## Notes

- Stamina only drains when the player is actually moving. This means holding shift while standing still does nothing
- Works out of the box with no dependencies
- UI bar support is included but commented out. To make it work, hook it up to any `Frame` element
