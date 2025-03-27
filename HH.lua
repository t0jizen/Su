-- NebulaCraft UI Library
-- Una interfaz moderna y personalizable para scripts de Roblox

local NebulaCraft = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ScreenGui = Instance.new("ScreenGui")

-- Configuración principal
NebulaCraft.Settings = {
    MainColor = Color3.fromRGB(32, 32, 32),
    AccentColor = Color3.fromRGB(70, 100, 245),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    ToggleKey = Enum.KeyCode.RightShift,
    TweenSpeed = 0.2,
    Visible = true
}

-- Inicializar la GUI
function NebulaCraft:Init()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game.CoreGui
    end
    
    ScreenGui.Name = "NebulaCraftUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Crear contenedor principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 500, 0, 350)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    self.MainFrame.BackgroundColor3 = self.Settings.MainColor
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = ScreenGui
    
    -- Hacer que el frame sea arrastrable
    self:MakeDraggable(self.MainFrame)
    
    -- Esquinas redondeadas
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = self.MainFrame
    
    -- Barra superior
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = self.Settings.AccentColor
    TopBar.BorderSizePixel = 0
    TopBar.Parent = self.MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 6)
    TopCorner.Parent = TopBar
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "NebulaCraft"
    Title.Font = self.Settings.Font
    Title.TextSize = 18
    Title.TextColor3 = self.Settings.TextColor
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Botón de cerrar
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.Text = "X"
    CloseButton.Font = self.Settings.Font
    CloseButton.TextSize = 14
    CloseButton.TextColor3 = self.Settings.TextColor
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        self = nil
    end)
    
    -- Contenedor de pestañas
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = self.MainFrame
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 6)
    TabContainerCorner.Parent = TabContainer
    
    -- Contenedor para las páginas
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Size = UDim2.new(1, -130, 1, -50)
    PageContainer.Position = UDim2.new(0, 125, 0, 45)
    PageContainer.BackgroundTransparency = 1
    PageContainer.BorderSizePixel = 0
    PageContainer.Parent = self.MainFrame
    
    self.TabContainer = TabContainer
    self.PageContainer = PageContainer
    self.Tabs = {}
    self.ActiveTab = nil
    
    -- Ocultar/mostrar con tecla específica
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == self.Settings.ToggleKey then
            self.Settings.Visible = not self.Settings.Visible
            self.MainFrame.Visible = self.Settings.Visible
        end
    end)
    
    return self
end

-- Hacer un objeto arrastrable
function NebulaCraft:MakeDraggable(frame)
    local dragToggle = nil
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end)
end

