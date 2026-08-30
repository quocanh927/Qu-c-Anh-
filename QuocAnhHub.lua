-- QUOC ANH HUB - ROBLOX STUDIO TEST
-- LocalScript -> StarterPlayer > StarterPlayerScripts

local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local LP=Players.LocalPlayer
local PG=LP:WaitForChild("PlayerGui")

local S={
 Speed=16,Jump=50,Noclip=false,InfJump=false,ESP=false,
 Hitbox=false,HitboxSize=4,HitboxColor=Color3.fromRGB(255,70,70),
 Aim=false,AimFOV=120
}
local Char,Hum,Root,Target
local ESPs,Old={},{}

local function char(c)
 Char=c Hum=c:WaitForChild("Humanoid") Root=c:WaitForChild("HumanoidRootPart")
 Hum.WalkSpeed=S.Speed Hum.UseJumpPower=true Hum.JumpPower=S.Jump
end
if LP.Character then char(LP.Character) end
LP.CharacterAdded:Connect(char)

local G=Instance.new("ScreenGui",PG);G.Name="QuocAnhHub";G.ResetOnSpawn=false;G.IgnoreGuiInset=true
local Main=Instance.new("Frame",G);Main.AnchorPoint=Vector2.new(.5,.5);Main.Position=UDim2.fromScale(.5,.5)
Main.Size=UDim2.fromScale(.86,.82);Main.BackgroundColor3=Color3.fromRGB(18,19,24);Main.BorderSizePixel=0
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,18)
local st=Instance.new("UIStroke",Main);st.Color=Color3.fromRGB(55,57,70);st.Thickness=1.5

local Title=Instance.new("TextLabel",Main);Title.Position=UDim2.fromOffset(20,8);Title.Size=UDim2.new(1,-80,0,30)
Title.BackgroundTransparency=1;Title.Text="QUOC ANH";Title.TextColor3=Color3.fromRGB(255,214,70)
Title.Font=Enum.Font.GothamBold;Title.TextSize=21;Title.TextXAlignment=Enum.TextXAlignment.Left
local Sub=Instance.new("TextLabel",Main);Sub.Position=UDim2.fromOffset(21,36);Sub.Size=UDim2.new(1,-80,0,16)
Sub.BackgroundTransparency=1;Sub.Text="STUDIO TEST MENU";Sub.TextColor3=Color3.fromRGB(145,148,160)
Sub.Font=Enum.Font.GothamMedium;Sub.TextSize=10;Sub.TextXAlignment=Enum.TextXAlignment.Left
local Close=Instance.new("TextButton",Main);Close.Position=UDim2.new(1,-55,0,12);Close.Size=UDim2.fromOffset(38,38)
Close.Text="×";Close.TextSize=25;Close.Font=Enum.Font.GothamBold;Close.TextColor3=Color3.new(1,1,1)
Close.BackgroundColor3=Color3.fromRGB(48,49,58);Close.BorderSizePixel=0
Instance.new("UICorner",Close).CornerRadius=UDim.new(0,10)

local Sc=Instance.new("ScrollingFrame",Main);Sc.Position=UDim2.fromOffset(12,70);Sc.Size=UDim2.new(1,-24,1,-82)
Sc.BackgroundTransparency=1;Sc.BorderSizePixel=0;Sc.ScrollBarThickness=3;Sc.AutomaticCanvasSize=Enum.AutomaticSize.Y
local Pad=Instance.new("UIPadding",Sc);Pad.PaddingLeft=UDim.new(0,3);Pad.PaddingRight=UDim.new(0,3);Pad.PaddingBottom=UDim.new(0,15)
local Lay=Instance.new("UIListLayout",Sc);Lay.Padding=UDim.new(0,9)

local function section(t)
 local x=Instance.new("TextLabel",Sc);x.Size=UDim2.new(1,-5,0,25);x.BackgroundTransparency=1;x.Text=t
 x.TextColor3=Color3.fromRGB(255,214,70);x.Font=Enum.Font.GothamBold;x.TextSize=13;x.TextXAlignment=Enum.TextXAlignment.Left
end

local function toggle(t,cb)
 local b=Instance.new("TextButton",Sc);b.Size=UDim2.new(1,-5,0,46);b.Text="";b.BackgroundColor3=Color3.fromRGB(30,31,39);b.BorderSizePixel=0
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)
 local n=Instance.new("TextLabel",b);n.Position=UDim2.fromOffset(15,0);n.Size=UDim2.new(1,-80,1,0);n.BackgroundTransparency=1;n.Text=t
 n.TextColor3=Color3.fromRGB(235,236,240);n.Font=Enum.Font.GothamMedium;n.TextSize=13;n.TextXAlignment=Enum.TextXAlignment.Left
 local q=Instance.new("TextLabel",b);q.Position=UDim2.new(1,-56,.5,-12);q.Size=UDim2.fromOffset(42,24);q.Font=Enum.Font.GothamBold;q.TextSize=10;q.TextColor3=Color3.new(1,1,1)
 Instance.new("UICorner",q).CornerRadius=UDim.new(1,0)
 local v=false
 local function refresh() q.Text=v and"ON"or"OFF";q.BackgroundColor3=v and Color3.fromRGB(66,150,91)or Color3.fromRGB(65,66,76) end
 refresh()
 b.Activated:Connect(function()v=not v;refresh();cb(v)end)
