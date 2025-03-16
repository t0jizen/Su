-- FootballUI.lua
-- UI para un juego de fútbol en Roblox

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuración principal
local TITLE = "FOOTBALL PRO"
local BACKGROUND_COLOR = Color3.fromRGB(0, 150, 255) -- Color azul para fútbol
local MAIN_COLOR = Color3.fromRGB(35, 35, 35)
local SECONDARY_COLOR = Color3.fromRGB(25, 25, 25)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local HIGHLIGHT_COLOR = Color3.fromRGB(0, 200, 255)
local TRANSPARENCY = 0.1

-- Categorías para el menú lateral y pestañas superiores
local CATEGORIES = {
    {Name = "Shoots", Icon = "rbxassetid://7072707179"}, -- Icono de balón
    {Name = "Passes", Icon = "rbxassetid://7072706318"}, -- Icono de pase
    {Name = "Dribbling", Icon = "rbxassetid://7072706896"}, -- Icono de dribling
    {Name = "Misc", Icon = "rbxassetid://7072706674"}, -- Icono de configuración
    {Name = "Modes", Icon = "rbxassetid://7072715646"}, -- Icono de modos
    {Name = "Goalkeeping", Icon = "rbxassetid://7072724538"}, -- Icono de portero
    {Name = "Visuals", Icon = "rbxassetid://7072706763"}, -- Icono de visuales
}

