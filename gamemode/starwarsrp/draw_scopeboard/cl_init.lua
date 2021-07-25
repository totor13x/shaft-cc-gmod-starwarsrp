hook.Add("TTS::Load","Load",function(panel1)
	scoreboard = panel1
	local tables_lerp = {}
	local function sidebarbuttons(data)
		data.name = data.name or ""
		local panel = scoreboard:AddPanel({
			-- FakeActivated = true,
			Text = data.name,
		})
		panel.Clicked = false
		panel.Think = function(s)
			if s.Clicked then
				s.onclick = true
				s.enabled = true
				s.LerpedColorAlphaBorders = 255 
				s.LerpedColorAlphaBlock = 255 
			else 
				s.onclick = false
				s.enabled = false
			end
		end
		panel.DoClick = function(s)
			for i,v in pairs(tables_lerp) do
				v.Clicked = false
			end
			s.Clicked = true
		end
		table.insert(tables_lerp, panel)
		return panel
	end
	
	--Text for admins
	
	local OnlineAdmins = {}
	for _, ply in pairs(player.GetAll())do
		if ply:GetUserGroup() ~= "user" and ply:GetUserGroup() ~= "vip" and ply:GetUserGroup() ~= "vip+" and ply:GetUserGroup() ~= "vip++" then
			table.insert(OnlineAdmins, ply)
		end
	end
	
	if #OnlineAdmins > 0 then
		local _ = scoreboard:AddPanel({
			vgui = "DPanel",
			tall = 30,
			type = "DownSidebar",
		})
		_.Paint = function(s,w,h)	
			draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35,200) )
			draw.SimpleText("Администрация онлайн", "S_Light_20", 10, 14, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)	
		end
		
		local _ = scoreboard:AddPanel({
			vgui = "DScrollPanel",
			tall = 250,
			type = "DownSidebar",
		})
		_.Paint = function(s,w,h) end
		for i, ply in pairs(OnlineAdmins)do
			local button = scoreboard:AddPanel({
				type = "ply",
				tall = 40,
				ply = ply,
				Text = "",
				parent = _,
			})
			local a_ = button.Paint
			button.Paint = function(s,w,h)
				a_(s,w,h)
				local GroupData = serverguard.ranks:GetRank(serverguard.player:GetRank(s.Player))
				draw.SimpleText((s.Player:Nick() or "NO DATA"), "S_Light_20", 50, 10, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(GroupData.name, "S_Light_20", 50, 26, GroupData.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			
			local Davaus = vgui.Create( "AvatarImage", button)
			Davaus:SetPos( 0, 0 )
			Davaus:SetSize( 40, 40 )
			Davaus:SetPlayer( ply, 38 )	
			
			button:Dock( TOP )
		end
	end
	
	-- End text for admin
	
	-- Text for change TEAM
	local teambutton = scoreboard:AddPanel({
		FakeActivated = true,
		type = "DownSidebar",
	})
	
	teambutton.DoClick = function(s2)
		if LocalPlayer():Team() == 2 then
			RunConsoleCommand("mu_jointeam", 1)
		else
			RunConsoleCommand("mu_jointeam", 2)
		end
	end
	teambutton.Think = function(s2)
		if LocalPlayer():Team() == 2 then
			s2.Text = "В наблюдатели"
		else
			s2.Text = "В игроки"
		end
		s2.LerpedColor = team.GetColor(LocalPlayer():Team())
	end
	
	-- End text for change TEAM
	
	local function adduserteam(teamn) 
	for i, ply in pairs(team.GetPlayers(teamn))do
	//for i=0, 50 do
		local button = scoreboard:AddPanel({
			type = "ply",
			tall = 40,
			ply = ply,
			Text = "",
			parent = scoreboard.ContentPanel,
		})
		button.Paint = function(s,w,h)
			if teamn == TEAM_PLAYERS then
				draw.SimpleText(s.Player:CharName(), "S_Light_20", 50, 10, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(s.Player:GetNWString("BatName"), "S_Light_20", 50, 26, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			else
				local GroupData = serverguard.ranks:GetRank(serverguard.player:GetRank(s.Player))
				draw.SimpleText((s.Player:Nick() or "NO DATA"), "S_Light_20", 50, 10, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(GroupData.name, "S_Light_20", 50, 26, GroupData.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end
		
		local Davaus = vgui.Create( "AvatarImage", button)
		Davaus:SetPos( 0, 0 )
		Davaus:SetSize( 40, 40 )
		Davaus:SetPlayer( ply, 38 )	
		
		
		local MuteButton = scoreboard:AddPanel({
			Text = "",
			parent = button,
			FakeActivated = true,
			type = "",
		})
		
		local aw = (scoreboard.contentwrap and 10 or 24)
		MuteButton:SetPos( button:GetWide()-10-aw, 0 )
		MuteButton:SetSize(10,38 + 2)
		
		MuteButton.DoClick = function()
			if not IsValid(ply) then return end
			local t = GMute() 
			if not ply.SetMute then
				t[ply:SteamID()] = true
				TTS:AddNote( "Вы персонально отключили текстовый чат для "..ply:Nick(), NOTIFY_HINT, 3)
			else
				t[ply:SteamID()] = nil
				TTS:AddNote( "Вы персонально включили текстовый чат для "..ply:Nick(), NOTIFY_HINT, 3)
			end
			SMute(t)
			ply.SetMute = !ply.SetMute
		end
		
		MuteButton.Think = function(s)
			if not IsValid(ply) then
				s:Remove()
			else
				if ply.SetMute then
					s.LerpedColor = Color(232,12,41)
				else
					s.LerpedColor = Color(24,123,41)
				end
			end
		end
		
		
		local GagButton = scoreboard:AddPanel({
			Text = "",
			parent = button,
			FakeActivated = true,
			type = "",
		})
		
		local aw = (scoreboard.contentwrap and 10 or 24)
		GagButton:SetPos( button:GetWide()-aw, 0 )
		GagButton:SetSize(10,38 + 2)
		
		GagButton.DoClick = function()
			if not IsValid(ply) then return end
			local t = GGag() 
			if not ply:IsMuted() then
				t[ply:SteamID()] = true
				TTS:AddNote( "Вы персонально отключили голосовой чат для "..ply:Nick(), NOTIFY_HINT, 3)
			else
				t[ply:SteamID()] = nil
				TTS:AddNote( "Вы персонально включили голосовой чат для "..ply:Nick(), NOTIFY_HINT, 3)
			end
			SGag(t)
			ply:SetMuted(!ply:IsMuted())
		end
		
		GagButton.Think = function(s)
			if not IsValid(ply) then
				s:Remove()
			else
				if ply:IsMuted() then
					s.LerpedColor = Color(232,12,41)
				else
					s.LerpedColor = Color(24,123,41)
				end
			end
		end
		
		
		button:Dock( TOP )
	end
	end
	
--[[ CONTENT BLOCK - PLAYERS ]]--
	local tcolor = team.GetColor(TEAM_PLAYERS)
	local tname = team.GetName(TEAM_PLAYERS)
	local _ = scoreboard:AddPanel({
		vgui = "DPanel",
		tall = 30,
		parent = scoreboard.ContentPanel,
			type = "",
	})
	_.Paint = function(s,w,h)	
		draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35,200) )
		draw.SimpleText(tname, "S_Bold_20", w/2, h/2, tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
	end
	_:Dock( TOP )
	
	adduserteam(TEAM_PLAYERS) 
	
	local tcolor = team.GetColor(TEAM_SPECTATOR)
	local tname = team.GetName(TEAM_SPECTATOR)
	local _ = scoreboard:AddPanel({
		vgui = "DPanel",
		tall = 30,
		parent = scoreboard.ContentPanel,
			type = "",
	})
	_.Paint = function(s,w,h)	
		draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 35, 35,200) )
		draw.SimpleText(tname, "S_Bold_20", w/2, h/2, tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
	end
	_:Dock( TOP )
	
	adduserteam(TEAM_SPECTATOR) 

--[[ END CONTENT BLOCK - PLAYERS ]] --

	local aa = sidebarbuttons({name = "Окно выбора персонажа"})
	local aa_ = aa.DoClick
	aa.DoClick = function(s,w,h)
		aa_(s,w,h)
		SWRP.CharFrame(SWRP.CharList, 1)
	end
	
	local aa = sidebarbuttons({name = "Мои действия"})
	local aa_ = aa.DoClick
	aa.DoClick = function(s,w,h)
		aa_(s,w,h)
		
		scoreboard.ContentPanel:Clear()
		scoreboard.ContentPanel.Paint = function( s, w, h ) end
		
	if LocalPlayer():GetUserGroup() ~= "user" then
		local DPanel = vgui.Create( "DPanel", scoreboard.ContentPanel )
		DPanel:DockMargin(5,5,0,0)
		DPanel.Paint = function() end
		DPanel:Dock(TOP)
		local LabelEntry = vgui.Create( "DLabel", DPanel )
		LabelEntry:SetText( "" )
		LabelEntry:SetFont( "S_Light_20" )
		LabelEntry:SizeToContents( )
		//LabelEntry:DockMargin(5,5,600,0)	
		LabelEntry:Dock(LEFT)
		LabelEntry.Think = function(s)
			s:SetText("Ваша группа: ")
			s:SizeToContents( )
			DPanel:SizeToContents()
		end	
		local LabelEntry = vgui.Create( "DLabel", DPanel )
		LabelEntry:SetText( "" )
		LabelEntry:SetFont( "S_Light_20" )
		LabelEntry:SizeToContents( )
		-- LabelEntry:DockMargin(5,5,600,0)	
		LabelEntry:Dock(LEFT)
		LabelEntry.Think = function(s)
			local GroupData = serverguard.ranks:GetRank(serverguard.player:GetRank(LocalPlayer()))
			s:SetText(GroupData.name)
			s:SetColor(GroupData.color)
			s:SizeToContents( )
			DPanel:SizeToContents()
		end		
		local LabelEntry = vgui.Create( "DLabel", DPanel )
		LabelEntry:SetText( "" )
		LabelEntry:SetFont( "S_Light_20" )
		LabelEntry:SizeToContents( )
		-- LabelEntry:DockMargin(5,5,600,0)	
		LabelEntry:Dock(LEFT)
		LabelEntry.Think = function(s)
			s:SetText(", будет действовать "..util.sec2Min(LocalPlayer():GetNWInt("groupStart")+LocalPlayer():GetNWInt("groupLength")-os.time(), true))
			s:SizeToContents( )
			DPanel:SizeToContents()
		end			
		local LabelEntry = vgui.Create( "DLabel", DPanel )
		LabelEntry:SetText( "." )
		LabelEntry:SetFont( "S_Light_20" )
		LabelEntry:SizeToContents( )
		-- LabelEntry:DockMargin(5,5,600,0)	
		LabelEntry:Dock(LEFT)
		LabelEntry.Think = function(s)
			s:SetText(".")
			s:SizeToContents( )
			DPanel:SizeToContents()
		end			
		
	end
	if LocalPlayer():GetNWBool("serverguard_muted") then	
		local LabelEntry = vgui.Create( "DLabel", scoreboard.ContentPanel )
		LabelEntry:SetText( "" )
		LabelEntry:SetFont( "S_Light_20" )
		LabelEntry:DockMargin(5,0,0,0)	
		LabelEntry:Dock(TOP)
		LabelEntry.Think = function(s)
			local text = "Выдано навсегда."
			if LocalPlayer():GetNWInt("MuGamuteEnd") ~= 0 then
				text = util.sec2Min(LocalPlayer():GetNWInt("MuGamuteEnd")-os.time(), true, true).."."
			end
			s:SetText("У Вас блокировка текстового чата. "..text)
			s:SizeToContents( )
		end	
	end
	if LocalPlayer():GetNWBool("serverguard_gagged") then	
		local LabelEntry = vgui.Create( "DLabel", scoreboard.ContentPanel )
		LabelEntry:SetText( "" )
		LabelEntry:SetFont( "S_Light_20" )
		LabelEntry:DockMargin(5,0,0,0)	
		LabelEntry:Dock(TOP)
		LabelEntry.Think = function(s)
			local text = "Выдано навсегда."
			if LocalPlayer():GetNWInt("MuGagagEnd") ~= 0 then
				text = util.sec2Min(LocalPlayer():GetNWInt("MuGagagEnd")-os.time(), true, true).."."
			end
			s:SetText("У Вас блокировка голосового чата. "..text)
			s:SizeToContents( )
		end	
	end
		
		local DermaCheckbox = vgui.Create( "DCheckBoxLabel", scoreboard.ContentPanel)
		DermaCheckbox:SetText( "Активация курсора в ТАБ'е без нажатия ПКМ" )		
		DermaCheckbox:SetFont("S_Light_20")						
		DermaCheckbox.CommandEd = "scoreboard_rightclick"	
		DermaCheckbox:SetConVar( DermaCheckbox.CommandEd )	
		DermaCheckbox:SetValue( math.Clamp(GetConVarNumber( DermaCheckbox.CommandEd), 0, 1) )
		DermaCheckbox:SizeToContents()		
		DermaCheckbox:DockMargin(5,15,0,0)		
		DermaCheckbox:Dock(TOP)
	
	local LabelEntry = vgui.Create( "DLabel", scoreboard.ContentPanel )
	LabelEntry:SetText( "Установка тегов для игрового чата" )
	LabelEntry:SetFont( "S_Light_20" )
	LabelEntry:SizeToContents( )
	LabelEntry:DockMargin(5,15,600,0)	
	LabelEntry:Dock(TOP)
	local tabl = {}
	for i=1, TTS.MyTags.max do
		local DComboBox = vgui.Create( "DComboBox", scoreboard.ContentPanel )
		DComboBox.id = i
		DComboBox:SetValue( "" )
		DComboBox:AddChoice( "" )
		for id,v in pairs(TTS.MyTags.tags) do
			local obshayadata = TTS.Tags[id]
			if !obshayadata then continue end 
			local name = obshayadata['tags-beauty-text'] 
			if string.sub( id, 1, 8 ) == "private." then name = "(private) "..name end 
			
			DComboBox:AddChoice( name, id, v.Enabled == i and true or false )
		end
		DComboBox:DockMargin(5,5,600,0)	
		DComboBox:Dock(TOP)
		table.insert(tabl, DComboBox)
	end
	local BAuttonchange = vgui.Create( "DButton", scoreboard.ContentPanel)
	BAuttonchange:SetText("Change")
	BAuttonchange.DoClick = function(s2)
		local sen = {}
		for i,v in pairs(tabl) do
			local a,b = v:GetSelected()
			if !b then continue end
			sen[b] = v.id
		end 
		netstream.Start( "TTS::SetTags", sen )
	end
	BAuttonchange:DockMargin(5,5,600,0)	
	BAuttonchange:Dock(TOP)
		
		
	local LabelEntry = vgui.Create( "DLabel", scoreboard.ContentPanel )
	LabelEntry:SetText( "Установка тега для глобального чата" )
	LabelEntry:SetFont( "S_Light_20" )
	LabelEntry:SizeToContents( )
	LabelEntry:DockMargin(5,15,600,0)	
	LabelEntry:Dock(TOP)
	
	local DComboBoxForGlob = vgui.Create( "DComboBox", scoreboard.ContentPanel )
	DComboBoxForGlob.id = i
	DComboBoxForGlob:SetValue( "%какой-то тег%" )
	for id,v in pairs(TTS.MyTags.tags) do
		local obshayadata = TTS.Tags[id]
		if !obshayadata then continue end 
		local name = obshayadata['tags-beauty-text'] 
		if string.sub( id, 1, 8 ) == "private." then name = "(private) "..name end 
		
		DComboBoxForGlob:AddChoice( name, id )
	end
	DComboBoxForGlob:DockMargin(5,5,600,0)	
	DComboBoxForGlob:Dock(TOP)
		
	local BAuttonchange = vgui.Create( "DButton", scoreboard.ContentPanel)
	BAuttonchange:SetText("Change")
	BAuttonchange.DoClick = function(s2)
		local _,id = DComboBoxForGlob:GetSelected()
		if !id then return end
		netstream.Start("TTS::SetGlobalTag", id)
	end
		BAuttonchange:DockMargin(5,5,600,0)	
		BAuttonchange:Dock(TOP)
	
	local BAuttonchange = vgui.Create( "DButton", scoreboard.ContentPanel)
	BAuttonchange:SetText("Remove")
	BAuttonchange.DoClick = function(s2)
		netstream.Start("TTS::SetGlobalTag", "no")
	end
	BAuttonchange:DockMargin(5,5,600,0)	
	BAuttonchange:Dock(TOP)
	
	end
	
end)