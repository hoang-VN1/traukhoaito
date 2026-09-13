-- ============================================================
-- MARU STYLE UI - TEST BUILD
-- Made by Binn | Dn Phuc text
-- Dán vào executor là chạy, không cần script chính
-- ============================================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer

local function GetParentGui()
    local ok, r = pcall(function()
        if gethui then return gethui() end
        return CoreGui
    end)
    if ok and r then return r end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local function SafeWriteFile(p, d) if writefile then pcall(writefile, p, d) end end
local function SafeReadFile(p)
    if readfile and isfile then
        local ok, d = pcall(function() if isfile(p) then return readfile(p) end end)
        if ok and d then return d end
    end
    return nil
end
local function SafeMakeFolder(p) if makefolder then pcall(makefolder, p) end end
local function SafeIsFile(p)
    if isfile then local ok, r = pcall(isfile, p); if ok then return r end end
    return false
end

local PARENT_GUI = GetParentGui()
local CONFIG_FOLDER = "MaruUI_Configs"
SafeMakeFolder(CONFIG_FOLDER)

-- ===== THEME =====
local Theme = {
    Background       = Color3.fromRGB(18, 18, 22),
    BackgroundTrans  = 0.15,
    Background2      = Color3.fromRGB(24, 24, 30),
    Background2Trans = 0.20,
    Background3      = Color3.fromRGB(30, 30, 38),
    Background3Trans = 0.25,
    Card             = Color3.fromRGB(35, 35, 44),
    CardTrans        = 0.20,
    CardHover        = Color3.fromRGB(48, 48, 58),
    CardHoverTrans   = 0.15,
    Text             = Color3.fromRGB(240, 240, 245),
    TextDim          = Color3.fromRGB(180, 180, 195),
    SubText          = Color3.fromRGB(150, 150, 165),
    Placeholder      = Color3.fromRGB(120, 120, 135),
    Accent           = Color3.fromRGB(80, 140, 255),
    AccentHover      = Color3.fromRGB(110, 165, 255),
    AccentDark       = Color3.fromRGB(55, 100, 200),
    ToggleOff        = Color3.fromRGB(60, 60, 72),
    ToggleOn         = Color3.fromRGB(80, 140, 255),
    Success          = Color3.fromRGB(80, 200, 120),
    Warning          = Color3.fromRGB(240, 180, 60),
    Error            = Color3.fromRGB(240, 80, 80),
    Info             = Color3.fromRGB(80, 140, 255),
    Stroke           = Color3.fromRGB(60, 60, 75),
    AnimFast         = 0.12,
    AnimNormal       = 0.2,
    AnimSlow         = 0.35,
}

-- ===== LOGO =====
local function CreateMaruLogo(size)
    size = size or UDim2.new(0, 80, 0, 80)
    local w, h = size.X.Offset, size.Y.Offset
    local container = Instance.new("Frame")
    container.Size = size
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false

    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, w * 0.4, 1, h * 0.4)
    glow.Position = UDim2.new(0.5, -w * 0.7, 0.5, -h * 0.7)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = Color3.fromRGB(60, 140, 255)
    glow.ImageTransparency = 0.4
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 276, 276)
    glow.ZIndex = 0; glow.Parent = container

    local dOuter = Instance.new("Frame")
    dOuter.Size = UDim2.new(0, w * 0.70, 0, h * 0.70)
    dOuter.Position = UDim2.new(0.5, -w * 0.35, 0.5, -h * 0.35)
    dOuter.BackgroundTransparency = 1
    dOuter.Rotation = 45
    dOuter.ZIndex = 1; dOuter.Parent = container
    local dOC = Instance.new("UICorner"); dOC.CornerRadius = UDim.new(0, math.max(2, w * 0.03)); dOC.Parent = dOuter
    local dOS = Instance.new("UIStroke")
    dOS.Color = Color3.fromRGB(255, 255, 255)
    dOS.Thickness = math.max(2, w * 0.025)
    dOS.Transparency = 0.05; dOS.Parent = dOuter

    local dInner = Instance.new("Frame")
    dInner.Size = UDim2.new(0, w * 0.55, 0, h * 0.55)
    dInner.Position = UDim2.new(0.5, -w * 0.275, 0.5, -h * 0.275)
    dInner.BackgroundTransparency = 1
    dInner.Rotation = 45
    dInner.ZIndex = 2; dInner.Parent = container
    local dIC = Instance.new("UICorner"); dIC.CornerRadius = UDim.new(0, math.max(2, w * 0.02)); dIC.Parent = dInner
    local dIS = Instance.new("UIStroke")
    dIS.Color = Color3.fromRGB(80, 140, 255)
    dIS.Thickness = math.max(1, w * 0.015)
    dIS.Transparency = 0.2; dIS.Parent = dInner

    local grad = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 220, 255)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(60, 160, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 60, 180)),
    }
    local function Bar(px, py, bw, bh, rot)
        local b = Instance.new("Frame")
        b.Size = UDim2.new(0, bw, 0, bh)
        b.Position = UDim2.new(0, px, 0, py)
        b.AnchorPoint = Vector2.new(0.5, 0.5)
        b.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
        b.BorderSizePixel = 0
        b.Rotation = rot
        b.ZIndex = 3; b.Parent = container
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, math.max(3, bw * 0.2)); c.Parent = b
        local g = Instance.new("UIGradient"); g.Color = grad; g.Rotation = 45; g.Parent = b
        local s = Instance.new("UIStroke")
        s.Color = Color3.fromRGB(200, 235, 255)
        s.Thickness = math.max(1, w * 0.012)
        s.Transparency = 0.1; s.Parent = b
    end
    local barW = w * 0.15
    local barH = h * 0.55
    Bar(w * 0.32, h * 0.52, barW, barH, 0)
    Bar(w * 0.46, h * 0.45, barW * 0.9, barH * 0.75, 32)
    Bar(w * 0.60, h * 0.45, barW * 0.9, barH * 0.75, -32)
    Bar(w * 0.72, h * 0.55, barW, barH * 1.05, 0)

    local function Arrow(px, dir)
        local g = Instance.new("Frame")
        g.Size = UDim2.new(0, w * 0.14, 0, h * 0.14)
        g.Position = UDim2.new(0, px, 0.5, -h * 0.07)
        g.BackgroundTransparency = 1; g.ZIndex = 4; g.Parent = container
        local top = Instance.new("Frame")
        top.Size = UDim2.new(0, w * 0.10, 0, h * 0.02)
        top.Position = UDim2.new(0.5, 0, 0.5, -h * 0.025)
        top.AnchorPoint = Vector2.new(0.5, 0.5)
        top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        top.BorderSizePixel = 0
        top.Rotation = dir * 45
        top.ZIndex = 4; top.Parent = g
        local bot = top:Clone()
        bot.Position = UDim2.new(0.5, 0, 0.5, h * 0.025)
        bot.Rotation = dir * -45
        bot.Parent = g
    end
    Arrow(w * 0.06, -1)
    Arrow(w * 0.80, 1)

    return container
