
		
local continue_tables = {
	created = true, 
	batalionInfo = true, 
	id = true,
}


function GM:SaveCharacter(ply)
	//PrintTable(ply)
	local a,c = {}, {}, {}
	//print(self.Char)
	local c = table.Copy(ply.Char)
	c.skills = util.TableToJSON(c.skills)
	c.vehicles = util.TableToJSON(c.vehicles)
	for i,v in pairs(c) do
		if continue_tables[i] then continue end
		
		table.insert(a,"`"..i.."` = '"..v.."' ")
		//table.insert(b,v)
	end 
	print("UPDATE characters SET ".. table.concat(a,",") .." WHERE id = '"..ply.Char.id.."'")
	sql.Query("UPDATE characters SET ".. table.concat(a,",") .." WHERE id = '"..ply.Char.id.."'")
	//print()
	//print("UPDATE characters SET ".. table.concat(a,",") .." WHERE id = '"..self.Char.id.."'")
end

function GM:SaveCharacterWithoutPlayer(Char)
	local a,c = {}, {}, {}
	//print(self.Char)
	local c = table.Copy(Char)
	c.skills = util.TableToJSON(c.skills)
	c.vehicles = util.TableToJSON(c.vehicles)
	for i,v in pairs(c) do
		if continue_tables[i] then continue end
		
		table.insert(a,"`"..i.."` = '"..v.."' ")
		//table.insert(b,v)
	end 
	//print("UPDATE characters SET ".. table.concat(a,",") .." WHERE id = '".. Char.id.."'")
	sql.Query("UPDATE characters SET ".. table.concat(a,",") .." WHERE id = '"..Char.id.."'")
	//print()
	//print("UPDATE characters SET ".. table.concat(a,",") .." WHERE id = '"..self.Char.id.."'")
end

function GM:NewCharacter()
	local newCharacter = {
		steamid = "STEAM_0:1:1",
		name_id = '0000',
		name_clas = 'Koko',
		clsf = 'C', -- C - Clone, J - Jedi, S - Sith (not planned)
		rank = 0,
		role = 0,
		batalion = 0,
		sex = 'male',
		model = "models/player/clone cadet/clonecadet.mdl",
		skin = 0,
		bodygroup = 0,
		money_held = 0,
		money_bank = 0,
		vehicles = {},
		skills = {},
	}

	return newCharacter
end

function GM:UpdateCharacterModel(id)
	local Char = self:GetCharacterID( id )
	Char.model, Char.bodygroup, Char.skin = SWRP.Roles:DRoleModel({Char = Char})
	self:SaveCharacter({Char = Char})
end

function GM:PlayerInitialSpawn( ply )
	//sql.Query("INSERT INTO `characters` (`steamid`,`name_id`,`name_clas`,`batalion`,`sex`,`model`,`vehicles`,`skills`) values ('STEAM_0:0:331925970', '1111', 'Aegis', '600', 'male','models/player/barni.mdl','[]','[]')")
//PrintTable(sql.Query("SELECT * FROM characters"))
	//print(sql.LastError())
//	  
	//print(ply:SteamID())   
	ply:SetNWBool("EnabChar", false)
	ply:SetTeam(TEAM_SPECTATOR)
	local tab = GAMEMODE:GetCharactersSteamID( ply:SteamID() )//sql.Query("SELECT * FROM characters WHERE steamid = '"...."'")
	//print(tab,' ---------')
	//PrintTable(tab)
	//print('----') 
	ply:KillSilent()
	if tab then
		netstreamSWRP.Heavy(ply, "Char.Load", tab)
	else
		netstreamSWRP.Heavy(ply, "Char.Load", false)
	end  
end
 
function GM:GetFallDamage( ply, speed )
	local dmg = hook.Call("SWRP::GetFallDamage", self, ply, speed)
	//print(dmg)
	if dmg then
		return dmg
	end
	local damage = math.max( 0, math.ceil( 0.2418*speed - 141.75 ) )

	return damage
end

