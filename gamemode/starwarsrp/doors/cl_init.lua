print("cl doors")
SWRP.Doors = SWRP.Doors or {}
//SWRP.Doors.TempData = SWRP.Doors.TempData or {}
TempData = TempData or {}
netstreamSWRP.Hook("SWRP::DoorsSync", function(data)
	TempData = data
end)

hook.Add("Cursor::Cam3D2D", "Tools::DoorSetup", function(pos, ang)
	local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent) and ent:GetNWInt("MapEntityID") != 0 then
		if (TempData and TempData[ent:GetNWInt("MapEntityID")]) then
		local infoDoor = TempData[ent:GetNWInt("MapEntityID")]
		local text = ""
		
		//if ang.z == 180 then return end -- hz, mojet tak
		//ang:RotateAroundAxis( ang:Right(), 90 )
		//ang:RotateAroundAxis( ang:Up(), 90 )
		//ang:RotateAroundAxis( ang:Forward(), -90 )
		//ang:Normalize()
		//PrintTable(ang)
		//ang.x = 0
		//ang.y = angadd.y
		//ang.z = 0
		local DostupK = 0
		local DostupKAll = 0
		cam.Start3D2D( pos, ang, 0.025 )
		cam.IgnoreZ(true)
			local y = -90
			//PrintTable(infoDoor.info)
			if infoDoor.info.roles then
				DostupKAll = DostupKAll + 1 
				local allowColor = Color(255,255,255)
				local data = SWRP.Roles:DRoleInfo(infoDoor.info.firstroles)
				draw.SimpleText( "Должность: ", "S_Bold_150", 0, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
				
				if infoDoor.info.roles[tonumber(GAMEMODE.Char.role)] then
					DostupK = DostupK + 1 
					allowColor = Color(175, 60, 60, 255)
				end
				
				draw.SimpleText( data.Name.." и выше", "S_Bold_150", 0, y, allowColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
				y = y - 150
			end
			if infoDoor.info.rank then
				local allowColor = Color(255,255,255)
				local data = SWRP.Ranks:GetRank(infoDoor.info.rank)
				if data then
					DostupKAll = DostupKAll + 1 
				
					if (tonumber(GAMEMODE.Char.rank) >= infoDoor.info.rank ) then
						DostupK = DostupK + 1
						allowColor = Color(175, 60, 60, 255)
					end
					
					draw.SimpleText( data.Name.." и выше", "S_Bold_150", 0, y, allowColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
					draw.SimpleText( "Звание: ", "S_Bold_150", 0, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
					y = y - 150
				end
			end
			if infoDoor.info.batalion then
				DostupKAll = DostupKAll + 1 
				local allowColor = Color(255,255,255)
				if (GAMEMODE.Char.batalion == infoDoor.info.batalion ) then
					DostupK = DostupK + 1
					allowColor = Color(175, 60, 60, 255)
				end
				draw.SimpleText( infoDoor.info.batalion, "S_Bold_150", 0, y, allowColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
				draw.SimpleText( "Батальон: ", "S_Bold_150", 0, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
				y = y - 150
			end
			if DostupK == DostupKAll then
				draw.SimpleText( string.upper("У Вас есть доступ"), "S_Bold_150", 0, y, Color(175, 60, 60, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
				y = y - 150
			else
				draw.SimpleText( string.upper("У Вас нет доступа"), "S_Bold_150", 0, y, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
				y = y - 150
			end
		cam.IgnoreZ(false)
		cam.End3D2D()
	end
	end
end)