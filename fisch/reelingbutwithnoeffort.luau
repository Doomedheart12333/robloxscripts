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

-- Run it continuously with a while true do loop (this is a true do loop now because of performance issuses?)
coroutine.wrap(function()
    while true do
        barcheatslol()
        task.wait() -- Wait for a frame to prevent freezing the game
    end
end)()
