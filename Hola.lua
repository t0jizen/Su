-- FootballUI.lua
-- UI para un juego de fútbol en Roblox (lado del cliente)
-- Presiona RightShift para mostrar/ocultar
-- Arrastra desde la barra superior para mover

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuración principal
local TITLE = "FOOTBALL PRO"
local MAIN_COLOR = Color3.fromRGB(20, 20, 25) -- Color oscuro para el panel
local SECONDARY_COLOR = Color3.fromRGB(30, 30, 35) -- Color para los botones
local TEXT_COLOR = Color3.fromRGB(255, 255, 255) -- Texto blanco
local HIGHLIGHT_COLOR = Color3.fromRGB(0, 170, 255) -- Azul brillante para selección
local CORNER_RADIUS = 8 -- Radio de las esquinas redondeadas

-- Categorías para las pestañas
local CATEGORIES = {
    {Name = "Shoots", Icon = "⚽"},
    {Name = "Passes", Icon = "↗"},
    {Name = "Dribbling", Icon = "↪"},
    {Name = "Misc", Icon = "⚙"},
    {Name = "Modes", Icon = "$"},
    {Name = "Goalkeeping", Icon = "👐"},
    {Name = "Visuals", Icon = "👁"},
}

-- Función para crear un objeto UICorner (esquinas redondeadas)
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or CORNER_RADIUS)
    corner.Parent = parent
    return corner
end

-- Función para crear la UI principal
local function CreateMainUI()
    -- Eliminar UI existente si existe
    if playerGui:FindFirstChild("FootballUI") then
        playerGui:FindFirstChild("FootballUI"):Destroy()
    end
    
    -- Crear ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FootballUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    -- Crear panel principal (más pequeño y con esquinas redondeadas)
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 500, 0, 350) -- Más pequeño
    mainPanel.Position = UDim2.new(0.5, -250, 0.5, -175) -- Centrado
    mainPanel.BackgroundColor3 = MAIN_COLOR
    mainPanel.BorderSizePixel = 0
    mainPanel.Parent = screenGui
    CreateCorner(mainPanel) -- Esquinas redondeadas
    
    -- Crear barra de título (para arrastrar)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = SECONDARY_COLOR
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainPanel
    CreateCorner(titleBar) -- Esquinas redondeadas
    
    -- Crear título
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = TITLE
    titleText.TextColor3 = TEXT_COLOR
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Botón de cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.Text = "X"
    closeButton.TextColor3 = TEXT_COLOR
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    CreateCorner(closeButton, 15) -- Esquinas muy redondeadas
    
    -- Crear contenedor de pestañas
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(1, -20, 0, 40)
    tabsContainer.Position = UDim2.new(0, 10, 0, 50)
    tabsContainer.BackgroundColor3 = SECONDARY_COLOR
    tabsContainer.BorderSizePixel = 0
    tabsContainer.Parent = mainPanel
    CreateCorner(tabsContainer) -- Esquinas redondeadas
    
    -- Crear contenedor de contenido
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -20, 1, -100)
    contentContainer.Position = UDim2.new(0, 10, 0, 100)
    contentContainer.BackgroundColor3 = SECONDARY_COLOR
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainPanel
    CreateCorner(contentContainer) -- Esquinas redondeadas
    
    -- Contenedores para cada categoría
    local categoryContents = {}
    
    -- Función para seleccionar una categoría
    local function SelectCategory(index)
        -- Actualizar apariencia de pestañas
        for i, tab in ipairs(tabsContainer:GetChildren()) do
            if tab:IsA("TextButton") then
                if i == index then
                    tab.BackgroundColor3 = HIGHLIGHT_COLOR
                    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    tab.BackgroundColor3 = SECONDARY_COLOR
                    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end
        
        -- Mostrar contenedor seleccionado
        for i, container in pairs(categoryContents) do
            container.Visible = (i == index)
        end
    end
    
    -- Crear pestañas y contenido para cada categoría
    for i, category in ipairs(CATEGORIES) do
        -- Crear pestaña
        local tab = Instance.new("TextButton")
        tab.Name = category.Name .. "Tab"
        tab.Size = UDim2.new(1/#CATEGORIES, -5, 1, -10)
        tab.Position = UDim2.new((i-1)/#CATEGORIES, 2.5, 0, 5)
        tab.BackgroundColor3 = i == 1 and HIGHLIGHT_COLOR or SECONDARY_COLOR
        tab.Text = category.Icon .. " " .. category.Name
        tab.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        tab.TextSize = 14
        tab.Font = Enum.Font.Gotham
        tab.Parent = tabsContainer
        CreateCorner(tab) -- Esquinas redondeadas
        
        -- Crear contenedor de contenido para esta categoría
        local content = Instance.new("ScrollingFrame")
        content.Name = category.Name .. "Content"
        content.Size = UDim2.new(1, -20, 1, -20)
        content.Position = UDim2.new(0, 10, 0, 10)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 6
        content.Visible = (i == 1) -- Solo el primero visible por defecto
        content.Parent = contentContainer
        
        -- Ejemplo de contenido para cada pestaña (puedes personalizarlo)
        local exampleLabel = Instance.new("TextLabel")
        exampleLabel.Size = UDim2.new(1, -20, 0, 30)
        exampleLabel.Position = UDim2.new(0, 10, 0, 10)
        exampleLabel.BackgroundColor3 = MAIN_COLOR
        exampleLabel.Text = "Contenido de " .. category.Name
        exampleLabel.TextColor3 = TEXT_COLOR
        exampleLabel.TextSize = 14
        exampleLabel.Font = Enum.Font.Gotham
        exampleLabel.Parent = content
        CreateCorner(exampleLabel) -- Esquinas redondeadas
        
        categoryContents[i] = content
        
        -- Conectar evento de clic
        tab.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
    end
    
    -- Hacer que la UI sea arrastrable
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainPanel.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainPanel.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    -- Conectar botón de cerrar
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)
    
    return screenGui
end

-- Variable para rastrear la UI
local footballUI = nil

-- Función para mostrar/ocultar la UI
local function ToggleUI()
    if footballUI and footballUI.Parent then
        footballUI.Enabled = not footballUI.Enabled
    else
        footballUI = CreateMainUI()
    end
end

-- Conectar tecla para mostrar/ocultar la UI (RightShift)
local connection = nil

-- Función para inicializar la UI
local function Initialize()
    -- Limpiar conexión existente si hay
    if connection then
        connection:Disconnect()
    end
    
    -- Crear nueva conexión
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
            ToggleUI()
        end
    end)
    
    -- Crear la UI inicialmente (oculta)
    footballUI = CreateMainUI()
    footballUI.Enabled = false
end

-- Inicializar cuando el jugador esté listo
if player.Character or player.CharacterAdded:Wait() then
    Initialize()
end

-- Reinicializar si el personaje se vuelve a cargar
player.CharacterAdded:Connect(Initialize)

-- Asegurarse de que la conexión se limpie cuando el script se detenga
script.Destroyed:Connect(function()
    if connection then
        connection:Disconnect()
    end
end)
