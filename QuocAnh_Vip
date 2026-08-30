--==============================================================
-- QUOC ANH HUB - ROBLOX STUDIO
-- PHẦN 1/7 - SERVICES + STATE + GUI ROOT
--==============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa GUI cũ
local oldGui = PlayerGui:FindFirstChild("QAHubGui")
if oldGui then
	oldGui:Destroy()
end

--==============================================================
-- STATE
--==============================================================

local State = {
	MenuOpen = true,

	ESPPlayer = false,
	ESPMob = false,
	Fullbright = false,
	FixLag = false,
	FixLagMode = "Nhẹ",

	Noclip = false,
	InfJump = false,

	Speed = false,
	SpeedValue = 100,

	JumpBoost = false,
	JumpValue = 100,

	Hitbox = false,
	HitboxSize = 20,
	HitboxColor = Color3.fromRGB(255, 0, 0),

	ESPColor = Color3.fromRGB(0, 200, 255),
}

--==============================================================
-- STORAGE
--==============================================================

local Connections = {}
local ESPObjects = {}
local HitboxObjects = {}

local Character
local Humanoid
local RootPart

local OriginalLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
}

local OriginalCharacter = {
	WalkSpeed = 16,
	JumpPower = 50,
	JumpHeight = 7.2,
	UseJumpPower = true,
}

--==============================================================
-- SCREEN GUI
--==============================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QAHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

--==============================================================
-- QA FLOATING BUTTON
--==============================================================

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "QAToggle"
toggleBtn.Size = UDim2.fromOffset(48, 48)
toggleBtn.Position = UDim2.new(0, 15, 0.45, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
toggleBtn.Text = "QA"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 17
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 2
toggleStroke.Parent = toggleBtn

--==============================================================
-- MAIN MENU
--==============================================================

local mainFrame = Instance.new("Frame")
mainFrame.Name = "QAHubMain"
mainFrame.Size = UDim2.fromOffset(285, 390)
mainFrame.Position = UDim2.new(0.5, -142, 0.5, -195)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

--==============================================================
-- SCALE
--==============================================================

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = mainFrame

--==============================================================
-- PHẦN 2/7 - HEADER + PROFILE + QA BUTTON
--==============================================================

--==============================================================
-- HEADER
--==============================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -55, 1, 0)
titleLabel.Position = UDim2.fromOffset(12, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "👑 QUOC ANH HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(27, 27)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = closeBtn

--==============================================================
-- PROFILE
--==============================================================

local profileCard = Instance.new("Frame")
profileCard.Size = UDim2.new(1, -20, 0, 50)
profileCard.Position = UDim2.fromOffset(10, 42)
profileCard.BackgroundColor3 = Color3.fromRGB(21, 21, 30)
profileCard.Parent = mainFrame

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 9)
profileCorner.Parent = profileCard

local logo = Instance.new("TextLabel")
logo.Size = UDim2.fromOffset(36, 36)
logo.Position = UDim2.fromOffset(7, 7)
logo.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
logo.Text = "QA"
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.TextSize = 14
logo.Font = Enum.Font.GothamBold
logo.Parent = profileCard

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logo

local logoStroke = Instance.new("UIStroke")
logoStroke.Thickness = 2
logoStroke.Parent = logo

local userName = Instance.new("TextLabel")
userName.Size = UDim2.new(1, -55, 0, 18)
userName.Position = UDim2.fromOffset(50, 7)
userName.BackgroundTransparency = 1
userName.Text = LocalPlayer.Name
userName.TextColor3 = Color3.fromRGB(255, 255, 255)
userName.TextSize = 11
userName.Font = Enum.Font.GothamBold
userName.TextXAlignment = Enum.TextXAlignment.Left
userName.Parent = profileCard

local device = Instance.new("TextLabel")
device.Size = UDim2.new(1, -55, 0, 16)
device.Position = UDim2.fromOffset(50, 25)
device.BackgroundTransparency = 1
device.Text = "Roblox Studio"
device.TextColor3 = Color3.fromRGB(100, 230, 150)
device.TextSize = 9
device.Font = Enum.Font.Gotham
device.TextXAlignment = Enum.TextXAlignment.Left
device.Parent = profileCard

--==============================================================
-- FPS
--==============================================================

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.fromOffset(70, 20)
fpsLabel.Position = UDim2.new(1, -82, 0, 96)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "0 FPS"
fpsLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
fpsLabel.TextSize = 9
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
fpsLabel.Parent = mainFrame

