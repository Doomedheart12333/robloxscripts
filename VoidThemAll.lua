local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ensure the player has the "Character" attribute set to "Hunter"
if player:GetAttribute("Character") ~= "Hunter" then
    StarterGui:SetCore("SendNotification", {
        Title = "Character Required",
        Text = "Please equip the Hero Hunter character to use this feature.",
        Duration = 3,
    })
    return
end

StarterGui:SetCore("SendNotification", {
    Title = "Working.",
    Text = "Use Flowing Water on anyone to sentence them to the void (this also kills you).",
    Duration = 3,
})

local inputConnection

local function onCharacterDied()
    if inputConnection then
        inputConnection:Disconnect()
        StarterGui:SetCore("SendNotification", {
            Title = "Script Disabled",
            Text = "The script has been disabled because you died.",
            Duration = 3,
        })
    end
end

local humanoid = character:FindFirstChild("Humanoid")
if humanoid then
    humanoid.Died:Connect(onCharacterDied)
end

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
            StarterGui:SetCore("SendNotification", {
                Title = "On Cooldown",
                Text = "This ability is on cooldown. Please wait.",
                Duration = 3,
            })
            return
        end

        -- Teleport logic
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local originalCFrame = rootPart.CFrame

            wait(0.6)
            rootPart.CFrame = rootPart.CFrame + Vector3.new(1000, -770, 1000)

            wait(1.5)
            rootPart.CFrame = originalCFrame
        end
    end
end)
