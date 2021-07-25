//INSERT INTO `batalion_list` (`owner_steamid`,`allow_class`,`named`,`named_beauty`) values ('STEAM_0:0:331925970', '[]', '432st', '432-й')
local NameOf = "Guard"
print("Load "..NameOf)
if not sql.Query("SELECT * FROM batalion_list WHERE named = '"..NameOf.."'") then
sql.Query("INSERT INTO `batalion_list` (`owner_steamid`,`allow_class`,`named`,`named_beauty`) values ('STEAM_0:1:58105', '[]', '"..NameOf.."','Гвардия')")
end

SWRP.Batalions.Personally.LoadWeapons[NameOf] = function(ply)
	if tonumber(ply.Char.rank) >= MSG then 
		ply:Give('weapon_r_handcuffs')
	end
end

SWRP.Batalions.SpecialsBataions[NameOf] = {
	[TRP] = {
		['All'] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '000000000000000000',
			Skin = 2,
		},
		[INJ_INFRASTUCK] = {
			Model = 'models/eng_gen/pm_coruscant_eng_gen.mdl',
			BodyGroups = '0000',
			Skin = 3,
		},
		[INJ_TECHNOLOG] = {
			Model = 'models/player/988thheb/trooper/988trooper.mdl',
			BodyGroups = '000',
			Skin = 4,
		},
		[INJ_TURELL] = {
			Model = 'models/player/988thheb/commander/988commander.mdl',
			BodyGroups = '00000',
			Skin = 2,
		},
		[INJ_PODRIVNIK] = {
			Model = 'models/coruscant_guard/combat_engineer_squad/cgces2.mdl',
			BodyGroups = '0011',
			Skin = 0,
		},
		[INJ_PROG] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '020000001000005500',
			Skin = 2,
		},



		[MEDIC_INTERN] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0000000000000',
			Skin = 0,
		},
		[MEDIC_POLE] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0000040100000',
			Skin = 0,
		},
		[MEDIC_SHTAB] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0000010100001',
			Skin = 0,
		},
		[MEDIC_OFF] = {
			Model = 'models/player/gideon/coruscantguards/medic/cg_medic.mdl',
			BodyGroups = '0030010320031',
			Skin = 0,
		},



		[PEHOTA_LIGHT] = {
			Model = 'models/player/gideon/501st/501st_officer/501st_officer.mdl',
			BodyGroups = '000110010100000000',
			Skin = 2,
		},
		[PEHOTA_SNIP_LIGHT] = {
			Model = 'models/player/gideon/501st/501st_arf/501st_arf.mdl',
			BodyGroups = '000100100005010',
			Skin = 2,
		},
		[PEHOTA_RAZVED] = {
			Model = 'models/kylejwest/synergyroleplay/rancor/sr3drancorarftrooper/sr3drancorarftrooper.mdl',
			BodyGroups = '1000001010010',
			Skin = 3,
		},
		[PEHOTA_GROUP] = {
			Model = 'models/player/gideon/501st/501st_tct/501st_tct.mdl',
			BodyGroups = '0100000021000010',
			Skin = 2,
		},
		[PEHOTA_SHTURM] = {
			Model = 'models/player/gideon/501st/501st_trooper/501st_trooper.mdl',
			BodyGroups = '020000000000',
			Skin = 2,
		},
		[PEHOTA_DESANT] = {
			Model = 'models/player/gideon/501st/501st_jet/501st_jet.mdl',
			BodyGroups = '000000010000',
			Skin = 1,
		},
		[PEHOTA_HARD] = {
			Model = 'models/player/gideon/501st/501st_snow/501st_snow.mdl',
			BodyGroups = '0',
			Skin = 1,
		},
		[PEHOTA_HARD_PULEMET] = {
			Model = 'models/player/gideon/501st/501st_heavy/501st_heavy.mdl',
			BodyGroups = '01000000021013000',
			Skin = 2,
		},
		[PEHOTA_HARD_FIRE] = {
			Model = 'models/artel/mvgmegaclone/501megaclone.mdl',
			BodyGroups = '0',
			Skin = 2,
		},
	},
}