end

-- ===== KÉO THẢ =====
local function makeDraggable(frame, dragArea)
    local dragging, dragInput, dragStart, startPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ===== GUI =====
if getgenv().MaruUI then pcall(function() getgenv().MaruUI:Destroy() end) end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MaruHubUI_" .. tostring(math.random(1, 999999))
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PARENT_GUI
getgenv().MaruUI = ScreenGui

local NotiGui = Instance.new("ScreenGui")
NotiGui.Name = "MaruNoti_" .. tostring(math.random(1, 999999))
NotiGui.ResetOnSpawn = false
NotiGui.Parent = PARENT_GUI
local NotiList = Instance.new("UIListLayout")
NotiList.Padding = UDim.new(0, 8)
NotiList.SortOrder = Enum.SortOrder.LayoutOrder
NotiList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotiList.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotiList.Parent = NotiGui

-- ===== NÚT TOGGLE =====
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 54, 0, 54)
ToggleBtn.Position = UDim2.new(0, 15, 0, 110)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Text = ""
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui
local TCorner = Instance.new("UICorner"); TCorner.CornerRadius = UDim.new(0, 10); TCorner.Parent = ToggleBtn
local TStroke = Instance.new("UIStroke"); TStroke.Color = Color3.fromRGB(70, 70, 90); TStroke.Thickness = 1.2; TStroke.Parent = ToggleBtn

local ToggleLogo = CreateMaruLogo(UDim2.new(0, 36, 0, 36))
ToggleLogo.Position = UDim2.new(0.5, -18, 0.5, -18)
ToggleLogo.Parent = ToggleBtn

ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(Theme.AnimFast), { BackgroundTransparency = 0 }):Play()
    TweenService:Create(TStroke, TweenInfo.new(Theme.AnimFast), { Color = Theme.Accent }):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(Theme.AnimFast), { BackgroundTransparency = 0.15 }):Play()
    TweenService:Create(TStroke, TweenInfo.new(Theme.AnimFast), { Color = Color3.fromRGB(70, 70, 90) }):Play()
end)
makeDraggable(ToggleBtn, ToggleBtn)

-- ===== LIBRARY =====
local Library = {}
getgenv().MaruLibrary = Library

local NotifyColors = { Info = Theme.Info, Success = Theme.Success, Warning = Theme.Warning, Error = Theme.Error }
function Library:Notify(opts)
    opts = opts or {}
    local ntype = opts.Type or "Info"
    local color = NotifyColors[ntype] or Theme.Accent

    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 280, 0, 60)
    n.BackgroundColor3 = Theme.Background2
    n.BackgroundTransparency = Theme.Background2Trans
    n.BorderSizePixel = 0
    n.Position = UDim2.new(1, 300, 1, -80)
    n.Parent = NotiGui
    local nc = Instance.new("UICorner"); nc.CornerRadius = UDim.new(0, 10); nc.Parent = n
    local ns = Instance.new("UIStroke"); ns.Color = color; ns.Thickness = 1.2; ns.Parent = n

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, -12); bar.Position = UDim2.new(0, 6, 0, 6)
    bar.BackgroundColor3 = color; bar.BorderSizePixel = 0; bar.Parent = n
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1, 0); bc.Parent = bar

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -30, 0, 20); t.Position = UDim2.new(0, 18, 0, 6)
    t.BackgroundTransparency = 1; t.Text = opts.Title or ntype
    t.TextColor3 = color; t.TextSize = 13; t.Font = Enum.Font.GothamBold
    t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = n

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -30, 1, -28); d.Position = UDim2.new(0, 18, 0, 26)
    d.BackgroundTransparency = 1; d.Text = opts.Description or opts.Desc or ""
    d.TextColor3 = Theme.TextDim; d.TextSize = 11; d.Font = Enum.Font.Gotham
    d.TextXAlignment = Enum.TextXAlignment.Left; d.TextWrapped = true; d.Parent = n

    local prog = Instance.new("Frame")
    prog.Size = UDim2.new(1, -12, 0, 3); prog.Position = UDim2.new(0, 6, 1, -5)
    prog.BackgroundColor3 = color; prog.BorderSizePixel = 0; prog.Parent = n
    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(1, 0); pc.Parent = prog

    local dur = opts.Duration or 4
    TweenService:Create(n, TweenInfo.new(Theme.AnimSlow, Enum.EasingStyle.Quad), { Position = UDim2.new(1, -300, 1, -80) }):Play()
    TweenService:Create(prog, TweenInfo.new(dur, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 0, 3) }):Play()
    task.delay(dur, function()
        TweenService:Create(n, TweenInfo.new(Theme.AnimSlow), { Position = UDim2.new(1, 300, 1, -80) }):Play()
        task.wait(0.4); n:Destroy()
    end)
