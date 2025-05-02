local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    warn("Failed to load MTWW. The URL might be down or incorrect.")
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

_G.infinjump = false
_G.infinJumpStarted = nil
_G.isAutoFarmingGold = false
_G.playerEspEnabled = false
_G.animalEspEnabled = false
_G.oreEspEnabled = false
_G.axeAuraEnabled = false

local windowName = "MTWW - Public Game"
if game.PrivateServerId ~= "" and game.PrivateServerId ~= nil then
    windowName = "MTWW - Private Game"
end

local Window = Rayfield:CreateWindow({
    Name = windowName,
    LoadingTitle = "The Wild West",
    LoadingSubtitle = "Script Is In Test Edition",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MTWW",
        FileName = "MTWW"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key | Youtube Hub",
        Subtitle = "Key System",
        Note = "Key In Discord Server",
        FileName = "YoutubeHubKey1",
        SaveKey = false,
        GrabKeyFromSite = true,
        Key = {"006", "Magic Word"}
    }
})

local MainTab = Window:CreateTab("🏠 Home", nil)
local MainSection = MainTab:CreateSection("Main")

Rayfield:Notify({
    Title = "You executed the script",
    Content = "Very cool gui",
    Duration = 5,
    Image = 13047715178,
    Actions = {
        Ignore = {
            Name = "Okay!",
            Callback = function()
                print("MARION THE WILD WEST LOADED!!! HAVE FUN!")
            end
        }
    }
})

local ButtonJump = MainTab:CreateButton({
    Name = "Infinite Jump Toggle",
    Callback = function()
        _G.infinjump = not _G.infinjump

        if _G.infinJumpStarted == nil then
            _G.infinJumpStarted = true
            StarterGui:SetCore("SendNotification", {
                Title = "Youtube Hub",
                Text = "Infinite Jump Activated!",
                Duration = 5
            })
            local plr = LocalPlayer
            local m = plr:GetMouse()
            m.KeyDown:connect(function(k)
                if _G.infinjump then
                    if k:byte() == 32 then
                        local humanoid = plr.Character and plr.Character:FindFirstChildOfClass('Humanoid')
                        if humanoid then
                            humanoid:ChangeState('Jumping')
                            wait()
                            humanoid:ChangeState('Seated')
                        end
                    end
                end
            end)
        else
             StarterGui:SetCore("SendNotification", {
                Title = "Youtube Hub",
                Text = "Infinite Jump " .. (_G.infinjump and "Activated!" or "Deactivated!"),
                Duration = 3
            })
        end
    end,
})

local Slider1 = MainTab:CreateSlider({
    Name = "WalkSpeed Slider",
    Range = {1, 350},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "sliderws",
    Callback = function(Value)
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end,
})

local Slider2 = MainTab:CreateSlider({
    Name = "JumpPower Slider",
    Range = {1, 350},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "sliderjp",
    Callback = function(Value)
         local char = LocalPlayer.Character
         local humanoid = char and char:FindFirstChild("Humanoid")
         if humanoid then
            humanoid.JumpPower = Value
        end
    end,
})

local Dropdown = MainTab:CreateDropdown({
    Name = "Select Area",
    Options = {"Starter World", "Pirate Island", "Pineapple Paradise"},
    CurrentOption = "Starter World",
    MultipleOptions = false,
    Flag = "dropdownarea",
    Callback = function(Option)
        print(Option)
    end,
})

local Input = MainTab:CreateInput({
    Name = "Walkspeed",
    PlaceholderText = "1-500",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        local num = tonumber(Text)
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if num and humanoid then
            humanoid.WalkSpeed = num
        end
    end,
})

local OtherSection = MainTab:CreateSection("Other")

