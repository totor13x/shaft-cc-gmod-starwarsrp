if !file.Exists( "batalions", "DATA" ) then
	file.CreateDir("batalions")
end

if (!file.Exists("batalions/doors.txt", "DATA")) then
	file.Write( "batalions/doors.txt", "[]" ) //Чекаем есть ли файл, если нет, то создаем
end

TOOL.Category = "Constraints"
TOOL.Name = "DoorSetup"

TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "nocollide" ] = "0"
if CLIENT then
TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "left_1", stage = 1, op = 2 },
	{ name = "right", stage = 0 },
	{ name = "right_1", stage = 1, op = 1 },
	{ name = "right_2", stage = 2, op = 1 },
	{ name = "reload" }
}
language.Add( "tool.door_setup.name", "Создатель ограничений" )
language.Add( "tool.door_setup.desc", "Позволяет наложить ограничения на дверь, кнопку или что-то еще" )
language.Add( "tool.door_setup.1", "See information in the context menu" )
language.Add( "tool.door_setup.left", "Установить ограничитель (необходимо сначала задать параметры)" )
language.Add( "tool.door_setup.right", "Удалить ограничитель" )
language.Add( "tool.door_setup.right_use", "Select previous mode" )
language.Add( "tool.door_setup.reload", "Пока ничего" )
language.Add( "tool.door_setup.reload_use", "Select your view model" )
end
if (SERVER) then
	
	netstreamSWRP.Hook("ChosenDoorBatalion", function(ply, data)
		ply.chosenBatalion = data
	end)
	
	netstreamSWRP.Hook("ChosenDoorRank", function(ply, data)
		ply.chosenRank = data
	end)
	
	netstreamSWRP.Hook("ChosenDoorRole", function(ply, first, data)
		ply.chosenFirst = first
		ply.chosenRoles = data
	end)
end

function TOOL:LeftClick( trace )
	if (SERVER) then
		//print(self:GetOwner().chosenBatalion)
		//print(self:GetOwner().chosenRank)
		//PrintTable(SWRP.Doors.List)
		SWRP.Doors = SWRP.Doors or {}
		SWRP.Doors.List = SWRP.Doors.List or {}
		SWRP.Doors.List[game.GetMap()] = SWRP.Doors.List[game.GetMap()] or {}
		if SWRP.Doors.List[game.GetMap()][trace.Entity:MapCreationID()] == nil then
			SWRP.Doors.List[game.GetMap()][trace.Entity:MapCreationID()] = {}
		end
		
		SWRP.Doors.List[game.GetMap()][trace.Entity:MapCreationID()]["batalion"] = self:GetOwner().chosenBatalion
		SWRP.Doors.List[game.GetMap()][trace.Entity:MapCreationID()]["roles"] = self:GetOwner().chosenRoles
		SWRP.Doors.List[game.GetMap()][trace.Entity:MapCreationID()]["firstroles"] = self:GetOwner().chosenFirst
		SWRP.Doors.List[game.GetMap()][trace.Entity:MapCreationID()]["rank"] = self:GetOwner().chosenRank
		
		SWRP.Doors.Save()
	end
	return true

end

function TOOL:RightClick( trace )
	if (SERVER) then
		//print(self:GetOwner().chosenBatalion)
		if SWRP.Doors.List[game.GetMap()][trace.Entity:MapCreationID()] != nil then
			
			SWRP.Doors.List[game.GetMap()][trace.Entity:MapCreationID()] = nil
			SWRP.Doors.Save()
		end
	end
	return true
end
if CLIENT then
	function TOOL:DrawHUD()
		LocalPlayer().infoDoor = nil
		local ent = self:GetOwner():GetEyeTrace().Entity
		if IsValid(ent) and ent:GetNWInt("MapEntityID") != 0 then
			if (SWRP.Doors.TempData and SWRP.Doors.TempData[ent:GetNWInt("MapEntityID")]) then
				//print( ent:GetNWInt("MapEntityID") )
				LocalPlayer().infoDoor = SWRP.Doors.TempData[ent:GetNWInt("MapEntityID")]
				//PrintTable( SWRP.Doors.TempData[ent:GetNWInt("MapEntityID")] )
			end
		end
		/*
		for i,v in pairs(SWRP.Doors.TempData) do
			print(v)
		end
		*/
	end
	local roleTab 
	function TOOL.BuildCPanel( CPanel )
		CPanel:AddControl( "Header", { Description = "Назначение батальонов дверям" } )
		AppList = vgui.Create( "DComboBox", CPanel )
		AppList:Dock(TOP)
		AppList:SizeToContents()
		AppList:AddChoice("Без ограничений", nil, true)
		for k,v in pairs(SWRP.Batalions.SpecialsBataions) do
			AppList:AddChoice( k, k )
		end
		function AppList:OnSelect( index, text, data )
			netstreamSWRP.Start("ChosenDoorBatalion", data)
			-- net.Start("ChosenDoorBatalion")
				-- net.WriteString(data)
			-- net.SendToServer()
		end
		//----Выбор роли
		CPanel:AddControl( "Header", { Description = "Назначение роли дверям" } )
		RoleList = vgui.Create( "DComboBox", CPanel )
		RoleList:Dock(TOP)
		RoleList:SizeToContents()
		RoleList:AddChoice("Без ограничений", nil, true)
		for k,v in pairs(GAMEMODE.Roles) do
			if k>=5 then 
				RoleList:AddChoice(v.Name, k)
			end
		end
	
		function RoleList:OnSelect( index, text, data )
			local roleTab = nil
			if data then
				roleTab = {}
				local tab = SWRP.Roles:FindRelativeClassesDeep(data)
				roleTab[data] = true
				for k,v in pairs(tab) do
					roleTab[v.id] = true
				end
				//PrintTable(roleTab)
			end
			netstreamSWRP.Start("ChosenDoorRole", data, roleTab)
			-- net.Start("ChosenDoorRole")
				-- net.WriteString(data)
				-- net.WriteTable(roleTab)
			-- net.SendToServer()
		end
		
		//----Выбор ранга
		CPanel:AddControl( "Header", { Description = "Назначение рангов дверям" } )
		RankList = vgui.Create( "DComboBox", CPanel )
		RankList:Dock(TOP)
		RankList:SizeToContents()
		RankList:AddChoice("Без ограничений", nil, true)
		for k,v in pairs(SWRP.Ranks.List) do
			RankList:AddChoice( v.Name, k )
		end
		function RankList:OnSelect( index, text, data )
			netstreamSWRP.Start("ChosenDoorRank", data)
			-- net.Start("ChosenDoorRank")
				-- net.WriteString(data)
			-- net.SendToServer()
		end
		
	end
end