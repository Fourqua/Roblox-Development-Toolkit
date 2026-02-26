-- Big thanks to tjwy for most of this code. Much Appreciated! 

local Workspace  = game:GetService("Workspace")
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting   = game:GetService("Lighting")

local terrain = Workspace.Terrain


-- CONFIG: Change these values to your liking
local CONFIG = {
	ChunkSize        = 64,                     -- Studs per chunk
	RenderDistance   = 3,                      -- Chunk radius loaded around each player
	HeightScale      = 60,                     -- Max terrain height variation
	WaterLevel       = 10,                     -- Height water fills up to
	NoiseScale       = 0.004,                  -- Lower = smoother, Higher = more jagged
	Seed             = math.random(1, 999999), -- Fix to a number for a consistent world
	WeatherEnabled   = true,                   -- Toggle weather system on/off
	WeatherInterval  = 120,                    -- Seconds between weather changes
}



-- Biomes determine terrain material and color based on height.
-- Checked bottom to top. last matching MinHeight wins.
--
-- Heres how to add a biome:
--   { Name = "Name", MinHeight = Y, Material = Enum.Material.X, Color = Color3.fromRGB() }

local BIOMES = {
	{
		Name      = "Ocean",
		MinHeight = -math.huge,
		Material  = Enum.Material.Sand,
		Color     = Color3.fromRGB(194, 178, 128),
	},
	{
		Name      = "Beach",
		MinHeight = CONFIG.WaterLevel - 2,
		Material  = Enum.Material.Sand,
		Color     = Color3.fromRGB(220, 200, 140),
	},
	{
		Name      = "Grassland",
		MinHeight = CONFIG.WaterLevel + 2,
		Material  = Enum.Material.Grass,
		Color     = Color3.fromRGB(106, 162, 75),
	},
	{
		Name      = "Forest",
		MinHeight = CONFIG.WaterLevel + 10,
		Material  = Enum.Material.Grass,
		Color     = Color3.fromRGB(72, 120, 50),
	},
	{
		Name      = "Mountain",
		MinHeight = CONFIG.WaterLevel + 25,
		Material  = Enum.Material.Rock,
		Color     = Color3.fromRGB(120, 110, 100),
	},
	{
		Name      = "Snow",
		MinHeight = CONFIG.WaterLevel + 40,
		Material  = Enum.Material.Glacier,
		Color     = Color3.fromRGB(220, 230, 240),
	},
}

-- WEATHER
-- Each entry runs when randomly selected by the weather loop.
-- Heres how to add weather:
--   { Name = "Name", Apply = function() -- set Lighting properties end }

local WEATHER = {
	{
		Name = "Clear",
		Apply = function()
			Lighting.FogEnd         = 100000
			Lighting.Brightness     = 1
			Lighting.Ambient        = Color3.fromRGB(100, 100, 100)
			Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
		end,
	},
	{
		Name = "Overcast",
		Apply = function()
			Lighting.FogEnd         = 2000
			Lighting.FogColor       = Color3.fromRGB(180, 180, 180)
			Lighting.Brightness     = 0.5
			Lighting.Ambient        = Color3.fromRGB(80, 80, 90)
			Lighting.OutdoorAmbient = Color3.fromRGB(80, 80, 90)
		end,
	},
	{
		Name = "Foggy",
		Apply = function()
			Lighting.FogEnd         = 300
			Lighting.FogStart       = 10
			Lighting.FogColor       = Color3.fromRGB(200, 200, 210)
			Lighting.Brightness     = 0.4
			Lighting.Ambient        = Color3.fromRGB(90, 90, 100)
			Lighting.OutdoorAmbient = Color3.fromRGB(90, 90, 100)
		end,
	},
	{
		Name = "Night",
		Apply = function()
			Lighting.FogEnd         = 100000
			Lighting.Brightness     = 0
			Lighting.Ambient        = Color3.fromRGB(20, 20, 40)
			Lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 40)
		end,
	},
}

-- 
-- OBJECTS
-- Spawned on terrain surfaces after a chunk generates.
-- To add an object:
--   {
--     Chance    = 0.02,            -- 0 to 1 spawn probability per point
--     MinHeight = CONFIG.WaterLevel + 2,
--     Spawn = function(x, y, z)
--       -- build your object here, return a Model or Part
--     end,
--   }
-- A tree example is included below but commented out.

local OBJECTS = {

	--[[
	-- Tree
	{
		Chance    = 0.02,
		MinHeight = CONFIG.WaterLevel + 2,
		Spawn = function(x, y, z)
			local trunk = Instance.new("Part")
			trunk.Size     = Vector3.new(2, 8, 2)
			trunk.Position = Vector3.new(x, y + 4, z)
			trunk.Anchored = true
			trunk.Material = Enum.Material.Wood
			trunk.BrickColor = BrickColor.new("Reddish brown")

			local leaves = Instance.new("Part")
			leaves.Shape     = Enum.PartType.Ball
			leaves.Size      = Vector3.new(10, 10, 10)
			leaves.Position  = Vector3.new(x, y + 12, z)
			leaves.Anchored  = true
			leaves.Material  = Enum.Material.Grass
			leaves.BrickColor = BrickColor.new("Bright green")

			local model = Instance.new("Model")
			model.Name    = "Tree"
			trunk.Parent  = model
			leaves.Parent = model
			return model
		end,
	},
	]]

}

