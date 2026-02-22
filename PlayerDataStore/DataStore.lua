local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- v1 in the name lets you version up later without taking out old stores
-- Simply switch it out with v2 and a new datastore will load
local store = DataStoreService:GetDataStore("PlayerData_v1")

-- Default values for new players
local DEFAULT_DATA = {
	Coins = 0, --Changable
	Level = 1, --Changable
	XP    = 0, --Changable
}

-- Holds player data in memory while they're in game
local cache = {}

local function loadData(player)
	-- Fetch from DataStore
	local success, saved = pcall(function()
		return store:GetAsync(tostring(player.UserId)) -- UserId as string key
	end)

	local data = {}

	-- Use saved value if it exists. It if doesn't, fall back to default
	for key, default in pairs(DEFAULT_DATA) do
		data[key] = (success and saved and saved[key] ~= nil) and saved[key] or default
	end

	-- Store in cache so the rest of the game can access it
	cache[player.UserId] = data
	print("[DataStore] Loaded data for " .. player.Name)
end

local function saveData(player)
	local data = cache[player.UserId]
	if not data then return end -- Nothing to save

	-- Write to DataStore
	local success, err = pcall(function()
		store:SetAsync(tostring(player.UserId), data)
	end)
    -- Print message if data sucessfully saves
	if success then
		print("[DataStore] Saved data for " .. player.Name)
	else
		-- Warning if data fails to save
		warn("[DataStore] Failed to save for " .. player.Name .. ": " .. tostring(err))
	end
end

-- Public API table, returned at the bottom
local DataStore = {}

-- Returns nil if the player isn't loaded yet
function DataStore.Get(player, key)
	local data = cache[player.UserId]
	return data and data[key]
end

-- Does nothing if the player has no cache entry
function DataStore.Set(player, key, value)
	local data = cache[player.UserId]
	if data then
		data[key] = value
	end
end

-- Only works on number values
function DataStore.Increment(player, key, amount)
	local current = DataStore.Get(player, key)
	if type(current) == "number" then
		DataStore.Set(player, key, current + (amount or 1)) -- Defaults to +1 if no amount given
	end
end

-- Exposed so other scripts can trigger a manual save if needed
function DataStore.Save(player)
	saveData(player)
end

-- Load data when the player joins
Players.PlayerAdded:Connect(loadData)

Players.PlayerRemoving:Connect(function(player)
	saveData(player)
	cache[player.UserId] = nil -- Clean up
end)

-- Catches a server shutdown so no data is lost on close
game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		saveData(player)
	end
end)

return DataStore