end

-- ===== CREATE WINDOW =====
function Library:CreateWindow(opts)
    opts = opts or {}
    local titleText = opts.Title or "Maru Hub Premium"
    local subtitleText = opts.Subtitle or "[ Blox Fruits ]"

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 520, 0, 340)
    Main.Position = UDim2.new(0.5, -260, 0.5, -170)
    Main.BackgroundColor3 = Theme.Background
    Main.BackgroundTransparency = Theme.BackgroundTrans
    Main.BorderSizePixel = 0
    Main.Visible = false
    Main.Parent = ScreenGui
    local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(0, 12); MC.Parent = Main
    local MS = Instance.new("UIStroke"); MS.Color = Theme.Stroke; MS.Thickness = 1; MS.Parent = Main

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 34)
    TopBar.BackgroundColor3 = Theme.Background2
    TopBar.BackgroundTransparency = Theme.Background2Trans
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    local TBC = Instance.new("UICorner"); TBC.CornerRadius = UDim.new(0, 12); TBC.Parent = TopBar
    makeDraggable(Main, TopBar)

    local topLogo = CreateMaruLogo(UDim2.new(0, 22, 0, 22))
    topLogo.Position = UDim2.new(0, 8, 0.5, -11)
    topLogo.Parent = TopBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -150, 1, 0)
    title.Position = UDim2.new(0, 36, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText .. "   " .. subtitleText
    title.TextColor3 = Theme.TextDim; title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = TopBar

    local function MakeTitleBtn(text, posX, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 30, 1, 0)
        b.Position = UDim2.new(1, posX, 0, 0)
        b.BackgroundTransparency = 1
        b.Text = text; b.TextColor3 = Theme.TextDim; b.TextSize = 14
        b.Font = Enum.Font.GothamBold; b.AutoButtonColor = false
        b.Parent = TopBar
        b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(Theme.AnimFast), { TextColor3 = Theme.Accent }):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(Theme.AnimFast), { TextColor3 = Theme.TextDim }):Play() end)
        b.MouseButton1Click:Connect(cb)
    end
    MakeTitleBtn("—", -90, function() Main.Visible = false end)
    local isMax = false
    local nSize, nPos = Main.Size, Main.Position
    MakeTitleBtn("□", -60, function()
        isMax = not isMax
        if isMax then
            nSize, nPos = Main.Size, Main.Position
            TweenService:Create(Main, TweenInfo.new(Theme.AnimSlow), { Size = UDim2.new(1, -40, 1, -40), Position = UDim2.new(0, 20, 0, 20) }):Play()
        else
            TweenService:Create(Main, TweenInfo.new(Theme.AnimSlow), { Size = nSize, Position = nPos }):Play()
        end
    end)
    MakeTitleBtn("✕", -30, function() Main.Visible = false end)

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, -34)
    Sidebar.Position = UDim2.new(0, 0, 0, 34)
    Sidebar.BackgroundColor3 = Theme.Background2
    Sidebar.BackgroundTransparency = Theme.Background2Trans
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(0, 12); SC.Parent = Sidebar

    local BigLogo = CreateMaruLogo(UDim2.new(0, 80, 0, 80))
    BigLogo.Position = UDim2.new(0.5, -40, 0, 10)
    BigLogo.Parent = Sidebar

    local SearchFrame = Instance.new("Frame")
    SearchFrame.Size = UDim2.new(1, -20, 0, 28)
    SearchFrame.Position = UDim2.new(0, 10, 0, 100)
    SearchFrame.BackgroundColor3 = Theme.Card
    SearchFrame.BackgroundTransparency = Theme.CardTrans
    SearchFrame.BorderSizePixel = 0
    SearchFrame.Parent = Sidebar
    local SFC = Instance.new("UICorner"); SFC.CornerRadius = UDim.new(0, 8); SFC.Parent = SearchFrame
    local SFS = Instance.new("UIStroke"); SFS.Color = Theme.Stroke; SFS.Thickness = 1; SFS.Parent = SearchFrame

    local SearchIcon = Instance.new("TextLabel")
    SearchIcon.Size = UDim2.new(0, 22, 1, 0); SearchIcon.Position = UDim2.new(0, 6, 0, 0)
    SearchIcon.BackgroundTransparency = 1; SearchIcon.Text = "🔍"; SearchIcon.TextSize = 12
    SearchIcon.Parent = SearchFrame

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -32, 1, 0); SearchBox.Position = UDim2.new(0, 28, 0, 0)
    SearchBox.BackgroundTransparency = 1; SearchBox.Text = ""
    SearchBox.PlaceholderText = "Tìm kiếm..."
    SearchBox.PlaceholderColor3 = Theme.Placeholder
    SearchBox.TextColor3 = Theme.Text; SearchBox.TextSize = 11
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.ClearTextOnFocus = false
    SearchBox.Parent = SearchFrame

    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, -20, 1, -140)
    TabList.Position = UDim2.new(0, 10, 0, 136)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 3
    TabList.ScrollBarImageColor3 = Theme.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = Sidebar

    local TLL = Instance.new("UIListLayout")
    TLL.Padding = UDim.new(0, 4)
    TLL.SortOrder = Enum.SortOrder.LayoutOrder
    TLL.Parent = TabList
    TLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TLL.AbsoluteContentSize.Y + 4)
    end)

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -150, 1, -34)
    Content.Position = UDim2.new(0, 150, 0, 34)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, 0, 1, 0)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Content

    local Window = {}
    local Tabs = {}
    local AllElements = {}

    local function SwitchTab(t)
        for _, x in pairs(Tabs) do
            x.Page.Visible = false
            TweenService:Create(x.ButtonStroke, TweenInfo.new(Theme.AnimFast), { Color = Theme.Stroke }):Play()
            TweenService:Create(x.ButtonTitle, TweenInfo.new(Theme.AnimFast), { TextColor3 = Theme.TextDim }):Play()
        end
        t.Page.Visible = true
        TweenService:Create(t.ButtonStroke, TweenInfo.new(Theme.AnimFast), { Color = Theme.Accent }):Play()
        TweenService:Create(t.ButtonTitle, TweenInfo.new(Theme.AnimFast), { TextColor3 = Theme.Accent }):Play()
    end

    function Window:AddTab(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Theme.Card
        btn.BackgroundTransparency = Theme.CardTrans
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = TabList
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 8); bc.Parent = btn
        local bs = Instance.new("UIStroke"); bs.Color = Theme.Stroke; bs.Thickness = 1; bs.Parent = btn

        local bt = Instance.new("TextLabel")
        bt.Size = UDim2.new(1, -20, 1, 0); bt.Position = UDim2.new(0, 12, 0, 0)
        bt.BackgroundTransparency = 1; bt.Text = name
        bt.TextColor3 = Theme.TextDim; bt.TextSize = 12
        bt.Font = Enum.Font.GothamMedium
        bt.TextXAlignment = Enum.TextXAlignment.Left; bt.Parent = btn

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -16, 1, -16); page.Position = UDim2.new(0, 8, 0, 8)
        page.BackgroundTransparency = 1; page.BorderSizePixel = 0
        page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = Theme.Accent
        page.CanvasSize = UDim2.new(0, 0, 0, 0); page.Visible = false
        page.Parent = Pages

        local pl = Instance.new("UIListLayout")
        pl.Padding = UDim.new(0, 6)
        pl.SortOrder = Enum.SortOrder.LayoutOrder
        pl.Parent = page
        pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pl.AbsoluteContentSize.Y + 6)
        end)

        local td = { Button = btn, ButtonTitle = bt, ButtonStroke = bs, Page = page, Name = name }
        table.insert(Tabs, td)
        btn.MouseButton1Click:Connect(function() SwitchTab(td) end)
        if #Tabs == 1 then SwitchTab(td) end

        local Tab = {}
        function Tab:AddLeftGroupbox(n) return self:AddSection(n) end

        function Tab:AddSection(name)
            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(1, 0, 0, 26)
            sec.BackgroundTransparency = 1
            sec.Parent = page

            local st = Instance.new("TextLabel")
            st.Size = UDim2.new(1, 0, 0, 22); st.BackgroundTransparency = 1
            st.Text = name; st.TextColor3 = Theme.Text; st.TextSize = 14
            st.Font = Enum.Font.GothamBold
            st.TextXAlignment = Enum.TextXAlignment.Left
            st.Parent = sec

            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1); line.Position = UDim2.new(0, 0, 0, 22)
            line.BackgroundColor3 = Theme.Accent; line.BackgroundTransparency = 0.7
            line.BorderSizePixel = 0; line.Parent = sec

            local slist = Instance.new("Frame")
            slist.Size = UDim2.new(1, 0, 0, 0); slist.Position = UDim2.new(0, 0, 0, 26)
            slist.BackgroundTransparency = 1; slist.Parent = sec

            local sll = Instance.new("UIListLayout")
            sll.Padding = UDim.new(0, 5)
            sll.SortOrder = Enum.SortOrder.LayoutOrder
            sll.Parent = slist
            sll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                slist.Size = UDim2.new(1, 0, 0, sll.AbsoluteContentSize.Y)
                sec.Size = UDim2.new(1, 0, 0, 26 + sll.AbsoluteContentSize.Y + 8)
            end)

            local Group = {}

            function Group:AddToggle(flag, opts)
                opts = opts or {}
                local title = opts.Title or flag
                local desc = opts.Desc or opts.Description
                local state = opts.Default or false

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, desc and 48 or 38)
                card.BackgroundColor3 = Theme.Card
                card.BackgroundTransparency = Theme.CardTrans
                card.BorderSizePixel = 0
                card.Parent = slist
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(1, -70, 0, 18)
                tl.Position = UDim2.new(0, 14, 0, desc and 6 or 10)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 13
                tl.Font = Enum.Font.GothamMedium
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Parent = card

                if desc then
                    local dl = Instance.new("TextLabel")
                    dl.Size = UDim2.new(1, -70, 0, 14)
                    dl.Position = UDim2.new(0, 14, 0, 26)
                    dl.BackgroundTransparency = 1
                    dl.Text = desc; dl.TextColor3 = Theme.SubText; dl.TextSize = 10
                    dl.Font = Enum.Font.Gotham
                    dl.TextXAlignment = Enum.TextXAlignment.Left; dl.Parent = card
                end

                local bg = Instance.new("Frame")
                bg.Size = UDim2.new(0, 42, 0, 22)
                bg.Position = UDim2.new(1, -54, 0.5, -11)
                bg.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
                bg.BorderSizePixel = 0; bg.Parent = card
                local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1, 0); bc.Parent = bg

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 18, 0, 18)
                knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                knob.BackgroundColor3 = state and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(200, 200, 210)
                knob.BorderSizePixel = 0; knob.Parent = bg
                local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1, 0); kc.Parent = knob

                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1
                b.Text = ""; b.Parent = card

                b.MouseButton1Click:Connect(function()
                    state = not state
                    TweenService:Create(bg, TweenInfo.new(0.15), { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }):Play()
                    TweenService:Create(knob, TweenInfo.new(0.15), {
                        Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                        BackgroundColor3 = state and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(200, 200, 210)
                    }):Play()
                    if opts.Callback then pcall(opts.Callback, state) end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return { SetStage = function(_, v) state = v end }
            end

            function Group:AddButton(opts)
                opts = opts or {}
                local title = opts.Title or "Button"
                local desc = opts.Desc or opts.Description

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, desc and 44 or 36)
                card.BackgroundColor3 = Theme.Card
                card.BackgroundTransparency = Theme.CardTrans
                card.BorderSizePixel = 0; card.Parent = slist
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(1, -20, 0, 18)
                tl.Position = UDim2.new(0, 14, 0, desc and 6 or 9)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 13
                tl.Font = Enum.Font.GothamMedium
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Parent = card

                if desc then
                    local dl = Instance.new("TextLabel")
                    dl.Size = UDim2.new(1, -20, 0, 14)
                    dl.Position = UDim2.new(0, 14, 0, 26)
                    dl.BackgroundTransparency = 1
                    dl.Text = desc; dl.TextColor3 = Theme.SubText; dl.TextSize = 10
                    dl.Font = Enum.Font.Gotham
                    dl.TextXAlignment = Enum.TextXAlignment.Left; dl.Parent = card
                end

                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1
                b.Text = ""; b.Parent = card
                b.MouseEnter:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.15), { BackgroundTransparency = Theme.CardHoverTrans }):Play()
                end)
                b.MouseLeave:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.15), { BackgroundTransparency = Theme.CardTrans }):Play()
                end)
                b.MouseButton1Click:Connect(function()
                    if opts.Callback then pcall(opts.Callback) end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return { SetTitle = function(_, v) tl.Text = v end }
            end

            function Group:AddDropdown(flag, opts)
                opts = opts or {}
                local title = opts.Title or flag
                local values = opts.Values or {}
                local selected = opts.Default

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 40)
                card.BackgroundColor3 = Theme.Card
                card.BackgroundTransparency = Theme.CardTrans
                card.BorderSizePixel = 0; card.Parent = slist
                card.ClipsDescendants = false
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(0.5, 0, 0, 40)
                tl.Position = UDim2.new(0, 14, 0, 0)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 13
                tl.Font = Enum.Font.GothamMedium
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Parent = card

                local vb = Instance.new("Frame")
                vb.Size = UDim2.new(0.45, 0, 1, -12)
                vb.Position = UDim2.new(0.53, 0, 0, 6)
                vb.BackgroundColor3 = Theme.Background2
                vb.BackgroundTransparency = Theme.Background2Trans
                vb.BorderSizePixel = 0; vb.Parent = card
                local vbc = Instance.new("UICorner"); vbc.CornerRadius = UDim.new(0, 6); vbc.Parent = vb

                local vl = Instance.new("TextLabel")
                vl.Size = UDim2.new(1, -26, 1, 0)
                vl.Position = UDim2.new(0, 8, 0, 0)
                vl.BackgroundTransparency = 1
                vl.Text = selected and tostring(selected) or "Chọn..."
                vl.TextColor3 = Theme.Text; vl.TextSize = 12
                vl.Font = Enum.Font.Gotham
                vl.TextXAlignment = Enum.TextXAlignment.Left; vl.Parent = vb

                local arrow = Instance.new("TextLabel")
                arrow.Size = UDim2.new(0, 22, 1, 0)
                arrow.Position = UDim2.new(1, -22, 0, 0)
                arrow.BackgroundTransparency = 1
                arrow.Text = "‹"; arrow.TextColor3 = Theme.TextDim; arrow.TextSize = 16
                arrow.Parent = vb

                local menu = Instance.new("ScrollingFrame")
                menu.Size = UDim2.new(1, 0, 0, 0)
                menu.Position = UDim2.new(0, 0, 1, 4)
                menu.BackgroundColor3 = Theme.Background3
                menu.BackgroundTransparency = Theme.Background3Trans
                menu.BorderSizePixel = 0
                menu.Visible = false
                menu.ZIndex = 10
                menu.ScrollBarThickness = 3
                menu.ScrollBarImageColor3 = Theme.Accent
                menu.CanvasSize = UDim2.new(0, 0, 0, 0)
                menu.ClipsDescendants = true
                menu.Parent = card
                local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, 6); mc.Parent = menu
                local ms = Instance.new("UIStroke"); ms.Color = Theme.Accent; ms.Thickness = 1; ms.Parent = menu

                local ml = Instance.new("UIListLayout"); ml.Padding = UDim.new(0, 2); ml.Parent = menu
                ml:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    menu.CanvasSize = UDim2.new(0, 0, 0, ml.AbsoluteContentSize.Y + 4)
                end)

                local opened = false
                local maxHeight = math.min(#values * 26 + 6, 160)

                for _, val in ipairs(values) do
                    local ob = Instance.new("TextButton")
                    ob.Size = UDim2.new(1, -8, 0, 24)
                    ob.BackgroundColor3 = Theme.Card
                    ob.BackgroundTransparency = Theme.CardTrans
                    ob.BorderSizePixel = 0
                    ob.Text = tostring(val); ob.TextColor3 = Theme.Text; ob.TextSize = 11
                    ob.Font = Enum.Font.Gotham; ob.AutoButtonColor = false
                    ob.Parent = menu
                    local oc = Instance.new("UICorner"); oc.CornerRadius = UDim.new(0, 4); oc.Parent = ob
                    ob.MouseEnter:Connect(function() TweenService:Create(ob, TweenInfo.new(0.1), { BackgroundTransparency = Theme.CardHoverTrans }):Play() end)
                    ob.MouseLeave:Connect(function() TweenService:Create(ob, TweenInfo.new(0.1), { BackgroundTransparency = Theme.CardTrans }):Play() end)
                    ob.MouseButton1Click:Connect(function()
                        if opts.Multi then
                            if type(selected) ~= "table" then selected = {} end
                            local found = false
                            for i, v in ipairs(selected) do if v == val then table.remove(selected, i); found = true; break end end
                            if not found then table.insert(selected, val) end
                            vl.Text = #selected > 0 and table.concat(selected, ", ") or "Chọn..."
                            if opts.Callback then pcall(opts.Callback, selected) end
                        else
                            selected = val; vl.Text = tostring(val)
                            menu.Visible = false; opened = false
                            TweenService:Create(menu, TweenInfo.new(Theme.AnimNormal), { Size = UDim2.new(1, 0, 0, 0) }):Play()
                            if opts.Callback then pcall(opts.Callback, selected) end
                        end
                    end)
                end

                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1
                b.Text = ""; b.Parent = card
                b.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        menu.Visible = true
                        TweenService:Create(menu, TweenInfo.new(Theme.AnimNormal, Enum.EasingStyle.Quad), { Size = UDim2.new(1, 0, 0, maxHeight) }):Play()
                    else
                        TweenService:Create(menu, TweenInfo.new(Theme.AnimNormal, Enum.EasingStyle.Quad), { Size = UDim2.new(1, 0, 0, 0) }):Play()
                        task.delay(Theme.AnimNormal, function() if not opened then menu.Visible = false end end)
                    end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return { Set = function(_, v) selected = v; vl.Text = tostring(v) end }
            end

            function Group:AddSlider(opts)
                opts = opts or {}
                local title = opts.Title or "Slider"
                local min = opts.Min or 0
                local max = opts.Max or 100
                local default = opts.Default or min
                local rounding = opts.Rounding or 0

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 48)
                card.BackgroundColor3 = Theme.Card
                card.BackgroundTransparency = Theme.CardTrans
                card.BorderSizePixel = 0; card.Parent = slist
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(1, -60, 0, 18)
                tl.Position = UDim2.new(0, 14, 0, 6)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 13
                tl.Font = Enum.Font.GothamMedium
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Parent = card

                local vl = Instance.new("TextLabel")
                vl.Size = UDim2.new(0, 50, 0, 18)
                vl.Position = UDim2.new(1, -60, 0, 6)
                vl.BackgroundTransparency = 1
                vl.Text = tostring(default); vl.TextColor3 = Theme.Accent; vl.TextSize = 12
                vl.Font = Enum.Font.GothamBold; vl.Parent = card

                local barBg = Instance.new("Frame")
                barBg.Size = UDim2.new(1, -28, 0, 6)
                barBg.Position = UDim2.new(0, 14, 0, 34)
                barBg.BackgroundColor3 = Theme.ToggleOff
                barBg.BorderSizePixel = 0; barBg.Parent = card
                local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(1, 0); bbc.Parent = barBg

                local barFill = Instance.new("Frame")
                barFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                barFill.BackgroundColor3 = Theme.Accent
                barFill.BorderSizePixel = 0; barFill.Parent = barBg
                local bfc = Instance.new("UICorner"); bfc.CornerRadius = UDim.new(1, 0); bfc.Parent = barFill

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 14, 0, 14)
                knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, -7)
                knob.AnchorPoint = Vector2.new(0.5, 0.5)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 0; knob.ZIndex = 2; knob.Parent = barBg
                local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1, 0); kc.Parent = knob
                local ks = Instance.new("UIStroke"); ks.Color = Theme.Accent; ks.Thickness = 2; ks.Parent = knob

                local sb = Instance.new("TextButton")
                sb.Size = UDim2.new(1, 0, 1, 22)
                sb.Position = UDim2.new(0, 0, -0.5, -6)
                sb.BackgroundTransparency = 1; sb.Text = ""; sb.Parent = barBg

                local dragging = false
                local function updateVal(input)
                    local rx = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                    local v = min + (max - min) * rx
                    if rounding == 0 then v = math.floor(v) else v = math.floor(v * 10^rounding) / 10^rounding end
                    barFill.Size = UDim2.new(rx, 0, 1, 0)
                    knob.Position = UDim2.new(rx, 0, 0.5, -7)
                    vl.Text = tostring(v)
                    if opts.Callback then pcall(opts.Callback, v) end
                end
                sb.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true; updateVal(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateVal(input)
                    end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return {}
            end

            function Group:AddInput(flag, opts)
                opts = opts or {}
                local title = opts.Title or flag
                local ph = opts.Placeholder or "Nhập..."

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 38)
                card.BackgroundColor3 = Theme.Card
                card.BackgroundTransparency = Theme.CardTrans
                card.BorderSizePixel = 0; card.Parent = slist
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(0.5, 0, 1, 0)
                tl.Position = UDim2.new(0, 14, 0, 0)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 12
                tl.Font = Enum.Font.Gotham
                tl.TextXAlignment = Enum.TextXAlignment.Left; tl.Parent = card

                local box = Instance.new("TextBox")
                box.Size = UDim2.new(0.45, 0, 1, -12)
                box.Position = UDim2.new(0.53, 0, 0, 6)
                box.BackgroundColor3 = Theme.Background2
                box.BackgroundTransparency = Theme.Background2Trans
                box.BorderSizePixel = 0
                box.Text = ""
                box.PlaceholderText = ph
                box.PlaceholderColor3 = Theme.Placeholder
                box.TextColor3 = Theme.Text; box.TextSize = 11
                box.Font = Enum.Font.Gotham
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.ClearTextOnFocus = false
                box.Parent = card
                local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = box

                box.FocusLost:Connect(function()
                    if opts.Callback then pcall(opts.Callback, box.Text) end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return { Set = function(_, v) box.Text = v end }
            end

            function Group:AddLabel(text)
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 0, 22)
                lbl.BackgroundTransparency = 1
                lbl.Text = text; lbl.TextColor3 = Theme.SubText; lbl.TextSize = 11
                lbl.Font = Enum.Font.Gotham
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.TextWrapped = true; lbl.Parent = slist

                table.insert(AllElements, { Card = lbl, Name = text, Section = name })
                return { SetText = function(_, v) lbl.Text = v end }
            end

            return Group
        end

        return Tab
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(SearchBox.Text)
        for _, el in ipairs(AllElements) do
            if q == "" then
                el.Card.Visible = true
            else
                local m = string.find(string.lower(el.Name), q, 1, true) ~= nil
                    or string.find(string.lower(el.Section), q, 1, true) ~= nil
                el.Card.Visible = m
            end
        end
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    return Window
end

