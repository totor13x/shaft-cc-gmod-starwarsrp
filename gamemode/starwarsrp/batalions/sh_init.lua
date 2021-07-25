SWRP.Batalions = SWRP.Batalions or {}
SWRP.Batalions.SpecialsBataions = SWRP.Batalions.SpecialsBataions or {}
SWRP.Batalions.Personally = SWRP.Batalions.Personally or {}
SWRP.Batalions.Personally.LoadWeapons = SWRP.Batalions.Personally.LoadWeapons or {}

//PrintTable(sql.Query("SELECT * FROM characters"))
function SWRP.Batalions:NDGetInfo(id, ...)
	//PrintTable(sql.Query("SELECT * FROM characters"))
	local blist = sql.Query("SELECT * FROM batalion_list WHERE named = '"..id.."'")
	local blocktables = ... or {}
	local BT = {}
	for i,v in pairs(blocktables) do
		BT[v] = true
	end
	if blist and istable(blist)then
		local info = table.Copy(blist[1])
		
		info.allow_class = util.JSONToTable(info.allow_class)
		if !BT["Players"] then -- // * Players
			local pllist = sql.Query("SELECT * FROM characters WHERE batalion = '"..info.named.."'")
			info.Players = {}
			for i,v in pairs(pllist) do
				if !info.Players[v.steamid] then info.Players[v.steamid] = {} end
				table.insert(info.Players[v.steamid], v.id, SWRP:DJSONCharacterConvert( v )) // ТУТТ
			end
		end
		if !BT["Transitions"] then -- // * Players
			info.Transitions = {}
    		local rqlist = sql.Query("SELECT * FROM transition_requests WHERE new_bat = '"..id.."'") or {}
			if #rqlist > 0 then
			local ids = {}
			for i,v in pairs(rqlist) do
				ids[v.charid] = true
			end
			local ids_concat = table.concat(table.GetKeys( ids ), "','")
			local pllist = sql.Query("SELECT * FROM characters WHERE id IN ('".. ids_concat .."')") 
			if pllist then
				for i,v in pairs(pllist) do
					if !info.Transitions[v.steamid] then info.Transitions[v.steamid] = {} end
					table.insert(info.Transitions[v.steamid], v.id, SWRP:DJSONCharacterConvert( v )) // ТУТТ
				end
			end
			end
			//info.Requests = {}
			//for i,v in pairs(rqlist) do
			//	if !info.Players[v.steamid] then info.Players[v.steamid] = {} end
			//	table.insert(info.Players[v.steamid], v.id, SWRP:DJSONCharacterConvert( v )) // ТУТТ
			//end
		end
		//PrintTable(info)
		return info
	end
	return false
end


//hook.Add("Initialize", "SWRP:BatalionsRecourceFill", function()