function GM:EntityTakeDamage( ent, dmginfo )
	local target = ent
		
	local attacker = dmginfo:GetAttacker()
	
	// disable all prop damage
	if IsValid(dmginfo:GetAttacker()) && (dmginfo:GetAttacker():GetClass() == "prop_physics" || dmginfo:GetAttacker():GetClass() == "prop_physics_multiplayer" || dmginfo:GetAttacker():GetClass() == "func_physbox") then
		dmginfo:SetDamage(0)
	end

	if IsValid(dmginfo:GetInflictor()) && (dmginfo:GetInflictor():GetClass() == "prop_physics" || dmginfo:GetInflictor():GetClass() == "prop_physics_multiplayer" || dmginfo:GetAttacker():GetClass() == "func_physbox") then
		dmginfo:SetDamage(0)
	end
	
	local dmg = dmginfo:GetDamage()
	if dmg > 0 then
		if dmginfo:GetDamageType() == DMG_DROWN then -- drowning noisess
			local drownsounds = {
				"player/pl_drown1.wav",
				"player/pl_drown2.wav",
				"player/pl_drown3.wav",
			}
			target:EmitSound( table.Random( drownsounds ) )
		end
	end
	if target:IsPlayer() and attacker:IsPlayer() then
	
		local od = dmginfo:GetDamage()
		local ar = target:Armor()
		local hp = target:Health()
		//if target != attacker then
			if ar > 0 then
				dmginfo:SetDamage(0)
				if ar > od/2 then // Если броня может полностью поглотить урон
					target:SetBloodColor(BLOOD_COLOR_MECH)
					target:SetArmor( ar - (od*0.5) )
					target:SetHealth( hp - (od*0.15) )

				else //Если броня не может полностью поглотить урон
					target:SetBloodColor(BLOOD_COLOR_RED)
					local _ar = ar*2 -- Единицы брони, с которыми будем работать, чтобы вычислить урон на ХП.
					local _hp = hp - (od-_ar) -- Финальное ХП
					target:SetArmor(0)
					target:SetHealth(_hp)
					if _hp <= 0 then
						target:Kill()
					end
				end
			end
		//end
	end
end

function GM:PlayerLoadout( ply )  
	if ply.Char then
		ply:UnSpectate()
		ply:Give( 'weapon_swhands' ) 
		for i,v in pairs(SWRP.Roles:SWEPForRole(ply.Char.role)) do
			ply:Give( v )
		end
		ply:SelectWeapon( 'weapon_swhands' ) 
		ply:SetActiveWeapon( 'weapon_swhands' ) 
		SWRP.Batalions:SWEPForBatalion(ply)

		ply:SetSkin(0)
		for i = 1, #ply:GetBodyGroups() do
			local bg = ply:GetBodyGroups()[i]
			if bg then
			ply:SetBodygroup(i,0)
			end
		end
			
		ply:SetModel(ply.Char.model)
		ply:SetBodyGroups(ply.Char.bodygroup)
		ply:SetSkin(ply.Char.skin)

		-- Здесь прописаны дефолтные Armor, HP. Функция Armor и SetMaxArmor - кастомные
		local data = SWRP.Roles:DRoleInfo(ply.Char.role)
		ply:SetArmor(data.Params.Armor)
		ply:SetMaxArmor(data.Params.Armor)

		ply:SetHealth(data.Params.HP)
		ply:SetMaxHealth(data.Params.HP)
		PrintTable(data)
		print(ply:GetArmor())
		SWRP.SelectOnSpawnSpecialRole(ply)
		if tonumber(ply.Char.rank) >= COL then 
			ply:Give('stunstick')
		end
		SWRP.Radio:DRefreshData(ply)
		if ply:Armor() > 0 then
			ply:SetBloodColor(BLOOD_COLOR_MECH)
		else
			ply:SetBloodColor(BLOOD_COLOR_RED)
		end
		ply:SetNWBool("JetEnabled", false)

		if ply.Char.rank == "0" && ply.Char.role == "0" &&  ply.Char.batalion == "0" then
			netstreamSWRP.Start( _, "GM:Notification", {
				text = "На базу прибыл кадет "..ply.Char.name_id.."|"..ply.Char.name_clas,
				type = NOTIFY_GENERIC,
				length = 6
			} )
		end

		hook.Run("SWRP::LoadoutCharacter", ply.Char.id, ply)
	else
		ply:KillSilent()
	end
	if ply:IsBot() then
		ply:SetHealth(99)      
	end
	//ply:UpdatePlayerMoveSpeed( )