-- ============================================================
-- TẠO TAB TEST
-- ============================================================

local TestWindow = Library:CreateWindow({
    Title = "Maru Hub Premium",
    Subtitle = "[ Blox Fruits ]"
})

-- ===== TAB 1: STATUS =====
local StatusTab = TestWindow:AddTab("Status")
local StatusGroup = StatusTab:AddLeftGroupbox("Thông tin")

StatusGroup:AddLabel("Level: Đang tải...")
StatusGroup:AddLabel("Beli: Đang tải...")
StatusGroup:AddLabel("Fruit: Chưa có")
StatusGroup:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Description = "Tự động bật Buso + Ken",
    Default = false,
    Callback = function(v)
        Library:Notify({Title = "Auto Haki", Description = v and "Đã bật" or "Đã tắt", Type = v and "Success" or "Warning"})
    end
})

-- ===== TAB 2: FARM SETTINGS =====
local FarmTab = TestWindow:AddTab("Farm Settings")
local WeaponGroup = FarmTab:AddLeftGroupbox("Weapon Settings")

WeaponGroup:AddDropdown("SelectWeapon", {
    Title = "Select Weapon",
    Values = {"Melee", "Sword", "Blox Fruit", "Gun"},
    Default = "Melee",
    Callback = function(v)
        Library:Notify({Title = "Weapon", Description = "Đã chọn: " .. tostring(v), Type = "Info"})
    end
})

