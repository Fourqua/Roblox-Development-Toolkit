# FallDamageManager

Fall damage system for Roblox. The higher a player falls from, the more damage they take.

---

## Overview

Tracks each player's peak height while in the air. On landing, the script calculates how far they fell and applies a scaled damage. Only falls past a set threshold will damage the player. All tuning is done in the `CONFIG` table at the top of the script.

---

## Setup

1. Place `FallDamageManager.lua` in `ServerScriptService` as a `Script`
2. Configurate `MinHeight`, `DamagePerStud`, and `MaxDamage` in the `CONFIG` table to fit your games preferences

---

## Examples

```lua
-- Intense FPS game
MinHeight     = 8
DamagePerStud = 5
MaxDamage     = 100

-- Casual survival game
MinHeight     = 25
DamagePerStud = 1
MaxDamage     = 50
```

---

## Troubleshooting

**Fall damage isn't triggering**
Make sure the script is a `Script` inside `ServerScriptService`.

**Players dying from very short falls**
Decrease `DamagePerStud` or raise `MinHeight` in the `CONFIG` table.

**Players take damage on respawn**
Increase `MinHeight` slightly to give a buffer for the spawn drop.

---

## Notes

- Peak Y axis value resets on each jump so multi-bounce falls are handled correctly
- Does not interfere with `Humanoid.Health` therefore meaning that low HP players can still be killed by a fall big enough