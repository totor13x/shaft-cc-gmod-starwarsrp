GM.Batalions = (GAMEMODE or GM).Batalions or {}
//if true then return end
//print(tabl)

netstreamSWRP.Hook("Batalion::OpenFrame", function(tabl, abil, listusers)
//if istable(tabl) then PrintTable(tabl) end
if IsValid(m_pnlBatalionFrame) then
	m_pnlBatalionFrame:Remove() 
end
local a_select = false
if tabl.sidf then
	a_select = tabl.sidf
end

m_pnlBatalionFrame = vgui.Create("DFrame")
m_pnlBatalionFrame:SetSize(400,350)
m_pnlBatalionFrame:Center()
m_pnlBatalionFrame:MakePopup() 

//local startbutton = vgui.Create("DButton", m_pnlBatalionFrame)
local lab = vgui.Create("DLabel", m_pnlBatalionFrame)
lab:SetPos(5, 25)
lab:SetSize(200, 20)
lab:SetText("Солдаты батальона")
//lab:SetSize(200-5-2.5,(350-25-5-5)/2)

local DermaPanelTextex = vgui.Create("DScrollPanel",m_pnlBatalionFrame)
DermaPanelTextex:SetPos(5, 25+20)
DermaPanelTextex:SetSize(200-5-2.5,(350-25-5-5)/2)
DermaPanelTextex.Paint = function(s,w,h) 
	surface.SetDrawColor( Color( 30, 30, 30, 110 ) ) 
	surface.DrawRect( 0, 0, w, h )
end

local ab = table.Copy(tabl)
ab.Players = nil
//PrintTable(tabl.Players)
for i,v in pairs(tabl.Players) do
	
	for k,l in pairs(v) do
		Dbut = vgui.Create( "DButton",DermaPanelTextex)
		Dbut:SetSize(DermaPanelTextex:GetWide(),20)
		Dbut:SetPos(200-5-2.5,0)
		local form = table.Copy(l)
		form.batalionInfo = ab
	
		Dbut:SetText(GAMEMODE:CharName(_, true, form))
		Dbut.DoClick = function(s) 
			if !IsValid(s:GetParent():GetParent():GetParent()) then return end
			local aa = s:GetParent():GetParent():GetParent()
			if IsValid(aa.m_pnlPlayerInfo) then
				aa.m_pnlPlayerInfo:Remove()
			end
			
			aa.m_pnlPlayerInfo = vgui.Create("DScrollPanel",aa)
			aa.m_pnlPlayerInfo:SetPos(200+5-2.5, 30)
			aa.m_pnlPlayerInfo:SetSize(200-5-2.5,(350-35))
			aa.m_pnlPlayerInfo.Paint = function(s,w,h) 
				surface.SetDrawColor( Color( 30, 30, 30, 110 ) )
				surface.DrawRect( 0, 0, w, h )
				
				surface.SetDrawColor( Color( 30, 30, 30, 220 ) )
				surface.DrawRect( 5, 25+25+40+20, w-10, 1 ) //между чекбоксами
				surface.DrawRect( 5, 25+25+50+35+20, w-10, 1 )//рамки для страницы причин
			end
					
			lab = vgui.Create("DLabel", aa.m_pnlPlayerInfo)
			lab:SetPos(5, 0)
			lab:SetSize(200, 20)
			lab:SetText("Игрок: "..s:GetText().."")
			
			lab = vgui.Create("DLabel", aa.m_pnlPlayerInfo)
			lab:SetPos(5, 0+20)
			lab:SetSize(200, 20)
			lab:SetText("SteamID: "..form['steamid'].."")
			
			local xz = (aa.m_pnlPlayerInfo:GetWide()-10)/3
			button = vgui.Create( "DButton", aa.m_pnlPlayerInfo)
			button:SetSize(xz,20)
			button:SetPos(5,25+20)
			button:SetText("RankUP")
			button.DoClick = function()
				if IsValid(m_pnlDoljFrame) then m_pnlDoljFrame:Remove() end
				netstreamSWRP.Start("Batalion::RankUP", form.id)
				timer.Simple(0, function() -- Маленький фикс
					RunConsoleCommand("cmd_pnlBatalion", form.id)
				end)
			end
			button = vgui.Create( "DButton", aa.m_pnlPlayerInfo)
			button:SetSize(xz+2/2,20)
			button:SetPos(5+xz,25+20)
			button:SetText("Должность")
			button.DoClick = function(s)
				if IsValid(m_pnlDoljFrame) then m_pnlDoljFrame:Remove() end
				m_pnlDoljFrame = vgui.Create("DFrame")
				m_pnlDoljFrame:SetSize(200,150)
				m_pnlDoljFrame:Center()
				m_pnlDoljFrame:MakePopup() 
	
				local DermaPanelTextex = vgui.Create("DScrollPanel",m_pnlDoljFrame)
				DermaPanelTextex:SetPos(5, 30)
				DermaPanelTextex:SetSize(200-5-5,150-30-5)
				DermaPanelTextex.Paint = function(s,w,h) 
					//surface.SetDrawColor( Color( 30, 30, 30, 110 ) )
					//surface.DrawRect( 0, 0, w, h )
				end
				local fix = {Char = form}
				local lis = SWRP.Roles:DListCanChangeRole(fix) or {}
				for i,v in pairs(lis) do
						button = vgui.Create( "DButton", DermaPanelTextex)
						button:Dock(TOP)
						button:DockMargin(5,5,5,0)
						button:SetText(v.Name) 
						button.DoClick = function(s)
							if IsValid(m_pnlDoljFrame) then m_pnlDoljFrame:Remove() end
							netstreamSWRP.Start("Roles::RoleUP", {sid = form.id, role = v.id})
							timer.Simple(0, function() -- Маленький фикс
								RunConsoleCommand("cmd_pnlBatalion", form.id)
							end)
						end
				end
			end
			
			button = vgui.Create( "DButton", aa.m_pnlPlayerInfo)
			button:SetSize(xz,20)
			button:SetPos(5+xz+xz,25+20)
			button:SetText("Кнп №3")
			
			lab = vgui.Create("DLabel", aa.m_pnlPlayerInfo)
			lab:SetPos(5, 25+25+20)
			lab:SetSize(200, 20)
			
			local info,text = SWRP.Ranks:GetRank(form['rank']), "%zvn%"
			if info then
				text = info.Short.."|"..info.Name
			end
			lab:SetText("Звание: "..text)
			
			lab = vgui.Create("DLabel", aa.m_pnlPlayerInfo)
			lab:SetPos(5, 25+25+15+20)
			lab:SetSize(200, 20)
			
			local info,text = SWRP.Roles:DRoleInfo(form['role']).Name, "%dolj%"
			
			lab:SetText("Должность: "..info)
			
			lab = vgui.Create("DCheckBoxLabel", aa.m_pnlPlayerInfo)
			lab:SetPos(5, 25+25+50+20)
			lab:SetSize(200, 20)
			lab:SetDisabled(false)
			if abil[form.id] then
				lab:SetChecked(true)
			else
				lab:SetChecked(false)
			end
			PrintTable(abil)
			lab:SetText("Разрешить переход\nв другой батальон")
			lab.OnChange = function(s, val)
				netstreamSWRP.Start("enable_transition", form.id, val )
				//RunConsoleCommand("cmd_pnlBatalion")
			end
			
			lab = vgui.Create("DLabel", aa.m_pnlPlayerInfo)
			lab:SetPos(5, 25+25+50+35+5+20)
			lab:SetSize(200, 20)
			lab:SetText("История званий")
			
			lab = vgui.Create("RichText", aa.m_pnlPlayerInfo)
			lab:SetPos(5, 25+25+50+35+20+5+20)
			lab:SetSize(200-20, 70)
			lab:InsertColorChange(255, 255, 255, 255 ) 
			lab:AppendText("TRP|25.04.2019 - %reason%\nTRP|25.04.2019 - %reason%\nTRP|25.04.2019 - %reason%\n")  
			lab:SetVerticalScrollbarEnabled( true ) 
			lab.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 255,255, 255, 10 ) )
			end
			
		end
		Dbut:Dock( TOP )
		
		
		if form.id == a_select then
			b_select = Dbut
			//RunConsoleCommand("cmd_pnlBatalion", a_select)
		end
		
		DermaPanelTextex:AddItem(Dbut)
	end
end

Dbut:DoClick(Dbut, Dbut:GetWide(), Dbut:GetTall())
if IsValid(b_select) then
b_select:DoClick(b_select, b_select:GetWide(), b_select:GetTall())
end
/*
PrintTable(tabl)
print(LocalPlayer():SteamID())
print(GAMEMODE:CharId(LocalPlayer()))*/
//PrintTable(tostring(GAMEMODE:CharId(LocalPlayer())))


//PrintTable(tabl.Players[LocalPlayer():SteamID()][LocalPlayer():CharID()])
local charid = tonumber(LocalPlayer():CharID())
//print(charid)
//PrintTable(tabl.Players)
/*if tonumber(tabl.Players[LocalPlayer():SteamID()][charid].rank or "0")<17 then
	return
end*/

local lab = vgui.Create("DLabel", m_pnlBatalionFrame)
lab:SetPos(5, ((350-25-5-5)/2)+55)
lab:SetSize(200, 20)
lab:SetText("Заявки на батальон")

local DermaPanelTextexReq = vgui.Create("DScrollPanel",m_pnlBatalionFrame)
DermaPanelTextexReq:SetPos(5, ((350)/2)-5-5-5+55+20)
DermaPanelTextexReq:SetSize(200-5-2.5,110)

DermaPanelTextexReq.Paint = function(s,w,h) 
	surface.SetDrawColor( Color( 30, 30, 30, 110 ) )
	surface.DrawRect( 0, 0, w, h )
