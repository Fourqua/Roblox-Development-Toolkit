# Dash

Press Q to dash in the direction you're moving.

---

## Overview

On Q press (or any button), the script reads the player's current move direction and applies a burst of horizontal velocity to the `HumanoidRootPart`. A cooldown prevents spamming. Everything can be tweaked in `CONFIG`.

---

## Setup

1. Place `DashManager.lua` in the `StarterCharacterScripts` as a `LocalScript`.
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
-- Short dash
DashPower = 50
Cooldown  = 0.5

-- Long dash
DashPower = 140
Cooldown  = 2

-- Change key to E
DashKey = Enum.KeyCode.E
```

---

## Troubleshooting

**Dash isn't firing** - 
Make sure the script is a `LocalScript` in the `StarterCharacterScripts`. Also check no other script is capturing Q input before this one.

**Dash goes the wrong direction** - 
The script uses `humanoid.MoveDirection` which follows WASD input. If you're not pressing a movement key it falls back to the camera's look direction.

**Dash feels too short or too long** - 
Increase or decrease `DashPower`.

---

## Notes

- Drop it in and it works
- Vertical velocity is preserved so dashing while jumping or falling works naturally