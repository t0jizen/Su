-- FootballUI.lua
-- Script Local para UI de fútbol en Roblox
-- Presiona RightShift para mostrar/ocultar

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales para rastrear el estado
_G.FootballUIVisible = false
_G.FootballUI = nil

-- Función para crear la UI
local function CreateFootballUI()
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
    
    -- Crear panel principal
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 500, 0, 350)
    mainPanel.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainPanel.BorderSizePixel = 0
    mainPanel.Active = true -- Necesario para que sea arrastrable
    mainPanel.Draggable = true -- Hacer arrastrable directamente
    mainPanel.Parent = screenGui
    
    -- Hacer el panel redondeado
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainPanel
    
    -- Crear barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainPanel
    
    -- Hacer la barra de título redondeada
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    -- Título
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "FOOTBALL PRO"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Botón X (cerrar)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    -- Hacer el botón X redondeado
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Contenedor de pestañas
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(1, -20, 0, 40)
    tabsContainer.Position = UDim2.new(0, 10, 0, 50)
    tabsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    tabsContainer.BorderSizePixel = 0
    tabsContainer.Parent = mainPanel
    
    -- Hacer el contenedor de pestañas redondeado
    local tabsCorner = Instance.new("UICorner")
    tabsCorner.CornerRadius = UDim.new(0, 8)
    tabsCorner.Parent = tabsContainer
    
    -- Contenedor de contenido
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -100)
    contentFrame.Position = UDim2.new(0, 10, 0, 100)
    contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainPanel
    
    -- Hacer el contenedor de contenido redondeado
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentFrame
    
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
    
    -- Contenedores de contenido para cada categoría
    local contentContainers = {}
    
    -- Función para seleccionar una categoría
    local function SelectCategory(index)
        -- Actualizar apariencia de pestañas
        for i, tab in ipairs(tabsContainer:GetChildren()) do
            if tab:IsA("TextButton") then
                if i == index then
                    tab.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    tab.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end
        
        -- Mostrar solo el contenido seleccionado
        for i, container in pairs(contentContainers) do
            container.Visible = (i == index)
        end
    end
    
    -- Crear pestañas y contenido
    for i, category in ipairs(categories) do
        -- Crear pestaña
        local tab = Instance.new("TextButton")
        tab.Name = category.Name .. "Tab"
        tab.Size = UDim2.new(1/#categories, -4, 1, -10)
        tab.Position = UDim2.new((i-1)/#categories, 2, 0, 5)
        tab.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 55)
        tab.Text = category.Icon .. " " .. category.Name
        tab.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        tab.TextSize = 14
        tab.Font = Enum.Font.GothamBold
        tab.Parent = tabsContainer
        
        -- Hacer la pestaña redondeada
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tab
        
        -- Crear contenedor para esta categoría
        local container = Instance.new("ScrollingFrame")
        container.Name = category.Name .. "Container"
        container.Size = UDim2.new(1, -20, 1, -20)
        container.Position = UDim2.new(0, 10, 0, 10)
        container.BackgroundTransparency = 1
        container.BorderSizePixel = 0
        container.ScrollBarThickness = 4
        container.Visible = (i == 1) -- Solo el primero visible
        container.Parent = contentFrame
        
        contentContainers[i] = container
        
        -- Añadir algunos elementos de ejemplo
        for j = 1, 5 do
            local button = Instance.new("TextButton")
            button.Name = "Option" .. j
            button.Size = UDim2.new(1, -10, 0, 40)
            button.Position = UDim2.new(0, 5, 0, (j-1) * 45 + 5)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            button.Text = category.Name .. " Option " .. j
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.Parent = container
            
            -- Hacer el botón redondeado
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 6)
            buttonCorner.Parent = button
        end
        
        -- Conectar evento de clic
        tab.MouseButton1Click:Connect(function()
            SelectCategory(i)
        end)
    end
    
    -- Conectar botón de cerrar
    closeButton.MouseButton1Click:Connect(function()
        ToggleFootballUI()
    end)
    
    return screenGui
end

-- Función para mostrar/ocultar la UI
function ToggleFootballUI()
    _G.FootballUIVisible = not _G.FootballUIVisible
    
    if _G.FootballUIVisible then
        if not _G.FootballUI or not _G.FootballUI.Parent then
            _G.FootballUI = CreateFootballUI()
        else
            _G.FootballUI.Enabled = true
        end
    else
        if _G.FootballUI then
            _G.FootballUI.Enabled = false
        end
    end
end

-- Conectar la tecla RightShift
local function OnInputBegan(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        ToggleFootballUI()
    end
end

UserInputService.InputBegan:Connect(OnInputBegan)

-- Mensaje para confirmar que el script se ha cargado
print("FootballUI script loaded. Press RightShift to toggle UI.")
