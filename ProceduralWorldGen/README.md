# ProceduralWorldGenerator

Infinite smooth terrain generation using Perlin noise. Chunks load around players and unload when out of range. Fully modular — biomes, weather, and objects are all defined in simple tables you can extend without touching the core logic.

---

## Overview

The world is split into chunks. As players move, nearby chunks generate using `Terrain:FillBlock` for true smooth Roblox terrain. Height is determined by two layers of Perlin noise for a natural feel. The height at each point picks a biome which sets the terrain material. Water fills any area below the water level. Weather cycles randomly on a timer by adjusting `Lighting` properties. Objects can be dropped into the `OBJECTS` table and will spawn on valid surfaces automatically.

---

## Setup

1. Place `ProceduralWorldGenerator.lua` in `ServerScriptService` as a `Script`
2. Tune `CONFIG` at the top:

```lua
local CONFIG = {
	ChunkSize       = 64,    -- Studs per chunk
	RenderDistance  = 3,     -- Chunks loaded around each player
	HeightScale     = 60,    -- Max terrain height
	WaterLevel      = 10,    -- Water fills up to this Y value
	NoiseScale      = 0.004, -- Lower = smoother, Higher = jagged
	Seed            = math.random(1, 999999),
	WeatherEnabled  = true,
	WeatherInterval = 120,   -- Seconds between weather changes
}
```

---

## Adding Biomes

Add a new entry to the `BIOMES` table. Biomes are selected by height — the last one whose `MinHeight` the terrain clears wins:

```lua
{
	Name      = "Desert",
	MinHeight = CONFIG.WaterLevel + 5,
	Material  = Enum.Material.Sand,
	Color     = Color3.fromRGB(210, 180, 100),
},
```

---

## Adding Weather

Add a new entry to the `WEATHER` table. The `Apply` function runs when this weather is selected:

```lua
{
	Name = "Stormy",
	Apply = function()
		Lighting.FogEnd         = 500
		Lighting.FogColor       = Color3.fromRGB(60, 60, 70)
		Lighting.Brightness     = 0.2
		Lighting.Ambient        = Color3.fromRGB(50, 50, 60)
		Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 60)
	end,
},
```

---

## Adding Objects

Add a new entry to the `OBJECTS` table. The `Spawn` function receives the world `x`, `y` (surface + 2), and `z` position and must return a `Model` or `Part`:

```lua
{
	Chance    = 0.015,
	MinHeight = CONFIG.WaterLevel + 2,
	Spawn = function(x, y, z)
		local rock = Instance.new("Part")
		rock.Size     = Vector3.new(3, 2, 3)
		rock.Position = Vector3.new(x, y + 1, z)
		rock.Anchored = true
		rock.Material = Enum.Material.Rock
		rock.Name     = "Rock"
		return rock
	end,
},
```

---

## Troubleshooting

**Game is lagging**
Lower `RenderDistance` or raise the `step` variable inside `generateChunk`. Less resolution = faster generation.

**Terrain looks too flat or too spiky**
Raise `HeightScale` for more dramatic terrain. Adjust `NoiseScale` — lower is smoother, higher is more chaotic.

**Objects spawning underwater**
Set `MinHeight` on the object above `CONFIG.WaterLevel`. Example: `MinHeight = CONFIG.WaterLevel + 3`.

**Same world every run**
Change `Seed` to `math.random(1, 999999)`. Fix it to a number if you want a consistent world.

---

## Notes

- All generated chunks live under a `GeneratedChunks` folder in Workspace
- Fix `Seed` to a specific number to get the same world every server start
- Weather is purely visual — tie it to gameplay by reading `Lighting.FogEnd` or adding a `CurrentWeather` variable
- Only one object spawns per terrain sample point — the first one that passes its chance check wins