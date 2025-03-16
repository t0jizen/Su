local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/t0jizen/Su/refs/heads/main/Aqua"))()
local run = game:service("RunService");
local runcon;players=game:service("Players");
player=players.LocalPlayer;camera=workspace.CurrentCamera;
local uis=game:service("UserInputService");
local curc;
local mouse=player:GetMouse();
local toggles={abk=Enum.UserInputType.MouseButton2;iag=false;};local traced={};local tsp=Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2 + 400);local gs=game:GetService("GuiService"):GetGuiInset();local sc=Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2);local mousemoverel = mousemoverel or Input.MoveMouse;local hookfunction = hookfunction or detour_function or replaceclosure;local getnamecallmethod=getnamecallmethod or get_namecall_method;

-- Ventanas principales
local shoots = library:CreateWindow('Shoots');
local visuals = library:CreateWindow('Visuals');
local dribbles = library:CreateWindow('Dribbles');
local goalkeeping = library:CreateWindow('Goalkeeping');
local passes = library:CreateWindow('Passes');

-- Configuración de Shoots
shoots:Section('Shooting Mechanics')
shoots:Toggle('Auto Shoot',{location=toggles,flag='autoshoot'});
shoots:Dropdown('Target Area', {location=toggles,flag='tgt', list={"Top Corner","Bottom Corner","Center"}});

-- Configuración de Visuals (sin ESP)
visuals:Section('Visual Enhancements');
visuals:Toggle('Ball Highlight', {location = toggles, flag = "ball_highlight"})
visuals:Toggle('Teammate Glow', {location = toggles, flag = "team_glow"})

-- Configuración de Dribbles
dribbles:Section('Dribble Moves')
dribbles:Toggle('Auto Dribble', {location=toggles,flag='autodribble'});
dribbles:Dropdown('Skill Moves', {location=toggles,flag='skillmove', list={"Step Over","Rainbow Flick","Nutmeg"}});

-- Configuración de Goalkeeping
goalkeeping:Section('Goalkeeper Abilities')
goalkeeping:Toggle('Auto Save', {location=toggles,flag='autosave'});
goalkeeping:Dropdown('Save Direction', {location=toggles,flag='savedir', list={"Left","Right","Center"}});

-- Configuración de Passes
passes:Section('Passing Options')
passes:Toggle('Auto Pass', {location=toggles,flag='autopass'});
passes:Dropdown('Pass Type', {location=toggles,flag='passtype', list={"Ground Pass","Lob Pass","Through Ball"}});

-- Configuración del FOV Circle
shoots:Toggle('Draw FOV circle', {location=toggles, flag='showfov'})
shoots:Toggle('Filled FOV circle', {location=toggles, flag='filled'})
shoots:Slider('FOV', {location=toggles, flag='fov', precise=false, default=50, min=50, max=500});

function createcircle()
    local a=Drawing.new('Circle');a.Transparency=0.3;a.Thickness=1.5;a.Visible=true;a.Color=Color3.fromRGB(0,240,90);a.Filled=false;a.Radius=toggles.fov;
    return a;
end;

curc=createcircle();

run.Stepped:Connect(function()
    spawn(function()
        if toggles.showfov then
            curc.Visible=true;curc.Position = Vector2.new(mouse.X, mouse.Y+gs.Y);curc.Radius=toggles.fov;
        else
            curc.Visible=false;
        end;
    end);
    spawn(function()
        if toggles.filled then
            toggles.showfov = true
            curc.Filled = true
        else
            curc.Filled = false
        end 
    end)
end);

-- Ocultar/Mostrar UI con tecla P
local uiVisible = true
uis.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.P then
        uiVisible = not uiVisible
        for _, window in ipairs({shoots, visuals, dribbles, goalkeeping, passes}) do
            window.object.Visible = uiVisible
        end
    end
end);
