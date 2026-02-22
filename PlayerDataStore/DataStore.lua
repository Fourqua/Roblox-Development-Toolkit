local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local store = DataStoreService:GetDataStore("PlayerData_v1")

local DEFAULT_DATA = {
	Coins = 0,
	Level = 1,
	XP    = 0,
}

local cache = {}

local function loadData(player)
	local success, saved = pcall(function()
		return store:GetAsync(tostring(player.UserId))
	end)

	local data = {}

	for key, default in pairs(DEFAULT_DATA) do
		data[key] = (success and saved and saved[key] ~= nil) and saved[key] or default
	end

	cache[player.UserId] = data
	print("[DataStore] Loaded data for " .. player.Name)
end

local function saveData(player)
	local data = cache[player.UserId]
	if not data then return end

	local success, err = pcall(function()
		store:SetAsync(tostring(player.UserId), data)
	end)

	if success then
		print("[DataStore] Saved data for " .. player.Name)
	else
		warn("[DataStore] Failed to save for " .. player.Name .. ": " .. tostring(err))
	end
end

local DataStore = {}

function DataStore.Get(player, key)
	local data = cache[player.UserId]
	return data and data[key]
end

function DataStore.Set(player, key, value)
	local data = cache[player.UserId]
	if data then
		data[key] = value
	end
end

function DataStore.Increment(player, key, amount)
	local current = DataStore.Get(player, key)
	if type(current) == "number" then
		DataStore.Set(player, key, current + (amount or 1))
	end
end

function DataStore.Save(player)
	saveData(player)
end

Players.PlayerAdded:Connect(loadData)

Players.PlayerRemoving:Connect(function(player)
	saveData(player)
	cache[player.UserId] = nil
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		saveData(player)
	end
end)

return DataStore