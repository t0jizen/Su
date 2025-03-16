-- Crear un ScreenGui para mostrar la interfaz
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Crear el Frame que se podrá mover
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(169, 169, 169) -- Gris
frame.BackgroundTransparency = 0.5 -- 50% transparente
frame.Parent = screenGui

-- Variables para controlar el arrastre
local dragging = false
local dragStart = nil
local startPos = nil

-- Conectar la función de arrastre al Frame
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Crear el botón de texto dentro del frame
local textButton = Instance.new("TextButton")
textButton.Size = UDim2.new(1, 0, 1, 0) -- Rellenar todo el Frame
textButton.Text = "Click me"
textButton.TextSize = 30
textButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro
textButton.BackgroundTransparency = 1 -- Sin fondo
textButton.Parent = frame

-- Conectar un evento para el click del botón
textButton.MouseButton1Click:Connect(function()
    print("Texto presionado")
end)
