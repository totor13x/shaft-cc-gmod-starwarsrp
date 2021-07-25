/*
Gateway Gaming Weapons Pack
Gateway Gaming Weapons Pack 2
Gateway Gaming Weapons Pack 3
TFA Base SV Edition 
[ TFA Star Wars ] Expanded Required Resources #1 
[TFA Official] Star Wars Shared Resources [ Sounds, Icons, Shared Support Menu ]


tfa_swch_dc15a_bluecamo_fray

DEFAULT 
tfa_omega_dc15sa

INJ
tfa_omega_repshot

SHTURM
tfa_omega_dc15a

SNIP
tfa_omega_repsnip

[SR] Null - Для теста
models/kylejwest/synergyroleplay/sr3dnullprudiimando/sr3dnullprudiimando.mdl


cgi clone cadet - Старт
models/player/clone cadet/clonecadet.mdl

*/
function AddLuaCSFolder(DIR)
	local Dir 		= GM.Folder:gsub("gamemodes/","").."/gamemode/"
	local GAMEFIL 	= file.Find(Dir..DIR.."/*.lua","LUA")
	
	for k,v in pairs( GAMEFIL ) do
		if (CLIENT) then include(Dir..DIR.."/"..v)
		else AddCSLuaFile(Dir..DIR.."/"..v) end
	end
end

function AddLuaSVFolder(DIR)
	local Dir 		= GM.Folder:gsub("gamemodes/","").."/gamemode/"
	local GAMEFIL	= file.Find(Dir..DIR.."/*.lua","LUA")
	
	for k,v in pairs( GAMEFIL ) do
		if (SERVER) then include(Dir..DIR.."/"..v) end
	end
end 

function AddLuaSHFolder(DIR)
	local Dir 		= GM.Folder:gsub("gamemodes/","").."/gamemode/"
	local GAMEFIL 	= file.Find(Dir..DIR.."/*.lua","LUA")
	
	for k,v in pairs( GAMEFIL ) do
		if (SERVER) then AddCSLuaFile(Dir..DIR.."/"..v) end
		include(Dir..DIR.."/"..v)
	end
end
 