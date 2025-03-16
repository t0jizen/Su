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

-- Función para hacer que los paneles sean arrastrables
local function MakePanelDraggable(panel)
    local dragInput, mousePos, panelPos
    local dragging = false

    local function onInputBegan(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            panelPos = panel.Position
        end
    end

    local function onInputChanged(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - mousePos
            panel.Position = UDim2.new(panelPos.X.Scale, panelPos.X.Offset + delta.X, panelPos.Y.Scale, panelPos.Y.Offset + delta.Y)
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end

    panel.InputBegan:Connect(onInputBegan)
    panel.InputChanged:Connect(onInputChanged)
    panel.InputEnded:Connect(onInputEnded)
end

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
        -- Crear pestaña superior
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

        -- Crear contenedor para el contenido de esta categoría
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = category.Name .. "Content"
        contentFrame.Size = UDim2.new(0, 200, 0, 300)
        contentFrame.Position = UDim2.new(0, 190, 0, 60)
        contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        contentFrame.BackgroundTransparency = 0.1
        contentFrame.BorderSizePixel = 0
        contentFrame.Visible = (i == 1)  -- Solo mostrar la primera categoría al inicio
        contentFrame.Parent = screenGui

        -- Esquinas redondeadas para el contenedor
        local contentCorner = Instance.new("UICorner")
        contentCorner.CornerRadius = UDim.new(0, 5)
        contentCorner.Parent = contentFrame

        contentContainers[i] = contentFrame

        -- Añadir opciones para esta categoría
        for j = 1, 5 do
            local option = Instance.new("TextButton")
            option.Name = "Option" .. j
            option.Size = UDim2.new(1, -20, 0, 30)
            option.Position = UDim2.new(0, 10, 0, (j-1) * 35 + 10)
            option.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            option.BackgroundTransparency = 0.5
            option.Text = category.Name .. " Option " .. j
            option.TextColor3 = Color3.fromRGB(255, 255, 255)
            option.TextSize = 14
            option.Font = Enum.Font.Gotham
            option.Parent = contentFrame

            -- Esquinas redondeadas para la opción
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 4)
            optionCorner.Parent = option
        end

        -- Conectar eventos de clic
        topTab.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
    end

    -- Hacer que los paneles sean arrastrables
    MakePanelDraggable(topTabsFrame)

    return screenGui
end

-- Función para mostrar/ocultar la UI
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

-- Conectar la tecla P para mostrar/ocultar la UI
local function onInputBegan(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        ToggleUI()
    end
end

-- Conectar el evento de entrada
UserInputService.InputBegan:Connect(onInputBegan)

-- Mostrar la UI inicialmente
mainGui = CreateUI()
uiVisible = true

-- Mensaje para confirmar que el script se ha cargado
print("FootballUI script loaded. Press P to toggle UI.")