timer.Simple(0, function() -- %Самое нелогичное. Не использовать Initialize
	SWRP.Batalions.SpecialsBataions = {}
	local path = "starwarsrp/gamemode/starwarsrp/batalions/no_cfg_batalions/"
	for _, mod in ipairs(file.Find(path.."*", "LUA")) do
		if SERVER then
			AddCSLuaFile(path .. mod)
		end
		include(path .. mod)
	end
	
	
	relativeFixA = function(tabl, v)
		local bb = SWRP.Roles:FindRelativeClasses(v)
		if (!bb) then return end
		//PrintTable(bb)
		for i,v2 in pairs(bb) do
			//PrintTable(tabl)
		//	print(i,v)
			tabl[v2.id] = tabl[v2.id] or tabl[v]
			tabl[v2.id].Model = tabl[v2.id].Model or tabl[v].Model or tabl['All'].Model  
			tabl[v2.id].BodyGroups = tabl[v2.id].BodyGroups or tabl[v].BodyGroups or tabl['All'].BodyGroups  
			tabl[v2.id].Skin = tabl[v2.id].Skin or tabl[v].Skin or tabl['All'].Skin  
			//print(v2.id)
			relativeFixA(tabl, v2.id)
		end
	end
	relativeFixB = function(v, datanow, dataold)
		local bb = SWRP.Roles:FindRelativeClasses(v)
		//print(v, bb)
		if (!bb) then return end
		for i,v in pairs(bb) do
			//print(dataold[v.id])
			datanow[v.id] = datanow[v.id] or dataold[v.id]
			relativeFixB(v.id, datanow, dataold)
		end
	end
	
	for i,v in pairs(SWRP.Batalions.SpecialsBataions) do 
		SWRP.Batalions.SpecialsBataions[i][0] = SWRP.Batalions.SpecialsBataions[i][0] or {
			['All'] = {
				Model = 'models/reizer_cgi_p2/clone_trp/clone_trp.mdl',
				BodyGroups = '0',
				Skin = 0,
			}
		}
		local temp = {}
		for rank=0,MAX_RANK_FOR_DO do
			if (SWRP.Batalions.SpecialsBataions[i][rank]) then
			
			
				//local tabled = {}
				//tabled[#tabled+1] = "All"
				local parse = false
				if (rank > 0 and table.Count(SWRP.Batalions.SpecialsBataions[i][rank-1]) != 1) then
					parse = true
				end
				
				for param,value in pairs(SWRP.Batalions.SpecialsBataions[i][rank]) do
					//if not SWRP.Batalions.SpecialsBataions[i][rank+1][param] then SWRP.Batalions.SpecialsBataions[i][rank+1][param] = SWRP.Batalions.SpecialsBataions[i][rank][param] end
					//if print()

					//print(rank, param)
					if param != 'All' then
						relativeFixA(SWRP.Batalions.SpecialsBataions[i][rank], param)
					end
					
					if parse then
						for i2,va in pairs(GAMEMODE.RolesWithCreate) do 
							local a = relativeFixB(va, SWRP.Batalions.SpecialsBataions[i][rank], SWRP.Batalions.SpecialsBataions[i][rank-1])
						end
					end 
					
					SWRP.Batalions.SpecialsBataions[i][rank][param] = SWRP.Batalions.SpecialsBataions[i][rank][param] or SWRP.Batalions.SpecialsBataions[i][rank-1][param]
					SWRP.Batalions.SpecialsBataions[i][rank][param].Model = SWRP.Batalions.SpecialsBataions[i][rank][param].Model or SWRP.Batalions.SpecialsBataions[i][rank-1][param].Model
					
					SWRP.Batalions.SpecialsBataions[i][rank][param].BodyGroups = SWRP.Batalions.SpecialsBataions[i][rank][param].BodyGroups or SWRP.Batalions.SpecialsBataions[i][rank-1][param].BodyGroups
					
					SWRP.Batalions.SpecialsBataions[i][rank][param].Skin = SWRP.Batalions.SpecialsBataions[i][rank][param].Skin or SWRP.Batalions.SpecialsBataions[i][rank-1][param].Skin
									 
				end
			else -- Если нет фич батальона, то приписываем стандартное
				SWRP.Batalions.SpecialsBataions[i][rank] = SWRP.Batalions.SpecialsBataions[i][rank-1]
			end
		end
	end
	print('Loaded data batalion')
	//PrintTable(SWRP.Batalions.SpecialsBataions)
end)

/*
	local temp 
	relativeLoadBatatlions = function(n, v, dataold)
			//v.Model = v.Model or dataold.Model
			for i,v2 in pairs(dataold) do
				for i,v3 in pairs(v2) do
					//PrintTable(v3)
					
				end
			end
			//relativeLoad(n, v.id, v)
		end
	for i,v in pairs(SWRP.Batalions.Specials) do 
		local a = relativeLoadBatatlions(n, v, v)
	end
*/
//end) 
//Рядовые
/*
TRP = 1
PVT = 2
PV1 = 3
CPL = 4
MSG = 5
SGT = 6
SSG = 7 
ENS = 8
SNS = 9
SMG = 10
MLT = 11
LT = 12
SLT = 13
CPT = 14
MAJ = 15
LTC = 16
COL = 17
CC = 18
MCC = 19
GMGL = 20
GC = 21
GA = 22
MCO = 23
CM = 24
*/