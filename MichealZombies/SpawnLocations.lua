local SpawnLocations = workspace.Ignore._Spawns.Zombie.Map:GetChildren()

for _, spawn in pairs(SpawnLocations) do
    spawn.Transparency = 0
    local HIGHLIGHTSPAWN = Instance.new("Highlight")
    HIGHLIGHTSPAWN.FillColor = Color3.fromRGB(255, 0, 0)
    HIGHLIGHTSPAWN.Parent = spawn -- Assigns the highlight to the individual spawn
end
