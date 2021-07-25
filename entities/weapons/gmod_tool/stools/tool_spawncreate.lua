TOOL.Category = "Constraints"
TOOL.Name = "Spawn Creator"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

print("spawncreatot init")

local SpawnsPoint = SpawnsPoint or {}
PrintTable(SpawnsPoint)
print("printing SpawnsPoint")

if SERVER then
	util.AddNetworkString("SpawnEditingSpawn")
	util.AddNetworkString("SpawnEditingRefresh")
	net.Receive("SpawnEditingRefresh", function(ln, ply)
		hook.Call("LoadSpawnsData")
		net.Start('SpawnEditingSpawn')
			net.WriteTable(SpawnsPoint)
		net.Send(ply)
	end)
	
	hook.Add("serverguard.RanksLoadedShared", "123s3123da", function()
		hook.Call("SaveSpawnsData", nil)
		hook.Call("LoadSpawnsData")
		net.Start('SpawnEditingSpawn')
			net.WriteTable(SpawnsPoint)
		net.Broadcast()
	end)
	
	netstream.Hook("ChosenSpawnBatalion", function(ply, data)
		ply.chosenSpawnBatalion = data
	end)
	
	hook.Add("PlayerSpawn", "asydgy", function(ply)
		if IsValid(ply) and ply.Char and (SpawnsPoint[ply.Char.batalion]) then
			if (table.Count(SpawnsPoint[ply.Char.batalion])>0) then
				ply:SetPos(table.Random(SpawnsPoint[ply.Char.batalion]))
			end
		end
	end)
else
	net.Receive("SpawnEditingSpawn", function()
		local table = net.ReadTable()
		LocalPlayer().SpawnList = table
	end)
	function InverseLerp( pos, p1, p2 )
	
		local range = 0
		range = p2-p1

		if range == 0 then return 1 end

		return ((pos - p1)/range)

	end
end

if CLIENT then
	net.Start('SpawnEditingRefresh')
	net.SendToServer()
end

function TOOL:Deploy()
	hook.Call("LoadSpawnsData")
	net.Start('SpawnEditingSpawn')
		net.WriteTable(SpawnsPoint)
	net.Send(self:GetOwner())
end

function TOOL:Think()
if CLIENT then
	for i,v in pairs(LocalPlayer().SpawnList or {}) do
		for k,d in pairs(v) do
			local dist = self:GetOwner():GetPos():Distance(d) 
			local color = Color(0,255,0)
			if dist < 150 then
				color = Color(255,0,0)
			end
			
			local bottomLight = DynamicLight(k);
			
			if (bottomLight) then
				bottomLight.pos = d;
				bottomLight.brightness = 0.5;
				bottomLight.Size = 350;
				bottomLight.Decay = 1000
				bottomLight.r = color.r;
				bottomLight.g = color.g;
				bottomLight.b = color.b;
				bottomLight.DieTime = CurTime() + 0.2;
				bottomLight.style = 0;
			end
		end
	end

	return true
end
end

function TOOL:Reload()
	if ( !IsFirstTimePredicted() ) then return end
	if CLIENT then
		net.Start('SpawnEditingRefresh')
		net.SendToServer()
	end
end

function TOOL:ziiip(pos)
	for i,v in pairs(SpawnsPoint) do
		for k,d in pairs(v) do
			if d:Distance(pos) < 150 then
				return self:GetOwner():ChatPrint('Близко к другому спавну')
			end
		end
	end
	AddSpawnItem(pos, self:GetOwner().chosenSpawnBatalion)
	self:GetOwner():ChatPrint('Точка добавлена')
end

function TOOL:SAziiip(pos)
	for i,v in pairs(SpawnsPoint) do
		for k,d in pairs(v) do
			if d:Distance(pos) < 100 then
				self:GetOwner():ChatPrint('Точка удалена')
				RemoveSpawnItem(i,k)
				return
			end
		end
	end
	self:GetOwner():ChatPrint('Подойдите к точке чтобы она была на расстоянии 100 юнит.')
end

function TOOL:LeftClick()
	if SERVER then
		hook.Call("LoadSpawnsData")
		net.Start('SpawnEditingSpawn')
			net.WriteTable(SpawnsPoint)
		net.Send(self:GetOwner())
		if self:GetOwner().chosenSpawnBatalion == nil then
			self:GetOwner().chosenSpawnBatalion = "CT"
		end
		self:ziiip(self:GetOwner():GetPos())
	end
	if CLIENT then
	timer.Simple(0, function()
		net.Start('SpawnEditingRefresh')
		net.SendToServer()
	end)
	end
