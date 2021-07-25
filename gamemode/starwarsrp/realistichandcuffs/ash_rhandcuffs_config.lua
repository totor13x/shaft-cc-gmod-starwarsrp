--[[
It will now put the player in the driver seat if no seat is available (allows usage of chairs etc)
Added German language (phynx https://steamcommunity.com/profiles/76561198040343084 )
Added checks so if bLogs fails to correctly it will no longer error

Configs added:
None
]]
print("CONFIG LOADED")
print("CONFIG LOADED")
print("CONFIG LOADED")
print("CONFIG LOADED")
print("CONFIG LOADED")
print("CONFIG LOADED")
print("CONFIG LOADED")
print("CONFIG LOADED")
print("CONFIG LOADED")
print("CONFIG LOADED")
print("CONFIG LOADED")
RHandcuffsConfig = {}

--Contact me on SF for help to translate
--Languages available:
--[[
Chinese
Danish
Dutch
English
French
German
Norwegian
Russian
]]
RHandcuffsConfig.LanguageToUse = "Russian"
 
RHandcuffsConfig.JailerModel = "models/player/Group01/Female_01.mdl"
RHandcuffsConfig.JailerText = "Jailer"
 
RHandcuffsConfig.BailerModel = "models/Barney.mdl"
RHandcuffsConfig.BailerText = "Bailer"
 
RHandcuffsConfig.CuffSound = "weapons/357/357_reload1.wav"
 
//The bail price for each year so -> YEARS*ThisConfig, so 10 years = 5000 in this case
RHandcuffsConfig.BailPricePerYear = 1000
//How many years(minutes) can a player be arrested for?
RHandcuffsConfig.MaxJailYears = 15
//How long it takes to lockpick the cuffs
RHandcuffsConfig.CuffPickTime = 15
//How long it takes to cuff someone
RHandcuffsConfig.CuffTime = 2
//Displays if player is cuffed overhead while aiming at him
RHandcuffsConfig.DisplayOverheadCuffed = true
//Calculates Movement/Penalty, so 2 would make player move half as fast
//Moving penalty while cuffed
RHandcuffsConfig.RestrainedMovePenalty = 3
//Moving penalty while dragging
RHandcuffsConfig.DraggingMovePenalty = 3
//Setting this to true will cause the system to bonemanipulate clientside, might cause sync issues but won't require you to install all playermodels on the server
RHandcuffsConfig.BoneManipulateClientside = false
//Range for cuffing
RHandcuffsConfig.CuffRange = 75
//Range while dragging, if player is too far away the dragging will cancel
RHandcuffsConfig.DragMaxRange = 185
//Maximum of velocity for dragging (raise if dragging is slow)
RHandcuffsConfig.DragMaxForce = 95
//Lower this to raise the velocity of dragging (lower if dragging is slow)
RHandcuffsConfig.DragRangeForce = 120
//Does the player has to be cuffed in order to arrest him?
RHandcuffsConfig.RestrainArrest = true
//Can only arrest players through the jailer NPC
RHandcuffsConfig.NPCArrestOnly = true
//Should the player stay cuffed after arrested?
RHandcuffsConfig.RestrainOnArrest = true
//Cuffs must be removed before you can unarrest if this is set to true
RHandcuffsConfig.UnarrestMustRemoveCuffs = true
//Give rewards when successfully arrested someone?
RHandcuffsConfig.ArrestReward = true
//Reward amount
RHandcuffsConfig.ArrestRewardAmount = 2500
//Reward for each weapon
RHandcuffsConfig.ConfiscateRewardAmount = 1000
--[[
1 = Only cuffing player can drag
2 = Only jobs in the RHC_PoliceJobs can drag
3 = Anyone can drag
]]
RHandcuffsConfig.DraggingPermissions = 3
//Key to drag a player
//https://wiki.garrysmod.com/page/Enums/IN
RHandcuffsConfig.KEY = IN_USE
 
RHandcuffsConfig.SurrenderEnabled = false
//All keys can be found here -> https://wiki.garrysmod.com/page/Enums/KEY
//Key for surrendering
RHandcuffsConfig.SurrenderKey = KEY_K
 
//Disables drawing player shadow
//Only use this if the shadows are causing issues
//This is a temp fix, will be fixed in the future
RHandcuffsConfig.DisablePlayerShadow = false
 
RHandcuffsConfig.BlackListedWeapons = {
["gmod_tool"] = true,
["keys"] = true,
["pocket"] = true,
["driving_license"] = true,
["weapon_physcannon"] = true,
["gmod_camera"] = true,
["weapon_physgun"] = true,
["weapon_r_restrained"] = true,
["tbfy_surrendered"] = true,
["weapon_r_cuffed"] = true,
["collections_bag"] = true
}
 
//Sets players to a specific team when arrested
RHandcuffsConfig.SetTeamOnArrest = false
//Allow DarkRP to create teams
timer.Simple(3, function()
    //The team it sets on player during jailtime if enabled
    RHandcuffsConfig.ArrestTeam = TEAM_GANG
    //Jobs that can use the cuffs and gets it as loadout
    RHandcuffsConfig.PoliceJobs = {TEAM_SWATLEADER, TEAM_SWATMEMBER, TEAM_COPS, TEAM_COP, TEAM_JUGGERNAUT, TEAM_PDCI, TEAM_PDI, TEAM_PDSGT, TEAM_PDCPL, TEAM_PDCBL, TEAM_PDPFC, TEAM_PDPVT, TEAM_Cadet, TEAM_MAYOR, TEAM_SECRETS}
end)
 
//Add all female models here or the handcuffs positioning will be weird
//It's case sensitive, make sure all letters are lowercase
RHandcuffsConfig.FEMALE_MODELS = {
    "models/player/group01/female_01.mdl",
    "models/player/group01/female_02.mdl",
    "models/player/group01/female_03.mdl",
    "models/player/group01/female_04.mdl",
    "models/player/group01/female_05.mdl", 
    "models/player/group01/female_06.mdl",
    "models/player/group03/female_01.mdl",
    "models/player/group03/female_02.mdl",
    "models/player/group03/female_03.mdl",
    "models/player/group03/female_04.mdl",
    "models/player/group03/female_05.mdl", 
    "models/player/group03/female_06.mdl",
}