end
//SWRP.AddTranslationRequest(charid,LocalPlayer():SteamID(), "CT")
local lis = tabl.Transitions
for steamid,chars in pairs(lis) do
for id,data in pairs(chars) do
	//if tabl.Transitions[v.sid] and tabl.Players[v.sid][tonumber(v.charid)] then
		//PrintTable(tabl.Players)
		//print(v.sid)
		//print(v.charid)
		//form = table.Copy(tabl.Players[v.sid][tonumber(v.charid)])
		//form.batalionInfo = ab
		button = vgui.Create( "DButton", DermaPanelTextexReq)
		button:Dock(TOP)
		button:SetSize(DermaPanelTextexReq:GetWide(),20)
		//button:DockMargin(5,5,5,0)
		button:SetText(GAMEMODE:CharName(_, true, data)) 
		button.DoClick = function(s)
			local m_pnlTransitionFrame = vgui.Create("DFrame")
			m_pnlTransitionFrame:SetSize(175,180+20)
			m_pnlTransitionFrame:Center()
			m_pnlTransitionFrame:MakePopup()
			m_pnlTransitionFrame.ID = id
			m_pnlTransitionFrame.m_pnlPlayerInfoS = vgui.Create("DScrollPanel",m_pnlTransitionFrame)
			m_pnlTransitionFrame.m_pnlPlayerInfoS:SetPos(5, 30)
			m_pnlTransitionFrame.m_pnlPlayerInfoS:SetSize(175-5-5,(140+20))
			m_pnlTransitionFrame.m_pnlPlayerInfoS.Paint = function(s,w,h) 
				surface.SetDrawColor( Color( 30, 30, 30, 110 ) )
				surface.DrawRect( 0, 0, w, h )
				
				surface.SetDrawColor( Color( 30, 30, 30, 220 ) )
				surface.DrawRect( 5, 25+25+15, w-10, 1 ) //между чекбоксами
				//surface.DrawRect( 5, 25+25+50+35+20, w-10, 1 )//рамки для страницы причин
			end
					
			lab = vgui.Create("DLabel", m_pnlTransitionFrame.m_pnlPlayerInfoS)
			lab:SetPos(5, 0)
			lab:SetSize(200, 20)
			lab:SetText("Клон: ".. s:GetText() .. "")
			
			lab = vgui.Create("DLabel", m_pnlTransitionFrame.m_pnlPlayerInfoS)
			lab:SetPos(5, 0+20)
			lab:SetSize(200, 20)
			lab:SetText("SteamID: ".. data.steamid)
			
			lab = vgui.Create("DLabel", m_pnlTransitionFrame.m_pnlPlayerInfoS)
			lab:SetPos(5, 0+40)
			lab:SetSize(200, 20)
			lab:SetText("Переход из батальона: " .. data.batalion)
			
			local info = SWRP.Roles:DRoleInfo(data['role']).Name
			
			lab = vgui.Create("DLabel", m_pnlTransitionFrame.m_pnlPlayerInfoS)
			lab:SetPos(5, 0+70)
			lab:SetSize(200, 20)
			lab:SetText("Должность: "..info)

			lab = vgui.Create("DLabel", m_pnlTransitionFrame.m_pnlPlayerInfoS)
			lab:SetPos(5, 0+90)
			lab:SetSize(200, 20)
			lab:SetText("Вердикт :")
			
			lab = vgui.Create("DButton", m_pnlTransitionFrame.m_pnlPlayerInfoS)
			lab:SetPos(5, 0+115)
			lab:SetSize(155, 20)
			lab:SetText("ОДОБРЕНИЕ")
			
			lab.DoClick = function(s)
				local id = m_pnlTransitionFrame.ID
				if IsValid(m_pnlTransitionFrame) then m_pnlTransitionFrame:Remove() end
				if IsValid(m_pnlDoljFrame) then m_pnlDoljFrame:Remove() end
				timer.Simple(0, function() -- Маленький фикс
					netstreamSWRP.Start("AcceptTransition", id, true)
					RunConsoleCommand("cmd_pnlBatalion")
				end)
			end /*todo Переход в батальон*/
			
			lab = vgui.Create("DButton", m_pnlTransitionFrame.m_pnlPlayerInfoS)
			lab:SetPos(5, 0+135)
			lab:SetSize(155, 20)
			lab:SetText("ОТКАЗ")
			
			lab.DoClick = function(s)
				local id = m_pnlTransitionFrame.ID
				if IsValid(m_pnlTransitionFrame) then m_pnlTransitionFrame:Remove() end
				if IsValid(m_pnlDoljFrame) then m_pnlDoljFrame:Remove() end
				timer.Simple(0, function() -- Маленький фикс
					netstreamSWRP.Start("AcceptTransition", id, false)
					RunConsoleCommand("cmd_pnlBatalion")
				end)
			end /*todo Запрос на удаление из бд*/
			
			/*if IsValid(m_pnlDoljFrame) then m_pnlDoljFrame:Remove() end
			timer.Simple(0, function() -- Маленький фикс
				RunConsoleCommand("cmd_pnlBatalion")
			end)*/
		end
	//end
