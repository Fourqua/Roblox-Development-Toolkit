# Dash

Press Q to dash in the direction you're moving. If you're standing still, dashes toward where the camera is looking.

---

## Overview

On Q press, the script reads the player's current move direction and applies a burst of horizontal velocity to the `HumanoidRootPart`. Vertical velocity is preserved so dashing mid-air feels natural. A cooldown prevents spamming. Everything is tunable in `CONFIG`.

---

## Setup

1. Place `Dash.lua` in `StarterCharacterScripts` as a `LocalScript`
2. Adjust `CONFIG` at the top:

```lua
local CONFIG = {
	DashPower = 80,              -- Higher = longer dash
	Cooldown  = 1,               -- Seconds before dashing again
	DashKey   = Enum.KeyCode.Q,  -- Change to any key
}
```

---

## Examples

```lua
-- Short snappy dash
DashPower = 50
Cooldown  = 0.5

-- Long aggressive dash
DashPower = 140
Cooldown  = 2

-- Change key to E
DashKey = Enum.KeyCode.E
```

---

## Troubleshooting

**Dash isn't firing**
Make sure the script is a `LocalScript` in `StarterCharacterScripts`. Also check no other script is capturing Q input before this one (`gameProcessed` will be true if a UI element has focus).

**Dash goes the wrong direction**
The script uses `humanoid.MoveDirection` which follows WASD input. If you're not pressing a movement key it falls back to the camera's look direction.

**Dash feels too short or too long**
Increase or decrease `DashPower`. The right value depends on your game's walkspeed and map scale.

---

## Notes

- No dependencies — drop it in and it works
- Vertical velocity is preserved so dashing while jumping or falling works naturally
- Automatically reconnects on respawn