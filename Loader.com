-- ==========================================================
-- PHẦN 1: KHỞI TẠO DỊCH VỤ, BIẾN, NÚT QA VÀ KHUNG MENU
-- ==========================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Xóa GUI cũ nếu có
if playerGui:FindFirstChild("QAHubGui") then
	playerGui.QAHubGui:Destroy()
end

-- Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "QAHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tạo Nút QA Nổi
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "QAToggle"
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
toggleBtn.Text = "QA"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Thickness = 2.5
btnStroke.Parent = toggleBtn

local btnTextGradient = Instance.new("UIGradient")
btnTextGradient.Parent = toggleBtn

-- Tạo Khung Menu Chính
local mainFrame = Instance.new("Frame")
mainFrame.Name = "QAHubMain"
mainFrame.Size = UDim2.new(0, 270, 0, 340)
mainFrame.Position = UDim2.new(0.5, -135, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

-- Sự kiện bấm Nút QA để mở/đóng menu
toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)
-- ==========================================================
-- PHẦN 2: HEADER, NÚT ĐÓNG, PROFILE CARD, HIỆU ỨNG CẦU VỒNG
-- ==========================================================

-- Header Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -45, 0, 35)
titleLabel.Position = UDim2.new(0, 12, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "👑 QUOC ANH HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local titleGradient = Instance.new("UIGradient")
titleGradient.Parent = titleLabel

-- Nút Đóng
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -32, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Profile Card
local profileCard = Instance.new("Frame")
profileCard.Size = UDim2.new(1, -20, 0, 50)
profileCard.Position = UDim2.new(0, 10, 0, 40)
profileCard.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
profileCard.Parent = mainFrame

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 8)
cardCorner.Parent = profileCard

local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 36, 0, 36)
logoFrame.Position = UDim2.new(0, 7, 0, 7)
logoFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
logoFrame.Parent = profileCard

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(1, 0)
logoCorner.Parent = logoFrame

local logoStroke = Instance.new("UIStroke")
logoStroke.Thickness = 2
logoStroke.Parent = logoFrame

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "QA"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextSize = 15
logoText.Font = Enum.Font.GothamBold
logoText.Parent = logoFrame

local logoTextGradient = Instance.new("UIGradient")
logoTextGradient.Parent = logoText

local userInfo = Instance.new("TextLabel")
userInfo.Size = UDim2.new(1, -55, 0, 16)
userInfo.Position = UDim2.new(0, 50, 0, 8)
userInfo.BackgroundTransparency = 1
userInfo.Text = LocalPlayer.Name
userInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
userInfo.TextSize = 12
userInfo.Font = Enum.Font.GothamBold
userInfo.TextXAlignment = Enum.TextXAlignment.Left
userInfo.Parent = profileCard

local deviceText = Instance.new("TextLabel")
deviceText.Size = UDim2.new(1, -55, 0, 14)
deviceText.Position = UDim2.new(0, 50, 0, 24)
deviceText.BackgroundTransparency = 1
deviceText.Text = "📱 Thiết bị: Android / PC"
deviceText.TextColor3 = Color3.fromRGB(0, 230, 120)
deviceText.TextSize = 10
deviceText.Font = Enum.Font.Gotham
deviceText.TextXAlignment = Enum.TextXAlignment.Left
deviceText.Parent = profileCard

-- Hiệu ứng Cầu Vồng chạy liên tục
local rainbowSequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 0)),
	ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(170, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 200))
})

titleGradient.Color = rainbowSequence
btnTextGradient.Color = rainbowSequence
logoTextGradient.Color = rainbowSequence

local offset = 0
RunService.RenderStepped:Connect(function(dt)
	offset = (offset + dt * 0.8) % 1
	local singleColor = Color3.fromHSV(offset, 0.85, 1)

	mainStroke.Color = singleColor
	btnStroke.Color = singleColor
	logoStroke.Color = singleColor

	titleGradient.Offset = Vector2.new(offset, 0)
	btnTextGradient.Offset = Vector2.new(offset, 0)
	logoTextGradient.Offset = Vector2.new(offset, 0)
end)
-- ==========================================================
-- PHẦN 3: SCROLLING FRAME, UI LIST VÀ KHAI BÁO BIẾN TRẠNG THÁI
-- ==========================================================

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -100)
scrollFrame.Position = UDim2.new(0, 8, 0, 95)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 255)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

