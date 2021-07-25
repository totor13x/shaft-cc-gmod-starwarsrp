local NameOf = "501th"
print("Load "..NameOf)
if not sql.Query("SELECT * FROM batalion_list WHERE named = '"..NameOf.."'") then
	sql.Query("INSERT INTO `batalion_list` (`owner_steamid`,`allow_class`,`named`,`named_beauty`) values ('STEAM_0:1:58105', '[]', '"..NameOf.."','501-ый')")
end


SWRP.Batalions.SpecialsBataions[NameOf] = {
	[TRP] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '000000000000000000',
			Skin = 0,
		},
		[INJ_INFRASTUCK] = {
			Model = 'models/eng_gen/pm_coruscant_eng_gen.mdl',
			BodyGroups = '0000',
			Skin = 1,
		},
		[INJ_TECHNOLOG] = {
			Model = 'models/player/988thheb/trooper/988trooper.mdl',
			BodyGroups = '000',
			Skin = 2,
		},
		[INJ_PODRIVNIK] = {
			Model = 'models/coruscant_guard/combat_engineer_squad/cgces2.mdl',
			BodyGroups = '0011',
			Skin = 2,
		},
		[INJ_PROG] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '020000001000005500',
			Skin = 0,
		},
		


		[MEDIC_INTERN] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0000000000000',
			Skin = 1,
		},
		[MEDIC_POLE] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0000040100000',
			Skin = 1,
		},
		[MEDIC_SHTAB] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0000010100001',
			Skin = 1,
		},
		[MEDIC_OFF] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0030010320031',
			Skin = 1,
		},
		


		[PEHOTA_LIGHT] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '000110010100000000',
			Skin = 0,
		},
		[PEHOTA_SNIP_LIGHT] = {
			Model = 'models/player/gideon/501st/501st_arf/501st_arf.mdl',
			BodyGroups = '000100100005010',
			Skin = 0,
		},
		[PEHOTA_SNIP_HARD] = {
			Model = 'models/player/gideon/501st/501st_arf/501st_arf.mdl',
			BodyGroups = '010100100005010',
			Skin = 0,
		},
		[PEHOTA_GROUP] = {
			Model = 'models/player/gideon/501st/501st_tct/501st_tct.mdl',
			BodyGroups = '0100000021000010',
			Skin = 0,
		},
		[PEHOTA_SHTURM] = {
			Model = 'models/player/gideon/501st/501st_trooper/501st_trooper.mdl',
			BodyGroups = '020000000000',
			Skin = 0,
		},
		[PEHOTA_DESANT] = {
			Model = 'models/player/gideon/501st/501st_jet/501st_jet.mdl',
			BodyGroups = '000000010000',
			Skin = 0,
		},
		[PEHOTA_GROUPFAST] = {
			Model = 'models/player/cblake/synergy/2ndac/2ac_trp/2ac_trp.mdl',
			BodyGroups = '00000041100022',
			Skin = 0,
		},
		[PEHOTA_HARD] = {
			Model = 'models/player/gideon/501st/501st_snow/501st_snow.mdl',
			BodyGroups = '0',
			Skin = 0,
		},
		[PEHOTA_HARD_PULEMET] = {
			Model = 'models/player/gideon/501st/501st_heavy/501st_heavy.mdl',
			BodyGroups = '01000000021013000',
			Skin = 0,
		},
		[PEHOTA_HARD_FIRE] = {
			Model = 'models/artel/mvgmegaclone/501megaclone.mdl',
			BodyGroups = '0',
			Skin = 0,
		},
	},
}