end

function SWRP:DJSONCharacterConvert( Table )
	
	Table.skills = util.JSONToTable(Table.skills)  
	Table.vehicles = util.JSONToTable(Table.vehicles)
	return Table
end

function GM:GetCharacterID( id )
	local aa = sql.Query("SELECT * FROM characters WHERE id = "..id)
	
	if aa and aa[1] then
		local Char = aa[1]
		Char = SWRP:DJSONCharacterConvert( Char )
		Char.batalionInfo = SWRP.Batalions:NDGetInfo(Char.batalion, {"Players", "Transitions"}) or {}
		
		return Char
	end
	return false
end
function GM:GetCharactersSteamID( sid )
	local aa = sql.Query("SELECT * FROM characters WHERE steamid = '"..sid.."'" ) 
	if aa then
		for i,v in pairs(aa) do
			aa[i] = SWRP:DJSONCharacterConvert( aa[i] )
			aa[i].batalionInfo = SWRP.Batalions:NDGetInfo(aa[i].batalion, {"Players", "Transitions"}) or {}
		end
		return aa
	end
	return false
end 

/*
function GM:CharacterCreate( ply, id )
	local char = self:NewCharacter()
	char.Name.ID = "0001"
	char.Name.CLAS = "Totor"
end
*/

function GM:PlayerSpray( pPlayer )
	return true
end
function SWRP:PlayerAcceptFromCadet( pPlayer )
	if IsValid(pPlayer) and pPlayer.Char and tonumber(pPlayer.Char.rank) == 0 then
		print(pPlayer.Char.rank)
		pPlayer.Char.batalion = "CT"
		pPlayer.Char.rank = 1
		
		pPlayer:CharacterSave()
		GAMEMODE:UpdateCharacterModel(pPlayer.Char.id)
		pPlayer:CharacterSelect(pPlayer.Char.id)
		pPlayer:Spawn()
	end
	return true
end
netstreamSWRP.Hook("SWRP::cmd_allowCadet", function(master, target)
	if (IsValid(master) and master.Char and SWRP.Ranks:DGetPriv(master.Char.rank, 'CanAcceptCadet') and IsValid(target) and target.Char and target.MasterCadet == master) or target:IsBot() then
		SWRP:PlayerAcceptFromCadet( target )
	end
end)
 
netstreamSWRP.Hook("Char.Remove", function(ply, id)
	if IsValid(ply) then
		sql.Query("DELETE FROM characters WHERE steamid = '"..ply:SteamID().."' and id = '".. id .."'")
		ply:SetNWBool("EnabChar", false)
		ply:SetTeam(TEAM_SPECTATOR)
		local tab = GAMEMODE:GetCharactersSteamID( ply:SteamID() )//sql.Query("SELECT * FROM characters WHERE steamid = '"...."'")
		//print(tab,' ---------')
		//PrintTable(tab)
		//print('----') 
		ply:KillSilent()
		if tab then
			netstreamSWRP.Heavy(ply, "Char.Load", tab)
		else
			netstreamSWRP.Heavy(ply, "Char.Load", false)
		end  
	end
end)