local CharGroup = FarmTab:AddLeftGroupbox("Character Settings")

CharGroup:AddToggle("AutoBuso", {
    Title = "Auto Use Buso",
    Default = true,
    Callback = function(v)
        Library:Notify({Title = "Buso", Description = v and "Bật" or "Tắt", Type = "Info"})
    end
})

CharGroup:AddToggle("AutoKen", {
    Title = "Auto Use Ken",
    Default = true,
    Callback = function(v)
        Library:Notify({Title = "Ken", Description = v and "Bật" or "Tắt", Type = "Info"})
    end
})

local RaceGroup = FarmTab:AddLeftGroupbox("Race Ability Settings")

RaceGroup:AddToggle("AutoV3", {
    Title = "Auto Turn On V3",
    Default = false,
    Callback = function(v) end
})

RaceGroup:AddToggle("AutoV4", {
    Title = "Auto Turn On V4",
    Default = false,
    Callback = function(v) end
})

-- ===== TAB 3: MAIN =====
local MainTab = TestWindow:AddTab("Main")
local MainGroup = MainTab:AddLeftGroupbox("Main Functions")

MainGroup:AddButton({
    Title = "Teleport Old World",
    Callback = function()
        Library:Notify({Title = "Teleport", Description = "Đang tới Old World...", Type = "Info"})
    end
})

