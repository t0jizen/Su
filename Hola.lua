local library = {count = 0, queue = {}, callbacks = {}, rainbowtable = {}, toggled = true, binds = {}}
local defaults;

do
    local dragger = {}
    local players = game:GetService("Players")
    local player = players.LocalPlayer
    local mouse = player:GetMouse()
    local run = game:GetService("RunService")
    local stepped = run.Stepped

    dragger.new = function(obj)
        spawn(function()
            local minitial
            local initial
            local isdragging
            obj.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isdragging = true
                    minitial = input.Position
                    initial = obj.Position
                    local con
                    con = stepped:Connect(function()
                        if isdragging then
                            local delta = Vector3.new(mouse.X, mouse.Y, 0) - minitial
                            obj.Position = UDim2.new(initial.X.Scale, initial.X.Offset + delta.X, initial.Y.Scale, initial.Y.Offset + delta.Y)
                        else
                            con:Disconnect()
                        end
                    end)
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            isdragging = false
                        end
                    end)
                end
            end)
        end)
    end

    function library:Create(class, data)
        local obj = Instance.new(class)
        for i, v in next, data do
            if i ~= "Parent" then
                if typeof(v) == "Instance" then
                    v.Parent = obj
                else
                    obj[i] = v
                end
            end
        end
        obj.Parent = data.Parent
        return obj
    end

    function library:CreateWindow(name, options)
        if not library.container then
            library.container = self:Create("ScreenGui", {
                self:Create("Frame", {
                    Name = "Container",
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 20, 0, 20),
                    BackgroundTransparency = 1,
                    Active = false,
                }),
                Parent = game:GetService("CoreGui"),
            }):FindFirstChild("Container")
        end

        if not library.options then
            library.options = setmetatable(options or {}, {__index = defaults})
        end

        local window = library:Create("Frame", {
            Name = name,
            Size = UDim2.new(0, 220, 0, 35),
            BackgroundColor3 = library.options.bgcolor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, (15 + (230 * library.count) - 230), 0, 0),
            ZIndex = 3,
            Parent = library.container,
        })

        -- 🔹 Bordes Redondeados
        local roundCorner = Instance.new("UICorner")
        roundCorner.CornerRadius = UDim.new(0, 8) -- Bordes más suaves
        roundCorner.Parent = window

        -- 🔹 Efecto de Blur en un Frame adicional
        local blurBackground = library:Create("Frame", {
            Name = "BlurEffect",
            Parent = window,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.3, -- Ajustado para mejor visibilidad
        })

        local blurCorner = Instance.new("UICorner")
        blurCorner.CornerRadius = UDim.new(0, 8)
        blurCorner.Parent = blurBackground

        library:Create("TextLabel", {
            Text = name,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            TextSize = 18,
            TextColor3 = library.options.textcolor,
            TextStrokeTransparency = 0.8,
            TextStrokeColor3 = library.options.strokecolor,
            ZIndex = 3,
            Parent = window,
        })

        local window_toggle = library:Create("TextButton", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -35, 0, 0),
            BackgroundTransparency = 1,
            Text = "-",
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            Name = "window_toggle",
            TextColor3 = library.options.textcolor,
            ZIndex = 3,
            Parent = window,
        })

        local container = library:Create("Frame", {
            Name = "container",
            Position = UDim2.new(0, 0, 1, 0),
            Size = UDim2.new(1, 0, 0, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = library.options.bgcolor,
            ClipsDescendants = true,
            Parent = window,
        })

        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 8)
        containerCorner.Parent = container

        local listLayout = library:Create("UIListLayout", {
            Name = "List",
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = container,
        })

        local function toggleWindow()
            window_toggle.Text = container.ClipsDescendants and "+" or "-"
            local targetSize = container.ClipsDescendants and UDim2.new(1, 0, 0, 5) or UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
            container:TweenSize(targetSize, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true)
            container.ClipsDescendants = not container.ClipsDescendants
        end

        window_toggle.MouseButton1Click:Connect(toggleWindow)

        return window
    end

    defaults = {
        bgcolor = Color3.fromRGB(50, 50, 50),  -- Fondo más oscuro y suave
        textcolor = Color3.fromRGB(255, 255, 255),
        strokecolor = Color3.fromRGB(0, 0, 0),
    }

    library.options = setmetatable({}, {__index = defaults})
end

return library
