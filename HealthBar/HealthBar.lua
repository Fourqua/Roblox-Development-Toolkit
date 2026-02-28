local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")

-- CONFIG: Change these values to your liking
local CONFIG = {
	BarWidth     = 300,
	BarHeight    = 22,
	HealthyColor = Color3.fromRGB(80, 200, 100),
	LowColor     = Color3.fromRGB(220, 60, 60),
}

-- BUILD UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name         = "HealthBarGui"
screenGui.ResetOnSpawn = false
screenGui.Parent       = player.PlayerGui

-- Background track
local background = Instance.new("Frame")
background.Size             = UDim2.new(0, CONFIG.BarWidth, 0, CONFIG.BarHeight)
background.Position         = UDim2.new(0.5, -CONFIG.BarWidth / 2, 1, -55)
background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
background.BorderSizePixel  = 0
background.Parent           = screenGui
Instance.new("UICorner", background).CornerRadius = UDim.new(0, 6)

-- Fill bar
local fill = Instance.new("Frame")
fill.Size             = UDim2.new(1, 0, 1, 0)
fill.BackgroundColor3 = CONFIG.HealthyColor
fill.BorderSizePixel  = 0
fill.Parent           = background
Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)

-- Health number
local label = Instance.new("TextLabel")
label.Size                 = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.TextColor3           = Color3.fromRGB(255, 255, 255)
label.TextSize             = 13
label.Font                 = Enum.Font.GothamBold
label.ZIndex               = 3
label.Parent               = background

-- UPDATE FUNCTION
local function lerpColor(a, b, t)
	return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end

local function update(health, maxHealth)
	local pct = math.clamp(health / maxHealth, 0, 1)

	TweenService:Create(fill, TweenInfo.new(0.15), {
		Size             = UDim2.new(pct, 0, 1, 0),
		BackgroundColor3 = lerpColor(CONFIG.LowColor, CONFIG.HealthyColor, pct),
	}):Play()

	label.Text = math.floor(health) .. " / " .. math.floor(maxHealth)
end

-- CONNECT
update(humanoid.Health, humanoid.MaxHealth)

humanoid.HealthChanged:Connect(function(health)
	update(health, humanoid.MaxHealth)
end)

player.CharacterAdded:Connect(function(newChar)
	humanoid = newChar:WaitForChild("Humanoid")
	update(humanoid.Health, humanoid.MaxHealth)
	humanoid.HealthChanged:Connect(function(health)
		update(health, humanoid.MaxHealth)
	end)
end)