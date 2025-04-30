local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    warn("Failed to load Rayfield UI Library. The URL might be down or incorrect.")
    return
end

_G.infinJumpEnabled = false
_G.infinJumpHandlerActive = false
_G.autoFarmGoldEnabled = false
_G.espEnabled = false
_G.aimbotEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "MTWW 1.0.7 - Public Game (Revised)",
    LoadingTitle = "The Wild West",
    LoadingSubtitle = "MARION THE WILD WEST.",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MTWW_Config",
        FileName = "MTWW_Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Key | MTWW",
        Subtitle = "Key Verify",
        Note = "Key In marion-games.com/mtww.key (Ensure URL is valid)",
        FileName = "MTWWKey",
        SaveKey = true,
        GrabKeyFromSite = true,
        Key = {"https://mgxl.marion-games.com/SSS/Key", "006"}
    }
})

Rayfield:Notify({
    Title = "Script Executed",
    Content = "MTWW Revised Loaded!",
    Duration = 7,
    Image = 13047715178,
    Actions = {
        Ignore = {
            Name = "Okay!",
            Callback = function()
                print("MARION THE WILD WEST (Revised) LOADED! HAVE FUN!")
            end
        }
    }
})

local MainTab = Window:CreateTab("🏠 Home", nil)
local MainSection = MainTab:CreateSection("Movement")

local Button = MainTab:CreateButton({
    Name = "Infinite Jump Toggle",
    Callback = function()
        _G.infinJumpEnabled = not _G.infinJumpEnabled

        StarterGui:SetCore("SendNotification", {
            Title = "Infinite Jump",
            Text = "Infinite Jump " .. (_G.infinJumpEnabled and "Activated!" or "Deactivated!"),
            Duration = 3
        })

        if not _G.infinJumpHandlerActive then
            _G.infinJumpHandlerActive = true
            print("Infinite Jump Handler Activated.")

            local plr = LocalPlayer
            local mouse = plr:GetMouse()

            mouse.KeyDown:Connect(function(key)
                if not _G.infinJumpEnabled then return end

                local char = plr.Character
                local humanoid = char and char:FindFirstChildOfClass('Humanoid')

                if key:byte() == 32 and humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    task.wait()
                    if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                         humanoid:ChangeState(Enum.HumanoidStateType.Seated)
                    end
                end
            end)
        end
    end,
})

local Slider1 = MainTab:CreateSlider({
    Name = "WalkSpeed Slider",
    Range = {16, 350},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "sliderws",
    Callback = function(Value)
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end,
})

local Slider2 = MainTab:CreateSlider({
    Name = "JumpPower Slider",
    Range = {50, 350},
    Increment = 1,
    Suffix = " Power",
    CurrentValue = 50,
    Flag = "sliderjp",
    Callback = function(Value)
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value
        end
    end,
})

local Input = MainTab:CreateInput({
    Name = "Set Walkspeed",
    PlaceholderText = "Enter speed (e.g., 50)",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
             local char = LocalPlayer.Character
             local humanoid = char and char:FindFirstChildOfClass("Humanoid")
             if humanoid then
                 humanoid.WalkSpeed = math.clamp(num, 1, 500)
                 Slider1:Set(humanoid.WalkSpeed)
                 print("WalkSpeed set to:", humanoid.WalkSpeed)
             end
        else
            print("Invalid number entered for WalkSpeed.")
        end
    end,
})

local FarmSection = MainTab:CreateSection("Automation")
_G.autoFarmGoldEnabled = false

