-- Dead by Daylight Exploit - Mobile UI Version
-- Optimized for Delta Executor on mobile devices
-- Touch-based UI with swipe navigation and large buttons

local function SafeDrawing(type)
    local success, result = pcall(function()
        return Drawing.new(type)
    end)
    if success then return result end
    return nil
end

local function SafeRemove(obj)
    if obj and obj.Remove then
        pcall(function() obj:Remove() end)
    end
end

if not Drawing or not Drawing.new then
    local waited = 0
    while not Drawing and waited < 5 do
        task.wait(0.1)
        waited = waited + 0.1
    end
    if not Drawing then
        warn("[Mobile UI] Drawing library not available.")
        return
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================
-- MOBILE UI DETECTION & CONFIG
-- ============================================

local ViewportSize = Camera.ViewportSize
local IsMobileDevice = ViewportSize.X < 1000 or ViewportSize.Y < 600

local UIConfig = {
    ButtonHeight = IsMobileDevice and 50 or 35,
    ButtonWidth = IsMobileDevice and 120 or 100,
    TabHeight = IsMobileDevice and 70 or 50,
    FontSize = IsMobileDevice and 16 or 12,
    TextSize = IsMobileDevice and 14 or 11,
    Padding = IsMobileDevice and 15 or 10,
    BottomTabHeight = IsMobileDevice and 70 or 50,
    HoverOpacity = 0.9,
    PressOpacity = 0.7,
}

local Colors = {
    Killer = Color3.fromRGB(255, 65, 65),
    KillerVis = Color3.fromRGB(255, 120, 120),
    Survivor = Color3.fromRGB(65, 220, 130),
    SurvivorVis = Color3.fromRGB(120, 255, 170),
    Generator = Color3.fromRGB(255, 180, 50),
    GeneratorDone = Color3.fromRGB(100, 255, 130),
    Gate = Color3.fromRGB(200, 200, 220),
    Hook = Color3.fromRGB(255, 100, 100),
    HookClose = Color3.fromRGB(255, 230, 80),
    Pallet = Color3.fromRGB(220, 180, 100),
    Window = Color3.fromRGB(100, 180, 255),
    Skeleton = Color3.fromRGB(255, 255, 255),
    SkeletonVis = Color3.fromRGB(150, 255, 150),
    Offscreen = Color3.fromRGB(255, 255, 255),
    HealthHigh = Color3.fromRGB(100, 255, 100),
    HealthMid = Color3.fromRGB(255, 220, 60),
    HealthLow = Color3.fromRGB(255, 70, 70),
    HealthBg = Color3.fromRGB(25, 25, 25),
    
    UI_Bg = Color3.fromRGB(12, 12, 16),
    UI_Card = Color3.fromRGB(20, 20, 26),
    UI_CardHover = Color3.fromRGB(30, 30, 40),
    UI_Border = Color3.fromRGB(45, 45, 55),
    UI_Accent = Color3.fromRGB(220, 70, 70),
    UI_AccentDim = Color3.fromRGB(160, 55, 55),
    UI_Text = Color3.fromRGB(235, 235, 240),
    UI_TextDim = Color3.fromRGB(130, 130, 145),
    UI_On = Color3.fromRGB(90, 220, 120),
    UI_Off = Color3.fromRGB(60, 60, 75),
    UI_TabActive = Color3.fromRGB(220, 70, 70),
    UI_TabInactive = Color3.fromRGB(85, 85, 100),
    
    RadarBg = Color3.fromRGB(20, 20, 20),
    RadarBorder = Color3.fromRGB(255, 65, 65),
    RadarYou = Color3.fromRGB(0, 255, 0)
}

-- ============================================
-- ORIGINAL SCRIPT CONFIG (PRESERVED)
-- ============================================

