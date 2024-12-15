-- Get the mouse position (screen coordinates)
local mouse = game.Players.LocalPlayer:GetMouse()
local clicklocationx, clicklocationy = mouse.X, mouse.Y
local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui

@@ -23,24 +27,28 @@
            local button = shakeui:FindFirstChild("safezone") and shakeui.safezone:FindFirstChild("button")
            if button then
                button.Size = UDim2.new(10, 0, 10, 0)
				-- Simulate the mouse click event at the screen position
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(clicklocationx, clicklocationy, 0, true, game, 1)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(clicklocationx, clicklocationy, 0, false, game, 1)
 
            end

            -- Exit loop if shakeui is destroyed or no longer exists
            if not shakeui.Parent then
                break
            end

            task.wait(0.1) -- Reasonable wait time to avoid tight looping
        end

        -- Clean up when done
        sgui:Destroy()
    end
end

while true do 
  if playerGui:FindFirstChild("shakeui") then
        makeButtonBigger()
  end
task.wait(0.0001)
end
