-- VapeStyleUI.lua
-- UI estilo VAPE para un juego de fútbol en Roblox

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local uiVisible = false
local mainGui = nil

-- Categorías para el juego de fútbol
local categories = {
    {Name = "Shoots", Icon = "⚽"},
    {Name = "Passes", Icon = "↗"},
    {Name = "Dribbling", Icon = "↪"},
    {Name = "Misc", Icon = "⚙"},
    {Name = "Modes", Icon = "$"},
    {Name = "Goalkeeping", Icon = "👐"},
    {Name = "Visuals", Icon = "👁"}
}

-- Función para crear la UI
local function CreateUI()
    if playerGui:FindFirstChild("FootballUI") then
        playerGui:FindFirstChild("FootballUI"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FootballUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Barra horizontal de pestañas en la parte superior
    local topTabsFrame = Instance.new("Frame")
    topTabsFrame.Name = "TopTabsFrame"
    topTabsFrame.Size = UDim2.new(1, -200, 0, 40)
    topTabsFrame.Position = UDim2.new(0, 190, 0, 10)
    topTabsFrame.BackgroundTransparency = 1
    topTabsFrame.Parent = screenGui

    local contentContainers = {}

    local function SelectCategory(index)
        for i, tab in ipairs(topTabsFrame:GetChildren()) do
            if tab:IsA("TextButton") then
                tab.BackgroundTransparency = (i == index) and 0 or 0.5
            end
        end
        for i, container in pairs(contentContainers) do
            container.Visible = (i == index)
        end
    end

    for i, category in ipairs(categories) do
        local topTab = Instance.new("TextButton")
        topTab.Name = category.Name .. "Tab"
        topTab.Size = UDim2.new(1/#categories, -5, 1, 0)
        topTab.Position = UDim2.new((i-1)/#categories, 2.5, 0, 0)
        topTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        topTab.BackgroundTransparency = i == 1 and 0 or 0.5
        topTab.BorderSizePixel = 0
        topTab.Text = category.Name
        topTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        topTab.TextSize = 14
        topTab.Font = Enum.Font.GothamSemibold
        topTab.Parent = topTabsFrame

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 5)
        tabCorner.Parent = topTab

        local contentFrame = Instance.new("Frame")
        contentFrame.Name = category.Name .. "Content"
        contentFrame.Size = UDim2.new(0, 200, 0, 300)
        contentFrame.Position = UDim2.new(0, 190, 0, 60)
        contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        contentFrame.BackgroundTransparency = 0.1
        contentFrame.BorderSizePixel = 0
        contentFrame.Visible = (i == 1)
        contentFrame.Parent = screenGui

        local contentCorner = Instance.new("UICorner")
        contentCorner.CornerRadius = UDim.new(0, 5)
        contentCorner.Parent = contentFrame

        contentContainers[i] = contentFrame

        topTab.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)

        -- Función para arrastrar pestañas
        local dragging
        local dragInput
        local dragStart
        local startPos

        local function updateInput(input)
            local delta = input.Position - dragStart
            topTab.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
        end

        topTab.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = topTab.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        topTab.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                updateInput(input)
            end
        end)
    end

    return screenGui
end

function ToggleUI()
    if uiVisible then
        if mainGui then
            mainGui:Destroy()
            mainGui = nil
        end
        uiVisible = false
    else
        mainGui = CreateUI()
        uiVisible = true
    end
end

local function onInputBegan(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        ToggleUI()
    end
end

UserInputService.InputBegan:Connect(onInputBegan)

mainGui = CreateUI()
uiVisible = true

print("FootballUI script loaded. Press P to toggle UI.")
