resource.AddWorkshop( '1950575140' ) // [SWRP] 14
resource.AddWorkshop( '1950583811' ) // [SWRP] 15
resource.AddWorkshop( '1950594436' ) // [SWRP] 16
resource.AddWorkshop( '1950600181' ) // [SWRP] 17
resource.AddWorkshop( '1950607619' ) // [SWRP] 18
resource.AddWorkshop( '1950609686' ) // [SWRP] 19
resource.AddWorkshop( '1950614946' ) // [SWRP] 20
resource.AddWorkshop( '1950617072' ) // [SWRP] 21
resource.AddWorkshop( '1950620573' ) // [SWRP] 22
resource.AddWorkshop( '1950625814' ) // [SWRP] 23
resource.AddWorkshop( '1950632604' ) // [SWRP] 24
resource.AddWorkshop( '1950636392' ) // [SWRP] 25
resource.AddWorkshop( '1950640879' ) // [SWRP] 26
resource.AddWorkshop( '1950646899' ) // [SWRP] 27
resource.AddWorkshop( '1950647596' ) // [SWRP] 28

/*

Нужно зайти на страницу коллекции и инспектор написать ниже 

var elements_1 = document.querySelectorAll('.collectionItem');
var text = "\n"
for (var elem of elements_1) {
	text += ("resource.AddWorkshop( '"+elem.id.split('_')[1] +"' ) // "+elem.children[2].children[0].innerText+"\n");
}

*/
function GM:Initialize()
end

function GM:Think()
end

function GM:CheckPassword(Mystery,IP,ServerPassword,Name)
	--This new hook returns AllowJoin,BlockMessage
end

--Damnit Garry!
function GM:PlayerSetModel( ply )
end



local function HookReloadMap_Second()
	local pls = player.GetAll()
	print('players', #pls)
	if #pls == 0 then
		RunConsoleCommand("changelevel", game.GetMap())
	end
end 

local function HookReloadMap()
	if !file.Exists( "map_refresh.txt", "DATA" ) then
		file.Write("map_refresh.txt", os.date( "%Y-%m-%d" ))
	end
	
	local data = file.Read( "map_refresh.txt" )
	
	if os.date( "%Y-%m-%d" ) != data then
		print('new day')
		file.Write("map_refresh.txt", os.date( "%Y-%m-%d" ))
		timer.Create("CheckIfNo0PlayersOnServer", 60, 0, HookReloadMap_Second)
	end
end
timer.Create( "ReloadMap", 60*30, 0, HookReloadMap )

AddCSLuaFile( "autolua.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )




