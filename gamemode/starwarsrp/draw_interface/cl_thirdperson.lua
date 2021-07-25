SWRP.Thirdperson = {}
SWRP.Thirdperson.Enabled = CreateClientConVar("swrp_thirdperson_enabled", 0, true, false)
SWRP.Thirdperson.Dist = 100
SWRP.Thirdperson.DistR = 0
SWRP.Thirdperson.Nije = 15
SWRP.Thirdperson.VR = 0
SWRP.Thirdperson.VF = 0
hook.Add("CreateMove",'CheckClientsideKeyBinds', function()
	if input.WasKeyPressed(KEY_F1) then
		RunConsoleCommand("swrp_toggle_thirdperson")
	end	
end)

concommand.Add("swrp_toggle_thirdperson", function(ply)
	if GetConVarNumber("swrp_thirdperson_enabled") == 0 then
		ply:ConCommand("swrp_thirdperson_enabled 1")
	else
		ply:ConCommand("swrp_thirdperson_enabled 0")
	end
end)


local function CalcViewThirdPerson( ply, pos, ang, fov, nearz, farz )
		-- test for thirdperson scoped weapons

	if SWRP.Thirdperson.Enabled:GetBool() == true and ply:Alive() and (ply:Team() ~= TEAM_SPECTATOR) then
		local view = {}

		local newpos = Vector(0,0,0)
		local dist = SWRP.Thirdperson.Dist
		local distR = SWRP.Thirdperson.DistR
		local nije = SWRP.Thirdperson.Nije
		
		local vR = SWRP.Thirdperson.VR
		local vF = SWRP.Thirdperson.VF
		local iai = false
		/* First */
		if iai then
			dist = -100
			nije = -9
			vR = 180
			vF = 180
		end
		local tr = util.TraceHull(
			{
			start = pos, 
			endpos = pos + ang:Forward()*-dist + Vector(0,0,nije) + ang:Right()*distR+ ang:Up(),
			mins = Vector(-5,-5,-5),
			maxs = Vector(5,5,5),
			filter = player.GetAll(),
			mask = MASK_SHOT_HULL
			
		})

		newpos = tr.HitPos
		view.origin = newpos

		local newang = ang
		newang:RotateAroundAxis( ply:EyeAngles():Right(), vR )
		newang:RotateAroundAxis( ply:EyeAngles():Up(), 0 )
		newang:RotateAroundAxis( ply:EyeAngles():Forward(), vF )

		view.angles = newang
		view.fov = fov



		--print( tracedist )

		return view
	end

end
hook.Add("SWRP::CalcView", "SWRP::Thirdperson", CalcViewThirdPerson )