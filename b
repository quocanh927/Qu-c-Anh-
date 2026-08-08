--[[
════════════════════════════════════════════════════════════════════
   👑 Quốc Anh Hub — Menu tiện ích
   Tính năng: Fix Lag, ESP Player, Fullbright, Speed, JumpBoost,
             Hitbox, Aimlock
────────────────────────────────────────────────────────────────────
   MỞ MENU: phím RightShift hoặc nút tròn "QA"
════════════════════════════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualInput = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

local THEME = {
    Accent  = Color3.fromRGB(0, 219, 146),
    Accent2 = Color3.fromRGB(0, 168, 232),
    Bg      = Color3.fromRGB(17, 18, 24),
    BgLight = Color3.fromRGB(24, 26, 33),
    Card    = Color3.fromRGB(28, 30, 39),
    Card2   = Color3.fromRGB(33, 36, 47),
    Stroke  = Color3.fromRGB(45, 49, 62),
    Text    = Color3.fromRGB(238, 240, 246),
    Dim     = Color3.fromRGB(133, 141, 158),
    Off     = Color3.fromRGB(54, 58, 72),
    Red     = Color3.fromRGB(230, 46, 46),
    Warn    = Color3.fromRGB(255, 190, 80),
}

local State = {
    FixLag = false, EspPlayer = false, Fullbright = false,
    Speed = false, JumpBoost = false,
    Hitbox = false, Aimlock = false,
    SpeedValue = 45, JumpValue = 90,
    HitboxSize = 5,
    MenuOpen = true,
}

------------------------------------------------------------------
-- HELPERS
------------------------------------------------------------------
local function new(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function corner(p, r)
    return new("UICorner", { CornerRadius = UDim.new(0, r), Parent = p })
end
local function stroke(p, c, t)
    return new("UIStroke", { Color = c or THEME.Stroke, Thickness = t or 1, Parent = p })
end
local function gradient(p, c1, c2, rot, trans)
    return new("UIGradient", { Parent = p, Rotation = rot or 90,
        Color = ColorSequence.new(c1, c2),
        Transparency = trans or NumberSequence.new(0) })
end

local function tween(inst, time, props, style)
    local tw = TweenService:Create(inst, TweenInfo.new(time, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function getHum()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function makeDraggable(handle, target, onTap)
    local dragging, startPos, startAbs, moved = false, nil, nil, 0
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, moved = true, 0
            startAbs, startPos = input.Position, target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - startAbs
            moved = math.max(moved, math.abs(d.X) + math.abs(d.Y))
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                        startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if onTap and moved < 8 then onTap() end
        end
    end)
end

------------------------------------------------------------------
-- GUI
------------------------------------------------------------------
local old = LocalPlayer.PlayerGui:FindFirstChild("QuocAnhHub")
if old then old:Destroy() end

local gui = new("ScreenGui", {
    Name = "QuocAnhHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999,
    Parent = LocalPlayer.PlayerGui
})

local root = new("Frame", {
    Name = "Root", Parent = gui,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(304, 390),
    BackgroundTransparency = 1,
    Visible = State.MenuOpen,
})
local uiScale = new("UIScale", { Parent = root })
local function fitScreen()
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    return math.clamp(math.min(vp.Y / 540, vp.X / 480), 0.66, 1)
end
uiScale.Scale = fitScreen()

local glow = new("Frame", {
    Parent = root, ZIndex = 0,
    Position = UDim2.new(0, -8, 0, -8),
    Size = UDim2.new(1, 16, 1, 16),
    BackgroundColor3 = THEME.Accent,
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0,
})
corner(glow, 22)
gradient(glow, THEME.Accent, THEME.Accent2, 140)

local main = new("Frame", {
    Parent = root, ZIndex = 1,
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = THEME.Bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
})
corner(main, 16)
stroke(main, THEME.Stroke, 1)
gradient(main, THEME.BgLight, THEME.Bg, 90)

------------------------------------------------------------------
-- HEADER
------------------------------------------------------------------
local header = new("Frame", {
    Parent = main,
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundColor3 = THEME.Card,
    BackgroundTransparency = 0.45,
    BorderSizePixel = 0,
    Active = true,
})
gradient(header, THEME.Accent, THEME.Card, 0,
    NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.82),
        NumberSequenceKeypoint.new(0.55, 1),
        NumberSequenceKeypoint.new(1, 1),
    }))

local accentBar = new("Frame", {
    Parent = header,
    Position = UDim2.new(0, 14, 0, 15),
    Size = UDim2.fromOffset(3, 30),
    BackgroundColor3 = THEME.Accent,
    BorderSizePixel = 0,
})
corner(accentBar, 2)
gradient(accentBar, THEME.Accent, THEME.Accent2, 90)

new("TextLabel", {
    Parent = header,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 26, 0, 13),
    Size = UDim2.new(1, -110, 0, 20),
    Font = Enum.Font.GothamBold,
    Text = "👑 Quốc Anh",
    TextSize = 17,
    TextColor3 = THEME.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
})
new("TextLabel", {
    Parent = header,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 26, 0, 33),
    Size = UDim2.new(1, -110, 0, 14),
    Font = Enum.Font.Gotham,
    Text = "by QuocAnhMenu",
    TextSize = 11,
    TextColor3 = THEME.Dim,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local fpsPill = new("Frame", {
    Parent = header,
    Position = UDim2.new(1, -108, 0, 17),
    Size = UDim2.fromOffset(56, 20),
    BackgroundColor3 = THEME.Bg,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
})
corner(fpsPill, 10)
stroke(fpsPill, THEME.Stroke, 1)
local fpsLabel = new("TextLabel", {
    Parent = fpsPill,
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Font = Enum.Font.GothamBold,
    Text = "-- FPS",
    TextSize = 10,
    TextColor3 = THEME.Dim,
})

local closeBtn = new("TextButton", {
    Parent = header,
    AutoButtonColor = false,
    Position = UDim2.new(1, -44, 0, 16),
    Size = UDim2.fromOffset(28, 28),
    BackgroundColor3 = THEME.Card2,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "✕",
    TextSize = 13,
    TextColor3 = THEME.Dim,
})
corner(closeBtn, 9)
stroke(closeBtn, THEME.Stroke, 1)
closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.15, { BackgroundColor3 = THEME.Red, TextColor3 = Color3.new(1, 1, 1) })
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.15, { BackgroundColor3 = THEME.Card2, TextColor3 = THEME.Dim })
end)

