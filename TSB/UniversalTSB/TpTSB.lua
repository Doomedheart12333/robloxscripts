-- LocalScript
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()  -- Waits for character to load
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")  -- Ensure HumanoidRootPart exists
local playerGui = player:WaitForChild("PlayerGui")

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Create the main button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)  -- Size of the main button
button.Position = UDim2.new(0.5, -100, 0.5, -25)  -- Position in the center of the screen
button.Text = "Atomic Slash"  -- Text on the main button
button.Parent = screenGui

-- Create the second button (buttona)
local buttona = Instance.new("TextButton")
buttona.Size = UDim2.new(0, 200, 0, 50)  -- Size of the second button
buttona.Position = UDim2.new(0.5, -100, 0.5, 30)  -- Adjusted position below the first button
buttona.Text = "Death Counter"  -- Text on the second button
buttona.Parent = screenGui

-- Create the X button to close the GUI
local xButton = Instance.new("TextButton")
xButton.Size = UDim2.new(0, 50, 0, 50)  -- Size of the X button
xButton.Position = UDim2.new(0.5, -100, 0.5, -90)  -- Position at the top-right corner
xButton.Text = "X"  -- Text on the button
xButton.Parent = screenGui

-- Define the function that will run when the main "Atomic Slash" button is clicked
local function onButtonClick()
    humanoidRootPart.CFrame = workspace.Cutscenes.Atoms.Part.CFrame + Vector3.new(0, 10, 0)
end

-- Define the function that will run when the "Death Counter" button is clicked
local function onButtonClicka()
    -- Correcting the CFrame assignment here: Access the part's CFrame
    humanoidRootPart.CFrame = workspace.Cutscenes["Death Cutscene"].Fist.CFrame + Vector3.new(0, 10, 0)
end

-- Define the function that will close the GUI when the X button is clicked
local function onXButtonClick()
    screenGui:Destroy()  -- Destroys the entire GUI
end

-- Connect the functions to the button click events
button.MouseButton1Click:Connect(onButtonClick)
buttona.MouseButton1Click:Connect(onButtonClicka)
xButton.MouseButton1Click:Connect(onXButtonClick)
