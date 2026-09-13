-- this is a deobfuscated version (this source is very old)
local r24 = loadstring(v1.HttpGet(v1, "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))();
local v2 = game;
local r25 = loadstring(v2.HttpGet(v2, "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))();
local v3 = game;
local v4 = loadstring(v3.HttpGet(v3, "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))();
local v5 = game;

local r26 = v5.GetService(v5, "Players");
local v6 = game;
local r27 = v6.GetService(v6, "ReplicatedStorage");
local v7 = game;
local r28 = v7.GetService(v7, "Workspace");
local v8 = game;
local r29 = v8.GetService(v8, "RunService");
local v9 = game;
local r30 = v9.GetService(v9, "UserInputService");
local v10 = game;
local r31 = v10.GetService(v10, "CoreGui");
local v11 = game;

v11.GetService(v11, "HttpService");

local v12 = game;

v12.GetService(v12, "Stats");

local v13 = game;
local r32 = v13.GetService(v13, "SoundService");
local v14 = game;
local r33 = v14.GetService(v14, "TweenService");

local function v15(arg1_2, arg2_2, ...)
    return (arg1_2 - arg2_2).Magnitude; 
end;

local r34 = r26.LocalPlayer;
local r35 = {};
local r36 = false;
local r37 = {};

local function v16(arg1_3, ...)
    r38 = arg1_3;
    
    if r38 and r38.Parent then
        pcall(function(...)
            n = r38;
            
            n.Destroy(n);
            
            return; 
        end);
    end;
    
    return; 
end;

local r39 = {};

r39.GetCharacter = function(...)
    return r34.Character; 
end;
r39.GetHumanoid = function(arg1_4, ...)
    d = arg1_4;
    
    if d then
        
        k = d.FindFirstChildOfClass(d, "Humanoid");
    end;
    
    return d; 
end;
r39.GetRootPart = function(arg1_5, ...)
    d = arg1_5;
    
    if d then
        
        k = d.FindFirstChild(d, "HumanoidRootPart");
    end;
    
    return d; 
end;
r39.IsUnsupportedExecutor = function(...)
    if identifyexecutor and type(identifyexecutor) == "function" then
        
        k = identifyexecutor();
        
        d = k.lower(k);
        j = "Madium";
        G = j[3];
        j = j[1];
        
        for G, N in j, ipairs({
            "ronix",
            "codex",
            "fluxus",
            "solara",
            j
        }) do
            u = G;
            
            if d.find(d, N) then
                return true;
            else
                
            end; 
        end;
    end;
    
    return false; 
end;
r39.IsXenoExecutor = function(...)
    if identifyexecutor and type(identifyexecutor) == "function" then
        
        k = identifyexecutor();
        
        n = k.lower(k);
        
        if n.find(n, "xeno") or n.find(n, "x3no") then
            return true;
        end;
    end;
    
    return false; 
end;
r39.IsFeatureSupported = function(arg1_6, ...)
    
    j = r16("\xf1k\xef\xfe\xce\xc4@\xb4\x9e\xd5\x81Y\xf3Y", 18566512124357);
    
    if r39[r15[j]]() then
        j = r15;
        G = j[3];
        j = j[1];
        
        for G, N in j, ipairs({
            "AutoDodge",
            "FreeGuard",
            "AutoQTE",
            "Desync"
        }) do
            u = G;
            
            if N == arg1_6 then
                return false;
            else
                
            end; 
        end;
    end;
    
    return true; 
end;
r39.UpdateToggleAvailability = function(arg1_7, arg2_7, arg3_7, ...)
    n = false;
    r40 = arg3_7;
    v = arg2_7;
    
    if v then
        n = r28;
        
        j = n.FindFirstChild(n, "Values");
        
        if j then
            
            u = j.FindFirstChild(j, "CurrentGame");
            
            if u then
                k = u.Value == v;
            end;
            
            G = u;
        end;
    else
        G = true;
    end;
    
    n = n;
    
    if r40 and r40.SetDisabled then
        C = 40;
        N = N;
        n = N;
        r41 = not n and v ~= nil or not r39.IsFeatureSupported(arg1_7);
        
        pcall(function(...)
            n = r40;
            
            n.SetDisabled(n, r41);
            
            return; 
        end);
        
        n = N;
        
        if r40.Value == true and (not n and v ~= nil) then
            pcall(function(...)
                n = r40;
                
                n.SetValue(n, false);
                
                return; 
            end);
        end;
    end;
    
    return; 
end;
r39.Notify = function(arg1_8, arg2_8, arg3_8, ...)
    n = r36;
    v = arg2_8;
    d = arg1_8;
    B = arg3_8;
    
    if n then
        n = r24;
        C = n;
        
        n.Notify(n, {
            ["Title"] = d,
            ["Description"] = v,
            ["Duration"] = B or 2
        });
    else
        x = n;
        
        table.insert(r37, {
            ["title"] = d,
            ["text"] = v,
            ["duration"] = B or 2
        });
    end;
    
    return; 
end;
r39.PlayBell = function(...)
    
    r42 = Instance.new("Sound");
    
    r42.SoundId = "rbxassetid://6518811702";
    r42.Volume = 1;
    r42.Parent = r32;
    
    n = r42;
    
    n.Play(n);
    
    n = r42.Ended;
    
    n.Connect(n, function(...)
        n = r42;
        
        n.Destroy(n);
        
        return; 
    end);
    
    return; 
end;
r39.TrailEnabled = false;
r39.TrailConnection = nil;
r39.ToggleFootstepTrail = function(arg1_9, ...)
    d = arg1_9;
    v = arg1_9;
    
    r39.TrailEnabled = v;
    
    if r39.TrailConnection then
        n = r39.TrailConnection;
        
        n.Disconnect(n);
        
        r39.TrailConnection = nil;
    end;
    
    v = r34.Character;
    
    if v then
        u = "\x17\x14\x03\n\xf3\xc4\xd0\xab4\xa5\xda\xcd\xcb\xb7\xd7\xda";
        N = 22405853079745;
        
        B = v.FindFirstChild(v, r15[r16(u, N)]);
        
        if B then
            N = B.GetChildren;
            u = {
                N(B)
            };
            G = N[2];
            u = N[1];
            
            for j, c in pairs(w(u)) do
                N = j;
                
                if c.IsA(c, "Trail") or c.IsA(c, "Attachment") then
                    c.Destroy(c);
                end; 
            end;
        end;
    end;
    
    if not d then
        r39.Notify("Trail", "Disabled", 2);
        r39.PlayBell();
        
        return;
    end;
    
    G = r29.RenderStepped;
    
    r39.TrailConnection = G.Connect(G, function(...)
        u = ">\xda7\xff\xcf\xd0\xd9\xba \x08\xefQ";
        
        if not r39[r15[r16(u, 25031976267144)]] then
            return;
        end;
        
        d = r34.Character;
        
        if not d then
            return;
        end;
        
        v = d.FindFirstChild(d, "HumanoidRootPart");
        
        if not v then
            return;
        end;
        
        if not d.FindFirstChildOfClass(d, "Humanoid") then
            return;
        end;
        
        if v.Velocity.Magnitude > 1 then
            
            u = v.FindFirstChild(v, "CoolTrail");
            
            if not u then
                
                N = Instance.new("Attachment");
                N.Position = Vector3.new(0, -2, 0);
                k = d.FindFirstChild(d, "HumanoidRootPart");
                
                N.Parent = k;
                u = Instance.new("Trail");
                
                u.Name = "CoolTrail";
                u.Attachment0 = N;
                u.Lifetime = 0.5;
                u.MinLength = .2;
                u.Width = 1.2;
                u.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255));
                u.Transparency = NumberSequence.new(0, 0.5, 1);
                u.LightEmission = 1;
                u.Parent = v;
            end;
            
            u.Enabled = true;
        else
            
            u = v.FindFirstChild(v, "CoolTrail");
            
            if u then
                u.Enabled = false;
            end;
            
            return;
        end; 
    end);
    
    r39.Notify("Trail", "Enabled", 2);
    r39.PlayBell();
    
    return; 
end;
r39.InfiniteJumpEnabled = false;
r39.InfiniteJumpConnection = nil;
r39.ToggleInfiniteJump = function(arg1_10, ...)
    d = arg1_10;
    v = arg1_10;
    
    r39.InfiniteJumpEnabled = v;
    
    if r39.InfiniteJumpConnection then
        n = r39.InfiniteJumpConnection;
        
        n.Disconnect(n);
        
        r39.InfiniteJumpConnection = nil;
    end;
    
    if d then
        v = r30.JumpRequest;
        
        r39.InfiniteJumpConnection = v.Connect(v, function(...)
            G = r15;
            
            if r39.InfiniteJumpEnabled and r34.Character then
                n = r34.Character.Humanoid;
                
                n.ChangeState(n, Enum.HumanoidStateType.Jumping);
            end;
            
            return; 
        end);
        
        r39.Notify("Infinite Jump", "Enabled", 3);
    else
        r39.Notify("Infinite Jump", "Disabled", 3);
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.DalgonaCompleteShape = function(...)
    if not r39.IsGameActive("Dalgona") then
        r39.Notify("Dalgona", "Wait for Dalgona!", 2);
        r39.PlayBell();
        
        return false;
    end;
    
    task.spawn(function(...)
        d = 189;
        
        X[d] = r34;
        
        r43 = workspace.CurrentCamera;
        
        local function r44(arg1_11, arg2_11, arg3_11, ...)
            B = arg3_11;
            n = Instance.new;
            
            r45 = n("Folder");
            j = arg2_11;
            
            r45.Name = j;
            r45.Parent = arg1_11;
            
            if B then
                task.delay(B, function(...)
                    if r45 and r45.Parent then
                        n = r45;
                        
                        n.Destroy(n);
                    end;
                    
                    return; 
                end);
            end;
            
            return r45; 
        end;
        
        local function r46(arg1_12, ...)
            n = pairs;
            d = arg1_12;
            j = d.GetDescendants;
            G = {
                j(d)
            };
            B = j[3];
            v = j[2];
            
            for B, u in n(w("pairs")) do
                j = B;
                
                if u.IsA(u, "BasePart") and u.Name ~= "HumanoidRootPart" then
                    u.Transparency = 1;
                end; 
            end;
            
            return; 
        end;
        
        local function r47(arg1_13, ...)
            d = arg1_13;
            n = pairs;
            j = d.GetDescendants;
            G = {
                j(d)
            };
            B = j[3];
            G = j[1];
            
            for B, u in G, n(w(G)) do
                j = B;
                
                if u.IsA(u, "BasePart") and u.Name ~= "HumanoidRootPart" then
                    u.Transparency = 0;
                    u.LocalTransparencyModifier = 0;
                end; 
            end;
            
            u = d.GetChildren;
            G = u[3];
            
            for G, u in u[1], pairs(u(d)) do
                j = G;
                
                if u.IsA(u, "Accessory") then
                    
                    N = u.FindFirstChild(u, "Handle");
                    
                    if N then
                        c = N.Transparency >= .99;
                    end;
                    
                    if N then
                        N.Transparency = 0;
                    end;
                end; 
            end;
            
            return; 
        end;
        
        local function r48(...)
            n = pairs;
            B = r26;
            B = "pairs";
            
            for v, j in n(B.GetPlayers(B)) do
                G = v;
                
                if j.Character then
                    r47(j.Character);
                end; 
            end;
            
            return; 
        end;
        
        n = r27;
        
        k = n.WaitForChild(n, "Remotes");
        C = k.FindFirstChild(k, "DALGONATEMPREMPTE");
        
        if not C then
            r39.Notify("Dalgona", "Remote not found!", 2);
            r39.PlayBell();
            
            return;
        end;
        
        C.FireServer(C, {
            ["Completed"] = true
        });
        C.FireServer(C, {
            ["Success"] = true
        });
        
        (function(...)
            n = X[d].Character;
            r49 = n;
            v = r49;
            k = 11;
            
            if v then
                v = r49;
                
                k = v.FindFirstChild(v, "HumanoidRootPart");
            end;
            
            r50 = k;
            B = r49;
            k = 115;
            
            if B then
                B = r49;
                
                k = B.FindFirstChild(B, "Humanoid");
            end;
            
            r51 = k;
            n = X[d];
            x = 22367826684079;
            
            r52 = n.FindFirstChild(n, "PlayerGui");
            n = X[d];
            r53 = n.FindFirstChild(n, "DebrisBD");
            n = workspace;
            u = n.FindFirstChild(n, r15[r16("\x1a\x91\x1f\x1c\x1e\xcb\x8d", x)]);
            N = r52;
            
            if N then
                N = r52;
                
                k = N.FindFirstChild(N, "ImpactFrames");
            end;
            
            c = not C;
            C = r49;
            
            if C then
                x = r50;
                
                if x then
                    C = r51;
                end;
                
                n = workspace;
                k = x;
            end;
            
            n = c;
            
            if not C then
                return;
            end;
            
            r54 = r43.FieldOfView;
            
            if u then
                r = u.GetChildren;
                R = {
                    r(u)
                };
                J = r[3];
                R = r[1];
                
                for J, m in R, pairs(w(R)) do
                    r = J;
                    
                    h = r16("f^\x019\xeb", 24390389771357);
                    
                    D = m.IsA(m, r15[h]);
                    
                    if D then
                        D = m.Name;
                        
                        P = D.match(D, "Outline$");
                    end;
                    
                    if D then
                        r56 = m;
                    else
                        h = r16;
                        n = pairs;
                        
                        if m.IsA(m, "Model") and (not h.match(h, "Outline$") and (m.Name ~= "Pick" and m.Name ~= "RedDot")) then
                            r55 = m;
                        else
                            if m.Name == "Pick" then
                                r57 = m;
                            else
                                if m.Name == "RedDot" then
                                    r58 = m;
                                end;
                            end;
                        end;
                    end; 
                end;
            end;
            
            if N then
                
                y = N.FindFirstChild(N, "ProgressBar");
            end;
            
            r59 = N;
            
            if N then
                h = N.GetChildren;
                L = {
                    h(N)
                };
                r = h[1];
                m = h[2];
                
                for I, L in pairs(w(L)) do
                    y = I;
                    
                    if L.IsA(L, "ViewportFrame") and L.FindFirstChild(L, "PickModel") then
                        r60 = L.PickModel;
                    else
                        
                    end; 
                end;
            end;
            
            y = r27;
            
            r = y.WaitForChild(y, "Remotes");
            r61 = r.WaitForChild(r, "DALGONATEMPREMPTE");
            r62 = true;
            
            task.spawn(function(...)
                r44(X[d], "RecentGameStartedMessage", .01);
                
                d = r55;
                k = d;
                
                if d then
                    d = r55;
                    
                    k = d.FindFirstChild(d, "shape");
                end;
                
                if k then
                    n = r33;
                    
                    k = n.Create(n, r55.shape, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                        ["Position"] = r55.shape.Position + Vector3.new(0, 0.5, 0)
                    });
                    
                    k.Play(k);
                end;
                
                if r55 then
                    B = r55;
                    B = {
                        pairs(B.GetChildren(B))
                    };
                    d = B[2];
                    v = B[3];
                    
                    B = pairs(B.GetChildren(B));
                end; 
            end);
            
            y = r29.RenderStepped;
            r63 = y.Connect(y, function(...)
                n = not r62;
                
                if n then
                    n = r63;
                    
                    n.Disconnect(n);
                    
                    return;
                end;
                
                if r43.CameraType == Enum.CameraType.Scriptable then
                    r43.CameraType = Enum.CameraType.Custom;
                end;
                
                if r51 and r43.CameraSubject ~= r51 then
                    r43.CameraSubject = r51;
                end; 
            end);
            
            return; 
        end)();
        (function(...)
            d = X[d].Character;
            
            if d then
                d = X[d].Character;
                
                k = d.FindFirstChild(d, "Remotes");
            end;
            
            if d then
                n = X[d].Character;
                
                r64 = n.FindFirstChild(n, "Remotes");
                
                pcall(function(...)
                    v = r16;
                    
                    r64.Disabled = true;
                    
                    return; 
                end);
                
                task.wait(0.5);
                
                pcall(function(...)
                    v = r16;
                    
                    r64.Disabled = false;
                    
                    return; 
                end);
            end;
            
            return; 
        end)();
        
        task.spawn(function(...)
            k = r27;
            
            d = k.WaitForChild(k, "Remotes");
            n = not d.FindFirstChild(d, "DALGONATEMPREMPTE");
            
            task.wait(1);
            
            r48();
            
            k = r27;
            
            d = k.WaitForChild(k, "Remotes");
            
            if not d.FindFirstChild(d, "DALGONATEMPREMPTE") then
                return;
            end; 
        end);
        r39.Notify("Dalgona", "Shape Completed!", 2);
        r39.PlayBell();
        
        return; 
    end);
    
    return; 
end;
r39.FullbrightEnabled = false;
r39.FullbrightSettings = {};
r39.FullbrightConnection = nil;
r39.AutoWinEnabled = false;
r39.AutoWinConnection = nil;
r39.AutoWinTriggered = {};
r39.GameStartTime = nil;
r39.CurrentGame = nil;
r39.LastNotifTime = 0;
r39.AutoWin = function(...)
    if not r39.AutoWinEnabled then
        return;
    end;
    
    d = tick();
    n = r28;
    
    v = n.FindFirstChild(n, "Values");
    
    if not v then
        return;
    end;
    
    B = v.FindFirstChild(v, "CurrentGame");
    
    if not B then
        return;
    end;
    
    G = B.Value;
    
    if not G then
        return;
    end;
    
    if G ~= r39.CurrentGame then
        j = B.Value;
        
        r39.CurrentGame = j;
        
        j = tick();
        
        r39.GameStartTime = j;
        
        r39.AutoWinTriggered[G] = false;
    end;
    
    if r39.AutoWinTriggered[G] then
        return;
    end;
    
    if not r39.GameStartTime then
        return;
    end;
    
    if d - r39.GameStartTime < 12 then
        return;
    end;
    
    j = r39.GetCharacter();
    
    if not j then
        return;
    end;
    
    u = r39.GetRootPart(j);
    
    if not u then
        return;
    end;
    
    if G == "RedLightGreenLight" then
        r39.SafeTeleport(Vector3.new(-214.4, 1023.1, 146.7));
        r39.Notify("AutoWin", "Auto teleported to End", 2);
        
        r39.AutoWinTriggered[G] = true;
        
        r39.PlayBell();
    else
        if G == "Dalgona" then
            r39.DalgonaCompleteShape();
            r39.Notify("AutoWin", "Auto completed Shape", 2);
            
            r39.AutoWinTriggered[G] = true;
            
            r39.PlayBell();
        else
            if G == "LightsOut" or G == "LightOut" then
                N = u.Position;
                
                r39.SafeTeleport(Vector3.new(N.X, N.Y + 100, N.Z));
                r39.Notify("AutoWin", "Auto teleported Up 100 blocks", 2);
                
                r39.AutoWinTriggered[G] = true;
                
                r39.PlayBell();
            else
                if G == "HideAndSeek" then
                    r39.IsSeeker(r34);
                    
                    if r39.IsHider(r34) then
                        C = u.Position;
                        
                        r39.SafeTeleport(Vector3.new(C.X, C.Y + 200, C.Z));
                        r39.Notify("AutoWin", "Auto teleported Up 200 blocks", 2);
                        
                        r39.AutoWinTriggered[G] = true;
                        
                        r39.PlayBell();
                    else
                        if k then
                            if d - r39.LastNotifTime > 5 then
                                
                                C = tick();
                                
                                r39.LastNotifTime = C;
                                
                                r39.PlayBell();
                            end;
                        end;
                    end;
                else
                    if G == "JumpRope" then
                        r39.SafeTeleport(Vector3.new(720.896057, 198.628311, 921.170654));
                        r39.Notify("AutoWin", "Teleported to End in JumpRope", 2);
                        
                        r39.AutoWinTriggered[G] = true;
                        
                        r39.PlayBell();
                    else
                        if G == "GlassBridge" then
                            r39.SafeTeleport(Vector3.new(-196.372467, 522.192139, -1534.20984));
                            r39.Notify("AutoWin", "Automatically teleported!", 2);
                            
                            r39.AutoWinTriggered[G] = true;
                            
                            r39.PlayBell();
                        end;
                        
                        return;
                    end;
                end;
            end;
        end;
    end; 
end;
r39.ToggleAutoWin = function(arg1_14, ...)
    d = arg1_14;
    v = arg1_14;
    
    r39.AutoWinEnabled = v;
    r39.AutoWinTriggered = {};
    r39.GameStartTime = nil;
    r39.CurrentGame = nil;
    r39.LastNotifTime = 0;
    
    if r39.AutoWinConnection then
        n = r39.AutoWinConnection;
        
        n.Disconnect(n);
        
        r39.AutoWinConnection = nil;
    end;
    
    if d then
        v = r29.Heartbeat;
        
        r39.AutoWinConnection = v.Connect(v, function(...)
            
            G = r16("k\x8a\xc7\x8fR\xab0\xdb\xbbW\x9f6\x10\x83", 17766073360464);
            
            if r39[r15[G]] then
                r39.AutoWin();
            end;
            
            return; 
        end);
        
        r39.Notify("Waiting for the next game..", 3);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.Rebel = {
    ["Enabled"] = false,
    ["Connection"] = nil,
    ["LastCheckTime"] = 0,
    ["LastKillTime"] = 0,
    ["CheckCooldown"] = .1,
    ["KillCooldown"] = .05
};
r39.ToggleRebel = function(arg1_15, ...)
    d = arg1_15;
    v = arg1_15;
    
    r39.Rebel.Enabled = v;
    
    if r39.Rebel.Connection then
        n = r39.Rebel.Connection;
        
        n.Disconnect(n);
        
        r39.Rebel.Connection = nil;
    end;
    
    if d then
        v = r29.Heartbeat;
        
        r39.Rebel.Connection = v.Connect(v, function(...)
            G = r15;
            
            if not r39.Rebel.Enabled then
                return;
            end;
            
            d = tick();
            
            if d - r39.Rebel.LastCheckTime < r39.Rebel.CheckCooldown then
                return;
            end;
            
            r39.Rebel.LastCheckTime = d;
            
            v = {};
            n = workspace;
            
            if n.FindFirstChild(n, "Live") then
                j = workspace.Live;
                B = j[2];
                j = j[1];
                
                for G, N in pairs(j.GetChildren(j)) do
                    u = G;
                    
                    if N.IsA(N, "Model") and (N.FindFirstChild(N, "Enemy") and not N.FindFirstChild(N, "Dead")) then
                        U = game;
                        
                        e = U.GetService(U, "Players");
                        x = e[3];
                        
                        for x, e in e[1], pairs(e.GetPlayers(e)) do
                            U = x;
                            
                            if e.Name == N.Name then
                                c = true;
                            else
                                
                            end; 
                        end;
                        
                        if not false then
                            table.insert(v, N.Name);
                        end;
                    end; 
                end;
            end;
            
            if #v == 0 then
                return;
            end;
            
            N = {
                pairs(v)
            };
            u = N[3];
            j = N[2];
            
            G = pairs(v); 
        end);
        
        r39.Notify("Rebel", "Equip ur gun", 2);
    else
        r39.Rebel.LastKillTime = 0;
        r39.Rebel.LastCheckTime = 0;
    end;
    
    return; 
end;
r39.SpikesPlatformTeleport = {
    ["Enabled"] = false,
    ["Connection"] = nil,
    ["Platform"] = nil,
    ["OriginalCFrame"] = nil,
    ["SpikesPosition"] = nil
};
r39.ToggleSpikesPlatformTeleport = function(arg1_16, ...)
    d = arg1_16;
    
    if d then
        k = not r39.IsGameActive("HideAndSeek");
    end;
    
    if d then
        r39.Notify("Spikes Platform", "Wait for HideAndSeek", 2);
        r39.PlayBell();
        
        n = r35.SpikesPlatformTeleport;
        
        if n then
            n = r35.SpikesPlatformTeleport;
            
            n.SetValue(n, false);
        end;
        
        return false;
    end;
    
    if r39.SpikesPlatformTeleport.Connection then
        n = r39.SpikesPlatformTeleport.Connection;
        
        n.Disconnect(n);
        
        r39.SpikesPlatformTeleport.Connection = nil;
    end;
    
    if r39.SpikesPlatformTeleport.Platform then
        pcall(function(...)
            v = "SpikesPlatformTeleport";
            n = r39[v].Platform;
            
            n.Destroy(n);
            
            return; 
        end);
        
        r39.SpikesPlatformTeleport.Platform = nil;
    end;
    
    r39.SpikesPlatformTeleport.Enabled = d;
    r39.SpikesPlatformTeleport.OriginalCFrame = nil;
    r39.SpikesPlatformTeleport.SpikesPosition = v;
    
    if not d then
        
        v = r39.GetCharacter();
        
        if v then
            k = r39.SpikesPlatformTeleport.OriginalCFrame;
        end;
        
        if v then
            v.SetPrimaryPartCFrame(v, r39.SpikesPlatformTeleport.OriginalCFrame);
            r39.Notify("Spikes Platform", "Returned", 2);
        end;
        
        r39.PlayBell();
        
        return true;
    end;
    
    n = workspace;
    N = "E\x91\x93\x94UTzf$;/\x88;J";
    c = 34239368134215;
    
    B = n.FindFirstChild(n, r15[r16(N, c)]);
    G = B and B.FindFirstChild(B, "KillingParts");
    
    if G then
        c = G.GetChildren;
        N = {
            c(G)
        };
        j = c[2];
        N = c[1];
        
        for u, C in pairs(w(N)) do
            c = u;
            
            if C.IsA(C, "BasePart") then
                v = C.Position;
            else
                
            end; 
        end;
    end;
    
    if not nil then
        C = workspace;
        N = C[2];
        c = C[3];
        
        for c, C in pairs(C.GetDescendants(C)) do
            j = c;
            n = workspace;
            
            if C.IsA(C, "BasePart") and C.Name == "Spikes" then
                v = C.Position;
            else
                
            end; 
        end;
    end;
    
    if not nil then
        r39.Notify("TP To Spikes", "Spikes not found", 2);
        r39.PlayBell();
        
        j = r35.SpikesPlatformTeleport;
        
        if j then
            j = r35.SpikesPlatformTeleport;
            
            j.SetValue(j, false);
        end;
        
        return false;
    end;
    
    r39.SpikesPlatformTeleport.SpikesPosition = v;
    
    u = Instance.new("Part");
    
    u.Name = "SpikesPlatformTeleport";
    u.Size = Vector3.new(10, 1, 10);
    u.Position = nil + Vector3.new(0, 10, 0);
    u.Anchored = true;
    u.CanCollide = true;
    u.Transparency = 0.5;
    u.Color = Color3.fromRGB(0, 255, 0);
    u.Material = Enum.Material.Neon;
    u.Parent = workspace;
    r39.SpikesPlatformTeleport.Platform = u;
    N = r39.GetCharacter();
    
    if N then
        
        c = r39.GetRootPart(N);
        
        if c then
            
            r39.SpikesPlatformTeleport.OriginalCFrame = N.GetPrimaryPartCFrame(N);
            c.CFrame = CFrame.new(u.Position + Vector3.new(0, 3, 0));
            
            r39.Notify("TP To Spikes", "Teleported", 2);
        end;
    end;
    
    C = r29.Heartbeat;
    
    r39.SpikesPlatformTeleport.Connection = C.Connect(C, function(...)
        if not r39.SpikesPlatformTeleport.Enabled then
            return;
        end;
        
        if not r39.IsGameActive("HideAndSeek") then
            r39.ToggleSpikesPlatformTeleport(false);
            
            n = r35.SpikesPlatformTeleport;
            
            if n then
                n = r35.SpikesPlatformTeleport;
                
                n.SetValue(n, false);
            end;
            
            return;
        end;
        
        if not r39.SpikesPlatformTeleport.Platform or not r39.SpikesPlatformTeleport.Platform.Parent then
            
            d = Instance.new("Part");
            
            d.Name = "SpikesPlatformTeleport";
            d.Size = Vector3.new(10, 1, 10);
            d.Position = r39.SpikesPlatformTeleport.SpikesPosition + Vector3.new(0, 10, 0);
            d.Anchored = true;
            d.CanCollide = true;
            d.Transparency = 0.5;
            d.Color = Color3.fromRGB(0, 255, 0);
            d.Material = Enum.Material.Neon;
            d.Parent = workspace;
            r39.SpikesPlatformTeleport.Platform = d;
        end;
        
        d = r39.GetCharacter();
        
        if d then
            
            v = r39.GetRootPart(d);
            
            if v then
                U = "\xf45QZ\xa6\xf7\xe0\xb9\xea\xf0\x7f\r\x02\x19,s\x15\xb2'F\xff(";
                
                if (v.Position - r39[r15[r16(U, 16266226933142)]].Platform.Position).Magnitude > 15 then
                    if not r39.SpikesPlatformTeleport.OriginalCFrame then
                        
                        r39.SpikesPlatformTeleport.OriginalCFrame = d.GetPrimaryPartCFrame(d);
                    end;
                    
                    v.CFrame = CFrame.new(r39.SpikesPlatformTeleport.Platform.Position + Vector3.new(0, 3, 0));
                end;
            end;
        end;
        
        return; 
    end);
    
    r39.PlayBell();
    
    return true; 
end;
r39.EffectShooter = {
    ["Enabled"] = false,
    ["Connection"] = nil,
    ["LastShootTime"] = 0,
    ["ShootCooldown"] = .05,
    ["TrackedPlayers"] = {},
    ["TargetEffect"] = "GuardCanKillLockOn"
};
r39.GetLocalGun = function(...)
    n = r34.Character;
    
    if n then
        G = r34.Character;
        G = "pairs";
        
        for B, u in pairs(G.GetChildren(G)) do
            j = B;
            
            if u.IsA(u, "Tool") and u.GetAttribute(u, "Gun") then
                d = u;
            else
                
            end; 
        end;
    end;
    
    G = not nil;
    
    if G then
        v = r34.Backpack;
    end;
    
    n = n;
    
    if G then
        u = r34.Backpack;
        B = u[1];
        G = u[2];
        
        for j, u in pairs(u.GetChildren(u)) do
            v = j;
            n = B;
            
            if u.IsA(u, "Tool") and u.GetAttribute(u, "Gun") then
                d = u;
            else
                
            end; 
        end;
    end;
    
    return nil; 
end;
r39.HasTargetEffect = function(arg1_17, ...)
    d = arg1_17;
    
    if not d.Character then
        return false;
    end;
    
    G = d.Character;
    B = G[3];
    G = G[1];
    
    for B, u in G, pairs(G.GetDescendants(G)) do
        j = B;
        
        if u.IsA(u, "BillboardGui") and u.Name == r39.EffectShooter.TargetEffect then
            return true;
        else
            
        end; 
    end;
    
    return false; 
end;
r39.ShootAtPlayer = function(arg1_18, ...)
    
    v = r39.GetLocalGun();
    n = not v;
    
    if n then
        return false;
    end;
    
    x = n;
    J = workspace;
    n = n;
    r65 = {
        v,
        {
            ["ClientRayNormal"] = Vector3.new(-1.1920928955078e-07, 1.0000001192093, 0),
            ["FiredGun"] = true,
            ["SecondaryHitTargets"] = {},
            ["ClientRayInstance"] = J.FindFirstChild(J, "StairWalkWay") and J.FindFirstChild(J, "Part") or nil,
            ["ClientRayPosition"] = Vector3.new(-220.17489624023, 183.29577636719, 301.07257080078),
            ["bulletCF"] = CFrame.new(-220.50398254395, 185.22506713867, 302.13354492188, .95511162281036, .2567310333252, -0.14782091975212, 7.4505814851022e-09, .49897986650467, .86661356687546, .29624626040459, -0.82771271467209, .47658145427704),
            ["HitTargets"] = {
                [arg1_18] = "Head"
            },
            ["bulletSizeC"] = Vector3.new(.0099999997764826, .0099999997764826, 4.4524998664856),
            ["NoMuzzleFX"] = false,
            ["FirePosition"] = Vector3.new(-72.88850402832, -679.48034667969, -173.31005859375)
        }
    };
    
    pcall(function(...)
        n = r27;
        j = "\xcbJt;0\xf1\xf2";
        
        k = n.WaitForChild(n, r15[r16(j, 10551326675761)]);
        n = k.WaitForChild(k, "FiredGunClient");
        
        n.FireServer(n, unpack(r65));
        
        return; 
    end);
    
    return true; 
end;
r39.TrackPlayerEffects = function(arg1_19, ...)
    d = arg1_19;
    
    if r39.EffectShooter.TrackedPlayers[d] then
        return;
    end;
    
    v = {};
    n = d.CharacterAdded;
    
    table.insert(v, n.Connect(n, function(arg1_20, ...)
        d = arg1_20;
        B = r15;
        
        task.wait(0.5);
        
        return; 
    end));
    
    if d.Character then
        n = d.Character.DescendantAdded;
        
        table.insert(v, n.Connect(n, function(arg1_21, ...)
            d = arg1_21;
            
            return; 
        end));
    end;
    
    r39.EffectShooter.TrackedPlayers[d] = v;
    
    return; 
end;
r39.ToggleEffectShooter = function(arg1_22, ...)
    d = arg1_22;
    v = arg1_22;
    
    r39.EffectShooter.Enabled = v;
    
    if r39.EffectShooter.Connection then
        n = r39.EffectShooter.Connection;
        
        n.Disconnect(n);
        
        r39.EffectShooter.Connection = nil;
    end;
    
    if d then
        G = r26;
        B = G[3];
        G = G[1];
        
        for B, u in G, pairs(G.GetPlayers(G)) do
            j = B;
            
            if u ~= r34 then
                r39.TrackPlayerEffects(u);
            end; 
        end;
        
        n = r26.PlayerAdded;
        
        n.Connect(n, function(arg1_23, ...)
            d = arg1_23;
            
            if d ~= r34 then
                B = r15;
                
                r39.TrackPlayerEffects(d);
            end;
            
            return; 
        end);
        
        G = X[y].Heartbeat;
        r39.EffectShooter.Connection = G.Connect(G, function(...)
            
            u = r16("a:\xc2\xe7vHa,\x8b\xdb\xa1.\xd3", 6849323519093);
            
            if not r39[r15[u]].Enabled then
                return;
            end;
            
            C = 31425448982825;
            
            if tick() - r39.EffectShooter.LastShootTime < r39.EffectShooter[r15[r16("\xb2\xef?\xbbj\xda\x82J\n\x1ey\\\xdd", C)]] then
                return;
            end;
            
            if not r39.GetLocalGun() then
                return;
            end;
            
            j = r26;
            B = j[2];
            j = j[1];
            
            for G, N in pairs(j.GetPlayers(j)) do
                C = N ~= r34;
                u = G;
                
                if C then
                    
                    c = r39.HasTargetEffect(N);
                end;
                
                if C then
                    r39.ShootAtPlayer(N.Name);
                    task.wait(.03);
                end; 
            end;
            
            r39.EffectShooter.LastShootTime = tick();
            
            return; 
        end);
        
        r39.Notify("AutoShoot", "Enabled", 3);
    else
        u = r39.EffectShooter;
        
        y = r16("v\xdf\xf4\r\x9b\x11\x7f\x88c\xeb\x18\xf2K\xa7", 18624933831136);
        B = u[2];
        G = u[3];
        
        for G, u in pairs(u[r15[y]]) do
            j = G;
            C = y[3];
            
            for C, x in y[1], pairs(u) do
                x.Disconnect(x);
                
                y = C; 
            end; 
        end;
        
        r39.EffectShooter.TrackedPlayers = {};
        r39.EffectShooter.LastShootTime = 0;
        
        return;
    end; 
end;
r39.IsMobile = function(...)
    return r30.TouchEnabled and not r30.KeyboardEnabled; 
end;
r39.IsGameActive = function(arg1_24, ...)
    n = r28;
    
    v = n.FindFirstChild(n, "Values");
    
    if not v then
        return false;
    end;
    
    B = v.FindFirstChild(v, "CurrentGame");
    
    if B then
        k = B.Value == arg1_24;
    end;
    
    return B; 
end;
r39.DisableToggle = function(arg1_25, ...)
    r66 = arg1_25;
    
    if r35[r66] and r35[r66].SetValue then
        pcall(function(...)
            n = r35[r66];
            
            n.SetValue(n, false);
            
            return; 
        end);
    end;
    
    return; 
end;
r39.CanEnableToggle = function(arg1_26, arg2_26, arg3_26, ...)
    v = arg2_26;
    d = arg1_26;
    r67 = arg3_26;
    
    if not r39.IsGameActive(d) then
        r39.Notify(v, "Wait for " .. d .. "!", 2);
        r39.PlayBell();
        
        if r67 and r67.SetValue then
            pcall(function(...)
                n = r67;
                
                n.SetValue(n, false);
                
                return; 
            end);
        end;
        
        return false;
    end;
    
    if not r39.IsFeatureSupported(v) then
        r39.Notify(v, "Not supported in your executor", 3);
        r39.PlayBell();
        
        if r67 and r67.SetValue then
            pcall(function(...)
                n = r67;
                
                n.SetValue(n, false);
                
                return; 
            end);
        end;
        
        return false;
    end;
    
    return true; 
end;
r39.SafeTeleport = function(arg1_27, ...)
    
    v = r39.GetCharacter();
    
    if v then
        
        B = r39.GetRootPart(v);
        
        if B then
            
            B.CFrame = CFrame.new(arg1_27);
            
            return true;
        end;
    end;
    
    return false; 
end;
r39.IsHider = function(arg1_28, ...)
    d = arg1_28;
    
    if d then
        k = d.GetAttribute(d, "IsHider") == true;
    end;
    
    return d; 
end;
r39.IsSeeker = function(arg1_29, ...)
    d = arg1_29;
    
    if d then
        k = d.GetAttribute(d, "IsHunter") == true;
    end;
    
    return d; 
end;
r39.FaceTargetModule = {
    ["Enabled"] = false,
    ["Connection"] = nil
};
r39.ToggleFaceTarget = function(arg1_30, ...)
    d = arg1_30;
    
    if type(d) ~= "boolean" then
        d = not r39.FaceTargetModule.Enabled;
    end;
    
    if r39.FaceTargetModule.Connection then
        k = r39.FaceTargetModule.Connection;
        
        k.Disconnect(k);
        
        r39.FaceTargetModule.Connection = nil;
    end;
    
    r39.FaceTargetModule.Enabled = d;
    
    if d then
        B = r29.Heartbeat;
        
        r39.FaceTargetModule.Connection = B.Connect(B, function(...)
            j = r16;
            
            if not r39.FaceTargetModule.Enabled then
                return;
            end;
            
            d = r34.Character;
            
            if not d then
                return;
            end;
            
            v = d.FindFirstChild(d, "HumanoidRootPart");
            
            if not v then
                return;
            end;
            
            G = math.huge;
            j = v.Position;
            n = ipairs;
            c = r26;
            u = c[2];
            c = c[1];
            
            for N, y in n(c.GetPlayers(c)) do
                C = N;
                
                if y ~= r34 and y.Character then
                else
                    
                end; 
            end;
            
            if nil then
                u = nil.Character;
            end;
            
            n = n;
            
            if u then
                u = nil.Character;
                
                N = u.FindFirstChild(u, "HumanoidRootPart");
                
                if N then
                    
                    c = CFrame.lookAt(v.Position, N.Position);
                    
                    v.CFrame = CFrame.new(v.Position) * (c - c.Position);
                end;
            end;
            
            return; 
        end);
        
        r39.Notify("Face Target", "Enabled", 3);
    else
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.AutoDodge = {
    ["Enabled"] = false,
    ["AnimationIds"] = {
        "rbxassetid://88451099342711",
        "rbxassetid://79649041083405",
        "rbxassetid://73242877658272",
        "rbxassetid://114928327045353",
        "rbxassetid://135690448001690",
        "rbxassetid://103355259844069",
        "rbxassetid://125906547773381",
        "rbxassetid://121147456137931",
        "rbxassetid://96924216250322",
        "rbxassetid://116839849594540",
        "rbxassetid://104041807075625",
        "rbxassetid://83057176809194",
        "rbxassetid://103318207627541",
        "rbxassetid://121473077508383",
        "rbxassetid://94215646393565",
        "rbxassetid://81533666958052",
        "rbxassetid://116839849594540"
    },
    ["Connections"] = {},
    ["LastDodgeTime"] = 0,
    ["DodgeCooldown"] = .9,
    ["Range"] = 3.8,
    ["RangeSquared"] = 14.44,
    ["AnimationIdsSet"] = {},
    ["ActiveAnimations"] = {},
    ["LastAnimationStartTime"] = {},
    ["CapturedCall"] = nil,
    ["LastCapturedCallTime"] = 0,
    ["OriginalFireServer"] = nil,
    ["Remote"] = nil,
    ["HeartbeatConnection"] = nil,
    ["DodgeAttempts"] = {}
};

local v17 = r39.AutoDodge;
local v18 = v17.AnimationIds;
local v19 = v17[3];

for v19, v18 in v17[1], ipairs(v18) do
    b = v19;
    
    r39.AutoDodge.AnimationIdsSet[v18] = true; 
end;

r39.getLocalPlayer = function(...)
    B = {
        pcall(function(...)
            local K = {
                K[1],
                K[2]
            };
            
            k = game;
            v = "Players";
            
            return k.GetService(k, v).LocalPlayer; 
        end)
    };
    d = B[2];
    
    v = pcall(function(...)
        local K = {
            K[1],
            K[2]
        };
        
        k = game;
        v = "Players";
        
        return k.GetService(k, v).LocalPlayer; 
    end);
    
    if v then
        k = B[2];
    end;
    
    if v then
        return d;
    end;
    
    return nil; 
end;
r39.setupRemoteHook = function(...)
    n = game;
    
    v = n.GetService(n, "ReplicatedStorage");
    G = v.FindFirstChild(v, "Remotes");
    
    if G then
        G = v.Remotes;
        
        k = G.FindFirstChild(G, "UsedTool");
    end;
    
    if G then
        r68 = v.Remotes.UsedTool;
    else
        y = "\xfd_\xd4\xc5B\xe3";
        
        C = r16(y, 6997589462202);
        
        j = v.FindFirstChild(v, r15[C]);
        
        if j then
            j = v.Events;
            
            k = j.FindFirstChild(j, "UsedTool");
        end;
        
        if j then
            r68 = v.Events.UsedTool;
        else
            C = v.GetChildren;
            c = {
                C(v)
            };
            N = C[3];
            u = C[2];
            
            for N, c in pairs(w(c)) do
                G = N;
                
                if c.FindFirstChild(c, "UsedTool") then
                    r68 = c.UsedTool;
                else
                    
                end; 
            end;
            
            if not r68 then
                return false;
            end;
            
            r39.AutoDodge.Remote = r68;
            
            local function r69(...)
                local function r70(arg1_31, ...)
                    n = pairs;
                    B = 43[3];
                    
                    for B, u in 43[1], n(arg1_31) do
                        j = B;
                        
                        if typeof(u) == "Instance" and (u.IsA(u, "Tool") and u.Name == "DODGE!") then
                            return true;
                        else
                            if typeof(u) == "table" then
                                if r70(u) then
                                    return true;
                                else
                                end;
                            end;
                        end; 
                    end;
                    
                    return false; 
                end;
                
                G = u[2];
                u = u[1];
                
                for j, c in ipairs({
                    select(-1, ...)
                }) do
                    N = j;
                    
                    if typeof(c) == "Instance" and (c.IsA(c, "Tool") and c.Name == "DODGE!") then
                        return true;
                    else
                        if typeof(c) == "table" then
                            if r70(c) then
                                return true;
                            else
                            end;
                        end;
                    end; 
                end;
                
                return false; 
            end;
            
            r39.AutoDodge.OriginalFireServer = r68.FireServer;
            
            if not pcall(function(...)
                d = getrawmetatable;
                
                return d and (hookfunction and setreadonly); 
            end) then
                if getnamecallmethod then
                    
                    u = getrawmetatable(r68);
                    
                    if u then
                        r71 = u.__namecall;
                        
                        u.__namecall = function(arg1_32, ...)
                            v = {
                                f(2, w(F))
                            };
                            d = arg1_32;
                            c = 29539759355323;
                            n = getnamecallmethod() == r15[r16("3\x8b\xd38\x80Bm\xd4~2", c)];
                            
                            if n then
                                G = {
                                    w(v)
                                };
                                
                                for u, C in ("3\x8b\xd38\x80Bm\xd4~2")[1], ipairs(G) do
                                    c = u;
                                    
                                    if typeof(C) == "Instance" and C.IsA(C, "Tool") then
                                        r39.AutoDodge.CapturedCall = {
                                            ["args"] = G,
                                            ["timestamp"] = tick(),
                                            ["tool"] = nil
                                        };
                                        
                                        r39.AutoDodge.LastCapturedCallTime = tick();
                                    else
                                        
                                    end; 
                                end;
                            end;
                            
                            N = r71;
                            
                            if N then
                                r71(d, w(v));
                            end;
                            
                            n = n;
                            
                            if N then
                                return N;
                            else
                                
                                G = r39.AutoDodge.OriginalFireServer(d, w(v));
                            end; 
                        end;
                    end;
                end;
                
                return true;
            end;
            
            y = {
                pcall(function(...)
                    if r68.ClassName == "RemoteEvent" then
                        
                        r72 = getrawmetatable(game);
                        
                        if r72 then
                            r73 = r72.__index;
                            j = {
                                pcall(function(...)
                                    setreadonly(r72, false);
                                    
                                    return; 
                                end)
                            };
                            B = j[2];
                            
                            G = pcall(function(...)
                                setreadonly(r72, false);
                                
                                return; 
                            end);
                            
                            if G then
                                c = "\xa5\x8f\xa3\xb7\xbe\x91\x9a";
                                
                                r72[r15[r16(c, 10307780612799)]] = function(arg1_33, arg2_33, ...)
                                    d = arg1_33;
                                    v = arg2_33;
                                    
                                    if d == r68 and v == "FireServer" then
                                        return function(arg1_34, ...)
                                            n = r69;
                                            v = {
                                                f(2, w(F))
                                            };
                                            j = "AutoDodge";
                                            
                                            if n(w(v)) then
                                                r39.AutoDodge.CapturedCall = {
                                                    ["args"] = {
                                                        w(v)
                                                    },
                                                    ["timestamp"] = tick(),
                                                    ["tool"] = nil
                                                };
                                                
                                                r39.AutoDodge.LastCapturedCallTime = tick();
                                            end;
                                            
                                            return r39[j].OriginalFireServer(arg1_34, w(v)); 
                                        end;
                                    end;
                                    
                                    return r73(d, v); 
                                end;
                                
                                setreadonly(r72, true);
                            end;
                        end;
                    else
                        c = 26657724625021;
                        
                        hookfunction(r68[r15[r16("z\xe5\xfa\xd0D\x89n\xdc(\xb3", c)]], function(arg1_35, ...)
                            v = {
                                f(2, w(F))
                            };
                            
                            if r69(w(v)) then
                                r39.AutoDodge.CapturedCall = {
                                    ["args"] = {
                                        w(v)
                                    },
                                    ["timestamp"] = tick(),
                                    ["tool"] = nil
                                };
                                
                                r39.AutoDodge.LastCapturedCallTime = tick();
                            end;
                            
                            return r39.AutoDodge.OriginalFireServer(arg1_35, w(v)); 
                        end);
                    end;
                    
                    return; 
                end)
            };
            N = y[2];
            
            if not pcall(function(...)
                if r68.ClassName == "RemoteEvent" then
                    
                    r72 = getrawmetatable(game);
                    
                    if r72 then
                        r73 = r72.__index;
                        j = {
                            pcall(function(...)
                                setreadonly(r72, false);
                                
                                return; 
                            end)
                        };
                        B = j[2];
                        
                        G = pcall(function(...)
                            setreadonly(r72, false);
                            
                            return; 
                        end);
                        
                        if G then
                            c = "\xa5\x8f\xa3\xb7\xbe\x91\x9a";
                            
                            r72[r15[r16(c, 10307780612799)]] = function(arg1_36, arg2_36, ...)
                                d = arg1_36;
                                v = arg2_36;
                                
                                if d == r68 and v == "FireServer" then
                                    return function(arg1_37, ...)
                                        n = r69;
                                        v = {
                                            f(2, w(F))
                                        };
                                        j = "AutoDodge";
                                        
                                        if n(w(v)) then
                                            r39.AutoDodge.CapturedCall = {
                                                ["args"] = {
                                                    w(v)
                                                },
                                                ["timestamp"] = tick(),
                                                ["tool"] = nil
                                            };
                                            
                                            r39.AutoDodge.LastCapturedCallTime = tick();
                                        end;
                                        
                                        return r39[j].OriginalFireServer(arg1_37, w(v)); 
                                    end;
                                end;
                                
                                return r73(d, v); 
                            end;
                            
                            setreadonly(r72, true);
                        end;
                    end;
                else
                    c = 26657724625021;
                    
                    hookfunction(r68[r15[r16("z\xe5\xfa\xd0D\x89n\xdc(\xb3", c)]], function(arg1_38, ...)
                        v = {
                            f(2, w(F))
                        };
                        
                        if r69(w(v)) then
                            r39.AutoDodge.CapturedCall = {
                                ["args"] = {
                                    w(v)
                                },
                                ["timestamp"] = tick(),
                                ["tool"] = nil
                            };
                            
                            r39.AutoDodge.LastCapturedCallTime = tick();
                        end;
                        
                        return r39.AutoDodge.OriginalFireServer(arg1_38, w(v)); 
                    end);
                end;
                
                return; 
            end) then
                r39.Notify("Auto Dodge", "Limited mode on this executor", 3);
            end;
            
            return true;
        end;
    end; 
end;
r39.executeDodge = function(...)
    if not r39.AutoDodge.Enabled then
        return false;
    end;
    
    d = tick();
    
    if d - r39.AutoDodge.LastDodgeTime < r39.AutoDodge.DodgeCooldown then
        return false;
    end;
    
    if not r39.AutoDodge.CapturedCall then
        return false;
    end;
    
    v = r39.getLocalPlayer();
    
    if not v then
        return false;
    end;
    
    G = v.Character;
    
    if G then
        
        n = G.FindFirstChild(G, "DODGE!");
        r74 = n;
        k = not r74 and v.Backpack;
        n = n;
        
        if k then
            k = v.Backpack;
            
            r74 = k.FindFirstChild(k, "DODGE!");
        end;
    end;
    
    if not r74 then
        return false;
    end;
    
    r75 = {};
    x = r39.AutoDodge.CapturedCall;
    C = x[3];
    
    for C, x in x[1], ipairs(x.args) do
        n = v[r15[j("?\xda\t\xcf\xaa[|\xfd\xe7", c)]];
        
        if typeof(x) == "Instance" and (x.IsA(x, "Tool") and x.Name == "DODGE!") then
            r75[C] = r74;
        else
            r75[C] = x;
        end; 
    end;
    
    r39.AutoDodge.LastDodgeTime = d;
    
    if not pcall(function(...)
        n = r39.AutoDodge.Remote;
        
        n.FireServer(n, unpack(r75));
        
        return; 
    end) then
        pcall(function(...)
            n = r39.AutoDodge.Remote;
            
            n.FireServer(n, r74);
            
            return; 
        end);
        
        return false;
    end;
    
    return true; 
end;
r39.isLookingAtPlayer = function(arg1_39, arg2_39, ...)
    d = arg1_39;
    v = arg2_39;
    
    if not d or not d.Character then
        return false;
    end;
    
    if not v or not v.Character then
        return false;
    end;
    
    n = d.Character;
    
    B = n.FindFirstChild(n, "Head");
    n = v.Character;
    G = n.FindFirstChild(n, "HumanoidRootPart");
    j = not B;
    
    if B then
        
        k = n.FindFirstChild(n, r15[N]);
    end;
    
    n = j;
    
    if not B then
        return false;
    end;
    
    j = (G.Position - B.Position).Unit;
    
    return j.Dot(j, B.CFrame.LookVector) > .1; 
end;
r39.setupHeartbeatProcessing = function(...)
    B = game;
    v = B.GetService(B, "RunService").Heartbeat;
    
    r39.AutoDodge.HeartbeatConnection = v.Connect(v, function(...)
        n = not r39.AutoDodge.Enabled;
        
        if n then
            return;
        end;
        
        d = r39.getLocalPlayer();
        
        if not d or not d.Character then
            return;
        end;
        
        if tick() - r39.AutoDodge.LastDodgeTime < r39.AutoDodge.DodgeCooldown then
            return;
        end;
        
        n = d.Character;
        
        if not n.FindFirstChild(n, "HumanoidRootPart") then
            return;
        end;
        
        u = game;
        
        N = u.GetService(u, "Players");
        u = {
            N.GetPlayers(N)
        };
        G = N[2];
        u = N[1];
        
        for j, c in pairs(w(u)) do
            N = j;
            r76 = c;
            
            if r76 == d then
                
            else
                if not r76.Character then
                    
                else
                    C = r76.Character;
                    
                    if not C.FindFirstChild(C, "HumanoidRootPart") then
                        
                    end;
                end;
            end; 
        end;
        
        return; 
    end);
    
    table.insert(r39.AutoDodge.Connections, r39.AutoDodge.HeartbeatConnection);
    
    return; 
end;
r39.setupPlayerCleanupTracking = function(...)
    n = game;
    
    d = n.GetService(n, "Players");
    N = d.GetPlayers;
    
    local function r77(arg1_40, arg2_40, ...)
        v = arg2_40;
        n = "FindFirstChild";
        r78 = arg1_40;
        
        n = v[n](v, "Humanoid");
        
        if n then
            n = n.Died;
            
            n.Once(n, function(...)
                G = r16;
                
                r39.AutoDodge.ActiveAnimations[r78.Name] = nil;
                r39.AutoDodge.LastAnimationStartTime[r78.Name] = nil;
                
                return; 
            end);
        end;
        
        return; 
    end;
    
    local function B(arg1_41, ...)
        r79 = arg1_41;
        n = r39.getLocalPlayer;
        
        if r79 == n() then
            return;
        end;
        
        if r79.Character then
            r77(r79, r79.Character);
        end;
        
        n = r79.CharacterAdded;
        
        table.insert(r39.AutoDodge.Connections, n.Connect(n, function(arg1_42, ...)
            r77(r79, arg1_42);
            
            return; 
        end));
        
        return; 
    end;
    
    u = {
        N(d)
    };
    j = N[3];
    u = N[1];
    
    for j, c in u, pairs(w(u)) do
        B(c);
        
        N = j; 
    end;
    
    n = d.PlayerAdded;
    
    table.insert(r39.AutoDodge.Connections, n.Connect(n, B));
    
    return; 
end;
r39.setupLeaveCleanup = function(...)
    n = game;
    
    r80 = r39.getLocalPlayer();
    
    if r80 then
        n = n.GetService(n, "Players").PlayerRemoving;
        
        table.insert(r39.AutoDodge.Connections, n.Connect(n, function(arg1_43, ...)
            d = arg1_43;
            
            if d == r80 then
                B = r15;
                
                r39.ToggleAutoDodge(false);
            else
                B = "AutoDodge";
                
                r39[B].ActiveAnimations[d.Name] = nil;
                r39.AutoDodge.LastAnimationStartTime[d.Name] = nil;
            end;
            
            return; 
        end));
    end;
    
    return; 
end;
r39.ToggleAutoDodge = function(arg1_44, ...)
    d = arg1_44;
    
    if d then
        if not r39.CanEnableToggle("HideAndSeek", "Auto Dodge", r35.AutoDodge) then
            return false;
        end;
    end;
    
    u = r39.AutoDodge;
    j = u.Connections;
    G = u[3];
    B = u[2];
    
    for G, N in pairs(k) do
        u = G;
        r81 = N;
        
        if r81 then
            pcall(function(...)
                n = r81;
                
                n.Disconnect(n);
                
                return; 
            end);
        end; 
    end;
    
    r39.AutoDodge.Enabled = false;
    r39.AutoDodge.Connections = {};
    r39.AutoDodge.ActiveAnimations = {};
    r39.AutoDodge.LastAnimationStartTime = {};
    r39.AutoDodge.LastDodgeTime = 0;
    r39.AutoDodge.HeartbeatConnection = nil;
    
    if d then
        r39.AutoDodge.Enabled = true;
        
        if not r39.AutoDodge.Remote then
            r39.setupRemoteHook();
        end;
        
        r39.setupPlayerCleanupTracking();
        r39.setupHeartbeatProcessing();
        r39.setupLeaveCleanup();
        r39.Notify("Auto Dodge", "Enabled", 3);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;

local v20 = {
    pcall(r39.setupRemoteHook)
};

r39.hookSuccess = pcall(r39.setupRemoteHook);
r39.hookError = v20[2];

if not r39.hookSuccess then
    r39.Notify("Warning", "Auto Dodge may not work properly", 5);
end;

r39.FreeGuardSettings = {
    ["Enabled"] = false,
    ["MaxCycles"] = 5,
    ["ButtonWaitTime"] = .6
};
r39.ToggleFreeGuard = function(arg1_45, ...)
    d = arg1_45;
    r82 = r35.FreeGuard;
    
    if d then
        if r39.IsXenoExecutor() then
            r39.Notify("Free Guard", "Not supported in your executor", 5);
            
            if r82 and r82.SetValue then
                pcall(function(...)
                    n = r82;
                    
                    n.SetValue(n, false);
                    
                    return; 
                end);
            end;
            
            return false;
        end;
    end;
    
    r39.FreeGuardSettings.Enabled = d;
    
    if d then
        r39.Notify("Free Guard", "Enabled", 2);
        
        n = r34;
        
        n.SetAttribute(n, "__OwnsPermGuard", true);
        
        local function r83(arg1_46, ...)
            d = arg1_46;
            n = not d;
            
            if n then
                return true;
            end;
            
            n = d.Name;
            n = "";
            B = false;
            
            if d.IsA(d, "TextButton") and d.Text then
                n = d.Text;
                
                B = n.lower(n);
            end;
            
            C = "temporary";
            c = C[3];
            N = C[2];
            
            for c, y in ipairs({
                "buy",
                "playable",
                "one.time",
                "onetime",
                C,
                "onetim",
                "time.playable",
                "time.guard",
                "playable.guard",
                "one.time.guard",
                "temporary.guard",
                "playable.one.time"
            }) do
                C = c;
                
                if string.find(n.lower(n) .. " " .. B, y) then
                    return true;
                else
                    
                end; 
            end;
            
            return false; 
        end;
        
        local function r84(arg1_47, ...)
            r85 = arg1_47;
            n = r34.PlayerGui;
            v = r86;
            
            local function r86(arg1_48, ...)
                n = {};
                d = arg1_48;
                n = pairs;
                u = d.GetChildren;
                j = {
                    u(d)
                };
                G = u[3];
                B = u[2];
                
                for G, N in n(w("pairs")) do
                    u = G;
                    
                    if N.IsA(N, "TextButton") or N.IsA(N, "ImageButton") then
                        c = true;
                        y = "skipBuy";
                        
                        if r85[y] then
                            n = N.Name;
                            n = string.find;
                            
                            y = n(n.lower(n), "buy");
                            
                            if N.IsA(N, "TextButton") and N.Text then
                                n = N.Text;
                                
                                if y then
                                    y = y;
                                    
                                    if y then
                                        c = false;
                                    end;
                                    
                                    if r85.name and N.Name ~= r85.name then
                                        c = false;
                                    end;
                                    
                                    R = "text";
                                    
                                    if r85[R] and (N.IsA(N, "TextButton") and N.Text) then
                                        y = N.Text;
                                        R = r85.text;
                                        
                                        if not string.find(y.lower(y), R.lower(R)) then
                                            c = false;
                                        end;
                                    end;
                                    
                                    n = N[r15[J]];
                                    
                                    if r85.color and N.BackgroundColor3 ~= r85.color then
                                        c = false;
                                    end;
                                    
                                    if true then
                                        table.insert(n, N);
                                    end;
                                    
                                    if #N.GetChildren(N) > 0 then
                                        J = m[1];
                                        R = m[2];
                                        
                                        for r, m in ipairs(r86(N)) do
                                            c = r;
                                            
                                            table.insert(n, m); 
                                        end;
                                    end;
                                else
                                    
                                    U = string.find(n.lower(n), "buy");
                                end;
                            end;
                        end;
                    end; 
                end;
                
                return n; 
            end;
            
            return r86(v); 
        end;
        
        local function r87(arg1_49, arg2_49, ...)
            r88 = arg1_49;
            r89 = arg2_49;
            n = r34.PlayerGui;
            B = r90;
            
            local function r90(arg1_50, arg2_50, ...)
                v = arg2_50;
                d = arg1_50;
                n = v > #r88;
                
                if n then
                    return nil;
                end;
                
                N = d.GetChildren;
                B = r88[v];
                u = {
                    N(d)
                };
                j = N[3];
                u = N[1];
                
                for j, c in u, pairs(w(u)) do
                    N = j;
                    y = r89;
                    C = "string";
                    
                    if y then
                        U = c.Name;
                        
                        C = string.find(U.lower(U), "buy");
                    end;
                    
                    if C then
                        
                    end;
                    
                    y = c.Name;
                    
                    if string.find(y.lower(y), B.lower(B)) then
                        C = #r88;
                        
                        if v == C then
                            return c;
                        else
                            
                            C = r90(c, v + 1);
                            
                            if C then
                                return C;
                            else
                                
                            end;
                        end;
                    else
                        C = #c.GetChildren(c);
                        
                        if C > 0 then
                            
                            C = r90(c, v);
                            
                            if C then
                                return C;
                            else
                                
                            end;
                        end;
                    end; 
                end;
                
                return nil; 
            end;
            
            return r90(B, 1); 
        end;
        
        local function r91(arg1_51, ...)
            r92 = arg1_51;
            n = not r92;
            
            if n then
                return false;
            end;
            
            n = r92.Name;
            n = "";
            B = n;
            G = r92;
            
            j = G.IsA(G, "TextButton");
            
            if j then
                k = r92.Text;
            end;
            
            if j then
                n = r92.Text;
                
                B = n.lower(n);
            end;
            
            N = string.find(n.lower(n) .. " " .. B, "buy");
            j = N;
            
            if N then
            end; 
        end;
        
        local function r93(...)
            n = 0;
            B = {};
            G = true[2];
            u = true[1];
            
            for j, c in ipairs(r84({
                ["color"] = Color3.fromRGB(0, 255, 0),
                ["skipBuy"] = true
            })) do
                N = j;
                
                if not r83(c) then
                    table.insert(B, c);
                end; 
            end;
            
            if #B == 0 then
                c = "skipBuy";
                u = c[2];
                N = c[3];
                
                for N, C in ipairs(r84({
                    ["text"] = "accept",
                    [c] = true
                })) do
                    c = N;
                    
                    if not r83(C) then
                        table.insert(B, C);
                    end; 
                end;
            end;
            
            if #B == 0 then
                c = "skipBuy";
                N = c[3];
                
                for N, C in c[1], ipairs(r84({
                    ["name"] = "Green",
                    [c] = true
                })) do
                    c = N;
                    
                    if not r83(C) then
                        table.insert(B, C);
                    end; 
                end;
            end;
            
            c = r15;
            
            G = r87({
                "HeaderPrompt",
                "Green"
            }, true);
            
            if G then
                j = not r83(G);
            end;
            
            if G then
                table.insert(B, G);
            end;
            
            n = #B > 0;
            
            if n then
                j = c[1];
                u = c[2];
                
                for N, C in ipairs(B) do
                    c = N;
                    
                    if r91(C) then
                        d = d + 1;
                    else
                        
                    end; 
                end;
            end;
            
            if n == 0 then
                return false;
            end;
            
            task.wait(r39.FreeGuardSettings.ButtonWaitTime);
            
            j = {};
            y = true[3];
            C = true[2];
            
            for y, x in ipairs(r84({
                ["name"] = "EquipTier1",
                ["skipBuy"] = true
            })) do
                N = y;
                
                if not r83(x) then
                    table.insert(j, x);
                end; 
            end;
            
            if #j == 0 then
                
                c = r87({
                    "RankSelection",
                    "EquipTier1"
                }, true);
                
                if c then
                    N = not r83(c);
                end;
                
                n = #B > 0;
                
                if c then
                    table.insert(j, c);
                end;
            end;
            
            if #j == 0 then
                U = "skipBuy";
                x = U[3];
                
                for x, U in U[1], ipairs(r84({
                    ["text"] = "tier1",
                    [U] = true
                })) do
                    N = x;
                    
                    if not r83(U) then
                        while not r84({
                            ["name"] = "EquipTier1",
                            [r15[e]] = true
                        }) do
                            
                            v, j = ({})(n, r84({
                                ["color"] = Color3.fromRGB(0, 255, 0),
                                ["skipBuy"] = true
                            }));
                            
                            if v then
                                
                                G = B(d, r84({
                                    ["color"] = Color3.fromRGB(0, 255, 0),
                                    ["skipBuy"] = true
                                }));
                                u = j.Name == "DalgonaClickPart" and j.IsA(j, "BasePart");
                            end;
                            
                            d = r39 and r39.Parent;
                            
                            if d then
                                n = r91;
                                
                                d = n.Create(n, r39, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                                    ["Transparency"] = 1
                                });
                                
                                d.Play(d);
                            end;
                            
                            d = r34 and r34.Parent;
                            
                            if d then
                                n = r91;
                                
                                d = n.Create(n, r34, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                                    ["Transparency"] = 1
                                });
                                
                                d.Play(d);
                            end;
                            
                            if X[K[9]] then
                                G = X[K[9]];
                                j = {
                                    G.GetDescendants(G)
                                };
                                B = G[3];
                                v = G[2];
                                
                                for B, j in pairs(w(j)) do
                                    G = B;
                                    u = "BasePart";
                                    
                                    if j.IsA(j, u) then
                                        n = r91;
                                        
                                        u = n.Create(n, j, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                                            ["Transparency"] = 1
                                        });
                                        
                                        u.Play(u);
                                    end; 
                                end;
                            end;
                            
                            if X[K[10]] then
                                n = r91;
                                
                                d = n.Create(n, X[K[11]], TweenInfo.new(2, Enum.EasingStyle.Quad), {
                                    ["CFrame"] = X[K[10]].CFrame * CFrame.new(.0841674805, 8.45438766, 6.69675446, .999918401, -0.00898250192, .00907994807, 3.31699681e-08, .710912943, .703280032, -0.0127722733, -0.703222632, .710854948)
                                });
                                
                                d.Play(d);
                            end;
                            
                            X[K[12]](X[K[13]]);
                            
                            n = X[K[14]];
                            
                            n.FireServer(n, {
                                ["Success"] = true
                            });
                            task.wait(2);
                            
                            j = r87;
                            N = r39;
                            B = j[3];
                            
                            for B, j in j[1], pairs({
                                j,
                                X[K[15]],
                                N,
                                r34,
                                X[K[16]]
                            }) do
                                G = B;
                                
                                if j then
                                    u = j.Parent;
                                end;
                                
                                if j then
                                    j.Destroy(j);
                                end; 
                            end;
                            
                            G = r83("\x90\x9f\x122\x8b\x1a\x0bK=\x88r9\xcf\x84E_", 9830631379425);
                            
                            X[K[17]][r16[G]] = true;
                            
                            v = X[K[18]];
                            d = v;
                            
                            if v then
                                n = 1;
                                
                                while 26414736371724 do
                                    
                                    y = J(U);
                                    
                                    while not y do
                                        
                                        u, N = G("\x90\x9f\x122\x8b\x1a\x0bK=\x88r9\xcf\x84E_", 9830631379425);
                                        
                                        if u then
                                            
                                            B = G(j, 9830631379425);
                                            
                                            if v - r84.Rebel.LastKillTime < r84.Rebel.KillCooldown then
                                                task.wait(r84.Rebel.KillCooldown - (v - r84.Rebel.LastKillTime));
                                            end;
                                            
                                            y = game;
                                            c = y.GetService(y, "Players").LocalPlayer.Character;
                                            x = game;
                                            m = 31550707743075;
                                            r = 10361233920728;
                                            
                                            J = r16("\xd0\xee\x9c\xa2\xa9\x84;\xba", r);
                                            C = x.GetService(x, "Players")[r15[r16("\x15Y\xc6d-\x1b\x08!A\xb0n", m)]][r15[J]];
                                            
                                            if c then
                                                r = c.GetChildren;
                                                R = {
                                                    r(c)
                                                };
                                                J = r[3];
                                                
                                                for J, R in r[1], pairs(w(R)) do
                                                    x = J;
                                                    n = n;
                                                    
                                                    if R.IsA(R, "Tool") and R.GetAttribute(R, "Gun") then
                                                        y = R;
                                                    else
                                                        
                                                    end; 
                                                end;
                                            end;
                                            
                                            U = n;
                                            e = not nil;
                                            
                                            if e then
                                                x = C;
                                            end;
                                            
                                            n = U;
                                            
                                            if e then
                                                m = {
                                                    pairs(C.GetChildren(C))
                                                };
                                                
                                                J, R = pairs(C.GetChildren(C))(m[2], m[3]);
                                                
                                                if J then
                                                    P = U;
                                                    
                                                    x = U(e, m[3]);
                                                    m = R.IsA(R, "Tool") and R.GetAttribute(R, "Gun");
                                                end;
                                            end;
                                        end;
                                        
                                        return; 
                                    end;
                                    
                                    o8 = 14358096927262;
                                    L = workspace;
                                    
                                    h = L.WaitForChild(L, "StairWalkWay");
                                    r94 = {
                                        y,
                                        {
                                            ["ClientRayNormal"] = Vector3.new(-1.1920928955078e-07, 1.0000001192093, 0),
                                            ["FiredGun"] = true,
                                            ["SecondaryHitTargets"] = {},
                                            ["ClientRayInstance"] = h.WaitForChild(h, "Part"),
                                            ["ClientRayPosition"] = Vector3.new(-220.17489624023, 183.29577636719, 301.07257080078),
                                            ["bulletCF"] = CFrame[r15[r16("\xfbl&", o8)]](-220.50398254395, 185.22506713867, 302.13354492188, .95511162281036, .2567310333252, -0.14782091975212, 7.4505814851022e-09, .49897986650467, .86661356687546, .29624626040459, -0.82771271467209, .47658145427704),
                                            ["HitTargets"] = {
                                                [N] = "Head"
                                            },
                                            ["bulletSizeC"] = Vector3.new(.0099999997764826, .0099999997764826, 4.4524998664856),
                                            ["NoMuzzleFX"] = false,
                                            ["FirePosition"] = Vector3.new(-72.88850402832, -679.48034667969, -173.31005859375)
                                        }
                                    };
                                    
                                    pcall(function(...)
                                        n = game;
                                        
                                        k = n.GetService(n, "ReplicatedStorage");
                                        n = k.WaitForChild(k, "Remotes");
                                        k = n.WaitForChild(n, "FiredGunClient");
                                        
                                        k.FireServer(k, unpack(r94));
                                        
                                        return; 
                                    end);
                                    
                                    r84.Rebel.LastKillTime = tick();
                                    
                                    task.wait(.05); 
                                end;
                            end;
                            
                            if d then
                                n = r91;
                                
                                d = n.Create(n, X[K[18]].Hotbar.Backpack, TweenInfo.new(1.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                                    ["Position"] = UDim2.new(0, 0, 0, 0)
                                });
                                
                                d.Play(d);
                            end;
                            
                            if X[K[16]] then
                                n = X[K[19]];
                                
                                if n then
                                    n = X[K[19]];
                                    
                                    n.Fire(n, X[K[16]], 2);
                                end;
                                
                                n = r91;
                                
                                d = n.Create(n, X[K[16]], TweenInfo.new(1.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                                    ["Position"] = UDim2.new(X[K[16]].Position.X.Scale, 0, X[K[16]].Position.Y.Scale + 1, 0)
                                });
                                
                                d.Play(d);
                            end;
                            
                            task.wait(0.5);
                            
                            X[K[20]] = false;
                            
                            X[K[11]].CameraType = Enum.CameraType.Custom;
                            
                            if X[K[21]] then
                                X[K[11]].CameraSubject = X[K[21]];
                                
                                break;
                            end;
                            
                            G = false;
                            
                            X[K[11]].FieldOfView = X[K[22]] or 70;
                            
                            return; 
                        end;
                        
                        n = r91;
                        
                        u = n.Create(n, j, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                            ["Transparency"] = 1
                        });
                        
                        u.Play(u);
                    else
                        
                    end; 
                end;
            end;
            
            if #j == 0 then
                U = r16;
                C = U[1];
                y = U[2];
                
                for x, U in ipairs(r84({
                    ["skipBuy"] = true
                })) do
                    N = x;
                    e = U.Name;
                    R = U.IsA(U, "TextButton") and U.Text;
                    n = #B > 0;
                    
                    if R then
                        R = U.Text;
                        
                        e = R.lower(R);
                    end;
                    
                    m = n;
                    R = string.find(e.lower(e), "tier1") or string.find("", "tier1");
                    
                    if R then
                        m = not r83(U);
                    end;
                    
                    n = m;
                    
                    if R then
                        table.insert(j, U);
                    end; 
                end;
            end;
            
            if #j > 0 then
                y = x[3];
                C = x[2];
                
                for y, x in ipairs(j) do
                    N = y;
                    
                    if r91(x) then
                        d = n + 1;
                    else
                        
                    end; 
                end;
            end;
            
            if n < 2 then
                return false;
            end;
            
            task.wait(r39.FreeGuardSettings.ButtonWaitTime);
            
            x = true[2];
            y = true[1];
            
            for e, J in ipairs(r84({
                ["color"] = Color3.fromRGB(0, 255, 0),
                ["skipBuy"] = true
            })) do
                C = e;
                
                if not r83(J) then
                    table.insert({}, J);
                end; 
            end;
            
            local function r95(arg1_52, ...)
                d = arg1_52;
                n = pairs;
                j = d.GetChildren;
                G = {
                    j(d)
                };
                v = j[2];
                G = j[1];
                
                for B, u in n(w(G)) do
                    J = "\xf5g\xd9\xe4\xb71;\xf1O\x9c";
                    x = "\x90\xbf\xfdn";
                    j = B;
                    n = u[r15[r16(x, 25104398101930)]];
                    
                    C = u.IsA(u, r15[r16(J, 7385886805359)]);
                    c = C;
                    
                    if C then
                        
                        J = string.find(n.lower(n), "green");
                        
                        if J then
                            n = n;
                            c = J and not r83(u);
                            n = n;
                            
                            if c then
                                return u;
                            else
                                c = #u.GetChildren(u);
                                
                                if c > 0 then
                                    
                                    c = r95(u);
                                    
                                    if c then
                                        return c;
                                    else
                                        
                                    end;
                                end;
                            end;
                        else
                            x = u.Name == "Green";
                        end;
                    end; 
                end;
                
                return nil; 
            end;
            
            e = r95(r34.PlayerGui);
            
            if e then
                r91(e);
            end;
            
            n = n;
            
            if e then
                d = n + 1;
                
                return true;
            end;
            
            R = r87({
                "RankConfirmation",
                "Green"
            }, true);
            
            if R then
                J = not r83(R) and r91(R);
                n = n;
            end;
            
            n = n;
            
            if R then
                d = n + 1;
                
                return true;
            end;
            
            W = r16("E\x07&Q\xfc\r\xda", 35131452096487);
            L = r15[W];
            i = L[2];
            D = L[1];
            
            for I, L in ipairs(r84({
                ["text"] = "confirm",
                [L] = true
            })) do
                m = I;
                W = not r83(L);
                
                if W then
                    r91(L);
                end;
                
                n = n;
                
                if W then
                    d = n + 1;
                    
                    return true;
                else
                    
                end; 
            end;
            
            return n > 2; 
        end;
        
        spawn(function(...)
            n = 0;
            d = n;
            n = r39.FreeGuardSettings.MaxCycles;
            
            for G = 1, n do
                N = G;
                
                if r39.FreeGuardSettings.Enabled then
                    if r93() then
                        d = d + 1;
                    end;
                else
                    
                end;
                
                r39.Notify("Free Guard", "Completed", 2);
                task.wait(2);
                
                r39.FreeGuardSettings.Enabled = false;
                
                if r82 and r82.SetValue then
                    pcall(function(...)
                        n = X[121];
                        
                        n.SetValue(n, false);
                        
                        return; 
                    end);
                end;
                
                return; 
            end;
            
            r39.Notify("Free Guard", "Completed", 2);
            task.wait(2);
            
            r39.FreeGuardSettings.Enabled = false;
            
            if n then
                k = r82.SetValue;
            end;
            
            if r82 and r82.SetValue then
                pcall(function(...)
                    n = X[121];
                    
                    n.SetValue(n, false);
                    
                    return; 
                end);
            end;
            
            return; 
        end);
    else
        r39.FreeGuardSettings.Enabled = false;
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.Fly = {
    ["Enabled"] = false,
    ["Speed"] = 45,
    ["Connection"] = nil,
    ["BodyVelocity"] = nil
};
r39.ToggleFly = function(arg1_53, arg2_53, ...)
    if arg1_53 then
        if r39.Fly.Enabled then
            return;
        end;
        
        r39.Fly.Enabled = true;
        
        r96 = r39.GetCharacter();
        
        if not r96 then
            return;
        end;
        
        G = r39.GetHumanoid(r96);
        n = r39.GetRootPart;
        u = not G;
        
        r97 = n(r96);
        
        if G then
            k = r97;
        end;
        
        n = u;
        
        if not G then
            return;
        end;
        
        n = r39.Fly.BodyVelocity;
        
        if n then
            n = r39.Fly.BodyVelocity;
            
            n.Destroy(n);
        end;
        
        r98 = Instance.new("BodyVelocity");
        
        r98.Name = "FlyBodyVelocity";
        r98.MaxForce = Vector3.new(40000, 40000, 40000);
        r98.Parent = r97;
        r39.Fly.BodyVelocity = r98;
        
        N = r29.Heartbeat;
        r39.Fly.Connection = N.Connect(N, function(...)
            C = "\xab\xf2\x12";
            
            if not r39[r15[r16(C, 9907151131141)]].Enabled or (not r96 or not r96.Parent) then
                r39.ToggleFly(false, true);
                
                return;
            end;
            
            r97 = r39.GetRootPart(r96);
            
            if not r97 or not r98 then
                r39.ToggleFly(false, true);
                
                return;
            end;
            
            d = workspace.CurrentCamera;
            
            if not d then
                return;
            end;
            
            v = Vector3.new(0, 0, 0);
            B = d.CFrame.LookVector;
            G = d.CFrame.RightVector;
            n = r30;
            
            if n.IsKeyDown(n, Enum.KeyCode.W) then
                v = Vector3.new(0, 0, 0) + B;
            end;
            
            j = r30;
            
            if j.IsKeyDown(j, Enum.KeyCode.S) then
                v = Vector3.new(0, 0, 0) - B;
            end;
            
            u = r30;
            
            if u.IsKeyDown(u, Enum.KeyCode.A) then
                v = Vector3.new(0, 0, 0) - G;
            end;
            
            N = r30;
            
            if N.IsKeyDown(N, Enum.KeyCode.D) then
                v = Vector3.new(0, 0, 0) + G;
            end;
            
            U = v.Magnitude > 0 and v.Unit * r39.Fly.Speed;
            n = n;
            
            if U then
                r98.Velocity = U;
                
                n = n;
                
                return;
            else
                
                y = Vector3.new(0, 0, 0);
            end; 
        end);
        
        if not arg2_53 then
            r39.Notify("Flight", "Enabled", 3);
        end;
    else
        if not r39.Fly.Enabled then
            return;
        end;
        
        r39.Fly.Enabled = false;
        
        if r39.Fly.Connection then
            n = r39.Fly.Connection;
            
            n.Disconnect(n);
            
            r39.Fly.Connection = nil;
        end;
        
        if r39.Fly.BodyVelocity then
            n = r39.Fly.BodyVelocity;
            
            n.Destroy(n);
            
            r39.Fly.BodyVelocity = nil;
        end;
        
        B = r39.GetCharacter();
        
        if B then
            
            G = r39.GetRootPart(B);
            
            if G then
                
                G.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            end;
        end;
        
        if not v then
        end;
        
        if not v then
            r39.PlayBell();
        end;
        
        return;
    end; 
end;
r39.SetFlySpeed = function(arg1_54, ...)
    r39.Fly.Speed = arg1_54;
    
    return; 
end;
r39.harmfulEffectsList = {
    "RagdollStun",
    "Stun",
    "Stunned",
    "StunEffect",
    "StunHit",
    "Knockback",
    "Knockdown",
    "Knockout",
    "Dazed",
    "Paralyzed",
    "Freeze",
    "Frozen",
    "Sleep",
    "Slow",
    "Slowed",
    "Root",
    "Rooted",
    "Crawling",
    "Crawled"
};
r39.RemoveStunEnabled = false;
r39.ToggleRemoveStun = function(arg1_55, ...)
    d = arg1_55;
    
    r39.RemoveStunEnabled = d;
    
    if d then
        local function r99(...)
            n = r39.GetCharacter;
            
            d = n();
            
            if not d then
                return;
            end;
            
            j = r39;
            G = j.harmfulEffectsList;
            B = j[3];
            G = j[1];
            
            for B, u in G, ipairs(G) do
                j = B;
                
                r100 = d.FindFirstChild(d, u);
                
                if r100 then
                    pcall(function(...)
                        n = r100;
                        
                        n.Destroy(n);
                        
                        return; 
                    end);
                end; 
            end;
            
            v = r39.GetHumanoid(d);
            
            if v then
                
                B = v.GetAttribute(v, "Stunned");
            end;
            
            if v then
                v.SetAttribute(v, "Stunned", false);
            end;
            
            return; 
        end;
        
        r99();
        
        n = r29.Heartbeat;
        
        n.Connect(n, function(...)
            B = r16;
            
            if r39.RemoveStunEnabled then
                r99();
            end;
            
            return; 
        end);
        r39.Notify("Remove Stun", "Enabled", 3);
    else
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.SpeedHackEnabled = false;
r39.SpeedValue = 39;
r39.SpeedHackLoop = nil;
r39.ToggleSpeedHack = function(arg1_56, ...)
    d = arg1_56;
    
    r39.SpeedHackEnabled = d;
    
    if d then
        if r39.SpeedHackLoop then
            task.cancel(r39.SpeedHackLoop);
        end;
        
        r39.SpeedHackLoop = task.spawn(function(...)
            
            G = r16("\x95\xf2\xc0\x96L\xa4\xe2p\"\x86\xfc\xf4\xd9\x95.0", 31299809245423);
            
            while r39[r15[G]] do
                if r39.GetCharacter() then
                    
                    v = r39.GetHumanoid(d);
                    k = "task";
                    
                    if v then
                        k = v.Health > 0;
                    end;
                    
                    if k then
                        v.WalkSpeed = r39.SpeedValue;
                    end;
                    
                    task.wait(.1);
                end; 
            end;
            
            return; 
        end);
        
        r39.Notify("SpeedHack", "Enabled - " .. r39.SpeedValue, 3);
    else
        if r39.SpeedHackLoop then
            task.cancel(r39.SpeedHackLoop);
            
            r39.SpeedHackLoop = nil;
        end;
        
        v = r39.GetCharacter();
        
        if v then
            
            B = r39.GetHumanoid(v);
            
            if B then
                B.WalkSpeed = 16;
            end;
        end;
        
        r39.PlayBell();
        
        return;
    end; 
end;
r39.SetSpeedValue = function(arg1_57, ...)
    
    r39.SpeedValue = math.min(arg1_57, 50);
    
    if r39.SpeedHackEnabled then
        
        v = r39.GetCharacter();
        
        if v then
            
            B = r39.GetHumanoid(v);
            
            if B then
                k = B.Health > 0;
            end;
            
            if B then
                B.WalkSpeed = r39.SpeedValue;
            end;
        end;
    end;
    
    return; 
end;
r39.FOVEnabled = false;
r39.FOVValue = 120;
r39.FOVConnection = nil;
r39.ToggleFOV = function(arg1_58, ...)
    d = arg1_58;
    
    if type(d) ~= "boolean" then
        d = not r39.FOVEnabled;
    end;
    
    r39.FOVEnabled = d;
    
    r101 = workspace.CurrentCamera;
    
    if d then
        r101.FieldOfView = r39.FOVValue;
        
        k = r39.FOVConnection;
        
        if k then
            k = r39.FOVConnection;
            
            k.Disconnect(k);
        end;
        
        G = r101;
        
        j = G.GetPropertyChangedSignal(G, "FieldOfView");
        r39.FOVConnection = j.Connect(j, function(...)
            
            u = r16("G\xf5\xbe\xd9\xbf\xf6\xeb\x0c\x14<", 10054889001546);
            
            if r39[r15[u]] and r101.FieldOfView ~= r39.FOVValue then
                r101.FieldOfView = r39.FOVValue;
            end;
            
            return; 
        end);
        
        r39.Notify("FOV", "Enabled - " .. r39.FOVValue, 3);
    else
        if r39.FOVConnection then
            k = r39.FOVConnection;
            
            k.Disconnect(k);
            
            r39.FOVConnection = nil;
        end;
        
        r101.FieldOfView = 70;
        
        r39.PlayBell();
        
        return;
    end; 
end;
r39.SetFOV = function(arg1_59, ...)
    
    r39.FOVValue = math.min(arg1_59, 120);
    
    if r39.FOVEnabled then
        workspace.CurrentCamera.FieldOfView = r39.FOVValue;
    end;
    
    return; 
end;
r39.AutoQTEMode = "Legit";
r39.AutoQTEEnabled = false;
r39.ToggleAutoQTE = function(arg1_60, ...)
    d = arg1_60;
    r102 = r35.AutoQTE;
    
    if d then
        if r39.IsXenoExecutor() then
            r39.Notify("Auto QTE", "Not supported in your executor", 5);
            
            if r102 and r102.SetValue then
                pcall(function(...)
                    n = r102;
                    
                    n.SetValue(n, false);
                    
                    return; 
                end);
            end;
            
            return false;
        end;
    end;
    
    r39.AutoQTEEnabled = d;
    
    if d then
        n = r34.PlayerGui;
        
        r103 = n.FindFirstChild(n, "ImpactFrames");
        n = r103;
        
        if n then
            r104 = {};
            n = r103.ChildAdded;
            
            n.Connect(n, function(arg1_61, ...)
                r105 = arg1_61;
                j = "Name";
                
                if r105[j] ~= "OuterRingTemplate" or r104[r105] then
                    return;
                end;
                
                r104[r105] = true;
                
                task.defer(function(...)
                    n = pairs;
                    G = r103;
                    B = G[3];
                    G = G[1];
                    
                    for B, u in G, n(G.GetChildren(G)) do
                        j = B;
                        
                        if u.Name == "InnerTemplate" and (u.Position == r105.Position and not u.GetAttribute(u, "Failed")) then
                            r106 = u;
                        else
                            
                        end; 
                    end;
                    
                    v = not r106 or (u.GetAttribute(u, "Tweening") or u.GetAttribute(u, "Failed"));
                    n = n;
                    
                    if v then
                        return;
                    end;
                    
                    r107 = require(r27.Modules.HBGQTE);
                    
                    if r39.AutoQTEMode == "Legit" then
                        pcall(function(...)
                            j = "\x9a5\x8a\xb8v\xc1\xa4";
                            
                            r107[r15[r16(j, 12536402089677)]](false, {
                                ["Inner"] = r106,
                                ["Outer"] = r105,
                                ["Duration"] = 2,
                                ["StartedAt"] = tick(),
                                ["Data"] = {}
                            });
                            
                            return; 
                        end);
                    else
                        pcall(function(...)
                            j = "v;\xde\xb6>\xba>";
                            
                            r107[r15[r16(j, 16107363229004)]](true, {
                                ["Inner"] = r106,
                                ["Outer"] = r105,
                                ["Duration"] = .1,
                                ["StartedAt"] = tick(),
                                ["Data"] = {}
                            });
                            
                            return; 
                        end);
                    end;
                    
                    return; 
                end);
                
                return; 
            end);
        end;
        
        r39.Notify("Auto QTE", "Enabled - " .. r39.AutoQTEMode .. " Mode", 3);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.SetAutoQTEMode = function(arg1_62, ...)
    r39.AutoQTEMode = arg1_62;
    
    return; 
end;
r39.TeleportUp = function(...)
    
    d = r39.GetCharacter();
    
    if d then
        
        v = r39.GetRootPart(d);
        
        if v then
            v.CFrame = v.CFrame + Vector3.new(0, 100, 0);
            
            r39.Notify("Teleport", "Up 100", 2);
        end;
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.TeleportDown = function(...)
    
    d = r39.GetCharacter();
    
    if d then
        
        v = r39.GetRootPart(d);
        
        if v then
            v.CFrame = v.CFrame + Vector3.new(0, -40, 0);
            
            r39.Notify("Teleport", "Down 40", 2);
        end;
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.GamePassStates = {
    ["PermanentGuard"] = false,
    ["GlassVision"] = false,
    ["EmotePages"] = false,
    ["CustomPlayerTag"] = false,
    ["PrivateServerPlus"] = false,
    ["FreeVIP"] = false,
    ["Lighter"] = false
};
r39.TogglePermanentGuard = function(arg1_63, ...)
    d = arg1_63;
    v = arg1_63;
    
    r39.GamePassStates.PermanentGuard = v;
    
    n = r34;
    
    n.SetAttribute(n, "__OwnsPermGuard", d);
    r39.PlayBell();
    
    return; 
end;
r39.ToggleGlassVision = function(arg1_64, ...)
    d = arg1_64;
    v = arg1_64;
    
    r39.GamePassStates.GlassVision = v;
    
    n = r34;
    
    n.SetAttribute(n, "__OwnsGlassManufacturerVision", d);
    r39.PlayBell();
    
    return; 
end;
r39.ToggleEmotePages = function(arg1_65, ...)
    d = arg1_65;
    v = arg1_65;
    
    r39.GamePassStates.EmotePages = v;
    
    n = r34;
    
    n.SetAttribute(n, "__OwnsEmotePages", d);
    r39.PlayBell();
    
    return; 
end;
r39.ToggleCustomPlayerTag = function(arg1_66, ...)
    d = arg1_66;
    v = arg1_66;
    
    r39.GamePassStates.CustomPlayerTag = v;
    
    n = r34;
    
    n.SetAttribute(n, "__OwnsCustomPlayerTag", d);
    r39.PlayBell();
    
    return; 
end;
r39.TogglePrivateServerPlus = function(arg1_67, ...)
    d = arg1_67;
    v = arg1_67;
    
    r39.GamePassStates.PrivateServerPlus = v;
    
    n = r34;
    
    n.SetAttribute(n, "__OwnsPSPlus", d);
    r39.PlayBell();
    
    return; 
end;
r39.ToggleFreeVIP = function(arg1_68, ...)
    d = arg1_68;
    v = arg1_68;
    
    r39.GamePassStates.FreeVIP = v;
    
    n = r34;
    
    n.SetAttribute(n, "__OwnsVIPGamepass", d);
    
    n = r34;
    
    n.SetAttribute(n, "VIPChatTag", d);
    
    n = r34;
    
    n.SetAttribute(n, "VIPJoinAlert", d);
    r39.PlayBell();
    
    return; 
end;
r39.ToggleLighter = function(arg1_69, ...)
    d = arg1_69;
    v = arg1_69;
    
    r39.GamePassStates.Lighter = v;
    
    n = r34;
    
    n.SetAttribute(n, "HasLighter", d);
    r39.PlayBell();
    
    return; 
end;
r39.HitboxEnabled = false;
r39.HitboxSize = 50;
r39.ModifiedParts = {};
r39.ToggleHitboxExpander = function(arg1_70, ...)
    d = arg1_70;
    
    r39.HitboxEnabled = d;
    
    if d then
        n = r29.Heartbeat;
        
        n.Connect(n, function(...)
            v = "HitboxEnabled";
            
            if not r39[v] then
                return;
            end;
            
            pcall(function(...)
                B = r26;
                d = B[2];
                B = B[1];
                
                for v, j in pairs(B.GetPlayers(B)) do
                    N = j ~= r34;
                    G = v;
                    
                    if N then
                        u = j.Character;
                    end;
                    
                    if N then
                        n = j.Character;
                        
                        u = n.FindFirstChild(n, "HumanoidRootPart");
                        
                        if u then
                            N = not r39.ModifiedParts[u];
                        end;
                        
                        if u then
                            r39.ModifiedParts[u] = {
                                ["Size"] = u.Size,
                                ["CanCollide"] = u.CanCollide,
                                ["Transparency"] = u.Transparency
                            };
                            
                            u.Size = Vector3.new(r39.HitboxSize, r39.HitboxSize, r39.HitboxSize);
                            u.CanCollide = false;
                            u.Transparency = 1;
                        end;
                    end; 
                end;
                
                return; 
            end);
            
            return; 
        end);
        r39.Notify("Hitbox", "Enabled - " .. r39.HitboxSize, 3);
    else
        j = r39;
        G = j.ModifiedParts;
        G = j[1];
        v = j[2];
        
        for B, u in pairs(G) do
            if B then
                N = B.Parent;
            end;
            
            if B then
                B.Size = u.Size;
                B.CanCollide = u.CanCollide;
                B.Transparency = u.Transparency;
            end; 
        end;
        
        r39.ModifiedParts = {};
        
        r39.PlayBell();
        
        return;
    end; 
end;
r39.SetHitboxSize = function(arg1_71, ...)
    d = arg1_71;
    v = arg1_71;
    
    r39.HitboxSize = v;
    
    G = r16;
    
    j = G("\n\x01\xd9M\xc6\xa9\x16\x1b\x81\x1e\x8f\xa1\xd3", 10738673210248);
    
    if r39[r15[j]] then
        j = r39;
        G = j.ModifiedParts;
        v = j[2];
        G = j[1];
        
        for B, u in pairs(G) do
            if B then
                N = B.Parent;
            end;
            
            if B then
                
                B.Size = Vector3.new(d, d, d);
            end; 
        end;
    end;
    
    return; 
end;
r39.RapidFireEnabled = false;
r39.OriginalFireRates = {};
r39.ToggleRapidFire = function(arg1_72, ...)
    d = arg1_72;
    
    r39.RapidFireEnabled = d;
    
    if d then
        n = r29.Heartbeat;
        
        n.Connect(n, function(...)
            v = "RapidFireEnabled";
            
            if not r39[v] then
                return;
            end;
            
            pcall(function(...)
                n = r27;
                d = "Weapons";
                
                d = n.FindFirstChild(n, d);
                
                if d then
                    
                    k = d.FindFirstChild(d, "Guns");
                end;
                
                if d then
                    G = d.Guns;
                    v = G[2];
                    G = G[1];
                    
                    for B, u in pairs(G.GetDescendants(G)) do
                        j = B;
                        
                        if u.Name == "FireRateCD" and u.IsA(u, "NumberValue") then
                            if not r39.OriginalFireRates[u] then
                                r39.OriginalFireRates[u] = u.Value;
                            end;
                            
                            u.Value = 0;
                        end; 
                    end;
                end;
                
                v = r39.GetCharacter();
                
                if v then
                    N = v.GetChildren;
                    G = N[2];
                    j = N[3];
                    
                    for j, N in pairs(N(v)) do
                        u = j;
                        
                        if N.IsA(N, "Tool") then
                            U = N.GetDescendants;
                            y = U[3];
                            
                            for y, U in U[1], pairs(U(N)) do
                                x = y;
                                
                                if U.Name == "FireRateCD" and U.IsA(U, "NumberValue") then
                                    if not r39.OriginalFireRates[U] then
                                        r39.OriginalFireRates[U] = U.Value;
                                    end;
                                    
                                    U.Value = 0;
                                end; 
                            end;
                        end; 
                    end;
                end;
                
                return; 
            end);
            
            return; 
        end);
        r39.Notify("Rapid Fire", "Enabled", 3);
    else
        j = r39;
        G = j.OriginalFireRates;
        v = j[2];
        G = j[1];
        
        for B, u in pairs(G) do
            if B then
                N = B.Parent;
            end;
            
            if B then
                B.Value = u;
            end; 
        end;
        
        r39.OriginalFireRates = {};
        
        r39.PlayBell();
        
        return;
    end; 
end;
r39.InfiniteAmmoEnabled = false;
r39.OriginalAmmo = {};
r39.ToggleInfiniteAmmo = function(arg1_73, ...)
    d = arg1_73;
    
    r39.InfiniteAmmoEnabled = d;
    
    if d then
        n = r29.Heartbeat;
        
        n.Connect(n, function(...)
            v = "InfiniteAmmoEnabled";
            
            if not r39[v] then
                return;
            end;
            
            pcall(function(...)
                j = "\xb5[\x9e\xd6S\xe9\x87Dp\x1b`9";
                
                G = r16(j, 11113286898743);
                d = r15[G];
                
                d = r39[d]();
                
                if d then
                    j = d.GetChildren;
                    G = {
                        j(d)
                    };
                    v = j[2];
                    G = j[1];
                    
                    for B, u in pairs(w(G)) do
                        j = B;
                        
                        if u.IsA(u, "Tool") then
                            x = u.GetDescendants;
                            C = x[3];
                            
                            for C, x in x[1], pairs(x(u)) do
                                y = C;
                                r = "NumberValue";
                                n = pairs;
                                
                                if (x.IsA(x, r) or x.IsA(x, "IntValue")) and r.find(r, "ammo") then
                                    if not r39.OriginalAmmo[x] then
                                        r39.OriginalAmmo[x] = x.Value;
                                    end;
                                    
                                    x.Value = math.huge;
                                end; 
                            end;
                        end; 
                    end;
                end;
                
                n = r34;
                
                v = n.FindFirstChild(n, "Backpack");
                
                if v then
                    N = v.GetChildren;
                    j = N[3];
                    
                    for j, N in N[1], pairs(N(v)) do
                        u = j;
                        
                        if N.IsA(N, "Tool") then
                            U = N.GetDescendants;
                            y = U[3];
                            C = U[2];
                            
                            for y, U in pairs(U(N)) do
                                x = y;
                                m = "NumberValue";
                                n = Env[c];
                                
                                if (U.IsA(U, m) or U.IsA(U, "IntValue")) and m.find(m, "ammo") then
                                    if not r39.OriginalAmmo[U] then
                                        r39.OriginalAmmo[U] = U.Value;
                                    end;
                                    
                                    U.Value = math.huge;
                                end; 
                            end;
                        end; 
                    end;
                end;
                
                return; 
            end);
            
            return; 
        end);
        r39.Notify("Infinite Ammo", "Enabled", 3);
    else
        j = r39;
        G = j.OriginalAmmo;
        G = j[1];
        v = j[2];
        
        for B, u in pairs(G) do
            if B then
                N = B.Parent;
            end;
            
            if B then
                B.Value = u;
            end; 
        end;
        
        r39.OriginalAmmo = {};
        
        r39.PlayBell();
        
        return;
    end; 
end;
r39.AutoNextEnabled = false;
r39.AutoNextConn = nil;

r39.TargetPos = Vector3.new(-214.3, 186.86, 242.64);
r39.Radius = 80;
r39.ToggleAutoNextGame = function(arg1_74, ...)
    d = arg1_74;
    v = arg1_74;
    
    r39.AutoNextEnabled = v;
    
    if r39.AutoNextConn then
        n = r39.AutoNextConn;
        
        n.Disconnect(n);
        
        r39.AutoNextConn = nil;
    end;
    
    if d then
        r108 = 0;
        B = r29.Heartbeat;
        
        r39.AutoNextConn = B.Connect(B, function(arg1_75, ...)
            j = r16;
            
            if not r39.AutoNextEnabled then
                return;
            end;
            
            v = r34.Character;
            B = v and v.PrimaryPart;
            
            if B then
                k = (B - r39.TargetPos).Magnitude <= r39.Radius;
            end;
            
            if B then
                r108 = r108 + arg1_75;
                
                if r108 >= 3.4 then
                    r108 = 0;
                    
                    pcall(function(...)
                        n = game;
                        u = 1970701714325;
                        
                        k = n.GetService(n, r15[r16("(\xbe[\x1al\xb1\x9e\x8b\xe1\xf0\xb2\xb1@\xf8*\xdd]", u)]);
                        n = k.WaitForChild(k, "Remotes");
                        k = n.WaitForChild(n, "TemporaryReachedBindable");
                        
                        k.FireServer(k);
                        
                        return; 
                    end);
                end;
            else
                r108 = 0;
            end;
            
            return; 
        end);
        
        r39.Notify("Auto Next Game", "Enabled", 3);
    else
    end;
    
    r39.PlayBell();
    
    return; 
end;

local r109 = false;
local r110 = {
    "DashRequest"
};

ToggleFreeDash = function(arg1_76, ...)
    d = arg1_76;
    r109 = d;
    
    if d then
        pcall(function(...)
            n = r27;
            B = r16;
            
            G = B(" \xe7\x19\x83\xfc\xae\x96", 27008926200097);
            
            d = n.FindFirstChild(n, r15[G]);
            
            if d then
                k = setrawmetatable;
            end;
            
            if d then
                G = r110;
                G = (" \xe7\x19\x83\xfc\xae\x96")[1];
                
                for B, u in ipairs(G) do
                    
                    N = d.FindFirstChild(d, u);
                    j = B;
                    
                    if N then
                        setrawmetatable(N, {
                            ["__index"] = function(...)
                                return function(...)
                                    return; 
                                end; 
                            end
                        });
                    end; 
                end;
            end;
            
            n = r34;
            
            v = n.FindFirstChild(n, "Boosts");
            
            if v then
                
                B = v.FindFirstChild(v, "Faster Sprint");
            end;
            
            if v then
                v["Faster Sprint"].Value = 6;
            end;
            
            return; 
        end);
        
        r39.Notify("Free Dash", "Enabled", 3);
    else
        pcall(function(...)
            n = r34;
            B = r16;
            
            d = n.FindFirstChild(n, "Boosts");
            
            if d then
                
                k = d.FindFirstChild(d, "Faster Sprint");
            end;
            
            if d then
                d["Faster Sprint"].Value = 1;
            end;
            
            return; 
        end);
    end;
    
    r39.PlayBell();
    
    return true; 
end;

r39.AmbienceEnabled = false;
r39.motionBlur = nil;
r39.blurAmount = 12;
r39.blurAmplifier = 12;
r39.lastVector = nil;
r39.originalTimeOfDay = nil;
r39.ambienceConnection = nil;
r39.timeFixConnection = nil;
r39.ToggleAmbience = function(arg1_77, ...)
    n = r39;
    d = arg1_77;
    
    n.AmbienceEnabled = d;
    
    if d then
        v = workspace.CurrentCamera;
        n = r39;
        
        n.lastVector = v.CFrame.LookVector;
        
        if r39.motionBlur and r39.motionBlur.Parent then
            n = r39.motionBlur;
            
            n.Destroy(n);
        end;
        
        r39.motionBlur = Instance.new("BlurEffect", v);
        
        n = game;
        r111 = n.GetService(n, "Lighting");
        
        r39.originalTimeOfDay = r111.TimeOfDay;
        r111.TimeOfDay = "22:00:00";
        
        n = r39.timeFixConnection;
        
        if n then
            n = r39.timeFixConnection;
            
            n.Disconnect(n);
        end;
        
        G = r111.Changed;
        
        r39.timeFixConnection = G.Connect(G, function(arg1_78, ...)
            
            u = r16("\xae:j)4\x11c\xd1\x16", 29052360570072);
            
            if arg1_78 == r15[u] and r39.AmbienceEnabled then
                r111.TimeOfDay = "22:00:00";
            end;
            
            return; 
        end);
        
        n = r39.ambienceConnection;
        
        if n then
            n = r39.ambienceConnection;
            
            n.Disconnect(n);
        end;
        
        G = r29.Heartbeat;
        
        r39.ambienceConnection = G.Connect(G, function(...)
            u = "\xc8\xf3\xb8=S6\xdbQ\xc8!\xb2\xa4%\xa6\\";
            
            if not r39[r15[r16(u, 16237109534088)]] then
                return;
            end;
            
            d = workspace.CurrentCamera;
            
            if not d then
                return;
            end;
            
            if not r39.motionBlur or r39.motionBlur.Parent == nil then
                
                r39.motionBlur = Instance.new("BlurEffect", d);
            end;
            
            v = d.CFrame.LookVector;
            
            r39.motionBlur.Size = math.abs((v - r39.lastVector).magnitude) * r39.blurAmount * r39.blurAmplifier / 2;
            r39.lastVector = v;
            
            return; 
        end);
        
        n = workspace.Changed;
        
        n.Connect(n, function(arg1_79, ...)
            G = r15;
            
            if arg1_79 == "CurrentCamera" and r39.AmbienceEnabled then
                v = workspace.CurrentCamera;
                B = r39.motionBlur;
                
                if B and r39.motionBlur.Parent then
                    B = n;
                    
                    r39.motionBlur.Parent = B;
                else
                    
                    r39.motionBlur = Instance.new("BlurEffect", v);
                end;
            end;
            
            return; 
        end);
    else
        if r39.motionBlur then
            n = r39.motionBlur;
            
            n.Destroy(n);
            
            r39.motionBlur = nil;
        end;
        
        if r39.ambienceConnection then
            n = r39.ambienceConnection;
            
            n.Disconnect(n);
            
            r39.ambienceConnection = nil;
        end;
        
        if r39.timeFixConnection then
            n = r39.timeFixConnection;
            
            n.Disconnect(n);
            
            r39.timeFixConnection = nil;
        end;
        
        n = game;
        
        if r39.originalTimeOfDay then
            n.GetService(n, "Lighting").TimeOfDay = r39.originalTimeOfDay;
        end;
        
        r39.PlayBell();
        
        return;
    end; 
end;
r39.ExitDoorESPEnabled = false;
r39.ExitDoorESPThread = nil;
r39.ExitDoorESPObjects = {};
r39.ToggleExitDoorESP = function(arg1_80, ...)
    d = arg1_80;
    
    r39.ExitDoorESPEnabled = d;
    
    if d then
        if r39.ExitDoorESPThread then
            task.cancel(r39.ExitDoorESPThread);
        end;
        
        r39.ExitDoorESPThread = task.spawn(function(...)
            r112 = {};
            
            local function r113(arg1_81, ...)
                d = arg1_81;
                G = "Instance";
                
                n = d.GetBoundingBox(d);
                v = {
                    ["box"] = G,
                    ["billboard"] = j,
                    ["part"] = G.Adornee
                };
                G = Env[G].new("BoxHandleAdornment");
                
                G.Adornee = d.PrimaryPart or d.FindFirstChildWhichIsA(d, "BasePart");
                
                if not G.Adornee then
                    return nil;
                end;
                
                k = v[2];
                
                G.Size = k;
                
                G.Color3 = Color3.fromRGB(255, 255, 0);
                G.Transparency = 0.5;
                G.AlwaysOnTop = true;
                G.ZIndex = 10;
                G.Parent = G.Adornee;
                j = Instance.new("BillboardGui");
                
                j.Adornee = G.Adornee;
                j.Size = UDim2.new(0, 100, 0, 50);
                j.StudsOffset = Vector3.new(0, 3, 0);
                j.AlwaysOnTop = true;
                j.Parent = G.Adornee;
                u = Instance.new("TextLabel");
                u.Size = UDim2.new(1, 0, 1, 0);
                u.BackgroundTransparency = 1;
                u.Text = "EXIT DOOR";
                u.TextColor3 = Color3.fromRGB(255, 255, 0);
                u.TextScaled = true;
                u.Font = Enum.Font.SourceSansBold;
                u.Parent = j;
                
                return {
                    ["box"] = G,
                    ["billboard"] = j,
                    ["part"] = G.Adornee
                }; 
            end;
            
            G = r15;
            
            while r39.ExitDoorESPEnabled do
                j = r112;
                G = u[3];
                j = u[1];
                
                for G, N in j, pairs(j) do
                    u = G;
                    r114 = N;
                    
                    if X[n].box and not X[n].part then
                        pcall(function(...)
                            n = X[n].box;
                            
                            n.Destroy(n);
                            
                            return; 
                        end);
                        pcall(function(...)
                            n = X[n].billboard;
                            
                            n.Destroy(n);
                            
                            return; 
                        end);
                    end; 
                end;
                
                n = workspace;
                
                B = n.FindFirstChild(n, "HideAndSeekMap");
                
                if B then
                    local function r115(arg1_82, ...)
                        d = arg1_82;
                        j = d.GetChildren;
                        n = pairs;
                        G = {
                            j(d)
                        };
                        B = j[3];
                        G = j[1];
                        
                        for B, u in G, n(w(G)) do
                            j = B;
                            
                            if u.Name == "EXITDOOR" and u.GetAttribute(u, "ActuallyWorks") == true then
                                if not r112[u] then
                                    
                                    N = r113(u);
                                    
                                    if N then
                                        
                                        c = n(u);
                                        
                                        r112[u] = c;
                                    end;
                                end;
                            end;
                            
                            r115(u); 
                        end;
                        
                        return; 
                    end;
                    
                    r115(B);
                end;
                
                task.wait(0.5); 
            end;
            
            return; 
        end);
        
        r39.Notify("Exit Door ESP", "Enabled", 3);
    else
        if r39.ExitDoorESPThread then
            task.cancel(r39.ExitDoorESPThread);
            
            r39.ExitDoorESPThread = nil;
        end;
        
        r39.PlayBell();
        
        return;
    end; 
end;
r39.ESP = {
    ["Enabled"] = false,
    ["Connection"] = nil,
    ["Folder"] = nil,
    ["TrailParts"] = {},
    ["TrailConnection"] = nil,
    ["TrailLastPos"] = nil,
    ["TrailLastMoveTime"] = 0,
    ["TrailWasMoving"] = false
};
r39.CreateTrailPart = function(arg1_83, arg2_83, ...)
    
    B = Instance.new("Part");
    B.Size = Vector3.new(1, .4, .7);
    B.CFrame = CFrame.new(arg1_83) * CFrame.Angles(0, arg2_83, 0);
    B.Anchored = true;
    B.CanCollide = false;
    B.CastShadow = false;
    B.Material = Enum.Material.Neon;
    B.Color = Color3.fromRGB(0, 150, 255);
    B.Transparency = 0;
    G = Instance.new("PointLight");
    G.Color = Color3.fromRGB(0, 150, 255);
    G.Range = 3;
    G.Brightness = 1.2;
    G.Parent = B;
    B.Parent = workspace;
    
    return B; 
end;
r39.ClearTrail = function(...)
    G = r39.ESP;
    B = G.TrailParts;
    d = G[2];
    v = G[3];
    
    for v, j in ipairs(k) do
        G = v;
        r116 = j;
        
        if X[n] and X[n].Parent then
            pcall(function(...)
                n = X[n];
                
                n.Destroy(n);
                
                return; 
            end);
        end; 
    end;
    
    r39.ESP.TrailParts = {};
    
    return; 
end;
r39.IsPlayerMoving = function(...)
    
    d = r39.GetCharacter();
    
    if not d then
        return false;
    end;
    
    v = r39.GetRootPart(d);
    
    if not v then
        return false;
    end;
    
    B = v.Velocity;
    
    return math.sqrt(B.X ^ 2 + B.Z ^ 2) > 1.5; 
end;
r39.AddTrail = function(arg1_84, arg2_84, ...)
    v = arg2_84;
    d = arg1_84;
    G = v.CFrame.LookVector * -0.5;
    
    table.insert(r39.ESP.TrailParts, 1, r39.CreateTrailPart(Vector3.new(d.X + G.X, d.Y - .3, d.Z + G.Z), math.rad(v.Orientation.Y)));
    
    if #r39.ESP.TrailParts > 30 then
        
        r117 = table.remove(r39.ESP.TrailParts);
        
        if r117 then
            pcall(function(...)
                n = r117;
                
                n.Destroy(n);
                
                return; 
            end);
        end;
    end;
    
    return; 
end;
r39.StartTrail = function(...)
    n = r39.ESP.TrailConnection;
    
    if n then
        n = r39.ESP.TrailConnection;
        
        n.Disconnect(n);
    end;
    
    d = r29.Heartbeat;
    
    r39.ESP.TrailConnection = d.Connect(d, function(...)
        B = "ESP";
        
        if not r39[B].Enabled then
            return;
        end;
        
        d = r39.GetCharacter();
        
        if not d then
            return;
        end;
        
        v = r39.GetRootPart(d);
        
        if not v then
            return;
        end;
        
        j = v.Position;
        
        if r39.IsPlayerMoving() then
            
            u = tick();
            
            r39.ESP.TrailLastMoveTime = u;
            
            if not r39.ESP.TrailLastPos or (j - r39.ESP.TrailLastPos).Magnitude > .35 then
                r39.AddTrail(j, v);
                
                r39.ESP.TrailLastPos = j;
            end;
            
            r39.ESP.TrailWasMoving = true;
        else
            if r39.ESP.TrailWasMoving and tick() - r39.ESP.TrailLastMoveTime >= .4 then
                r39.ClearTrail();
                
                r39.ESP.TrailWasMoving = false;
                r39.ESP.TrailLastPos = nil;
            end;
            
            return;
        end; 
    end);
    
    return; 
end;
r39.StopTrail = function(...)
    if r39.ESP.TrailConnection then
        n = r39.ESP.TrailConnection;
        
        n.Disconnect(n);
        
        r39.ESP.TrailConnection = nil;
    end;
    
    r39.ClearTrail();
    
    r39.ESP.TrailWasMoving = false;
    r39.ESP.TrailLastPos = nil;
    
    return; 
end;
r39.ToggleESP = function(arg1_85, ...)
    d = arg1_85;
    v = arg1_85;
    
    r39.ESP.Enabled = v;
    
    if r39.ESP.Connection then
        n = r39.ESP.Connection;
        
        n.Disconnect(n);
        
        r39.ESP.Connection = nil;
    end;
    
    if r39.ESP.Folder then
        pcall(function(...)
            v = "ESP";
            n = r39[v].Folder;
            
            n.Destroy(n);
            
            return; 
        end);
        
        r39.ESP.Folder = nil;
    end;
    
    if not d then
        r39.StopTrail();
        r39.PlayBell();
        
        return;
    end;
    
    r39.StartTrail();
    r39.ESP.Folder = Instance.new("Folder");
    r39.ESP.Folder.Name = "HollyScriptX";
    r39.ESP.Folder.Parent = r31;
    
    r118 = {};
    B = r29.RenderStepped;
    r39.ESP.Connection = B.Connect(B, function(...)
        j = r16;
        
        if not r39.ESP.Enabled then
            return;
        end;
        
        d = {};
        G = r26;
        v = G[2];
        G = G[1];
        
        for B, u in pairs(G.GetPlayers(G)) do
            r119 = u;
            j = B;
            N = r119;
            
            if N ~= r34 then
                d[r119] = true;
                
                C = r15;
                N = r119.Character;
                
                if N then
                    c = N.FindFirstChild(N, "HumanoidRootPart") and n.FindFirstChild(n, "Humanoid");
                    n = n;
                end;
                
                if N then
                    C = N.Humanoid;
                    
                    J = r16("~\x89FP\x8f)", 6565543971825);
                    y = C[r15[J]];
                    x = 0;
                    
                    if y > x then
                        if not r118[r119] then
                            
                            y = Instance.new("Highlight");
                            
                            y.FillTransparency = .85;
                            y.OutlineTransparency = .2;
                            y.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                            y.Parent = r39.ESP.Folder;
                            x = Instance.new("BillboardGui");
                            x.Size = UDim2.new(0, 140, 0, 50);
                            x.StudsOffset = Vector3.new(0, 2.5, 0);
                            x.AlwaysOnTop = true;
                            x.Parent = r39.ESP.Folder;
                            U = Instance.new("TextLabel");
                            U.Size = UDim2.new(1, 0, .4, 0);
                            U.BackgroundTransparency = 1;
                            U.TextSize = 11;
                            U.Font = Enum.Font.GothamBold;
                            U.TextStrokeTransparency = .2;
                            U.TextXAlignment = Enum.TextXAlignment.Left;
                            U.Parent = x;
                            e = Instance.new("Frame");
                            e.Size = UDim2.new(.45, 0, .07, 0);
                            e.Position = UDim2.new(0, 0, .48, 0);
                            e.BackgroundColor3 = Color3.fromRGB(35, 35, 40);
                            e.BorderSizePixel = 0;
                            e.Parent = x;
                            J = Instance.new("UICorner");
                            J.CornerRadius = UDim.new(0, 3);
                            J.Parent = e;
                            R = Instance.new("Frame");
                            R.Size = UDim2.new(1, 0, 1, 0);
                            R.BackgroundColor3 = Color3.fromRGB(130, 230, 160);
                            R.BorderSizePixel = 0;
                            R.Parent = e;
                            r = Instance.new("UICorner");
                            r.CornerRadius = UDim.new(0, 3);
                            r.Parent = R;
                            
                            r118[r119] = {
                                ["Highlight"] = y,
                                ["Billboard"] = x,
                                ["Name"] = U,
                                ["HpFill"] = R
                            };
                        end;
                        
                        y = r118[r119];
                        
                        x = Color3.fromRGB(210, 215, 220);
                        
                        if r39.IsGameActive("HideAndSeek") then
                            if r39.IsHider(r119) then
                                Color3.fromRGB(100, 150, 255);
                            else
                                if r39.IsSeeker(r119) then
                                    Color3.fromRGB(245, 130, 130);
                                end;
                            end;
                        end;
                        
                        R = n;
                        
                        y.Highlight.Adornee = R;
                        
                        R = Color3.fromRGB(210, 215, 220);
                        
                        y.Highlight.FillColor = R;
                        y.Highlight.OutlineColor = x;
                        y.Highlight.Enabled = true;
                        
                        R = N.HumanoidRootPart;
                        
                        y.Billboard.Adornee = R;
                        y.Billboard.Enabled = true;
                        y.Name.Text = r119.DisplayName or r119.Name;
                        y.Name.TextColor3 = x;
                        
                        J = C.Health / C.MaxHealth;
                        y.HpFill.Size = UDim2.new(J, 0, 1, 0);
                        
                        if J > .6 then
                            
                            y.HpFill.BackgroundColor3 = Color3.fromRGB(130, 230, 160);
                        else
                            if C.Health / C.MaxHealth > .3 then
                                
                                y.HpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100);
                            else
                                
                                y.HpFill.BackgroundColor3 = Color3.fromRGB(245, 130, 130);
                            end;
                        end;
                    else
                        if r118[r119] then
                            pcall(function(...)
                                r118[r119].Highlight.Enabled = false;
                                r118[r119].Billboard.Enabled = false;
                                
                                return; 
                            end);
                        end;
                    end;
                end;
            end; 
        end;
        
        B = u[2];
        v = u[1];
        
        for G, u in pairs(r118) do
            r120 = u;
            u = 97;
            
            if not d[G] then
                pcall(function(...)
                    n = r120.Highlight;
                    
                    n.Destroy(n);
                    
                    return; 
                end);
                pcall(function(...)
                    n = r120.Billboard;
                    
                    n.Destroy(n);
                    
                    return; 
                end);
                
                r118[G] = nil;
            end; 
        end;
        
        return; 
    end);
    
    r39.PlayBell();
    
    return; 
end;
r39.AutoSafe = {
    ["Enabled"] = false,
    ["Connection"] = nil,
    ["HasTeleported"] = false,
    ["LowHPChecked"] = false
};
r39.ToggleAutoSafe = function(arg1_86, ...)
    d = arg1_86;
    
    if r39.AutoSafe.Connection then
        n = r39.AutoSafe.Connection;
        
        n.Disconnect(n);
        
        r39.AutoSafe.Connection = nil;
    end;
    
    v = arg1_86;
    
    r39.AutoSafe.Enabled = v;
    r39.AutoSafe.HasTeleported = false;
    r39.AutoSafe.LowHPChecked = false;
    
    if d then
        v = r29.Heartbeat;
        
        r39.AutoSafe.Connection = v.Connect(v, function(...)
            G = r15;
            
            if not r39.AutoSafe.Enabled then
                if r39.AutoSafe.Connection then
                    n = r39.AutoSafe.Connection;
                    
                    n.Disconnect(n);
                    
                    r39.AutoSafe.Connection = nil;
                end;
                
                return;
            end;
            
            j = "SkySquidGame";
            n = pairs;
            B = j[2];
            j = j[1];
            
            for G, N in n({
                "Mingle",
                "JumpRope",
                "Pentathlon",
                "GlassBridge",
                "SquidGame",
                j,
                "TugOfWar"
            }) do
                u = G;
                
                if r39.IsGameActive(N) then
                    v = true;
                else
                    
                end; 
            end;
            
            if false then
                return;
            end;
            
            B = r39.GetCharacter;
            
            G = B();
            
            if G then
                
                B = G.FindFirstChildOfClass(G, "Humanoid");
                
                if B then
                    c = r15;
                    
                    u = r39.IsGameActive("RedLightGreenLight");
                    
                    if u then
                        if B.Health <= 35 then
                            if not r39.AutoSafe.HasTeleported then
                                j = G.FindFirstChild(G, "HumanoidRootPart") or G.PrimaryPart;
                                n = pairs;
                                
                                if j then
                                    u = j.Position;
                                    
                                    j.CFrame = CFrame.new(Vector3.new(u.X, u.Y + 100, u.Z));
                                    r39.AutoSafe.HasTeleported = true;
                                    r39.AutoSafe.LowHPChecked = true;
                                    
                                    r39.Notify("AutoSafe", "Saved from Red Light!", 2);
                                end;
                            end;
                        else
                            n = pairs;
                            
                            if B.Health > 35 and r39.AutoSafe.HasTeleported then
                                r39.AutoSafe.HasTeleported = false;
                            end;
                        end;
                    else
                        u = pairs;
                        
                        c = r39.IsGameActive("HideAndSeek");
                        
                        if c then
                            n = u;
                            
                            if c then
                                if B.Health <= 30 then
                                    if not r39.AutoSafe.HasTeleported then
                                        j = G.FindFirstChild(G, "HumanoidRootPart") or G.PrimaryPart;
                                        n = n;
                                        
                                        if j then
                                            u = j.Position;
                                            
                                            j.CFrame = CFrame.new(Vector3.new(u.X, u.Y + 150, u.Z));
                                            r39.AutoSafe.HasTeleported = true;
                                            r39.AutoSafe.LowHPChecked = true;
                                            
                                            r39.Notify("AutoSafe", "Auto-saved!", 2);
                                        end;
                                    end;
                                else
                                    n = n;
                                    
                                    if B.Health > 30 and r39.AutoSafe.HasTeleported then
                                        r39.AutoSafe.HasTeleported = false;
                                    end;
                                end;
                            else
                                if B.Health <= 30 then
                                    if not r39.AutoSafe.HasTeleported then
                                        j = G.FindFirstChild(G, "HumanoidRootPart") or G.PrimaryPart;
                                        n = n;
                                        
                                        if j then
                                            u = j.Position;
                                            
                                            j.CFrame = CFrame.new(Vector3.new(u.X, u.Y + 100, u.Z));
                                            r39.AutoSafe.HasTeleported = true;
                                            r39.AutoSafe.LowHPChecked = true;
                                            
                                            r39.Notify("AutoSafe", "Auto-saved!", 2);
                                        end;
                                    end;
                                else
                                    n = n;
                                    
                                    if G.FindFirstChildOfClass(G, j).Health > 30 and r39.AutoSafe.HasTeleported then
                                        r39.AutoSafe.HasTeleported = false;
                                    end;
                                    
                                    return;
                                end;
                            end;
                        end;
                    end;
                end;
            end; 
        end);
        
        r39.Notify("AutoSafe", "Enabled", 2);
    else
    end;
    
    return; 
end;
r39.Dalgona_Lighter = function(...)
    if r39.IsGameActive("Dalgona") then
        n = r34;
        
        n.SetAttribute(n, "HasLighter", true);
        r39.Notify("Dalgona", "Lighter Unlocked", 2);
    else
        r39.Notify("Dalgona", "Wait for Dalgona!", 2);
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.JR_TP_Start = function(...)
    if r39.IsGameActive("JumpRope") then
        r39.SafeTeleport(Vector3.new(615.284424, 192.274277, 920.952515));
        r39.Notify("JumpRope", "Teleported to Start", 2);
    else
        r39.Notify("JumpRope", "Wait for JumpRope!", 2);
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.JR_TP_End = function(...)
    if r39.IsGameActive("JumpRope") then
        r39.SafeTeleport(Vector3.new(720.896057, 198.628311, 921.170654));
        r39.Notify("JumpRope", "Teleported to End", 2);
    else
        r39.Notify("JumpRope", "Wait for JumpRope!", 2);
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.JR_DeleteRope = function(...)
    if r39.IsGameActive("JumpRope") then
        B = workspace;
        v = B[3];
        B = B[1];
        
        for v, j in B, pairs(B.GetDescendants(B)) do
            G = v;
            
            if j.Name == "Rope" and j.IsA(j, "Model") then
                j.Destroy(j);
                r39.Notify("JumpRope", "Rope deleted", 2);
                r39.PlayBell();
                
                return;
            else
                
            end; 
        end;
        
        r39.Notify("JumpRope", "Rope not found", 2);
    else
        r39.Notify("JumpRope", "Wait for JumpRope!", 2);
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.JumpRopeAntiFall = {
    ["Enabled"] = false,
    ["Platform"] = nil,
    ["Conn"] = nil
};
r39.ToggleJumpRopeAntiFall = function(arg1_87, ...)
    d = arg1_87;
    
    if d then
        if not r39.CanEnableToggle("JumpRope", "Anti Fall", r35.JumpRopeAntiFall) then
            return false;
        end;
    end;
    
    n = r39.JumpRopeAntiFall.Conn;
    
    if n then
        n = r39.JumpRopeAntiFall.Conn;
        
        n.Disconnect(n);
    end;
    
    n = r39.JumpRopeAntiFall.Platform;
    
    if n then
        n = r39.JumpRopeAntiFall.Platform;
        
        n.Destroy(n);
    end;
    
    r39.JumpRopeAntiFall.Enabled = d;
    
    if d then
        local function r121(...)
            n = r39.GetCharacter;
            
            d = n();
            
            if not d then
                return nil;
            end;
            
            v = r39.GetRootPart(d);
            
            if not v then
                return nil;
            end;
            
            B = Instance.new("Part");
            
            B.Name = "JumpRopeAntiFall";
            B.Size = Vector3.new(10000, 1, 10000);
            B.Position = Vector3.new(v.Position.X, v.Position.Y - 5, v.Position.Z);
            B.Anchored = true;
            B.CanCollide = true;
            B.Transparency = 1;
            B.Parent = workspace;
            
            return B; 
        end;
        
        r39.JumpRopeAntiFall.Platform = r121();
        
        G = r29.Heartbeat;
        
        r39.JumpRopeAntiFall.Conn = G.Connect(G, function(...)
            
            u = r16("Gu\x0b\xdbv\xb9\xa2V\x11P\xd1\xd8\xf9+\"\x82", 20147655894181);
            
            if not r39[r15[u]].Enabled then
                return;
            end;
            
            n = not r39.IsGameActive("JumpRope");
            
            if n then
                r39.DisableToggle("JumpRopeAntiFall");
                
                return;
            end;
            
            n = n;
            
            if not (r39.JumpRopeAntiFall.Platform and r39.JumpRopeAntiFall.Platform.Parent) then
                
                r39.JumpRopeAntiFall.Platform = r121();
            end;
            
            return; 
        end);
        
        r39.Notify("AntiFall", "Enabled", 3);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.GB_TP_End = function(...)
    if r39.IsGameActive("GlassBridge") then
        r39.SafeTeleport(Vector3.new(-196.372467, 522.192139, -1534.20984));
        r39.Notify("GlassBridge", "Teleported to End", 2);
    else
        r39.Notify("GlassBridge", "Wait for GlassBridge!", 2);
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.GlassESPEnabled = false;
r39.GlassESPTransparency = 60;
r39.ToggleGlassESP = function(arg1_88, ...)
    d = arg1_88;
    
    if d then
        if not r39.CanEnableToggle("GlassBridge", "Glass ESP", r35.GlassESP) then
            return false;
        end;
    end;
    
    r39.GlassESPEnabled = d;
    
    if d then
        local function r122(...)
            d = r28;
            d = d.FindFirstChild(d, "GlassBridge") and d.FindFirstChild(d, "GlassHolder");
            n = not d;
            
            if n then
                return;
            end;
            
            j = d.GetChildren;
            G = {
                j(d)
            };
            v = j[2];
            G = j[1];
            
            for B, u in pairs(w(G)) do
                x = u.GetChildren;
                j = B;
                c = x[2];
                C = x[3];
                
                for C, x in pairs(x(u)) do
                    y = C;
                    
                    if x.IsA(x, "Model") then
                        r = x.GetDescendants;
                        J = r[3];
                        
                        for J, r in r[1], pairs(r(x)) do
                            i = r15;
                            R = J;
                            
                            P = r.IsA(r, "BasePart");
                            
                            if P and r.GetAttribute(r, "GlassPart") then
                                m = r.GetAttribute(r, "ActuallyKilling") == true;
                                P = r.GetAttribute(r, "DelayedGlass") == true;
                                i = r.GetAttribute(r, "DelayedTime") or 0;
                                
                                r.Transparency = .6;
                                r.Material = Enum.Material.Neon;
                                
                                if r.GetAttribute(r, "DelayedKilling") == true then
                                    
                                    r.Color = Color3.fromRGB(255, 165, 0);
                                else
                                    if P then
                                        I = i > 0;
                                    end;
                                    
                                    n = r.GetAttribute(r, "DelayedKilling") == true;
                                    
                                    if P then
                                        if i <= 2 then
                                            
                                            r.Color = Color3.fromRGB(255, 200, 0);
                                        else
                                            if i <= 4 then
                                                
                                                r.Color = Color3.fromRGB(255, 215, 0);
                                            else
                                                
                                                r.Color = Color3.fromRGB(255, 255, 0);
                                            end;
                                        end;
                                    else
                                        if r.GetAttribute(r, "ActuallyKilling") == true then
                                            
                                            r.Color = Color3.fromRGB(255, 0, 0);
                                        else
                                            
                                            r.Color = Color3.fromRGB(0, 255, 0);
                                        end;
                                    end;
                                end;
                            end; 
                        end;
                    end; 
                end; 
            end;
            
            return; 
        end;
        
        r122();
        
        G = r29.Heartbeat;
        
        r39.GlassESPConnection = G.Connect(G, function(...)
            u = 32278961715895;
            
            if r39[r15[r16("?\xb2\xe9a\xe7q\xea\xff\x08\x9b\x9a\xe0\xbd\xadh", u)]] then
                r122();
            end;
            
            return; 
        end);
        
        r39.Notify("GlassESP", "Enabled", 3);
    else
        if r39.GlassESPConnection then
            n = r39.GlassESPConnection;
            
            n.Disconnect(n);
            
            r39.GlassESPConnection = nil;
        end;
        
        B = r28;
        u = r15;
        N = r16;
        B = B.FindFirstChild(B, "GlassBridge") and B.FindFirstChild(B, "GlassHolder");
        
        if B then
            N = B.GetChildren;
            u = {
                N(B)
            };
            j = N[3];
            u = N[1];
            
            for j, c in u, pairs(w(u)) do
                N = j;
                e = c.GetChildren;
                y = e[2];
                C = e[1];
                
                for x, e in pairs(e(c)) do
                    U = x;
                    
                    if e.IsA(e, "Model") then
                        P = e.GetDescendants;
                        r = P[3];
                        
                        for r, P in P[1], pairs(P(e)) do
                            m = r;
                            
                            if P.IsA(P, "BasePart") and P.GetAttribute(P, "GlassPart") then
                                
                                P.Color = Color3.fromRGB(163, 162, 165);
                                P.Material = Enum.Material.Glass;
                                P.Transparency = 0;
                            end; 
                        end;
                    end; 
                end; 
            end;
        end;
        
        r39.PlayBell();
        
        return true;
    end; 
end;
r39.SetGlassESPTransparency = function(arg1_89, ...)
    r39.GlassESPTransparency = arg1_89 / 100;
    
    if r39.GlassESPEnabled then
        v = r28;
        u = r16;
        v = v.FindFirstChild(v, "GlassBridge") and v.FindFirstChild(v, "GlassHolder");
        
        if v then
            u = v.GetChildren;
            j = {
                u(v)
            };
            B = u[2];
            G = u[3];
            
            for G, N in pairs(w("pairs")) do
                u = G;
                U = N.GetChildren;
                y = U[3];
                C = U[2];
                
                for y, U in pairs(U(N)) do
                    x = y;
                    
                    if U.IsA(U, "Model") then
                        m = U.GetDescendants;
                        J = m[2];
                        e = m[1];
                        
                        for R, m in pairs(m(U)) do
                            r = R;
                            
                            if m.IsA(m, "BasePart") and m.GetAttribute(m, "GlassPart") then
                                m.Transparency = r39.GlassESPTransparency;
                            end; 
                        end;
                    end; 
                end; 
            end;
        end;
    end;
    
    return; 
end;
r39.SetGlassESPTransparency = function(arg1_90, ...)
    r39.GlassESPTransparency = arg1_90 / 100;
    
    if r39.GlassESPEnabled then
        v = r28;
        j = r15;
        u = r16;
        v = v.FindFirstChild(v, "GlassBridge") and v.FindFirstChild(v, "GlassHolder");
        
        if v then
            u = v.GetChildren;
            j = {
                u(v)
            };
            j = u[1];
            B = u[2];
            
            for G, N in pairs(w(j)) do
                u = G;
                U = N.GetChildren;
                y = U[3];
                C = U[2];
                
                for y, U in pairs(U(N)) do
                    x = y;
                    
                    if U.IsA(U, "Model") then
                        m = U.GetDescendants;
                        R = m[3];
                        
                        for R, m in m[1], pairs(m(U)) do
                            r = R;
                            
                            if m.IsA(m, "BasePart") and m.GetAttribute(m, "GlassPart") then
                                m.Transparency = r39.GlassESPTransparency;
                            end; 
                        end;
                    end; 
                end; 
            end;
        end;
    end;
    
    return; 
end;
r39.TitleEnabled = false;
r39.CurrentTitleValue = "Rich Millionaire";
r39.TitleLoopConnection = nil;
r39.UpdateTitle = function(...)
    if r39.TitleEnabled and r39.CurrentTitleValue then
        n = r34;
        
        n.SetAttribute(n, "_CurrentTitle", r39.CurrentTitleValue);
    end;
    
    return; 
end;
r39.StartTitleLoop = function(...)
    if r39.TitleLoopConnection then
        n = r39.TitleLoopConnection;
        
        n.Disconnect(n);
        
        r39.TitleLoopConnection = nil;
    end;
    
    d = r29.Heartbeat;
    
    r39.TitleLoopConnection = d.Connect(d, function(...)
        B = r16;
        
        if r39.TitleEnabled then
            r39.UpdateTitle();
        end;
        
        return; 
    end);
    
    return; 
end;
r39.ToggleFreeTitle = function(arg1_91, ...)
    d = arg1_91;
    
    r39.TitleEnabled = d;
    
    if d then
        r39.UpdateTitle();
        r39.StartTitleLoop();
        r39.Notify("Free Title", "Enabled - " .. r39.CurrentTitleValue, 3);
    else
        if r39.TitleLoopConnection then
            n = r39.TitleLoopConnection;
            
            n.Disconnect(n);
            
            r39.TitleLoopConnection = nil;
        end;
        
        n = r34;
        
        n.SetAttribute(n, "_CurrentTitle", "");
        r39.Notify("Free Title", "Disabled", 2);
        r39.PlayBell();
        
        return;
    end; 
end;
r39.SetTitle = function(arg1_92, ...)
    d = arg1_92;
    v = arg1_92;
    
    r39.CurrentTitleValue = v;
    
    if r39.TitleEnabled then
        r39.UpdateTitle();
        r39.Notify("Free Title", "Changed to: " .. d, 2);
    end;
    
    return; 
end;
r39.AntiBreakEnabled = false;
r39.AntiBreakConn = nil;
r39.SafetyPlatforms = {};
r39.ToggleAntiBreak = function(arg1_93, ...)
    d = arg1_93;
    
    if d then
        if not r39.CanEnableToggle("GlassBridge", "Anti Break", r35.AntiBreak) then
            return false;
        end;
    end;
    
    if r39.AntiBreakConn then
        n = r39.AntiBreakConn;
        
        n.Disconnect(n);
        
        r39.AntiBreakConn = nil;
    end;
    
    u = r39;
    j = u.SafetyPlatforms;
    G = u[3];
    j = u[1];
    
    for G, N in j, pairs(j) do
        u = G;
        
        if N then
            N.Destroy(N);
        end; 
    end;
    
    r39.SafetyPlatforms = {};
    r39.AntiBreakEnabled = d;
    
    if d then
        G = r29.Heartbeat;
        
        r39.AntiBreakConn = G.Connect(G, function(...)
            u = "\xf0\xc48x\xb4\x87j\x93\xc9\xd4 1$\xbdK]";
            
            if not r39[r15[r16(u, 15993758031127)]] then
                return;
            end;
            
            if not r39.IsGameActive("GlassBridge") then
                r39.DisableToggle("AntiBreak");
                
                return;
            end;
            
            d = r28;
            d = d.FindFirstChild(d, "GlassBridge") and d.FindFirstChild(d, "GlassHolder");
            
            if not d then
                return;
            end;
            
            j = d.GetChildren;
            G = {
                j(d)
            };
            v = j[2];
            B = j[3];
            
            for B, u in pairs(w("pairs")) do
                x = u.GetChildren;
                j = B;
                C = x[3];
                
                for C, x in x[1], pairs(x(u)) do
                    y = C;
                    
                    if x.IsA(x, "Model") and x.PrimaryPart then
                        n = x.PrimaryPart;
                        
                        if n.GetAttribute(n, "exploitingisevil") then
                            n = x.PrimaryPart;
                            
                            n.SetAttribute(n, "exploitingisevil", nil);
                        end;
                        
                        if not r39.SafetyPlatforms[x] then
                            
                            U = Instance.new("Part");
                            
                            U.Name = "GlassSafetyPlatform";
                            U.Size = Vector3.new(20, 1, 20);
                            U.Position = x.PrimaryPart.Position + Vector3.new(0, -2, 0);
                            U.Anchored = true;
                            U.CanCollide = true;
                            U.Transparency = 1;
                            U.Parent = workspace;
                            
                            r39.SafetyPlatforms[x] = U;
                        end;
                    end; 
                end; 
            end;
            
            return; 
        end);
        
        r39.Notify("AntiBreak", "Enabled", 2);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.TeleportToHider = function(...)
    if not r39.IsGameActive("HideAndSeek") then
        r39.Notify("HNS", "Wait for HideAndSeek!", 2);
        
        return;
    end;
    
    d = r39.GetCharacter();
    
    if not d then
        return;
    end;
    
    G = r26;
    v = G[2];
    G = G[1];
    
    for B, u in pairs(G.GetPlayers(G)) do
        j = B;
        
        if u ~= r34 and r39.IsHider(u) then
            n = u.Character;
            
            N = n.FindFirstChildOfClass(n, "Humanoid");
            
            if N then
                c = N.Health > 0;
            end;
            
            if N then
                n = u.Character;
                C = "HumanoidRootPart";
                
                c = n.FindFirstChild(n, C);
                
                if c then
                    
                    C = r39.GetRootPart(d);
                    
                    if C then
                        
                        C.CFrame = CFrame.new(c.Position.X, c.Position.Y + 3, c.Position.Z);
                        
                        r39.Notify("HNS", "Teleported to hider: " .. u.Name, 2);
                        r39.PlayBell();
                        
                        return;
                    else
                        
                    end;
                end;
            end;
        end; 
    end;
    
    r24.Notify("HideAndSeek", "No hider's found :c", 2);
    r39.PlayBell();
    
    return; 
end;
r39.TeleportToSeeker = function(...)
    if not r39.IsGameActive("HideAndSeek") then
        r24.Notify("HideAndSeek", "Wait for HideAndSeek!", 2);
        
        return;
    end;
    
    d = r39.GetCharacter();
    
    if not d then
        return;
    end;
    
    G = r26;
    v = G[2];
    G = G[1];
    
    for B, u in pairs(G.GetPlayers(G)) do
        c = u ~= r34;
        j = B;
        
        if c then
            
            x = r39.IsSeeker(u);
            
            if x then
                c = u.Character;
            end;
            
            n = pairs;
            N = x;
        end;
        
        if c then
            n = u.Character;
            
            N = n.FindFirstChildOfClass(n, "Humanoid");
            
            if N then
                c = N.Health > 0;
            end;
            
            if N then
                n = u.Character;
                C = "HumanoidRootPart";
                
                c = n.FindFirstChild(n, C);
                
                if c then
                    
                    C = r39.GetRootPart(d);
                    
                    if C then
                        
                        C.CFrame = CFrame.new(c.Position.X, c.Position.Y + 3, c.Position.Z);
                        
                        r24.Notify("HNS", "Teleported to seeker: " .. u.Name, 2);
                        r39.PlayBell();
                        
                        return;
                    else
                        
                    end;
                end;
            end;
        end; 
    end;
    
    r24.Notify("HideAndSeek", "No seeker's found :c", 2);
    r39.PlayBell();
    
    return; 
end;
r39.InfStaminaActive = false;
r39.StaminaConns = {};
r39.ToggleInfiniteStamina = function(arg1_94, ...)
    d = arg1_94;
    
    if d then
        if not r39.CanEnableToggle("HideAndSeek", "Infinite Stamina", r35.InfiniteStamina) then
            return false;
        end;
    end;
    
    if d then
        if r39.InfStaminaActive then
            return;
        end;
        
        r39.InfStaminaActive = true;
        
        local function r123(...)
            n = r34.Character;
            d = pairs;
            
            if not d then
                return;
            end;
            
            v = d.FindFirstChild(d, "Humanoid");
            
            if not v then
                return;
            end;
            
            u = v.GetChildren;
            j = {
                u(v)
            };
            G = u[3];
            j = u[1];
            
            for G, N in j, pairs(w(j)) do
                r124 = N;
                C = X[n];
                u = G;
                U = r15;
                x = "NumberValue";
                
                y = C.IsA(C, x);
                
                if y then
                    x = X[n].Name;
                    
                    U = x.lower(x);
                    n = 263;
                    c = U.find(U, "stamina") or U.find(U, "energy");
                end;
                
                if y then
                    X[n].Value = 100;
                    
                    y = X[n];
                    
                    x = y.GetPropertyChangedSignal(y, "Value");
                    
                    table.insert(r39.StaminaConns, x.Connect(x, function(...)
                        X[n].Value = 100;
                        
                        return; 
                    end));
                end; 
            end;
            
            N = d.GetChildren;
            B = N[1];
            G = N[2];
            
            for j, N in pairs(N(d)) do
                r125 = N;
                u = j;
                C = X[n];
                U = r15;
                x = "NumberValue";
                
                y = C.IsA(C, x);
                
                if y then
                    x = X[n].Name;
                    
                    U = x.lower(x);
                    c = U.find(U, "stamina") or U.find(U, "energy");
                    n = 81;
                end;
                
                if y then
                    X[n].Value = 100;
                    
                    y = X[n];
                    
                    x = y.GetPropertyChangedSignal(y, "Value");
                    
                    table.insert(r39.StaminaConns, x.Connect(x, function(...)
                        X[n].Value = 100;
                        
                        return; 
                    end));
                end; 
            end;
            
            return; 
        end;
        
        (function(...)
            n = r27;
            
            d = n.FindFirstChild(n, "UI");
            
            if d then
                
                r126 = d.FindFirstChild(d, "StaminaBar");
                u = "\xa4\x05,\xc9\x92\xc2p\x13&\x0fu\xad\x87\xaf\xa2:\x1d";
                r127 = d.FindFirstChild(d, r15[r16(u, 32188244195980)]);
                n = r126;
                
                if r127 and table.insert(r39.StaminaConns, u.Connect(u, function(...)
                    if r126.Size.X.Scale < 1 then
                        
                        r126.Size = UDim2.new(1, 0, 1, 0);
                    end;
                    
                    return; 
                end)) then
                    
                    r127.Size = UDim2.new(1, 0, 1, 0);
                    
                    j = r127;
                    u = j.GetPropertyChangedSignal(j, "Size");
                    
                    table.insert(r39.StaminaConns, u.Connect(u, function(...)
                        
                        N = r16("\xbe\x10\x1b\t", 460235178198);
                        
                        if r127[r15[N]].X.Scale < 1 then
                            
                            r127.Size = UDim2.new(1, 0, 1, 0);
                        end;
                        
                        return; 
                    end));
                end;
            end;
            
            return; 
        end)();
        
        r123();
        
        u = r34.CharacterAdded;
        
        table.insert(r39.StaminaConns, u.Connect(u, function(...)
            task.wait(0.5);
            
            if r39.InfStaminaActive then
                r123();
            end;
            
            return; 
        end));
        
        u = r29.Heartbeat;
        
        table.insert(r39.StaminaConns, u.Connect(u, function(...)
            n = r39.InfStaminaActive;
            
            if n then
                d = r34.Character;
                
                if d then
                    u = 26751299301545;
                    
                    v = d.FindFirstChild(d, r15[r16("WqK\x10\x07Q5\xd9", u)]);
                    
                    if v then
                        u = v.GetChildren;
                        j = {
                            u(v)
                        };
                        G = u[3];
                        B = u[2];
                        
                        for G, N in pairs(w("pairs")) do
                            u = G;
                            J = "\xad0d\xe2\xa3?W\x80\xcf\xc9l";
                            
                            C = N.IsA(N, r15[r16(J, 9902474809859)]);
                            c = C;
                            
                            if C then
                                e = N.Name;
                                
                                J = e.lower(e);
                                n = n;
                                n = n;
                                c = (J.find(J, "stamina") or J.find(J, "energy")) and N.Value < 100;
                            end;
                            
                            if c then
                                N.Value = 100;
                            end; 
                        end;
                    end;
                end;
                
                n = r27;
                c = 23532965030606;
                
                v = n.FindFirstChild(n, r15[r16("\xcaY", c)]);
                
                if v then
                    
                    B = v.FindFirstChild(v, "StaminaBar");
                    G = v.FindFirstChild(v, "NoRegenStaminaBar");
                    
                    if B then
                        j = B.Size.X.Scale < 1;
                    end;
                    
                    if B then
                        
                        B.Size = UDim2.new(1, 0, 1, 0);
                    end;
                    
                    if G then
                        j = G.Size.X.Scale < 1;
                    end;
                    
                    if G then
                        
                        G.Size = UDim2.new(1, 0, 1, 0);
                    end;
                end;
            end;
            
            return; 
        end));
        r39.Notify("Infinite Stamina", "Enabled", 3);
    else
        r39.InfStaminaActive = false;
        
        u = r39;
        j = u.StaminaConns;
        G = u[3];
        j = u[1];
        
        for G, N in j, pairs(j) do
            u = G;
            r128 = N;
            
            pcall(function(...)
                n = r128;
                
                n.Disconnect(n);
                
                return; 
            end); 
        end;
        
        r39.StaminaConns = {};
        
        r39.PlayBell();
        
        return true;
    end; 
end;
r39.SpikesKillFeature = {
    ["Enabled"] = false,
    ["AnimationIds"] = {
        "rbxassetid://105341857343164",
        "rbxassetid://95623680038308",
        "rbxassetid://106191977814264",
        "rbxassetid://79549040943367",
        "rbxassetid://138639404847153",
        "rbxassetid://81533666958052",
        "rbxassetid://118039465583394"
    },
    ["SpikesPosition"] = nil,
    ["PlatformHeightOffset"] = 10,
    ["ReturnDelay"] = 1,
    ["OriginalCFrame"] = nil,
    ["ActiveAnimation"] = false,
    ["AnimationStartTime"] = 0,
    ["AnimationConnection"] = nil,
    ["CharacterAddedConnection"] = nil,
    ["AnimationStoppedConnections"] = {},
    ["AnimationCheckConnection"] = nil,
    ["TrackedAnimations"] = {},
    ["SafetyCheckConnection"] = nil,
    ["PlatformPart"] = nil,
    ["PlatformCreated"] = false
};
r39.ToggleSpikesKill = function(arg1_95, ...)
    d = arg1_95;
    
    if d then
        k = not r39.IsGameActive("HideAndSeek");
    end;
    
    if d then
        r39.Notify("Spikes Kill", "Wait for HideAndSeek!", 2);
        
        r39.SpikesKillFeature.Enabled = false;
        
        return;
    end;
    
    if r39.SpikesKillFeature.AnimationConnection then
        n = r39.SpikesKillFeature.AnimationConnection;
        
        n.Disconnect(n);
        
        r39.SpikesKillFeature.AnimationConnection = nil;
    end;
    
    if r39.SpikesKillFeature.CharacterAddedConnection then
        n = r39.SpikesKillFeature.CharacterAddedConnection;
        
        n.Disconnect(n);
        
        r39.SpikesKillFeature.CharacterAddedConnection = nil;
    end;
    
    if r39.SpikesKillFeature.SafetyCheckConnection then
        n = r39.SpikesKillFeature.SafetyCheckConnection;
        
        n.Disconnect(n);
        
        r39.SpikesKillFeature.SafetyCheckConnection = nil;
    end;
    
    if r39.SpikesKillFeature.AnimationCheckConnection then
        n = r39.SpikesKillFeature.AnimationCheckConnection;
        
        n.Disconnect(n);
        
        r39.SpikesKillFeature.AnimationCheckConnection = nil;
    end;
    
    j = r39.SpikesKillFeature;
    G = j.AnimationStoppedConnections;
    v = j[2];
    G = j[1];
    
    for B, u in ipairs(G) do
        j = B;
        r129 = u;
        
        pcall(function(...)
            n = r129;
            
            n.Disconnect(n);
            
            return; 
        end); 
    end;
    
    r39.SpikesKillFeature.AnimationStoppedConnections = {};
    
    if r39.SpikesKillFeature.PlatformPart then
        pcall(function(...)
            B = r15;
            n = r39.SpikesKillFeature.PlatformPart;
            
            n.Destroy(n);
            
            return; 
        end);
        
        r39.SpikesKillFeature.PlatformPart = nil;
    end;
    
    r39.SpikesKillFeature.PlatformCreated = false;
    r39.SpikesKillFeature.OriginalCFrame = nil;
    r39.SpikesKillFeature.ActiveAnimation = false;
    r39.SpikesKillFeature.AnimationStartTime = 0;
    r39.SpikesKillFeature.TrackedAnimations = {};
    r39.SpikesKillFeature.SpikesPosition = nil;
    
    if not d then
        r39.SpikesKillFeature.Enabled = false;
        
        return;
    end;
    
    pcall(function(...)
        u = 9563510165861;
        n = workspace;
        B = r16;
        j = "\xdd\xc0H\x1d\xcfa|\xdf\xf5\x9eLLm\x9d";
        
        d = n.FindFirstChild(n, r15[B(j, u)]);
        v = d and d.FindFirstChild(d, "KillingParts");
        
        if v then
            u = v.GetChildren;
            j = {
                u(v)
            };
            j = u[1];
            B = u[2];
            
            for G, N in pairs(w(j)) do
                u = G;
                
                if N.IsA(N, "BasePart") then
                    if not r39.SpikesKillFeature.SpikesPosition then
                        r39.SpikesKillFeature.SpikesPosition = N.Position;
                    end;
                    
                    N.Destroy(N);
                end; 
            end;
        end;
        
        return; 
    end);
    
    local function r130(...)
        n = r39.SpikesKillFeature.PlatformCreated;
        
        if n then
            return;
        end;
        
        if not r39.SpikesKillFeature.SpikesPosition then
            return;
        end;
        
        pcall(function(...)
            d = "Instance";
            
            d = Env[d].new("Part");
            
            d.Name = "SafetyPlatform";
            d.Size = Vector3.new(20, 1, 20);
            d.Position = r39.SpikesKillFeature.SpikesPosition + Vector3.new(0, r39.SpikesKillFeature.PlatformHeightOffset, 0);
            d.Anchored = true;
            d.CanCollide = true;
            d.Transparency = 1;
            d.Color = Color3.fromRGB(0, 255, 0);
            v = Instance.new("BoolValue");
            
            v.Name = "SafePlatform";
            v.Value = true;
            v.Parent = d;
            d.Parent = workspace;
            r39.SpikesKillFeature.PlatformPart = d;
            r39.SpikesKillFeature.PlatformCreated = true;
            
            return; 
        end);
        
        return; 
    end;
    
    local function r131(arg1_96, ...)
        d = arg1_96;
        
        if not d or not d.FindFirstChild(d, "HumanoidRootPart") then
            return;
        end;
        
        n = not r39.SpikesKillFeature.PlatformCreated;
        
        if n then
            r130();
        end;
        
        if r39.SpikesKillFeature.SpikesPosition and r39.SpikesKillFeature.PlatformPart then
            
            r39.SpikesKillFeature.OriginalCFrame = d.GetPrimaryPartCFrame(d);
            
            d.SetPrimaryPartCFrame(d, CFrame.new(r39.SpikesKillFeature.PlatformPart.Position + Vector3.new(0, 3, 0)));
        end;
        
        return; 
    end;
    
    local function r132(arg1_97, ...)
        d = arg1_97;
        
        if not d or not d.FindFirstChild(d, "HumanoidRootPart") then
            return;
        end;
        
        n = r39.SpikesKillFeature.OriginalCFrame;
        
        if n then
            d.SetPrimaryPartCFrame(d, r39.SpikesKillFeature.OriginalCFrame);
            
            r39.SpikesKillFeature.OriginalCFrame = nil;
        end;
        
        return; 
    end;
    
    local function r133(arg1_98, ...)
        n = ipairs;
        j = r39.SpikesKillFeature;
        G = j.AnimationIds;
        G = j[1];
        v = j[2];
        
        for B, u in n(G) do
            j = B;
            
            if arg1_98 == u then
                return true;
            else
                
            end; 
        end;
        
        return false; 
    end;
    
    local function r134(arg1_99, ...)
        r135 = arg1_99;
        n = r135;
        B = n.WaitForChild(n, "Humanoid").AnimationPlayed;
        
        r39.SpikesKillFeature.AnimationConnection = B.Connect(B, function(arg1_100, ...)
            d = arg1_100;
            j = r15;
            
            if not r39.SpikesKillFeature.Enabled then
                return;
            end;
            
            v = d.Animation;
            
            if v then
                r133(d.Animation.AnimationId);
            end;
            
            if v then
                r39.SpikesKillFeature.TrackedAnimations[d] = true;
                
                if not r39.SpikesKillFeature.ActiveAnimation then
                    r39.SpikesKillFeature.ActiveAnimation = true;
                    
                    r39.SpikesKillFeature.AnimationStartTime = tick();
                    
                    r131(r135);
                    
                    n = d.Stopped;
                    
                    table.insert(r39.SpikesKillFeature.AnimationStoppedConnections, n.Connect(n, function(...)
                        v = r15;
                        
                        task.wait(r39.SpikesKillFeature.ReturnDelay);
                        
                        if r39.SpikesKillFeature.OriginalCFrame then
                            r132(r135);
                            
                            r39.SpikesKillFeature.ActiveAnimation = false;
                            r39.SpikesKillFeature.TrackedAnimations = {};
                        end;
                        
                        return; 
                    end));
                end;
            end;
            
            return; 
        end);
        
        return; 
    end;
    
    N = r34.Character;
    
    if N then
        r134(N);
    end;
    
    C = r34.CharacterAdded;
    
    r39.SpikesKillFeature.CharacterAddedConnection = C.Connect(C, function(arg1_101, ...)
        task.wait(1);
        
        r134(arg1_101);
        
        return; 
    end);
    
    C = r29.Heartbeat;
    r39.SpikesKillFeature.SafetyCheckConnection = C.Connect(C, function(...)
        if not r39.SpikesKillFeature.Enabled then
            if r39.SpikesKillFeature.SafetyCheckConnection then
                n = r39.SpikesKillFeature.SafetyCheckConnection;
                
                n.Disconnect(n);
                
                r39.SpikesKillFeature.SafetyCheckConnection = nil;
            end;
            
            return;
        end;
        
        if not r39.IsGameActive("HideAndSeek") then
            r39.SpikesKillFeature.Enabled = false;
            
            r39.Notify("Spikes Kill", "Disabled", 2);
            r39.PlayBell();
            
            return;
        end;
        
        if r39.SpikesKillFeature.PlatformCreated and not r39.SpikesKillFeature.PlatformPart then
            r39.SpikesKillFeature.PlatformCreated = false;
            r39.SpikesKillFeature.PlatformPart = nil;
            
            r130();
        end;
        
        if r39.SpikesKillFeature.ActiveAnimation and tick() - r39.SpikesKillFeature.AnimationStartTime >= 10 then
            
            d = r39.GetCharacter();
            
            if d then
                k = r39.SpikesKillFeature.OriginalCFrame;
            end;
            
            if d then
                r132(d);
            end;
            
            r39.SpikesKillFeature.ActiveAnimation = false;
            r39.SpikesKillFeature.TrackedAnimations = {};
        end;
        
        return; 
    end);
    r39.SpikesKillFeature.Enabled = true;
    
    r39.Notify("Spikes Kill", "Enabled", 2);
    r39.PlayBell();
    
    r130();
    
    return; 
end;
r39.DeleteSpikes = function(...)
    d = r28;
    
    v = d.FindFirstChild(d, "HideAndSeekMap");
    
    if v then
        
        k = v.FindFirstChild(v, "KillingParts");
    end;
    
    if v then
        j = v.KillingParts;
        G = j[3];
        j = j[1];
        
        for G, N in j, ipairs(j.GetDescendants(j)) do
            u = G;
            
            if N.Name == "Spikes" and N.IsA(N, "BasePart") then
                N.CanTouch = false;
            end; 
        end;
        
        r39.Notify("Delete Spikes", "Removed", 2);
    else
        r39.Notify("Delete Spikes", "Map not found", 2);
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.AutoEscapeEnabled = false;
r39.AutoEscapeConnection = nil;
r39.ToggleAutoEscape = function(arg1_102, ...)
    d = arg1_102;
    
    if d then
        if not r39.CanEnableToggle("HideAndSeek", "Auto Escape", r35.AutoEscape) then
            return false;
        end;
        
        if not r39.AutoPickupEnabled then
            r39.ToggleAutoPickup(true);
            
            n = r35.AutoPickup;
            
            if n then
                n = r35.AutoPickup;
                
                n.SetValue(n, true);
            end;
        end;
    else
        if r39.AutoPickupEnabled then
            r39.ToggleAutoPickup(false);
            
            n = r35.AutoPickup;
            
            if n then
                n = r35.AutoPickup;
                
                n.SetValue(n, false);
            end;
        end;
        
        r39.AutoEscapeEnabled = d;
        
        if d then
            task.spawn(function(...)
                n = game;
                B = r16;
                n = game;
                
                v = n.GetService(n, "Workspace");
                r136 = n.GetService(n, "Players").LocalPlayer;
                G = v.WaitForChild(v, "Values");
                r137 = G.WaitForChild(G, "CurrentGame");
                
                if r137.Value ~= "HideAndSeek" then
                    r39.AutoEscapeEnabled = false;
                    
                    return;
                end;
                
                u = r136.Character;
                k = u;
                
                if u then
                    u = r[1];
                    
                    r138 = u.WaitForChild(u, "HumanoidRootPart");
                    c = v.WaitForChild(v, "HideAndSeekMap");
                    r139 = c.WaitForChild(c, "NEWFIXEDDOORS");
                    r140 = v.WaitForChild(v, "Effects");
                    x = c.WaitForChild(c, "KillingParts");
                    r = x.GetDescendants;
                    r141 = {};
                    R = {
                        r(x)
                    };
                    J = r[3];
                    R = r[1];
                    
                    for J, m in R, ipairs(w(R)) do
                        r = J;
                        
                        if m.IsA(m, "BasePart") then
                            table.insert(r141, m);
                        end; 
                    end;
                    
                    r142 = {};
                    R = P[2];
                    J = P[1];
                    
                    for r, P in ipairs(r141) do
                        m = r;
                        
                        r142[P] = P.CanTouch; 
                    end;
                    
                    local function r143(...)
                        n = ipairs;
                        B = r141;
                        d = G[2];
                        B = G[1];
                        
                        for v, j in n(B) do
                            G = v;
                            
                            j.CanTouch = false; 
                        end;
                        
                        return; 
                    end;
                    
                    local function r144(...)
                        n = ipairs;
                        B = r141;
                        v = G[3];
                        B = G[1];
                        
                        for v, j in B, n(B) do
                            G = v;
                            
                            if r142[j] ~= nil then
                                j.CanTouch = r142[j];
                            end; 
                        end;
                        
                        return; 
                    end;
                    
                    local function r145(...)
                        n = r136;
                        
                        return n.FindFirstChild(n, "CurrentKeys"); 
                    end;
                    
                    local function r146(arg1_103, ...)
                        n = r145;
                        
                        v = n();
                        
                        if v then
                            k = v.FindFirstChild(v, arg1_103) ~= nil;
                        end;
                        
                        return v; 
                    end;
                    
                    local function P(...)
                        
                        j = r16("v\n\xe6\x9f\xf8\x0e", 6328229088130);
                        n = {
                            "Circle",
                            "Triangle",
                            r15[j]
                        };
                        d = ipairs;
                        v = {};
                        B = j[2];
                        j = j[1];
                        
                        for G, N in ipairs(d) do
                            u = G;
                            
                            if not r146(N) then
                                table.insert(v, N);
                            end; 
                        end;
                        
                        return v; 
                    end;
                    
                    local function r147(arg1_104, ...)
                        d = arg1_104;
                        n = typeof(d) == "Vector3";
                        
                        if n then
                            
                            r138.CFrame = CFrame.new(d);
                        else
                            
                            v = typeof(d);
                            
                            if v == "CFrame" then
                                v = arg1_104;
                                
                                r138.CFrame = v;
                            end;
                            
                            return;
                        end; 
                    end;
                    
                    local function i(arg1_105, ...)
                        r148 = arg1_105;
                        B = r148;
                        
                        if not B or not B.IsA(B, "ProximityPrompt") then
                            return;
                        end;
                        
                        n = fireproximityprompt;
                        
                        if n then
                            pcall(function(...)
                                fireproximityprompt(r148);
                                
                                return; 
                            end);
                        else
                            if syn and syn.proximityprompt then
                                pcall(function(...)
                                    v = r15;
                                    
                                    syn.proximityprompt(r148);
                                    
                                    return; 
                                end);
                            else
                                r148.HoldDuration = 0;
                                
                                pcall(function(...)
                                    n = r148;
                                    
                                    n.InputHoldBegin(n);
                                    
                                    B = r16;
                                    
                                    task.wait();
                                    
                                    n = r148;
                                    
                                    n.InputHoldEnd(n);
                                    
                                    return; 
                                end);
                                
                                r148.HoldDuration = r148.HoldDuration;
                            end;
                            
                            return;
                        end; 
                    end;
                    
                    local function r149(...)
                        n = {};
                        G = r139;
                        B = G[3];
                        G = G[1];
                        
                        for B, u in G, ipairs(G.GetChildren(G)) do
                            j = B;
                            y = r15;
                            
                            if u.IsA(u, "Folder") and u.FindFirstChild(u, "EXITDOORS") then
                                y = u.EXITDOORS;
                                x = {
                                    y.GetChildren(y)
                                };
                                C = y[3];
                                
                                for C, x in y[1], ipairs(w(x)) do
                                    y = C;
                                    
                                    if x.IsA(x, "Model") and (x.Name == "EXITDOOR" and x.GetAttribute(x, "ActuallyWorks") == true) then
                                        table.insert(n, x);
                                    end; 
                                end;
                            end; 
                        end;
                        
                        return n; 
                    end;
                    
                    local function L(...)
                        n = r149;
                        
                        d = n();
                        
                        if #d == 0 then
                            return nil;
                        end;
                        
                        table.sort(d, function(arg1_106, arg2_106, ...)
                            v = arg2_106;
                            
                            return arg1_106.Name < v.Name; 
                        end);
                        
                        return d[1]; 
                    end;
                    
                    local function h(arg1_107, ...)
                        d = arg1_107;
                        n = "FindFirstChild";
                        
                        v = d[n](d, "DoorKnob");
                        
                        if not v then
                            return nil;
                        end;
                        
                        u = v.GetDescendants;
                        j = {
                            u(v)
                        };
                        G = u[3];
                        j = u[1];
                        
                        for G, N in j, ipairs(w(j)) do
                            u = G;
                            r150 = N;
                            
                            if pcall(function(...)
                                return r150.CFrame; 
                            end) then
                                return r150;
                            else
                                
                            end; 
                        end;
                        
                        return nil; 
                    end;
                    
                    local function r152(...)
                        n = r151;
                        
                        if n then
                            n = r151;
                            
                            n.Disconnect(n);
                        end;
                        
                        return; 
                    end;
                    
                    local function r153(arg1_108, ...)
                        d = arg1_108;
                        v = not r39.AutoEscapeEnabled;
                        k = v;
                        
                        if v then
                            if v then
                                return;
                            end;
                            
                            v = not k;
                            
                            B = d.IsA(d, "Model");
                            k = r16;
                            
                            if B then
                                B = d.Name;
                                
                                k = B.match(B, "^DroppedKey");
                            end;
                            
                            n = v;
                            
                            if not k then
                                return;
                            end;
                            
                            n = d.Name;
                            n = r146;
                            
                            if n(n.gsub(n, "^DroppedKey", "")) then
                                return;
                            end;
                            
                            n = n;
                            
                            r143();
                            
                            r147((d.PrimaryPart and d.PrimaryPart.Position or d.GetPivot(d).Position) + Vector3.new(0, 5, 0));
                            
                            task.wait(.1);
                            
                            r144();
                            
                            return;
                        else
                            v = r136;
                            
                            k = v.FindFirstChild(v, "Escaped");
                        end; 
                    end;
                    
                    n = r137;
                    
                    E = n.GetPropertyChangedSignal(n, "Value");
                    
                    E.Connect(E, function(...)
                        if r39.AutoEscapeEnabled and r137.Value ~= "HideAndSeek" then
                            r39.AutoEscapeEnabled = false;
                            
                            r152();
                        end;
                        
                        return; 
                    end);
                    
                    (function(...)
                        n = r152;
                        
                        n();
                        
                        n = r140.ChildAdded;
                        
                        r151 = n.Connect(n, function(arg1_109, ...)
                            d = arg1_109;
                            
                            v = d.IsA(d, "Model");
                            
                            if v then
                                v = d.Name;
                                
                                k = v.match(v, "^DroppedKey");
                            end;
                            
                            if v then
                                r153(d);
                            end;
                            
                            return; 
                        end);
                        
                        return; 
                    end)();
                    
                    while r39.AutoEscapeEnabled do
                        repeat
                            n = r136;
                        until true.FindFirstChild(true, "Escaped");
                        
                        r39.AutoEscapeEnabled = false;
                        
                        task.wait(0.5); 
                    end;
                    
                    r152();
                    
                    return;
                else
                    u = r136.CharacterAdded;
                    
                    k = u.Wait(u);
                end; 
            end);
            r39.Notify("Auto Escape", "Enabled", 3);
        else
        end;
        
        r39.PlayBell();
        
        return true;
    end; 
end;
r39.KeyESPEnabled = false;
r39.KeyESPConnection = nil;
r39.KeyESPBoxes = {};
r39.ToggleKeyESP = function(arg1_110, ...)
    d = arg1_110;
    
    if d then
        if not r39.CanEnableToggle("HideAndSeek", "Key ESP", r35.KeyESP) then
            return false;
        end;
    end;
    
    r39.KeyESPEnabled = d;
    
    if r39.KeyESPConnection then
        n = r39.KeyESPConnection;
        
        n.Disconnect(n);
        
        r39.KeyESPConnection = nil;
    end;
    
    u = r39;
    j = u.KeyESPBoxes;
    G = u[3];
    j = u[1];
    
    for G, N in j, pairs(j) do
        r154 = N;
        u = G;
        
        if r154 then
            pcall(function(...)
                n = r154;
                
                n.Destroy(n);
                
                return; 
            end);
        end; 
    end;
    
    r39.KeyESPBoxes = {};
    
    if d then
        task.spawn(function(...)
            n = game;
            
            G = r16("+aj\xbc\xbe\xd2\xad", 30268010739470);
            n = game;
            r155 = n.GetService(n, r15[G]).LocalPlayer;
            
            r156 = n.GetService(n, "Workspace");
            n = r156;
            j = n.FindFirstChild(n, "Effects");
            
            task.wait(.1);
            
            if j then
                r157 = {};
                
                local function r158(...)
                    n = r155;
                    
                    d = n.FindFirstChild(n, "CurrentKeys");
                    
                    if d then
                        return d;
                    end;
                    
                    n = r156;
                    
                    v = n.FindFirstChild(n, "Live");
                    
                    if v then
                        
                        B = v.FindFirstChild(v, r155.Name);
                        
                        if B then
                            
                            d = B.FindFirstChild(B, "CurrentKeys");
                            
                            if d then
                                return d;
                            end;
                        end;
                    end;
                    
                    return nil; 
                end;
                
                local function y(arg1_111, ...)
                    d = arg1_111;
                    n = r157[d];
                    
                    if n then
                        if r157[d] and r157[d].Parent then
                            n = r157[d];
                            
                            n.Destroy(n);
                        end;
                        
                        n = r157;
                        
                        n[d] = nil;
                    end;
                    
                    return; 
                end;
                
                R = r16("\xcf\xf6\xb4\xaf\xca|\x89\xc6\xe3,g\xa2\x92", 15988850416917);
                
                while r39[r15[R]] do
                    U = R[2];
                    x = R[1];
                    
                    for e, R in pairs(r157) do
                        if not e or not e.Parent then
                            y(e);
                        end; 
                    end;
                    
                    R = k.GetChildren;
                    x = R[1];
                    U = R[2];
                    
                    for e, R in ipairs(R(k)) do
                        J = e;
                        
                        if not r39.KeyESPEnabled then
                            
                        else
                            
                            m = R.IsA(R, "Model");
                            
                            if m then
                                m = R.Name;
                                
                                r = m.match(m, "^DroppedKey");
                            end;
                            
                            if m then
                                n = R.Name;
                                m = R.PrimaryPart or R.FindFirstChildWhichIsA(R, "BasePart");
                                
                                if m then
                                    if not (function(arg1_113, ...)
                                        n = r158;
                                        
                                        v = n();
                                        
                                        if not v then
                                            return false;
                                        end;
                                        
                                        return v.FindFirstChild(v, arg1_113) ~= nil; 
                                    end)(n.gsub(n, "^DroppedKey", "")) then
                                        if not r157[R] and not m.FindFirstChild(m, "KeyESP") then
                                            
                                            r157[R] = (function(arg1_112, ...)
                                                d = arg1_112;
                                                n = Instance.new;
                                                
                                                v = n("BoxHandleAdornment");
                                                n = "Name";
                                                
                                                v[n] = "KeyESP";
                                                
                                                k = arg1_112;
                                                
                                                v.Adornee = k;
                                                v.Size = d.Size + Vector3.new(0.5, 0.5, 0.5);
                                                
                                                v.Color3 = Color3.fromRGB(138, 43, 226);
                                                v.Transparency = .4;
                                                v.AlwaysOnTop = true;
                                                v.ZIndex = 10;
                                                v.Parent = d;
                                                
                                                return v; 
                                            end)(m);
                                        end;
                                    else
                                        y(R);
                                        
                                        D = m.FindFirstChild(m, "KeyESP");
                                        
                                        if D then
                                            D.Destroy(D);
                                        end;
                                    end;
                                end;
                            end;
                        end; 
                    end;
                    
                    task.wait(0.25); 
                end;
                
                U = R[2];
                e = R[3];
                
                for e, R in pairs(r157) do
                    J = e;
                    
                    if R then
                        R.Destroy(R);
                    end; 
                end;
                
                r157 = {};
                
                return;
            end; 
        end);
        r39.Notify("Key ESP", "Enabled", 3);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.AutoPickupEnabled = false;
r39.ToggleAutoPickup = function(arg1_114, ...)
    d = arg1_114;
    
    if d then
        if not r39.IsGameActive("HideAndSeek") then
            r39.Notify("Auto Pickup", "Wait for HideAndSeek!", 2);
            r39.PlayBell();
            
            n = r35.AutoPickup;
            
            if n then
                n = r35.AutoPickup;
                
                n.SetValue(n, false);
            end;
            
            return false;
        end;
    end;
    
    r39.AutoPickupEnabled = d;
    
    if d then
        task.spawn(function(...)
            n = game;
            v = r15;
            n = game;
            
            r159 = n.GetService(n, "Workspace");
            r160 = n.GetService(n, "Players").LocalPlayer;
            n = r159;
            G = n.FindFirstChild(n, "Values");
            
            if not G then
                return;
            end;
            
            j = G.FindFirstChild(G, "CurrentGame");
            
            if not j or j.Value ~= "HideAndSeek" then
                r39.AutoPickupEnabled = false;
                
                n = r35.AutoPickup;
                
                if n then
                    n = r35.AutoPickup;
                    
                    n.SetValue(n, false);
                end;
                
                return;
            end;
            
            u = r160.Character;
            k = u;
            
            if u then
                
                r161 = u.WaitForChild(u, "HumanoidRootPart");
                
                local function r162(...)
                    n = r160;
                    
                    return n.FindFirstChild(n, "CurrentKeys"); 
                end;
                
                local function r163(arg1_115, ...)
                    n = r162;
                    
                    v = n();
                    
                    if v then
                        k = v.FindFirstChild(v, arg1_115) ~= nil;
                    end;
                    
                    return v; 
                end;
                
                J = {};
                
                while r39.AutoPickupEnabled do
                    if not r39.IsGameActive("HideAndSeek") then
                        
                    else
                        k = r160;
                        n = k.GetAttribute(k, "IsHunter") == true;
                        
                        if n then
                            task.wait(1);
                        else
                            n = r160;
                            
                            if n.FindFirstChild(n, "Escaped") then
                                
                            else
                                if #(function(...)
                                    
                                    j = r16("\x86\x98\xffK\xbeQ", 5247083579787);
                                    n = {
                                        "Circle",
                                        "Triangle",
                                        r15[j]
                                    };
                                    d = ipairs;
                                    v = {};
                                    G = j[3];
                                    j = j[1];
                                    
                                    for G, N in j, ipairs(d) do
                                        u = G;
                                        
                                        if not r163(N) then
                                            table.insert(v, N);
                                        end; 
                                    end;
                                    
                                    return v; 
                                end)() == 0 then
                                    r39.Notify("Auto Pickup", "All keys collected!", 2);
                                else
                                    m = D[2];
                                    D = "pairs";
                                    
                                    for P, I in pairs((function(...)
                                        u = "\x84\xa3\xe7\xb4\\\tD";
                                        n = {};
                                        r164 = n;
                                        n = r159;
                                        
                                        v = n.FindFirstChild(n, r15[r16(u, 26434856546325)]);
                                        
                                        if v then
                                            u = {
                                                pairs(v.GetChildren(v))
                                            };
                                            G = u[3];
                                            B = u[2];
                                            
                                            j = pairs(v.GetChildren(v));
                                        end; 
                                    end)()) do
                                        i = P;
                                        g = "AutoPickupEnabled";
                                        
                                        if not r39[g] then
                                            
                                        else
                                            b = 21956327516144;
                                            
                                            g = table[r15[r16("\xbfHxs", b)]](y(), I.name);
                                            
                                            if g then
                                                L = not J[I.name];
                                            end;
                                            
                                            if g then
                                                (function(arg1_116, ...)
                                                    if r161 and r161.Parent then
                                                        n = r161;
                                                        
                                                        n.CFrame = CFrame.new(arg1_116);
                                                    end;
                                                    
                                                    return; 
                                                end)(I.position + Vector3.new(0, 3, 0));
                                                
                                                task.wait(.1);
                                                
                                                if I.model then
                                                    n = I.model;
                                                    
                                                    n8 = r16("[\xac{\xb2\x91HN}g\xe0l\xe8\x9a\xc4B", 15860375444697);
                                                    
                                                    L = n.FindFirstChildOfClass(n, r15[n8]);
                                                    
                                                    if not L then
                                                        n8 = I.model;
                                                        E = {
                                                            n8.GetDescendants(n8)
                                                        };
                                                        g = n8[1];
                                                        W = n8[2];
                                                        
                                                        for s, E in pairs(w(E)) do
                                                            n8 = s;
                                                            
                                                            if E.IsA(E, "ProximityPrompt") then
                                                                L = E;
                                                            else
                                                                
                                                            end; 
                                                        end;
                                                    end;
                                                end;
                                                
                                                if L then
                                                    (function(arg1_117, ...)
                                                        r165 = arg1_117;
                                                        B = r165;
                                                        
                                                        if not B or not B.IsA(B, "ProximityPrompt") then
                                                            n = false;
                                                            
                                                            return n;
                                                        end;
                                                        
                                                        n = fireproximityprompt;
                                                        
                                                        if n then
                                                            pcall(function(...)
                                                                fireproximityprompt(r165);
                                                                
                                                                return; 
                                                            end);
                                                        else
                                                            if syn and syn.proximityprompt then
                                                                pcall(function(...)
                                                                    v = r15;
                                                                    
                                                                    syn.proximityprompt(r165);
                                                                    
                                                                    return; 
                                                                end);
                                                            else
                                                                r165.HoldDuration = 0;
                                                                
                                                                pcall(function(...)
                                                                    n = r165;
                                                                    
                                                                    n.InputHoldBegin(n);
                                                                    
                                                                    B = r16;
                                                                    
                                                                    task.wait(.05);
                                                                    
                                                                    n = r165;
                                                                    
                                                                    n.InputHoldEnd(n);
                                                                    
                                                                    return; 
                                                                end);
                                                                
                                                                r165.HoldDuration = r165.HoldDuration;
                                                            end;
                                                            
                                                            return true;
                                                        end; 
                                                    end)(L);
                                                    
                                                    J[I.name] = true;
                                                    
                                                    r39.Notify("Auto Pickup", "Picked up " .. I.name .. " key!", 2);
                                                    r39.PlayBell();
                                                end;
                                                
                                                task.wait(.3);
                                            end;
                                        end; 
                                    end;
                                    
                                    task.wait(0.5);
                                end;
                            end;
                        end;
                    end; 
                end;
                
                r39.AutoPickupEnabled = false;
                
                R = r35.AutoPickup;
                
                if R then
                    R = r35.AutoPickup;
                    
                    R.SetValue(R, false);
                end;
                
                return;
            else
                u = r160.CharacterAdded;
                
                k = u.Wait(u);
            end; 
        end);
        r39.Notify("Auto Pickup Keys", "Enabled", 3);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.ShowSpikesEnabled = false;
r39.ToggleShowSpikes = function(arg1_118, ...)
    d = arg1_118;
    
    r39.ShowSpikesEnabled = d;
    
    if d then
        r39.Notify("Show Spikes", "Enabled", 2);
    else
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.ZoneKillFeature = {
    ["Enabled"] = false,
    ["AnimationId"] = "rbxassetid://105341857343164",
    ["ZonePosition"] = Vector3.new(197.7, 54.6, -96.3),
    ["ReturnDelay"] = .6,
    ["SavedCFrame"] = nil,
    ["ActiveAnimation"] = false,
    ["AnimationStartTime"] = 0,
    ["AnimationConnection"] = nil,
    ["CharacterAddedConnection"] = nil,
    ["AnimationStoppedConnections"] = {},
    ["AnimationCheckConnection"] = nil,
    ["TrackedAnimations"] = {}
};
r39.ToggleZoneKill = function(arg1_119, ...)
    d = arg1_119;
    
    if d then
        if not r39.CanEnableToggle("LastDinner", "Zone Kill", r35.ZoneKill) then
            return false;
        end;
    end;
    
    r39.ZoneKillFeature.Enabled = d;
    
    if r39.ZoneKillFeature.AnimationConnection then
        n = r39.ZoneKillFeature.AnimationConnection;
        
        n.Disconnect(n);
        
        r39.ZoneKillFeature.AnimationConnection = nil;
    end;
    
    if r39.ZoneKillFeature.CharacterAddedConnection then
        n = r39.ZoneKillFeature.CharacterAddedConnection;
        
        n.Disconnect(n);
        
        r39.ZoneKillFeature.CharacterAddedConnection = nil;
    end;
    
    if r39.ZoneKillFeature.AnimationCheckConnection then
        n = r39.ZoneKillFeature.AnimationCheckConnection;
        
        n.Disconnect(n);
        
        r39.ZoneKillFeature.AnimationCheckConnection = nil;
    end;
    
    u = r39.ZoneKillFeature;
    j = u.AnimationStoppedConnections;
    B = u[2];
    G = u[3];
    
    for G, N in ipairs(k) do
        u = G;
        r166 = N;
        
        pcall(function(...)
            n = r166;
            
            n.Disconnect(n);
            
            return; 
        end); 
    end;
    
    r39.ZoneKillFeature.AnimationStoppedConnections = {};
    r39.ZoneKillFeature.SavedCFrame = nil;
    r39.ZoneKillFeature.ActiveAnimation = false;
    r39.ZoneKillFeature.AnimationStartTime = 0;
    r39.ZoneKillFeature.TrackedAnimations = {};
    
    if not d then
        r39.PlayBell();
        
        return true;
    end;
    
    local function r167(...)
        n = not r39.ZoneKillFeature.Enabled;
        
        if n then
            return;
        end;
        
        r168 = r39.GetCharacter();
        
        if not r168 then
            return;
        end;
        
        v = r39.GetHumanoid(r168);
        
        if not v then
            return;
        end;
        
        for j, c in pairs(v.GetPlayingAnimationTracks(v)) do
            N = j;
            
            if c then
                C = c.Animation;
            end;
            
            if c then
                C = c.Animation.AnimationId;
                
                if C then
                    y = C == r39.ZoneKillFeature.AnimationId;
                end;
                
                if C then
                    y = C .. "_" .. tostring(c);
                    
                    if not r39.ZoneKillFeature.TrackedAnimations[y] then
                        r39.ZoneKillFeature.TrackedAnimations[y] = true;
                        
                        if not r39.ZoneKillFeature.ActiveAnimation then
                            r39.ZoneKillFeature.ActiveAnimation = true;
                            
                            r39.ZoneKillFeature.AnimationStartTime = tick();
                            
                            U = r168;
                            
                            r39.ZoneKillFeature.SavedCFrame = U.GetPrimaryPartCFrame(U);
                            
                            n = r168;
                            
                            n.SetPrimaryPartCFrame(n, CFrame.new(r39.ZoneKillFeature.ZonePosition));
                            
                            n = c.Stopped;
                            
                            table.insert(r39.ZoneKillFeature.AnimationStoppedConnections, n.Connect(n, function(...)
                                task.wait(r39.ZoneKillFeature.ReturnDelay);
                                
                                if r39.ZoneKillFeature.SavedCFrame then
                                    n = r168;
                                    
                                    n.SetPrimaryPartCFrame(n, r39.ZoneKillFeature.SavedCFrame);
                                    
                                    r39.ZoneKillFeature.SavedCFrame = nil;
                                    r39.ZoneKillFeature.ActiveAnimation = false;
                                    r39.ZoneKillFeature.TrackedAnimations = {};
                                end;
                                
                                return; 
                            end));
                        end;
                    end;
                end;
            end; 
        end;
        
        return; 
    end;
    
    local function r169(arg1_120, ...)
        r170 = arg1_120;
        n = r170;
        
        v = n.WaitForChild(n, "Humanoid", 5);
        
        if not v then
            return;
        end;
        
        B = v.AnimationPlayed;
        
        r39.ZoneKillFeature.AnimationConnection = B.Connect(B, function(arg1_121, ...)
            d = arg1_121;
            j = r15;
            
            if not r39.ZoneKillFeature.Enabled then
                return;
            end;
            
            if d then
                k = d.Animation;
            end;
            
            if d then
                v = d.Animation.AnimationId;
                
                if v then
                    k = v == r39.ZoneKillFeature.AnimationId;
                end;
                
                if v then
                    r39.ZoneKillFeature.TrackedAnimations[v .. "_" .. tostring(d)] = true;
                    
                    if not r39.ZoneKillFeature.ActiveAnimation then
                        r39.ZoneKillFeature.ActiveAnimation = true;
                        
                        r39.ZoneKillFeature.AnimationStartTime = tick();
                        
                        G = r170;
                        
                        r39.ZoneKillFeature.SavedCFrame = G.GetPrimaryPartCFrame(G);
                        
                        n = r170;
                        
                        n.SetPrimaryPartCFrame(n, CFrame.new(r39.ZoneKillFeature.ZonePosition));
                        
                        n = d.Stopped;
                        
                        table.insert(r39.ZoneKillFeature.AnimationStoppedConnections, n.Connect(n, function(...)
                            
                            G = r16("\x08\x9b\x9d\x08", 4358623922157);
                            
                            task[r15[G]](r39.ZoneKillFeature.ReturnDelay);
                            
                            if r39.ZoneKillFeature.SavedCFrame then
                                n = r170;
                                
                                n.SetPrimaryPartCFrame(n, r39.ZoneKillFeature.SavedCFrame);
                                
                                r39.ZoneKillFeature.SavedCFrame = nil;
                            end;
                            
                            r39.ZoneKillFeature.ActiveAnimation = false;
                            r39.ZoneKillFeature.TrackedAnimations = {};
                            
                            return; 
                        end));
                    end;
                end;
            end;
            
            return; 
        end);
        
        return; 
    end;
    
    j = r34.Character;
    
    if j then
        r169(j);
    end;
    
    N = r34.CharacterAdded;
    
    r39.ZoneKillFeature.CharacterAddedConnection = N.Connect(N, function(arg1_122, ...)
        task.wait(1);
        
        r169(arg1_122);
        
        return; 
    end);
    
    N = r29.Heartbeat;
    r39.ZoneKillFeature.AnimationCheckConnection = N.Connect(N, function(...)
        if not r39.ZoneKillFeature.Enabled then
            return;
        end;
        
        r167();
        
        return; 
    end);
    
    r39.Notify("Zone Kill", "Enabled", 2);
    r39.PlayBell();
    
    return true; 
end;
r39.VoidKillEnabled = false;
r39.VoidKillConn = nil;
r39.VoidKillCharConn = nil;
r39.VoidAnimIds = {
    "rbxassetid://107989020363293",
    "rbxassetid://71619354165195"
};
r39.VoidZonePos = Vector3.new(-95.1, 964.6, 67.6);
r39.ToggleVoidKill = function(arg1_123, ...)
    d = arg1_123;
    
    if d then
        if not r39.CanEnableToggle("SkySquidGame", "Void Kill", r35.VoidKill) then
            return false;
        end;
    end;
    
    n = r39.VoidKillConn;
    
    if n then
        n = r39.VoidKillConn;
        
        n.Disconnect(n);
    end;
    
    n = r39.VoidKillCharConn;
    
    if n then
        n = r39.VoidKillCharConn;
        
        n.Disconnect(n);
    end;
    
    r39.VoidKillEnabled = d;
    
    if d then
        local function r171(arg1_124, ...)
            r172 = arg1_124;
            n = r172;
            B = n.WaitForChild(n, "Humanoid").AnimationPlayed;
            
            r39.VoidKillConn = B.Connect(B, function(arg1_125, ...)
                d = arg1_125;
                j = r16;
                v = d.Animation;
                
                if v then
                    
                    k = table.find(r39.VoidAnimIds, d.Animation.AnimationId);
                end;
                
                if v then
                    n = r172;
                    
                    r173 = n.GetPrimaryPartCFrame(n);
                    r174 = Instance.new("Part");
                    
                    r174.Name = "VoidKillAntiFall";
                    r174.Size = Vector3.new(10, 1, 10);
                    r174.Position = r39.VoidZonePos + Vector3.new(0, -4, 0);
                    r174.Anchored = true;
                    r174.CanCollide = true;
                    r174.Transparency = 1;
                    r174.Parent = workspace;
                    
                    n = r172;
                    
                    n.SetPrimaryPartCFrame(n, CFrame.new(r39.VoidZonePos.X, r39.VoidZonePos.Y, r39.VoidZonePos.Z));
                    
                    n = d.Stopped;
                    
                    n.Connect(n, function(...)
                        
                        G = r16("\x93v\xb3~", 13455941228665);
                        
                        task[r15[G]](1);
                        
                        n = r173;
                        
                        if n then
                            n = r172;
                            
                            n.SetPrimaryPartCFrame(n, r173);
                        end;
                        
                        n = r174;
                        
                        n.Destroy(n);
                        
                        return; 
                    end);
                end;
                
                return; 
            end);
            
            return; 
        end;
        
        if r34.Character then
            r171(r34.Character);
        end;
        
        G = r34.CharacterAdded;
        
        r39.VoidKillCharConn = G.Connect(G, function(arg1_126, ...)
            u = "*\x13\xf5\x9d";
            
            task[r15[r16(u, 23394657364621)]](1);
            
            r171(arg1_126);
            
            return; 
        end);
        
        r39.Notify("Void Kill", "Enabled", 2);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.MingleVoidKillEnabled = false;
r39.MingleConns = {};
r39.MingleAnimId = "rbxassetid://71318091779666";
r39.ToggleMingleVoidKill = function(arg1_127, ...)
    d = arg1_127;
    
    if d then
        if not r39.CanEnableToggle("Mingle", "Void Kill", r35.MingleVoidKill) then
            return false;
        end;
    end;
    
    u = r39;
    j = u.MingleConns;
    G = u[3];
    j = u[1];
    
    for G, N in j, pairs(j) do
        u = G;
        r175 = N;
        
        pcall(function(...)
            n = r175;
            
            n.Disconnect(n);
            
            return; 
        end); 
    end;
    
    r39.MingleConns = {};
    r39.MingleVoidKillEnabled = d;
    
    if d then
        local function r178(arg1_128, ...)
            r179 = arg1_128;
            n = r179;
            n = n.WaitForChild(n, "Humanoid").AnimationPlayed;
            
            table.insert(r39.MingleConns, n.Connect(n, function(arg1_129, ...)
                d = arg1_129;
                B = "Animation";
                
                if d[B] and d.Animation.AnimationId == r39.MingleAnimId then
                    n = r179;
                    
                    k = n.FindFirstChild(n, "HumanoidRootPart");
                    r180 = k;
                    
                    if r180 then
                        r177 = r180.Position;
                        k = r176;
                        
                        if k then
                            k = r176;
                            
                            k.Destroy(k);
                        end;
                        
                        r176 = Instance.new("Part");
                        
                        r176.Name = "MingleSafetyPlatform";
                        r176.Size = Vector3.new(100, 10, 100);
                        r176.Position = Vector3.new(r177.X, r177.Y - 30, r177.Z);
                        r176.Anchored = true;
                        r176.CanCollide = true;
                        r176.Transparency = .8;
                        r176.Color = Color3.fromRGB(0, 170, 255);
                        r176.Material = Enum.Material.Neon;
                        r176.Parent = workspace;
                        r180.CFrame = CFrame.new(r176.Position.X, r176.Position.Y + 3, r176.Position.Z);
                        
                        k = d.Stopped;
                        
                        k.Connect(k, function(...)
                            j = "z\xcc\xc29";
                            
                            task[r15[r16(j, 29234379896109)]](.6);
                            
                            if r177 then
                                
                                r180.CFrame = CFrame.new(r177);
                            end;
                            
                            if r176 then
                                n = r176;
                                
                                n.Destroy(n);
                            end;
                            
                            return; 
                        end);
                    end;
                end;
                
                return; 
            end));
            
            return; 
        end;
        
        if r34.Character then
            r178(r34.Character);
        end;
        
        c = r34.CharacterAdded;
        
        table.insert(r39.MingleConns, c.Connect(c, function(arg1_130, ...)
            task.wait(1);
            
            r178(arg1_130);
            
            return; 
        end));
        r39.Notify("Void Kill", "Enabled", 2);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.AutoChokeEnabled = false;
r39.AutoChokeConnection = nil;
r39.ToggleAutoChoke = function(arg1_131, ...)
    d = arg1_131;
    
    if d then
        if not r39.CanEnableToggle("Mingle", "Auto Choke", r35.AutoChoke) then
            return false;
        end;
    end;
    
    r39.AutoChokeEnabled = d;
    
    if d then
        n = r34.PlayerGui;
        
        r181 = n.FindFirstChild(n, "ImpactFrames");
        n = r181;
        
        if n then
            r182 = {};
            n = r181.ChildAdded;
            
            n.Connect(n, function(arg1_132, ...)
                r183 = arg1_132;
                j = "Name";
                
                if r183[j] ~= "OuterRingTemplate" or r182[r183] then
                    return;
                end;
                
                r182[r183] = true;
                
                task.defer(function(...)
                    n = pairs;
                    G = r181;
                    G = {
                        n(G.GetChildren(G))
                    };
                    v = G[2];
                    
                    G = n(G.GetChildren(G));
                    
                    if G(v, G[3]) then
                        U = r16;
                        N = u.Name == "InnerTemplate" and (u.Position == r183.Position and not u.GetAttribute(u, "Failed"));
                        
                        U.HpFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100);
                        
                        G, N = B(B, k);
                        
                        while G do
                            
                            u = j(B, k);
                            U = r16;
                            
                            if N.IsA(N, "Model") and N.FindFirstChild(N, "Humanoid") then
                                U = r183;
                                e = {
                                    U.GetPlayers(U)
                                };
                                y = U[2];
                                C = U[1];
                                
                                for x, e in pairs(w(e)) do
                                    U = x;
                                    
                                    if e.Name == N.Name then
                                        c = true;
                                    else
                                        
                                    end; 
                                end;
                                
                                if false then
                                    
                                else
                                    
                                    C = N.FindFirstChildOfClass(N, "Humanoid");
                                    x = C;
                                    
                                    if C then
                                        n = pairs;
                                        x = C.Health > 0 and not N.GetAttribute(N, "BodyDespawntime");
                                    end;
                                    
                                    n = pairs;
                                    
                                    if x then
                                        v[N] = true;
                                        
                                        x = N.FindFirstChild(N, "HumanoidRootPart");
                                        e = U;
                                        U = x;
                                        
                                        if x then
                                            
                                            U = x.IsA(x, "BasePart");
                                        end;
                                        
                                        n = e;
                                        
                                        if U then
                                            if not r181.GuardOriginalSizes[x] then
                                                r181.GuardOriginalSizes[x] = x.Size;
                                            end;
                                            
                                            x.Size = Vector3.new(r181.GuardHitboxSize, r181.GuardHitboxSize, r181.GuardHitboxSize);
                                            x.Transparency = .4;
                                            x.Color = Color3.fromRGB(255, 100, 100);
                                            x.Material = Enum.Material.Neon;
                                            x.CanCollide = false;
                                            
                                            if not r181.GuardESPObjects[N] then
                                                
                                                e = Instance.new("Highlight");
                                                
                                                e.FillTransparency = 0.75;
                                                e.OutlineTransparency = .15;
                                                e.FillColor = Color3.fromRGB(255, 100, 100);
                                                e.OutlineColor = Color3.fromRGB(255, 100, 100);
                                                e.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                                                e.Parent = r27;
                                                J = Instance.new("BillboardGui");
                                                J.Size = UDim2.new(0, 130, 0, 40);
                                                J.StudsOffset = Vector3.new(0, 2.5, 0);
                                                J.AlwaysOnTop = true;
                                                J.Parent = r27;
                                                R = Instance.new("TextLabel");
                                                R.Size = UDim2.new(1, 0, 0.5, 0);
                                                R.BackgroundTransparency = 1;
                                                R.TextSize = 11;
                                                R.Font = Enum.Font.GothamBold;
                                                R.TextStrokeTransparency = .2;
                                                R.TextColor3 = Color3.fromRGB(255, 100, 100);
                                                R.Text = "Guard";
                                                R.TextXAlignment = Enum.TextXAlignment.Center;
                                                R.Parent = J;
                                                r = Instance.new("Frame");
                                                r.Size = UDim2.new(0.5, 0, .1, 0);
                                                r.Position = UDim2.new(0.25, 0, .65, 0);
                                                r.BackgroundColor3 = Color3.fromRGB(40, 40, 45);
                                                r.BorderSizePixel = 0;
                                                r.Parent = J;
                                                m = Instance.new("UICorner");
                                                m.CornerRadius = UDim.new(0, 2);
                                                m.Parent = r;
                                                P = Instance.new("Frame");
                                                P.Size = UDim2.new(1, 0, 1, 0);
                                                P.BackgroundColor3 = Color3.fromRGB(255, 100, 100);
                                                P.BorderSizePixel = 0;
                                                P.Parent = r;
                                                D = Instance.new("UICorner");
                                                D.CornerRadius = UDim.new(0, 2);
                                                D.Parent = P;
                                                
                                                r181.GuardESPObjects[N] = {
                                                    ["Highlight"] = e,
                                                    ["Billboard"] = J,
                                                    ["Name"] = R,
                                                    ["HpFill"] = P
                                                };
                                            end;
                                            
                                            U = r181.GuardESPObjects[N];
                                            
                                            U.Highlight.Adornee = N;
                                            U.Billboard.Adornee = x;
                                            
                                            e = C.Health / C.MaxHealth;
                                            
                                            U.HpFill.Size = UDim2.new(e, 0, 1, 0);
                                            
                                            if e > .6 then
                                                
                                                U.HpFill.BackgroundColor3 = Color3.fromRGB(100, 220, 140);
                                            else
                                                if e > .3 then
                                                    
                                                    U.HpFill.BackgroundColor3 = Color3.fromRGB(255, 180, 80);
                                                else
                                                    
                                                    U.HpFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100);
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end; 
                        end;
                        
                        c = r181;
                        N = c.GuardESPObjects;
                        u = c[3];
                        j = c[2];
                        
                        for u, N in pairs(N) do
                            r185 = N;
                            
                            if not v[u] then
                                pcall(function(...)
                                    n = r185.Highlight;
                                    
                                    if n then
                                        n = r185.Highlight;
                                        
                                        n.Destroy(n);
                                    end;
                                    
                                    n = r185.Billboard;
                                    
                                    if n then
                                        n = r185.Billboard;
                                        
                                        n.Destroy(n);
                                    end;
                                    
                                    return; 
                                end);
                                
                                r181.GuardESPObjects[u] = nil;
                            end; 
                        end;
                        
                        return;
                    end;
                    
                    n = n;
                    
                    if not r184 or (u.GetAttribute(u, "Tweening") or u.GetAttribute(u, "Failed")) then
                        return;
                    end;
                    
                    r186 = require(r27.Modules.HBGQTE);
                    
                    pcall(function(...)
                        j = "\xf7\xefWXu\x81\xcb";
                        
                        r186[r15[r16(j, 6147216837422)]](false, {
                            ["Inner"] = r184,
                            ["Outer"] = r183,
                            ["Duration"] = 2,
                            ["StartedAt"] = tick(),
                            ["Data"] = {}
                        });
                        
                        return; 
                    end);
                    
                    return; 
                end);
                
                return; 
            end);
        end;
        
        r39.Notify("Auto Choke", "Enabled", 3);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.SkySquidAntiFall = {
    ["Enabled"] = false,
    ["Platform"] = nil,
    ["Conn"] = nil
};
r39.ToggleSkySquidAntiFall = function(arg1_133, ...)
    d = arg1_133;
    n = r39.SkySquidAntiFall.Conn;
    
    if n then
        n = r39.SkySquidAntiFall.Conn;
        
        n.Disconnect(n);
    end;
    
    n = r39.SkySquidAntiFall.Platform;
    
    if n then
        n = r39.SkySquidAntiFall.Platform;
        
        n.Destroy(n);
    end;
    
    r39.SkySquidAntiFall.Enabled = d;
    
    if d then
        local function r187(...)
            n = r39.GetCharacter;
            
            d = n();
            
            if not d then
                return nil;
            end;
            
            v = r39.GetRootPart(d);
            
            if not v then
                return nil;
            end;
            
            B = Instance.new("Part");
            
            B.Name = "SkySquidAntiFall";
            B.Size = Vector3.new(10000, 1, 10000);
            B.Position = Vector3.new(v.Position.X, v.Position.Y - 5, v.Position.Z);
            B.Anchored = true;
            B.CanCollide = true;
            B.Transparency = 1;
            B.Parent = workspace;
            
            return B; 
        end;
        
        r39.SkySquidAntiFall.Platform = r187();
        
        B = r29.Heartbeat;
        
        r39.SkySquidAntiFall.Conn = B.Connect(B, function(...)
            j = r16;
            n = not r39.SkySquidAntiFall.Enabled;
            
            if n then
                return;
            end;
            
            n = n;
            
            if not (r39.SkySquidAntiFall.Platform and r39.SkySquidAntiFall.Platform.Parent) then
                
                r39.SkySquidAntiFall.Platform = r187();
            end;
            
            return; 
        end);
        
        r39.Notify("AntiFall", "Created invisible platform!", 3);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.FullbrightEnabled = false;
r39.FullbrightSettings = {};
r39.FullbrightConnection = nil;
r39.ToggleFullbright = function(arg1_134, ...)
    d = arg1_134;
    v = arg1_134;
    
    r39.FullbrightEnabled = v;
    
    n = game;
    
    r188 = n.GetService(n, "Lighting");
    
    if d then
        r39.FullbrightSettings.Brightness = r188.Brightness;
        r39.FullbrightSettings.ClockTime = r188.ClockTime;
        r39.FullbrightSettings.FogEnd = r188.FogEnd;
        r39.FullbrightSettings.GlobalShadows = r188.GlobalShadows;
        r39.FullbrightSettings.OutdoorAmbient = r188.OutdoorAmbient;
        r39.FullbrightSettings.Ambient = r188.Ambient;
        r188.Brightness = 2;
        r188.ClockTime = 14;
        r188.FogEnd = 100000;
        r188.GlobalShadows = false;
        
        r188.OutdoorAmbient = Color3.fromRGB(128, 128, 128);
        r188.Ambient = Color3.fromRGB(255, 255, 255);
        
        n = r39.FullbrightConnection;
        
        if n then
            n = r39.FullbrightConnection;
            
            n.Disconnect(n);
        end;
        
        B = r188.Changed;
        
        r39.FullbrightConnection = B.Connect(B, function(arg1_135, ...)
            d = arg1_135;
            j = r16;
            
            if not r39.FullbrightEnabled then
                return;
            end;
            
            r188.Brightness = 2;
            r188.ClockTime = 14;
            r188.FogEnd = 100000;
            r188.GlobalShadows = false;
            
            r188.OutdoorAmbient = Color3.fromRGB(128, 128, 128);
            r188.Ambient = Color3.fromRGB(255, 255, 255);
            
            return; 
        end);
        
        r39.Notify("Fullbright", "Enabled", 3);
    else
        u = r39;
        j = u.FullbrightSettings;
        G = u[3];
        j = u[1];
        
        for G, N in j, pairs(j) do
            r189 = G;
            r190 = N;
            
            pcall(function(...)
                r188[r189] = X[n];
                
                return; 
            end); 
        end;
        
        if r39.FullbrightConnection then
            n = r39.FullbrightConnection;
            
            n.Disconnect(n);
            
            r39.FullbrightConnection = nil;
        end;
        
        r39.PlayBell();
        
        return;
    end; 
end;
r39.AutoCollectBandage = false;
r39.AutoCollectBandageConnection = nil;
r39.HasTool = function(arg1_136, ...)
    d = arg1_136;
    u = "\x0e-\xf0\x90\x97o\x92\xecG\xd5~m";
    
    v = r39[r15[r16(u, 14908065520414)]]();
    
    if v then
        u = v.GetChildren;
        j = {
            u(v)
        };
        G = u[3];
        B = u[2];
        
        for G, N in pairs(w("pairs")) do
            u = G;
            
            if N.IsA(N, "Tool") and N.Name == d then
                return true;
            else
                
            end; 
        end;
    end;
    
    n = r34;
    
    B = n.FindFirstChild(n, "Backpack");
    
    if B then
        c = B.GetChildren;
        j = c[2];
        u = c[3];
        
        for u, c in pairs(c(B)) do
            N = u;
            
            if c.IsA(c, "Tool") and c.Name == d then
                return true;
            else
                
            end; 
        end;
    end;
    
    return false; 
end;
r39.StartAutoCollectBandage = function(...)
    if r39.AutoCollectBandageConnection then
        n = r39.AutoCollectBandageConnection;
        
        n.Disconnect(n);
        
        r39.AutoCollectBandageConnection = nil;
    end;
    
    d = r29.Heartbeat;
    
    r39.AutoCollectBandageConnection = d.Connect(d, function(...)
        B = r15;
        n = not r39.AutoCollectBandage;
        
        if n then
            return;
        end;
        
        if not r39.HasTool("Bandage") and r34.Character then
            j = "\xd7p\x1e\xf4\xfb\x06\xfe";
            n = workspace;
            
            G = r16(j, 24218472737805);
            
            d = n.FindFirstChild(n, r15[G]);
            
            if d then
                j = d.GetChildren;
                G = {
                    j(d)
                };
                G = j[1];
                v = j[2];
                
                for B, u in pairs(w(G)) do
                    j = B;
                    
                    if u.Name == "DroppedBandage" and u.FindFirstChild(u, "Handle") then
                        r34.Character.HumanoidRootPart.CFrame = u.Handle.CFrame;
                        
                        task.wait(.3);
                        
                        C = r34.Character;
                        
                        if C then
                            C = r34.Character;
                            
                            c = C.FindFirstChild(C, "HumanoidRootPart");
                        end;
                        
                        if C then
                            C = r34.Character.HumanoidRootPart.CFrame;
                            
                            r34.Character.HumanoidRootPart.CFrame = C;
                        end;
                    else
                        
                    end; 
                end;
            end;
        end;
        
        return; 
    end);
    
    return; 
end;
r39.ToggleAutoCollectBandage = function(arg1_137, ...)
    d = arg1_137;
    
    r39.AutoCollectBandage = d;
    
    if d then
        r39.StartAutoCollectBandage();
    else
        if r39.AutoCollectBandageConnection then
            n = r39.AutoCollectBandageConnection;
            
            n.Disconnect(n);
            
            r39.AutoCollectBandageConnection = nil;
        end;
        
        r39.PlayBell();
        
        return;
    end; 
end;
r39.currentAnim = nil;
r39.currentSound = nil;
r39.stopEmote = function(...)
    if r39.currentAnim then
        n = r39.currentAnim;
        
        n.Stop(n);
        
        r39.currentAnim = nil;
    end;
    
    if r39.currentSound then
        n = r39.currentSound;
        
        n.Stop(n);
        
        n = r39.currentSound;
        
        n.Destroy(n);
        
        r39.currentSound = nil;
    end;
    
    return; 
end;
r39.PlayDreamJournal = function(...)
    r39.stopEmote();
    d = Instance.new("Animation");
    
    d.AnimationId = "rbxassetid://117325441970867";
    v = r39.GetHumanoid(r39.GetCharacter());
    
    if v then
        
        r39.currentAnim = v.LoadAnimation(v, d);
        
        n = r39.currentAnim;
        
        n.Play(n);
        B = Instance.new("Sound");
        
        B.SoundId = "rbxassetid://88476306353688";
        B.Volume = 10;
        B.Looped = true;
        B.Parent = r32;
        
        B.Play(B);
        
        r39.currentSound = B;
        
        r39.Notify("Emote", "Dream Journal", 2);
        r39.PlayBell();
    end;
    
    return; 
end;
r39.PlayOtsukareSummer = function(...)
    r39.stopEmote();
    d = Instance.new("Animation");
    
    d.AnimationId = "rbxassetid://134888005420629";
    v = r39.GetHumanoid(r39.GetCharacter());
    
    if v then
        
        r39.currentAnim = v.LoadAnimation(v, d);
        
        n = r39.currentAnim;
        
        n.Play(n);
        B = Instance.new("Sound");
        
        B.SoundId = "rbxassetid://127332409398776";
        B.Volume = 3;
        B.Looped = true;
        B.Parent = r32;
        
        B.Play(B);
        
        r39.currentSound = B;
        
        r39.Notify("Emote", "Otsukare Summer", 2);
        r39.PlayBell();
    end;
    
    return; 
end;
r39.PlaySpite = function(...)
    r39.stopEmote();
    d = Instance.new("Animation");
    
    d.AnimationId = "rbxassetid://100382123964355";
    v = r39.GetHumanoid(r39.GetCharacter());
    
    if v then
        
        r39.currentAnim = v.LoadAnimation(v, d);
        
        n = r39.currentAnim;
        
        n.Play(n);
        B = Instance.new("Sound");
        
        B.SoundId = "rbxassetid://90513005423910";
        B.Volume = 5;
        B.Looped = true;
        B.Parent = r32;
        
        B.Play(B);
        
        r39.currentSound = B;
        
        r39.Notify("Emote", "Spite", 2);
        r39.PlayBell();
    end;
    
    return; 
end;
r39.PlayShuffle = function(...)
    r39.stopEmote();
    d = Instance.new("Animation");
    
    d.AnimationId = "rbxassetid://113121578988536";
    v = r39.GetHumanoid(r39.GetCharacter());
    
    if v then
        
        r39.currentAnim = v.LoadAnimation(v, d);
        
        n = r39.currentAnim;
        
        n.Play(n);
        
        B = {
            "rbxassetid://18278587259",
            "rbxassetid://104805805321503",
            "rbxassetid://127426881747595"
        };
        j = Instance.new("Sound");
        k = B[math.random(1, #B)];
        
        j.SoundId = k;
        j.Volume = 5;
        j.Looped = true;
        j.Parent = r32;
        
        j.Play(j);
        
        r39.currentSound = j;
        
        r39.Notify("Emote", "Shuffle", 2);
        r39.PlayBell();
    end;
    
    return; 
end;
r39.PlayYareYare = function(...)
    r39.stopEmote();
    d = Instance.new("Animation");
    
    d.AnimationId = "rbxassetid://86642655479570";
    v = r39.GetHumanoid(r39.GetCharacter());
    
    if v then
        
        r39.currentAnim = v.LoadAnimation(v, d);
        
        n = r39.currentAnim;
        
        n.Play(n);
        B = Instance.new("Sound");
        
        B.SoundId = "rbxassetid://128193072645447";
        B.Volume = 5;
        B.Looped = true;
        B.Parent = r32;
        
        B.Play(B);
        
        r39.currentSound = B;
        
        r39.Notify("Emote", "Yare Yare", 2);
        r39.PlayBell();
    end;
    
    return; 
end;
r39.PlayFateOfBothWorlds = function(...)
    r39.stopEmote();
    d = Instance.new("Animation");
    
    d.AnimationId = "rbxassetid://114244682550258";
    v = r39.GetHumanoid(r39.GetCharacter());
    
    if v then
        
        r39.currentAnim = v.LoadAnimation(v, d);
        
        n = r39.currentAnim;
        
        n.Play(n);
        B = Instance.new("Sound");
        
        B.SoundId = "rbxassetid://103081000050688";
        B.Volume = 5;
        B.Looped = true;
        B.Parent = r32;
        
        B.Play(B);
        
        r39.currentSound = B;
        
        r39.Notify("Emote", "Fate Of Both Worlds", 2);
        r39.PlayBell();
    end;
    
    return; 
end;
r39.PlayPerfectVictory = function(...)
    r39.stopEmote();
    d = Instance.new("Animation");
    
    d.AnimationId = "rbxassetid://110501561372722";
    v = r39.GetHumanoid(r39.GetCharacter());
    
    if v then
        
        r39.currentAnim = v.LoadAnimation(v, d);
        
        n = r39.currentAnim;
        
        n.Play(n);
        B = Instance.new("Sound");
        
        B.SoundId = "rbxassetid://104280886491008";
        B.Volume = 5;
        B.Looped = true;
        B.Parent = r32;
        
        B.Play(B);
        
        r39.currentSound = B;
        
        r39.Notify("Emote", "My Perfect Victory", 2);
        r39.PlayBell();
    end;
    
    return; 
end;
r39.PlayPosingTime = function(...)
    r39.stopEmote();
    d = Instance.new("Animation");
    
    d.AnimationId = "rbxassetid://89240795237958";
    v = r39.GetHumanoid(r39.GetCharacter());
    
    if v then
        
        r39.currentAnim = v.LoadAnimation(v, d);
        
        n = r39.currentAnim;
        
        n.Play(n);
        B = Instance.new("Sound");
        
        B.SoundId = "rbxassetid://113259086406604";
        B.Volume = 1;
        B.Looped = true;
        B.Parent = r32;
        
        B.Play(B);
        
        r39.currentSound = B;
        
        r39.Notify("Emote", "Posing Time", 2);
        r39.PlayBell();
    end;
    
    return; 
end;
r39.StopAllEmotes = function(...)
    r39.stopEmote();
    r39.Notify("Emote", "All emotes stopped", 2);
    r39.PlayBell();
    
    return; 
end;
r39.RLGL_TP_End = function(...)
    if r39.IsGameActive("RedLightGreenLight") then
        r39.SafeTeleport(Vector3.new(-214.4, 1023.1, 146.7));
        r39.Notify("RLGL", "Teleported to End", 2);
    else
        r39.Notify("RLGL", "Wait for RedLightGreenLight!", 2);
    end;
    
    r39.PlayBell();
    
    return; 
end;
r39.GodModeEnabled = false;
r39.GodModeConn = nil;
r39.GodModeOrigY = nil;
r39.ToggleGodMode = function(arg1_138, ...)
    d = arg1_138;
    
    j = r16("\xb6\x17\x8d\xdd\x0eA\xcb", 7300456041799);
    
    if d then
        if not r39.CanEnableToggle("RedLightGreenLight", "God Mode", r35[r15[j]]) then
            return false;
        end;
    end;
    
    if d then
        if r39.GodModeConn then
            n = r39.GodModeConn;
            
            n.Disconnect(n);
            
            r39.GodModeConn = nil;
        end;
        
        r39.GodModeEnabled = true;
        
        B = r39.GetCharacter();
        
        if not B then
            r39.Notify("GodMode", "Character not found", 2);
            
            r39.GodModeEnabled = false;
            
            r39.PlayBell();
            
            return false;
        end;
        
        G = B.FindFirstChild(B, "HumanoidRootPart") or B.PrimaryPart;
        
        if G then
            r39.GodModeOrigY = G.Position.Y;
            
            r39.SafeTeleport(Vector3.new(G.Position.X, G.Position.Y + 170, G.Position.Z));
            r39.Notify("GodMode", "Enabled", 2);
        end;
        
        j = r29.Heartbeat;
        
        r39.GodModeConn = j.Connect(j, function(...)
            N = "\x9aZF\x00@\xe2\x16)Q.f\xdd\xa4\xc9";
            
            if r39[r15[r16(N, 16991016247016)]] and not r39.IsGameActive("RedLightGreenLight") then
                r39.DisableToggle("GodMode");
            end;
            
            return; 
        end);
    else
        r39.GodModeEnabled = false;
        
        if r39.GodModeConn then
            n = r39.GodModeConn;
            
            n.Disconnect(n);
            
            r39.GodModeConn = nil;
        end;
        
        if r39.GodModeOrigY then
            
            B = r39.GetCharacter();
            
            if B then
                
                G = B.FindFirstChild(B, "HumanoidRootPart");
                
                if G then
                    r39.SafeTeleport(Vector3.new(G.Position.X, r39.GodModeOrigY, G.Position.Z));
                end;
            end;
        end;
        
        r39.GodModeOrigY = nil;
        
        r39.PlayBell();
        
        return true;
    end; 
end;
r39.RemoveInjuryEnabled = false;
r39.RemoveInjuryConnection = nil;

local function r191(...)
    n = game;
    
    d = n.GetService(n, "Workspace");
    n = game;
    G = d.FindFirstChild(d, "Live");
    
    if not G then
        return;
    end;
    
    j = G.FindFirstChild(G, n.GetService(n, "Players").LocalPlayer.Name);
    
    if j then
        
        v1 = j.FindFirstChild(j, "InjuredWalking");
        
        if v1 then
            v1.Destroy(v1);
        end;
        
        v5 = j.FindFirstChild(j, "Stun", "Stunned", "Crawling", "Crawl", "Crawled");
        
        if v5 then
            v5.Destroy(v5);
        end;
    end;
    
    return; 
end;

r39.ToggleRemoveInjury = function(arg1_139, ...)
    d = arg1_139;
    
    if d then
        if not r39.CanEnableToggle("RedLightGreenLight", "Remove Injury", r35.RemoveInjury) then
            return false;
        end;
    end;
    
    r39.RemoveInjuryEnabled = d;
    
    if r39.RemoveInjuryConnection then
        n = r39.RemoveInjuryConnection;
        
        n.Disconnect(n);
        
        r39.RemoveInjuryConnection = nil;
    end;
    
    if d then
        r191();
        
        B = r29.Heartbeat;
        
        r39.RemoveInjuryConnection = B.Connect(B, function(...)
            j = "\x05\xe6(\x92v\xc5R\xa6\xbc\x96\xfdd\x9b\xbdwQ'\xe0\x03";
            
            if r39[r15[r16(j, 30454413293413)]] then
                r191();
            end;
            
            return; 
        end);
        
        r39.Notify("Remove Injury", "Enabled", 3);
    else
    end;
    
    r39.PlayBell();
    
    return true; 
end;
r39.noclipEnabled = false;
r39.noclipButton = nil;
r39.noclipConnection = nil;
r39.TELEPORT_DISTANCE = 13;
r39.RAY_LENGTH = 6;
r39.createNoclipButton = function(...)
    n = r39.noclipButton;
    
    if n then
        n = r39.noclipButton;
        
        n.Destroy(n);
    end;
    
    d = Instance.new("ScreenGui");
    
    d.Name = "NoclipButton";
    d.ResetOnSpawn = false;
    
    k = r34;
    d.Parent = k.WaitForChild(k, "PlayerGui");
    r192 = Instance.new("TextButton");
    r192.Size = UDim2.new(0, 80, 0, 80);
    r192.Position = UDim2.new(1, -100, 0, 100);
    r192.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    r192.BackgroundTransparency = 0.5;
    r192.Text = "TP";
    r192.TextColor3 = Color3.new(1, 1, 1);
    r192.TextSize = 20;
    r192.Font = Enum.Font.GothamBold;
    r192.Parent = d;
    B = Instance.new("UIStroke");
    B.Color = Color3.fromRGB(255, 255, 255);
    B.Thickness = 2;
    B.Parent = r192;
    G = Instance.new("UICorner");
    G.CornerRadius = UDim.new(0, 10);
    G.Parent = r192;
    
    r193 = false;
    n = r192.InputBegan;
    
    n.Connect(n, function(arg1_140, ...)
        d = arg1_140;
        
        c = r16("\x8aId!L2z\xf7x\x9a\xa3\xcf\x01", 6615204989960);
        
        if d.UserInputType == Enum[r15[c]].Touch then
            r193 = true;
            r194 = d.Position;
            r195 = r192.Position;
        end;
        
        return; 
    end);
    
    n = r192.InputChanged;
    
    n.Connect(n, function(arg1_141, ...)
        d = arg1_141;
        
        if r193 and d.UserInputType == Enum.UserInputType.Touch then
            v = d.Position - r194;
            
            c = r16("\x9d\xef\xde", 10044336165445);
            
            r192.Position = UDim2[r15[c]](r195.X.Scale, r195.X.Offset + v.X, r195.Y.Scale, r195.Y.Offset + v.Y);
        end;
        
        return; 
    end);
    
    n = r192.InputEnded;
    
    n.Connect(n, function(arg1_142, ...)
        
        c = r16("\x98\x05Al\xd3-.2\x07\xf8\x8de\x1d", 26844986011860);
        
        if arg1_142.UserInputType == Enum[r15[c]].Touch then
            r193 = false;
        end;
        
        return; 
    end);
    
    n = r192.MouseButton1Click;
    
    n.Connect(n, function(...)
        r39.teleportThroughWall();
        
        return; 
    end);
    
    r39.noclipButton = d;
    
    return d; 
end;
r39.teleportThroughWall = function(...)
    if not r39.noclipEnabled then
        return;
    end;
    
    d = r34.Character;
    
    if not d then
        return;
    end;
    
    v = d.FindFirstChild(d, "HumanoidRootPart");
    
    if not v then
        return;
    end;
    
    B = workspace.CurrentCamera;
    
    if not B then
        return;
    end;
    
    G = B.CFrame.LookVector;
    j = v.Position;
    
    u = RaycastParams.new();
    
    u.FilterType = Enum.RaycastFilterType.Blacklist;
    u.FilterDescendantsInstances = {
        d
    };
    u.IgnoreWater = true;
    
    n = workspace;
    N = n.Raycast(n, j, G * r39.RAY_LENGTH, u);
    c = j + G * r39.TELEPORT_DISTANCE;
    
    if N then
        y = N.Normal;
        c = N.Position + G * 3 + y * 2;
    end;
    
    v.CanCollide = false;
    
    v.CFrame = CFrame.new(c);
    
    task.wait();
    
    v.CanCollide = true;
    
    return; 
end;
r39.desyncHooked = false;

r39.desyncAvailable = pcall(function(...)
    return raknet and raknet.add_send_hook; 
end);
r39.rakhook = function(arg1_143, ...)
    B = r15;
    d = arg1_143;
    
    if d.PacketId == 27 then
        B = buffer;
        v = d.AsBuffer;
        
        if B then
            k = buffer.writeu32;
        end;
        
        if B then
            buffer.writeu32(v, 1, 4294967295);
            d.SetData(d, v);
        end;
    end;
    
    return; 
end;
r39.ToggleDesync = function(arg1_144, ...)
    d = arg1_144;
    r196 = r35.Desync;
    
    if d then
        
        k = r39.IsXenoExecutor();
    end;
    
    if d then
        r39.Notify("Desync", "Not supported in your executor", 5);
        
        if r196 and r196.SetValue then
            pcall(function(...)
                n = r196;
                
                n.SetValue(n, false);
                
                return; 
            end);
        end;
        
        return false;
    end;
    
    if not r39.desyncAvailable then
        r39.Notify("Desync", "Unsupported Executor", 3);
        
        if r196 and r196.SetValue then
            pcall(function(...)
                n = r196;
                
                n.SetValue(n, false);
                
                return; 
            end);
        end;
        
        return false;
    end;
    
    if d then
        if not r39.desyncHooked then
            pcall(function(...)
                B = r16;
                
                raknet.add_send_hook(r39.rakhook);
                
                r39.desyncHooked = true;
                
                r39.Notify("Desync", "Enabled", 3);
                
                return; 
            end);
        end;
    else
        if r39.desyncHooked then
            pcall(function(...)
                B = r16;
                
                raknet.remove_send_hook(r39.rakhook);
                
                r39.desyncHooked = false;
                
                return; 
            end);
        end;
        
        return true;
    end; 
end;
r39.PlayerAttachEnabled = false;
r39.attachedTarget = nil;
r39.attachConnection = nil;
r39.autoSearchConnection = nil;
r39.BehindSquare = nil;
r39.FrontSquare = nil;
r39.CurrentSquare = nil;
r39.CurrentBodyVelocity = nil;
r39.AttachConfig = {
    ["BehindDistance"] = 2.5,
    ["FrontDistance"] = 16,
    ["SpeedThreshold"] = 17,
    ["MaxSpeed"] = 500,
    ["TransitionSpeed"] = 150
};
r39.createSquare = function(arg1_145, arg2_145, ...)
    v = arg2_145;
    
    B = Instance.new("Part");
    k = arg1_145;
    
    B.Name = k;
    B.Size = Vector3.new(3, 0.5, 3);
    B.Transparency = 1;
    B.CanCollide = false;
    B.Anchored = true;
    B.Massless = true;
    B.Parent = workspace;
    
    return B; 
end;
r39.destroySquares = function(...)
    if r39.BehindSquare then
        n = r39.BehindSquare;
        
        n.Destroy(n);
        
        r39.BehindSquare = nil;
    end;
    
    if r39.FrontSquare then
        n = r39.FrontSquare;
        
        n.Destroy(n);
        
        r39.FrontSquare = nil;
    end;
    
    return; 
end;
r39.isTargetMovingForward = function(arg1_146, ...)
    d = arg1_146;
    
    if not d then
        return false;
    end;
    
    v = d.Velocity;
    
    if math.sqrt(v.X ^ 2 + v.Z ^ 2) < 2 then
        return false;
    end;
    
    G = d.CFrame.LookVector;
    u = Vector3.new(G.X, 0, G.Z).Unit;
    
    return u.Dot(u, Vector3.new(v.X, 0, v.Z).Unit) > .7; 
end;
r39.updateSquares = function(arg1_147, ...)
    d = arg1_147;
    
    if not d then
        return;
    end;
    
    v = d.Position;
    B = d.CFrame.LookVector;
    G = d.Position.Y;
    j = v + -B * r39.AttachConfig.BehindDistance;
    
    j = Vector3.new(j.X, G - 2, j.Z);
    u = v + B * r39.AttachConfig.FrontDistance;
    u = Vector3.new(u.X, G - 2, u.Z);
    C = "BehindSquare";
    
    if r39[C] then
        C = k;
        
        r39.BehindSquare.Position = C;
    end;
    
    C = "FrontSquare";
    
    if r39[C] then
        C = N;
        
        r39.FrontSquare.Position = C;
    end;
    
    return; 
end;
r39.getTargetSquare = function(arg1_148, ...)
    d = arg1_148;
    
    if not d then
        return r39.BehindSquare;
    end;
    
    v = d.Velocity;
    G = math.sqrt(v.X ^ 2 + v.Z ^ 2) > r39.AttachConfig.SpeedThreshold;
    
    if G then
        
        k = n(d);
    end;
    
    if G then
        return r39.FrontSquare;
    end;
    
    return r39.BehindSquare; 
end;
r39.applySmoothMovement = function(arg1_149, arg2_149, ...)
    d = arg1_149;
    v = arg2_149;
    B = r34.Character;
    
    if not B then
        return;
    end;
    
    G = B.FindFirstChild(B, "HumanoidRootPart");
    j = B.FindFirstChildOfClass(B, "Humanoid");
    
    if not G or not j then
        return;
    end;
    
    if not d then
        return;
    end;
    
    u = G.Position;
    N = (d - u).Magnitude;
    
    if N > .3 then
        n = (d - u).Unit;
        c = r39.CurrentBodyVelocity;
        
        if v then
            C = r39.AttachConfig.TransitionSpeed;
        end;
        
        n = n;
        y = c * math.min(v or r39.AttachConfig.MaxSpeed, N * 10);
        n = r39.CurrentBodyVelocity;
        
        if n then
            n = r39.CurrentBodyVelocity;
            
            n.Destroy(n);
        end;
        
        r39.CurrentBodyVelocity = Instance.new("BodyVelocity");
        r39.CurrentBodyVelocity.MaxForce = Vector3.new(50000, 0, 50000);
        r39.CurrentBodyVelocity.Velocity = Vector3.new(y.X, 0, y.Z);
        x = B.FindFirstChild(B, "HumanoidRootPart");
        
        r39.CurrentBodyVelocity.Parent = x;
        
        task.wait(.03);
        
        if r39.CurrentBodyVelocity then
            n = r39.CurrentBodyVelocity;
            
            n.Destroy(n);
            
            r39.CurrentBodyVelocity = nil;
        end;
    end;
    
    j.AutoRotate = true;
    
    return; 
end;
r39.FindBestTarget = function(...)
    d = r34;
    
    if not d then
        return nil;
    end;
    
    v = r39.IsSeeker(d);
    B = r39.IsHider(d);
    G = r34.Character;
    
    if not G then
        return nil;
    end;
    
    j = G.FindFirstChild(G, "HumanoidRootPart");
    
    if not j then
        return nil;
    end;
    
    y = r26;
    y = "pairs";
    
    for C, U in pairs(y.GetPlayers(y)) do
        J = U ~= r34;
        x = C;
        
        if J then
            e = U.Character;
        end;
        
        if J then
            n = U.Character;
            
            e = n.FindFirstChildOfClass(n, "Humanoid");
            
            if e then
                J = e.Health > 0;
            end;
            
            if e then
                J = false;
                
                if v then
                    
                    R = r39.IsHider(U);
                end;
                
                if v then
                    J = true;
                else
                    if B then
                        
                        R = r39.IsSeeker(U);
                    end;
                    
                    n = false;
                    
                    if B then
                        J = true;
                    else
                        P = not v;
                        m = r;
                        
                        if P then
                            r = not B;
                        end;
                        
                        n = m;
                        
                        if P then
                            J = true;
                        end;
                        
                        if n then
                            m = U.Character;
                            
                            P = m.FindFirstChild(m, "HumanoidRootPart");
                            
                            if P then
                                m = (P.Position - j.Position).Magnitude;
                                D = m < math.huge;
                                
                                if D then
                                    D = (P.Position - j[r15[r16(s, n8)]])[i];
                                    N = m;
                                    u = U;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end; 
    end;
    
    return nil; 
end;
r39.lastSquare = nil;
r39.attachToPlayer = function(arg1_150, ...)
    d = arg1_150;
    
    if not d or not d.Character then
        return false;
    end;
    
    if r39.attachedTarget == d then
        return true;
    end;
    
    if r39.attachedTarget then
        r39.detach();
    end;
    
    v = r34.Character;
    
    if not v then
        return false;
    end;
    
    G = v.FindFirstChildOfClass(v, "Humanoid");
    
    if not v.FindFirstChild(v, "HumanoidRootPart") or not G then
        return false;
    end;
    
    r39.destroySquares();
    r39.BehindSquare = r39.createSquare("BehindSquare", r39.AttachConfig.BehindDistance);
    r39.FrontSquare = r39.createSquare("FrontSquare", r39.AttachConfig.FrontDistance);
    r39.attachedTarget = d;
    r39.lastSquare = nil;
    G.WalkSpeed = r39.AttachConfig.MaxSpeed;
    G.AutoRotate = true;
    G.PlatformStand = false;
    
    if not r39.FaceTargetModule.Enabled then
        r39.ToggleFaceTarget(true);
        
        n = r35.FaceTarget;
        
        if n then
            n = r35.FaceTarget;
            
            n.SetValue(n, true);
        end;
    end;
    
    n = r39.attachConnection;
    
    if n then
        n = r39.attachConnection;
        
        n.Disconnect(n);
    end;
    
    j = r29.Heartbeat;
    
    r39.attachConnection = j.Connect(j, function(...)
        
        N = r16("5\xfc\x83\xa4n\xe6qs\x85 \xd04\x1a=\xcbN\xfa\x0e\xab", 21831072704437);
        
        if not r39[r15[N]] or not r39.attachedTarget then
            r39.detach();
            
            return;
        end;
        
        if not r39.attachedTarget or not r39.attachedTarget.Character then
            r39.detach();
            
            return;
        end;
        
        d = r39.attachedTarget.Character;
        G = not d.FindFirstChild(d, "HumanoidRootPart");
        k = G;
        
        B = d.FindFirstChildOfClass(d, "Humanoid");
        
        if G then
            if G then
                
                G = r39.FindBestTarget();
                
                if G then
                    k = G ~= r39.attachedTarget;
                end;
                
                if G then
                    r39.attachToPlayer(G);
                else
                    r39.detach();
                    r39.Notify("KillAura", "No new target's found :c", 2);
                    
                    n = r35.PlayerAttach;
                    
                    if n then
                        n = r35.PlayerAttach;
                        
                        n.SetValue(n, false);
                    end;
                    
                    return;
                end;
            end;
            
            r39.updateSquares(v);
            G = r39.getTargetSquare(v);
            
            if G then
                u = G.Position;
                
                r39.applySmoothMovement(Vector3.new(u.X, u.Y + 2.5, u.Z), r39.lastSquare ~= nil and r39.lastSquare ~= G);
                
                r39.lastSquare = G;
            end;
            
            return;
        else
            d.FindFirstChildOfClass(d, r15[j]);
            
            k = not B or B.Health <= 0;
        end; 
    end);
    
    return true; 
end;
r39.detach = function(...)
    if r39.attachConnection then
        n = r39.attachConnection;
        
        n.Disconnect(n);
        
        r39.attachConnection = nil;
    end;
    
    if r39.CurrentBodyVelocity then
        n = r39.CurrentBodyVelocity;
        
        n.Destroy(n);
        
        r39.CurrentBodyVelocity = nil;
    end;
    
    r39.destroySquares();
    
    d = r34.Character;
    
    if d then
        
        v = d.FindFirstChildOfClass(d, "Humanoid");
        
        if v then
            v.PlatformStand = false;
            v.AutoRotate = true;
            v.WalkSpeed = 16;
        end;
        
        B = d.FindFirstChild(d, "HumanoidRootPart");
        
        if B then
            
            B.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        end;
    end;
    
    if r39.FaceTargetModule.Enabled then
        r39.ToggleFaceTarget(false);
        
        n = r35.FaceTarget;
        
        if n then
            n = r35.FaceTarget;
            
            n.SetValue(n, false);
        end;
    end;
    
    r39.attachedTarget = nil;
    r39.CurrentSquare = nil;
    r39.lastSquare = nil;
    
    return; 
end;
r39.startAutoSearch = function(...)
    n = r39.autoSearchConnection;
    
    if n then
        n = r39.autoSearchConnection;
        
        n.Disconnect(n);
    end;
    
    d = r29.Heartbeat;
    
    r39.autoSearchConnection = d.Connect(d, function(...)
        B = r15;
        
        if not r39.PlayerAttachEnabled then
            return;
        end;
        
        if r39.attachedTarget then
            return;
        end;
        
        if tick() % 1 < .05 then
            
            d = r39.FindBestTarget();
            
            if d then
                r39.attachToPlayer(d);
                r39.Notify("KillAura", "Attached to: " .. d.Name, 2);
                r39.PlayBell();
            end;
        end;
        
        return; 
    end);
    
    return; 
end;
r39.TogglePlayerAttach = function(arg1_151, ...)
    d = arg1_151;
    v = d;
    
    r39.PlayerAttachEnabled = v;
    
    if d then
        
        v = r39.FindBestTarget();
        
        if v then
            r39.attachToPlayer(v);
            r39.Notify("KillAura", "Attached to: " .. v.Name, 2);
            r39.PlayBell();
            r39.startAutoSearch();
        else
            r39.Notify("Killaura", "No player's found :c", 2);
            r39.PlayBell();
            
            r39.PlayerAttachEnabled = false;
            
            n = r35.PlayerAttach;
            
            if n then
                n = r35.PlayerAttach;
                
                n.SetValue(n, false);
            end;
        end;
    else
        if r39.autoSearchConnection then
            n = r39.autoSearchConnection;
            
            n.Disconnect(n);
            
            r39.autoSearchConnection = nil;
        end;
        
        r39.detach();
        r39.PlayBell();
        
        return;
    end; 
end;
r39.SpectatePlayer = function(arg1_152, ...)
    d = arg1_152;
    
    if not d then
        return;
    end;
    
    if not d.Character then
        r39.Notify("Spectate", "Player has no character", 2);
        
        return;
    end;
    
    n = d.Character;
    
    v = n.FindFirstChildOfClass(n, "Humanoid");
    
    if not v or v.Health <= 0 then
        r39.Notify("Spectate", "Player is dead", 2);
        
        return;
    end;
    
    workspace.CurrentCamera.CameraSubject = v;
    
    r39.Notify("Spectate", "Spectating: " .. d.Name, 2);
    r39.PlayBell();
    
    return; 
end;
r39.StopSpectate = function(...)
    d = r34.Character;
    
    if d then
        
        v = d.FindFirstChildOfClass(d, "Humanoid");
        
        if v then
            B = n;
            
            workspace.CurrentCamera.CameraSubject = B;
            
            r39.Notify("Spectate", "Stopped", 2);
            r39.PlayBell();
        end;
    end;
    
    return; 
end;
r39.TeleportToPlayer = function(arg1_153, ...)
    d = arg1_153;
    
    if not d then
        return;
    end;
    
    if not d.Character then
        r39.Notify("Teleport", "Player has no character", 2);
        
        return;
    end;
    
    n = d.Character;
    
    v = n.FindFirstChild(n, "HumanoidRootPart");
    
    if not v then
        r39.Notify("Teleport", "Player has no root part", 2);
        
        return;
    end;
    
    B = r34.Character;
    
    if not B then
        return;
    end;
    
    G = B.FindFirstChild(B, "HumanoidRootPart");
    
    if not G then
        return;
    end;
    
    G.CFrame = CFrame.new(v.Position + Vector3.new(0, 3, 0));
    
    r39.Notify("Teleport", "Teleported to: " .. d.Name, 2);
    r39.PlayBell();
    
    return; 
end;
r39.getNearestPlayerAnywhere = function(...)
    
    B = r39.GetCharacter();
    
    if not B then
        return nil;
    end;
    
    G = B.FindFirstChild(B, "HumanoidRootPart") and B.HumanoidRootPart.Position;
    
    if not G then
        return nil;
    end;
    
    N = r26;
    u = N[3];
    N = N[1];
    
    for u, C in N, pairs(N.GetPlayers(N)) do
        c = u;
        
        if C ~= r34 and C.Character then
            n = C.Character;
            
            y = n.FindFirstChild(n, "HumanoidRootPart");
            
            if y then
                x = y.Position - G;
                n = (x.Magnitude and x) < math.huge;
            end;
        end; 
    end;
    
    return nil; 
end;
r39.teleportToNearest = function(...)
    n = r39.getNearestPlayerAnywhere;
    
    d = n();
    
    if d then
        k = d.Character;
    end;
    
    if d then
        n = d.Character;
        
        v = n.FindFirstChild(n, "HumanoidRootPart");
        
        if v then
            B = r34.Character;
            
            if B then
                
                G = B.FindFirstChild(B, "HumanoidRootPart");
                
                if G then
                    
                    G.CFrame = CFrame.new(v.Position + Vector3.new(0, 3, 0));
                    
                    r39.Notify("Teleport", "Teleported to: " .. d.Name, 2);
                    r39.PlayBell();
                end;
            end;
        end;
    else
        r39.Notify("Teleport", "No players near", 2);
        r39.PlayBell();
    end;
    
    return; 
end;
r39.UpdateAllTogglesByGame = function(...)
    n = r28;
    
    d = n.FindFirstChild(n, "Values");
    
    if not d then
        return;
    end;
    
    v = d.FindFirstChild(d, "CurrentGame");
    B = v and v.Value;
    n = r39.UpdateToggleAvailability;
    u = n;
    
    n("AutoDodge", B == "HideAndSeek" and "HideAndSeek" or nil, r35.AutoDodge);
    
    N = n;
    
    r39.UpdateToggleAvailability("InfiniteStamina", B == "HideAndSeek" and "HideAndSeek" or nil, r35.InfiniteStamina);
    
    N = n;
    
    r39.UpdateToggleAvailability("SpikesKill", B == "HideAndSeek" and "HideAndSeek" or nil, r35.SpikesKill);
    
    N = n;
    
    r39.UpdateToggleAvailability("AutoEscape", B == "HideAndSeek" and "HideAndSeek" or nil, r35.AutoEscape);
    
    N = n;
    
    r39.UpdateToggleAvailability("KeyESP", B == "HideAndSeek" and "HideAndSeek" or nil, r35.KeyESP);
    
    N = n;
    
    r39.UpdateToggleAvailability("JumpRopeAntiFall", B == "JumpRope" and "JumpRope" or nil, r35.JumpRopeAntiFall);
    
    N = n;
    
    r39.UpdateToggleAvailability("GlassESP", B == "GlassBridge" and "GlassBridge" or nil, r35.GlassESP);
    
    N = n;
    
    r39.UpdateToggleAvailability("AntiBreak", B == "GlassBridge" and "GlassBridge" or nil, r35.AntiBreak);
    
    N = n;
    
    r39.UpdateToggleAvailability("ZoneKill", B == "LastDinner" and "LastDinner" or nil, r35.ZoneKill);
    
    N = n;
    
    r39.UpdateToggleAvailability("VoidKill", B == "SkySquidGame" and "SkySquidGame" or nil, r35.VoidKill);
    
    N = n;
    
    r39.UpdateToggleAvailability("SkySquidAntiFall", B == "SkySquidGame" and "SkySquidGame" or nil, r35.SkySquidAntiFall);
    
    N = n;
    
    r39.UpdateToggleAvailability("MingleVoidKill", B == "Mingle" and "Mingle" or nil, r35.MingleVoidKill);
    
    N = n;
    
    r39.UpdateToggleAvailability("GodMode", B == "RedLightGreenLight" and "RedLightGreenLight" or nil, r35.GodMode);
    
    N = n;
    
    r39.UpdateToggleAvailability("RemoveInjury", B == "RedLightGreenLight" and "RedLightGreenLight" or nil, r35.RemoveInjury);
    
    N = n;
    
    r39.UpdateToggleAvailability("AutoChoke", B == "Mingle" and "Mingle" or nil, r35.AutoChoke);
    
    N = n;
    n = n;
    
    r39.UpdateToggleAvailability("AutoPickupKeys", B == "HideAndSeek" and "HideAndSeek" or nil, r35.AutoPickup);
    
    return; 
end;
r39.GameStateMonitor = {
    ["Connection"] = nil,
    ["LastGame"] = nil
};
r39.GameStateMonitor.Start = function(...)
    n = r39.GameStateMonitor.Connection;
    
    if n then
        n = r39.GameStateMonitor.Connection;
        
        n.Disconnect(n);
    end;
    
    d = r29.Heartbeat;
    
    r39.GameStateMonitor.Connection = d.Connect(d, function(...)
        n = r28;
        B = r16;
        
        d = n.FindFirstChild(n, "Values");
        
        if not d then
            return;
        end;
        
        v = d.FindFirstChild(d, "CurrentGame");
        B = v and v.Value;
        
        if B ~= r39.GameStateMonitor.LastGame then
            if r39.GameStateMonitor.LastGame then
                r39.GameStateMonitor.DisableGameToggles(r39.GameStateMonitor.LastGame);
            end;
            
            G = v and v.Value;
            
            r39.GameStateMonitor.LastGame = G;
            
            r39.UpdateAllTogglesByGame();
        end;
        
        return; 
    end);
    
    return; 
end;
r39.GameStateMonitor.DisableGameToggles = function(arg1_154, ...)
    c = {
        "ZoneKill"
    };
    B = ({
        ["HideAndSeek"] = {
            "AutoDodge",
            "InfiniteStamina",
            "SpikesKill",
            "AutoEscape",
            "KeyESP",
            "AutoPickupKeys"
        },
        ["JumpRope"] = {
            "JumpRopeAntiFall"
        },
        ["GlassBridge"] = {
            "GlassESP",
            "AntiBreak"
        },
        ["LastDinner"] = c,
        ["SkySquidGame"] = {
            "VoidKill",
            "SkySquidAntiFall"
        },
        ["Mingle"] = {
            "MingleVoidKill",
            "AutoChoke"
        },
        ["RedLightGreenLight"] = {
            "GodMode",
            "RemoveInjury"
        }
    })[arg1_154];
    
    if B then
        u = "ipairs";
        
        for j, c in ipairs(B) do
            N = j;
            
            r39.DisableToggle(c); 
        end;
    end;
    
    return; 
end;

r39.GameStateMonitor.Start();

local v21 = r24;
local v22 = "Footer";
local v23 = v21.CreateWindow(v21, {
    ["Title"] = "HollyScriptX",
    ["Icon"] = "diamond-percent",
    [v22] = "Ink Game | Updated",
    ["Center"] = true,
    ["Resizable"] = true,
    ["AutoShow"] = true,
    ["ShowCustomCursor"] = false,
    ["ToggleKeybind"] = Enum.KeyCode.Z,
    ["CornerRadius"] = 999999
});
local v24 = r24;

v24.SetDPIScale(v24, 100);

r36 = true;

local v25 = r37;
local v26 = v22[1];
local v27 = v22[2];

for v20, v25 in ipairs(v25) do
    v22 = r24;
    v17 = v20;
    
    v22.Notify(v22, {
        ["Title"] = v25.title,
        ["Description"] = v25.text,
        ["Duration"] = v25.duration
    }); 
end;

r37 = {};

local v28 = r25;

if v28 then
    v28 = r25;
    
    v28.SetLibrary(v28, r24);
    
    v28 = r25;
    
    v28.SetFolder(v28, "HollyScriptX");
end;

local v29 = r39.IsMobile;

if v29() then
    v29 = r24;
    
    v29.SetDPIScale(v29, 80);
end;

if v4 then
    v4.SetLibrary(v4, r24);
    v4.SetFolder(v4, "HollyScriptX");
    v4.IgnoreThemeSettings(v4);
    v4.LoadAutoloadConfig(v4);
end;

local v30 = v23.AddTab(v23, "Games", "gamepad");
local v31 = v23.AddTab(v23, "Players", "users");
local v32 = v23.AddTab(v23, "Guards", "shield");
local v33 = v23.AddTab(v23, "Main", "warehouse");
local v34 = v30.AddLeftGroupbox(v30, "Red Light Green Light", "lightbulb");
local v35 = v30.AddRightGroupbox(v30, "Dalgona", "cookie");
local v8 = v30.AddLeftGroupbox(v30, "Hide And Seek", "eye");
local v36 = v30.AddLeftGroupbox(v30, "Jump Rope", "arrow-up");
local v37 = v30.AddLeftGroupbox(v30, "Glass Bridge", "circuit-board");
local v38 = v30.AddLeftGroupbox(v30, "Mingle", "users");
local v39 = v30.AddRightGroupbox(v30, "Last Dinner", "utensils");
local v40 = v30.AddLeftGroupbox(v30, "Sky Squid", "cloud");
local v41 = v30.AddRightGroupbox(v30, "Rebel", "flag");
r35.RemoveInjury = v34.AddToggle(v34, "RemoveInjury", {
    ["Text"] = "Remove Injury",
    ["Default"] = false,
    ["Callback"] = r39.ToggleRemoveInjury
});

v34.AddButton(v34, "Teleport to End", r39.RLGL_TP_End);
r35.GodMode = v34.AddToggle(v34, "GodMode", {
    ["Text"] = "God Mode",
    ["Default"] = false,
    ["Callback"] = r39.ToggleGodMode
});

v35.AddButton(v35, "Get Lighter", r39.Dalgona_Lighter);
v35.AddButton(v35, "Complete Shape", function(...)
    r39.DalgonaCompleteShape();
    
    print("Failed!");
    
    return; 
end);

local r197 = "Remote";

v35.AddDropdown(v35, "DalgonaMethod", {
    ["Text"] = "Method",
    ["Default"] = "Remote",
    ["Values"] = {
        "Remote",
        "HookFunction"
    },
    ["Callback"] = function(arg1_155, ...)
        d = arg1_155;
        r197 = d;
        
        r39.Notify("Dalgona", "changed to: " .. d, 2);
        
        return; 
    end
});
r35.InfiniteStamina = v8.AddToggle(v8, "InfiniteStamina", {
    ["Text"] = "Infinite Stamina",
    ["Default"] = false,
    ["Callback"] = r39.ToggleInfiniteStamina
});
r35.AutoEscape = v8.AddToggle(v8, "AutoEscape", {
    ["Text"] = "Auto Escape",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAutoEscape
});
r35.AutoPickup = v8.AddToggle(v8, "AutoPickupKeys", {
    ["Text"] = "Auto Pickup Keys",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAutoPickup
});
r35.SpikesKill = v8.AddToggle(v8, "SpikesKill", {
    ["Text"] = "Spikes Kill",
    ["Default"] = false,
    ["Callback"] = r39.ToggleSpikesKill
});
r35.KeyESP = v8.AddToggle(v8, "KeyESP", {
    ["Text"] = "Show Keys (purple)",
    ["Default"] = false,
    ["Callback"] = r39.ToggleKeyESP
});

v8.AddToggle(v8, "ExitDoorESP", {
    ["Text"] = "Show Exit Doors (yellow)",
    ["Default"] = false,
    ["Callback"] = r39.ToggleExitDoorESP
});
v8.AddButton(v8, "Delete Spikes", r39.DeleteSpikes);
v8.AddButton(v8, "Teleport to Hider", r39.TeleportToHider);
local v42 = v8.AddLabel(v8, "Keybind:");

v42.AddKeyPicker(v42, "Teleport To Hider", {
    ["Default"] = nil,
    ["Mode"] = "Toggle",
    ["Text"] = "Teleport to Hider",
    ["Callback"] = function(...)
        r39.TeleportToHider();
        
        return; 
    end
});
v8.AddButton(v8, "Teleport to Seeker", r39.TeleportToSeeker);
local v43 = v8.AddLabel(v8, "Keybind:");

v43.AddKeyPicker(v43, "Teleport To Seeker", {
    ["Default"] = nil,
    ["Mode"] = "Press",
    ["Text"] = "Teleport To Seeker",
    ["Callback"] = function(...)
        r39.TeleportToSeeker();
        
        return; 
    end
});
r35.AutoDodge = v8.AddToggle(v8, "AutoDodge", {
    ["Text"] = "Auto Dodge",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAutoDodge
});

local v44 = r35.AutoDodge;

v44.AddKeyPicker(v44, "AutoDodge", {
    ["Default"] = nil,
    ["Mode"] = "Toggle",
    ["Text"] = "Auto Dodge",
    ["Callback"] = function(arg1_156, ...)
        d = arg1_156;
        
        r39.ToggleAutoDodge(d);
        
        n = r35.AutoDodge;
        
        if n then
            n = r35.AutoDodge;
            
            n.SetValue(n, d);
        end;
        
        return; 
    end
});
r35.SpikesPlatformTeleport = v8.AddToggle(v8, "SpikesPlatformTeleport", {
    ["Text"] = "TP To Spikes",
    ["Default"] = false,
    ["Callback"] = r39.ToggleSpikesPlatformTeleport
});

local v45 = r35.SpikesPlatformTeleport;

v45.AddKeyPicker(v45, "Teleport To Spikes", {
    ["Default"] = nil,
    ["Mode"] = "Toggle",
    ["Text"] = "TP To Spikes",
    ["Callback"] = function(arg1_157, ...)
        d = arg1_157;
        
        r39.ToggleSpikesPlatformTeleport(d);
        
        n = r35.SpikesPlatformTeleport;
        
        if n then
            n = r35.SpikesPlatformTeleport;
            
            n.SetValue(n, d);
        end;
        
        return; 
    end
});
v8.AddToggle(v8, "ShowSpikes", {
    ["Text"] = "Show Spikes (red)",
    ["Default"] = false,
    ["Callback"] = r39.ToggleShowSpikes
});
r35.JumpRopeAntiFall = v36.AddToggle(v36, "AntiFall", {
    ["Text"] = "Anti Fall",
    ["Default"] = false,
    ["Callback"] = r39.ToggleJumpRopeAntiFall
});

v36.AddButton(v36, "Remove Rope", r39.JR_DeleteRope);
v36.AddButton(v36, "Teleport to Start", r39.JR_TP_Start);
v36.AddButton(v36, "Teleport to End", r39.JR_TP_End);
r35.GlassESP = v37.AddToggle(v37, "GlassESP", {
    ["Text"] = "Glass ESP",
    ["Default"] = false,
    ["Callback"] = r39.ToggleGlassESP
});

v37.AddSlider(v37, "GlassESPTransparency", {
    ["Text"] = "Glass ESP Transparency",
    ["Default"] = 40,
    ["Min"] = 0,
    ["Max"] = 100,
    ["Callback"] = r39.SetGlassESPTransparency
});
v37.AddDivider(v37);
r35.AntiBreak = v37.AddToggle(v37, "AntiBreak", {
    ["Text"] = "Anti-Break",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAntiBreak
});

v37.AddButton(v37, "Teleport to End", r39.GB_TP_End);
r35.MingleVoidKill = v38.AddToggle(v38, "VoidKill", {
    ["Text"] = "Void Kill",
    ["Default"] = false,
    ["Callback"] = r39.ToggleMingleVoidKill
});
r35.AutoChoke = v38.AddToggle(v38, "AutoChoke", {
    ["Text"] = "Auto Choke",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAutoChoke
});
r39.TeleportToSafeSpot = function(...)
    if r39.IsGameActive("LastDinner") then
        r39.SafeTeleport(Vector3.new(0, 100, 0));
        r39.Notify("Last Dinner", "Teleported to Safe Spot", 2);
    else
        r39.Notify("Last Dinner", "Wait for LastDinner!", 2);
    end;
    
    r39.PlayBell();
    
    return; 
end;
r35.ZoneKill = v39.AddToggle(v39, "ZoneKill", {
    ["Text"] = "Zone Kill",
    ["Default"] = false,
    ["Callback"] = r39.ToggleZoneKill
});

v39.AddButton(v39, "Teleport To Safe Spot", r39.TeleportToSafeSpot);
r35.AutoKillGuards = v41.AddToggle(v41, "AutoKillGuards", {
    ["Text"] = "Auto Kill Guards",
    ["Default"] = false,
    ["Callback"] = r39.ToggleRebel
});
r39.GuardHitboxEnabled = false;
r39.GuardHitboxConnection = nil;
r39.GuardHitboxSize = 4.5;
r39.GuardOriginalSizes = {};
r39.GuardESPObjects = {};
r39.ToggleGuardHitbox = function(arg1_158, ...)
    d = arg1_158;
    v = arg1_158;
    
    r39.GuardHitboxEnabled = v;
    
    local function v(...)
        n = pairs;
        G = r39;
        B = G.GuardOriginalSizes;
        v = G[3];
        B = G[1];
        
        for v, j in B, n(B) do
            r198 = v;
            r199 = j;
            j = 160;
            
            if r198 and r198.Parent then
                pcall(function(...)
                    r198.Size = X[n];
                    
                    return; 
                end);
            end; 
        end;
        
        r39.GuardOriginalSizes = {};
        
        j = r39;
        v = j[2];
        
        for B, j in pairs(j.GuardESPObjects) do
            r200 = j;
            j = 24;
            G = B;
            
            pcall(function(...)
                n = X[n].Highlight;
                
                n.Destroy(n);
                
                return; 
            end);
            pcall(function(...)
                n = r200.Billboard;
                
                n.Destroy(n);
                
                return; 
            end); 
        end;
        
        r39.GuardESPObjects = {};
        
        return; 
    end;
    
    if d then
        n = r39.GuardHitboxConnection;
        
        if n then
            n = r39.GuardHitboxConnection;
            
            n.Disconnect(n);
        end;
        
        B = r29.RenderStepped;
        
        r39.GuardHitboxConnection = B.Connect(B, function(...)
            
            j = r16("\x8a\xc7rOH\x9e\xae\xb2\x123\x96\xa3c\xaa\nXz\xe9", 27483698672126);
            
            if not r39[r15[j]] then
                return;
            end;
            
            n = workspace;
            N = 23249142622794;
            
            d = n.FindFirstChild(n, "Live");
            B = {};
            
            if d then
                N = d.GetChildren;
                u = {
                    N(d)
                };
                G = N[2];
                j = N[3];
                
                for j, c in ipairs(w("ipairs")) do
                    N = j;
                    
                    if c.IsA(c, "Model") and c.FindFirstChild(c, "Humanoid") then
                        if c == r34[r15[r16("\x05\xd0\x8d<]\xaf\x91YB", N)]] then
                            
                        else
                            R = r26;
                            r = {
                                R.GetPlayers(R)
                            };
                            U = R[1];
                            e = R[2];
                            
                            for J, r in pairs(w(r)) do
                                R = J;
                                
                                if r.Name == c.Name then
                                    C = true;
                                else
                                    
                                end; 
                            end;
                            
                            if false then
                                
                            else
                                
                                y = c.FindFirstChildOfClass(c, "Humanoid");
                                
                                if y then
                                    n = pairs;
                                    U = y.Health > 0 and not c.GetAttribute(c, "BodyDespawntime");
                                end;
                                
                                n = pairs;
                                
                                if y then
                                    B[c] = true;
                                    
                                    R = r16;
                                    
                                    U = c.FindFirstChild(c, "HumanoidRootPart");
                                    J = e;
                                    e = U;
                                    
                                    if U then
                                        
                                        e = U.IsA(U, "BasePart");
                                    end;
                                    
                                    n = J;
                                    
                                    if e then
                                        if not r39.GuardOriginalSizes[U] then
                                            r39.GuardOriginalSizes[U] = U.Size;
                                        end;
                                        
                                        U.Size = Vector3.new(r39.GuardHitboxSize, r39.GuardHitboxSize, r39.GuardHitboxSize);
                                        
                                        if not r39.GuardESPObjects[c] then
                                            
                                            J = Instance.new("Highlight");
                                            
                                            J.FillTransparency = .85;
                                            J.OutlineTransparency = .2;
                                            J.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                                            J.Parent = r31;
                                            R = Instance.new("BillboardGui");
                                            R.Size = UDim2.new(0, 140, 0, 45);
                                            R.StudsOffset = Vector3.new(0, 2.5, 0);
                                            R.AlwaysOnTop = true;
                                            R.Parent = r31;
                                            r = Instance.new("TextLabel");
                                            r.Size = UDim2.new(1, 0, .45, 0);
                                            r.BackgroundTransparency = 1;
                                            r.TextSize = 11;
                                            r.Font = Enum.Font.GothamBold;
                                            r.TextStrokeTransparency = .2;
                                            r.TextXAlignment = Enum.TextXAlignment.Left;
                                            r.Text = "GUARD";
                                            r.Parent = R;
                                            m = Instance.new("Frame");
                                            m.Size = UDim2.new(.45, 0, .07, 0);
                                            m.Position = UDim2.new(0, 0, .48, 0);
                                            m.BackgroundColor3 = Color3.fromRGB(35, 35, 40);
                                            m.BorderSizePixel = 0;
                                            m.Parent = R;
                                            P = Instance.new("UICorner");
                                            P.CornerRadius = UDim.new(0, 3);
                                            P.Parent = m;
                                            D = Instance.new("Frame");
                                            D.Size = UDim2.new(1, 0, 1, 0);
                                            D.BackgroundColor3 = Color3.fromRGB(130, 230, 160);
                                            D.BorderSizePixel = 0;
                                            D.Parent = m;
                                            i = Instance.new("UICorner");
                                            i.CornerRadius = UDim.new(0, 3);
                                            i.Parent = D;
                                            
                                            r39.GuardESPObjects[c] = {
                                                ["Highlight"] = J,
                                                ["Billboard"] = R,
                                                ["Name"] = r,
                                                ["HpFill"] = D
                                            };
                                        end;
                                        
                                        e = r39.GuardESPObjects[c];
                                        
                                        R = Color3.fromRGB(255, 80, 100);
                                        
                                        e.Highlight.Adornee = c;
                                        m = Color3.fromRGB(255, 80, 100);
                                        
                                        e.Highlight.FillColor = m;
                                        e.Highlight.OutlineColor = R;
                                        e.Highlight.Enabled = true;
                                        e.Billboard.Adornee = U;
                                        e.Billboard.Enabled = true;
                                        e.Name.TextColor3 = R;
                                        
                                        J = y.Health / y.MaxHealth;
                                        e.HpFill.Size = UDim2.new(J, 0, 1, 0);
                                        
                                        if J > .6 then
                                            
                                            e.HpFill.BackgroundColor3 = Color3.fromRGB(130, 230, 160);
                                        else
                                            if y.Health / y.MaxHealth > .3 then
                                                
                                                e.HpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100);
                                            else
                                                
                                                e.HpFill.BackgroundColor3 = Color3.fromRGB(245, 130, 130);
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    else
                        
                    end; 
                end;
            end;
            
            C = r39;
            c = C.GuardESPObjects;
            u = C[2];
            N = C[3];
            
            for N, c in pairs(c) do
                r201 = c;
                
                if not B[N] then
                    pcall(function(...)
                        r201.Highlight.Enabled = false;
                        r201.Billboard.Enabled = false;
                        
                        return; 
                    end);
                end; 
            end;
            
            return; 
        end);
        
        r39.Notify("Guard ESP", "Enabled", 3);
    else
        if r39.GuardHitboxConnection then
            n = r39.GuardHitboxConnection;
            
            n.Disconnect(n);
            
            r39.GuardHitboxConnection = nil;
        end;
        
        v();
        
        r39.Notify("Guard ESP", "Disabled", 2);
        r39.PlayBell();
        
        return true;
    end; 
end;
r39.SetGuardHitboxSize = function(arg1_159, ...)
    r39.GuardHitboxSize = arg1_159;
    
    return; 
end;
r35.InfiniteAmmoRebel = v41.AddToggle(v41, "InfiniteAmmoRebel", {
    ["Text"] = "Infinite Ammo",
    ["Default"] = false,
    ["Callback"] = r39.ToggleInfiniteAmmo
});
r35.RapidFireRebel = v41.AddToggle(v41, "RapidFireRebel", {
    ["Text"] = "Rapid Fire",
    ["Default"] = false,
    ["Callback"] = r39.ToggleRapidFire
});
r39.GuardHitboxEnabled = false;
r39.GuardHitboxConnection = nil;
r39.GuardHitboxSize = 4.5;
r39.GuardOriginalSizes = {};
r39.GuardESPObjects = {};
r39.ToggleGuardHitbox = function(arg1_160, ...)
    d = arg1_160;
    B = r16;
    v = arg1_160;
    
    r39.GuardHitboxEnabled = v;
    
    local function v(...)
        n = pairs;
        G = r39;
        B = G.GuardOriginalSizes;
        v = G[3];
        B = G[1];
        
        for v, j in B, n(B) do
            r202 = v;
            r203 = j;
            j = 119;
            
            if r202 and r202.Parent then
                pcall(function(...)
                    N = "b\x05\x10b\xf9^'";
                    
                    r202.Size = X[n];
                    r202.Transparency = 1;
                    r202.CanCollide = true;
                    
                    r202.Color = Color3[r15[r16(N, 11759560463715)]](255, 255, 255);
                    r202.Material = Enum.Material.Plastic;
                    
                    return; 
                end);
            end; 
        end;
        
        r39.GuardOriginalSizes = {};
        
        j = r39;
        B = j[3];
        
        for B, j in j[1], pairs(j.GuardESPObjects) do
            G = B;
            r204 = j;
            j = 248;
            
            pcall(function(...)
                n = r204.Highlight;
                
                if n then
                    n = r204.Highlight;
                    
                    n.Destroy(n);
                end;
                
                n = r204.Billboard;
                
                if n then
                    n = r204.Billboard;
                    
                    n.Destroy(n);
                end;
                
                return; 
            end); 
        end;
        
        r39.GuardESPObjects = {};
        
        return; 
    end;
    
    if d then
        n = r39.GuardHitboxConnection;
        
        if n then
            n = r39.GuardHitboxConnection;
            
            n.Disconnect(n);
        end;
        
        B = r29.RenderStepped;
        
        r39.GuardHitboxConnection = B.Connect(B, function(...)
            
            j = r16("\xc3\x0e\x02-T\xebe\"\x96\xab>[V$\xcf\xe3\xea7", 23314788166248);
            
            if not r39[r15[j]] then
                return;
            end;
            
            n = workspace;
            
            d = n.FindFirstChild(n, "Live");
            
            if not d then
                return;
            end;
            
            u = {
                ipairs(d.GetChildren(d))
            };
            B = u[2];
            G = u[3];
            
            j = ipairs(d.GetChildren(d)); 
        end);
    else
        if r39.GuardHitboxConnection then
            n = r39.GuardHitboxConnection;
            
            n.Disconnect(n);
            
            r39.GuardHitboxConnection = nil;
        end;
        
        v();
        
        r39.PlayBell();
        
        return true;
    end; 
end;
r39.SetGuardHitboxSize = function(arg1_161, ...)
    d = arg1_161;
    v = arg1_161;
    
    r39.GuardHitboxSize = v;
    
    j = r16("S3?\x15;\x8d-\x00N\x17\xe1o\xe2q:\xf3\x08\xfa", 16373554634184);
    
    if r39[r15[j]] then
        j = r39;
        G = j.GuardESPObjects;
        B = j[3];
        v = j[2];
        
        for B, u in pairs("pairs") do
            if B then
                
                N = B.FindFirstChild(B, "HumanoidRootPart");
            end;
            
            if B then
                
                B.Size = Vector3.new(d, d, d);
            end; 
        end;
    end;
    
    return; 
end;
r35.GuardHitbox = v41.AddToggle(v41, "GuardHitbox", {
    ["Text"] = "Hitbox + ESP Guards",
    ["Default"] = false,
    ["Callback"] = r39.ToggleGuardHitbox
});

v41.AddSlider(v41, "GuardHitboxSize", {
    ["Text"] = "Guard Hitbox Size",
    ["Default"] = 30,
    ["Min"] = 10,
    ["Max"] = 100,
    ["Callback"] = r39.SetGuardHitboxSize
});
r35.SkySquidAntiFall = v40.AddToggle(v40, "AntiFall", {
    ["Text"] = "Anti Fall",
    ["Default"] = false,
    ["Callback"] = r39.ToggleSkySquidAntiFall
});
local v46 = v31.AddLeftGroupbox(v31, "Players Stats", "chart-bar");
local r206 = v46.AddLabel(v46, "Wins: -");
local r207 = v46.AddLabel(v46, "Wons: -");
local r208 = v46.AddLabel(v46, "Power: -");
local r209 = v46.AddLabel(v46, "GuardPower: -");
local r210 = v46.AddLabel(v46, "Level: -");
local r211 = v46.AddLabel(v46, "Power Rolls: -");
local r212 = v46.AddLabel(v46, "Guard Power Rolls: -");
local r213 = v46.AddLabel(v46, "Robux Donated: -");

v46.AddDivider(v46);
local r214 = v46.AddLabel(v46, "VIP: -");
local r215 = v46.AddLabel(v46, "Glass Manufact Vision: -");
local r216 = v46.AddLabel(v46, "2X Vote: -");
local r217 = v46.AddLabel(v46, "Permanent Guard: -");
local r218 = v46.AddLabel(v46, "Lighter: -");

v46.AddDivider(v46);
local r219 = v46.AddLabel(v46, "Faster Sprint: -");
local r220 = v46.AddLabel(v46, "Strength Boost: -");
local r221 = v46.AddLabel(v46, "Won Boost: -");

v46.AddDivider(v46);
local r222 = v46.AddLabel(v46, "Unlocked Powers: -");

local function v47(arg1_162, ...)
    d = arg1_162;
    
    if d == "-" or d == nil then
        return "-";
    end;
    
    if type(d) ~= "number" then
        d = tonumber(arg1_162) or 0;
    end;
    
    return string.format("%d", d); 
end;

local function r223(arg1_163, arg2_163, ...)
    v4 = 0;
    d = arg1_163;
    r224 = arg2_163;
    
    local function G(arg1_164, ...)
        d = arg1_164;
        
        if d then
            n = pairs;
            j = d.GetChildren;
            G = {
                j(d)
            };
            v = j[2];
            v4 = j[3];
            
            for v4, v1 in n(w(k)) do
                j = v4;
                v7 = v1.Name;
                
                if v7 == r224 and v1.IsA(v1, "NumberValue") then
                    return v1.Value;
                else
                    
                    v7 = string.lower(v1.Name);
                    
                    if v7.find(v7, string.lower(r224)) and v1.IsA(v1, "NumberValue") then
                        return v1.Value;
                    else
                        
                    end;
                end; 
            end;
        end;
        
        return n; 
    end;
    
    j = d.FindFirstChild(d, "Boosts");
    
    if j then
        
        v1 = G(j);
        
        if v1 then
            return v1;
        end;
    end;
    
    v5 = r16;
    
    v1 = d.FindFirstChild(d, "_BoostData");
    
    if v1 then
        
        v5 = G(v1);
        
        if v5 then
            return v5;
        end;
        
        while not ("\x8b\x85\xa1\xf9\x99\xc0\xb3\xe4|\xc7")(172, "Key") do
            
            G, v5 = d.FindFirstChild(d, "Boosts")(0, function(arg1_165, ...)
                d = arg1_165;
                
                if d then
                    n = pairs;
                    j = d.GetChildren;
                    G = {
                        j(d)
                    };
                    v = j[2];
                    v4 = j[3];
                    
                    for v4, v1 in n(w(k)) do
                        j = v4;
                        v7 = v1.Name;
                        
                        if v7 == X[v] and v1.IsA(v1, "NumberValue") then
                            return v1.Value;
                        else
                            
                            v7 = string.lower(v1.Name);
                            
                            if v7.find(v7, string.lower(X[v])) and v1.IsA(v1, "NumberValue") then
                                return v1.Value;
                            else
                                
                            end;
                        end; 
                    end;
                end;
                
                return n; 
            end);
            
            if G then
                v1 = G;
                
                v7 = v5.IsA(v5, "Model");
                v6 = v7;
                
                if v7 then
                    v10 = 173;
                    v7 = string.find;
                    v9 = v5.Name or "";
                end;
            end;
            
            v4 = r15;
            
            G = v4.FindFirstChild(v4, "HideAndSeekMap");
            
            if G then
                local function r225(arg1_166, ...)
                    d = arg1_166;
                    j = "GetChildren";
                    j = d[j];
                    G = {
                        j(d)
                    };
                    v4 = j[3];
                    G = j[1];
                    
                    for v4, v1 in G, pairs(w(G)) do
                        j = v4;
                        
                        v8 = X[arg1_166]("\x07\xbb+\xbc\xff", 34150191627806);
                        
                        if v1.IsA(v1, r16[v8]) then
                            
                            v8 = string.find(v1.Name or "", "Circle");
                            v6 = v8;
                            
                            if v8 then
                                if v8 then
                                    if string.find(v5, "Circle") then
                                        v6 = "Circle";
                                    else
                                        if string.find(v5, "Triangle") then
                                            v6 = "Triangle";
                                        else
                                            if string.find(v5, "Square") then
                                                v6 = "Square";
                                            end;
                                            
                                            if nil then
                                                v9 = v1.PrimaryPart or v1.FindFirstChildWhichIsA(v1, "BasePart");
                                                n = string.find;
                                                
                                                if v9 then
                                                    table.insert(X[arg1_166], {
                                                        ["name"] = nil,
                                                        ["position"] = v9.Position,
                                                        ["model"] = v1
                                                    });
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                                
                                r225(v1);
                            end;
                        end; 
                    end;
                    
                    return; 
                end;
                
                r225(G);
                
                break;
            end;
            
            return X[d]; 
        end;
        
        if string.find(v5.Name, "Circle") then
            v6 = "Circle";
        else
            if string.find(v5.Name, "Triangle") then
                v6 = "Triangle";
            else
                if string.find(v5.Name, "Square") then
                    v6 = "Square";
                end;
                
                if nil then
                    v9 = v5.PrimaryPart or v5.FindFirstChildWhichIsA(v5, "BasePart");
                    n = string.find;
                    
                    if v9 then
                        table.insert(X[d], {
                            ["name"] = nil,
                            ["position"] = v9.Position,
                            ["model"] = v5
                        });
                    end;
                end;
            end;
        end;
    end;
    
    n = workspace;
    
    v5 = n.FindFirstChild(n, "Live");
    
    if v5 then
        
        v6 = v5.FindFirstChild(v5, d.Name);
        
        if v6 then
            
            v7 = v6.FindFirstChild(v6, "Boosts");
            
            if v7 then
                
                v8 = G(v7);
                
                if v8 then
                    return v8;
                end;
            end;
            
            v8 = v6.FindFirstChild(v6, "_BoostData");
            
            if v8 then
                
                v9 = G(v8);
                
                if v9 then
                    return v9;
                end;
            end;
        end;
    end;
    
    for v8, v13 in pairs(d.GetAttributes(d)) do
        
        r = string.lower(v8);
        
        if r.find(r, string.lower(r224)) and type(v13) == "number" then
            return v13;
        else
            
        end; 
    end;
    
    return 0; 
end;

local function r226(arg1_167, ...)
    d = arg1_167;
    
    if not d or not d.Parent then
        n = r206;
        
        n.SetText(n, "Wins: -");
        
        n = r207;
        
        n.SetText(n, "Wons: -");
        
        n = r208;
        
        n.SetText(n, "Power: -");
        
        n = r209;
        
        n.SetText(n, "GuardPower: -");
        
        n = r210;
        
        n.SetText(n, "Level: -");
        
        n = r211;
        
        n.SetText(n, "Power Rolls: -");
        
        n = r212;
        
        n.SetText(n, "Guard Power Rolls: -");
        
        n = r213;
        
        n.SetText(n, "Robux Donated: -");
        
        n = r214;
        
        n.SetText(n, "VIP: -");
        
        n = r215;
        
        n.SetText(n, "Glass Manufact Vision: -");
        
        n = r216;
        
        n.SetText(n, "2X Vote: -");
        
        n = r217;
        
        n.SetText(n, "Permanent Guard: -");
        
        n = r218;
        
        n.SetText(n, "Lighter: -");
        
        n = r219;
        
        n.SetText(n, "Faster Sprint: -");
        
        n = r220;
        
        n.SetText(n, "Strength Boost: -");
        
        n = r221;
        
        n.SetText(n, "Won Boost: -");
        
        n = r222;
        
        n.SetText(n, "Unlocked Powers: -");
        
        return;
    end;
    
    v = d.GetAttributes(d);
    n = r206;
    v6 = n;
    
    n.SetText(n, "Wins: " .. tostring(v._GameWins or 0));
    
    k = r207;
    v7 = n;
    
    k.SetText(k, "Wons: " .. tostring(v._Won or 0));
    
    k = r208;
    n = n;
    
    k.SetText(k, "Power: " .. tostring(v._EquippedPower or "-"));
    
    k = r209;
    
    k.SetText(k, "GuardPower: " .. tostring(v._EquippedGuardPower or "-"));
    
    k = r210;
    v7 = n;
    
    k.SetText(k, "Level: " .. tostring(v._CurrentLevel or 0));
    
    k = r211;
    v7 = n;
    
    k.SetText(k, "Power Rolls: " .. tostring(v._TotalPowerSpins or 0));
    
    k = r212;
    v7 = n;
    
    k.SetText(k, "Guard Power Rolls: " .. tostring(v._TotalGuardPowerSpins or 0));
    
    k = r213;
    v7 = n;
    
    k.SetText(k, "Robux Donated: " .. tostring(v._TotalRobuxDonated or 0));
    
    v4 = n;
    n = n;
    n = v4;
    n = v4;
    n = v4;
    v7 = v.__OwnsVIPGamepass == true and "Yes" or "No";
    n = v4;
    n = v.__OwnsVIPGamepass == true and "Yes" or "No";
    k = r214;
    
    k.SetText(k, "VIP: " .. (v.__OwnsVIPGamepass == true and "Yes" or "No"));
    
    k = r215;
    
    k.SetText(k, "Glass Manufact Vision: " .. (v.__OwnsGlassManufacturerVision == true and "Yes" or "No"));
    
    k = r216;
    
    k.SetText(k, "2X Vote: " .. (v.__Owns2xVote == true and "Yes" or "No"));
    
    k = r217;
    
    k.SetText(k, "Permanent Guard: " .. (v.__OwnsPermGuard == true and "Yes" or "No"));
    
    k = r218;
    
    k.SetText(k, "Lighter: " .. (v.HasLighter == true and "Yes" or "No"));
    
    k = r219;
    
    k.SetText(k, "Faster Sprint: " .. tostring(r223(d, "Faster Sprint")));
    
    k = r220;
    
    k.SetText(k, "Strength Boost: " .. tostring(r223(d, "Strength Boost")));
    
    k = r221;
    
    k.SetText(k, "Won Boost: " .. tostring(r223(d, "Won Boost")));
    
    n = n;
    v9 = v._UnlockedPowers or (v._PowersUnlocked or (v._HavePowers or ""));
    v10 = "";
    
    if v9 ~= v10 then
        if string.len(v9) > 50 then
            v9 = string.sub(v[r15[r16("(\x11\xf5npC\xeeA\r'\x180H\xc1\x9a", P)]] or (v._PowersUnlocked or (v._HavePowers or "")), 1, 47) .. "...";
        end;
        
        v10 = r222;
        
        v10.SetText(v10, "Unlocked Powers: " .. v9);
    else
        v10 = r222;
        
        v10.SetText(v10, "Unlocked Powers: None");
    end;
    
    return; 
end;

local function r227(...)
    d = {};
    G = r26;
    G = "pairs";
    
    for v4, v1 in pairs(G.GetPlayers(G)) do
        j = v4;
        
        if v1 ~= r34 then
            table.insert(d, v1.Name);
        end; 
    end;
    
    if #d == 0 then
        table.insert(d, "No players");
    end;
    
    return d; 
end;

v46.AddInput(v46, "PlayerSearch", {
    ["Text"] = "Search Player",
    ["Default"] = "",
    ["Placeholder"] = "Type nickname...",
    ["Callback"] = function(arg1_168, ...)
        d = arg1_168;
        
        if d then
            k = d ~= "";
        end;
        
        if d then
            G = r26;
            v = G[2];
            G = G[1];
            
            for v4, v1 in pairs(G.GetPlayers(G)) do
                j = v4;
                v7 = r34;
                v5 = v1 ~= v7 and v7.find(v7, string.lower(d));
                
                if v5 then
                    r205 = v1;
                    
                    r226(v1);
                    
                    v5 = playerDropdown;
                    
                    v5.SetValue(v5, v1.Name);
                else
                    
                end; 
            end;
        end;
        
        return; 
    end
});
local r228 = v46.AddDropdown(v46, "PlayerSelect", {
    ["Text"] = "Select Player",
    ["Default"] = "No players",
    ["Values"] = r227(),
    ["Callback"] = function(arg1_169, ...)
        d = arg1_169;
        
        if d == "No players" then
            r226(nil);
            
            return;
        end;
        
        j = r26;
        v1 = {
            j.GetPlayers(j)
        };
        G = j[3];
        
        for G, v1 in j[1], pairs(w(v1)) do
            j = G;
            
            if v1.Name == d then
                r205 = v1;
                
                r226(v1);
                
                break;
            else
                
            end; 
        end;
        
        return; 
    end
});

v46.AddButton(v46, "Biggest Player", function(...)
    v = -1;
    j = r26;
    v4 = j[2];
    j = j[1];
    
    for G, v5 in pairs(j.GetPlayers(j)) do
        v1 = G;
        
        if v5 ~= r34 then
            v6 = v5.GetAttribute(v5, "_GameWins") or 0;
            v7 = v6 > v;
            
            if v7 then
                v7 = v5.GetAttribute(v5, v9[v13]) or v8;
                d = v5;
                v = v6;
            end;
        end; 
    end;
    
    if nil then
        r205 = d;
        G = r228;
        
        G.SetValue(G, nil.Name);
        
        r226(nil);
        
        r39.Notify("Stats", "Biggest: " .. nil.Name .. " (" .. v .. " wins)", 3);
    end;
    
    r39.PlayBell();
    
    return; 
end);

local v48 = r26.PlayerAdded;

v48.Connect(v48, function(...)
    n = r228;
    
    n.SetValues(n, r227());
    
    return; 
end);

local v49 = r26.PlayerRemoving;

v49.Connect(v49, function(...)
    n = r228;
    
    n.SetValues(n, r227());
    
    k = r205 and not r205.Parent;
    
    if k then
        r226(nil);
        
        k = r228;
        
        k.SetValue(k, "No players");
    end;
    
    return; 
end);

local v50 = r29.Heartbeat;

v50.Connect(v50, function(...)
    if r205 and r205.Parent then
        r226(r205);
    end;
    
    return; 
end);
local v51 = v31.AddRightGroupbox(v31, "Miscs", "rocket");
local r229 = {};

local function r230(...)
    r229 = {};
    G = r26;
    j = {
        G.GetPlayers(G)
    };
    v = G[2];
    v4 = G[3];
    
    for v4, j in pairs(w(j)) do
        G = v4;
        
        if j ~= r34 then
            table.insert(r229, j.Name);
        end; 
    end;
    
    if #r229 == 0 then
        table.insert(r229, "No players");
    end;
    
    return; 
end;

r230();

local r232 = v51.AddDropdown(v51, "TeleportPlayerSelect", {
    ["Text"] = "Select Player",
    ["Default"] = "No players",
    ["Values"] = r229,
    ["Callback"] = function(arg1_170, ...)
        d = arg1_170;
        
        if d == "No players" then
            return;
        end;
        
        j = r26;
        v1 = {
            j.GetPlayers(j)
        };
        v = j[1];
        v4 = j[2];
        
        for G, v1 in pairs(w(v1)) do
            j = G;
            
            if v1.Name == d then
                r231 = v1;
                
                break;
            else
                
            end; 
        end;
        
        return; 
    end
});

v51.AddButton(v51, "Teleport to Selected", function(...)
    if r231 then
        r39.TeleportToPlayer(r231);
    else
        r39.Notify("Teleport", "No player selected", 2);
        r39.PlayBell();
    end;
    
    return; 
end);
v51.AddButton(v51, "Spectate Selected", function(...)
    if r231 then
        r39.SpectatePlayer(r231);
    else
        r39.Notify("Spectate", "No player selected", 2);
        r39.PlayBell();
    end;
    
    return; 
end);
v51.AddButton(v51, "Stop Spectating", function(...)
    r39.StopSpectate();
    
    return; 
end);

local v52 = r26.PlayerAdded;

v52.Connect(v52, function(...)
    task.wait(.1);
    
    r230();
    
    n = r232;
    
    n.SetValues(n, r229);
    
    return; 
end);

local v53 = r26.PlayerRemoving;

v53.Connect(v53, function(...)
    v = r15;
    
    task.wait(.1);
    
    k = r231 and not v.FindFirstChild(v, r231.Name);
    
    if k then
        k = r232;
        
        k.SetValue(k, "No players");
    end;
    
    r230();
    
    k = r232;
    
    k.SetValues(k, r229);
    
    return; 
end);
v51.AddButton(v51, "Teleport to Nearest", r39.teleportToNearest);
local v54 = v51.AddLabel(v51, "Keybind: G");

v54.AddKeyPicker(v54, "TPNearestBind", {
    ["Default"] = "G",
    ["Mode"] = "Toggle",
    ["Text"] = "Teleport to Nearest",
    ["Callback"] = function(...)
        r39.teleportToNearest();
        
        return; 
    end
});
local v55 = v32.AddLeftGroupbox(v32, "Gun", "crosshair");
local v56 = v32.AddRightGroupbox(v32, "Extras", "sparkles");
r35.HitboxExpander = v55.AddToggle(v55, "HitboxExpander", {
    ["Text"] = "Hitbox Expander",
    ["Default"] = false,
    ["Callback"] = r39.ToggleHitboxExpander
});

v55.AddSlider(v55, "HitboxSize", {
    ["Text"] = "Hitbox Size",
    ["Default"] = 167,
    ["Min"] = 50,
    ["Max"] = 999,
    ["Callback"] = r39.SetHitboxSize
});
r35.RapidFire = v55.AddToggle(v55, "RapidFire", {
    ["Text"] = "Rapid Fire",
    ["Default"] = false,
    ["Callback"] = r39.ToggleRapidFire
});
r35.InfiniteAmmo = v55.AddToggle(v55, "InfiniteAmmo", {
    ["Text"] = "Infinite Ammo",
    ["Default"] = false,
    ["Callback"] = r39.ToggleInfiniteAmmo
});
r35.AutoShoot = v55.AddToggle(v55, "AutoShoot", {
    ["Text"] = "AutoShoot",
    ["Default"] = false,
    ["Callback"] = r39.ToggleEffectShooter
});
r35.FreeGuard = v56.AddToggle(v56, "FreeGuard", {
    ["Text"] = "Free Guard",
    ["Default"] = false,
    ["Callback"] = r39.ToggleFreeGuard
});
r35.PermanentGuard = v56.AddToggle(v56, "PermanentGuard", {
    ["Text"] = "Permanent Guard",
    ["Default"] = false,
    ["Callback"] = r39.TogglePermanentGuard
});
local v57 = v33.AddLeftGroupbox(v33, "Player", "user");
local v58 = v33.AddLeftGroupbox(v33, "Emotes", "music");
local v59 = v33.AddLeftGroupbox(v33, "Combat", "sword");
local v60 = v33.AddRightGroupbox(v33, "Extras", "sparkles");
local v61 = v33.AddRightGroupbox(v33, "Boosts", "rocket");
local v62 = v33.AddLeftGroupbox(v33, "Gamepasses (NOT FE)", "crown");

if r39.IsFeatureSupported("SpeedHack") then
    
    r35.SpeedHack = v61.AddToggle(v61, "SpeedHack", {
        ["Text"] = "Speed Hack",
        ["Default"] = false,
        ["Callback"] = r39.ToggleSpeedHack
    });
    
    v61.AddSlider(v61, "SpeedValue", {
        ["Text"] = "Speed Value",
        ["Default"] = 39,
        ["Min"] = 16,
        ["Max"] = 50,
        ["Callback"] = r39.SetSpeedValue
    });
else
    
    Bv = v61.AddToggle(v61, "SpeedHack", {
        ["Text"] = "Speed Hack (Unsupported)",
        ["Default"] = false,
        ["Callback"] = r39.ToggleSpeedHack
    });
    
    Bv.SetDisabled(Bv, true);
end;

r35.RemoveStun = v61.AddToggle(v61, "RemoveStun", {
    ["Text"] = "Remove Stun",
    ["Default"] = false,
    ["Callback"] = r39.ToggleRemoveStun
});

local v63 = r35.RemoveStun;

v63.AddKeyPicker(v63, "RemoveStunBind", {
    ["Default"] = nil,
    ["Mode"] = "Toggle",
    ["Text"] = "Remove Stun Keybind",
    ["Callback"] = function(arg1_171, ...)
        d = arg1_171;
        
        r39.ToggleRemoveStun(d);
        
        n = r35.RemoveStun;
        
        if n then
            n = r35.RemoveStun;
            
            n.SetValue(n, d);
        end;
        
        return; 
    end
});
r35.FOVChanger = v57.AddToggle(v57, "FOVChanger", {
    ["Text"] = "FOV Changer",
    ["Default"] = false,
    ["Callback"] = r39.ToggleFOV
});

v57.AddSlider(v57, "FOVValue", {
    ["Text"] = "FOV Value",
    ["Default"] = 120,
    ["Min"] = 70,
    ["Max"] = 120,
    ["Callback"] = r39.SetFOV
});
r35.Fullbright = v57.AddToggle(v57, "Fullbright", {
    ["Text"] = "Fullbright",
    ["Default"] = false,
    ["Callback"] = r39.ToggleFullbright
});
r35.Ambience = v57.AddToggle(v57, "Ambience", {
    ["Text"] = "Ambience",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAmbience
});
r35.InstantInteract = v57.AddToggle(v57, "InstantInteract", {
    ["Text"] = "Instant Interact",
    ["Default"] = false,
    ["Callback"] = r39.ToggleInstantInteract
});

v57.AddSlider(v57, "FlySpeed", {
    ["Text"] = "Fly Speed",
    ["Default"] = 52,
    ["Min"] = 10,
    ["Max"] = 200,
    ["Callback"] = r39.SetFlySpeed
});
r35.Flight = v57.AddToggle(v57, "Flight", {
    ["Text"] = "Flight",
    ["Default"] = false,
    ["Callback"] = r39.ToggleFly
});

local v64 = r35.Flight;

v64.AddKeyPicker(v64, "FlightBind", {
    ["Default"] = nil,
    ["Mode"] = "Toggle",
    ["Text"] = "Flight",
    ["Callback"] = function(arg1_172, ...)
        r39.ToggleFly(arg1_172);
        
        return; 
    end
});
r35.PlayerAttach = v59.AddToggle(v59, "PlayerAttach", {
    ["Text"] = "KillAura",
    ["Default"] = false,
    ["Callback"] = r39.TogglePlayerAttach
});

local v65 = r35.PlayerAttach;

v65.AddKeyPicker(v65, "AttachBind", {
    ["Default"] = nil,
    ["Mode"] = "Toggle",
    ["Text"] = "Player Attach",
    ["Callback"] = function(arg1_173, ...)
        r39.TogglePlayerAttach(arg1_173);
        
        return; 
    end
});
r35.FaceTarget = v59.AddToggle(v59, "FaceTarget", {
    ["Text"] = "Face Target",
    ["Default"] = false,
    ["Callback"] = r39.ToggleFaceTarget
});

local v66 = r35.FaceTarget;

v66.AddKeyPicker(v66, "FaceTargetBind", {
    ["Default"] = nil,
    ["Mode"] = "Toggle",
    ["Text"] = "Face Target",
    ["Callback"] = function(arg1_174, ...)
        r39.ToggleFaceTarget(arg1_174);
        
        return; 
    end
});

local v67 = r39.IsFeatureSupported;

if v67("Desync") then
    
    r35.Desync = v59.AddToggle(v59, "Desync", {
        ["Text"] = "Desync",
        ["Default"] = false,
        ["Callback"] = r39.ToggleDesync
    });
    
    v67 = r35.Desync;
    
    v67.AddKeyPicker(v67, "DesyncBind", {
        ["Default"] = nil,
        ["Mode"] = "Toggle",
        ["Text"] = "Desync",
        ["Callback"] = function(arg1_175, ...)
            r39.ToggleDesync(arg1_175);
            
            return; 
        end
    });
else
    
    v67 = v59.AddToggle(v59, "Desync", {
        ["Text"] = "Desync (Unsupported)",
        ["Default"] = false,
        ["Callback"] = r39.ToggleDesync
    });
    
    v67.SetDisabled(v67, true);
end;

r35.AutoWin = v60.AddToggle(v60, "AutoWin", {
    ["Text"] = "Auto Win [BETA]",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAutoWin
});
r35.FreePhantomDash = v60.AddToggle(v60, "FreePhantomDash", {
    ["Text"] = "Free Phantom Dash",
    ["Default"] = false,
    ["Callback"] = function(arg1_176, ...)
        if arg1_176 then
            ToggleFreeDash(true, true);
            
            n = r34;
            
            n.SetAttribute(n, "_EquippedPower", "PHANTOM STEP");
            r39.Notify("Phantom Dash", "Enabled", 3);
            r39.PlayBell();
        else
            ToggleFreeDash(false, true);
            
            n = r34;
            
            n.SetAttribute(n, "_EquippedPower", nil);
            r39.PlayBell();
        end;
        
        return; 
    end
});
r35.FreeDash = v60.AddToggle(v60, "FreeDash", {
    ["Text"] = "Free Dash",
    ["Default"] = false,
    ["Callback"] = function(arg1_177, ...)
        ToggleFreeDash(arg1_177, false);
        
        return; 
    end
});
r35.Noclip = v60.AddToggle(v60, "Noclip", {
    ["Text"] = "TP Through Walls",
    ["Default"] = false,
    ["Callback"] = function(arg1_178, ...)
        d = arg1_178;
        
        r39.noclipEnabled = d;
        
        if d then
            v4 = r15;
            
            if r39.IsMobile() then
                r39.createNoclipButton();
            else
                v4 = r30.InputBegan;
                
                r39.noclipConnection = v4.Connect(v4, function(arg1_179, arg2_179, ...)
                    if arg2_179 then
                        return;
                    end;
                    
                    n = arg1_179.KeyCode == Enum.KeyCode.X;
                    
                    if n then
                        r39.teleportThroughWall();
                    end;
                    
                    return; 
                end);
            end;
        else
            n = r39.noclipButton;
            
            if n then
                n = r39.noclipButton;
                
                n.Destroy(n);
            end;
            
            n = r39.noclipConnection;
            
            if n then
                n = r39.noclipConnection;
                
                n.Disconnect(n);
            end;
            
            return;
        end; 
    end
});
r35.InfiniteJump = v60.AddToggle(v60, "InfiniteJump", {
    ["Text"] = "Infinite Jump",
    ["Default"] = false,
    ["Callback"] = r39.ToggleInfiniteJump
});
r35.AutoNextGame = v60.AddToggle(v60, "AutoNextGame", {
    ["Text"] = "Auto Next Game",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAutoNextGame
});
r35.PlayerESP = v60.AddToggle(v60, "PlayerESP", {
    ["Text"] = "Players ESP",
    ["Default"] = false,
    ["Callback"] = r39.ToggleESP
});

v60.AddButton(v60, "Teleport Up 100", r39.TeleportUp);
v60.AddButton(v60, "Teleport Down 40", r39.TeleportDown);
r35.AutoSafe = v60.AddToggle(v60, "AutoSafe", {
    ["Text"] = "Safe Place on Low Health",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAutoSafe
});

if r39.IsFeatureSupported("AutoQTE") then
    
    r35.AutoQTE = v60.AddToggle(v60, "AutoQTE", {
        ["Text"] = "Auto QTE",
        ["Default"] = false,
        ["Callback"] = r39.ToggleAutoQTE
    });
    
    v60.AddDropdown(v60, "AutoQTEMode", {
        ["Text"] = "Auto QTE Mode",
        ["Default"] = "Legit",
        ["Values"] = {
            "Legit",
            "Rage"
        },
        ["Callback"] = function(arg1_180, ...)
            d = arg1_180;
            
            r39.SetAutoQTEMode(d);
            
            if r39.AutoQTEEnabled then
                r39.Notify("Auto QTE", "Mode " .. d, 2);
            end;
            
            return; 
        end
    });
else
    
    v67 = v60.AddToggle(v60, "AutoQTE", {
        ["Text"] = "Auto QTE (Unsupported)",
        ["Default"] = false,
        ["Callback"] = r39.ToggleAutoQTE
    });
    
    v67.SetDisabled(v67, true);
end;

local r233 = v60.AddToggle(v60, "SkySquidAntiFallCopy", {
    ["Text"] = "AntiFall",
    ["Default"] = false,
    ["Callback"] = function(arg1_181, ...)
        r39.ToggleSkySquidAntiFall(arg1_181);
        
        return; 
    end
});
local v68 = r233;

v68.AddKeyPicker(v68, "SkySquidAntiFallBind", {
    ["Default"] = nil,
    ["Mode"] = "Toggle",
    ["Text"] = "AntiFall",
    ["Callback"] = function(arg1_182, ...)
        d = arg1_182;
        
        r39.ToggleSkySquidAntiFall(d);
        
        n = r233;
        
        n.SetValue(n, d);
        
        return; 
    end
});
r35.AutoCollectBandage = v60.AddToggle(v60, "AutoCollectBandage", {
    ["Text"] = "Auto Collect Bandage",
    ["Default"] = false,
    ["Callback"] = r39.ToggleAutoCollectBandage
});

v60.AddDivider(v60);
v60.AddDropdown(v60, "TitleSelect", {
    ["Text"] = "Select Title",
    ["Default"] = "Rich Millionaire",
    ["Values"] = {
        "Manipulator",
        "Rich Millionaire",
        "Rich Billionaire",
        "Fallen Angel",
        "Zeus",
        "Content Creator",
        "Aura Farmer",
        "The Recruiter",
        "Tanos",
        "The Glass Maker",
        "Frontman",
        "Squidder",
        "Game VIP",
        "Sackboy",
        "Him",
        "Honeycomb Artist",
        "The Chosen One",
        "Content Creator",
        "Game Developer",
        "Game Administrator",
        "Game Animator",
        "Game Artist",
        "Game Builder",
        "Game Contributer",
        "Game Modeller",
        "Game Moderator",
        "Game SFX Designer",
        "The Strongest",
        "The Perfect Lifeform",
        "Voice Actor",
        "SFX Designer"
    },
    ["Callback"] = function(arg1_183, ...)
        r39.SetTitle(arg1_183);
        
        return; 
    end
});
r35.FreeTitle = v60.AddToggle(v60, "FreeTitle", {
    ["Text"] = "Free Title (NOT FE)",
    ["Default"] = false,
    ["Callback"] = r39.ToggleFreeTitle
});

local r234 = {
    {
        ["Name"] = "Dream Journal",
        ["AnimId"] = "rbxassetid://117325441970867",
        ["SoundId"] = "rbxassetid://88476306353688",
        ["Volume"] = 10
    },
    {
        ["Name"] = "Otsukare Summer",
        ["AnimId"] = "rbxassetid://134888005420629",
        ["SoundId"] = "rbxassetid://127332409398776",
        ["Volume"] = 3
    },
    {
        ["Name"] = "Spite",
        ["AnimId"] = "rbxassetid://100382123964355",
        ["SoundId"] = "rbxassetid://90513005423910",
        ["Volume"] = 5
    },
    {
        ["Name"] = "Posing Time",
        ["AnimId"] = "rbxassetid://89240795237958",
        ["SoundId"] = "rbxassetid://113259086406604",
        ["Volume"] = 1
    },
    {
        ["Name"] = "Shuffle",
        ["AnimId"] = "rbxassetid://113121578988536",
        ["SoundId"] = nil,
        ["Volume"] = 5
    },
    {
        ["Name"] = "Yare Yare",
        ["AnimId"] = "rbxassetid://86642655479570",
        ["SoundId"] = "rbxassetid://128193072645447",
        ["Volume"] = 5
    },
    {
        ["Name"] = "My Perfect Victory",
        ["AnimId"] = "rbxassetid://110501561372722",
        ["SoundId"] = "rbxassetid://104280886491008",
        ["Volume"] = 5
    },
    {
        ["Name"] = "Fate Of Both Worlds",
        ["AnimId"] = "rbxassetid://114244682550258",
        ["SoundId"] = "rbxassetid://103081000050688",
        ["Volume"] = 5
    }
};
local r237 = false;

local function r240(...)
    if r235 then
        pcall(function(...)
            n = r235;
            
            n.Stop(n);
            
            return; 
        end);
    end;
    
    if r236 then
        pcall(function(...)
            n = X[vm3];
            
            n.Stop(n);
            
            return; 
        end);
        pcall(function(...)
            n = X[vm3];
            
            n.Destroy(n);
            
            return; 
        end);
    end;
    
    r237 = false;
    v = r239;
    
    if v then
        v = r239;
        
        v.SetText(v, "Play Emote");
    end;
    
    return; 
end;

local function r241(arg1_184, ...)
    d = arg1_184;
    
    r240();
    
    v = r39.GetHumanoid(r39.GetCharacter());
    
    if not v then
        r39.Notify("Emote", "No character found", 2);
        
        return;
    end;
    
    v4 = Instance.new("Animation");
    
    v4.AnimationId = d.AnimId;
    n = v.LoadAnimation(v, v4);
    r235 = n;
    k = r235;
    
    k.Play(k);
    
    if d.SoundId then
        
        G = Instance.new("Sound");
        
        G.SoundId = d.SoundId;
        v1 = v.LoadAnimation(v, v4);
        
        G.Volume = d.Volume or 5;
        G.Looped = true;
        G.Parent = r32;
        
        G.Play(G);
        
        r236 = G;
    end;
    
    r237 = true;
    j = r239;
    
    if j then
        j = r239;
        
        j.SetText(j, "Stop Emote");
    end;
    
    r39.PlayBell();
    
    return; 
end;

local v69 = {};
local v70 = {
    ipairs(r234)
};

local v71, v72 = ipairs(r234)(v70[2], v70[3]);

while v71 do
    
    vm2 = vm9(vm4, v70[3]);
    
    table.insert(v69, v72.Name); 
end;

local r238 = v58.AddDropdown(v58, "EmoteSelector", {
    ["Text"] = "Select Emote",
    ["Default"] = v69[1],
    ["Values"] = v69,
    ["Callback"] = function(arg1_185, ...)
        d = arg1_185;
        
        return; 
    end
});
local r239 = v58.AddButton(v58, "Play/Stop Emote", function(...)
    if r237 then
        r240();
    else
        G = r234;
        G = ("\x86\x1d\xbcm2")[1];
        
        for v4, v1 in ipairs(G) do
            j = v4;
            
            if v1.Name == r238.Value then
                r241(v1);
            else
                
            end; 
        end;
        
        r39.PlayBell();
        
        return;
    end; 
end);

(function(...)
    v4 = r16;
    
    G = v4("\x8d1\xf3\xbe<\xa2<\r", 25483668434522);
    
    if r39[r15[G]]() then
        v4 = r234;
        d = G[2];
        v4 = G[1];
        
        for v, j in ipairs(v4) do
            G = v;
            
            j.Volume = 4; 
        end;
    end;
    
    return; 
end)();

r35.PermanentGuard = v62.AddToggle(v62, "PermanentGuard", {
    ["Text"] = "Permanent Guard",
    ["Default"] = false,
    ["Callback"] = r39.TogglePermanentGuard
});
r35.CustomPlayerTag = v62.AddToggle(v62, "CustomPlayerTag", {
    ["Text"] = "Custom Player Tag",
    ["Default"] = false,
    ["Callback"] = r39.ToggleCustomPlayerTag
});
r35.PrivateServerPlus = v62.AddToggle(v62, "PrivateServerPlus", {
    ["Text"] = "Private Server Plus",
    ["Default"] = false,
    ["Callback"] = r39.TogglePrivateServerPlus
});
r35.FreeVIP = v62.AddToggle(v62, "FreeVIP", {
    ["Text"] = "Free VIP",
    ["Default"] = false,
    ["Callback"] = r39.ToggleFreeVIP
});
r35.Lighter = v62.AddToggle(v62, "Lighter", {
    ["Text"] = "Lighter",
    ["Default"] = false,
    ["Callback"] = r39.ToggleLighter
});
local v73 = v23.AddTab(v23, "Settings", "settings");
local v74 = v73.AddLeftGroupbox(v73, "Menu", "menu");
local v75 = v73.AddRightGroupbox(v73, "Executor Info", "info");

v74.AddToggle(v74, "KeybindMenuOpen", {
    ["Text"] = "Open Keybind Menu",
    ["Default"] = r24.KeybindFrame.Visible,
    ["Callback"] = function(arg1_186, ...)
        r24.KeybindFrame.Visible = arg1_186;
        
        return; 
    end
});
v74.AddDropdown(v74, "NotificationSide", {
    ["Callback"] = function(arg1_187, ...)
        n = r24;
        
        n.SetNotifySide(n, arg1_187);
        
        return; 
    end,
    ["Text"] = "Notification Side",
    ["Default"] = "Right",
    ["Values"] = {
        "Left",
        "Right"
    }
});
local v76 = v74.AddLabel(v74, "Menu bind");

v76.AddKeyPicker(v76, "MenuKeybind", {
    ["NoUI"] = true,
    ["Default"] = "Z",
    ["Text"] = "Menu keybind"
});

r39.CleanupEverything = function(...)
    r39.ToggleAutoWin(false);
    r39.ToggleRebel(false);
    r39.ToggleFly(false, true);
    r39.ToggleESP(false);
    r39.ToggleSpeedHack(false);
    r39.ToggleRemoveStun(false);
    r39.ToggleFOV(false);
    r39.ToggleFullbright(false);
    r39.ToggleAmbience(false);
    r39.ToggleHitboxExpander(false);
    r39.ToggleRapidFire(false);
    r39.ToggleInfiniteAmmo(false);
    r39.ToggleAutoNextGame(false);
    r39.ToggleAutoSafe(false);
    r39.ToggleAutoDodge(false);
    r39.ToggleAutoEscape(false);
    r39.ToggleAutoPickup(false);
    r39.ToggleFreeGuard(false);
    r39.ToggleEffectShooter(false);
    r39.ToggleFaceTarget(false);
    r39.TogglePlayerAttach(false);
    r39.ToggleGodMode(false);
    r39.ToggleRemoveInjury(false);
    r39.ToggleAntiBreak(false);
    r39.ToggleJumpRopeAntiFall(false);
    r39.ToggleGlassESP(false);
    r39.ToggleSpikesKill(false);
    r39.ToggleSpikesPlatformTeleport(false);
    r39.ToggleKeyESP(false);
    r39.ToggleExitDoorESP(false);
    r39.ToggleEspGuards(false);
    r39.ToggleGuardHitbox(false);
    r39.ToggleSkySquidAntiFall(false);
    r39.ToggleVoidKill(false);
    r39.ToggleMingleVoidKill(false);
    r39.ToggleZoneKill(false);
    r39.ToggleAutoChoke(false);
    r39.ToggleInfiniteStamina(false);
    r39.ToggleDesync(false);
    r39.stopEmote();
    
    if r39.AutoWinConnection then
        n = r39.AutoWinConnection;
        
        n.Disconnect(n);
        
        r39.AutoWinConnection = nil;
    end;
    
    if r39.Rebel.Connection then
        n = r39.Rebel.Connection;
        
        n.Disconnect(n);
        
        r39.Rebel.Connection = nil;
    end;
    
    if r39.Fly.Connection then
        n = r39.Fly.Connection;
        
        n.Disconnect(n);
        
        r39.Fly.Connection = nil;
    end;
    
    if r39.Fly.BodyVelocity then
        n = r39.Fly.BodyVelocity;
        
        n.Destroy(n);
        
        r39.Fly.BodyVelocity = nil;
    end;
    
    if r39.SpeedHackLoop then
        task.cancel(r39.SpeedHackLoop);
        
        r39.SpeedHackLoop = nil;
    end;
    
    if r39.FOVConnection then
        n = r39.FOVConnection;
        
        n.Disconnect(n);
        
        r39.FOVConnection = nil;
    end;
    
    if r39.FullbrightConnection then
        n = r39.FullbrightConnection;
        
        n.Disconnect(n);
        
        r39.FullbrightConnection = nil;
    end;
    
    if r39.ambienceConnection then
        n = r39.ambienceConnection;
        
        n.Disconnect(n);
        
        r39.ambienceConnection = nil;
    end;
    
    if r39.timeFixConnection then
        n = r39.timeFixConnection;
        
        n.Disconnect(n);
        
        r39.timeFixConnection = nil;
    end;
    
    if r39.motionBlur then
        n = r39.motionBlur;
        
        n.Destroy(n);
        
        r39.motionBlur = nil;
    end;
    
    if r39.AutoDodge.HeartbeatConnection then
        n = r39.AutoDodge.HeartbeatConnection;
        
        n.Disconnect(n);
        
        r39.AutoDodge.HeartbeatConnection = nil;
    end;
    
    G = r39.AutoDodge;
    B = G.Connections;
    v = G[3];
    B = G[1];
    
    for v, j in B, pairs(B) do
        G = v;
        r242 = j;
        
        if r242 then
            pcall(function(...)
                n = r242;
                
                n.Disconnect(n);
                
                return; 
            end);
        end; 
    end;
    
    r39.AutoDodge.Connections = {};
    
    if r39.AutoDodge.Remote and r39.AutoDodge.OriginalFireServer then
        pcall(function(...)
            v = "AutoDodge";
            
            r39[v].Remote.FireServer = r39.AutoDodge.OriginalFireServer;
            
            return; 
        end);
    end;
    
    if r39.AutoEscapeConnection then
        n = r39.AutoEscapeConnection;
        
        n.Disconnect(n);
        
        r39.AutoEscapeConnection = nil;
    end;
    
    j = r39;
    v = j[2];
    B = j[3];
    
    for B, j in pairs(j.SafetyPlatforms) do
        G = B;
        r243 = j;
        
        if r243 then
            pcall(function(...)
                n = r243;
                
                n.Destroy(n);
                
                return; 
            end);
        end; 
    end;
    
    r39.SafetyPlatforms = {};
    
    if r39.AntiBreakConn then
        n = r39.AntiBreakConn;
        
        n.Disconnect(n);
        
        r39.AntiBreakConn = nil;
    end;
    
    if r39.JumpRopeAntiFall.Conn then
        n = r39.JumpRopeAntiFall.Conn;
        
        n.Disconnect(n);
        
        r39.JumpRopeAntiFall.Conn = nil;
    end;
    
    if r39.JumpRopeAntiFall.Platform then
        n = r39.JumpRopeAntiFall.Platform;
        
        n.Destroy(n);
        
        r39.JumpRopeAntiFall.Platform = nil;
    end;
    
    pcall(function(...)
        d = r28;
        v = "FindFirstChild";
        j = r16;
        d = d[v](d, "GlassBridge") and d.FindFirstChild(d, "GlassHolder");
        
        if d then
            j = d.GetChildren;
            G = {
                j(d)
            };
            B = j[3];
            v = j[2];
            
            for B, u in pairs(w("pairs")) do
                j = B;
                x = u.GetChildren;
                c = x[2];
                C = x[3];
                
                for C, x in pairs(x(u)) do
                    y = C;
                    
                    if x.IsA(x, "Model") then
                        r = x.GetDescendants;
                        J = r[3];
                        e = r[2];
                        
                        for J, r in pairs(r(x)) do
                            R = J;
                            
                            P = r.IsA(r, "BasePart");
                            m = P;
                            
                            if P then
                            end; 
                        end;
                    end; 
                end; 
            end;
        end;
        
        return; 
    end);
    
    j = r39;
    
    for B, j in pairs(j.ModifiedParts) do
        r244 = B;
        r245 = j;
        j = 33;
        
        if r244 and r244.Parent then
            pcall(function(...)
                N = "\xca\xe0\x87W";
                
                r244.Size = X[n][r15[r16(N, 2006795715494)]];
                r244.CanCollide = X[n].CanCollide;
                r244.Transparency = X[n].Transparency;
                
                return; 
            end);
        end; 
    end;
    
    r39.ModifiedParts = {};
    
    j = r39;
    B = j[3];
    
    for B, j in pairs(j.OriginalFireRates) do
        r246 = B;
        r247 = j;
        j = 61;
        
        if r246 and r246.Parent then
            pcall(function(...)
                r246.Value = X[n];
                
                return; 
            end);
        end; 
    end;
    
    r39.OriginalFireRates = {};
    
    j = r39;
    B = j[3];
    
    for B, j in j[1], pairs(j.OriginalAmmo) do
        r248 = B;
        r249 = j;
        j = 266;
        
        if r248 and r248.Parent then
            pcall(function(...)
                r248.Value = X[n];
                
                return; 
            end);
        end; 
    end;
    
    r39.OriginalAmmo = {};
    
    d = r39.GetCharacter();
    
    if d then
        
        r250 = r39.GetHumanoid(d);
        
        if r250 then
            pcall(function(...)
                G = "J\xa2\xc7f\x02\x9f\x96\xc5\xd7";
                
                r250[r15[r16(G, 11260356252795)]] = 16;
                
                return; 
            end);
        end;
    end;
    
    r39.ClearESP();
    
    if r39.EspGuardsThread then
        task.cancel(r39.EspGuardsThread);
        
        r39.EspGuardsThread = nil;
    end;
    
    u = r39;
    G = u[3];
    
    for G, u in u[1], pairs(u.EspGuardsBoxes) do
        j = G;
        r251 = u;
        
        if r251 then
            pcall(function(...)
                n = r251;
                
                n.Destroy(n);
                
                return; 
            end);
        end; 
    end;
    
    r39.EspGuardsBoxes = {};
    
    if r39.ExitDoorESPThread then
        task.cancel(r39.ExitDoorESPThread);
        
        r39.ExitDoorESPThread = nil;
    end;
    
    u = r39;
    G = u[3];
    
    for G, u in u[1], pairs(u.ExitDoorESPObjects) do
        j = G;
        r252 = u;
        
        if r252 then
            pcall(function(...)
                n = r252;
                
                n.Destroy(n);
                
                return; 
            end);
        end; 
    end;
    
    r39.ExitDoorESPObjects = {};
    
    u = r39;
    
    for G, u in pairs(u.KeyESPBoxes) do
        r253 = u;
        j = G;
        
        if r253 then
            pcall(function(...)
                n = r253;
                
                n.Destroy(n);
                
                return; 
            end);
        end; 
    end;
    
    r39.KeyESPBoxes = {};
    
    if r39.KeyESPConnection then
        n = r39.KeyESPConnection;
        
        n.Disconnect(n);
        
        r39.KeyESPConnection = nil;
    end;
    
    if r39.SpikesKillFeature.PlatformPart then
        pcall(function(...)
            B = r15;
            n = r39.SpikesKillFeature.PlatformPart;
            
            n.Destroy(n);
            
            return; 
        end);
        
        r39.SpikesKillFeature.PlatformPart = nil;
    end;
    
    if r39.SpikesKillFeature.AnimationConnection then
        n = r39.SpikesKillFeature.AnimationConnection;
        
        n.Disconnect(n);
        
        r39.SpikesKillFeature.AnimationConnection = nil;
    end;
    
    if r39.SpikesKillFeature.CharacterAddedConnection then
        n = r39.SpikesKillFeature.CharacterAddedConnection;
        
        n.Disconnect(n);
        
        r39.SpikesKillFeature.CharacterAddedConnection = nil;
    end;
    
    if r39.SpikesKillFeature.SafetyCheckConnection then
        n = r39.SpikesKillFeature.SafetyCheckConnection;
        
        n.Disconnect(n);
        
        r39.SpikesKillFeature.SafetyCheckConnection = nil;
    end;
    
    if r39.SpikesKillFeature.AnimationCheckConnection then
        n = r39.SpikesKillFeature.AnimationCheckConnection;
        
        n.Disconnect(n);
        
        r39.SpikesKillFeature.AnimationCheckConnection = nil;
    end;
    
    u = r39.SpikesKillFeature;
    v = u[1];
    B = u[2];
    
    for G, u in pairs(u.AnimationStoppedConnections) do
        r254 = u;
        j = G;
        
        pcall(function(...)
            n = r254;
            
            n.Disconnect(n);
            
            return; 
        end); 
    end;
    
    r39.SpikesKillFeature.AnimationStoppedConnections = {};
    
    if r39.SpikesPlatformTeleport.Platform then
        pcall(function(...)
            B = r15;
            n = r39.SpikesPlatformTeleport.Platform;
            
            n.Destroy(n);
            
            return; 
        end);
        
        r39.SpikesPlatformTeleport.Platform = nil;
    end;
    
    if r39.SpikesPlatformTeleport.Connection then
        n = r39.SpikesPlatformTeleport.Connection;
        
        n.Disconnect(n);
        
        r39.SpikesPlatformTeleport.Connection = nil;
    end;
    
    if r39.ZoneKillFeature.AnimationConnection then
        n = r39.ZoneKillFeature.AnimationConnection;
        
        n.Disconnect(n);
        
        r39.ZoneKillFeature.AnimationConnection = nil;
    end;
    
    if r39.ZoneKillFeature.CharacterAddedConnection then
        n = r39.ZoneKillFeature.CharacterAddedConnection;
        
        n.Disconnect(n);
        
        r39.ZoneKillFeature.CharacterAddedConnection = nil;
    end;
    
    if r39.ZoneKillFeature.AnimationCheckConnection then
        n = r39.ZoneKillFeature.AnimationCheckConnection;
        
        n.Disconnect(n);
        
        r39.ZoneKillFeature.AnimationCheckConnection = nil;
    end;
    
    u = r39.ZoneKillFeature;
    B = u[2];
    v = u[1];
    
    for G, u in pairs(u.AnimationStoppedConnections) do
        r255 = u;
        j = G;
        
        pcall(function(...)
            n = X[n];
            
            n.Disconnect(n);
            
            return; 
        end); 
    end;
    
    r39.ZoneKillFeature.AnimationStoppedConnections = {};
    
    if r39.VoidKillConn then
        n = r39.VoidKillConn;
        
        n.Disconnect(n);
        
        r39.VoidKillConn = nil;
    end;
    
    if r39.VoidKillCharConn then
        n = r39.VoidKillCharConn;
        
        n.Disconnect(n);
        
        r39.VoidKillCharConn = nil;
    end;
    
    u = r39;
    G = u[3];
    
    for G, u in u[1], pairs(u.MingleConns) do
        j = G;
        r256 = u;
        
        pcall(function(...)
            n = X[n];
            
            n.Disconnect(n);
            
            return; 
        end); 
    end;
    
    r39.MingleConns = {};
    
    if r39.SkySquidAntiFall.Platform then
        pcall(function(...)
            B = r15;
            n = r39.SkySquidAntiFall.Platform;
            
            n.Destroy(n);
            
            return; 
        end);
        
        r39.SkySquidAntiFall.Platform = nil;
    end;
    
    if r39.SkySquidAntiFall.Conn then
        n = r39.SkySquidAntiFall.Conn;
        
        n.Disconnect(n);
        
        r39.SkySquidAntiFall.Conn = nil;
    end;
    
    if r39.GuardHitboxConnection then
        n = r39.GuardHitboxConnection;
        
        n.Disconnect(n);
        
        r39.GuardHitboxConnection = nil;
    end;
    
    u = r39;
    G = u[3];
    B = u[2];
    
    for G, u in pairs(u.GuardOriginalSizes) do
        r257 = G;
        r258 = u;
        
        if r257 and r257.Parent then
            pcall(function(...)
                r257.Size = X[n];
                
                return; 
            end);
        end; 
    end;
    
    r39.GuardOriginalSizes = {};
    
    if r39.StaminaConns then
        u = r39;
        G = u[3];
        
        for G, u in u[1], pairs(u.StaminaConns) do
            j = G;
            r259 = u;
            
            pcall(function(...)
                n = X[n];
                
                n.Disconnect(n);
                
                return; 
            end); 
        end;
        
        r39.StaminaConns = {};
    end;
    
    if r39.GameStateMonitor.Connection then
        n = r39.GameStateMonitor.Connection;
        
        n.Disconnect(n);
        
        r39.GameStateMonitor.Connection = nil;
    end;
    
    if r39.noclipButton then
        pcall(function(...)
            B = r16;
            n = r39.noclipButton;
            
            n.Destroy(n);
            
            return; 
        end);
        
        r39.noclipButton = nil;
    end;
    
    if r39.noclipConnection then
        n = r39.noclipConnection;
        
        n.Disconnect(n);
        
        r39.noclipConnection = nil;
    end;
    
    if r39.attachConnection then
        n = r39.attachConnection;
        
        n.Disconnect(n);
        
        r39.attachConnection = nil;
    end;
    
    if r39.autoSearchConnection then
        n = r39.autoSearchConnection;
        
        n.Disconnect(n);
        
        r39.autoSearchConnection = nil;
    end;
    
    r39.destroySquares();
    
    if r39.CurrentBodyVelocity then
        n = r39.CurrentBodyVelocity;
        
        n.Destroy(n);
        
        r39.CurrentBodyVelocity = nil;
    end;
    
    if r39.FaceTargetModule.Connection then
        n = r39.FaceTargetModule.Connection;
        
        n.Disconnect(n);
        
        r39.FaceTargetModule.Connection = nil;
    end;
    
    r39.FaceTargetModule.Enabled = false;
    r39.FullbrightEnabled = false;
    r39.RemoveStunEnabled = false;
    r39.AutoWinEnabled = false;
    r39.AutoDodge.Enabled = false;
    r39.AutoDodge.ActiveAnimations = {};
    r39.AutoDodge.LastAnimationStartTime = {};
    r39.AutoDodge.LastDodgeTime = 0;
    
    n = game;
    
    v = n.GetService(n, "Lighting");
    
    if r39.FullbrightSettings.Brightness then
        v.Brightness = r39.FullbrightSettings.Brightness;
        v.ClockTime = r39.FullbrightSettings.ClockTime;
        v.FogEnd = r39.FullbrightSettings.FogEnd;
        v.GlobalShadows = r39.FullbrightSettings.GlobalShadows;
        v.OutdoorAmbient = r39.FullbrightSettings.OutdoorAmbient;
        v.Ambient = r39.FullbrightSettings.Ambient;
    end;
    
    pcall(function(...)
        
        G = r16("\x9d\xe7FB\xf7\x12=\xd9.\xe2\xcb-\xae", 34273824538199);
        
        workspace[r15[G]].FieldOfView = 70;
        
        return; 
    end);
    
    r39.Fly.Enabled = false;
    r39.Fly.Speed = 45;
    r39.SpeedHackEnabled = false;
    r39.SpeedValue = 39;
    r39.FOVEnabled = false;
    r39.FOVValue = 120;
    r39.AmbienceEnabled = false;
    r39.HitboxEnabled = false;
    r39.RapidFireEnabled = false;
    r39.InfiniteAmmoEnabled = false;
    r39.AutoNextEnabled = false;
    r39.AutoSafe.Enabled = false;
    r39.AutoSafe.HasTeleported = false;
    r39.AutoSafe.LowHPChecked = false;
    r39.AutoEscapeEnabled = false;
    r39.AutoPickupEnabled = false;
    r39.FreeGuardSettings.Enabled = false;
    r39.EffectShooter.Enabled = false;
    r39.PlayerAttachEnabled = false;
    r39.GodModeEnabled = false;
    r39.RemoveInjuryEnabled = false;
    r39.AntiBreakEnabled = false;
    r39.JumpRopeAntiFall.Enabled = false;
    r39.GlassESPEnabled = false;
    r39.SpikesKillFeature.Enabled = false;
    r39.SpikesPlatformTeleport.Enabled = false;
    r39.KeyESPEnabled = false;
    r39.ExitDoorESPEnabled = false;
    r39.EspGuardsEnabled = false;
    r39.GuardHitboxEnabled = false;
    r39.SkySquidAntiFall.Enabled = false;
    r39.VoidKillEnabled = false;
    r39.MingleVoidKillEnabled = false;
    r39.ZoneKillFeature.Enabled = false;
    r39.AutoChokeEnabled = false;
    r39.InfStaminaActive = false;
    r39.noclipEnabled = false;
    
    return; 
end;

v74.AddButton(v74, "Unload Script", function(...)
    r39.CleanupEverything();
    
    n = r24;
    
    n.Unload(n);
    
    return; 
end);

local v77 = identifyexecutor;

if v77 then
    vm12 = type(identifyexecutor) == "function";
end;

local v78 = X[v];

if v77 then
    
    v76 = identifyexecutor();
end;

r39.checkHookSupport = function(...)
    n = vm36;
    
    if not (getrawmetatable and (hookfunction and setreadonly)) then
        return false;
    end;
    
    local function r260(...)
        local K = {
            K[1],
            K[2]
        };
        
        n = "original";
        
        return n; 
    end;
    
    r261 = false;
    
    B = pcall(function(...)
        local function B(...)
            X[v] = true;
            
            return r262(select(-2, ...)); 
        end;
        
        r262 = hookfunction(r260, B);
        
        r260();
        
        return; 
    end);
    
    if B then
        k = r261;
    end;
    
    return B; 
end;

local v79 = r39.checkHookSupport();

v75.AddLabel(v75, "Executor: " .. "Unknown");

if v79 then
    vm34 = "Supported";
end;

local v80 = r15;
local v81 = "Unsupported";
local v82 = v80;
local v83 = v82;

v75.AddLabel(v75, "Status: " .. (v81 or v81));
v75.AddDivider(v75);
v75.AddLabel(v75, "If you found any bugs dm:");
v75.AddLabel(v75, "@whonixx_ (Discord)");
v75.AddButton(v75, "Copy Discord Tag", function(...)
    if setclipboard then
        setclipboard("whonixx_");
        
        r39.Notify("Copied", "Discord tag copied to clipboard!", 2);
    else
        r39.Notify("Error", "Your executor does not support clipboard", 2);
    end;
    
    return; 
end);

local v84 = "\xf6\xf9\x8c\xc0";

r24.ToggleKeybind = r24.Options.MenuKeybind;

local v85 = r25;

v85.SetLibrary(v85, r24);
v4.SetLibrary(v4, r24);
v4.IgnoreThemeSettings(v4);
v4.SetIgnoreIndexes(v4, {
    "MenuKeybind"
});

local v86 = r25;

v86.SetFolder(v86, "HollyScriptX");
v4.SetFolder(v4, "HollyScriptX");
v4.BuildConfigSection(v4, v73);

local v87 = r25;

v87.ApplyToTab(v87, v73);
v4.LoadAutoloadConfig(v4);
task.defer(function(...)
    pcall(function(...)
        local K = {
            K[1],
            K[2],
            K[3],
            K[4]
        };
        
        v83 = game;
        d = "Lighting";
        
        v83.GetService(v83, d);
        
        if X[K[3]] and X[K[3]].GetCurrentTheme then
            
            v = X[K[3]].GetCurrentTheme();
        end;
        
        if v83 then
            v83 = X[K[3]];
            
            v83.SetTheme(v83, v83);
        else
            v83 = X[K[4]];
            
            v83.UpdateColorsUsingRegistry(v83);
        end;
        
        return; 
    end);
    
    return; 
end);
task.defer(function(...)
    task.wait(0.5);
    r39.UpdateAllTogglesByGame();
    
    return; 
end);

local v88 = r16;
local v89 = {
    pairs(r24[r15[v88(v84, 27761300025983)]])
};

local v90, v91 = pairs(r24[r15[v88(v84, 27761300025983)]])(v89[2], v89[3]);

while v90 do
    
    vm26 = vm28(vm30, v89[3]);
    v83 = v83;
    v84 = {
        pairs(v91.Groupboxes or {})
    };
    
    v88, vm19 = pairs(v91.Groupboxes or {})(v84[2], v84[3]);
    
    while v88 do
        
        v89 = vm38(vm18, v84[3]);
        
        pcall(function(arg1_188, ...)
            r263 = arg1_188;
            v83 = r263.Holder;
            
            v = v83.FindFirstChildWhichIsA(v83, "TextLabel");
            
            if not v then
                return;
            end;
            
            r264 = Instance.new("ImageButton");
            r264.Size = UDim2.new(0, 20, 0, 20);
            r264.Position = UDim2.new(1, 5, 0, 7);
            r264.BackgroundTransparency = 1;
            r264.Parent = v;
            
            v83 = r24;
            r265 = v83.GetIcon(v83, "chevron-down");
            v83 = r24;
            r266 = v83.GetIcon(v83, "chevron-right");
            
            r264.Image = r265.Url;
            r264.ImageRectOffset = r265.ImageRectOffset;
            r264.ImageRectSize = r265.ImageRectSize;
            
            r267 = false;
            r268 = r263.Container;
            r269 = r263.Holder;
            v.Size = UDim2.new(1, -50, 0, 34);
            
            v83 = r264.MouseButton1Click;
            
            v83.Connect(v83, function(...)
                r267 = not r267;
                
                if r267 then
                    v7 = 30639948494779;
                    
                    r268.Visible = false;
                    
                    r269.Size = UDim2[r15[r16("\x87\\\xfd", v7)]](1, 0, 0, 34);
                    r264.Image = r266.Url;
                    r264.ImageRectOffset = r266.ImageRectOffset;
                    r264.ImageRectSize = r266.ImageRectSize;
                else
                    v7 = 2008963744679;
                    
                    r268.Visible = true;
                    
                    k = r263;
                    
                    k.Resize(k);
                    
                    r264.Image = r265[r15[r16("\xacA\x0b", v7)]];
                    r264.ImageRectOffset = r265.ImageRectOffset;
                    r264.ImageRectSize = r265.ImageRectSize;
                end;
                
                return; 
            end);
            
            return; 
        end, vm19); 
    end; 
end;

r24.Scheme.BackgroundColor = Color3.fromRGB(0, 0, 0);
r24.Scheme.MainColor = Color3.fromRGB(25, 25, 25);
r24.Scheme.AccentColor = Color3.fromRGB(162, 162, 162);
r24.Scheme.OutlineColor = Color3.fromRGB(40, 40, 40);
r24.Scheme.FontColor = Color3.fromRGB(255, 255, 255);
r24.Scheme.Font = Font.fromEnum(Enum.Font.Gotham);

local v92 = r24;

v92.UpdateColorsUsingRegistry(v92);

local v93 = r26.LocalPlayer;
local r270 = v93.GetMouse(v93);
local v94 = Instance.new("ScreenGui");

v94.Name = "CustomCursor";
v94.ResetOnSpawn = false;
v94.Parent = v93.WaitForChild(v93, "PlayerGui");
local r271 = Instance.new("Frame");
r271.Size = UDim2.new(0, 40, 0, 40);
r271.BackgroundTransparency = 1;
r271.Parent = v94;
local v95 = Instance.new("Frame");
v95.Size = UDim2.new(0, 24, 0, 3);
v95.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
v95.BorderSizePixel = 1;
v95.BorderColor3 = Color3.fromRGB(0, 0, 0);
v95.Position = UDim2.new(0.5, -12, 0.5, -1.5);
v95.Parent = r271;
local v96 = Instance.new("Frame");
v96.Size = UDim2.new(0, 3, 0, 24);
v96.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
v96.BorderColor3 = Color3.fromRGB(0, 0, 0);
v96.Position = UDim2.new(0.5, -1.5, 0.5, -12);
v96.Parent = r271;
local v97 = Instance.new("Frame");
v97.Size = UDim2.new(0, 16, 0, 2);
v97.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
v97.BorderSizePixel = 1;
v97.BorderColor3 = Color3.fromRGB(0, 0, 0);
v97.Position = UDim2.new(0.5, -8, 0.5, -1);
v97.Rotation = 45;
v97.Parent = r271;
local v98 = Instance.new("Frame");
v98.Size = UDim2.new(0, 16, 0, 2);
v98.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
v98.BorderSizePixel = 1;
v98.BorderColor3 = Color3.fromRGB(0, 0, 0);
v98.Position = UDim2.new(0.5, -8, 0.5, -1);
v98.Rotation = -45;
v98.Parent = r271;
local r272 = Instance.new("TextLabel");
r272.Size = UDim2.new(0, 100, 0, 18);
r272.BackgroundTransparency = 1;
r272.Text = "HollyScriptX";
r272.TextColor3 = Color3.fromRGB(200, 200, 200);
r272.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
r272.TextStrokeTransparency = 0;
r272.TextSize = 12;
r272.Font = Enum.Font.GothamBold;
r272.TextXAlignment = Enum.TextXAlignment.Center;
r272.Parent = v94;

local r273 = 120;

tick();

local v99 = r29.RenderStepped;

v99.Connect(v99, function(arg1_189, ...)
    r271.Rotation = r271.Rotation + r273 * arg1_189;
    
    v = r270.X;
    v4 = r270.Y;
    
    r271.Position = UDim2.new(0, v - 20, 0, v4 - 20);
    r272.Position = UDim2.new(0, v - 50, 0, v4 - -20);
    
    return; 
end);
r39.PlayBell();
r39.Notify("HSX [BETA]", "Success Loaded!");
