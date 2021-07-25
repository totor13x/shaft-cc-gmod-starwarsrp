concommand.Add("jetpack_enable", function(ply)
	local JetIsOn = ply:GetNWBool("JetEnabled")
    if !SWRP.Ranks:DGetPrivPly(ply, "JUST_I_WANT_TO_FLY") then return end
    if JetIsOn then
        ply:EmitSound("hl1/fvox/deactivated.wav")
        ply:StopSound("RocketThrust")
        ply:SetNWBool("JetEnabled", false)
		netstreamSWRP.Start( ply, "GM:Notification", {
            text = "Джетпак отключен",
            type = NOTIFY_GENERIC,
            length = 3
        } )
    else
        ply:EmitSound("hl1/fvox/activated.wav")
        ply:SetNWBool("JetEnabled", true)

		netstreamSWRP.Start( ply, "GM:Notification", {
            text = "Джетпак активирован",
            type = NOTIFY_GENERIC,
            length = 3
        } )
    end
end)


local ba, bn = bit.band, bit.bnot
hook.Add("SetupMove", "Player.JetpackVind",function( ply, mv, cmd )
    if not ply:Alive() or ply:InVehicle() then return end
    local ButtonData = cmd:GetButtons()
    
    if ba( ButtonData, IN_JUMP ) > 0 and ply:GetNWBool("JetEnabled") then
        //print('asd')
        //cmd:SetButtons( ba( ButtonData, bn( IN_JUMP ) ) )
        
        ply:LagCompensation( true )
            //print(!ply:IsOnGround())
        if ( !ply:IsOnGround() ) then
            local vel = mv:GetVelocity()
            if vel.z < 0 then
                vel.z = vel.z/1.2
            end
            mv:SetVelocity(vel +ply:GetUp() * 10 )
            ply:EmitSound("RocketThrust")
            if (ply:GetNWFloat("NextJetEffect") or 0)<CurTime() then
                local fx = EffectData()
                fx:SetEntity(ply)
                util.Effect("swrp_jetpack_steam", fx, true, true)
                ply:SetNWFloat("NextJetEffect", CurTime()+0.95)
            end
        end
        ply:LagCompensation( false )
        return
    end
    //if ply:IsOnGround() then
        ply:StopSound("RocketThrust")
    //end
end )
