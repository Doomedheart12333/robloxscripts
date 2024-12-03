local INVISIBLEWALLS = workspace.Ignore.MapCollisions.GeneralBlockers.OutsideWallCollider:GetChildren()

for _, Wall in pairs(INVISIBLEWALLS) do
    if Wall.CanCollide == true then
      Wall.CanCollide = false
    elseif Wall.CanCollide == false then
      Wall.CanCollide = true
    else
      print("Nil Value Likely")
    end
end