--==============================================================
-- TOGGLE MENU
--==============================================================

local menuTweenInfo = TweenInfo.new(
	0.22,
	Enum.EasingStyle.Quart,
	Enum.EasingDirection.Out
)

local function OpenMenu()
	State.MenuOpen = true
	mainFrame.Visible = true
	mainFrame.Size = UDim2.fromOffset(260, 350)

	TweenService:Create(
		mainFrame,
		menuTweenInfo,
		{
			Size = UDim2.fromOffset(285, 390)
		}
	):Play()
end

local function CloseMenu()
	State.MenuOpen = false

	local tween = TweenService:Create(
		mainFrame,
		menuTweenInfo,
		{
			Size = UDim2.fromOffset(260, 350)
		}
	)

	tween:Play()

	tween.Completed:Connect(function()
		if not State.MenuOpen then
			mainFrame.Visible = false
		end
	end)
end

toggleBtn.MouseButton1Click:Connect(function()
	if State.MenuOpen then
		CloseMenu()
	else
		OpenMenu()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	CloseMenu()
end)

--==============================================================
-- PHẦN 3/7 - SCROLL + TOGGLE + SLIDER
--==============================================================

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "FeatureList"
scrollFrame.Size = UDim2.new(1, -16, 1, -104)
scrollFrame.Position = UDim2.fromOffset(8, 104)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(170, 0, 255)
scrollFrame.CanvasSize = UDim2.fromOffset(0, 0)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local padding = Instance.new("UIPadding")
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = scrollFrame

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.fromOffset(
		0,
		listLayout.AbsoluteContentSize.Y + 12
	)
end)

local order = 0

local function NextOrder()
	order += 1
	return order
end

--==============================================================
-- TOGGLE
--==============================================================

local function CreateToggle(name, description, callback)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -6, 0, 45)
	frame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = NextOrder()
	frame.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -65, 0, 19)
	title.Position = UDim2.fromOffset(9, 4)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = Color3.fromRGB(245, 245, 250)
	title.TextSize = 11
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(1, -65, 0, 16)
	desc.Position = UDim2.fromOffset(9, 23)
	desc.BackgroundTransparency = 1
	desc.Text = description
	desc.TextColor3 = Color3.fromRGB(135, 135, 155)
	desc.TextSize = 8
	desc.Font = Enum.Font.Gotham
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.Parent = frame

	local button = Instance.new("TextButton")
	button.Size = UDim2.fromOffset(40, 20)
	button.Position = UDim2.new(1, -49, 0.5, -10)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	button.Text = ""
	button.AutoButtonColor = false
	button.Parent = frame

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = button

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(14, 14)
	knob.Position = UDim2.fromOffset(3, 3)
	knob.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
	knob.Parent = button

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local enabled = false

	local function SetState(value)
		enabled = value

		local pos
		local color

		if enabled then
			pos = UDim2.new(1, -17, 0, 3)
			color = Color3.fromRGB(170, 0, 255)
		else
			pos = UDim2.fromOffset(3, 3)
			color = Color3.fromRGB(45, 45, 60)
		end

		TweenService:Create(
			knob,
			TweenInfo.new(0.18),
			{Position = pos}
		):Play()

		TweenService:Create(
			button,
			TweenInfo.new(0.18),
			{BackgroundColor3 = color}
		):Play()

		if callback then
			callback(enabled)
		end
	end

	button.MouseButton1Click:Connect(function()
		SetState(not enabled)
	end)

	return frame, SetState
end

--==============================================================
-- SLIDER
--==============================================================

