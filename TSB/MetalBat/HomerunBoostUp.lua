local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ensure the player has the "Character" attribute set to "Cyborg"
if player:GetAttribute("Character") ~= "Batter" then
    StarterGui:SetCore("SendNotification", {
        Title = "Character Required",
        Text = "Please equip the Brutal Demon character to use this feature.",
        Duration = 3,
    })
    return
end

local inputConnection

local function onCharacterDied()
    if inputConnection then
        inputConnection:Disconnect()
    end
end

local humanoid = character:FindFirstChild("Humanoid")
if humanoid then
    humanoid.Died:Connect(onCharacterDied)
end

-- Boost logic
local boostForce = 105 -- Adjust the strength of the boost
local cooldownDuration = 5 -- Cooldown time in seconds
local isOnCooldown = false

inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.One then
        -- Check for cooldown
        local cooldownPath = player:FindFirstChild("PlayerGui")
            and player.PlayerGui:FindFirstChild("Hotbar")
            and player.PlayerGui.Hotbar:FindFirstChild("Backpack")
            and player.PlayerGui.Hotbar.Backpack:FindFirstChild("Hotbar")
            and player.PlayerGui.Hotbar.Backpack.Hotbar:FindFirstChild("1")
            and player.PlayerGui.Hotbar.Backpack.Hotbar["1"]:FindFirstChild("Base")
            and player.PlayerGui.Hotbar.Backpack.Hotbar["1"].Base:FindFirstChild("Cooldown")

        if cooldownPath then
            return -- Ability is on cooldown; exit function
        end

        -- Boost logic
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            -- Apply a strong velocity upwards
            wait(0.4)
            rootPart.Velocity = Vector3.new(0, boostForce, 0)

            -- Set cooldown
            isOnCooldown = true
            task.delay(cooldownDuration, function()
                isOnCooldown = false
            end)
        end
    end
end)
