--Variables
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local characterz = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local Camera = game.Workspace.CurrentCamera
local rootPart = character:WaitForChild("HumanoidRootPart")
local animator = humanoid:WaitForChild("Animator")
local UserInputService = game:GetService("UserInputService")

-- CHATTING
local isNewChatSystem = pcall(function()
    return TextChatService.TextChannels
end)

if isNewChatSystem then
    print("Using the new TextChatService system.")
else
    local legacyChatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if legacyChatEvent and legacyChatEvent:FindFirstChild("SayMessageRequest") then
        print("Using the legacy chat system.")
    else
        print("No recognized chat system is in use.")
    end
end


function chatMessage(str)
    str = tostring(str)
    local isNewChatSystem = pcall(function()
        return TextChatService.TextChannels
    end)

    if isNewChatSystem then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

-- TWEENING
local function isValidVector3(position)
    if typeof(position) == "Vector3" then
        return true
    else
        print("Not Vector3.new() - Invalid Position")
        return false
    end
end

-- Smooth Teleport without tweening (manual movement)
local function smoothTeleport(targetPosition, speed)
    -- Check if the targetPosition is a valid Vector3
    if not isValidVector3(targetPosition) then
        return
    end

    -- Store the initial position of the humanoid root part
    local currentPos = humanoidRootPart.Position
    local distance = (targetPosition - currentPos).Magnitude

    -- Disable movement by setting the humanoid to not move (optional)
    humanoidRootPart.Anchored = true

    -- Loop until the player reaches the target position
    while distance > 0.1 do  -- You can set a threshold for when to stop
        -- Calculate the direction vector and move towards the target
        local direction = (targetPosition - currentPos).unit  -- Normalize the direction
        humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(direction * speed * game:GetService("RunService").Heartbeat:Wait())  -- Move towards the target position
        currentPos = humanoidRootPart.Position
        distance = (targetPosition - currentPos).Magnitude  -- Update the distance to the target
    end

    -- Once at the target, snap to the exact target position
    humanoidRootPart.CFrame = CFrame.new(targetPosition)

    -- Re-enable movement after teleportation
    humanoidRootPart.Anchored = false
end

-- TELEPORTING (Instant)
local function teleportPlayer(targetPosition)
    if typeof(targetPosition) == "CFrame" then
        humanoidRootPart.CFrame = targetPosition
    else
        print("Invalid CFrame - teleport failed")
    end
end
local function offSET(offset)
    -- Get the player's character
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Ensure the character has a humanoid root part
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Apply the offset to the player's CFrame
    humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(offset)
end

--TURNING
function CardinalDirections(direction)
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local directionVector

        -- Set the direction vector based on the input
        if direction == "North" then
            directionVector = Vector3.new(0, 0, -1) -- North is -Z
        elseif direction == "South" then
            directionVector = Vector3.new(0, 0, 1) -- South is +Z
        elseif direction == "East" then
            directionVector = Vector3.new(1, 0, 0) -- East is +X
        elseif direction == "West" then
            directionVector = Vector3.new(-1, 0, 0) -- West is -X
        else
            warn("Invalid direction!")
            return
        end

        -- Set the player's orientation to face the chosen direction
        humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + directionVector)
    else
        warn("HumanoidRootPart not found!")
    end
end
local function TurnDegrees(turnammount)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Get the player's current facing direction (Orientation)
    local currentOrientation = humanoidRootPart.CFrame.LookVector

    -- Calculate the current angle (in degrees) from the LookVector
    local currentAngle = math.atan2(currentOrientation.Z, currentOrientation.X) * (180 / math.pi)

    -- Turn the player by 90 degrees
    local newAngle = currentAngle + turnammount

    -- Normalize the new angle (make sure it's between 0 and 360 degrees)
    newAngle = newAngle % 360

    -- Calculate the new LookVector based on the new angle
    local newLookVector = Vector3.new(math.cos(math.rad(newAngle)), 0, math.sin(math.rad(newAngle)))

    -- Update the player's orientation
    humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + newLookVector)
end
--DIE
local function Reset()
     humanoid.Health = 0  -- Set health to 0 to "reset" the character
end
--Parts!
local function deleteObject(objectName)
    -- Wait for the object to exist in the Workspace
    local object = game.Workspace:WaitForChild(objectName)
    
    -- Delete the object if it exists
    if object then
        object:Destroy()
    else
        print("Object not found: " .. objectName)
    end
end
--FUN
local function sitPlayer()
    -- Get the player's character
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Ensure the character has a humanoid
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Set the Sit property to true to make the player sit
    humanoid.Sit = true
end
local function makePlayerJump()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000) -- Apply large force to ensure jump
    bodyVelocity.Velocity = Vector3.new(0, humanoid.JumpPower, 0) -- Apply upward velocity
    bodyVelocity.Parent = rootPart

    game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
end
local function playAnimation(animationId)
    -- Create a new Animation object
    local animation = Instance.new("Animation")
    
    -- Set the AnimationId to the provided animation ID
    animation.AnimationId = "rbxassetid://" .. animationId

    local track = animator:LoadAnimation(animation)

    track:Play()
end
local function stopAllAnimations(humanoid)
    if humanoid then
        local animator = humanoid:FindFirstChild("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end
    end
end

function OnKeyPressed(keyCode, userFunction)
    -- Detect key press to trigger the function
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end  -- Ignore if the game already processed the input (e.g., for UI interactions)

        if input.KeyCode == keyCode then  -- Check if the selected key is pressed
            userFunction()  -- Execute the provided function when the key is pressed
        end
    end)
end
