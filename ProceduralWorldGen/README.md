# ProceduralWorldGenerator

Infinite terrain generation. Chunks load around players and unload when out of range. This system is compatible with biomes, weather, and objects. They are all defined in simple tables you can extend without touching the main logic.

---

## Overview

The world is split into chunks, kinda like minecraft. As players move, nearby chunks generate using `Terrain:FillBlock` for true Roblox terrain. Height is determined by two layers of Perlin noise for a natural feel. The height at each point picks a biome which sets the terrain material. Water fills any area below the water level. Weather cycles randomly on a timer by adjusting `Lighting` properties. Objects can be dropped into the `OBJECTS` table and will spawn on surfaces automatically.

---

## Setup

1. Place `ProceduralWorldGenerator.lua` in the `ServerScriptService` as a `Script`.
2. Tweak `CONFIG` at the top to your liking:

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

Add a new entry to the `BIOMES` table. Biomes are selected by height. The last one whose `MinHeight` the terrain clears wins

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

Add a new entry to the `WEATHER` table. The `Apply` function runs when this weather is selected

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

Add a new entry to the `OBJECTS` table. The `Spawn` function receives the world `x`, `y` (surface + 2), and `z` position and must return a `Model` or `Part`

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

**Game is lagging** - 
Lower the `RenderDistance` or raise the `step` variable inside `generateChunk`.

**Terrain looks too flat or too spiky** - 
Raise `HeightScale` for more dramatic terrain. Adjust `NoiseScale`. The lower is smoother, higher is more chaotic.

**Objects spawning underwater** - 
Set `MinHeight` on the object above `CONFIG.WaterLevel`. Example: `MinHeight = CONFIG.WaterLevel + 3`.

**Same world every run** - 
Change `Seed` to `math.random(1, 999999)`.

---

## Notes

- All generated chunks live under a `GeneratedChunks` folder in the `Workspace`.
- Fix the `Seed` to a specific number to get the same world every server start.
- Weather is purely visual. Tie it to gameplay by reading `Lighting.FogEnd` or adding a `CurrentWeather` variable.
- This system is modular. You can easily add or change anything that fits into your game.