-- Tự động giãn chiều cao của scroll
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

local currentLayoutOrder = 0
local function GetNextOrder()
	currentLayoutOrder = currentLayoutOrder + 1
	return currentLayoutOrder
end

-- Biến lưu trạng thái (Không được tắt khi đổi code phần sau)
local ESP_State = false
local ESP_Color = Color3.fromRGB(255,0,0)
local ESPMob_State = false

local Fullbright_State = false
local FixLag_State = false
local FixLag_Mode = "Light"

local Noclip_State = false
local InfJump_State = false
local Speed_State = false
local Speed_Value = 16
local JumpBoost_State = false
local JumpBoost_Value = 50
local Hitbox_State = false
local Hitbox_Value = 1
local Hitbox_Color = Color3.fromRGB(255,0,0)
-- ==========================================================
-- PHẦN 4: HÀM TẠO TOGGLE (NÚT BẬT TẮT) VÀ SLIDER (THANH TRƯỢT)
-- ==========================================================

local function CreateToggle(name, subtext, onToggleCallback)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Size = UDim2.new(1, -6, 0, 42)
	toggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
	toggleFrame.LayoutOrder = GetNextOrder()
	toggleFrame.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toggleFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.65, 0, 0.5, 0)
	label.Position = UDim2.new(0, 8, 0, 3)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 11
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggleFrame

	local subLabel = Instance.new("TextLabel")
	subLabel.Size = UDim2.new(0.65, 0, 0.4, 0)
	subLabel.Position = UDim2.new(0, 8, 0.5, -2)
	subLabel.BackgroundTransparency = 1
	subLabel.Text = subtext
	subLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
	subLabel.TextSize = 9
	subLabel.Font = Enum.Font.Gotham
	subLabel.TextXAlignment = Enum.TextXAlignment.Left
	subLabel.Parent = toggleFrame

	local switchTrack = Instance.new("TextButton")
	switchTrack.Size = UDim2.new(0, 40, 0, 20)
	switchTrack.Position = UDim2.new(1, -48, 0.5, -10)
	switchTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	switchTrack.Text = ""
	switchTrack.AutoButtonColor = false
	switchTrack.Parent = toggleFrame

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = switchTrack

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0, 3, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	knob.Parent = switchTrack

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local toggled = false
	switchTrack.MouseButton1Click:Connect(function()
		toggled = not toggled
		local targetPos = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		local targetBgColor = toggled and Color3.fromRGB(170, 0, 255) or Color3.fromRGB(45, 45, 60)

		TweenService:Create(knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
		TweenService:Create(switchTrack, TweenInfo.new(0.2), {BackgroundColor3 = targetBgColor}):Play()

		if onToggleCallback then
			onToggleCallback(toggled)
		end
	end)

	return toggleFrame
end

-- Hàm tạo Slider (Kéo chỉnh giá trị)
local function CreateSlider(name, min, max, default)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(1, -6, 0, 44)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	sliderFrame.LayoutOrder = GetNextOrder()
	sliderFrame.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = sliderFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.9, 0, 0, 18)
	label.Position = UDim2.new(0, 8, 0, 3)
	label.BackgroundTransparency = 1
	label.Text = name .. ": " .. default
	label.TextColor3 = Color3.fromRGB(200, 200, 220)
	label.TextSize = 10
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sliderFrame

	local track = Instance.new("TextButton")
	track.Size = UDim2.new(1, -16, 0, 8)
	track.Position = UDim2.new(0, 8, 0, 26)
	track.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = sliderFrame

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = track

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local dragging = false
	local value = default

	local function UpdateSlider(input)
		local absPos = track.AbsolutePosition.X
		local absSize = track.AbsoluteSize.X
		local mouseX = input.Position.X
		local scale = math.clamp((mouseX - absPos) / absSize, 0, 1)
		value = math.floor(min + (max - min) * scale)
		
		fill.Size = UDim2.new(scale, 0, 1, 0)
		label.Text = name .. ": " .. value
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			UpdateSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			UpdateSlider(input)
		end
	end)

	return sliderFrame, function() return value end
end
-- ==========================================================
-- PHẦN 5: HÀM TẠO COLOR PICKER, FIX LAG VÀ KHỞI TẠO CÁC MỤC
-- ==========================================================