end

local function slider(t,mi,ma,def,cb)
 local h=Instance.new("Frame",Sc);h.Size=UDim2.new(1,-5,0,62);h.BackgroundColor3=Color3.fromRGB(30,31,39);h.BorderSizePixel=0
 Instance.new("UICorner",h).CornerRadius=UDim.new(0,12)
 local l=Instance.new("TextLabel",h);l.Position=UDim2.fromOffset(15,6);l.Size=UDim2.new(1,-30,0,20);l.BackgroundTransparency=1
 l.TextColor3=Color3.fromRGB(235,236,240);l.Font=Enum.Font.GothamMedium;l.TextSize=12;l.TextXAlignment=Enum.TextXAlignment.Left
 local bar=Instance.new("Frame",h);bar.Position=UDim2.new(0,15,0,38);bar.Size=UDim2.new(1,-30,0,7);bar.BackgroundColor3=Color3.fromRGB(60,61,72);bar.BorderSizePixel=0
 Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
 local fill=Instance.new("Frame",bar);fill.BackgroundColor3=Color3.fromRGB(255,214,70);fill.BorderSizePixel=0
 Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
 local drag=false
 local function upd(x)
  local p=math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1);local v=math.floor(mi+(ma-mi)*p)
  fill.Size=UDim2.fromScale(p,1);l.Text=t.."   "..v;cb(v)
 end
 upd(bar.AbsolutePosition.X+bar.AbsoluteSize.X*(def-mi)/(ma-mi))
 bar.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true;upd(i.Position.X)end end)
 UIS.InputChanged:Connect(function(i)if drag and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then upd(i.Position.X)end end)
 UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end end)
end

section("PLAYER")
slider("Speed",8,100,S.Speed,function(v)S.Speed=v;if Hum then Hum.WalkSpeed=v end end)
slider("Jump Power",25,150,S.Jump,function(v)S.Jump=v;if Hum then Hum.JumpPower=v end end)
toggle("Noclip",function(v)S.Noclip=v end)
toggle("Infinite Jump",function(v)S.InfJump=v end)
UIS.JumpRequest:Connect(function()if S.InfJump and Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping)end end)

section("VISUAL")
local function rem(p)if ESPs[p]then ESPs[p]:Destroy();ESPs[p]=nil end end
local function esp(p)
 if p==LP or not p.Character then return end
 local head=p.Character:FindFirstChild("Head");if not head then return end
 rem(p)
 local bb=Instance.new("BillboardGui",head);bb.Name="QA_NameESP";bb.Adornee=head;bb.AlwaysOnTop=true;bb.MaxDistance=math.huge
 bb.Size=UDim2.fromOffset(190,35);bb.StudsOffset=Vector3.new(0,2.8,0)
 local tx=Instance.new("TextLabel",bb);tx.Size=UDim2.fromScale(1,1);tx.BackgroundTransparency=1;tx.Text=p.DisplayName
 tx.TextColor3=Color3.new(1,1,1);tx.TextStrokeTransparency=0;tx.Font=Enum.Font.GothamBold;tx.TextSize=14
 ESPs[p]=bb
end
local function refreshESP()for _,p in ipairs(Players:GetPlayers())do if p~=LP then if S.ESP then esp(p)else rem(p)end end end end
toggle("Player Name ESP",function(v)S.ESP=v;refreshESP()end)

section("HITBOX")
local function hitboxes()
 for _,p in ipairs(Players:GetPlayers())do
  if p~=LP and p.Character then
   local r=p.Character:FindFirstChild("HumanoidRootPart")
   if r then
    if not Old[p]then Old[p]={Size=r.Size,Transparency=r.Transparency,Color=r.Color}end
    if S.Hitbox then r.Size=Vector3.new(S.HitboxSize,S.HitboxSize,S.HitboxSize);r.Transparency=.55;r.Color=S.HitboxColor
    else local o=Old[p];r.Size=o.Size;r.Transparency=o.Transparency;r.Color=o.Color end
   end
  end
 end
end
toggle("Custom Hitbox",function(v)S.Hitbox=v;hitboxes()end)
slider("Hitbox Size",2,20,S.HitboxSize,function(v)S.HitboxSize=v;if S.Hitbox then hitboxes()end end)