local function CreateSlider(name, minValue, maxValue, defaultValue, callback)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -6, 0, 49)
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 27)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = NextOrder()
	frame.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 0, 18)
	label.Position = UDim2.fromOffset(8, 3)
	label.BackgroundTransparency = 1
	label.Text = name .. ": " .. tostring(defaultValue)
	label.TextColor3 = Color3.fromRGB(205, 205, 220)
	label.TextSize = 9
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(1, -16, 0, 8)
	track.Position = UDim2.fromOffset(8, 29)
	track.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = frame

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local fill = Instance.new("Frame")
	local initial = math.clamp(
		(defaultValue - minValue) / (maxValue - minValue),
		0,
		1
	)

	fill.Size = UDim2.new(initial, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
	fill.BorderSizePixel = 0
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local dragging = false
	local value = defaultValue

	local function Update(input)
		local x = input.Position.X
		local left = track.AbsolutePosition.X
		local width = track.AbsoluteSize.X

		if width <= 0 then
			return
		end

		local percent = math.clamp(
			(x - left) / width,
			0,
			1
		)

		value = math.floor(
			minValue + (maxValue - minValue) * percent + 0.5
		)

		local realPercent =
			(value - minValue) / (maxValue - minValue)

		fill.Size = UDim2.new(
			realPercent,
			0,
			1,
			0
		)

		label.Text =
			name .. ": " .. tostring(value)

		if callback then
			callback(value)
		end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			Update(input)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging then
			if input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch then

				Update(input)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false
		end
	end)

	return frame
end

--==============================================================
-- PHẦN 4/7 - COLOR PICKER + FIX LAG OPTIONS
--==============================================================

local function CreateColorPicker(name, defaultColor, callback)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -6, 0, 78)
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 27)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = NextOrder()
	frame.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -16, 0, 18)
	title.Position = UDim2.fromOffset(8, 4)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = Color3.fromRGB(205, 205, 220)
	title.TextSize = 9
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -16, 0, 48)
	container.Position = UDim2.fromOffset(8, 25)
	container.BackgroundTransparency = 1
	container.Parent = frame

	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.fromOffset(24, 20)
	grid.CellPadding = UDim2.fromOffset(5, 5)
	grid.Parent = container

	local colors = {
		{"Đỏ", Color3.fromRGB(255, 0, 0)},
		{"Cam", Color3.fromRGB(255, 120, 0)},
		{"Vàng", Color3.fromRGB(255, 230, 0)},
		{"Lục", Color3.fromRGB(0, 255, 80)},
		{"Cyan", Color3.fromRGB(0, 220, 255)},
		{"Xanh", Color3.fromRGB(0, 100, 255)},
		{"Tím", Color3.fromRGB(160, 0, 255)},
		{"Hồng", Color3.fromRGB(255, 70, 180)},
		{"Trắng", Color3.fromRGB(255, 255, 255)},
	}

	for _, info in ipairs(colors) do

		local button = Instance.new("TextButton")
		button.Name = info[1]
		button.Size = UDim2.fromOffset(24, 20)
		button.BackgroundColor3 = info[2]
		button.Text = ""
		button.AutoButtonColor = false
		button.Parent = container

		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 5)
		c.Parent = button

		button.MouseButton1Click:Connect(function()
			if callback then
				callback(info[2])
			end
		end)
	end

	return frame
end

--==============================================================
-- FIX LAG OPTIONS
--==============================================================

local function CreateFixLagOptions(callback)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -6, 0, 42)
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 27)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = NextOrder()
	frame.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local light = Instance.new("TextButton")
	light.Size = UDim2.new(0.46, 0, 0, 27)
	light.Position = UDim2.new(0.03, 0, 0, 7)
	light.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
	light.Text = "Nhẹ"
	light.TextColor3 = Color3.fromRGB(255, 255, 255)
	light.TextSize = 9
	light.Font = Enum.Font.GothamBold
	light.AutoButtonColor = false
	light.Parent = frame

	local lc = Instance.new("UICorner")
	lc.CornerRadius = UDim.new(0, 6)
	lc.Parent = light

	local strong = Instance.new("TextButton")
	strong.Size = UDim2.new(0.46, 0, 0, 27)
	strong.Position = UDim2.new(0.51, 0, 0, 7)
	strong.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
	strong.Text = "Mạnh"
	strong.TextColor3 = Color3.fromRGB(175, 175, 190)
	strong.TextSize = 9
	strong.Font = Enum.Font.GothamBold
	strong.AutoButtonColor = false
	strong.Parent = frame

	local sc = Instance.new("UICorner")
	sc.CornerRadius = UDim.new(0, 6)
	sc.Parent = strong

	local function Select(mode)

		State.FixLagMode = mode

		local lightSelected = mode == "Nhẹ"

		light.BackgroundColor3 =
			lightSelected
			and Color3.fromRGB(170, 0, 255)
			or Color3.fromRGB(35, 35, 48)

		strong.BackgroundColor3 =
			not lightSelected
			and Color3.fromRGB(170, 0, 255)
			or Color3.fromRGB(35, 35, 48)

		light.TextColor3 =
			lightSelected
			and Color3.fromRGB(255, 255, 255)
			or Color3.fromRGB(175, 175, 190)

		strong.TextColor3 =
			not lightSelected
			and Color3.fromRGB(255, 255, 255)
			or Color3.fromRGB(175, 175, 190)

		if callback then
			callback(mode)
		end
	end

	light.MouseButton1Click:Connect(function()
		Select("Nhẹ")
	end)

	strong.MouseButton1Click:Connect(function()
		Select("Mạnh")
	end)

	return frame
