--[[
	HealthBar.lua
	Displays a HUD health bar with current and max health numbers.
	Smoothly animates on damage and healing. Hides when full.
	Place in: StarterPlayerScripts as a LocalScript
--]]

local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")

-- ============================================================
-- CONFIG
-- ============================================================

local CONFIG = {
	BarWidth        = 300,   -- Width of the health bar in pixels
	BarHeight       = 20,    -- Height of the health bar in pixels
	AnimationTime   = 0.15,  -- Seconds to animate health change
	HideWhenFull    = true,  -- Hide the bar when at max health
	FadeDelay       = 2,     -- Seconds after full health before fading out
	HealthyColor    = Color3.fromRGB(80, 200, 100),  -- Full health color
	LowColor        = Color3.fromRGB(220, 60, 60),   -- Low health color
	BackgroundColor = Color3.fromRGB(20, 20, 20),    -- Bar background
	TextColor       = Color3.fromRGB(240, 240, 240), -- Health number color
}

-- ============================================================
-- BUILD UI
-- ============================================================

-- Remove any existing HealthBar GUI to avoid duplicates on respawn
local existing = player.PlayerGui:FindFirstChild("HealthBarGui")
if existing then existing:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name            = "HealthBarGui"
screenGui.ResetOnSpawn    = false
screenGui.IgnoreGuiInset  = false
screenGui.Parent          = player.PlayerGui

-- Container — sits at the bottom center of the screen
local container = Instance.new("Frame")
container.Name            = "Container"
container.Size            = UDim2.new(0, CONFIG.BarWidth + 20, 0, CONFIG.BarHeight + 30)
container.Position        = UDim2.new(0.5, -(CONFIG.BarWidth / 2 + 10), 1, -60)
container.BackgroundTransparency = 1
container.Parent          = screenGui

-- Background track
local barBackground = Instance.new("Frame")
barBackground.Name              = "Background"
barBackground.Size              = UDim2.new(0, CONFIG.BarWidth, 0, CONFIG.BarHeight)
barBackground.Position          = UDim2.new(0, 10, 0, 0)
barBackground.BackgroundColor3  = CONFIG.BackgroundColor
barBackground.BorderSizePixel   = 0
barBackground.Parent            = container

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 6)
bgCorner.Parent       = barBackground

-- Health fill bar
local barFill = Instance.new("Frame")
barFill.Name             = "Fill"
barFill.Size             = UDim2.new(1, 0, 1, 0)
barFill.Position         = UDim2.new(0, 0, 0, 0)
barFill.BackgroundColor3 = CONFIG.HealthyColor
barFill.BorderSizePixel  = 0
barFill.ZIndex           = 2
barFill.Parent           = barBackground

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 6)
fillCorner.Parent       = barFill

-- Health number label (e.g. "85 / 100")
local healthLabel = Instance.new("TextLabel")
healthLabel.Name                 = "HealthLabel"
healthLabel.Size                 = UDim2.new(0, CONFIG.BarWidth, 0, 18)
healthLabel.Position             = UDim2.new(0, 10, 0, CONFIG.BarHeight + 4)
healthLabel.BackgroundTransparency = 1
healthLabel.TextColor3           = CONFIG.TextColor
healthLabel.TextSize             = 13
healthLabel.Font                 = Enum.Font.GothamBold
healthLabel.TextXAlignment       = Enum.TextXAlignment.Center
healthLabel.ZIndex               = 3
healthLabel.Parent               = container

-- ============================================================
-- LOGIC
-- ============================================================

local fadeThread = nil

-- Lerp between two Color3 values by a 0–1 alpha
local function lerpColor(a, b, alpha)
	return Color3.new(
		a.R + (b.R - a.R) * alpha,
		a.G + (b.G - a.G) * alpha,
		a.B + (b.B - a.B) * alpha
	)
end

local function updateBar(health, maxHealth)
	local pct = math.clamp(health / maxHealth, 0, 1)

	-- Animate bar width
	TweenService:Create(barFill, TweenInfo.new(CONFIG.AnimationTime), {
		Size = UDim2.new(pct, 0, 1, 0)
	}):Play()

	-- Color shifts from healthy green → red as health drops
	TweenService:Create(barFill, TweenInfo.new(CONFIG.AnimationTime), {
		BackgroundColor3 = lerpColor(CONFIG.LowColor, CONFIG.HealthyColor, pct)
	}):Play()

	-- Update health number text
	healthLabel.Text = math.floor(health) .. " / " .. math.floor(maxHealth)

	-- Handle show/hide when full
	if CONFIG.HideWhenFull then
		-- Cancel any existing fade thread
		if fadeThread then
			task.cancel(fadeThread)
			fadeThread = nil
		end

		if pct >= 1 then
			-- Fade out after delay
			fadeThread = task.delay(CONFIG.FadeDelay, function()
				TweenService:Create(container, TweenInfo.new(0.5), {
					GroupTransparency = 1
				}):Play()
			end)
		else
			-- Instantly show
			container.GroupTransparency = 0
		end
	end
end

-- Initial render
updateBar(humanoid.Health, humanoid.MaxHealth)

-- Update on health change
humanoid.HealthChanged:Connect(function(health)
	updateBar(health, humanoid.MaxHealth)
end)

-- Re-run setup on respawn
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid  = newCharacter:WaitForChild("Humanoid")
	updateBar(humanoid.Health, humanoid.MaxHealth)
	humanoid.HealthChanged:Connect(function(health)
		updateBar(health, humanoid.MaxHealth)
	end)
end)