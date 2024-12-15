local playerGui = game.Players.LocalPlayer.PlayerGui

local function barcheatslol()
    local reel = playerGui:FindFirstChild("reel")
    if reel and reel:FindFirstChild("bar") and reel.bar:FindFirstChild("fish") then
        local fishpos = reel.bar.fish.Position
        if reel.bar:FindFirstChild("playerbar") then
            reel.bar.playerbar.Position = fishpos
        end
    end
end

-- Run it continuously but use RenderStepped for efficiency
game:GetService("RunService").RenderStepped:Connect(function()
    barcheatslol()
end)
