local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- CHATTING
function chatMessage(str)
    str = tostring(str)
    if not isLegacyChat then
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
