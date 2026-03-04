# DoubleJump

Lets the player jump a second time while in the air.

---

## Overview

System racks the player's `HumanoidState` to know when they are airborne. Once in freefall mode, a second space bar press applies an upward velocity to the `Player` for the second jump. Landing or touching the ground resets the double jump.

---

## Setup

1. Place `DoubleJump.lua` in the `StarterCharacterScripts` as a `LocalScript`.
2. Adjust `CONFIG` at the top to your liking:

```lua
local CONFIG = {
	DoubleJumpPower = 50, -- Higher = jumps higher on the second jump
}
```

---

## Examples

```lua
-- Floaty jump
DoubleJumpPower = 35

-- Aggressive jump
DoubleJumpPower = 80
```

---

## Troubleshooting

**Double jump isn't triggering** - 
Make sure the script is a `LocalScript` inside the `StarterCharacterScripts` folder, not `StarterPlayerScripts`.

**Player can double jump more than twice** - 
The `hasDoubleJumped` flag prevents this. If it's happening, check nothing else in your game is resetting the humanoid state.

**Double jump feels too weak or too strong** - 
Adjust `DoubleJumpPower` variable in the `CONFIG` taboe. The default of `50` matches roughly the height of the normal Roblox jump height.

---

## Notes

- Drop it in and it works No dependencies.
- Automatically resets on landing and reconnects on respawn.
- Only one double jump per airborne period — must land before jumping again.