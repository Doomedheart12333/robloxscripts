--Blue Lock Game Destroyer (makes unplayable if scores are tied lol)

local player = game.Players.LocalPlayer

if workspace.Football then
    player.Character:WaitForChild("Torso").CFrame = workspace.Football.Hitbox.CFrame
end

wait(0.1)
player.Character:WaitForChild("Torso").CFrame = CFrame.new(0, 69696969, 0)
wait(0.15)
player.Character:WaitForChild("Humanoid").Health = 0