local function CreateColorPicker(name)
	local pickerFrame = Instance.new("Frame")
	pickerFrame.Size = UDim2.new(1, -6, 0, 75)
	pickerFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	pickerFrame.LayoutOrder = GetNextOrder()
	pickerFrame.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = pickerFrame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 0, 16)
	label.Position = UDim2.new(0, 8, 0, 3)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(200, 200, 220)
	label.TextSize = 10
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = pickerFrame

	local colorsContainer = Instance.new("Frame")
	colorsContainer.Size = UDim2.new(1, -16, 0, 45)
	colorsContainer.Position = UDim2.new(0, 8, 0, 22)
	colorsContainer.BackgroundTransparency = 1
	colorsContainer.Parent = pickerFrame

	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0, 22, 0, 18)
	grid.CellPadding = UDim2.new(0, 4, 0, 4)
	grid.Parent = colorsContainer

	local currentColor = Color3.fromRGB(255, 0, 0)

	local colorsList = {
		{Name = "Đỏ", Color = Color3.fromRGB(255, 0, 0)},
		{Name = "Xanh Lá", Color = Color3.fromRGB(0, 255, 0)},
		{Name = "Xanh Nước", Color = Color3.fromRGB(0, 180, 255)},
		{Name = "Vàng", Color = Color3.fromRGB(255, 230, 0)},
		{Name = "Tím", Color = Color3.fromRGB(160, 0, 255)},
		{Name = "Hồng", Color = Color3.fromRGB(255, 100, 200)},
		{Name = "Trắng", Color = Color3.fromRGB(255, 255, 255)},
		{Name = "Đen", Color = Color3.fromRGB(30, 30, 30)},
		{Name = "Cầu Vồng", IsRainbow = true}
	}

	for _, cInfo in ipairs(colorsList) do
		local cBtn = Instance.new("TextButton")
		cBtn.Text = ""
		cBtn.Parent = colorsContainer

		local cCorner = Instance.new("UICorner")
		cCorner.CornerRadius = UDim.new(0, 4)
		cCorner.Parent = cBtn

		if cInfo.IsRainbow then
			cBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			local gradient = Instance.new("UIGradient")
			gradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,0)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(0,100,255))
			})
			gradient.Parent = cBtn
		else
			cBtn.BackgroundColor3 = cInfo.Color
		end

		cBtn.MouseButton1Click:Connect(function()
			if cInfo.IsRainbow then
				currentColor = "Rainbow"
			else
				currentColor = cInfo.Color
			end
		end)
	end

	return pickerFrame, function() return currentColor end
end

-- Hàm Fix Lag (Nhẹ / Mạnh)
local function CreateFixLagOptions()
	local optFrame = Instance.new("Frame")
	optFrame.Size = UDim2.new(1, -6, 0, 38)
	optFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	optFrame.LayoutOrder = GetNextOrder()
	optFrame.Parent = scrollFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = optFrame

	local lightBtn = Instance.new("TextButton")
	lightBtn.Size = UDim2.new(0.46, 0, 0.75, 0)
	lightBtn.Position = UDim2.new(0.03, 0, 0.125, 0)
	lightBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
	lightBtn.Text = "Nhẹ"
	lightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	lightBtn.TextSize = 10
	lightBtn.Font = Enum.Font.GothamBold
	lightBtn.Parent = optFrame

	local lightCorner = Instance.new("UICorner")
	lightCorner.CornerRadius = UDim.new(0, 5)
	lightCorner.Parent = lightBtn

	local strongBtn = Instance.new("TextButton")
	strongBtn.Size = UDim2.new(0.46, 0, 0.75, 0)
	strongBtn.Position = UDim2.new(0.51, 0, 0.125, 0)
	strongBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	strongBtn.Text = "Mạnh"
	strongBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
	strongBtn.TextSize = 10
	strongBtn.Font = Enum.Font.GothamBold
	strongBtn.Parent = optFrame

	local strongCorner = Instance.new("UICorner")
	strongCorner.CornerRadius = UDim.new(0, 5)
	strongCorner.Parent = strongBtn

	lightBtn.MouseButton1Click:Connect(function()
		FixLag_Mode = "Light"
		lightBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
		lightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		strongBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
		strongBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
	end)

	strongBtn.MouseButton1Click:Connect(function()
		FixLag_Mode = "Strong"
		strongBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
		strongBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		lightBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
		lightBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
	end)

	return optFrame
end

