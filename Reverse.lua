local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local actions = {}
local timeLimit = 10 -- seconds to track
local keyToPress = Enum.KeyCode.Z -- Change this to the key you want to press
local isReversing = false -- Flag to check if we're in the process of reversing
local tweenService = game:GetService("TweenService")
local animationTracks = {} -- Store current animation tracks

-- Function to track the player's position and CFrame
local function recordAction()
    if isReversing then return end

    local currentTime = tick() -- Get the current time
    local cframe = character.PrimaryPart.CFrame -- Record the CFrame (position and rotation)
    table.insert(actions, {cframe = cframe, time = currentTime})

    -- Remove actions older than the timeLimit
    for i = #actions, 1, -1 do
        if actions[i].time < currentTime - timeLimit then
            table.remove(actions, i)
        end
    end

    -- Track active animations
    animationTracks = {}
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        table.insert(animationTracks, {track = track, timePosition = track.TimePosition, speed = track.PlaybackSpeed})
    end
end

-- Function to reverse the player's CFrame actions and animations (faster tweens)
local function reverseActions()
    if isReversing then return end -- Prevent multiple reversals

    isReversing = true
    local currentTime = tick()
    local reversed = false

    -- Reverse actions for the last 10 seconds
    for i = #actions, 1, -1 do
        if actions[i].time > currentTime - timeLimit then
            -- Calculate the distance to the target CFrame
            local targetCFrame = actions[i].cframe
            local distance = (targetCFrame.Position - character.PrimaryPart.Position).Magnitude
            
            -- Set a fixed short duration for the tween (adjust to make faster or slower)
            local fastDuration = math.max(0.00001, 0.00001)  -- 0.1 sec minimum duration
            
            -- Use a fast tween to smoothly move the character back to the previously recorded CFrame
            local tweenInfo = TweenInfo.new(fastDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local tween = tweenService:Create(character.PrimaryPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
            tween.Completed:Wait() -- Wait for the tween to complete before continuing
            reversed = true
        else
            break
        end
    end

    -- Reverse the animationswd
    for _, trackData in ipairs(animationTracks) do
        local track = trackData.track
        -- Reverse the animation by changing the playback speed and time position
        track:Stop() -- Stop the animation
        track:Play() -- Restart it
        track.PlaybackSpeed = -trackData.speed  -- Reverse playback speed
        track.TimePosition = trackData.timePosition -- Set the position to where it was when recorded
    end

    if reversed then
        -- Optional: Add a brief pause after the reversal for clarity
        wait(0.00001)
    end

    isReversing = false
end

-- Key press listener
local function onKeyPress(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keyToPress then
        reverseActions()
    end
end

-- Game loop: record actions continuously
game:GetService("RunService").Heartbeat:Connect(function()
    recordAction()
end)

-- Connect the key press event
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)
