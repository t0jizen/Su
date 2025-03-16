-- Crear una interfaz simple
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(169, 169, 169) -- Gris
Frame.BackgroundTransparency = 0.5 -- Transparente
Frame.Parent = ScreenGui

-- Función para hacer que el Frame sea arrastrable
local dragging, dragInput, dragStart, startPos
Frame.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Crear un texto presionable
local TextButton = Instance.new("TextButton")
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.Text = "text"
TextButton.TextSize = 24
TextButton.BackgroundTransparency = 1
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Negro
TextButton.Parent = Frame

TextButton.MouseButton1Click:Connect(function()
    print("Text presionado")
end)