new("Frame", {
    Parent = main,
    Position = UDim2.new(0, 0, 0, 60),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = THEME.Stroke,
    BorderSizePixel = 0,
})
------------------------------------------------------------------
-- BODY
------------------------------------------------------------------
local body = new("ScrollingFrame", {
    Parent = main,
    Position = UDim2.new(0, 0, 0, 61),
    Size = UDim2.new(1, 0, 1, -61),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = THEME.Accent,
    ScrollBarImageTransparency = 0.5,
    ClipsDescendants = true,
})
new("UIListLayout", {
    Parent = body,
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
})
new("UIPadding", {
    Parent = body,
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12),
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 12),
})

------------------------------------------------------------------
-- NÚT TRÒN MỞ MENU (QA)
------------------------------------------------------------------
local fab = new("TextButton", {
    Name = "Fab",
    Parent = gui,
    AutoButtonColor = false,
    Position = UDim2.new(0, 16, 0.5, -27),
    Size = UDim2.fromOffset(54, 54),
    BackgroundColor3 = THEME.Accent,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBlack,
    Text = "QA",
    TextSize = 18,
    TextColor3 = Color3.fromRGB(8, 22, 18),
})
corner(fab, 27)
gradient(fab, THEME.Accent, THEME.Accent2, 135)
stroke(fab, Color3.new(1, 1, 1), 1.5).Transparency = 0.72