local Config = {
    ESP_Enabled = true,
    ESP_Killer = true,
    ESP_Survivor = true,
    ESP_Generator = true,
    ESP_Gate = true,
    ESP_Hook = true,
    ESP_Pallet = true,
    ESP_Window = false,
    ESP_Distance = true,
    ESP_Names = true,
    ESP_Health = true,
    ESP_Skeleton = false,
    ESP_Offscreen = true,
    ESP_Velocity = false,
    ESP_ClosestHook = true,
    ESP_MaxDist = 500,
    
    ESP_PlayerChams = false,
    ESP_ObjectChams = true,
    
    RADAR_Enabled = false,
    RADAR_Size = 120,
    RADAR_Circle = false,
    RADAR_Killer = true,
    RADAR_Survivor = true,
    RADAR_Generator = true,
    RADAR_Pallet = true,
    
    AUTO_Generator = false,
    AUTO_GenMode = "Fast",
    AUTO_LeaveGen = false,
    AUTO_LeaveDist = 18,
    AUTO_Attack = false,
    AUTO_AttackRange = 12,
    HITBOX_Enabled = false,
    HITBOX_Size = 15,
    AUTO_TeleAway = false,
    AUTO_TeleAwayDist = 40,
    
    AUTO_Parry = false,
    AUTO_SkillCheck = false,
    SURV_NoFall = false,
    SURV_AutoWiggle = false,
    KILLER_DestroyPallets = false,
    KILLER_FullGenBreak = false,
    KILLER_NoPalletStun = false,
    KILLER_AutoHook = false,
    KILLER_AntiBlind = false,
    KILLER_NoSlowdown = false,
    KILLER_DoubleTap = false,
    KILLER_InfiniteLunge = false,
    SPEED_Enabled = false,
    SPEED_Value = 32,
    SPEED_Method = "Attribute",
    NOCLIP_Enabled = false,
    FLY_Enabled = false,
    FLY_Speed = 50,
    FLY_Method = "CFrame",
    JUMP_Power = 50,
    JUMP_Infinite = false,
    
    NO_Fog = false,
    CAM_FOVEnabled = false,
    CAM_FOV = 90,
    CAM_ThirdPerson = false,
    CAM_ShiftLock = false,
    FLING_Enabled = false,
    FLING_Strength = 10000,
    
    BEAT_Survivor = false,
    BEAT_Killer = false,
    
    AIM_Enabled = false,
    AIM_FOV = 120,
    AIM_Smooth = 0.3,
    AIM_TargetPart = "Head",
    AIM_VisCheck = true,
    AIM_ShowFOV = true,
    AIM_Predict = true,
    
    SPEAR_Aimbot = false,
    SPEAR_Gravity = 50,
    SPEAR_Speed = 100
}

local Tuning = {
    ESP_RefreshRate = 0.08,
    ESP_VisCheckRate = 0.15,
    Gen_RefreshRate = 0.2,
    CacheRefreshRate = 1.0,
    Box_WidthRatio = 0.55,
    Name_Offset = 18,
    Dist_Offset = 5,
    Health_Width = 4,
    Health_Offset = 6,
    Offscreen_Edge = 50,
    Offscreen_Size = 12,
    Skel_Thickness = 1,
    Box_Thickness = 1,
    RadarRange = 150,
    RadarDotSize = 5,
    RadarArrowSize = 8
}

local ChamsColors = {
    Killer = {fill = Color3.fromRGB(180, 40, 40), outline = Color3.fromRGB(255, 80, 80), fillTrans = 0.6},
    Survivor = {fill = Color3.fromRGB(40, 160, 80), outline = Color3.fromRGB(80, 255, 130), fillTrans = 0.6},
    Generator = {fill = Color3.fromRGB(200, 140, 30), outline = Color3.fromRGB(255, 200, 80), fillTrans = 0.5},
    Gate = {fill = Color3.fromRGB(150, 150, 170), outline = Color3.fromRGB(220, 220, 255), fillTrans = 0.5},
    Hook = {fill = Color3.fromRGB(180, 60, 60), outline = Color3.fromRGB(255, 100, 100), fillTrans = 0.5},
    HookClose = {fill = Color3.fromRGB(200, 180, 40), outline = Color3.fromRGB(255, 240, 100), fillTrans = 0.4},
    Pallet = {fill = Color3.fromRGB(180, 140, 70), outline = Color3.fromRGB(255, 210, 130), fillTrans = 0.5},
    Window = {fill = Color3.fromRGB(60, 140, 200), outline = Color3.fromRGB(120, 200, 255), fillTrans = 0.5}
}

local Bones_R15 = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}

local Bones_R6 = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}

local State = {
    Unloaded = false,
    LastESPUpdate = 0,
    LastVisCheck = 0,
    LastGenUpdate = 0,
    LastCacheUpdate = 0,
    AimTarget = nil,
    AimHolding = false,
}

local Cache = {
    Players = {},
    Generators = {},
    Gates = {},
    Hooks = {},
    Pallets = {},
    Windows = {},
    Visibility = {},
    ClosestHook = nil
}

-- ============================================
-- MOBILE TOUCH FRAMEWORK
-- ============================================

