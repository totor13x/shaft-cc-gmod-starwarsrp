SWRP.Ranks = {}
SWRP.Ranks.List = {}
CUR = 0

//Рядовые
TRP = 1
PVT = 2
PV1 = 3
CPL = 4
//Сержанты
MSG = 5
SGT = 6
SSG = 7 
ENS = 8
SNS = 9
SMG = 10
//Младшие офицеры
MLT = 11
LT = 12
SLT = 13
CPT = 14
//Старшие офицеры
MAJ = 15
LTC = 16
COL = 17
CC = 18
//Высшие офицеры
MCC = 19
GMGL = 20
GL = 21
GC = 22
GA = 23
MCO = 24
CM = 25

MAX_RANK = CC
MAX_RANK_FOR_DO = CM 
/*
•Рядовой состав: 
TRP - Рекрут
PVT - Рядовой
PV1 - Рядовой первого класса
CPL - Капрал

•Сержантский состав
MSG - Младший Сержант
SGT - Сержант
SSG - Старший Сержант
ENS - Прапорщик
SNS - Старший Прапорщик
SMG - Сержант-Майор

•Младший офицерский состав
MLT - Младший Лейтенант
LT - Лейтенант
SLT -Старший лейтенант
CPT - Капитан

•Старший офицерский состав
MAJ - Майор
LTC - Подполковник
COL - Полковник
СС - Командер

•Высший офицерский состав
MCC - Маршал-командер
GM - Генерал Майор
GL - Генерал Лейтенант
GC - Генерал Полковник
GA - Генерал Армии
MCO - Маршал
CM - Верховный Главнокомандующий

MCC = 19
GMGL = 20
GC = 21
GA = 22
MCO = 23
CM = 24
*/

SWRP.Ranks.List[CUR] = {
	Name = "Курсант",
	Short = "CUR",
	Priv = {
		
	}
}

SWRP.Ranks.List[TRP] = {
	Name = "Рекрут",
	Short = "TRP",
	Priv = {
		Radio = true,
	}
}

