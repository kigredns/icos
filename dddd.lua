

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UILib = {}
UILib.__index = UILib

-- Kolory i style
local colors = {
    background = Color3.fromRGB(18, 18, 25),
    panel = Color3.fromRGB(28, 28, 35),
    accent = Color3.fromRGB(114, 137, 218),
    accentLight = Color3.fromRGB(142, 167, 255),
    text = Color3.fromRGB(220, 220, 230),
    textLight = Color3.fromRGB(240, 240, 250),
    shadow = Color3.fromRGB(0, 0, 0),
}

local font = Enum.Font.Gotham

-- Utility - tworzenie obiektów
local function create(className, props)
    local obj = Instance.new(className)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then
                obj.Parent = v
            else
                obj[k] = v
            end
        end
    end
    return obj
end

-- Dodanie cienia
local function addShadow(parent)
    local shadow = create("Frame", {
        BackgroundColor3 = colors.shadow,
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.new(0, -3, 0, -3),
        ZIndex = 0,
        Parent = parent,
        ClipsDescendants = false,
    })
    local uicorner = create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = shadow})
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = 0
    return shadow
end

-- Animacja hover na przyciskach
local function hoverAnim(frame, enter)
    local goalColor = enter and colors.accentLight or colors.accent
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = goalColor}):Play()
end