end

--==============================================================
-- PHẦN 5/7 - TẠO TOÀN BỘ MENU TÍNH NĂNG
--==============================================================

--==============================================================
-- ESP PLAYER
--==============================================================

local espColorPicker

local espToggle = CreateToggle(
	"ESP Player",
	"Hiện người chơi",
	function(enabled)

		State.ESPPlayer = enabled

		if espColorPicker then
			espColorPicker.Visible = enabled
		end
	end
)

espColorPicker = CreateColorPicker(
	"Màu ESP Player",
	State.ESPColor,
	function(color)

		State.ESPColor = color
	end
)

espColorPicker.Visible = false

--==============================================================
-- ESP MOB
--==============================================================

CreateToggle(
	"ESP Mob",
	"Hiện NPC / quái vật",
	function(enabled)

		State.ESPMob = enabled
	end
)

--==============================================================
-- FULLBRIGHT
--==============================================================

CreateToggle(
	"Fullbright",
	"Sáng toàn bản đồ",
	function(enabled)

		State.Fullbright = enabled
	end
)

--==============================================================
-- FIX LAG
--==============================================================

local fixLagOptions

CreateToggle(
	"Fix Lag",
	"Giảm hiệu ứng gây nặng máy",
	function(enabled)

		State.FixLag = enabled

		if fixLagOptions then
			fixLagOptions.Visible = enabled
		end
	end
)

fixLagOptions = CreateFixLagOptions(function(mode)

	State.FixLagMode = mode
end)

fixLagOptions.Visible = false

--==============================================================
-- NOCLIP
--==============================================================

CreateToggle(
	"Noclip",
	"Đi xuyên vật cản trong Studio",
	function(enabled)

		State.Noclip = enabled
	end
)

--==============================================================
-- INFJUMP
--==============================================================

CreateToggle(
	"InfJump",
	"Cho phép nhảy liên tục",
	function(enabled)

		State.InfJump = enabled
	end
)

--==============================================================
-- SPEED
--==============================================================

local speedSlider

CreateToggle(
	"Speed",
	"Tăng tốc độ di chuyển",
	function(enabled)

		State.Speed = enabled

		if speedSlider then
			speedSlider.Visible = enabled
		end
	end
)

speedSlider = CreateSlider(
	"Speed Value",
	16,
	300,
	State.SpeedValue,
	function(value)

		State.SpeedValue = value
	end
)

speedSlider.Visible = false

--==============================================================
-- JUMP BOOST
--==============================================================

local jumpSlider

CreateToggle(
	"Jump Boost",
	"Tăng lực nhảy",
	function(enabled)

		State.JumpBoost = enabled

		if jumpSlider then
			jumpSlider.Visible = enabled
		end
	end
)

jumpSlider = CreateSlider(
	"Jump Power",
	50,
	300,
	State.JumpValue,
	function(value)

		State.JumpValue = value
	end
)

jumpSlider.Visible = false

--==============================================================
-- HITBOX
--==============================================================

local hitboxSlider
local hitboxColorPicker

CreateToggle(
	"Hitbox Player",
	"Hiển thị vùng hitbox người chơi",
	function(enabled)

		State.Hitbox = enabled

		if hitboxSlider then
			hitboxSlider.Visible = enabled
		end

		if hitboxColorPicker then
			hitboxColorPicker.Visible = enabled
		end
	end
)

hitboxSlider = CreateSlider(
	"Size Hitbox",
	1,
	50,
	State.HitboxSize,
	function(value)

		State.HitboxSize = value
	end
)

hitboxSlider.Visible = false

hitboxColorPicker = CreateColorPicker(
	"Màu Hitbox",
	State.HitboxColor,
	function(color)

		State.HitboxColor = color
	end
)

hitboxColorPicker.Visible = false

--==============================================================
-- PHẦN 6/7 - CHẠY CÁC TÍNH NĂNG
--==============================================================

