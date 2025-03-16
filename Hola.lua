function types.window(name, options)
    library.count = library.count + 1
    local newWindow = library:Create('Frame', {
        Name = name;
        Size = UDim2.new(0, 190, 0, 30);
        BackgroundColor3 = options.topcolor;
        BorderSizePixel = 0;
        Parent = library.container;
        Position = UDim2.new(0, (15 + (200 * library.count) - 200), 0, 0);
        ZIndex = 3;
    });

    -- 🔹 Bordes redondeados en la ventana
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = newWindow

    -- 🔹 Efecto de Blur en el fondo
    local blurEffect = library:Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0);
        BackgroundColor3 = options.bgcolor;
        BackgroundTransparency = 0.2; -- Ajuste para evitar que desaparezca la UI
        Parent = newWindow;
    });

    local blurCorner = Instance.new("UICorner")
    blurCorner.CornerRadius = UDim.new(0, 8)
    blurCorner.Parent = blurEffect

    library:Create('TextLabel', {
        Text = name;
        Size = UDim2.new(1, -10, 1, 0);
        Position = UDim2.new(0, 5, 0, 0);
        BackgroundTransparency = 1;
        Font = Enum.Font.Gotham;
        TextSize = options.titlesize;
        TextColor3 = options.titletextcolor;
        ZIndex = 3;
        Parent = newWindow;
    });

    local window_toggle = library:Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30);
        Position = UDim2.new(1, -35, 0, 0);
        BackgroundTransparency = 1;
        Text = "-";
        TextSize = options.titlesize;
        Font = options.titlefont;
        Name = "window_toggle";
        TextColor3 = options.titletextcolor;
        ZIndex = 3;
        Parent = newWindow;
    });

    local container = library:Create("Frame", {
        Name = "container";
        Position = UDim2.new(0, 0, 1, 0);
        Size = UDim2.new(1, 0, 0, 0);
        BorderSizePixel = 0;
        BackgroundColor3 = options.bgcolor;
        ClipsDescendants = false;
        Parent = newWindow;
    });

    -- 🔹 Bordes redondeados en el contenedor
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container

    local listLayout = library:Create("UIListLayout", {
        Name = "List";
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = container;
    });

    local function toggleWindow()
        window_toggle.Text = container.ClipsDescendants and "+" or "-";
        local targetSize = container.ClipsDescendants and UDim2.new(1, 0, 0, 5) or UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y + 10);
        container:TweenSize(targetSize, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3, true);
        container.ClipsDescendants = not container.ClipsDescendants;
    end

    window_toggle.MouseButton1Click:Connect(toggleWindow);

    return newWindow;
end
