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

-- Bounce-in effect
local crazyTween = TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 300, 0, 200),
	Rotation = 15,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255)
})

-- Final sleek menu look
local finalTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 600, 0, 300),
	Rotation = 0,
	BackgroundColor3 = Color3.fromRGB(20, 20, 20)
})

crazyTween:Play()
crazyTween.Completed:Connect(function()
	wait(0.2)
	finalTween:Play()
end)

finalTween.Completed:Connect(function()
	-- === Secondary Frame for Buttons ===
	local SecondaryFrame = Instance.new("Frame")
	SecondaryFrame.Size = UDim2.new(0, 558, 0, 261)
	SecondaryFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	SecondaryFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	SecondaryFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
	SecondaryFrame.BorderSizePixel = 0
	SecondaryFrame.Parent = MainFrame

	local UIListLayout = Instance.new("UIListLayout", SecondaryFrame)
	UIListLayout.Padding = UDim.new(0, 10)
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	-- === Reusable Button Function ===
	local function createButton(text, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 200, 0, 50)
		btn.Text = text
		btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		btn.TextColor3 = Color3.fromRGB(0, 255, 0)
		btn.Font = Enum.Font.Code
		btn.TextSize = 20
		btn.BorderSizePixel = 0
		btn.Parent = SecondaryFrame

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
		end)

		btn.MouseButton1Click:Connect(callback)
	end

	-- === Noclip ===
	local noclipEnabled = false
	local function toggleNoclip()
		noclipEnabled = not noclipEnabled
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:WaitForChild("HumanoidRootPart")
		if noclipEnabled then
			print("Noclip: ON")
			game:GetService("RunService").Stepped:Connect(function()
				if noclipEnabled then
					for _, part in pairs(char:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end
			end)
		else
			print("Noclip: OFF")
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end

	-- === Fly ===
	local flying = false
	local flyConnection
	local function toggleFly()
		flying = not flying
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		if flying then
			print("Fly: ON")
			local bv = Instance.new("BodyVelocity")
			bv.Velocity = Vector3.new(0, 0, 0)
			bv.MaxForce = Vector3.new(9999, 9999, 9999)
			bv.Name = "FlyForce"
			bv.Parent = hrp

			flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
				local cam = workspace.CurrentCamera
				local direction = Vector3.new()
				if userInput:IsKeyDown(Enum.KeyCode.W) then direction += cam.CFrame.LookVector end
				if userInput:IsKeyDown(Enum.KeyCode.S) then direction -= cam.CFrame.LookVector end
				if userInput:IsKeyDown(Enum.KeyCode.A) then direction -= cam.CFrame.RightVector end
				if userInput:IsKeyDown(Enum.KeyCode.D) then direction += cam.CFrame.RightVector end
				bv.Velocity = direction.Unit * 100
			end)
		else
			print("Fly: OFF")
			if flyConnection then flyConnection:Disconnect() end
			local existing = hrp:FindFirstChild("FlyForce")
			if existing then existing:Destroy() end
		end
	end

	-- Required for fly movement input
	userInput = game:GetService("UserInputService")

	-- === Create Buttons ===
	createButton("Noclip", toggleNoclip)
	createButton("Fly", toggleFly)
end)
