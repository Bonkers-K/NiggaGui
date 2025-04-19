local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Create GUI
local Gui = Instance.new("ScreenGui")
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

-- Create Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
MainFrame.BorderSizePixel = 0
MainFrame.Rotation = -90
MainFrame.Visible = true
MainFrame.Parent = Gui

-- Initial bounce tween
local crazyTweenInfo = TweenInfo.new(
	0.8,
	Enum.EasingStyle.Bounce,
	Enum.EasingDirection.Out
)

local crazyTweenGoals = {
	Size = UDim2.new(0, 300, 0, 200),
	Rotation = 15,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255)
}

local crazyTween = TweenService:Create(MainFrame, crazyTweenInfo, crazyTweenGoals)

-- Final sleek menu tween
local finalTweenInfo = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local finalTweenGoals = {
	Size = UDim2.new(0, 600, 0, 300),
	Rotation = 0,
	BackgroundColor3 = Color3.fromRGB(20, 20, 20)
}

local finalTween = TweenService:Create(MainFrame, finalTweenInfo, finalTweenGoals)

-- Play tweens
crazyTween:Play()
crazyTween.Completed:Connect(function()
	wait(0.2)
	finalTween:Play()
end)

finalTween.Completed:Connect(function()
	local SecondaryFrame = Instance.new("Frame")
	SecondaryFrame.Size = UDim2.new(0, 558, 0, 261)
	SecondaryFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	SecondaryFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	SecondaryFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
	SecondaryFrame.BorderSizePixel = 0
	SecondaryFrame.Parent = MainFrame
end)