MainGroup:AddButton({
    Title = "Teleport New World",
    Callback = function()
        Library:Notify({Title = "Teleport", Description = "Đang tới New World...", Type = "Info"})
    end
})

MainGroup:AddButton({
    Title = "Teleport Third Sea",
    Callback = function()
        Library:Notify({Title = "Teleport", Description = "Đang tới Third Sea...", Type = "Info"})
    end
})

MainGroup:AddSlider({
    Title = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Rounding = 0,
    Callback = function(v)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end
})

-- ===== TAB 4: MULTI FARM =====
local MultiTab = TestWindow:AddTab("Multi Farm")
local MultiGroup = MultiTab:AddLeftGroupbox("Multi Farm")

MultiGroup:AddToggle("MultiFarm", {
    Title = "Multi Farm",
    Description = "Farm nhiều chức năng cùng lúc",
    Default = false,
    Callback = function(v) end
})

MultiGroup:AddDropdown("MultiSelect", {
    Title = "Chọn chức năng",
    Values = {"Auto Chest", "Auto Berry", "Auto Elite", "Auto Sea Beast"},
    Default = nil,
    Multi = true,
    Callback = function(v) end
})

-- ===== TAB 5: QUESTS =====
local QuestTab = TestWindow:AddTab("Quests")
local QuestGroup = QuestTab:AddLeftGroupbox("Quests")