local function AutoFarmGold()
    local player = LocalPlayer
    print("AutoFarm: Started.")
    while _G.isAutoFarmingGold and task.wait(0.1) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            print("AutoFarm: Character or RootPart not found.")
            task.wait(1)
            continue
        end

        local goldOreFolder = Workspace:FindFirstChild("WORKSPACE_Interactables")
                                :FindFirstChild("Mining")
                                :FindFirstChild("OreDeposits")
                                :FindFirstChild("Gold")

        if not goldOreFolder then
            print("AutoFarm: Gold Ore folder not found at Workspace.WORKSPACE_Interactables.Mining.OreDeposits.Gold")
            task.wait(1)
            continue
        end

        local children = goldOreFolder:GetChildren()
        if #children == 0 then
             task.wait(0.5)
             continue
        end

        for _, oreModule in ipairs(children) do
            if not _G.isAutoFarmingGold then break end

            local targetPart = nil
            if oreModule:IsA("BasePart") then
                 targetPart = oreModule
            else
                 targetPart = oreModule:FindFirstAncestorWhichIsA("BasePart")
                 if not targetPart then
                      targetPart = oreModule:FindFirstChildWhichIsA("BasePart")
                 end
            end

            if targetPart and targetPart.CFrame then
                rootPart.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
                task.wait(0.2)

                if not _G.isAutoFarmingGold then break end

                local clickDetector = targetPart:FindFirstChildOfClass("ClickDetector")
                local prompt = targetPart:FindFirstChildOfClass("ProximityPrompt")

                local interacted = false
                if clickDetector then
                    if fireclickdetector then
                        fireclickdetector(clickDetector)
                        interacted = true
                    else
                        print("AutoFarm Error: fireclickdetector function not available")
                        _G.isAutoFarmingGold = false
                        break
                    end
                elseif prompt then
                     if fireproximityprompt then
                         fireproximityprompt(prompt)
                         interacted = true
                     else
                         print("AutoFarm Error: fireproximityprompt function not available")
                          _G.isAutoFarmingGold = false
                         break
                     end
                end

                if interacted then
                    task.wait(0.5)
                else
                    task.wait(0.1)
                end

            else
                 task.wait(0.05)
            end
        end
        task.wait(0.1)
    end
    print("AutoFarm: Stopped.")
end


local ToggleFarm = MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        _G.isAutoFarmingGold = Value
        print("FARMING:", Value)
        if Value then
            task.spawn(AutoFarmGold)
        end
    end,
})


local TeleportTab = Window:CreateTab("🏝 Teleports", nil)

local ButtonTeleport1 = TeleportTab:CreateButton({
    Name = "Bronze City",
    Callback = function()
        local player = LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        local interactables = Workspace:FindFirstChild("WORKSPACE_Interactables")
        local npcs = interactables and interactables:FindFirstChild("NPCs")
        local mayor = npcs and npcs:FindFirstChild("DonationMayor")
        local targetPart = mayor and mayor:FindFirstChild("Head")

        if rootPart and targetPart then
            rootPart.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
            print("Teleported to Bronze City Mayor's Head location.")
             StarterGui:SetCore("SendNotification", {
                  Title = "Teleport",
                  Text = "Teleported to Bronze City.",
                  Duration = 3
             })
        else
            print("Teleport failed: Could not find Character RootPart or Target Part.")
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport Failed",
                Text = "Could not find target location or character.",
                Duration = 5
            })
        end
    end,
})

local ButtonTeleport2 = TeleportTab:CreateButton({
    Name = "Puerto Dorado",
    Callback = function()
        print("Puerto Dorado button clicked - no teleport logic added yet.")
    end,
})

local ButtonTeleport3 = TeleportTab:CreateButton({
    Name = "Reservation Camp",
    Callback = function()
        print("Reservation Camp button clicked - no teleport logic added yet.")
    end,
})

local MiscTab = Window:CreateTab("🎲 Misc", nil)

