local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local lib = {}
local accentColor = Color3.fromRGB(130, 100, 255)
local backgroundColor = Color3.fromRGB(30, 30, 30)
local darkGray = Color3.fromRGB(40, 40, 40)
local lightGray = Color3.fromRGB(180, 180, 180)

local function create(class, props)
    local inst = Instance.new(class)
    for i,v in pairs(props) do
        inst[i] = v
    end
    return inst
end

local function tween(inst, props, time)
    TweenService:Create(inst, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local ScreenGui = create("ScreenGui", { Name = "CustomUILib", ResetOnSpawn = false, Parent = game.CoreGui })

-- Main window frame
local MainFrame = create("Frame", {
    Size = UDim2.new(0, 450, 0, 350),
    Position = UDim2.new(0.5, -225, 0.5, -175),
    BackgroundColor3 = backgroundColor,
    BorderSizePixel = 0,
    Parent = ScreenGui
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = MainFrame })

local TopBar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = darkGray,
    BorderSizePixel = 0,
    Parent = MainFrame
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TopBar })

local Title = create("TextLabel", {
    Size = UDim2.new(1, -40, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "Custom UI Lib",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255,255,255),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopBar
})

local CloseBtn = create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0, 2),
    BackgroundColor3 = darkGray,
    BorderSizePixel = 0,
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = lightGray,
    Parent = TopBar
})
create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })
CloseBtn.MouseEnter:Connect(function() tween(CloseBtn, {BackgroundColor3 = accentColor}, 0.2) CloseBtn.TextColor3 = Color3.fromRGB(20,20,20) end)
CloseBtn.MouseLeave:Connect(function() tween(CloseBtn, {BackgroundColor3 = darkGray}, 0.2) CloseBtn.TextColor3 = lightGray end)
CloseBtn.MouseButton1Click:Connect(function()
    tween(MainFrame, {Position = UDim2.new(0.5, -225, 1, 50), BackgroundTransparency = 1}, 0.3)
    wait(0.3)
    ScreenGui:Destroy()
end)

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local TabsFrame = create("Frame", {
    Size = UDim2.new(0, 120, 1, -35),
    Position = UDim2.new(0, 0, 0, 35),
    BackgroundColor3 = darkGray,
    BorderSizePixel = 0,
    Parent = MainFrame
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabsFrame })

local ContentFrame = create("Frame", {
    Size = UDim2.new(1, -120, 1, -35),
    Position = UDim2.new(0, 120, 0, 35),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    BorderSizePixel = 0,
    Parent = MainFrame
})
create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ContentFrame })

