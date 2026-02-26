local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CommandEvent  = ReplicatedStorage:WaitForChild("CommandEvent")
local ResponseEvent = ReplicatedStorage:WaitForChild("ResponseEvent")

local player = Players.LocalPlayer

-- Intercept outgoing messages to check for commands
TextChatService.OnIncomingMessage = function(message)
	local properties = Instance.new("TextChatMessageProperties")
	return properties
end

-- Listen for chat messages from the player
local TextChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

TextChannel.OnIncomingMessage = function(message)
	local properties = Instance.new("TextChatMessageProperties")

	-- Only process messages from that player
	if not message.TextSource or message.TextSource.UserId ~= player.UserId then
		return properties
	end

	local text = message.Text:lower()

	-- parse /kick <user> <reason>
	if text:sub(1, 5) == "/kick" then
		local args = {}
		for word in message.Text:sub(7):gmatch("%S+") do
			table.insert(args, word)
		end
		CommandEvent:FireServer("kick", args)
		properties.Text = ""
	end

	-- parse /ban <user> <time> <reason>
	if text:sub(1, 4) == "/ban" and text:sub(1, 6) ~= "/unban" then
		local args = {}
		for word in message.Text:sub(6):gmatch("%S+") do
			table.insert(args, word)
		end
		CommandEvent:FireServer("ban", args)
		properties.Text = ""
	end

	-- Parse /unban <userId>
	if text:sub(1, 6) == "/unban" then
		local args = {}
		for word in message.Text:sub(8):gmatch("%S+") do
			table.insert(args, word)
		end
		CommandEvent:FireServer("unban", args)
		properties.Text = ""
	end

	return properties
end

-- Show server feedback messages to the player
ResponseEvent.OnClientEvent:Connect(function(msg)
	local systemChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXSystem")
	systemChannel:DisplaySystemMessage(msg)
end)