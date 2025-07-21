local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UILib = {}
UILib.__index = UILib

-- Kolory
local colors = {
    background = Color3.fromRGB(18, 18, 25),
    panel = Color3.fromRGB(28, 28, 35),
    accent = Color3.fromRGB(114, 137, 218),
    accentLight = Color3.fromRGB(142, 167, 255),
    text = Color3.fromRGB(220, 220, 230),
    textLight = Color3.fromRGB(240, 240, 250),
    shadow = Color3.fromRGB(0, 0, 0),
    darkGray = Color3.fromRGB(40, 40, 50),
    toggleOn = Color3.fromRGB(100, 180, 255),
    toggleOff = Color3.fromRGB(70, 70, 90),
}

local font = Enum.Font.Gotham

-- Helper: tworzy element z właściwościami
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

-- Helper: dodaje cień pod dany frame (prostokątny)
local function addShadow(frame)
    local shadow = create("Frame", {
        BackgroundColor3 = colors.shadow,
        Size = UDim2.new(1, 8, 1, 8),
        Position = UDim2.new(0, -4, 0, -4),
        ZIndex = 0,
        Parent = frame,
        ClipsDescendants = false,
        BackgroundTransparency = 0.75,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = shadow})
    return shadow
end

-- Animacja hover na przycisku
local function hoverAnim(frame, enter)
    local goalColor = enter and colors.accentLight or colors.accent
    TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = goalColor}):Play()
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
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Konstruktory komponentów UI
local tabObj = {}
tabObj.__index = tabObj

function tabObj:Button(text, callback)
    local button = create("TextButton", {
        Text = text,
        Font = font,
        TextSize = 16,
        TextColor3 = colors.textLight,
        BackgroundColor3 = colors.accent,
        Size = UDim2.new(1, 0, 0, 40),
        AutoButtonColor = false,
        Parent = self.content,
        ZIndex = 2,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = button})
    addShadow(button)

    button.MouseEnter:Connect(function()
        hoverAnim(button, true)
    end)
    button.MouseLeave:Connect(function()
        hoverAnim(button, false)
    end)
    button.MouseButton1Click:Connect(function()
        -- Kliknięcie animacja
        local originalColor = button.BackgroundColor3
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = colors.accentLight}):Play()
        task.delay(0.15, function()
            TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = originalColor}):Play()
        end)
        callback()
    end)
end

function tabObj:Toggle(text, default, callback)
    local state = default or false

    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = colors.darkGray,
        Parent = self.content,
        ZIndex = 2,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = frame})
    addShadow(frame)

    local label = create("TextLabel", {
        Text = text,
        Font = font,
        TextSize = 15,
        TextColor3 = colors.textLight,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 6),
        Size = UDim2.new(1, -60, 1, -12),
        Parent = frame,
        ZIndex = 3,
    })

    local toggleBtn = create("Frame", {
        BackgroundColor3 = state and colors.toggleOn or colors.toggleOff,
        Size = UDim2.new(0, 50, 0, 26),
        Position = UDim2.new(1, -60, 0.5, -13),
        Parent = frame,
        ZIndex = 3,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = toggleBtn})

    local toggleCircle = create("Frame", {
        BackgroundColor3 = colors.background,
        Size = UDim2.new(0, 22, 0, 22),
        Position = state and UDim2.new(1, -28, 0.5, -11) or UDim2.new(0, 4, 0.5, -11),
        Parent = toggleBtn,
        ZIndex = 4,
    })
    create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = toggleCircle})

    -- Animacja przełączania
    local function toggleChange()
        state = not state
        local goalColor = state and colors.toggleOn or colors.toggleOff
        TweenService:Create(toggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = goalColor}):Play()
        TweenService:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = state and UDim2.new(1, -28, 0.5, -11) or UDim2.new(0, 4, 0.5, -11)
        }):Play()
        callback(state)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleChange()
        end
    end)
end

function tabObj:Textbox(placeholder, callback)
    local box = create("TextBox", {
        PlaceholderText = placeholder or "",
        Text = "",
        Font = font,
        TextSize = 15,
        TextColor3 = colors.textLight,
        BackgroundColor3 = colors.darkGray,
        Size = UDim2.new(1, 0, 0, 36),
        Parent = self.content,
        ClearTextOnFocus = false,
        ZIndex = 2,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = box})
    addShadow(box)

    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(box.Text)
            box.Text = ""
        end
    end)
