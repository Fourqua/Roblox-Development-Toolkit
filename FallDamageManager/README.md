# FallDamageManager
Fall damage system for Roblox. The faster a player is falling when they land, the more damage they take.

---

## Overview
This fall damage system tracks the player's downward velocity on landing and applies certain amount of damage based on how fast they were falling. Only falls past a set threshold will damage the player. Tweaks and Tunes can be done in the `CONFIG` table.

---

## Setup
1. Place `FallDamageManager.lua` in `ServerScriptService` as a `Script`
2. Configure `MinFallDistance` and `MaxFallDistance` in the `CONFIG` table to fit your game's preferences and likings.

---

## Examples
​```lua
-- Intense FPS game
MinFallDistance = 25
MaxFallDistance = 75

-- Calm survival game
MinFallDistance = 50
MaxFallDistance = 120
​```

---

## Troubleshooting
**Fall damage isn't triggering**
Make sure the script is a `Script` inside `ServerScriptService`

**Players dying from very short falls**
Raise `MinFallDistance` in the `CONFIG` table.

**Players taking damage from a normal jump**
`MinFallDistance` is too low. Try a value around `40` or higher.

---

## Notes
- Damage is based on landing velocity, not height. This means falling through the air for longer will hurt me.
- Instant kill value is controlled by `MaxFallDistance`
- Does not set `Humanoid.Health` to a fixed value, so low HP players can still be finished off by a smaller fall