-- Crear la interfaz principal
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
    
    -- Crear fondo principal
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = BACKGROUND_COLOR
    background.BackgroundTransparency = 0.2
    background.Parent = screenGui
    
    -- Crear panel lateral
    local sidePanel = Instance.new("Frame")
    sidePanel.Name = "SidePanel"
    sidePanel.Size = UDim2.new(0, 180, 1, 0)
    sidePanel.Position = UDim2.new(0, 0, 0, 0)
    sidePanel.BackgroundColor3 = MAIN_COLOR
    sidePanel.BackgroundTransparency = TRANSPARENCY
    sidePanel.Parent = screenGui
    
    -- Crear título del panel lateral
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(1, 0, 0, 50)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    titleFrame.BackgroundColor3 = SECONDARY_COLOR
    titleFrame.BackgroundTransparency = TRANSPARENCY
    titleFrame.Parent = sidePanel
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(0.8, 0, 1, 0)
    titleText.Position = UDim2.new(0.1, 0, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = TITLE
    titleText.TextColor3 = TEXT_COLOR
    titleText.TextSize = 24
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleFrame
    
    local settingsButton = Instance.new("ImageButton")
    settingsButton.Name = "SettingsButton"
    settingsButton.Size = UDim2.new(0, 20, 0, 20)
    settingsButton.Position = UDim2.new(0.9, 0, 0.5, -10)
    settingsButton.BackgroundTransparency = 1
    settingsButton.Image = "rbxassetid://7059346373" -- Icono de configuración
    settingsButton.Parent = titleFrame
    
    -- Crear contenedor para categorías en el panel lateral
    local categoryContainer = Instance.new("ScrollingFrame")
    categoryContainer.Name = "CategoryContainer"
    categoryContainer.Size = UDim2.new(1, 0, 0.9, -50)
    categoryContainer.Position = UDim2.new(0, 0, 0, 50)
    categoryContainer.BackgroundTransparency = 1
    categoryContainer.ScrollBarThickness = 0
    categoryContainer.CanvasSize = UDim2.new(0, 0, 0, #CATEGORIES * 40)
    categoryContainer.Parent = sidePanel
    
    -- Crear pestañas superiores
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "TabsFrame"
    tabsFrame.Size = UDim2.new(1, -180, 0, 50)
    tabsFrame.Position = UDim2.new(0, 180, 0, 0)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Parent = screenGui
    
    -- Crear contenedores para cada categoría
    local contentContainers = {}
    
    -- Función para seleccionar una categoría
    local function SelectCategory(index)
        -- Actualizar apariencia de botones en el panel lateral
        for i, button in pairs(categoryContainer:GetChildren()) do
            if button:IsA("TextButton") then
                if i == index then
                    button.BackgroundColor3 = HIGHLIGHT_COLOR
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    button.BackgroundColor3 = SECONDARY_COLOR
                    button.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end
        
        -- Actualizar apariencia de pestañas superiores
        for i, tab in pairs(tabsFrame:GetChildren()) do
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
        for i, container in pairs(contentContainers) do
            container.Visible = (i == index)
        end
    end
    
    -- Crear botones de categoría en el panel lateral y pestañas superiores
    for i, category in ipairs(CATEGORIES) do
        -- Botón en el panel lateral
        local categoryButton = Instance.new("TextButton")
        categoryButton.Name = category.Name .. "Button"
        categoryButton.Size = UDim2.new(0.9, 0, 0, 35)
        categoryButton.Position = UDim2.new(0.05, 0, 0, (i-1) * 40 + 5)
        categoryButton.BackgroundColor3 = SECONDARY_COLOR
        categoryButton.BackgroundTransparency = TRANSPARENCY
        categoryButton.Text = "  " .. category.Name
        categoryButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        categoryButton.TextSize = 16
        categoryButton.Font = Enum.Font.Gotham
        categoryButton.TextXAlignment = Enum.TextXAlignment.Left
        categoryButton.Parent = categoryContainer
        
        -- Icono para el botón
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 5, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.Image = category.Icon
        icon.Parent = categoryButton
        
        -- Pestaña superior
        local tab = Instance.new("TextButton")
        tab.Name = category.Name .. "Tab"
        tab.Size = UDim2.new(1/#CATEGORIES, -10, 1, -10)
        tab.Position = UDim2.new((i-1)/#CATEGORIES, 5, 0, 5)
        tab.BackgroundColor3 = SECONDARY_COLOR
        tab.BackgroundTransparency = TRANSPARENCY
        tab.Text = category.Name
        tab.TextColor3 = Color3.fromRGB(200, 200, 200)
        tab.TextSize = 14
        tab.Font = Enum.Font.Gotham
        tab.Parent = tabsFrame
        
        -- Icono para la pestaña
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 16, 0, 16)
        tabIcon.Position = UDim2.new(0, 5, 0.5, -8)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = category.Icon
        tabIcon.Parent = tab
        
        -- Contenedor de contenido para esta categoría
        local contentContainer = Instance.new("Frame")
        contentContainer.Name = category.Name .. "Content"
        contentContainer.Size = UDim2.new(1, -180, 1, -50)
        contentContainer.Position = UDim2.new(0, 180, 0, 50)
        contentContainer.BackgroundTransparency = 1
        contentContainer.Visible = (i == 1) -- Solo el primero visible por defecto
        contentContainer.Parent = screenGui
        
        contentContainers[i] = contentContainer
        
        -- Conectar eventos de clic
        categoryButton.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
        
        tab.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
    end
    
    -- Seleccionar la primera categoría por defecto
    SelectCategory(1)
    
    -- Hacer que la UI sea arrastrable desde el título
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = sidePanel.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            sidePanel.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    -- Botón para cerrar/abrir el menú
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.BackgroundColor3 = MAIN_COLOR
    toggleButton.BackgroundTransparency = TRANSPARENCY
    toggleButton.Text = "X"
    toggleButton.TextColor3 = TEXT_COLOR
    toggleButton.TextSize = 18
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Visible = false
    toggleButton.Parent = screenGui
    
    local isMenuOpen = true
    
    toggleButton.MouseButton1Click:Connect(function()
        isMenuOpen = not isMenuOpen
        
        if isMenuOpen then
            sidePanel.Visible = true
            toggleButton.Visible = false
        else
            sidePanel.Visible = false
            toggleButton.Visible = true
        end
    end)
    
    return screenGui
end

-- Función para mostrar/ocultar la UI
local isUIVisible = false
local mainUI = nil

local function ToggleUI()
    isUIVisible = not isUIVisible
    
    if isUIVisible then
        if not mainUI or not mainUI.Parent then
            mainUI = CreateMainUI()
        end
        mainUI.Enabled = true
    else
        if mainUI then
            mainUI.Enabled = false
        end
    end
end

-- Conectar tecla para mostrar/ocultar la UI (por defecto: RightControl)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        ToggleUI()
    end
end)

-- Crear la UI inicialmente (opcional, comentar si quieres que empiece oculta)
mainUI = CreateMainUI()
mainUI.Enabled = true