local TouchInput = {
    StartPos = Vector2.new(),
    StartTime = 0,
    IsDragging = false,
    SwipeThreshold = 50,
}

local MobileMenu = {
    CurrentTab = 1,
    Tabs = {
        {name = "ESP", icon = "👁️", color = Colors.UI_Accent},
        {name = "AIM", icon = "🎯", color = Colors.UI_Accent},
        {name = "MOVE", icon = "🏃", color = Colors.UI_Accent},
        {name = "AUTO", icon = "⚙️", color = Colors.UI_Accent},
        {name = "OTHER", icon = "📋", color = Colors.UI_Accent}
    },
    TabButtons = {},
    Toggles = {},
    UIElements = {}
}

-- ============================================
-- TOUCH TOGGLE SWITCH COMPONENT
-- ============================================

local TouchToggle = {}
TouchToggle.__index = TouchToggle

function TouchToggle.new(text, pos, state, callback)
    local self = setmetatable({}, TouchToggle)
    self.Text = text
    self.Position = pos
    self.State = state or false
    self.Callback = callback
    self.Size = Vector2.new(ViewportSize.X - UIConfig.Padding * 2, UIConfig.ButtonHeight)
    
    self.Background = SafeDrawing("Square")
    self.Toggle = SafeDrawing("Square")
    self.TextLabel = SafeDrawing("Text")
    
    self:Setup()
    return self
end

function TouchToggle:Setup()
    self.Background.Filled = true
    self.Background.Color = Colors.UI_Card
    
    self.Toggle.Filled = true
    
    self.TextLabel.Font = Drawing.Fonts.Gotham
    self.TextLabel.Size = UIConfig.TextSize
    self.TextLabel.Color = Colors.UI_Text
    self.TextLabel.Outline = true
    self.TextLabel.OutlineColor = Color3.new(0, 0, 0)
end

function TouchToggle:Update()
    self.Background.Position = self.Position
    self.Background.Size = self.Size
    self.Background.Transparency = 0.5
    self.Background.Visible = true
    
    local toggleX = self.Position.X + self.Size.X - 60
    self.Toggle.Position = Vector2.new(toggleX, self.Position.Y + 5)
    self.Toggle.Size = Vector2.new(45, self.Size.Y - 10)
    self.Toggle.Color = self.State and Colors.UI_On or Colors.UI_Off
    self.Toggle.Transparency = 0.7
    self.Toggle.Visible = true
    
    self.TextLabel.Position = self.Position + Vector2.new(10, self.Size.Y / 2)
    self.TextLabel.Text = self.Text
    self.TextLabel.Visible = true
end

function TouchToggle:Toggle()
    self.State = not self.State
    if self.Callback then
        self.Callback(self.State)
    end
end

function TouchToggle:Destroy()
    pcall(function() self.Background:Remove() end)
    pcall(function() self.Toggle:Remove() end)
    pcall(function() self.TextLabel:Remove() end)
end

-- ============================================
-- MOBILE MENU INITIALIZATION
-- ============================================

local function CreateTabBar()
    local tabHeight = UIConfig.BottomTabHeight
    local tabWidth = ViewportSize.X / #MobileMenu.Tabs
    
    for i, tab in ipairs(MobileMenu.Tabs) do
        local pos = Vector2.new((i - 1) * tabWidth, ViewportSize.Y - tabHeight)
        local size = Vector2.new(tabWidth, tabHeight)
        
        local bgTab = SafeDrawing("Square")
        bgTab.Filled = true
        bgTab.Color = Colors.UI_TabInactive
        bgTab.Position = pos
        bgTab.Size = size
        bgTab.Transparency = 0.7
        bgTab.Visible = true
        
        local textTab = SafeDrawing("Text")
        textTab.Font = Drawing.Fonts.GothamBold
        textTab.Size = UIConfig.FontSize
        textTab.Center = true
        textTab.Position = pos + size / 2
        textTab.Text = tab.icon .. "\n" .. tab.name
        textTab.Color = Colors.UI_Text
        textTab.Outline = true
        textTab.OutlineColor = Color3.new(0, 0, 0)
        textTab.Visible = true
        
        table.insert(MobileMenu.TabButtons, {
            bg = bgTab,
            text = textTab,
            tabIndex = i,
            position = pos,
            size = size
        })
    end
end