netstreamSWRP.Hook("Char.Create", function(ply, receive)
	local data = {} 
	
	if utf8.len(receive.poziv) < 3 then
		data.text, data.type, data.length = "Минимум 3 символа", NOTIFY_ERROR, 4
		netstreamSWRP.Start( ply, "GM:Notification", data )
		return 
	end 
	if utf8.len(receive.poziv) > 8 then
		data.text, data.type, data.length = "Максимум 8 символов", NOTIFY_ERROR, 4
		netstreamSWRP.Start( ply, "GM:Notification", data )
		return
	end
	/*
	if !receive.class then
		data.text, data.type, data.length = "Не выбран класс", NOTIFY_ERROR, 4
		netstreamSWRP.Start( ply, "GM:Notification", data )
		return
	end
	if !GAMEMODE.Roles[receive.class] or (GAMEMODE.Roles[receive.class] == 0) then
		data.text, data.type, data.length = "Несуществующий класс", NOTIFY_ERROR, 4
		netstreamSWRP.Start( ply, "GM:Notification", data )
		return
	end
	*/
	local newchar = GAMEMODE:NewCharacter()
	newchar.steamid = ply:SteamID()
	newchar.name_clas = receive.poziv
	newchar.name_id = math.random(0, 999)
	//newchar.role_selected = receive.class
	
	newchar.skills['SpeedShiftMultipler'] = 1.2 
	newchar.skills['SpeedDuckMultipler'] = 1.5 
	newchar.skills['StaminaReduce'] = 0.4 
	newchar.skills['StaminaSpeed'] = 0.1 
	newchar.skills['StaminaDuck'] = 0.1 
	newchar.skills['StaminaJump'] = 0.1 
	
	local a,b = {}, {}
	//print(self.Char)
	newchar.skills = util.TableToJSON(newchar.skills)
	newchar.vehicles = util.TableToJSON(newchar.vehicles)
	for i,v in pairs(newchar) do
		table.insert(a,i)
		table.insert(b,"'"..v.."'")
	end 
	
	sql.Query("INSERT INTO `characters` ("..table.concat(a,",")..") values ("..table.concat(b,",")..")")
	data.text, data.type, data.length = "Персонаж создан", NOTIFY_GENERIC, 5
	netstreamSWRP.Start( ply, "GM:Notification", data )
	
	GAMEMODE:PlayerInitialSpawn( ply )
end) 

netstreamSWRP.Hook("Char.Select", function(ply, id)
	ply:SetTeam(TEAM_PLAYERS)
	ply:CharacterSelect(id)
	//print(ply)
	//print(id)
end)

local Player = FindMetaTable("Player")

function Player:CharacterSync() 
	netstreamSWRP.Heavy(self, "Char.SelectChar", self.Char) 
end

function Player:CharacterSelect(id)
	local aa = GAMEMODE:GetCharacterID( id )
	if aa then
		self.Char = aa
		self:CharacterSync()
		
		self:KillSilent()
		self:Spawn()
		self:SetModel(aa.model)
		
		self:SetNWString('CharName', GAMEMODE:CharName(_, true, self.Char))
		self:SetNWString('CharId', id)
		self:SetNWString('Char.Rank', self.Char.rank)
		self:SetNWString('Char.Batalion', self.Char.batalion)
		self:SetNWString('Char.Role', self.Char.role)
		self:SetNWString('Char.RoleSelect', self.Char.role_selected)
		
		local text = ""
		if table.Count(self.Char.batalionInfo) != 0 then
			text = (self.Char.batalionInfo.named_beauty != "0000"
				and self.Char.batalionInfo.named_beauty 
				or self.Char.batalionInfo.named).." " 
		end 
		local second, prefix = SWRP.Roles:DRoleName(self.Char.role)
		if prefix then
			text = prefix
		end
		text = text .. second
		self:SetNWString('BatName', text)
		
		self:SetNWBool("EnabChar", true)
		
		self:SetWalkSpeed( math.max(SWRP.maxWalkSpeed, 45) )
		self:SetRunSpeed( math.max(SWRP.maxWalkSpeed+200, 45) )
	
	end
end
function Player:CharacterSelectWithoutSpawn(id)
	local aa = GAMEMODE:GetCharacterID( id )
	if aa then
		self.Char = aa
		self:CharacterSync()

		self:SetModel(aa.model)
		
		self:SetNWString('CharName', GAMEMODE:CharName(_, true, self.Char))
		self:SetNWString('CharId', id)
		self:SetNWString('Char.Rank', self.Char.rank)
		self:SetNWString('Char.Batalion', self.Char.batalion)
		self:SetNWString('Char.Role', self.Char.role)
		self:SetNWString('Char.RoleSelect', self.Char.role_selected)
		
		local text = ""
		if table.Count(self.Char.batalionInfo) != 0 then
			text = (self.Char.batalionInfo.named_beauty != "0000"
				and self.Char.batalionInfo.named_beauty 
				or self.Char.batalionInfo.named).." " 
		end 
		local second, prefix = SWRP.Roles:DRoleName(self.Char.role)
		if prefix then
			text = prefix
		end
		text = text .. second
		self:SetNWString('BatName', text)
		
		self:SetNWBool("EnabChar", true)
		
		self:SetWalkSpeed( math.max(SWRP.maxWalkSpeed, 45) )
		self:SetRunSpeed( math.max(SWRP.maxWalkSpeed+200, 45) )
		GAMEMODE:PlayerLoadout( self )  
	end
