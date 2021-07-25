concommand.Add("cmd_pnlBatalion", function(ply,cmd,args)
	if IsValid(ply) and ply.Char then
		//print(ply.Char.batalion)
		local select = SWRP.Batalions:NDGetInfo(ply.Char.batalion)
		-- print(select)
		if args[1] then	select.sidf = args[1] end
		if select then
			netstreamSWRP.Start(ply, "Batalion::OpenFrame", select, SWRP.TransitionAbility.List)
    		SWRP.TransitionAbility:RefreshData()
			SWRP.TransitionAbility:Update()
		end
	end
end)

function SWRP.Batalions:SWEPForBatalion(ply)
	if isfunction(SWRP.Batalions.Personally.LoadWeapons[ply.Char.batalion]) then
		SWRP.Batalions.Personally.LoadWeapons[ply.Char.batalion](ply)
	end
end
timer.Simple(0, function()
//	print(#sql.Query("SELECT * FROM characters where batalion = 'CT' and rank = '"..CC.."'"))
end)
function SWRP.Batalions:RankUP(ply)
	local id = ply.Char.rank 
	id = tonumber(id)

	if id+1 > MAX_RANK then return end
	local zzz = 1
	for i=id+1, MAX_RANK do
		zzz = i
		if SWRP.Ranks:GetRank(i) then break end
	end
	
	if !SWRP.Ranks:GetRank(zzz) then return end
	

	local time = SWRP.Ranks:LastInsertTime(ply) 
	print(time + (60*60*24) >= os.time(), zzz >= TRP && zzz <= CPL)
	if 
		time + (60*60*24) >= os.time() && //Рядовой состав может быть повышен один раз в 24 часа
		(zzz >= TRP && zzz <= CPL) then
			netstreamSWRP.Start( ply, "GM:Notification", {
				text = "Клон "..GAMEMODE:CharName(_, true, ply.Char).." уже был повышен, повтори через "..util.sec2Min((time+(60*60*24)) - os.time(), true), 
				type = NOTIFY_ERROR, 
				length = 6
			} )
			return
	end

	if 
		time + (60*60*24*3) >= os.time() && //Сержантский состав может быть повышен один раз в 3 дня
		(zzz >= MSG && zzz <= SMG) then
			netstreamSWRP.Start( ply, "GM:Notification", {
				text = "Клон "..GAMEMODE:CharName(_, true, ply.Char).." уже был повышен, повтори через "..util.sec2Min((time+(60*60*24*3)) - os.time(), true), 
				type = NOTIFY_ERROR, 
				length = 6
			} )
			return
	end
	if 
		time + (60*60*24*5) >= os.time() && //Мл. офицерский состав может быть повышен один раз в 5 дней
		(zzz >= MLT && zzz <= CPT) then
			netstreamSWRP.Start( ply, "GM:Notification", {
				text = "Клон "..GAMEMODE:CharName(_, true, ply.Char).." уже был повышен, повтори через "..util.sec2Min((time+(60*60*24*5)) - os.time(), true), 
				type = NOTIFY_ERROR, 
				length = 6
			} )
			return
	end
	if 
		time + (60*60*24*10) >= os.time() && //Ст. офицерский состав может быть повышен один раз в 10 дней
		(zzz >= MAJ && zzz <= CC) then
			netstreamSWRP.Start( ply, "GM:Notification", {
				text = "Клон "..GAMEMODE:CharName(_, true, ply.Char).." уже был повышен, повтори через "..util.sec2Min((time+(60*60*24*10)) - os.time(), true), 
				type = NOTIFY_ERROR, 
				length = 6
			} )
			return
	end

	ply.Char.rank = zzz
	ply.Char.model, ply.Char.bodygroup, ply.Char.skin = SWRP.Roles:DRoleModel(ply)
	

	SWRP.Ranks:InsertNewRecord(ply) 
	GAMEMODE:SaveCharacter(ply)
	local player = player.GetBySteamID(ply.Char.steamid)
	if player then
		/*
		player:SetModel(ply.Char.model)
		player:SetBodyGroups(ply.Char.bodygroup)
		
		player:SetNWString('CharName', GAMEMODE:CharName(_, true, ply.Char))
		
		local text = ""
		if table.Count(ply.Char.batalionInfo) != 0 then text = (ply.Char.batalionInfo.named_beauty != "0000" and ply.Char.batalionInfo.named_beauty or ply.Char.batalionInfo.named).." " end
		text = text .. SWRP.Roles:DRoleName(ply.Char.role, ply.Char.special_name)
		player:SetNWString('BatName', text)
		*/
		player:CharacterSelect(ply.Char.id)
	end
	//PrintTable(ply.Char)
	return true
end

