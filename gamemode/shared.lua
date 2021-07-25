SWRP = {}
include("autolua.lua")

AddLuaCSFolder("cl_various")
AddLuaCSFolder("cl_hud/vgui")
AddLuaCSFolder("cl_hud/menus")
AddLuaCSFolder("cl_hud")

AddLuaSHFolder("sh_various")

AddLuaSVFolder("sv_various")



function GM:PlayerNoClip( pl )
	return pl:IsSuperAdmin()
end

if (SERVER) then AddCSLuaFile("starwarsrp/sh_init.lua") end
include("starwarsrp/sh_init.lua")

TEAM_PLAYERS = 1
function GM:CreateTeams()
	team.SetUp(TEAM_PLAYERS, "%название%", Color(250,250,250), false)
	team.SetColor( TEAM_SPECTATOR, team.GetColor(TEAM_SPECTATOR) )
end