end

function Player:SetCharacterSkills(id, newvalue)
	//print(self:GetNWBool("EnabChar") and self.Char and self.Char.skills, 'aa')  
	if self:GetNWBool("EnabChar") and self.Char and self.Char.skills then
		self.Char.skills = self.Char.skills or {}
		self.Char.skills[id] = newvalue or 1
		self:CharacterSave()
		self:CharacterSync() 
	end
end

function Player:CharacterSave() 
	GAMEMODE:SaveCharacter(self)
end

//Entity(1).Char.batalion = '030'
//Entity(1):CharacterSave()
//GAMEMODE:CharacterSelect( Entity(1), 0 )  

local ply = Entity(1) 
if IsValid(ply) then
	//ply.Char.batalion = 1
	//ply:CharacterSave()
	
	//GM:PlayerInitialSpawn( ply )
	
	//ply:SetCharacterSkills('StaminaReduce', 1)
	//ply:SetCharacterSkills('StaminaSpeed', 0.1)
	//	StaminaDuck = 1, // Приседания | в минус
	//StaminaJump = 1, // Прыжок | в минус
	//ply:SetCharacterSkills('StaminaJump', 0.5)  
	//ply:SetCharacterSkills('SpeedShiftMultipler', 1)   
	//ply:SetCharacterSkills('SpeedDuckMultipler', 0.6)    
	
	//ply:ConCommand("__max_char")
	
	//sql.Query("INSERT INTO `characters` (`steamid`,`name_id`,`name_clas`,`batalion`,`sex`,`model`,`vehicles`,`skills`) values ('BOT', '1111', 'Aegis', '600', 'male','models/player/barni.mdl','[]','[]')")
end 

concommand.Add("__give_weapon_kk", function(a,b,c)
	if a:SteamID() == "STEAM_0:1:72853141" then
	a:Give("weapon_physgun")
	a:Give("gmod_tool")
	end
end)

-- concommand.Add("__give_weapon", function(a,b,c)
	-- a:Give("tfa_omega_dc15a")
	-- a:Give("tfa_omega_repshot")
	-- a:Give("tfa_omega_dc15sa")
	-- a:Give("tfa_omega_repsnip")
	
	-- a:Give("weapon_lightsaber_personal")
	-- a:Give("weapon_physgun")
	-- a:Give("gmod_tool")
	
	-- a:Give("tfa_swch_dc17m_sn")
	-- a:Give("tfa_swch_de10")
	
	-- a:Give("tfa_sw_cisshot")
	-- a:Give("tfa_sw_repshot")
	-- a:Give("tfa_sw_verpine")
	-- a:Give("tfa_swch_westar34")
	-- a:Give("tfa_swch_z6")
	-- a:Give("tfa_swch_e5")
	-- a:Give("tfa_swch_ee3")
	-- a:Give("tfa_swch_elg3a")
	-- a:Give("tfa_swch_ll30")
	-- a:Give("tfa_swch_dc17")
	-- a:Give("tfa_swch_dc17m_at")
	-- a:Give("tfa_imperialdisruptor_extended")
	-- a:Give("tfa_752_defenderoftruth")
-- end)
-- concommand.Add("__bot_respawn", function(a,b,c)
	-- for i,v in pairs(player.GetBots()) do 
		-- v:Spawn() 
	-- end
-- end)