local TabsLayout = create("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabsFrame })

local currentTab = nil
local tabs = {}

function lib:CreateTab(name)
    local tabBtn = create("TextButton", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = darkGray,
        Text = name,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextColor3 = lightGray,
        Parent = TabsFrame
    })
    create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabBtn })

    local tabContent = create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = ContentFrame
    })

    local layout = create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabContent })

    tabBtn.MouseEnter:Connect(function() tween(tabBtn, {BackgroundColor3 = accentColor}, 0.2) tabBtn.TextColor3 = Color3.fromRGB(20, 20, 20) end)
    tabBtn.MouseLeave:Connect(function()
        if currentTab ~= tabBtn then
            tween(tabBtn, {BackgroundColor3 = darkGray}, 0.2)
            tabBtn.TextColor3 = lightGray
        end
    end)

    tabBtn.MouseButton1Click:Connect(function()
        -- Przełącz taby
        if currentTab then
            tween(currentTab, {BackgroundColor3 = darkGray}, 0.3)
            currentTab.TextColor3 = lightGray
            tabs[currentTab].Visible = false
        end
        currentTab = tabBtn
        tween(currentTab, {BackgroundColor3 = accentColor}, 0.3)
        currentTab.TextColor3 = Color3.fromRGB(20,20,20)
        tabs[currentTab].Visible = true
    end)

    tabs[tabBtn] = tabContent

    tabContent.Visible = false

    if not currentTab then
        currentTab = tabBtn
        tabContent.Visible = true
        tween(currentTab, {BackgroundColor3 = accentColor}, 0.3)
        currentTab.TextColor3 = Color3.fromRGB(20,20,20)
    end


    local tabApi = {}

    function tabApi:Label(text)
        local lbl = create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = lightGray,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabContent
        })
        return lbl
    end

    function tabApi:Button(text, callback)
        local btn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = darkGray,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = lightGray,
            Parent = tabContent
        })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = accentColor}, 0.2) btn.TextColor3 = Color3.fromRGB(20,20,20) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = darkGray}, 0.2) btn.TextColor3 = lightGray end)
        btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
        return btn
    end

    function tabApi:Toggle(text, default, callback)
        local state = default or false
        local btn = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = darkGray,
            Text = text .. ": " .. (state and "ON" or "OFF"),
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = lightGray,
            Parent = tabContent
        })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
        btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = accentColor}, 0.2) btn.TextColor3 = Color3.fromRGB(20,20,20) end)
        btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = darkGray}, 0.2) btn.TextColor3 = lightGray end)

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text .. ": " .. (state and "ON" or "OFF")
            pcall(callback, state)
        end)
        return btn
    end

    function tabApi:Textbox(placeholder, callback)
        local frame = create("Frame", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = darkGray,
            Parent = tabContent
        })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = frame })

        local txtbox = create("TextBox", {
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            Text = "",
            PlaceholderText = placeholder,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = lightGray,
            ClearTextOnFocus = false,
            Parent = frame
        })

        txtbox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                pcall(callback, txtbox.Text)
            end
        end)
        return txtbox
    end

    function tabApi:Dropdown(text, options, callback)
        local dropdownOpen = false
        local frame = create("Frame", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = darkGray,
            Parent = tabContent
        })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = frame })

        local title = create("TextLabel", {
            Size = UDim2.new(0.7, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = lightGray,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })

        local selected = create("TextLabel", {
            Size = UDim2.new(0.3, -10, 1, 0),
            Position = UDim2.new(0.7, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = options[1] or "",
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = accentColor,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = frame
        })

        local dropFrame = create("Frame", {
            Size = UDim2.new(1, 0, 0, #options*30),
            Position = UDim2.new(0, 0, 1, 5),
            BackgroundColor3 = darkGray,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Parent = frame,
            Visible = false
        })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = dropFrame })

        local listLayout = create("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = dropFrame })

        for i,opt in ipairs(options) do
            local optBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = darkGray,
                Text = opt,
                Font = Enum.Font.Gotham,
                TextSize = 15,
                TextColor3 = lightGray,
                Parent = dropFrame
            })
            create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = optBtn })
            optBtn.MouseEnter:Connect(function() tween(optBtn, {BackgroundColor3 = accentColor}, 0.15) optBtn.TextColor3 = Color3.fromRGB(20,20,20) end)
            optBtn.MouseLeave:Connect(function() tween(optBtn, {BackgroundColor3 = darkGray}, 0.15) optBtn.TextColor3 = lightGray end)

            optBtn.MouseButton1Click:Connect(function()
                selected.Text = opt
                dropFrame.Visible = false
                dropdownOpen = false
                pcall(callback, opt)
            end)
        end

        frame.MouseButton1Click = frame.MouseButton1Click or Instance.new("BindableEvent") -- Hack na ClickDetector dla Frame
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dropdownOpen = not dropdownOpen
                dropFrame.Visible = dropdownOpen
            end
        end)

        return frame
    end

    function tabApi:Slider(text, min, max, default, callback)
        local dragging = false
        local value = default or min

        local frame = create("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = darkGray,
            Parent = tabContent
        })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = frame })

        local label = create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = text .. ": " .. tostring(value),
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = lightGray,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })

        local sliderBar = create("Frame", {
            Size = UDim2.new(1, -20, 0, 15),
            Position = UDim2.new(0, 10, 0, 30),
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Parent = frame
        })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = sliderBar })

        local sliderFill = create("Frame", {
            Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = accentColor,
            Parent = sliderBar
        })
        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = sliderFill })

        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        sliderBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativePos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * relativePos + 0.5)
                sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                label.Text = text .. ": " .. tostring(value)
                pcall(callback, value)
            end
        end)

        return frame
    end

    return tabApi
end

return lib
