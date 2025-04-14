-- Lern-Aimbot mit GUI (für Velocity Exploit, NUR zum Lernen und Anticheat-Entwicklung)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Einstellungen
local aimbotEnabled = false
local aimbotFOV = 100
local aimKey = Enum.KeyCode.E

-- GUI Setup (in CoreGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotGUI"
screenGui.ResetOnSpawn = false
pcall(function()
	screenGui.Parent = game:GetService("CoreGui")
end)

-- Statusanzeige
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Text = "Aimbot: OFF"
statusLabel.BorderSizePixel = 0
statusLabel.Parent = screenGui

-- FOV-Anzeige
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 200, 0, 30)
fovLabel.Position = UDim2.new(0, 10, 0, 45)
fovLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.TextScaled = true
fovLabel.Text = "FOV: " .. aimbotFOV
fovLabel.BorderSizePixel = 0
fovLabel.Parent = screenGui

-- Ziel finden
local function getClosestTarget()
	local closestPlayer = nil
	local shortestDistance = aimbotFOV

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			local head = player.Character.Head
			local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
				if distance < shortestDistance then
					closestPlayer = player
					shortestDistance = distance
				end
			end
		end
	end

	return closestPlayer
end

-- Aimbot aktiv
RunService.RenderStepped:Connect(function()
	if aimbotEnabled then
		local target = getClosestTarget()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			local targetPos = target.Character.Head.Position
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
		end
	end
end)

-- Tasteneingaben
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if input.KeyCode == aimKey then
		aimbotEnabled = not aimbotEnabled
		statusLabel.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
		statusLabel.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(30, 30, 30)
	elseif input.KeyCode == Enum.KeyCode.Right then
		aimbotFOV = aimbotFOV + 10
		fovLabel.Text = "FOV: " .. aimbotFOV
	elseif input.KeyCode == Enum.KeyCode.Left then
		aimbotFOV = math.max(10, aimbotFOV - 10)
		fovLabel.Text = "FOV: " .. aimbotFOV
	end
end)