end

function tabObj:Dropdown(title, options, callback)
    local isOpen = false

    local dropdownFrame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = colors.darkGray,
        Parent = self.content,
        ZIndex = 2,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = dropdownFrame})
    addShadow(dropdownFrame)

    local label = create("TextLabel", {
        Text = title,
        Font = font,
        TextSize = 15,
        TextColor3 = colors.textLight,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 6),
        Size = UDim2.new(1, -60, 1, -12),
        Parent = dropdownFrame,
        ZIndex = 3,
    })

    local arrow = create("TextLabel", {
        Text = "▼",
        Font = font,
        TextSize = 20,
        TextColor3 = colors.accent,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0.5, -12),
        Size = UDim2.new(0, 30, 0, 24),
        Parent = dropdownFrame,
        ZIndex = 3,
    })

    local optionsFrame = create("Frame", {
        Size = UDim2.new(1, 0, 0, #options * 36),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = colors.panel,
        Parent = dropdownFrame,
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 4,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 14), Parent = optionsFrame})
    addShadow(optionsFrame)

    local function closeDropdown()
        isOpen = false
        optionsFrame.Visible = false
        arrow.Text = "▼"
        TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 36)}):Play()
    end

    local function openDropdown()
        isOpen = true
        optionsFrame.Visible = true
        arrow.Text = "▲"
        TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 36 + #options * 36)}):Play()
    end

    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isOpen then
                closeDropdown()
            else
                openDropdown()
            end
        end
    end)

    for i, optionText in ipairs(options) do
        local opt = create("TextButton", {
            Text = optionText,
            Font = font,
            TextSize = 15,
            TextColor3 = colors.textLight,
            BackgroundColor3 = colors.panel,
            Size = UDim2.new(1, 0, 0, 36),
            Position = UDim2.new(0, 0, 0, (i - 1) * 36),
            Parent = optionsFrame,
            AutoButtonColor = false,
            ZIndex = 5,
        })
        create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = opt})
        opt.MouseEnter:Connect(function()
            TweenService:Create(opt, TweenInfo.new(0.15), {BackgroundColor3 = colors.accent}):Play()
        end)
        opt.MouseLeave:Connect(function()
            TweenService:Create(opt, TweenInfo.new(0.15), {BackgroundColor3 = colors.panel}):Play()
        end)
        opt.MouseButton1Click:Connect(function()
            callback(optionText)
            label.Text = title .. ": " .. optionText
            closeDropdown()
        end)
    end
end

-- Główna funkcja tworząca UI
function UILib:CreateWindow(title)
    local screenGui = create("ScreenGui", {
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        Name = "SuperPremiumUI",
        Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"),
    })

    local mainFrame = create("Frame", {
        Size = UDim2.new(0, 460, 0, 520),
        Position = UDim2.new(0.5, -230, 0.5, -260),
        BackgroundColor3 = colors.panel,
        Parent = screenGui,
        ClipsDescendants = false,
        ZIndex = 10,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = mainFrame})
    addShadow(mainFrame)

    local titleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = colors.background,
        Parent = mainFrame,
        ZIndex = 11,
    })
    create("UICorner", {CornerRadius = UDim.new(0, 18), Parent = titleBar})

    local titleLabel = create("TextLabel", {
        Text = title or "SuperPremium UI",
        Font = font,
        TextSize = 26,
        TextColor3 = colors.textLight,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = titleBar,
        ZIndex = 12,
    })

    local closeBtn = create("TextButton", {
        Text = "✕",
        Font = font,
        TextSize = 30,
        TextColor3 = colors.textLight,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 44, 0, 44),
        Position = UDim2.new(1, -54, 0.5, -22),
        Parent = titleBar,
        ZIndex = 12,
        AutoButtonColor = false,
    })
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 90, 90)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = colors.textLight}):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    makeDraggable(mainFrame, titleBar)

    local content = create("Frame", {
        Position = UDim2.new(0, 20, 0, 60),
        Size = UDim2.new(1, -40, 1, -70),
        BackgroundTransparency = 1,
        Parent = mainFrame,
        ClipsDescendants = false,
        ZIndex = 11,
    })

    local tabInstance = setmetatable({content = content}, tabObj)
    return tabInstance
end

return UILib
