m_tblNotesImmersive = m_tblNotesImmersive or {}

if IsValid(m_tblNotesInvisible) then
	m_tblNotesInvisible:Remove()
end

local scale = 0.03
local block = 400

function SWRP:AddNotesParent() 
	if !IsValid(m_tblNotesInvisible) then
		m_tblNotesInvisible = vgui.Create( "DPanel" )
		m_tblNotesInvisible.Paint = function(s,w,h)
			//draw.RoundedBox(0, 0, 0, w, h, Color(155,35,200,200))
		end
	end
end

function SWRP:AddImmersiveNotification(text, delay, ...)
	SWRP:AddNotesParent()
	local args  = {...}

	local m_notifAlt = vgui.Create( "DFrame", m_tblNotesInvisible )
	m_notifAlt:SetDraggable( false )
	m_notifAlt.StartTime = SysTime()
	m_notifAlt.Length = delay and delay or 8
	m_notifAlt:SetSize( 400, 140 )
	m_notifAlt.fx = 0
	m_notifAlt.fy = 0
	m_notifAlt.AX = 0
	m_notifAlt.AY = 0
	m_notifAlt:ShowCloseButton(false)
	m_notifAlt:DockMargin(0, 0, 0, 0)
	m_notifAlt:SetTitle("")
	m_notifAlt.Paint = function(s,w,h)
		draw.RoundedBox(0, 0, 0, w, h, Color(35,35,35,200))
		draw.SimpleText("НОВОЕ УВЕДОМЛЕНИЕ", "S_Bold_20", w/2, 30/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local x,y = m_notifAlt:GetSize()

	-- Rich Text panel
	local richtext = vgui.Create( "DLabel", m_notifAlt )
	richtext:SetPos(5,35)
	richtext:SetSize( x-10, y-35-40 )
	richtext:SetText( text )
	richtext:SetFont(  "S_Regular_20" )
	richtext:SetWrap( true )
	richtext:SetAutoStretchVertical(true)
	richtext.Paint = function(s,w,h)
		//draw.RoundedBox(0, 0, 0, w, h, Color(155,35,35,200))
	end
	m_notifAlt.grid = false
	if #args != 0 then 
		local items = math.floor( #args/2 )
		local wide = (x-10)/items
		local grid = vgui.Create( "DGrid", m_notifAlt )
		grid:SetPos( 5,y-35 )
		grid:SetCols( items )
		grid:SetColWide( wide )
		grid:SetRowHeight( 30 )
		grid.Paint = function(s,w,h)
		//draw.RoundedBox(0, 0, 0, w, h, Color(155,35,35,200))
		end

		for k, v in ipairs(args) do
			if (istable(v)) then
				local arg = args[k + 1]
				
				if (!arg or not isfunction(arg)) then
					continue;
				end;

				local buttonTableData = v
				local m_notifButtonsLeft = vgui.Create( ".CCButton", m_notifAlt )	
				m_notifButtonsLeft:SetBorders(false)
				m_notifButtonsLeft.LerpedColor = buttonTableData.Color or Color(155,35,35)
				m_notifButtonsLeft.Text = buttonTableData.Text or {}
				m_notifButtonsLeft.Font = "S_Light_20"
				m_notifButtonsLeft:SetSize(wide, 30)
				//m_notifButtonsLeft:SetPos(5,y-35)
				m_notifButtonsLeft.DoClick = function(s)
					arg(s)
				end
				grid:AddItem( m_notifButtonsLeft )
			end
		end
		m_notifAlt.grid = grid
	else
		local m_notifButtonsLeft = vgui.Create( "DButton", m_notifAlt )
		m_notifButtonsLeft:SetText("")
		m_notifButtonsLeft:SetPos( 0, 0 )
		m_notifButtonsLeft:SetSize( x,y )
		m_notifButtonsLeft.DoClick = function(s)
			m_notifAlt:Remove()
		end
		m_notifButtonsLeft.Paint = function(s,w,h) end
	end
	function richtext:PerformLayout( w,h )
		if IsValid(m_notifAlt.grid) then
			//print(35+h+5+35)
			m_notifAlt.AX, m_notifAlt.AY = x, 35+h+5+35
			m_notifAlt:SetSize(x, 35+h+5+35 )
			m_notifAlt.grid:SetPos( 5, 35+h+5 )
			//print(m_notifAlt.grid)
		else
			m_notifAlt.AX, m_notifAlt.AY = x, 35+h+5
			m_notifAlt:SetSize(x, 35+h+5 )
		end

		m_notifAlt:SlideDown( 0.3 )
		//m_notifButtonsLeft:SetPos(5,35+h+5)
		//m_notifButtonsRight:SetPos(x/2+5,35+h+5)
	end
	surface.PlaySound("buttons/blip1.wav")  
	table.insert( m_tblNotesImmersive, m_notifAlt ) 

end

function SWRP:UpdateNoticeImmersive( i, Panel, Count, posy )
	if !IsValid(Panel) then return end
	Panel:SetPos( 0, posy )
	m_tblNotesInvisible:SizeToChildren(true, true)
end

hook.Add( "PostDrawOpaqueRenderables", "HUD.NotificationsImmersiveThink", function()
	local pos = EyePos()
	local ang = LocalPlayer():GetAimVector():Angle()
	local posend = pos +ang:Forward()*17 -ang:Right()*(block*scale/2) -ang:Up()*8

	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), -40)


	if !IsValid(m_tblNotesInvisible) then
		SWRP:AddNotesParent()
	end
	local i = 1
	local Count = table.Count( m_tblNotesImmersive )
	local positionY = 0
    vgui.Start3D2D( posend, ang, scale)  
		m_tblNotesInvisible:Paint3D2D() 
		for key, Panel in SortedPairs( m_tblNotesImmersive, true ) do
			if not IsValid( Panel ) or 
			Panel.StartTime + Panel.Length < SysTime() 
			then 
				Panel:Remove()
				table.remove( m_tblNotesImmersive, key )
				m_tblNotesInvisible:SizeToChildren(true, true)
			end
			SWRP:UpdateNoticeImmersive( i, Panel, Count, positionY) 
			if !IsValid(Panel) then continue  end
			positionY = positionY + Panel:GetTall() + 5
			i = i +1
			Panel:Paint3D2D() 
		end
		vgui.DrawCursor(m_tblNotesInvisible)
	vgui.End3D2D()
end )
