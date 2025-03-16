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
    -- Eliminar UI existente si existe
    if playerGui:FindFirstChild("FootballUI") then
        playerGui:FindFirstChild("FootballUI"):Destroy()
    end
    
    -- Crear ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FootballUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Panel lateral (izquierda)
    local sidePanel = Instance.new("Frame")
    sidePanel.Name = "SidePanel"
    sidePanel.Size = UDim2.new(0, 180, 0, 400)
    sidePanel.Position = UDim2.new(0, 10, 0.5, -200)
    sidePanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    sidePanel.BackgroundTransparency = 0.1
    sidePanel.BorderSizePixel = 0
    sidePanel.Parent = screenGui
    
    -- Esquinas redondeadas para el panel lateral
    local sidePanelCorner = Instance.new("UICorner")
    sidePanelCorner.CornerRadius = UDim.new(0, 5)
    sidePanelCorner.Parent = sidePanel
    
    -- Título del panel lateral
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleFrame.BackgroundTransparency = 0.1
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = sidePanel
    
    -- Esquinas redondeadas para el título
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 5)
    titleCorner.Parent = titleFrame
    
    -- Texto del título
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "FOOTBALL PRO"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleFrame
    
    -- Botón de configuración
    local settingsButton = Instance.new("ImageButton")
    settingsButton.Name = "SettingsButton"
    settingsButton.Size = UDim2.new(0, 20, 0, 20)
    settingsButton.Position = UDim2.new(1, -30, 0.5, -10)
    settingsButton.BackgroundTransparency = 1
    settingsButton.Image = "rbxassetid://3926307971"
    settingsButton.ImageRectOffset = Vector2.new(324, 124)
    settingsButton.ImageRectSize = Vector2.new(36, 36)
    settingsButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.Parent = titleFrame
    
    -- Contenedor para las categorías del panel lateral
    local categoriesContainer = Instance.new("Frame")
    categoriesContainer.Name = "CategoriesContainer"
    categoriesContainer.Size = UDim2.new(1, 0, 1, -40)
    categoriesContainer.Position = UDim2.new(0, 0, 0, 40)
    categoriesContainer.BackgroundTransparency = 1
    categoriesContainer.Parent = sidePanel
    
    -- Barra horizontal de pestañas en la parte superior
    local topTabsFrame = Instance.new("Frame")
    topTabsFrame.Name = "TopTabsFrame"
    topTabsFrame.Size = UDim2.new(1, -200, 0, 40)
    topTabsFrame.Position = UDim2.new(0, 190, 0, 10)
    topTabsFrame.BackgroundTransparency = 1
    topTabsFrame.Parent = screenGui
    
    -- Contenedores para el contenido de cada categoría
    local contentContainers = {}
    
    -- Función para seleccionar una categoría
    local function SelectCategory(index)
        -- Actualizar apariencia de botones laterales
        for i, button in ipairs(categoriesContainer:GetChildren()) do
            if button:IsA("TextButton") then
                if i == index then
                    button.BackgroundTransparency = 0
                    button.TextColor3 = Color3.fromRGB(0, 255, 128)
                else
                    button.BackgroundTransparency = 1
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
        
        -- Actualizar apariencia de pestañas superiores
        for i, tab in ipairs(topTabsFrame:GetChildren()) do
            if tab:IsA("TextButton") then
                if i == index then
                    tab.BackgroundTransparency = 0
                else
                    tab.BackgroundTransparency = 0.5
                end
            end
        end
        
        -- Mostrar solo el contenido seleccionado
        for i, container in pairs(contentContainers) do
            container.Visible = (i == index)
        end
    end
    
    -- Crear botones laterales y pestañas superiores para cada categoría
    for i, category in ipairs(categories) do
        -- Crear botón lateral
        local sideButton = Instance.new("TextButton")
        sideButton.Name = category.Name .. "Button"
        sideButton.Size = UDim2.new(1, 0, 0, 30)
        sideButton.Position = UDim2.new(0, 0, 0, (i-1) * 35)
        sideButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sideButton.BackgroundTransparency = i == 1 and 0 or 1
        sideButton.BorderSizePixel = 0
        sideButton.Text = "  " .. category.Icon .. " " .. category.Name
        sideButton.TextColor3 = i == 1 and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(255, 255, 255)
        sideButton.TextSize = 14
        sideButton.Font = Enum.Font.Gotham
        sideButton.TextXAlignment = Enum.TextXAlignment.Left
        sideButton.Parent = categoriesContainer
        
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
        
        -- Esquinas redondeadas para la pestaña
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
        contentFrame.Visible = (i == 1)
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
        sideButton.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
        
        topTab.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
    end
    
    -- Sección inferior del panel lateral (Friends, Profiles, Targets)
    local lowerSections = {"Friends", "Profiles", "Targets"}
    local lowerContainer = Instance.new("Frame")
    lowerContainer.Name = "LowerContainer"
    lowerContainer.Size = UDim2.new(1, 0, 0, 120)
    lowerContainer.Position = UDim2.new(0, 0, 1, -120)
    lowerContainer.BackgroundTransparency = 1
    lowerContainer.Parent = sidePanel
    
    for i, section in ipairs(lowerSections) do
        local sectionButton = Instance.new("TextButton")
        sectionButton.Name = section .. "Button"
        sectionButton.Size = UDim2.new(1, 0, 0, 30)
        sectionButton.Position = UDim2.new(0, 0, 0, (i-1) * 35)
        sectionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sectionButton.BackgroundTransparency = 1
        sectionButton.BorderSizePixel = 0
        sectionButton.Text = "  " .. section
        sectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        sectionButton.TextSize = 14
        sectionButton.Font = Enum.Font.Gotham
        sectionButton.TextXAlignment = Enum.TextXAlignment.Left
        sectionButton.Parent = lowerContainer
        
        -- Botón de configuración para cada sección
        local sectionSettings = Instance.new("ImageButton")
        sectionSettings.Name = "Settings"
        sectionSettings.Size = UDim2.new(0, 16, 0, 16)
        sectionSettings.Position = UDim2.new(1, -25, 0.5, -8)
        sectionSettings.BackgroundTransparency = 1
        sectionSettings.Image = "rbxassetid://3926307971"
        sectionSettings.ImageRectOffset = Vector2.new(324, 124)
        sectionSettings.ImageRectSize = Vector2.new(36, 36)
        sectionSettings.ImageColor3 = Color3.fromRGB(200, 200, 200)
        sectionSettings.Parent = sectionButton
    end
    
    -- Botones de sección inferior (duplicados como en la imagen)
    local bottomButtons = Instance.new("Frame")
    bottomButtons.Name = "BottomButtons"
    bottomButtons.Size = UDim2.new(0, 180, 0, 120)
    bottomButtons.Position = UDim2.new(0, 10, 1, -130)
    bottomButtons.BackgroundTransparency = 1
    bottomButtons.Parent = screenGui
    
    for i, section in ipairs(lowerSections) do
        local bottomButton = Instance.new("TextButton")
        bottomButton.Name = section .. "BottomButton"
        bottomButton.Size = UDim2.new(1, 0, 0, 30)
        bottomButton.Position = UDim2.new(0, 0, 0, (i-1) * 35)
        bottomButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        bottomButton.BackgroundTransparency = 0.1
        bottomButton.BorderSizePixel = 0
        bottomButton.Text = "  " .. section
        bottomButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        bottomButton.TextSize = 14
        bottomButton.Font = Enum.Font.Gotham
        bottomButton.TextXAlignment = Enum.TextXAlignment.Left
        bottomButton.Parent = bottomButtons
        
        -- Esquinas redondeadas
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 5)
        buttonCorner.Parent = bottomButton
        
        -- Botón de configuración
        local buttonSettings = Instance.new("ImageButton")
        buttonSettings.Name = "Settings"
        buttonSettings.Size = UDim2.new(0, 16, 0, 16)
        buttonSettings.Position = UDim2.new(1, -25, 0.5, -8)
        buttonSettings.BackgroundTransparency = 1
        buttonSettings.Image = "rbxassetid://3926307971"
        buttonSettings.ImageRectOffset = Vector2.new(324, 124)
        buttonSettings.ImageRectSize = Vector2.new(36, 36)
        buttonSettings.ImageColor3 = Color3.fromRGB(200, 200, 200)
        buttonSettings.Parent = bottomButton
    end
    
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