local loadedChunks = {}

local chunkFolder = Instance.new("Folder")
chunkFolder.Name   = "GeneratedChunks"
chunkFolder.Parent = Workspace

-- Returns the correct biome for a given height
local function getBiome(height)
	local result = BIOMES[1]
	for _, biome in ipairs(BIOMES) do
		if height >= biome.MinHeight then
			result = biome
		end
	end
	return result
end

-- Two-octave Perlin noise for natural-looking terrain
local function getHeight(x, z)
	local nx     = x * CONFIG.NoiseScale + CONFIG.Seed
	local nz     = z * CONFIG.NoiseScale + CONFIG.Seed
	local base   = math.noise(nx, nz)
	local detail = math.noise(nx * 3, nz * 3) * 0.3
	return (base + detail) * CONFIG.HeightScale
end

local function chunkKey(cx, cz)
	return cx .. "," .. cz
end

local function generateChunk(cx, cz)
	local key = chunkKey(cx, cz)
	if loadedChunks[key] then return end

	local originX = cx * CONFIG.ChunkSize
	local originZ = cz * CONFIG.ChunkSize
	local step    = 4

	local chunkModel = Instance.new("Model")
	chunkModel.Name   = "Chunk_" .. key
	chunkModel.Parent = chunkFolder

	for lx = 0, CONFIG.ChunkSize - 1, step do
		for lz = 0, CONFIG.ChunkSize - 1, step do
			local wx     = originX + lx
			local wz     = originZ + lz
			local height = getHeight(wx, wz)
			local biome  = getBiome(height)

			-- Fill solid terrain from deep underground up to the surface
			terrain:FillBlock(
				CFrame.new(wx, height / 2, wz),
				Vector3.new(step, math.abs(height) + 20, step),
				biome.Material
			)

			-- Fill water in low areas below the water level
			if height < CONFIG.WaterLevel then
				terrain:FillBlock(
					CFrame.new(wx, (height + CONFIG.WaterLevel) / 2, wz),
					Vector3.new(step, CONFIG.WaterLevel - height, step),
					Enum.Material.Water
				)
			end

			-- Try spawning objects on the surface
			for _, obj in ipairs(OBJECTS) do
				if height >= obj.MinHeight and math.random() < obj.Chance then
					local spawned = obj.Spawn(wx, height + 2, wz)
					if spawned then
						spawned.Parent = chunkModel
					end
					break
				end
			end
		end
	end

	loadedChunks[key] = chunkModel
end

local function unloadChunk(key)
	local model = loadedChunks[key]
	if not model then return end

	local parts = key:split(",")
	local cx = tonumber(parts[1])
	local cz = tonumber(parts[2])
	local ox = cx * CONFIG.ChunkSize
	local oz = cz * CONFIG.ChunkSize

	-- Clear terrain in this chunk by filling with Air
	terrain:FillBlock(
		CFrame.new(ox + CONFIG.ChunkSize / 2, 0, oz + CONFIG.ChunkSize / 2),
		Vector3.new(CONFIG.ChunkSize, CONFIG.HeightScale * 3, CONFIG.ChunkSize),
		Enum.Material.Air
	)

	model:Destroy()
	loadedChunks[key] = nil
end

local function getNeededChunks(position)
	local cx = math.floor(position.X / CONFIG.ChunkSize)
	local cz = math.floor(position.Z / CONFIG.ChunkSize)
	local needed = {}
	local r = CONFIG.RenderDistance
	for dx = -r, r do
		for dz = -r, r do
			needed[chunkKey(cx + dx, cz + dz)] = true
		end
	end
	return needed
end

-- Thy weather loop

if CONFIG.WeatherEnabled and #WEATHER > 0 then
	task.spawn(function()
		while true do
			local weather = WEATHER[math.random(1, #WEATHER)]
			print("[WorldGen] Weather: " .. weather.Name)
			weather.Apply()
			task.wait(CONFIG.WeatherInterval)
		end
	end)
end

-- Main loop
RunService.Heartbeat:Connect(function()
	local allNeeded = {}

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			for key in pairs(getNeededChunks(character.HumanoidRootPart.Position)) do
				allNeeded[key] = true
			end
		end
	end

	for key in pairs(allNeeded) do
		if not loadedChunks[key] then
			local parts = key:split(",")
			generateChunk(tonumber(parts[1]), tonumber(parts[2]))
		end
	end

	for key in pairs(loadedChunks) do
		if not allNeeded[key] then
			unloadChunk(key)
		end
	end
end)