QuestGroup:AddButton({
    Title = "Auto Saber",
    Callback = function()
        Library:Notify({Title = "Quest", Description = "Bắt đầu Auto Saber...", Type = "Info"})
    end
})

QuestGroup:AddButton({
    Title = "Auto Yama",
    Callback = function()
        Library:Notify({Title = "Quest", Description = "Bắt đầu Auto Yama...", Type = "Info"})
    end
})

QuestGroup:AddButton({
    Title = "Auto Tushita",
    Callback = function()
        Library:Notify({Title = "Quest", Description = "Bắt đầu Auto Tushita...", Type = "Info"})
    end
})

QuestGroup:AddButton({
    Title = "Auto CDK",
    Callback = function()
        Library:Notify({Title = "Quest", Description = "Bắt đầu Auto CDK...", Type = "Info"})
    end
})

-- ===== TAB 6: SHOP =====
local ShopTab = TestWindow:AddTab("Shop")
local ShopGroup = ShopTab:AddLeftGroupbox("Misc Shop")

ShopGroup:AddButton({
    Title = "Redeem Code",
    Callback = function()
        Library:Notify({Title = "Shop", Description = "Đang redeem code...", Type = "Info"})
    end
})

ShopGroup:AddButton({
    Title = "Reset Stats",
    Callback = function()
        Library:Notify({Title = "Shop", Description = "Đã reset stats", Type = "Success"})
    end
})

