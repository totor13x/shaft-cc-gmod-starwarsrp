hook.Add( "Think", "SWRP::YawHeadNW.Think", function()
    for _, ply in pairs( player.GetAll() ) do -- Change to visible
        if ply:GetNWAngle("YawHeadRotate") ~= Angle(0,0,0) then
            if LocalPlayer() == ply && SWRP.Thirdperson.Enabled:GetBool() != true then continue end

            ply.AngleYawHead = LerpAngle( 0.5, ply.AngleYawHead or Angle(0,0,0),ply:GetNWAngle("YawHeadRotate") )
            
            ply:ManipulateBoneAngles( ply:LookupBone( "ValveBiped.Bip01_Head1" ), ply.AngleYawHead )
        end
    end
end )