-- KHỞI TẠO CÁC MỤC TRONG MENU
local espColorPicker, espColorGetter
local espToggle = CreateToggle("ESP Player", "Hiện người chơi", function(state)
	ESP_State = state
	espColorPicker.Visible = state
end)
espColorPicker, espColorGetter = CreateColorPicker("Màu ESP Player")
espColorPicker.Visible = false

local espMobToggle = CreateToggle("ESP Mob", "Hiện quái vật", function(state)
	ESPMob_State = state
end)

local fullbrightToggle = CreateToggle("Fullbright", "Sáng toàn bản đồ", function(state)
	Fullbright_State = state
end)

local fixLagOptions
local fixLagToggle = CreateToggle("Fix Lag", "Giảm lag hiệu quả", function(state)
	FixLag_State = state
	fixLagOptions.Visible = state
end)
fixLagOptions = CreateFixLagOptions()
fixLagOptions.Visible = false

CreateToggle("Noclip", "Đi xuyên tường", function(state)
	Noclip_State = state
end)

CreateToggle("infjump", "Nhảy vô tận", function(state)
	InfJump_State = state
end)

local speedSlider, speedSliderGetter
local speedToggle = CreateToggle("Speed", "Tăng tốc độ di chuyển", function(state)
	Speed_State = state
	speedSlider.Visible = state
end)
speedSlider, speedSliderGetter = CreateSlider("Speed Value", 16, 300, 100)
speedSlider.Visible = false

local jumpSlider, jumpSliderGetter
local jumpToggle = CreateToggle("Jump Boost", "Tăng lực nhảy", function(state)
	JumpBoost_State = state
	jumpSlider.Visible = state
end)
jumpSlider, jumpSliderGetter = CreateSlider("Jump Power", 50, 300, 100)
jumpSlider.Visible = false

local hitboxSlider, hitboxColorPicker, hitboxSliderGetter, hitboxColorGetter
local hitboxToggle = CreateToggle("Hitbox Player", "Đổi size & màu TẤT CẢ người chơi", function(state)
	Hitbox_State = state
	hitboxSlider.Visible = state
	hitboxColorPicker.Visible = state
end)
hitboxSlider, hitboxSliderGetter = CreateSlider("Size Hitbox", 1, 50, 20)
hitboxColorPicker, hitboxColorGetter = CreateColorPicker("Màu Hitbox")
hitboxSlider.Visible = false
hitboxColorPicker.Visible = false
-- ==========================================================
-- PHẦN 6: LOGIC CHÍNH (SPEED, JUMP, NOCLIP, FIX LAG, HITBOX)
-- ==========================================================
local defaultWalkSpeed = 16
local defaultJumpPower = 50

