-- Crear la interfaz
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local draggableFrame = Instance.new("Frame")
draggableFrame.Size = UDim2.new(0, 200, 0, 100)  -- Tamaño del panel
draggableFrame.Position = UDim2.new(0.5, -100, 0.5, -50)  -- Posición inicial
draggableFrame.BackgroundColor3 = Color3.fromRGB(128, 128, 128)  -- Color gris
draggableFrame.BackgroundTransparency = 0.4  -- Transparencia (0 es opaco, 1 es completamente transparente)
draggableFrame.Parent = screenGui

-- Crear la funcionalidad arrastrable
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function update(input)
    local delta = input.Position - dragStart
    draggableFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

draggableFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = draggableFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

draggableFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)
