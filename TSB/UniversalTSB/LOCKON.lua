-- LocalScript inside StarterPlayerScripts

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Settings
local lockKey = Enum.KeyCode.E  -- Key to press for lock-on
local lockDistance = 100  -- Maximum distance to detect humanoids

-- Variables for locked humanoid and the billboard GUI
local lockedHumanoid = nil
local billboardClone = nil

-- Create alert UI
local function createAlert(message)
    -- Create a ScreenGui if it doesn't already exist
    local screenGui = player:FindFirstChild("PlayerGui"):FindFirstChild("LockOnAlert")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "LockOnAlert"
        screenGui.Parent = player:FindFirstChild("PlayerGui")
        
        -- Create the text label for the alert message
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "AlertMessage"
        textLabel.Text = message
        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Red text color
        textLabel.TextSize = 18
        textLabel.Size = UDim2.new(0, 300, 0, 50)  -- Size of the message
        textLabel.Position = UDim2.new(0.85, 0, 0.9, 0)  -- Bottom right of the screen
        textLabel.BackgroundTransparency = 1  -- Transparent background
        textLabel.Parent = screenGui
        
        -- Make the alert disappear after 2 seconds
        wait(2)
        screenGui:Destroy()
    end
end

-- Function to find the nearest humanoid
local function getNearestHumanoid()
    local nearestHumanoid = nil
    local shortestDistance = lockDistance

    -- Loop through all characters in workspace.Live
    for _, obj in pairs(game.Workspace.Live:GetChildren()) do
        -- Check if the object is a model with a humanoid and not the player's own character
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= player.Character then
            local humanoid = obj:FindFirstChild("Humanoid")
            local primaryPart = obj.PrimaryPart
            if primaryPart then
                local distance = (camera.CFrame.Position - primaryPart.Position).Magnitude
                
                -- Debug: Print details of the humanoids being checked
                print("Checking humanoid: " .. obj.Name .. " at distance: " .. distance)

                -- Check if the humanoid is within range and closer than the previous closest
                if distance < shortestDistance then
                    nearestHumanoid = humanoid
                    shortestDistance = distance
                    print("Nearest humanoid updated to: " .. obj.Name .. " with distance: " .. distance)
                end
            else
                -- Print debug message if PrimaryPart is missing
                print("Humanoid " .. obj.Name .. " does not have a PrimaryPart!")
            end
        end
    end

    return nearestHumanoid
end

-- Lock on function
local function lockOnToHumanoid(humanoid)
    if humanoid and humanoid.Parent then
        -- Update the camera to focus on the humanoid's position
        print("Locking on to humanoid: " .. humanoid.Parent.Name)
        camera.CFrame = CFrame.new(camera.CFrame.Position, humanoid.Parent.PrimaryPart.Position)

        -- Clone and add the BillboardGui to the locked humanoid's head
        if not billboardClone then
            -- Clone the BillboardGui and attach it to the humanoid's head
            print("Cloning and attaching BillboardGui to humanoid's head.")
            billboardClone = workspace.Cutscenes.Billboard.BillboardGui:Clone()
            
            -- Attach to the head of the humanoid model (ensure it exists)
            local humanoidHead = humanoid.Parent:FindFirstChild("Head")
            if humanoidHead then
                billboardClone.Parent = humanoidHead  -- Parent the BillboardGui to the humanoid's head
                billboardClone.Enabled = true  -- Enable the BillboardGui
            else
                print("Humanoid does not have a Head part, attaching to HumanoidRootPart.")
                local humanoidRootPart = humanoid.Parent:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    billboardClone.Parent = humanoidRootPart  -- Fallback: Attach to HumanoidRootPart
                    billboardClone.Enabled = true
                else
                    print("Humanoid does not have a valid Head or HumanoidRootPart.")
                end
            end
        end
    end
end

-- Unlock function
local function unlockFromHumanoid()
    -- Remove the BillboardGui from the humanoid when unlocking
    if billboardClone then
        print("Unlocking from humanoid, destroying BillboardGui.")
        billboardClone:Destroy()
        billboardClone = nil
    end
end

-- Detect key press and lock on
UIS.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    -- Check if the user pressed the lock key
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == lockKey then
        print("Lock key pressed.")
        
        if lockedHumanoid then
            -- If already locked onto a humanoid, unlock
            print("Already locked on, unlocking.")
            unlockFromHumanoid()
            lockedHumanoid = nil  -- Reset the locked humanoid
        else
            -- If not locked, check if script is already running
            if lockedHumanoid then
                -- Alert the player that the lock-on is already active
                createAlert("Already Running Lock-On for PC")
                return  -- Don't proceed with locking a new target
            end

            -- If not locked, find the nearest humanoid and lock onto it
            print("Not locked on, finding nearest humanoid.")
            local nearestHumanoid = getNearestHumanoid()
            if nearestHumanoid then
                -- Lock on to the nearest humanoid
                print("Locking on to nearest humanoid.")
                lockedHumanoid = nearestHumanoid
                lockOnToHumanoid(lockedHumanoid)
            else
                print("No humanoid found within range.")
            end
        end
    end
end)

-- Update the camera to track the humanoid if it's locked on
game:GetService("RunService").RenderStepped:Connect(function()
    if lockedHumanoid and lockedHumanoid.Parent then
        -- Continuously update the camera to lock onto the humanoid's position
        -- Debug: Print every frame when the camera is tracking
        print("Tracking humanoid: " .. lockedHumanoid.Parent.Name)
        camera.CFrame = CFrame.new(camera.CFrame.Position, lockedHumanoid.Parent.PrimaryPart.Position)
    end
end)