-- Crear una nueva pestaña
function NebulaCraft:CreateTab(name, icon)
    local tabIndex = #self.Tabs + 1
    
    -- Botón de la pestaña
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Size = UDim2.new(1, -20, 0, 32)
    TabButton.Position = UDim2.new(0, 10, 0, 10 + ((tabIndex - 1) * 40))
    TabButton.BackgroundColor3 = self.Settings.MainColor
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.Font = self.Settings.Font
    TabButton.TextSize = 14
    TabButton.TextColor3 = self.Settings.TextColor
    TabButton.Parent = self.TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 4)
    TabCorner.Parent = TabButton
    
    -- Contenedor de la página
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name.."Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = self.Settings.AccentColor
    Page.Visible = false
    Page.Parent = self.PageContainer
    
    -- Diseño automático para elementos en la página
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = Page
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.PaddingTop = UDim.new(0, 5)
    UIPadding.PaddingBottom = UDim.new(0, 5)
    UIPadding.Parent = Page
    
    -- Agregar ícono si se proporciona
    if icon then
        local Icon = Instance.new("ImageLabel")
        Icon.Name = "Icon"
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0, 5, 0.5, -10)
        Icon.BackgroundTransparency = 1
        Icon.Image = icon
        Icon.Parent = TabButton
        
        TabButton.Text = "    " .. name
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    -- Almacenar referencia a la pestaña
    local tab = {
        Button = TabButton,
        Page = Page,
        Name = name
    }
    
    self.Tabs[tabIndex] = tab
    
    -- Lógica para cambiar entre pestañas
    TabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    -- Si es la primera pestaña, seleccionarla automáticamente
    if tabIndex == 1 then
        self:SelectTab(tab)
    end
    
    -- Métodos para agregar elementos a la pestaña
    local tabMethods = {}
    
    -- Crear un botón
    function tabMethods:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = text.."Button"
        Button.Size = UDim2.new(1, 0, 0, 32)
        Button.BackgroundColor3 = NebulaCraft.Settings.MainColor
        Button.BorderSizePixel = 0
        Button.Text = text
        Button.Font = NebulaCraft.Settings.Font
        Button.TextSize = 14
        Button.TextColor3 = NebulaCraft.Settings.TextColor
        Button.Parent = Page
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            callback()
        end)
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = NebulaCraft.Settings.AccentColor}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = NebulaCraft.Settings.MainColor}):Play()
        end)
        
        return Button
    end
    
    -- Crear un toggle (interruptor)
    function tabMethods:AddToggle(text, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = text.."Toggle"
        ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
        ToggleFrame.BackgroundColor3 = NebulaCraft.Settings.MainColor
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = Page
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 4)
        ToggleCorner.Parent = ToggleFrame
        
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.Font = NebulaCraft.Settings.Font
        Label.TextSize = 14
        Label.TextColor3 = NebulaCraft.Settings.TextColor
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("Frame")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Parent = ToggleFrame
        
        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
        ToggleButtonCorner.Parent = ToggleButton
        
        local Circle = Instance.new("Frame")
        Circle.Name = "Circle"
        Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.Position = UDim2.new(0, 2, 0.5, -8)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BorderSizePixel = 0
        Circle.Parent = ToggleButton
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = Circle
    local enabled = default or false
        
        -- Actualizar estado visual
        local function updateToggle()
            if enabled then
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = NebulaCraft.Settings.AccentColor}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0.5, -8)}):Play()
            else
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            end
            if callback then
                callback(enabled)
            end
        end
        
        -- Establecer estado inicial
        updateToggle()
        
        -- Conectar eventos
        ToggleFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                enabled = not enabled
                updateToggle()
            end
        end)
        
        -- Métodos para manipular el toggle desde código
        local toggleFunctions = {}
        
        function toggleFunctions:Set(value)
            enabled = value
            updateToggle()
        end
        
        function toggleFunctions:Get()
            return enabled
        end
        
        return toggleFunctions
    end
    
    -- Crear un deslizador
    function tabMethods:AddSlider(text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = text.."Slider"
        SliderFrame.Size = UDim2.new(1, 0, 0, 45)
        SliderFrame.BackgroundColor3 = NebulaCraft.Settings.MainColor
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = Page
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 4)
        SliderCorner.Parent = SliderFrame
        
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(1, -50, 0, 20)
        Label.Position = UDim2.new(0, 10, 0, 5)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.Font = NebulaCraft.Settings.Font
        Label.TextSize = 14
        Label.TextColor3 = NebulaCraft.Settings.TextColor
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = SliderFrame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Name = "ValueLabel"
        ValueLabel.Size = UDim2.new(0, 40, 0, 20)
        ValueLabel.Position = UDim2.new(1, -50, 0, 5)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(default)
        ValueLabel.Font = NebulaCraft.Settings.Font
        ValueLabel.TextSize = 14
        ValueLabel.TextColor3 = NebulaCraft.Settings.TextColor
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame
        
        local SliderBG = Instance.new("Frame")
        SliderBG.Name = "SliderBG"
        SliderBG.Size = UDim2.new(1, -20, 0, 6)
        SliderBG.Position = UDim2.new(0, 10, 0, 30)
        SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SliderBG.BorderSizePixel = 0
        SliderBG.Parent = SliderFrame
        
        local SliderBGCorner = Instance.new("UICorner")
        SliderBGCorner.CornerRadius = UDim.new(1, 0)
        SliderBGCorner.Parent = SliderBG
        
        local Slider = Instance.new("Frame")
        Slider.Name = "Slider"
        local percent = (default - min) / (max - min)
        Slider.Size = UDim2.new(percent, 0, 1, 0)
        Slider.BackgroundColor3 = NebulaCraft.Settings.AccentColor
        Slider.BorderSizePixel = 0
        Slider.Parent = SliderBG
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(1, 0)
        SliderCorner.Parent = Slider
        
        local Circle = Instance.new("Frame")
        Circle.Name = "Circle"
        Circle.Size = UDim2.new(0, 14, 0, 14)
        Circle.Position = UDim2.new(percent, -7, 0.5, -7)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BorderSizePixel = 0
        Circle.Parent = SliderBG
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = Circle
        
        local value = default
        
        local function update(input)
            local sizeX = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            Slider.Size = UDim2.new(sizeX, 0, 1, 0)
            Circle.Position = UDim2.new(sizeX, -7, 0.5, -7)
            
            value = math.floor(min + ((max - min) * sizeX))
            ValueLabel.Text = tostring(value)
            
            if callback then
                callback(value)
            end
        end
        
        SliderBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    update(input)
                end)
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        local sliderFunctions = {}
        
        function sliderFunctions:Set(val)
            val = math.clamp(val, min, max)
            value = val
            local percent = (val - min) / (max - min)
            ValueLabel.Text = tostring(val)
            Slider.Size = UDim2.new(percent, 0, 1, 0)
            Circle.Position = UDim2.new(percent, -7, 0.5, -7)
            
            if callback then
                callback(val)
            end
        end
        
        function sliderFunctions:Get()
            return value
        end
        
        return sliderFunctions
    end
    
    -- Crear un selector de opciones (dropdown)
    function tabMethods:AddDropdown(text, options, default, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = text.."Dropdown"
        DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
        DropdownFrame.BackgroundColor3 = NebulaCraft.Settings.MainColor
        DropdownFrame.BorderSizePixel = 0
        DropdownFrame.ClipsDescendants = true
        DropdownFrame.Parent = Page
        
        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 4)
        DropdownCorner.Parent = DropdownFrame
        
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(1, -10, 0, 32)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. (default or options[1])
        Label.Font = NebulaCraft.Settings.Font
        Label.TextSize = 14
        Label.TextColor3 = NebulaCraft.Settings.TextColor
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = DropdownFrame
        
        local ArrowButton = Instance.new("TextButton")
        ArrowButton.Name = "ArrowButton"
        ArrowButton.Size = UDim2.new(0, 32, 0, 32)
        ArrowButton.Position = UDim2.new(1, -32, 0, 0)
        ArrowButton.BackgroundTransparency = 1
        ArrowButton.Text = "▼"
        ArrowButton.Font = NebulaCraft.Settings.Font
        ArrowButton.TextSize = 14
        ArrowButton.TextColor3 = NebulaCraft.Settings.TextColor
        ArrowButton.Parent = DropdownFrame
        
        local OptionsFrame = Instance.new("Frame")
        OptionsFrame.Name = "OptionsFrame"
        OptionsFrame.Size = UDim2.new(1, -20, 0, #options * 30)
        OptionsFrame.Position = UDim2.new(0, 10, 0, 40)
        OptionsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        OptionsFrame.BorderSizePixel = 0
        OptionsFrame.Visible = false
        OptionsFrame.Parent = DropdownFrame
        
        local OptionsCorner = Instance.new("UICorner")
        OptionsCorner.CornerRadius = UDim.new(0, 4)
        OptionsCorner.Parent = OptionsFrame
        
        local currentSelected = default or options[1]
        local isOpen = false
        
        -- Ajustar tamaño del dropdown cuando se abre/cierra
        local function updateDropdown()
            if isOpen then
                DropdownFrame.Size = UDim2.new(1, 0, 0, 42 + (#options * 30))
                OptionsFrame.Visible = true
                ArrowButton.Text = "▲"
            else
                DropdownFrame.Size = UDim2.new(1, 0, 0, 32)
                OptionsFrame.Visible = false
                ArrowButton.Text = "▼"
            end
        end
        
        ArrowButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            updateDropdown()
        end)
        
        -- Crear opciones
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option.."Option"
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            OptionButton.BackgroundTransparency = 1
            OptionButton.Text = option
            OptionButton.Font = NebulaCraft.Settings.Font
            OptionButton.TextSize = 14
            OptionButton.TextColor3 = NebulaCraft.Settings.TextColor
            OptionButton.Parent = OptionsFrame
            
            OptionButton.MouseButton1Click:Connect(function()
                currentSelected = option
                Label.Text = text .. ": " .. option
                isOpen = false
                updateDropdown()
                
                if callback then
                    callback(option)
                end
            end)
            
            OptionButton.MouseEnter:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, BackgroundColor3 = NebulaCraft.Settings.AccentColor}):Play()
            end)
            
            OptionButton.MouseLeave:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end)
        end
        
        local dropdownFunctions = {}
        
        function dropdownFunctions:Set(option)
            if table.find(options, option) then
                currentSelected = option
                Label.Text = text .. ": " .. option
                
                if callback then
                    callback(option)
                end
            end
        end
        
        function dropdownFunctions:Get()
            return currentSelected
        end
        
        return dropdownFunctions
    end
    
    -- Añadir etiqueta
    function tabMethods:AddLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(1, 0, 0, 25)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.Font = NebulaCraft.Settings.Font
        Label.TextSize = 14
        Label.TextColor3 = NebulaCraft.Settings.TextColor
        Label.Parent = Page
        
        return Label
    end
    
    -- Añadir separador
    function tabMethods:AddSeparator()
        local Separator = Instance.new("Frame")
        Separator.Name = "Separator"
        Separator.Size = UDim2.new(1, -20, 0, 1)
        Separator.Position = UDim2.new(0, 10, 0, 0)
        Separator.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Separator.BorderSizePixel = 0
        Separator.Parent = Page
        
        return Separator
    end
    
    -- Añadir caja de texto
    function tabMethods:AddTextbox(text, placeholder, callback)
        local TextboxFrame = Instance.new("Frame")
        TextboxFrame.Name = text.."TextboxFrame"
        TextboxFrame.Size = UDim2.new(1, 0, 0, 32)
        TextboxFrame.BackgroundColor3 = NebulaCraft.Settings.MainColor
        TextboxFrame.BorderSizePixel = 0
        TextboxFrame.Parent = Page
        
        local TextboxCorner = Instance.new("UICorner")
        TextboxCorner.CornerRadius = UDim.new(0, 4)
        TextboxCorner.Parent = TextboxFrame
        
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Size = UDim2.new(0.4, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.Font = NebulaCraft.Settings.Font
        Label.TextSize = 14
        Label.TextColor3 = NebulaCraft.Settings.TextColor
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = TextboxFrame
        
        local Textbox = Instance.new("TextBox")
        Textbox.Name = "Textbox"
        Textbox.Size = UDim2.new(0.5, -20, 0, 22)
        Textbox.Position = UDim2.new(0.5, 0, 0.5, -11)
        Textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Textbox.BorderSizePixel = 0
        Textbox.PlaceholderText = placeholder or "Escribir aquí..."
        Textbox.Text = ""
        Textbox.Font = NebulaCraft.Settings.Font
        Textbox.TextSize = 14
        Textbox.TextColor3 = NebulaCraft.Settings.TextColor
        Textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        Textbox.Parent = TextboxFrame
        
        local TextboxCorner = Instance.new("UICorner")
        TextboxCorner.CornerRadius = UDim.new(0, 4)
        TextboxCorner.Parent = Textbox
        
        Textbox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                callback(Textbox.Text)
            end
        end)
        
        local textboxFunctions = {}
        
        function textboxFunctions:GetText()
            return Textbox.Text
        end
        
        function textboxFunctions:SetText(text)
            Textbox.Text = text
        end
        
        return textboxFunctions
    end
    
    -- Añadir una sección colapsable
    function tabMethods:AddSection(title)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = title.."Section"
        SectionFrame.Size = UDim2.new(1, 0, 0, 30)
        SectionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        SectionFrame.BorderSizePixel = 0
        SectionFrame.ClipsDescendants = true
        SectionFrame.Parent = Page
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 4)
        SectionCorner.Parent = SectionFrame
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "TitleLabel"
        TitleLabel.Size = UDim2.new(1, -40, 0, 30)
        TitleLabel.Position = UDim2.new(0, 10, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.Font = NebulaCraft.Settings.Font
        TitleLabel.TextSize = 15
        TitleLabel.TextColor3 = NebulaCraft.Settings.TextColor
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = SectionFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(0, 30, 0, 30)
        ToggleButton.Position = UDim2.new(1, -30, 0, 0)
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.Text = "+"
        ToggleButton.Font = NebulaCraft.Settings.Font
        ToggleButton.TextSize = 20
        ToggleButton.TextColor3 = NebulaCraft.Settings.TextColor
        ToggleButton.Parent = SectionFrame
        
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = "ContentFrame"
        ContentFrame.Size = UDim2.new(1, -20, 0, 0)
        ContentFrame.Position = UDim2.new(0, 10, 0, 35)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Parent = SectionFrame
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 8)
        UIListLayout.Parent = ContentFrame
        
        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if ContentFrame.Visible then
                SectionFrame.Size = UDim2.new(1, 0, 0, 40 + UIListLayout.AbsoluteContentSize.Y)
            end
        end)
        
        local isExpanded = false
        ContentFrame.Visible = false
        
        ToggleButton.MouseButton1Click:Connect(function()
            isExpanded = not isExpanded
            
            if isExpanded then
                ToggleButton.Text = "-"
                ContentFrame.Visible = true
                SectionFrame.Size = UDim2.new(1, 0, 0, 40 + UIListLayout.AbsoluteContentSize.Y)
            else
                ToggleButton.Text = "+"
                ContentFrame.Visible = false
                SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            end
        end)
        
        local sectionMethods = {}
        
        function sectionMethods:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text.."Button"
            Button.Size = UDim2.new(1, 0, 0, 30)
            Button.BackgroundColor3 = NebulaCraft.Settings.MainColor
            Button.BorderSizePixel = 0
            Button.Text = text
            Button.Font = NebulaCraft.Settings.Font
            Button.TextSize = 14
            Button.TextColor3 = NebulaCraft.Settings.TextColor
            Button.Parent = ContentFrame
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = NebulaCraft.Settings.AccentColor}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = NebulaCraft.Settings.MainColor}):Play()
            end)
            
            return Button
        end
        
        function sectionMethods:AddToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text.."Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
            ToggleFrame.BackgroundColor3 = NebulaCraft.Settings.MainColor
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = ContentFrame
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Parent = ToggleFrame
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.Font = NebulaCraft.Settings.Font
            Label.TextSize = 14
            Label.TextColor3 = NebulaCraft.Settings.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local Circle = Instance.new("Frame")
            Circle.Name = "Circle"
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.BorderSizePixel = 0
            Circle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle
            
            local enabled = default or false
            
            local function updateToggle()
                if enabled then
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = NebulaCraft.Settings.AccentColor}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0.5, -8)}):Play()
                else
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                end
                if callback then
                    callback(enabled)
                end
            end
            
            updateToggle()
            
            ToggleFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    enabled = not enabled
                    updateToggle()
                end
            end)
            
            local toggleFunctions = {}
            
            function toggleFunctions:Set(value)
                enabled = value
                updateToggle()
            end
            
            function toggleFunctions:Get()
                return enabled
            end
            
            return toggleFunctions
        end
        
        -- Puedes agregar más elementos a la sección según sea necesario...
        
        return sectionMethods
    end
    
    return tabMethods