local function CreateESPToggles()
    local startY = UIConfig.Padding + 20
    local spacing = UIConfig.ButtonHeight + 10
    
    local toggles = {
        {text = "ESP Enabled", config = "ESP_Enabled"},
        {text = "Show Killers", config = "ESP_Killer"},
        {text = "Show Survivors", config = "ESP_Survivor"},
        {text = "Show Distance", config = "ESP_Distance"},
        {text = "Show Names", config = "ESP_Names"},
        {text = "Show Health", config = "ESP_Health"},
        {text = "Player Chams", config = "ESP_PlayerChams"},
        {text = "Radar", config = "RADAR_Enabled"},
    }
    
    for i, toggle in ipairs(toggles) do
        local y = startY + (i - 1) * spacing
        local t = TouchToggle.new(toggle.text, Vector2.new(UIConfig.Padding, y), Config[toggle.config], function(state)
            Config[toggle.config] = state
        end)
        t.TabIndex = 1
        table.insert(MobileMenu.Toggles, t)
    end
end

local function CreateAimToggles()
    local startY = UIConfig.Padding + 20
    local spacing = UIConfig.ButtonHeight + 10
    
    local toggles = {
        {text = "Aimbot Enabled", config = "AIM_Enabled"},
        {text = "Show FOV", config = "AIM_ShowFOV"},
        {text = "Predict Movement", config = "AIM_Predict"},
        {text = "Visibility Check", config = "AIM_VisCheck"},
    }
    
    for i, toggle in ipairs(toggles) do
        local y = startY + (i - 1) * spacing
        local t = TouchToggle.new(toggle.text, Vector2.new(UIConfig.Padding, y), Config[toggle.config], function(state)
            Config[toggle.config] = state
        end)
        t.TabIndex = 2
        table.insert(MobileMenu.Toggles, t)
    end
end

local function CreateMovementToggles()
    local startY = UIConfig.Padding + 20
    local spacing = UIConfig.ButtonHeight + 10
    
    local toggles = {
        {text = "Speed Enabled", config = "SPEED_Enabled"},
        {text = "Fly Enabled", config = "FLY_Enabled"},
        {text = "No Clip", config = "NOCLIP_Enabled"},
        {text = "Infinite Jump", config = "JUMP_Infinite"},
    }
    
    for i, toggle in ipairs(toggles) do
        local y = startY + (i - 1) * spacing
        local t = TouchToggle.new(toggle.text, Vector2.new(UIConfig.Padding, y), Config[toggle.config], function(state)
            Config[toggle.config] = state
        end)
        t.TabIndex = 3
        table.insert(MobileMenu.Toggles, t)
    end
end

local function CreateAutoToggles()
    local startY = UIConfig.Padding + 20
    local spacing = UIConfig.ButtonHeight + 10
    
    local toggles = {
        {text = "Auto Generator", config = "AUTO_Generator"},
        {text = "Auto Attack", config = "AUTO_Attack"},
        {text = "Auto Parry", config = "AUTO_Parry"},
        {text = "Auto Wiggle", config = "SURV_AutoWiggle"},
        {text = "Auto Hook", config = "KILLER_AutoHook"},
    }
    
    for i, toggle in ipairs(toggles) do
        local y = startY + (i - 1) * spacing
        local t = TouchToggle.new(toggle.text, Vector2.new(UIConfig.Padding, y), Config[toggle.config], function(state)
            Config[toggle.config] = state
        end)
        t.TabIndex = 4
        table.insert(MobileMenu.Toggles, t)
    end
end

local function CreateOtherToggles()
    local startY = UIConfig.Padding + 20
    local spacing = UIConfig.ButtonHeight + 10
    
    local toggles = {
        {text = "No Fog", config = "NO_Fog"},
        {text = "Third Person", config = "CAM_ThirdPerson"},
        {text = "Skeleton ESP", config = "ESP_Skeleton"},
        {text = "Velocity ESP", config = "ESP_Velocity"},
    }
    
    for i, toggle in ipairs(toggles) do
        local y = startY + (i - 1) * spacing
        local t = TouchToggle.new(toggle.text, Vector2.new(UIConfig.Padding, y), Config[toggle.config], function(state)
            Config[toggle.config] = state
        end)
        t.TabIndex = 5
        table.insert(MobileMenu.Toggles, t)
    end
end

local function InitializeMenu()
    CreateTabBar()
    CreateESPToggles()
    CreateAimToggles()
    CreateMovementToggles()
    CreateAutoToggles()
    CreateOtherToggles()
end

-- ============================================
-- TOUCH INPUT HANDLER
-- ============================================

