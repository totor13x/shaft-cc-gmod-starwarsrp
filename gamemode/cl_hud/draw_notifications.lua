m_tblNotes = m_tblNotes or {}
--Notifications
function GM:KillNote( uid ) 
	if not IsValid( m_tblNotes[uid] ) then return end
	m_tblNotes[uid].StartTime = SysTime()
	m_tblNotes[uid].Length = 0.8
end

function GM:AddNote( text, type, length )
	local Panel = vgui.Create( "MBNoticePanel" )
	Panel.StartTime = SysTime()
	Panel.Length = length and length or 8
	Panel.VelX = -5
	Panel.VelY = 0
	Panel.fx = ScrW() +200
	Panel.fy = ScrH()
	Panel:SetAlpha( 255 )
	Panel:SetText( text )
	Panel:SetType( type )
	Panel:SetPos( Panel.fx, Panel.fy )

	table.insert( m_tblNotes, Panel ) 
	--surface.PlaySound( "ui/beepclear.wav" )
end

function GM:UpdateNotice( i, Panel, Count )
	local x = Panel.fx
	local y = Panel.fy
	local w = Panel:GetWide()
	local h = Panel:GetTall()
	w = w
	h = h +16
	
	local ideal_y = (ScrH() *0.66) -(Count -i) *(h -12)
	local ideal_x = ScrW() -w
	local timeleft = Panel.StartTime -(SysTime() -Panel.Length)
	
	-- Cartoon style about to go thing
	if timeleft < 0.7 then
		ideal_x = ideal_x -50
	end
	-- Gone!
	if timeleft < 0.2 then
		ideal_x = ideal_x +w *2
	end
	
	local spd = FrameTime() *15
	y = y +Panel.VelY *spd
	x = x +Panel.VelX *spd
	
	local dist = ideal_y -y
	Panel.VelY = Panel.VelY +dist *spd *1
	if math.abs( dist ) < 2 and math.abs( Panel.VelY ) < 0.1 then Panel.VelY = 0 end

	local dist = ideal_x -x
	Panel.VelX = Panel.VelX +dist *spd *1
	if math.abs( dist ) < 2 and math.abs( Panel.VelX ) < 0.1 then Panel.VelX = 0 end
	
	-- Friction.. kind of FPS independant.
	Panel.VelX = Panel.VelX *(0.95 -FrameTime() *8 )
	Panel.VelY = Panel.VelY *(0.95 -FrameTime() *8 )
	Panel.fx = x
	Panel.fy = y
	Panel:SetPos( Panel.fx, Panel.fy )
end

function GM:UpdateNotes()
	local i = 0
	local Count = table.Count( m_tblNotes )
	for key, Panel in pairs( m_tblNotes ) do
		i = i +1
		GAMEMODE:UpdateNotice( i, Panel, Count )  
	end
	
	for k, Panel in pairs( m_tblNotes ) do
		if not IsValid( Panel ) or Panel:KillSelf() then m_tblNotes[k] = nil end
	end
end
hook.Add("Think", "HUD.NotificationsThink", GM.UpdateNotes)


//GAMEMODE:AddNote( "Текст", NOTIFY_HINT, 6 ) 