end

-- Cambiar entre pestañas
function NebulaCraft:SelectTab(tab)
    if self.ActiveTab then
        -- Desactivar la pestaña anterior
        TweenService:Create(self.ActiveTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Settings.MainColor}):Play()
        self.ActiveTab.Page.Visible = false
    end
    
    -- Activar la nueva pestaña
    TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundColor3 = self.Settings.AccentColor}):Play()
    tab.Page.Visible = true
    self.ActiveTab = tab
end

-- Personalizar la apariencia
function NebulaCraft:SetTheme(theme)
    if type(theme) == "table" then
        for key, value in pairs(theme) do
            if self.Settings[key] ~= nil then
                self.Settings[key] = value
            end
        end
        
        -- Actualizar elementos existentes
        if self.MainFrame then
            self.MainFrame.BackgroundColor3 = self.Settings.MainColor
            
            -- Actualizar barra superior
            if self.MainFrame:FindFirstChild("TopBar") then
                self.MainFrame.TopBar.BackgroundColor3 = self.Settings.AccentColor
            end
            
            -- Actualizar contenedor de pestañas
            if self.TabContainer then
                for _, tab in pairs(self.Tabs) do
                    if tab == self.ActiveTab then
                        tab.Button.BackgroundColor3 = self.Settings.AccentColor
                    else
                        tab.Button.BackgroundColor3 = self.Settings.MainColor
                    end
                    tab.Button.TextColor3 = self.Settings.TextColor
                end
            end
        end
    end
