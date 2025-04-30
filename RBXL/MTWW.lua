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
_G.espEnabled = false
_G.espHandlerActive = false -- Track if ESP handler is active

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
local EspSection = MiscTab:CreateSection("Player ESP")

local espLoopConnection = nil
local playerHighlights = {}
local entitiesPlayersFolder = Workspace:FindFirstChild("WORKSPACE_Entities") and Workspace.WORKSPACE_Entities:FindFirstChild("Players")

local function UpdateESP()
    if not _G.espEnabled or not entitiesPlayersFolder then return end

    local currentPlayers = {}

    for _, playerEntity in ipairs(entitiesPlayersFolder:GetChildren()) do
        if playerEntity.Name ~= LocalPlayer.Name then
            currentPlayers[playerEntity.Name] = true
            local characterModel = playerEntity
            local humanoid = characterModel and characterModel:FindFirstChildOfClass("Humanoid")

            if characterModel and humanoid and humanoid.Health > 0 then
                local highlight = playerHighlights[playerEntity.Name]
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight_" .. playerEntity.Name
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.FillTransparency = 0.7
                    highlight.OutlineColor = Color3.fromRGB(0, 100, 0)
                    highlight.OutlineTransparency = 0.2
                    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                    highlight.Enabled = true
                    highlight.Parent = CoreGui
                    playerHighlights[playerEntity.Name] = highlight
                    print("Created ESP Highlight for", playerEntity.Name)
                end
                 if highlight.Parent ~= CoreGui then highlight.Parent = CoreGui end
                 highlight.Adornee = characterModel
                 highlight.Enabled = true
            else
                if playerHighlights[playerEntity.Name] then
                    playerHighlights[playerEntity.Name].Enabled = false
                    playerHighlights[playerEntity.Name].Adornee = nil
                end
            end
        end
    end

     for playerName, highlight in pairs(playerHighlights) do
         if not currentPlayers[playerName] then
             print("Removing ESP Highlight for left player:", playerName)
             highlight:Destroy()
             playerHighlights[playerName] = nil
         end
     end
end

local EspButton = EspSection:CreateButton({
    Name = "Toggle Player ESP",
    Callback = function()
        _G.espEnabled = not _G.espEnabled
        local Value = _G.espEnabled
        print("Player ESP Toggled via Button:", Value)

        entitiesPlayersFolder = Workspace:FindFirstChild("WORKSPACE_Entities") and Workspace.WORKSPACE_Entities:FindFirstChild("Players")
        if not entitiesPlayersFolder then
             warn("ESP Error: Could not find Workspace.WORKSPACE_Entities.Players folder!")
        end

        if Value then
            if not entitiesPlayersFolder then
                _G.espEnabled = false
                StarterGui:SetCore("SendNotification", { Title = "ESP Error", Text = "Player folder not found!", Duration = 5 })
                return
            end
            if not _G.espHandlerActive then
                _G.espHandlerActive = true
                espLoopConnection = RunService.RenderStepped:Connect(UpdateESP)
                print("ESP Update Loop Connected.")
                UpdateESP()
            end
             for _, highlight in pairs(playerHighlights) do
                 if highlight.Adornee then
                     highlight.Enabled = true
                 end
             end
        else
            if espLoopConnection and espLoopConnection.Connected then
                espLoopConnection:Disconnect()
                espLoopConnection = nil
                _G.espHandlerActive = false
                print("ESP Update Loop Disconnected.")
            end
            print("Disabling all ESP Highlights.")
            for playerName, highlight in pairs(playerHighlights) do
                highlight:Destroy()
            end
            playerHighlights = {}
        end
         StarterGui:SetCore("SendNotification", { Title = "ESP", Text = "Player ESP " .. (Value and "Enabled" or "Disabled"), Duration = 3 })
    end,
})