-- Logic Infinite Jump
UserInputService.JumpRequest:Connect(function()
	if InfJump_State and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- Vòng lặp chính xử lý liên tục các tính năng
RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return end

	-- FIX LAG THẬT SỰ (Tắt bóng, tắt viền, chỉnh màu đen)
	if FixLag_State then
		Lighting.GlobalShadows = false
		Lighting.Outlines = false
		
		if FixLag_Mode == "Light" then
			Lighting.ShadowSoftness = 0
			Lighting.EnvironmentDiffuseScale = 0
			Lighting.EnvironmentSpecularScale = 0
		elseif FixLag_Mode == "Strong" then
			Lighting.ShadowSoftness = 0
			Lighting.EnvironmentDiffuseScale = 0
			Lighting.EnvironmentSpecularScale = 0
			Lighting.ClockTime = 12
			Lighting.Brightness = 1
			workspace.DescendantAdded:Connect(function(desc)
				if desc:IsA("BasePart") then
					desc.Material = Enum.Material.SmoothPlastic
				end
			end)
		end
	else
		-- Reset lại mặc định khi tắt
		Lighting.GlobalShadows = true
		Lighting.Outlines = true
		Lighting.ShadowSoftness = 1
		Lighting.EnvironmentDiffuseScale = 1
		Lighting.EnvironmentSpecularScale = 1
	end

	-- Fullbright
	if Fullbright_State then
		Lighting.Brightness = 3
		Lighting.ClockTime = 12
		Lighting.Outlines = false
	else
		Lighting.Brightness = 1
		Lighting.ClockTime = 14
	end

	-- Speed & Jump Boost (Tự động Reset về mặc định khi tắt)
	Speed_Value = speedSliderGetter()
	JumpBoost_Value = jumpSliderGetter()

	if Speed_State then
		hum.WalkSpeed = Speed_Value
	else
		hum.WalkSpeed = defaultWalkSpeed
	end

	if JumpBoost_State then
		hum.JumpPower = JumpBoost_Value
	else
		hum.JumpPower = defaultJumpPower
	end

	-- NOCLIP (Dùng lệnh Executor nếu có để chắc chắn xuyên tường)
	if Noclip_State then
		-- Thử dùng lệnh chuẩn của Executor
		if sethiddenproperty then
			sethiddenproperty(root, "CanCollide", false)
		else
			root.CanCollide = false
		end
		-- Xử lý riêng cho các khớp
		for _, part in ipairs(char:GetChildren()) do
			if part:IsA("BasePart") then
				if sethiddenproperty then
					sethiddenproperty(part, "CanCollide", false)
				else
					part.CanCollide = false
				end
			end
		end
	else
		-- Reset lại khi tắt
		if sethiddenproperty then
			sethiddenproperty(root, "CanCollide", true)
		else
			root.CanCollide = true
		end
		for _, part in ipairs(char:GetChildren()) do
			if part:IsA("BasePart") then
				if sethiddenproperty then
					sethiddenproperty(part, "CanCollide", true)
				else
					part.CanCollide = true
				end
			end
		end
	end

	-- HITBOX: Thay đổi kích thước và màu của TẤT CẢ NGƯỜI CHƠI TRONG SERVER
	if Hitbox_State then
		Hitbox_Value = hitboxSliderGetter()
		Hitbox_Color = hitboxColorGetter()
		
		local scale = Hitbox_Value / 10 -- Chỉnh tỷ lệ to lên

		for _, plr in ipairs(Players:GetPlayers()) do
			local char2 = plr.Character
			if char2 then
				local root2 = char2:FindFirstChild("HumanoidRootPart")
				if root2 then
					-- Đổi size to
					root2.Size = Vector3.new(2 + scale, 2 + scale, 1 + scale)
					
					-- Đổi màu
					if Hitbox_Color == "Rainbow" then
						root2.Color = Color3.fromHSV(tick() % 1, 1, 1)
					else
						root2.Color = Hitbox_Color
					end
				end
			end
		end
	else
		-- Reset về mặc định khi tắt
		for _, plr in ipairs(Players:GetPlayers()) do
			local char2 = plr.Character
			if char2 then
				local root2 = char2:FindFirstChild("HumanoidRootPart")
				if root2 then
					root2.Size = Vector3.new(2, 2, 1)
					root2.Color = Color3.fromRGB(255, 255, 255)
				end
			end
		end
	end
end)
-- ==========================================================
-- PHẦN 7: LOGIC ESP - HIỆN TẤT CẢ NGƯỜI CHƠI & QUÁI VẬT
-- ==========================================================
RunService.RenderStepped:Connect(function()
	-- Lấy màu đang chọn từ menu
	ESP_Color = espColorGetter()

	-- Xóa toàn bộ Drawing cũ nếu tắt ESP hoặc Mob
	if not ESP_State and not ESPMob_State then
		for _, d in ipairs(getgc(true)) do
			if typeof(d) == "Drawing" then d:Remove() end
		end
		return
	end

	-- Vẽ ESP cho Người Chơi
	if ESP_State then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
				if hrp and hrp:IsA("BasePart") then
					local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
					if onScreen then
						local box = Drawing.new("Box")
						box.Size = Vector2.new(60, 90)
						box.Position = Vector2.new(pos.X - 30, pos.Y - 60)
						box.Color = ESP_Color
						box.Thickness = 2
						box.Visible = true
					end
				end
			end
		end
	end

	-- Vẽ ESP cho Quái Vật (Mob)
	if ESPMob_State then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Humanoid") and obj.Parent and obj.Parent:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj.Parent) then
				local hrp = obj.Parent:FindFirstChild("HumanoidRootPart")
				if hrp then
					local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
					if onScreen then
						local box = Drawing.new("Box")
						box.Size = Vector2.new(40, 60)
						box.Position = Vector2.new(pos.X - 20, pos.Y - 40)
						box.Color = Color3.fromRGB(255, 100, 0) -- Màu cam cho quái
						box.Thickness = 2
						box.Visible = true
					end
				end
			end
		end
	end
end)