end

-- Notificación en pantalla
function NebulaCraft:Notify(title, message, duration)
    duration = duration or 3
    
    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Name = "Notification"
    NotifyFrame.Size = UDim2.new(0, 250, 0, 80)
    NotifyFrame.Position = UDim2.new(1, -260, 0, 10)
    NotifyFrame.BackgroundColor3 = self.Settings.MainColor
    NotifyFrame.BorderSizePixel = 0
    NotifyFrame.Parent = ScreenGui
    
    local NotifyCorner = Instance.new("UICorner")
    NotifyCorner.CornerRadius = UDim.new(0, 6)
    NotifyCorner.Parent = NotifyFrame
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 28)
    TitleBar.BackgroundColor3 = self.Settings.AccentColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = NotifyFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 6)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.Font = self.Settings.Font
    TitleLabel.TextSize = 15
    TitleLabel.TextColor3 = self.Settings.TextColor
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Message"
    MessageLabel.Size = UDim2.new(1, -20, 0, 42)
    MessageLabel.Position = UDim2.new(0, 10, 0, 33)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = message
    MessageLabel.Font = self.Settings.Font
    MessageLabel.TextSize = 14
    MessageLabel.TextColor3 = self.Settings.TextColor
    MessageLabel.TextWrapped = true
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.Parent = NotifyFrame
    
    -- Animación de entrada
    NotifyFrame.Position = UDim2.new(1, 0, 0, 10)
    TweenService:Create(NotifyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -260, 0, 10)}):Play()
    
    -- Autodestrucción después de la duración
    task.delay(duration, function()
        local fadeTween = TweenService:Create(NotifyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 0, 0, 10)})
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            NotifyFrame:Destroy()
        end)
    end)
end

return NebulaCraft
