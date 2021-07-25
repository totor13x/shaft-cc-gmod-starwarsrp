
hook.Add("HUDPaint","DrawingNames",function()
	local tr = LocalPlayer():GetEyeTraceNoCursor()
	local col = Color(255,255,255,255)
	if IsValid(tr.Entity) && (tr.Entity:IsPlayer() || tr.Entity:GetClass() == "prop_ragdoll") && tr.HitPos:Distance(tr.StartPos) < 500 then
		self.LastLooked = tr.Entity
		self.LookedFade = CurTime()
	end
	if IsValid(self.LastLooked) && self.LookedFade + 2 > CurTime() then
		col.a = (1 - (CurTime() - self.LookedFade) / 2) * 255
		self.LastLooked.col = col
		local text,x,y = nil, ScrW() / 2, ScrH() / 2 + 40
		if self.LastLooked:GetClass() == "prop_ragdoll" then
			text = self.LastLooked:GetNWString("CharName")
		else
			text = self.LastLooked:CharName()
		end
		
		draw.SimpleText(text, "default", x+1, y+1, Color(0,0,0, col.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(text, "default", x, y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.SimpleText(self.LastLooked:GetNWString("BatName"), "default", x+1, y+1+15, Color(0,0,0, col.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.LastLooked:GetNWString("BatName"), "default", x, y+15, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		//if self.LastLooked.Alive && self.LastLooked:Alive() then
		//draw.SimpleText("DEBUG - HP: "..self.LastLooked:Health().." AP: "..self.LastLooked:Armor(), "default", x, y+15+15, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		//end
	end	
end)


if IsValid(m_panelTextHead) then
	m_panelTextHead:Remove()
end

hook.Add( "PostDrawOpaqueRenderables", "HUD.TextHeadProst", function()
	//cam.IgnoreZ( true )
	//outline.Clear()

	if IsValid(self.LastLooked)  && self.LookedFade + 2 > CurTime()  then
		local ply = self.LastLooked
		if ply == LocalPlayer() then return end
		if ply != self.LastLooked then return end
		if !ply.Alive || !ply:Alive() then return end

		if !IsValid(m_panelTextHead) then
			m_panelTextHead = vgui.Create( "DFrame" )
			m_panelTextHead:SetDraggable( false )
			m_panelTextHead.StartTime = SysTime()
			m_panelTextHead.Length = delay and delay or 8
			m_panelTextHead:SetSize( 400, 140 )
			m_panelTextHead.fx = 0
			m_panelTextHead.fy = 0
			m_panelTextHead.AX = 0
			m_panelTextHead.AY = 0
			m_panelTextHead:ShowCloseButton(false)
			m_panelTextHead:DockMargin(0, 0, 0, 0)
			m_panelTextHead:SetTitle("")
			m_panelTextHead.Paint = function(s,w,h)
				//draw.RoundedBox(0, 0, 0, w, h, Color(35,35,35,200))
				local cop = self.LastLooked.col
				draw.SimpleText(self.LastLooked:CharName(), "S_Bold_50", (w/2)+1, 21, Color(0,0,0,cop.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(self.LastLooked:CharName(), "S_Bold_50", w/2, 20, cop, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(self.LastLooked:GetNWString("BatName"), "S_Regular_50", (w/2)+1, 61, Color(0,0,0,cop.a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(self.LastLooked:GetNWString("BatName"), "S_Regular_50", w/2, 60, cop, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		//render.ClearStencil()
		//render.ClearDepth()
		local offset = Vector(0, 0, 85)
		local ang = LocalPlayer():EyeAngles()
		local pos = ply:GetPos() + offset + ang:Up() - ang:Right()*(400*0.1/2)
		
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)

		//render.Clear(0, 0, 0, 0, true, true)

		-- start stencil modification
		//render.SetStencilEnable(true)

			vgui.Start3D2D( pos, Angle(0, ang.y, 90), 0.1)
				m_panelTextHead:Paint3D2D() 
			vgui.End3D2D()
/*
			cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
				draw.DrawText(self.LastLooked:CharName(), "MBDefaultFontVeryLarge", 2, 2, self.LastLooked.col, TEXT_ALIGN_CENTER)
			cam.End3D2D()
			cam.Start3D2D(pos-Vector(0,0,4), Angle(0, ang.y, 90), 0.1)
				draw.DrawText(self.LastLooked:GetNWString("BatName"), "MBDefaultFontVeryLarge", 2, 2, self.LastLooked.col, TEXT_ALIGN_CENTER)
			cam.End3D2D()
*/

		//render.SetStencilEnable(false)
	else
		if IsValid(m_panelTextHead) then
			m_panelTextHead:Remove()
		end
	end	
end)