------------------------------------------------------------------
-- COMPONENTS
------------------------------------------------------------------
local function makeSwitch(parent, onChange)
    local btn = new("TextButton", {
        Parent = parent,
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(44, 23),
        BackgroundColor3 = THEME.Off,
        BorderSizePixel = 0,
        Text = "",
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn })
    local glowStroke = new("UIStroke", {
        Parent = btn,
        Color = THEME.Accent,
        Thickness = 1.5,
        Transparency = 1,
    })
    local knob = new("Frame", {
        Parent = btn,
        Size = UDim2.fromOffset(17, 17),
        Position = UDim2.new(0, 3, 0.5, -8.5),
        BackgroundColor3 = Color3.fromRGB(246, 248, 252),
        BorderSizePixel = 0,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

    local on = false
    local function render(animate)
        local d = animate and 0.16 or 0
        tween(btn, d, { BackgroundColor3 = on and THEME.Accent or THEME.Off })
        tween(glowStroke, d, { Transparency = on and 0.55 or 1 })
        tween(knob, d, {
            Position = on and UDim2.new(1, -20, 0.5, -8.5) or UDim2.new(0, 3, 0.5, -8.5),
        }, Enum.EasingStyle.Back)
    end

    local api = {}
    function api.Set(value, silent)
        if on == value then return end
        on = value
        render(true)
        if not silent and onChange then onChange(on) end
    end
    function api.Get() return on end

    btn.MouseButton1Click:Connect(function() api.Set(not on) end)
    render(false)
    return api
end

local function makeSlider(parent, opts)
    local holder = new("Frame", {
        Parent = parent,
        LayoutOrder = opts.order or 2,
        Visible = opts.visible ~= false,
        Size = UDim2.new(1, 0, 0, opts.label and 44 or 32),
        BackgroundTransparency = 1,
    })
    new("UIPadding", {
        Parent = holder,
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 10),
    })

    local yOff = 0
    if opts.label then
        new("TextLabel", {
            Parent = holder,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 13),
            Font = Enum.Font.Gotham,
            Text = opts.label,
            TextSize = 10.5,
            TextColor3 = THEME.Dim,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        yOff = 13
    end

    local track = new("Frame", {
        Parent = holder,
        Position = UDim2.new(0, 0, 0, yOff + 8),
        Size = UDim2.new(1, -46, 0, 6),
        BackgroundColor3 = THEME.Off,
        BorderSizePixel = 0,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

    local fill = new("Frame", {
        Parent = track,
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = THEME.Accent,
        BorderSizePixel = 0,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
    gradient(fill, THEME.Accent2, THEME.Accent, 0)

    local knob = new("Frame", {
        Parent = track,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(15, 15),
        BackgroundColor3 = Color3.fromRGB(246, 248, 252),
        BorderSizePixel = 0,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

    local valueLabel = new("TextLabel", {
        Parent = holder,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, yOff + 2),
        Size = UDim2.fromOffset(42, 16),
        Font = Enum.Font.GothamBold,
        Text = tostring(opts.default),
        TextSize = 12,
        TextColor3 = THEME.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    local hit = new("TextButton", {
        Parent = holder,
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Position = UDim2.new(0, -8, 0, yOff),
        Size = UDim2.new(1, -30, 0, 26),
    })

    local value = opts.default
    local function render()
        local a = (value - opts.min) / (opts.max - opts.min)
        fill.Size = UDim2.fromScale(a, 1)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
        valueLabel.Text = tostring(value)
    end

    local function setFromX(x)
        local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        local v = math.floor(opts.min + (opts.max - opts.min) * a + 0.5)
        if v ~= value then
            value = v
            render()
            if opts.onChanged then opts.onChanged(value) end
        end
    end

    local dragging = false
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            tween(knob, 0.1, { Size = UDim2.fromOffset(19, 19) })
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            tween(knob, 0.12, { Size = UDim2.fromOffset(15, 15) })
        end
    end)

    render()
    return holder
end

local rowOrder = 0
local function addSection(text)
    rowOrder += 1
    local f = new("Frame", {
        Parent = body,
        LayoutOrder = rowOrder,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
    })
    new("TextLabel", {
        Parent = f,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 4, 0, 6),
        Size = UDim2.new(1, -8, 0, 12),
        Font = Enum.Font.GothamBold,
        Text = text,
        TextSize = 10,
        TextColor3 = THEME.Dim,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    return f
end

local function addFeature(opts)
    rowOrder += 1
    local card = new("Frame", {
        Parent = body,
        LayoutOrder = rowOrder,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = THEME.Card,
        BorderSizePixel = 0,
    })
    corner(card, 11)
    gradient(card, THEME.Card2, THEME.Card, 90)
    local cardStroke = stroke(card, THEME.Stroke, 1)
    new("UIListLayout", { Parent = card, SortOrder = Enum.SortOrder.LayoutOrder })

    local head = new("Frame", {
        Parent = card,
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
    })

    local activeBar = new("Frame", {
        Parent = head,
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = THEME.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2,
    })

    local iconBox = new("Frame", {
        Parent = head,
        Position = UDim2.new(0, 12, 0.5, -15),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = opts.color or THEME.Accent,
        BackgroundTransparency = 0.87,
        BorderSizePixel = 0,
    })
    corner(iconBox, 9)
    new("TextLabel", {
        Parent = iconBox,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Font = Enum.Font.GothamBold,
        Text = opts.icon,
        TextSize = 15,
        TextColor3 = THEME.Text,
    })

    new("TextLabel", {
        Parent = head,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 51, 0, 10),
        Size = UDim2.new(1, -120, 0, 16),
        Font = Enum.Font.GothamBold,
        Text = opts.title,
        TextSize = 13,
        TextColor3 = THEME.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    new("TextLabel", {
        Parent = head,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 51, 0, 27),
        Size = UDim2.new(1, -120, 0, 13),
        Font = Enum.Font.Gotham,
        Text = opts.desc or "",
        TextSize = 10.5,
        TextColor3 = THEME.Dim,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    local extras = {}
    local function setActive(on)
        tween(activeBar, 0.18, { BackgroundTransparency = on and 0 or 1 })
        tween(cardStroke, 0.18, { Color = on and (opts.color or THEME.Accent) or THEME.Stroke })
        tween(iconBox, 0.18, { BackgroundTransparency = on and 0.72 or 0.87 })
        for _, e in ipairs(extras) do e.Visible = on end
    end

    local switch = makeSwitch(head, function(on)
        setActive(on)
        opts.onToggle(on)
    end)

    local api = { Card = card, Switch = switch }
    function api.Set(v, silent)
        switch.Set(v, silent)
        if silent then setActive(v) end
    end
    function api.Get() return switch.Get() end

    if opts.slider then
        opts.slider.order = 2
        opts.slider.visible = false
        extras[#extras + 1] = makeSlider(card, opts.slider)
    end
    return api
end
------------------------------------------------------------------
-- CHỨC NĂNG: FIX LAG
------------------------------------------------------------------
local FixLag = {}
do
    local saved, conn, active = {}, nil, false

    local function set(inst, prop, value)
        local ok, old = pcall(function() return inst[prop] end)
        if ok then
            saved[#saved + 1] = { inst, prop, old }
            pcall(function() inst[prop] = value end)
        end
    end

    local function process(inst)
        if inst:IsA("Terrain") then
            set(inst, "Decoration", false)
            set(inst, "WaterWaveSize", 0)
            set(inst, "WaterWaveSpeed", 0)
            set(inst, "WaterReflectance", 0)
        elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke")
            or inst:IsA("Fire") or inst:IsA("Sparkles") then
            if inst.Enabled then set(inst, "Enabled", false) end
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            if inst.Transparency < 1 then set(inst, "Transparency", 1) end
        elseif inst:IsA("BasePart") then
            if inst.Material ~= Enum.Material.SmoothPlastic then set(inst, "Material", Enum.Material.SmoothPlastic) end
            if inst.Reflectance > 0 then set(inst, "Reflectance", 0) end
            if inst.CastShadow then set(inst, "CastShadow", false) end
        end
    end

    local function isCreature(model)
        return model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") ~= nil
    end

    function FixLag.SetEnabled(on)
        if on == active then return end
        active = on

        if on then
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)

            set(Lighting, "GlobalShadows", false)
            set(Lighting, "EnvironmentDiffuseScale", 0)
            set(Lighting, "EnvironmentSpecularScale", 0)
            for _, fx in ipairs(Lighting:GetChildren()) do
                if fx:IsA("PostEffect") and fx.Enabled then set(fx, "Enabled", false) end
            end

            local count = 0
            for _, child in ipairs(workspace:GetChildren()) do
                if not isCreature(child) then
                    process(child)
                    for _, d in ipairs(child:GetDescendants()) do
                        process(d)
                        count += 1
                        if count % 400 == 0 then task.wait() end
                    end
                end
            end

            conn = workspace.DescendantAdded:Connect(function(inst)
                if not active then return end
                task.defer(function()
                    local model = inst:FindFirstAncestorOfClass("Model")
                    if model and isCreature(model) then return end
                    process(inst)
                end)
            end)
        else
            if conn then conn:Disconnect(); conn = nil end
            for i = #saved, 1, -1 do
                local rec = saved[i]
                pcall(function() rec[1][rec[2]] = rec[3] end)
            end
            table.clear(saved)
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            end)
        end
    end
end

------------------------------------------------------------------
-- CHỨC NĂNG: ESP NGƯỜI CHƠI
------------------------------------------------------------------
local ESP = {}
do
    local folder, entries = nil, {}
    local playerConns = {}

    local function ensureFolder()
        if not folder or not folder.Parent then
            folder = new("Folder", { Name = "QA_ESP", Parent = workspace.CurrentCamera or workspace })
        end
        return folder
    end

    local function destroyEntry(model)
        local e = entries[model]
        if not e then return end
        if e.highlight then e.highlight:Destroy() end
        if e.billboard then e.billboard:Destroy() end
        entries[model] = nil
    end

    local function addPlayer(player)
        if player == LocalPlayer then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local anchor = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not anchor then return end

        if entries[char] then return end

        local e = { kind = "player", hum = hum, anchor = anchor }
        e.highlight = new("Highlight", {
            Parent = ensureFolder(), Adornee = char,
            DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
            FillColor = THEME.Accent, FillTransparency = 0.72,
            OutlineColor = THEME.Accent, OutlineTransparency = 0,
        })
        e.billboard = new("BillboardGui", {
            Parent = ensureFolder(), Adornee = anchor,
            Size = UDim2.fromOffset(190, 34), StudsOffset = Vector3.new(0, 2.4, 0),
            AlwaysOnTop = true, MaxDistance = 3000, LightInfluence = 0,
        })
        new("TextLabel", {
            Parent = e.billboard, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 17),
            Font = Enum.Font.GothamBold, Text = player.Name, TextSize = 13,
            TextColor3 = THEME.Accent, TextStrokeTransparency = 0.35,
            TextStrokeColor3 = Color3.new(0, 0, 0), TextTruncate = Enum.TextTruncate.AtEnd,
        })
        e.info = new("TextLabel", {
            Parent = e.billboard, BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 17), Size = UDim2.new(1, 0, 0, 14),
            Font = Enum.Font.Gotham, Text = "", TextSize = 10, TextColor3 = THEME.Dim,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        entries[char] = e
    end

    local function clearAll()
        for model, e in pairs(entries) do
            destroyEntry(model)
        end
        entries = {}
        for _, c in ipairs(playerConns) do
            pcall(c.Disconnect, c)
        end
        playerConns = {}
    end

    function ESP.SetEnabled(on)
        clearAll()
        if not on then return end

        for _, p in ipairs(Players:GetPlayers()) do
            addPlayer(p)
        end

        local conn1 = Players.PlayerAdded:Connect(function(p)
            task.wait(0.5)
            addPlayer(p)
        end)
        table.insert(playerConns, conn1)

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local conn2 = p.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    addPlayer(p)
                end)
                table.insert(playerConns, conn2)
            end
        end

        RunService.Heartbeat:Connect(function()
            for model, e in pairs(entries) do
                if e.hum and e.hum.Parent then
                    local health = math.floor(e.hum.Health)
                    e.info.Text = health .. " HP"
                end
            end
        end)
    end
end

------------------------------------------------------------------
-- CHỨC NĂNG: HITBOX
------------------------------------------------------------------
local Hitbox = {}
do
    local originalSizes = {}

    function Hitbox.Apply()
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                pcall(function()
                    local root = v.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        if State.Hitbox then
                            if not originalSizes[root] then
                                originalSizes[root] = root.Size
                            end
                            root.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                            root.Transparency = 0.7
                            root.BrickColor = BrickColor.new("Really blue")
                            root.Material = Enum.Material.Neon
                            root.CanCollide = true
                        else
                            local orig = originalSizes[root]
                            root.Size = orig or Vector3.new(2, 2, 1)
                            root.Transparency = 0
                            root.BrickColor = BrickColor.new("Medium stone grey")
                            root.Material = Enum.Material.Plastic
                            root.CanCollide = true
                        end
                    end
                end)
            end
        end
    end

    function Hitbox.SetEnabled(on)
        State.Hitbox = on
        Hitbox.Apply()
    end

    function Hitbox.SetSize(newSize)
        State.HitboxSize = newSize
        if State.Hitbox then
            Hitbox.Apply()
        end
    end
end

RunService.RenderStepped:Connect(function()
    if State.Hitbox then
        Hitbox.Apply()
    else
        Hitbox.Apply()
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.3)
        if State.Hitbox then Hitbox.Apply() end
    end)
end)

------------------------------------------------------------------
-- CHỨC NĂNG: AIMLOCK
------------------------------------------------------------------
local Aimlock = {}
do
    local target = nil
    local enabled = false
    local FOV = 180
    local smooth = 0.18
    local AUTO_SHOOT = true
    local connection = nil

    local function getAimPart(char)
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    end

    local function findTarget()
        local best, bestDist = nil, FOV
        local cam = workspace.CurrentCamera
        local center = cam.ViewportSize / 2
        for _, other in ipairs(Players:GetPlayers()) do
            if other ~= LocalPlayer and other.Character then
                local hum = other.Character:FindFirstChildOfClass("Humanoid")
                local aim = getAimPart(other.Character)
                if hum and hum.Health > 0 and aim then
                    local screen, vis = cam:WorldToViewportPoint(aim.Position)
                    if vis then
                        local d = (Vector2.new(screen.X, screen.Y) - center).Magnitude
                        if d < bestDist then
                            bestDist = d
                            best = other
                        end
                    end
                end
            end
        end
        return best
    end

    local function shoot()
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                local remote = tool:FindFirstChild("RemoteEvent")
                if remote then
                    remote:FireServer()
                else
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.03)
                    VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            else
                VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.03)
                VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end
        end
    end

    function Aimlock.SetEnabled(on)
        enabled = on
        if on then
            target = findTarget()
            if connection then connection:Disconnect() end
            connection = RunService.RenderStepped:Connect(function()
                if not enabled then return end
                if not target or not target.Character then
                    target = findTarget()
                    return
                end
                local hum = target.Character:FindFirstChildOfClass("Humanoid")
                local aim = getAimPart(target.Character)
                if not hum or hum.Health <= 0 or not aim then
                    target = findTarget()
                    return
                end
                local pos = aim.Position
                local cam = workspace.CurrentCamera
                local wanted = CFrame.lookAt(cam.CFrame.Position, pos)
                cam.CFrame = cam.CFrame:Lerp(wanted, smooth)
                if AUTO_SHOOT then
                    local screen, vis = cam:WorldToViewportPoint(pos)
                    if vis then
                        local center = cam.ViewportSize / 2
                        local d = (Vector2.new(screen.X, screen.Y) - center).Magnitude
                        if d < FOV * 0.3 then
                            shoot()
                        end
                    end
                end
            end)
        else
            if connection then connection:Disconnect(); connection = nil end
            target = nil
        end
    end
end

------------------------------------------------------------------
-- HÀM SPEED & JUMPBOOST
------------------------------------------------------------------
local function applySpeed()
    local hum = getHum()
    if hum then
        hum.WalkSpeed = State.Speed and State.SpeedValue or 16
    end
end

local function applyJump()
    local hum = getHum()
    if hum then
        hum.JumpPower = State.JumpBoost and State.JumpValue or 50
    end
end

------------------------------------------------------------------
-- TẠO MENU
------------------------------------------------------------------
addSection("🖼 HÌNH ẢNH")
addFeature({
    icon = "🔧", title = "Fix Lag", desc = "Tắt hiệu ứng, giảm lag",
    color = THEME.Accent,
    onToggle = function(on) FixLag.SetEnabled(on) end,
})
addFeature({
    icon = "👁", title = "ESP Người chơi", desc = "Hiển thị tên + viền",
    color = THEME.Accent,
    onToggle = function(on) ESP.SetEnabled(on) end,
})
addFeature({
    icon = "☀️", title = "Fullbright", desc = "Sáng hơn",
    color = THEME.Warn,
    onToggle = function(on)
        State.Fullbright = on
        Lighting.Brightness = on and 2 or 1
        Lighting.ClockTime = on and 12 or 9
    end,
})

addSection("🏃 DI CHUYỂN")
addFeature({
    icon = "⚡", title = "Speed", desc = "Tăng tốc độ chạy",
    color = THEME.Accent,
    onToggle = function(on) State.Speed = on; applySpeed() end,
    slider = {
        label = "Tốc độ", min = 16, max = 100, default = 45,
        onChanged = function(v) State.SpeedValue = v; if State.Speed then applySpeed() end end,
    },
})
addFeature({
    icon = "🦘", title = "JumpBoost", desc = "Nhảy cao hơn",
    color = THEME.Warn,
    onToggle = function(on) State.JumpBoost = on; applyJump() end,
    slider = {
        label = "Độ cao", min = 50, max = 150, default = 90,
        onChanged = function(v) State.JumpValue = v; if State.JumpBoost then applyJump() end end,
    },
})

addSection("🎯 CHIẾN ĐẤU")
addFeature({
    icon = "📦", title = "Hitbox", desc = "Phóng to hitbox người chơi",
    color = THEME.Accent,
    onToggle = function(on) Hitbox.SetEnabled(on) end,
    slider = {
        label = "Kích thước", min = 1, max = 50, default = 5,
        onChanged = function(v) Hitbox.SetSize(v) end,
    },
})
addFeature({
    icon = "🎯", title = "Aimlock", desc = "Tự nhắm vào người gần nhất",
    color = THEME.Red,
    onToggle = function(on) Aimlock.SetEnabled(on) end,
})
------------------------------------------------------------------
-- SỰ KIỆN
------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        State.MenuOpen = not State.MenuOpen
        root.Visible = State.MenuOpen
        if State.MenuOpen then
            fab.Visible = false
            tween(root, 0.2, { Size = UDim2.fromOffset(304, 390) })
        else
            fab.Visible = true
            tween(root, 0.2, { Size = UDim2.fromOffset(0, 0) })
        end
    end
end)

fab.MouseButton1Click:Connect(function()
    State.MenuOpen = true
    root.Visible = true
    fab.Visible = false
    tween(root, 0.2, { Size = UDim2.fromOffset(304, 390) })
end)

closeBtn.MouseButton1Click:Connect(function()
    State.MenuOpen = false
    root.Visible = false
    fab.Visible = true
    tween(root, 0.2, { Size = UDim2.fromOffset(0, 0) })
end)

makeDraggable(header, root, nil)
makeDraggable(fab, fab, nil)

RunService.Heartbeat:Connect(function()
    if not root.Visible then return end
    local fps = math.floor(1 / RunService.Heartbeat:Wait())
    fpsLabel.Text = fps .. " FPS"
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    if State.Speed then applySpeed() end
    if State.JumpBoost then applyJump() end
    if State.Hitbox then Hitbox.Apply() end
end)

fab.Visible = false
print("👑 Quốc Anh Hub loaded!")
