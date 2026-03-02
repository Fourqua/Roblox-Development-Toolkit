
local Players           = game:GetService("Players")
local TextChatService   = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Remote Events
local GiveCommandEvent  = ReplicatedStorage:WaitForChild("GiveCommandEvent")
local GiveResponseEvent = ReplicatedStorage:WaitForChild("GiveResponseEvent")

-- Listen for /give typed in the chat 
local TextChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

TextChannel.OnIncomingMessage = function(message)
	local properties = Instance.new("TextChatMessageProperties")

	if not message.TextSource then return properties end
	if message.TextSource.UserId ~= player.UserId then return properties end

	local text = message.Text

	-- Match the command /give <player> <item>
	if text:lower():sub(1, 5) == "/give" then
		local args = {}
		for word in text:sub(7):gmatch("%S+") do
			table.insert(args, word)
		end

		local targetName = args[1]
		local itemName   = args[2]

		GiveCommandEvent:FireServer(targetName, itemName)

		-- Hide the command from the chat
		properties.Text = ""
	end

	return properties
end

-- Show server response as a message
GiveResponseEvent.OnClientEvent:Connect(function(msg)
	local systemChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXSystem")
	systemChannel:DisplaySystemMessage(msg)
end)