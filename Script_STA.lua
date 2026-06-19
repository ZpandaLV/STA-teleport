-- =============================================================================
-- SCRIPT EXECUTOR - APOCALYPSE UTILITY V5.4 (READY FOR GITHUB)
-- =============================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Menghapus GUI lama jika sudah ada agar tidak menumpuk di layar
if CoreGui:FindFirstChild("ApocTeleportGui") then
	CoreGui.ApocTeleportGui:Destroy()
end

-- 1. SETUP ANTARMUKA (GUI LOKAL)
local TeleportGui = Instance.new("ScreenGui")
TeleportGui.Name = "ApocTeleportGui"
TeleportGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 160)
MainFrame.Position = UDim2.new(0, 20, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.ClipsDescendants = true 
MainFrame.Parent = TeleportGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Judul Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -65, 0, 30)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ APOC V5.4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Tombol Lock Floating
local LockButton = Instance.new("TextButton")
LockButton.Name = "LockButton"
LockButton.Size = UDim2.new(0, 25, 0, 25)
LockButton.Position = UDim2.new(1, -60, 0, 3)
LockButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LockButton.Text = "🔓"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.Font = Enum.Font.SourceSansBold
LockButton.TextSize = 14
LockButton.Parent = MainFrame

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 5)
LockCorner.Parent = LockButton

-- Tombol Minimize (- / +)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -30, 0, 3)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 16
MinimizeButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 5)
MinCorner.Parent = MinimizeButton

-- Container Konten Utama
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local BaseButton = Instance.new("TextButton")
BaseButton.Size = UDim2.new(0, 180, 0, 35)
BaseButton.Position = UDim2.new(0, 10, 0, 5)
BaseButton.BackgroundColor3 = Color3.fromRGB(139, 34, 34)
BaseButton.Text = "Glitch to Base (Force Amblas)"
BaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BaseButton.Font = Enum.Font.SourceSansBold
BaseButton.TextSize = 14
BaseButton.Parent = ContentFrame
local BC = Instance.new("UICorner") BC.CornerRadius = UDim.new(0, 5) BC.Parent = BaseButton

local PlayerInput = Instance.new("TextBox")
PlayerInput.Size = UDim2.new(0, 180, 0, 30)
PlayerInput.Position = UDim2.new(0, 10, 0, 50)
PlayerInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerInput.Text = ""
PlayerInput.PlaceholderText = "Nama Player..."
PlayerInput.TextColor3 = Color3.fromRGB(0, 0, 0)
PlayerInput.TextSize = 14
PlayerInput.Parent = ContentFrame
local IC = Instance.new("UICorner") IC.CornerRadius = UDim.new(0, 5) IC.Parent = PlayerInput

local PlayerButton = Instance.new("TextButton")
PlayerButton.Size = UDim2.new(0, 180, 0, 35)
PlayerButton.Position = UDim2.new(0, 10, 0, 85)
PlayerButton.BackgroundColor3 = Color3.fromRGB(218, 165, 32)
PlayerButton.Text = "Teleport to Player"
PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerButton.Font = Enum.Font.SourceSansBold
PlayerButton.TextSize = 14
PlayerButton.Parent = ContentFrame
local PC = Instance.new("UICorner") PC.CornerRadius = UDim.new(0, 5) PC.Parent = PlayerButton

--------------------------------------------------------------------------------
-- 2. LOGIKA OPERASIONAL (INTERFACES BUTTONS)
--------------------------------------------------------------------------------

-- Animasi Minimize
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	
	local targetSize = isMinimized and UDim2.new(0, 200, 0, 32) or UDim2.new(0, 200, 0, 160)
	MinimizeButton.Text = isMinimized and "+" or "-"
	
	if isMinimized then
		ContentFrame.Visible = false
	end
	
	local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize})
	tween:Play()
	
	tween.Completed:Connect(function()
		if not isMinimized then
			ContentFrame.Visible = true
		end
	end)
end)

-- Kunci Posisi Menu
local isLocked = false
LockButton.MouseButton1Click:Connect(function()
	isLocked = not isLocked
	if isLocked then
		MainFrame.Draggable = false
		LockButton.Text = "🔒"
		LockButton.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
	else
		MainFrame.Draggable = true
		LockButton.Text = "🔓"
		LockButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end
end)