local function AutoFarmGold()
    local player = LocalPlayer
    print("AutoFarmGold: Coroutine Started.")

    while _G.autoFarmGoldEnabled and task.wait(0.1) do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if not (rootPart and humanoid and humanoid.Health > 0) then
            print("AutoFarmGold: Waiting for character/rootpart/humanoid...")
            task.wait(1)
            continue
        end

        local goldOreFolder = Workspace:FindFirstChild("WORKSPACE_Interactables")
                                :FindFirstChild("Mining")
                                :FindFirstChild("OreDeposits")
                                :FindFirstChild("Gold")

        if not goldOreFolder then
            warn("AutoFarmGold Error: Gold Ore folder path not found!")
            warn("Path searched: Workspace.WORKSPACE_Interactables.Mining.OreDeposits.Gold")
            _G.autoFarmGoldEnabled = false
            break
        end

        local children = goldOreFolder:GetChildren()
        if #children == 0 then
            task.wait(0.5)
            continue
        end

        local processedNode = false
        for _, oreInstance in ipairs(children) do
            if not _G.autoFarmGoldEnabled then break end

            local targetPart = nil
            if oreInstance:IsA("Model") then
                 targetPart = oreInstance.PrimaryPart or oreInstance:FindFirstChildWhichIsA("BasePart")
            elseif oreInstance:IsA("BasePart") then
                 targetPart = oreInstance
            end

             if not targetPart then
                 targetPart = oreInstance:FindFirstAncestorWhichIsA("BasePart")
             end


            if targetPart and targetPart.CFrame then
                 rootPart.CFrame = targetPart.CFrame * CFrame.new(0, 3.5, 0)
                 task.wait(0.2)

                 if not _G.autoFarmGoldEnabled then break end

                 local clickDetector = targetPart:FindFirstChildOfClass("ClickDetector")
                 local prompt = targetPart:FindFirstChildOfClass("ProximityPrompt")
                 local interacted = false

                 if clickDetector then
                     if fireclickdetector then
                         fireclickdetector(clickDetector)
                         interacted = true
                         print("AutoFarmGold: Fired ClickDetector on " .. targetPart.Name)
                     else
                         warn("AutoFarmGold Error: 'fireclickdetector' function not available in your executor!")
                         _G.autoFarmGoldEnabled = false; break
                     end
                 elseif prompt then
                      if fireproximityprompt then
                          fireproximityprompt(prompt)
                          interacted = true
                          print("AutoFarmGold: Fired ProximityPrompt on " .. targetPart.Name)
                      else
                          warn("AutoFarmGold Error: 'fireproximityprompt' function not available in your executor!")
                          _G.autoFarmGoldEnabled = false; break
                      end
                 end

                 if interacted then
                     processedNode = true
                     task.wait(0.5)
                 else
                     task.wait(0.1)
                 end

            else
                 task.wait(0.05)
            end
        end
        if not processedNode then
        end
        task.wait(0.1)
    end
    print("AutoFarmGold: Coroutine Stopped.")
    StarterGui:SetCore("SendNotification", { Title = "Auto Farm", Text = "Gold farming stopped.", Duration = 3 })
end


local ToggleFarm = FarmSection:CreateToggle({
    Name = "Auto Farm Gold Ore",
    CurrentValue = _G.autoFarmGoldEnabled,
    Flag = "ToggleAutoFarmGold",
    Callback = function(Value)
        _G.autoFarmGoldEnabled = Value
        print("Auto Farm Gold Ore Toggled:", Value)
        if Value then
            task.spawn(AutoFarmGold)
            StarterGui:SetCore("SendNotification", { Title = "Auto Farm", Text = "Gold farming started!", Duration = 3 })
        else
        end
    end,
})

local TeleportTab = Window:CreateTab("🏝 Teleports", nil)
local TeleportSection = TeleportTab:CreateSection("Locations")

local function TeleportPlayer(targetPosition, locationName)
    local player = LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if rootPart and humanoid and humanoid.Health > 0 and targetPosition then
        rootPart.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 3, 0)
        print("Teleported to " .. locationName)
        StarterGui:SetCore("SendNotification", {
            Title = "Teleport", Text = "Teleported to " .. locationName .. ".", Duration = 3
        })
    else
        print("Teleport failed: Character/RootPart not found, player dead, or targetPosition invalid.")
        StarterGui:SetCore("SendNotification", {
            Title = "Teleport Failed", Text = "Could not teleport to " .. locationName .. ".", Duration = 5
        })
    end
end

local Button1 = TeleportSection:CreateButton({
    Name = "Bronze City (Mayor)",
    Callback = function()
        local mayorNpc = Workspace:FindFirstChild("WORKSPACE_Interactables", true)
                         :FindFirstChild("NPCs", true)
                         :FindFirstChild("DonationMayor", true)
        local targetPart = mayorNpc and mayorNpc:FindFirstChild("Head")

        if targetPart and targetPart:IsA("BasePart") then
            TeleportPlayer(targetPart.Position, "Bronze City (Mayor)")
        else
            warn("Bronze City Teleport Error: Could not find DonationMayor's Head part.")
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport Failed", Text = "Could not find Bronze City target.", Duration = 5
            })
        end
    end,
})

local Button2 = TeleportSection:CreateButton({
    Name = "Puerto Dorado (Not Implemented)",
    Callback = function()
        print("Puerto Dorado button clicked - no teleport logic added yet.")
        StarterGui:SetCore("SendNotification", {
            Title = "Teleport Info", Text = "Puerto Dorado teleport not yet implemented.", Duration = 5
        })
    end,
})

local Button3 = TeleportSection:CreateButton({
    Name = "Reservation Camp (Not Implemented)",
    Callback = function()
        print("Reservation Camp button clicked - no teleport logic added yet.")
         StarterGui:SetCore("SendNotification", {
            Title = "Teleport Info", Text = "Reservation Camp teleport not yet implemented.", Duration = 5
        })
    end,
})

local MiscTab = Window:CreateTab("🎲 Misc", nil)
local EspSection = MiscTab:CreateSection("Player ESP")

_G.espEnabled = false
local espLoopConnection = nil
local playerHighlights = {}