netstreamSWRP.Hook("Batalion::RankUP", function(ply, tab)
	print(ply, tab)
	//PrintTable(ply.Char)
	///local char = GAMEMODE:GetCharacterID( ply )
	//print(Entity(ply:EntIndex()).Char.rank, '_____')
	if !SWRP.Ranks:DGetPriv(ply.Char.rank, 'BatalionCanRankUP') then
		local data = {}
		data.text, data.type, data.length = "Недостаточно привелегий %CanRankUP%", NOTIFY_ERROR, 4
		netstreamSWRP.Start( ply, "GM:Notification", data )
		
		return 
	end
	local char = GAMEMODE:GetCharacterID( tab )
	if char then
		local char_rank = tonumber(char.rank)

		if char.batalion == "ARC" && char_rank+1 > COL then
			netstreamSWRP.Start( ply, "GM:Notification", {
				text = "В батальоне ARC нельзя повысить выше звания COL", 
				type = NOTIFY_ERROR, 
				length = 4
			} )
			return 
		end
		local time = SWRP.Ranks:LastInsertTime({Char = char}) 
		if 
			time + (60*60*24) >= os.time() && //Рядовой состав может быть повышен один раз в 24 часа
			(char_rank >= TRP && char_rank <= CPL) then
				netstreamSWRP.Start( ply, "GM:Notification", {
					text = "Клон "..GAMEMODE:CharName(_, true, char).." уже был повышен, повтори через "..util.sec2Min((time+(60*60*24)) - os.time(), true), 
					type = NOTIFY_ERROR, 
					length = 6
				} )
				return
		end

		if 
			time + (60*60*24*3) >= os.time() && //Сержантский состав может быть повышен один раз в 3 дня
			(char_rank >= MSG && char_rank <= SMG) then
				netstreamSWRP.Start( ply, "GM:Notification", {
					text = "Клон "..GAMEMODE:CharName(_, true, char).." уже был повышен, повтори через "..util.sec2Min((time+(60*60*24*3)) - os.time(), true), 
					type = NOTIFY_ERROR, 
					length = 6
				} )
				return
		end
		if 
			time + (60*60*24*5) >= os.time() && //Мл. офицерский состав может быть повышен один раз в 5 дней
			(char_rank >= MLT && char_rank <= CPT) then
				netstreamSWRP.Start( ply, "GM:Notification", {
					text = "Клон "..GAMEMODE:CharName(_, true, char).." уже был повышен, повтори через "..util.sec2Min((time+(60*60*24*5)) - os.time(), true), 
					type = NOTIFY_ERROR, 
					length = 6
				} )
				return
		end
		if 
			time + (60*60*24*10) >= os.time() && //Ст. офицерский состав может быть повышен один раз в 10 дней
			(char_rank >= MAJ && char_rank <= CC) then
				netstreamSWRP.Start( ply, "GM:Notification", {
					text = "Клон "..GAMEMODE:CharName(_, true, char).." уже был повышен, повтори через "..util.sec2Min((time+(60*60*24*10)) - os.time(), true), 
					type = NOTIFY_ERROR, 
					length = 6
				} )
				return
		end

		if char_rank == MAJ-1 then
			local MAJ_count = sql.Query("SELECT * FROM characters where batalion = '"..char.batalion.."' and rank = '"..(MAJ).."'") -- CC
			if MAJ_count && #MAJ_count >= 5 then
				netstreamSWRP.Start( ply, "GM:Notification", {
					text = "Ты не можешь повысить "..GAMEMODE:CharName(_, true, char)..", клонов MAJ хватает", 
					type = NOTIFY_ERROR, 
					length = 4
				} )
				return 
			end 
		end 
		
		if char_rank == LTC-1 then
			local LTC_count = sql.Query("SELECT * FROM characters where batalion = '"..char.batalion.."' and rank = '"..(LTC).."'") -- CC
			if LTC_count && #LTC_count >= 4 then
				netstreamSWRP.Start( ply, "GM:Notification", {
					text = "Ты не можешь повысить "..GAMEMODE:CharName(_, true, char)..", клонов LTC хватает", 
					type = NOTIFY_ERROR, 
					length = 4
				} )
				return 
			end 
		end 
		
		if char_rank == COL-1 then
			local col_count = sql.Query("SELECT * FROM characters where batalion = '"..char.batalion.."' and rank = '"..(COL).."'") -- CC
			if col_count && #col_count >= 3 then
				netstreamSWRP.Start( ply, "GM:Notification", {
					text = "Ты не можешь повысить "..GAMEMODE:CharName(_, true, char)..", клонов COL хватает", 
					type = NOTIFY_ERROR, 
					length = 4
				} )
				return 
			end 
		end 
		
		if char_rank == CC-1 then
			local cc_count = sql.Query("SELECT * FROM characters where batalion = '"..char.batalion.."' and rank = '"..(CC).."'") -- CC
			if cc_count && #cc_count >= 2 then
				netstreamSWRP.Start( ply, "GM:Notification", {
					text = "Ты не можешь повысить "..GAMEMODE:CharName(_, true, char)..", клонов CC хватает", 
					type = NOTIFY_ERROR, 
					length = 4
				} )
				return 
			end 
		end 
		SWRP.Batalions:RankUP({Char = char})
	end
end)
/*
timer.Simple(0, function()
SWRP.Batalions:RankUP(Entity(1))
end)
*/
//print(sql.Query("SELECT * FROM batalion_list WHERE named = 'NULL'"), '-----') 

if not sql.Query("SELECT * FROM batalion_list WHERE named = 'NULL'") then
	sql.Query("INSERT INTO `batalion_list` (`owner_steamid`,`allow_class`,`named`) values ('STEAM_0:0:331925970', '[]', 'NULL')")
	local lock = {}
	lock[ST_MEDIC] = 3
	lock[CM_MEDIC] = 1 
end

if not sql.Query("SELECT * FROM batalion_list WHERE named = 'CT'") then
	sql.Query("INSERT INTO `batalion_list` (`owner_steamid`,`allow_class`,`named`) values ('STEAM_0:0:331925970', '[]', 'CT')")
end