local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local Gui = Instance.new("ScreenGui")
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 600, 0, 300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Rotation = 0
MainFrame.Parent = Gui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 600, 0, 300),
	Rotation = 0,
	BackgroundColor3 = Color3.fromRGB(20, 20, 20)
}):Play()

task.wait(0.6)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Parent = Container

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 2
		})
	end)
end

local function createButton(text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 200, 0, 40)
	button.Text = text
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(0, 255, 0)
	button.Font = Enum.Font.Gotham
	button.TextSize = 18
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Parent = Container

	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 8)

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
	end)

	button.MouseButton1Click:Connect(callback)
end

local isMinimized = false
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 30)
minimizeBtn.Position = UDim2.new(1, -50, 0, 10)
minimizeBtn.AnchorPoint = Vector2.new(0, 0)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = MainFrame

local btnCorner = Instance.new("UICorner", minimizeBtn)
btnCorner.CornerRadius = UDim.new(0, 6)

minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 40, 0, 30)}):Play()
		Container.Visible = false
		minimizeBtn.Text = "+"
	else
		TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 300)}):Play()
		Container.Visible = true
		minimizeBtn.Text = "-"
	end
end)

local noclipEnabled = false
local noclipConn

createButton("Toggle Noclip", function()
	local char = player.Character or player.CharacterAdded:Wait()
	noclipEnabled = not noclipEnabled

	if noclipEnabled then
		noclipConn = RunService.Stepped:Connect(function()
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end)
		notify("Noclip", "Noclip enabled")
	else
		if noclipConn then noclipConn:Disconnect() end
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = true end
		end
		notify("Noclip", "Noclip disabled")
	end
end)

local speed = 50
local direction = Vector3.zero
local bodyVelocity

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.W then direction = Vector3.new(0, 0, -1)
	elseif key == Enum.KeyCode.S then direction = Vector3.new(0, 0, 1)
	elseif key == Enum.KeyCode.A then direction = Vector3.new(-1, 0, 0)
	elseif key == Enum.KeyCode.D then direction = Vector3.new(1, 0, 0) end
end)
UserInputService.InputEnded:Connect(function(input, gpe)
	if gpe then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.W or key == Enum.KeyCode.S or key == Enum.KeyCode.A or key == Enum.KeyCode.D then
		direction = Vector3.zero
	end
end)

createButton("Toggle Speed", function()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local flyEnabled = not flyEnabled

	if flyEnabled then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.P = 5000
		bodyVelocity.Parent = hrp

		RunService:BindToRenderStep("SpeedFly", Enum.RenderPriority.Input.Value, function()
			local camCF = workspace.CurrentCamera.CFrame
			local moveDir = camCF:VectorToWorldSpace(direction)
			bodyVelocity.Velocity = moveDir.Unit * speed
		end)

		notify("Speed", "Speed enabled")
	else
		RunService:UnbindFromRenderStep("SpeedFly")
		if bodyVelocity then bodyVelocity:Destroy() end
		notify("Speed", "Speed disabled")
	end
end)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 200, 0, 40)
speedBox.PlaceholderText = "Enter Speed (e.g. 100)"
speedBox.Text = ""
speedBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
speedBox.TextColor3 = Color3.fromRGB(0, 255, 0)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 16
speedBox.BorderSizePixel = 0
speedBox.ClearTextOnFocus = false
speedBox.Parent = Container

Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

speedBox.FocusLost:Connect(function(enter)
	if enter then
		local newSpeed = tonumber(speedBox.Text)
		if newSpeed then
			speed = math.clamp(newSpeed, 1, 500)
			notify("Speed", "Speed set to " .. speed)
		else
			notify("Speed", "Invalid speed")
		end
	end
end)

local flingBox = Instance.new("TextBox")
flingBox.Size = UDim2.new(0, 200, 0, 40)
flingBox.PlaceholderText = "Player to fling"
flingBox.Text = ""
flingBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
flingBox.TextColor3 = Color3.fromRGB(255, 100, 100)
flingBox.Font = Enum.Font.Gotham
flingBox.TextSize = 16
flingBox.BorderSizePixel = 0
flingBox.ClearTextOnFocus = false
flingBox.Parent = Container

Instance.new("UICorner", flingBox).CornerRadius = UDim.new(0, 6)

createButton("Fling Player", function()
	local targetName = flingBox.Text
	local target = Players:FindFirstChild(targetName)
	local char = player.Character
	if not (char and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")) then
		notify("Fling", "Player not found!")
		return
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)

	local fling = Instance.new("BodyAngularVelocity")
	fling.AngularVelocity = Vector3.new(0, 99999, 0)
	fling.MaxTorque = Vector3.new(99999, 99999, 99999)
	fling.P = 99999
	fling.Parent = hrp

	notify("Fling", "Launched " .. targetName)

	task.delay(2, function()
		if fling then fling:Destroy() end
	end)
end)