local espLoopConnection = nil
local playerHighlights = {}
local animalHighlights = {}
local oreHighlights = {}
local workspaceEntities = Workspace:FindFirstChild("WORKSPACE_Entities")
local entitiesPlayersFolder = workspaceEntities and workspaceEntities:FindFirstChild("Players")
local entitiesAnimalsFolder = workspaceEntities and workspaceEntities:FindFirstChild("Animals")
local entitiesDeadAnimalsFolder = workspaceEntities and workspaceEntities:FindFirstChild("DeadAnimals")
local goldOreFolder = Workspace:FindFirstChild("WORKSPACE_Interactables") and Workspace.WORKSPACE_Interactables:FindFirstChild("Mining") and Workspace.WORKSPACE_Interactables.Mining:FindFirstChild("OreDeposits") and Workspace.WORKSPACE_Interactables.Mining.OreDeposits:FindFirstChild("Gold")

local function UpdateAllESP()
    if not (_G.playerEspEnabled or _G.animalEspEnabled or _G.oreEspEnabled) then return end

    local currentPlayers = {}
    local currentAnimals = {}
    local currentOres = {}

    if _G.playerEspEnabled and entitiesPlayersFolder then
        for _, playerEntity in ipairs(entitiesPlayersFolder:GetChildren()) do
            if playerEntity.Name ~= LocalPlayer.Name then
                currentPlayers[playerEntity.Name] = true
                local characterModel = playerEntity
                local humanoid = characterModel and characterModel:FindFirstChildOfClass("Humanoid")

                if characterModel and humanoid and humanoid.Health > 0 then
                    local highlight = playerHighlights[playerEntity.Name]
                    if not highlight or not highlight.Parent then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "PlayerESP_" .. playerEntity.Name
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.FillTransparency = 0.7
                        highlight.OutlineColor = Color3.fromRGB(150, 0, 0)
                        highlight.OutlineTransparency = 0.2
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = CoreGui
                        playerHighlights[playerEntity.Name] = highlight
                    end
                    highlight.Adornee = characterModel
                    highlight.Enabled = true
                else
                    if playerHighlights[playerEntity.Name] and playerHighlights[playerEntity.Name].Parent then
                        playerHighlights[playerEntity.Name].Enabled = false
                    end
                end
            end
        end
    end
    for playerName, highlight in pairs(playerHighlights) do
        if highlight and highlight.Parent and (not currentPlayers[playerName] or not _G.playerEspEnabled) then
            highlight:Destroy()
            playerHighlights[playerName] = nil
        end
    end

    local function ProcessAnimalFolder(folder, isAlive)
        if not folder then return end
        for _, animalEntity in ipairs(folder:GetChildren()) do
            local uniqueID = folder.Name .. "_" .. animalEntity.Name .. "_" .. tostring(animalEntity:GetHashCode())
            currentAnimals[uniqueID] = true
            local animalModel = animalEntity
            local humanoid = animalModel and animalModel:FindFirstChildOfClass("Humanoid")

            if animalModel and (humanoid or not isAlive) then
                 local highlight = animalHighlights[uniqueID]
                 if not highlight or not highlight.Parent then
                     highlight = Instance.new("Highlight")
                     highlight.Name = "AnimalESP_" .. uniqueID
                     highlight.FillColor = Color3.fromRGB(0, 255, 0)
                     highlight.FillTransparency = 0.7
                     highlight.OutlineColor = Color3.fromRGB(0, 150, 0)
                     highlight.OutlineTransparency = 0.2
                     highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                     highlight.Parent = CoreGui
                     animalHighlights[uniqueID] = highlight
                 end
                 highlight.Adornee = animalModel
                 highlight.Enabled = true
            else
                 if animalHighlights[uniqueID] and animalHighlights[uniqueID].Parent then
                     animalHighlights[uniqueID].Enabled = false
                 end
            end
        end
    end

    if _G.animalEspEnabled then
        ProcessAnimalFolder(entitiesAnimalsFolder, true)
        ProcessAnimalFolder(entitiesDeadAnimalsFolder, false)
    end
    for animalID, highlight in pairs(animalHighlights) do
        if highlight and highlight.Parent and (not currentAnimals[animalID] or not _G.animalEspEnabled) then
            highlight:Destroy()
            animalHighlights[animalID] = nil
        end
    end

    if _G.oreEspEnabled and goldOreFolder then
        for _, oreModule in ipairs(goldOreFolder:GetChildren()) do
            local targetPart = nil
            if oreModule:IsA("BasePart") then
                 targetPart = oreModule
            elseif oreModule:IsA("Model") then
                 targetPart = oreModule.PrimaryPart or oreModule:FindFirstChildWhichIsA("BasePart")
            end
            if not targetPart then targetPart = oreModule:FindFirstAncestorWhichIsA("BasePart") end

            if targetPart then
                local uniqueID = "Ore_" .. oreModule.Name .. "_" .. tostring(oreModule:GetHashCode())
                currentOres[uniqueID] = true
                local highlight = oreHighlights[uniqueID]
                if not highlight or not highlight.Parent then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "OreESP_" .. uniqueID
                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                    highlight.FillTransparency = 0.7
                    highlight.OutlineColor = Color3.fromRGB(150, 150, 0)
                    highlight.OutlineTransparency = 0.2
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = CoreGui
                    oreHighlights[uniqueID] = highlight
                end
                highlight.Adornee = targetPart
                highlight.Enabled = true
            end
        end
    end
    for oreID, highlight in pairs(oreHighlights) do
        if highlight and highlight.Parent and (not currentOres[oreID] or not _G.oreEspEnabled) then
            highlight:Destroy()
            oreHighlights[oreID] = nil
        end
    end

