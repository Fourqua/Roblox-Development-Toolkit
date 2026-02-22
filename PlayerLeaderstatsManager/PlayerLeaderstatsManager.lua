local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- This is where we save all the player data
local store = DataStoreService:GetDataStore("LeaderstatsData_v1") -- Change this to a new name to reset the datastore. (Ex. LeaderstatsData_v2)

-- These are the stats every player starts with
local STATS = {
	Coins  = 0, -- Change or add anything to your liking
	Kills  = 0, -- Change or add anything to your liking
	Deaths = 0, -- Change or add anything to your liking
}

-- Temporary storage so we dont have to keep asking the datastore
local cache = {}

-- Loads the players saved data when they join
local function loadData(player)
	local success, saved = pcall(function()
		return store:GetAsync(tostring(player.UserId))
	end)

	-- If they have saved data use it, otherwise use the defaults
	local data = {}
	for key, default in pairs(STATS) do
		data[key] = (success and saved and saved[key] ~= nil) and saved[key] or default
	end

	cache[player.UserId] = data
	return data
end

-- Saves the players data to the datastore
local function saveData(player)
	local data = cache[player.UserId]
	if not data then return end -- Nothing to save, skip it

	local success, err = pcall(function()
		store:SetAsync(tostring(player.UserId), data)
	end)

	-- Print a warning if saving broke
	if not success then
		warn("[LeaderstatsManager] Failed to save for " .. player.Name .. ": " .. tostring(err))
	end
end

-- creates the leaderboard stats when a player joins
local function setupLeaderstats(player)
	local data = loadData(player)

	-- Make the leaderstats folder 
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local statObjects = {}

	-- Make a value object for each stat
	for key, value in pairs(STATS) do
		local stat = Instance.new("IntValue")
		stat.Name = key
		stat.Value = data[key] ~= nil and data[key] or value
		stat.Parent = leaderstats
		statObjects[key] = stat

		-- Whenever the stat changes, update the cache too
		stat.Changed:Connect(function(newValue)
			if cache[player.UserId] then
				cache[player.UserId][key] = newValue
			end
		end)
	end
end

local LeaderstatsManager = {}

-- Get a players stat number from the cache
function LeaderstatsManager.Get(player, key)
	local data = cache[player.UserId]
	return data and data[key]
end

-- Change a players stat to a new number
function LeaderstatsManager.Set(player, key, value)
	-- Update the leaderboard so the player can see it
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local stat = leaderstats:FindFirstChild(key)
		if stat then
			stat.Value = value
		end
	end
	-- update the cache
	if cache[player.UserId] then
		cache[player.UserId][key] = value
	end
end

-- Add to a stat
function LeaderstatsManager.Increment(player, key, amount)
	local current = LeaderstatsManager.Get(player, key)
	if type(current) == "number" then
		LeaderstatsManager.Set(player, key, current + (amount or 1)) -- Amount defaults to 1 if you dont give a number
	end
end

-- Manually save a player right now
function LeaderstatsManager.Save(player)
	saveData(player)
end

-- Setup stats when someone joins the game
Players.PlayerAdded:Connect(setupLeaderstats)

-- Save and clean up when someone leaves
Players.PlayerRemoving:Connect(function(player)
	saveData(player)
	cache[player.UserId] = nil -- remove from cache so we dont waste memory
end)

-- Save everyone when the server shuts down so no data is lost
game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		saveData(player)
	end
end)

return LeaderstatsManager