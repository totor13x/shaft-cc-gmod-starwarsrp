//INSERT INTO `batalion_list` (`owner_steamid`,`allow_class`,`named`,`named_beauty`) values ('STEAM_0:0:331925970', '[]', '432st', '432-й')
local NameOf = "CT"
print("Load "..NameOf)
if not sql.Query("SELECT * FROM batalion_list WHERE named = '"..NameOf.."'") then
sql.Query("INSERT INTO `batalion_list` (`owner_steamid`,`allow_class`,`named`) values ('STEAM_0:1:58105', '[]', '"..NameOf.."')")
end

SWRP.Batalions.SpecialsBataions[NameOf] = {
	[TRP] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '000000000000000000',
			Skin = 3,
		},
		[INJ_INFRASTUCK] = {
			Model = 'models/eng_gen/pm_coruscant_eng_gen.mdl',
			BodyGroups = '0000',
			Skin = 0,
		},
		[INJ_TECHNOLOG] = {
			Model = 'models/player/988thheb/trooper/988trooper.mdl',
			BodyGroups = '000',
			Skin = 0,
		},
		[INJ_PODRIVNIK] = {
			Model = 'models/coruscant_guard/combat_engineer_squad/cgces2.mdl',
			BodyGroups = '0011',
			Skin = 1,
		},
		[ARC_INJ] = {
			Model = 'models/player/chet/donate/dante1/clone02dante.mdl',
			BodyGroups = '00000000000000000',
			Skin = 1,
		},
		[MEDIC_INTERN] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0000000000000',
			Skin = 4,
		},
		[MEDIC_POLE] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0000040100000',
			Skin = 4,
		},
		[MEDIC_SHTAB] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0000010100001',
			Skin = 4,
		},
		[MEDIC_OFF] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0030010320031',
			Skin = 4,
		},
		[ARC_MEDIC] = {
			Model = 'models/player/chet/donate/dante1/clone02dante.mdl',
			BodyGroups = '00000000000000000',
			Skin = 0,
		},
		[PEHOTA_LIGHT] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '000110010100000000',
			Skin = 3,
		},
		[PEHOTA_SNIP_LIGHT] = {
			Model = 'models/player/gideon/501st/501st_arf/501st_arf.mdl',
			BodyGroups = '000100100005010',
			Skin = 3,
		},
		[PEHOTA_SNIP_HARD] = {
			Model = 'models/player/gideon/501st/501st_arf/501st_arf.mdl',
			BodyGroups = '010100100005010',
			Skin = 3,
		},
		[PEHOTA_GROUP] = {
			Model = 'models/player/gideon/501st/501st_tct/501st_tct.mdl',
			BodyGroups = '0100000021000010',
			Skin = 3,
		},
		[PEHOTA_SHTURM] = {
			Model = 'models/player/gideon/501st/501st_trooper/501st_trooper.mdl',
			BodyGroups = '020000000000',
			Skin = 3,
		},
		[PEHOTA_GROUPFAST] = {
			Model = 'models/player/cblake/synergy/2ndac/2ac_trp/2ac_trp.mdl',
			BodyGroups = '00000041100022',
			Skin = 1,
		},
		[ARC_PEHOTA] = {
			Model = 'models/player/chet/donate/dante1/clone02dante.mdll',
			BodyGroups = '00000000000000000',
			Skin = 2,
		},
	},
	/*
	[PVT] = {
		['All'] = {
			Model = "models/reizer_cgi_p2_cm2/clone_trp/clone_trp.mdl",
			BodyGroups = '0000',
		},
	},
	[PV1] = {
		['All'] = {
			Model = "models/reizer_cgi_p2_cm2/clone_trp/clone_trp.mdl",
			BodyGroups = '0000',
		},
	},
	[CPL] = {
		['All'] = {
			Model = "models/reizer_cgi_p2_cm2/clone_trp/clone_trp.mdl",
			BodyGroups = '0001',
		},
	},
	[MSG] = {
		['All'] = {
			Model = "models/reizer_cgi_p2_cm2/clone_sgt/clone_sgt.mdl",
			BodyGroups = '000000',
		},
	},
	[SGT] = {
		['All'] = {
			Model = "models/reizer_cgi_p2_cm2/clone_sgt/clone_sgt.mdl",
			BodyGroups = '000000',
		},
	},
	[SSG] = {
		['All'] = {
			Model = "models/reizer_cgi_p2_cm2/clone_sgt/clone_sgt.mdl",
			BodyGroups = '000001',
		},
	},
	[ENS] = {
		['All'] = {
			Model = "models/reizer_cgi_p2_cm2/clone_sgt/clone_sgt.mdl",
			BodyGroups = '000101',
		},
	},
	[SNS] = {
		['All'] = {
			Model = "models/reizer_cgi_p2_cm2/clone_sgt/clone_sgt.mdl",
			BodyGroups = '001101',
		},
	},
	[SMG] = {
		['All'] = {
			Model = "models/reizer_cgi_p2_cm2/clone_sgt/clone_sgt.mdl",
			BodyGroups = '001101',
		},
	},
	[MLT] = {
		['All'] = {
			Model = 'models/reizer_cgi_p2_cm2/clone_lt/clone_lt.mdl',
			BodyGroups = '0000000',
		},
	},
	[LT] = {
		['All'] = {
			Model = 'models/reizer_cgi_p2_cm2/clone_lt/clone_lt.mdl',
			BodyGroups = '0000001',
		},
	},
	[SLT] = {
		['All'] = {
			Model = 'models/reizer_cgi_p2_cm2/clone_lt/clone_lt.mdl',
			BodyGroups = '0000011',
		},
	},
	[CPT] = {
		['All'] = {
			Model = 'models/reizer_cgi_p2_cm2/clone_lt/clone_lt.mdl',
			BodyGroups = '0010001',
		},
	},
	[MAJ] = {
		['All'] = {
			Model = 'models/reizer_cgi_p2_cm2/clone_cpt/clone_cpt.mdl',
			BodyGroups = '0010001',
		},
	},
	[LTC] = {
		['All'] = {
			Model = 'models/reizer_cgi_p2_cm2/clone_cpt/clone_cpt.mdl',
			BodyGroups = '0000001',
		},
	},
	[COL] = {
		['All'] = {
			Model = 'models/reizer_cgi_p2_cm2/clone_cmd/clone_cmd.mdl',
			BodyGroups = '001101000',
		},
	},
	[CC] = {
		['All'] = {
			Model = 'models/reizer_cgi_p2_cm2/clone_cmd/clone_cmd.mdl',
			BodyGroups = '000001000',
		},
	},
	[MCC] = {
		['All'] = {
			Model = 'models/reizer_cgi_p2_cm2/clone_cmd/clone_cmd.mdl',
			BodyGroups = '000000000',
		},
	},
	*/
}
