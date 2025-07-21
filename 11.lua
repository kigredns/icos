-- Sander UI - 0x37 Inspired Roblox Executor Lib
-- by GPT / Inspired by 0x37 Lib
-- Customizable, Expandable, Beautiful

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local lib = {}

local Sander = Instance.new("ScreenGui")
Sander.Name = "SanderUI"
Sander.ResetOnSpawn = false
Sander.Parent = CoreGui

-- MAIN UI CONTAINER
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 600, 0, 400)
Main.Position = UDim2.new(0.5, -300, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Main.BorderSizePixel = 0
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Parent = Sander

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 10)

-- SHADOW
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = Main
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.ZIndex = 0
shadow.Image = "rbxassetid://6015897843"
shadow.ImageTransparency = 0.6

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local TabList = Instance.new("UIListLayout", Sidebar)
TabList.FillDirection = Enum.FillDirection.Vertical
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.VerticalAlignment = Enum.VerticalAlignment.Top
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 6)

-- CONTENT
local Pages = Instance.new("Frame")
Pages.Name = "Pages"
Pages.Size = UDim2.new(1, -120, 1, 0)
Pages.Position = UDim2.new(0, 120, 0, 0)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

-- FOLDER for tab pages
local PageFolder = Instance.new("Folder")
PageFolder.Name = "PageFolder"
PageFolder.Parent = Pages

-- PAGE TEMPLATE FUNCTION
function lib:CreatePage(name: string)
	local btn = Instance.new("TextButton")
	btn.Name = name .. "_Button"
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 14
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	btn.AutoButtonColor = false
	btn.Parent = Sidebar

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)

	local page = Instance.new("ScrollingFrame")
	page.Name = name .. "_Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ScrollBarThickness = 4
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.BackgroundTransparency = 1
	page.Parent = PageFolder

	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	btn.MouseButton1Click:Connect(function()
		for _, p in ipairs(PageFolder:GetChildren()) do
			p.Visible = false
		end
		page.Visible = true
	end)

	return {
		Button = btn,
		Page = page
	}
end

-- COMPONENTS
function lib:CreateLabel(text: string, page)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 25)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = page
end

function lib:CreateButton(text: string, callback: () -> (), page)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 14
	btn.AutoButtonColor = false
	btn.Parent = page

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		}):Play()
	end)

	btn.MouseButton1Click:Connect(callback)
end

function lib:CreateToggle(text: string, callback: (boolean) -> (), page)
	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(1, -20, 0, 30)
	toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Font = Enum.Font.GothamSemibold
	toggle.TextSize = 14
	toggle.Text = text .. ": OFF"
	toggle.AutoButtonColor = false
	toggle.Parent = page

	local corner = Instance.new("UICorner", toggle)
	corner.CornerRadius = UDim.new(0, 6)

	local state = false

	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = text .. ": " .. (state and "ON" or "OFF")
		callback(state)
	end)
end

return lib