local function UpdateESP()
    if not _G.espEnabled then return end

    local currentPlayers = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            currentPlayers[player] = true
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if character and humanoid and humanoid.Health > 0 then
                local highlight = playerHighlights[player]
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_Highlight_" .. player.Name
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.FillTransparency = 0.7
                    highlight.OutlineColor = Color3.fromRGB(0, 100, 0)
                    highlight.OutlineTransparency = 0.2
                    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                    highlight.Enabled = true
                    highlight.Parent = CoreGui
                    playerHighlights[player] = highlight
                    print("Created ESP Highlight for", player.Name)
                end
                 if highlight.Parent ~= CoreGui then highlight.Parent = CoreGui end
                 highlight.Adornee = character
                 highlight.Enabled = true
            else
                if playerHighlights[player] then
                    playerHighlights[player].Enabled = false
                    playerHighlights[player].Adornee = nil
                end
            end
        end
    end

     for player, highlight in pairs(playerHighlights) do
         if not currentPlayers[player] then
             print("Removing ESP Highlight for left player:", player.Name)
             highlight:Destroy()
             playerHighlights[player] = nil
         end
     end
end

local EspToggle = EspSection:CreateToggle({
    Name = "Enable Player ESP (Highlight)",
    CurrentValue = _G.espEnabled,
    Flag = "ToggleESP",
    Callback = function(Value)
        _G.espEnabled = Value
        print("Player ESP Toggled:", Value)

        if Value then
            if not (espLoopConnection and espLoopConnection.Connected) then
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
                print("ESP Update Loop Disconnected.")
            end
            print("Disabling all ESP Highlights.")
            for player, highlight in pairs(playerHighlights) do
                highlight:Destroy()
            end
            playerHighlights = {}
        end
         StarterGui:SetCore("SendNotification", { Title = "ESP", Text = "Player ESP " .. (Value and "Enabled" or "Disabled"), Duration = 3 })
    end,
})

Players.PlayerRemoving:Connect(function(player)
    if playerHighlights[player] then
        print("Cleaning up ESP Highlight for leaving player:", player.Name)
        playerHighlights[player]:Destroy()
        playerHighlights[player] = nil
    end
end)

local AimTab = Window:CreateTab("⚔️ Combat", nil)
local AimSection = AimTab:CreateSection("Aim Assist")

_G.aimbotEnabled = false
local aimbotFOV = 50
local aimbotLoopConnection = nil
local fovCircle = nil
local Camera = Workspace.CurrentCamera

local FOVSlider = AimSection:CreateSlider({
    Name = "FOV Size (Radius)",
    Range = {10, 300},
    Increment = 5,
    Suffix = "px",
    CurrentValue = aimbotFOV,
    Flag = "aimfovslider",
    Callback = function(Value)
        aimbotFOV = Value
        if fovCircle then
            fovCircle.Radius = aimbotFOV
        end
    end,
})

local function AimbotLoop()
    if not _G.aimbotEnabled or not Camera or not LocalPlayer then return end

    local ViewportSize = Camera.ViewportSize
    local CenterScreen = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)

    if Drawing and Drawing.new then
        if not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Color = Color3.fromRGB(255, 0, 0)
            fovCircle.Thickness = 1
            fovCircle.NumSides = 40
            fovCircle.Filled = false
            fovCircle.Radius = aimbotFOV
            fovCircle.Visible = true
            print("Aimbot: Created FOV Circle")
        end
        fovCircle.Position = CenterScreen
        fovCircle.Visible = _G.aimbotEnabled
        fovCircle.Radius = aimbotFOV
    elseif fovCircle then
        fovCircle.Visible = false
    end

    local currentTargetHead = nil
    local minDist = aimbotFOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local head = character and character:FindFirstChild("Head")

            if head and humanoid and humanoid.Health > 0 then
                local headPos3D = head.Position
                local screenPosVec3, onScreen = Camera:WorldToViewportPoint(headPos3D)

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
    CurrentValue = _G.aimbotEnabled,
    Flag = "aimbottoggle",
    Callback = function(Value)
        _G.aimbotEnabled = Value
        print("Aimbot Toggled:", Value)
        Camera = Workspace.CurrentCamera

        if Value then
            if not (aimbotLoopConnection and aimbotLoopConnection.Connected) then
                aimbotLoopConnection = RunService.RenderStepped:Connect(AimbotLoop)
                print("Aimbot Loop Connected.")
            end
             AimbotLoop()
             if fovCircle then fovCircle.Visible = true end
        else
            if aimbotLoopConnection and aimbotLoopConnection.Connected then
                aimbotLoopConnection:Disconnect()
                aimbotLoopConnection = nil
                print("Aimbot Loop Disconnected.")
            end
            if fovCircle then
                fovCircle.Visible = false
                print("Aimbot FOV Circle Hidden.")
            end
        end
         StarterGui:SetCore("SendNotification", { Title = "Aimbot", Text = "Aim Assist " .. (Value and "Enabled" or "Disabled"), Duration = 3 })
    end,
})

