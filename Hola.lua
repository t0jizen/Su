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
local MAIN_COLOR = Color3.fromRGB(20, 20, 25) -- Color oscuro para el panel lateral
local SECONDARY_COLOR = Color3.fromRGB(30, 30, 35) -- Color para los botones
local TEXT_COLOR = Color3.fromRGB(255, 255, 255) -- Texto blanco
local HIGHLIGHT_COLOR = Color3.fromRGB(0, 170, 255) -- Azul brillante para selección
local TRANSPARENCY = 0 -- Sin transparencia para mejor visibilidad

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
    
    -- Crear panel lateral
    local sidePanel = Instance.new("Frame")
    sidePanel.Name = "SidePanel"
    sidePanel.Size = UDim2.new(0, 140, 1, 0)
    sidePanel.Position = UDim2.new(0, 0, 0, 0)
    sidePanel.BackgroundColor3 = MAIN_COLOR
    sidePanel.BackgroundTransparency = TRANSPARENCY
    sidePanel.BorderSizePixel = 0
    sidePanel.Parent = screenGui
    
    -- Crear título del panel lateral
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    titleFrame.BackgroundColor3 = MAIN_COLOR
    titleFrame.BackgroundTransparency = TRANSPARENCY
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = sidePanel
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, 0, 1, 0)
    titleText.Position = UDim2.new(0, 0, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = TITLE
    titleText.TextColor3 = TEXT_COLOR
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleFrame
    
    -- Crear contenedor para categorías en el panel lateral
    local categoryContainer = Instance.new("Frame")
    categoryContainer.Name = "CategoryContainer"
    categoryContainer.Size = UDim2.new(1, 0, 1, -40)
    categoryContainer.Position = UDim2.new(0, 0, 0, 40)
    categoryContainer.BackgroundTransparency = 1
    categoryContainer.Parent = sidePanel
    
    -- Crear pestañas superiores
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "TabsFrame"
    tabsFrame.Size = UDim2.new(1, -140, 0, 40)
    tabsFrame.Position = UDim2.new(0, 140, 0, 0)
    tabsFrame.BackgroundColor3 = MAIN_COLOR
    tabsFrame.BackgroundTransparency = TRANSPARENCY
    tabsFrame.BorderSizePixel = 0
    tabsFrame.Parent = screenGui
    
    -- Crear contenedores para cada categoría
    local contentContainers = {}
    
    -- Función para seleccionar una categoría
    local function SelectCategory(index)
        -- Actualizar apariencia de botones en el panel lateral
        for i, button in pairs(categoryContainer:GetChildren()) do
            if button:IsA("Frame") then
                if i == index then
                    button.BackgroundColor3 = HIGHLIGHT_COLOR
                    button.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    button.BackgroundColor3 = MAIN_COLOR
                    button.TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end
        
        -- Actualizar apariencia de pestañas superiores
        for i, tab in pairs(tabsFrame:GetChildren()) do
            if tab:IsA("Frame") then
                if i == index then
                    tab.BackgroundColor3 = HIGHLIGHT_COLOR
                    tab.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    tab.BackgroundColor3 = SECONDARY_COLOR
                    tab.TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
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
        local categoryButton = Instance.new("Frame")
        categoryButton.Name = category.Name .. "Button"
        categoryButton.Size = UDim2.new(1, 0, 0, 30)
        categoryButton.Position = UDim2.new(0, 0, 0, 30 * (i-1) + 10)
        categoryButton.BackgroundColor3 = MAIN_COLOR
        categoryButton.BackgroundTransparency = TRANSPARENCY
        categoryButton.BorderSizePixel = 0
        categoryButton.Parent = categoryContainer
        
        -- Hacer que el botón sea clickeable
        local buttonClick = Instance.new("TextButton")
        buttonClick.Name = "ButtonClick"
        buttonClick.Size = UDim2.new(1, 0, 1, 0)
        buttonClick.Position = UDim2.new(0, 0, 0, 0)
        buttonClick.BackgroundTransparency = 1
        buttonClick.Text = ""
        buttonClick.Parent = categoryButton
        
        -- Texto para el botón
        local buttonText = Instance.new("TextLabel")
        buttonText.Name = "TextLabel"
        buttonText.Size = UDim2.new(1, -30, 1, 0)
        buttonText.Position = UDim2.new(0, 30, 0, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Text = category.Name
        buttonText.TextColor3 = Color3.fromRGB(200, 200, 200)
        buttonText.TextSize = 14
        buttonText.Font = Enum.Font.Gotham
        buttonText.TextXAlignment = Enum.TextXAlignment.Left
        buttonText.Parent = categoryButton
        
        -- Icono para el botón
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Position = UDim2.new(0, 8, 0.5, -8)
        icon.BackgroundTransparency = 1
        icon.Image = category.Icon
        icon.Parent = categoryButton
        
        -- Pestaña superior
        local tab = Instance.new("Frame")
        tab.Name = category.Name .. "Tab"
        tab.Size = UDim2.new(1/#CATEGORIES, 0, 1, 0)
        tab.Position = UDim2.new((i-1)/#CATEGORIES, 0, 0, 0)
        tab.BackgroundColor3 = SECONDARY_COLOR
        tab.BackgroundTransparency = TRANSPARENCY
        tab.BorderSizePixel = 0
        tab.Parent = tabsFrame
        
        -- Hacer que la pestaña sea clickeable
        local tabClick = Instance.new("TextButton")
        tabClick.Name = "TabClick"
        tabClick.Size = UDim2.new(1, 0, 1, 0)
        tabClick.Position = UDim2.new(0, 0, 0, 0)
        tabClick.BackgroundTransparency = 1
        tabClick.Text = ""
        tabClick.Parent = tab
        
        -- Texto para la pestaña
        local tabText = Instance.new("TextLabel")
        tabText.Name = "TextLabel"
        tabText.Size = UDim2.new(1, 0, 1, 0)
        tabText.Position = UDim2.new(0, 0, 0, 0)
        tabText.BackgroundTransparency = 1
        tabText.Text = category.Name
        tabText.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabText.TextSize = 14
        tabText.Font = Enum.Font.Gotham
        tabText.Parent = tab
        
        -- Icono para la pestaña
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 16, 0, 16)
        tabIcon.Position = UDim2.new(0.5, -8, 0, 5)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = category.Icon
        tabIcon.Parent = tab
        
        -- Contenedor de contenido para esta categoría
        local contentContainer = Instance.new("Frame")
        contentContainer.Name = category.Name .. "Content"
        contentContainer.Size = UDim2.new(1, -140, 1, -40)
        contentContainer.Position = UDim2.new(0, 140, 0, 40)
        contentContainer.BackgroundTransparency = 1
        contentContainer.Visible = (i == 1) -- Solo el primero visible por defecto
        contentContainer.Parent = screenGui
        
        contentContainers[i] = contentContainer
        
        -- Conectar eventos de clic
        buttonClick.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
        
        tabClick.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
    end
    
    -- Seleccionar la primera categoría por defecto
    SelectCategory(1)
    
    return screenGui
end

-- Función para mostrar/ocultar la UI
local isUIVisible = true
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

-- Conectar tecla para mostrar/ocultar la UI (RightShift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        ToggleUI()
    end
end)

-- Crear la UI inicialmente
mainUI = CreateMainUI()
mainUI.Enabled = true