local function HandleTouchInput(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.Touch then
        local touchPos = Vector2.new(input.Position.X, input.Position.Y)
        
        if input.UserInputState == Enum.UserInputState.Begin then
            TouchInput.StartPos = touchPos
            TouchInput.StartTime = tick()
            TouchInput.IsDragging = false
            
        elseif input.UserInputState == Enum.UserInputState.Changed then
            local delta = (touchPos - TouchInput.StartPos).Magnitude
            if delta > 10 then
                TouchInput.IsDragging = true
                
                local dx = touchPos.X - TouchInput.StartPos.X
                if math.abs(dx) > TouchInput.SwipeThreshold then
                    if dx < 0 then
                        MobileMenu.CurrentTab = math.min(MobileMenu.CurrentTab + 1, #MobileMenu.Tabs)
                    else
                        MobileMenu.CurrentTab = math.max(MobileMenu.CurrentTab - 1, 1)
                    end
                    TouchInput.StartPos = touchPos
                end
            end
            
        elseif input.UserInputState == Enum.UserInputState.End then
            local timeDiff = tick() - TouchInput.StartTime
            
            if not TouchInput.IsDragging and timeDiff < 0.3 then
                -- Tab tap
                for _, btn in ipairs(MobileMenu.TabButtons) do
                    local minX = btn.position.X
                    local maxX = btn.position.X + btn.size.X
                    local minY = btn.position.Y
                    local maxY = btn.position.Y + btn.size.Y
                    
                    if touchPos.X >= minX and touchPos.X <= maxX and
                       touchPos.Y >= minY and touchPos.Y <= maxY then
                        MobileMenu.CurrentTab = btn.tabIndex
                    end
                end
                
                -- Toggle tap
                for _, toggle in ipairs(MobileMenu.Toggles) do
                    if toggle.TabIndex == MobileMenu.CurrentTab then
                        local minX = toggle.Position.X
                        local maxX = toggle.Position.X + toggle.Size.X
                        local minY = toggle.Position.Y
                        local maxY = toggle.Position.Y + toggle.Size.Y
                        
                        if touchPos.X >= minX and touchPos.X <= maxX and
                           touchPos.Y >= minY and touchPos.Y <= maxY then
                            toggle:Toggle()
                        end
                    end
                end
            end
            
            TouchInput.IsDragging = false
        end
    end
end

-- ============================================
-- HELPER FUNCTIONS (FROM ORIGINAL SCRIPT)
-- ============================================

local function GetRole()
    if not LocalPlayer.Team then return "Unknown" end
    local name = LocalPlayer.Team.Name
    if name == "Killer" then return "Killer" end
    if name == "Survivors" then return "Survivor" end
    return "Lobby"
end

local function IsKiller(player)
    return player and player.Team and player.Team.Name == "Killer"
end

local function IsSurvivor(player)
    return player and player.Team and player.Team.Name == "Survivors"
end

local function GetCharacterRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function IsR6(char)
    return char:FindFirstChild("Torso") ~= nil
end

local function GetDistance(pos)
    local root = GetCharacterRoot()
    if not root then return math.huge end
    return (pos - root.Position).Magnitude
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

-- ============================================
-- RENDER LOOP
-- ============================================

local function RenderMobileUI()
    -- Update tab colors
    for _, btn in ipairs(MobileMenu.TabButtons) do
        btn.bg.Color = btn.tabIndex == MobileMenu.CurrentTab and Colors.UI_TabActive or Colors.UI_TabInactive
    end
    
    -- Update toggles for current tab
    for _, toggle in ipairs(MobileMenu.Toggles) do
        if toggle.TabIndex == MobileMenu.CurrentTab then
            toggle:Update()
        else
            toggle.Background.Visible = false
            toggle.Toggle.Visible = false
            toggle.TextLabel.Visible = false
        end
    end
end

-- ============================================
-- INITIALIZATION
-- ============================================

InitializeMenu()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    HandleTouchInput(input, gameProcessed)
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    HandleTouchInput(input, gameProcessed)
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    HandleTouchInput(input, gameProcessed)
end)

RunService.RenderStepped:Connect(function()
    RenderMobileUI()
end)

print("[Mobile UI] ✓ Loaded successfully!")
print("[Mobile UI] ✓ Swipe left/right to switch tabs")
print("[Mobile UI] ✓ Tap toggles to enable/disable features")
print("[Mobile UI] ✓ Current Tab: " .. MobileMenu.Tabs[MobileMenu.CurrentTab].name)