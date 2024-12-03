local INVISIBLEWALLS = workspace.Ignore.MapCollisions.GeneralBlockers.OutsideWallCollider:GetChildren()

for _, Wall in pairs(INVISIBLEWALLS) do
    Wall.Transparency = 0.8
    Wall.Color = Color3.new(0.25, 0.27, 0.9)
end
