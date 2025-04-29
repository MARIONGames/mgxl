local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "MTWW 1.0.6 - Public Game",
    LoadingTitle = "The Wild West",
    LoadingSubtitle = "MARION THE WILD WEST.",
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

local Button = MainTab:CreateButton({
    Name = "Infinite Jump Toggle",
    Callback = function()
        _G.infinjump = not _G.infinjump

        if _G.infinJumpStarted == nil then
            _G.infinJumpStarted = true

            game.StarterGui:SetCore("SendNotification", {
                Title = "Youtube Hub",
                Text = "Infinite Jump Activated!",
                Duration = 5
            })

            local plr = game:GetService('Players').LocalPlayer
            local m = plr:GetMouse()
            m.KeyDown:connect(function(k)
                if _G.infinjump then
                    if k:byte() == 32 then
                        local humanoid = plr.Character:FindFirstChildOfClass('Humanoid')
                        if humanoid then
                            humanoid:ChangeState('Jumping')
                            wait()
                            humanoid:ChangeState('Seated')
                        end
                    end
                end
            end)
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
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
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
         if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
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
        if num and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
        end
    end,
})

local OtherSection = MainTab:CreateSection("Other")
_G.isAutoFarmingGold = false

local function AutoFarmGold()
    local player = game:GetService("Players").LocalPlayer
    print("AutoFarm: Started.")
    while _G.isAutoFarmingGold and task.wait(0.1) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            print("AutoFarm: Character or RootPart not found.")
            task.wait(1)
            continue
        end

        local goldOreFolder = game:GetService("Workspace"):FindFirstChild("WORKSPACE_Interactables")
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
             print("AutoFarm: No gold ore modules found.") 
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
                        print("AutoFarm: Fired ClickDetector on " .. targetPart.Name)
                    else
                        print("AutoFarm Error: fireclickdetector function not available")
                        _G.isAutoFarmingGold = false -- Stop if interaction fails
                        break
                    end
                elseif prompt then
                     if fireproximityprompt then
                         fireproximityprompt(prompt)
                         interacted = true
                         print("AutoFarm: Fired ProximityPrompt on " .. targetPart.Name)
                     else
                         print("AutoFarm Error: fireproximityprompt function not available")
                          _G.isAutoFarmingGold = false -- Stop if interaction fails
                         break
                     end
                end

                if interacted then
                    task.wait(0.5)
                else
                    print("AutoFarm: No interactable found on " .. targetPart.Name .. " related to module " .. oreModule.Name)
                    task.wait(0.1)
                end

            else
                print("AutoFarm: Could not determine target part for module: " .. oreModule.Name)
                task.wait(0.05)
            end
        end
        task.wait(0.1)
    end
    print("AutoFarm: Stopped.")
end


local Toggle = MainTab:CreateToggle({
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

local Button1 = TeleportTab:CreateButton({
    Name = "Bronze City",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        local interactables = game.Workspace:FindFirstChild("WORKSPACE_Interactables")
        local npcs = interactables and interactables:FindFirstChild("NPCs")
        local mayor = npcs and npcs:FindFirstChild("DonationMayor")
        local targetPart = mayor and mayor:FindFirstChild("Head")

        if rootPart and targetPart then
            rootPart.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
            print("Teleported to Bronze City Mayor's Head location.")
             game.StarterGui:SetCore("SendNotification", {
                 Title = "Teleport",
                 Text = "Teleported to Bronze City.",
                 Duration = 3
             })
        else
            print("Teleport failed: Could not find Character RootPart or Target Part.")
            game.StarterGui:SetCore("SendNotification", {
                Title = "Teleport Failed",
                Text = "Could not find target location or character.",
                Duration = 5
            })
        end
    end,
})

local Button2 = TeleportTab:CreateButton({
    Name = "Puerto Dorado",
    Callback = function()
        print("Puerto Dorado button clicked - no teleport logic added yet.")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Teleport Failed",
            Text = "Could not find target location or character.",
            Duration = 5
        })
    end,
})

local Button3 = TeleportTab:CreateButton({
    Name = "Reservation Camp",
    Callback = function()
        print("Reservation Camp button clicked - no teleport logic added yet.")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Teleport Failed",
            Text = "Could not find target location or character.",
            Duration = 5
        })
    end,
})

local MiscTab = Window:CreateTab("🎲 Misc", nil)

local aimbotEnabled = false
local aimbotFOV = 50
local aimbotLoopConnection = nil
local fovCircle = nil
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local AimTab = Window:CreateTab("⚔️ Combat", nil)
local AimSection = AimTab:CreateSection("Aim Bot")

local FOVSlider = AimSection:CreateSlider({
    Name = "FOV Size",
    Range = {1, 5},
    Increment = 0.1,
    Suffix = " ",
    CurrentValue = 1,
    Flag = "aimfovslider",
    Callback = function(Value)
        aimbotFOV = Value * 50
        if fovCircle then
            fovCircle.Radius = aimbotFOV
        end
    end,
})

local function AimbotLoop()
    if not aimbotEnabled or not Camera or not Players.LocalPlayer then return end

    local ViewportSize = Camera.ViewportSize
    local CenterScreen = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)

    if Drawing and Drawing.new then
        if not fovCircle then 
            fovCircle = Drawing.new("Circle")
            fovCircle.Color = Color3.fromRGB(255, 0, 0)
            fovCircle.Thickness = 2
            fovCircle.NumSides = 30
            fovCircle.Filled = false
            print("Aimbot: Created FOV Circle")
        end
        fovCircle.Visible = true
        fovCircle.Radius = aimbotFOV
        fovCircle.Position = CenterScreen
    elseif fovCircle then
         fovCircle.Visible = false
    end

    local currentTargetHead = nil
    local minDist = aimbotFOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Head")

            if humanoid and humanoid.Health > 0 and head then
                local headPos3D = head.Position

                local screenPosVec3, onScreen = Camera:WorldToScreenPoint(headPos3D)

                if onScreen then
                    local screenPosVec2 = Vector2.new(screenPosVec3.X, screenPosVec3.Y)
                    local dist = (screenPosVec2 - CenterScreen).Magnitude

                    if dist < minDist then
                        minDist = dist
                        currentTargetHead = head
                    end
                end
            end
        end
    end

    if currentTargetHead then
    end
end

local AimbotToggle = AimSection:CreateToggle({
    Name = "Enable Aim Assist",
    CurrentValue = false,
    Flag = "aimbottoggle",
    Callback = function(Value)
        aimbotEnabled = Value
        if Value then
            print("Aimbot Enabled")
            Camera = workspace.CurrentCamera
            if not aimbotLoopConnection or not aimbotLoopConnection.Connected then
                 aimbotLoopConnection = RunService.RenderStepped:Connect(AimbotLoop)
            end
            if fovCircle then fovCircle.Visible = true end
        else
            print("Aimbot Disabled")
            if aimbotLoopConnection and aimbotLoopConnection.Connected then
                aimbotLoopConnection:Disconnect()
                aimbotLoopConnection = nil
            end
            -- Hide the FOV circle
            if fovCircle then
                fovCircle.Visible = false
                Optional: You could destroy the circle here if you want
                fovCircle:Remove()
                fovCircle = nil
            end
        end
    end,
})
