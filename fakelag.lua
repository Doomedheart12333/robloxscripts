-- Adjustable lag parameters
local lagDelay = 0 -- Delay between movement updates (in seconds)
local lagStutter = 0 -- Random stutter amount (0 to 1 or higher)


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local runService = game:GetService("RunService")

-- Store original CFrame positions and rotations to simulate lag
local lastPosition = character.HumanoidRootPart.CFrame
local lastRotation = character.HumanoidRootPart.CFrame.LookVector

-- Function to simulate lag
local function simulateLag()
    while true do
        -- Randomize stutter (can make the lag appear more erratic)
        local randomStutter = math.random() * lagStutter

        -- Apply delayed movement by adjusting position with a slight delay
        local newPosition = character.HumanoidRootPart.CFrame:Lerp(lastPosition, randomStutter)
        character.HumanoidRootPart.CFrame = newPosition

        -- Apply delayed rotation with a slight delay
        local currentRotation = character.HumanoidRootPart.CFrame.LookVector
        local rotationDelta = currentRotation - lastRotation
        local stutteredRotation = lastRotation + rotationDelta * randomStutter
        
        -- This will make the rotation appear more exaggerated if `randomStutter` > 1
        character.HumanoidRootPart.CFrame = CFrame.lookAt(newPosition.Position, newPosition.Position + stutteredRotation)

        -- Update the last known position and rotation
        lastPosition = character.HumanoidRootPart.CFrame
        lastRotation = currentRotation

        -- Wait for the next update, introducing the "lag"
        wait(lagDelay + randomStutter)
    end
end

-- Start simulating the lag when the player moves
runService.Heartbeat:Connect(function()
    simulateLag()
end)
