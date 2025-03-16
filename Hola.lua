local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local uiVisible = false
local mainGui = nil
local dragging = false
local startPos = nil
local dragObject = nil

-- Categorías de la UI
local categories = {
    {Name = "Shoots", Icon = "⚽", Options = {"Shot 1", "Shot 2", "Shot 3"}},
    {Name = "Passes", Icon = "↗", Options = {"Pass 1", "Pass 2", "Pass 3"}},
    {Name = "Dribbling", Icon = "↪", Options = {"Dribble 1", "Dribble 2", "Dribble 3"}},
    {Name = "Misc", Icon = "⚙", Options = {"Misc 1", "Misc 2", "Misc 3"}}
}

-- Función para crear la UI
local function CreateUI()
    if playerGui:FindFirstChild("FootballUI") then
        playerGui:FindFirstChild("FootballUI"):Destroy()
    end

    -- Crear un ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FootballUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Panel principal
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 300, 0, 400)
    mainPanel.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainPanel.BorderSizePixel = 0
    mainPanel.Parent = screenGui

    -- Esquinas redondeadas para el panel principal
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainPanel

    -- Título del panel
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "FOOTBALL PRO"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = mainPanel

    -- Contenedor de pestañas en la parte superior
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainPanel

    -- Contenedor de submenús
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, 0, 1, -80)
    contentContainer.Position = UDim2.new(0, 0, 0, 80)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainPanel

    -- Crear pestañas y submenús
    local contentFrames = {}

    for i, category in ipairs(categories) do
        -- Crear pestaña superior
        local tabButton = Instance.new("TextButton")
        tabButton.Name = category.Name .. "Tab"
        tabButton.Size = UDim2.new(1 / #categories, -5, 1, 0)
        tabButton.Position = UDim2.new((i - 1) / #categories, 2.5, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabButton.BackgroundTransparency = 0.3
        tabButton.BorderSizePixel = 0
        tabButton.Text = category.Name
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Parent = tabContainer

        -- Crear submenú
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = category.Name .. "Content"
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.Position = UDim2.new(0, 0, 0, 0)
        contentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        contentFrame.BackgroundTransparency = 0.1
        contentFrame.Visible = (i == 1) -- Hacer visible el primer submenú por defecto
        contentFrame.Parent = contentContainer

        local contentCorner = Instance.new("UICorner")
        contentCorner.CornerRadius = UDim.new(0, 10)
        contentCorner.Parent = contentFrame

        -- Crear opciones dentro de cada submenú
        for j, option in ipairs(category.Options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option" .. j
            optionButton.Size = UDim2.new(1, -20, 0, 40)
            optionButton.Position = UDim2.new(0, 10, 0, (j - 1) * 45 + 10)
            optionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            optionButton.BackgroundTransparency = 0.2
            optionButton.Text = option
            optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            optionButton.TextSize = 14
            optionButton.Font = Enum.Font.Gotham
            optionButton.Parent = contentFrame

            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 5)
            optionCorner.Parent = optionButton
        end

        -- Guardar la referencia al submenú
        contentFrames[i] = contentFrame

        -- Conectar la funcionalidad de cambio de pestaña
        tabButton.MouseButton1Click:Connect(function()
            for _, frame in ipairs(contentFrames) do
                frame.Visible = false
            end
            contentFrame.Visible = true
        end)
    end

    -- Función para arrastrar el panel
    local function DragPanel(frame)
        local dragging = false
        local startPos
        local startPosFrame

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                startPos = input.Position
                startPosFrame = frame.Position
            end
        end)

        frame.InputChanged:Connect(function(input)
            if dragging then
                local delta = input.Position - startPos
                frame.Position = startPosFrame + UDim2.new(0, delta.X, 0, delta.Y)
            end
        end)

        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    -- Hacer arrastrable el panel principal
    DragPanel(mainPanel)

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

print("FootballUI script loaded. Press P to toggle UI.")
