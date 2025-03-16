-- Librería de UI rediseñada para Roblox con bordes redondeados y efecto blur
local library = {count = 0, queue = {}, callbacks = {}, rainbowtable = {}, toggled = true, binds = {}};
local defaults;

local function applyBlurEffect()
    local blur = Instance.new("BlurEffect")
    blur.Size = 10 -- Ajustar el nivel de desenfoque
    blur.Parent = game.Lighting
end

applyBlurEffect()

do
    local dragger = {};
    do
        local players = game:GetService('Players');
        local player = players.LocalPlayer;
        local mouse = player:GetMouse();
        local run = game:GetService('RunService');
        local stepped = run.Stepped;
        dragger.new = function(obj)
            spawn(function()
                local minitial;
                local initial;
                local isdragging;
                obj.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isdragging = true;
                        minitial = input.Position;
                        initial = obj.Position;
                        local con;
                        con = stepped:Connect(function()
                            if isdragging then
                                local delta = Vector3.new(mouse.X, mouse.Y, 0) - minitial;
                                obj.Position = UDim2.new(initial.X.Scale, initial.X.Offset + delta.X, initial.Y.Scale, initial.Y.Offset + delta.Y);
                            else
                                con:Disconnect();
                            end;
                        end);
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                isdragging = false;
                            end;
                        end);
                    end;
                end);
            end)
        end;
    end
    
    local types = {};
    do
        types.__index = types;
        function types.window(name, options)
            library.count = library.count + 1;
            local newWindow = library:Create('Frame', {
                Name = name;
                Size = UDim2.new(0, 220, 0, 40);
                BackgroundColor3 = options.topcolor;
                BorderSizePixel = 0;
                Parent = library.container;
                Position = UDim2.new(0, (20 + (230 * library.count) - 230), 0, 0);
                ZIndex = 3;
                CornerRadius = UDim.new(0, 10); -- Bordes redondeados
                library:Create('UICorner', {
                    CornerRadius = UDim.new(0, 10);
                });
            });
            
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
            
            return newWindow;
        end
    end
    
    function library:Create(class, data)
        local obj = Instance.new(class);
        for i, v in next, data do
            if i ~= 'Parent' then
                if typeof(v) == "Instance" then
                    v.Parent = obj;
                else
                    obj[i] = v;
                end
            end
        end
        obj.Parent = data.Parent;
        return obj;
    end
    
    function library:CreateWindow(name, options)
        if (not library.container) then
            library.container = self:Create("ScreenGui", {
                self:Create('Frame', {
                    Name = 'Container';
                    Size = UDim2.new(1, -30, 1, 0);
                    Position = UDim2.new(0, 20, 0, 20);
                    BackgroundTransparency = 1;
                    Active = false;
                });
                Parent = game:GetService("CoreGui");
            }):FindFirstChild('Container');
        end
        
        local window = types.window(name, library.options);
        dragger.new(window);
        return window;
    end
    
    default = {
        topcolor       = Color3.fromRGB(40, 40, 40);
        titlecolor     = Color3.fromRGB(255, 255, 255);
        bgcolor        = Color3.fromRGB(45, 45, 45);
        bordercolor    = Color3.fromRGB(80, 80, 80);
        
        font           = Enum.Font.Gotham;
        titlesize      = 20;
        textcolor      = Color3.fromRGB(220, 220, 220);
        titletextcolor = Color3.fromRGB(255, 255, 255);
    };
    
    library.options = setmetatable({}, {__index = default});
end

return library;
