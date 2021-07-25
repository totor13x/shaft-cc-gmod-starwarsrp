SWRP.Dev = true 
SWRP.Config = {}

SWRP.Config.SymbolVersion = "β"
SWRP.Config.BuildVersion = 0.6

local fullnameversion = ""
if SWRP.Config.SymbolVersion ~= "" then
	fullnameversion = "["..SWRP.Config.SymbolVersion.."] "
end
fullnameversion = fullnameversion..SWRP.Config.BuildVersion.." "

SWRP.Config.StartMenu = {}
SWRP.Config.StartMenu.Text = "Добро пожаловать на Shaft.CC\nВерсия сервера "..fullnameversion.." на данный момент все только начинается. Вы можете помочь нам со своими предложениями и замечаниями"  
SWRP.Config.StartMenu.DiscordButton = "https://discord.gg/3edNxSg"
//GM.Config.StartMenu = false 


-- Конфиг
SWRP.Config.TimeRespawn = 20
SWRP.maxWalkSpeed = 90


SWRP.SpecialRoles = SWRP.SpecialRoles or {} 

GM.Name 			= "StarWarsRP"
GM.Author 			= "pl0nch1 & Totor"
GM.Email 			= "totor_@outlook.com"
GM.Website 			= "shaft.cc"
GM.Version			= SWRP.Config.BuildVersion

local modulesPath = "starwarsrp/gamemode/starwarsrp"
local _, directories = file.Find(modulesPath .. "/*", "LUA")

local disabled_modules = {
	['_garrysmod_bsp_renderer-master'] = SWRP.Dev and true or false,
	['lightsabers_old'] = true,
	['lightsabers_renew'] = true,
	['anim-extension'] = true,  -- Не получилось отключить, поэтому воткнул no_anim-extension и *-holds
	['anim-extension-holds'] = true,
	//['lightsabers'] = true,
	//['entities_items'] = true,
}

if SERVER then print("--- MODULES ---") end
for _, mod in ipairs(directories) do
	if disabled_modules[mod] then continue end
	local dirprefix = string.sub(mod, 1, 3)
	if dirprefix == "no_" then continue end
	
	files = file.Find(modulesPath .. "/" .. mod .. "/*.lua", "LUA")
	if #files > 0 then
		if SERVER then print("LOADING " .. mod) end
	end
	for _, v in ipairs(files) do
		local ext = string.sub(v, 1, 3)
		if ext == "cl_" then
			if SERVER then
				AddCSLuaFile(modulesPath .. "/" .. mod .. "/" .. v)
			else
				include(modulesPath .. "/" .. mod .. "/" .. v)
			end
		elseif ext == "sv_" then
			if SERVER then
				include(modulesPath .. "/" .. mod .. "/" .. v)
			end
		else 
			if SERVER then
				AddCSLuaFile(modulesPath .. "/" .. mod .. "/" .. v)
			end
			include(modulesPath .. "/" .. mod .. "/" .. v)
		end
	end
end

hook.Run("PostGamemodeLoaded")