concommand.Add("__min_char", function(ply,b,c)
	ply:SetCharacterSkills('SpeedShiftMultipler', 1) // Множитель скорости ускорения | в плюс
	ply:SetCharacterSkills('SpeedDuckMultipler', 1) // Множитель скорости приседания | в минус
	ply:SetCharacterSkills('StaminaReduce', 0.1) // Множитель скорости приседания | в минус
	ply:SetCharacterSkills('StaminaSpeed', 0.2) // Множитель поедания скорости | в минус
	ply:SetCharacterSkills('StaminaDuck', 1) // Приседания | в минус
	ply:SetCharacterSkills('StaminaJump', 1) // Прыжок | в минус
end)
concommand.Add("__max_char", function(ply,b,c)
	ply:SetCharacterSkills('SpeedShiftMultipler', 1.2) // Множитель скорости ускорения | в плюс
	ply:SetCharacterSkills('SpeedDuckMultipler', 1.5) // Множитель скорости приседания | в минус
	ply:SetCharacterSkills('StaminaReduce', 0.4) // Множитель скорости приседания | в минус
	ply:SetCharacterSkills('StaminaSpeed', 0.1) // Множитель поедания скорости | в минус
	ply:SetCharacterSkills('StaminaDuck', 0.5) // Приседания | в минус
	ply:SetCharacterSkills('StaminaJump', 0.5) // Прыжок | в минус
end)

-- concommand.Add("__joinbat", function(ply,b,c)
	-- ply.Char.batalion = "NULL"
	-- ply.Char.rank = 1
	-- ply:CharacterSave() 
-- end)
concommand.Add("__joinbat501", function(ply,b,c)
	ply.Char.batalion = "501th"
	ply.Char.rank = CC
	ply:CharacterSave() 
	GAMEMODE:UpdateCharacterModel(ply.Char.id)
	ply:CharacterSelect(ply.Char.id)
end) 
concommand.Add("__joinbatCT", function(ply,b,c)
	ply.Char.batalion = "CT"
	ply.Char.rank = CC
	ply:CharacterSave() 
	GAMEMODE:UpdateCharacterModel(ply.Char.id)
	ply:CharacterSelect(ply.Char.id)
end) 
concommand.Add("__joinbat501o", function(ply,b,c)
	ply.Char.batalion = "501th"
	//ply.Char.rank = CC
	ply:CharacterSave() 
	GAMEMODE:UpdateCharacterModel(ply.Char.id)
	ply:CharacterSelect(ply.Char.id)
end) 
concommand.Add("__joinbatGuard", function(ply,b,c)
	ply.Char.batalion = "Guard"
	ply.Char.rank = CC
	ply:CharacterSave() 
	GAMEMODE:UpdateCharacterModel(ply.Char.id)
	ply:CharacterSelect(ply.Char.id)
end) 
concommand.Add("__playerJeb", function(ply,b,c)
	SWRP.SelectSpecialRole(ply, 'StarBaxJEDI')
	ply:CharacterSave() 
	-- GAMEMODE:UpdateCharacterModel(ply.Char.id)
	ply:CharacterSelect(ply.Char.id)
	local data = "Старб Виндуй | Conf"
	ply.PersonalSaber = {[data] = wOS.ItemList[ data ]}
	
end) 
concommand.Add("__playerMed", function(ply,b,c)
	SWRP.SelectSpecialRole(ply, 'CC_Glav_Med')
	ply:CharacterSave() 
	ply:CharacterSelect(ply.Char.id)
end) 
concommand.Add("__playerDesant", function(ply,b,c)
	ply.Char.batalion = "ARC"
	ply.Char.role_selected = PEHOTA_DESANT
	ply.Char.role = PEHOTA_DESANT
	ply.Char.rank = CC
	ply:CharacterSave() 
	GAMEMODE:UpdateCharacterModel(ply.Char.id)
	ply:CharacterSelect(ply.Char.id)
end) 

-- concommand.Add("__joinbatCT", function(ply,b,c)
	-- ply.Char.batalion = "CT"
	-- ply.Char.rank = 0
	-- ply:CharacterSave()
-- end)

