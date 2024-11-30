local player = game.Players.LocalPlayer
local freecamScript = player.Character and player.Character:WaitForChild("CharacterHandler"):WaitForChild("Freecam"):WaitForChild("FreecamScript")

if freecamScript then
    freecamScript.Enabled = true
end

if player then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Executed",    -- Title of the notification
        Text = "Freecam has been enabled, press SHIFT+P to Toggle",  -- Message text
        Icon = "rbxassetid://123456789",  -- Optional: You can specify an icon (replace the ID)
        Duration = 3,  -- How long the notification will stay visible (in seconds)
    })
end
