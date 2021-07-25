print('sv hands')

local validDoors = {func_door = true, func_door_rotating = true, prop_door_rotating = true}

//hook.Add("InitPostEntity", "LoadDoors", function()
	-- for i,v in pairs(ents.GetAll()) do
		-- if IsValid(v) and validDoors[v:GetClass()] then
			-- PrintTable(v:GetKeyValues()) 
			-- v:HasSpawnFlags(
		-- end
	-- end
//end)

hook.Add("AcceptInput", "DoorsFix", function(ent, name, activator, caller, data)
	//if IsValid(ent) and validDoors[ent:GetClass()] then
	//		print(activator)
	//		print(caller)
	//		print(data)
	//end
end)

hook.Add("PlayerUse", "PropFix", function(ply, ent)
	
end)