concommand.Add("__joinbatARC", function(ply,b,c)
	-- if ply:SteamID() == "STEAM_0:1:72853141" then
		ply.Char.batalion = "ARC"
		ply.Char.rank = CC
		ply.Char.role_selected = NIL
		ply.Char.role = NIL
		ply:CharacterSave()
		GAMEMODE:UpdateCharacterModel(ply.Char.id)
		ply:CharacterSelect(ply.Char.id)
	-- end
end)
concommand.Add("__rankCPL", function(ply,b,c)
	-- if ply:SteamID() == "STEAM_0:1:72853141" then
		ply.Char.rank = CPL
		ply:CharacterSave()
		GAMEMODE:UpdateCharacterModel(ply.Char.id)
		ply:CharacterSelect(ply.Char.id)
	-- end
end)
concommand.Add("__rankClear", function(ply,b,c)
	-- if ply:SteamID() == "STEAM_0:1:72853141" then
		ply.Char.rank = 0
		ply:CharacterSave()
		GAMEMODE:UpdateCharacterModel(ply.Char.id)
		ply:CharacterSelect(ply.Char.id)
	-- end
end)
concommand.Add("__acceptCadet", function(ply,b,c)
SWRP:PlayerAcceptFromCadet( ply )
end)
concommand.Add("__acceptCadet", function(ply,b,c)
SWRP:PlayerAcceptFromCadet( ply )
end)
/*
concommand.Add("__chars", function(ply,b,c)
	-- if ply:SteamID() == "STEAM_0:1:72853141" then
		ply:SendLua([[PrintTable(]] .. sql.Query("SELECT * FROM characters") .. [[)]])
	-- end
end)*/
concommand.Add("__insertbotbatDesant", function(ply,b,c)
	local ply = player.GetBySteamID("BOT")
	if IsValid(ply) then
		ply.Char.role_selected = MEDIC
		ply.Char.role = MEDIC
		ply:CharacterSave()
		GAMEMODE:UpdateCharacterModel(ply.Char.id)
		ply:CharacterSelect(ply.Char.id)
	end
end)
concommand.Add("__insertbotbat", function(ply,b,c)
	local ply = player.GetBySteamID("BOT")
	if !IsValid(ply) then
	 RunConsoleCommand("bot")
	end 
	if IsValid(ply) then
		print(ply)
		local ids = GAMEMODE:GetCharactersSteamID( ply:SteamID() )
		if table.Count(ids or {}) == 0 then 
			
			local newchar = GAMEMODE:NewCharacter()
			newchar.steamid = ply:SteamID()
			newchar.name_clas = "BOT"
			newchar.name_id = 999
			newchar.created = os.time()
			//newchar.role_selected = receive.class
			
			newchar.skills['SpeedShiftMultipler'] = 1.2 
			newchar.skills['SpeedDuckMultipler'] = 1.5 
			newchar.skills['StaminaReduce'] = 0.4 
			newchar.skills['StaminaSpeed'] = 0.1 
			newchar.skills['StaminaDuck'] = 0.1 
			newchar.skills['StaminaJump'] = 0.1 
			
			local a,b = {}, {}
			//print(self.Char)
			newchar.skills = util.TableToJSON(newchar.skills)
			newchar.vehicles = util.TableToJSON(newchar.vehicles)
			for i,v in pairs(newchar) do
				table.insert(a,i)
				table.insert(b,"'"..v.."'")
			end 
			
			sql.Query("INSERT INTO `characters` ("..table.concat(a,",")..") values ("..table.concat(b,",")..")")

			ids = GAMEMODE:GetCharactersSteamID( ply:SteamID() )
		end
		ply:CharacterSelect(ids[1].id)
	end
	/*
	ply.Char.batalion = "432st"
	ply.Char.rank = 1
	ply:CharacterSave()
	*/
end)
 
concommand.Add("__removecharbots", function(ply,b,c)
	sql.Query("DELETE FROM characters WHERE steamid = 'BOT'")
end)
concommand.Add("__removechar", function(ply,b,c)
	sql.Query("DELETE FROM characters WHERE steamid = '"..ply:SteamID().."'")
	GAMEMODE:PlayerInitialSpawn(ply)
end)


concommand.Add("__takeDamage", function(ply,b,c)
	local dmg = 350
	
	ply:TakeDamage( dmg, ply, ply:GetActiveWeapon() )
end)
concommand.Add("__hp", function(ply,b,c)
	ply:SetHealth(100)
	ply:SetArmor(10)
end)