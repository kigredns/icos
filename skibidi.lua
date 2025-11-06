
local TweenService = game:GetService("TweenService")

local BODY = Instance.new("ScreenGui")

local flash = Instance.new("Frame")
flash.BackgroundColor3 = Color3.new(1, 1, 1)
flash.Size = UDim2.new(1, 0, 1, 0)
flash.BackgroundTransparency = 0
flash.ZIndex = 100

BODY.Name = "BODY"
BODY.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
BODY.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
flash.Parent = BODY

local RAMKATRZYMAJACARAMKE1 = Instance.new("Frame")
local RAMKA1 = Instance.new("Frame")
local DISCORLABEL = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local copybutton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local close = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")

RAMKATRZYMAJACARAMKE1.Name = "RAMKATRZYMAJACARAMKE1"
RAMKATRZYMAJACARAMKE1.Parent = BODY
RAMKATRZYMAJACARAMKE1.AnchorPoint = Vector2.new(0.5, 0.5)
RAMKATRZYMAJACARAMKE1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RAMKATRZYMAJACARAMKE1.BorderSizePixel = 0
RAMKATRZYMAJACARAMKE1.Size = UDim2.new(0, 0, 0, 0)
RAMKATRZYMAJACARAMKE1.Position = UDim2.new(0.5, 0, 0.3, 0)
RAMKATRZYMAJACARAMKE1.BackgroundTransparency = 1

RAMKA1.Name = "RAMKA1"
RAMKA1.Parent = RAMKATRZYMAJACARAMKE1
RAMKA1.AnchorPoint = Vector2.new(0.5, 0.5)
RAMKA1.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
RAMKA1.BorderSizePixel = 0
RAMKA1.Position = UDim2.new(0.5, 0, 0.5, 0)
RAMKA1.Size = UDim2.new(0, 539, 0, 396)

DISCORLABEL.Name = "DISCORLABEL"
DISCORLABEL.Parent = RAMKA1
DISCORLABEL.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
DISCORLABEL.BorderSizePixel = 0
DISCORLABEL.Position = UDim2.new(0.02, 0, 0.84, 0)
DISCORLABEL.Size = UDim2.new(0, 345, 0, 50)
DISCORLABEL.Font = Enum.Font.SourceSansBold
DISCORLABEL.Text = "dsc.gg/sanderteam"
DISCORLABEL.TextColor3 = Color3.fromRGB(0, 255, 213)
DISCORLABEL.TextSize = 48
UICorner.Parent = DISCORLABEL

spawn(function()
	while true do
		TweenService:Create(DISCORLABEL, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			TextColor3 = Color3.fromRGB(0, 200, 255)
		}):Play()
		wait(1)
		TweenService:Create(DISCORLABEL, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			TextColor3 = Color3.fromRGB(0, 255, 213)
		}):Play()
		wait(1)
	end
end)

copybutton.Name = "copybutton"
copybutton.Parent = RAMKA1
copybutton.BackgroundColor3 = Color3.fromRGB(60, 255, 0)
copybutton.BorderSizePixel = 0
copybutton.Position = UDim2.new(0.74, 0, 0.84, 0)
copybutton.Size = UDim2.new(0, 127, 0, 50)
copybutton.Font = Enum.Font.SourceSansBold
copybutton.Text = "COPY"
copybutton.TextColor3 = Color3.fromRGB(255, 0, 0)
copybutton.TextSize = 33
UICorner_2.Parent = copybutton

local function buttonHover(button)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {
			Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 10, button.Size.Y.Scale, button.Size.Y.Offset + 5)
		}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {
			Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 10, button.Size.Y.Scale, button.Size.Y.Offset - 5)
		}):Play()
	end)
end
buttonHover(copybutton)

TextLabel.Parent = RAMKA1
TextLabel.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.02, 0, 0.03, 0)
TextLabel.Size = UDim2.new(0, 514, 0, 321)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "Join our Discord for updates, leaks (like the Sander XY and Brookhaven updates), and support. If you've purchased Delux, contact the script owner via Discord for help."
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

close.Name = "close"
close.Parent = RAMKA1
close.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
close.BorderSizePixel = 0
close.Position = UDim2.new(0.89, 0, 0.03, 0)
close.Size = UDim2.new(0, 56, 0, 51)
close.Font = Enum.Font.SourceSansBold
close.Text = "x"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 52
UICorner_4.Parent = close
buttonHover(close)

copybutton.MouseButton1Click:Connect(function()
	setclipboard("dsc.gg/sanderteam")
	copybutton.Text = "COPIED!"
	wait(1)
	copybutton.Text = "COPY"
end)

close.MouseButton1Click:Connect(function()
	local goal = {
		Size = UDim2.new(0, 0, 0, 0),
		Rotation = 90,
		BackgroundTransparency = 1
	}
	local tween = TweenService:Create(RAMKATRZYMAJACARAMKE1, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.In), goal)
	tween:Play()
	tween.Completed:Wait()
	BODY:Destroy()
end)

TweenService:Create(flash, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
delay(0.35, function() flash:Destroy() end)

TweenService:Create(RAMKATRZYMAJACARAMKE1, TweenInfo.new(0.65, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 560, 0, 417),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	BackgroundTransparency = 0
}):Play()