end
end

/*
local startbutton = vgui.Create("DButton", m_pnlBatalionFrame)
	startbutton:SetPos(5,30+5)
	startbutton:SetSize(20,20)
	startbutton:SetText("<")
	startbutton:SetDisabled(true)
	startbutton:SetTooltip("Выбор множества персонажей недоступен.")
	startbutton.DoClick = function(s,w,h)
	end
local startbutton = vgui.Create("DButton", m_pnlBatalionFrame)
	startbutton:SetPos(m_pnlBatalionFrame:GetWide()-25,30+5)
	startbutton:SetSize(20,20)
	startbutton:SetText(">")
	startbutton:SetDisabled(true)
	startbutton:SetTooltip("Выбор множества персонажей недоступен.")
	startbutton.DoClick = function(s,w,h)
	end
local startbutton = vgui.Create("DButton", m_pnlBatalionFrame)
	startbutton:SetPos(25,30+5)
	startbutton:SetSize(m_pnlBatalionFrame:GetWide()-50,20)
	startbutton:SetText()
	startbutton.DoClick = function(s,w,h)
		netstreamSWRP.Request("Char.Select", tabl[1].id)
	end
	*/
end)
/*
timer.Simple(0, function()

for i=CUR,MAX_RANK do
local aa = SWRP.Ranks:GetRank(i)
if !aa then continue end
	button = vgui.Create( "DLabel", DermaPanelTextex)
	button:Dock(TOP)
	button:DockMargin(5,0,5,0)
	button:SetText(" - "..SWRP.Ranks:GetRank(i).Name) 
	
	for i,v in pairs(SWRP.Roles:FindAllClasses(CLAss, i)) do 
		//local info = SWRP.Roles:DRoleInfo(GAMEMODE.Char.role).Name
		local info = v.Name
		if added[info] then continue end
		button = vgui.Create( "DButton", DermaPanelTextex)
		button:Dock(TOP)
		button:DockMargin(5,0,5,0)
		added[info] = true
		button:SetText(info)  
		button.DoClick = function(s) 
			
		end
	end
end

//m_pnlDoljFrame:Add(button)
end)
*/