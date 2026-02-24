# DayNightCycle

Cycles through day and night on a tweakable timer.

---

## Overview

Runs server side on every frame using `Heartbeat`. Increments `Lighting` clock based on how much real time has passed, scaled to your configured day length. The cycle loops continuously and all players see the same time in sync.

---

## Setup

1. Place `DayNightCycle.lua` in the `ServerScriptService` as a `Script`
2. Tweak `CONFIG` at the top to your liking:

```lua
local CONFIG = {
	DayLength = 240, -- length of a full day/night cycle in seconds
	StartTime = 8,   -- hour the server starts at (0-24 hours)
}
```

---

## Examples

```lua
-- Fast cycle
DayLength = 60

-- Slow cycle
DayLength = 1200

-- Starts at midnight
StartTime = 0

-- Starts at sunset
StartTime = 18
```

---

## Troubleshooting

**Time isn't changing** - 
Make sure the script is a regular `Script` in `ServerScriptService` (MAKE SURE IT IS **NOT** a `LocalScript`)

**Sky looks wrong at certain times** - 
Roblox's default sky handles lighting automatically. If you have a custom `Sky` object in `Lighting` make sure that it's set up correctly for day and night cycles.

**Cycle is too fast or too slow** - 
Increase `DayLength` to slow it down, decrease it to speed it up.

---

## Notes

- No dependencies. Paste in the code and it works.
- All players see the same time since it runs on the server.
- Works with Roblox's built in atmosphere and sky.