SWRP.Ranks.List[PVT] = {
	Name = "Рядовой",
	Short = "PVT",
	Priv = {
		Radio = true,
	}
}
SWRP.Ranks.List[PV1] = {
	Name = "Рядовой первого класса",
	Short = "PV1",
	Priv = {
		Radio = true,
	}
}
SWRP.Ranks.List[CPL] = {
	Name = "Капрал",
	Short = "CPL",
	Priv = {
		Radio = true,
	}
}
SWRP.Ranks.List[MSG] = {
	Name = "Младший Сержант",
	Short = "MSG",
	Priv = {
		Radio = true,
	}
}
SWRP.Ranks.List[SGT] = {
	Name = "Сержант",
	Short = "SGT",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[SSG] = {
	Name = "Старший Сержант",
	Short = "SSG",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[ENS] = {
	Name = "Прапорщик",
	Short = "ENS",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[SNS] = {
	Name = "Старший Прапорщик",
	Short = "SNS",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[SMG] = {
	Name = "Сержант-Майор",
	Short = "SMG",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[MLT] = {
	Name = "Младший Лейтенант",
	Short = "MLT",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[LT] = {
	Name = "Лейтенант",
	Short = "LT",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[SLT] = {
	Name = "Старший Лейтенант",
	Short = "SLT",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[CPT] = {
	Name = "Капитан",
	Short = "CPT",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[MAJ] = {
	Name = "Майор",
	Short = "MAJ",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[LTC] = {
	Name = "Подполковник",
	Short = "LTC",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}
SWRP.Ranks.List[COL] = {
	Name = "Полковник",
	Short = "COL",
	Priv = {
		Radio = true,
		CanAcceptCadet = true,
	}
}

SWRP.Ranks.List[CC] = {
	Name = "Командер",
	Short = "CC",
	Priv = {
		Radio = true,
		BatalionEdit = true,
		BatalionCanRankUP = true,
		CanAcceptCadet = true,
	}
}

-- MCC - Маршал-командер
-- GMGL - Генерал Майор
-- GL - Генерал Лейтенант
-- GC - Генерал Полковник
-- GA - Генерал Армии
-- MCO - Маршал
-- CM - Верховный Главнокомандующий


SWRP.Ranks.List[MCC] = {
	Name = "Маршал-командер",
	Short = "MCC",
	Priv = SWRP.Ranks.List[CC].Priv
}
SWRP.Ranks.List[GMGL] = {
	Name = "Генерал-майор",
	Short = "GM",
	Priv = SWRP.Ranks.List[MCC].Priv
}
SWRP.Ranks.List[GL] = {
	Name = "Генерал-лейтенант",
	Short = "GL",
	Priv = SWRP.Ranks.List[GMGL].Priv
}
SWRP.Ranks.List[GC] = {
	Name = "Генерал-полковник",
	Short = "GC",
	Priv = SWRP.Ranks.List[GL].Priv
}
SWRP.Ranks.List[GA] = {
	Name = "Генерал армии",
	Short = "GA",
	Priv = SWRP.Ranks.List[GC].Priv
}
SWRP.Ranks.List[MCO] = {
	Name = "Маршал",
	Short = "MCO",
	Priv = SWRP.Ranks.List[GA].Priv
}
SWRP.Ranks.List[CM] = {
	Name = "Верховный Главнокомандующий",
	Short = "CM",
	Priv = SWRP.Ranks.List[MCO].Priv
}

-- GMGL - YUG - Юнлинг
-- GL - PAD - Падаван
-- GC - KGD - Рыцарь
-- GA - MSR - Мастер
-- MCO - MAG - Магистр
-- CM - GRAND - Гранд мастер

SWRP.RanksChanger = {
	J = {
		[GMGL] = {
			Name = "Юнлинг",
			Short = "YUG",
		},
		[GL] = {
			Name = "Падаван",
			Short = "PAD",
		},
		[GC] = {
			Name = "Рыцарь",
			Short = "KGD",
		},
		[GA] = {
			Name = "Мастер",
			Short = "MSR",
		},
		[MCO] = {
			Name = "Магистр",
			Short = "MAG",
		},
		[CM] = {
			Name = "Гранд-мастер",
			Short = "GRAND",
		},
	}
}

function SWRP.Ranks:GetRank(id, clsf) 
	id = tonumber(id) or 0//self.Ranks[tonumber(tab['rank']) or 0].Short
	
	clsf = clsf or "C"
	
	local info = table.Copy(SWRP.Ranks.List[id])
	
	if clsf != "C" then
		if SWRP.RanksChanger[clsf] and SWRP.RanksChanger[clsf][id] then
			table.Merge(info, SWRP.RanksChanger[clsf][id])
		end
	end
	
	return info or false
end
/*
timer.Simple(0, function()
PrintTable(SWRP.Ranks:GetRank(GL, "J"))
end)
*/
function SWRP.Ranks:DGetPrivPly(ply, priv)
	local _ply = ply
	if CLIENT then
		_ply = GAMEMODE
	end
	if _ply.Char then
		local rank = SWRP.Ranks:GetRank(_ply.Char.rank)
		local role = SWRP.Roles:DRoleInfo(ply:GetRole())
		
		if rank && rank.Priv && rank.Priv[priv] then
			return true
		end
		if role && role.Priv && role.Priv[priv] then
			return true
		end
	end
	return false
end
function SWRP.Ranks:DGetPriv(id, priv)
	local info = SWRP.Ranks:GetRank(id)
	-- print(id, priv, info.Priv)
	-- PrintTable(info.Priv)
	if info then
		return info.Priv and info.Priv[priv] or false
	end
	return false
end
function SWRP.Ranks:InsertNewRecord(ply) 
	if ply.Char then
		sql.Query("INSERT INTO `char_rank_up` (`character_id`,`rank`, `time`) values ('"..ply.Char.id.."', '"..ply.Char.rank.."', '"..os.time().."')")
	end
end
function SWRP.Ranks:LastInsertTime(ply) 
	if ply.Char then
		local last = sql.QueryRow("SELECT * FROM `char_rank_up` WHERE `character_id` = '"..ply.Char.id.."' ORDER BY id DESC")
		return last and last.time or 0
	end
end