end

local function StartStopESPUpdates()
    if (_G.playerEspEnabled or _G.animalEspEnabled or _G.oreEspEnabled) then
        if not (espLoopConnection and espLoopConnection.Connected) then
             workspaceEntities = Workspace:FindFirstChild("WORKSPACE_Entities")
             entitiesPlayersFolder = workspaceEntities and workspaceEntities:FindFirstChild("Players")
             entitiesAnimalsFolder = workspaceEntities and workspaceEntities:FindFirstChild("Animals")
             entitiesDeadAnimalsFolder = workspaceEntities and workspaceEntities:FindFirstChild("DeadAnimals")
             goldOreFolder = Workspace:FindFirstChild("WORKSPACE_Interactables") and Workspace.WORKSPACE_Interactables:FindFirstChild("Mining") and Workspace.WORKSPACE_Interactables.Mining:FindFirstChild("OreDeposits") and Workspace.WORKSPACE_Interactables.Mining.OreDeposits:FindFirstChild("Gold")
             if not workspaceEntities then warn("ESP Warning: WORKSPACE_Entities not found!") end
             if not goldOreFolder then warn("ESP Warning: Gold Ore folder not found!") end
             espLoopConnection = RunService.RenderStepped:Connect(UpdateAllESP)
             print("ESP Update Loop Started.")
        end
    else
        if (espLoopConnection and espLoopConnection.Connected) then
            espLoopConnection:Disconnect()
            espLoopConnection = nil
            print("ESP Update Loop Stopped.")
            for playerName, highlight in pairs(playerHighlights) do if highlight and highlight.Parent then highlight:Destroy() end end
            playerHighlights = {}
            for animalID, highlight in pairs(animalHighlights) do if highlight and highlight.Parent then highlight:Destroy() end end
            animalHighlights = {}
            for oreID, highlight in pairs(oreHighlights) do if highlight and highlight.Parent then highlight:Destroy() end end
            oreHighlights = {}
        end
    end
end

local PlayerEspButton = MiscTab:CreateButton({
    Name = "Toggle Player ESP",
    Callback = function()
        _G.playerEspEnabled = not _G.playerEspEnabled
        if not _G.playerEspEnabled then
            for playerName, highlight in pairs(playerHighlights) do if highlight and highlight.Parent then highlight:Destroy() end end
            playerHighlights = {}
        end
        StartStopESPUpdates()
        StarterGui:SetCore("SendNotification", { Title = "Player ESP", Text = "Player ESP " .. (_G.playerEspEnabled and "Enabled" or "Disabled"), Duration = 3 })
    end,
})

