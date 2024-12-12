-- Clone and adjust the button
local player = game.Players.LocalPlayer
local inGameUI = player.PlayerGui:FindFirstChild("InGameUI")

if not inGameUI then
    warn("InGameUI not found!")
    return
end

local button = inGameUI:FindFirstChild("GK"):Clone()
button.Parent = inGameUI
button.Name = "SwitchTeam"
button.Position = UDim2.new(0.2, 0, 0.96, 0) -- Example position: center of the screen
button.Text.Text = "SWITCH TEAM"


-- Enlarge on hover, shrink when unhovered, and perform actions on click
if button:IsA("ImageButton") then
    local originalSize = button.Size
    local enlargedSize = originalSize + UDim2.new(0.1, 0, 0.1, 0) -- Slightly enlarge the size

    button.MouseEnter:Connect(function()
        button.Size = enlargedSize
    end)

    button.MouseLeave:Connect(function()
        button.Size = originalSize
    end)

    button.MouseButton1Click:Connect(function()
        local gui = player.PlayerGui:FindFirstChild("PickTeam")
        if gui then
            gui.Enabled = true
            gui.Return.Text.Text = "CLOSE"

			wait(0.0000001)

            if gui:FindFirstChild("AwayFull") and gui.AwayFull.Visible then
                gui.AwayFull.Visible = false
                gui.Away.Visible = true
            end

            if gui:FindFirstChild("HomeFull") and gui.HomeFull.Visible then
                gui.HomeFull.Visible = false
                gui.Home.Visible = true
            end
        else
            warn("PickTeam GUI not found!")
        end
    end)
end
