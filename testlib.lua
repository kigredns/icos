
function tabObj:Toggle(text, default, callback)
    local state = default
    local toggle = create("Frame", {
        Size = UDim2.new(1, -10, 0, 30),
        BackgroundColor3 = darkColor,
        Parent = content
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = toggle})
    addShadow(toggle)

    local label = create("TextLabel", {
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = textColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 1, 0),
        Parent = toggle
    })

    local button = create("TextButton", {
        Text = "",
        BackgroundColor3 = state and accentColor or Color3.fromRGB(60,60,60),
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0.5, -12),
        Parent = toggle
    })
    create("UICorner", {CornerRadius = UDim.new(1,0), Parent = button})

    button.MouseButton1Click:Connect(function()
        state = not state
        tween(button, {BackgroundColor3 = state and accentColor or Color3.fromRGB(60,60,60)})
        callback(state)
    end)
end

function tabObj:Textbox(placeholder, callback)
    local box = create("TextBox", {
        PlaceholderText = placeholder,
        Text = "",
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = textColor,
        BackgroundColor3 = darkColor,
        Size = UDim2.new(1, -10, 0, 30),
        Parent = content,
        ClearTextOnFocus = false
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = box})
    addShadow(box)

    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
end

function tabObj:Dropdown(title, options, callback)
    local dropdown = create("Frame", {
        Size = UDim2.new(1, -10, 0, 30),
        BackgroundColor3 = darkColor,
        Parent = content
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = dropdown})
    addShadow(dropdown)

    local label = create("TextLabel", {
        Text = title,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = textColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, 1, 0),
        Parent = dropdown
    })

    local toggleBtn = create("TextButton", {
        Text = "▼",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = textColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        Parent = dropdown
    })

    local list = create("Frame", {
        Size = UDim2.new(1, 0, 0, #options * 26),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = midColor,
        Parent = dropdown,
        Visible = false
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = list})
    addShadow(list)

    for _, opt in ipairs(options) do
        local optBtn = create("TextButton", {
            Text = opt,
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = darkColor,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = textColor,
            Parent = list
        })
        create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = optBtn})

        optBtn.MouseButton1Click:Connect(function()
            callback(opt)
            list.Visible = false
        end)
    end

    toggleBtn.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)
end

function tabObj:Slider(text, min, max, default, callback)
    local slider = create("Frame", {
        Size = UDim2.new(1, -10, 0, 40),
        BackgroundColor3 = darkColor,
        Parent = content
    })
    create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = slider})
    addShadow(slider)

    local label = create("TextLabel", {
        Text = text .. ": " .. default,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = textColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Parent = slider
    })

    local bar = create("Frame", {
        BackgroundColor3 = midColor,
        Size = UDim2.new(1, -10, 0, 10),
        Position = UDim2.new(0, 5, 1, -15),
        Parent = slider
    })
    create("UICorner", {CornerRadius = UDim.new(1,0), Parent = bar})

    local fill = create("Frame", {
        BackgroundColor3 = accentColor,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        Parent = bar
    })
    create("UICorner", {CornerRadius = UDim.new(1,0), Parent = fill})

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
            rel = math.clamp(rel, 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            local value = math.floor(min + (max - min) * rel)
            label.Text = text .. ": " .. tostring(value)
            callback(value)
        end
    end)
end

return UILib