local AnimalEspButton = MiscTab:CreateButton({
    Name = "Toggle Animal ESP",
    Callback = function()
        _G.animalEspEnabled = not _G.animalEspEnabled
         if not _G.animalEspEnabled then
            for animalID, highlight in pairs(animalHighlights) do if highlight and highlight.Parent then highlight:Destroy() end end
            animalHighlights = {}
        end
        StartStopESPUpdates()
        StarterGui:SetCore("SendNotification", { Title = "Animal ESP", Text = "Animal ESP " .. (_G.animalEspEnabled and "Enabled" or "Disabled"), Duration = 3 })
    end,
})

local OreEspButton = MiscTab:CreateButton({
    Name = "Toggle Ore ESP",
    Callback = function()
        _G.oreEspEnabled = not _G.oreEspEnabled
         if not _G.oreEspEnabled then
            for oreID, highlight in pairs(oreHighlights) do if highlight and highlight.Parent then highlight:Destroy() end end
            oreHighlights = {}
        end
        StartStopESPUpdates()
        StarterGui:SetCore("SendNotification", { Title = "Ore ESP", Text = "Ore ESP " .. (_G.oreEspEnabled and "Enabled" or "Disabled"), Duration = 3 })
    end,
})


local AuraSection = MiscTab:CreateSection("Auras")
local axeAuraLoopConnection = nil
local currentAxeHitbox = nil
local originalAxeHitboxSize = nil
local targetAxeNames = {["Tier1Axe"] = true, ["Tier2Axe"] = true, ["Tier3Axe"] = true}

local function UpdateAxeAura()
    if not _G.axeAuraEnabled then return end

    local character = LocalPlayer.Character
    if not character then return end

    local currentTool = character:FindFirstChildOfClass("Tool")
    local hitbox = nil

    if currentTool and targetAxeNames[currentTool.Name] then
        local handle = currentTool:FindFirstChild("Handle")
        if handle then
            hitbox = handle:FindFirstChild("HitBox")
        end
    end

    if hitbox and hitbox:IsA("BasePart") then
        if hitbox ~= currentAxeHitbox then
            if currentAxeHitbox and originalAxeHitboxSize then
                 if currentAxeHitbox.Parent then currentAxeHitbox.Size = originalAxeHitboxSize end
            end
            currentAxeHitbox = hitbox
            originalAxeHitboxSize = hitbox.Size
        end
        hitbox.Size = Vector3.new(10, 10, 10)
    elseif currentAxeHitbox then
         if originalAxeHitboxSize and currentAxeHitbox.Parent then
             currentAxeHitbox.Size = originalAxeHitboxSize
         end
         currentAxeHitbox = nil
         originalAxeHitboxSize = nil
    end
end

if AuraSection then
    local AxeAuraButton = AuraSection:CreateButton({
        Name = "Axe Aura",
        Callback = function()
            _G.axeAuraEnabled = not _G.axeAuraEnabled
            if _G.axeAuraEnabled then
                 if not (axeAuraLoopConnection and axeAuraLoopConnection.Connected) then
                     axeAuraLoopConnection = RunService.Heartbeat:Connect(UpdateAxeAura)
                     print("Axe Aura Loop Started.")
                 end
            else
                 if (axeAuraLoopConnection and axeAuraLoopConnection.Connected) then
                     axeAuraLoopConnection:Disconnect()
                     axeAuraLoopConnection = nil
                     print("Axe Aura Loop Stopped.")
                     if currentAxeHitbox and originalAxeHitboxSize then
                         if currentAxeHitbox.Parent then currentAxeHitbox.Size = originalAxeHitboxSize end
                         currentAxeHitbox = nil
                         originalAxeHitboxSize = nil
                     end
                 end
            end
            StarterGui:SetCore("SendNotification", { Title = "Axe Aura", Text = "Axe Aura " .. (_G.axeAuraEnabled and "Enabled" or "Disabled"), Duration = 3 })
        end,
    })
    if not AxeAuraButton then
        warn("Failed to create Axe Aura button!")
    end
else
    warn("Failed to create Aura section!")
end

