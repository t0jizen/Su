-- FootballUI.lua
-- UI simple para un juego de fútbol en Roblox

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local uiVisible = false
local mainGui = nil

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
    
    -- Panel principal (ventana compacta)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas para el panel
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 6)
    mainCorner.Parent = mainFrame
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    -- Esquinas redondeadas para la barra de título
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 6)
    titleCorner.Parent = titleBar
    
    -- Título
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "FOOTBALL PRO"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Botón X (cerrar)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -27, 0, 3)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    -- Esquinas redondeadas para el botón X
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    -- Categorías
    local categories = {
        {Name = "Shoots", Icon = "⚽"},
        {Name = "Passes", Icon = "↗"},
        {Name = "Dribbling", Icon = "↪"},
        {Name = "Misc", Icon = "⚙"},
        {Name = "Modes", Icon = "$"},
        {Name = "Goalkeeping", Icon = "👐"},
        {Name = "Visuals", Icon = "👁"},
    }
    
    -- Contenedor de contenido
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    -- Esquinas redondeadas para el contenedor de contenido
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 6)
    contentCorner.Parent = contentFrame
    
    -- Contenedores para cada categoría
    local categoryContainers = {}
    
    -- Función para seleccionar una categoría
    local function SelectCategory(index)
        -- Actualizar apariencia de pestañas
        for i, tab in pairs(mainFrame:GetChildren()) do
            if tab:IsA("TextButton") and tab.Name:find("Tab") then
                local tabIndex = tonumber(tab.Name:match("Tab(%d+)"))
                if tabIndex == index then
                    tab.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end
        
        -- Mostrar solo el contenido seleccionado
        for i, container in pairs(categoryContainers) do
            container.Visible = (i == index)
        end
    end
    
    -- Crear pestañas
    for i, category in ipairs(categories) do
        -- Crear pestaña
        local tab = Instance.new("TextButton")
        tab.Name = "Tab" .. i
        tab.Size = UDim2.new(1/#categories, -2, 0, 24)
        tab.Position = UDim2.new((i-1)/#categories, 1, 0, 32)
        tab.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 40)
        tab.Text = category.Name
        tab.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        tab.TextSize = 12
        tab.Font = Enum.Font.GothamSemibold
        tab.Parent = mainFrame
        
        -- Esquinas redondeadas para la pestaña
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4)
        tabCorner.Parent = tab
        
        -- Crear contenedor para esta categoría
        local container = Instance.new("ScrollingFrame")
        container.Name = category.Name .. "Container"
        container.Size = UDim2.new(1, -10, 1, -10)
        container.Position = UDim2.new(0, 5, 0, 5)
        container.BackgroundTransparency = 1
        container.BorderSizePixel = 0
        container.ScrollBarThickness = 4
        container.Visible = (i == 1) -- Solo el primero visible
        container.Parent = contentFrame
        
        categoryContainers[i] = container
        
        -- Añadir opciones para esta categoría
        for j = 1, 5 do
            local option = Instance.new("TextButton")
            option.Name = "Option" .. j
            option.Size = UDim2.new(1, -10, 0, 30)
            option.Position = UDim2.new(0, 5, 0, (j-1) * 35 + 5)
            option.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            option.Text = category.Name .. " Option " .. j
            option.TextColor3 = Color3.fromRGB(255, 255, 255)
            option.TextSize = 14
            option.Font = Enum.Font.Gotham
            option.Parent = container
            
            -- Esquinas redondeadas para la opción
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 4)
            optionCorner.Parent = option
        end
        
        -- Conectar evento de clic
        tab.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
    end
    
    -- Conectar botón de cerrar
    closeButton.MouseButton1Click:Connect(function()
        ToggleUI()
    end)
    
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

-- Mensaje para confirmar que el script se ha cargado
print("FootballUI script loaded. Press P to toggle UI.")