--==============================================================
-- CHARACTER
--==============================================================

local function UpdateCharacter()

	Character = LocalPlayer.Character

	if not Character then
		Humanoid = nil
		RootPart = nil
		return
	end

	Humanoid = Character:FindFirstChildOfClass("Humanoid")
	RootPart = Character:FindFirstChild("HumanoidRootPart")

	if Humanoid then

		if State.Speed then
			Humanoid.WalkSpeed = State.SpeedValue
		else
			Humanoid.WalkSpeed = OriginalCharacter.WalkSpeed
		end

		if State.JumpBoost then
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = State.JumpValue
		else
			Humanoid.UseJumpPower = OriginalCharacter.UseJumpPower
			Humanoid.JumpPower = OriginalCharacter.JumpPower
			Humanoid.JumpHeight = OriginalCharacter.JumpHeight
		end
	end
end

local function OnCharacterAdded(character)

	Character = character

	task.wait(0.25)

	Humanoid = character:FindFirstChildOfClass("Humanoid")
	RootPart = character:FindFirstChild("HumanoidRootPart")

	if Humanoid then
		OriginalCharacter.WalkSpeed = Humanoid.WalkSpeed
		OriginalCharacter.JumpPower = Humanoid.JumpPower
		OriginalCharacter.JumpHeight = Humanoid.JumpHeight
		OriginalCharacter.UseJumpPower = Humanoid.UseJumpPower
	end

	UpdateCharacter()
end

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)

OnCharacterAdded(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

--==============================================================
-- ESP PLAYER
--==============================================================

local function ClearESP()

	for player, object in pairs(ESPObjects) do

		if object then
			object:Destroy()
		end

		ESPObjects[player] = nil
	end
end

local function MakeESP(player)

	if player == LocalPlayer then
		return
	end

	local character = player.Character

	if not character then
		return
	end

	local old = ESPObjects[player]

	if old then
		old:Destroy()
	end

	local highlight = Instance.new("Highlight")
	highlight.Name = "QA_ESP"
	highlight.Adornee = character
	highlight.FillColor = State.ESPColor
	highlight.OutlineColor = State.ESPColor
	highlight.FillTransparency = 0.72
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = character

	ESPObjects[player] = highlight
end

local function UpdateESP()

	if not State.ESPPlayer then
		ClearESP()
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		MakeESP(player)
	end

	for _, object in pairs(ESPObjects) do
		if object then
			object.FillColor = State.ESPColor
			object.OutlineColor = State.ESPColor
		end
	end
end

Players.PlayerRemoving:Connect(function(player)

	local object = ESPObjects[player]

	if object then
		object:Destroy()
	end

	ESPObjects[player] = nil
end)

--==============================================================
-- HITBOX VISUAL
--==============================================================

local function ClearHitboxes()

	for player, object in pairs(HitboxObjects) do

		if object then
			object:Destroy()
		end

		HitboxObjects[player] = nil
	end
end

local function MakeHitbox(player)

	if player == LocalPlayer then
		return
	end

	local character = player.Character

	if not character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	local old = HitboxObjects[player]

	if old then
		old:Destroy()
	end

	local adornment = Instance.new("BoxHandleAdornment")
	adornment.Name = "QA_Hitbox"
	adornment.Adornee = root
	adornment.AlwaysOnTop = true
	adornment.ZIndex = 5
	adornment.Size = Vector3.new(
		State.HitboxSize,
		State.HitboxSize,
		State.HitboxSize
	)
	adornment.Color3 = State.HitboxColor
	adornment.Transparency = 0.75
	adornment.Parent = root

	HitboxObjects[player] = adornment
end

local function UpdateHitboxes()

	if not State.Hitbox then
		ClearHitboxes()
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		MakeHitbox(player)
	end

	for _, object in pairs(HitboxObjects) do

		if object then
			object.Size = Vector3.new(
				State.HitboxSize,
				State.HitboxSize,
				State.HitboxSize
			)

			object.Color3 = State.HitboxColor
		end
	end
end

--==============================================================
-- NOCLIP
--==============================================================

local function ApplyNoclip()

	if not State.Noclip then
		return
	end

	if not Character then
		return
	end

	for _, object in ipairs(Character:GetDescendants()) do

		if object:IsA("BasePart") then
			object.CanCollide = false
		end
	end
end

--==============================================================
-- FULLBRIGHT
--==============================================================

local function ApplyFullbright()

	if State.Fullbright then

		Lighting.Brightness = 3
		Lighting.ClockTime = 14
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = false
		Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)

	else

		Lighting.Brightness = OriginalLighting.Brightness
		Lighting.ClockTime = OriginalLighting.ClockTime
		Lighting.FogEnd = OriginalLighting.FogEnd
		Lighting.GlobalShadows = OriginalLighting.GlobalShadows
		Lighting.Ambient = OriginalLighting.Ambient
		Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
	end
