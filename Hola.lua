-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FootballScriptUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create the sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 200, 0, 400)
sidebar.Position = UDim2.new(0, 20, 0.5, -200)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sidebar.BorderSizePixel = 0
sidebar.Parent = screenGui

-- Add rounded corners to sidebar
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

-- Create the title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Football Script"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = sidebar

-- Tab configuration
local tabs = {
    {name = "Shoots", color = Color3.fromRGB(72, 187, 120)},
    {name = "Passes", color = Color3.fromRGB(72, 187, 120)},
    {name = "Dribbling", color = Color3.fromRGB(72, 187, 120)},
    {name = "Misc", color = Color3.fromRGB(72, 187, 120)},
    {name = "Modes", color = Color3.fromRGB(72, 187, 120)},
    {name = "Goalkeeping", color = Color3.fromRGB(72, 187, 120)},
    {name = "Visuals", color = Color3.fromRGB(72, 187, 120)}
}

-- Function to create a window
local function createWindow(name, position)
    local window = Instance.new("Frame")
    window.Name = name .. "Window"
    window.Size = UDim2.new(0, 400, 0, 300)
    window.Position = position or UDim2.new(0.5, -200, 0.5, -150)
    window.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    window.BorderSizePixel = 0
    window.Visible = false
    window.Parent = screenGui
    
    -- Add rounded corners
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 8)
    windowCorner.Parent = window
    
    -- Add title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window
    
    -- Add rounded corners to title bar
    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 8)
    titleBarCorner.Parent = titleBar
    
    -- Add window title
    local windowTitle = Instance.new("TextLabel")
    windowTitle.Size = UDim2.new(1, -40, 1, 0)
    windowTitle.Position = UDim2.new(0, 10, 0, 0)
    windowTitle.BackgroundTransparency = 1
    windowTitle.Text = name
    windowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    windowTitle.TextSize = 18
    windowTitle.Font = Enum.Font.GothamMedium
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left
    windowTitle.Parent = titleBar
    
    -- Add close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    -- Add rounded corners to close button
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Add content area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 50)
    content.BackgroundTransparency = 1
    content.Parent = window
    
    -- Add placeholder text
    local placeholder = Instance.new("TextLabel")
    placeholder.Size = UDim2.new(1, 0, 0, 30)
    placeholder.Position = UDim2.new(0, 0, 0, 10)
    placeholder.BackgroundTransparency = 1
    placeholder.Text = name .. " Controls Panel"
    placeholder.TextColor3 = Color3.fromRGB(200, 200, 200)
    placeholder.TextSize = 18
    placeholder.Font = Enum.Font.GothamMedium
    placeholder.Parent = content
    
    -- Add shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://297774371"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = -1
    shadow.Parent = window
    
    -- Make window draggable
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        window.Visible = false
    end)
    
    return window
end

-- Create tab buttons and windows
local windows = {}
for i, tab in ipairs(tabs) do
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tab.name .. "Tab"
    tabButton.Size = UDim2.new(0.9, 0, 0, 40)
    tabButton.Position = UDim2.new(0.05, 0, 0, 60 + (i-1) * 50)
    tabButton.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    tabButton.Text = tab.name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.TextSize = 16
    tabButton.Font = Enum.Font.GothamMedium
    tabButton.Parent = sidebar
    
    -- Add rounded corners to tab button
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    -- Create window for this tab
    local window = createWindow(tab.name, UDim2.new(0.5, -200 + (i * 30), 0.5, -150 + (i * 30)))
    windows[tab.name] = window
    
    -- Connect tab button
    tabButton.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
        tabButton.BackgroundColor3 = window.Visible 
            and Color3.fromRGB(72, 187, 120) 
            or Color3.fromRGB(42, 42, 42)
    end)
end

-- Make sidebar draggable
local isDragging = false
local dragStart = nil
local startPos = nil

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = sidebar.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
        local delta = input.Position - dragStart
        sidebar.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