-- Przeciąganie GUI
local function makeDraggable(frame, dragArea)
    local dragging, dragInput, dragStart, startPos

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Main constructor
function UILib.new()
    local self = setmetatable({}, UILib)

    -- Stworzenie ekranu
    local screenGui = create("ScreenGui", {
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        Name = "SuperPremiumUI"
    })

    -- Główny panel
    local mainFrame = create("Frame", {
        Size = UDim2.new(0, 450, 0, 520),
        Position = UDim2.new(0.5, -225, 0.5, -260),
        BackgroundColor3 = colors.panel,
        Parent = screenGui,
        ClipsDescendants = false,
    })
    local corner = create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = mainFrame})
    addShadow(mainFrame)

    -- Gradient na tle panelu
    local gradient = create("UIGradient", {
        Rotation = 45,
        Parent = mainFrame
    })
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, colors.panel),
        ColorSequenceKeypoint.new(1, colors.background)
    }

    -- Pasek tytułowy
    local titleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = colors.background,
        Parent = mainFrame,
        ZIndex = 2,
    })
    local titleCorner = create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = titleBar})

    local titleText = create("TextLabel", {
        Text = "SuperPremium UI",
        Font = font,
        TextSize = 22,
        TextColor3 = colors.textLight,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = titleBar,
        ZIndex = 3,
    })

    -- Zamknij przycisk
    local closeButton = create("TextButton", {
        Text = "✕",
        Font = font,
        TextSize = 28,
        TextColor3 = colors.textLight,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -46, 0.5, -20),
        Parent = titleBar,
        ZIndex = 3,
    })
    closeButton.MouseEnter:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 70, 70)}):Play() end)
    closeButton.MouseLeave:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {TextColor3 = colors.textLight}):Play() end)
    closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Przeciąganie po titleBar
    makeDraggable(mainFrame, titleBar)

    -- Kontener na zakładki
    local tabsHolder = create("Frame", {
        Size = UDim2.new(0, 100, 1, -48),
        Position = UDim2.new(0, 0, 0, 48),
        BackgroundTransparency = 1,
        Parent = mainFrame,
        ZIndex = 2,
    })

    -- Zaokrąglone przyciski zakładek
    local tabButtonList = {}

    -- Kontener na treść zakładki
    local contentHolder = create("Frame", {
        Size = UDim2.new(1, -100, 1, -48),
        Position = UDim2.new(0, 100, 0, 48),
        BackgroundColor3 = colors.background,
        Parent = mainFrame,
        ClipsDescendants = true,
        ZIndex = 2,
    })
    local contentCorner = create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = contentHolder})

    local selectedTab

    function self:CreateTab(name)
        -- Stwórz przycisk zakładki
        local tabButton = create("TextButton", {
            Text = name,
            Font = font,
            TextSize = 16,
            BackgroundColor3 = colors.panel,
            TextColor3 = colors.text,
            Size = UDim2.new(1, -10, 0, 40),
            Position = UDim2.new(0, 5, 0, (#tabButtonList * 45) + 5),
            Parent = tabsHolder,
            AutoButtonColor = false,
            ZIndex = 3,
        })
        local btnCorner = create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = tabButton})
        addShadow(tabButton)

        -- Hover efekt
        tabButton.MouseEnter:Connect(function()
            TweenService:Create(tabButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = colors.accent}):Play()
            TweenService:Create(tabButton, TweenInfo.new(0.25), {TextColor3 = colors.textLight}):Play()
        end)
        tabButton.MouseLeave:Connect(function()
            if selectedTab ~= tabButton then
                TweenService:Create(tabButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = colors.panel}):Play()
                TweenService:Create(tabButton, TweenInfo.new(0.25), {TextColor3 = colors.text}):Play()
            end
        end)

        -- Treść zakładki
        local tabContent = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 6,
            Parent = contentHolder,
            Visible = false,
        })
        tabContent.CanvasSize = UDim2.new(0,0,0,0)
        local uiCorner = create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = tabContent})

        -- Automatyczne aktualizowanie rozmiaru canvasu
        tabContent.ChildAdded:Connect(function()
            local contentHeight = 0
            for _,child in pairs(tabContent:GetChildren()) do
                if child:IsA("GuiObject") and child ~= uiCorner then
                    contentHeight = contentHeight + child.AbsoluteSize.Y + 10
                end
            end
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        end)

        -- Zmiana zakładki po kliknięciu
        tabButton.MouseButton1Click:Connect(function()
            if selectedTab then
                TweenService:Create(selectedTab, TweenInfo.new(0.3), {BackgroundColor3 = colors.panel}):Play()
                contentHolder:FindFirstChildWhichIsA("ScrollingFrame").Visible = false
            end
            selectedTab = tabButton
            TweenService:Create(tabButton, TweenInfo.new(0.3), {BackgroundColor3 = colors.accent}):Play()
            tabContent.Visible = true
        end)

        -- Domyślnie wybierz pierwszą zakładkę
        if #tabButtonList == 0 then
            selectedTab = tabButton
            tabButton.BackgroundColor3 = colors.accent
            tabContent.Visible = true
        end

        -- Metody zakładki (dodawanie przycisków, toggle itd.)
        local tabObj = {}

        local function addUICorner(obj, radius)
            radius = radius or 8
            local corner = create("UICorner", {CornerRadius = UDim.new(0, radius), Parent = obj})
            return corner
        end

        function tabObj:Button(text, callback)
            local btn = create("TextButton", {
                Text = text,
                Font = font,
                TextSize = 18,
                TextColor3 = colors.textLight,
                BackgroundColor3 = colors.accent,
                Size = UDim2.new(1, -20, 0, 40),
                Parent = tabContent,
                AutoButtonColor = false,
            })
            addUICorner(btn, 12)
            addShadow(btn)

            btn.MouseEnter:Connect(function()
                hoverAnim(btn, true)
            end)
            btn.MouseLeave:Connect(function()
                hoverAnim(btn, false)
            end)
            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = colors.accentLight}):Play()
                wait(0.12)
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = colors.accent}):Play()
                callback()
            end)
        end

        function tabObj:Toggle(text, default, callback)
            local state = default or false

            local frame = create("Frame", {
                Size = UDim2.new(1, -20, 0, 40),
                BackgroundColor3 = colors.panel,
                Parent = tabContent,
            })
            addUICorner(frame, 12)
            addShadow(frame)

            local label = create("TextLabel", {
                Text = text,
                Font = font,
                TextSize = 16,
                TextColor3 = colors.textLight,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0.7, 0, 1, 0),
                Parent = frame,
            })

            local toggleBtn = create("Frame", {
                Size = UDim2.new(0, 50, 0, 25),
                BackgroundColor3 = state and colors.accent or Color3.fromRGB(50,50,50),
                Position = UDim2.new(1, -60, 0, 8),
                Parent = frame,
                ClipsDescendants = true,
            })
            addUICorner(toggleBtn, 12)
            addShadow(toggleBtn)

            local knob = create("Frame", {
                Size = UDim2.new(0, 21, 0, 21),
                BackgroundColor3 = colors.background,
                Position = state and UDim2.new(1, -25, 0, 2) or UDim2.new(0, 4, 0, 2),
                Parent = toggleBtn,
            })
            addUICorner(knob, 12)
            addShadow(knob)

            local function updateToggle(newState)
                state = newState
                local toggleColor = state and colors.accent or Color3.fromRGB(50,50,50)
                local knobPos = state and UDim2.new(1, -25, 0, 2) or UDim2.new(0, 4, 0, 2)
                TweenService:Create(toggleBtn, TweenInfo.new(0.25), {BackgroundColor3 = toggleColor}):Play()
                TweenService:Create(knob, TweenInfo.new(0.25), {Position = knobPos}):Play()
                callback(state)
            end

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateToggle(not state)
                end
            end)
        end

        function tabObj:Slider(text, min, max, default, callback)
            default = default or min
            local value = default

            local frame = create("Frame", {
                Size = UDim2.new(1, -20, 0, 60),
                BackgroundColor3 = colors.panel,
                Parent = tabContent,
            })
            addUICorner(frame, 12)
            addShadow(frame)

            local label = create("TextLabel", {
                Text = text,
                Font = font,
                TextSize = 16,
                TextColor3 = colors.textLight,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 8),
                Size = UDim2.new(1, -20, 0, 20),
                Parent = frame,
            })

            local sliderBack = create("Frame", {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                Position = UDim2.new(0, 10, 0, 34),
                Size = UDim2.new(1, -20, 0, 12),
                Parent = frame,
            })
            addUICorner(sliderBack, 8)

            local sliderFill = create("Frame", {
                BackgroundColor3 = colors.accent,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                Parent = sliderBack,
            })
            addUICorner(sliderFill, 8)

            local valueLabel = create("TextLabel", {
                Text = tostring(value),
                Font = font,
                TextSize = 16,
                TextColor3 = colors.textLight,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0, 8),
                Size = UDim2.new(0, 30, 0, 20),
                Parent = frame,
            })

            local dragging = false

            sliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local mouse = input.Position
                    local relPos = math.clamp(mouse.X - sliderBack.AbsolutePosition.X, 0, sliderBack.AbsoluteSize.X)
                    value = math.floor(min + (relPos / sliderBack.AbsoluteSize.X) * (max - min) + 0.5)
                    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    valueLabel.Text = tostring(value)
                    callback(value)
                end
            end)

            sliderBack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            sliderBack.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relPos = math.clamp(input.Position.X - sliderBack.AbsolutePosition.X, 0, sliderBack.AbsoluteSize.X)
                    value = math.floor(min + (relPos / sliderBack.AbsoluteSize.X) * (max - min) + 0.5)
                    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    valueLabel.Text = tostring(value)
                    callback(value)
                end
            end)
        end

        function tabObj:Dropdown(text, options, callback)
            local frame = create("Frame", {
                Size = UDim2.new(1, -20, 0, 40),
                BackgroundColor3 = colors.panel,
                Parent = tabContent,
            })
            addUICorner(frame, 12)
            addShadow(frame)

            local label = create("TextLabel", {
                Text = text,
                Font = font,
                TextSize = 16,
                TextColor3 = colors.textLight,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0.6, 0, 1, 0),
                Parent = frame,
            })

            local selectedIndex = 1
            local open = false

            local dropdownBtn = create("TextButton", {
                Text = options[selectedIndex] or "Wybierz",
                Font = font,
                TextSize = 16,
                TextColor3 = colors.textLight,
                BackgroundColor3 = colors.accent,
                Position = UDim2.new(0.6, 10, 0.1, 5),
                Size = UDim2.new(0.35, -20, 0.8, 0),
                Parent = frame,
                AutoButtonColor = false,
            })
            addUICorner(dropdownBtn, 12)
            addShadow(dropdownBtn)

            local optionsHolder = create("Frame", {
                Size = UDim2.new(1, 0, 0, #options * 30),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = colors.panel,
                ClipsDescendants = true,
                Visible = false,
                Parent = frame,
                ZIndex = 10,
            })
            addUICorner(optionsHolder, 12)
            addShadow(optionsHolder)

            local function closeDropdown()
                open = false
                TweenService:Create(optionsHolder, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                wait(0.3)
                optionsHolder.Visible = false
            end

            local function openDropdown()
                open = true
                optionsHolder.Visible = true
                TweenService:Create(optionsHolder, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, #options * 30)}):Play()
            end

            dropdownBtn.MouseButton1Click:Connect(function()
                if open then
                    closeDropdown()
                else
                    openDropdown()
                end
            end)

            for i, option in ipairs(options) do
                local optBtn = create("TextButton", {
                    Text = option,
                    Font = font,
                    TextSize = 14,
                    TextColor3 = colors.textLight,
                    BackgroundColor3 = colors.panel,
                    Size = UDim2.new(1, 0, 0, 30),
                    Position = UDim2.new(0, 0, 0, (i-1)*30),
                    Parent = optionsHolder,
                    AutoButtonColor = false,
                })
                addUICorner(optBtn, 8)
                addShadow(optBtn)

                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = colors.accent}):Play()
                    TweenService:Create(optBtn, TweenInfo.new(0.2), {TextColor3 = colors.textLight}):Play()
                end)
                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = colors.panel}):Play()
                    TweenService:Create(optBtn, TweenInfo.new(0.2), {TextColor3 = colors.textLight}):Play()
                end)

                optBtn.MouseButton1Click:Connect(function()
                    selectedIndex = i
                    dropdownBtn.Text = option
                    callback(option)
                    closeDropdown()
                end)
            end
        end

        function tabObj:Textbox(text, callback)
            local frame = create("Frame", {
                Size = UDim2.new(1, -20, 0, 40),
                BackgroundColor3 = colors.panel,
                Parent = tabContent,
            })
            addUICorner(frame, 12)
            addShadow(frame)

            local label = create("TextLabel", {
                Text = text,
                Font = font,
                TextSize = 16,
                TextColor3 = colors.textLight,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0.6, 0, 1, 0),
                Parent = frame,
            })

            local textbox = create("TextBox", {
                Font = font,
                TextSize = 16,
                TextColor3 = colors.textLight,
                BackgroundColor3 = colors.accent,
                Position = UDim2.new(0.6, 10, 0.1, 5),
                Size = UDim2.new(0.35, -20, 0.8, 0),
                Parent = frame,
                ClearTextOnFocus = false,
                Text = "",
                ZIndex = 5,
            })
            addUICorner(textbox, 12)
            addShadow(textbox)

            textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(textbox.Text)
                end
            end)
        end

        table.insert(tabButtonList, tabButton)
        return tabObj
    end

    self.ScreenGui = screenGui
    self.MainFrame = mainFrame
    self.TabsHolder = tabsHolder
    self.ContentHolder = contentHolder

    screenGui.Parent = game:GetService("CoreGui")

    return self
end

return UILib
