local cloneref = (cloneref or clonereference or function(i) return i end)
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
do
	local E = Encrypt
	if type(E) ~= "table" then
		E = {}
		if type(Encrypt) == "function" then
			E.encode = Encrypt
		end
	end
	E.start = E.start or function() end
	E["end"] = E["end"] or function() end
	Encrypt = E
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/brojstypingshit-prog/savemanagerhollyyyy/refs/heads/main/ThemeManager.luau"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/brojstypingshit-prog/savemanagerhollyyyy/refs/heads/main/SaveManager.luau"))()

local Options = Library.Options
local Toggles = Library.Toggles

MainModule = MainModule or {}
MainModule.Keybinds = MainModule.Keybinds or {}
MainModule._KeybindPress = MainModule._KeybindPress or {}

local function HSXNotify(a, b, c)
	local title, content, dur = "HollyScriptX", "", 0.9
	if type(a) == "table" then
		title = tostring(a.Title or a.title or "HollyScriptX")
		content = tostring(a.Description or a.Content or a.text or a.Desc or "")
		dur = tonumber(a.Duration or a.duration) or 0.9
	elseif type(a) == "string" then
		title = a
		content = tostring(b or "")
		dur = tonumber(c) or 0.9
	end
	local msg = content ~= "" and (title .. " | " .. content) or title
	pcall(function() Library:Notify(msg, dur) end)
end

function Library:SetNotifySide(side)
	pcall(function()
		if Library.NotifySide ~= nil then Library.NotifySide = side end
	end)
end


MainModule._HSX_Side = {}
function MainModule.wrapGroupbox(gb)
	local s = {}
	s._raw = gb
	function s:Toggle(opts)
		opts = opts or {}
		local id = opts.Id or opts.Title or ("T" .. tostring(math.random(100000,999999)))
		id = tostring(id):gsub("%s+", "")
		local userCb = opts.Callback
		local tog = gb:AddToggle(id, {
			Text = opts.Title or id,
			Default = opts.Value and true or false,
			Tooltip = opts.Desc or opts.Tooltip,
			Callback = function(v)
				if MainModule and MainModule._SuppressUI then return end
				if userCb then pcall(userCb, v) end
			end,
		})
		if MainModule then
			MainModule._AllToggleRefs = MainModule._AllToggleRefs or {}
			MainModule._AllToggleRefs[id] = tog
		end
		if MainModule.ToggleRefs then MainModule.ToggleRefs[id] = tog end
		return tog
	end
	function s:Button(opts)
		if type(opts) == "string" then
			local title = opts
			return function(_, cb)
				return gb:AddButton({ Text = title, Func = function() if cb then pcall(cb) end end })
			end
		end
		opts = opts or {}
		return gb:AddButton({
			Text = opts.Title or opts.Text or "Button",
			Func = function() if opts.Callback then pcall(opts.Callback) end end,
			Tooltip = opts.Desc or opts.Tooltip,
		})
	end
	function s:Slider(opts)
		opts = opts or {}
		local id = opts.Id or opts.Title or ("S" .. tostring(math.random(100000,999999)))
		id = tostring(id):gsub("%s+", "")
		local range = opts.Value or {}
		local min = range.Min or opts.Min or 0
		local max = range.Max or opts.Max or 100
		local def = range.Default or opts.Default or min
		local userCb = opts.Callback
		return gb:AddSlider(id, {
			Text = opts.Title or id,
			Default = def,
			Min = min,
			Max = max,
			Rounding = opts.Step and (opts.Step < 1 and 1 or 0) or 0,
			Callback = function(v) if userCb then pcall(userCb, v) end end,
		})
	end
	function s:Dropdown(opts)
		opts = opts or {}
		local id = opts.Id or opts.Title or ("D" .. tostring(math.random(100000,999999)))
		id = tostring(id):gsub("%s+", "")
		local userCb = opts.Callback
		return gb:AddDropdown(id, {
			Text = opts.Title or id,
			Values = opts.Values or {},
			Default = opts.Value or opts.Default,
			Callback = function(v) if userCb then pcall(userCb, v) end end,
		})
	end
	function s:Input(opts)
		opts = opts or {}
		local id = opts.Id or opts.Title or ("I" .. tostring(math.random(100000,999999)))
		id = tostring(id):gsub("%s+", "")
		local userCb = opts.Callback
		return gb:AddInput(id, {
			Text = opts.Title or id,
			Default = opts.Value or opts.Default or "",
			Placeholder = opts.Placeholder,
			Callback = function(v) if userCb then pcall(userCb, v) end end,
		})
	end
	function s:Paragraph(opts)
		opts = opts or {}
		local text = type(opts) == "string" and opts or (opts.Title or opts.Text or "")
		local lbl = gb:AddLabel(tostring(text))
		function lbl:SetTitle(t) pcall(function() if lbl.SetText then lbl:SetText(t) end end) end
		return lbl
	end
	function s:Colorpicker(opts)
		opts = opts or {}
		local id = opts.Id or opts.Title or ("C" .. tostring(math.random(100000,999999)))
		id = tostring(id):gsub("%s+", ""):gsub("[^%w_]", "")
		local userCb = opts.Callback
		local def = opts.Default or opts.Value or Color3.fromRGB(255,255,255)
		local title = opts.Title or id
		local res
		pcall(function()
			local label = gb:AddLabel(title)
			res = label:AddColorPicker(id, {
				Default = def,
				Title = title,
				Callback = function(v)
					if userCb then pcall(userCb, v) end
				end,
			})
		end)
		return res
	end
	function s:Keybind(opts)
		opts = opts or {}
		local id = opts.Id or opts.Title or ("K" .. tostring(math.random(100000,999999)))
		id = tostring(id):gsub("%s+", "")
		local userCb = opts.Callback
		local label = gb:AddLabel(opts.Title or id)
		local kp
		pcall(function()
			kp = label:AddKeyPicker(id, {
				Default = opts.Value or opts.Default or "None",
				Mode = "Hold",
				Text = opts.Title or id,
				NoUI = opts.NoUI ~= false,
				Callback = function(v)
					if userCb then
						local name = typeof(v) == "EnumItem" and v.Name or tostring(v)
						if name == "true" or name == "false" then return end
						pcall(userCb, name)
					end
				end,
			})
		end)
		return kp or label
	end
	function s:AddKeyPicker(idx, info)
		return gb:AddLabel(info and info.Text or idx):AddKeyPicker(idx, info)
	end
	return s
end

function MainModule.wrapTab(tab)
	local t = {}
	local side = 0
	function t:Section(opts)
		opts = opts or {}
		local title = opts.Title or "Section"
		local icon = opts.Icon
		side = side + 1
		local gb
		if side % 2 == 1 then
			gb = tab:AddLeftGroupbox(title, icon)
		else
			gb = tab:AddRightGroupbox(title, icon)
		end
		return MainModule.wrapGroupbox(gb)
	end
	function t:AddLeftGroupbox(title, icon)
		return MainModule.wrapGroupbox(tab:AddLeftGroupbox(title, icon))
	end
	function t:AddRightGroupbox(title, icon)
		return MainModule.wrapGroupbox(tab:AddRightGroupbox(title, icon))
	end
	return t
end


WindUI = {

	Window = nil,
	Notify = function(_, opts)
		local title = opts and (opts.Title or "HollyScriptX") or "HollyScriptX"
		local content = opts and (opts.Content or opts.Description or "") or ""
		HSXNotify(title, content, opts and opts.Duration or 0.9)
	end,
	SetTheme = function() end,
	GetThemes = function() return {} end,
	ToggleAcrylic = function() end,
	Destroy = function() end,
}

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local HttpService = game:GetService("HttpService")
    local Stats = game:GetService("Stats")
    local SoundService = game:GetService("SoundService")
    local TweenService = game:GetService("TweenService")

    local LocalPlayer = Players.LocalPlayer

MainModule.ToggleRefs = MainModule.ToggleRefs or {}
MainModule.ToggleGameRequirements = MainModule.ToggleGameRequirements or {}
MainModule.guiCreated = false
MainModule.pendingNotifications = {}

local function SafeDestroy(obj)
    if obj and obj.Parent then
        pcall(function() obj:Destroy() end)
    end
end

local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

MainModule = MainModule or {}

MainModule.get_character = function()
    return LocalPlayer.Character
end

MainModule.get_humanoid = function(c)
    return c and c:FindFirstChildOfClass("Humanoid")
end

MainModule.get_root_part = function(c)
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function removeCursorUI()
    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local cursorUI = playerGui:FindFirstChild("HollyScriptX_Cursor")
    if cursorUI then
        cursorUI:Destroy()
    end
end

removeCursorUI()

MainModule.is_xeno_executor = function()
    if identifyexecutor and type(identifyexecutor) == "function" then
        local executor = identifyexecutor():lower()
        if executor:find("xeno") or executor:find("Xeno") then return true end
    end
    return false
end

MainModule.is_feature_supported = function(featureName)
    if MainModule.is_xeno_executor() then
        local unsupportedFeatures = {"AutoDodge", "FreeGuard", "AutoQTE", "Desync"}
        for _, f in ipairs(unsupportedFeatures) do
            if f == featureName then
                return false
            end
        end
    end
    return true
end

MainModule.update_toggle_availability = function(toggleName, gameName, toggleRef)
    local isGameActive = false
    if gameName then
        local values = Workspace:FindFirstChild("Values")
        if values then
            local currentGame = values:FindFirstChild("CurrentGame")
            isGameActive = currentGame and currentGame.Value == gameName
        end
    else
        isGameActive = true
    end

    local isSupported = MainModule.is_feature_supported(toggleName)

    if toggleRef and toggleRef.SetDisabled then
        local shouldDisable = (not isGameActive and gameName ~= nil) or not isSupported
        pcall(function() toggleRef:SetDisabled(shouldDisable) end)

        if toggleRef.Value == true and not isGameActive and gameName ~= nil then
            pcall(function() toggleRef:SetValue(false) end)
        end
    end
end

MainModule.notify = function(title, text, duration)
    local d = tonumber(duration) or 0.9
    if MainModule.guiCreated then
        HSXNotify({Title = title, Description = text, Duration = d})
    else
        table.insert(MainModule.pendingNotifications, {title = title, text = text, duration = d})
        pcall(function() HSXNotify({Title = title, Description = text, Duration = d}) end)
    end
end

MainModule.SpectateModeEnabled = false

function MainModule.toggle_spectate_mode(enabled)
    enabled = enabled and true or false
    MainModule.SpectateModeEnabled = enabled

    pcall(function()
        local values = workspace:FindFirstChild("Values")
        if not values then
            return
        end

        local canSpectate = values:FindFirstChild("CanSpectateIfWonGame")
        if canSpectate and canSpectate:IsA("ValueBase") then
            canSpectate.Value = enabled
        end
    end)

    PlayToggleSound()
    return true
end

MainModule.RapidFireEnabled = false
MainModule.OriginalFireRates = {}
MainModule.RapidFireConnection = nil

function MainModule.toggle_rapid_fire(enabled)
    MainModule.RapidFireEnabled = enabled

    if enabled then
        if MainModule.RapidFireConnection then return end

        MainModule.RapidFireConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.RapidFireEnabled then return end

            pcall(function()
                local w = ReplicatedStorage:FindFirstChild("Weapons")
                if w and w:FindFirstChild("Guns") then
                    for _, o in pairs(w.Guns:GetDescendants()) do
                        if o.Name == "FireRateCD" and (o:IsA("NumberValue") or o:IsA("IntValue")) then
                            if not MainModule.OriginalFireRates[o] then
                                MainModule.OriginalFireRates[o] = o.Value
                            end
                            o.Value = 0
                        end
                    end
                end

                local c = MainModule.get_character and MainModule.get_character() or MainModule.GetCharacter and MainModule.GetCharacter()
                if c then
                    for _, t in pairs(c:GetChildren()) do
                        if t:IsA("Tool") then
                            for _, o in pairs(t:GetDescendants()) do
                                if o.Name == "FireRateCD" and (o:IsA("NumberValue") or o:IsA("IntValue")) then
                                    if not MainModule.OriginalFireRates[o] then
                                        MainModule.OriginalFireRates[o] = o.Value
                                    end
                                    o.Value = 0
                                end
                            end
                        end
                    end
                end
            end)
        end)
    else
        if MainModule.RapidFireConnection then
            MainModule.RapidFireConnection:Disconnect()
            MainModule.RapidFireConnection = nil
        end

        for o, v in pairs(MainModule.OriginalFireRates) do
            if o and o.Parent then
                o.Value = v
            else
                MainModule.OriginalFireRates[o] = nil
            end
        end
        MainModule.OriginalFireRates = {}
    end

    if MainModule.ToggleRefs.RapidFire then
        MainModule.ToggleRefs.RapidFire:SetValue(enabled)
    end

    PlayToggleSound()
end



loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
--@encrypt_start
loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
MainModule.PentathlonConnections = {}
MainModule.PentathlonStates = {}

local gameCache = {obj = nil, time = 0}
local activeCache = {val = false, time = 0}

local function findActivePentathlonGame()
    local char = LocalPlayer.Character
    if not char then return nil end
    local ok, result = pcall(function()
        for _, obj in ipairs(getgc(true)) do
            if type(obj) == "table" and rawget(obj, "GUID") and rawget(obj, "Players") and rawget(obj, "Active") then
                local players = rawget(obj, "Players")
                if type(players) == "table" then
                    for _, v in pairs(players) do
                        if v == char then
                            return obj
                        end
                    end
                end
            end
        end
        return nil
    end)
    return ok and result or nil
end

local function getCachedGame()
    if tick() - gameCache.time > 2 then
        gameCache.time = tick()
        gameCache.obj = findActivePentathlonGame()
    end
    return gameCache.obj
end

local function isPentathlonActive()
    if tick() - activeCache.time > 0.5 then
        activeCache.time = tick()
        activeCache.val = LocalPlayer:GetAttribute("InPentathlon") == true or Workspace:FindFirstChild("PentathlonMap") ~= nil
    end
    return activeCache.val
end

local function getPentathlonClient()
    local ok, mod = pcall(function()
        return require(ReplicatedStorage.Modules.Games.PentathlonClient)
    end)
    return ok and mod or nil
end

local function stopPentathlonAuto(name)
    if MainModule.PentathlonConnections[name] then
        MainModule.PentathlonConnections[name]:Disconnect()
        MainModule.PentathlonConnections[name] = nil
    end
    MainModule.PentathlonStates[name] = nil
end

MainModule.AutoDdakji = false
function MainModule.toggle_auto_ddakji(enabled)
    MainModule.AutoDdakji = enabled
    stopPentathlonAuto("Ddakji")
    if enabled then
        local Client = getPentathlonClient()
        if not Client then PlayToggleSound() return end
        local POWER = 0.9512388499560662
        local POSITION = Vector3.new(-147.3336944580078, 6001.07568359375, -19.965335845947266)
        local lastAction = 0
        MainModule.PentathlonConnections["Ddakji"] = task.spawn(function()
            while MainModule.AutoDdakji do
                if not isPentathlonActive() then break end
                if tick() - lastAction >= 1.5 then
                    local game = getCachedGame()
                    if game and game.Active and game.CurrentPlayer == LocalPlayer.Character then
                        pcall(function()
                            Client.RunServerGame(game, "Thrown", {Power = POWER, Position = POSITION})
                        end)
                        lastAction = tick()
                    end
                end
                task.wait(0.1)
            end
            stopPentathlonAuto("Ddakji")
        end)
    end
    PlayToggleSound()
end

MainModule.AutoFlyingStone = false
function MainModule.toggle_auto_flying_stone(enabled)
    MainModule.AutoFlyingStone = enabled
    stopPentathlonAuto("FlyingStone")
    if enabled then
        local Client = getPentathlonClient()
        if not Client then PlayToggleSound() return end
        local lastAction = 0
        local standCache = {stand = nil, game = nil}
        MainModule.PentathlonConnections["FlyingStone"] = task.spawn(function()
            while MainModule.AutoFlyingStone do
                if not isPentathlonActive() then break end
                if tick() - lastAction >= 1.5 then
                    local game = getCachedGame()
                    if game and game.Active and game.CurrentPlayer == LocalPlayer.Character then
                        local character = LocalPlayer.Character
                        local hrp = character and character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            if not standCache.stand or standCache.game ~= game then
                                standCache.game = game
                                local map = Workspace:FindFirstChild("PentathlonMap")
                                standCache.stand = map and map:FindFirstChild("Stand", true)
                            end
                            local targetPos
                            if standCache.stand and standCache.stand:FindFirstChild("Target") then
                                targetPos = standCache.stand.Target.Position
                            else
                                targetPos = hrp.Position + hrp.CFrame.LookVector * 20
                            end
                            local origin = hrp.Position + Vector3.new(0,1.5,0)
                            local direction = (targetPos - origin).Unit
                            pcall(function()
                                Client.RunServerGame(game, "Thrown", {ThrowPower = "Perfect", Origin = origin, Direction = direction})
                            end)
                            lastAction = tick()
                        end
                    end
                end
                task.wait(0.1)
            end
            stopPentathlonAuto("FlyingStone")
        end)
    end
    PlayToggleSound()
end

MainModule.AutoGonggi = false
function MainModule.toggle_auto_gonggi(enabled)
    MainModule.AutoGonggi = enabled
    stopPentathlonAuto("Gonggi")
    if enabled then
        local Client = getPentathlonClient()
        if not Client then PlayToggleSound() return end
        local lastAction = 0
        local collectedPieces = {}
        local lastGame = nil
        MainModule.PentathlonConnections["Gonggi"] = task.spawn(function()
            while MainModule.AutoGonggi do
                if not isPentathlonActive() then break end
                local game = getCachedGame()
                if game and game.Active and game.CurrentPlayer == LocalPlayer.Character and tick() - lastAction >= 2.5 then
                    if game ~= lastGame then
                        lastGame = game
                        table.clear(collectedPieces)
                    end
                    local map = Workspace:FindFirstChild("PentathlonMap")
                    if map then
                        local pieceToGrab
                        for _, obj in ipairs(map:GetDescendants()) do
                            if obj:IsA("BasePart") and obj:FindFirstChild("GrabHighlight") and not collectedPieces[obj.Name] then
                                pieceToGrab = obj
                                break
                            end
                        end
                        if pieceToGrab then
                            collectedPieces[pieceToGrab.Name] = true
                            lastAction = tick()
                            task.spawn(function()
                                task.wait(0.4)
                                if game and game.Active then
                                    pcall(function() Client.RunServerGame(game, "GotPiece", {Name = pieceToGrab.Name}) end)
                                end
                                task.wait(0.3)
                                if game and game.Active then
                                    local allDone = true
                                    for _, p in ipairs(map:GetDescendants()) do
                                        if p:IsA("BasePart") and p:FindFirstChild("GrabHighlight") and not collectedPieces[p.Name] then
                                            allDone = false
                                            break
                                        end
                                    end
                                    if allDone then
                                        pcall(function() Client.RunServerGame(game, "TimeSlowFinish") end)
                                    end
                                end
                            end)
                        end
                    end
                end
                task.wait(0.1)
            end
            stopPentathlonAuto("Gonggi")
        end)
    end
    PlayToggleSound()
end

MainModule.AutoSpinningTop = false
function MainModule.toggle_auto_spinning_top(enabled)
    MainModule.AutoSpinningTop = enabled
    stopPentathlonAuto("SpinningTop")
    if enabled then
        local Client = getPentathlonClient()
        if not Client then PlayToggleSound() return end
        local phase = "Tie"
        local hooked = false
        local lastAction = 0
        local lastGame = nil
        local function hookGame(g)
            if hooked or not g or not g.HandleRequest then return end
            local original = g.HandleRequest
            g.HandleRequest = function(self, cmd, data, ...)
                if cmd == "Aim" then phase = "Aim"
                elseif cmd == "SetPlayer" or cmd == "Restart" then phase = "Tie"
                elseif cmd == "Reset" then phase = nil end
                return original(self, cmd, data, ...)
            end
            hooked = true
        end
        MainModule.PentathlonConnections["SpinningTop"] = task.spawn(function()
            while MainModule.AutoSpinningTop do
                if not isPentathlonActive() then break end
                local game = getCachedGame()
                if game and game.Active then
                    if game ~= lastGame then
                        lastGame = game
                        hooked = false
                        phase = "Tie"
                        hookGame(game)
                    end
                    if game.CurrentPlayer == LocalPlayer.Character then
                        local now = tick()
                        if phase == "Tie" and now - lastAction > 0.3 then
                            pcall(function() Client.RunServerGame(game, "Tied", {}) end)
                            lastAction = now
                        elseif phase == "Aim" and now - lastAction > 1.5 then
                            pcall(function() Client.RunServerGame(game, "Thrown", {}) end)
                            lastAction = now
                        end
                    end
                end
                task.wait(0.1)
            end
            stopPentathlonAuto("SpinningTop")
        end)
    end
    PlayToggleSound()
end

MainModule.AutoJegi = false
function MainModule.toggle_auto_jegi(enabled)
    MainModule.AutoJegi = enabled
    stopPentathlonAuto("Jegi")
    if enabled then
        local Client = getPentathlonClient()
        if not Client then PlayToggleSound() return end
        local lastKick = 0
        MainModule.PentathlonConnections["Jegi"] = task.spawn(function()
            while MainModule.AutoJegi do
                if not isPentathlonActive() then break end
                if tick() - lastKick >= 0.8 then
                    local game = getCachedGame()
                    if game and game.Active and game.CurrentPlayer == LocalPlayer.Character then
                        pcall(function() Client.RunServerGame(game, "Kick", {Lose = false}) end)
                        lastKick = tick()
                    end
                end
                task.wait(0.1)
            end
            stopPentathlonAuto("Jegi")
        end)
    end
    PlayToggleSound()
end



--@encrypt_end
MainModule.DalgonaAutoRelax = false
MainModule.DalgonaAutoRelaxConnection = nil
MainModule.DalgonaLastRelax = 0

function MainModule.toggle_dalgona_auto_relax(enabled)
    MainModule.DalgonaAutoRelax = enabled

    if MainModule.DalgonaAutoRelaxConnection then
        MainModule.DalgonaAutoRelaxConnection:Disconnect()
        MainModule.DalgonaAutoRelaxConnection = nil
    end

    if enabled then
        MainModule.DalgonaLastRelax = 0

        MainModule.DalgonaAutoRelaxConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.DalgonaAutoRelax then return end

            if tick() - MainModule.DalgonaLastRelax < 5 then return end

            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if not playerGui then return end

            local dalgonaUI = playerGui:FindFirstChild("DalgonaUI")
            if not dalgonaUI then return end

            local breathing = dalgonaUI:FindFirstChild("Breathing")
            if not breathing or not breathing.Visible then return end

            local breath = breathing:FindFirstChild("Breath")
            if not breath then return end

            local crackBar = breathing:FindFirstChild("CrackProgressBar")
            if not crackBar then return end

            local shadow = crackBar:FindFirstChild("ChanceShadow")
            local chance = shadow and shadow:FindFirstChild("Chance")
            local text = chance and chance.Text or "0%"
            local percent = tonumber(text:match("(%d+)")) or 0

            if percent <= 0 or percent >= 95 then return end

            pcall(function()
                firesignal(breath.MouseButton1Click)
            end)

            MainModule.DalgonaLastRelax = tick()
        end)
    end

    PlayToggleSound()
end

MainModule.TugOfWarAutoQTEMiss = false
MainModule.TugOfWarAutoQTEMissConnection = nil
MainModule.TugOfWarAutoPull = false
MainModule.TugOfWarAutoPullConnection = nil
MainModule.TugOfWarUltraFastPull = false
MainModule.TugOfWarUltraFastPullConnection = nil
MainModule.TugOfWarUltraFastPullMissConnection = nil

local function findTugOfWarCircle()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    local ui = playerGui:FindFirstChild("TugOfWarUIV2")
        or playerGui:FindFirstChild("TugOfWarUI")
        or playerGui:FindFirstChild("TugofWarRemake")
    if not ui then return nil end
    local remake = ui:FindFirstChild("TugofWarRemake") or ui
    local circle = remake and remake:FindFirstChild("CircleBase")
    if circle and circle.Visible then return circle end
    return nil
end

function MainModule.toggle_tug_of_war_auto_qte_miss(enabled)
    MainModule.TugOfWarAutoQTEMiss = enabled
    if MainModule.TugOfWarAutoQTEMissConnection then
        MainModule.TugOfWarAutoQTEMissConnection:Disconnect()
        MainModule.TugOfWarAutoQTEMissConnection = nil
    end
    if enabled then
        MainModule.TugOfWarAutoQTEMissConnection = RunService.RenderStepped:Connect(function()
            if not MainModule.TugOfWarAutoQTEMiss then return end
            if LocalPlayer:GetAttribute("TugOfWarPhase") ~= "QTE" then return end
            local circle = findTugOfWarCircle()
            if not circle then return end
            local arrow = circle:FindFirstChild("Arrow")
            local medium = circle:FindFirstChild("Medium")
            if not arrow or not medium then return end
            medium.Rotation = arrow.Rotation
        end)
    end
    PlayToggleSound()
end

function MainModule.toggle_tug_of_war_auto_pull(enabled)
    MainModule.TugOfWarAutoPull = enabled
    if MainModule.TugOfWarAutoPullConnection then
        MainModule.TugOfWarAutoPullConnection:Disconnect()
        MainModule.TugOfWarAutoPullConnection = nil
    end
    if enabled then
        local function startLoop()
            MainModule.TugOfWarAutoPullConnection = RunService.Heartbeat:Connect(function()
                if not MainModule.TugOfWarAutoPull then return end
                if LocalPlayer:GetAttribute("TugOfWarPhase") ~= "QTE" then return end
                local circle = findTugOfWarCircle()
                if not circle or not circle.Visible then return end
                local arrow = circle:FindFirstChild("Arrow")
                local medium = circle:FindFirstChild("Medium")
                local btn = circle:FindFirstChild("TextButton")
                if not arrow or not medium or not btn then return end
                local strategy = LocalPlayer:GetAttribute("TugOfWarStrategy") or "Standard"
                local hitZone = 26
                if strategy == "Stall" then hitZone = math.floor(26 * 0.8) end
                local diff = (medium.Rotation - arrow.Rotation + 180) % 360 - 180
                if math.abs(diff) <= hitZone then
                    pcall(function() firesignal(btn.MouseButton1Click) end)
                end
            end)
        end
        startLoop()
        LocalPlayer:GetAttributeChangedSignal("TugOfWarPhase"):Connect(function()
            if LocalPlayer:GetAttribute("TugOfWarPhase") ~= "QTE" then
                if MainModule.TugOfWarAutoPullConnection then
                    MainModule.TugOfWarAutoPullConnection:Disconnect()
                    MainModule.TugOfWarAutoPullConnection = nil
                end
            else
                if MainModule.TugOfWarAutoPull then startLoop() end
            end
        end)
    end
    PlayToggleSound()
end

function MainModule.toggle_tug_of_war_ultra_fast_pull(enabled)
    MainModule.TugOfWarUltraFastPull = enabled
    if MainModule.TugOfWarUltraFastPullConnection then
        MainModule.TugOfWarUltraFastPullConnection:Disconnect()
        MainModule.TugOfWarUltraFastPullConnection = nil
    end
    if MainModule.TugOfWarUltraFastPullMissConnection then
        MainModule.TugOfWarUltraFastPullMissConnection:Disconnect()
        MainModule.TugOfWarUltraFastPullMissConnection = nil
    end
    if enabled then
        MainModule.TugOfWarUltraFastPullMissConnection = RunService.RenderStepped:Connect(function()
            if not MainModule.TugOfWarUltraFastPull then return end
            if LocalPlayer:GetAttribute("TugOfWarPhase") ~= "QTE" then return end
            local circle = findTugOfWarCircle()
            if not circle then return end
            local arrow = circle:FindFirstChild("Arrow")
            local medium = circle:FindFirstChild("Medium")
            if not arrow or not medium then return end
            medium.Rotation = arrow.Rotation
        end)
        MainModule.TugOfWarUltraFastPullConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.TugOfWarUltraFastPull then return end
            if LocalPlayer:GetAttribute("TugOfWarPhase") ~= "QTE" then return end
            local circle = findTugOfWarCircle()
            if not circle or not circle.Visible then return end
            local arrow = circle:FindFirstChild("Arrow")
            local medium = circle:FindFirstChild("Medium")
            local btn = circle:FindFirstChild("TextButton")
            if not arrow or not medium or not btn then return end
            local diff = (medium.Rotation - arrow.Rotation + 180) % 360 - 180
            if math.abs(diff) <= 26 then
                pcall(function() firesignal(btn.MouseButton1Click) end)
            end
        end)
    end
    PlayToggleSound()
end

MainModule.AutoRespawnOnFall = {
    Enabled = false,
    Connection = nil,
    FallHeight = 950,
    TeleportPosition = Vector3.new(0, 966, -6),
    HasTeleported = false
}

function MainModule.toggle_auto_respawn_on_fall(enabled)
    local toggleRef = MainModule.ToggleRefs.AutoRespawnOnFall

    MainModule.AutoRespawnOnFall.Enabled = enabled
    MainModule.AutoRespawnOnFall.HasTeleported = false

    if MainModule.AutoRespawnOnFall.Connection then
        MainModule.AutoRespawnOnFall.Connection:Disconnect()
        MainModule.AutoRespawnOnFall.Connection = nil
    end

    if enabled then
        MainModule.AutoRespawnOnFall.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.AutoRespawnOnFall.Enabled then return end
            if MainModule.is_game_active and not MainModule.is_game_active("SkySquidGame") then return end

            local character = MainModule.get_character()
            if not character then return end

            local rootPart = MainModule.get_root_part(character)
            if not rootPart then return end

            local currentY = rootPart.Position.Y

            if currentY <= MainModule.AutoRespawnOnFall.FallHeight and not MainModule.AutoRespawnOnFall.HasTeleported then
                rootPart.CFrame = CFrame.new(MainModule.AutoRespawnOnFall.TeleportPosition)
                MainModule.AutoRespawnOnFall.HasTeleported = true
                PlayBell()
            end
            if currentY > MainModule.AutoRespawnOnFall.FallHeight then
                MainModule.AutoRespawnOnFall.HasTeleported = false
            end
        end)
    end
    PlayToggleSound()
end

MainModule.VoidKillSettings = {
    Enabled = false,
    Conn = nil,
    CharConn = nil,
    Platform = nil,
    BackupPlatform = nil
}

MainModule.VoidAnimIds = {
    "rbxassetid://107989020363293",
    "rbxassetid://95016887526212",
    "rbxassetid://81454586970343"
}

function MainModule.toggle_void_kill(enabled)
    local toggleRef = MainModule.ToggleRefs.VoidKill

    if enabled then
        if not MainModule.is_game_active("SkySquidGame") then
            HSXNotify("Void Kill", "Wait for SkySquidGame!", 0.9)
            PlayErrorSound()
            if toggleRef and toggleRef.SetValue then
                pcall(function() toggleRef:SetValue(false) end)
            end
            return false
        end
    end

    if not enabled then
        if MainModule.VoidKillSettings.Conn then
            MainModule.VoidKillSettings.Conn:Disconnect()
            MainModule.VoidKillSettings.Conn = nil
        end
        if MainModule.VoidKillSettings.CharConn then
            MainModule.VoidKillSettings.CharConn:Disconnect()
            MainModule.VoidKillSettings.CharConn = nil
        end
        if MainModule.VoidKillSettings.Platform then
            MainModule.VoidKillSettings.Platform:Destroy()
            MainModule.VoidKillSettings.Platform = nil
        end
        if MainModule.VoidKillSettings.BackupPlatform then
            MainModule.VoidKillSettings.BackupPlatform:Destroy()
            MainModule.VoidKillSettings.BackupPlatform = nil
        end
        PlayToggleSound()
        return true
    end

    MainModule.VoidKillSettings.Enabled = enabled

    local function setup(char)
        local h = char:FindFirstChildOfClass("Humanoid")
        if not h then return end

        MainModule.VoidKillSettings.Conn = h.AnimationPlayed:Connect(function(track)
            if not MainModule.VoidKillSettings.Enabled then return end

            if track.Animation and table.find(MainModule.VoidAnimIds, track.Animation.AnimationId) then
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end

                local currentStartPos = rootPart.CFrame

                local randomAngle = math.random() * math.pi * 2
                local randomRadius = 63
                local offsetX = math.cos(randomAngle) * randomRadius
                local offsetZ = math.sin(randomAngle) * randomRadius

                local teleportPos = currentStartPos.Position + Vector3.new(offsetX, 0, offsetZ)
                local teleportCFrame = CFrame.new(teleportPos + Vector3.new(0, 0.5, 0))

                if MainModule.VoidKillSettings.Platform then
                    MainModule.VoidKillSettings.Platform:Destroy()
                end
                if MainModule.VoidKillSettings.BackupPlatform then
                    MainModule.VoidKillSettings.BackupPlatform:Destroy()
                end

                local platform = Instance.new("Part")
                platform.Name = HttpService:GenerateGUID(false)
                platform.Size = Vector3.new(240, 3, 240)
                platform.Material = Enum.Material.Plastic
                platform.Position = teleportPos + Vector3.new(0, -3, 0)
                platform.Anchored = true
                platform.CanCollide = true
                platform.Transparency = 0.5
                platform.Parent = workspace

                local backupPlatform = Instance.new("Part")
                backupPlatform.Name = HttpService:GenerateGUID(false)
                backupPlatform.Size = Vector3.new(240, 2, 240)
                backupPlatform.Position = teleportPos + Vector3.new(0, -7, 0)
                backupPlatform.Anchored = true
                backupPlatform.CanCollide = true
                backupPlatform.Transparency = 1
                backupPlatform.Parent = workspace

                MainModule.VoidKillSettings.Platform = platform
                MainModule.VoidKillSettings.BackupPlatform = backupPlatform

                rootPart.CFrame = teleportCFrame
                if char.PrimaryPart then
                    char:SetPrimaryPartCFrame(teleportCFrame)
                end

                local stopConn
                stopConn = track.Stopped:Connect(function()
                    task.wait(1.5)
                    if char and char.Parent and MainModule.VoidKillSettings.Enabled then
                        local returnRoot = char:FindFirstChild("HumanoidRootPart")
                        if returnRoot then
                            returnRoot.CFrame = currentStartPos
                            if char.PrimaryPart then
                                char:SetPrimaryPartCFrame(currentStartPos)
                            end
                        end
                    end
                    task.wait(1.5)
                    if platform then
                        platform:Destroy()
                    end
                    if backupPlatform then
                        backupPlatform:Destroy()
                    end
                    MainModule.VoidKillSettings.Platform = nil
                    MainModule.VoidKillSettings.BackupPlatform = nil
                    if stopConn then stopConn:Disconnect() end
                end)
            end
        end)
    end

    if LocalPlayer.Character then
        setup(LocalPlayer.Character)
    end

    MainModule.VoidKillSettings.CharConn = LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        if MainModule.VoidKillSettings.Enabled then
            setup(char)
        end
    end)

    PlayToggleSound()
    return true
end

MainModule.AutoSkipEnabled = false
MainModule.AutoSkipLoop = nil

MainModule.toggle_auto_skip = function(enabled)
    MainModule.AutoSkipEnabled = enabled

    if MainModule.AutoSkipLoop then
        task.cancel(MainModule.AutoSkipLoop)
        MainModule.AutoSkipLoop = nil
    end

    if enabled then
        MainModule.AutoSkipLoop = task.spawn(function()
            while MainModule.AutoSkipEnabled do
                pcall(function()
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    if remotes then
                        local dialogueRemote = remotes:FindFirstChild("DialogueRemote")
                        if dialogueRemote then
                            dialogueRemote:FireServer("Skipped")
                        end
                        local reachableBindable = remotes:FindFirstChild("TemporaryReachedBindable")
                        if reachableBindable then
                            reachableBindable:FireServer()
                        end
                    end
                end)
                task.wait(0.8)
            end
        end)
    else
    end
    PlayToggleSound()
end

function MainModule.AntiCrack()
    local effectsWorkspace = workspace:FindFirstChild("Effects")
    if effectsWorkspace then
        for _, outline in ipairs(effectsWorkspace:GetChildren()) do
            if outline.Name and outline.Name:find("Outline") then
                for _, part in ipairs(outline:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "DalgonaClickPart" then
                        pcall(function()
                            local clickPart = part:Clone()
                            clickPart.Name = "DalgonaClickPart"
                            clickPart.Parent = part.Parent
                            clickPart.Size = Vector3.new(1, 1, 1)
                            clickPart.Transparency = 1
                            clickPart.CanCollide = false
                            clickPart.Anchored = true
                            clickPart.Position = part.Position
                        end)
                    end
                end
            end
        end
    end
end
MainModule.anti_crack = MainModule.AntiCrack
MainModule.toggle_anti_crack = function()
    MainModule.AntiCrack()
    PlayToggleSound()
    return true
end


loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
--@encrypt_start
loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
MainModule.AutoDalgonaEnabled = false
MainModule.AutoDalgonaConnections = {}
MainModule.AutoDalgonaTasks = {}
MainModule._DalgonaProgressHooked = false

local function killCracks()
    local effects = workspace:FindFirstChild("Effects")
    if not effects then return end
    for _, obj in ipairs(effects:GetChildren()) do
        if obj.Name and (
            obj.Name:find("Crack")
            or obj.Name:find("Shattered")
            or obj.Name:find("Fragment")
        ) then
            pcall(function() obj:Destroy() end)
        end
    end
end

local function blockNewCracks()
    local effects = workspace:FindFirstChild("Effects")
    if not effects then return end
    local connection = effects.ChildAdded:Connect(function(child)
        if child.Name and (
            child.Name:find("Crack")
            or child.Name:find("Shattered")
            or child.Name:find("Fragment")
        ) then
            pcall(function() child:Destroy() end)
        end
    end)
    table.insert(MainModule.AutoDalgonaConnections, connection)
end

local function forceDalgonaProgress100()
    if not getgc or not debug then return false end
    local getups = debug.getupvalues or debug.get_upvalues
    local setup = debug.setupvalue or debug.setup_value
    local getconsts = debug.getconstants or debug.get_constants
    if not getups or not setup then return false end

    local patched = false
    local list = getgc()
    for _, fn in ipairs(list) do
        if type(fn) == "function" then
            local consts = nil
            if getconsts then
                local okc, cs = pcall(getconsts, fn)
                if okc then consts = cs end
            end
            local hasCompleted = false
            local hasProgress = false
            if type(consts) == "table" then
                for _, const in pairs(consts) do
                    if const == "Completed" then hasCompleted = true end
                    if type(const) == "string" and (const == "Progress" or const:find("%%", 1, true)) then
                        hasProgress = true
                    end
                end
            end
            if hasCompleted or hasProgress then
                local oku, ups = pcall(getups, fn)
                if oku and type(ups) == "table" then
                    for i, u in pairs(ups) do
                        if type(u) == "number" and u == u and u >= 0 and u < 50000 then
                            local oks = pcall(setup, fn, i, 100000)
                            if oks then patched = true end
                        end
                    end
                end
            end
        end
    end

    pcall(function()
        local effects = workspace:FindFirstChild("Effects")
        if not effects then return end
        for _, outline in ipairs(effects:GetChildren()) do
            if outline.Name and outline.Name:find("Outline") then
                for _, part in ipairs(outline:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part:SetAttribute("Done", true)
                    end
                end
            end
        end
    end)

    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local remote = remotes and remotes:FindFirstChild("DALGONATEMPREMPTE")
        if remote then
            remote:FireServer({ Completed = true })
            remote:FireServer({ Success = true })
        end
    end)

    return patched
end

function MainModule.start_auto_dalgona()
    if MainModule.AutoDalgonaEnabled then return end

    if not MainModule.is_game_active or not MainModule.is_game_active("Dalgona") then
    end

    MainModule.AutoDalgonaEnabled = true
    blockNewCracks()

    local okPatch = false
    pcall(function()
        okPatch = forceDalgonaProgress100()
    end)

    local taskId = task.spawn(function()
        local n = 0
        while MainModule.AutoDalgonaEnabled do
            pcall(forceDalgonaProgress100)
            pcall(killCracks)
            n += 1
            if n >= 8 then
                break 
            end
            task.wait(0.25)
        end
        while MainModule.AutoDalgonaEnabled do
            pcall(killCracks)
            task.wait(0.5)
        end
    end)
    table.insert(MainModule.AutoDalgonaTasks, taskId)

    PlayToggleSound()
    MainModule.notify("Auto Dalgona", okPatch and "Progress forced 100%" or "Tried force complete", 0.9)
    return true
end

function MainModule.stop_auto_dalgona()
    if not MainModule.AutoDalgonaEnabled then return end
    MainModule.AutoDalgonaEnabled = false

    for _, connection in ipairs(MainModule.AutoDalgonaConnections) do
        if connection and connection.Disconnect then
            pcall(function() connection:Disconnect() end)
        end
    end
    MainModule.AutoDalgonaConnections = {}

    for _, taskId in ipairs(MainModule.AutoDalgonaTasks) do
        pcall(function() task.cancel(taskId) end)
    end
    MainModule.AutoDalgonaTasks = {}

    PlayToggleSound()
end

function MainModule.toggle_auto_dalgona(enabled)
    if enabled then
        if MainModule.is_game_active and not MainModule.is_game_active("Dalgona") then
            HSXNotify("Auto Dalgona", "Wait for Dalgona!", 0.9)
            PlayErrorSound()
            if MainModule.ToggleRefs.AutoDalgona and MainModule.ToggleRefs.AutoDalgona.SetValue then
                pcall(function() MainModule.ToggleRefs.AutoDalgona:SetValue(false) end)
            end
            return false
        end
        return MainModule.start_auto_dalgona()
    else
        MainModule.stop_auto_dalgona()
        return true
    end
end



--@encrypt_end
MainModule.HideNicknameEnabled = false
MainModule.HideAllNicknamesEnabled = false
MainModule.HideNicknameConnection = nil
MainModule.HideAllNicknamesConnection = nil

local function getOwnNametag()
    local live = workspace:FindFirstChild("Live")
    if not live then return nil end
    local folder = live:FindFirstChild(LocalPlayer.Name)
    if not folder then return nil end
    local torso = folder:FindFirstChild("Torso")
    if not torso then return nil end
    return torso:FindFirstChild("Player_Nametag")
end

local function hideOwnNickname()
    local nametag = getOwnNametag()
    if nametag then
        pcall(function()
            nametag.Enabled = false
            if nametag:IsA("BillboardGui") or nametag:IsA("SurfaceGui") then
                nametag.Enabled = false
            end
            for _, child in ipairs(nametag:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                    child.Visible = false
                end
            end
        end)
    end
end

local function showOwnNickname()
    local nametag = getOwnNametag()
    if nametag then
        pcall(function()
            nametag.Enabled = true
            for _, child in ipairs(nametag:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                    child.Visible = true
                end
            end
        end)
    end
end

local function hideAllNicknames()
    local live = workspace:FindFirstChild("Live")
    if not live then return end

    for _, folder in ipairs(live:GetChildren()) do
        local torso = folder:FindFirstChild("Torso")
        if torso then
            local nametag = torso:FindFirstChild("Player_Nametag")
            if nametag then
                pcall(function()
                    nametag.Enabled = false
                    for _, child in ipairs(nametag:GetDescendants()) do
                        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                            child.Visible = false
                        end
                    end
                end)
            end
        end
    end
end

local function showAllNicknames()
    local live = workspace:FindFirstChild("Live")
    if not live then return end

    for _, folder in ipairs(live:GetChildren()) do
        local torso = folder:FindFirstChild("Torso")
        if torso then
            local nametag = torso:FindFirstChild("Player_Nametag")
            if nametag then
                pcall(function()
                    nametag.Enabled = true
                    for _, child in ipairs(nametag:GetDescendants()) do
                        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                            child.Visible = true
                        end
                    end
                end)
            end
        end
    end
end

function MainModule.toggle_hide_nickname(enabled)
    MainModule.HideNicknameEnabled = enabled

    if MainModule.HideNicknameConnection then
        MainModule.HideNicknameConnection:Disconnect()
        MainModule.HideNicknameConnection = nil
    end

    if enabled then
        hideOwnNickname()
        MainModule.HideNicknameConnection = RunService.Heartbeat:Connect(function()
            if MainModule.HideNicknameEnabled then
                hideOwnNickname()
            end
        end)
    else
        showOwnNickname()
    end

    PlayToggleSound()
end

function MainModule.toggle_hide_all_nicknames(enabled)
    MainModule.HideAllNicknamesEnabled = enabled

    if MainModule.HideAllNicknamesConnection then
        MainModule.HideAllNicknamesConnection:Disconnect()
        MainModule.HideAllNicknamesConnection = nil
    end

    if enabled then
        hideAllNicknames()
        MainModule.HideAllNicknamesConnection = RunService.Heartbeat:Connect(function()
            if MainModule.HideAllNicknamesEnabled then
                hideAllNicknames()
            end
        end)
    else
        showAllNicknames()
    end

    PlayToggleSound()
end

MainModule.CustomGravityEnabled = false
MainModule.CustomGravityValue = 196.2
MainModule.CustomGravityConnection = nil

MainModule.toggle_custom_gravity = function(enabled)
    MainModule.CustomGravityEnabled = enabled

    if MainModule.CustomGravityConnection then
        MainModule.CustomGravityConnection:Disconnect()
        MainModule.CustomGravityConnection = nil
    end

    if enabled then
        Workspace.Gravity = MainModule.CustomGravityValue
        MainModule.CustomGravityConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomGravityEnabled then
                Workspace.Gravity = MainModule.CustomGravityValue
            end
        end)
    else
        Workspace.Gravity = 196.2
    end
    PlayToggleSound()
end

MainModule.set_custom_gravity = function(value)
    local num = tonumber(value)
    if num and num >= 50 and num <= 500 then
        MainModule.CustomGravityValue = num
        if MainModule.CustomGravityEnabled then
            Workspace.Gravity = MainModule.CustomGravityValue
        end
    else
        MainModule.notify("Custom Gravity", "Invalid number (50-500)", 0.9)
        PlayErrorSound()
    end
end

MainModule.CustomJumpPowerEnabled = false
MainModule.CustomJumpPowerValue = 50
MainModule.CustomJumpPowerConnection = nil

MainModule.toggle_custom_jump_power = function(enabled)
    MainModule.CustomJumpPowerEnabled = enabled

    if MainModule.CustomJumpPowerConnection then
        MainModule.CustomJumpPowerConnection:Disconnect()
        MainModule.CustomJumpPowerConnection = nil
    end

    if enabled then
        local char = MainModule.get_character()
        if char then
            local hum = MainModule.get_humanoid(char)
            if hum then
                MainModule.OriginalJumpPower = hum.JumpPower
                hum.JumpPower = MainModule.CustomJumpPowerValue
            end
        end
        MainModule.CustomJumpPowerConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomJumpPowerEnabled then
                local c = MainModule.get_character()
                if c then
                    local h = MainModule.get_humanoid(c)
                    if h and h.JumpPower ~= MainModule.CustomJumpPowerValue then
                        h.JumpPower = MainModule.CustomJumpPowerValue
                    end
                end
            end
        end)
    else
        local char = MainModule.get_character()
        if char then
            local hum = MainModule.get_humanoid(char)
            if hum then
                hum.JumpPower = MainModule.OriginalJumpPower or 50
            end
        end
    end
    PlayToggleSound()
end

MainModule.set_custom_jump_power = function(value)
    local num = tonumber(value)
    if num and num >= 20 and num <= 200 then
        MainModule.CustomJumpPowerValue = num
        if MainModule.CustomJumpPowerEnabled then
            local char = MainModule.get_character()
            if char then
                local hum = MainModule.get_humanoid(char)
                if hum then
                    hum.JumpPower = MainModule.CustomJumpPowerValue
                end
            end
        end
    else
        MainModule.notify("Custom Jump Power", "Invalid number (20-200)", 0.9)
        PlayErrorSound()
    end
end

MainModule.CustomGravityEnabled = false
MainModule.CustomGravityValue = 196.2
MainModule.CustomGravityConnection = nil

MainModule.toggle_custom_gravity = function(enabled)
    MainModule.CustomGravityEnabled = enabled

    if MainModule.CustomGravityConnection then
        MainModule.CustomGravityConnection:Disconnect()
        MainModule.CustomGravityConnection = nil
    end

    if enabled then
        Workspace.Gravity = MainModule.CustomGravityValue
        MainModule.CustomGravityConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomGravityEnabled then
                Workspace.Gravity = MainModule.CustomGravityValue
            end
        end)
    else
        Workspace.Gravity = 196.2
    end
    PlayToggleSound()
end

MainModule.set_custom_gravity = function(value)
    local num = tonumber(value)
    if num and num >= 50 and num <= 500 then
        MainModule.CustomGravityValue = num
        if MainModule.CustomGravityEnabled then
            Workspace.Gravity = MainModule.CustomGravityValue
        end
    else
        MainModule.notify("Custom Gravity", "Invalid number (50-500)", 0.9)
        PlayErrorSound()
    end
end

MainModule.CustomJumpPowerEnabled = false
MainModule.CustomJumpPowerValue = 50
MainModule.CustomJumpPowerConnection = nil

MainModule.toggle_custom_jump_power = function(enabled)
    MainModule.CustomJumpPowerEnabled = enabled

    if MainModule.CustomJumpPowerConnection then
        MainModule.CustomJumpPowerConnection:Disconnect()
        MainModule.CustomJumpPowerConnection = nil
    end

    if enabled then
        local char = MainModule.get_character()
        if char then
            local hum = MainModule.get_humanoid(char)
            if hum then
                MainModule.OriginalJumpPower = hum.JumpPower
                hum.JumpPower = MainModule.CustomJumpPowerValue
            end
        end
        MainModule.CustomJumpPowerConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomJumpPowerEnabled then
                local c = MainModule.get_character()
                if c then
                    local h = MainModule.get_humanoid(c)
                    if h and h.JumpPower ~= MainModule.CustomJumpPowerValue then
                        h.JumpPower = MainModule.CustomJumpPowerValue
                    end
                end
            end
        end)
    else
        local char = MainModule.get_character()
        if char then
            local hum = MainModule.get_humanoid(char)
            if hum then
                hum.JumpPower = MainModule.OriginalJumpPower or 50
            end
        end
    end
    PlayToggleSound()
end

MainModule.set_custom_jump_power = function(value)
    MainModule.CustomJumpPowerValue = value
    if MainModule.CustomJumpPowerEnabled then
        local char = MainModule.get_character()
        if char then
            local hum = MainModule.get_humanoid(char)
            if hum then
                hum.JumpPower = MainModule.CustomJumpPowerValue
            end
        end
    end
end

MainModule.CustomWinEnabled = false
MainModule.CustomWinValue = 67
MainModule.CustomWinConnection = nil

MainModule.toggle_custom_win = function(enabled)
    MainModule.CustomWinEnabled = enabled

    if MainModule.CustomWinConnection then
        MainModule.CustomWinConnection:Disconnect()
        MainModule.CustomWinConnection = nil
    end

    if enabled then
        LocalPlayer:SetAttribute("_GameWins", MainModule.CustomWinValue)
        MainModule.CustomWinConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomWinEnabled then
                LocalPlayer:SetAttribute("_GameWins", MainModule.CustomWinValue)
            end
        end)
    end
    PlayToggleSound()
end

MainModule.set_custom_win = function(value)
    local num = tonumber(value)
    if num and num >= 0 and num <= 999999 then
        MainModule.CustomWinValue = math.floor(num)
        if MainModule.CustomWinEnabled then
            LocalPlayer:SetAttribute("_GameWins", MainModule.CustomWinValue)
        end
    else
        MainModule.notify("Custom Win", "Invalid number", 0.9)
    end
end

MainModule.AutoVoteEnabled = false
MainModule.AutoVoteConnection = nil
MainModule.VoteOption = "KeepPlaying"

MainModule.toggle_auto_vote = function(enabled)
    MainModule.AutoVoteEnabled = enabled

    if MainModule.AutoVoteConnection then
        MainModule.AutoVoteConnection:Disconnect()
        MainModule.AutoVoteConnection = nil
    end

    if enabled then
        MainModule.AutoVoteConnection = RunService.Heartbeat:Connect(function()
            if MainModule.AutoVoteEnabled then
                pcall(function()
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    if remotes then
                        local voteRemote = remotes:FindFirstChild("ExtraTemporaryRemote")
                        if voteRemote then
                            voteRemote:FireServer({ Voting = MainModule.VoteOption })
                        end
                    end
                end)
            end
        end)
    end
    PlayToggleSound()
end

MainModule.set_vote_option = function(option)
    MainModule.VoteOption = option
end

MainModule.NoCooldownProximityEnabled = false
MainModule.ProximityConnection = nil

MainModule.toggle_no_cooldown_proximity = function(enabled)
    MainModule.NoCooldownProximityEnabled = enabled

    local function setProximityCooldown(instance)
        if instance:IsA("ProximityPrompt") then
            instance.HoldDuration = 0
        end
    end

    if enabled then
        for _, descendant in pairs(workspace:GetDescendants()) do
            setProximityCooldown(descendant)
        end

        MainModule.ProximityConnection = workspace.DescendantAdded:Connect(function(descendant)
            if MainModule.NoCooldownProximityEnabled then
                setProximityCooldown(descendant)
            end
        end)
    else
        if MainModule.ProximityConnection then
            MainModule.ProximityConnection:Disconnect()
            MainModule.ProximityConnection = nil
        end
    end
    PlayToggleSound()
end

MainModule.InfiniteJumpEnabled = false
MainModule.InfiniteJumpConnection = nil

MainModule.toggle_infinite_jump = function(enabled)
    MainModule.InfiniteJumpEnabled = enabled

    if MainModule.InfiniteJumpConnection then
        MainModule.InfiniteJumpConnection:Disconnect()
        MainModule.InfiniteJumpConnection = nil
    end

    if enabled then
        MainModule.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if MainModule.InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
    PlayToggleSound()
end


loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
--@encrypt_start
loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
MainModule.dalgona_complete_shape = function()
    if MainModule.is_game_active and not MainModule.is_game_active("Dalgona") then
        MainModule.notify("Dalgona", "Wait for Dalgona!", 0.9)
        if PlayErrorSound then PlayErrorSound() end
        return false
    end

    local getupvalues = (debug and (debug.getupvalues or debug.get_upvalues)) or getupvalues
    local setupvalue = (debug and (debug.setupvalue or debug.setup_value)) or setupvalue
    local getconstants = (debug and (debug.getconstants or debug.get_constants)) or getconstants

    local function forceProgress100()
        if not getgc or not getupvalues or not setupvalue then
            return false
        end

        local patched = false
        local list = getgc()
        if type(list) ~= "table" then return false end

        for _, fn in ipairs(list) do
            if type(fn) == "function" then
                local consts = nil
                if getconstants then
                    local ok, cs = pcall(getconstants, fn)
                    if ok then consts = cs end
                end

                local useful = false
                if type(consts) == "table" then
                    for _, c in pairs(consts) do
                        if c == "Progress" or c == "Completed" then
                            useful = true
                            break
                        end
                        if type(c) == "string" and c:find("%%", 1, true) then
                            useful = true
                            break
                        end
                    end
                end

                if useful then
                    local ok, ups = pcall(getupvalues, fn)
                    if ok and type(ups) == "table" then
                        for i, u in pairs(ups) do
                            if type(u) == "number" and u == u and u >= 0 and u < 5000 then
                                if pcall(setupvalue, fn, i, 100000) then
                                    patched = true
                                end
                            end
                        end
                    end
                end
            end
        end
        return patched
    end

    task.spawn(function()
        local ok = false
        for _ = 1, 10 do
            if forceProgress100() then ok = true end
            task.wait(0.15)
        end
        if ok then
            HSXNotify("Dalgona", "Dalgona Completed", 0.9)
        else
            HSXNotify("Dalgona", "Failed (no hooks?)", 0.9)
        end
    end)

    return true
end



--@encrypt_end
MainModule.Rebel = {
    Enabled = false,
    Connection = nil,
    LastCheckTime = 0,
    LastKillTime = 0,
    CheckCooldown = 0.1,
    KillCooldown = 0.05
}


MainModule.toggle_rebel = function(enabled)
    MainModule.Rebel.Enabled = enabled
    if MainModule.Rebel.Connection then
        MainModule.Rebel.Connection:Disconnect()
        MainModule.Rebel.Connection = nil
    end
    if enabled then
        MainModule.Rebel.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.Rebel.Enabled then return end
            local currentTime = tick()
            if currentTime - MainModule.Rebel.LastCheckTime < MainModule.Rebel.CheckCooldown then return end
            MainModule.Rebel.LastCheckTime = currentTime

            local enemyNames = {}
            if workspace:FindFirstChild("Live") then
                for _, enemy in pairs(workspace.Live:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("Enemy") and not enemy:FindFirstChild("Dead") then
                        local isPlayer = false
                        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                            if player.Name == enemy.Name then
                                isPlayer = true
                                break
                            end
                        end
                        if not isPlayer then
                            table.insert(enemyNames, enemy.Name)
                        end
                    end
                end
            end

            if #enemyNames == 0 then return end

            for _, enemyName in pairs(enemyNames) do
                if currentTime - MainModule.Rebel.LastKillTime < MainModule.Rebel.KillCooldown then
                    task.wait(MainModule.Rebel.KillCooldown - (currentTime - MainModule.Rebel.LastKillTime))
                end

                local character = game:GetService("Players").LocalPlayer.Character
                local backpack = game:GetService("Players").LocalPlayer.Backpack
                local gun = nil

                if character then
                    for _, tool in pairs(character:GetChildren()) do
                        if tool:IsA("Tool") and tool:GetAttribute("Gun") then
                            gun = tool
                            break
                        end
                    end
                end

                if not gun and backpack then
                    for _, tool in pairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool:GetAttribute("Gun") then
                            gun = tool
                            break
                        end
                    end
                end

                if gun then
                    local args = {
                        gun,
                        {
                            ClientRayNormal = Vector3.new(-1.1920928955078125e-7, 1.0000001192092896, 0),
                            FiredGun = true,
                            SecondaryHitTargets = {},
                            ClientRayInstance = workspace:WaitForChild("StairWalkWay"):WaitForChild("Part"),
                            ClientRayPosition = Vector3.new(-220.17489624023438, 183.2957763671875, 301.07257080078125),
                            bulletCF = CFrame.new(-220.5039825439453, 185.22506713867188, 302.133544921875, 0.9551116228103638, 0.2567310333251953, -0.14782091975212097, 7.450581485102248e-9, 0.4989798665046692, 0.8666135668754578, 0.2962462604045868, -0.8277127146720886, 0.4765814542770386),
                            HitTargets = {
                                [enemyName] = "Head"
                            },
                            bulletSizeC = Vector3.new(0.009999999776482582, 0.009999999776482582, 4.452499866485596),
                            NoMuzzleFX = false,
                            FirePosition = Vector3.new(-72.88850402832031, -679.4803466796875, -173.31005859375)
                        }
                    }

                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FiredGunClient"):FireServer(unpack(args))
                    end)

                    MainModule.Rebel.LastKillTime = tick()
                    task.wait(0.05)
                end
            end
        end)
    else
        MainModule.Rebel.LastKillTime = 0
        MainModule.Rebel.LastCheckTime = 0
    end
    PlayToggleSound()
end

MainModule.ParkourArtistEnabled = false
MainModule.ParkourArtistConnection = nil
MainModule.OriginalPower = nil
MainModule.ParkourArtistState = nil
MainModule.ParkourArtistConns = {}

MainModule.unlock_parkour_artist = function()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local animations = replicatedStorage:FindFirstChild("Animations")
    local abilities = animations and animations:FindFirstChild("Abilities")
    local parkourArtist = abilities and abilities:FindFirstChild("ParkourArtist")
    if parkourArtist then
        if parkourArtist:IsA("BoolValue") then
            parkourArtist.Value = true
        elseif parkourArtist:IsA("NumberValue") or parkourArtist:IsA("IntValue") then
            parkourArtist.Value = 1
        end
        for _, descendant in pairs(parkourArtist:GetDescendants()) do
            if descendant:IsA("BoolValue") then
                descendant.Value = true
            elseif descendant:IsA("NumberValue") or descendant:IsA("IntValue") then
                descendant.Value = 1
            end
        end
    end
    LocalPlayer:SetAttribute("__OwnsParkourArtist", true)
    LocalPlayer:SetAttribute("HasParkourArtist", true)
    LocalPlayer:SetAttribute("UnlockedParkourArtist", true)
end

MainModule._ParkourCleanup = function()
    for _, c in ipairs(MainModule.ParkourArtistConns) do
        pcall(function() c:Disconnect() end)
    end
    MainModule.ParkourArtistConns = {}
    if MainModule.ParkourArtistConnection then
        pcall(function() MainModule.ParkourArtistConnection:Disconnect() end)
        MainModule.ParkourArtistConnection = nil
    end
    MainModule.ParkourArtistState = nil
end

MainModule._ParkourStartMechanics = function()
    MainModule._ParkourCleanup()
    local DOUBLE_JUMP_BOOST = 75
    local DOUBLE_JUMP_SOUND = "rbxassetid://10753621125"
    local C_KEY = Enum.KeyCode.C
    local DASH_SPEED = 95
    local DASH_DURATION = 0.28
    local DASH_COOLDOWN = 0.65
    local DASH_SLOWDOWN_TIME = 0.18
    local Debris = game:GetService("Debris")

    local function getAnimFolder()
        local ok, result = pcall(function()
            return ReplicatedStorage:WaitForChild("Animations", 5)
                :WaitForChild("Abilities", 5)
                :WaitForChild("ParkourArtist", 5)
        end)
        if ok then return result end
        return nil
    end

    local function getAnimations()
        local folder = getAnimFolder()
        if not folder then return {} end
        local list = {}
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("Animation") and obj.AnimationId ~= "" then
                table.insert(list, obj)
            end
        end
        return list
    end

    local EffectFolder = nil
    local function findEffectFolder()
        local names = {
            "PARKOURARTIST", "ParkourArtist", "PARKOUR_ARTIST",
            "Parkour", "PARKOUR", "ParkourArtistEffects", "ParkourEffects"
        }
        local paths = {
            function() return ReplicatedStorage.Effects.SetupParts.CustomEffectsFolders end,
            function() return ReplicatedStorage.Effects.Parts end,
            function() return ReplicatedStorage.Effects end,
        }
        for _, getParent in ipairs(paths) do
            local ok, parent = pcall(getParent)
            if ok and parent then
                for _, name in ipairs(names) do
                    local folder = parent:FindFirstChild(name)
                    if folder then return folder end
                end
            end
        end
        return nil
    end
    EffectFolder = findEffectFolder()

    local state = {
        JumpCount = 0,
        CanDoubleJump = false,
        HasLeftGround = false,
        DoubleJumpTrack = nil,
        CKeyTrack = nil,
        DoubleJumpAnim = nil,
        CKeyAnim = nil,
        DashCooldown = false,
        IsDashing = false,
        LastCPress = 0,
    }
    MainModule.ParkourArtistState = state

    local function getChar()
        return LocalPlayer.Character
    end
    local function getHumanoid()
        local c = getChar()
        return c and c:FindFirstChildOfClass("Humanoid")
    end
    local function getHRP()
        local c = getChar()
        return c and c:FindFirstChild("HumanoidRootPart")
    end
    local function getAnimator()
        local hum = getHumanoid()
        if not hum then return nil end
        local a = hum:FindFirstChildOfClass("Animator")
        if not a then
            a = Instance.new("Animator")
            a.Parent = hum
        end
        return a
    end

    local function assignAnimations()
        local anims = getAnimations()
        if #anims == 0 then
            HSXNotify("Parkour Artist", "No animations found", 1)
            return
        end
        if #anims == 1 then
            state.DoubleJumpAnim = anims[1]
            state.CKeyAnim = anims[1]
        else
            state.DoubleJumpAnim = anims[1]
            state.CKeyAnim = anims[2]
        end
        HSXNotify("Parkour Artist", "DoubleJump: " .. tostring(state.DoubleJumpAnim.Name) .. " | C: " .. tostring(state.CKeyAnim.Name), 1.2)
    end

    local function playAnim(anim, trackKey)
        if not anim then return nil end
        if state[trackKey] then
            pcall(function()
                state[trackKey]:Stop(0.08)
                state[trackKey]:Destroy()
            end)
            state[trackKey] = nil
        end
        local animator = getAnimator()
        if not animator then return nil end
        local ok, track = pcall(function()
            return animator:LoadAnimation(anim)
        end)
        if ok and track then
            state[trackKey] = track
            track.Priority = Enum.AnimationPriority.Action4
            track.Looped = false
            pcall(function() track:Play(0.05, 1, 1) end)
            track.Stopped:Once(function()
                if state[trackKey] == track then
                    pcall(function() track:Destroy() end)
                    state[trackKey] = nil
                end
            end)
            return track
        end
        return nil
    end

    local function createFallbackEffect(hrp, isDash)
        local sound = Instance.new("Sound")
        sound.SoundId = isDash and "rbxassetid://9125411438" or DOUBLE_JUMP_SOUND
        sound.Volume = isDash and 0.9 or 1
        sound.PlaybackSpeed = isDash and 1.15 or 1
        sound.Parent = hrp
        sound:Play()
        Debris:AddItem(sound, 3)
        local att = Instance.new("Attachment")
        att.Parent = hrp
        local pe = Instance.new("ParticleEmitter")
        pe.Texture = "rbxassetid://241650934"
        pe.Rate = 0
        pe.Lifetime = NumberRange.new(0.25, 0.45)
        pe.Speed = NumberRange.new(6, 14)
        pe.SpreadAngle = Vector2.new(40, 40)
        pe.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(1, 0)
        })
        pe.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
        pe.Color = ColorSequence.new(Color3.fromRGB(180, 220, 255))
        pe.LightEmission = 0.4
        pe.Parent = att
        pe:Emit(isDash and 18 or 12)
        Debris:AddItem(att, 1.5)
    end

    local function playEffects(isDash)
        local char = getChar()
        local hrp = getHRP()
        if not char or not hrp then return end
        local playedSomething = false
        if EffectFolder then
            for _, obj in EffectFolder:GetDescendants() do
                if obj:IsA("Sound") then
                    local snd = obj:Clone()
                    snd.Parent = hrp
                    snd:Play()
                    snd.Ended:Once(function()
                        if snd then snd:Destroy() end
                    end)
                    Debris:AddItem(snd, 8)
                    playedSomething = true
                end
            end
            local bodyParts = {}
            for _, n in pairs({
                "Head", "Torso", "UpperTorso", "LowerTorso",
                "Left Arm", "Right Arm", "Left Leg", "Right Leg",
                "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
                "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
                "LeftHand", "RightHand", "LeftFoot", "RightFoot", "HumanoidRootPart"
            }) do
                local pp = char:FindFirstChild(n)
                if pp and pp:IsA("BasePart") then
                    table.insert(bodyParts, pp)
                end
            end
            for _, obj in EffectFolder:GetDescendants() do
                if obj:IsA("ParticleEmitter") then
                    for _, limb in pairs(bodyParts) do
                        local clone = obj:Clone()
                        clone.Enabled = false
                        clone.Parent = limb
                        clone:Emit(clone:GetAttribute("EmitCount") or 8)
                        Debris:AddItem(clone, 2.5)
                        playedSomething = true
                    end
                end
            end
        end
        if not playedSomething then
            createFallbackEffect(hrp, isDash)
        end
    end

    local function doDoubleJump()
        local hrp = getHRP()
        if not hrp then return end
        local cv = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(cv.X, DOUBLE_JUMP_BOOST, cv.Z)
        local sound = Instance.new("Sound")
        sound.SoundId = DOUBLE_JUMP_SOUND
        sound.Volume = 1
        sound.PlaybackSpeed = 1
        sound.Parent = hrp
        sound:Play()
        Debris:AddItem(sound, 3)
        playAnim(state.DoubleJumpAnim, "DoubleJumpTrack")
        playEffects(false)
    end

    local function doDash()
        if state.DashCooldown or state.IsDashing then return end
        if tick() - state.LastCPress < 0.28 then return end
        state.LastCPress = tick()
        local char = getChar()
        local hum = getHumanoid()
        local hrp = getHRP()
        if not char or not hum or not hrp then return end
        state.DashCooldown = true
        state.IsDashing = true
        local look = hrp.CFrame.LookVector
        local dir = Vector3.new(look.X, 0, look.Z)
        if dir.Magnitude < 0.05 then
            state.IsDashing = false
            task.delay(DASH_COOLDOWN, function() state.DashCooldown = false end)
            return
        end
        dir = dir.Unit
        playAnim(state.CKeyAnim, "CKeyTrack")
        playEffects(true)
        local startTime = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not MainModule.ParkourArtistEnabled then
                if conn then conn:Disconnect() end
                state.IsDashing = false
                return
            end
            if not hrp or not hrp.Parent then
                if conn then conn:Disconnect() end
                state.IsDashing = false
                return
            end
            local elapsed = tick() - startTime
            if elapsed >= DASH_DURATION + DASH_SLOWDOWN_TIME then
                if conn then conn:Disconnect() end
                state.IsDashing = false
                return
            end
            if elapsed < DASH_DURATION then
                local currentY = hrp.AssemblyLinearVelocity.Y
                hrp.AssemblyLinearVelocity = Vector3.new(dir.X * DASH_SPEED, currentY, dir.Z * DASH_SPEED)
            else
                local alpha = math.clamp((elapsed - DASH_DURATION) / DASH_SLOWDOWN_TIME, 0, 1)
                local speed = DASH_SPEED * (1 - alpha)
                local currentY = hrp.AssemblyLinearVelocity.Y
                hrp.AssemblyLinearVelocity = Vector3.new(dir.X * speed, currentY, dir.Z * speed)
            end
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {char}
            rayParams.IgnoreWater = true
            local hit = workspace:Raycast(hrp.Position, dir * 3.5, rayParams)
            if hit then
                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                if conn then conn:Disconnect() end
                state.IsDashing = false
            end
        end)
        table.insert(MainModule.ParkourArtistConns, conn)
        task.delay(DASH_COOLDOWN, function() state.DashCooldown = false end)
    end

    local function setupLandReset(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoid then return end
        local c = humanoid.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Landed
                or newState == Enum.HumanoidStateType.Running
                or newState == Enum.HumanoidStateType.RunningNoPhysics then
                state.JumpCount = 0
                state.CanDoubleJump = false
                state.HasLeftGround = false
            end
        end)
        table.insert(MainModule.ParkourArtistConns, c)
    end

    local jumpConn = UserInputService.JumpRequest:Connect(function()
        if not MainModule.ParkourArtistEnabled then return end
        local humanoid = getHumanoid()
        local hrp = getHRP()
        if not humanoid or not hrp then return end
        local hstate = humanoid:GetState()
        if hstate == Enum.HumanoidStateType.Running
            or hstate == Enum.HumanoidStateType.RunningNoPhysics
            or hstate == Enum.HumanoidStateType.Landed
            or humanoid.FloorMaterial ~= Enum.Material.Air then
            state.JumpCount = 1
            state.CanDoubleJump = false
            state.HasLeftGround = false
            task.spawn(function()
                local start = tick()
                while tick() - start < 0.35 do
                    if not humanoid or not humanoid.Parent then return end
                    if humanoid.FloorMaterial == Enum.Material.Air
                        or humanoid:GetState() == Enum.HumanoidStateType.Jumping
                        or humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                        state.HasLeftGround = true
                        state.CanDoubleJump = true
                        return
                    end
                    task.wait()
                end
            end)
        elseif state.CanDoubleJump
            and state.HasLeftGround
            and state.JumpCount == 1
            and (hstate == Enum.HumanoidStateType.Freefall
                or hstate == Enum.HumanoidStateType.Jumping
                or humanoid.FloorMaterial == Enum.Material.Air) then
            state.JumpCount = 2
            state.CanDoubleJump = false
            doDoubleJump()
        end
    end)
    table.insert(MainModule.ParkourArtistConns, jumpConn)

    local inputConn = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if not MainModule.ParkourArtistEnabled then return end
        if input.KeyCode == C_KEY then
            doDash()
        end
    end)
    table.insert(MainModule.ParkourArtistConns, inputConn)

    assignAnimations()
    if LocalPlayer.Character then
        setupLandReset(LocalPlayer.Character)
    end
    local charConn = LocalPlayer.CharacterAdded:Connect(function(char)
        state.JumpCount = 0
        state.CanDoubleJump = false
        state.HasLeftGround = false
        state.DashCooldown = false
        state.IsDashing = false
        state.DoubleJumpTrack = nil
        state.CKeyTrack = nil
        task.wait(0.4)
        if MainModule.ParkourArtistEnabled then
            assignAnimations()
            setupLandReset(char)
        end
    end)
    table.insert(MainModule.ParkourArtistConns, charConn)
end

MainModule.toggle_parkour_artist = function(enabled)
    if enabled then
        if not MainModule.OriginalPower then
            MainModule.OriginalPower = LocalPlayer:GetAttribute("_EquippedPower") or ""
        end
        MainModule.unlock_parkour_artist()
        LocalPlayer:SetAttribute("_EquippedPower", "PARKOUR ARTIST")
        if MainModule.ParkourArtistConnection then
            MainModule.ParkourArtistConnection:Disconnect()
        end
        MainModule.ParkourArtistConnection = RunService.Heartbeat:Connect(function()
            if MainModule.ParkourArtistEnabled then
                LocalPlayer:SetAttribute("_EquippedPower", "PARKOUR ARTIST")
                LocalPlayer:SetAttribute("__OwnsParkourArtist", true)
                LocalPlayer:SetAttribute("HasParkourArtist", true)
            end
        end)
        MainModule.ParkourArtistEnabled = true
        MainModule._ParkourStartMechanics()
    else
        MainModule.ParkourArtistEnabled = false
        MainModule._ParkourCleanup()
        if MainModule.OriginalPower then
            LocalPlayer:SetAttribute("_EquippedPower", MainModule.OriginalPower)
        else
            LocalPlayer:SetAttribute("_EquippedPower", nil)
        end
    end
    PlayToggleSound()
end

MainModule.set_parkour_artist = function()
    MainModule.unlock_parkour_artist()
    PlayToggleSound()
end


MainModule.SpikesPlatformTeleport = {
    Enabled = false,
    Connection = nil,
    Platform = nil,
    OriginalCFrame = nil,
    SpikesPosition = nil
}

function MainModule.toggle_spikes_platform_teleport(enabled)
    if enabled and not MainModule.is_game_active("HideAndSeek") then
        MainModule.notify("Spikes Platform", "Wait for HideAndSeek", 0.9)
        PlayErrorSound()
        if MainModule.ToggleRefs.SpikesPlatformTeleport then
            MainModule.ToggleRefs.SpikesPlatformTeleport:SetValue(false)
        end
        return false
    end

    if MainModule.SpikesPlatformTeleport.Connection then
        MainModule.SpikesPlatformTeleport.Connection:Disconnect()
        MainModule.SpikesPlatformTeleport.Connection = nil
    end

    if MainModule.SpikesPlatformTeleport.Platform then
        pcall(function() MainModule.SpikesPlatformTeleport.Platform:Destroy() end)
        MainModule.SpikesPlatformTeleport.Platform = nil
    end

    MainModule.SpikesPlatformTeleport.Enabled = enabled
    MainModule.SpikesPlatformTeleport.OriginalCFrame = nil
    MainModule.SpikesPlatformTeleport.SpikesPosition = nil

    if not enabled then
        local character = MainModule.get_character()
        if character and MainModule.SpikesPlatformTeleport.OriginalCFrame then
            character:SetPrimaryPartCFrame(MainModule.SpikesPlatformTeleport.OriginalCFrame)
            HSXNotify({Title = "Spikes Platform", Description = "Returned", Duration = 0.9})
        end
        PlayToggleSound()
        return true
    end

    local spikesPosition = nil
    local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
    local killingParts = hideAndSeekMap and hideAndSeekMap:FindFirstChild("KillingParts")

    if killingParts then
        for _, spike in pairs(killingParts:GetChildren()) do
            if spike:IsA("BasePart") then
                spikesPosition = spike.Position
                break
            end
        end
    end

    if not spikesPosition then
        for _, spike in pairs(workspace:GetDescendants()) do
            if spike:IsA("BasePart") and spike.Name == "Spikes" then
                spikesPosition = spike.Position
                break
            end
        end
    end

    if not spikesPosition then
        MainModule.notify("TP To Spikes", "Spikes not found", 0.9)
        PlayErrorSound()
        if MainModule.ToggleRefs.SpikesPlatformTeleport then
            MainModule.ToggleRefs.SpikesPlatformTeleport:SetValue(false)
        end
        return false
    end

    MainModule.SpikesPlatformTeleport.SpikesPosition = spikesPosition

    local platform = Instance.new("Part")
    platform.Name = HttpService:GenerateGUID(false)
    platform.Size = Vector3.new(10, 1, 10)
    platform.Position = spikesPosition + Vector3.new(0, 10, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 0.5
    platform.Color = Color3.fromRGB(0, 255, 0)
    platform.Material = Enum.Material.Neon
    platform.Parent = workspace
    MainModule.SpikesPlatformTeleport.Platform = platform

    local character = MainModule.get_character()
    if character then
        local rootPart = MainModule.get_root_part(character)
        if rootPart then
            MainModule.SpikesPlatformTeleport.OriginalCFrame = character:GetPrimaryPartCFrame()
            local targetPosition = platform.Position + Vector3.new(0, 3, 0)
            rootPart.CFrame = CFrame.new(targetPosition)
            HSXNotify({Title = "Teleport to spikes", Description = "Teleported", Duration = 0.9})
        end
    end

    MainModule.SpikesPlatformTeleport.Connection = RunService.Heartbeat:Connect(function()
        if not MainModule.SpikesPlatformTeleport.Enabled then return end

        if not MainModule.is_game_active("HideAndSeek") then
            MainModule.toggle_spikes_platform_teleport(false)
            if MainModule.ToggleRefs.SpikesPlatformTeleport then
                MainModule.ToggleRefs.SpikesPlatformTeleport:SetValue(false)
            end
            return
        end

        if not MainModule.SpikesPlatformTeleport.Platform or not MainModule.SpikesPlatformTeleport.Platform.Parent then
            local newPlatform = Instance.new("Part")
            newPlatform.Name = HttpService:GenerateGUID(false)
            newPlatform.Size = Vector3.new(10, 1, 10)
            newPlatform.Position = MainModule.SpikesPlatformTeleport.SpikesPosition + Vector3.new(0, 10, 0)
            newPlatform.Anchored = true
            newPlatform.CanCollide = true
            newPlatform.Transparency = 0.5
            newPlatform.Color = Color3.fromRGB(0, 255, 0)
            newPlatform.Material = Enum.Material.Neon
            newPlatform.Parent = workspace
            MainModule.SpikesPlatformTeleport.Platform = newPlatform
        end

        local character = MainModule.get_character()
        if character then
            local rootPart = MainModule.get_root_part(character)
            if rootPart then
                local distance = (rootPart.Position - MainModule.SpikesPlatformTeleport.Platform.Position).Magnitude
                if distance > 15 then
                    if not MainModule.SpikesPlatformTeleport.OriginalCFrame then
                        MainModule.SpikesPlatformTeleport.OriginalCFrame = character:GetPrimaryPartCFrame()
                    end
                    local targetPosition = MainModule.SpikesPlatformTeleport.Platform.Position + Vector3.new(0, 3, 0)
                    rootPart.CFrame = CFrame.new(targetPosition)
                end
            end
        end
    end)

    PlayToggleSound()
    return true
end

MainModule.HCGlassESPEnabled = false
MainModule.HCGlassESPConnection = nil
MainModule.HCGlassESPObjects = {}

function MainModule.create_hc_glass_esp(tileModel, isBreakable)
    if MainModule.HCGlassESPObjects[tileModel] then return end

    local primaryPart = tileModel.PrimaryPart
    if not primaryPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = tileModel
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = isBreakable and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.3
    highlight.Parent = tileModel

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = primaryPart
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = primaryPart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = isBreakable and "BREAKABLE" or "SAFE"
    label.TextColor3 = isBreakable and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Parent = billboard

    MainModule.HCGlassESPObjects[tileModel] = {
        highlight = highlight,
        billboard = billboard,
        label = label,
        tile = tileModel
    }
end

function MainModule.scan_hc_glass_bridge()
    local glassHolder = workspace:FindFirstChild("GlassBridge") and workspace.GlassBridge:FindFirstChild("GlassHolder")
    if not glassHolder then return end

    for _, tilePair in pairs(glassHolder:GetChildren()) do
        for _, tileModel in pairs(tilePair:GetChildren()) do
            if tileModel:IsA("Model") and tileModel.PrimaryPart then
                local isBreakable = tileModel.PrimaryPart:GetAttribute("exploitingisevil") == true
                MainModule.create_hc_glass_esp(tileModel, isBreakable)
            end
        end
    end
end

function MainModule.clear_hc_glass_esp()
    for _, data in pairs(MainModule.HCGlassESPObjects) do
        if data.highlight then
            pcall(function() data.highlight:Destroy() end)
        end
        if data.billboard then
            pcall(function() data.billboard:Destroy() end)
        end
    end
    MainModule.HCGlassESPObjects = {}
end

function MainModule.toggle_hc_glass_esp(enabled)
    MainModule.HCGlassESPEnabled = enabled

    if MainModule.HCGlassESPConnection then
        MainModule.HCGlassESPConnection:Disconnect()
        MainModule.HCGlassESPConnection = nil
    end

    if enabled then
        MainModule.scan_hc_glass_bridge()

        MainModule.HCGlassESPConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.HCGlassESPEnabled then return end

            if not MainModule.is_game_active("GlassBridge") then
                MainModule.disable_toggle("HCGlassESP")
                return
            end

            MainModule.scan_hc_glass_bridge()
        end)
    else
        MainModule.clear_hc_glass_esp()
    end
    PlayToggleSound()
end

MainModule.TugOfWarAutoQTEMiss = false
MainModule.TugOfWarAutoQTEMissConnection = nil

local function findTugOfWarCircle()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local ui = playerGui:FindFirstChild("TugOfWarUIV2")
        or playerGui:FindFirstChild("TugOfWarUI")
        or playerGui:FindFirstChild("TugofWarRemake")
    if not ui then return end

    local remake = ui:FindFirstChild("TugofWarRemake") or ui
    local circle = remake and remake:FindFirstChild("CircleBase")
    if circle and circle.Visible then
        return circle
    end
    return nil
end

function MainModule.toggle_tug_of_war_auto_qte_miss(enabled)
    MainModule.TugOfWarAutoQTEMiss = enabled

    if MainModule.TugOfWarAutoQTEMissConnection then
        MainModule.TugOfWarAutoQTEMissConnection:Disconnect()
        MainModule.TugOfWarAutoQTEMissConnection = nil
    end

    if enabled then
        MainModule.TugOfWarAutoQTEMissConnection = RunService.RenderStepped:Connect(function()
            if not MainModule.TugOfWarAutoQTEMiss then return end
            if LocalPlayer:GetAttribute("TugOfWarPhase") ~= "QTE" then return end

            local circle = findTugOfWarCircle()
            if not circle then return end

            local arrow = circle:FindFirstChild("Arrow")
            local medium = circle:FindFirstChild("Medium")
            if not (arrow and medium) then return end

            medium.Rotation = arrow.Rotation
        end)
   
    else
     
    end
    PlayToggleSound()
end


loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
--@encrypt_start
loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
MainModule.EffectShooter = {
    Enabled = false,
    Connection = nil,
    LastShootTime = 0,
    ShootCooldown = 0.05,
    TrackedPlayers = {},
    TargetEffect = "GuardCanKillLockOn"
}

MainModule.get_local_gun = function()
    local gun = nil

    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("Gun") then
                gun = tool
                break
            end
        end
    end

    if not gun and LocalPlayer.Backpack then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("Gun") then
                gun = tool
                break
            end
        end
    end

    return gun
end

MainModule.has_target_effect = function(player)
    if not player or not player.Character then
        return false
    end

    for _, descendant in pairs(player.Character:GetDescendants()) do
        if descendant:IsA("BillboardGui") and descendant.Name == MainModule.EffectShooter.TargetEffect then
            return true
        end
    end
    return false
end

MainModule.shoot_at_player = function(targetPlayerName)
    local gun = MainModule.get_local_gun()
    if not gun then return false end

    local args = {
        gun,
        {
            ClientRayNormal = Vector3.new(-1.1920928955078125e-7, 1.0000001192092896, 0),
            FiredGun = true,
            SecondaryHitTargets = {},
            ClientRayInstance = workspace:FindFirstChild("StairWalkWay") and workspace.StairWalkWay:FindFirstChild("Part") or nil,
            ClientRayPosition = Vector3.new(-220.17489624023438, 183.2957763671875, 301.07257080078125),
            bulletCF = CFrame.new(-220.5039825439453, 185.22506713867188, 302.133544921875, 0.9551116228103638, 0.2567310333251953, -0.14782091975212097, 7.450581485102248e-9, 0.4989798665046692, 0.8666135668754578, 0.2962462604045868, -0.8277127146720886, 0.4765814542770386),
            HitTargets = {
                [targetPlayerName] = "Head"
            },
            bulletSizeC = Vector3.new(0.009999999776482582, 0.009999999776482582, 4.452499866485596),
            NoMuzzleFX = false,
            FirePosition = Vector3.new(-72.88850402832031, -679.4803466796875, -173.31005859375)
        }
    }

    pcall(function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FiredGunClient"):FireServer(unpack(args))
    end)

    return true
end

MainModule.track_player_effects = function(player)
    if not player then return end

    if MainModule.EffectShooter.TrackedPlayers[player] then
        return
    end

    local connections = {}

    local characterAdded = player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
    end)
    table.insert(connections, characterAdded)

    if player.Character then
        local descendantAdded = player.Character.DescendantAdded:Connect(function(descendant)
        end)
        table.insert(connections, descendantAdded)
    end

    MainModule.EffectShooter.TrackedPlayers[player] = connections
end

MainModule.toggle_effect_shooter = function(enabled)
    MainModule.EffectShooter.Enabled = enabled
    MainModule.AutoShootEnabled = enabled and true or false

    if MainModule.EffectShooter.Connection then
        MainModule.EffectShooter.Connection:Disconnect()
        MainModule.EffectShooter.Connection = nil
    end

    if enabled then
        pcall(function()
            if MainModule.toggle_rapid_fire and not MainModule.RapidFireEnabled then
                MainModule.toggle_rapid_fire(true)
            end
        end)
        pcall(function()
            if MainModule.toggle_infinite_ammo and not MainModule.InfiniteAmmoEnabled then
                MainModule.toggle_infinite_ammo(true)
            end
        end)

        local last = 0
        MainModule.EffectShooter.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.EffectShooter.Enabled then return end
            local now = tick()
            if now - last < 0.08 then return end
            last = now

            local gun = MainModule.get_local_gun and MainModule.get_local_gun()
            if not gun then
                local char = LocalPlayer.Character
                if char then
                    for _, t in ipairs(char:GetChildren()) do
                        if t:IsA("Tool") and (t:GetAttribute("Gun") or t:FindFirstChild("GunScript") or string.lower(t.Name):find("gun")) then
                            gun = t
                            break
                        end
                    end
                end
            end
            if not gun then return end

            local hits = {}
            local live = workspace:FindFirstChild("Live")
            if live then
                for _, model in ipairs(live:GetChildren()) do
                    if model:IsA("Model") and model.Name ~= LocalPlayer.Name then
                        local player = Players:FindFirstChild(model.Name)
                        local marked = false

                        if player and MainModule.has_target_effect and MainModule.has_target_effect(player) then
                            marked = true
                        end

                        if not marked then
                            for _, d in ipairs(model:GetDescendants()) do
                                if d:IsA("Highlight") and d.Enabled then
                                    local fc = d.FillColor
                                    if fc and fc.R > 0.7 and fc.G < 0.4 and fc.B < 0.4 then
                                        marked = true
                                        break
                                    end
                                elseif d:IsA("BillboardGui") and (d.Name:find("Target") or d.Name:find("Effect")) then
                                    marked = true
                                    break
                                end
                            end
                        end

                        if marked then
                            hits[model.Name] = "Head"
                        end
                    end
                end
            end

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and MainModule.has_target_effect and MainModule.has_target_effect(plr) then
                    hits[plr.Name] = "Head"
                end
            end

            if next(hits) == nil then return end
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local remote = remotes and remotes:FindFirstChild("FiredGunClient")
            if not remote then return end
            local rayInst = workspace:FindFirstChild("StairWalkWay") and workspace.StairWalkWay:FindFirstChild("Part") or workspace
            local args = {
                gun,
                {
                    ClientRayNormal = Vector3.new(0, 1, 0),
                    FiredGun = true,
                    SecondaryHitTargets = {},
                    ClientRayInstance = rayInst,
                    ClientRayPosition = Vector3.new(0, 0, 0),
                    bulletCF = CFrame.new(),
                    HitTargets = hits,
                    bulletSizeC = Vector3.new(0.01, 0.01, 5),
                    NoMuzzleFX = true,
                    FirePosition = Vector3.new(0, 0, 0)
                }
            }
            pcall(function() remote:FireServer(unpack(args)) end)
        end)
    end
    PlayToggleSound()
end
--@encrypt_end


MainModule.is_mobile = function()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

MainModule.is_game_active = function(gameName)
    local values = Workspace:FindFirstChild("Values")
    if not values then return false end
    local currentGame = values:FindFirstChild("CurrentGame")
    return currentGame and currentGame.Value == gameName
end

MainModule.disable_toggle = function(toggleName)
    if MainModule.ToggleRefs[toggleName] and MainModule.ToggleRefs[toggleName].SetValue then
        pcall(function() MainModule.ToggleRefs[toggleName]:SetValue(false) end)
    end
end

MainModule.can_enable_toggle = function(gameName, toggleName, toggleRef)
    if not MainModule.is_game_active(gameName) then
        MainModule.notify(toggleName, "Wait for " .. gameName .. "!", 0.9)
        PlayErrorSound()
        if toggleRef and toggleRef.SetValue then
            pcall(function() toggleRef:SetValue(false) end)
        end
        return false
    end

    if not MainModule.is_feature_supported(toggleName) then
        MainModule.notify(toggleName, "Not supported in your executor", 0.9)
        PlayErrorSound()
        if toggleRef and toggleRef.SetValue then
            pcall(function() toggleRef:SetValue(false) end)
        end
        return false
    end

    return true
end

MainModule.safe_teleport = function(pos)
    local c = MainModule.get_character()
    if c then
        local rp = MainModule.get_root_part(c)
        if rp then rp.CFrame = CFrame.new(pos); return true end
    end
    return false
end
MainModule.SafeTeleport = MainModule.safe_teleport

MainModule.is_hider = function(p)
    return p and p:GetAttribute("IsHider") == true
end

MainModule.is_seeker = function(p)
    return p and p:GetAttribute("IsHunter") == true
end

MainModule.FaceTargetModule = {
    Enabled = false,
    Connection = nil
}

MainModule.toggle_face_target = function(enabled)
    if type(enabled) ~= "boolean" then
        enabled = not MainModule.FaceTargetModule.Enabled
    end

    if MainModule.FaceTargetModule.Connection then
        MainModule.FaceTargetModule.Connection:Disconnect()
        MainModule.FaceTargetModule.Connection = nil
    end

    MainModule.FaceTargetModule.Enabled = enabled

    if enabled then
        MainModule.FaceTargetModule.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.FaceTargetModule.Enabled then return end

            local character = LocalPlayer.Character
            if not character then return end
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local closestPlayer = nil
            local shortestDistance = math.huge
            local myPos = root.Position

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local dist = (targetRoot.Position - myPos).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closestPlayer = player
                        end
                    end
                end
            end

            if closestPlayer and closestPlayer.Character then
                local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local lookAt = CFrame.lookAt(root.Position, targetRoot.Position)
                    root.CFrame = CFrame.new(root.Position) * (lookAt - lookAt.Position)
                end
            end
        end)
    else
    end
    PlayToggleSound()
end

MainModule.AutoDodge = {
    Enabled = false,
    AnimationIds = {
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
        "rbxassetid://81533666958072",
        "rbxassetid://116839849594540"
    },
    Connections = {},
    LastDodgeTime = 0,
    DodgeCooldown = 1.1,
    Range = 6,
    RangeSquared = 36,
    AnimationIdsSet = {},
    ActiveAnimations = {},
    HeartbeatConnection = nil,
    PlayerStates = {},
    PlayerLastPos = {},
    PlayerAnimationStart = {},
    DodgePredictions = {},
    ActiveHitboxes = {},
    LastLookVectors = {},
    HitboxConnections = {},
}
for _, id in ipairs(MainModule.AutoDodge.AnimationIds) do
    MainModule.AutoDodge.AnimationIdsSet[id] = true
end

MainModule.AutoDodge_executeDodgeInstant = function()
    if not MainModule.AutoDodge.Enabled then return false end
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return false end
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    if not Backpack then return false end
    local dodgeItem = Backpack:FindFirstChild("DODGE!")
    if not dodgeItem then return false end
    local Hotbar = LocalPlayer.PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then return false end
    local HotbarFolder = Hotbar:FindFirstChild("Backpack")
    if not HotbarFolder then return false end
    local HotbarContainer = HotbarFolder:FindFirstChild("Hotbar")
    if not HotbarContainer then return false end
    local button = nil
    for _, slot in pairs(HotbarContainer:GetChildren()) do
        if slot:FindFirstChild("ToolName") and slot.ToolName.Text == "DODGE!" then
            button = slot
            break
        end
    end
    if not button then return false end
    local success = pcall(function()
        if not getconnections then return end
        local connections = getconnections(button.MouseButton1Down)
        for _, connection in pairs(connections) do
            connection:Fire()
        end
    end)
    if success then
        MainModule.AutoDodge.LastDodgeTime = tick()
    end
    return success
end

MainModule.AutoDodge_executeDodge = function()
    if not MainModule.AutoDodge.Enabled then return false end
    local currentTime = tick()
    if currentTime - MainModule.AutoDodge.LastDodgeTime < MainModule.AutoDodge.DodgeCooldown then return false end
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return false end
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    if not Backpack then return false end
    local dodgeItem = Backpack:FindFirstChild("DODGE!")
    if not dodgeItem then return false end
    local Hotbar = LocalPlayer.PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then return false end
    local HotbarFolder = Hotbar:FindFirstChild("Backpack")
    if not HotbarFolder then return false end
    local HotbarContainer = HotbarFolder:FindFirstChild("Hotbar")
    if not HotbarContainer then return false end
    local button = nil
    for _, slot in pairs(HotbarContainer:GetChildren()) do
        if slot:FindFirstChild("ToolName") and slot.ToolName.Text == "DODGE!" then
            button = slot
            break
        end
    end
    if not button then return false end
    local success = pcall(function()
        if not getconnections then return end
        local connections = getconnections(button.MouseButton1Down)
        for _, connection in pairs(connections) do
            connection:Fire()
        end
    end)
    if not success then return false end
    MainModule.AutoDodge.LastDodgeTime = currentTime
    return true
end

function MainModule.AutoDodge_getForwardLength(animId, animationTrack)
    local baseLength = 5
    local speedMultiplier = 0.88
    if animId:find("99157505926076") or animId:find("123072675259257") then
        baseLength = 16
    elseif animId:find("73242877658272") or animId:find("79649041083405") then
        baseLength = 6.5
    end
    local specialAnimIds = {"773242877658272", "79649041083405", "105341857343164"}
    local isSpecialAnim = false
    for _, id in ipairs(specialAnimIds) do
        if animId:find(id) then
            isSpecialAnim = true
            break
        end
    end
    if isSpecialAnim and animationTrack and animationTrack.IsPlaying then
        local success, speed = pcall(function() return animationTrack.Speed end)
        if success and speed and speed >= 19 then
            speedMultiplier = 1.3
        end
    end
    return baseLength * speedMultiplier
end

function MainModule.AutoDodge_getAnimationLength(animationTrack)
    local success, length = pcall(function() return animationTrack.Length end)
    return success and length or 1
end

function MainModule.AutoDodge_setupHitboxUpdater(hitbox, attachTo, offset)
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not MainModule.AutoDodge.Enabled then
            if connection then connection:Disconnect() end
            return
        end
        if not hitbox or not hitbox.Parent then
            if connection then connection:Disconnect() end
            return
        end
        if not attachTo or not attachTo.Parent then
            if connection then connection:Disconnect() end
            return
        end
        hitbox.CFrame = attachTo.CFrame * offset
    end)
    return connection
end

MainModule.AutoDodge_createHitbox = function(character, animId, animationTrack, sourcePlayer)
    if not MainModule.AutoDodge.Enabled then return nil end
    local localPlayer = Players.LocalPlayer
    if sourcePlayer == localPlayer then return nil end
    if not character or not character.Parent then return nil end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    local localChar = localPlayer and localPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then return nil end
    if not animationTrack or not animationTrack.IsPlaying then return nil end
    local hitboxId = tostring(tick()) .. "*" .. tostring(character.Name) .. "*" .. string.sub(animId, -8)
    local animLength = MainModule.AutoDodge_getAnimationLength(animationTrack)
    local destroyTime = math.max(0.1, animLength - 0.1)
    local forwardLength = MainModule.AutoDodge_getForwardLength(animId, animationTrack)
    local frontHitbox = Instance.new("Part")
    frontHitbox.Name = "Hitbox_Front*" .. string.sub(animId, -6) .. "*" .. tick()
    frontHitbox.Size = Vector3.new(7.04, 5.28, forwardLength)
    frontHitbox.Color = Color3.fromRGB(255, 50, 50)
    frontHitbox.Transparency = 1
    frontHitbox.Anchored = false
    frontHitbox.CanCollide = false
    frontHitbox.Material = Enum.Material.Neon
    local frontOffset = CFrame.new(0, 1.2, -(forwardLength / 2 + 1.5))
    frontHitbox.CFrame = humanoidRootPart.CFrame * frontOffset
    local frontSelectionBox = Instance.new("SelectionBox")
    frontSelectionBox.Adornee = frontHitbox
    frontSelectionBox.Color3 = frontHitbox.Color
    frontSelectionBox.LineThickness = 0.12
    frontSelectionBox.Transparency = 1
    frontSelectionBox.Parent = frontHitbox
    frontHitbox.Parent = Workspace
    local backHitbox = Instance.new("Part")
    backHitbox.Name = "Hitbox_Back*" .. string.sub(animId, -6) .. "*" .. tick()
    backHitbox.Size = Vector3.new(0.7, 0.7, 0.7)
    backHitbox.Color = Color3.fromRGB(255, 200, 100)
    backHitbox.Transparency = 1
    backHitbox.Material = Enum.Material.Neon
    backHitbox.Anchored = false
    backHitbox.CanCollide = false
    local backOffset = CFrame.new(0, 0.3, 1.5)
    backHitbox.CFrame = humanoidRootPart.CFrame * backOffset
    local backSelectionBox = Instance.new("SelectionBox")
    backSelectionBox.Adornee = backHitbox
    backSelectionBox.Color3 = backHitbox.Color
    backSelectionBox.LineThickness = 0.02
    backSelectionBox.Transparency = 1
    backSelectionBox.Parent = backHitbox
    backHitbox.Parent = Workspace
    local frontUpdateConnection = MainModule.AutoDodge_setupHitboxUpdater(frontHitbox, humanoidRootPart, frontOffset)
    local backUpdateConnection = MainModule.AutoDodge_setupHitboxUpdater(backHitbox, humanoidRootPart, backOffset)
    local hitboxData = {
        active = true,
        character = character,
        frontHitbox = frontHitbox,
        backHitbox = backHitbox,
        hitboxId = hitboxId,
        animationStartTime = tick(),
        hasDodged = false,
        animationTrack = animationTrack,
        characterName = character.Name
    }
    local function onTouch(otherPart)
        if not MainModule.AutoDodge.Enabled then return end
        if not localHRP or not localHRP.Parent then return end
        if hitboxData.hasDodged then return end
        if not hitboxData.active then return end
        local isOurBody = false
        if otherPart == localHRP then
            isOurBody = true
        elseif localChar and (otherPart.Parent == localChar or otherPart:IsDescendantOf(localChar)) then
            isOurBody = true
        end
        if isOurBody then
            hitboxData.hasDodged = true
            task.spawn(function()
                MainModule.AutoDodge_executeDodgeInstant()
            end)
        end
    end
    local frontTouchConn = frontHitbox.Touched:Connect(onTouch)
    local backTouchConn = backHitbox.Touched:Connect(onTouch)
    local function destroyHitboxes()
        hitboxData.active = false
        if frontUpdateConnection then frontUpdateConnection:Disconnect() end
        if backUpdateConnection then backUpdateConnection:Disconnect() end
        if frontTouchConn then frontTouchConn:Disconnect() end
        if backTouchConn then backTouchConn:Disconnect() end
        if frontHitbox and frontHitbox.Parent then frontHitbox:Destroy() end
        if backHitbox and backHitbox.Parent then backHitbox:Destroy() end
    end
    task.spawn(function()
        if destroyTime > 0 and destroyTime < animLength then
            task.wait(destroyTime)
        else
            while animationTrack and animationTrack.IsPlaying do
                task.wait(0.03)
            end
        end
        destroyHitboxes()
    end)
    return {frontHitbox, backHitbox}
end

function MainModule.AutoDodge_destroyAllHitboxes()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Part") and (obj.Name:find("Hitbox") or obj.Name:find("GiantHitbox") or obj.Name:find("RotationEffect")) then
            pcall(function() obj:Destroy() end)
        end
    end
end

function MainModule.AutoDodge_setupAnimationTrackingWithHitboxes()
    local function trackPlayer(player)
        if not player then return end
        local function onCharacterAdded(character)
            local humanoid = character:WaitForChild("Humanoid", 5)
            if not humanoid then return end
            humanoid.AnimationPlayed:Connect(function(animationTrack)
                if not MainModule.AutoDodge.Enabled then return end
                local animId = animationTrack.Animation.AnimationId
                if MainModule.AutoDodge.AnimationIdsSet[animId] then
                    task.spawn(function()
                        MainModule.AutoDodge_createHitbox(player.Character, animId, animationTrack, player)
                    end)
                end
            end)
        end
        if player.Character then
            onCharacterAdded(player.Character)
        end
        player.CharacterAdded:Connect(onCharacterAdded)
    end
    for _, player in pairs(Players:GetPlayers()) do
        task.spawn(function() trackPlayer(player) end)
    end
    local pa = Players.PlayerAdded:Connect(function(player) trackPlayer(player) end)
    table.insert(MainModule.AutoDodge.Connections, pa)
end

MainModule.AutoDodge_predictAttack = function(player, localPlayer)
    if not player or not player.Character then return false end
    if not localPlayer or not localPlayer.Character then return false end
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot or not targetRoot then return false end
    local distance = (targetRoot.Position - localRoot.Position).Magnitude
    if distance > 6 then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    local hasAnim = false
    local animStarted = false
    local tracks = humanoid:GetPlayingAnimationTracks()
    for _, track in pairs(tracks) do
        if track and track.Animation and track.IsPlaying then
            local id = track.Animation.AnimationId
            if MainModule.AutoDodge.AnimationIdsSet[id] then
                hasAnim = true
                local startTime = MainModule.AutoDodge.PlayerAnimationStart[player.Name] or 0
                if tick() - startTime < 0.3 then
                    animStarted = true
                end
                break
            end
        end
    end
    if not hasAnim then return false end
    local lastPos = MainModule.AutoDodge.PlayerLastPos[player.Name] or targetRoot.Position
    local velocity = (targetRoot.Position - lastPos).Magnitude
    MainModule.AutoDodge.PlayerLastPos[player.Name] = targetRoot.Position
    local isMoving = velocity > 0.5
    local state = MainModule.AutoDodge.PlayerStates[player.Name] or {}
    local lastDist = state.lastDist or distance
    local isClosing = distance < lastDist - 0.5
    state.lastDist = distance
    MainModule.AutoDodge.PlayerStates[player.Name] = state
    local predictionKey = player.Name .. "_pred"
    local lastPred = MainModule.AutoDodge.DodgePredictions[predictionKey] or 0
    if tick() - lastPred < 0.5 then return false end
    local shouldDodge = false
    if animStarted and (isMoving or isClosing) then shouldDodge = true end
    if animStarted and velocity > 3 then shouldDodge = true end
    if shouldDodge then
        MainModule.AutoDodge.DodgePredictions[predictionKey] = tick()
        return true
    end
    return false
end

MainModule.AutoDodge_processDodge = function()
    if not MainModule.AutoDodge.Enabled then return end
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer or not LocalPlayer.Character then return end
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    local players = Players:GetPlayers()
    for i = 1, #players do
        local player = players[i]
        if player == LocalPlayer then goto HSX_CONT_76 end
        if not player.Character then goto HSX_CONT_76 end
        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then goto HSX_CONT_76 end
        local distance = (targetRoot.Position - localRoot.Position).Magnitude
        if distance > 8 then
            MainModule.AutoDodge.PlayerStates[player.Name] = nil
            goto HSX_CONT_76
        end
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if not humanoid then goto HSX_CONT_76 end
        local hasAnim = false
        local tracks = humanoid:GetPlayingAnimationTracks()
        for _, track in pairs(tracks) do
            if track and track.Animation and track.IsPlaying then
                local id = track.Animation.AnimationId
                if MainModule.AutoDodge.AnimationIdsSet[id] then
                    hasAnim = true
                    if not MainModule.AutoDodge.PlayerAnimationStart[player.Name] then
                        MainModule.AutoDodge.PlayerAnimationStart[player.Name] = tick()
                    end
                    break
                end
            end
        end
        if not hasAnim then
            MainModule.AutoDodge.PlayerAnimationStart[player.Name] = nil
            goto HSX_CONT_76
        end
        if MainModule.AutoDodge_predictAttack(player, LocalPlayer) then
            local animKey = player.Name .. tostring(tick())
            if not MainModule.AutoDodge.ActiveAnimations[player.Name] then
                MainModule.AutoDodge.ActiveAnimations[player.Name] = {}
            end
            if not MainModule.AutoDodge.ActiveAnimations[player.Name][animKey] then
                MainModule.AutoDodge.ActiveAnimations[player.Name][animKey] = true
                if MainModule.AutoDodge_executeDodge() then
                    task.spawn(function()
                        task.wait(0.3)
                        if MainModule.AutoDodge.ActiveAnimations[player.Name] then
                            MainModule.AutoDodge.ActiveAnimations[player.Name][animKey] = nil
                        end
                    end)
                else
                    MainModule.AutoDodge.ActiveAnimations[player.Name][animKey] = nil
                end
            end
        end
        ::HSX_CONT_76::
    end
end


MainModule._AutoUseSaved = MainModule._AutoUseSaved or {}

MainModule.PushAutoUseTrue = function(key)
    key = tostring(key or "default")
    pcall(function()
        local autoUse = LocalPlayer:FindFirstChild("AutoUse")
        if not autoUse then
            autoUse = Instance.new("BoolValue")
            autoUse.Name = "AutoUse"
            autoUse.Parent = LocalPlayer
        end
        if MainModule._AutoUseSaved[key] == nil then
            MainModule._AutoUseSaved[key] = autoUse.Value
        end
        autoUse.Value = true
    end)
end

MainModule.PopAutoUse = function(key)
    key = tostring(key or "default")
    pcall(function()
        local autoUse = LocalPlayer:FindFirstChild("AutoUse")
        if not autoUse then return end
        local saved = MainModule._AutoUseSaved[key]
        if saved ~= nil then
            autoUse.Value = saved
            MainModule._AutoUseSaved[key] = nil
        end
    end)
end

MainModule.toggle_auto_dodge = function(enabled)
    local toggleRef = MainModule.ToggleRefs.AutoDodge
    if enabled then
        if MainModule.can_enable_toggle and not MainModule.can_enable_toggle("HideAndSeek", "Auto Dodge", toggleRef) then
            return false
        end
    end
    for _, conn in pairs(MainModule.AutoDodge.Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    if MainModule.AutoDodge.HeartbeatConnection then
        pcall(function() MainModule.AutoDodge.HeartbeatConnection:Disconnect() end)
        MainModule.AutoDodge.HeartbeatConnection = nil
    end
    MainModule.AutoDodge.Enabled = false
    MainModule.AutoDodge.Connections = {}
    MainModule.AutoDodge.ActiveAnimations = {}
    MainModule.AutoDodge.LastDodgeTime = 0
    MainModule.AutoDodge_destroyAllHitboxes()
    if enabled then
        MainModule.PushAutoUseTrue("AutoDodge")
        MainModule.AutoDodge.Enabled = true
        MainModule.AutoDodge_setupAnimationTrackingWithHitboxes()
        MainModule.AutoDodge.HeartbeatConnection = RunService.Heartbeat:Connect(function()
            MainModule.AutoDodge_processDodge()
        end)
        table.insert(MainModule.AutoDodge.Connections, MainModule.AutoDodge.HeartbeatConnection)
    else
        MainModule.PopAutoUse("AutoDodge")
    end
    PlayToggleSound()
    return true
end


MainModule.AutoUltraInstinct = {
    Enabled = false,
    ViewOwnHitboxes = false,
    AnimationIds = {
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
        "rbxassetid://116839849594540",
        "rbxassetid://85793691404836",
        "rbxassetid://86197206792061",
        "rbxassetid://87978085217719",
        "rbxassetid://85623602463927",
        "rbxassetid://103062305177426",
        "rbxassetid://99157505926076",
        "rbxassetid://114769224376981",
        "rbxassetid://9783204720378",
        "rbxassetid://94443309383954",
        "rbxassetid://98785078701251",
        "rbxassetid://123072675259257",
        "rbxassetid://85743982894847",
        "rbxassetid://89439896387299",
        "rbxassetid://97863204720378",
        "rbxassetid://106756593687295",
        "rbxassetid://81816623746576",
        "rbxassetid://81392013026663",
        "rbxassetid://109822392402606",
        "rbxassetid://134675465964672",
        "rbxassetid://137659772694747",
        "rbxassetid://85756694343517",
        "rbxassetid://131235569946744",
        "rbxassetid://76323709902827",
        "rbxassetid://73150160715773"
    },
    Connections = {},
    AnimationIdsSet = {},
    DodgedHitboxes = {},
    LastDodgeTime = 0,
    MinDodgeInterval = 0.02,
    LastLookVectors = {},
    Active6663Hitbox = nil,
    IsDodging6663 = false,
    Dodge6663Count = 0,
    Max6663Dodges = 200,
    IsInside6663Hitbox = false,
    SpecialAnimations = {
        ["1123072675259257"] = true,
        ["99157505926076"] = true
    },
    SpecialAnimationData = {},
    SpecialDodgeRadius = 20,
    SpecialTrackRadius = 1500,
    IsInitialized = false,
}
for _, id in ipairs(MainModule.AutoUltraInstinct.AnimationIds) do
    MainModule.AutoUltraInstinct.AnimationIdsSet[id] = true
end

MainModule.AUI_cachedTool = nil
MainModule.AUI_lastToolCheck = 0

MainModule.AUI_findUltraTool = function()
    local UI = MainModule.AutoUltraInstinct
    local currentTime = tick()
    if MainModule.AUI_cachedTool and currentTime - MainModule.AUI_lastToolCheck < 0.3 then
        return MainModule.AUI_cachedTool
    end
    local player = Players.LocalPlayer
    if not player then return nil end
    local character = player.Character
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("ultra") then
                MainModule.AUI_cachedTool = tool
                MainModule.AUI_lastToolCheck = currentTime
                return tool
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("ultra") then
                MainModule.AUI_cachedTool = tool
                MainModule.AUI_lastToolCheck = currentTime
                return tool
            end
        end
    end
    MainModule.AUI_cachedTool = nil
    MainModule.AUI_lastToolCheck = currentTime
    return nil
end

MainModule.AUI_pressUltraHotbar = function()
    local ultraTool = MainModule.AUI_findUltraTool()
    if not ultraTool then return false end
    local toolName = ultraTool.Name
    local lp = Players.LocalPlayer
    if not lp then return false end
    local Hotbar = lp:FindFirstChild("PlayerGui") and lp.PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then return false end
    local hotbarContainer = Hotbar:FindFirstChild("Backpack")
    if not hotbarContainer then return false end
    local hotbar = hotbarContainer:FindFirstChild("Hotbar")
    if not hotbar then return false end
    local button = nil
    for _, slot in pairs(hotbar:GetChildren()) do
        local tn = slot:FindFirstChild("ToolName")
        if tn and tn.Text == toolName then
            button = slot
            break
        end
    end
    if not button then return false end
    if not getconnections then return false end
    local ok = pcall(function()
        for _, connection in pairs(getconnections(button.MouseButton1Down)) do
            pcall(function() connection:Fire() end)
        end
        task.wait(0.05)
        for _, connection in pairs(getconnections(button.MouseButton1Up)) do
            pcall(function() connection:Fire() end)
        end
    end)
    return ok
end

MainModule.AUI_isEnemyLookingAtUs = function(character, ourPosition, characterName)
    local UI = MainModule.AutoUltraInstinct
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false, 0, false end
    local enemyPosition = humanoidRootPart.Position
    local toOurPosition = (ourPosition - enemyPosition).Unit
    local enemyLookVector = humanoidRootPart.CFrame.LookVector
    local dotProduct = enemyLookVector:Dot(toOurPosition)
    local threshold = 0.05
    local lastData = UI.LastLookVectors[characterName]
    local isSharpTurn = false
    if lastData then
        local lastVector = lastData.vector
        local angleChange = math.acos(math.clamp(enemyLookVector:Dot(lastVector), -1, 1))
        if angleChange > 0.25 then
            isSharpTurn = true
        end
    end
    UI.LastLookVectors[characterName] = { vector = enemyLookVector, time = tick() }
    local isLooking = dotProduct > threshold or isSharpTurn
    return isLooking, dotProduct, isSharpTurn
end

MainModule.AUI_executeUltraNow = function(hitboxId, reason)
    local UI = MainModule.AutoUltraInstinct
    if not UI.Enabled then return false end
    local currentTime = tick()
    local is6663Hitbox = hitboxId and (string.find(hitboxId, "6663") or (UI.Active6663Hitbox and hitboxId == UI.Active6663Hitbox.hitboxId .. "_touch"))
    if is6663Hitbox then
        if not UI.IsInside6663Hitbox then return false end
        if not UI.Active6663Hitbox or not UI.Active6663Hitbox.active then return false end
        if UI.Dodge6663Count >= UI.Max6663Dodges then return false end
    else
        if currentTime - UI.LastDodgeTime < UI.MinDodgeInterval then return false end
        if UI.DodgedHitboxes[hitboxId] then return false end
        UI.DodgedHitboxes[hitboxId] = true
    end
    local success = MainModule.AUI_pressUltraHotbar()
    if success then
        if not is6663Hitbox then
            UI.LastDodgeTime = currentTime
        else
            UI.Dodge6663Count = UI.Dodge6663Count + 1
        end
    end
    if not is6663Hitbox then
        task.spawn(function()
            task.wait(1.5)
            UI.DodgedHitboxes[hitboxId] = nil
        end)
    end
    return success
end

MainModule.AUI_startLimitedDodgeFor6663 = function(hitboxData)
    local UI = MainModule.AutoUltraInstinct
    if UI.IsDodging6663 then return end
    UI.IsDodging6663 = true
    UI.Active6663Hitbox = hitboxData
    UI.Dodge6663Count = 0
    UI.IsInside6663Hitbox = true
    task.spawn(function()
        while UI.IsDodging6663 and hitboxData and hitboxData.active and UI.Dodge6663Count < UI.Max6663Dodges do
            if not UI.IsInside6663Hitbox then break end
            if not hitboxData.active or not hitboxData.frontHitbox or not hitboxData.frontHitbox.Parent then break end
            local success = MainModule.AUI_executeUltraNow(hitboxData.hitboxId .. "_touch", "6663 TOUCH DODGE")
            if not success then
                task.wait(0.01)
            else
                task.wait(0.03)
            end
        end
        UI.IsDodging6663 = false
        UI.Active6663Hitbox = nil
        UI.IsInside6663Hitbox = false
    end)
end

MainModule.AUI_setupHitboxUpdater = function(hitbox, attachTo, offset, isStatic)
    if isStatic then return nil end
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not MainModule.AutoUltraInstinct.Enabled then
            if connection then connection:Disconnect() end
            return
        end
        if not hitbox or not hitbox.Parent then
            if connection then connection:Disconnect() end
            return
        end
        if not attachTo or not attachTo.Parent then
            if connection then connection:Disconnect() end
            return
        end
        hitbox.CFrame = attachTo.CFrame * offset
    end)
    return connection
end

MainModule.AUI_getAnimationLength = function(animationTrack)
    local success, length = pcall(function() return animationTrack.Length end)
    return success and length or 1
end

MainModule.AUI_getForwardLength = function(animId, isSpecial)
    if isSpecial then return 55 end
    local forwardLength = 5
    if animId:find("99157505926076") or animId:find("123072675259257") then
        forwardLength = 16
    elseif animId:find("73242877658272") or animId:find("79649041083405") then
        forwardLength = 6.5
    end
    return forwardLength
end

MainModule.AUI_setupSpecialAnimationTracking = function(player, animId, animationTrack)
    local UI = MainModule.AutoUltraInstinct
    local animIdNumber = animId:match("(%d+)$") or animId:match("/(%d+)$")
    if not animIdNumber then return end
    if not UI.SpecialAnimations[animIdNumber] then return end
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local localPlayer = Players.LocalPlayer
    if player == localPlayer then return end
    local specialId = tostring(tick()) .. "_" .. tostring(player.Name) .. "_special_" .. animIdNumber
    local isActive = true
    local hasDodged = false
    local checkConnection = nil
    UI.SpecialAnimationData[specialId] = {
        active = true,
        character = character,
        humanoidRootPart = humanoidRootPart,
        player = player,
        animId = animIdNumber,
        hasDodged = false,
        startTime = tick(),
        isTracking = false
    }
    checkConnection = RunService.Heartbeat:Connect(function()
        if not UI.Enabled then
            if checkConnection then checkConnection:Disconnect() end
            return
        end
        if not isActive or hasDodged then
            if checkConnection then checkConnection:Disconnect() end
            return
        end
        local localChar = localPlayer.Character
        if not localChar then return end
        local localHRP = localChar:FindFirstChild("HumanoidRootPart")
        if not localHRP then return end
        if not character or not character.Parent or not humanoidRootPart or not humanoidRootPart.Parent then
            isActive = false
            if checkConnection then checkConnection:Disconnect() end
            return
        end
        local distance = (humanoidRootPart.Position - localHRP.Position).Magnitude
        if distance <= UI.SpecialDodgeRadius then
            if not hasDodged then
                hasDodged = true
                UI.SpecialAnimationData[specialId].hasDodged = true
                if checkConnection then checkConnection:Disconnect() end
                MainModule.AUI_executeUltraNow(specialId .. "_special_dodge", "SPECIAL ANIMATION DODGE")
            end
        end
    end)
    task.spawn(function()
        while isActive and animationTrack and animationTrack.IsPlaying do
            task.wait(0.03)
        end
        isActive = false
        if checkConnection then checkConnection:Disconnect() end
        UI.SpecialAnimationData[specialId] = nil
    end)
end

MainModule.AUI_createHitbox = function(character, animId, animationTrack, sourcePlayer)
    local UI = MainModule.AutoUltraInstinct
    if not UI.Enabled then return nil end
    local localPlayer = Players.LocalPlayer
    local animIdNumber = animId:match("(%d+)$") or animId:match("/(%d+)$")
    local isSpecialAnim = animIdNumber and UI.SpecialAnimations[animIdNumber]
    if isSpecialAnim and sourcePlayer ~= localPlayer then
        task.spawn(function()
            MainModule.AUI_setupSpecialAnimationTracking(sourcePlayer, animId, animationTrack)
        end)
        return nil
    end
    if sourcePlayer == localPlayer and not UI.ViewOwnHitboxes then
        return nil
    end
    if not character or not character.Parent then return nil end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    local localChar = localPlayer and localPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local startDistance = nil
    if localHRP and humanoidRootPart then
        startDistance = (humanoidRootPart.Position - localHRP.Position).Magnitude
    end
    task.wait(0.01)
    if not character or not character.Parent then return nil end
    if not humanoidRootPart or not humanoidRootPart.Parent then return nil end
    if not animationTrack or not animationTrack.IsPlaying then return nil end
    local isSpecial = animId:find("6663") ~= nil
    local hitboxId = tostring(tick()) .. "_" .. tostring(character.Name) .. "_" .. string.sub(animId, -8)
    local animLength = MainModule.AUI_getAnimationLength(animationTrack)
    local destroyTime
    if isSpecial then
        destroyTime = animLength + 3.1
    else
        destroyTime = math.max(0.1, animLength - 0.1)
    end
    local staticPosition = nil
    local staticCFrame = nil
    if isSpecial then
        staticPosition = humanoidRootPart.Position
        staticCFrame = humanoidRootPart.CFrame
    end
    local forwardLength = MainModule.AUI_getForwardLength(animId, isSpecial)
    local frontHitbox = Instance.new("Part")
    if isSpecial then
        frontHitbox.Name = "GiantHitbox_6663_STATIC_" .. tick()
        frontHitbox.Size = Vector3.new(55, 32.5, 55)
        frontHitbox.Color = Color3.fromRGB(255, 0, 100)
        frontHitbox.Transparency = 0.35
        frontHitbox.Anchored = true
    else
        frontHitbox.Name = "Hitbox_Front_" .. string.sub(animId, -6) .. "_" .. tick()
        frontHitbox.Size = Vector3.new(8, 6, forwardLength)
        frontHitbox.Color = Color3.fromRGB(255, 50, 50)
        frontHitbox.Transparency = 0.35
        frontHitbox.Anchored = false
    end
    frontHitbox.CanCollide = false
    frontHitbox.Material = Enum.Material.Neon
    local frontOffset = CFrame.new(0, 1.2, -(forwardLength / 2 + 1.5))
    if isSpecial then
        frontHitbox.CFrame = staticCFrame * frontOffset
    else
        frontHitbox.CFrame = humanoidRootPart.CFrame * frontOffset
    end
    local frontSelectionBox = Instance.new("SelectionBox")
    frontSelectionBox.Adornee = frontHitbox
    frontSelectionBox.Color3 = frontHitbox.Color
    frontSelectionBox.LineThickness = isSpecial and 0.35 or 0.12
    frontSelectionBox.Transparency = 0.25
    frontSelectionBox.Parent = frontHitbox
    local frontParticles = Instance.new("ParticleEmitter")
    frontParticles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    frontParticles.Color = ColorSequence.new(frontHitbox.Color)
    frontParticles.Size = NumberSequence.new(isSpecial and 4 or 0.4)
    frontParticles.Rate = isSpecial and 200 or 20
    frontParticles.Lifetime = NumberRange.new(isSpecial and 1.5 or 0.25)
    frontParticles.SpreadAngle = Vector2.new(360, 360)
    frontParticles.VelocityInheritance = 0
    frontParticles.Speed = NumberRange.new(isSpecial and 10 or 1.5)
    frontParticles.Parent = frontHitbox
    local hitboxData = {
        active = true,
        character = character,
        frontHitbox = frontHitbox,
        backHitbox = nil,
        hitboxId = hitboxId,
        animationStartTime = tick(),
        hasDodged = false,
        animationTrack = animationTrack,
        startDistance = startDistance,
        hasEnteredRadius = false,
        characterName = character.Name,
        turnWindowEndTime = tick() + 1.4,
        is6663 = isSpecial,
        staticPosition = staticPosition,
        staticCFrame = staticCFrame
    }
    if isSpecial then
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(255, 0, 100)
        pointLight.Range = 60
        pointLight.Brightness = 4
        pointLight.Parent = frontHitbox
        local attachment = Instance.new("Attachment")
        attachment.Parent = frontHitbox
        local smoke = Instance.new("Smoke")
        smoke.Color = Color3.fromRGB(255, 0, 100)
        smoke.Opacity = 0.5
        smoke.RiseVelocity = 5
        smoke.Size = 12
        smoke.Parent = attachment
        local rotationEffect = Instance.new("Part")
        rotationEffect.Name = "RotationEffect"
        rotationEffect.Size = Vector3.new(60, 2, 60)
        rotationEffect.Shape = Enum.PartType.Cylinder
        rotationEffect.Color = Color3.fromRGB(255, 0, 100)
        rotationEffect.Transparency = 0.7
        rotationEffect.Material = Enum.Material.Neon
        rotationEffect.Anchored = true
        rotationEffect.CanCollide = false
        rotationEffect.CFrame = staticCFrame
        rotationEffect.Parent = Workspace
        task.spawn(function()
            local startTime = tick()
            while hitboxData.active and rotationEffect and rotationEffect.Parent and UI.Enabled do
                local elapsed = tick() - startTime
                rotationEffect.CFrame = staticCFrame * CFrame.Angles(0, math.rad(elapsed * 180), 0)
                task.wait()
            end
            if rotationEffect then pcall(function() rotationEffect:Destroy() end) end
        end)
    end
    frontHitbox.Parent = Workspace
    local backHitbox = Instance.new("Part")
    backHitbox.Name = "Hitbox_Back_" .. string.sub(animId, -6) .. "_" .. tick()
    backHitbox.Size = Vector3.new(0.8, 0.8, 0.8)
    backHitbox.Color = Color3.fromRGB(255, 200, 100)
    backHitbox.Transparency = 0.15
    backHitbox.Material = Enum.Material.Neon
    backHitbox.Anchored = isSpecial
    backHitbox.CanCollide = false
    local backOffset = CFrame.new(0, 0.3, 0.8)
    if isSpecial then
        backHitbox.CFrame = staticCFrame * backOffset
    else
        backHitbox.CFrame = humanoidRootPart.CFrame * backOffset
    end
    local backSelectionBox = Instance.new("SelectionBox")
    backSelectionBox.Adornee = backHitbox
    backSelectionBox.Color3 = Color3.fromRGB(255, 200, 100)
    backSelectionBox.LineThickness = 0.02
    backSelectionBox.Transparency = 0.5
    backSelectionBox.Parent = backHitbox
    backHitbox.Parent = Workspace
    hitboxData.backHitbox = backHitbox
    local frontUpdateConnection = MainModule.AUI_setupHitboxUpdater(frontHitbox, humanoidRootPart, frontOffset, isSpecial)
    local backUpdateConnection = MainModule.AUI_setupHitboxUpdater(backHitbox, humanoidRootPart, backOffset, isSpecial)
    local isOwnHitbox = (sourcePlayer == localPlayer)
    if isOwnHitbox then
        task.spawn(function()
            if isSpecial then
                while animationTrack and animationTrack.IsPlaying do task.wait(0.03) end
                task.wait(3.1)
            else
                if destroyTime > 0 and destroyTime < animLength then
                    task.wait(destroyTime)
                else
                    while animationTrack and animationTrack.IsPlaying do task.wait(0.03) end
                end
            end
            hitboxData.active = false
            if isSpecial then
                UI.IsDodging6663 = false
                UI.Active6663Hitbox = nil
                UI.IsInside6663Hitbox = false
            end
            if frontUpdateConnection then frontUpdateConnection:Disconnect() end
            if backUpdateConnection then backUpdateConnection:Disconnect() end
            if frontHitbox and frontHitbox.Parent then frontHitbox:Destroy() end
            if backHitbox and backHitbox.Parent then backHitbox:Destroy() end
        end)
        return {frontHitbox, backHitbox}
    end
    local turnCheckConnection = nil
    if not isSpecial then
        turnCheckConnection = RunService.RenderStepped:Connect(function()
            if not UI.Enabled then
                if turnCheckConnection then turnCheckConnection:Disconnect() end
                return
            end
            if hitboxData.hasDodged or not hitboxData.active then
                if turnCheckConnection then turnCheckConnection:Disconnect() end
                return
            end
            if tick() > hitboxData.turnWindowEndTime then
                if turnCheckConnection then turnCheckConnection:Disconnect() end
                return
            end
            if not localHRP or not localHRP.Parent then return end
            if not character or not character.Parent then return end
            local enemyHRP = character:FindFirstChild("HumanoidRootPart")
            if not enemyHRP then return end
            local currentDistance = (enemyHRP.Position - localHRP.Position).Magnitude
            local startDistanceCheck = hitboxData.startDistance and hitboxData.startDistance > 5.5
            if startDistanceCheck and currentDistance <= 5.5 then
                if not hitboxData.hasEnteredRadius then
                    hitboxData.hasEnteredRadius = true
                end
                local isLooking, _, isSharpTurn = MainModule.AUI_isEnemyLookingAtUs(character, localHRP.Position, hitboxData.characterName)
                if (isLooking or isSharpTurn) and hitboxData.hasEnteredRadius and hitboxData.active then
                    hitboxData.hasDodged = true
                    if turnCheckConnection then turnCheckConnection:Disconnect() end
                    MainModule.AUI_executeUltraNow(hitboxId .. "_turn", "")
                end
            end
        end)
    end
    local function onTouch(otherPart, boxId)
        if not UI.Enabled then return end
        if not localHRP or not localHRP.Parent then return end
        local isOurBody = false
        if otherPart == localHRP then
            isOurBody = true
        elseif localChar and (otherPart.Parent == localChar or otherPart:IsDescendantOf(localChar)) then
            isOurBody = true
        end
        if isOurBody then
            if isSpecial then
                if not hitboxData.hasDodged and hitboxData.active then
                    hitboxData.hasDodged = true
                    UI.IsInside6663Hitbox = true
                    MainModule.AUI_startLimitedDodgeFor6663(hitboxData)
                end
            else
                if not hitboxData.hasDodged then
                    hitboxData.hasDodged = true
                    if turnCheckConnection then turnCheckConnection:Disconnect() end
                    MainModule.AUI_executeUltraNow(boxId, "")
                end
            end
        end
    end
    local function onTouchEnd(otherPart)
        if not UI.Enabled or not isSpecial or not hitboxData.active then return end
        local isOurBody = false
        if otherPart == localHRP then
            isOurBody = true
        elseif localChar and (otherPart.Parent == localChar or otherPart:IsDescendantOf(localChar)) then
            isOurBody = true
        end
        if isOurBody then
            UI.IsInside6663Hitbox = false
        end
    end
    local frontBoxId = hitboxId .. "_front"
    local backBoxId = hitboxId .. "_back"
    local frontTouchConn = frontHitbox.Touched:Connect(function(part) onTouch(part, frontBoxId) end)
    local backTouchConn = backHitbox.Touched:Connect(function(part) onTouch(part, backBoxId) end)
    local touchEndConn = nil
    if isSpecial then
        touchEndConn = frontHitbox.TouchEnded:Connect(function(part) onTouchEnd(part) end)
    end
    local function destroyHitboxes()
        hitboxData.active = false
        if isSpecial then
            UI.IsDodging6663 = false
            UI.Active6663Hitbox = nil
            UI.IsInside6663Hitbox = false
        end
        if frontUpdateConnection then frontUpdateConnection:Disconnect() end
        if backUpdateConnection then backUpdateConnection:Disconnect() end
        if turnCheckConnection then turnCheckConnection:Disconnect() end
        if frontTouchConn then frontTouchConn:Disconnect() end
        if backTouchConn then backTouchConn:Disconnect() end
        if touchEndConn then touchEndConn:Disconnect() end
        task.spawn(function()
            task.wait(2)
            UI.LastLookVectors[hitboxData.characterName] = nil
        end)
        task.spawn(function()
            task.wait(1.5)
            if not isSpecial then
                UI.DodgedHitboxes[frontBoxId] = nil
                UI.DodgedHitboxes[backBoxId] = nil
                UI.DodgedHitboxes[hitboxId .. "_turn"] = nil
            end
        end)
        if frontHitbox and frontHitbox.Parent then frontHitbox:Destroy() end
        if backHitbox and backHitbox.Parent then backHitbox:Destroy() end
    end
    task.spawn(function()
        if isSpecial then
            while animationTrack and animationTrack.IsPlaying do task.wait(0.03) end
            task.wait(3.1)
        else
            if destroyTime > 0 and destroyTime < animLength then
                task.wait(destroyTime)
            else
                while animationTrack and animationTrack.IsPlaying do task.wait(0.03) end
            end
        end
        destroyHitboxes()
    end)
    return {frontHitbox, backHitbox}
end

MainModule.AUI_destroyAllHitboxes = function()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Part") and (obj.Name:find("Hitbox") or obj.Name:find("GiantHitbox") or obj.Name:find("RotationEffect")) then
            pcall(function() obj:Destroy() end)
        end
    end
end

MainModule.AUI_setupAnimationTracking = function()
    local UI = MainModule.AutoUltraInstinct
    local function trackPlayer(player)
        if not player then return end
        local function onCharacterAdded(character)
            local humanoid = character:WaitForChild("Humanoid", 5)
            if not humanoid then return end
            local conn = humanoid.AnimationPlayed:Connect(function(animationTrack)
                if not UI.Enabled then return end
                local animId = animationTrack.Animation.AnimationId
                if UI.AnimationIdsSet[animId] then
                    task.spawn(function()
                        MainModule.AUI_createHitbox(player.Character, animId, animationTrack, player)
                    end)
                end
            end)
            table.insert(UI.Connections, conn)
        end
        if player.Character then onCharacterAdded(player.Character) end
        local ca = player.CharacterAdded:Connect(onCharacterAdded)
        table.insert(UI.Connections, ca)
    end
    for _, player in pairs(Players:GetPlayers()) do
        task.spawn(function() trackPlayer(player) end)
    end
    local pa = Players.PlayerAdded:Connect(function(player) trackPlayer(player) end)
    table.insert(UI.Connections, pa)
end

MainModule.toggle_auto_ultra_instinct = function(enabled)
    local UI = MainModule.AutoUltraInstinct
    enabled = enabled and true or false
    UI.Enabled = enabled
    if enabled then
        MainModule.PushAutoUseTrue("AutoUltraInstinct")
        MainModule.AUI_destroyAllHitboxes()
        if not UI.IsInitialized then
            MainModule.AUI_setupAnimationTracking()
            task.spawn(function()
                while true do
                    task.wait(5)
                    local now = tick()
                    for name, data in pairs(UI.LastLookVectors) do
                        if now - data.time > 2 then UI.LastLookVectors[name] = nil end
                    end
                end
            end)
            task.spawn(function()
                while true do
                    task.wait(10)
                    local now = tick()
                    for id, data in pairs(UI.SpecialAnimationData) do
                        if data.startTime and now - data.startTime > 10 then
                            UI.SpecialAnimationData[id] = nil
                        end
                    end
                end
            end)
            UI.IsInitialized = true
        end
    else
        MainModule.AUI_destroyAllHitboxes()
        UI.IsDodging6663 = false
        UI.Active6663Hitbox = nil
        UI.Dodge6663Count = 0
        UI.IsInside6663Hitbox = false
        UI.SpecialAnimationData = {}
        MainModule.PopAutoUse("AutoUltraInstinct")
    end
    PlayToggleSound()
    return true
end

MainModule.ThrowHelper = {
    Enabled = false,
    Connection = nil,
    LockedTarget = nil,
    IsLocked = false,
    CurrentTarget = nil,
    LastLookTarget = nil,
    CheckInterval = 0.5,
    LastCheckTime = 0,
    DotThreshold = 0.3
}
MainModule.FaceTargetModule = MainModule.ThrowHelper

MainModule.AutoThrow = {
    Enabled = false,
    LastThrowTime = 0,
    ThrowCooldown = 0.3,
    KeybindConnection = nil,
    TempFaceTask = nil,
    MobileButton = nil,
    IsThrowing = false,
}

MainModule.ThrowHelper_isLookingAtPlayer = function(targetPlayer, localPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    if not localPlayer or not localPlayer.Character then return false end
    local targetHead = targetPlayer.Character:FindFirstChild("Head")
    local localHead = localPlayer.Character:FindFirstChild("Head")
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (targetHead and localHead and localRoot) then return false end
    local directionToTarget = (targetHead.Position - localHead.Position).Unit
    local lookVector = localHead.CFrame.LookVector
    return directionToTarget:Dot(lookVector) > MainModule.ThrowHelper.DotThreshold
end

MainModule.ThrowHelper_findClosestPlayer = function()
    local character = LocalPlayer.Character
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closestPlayer, shortestDistance = nil, math.huge
    local myPos = root.Position
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local dist = (targetRoot.Position - myPos).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

MainModule.ThrowHelper_findPlayerLookingAt = function()
    local character = LocalPlayer.Character
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local myPos = root.Position
    local lookingAt, closestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if MainModule.ThrowHelper_isLookingAtPlayer(player, LocalPlayer) then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local dist = (targetRoot.Position - myPos).Magnitude
                    if dist < closestDistance then
                        closestDistance = dist
                        lookingAt = player
                    end
                end
            end
        end
    end
    if lookingAt then return lookingAt end
    return MainModule.ThrowHelper_findClosestPlayer()
end

MainModule.ThrowHelper_selectTarget = function()
    local target = MainModule.ThrowHelper_findPlayerLookingAt()
    if target then
        MainModule.ThrowHelper.LockedTarget = target
        MainModule.ThrowHelper.IsLocked = true
        return true
    end
    return false
end

MainModule.ThrowHelper_resetTarget = function()
    MainModule.ThrowHelper.LockedTarget = nil
    MainModule.ThrowHelper.IsLocked = false
    MainModule.ThrowHelper.CurrentTarget = nil
    MainModule.ThrowHelper.LastLookTarget = nil
end

MainModule.ThrowHelper_toggleFaceTarget = function(enabled, lockTarget)
    if type(enabled) ~= "boolean" then
        enabled = not MainModule.ThrowHelper.Enabled
    end
    if MainModule.ThrowHelper.Connection then
        MainModule.ThrowHelper.Connection:Disconnect()
        MainModule.ThrowHelper.Connection = nil
    end
    MainModule.ThrowHelper.Enabled = enabled
    if enabled then
        if lockTarget then
            MainModule.ThrowHelper_selectTarget()
        end
        MainModule.ThrowHelper.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.ThrowHelper.Enabled then return end
            local character = LocalPlayer.Character
            if not character then return end
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            if MainModule.ThrowHelper.IsLocked and MainModule.ThrowHelper.LockedTarget then
                if MainModule.ThrowHelper.LockedTarget.Character and MainModule.ThrowHelper.LockedTarget.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = MainModule.ThrowHelper.LockedTarget.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local lookAt = CFrame.lookAt(root.Position, targetRoot.Position)
                        root.CFrame = CFrame.new(root.Position) * (lookAt - lookAt.Position)
                    end
                else
                    MainModule.ThrowHelper_resetTarget()
                    MainModule.ThrowHelper_selectTarget()
                end
            else
                local currentTime = tick()
                local target = nil
                if currentTime - MainModule.ThrowHelper.LastCheckTime >= MainModule.ThrowHelper.CheckInterval then
                    MainModule.ThrowHelper.LastCheckTime = currentTime
                    target = MainModule.ThrowHelper_findPlayerLookingAt()
                    if target then
                        MainModule.ThrowHelper.LastLookTarget = target
                        MainModule.ThrowHelper.CurrentTarget = target
                    else
                        if MainModule.ThrowHelper.LastLookTarget and MainModule.ThrowHelper.LastLookTarget.Character then
                            target = MainModule.ThrowHelper.LastLookTarget
                            MainModule.ThrowHelper.CurrentTarget = target
                        else
                            target = MainModule.ThrowHelper_findClosestPlayer()
                            MainModule.ThrowHelper.CurrentTarget = target
                            MainModule.ThrowHelper.LastLookTarget = target
                        end
                    end
                end
                MainModule.ThrowHelper.CurrentTarget = MainModule.ThrowHelper.LastLookTarget
                if MainModule.ThrowHelper.CurrentTarget and MainModule.ThrowHelper.CurrentTarget.Character then
                    local targetRoot = MainModule.ThrowHelper.CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local lookAt = CFrame.lookAt(root.Position, targetRoot.Position)
                        root.CFrame = CFrame.new(root.Position) * (lookAt - lookAt.Position)
                    end
                end
            end
        end)
    else
        MainModule.ThrowHelper_resetTarget()
    end
end

MainModule.AutoThrow_findThrowTool = function()
    if LocalPlayer.Backpack then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and string.find(tool.Name, "Throw") then
                return tool
            end
        end
    end
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and string.find(tool.Name, "Throw") then
                return tool
            end
        end
    end
    return nil
end

MainModule.AutoThrow_executeThrow = function()
    if not MainModule.AutoThrow.Enabled then return false end
    local currentTime = tick()
    if currentTime - MainModule.AutoThrow.LastThrowTime < MainModule.AutoThrow.ThrowCooldown then
        return false
    end
    local throwTool = MainModule.AutoThrow_findThrowTool()
    if not throwTool then return false end
    local Hotbar = LocalPlayer.PlayerGui:FindFirstChild("Hotbar")
    if not Hotbar then return false end
    local hotbarContainer = Hotbar:FindFirstChild("Backpack")
    if not hotbarContainer then return false end
    local hotbar = hotbarContainer:FindFirstChild("Hotbar")
    if not hotbar then return false end
    local button = nil
    for _, slot in pairs(hotbar:GetChildren()) do
        if slot:FindFirstChild("ToolName") and slot.ToolName.Text == throwTool.Name then
            button = slot
            break
        end
    end
    if not button then return false end
    MainModule.AutoThrow.LastThrowTime = currentTime
    if not MainModule.ThrowHelper.Enabled then
        MainModule.ThrowHelper_toggleFaceTarget(true, true)
    else
        if not MainModule.ThrowHelper.IsLocked then
            MainModule.ThrowHelper_selectTarget()
        end
    end
    local success = pcall(function()
        for _, connection in pairs(getconnections(button.MouseButton1Down)) do
            connection:Fire()
        end
        task.wait(0.05)
        for _, connection in pairs(getconnections(button.MouseButton1Up)) do
            connection:Fire()
        end
    end)
    if success then
        if MainModule.AutoThrow.TempFaceTask then
            task.cancel(MainModule.AutoThrow.TempFaceTask)
        end
        MainModule.AutoThrow.TempFaceTask = task.delay(1.0, function()
            if MainModule.ThrowHelper.Enabled and MainModule.ThrowHelper.IsLocked then
                MainModule.ThrowHelper_resetTarget()
                task.delay(0.5, function()
                    if MainModule.ThrowHelper.Enabled then
                        MainModule.ThrowHelper_toggleFaceTarget(false)
                    end
                end)
            end
            MainModule.AutoThrow.TempFaceTask = nil
        end)
    end
    return success
end

MainModule.AutoThrow_createMobileButton = function()
    if MainModule.AutoThrow.MobileButton then return end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "HSX_AutoThrowMobile"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = pg
    local btn = Instance.new("TextButton")
    btn.Name = "ThrowBtn"
    btn.Size = UDim2.fromOffset(100, 100)
    btn.Position = UDim2.new(1, -120, 1, -220)
    btn.AnchorPoint = Vector2.new(0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.BackgroundTransparency = 0.15
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "THROW"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.AutoButtonColor = true
    btn.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5
    stroke.Parent = btn
    btn.MouseButton1Click:Connect(function()
        MainModule.AutoThrow_executeThrow()
    end)
    btn.TouchTap:Connect(function()
        MainModule.AutoThrow_executeThrow()
    end)
    MainModule.AutoThrow.MobileButton = gui
end

MainModule.AutoThrow_destroyMobileButton = function()
    if MainModule.AutoThrow.MobileButton then
        pcall(function() MainModule.AutoThrow.MobileButton:Destroy() end)
        MainModule.AutoThrow.MobileButton = nil
    end
end

MainModule.toggle_auto_throw = function(enabled)
    MainModule.AutoThrow.Enabled = enabled and true or false
    if MainModule.AutoThrow.KeybindConnection then
        MainModule.AutoThrow.KeybindConnection:Disconnect()
        MainModule.AutoThrow.KeybindConnection = nil
    end
    MainModule.AutoThrow_destroyMobileButton()
    if enabled then
        pcall(function() MainModule.PushAutoUseTrue("AutoThrow") end)
        MainModule.AutoThrow.KeybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.F then
                MainModule.AutoThrow_executeThrow()
            end
        end)
        -- mobile / touch button always available when enabled
        MainModule.AutoThrow_createMobileButton()
    else
        MainModule.ThrowHelper_resetTarget()
        if MainModule.ThrowHelper.Connection then
            MainModule.ThrowHelper.Connection:Disconnect()
            MainModule.ThrowHelper.Connection = nil
        end
        MainModule.ThrowHelper.Enabled = false
        pcall(function() MainModule.PopAutoUse("AutoThrow") end)
    end
    PlayToggleSound()
    return true
end



MainModule.Fly = {Enabled = false, Speed = 900, Connection = nil, BodyVelocity = nil}

MainModule.toggle_fly = function(enabled, silent)
    if enabled then
        if MainModule.Fly.Enabled then return end
        MainModule.Fly.Enabled = true
        local c = MainModule.get_character()
        if not c then return end
        local h = MainModule.get_humanoid(c)
        local rp = MainModule.get_root_part(c)
        if not (h and rp) then return end

        h.UseJumpPower = false
        h.AutoRotate = false
        h.PlatformStand = true

        if MainModule.Fly.BodyVelocity then MainModule.Fly.BodyVelocity:Destroy() end
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBodyVelocity"
        bv.MaxForce = Vector3.new(40000, 40000, 40000)
        bv.Parent = rp
        MainModule.Fly.BodyVelocity = bv

        MainModule.Fly.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.Fly.Enabled or not c or not c.Parent then
                MainModule.toggle_fly(false, true)
                return
            end
            rp = MainModule.get_root_part(c)
            h = MainModule.get_humanoid(c)
            if not rp or not bv or not h then
                MainModule.toggle_fly(false, true)
                return
            end

            local cam = workspace.CurrentCamera
            if not cam then return end

            local camCF = cam.CFrame
            local forward = camCF.LookVector
            local right = camCF.RightVector
            local up = camCF.UpVector

            local keyPressed = false
            local moveDirection = Vector3.new(0,0,0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + forward; keyPressed = true end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - forward; keyPressed = true end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - right; keyPressed = true end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + right; keyPressed = true end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + up; keyPressed = true end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - up; keyPressed = true end

            if not keyPressed then
                local joyDir = h.MoveDirection
                if joyDir.Magnitude > 0.1 then
                    moveDirection = (forward * joyDir.Z) + (right * joyDir.X) + (up * joyDir.Y)
                    keyPressed = true
                end
            end

            if keyPressed and moveDirection.Magnitude > 0 then
                bv.Velocity = moveDirection.Unit * MainModule.Fly.Speed
            else
                bv.Velocity = Vector3.new(0,0,0)
            end
        end)
        if not silent then end
    else
        if not MainModule.Fly.Enabled then return end
        MainModule.Fly.Enabled = false
        if MainModule.Fly.Connection then MainModule.Fly.Connection:Disconnect(); MainModule.Fly.Connection = nil end
        if MainModule.Fly.BodyVelocity then MainModule.Fly.BodyVelocity:Destroy(); MainModule.Fly.BodyVelocity = nil end
        local c = MainModule.get_character()
        if c then
            local rp = MainModule.get_root_part(c)
            if rp then rp.AssemblyLinearVelocity = Vector3.new(0,0,0) end
            local h = MainModule.get_humanoid(c)
            if h then
                h.UseJumpPower = true
                h.AutoRotate = true
                h.PlatformStand = false
            end
        end
        if not silent then end
    end
    if not silent then PlayToggleSound() end
end

MainModule.set_fly_speed = function(speed)
    MainModule.Fly.Speed = speed
end

MainModule.harmfulEffectsList = {"RagdollStun","Stun","Stunned","StunEffect","StunHit","Knockback","Knockdown","Knockout","Dazed","Paralyzed","Freeze","Frozen","Sleep","Slow","Slowed","Root","Rooted", "Crawling", "Crawled"}
MainModule.RemoveStunEnabled = false

MainModule.toggle_remove_stun = function(enabled)
    MainModule.RemoveStunEnabled = enabled
    if enabled then
        local function remove()
            local c = MainModule.get_character()
            if not c then return end
            for _, e in ipairs(MainModule.harmfulEffectsList) do
                local eff = c:FindFirstChild(e)
                if eff then pcall(function() eff:Destroy() end) end
            end
            local h = MainModule.get_humanoid(c)
            if h and h:GetAttribute("Stunned") then h:SetAttribute("Stunned", false) end
        end
        remove()
        RunService.Heartbeat:Connect(function() if MainModule.RemoveStunEnabled then remove() end end)
    else
    end
    PlayToggleSound()
end

MainModule.SpeedHackEnabled = false
MainModule.SpeedValue = 39
MainModule.SpeedHackLoop = nil

MainModule.toggle_speed_hack = function(enabled)
    MainModule.SpeedHackEnabled = enabled
    if enabled then
        if MainModule.SpeedHackLoop then task.cancel(MainModule.SpeedHackLoop) end
        MainModule.SpeedHackLoop = task.spawn(function()
            while MainModule.SpeedHackEnabled do
                local c = MainModule.get_character()
                if c then
                    local h = MainModule.get_humanoid(c)
                    if h and h.Health > 0 then
                        h.WalkSpeed = MainModule.SpeedValue
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        if MainModule.SpeedHackLoop then task.cancel(MainModule.SpeedHackLoop); MainModule.SpeedHackLoop = nil end
        local c = MainModule.get_character()
        if c then
            local h = MainModule.get_humanoid(c)
            if h then
                h.WalkSpeed = 16
            end
        end
    end
    PlayToggleSound()
end

MainModule.set_speed_value = function(v)
    MainModule.SpeedValue = math.min(v, 50)
    if MainModule.SpeedHackEnabled then
        local c = MainModule.get_character()
        if c then
            local h = MainModule.get_humanoid(c)
            if h and h.Health > 0 then
                h.WalkSpeed = MainModule.SpeedValue
            end
        end
    end
end

MainModule.FOVEnabled = false
MainModule.FOVValue = 120
MainModule.FOVConnection = nil

MainModule.toggle_fov = function(enabled)
    if type(enabled) ~= "boolean" then
        enabled = not MainModule.FOVEnabled
    end
    MainModule.FOVEnabled = enabled
    local cam = workspace.CurrentCamera
    if enabled then
        cam.FieldOfView = MainModule.FOVValue
        if MainModule.FOVConnection then
            MainModule.FOVConnection:Disconnect()
        end
        MainModule.FOVConnection = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            if MainModule.FOVEnabled and cam.FieldOfView ~= MainModule.FOVValue then
                cam.FieldOfView = MainModule.FOVValue
            end
        end)
    else
        if MainModule.FOVConnection then
            MainModule.FOVConnection:Disconnect()
            MainModule.FOVConnection = nil
        end
        cam.FieldOfView = 70
    end
    PlayToggleSound()
end

MainModule.set_fov = function(v)
    MainModule.FOVValue = math.min(v, 120)
    if MainModule.FOVEnabled then
        workspace.CurrentCamera.FieldOfView = MainModule.FOVValue
    end
end

MainModule.AutoQTEMode = "Legit"
MainModule.AutoQTEEnabled = false

MainModule.toggle_auto_qte = function(enabled)
    local toggleRef = MainModule.ToggleRefs.AutoQTE

    if enabled then
        if MainModule.is_xeno_executor() then
            MainModule.notify("Auto QTE", "Not supported in your executor", 0.9)
            PlayErrorSound()
            if toggleRef and toggleRef.SetValue then
                pcall(function() toggleRef:SetValue(false) end)
            end
            return false
        end
    end

    MainModule.AutoQTEEnabled = enabled
    if enabled then
        local ImpactFrames = LocalPlayer.PlayerGui:FindFirstChild("ImpactFrames")
        if ImpactFrames then
            local processed = {}
            ImpactFrames.ChildAdded:Connect(function(outer)
                if outer.Name ~= "OuterRingTemplate" or processed[outer] then return end
                processed[outer] = true
                task.defer(function()
                    local inner = nil
                    for _, g in pairs(ImpactFrames:GetChildren()) do
                        if g.Name == "InnerTemplate" and g.Position == outer.Position and not g:GetAttribute("Failed") then
                            inner = g; break
                        end
                    end
                    if not inner or inner:GetAttribute("Tweening") or inner:GetAttribute("Failed") then return end
                    local HBGQTE = require(ReplicatedStorage.Modules.HBGQTE)
                    if MainModule.AutoQTEMode == "Legit" then
                        pcall(function() HBGQTE.Pressed(false, {Inner=inner, Outer=outer, Duration=2, StartedAt=tick(), Data={}}) end)
                    else
                        pcall(function()
                            HBGQTE.Pressed(true, {Inner=inner, Outer=outer, Duration=0.1, StartedAt=tick(), Data={}})
                        end)
                    end
                end)
            end)
        end
    else
    end
    PlayToggleSound()
    return true
end

MainModule.set_auto_qte_mode = function(mode)
    MainModule.AutoQTEMode = mode
end

MainModule.teleport_up = function()
    local c = MainModule.get_character()
    if c then
        local rp = MainModule.get_root_part(c)
        if rp then rp.CFrame = rp.CFrame + Vector3.new(0,100,0); MainModule.notify("Teleport","Up 100",0.9) end
    end
    PlayBell()
end

MainModule.teleport_down = function()
    local c = MainModule.get_character()
    if c then
        local rp = MainModule.get_root_part(c)
        if rp then rp.CFrame = rp.CFrame + Vector3.new(0,-40,0); MainModule.notify("Teleport","Down 40",0.9) end
    end
    PlayBell()
end

MainModule.GamePassStates = {
    PermanentGuard = false,
    GlassVision = false,
    EmotePages = false,
    CustomPlayerTag = false,
    PrivateServerPlus = false,
    FreeVIP = false,
    Lighter = false
}

MainModule.toggle_permanent_guard = function(enabled)
    MainModule.GamePassStates.PermanentGuard = enabled
    LocalPlayer:SetAttribute("__OwnsPermGuard", enabled)
    PlayToggleSound()
end

MainModule.toggle_glass_vision = function(enabled)
    MainModule.GamePassStates = MainModule.GamePassStates or {}
    MainModule.GamePassStates.GlassVision = enabled and true or false
    MainModule.GlassVisionEnabled = enabled and true or false
    LocalPlayer:SetAttribute("__OwnsGlassManufacturerVision", enabled and true or false)
    PlayToggleSound()
end

MainModule.toggle_emote_pages = function(enabled)
    MainModule.GamePassStates.EmotePages = enabled
    LocalPlayer:SetAttribute("__OwnsEmotePages", enabled)
    PlayToggleSound()
end

MainModule.toggle_custom_player_tag = function(enabled)
    MainModule.GamePassStates.CustomPlayerTag = enabled
    LocalPlayer:SetAttribute("__OwnsCustomPlayerTag", enabled)
    PlayToggleSound()
end

MainModule.toggle_private_server_plus = function(enabled)
    MainModule.GamePassStates.PrivateServerPlus = enabled
    LocalPlayer:SetAttribute("__OwnsPSPlus", enabled)
    PlayToggleSound()
end

MainModule.unlock_vip = function()
    LocalPlayer:SetAttribute("__OwnsVIPGamepass", true)
    LocalPlayer:SetAttribute("__Owns2xVote", true)
    pcall(function() MainModule.GamePassStates.FreeVIP = true end)
    PlayBell()
    HSXNotify("VIP", "Unlocked", 0.9)
end

MainModule.toggle_lighter = function(enabled)
    MainModule.GamePassStates = MainModule.GamePassStates or {}
    MainModule.GamePassStates.Lighter = enabled and true or false
    MainModule.LighterEnabled = enabled and true or false
    LocalPlayer:SetAttribute("HasLighter", enabled and true or false)
    PlayToggleSound()
end

MainModule.LegitHitboxEnabled = false
MainModule.LegitHitboxConn = nil
MainModule.LegitHitboxParts = {}

MainModule.legit_hitbox_enabled = false
MainModule.legit_hitbox_conn = nil
MainModule.legit_hitbox_parts = {}

MainModule.toggle_legit_hitbox = function(enabled)
    MainModule.legit_hitbox_enabled = enabled and true or false
    if MainModule.legit_hitbox_conn then
        pcall(function() MainModule.legit_hitbox_conn:Disconnect() end)
        MainModule.legit_hitbox_conn = nil
    end
    for part, props in pairs(MainModule.legit_hitbox_parts) do
        if part and part.Parent then
            pcall(function()
                part.Size = props.Size
                part.CanCollide = props.CanCollide
                part.Transparency = props.Transparency
            end)
        end
    end
    MainModule.legit_hitbox_parts = {}
    if not enabled then
        PlayToggleSound()
        return true
    end
    local fixedSize = 8
    MainModule.legit_hitbox_conn = RunService.Heartbeat:Connect(function()
        if not MainModule.legit_hitbox_enabled then return end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { myChar }
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local r = p.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    local dir = r.Position - myRoot.Position
                    local dist = dir.Magnitude
                    if dist < 0.1 then dist = 0.1 end
                    local hit = workspace:Raycast(myRoot.Position, dir.Unit * math.min(dist, 400), params)
                    local visible = (not hit) or (hit.Instance and hit.Instance:IsDescendantOf(p.Character))
                    if visible then
                        if not MainModule.legit_hitbox_parts[r] then
                            MainModule.legit_hitbox_parts[r] = {
                                Size = r.Size,
                                CanCollide = r.CanCollide,
                                Transparency = r.Transparency
                            }
                            r.Size = Vector3.new(fixedSize, fixedSize, fixedSize)
                            r.CanCollide = false
                            r.Transparency = 0.45
                        end
                    else
                        local props = MainModule.legit_hitbox_parts[r]
                        if props then
                            r.Size = props.Size
                            r.Transparency = props.Transparency
                            r.CanCollide = props.CanCollide
                            MainModule.legit_hitbox_parts[r] = nil
                        end
                    end
                end
            end
        end
    end)
    PlayToggleSound()
    return true
end

MainModule.InfiniteAmmoEnabled = false
MainModule.OriginalAmmo = {}

MainModule.toggle_infinite_ammo = function(enabled)
    MainModule.InfiniteAmmoEnabled = enabled
    if enabled then
        RunService.Heartbeat:Connect(function()
            if not MainModule.InfiniteAmmoEnabled then return end
            pcall(function()
                local c = MainModule.get_character()
                if c then for _, t in pairs(c:GetChildren()) do if t:IsA("Tool") then for _, o in pairs(t:GetDescendants()) do if (o:IsA("NumberValue") or o:IsA("IntValue")) and (o.Name:lower():find("ammo") or o.Name:lower():find("bullet")) then if not MainModule.OriginalAmmo[o] then MainModule.OriginalAmmo[o] = o.Value end; o.Value = math.huge end end end end end
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then for _, t in pairs(bp:GetChildren()) do if t:IsA("Tool") then for _, o in pairs(t:GetDescendants()) do if (o:IsA("NumberValue") or o:IsA("IntValue")) and (o.Name:lower():find("ammo") or o.Name:lower():find("bullet")) then if not MainModule.OriginalAmmo[o] then MainModule.OriginalAmmo[o] = o.Value end; o.Value = math.huge end end end end end
            end)
        end)
    else
        for o,v in pairs(MainModule.OriginalAmmo) do if o and o.Parent then o.Value = v end end
        MainModule.OriginalAmmo = {}
    end
    PlayToggleSound()
end

MainModule.set_custom_player_tag = function(tagNumber)
    local num = tonumber(tagNumber)
    if num and (0 <= num and num <= 999) then
        local formattedNum = string.format("%03d", num)
        local liveFolder = workspace:FindFirstChild("Live")
        if liveFolder then
            local playerFolder = liveFolder:FindFirstChild(LocalPlayer.Name)
            if playerFolder then
                local playerTags = playerFolder:FindFirstChild("PlayerTags")
                if playerTags then
                    local backTag = playerTags:FindFirstChild("Back")
                    local frontTag = playerTags:FindFirstChild("Front")

                    local backLabel = nil
                    local frontLabel = nil

                    if backTag then
                        local backSurface = backTag:FindFirstChild("SurfaceGui")
                        if backSurface then
                            backLabel = backSurface:FindFirstChild("TextLabel")
                        end
                    end

                    if frontTag then
                        local frontSurface = frontTag:FindFirstChild("SurfaceGui")
                        if frontSurface then
                            frontLabel = frontSurface:FindFirstChild("TextLabel")
                        end
                    end

                    if backLabel and frontLabel then
                        backLabel.Text = formattedNum
                        frontLabel.Text = formattedNum
                    end
                end
            end
        end
    end
    PlayBell()
end

MainModule.CustomPlayerTagEnabled = false
MainModule.CustomPlayerTagValue = "067"
MainModule.CustomPlayerTagConnection = nil

local function FormatTagValue(value)
    local num = tonumber(value)
    if num and num >= 0 and num <= 999 then
        return string.format("%03d", num)
    end
    return "000"
end

MainModule.toggle_custom_player_tag = function(enabled)
    MainModule.CustomPlayerTagEnabled = enabled

    if MainModule.CustomPlayerTagConnection then
        MainModule.CustomPlayerTagConnection:Disconnect()
        MainModule.CustomPlayerTagConnection = nil
    end

    if enabled then
        MainModule.set_custom_player_tag(MainModule.CustomPlayerTagValue)

        MainModule.CustomPlayerTagConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomPlayerTagEnabled then
                local liveFolder = workspace:FindFirstChild("Live")
                if liveFolder then
                    local playerFolder = liveFolder:FindFirstChild(LocalPlayer.Name)
                    if playerFolder then
                        local playerTags = playerFolder:FindFirstChild("PlayerTags")
                        if playerTags then
                            local backTag = playerTags:FindFirstChild("Back")
                            local frontTag = playerTags:FindFirstChild("Front")

                            local backLabel = nil
                            local frontLabel = nil

                            if backTag then
                                local backSurface = backTag:FindFirstChild("SurfaceGui")
                                if backSurface then
                                    backLabel = backSurface:FindFirstChild("TextLabel")
                                end
                            end

                            if frontTag then
                                local frontSurface = frontTag:FindFirstChild("SurfaceGui")
                                if frontSurface then
                                    frontLabel = frontSurface:FindFirstChild("TextLabel")
                                end
                            end

                            if backLabel and frontLabel then
                                local formattedValue = FormatTagValue(MainModule.CustomPlayerTagValue)
                                if backLabel.Text ~= formattedValue then
                                    backLabel.Text = formattedValue
                                end
                                if frontLabel.Text ~= formattedValue then
                                    frontLabel.Text = formattedValue
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        MainModule.set_custom_player_tag(0)
    end
    PlayToggleSound()
end

MainModule.set_custom_tag_value = function(value)
    local formatted = FormatTagValue(value)
    MainModule.CustomPlayerTagValue = formatted
    if MainModule.CustomPlayerTagEnabled then
        MainModule.set_custom_player_tag(tonumber(formatted))
    end
end

MainModule.AutoNextEnabled = false
MainModule.AutoNextConn = nil
MainModule.TargetPos = Vector3.new(-214.30,186.86,242.64)
MainModule.Radius = 80

MainModule.toggle_auto_next_game = function(enabled)
    MainModule.AutoNextEnabled = enabled
    if MainModule.AutoNextConn then MainModule.AutoNextConn:Disconnect(); MainModule.AutoNextConn = nil end
    if enabled then
        local t = 0
        MainModule.AutoNextConn = RunService.Heartbeat:Connect(function(dt)
            if not MainModule.AutoNextEnabled then return end
            local c = LocalPlayer.Character
            local pp = c and c.PrimaryPart and c.PrimaryPart.Position
            if pp and (pp - MainModule.TargetPos).Magnitude <= MainModule.Radius then
                t = t + dt
                if t >= 3.4 then t = 0; pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TemporaryReachedBindable"):FireServer() end) end
            else t = 0 end
        end)
    else
    end
    PlayToggleSound()
end

local FreeDashEnabled = false
local blockedRemotes = {"DashRequest"}

function ToggleFreeDash(enabled)
    FreeDashEnabled = enabled
    MainModule.FreeDashEnabled = enabled

    if enabled then
        local b = LocalPlayer:FindFirstChild("Boosts")
        local fasterSprint = b and b:FindFirstChild("Faster Sprint")

        if not fasterSprint then
            MainModule.notify("Free Dash", "You don't have Faster Sprint boost!", 0.9)
            PlayErrorSound()
            return false
        end

        local currentLevel = fasterSprint.Value
        if currentLevel ~= 5 then
            MainModule.notify("Free Dash", "Your Faster Sprint level is " .. currentLevel .. ", need level 5!", 0.9)
            PlayErrorSound()
            return false
        end

        pcall(function()
            local r = ReplicatedStorage:FindFirstChild("Remotes")
            if r and setrawmetatable then
                for _, remoteName in ipairs(blockedRemotes) do
                    local remote = r:FindFirstChild(remoteName)
                    if remote then
                        setrawmetatable(remote, {__index = function() return function() end end})
                    end
                end
            end

            if b and fasterSprint then
                fasterSprint.Value = 6
            end
        end)
        PlayToggleSound()
        return true
    else
        pcall(function()
            local b = LocalPlayer:FindFirstChild("Boosts")
            if b and b:FindFirstChild("Faster Sprint") then
                local currentValue = b["Faster Sprint"].Value
                if currentValue == 6 then
                    b["Faster Sprint"].Value = 5
                end
            end
        end)
        PlayToggleSound()
        return true
    end
end

MainModule.toggle_free_dash = ToggleFreeDash

MainModule.NoDashPhantomCDEnabled = false
MainModule.NoDashPhantomCDConnection = nil
MainModule.NoDashPhantomCDObj = nil
function MainModule.toggle_no_dash_phantom_cd(enabled)
	MainModule.NoDashPhantomCDEnabled = enabled and true or false
	if MainModule.NoDashPhantomCDConnection then
		pcall(function() MainModule.NoDashPhantomCDConnection:Disconnect() end)
		MainModule.NoDashPhantomCDConnection = nil
	end
	MainModule.NoDashPhantomCDObj = nil
	if enabled then
		local targetObj = nil
		pcall(function()
			for _, obj in pairs(getgc(true)) do
				if type(obj) == "table" and rawget(obj, "CDDASHSTACKS") and rawget(obj, "StopCounter") then
					targetObj = obj
					break
				end
			end
		end)
		MainModule.NoDashPhantomCDObj = targetObj
		if targetObj then
			MainModule.NoDashPhantomCDConnection = RunService.RenderStepped:Connect(function()
				if not MainModule.NoDashPhantomCDEnabled then return end
				local obj = MainModule.NoDashPhantomCDObj
				if not obj then return end
				pcall(function()
					rawset(obj, "DashCD", nil)
					if rawget(obj, "CDDASHSTACKS") and rawget(obj, "CDDASHSTACKS") > 1 then
						rawset(obj, "CDDASHSTACKS", 1)
					end
				end)
			end)
		else
			MainModule.NoDashPhantomCDConnection = RunService.Heartbeat:Connect(function()
				if not MainModule.NoDashPhantomCDEnabled then return end
				if MainModule.NoDashPhantomCDObj then return end
				pcall(function()
					for _, obj in pairs(getgc(true)) do
						if type(obj) == "table" and rawget(obj, "CDDASHSTACKS") and rawget(obj, "StopCounter") then
							MainModule.NoDashPhantomCDObj = obj
							if MainModule.NoDashPhantomCDConnection then
								pcall(function() MainModule.NoDashPhantomCDConnection:Disconnect() end)
							end
							MainModule.NoDashPhantomCDConnection = RunService.RenderStepped:Connect(function()
								if not MainModule.NoDashPhantomCDEnabled then return end
								local o = MainModule.NoDashPhantomCDObj
								if not o then return end
								pcall(function()
									rawset(o, "DashCD", nil)
									if rawget(o, "CDDASHSTACKS") and rawget(o, "CDDASHSTACKS") > 1 then
										rawset(o, "CDDASHSTACKS", 1)
									end
								end)
							end)
							break
						end
					end
				end)
			end)
		end
	end
	PlayToggleSound()
	return true
end


MainModule.FasterSprintEnabled = false
MainModule.FasterSprintLoop = nil
_G.FasterSprintEnabled = false

function MainModule.toggle_faster_sprint(enabled)
	enabled = enabled and true or false
	MainModule.FasterSprintEnabled = enabled
	_G.FasterSprintEnabled = enabled
	if MainModule.FasterSprintLoop then
		pcall(task.cancel, MainModule.FasterSprintLoop)
		MainModule.FasterSprintLoop = nil
	end
	if enabled then
		MainModule.FasterSprintLoop = task.spawn(function()
			local lp = LocalPlayer
			while MainModule.FasterSprintEnabled do
				local char = lp.Character
				if char and char.Parent then
					if not char:FindFirstChild("FASTERSPRINT") then
						local fasterSprintFolder = Instance.new("Folder")
						fasterSprintFolder.Name = "FASTERSPRINT"
						fasterSprintFolder.Parent = char
					end
					local lagFolder = char:FindFirstChild("DelIfGone_Folder")
					if lagFolder then
						lagFolder:Destroy()
					end
					local stamina = char:FindFirstChild("StaminaVal")
					if stamina then
						stamina.Value = 100
					end
					local children = char:GetChildren()
					local target36 = children[36]
					if target36 and not char:FindFirstChild(target36.Name) then
						local targetFolder = Instance.new("Folder")
						targetFolder.Name = target36.Name
						targetFolder.Parent = char
					end
				end
				task.wait()
			end
		end)
	end
	PlayToggleSound()
	return true
end


MainModule.AmbienceEnabled = false
MainModule.motionBlur = nil
MainModule.blurAmount = 12
MainModule.blurAmplifier = 12
MainModule.lastVector = nil
MainModule.originalTimeOfDay = nil
MainModule.ambienceConnection = nil
MainModule.timeFixConnection = nil

MainModule.toggle_ambience = function(enabled)
    MainModule.AmbienceEnabled = enabled

    if enabled then
        local camera = workspace.CurrentCamera
        MainModule.lastVector = camera.CFrame.LookVector

        if MainModule.motionBlur and MainModule.motionBlur.Parent then
            MainModule.motionBlur:Destroy()
        end

        MainModule.motionBlur = Instance.new("BlurEffect", camera)

        local Lighting = game:GetService("Lighting")
        MainModule.originalTimeOfDay = Lighting.TimeOfDay

        Lighting.TimeOfDay = "22:00:00"

        if MainModule.timeFixConnection then
            MainModule.timeFixConnection:Disconnect()
        end

        MainModule.timeFixConnection = Lighting.Changed:Connect(function(property)
            if property == "TimeOfDay" and MainModule.AmbienceEnabled then
                Lighting.TimeOfDay = "22:00:00"
            end
        end)

        if MainModule.ambienceConnection then
            MainModule.ambienceConnection:Disconnect()
        end

        MainModule.ambienceConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.AmbienceEnabled then return end

            local camera = workspace.CurrentCamera
            if not camera then return end

            if not MainModule.motionBlur or MainModule.motionBlur.Parent == nil then
                MainModule.motionBlur = Instance.new("BlurEffect", camera)
            end

            local currentVector = camera.CFrame.LookVector
            local magnitude = (currentVector - MainModule.lastVector).magnitude
            MainModule.motionBlur.Size = math.abs(magnitude) * MainModule.blurAmount * MainModule.blurAmplifier / 2
            MainModule.lastVector = currentVector
        end)

        workspace.Changed:Connect(function(property)
            if property == "CurrentCamera" and MainModule.AmbienceEnabled then
                local camera = workspace.CurrentCamera
                if MainModule.motionBlur and MainModule.motionBlur.Parent then
                    MainModule.motionBlur.Parent = camera
                else
                    MainModule.motionBlur = Instance.new("BlurEffect", camera)
                end
            end
        end)

    else
        if MainModule.motionBlur then
            MainModule.motionBlur:Destroy()
            MainModule.motionBlur = nil
        end

        if MainModule.ambienceConnection then
            MainModule.ambienceConnection:Disconnect()
            MainModule.ambienceConnection = nil
        end

        if MainModule.timeFixConnection then
            MainModule.timeFixConnection:Disconnect()
            MainModule.timeFixConnection = nil
        end

        local Lighting = game:GetService("Lighting")
        if MainModule.originalTimeOfDay then
            Lighting.TimeOfDay = MainModule.originalTimeOfDay
        end

    end

    PlayToggleSound()
end

MainModule.ExitDoorESPEnabled = false
MainModule.ExitDoorESPThread = nil
MainModule.ExitDoorESPObjects = {}

function MainModule.toggle_exit_door_esp(enabled)
    MainModule.ExitDoorESPEnabled = enabled

    if enabled then
        if MainModule.ExitDoorESPThread then
            task.cancel(MainModule.ExitDoorESPThread)
        end

        MainModule.ExitDoorESPThread = task.spawn(function()
            local espDoors = {}

            local function createDoorESP(model)
                local cf, size = model:GetBoundingBox()

                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if not box.Adornee then return nil end
                box.Size = size
                box.Color3 = Color3.fromRGB(255, 255, 0)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Parent = box.Adornee

                local billboard = Instance.new("BillboardGui")
                billboard.Adornee = box.Adornee
                billboard.Size = UDim2.new(0, 100, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = box.Adornee

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = "EXIT DOOR"
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                textLabel.TextScaled = true
                textLabel.Font = Enum.Font.SourceSansBold
                textLabel.Parent = billboard

                return {box = box, billboard = billboard, part = box.Adornee}
            end

            while MainModule.ExitDoorESPEnabled do
                for _, obj in pairs(espDoors) do
                    if obj.box and (not obj.part or not obj.part.Parent) then
                        pcall(function() obj.box:Destroy() end)
                        pcall(function() obj.billboard:Destroy() end)
                    end
                end

                local hideMap = workspace:FindFirstChild("HideAndSeekMap")
                if hideMap then
                    local function findDoors(parent)
                        for _, child in pairs(parent:GetChildren()) do
                            if child.Name == "EXITDOOR" and child:GetAttribute("ActuallyWorks") == true then
                                if not espDoors[child] then
                                    local esp = createDoorESP(child)
                                    if esp then
                                        espDoors[child] = esp
                                    end
                                end
                            end
                            findDoors(child)
                        end
                    end
                    findDoors(hideMap)
                end

                task.wait(0.5)
            end
        end)
    else
        if MainModule.ExitDoorESPThread then
            task.cancel(MainModule.ExitDoorESPThread)
            MainModule.ExitDoorESPThread = nil
        end
    end
    PlayToggleSound()
end

MainModule.Misc = {
    ESPEnabled = false,
    ESPPlayers = true,
    ESPHiders = true,
    ESPSeekers = true,
    ESPNames = true,
    ESPDistance = true,
    ESPHighlight = true,
    ESPFillTransparency = 0.75,
    ESPOutlineTransparency = 0.2,
    ESPTextSize = 14
}

MainModule.ESP = {
    Players = {},
    Objects = {},
    Connections = {},
    Folder = nil,
    MainConnection = nil,
    UpdateRate = 0.1
}

function MainModule.clear_player_esp(player)
    if not player then return end
    local espData = MainModule.ESP.Players[player]
    if espData then
        if espData.Highlight then
            espData.Highlight.Adornee = nil
            pcall(function() espData.Highlight:Destroy() end)
        end
        if espData.Billboard then
            pcall(function() espData.Billboard:Destroy() end)
        end
        if espData.CharAddedConn then
            pcall(function() espData.CharAddedConn:Disconnect() end)
            espData.CharAddedConn = nil
        end
        if espData.DiedConn then
            pcall(function() espData.DiedConn:Disconnect() end)
            espData.DiedConn = nil
        end
        MainModule.ESP.Players[player] = nil
    end
end

function MainModule.update_player_esp(player)
    if not player or player == LocalPlayer or not MainModule.Misc.ESPEnabled then return end

    local character = player.Character
    if not character then
        MainModule.clear_player_esp(player)
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoid and rootPart and humanoid.Health > 0 then
        local espData = MainModule.ESP.Players[player]

        if not espData then
            espData = {
                Player = player,
                Highlight = nil,
                Billboard = nil,
                Label = nil,
                CharAddedConn = nil,
                DiedConn = nil
            }
            MainModule.ESP.Players[player] = espData

            espData.DiedConn = humanoid.Died:Connect(function()
                if espData.Highlight then
                    espData.Highlight.Adornee = nil
                    espData.Highlight.Enabled = false
                end
                if espData.Billboard then
                    espData.Billboard.Enabled = false
                end
            end)
        end

        if not espData.Highlight then
            espData.Highlight = Instance.new("Highlight")
            espData.Highlight.Name = player.Name .. "_ESP"
            espData.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            espData.Highlight.Enabled = true
            espData.Highlight.Parent = MainModule.ESP.Folder or CoreGui
        end

        if espData.Highlight.Adornee ~= character then
            espData.Highlight.Adornee = character
        end

        local color = Color3.fromRGB(0, 120, 255)
        if MainModule.is_hider and MainModule.is_hider(player) then
            color = Color3.fromRGB(0, 255, 0)
        elseif MainModule.is_seeker and MainModule.is_seeker(player) then
            color = Color3.fromRGB(255, 0, 0)
        end

        espData.Highlight.FillColor = color
        espData.Highlight.OutlineColor = color
        espData.Highlight.FillTransparency = MainModule.Misc.ESPFillTransparency
        espData.Highlight.OutlineTransparency = MainModule.Misc.ESPOutlineTransparency
        espData.Highlight.Enabled = true

        if MainModule.Misc.ESPNames then
            if not espData.Billboard then
                espData.Billboard = Instance.new("BillboardGui")
                espData.Billboard.Name = player.Name .. "_Text"
                espData.Billboard.AlwaysOnTop = true
                espData.Billboard.Size = UDim2.new(0, 200, 0, 50)
                espData.Billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                espData.Billboard.Parent = MainModule.ESP.Folder or CoreGui

                espData.Label = Instance.new("TextLabel")
                espData.Label.Size = UDim2.new(1, 0, 1, 0)
                espData.Label.BackgroundTransparency = 1
                espData.Label.TextColor3 = color
                espData.Label.TextSize = 14
                espData.Label.Font = Enum.Font.GothamBold
                espData.Label.TextStrokeColor3 = Color3.new(0, 0, 0)
                espData.Label.TextStrokeTransparency = 0.5
                espData.Label.Parent = espData.Billboard
            end

            if espData.Billboard.Adornee ~= rootPart then
                espData.Billboard.Adornee = rootPart
            end

            espData.Billboard.Enabled = true
            local healthText = string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
            local nameText = player.DisplayName or player.Name
            espData.Label.Text = nameText .. "\n" .. healthText
            espData.Label.TextColor3 = color
        elseif espData.Billboard then
            espData.Billboard.Enabled = false
        end
    else
        local espData = MainModule.ESP.Players[player]
        if espData then
            if espData.Highlight then
                espData.Highlight.Enabled = false
                espData.Highlight.Adornee = nil
            end
            if espData.Billboard then
                espData.Billboard.Enabled = false
                espData.Billboard.Adornee = nil
            end
        end
    end
end

function MainModule.setup_player_esp(player)
    if player == LocalPlayer then return end

    MainModule.clear_player_esp(player)

    if player.Character then
        MainModule.update_player_esp(player)
    end

    local charAddedConn = player.CharacterAdded:Connect(function(character)
        task.wait(0.05)
        MainModule.update_player_esp(player)
    end)

    local espData = MainModule.ESP.Players[player]
    if espData then
        espData.CharAddedConn = charAddedConn
    end
end

--@encrypt_start
function MainModule.toggle_old_esp(enabled)
    if Encrypt and Encrypt.start then pcall(Encrypt.start) end
    MainModule.Misc.ESPEnabled = enabled

    if MainModule.ESP.MainConnection then
        MainModule.ESP.MainConnection:Disconnect()
        MainModule.ESP.MainConnection = nil
    end

    MainModule.clear_esp()

    if enabled then
        MainModule.ESP.Folder = Instance.new("Folder")
        MainModule.ESP.Folder.Name = "HollyScriptX_ESP"
        MainModule.ESP.Folder.Parent = CoreGui

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                MainModule.setup_player_esp(player)
            end
        end

        MainModule.ESP.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
            if MainModule.Misc.ESPEnabled then
                MainModule.setup_player_esp(player)
            end
        end)

        MainModule.ESP.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
            MainModule.clear_player_esp(player)
        end)

        MainModule.ESP.MainConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.Misc.ESPEnabled then return end
            for player, espData in pairs(MainModule.ESP.Players) do
                if player and player.Parent then
                    MainModule.update_player_esp(player)
                else
                    MainModule.clear_player_esp(player)
                end
            end
        end)
    end
    PlayToggleSound()
    if Encrypt and Encrypt["end"] then pcall(Encrypt["end"]) end
end
--@encrypt_end

function MainModule.clear_esp()
    for player, _ in pairs(MainModule.ESP.Players) do
        MainModule.clear_player_esp(player)
    end
    MainModule.ESP.Players = {}

    if MainModule.ESP.Connections then
        for name, connection in pairs(MainModule.ESP.Connections) do
            if connection then
                pcall(function() connection:Disconnect() end)
                MainModule.ESP.Connections[name] = nil
            end
        end
    end

    if MainModule.ESP.Folder then
        pcall(function() MainModule.ESP.Folder:Destroy() end)
        MainModule.ESP.Folder = nil
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

MainModule = MainModule or {}

local function PlayToggleSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://99979147606311"
    sound.Volume = 5
    sound.Parent = SoundService
    sound:Play()

    sound.Ended:Once(function()
        sound:Destroy()
    end)
end

local NewESP = {
    Enabled = false,
    RGB = false,
    Cache = {},
    Connection = nil
}

local oldGui = CoreGui:FindFirstChild("NewESP")

if oldGui then
    oldGui:Destroy()
end

NewESP.ScreenGui = Instance.new("ScreenGui")
NewESP.ScreenGui.Name = "NewESP"
NewESP.ScreenGui.ResetOnSpawn = false
NewESP.ScreenGui.IgnoreGuiInset = true
NewESP.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NewESP.ScreenGui.DisplayOrder = 999999
NewESP.ScreenGui.Parent = CoreGui

local function GetRole(player, character)
    if not player or not character then
        return nil
    end

    local hunter =
        player:GetAttribute("Hunter") == true
        or player:GetAttribute("IsHunter") == true
        or character:GetAttribute("Hunter") == true
        or character:GetAttribute("IsHunter") == true

    local hider =
        player:GetAttribute("Hider") == true
        or player:GetAttribute("IsHider") == true
        or character:GetAttribute("Hider") == true
        or character:GetAttribute("IsHider") == true

    if hunter then
        return "Hunter"
    end

    if hider then
        return "Hider"
    end

    return nil
end

local function GetESPColor(player, character)
    local role = GetRole(player, character)

    if role == "Hunter" then
        return Color3.fromRGB(255, 65, 65)
    end

    if role == "Hider" then
        return Color3.fromRGB(65, 145, 255)
    end

    if NewESP.RGB then
        return Color3.fromHSV(
            (os.clock() * 0.35) % 1,
            0.9,
            1
        )
    end

    return Color3.fromRGB(235, 235, 240)
end

local function GetHealthColor(percent)
    if percent > 0.6 then
        return Color3.fromRGB(40, 240, 80)
    elseif percent > 0.3 then
        return Color3.fromRGB(255, 215, 40)
    end

    return Color3.fromRGB(255, 55, 55)
end

function NewESP.Hide(esp)
    if not esp then
        return
    end

    if esp.Box then
        esp.Box.Visible = false
    end

    if esp.Name then
        esp.Name.Visible = false
    end

    if esp.HealthText then
        esp.HealthText.Visible = false
    end

    if esp.HealthBg then
        esp.HealthBg.Visible = false
    end

    if esp.HealthBar then
        esp.HealthBar.Visible = false
    end
end

function NewESP.HideAll()
    for _, esp in pairs(NewESP.Cache) do
        NewESP.Hide(esp)
    end
end

function NewESP.DestroyESP(esp)
    if not esp then
        return
    end

    pcall(function()
        if esp.Box then
            esp.Box:Destroy()
        end

        if esp.Name then
            esp.Name:Destroy()
        end

        if esp.HealthText then
            esp.HealthText:Destroy()
        end

        if esp.HealthBg then
            esp.HealthBg:Destroy()
        end

        if esp.HealthBar then
            esp.HealthBar:Destroy()
        end
    end)
end

function NewESP.ClearAll()
    for _, esp in pairs(NewESP.Cache) do
        NewESP.DestroyESP(esp)
    end

    table.clear(NewESP.Cache)
end

function NewESP.Create(player)
    if NewESP.Cache[player] then
        return NewESP.Cache[player]
    end

    local esp = {}

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 10
    box.Parent = NewESP.ScreenGui

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Transparency = 0
    boxStroke.Color = Color3.fromRGB(235, 235, 240)
    boxStroke.Parent = box

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.BackgroundTransparency = 1
    nameLabel.BorderSizePixel = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
    nameLabel.TextStrokeTransparency = 0.25
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Visible = false
    nameLabel.ZIndex = 11
    nameLabel.Parent = NewESP.ScreenGui

    local healthText = Instance.new("TextLabel")
    healthText.Name = "Health"
    healthText.BackgroundTransparency = 1
    healthText.BorderSizePixel = 0
    healthText.Font = Enum.Font.Gotham
    healthText.TextSize = 11
    healthText.TextColor3 = Color3.fromRGB(235, 235, 240)
    healthText.TextStrokeTransparency = 0.25
    healthText.TextStrokeColor3 = Color3.new(0, 0, 0)
    healthText.TextXAlignment = Enum.TextXAlignment.Center
    healthText.Visible = false
    healthText.ZIndex = 11
    healthText.Parent = NewESP.ScreenGui

    local healthBg = Instance.new("Frame")
    healthBg.Name = "HealthBackground"
    healthBg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    healthBg.BorderSizePixel = 0
    healthBg.Visible = false
    healthBg.ZIndex = 10
    healthBg.Parent = NewESP.ScreenGui

    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Visible = false
    healthBar.ZIndex = 11
    healthBar.Parent = NewESP.ScreenGui

    esp.Box = box
    esp.BoxStroke = boxStroke
    esp.Name = nameLabel
    esp.HealthText = healthText
    esp.HealthBg = healthBg
    esp.HealthBar = healthBar

    NewESP.Cache[player] = esp

    return esp
end

local BoundingParts = {
    "Head",
    "HumanoidRootPart",
    "UpperTorso",
    "LowerTorso",
    "Torso",
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftHand",
    "RightUpperArm",
    "RightLowerArm",
    "RightHand",
    "LeftUpperLeg",
    "LeftLowerLeg",
    "LeftFoot",
    "RightUpperLeg",
    "RightLowerLeg",
    "RightFoot",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Right Leg"
}

local function GetScreenBounds(character, camera)
    local minX = math.huge
    local minY = math.huge

    local maxX = -math.huge
    local maxY = -math.huge

    local found = false

    for _, name in ipairs(BoundingParts) do
        local part = character:FindFirstChild(name)

        if part and part:IsA("BasePart") then
            local cf = part.CFrame
            local size = part.Size

            local x = size.X / 2
            local y = size.Y / 2
            local z = size.Z / 2

            local corners = {
                Vector3.new(-x, -y, -z),
                Vector3.new(-x, -y, z),
                Vector3.new(-x, y, -z),
                Vector3.new(-x, y, z),

                Vector3.new(x, -y, -z),
                Vector3.new(x, -y, z),
                Vector3.new(x, y, -z),
                Vector3.new(x, y, z)
            }

            for _, offset in ipairs(corners) do
                local worldPosition = cf:PointToWorldSpace(offset)
                local screenPosition = camera:WorldToViewportPoint(worldPosition)

                if screenPosition.Z > 0 then
                    found = true

                    minX = math.min(minX, screenPosition.X)
                    minY = math.min(minY, screenPosition.Y)

                    maxX = math.max(maxX, screenPosition.X)
                    maxY = math.max(maxY, screenPosition.Y)
                end
            end
        end
    end

    if not found then
        return nil
    end

    local width = maxX - minX
    local height = maxY - minY

    if width < 2 or height < 2 then
        return nil
    end

    local paddingX = math.max(2, width * 0.05)
    local paddingY = math.max(2, height * 0.025)

    minX -= paddingX
    maxX += paddingX

    minY -= paddingY
    maxY += paddingY

    return minX, minY, maxX, maxY
end

function NewESP.Update()
    if not NewESP.Enabled then
        NewESP.HideAll()
        return
    end

    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    local activePlayers = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character

            local humanoid =
                character
                and character:FindFirstChildOfClass("Humanoid")

            local root =
                character
                and character:FindFirstChild("HumanoidRootPart")

            if character
                and humanoid
                and root
                and humanoid.Health > 0
                and root.Position.Y > -50
            then
                activePlayers[player] = true

                local esp =
                    NewESP.Cache[player]
                    or NewESP.Create(player)

                local minX, minY, maxX, maxY =
                    GetScreenBounds(character, camera)

                if minX then
                    local width = maxX - minX
                    local height = maxY - minY

                    local centerX =
                        minX + width / 2

                    local espColor =
                        GetESPColor(
                            player,
                            character
                        )

                    esp.Box.Position =
                        UDim2.fromOffset(
                            math.floor(minX),
                            math.floor(minY)
                        )

                    esp.Box.Size =
                        UDim2.fromOffset(
                            math.floor(width),
                            math.floor(height)
                        )

                    esp.BoxStroke.Color =
                        espColor

                    esp.Box.Visible = true

                    local displayName =
                        player.DisplayName

                    if not displayName
                        or displayName == ""
                    then
                        displayName = player.Name
                    end

                    esp.Name.Text = displayName
                    esp.Name.TextColor3 = espColor

                    local nameWidth =
                        math.max(
                            width + 80,
                            130
                        )

                    esp.Name.Size =
                        UDim2.fromOffset(
                            nameWidth,
                            18
                        )

                    esp.Name.Position =
                        UDim2.fromOffset(
                            centerX - nameWidth / 2,
                            minY - 20
                        )

                    esp.Name.Visible = true

                    local healthPercent = 0

                    if humanoid.MaxHealth > 0 then
                        healthPercent =
                            math.clamp(
                                humanoid.Health
                                / humanoid.MaxHealth,
                                0,
                                1
                            )
                    end

                    local barWidth = 3

                    local barX =
                        minX - 7

                    esp.HealthBg.Position =
                        UDim2.fromOffset(
                            barX - 1,
                            minY - 1
                        )

                    esp.HealthBg.Size =
                        UDim2.fromOffset(
                            barWidth + 2,
                            height + 2
                        )

                    esp.HealthBg.Visible = true

                    local healthHeight =
                        height * healthPercent

                    esp.HealthBar.Position =
                        UDim2.fromOffset(
                            barX,
                            maxY - healthHeight
                        )

                    esp.HealthBar.Size =
                        UDim2.fromOffset(
                            barWidth,
                            healthHeight
                        )

                    esp.HealthBar.BackgroundColor3 =
                        GetHealthColor(
                            healthPercent
                        )

                    esp.HealthBar.Visible = true

                    esp.HealthText.Text =
                        math.floor(humanoid.Health)
                        .. " / "
                        .. math.floor(humanoid.MaxHealth)

                    local hpTextWidth =
                        math.max(
                            width + 80,
                            120
                        )

                    esp.HealthText.Size =
                        UDim2.fromOffset(
                            hpTextWidth,
                            16
                        )

                    esp.HealthText.Position =
                        UDim2.fromOffset(
                            centerX - hpTextWidth / 2,
                            maxY + 2
                        )

                    esp.HealthText.Visible = true
                else
                    NewESP.Hide(esp)
                end
            end
        end
    end

    for player, esp in pairs(NewESP.Cache) do
        if not activePlayers[player] then
            NewESP.DestroyESP(esp)
            NewESP.Cache[player] = nil
        end
    end
end

--@encrypt_start
function MainModule.toggle_new_esp(enabled)
    if Encrypt and Encrypt.start then pcall(Encrypt.start) end
    NewESP.Enabled = enabled and true or false
    if NewESP.Enabled then
        if not NewESP.Connection then
            NewESP.Connection = RunService.RenderStepped:Connect(function()
                local ok, err = pcall(NewESP.Update)
                if not ok then
                    warn("[NewESP]", err)
                end
            end)
        end
    else
        if NewESP.Connection then
            NewESP.Connection:Disconnect()
            NewESP.Connection = nil
        end
        NewESP.HideAll()
        NewESP.ClearAll()
    end
    PlayToggleSound()
    if Encrypt and Encrypt["end"] then pcall(Encrypt["end"]) end
end
--@encrypt_end

function MainModule.toggle_esprgb(enabled)
    NewESP.RGB = enabled and true or false
end

MainModule.PlayerESPEnabled = MainModule.PlayerESPEnabled or false
MainModule.ESPRGBEnabled = MainModule.ESPRGBEnabled or false
MainModule.ESP_Mode = MainModule.ESP_Mode or "New"

function MainModule.set_esp_mode(mode)
    MainModule.ESP_Mode = mode
    MainModule.toggle_new_esp(false)
    if MainModule.toggle_old_esp then
        MainModule.toggle_old_esp(false)
    end
    if MainModule.PlayerESPEnabled then
        if mode == "New" then
            MainModule.toggle_new_esp(true)
        elseif mode == "Old" and MainModule.toggle_old_esp then
            MainModule.toggle_old_esp(true)
        end
    end
    PlayToggleSound()
end

function MainModule.toggle_player_esp(enabled)
    MainModule.PlayerESPEnabled = enabled and true or false
    if enabled then
        if MainModule.ESP_Mode == "New" then
            MainModule.toggle_new_esp(true)
        elseif MainModule.toggle_old_esp then
            MainModule.toggle_old_esp(true)
        end
    else
        MainModule.toggle_new_esp(false)
        if MainModule.toggle_old_esp then
            MainModule.toggle_old_esp(false)
        end
    end
    PlayToggleSound()
end

MainModule.AutoSafe = {
    Enabled = false,
    Connection = nil,
    HasTeleported = false,
    LowHPChecked = false
}

MainModule.toggle_auto_safe = function(enabled)
    if MainModule.AutoSafe.Connection then
        MainModule.AutoSafe.Connection:Disconnect()
        MainModule.AutoSafe.Connection = nil
    end

    MainModule.AutoSafe.Enabled = enabled
    MainModule.AutoSafe.HasTeleported = false
    MainModule.AutoSafe.LowHPChecked = false

    if enabled then
        MainModule.AutoSafe.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.AutoSafe.Enabled then
                if MainModule.AutoSafe.Connection then
                    MainModule.AutoSafe.Connection:Disconnect()
                    MainModule.AutoSafe.Connection = nil
                end
                return
            end

            local noSafeGames = {
                "Mingle",
                "JumpRope",
                "Pentathlon",
                "GlassBridge",
                "SquidGame",
                "SkySquidGame",
                "RedLightGreenLight",
                "TugOfWar"
            }

            local isNoSafeGame = false
            for _, gameName in pairs(noSafeGames) do
                if MainModule.is_game_active(gameName) then
                    isNoSafeGame = true
                    break
                end
            end

            if isNoSafeGame then
                return
            end

            local character = MainModule.get_character()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if MainModule.is_game_active("HideAndSeek") or MainModule.is_game_active("LightsOut") or MainModule.is_game_active("LightOut") then
                        if humanoid.Health <= 30 then
                            if not MainModule.AutoSafe.HasTeleported then
                                local rootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
                                if rootPart then
                                    local currentPosition = rootPart.Position
                                    local newPosition = Vector3.new(
                                        currentPosition.X,
                                        currentPosition.Y + 150,
                                        currentPosition.Z
                                    )
                                    rootPart.CFrame = CFrame.new(newPosition)

                                    MainModule.AutoSafe.HasTeleported = true
                                    MainModule.AutoSafe.LowHPChecked = true
                                end
                            end
                        elseif humanoid.Health > 30 and MainModule.AutoSafe.HasTeleported then
                            MainModule.AutoSafe.HasTeleported = false
                        end
                    else
                        if humanoid.Health <= 30 then
                            if not MainModule.AutoSafe.HasTeleported then
                                local rootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
                                if rootPart then
                                    local currentPosition = rootPart.Position
                                    local newPosition = Vector3.new(
                                        currentPosition.X,
                                        currentPosition.Y + 100,
                                        currentPosition.Z
                                    )
                                    rootPart.CFrame = CFrame.new(newPosition)

                                    MainModule.AutoSafe.HasTeleported = true
                                    MainModule.AutoSafe.LowHPChecked = true
                                end
                            end
                        elseif humanoid.Health > 30 and MainModule.AutoSafe.HasTeleported then
                            MainModule.AutoSafe.HasTeleported = false
                        end
                    end
                end
            end
        end)
    else
    end
    PlayToggleSound()
end

MainModule.dalgona_lighter = function()
    if MainModule.is_game_active("Dalgona") then
        LocalPlayer:SetAttribute("HasLighter", true)
    else
        MainModule.notify("Dalgona","Wait for Dalgona!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.AutoCollectFlashbang = false
MainModule.AutoCollectFlashbangLoop = nil

MainModule.toggle_auto_collect_flashbang = function(enabled)
    MainModule.AutoCollectFlashbang = enabled

    if MainModule.AutoCollectFlashbangLoop then
        task.cancel(MainModule.AutoCollectFlashbangLoop)
        MainModule.AutoCollectFlashbangLoop = nil
    end

    if enabled then
        MainModule.AutoCollectFlashbangLoop = task.spawn(function()
            while MainModule.AutoCollectFlashbang do
                local character = MainModule.get_character()
                if not character then task.wait(0.5) goto HSX_CONT_128 end
                local rootPart = MainModule.get_root_part(character)
                if not rootPart then task.wait(0.5) goto HSX_CONT_128 end

                local startCF = rootPart.CFrame

                if not MainModule.has_tool("Flashbang") then
                    local found = false
                    local effects = workspace:FindFirstChild("Effects")
                    if effects then
                        for _, effect in pairs(effects:GetChildren()) do
                            if effect.Name == "DroppedFlashbang" and effect:FindFirstChild("Stun Grenade") then
                                rootPart.CFrame = effect["Stun Grenade"].CFrame
                                found = true
                                break
                            end
                        end
                    end
                    if found then
                        task.wait(0.3)
                        rootPart.CFrame = startCF
                    end
                end
                task.wait(0.5)
                ::HSX_CONT_128::
            end
        end)
    else
    end
    PlayToggleSound()
end

MainModule.AutoCollectGrenade = false
MainModule.AutoCollectGrenadeLoop = nil

MainModule.toggle_auto_collect_grenade = function(enabled)
    MainModule.AutoCollectGrenade = enabled

    if MainModule.AutoCollectGrenadeLoop then
        task.cancel(MainModule.AutoCollectGrenadeLoop)
        MainModule.AutoCollectGrenadeLoop = nil
    end

    if enabled then
        MainModule.AutoCollectGrenadeLoop = task.spawn(function()
            while MainModule.AutoCollectGrenade do
                local character = MainModule.get_character()
                if not character then task.wait(0.5) goto HSX_CONT_130 end
                local rootPart = MainModule.get_root_part(character)
                if not rootPart then task.wait(0.5) goto HSX_CONT_130 end

                local startCF = rootPart.CFrame

                if not MainModule.has_tool("Grenade") then
                    local found = false
                    local effects = workspace:FindFirstChild("Effects")
                    if effects then
                        for _, effect in pairs(effects:GetChildren()) do
                            if effect.Name == "DroppedGrenade" and effect:FindFirstChild("Handle") then
                                rootPart.CFrame = effect.Handle.CFrame
                                found = true
                                break
                            end
                        end
                    end
                    if found then
                        task.wait(0.3)
                        rootPart.CFrame = startCF
                    end
                end
                task.wait(0.5)
                ::HSX_CONT_130::
            end
        end)
    else
    end
    PlayToggleSound()
end

MainModule.jr_tp_start = function()
    if MainModule.is_game_active("JumpRope") then
        MainModule.safe_teleport(Vector3.new(615.284424,192.274277,920.952515))
        MainModule.notify("JumpRope","Teleported to Start",0.9)
    else
        MainModule.notify("JumpRope","Wait for JumpRope!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.jr_tp_end = function()
    if MainModule.is_game_active("JumpRope") then
        MainModule.safe_teleport(Vector3.new(720.896057,198.628311,921.170654))
        MainModule.notify("JumpRope","Teleported to End",0.9)
    else
        MainModule.notify("JumpRope","Wait for JumpRope!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.jr_delete_rope = function()
    if MainModule.is_game_active("JumpRope") then
        for _,o in pairs(workspace:GetDescendants()) do
            if o.Name == "Rope" and (o:IsA("Model") or o:IsA("Part")) then
                o:Destroy()
                MainModule.notify("JumpRope","Rope deleted",0.9)
                PlayBell()
                return
            end
        end
        MainModule.notify("JumpRope","Rope not found",0.9)
        PlayErrorSound()
    else
        MainModule.notify("JumpRope","Wait for JumpRope!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.GlobalAntiFall = { Enabled = false, Platform = nil, Conn = nil }

function MainModule.toggle_global_anti_fall(enabled)
    MainModule.GlobalAntiFall.Enabled = enabled and true or false
    if MainModule.GlobalAntiFall.Conn then
        pcall(function() MainModule.GlobalAntiFall.Conn:Disconnect() end)
        MainModule.GlobalAntiFall.Conn = nil
    end
    if MainModule.GlobalAntiFall.Platform then
        pcall(function() MainModule.GlobalAntiFall.Platform:Destroy() end)
        MainModule.GlobalAntiFall.Platform = nil
    end
    if not enabled then
        PlayToggleSound()
        return true
    end
    local function make()
        local char = MainModule.get_character and MainModule.get_character() or LocalPlayer.Character
        local rp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
        if not rp then return nil end
        local p = Instance.new("Part")
        p.Name = HttpService:GenerateGUID(false)
        p.Size = Vector3.new(12, 1, 12)
        p.Anchored = true
        p.CanCollide = true
        p.Transparency = 0.5
        p.Material = Enum.Material.SmoothPlastic
        p.Color = Color3.fromRGB(100, 100, 100)
        p.CFrame = CFrame.new(rp.Position.X, rp.Position.Y - 3.5, rp.Position.Z)
        p.Parent = workspace
        return p
    end
    MainModule.GlobalAntiFall.Platform = make()
    MainModule.GlobalAntiFall.Conn = RunService.Heartbeat:Connect(function()
        if not MainModule.GlobalAntiFall.Enabled then return end
        local char = MainModule.get_character and MainModule.get_character() or LocalPlayer.Character
        local rp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
        if not rp then return end
        if not (MainModule.GlobalAntiFall.Platform and MainModule.GlobalAntiFall.Platform.Parent) then
            MainModule.GlobalAntiFall.Platform = make()
        end
        if MainModule.GlobalAntiFall.Platform then
            MainModule.GlobalAntiFall.Platform.CFrame = CFrame.new(rp.Position.X, rp.Position.Y - 3.5, rp.Position.Z)
            MainModule.GlobalAntiFall.Platform.Transparency = 0.5
        end
    end)
    PlayToggleSound()
    return true
end

MainModule.JumpRopeAntiFall = {Enabled=false, Platform=nil, Conn=nil}

MainModule.toggle_jump_rope_anti_fall = function(enabled)
    local toggleRef = MainModule.ToggleRefs.JumpRopeAntiFall

    if enabled then
        if not MainModule.can_enable_toggle("JumpRope", "Anti Fall", toggleRef) then
            return false
        end
    end

    if MainModule.JumpRopeAntiFall.Conn then MainModule.JumpRopeAntiFall.Conn:Disconnect() end
    if MainModule.JumpRopeAntiFall.Platform then MainModule.JumpRopeAntiFall.Platform:Destroy() end
    MainModule.JumpRopeAntiFall.Enabled = enabled
    if enabled then
        local function create()
            local c = MainModule.get_character()
            if not c then return nil end
            local rp = MainModule.get_root_part(c)
            if not rp then return nil end
            local p = Instance.new("Part")
            p.Name = HttpService:GenerateGUID(false)
            p.Size = Vector3.new(10000,1,10000)
            p.Position = Vector3.new(rp.Position.X, rp.Position.Y-5, rp.Position.Z)
            p.Anchored = true
            p.CanCollide = true
            p.Transparency = 0.5
            p.Parent = workspace
            return p
        end
        MainModule.JumpRopeAntiFall.Platform = create()
        MainModule.JumpRopeAntiFall.Conn = RunService.Heartbeat:Connect(function()
            if not MainModule.JumpRopeAntiFall.Enabled then return end
            if not MainModule.is_game_active("JumpRope") then
                MainModule.disable_toggle("JumpRopeAntiFall")
                return
            end
            if not (MainModule.JumpRopeAntiFall.Platform and MainModule.JumpRopeAntiFall.Platform.Parent) then
                MainModule.JumpRopeAntiFall.Platform = create()
            end
        end)
    else
    end
    PlayToggleSound()
    return true
end

MainModule.gb_tp_end = function()
    if MainModule.is_game_active("GlassBridge") then
        MainModule.safe_teleport(Vector3.new(-196.372467,522.192139,-1534.20984))
        MainModule.notify("GlassBridge","Teleported to End",0.9)
    else
        MainModule.notify("GlassBridge","Wait for GlassBridge!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.GlassESPEnabled = false
MainModule.GlassESPConnection = nil
MainModule.GlassESPHighlighted = {}
MainModule.GlassESPOriginal = {}

MainModule.toggle_glass_esp = function(enabled)
    local toggleRef = MainModule.ToggleRefs.GlassESP
    if enabled then
        if not MainModule.can_enable_toggle("GlassBridge", "Glass ESP", toggleRef) then
            return false
        end
    end
    MainModule.GlassESPEnabled = enabled and true or false
    if MainModule.GlassESPConnection then
        pcall(function() MainModule.GlassESPConnection:Disconnect() end)
        MainModule.GlassESPConnection = nil
    end
    for part, orig in pairs(MainModule.GlassESPOriginal) do
        if part and part.Parent then
            pcall(function()
                part.Color = orig.Color
                part.Material = orig.Material
            end)
        end
    end
    MainModule.GlassESPOriginal = {}
    MainModule.GlassESPHighlighted = {}
    if not enabled then
        PlayToggleSound()
        return true
    end
    local glassHolder = workspace:FindFirstChild("GlassBridge") and workspace.GlassBridge:FindFirstChild("GlassHolder")
    if not glassHolder then
        PlayToggleSound()
        return true
    end
    local function getGlassType(part)
        if not part:GetAttribute("GlassPart") then return nil end
        local hasActuallyKilling = part:GetAttribute("ActuallyKilling") ~= nil
        local hasDelayedBreaking = part:GetAttribute("DelayedBreaking") ~= nil
        if hasActuallyKilling and hasDelayedBreaking then
            return "delayed"
        elseif hasActuallyKilling then
            return "fake"
        else
            return "real"
        end
    end
    local glassColors = {
        real = Color3.fromRGB(0, 255, 0),
        delayed = Color3.fromRGB(255, 200, 0),
        fake = Color3.fromRGB(255, 0, 0)
    }
    for _, part in ipairs(glassHolder:GetDescendants()) do
        if part:IsA("BasePart") and part:GetAttribute("GlassPart") then
            local glassType = getGlassType(part)
            if glassType then
                if not MainModule.GlassESPOriginal[part] then
                    MainModule.GlassESPOriginal[part] = { Color = part.Color, Material = part.Material }
                end
                part.Color = glassColors[glassType]
                part.Material = Enum.Material.Neon
                MainModule.GlassESPHighlighted[part] = glassType
            end
        end
    end
    MainModule.GlassESPConnection = RunService.RenderStepped:Connect(function()
        if not MainModule.GlassESPEnabled then return end
        if not glassHolder.Parent then
            if MainModule.GlassESPConnection then
                MainModule.GlassESPConnection:Disconnect()
                MainModule.GlassESPConnection = nil
            end
            return
        end
        for part, glassType in pairs(MainModule.GlassESPHighlighted) do
            if part and part.Parent then
                part.Color = glassColors[glassType]
                part.Material = Enum.Material.Neon
            else
                MainModule.GlassESPHighlighted[part] = nil
            end
        end
    end)
    PlayToggleSound()
    return true
end

function MainModule.set_title(value)
    MainModule.CurrentTitleValue = value
    if MainModule.TitleEnabled then
        MainModule.update_title()
    end
end

MainModule.AntiBreakEnabled = false
MainModule.AntiBreakConn = nil
MainModule.SafetyPlatforms = {}

MainModule.toggle_anti_break = function(enabled)
    enabled = enabled and true or false
    MainModule.AntiBreakEnabled = enabled
    if MainModule.AntiBreakConn then
        pcall(function() MainModule.AntiBreakConn:Disconnect() end)
        MainModule.AntiBreakConn = nil
    end
    local function stripGlassTouches()
        local glassBridge = Workspace:FindFirstChild("GlassBridge")
        if not glassBridge then return end
        local glassHolder = glassBridge:FindFirstChild("GlassHolder")
        if not glassHolder then return end
        for _, descendant in ipairs(glassHolder:GetDescendants()) do
            if descendant:IsA("TouchTransmitter") or (descendant:IsA("ProximityPrompt") or (typeof(descendant.Name) == "string" and descendant.Name:lower():find("touch"))) then
                pcall(function() descendant:Destroy() end)
            elseif descendant:IsA("BasePart") then
                for _, child in ipairs(descendant:GetChildren()) do
                    if child.ClassName == "TouchInterest" then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end
    end
    if enabled then
        stripGlassTouches()
        MainModule.AntiBreakConn = RunService.Heartbeat:Connect(function()
            if not MainModule.AntiBreakEnabled then return end
            -- throttle every ~1s via attribute stamp
            local now = tick()
            if (MainModule._AntiBreakLast or 0) + 1 > now then return end
            MainModule._AntiBreakLast = now
            pcall(stripGlassTouches)
        end)
    end
    if PlayToggleSound then PlayToggleSound() end
    return true
end


MainModule.FreezeRopeEnabled = false
MainModule.FreezeRopeConnection = nil

MainModule.toggle_freeze_rope = function(enabled)
    MainModule.FreezeRopeEnabled = enabled

    local rope = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("rope")
    if not rope then
        if MainModule.ToggleRefs.FreezeRope then
            pcall(function() MainModule.ToggleRefs.FreezeRope:SetValue(false) end)
        end
        return
    end

    if enabled then
        for _, part in ipairs(rope:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true
                part.Velocity = Vector3.zero
                part.RotVelocity = Vector3.zero
            elseif part:IsA("Constraint") or part:IsA("RopeConstraint") or part:IsA("Motor6D") then
                part.Enabled = false
            end
        end
    else
        for _, part in ipairs(rope:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            elseif part:IsA("Constraint") or part:IsA("RopeConstraint") or part:IsA("Motor6D") then
                part.Enabled = true
            end
        end
    end

    PlayToggleSound()
end

MainModule.remove_balance_mini_game = function()
    local playingJumpRope = LocalPlayer:FindFirstChild("PlayingJumpRope")
    if playingJumpRope then
        pcall(function() playingJumpRope:Destroy() end)
        PlayBell()
    else
        MainModule.notify("Jump Rope", "PlayingJumpRope not found", 0.9)
        PlayErrorSound()
    end
end

MainModule.AutoJumpEnabled = false
MainModule.AutoJumpLoop = nil

MainModule.toggle_auto_jump = function(enabled)
    MainModule.AutoJumpEnabled = enabled

    if MainModule.AutoJumpLoop then
        task.cancel(MainModule.AutoJumpLoop)
        MainModule.AutoJumpLoop = nil
    end

    if enabled then
        MainModule.AutoJumpLoop = task.spawn(function()
            while MainModule.AutoJumpEnabled do
                local rope = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("rope")
                local character = MainModule.get_character()

                if rope and character then
                    local rootPart = MainModule.get_root_part(character)
                    if rootPart and (rootPart.Position - rope.Position).Magnitude <= 15 then
                        local humanoid = MainModule.get_humanoid(character)
                        if humanoid and humanoid.Health > 0 then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    else
    end

    PlayToggleSound()
end

MainModule.JumpRopeAntiHit = {
    Enabled = false,
    Connection = nil,
    AnimationId = "rbxassetid://105677261748140",
    AnimationDuration = 0.4,
    CurrentAnimation = nil,
    StopTimer = nil,
    WasJumping = false,
    RopeDestroyed = false
}

MainModule.JumpRopeFakeBalance = {
    Enabled = false,
    Connection = nil,
    AnimationId = "rbxassetid://105677261748140",
    AnimationDuration = 0.4,
    CurrentAnimation = nil,
    StopTimer = nil,
    WasJumping = false
}

function MainModule.play_land_animation_fake_balance()
    if not MainModule.JumpRopeFakeBalance.Enabled then return end

    local character = MainModule.get_character()
    if not character then return end

    local humanoid = MainModule.get_humanoid(character)
    if not humanoid then return end

    if MainModule.JumpRopeFakeBalance.CurrentAnimation then
        pcall(function() MainModule.JumpRopeFakeBalance.CurrentAnimation:Stop() end)
    end

    if MainModule.JumpRopeFakeBalance.StopTimer then
        MainModule.JumpRopeFakeBalance.StopTimer:Disconnect()
        MainModule.JumpRopeFakeBalance.StopTimer = nil
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = MainModule.JumpRopeFakeBalance.AnimationId
    MainModule.JumpRopeFakeBalance.CurrentAnimation = humanoid:LoadAnimation(anim)
    pcall(function() MainModule.JumpRopeFakeBalance.CurrentAnimation:Play() end)

    MainModule.JumpRopeFakeBalance.StopTimer = game:GetService("RunService").Stepped:Connect(function()
        task.wait(MainModule.JumpRopeFakeBalance.AnimationDuration)
        if MainModule.JumpRopeFakeBalance.CurrentAnimation then
            pcall(function() MainModule.JumpRopeFakeBalance.CurrentAnimation:Stop() end)
            MainModule.JumpRopeFakeBalance.CurrentAnimation = nil
        end
        if MainModule.JumpRopeFakeBalance.StopTimer then
            MainModule.JumpRopeFakeBalance.StopTimer:Disconnect()
            MainModule.JumpRopeFakeBalance.StopTimer = nil
        end
    end)
end

function MainModule.setup_jump_rope_fake_balance()
    local character = MainModule.get_character()
    if not character then return end

    local humanoid = MainModule.get_humanoid(character)
    if not humanoid then return end

    MainModule.JumpRopeFakeBalance.WasJumping = false

    humanoid.StateChanged:Connect(function(oldState, newState)
        if not MainModule.JumpRopeFakeBalance.Enabled then return end

        if newState == Enum.HumanoidStateType.Jumping then
            MainModule.JumpRopeFakeBalance.WasJumping = true
        end

        if MainModule.JumpRopeFakeBalance.WasJumping and (newState == Enum.HumanoidStateType.Running or
           newState == Enum.HumanoidStateType.Landed or
           newState == Enum.HumanoidStateType.GettingUp) then
            MainModule.play_land_animation_fake_balance()
            MainModule.JumpRopeFakeBalance.WasJumping = false
        end
    end)
end

function MainModule.toggle_jump_rope_fake_balance(enabled)
    local toggleRef = MainModule.ToggleRefs.JumpRopeFakeBalance

    if enabled then
        if not MainModule.can_enable_toggle("JumpRope", "Fake Balance", toggleRef) then
            return false
        end
    end

    if MainModule.JumpRopeFakeBalance.Connection then
        MainModule.JumpRopeFakeBalance.Connection:Disconnect()
        MainModule.JumpRopeFakeBalance.Connection = nil
    end

    if MainModule.JumpRopeFakeBalance.CurrentAnimation then
        pcall(function() MainModule.JumpRopeFakeBalance.CurrentAnimation:Stop() end)
        MainModule.JumpRopeFakeBalance.CurrentAnimation = nil
    end

    if MainModule.JumpRopeFakeBalance.StopTimer then
        MainModule.JumpRopeFakeBalance.StopTimer:Disconnect()
        MainModule.JumpRopeFakeBalance.StopTimer = nil
    end

    MainModule.JumpRopeFakeBalance.Enabled = enabled

    if enabled then
        MainModule.setup_jump_rope_fake_balance()

        MainModule.JumpRopeFakeBalance.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.JumpRopeFakeBalance.Enabled then return end

            if not MainModule.is_game_active("JumpRope") then
                if MainModule.ToggleRefs.JumpRopeFakeBalance then
                    pcall(function() MainModule.ToggleRefs.JumpRopeFakeBalance:SetValue(false) end)
                end
                MainModule.toggle_jump_rope_fake_balance(false)
                return
            end
        end)
    end

    PlayToggleSound()
    return true
end

function MainModule.disable_rope_objects(obj)
    if not obj then return end

    pcall(function()
        if obj:IsA("MeshPart") or obj:IsA("Part") or obj:IsA("BasePart") then
            obj.CanCollide = false
            obj.CanTouch = false
            obj.CanQuery = false
            obj.Massless = true

            if obj.TouchTransmitter then
                obj.TouchTransmitter:Destroy()
            end
        end

        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            local name = obj.Name:lower()
            if name:find("rope") or name:find("jump") or name:find("carry") or name:find("damage") or name:find("hurt") then
                obj.Disabled = true
            end
        end

        if obj:IsA("RopeConstraint") then
            obj:Destroy()
        end

        local name = obj.Name or ""
        if name == "PlayingJumpRope" or name == "RopeCarryPrompt" then
            obj:Destroy()
        end
    end)
end

function MainModule.search_and_destroy_rope(parent)
    if not parent then return end
    for _, obj in pairs(parent:GetDescendants()) do
        if obj.Name and obj.Name:lower():find("rope") then
            MainModule.disable_rope_objects(obj)
        end
        if obj:IsA("RopeConstraint") then
            MainModule.disable_rope_objects(obj)
        end
        if obj.Name == "PlayingJumpRope" or obj.Name == "RopeCarryPrompt" then
            MainModule.disable_rope_objects(obj)
        end
    end
end

function MainModule.destroy_all_ropes()
    MainModule.search_and_destroy_rope(workspace)

    pcall(function()
        MainModule.search_and_destroy_rope(game:GetService("ReplicatedStorage"))
    end)

    pcall(function()
        MainModule.search_and_destroy_rope(game:GetService("ServerStorage"))
    end)

    pcall(function()
        MainModule.search_and_destroy_rope(game:GetService("ServerScriptService"))
    end)

    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                MainModule.search_and_destroy_rope(player.Character)
            end
            if player.PlayerGui then
                MainModule.search_and_destroy_rope(player.PlayerGui)
            end
        end
    end)

    MainModule.JumpRopeAntiHit.RopeDestroyed = true
end

function MainModule.disable_damage_scripts()
    pcall(function()
        local replicatedStorage = game:GetService("ReplicatedStorage")
        for _, obj in pairs(replicatedStorage:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                local name = obj.Name:lower()
                if name:find("rope") or name:find("jump") or name:find("carry") or name:find("damage") or name:find("hurt") then
                    obj.Disabled = true
                end
            end
        end
    end)

    pcall(function()
        local serverStorage = game:GetService("ServerStorage")
        for _, obj in pairs(serverStorage:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                local name = obj.Name:lower()
                if name:find("rope") or name:find("jump") or name:find("carry") or name:find("damage") or name:find("hurt") then
                    obj.Disabled = true
                end
            end
        end
    end)

    pcall(function()
        local serverScriptService = game:GetService("ServerScriptService")
        for _, obj in pairs(serverScriptService:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                local name = obj.Name:lower()
                if name:find("rope") or name:find("jump") or name:find("carry") or name:find("damage") or name:find("hurt") then
                    obj.Disabled = true
                end
            end
        end
    end)
end

function MainModule.toggle_jump_rope_anti_hit(enabled)
    local toggleRef = MainModule.ToggleRefs.JumpRopeAntiHit

    if enabled then
        if not MainModule.can_enable_toggle("JumpRope", "AntiHit", toggleRef) then
            return false
        end
    end

    if MainModule.JumpRopeAntiHit.Connection then
        MainModule.JumpRopeAntiHit.Connection:Disconnect()
        MainModule.JumpRopeAntiHit.Connection = nil
    end

    MainModule.JumpRopeAntiHit.Enabled = enabled
    MainModule.JumpRopeAntiHit.RopeDestroyed = false

    if enabled then
        MainModule.disable_damage_scripts()
        MainModule.destroy_all_ropes()

        MainModule.JumpRopeAntiHit.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.JumpRopeAntiHit.Enabled then return end

            if not MainModule.is_game_active("JumpRope") then
                if MainModule.ToggleRefs.JumpRopeAntiHit then
                    pcall(function() MainModule.ToggleRefs.JumpRopeAntiHit:SetValue(false) end)
                end
                MainModule.toggle_jump_rope_anti_hit(false)
                return
            end

            if not MainModule.JumpRopeAntiHit.RopeDestroyed then
                MainModule.destroy_all_ropes()
            end
        end)
    end

    PlayToggleSound()
    return true
end

MainModule.ToggleRefs.JumpRopeAntiHit = nil
MainModule.ToggleRefs.JumpRopeFakeBalance = nil

MainModule.ZoneKillFeature = {
    Enabled = false,
    AnimationId = "rbxassetid://105341857343164",
    ZonePosition = Vector3.new(197.7, 54.6, -96.3),
    ReturnDelay = 0.6,
    SavedCFrame = nil,
    ActiveAnimation = false,
    AnimationStartTime = 0,
    AnimationConnection = nil,
    CharacterAddedConnection = nil,
    AnimationStoppedConnections = {},
    AnimationCheckConnection = nil,
    TrackedAnimations = {}
}

function MainModule.toggle_zone_kill(enabled)
    local toggleRef = MainModule.ToggleRefs.ZoneKill

    if enabled then
        if not MainModule.can_enable_toggle("LastDinner", "Zone Kill", toggleRef) then
            return false
        end
    end

    MainModule.ZoneKillFeature.Enabled = enabled

    if MainModule.ZoneKillFeature.AnimationConnection then
        MainModule.ZoneKillFeature.AnimationConnection:Disconnect()
        MainModule.ZoneKillFeature.AnimationConnection = nil
    end
    if MainModule.ZoneKillFeature.CharacterAddedConnection then
        MainModule.ZoneKillFeature.CharacterAddedConnection:Disconnect()
        MainModule.ZoneKillFeature.CharacterAddedConnection = nil
    end
    if MainModule.ZoneKillFeature.AnimationCheckConnection then
        MainModule.ZoneKillFeature.AnimationCheckConnection:Disconnect()
        MainModule.ZoneKillFeature.AnimationCheckConnection = nil
    end

    for _, conn in ipairs(MainModule.ZoneKillFeature.AnimationStoppedConnections) do
        pcall(function() conn:Disconnect() end)
    end
    MainModule.ZoneKillFeature.AnimationStoppedConnections = {}

    MainModule.ZoneKillFeature.SavedCFrame = nil
    MainModule.ZoneKillFeature.ActiveAnimation = false
    MainModule.ZoneKillFeature.AnimationStartTime = 0
    MainModule.ZoneKillFeature.TrackedAnimations = {}

    if not enabled then
        PlayToggleSound()
        return true
    end

    local function checkAnimations()
        if not MainModule.ZoneKillFeature.Enabled then return end

        local character = MainModule.get_character()
        if not character then return end
        local humanoid = MainModule.get_humanoid(character)
        if not humanoid then return end

        local activeTracks = humanoid:GetPlayingAnimationTracks()
        for _, track in pairs(activeTracks) do
            if track and track.Animation then
                local animId = track.Animation.AnimationId

                if animId and animId == MainModule.ZoneKillFeature.AnimationId then
                    local trackKey = animId .. "_" .. tostring(track)
                    if not MainModule.ZoneKillFeature.TrackedAnimations[trackKey] then
                        MainModule.ZoneKillFeature.TrackedAnimations[trackKey] = true

                        if not MainModule.ZoneKillFeature.ActiveAnimation then
                            MainModule.ZoneKillFeature.ActiveAnimation = true
                            MainModule.ZoneKillFeature.AnimationStartTime = tick()

                            MainModule.ZoneKillFeature.SavedCFrame = character:GetPrimaryPartCFrame()
                            character:SetPrimaryPartCFrame(CFrame.new(MainModule.ZoneKillFeature.ZonePosition))

                            local stoppedConn = track.Stopped:Connect(function()
                                task.wait(MainModule.ZoneKillFeature.ReturnDelay)

                                if MainModule.ZoneKillFeature.SavedCFrame then
                                    character:SetPrimaryPartCFrame(MainModule.ZoneKillFeature.SavedCFrame)
                                    MainModule.ZoneKillFeature.SavedCFrame = nil
                                    MainModule.ZoneKillFeature.ActiveAnimation = false
                                    MainModule.ZoneKillFeature.TrackedAnimations = {}
                                end
                            end)
                            table.insert(MainModule.ZoneKillFeature.AnimationStoppedConnections, stoppedConn)
                        end
                    end
                end
            end
        end
    end

    local function setupCharacter(char)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if not humanoid then return end

        MainModule.ZoneKillFeature.AnimationConnection = humanoid.AnimationPlayed:Connect(function(track)
            if not MainModule.ZoneKillFeature.Enabled then return end

            if track and track.Animation then
                local animId = track.Animation.AnimationId

                if animId and animId == MainModule.ZoneKillFeature.AnimationId then
                    local trackKey = animId .. "_" .. tostring(track)
                    MainModule.ZoneKillFeature.TrackedAnimations[trackKey] = true

                    if not MainModule.ZoneKillFeature.ActiveAnimation then
                        MainModule.ZoneKillFeature.ActiveAnimation = true
                        MainModule.ZoneKillFeature.AnimationStartTime = tick()

                        MainModule.ZoneKillFeature.SavedCFrame = char:GetPrimaryPartCFrame()
                        char:SetPrimaryPartCFrame(CFrame.new(MainModule.ZoneKillFeature.ZonePosition))

                        local stoppedConn = track.Stopped:Connect(function()
                            task.wait(MainModule.ZoneKillFeature.ReturnDelay)

                            if MainModule.ZoneKillFeature.SavedCFrame then
                                char:SetPrimaryPartCFrame(MainModule.ZoneKillFeature.SavedCFrame)
                                MainModule.ZoneKillFeature.SavedCFrame = nil
                            end

                            MainModule.ZoneKillFeature.ActiveAnimation = false
                            MainModule.ZoneKillFeature.TrackedAnimations = {}
                        end)

                        table.insert(MainModule.ZoneKillFeature.AnimationStoppedConnections, stoppedConn)
                    end
                end
            end
        end)
    end

    local char = LocalPlayer.Character
    if char then
        setupCharacter(char)
    end

    MainModule.ZoneKillFeature.CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(1)
        setupCharacter(newChar)
    end)

    MainModule.ZoneKillFeature.AnimationCheckConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.ZoneKillFeature.Enabled then return end
        checkAnimations()
    end)

    PlayToggleSound()
    return true
end

MainModule.VoidKillEnabled = false
MainModule.VoidKillConn = nil
MainModule.VoidKillCharConn = nil
MainModule.VoidAnimIds = {"rbxassetid://107989020363293","rbxassetid://71619354165195"}
MainModule.VoidZonePos = Vector3.new(-95.1,964.6,67.6)

MainModule.toggle_void_kill = function(enabled)
    local toggleRef = MainModule.ToggleRefs.VoidKill

    if enabled then
        if not MainModule.can_enable_toggle("SkySquidGame", "Void Kill", toggleRef) then
            return false
        end
    end

    if MainModule.VoidKillConn then MainModule.VoidKillConn:Disconnect() end
    if MainModule.VoidKillCharConn then MainModule.VoidKillCharConn:Disconnect() end
    MainModule.VoidKillEnabled = enabled
    if enabled then
        local function setup(char)
            local h = char:WaitForChild("Humanoid")
            MainModule.VoidKillConn = h.AnimationPlayed:Connect(function(track)
                if track.Animation and table.find(MainModule.VoidAnimIds, track.Animation.AnimationId) then
                    local orig = char:GetPrimaryPartCFrame()
                    local platform = Instance.new("Part")
                    platform.Name = HttpService:GenerateGUID(false)
                    platform.Size = Vector3.new(10,1,10)
                    platform.Position = MainModule.VoidZonePos + Vector3.new(0,-4,0)
                    platform.Anchored = true
                    platform.CanCollide = true
                    platform.Transparency = 1
                    platform.Parent = workspace
                    char:SetPrimaryPartCFrame(CFrame.new(MainModule.VoidZonePos.X, MainModule.VoidZonePos.Y, MainModule.VoidZonePos.Z))
                    track.Stopped:Connect(function()
                        task.wait(1)
                        if orig then char:SetPrimaryPartCFrame(orig) end
                        platform:Destroy()
                    end)
                end
            end)
        end
        if LocalPlayer.Character then setup(LocalPlayer.Character) end
        MainModule.VoidKillCharConn = LocalPlayer.CharacterAdded:Connect(function(char) task.wait(1); setup(char) end)
    else
    end
    PlayToggleSound()
    return true
end

MainModule.MingleVoidKillEnabled = false
MainModule.MingleConns = {}
MainModule.MingleAnimId = "rbxassetid://71318091779666"

MainModule.toggle_mingle_void_kill = function(enabled)
    local toggleRef = MainModule.ToggleRefs.MingleVoidKill

    if enabled then
        if not MainModule.can_enable_toggle("Mingle", "Void Kill", toggleRef) then
            return false
        end
    end

    for _,c in pairs(MainModule.MingleConns) do pcall(function() c:Disconnect() end) end
    MainModule.MingleConns = {}
    MainModule.MingleVoidKillEnabled = enabled
    if enabled then
        local platform = nil
        local function setup(char)
            local h = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
            if not h then return end
            local conn = h.AnimationPlayed:Connect(function(track)
                if not MainModule.MingleVoidKillEnabled then return end
                if not track.Animation then return end
                if track.Animation.AnimationId ~= MainModule.MingleAnimId then return end
                local rp = char:FindFirstChild("HumanoidRootPart")
                if not rp then return end
                local returnCFrame = rp.CFrame
                local spawnPos = Vector3.new(196.83342, 55.9547985, -90.4745865)
                if platform then pcall(function() platform:Destroy() end) platform = nil end
                platform = Instance.new("Part")
                platform.Name = HttpService:GenerateGUID(false)
                platform.Size = Vector3.new(40, 2, 40)
                platform.Position = spawnPos + Vector3.new(0, -3, 0)
                platform.Anchored = true
                platform.CanCollide = true
                platform.Transparency = 1
                platform.Parent = workspace
                rp.AssemblyLinearVelocity = Vector3.zero
                rp.CFrame = CFrame.new(spawnPos)
                if char.PrimaryPart then
                    pcall(function() char:SetPrimaryPartCFrame(CFrame.new(spawnPos)) end)
                end
                local stopConn
                stopConn = track.Stopped:Connect(function()
                    task.wait(0.6)
                    if char and char.Parent and MainModule.MingleVoidKillEnabled then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.AssemblyLinearVelocity = Vector3.zero
                            root.CFrame = returnCFrame
                            if char.PrimaryPart then
                                pcall(function() char:SetPrimaryPartCFrame(returnCFrame) end)
                            end
                        end
                    end
                    if platform then pcall(function() platform:Destroy() end) platform = nil end
                    if stopConn then stopConn:Disconnect() end
                end)
            end)
            table.insert(MainModule.MingleConns, conn)
        end
        if LocalPlayer.Character then setup(LocalPlayer.Character) end
        table.insert(MainModule.MingleConns, LocalPlayer.CharacterAdded:Connect(function(char) task.wait(0.5); setup(char) end))
    end
    PlayToggleSound()
    return true
end

MainModule.AutoChokeEnabled = false
MainModule.AutoChokeConnection = nil

MainModule.toggle_auto_choke = function(enabled)
    local toggleRef = MainModule.ToggleRefs.AutoChoke

    if enabled then
        if not MainModule.can_enable_toggle("Mingle", "Auto Choke", toggleRef) then
            return false
        end
    end

    MainModule.AutoChokeEnabled = enabled
    if enabled then
        local ImpactFrames = LocalPlayer.PlayerGui:FindFirstChild("ImpactFrames")
        if ImpactFrames then
            local processed = {}
            ImpactFrames.ChildAdded:Connect(function(outer)
                if outer.Name ~= "OuterRingTemplate" or processed[outer] then return end
                processed[outer] = true
                task.defer(function()
                    local inner = nil
                    for _, g in pairs(ImpactFrames:GetChildren()) do
                        if g.Name == "InnerTemplate" and g.Position == outer.Position and not g:GetAttribute("Failed") then
                            inner = g; break
                        end
                    end
                    if not inner or inner:GetAttribute("Tweening") or inner:GetAttribute("Failed") then return end
                    local HBGQTE = require(ReplicatedStorage.Modules.HBGQTE)
                    pcall(function() HBGQTE.Pressed(false, {Inner=inner, Outer=outer, Duration=2, StartedAt=tick(), Data={}}) end)
                end)
            end)
        end
    else
    end
    PlayToggleSound()
    return true
end

MainModule.SkySquidAntiFall = {Enabled=false, Platform=nil, Conn=nil}

MainModule.toggle_sky_squid_anti_fall = function(enabled)
    if MainModule.SkySquidAntiFall.Conn then MainModule.SkySquidAntiFall.Conn:Disconnect() end
    if MainModule.SkySquidAntiFall.Platform then MainModule.SkySquidAntiFall.Platform:Destroy() end
    MainModule.SkySquidAntiFall.Enabled = enabled
    if enabled then
        local function create()
            local c = MainModule.get_character()
            if not c then return nil end
            local rp = MainModule.get_root_part(c)
            if not rp then return nil end
            local p = Instance.new("Part")
            p.Name = HttpService:GenerateGUID(false)
            p.Size = Vector3.new(10000,1,10000)
            p.Position = Vector3.new(rp.Position.X, rp.Position.Y-5, rp.Position.Z)
            p.Anchored = true
            p.CanCollide = true
            p.Transparency = 0.5
            p.Parent = workspace
            return p
        end
        MainModule.SkySquidAntiFall.Platform = create()
        MainModule.SkySquidAntiFall.Conn = RunService.Heartbeat:Connect(function()
            if not MainModule.SkySquidAntiFall.Enabled then return end
            if not (MainModule.SkySquidAntiFall.Platform and MainModule.SkySquidAntiFall.Platform.Parent) then
                MainModule.SkySquidAntiFall.Platform = create()
            end
        end)
    else
    end
    PlayToggleSound()
    return true
end

MainModule.FullbrightEnabled = false
MainModule.FullbrightSettings = {}
MainModule.FullbrightConnection = nil

MainModule.toggle_fullbright = function(enabled)
    MainModule.FullbrightEnabled = enabled
    local Lighting = game:GetService("Lighting")

    if enabled then
        MainModule.FullbrightSettings.Brightness = Lighting.Brightness
        MainModule.FullbrightSettings.ClockTime = Lighting.ClockTime
        MainModule.FullbrightSettings.FogEnd = Lighting.FogEnd
        MainModule.FullbrightSettings.GlobalShadows = Lighting.GlobalShadows
        MainModule.FullbrightSettings.OutdoorAmbient = Lighting.OutdoorAmbient
        MainModule.FullbrightSettings.Ambient = Lighting.Ambient

        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)

        if MainModule.FullbrightConnection then
            MainModule.FullbrightConnection:Disconnect()
        end

        MainModule.FullbrightConnection = Lighting.Changed:Connect(function(property)
            if not MainModule.FullbrightEnabled then return end
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        end)

    else
        for property, value in pairs(MainModule.FullbrightSettings) do
            pcall(function()
                Lighting[property] = value
            end)
        end

        if MainModule.FullbrightConnection then
            MainModule.FullbrightConnection:Disconnect()
            MainModule.FullbrightConnection = nil
        end
    end
    PlayToggleSound()
end

MainModule.AutoCollectBandage = false
MainModule.AutoCollectBandageConnection = nil

function MainModule.has_tool(toolName)
    local char = MainModule.get_character()
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == toolName then
                return true
            end
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == toolName then
                return true
            end
        end
    end
    return false
end

function MainModule.start_auto_collect_bandage()
    if MainModule.AutoCollectBandageConnection then
        MainModule.AutoCollectBandageConnection:Disconnect()
        MainModule.AutoCollectBandageConnection = nil
    end

    MainModule.AutoCollectBandageConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.AutoCollectBandage then return end

        if not MainModule.has_tool("Bandage") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local effects = workspace:FindFirstChild("Effects")
            if effects then
                for _, v in pairs(effects:GetChildren()) do
                    if v.Name == "DroppedBandage" and v:FindFirstChild("Handle") then
                        local oldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                        task.wait(0.3)
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
                        end
                        break
                    end
                end
            end
        end
    end)
end

function MainModule.toggle_auto_collect_bandage(enabled)
    MainModule.AutoCollectBandage = enabled

    if enabled then
        MainModule.start_auto_collect_bandage()
    else
        if MainModule.AutoCollectBandageConnection then
            MainModule.AutoCollectBandageConnection:Disconnect()
            MainModule.AutoCollectBandageConnection = nil
        end
    end
    PlayToggleSound()
end

MainModule.RLGLEndCorner = MainModule.RLGLEndCorner or "Left Corner"
MainModule.RLGLEndPositions = {
    ["Left Corner"] = Vector3.new(110, 1023, 133),
    ["Right Corner"] = Vector3.new(-214.4, 1023.1, 146.7),
}

MainModule.rlgl_tp_end = function()
    if MainModule.is_game_active("RedLightGreenLight") then
        local corner = MainModule.RLGLEndCorner or "Left Corner"
        local pos = (MainModule.RLGLEndPositions and MainModule.RLGLEndPositions[corner]) or Vector3.new(110, 1023, 133)
        MainModule.safe_teleport(pos)
        MainModule.notify("RLGL", "Teleported to " .. tostring(corner), 0.9)
    else
        MainModule.notify("RLGL","Wait for RedLightGreenLight!",0.9)
        PlayErrorSound()
    end
end

MainModule.GodModeEnabled = false
MainModule.GodModeConn = nil
MainModule.GodModeOrigY = nil

MainModule.toggle_god_mode = function(enabled)
    local toggleRef = MainModule.ToggleRefs.GodMode

    if enabled then
        if not MainModule.can_enable_toggle("RedLightGreenLight", "God Mode", toggleRef) then
            return false
        end
    end

    if enabled then
        if MainModule.GodModeConn then MainModule.GodModeConn:Disconnect(); MainModule.GodModeConn = nil end
        MainModule.GodModeEnabled = true
        local c = MainModule.get_character()
        if not c then MainModule.notify("GodMode","Character not found",0.9); PlayErrorSound(); MainModule.GodModeEnabled=false; return false end
        local rp = c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart
        if rp then
            MainModule.GodModeOrigY = rp.Position.Y
            MainModule.safe_teleport(Vector3.new(rp.Position.X, rp.Position.Y+170, rp.Position.Z))
        end
        MainModule.GodModeConn = RunService.Heartbeat:Connect(function()
            if MainModule.GodModeEnabled and not MainModule.is_game_active("RedLightGreenLight") then
                MainModule.disable_toggle("GodMode")
            end
        end)
    else
        MainModule.GodModeEnabled = false
        if MainModule.GodModeConn then MainModule.GodModeConn:Disconnect(); MainModule.GodModeConn = nil end
        if MainModule.GodModeOrigY then
            local c = MainModule.get_character()
            if c then
                local rp = c:FindFirstChild("HumanoidRootPart")
                if rp then MainModule.safe_teleport(Vector3.new(rp.Position.X, MainModule.GodModeOrigY, rp.Position.Z)) end
            end
        end
        MainModule.GodModeOrigY = nil
    end
    PlayToggleSound()
    return true
end

MainModule.RageAutoQTEEnabled = false
MainModule.RageAutoQTELoop = nil

MainModule.toggle_rage_auto_qte = function(enabled)
    local toggleRef = MainModule.ToggleRefs.RageAutoQTE

    if enabled then
        if MainModule.is_xeno_executor() then
            MainModule.notify("RAGE Auto QTE", "Not supported in your executor", 0.9)
            PlayErrorSound()
            if toggleRef and toggleRef.SetValue then
                pcall(function() toggleRef:SetValue(false) end)
            end
            return false
        end
    end

    MainModule.RageAutoQTEEnabled = enabled

    if MainModule.RageAutoQTELoop then
        task.cancel(MainModule.RageAutoQTELoop)
        MainModule.RageAutoQTELoop = nil
    end

    if enabled then
        MainModule.RageAutoQTELoop = task.spawn(function()
            local QTE = nil
            local success, module = pcall(function()
                return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("HBGQTE"))
            end)
            if success then
                QTE = module
            else
                MainModule.notify("RAGE Auto QTE", "Failed to load QTE module", 0.9)
                PlayErrorSound()
                MainModule.RageAutoQTEEnabled = false
                if toggleRef and toggleRef.SetValue then
                    pcall(function() toggleRef:SetValue(false) end)
                end
                return
            end

            while MainModule.RageAutoQTEEnabled do
                task.wait(0.05)
                pcall(function()
                    if QTE and QTE.ActiveButtons then
                        for _, data in pairs(QTE.ActiveButtons) do
                            if data
                            and data.Inner
                            and data.Outer
                            and not data.Inner:GetAttribute("Tweening")
                            and not data.Inner:GetAttribute("Failed") then
                                pcall(function()
                                    QTE.Pressed(false, data)
                                end)
                            end
                        end
                    end
                end)
            end
        end)
        PlayToggleSound()
    else
        PlayToggleSound()
    end
    return true
end

MainModule.RemoveInjuryEnabled = false
MainModule.RemoveInjuryConn = nil

local injury_names = {
    Stun=true, stunned=true, Stunned=true,
    crawl=true, Crawl=true, crawled=true, Crawled=true,
    crawling=true, Crawling=true,
}

local function clear_injury_fx()
    local char = LocalPlayer.Character
    if not char then return end
    for _, obj in ipairs(char:GetDescendants()) do
        local n = obj.Name
        if injury_names[n] then
            pcall(function() obj:Destroy() end)
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
                local id = t.Animation and t.Animation.AnimationId or ""
            end
        end)
    end
end

MainModule.remove_injury_objects = function()
    clear_injury_fx()
end

MainModule.toggle_remove_injury = function(enabled)
    MainModule.RemoveInjuryEnabled = enabled and true or false
    if MainModule.RemoveInjuryConn then
        pcall(function() MainModule.RemoveInjuryConn:Disconnect() end)
        MainModule.RemoveInjuryConn = nil
    end
    if MainModule.RemoveInjuryEnabled then
        clear_injury_fx()
        MainModule.RemoveInjuryConn = RunService.Heartbeat:Connect(function()
            if not MainModule.RemoveInjuryEnabled then return end
            if not MainModule._injury_last then MainModule._injury_last = 0 end
            if tick() - MainModule._injury_last < 1 then return end
            MainModule._injury_last = tick()
            clear_injury_fx()
        end)
    end
    PlayToggleSound()
end

MainModule = MainModule or {}


MainModule.FireHotbarTool = function(toolName)
    local lp = Players.LocalPlayer
    if not lp then return false end
    local backpack = lp:FindFirstChild("Backpack")
    if not backpack then return false end
    local item = backpack:FindFirstChild(toolName)
    if not item then
        local ch = lp.Character
        item = ch and ch:FindFirstChild(toolName)
    end
    if not item then return false end
    local hotbar = lp.PlayerGui:FindFirstChild("Hotbar")
    if not hotbar then return false end
    local hb = hotbar:FindFirstChild("Backpack")
    hb = hb and hb:FindFirstChild("Hotbar")
    if not hb then return false end
    local button = nil
    for _, slot in pairs(hb:GetChildren()) do
        local tn = slot:FindFirstChild("ToolName")
        if tn and tn.Text == toolName then
            button = slot
            break
        end
    end
    if not button or not getconnections then return false end
    pcall(function()
        for _, connection in pairs(getconnections(button.MouseButton1Down)) do
            pcall(function() connection:Fire() end)
        end
        task.wait(0.05)
        for _, connection in pairs(getconnections(button.MouseButton1Up)) do
            pcall(function() connection:Fire() end)
        end
    end)
    return true
end


loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
MainModule = MainModule or {}
--@encrypt_start
loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
function MainModule.EnsureFakeUltraInstinct()
    if type(MainModule.FakeUltraInstinct) ~= "table" then
        MainModule.FakeUltraInstinct = {}
    end
    local FUI = MainModule.FakeUltraInstinct
    if FUI.MaxDodges == nil then FUI.MaxDodges = 10 end
    if FUI.Dodges == nil then FUI.Dodges = 10 end
    if FUI.Cooldown == nil then FUI.Cooldown = false end
    if FUI.Equipped == nil then FUI.Equipped = false end
    if FUI.AnimPlaying == nil then FUI.AnimPlaying = false end
    if FUI.Enabled == nil then FUI.Enabled = false end
    if FUI.SoundId == nil then FUI.SoundId = "rbxassetid://6732929006" end
    if type(FUI.DodgeLabels) ~= "table" then FUI.DodgeLabels = {} end
    if type(FUI.Connections) ~= "table" then FUI.Connections = {} end
    if type(FUI.FXMap) ~= "table" then
        FUI.FXMap = { [1] = 1, [2] = 2, [3] = 1, [4] = 2, [5] = 1 }
    end
    return FUI
end
function MainModule.FUIGetPlayer()
    return game:GetService("Players").LocalPlayer
end
function MainModule.FUIGetEffects()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    if FUI.UIDodgeEffects then
        return FUI.UIDodgeEffects
    end
    local ok, result = pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local modules = rs:FindFirstChild("Modules")
        if not modules then return nil end
        local abilityModules = modules:FindFirstChild("AbilityEffectsModules")
        if not abilityModules then return nil end
        local target = abilityModules:FindFirstChild("UIDodgeCLIENTEFFECTS")
        if not target then return nil end
        return require(target)
    end)
    if ok and type(result) == "function" then
        FUI.UIDodgeEffects = result
        return result
    end
    return nil
end
function MainModule.FUIGetAnimFolder()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    if FUI.AnimFolder and FUI.AnimFolder.Parent then
        return FUI.AnimFolder
    end
    local ok, result = pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local animations = rs:FindFirstChild("Animations")
        if not animations then return nil end
        local abilities = animations:FindFirstChild("Abilities")
        if not abilities then return nil end
        return abilities:FindFirstChild("UltraInstinct")
    end)
    if ok and result then
        FUI.AnimFolder = result
        return result
    end
    return nil
end
function MainModule.FUIGetChar()
    local player = MainModule.FUIGetPlayer()
    if not player then return nil end
    return player.Character
end
function MainModule.FUIGetAnimator()
    local char = MainModule.FUIGetChar()
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    return animator
end
function MainModule.FUIGetAnimations()
    local folder = MainModule.FUIGetAnimFolder()
    if not folder then return {} end
    local list = {}
    for _, obj in ipairs(folder:GetChildren()) do
        if obj:IsA("Animation") and obj.AnimationId ~= "" then
            table.insert(list, obj)
        end
    end
    return list
end
function MainModule.FUIStageOf(anim)
    if not anim then return 1 end
    return tonumber(tostring(anim.Name):match("%d+")) or 1
end
function MainModule.FUIPlayAura()
    local effects = MainModule.FUIGetEffects()
    if not effects then return end
    local char = MainModule.FUIGetChar()
    if not char then return end
    pcall(function()
        effects({ ModuleName = "UIDodge", Character = char, initial = true })
    end)
end
function MainModule.FUIPlayDodgeFX(stage)
    local effects = MainModule.FUIGetEffects()
    if not effects then return end
    local char = MainModule.FUIGetChar()
    if not char then return end
    pcall(function()
        effects({ ModuleName = "UIDodge", Character = char, dodgenumber = stage, initial = false })
    end)
end
function MainModule.FUIPlaySound()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    local char = MainModule.FUIGetChar()
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    if not root then return end
    local sound = Instance.new("Sound")
    sound.Name = "FakeUltraInstinctSound"
    sound.SoundId = FUI.SoundId
    sound.Volume = 1.5
    sound.RollOffMaxDistance = 120
    sound.Parent = root
    pcall(function() sound:Play() end)
    sound.Ended:Once(function()
        sound:Destroy()
    end)
end
function MainModule.FUIFindLabels(root)
    local labels = {}
    if not root then return labels end
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local text = tostring(obj.Text)
            if text:find("%d+%s*/%s*%d+") or text:lower():find("dodge") then
                table.insert(labels, obj)
            end
        end
    end
    return labels
end
function MainModule.FUISetupPanel()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    if FUI.Panel and FUI.Panel.Parent then return end
    local player = MainModule.FUIGetPlayer()
    if not player then return end
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end
    local original = playerGui:FindFirstChild("PowerUIDodges")
    if not original then return end
    FUI.OriginalPanel = original
    pcall(function()
        if original:IsA("ScreenGui") then original.Enabled = false end
    end)
    local clone = original:Clone()
    clone.Name = "FakeUltraInstinctDodges"
    for _, obj in ipairs(clone:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            obj:Destroy()
        end
    end
    local parent = playerGui
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then parent = hui end
    end
    clone.Parent = parent
    if clone:IsA("ScreenGui") then
        clone.Enabled = true
        clone.ResetOnSpawn = false
    end
    FUI.Panel = clone
    FUI.DodgeLabels = MainModule.FUIFindLabels(clone)
    MainModule.FUIUpdatePanel()
end
function MainModule.FUIUpdatePanel()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    if not FUI.Panel or not FUI.Panel.Parent then return end
    local text = string.format("Dodges Left: %d/%d", FUI.Dodges, FUI.MaxDodges)
    for _, label in ipairs(FUI.DodgeLabels) do
        if label and label.Parent then
            pcall(function() label.Text = text end)
        end
    end
end
function MainModule.FUIConsumeDodge()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    FUI.Dodges = math.max(FUI.Dodges - 1, 0)
    MainModule.FUIUpdatePanel()
    if FUI.Dodges <= 0 then
        task.delay(0.35, function()
            local inner = MainModule.EnsureFakeUltraInstinct()
            if not inner.Enabled then return end
            inner.Dodges = inner.MaxDodges
            MainModule.FUIUpdatePanel()
        end)
    end
end
function MainModule.FUIStopAnim()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    if FUI.CurrentTrack then
        pcall(function()
            FUI.CurrentTrack:Stop(0.1)
            FUI.CurrentTrack:Destroy()
        end)
    end
    FUI.CurrentTrack = nil
    FUI.AnimPlaying = false
end
function MainModule.FUIPlayAll(consume)
    local FUI = MainModule.EnsureFakeUltraInstinct()
    if not FUI.Enabled then return end
    local list = MainModule.FUIGetAnimations()
    if #list == 0 then return end
    local selected
    if #list == 1 then
        selected = list[1]
    else
        local tries = 0
        repeat
            selected = list[math.random(1, #list)]
            tries += 1
        until selected ~= FUI.LastAnim or tries > 10
    end
    FUI.LastAnim = selected
    local stage = MainModule.FUIStageOf(selected)
    local fxStage = FUI.FXMap[stage] or math.random(1, 2)
    MainModule.FUIStopAnim()
    local animator = MainModule.FUIGetAnimator()
    if animator then
        local ok, track = pcall(function()
            return animator:LoadAnimation(selected)
        end)
        if ok and track then
            FUI.AnimPlaying = true
            FUI.CurrentTrack = track
            track.Priority = Enum.AnimationPriority.Action4
            track.Looped = false
            pcall(function() track:Play(0.05, 1, 1) end)
            track.Stopped:Once(function()
                local inner = MainModule.EnsureFakeUltraInstinct()
                if inner.CurrentTrack == track then
                    pcall(function() track:Destroy() end)
                    inner.CurrentTrack = nil
                    inner.AnimPlaying = false
                end
            end)
        end
    end
    task.spawn(MainModule.FUIPlayAura)
    task.spawn(function() MainModule.FUIPlayDodgeFX(fxStage) end)
    task.spawn(MainModule.FUIPlaySound)
    if consume then
        MainModule.FUIConsumeDodge()
    end
end
function MainModule.FUIDoDodge()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    if not FUI.Enabled then return end
    if FUI.Cooldown then return end
    FUI.Cooldown = true
    MainModule.FUIPlayAll(true)
    task.delay(0.35, function()
        local inner = MainModule.EnsureFakeUltraInstinct()
        inner.Cooldown = false
    end)
end
function MainModule.FUICreateTool()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    if not FUI.Enabled then return end
    if FUI.Tool and FUI.Tool.Parent then return end
    local player = MainModule.FUIGetPlayer()
    if not player then return end
    local backpack = player:FindFirstChildOfClass("Backpack") or player:WaitForChild("Backpack", 5)
    if not backpack then return end
    local existing = backpack:FindFirstChild("Ultra Instinct") or (player.Character and player.Character:FindFirstChild("Ultra Instinct"))
    if existing then pcall(function() existing:Destroy() end) end
    local tool = Instance.new("Tool")
    tool.Name = "Ultra Instinct"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.ToolTip = "Ultra Instinct"
    tool.Parent = backpack
    FUI.Tool = tool
    table.insert(FUI.Connections, tool.Equipped:Connect(function()
        local inner = MainModule.EnsureFakeUltraInstinct()
        if not inner.Enabled then return end
        inner.Equipped = true
        MainModule.FUISetupPanel()
        task.wait(0.1)
        MainModule.FUIDoDodge()
    end))
    table.insert(FUI.Connections, tool.Unequipped:Connect(function()
        local inner = MainModule.EnsureFakeUltraInstinct()
        inner.Equipped = false
        MainModule.FUIStopAnim()
    end))
    table.insert(FUI.Connections, tool.Activated:Connect(function()
        task.wait(0.2)
        MainModule.FUIDoDodge()
    end))
end
function MainModule.FUIDestroy()
    local FUI = MainModule.EnsureFakeUltraInstinct()
    FUI.Enabled = false
    FUI.Equipped = false
    FUI.Cooldown = false
    MainModule.FUIStopAnim()
    for _, connection in ipairs(FUI.Connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(FUI.Connections)
    if FUI.Tool then
        pcall(function() FUI.Tool:Destroy() end)
        FUI.Tool = nil
    end
    if FUI.Panel then
        pcall(function() FUI.Panel:Destroy() end)
        FUI.Panel = nil
    end
    if FUI.OriginalPanel then
        pcall(function()
            if FUI.OriginalPanel:IsA("ScreenGui") then
                FUI.OriginalPanel.Enabled = true
            end
        end)
        FUI.OriginalPanel = nil
    end
    FUI.DodgeLabels = {}
    FUI.Dodges = FUI.MaxDodges
end
function MainModule.toggle_fake_ultra_instinct(enabled)
    local FUI = MainModule.EnsureFakeUltraInstinct()
    enabled = enabled == true
    if enabled then
        if FUI.Enabled then return end
        FUI.Enabled = true
        FUI.Dodges = FUI.MaxDodges
        MainModule.FUICreateTool()
    else
        MainModule.FUIDestroy()
    end
end
do
    local FUI = MainModule.EnsureFakeUltraInstinct()
    if FUI.CharacterConnection then
        pcall(function() FUI.CharacterConnection:Disconnect() end)
    end
    local player = MainModule.FUIGetPlayer()
    if player then
        FUI.CharacterConnection = player.CharacterAdded:Connect(function()
            task.wait(1)
            local inner = MainModule.EnsureFakeUltraInstinct()
            inner.Equipped = false
            inner.Cooldown = false
            inner.AnimPlaying = false
            inner.Dodges = inner.MaxDodges
            inner.Tool = nil
            inner.Panel = nil
            inner.DodgeLabels = {}
            MainModule.FUIStopAnim()
            if inner.Enabled then
                MainModule.FUICreateTool()
            end
        end)
    end
end

--@encrypt_end
MainModule.PhantomDashEnabled = false
MainModule.PhantomDashKeybind = Enum.KeyCode.Q
MainModule.PhantomDashDistance = 15
MainModule.PhantomDashDuration = 0.25
MainModule.PhantomDashCooldown = 1
MainModule.PhantomDashMaxCharges = 2
MainModule.PhantomDashCurrentCharges = 2
MainModule.PhantomDashIsMoving = false
MainModule.PhantomDashSoundId = "rbxassetid://94904871279766"
MainModule.PhantomDashBackwardSoundId = "rbxassetid://99068532205349"
MainModule.PhantomDashTextures = {
    "http://www.roblox.com/asset/?id=122158926856615",
    "http://www.roblox.com/asset/?id=14005913529",
    "http://www.roblox.com/asset/?id=17888919056",
    "http://www.roblox.com/asset/?id=14695179076",
    "http://www.roblox.com/asset/?id=15431126240",
    "http://www.roblox.com/asset/?id=14045123768"
}
MainModule.PhantomDashConnection = nil
MainModule.PhantomDashKeybindConnection = nil
MainModule.PhantomDashMobileGui = nil
MainModule.PhantomDashRechargeThread = nil

local function createDiagonalClusterTrail(parent)
    local createdEmitters = {}

    for index, textureId in ipairs(MainModule.PhantomDashTextures) do
        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "DashDiagonalCluster_" .. index
        emitter.Texture = textureId

        emitter.Color = ColorSequence.new(Color3.new(0, 0, 0))
        emitter.LightEmission = 0
        emitter.LightInfluence = 0
        emitter.Brightness = 1

        emitter.LockedToPart = false
        emitter.Orientation = Enum.ParticleOrientation.FacingCamera

        emitter.Rotation = NumberRange.new(45, 45)
        emitter.RotSpeed = NumberRange.new(0, 0)

        emitter.Speed = NumberRange.new(1, 5)
        emitter.SpreadAngle = Vector2.new(20, 20)
        emitter.Lifetime = NumberRange.new(0.3, 0.6)
        emitter.ZOffset = 1

        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 3.5),
            NumberSequenceKeypoint.new(0.5, 6),
            NumberSequenceKeypoint.new(1, 0)
        })

        emitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.6, 0.4),
            NumberSequenceKeypoint.new(1, 1)
        })

        emitter.Parent = parent
        table.insert(createdEmitters, emitter)
    end

    return createdEmitters
end

local function startRecharge()
    if MainModule.PhantomDashRechargeThread then
        task.cancel(MainModule.PhantomDashRechargeThread)
    end

    MainModule.PhantomDashRechargeThread = task.spawn(function()
        while MainModule.PhantomDashCurrentCharges < MainModule.PhantomDashMaxCharges do
            task.wait(MainModule.PhantomDashCooldown)
            MainModule.PhantomDashCurrentCharges = math.min(MainModule.PhantomDashMaxCharges, MainModule.PhantomDashCurrentCharges + 1)
        end
        MainModule.PhantomDashRechargeThread = nil
    end)
end

local function doPhantomDash()
    if MainModule.PhantomDashIsMoving or MainModule.PhantomDashCurrentCharges <= 0 then return end

    local character = MainModule.get_character()
    if not character then return end
    local hrp = MainModule.get_root_part(character)
    local humanoid = MainModule.get_humanoid(character)
    if not hrp or not humanoid then return end

    MainModule.PhantomDashIsMoving = true

    local shouldStartRecharge = (MainModule.PhantomDashCurrentCharges == MainModule.PhantomDashMaxCharges)
    MainModule.PhantomDashCurrentCharges = MainModule.PhantomDashCurrentCharges - 1

    if shouldStartRecharge then
        startRecharge()
    end

    local moveDir = humanoid.MoveDirection
    local isMovingBackward = false
    local dashDirectionVector = hrp.CFrame.LookVector

    if moveDir.Magnitude > 0 then
        local dot = moveDir:Dot(hrp.CFrame.LookVector)
        if dot < -0.2 or UserInputService:IsKeyDown(Enum.KeyCode.S) then
            isMovingBackward = true
            dashDirectionVector = -hrp.CFrame.LookVector
        else
            dashDirectionVector = moveDir
        end
    elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
        isMovingBackward = true
        dashDirectionVector = -hrp.CFrame.LookVector
    end

    local soundToPlay = isMovingBackward and MainModule.PhantomDashBackwardSoundId or MainModule.PhantomDashSoundId

    local sound = Instance.new("Sound")
    sound.SoundId = soundToPlay
    sound.Volume = 1.5
    sound.Parent = hrp
    sound:Play()
    task.delay(3, function() sound:Destroy() end)

    local emitters = createDiagonalClusterTrail(hrp)
    for _, emitter in ipairs(emitters) do
        emitter.Rate = 110
        emitter.Enabled = true
    end

    local targetCFrame = hrp.CFrame + (dashDirectionVector * MainModule.PhantomDashDistance)
    local tweenInfo = TweenInfo.new(MainModule.PhantomDashDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})

    tween:Play()

    task.wait(MainModule.PhantomDashDuration)

    for _, emitter in ipairs(emitters) do
        emitter.Enabled = false
        task.delay(1.2, function() emitter:Destroy() end)
    end

    MainModule.PhantomDashIsMoving = false
end

local function createMobilePhantomDashButton()
    if MainModule.PhantomDashMobileGui then
        MainModule.PhantomDashMobileGui:Destroy()
        MainModule.PhantomDashMobileGui = nil
    end

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local dashButton = Instance.new("TextButton")
    dashButton.Name = HttpService:GenerateGUID(false)
    dashButton.Size = UDim2.new(0, 70, 0, 70)
    dashButton.Position = UDim2.new(0.8, -35, 0.6, -35)
    dashButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dashButton.Text = "Dash"
    dashButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dashButton.Font = Enum.Font.GothamBold
    dashButton.TextSize = 16
    dashButton.Active = true
    dashButton.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = dashButton

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 2
    uiStroke.Color = Color3.fromRGB(0, 0, 0)
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    uiStroke.Parent = dashButton

    local dragging = false
    local dragStart, startPos
    local hasMoved = false

    dashButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = dashButton.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dashButton.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                hasMoved = true
            end
            dashButton.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    dashButton.MouseButton1Click:Connect(function()
        if not hasMoved then
            doPhantomDash()
        end
    end)

    MainModule.PhantomDashMobileGui = screenGui
end

function MainModule.toggle_phantom_dash(enabled)
    MainModule.PhantomDashEnabled = enabled

    if MainModule.PhantomDashConnection then
        MainModule.PhantomDashConnection:Disconnect()
        MainModule.PhantomDashConnection = nil
    end

    if MainModule.PhantomDashKeybindConnection then
        MainModule.PhantomDashKeybindConnection:Disconnect()
        MainModule.PhantomDashKeybindConnection = nil
    end

    if MainModule.PhantomDashMobileGui then
        MainModule.PhantomDashMobileGui:Destroy()
        MainModule.PhantomDashMobileGui = nil
    end

    if MainModule.PhantomDashRechargeThread then
        task.cancel(MainModule.PhantomDashRechargeThread)
        MainModule.PhantomDashRechargeThread = nil
    end

    MainModule.PhantomDashCurrentCharges = MainModule.PhantomDashMaxCharges
    MainModule.PhantomDashIsMoving = false

    if enabled then
        if MainModule.is_mobile() then
            createMobilePhantomDashButton()
        else
            MainModule.PhantomDashKeybindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == MainModule.PhantomDashKeybind then
                    doPhantomDash()
                end
            end)
        end
    end

    PlayToggleSound()
end

function MainModule.set_phantom_dash_keybind(keycode)
    MainModule.PhantomDashKeybind = keycode
end

function MainModule.set_phantom_dash_distance(value)
    MainModule.PhantomDashDistance = value
end

function MainModule.set_phantom_dash_duration(value)
    MainModule.PhantomDashDuration = value / 100
end

function MainModule.set_phantom_dash_cooldown(value)
    MainModule.PhantomDashCooldown = value
end

function MainModule.set_phantom_dash_max_charges(value)
    MainModule.PhantomDashMaxCharges = value
    MainModule.PhantomDashCurrentCharges = value
end

MainModule.RLGLEnabled = false
MainModule.RLGLConnection = nil
MainModule.RLGLOriginalWalkSpeed = 16
MainModule.RLGLOriginalJumpPower = 50
MainModule.RLGLOriginalJumpHeight = 7.2
MainModule.RLGLWasFrozen = false
MainModule.RLGLRedLightAnimId = "rbxassetid://73083130944511"

MainModule.RLGLPointA = Vector3.new(-215, 1023, -513)
MainModule.RLGLPointB = Vector3.new(116, 1023, 82)

MainModule.RLGLMinX = math.min(MainModule.RLGLPointA.X, MainModule.RLGLPointB.X)
MainModule.RLGLMaxX = math.max(MainModule.RLGLPointA.X, MainModule.RLGLPointB.X)
MainModule.RLGLMinY = math.min(MainModule.RLGLPointA.Y, MainModule.RLGLPointB.Y) - 50
MainModule.RLGLMaxY = math.max(MainModule.RLGLPointA.Y, MainModule.RLGLPointB.Y) + 50
MainModule.RLGLMinZ = math.min(MainModule.RLGLPointA.Z, MainModule.RLGLPointB.Z)
MainModule.RLGLMaxZ = math.max(MainModule.RLGLPointA.Z, MainModule.RLGLPointB.Z)

pcall(function()
    local anim = ReplicatedStorage:FindFirstChild("Animations")
        and ReplicatedStorage.Animations:FindFirstChild("Games")
        and ReplicatedStorage.Animations.Games:FindFirstChild("RedLightGreenLight")
        and ReplicatedStorage.Animations.Games.RedLightGreenLight:FindFirstChild("RedLightTurn")
    if anim and anim:IsA("Animation") then
        MainModule.RLGLRedLightAnimId = anim.AnimationId
    end
end)

function MainModule.getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function MainModule.getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function MainModule.isPlayerInZone()
    local hrp = MainModule.getHRP()
    if not hrp then return false end
    local pos = hrp.Position
    return (pos.X >= MainModule.RLGLMinX and pos.X <= MainModule.RLGLMaxX)
       and (pos.Y >= MainModule.RLGLMinY and pos.Y <= MainModule.RLGLMaxY)
       and (pos.Z >= MainModule.RLGLMinZ and pos.Z <= MainModule.RLGLMaxZ)
end

MainModule.RLGLCachedAnimators = {}
MainModule.RLGLLastCacheTime = 0

function MainModule.updateAnimatorCache()
    local currentTime = tick()
    if currentTime - MainModule.RLGLLastCacheTime < 0.5 then return end
    MainModule.RLGLLastCacheTime = currentTime
    table.clear(MainModule.RLGLCachedAnimators)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Animator") then
            table.insert(MainModule.RLGLCachedAnimators, obj)
        end
    end
end

function MainModule.isRedLightActive()
    MainModule.updateAnimatorCache()
    local targetId = tostring(MainModule.RLGLRedLightAnimId)
    for i = #MainModule.RLGLCachedAnimators, 1, -1 do
        local animator = MainModule.RLGLCachedAnimators[i]
        if not animator or not animator.Parent then
            table.remove(MainModule.RLGLCachedAnimators, i)
        else
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                if track.Animation and track.IsPlaying then
                    local animId = tostring(track.Animation.AnimationId)
                    if animId == targetId then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function MainModule.freezePlayer()
    local humanoid = MainModule.getHumanoid()
    local hrp = MainModule.getHRP()
    if not humanoid then return end
    if not MainModule.RLGLWasFrozen then
        MainModule.RLGLOriginalWalkSpeed = humanoid.WalkSpeed
        MainModule.RLGLOriginalJumpPower = humanoid.JumpPower
        MainModule.RLGLOriginalJumpHeight = humanoid.JumpHeight
        MainModule.RLGLWasFrozen = true
    end
    humanoid:Move(Vector3.new(0, 0, 0), false)
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.JumpHeight = 0
end

function MainModule.unfreezePlayer()
    local humanoid = MainModule.getHumanoid()
    if not humanoid then return end
    humanoid.WalkSpeed = MainModule.RLGLOriginalWalkSpeed > 0 and MainModule.RLGLOriginalWalkSpeed or 16
    humanoid.JumpPower = MainModule.RLGLOriginalJumpPower > 0 and MainModule.RLGLOriginalJumpPower or 50
    humanoid.JumpHeight = MainModule.RLGLOriginalJumpHeight > 0 and MainModule.RLGLOriginalJumpHeight or 7.2
    MainModule.RLGLWasFrozen = false
end

function MainModule.toggle_rlgl_stop(enabled)
    MainModule.RLGLEnabled = enabled
    if MainModule.RLGLConnection then
        MainModule.RLGLConnection:Disconnect()
        MainModule.RLGLConnection = nil
    end
    if enabled then
        MainModule.RLGLConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.RLGLEnabled then return end
            if MainModule.isPlayerInZone() and MainModule.isRedLightActive() then
                MainModule.freezePlayer()
            else
                if MainModule.RLGLWasFrozen then
                    MainModule.unfreezePlayer()
                end
            end
        end)
    else
        if MainModule.RLGLWasFrozen then
            MainModule.unfreezePlayer()
        end
    end
    if PlayToggleSound then
        PlayToggleSound()
    end
end

MainModule.TugOfWarQTEMode = false
MainModule.TugOfWarQTEConnection = nil
MainModule.TugOfWarQTEUI = nil

local qte = nil
pcall(function()
	qte = require(ReplicatedStorage:WaitForChild("Modules", 5):WaitForChild("HBGQTE", 5))
end)

local function findTugOfWarUI()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end

    local ui = playerGui:FindFirstChild("TugOfWarUIV2")
        or playerGui:FindFirstChild("TugOfWarUI")
        or playerGui:FindFirstChild("TugofWarRemake")

    if ui then return ui end

    local storage = ReplicatedStorage:FindFirstChild("UI")
    if storage then
        ui = storage:FindFirstChild("TugOfWarUIV2")
            or storage:FindFirstChild("TugOfWarUI")
        if ui then
            local clone = ui:Clone()
            clone.Parent = playerGui
            return clone
        end
    end

    return nil
end

function MainModule.toggle_tug_of_war_qte(enabled)
    MainModule.TugOfWarQTEMode = enabled

    if MainModule.TugOfWarQTEConnection then
        MainModule.TugOfWarQTEConnection:Disconnect()
        MainModule.TugOfWarQTEConnection = nil
    end

    if MainModule.TugOfWarQTEUI then
        MainModule.TugOfWarQTEUI:Destroy()
        MainModule.TugOfWarQTEUI = nil
    end

    if enabled then
        LocalPlayer:SetAttribute("TugOfWarPhase", "QTE")
        workspace:SetAttribute("TugOfWarRhythmGoal", 180)
        workspace:SetAttribute("TugOfWarRush", nil)

        local ui = findTugOfWarUI()
        if ui then
            ui.Enabled = true
            MainModule.TugOfWarQTEUI = ui

            local handler = ui:FindFirstChild("TugOfWarQTEHandler", true)
                or ui:FindFirstChildWhichIsA("LocalScript", true)
                or ui:FindFirstChildWhichIsA("Script", true)

            if handler and handler:IsA("LocalScript") then
                handler.Disabled = false
            end
        end

        task.wait(0.3)
        LocalPlayer:SetAttribute("TugOfWarPhase", "QTE")

        MainModule.notify("Tug of War", "QTE Mode Enabled", 0.9)
    else
        MainModule.notify("Tug of War", "QTE Mode Disabled", 0.9)
    end

    PlayToggleSound()
end

local qteButtonsRunning = false
local qteButtonsTask = nil

local function StopQTEButtons()
    qteButtonsRunning = false
    if qteButtonsTask then
        task.cancel(qteButtonsTask)
        qteButtonsTask = nil
    end
end

MainModule.QTELetters = MainModule.QTELetters or "WASD"
MainModule.QTESpawnSpeed = MainModule.QTESpawnSpeed or 0.5

local function StartQTEButtons()
    StopQTEButtons()

    local letters = MainModule.QTELetters or "WASD"
    local speed = tonumber(MainModule.QTESpawnSpeed) or 0.5

    local filtered = {}
    for i = 1, #tostring(letters) do
        local char = tostring(letters):sub(i, i):upper()
        if char:match("[A-Z]") then
            filtered[#filtered + 1] = char
        end
    end

    if #filtered == 0 then
        HSXNotify("QTE Buttons", "No valid letters entered", 0.9)
        return
    end

    local qteMod = qte
    if not qteMod then
        pcall(function()
            local mods = ReplicatedStorage:FindFirstChild("Modules")
            if mods then
                local m = mods:FindFirstChild("HBGQTE")
                if m then qteMod = require(m) end
            end
        end)
        qte = qteMod
    end
    if not qteMod or type(qteMod.SetUpButton) ~= "function" then
        HSXNotify("QTE Buttons", "HBGQTE not available right now", 0.9)
        return
    end

    qteButtonsRunning = true
    qteButtonsTask = task.spawn(function()
        local index = 1
        while qteButtonsRunning do
            local key = filtered[index]
            local ok, err = pcall(function()
                qteMod.SetUpButton(3, key, false, nil)
            end)
            if not ok then
                qteButtonsRunning = false
                break
            end
            index = index % #filtered + 1
            task.wait(speed)
        end
        qteButtonsTask = nil
    end)
end

function MainModule.toggle_qte_buttons(enabled)
    if enabled then
        StartQTEButtons()
    else
        StopQTEButtons()
    end
    PlayToggleSound()
end

MainModule.BalloonData = {

    ESPEnabled = false,

    TPEnabled = false,

    Tracers = {},

    Highlights = {},

    NotifiedBalloons = {},

    ProcessedPrompts = {}

}

local function firePromptExecutor(prompt)

    if not prompt or not prompt:IsA("ProximityPrompt") then return end

    if fireproximityprompt then

        pcall(function() fireproximityprompt(prompt) end)

    elseif syn and syn.proximityprompt then

        pcall(function() syn.proximityprompt(prompt) end)

    else

        local originalDuration = prompt.HoldDuration

        prompt.HoldDuration = 0

        pcall(function()

            prompt:InputHoldBegin()

            task.wait()

            prompt:InputHoldEnd()

        end)

        prompt.HoldDuration = originalDuration

    end

end

function MainModule.toggle_balloon_teleport(enabled)
    MainModule.BalloonData.TPEnabled = enabled
end

local function isPromptClaimable(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false end
    if not prompt.Enabled then return false end
    if not prompt.Parent then return false end
    if prompt.MaxActivationDistance and prompt.MaxActivationDistance <= 0 then return false end
    return true
end

task.spawn(function()
    while task.wait(0.2) do
        if MainModule.BalloonData.TPEnabled then
            local effects = workspace:FindFirstChild("Effects")
            if effects then
                for _, balloon in ipairs(effects:GetChildren()) do
                    if balloon.Name == "Balloon" and not MainModule.BalloonData.ProcessedPrompts[balloon] then
                        local prompt = balloon:FindFirstChild("BalloonProximityPrompt", true)
                            or balloon:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt and isPromptClaimable(prompt) then
                            MainModule.BalloonData.ProcessedPrompts[balloon] = true
                            task.spawn(function()
                                if not (balloon and balloon.Parent and MainModule.BalloonData.TPEnabled) then return end
                                if not isPromptClaimable(prompt) then
                                    MainModule.BalloonData.ProcessedPrompts[balloon] = nil
                                    return
                                end
                                local targetPart = prompt.Parent:IsA("BasePart") and prompt.Parent
                                    or balloon:FindFirstChildWhichIsA("BasePart", true)
                                local char = MainModule.get_character()
                                local hrp = char and MainModule.get_root_part(char)
                                if char and hrp and targetPart then
                                    pcall(function()
                                        char:PivotTo(targetPart.CFrame * CFrame.new(0, 5, 0))
                                    end)
                                    task.wait(0.2)
                                    if isPromptClaimable(prompt) then
                                        firePromptExecutor(prompt)
                                    end
                                else
                                    MainModule.BalloonData.ProcessedPrompts[balloon] = nil
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

function MainModule.create_esp_visuals(balloon)

    local targetPart = balloon:IsA("BasePart") and balloon or balloon:FindFirstChildWhichIsA("BasePart", true)

    if not targetPart then return end

    if not MainModule.BalloonData.NotifiedBalloons[balloon] then

        MainModule.BalloonData.NotifiedBalloons[balloon] = true

        if Library and HSXNotify then

            HSXNotify({Title = "HollyScriptX", Description = "Balloon detected!", Duration = 0.9})

        end

        if PlayErrorSound then PlayErrorSound() end

    end

    if not MainModule.BalloonData.Highlights[balloon] then

        local highlight = Instance.new("Highlight")

        highlight.Name = "BalloonHighlight"

        highlight.Adornee = balloon

        highlight.FillColor = Color3.fromRGB(255, 255, 255)

        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

        highlight.FillTransparency = 0.5

        highlight.OutlineTransparency = 0

        highlight.Parent = balloon

        MainModule.BalloonData.Highlights[balloon] = highlight

    end

    local char = MainModule.get_character()

    if char then

        local hrp = MainModule.get_root_part(char)

        if hrp and not MainModule.BalloonData.Tracers[targetPart] then

            local a0 = Instance.new("Attachment", hrp)

            a0.Name = "BalloonTracerA0"

            local a1 = Instance.new("Attachment", targetPart)

            a1.Name = "BalloonTracerA1"

            local beam = Instance.new("Beam")

            beam.Name = "BalloonTracerBeam"

            beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))

            beam.Width0 = 0.15

            beam.Width1 = 0.15

            beam.FaceCamera = true

            beam.Attachment0 = a0

            beam.Attachment1 = a1

            beam.Parent = targetPart

            MainModule.BalloonData.Tracers[targetPart] = {

                Attachment0 = a0,

                Attachment1 = a1,

                Beam = beam

            }

        end

    end

    balloon.AncestryChanged:Connect(function(_, parent)

        if not parent then

            MainModule.BalloonData.NotifiedBalloons[balloon] = nil

            MainModule.BalloonData.ProcessedPrompts[balloon] = nil

            if MainModule.BalloonData.Highlights[balloon] then

                pcall(function() MainModule.BalloonData.Highlights[balloon]:Destroy() end)

                MainModule.BalloonData.Highlights[balloon] = nil

            end

            if MainModule.BalloonData.Tracers[targetPart] then

                pcall(function()

                    MainModule.BalloonData.Tracers[targetPart].Attachment0:Destroy()

                    MainModule.BalloonData.Tracers[targetPart].Attachment1:Destroy()

                    MainModule.BalloonData.Tracers[targetPart].Beam:Destroy()

                end)

                MainModule.BalloonData.Tracers[targetPart] = nil

            end

        end

    end)

end

function MainModule.toggle_balloon_esp(enabled)

    MainModule.BalloonData.ESPEnabled = enabled

    if not enabled then

        for balloon, hl in pairs(MainModule.BalloonData.Highlights) do

            pcall(function() hl:Destroy() end)

        end

        for _, data in pairs(MainModule.BalloonData.Tracers) do

            pcall(function()

                data.Attachment0:Destroy()

                data.Attachment1:Destroy()

                data.Beam:Destroy()

            end)

        end

        MainModule.BalloonData.Highlights = {}

        MainModule.BalloonData.Tracers = {}

        MainModule.BalloonData.NotifiedBalloons = {}

    end

end

task.spawn(function()

    while task.wait(0.5) do

        if MainModule.BalloonData.ESPEnabled then

            local effects = workspace:FindFirstChild("Effects")

            if effects then

                for _, child in ipairs(effects:GetChildren()) do

                    if child.Name == "Balloon" then

                        MainModule.create_esp_visuals(child)

                    end

                end

            end

        end

    end

end)

MainModule.noclipEnabled = false
MainModule.noclipButton = nil
MainModule.noclipConnection = nil
MainModule.TELEPORT_DISTANCE = 13
MainModule.RAY_LENGTH = 6

MainModule.createNoclipButton = function()
    if MainModule.noclipButton then pcall(function() MainModule.noclipButton:Destroy() end) end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = HttpService:GenerateGUID(false)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local button = Instance.new("TextButton")
    button.Name = HttpService:GenerateGUID(false)
    button.Size = UDim2.new(0, 90, 0, 90)
    button.Position = UDim2.new(1, -110, 0.5, -45)
    button.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    button.BackgroundTransparency = 0.25
    button.Text = "TP Wall"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = true
    button.Parent = screenGui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(200, 200, 210)
    stroke.Thickness = 1.5
    stroke.Parent = button

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button

    local dragging = false
    local moved = false
    local dragStart = nil
    local startPos = nil

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = button.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then
                moved = true
            end
            button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging and not moved then
                pcall(function() MainModule.teleportThroughWall() end)
            end
            dragging = false
        end
    end)

    MainModule.noclipButton = screenGui
    return screenGui
end

MainModule.ThroughWallsEnabled = false
MainModule.ThroughWallsConn = nil
MainModule.RAY_LENGTH = MainModule.RAY_LENGTH or 50
MainModule.TELEPORT_DISTANCE = MainModule.TELEPORT_DISTANCE or 8

function MainModule.toggle_through_walls(enabled)
    MainModule.ThroughWallsEnabled = enabled and true or false
    MainModule.noclipEnabled = MainModule.ThroughWallsEnabled
    if MainModule.ThroughWallsConn then
        pcall(function() MainModule.ThroughWallsConn:Disconnect() end)
        MainModule.ThroughWallsConn = nil
    end
    
    if MainModule.noclipButton then
        pcall(function() MainModule.noclipButton:Destroy() end)
        MainModule.noclipButton = nil
    end
    if MainModule.ThroughWallsEnabled then
        MainModule.ThroughWallsConn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.X then
                pcall(function() MainModule.teleportThroughWall() end)
            end
        end)
        
        local isMobile = false
        pcall(function()
            isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        end)
        if isMobile and MainModule.createNoclipButton then
            pcall(MainModule.createNoclipButton)
        end
    end
    PlayToggleSound()
    return true
end
MainModule.teleportThroughWall = function()
    if not MainModule.noclipEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local direction = cam.CFrame.LookVector
    local origin = root.Position
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {char}
    rayParams.IgnoreWater = true
    local rayResult = workspace:Raycast(origin, direction * MainModule.RAY_LENGTH, rayParams)
    local targetPos = origin + (direction * MainModule.TELEPORT_DISTANCE)
    if rayResult then
        local hitPos = rayResult.Position
        local normal = rayResult.Normal
        targetPos = hitPos + (direction * 3) + (normal * 2)
    end
    root.CanCollide = false
    root.CFrame = CFrame.new(targetPos)
    task.wait()
    root.CanCollide = true
end

MainModule.desyncHooked = false
MainModule.desyncAvailable = pcall(function() return raknet and raknet.add_send_hook end)

MainModule.rakhook = function(packet)
    if packet.PacketId == 0x1B then
        local buf = packet.AsBuffer
        if buffer and buffer.writeu32 then
            buffer.writeu32(buf, 1, 0xFFFFFFFF)
            packet:SetData(buf)
        end
    end
end

MainModule.toggle_desync = function(enabled)
    local toggleRef = MainModule.ToggleRefs.Desync

    if enabled and MainModule.is_xeno_executor() then
        MainModule.notify("Desync", "Not supported in your executor", 0.9)
        PlayErrorSound()
        if toggleRef and toggleRef.SetValue then
            pcall(function() toggleRef:SetValue(false) end)
        end
        return false
    end
    if not MainModule.desyncAvailable then
        MainModule.notify("Desync", "Unsupported Executor", 0.9)
        PlayErrorSound()
        if toggleRef and toggleRef.SetValue then
            pcall(function() toggleRef:SetValue(false) end)
        end
        return false
    end
    if enabled then
        if not MainModule.desyncHooked then
            pcall(function()
                raknet.add_send_hook(MainModule.rakhook)
                MainModule.desyncHooked = true
            end)
        end
    else
        if MainModule.desyncHooked then
            pcall(function()
                raknet.remove_send_hook(MainModule.rakhook)
                MainModule.desyncHooked = false
            end)
        end
    end
    PlayToggleSound()
    return true
end

MainModule.PlayerAttachEnabled = false
MainModule.attachedTarget = nil
MainModule.attachConnection = nil
MainModule.autoSearchConnection = nil

MainModule.BehindSquare = nil
MainModule.FrontSquare = nil
MainModule.CurrentSquare = nil
MainModule.CurrentBodyVelocity = nil

MainModule.AttachConfig = {
    BehindDistance = 2.5,
    FrontDistance = 16,
    SpeedThreshold = 17,
    MaxSpeed = 500,
    TransitionSpeed = 150,
}

MainModule.createSquare = function(name, offsetDistance)
    local square = Instance.new("Part")
    square.Name = name
    square.Size = Vector3.new(3, 0.5, 3)
    square.Transparency = 1
    square.CanCollide = false
    square.Anchored = true
    square.Massless = true
    square.Parent = workspace
    return square
end

MainModule.destroySquares = function()
    if MainModule.BehindSquare then
        MainModule.BehindSquare:Destroy()
        MainModule.BehindSquare = nil
    end
    if MainModule.FrontSquare then
        MainModule.FrontSquare:Destroy()
        MainModule.FrontSquare = nil
    end
end

MainModule.isTargetMovingForward = function(targetRoot)
    if not targetRoot then return false end
    local targetVel = targetRoot.Velocity
    local horizontalSpeed = math.sqrt(targetVel.X^2 + targetVel.Z^2)
    if horizontalSpeed < 2 then return false end
    local targetLook = targetRoot.CFrame.LookVector
    local moveDir = Vector3.new(targetVel.X, 0, targetVel.Z).Unit
    local lookDir = Vector3.new(targetLook.X, 0, targetLook.Z).Unit
    return lookDir:Dot(moveDir) > 0.7
end

MainModule.updateSquares = function(targetRoot)
    if not targetRoot then return end
    local targetPos = targetRoot.Position
    local targetLook = targetRoot.CFrame.LookVector
    local targetHeight = targetRoot.Position.Y

    local behindPos = targetPos + (-targetLook * MainModule.AttachConfig.BehindDistance)
    behindPos = Vector3.new(behindPos.X, targetHeight - 2, behindPos.Z)

    local frontPos = targetPos + (targetLook * MainModule.AttachConfig.FrontDistance)
    frontPos = Vector3.new(frontPos.X, targetHeight - 2, frontPos.Z)

    if MainModule.BehindSquare then MainModule.BehindSquare.Position = behindPos end
    if MainModule.FrontSquare then MainModule.FrontSquare.Position = frontPos end
end

MainModule.getTargetSquare = function(targetRoot)
    if not targetRoot then return MainModule.BehindSquare end
    local targetVel = targetRoot.Velocity
    local horizontalSpeed = math.sqrt(targetVel.X^2 + targetVel.Z^2)
    local isFast = horizontalSpeed > MainModule.AttachConfig.SpeedThreshold
    local isMovingForward = MainModule.isTargetMovingForward(targetRoot)

    if isFast and isMovingForward then
        return MainModule.FrontSquare
    else
        return MainModule.BehindSquare
    end
end

MainModule.applySmoothMovement = function(targetPos, isTransition)
    local myChar = LocalPlayer.Character
    if not myChar then return end

    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar:FindFirstChildOfClass("Humanoid")

    if not myRoot or not myHum then return end

    if not targetPos then return end

    local currentPos = myRoot.Position
    local distance = (targetPos - currentPos).Magnitude

    if distance > 0.3 then
        local direction = (targetPos - currentPos).Unit
        local speed = isTransition and MainModule.AttachConfig.TransitionSpeed or MainModule.AttachConfig.MaxSpeed
        local moveVector = direction * math.min(speed, distance * 10)

        if MainModule.CurrentBodyVelocity then
            MainModule.CurrentBodyVelocity:Destroy()
        end

        MainModule.CurrentBodyVelocity = Instance.new("BodyVelocity")
        MainModule.CurrentBodyVelocity.MaxForce = Vector3.new(50000, 0, 50000)
        MainModule.CurrentBodyVelocity.Velocity = Vector3.new(moveVector.X, 0, moveVector.Z)
        MainModule.CurrentBodyVelocity.Parent = myRoot

        task.wait(0.03)

        if MainModule.CurrentBodyVelocity then
            MainModule.CurrentBodyVelocity:Destroy()
            MainModule.CurrentBodyVelocity = nil
        end
    end

    myHum.AutoRotate = true
end

MainModule.find_best_target = function()
    local localPlayer = LocalPlayer
    if not localPlayer then return nil end

    local isSeeker = MainModule.is_seeker(localPlayer)
    local isHider = MainModule.is_hider(localPlayer)

    local myChar = LocalPlayer.Character
    if not myChar then return nil end

    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local bestTarget = nil
    local bestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then

                local valid = false
                if isSeeker and MainModule.is_hider(player) then
                    valid = true
                elseif isHider and MainModule.is_seeker(player) then
                    valid = true
                elseif not isSeeker and not isHider then
                    valid = true
                end

                if valid then
                    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local dist = (targetRoot.Position - myRoot.Position).Magnitude
                        if dist < bestDistance then
                            bestDistance = dist
                            bestTarget = player
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

MainModule.lastSquare = nil

MainModule.attachToPlayer = function(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    if MainModule.attachedTarget == targetPlayer then return true end

    if MainModule.attachedTarget then MainModule.detach() end

    local myChar = LocalPlayer.Character
    if not myChar then return false end

    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    if not myRoot or not myHum then return false end

    MainModule.destroySquares()
    MainModule.BehindSquare = MainModule.createSquare("BehindSquare", MainModule.AttachConfig.BehindDistance)
    MainModule.FrontSquare = MainModule.createSquare("FrontSquare", MainModule.AttachConfig.FrontDistance)

    MainModule.attachedTarget = targetPlayer
    MainModule.lastSquare = nil

    myHum.WalkSpeed = MainModule.AttachConfig.MaxSpeed
    myHum.AutoRotate = true
    myHum.PlatformStand = false

    if not MainModule.FaceTargetModule.Enabled then
        MainModule.toggle_face_target(true)
        if MainModule.ToggleRefs.FaceTarget then MainModule.ToggleRefs.FaceTarget:SetValue(true) end
    end

    if MainModule.attachConnection then MainModule.attachConnection:Disconnect() end

    MainModule.attachConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.PlayerAttachEnabled or not MainModule.attachedTarget then
            MainModule.detach()
            return
        end

        if not MainModule.attachedTarget or not MainModule.attachedTarget.Character then
            MainModule.detach()
            return
        end

        local targetChar = MainModule.attachedTarget.Character
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local targetHum = targetChar:FindFirstChildOfClass("Humanoid")

        if not targetRoot or not targetHum or targetHum.Health <= 0 then
            local newTarget = MainModule.find_best_target()
            if newTarget and newTarget ~= MainModule.attachedTarget then
                MainModule.attachToPlayer(newTarget)
                PlayDeathSound()
            else
                MainModule.detach()
                MainModule.notify("KillAura", "No new target's found :c", 0.9)
                PlayErrorSound()
                if MainModule.ToggleRefs.PlayerAttach then MainModule.ToggleRefs.PlayerAttach:SetValue(false) end
            end
            return
        end

        MainModule.updateSquares(targetRoot)

        local targetSquare = MainModule.getTargetSquare(targetRoot)
        if targetSquare then
            local isChangingSquare = (MainModule.lastSquare ~= nil and MainModule.lastSquare ~= targetSquare)
            local targetPos = targetSquare.Position
            local targetHeightPos = Vector3.new(targetPos.X, targetPos.Y + 2.5, targetPos.Z)
            MainModule.applySmoothMovement(targetHeightPos, isChangingSquare)
            MainModule.lastSquare = targetSquare
        end
    end)

    return true
end

MainModule.detach = function()
    if MainModule.attachConnection then
        MainModule.attachConnection:Disconnect()
        MainModule.attachConnection = nil
    end

    if MainModule.CurrentBodyVelocity then
        MainModule.CurrentBodyVelocity:Destroy()
        MainModule.CurrentBodyVelocity = nil
    end

    MainModule.destroySquares()

    local myChar = LocalPlayer.Character
    if myChar then
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        if myHum then
            myHum.PlatformStand = false
            myHum.AutoRotate = true
            myHum.WalkSpeed = 16
        end

        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if myRoot then
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end

    if MainModule.FaceTargetModule.Enabled then
        MainModule.toggle_face_target(false)
        if MainModule.ToggleRefs.FaceTarget then MainModule.ToggleRefs.FaceTarget:SetValue(false) end
    end

    MainModule.attachedTarget = nil
    MainModule.CurrentSquare = nil
    MainModule.lastSquare = nil
end

MainModule.startAutoSearch = function()
    if MainModule.autoSearchConnection then MainModule.autoSearchConnection:Disconnect() end

    MainModule.autoSearchConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.PlayerAttachEnabled then return end
        if MainModule.attachedTarget then return end

        if tick() % 1 < 0.05 then
            local bestTarget = MainModule.find_best_target()
            if bestTarget then
                MainModule.attachToPlayer(bestTarget)
                PlayBell()
            end
        end
    end)
end

MainModule.toggle_player_attach = function(enabled)
    MainModule.PlayerAttachEnabled = enabled

    if enabled then
        local bestTarget = MainModule.find_best_target()

        if bestTarget then
            MainModule.attachToPlayer(bestTarget)
            PlayBell()
            MainModule.startAutoSearch()
        else
            MainModule.notify("Killaura", "No player's found :c", 0.9)
            PlayErrorSound()
            MainModule.PlayerAttachEnabled = false
            if MainModule.ToggleRefs.PlayerAttach then MainModule.ToggleRefs.PlayerAttach:SetValue(false) end
        end
    else
        if MainModule.autoSearchConnection then
            MainModule.autoSearchConnection:Disconnect()
            MainModule.autoSearchConnection = nil
        end
        MainModule.detach()
    end
    PlayToggleSound()
end

MainModule.spectate_player = function(player)
    if not player then return end
    if not player.Character then
        MainModule.notify("Spectate", "Player has no character", 0.9)
        PlayErrorSound()
        return
    end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then
        HSXNotify({Title = "Spectate", Description = "Player is dead", Duration = 0.9})
        PlayErrorSound()
        return
    end
    workspace.CurrentCamera.CameraSubject = hum
    HSXNotify({Title = "Spectate", Description = "Spectating: " .. player.Name, Duration = 0.9})
    PlayBell()
end

MainModule.stop_spectate = function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            workspace.CurrentCamera.CameraSubject = hum
            HSXNotify({Title = "Spectate", Description = "Stopped", Duration = 0.9})
            PlayBell()
        end
    end
end

MainModule.teleport_to_player = function(player)
    if not player then return end
    if not player.Character then
        HSXNotify({Title = "Teleport", Description = "Player has no character", Duration = 0.9})
        PlayErrorSound()
        return
    end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        HSXNotify({Title = "Teleport", Description = "Player has no root part", Duration = 0.9})
        PlayErrorSound()
        return
    end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
    HSXNotify({Title = "Teleport", Description = "Teleported to: " .. player.Name, Duration = 0.9})
    PlayBell()
end

MainModule.getNearestPlayerAnywhere = function()
    local nearest = nil
    local shortest = math.huge
    local myChar = MainModule.get_character()
    if not myChar then return nil end
    local myPos = myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position
    if not myPos then return nil end
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local rp = p.Character:FindFirstChild("HumanoidRootPart")
            if rp then
                local d = (rp.Position - myPos).Magnitude
                if d < shortest then shortest = d; nearest = p end
            end
        end
    end
    return nearest
end

MainModule.teleportToNearest = function()
    local nearest = MainModule.getNearestPlayerAnywhere()
    if nearest and nearest.Character then
        local root = nearest.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local myChar = LocalPlayer.Character
            if myChar then
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
                    MainModule.notify("Teleport", "Teleported to: " .. nearest.Name, 0.9)
                    PlayBell()
                end
            end
        end
    else
        HSXNotify({Title = "Teleport", Description = "No player's near :c", Duration = 0.9})
        PlayErrorSound()
    end
end

MainModule.update_all_toggles_by_game = function()
    local values = Workspace:FindFirstChild("Values")
    if not values then return end
    local currentGame = values:FindFirstChild("CurrentGame")
    local gameName = currentGame and currentGame.Value

    MainModule.update_toggle_availability("AutoDodge", gameName == "HideAndSeek" and "HideAndSeek" or nil, MainModule.ToggleRefs.AutoDodge)
    MainModule.update_toggle_availability("InfiniteStamina", gameName == "HideAndSeek" and "HideAndSeek" or nil, MainModule.ToggleRefs.InfiniteStamina)
    MainModule.update_toggle_availability("SpikesKill", gameName == "HideAndSeek" and "HideAndSeek" or nil, MainModule.ToggleRefs.SpikesKill)
    MainModule.update_toggle_availability("AutoEscape", gameName == "HideAndSeek" and "HideAndSeek" or nil, MainModule.ToggleRefs.AutoEscape)
    MainModule.update_toggle_availability("KeyESP", gameName == "HideAndSeek" and "HideAndSeek" or nil, MainModule.ToggleRefs.KeyESP)
    MainModule.update_toggle_availability("JumpRopeAntiFall", gameName == "JumpRope" and "JumpRope" or nil, MainModule.ToggleRefs.JumpRopeAntiFall)
    MainModule.update_toggle_availability("GlassESP", gameName == "GlassBridge" and "GlassBridge" or nil, MainModule.ToggleRefs.GlassESP)
    MainModule.update_toggle_availability("AntiBreak", gameName == "GlassBridge" and "GlassBridge" or nil, MainModule.ToggleRefs.AntiBreak)
    MainModule.update_toggle_availability("ZoneKill", gameName == "LastDinner" and "LastDinner" or nil, MainModule.ToggleRefs.ZoneKill)
    MainModule.update_toggle_availability("VoidKill", gameName == "SkySquidGame" and "SkySquidGame" or nil, MainModule.ToggleRefs.VoidKill)
    MainModule.update_toggle_availability("SkySquidAntiFall", gameName == "SkySquidGame" and "SkySquidGame" or nil, MainModule.ToggleRefs.SkySquidAntiFall)
    MainModule.update_toggle_availability("MingleVoidKill", gameName == "Mingle" and "Mingle" or nil, MainModule.ToggleRefs.MingleVoidKill)
    MainModule.update_toggle_availability("GodMode", gameName == "RedLightGreenLight" and "RedLightGreenLight" or nil, MainModule.ToggleRefs.GodMode)
    MainModule.update_toggle_availability("RemoveInjury", gameName == "RedLightGreenLight" and "RedLightGreenLight" or nil, MainModule.ToggleRefs.RemoveInjury)
    MainModule.update_toggle_availability("AutoChoke", gameName == "Mingle" and "Mingle" or nil, MainModule.ToggleRefs.AutoChoke)
    MainModule.update_toggle_availability("AutoPickupKeys", gameName == "HideAndSeek" and "HideAndSeek" or nil, MainModule.ToggleRefs.AutoPickup)
end

MainModule.GameStateMonitor = {
    Connection = nil,
    LastGame = nil
}

MainModule.GameStateMonitor.Start = function()
    if MainModule.GameStateMonitor.Connection then MainModule.GameStateMonitor.Connection:Disconnect() end

    MainModule.GameStateMonitor.Connection = RunService.Heartbeat:Connect(function()
        local values = Workspace:FindFirstChild("Values")
        if not values then return end
        local currentGame = values:FindFirstChild("CurrentGame")
        local gameName = currentGame and currentGame.Value

        if gameName ~= MainModule.GameStateMonitor.LastGame then
            if MainModule.GameStateMonitor.LastGame then
                MainModule.GameStateMonitor.DisableGameToggles(MainModule.GameStateMonitor.LastGame)
            end
            MainModule.GameStateMonitor.LastGame = gameName
            MainModule.update_all_toggles_by_game()
        end
    end)
end

MainModule.GameStateMonitor.DisableGameToggles = function(gameName)
    local toggles = {
        HideAndSeek = {"AutoDodge", "InfiniteStamina", "SpikesKill", "AutoEscape", "KeyESP", "AutoPickupKeys"},
        JumpRope = {"JumpRopeAntiFall"},
        GlassBridge = {"GlassESP", "AntiBreak"},
        LastDinner = {"ZoneKill"},
        SkySquidGame = {"VoidKill", "SkySquidAntiFall"},
        Mingle = {"MingleVoidKill", "AutoChoke"},
        RedLightGreenLight = {"GodMode", "RemoveInjury"}
    }

    local gameToggles = toggles[gameName]
    if gameToggles then
        for _, toggleName in ipairs(gameToggles) do
            MainModule.disable_toggle(toggleName)
        end
    end
end

MainModule.GameStateMonitor.Start()

MainModule.teleport_to_safe_spot = function()
    if MainModule.is_game_active("LastDinner") then
        MainModule.safe_teleport(Vector3.new(0, 100, 0))
        MainModule.notify("Last Dinner", "Teleported to Safe Spot", 0.9)
    else
        MainModule.notify("Last Dinner", "Wait for LastDinner!", 0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.RebelEnabled = false
MainModule.RebelShotsPerTick = 10
MainModule.RebelConnection = nil
MainModule.RebelGun = nil
MainModule.RebelEnemiesCache = {}
MainModule.RebelEnemiesUpdateTime = 0
MainModule.RebelEnemiesIndex = 1
MainModule.RebelEnemiesList = {}

local function FindRebelGun()
    local char = MainModule.get_character()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local gun = nil

    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool:GetAttribute("Gun") or tool:FindFirstChild("GunScript") or string.lower(tool.Name):find("gun")) then
                gun = tool
                break
            end
        end
    end

    if not gun and backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool:GetAttribute("Gun") or tool:FindFirstChild("GunScript") or string.lower(tool.Name):find("gun")) then
                gun = tool
                break
            end
        end
    end

    return gun
end

local function UpdateRebelEnemies()
    if tick() - MainModule.RebelEnemiesUpdateTime < 0.1 then return end
    MainModule.RebelEnemiesUpdateTime = tick()

    local hits = {}
    local live = workspace:FindFirstChild("Live")
    if live then
        for _, enemy in ipairs(live:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Enemy") and not enemy:FindFirstChild("Dead") then
                local isPlayer = false
                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Name == enemy.Name then
                        isPlayer = true
                        break
                    end
                end
                if not isPlayer then
                    hits[enemy.Name] = "Head"
                end
            end
        end
    end
    MainModule.RebelEnemiesCache = hits
    MainModule.RebelEnemiesIndex = 1

    MainModule.RebelEnemiesList = {}
    for name, part in pairs(hits) do
        MainModule.RebelEnemiesList[#MainModule.RebelEnemiesList + 1] = {name = name, part = part}
    end
end

local function GetNextTargets(max)
    if not MainModule.RebelEnemiesList or #MainModule.RebelEnemiesList == 0 then return {} end

    local targets = {}
    local count = 0
    local list = MainModule.RebelEnemiesList

    for i = MainModule.RebelEnemiesIndex, #list do
        local item = list[i]
        targets[item.name] = item.part
        count = count + 1
        MainModule.RebelEnemiesIndex = i + 1
        if count >= max then break end
    end

    if MainModule.RebelEnemiesIndex > #list then
        MainModule.RebelEnemiesIndex = 1
    end

    return targets
end

local function StartRebelLoop()
    if MainModule.RebelConnection then
        MainModule.RebelConnection:Disconnect()
        MainModule.RebelConnection = nil
    end

    MainModule.RebelConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.RebelEnabled then return end

        
        if not MainModule.RebelGun or tick() % 1 < 0.02 then
            MainModule.RebelGun = FindRebelGun()
        end
        if not MainModule.RebelGun then return end

        
        UpdateRebelEnemies()
        if not MainModule.RebelEnemiesList or #MainModule.RebelEnemiesList == 0 then return end

        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return end
        local remote = remotes:FindFirstChild("FiredGunClient")
        if not remote then return end

        local rayInst = workspace:FindFirstChild("StairWalkWay") and workspace.StairWalkWay:FindFirstChild("Part") or workspace

        
        local targets = GetNextTargets(5)

        local args = {
            MainModule.RebelGun,
            {
                ClientRayNormal = Vector3.new(0, 1, 0),
                FiredGun = true,
                SecondaryHitTargets = {},
                ClientRayInstance = rayInst,
                ClientRayPosition = Vector3.new(0, 0, 0),
                bulletCF = CFrame.new(),
                HitTargets = targets,
                bulletSizeC = Vector3.new(0.01, 0.01, 5),
                NoMuzzleFX = true,
                FirePosition = Vector3.new(0, 0, 0)
            }
        }

        
        for _ = 1, math.min(MainModule.RebelShotsPerTick, 3) do
            pcall(function()
                remote:FireServer(unpack(args))
            end)
        end
    end)
end

function MainModule.toggle_rebel_v2(enabled)
    MainModule.RebelEnabled = enabled

    if MainModule.RebelConnection then
        MainModule.RebelConnection:Disconnect()
        MainModule.RebelConnection = nil
    end

    MainModule.RebelGun = nil
    MainModule.RebelEnemiesList = {}
    MainModule.RebelEnemiesIndex = 1

    if enabled then
        StartRebelLoop()
    else
    end
    PlayToggleSound()
end

function MainModule.set_rebel_shots_per_tick(value)
    MainModule.RebelShotsPerTick = value
end

MainModule.NoRecoilEnabled = false
MainModule.NoRecoilConnection = nil
MainModule.NoRecoilExtraConns = {}

local function disconnectNoRecoilConns()
    if MainModule.NoRecoilConnection then
        pcall(function() MainModule.NoRecoilConnection:Disconnect() end)
        MainModule.NoRecoilConnection = nil
    end
    if MainModule.NoRecoilExtraConns then
        for _, conn in ipairs(MainModule.NoRecoilExtraConns) do
            pcall(function() conn:Disconnect() end)
        end
    end
    MainModule.NoRecoilExtraConns = {}
end

local function zeroObj(obj)
    if not obj then return end
    pcall(function()
        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
            obj.Value = 0
        elseif obj:IsA("Vector3Value") then
            obj.Value = Vector3.zero
        elseif obj:IsA("BoolValue") then
            obj.Value = false
        elseif obj:IsA("Folder") or obj:IsA("Configuration") then
            for _, ch in ipairs(obj:GetDescendants()) do
                if ch:IsA("NumberValue") or ch:IsA("IntValue") then
                    ch.Value = 0
                elseif ch:IsA("Vector3Value") then
                    ch.Value = Vector3.zero
                end
            end
        end
    end)
end

local function stripGun(gun)
    if not gun then return end
    pcall(function()
        for _, name in ipairs({"Spread", "Recoil", "RecoilShake"}) do
            local o = gun:FindFirstChild(name)
            if o then
                if o:IsA("NumberValue") or o:IsA("IntValue") or o:IsA("Vector3Value") or o:IsA("BoolValue") then
                    zeroObj(o)
                elseif o:IsA("Folder") or o:IsA("Configuration") then
                    zeroObj(o)
                else
                    if name ~= "Spread" then
                        pcall(function() o:Destroy() end)
                    else
                        zeroObj(o)
                    end
                end
            end
        end
        for _, d in ipairs(gun:GetDescendants()) do
            if d.Name == "Spread" or d.Name == "Recoil" or d.Name == "RecoilShake" then
                if d:IsA("NumberValue") or d:IsA("IntValue") or d:IsA("Vector3Value") then
                    zeroObj(d)
                elseif d.Name ~= "Spread" and (d:IsA("Folder") or d:IsA("Configuration")) then
                    zeroObj(d)
                end
            end
        end
        if gun.SetAttribute then
            gun:SetAttribute("Spread", 0)
            gun:SetAttribute("Recoil", 0)
            gun:SetAttribute("RecoilShake", 0)
        end
    end)
end

local function getGunsFolder()
    local weapons = ReplicatedStorage:FindFirstChild("Weapons")
    return weapons and weapons:FindFirstChild("Guns") or nil
end

local function applyAllGuns()
    local guns = getGunsFolder()
    if guns then
        for _, gun in ipairs(guns:GetChildren()) do
            stripGun(gun)
        end
    end
    local char = LocalPlayer.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then stripGun(t) end
        end
    end
    local bag = LocalPlayer:FindFirstChild("Backpack")
    if bag then
        for _, t in ipairs(bag:GetChildren()) do
            if t:IsA("Tool") then stripGun(t) end
        end
    end
end

local function bindValueStayZero(o)
    if not o or not (o:IsA("NumberValue") or o:IsA("IntValue")) then return end
    table.insert(MainModule.NoRecoilExtraConns, o:GetPropertyChangedSignal("Value"):Connect(function()
        if MainModule.NoRecoilEnabled and o.Parent and o.Value ~= 0 then
            o.Value = 0
        end
    end))
end

function MainModule.toggle_no_recoil(enabled)
    enabled = enabled and true or false
    MainModule.NoRecoilEnabled = enabled
    disconnectNoRecoilConns()

    if not enabled then
        if PlayToggleSound then PlayToggleSound() end
        return true
    end

    
    local function stripCamera()
        local cam = workspace.CurrentCamera
        if not cam then return end
        for _, name in ipairs({"CameraRecoil", "Recoil", "Spread", "CameraShake", "RecoilShake"}) do
            local o = cam:FindFirstChild(name)
            if o then pcall(function() o:Destroy() end) end
        end
    end

    local function stripGunValues(gun)
        if not gun then return end
        pcall(function()
            for _, name in ipairs({"Spread", "Recoil", "RecoilShake"}) do
                local o = gun:FindFirstChild(name, true)
                if o then
                    if o:IsA("NumberValue") or o:IsA("IntValue") then o.Value = 0
                    elseif o:IsA("Vector3Value") then o.Value = Vector3.zero
                    elseif o:IsA("BoolValue") then o.Value = false
                    end
                end
            end
            if gun.SetAttribute then
                gun:SetAttribute("Spread", 0)
                gun:SetAttribute("Recoil", 0)
            end
        end)
    end

    local function applyAll()
        pcall(function()
            local w = ReplicatedStorage:FindFirstChild("Weapons")
            if w and w:FindFirstChild("Guns") then
                for _, gun in ipairs(w.Guns:GetChildren()) do stripGunValues(gun) end
            end
            local c = MainModule.get_character and MainModule.get_character()
            if c then
                for _, t in ipairs(c:GetChildren()) do
                    if t:IsA("Tool") then stripGunValues(t) end
                end
            end
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if t:IsA("Tool") then stripGunValues(t) end
                end
            end
        end)
    end

    applyAll()
    MainModule.NoRecoilConnection = RunService.RenderStepped:Connect(function()
        if not MainModule.NoRecoilEnabled then return end
        stripCamera()
        applyAll()
    end)

    if PlayToggleSound then PlayToggleSound() end
    return true
end


function MainModule.toggle_spikes_esp(enabled)
    MainModule.SpikesESPEnabled = enabled and true or false
    for _, h in pairs(MainModule.SpikesESPObjects) do
        pcall(function()
            if type(h) == "table" then
                for _, o in pairs(h) do
                    if o and o.Destroy then o:Destroy() end
                end
            elseif h and h.Destroy then
                h:Destroy()
            end
        end)
    end
    MainModule.SpikesESPObjects = {}
    if MainModule.SpikesESPConn then
        pcall(function() MainModule.SpikesESPConn:Disconnect() end)
        MainModule.SpikesESPConn = nil
    end
    if MainModule.SpikesESPFolder then
        pcall(function() MainModule.SpikesESPFolder:Destroy() end)
        MainModule.SpikesESPFolder = nil
    end
    if not enabled then
        PlayToggleSound()
        return true
    end

    local folder = Instance.new("Folder")
    folder.Name = "HSX_SpikesESP"
    folder.Parent = workspace
    MainModule.SpikesESPFolder = folder

    local function find_killing_parts()
        local results = {}
        local function consider(kp)
            if kp and not results[kp] then
                results[kp] = true
            end
        end
        local map = workspace:FindFirstChild("HideAndSeekMap") or Workspace:FindFirstChild("HideAndSeekMap")
        if map then
            consider(map:FindFirstChild("KillingParts"))
            for _, d in ipairs(map:GetDescendants()) do
                if d.Name == "KillingParts" then
                    consider(d)
                end
            end
        end
        for _, d in ipairs(workspace:GetDescendants()) do
            if d.Name == "KillingParts" then
                consider(d)
            end
        end
        local list = {}
        for kp in pairs(results) do
            table.insert(list, kp)
        end
        return list
    end

    local function add_esp(part)
        if not part or not part:IsA("BasePart") then return end
        if MainModule.SpikesESPObjects[part] then return end
        local h = Instance.new("Highlight")
        h.Name = "HSX_SpikeHL"
        h.Adornee = part
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.FillColor = Color3.fromRGB(0, 0, 0)
        h.OutlineColor = Color3.fromRGB(0, 0, 0)
        h.FillTransparency = 0.35
        h.OutlineTransparency = 0
        h.Parent = folder
        MainModule.SpikesESPObjects[part] = h
        
        pcall(function()
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "HSX_SpikeBox"
            box.Adornee = part
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = part.Size
            box.Color3 = Color3.fromRGB(0, 0, 0)
            box.Transparency = 0.4
            box.Parent = folder
            MainModule.SpikesESPObjects[part] = { h, box }
        end)
    end

    local function refresh()
        if not MainModule.SpikesESPEnabled then return end
        for _, kp in ipairs(find_killing_parts()) do
            for _, part in ipairs(kp:GetDescendants()) do
                if part:IsA("BasePart") then
                    add_esp(part)
                end
            end
            for _, part in ipairs(kp:GetChildren()) do
                if part:IsA("BasePart") then
                    add_esp(part)
                elseif part:IsA("Model") then
                    for _, d in ipairs(part:GetDescendants()) do
                        if d:IsA("BasePart") then
                            add_esp(d)
                        end
                    end
                end
            end
        end
    end

    refresh()
    MainModule.SpikesESPConn = RunService.Heartbeat:Connect(function()
        if not MainModule.SpikesESPEnabled then return end
        if not MainModule._spikes_esp_t then MainModule._spikes_esp_t = 0 end
        if tick() - MainModule._spikes_esp_t < 0.75 then return end
        MainModule._spikes_esp_t = tick()
        refresh()
    end)
    PlayToggleSound()
    return true
end

local selectedPlayer = nil

local function formatNumberWithCommas(num)
    if num == "-" or num == nil then return "-" end
    if type(num) ~= "number" then
        num = tonumber(num) or 0
    end
    local formatted = tostring(math.floor(num))
    local k = formatted:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if k:sub(1,1) == "," then k = k:sub(2) end
    return k
end

local function getBoostFromAllSources(player, boostName)
    local checkFolder = function(folder)
        if folder then
            for _, child in pairs(folder:GetChildren()) do
                if child.Name == boostName and (child:IsA("NumberValue") or child:IsA("IntValue")) then
                    return child.Value
                end
                if string.lower(child.Name):find(string.lower(boostName)) and (child:IsA("NumberValue") or child:IsA("IntValue")) then
                    return child.Value
                end
            end
        end
        return nil
    end

    local boosts = player:FindFirstChild("Boosts")
    if boosts then
        local val = checkFolder(boosts)
        if val then return val end
    end

    local boostData = player:FindFirstChild("_BoostData")
    if boostData then
        local val = checkFolder(boostData)
        if val then return val end
    end

    local liveFolder = workspace:FindFirstChild("Live")
    if liveFolder then
        local playerFolder = liveFolder:FindFirstChild(player.Name)
        if playerFolder then
            local boostsLive = playerFolder:FindFirstChild("Boosts")
            if boostsLive then
                local val = checkFolder(boostsLive)
                if val then return val end
            end
            local boostDataLive = playerFolder:FindFirstChild("_BoostData")
            if boostDataLive then
                local val = checkFolder(boostDataLive)
                if val then return val end
            end
        end
    end

    local attrs = player:GetAttributes()
    for name, val in pairs(attrs) do
        if string.lower(name):find(string.lower(boostName)) and type(val) == "number" then
            return val
        end
    end

    return 0
end

MainModule._PlayerStatLabels = MainModule._PlayerStatLabels or {}

local function updateStatsDisplay(player)
    local L = MainModule._PlayerStatLabels
    if not L or not next(L) then return end
    local function set(name, text)
        local el = L[name]
        if not el then return end
        pcall(function()
            if el.SetTitle then el:SetTitle(text)
            elseif el.SetDesc then el:SetDesc(text)
            elseif el.SetText then el:SetText(text) end
        end)
    end
    if not player or not player.Parent then
        for k in pairs(L) do set(k, k:gsub("^%l", string.upper) .. ": -") end
        return
    end
    local attrs = player:GetAttributes()
    local function fmt(n)
        n = tonumber(n) or 0
        local s = tostring(math.floor(n))
        local k = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
        if k:sub(1,1) == "," then k = k:sub(2) end
        return k
    end
    set("Wins", "Wins: " .. fmt(attrs._GameWins or 0))
    set("Money", "Money: " .. fmt(attrs._Won or 0))
    set("Power", "Equipped Power: " .. tostring(attrs._EquippedPower or "-"))
    set("GuardPower", "Guard Power: " .. tostring(attrs._EquippedGuardPower or "-"))
    set("Level", "Level: " .. tostring(attrs._CurrentLevel or attrs._Level or attrs.Level or 0))
    set("PowerSpins", "Power Spins: " .. fmt(attrs._TotalPowerSpins or 0))
    set("GuardSpins", "Guard Spins: " .. fmt(attrs._TotalGuardPowerSpins or 0))
    set("Robux", "Robux Donated: " .. fmt(attrs._TotalRobuxDonated or attrs._RobuxDonated or 0))
    set("VIP", "VIP: " .. ((attrs.__OwnsVIPGamepass and "Yes") or "No"))
    set("PermGuard", "Perm Guard: " .. ((attrs.__OwnsPermGuard and "Yes") or "No"))
    set("Lighter", "Lighter: " .. ((attrs.HasLighter and "Yes") or "No"))
end

local function refreshPlayerList()
    local players = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(players, plr.Name)
        end
    end
    if #players == 0 then
        table.insert(players, "No players")
    end
    return players
end

Players.PlayerAdded:Connect(function()
end)

Players.PlayerRemoving:Connect(function()
    if selectedPlayer and not selectedPlayer.Parent then
        selectedPlayer = nil
        updateStatsDisplay(nil)
    end
end)

RunService.Heartbeat:Connect(function()
    if selectedPlayer and selectedPlayer.Parent then
        updateStatsDisplay(selectedPlayer)
    end
end)

local playerListForTeleport = {}
local function updatePlayerListForTeleport()
    playerListForTeleport = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(playerListForTeleport, plr.Name)
        end
    end
    if #playerListForTeleport == 0 then
        table.insert(playerListForTeleport, "No players")
    end
end

updatePlayerListForTeleport()

local selectedTeleportPlayer = nil
Players.PlayerAdded:Connect(function()
    task.wait(0.1)
    updatePlayerListForTeleport()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    if selectedTeleportPlayer and not Players:FindFirstChild(selectedTeleportPlayer.Name) then
        selectedTeleportPlayer = nil
    end
    updatePlayerListForTeleport()
end)

MainModule.PeabertEnabled = false
MainModule.PeabertShotsPerTick = 15
MainModule.PeabertConnection = nil

function MainModule.start_peabert_loop()
    if MainModule.PeabertConnection then
        MainModule.PeabertConnection:Disconnect()
        MainModule.PeabertConnection = nil
    end

    MainModule.PeabertConnection = RunService.RenderStepped:Connect(function()
        if not MainModule.PeabertEnabled then return end

        local char = MainModule.get_character()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local gun = nil

        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") and (tool:GetAttribute("Gun") or tool:FindFirstChild("GunScript") or string.lower(tool.Name):find("gun")) then
                    gun = tool
                    break
                end
            end
        end

        if not gun and backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool:GetAttribute("Gun") or tool:FindFirstChild("GunScript") or string.lower(tool.Name):find("gun")) then
                    gun = tool
                    break
                end
            end
        end

        if not gun then return end

        local hitTargetsTable = {}

        
        local live = workspace:FindFirstChild("Live")
        if live then
            for i = 1, 10 do
                local name = "EvilPeabert1_" .. i
                local enemy = live:FindFirstChild(name)
                if enemy and not enemy:FindFirstChild("Dead") then
                    hitTargetsTable[name] = "Head"
                end
            end
            for _, enemy in ipairs(live:GetChildren()) do
                if not enemy:FindFirstChild("Dead") then
                    local name = enemy.Name
                    if name:match("^PeabertSpawn%d+$") then
                        local num = tonumber(name:match("%d+"))
                        if num and num >= 1 and num <= 31 then
                            hitTargetsTable[name] = "Head"
                        end
                    end
                    if name:lower():find("peabert") or name:lower():find("evilpeabert") then
                        hitTargetsTable[name] = "Head"
                    end
                end
            end
        end

        for _, obj in ipairs(workspace:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("BasePart")) and not obj:FindFirstChild("Dead") then
                local name = obj.Name
                if name:match("^EvilPeabert1_%d+$") or name:match("^PeabertSpawn%d+$") or name:lower():find("peabert") then
                    hitTargetsTable[name] = "Head"
                end
            end
        end

        if next(hitTargetsTable) ~= nil then
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local remote = remotes:FindFirstChild("FiredGunClient")
                if remote then
                    local rayInst = workspace:FindFirstChild("StairWalkWay") and workspace.StairWalkWay:FindFirstChild("Part") or workspace

                    local args = {
                        gun,
                        {
                            ClientRayNormal = Vector3.new(0, 1, 0),
                            FiredGun = true,
                            SecondaryHitTargets = {},
                            ClientRayInstance = rayInst,
                            ClientRayPosition = Vector3.new(0, 0, 0),
                            bulletCF = CFrame.new(),
                            HitTargets = hitTargetsTable,
                            bulletSizeC = Vector3.new(0.01, 0.01, 5),
                            NoMuzzleFX = true,
                            FirePosition = Vector3.new(0, 0, 0)
                        }
                    }

                    for _ = 1, MainModule.PeabertShotsPerTick do
                        pcall(function()
                            remote:FireServer(unpack(args))
                        end)
                    end
                end
            end
        end
    end)
end

function MainModule.toggle_peabert_kill(enabled)
    MainModule.PeabertEnabled = enabled

    if MainModule.PeabertConnection then
        MainModule.PeabertConnection:Disconnect()
        MainModule.PeabertConnection = nil
    end

    if enabled then
        MainModule.start_peabert_loop()
    else
    end
    PlayToggleSound()
end

function MainModule.set_peabert_shots_per_tick(value)
    MainModule.PeabertShotsPerTick = value
end




loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
--@encrypt_start
loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
MainModule.FakeLightningAwakeningEnabled = false
MainModule._LA_Inited = false

MainModule.toggle_fake_lightning_awakening = function(enabled)
	MainModule.FakeLightningAwakeningEnabled = enabled and true or false
	if not enabled then
		pcall(function()
			local bp = LocalPlayer:FindFirstChild("Backpack")
			if bp then
				local x = bp:FindFirstChild("LIGHTNING AWAKENING")
				if x then x:Destroy() end
			end
			local c = LocalPlayer.Character
			if c then
				local x = c:FindFirstChild("LIGHTNING AWAKENING")
				if x then x:Destroy() end
			end
		end)
		PlayToggleSound()
		return true
	end
	if not MainModule._LA_Inited then
		MainModule._LA_Inited = true
		MainModule._LA_Start()
	end
	PlayToggleSound()
	return true
end

MainModule._LA_Start = function()
	--@encrypt_start
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Debris = game:GetService("Debris")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera
	local RS = ReplicatedStorage

	local EffectFolder = RS:FindFirstChild("Effects")
		and RS.Effects:FindFirstChild("SetupParts")
		and RS.Effects.SetupParts:FindFirstChild("CustomEffectsFolders")
		and RS.Effects.SetupParts.CustomEffectsFolders:FindFirstChild("LIGHTNINGGODAWAKENING")

	local Animations = RS:FindFirstChild("Animations")
	local AwakeningAnim = Animations and Animations:FindFirstChild("Abilities") and Animations.Abilities:FindFirstChild("LightningGodAwakening")
	local CamModule = RS:FindFirstChild("CustomCameraModules") and RS.CustomCameraModules:FindFirstChild("LightningAwakening")
	local ModulesFolder = RS:FindFirstChild("Modules")
	local EffectsModule, EffectsSecond
	pcall(function() EffectsModule = ModulesFolder and ModulesFolder:FindFirstChild("Effects") and require(ModulesFolder.Effects) end)
	pcall(function() EffectsSecond = ModulesFolder and ModulesFolder:FindFirstChild("EffectsSecond") and require(ModulesFolder.EffectsSecond) end)

	local CamData = nil
	if CamModule then
		pcall(function()
			local r = require(CamModule)
			if typeof(r) == "function" then CamData = r() else CamData = r end
		end)
	end
	local FOV_DATA = CamData and CamData.FOV
	local CAMERA_FRAMES = CamData and CamData.Frames
	if not FOV_DATA then
		FOV_DATA = {}
		for i = 1, 250 do FOV_DATA[i] = 70 end
	end
	if not CAMERA_FRAMES then
		CAMERA_FRAMES = {}
		for i = 1, 250 do CAMERA_FRAMES[i] = {0,2,-8,-1,0,0,0,1,0,0,0,-1} end
	end

	local isPlaying, cooldown, hasActivated = false, false, false

	local function frameToCFrame(f)
		return CFrame.new(f[1],f[2],f[3],f[4],f[5],f[6],f[7],f[8],f[9],f[10],f[11],f[12])
	end

	local function setupWeldedPart(template, parent, hrp, c0)
		if not template or not parent or not hrp then return nil end
		local clone = template:Clone()
		if clone:IsA("BasePart") then
			clone.Anchored = false
			clone.CanCollide = false
			clone.Massless = true
			local weld = Instance.new("Weld")
			weld.Part0 = hrp
			weld.Part1 = clone
			weld.C0 = c0 or CFrame.new()
			weld.Parent = clone
			clone.Parent = parent
		elseif clone:IsA("Model") then
			clone.Parent = parent
			for _, desc in clone:GetDescendants() do
				if desc and desc:IsA("BasePart") then
					desc.Anchored = false
					desc.CanCollide = false
					desc.Massless = true
					local weld = Instance.new("Weld")
					weld.Part0 = hrp
					weld.Part1 = desc
					weld.C0 = c0 or CFrame.new()
					weld.Parent = desc
				end
			end
		end
		for _, desc in clone:GetDescendants() do
			if desc then
				if desc:IsA("ParticleEmitter") then desc.Enabled = true end
				if desc:IsA("PointLight") then desc.Enabled = true end
			end
		end
		return clone
	end

	local function createFakeCharacter(character)
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return nil end
		local savedArchivable = {}
		for _, obj in character:GetDescendants() do
			savedArchivable[obj] = obj.Archivable
			obj.Archivable = true
		end
		local origArch = character.Archivable
		character.Archivable = true
		local ok, fakeModel = pcall(function() return character:Clone() end)
		character.Archivable = origArch
		for obj, val in savedArchivable do
			if obj and obj.Parent then pcall(function() obj.Archivable = val end) end
		end
		if not ok or not fakeModel then return nil end
		fakeModel.Name = "FakeChar_LightningAwakening"
		local toDestroy = {}
		for _, obj in fakeModel:GetDescendants() do
			if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("Tool") or obj:IsA("ModuleScript") then
				table.insert(toDestroy, obj)
			end
		end
		for _, obj in toDestroy do pcall(function() if obj and obj.Parent then obj:Destroy() end end) end
		for _, desc in fakeModel:GetDescendants() do
			if desc and desc:IsA("BasePart") then
				pcall(function()
					desc.CanCollide = false
					desc.CanQuery = false
					desc.CanTouch = false
					desc.Massless = true
					desc.Anchored = false
				end)
			end
		end
		local fakeHRP = fakeModel:FindFirstChild("HumanoidRootPart")
		if fakeHRP then fakeHRP.Anchored = true end
		local fakeHum = fakeModel:FindFirstChildOfClass("Humanoid")
		if fakeHum then
			pcall(function()
				fakeHum.DisplayDistanceType = Enum.HumanoidDisplayType.None
				fakeHum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
				fakeHum.BreakJointsOnDeath = false
				fakeHum.RequiresNeck = false
			end)
		end
		fakeModel.Parent = workspace
		return fakeModel
	end

	local function restoreCharacter(character, humanoid, hrp, savedPosition, wasAnchored, origWS, origJP, origFOV, origCamType)
		if character and character.Parent then
			for _, part in character:GetDescendants() do
				if part and part:IsA("BasePart") then
					pcall(function() part.LocalTransparencyModifier = 0 end)
				end
			end
		end
		if hrp and hrp.Parent then
			pcall(function()
				hrp.Anchored = false
				hrp.CFrame = savedPosition
				hrp.Anchored = wasAnchored
				hrp.AssemblyLinearVelocity = Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
			end)
		end
		pcall(function()
			Camera.CameraType = origCamType or Enum.CameraType.Custom
			TweenService:Create(Camera, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {FieldOfView = origFOV or 70}):Play()
		end)
		if humanoid and humanoid.Parent then
			pcall(function()
				humanoid.WalkSpeed = (origWS and origWS > 0) and origWS or 16
				humanoid.JumpPower = (origJP and origJP > 0) and origJP or 50
				humanoid.JumpHeight = 7.2
				humanoid.AutoRotate = true
				humanoid.PlatformStand = false
				humanoid.Sit = false
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			end)
		end
	end

	local function activate()
		if isPlaying or cooldown or not MainModule.FakeLightningAwakeningEnabled then return end
		local character = LocalPlayer.Character
		if not character then return end
		local humanoid = character:FindFirstChild("Humanoid")
		local hrp = character:FindFirstChild("HumanoidRootPart")
		local head = character:FindFirstChild("Head")
		if not humanoid or not hrp then return end
		isPlaying, cooldown = true, true
		local origFOV, origCamType = Camera.FieldOfView, Camera.CameraType
		local origWS, origJP = humanoid.WalkSpeed, humanoid.JumpPower
		local savedPosition, wasAnchored = hrp.CFrame, hrp.Anchored
		local teleportHeight = 150
		local hasRestored = false
		local function safeRestore()
			if hasRestored then return end
			hasRestored = true
			pcall(function()
				restoreCharacter(character, humanoid, hrp, savedPosition, wasAnchored, origWS, origJP, origFOV, origCamType)
			end)
			isPlaying = false
			task.delay(3, function() cooldown = false end)
		end
		local ok = pcall(function()
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
			humanoid.AutoRotate = false
			local fakeChar = createFakeCharacter(character)
			if not fakeChar then error("Failed to create fake character") end
			local fakeHRP = fakeChar:FindFirstChild("HumanoidRootPart")
			local fakeHum = fakeChar:FindFirstChildOfClass("Humanoid")
			local fakeHead = fakeChar:FindFirstChild("Head")
			if fakeHRP then fakeHRP.CFrame = savedPosition end
			local fakeBodyParts = {}
			for _, n in {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg","UpperTorso","LowerTorso","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftHand","RightHand","LeftFoot","RightFoot"} do
				local p = fakeChar:FindFirstChild(n)
				if p and p:IsA("BasePart") then table.insert(fakeBodyParts, p) end
			end
			local function getLiveParts()
				local out = {}
				for _, p in fakeBodyParts do
					if p and typeof(p) == "Instance" and p.Parent then table.insert(out, p) end
				end
				return out
			end
			hrp.Anchored = true
			task.wait()
			hrp.CFrame = savedPosition * CFrame.new(0, teleportHeight, 0)
			hrp.Anchored = true
			for _, part in character:GetDescendants() do
				if part and part:IsA("BasePart") then pcall(function() part.LocalTransparencyModifier = 1 end) end
			end
			local fakeUpdateConn = RunService.Heartbeat:Connect(function()
				if fakeChar and fakeChar.Parent and fakeHRP and fakeHRP.Parent then fakeHRP.CFrame = savedPosition end
			end)
			local moveConn = RunService.Heartbeat:Connect(function()
				if isPlaying and hrp and hrp.Parent then
					hrp.CFrame = savedPosition * CFrame.new(0, teleportHeight, 0)
					hrp.AssemblyLinearVelocity = Vector3.zero
					hrp.AssemblyAngularVelocity = Vector3.zero
				end
			end)
			local animTrack = nil
			if AwakeningAnim and fakeHum then
				pcall(function()
					local anim = Instance.new("Animation")
					anim.AnimationId = AwakeningAnim.AnimationId
					local animator = fakeHum:FindFirstChildOfClass("Animator")
					if not animator then animator = Instance.new("Animator"); animator.Parent = fakeHum end
					animTrack = animator:LoadAnimation(anim)
					animTrack.Priority = Enum.AnimationPriority.Action4
					animTrack:Play()
				end)
			end
			local animSound
			if fakeHRP then
				animSound = Instance.new("Sound")
				animSound.SoundId = "rbxassetid://103481331692768"
				animSound.Volume = 2
				animSound.RollOffMaxDistance = 300
				animSound.Parent = fakeHRP
				animSound:Play()
			end
			local frameInterval = 1 / 60
			local totalFrames = math.min(#CAMERA_FRAMES, #FOV_DATA)
			local totalDuration = totalFrames * frameInterval
			Camera.CameraType = Enum.CameraType.Scriptable
			local startTime = tick()
			local camConn
			camConn = RunService.RenderStepped:Connect(function()
				local elapsed = tick() - startTime
				local rawFrame = elapsed / frameInterval
				local fi = math.floor(rawFrame) + 1
				if fi > totalFrames then pcall(function() camConn:Disconnect() end) return end
				local alpha = rawFrame - math.floor(rawFrame)
				local ni = math.min(fi + 1, totalFrames)
				Camera.FieldOfView = FOV_DATA[fi] + (FOV_DATA[ni] - FOV_DATA[fi]) * alpha
				local cf1 = frameToCFrame(CAMERA_FRAMES[fi])
				local cf2 = frameToCFrame(CAMERA_FRAMES[ni])
				Camera.CFrame = savedPosition * cf1:Lerp(cf2, alpha)
			end)
			if EffectsModule and EffectsModule.PrepFrame then
				local prepImages = {}
				local impFramesFolder = RS:FindFirstChild("ImpactFrames")
				if impFramesFolder then
					local lgFolder = impFramesFolder:FindFirstChild("LightningGod")
					if lgFolder then
						for _, v in lgFolder:GetDescendants() do
							if v and v.ClassName == "ImageLabel" then table.insert(prepImages, v.Image) end
						end
					end
				end
				if #prepImages > 0 then
					task.spawn(function()
						pcall(function() EffectsModule.PrepFrame({ EffectName = "PrepFrame", ImageTable = prepImages }) end)
					end)
				end
			end
			pcall(function()
				if EffectFolder and EffectFolder:FindFirstChild("start") then
					for _, emitter in EffectFolder.start:GetChildren() do
						if emitter and emitter:IsA("ParticleEmitter") then
							local emitterName = emitter.Name
							for _, limb in getLiveParts() do
								if limb.Name ~= "Head" or emitterName ~= "Lightning1" then
									local clone = emitter:Clone()
									clone.Enabled = true
									clone.Parent = limb
									task.delay(1.52, function() if clone and clone.Parent then clone.Enabled = false end end)
									Debris:AddItem(clone, 1.6)
								end
							end
						end
					end
				end
			end)
			task.delay(1.55, function()
				if not isPlaying then return end
				pcall(function()
					if EffectFolder and EffectFolder:FindFirstChild("Aura1") and fakeHRP and fakeHRP.Parent then
						local auraClone = setupWeldedPart(EffectFolder.Aura1, fakeChar, fakeHRP, CFrame.new(-0.386, -0.425, -0.538))
						if auraClone then
							task.delay(1.33, function()
								if auraClone and auraClone.Parent then
									for _, desc in auraClone:GetDescendants() do
										if desc and desc:IsA("ParticleEmitter") then desc.Enabled = false end
									end
								end
							end)
							Debris:AddItem(auraClone, 2.3)
						end
					end
					if EffectFolder and EffectFolder:FindFirstChild("eyes") and fakeHead and fakeHead.Parent then
						for _, child in EffectFolder.eyes:GetChildren() do
							if child and child:IsA("Attachment") then
								local clone = child:Clone()
								clone.Parent = fakeHead
								for _, desc in clone:GetDescendants() do
									if desc and desc:IsA("ParticleEmitter") then desc.Enabled = true end
								end
								Debris:AddItem(clone, 2.61)
							end
						end
					end
				end)
			end)
			task.delay(2.85, function()
				if not isPlaying then return end
				pcall(function()
					if EffectFolder and EffectFolder:FindFirstChild("Strike") and fakeHRP and fakeHRP.Parent then
						local sf = EffectFolder.Strike
						local am = sf:FindFirstChild("Model")
						if am then
							local ac = setupWeldedPart(am, fakeChar, fakeHRP, CFrame.new(0.221, 14.591, -2.723))
							if ac then Debris:AddItem(ac, 2.5) end
						end
						local gp = sf:FindFirstChild("LightningImpactGround")
						if gp then
							local gc = setupWeldedPart(gp, fakeChar, fakeHRP, CFrame.new(0.222, -0.35, -2.723))
							if gc then
								Debris:AddItem(gc, 2.5)
								local bl = gc:FindFirstChild("BlastLight", true)
								if not bl then
									local imp = gc:FindFirstChild("Impact", true)
									if imp then bl = imp:FindFirstChild("BlastLight") end
								end
								if bl and bl:IsA("PointLight") then
									bl.Enabled = true
									task.delay(0.42, function()
										if bl and bl.Parent then
											TweenService:Create(bl, TweenInfo.new(0.35, Enum.EasingStyle.Linear), {Brightness=2}):Play()
										end
									end)
								end
							end
						end
					end
					if EffectFolder and EffectFolder:FindFirstChild("Lines1") then
						local lines = EffectFolder.Lines1
						if lines:IsA("ParticleEmitter") then
							for _, limb in getLiveParts() do
								local clone = lines:Clone()
								clone.Enabled = true
								clone.Parent = limb
								Debris:AddItem(clone, 0.8)
							end
						end
					end
					if EffectFolder and EffectFolder:FindFirstChild("AuraLightning") then
						for _, emitter in EffectFolder.AuraLightning:GetChildren() do
							if emitter and emitter:IsA("ParticleEmitter") then
								for _, limb in getLiveParts() do
									local clone = emitter:Clone()
									clone.Enabled = true
									clone.Parent = limb
									Debris:AddItem(clone, 0.8)
								end
							end
						end
					end
					local myChar = LocalPlayer.Character
					if myChar and myChar:FindFirstChild("Remotes") then
						local relay = myChar.Remotes:FindFirstChild("Relay")
						if relay then
							relay:Fire({EffectName="MauioShake",Length=0.45,TweenSpeed=0.075,AxisMultipliers=Vector3.new(1,0.15,1),FadeStyle="inQuad",PositionStyle="inCubic",Intensity=2})
						end
					end
				end)
			end)
			task.delay(2.9, function()
				if not isPlaying then return end
				if EffectsSecond and EffectsSecond.ImpactFrames then
					pcall(function() EffectsSecond.ImpactFrames({foldername = "LightningGod", displaytime = 0.015}) end)
				end
			end)
			task.delay(3.65, function()
				if not isPlaying then return end
				pcall(function()
					if EffectFolder and EffectFolder:FindFirstChild("Glow") then
						local glow = EffectFolder.Glow
						if glow:IsA("ParticleEmitter") then
							for _, limb in getLiveParts() do
								local clone = glow:Clone()
								clone.Enabled = true
								clone.Parent = limb
								Debris:AddItem(clone, 0.52)
							end
						end
					end
				end)
			end)
			task.delay(totalDuration, function()
				pcall(function() moveConn:Disconnect() end)
				pcall(function() fakeUpdateConn:Disconnect() end)
				pcall(function() camConn:Disconnect() end)
				if animSound and animSound.Parent then pcall(function() animSound:Stop() animSound:Destroy() end) end
				if animTrack then pcall(function() animTrack:Stop(0.3) end) end
				safeRestore()
				if hrp and hrp.Parent then
					local afterSound = Instance.new("Sound")
					afterSound.SoundId = "rbxassetid://97926606277706"
					afterSound.Volume = 1.5
					afterSound.RollOffMaxDistance = 300
					afterSound.Parent = hrp
					afterSound:Play()
					Debris:AddItem(afterSound, 10)
				end
				pcall(function()
					if EffectFolder and EffectFolder:FindFirstChild("LingeringAura") and character and character.Parent then
						for _, emitter in EffectFolder.LingeringAura:GetChildren() do
							if emitter and emitter:IsA("ParticleEmitter") then
								for _, n in {"Torso","UpperTorso","Left Arm","Right Arm"} do
									local p = character:FindFirstChild(n)
									if p and p:IsA("BasePart") then
										local clone = emitter:Clone()
										clone.Enabled = true
										clone.Parent = p
										Debris:AddItem(clone, 6)
										task.delay(4, function() if clone and clone.Parent then clone.Enabled = false end end)
									end
								end
							end
						end
					end
				end)
				pcall(function()
					if EffectFolder and EffectFolder:FindFirstChild("eyes") and head and head.Parent then
						for _, child in EffectFolder.eyes:GetChildren() do
							if child and child:IsA("Attachment") then
								local clone = child:Clone()
								clone.Parent = head
								for _, desc in clone:GetDescendants() do
									if desc and desc:IsA("ParticleEmitter") then desc.Enabled = true end
								end
								Debris:AddItem(clone, 6)
								task.delay(4, function()
									if clone and clone.Parent then
										for _, desc in clone:GetDescendants() do
											if desc and desc:IsA("ParticleEmitter") then desc.Enabled = false end
										end
									end
								end)
							end
						end
					end
				end)
				task.delay(0.3, function()
					if fakeChar and fakeChar.Parent then pcall(function() fakeChar:Destroy() end) end
				end)
			end)
		end)
		if not ok then safeRestore() end
		task.delay(20, function() if not hasRestored then safeRestore() end end)
	end

	local toolConnections = {}
	local function setupTool(tool)
		if not tool or toolConnections[tool] then return end
		toolConnections[tool] = true
		local function go()
			if hasActivated or isPlaying or not MainModule.FakeLightningAwakeningEnabled then return end
			hasActivated = true
			task.defer(function() activate() task.wait(0.5) hasActivated = false end)
		end
		tool.Equipped:Connect(go)
		tool.Activated:Connect(go)
	end

	local Tool = Instance.new("Tool")
	Tool.Name = "LIGHTNING AWAKENING"
	Tool.RequiresHandle = true
	Tool.CanBeDropped = false
	local Handle = Instance.new("Part")
	Handle.Name = "Handle"
	Handle.Size = Vector3.new(1, 1, 1)
	Handle.Transparency = 1
	Handle.CanCollide = false
	Handle.Massless = true
	Handle.Parent = Tool

	local function giveTool()
		if not MainModule.FakeLightningAwakeningEnabled then return end
		local bp = LocalPlayer:FindFirstChild("Backpack")
		local char = LocalPlayer.Character
		if not bp then return end
		local inBackpack = bp:FindFirstChild("LIGHTNING AWAKENING")
		local inChar = char and char:FindFirstChild("LIGHTNING AWAKENING")
		if not inBackpack and not inChar then
			local t = Tool:Clone()
			t.Parent = bp
			setupTool(t)
		elseif inBackpack then
			setupTool(inBackpack)
		elseif inChar then
			setupTool(inChar)
		end
	end

	LocalPlayer:WaitForChild("Backpack")
	giveTool()
	LocalPlayer.Backpack.ChildAdded:Connect(function(child)
		if child.Name == "LIGHTNING AWAKENING" and child:IsA("Tool") then setupTool(child) end
	end)
	LocalPlayer.CharacterAdded:Connect(function(char)
		isPlaying, cooldown, hasActivated = false, false, false
		toolConnections = {}
		pcall(function() Camera.CameraType = Enum.CameraType.Custom Camera.FieldOfView = 70 end)
		task.wait(1)
		giveTool()
		char.ChildAdded:Connect(function(child)
			if child.Name == "LIGHTNING AWAKENING" and child:IsA("Tool") then setupTool(child) end
		end)
	end)
	--@encrypt_end
end


MainModule.ESPPowersEnabled = false
MainModule.ESPPowersDrawings = {}
MainModule.ESPPowersConnection = nil

function MainModule.clear_esp_powers()
    for _, d in pairs(MainModule.ESPPowersDrawings) do
        pcall(function()
            if d.Remove then d:Remove() elseif d.Destroy then d:Destroy() end
        end)
    end
    MainModule.ESPPowersDrawings = {}
    if MainModule.ESPPowersConnection then
        pcall(function() MainModule.ESPPowersConnection:Disconnect() end)
        MainModule.ESPPowersConnection = nil
    end
end

function MainModule.toggle_esp_powers(enabled)
    MainModule.ESPPowersEnabled = enabled and true or false
    MainModule.clear_esp_powers()
    if not enabled then
        if PlayToggleSound then PlayToggleSound() end
        return true
    end

    local function getPowerName(plr)
        if not plr then return nil end
        local keys = {"_EquippedPower", "EquippedPower", "Power", "CurrentPower", "Ability"}
        for _, k in ipairs(keys) do
            local v = plr:GetAttribute(k)
            if v ~= nil and v ~= false and v ~= "" and v ~= 0 then
                return tostring(v)
            end
        end
        local c = plr.Character
        if c then
            for _, k in ipairs(keys) do
                local v = c:GetAttribute(k)
                if v ~= nil and v ~= false and v ~= "" and v ~= 0 then
                    return tostring(v)
                end
            end
            for _, inst in ipairs(c:GetDescendants()) do
                if inst.Name == "_EquippedPower" or inst.Name == "EquippedPower" or inst.Name == "Power" then
                    if inst:IsA("StringValue") or inst:IsA("NumberValue") then
                        return tostring(inst.Value)
                    end
                    local av = inst:GetAttribute("Value") or inst:GetAttribute("Name")
                    if av then return tostring(av) end
                end
            end
        end
        return nil
    end

    MainModule.ESPPowersConnection = RunService.RenderStepped:Connect(function()
        if not MainModule.ESPPowersEnabled then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local used = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local powerName = getPowerName(plr)
                if powerName then
                    local head = plr.Character:FindFirstChild("Head")
                        or plr.Character:FindFirstChild("HumanoidRootPart")
                    if head then
                        local sp, onScreen = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 2.2, 0))
                        local key = plr.UserId
                        used[key] = true
                        local text = MainModule.ESPPowersDrawings[key]
                        if not text then
                            text = Drawing.new("Text")
                            text.Center = true
                            text.Outline = true
                            text.Size = 16
                            text.Font = 2
                            text.Color = Color3.fromRGB(255, 255, 255)
                            text.OutlineColor = Color3.fromRGB(0, 0, 0)
                            MainModule.ESPPowersDrawings[key] = text
                        end
                        if onScreen and sp.Z > 0 then
                            text.Visible = true
                            text.Position = Vector2.new(sp.X, sp.Y)
                            text.Text = powerName
                        else
                            text.Visible = false
                        end
                    end
                end
            end
        end
        for key, text in pairs(MainModule.ESPPowersDrawings) do
            if not used[key] then
                pcall(function() if text.Remove then text:Remove() end end)
                MainModule.ESPPowersDrawings[key] = nil
            end
        end
    end)

    if PlayToggleSound then PlayToggleSound() end
    return true
end


MainModule.PeabertESPEnabled = false
MainModule.PeabertESPHighlights = {}
MainModule.PeabertESPTracers = {}
MainModule.PeabertESPConnection = nil
MainModule.PeabertTargetsCache = {}
MainModule.PeabertLastScan = 0

local function clearPeabertESP()
    for _, h in pairs(MainModule.PeabertESPHighlights) do
        pcall(function() if h and h.Parent then h:Destroy() end end)
    end
    MainModule.PeabertESPHighlights = {}
    for _, t in pairs(MainModule.PeabertESPTracers) do
        pcall(function() if t.Remove then t:Remove() elseif t.Destroy then t:Destroy() end end)
    end
    MainModule.PeabertESPTracers = {}
end

local function isPeabertTarget(obj)
    if not obj then return false end
    if obj:FindFirstChild("Dead") then return false end
    local n = obj.Name
    local low = n:lower()
    if low == "freepeabert" or low:find("freepeabert") then return true end
    local free = false
    pcall(function() free = obj:GetAttribute("FREEPEABERT") or obj:GetAttribute("FreePeabert") end)
    if free then return true end
    if low:match("^peabert%d+$") then return true end
    if low:match("^peabert_%d+$") then return true end
    if low:match("^evilpeabert1_%d+$") then return true end
    if low:match("^peabertspawn%d+$") then return true end
    if low:match("^peabertshattered%d+$") then return true end
    if low:match("^peabertcrack%d+$") then return true end
    if low == "peabert" or (low:find("peabert") and not low:find("esp")) then return true end
    return false
end

local function getPeabertPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart
            or obj:FindFirstChild("HumanoidRootPart")
            or obj:FindFirstChild("Head")
            or obj:FindFirstChildWhichIsA("BasePart")
    end
    return obj:FindFirstChildWhichIsA("BasePart")
end

local function scanPeaberts()
    local targets = {}
    local seen = {}

    local function add(obj)
        if not obj or seen[obj] then return end
        if not isPeabertTarget(obj) then return end
        local part = getPeabertPart(obj)
        if not part then return end
        seen[obj] = true
        table.insert(targets, { Object = obj, Part = part, Name = obj.Name })
    end

    local live = workspace:FindFirstChild("Live")
    if live then
        for i = 1, 10 do
            add(live:FindFirstChild("FREEPEABERT"))
            add(live:FindFirstChild("FreePeabert"))
            add(live:FindFirstChild("FreePeabert" .. i))
            add(live:FindFirstChild("Peabert" .. i))
            add(live:FindFirstChild("Peabert_" .. i))
            add(live:FindFirstChild("EvilPeabert1_" .. i))
            add(live:FindFirstChild("PeabertSpawn" .. i))
        end
        for _, child in ipairs(live:GetChildren()) do
            local n = child.Name:lower()
            if n:find("peabert") or n:find("freepeabert") then
                add(child)
            end
        end
    end

    -- light pass: only direct children named like peabert (no full GetDescendants)
    for _, child in ipairs(workspace:GetChildren()) do
        local n = child.Name:lower()
        if n:find("peabert") then
            add(child)
            for _, sub in ipairs(child:GetChildren()) do
                add(sub)
            end
        end
    end

    MainModule.PeabertTargetsCache = targets
    MainModule.PeabertLastScan = tick()
end

function MainModule.start_peabert_esp()
    if MainModule.PeabertESPEnabled then return end
    MainModule.PeabertESPEnabled = true
    clearPeabertESP()
    scanPeaberts()

    MainModule.PeabertESPConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.PeabertESPEnabled then return end
        if tick() - MainModule.PeabertLastScan > 2.5 then
            scanPeaberts()
        end

        local cam = workspace.CurrentCamera
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local used = {}
        local fromPos = Vector2.new(0, 0)
        if cam then
            fromPos = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
        end
        if myRoot and cam then
            local sp = cam:WorldToViewportPoint(myRoot.Position)
            fromPos = Vector2.new(sp.X, sp.Y)
        end

        for _, data in ipairs(MainModule.PeabertTargetsCache) do
            local part = data.Part
            local name = data.Name
            local key = tostring(data.Object)
            if part and part.Parent then
                used[key] = true
                local hl = MainModule.PeabertESPHighlights[key]
                if not hl or not hl.Parent then
                    hl = Instance.new("Highlight")
                    hl.Name = "PeabertHighlight"
                    hl.FillColor = Color3.fromRGB(255, 105, 180)
                    hl.OutlineColor = Color3.fromRGB(255, 182, 193)
                    hl.FillTransparency = 0.4
                    hl.OutlineTransparency = 0
                    local adornee = data.Object:IsA("Model") and data.Object or part
                    hl.Adornee = adornee
                    hl.Parent = adornee
                    MainModule.PeabertESPHighlights[key] = hl
                else
                    hl.Adornee = data.Object:IsA("Model") and data.Object or part
                end

                local dist = myRoot and (part.Position - myRoot.Position).Magnitude or 0
                local tracer = MainModule.PeabertESPTracers[key]
                if dist > 500 then
                    if tracer then
                        tracer.Visible = false
                    end
                else
                    if not tracer then
                        tracer = Drawing.new("Line")
                        tracer.Thickness = 1.5
                        tracer.Color = Color3.fromRGB(255, 105, 180)
                        tracer.Transparency = 1
                        MainModule.PeabertESPTracers[key] = tracer
                    end
                    if cam then
                        local sp2, onScreen = cam:WorldToViewportPoint(part.Position)
                        if onScreen and sp2.Z > 0 then
                            tracer.Visible = true
                            tracer.From = fromPos
                            tracer.To = Vector2.new(sp2.X, sp2.Y)
                        else
                            tracer.Visible = false
                        end
                    end
                end
            end
        end

        for key, hl in pairs(MainModule.PeabertESPHighlights) do
            if not used[key] then
                pcall(function() if hl and hl.Parent then hl:Destroy() end end)
                MainModule.PeabertESPHighlights[key] = nil
            end
        end
        for key, tr in pairs(MainModule.PeabertESPTracers) do
            if not used[key] then
                pcall(function() if tr.Remove then tr:Remove() end end)
                MainModule.PeabertESPTracers[key] = nil
            end
        end
    end)

    if MainModule.notify then
    end
    if PlayToggleSound then PlayToggleSound() end
    return true
end

function MainModule.stop_peabert_esp()
    if not MainModule.PeabertESPEnabled then return end
    MainModule.PeabertESPEnabled = false
    if MainModule.PeabertESPConnection then
        pcall(function() MainModule.PeabertESPConnection:Disconnect() end)
        MainModule.PeabertESPConnection = nil
    end
    clearPeabertESP()
    if PlayToggleSound then PlayToggleSound() end
end

function MainModule.toggle_peabert_esp(state)
    if state then
        return MainModule.start_peabert_esp()
    else
        MainModule.stop_peabert_esp()
        return true
    end
end

function MainModule.tp_to_peaberts()
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    scanPeaberts()

    local targets = MainModule.PeabertTargetsCache
    if #targets == 0 then
        if MainModule.notify then
            MainModule.notify("Peabert TP", "No Peaberts found on map!", 1.5)
        end
        return
    end

    local best, bestDist = nil, math.huge
    for _, data in ipairs(targets) do
        local part = data.Part
        if part and part.Parent then
            local n = data.Name:lower()
            local priority = 2
            if n:find("freepeabert") or n == "freepeabert" then
                priority = 0
            elseif n:match("^peabert%d+$") or n:match("^peabert_%d+$") then
                priority = 1
            end
            local d = (part.Position - hrp.Position).Magnitude + priority * 0.001
            if d < bestDist then
                best, bestDist = part, d
            end
        end
    end

    if not best then
        if MainModule.notify then
            MainModule.notify("Peabert TP", "No Peaberts found on map!", 1.5)
        end
        return
    end

    hrp.CFrame = CFrame.new(best.Position + Vector3.new(0, 4, 0))
    if MainModule.notify then
        MainModule.notify("Peabert TP", "Teleported to Peabert!", 1.2)
    end
end

MainModule.AddVisualItemsEnabled = false
MainModule.AddVisualItemsConnection = nil

MainModule.AutoWinEnabled = false
MainModule.AutoWinConnection = nil
MainModule.AutoWinTriggered = {}
MainModule.CurrentGame = nil
MainModule.GameStartTime = nil
MainModule.LastNotifTime = 0
MainModule.AutoWinHunterFeatures = false

MainModule.set_auto_win_hunter_features = function(enabled)
    enabled = enabled and true or false

    if MainModule.AutoWinHunterFeatures == enabled then
        return
    end

    MainModule.AutoWinHunterFeatures = enabled

    if MainModule.PlayerAttachEnabled ~= enabled then
        MainModule.toggle_player_attach(enabled)
    end

    if MainModule.FaceTargetModule
        and MainModule.FaceTargetModule.Enabled ~= enabled
    then
        MainModule.toggle_face_target(enabled)
    end

    if MainModule.SpikesKillFeature
        and MainModule.SpikesKillFeature.Enabled ~= enabled
    then
        MainModule.toggle_spikes_kill(enabled)
    end

    MainModule.toggle_noclip(enabled)

    if MainModule.ToggleRefs then
        if MainModule.ToggleRefs.PlayerAttach then
            MainModule.ToggleRefs.PlayerAttach:SetValue(enabled)
        end

        if MainModule.ToggleRefs.FaceTarget then
            MainModule.ToggleRefs.FaceTarget:SetValue(enabled)
        end

        if MainModule.ToggleRefs.SpikesKill then
            MainModule.ToggleRefs.SpikesKill:SetValue(enabled)
        end

        if MainModule.ToggleRefs.Noclip then
            MainModule.ToggleRefs.Noclip:SetValue(enabled)
        end
    end
end

local getupvalues =
    (debug and (debug.getupvalues or debug.get_upvalues))
    or getupvalues

local setupvalue =
    (debug and (debug.setupvalue or debug.setup_value))
    or setupvalue

local getconstants =
    (debug and (debug.getconstants or debug.get_constants))
    or getconstants

local function forceProgress100()
    if not getgc or not getupvalues or not setupvalue then
        return false
    end

    local patched = false

    local ok, list = pcall(function()
        return getgc()
    end)

    if not ok or type(list) ~= "table" then
        return false
    end

    for _, fn in ipairs(list) do
        if type(fn) == "function" then
            local consts = nil

            if getconstants then
                local constantsOk, result = pcall(function()
                    return getconstants(fn)
                end)

                if constantsOk then
                    consts = result
                end
            end

            local useful = false

            if type(consts) == "table" then
                for _, constant in pairs(consts) do
                    if constant == "Progress"
                        or constant == "Completed"
                    then
                        useful = true
                        break
                    end

                    if type(constant) == "string"
                        and constant:find("%%", 1, true)
                    then
                        useful = true
                        break
                    end
                end
            end

            if useful then
                local upvaluesOk, ups = pcall(function()
                    return getupvalues(fn)
                end)

                if upvaluesOk and type(ups) == "table" then
                    for index, value in pairs(ups) do
                        if type(value) == "number"
                            and value == value
                            and value >= 0
                            and value < 5000
                        then
                            local patchedOk = pcall(function()
                                setupvalue(fn, index, 100000)
                            end)

                            if patchedOk then
                                patched = true
                            end
                        end
                    end
                end
            end
        end
    end

    return patched
end



loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();


loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
--@encrypt_end
--@encrypt_start
loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
MainModule.complete_dalgona = function()
    task.spawn(function()
        local success = false

        for _ = 1, 10 do
            if forceProgress100() then
                success = true
            end

            task.wait(0.15)
        end

        if success then
            pcall(function()
                HSXNotify("Dalgona", "Dalgona Completed", 0.9)
            end)
        else
            pcall(function()
                HSXNotify("Dalgona", "Failed (no hooks?)", 0.9)
            end)
        end
    end)
end



--@encrypt_end
MainModule.cleanup_auto_win_game = function(gameName)
    if gameName == "HideAndSeek" then
        MainModule.set_auto_win_hunter_features(false)
    end

    if gameName == "Rebel" and MainModule.RebelEnabled then
        MainModule.toggle_rebel_v2(false)
    end

    if gameName == "TugOfWar" or gameName == "TugofWar" then
        if MainModule.TugOfWarUltraFastPull then
            MainModule.toggle_tug_of_war_ultra_fast_pull(false)
        end
    end
end

MainModule.auto_win = function()
    if not MainModule.AutoWinEnabled then
        return
    end

    local currentTime = tick()

    local values = Workspace:FindFirstChild("Values")
    if not values then
        return
    end

    local currentGameValue = values:FindFirstChild("CurrentGame")
    if not currentGameValue then
        return
    end

    local currentGame = currentGameValue.Value
    if not currentGame or currentGame == "" then
        return
    end

    if currentGame ~= MainModule.CurrentGame then
        local oldGame = MainModule.CurrentGame

        if oldGame then
            MainModule.cleanup_auto_win_game(oldGame)
        end

        MainModule.CurrentGame = currentGame
        MainModule.GameStartTime = currentTime

        MainModule.AutoWinTriggered = {
            Main = false,
            HunterStarted = false,
            HunterStopped = false,
            RebelStarted = false,
            TugOfWarStarted = false
        }

        return
    end

    if not MainModule.GameStartTime then
        MainModule.GameStartTime = currentTime
        return
    end

    local elapsed = currentTime - MainModule.GameStartTime
    local state = MainModule.AutoWinTriggered

    if currentGame == "TugOfWar" or currentGame == "TugofWar" then
        if not state.TugOfWarStarted then
            state.TugOfWarStarted = true

            if not MainModule.TugOfWarUltraFastPull then
                MainModule.toggle_tug_of_war_ultra_fast_pull(true)
            end

            PlayBell()
        end

        return
    end

    local character = MainModule.get_character()
    if not character then
        return
    end

    local rootPart = MainModule.get_root_part(character)
    if not rootPart then
        return
    end

    if currentGame == "RedLightGreenLight" then
        if not state.Main and elapsed >= 15 then
            state.Main = true

            MainModule.safe_teleport(
                Vector3.new(-214.4, 1023.1, 146.7)
            )

            PlayBell()
        end

    elseif currentGame == "Dalgona" then
        if not state.Main and elapsed >= 25 then
            state.Main = true
            MainModule.complete_dalgona()
            PlayBell()
        end

    elseif currentGame == "LightsOut" or currentGame == "LightOut" then
        if not state.Main and elapsed >= 15 then
            state.Main = true

            local pos = rootPart.Position

            MainModule.safe_teleport(
                Vector3.new(pos.X, pos.Y + 100, pos.Z)
            )

            PlayBell()
        end

    elseif currentGame == "HideAndSeek" then
        local isHider = MainModule.is_hider(LocalPlayer)
        local isHunter = MainModule.is_seeker(LocalPlayer)

        if isHider then
            if not state.Main and elapsed >= 15 then
                state.Main = true

                local pos = rootPart.Position

                MainModule.safe_teleport(
                    Vector3.new(pos.X, pos.Y + 200, pos.Z)
                )

                PlayBell()
            end

        elseif isHunter then
            if not state.HunterStarted and elapsed >= 25 then
                state.HunterStarted = true
                MainModule.set_auto_win_hunter_features(true)
                PlayBell()
            end

            if state.HunterStarted
                and not state.HunterStopped
                and elapsed >= 145
            then
                state.HunterStopped = true
                MainModule.set_auto_win_hunter_features(false)
                PlayBell()
            end
        end

    elseif currentGame == "JumpRope" then
        if not state.Main and elapsed >= 15 then
            state.Main = true

            MainModule.safe_teleport(
                Vector3.new(
                    720.896057,
                    198.628311,
                    921.170654
                )
            )

            PlayBell()
        end

    elseif currentGame == "GlassBridge" then
        if not state.Main and elapsed >= 15 then
            state.Main = true

            MainModule.safe_teleport(
                Vector3.new(
                    -196.372467,
                    522.192139,
                    -1534.20984
                )
            )

            PlayBell()
        end

    elseif currentGame == "Rebel" then
        if not state.RebelStarted then
            state.RebelStarted = true

            local pos = rootPart.Position

            MainModule.safe_teleport(
                Vector3.new(pos.X, pos.Y + 100, pos.Z)
            )

            if not MainModule.RebelEnabled then
                MainModule.toggle_rebel_v2(true)
            end

            PlayBell()
        end
    end
end

MainModule.toggle_auto_win = function(enabled)
    enabled = enabled and true or false

    MainModule.AutoWinEnabled = enabled

    if MainModule.AutoWinConnection then
        MainModule.AutoWinConnection:Disconnect()
        MainModule.AutoWinConnection = nil
    end

    if not enabled then
        MainModule.cleanup_auto_win_game(MainModule.CurrentGame)

        MainModule.set_auto_win_hunter_features(false)

        if MainModule.TugOfWarUltraFastPull then
            MainModule.toggle_tug_of_war_ultra_fast_pull(false)
        end

        if MainModule.RebelEnabled then
            MainModule.toggle_rebel_v2(false)
        end
    end

    MainModule.AutoWinTriggered = {}
    MainModule.CurrentGame = nil
    MainModule.GameStartTime = nil
    MainModule.LastNotifTime = 0

    if enabled then
        MainModule.AutoWinConnection = RunService.Heartbeat:Connect(function()
            MainModule.auto_win()
        end)
    end

    PlayToggleSound()

    return true
end

getgenv().Time = 3
getgenv().Head = {1095708}
getgenv().Hand = {3141364957}
getgenv().Torso = {2222720521}

local function findMyCharacter()
    local camera = workspace.CurrentCamera
    if camera and camera.CameraSubject then
        local subject = camera.CameraSubject
        if subject and subject:IsA("Humanoid") then
            return subject.Parent
        end
    end

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
            if not string.find(obj.Name:lower(), "badpreload") and not string.find(obj.Name:lower(), "preload") then
                return obj
            end
        end
    end
    return nil
end

local function addAccessory(accessoryId, parentPart)
    local success, accessory = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    end)

    if success and accessory then
        local handle = accessory:FindFirstChild("Handle")
        if handle then
            local accessoryAttachment = handle:FindFirstChildOfClass("Attachment")

            if accessoryAttachment then
                local parentAttachment = parentPart:FindFirstChild(accessoryAttachment.Name)

                if parentAttachment then
                    local weld = Instance.new("Weld")
                    weld.Part0 = parentPart
                    weld.Part1 = handle
                    weld.C0 = parentAttachment.CFrame
                    weld.C1 = accessoryAttachment.CFrame
                    weld.Parent = handle
                else
                    local weld = Instance.new("Weld")
                    weld.Part0 = parentPart
                    weld.Part1 = handle
                    weld.C0 = CFrame.new()
                    weld.C1 = CFrame.new()
                    weld.Parent = handle
                end
            else
                local weld = Instance.new("Weld")
                weld.Part0 = parentPart
                weld.Part1 = handle
                weld.C0 = CFrame.new()
                weld.C1 = CFrame.new()
                weld.Parent = handle
            end

            handle.CanCollide = false
            accessory.Parent = parentPart.Parent

            print("Added to u: " .. tostring(accessoryId))
        else
            warn("No Handle found in accessory: " .. tostring(accessoryId))
        end
    else
        warn("Failed to load accessory: " .. tostring(accessoryId))
    end
end

local function ApplyHeadless(character)
    local head = character:FindFirstChild("Head")
    if not head then return end

    head.Transparency = 1
    head.CanCollide = false

    local face = head:FindFirstChildOfClass("Decal")
    if face then face:Destroy() end

    for _, v in ipairs(head:GetChildren()) do
        if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then
            v:Destroy()
        end
    end

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1095708"
    mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
    mesh.Parent = head
end

local function ApplyKorblox(character)
    local rightLeg = character:FindFirstChild("Right Leg")
    if not rightLeg then return end

    for _, v in ipairs(rightLeg:GetChildren()) do
        if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then
            v:Destroy()
        end
    end

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://3141364957"
    mesh.TextureId = "rbxassetid://3141364957"
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = rightLeg
end

local function AddVisualItems()
    local character = findMyCharacter()
    if not character then return end

    if character:FindFirstChild("Head") then
        for _, id in ipairs(getgenv().Head) do
            addAccessory(id, character.Head)
            task.wait(0.3)
        end
    end

    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if torso then
        for _, id in ipairs(getgenv().Torso) do
            addAccessory(id, torso)
            task.wait(0.3)
        end
    end

    local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("LeftHand")
    if not hand then
        hand = character:FindFirstChild("Right Arm") or character:FindFirstChild("Left Arm")
    end

    if hand and getgenv().Hand then
        for _, id in ipairs(getgenv().Hand) do
            addAccessory(id, hand)
            task.wait(0.3)
        end
    end

    ApplyHeadless(character)
end

function MainModule.toggle_visual_items(enabled)
    MainModule.AddVisualItemsEnabled = enabled

    if MainModule.AddVisualItemsConnection then
        MainModule.AddVisualItemsConnection:Disconnect()
        MainModule.AddVisualItemsConnection = nil
    end

    if enabled then
        AddVisualItems()
        MainModule.AddVisualItemsConnection = LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(1)
            if MainModule.AddVisualItemsEnabled then
                AddVisualItems()
            end
        end)
    end

    PlayToggleSound()
end

local noclippizdaEnabled = false
local originalStates = {}
local connections = {}

local function isWall(part)
    local name = part.Name:lower()
    if name:find("wall") then
        return true
    end
    if part.Size.Y > part.Size.X or part.Size.Y > part.Size.Z then
        return true
    end
    return false
end

local function isFloor(part)
    local name = part.Name:lower()
    if name:find("floor") or name:find("ground") or name:find("plate") then
        return true
    end
    if part.Size.Y < part.Size.X and part.Size.Y < part.Size.Z then
        return true
    end
    return false
end

local function processPart(part)
    if not part:IsA("BasePart") then return end
    local character = LocalPlayer.Character
    if character and part:IsDescendantOf(character) then return end
    if originalStates[part] == nil then
        originalStates[part] = part.CanCollide
    end
    if noclippizdaEnabled then
        if isFloor(part) then
            part.CanCollide = true
        elseif isWall(part) then
            part.CanCollide = false
        end
    else
        part.CanCollide = originalStates[part]
    end
end

local function applyToAll()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        processPart(obj)
    end
end

local function enableNoclip()
    noclippizdaEnabled = true
    applyToAll()
    table.insert(connections, Workspace.DescendantAdded:Connect(function(obj)
        if noclippizdaEnabled then
            processPart(obj)
        end
    end))
end

local function disableNoclip()
    noclippizdaEnabled = false
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(connections)
    for part, original in pairs(originalStates) do
        if part and part.Parent then
            pcall(function() part.CanCollide = original end)
        end
    end
    table.clear(originalStates)
end

MainModule.toggle_noclip = function(enabled)
    enabled = enabled and true or false
    if enabled then
        enableNoclip()
    else
        disableNoclip()
    end
    PlayToggleSound()
    return true
end

MainModule.FreeCam = {
    Enabled = false,
    Camera = nil,
    OriginalCameraType = nil,
    OriginalCameraSubject = nil,
    OriginalCFrame = nil,
    Speed = 10,
    Sensitivity = 0.25,
    Keys = {W=false, S=false, A=false, D=false, Q=false, E=false},
    Connection = nil,
    HeartbeatConnection = nil,
    InputBegan = nil,
    InputEnded = nil,
    Yaw = 0,
    Pitch = 0
}

MainModule.set_free_cam_speed = function(v)
    local n = tonumber(v) or 10
    MainModule.FreeCam.Speed = n
end

MainModule.toggle_free_cam = function(enabled)
    if enabled then
        if MainModule.FreeCam.Enabled then return end
        MainModule.FreeCam.Enabled = true

        local cam = workspace.CurrentCamera
        local char = LocalPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")

        MainModule.FreeCam.OriginalCameraType = cam.CameraType
        MainModule.FreeCam.OriginalCameraSubject = cam.CameraSubject
        MainModule.FreeCam.OriginalCFrame = cam.CFrame
        MainModule.FreeCam.Camera = cam

        if rootPart then
            MainModule.FreeCam.OriginalPosition = rootPart.CFrame
        end

        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = MainModule.FreeCam.OriginalCFrame

        do
            local lv = cam.CFrame.LookVector
            MainModule.FreeCam.Yaw = math.atan2(-lv.X, -lv.Z)
            MainModule.FreeCam.Pitch = math.asin(math.clamp(lv.Y, -1, 1))
        end
        pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter end)
        pcall(function() UserInputService.MouseIconEnabled = false end)

        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = false
                hum.PlatformStand = true
            end
            if rootPart then
                rootPart.Anchored = true
            end
        end

        local function updateFreeCam()
            if not MainModule.FreeCam.Enabled then return end
            local cam = MainModule.FreeCam.Camera
            if not cam then return end

            local delta = UserInputService:GetMouseDelta()
            local sens = MainModule.FreeCam.Sensitivity or 0.25
            MainModule.FreeCam.Yaw = MainModule.FreeCam.Yaw - delta.X * sens * 0.012
            MainModule.FreeCam.Pitch = math.clamp(MainModule.FreeCam.Pitch - delta.Y * sens * 0.012, -1.45, 1.45)

            local rot = CFrame.fromEulerAnglesYXZ(MainModule.FreeCam.Pitch, MainModule.FreeCam.Yaw, 0)
            local pos = cam.CFrame.Position

            local move = Vector3.zero
            if MainModule.FreeCam.Keys.W then move = move + rot.LookVector end
            if MainModule.FreeCam.Keys.S then move = move - rot.LookVector end
            if MainModule.FreeCam.Keys.D then move = move + rot.RightVector end
            if MainModule.FreeCam.Keys.A then move = move - rot.RightVector end
            if MainModule.FreeCam.Keys.Q then move = move - Vector3.yAxis end
            if MainModule.FreeCam.Keys.E then move = move + Vector3.yAxis end

            if move.Magnitude > 0 then
                pos = pos + move.Unit * (MainModule.FreeCam.Speed or 10)
            end
            cam.CFrame = CFrame.new(pos) * rot
        end

        local inputBegan = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            local k = input.KeyCode
            if k == Enum.KeyCode.W then MainModule.FreeCam.Keys.W = true
            elseif k == Enum.KeyCode.S then MainModule.FreeCam.Keys.S = true
            elseif k == Enum.KeyCode.A then MainModule.FreeCam.Keys.A = true
            elseif k == Enum.KeyCode.D then MainModule.FreeCam.Keys.D = true
            elseif k == Enum.KeyCode.Q then MainModule.FreeCam.Keys.Q = true
            elseif k == Enum.KeyCode.E then MainModule.FreeCam.Keys.E = true
            elseif k == Enum.KeyCode.LeftShift then MainModule.FreeCam.Speed = (MainModule.FreeCam.Speed or 10) * 2
            elseif k == Enum.KeyCode.LeftControl then MainModule.FreeCam.Speed = math.max(1, (MainModule.FreeCam.Speed or 10) * 0.4)
            end
        end)

        local inputEnded = UserInputService.InputEnded:Connect(function(input)
            local k = input.KeyCode
            if k == Enum.KeyCode.W then MainModule.FreeCam.Keys.W = false
            elseif k == Enum.KeyCode.S then MainModule.FreeCam.Keys.S = false
            elseif k == Enum.KeyCode.A then MainModule.FreeCam.Keys.A = false
            elseif k == Enum.KeyCode.D then MainModule.FreeCam.Keys.D = false
            elseif k == Enum.KeyCode.Q then MainModule.FreeCam.Keys.Q = false
            elseif k == Enum.KeyCode.E then MainModule.FreeCam.Keys.E = false
            elseif k == Enum.KeyCode.LeftShift or k == Enum.KeyCode.LeftControl then
                MainModule.FreeCam.Speed = MainModule.FreeCam._BaseSpeed or MainModule.FreeCam.Speed or 10
            end
        end)

        MainModule.FreeCam._BaseSpeed = MainModule.FreeCam.Speed
        MainModule.FreeCam.Connection = RunService.RenderStepped:Connect(updateFreeCam)
        MainModule.FreeCam.InputBegan = inputBegan
        MainModule.FreeCam.InputEnded = inputEnded

        HSXNotify("FreeCam", "Mouse look + WASD/QE | Shift fast / Ctrl slow", 0.9)
    else
        if not MainModule.FreeCam.Enabled then return end
        MainModule.FreeCam.Enabled = false

        if MainModule.FreeCam.Connection then
            MainModule.FreeCam.Connection:Disconnect()
            MainModule.FreeCam.Connection = nil
        end
        if MainModule.FreeCam.InputBegan then
            MainModule.FreeCam.InputBegan:Disconnect()
            MainModule.FreeCam.InputBegan = nil
        end
        if MainModule.FreeCam.InputEnded then
            MainModule.FreeCam.InputEnded:Disconnect()
            MainModule.FreeCam.InputEnded = nil
        end

        pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)
        pcall(function() UserInputService.MouseIconEnabled = true end)

        local cam = MainModule.FreeCam.Camera
        if cam then
            cam.CameraType = MainModule.FreeCam.OriginalCameraType or Enum.CameraType.Custom
            if MainModule.FreeCam.OriginalCameraSubject then
                cam.CameraSubject = MainModule.FreeCam.OriginalCameraSubject
            end
        end

        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.AutoRotate = true
                hum.PlatformStand = false
            end
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Anchored = false
                if MainModule.FreeCam.OriginalPosition then
                    rootPart.CFrame = MainModule.FreeCam.OriginalPosition
                end
            end
        end
    end
    PlayToggleSound()
end

MainModule.QuicksilverEnabled = false
MainModule.QuicksilverFolder = nil

MainModule.toggle_quicksilver = function(enabled)
    enabled = enabled and true or false
    MainModule.QuicksilverEnabled = enabled
    if enabled then
        pcall(function()
            local live = Workspace:FindFirstChild("Live") or Workspace:WaitForChild("Live", 5)
            if not live then return end
            local target = live:FindFirstChild(LocalPlayer.Name) or live:WaitForChild(LocalPlayer.Name, 5)
            if not target then return end
            local existing = target:FindFirstChild("IsWallyWest")
            if existing then existing:Destroy() end
            local folder = Instance.new("Folder")
            folder.Name = "IsWallyWest"
            folder.Parent = target
            MainModule.QuicksilverFolder = folder
        end)
        HSXNotify("Quicksilver", "Enabled", 0.8)
    else
        pcall(function()
            if MainModule.QuicksilverFolder and MainModule.QuicksilverFolder.Parent then
                MainModule.QuicksilverFolder:Destroy()
            end
            MainModule.QuicksilverFolder = nil
            local live = Workspace:FindFirstChild("Live")
            local target = live and live:FindFirstChild(LocalPlayer.Name)
            if target then
                local f = target:FindFirstChild("IsWallyWest")
                if f then f:Destroy() end
            end
        end)
        HSXNotify("Quicksilver", "Disabled", 0.8)
    end
    PlayToggleSound()
    return true
end



MainModule.RemoveAnniversaryEnabled = false
MainModule.RemoveAnniversaryTask = nil
MainModule.AnniversaryFolders = {
    "GameplayLobbyForAnniversary",
    "RedLightGreenLightAnniversary",
    "JumpropeAnniversary",
    "Anniversary",
    "LobbyAnniversary",
    "MapAnniversary",
    "HideAndSeekAnniversary",
    "DalgonaAnniversary",
    "SkySquidGameAnniversary",
    "SquidGameAnniversary",
    "GlassBridgeAnniversary",
    "TugOfWarAnniversary",
    "LightsOutEffectBind",
}

local function removeAnniversaryOnce()
    for _, name in ipairs(MainModule.AnniversaryFolders) do
        local obj = workspace:FindFirstChild(name)
        if obj then
            pcall(function() obj:Destroy() end)
        end
    end
    local effects = workspace:FindFirstChild("Effects")
    if effects then
        local blood = effects:FindFirstChild("BloodSplatter")
        if blood then
            pcall(function() blood:Destroy() end)
        end
    end
end

function MainModule.toggle_remove_anniversary(enabled)
    enabled = enabled and true or false
    MainModule.RemoveAnniversaryEnabled = enabled
    if MainModule.RemoveAnniversaryTask then
        task.cancel(MainModule.RemoveAnniversaryTask)
        MainModule.RemoveAnniversaryTask = nil
    end
    if enabled then
        removeAnniversaryOnce()
        MainModule.RemoveAnniversaryTask = task.spawn(function()
            while MainModule.RemoveAnniversaryEnabled do
                task.wait(10)
                if not MainModule.RemoveAnniversaryEnabled then break end
                removeAnniversaryOnce()
            end
            MainModule.RemoveAnniversaryTask = nil
        end)
        HSXNotify("Anniversary", "Decor removal ON", 0.8)
    else
        HSXNotify("Anniversary", "Decor removal OFF", 0.8)
    end
    PlayToggleSound()
    return true
end

MainModule.FakeExploiterEnabled = false
MainModule.FakeExploiter = {
    isActive = false,
    currentTarget = nil,
    fakeChar = nil,
    hideConn = nil,
    seqTask = nil,
    originalNametag = nil,
    nametagParent = nil,
    watchdog = nil,
}

local FE_ANIMS = {
    Startup = "rbxassetid://135801672920476",
    Sprint  = "rbxassetid://82609803681213",
    Jump    = "rbxassetid://130659228300247",
    Fall    = "rbxassetid://112693580156198"
}

function MainModule.FakeExploiter_getNearest()
    local dist = math.huge
    local target = nil
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - myHRP.Position).Magnitude
                if d < dist then
                    dist = d
                    target = p
                end
            end
        end
    end
    return target
end

function MainModule.FakeExploiter_setHidden(char, hidden)
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
            if v.Name ~= "Player_Nametag" and not v:FindFirstAncestor("Player_Nametag") then
                v.LocalTransparencyModifier = hidden and 1 or 0
            end
        elseif v:IsA("Accessory") then
            local handle = v:FindFirstChild("Handle")
            if handle then
                handle.LocalTransparencyModifier = hidden and 1 or 0
            end
        end
    end
end

function MainModule.FakeExploiter_findNametag(char)
    if not char then return nil end
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if torso then
        local tag = torso:FindFirstChild("Player_Nametag")
        if tag then return tag, torso end
    end
    for _, v in ipairs(char:GetDescendants()) do
        if v.Name == "Player_Nametag" then
            return v, v.Parent
        end
    end
    return nil, nil
end

function MainModule.FakeExploiter_moveNametag(realChar, fake)
    local FE = MainModule.FakeExploiter
    local tag, parent = MainModule.FakeExploiter_findNametag(realChar)
    if not tag or not fake then return end
    FE.originalNametag = tag
    FE.nametagParent = parent
    local fakeTorso = fake:FindFirstChild("Torso") or fake:FindFirstChild("UpperTorso")
    if not fakeTorso then return end
    tag.Parent = fakeTorso
end

function MainModule.FakeExploiter_restoreNametag()
    local FE = MainModule.FakeExploiter
    if FE.originalNametag and FE.nametagParent and FE.originalNametag.Parent then
        pcall(function()
            FE.originalNametag.Parent = FE.nametagParent
        end)
    end
    FE.originalNametag = nil
    FE.nametagParent = nil
end

function MainModule.FakeExploiter_turnOff()
    local FE = MainModule.FakeExploiter
    FE.isActive = false
    if FE.seqTask then
        task.cancel(FE.seqTask)
        FE.seqTask = nil
    end
    if FE.hideConn then
        FE.hideConn:Disconnect()
        FE.hideConn = nil
    end
    if FE.watchdog then
        FE.watchdog:Disconnect()
        FE.watchdog = nil
    end
    MainModule.FakeExploiter_restoreNametag()
    if FE.currentTarget and FE.currentTarget.Character then
        MainModule.FakeExploiter_setHidden(FE.currentTarget.Character, false)
    end
    if FE.fakeChar and FE.fakeChar.Parent then
        FE.fakeChar:Destroy()
    end
    FE.currentTarget = nil
    FE.fakeChar = nil
end

function MainModule.FakeExploiter_activate()
    local FE = MainModule.FakeExploiter
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then MainModule.FakeExploiter_turnOff() return end
    if not FE.currentTarget then MainModule.FakeExploiter_turnOff() return end
    local realChar = FE.currentTarget.Character
    if not realChar then MainModule.FakeExploiter_turnOff() return end
    local realHRP = realChar:FindFirstChild("HumanoidRootPart")
    if not realHRP then MainModule.FakeExploiter_turnOff() return end

    local wasArchivable = realChar.Archivable
    realChar.Archivable = true
    FE.fakeChar = realChar:Clone()
    realChar.Archivable = wasArchivable

    for _, v in ipairs(FE.fakeChar:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            v:Destroy()
        elseif v.Name == "Player_Nametag" then
            v:Destroy()
        end
    end

    local fakeHRP = FE.fakeChar:FindFirstChild("HumanoidRootPart")
    local fakeHum = FE.fakeChar:FindFirstChild("Humanoid")
    if not fakeHRP or not fakeHum then
        FE.fakeChar:Destroy()
        MainModule.FakeExploiter_turnOff()
        return
    end

    fakeHRP.Anchored = true
    fakeHRP.CFrame = realHRP.CFrame
    FE.fakeChar.Parent = workspace

    MainModule.FakeExploiter_moveNametag(realChar, FE.fakeChar)

    local animator = fakeHum:FindFirstChildOfClass("Animator") or Instance.new("Animator", fakeHum)
    local function loadAnim(id)
        local a = Instance.new("Animation")
        a.AnimationId = id
        return animator:LoadAnimation(a)
    end

    local trStartup = loadAnim(FE_ANIMS.Startup)
    local trSprint = loadAnim(FE_ANIMS.Sprint)
    local trJump = loadAnim(FE_ANIMS.Jump)
    local trFall = loadAnim(FE_ANIMS.Fall)
    trStartup.Priority = Enum.AnimationPriority.Action4
    trSprint.Priority = Enum.AnimationPriority.Action4
    trJump.Priority = Enum.AnimationPriority.Action4
    trFall.Priority = Enum.AnimationPriority.Action4

    FE.hideConn = RunService.RenderStepped:Connect(function()
        if FE.currentTarget and FE.currentTarget.Character then
            MainModule.FakeExploiter_setHidden(FE.currentTarget.Character, true)
        end
    end)

    FE.seqTask = task.spawn(function()
        trStartup:Play()
        task.wait(0.4)
        trStartup:Stop(0.2)

        trSprint:Play()
        local t = 0
        while t < 2.5 and FE.isActive do
            local dt = task.wait()
            t += dt
            if not myHRP or not myHRP.Parent or not fakeHRP or not fakeHRP.Parent then break end
            local targetPos = myHRP.Position + Vector3.new(math.sin(t * 10) * 16, 0, math.cos(t * 10) * 16)
            local lookAt = CFrame.lookAt(fakeHRP.Position, targetPos + Vector3.new(0, 0.1, 0))
            fakeHRP.CFrame = lookAt * CFrame.new(0, 0, -55 * dt)
            fakeHRP.CFrame = CFrame.new(fakeHRP.Position.X, myHRP.Position.Y, fakeHRP.Position.Z) * fakeHRP.CFrame.Rotation
        end
        trSprint:Stop(0.2)

        trJump:Play()
        t = 0
        while t < 0.45 and FE.isActive do
            local dt = task.wait()
            t += dt
            if not fakeHRP or not fakeHRP.Parent then break end
            fakeHRP.CFrame = fakeHRP.CFrame * CFrame.new(0, 28 * dt, -12 * dt)
        end
        trJump:Stop(0.2)

        trFall:Play()
        local angle = 0
        while FE.isActive do
            local dt = task.wait()
            angle += dt * 6
            if not myHRP or not myHRP.Parent or not fakeHRP or not fakeHRP.Parent then break end
            local radius = 18 + math.sin(angle * 1.5) * 8
            local height = 8 + math.cos(angle * 1.2) * 5
            local targetPos = myHRP.Position + Vector3.new(
                math.sin(angle * 1.2) * radius,
                height,
                math.cos(angle * 1.2) * radius
            )
            local lookAt = CFrame.lookAt(fakeHRP.Position, targetPos)
            fakeHRP.CFrame = lookAt * CFrame.new(0, 0, -70 * dt)
        end
    end)

    FE.watchdog = RunService.Heartbeat:Connect(function()
        if FE.isActive and FE.currentTarget then
            if not FE.currentTarget.Parent or not FE.currentTarget.Character or not FE.currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                MainModule.FakeExploiter_turnOff()
            end
        end
    end)
end

function MainModule.toggle_fake_exploiter(enabled)
    enabled = enabled and true or false
    MainModule.FakeExploiterEnabled = enabled
    if enabled then
        local target = MainModule.FakeExploiter_getNearest()
        if not target then
            MainModule.FakeExploiterEnabled = false
            HSXNotify("Fake Exploiter", "No target nearby", 0.9)
            PlayErrorSound()
            return false
        end
        MainModule.FakeExploiter.isActive = true
        MainModule.FakeExploiter.currentTarget = target
        MainModule.FakeExploiter_activate()
        HSXNotify("Fake Exploiter", "On: " .. tostring(target.DisplayName or target.Name), 1)
    else
        MainModule.FakeExploiter_turnOff()
        HSXNotify("Fake Exploiter", "Off", 0.8)
    end
    PlayToggleSound()
    return true
end


MainModule.CustomLevelEnabled = false
MainModule.CustomLevelValue = 1
MainModule.CustomLevelConnection = nil

MainModule.toggle_custom_level = function(enabled)
    MainModule.CustomLevelEnabled = enabled

    if MainModule.CustomLevelConnection then
        MainModule.CustomLevelConnection:Disconnect()
        MainModule.CustomLevelConnection = nil
    end

    if enabled then
        LocalPlayer:SetAttribute("_CurrentLevel", MainModule.CustomLevelValue)
        MainModule.CustomLevelConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomLevelEnabled then
                LocalPlayer:SetAttribute("_CurrentLevel", MainModule.CustomLevelValue)
            end
        end)
    else
    end
    PlayToggleSound()
end

MainModule.set_custom_level = function(value)
    local num = tonumber(value)
    if num and num >= 1 and num <= 999999 then
        MainModule.CustomLevelValue = math.floor(num)
        if MainModule.CustomLevelEnabled then
            LocalPlayer:SetAttribute("_CurrentLevel", MainModule.CustomLevelValue)
        end
    else
        MainModule.notify("Custom Level", "Invalid number (1-999999)", 0.9)
        PlayErrorSound()
    end
end

MainModule.set_all_level_attributes = function(value)
    local num = tonumber(value)
    if num and num >= 1 then
        local attributes = {
            "_CurrentLevel",
            "CurrentLevel",
            "_Level",
            "Level"
        }

        for _, attr in ipairs(attributes) do
            pcall(function()
                LocalPlayer:SetAttribute(attr, math.floor(num))
            end)
        end

        if MainModule.CustomLevelEnabled then
            MainModule.CustomLevelValue = math.floor(num)
        end

        PlayBell()
    else
        PlayErrorSound()
    end
end

MainModule.CustomWinstreakEnabled = false
MainModule.CustomWinstreakValue = 0
MainModule.CustomWinstreakConnection = nil

MainModule.toggle_custom_winstreak = function(enabled)
    MainModule.CustomWinstreakEnabled = enabled

    if MainModule.CustomWinstreakConnection then
        MainModule.CustomWinstreakConnection:Disconnect()
        MainModule.CustomWinstreakConnection = nil
    end

    if enabled then
        LocalPlayer:SetAttribute("_ConsecutiveWins", MainModule.CustomWinstreakValue)
        MainModule.CustomWinstreakConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomWinstreakEnabled then
                LocalPlayer:SetAttribute("_ConsecutiveWins", MainModule.CustomWinstreakValue)
            end
        end)
    else
    end
    PlayToggleSound()
end

MainModule.set_custom_winstreak = function(value)
    local num = tonumber(value)
    if num and num >= 0 and num <= 999999 then
        MainModule.CustomWinstreakValue = math.floor(num)
        if MainModule.CustomWinstreakEnabled then
            LocalPlayer:SetAttribute("_ConsecutiveWins", MainModule.CustomWinstreakValue)
        end
    else
        MainModule.notify("Custom Winstreak", "Invalid number (0-999999)", 0.9)
        PlayErrorSound()
    end
end

MainModule.set_all_winstreak_attributes = function(value)
    local num = tonumber(value)
    if num and num >= 0 then
        local attributes = {
            "_ConsecutiveWins",
            "ConsecutiveWins",
            "_WinStreak",
            "WinStreak",
            "_CurrentStreak",
            "CurrentStreak",
            "_Streak",
            "Streak"
        }

        for _, attr in ipairs(attributes) do
            pcall(function()
                LocalPlayer:SetAttribute(attr, math.floor(num))
            end)
        end

        if MainModule.CustomWinstreakEnabled then
            MainModule.CustomWinstreakValue = math.floor(num)
        end

        MainModule.notify("Winstreak", "Set to: " .. math.floor(num), 0.9)
    else
        MainModule.notify("Winstreak", "Invalid number!", 0.9)
        PlayErrorSound()
    end
end

local EmotesList = {
    {Name = "JumpMaxxing", AnimId = "rbxassetid://117992339950574", SoundId = "rbxassetid://101111943336616", Volume = 5},
    {Name = "Catch Catch", AnimId = "rbxassetid://110575780667276", SoundId = {"rbxassetid://139710162629738", "rbxassetid://109474708805441"}, Volume = 5},
    {Name = "Triple T dance", AnimId = "rbxassetid://87099414813526", SoundId = "rbxassetid://134846418381928", Volume = 5},
    {Name = "AVGN", AnimId = "rbxassetid://123450801218845", SoundId = "rbxassetid://74497095127038", Volume = 5},
    {Name = "Bubble pop electric", AnimId = "rbxassetid://75245548704974", SoundId = "rbxassetid://140344891172315", Volume = 5},
    {Name = "Dream Journal", AnimId = "rbxassetid://117325441970867", SoundId = "rbxassetid://88476306353688", Volume = 10},
    {Name = "Otsukare Summer", AnimId = "rbxassetid://134888005420629", SoundId = "rbxassetid://127332409398776", Volume = 3},
    {Name = "Spite", AnimId = "rbxassetid://100382123964355", SoundId = "rbxassetid://90513005423910", Volume = 5},
    {Name = "Posing Time", AnimId = "rbxassetid://89240795237958", SoundId = "rbxassetid://113259086406604", Volume = 5},
    {Name = "Shuffle", AnimId = "rbxassetid://113121578988536", SoundId = "rbxassetid://127426881747595", Volume = 5},
    {Name = "Yare Yare", AnimId = "rbxassetid://86642655479570", SoundId = "rbxassetid://128193072645447", Volume = 5},
    {Name = "My Perfect Victory", AnimId = "rbxassetid://110501561372722", SoundId = "rbxassetid://104280886491008", Volume = 5},
    {Name = "Fate Of Both Worlds", AnimId = "rbxassetid://114244682550258", SoundId = "rbxassetid://103081000050688", Volume = 5},
    {Name = "Peanut of Butter House", AnimId = "rbxassetid://108074529570331", SoundId = "rbxassetid://95893903149232", Volume = 5},
    {Name = "Cat Hands", AnimId = "rbxassetid://87331103640233", SoundId = "rbxassetid://126527049854337", Volume = 5},
    {Name = "The System", AnimId = "rbxassetid://117978762262770", SoundId = "rbxassetid://73318799732606", Volume = 5},
    {Name = "Gear 5", AnimId = "rbxassetid://107815350238463", SoundId = nil, Volume = 5},
    {Name = "Mingle Dance", AnimId = "rbxassetid://99559083669885", SoundId = "rbxassetid://89379201770587", Volume = 5},
    {Name = "Metro Dance", AnimId = "rbxassetid://104701586795462", SoundId = "rbxassetid://95730226592096", Volume = 5},
    {Name = "Funeral for the living", AnimId = "rbxassetid://123297701965318", SoundId = "rbxassetid://105930820096344", Volume = 5},
    {Name = "Cartwheel", AnimId = "rbxassetid://131418698864660", SoundId = "rbxassetid://18911882091", Volume = 5},
    {Name = "Lively Walk", AnimId = "rbxassetid://99556634315867", SoundId = "rbxassetid://16706317921", Volume = 5},
    {Name = "Dance of nights", AnimId = "rbxassetid://100183800468181", SoundId = "rbxassetid://133365635431929", Volume = 5},
    {Name = "Sonic run", AnimId = "rbxassetid://120151271879240", SoundId = "rbxassetid://131594734029433", Volume = 5},
    {Name = "Khabilame", AnimId = "rbxassetid://133158883386630", SoundId = "rbxassetid://131852145461258", Volume = 5},
    {Name = "Mii swing", AnimId = "rbxassetid://111293910946685", SoundId = "rbxassetid://121596432073446", Volume = 5},
    {Name = "Jackpot", AnimId = "rbxassetid://90063856357375", SoundId = "rbxassetid://96528255406149", Volume = 5},
    {Name = "Scuba", AnimId = "rbxassetid://125809050313880", SoundId = "rbxassetid://78439444151879", Volume = 5},
    {Name = "Crying", AnimId = "rbxassetid://96313533433486", SoundId = "rbxassetid://18151791880", Volume = 5},
    {Name = "Ogame", AnimId = "rbxassetid://117778295104747", SoundId = "rbxassetid://122457089809687", Volume = 5},
    {Name = "Blue Shirt Kid", AnimId = "rbxassetid://83396620848313", SoundId = "rbxassetid://115875415839739", Volume = 5},
    {Name = "Zepelli", AnimId = "rbxassetid://135418027114658", SoundId = nil, Volume = 5},
    {Name = "Woke Up The World", AnimId = "rbxassetid://130106286443990", SoundId = "rbxassetid://0275579621574", Volume = 5},
    {Name = "Mask", AnimId = "rbxassetid://102176887169297", SoundId = "rbxassetid://97952595881264", Volume = 5}

}

local currentEmoteAnim = nil
local currentEmoteSound = nil
local isPlaying = false
local emoteDropdown = nil
local emoteButton = nil

local function StopCurrentEmote()
    if currentEmoteAnim then
        pcall(function() currentEmoteAnim:Stop() end)
        currentEmoteAnim = nil
    end
    if currentEmoteSound then
        if type(currentEmoteSound) == "table" then
            for _, s in ipairs(currentEmoteSound) do
                pcall(function() s:Stop() end)
                pcall(function() s:Destroy() end)
            end
        else
            pcall(function() currentEmoteSound:Stop() end)
            pcall(function() currentEmoteSound:Destroy() end)
        end
        currentEmoteSound = nil
    end
    isPlaying = false
    if emoteButton then
        emoteButton:SetText("Play Emote")
    end
end

local function PlayEmote(emoteData)
    StopCurrentEmote()
    if not emoteData or not emoteData.AnimId then return end
    local h = MainModule.get_humanoid(MainModule.get_character())
    if not h then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = emoteData.AnimId
    local ok, track = pcall(function() return h:LoadAnimation(anim) end)
    if not ok or not track then return end
    currentEmoteAnim = track
    pcall(function() track.Looped = true end)
    track:Play()
    if emoteData.SoundId then
        local ids = emoteData.SoundId
        if type(ids) == "string" then ids = {ids} end
        if type(ids) == "table" then
            currentEmoteSound = {}
            for _, sid in ipairs(ids) do
                if type(sid) == "string" and sid ~= "" then
                    local s = Instance.new("Sound")
                    s.SoundId = sid
                    s.Volume = emoteData.Volume or 5
                    s.Looped = true
                    s.Parent = SoundService
                    pcall(function() s:Play() end)
                    table.insert(currentEmoteSound, s)
                end
            end
        end
    end
    isPlaying = true
    PlayBell()
end

local emoteNames = {}
for _, emote in ipairs(EmotesList) do
    table.insert(emoteNames, emote.Name)
end

local function FixMobileVolume()
MainModule.stopEmote = StopCurrentEmote
MainModule.playEmote = PlayEmote
    if MainModule.is_mobile() then
        for _, emote in ipairs(EmotesList) do
            emote.Volume = 3
        end
    end
end

FixMobileVolume()

MainModule.cleanup_everything = function()
    MainModule.toggle_auto_win(false)
    MainModule.toggle_rebel(false)
    MainModule.toggle_fly(false, true)
    MainModule.ToggleESP(false)
    MainModule.toggle_speed_hack(false)
    MainModule.toggle_remove_stun(false)
    MainModule.toggle_fov(false)
    MainModule.toggle_fullbright(false)
    MainModule.toggle_ambience(false)
    MainModule.toggle_rapid_fire(false)
    MainModule.toggle_infinite_ammo(false)
    MainModule.toggle_auto_next_game(false)
    MainModule.toggle_auto_safe(false)
    MainModule.toggle_auto_dodge(false)
    MainModule.toggle_auto_escape(false)
    MainModule.toggle_auto_pickup(false)
    MainModule.ToggleFreeGuard(false)
    MainModule.toggle_effect_shooter(false)
    MainModule.toggle_face_target(false)
    MainModule.toggle_player_attach(false)
    MainModule.toggle_god_mode(false)
    MainModule.toggle_remove_injury(false)
    MainModule.toggle_anti_break(false)
    MainModule.toggle_jump_rope_anti_fall(false)
    MainModule.toggle_glass_esp(false)
    MainModule.toggle_spikes_kill(false)
    MainModule.toggle_spikes_platform_teleport(false)
    MainModule.toggle_key_esp(false)
    MainModule.toggle_exit_door_esp(false)
    MainModule.ToggleEspGuards(false)
    MainModule.toggle_sky_squid_anti_fall(false)
    MainModule.toggle_void_kill(false)
    MainModule.toggle_mingle_void_kill(false)
    pcall(function() if MainModule.toggle_faster_sprint then MainModule.toggle_faster_sprint(false) end end)
    MainModule.toggle_zone_kill(false)
    MainModule.toggle_auto_choke(false)
    MainModule.ToggleInfiniteStamina(false)
    MainModule.toggle_desync(false)

    MainModule.stopEmote()

    if MainModule.AutoWinConnection then
        MainModule.AutoWinConnection:Disconnect()
        MainModule.AutoWinConnection = nil
    end

    if MainModule.Rebel.Connection then
        MainModule.Rebel.Connection:Disconnect()
        MainModule.Rebel.Connection = nil
    end

    if MainModule.Fly.Connection then
        MainModule.Fly.Connection:Disconnect()
        MainModule.Fly.Connection = nil
    end
    if MainModule.Fly.BodyVelocity then
        MainModule.Fly.BodyVelocity:Destroy()
        MainModule.Fly.BodyVelocity = nil
    end

    if MainModule.SpeedHackLoop then
        task.cancel(MainModule.SpeedHackLoop)
        MainModule.SpeedHackLoop = nil
    end

    if MainModule.FOVConnection then
        MainModule.FOVConnection:Disconnect()
        MainModule.FOVConnection = nil
    end

    if MainModule.FullbrightConnection then
        MainModule.FullbrightConnection:Disconnect()
        MainModule.FullbrightConnection = nil
    end

    if MainModule.ambienceConnection then
        MainModule.ambienceConnection:Disconnect()
        MainModule.ambienceConnection = nil
    end
    if MainModule.timeFixConnection then
        MainModule.timeFixConnection:Disconnect()
        MainModule.timeFixConnection = nil
    end
    if MainModule.motionBlur then
        MainModule.motionBlur:Destroy()
        MainModule.motionBlur = nil
    end

    if MainModule.AutoDodge.HeartbeatConnection then
        MainModule.AutoDodge.HeartbeatConnection:Disconnect()
        MainModule.AutoDodge.HeartbeatConnection = nil
    end
    for _, conn in pairs(MainModule.AutoDodge.Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    MainModule.AutoDodge.Connections = {}

    if MainModule.AutoDodge.Remote and MainModule.AutoDodge.OriginalFireServer then
        pcall(function()
            MainModule.AutoDodge.Remote.FireServer = MainModule.AutoDodge.OriginalFireServer
        end)
    end

    if MainModule.AutoEscapeConnection then
        MainModule.AutoEscapeConnection:Disconnect()
        MainModule.AutoEscapeConnection = nil
    end

    for _, platform in pairs(MainModule.SafetyPlatforms) do
        if platform then pcall(function() platform:Destroy() end) end
    end
    MainModule.SafetyPlatforms = {}
    if MainModule.AntiBreakConn then
        MainModule.AntiBreakConn:Disconnect()
        MainModule.AntiBreakConn = nil
    end

    if MainModule.JumpRopeAntiFall.Conn then
        MainModule.JumpRopeAntiFall.Conn:Disconnect()
        MainModule.JumpRopeAntiFall.Conn = nil
    end
    if MainModule.JumpRopeAntiFall.Platform then
        MainModule.JumpRopeAntiFall.Platform:Destroy()
        MainModule.JumpRopeAntiFall.Platform = nil
    end

    pcall(function()
        local gh = Workspace:FindFirstChild("GlassBridge") and Workspace.GlassBridge:FindFirstChild("GlassHolder")
        if gh then
            for _, l in pairs(gh:GetChildren()) do
                for _, gm in pairs(l:GetChildren()) do
                    if gm:IsA("Model") then
                        for _, p in pairs(gm:GetDescendants()) do
                            if p:IsA("BasePart") and p:GetAttribute("GlassPart") then
                                p.Color = Color3.fromRGB(163, 162, 165)
                                p.Material = Enum.Material.Glass
                                p.Transparency = 0
                            end
                        end
                    end
                end
            end
        end
    end)

    for part, props in pairs(MainModule.ModifiedParts) do
        if part and part.Parent then
            pcall(function()
                part.Size = props.Size
                part.CanCollide = props.CanCollide
                part.Transparency = props.Transparency
            end)
        end
    end
    MainModule.ModifiedParts = {}

    for o, v in pairs(MainModule.OriginalFireRates) do
        if o and o.Parent then pcall(function() o.Value = v end) end
    end
    MainModule.OriginalFireRates = {}

    for o, v in pairs(MainModule.OriginalAmmo) do
        if o and o.Parent then pcall(function() o.Value = v end) end
    end
    MainModule.OriginalAmmo = {}

    local c = MainModule.get_character()
    if c then
        local h = MainModule.get_humanoid(c)
        if h then
            pcall(function() h.WalkSpeed = 16 end)
        end
    end

    MainModule.clear_esp()

    if MainModule.EspGuardsThread then
        task.cancel(MainModule.EspGuardsThread)
        MainModule.EspGuardsThread = nil
    end
    for part, box in pairs(MainModule.EspGuardsBoxes) do
        if box then pcall(function() box:Destroy() end) end
    end
    MainModule.EspGuardsBoxes = {}

    if MainModule.ExitDoorESPThread then
        task.cancel(MainModule.ExitDoorESPThread)
        MainModule.ExitDoorESPThread = nil
    end
    for _, obj in pairs(MainModule.ExitDoorESPObjects) do
        if obj then pcall(function() obj:Destroy() end) end
    end
    MainModule.ExitDoorESPObjects = {}

    for _, esp in pairs(MainModule.KeyESPBoxes) do
        if esp then pcall(function() esp:Destroy() end) end
    end
    MainModule.KeyESPBoxes = {}
    if MainModule.KeyESPConnection then
        MainModule.KeyESPConnection:Disconnect()
        MainModule.KeyESPConnection = nil
    end

    if MainModule.SpikesKillFeature.PlatformPart then
        pcall(function() MainModule.SpikesKillFeature.PlatformPart:Destroy() end)
        MainModule.SpikesKillFeature.PlatformPart = nil
    end
    if MainModule.SpikesKillFeature.AnimationConnection then
        MainModule.SpikesKillFeature.AnimationConnection:Disconnect()
        MainModule.SpikesKillFeature.AnimationConnection = nil
    end
    if MainModule.SpikesKillFeature.CharacterAddedConnection then
        MainModule.SpikesKillFeature.CharacterAddedConnection:Disconnect()
        MainModule.SpikesKillFeature.CharacterAddedConnection = nil
    end
    if MainModule.SpikesKillFeature.SafetyCheckConnection then
        MainModule.SpikesKillFeature.SafetyCheckConnection:Disconnect()
        MainModule.SpikesKillFeature.SafetyCheckConnection = nil
    end
    if MainModule.SpikesKillFeature.AnimationCheckConnection then
        MainModule.SpikesKillFeature.AnimationCheckConnection:Disconnect()
        MainModule.SpikesKillFeature.AnimationCheckConnection = nil
    end
    for _, conn in pairs(MainModule.SpikesKillFeature.AnimationStoppedConnections) do
        pcall(function() conn:Disconnect() end)
    end
    MainModule.SpikesKillFeature.AnimationStoppedConnections = {}

    if MainModule.SpikesPlatformTeleport.Platform then
        pcall(function() MainModule.SpikesPlatformTeleport.Platform:Destroy() end)
        MainModule.SpikesPlatformTeleport.Platform = nil
    end
    if MainModule.SpikesPlatformTeleport.Connection then
        MainModule.SpikesPlatformTeleport.Connection:Disconnect()
        MainModule.SpikesPlatformTeleport.Connection = nil
    end

    if MainModule.ZoneKillFeature.AnimationConnection then
        MainModule.ZoneKillFeature.AnimationConnection:Disconnect()
        MainModule.ZoneKillFeature.AnimationConnection = nil
    end
    if MainModule.ZoneKillFeature.CharacterAddedConnection then
        MainModule.ZoneKillFeature.CharacterAddedConnection:Disconnect()
        MainModule.ZoneKillFeature.CharacterAddedConnection = nil
    end
    if MainModule.ZoneKillFeature.AnimationCheckConnection then
        MainModule.ZoneKillFeature.AnimationCheckConnection:Disconnect()
        MainModule.ZoneKillFeature.AnimationCheckConnection = nil
    end
    for _, conn in pairs(MainModule.ZoneKillFeature.AnimationStoppedConnections) do
        pcall(function() conn:Disconnect() end)
    end
    MainModule.ZoneKillFeature.AnimationStoppedConnections = {}

    if MainModule.VoidKillConn then
        MainModule.VoidKillConn:Disconnect()
        MainModule.VoidKillConn = nil
    end
    if MainModule.VoidKillCharConn then
        MainModule.VoidKillCharConn:Disconnect()
        MainModule.VoidKillCharConn = nil
    end

    for _, conn in pairs(MainModule.MingleConns) do
        pcall(function() conn:Disconnect() end)
    end
    MainModule.MingleConns = {}

    if MainModule.SkySquidAntiFall.Platform then
        pcall(function() MainModule.SkySquidAntiFall.Platform:Destroy() end)
        MainModule.SkySquidAntiFall.Platform = nil
    end
    if MainModule.SkySquidAntiFall.Conn then
        MainModule.SkySquidAntiFall.Conn:Disconnect()
        MainModule.SkySquidAntiFall.Conn = nil
    end

    for part, originalSize in pairs(MainModule.GuardOriginalSizes) do
        if part and part.Parent then
            pcall(function() part.Size = originalSize end)
        end
    end
    MainModule.GuardOriginalSizes = {}

    if MainModule.StaminaConns then
        for _, conn in pairs(MainModule.StaminaConns) do
            pcall(function() conn:Disconnect() end)
        end
        MainModule.StaminaConns = {}
    end

    if MainModule.GameStateMonitor.Connection then
        MainModule.GameStateMonitor.Connection:Disconnect()
        MainModule.GameStateMonitor.Connection = nil
    end

    if MainModule.noclipButton then
        pcall(function() MainModule.noclipButton:Destroy() end)
        MainModule.noclipButton = nil
    end
    if MainModule.noclipConnection then
        MainModule.noclipConnection:Disconnect()
        MainModule.noclipConnection = nil
    end

    if MainModule.attachConnection then
        MainModule.attachConnection:Disconnect()
        MainModule.attachConnection = nil
    end
    if MainModule.autoSearchConnection then
        MainModule.autoSearchConnection:Disconnect()
        MainModule.autoSearchConnection = nil
    end

    MainModule.destroySquares()

    if MainModule.CurrentBodyVelocity then
        MainModule.CurrentBodyVelocity:Destroy()
        MainModule.CurrentBodyVelocity = nil
    end

    if MainModule.FaceTargetModule.Connection then
        MainModule.FaceTargetModule.Connection:Disconnect()
        MainModule.FaceTargetModule.Connection = nil
    end
    MainModule.FaceTargetModule.Enabled = false

    MainModule.FullbrightEnabled = false
    MainModule.RemoveStunEnabled = false
    MainModule.AutoWinEnabled = false
    MainModule.AutoDodge.Enabled = false
    MainModule.AutoDodge.ActiveAnimations = {}
    MainModule.AutoDodge.LastAnimationStartTime = {}
    MainModule.AutoDodge.LastDodgeTime = 0

    local Lighting = game:GetService("Lighting")
    if MainModule.FullbrightSettings.Brightness then
        Lighting.Brightness = MainModule.FullbrightSettings.Brightness
        Lighting.ClockTime = MainModule.FullbrightSettings.ClockTime
        Lighting.FogEnd = MainModule.FullbrightSettings.FogEnd
        Lighting.GlobalShadows = MainModule.FullbrightSettings.GlobalShadows
        Lighting.OutdoorAmbient = MainModule.FullbrightSettings.OutdoorAmbient
        Lighting.Ambient = MainModule.FullbrightSettings.Ambient
    end

    pcall(function()
        workspace.CurrentCamera.FieldOfView = 70
    end)

    MainModule.Fly.Enabled = false
    MainModule.Fly.Speed = 45
    MainModule.SpeedHackEnabled = false
    MainModule.SpeedValue = 39
    MainModule.FOVEnabled = false
    MainModule.FOVValue = 120
    MainModule.AmbienceEnabled = false
    MainModule.RapidFireEnabled = false
    MainModule.InfiniteAmmoEnabled = false
    MainModule.AutoNextEnabled = false
    MainModule.AutoSafe.Enabled = false
    MainModule.AutoSafe.HasTeleported = false
    MainModule.AutoSafe.LowHPChecked = false
    MainModule.AutoEscapeEnabled = false
    MainModule.AutoPickupEnabled = false
    MainModule.FreeGuardSettings.Enabled = false
    MainModule.EffectShooter.Enabled = false
    MainModule.PlayerAttachEnabled = false
    MainModule.GodModeEnabled = false
    MainModule.RemoveInjuryEnabled = false
    MainModule.AntiBreakEnabled = false
    MainModule.JumpRopeAntiFall.Enabled = false
    MainModule.GlassESPEnabled = false
    MainModule.SpikesKillFeature.Enabled = false
    MainModule.SpikesPlatformTeleport.Enabled = false
    MainModule.KeyESPEnabled = false
    MainModule.ExitDoorESPEnabled = false
    MainModule.EspGuardsEnabled = false
    MainModule.SkySquidAntiFall.Enabled = false
    MainModule.VoidKillEnabled = false
    MainModule.MingleVoidKillEnabled = false
    MainModule.ZoneKillFeature.Enabled = false
    MainModule.AutoChokeEnabled = false
    MainModule.InfStaminaActive = false
    MainModule.noclipEnabled = false

    local forceOff = {
        "toggle_free_cam", "toggle_noclip", "toggle_phantom_dash", "toggle_peabert_kill",
        "toggle_hide_nickname", "toggle_hide_all_nicknames", "toggle_custom_gravity",
        "toggle_custom_jump_power", "toggle_infinite_jump", "toggle_quicksilver",
        "toggle_parkour_artist", "toggle_visual_items", "toggle_free_title",
        "toggle_permanent_guard", "toggle_custom_player_tag", "toggle_private_server_plus",
        "toggle_lighter", "toggle_glass_vision", "toggle_player_esp", "toggle_esprgb",
        "toggle_auto_skip", "toggle_auto_vote", "toggle_auto_collect_bandage",
        "toggle_auto_collect_flashbang", "toggle_auto_collect_grenade", "toggle_rage_auto_qte",
        "toggle_legit_auto_qte", "toggle_auto_win", "toggle_auto_next_game", "toggle_auto_safe",
        "toggle_speed_hack", "toggle_fly", "toggle_fov", "toggle_fullbright",
        "toggle_no_cooldown_proximity", "toggle_custom_win", "toggle_custom_level",
        "toggle_custom_winstreak", "toggle_rebel", "toggle_rebel_v2",
    }
    for _, name in ipairs(forceOff) do
        local fn = MainModule[name]
        if type(fn) == "function" then
            pcall(function() fn(false) end)
        end
    end

    if MainModule.KeybindConns then
        for id, conn in pairs(MainModule.KeybindConns) do
            pcall(function() conn:Disconnect() end)
        end
        MainModule.KeybindConns = {}
    end
    pcall(function()
        if MainModule.toggle_free_cam then MainModule.toggle_free_cam(false) end
        if MainModule.toggle_noclip then MainModule.toggle_noclip(false) end
        if MainModule.toggle_phantom_dash then MainModule.toggle_phantom_dash(false) end
        if MainModule.toggle_peabert_kill then MainModule.toggle_peabert_kill(false) end
    end)
    cursorVisible = false
    pcall(function()
        if _G.HollyScriptX_CursorDrawings then
            for _, d in ipairs(_G.HollyScriptX_CursorDrawings) do
                pcall(function() d.Visible = false; if d.Remove then d:Remove() end end)
            end
        end
        if _G.HollyScriptX_CursorConnections then
            for _, c in ipairs(_G.HollyScriptX_CursorConnections) do
                pcall(function() c:Disconnect() end)
            end
        end
    end)
    pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)
    pcall(function() UserInputService.MouseIconEnabled = true end)
end

task.defer(function()
    task.wait(0.5)
    pcall(function()
        if MainModule.update_all_toggles_by_game then
            MainModule.update_all_toggles_by_game()
        end
    end)
end)

task.spawn(function()
    task.wait(1)
    pcall(function()
        if sendWebhook then sendWebhook() end
    end)
end)

HSXNotify("HollyScriptX", "Ink Game", 0.9)

Library.CornerRadius = 12
pcall(function()
	if type(Library.SetCornerRadius) == "function" then
		Library:SetCornerRadius(12)
	end
end)

Library.CornerRadius = 12
local Window = Library:CreateWindow({
	Title = "HollyScriptX",
	Center = true,
	Footer = "discord.gg/hollyscriptx-1504482964661076098 | Ink Game",
	Resizable = true,
	AutoShow = true,
	ShowCustomCursor = false,
	ToggleKeybind = Enum.KeyCode.Z,
	AlwaysOnTop = true,
	Acrylic = true,
})
pcall(function()
	if Library.SetAlwaysOnTop then Library:SetAlwaysOnTop(true) end
	if Library.ToggleAcrylic then Library:ToggleAcrylic(true) end
	if Library.SetAcrylic then Library:SetAcrylic(true) end
	if type(Library.Acrylic) ~= "nil" then Library.Acrylic = true end
end)

task.defer(function()
	pcall(function()
		local roots = {}
		if Library.ScreenGui then table.insert(roots, Library.ScreenGui) end
		if typeof(Window) == "table" and Window.Root then table.insert(roots, Window.Root) end
		for _, root in ipairs(roots) do
			if typeof(root) == "Instance" then
				for _, d in ipairs(root:GetDescendants()) do
					if d:IsA("UICorner") then
						d.CornerRadius = UDim.new(0, 12)
					end
				end
				root.DescendantAdded:Connect(function(d)
					if d:IsA("UICorner") then
						task.defer(function()
							pcall(function() d.CornerRadius = UDim.new(0, 12) end)
						end)
					end
				end)
			end
		end
	end)
end)
pcall(function()
	if Library.KeybindFrame then
		Library.KeybindFrame.Visible = false
	end
end)


MainModule.guiCreated = true
_G.HSX_Window = Window
WindUI.Window = Window


local _rawAddTab = Window.AddTab
function Window:Tab(opts)
	opts = opts or {}
	local title = opts.Title or "Tab"
	local icon = opts.Icon
	local tab = _rawAddTab(Window, title, icon)
	local wrapped = MainModule.wrapTab(tab)
	wrapped._raw = tab
	return wrapped
end
function Window:AddTab(title, icon)
	local tab = _rawAddTab(Window, title, icon)
	local wrapped = MainModule.wrapTab(tab)
	wrapped._raw = tab
	return wrapped
end
function Window:SetToggleKey(key)
	pcall(function() Library.ToggleKeybind = key end)
end
function Window:Destroy()
	pcall(function() Library:Unload() end)
end
function Window:ToggleTransparency() end
function Window:SetTheme() end

Library:SetDPIScale(100)
task.defer(function()
	for _, n in ipairs(MainModule.pendingNotifications) do
		pcall(function()
			HSXNotify({ Title = n.title, Description = n.text, Duration = n.duration or 0.9 })
		end)
	end
	MainModule.pendingNotifications = {}
end)

local function sc(fn, ...)
	if type(fn) ~= "function" then return end
	local a = {...}
	task.spawn(function() pcall(fn, table.unpack(a)) end)
end

MainModule.LightsOutSafe = {
	Enabled = false,
	SavedCFrame = nil,
	Wall = nil,
}

function MainModule.toggle_lights_out_safezone(enabled)
	enabled = enabled and true or false
	MainModule.LightsOutSafe.Enabled = enabled
	local char = MainModule.get_character and MainModule.get_character() or LocalPlayer.Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)

	if enabled then
		if root then
			MainModule.LightsOutSafe.SavedCFrame = root.CFrame
			pcall(function()
				root.CFrame = CFrame.new(178, 56, 50)
			end)
		end
		PlayToggleSound()
		return true
	else
		if root and MainModule.LightsOutSafe.SavedCFrame then
			pcall(function()
				root.CFrame = MainModule.LightsOutSafe.SavedCFrame
			end)
		end
		MainModule.LightsOutSafe.SavedCFrame = nil
		PlayToggleSound()
		return true
	end
end

local InfoTab = Window:Tab({ Title = "Information", Icon = "info", Desc = "Discord & credits" })
do
	local s = InfoTab:Section({ Title = "Discord", Icon = "message-circle", Opened = true })
	local nameP = s:Paragraph({ Title = "Server: ..." })
	local memP = s:Paragraph({ Title = "Total Members: ..." })
	local onP = s:Paragraph({ Title = "Online Members: ..." })
	s:Button({
		Title = "Copy Discord Invite",
		Callback = function()
			pcall(function() setclipboard("https://discord.gg/hollyscriptx-1504482964661076098") end)
			HSXNotify("Discord", "ok copied link", 1.2)
		end
	})
	task.spawn(function()
		for _, code in ipairs({"hsx", "fBTP3ry53Q"}) do
			local ok, res = pcall(function()
				return game:HttpGet("https://discord.com/api/v10/invites/" .. code .. "?with_counts=true")
			end)
			if ok and res then
				local ok2, data = pcall(function() return HttpService:JSONDecode(res) end)
				if ok2 and data and data.guild then
					pcall(function()
						nameP:SetTitle("Server: " .. tostring(data.guild.name))
						memP:SetTitle("Members: " .. tostring(data.approximate_member_count or "?"))
						onP:SetTitle("Online: " .. tostring(data.approximate_presence_count or "?"))
					end)
					break
				end
			end
		end
	end)
	local c = InfoTab:Section({ Title = "Credits", Icon = "heart", Opened = true })
	c:Paragraph({ Title = "whonixx - script owner" })
	c:Paragraph({ Title = "shades - script owner" })
	c:Paragraph({ Title = "insected - helped with obf/dc server" })
	c:Paragraph({ Title = "chillnie - script tester/co-owner" })
	c:Paragraph({ Title = "rezorn - script helper/developer" })
end

MainModule.Keybinds = MainModule.Keybinds or {}
MainModule.KeybindConns = MainModule.KeybindConns or {}
MainModule.KeybindUI = MainModule.KeybindUI or {}
MainModule._KeybindPress = MainModule._KeybindPress or {}
MainModule._KeybindToggleRefs = MainModule._KeybindToggleRefs or {}

MainModule._KeybindIgnoreUntil = 0
MainModule._KeybindSetting = false
function MainModule.HSXNormalizeKey(v)
	if v == nil then return "None" end
	if typeof(v) == "EnumItem" then return v.Name end
	if type(v) == "boolean" then return "None" end
	local s = tostring(v)
	if s == "" or s == "nil" or s == "Nil" or s == "true" or s == "false" then return "None" end
	s = s:gsub("^Enum%.KeyCode%.", ""):gsub("^KeyCode%.", "")
	s = s:match("([%w_]+)$") or s
	if s == "" then return "None" end
	return s
end

if not MainModule._KeybindDispatcher then
	MainModule._KeybindDispatcher = UserInputService.InputBegan:Connect(function(input, gp)
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		if UserInputService:GetFocusedTextBox() then return end
		if MainModule._KeybindSetting then return end
		if tick() < (MainModule._KeybindIgnoreUntil or 0) then return end
		local pressed = input.KeyCode and input.KeyCode.Name
		if not pressed or pressed == "Unknown" then return end
		local handlers = MainModule._KeybindPress or {}
		local binds = MainModule.Keybinds or {}
		for id, key in pairs(binds) do
			if id ~= "Menu" then
				local nk = MainModule.HSXNormalizeKey(key)
				if nk ~= "None" and nk ~= "" and string.lower(nk) == string.lower(pressed) then
					local fn = handlers[id]
					if type(fn) == "function" then
						MainModule._KeybindLastFire = MainModule._KeybindLastFire or {}
						local now = tick()
						if (MainModule._KeybindLastFire[id] or 0) + 0.15 <= now then
							MainModule._KeybindLastFire[id] = now
							task.spawn(function()
								pcall(fn)
							end)
						end
					end
				end
			end
		end
	end)
end

function MainModule.HSXRegisterKeybind(id, keyName, onPress)
	if onPress then MainModule._KeybindPress[id] = onPress end
	if keyName ~= nil then
		MainModule.Keybinds[id] = MainModule.HSXNormalizeKey(keyName)
	end
end

local function HSXUpdateToggleDesc(id)
end

function MainModule.HSXSyncKeybindUI(id, keyName)
	keyName = MainModule.HSXNormalizeKey(keyName)
	MainModule._KeybindSetting = true
	local list = MainModule.KeybindUI and MainModule.KeybindUI[id]
	if list then
		for _, el in ipairs(list) do
			pcall(function()
				if el.SetValue then el:SetValue(keyName)
				elseif el.Set then el:Set(keyName) end
			end)
		end
	end
	local el2 = MainModule._SettingsKeybindEls and MainModule._SettingsKeybindEls[id]
	if el2 then
		pcall(function()
			if el2.SetValue then el2:SetValue(keyName)
			elseif el2.Set then el2:Set(keyName) end
		end)
	end
	
	pcall(function()
		local opt = Library.Options and (Library.Options[id .. "Key"] or Library.Options["SettingsKB_" .. id])
		if opt and opt.SetValue then opt:SetValue(keyName) end
	end)
	task.defer(function()
		task.wait(0.08)
		MainModule._KeybindSetting = false
	end)
end

function MainModule.HSXSetKeybind(id, keyName)
	local name = MainModule.HSXNormalizeKey(keyName)
	if MainModule.Keybinds[id] == name then
		MainModule.HSXSyncKeybindUI(id, name)
		return
	end
	MainModule.Keybinds[id] = name
	MainModule._KeybindIgnoreUntil = tick() + 0.12
	if MainModule._KeybindPress[id] then
		MainModule.HSXRegisterKeybind(id, name, MainModule._KeybindPress[id])
	end
	MainModule.HSXSyncKeybindUI(id, name)
end

MainModule._ToggleStates = MainModule._ToggleStates or {}
MainModule._KeybindMenuRefs = MainModule._KeybindMenuRefs or {}
MainModule.ConfigRegistry = MainModule.ConfigRegistry or {}

function MainModule.HSXRegisterConfig(id, getFn, setFn, kind, ref)
	if not id then return end
	MainModule.ConfigRegistry[id] = {
		get = getFn,
		set = setFn,
		kind = kind or "toggle",
		ref = ref,
	}
end

function MainModule.HSXTrackToggle(id, tog, getState, setState)
	MainModule._AllToggleRefs = MainModule._AllToggleRefs or {}
	MainModule._ConfigGetters = MainModule._ConfigGetters or {}
	MainModule._ConfigSetters = MainModule._ConfigSetters or {}
	MainModule._AllToggleRefs[id] = tog
	if getState then MainModule._ConfigGetters[id] = getState end
	if setState then MainModule._ConfigSetters[id] = setState end
end

function MainModule.HSXForceToggleVisual(tog, val)
	if not tog then return end
	val = val and true or false
	pcall(function() if tog.Set then tog:Set(val) end end)
	pcall(function() if tog.SetValue then tog:SetValue(val) end end)
	pcall(function() if tog.SetState then tog:SetState(val) end end)
	pcall(function() tog.Value = val end)
	pcall(function() if tog.Update then tog:Update(val) end end)
	pcall(function()
		if tog.UIElements and tog.UIElements.Main then
			local m = tog.UIElements.Main
			if m.Set then m:Set(val) end
		end
	end)
	pcall(function()
		if type(tog) == "table" and tog.__type == "Toggle" and tog.Set then tog:Set(val) end
	end)
end

function MainModule.HSXSetToggleUI(id, val)
	val = val and true or false
	MainModule._ToggleStates[id] = val
	if MainModule._SuppressUI then return end
	MainModule._SuppressUI = true
	local seen = {}
	local refs = {
		MainModule._KeybindToggleRefs and MainModule._KeybindToggleRefs[id],
		MainModule._AllToggleRefs and MainModule._AllToggleRefs[id],
		MainModule._KeybindMenuRefs and MainModule._KeybindMenuRefs[id] and MainModule._KeybindMenuRefs[id].tog,
	}
	if MainModule.ConfigRegistry and MainModule.ConfigRegistry[id] and MainModule.ConfigRegistry[id].ref then
		table.insert(refs, MainModule.ConfigRegistry[id].ref)
	end
	for _, tog in ipairs(refs) do
		if tog and not seen[tog] then
			seen[tog] = true
			MainModule.HSXForceToggleVisual(tog, val)
		end
	end
	MainModule._SuppressUI = false
end

function MainModule.HSXToggle(section, opts)
	local id = opts.Id or opts.Title
	local userCb = opts.Callback
	local tog
	tog = section:Toggle({
		Title = opts.Title,
		Desc = opts.Desc or opts.Tooltip,
		Value = opts.Value or false,
		Callback = function(v)
			if MainModule._SuppressUI then
				MainModule._ToggleStates[id] = v and true or false
				return
			end
			MainModule._ToggleStates[id] = v and true or false
			local ret = true
			if userCb then
				local ok, r = pcall(userCb, v)
				if ok and r == false then ret = false end
				if not ok then ret = false end
			end
			if ret == false then
				MainModule._ToggleStates[id] = false
				MainModule._SuppressUI = true
				pcall(function()
					if tog.Set then tog:Set(false) elseif tog.SetValue then tog:SetValue(false) end
				end)
				MainModule._SuppressUI = false
			end
		end
	})
	MainModule.HSXTrackToggle(id, tog,
		function() return MainModule._ToggleStates[id] == true end,
		function(v)
			MainModule._ToggleStates[id] = v and true or false
			if userCb then return userCb(v) end
			return true
		end
	)
	return tog
end

function MainModule.HSXToggleWithKey(section, toggleTitle, id, defaultKey, getState, setState, tooltip)
	MainModule._KeybindToggleTitles = MainModule._KeybindToggleTitles or {}
	MainModule._KeybindToggleTitles[id] = toggleTitle
	MainModule.Keybinds = MainModule.Keybinds or {}
	MainModule._KeybindPress = MainModule._KeybindPress or {}
	if MainModule.Keybinds[id] == nil then
		MainModule.Keybinds[id] = (defaultKey and defaultKey ~= "" and defaultKey) or "None"
	end
	local key = MainModule.Keybinds[id]
	MainModule._AllToggleRefs = MainModule._AllToggleRefs or {}
	MainModule._KeybindToggleRefs = MainModule._KeybindToggleRefs or {}
	local tip = tooltip or toggleTitle

	local tog = section:Toggle({
		Title = toggleTitle,
		Desc = tip,
		Value = false,
		Callback = function(v)
			if MainModule._SuppressUI then
				MainModule._ToggleStates[id] = v and true or false
				return
			end
			local ret = setState(v)
			if ret == false then
				MainModule._SuppressUI = true
				pcall(function()
					if tog.Set then tog:Set(false) elseif tog.SetValue then tog:SetValue(false) end
				end)
				MainModule._SuppressUI = false
				MainModule._ToggleStates[id] = false
				return
			end
			MainModule._ToggleStates[id] = v and true or false
		end
	})

	local function onPress()
		local cur = false
		pcall(function() cur = getState() end)
		local nv = not cur
		local ret = setState(nv)
		if ret == false then
			MainModule.HSXSetToggleUI(id, false)
			return
		end
		MainModule._ToggleStates[id] = nv
		MainModule.HSXSetToggleUI(id, nv)
		local now = false
		pcall(function() now = getState() end)
		
		pcall(PlayToggleSound)
	end
	MainModule._KeybindPress[id] = onPress
	MainModule.HSXRegisterKeybind(id, key, onPress)

	
	pcall(function()
		local def = (key and key ~= "" and key ~= "None") and key or "None"
		if tog.AddKeyPicker then
			local kp = tog:AddKeyPicker(id .. "Key", {
				Default = def,
				Mode = "Toggle",
				Text = toggleTitle,
				SyncToggleState = false,
				NoUI = false,
				Callback = function(v)
					if MainModule._KeybindSetting then return end
					local name = MainModule.HSXNormalizeKey(v)
					MainModule._KeybindIgnoreUntil = tick() + 0.12
					MainModule.Keybinds[id] = name
					MainModule.HSXRegisterKeybind(id, name, onPress)
				end,
				Clicked = function()
					onPress()
				end,
			})
			MainModule.KeybindUI = MainModule.KeybindUI or {}
			MainModule.KeybindUI[id] = MainModule.KeybindUI[id] or {}
			if kp then table.insert(MainModule.KeybindUI[id], kp) end
		elseif section.Keybind then
			local el = section:Keybind({
				Title = toggleTitle .. " Keybind",
				Value = def,
				Callback = function(v)
					if MainModule._KeybindSetting then return end
					local name = MainModule.HSXNormalizeKey(v)
					MainModule.Keybinds[id] = name
					MainModule.HSXRegisterKeybind(id, name, onPress)
				end
			})
			MainModule.KeybindUI = MainModule.KeybindUI or {}
			MainModule.KeybindUI[id] = MainModule.KeybindUI[id] or {}
			if el then table.insert(MainModule.KeybindUI[id], el) end
		end
	end)

	MainModule._KeybindToggleRefs[id] = tog
	MainModule._AllToggleRefs[id] = tog
	MainModule.HSXRegisterConfig(id,
		function()
			local ok, v = pcall(getState)
			if ok then return v and true or false end
			return MainModule._ToggleStates[id] == true
		end,
		function(v)
			local r = setState(v)
			MainModule._ToggleStates[id] = (r ~= false) and (v and true or false) or false
			MainModule.HSXSetToggleUI(id, MainModule._ToggleStates[id])
			return r
		end,
		"toggle", tog
	)
	return tog
end

function MainModule.HSXCollapse(el, collapsed)
	if not el then return end
	local show = not collapsed
	
	if type(el) == "table" then
		local ok = pcall(function()
			if type(el.SetVisible) == "function" then
				el:SetVisible(show)
			elseif el.Visible ~= nil then
				el.Visible = show
			end
		end)
		if ok then return end
	end
	if typeof(el) == "Instance" and el:IsA("GuiObject") then
		el.Visible = show
	end
end

function MainModule.HSXShowHide(el, vis)
	MainModule.HSXCollapse(el, not vis)
end

MainModule._SliderStates = MainModule._SliderStates or {}
MainModule._SliderRefs = MainModule._SliderRefs or {}
MainModule._SliderSetters = MainModule._SliderSetters or {}

MainModule._SliderLinks = MainModule._SliderLinks or {}

function MainModule.HSXBindSlider(section, opts)
	local sid = opts.Id or opts.Title
	local holder = { el = nil, value = opts.defaultValue or (opts.Value and opts.Value.Default) or 0, id = sid, parentId = opts.ParentId }
	MainModule._SliderStates[sid] = holder.value
	local cfg = {
		Title = opts.Title,
		Value = {
			Min = opts.Value.Min,
			Max = opts.Value.Max,
			Default = holder.value or opts.Value.Default
		},
		Step = opts.Step,
		Callback = function(v)
			holder.value = v
			MainModule._SliderStates[sid] = v
			if opts.Callback then opts.Callback(v) end
		end
	}
	holder.el = section:Slider(cfg)
	MainModule._SliderRefs[sid] = holder
	MainModule._SliderSetters[sid] = opts.Callback
	if opts.ParentId then
		MainModule._SliderLinks[opts.ParentId] = MainModule._SliderLinks[opts.ParentId] or {}
		table.insert(MainModule._SliderLinks[opts.ParentId], holder)
	end
	MainModule.HSXRegisterConfig(sid,
		function() return MainModule._SliderStates[sid] end,
		function(v)
			MainModule._SliderStates[sid] = v
			holder.value = v
			if opts.Callback then pcall(opts.Callback, v) end
			pcall(function()
				if holder.el then
					if holder.el.SetValue then holder.el:SetValue(v)
					elseif holder.el.Set then holder.el:Set(v) end
				end
			end)
		end,
		"slider", holder)
	
	pcall(function()
		if holder.el and holder.el.SetVisible then holder.el:SetVisible(false) end
	end)
	holder.ensure = function(show)
		show = show and true or false
		pcall(function()
			if holder.el and holder.el.SetVisible then
				holder.el:SetVisible(show)
			elseif holder.el then
				MainModule.HSXCollapse(holder.el, not show)
			end
		end)
		if show and holder.el then
			pcall(function()
				if holder.el.SetValue then holder.el:SetValue(holder.value)
				elseif holder.el.Set then holder.el:Set(holder.value) end
			end)
		end
	end
	return holder
end

function MainModule.UISlider(section, opts)
	local id = opts.Id or opts.Title
	local userCb = opts.Callback
	local def = opts.Default or (opts.Value and opts.Value.Default) or 0
	MainModule._SliderStates[id] = def
	local el = section:Slider({
		Title = opts.Title,
		Desc = opts.Desc,
		Value = opts.Value or {Min=0,Max=100,Default=def},
		Step = opts.Step or 1,
		Callback = function(v)
			MainModule._SliderStates[id] = v
			if userCb then pcall(userCb, v) end
		end
	})
	MainModule.HSXRegisterConfig(id,
		function() return MainModule._SliderStates[id] end,
		function(v)
			MainModule._SliderStates[id] = v
			if userCb then pcall(userCb, v) end
			pcall(function() if el and el.Set then el:Set(v) end end)
		end,
		"slider", el)
	return el
end

function MainModule.UIInput(section, opts)
	local id = opts.Id or opts.Title
	local userCb = opts.Callback
	MainModule._InputStates = MainModule._InputStates or {}
	MainModule._InputStates[id] = opts.Value or ""
	local el = section:Input({
		Title = opts.Title,
		Desc = opts.Desc,
		Value = opts.Value or "",
		Callback = function(v)
			MainModule._InputStates[id] = v
			if userCb then pcall(userCb, v) end
		end
	})
	MainModule.HSXRegisterConfig(id,
		function() return MainModule._InputStates[id] end,
		function(v)
			MainModule._InputStates[id] = v
			if userCb then pcall(userCb, v) end
			pcall(function() if el and el.Set then el:Set(v) end end)
		end,
		"value", el)
	return el
end

function MainModule.UIDropdown(section, opts)
	local id = opts.Id or opts.Title
	local userCb = opts.Callback
	MainModule._DropdownStates = MainModule._DropdownStates or {}
	MainModule._DropdownStates[id] = opts.Value
	local el = section:Dropdown({
		Title = opts.Title,
		Desc = opts.Desc,
		Values = opts.Values,
		Value = opts.Value,
		Callback = function(v)
			MainModule._DropdownStates[id] = v
			if userCb then pcall(userCb, v) end
		end
	})
	MainModule.HSXRegisterConfig(id,
		function() return MainModule._DropdownStates[id] end,
		function(v)
			MainModule._DropdownStates[id] = v
			if userCb then pcall(userCb, v) end
			pcall(function() if el and el.Set then el:Set(v) elseif el.Select then el:Select(v) end end)
		end,
		"value", el)
	return el
end

function MainModule.UIToggle(section, opts)
	local id = opts.Id or (opts.Title and tostring(opts.Title):gsub("%s+", "") or ("T" .. tostring(math.random(1,99999))))
	local userCb = opts.Callback
	local tog
	tog = section:Toggle({
		Title = opts.Title,
		Desc = opts.Desc or opts.Tooltip,
		Value = opts.Value or false,
		Callback = function(v)
			if MainModule._SuppressUI then
				MainModule._ToggleStates[id] = v and true or false
				return
			end
			MainModule._ToggleStates[id] = v and true or false
			if userCb then
				local ok, r = pcall(userCb, v)
				if ok and r == false then
					MainModule._ToggleStates[id] = false
					MainModule._SuppressUI = true
					pcall(function() if tog.Set then tog:Set(false) elseif tog.SetValue then tog:SetValue(false) end end)
					MainModule._SuppressUI = false
				end
			end
		end
	})
	MainModule._AllToggleRefs = MainModule._AllToggleRefs or {}
	MainModule._ConfigGetters = MainModule._ConfigGetters or {}
	MainModule._ConfigSetters = MainModule._ConfigSetters or {}
	MainModule._AllToggleRefs[id] = tog
	local getFn = function() return MainModule._ToggleStates[id] == true end
	local setFn = function(v)
		v = v and true or false
		MainModule._ToggleStates[id] = v
		if userCb then pcall(userCb, v) end
		MainModule._SuppressUI = true
		pcall(function()
			if tog.Set then tog:Set(v) elseif tog.SetValue then tog:SetValue(v) end
		end)
		MainModule._SuppressUI = false
	end
	MainModule._ConfigGetters[id] = getFn
	MainModule._ConfigSetters[id] = setFn
	MainModule.HSXRegisterConfig(id, getFn, setFn, "toggle", tog)
	return tog
end

do
	local t = Window:Tab({ Title = "Games", Icon = "gamepad-2", Desc = "All minigame features" })

	local s = t:Section({ Title = "Red Light Green Light", Icon = "traffic-cone", Opened = true })
	MainModule.UIToggle(s, { Id = "RemoveInjury", Title = "Remove Injury", Value = false, Callback = function(v) sc(MainModule.toggle_remove_injury, v) end })
	MainModule.UIDropdown(s, {
		Title = "End Corner",
		Desc = "Left Corner or Right Corner for Teleport to End",
		Values = {"Left Corner", "Right Corner"},
		Value = "Left Corner",
		Callback = function(v)
			MainModule.RLGLEndCorner = v
		end
	})
	s:Button({ Title = "Teleport to End", Callback = function() sc(MainModule.rlgl_tp_end) end })
	MainModule.UIToggle(s, { Id = "GodMode", Title = "God Mode", Desc = "Teleports you high up to avoid being shooted by bullets", Value = false, Callback = function(v) sc(MainModule.toggle_god_mode, v) end })
	MainModule.UIToggle(s, { Id = "AutoStopRedLight", Title = "Auto Stop on Red Light", Desc = "Automatically freezes your character when Red Light is active to avoid getting shot, and unfreezes when Green Light is active", Value = false, Callback = function(v) sc(MainModule.toggle_rlgl_stop, v) end })

	local s = t:Section({ Title = "Lights Out", Icon = "moon", Opened = true })
	MainModule.UIToggle(s, {
		Id = "LightsOutSafezone",
		Title = "Safezone TP",
		Desc = "Teleports you to the safezone where you cannot get hit from other players, after disabling you will be returned to your position (Also works in hns as a hider).",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_lights_out_safezone, v)
		end
	})

	local s = t:Section({ Title = "Dalgona & Pentathlon", Icon = "cookie", Opened = true })
	MainModule.UIToggle(s, { Id = "FreeLighter", Title = "Free Lighter", Desc = "Gives you a lighter for the Dalgona game", Value = false, Callback = function(v) sc(MainModule.dalgona_lighter, v) end })
    MainModule.UIToggle(s, { Id = "AutoRelaxBreathing", Title = "Auto Relax Breathing", Desc = "Auto Q to reduce fear in Dalgona", Value = false, Callback = function(v) sc(MainModule.toggle_dalgona_auto_relax, v) end })
	s:Button({ Title = "Anti Crack", Desc = "Fix/create Dalgona click parts on outlines", Callback = function()
		sc(MainModule.AntiCrack)
	end })
	s:Button({ Title = "Complete Dalgona Shape", Callback = function() sc(MainModule.dalgona_complete_shape) end })

MainModule.UIToggle(s, { Id = "AutoDdakji", Title = "Auto Ddakji", Desc = "Auto throw Ddakji with perfect coords by using remote", Value = false, Callback = function(v) sc(MainModule.toggle_auto_ddakji, v) end })
MainModule.UIToggle(s, { Id = "AutoFlyingStone", Title = "Auto Flying Stone", Desc = "Auto throw rock in perfect zone by using remote", Value = false, Callback = function(v) sc(MainModule.toggle_auto_flying_stone, v) end })
MainModule.UIToggle(s, { Id = "AutoGonggi", Title = "Auto Gonggi", Desc = "Auto grab all pieces by using remote", Value = false, Callback = function(v) sc(MainModule.toggle_auto_gonggi, v) end })
MainModule.UIToggle(s, { Id = "AutoSpinningTop", Title = "Auto Spinning Top", Desc = "Auto spin and aim by using remote", Value = false, Callback = function(v) sc(MainModule.toggle_auto_spinning_top, v) end })
MainModule.UIToggle(s, { Id = "AutoJegi", Title = "Auto Jegi", Desc = "Auto completes jegi by using remote", Value = false, Callback = function(v) sc(MainModule.toggle_auto_jegi, v) end })

	local s = t:Section({ Title = "Hide And Seek", Icon = "eye-off", Opened = true })
	MainModule.UIToggle(s, {
		Id = "FasterSprint",
		Title = "Infinite Faster Sprint + Stamina",
		Desc = "Allows you to use infinite faster sprint for hider with infinite stamina",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_faster_sprint, v)
		end
	})
	MainModule.UIToggle(s, {
		Id = "KillHiders",
		Title = "Kill Hiders",
		Desc = "Attach + Face + Noclip + Spikes Kill until 0 hiders (check every 5s)",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_kill_hiders, v)
		end
	})
	s:Button({ Title = "Teleport To Spawn", Callback = function() sc(MainModule.teleport_to_spawn) end })
	s:Button({ Title = "Teleport To Hider", Callback = function() sc(MainModule.teleport_to_hider) end })
	MainModule.Keybinds = MainModule.Keybinds or {}
	MainModule._KeybindPress = MainModule._KeybindPress or {}
	if MainModule.Keybinds.TpHider == nil then MainModule.Keybinds.TpHider = "None" end
	MainModule._KeybindPress.TpHider = function()
		sc(MainModule.teleport_to_hider)
	end
	MainModule.HSXRegisterKeybind("TpHider", MainModule.Keybinds.TpHider, MainModule._KeybindPress.TpHider)
	pcall(function()
		s:Keybind({
			Id = "TpHiderKey",
			Title = "Tp Hider Keybind",
			Value = MainModule.Keybinds.TpHider or "None",
			NoUI = true,
			Callback = function(v)
				local name = MainModule.HSXNormalizeKey(v)
				MainModule.Keybinds.TpHider = name
				MainModule.HSXRegisterKeybind("TpHider", name, MainModule._KeybindPress.TpHider)
				MainModule.HSXSyncKeybindUI("TpHider", name)
			end
		})
	end)
	s:Button({ Title = "Teleport To Seeker", Callback = function() sc(MainModule.teleport_to_seeker) end })
	if MainModule.Keybinds.TpSeeker == nil then MainModule.Keybinds.TpSeeker = "None" end
	MainModule._KeybindPress.TpSeeker = function()
		sc(MainModule.teleport_to_seeker)
	end
	MainModule.HSXRegisterKeybind("TpSeeker", MainModule.Keybinds.TpSeeker, MainModule._KeybindPress.TpSeeker)
	pcall(function()
		s:Keybind({
			Id = "TpSeekerKey",
			Title = "Tp Seeker Keybind",
			Value = MainModule.Keybinds.TpSeeker or "None",
			NoUI = true,
			Callback = function(v)
				local name = MainModule.HSXNormalizeKey(v)
				MainModule.Keybinds.TpSeeker = name
				MainModule.HSXRegisterKeybind("TpSeeker", name, MainModule._KeybindPress.TpSeeker)
				MainModule.HSXSyncKeybindUI("TpSeeker", name)
			end
		})
	end)
	MainModule.UIToggle(s, { Id = "AutoEscape", Title = "Auto Escape", Desc = "Automatically teleports to every dropped keys and after to escape door and automatically escapes", Value = false, Callback = function(v) sc(MainModule.toggle_auto_escape, v) end })
	MainModule.UIToggle(s, { Id = "AutoPickupKeys", Title = "Auto Pickup Keys", Desc = "Automatically teleports to all dropped keys for hider", Value = false, Callback = function(v) sc(MainModule.toggle_auto_pickup, v) end })
	MainModule.UIToggle(s, { Id = "ESPDroppedKeys", Title = "ESP Dropped Keys", Desc = "Shows all dropped keys for hider", Value = false, Callback = function(v) sc(MainModule.toggle_key_esp, v) end })
	MainModule.UIToggle(s, { Id = "ESPExitDoors", Title = "ESP Exit Doors", Desc = "Shows all exit doors", Value = false, Callback = function(v) sc(MainModule.toggle_exit_door_esp, v) end })
	MainModule.UIToggle(s, { Id = "ESPSpikes", Title = "ESP Spikes", Desc = "Highlights all spikes on map (black)", Value = false, Callback = function(v) sc(MainModule.toggle_spikes_esp, v) end })
	MainModule.HSXToggleWithKey(s, "Auto Dodge", "AutoDodge", "None",
		function() return MainModule.AutoDodge and MainModule.AutoDodge.Enabled end,
		function(v) return MainModule.toggle_auto_dodge(v) end,
		"Automatically uses DODGE! when being attacked, You need to use DODGE! before enable")
	MainModule.UIToggle(s, { Id = "SpikesKill", Title = "Spikes Kill", Desc = "Teleport players to spikes by animation", Value = false, Callback = function(v) sc(MainModule.toggle_spikes_kill, v) end })
	MainModule.UIToggle(s, { Id = "TeleportToSpikes", Title = "Teleport To Spikes", Desc = "Teleports you to random spikes, to prevent die you need to disable spikes first", Value = false, Callback = function(v) sc(MainModule.toggle_spikes_platform_teleport, v) end })
	s:Button({ Title = "Teleport Random Exit", Callback = function() sc(MainModule.teleport_random_exit) end })
	MainModule.UIToggle(s, { Id = "AntiSpikes", Title = "Anti-Spikes", Desc = "Creates a platform above spikes to avoid being killed.", Value = false, Callback = function(v) sc(MainModule.toggle_anti_spikes, v) end })

	local s = t:Section({ Title = "Tug Of War", Icon = "swords", Opened = true })
MainModule.UIToggle(s, { Id = "AntiMissQTE", Title = "Anti Miss QTE", Desc = "never miss Tug QTE", Value = false, Callback = function(v) sc(MainModule.toggle_tug_of_war_auto_qte_miss, v) end })
MainModule.UIToggle(s, { Id = "AutoPullQTE", Title = "Auto Pull", Desc = "auto press when in zone", Value = false, Callback = function(v) sc(MainModule.toggle_tug_of_war_auto_pull, v) end })
MainModule.UIToggle(s, { Id = "UltraFastPullQTE", Title = "Ultra Fast Auto Pull", Desc = "rage mode, its obvious but wins in 6-7 secs", Value = false, Callback = function(v) sc(MainModule.toggle_tug_of_war_ultra_fast_pull, v) end })

	local s = t:Section({ Title = "Jump Rope", Icon = "activity", Opened = true })
	MainModule.UIToggle(s, { Id = "AntiFall", Title = "Anti Fall", Desc = "Creates platform to prevent falling", Value = false, Callback = function(v) sc(MainModule.toggle_jump_rope_anti_fall, v) end })
	MainModule.UIToggle(s, { Id = "AntiHit", Title = "AntiHit", Desc = "Avoid rope hits", Value = false, Callback = function(v) sc(MainModule.toggle_jump_rope_anti_hit, v) end })
	MainModule.UIToggle(s, { Id = "FakeBalance", Title = "Fake Balance", Desc = "Fake balance animation", Value = false, Callback = function(v) sc(MainModule.toggle_jump_rope_fake_balance, v) end })
	MainModule.UIToggle(s, { Id = "FreezeRope", Title = "Freeze Rope", Desc = "Freeze jump rope", Value = false, Callback = function(v) sc(MainModule.toggle_freeze_rope, v) end })
	s:Button({ Title = "Remove Balance Mini Game", Callback = function() sc(MainModule.remove_balance_mini_game) end })
	s:Button({ Title = "Remove Rope", Callback = function() sc(MainModule.jr_delete_rope) end })
	s:Button({ Title = "Teleport to Start", Callback = function() sc(MainModule.jr_tp_start) end })
	s:Button({ Title = "Teleport to End", Callback = function() sc(MainModule.jr_tp_end) end })

	local s = t:Section({ Title = "Glass Bridge", Icon = "layers", Opened = true })
	MainModule.UIToggle(s, { Id = "GlassESP", Title = "Glass ESP", Desc = "Green = safe, Yellow = delayed, Red = breakable", Value = false, Callback = function(v) sc(MainModule.toggle_glass_esp, v) end })
	MainModule.UIToggle(s, { Id = "AntiBreak", Title = "AntiBreak Glass", Desc = "Prevents glass from breaking", Value = false, Callback = function(v) sc(MainModule.toggle_anti_break, v) end })
	MainModule.UISlider(s, { Title = "ESP Transparency", Value = {Min=0,Max=100,Default=40}, Step=1, Callback = function(v) sc(MainModule.set_glass_esp_transparency, v) end })
	s:Button({ Title = "Teleport to End", Callback = function() sc(MainModule.gb_tp_end) end })
	MainModule.UIToggle(s, { Id = "HCGlassESP", Title = "HC Glass ESP", Desc = "Highlight correct glass ( red breakable , green = safe _", Value = false, Callback = function(v) sc(MainModule.toggle_hc_glass_esp, v) end })

	local s = t:Section({ Title = "Mingle", Icon = "users", Opened = true })
	MainModule.UIToggle(s, { Id = "VoidKill", Title = "Void Kill", Desc = "Teleports you into the void upon using choke on someone and after tps you back", Value = false, Callback = function(v) sc(MainModule.toggle_mingle_void_kill, v) end })

	local s = t:Section({ Title = "Last Dinner", Icon = "utensils", Opened = true })
	MainModule.UIToggle(s, { Id = "ZoneKill", Title = "Zone Kill", Desc = "Brings enemy into players lobby where zone is killing them, after it you will be returned to your position. Also requires knife and land backstab", Value = false, Callback = function(v) sc(MainModule.toggle_zone_kill, v) end })
	s:Button({ Title = "Teleport To Safe Spot", Callback = function() sc(MainModule.teleport_to_safe_spot) end })

	local s = t:Section({ Title = "Sky Squid", Icon = "cloud", Opened = true })
	MainModule.UIToggle(s, { Id = "AutoTeleportOnFall", Title = "Auto Teleport on Fall", Desc = "Teleport u to the platform up when fall so u cant fall", Value = false, Callback = function(v) sc(MainModule.toggle_auto_respawn_on_fall, v) end })
	MainModule.UIToggle(s, { Title = "Void Kill", Value = false, Callback = function(v) sc(MainModule.toggle_void_kill, v) end })
	MainModule.UIToggle(s, { Title = "Anti Fall", Value = false, Callback = function(v) sc(MainModule.toggle_sky_squid_anti_fall, v) end })

	local s = t:Section({ Title = "Rebel", Icon = "shield", Opened = true })
	MainModule.UIToggle(s, { Id = "InstantKillGuards", Title = "Instant Kill Guards", Desc = "Instantly kills all npcs guards, if you want to kill players guards, use autoshoot from guards tab", Value = false, Callback = function(v)
		if MainModule.toggle_rebel_v2 then sc(MainModule.toggle_rebel_v2, v) else sc(MainModule.toggle_rebel, v) end
	end })
	MainModule.UISlider(s, { Title = "Shots Per Tick", Value = {Min=1,Max=50,Default=10}, Step=1, Callback = function(v)
		if MainModule.set_rebel_shots_per_tick then MainModule.set_rebel_shots_per_tick(v)
		elseif MainModule.RebelShotsPerTick then MainModule.RebelShotsPerTick = v end
	end })
end

do
	local t = Window:Tab({ Title = "Powers", Icon = "zap", Desc = "Fake powers and power ESP" })
	local fp = t:Section({ Title = "Fake Powers", Icon = "sparkles", Opened = true })
	MainModule.UIToggle(fp, {
		Id = "FakeUltraInstinct",
		Title = "Give Fake Ultra Instinct",
		Desc = "Give visual ultra instinct ability.",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_fake_ultra_instinct, v)
		end
	})
	MainModule.UIToggle(fp, {
		Id = "FakeLGPowerHold",
		Title = "Give Fake LG PowerHold",
		Desc = "Load Fake LG PowerHold",
		Value = false,
		Callback = function(enabled)
			MainModule.FakeLGPowerHoldEnabled = enabled and true or false
			if enabled then
				pcall(function()
					loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/95b3b990b427dd37b00222b35e7a6e5d.lua"))()
				end)
				HSXNotify("Fake LG PowerHold", "Loaded", 0.9)
			end
		end
	})
	MainModule.UIToggle(fp, {
		Id = "FakeLightningAwakening",
		Title = "Give Fake Lightning Awakening",
		Desc = "Gives LIGHTNING AWAKENING tool",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_fake_lightning_awakening, v)
		end
	})
	MainModule.UIToggle(fp, {
		Id = "Quicksilver",
		Title = "Free Quicksilver",
		Desc = "Gives Free Quicksilver power",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_quicksilver, v)
		end
	})
	MainModule.UIToggle(fp, {
		Id = "ParkourArtist",
		Title = "Parkour Artist",
		Desc = "Double jump + C dash with anims/FX",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_parkour_artist, v)
		end
	})
	local pdDist, pdDur, pdCd, pdCh
	MainModule.UIToggle(fp, {
		Id = "PhantomDash",
		Title = "Phantom Dash",
		Desc = "Phantom step ability (mobile and PC)",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_phantom_dash, v)
			if pdDist then pdDist.ensure(v) end
			if pdDur then pdDur.ensure(v) end
			if pdCd then pdCd.ensure(v) end
			if pdCh then pdCh.ensure(v) end
		end
	})
	pdDist = MainModule.HSXBindSlider(fp, {ParentId="PhantomDash", Title="Dash Distance", Value={Min=5,Max=50,Default=15}, Step=1, defaultValue=15, Callback=function(v) sc(MainModule.set_phantom_dash_distance, v) end})
	pdDur = MainModule.HSXBindSlider(fp, {ParentId="PhantomDash", Title="Dash Duration", Value={Min=10,Max=100,Default=25}, Step=1, defaultValue=25, Callback=function(v) sc(MainModule.set_phantom_dash_duration, v) end})
	pdCd = MainModule.HSXBindSlider(fp, {ParentId="PhantomDash", Title="Charge Cooldown", Value={Min=0.5,Max=5,Default=1}, Step=0.1, defaultValue=1, Callback=function(v) sc(MainModule.set_phantom_dash_cooldown, v) end})
	pdCh = MainModule.HSXBindSlider(fp, {ParentId="PhantomDash", Title="Max Charges", Value={Min=1,Max=5,Default=2}, Step=1, defaultValue=2, Callback=function(v) sc(MainModule.set_phantom_dash_max_charges, v) end})
	local pw = t:Section({ Title = "Powers", Icon = "eye", Opened = true })
	MainModule.UIToggle(pw, {
		Id = "ESPPowers",
		Title = "Powers ESP",
		Desc = "shows power name above player head",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_esp_powers, v)
		end
	})
	MainModule.UIToggle(pw, {
		Id = "AutoUltraInstinct",
		Title = "Auto Ultra Instinct",
		Desc = "Auto Dodge with Real Ultra Instinct",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_auto_ultra_instinct, v)
		end
	})
end

do
	local t = Window:Tab({ Title = "Combat", Icon = "swords", Desc = "PVP / ESP / attach" })
	local s = t:Section({ Title = "Combat", Icon = "swords", Opened = true })
	MainModule.HSXToggleWithKey(s, "Face Target", "FaceTarget", "None",
		function() return MainModule.FaceTargetModule and MainModule.FaceTargetModule.Enabled end,
		function(v) sc(MainModule.toggle_face_target, v); return true end,
		"Always face target")
	MainModule.UIToggle(s, { Id = "Desync", Title = "Desync", Desc = "Network desync (good executor required)", Value = false, Callback = function(v) sc(MainModule.toggle_desync, v) end })
	MainModule.UIToggle(s, {
    Id = "PlayersESP",
    Title = "Players ESP",
    Desc = "ESP for all non-dead players.",
    Value = false,
    Callback = function(v)
        MainModule.PlayerESPEnabled = v and true or false
        sc(MainModule.toggle_player_esp, v)
    end
})

MainModule.UIDropdown(s, {
    Title = "ESP Mode",
    Desc = "New or Old ESP style",
    Values = {"New", "Old"},
    Value = "New",
    Callback = function(v)
        sc(MainModule.set_esp_mode, v)
    end
})

MainModule.UIToggle(s, {
    Id = "ESPRGBMode",
    Title = "ESP RGB Mode",
    Desc = "Rainbow ESP box",
    Value = false,
    Callback = function(v)
        MainModule.ESPRGBEnabled = v and true or false
        sc(MainModule.toggle_esprgb, v)
        PlayToggleSound()
    end
})
	MainModule.HSXToggleWithKey(s, "AntiStun", "AntiStun", "None",
		function() return MainModule.RemoveStunEnabled end,
		function(v) sc(MainModule.toggle_remove_stun, v); return true end,
		"Remove stun effects")
end

do
	
MainModule.BiggestThreatHighlight = nil
MainModule.BiggestThreatConnection = nil
MainModule.BiggestThreatEnabled = false

MainModule._GetPlayerWins = function(plr)
    local wins = 0
    pcall(function()
        local v = plr:GetAttribute("_GameWins") or plr:GetAttribute("GameWins") or plr:GetAttribute("Wins")
        if type(v) == "number" then wins = v end
    end)
    pcall(function()
        local ls = plr:FindFirstChild("leaderstats")
        if ls then
            local w = ls:FindFirstChild("Wins") or ls:FindFirstChild("wins") or ls:FindFirstChild("Victories")
            if w and typeof(w.Value) == "number" then
                wins = math.max(wins, w.Value)
            end
        end
    end)
    pcall(function()
        local vals = plr:FindFirstChild("Values")
        if vals then
            local w = vals:FindFirstChild("Wins") or vals:FindFirstChild("_GameWins")
            if w and typeof(w.Value) == "number" then
                wins = math.max(wins, w.Value)
            end
        end
    end)
    return wins
end

MainModule.FindBiggestThreat = function()
    local best, bestWins = nil, -1
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local w = MainModule._GetPlayerWins(plr)
            if w > bestWins then
                bestWins = w
                best = plr
            end
        end
    end
    return best, bestWins
end

MainModule.clear_biggest_threat = function()
    if MainModule.BiggestThreatHighlight then
        pcall(function() MainModule.BiggestThreatHighlight:Destroy() end)
        MainModule.BiggestThreatHighlight = nil
    end
    if MainModule.BiggestThreatConnection then
        pcall(function() MainModule.BiggestThreatConnection:Disconnect() end)
        MainModule.BiggestThreatConnection = nil
    end
end

MainModule.toggle_biggest_threat = function(enabled)
    enabled = enabled and true or false
    MainModule.BiggestThreatEnabled = enabled
    MainModule.clear_biggest_threat()
    if not enabled then
        PlayToggleSound()
        return true
    end
    local function apply()
        local target, wins = MainModule.FindBiggestThreat()
        MainModule.clear_biggest_threat()
        if not target then
            HSXNotify("Biggest Threat", "No players found", 0.9)
            return
        end
        HSXNotify("Biggest Threat", tostring(target.DisplayName or target.Name) .. " — " .. tostring(wins) .. " wins", 1.5)
        local char = target.Character
        if char then
            local h = Instance.new("Highlight")
            h.Name = "HSX_BiggestThreat"
            h.FillColor = Color3.fromRGB(255, 50, 50)
            h.OutlineColor = Color3.fromRGB(255, 200, 0)
            h.FillTransparency = 0.55
            h.OutlineTransparency = 0
            h.Adornee = char
            h.Parent = char
            MainModule.BiggestThreatHighlight = h
        end
        MainModule.BiggestThreatConnection = target.CharacterAdded:Connect(function(c)
            if not MainModule.BiggestThreatEnabled then return end
            task.wait(0.2)
            if MainModule.BiggestThreatHighlight then
                pcall(function() MainModule.BiggestThreatHighlight:Destroy() end)
            end
            local h = Instance.new("Highlight")
            h.Name = "HSX_BiggestThreat"
            h.FillColor = Color3.fromRGB(255, 50, 50)
            h.OutlineColor = Color3.fromRGB(255, 200, 0)
            h.FillTransparency = 0.55
            h.OutlineTransparency = 0
            h.Adornee = c
            h.Parent = c
            MainModule.BiggestThreatHighlight = h
        end)
    end
    apply()
    task.spawn(function()
        while MainModule.BiggestThreatEnabled do
            task.wait(8)
            if MainModule.BiggestThreatEnabled then
                apply()
            end
        end
    end)
    PlayToggleSound()
    return true
end


local t = Window:Tab({ Title = "Players", Icon = "users", Desc = "Teleport, spectate & stats" })
	local s = t:Section({ Title = "Players", Icon = "users", Opened = true })
	MainModule.UIToggle(s, {
		Id = "BiggestThreat",
		Title = "Biggest Threat",
		Desc = "Highlight player with most wins on server",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_biggest_threat, v)
		end
	})
	local selected = nil
	local selectedPlayer = nil
	local function list()
		local r = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then table.insert(r, p.Name) end
		end
		if #r == 0 then table.insert(r, "No players") end
		return r
	end
	local drop = MainModule.UIDropdown(s, {
		Title = "Select Player",
		Desc = "Pick a player to TP / spectate / view stats",
		Values = list(),
		Value = "No players",
		Callback = function(v)
			selected = v
			selectedPlayer = Players:FindFirstChild(v)
			_G.HSX_SelectedPlayer = selectedPlayer
			updateStatsDisplay(selectedPlayer)
		end
	})
	s:Button({ Title = "Refresh", Desc = "Refresh player list", Callback = function() pcall(function() drop:Refresh(list()) end) end })
	s:Button({ Title = "Teleport to Selected", Desc = "TP to selected player", Callback = function()
		local p = selected and Players:FindFirstChild(selected)
		if p then sc(MainModule.teleport_to_player, p) end
	end })
	MainModule._KeybindPress.TpSelected = function()
		local p = selected and Players:FindFirstChild(selected)
		if p then sc(MainModule.teleport_to_player, p); HSXNotify("Teleport", "To " .. tostring(selected), 0.8)
		else HSXNotify("Teleport", "No player selected", 0.8) end
	end
	MainModule.Keybinds.TpSelected = MainModule.Keybinds.TpSelected or "None"
	MainModule.HSXRegisterKeybind("TpSelected", MainModule.Keybinds.TpSelected, MainModule._KeybindPress.TpSelected)
	s:Button({ Title = "Spectate Selected", Desc = "Spectate selected player", Callback = function()
		local p = selected and Players:FindFirstChild(selected)
		if p then sc(MainModule.spectate_player, p) end
	end })
	s:Button({ Title = "Stop Spectating", Callback = function() sc(MainModule.stop_spectate) end })
	s:Button({ Title = "Teleport to Nearest", Callback = function() sc(MainModule.teleportToNearest) end })
	MainModule.Keybinds = MainModule.Keybinds or {}
	MainModule._KeybindPress = MainModule._KeybindPress or {}
	MainModule.Keybinds.TpNearest = MainModule.Keybinds.TpNearest or "G"
	MainModule._KeybindPress.TpNearest = function()
		sc(MainModule.teleportToNearest)
	end
	MainModule.HSXRegisterKeybind("TpNearest", MainModule.Keybinds.TpNearest, MainModule._KeybindPress.TpNearest)
	pcall(function()
		local defKey = MainModule.Keybinds.TpNearest or "G"
		if defKey == "" or defKey == "None" then defKey = "G" end
		MainModule.Keybinds.TpNearest = defKey
		MainModule.HSXRegisterKeybind("TpNearest", defKey, MainModule._KeybindPress.TpNearest)
		local label = nil
		local raw = s._raw or s
		pcall(function()
			if type(raw.AddLabel) == "function" then
				label = raw:AddLabel("Tp Nearest Keybind")
			end
		end)
		local kp
		if label and label.AddKeyPicker then
			kp = label:AddKeyPicker("TpNearestKey", {
				Default = defKey,
				Mode = "Hold",
				Text = "Tp Nearest",
				NoUI = false,
				Callback = function(v)
					local name = MainModule.HSXNormalizeKey(v)
					if not name or name == "" then return end
					MainModule.Keybinds.TpNearest = name
					MainModule.HSXRegisterKeybind("TpNearest", name, MainModule._KeybindPress.TpNearest)
				end,
				Changed = function(v)
					local name = MainModule.HSXNormalizeKey(v)
					if not name or name == "" then return end
					MainModule.Keybinds.TpNearest = name
					MainModule.HSXRegisterKeybind("TpNearest", name, MainModule._KeybindPress.TpNearest)
				end,
			})
		else
			s:Keybind({
				Id = "TpNearestKey",
				Title = "Tp Nearest Keybind",
				Value = defKey,
				NoUI = false,
				Callback = function(v)
					local name = MainModule.HSXNormalizeKey(v)
					if not name or name == "" then return end
					MainModule.Keybinds.TpNearest = name
					MainModule.HSXRegisterKeybind("TpNearest", name, MainModule._KeybindPress.TpNearest)
				end
			})
		end
		if kp then
			MainModule.KeybindUI = MainModule.KeybindUI or {}
			MainModule.KeybindUI.TpNearest = MainModule.KeybindUI.TpNearest or {}
			table.insert(MainModule.KeybindUI.TpNearest, kp)
		end
	end)
    MainModule.UIToggle(s, { Id = "SpectateMode", Title = "Spectate Mode", Desc = "Allows spectating after winning a game", Value = false, Callback = function(v)
    sc(MainModule.toggle_spectate_mode, v)
end })

	local st = t:Section({ Title = "Player Stats", Icon = "bar-chart-3", Opened = true })
	MainModule._PlayerStatLabels = {}
	for _, key in ipairs({"Wins","Money","Power","GuardPower","Level","PowerSpins","GuardSpins","Robux","VIP","PermGuard","Lighter"}) do
		local p = st:Paragraph({ Title = key .. ": -" })
		MainModule._PlayerStatLabels[key] = p
	end
end

do
	local t = Window:Tab({ Title = "Guards", Icon = "shield", Desc = "Gun tools" })
	local s = t:Section({ Title = "Guns", Icon = "crosshair", Opened = true })
	MainModule.UIToggle(s, {
		Id = "NoRecoil",
		Title = "No Recoil",
		Desc = "removes recoil effect on all weapons",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_no_recoil, v)
		end
	})
	MainModule.UIToggle(s, { Id = "RapidFire", Title = "Rapid Fire", Desc = "Remove fire rate limit", Value = false, Callback = function(v) sc(MainModule.toggle_rapid_fire, v) end })
	MainModule.HSXToggleWithKey(s, "Infinite Ammo", "InfAmmo", "None",
		function() return MainModule.InfiniteAmmoEnabled end,
		function(v) sc(MainModule.toggle_infinite_ammo, v); return true end)
	MainModule.UIToggle(s, { Id = "AutoShoot", Title = "AutoShoot", Desc = "Auto shoots all targets that red highlited, also works if you want to kill players guards in rebel", Value = false, Callback = function(v)
		MainModule.AutoShootEnabled = v and true or false
		if MainModule.EffectShooter then MainModule.EffectShooter.Enabled = v end
		sc(MainModule.toggle_effect_shooter, v)
	end })
end

do
	local t = Window:Tab({ Title = "Main", Icon = "warehouse", Desc = "Movement & misc" })
	local b = t:Section({ Title = "Boosts", Icon = "zap", Opened = true })
	MainModule.UIToggle(b, { Id = "FreeDash", Title = "unlock faster sprint level 6", Desc = "Gives 6 lvl of sprint boost when you have level 5", Value = false, Callback = function(v)
		local ok = MainModule.toggle_free_dash and MainModule.toggle_free_dash(v)
		if ok == false and v then
			pcall(function()
				local ref = MainModule._AllToggleRefs and MainModule._AllToggleRefs.FreeDash
				if ref and ref.SetValue then ref:SetValue(false) end
			end)
		end
	end })
	MainModule.UIToggle(b, {
		Id = "NoDashPhantomCD",
		Title = "No Dash + Phantom Dash CD",
		Desc = "Removes dash and phantom dash cooldown",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_no_dash_phantom_cd, v)
		end
	})

	local speedS
	MainModule.UIToggle(b, { Id = "SpeedHack", Title = "Speed Hack", Desc = "Increase your character speed", Value = false, Callback = function(v)
		sc(MainModule.toggle_speed_hack, v); if speedS then speedS.ensure(v) end
	end })
	speedS = MainModule.HSXBindSlider(b, {
		ParentId = "SpeedHack", Id = "SpeedValue", Title = "Speed Value", Value = {Min=16,Max=50,Default=39}, Step=1, defaultValue = 39,
		Callback = function(v) sc(MainModule.set_speed_value, v) end
	})

	local fcSpeed
	MainModule.HSXToggleWithKey(b, "Free Cam", "FreeCam", "None",
		function() return MainModule.FreeCam and MainModule.FreeCam.Enabled end,
		function(v) sc(MainModule.toggle_free_cam, v); if fcSpeed then fcSpeed.ensure(v) end; return true end)
	fcSpeed = MainModule.HSXBindSlider(b, {
		ParentId = "FreeCam", Id = "FreeCamSpeed", Title = "Free Cam Speed", Value = {Min=1,Max=50,Default=10}, Step=1, defaultValue = 10,
		Callback = function(v)
			MainModule.FreeCam._BaseSpeed = v
			sc(MainModule.set_free_cam_speed, v)
		end
	})

	local jumpS
	MainModule.UIToggle(b, { Id = "CustomJumpPower", Title = "Custom Jump Power", Desc = "Changes your jump power", Value = false, Callback = function(v)
		sc(MainModule.toggle_custom_jump_power, v); if jumpS then jumpS.ensure(v) end
	end })
	jumpS = MainModule.HSXBindSlider(b, {
		ParentId = "CustomJumpPower", Id = "JumpPower", Title = "Jump Power", Value = {Min=20,Max=200,Default=50}, Step=1, defaultValue = 50,
		Callback = function(v) sc(MainModule.set_custom_jump_power, v) end
	})

	local gravS
	MainModule.UIToggle(b, { Id = "CustomGravity", Title = "Custom Gravity", Desc = "Changes game gravity", Value = false, Callback = function(v)
		sc(MainModule.toggle_custom_gravity, v); if gravS then gravS.ensure(v) end
	end })
	gravS = MainModule.HSXBindSlider(b, {
		ParentId = "CustomGravity", Id = "Gravity", Title = "Gravity", Value = {Min=50,Max=500,Default=196.2}, Step=0.1, defaultValue = 196.2,
		Callback = function(v) sc(MainModule.set_custom_gravity, v) end
	})

	MainModule.UIToggle(b, { Id = "InfiniteJump", Title = "Infinite Jump", Desc = "Allows your character to infinite jumps", Value = false, Callback = function(v) sc(MainModule.toggle_infinite_jump, v) end })

	local m = t:Section({ Title = "Misc", Icon = "wrench", Opened = true })
	MainModule.UIToggle(m, { Id = "ThroughWalls", Title = "TP Through Walls", Desc = "Press X to teleport through wall in look direction", Value = false, Callback = function(v) sc(MainModule.toggle_through_walls, v) end })
	local fovS
	MainModule.UIToggle(m, { Id = "FOVChanger", Title = "FOV Changer", Desc = "Increase your field of view", Value = false, Callback = function(v)
		sc(MainModule.toggle_fov, v); if fovS then fovS.ensure(v) end
	end })
	fovS = MainModule.HSXBindSlider(m, {
		ParentId = "FOVChanger", Id = "FOV", Title = "FOV", Value = {Min=70,Max=120,Default=120}, Step=1, defaultValue = 120,
		Callback = function(v) sc(MainModule.set_fov, v) end
	})

	MainModule.UIToggle(m, { Id = "Fullbright", Title = "Fullbright", Desc = "Makes everything bright", Value = false, Callback = function(v) sc(MainModule.toggle_fullbright, v) end })
	MainModule.UIToggle(m, { Id = "InstantInteract", Title = "Instant Interact", Desc = "No proximity prompt cooldown", Value = false, Callback = function(v) sc(MainModule.toggle_no_cooldown_proximity, v) end })

	local flyS
	MainModule.HSXToggleWithKey(m, "Flight", "Flight", "None",
		function() return MainModule.Fly and MainModule.Fly.Enabled end,
		function(v) sc(MainModule.toggle_fly, v); if flyS then flyS.ensure(v) end; return true end)
	flyS = MainModule.HSXBindSlider(m, {
		ParentId = "Flight", Id = "FlySpeed", Title = "Fly Speed", Value = {Min=10,Max=200,Default=52}, Step=1, defaultValue = 52,
		Callback = function(v) sc(MainModule.set_fly_speed, v) end
	})

	MainModule.HSXToggleWithKey(m, "Noclip", "Noclip", "None",
		function() return noclippizdaEnabled end,
		function(v) return MainModule.toggle_noclip(v) end,
		"Walk through walls")
	MainModule.UIToggle(m, { Id = "HideOwnNickname", Title = "Hide Own Nickname", Desc = "Hide your nametag", Value = false, Callback = function(v) sc(MainModule.toggle_hide_nickname, v) end })
	MainModule.UIToggle(m, { Id = "HideAllNicknames", Title = "Hide All Nicknames", Desc = "Hide all players nametags", Value = false, Callback = function(v) sc(MainModule.toggle_hide_all_nicknames, v) end })
	MainModule.UIToggle(m, { Id = "GiveVisualItems", Title = "Give Visual Items", Desc = "Visual items (headless staff and other shii)", Value = false, Callback = function(v) sc(MainModule.toggle_visual_items, v) end })

	local c = t:Section({ Title = "Custom", Icon = "pencil", Opened = true })

	MainModule.ClothesColorEnabled = MainModule.ClothesColorEnabled or false
	MainModule.VFXColorEnabled = MainModule.VFXColorEnabled or false
	MainModule.ClothesColor = MainModule.ClothesColor or Color3.fromRGB(255, 255, 255)
	MainModule.VFXColor = MainModule.VFXColor or Color3.fromRGB(0, 255, 255)
	MainModule.UniformColorValue = MainModule.UniformColorValue or MainModule.ClothesColor
	MainModule.SetUniformSkinEnabled = MainModule.ClothesColorEnabled
	MainModule.FakeSettings = MainModule.FakeSettings or {
		["Custom Clothing Color"] = false,
		["Custom Ability Color"] = false
	}

	
	MainModule.UIToggle(c, {
		Id = "CustomUniformColor",
		Title = "Custom Clothes Color",
		Desc = "set your custom clothing color like with vip",
		Value = MainModule.ClothesColorEnabled,
		Callback = function(v)
			if MainModule.toggle_custom_uniform_color then
				MainModule.toggle_custom_uniform_color(v)
			else
				MainModule.ClothesColorEnabled = v
				if MainModule.UpdateVIPClothes then MainModule.UpdateVIPClothes() end
			end
		end
	})
	pcall(function()
		c:Colorpicker({
			Title = "Clothes Color",
			Default = MainModule.ClothesColor or Color3.fromRGB(255, 255, 255),
			Callback = function(col)
				if MainModule.set_uniform_color then
					MainModule.set_uniform_color(col)
				else
					MainModule.ClothesColor = col
					if MainModule.ClothesColorEnabled and MainModule.UpdateVIPClothes then
						MainModule.UpdateVIPClothes()
					end
				end
			end
		})
	end)

	MainModule.UIToggle(c, {
		Id = "CustomVFXColor",
		Title = "Custom VFX Color",
		Desc = "Turn on VIP abilities/VFX coloring locally",
		Value = MainModule.VFXColorEnabled,
		Callback = function(v)
			MainModule.VFXColorEnabled = v
			if MainModule.UpdateVIPVFX then MainModule.UpdateVIPVFX() end
		end
	})
	pcall(function()
		c:Colorpicker({
			Title = "VFX Color",
			Default = MainModule.VFXColor or Color3.fromRGB(0, 255, 255),
			Callback = function(col)
				MainModule.VFXColor = col
				if MainModule.VFXColorEnabled and MainModule.UpdateVIPVFX then
					MainModule.UpdateVIPVFX()
				end
			end
		})
	end)

	MainModule.UIToggle(c, { Id = "CustomWins", Title = "Custom Wins", Desc = "Spoof displayed win count (visual)", Value = false, Callback = function(v) sc(MainModule.toggle_custom_win, v) end })
	MainModule.UIInput(c, { Title = "Custom Win Value", Desc = "Type a number", Value = "67", Callback = function(v) sc(MainModule.set_custom_win, tonumber(v) or 0) end })
	MainModule.UIToggle(c, { Id = "CustomWinstreak", Title = "Custom Winstreak", Desc = "Spoof ur winstreak in leaderboard (visual)", Value = false, Callback = function(v) sc(MainModule.toggle_custom_winstreak, v) end })
	MainModule.UIInput(c, { Title = "Custom Winstreak Value", Desc = "Type a number", Value = "0", Callback = function(v) sc(MainModule.set_custom_winstreak, tonumber(v) or 0) end })
	MainModule.UIToggle(c, { Id = "CustomLevel", Title = "Custom Level", Desc = "Spoof ur level in leaderboard (visual)", Value = false, Callback = function(v) sc(MainModule.toggle_custom_level, v) end })
	MainModule.UIInput(c, { Title = "Custom Level Value", Desc = "Type a number", Value = "1", Callback = function(v)
		if MainModule.set_custom_level then sc(MainModule.set_custom_level, tonumber(v) or 1) end
	end })

	
	if not MainModule.InitSettingDataSpoof then
		function MainModule.InitSettingDataSpoof()
			local ok, SettingData = pcall(function()
				local effects = ReplicatedStorage:FindFirstChild("Effects")
				if not effects then return nil end
				local modules = effects:FindFirstChild("Modules")
				if not modules then return nil end
				local mod = modules:FindFirstChild("SettingData")
				if not mod then return nil end
				return require(mod)
			end)
			if not ok or type(SettingData) ~= "table" then return end
			MainModule._SettingData = SettingData
			local FakeSettings = MainModule.FakeSettings
			local function updateGameTables(tbl)
				for k, v in pairs(tbl) do
					if k == "Custom Clothing Color" then
						tbl[k] = FakeSettings["Custom Clothing Color"]
					elseif k == "Custom Ability Color" then
						tbl[k] = FakeSettings["Custom Ability Color"]
					elseif typeof(v) == "table" and v ~= tbl then
						updateGameTables(v)
					end
				end
			end
			MainModule._updateGameTables = updateGameTables
			for key, fn in pairs(SettingData) do
				if typeof(fn) == "function" then
					local original = fn
					SettingData[key] = function(self, ...)
						local args = {...}
						if typeof(self) == "string" and FakeSettings[self] ~= nil then
							return FakeSettings[self]
						end
						if typeof(args[1]) == "string" and FakeSettings[args[1]] ~= nil then
							return FakeSettings[args[1]]
						end
						return original(self, ...)
					end
				end
			end
		end
	end
	task.spawn(function()
		pcall(MainModule.InitSettingDataSpoof)
	end)

	if not MainModule.UpdateVIPClothes then
		function MainModule.UpdateVIPClothes()
			MainModule.FakeSettings["Custom Clothing Color"] = MainModule.ClothesColorEnabled
			pcall(function()
				if MainModule._updateGameTables and MainModule._SettingData then
					MainModule._updateGameTables(MainModule._SettingData)
				end
			end)
			local col = MainModule.ClothesColor or Color3.fromRGB(255, 255, 255)
			MainModule.UniformColorValue = col
			MainModule.SetUniformSkinEnabled = MainModule.ClothesColorEnabled
			_G.UniformColorValue = col
			_G.SetUniformSkinEnabled = MainModule.ClothesColorEnabled
			pcall(function()
				if MainModule.ClothesColorEnabled then
					LocalPlayer:SetAttribute("ClothingColor", col)
					LocalPlayer:SetAttribute("UniformColorValue", col)
					LocalPlayer:SetAttribute("ClothingColorToggle", true)
					LocalPlayer:SetAttribute("SetUniformSkinEnabled", true)
				else
					LocalPlayer:SetAttribute("ClothingColor", nil)
					LocalPlayer:SetAttribute("UniformColorValue", nil)
					LocalPlayer:SetAttribute("ClothingColorToggle", false)
					LocalPlayer:SetAttribute("SetUniformSkinEnabled", false)
				end
			end)
		end
	end
	if not MainModule.toggle_custom_uniform_color then
		function MainModule.toggle_custom_uniform_color(enabled)
			MainModule.ClothesColorEnabled = enabled and true or false
			MainModule.UpdateVIPClothes()
			if PlayToggleSound then PlayToggleSound() end
			return true
		end
		MainModule.toggle_clothes_color = MainModule.toggle_custom_uniform_color
	end
	if not MainModule.set_uniform_color then
		function MainModule.set_uniform_color(col)
			if typeof(col) == "Color3" then
				MainModule.ClothesColor = col
				if MainModule.ClothesColorEnabled then MainModule.UpdateVIPClothes() end
			end
		end
	end
	if not MainModule.UpdateVIPVFX then
		function MainModule.UpdateVIPVFX()
			MainModule.FakeSettings["Custom Ability Color"] = MainModule.VFXColorEnabled
			pcall(function()
				if MainModule._updateGameTables and MainModule._SettingData then
					MainModule._updateGameTables(MainModule._SettingData)
				end
			end)
		end
	end

	local e = t:Section({ Title = "Emotes", Icon = "music", Opened = true })
	local selectedEmote = emoteNames and emoteNames[1] or nil
	local emoteDrop
	emoteDrop = MainModule.UIDropdown(e, {
		Title = "Select Emote",
		Desc = "Choose an emote to play",
		Values = emoteNames or {"None"},
		Value = (emoteNames and emoteNames[1]) or "None",
		Callback = function(v) selectedEmote = v end
	})
	MainModule.UIInput(e, {
		Title = "Search Emote",
		Value = "",
		Callback = function(value)
			if not emoteNames then return end
			local filtered = {}
			if value and value ~= "" then
				for _, name in ipairs(emoteNames) do
					if string.lower(name):find(string.lower(value), 1, true) then
						table.insert(filtered, name)
					end
				end
			else
				filtered = emoteNames
			end
			if #filtered == 0 then filtered = {"No results"} end
			pcall(function()
				if emoteDrop.Refresh then emoteDrop:Refresh(filtered)
				elseif emoteDrop.SetValues then emoteDrop:SetValues(filtered) end
			end)
		end
	})
	e:Button({
		Title = "Play Emote",
		Desc = "Play selected emote (it also plays the sound of emote btw)",
		Callback = function()
			local data = nil
			for _, em in ipairs(EmotesList or {}) do
				if em.Name == selectedEmote then data = em; break end
			end
			if data then
				PlayEmote(data)
			else
				HSXNotify("Emote", "Select an emote", 0.8)
			end
		end
	})
	e:Button({
		Title = "Stop Emote",
		Desc = "Stop current emote",
		Callback = function()
			StopCurrentEmote()
			HSXNotify("Emote", "Stopped", 0.6)
		end
	})
end

do
	local t = Window:Tab({ Title = "Anniversary", Icon = "star", Desc = "Balloons, Peaberts, Anniversary" })
	local s = t:Section({ Title = "Balloons", Icon = "party-popper", Opened = true })
	MainModule.UIToggle(s, { Id = "BalloonESP", Title = "Balloon ESP", Desc = "shows a tracer and notification to ballons when they are spawns", Value = false, Callback = function(v) if PlayToggleSound then PlayToggleSound() end; sc(MainModule.toggle_balloon_esp, v) end })
	MainModule.HSXToggleWithKey(s, "Auto Teleport to Balloons", "BalloonTP", "None",
		function() return MainModule.BalloonData and MainModule.BalloonData.TPEnabled end,
		function(v) if PlayToggleSound then PlayToggleSound() end; sc(MainModule.toggle_balloon_teleport, v); return true end,
		"automatically teleport u to the ballon when they are available for pick up")
	local p = t:Section({ Title = "Peaberts", Icon = "skull", Opened = true })
	MainModule.UIToggle(p, { Id = "InstantKillPeaberts", Title = "Instant Kill Peaberts", Desc = "auto kill all admin abuse evil peaberts", Value = false, Callback = function(v) sc(MainModule.toggle_peabert_kill, v) end })
	MainModule.UISlider(p, { Title = "Shots Per Tick", Desc = "Shots fired per tick for peabert kill", Value = {Min=1,Max=50,Default=15}, Step=1, Callback = function(v) sc(MainModule.set_peabert_shots_per_tick, v) end })
	MainModule.UIToggle(p, { Id = "PeabertESP", Title = "Peabert ESP", Desc = "ESP + Tracers on peaberts that gives power rolls.", Value = false, Callback = function(v) sc(MainModule.toggle_peabert_esp, v) end })
	p:Button({ Title = "TP to Peabert", Desc = "Teleport to nearest peabert", Callback = function() sc(MainModule.tp_to_peaberts) end })
end

do
	local t = Window:Tab({ Title = "Extras", Icon = "sparkles", Desc = "Auto features & more" })
	local a = t:Section({ Title = "Auto Features", Icon = "bot", Opened = true })
	MainModule.UIToggle(a, { Id = "AutoWin", Title = "Auto Win", Desc = "Automatically teleports to end/safezone in RLGL, Dalgona, Light's out, HideAndSeek (Only Hider), JumpRope, GlassBridge", Value = false, Callback = function(v) sc(MainModule.toggle_auto_win, v) end })
	MainModule.UIToggle(a, { Id = "AutoNextGame", Title = "Auto Next Game", Desc = "Automatically teleports you to the next game", Value = false, Callback = function(v) sc(MainModule.toggle_auto_next_game, v) end })
	MainModule.UIToggle(a, { Id = "SafePlaceLowHealth", Title = "Safe Place on Low Health", Desc = "Teleports you to 100 blocks up when you have 30 HP or lowest", Value = false, Callback = function(v) sc(MainModule.toggle_auto_safe, v) end })
	MainModule.UIToggle(a, { Id = "AutoSkipDialogues", Title = "Auto Skip Dialogues", Desc = "Skip dialogue prompts", Value = false, Callback = function(v) sc(MainModule.toggle_auto_skip, v) end })
	MainModule.UIToggle(a, { Id = "AutoCollectBandage", Title = "Auto Collect Bandage", Desc = "Auto teleport u to the bandage if you dont have one", Value = false, Callback = function(v) sc(MainModule.toggle_auto_collect_bandage, v) end })
	MainModule.UIToggle(a, { Id = "AutoCollectFlashbang", Title = "Auto Collect Flashbang", Desc = "Auto teleport u to the flashbang if you dont have one", Value = false, Callback = function(v) sc(MainModule.toggle_auto_collect_flashbang, v) end })
	MainModule.UIToggle(a, { Id = "AutoCollectGrenade", Title = "Auto Collect Grenade", Desc = "Auto teleport u to the grenade if you dont have one", Value = false, Callback = function(v) sc(MainModule.toggle_auto_collect_grenade, v) end })
	MainModule.UIToggle(a, { Id = "AutoVote", Title = "Auto Vote", Desc = "Auto vote keep/stop", Value = false, Callback = function(v) sc(MainModule.toggle_auto_vote, v) end })
	MainModule.UIDropdown(a, { Title = "Vote Option", Values = {"KeepPlaying","StopPlaying"}, Value = "KeepPlaying", Callback = function(v) sc(MainModule.set_vote_option, v) end })
	MainModule.UIToggle(a, { Id = "RageAutoQTE", Title = "RAGE Auto QTE", Desc = "Auto pressing QTE when they are spawn", Value = false, Callback = function(v) sc(MainModule.toggle_rage_auto_qte, v) end })
	MainModule.UIToggle(a, { Id = "LegitAutoQTE", Title = "Legit Auto QTE", Desc = "Normally pressing auto QTE in timing", Value = false, Callback = function(v) sc(MainModule.toggle_legit_auto_qte, v) end })

	local s = t:Section({ Title = "Misc Extras", Icon = "sparkles", Opened = true })
	MainModule.UIToggle(s, {
		Id = "RemoveAnniversaryDecor",
		Title = "Remove Anniversary Decor",
		Desc = "Deletes all anniversary decorations to prevent lags on bad devices",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_remove_anniversary, v)
		end
	})
	MainModule.UIToggle(s, {
		Id = "FakeExploiter",
		Title = "Fake Exploiter",
		Desc = "makes nearest target flying and using speedhack ONLY FOR YOU so you can report them in ink support",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_fake_exploiter, v)
		end
	})
	MainModule.UIToggle(s, {
		Id = "AutoThrow",
		Title = "Auto Throw",
		Desc = "F / mobile button throw + face target helper",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_auto_throw, v)
		end
	})
	MainModule.UIToggle(s, {
		Id = "TugOfWarQTE",
		Title = "Enable Tug of War QTE",
		Desc = "enables tug of war qte good if you want to test or just to practice",
		Value = false,
		Callback = function(v)
			sc(MainModule.toggle_tug_of_war_qte, v)
		end
	})
	MainModule.UIToggle(s, { Id = "Ambience", Title = "Ambience", Value = false, Callback = function(v) sc(MainModule.toggle_ambience, v) end })
    MainModule.UIToggle(s, { Id = "AntiFall", Title = "Anti Fall", Desc = "Semi-transparent platform under you (works everywhere)", Value = false, Callback = function(v) sc(MainModule.toggle_global_anti_fall, v) end })

	s:Button({ Title = "Teleport Up 100", Callback = function() sc(MainModule.teleport_up) end })
	s:Button({ Title = "Teleport Down 40", Callback = function() sc(MainModule.teleport_down) end })

	local titleDrop
	MainModule.UIToggle(s, { Id = "FreeTitle", Title = "Free Title", Value = false, Callback = function(v)
		sc(MainModule.toggle_free_title, v)
		MainModule.HSXShowHide(titleDrop, v)
	end })
	titleDrop = MainModule.UIDropdown(s, {
		Title = "Select Title",
		Values = {"Manipulator","Rich Millionaire","Rich Billionaire","Fallen Angel","Zeus","Content Creator","Aura Farmer","The Recruiter","Tanos","The Glass Maker","Frontman","Squidder","Game VIP","Sackboy","Him","Honeycomb Artist","The Chosen One","Game Developer","Game Administrator","The Strongest","The Perfect Lifeform","Mastermind","King of Curses","Escape Artist","Protagonist"},
		Value = "Rich Billionaire",
		Callback = function(v) sc(MainModule.set_title, v) end
	})
	MainModule.HSXShowHide(titleDrop, false)

	local gp = t:Section({ Title = "Free Gamepasses", Icon = "gift", Opened = true })
	gp:Button({ Title = "Free VIP", Callback = function() sc(MainModule.unlock_vip) end })
	MainModule.UIToggle(gp, { Id = "PermanentGuard", Title = "Permanent Guard", Value = false, Callback = function(v) sc(MainModule.toggle_permanent_guard, v) end })
	MainModule.UIToggle(gp, { Id = "CustomPlayerTag", Title = "Custom Player Tag", Value = false, Callback = function(v) sc(MainModule.toggle_custom_player_tag, v) end })
	MainModule.UIToggle(gp, { Id = "PrivateServerPlus", Title = "Private Server Plus", Value = false, Callback = function(v) sc(MainModule.toggle_private_server_plus, v) end })
	MainModule.UIToggle(gp, { Id = "Lighter", Title = "Lighter", Value = false, Callback = function(v) sc(MainModule.toggle_lighter, v) end })
	MainModule.UIToggle(gp, { Id = "GlassVision", Title = "Glass Vision", Value = false, Callback = function(v) sc(MainModule.toggle_glass_vision, v) end })
end

do
	local t = Window:Tab({ Title = "Settings", Icon = "settings", Desc = "Menu, configs, themes" })
	local rawTab = t._raw or t

	
	local MenuBox = t:Section({ Title = "Menu", Icon = "menu", Opened = true })

	MenuBox:Dropdown({
		Title = "Notification Side",
		Values = { "Left", "Right" },
		Value = "Right",
		Callback = function(Value)
			pcall(function() Library:SetNotifySide(Value) end)
		end
	})

	MenuBox:Toggle({
		Title = "Always On Top",
		Desc = "Keep HollyScriptX above other UI",
		Value = true,
		Callback = function(State)
			pcall(function()
				if Library.SetAlwaysOnTop then
					Library:SetAlwaysOnTop(State and true or false)
				elseif Library.AlwaysOnTop ~= nil then
					Library.AlwaysOnTop = State and true or false
				end
				if Window and Window.SetAlwaysOnTop then
					Window:SetAlwaysOnTop(State and true or false)
				end
			end)
		end
	})

	MenuBox:Toggle({
		Title = "Background Blur",
		Desc = "Acrylic/blur behind the menu when open",
		Value = true,
		Callback = function(State)
			pcall(function()
				if Library.ToggleAcrylic then
					Library:ToggleAcrylic(State and true or false)
				elseif Library.SetAcrylic then
					Library:SetAcrylic(State and true or false)
				elseif Library.Acrylic ~= nil then
					Library.Acrylic = State and true or false
				end
				if Library.BackgroundBlur ~= nil then
					Library.BackgroundBlur = State and true or false
				end
			end)
		end
	})

	
	pcall(function()
		MainModule.Keybinds = MainModule.Keybinds or {}
		MainModule.Keybinds.Menu = MainModule.Keybinds.Menu or "Z"
		local def = MainModule.Keybinds.Menu
		if not def or def == "" or def == "None" then def = "Z" end
		local rawGb = MenuBox._raw or MenuBox
		local label = rawGb.AddLabel and rawGb:AddLabel("Menu bind") or nil
		local kp
		if label and label.AddKeyPicker then
			kp = label:AddKeyPicker("MenuKeybind", {
				Default = def,
				Mode = "Toggle",
				Text = "Menu keybind",
				NoUI = true,
			})
		end
		if Library.Options and Library.Options.MenuKeybind then
			Library.ToggleKeybind = Library.Options.MenuKeybind
		elseif kp then
			Library.ToggleKeybind = kp
		elseif Enum.KeyCode[def] then
			Library.ToggleKeybind = Enum.KeyCode[def]
		else
			Library.ToggleKeybind = Enum.KeyCode.Z
		end
	end)

	MenuBox:Dropdown({
		Title = "DPI Scale",
		Values = { "50", "75", "80", "85", "90", "100", "125", "150", "175", "200" },
		Value = "100",
		Callback = function(Value)
			Library:SetDPIScale(tonumber(Value) or 100)
			PlayBell()
		end
	})

	MenuBox:Button({
		Title = "Unload Script",
		Callback = function()
			pcall(function()
				if MainModule.cleanup_everything then MainModule.cleanup_everything() end
			end)
			cursorVisible = false
			pcall(function()
				if _G.HollyScriptX_CursorDrawings then
					for _, d in ipairs(_G.HollyScriptX_CursorDrawings) do
						pcall(function() d.Visible = false; if d.Remove then d:Remove() end end)
					end
				end
			end)
			pcall(function() if Window and Window.Destroy then Window:Destroy() end end)
			pcall(function() if Library and Library.Unload then Library:Unload() end end)
			HSXNotify("HollyScriptX", "Unloaded", 0.8)
		end
	})

	local MenuKeybinds = t:Section({ Title = "Keybinds", Icon = "keyboard", Opened = true })
	MenuKeybinds:Toggle({
		Title = "Show Keybinds Menu",
		Desc = "Show floating keybinds panel",
		Value = false,
		Callback = function(State)
			pcall(function()
				if Library.KeybindFrame then
					Library.KeybindFrame.Visible = State and true or false
				end
			end)
		end
	})

	
	pcall(function()
		ThemeManager:SetLibrary(Library)
		ThemeManager:SetFolder("HollyScriptX")
		ThemeManager:ApplyToTab(rawTab)
	end)
	pcall(function()
		SaveManager:SetLibrary(Library)
		SaveManager:IgnoreThemeSettings()
		SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
		SaveManager:SetFolder("HollyScriptX")
		SaveManager:BuildConfigSection(rawTab)
		SaveManager:LoadAutoloadConfig()
	end)

	local cr = t:Section({ Title = "Credits", Icon = "heart", Opened = true })
	cr:Paragraph({ Title = "whonixx - script owner" })
	cr:Paragraph({ Title = "shades - script owner" })
	cr:Paragraph({ Title = "insected - helped with obf/dc server" })
	cr:Paragraph({ Title = "chillnie - script tester/co-owner" })
	cr:Paragraph({ Title = "rezorn - script helper/developer" })
end

pcall(function()
	local mk = (MainModule.Keybinds and MainModule.Keybinds.Menu) or "Z"
	if Window.SetToggleKey and Enum.KeyCode[mk] then Window:SetToggleKey(Enum.KeyCode[mk]) end
end)
task.defer(function()
	task.wait(0.3)
	local url = "https://discord.gg/hollyscriptx-1504482964661076098"
	pcall(function() if setclipboard then setclipboard(url) end end)
	pcall(function() if toclipboard then toclipboard(url) end end)
	HSXNotify("HollyScriptX", "discord.gg/hollyscriptx-1504482964661076098 link copied to ur clipboard", 2)
end)


pcall(function()
	if Library.Options and Library.Options.MenuKeybind then
		Library.ToggleKeybind = Library.Options.MenuKeybind
	end
end)

print("[HollyScriptX] guguugguugagagagagagaagag")
