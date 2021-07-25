function DrawHealthbar()
	local HP, AP = LocalPlayer():Health(), LocalPlayer():Armor()
	
	//DrawText( "hp "..HP, "MBDefaultFontMedium", 10, ScrH()-62, MAIN_BLACKCOLOR )
	//DrawText( "hp "..HP, "MBDefaultFontMedium", 10, ScrH()-60, MAIN_WHITECOLOR )
	//DrawText( "ap "..AP, "MBDefaultFontMedium", 10, ScrH()-42, MAIN_BLACKCOLOR )
	//DrawText( "ap "..AP, "MBDefaultFontMedium", 10, ScrH()-40, MAIN_WHITECOLOR )
	//DrawText( "stamina "..LocalPlayer():GetNWInt("Needs.Stamina"), "MBDefaultFontMedium", ScrW()-10, ScrH()-40, MAIN_WHITECOLOR, TEXT_ALIGN_RIGHT )
end
STARTED_HUD = STARTED_HUD or false
hook.Add("InitPostEntity", "DrawHealthbar", function()
		if IsValid(m_pnlStamina) then m_pnlStamina:Remove() end
		local x = 1
		
		if GUI3D.config.Enabled and !self.Pushed3D then x = ScreenScale(2)/2.5 end
		//print(x)
		surface.CreateFont("MidSymbol3DDraw", { size = 15*x, weight = 400, shadow = true, extended = true})
		m_pnlStamina = vgui.Create( "MBProgress" )
		m_pnlStamina:SetBarColor( Color(175, 60, 60, 255) ) 
		m_pnlStamina:SetBackgroundColor( Color( 35, 35, 35,200) )
		m_pnlStamina:SetSize( 200*x, 30*x ) 
		m_pnlStamina:SetPos( 5, ScrH()-(90+30)*x )
		m_pnlStamina:SetFullGradient( true )
		m_pnlStamina.Think = function()
			m_pnlStamina:SetFraction( LocalPlayer():GetNWInt("Needs.Stamina") / 100 )
		end
		m_pnlStamina.OldPaint = m_pnlStamina.Paint
		m_pnlStamina.Paint = function( s, intW, intH )
			m_pnlStamina.OldPaint(s, intW, intH)
			draw.SimpleTextOutlined(
				"Запас сил: "..math.Round(LocalPlayer():GetNWInt("Needs.Stamina")).."%",
				"MidSymbol3DDraw",
				7, intH /2,
				color_white,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_CENTER,
				1,
				color_black
			)
		end

		if IsValid(m_pnlHealth) then m_pnlHealth:Remove() end
		 
		m_pnlHealth = vgui.Create( "MBProgress" )
		m_pnlHealth:SetBarColor( Color(175, 60, 60, 255) ) 
		m_pnlHealth:SetBackgroundColor( Color( 35, 35, 35,200) )
		m_pnlHealth:SetSize( 200*x, 30*x )
		m_pnlHealth:SetPos( 5, ScrH()-(50+35)*x ) 
		m_pnlHealth:SetFullGradient( true )
		m_pnlHealth.Think = function()
			m_pnlHealth:SetFraction( LocalPlayer():Health() / LocalPlayer():GetMaxHealth() )
		end
		m_pnlHealth.OldPaint = m_pnlHealth.Paint
		m_pnlHealth.Paint = function( s, intW, intH )
			m_pnlHealth.OldPaint(s, intW, intH)
			draw.SimpleTextOutlined(
				"Здоровье: "..LocalPlayer():Health().."",
				"MidSymbol3DDraw",
				7, intH /2,
				color_white,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_CENTER,
				1,
				color_black
			)
		end
		if IsValid(m_pnlArmor) then m_pnlArmor:Remove() end
		 
		m_pnlArmor = vgui.Create( "MBProgress" )
		m_pnlArmor:SetBarColor( Color(175, 60, 60, 255) ) 
		m_pnlArmor:SetBackgroundColor( Color( 35, 35, 35,200) )
		m_pnlArmor:SetSize( 200*x, 30*x )
		m_pnlArmor:SetPos( 5, ScrH()-(50)*x )
		m_pnlArmor:SetFullGradient( true )
		m_pnlArmor.Think = function()
			m_pnlArmor:SetFraction( LocalPlayer():Armor() / LocalPlayer():GetMaxArmor() )
		end
		m_pnlArmor.OldPaint = m_pnlArmor.Paint
		m_pnlArmor.Paint = function( s, intW, intH )
			m_pnlArmor.OldPaint(s, intW, intH)
			draw.SimpleTextOutlined(
				"Броня: "..LocalPlayer():Armor().."",
				"MidSymbol3DDraw",
				7, intH /2,
				color_white,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_CENTER,
				1,
				color_black
			)
		end
		if IsValid(m_pnlName) then m_pnlName:Remove() end
		 
		m_pnlName = vgui.Create( "MBPanel" )
		m_pnlName:SetBackgroundColor( Color( 35, 35, 35,200) )
		m_pnlName:SetSize( 200*x, 40*x ) 
		m_pnlName:SetPos( 5, ScrH()-((60)+35+35+35)*x )
		m_pnlName.OldPaint = m_pnlName.Paint
		m_pnlName.Paint = function( s, intW, intH )
			m_pnlName.OldPaint(s, intW, intH)
			draw.SimpleTextOutlined(
				LocalPlayer():CharName(),
				"MidSymbol3DDraw",
				7, (intH /2)-7*x,
				color_white,
				TEXT_ALIGN_LEFT, 
				TEXT_ALIGN_CENTER,
				1,
				color_black
			)
			draw.SimpleTextOutlined(
				LocalPlayer():GetNWString("BatName"),
				"MidSymbol3DDraw",
				7, (intH /2)+7*x,
				color_white,
				TEXT_ALIGN_LEFT, 
				TEXT_ALIGN_CENTER,
				1,
				color_black
			)
			//s:OldPaintOver(s, intW, intH)
		end 
		
		if wOS and wOS.MountLevelToHUD then
			if IsValid(m_pnlLightsaber) then m_pnlLightsaber:Remove() end
			 
			m_pnlLightsaber = vgui.Create( "MBProgress" )
			m_pnlLightsaber:SetBackgroundColor( Color( 35, 35, 35,200) )
			m_pnlLightsaber:SetFullGradient( true )
			m_pnlLightsaber:SetSize( 200*x, 30*x ) 
			m_pnlLightsaber:SetPos( 5, ScrH()-((60)+35+35+35+45)*x )
			m_pnlLightsaber.OldPaint = m_pnlLightsaber.Paint
			m_pnlLightsaber.Paint = function( s, intW, intH )
				m_pnlLightsaber.OldPaint(s, intW, intH)
				draw.SimpleTextOutlined(
					s.level == wOS.SkillMaxLevel and "LVLMAX" or "LVL".. s.level .." > ".. (s.level+1 == wOS.SkillMaxLevel and "LVLMAX" or "LVL"..(s.level+1).." (".. math.Round(s.rat*100).."%)"),
					"MidSymbol3DDraw",
					7, intH /2,
					color_white,
					TEXT_ALIGN_LEFT,
					TEXT_ALIGN_CENTER,
					1,
					color_black
				)
				
			end 
			m_pnlLightsaber.Think = function(s)
				s.level = LocalPlayer():GetNW2Int( "wOS.SkillLevel", 0 )
				s.xp = LocalPlayer():GetNW2Int( "wOS.SkillExperience", 0 )
				s.reqxp = wOS.XPScaleFormula( s.level )
				s.lastxp = 0
				if s.level > 0 then
					s.lastxp = wOS.XPScaleFormula( s.level - 1 )
				end
				local rat = ( s.xp - s.lastxp )/( s.reqxp - s.lastxp )
				if s.level == wOS.SkillMaxLevel then
					rat = 1
				end
				
				s.rat = rat
				s:SetFraction( s.rat / 1 )
			end
		end
		
		if IsValid(m_pnlVoices) then m_pnlVoices:Remove() end
		m_pnlVoices = vgui.Create("Panel")
		m_pnlVoices:SetSize( 200*x, ScrH()-10 )
		m_pnlVoices:SetPos( (ScrW()-5)-(200*x), 5 )
		//m_pnlVoices.lastPlys = SWRP.Radio.Plys
		m_pnlVoices.Paint = function( s, intW, intH )
			//surface.DrawRect(0,0,intW,intH)
		end
		
		/*
		m_pnlHealth:SetBarColor( Color(175, 60, 60, 255) ) 
		m_pnlHealth:SetBackgroundColor( Color( 35, 35, 35,200) )
		m_pnlHealth:SetSize( 200*x, 30*x )
		m_pnlHealth:SetPos( 5, ScrH()-(40+35)*x ) 
		m_pnlHealth:SetFullGradient( true )
		m_pnlHealth.Think = function()
			m_pnlHealth:SetFraction( LocalPlayer():Health() / 100 ) 
		end
		*/
			m_pnlVoices.Think = function( s )
				//if !SWRP.Radio.ID then s:SetVisible(false) return end
				if SWRP.Radio.Plys != lastPlys then
					//print(SWRP.Radio.Plys != lastPlys)
					//PrintTable(SWRP.Radio.Plys)
					
					for i,v in pairs(s:GetChildren()) do v:Remove() end
					
					local dataframe = vgui.Create( "MBPanel", m_pnlVoices )
					dataframe:SetBackgroundColor( Color( 175, 35, 35, 200) )
					dataframe:SetSize( 200*x, 30*x ) 
					dataframe:Dock( BOTTOM ) 
					dataframe:DockMargin( 0,5,0,0 )
					dataframe.OldPaint = dataframe.Paint
					dataframe.Paint = function( s, intW, intH )
						dataframe.OldPaint(s, intW, intH) 
						draw.SimpleTextOutlined( 
							"Частота рации: "..(SWRP and SWRP.Radio and SWRP.Radio.ID or "NaN"), 
							"MidSymbol3DDraw",
							intW-7, intH /2,
							color_white,
							TEXT_ALIGN_RIGHT, 
							TEXT_ALIGN_CENTER, 
							1, 
							color_black
						)
					end 
					GUI3D:CapturePanel(dataframe)
					
					for i,v in pairs(SWRP.Radio.Plys) do
						v.vp = vgui.Create("MBVoicePanel",m_pnlVoices)
						v.vp:SetBackgroundColor( Color( 35, 35, 35, 200) ) 
						v.vp:SetSize( 200*x, 30*x )  
						v.vp:SetBarColorHP( Color(175, 60, 60, 255) ) 
						v.vp:SetBarColorAR( Color(60, 60, 175, 255) ) 
						v.vp:SetBackgroundColor( Color( 35, 35, 35,200) )
						v.vp:SetFullGradient( true )
						v.vp:SetPlayer( v )
						v.vp.Sc = x
						v.vp.Think = function(s)
							if v.vp then
								v.vp:SetFractionHP( v:Health() / v:GetMaxHealth() )
								v.vp:SetFractionAR( v:Armor() / v:GetMaxArmor() )
							else
								s:Remove()
							end 
						end
						v.vp.OldPaint = v.vp.Paint
						v.vp.Paint = function( s, intW, intH )
							v.vp.OldPaint(s, intW, intH) 
							draw.SimpleTextOutlined( 
								v:CharName(), 
								"MidSymbol3DDraw",
								intW-7, intH /2,
								color_white,
								TEXT_ALIGN_RIGHT, 
								TEXT_ALIGN_CENTER, 
								1,
								color_black
							)
							local x2 = 5
							if IsValid(s.m_entPly) and s.m_entPly:IsPlayer() and (s.m_entPly.Talking) and s.m_entPly:GetNWBool("is_radio") then
								x2 = (16+5+5+3)*x
							end
							draw.SimpleTextOutlined( 
								v:Health()..":"..v:Armor(),
								"MidSymbol3DDraw",
								x2, intH /2,
								color_white,
								TEXT_ALIGN_LEFT, 
								TEXT_ALIGN_CENTER,
								1,
								color_black
							)
							//s:OldPaintOver(s, intW, intH)
						end 
						GUI3D:CapturePanel(v.vp)
					end
					lastPlys = SWRP.Radio.Plys
				end
			end
		
		if GUI3D.config.Enabled then
			if wOS and wOS.MountLevelToHUD then
				GUI3D:CapturePanel(m_pnlLightsaber) 
			end
			GUI3D:CapturePanel(m_pnlName) 
			GUI3D:CapturePanel(m_pnlStamina) 
			GUI3D:CapturePanel(m_pnlHealth) 
			GUI3D:CapturePanel(m_pnlArmor)
			GUI3D:CapturePanel(m_pnlVoices)
		end
		STARTED_HUD = true
end)
if STARTED_HUD then
	hook.Call("InitPostEntity")
end