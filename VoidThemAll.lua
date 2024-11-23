local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ensure the player has the "Character" attribute set to "Hero Hunter"
if player:GetAttribute("Character") ~= "Hunter" then
    -- Send a notification to the player
    StarterGui:SetCore("SendNotification", {
        Title = "Character Required",
        Text = "Please equip the Hero Hunter character to use this feature.",
        Duration = 3, -- Notification stays for 3 seconds
    })
    return
end

-- Inform the player that the feature is active
StarterGui:SetCore("SendNotification", {
    Title = "Working.",
    Text = "Use Flowing Water on anyone to sentence them to the void (this also kills you).",
    Duration = 3, -- Notification stays for 3 seconds
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end  -- Ignore if input is processed by the game
    if input.KeyCode == Enum.KeyCode.One then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            StarterGui:SetCore("SendNotification", {
                Title = "ALERT",
                Text = "Re-run the script for this to work again.",
                Duration = 3, -- Notification stays for 3 seconds
            })
            wait(0.6) -- Wait for 0.6 seconds before moving
            rootPart.CFrame = rootPart.CFrame + Vector3.new(1000, -770, 1000)
        end
    end
end)
