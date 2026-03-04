# DoubleJump

Lets players jump a second time while in the air. First space bar jump works as normal, second jump while airborne launches them back up.

---

## Overview

Tracks the player's `HumanoidState` to know when they're airborne. Once in freefall, a second space bar press applies an upward velocity to the `HumanoidRootPart` for the second jump. Landing or touching the ground resets the double jump so it's ready for next time.

---

## Setup

1. Place `DoubleJump.lua` in `StarterCharacterScripts` as a `LocalScript`
2. Adjust `CONFIG` at the top:

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

**Double jump isn't triggering**
Make sure the script is a `LocalScript` in `StarterCharacterScripts`, not `StarterPlayerScripts`. It needs to reload with the character.

**Player can double jump more than twice**
The `hasDoubleJumped` flag prevents this — if it's happening, check nothing else in your game is resetting the humanoid state unexpectedly.

**Double jump feels too weak or too strong**
Adjust `DoubleJumpPower` in `CONFIG`. The default of `50` matches roughly the height of a normal Roblox jump.

---

## Notes

- No dependencies — drop it in and it works
- Automatically resets on landing and reconnects on respawn
- Only one double jump per airborne period — must land before jumping again