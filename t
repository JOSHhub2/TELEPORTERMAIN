local key = Enum.KeyCode.X -- key to toggle invisibility

--// Don't edit below this line
local invis_on = false
local defaultSpeed = 16
local boostedSpeed = 48
local isSpeedBoosted = false

-- Create GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

-- INVISIBLE button (top-left)
local invisButton = Instance.new("TextButton", screenGui)
invisButton.Size = UDim2.new(0, 110, 0, 40)
invisButton.Position = UDim2.new(0, 15, 0, 15)
invisButton.Text = "INVISIBLE"
invisButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
invisButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisButton.Font = Enum.Font.SourceSansBold
invisButton.TextScaled = true
invisButton.AutoButtonColor = true
invisButton.Active = true
invisButton.Draggable = true

-- SPEED BOOST button (top-right)
local speedButton = Instance.new("TextButton", screenGui)
speedButton.Size = UDim2.new(0, 110, 0, 40)
speedButton.Position = UDim2.new(1, -125, 0, 15)
speedButton.AnchorPoint = Vector2.new(0, 0)
speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speedButton.Text = "SPEED BOOST"
speedButton.TextScaled = true
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.SourceSansBold
speedButton.AutoButtonColor = true
speedButton.Active = true
speedButton.Draggable = true

-- Sound effect
local sound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
sound.SoundId = "rbxassetid://942127495"
sound.Volume = 1

local function setTransparency(character, transparency)
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Decal") then
			part.Transparency = transparency
		end
	end
end

local function toggleInvisibility()
	invis_on = not invis_on
	sound:Play()
	if invis_on then
		local savedpos = player.Character.HumanoidRootPart.CFrame
		wait()
		player.Character:MoveTo(Vector3.new(-25.95, 84, 3537.55))
		wait(0.15)
		local Seat = Instance.new("Seat", workspace)
		Seat.Anchored = false
		Seat.CanCollide = false
		Seat.Name = "invischair"
		Seat.Transparency = 1
		Seat.Position = Vector3.new(-25.95, 84, 3537.55)
		local Weld = Instance.new("Weld", Seat)
		Weld.Part0 = Seat
		Weld.Part1 = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
		wait()
		Seat.CFrame = savedpos
		setTransparency(player.Character, 0.5)
		game.StarterGui:SetCore("SendNotification", {
			Title = "Invisibility: ON",
			Duration = 3,
			Text = "You are now invisible."
		})
	else
		local invisChair = workspace:FindFirstChild("invischair")
		if invisChair then
			invisChair:Destroy()
		end
		setTransparency(player.Character, 0)
		game.StarterGui:SetCore("SendNotification", {
			Title = "Invisibility: OFF",
			Duration = 3,
			Text = "You are now visible."
		})
	end
end

local function toggleSpeedBoost()
	isSpeedBoosted = not isSpeedBoosted
	sound:Play()
	local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
	if humanoid then
		if isSpeedBoosted then
			humanoid.WalkSpeed = boostedSpeed
			speedButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			game.StarterGui:SetCore("SendNotification", {
				Title = "Speed Boost: ON",
				Duration = 3,
				Text = "Speed set to " .. boostedSpeed
			})
		else
			humanoid.WalkSpeed = defaultSpeed
			speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			game.StarterGui:SetCore("SendNotification", {
				Title = "Speed Boost: OFF",
				Duration = 3,
				Text = "Speed set to " .. defaultSpeed
			})
		end
	end
end

-- Connect buttons
invisButton.MouseButton1Click:Connect(toggleInvisibility)
speedButton.MouseButton1Click:Connect(toggleSpeedBoost)

-- Reset when character respawns
player.CharacterAdded:Connect(function(character)
	isSpeedBoosted = false
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = defaultSpeed
	speedButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)