end

--
-- SecondaryAttack - Nothing. See Tick for zooming.
--
function TOOL:RightClick()
	if ( !IsFirstTimePredicted() ) then return end
	if SERVER then self:SAziiip(self:GetOwner():GetPos()) end
	
	if CLIENT then
	timer.Simple(0, function()
		net.Start('SpawnEditingRefresh')
		net.SendToServer()
	end)
	end
end

//-------------------------------------------------
if !SpawnsPoint then
	SpawnsPoint = {}
end

hook.Add("LoadSpawnsData","poqwien1", function()
	print("Loading SpawnPoints")
	local mapName = game.GetMap()
	local jason = file.Read("swrp/" .. mapName .. "/spawn.txt", "DATA")
	if jason then
		local tbl = util.JSONToTable(jason)
		SpawnsPoint = tbl
		PrintTable(SpawnsPoint)
	end
end)

hook.Add("SaveSpawnsData","poqwien", function(createFile)

	// ensure the folders are there
	if !file.Exists("swrp/","DATA") then
		file.CreateDir("swrp")
	end

	local mapName = game.GetMap()
	if !file.Exists("swrp/" .. mapName .. "/","DATA") then
		file.CreateDir("swrp/" .. mapName)
	end
	
	// JSON!
	if !file.Exists("swrp/" .. mapName .. "/" .. "spawn.txt","DATA") then
		local jason = util.TableToJSON(SpawnsPoint)
		file.Write("swrp/" .. mapName .. "/spawn.txt", jason)
	end
end)

hook.Add("AddSpawnItem","qaweasdfaf", function(pos, bat)
	if (SpawnsPoint[bat] == nil) then SpawnsPoint[bat] = {} end
	table.insert(SpawnsPoint[bat], pos)
end)

function AddSpawnItem(pos, bat)
	hook.Call("AddSpawnItem", nil, pos, bat)
	hook.Call("SaveSpawnsData",nil)
end

function RemoveSpawnItem(bat, key)
	if !SpawnsPoint[bat][key] then
		ply:ChatPrint("Invalid key, position inexists")
		return
	end

	local data = SpawnsPoint[bat][key]
	table.remove(SpawnsPoint[bat], key)
	
	hook.Call("SaveSpawnsData", nil)
end
//----------------
//----------------
//----------------
//----------------
--
-- Deploy - Allow lastinv
--

function TOOL.BuildCPanel( CPanel )
		CPanel:AddControl( "Header", { Description = "Выбор батальона" } )
		AppList = vgui.Create( "DComboBox", CPanel )
		AppList:Dock(TOP)
		AppList:SizeToContents()
		for k,v in pairs(SWRP.Batalions.SpecialsBataions) do
			AppList:AddChoice( k, k )
		end
		function AppList:OnSelect( index, text, data )
			netstream.Start("ChosenSpawnBalation", data)
		end
end
if ( SERVER ) then	return end -- Only clientside lua after this line

function TOOL:DrawHUD()
	local tablr = LocalPlayer().SpawnList or {}
	/*draw.SimpleText( #tablr..'/'..game.MaxPlayers(), "CloseCaption_Normal", ScrW()-5, 5, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
	if #tablr >= game.MaxPlayers() then
	draw.SimpleText( 'Работают кастомные спавны!', "CloseCaption_Normal", ScrW()-5, 25, Color(120,255,120), TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)
	end*/
	for i,v in pairs(tablr) do
	for k,d in pairs(v) do
		local data = d:ToScreen()
		local a = 0
		local color = Color(0,255,0)
		local dist = self.Owner:GetPos():Distance( d )
		if dist > 750 then
			a = 30
		elseif dist < 200 then
			a = 255
		else
			a = InverseLerp( dist, 750, 200 )*255
		end
		if dist < 150 then
			color = Color(255,0,0)
		end
		
		color.a = a
		
		draw.SimpleText( math.Round(dist, 2), "GModToolScreen", data.x, data.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText( i, "GModToolScreen", data.x, data.y-40, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	end
	//return true
end


local matScreen = Material( "models/weapons/v_toolgun/screen" )
local txBackground = surface.GetTextureID( "models/weapons/v_toolgun/screen_bg" )

-- GetRenderTarget returns the texture if it exists, or creates it if it doesn't
local RTTexture = GetRenderTarget( "GModToolgunScreen", 256, 256 )

surface.CreateFont( "GModToolScreen", {
	font	= "Helvetica",
	size	= 20,
	weight	= 100
} )
