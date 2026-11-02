--// KAYA LOADER

if _G.KayaLoaderRunning then return end
_G.KayaLoaderRunning = true

repeat task.wait() until game:IsLoaded()

-- Floating 🥬 button to hide/show UI panels
do
    local player = game:GetService("Players").LocalPlayer
    local toggleGui = Instance.new("ScreenGui")
    toggleGui.Name = "treehub"
    toggleGui.ResetOnSpawn = false
    toggleGui.IgnoreGuiInset = true
    toggleGui.DisplayOrder = 1000000
    local host = (gethui and gethui()) or game:GetService("CoreGui")
    pcall(function() toggleGui.Parent = host end)
    if not toggleGui.Parent then toggleGui.Parent = player:WaitForChild("PlayerGui") end

    local button = Instance.new("TextButton")
    button.Name = "MoneyToggle"
    button.Size = UDim2.fromOffset(34, 34)
    button.Position = UDim2.new(0, 14, 0.5, -17)
    button.BackgroundColor3 = Color3.fromRGB(80, 141, 255)
    button.Text = ""
    button.TextSize = 18
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = Color3.new(1, 1, 1)
    button.ZIndex = 10
    button.Parent = toggleGui

    local gear = Instance.new("TextButton")
    gear.Name = "SettingsToggle"
    gear.Size = UDim2.fromOffset(30, 30)
    gear.Position = UDim2.new(0, 54, 0.5, -15)
    gear.BackgroundColor3 = Color3.fromRGB(30, 78, 190)
    gear.Text = "⚙️"
    gear.TextSize = 16
    gear.Font = Enum.Font.GothamBold
    gear.TextColor3 = Color3.new(1, 1, 1)
    gear.Parent = toggleGui
    Instance.new("UICorner", gear).CornerRadius = UDim.new(1, 0)

    local settings = Instance.new("Frame")
    settings.Name = "SettingsPanel"
    settings.Size = UDim2.fromOffset(210, 112)
    settings.Position = UDim2.new(0, 54, 0.5, 22)
    settings.BackgroundColor3 = Color3.fromRGB(10, 18, 35)
    settings.BackgroundTransparency = 0.18
    settings.Visible = false
    settings.Parent = toggleGui
    Instance.new("UICorner", settings).CornerRadius = UDim.new(0, 10)
    local outline = Instance.new("UIStroke", settings)
    outline.Color = Color3.fromRGB(20, 52, 102)
    outline.Thickness = 1.5

    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Size = UDim2.new(1, -12, 0, 30)
    settingsTitle.Position = UDim2.fromOffset(6, 4)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Text = "SETTINGS"
    settingsTitle.Font = Enum.Font.GothamBold
    settingsTitle.TextSize = 13
    settingsTitle.TextColor3 = Color3.new(1, 1, 1)
    settingsTitle.Parent = settings

    local unload = Instance.new("TextButton")
    unload.Size = UDim2.new(1, -16, 0, 48)
    unload.Position = UDim2.fromOffset(8, 48)
    unload.BackgroundColor3 = Color3.fromRGB(80, 141, 255)
    unload.Text = "UNLOAD SCRIPT"
    unload.Font = Enum.Font.GothamBold
    unload.TextSize = 13
    unload.TextColor3 = Color3.new(1, 1, 1)
    unload.Parent = settings
    Instance.new("UICorner", unload).CornerRadius = UDim.new(0, 8)

    local confirm = Instance.new("Frame")
    confirm.Name = "UnloadConfirmation"
    confirm.Size = UDim2.fromOffset(250, 112)
    confirm.Position = UDim2.new(0.5, -125, 0.5, -56)
    confirm.BackgroundColor3 = Color3.fromRGB(8, 16, 30)
    confirm.BackgroundTransparency = 0.12
    confirm.Visible = false
    confirm.ZIndex = 20
    confirm.Parent = toggleGui
    Instance.new("UICorner", confirm).CornerRadius = UDim.new(0, 10)
    local confirmStroke = Instance.new("UIStroke", confirm)
    confirmStroke.Color = Color3.fromRGB(20, 52, 102)
    confirmStroke.Thickness = 1.5

    local question = Instance.new("TextLabel")
    question.Size = UDim2.new(1, -16, 0, 52)
    question.Position = UDim2.fromOffset(8, 5)
    question.BackgroundTransparency = 1
    question.Text = "Are you sure you want to unload this script?"
    question.TextWrapped = true
    question.Font = Enum.Font.GothamBold
    question.TextSize = 13
    question.TextColor3 = Color3.new(1, 1, 1)
    question.ZIndex = 21
    question.Parent = confirm

    local yes = Instance.new("TextButton")
    yes.Size = UDim2.new(0.5, -12, 0, 34)
    yes.Position = UDim2.new(0, 8, 1, -42)
    yes.BackgroundColor3 = Color3.fromRGB(80, 141, 255)
    yes.Text = "YES"
    yes.Font = Enum.Font.GothamBold
    yes.TextSize = 13
    yes.TextColor3 = Color3.new(1, 1, 1)
    yes.ZIndex = 21
    yes.Parent = confirm
    Instance.new("UICorner", yes).CornerRadius = UDim.new(0, 7)

    local no = Instance.new("TextButton")
    no.Size = UDim2.new(0.5, -12, 0, 34)
    no.Position = UDim2.new(0.5, 4, 1, -42)
    no.BackgroundColor3 = Color3.fromRGB(55, 75, 120)
    no.Text = "NO"
    no.Font = Enum.Font.GothamBold
    no.TextSize = 13
    no.TextColor3 = Color3.new(1, 1, 1)
    no.ZIndex = 21
    no.Parent = confirm
    Instance.new("UICorner", no).CornerRadius = UDim.new(0, 7)

    local gearDragging, gearInput, gearStart, gearStartPos, gearMoved = false, nil, nil, nil, false
    gear.Activated:Connect(function()
        if gearMoved then gearMoved = false; return end
        settings.Visible = not settings.Visible
    end)
    unload.Activated:Connect(function()
        confirm.Visible = true
    end)
    no.Activated:Connect(function()
        confirm.Visible = false
        settings.Visible = false
        gear.Visible = false
    end)
    yes.Activated:Connect(function()
        _G.KayaLoaderRunning = false
        local roots = {game:GetService("CoreGui"), player:FindFirstChildOfClass("PlayerGui")}
        pcall(function() if gethui then roots[#roots + 1] = gethui() end end)
        for _, root in ipairs(roots) do
            if root then
                for _, item in ipairs(root:GetChildren()) do
                    if item:IsA("ScreenGui") then
                        local n = string.lower(item.Name)
                        local owned = item == toggleGui
                            or n == "kayaloaderui"
                            or n == "cxshoutmoneytoggle"
                            or string.find(n, "meerko", 1, true) == 1
                            or string.find(n, "cxshout", 1, true) ~= nil
                            or string.find(n, "kayaprivate", 1, true) ~= nil
                        if owned then pcall(function() item:Destroy() end) end
                    end
                end
            end
        end
    end)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(20, 52, 102)
    stroke.Thickness = 2
    stroke.Parent = button

    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragInput, dragStart, startPosition
    local moved = false

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPosition = button.Position
            dragInput = input
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then moved = true end
            button.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == dragStart or input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    gear.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            gearDragging = true
            gearMoved = false
            gearStart = input.Position
            gearStartPos = gear.Position
            gearInput = input
        end
    end)
    gear.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            gearInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if gearDragging and input == gearInput then
            local delta = input.Position - gearStart
            if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then gearMoved = true end
            gear.Position = UDim2.new(
                gearStartPos.X.Scale, gearStartPos.X.Offset + delta.X,
                gearStartPos.Y.Scale, gearStartPos.Y.Offset + delta.Y
            )
            settings.Position = UDim2.new(
                gear.Position.X.Scale, gear.Position.X.Offset,
                gear.Position.Y.Scale, gear.Position.Y.Offset + 52
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if gearDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            gearDragging = false
        end
    end)

    local shown = true
    button.Activated:Connect(function()
        if moved then moved = false; return end
        shown = not shown

        local roots = {game:GetService("CoreGui"), player:FindFirstChildOfClass("PlayerGui")}
        for _, root in ipairs(roots) do
            if root then
                for _, item in ipairs(root:GetDescendants()) do
                    if item:IsA("ScreenGui") and item ~= toggleGui then
                        local lowerName = string.lower(item.Name)
                        local isOurGui = string.find(lowerName, "meerko", 1, true) == 1
                            or string.find(lowerName, "cxshout", 1, true) ~= nil
                            or string.find(lowerName, "kayaprivate", 1, true) ~= nil
                        if isOurGui then pcall(function() item.Enabled = shown end) end
                    end
                end
            end
        end
    end)
end

-- ===================== TREEHUB SPLASH =====================
do
    local Players = game:GetService("Players")
    local LP2 = Players.LocalPlayer
    local TweenService2 = game:GetService("TweenService")
    local SoundService2 = game:GetService("SoundService")

    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "TREEHUBSplash"
    splashGui.ResetOnSpawn = false
    splashGui.DisplayOrder = 999
    splashGui.IgnoreGuiInset = true
    if not pcall(function() splashGui.Parent = game:GetService("CoreGui") end) then
        splashGui.Parent = LP2:WaitForChild("PlayerGui")
    end

    local overlay = Instance.new("Frame", splashGui)
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.fromRGB(5, 12, 26)
    overlay.BackgroundTransparency = 0.1
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1

    local tapHint = Instance.new("TextLabel", splashGui)
    tapHint.Size = UDim2.new(1, 0, 0, 20)
    tapHint.Position = UDim2.new(0, 0, 1, -36)
    tapHint.BackgroundTransparency = 1
    tapHint.Text = "tap anywhere to skip"
    tapHint.TextColor3 = Color3.fromRGB(150, 190, 255)
    tapHint.Font = Enum.Font.Gotham
    tapHint.TextSize = 11
    tapHint.ZIndex = 10
    tapHint.TextXAlignment = Enum.TextXAlignment.Center

    local skipZone = Instance.new("TextButton", splashGui)
    skipZone.Size = UDim2.new(1,0,1,0)
    skipZone.BackgroundTransparency = 1
    skipZone.Text = ""
    skipZone.ZIndex = 9

    local container = Instance.new("Frame", splashGui)
    container.Size = UDim2.new(0,320,0,120)
    container.Position = UDim2.new(0.5,-160,0,-140)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ZIndex = 2
    container.ClipsDescendants = false

    local titleSplash = Instance.new("TextLabel", container)
    titleSplash.Size = UDim2.new(1,0,0,70)
    titleSplash.Position = UDim2.new(0,0,0,0)
    titleSplash.BackgroundTransparency = 1
    titleSplash.Text = "TREEHUB"
    titleSplash.TextColor3 = Color3.fromRGB(255,255,255)
    titleSplash.Font = Enum.Font.GothamBlack
    titleSplash.TextSize = 48
    titleSplash.TextTransparency = 0
    titleSplash.ZIndex = 3
    do
        local g = Instance.new("UIGradient", titleSplash)
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 130, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 190, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 88, 180))
        })
    end

    local subSplash = Instance.new("TextLabel", container)
    subSplash.Size = UDim2.new(1,0,0,24)
    subSplash.Position = UDim2.new(0,0,0,72)
    subSplash.BackgroundTransparency = 1
    subSplash.Text = ""
    subSplash.TextColor3 = Color3.fromRGB(115, 170, 255)
    subSplash.Font = Enum.Font.Gotham
    subSplash.TextSize = 13
    subSplash.TextTransparency = 0
    subSplash.ZIndex = 3

    local fragments = {}
    local fragTexts = {"TREE","HUB"}
    local fragColors = {
        Color3.fromRGB(120, 175, 255),
        Color3.fromRGB(48, 92, 170),
    }
    for i, txt in ipairs(fragTexts) do
        local frag = Instance.new("TextLabel", splashGui)
        frag.Size = UDim2.new(0,90,0,60)
        frag.AnchorPoint = Vector2.new(0.5,0.5)
        frag.Position = UDim2.new(0.5, (i-2)*60, 0.5, -30)
        frag.BackgroundTransparency = 1
        frag.Text = txt
        frag.TextColor3 = fragColors[i]
        frag.Font = Enum.Font.GothamBlack
        frag.TextSize = 44
        frag.TextTransparency = 1
        frag.ZIndex = 5
        frag.Rotation = 0
        table.insert(fragments, frag)
    end

    local splashDone = false
    local function finishSplash()
        if splashDone then return end
        splashDone = true
        TweenService2:Create(subSplash, TweenInfo.new(0.3), {TextTransparency=1}):Play()
        TweenService2:Create(overlay, TweenInfo.new(0.4), {BackgroundTransparency=1}):Play()
        tapHint.Visible = false
    end

    skipZone.MouseButton1Click:Connect(function()
        titleSplash.TextTransparency = 1
        subSplash.TextTransparency = 1
        finishSplash()
    end)

    task.spawn(function()
        TweenService2:Create(overlay, TweenInfo.new(0.2), {BackgroundTransparency=0.1}):Play()
        task.wait(0.15)
        TweenService2:Create(container, TweenInfo.new(0.45, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
            {Position=UDim2.new(0.5,-160,0.5,-60)}):Play()
        task.wait(0.5)
        task.wait(0.85)
        finishSplash()
        task.wait(0.45)
        if splashGui and splashGui.Parent then splashGui:Destroy() end
    end)

    local _t0 = tick()
    while not splashDone and (tick() - _t0) < 3.0 do
        task.wait(0.05)
    end
end

-- BLUE TRANSPARENT THEME OVERRIDE
do
    local function recolorTreehub()
        local roots = {
            game:GetService("CoreGui"),
            game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"),
        }

        for _, root in ipairs(roots) do
            if root then
                for _, obj in ipairs(root:GetDescendants()) do
                    if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("TextLabel") then
                        local name = tostring(obj.Name):lower()

                        if obj:IsA("TextLabel") then
                            if string.find(name, "cxshout", 1, true) ~= nil
                                or string.find(name, "treehub", 1, true) ~= nil
                                or obj.Text == "💸CXSHOUT💰HUB" then
                                obj.Text = "TREEHUB"
                            end

                            if obj.Text and string.find(obj.Text, "CXSHOUT", 1, true) then
                                obj.Text = string.gsub(obj.Text, "CXSHOUT", "TREEHUB")
                            end
                        end

                        if obj:IsA("Frame") or obj:IsA("TextButton") then
                            local color = obj.BackgroundColor3
                            if color ~= Color3.fromRGB(80, 141, 255) then
                                obj.BackgroundColor3 = Color3.fromRGB(80, 141, 255)
                            end
                        end

                        if obj:IsA("TextButton") then
                            obj.TextColor3 = Color3.new(1, 1, 1)
                        end

                        local stroke = obj:FindFirstChildOfType("UIStroke")
                        if stroke then
                            stroke.Color = Color3.fromRGB(20, 52, 102)
                            stroke.Thickness = 1.5
                        end
                    end
                end
            end
        end
    end

    task.spawn(function()
        while true do
            recolorTreehub()
            task.wait(1)
        end
    end)
end
