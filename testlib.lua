

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UILib = {}
UILib.__index = UILib

-- Kolory
local darkColor = Color3.fromRGB(30, 30, 40)
local midColor = Color3.fromRGB(45, 45, 60)
local accentColor = Color3.fromRGB(140, 55, 255)
local textColor = Color3.fromRGB(220, 220, 230)
local shadowColor = Color3.new(0, 0, 0)

-- Pomocnicze funkcje
local function create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

local function addShadow(frame)
    local shadow = create("Frame", {
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.new(0, -3, 0, -3),
        ZIndex = 0,
        Parent = frame,
        BackgroundTransparency = 0.75,
        ClipsDescendants = false,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = shadow})
    return shadow
end

local function tween(inst, props, time, style, dir)
    time = time or 0.3
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local tween = TweenService:Create(inst, TweenInfo.new(time, style, dir), props)
    tween:Play()
    return tween
end

-- Główne GUI
function UILib.new()
    local self = setmetatable({}, UILib)

    local screenGui = create("ScreenGui", {
        Name = "AwesomeUILib",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui")
    })

    local mainFrame = create("Frame", {
        Size = UDim2.new(0, 450, 0, 350),
        Position = UDim2.new(0.5, -225, 0.5, -175),
        BackgroundColor3 = darkColor,
        Parent = screenGui,
        AnchorPoint = Vector2.new(0.5, 0.5),
    })
    create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = mainFrame})
    addShadow(mainFrame)

    -- Top bar
    local topBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = midColor,
        Parent = mainFrame,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = topBar})

    local titleLabel = create("TextLabel", {
        Text = "Awesome UI Library",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = textColor,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 7),
        Parent = topBar,
    })

    local closeButton = create("TextButton", {
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = textColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 5),
        Parent = topBar,
    })
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Tab container (list of tabs buttons)
    local tabButtonsFrame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = mainFrame,
    })

    -- Content frame (where tab content goes)
    local contentFrame = create("Frame", {
        Size = UDim2.new(1, -20, 1, -80),
        Position = UDim2.new(0, 10, 0, 80),
        BackgroundColor3 = midColor,
        Parent = mainFrame,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = contentFrame})
    addShadow(contentFrame)

    local tabs = {}
    local selectedTabButton = nil
    local selectedTabContent = nil

    -- Metody tabów
    local tabObj = {}
    tabObj.__index = tabObj

    function tabObj:Button(text, callback)
        local btn = create("TextButton", {
            Text = text,
            BackgroundColor3 = accentColor,
            TextColor3 = textColor,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            Size = UDim2.new(1, 0, 0, 35),
            Parent = self.content,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})
        addShadow(btn)

        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = accentColor:Lerp(Color3.new(1,1,1), 0.2)}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = accentColor}, 0.2)
        end)
        btn.MouseButton1Click:Connect(callback)
    end

    function tabObj:Toggle(text, default, callback)
        local state = default

        local frame = create("Frame", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = midColor,
            Parent = self.content,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = frame})
        addShadow(frame)

        local label = create("TextLabel", {
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = textColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Parent = frame,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local toggleBtn = create("Frame", {
            Size = UDim2.new(0, 36, 0, 20),
            Position = UDim2.new(1, -46, 0.5, -10),
            BackgroundColor3 = state and accentColor or Color3.fromRGB(60,60,60),
            Parent = frame,
        })
        create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = toggleBtn})

        local circle = create("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = state and UDim2.new(1, -18, 0, 1) or UDim2.new(0, 0, 0, 1),
            BackgroundColor3 = Color3.fromRGB(245, 245, 245),
            Parent = toggleBtn,
        })
        create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = circle})
        addShadow(circle)

        local function updateToggle()
            tween(toggleBtn, {BackgroundColor3 = state and accentColor or Color3.fromRGB(60,60,60)}, 0.25)
            tween(circle, {Position = state and UDim2.new(1, -18, 0, 1) or UDim2.new(0, 0, 0, 1)}, 0.25)
        end
        updateToggle()

        toggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                updateToggle()
                callback(state)
            end
        end)
    end

    function tabObj:Textbox(placeholder, callback)
        local box = create("TextBox", {
            PlaceholderText = placeholder,
            Text = "",
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = textColor,
            BackgroundColor3 = midColor,
            Size = UDim2.new(1, 0, 0, 35),
            Parent = self.content,
            ClearTextOnFocus = false,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = box})
        addShadow(box)

        box.FocusLost:Connect(function()
            callback(box.Text)
        end)
    end

    function tabObj:Dropdown(title, options, callback)
        local dropdown = create("Frame", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = midColor,
            Parent = self.content,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = dropdown})
        addShadow(dropdown)

        local label = create("TextLabel", {
            Text = title,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = textColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Parent = dropdown,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local arrow = create("TextLabel", {
            Text = "▼",
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            TextColor3 = textColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(1, -35, 0, 0),
            Parent = dropdown,
        })

        local list = create("Frame", {
            Size = UDim2.new(1, 0, 0, #options * 30),
            Position = UDim2.new(0, 0, 1, 2),
            BackgroundColor3 = midColor,
            Parent = dropdown,
            ClipsDescendants = true,
            Visible = false,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = list})
        addShadow(list)

        local layout = create("UIListLayout", {Parent = list, Padding = UDim.new(0, 3)})
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local function closeDropdown()
            tween(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
            tween(arrow, {Rotation = 0}, 0.25)
            wait(0.25)
            list.Visible = false
        end

        local function openDropdown()
            list.Visible = true
            tween(list, {Size = UDim2.new(1, 0, 0, #options * 30 + (#options - 1) * 3)}, 0.25)
            tween(arrow, {Rotation = 180}, 0.25)
        end

        arrow.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if list.Visible then
                    closeDropdown()
                else
                    openDropdown()
                end
            end
        end)

        for i, option in ipairs(options) do
            local optBtn = create("TextButton", {
                Text = option,
                BackgroundColor3 = midColor,
                TextColor3 = textColor,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Size = UDim2.new(1, 0, 0, 30),
                Parent = list,
                AutoButtonColor = false,
            })
            create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = optBtn})

            optBtn.MouseEnter:Connect(function()
                tween(optBtn, {BackgroundColor3 = accentColor}, 0.2)
            end)
            optBtn.MouseLeave:Connect(function()
                tween(optBtn, {BackgroundColor3 = midColor}, 0.2)
            end)

            optBtn.MouseButton1Click:Connect(function()
                callback(option)
                closeDropdown()
            end)
        end
    end

    function tabObj:Slider(text, min, max, default, callback)
        local slider = create("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = midColor,
            Parent = self.content,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = slider})
        addShadow(slider)

        local label = create("TextLabel", {
            Text = text .. ": " .. tostring(default),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = textColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 10, 0, 5),
            Parent = slider,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local bar = create("Frame", {
            BackgroundColor3 = darkColor,
            Size = UDim2.new(1, -20, 0, 15),
            Position = UDim2.new(0, 10, 0, 30),
            Parent = slider,
        })
        create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = bar})

        local fill = create("Frame", {
            BackgroundColor3 = accentColor,
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            Parent = bar,
        })
        create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})

        local handle = create("Frame", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10),
            BackgroundColor3 = accentColor,
            Parent = bar,
        })
        create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = handle})
        addShadow(handle)

        local dragging = false
        local function updateSlider(inputPosX)
            local relativePos = math.clamp((inputPosX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(relativePos, 0, 1, 0)
            handle.Position = UDim2.new(relativePos, -10, 0.5, -10)
            local value = math.floor(min + (max - min) * relativePos)
            label.Text = text .. ": " .. tostring(value)
            callback(value)
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input.Position.X)
            end
        end)

        bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input.Position.X)
            end
        end)
    end

    -- CreateTab function
    function self:CreateTab(name)
        local tabButton = create("TextButton", {
            Text = name,
            BackgroundColor3 = midColor,
            TextColor3 = textColor,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            Size = UDim2.new(0, 120, 1, 0),
            Parent = tabButtonsFrame,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = tabButton})
        addShadow(tabButton)

        local tabContent = create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Parent = contentFrame,
            Visible = false,
        })

        local tabInstance = setmetatable({
            content = tabContent,
        }, tabObj)

        tabButton.MouseButton1Click:Connect(function()
            if selectedTabButton then
                selectedTabButton.BackgroundColor3 = midColor
                selectedTabContent.Visible = false
            end
            selectedTabButton = tabButton
            selectedTabContent = tabContent
            tabButton.BackgroundColor3 = accentColor
            tabContent.Visible = true
        end)

        -- Jeśli to pierwsza zakładka - automatycznie wybrać
        if #tabs == 0 then
            tabButton.BackgroundColor3 = accentColor
            tabContent.Visible = true
            selectedTabButton = tabButton
            selectedTabContent = tabContent
        end

        table.insert(tabs, tabInstance)
        return tabInstance
    end

    self.ScreenGui = screenGui
    self.MainFrame = mainFrame

    return self
end

return UILib.new()
