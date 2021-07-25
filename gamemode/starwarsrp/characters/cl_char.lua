
GM.Char = {}
SWRP.CharList = SWRP.CharList or {}
MAX_CHAR = 5

netstreamSWRP.Hook("Char.SelectChar", function(tabl)
	GAMEMODE.Char = tabl
	if IsValid(SelectRole) then
		SelectRole:Remove() 
	end
	-- print(GAMEMODE.Char, "222")
	-- PrintTable(GAMEMODE.Char)
end)

local function CharFrame(tabl, id)
	-- print(tabl)
	-- if istable(tabl) then PrintTable(tabl) end
	
	if IsValid(SelectRole) then
		SelectRole:Remove()  
	end
	
	SelectRole = vgui.Create("DFrame")
	SelectRole:SetSize(250,350) 
	SelectRole:Center()
	SelectRole:MakePopup() 
	local is_startinfo = 30 
	if SWRP.Config.StartMenu then
	local textpanel = vgui.Create("RichText", SelectRole)
		textpanel:SetPos(5,30)
		textpanel:SetSize(SelectRole:GetWide()-10,65)  
		textpanel:SetVerticalScrollbarEnabled( false ) 
		textpanel:InsertColorChange(255, 255, 255, 255 ) 
		textpanel:AppendText(SWRP.Config.StartMenu.Text)  
		textpanel:SizeToContents() 
	local discordbutton = vgui.Create("DButton", SelectRole) 
		discordbutton:SetPos(5,30+textpanel:GetTall()+5)
		discordbutton:SetSize(SelectRole:GetWide()-10,20)
		discordbutton:SetText("Наш Discord!") 
		discordbutton.DoClick = function(s,w,h)
			gui.OpenURL(SWRP.Config.StartMenu.DiscordButton)
		end
		is_startinfo = 40+textpanel:GetTall()+discordbutton:GetTall()
	end
	local model 

	model = vgui.Create("DModelPanel", SelectRole)
	model:SetSize(SelectRole:GetWide()-10,SelectRole:GetTall()-30-is_startinfo)
	model:SetPos(5,is_startinfo)
	model:SetVisible(false)
	if tabl and tabl[id] then
		model:SetVisible(true)
		model:SetModel(tabl[id].model)
		model._oldpaint = model.Paint
		model.LayoutEntity = function( ent ) end
		model.Paint = function(s,w,h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
			s._oldpaint(s,w,h)
		end



		//model:SetCamPos( Vector(25, 0, 65))
		//model:SetLookAt(Vector(0, 0, 65))
		//model:SetFOV(100)
		model.Entity:SetBodyGroups(tabl[id].bodygroups)
		model.Entity:SetSkin(tabl[id].skin) 
		local anims = {
			'pose_ducking_01',
			//'pose_ducking_01',
			'pose_standing_01',
			'pose_standing_02',
		}
		local iSeq = model.Entity:LookupSequence( table.Random(anims) )
		if ( iSeq > 0 ) then model.Entity:ResetSequence( iSeq ) end

		local PrevMins, PrevMaxs = model.Entity:GetRenderBounds()
		if PrevMins:IsEqualTol(PrevMaxs, 100 ) then
			model:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.25) + Vector(0, 0, 15))
			model:SetLookAt((PrevMaxs + PrevMins) / 2)
		end
	else
		local textpanel = vgui.Create("RichText", SelectRole)
			textpanel:SetPos(5,is_startinfo+5)
			textpanel:SetSize(SelectRole:GetWide()-10,120)  
			textpanel:SetVerticalScrollbarEnabled( false ) 
			textpanel:InsertColorChange(255, 255, 255, 255 ) 
			textpanel:AppendText([[Поле выбора профессии станет доступна с ранга CPL. Там ты сможешь более подробно ознакомиться со всеми доступными должностями. :з

А сейчас выбери себе позывной, так как смены псевдонима, как и номера, здесь нет. Удачной службы на Великую Армию Республики!]])  
			textpanel:SizeToContents() 
			
		local poziv = vgui.Create("DTextEntry", SelectRole) 
			poziv:SetPos(5,is_startinfo+5+120)
			poziv:SetSize(SelectRole:GetWide()-10,20)
			poziv:SetPlaceholderText("Позывной - макс. 8 символов") 
			/*
			local class = vgui.Create("DComboBox", SelectRole) 
			class:SetPos(5,is_startinfo+30)
			class:SetSize(SelectRole:GetWide()-10,20)
			class:SetValue( "Выбор класс для прокачки" ) 
			for i,v in pairs(GAMEMODE.RolesWithCreate) do
				class:AddChoice( SWRP.Roles:DRoleInfo(v).Name, v)
			end
			*/

		local startbutton = vgui.Create("DButton", SelectRole)
			startbutton:SetPos(25,SelectRole:GetTall()-25)
			startbutton:SetSize(SelectRole:GetWide()-50,20)
			startbutton:SetText("Создать персонажа")
			startbutton.DoClick = function(s,w,h)
				//local prim, sec = class:GetSelected()
				local data = {}
				data.poziv = poziv:GetText()
				//data.class = sec
				netstreamSWRP.Start("Char.Create", data)
			end
	end
	
	if tabl then
		
		local startbutton = vgui.Create("DButton", SelectRole)
			startbutton:SetPos(5,is_startinfo+model:GetTall()+5)
			startbutton:SetSize(20,20)
			startbutton:SetText("<")
			if (id-1 < 1) then
				startbutton:SetDisabled(true)
				startbutton:SetTooltip("Выбор множества персонажей недоступен.")
			end
			startbutton.DoClick = function(s,w,h)
				CharFrame(tabl, id-1)
			end
		local startbutton = vgui.Create("DButton", SelectRole)
			startbutton:SetPos(SelectRole:GetWide()-25,is_startinfo+model:GetTall()+5)
			startbutton:SetSize(20,20)
			startbutton:SetText(">")
			if (id+1 > MAX_CHAR) then
				startbutton:SetDisabled(true)
				startbutton:SetTooltip("Выбор множества персонажей недоступен.")
			end
			startbutton.DoClick = function(s,w,h)
				CharFrame(tabl, id+1)
			end
		if tabl[id] then
			local startbutton = vgui.Create("DButton", SelectRole)
			startbutton:SetPos(25,is_startinfo+model:GetTall()+5)
			startbutton:SetSize(SelectRole:GetWide()-50-20,20)
			startbutton:SetText(GAMEMODE:CharName(_, true, tabl[id]))
			startbutton.DoClick = function(s,w,h)
				netstreamSWRP.Request("Char.Select", tabl[id].id)
			end
			local removebutton = vgui.Create("DButton", SelectRole)
			removebutton:SetPos(25+startbutton:GetWide(),is_startinfo+model:GetTall()+5)
			removebutton:SetSize(20,20)
			removebutton:SetText("X")
			removebutton.DoClick = function(s,w,h)
				local q = util.CreateDialog("Вы хотите удалить персонажа?",
				"Удаленного персонажа невозможно вернуть, вы уверены что хотите удалить "..GAMEMODE:CharName(_, true, tabl[id]).."?",
				function() netstreamSWRP.Request("Char.Remove", tabl[id].id); end,
				"Yes",
				function() end,
				"No");
				
			end
		end
	end
end

netstreamSWRP.Hook("Char.Load", function(tabl) 
	CharFrame(tabl, 1)
	SWRP.CharList = tabl
end)

SWRP.CharFrame = CharFrame