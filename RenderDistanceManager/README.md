# RenderDistance

Hides parts and models that are beyond a certain distance from the player. Runs client side so each player manages their own view.

---

## Overview

Every `CheckInterval` seconds, the script measures the distance from the player's `HumanoidRootPart` to every managed part in the workspace. Parts beyond `RenderDistance` studs are hidden, and parts within range are shown. Character parts for all players are excluded.

---

## Setup

1. Place `RenderDistance.lua` in the `StarterPlayerScripts` as a `LocalScript`.
2. Adjust `CONFIG` settings at the top:

```lua
local CONFIG = {
	RenderDistance = 300,   -- Studs before parts are hidden
	CheckInterval  = 0.5,   -- Seconds between checks
	FadeEnabled    = true,  -- Fade in/out instead of popping
	FadeTime       = 0.3,   -- Fade duration in seconds
}
```

---

## Examples

```lua
-- Tight render distance
RenderDistance = 80
FadeEnabled    = true

-- Instant pop
RenderDistance = 600
FadeEnabled    = false

-- Frequent checks for fast players
CheckInterval  = 0.1
```

---

## Troubleshooting

**Parts are flickering**
Increase `CheckInterval` slightly. Flickering usually means the part is right on the edge of the render distance and toggling every frame.

**Player characters are disappearing**
The script excludes character parts automatically. If it's still happening, make sure the characters are properly parented under `Players` and not directly in `Workspace` as a custom setup.

**Performance is poor in large maps**
Increase `CheckInterval` to reduce how often checks run, or increase `RenderDistance` so fewer parts are toggling per cycle.

---

## Notes

- Runs client-side — each player has their own independent render distance
- Character parts for all players are always excluded
- Uses squared distance comparison to avoid expensive `math.sqrt` calls every frame
- Parts are hidden visually only — they still exist physically and can still collide