-- Metode Amblas Tanah ke Base
BaseButton.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	
	if root and hum then
		hum:ChangeState(Enum.HumanoidStateType.FallingDown)
		local startTime = os.clock()
		local amblasConnection
		
		amblasConnection = RunService.Heartbeat:Connect(function()
			if os.clock() - startTime > 1.2 then
				amblasConnection:Disconnect()
			else
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
				root.CFrame = root.CFrame * CFrame.new(0, -15, 0)
			end
		end)
	end
end)

-- Teleport Instant ke Player
PlayerButton.MouseButton1Click:Connect(function()
	local targetName = PlayerInput.Text
	if targetName ~= "" then
		local foundPlayer = nil
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and string.sub(string.lower(p.Name), 1, string.len(targetName)) == string.lower(targetName) then
				foundPlayer = p
				break
			end
		end
		
		if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local targetPos = foundPlayer.Character.HumanoidRootPart.Position
			local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if root then
				root.Velocity = Vector3.new(0,0,0)
				local tween = TweenService:Create(root, TweenInfo.new(0.1), {CFrame = CFrame.new(targetPos + Vector3.new(3, 1, 0))})
				tween:Play()
			end
			PlayerInput.Text = ""
		else
			PlayerInput.Text = "Tidak ditemukan!"
			task.wait(1)
			PlayerInput.Text = ""
		end
	end
end)

--------------------------------------------------------------------------------
-- 3. LOGIKA DAMAGE & DATA ZOMBIE (ALWAYS ON - STUDIO SERVER COMPATIBLE)
--------------------------------------------------------------------------------

local damageMultipliers = {
	["Firearm"] = {
		["Walkers"] = 10.0, ["Crawlers"] = 10.0, ["Sprinters"] = 12.0,
		["RiotShieldZombies"] = 5.0, ["Bloaters"] = 15.0, ["Boomers"] = 15.0, ["Spitters"] = 15.0,
		["Brutes"] = 8.0, ["ShadowBrute"] = 7.0, ["Titan"] = 6.0,
		["GhostZombies"] = 10.0, ["Screechers"] = 14.0
	},
	["Melee"] = {
		["Walkers"] = 15.0, ["Crawlers"] = 15.0, ["Sprinters"] = 15.0,
		["RiotShieldZombies"] = 12.0, ["Bloaters"] = 5.0, ["Boomers"] = 5.0, ["Spitters"] = 12.0,
		["Brutes"] = 6.0, ["ShadowBrute"] = 5.0, ["Titan"] = 3.0,
		["GhostZombies"] = 12.0, ["Screechers"] = 4.0
	},
	["Explosive"] = {
		["Walkers"] = 30.0, ["Crawlers"] = 30.0, ["Sprinters"] = 30.0,
		["RiotShieldZombies"] = 25.0, ["Bloaters"] = 30.0, ["Boomers"] = 30.0, ["Spitters"] = 30.0,
		["Brutes"] = 20.0, ["ShadowBrute"] = 18.0, ["Titan"] = 15.0,
		["GhostZombies"] = 25.0, ["Screechers"] = 25.0
	}
}

local function applyApocalypseDamage(attacker, victimHumanoid, weaponType)
	if not victimHumanoid or victimHumanoid.Health <= 0 then return end
	
	local baseDamage = 100 
	if weaponType == "Explosive" then baseDamage = 400 end 
	
	local finalDamage = baseDamage
	local currentDamageMultiplier = 1
	
	local targetType = victimHumanoid.Parent:GetAttribute("ZombieType") or "Walkers"
	
	if damageMultipliers[weaponType] and damageMultipliers[weaponType][targetType] then
		currentDamageMultiplier = damageMultipliers[weaponType][targetType]
	else
		currentDamageMultiplier = 8.0 
	end
	
	finalDamage = baseDamage * currentDamageMultiplier
	victimHumanoid:TakeDamage(finalDamage)
	print(string.format("[Combat Info] %s -> %d Damage ke %s", attacker.Name, finalDamage, targetType))
end

local function onPlayerAttack(player, targetCharacter, weaponType)
	local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
	if humanoid then
		applyApocalypseDamage(player, humanoid, weaponType)
	end
end
