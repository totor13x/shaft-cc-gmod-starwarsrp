netstreamSWRP.Hook("ChangeYawPos", function(ply, ang)
    ply.AngleYaw = ang
    ply:SetNWAngle("YawHeadRotate", ply.AngleYaw)
    ply.LastChange = CurTime()+1
end)

LastRun = 0
hook.Add("Think", "SWRP::RestoreYawHead", function()
    if (LastRun > CurTime()) then return end

    for _, ply in pairs( player.GetAll() ) do 
        if ply.AngleYaw ~= Angle(0,0,0) && ((ply.LastChange or 0) < CurTime()) then
            ply.AngleYaw = Angle(0,0,0)
            ply:SetNWAngle("YawHeadRotate", Angle(0,0,0))
        end
    end
    LastRun = CurTime()+0.5
end)