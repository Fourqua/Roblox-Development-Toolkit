# StaminaManager

Sprint system with stamina. Hold shift to sprint — stamina drains while sprinting and regenerates when you stop.

---

## Overview

Runs on the client via `Heartbeat` every frame. While the player holds shift and is moving, stamina drains and speed increases. When shift is released or stamina hits zero, the player returns to walk speed. Stamina waits a short delay before regenerating, then fills back up over time. All values are tunable in the `CONFIG` table.

---

## Setup

1. Place `StaminaManager.lua` in `StarterCharacterScripts`. Must be a `LocalScript`
2. Adjust the `CONFIG` values to fit your game:

```lua
local CONFIG = {
	WalkSpeed   = 16,  -- Normal speed
	SprintSpeed = 28,  -- Speed while sprinting
	MaxStamina  = 100, -- Stamina pool size
	DrainRate   = 20,  -- Stamina lost per second while sprinting
	RegenRate   = 10,  -- Stamina regained per second while not sprinting
	RegenDelay  = 1,   -- Seconds before regen starts after stopping
}
```

---

## Examples

```lua
-- Fast drain, slow regen
DrainRate  = 35
RegenRate  = 8
RegenDelay = 2

-- Light stamina system
DrainRate  = 10
RegenRate  = 20
RegenDelay = 0.5
```

**Adding a UI stamina bar:**
In the script, uncomment the `staminaBar` line and point it to your UI element. The value `stamina / CONFIG.MaxStamina` gives you a 0–1 percentage you can apply to a frame's size.

---

## Troubleshooting

**Player sprints forever and stamina never drains**
Make sure the script is a `LocalScript` inside `StarterCharacterScripts`, not a regular `Script`.

**Speed doesn't reset after sprinting**
This can happen if the character respawns mid-sprint. Since the script is in `StarterCharacterScripts` it reloads fresh on every respawn, so this should resolve itself automatically.

**Stamina regenerates too fast or too slow**
Adjust `RegenRate` and `RegenDelay` in `CONFIG`. Increasing `RegenDelay` makes the player wait longer before any regen starts.

**Sprint isn't working on mobile**
This script uses keyboard input only. Mobile support would require a separate on-screen button wired to the same sprint logic.

---

## Notes

- Stamina only drains when the player is actually moving — holding shift while standing still does nothing
- Works out of the box with no dependencies
- UI bar support is included but commented out — hook it up to any `Frame` element