/*
SWRP.Batalions.SpecialsBataions[NameOf] = {
	[TRP] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_trooper/501st_trooper.mdl',
			BodyGroups = '000000000000',
			Skin = 0,
		},
		[MEDIC_INTERN] = {
			Model = 'models/player/gideon/501st/501st_medic/501st_medic.mdl',
			BodyGroups = '0000000100000',
			Skin = 0,
		},
		[MEDIC_POLE] = {
			Model = 'models/player/gideon/501st/501st_medic/501st_medic.mdl',
			BodyGroups = '0300001100000',
			Skin = 0,
		},
		[MEDIC_SHTAB] = {
			Model = 'models/player/gideon/501st/501st_medic/501st_medic.mdl',
			BodyGroups = '0300001100010',
			Skin = 0,
		},
		[MEDIC_OFF] = {
			Model = 'models/player/gideon/501st/501st_medic/501st_medic.mdl',
			BodyGroups = '0300001113311',
			Skin = 0,
		},
		[PEHOTA_LIGHT] = {
			Model = 'models/player/gideon/501st/501st_arf/501st_arf.mdl',
			BodyGroups = '000000000000000',
			Skin = 0,
		},
		[PEHOTA_SNIP_LIGHT] = {
			Model = 'models/player/gideon/501st/501st_arf/501st_arf.mdl',
			BodyGroups = '010001002000000',
			Skin = 0,
		},
		[PEHOTA_SNIP_HARD] = {
			Model = 'models/player/gideon/501st/501st_arf/501st_arf.mdl',
			BodyGroups = '010001002011111',
			Skin = 0,
		},
		[INJ_PODRIVNIK] = {
			Model = 'models/player/gideon/501st/501st_tup/501st_tup.mdl',
			BodyGroups = '03000000101100',
			Skin = 0,
		},
		[INJ_TURELL] = {
			Model = 'models/player/gideon/501st/501st_tup/501st_tup.mdl',
			BodyGroups = '01000001100301',
			Skin = 0,
		},
		[INJ_GRENADER] = {
			Model = 'models/player/gideon/501st/501st_tup/501st_tup.mdl',
			BodyGroups = '01000001110301',
			Skin = 0,
		},
		[INJ_TECHNOLOG] = {
			Model = 'models/player/gideon/501st/501st_tup/501st_tup.mdl',
			BodyGroups = '03000000000000',
			Skin = 0,
		},
		[INJ_INFRASTUCK] = {
			Model = 'models/player/gideon/501st/501st_tct/501st_tct.mdl',
			BodyGroups = '0300000000000000',
			Skin = 0,
		},
		[INJ_MEHANIC] = {
			Model = 'models/player/gideon/501st/501st_jet/501st_jet.mdl',
			BodyGroups = '000000020000',
			Skin = 0,
		},
		[INJ_TYAJNAZEM] = {
			Model = 'models/player/gideon/501st/501st_jet/501st_jet.mdl',
			BodyGroups = '010000120133',
			Skin = 0,
		},
		[INJ_LEGCVOZDUH] = {
			Model = 'models/player/gideon/501st/501st_pilot/501st_pilot.mdl',
			BodyGroups = '000000000',
			Skin = 0,
		},
		[INJ_LEGCVOZDUHISTR] = {
			Model = 'models/player/gideon/501st/501st_pilot/501st_pilot.mdl',
			BodyGroups = '010000110',
			Skin = 0,
		},
		[INJ_LEGCVOZDUHBOMB] = {
			Model = 'models/player/gideon/501st/501st_pilot/501st_pilot.mdl',
			BodyGroups = '010002113',
			Skin = 0,
		},
		[INJ_PROG] = {
			Model = 'models/player/gideon/501st/501st_hardcase/501st_hardcase.mdl',
			BodyGroups = '03000000000011',
			Skin = 0,
		},
		[INJ_PROGSTAR] = {
			Model = 'models/player/gideon/501st/501st_hardcase/501st_hardcase.mdl',
			BodyGroups = '03000020013011',
			Skin = 0,
		},
		[PEHOTA_HARD] = {
			Model = 'models/artel/mvgmegaclone/501megaclone.mdl',
			BodyGroups = '0',
			Skin = 0,
		},
		[PEHOTA_HARD_PULEMET] = {
			Model = 'models/player/gideon/501st/501st_heavy/501st_heavy.mdl',
			BodyGroups = '01010002200000011',
			Skin = 0,
		},
		[PEHOTA_HARD_ROCKET] = {
			Model = 'models/player/gideon/501st/501st_heavy/501st_heavy.mdl',
			BodyGroups = '01010010001101011',
			Skin = 0,
		},
		[PEHOTA_HARD_FIRE] = {
			Model = 'models/player/gideon/501st/501st_heavy/501st_heavy.mdl',
			BodyGroups = '0',
			Skin = 0,
		},
        [ARC_MEDIC] = {
			Model = 'models/player/ishtari/ct_arc/ct_arc.mdl',
			BodyGroups = '00120003001100130',
			Skin = 2,
		},
        [ARC_PEHOTA] = {
			Model = 'models/player/ishtari/ct_arc/ct_arc.mdl',
			BodyGroups = '00120003001100130',
			Skin = 2,
		},
        [ARC_INJ] = {
			Model = 'models/player/ishtari/ct_arc/ct_arc.mdl',
			BodyGroups = '00120003001100130',
			Skin = 2,
		},
	},
	[PVT] = {
		['All'] = {
			Model = "models/player/gideon/501st/501st_trooper/501st_trooper.mdl",
			BodyGroups = '000000000000',
		},
	},
	[PV1] = {
		['All'] = {
			Model = "models/player/gideon/501st/501st_trooper/501st_trooper.mdl",
			BodyGroups = '000000000010',
		},
	},
	[CPL] = {
		['All'] = {
			Model = "models/player/gideon/501st/501st_trooper/501st_trooper.mdl",
			BodyGroups = '000000005011',
		},
	},
	[MSG] = {
		['All'] = {
			Model = "models/player/gideon/501st/501st_trooper/501st_trooper.mdl",
			BodyGroups = '030000005511',
		},
	},
	[SGT] = {
		['All'] = {
			Model = "models/player/gideon/501st/501st_trooper/501st_trooper.mdl",
			BodyGroups = '030003005511',
		},
	},
	[SSG] = {
		['All'] = {
			Model = "models/player/gideon/501st/501st_dogma/501st_dogma.mdl",
			BodyGroups = '03001001000011',
		},
	},
	[ENS] = {
		['All'] = {
			Model = "models/player/gideon/501st/501st_dogma/501st_dogma.mdl",
			BodyGroups = '03002201005011',
		},
	},
	[SNS] = {
		['All'] = {
			Model = "models/player/gideon/501st/501st_officer/501st_officer.mdl",
			BodyGroups = '030010000000000000',
		},
	},
	[SMG] = {
		['All'] = {
			Model = "models/player/gideon/501st/501st_officer/501st_officer.mdl",
			BodyGroups = '030000002000000100',
		},
	},
	[MLT] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '010000000000000000',
		},
	},
	[LT] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '010000000010000100',
		},
	},
	[SLT] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '010000002200010100',
		},
	},
	[CPT] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '010000002200014100',
		},
	},
	[MAJ] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_tco/501st_tco.mdl',
			BodyGroups = '000000000000002211',
		},
	},
	[LTC] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_tco/501st_tco.mdl',
			BodyGroups = '000000002020011211',
		},
	},
	[COL] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_tco/501st_tco.mdl',
			BodyGroups = '000000012220011111',
		},
	},
	[CC] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_rex/501st_rex.mdl',
			BodyGroups = '0000000000000000000',
		},
	},
	[MCC] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_rex/501st_rex.mdl',
			BodyGroups = '0000011111100005511',
		},
	},
}
*/