/*
hook.Add("serverguard.RanksLoadedShared", "12312378sd", function()
	netstreamSWRP.Start("WantToUpdateAbilitiesCL")
end)*/
hook.Add("Tick", "Draw::Context", function()
	if !gui.IsGameUIVisible() and !LocalPlayer():IsTyping() and !IsValid(vgui.GetKeyboardFocus()) and input.IsKeyDown(KEY_C) then
		if !IsValid(m_panelContext) then 
			gui.EnableScreenClicker(true)
			input.SetCursorPos(ScrW()/2, ScrH()/2)
			m_panelContext = DermaMenu()
			m_panelContext:SetMaxHeight(200)
			m_panelContext:SetDeleteSelf(false)
			if (tonumber(GAMEMODE.Char.rank) == CC) or (tonumber(GAMEMODE.Char.rank) == COL) then
				m_panelContext:AddOption("Ваш батальон", function() RunConsoleCommand("cmd_pnlBatalion") end)
			end
			if tonumber(GAMEMODE.Char.rank) >= CPL && GAMEMODE.Char.role_selected == "0" then
				m_panelContext:AddOption("Вам доступен выбор специализации", function() RunConsoleCommand("cmd_pnlSelectFrame") end)
			end
			
			if SWRP.TransitionRequests[GAMEMODE.Char.id] then
				local f = m_panelContext:AddSubMenu("Запросить переход в другой батальон")
				for k,v in pairs(SWRP.Batalions.SpecialsBataions) do
					f:AddOption(k, function() SWRP.AddTranslationRequest(GAMEMODE.Char.id,LocalPlayer():SteamID(), k) end)
				end
			end
			
			if SWRP.Ranks:DGetPriv(GAMEMODE.Char.rank, 'Radio') then
				m_panelContext:AddOption("Рация ", function()
					if IsValid(m_pnlRadio) then m_pnlRadio:Remove() end 
					m_pnlRadio = vgui.Create("MBChatRadioMenu")  
					m_pnlRadio:SetSize( 226, 30+25+25 )
					m_pnlRadio:SetPos( ScrW() -m_pnlRadio:GetWide() -5, (ScrH() /2) -(m_pnlRadio:GetTall() /2) )
					m_pnlRadio:Center()
					m_pnlRadio:MakePopup()
				end)
			end
			m_panelContext:AddSpacer()
			local a = m_panelContext:AddSubMenu("Действия")
			if LocalPlayer().GetActiveWeapon and LocalPlayer():GetActiveWeapon()  and LocalPlayer():GetActiveWeapon().CycleSafety then
				a:AddOption("Убрать оружие", function() RunConsoleCommand("cycle_wep") end)
			end
			print(SWRP.Ranks:DGetPrivPly(LocalPlayer(), "JUST_I_WANT_TO_FLY"))
    		if SWRP.Ranks:DGetPrivPly(LocalPlayer(), "JUST_I_WANT_TO_FLY") then
				if LocalPlayer():GetNWBool("JetEnabled") then
					a:AddOption("Отключить джетпак", function() RunConsoleCommand("jetpack_enable") end)
				else
					a:AddOption("Включить джетпак", function() RunConsoleCommand("jetpack_enable") end)
				end
			end
			local a = m_panelContext:AddSubMenu("Таунты")
			a:AddOption("Salute", function() RunConsoleCommand("act", "salute") end)
			a:AddOption("Dance", function() RunConsoleCommand("act", "dance") end)
			
			if IsValid(GAMEMODE.LastLooked) && GAMEMODE.LastLooked:IsPlayer() && GAMEMODE.LookedFade + 2 > CurTime() then
				m_panelContext:AddOption("Повысить в звании "..GAMEMODE.LastLooked:CharName(), function() netstreamSWRP.Start("Batalion::RankUP", GAMEMODE.LastLooked:CharID()) end)
				m_panelContext:AddOption("Отказаться от обучения "..GAMEMODE.LastLooked:CharName(), function() netstreamSWRP.Start("SWRP::Cadet.cancerTraining", GAMEMODE.LastLooked) end)
				m_panelContext:AddOption("Выдача формы кадету "..GAMEMODE.LastLooked:CharName(), function() netstreamSWRP.Start("SWRP::cmd_allowCadet", GAMEMODE.LastLooked) end)
				if (GAMEMODE.Char.batalion == "ARC") then
				//ply:GetNWString("Char.Rank"), ply:GetNWString("Char.Batalion")
					SWRP.Roles:FindRelativeClassesDeepArc(GAMEMODE.LastLooked:GetNWString("Char.Role") , GAMEMODE.LastLooked:GetNWString("Char.Rank"), GAMEMODE.Char.role, function(bool)
						local a = m_panelContext:AddSubMenu("Обучение "..GAMEMODE.LastLooked:CharName())
							
						local lis = SWRP.Roles:DListCanChangeRole(GAMEMODE.LastLooked) or {}
						for i,v in pairs(lis) do
							a:AddOption(v.Name, function()
								netstreamSWRP.Start("Roles::RoleUP", {sid = GAMEMODE.LastLooked:GetNWString("CharId"), role = v.id})
							end)
						end
					end)
					//m_panelContext:AddOption("Обучение "..GAMEMODE.LastLooked:CharName(), function() netstreamSWRP.Start("SWRP::Cadet.cancerTraining", GAMEMODE.LastLooked) end)
				end
			end
			/*
			local a = m_panelContext:AddSubMenu("Пропы %dev%")
			for i,v in pairs(SWRP.Ents:GetItems()) do
			//print(i)
			a:AddOption(v.Name, function() RunConsoleCommand("__create_item", i) end)
			end
			*/
			m_panelContext:Open()
		end
		
		gui.EnableScreenClicker(false)
		return 
	end 
	
	if IsValid(m_panelContext) then
		gui.EnableScreenClicker(false)
		m_panelContext:Remove() 
	end
end)

//hook.Add
