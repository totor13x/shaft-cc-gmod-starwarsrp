print('sv doors')
SWRP.Doors = SWRP.Doors or {}
SWRP.Doors.List = SWRP.Doors.List or {}

local validDoors = {func_door = true, func_door_rotating = true, prop_door_rotating = true}

local function syncDoors(ply)
	//print('------44')
	local data = {}  
	if SWRP.Doors.List[game.GetMap()] then 
		for i,v in pairs(SWRP.Doors.List[game.GetMap()]) do
			local ent = ents.GetMapCreatedEntity( i )
			if IsValid(ent) then
				data[i] = {}
				data[i]['info'] = v 
				
				data[i]['posang'] = {} 
			
				data[i]['posang']['pos'] = ent:GetPos()
				data[i]['posang']['ang'] = ent:GetAngles()
				ent:SetNWInt("MapEntityID", i)
			end
			//print(Entity(i))   
			//print(i,v)
			//PrintTable(data)
		end
		if ply then
			netstreamSWRP.Heavy(ply, "SWRP::DoorsSync", data)
		end
	end
end

function SWRP.Doors.Save()
	file.Write("batalions/doors.txt", util.TableToJSON(SWRP.Doors.List))
	
	syncDoors(player.GetAll())
end

hook.Add("PlayerInitialSpawn", "Doors::LoadClient", function(ply)
	syncDoors(ply)
end)

hook.Add("serverguard.RanksLoadedShared", "Doors::Load", function()
	
	SWRP.Doors.List = util.JSONToTable(file.Read("batalions/doors.txt") or "[]")
	SWRP.Doors.List[game.GetMap()] = SWRP.Doors.List[game.GetMap()] or {}
	syncDoors(player.GetAll())
end)

timer.Simple(0, function()
syncDoors(Entity(1))  
end)


hook.Add('PlayerUse', 'doorUsed', function(ply, ent)
	SWRP.Doors.List[game.GetMap()] = SWRP.Doors.List[game.GetMap()] or {}
	SWRP.Doors.List[game.GetMap()][ent:MapCreationID()] = SWRP.Doors.List[game.GetMap()][ent:MapCreationID()] or {}
	
	bat = SWRP.Doors.List[game.GetMap()][ent:MapCreationID()]["batalion"]
	roles = SWRP.Doors.List[game.GetMap()][ent:MapCreationID()]["roles"]
	rank = SWRP.Doors.List[game.GetMap()][ent:MapCreationID()]["rank"]
			
	if bat and bat != ply.Char.batalion then
		return false
	end
	if (rank and tonumber(ply.Char.rank)<rank) then
		return false
	end
	if roles and !roles[tonumber(ply.Char.role)] then
		return false
	end
end)