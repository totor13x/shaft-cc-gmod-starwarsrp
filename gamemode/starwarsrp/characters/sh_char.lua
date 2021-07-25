function GM:CharName(id, bool, ...)
	local tab = ...
	if bool then
		local a1 = (tab['name_id']).." "
		local a2 = (tab.batalionInfo and tab.batalionInfo.named) or "0000"
		local a3 = SWRP.Ranks:GetRank(tonumber(tab['rank']) or 0, tab['clsf']).Short //(SWRP.Ranks.List[tonumber(tab['rank']) or 0].Short ) 
		local a4 = (tab['name_clas'])
		if tab['clsf'] == "J" then
			a1 = ""
			a2 = (tab.batalionInfo and tab.batalionInfo.named) or "Jedi"
			a3 = SWRP.Ranks:GetRank(tonumber(tab['rank']) or 0, tab['clsf']).Short //(SWRP.Ranks.List[tonumber(tab['rank']) or 0].Short ) 
			a4 = (tab['name_clas'])
		end
		return a1..""..a2.."|"..a3.."|"..a4..""
	end
	if IsValid(id) and id:IsPlayer() then
		if id:GetNWBool("EnabChar") then
			return id:GetNWString('CharName')
		else 
			return id:Nick()
		end
	end
	local tab = self:GetCharacterID( id )
	if tab then
		local a1 = (tab['name_id']).." "
		local a2 = (tab.batalionInfo and tab.batalionInfo.named) or "0000"
		local a3 = SWRP.Ranks:GetRank(tonumber(tab['rank']) or 0, tab['clsf']).Short
		local a4 = (tab['name_clas'])
		
		if tab['clsf'] == "J" then
			a1 = ""
			a2 = (tab.batalionInfo and tab.batalionInfo.named) or "Jedi"
			a3 = SWRP.Ranks:GetRank(tonumber(tab['rank']) or 0, tab['clsf']).Short //(SWRP.Ranks.List[tonumber(tab['rank']) or 0].Short ) 
			a4 = (tab['name_clas'])
		end
		return a1..""..a2.."|"..a3.."|"..a4
	end
	//ID|Батальон|ШортКодЗвания|Позывной
	return "Неизвестно"
end

function GM:CharId(id)
	if IsValid(id) and id:IsPlayer() then
		if id:GetNWBool("EnabChar") then
			return id:GetNWString('CharId')
		else 
			return id:Nick()
		end
	end
	return "Неизвестно"
end

//print(GM:CharName("aa", true, {id = '1', foo = 'bar'}))

local Player = FindMetaTable("Player")
function Player:CharNick()
	return GAMEMODE:CharName(self)
end

function Player:CharId()
	return GAMEMODE:CharId(self)
end

Player.CharName = Player.CharNick
Player.CharID = Player.CharId

function Player:GetCharacterSkills(id)
	if self:GetNWBool("EnabChar") and self.Char and self.Char.skills and self.Char.skills[id] then
		return self.Char.skills[id]
	end
	return GAMEMODE and GAMEMODE.Needs and GAMEMODE.Needs.Config[id] or 1
end

function Player:DGetPriv(priv)
 	return SWRP.Ranks:DGetPrivPly(self, priv)
end

-- Custom Armor
function Player:SetArmor(armor)
	self:SetNWInt("SWRP.Armor", armor)
end
function Player:GetArmor()
	return self:GetNWInt("SWRP.Armor", 0)
end
Player.Armor = Player.GetArmor
function Player:SetMaxArmor(armor)
	self:SetNWInt("SWRP.MaxArmor", armor)
end
function Player:GetMaxArmor()
	return self:GetNWInt("SWRP.MaxArmor", 0)
end