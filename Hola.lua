-- Crear el ScreenGui y Frame principal
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(169, 169, 169) -- Gris
frame.BackgroundTransparency = 0.5 -- 50% de transparencia
frame.Parent = screenGui

-- Crear la barra arrastrable (tab) en la parte superior
local dragTab = Instance.new("Frame")
dragTab.Size = UDim2.new(1, 0, 0, 30) -- Barra de arrastre
dragTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rojo brillante
dragTab.Position = UDim2.new(0, 0, 0, 0) -- Barra en la parte superior
dragTab.Parent = frame

-- Crear un texto en la parte arrastrable para mostrar que es interactivo
local dragText = Instance.new("TextLabel")
dragText.Size = UDim2.new(1, 0, 1, 0)
dragText.Text = "Arrástrame"
dragText.TextSize = 20
dragText.TextColor3 = Color3.fromRGB(255, 255, 255) -- Texto blanco
dragText.BackgroundTransparency = 1 -- Sin fondo
dragText.Parent = dragTab

-- Variables para manejar el arrastre
local dragging = false
local dragStart = nil
local startPos = nil

-- Función para comenzar a arrastrar
dragTab.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

-- Función para mover el frame mientras se arrastra
dragTab.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Función para terminar el arrastre
dragTab.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Crear un texto clickeable dentro del frame
local textButton = Instance.new("TextButton")
textButton.Size = UDim2.new(1, 0, 1, 0) -- Rellenar todo el frame
textButton.Text = "Haz clic aquí"
textButton.TextSize = 30
textButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
textButton.BackgroundTransparency = 1 -- Sin fondo
textButton.Parent = frame

-- Evento para manejar el clic en el texto
textButton.MouseButton1Click:Connect(function()
    print("Texto presionado")
end)