end

--==============================================================
-- FIX LAG
--==============================================================

local function ApplyFixLag()

	if not State.FixLag then
		return
	end

	for _, object in ipairs(Workspace:GetDescendants()) do

		if object:IsA("ParticleEmitter")
			or object:IsA("Trail")
			or object:IsA("Beam") then

			object.Enabled = false

		elseif object:IsA("BasePart") then

			if State.FixLagMode == "Mạnh" then
				object.CastShadow = false
			end
		end
	end
end

--==============================================================
-- PHẦN 7/7 - LOOP + INFJUMP + RAINBOW + DRAG + FINAL
--==============================================================

--==============================================================
-- INFJUMP
--==============================================================

UserInputService.JumpRequest:Connect(function()

	if State.InfJump then

		local humanoid = LocalPlayer.Character
			and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

--==============================================================
-- FPS
--==============================================================

local frames = 0
local fpsStart = os.clock()

RunService.RenderStepped:Connect(function()

	frames += 1

	local elapsed = os.clock() - fpsStart

	if elapsed >= 1 then

		local fps = math.floor(frames / elapsed)

		fpsLabel.Text = tostring(fps) .. " FPS"

		frames = 0
		fpsStart = os.clock()
	end
end)

--==============================================================
-- RAINBOW BORDER
--==============================================================

local rainbow = 0

RunService.RenderStepped:Connect(function(dt)

	rainbow = (rainbow + dt * 0.35) % 1

	local color = Color3.fromHSV(
		rainbow,
		0.85,
		1
	)

	mainStroke.Color = color
	toggleStroke.Color = color
	logoStroke.Color = color
end)

--==============================================================
-- MAIN FEATURE LOOP
--==============================================================

local featureTimer = 0

RunService.Heartbeat:Connect(function()

	-- Character
	if Character and Humanoid then

		if State.Speed then
			Humanoid.WalkSpeed = State.SpeedValue
		else
			Humanoid.WalkSpeed = OriginalCharacter.WalkSpeed
		end

		if State.JumpBoost then
			Humanoid.UseJumpPower = true
			Humanoid.JumpPower = State.JumpValue
		end
	end

	-- Noclip
	ApplyNoclip()

	-- Fullbright
	ApplyFullbright()

	featureTimer += 1

	if featureTimer >= 10 then

		featureTimer = 0

		UpdateESP()
		UpdateHitboxes()

		if State.FixLag then
			ApplyFixLag()
		end
	end
end)

--==============================================================
-- DRAG SUPPORT
--==============================================================

local function MakeDraggable(object)

	local dragging = false
	local dragStart
	local startPosition

	object.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPosition = object.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)

		if not dragging then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement
			and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart

		object.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)

	UserInputService.InputEnded:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = false
		end
	end)
end

MakeDraggable(toggleBtn)
MakeDraggable(header)

--==============================================================
-- RESPAWN UPDATE
--==============================================================

LocalPlayer.CharacterAdded:Connect(function()

	task.wait(0.5)

	ClearESP()
	ClearHitboxes()

	UpdateCharacter()
end)

--==============================================================
-- PLAYER CHARACTER UPDATE
--==============================================================

for _, player in ipairs(Players:GetPlayers()) do

	if player ~= LocalPlayer then

		player.CharacterAdded:Connect(function()

			task.wait(0.5)

			if State.ESPPlayer then
				MakeESP(player)
			end

			if State.Hitbox then
				MakeHitbox(player)
			end
		end)
	end
end

Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function()

		task.wait(0.5)

		if State.ESPPlayer then
			MakeESP(player)
		end

		if State.Hitbox then
			MakeHitbox(player)
		end
	end)
end)

--==============================================================
-- INITIAL
--==============================================================

mainFrame.Visible = true
State.MenuOpen = true

print("==============================================")
print("        QUOC ANH HUB")
print("        ALL SYSTEMS READY")
print("==============================================")