ShopGroup:AddButton({
    Title = "Reroll Race",
    Callback = function()
        Library:Notify({Title = "Shop", Description = "Đã reroll race", Type = "Success"})
    end
})

-- ===== TAB 7: SETTINGS =====
local SettingTab = TestWindow:AddTab("Settings")
local SettingGroup = SettingTab:AddLeftGroupbox("Teleport Bypass")

SettingGroup:AddToggle("BypassTP", {
    Title = "Bypass Teleport",
    Description = "Không reset khi teleport xa",
    Default = false,
    Callback = function(v) end
})

SettingGroup:AddInput("JobID", {
    Title = "Job ID",
    Placeholder = "Nhập Job ID...",
    Callback = function(v)
        Library:Notify({Title = "Job ID", Description = "Đã lưu: " .. v, Type = "Info"})
    end
})

SettingGroup:AddButton({
    Title = "Copy Job ID",
    Callback = function()
        if setclipboard then
            setclipboard(game.JobId)
            Library:Notify({Title = "Clipboard", Description = "Đã copy Job ID", Type = "Success"})
        end
    end
})

SettingGroup:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

-- ===== THÔNG BÁO =====
Library:Notify({
    Title = "Maru Hub Premium",
    Description = "UI đã load thành công!",
    Type = "Success",
    Duration = 5
})