local ch=Instance.new("TextButton",Sc);ch.Size=UDim2.new(1,-5,0,46);ch.Text="Hitbox Color";ch.TextColor3=Color3.new(1,1,1)
ch.Font=Enum.Font.GothamMedium;ch.TextSize=13;ch.BackgroundColor3=Color3.fromRGB(30,31,39);ch.BorderSizePixel=0
Instance.new("UICorner",ch).CornerRadius=UDim.new(0,12)
local colors={
 Color3.fromRGB(255,70,70),Color3.fromRGB(255,150,50),Color3.fromRGB(255,220,60),
 Color3.fromRGB(80,220,100),Color3.fromRGB(60,200,255),Color3.fromRGB(80,120,255),
 Color3.fromRGB(170,80,255),Color3.fromRGB(255,80,190),Color3.fromRGB(255,255,255)
}
local cp=Instance.new("Frame",G);cp.Visible=false;cp.AnchorPoint=Vector2.new(1,0);cp.Position=UDim2.new(.97,0,.5,0)
cp.Size=UDim2.fromOffset(160,120);cp.BackgroundColor3=Color3.fromRGB(24,25,31);cp.BorderSizePixel=0
Instance.new("UICorner",cp).CornerRadius=UDim.new(0,12)
local grid=Instance.new("UIGridLayout",cp);grid.CellSize=UDim2.fromOffset(28,28);grid.CellPadding=UDim2.fromOffset(7,7);grid.HorizontalAlignment=Enum.HorizontalAlignment.Center;grid.VerticalAlignment=Enum.VerticalAlignment.Center
for _,c in ipairs(colors)do local b=Instance.new("TextButton",cp);b.Text="";b.BackgroundColor3=c;b.BorderSizePixel=0;Instance.new("UICorner",b).CornerRadius=UDim.new(0,7);b.Activated:Connect(function()S.HitboxColor=c;cp.Visible=false;if S.Hitbox then hitboxes()end end)end
ch.Activated:Connect(function()cp.Visible=not cp.Visible end)

section("AIM")
slider("Aimbot FOV",30,400,S.AimFOV,function(v)S.AimFOV=v end)
toggle("Target Assist",function(v)S.Aim=v;if not v then Target=nil end end)

local function valid(p)
 if not p or p==LP or not p.Character then return false end
 local h=p.Character:FindFirstChildOfClass("Humanoid");local r=p.Character:FindFirstChild("HumanoidRootPart")
 return h and h.Health>0 and r~=nil
end
local function nearest()
 local cam=workspace.CurrentCamera;if not cam then return end
 local c=cam.ViewportSize/2;local best,bd=nil,S.AimFOV
 for _,p in ipairs(Players:GetPlayers())do
  if valid(p)then local r=p.Character.HumanoidRootPart;local s,vis=cam:WorldToViewportPoint(r.Position)
   if vis and s.Z>0 then local d=(Vector2.new(s.X,s.Y)-c).Magnitude;if d<=bd then bd=d;best=p end end
  end
 end
 return best
end

RunService.RenderStepped:Connect(function()
 if Hum then Hum.WalkSpeed=S.Speed;Hum.JumpPower=S.Jump end
 if S.Noclip and Char then for _,x in ipairs(Char:GetDescendants())do if x:IsA("BasePart")then x.CanCollide=false end end end
 if S.ESP then refreshESP()end
 if S.Hitbox then hitboxes()end
 if S.Aim then if not valid(Target)then Target=nearest()end else Target=nil end
 -- Không sửa Camera.CFrame: camera luôn tự do.
end)

Players.PlayerAdded:Connect(function(p)p.CharacterAdded:Connect(function()task.wait(.5);if S.ESP then esp(p)end end)end)
Players.PlayerRemoving:Connect(function(p)rem(p);Old[p]=nil;if Target==p then Target=nil end end)

local Open=Instance.new("TextButton",G);Open.AnchorPoint=Vector2.new(0,1);Open.Position=UDim2.fromScale(.03,.96);Open.Size=UDim2.fromOffset(105,42)
Open.Text="OPEN HUB";Open.TextColor3=Color3.new(1,1,1);Open.TextSize=12;Open.Font=Enum.Font.GothamBold;Open.BackgroundColor3=Color3.fromRGB(25,26,32)
Open.BorderSizePixel=0;Open.Visible=false;Instance.new("UICorner",Open).CornerRadius=UDim.new(0,11)
Close.Activated:Connect(function()Main.Visible=false;cp.Visible=false;Open.Visible=true end)
Open.Activated:Connect(function()Main.Visible=true;Open.Visible=false end)

-- Kéo menu bằng thanh tiêu đề
local dragging,startPos,startInput=false,nil,nil
Title.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;startInput=i.Position;startPos=Main.Position end end)
UIS.InputChanged:Connect(function(i)if dragging and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local d=i.Position-startInput;Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)end end)
UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
