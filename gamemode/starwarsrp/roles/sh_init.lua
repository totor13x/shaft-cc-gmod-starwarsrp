GM.Roles = {}
NIL = 0
INJ = 1
MEDIC = 2
PEHOTA = 3

GM.Roles[NIL] = {
	Name = "Рекрут",
	Model = {
		['All'] = "models/player/clone cadet/clonecadet.mdl",
	},
	Wep = {},
	Priv = {},
	Params = {
		HP = 100,
		Armor = 0,
	}
}

GM.Roles[INJ] = {
	Name = "Инженер",
	Model = {
		['All'] = "models/grealms/characters/republicdesertcamo/republicdesertcamo.mdl",
	},
	Wep = {
		'rw_sw_dc15s',
		'rw_sw_dc17',
	},
	Priv = {},
	Params = {
		HP = 100,
		Armor = 50,
	}
}
GM.Roles[MEDIC] = {
	Name = "Медик",
	Model = {
		['All'] = "models/grealms/characters/republicmedic/republicmedic.mdl",
	},
	Wep = {
		'weapon_swrp_def',
		'rw_sw_dc17ext',
		'weapon_bactainjector',
	},
	Priv = {},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
GM.Roles[PEHOTA] = {
	Name = "Пехотинец",
	Model = {
		['All'] = "models/grealms/characters/republicforestcamo/republicforestcamo.mdl",
	},
	Wep = {
		'rw_sw_dc17',
		'rw_sw_dc15s',
	},
	Priv = {},
	Params = {
		HP = 100,
		Armor = 100,
	}
}

/* MEDIC */
MEDIC_INTERN = 5
GM.Roles[MEDIC_INTERN] = {
	Name = "Мед. интерн", 
	NeedToUp = {
		role = MEDIC,
	},
	Wep = {
		'weapon_swrp_def',
		'rw_sw_dc17ext',
		'rw_sw_dp23',
		'weapon_bactainjector',
	},
	Params = {
		HP = 110,
		Armor = 100,
	}
}

MEDIC_POLE = 6
GM.Roles[MEDIC_POLE] = {
	Name = "Мед. полевой", 
	NeedToUp = {
		role = MEDIC_INTERN,
	},
	Wep = {
		'weapon_swrp_def',
		'rw_sw_dc17ext',
		'rw_sw_dp23',
		'weapon_bactainjector',
		'weapon_bactanade',
	},
	Params = {
		HP = 120,
		Armor = 100,
	}
}

MEDIC_SHTAB = 7
GM.Roles[MEDIC_SHTAB] = {
	Name = "Мед. штабной", 
	NeedToUp = {
		role = MEDIC_POLE,
	},
	Wep = {
		'weapon_swrp_def',
		'rw_sw_dc17ext',
		'rw_sw_dp23',
		'weapon_bactainjector',
		'weapon_bactanade',
		'weapon_swrp_repairarmor',
	},
	Params = {
		HP = 120,
		Armor = 100,
	}
}

MEDIC_OFF = 8
GM.Roles[MEDIC_OFF] = {
	Name = "Мед. офицер", 
	NeedToUp = {
		role = MEDIC_SHTAB,
	},
	Wep = {
		'weapon_swrp_def',
		'rw_sw_dc17ext',
		'rw_sw_dual_dc17ext',
		'weapon_bactainjector',
		'weapon_bactanade',
		'weapon_swrp_repairarmor',
	},
	Params = {
		HP = 130,
		Armor = 100,
	}
}
/* Пехотинец */

PEHOTA_LIGHT = 9
GM.Roles[PEHOTA_LIGHT] = {
	Name = "Легкий пехотинец", 
	NeedToUp = {
		role = PEHOTA,
	},
	Wep = {
		'rw_sw_dc17',
		'rw_sw_dc15a',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
/* Снайпер */
PEHOTA_SNIP_LIGHT = 10
GM.Roles[PEHOTA_SNIP_LIGHT] = {
	Name = "Легкий снайпер", 
	NeedToUp = {
		role = PEHOTA_LIGHT,
	},
	Wep = {
		'rw_sw_dc17',
		'rw_sw_valken38x',
	},
	Params = {
		HP = 100,
		Armor = 70,
	}
}
PEHOTA_SNIP_HARD = 11
GM.Roles[PEHOTA_SNIP_HARD] = {
	Name = "Тяжелый снайпер", 
	NeedToUp = {
		role = PEHOTA_SNIP_LIGHT,
	},
	BlockFor = {
		batalion = {
			['104th'] = true,
			['Guard'] = true,
		},
	},
	Wep = {
		'rw_sw_dual_dc17',
		'tfa_sw_bowcaster',
	},
	Params = {
		HP = 100,
		Armor = 70,
	}
}
/* Разведчик */
PEHOTA_RAZVED = 12
GM.Roles[PEHOTA_RAZVED] = {
	Name = "Разведчик", 
	NeedToUp = {
		role = PEHOTA_LIGHT,
	},
	BlockFor = {
		batalion = {
			CT = true,
			['501th'] = true,
		},
	},
	Wep = {
		'rw_sw_dc17c',
	},
	Params = {
		HP = 100,
		Armor = 70,
	}
}
PEHOTA_SPY = 13
GM.Roles[PEHOTA_SPY] = {
	Name = "Шпион", 
	NeedToUp = {
		role = PEHOTA_RAZVED,
	},
	BlockFor = {
		batalion = {
			['104th'] = true,
		},
	},
	Wep = {
		'rw_sw_dc17c',
	},
	Params = {
		HP = 100,
		Armor = 70,
	}
}
PEHOTA_GROUP = 14
GM.Roles[PEHOTA_GROUP] = {
	Name = "Группа захвата", 
	NeedToUp = {
		role = PEHOTA_RAZVED,
	},
	BlockFor = {
		batalion = {
			['104th'] = true,
		},
	},
	Wep = {
		'rw_sw_dc17c',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
/* Штурмовик */
PEHOTA_SHTURM = 15
GM.Roles[PEHOTA_SHTURM] = {
	Name = "Штурмовик", 
	NeedToUp = {
		role = PEHOTA,
	},
	BlockFor = {
		batalion = {
			['104th'] = true,
		},
	},
	Wep = {
		'rw_sw_dc17c',
		'rw_sw_westarm5',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
PEHOTA_DESANT = 16
GM.Roles[PEHOTA_DESANT] = {
	Name = "Десантник", 
	NeedToUp = {
		role = PEHOTA_SHTURM,
	},
	BlockFor = {
		batalion = {
			CT = true,
			['104th'] = true,
		},
	},
	Wep = {
		'rw_sw_dc17c',
		'rw_sw_westarm5',
	},
	Priv = {
		JUST_I_WANT_TO_FLY = true,
	},
	Params = {
		HP = 100,
		Armor = 120,
	}
}
PEHOTA_GROUPFAST = 17
GM.Roles[PEHOTA_GROUPFAST] = {
	Name = "Группа быстрого реагирования", 
	NeedToUp = {
		role = PEHOTA_SHTURM, 
	},
	BlockFor = {
		batalion = {
			['104th'] = true,
			Guard = true,
		},
	},
	Wep = {
		'rw_sw_dc17c',
		'rw_sw_dp23',
	},
	Params = {
		HP = 100,
		Armor = 120,
	}
}
/* Тяжелый пехотинец */
PEHOTA_HARD = 18
GM.Roles[PEHOTA_HARD] = { 
	Name = "Тяжелый пехотинец", 
	NeedToUp = {
		role = PEHOTA,
	},
	BlockFor = {
		batalion = {
			CT = true,
		},
	},
	Wep = {
		'rw_sw_dc15a',
		'rw_sw_dp23',
	},
	Params = {
		HP = 110,
		Armor = 150,
	}
}
PEHOTA_HARD_PULEMET = 19
GM.Roles[PEHOTA_HARD_PULEMET] = {
	Name = "Пулеметчик", 
	NeedToUp = {
		role = PEHOTA_HARD,
	},
	BlockFor = {
		batalion = {
			CT = true,
		},
	},
	Wep = {
		'rw_sw_z6',
		'rw_sw_dc17',
	},
	Params = {
		HP = 100,
		Armor = 170,
	}
}
PEHOTA_HARD_ROCKET = 20
GM.Roles[PEHOTA_HARD_ROCKET] = { 
	Name = "Ракетчик", 
	NeedToUp = {
		role = PEHOTA_HARD,
	},
	BlockFor = {
		batalion = {
			CT = true,
			['501th'] = true,
			Guard = true,
		},
	},
	Wep = {
		'tfa_swch_clonelauncher',
		'rw_sw_dc15a',
	},
	Params = {
		HP = 120,
		Armor = 170,
	}
}
PEHOTA_HARD_FIRE = 21
GM.Roles[PEHOTA_HARD_FIRE] = {
	Name = "Огнеметчик", 
	NeedToUp = {
		role = PEHOTA_HARD,
	},
	Wep = {
		'flamethrower_variant',
		'rw_sw_dc15a',
	},
	BlockFor = {
		batalion = {
			CT = true,
		},
	},
	Params = {
		HP = 150,
		Armor = 220,
	}
}
/* Инженер */
INJ_INFRASTUCK = 22
GM.Roles[INJ_INFRASTUCK] = {
	Name = "Инфраструктурщик", 
	NeedToUp = {
		role = INJ,
	},
	Wep = {
		'rw_sw_dc15s',
		'rw_sw_dc17ext',
	},
	Params = {
		HP = 100,
		Armor = 50,
	}
}
/* Технолог */
INJ_TECHNOLOG = 23
GM.Roles[INJ_TECHNOLOG] = {
	Name = "Технолог", 
	NeedToUp = {
		role = INJ_INFRASTUCK,
	},
	Wep = {
		'rw_sw_dc15s',
		'rw_sw_dc17ext',
	},
	Params = {
		HP = 100,
		Armor = 50,
	}
}
INJ_TURELL = 24
GM.Roles[INJ_TURELL] = {
	Name = "Турельщик", 
	NeedToUp = {
		role = INJ_TECHNOLOG,
	},
	BlockFor = {
		batalion = {
			CT = true,
			['501th'] = true, 
		},
	},
	Wep = {
		'rw_sw_dp24',
		'rw_sw_dc17ext',
	},
	Params = {
		HP = 100, 
		Armor = 100,
	}
}
INJ_GRENADER = 25
GM.Roles[INJ_GRENADER] = {
	Name = "Гренадер", 
	NeedToUp = {
		role = INJ_TURELL,
	},
	BlockFor = {
		batalion = {
			CT = true,
			['501th'] = true, 
			['Guard'] = true,
		},
	},
	Wep = {
		'tfa_grenade',
		'rw_sw_dc17c',
	},
	Params = {
		HP = 110,
		Armor = 100,
	}
}
INJ_PODRIVNIK = 26
GM.Roles[INJ_PODRIVNIK] = {
	Name = "Подрывник", 
	NeedToUp = {
		role = INJ_TECHNOLOG,
	},
	Wep = {
		'rw_sw_smartlauncher',
		'rw_sw_dc17ext',
	},
	Params = {
		HP = 110,
		Armor = 100,
	}
}
INJ_GLAVTEHN = 27
GM.Roles[INJ_GLAVTEHN] = {
	Name = "Гл. технолог", 
	NeedToUp = {
		role = {INJ_PODRIVNIK, INJ_GRENADER},
	},
	Wep = {
		'rw_sw_dc15le_o',
		'rw_sw_dual_dc17ext',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
INJ_PROG = 28
GM.Roles[INJ_PROG] = {
	Name = "Программист", 
	NeedToUp = {
		role = INJ_INFRASTUCK,
	},
	BlockFor = {
		batalion = {
			CT = true,
		},
	},
	Wep = {
		'rw_sw_dc15s',
		'rw_sw_dc17ext',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
INJ_PROGSTAR = 29
GM.Roles[INJ_PROGSTAR] = {
	Name = "Ведущий программист", 
	NeedToUp = {
		role = INJ_PROG,
	},
	Wep = {
		'rw_sw_dual_dc17ext',
		'rw_sw_dc15s',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}

INJ_MEHANIC = 30 
GM.Roles[INJ_MEHANIC] = {
	Name = "Механик", 
	NeedToUp = {
		role = INJ_INFRASTUCK,
		batalion = "none",  -- Отключено повышение до пилотов полностью до поры до времени
	},
	Wep = {
		'rw_sw_dc15s',
	},
	Params = {
		HP = 100,
		Armor = 50,
	}
}
INJ_LEGCVOZDUH = 31
GM.Roles[INJ_LEGCVOZDUH] = {
	Name = "Управление легкой воздушной", 
	NeedToUp = {
		role = INJ_MEHANIC,
	},
	
	Wep = {
		'rw_sw_dc15a',
		'rw_sw_dc17',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
INJ_LEGCVOZDUHBOMB = 32
GM.Roles[INJ_LEGCVOZDUHBOMB] = {
	Name = "Управление бомбардировщиком", 
	NeedToUp = {
		role = INJ_LEGCVOZDUH,
	},
	Wep = {
		'rw_sw_dc15a',
		'rw_sw_dc17',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
INJ_LEGCVOZDUHISTR = 33
GM.Roles[INJ_LEGCVOZDUHISTR] = {
	Name = "Управление истребителем", 
	NeedToUp = {
		role = INJ_LEGCVOZDUH,
	},
	Wep = {
		'rw_sw_dc15a',
		'rw_sw_dc17',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
INJ_STEDNAZEM = 34
GM.Roles[INJ_STEDNAZEM] = {
	Name = "Управление средней назменой техникой", 
	NeedToUp = {
		role = INJ_MEHANIC,
	},
	Wep = {
		'rw_sw_dc15s',
		'rw_sw_dc17',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
INJ_TYAJNAZEM = 35
GM.Roles[INJ_TYAJNAZEM] = {
	Name = "Управление тяжелой техникой", 
	NeedToUp = {
		role = INJ_STEDNAZEM,
	},
	Wep = {
		'rw_sw_dc15s',
		'rw_sw_dc17',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}
INJ_GLAVESKADR = 36
GM.Roles[INJ_GLAVESKADR] = {
	Name = "Глава эскадры",  
	NeedToUp = {
		role = {INJ_TYAJNAZEM,INJ_LEGCVOZDUHISTR,INJ_LEGCVOZDUHBOMB},
	},
	Wep = {
		'rw_sw_dc15a',
		'rw_sw_dual_dc17',
	},
	Params = {
		HP = 100,
		Armor = 100,
	}
}

JEDI = 37
GM.Roles[JEDI] = {
	Name = "Джедай",
	Prefix = "",
	Model = {
		['All'] = "models/cleiner.mdl",
	},
	Wep = {},
	Priv = {},
	Params = {
		HP = 200,
		Armor = 0,
	}
}

ARC_MEDIC = 8999
GM.Roles[ARC_MEDIC] = {
	Name = "Инструктор мед.",
	Prefix = "ARC ",
	NeedToUp = {
		role = MEDIC_OFF,
		batalion = "ARC",
	},
	Wep = {
		'weapon_swrp_def',
		'rw_sw_dc17ext',
		'rw_sw_dual_dc17ext',
		'weapon_bactainjector',
		'weapon_bactanade',
		'weapon_swrp_repairarmor',
	},
	Priv = {
		["ARC Can RoleUP"] = true,
	},
	Params = {
		HP = 100,
		Armor = 0,
	}
}
ARC_PEHOTA = 8998
GM.Roles[ARC_PEHOTA] = {
	Name = "Инструктор пехоты",
	Prefix = "ARC ",
	NeedToUp = {
		role = 	{	
					PEHOTA_GROUP,
				 	PEHOTA_SNIP_HARD, 
					PEHOTA_SPY, 
					PEHOTA_DESANT, 
					PEHOTA_GROUPFAST, 
					PEHOTA_HARD_PULEMET, 
					PEHOTA_HARD_ROCKET,
					PEHOTA_HARD_FIRE,
				},
		batalion = "ARC",
	},
	Wep = {
		'weapon_swrp_def',
		'rw_sw_dc17',
		'weapon_bactainjector',
		'weapon_bactanade',
		'rw_sw_dp23',
	},
	Priv = {
		["ARC Can RoleUP"] = true,
	},
	Params = {
		HP = 100,
		Armor = 0,
	}
}

ARC_INJ = 8997
GM.Roles[ARC_INJ] = {
	Name = "Инструктор инж.",
	Prefix = "ARC ",
	NeedToUp = {
		role = 	{	
					INJ_GLAVTEHN, 
					INJ_PROGSTAR, 
					INJ_GLAVESKADR,
				},
		batalion = "ARC",
	},
	Wep = {
		'weapon_swrp_def',
		'rw_sw_dc17',
		'weapon_bactainjector',
		'weapon_bactanade',
		'rw_sw_dp23',
	},
	Priv = {
		["ARC Can RoleUP"] = true,
	},
	Params = {
		HP = 100,
		Armor = 0,
	}
}
GM.RolesWithCreate = { INJ,MEDIC,PEHOTA }
/*
#Инженер
**Техник
***Починка техники
***Производство техники
***|Управление техникой
****Управление легкой наземной техникой
*****Управление средней наземной техникой
*****Управление легкой воздушной
******Управление бомбардировщиком
******Управление истребителем
******|Управление техникой
*******Глава флота
********Управление венатором
#Медик
**Мед. интерн
***Мед. штабной
****Мед. полевой
*****Мед. инструктор
*****Гл. медик
#Снайпер
**Ассасин
**Тяжелый снайпер
**|Инструктор снайперов
#Пехотинец
*/
for i,v in pairs(GM.Roles) do GM.Roles[i].id = i end -- UpgradeSmall
/*
timer.Simple(0, function()
	for i,v in pairs(GAMEMODE.Roles) do 
		print(v.id, v.Name)
	end
end)
timer.Simple(0, function()
	local temp 
		relativeLoad = function(n, v, dataold)
			local bb = SWRP.Roles:FindRelativeClasses(v)
		n=n+1
		for i,v in pairs(bb) do
			for av=0, n do Msg("*") end
			 MsgN(v.Name)
			 //print(dataold)
			
			v.Model = v.Model or dataold.Model
			
			relativeLoad(n, v.id, v)
		end
	end
	for i,v in pairs(GAMEMODE.RolesWithCreate) do 
		local n = 0
		local bx = SWRP.Roles:FindRelativeClasses(v)
		for av=0, n do Msg("#") end
		MsgN(GAMEMODE.Roles[v].Name)
		local a = relativeLoad(n, v, GAMEMODE.Roles[v])
	end
	//PrintTable(GAMEMODE.Roles)
end) 
*/
/*
timer.Simple(0, function()
	local temp 
	relativeLoad = function(n, v)
		local bb = SWRP.Roles:FindRelativeClasses(v)
		n=n+1
		
		//if #bb != 1 then temp[#temp] = bb return end
		for i,v in pairs(bb) do
			if (v['NeedToUp'] and #v['NeedToUp'].role != 1) then temp = v return end
			for av=0, n do Msg("*") end
			 MsgN(v.Name)
			//PrintTable(bb)
			//local bb2 = SWRP.Roles:FindRelativeClasses(v.id)
			relativeLoad(n, v.id)
		end
		if temp != nil then
			for av=0, n do Msg("*") end
			MsgN("|"..temp.Name)
			//print(temp['NeedToUp'] and #temp['NeedToUp'].role)
			//PrintTable(SWRP.Roles:FindRelativeClasses(temp.id))
			local id = temp.id
			temp = nil
			relativeLoad(n, id)
			
		end
		//print('11')
		//return # != 0 and SWRP.Roles:FindRelativeClasses(v) or false
	end
	for i,v in pairs(GAMEMODE.RolesWithCreate) do 
		local n = 0
		local bx = SWRP.Roles:FindRelativeClasses(v)
		for av=0, n do Msg("#") end
		//PrintTable(bx)
		MsgN(GAMEMODE.Roles[v].Name)
		local a = relativeLoad(n, v)
//		PrintTable()
		//GM.Roles[i].id = i 
	end -- UpgradeSmall

//	PrintTable(GAMEMODE.Roles)
end) 
*/
SWRP.Roles = {}


function SWRP.Roles:DRoleName(id, extraname)
	id = tonumber(id) or 0
	local tagn = ""
	if extraname then
		tagn = " "..extraname
	end
	return GAMEMODE.Roles[id].Name..tagn, GAMEMODE.Roles[id].Prefix
end
//local loop = 0

relativeLoadRolesForDeep = function(class, rank, tabl)
	local bb = SWRP.Roles:FindRelativeClasses(class, rank)
	for i,v in pairs(bb) do
		local add = true
		for zz,za in pairs(tabl) do
			if za.id == v.id then add = false break end
		end
		if add then
			table.insert(tabl, v)
		end
		relativeLoadRolesForDeep(v.id, rank, tabl)
	end
end
function SWRP.Roles:FindRelativeClassesDeep(class, rank)
	local tabl = {}
	relativeLoadRolesForDeep(class, rank, tabl) 
	return tabl
end

relativeLoadRolesForDeepArc = function(class, rank, tabl, ifcheck, cb)
	local bb = SWRP.Roles:FindRelativeClasses(class, rank)
	for i,v in pairs(bb) do
		local add = true
		if v.id == ifcheck then return cb(true) end
		for zz,za in pairs(tabl) do
			if za.id == v.id then add = false break end
		end
		if add then
			table.insert(tabl, v)
		end
		relativeLoadRolesForDeepArc(v.id, rank, tabl, ifcheck, cb)
	end
end
function SWRP.Roles:FindRelativeClassesDeepArc(class, rank, ifcheck, cb)
	local tabl = {}
	if ifcheck then
		ifcheck = tonumber(ifcheck)
	end
	
	relativeLoadRolesForDeepArc(class, rank, tabl, ifcheck, function(bool)
		return cb(bool)
	end) 
	return tabl
end

relativeLoadRolesForBlockBats = function(class, rank, bat, char, cb)
	local bb = SWRP.Roles:DRoleInfo(class)
	//PrintTable(bb)
	if istable(bb) then
		if bb.BlockFor && bb.BlockFor.batalion && bb.BlockFor.batalion[bat] then
			if istable(bb.NeedToUp.role) then
				return relativeLoadRolesForBlockBats(bb.NeedToUp.role[1], rank, bat, char, cb)
			end
		end
		if cb then
			return cb(bb)
		end
	end
	return false
end
function SWRP.Roles:FindRelativeClassesBlockBats(class, rank, bat, char, cb)
	rank = tonumber(rank)
	class = tonumber(class)
	
	relativeLoadRolesForBlockBats(class, rank, bat, char, function(bool)
		return cb(char, bool)
	end) 
end
/*
timer.Simple(0, function()
	SWRP.Roles:FindRelativeClassesBlockBats(INJ_GRENADER, CC, "CT", function(data)
		PrintTable(data)
	end)
end)
*/
function SWRP.Roles:SWEPForRole(class)
	local info = SWRP.Roles:DRoleInfo(class)
	return istable(info.Wep) and info.Wep or {}
end

function SWRP.Roles:FindRelativeClasses(class, rank, batalion)
	//loop = loop + 1 
	//if loop > 1000 then return end
	local ing = {}
	class = tonumber(class) or 0
	rank = tonumber(rank) or 0
	for i,v in pairs(GAMEMODE.Roles) do
		if istable(v) then
			//if v['NeedToUp'] and v['NeedToUp'].role == class then
			if v['NeedToUp'] and v['NeedToUp'].role then
				if !istable(v['NeedToUp'].role) then
					local b = v['NeedToUp'].role
					v['NeedToUp'].role = {b}
				end
				for i,w in pairs(v['NeedToUp'].role) do
					if w == class then
						if batalion and v.BlockFor and v.BlockFor and v.BlockFor.batalion and v.BlockFor.batalion[batalion] then continue end
						if rank and v.NeedToUp.rank and rank < v.NeedToUp.rank then continue end
						if batalion and v.NeedToUp.batalion and batalion != v.NeedToUp.batalion then continue end
						table.insert(ing, v)
					end
				end
			end
		end
	end
			
	return ing
end

timer.Simple(0, function()
	-- SWRP.Roles:FindRelativeClasses(INJ_MEHANIC, 0, true)
	//PrintTable(SWRP.Roles:FindRelativeClassesDeep(INJ_MEHANIC))
end)

function SWRP.Roles:DListCanChangeRole(ply)
	if ply.Char then
		local c = ply.Char
		local rl = c.role == "0" and c.role_selected or c.role
		//local bat = c.batalion == "0" and c.role_selected or c.role
		//PrintTable(c)
		local lst = SWRP.Roles:FindRelativeClasses(rl, c.rank, c.batalion)
		return (lst) 
	elseif IsValid(ply) then
		local rl = ply:GetNWString("Char.Role") == "0" and ply:GetNWString("Char.RoleSelect") or ply:GetNWString("Char.Role")
		local lst = SWRP.Roles:FindRelativeClasses(rl, ply:GetNWString("Char.Rank"), ply:GetNWString("Char.Batalion"))
		return (lst) 
	end
	return false
end


function SWRP.Roles:RoleUP(ply, role)
	if ply.Char then
		local aa = SWRP.Roles:DListCanChangeRole(ply)
		local selected = false
		if !aa then return end
		for i,v in pairs(aa) do
			if v.id == role then selected = v break end
		end	
		if selected then
			ply.Char.role = selected.id
			ply.Char.model, ply.Char.bodygroup, ply.Char.skin = SWRP.Roles:DRoleModel(ply)
			
			
			GAMEMODE:SaveCharacter(ply)
			local player = player.GetBySteamID(ply.Char.steamid)
			if player then
				/*
				player:SetNWString('CharName', GAMEMODE:CharName(_, true, ply.Char))
				
				local text = ""
				if table.Count(ply.Char.batalionInfo) != 0 then text = (ply.Char.batalionInfo.named_beauty != "0000" and ply.Char.batalionInfo.named_beauty or ply.Char.batalionInfo.named).." " end
				text = text .. SWRP.Roles:DRoleName(ply.Char.role, ply.Char.special_name)
				player:SetNWString('BatName', text)
				*/
				player:CharacterSelect(ply.Char.id)
				/*INFO - Notification*/
			end
		end
	end
	/*
	local id = ply.Char.role 
	id = tonumber(id)
	
	if id+1 > MAX_RANK then return end
	local zzz = 1
	for i=id+1, MAX_RANK do
		zzz = i
		if SWRP.Ranks:GetRank(i) then break end
	end
	
	if !SWRP.Ranks:GetRank(zzz) then return end
	
	ply.Char.rank = zzz
	ply.Char.model, ply.Char.bodygroup = SWRP.Roles:DRoleModel(ply)
	
	ply:SetModel(ply.Char.model)
	ply:SetBodyGroups(ply.Char.bodygroup)
	
	ply:CharacterSave() 

	ply:SetNWString('CharName', GAMEMODE:CharName(_, true, ply.Char))
	
	local text = ""
	if table.Count(ply.Char.batalionInfo) != 0 then text = (ply.Char.batalionInfo.named_beauty != "0000" and ply.Char.batalionInfo.named_beauty or ply.Char.batalionInfo.named).." " end
	text = text .. SWRP.Roles:DRoleName(ply.Char.role, ply.Char.special_name)
	ply:SetNWString('BatName', text)
	return true
	*/
end
/*
tab:
role	=	5
sid	=	5
*/
netstreamSWRP.Hook("Roles::RoleUP", function(ply, tab)
	if !ply:DGetPriv("ARC Can RoleUP") then
		if tonumber(ply.Char.rank) < SGT && ply.Char.batalion == "ARC" then
			netstreamSWRP.Start( ply, "GM:Notification", {
				text = "Тебе нужно звание SGT+, чтобы обучать", 
				type = NOTIFY_ERROR, 
				length = 4
			} )
			return
		end
	end
	/*

	if !SWRP.Ranks:DGetPriv(ply.Char.rank, 'BatalionCanRankUP') then
		local data = {}
		data.text, data.type, data.length = "Недостаточно привелегий %CanRoleUP%", NOTIFY_ERROR, 4
		netstreamSWRP.Start( ply, "GM:Notification", data )
		//return 
	end
*/	
	local char = GAMEMODE:GetCharacterID( tab.sid )
	if char then
		SWRP.Roles:RoleUP({Char = char}, tab.role)
	end
	/*
		role	=	5
		sid	=	5

	*/
	/*
	local tab = player.GetBySteamID(tab)
	
	if !SWRP.Ranks:DGetPriv(ply.Char.rank, 'BatalionCanRankUP') then
		local data = {}
		data.text, data.type, data.length = "Недостаточно привелегий %CanRankUP%", NOTIFY_ERROR, 4
		netstreamSWRP.Start( ply, "GM:Notification", data )
		//return 
	end
	if tab and tab.Char then
		SWRP.Batalions:RankUP(tab)
	end
	*/
end)

//print('--------------------')
//PrintTable(SWRP.Roles:DListCanChangeRole(Entity(1)))
//print('--------------------')

function SWRP.Roles:DRoleModel(ply)
	local char = ply.Char
	role = tonumber(char.role) or 'All'
	class = tonumber(char.class) or 0
	rank = tonumber(char.rank) or 0
	
	//PrintTable(char)
	//PrintTable(SWRP.Batalions)
	if char.special_id_role != "NULL" then
		local ID = char.special_id_role
		if SWRP.SpecialRoles[ID] then
			local data = SWRP.SpecialRoles[ID]
			if data.Model then
            	return data.Model, data.BodyGroups or '0', data.Skin or 0
			end
        end
	end

	local prioritymodel = SWRP.Batalions.SpecialsBataions[char.batalion]
	local retdata = {}
	if prioritymodel then
		prioritymodel = (prioritymodel[rank] and prioritymodel[rank][role] or prioritymodel[rank]["All"] )
		retdata.x, retdata.y, retdata.z = prioritymodel.Model or '', prioritymodel.BodyGroups or '0000000000', prioritymodel.Skin or 0
	else
		local ct = SWRP.Batalions.SpecialsBataions["CT"]
		//print(ct[rank], role)
		//print()
		retdata.x, retdata.y, retdata.z  = 
		(ct[rank] and ct[rank][role] and ct[rank][role].Model or ct[rank]["All"].Model ) or ct[0]["All"].Model or "models/player/clone cadet/clonecadet.mdl",
		(ct[rank] and ct[rank][role] and ct[rank][role].BodyGroups or ct[rank]["All"].BodyGroups) or ct[0]["All"].BodyGroups or "0000000000",
		(ct[rank] and ct[rank][role] and ct[rank][role].Skin or ct[rank]["All"].Skin) or ct[0]["All"].Skin or 0
	end
	return retdata.x, retdata.y, retdata.z
end 

function SWRP.Roles:DRoleInfo(id)
	id = tonumber(id) or 0
	return GAMEMODE.Roles[id] or GAMEMODE.Roles[NIL]
end

local meta = FindMetaTable( "Player" )
function meta:GetRole(id)
	id = id or false
	local this = (CLIENT and GAMEMODE or self)
	if this.Char then
		local ids = tonumber(this.Char.role)
		if id then
			return id == ids 
		end
		return this.Char.role 
	end
	return id and false or 0
end