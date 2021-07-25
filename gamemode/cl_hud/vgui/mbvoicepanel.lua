
local PANEL = {}
local TEX_GRADIENT_LEFT	= surface.GetTextureID( "gui/gradient" )
local TEX_GRADIENT_DOWN = surface.GetTextureID( "gui/gradient_down" )
AccessorFunc( PANEL, "m_fFractionHP",	"FractionHP" )
AccessorFunc( PANEL, "m_fFractionAR",	"FractionAR" )
function PANEL:Init()
	self:SetMouseInputEnabled( false )
	self:SetFractionHP( 0 )
	self:SetFractionAR( 0 )
	self.m_colBackground = Color( 40, 40, 40, 255 )
	self.m_colHPBar = Color( 255, 50, 50, 255 )
	self.m_colARBar = Color( 50, 50, 255, 255 )
	self:Dock( BOTTOM ) 
	self:DockMargin( 0,5,0,0 )
end
function PANEL:SetBackgroundColor( col )
	self.m_colBackground = col
end
function PANEL:SetBarColorHP( col )
	self.m_colHPBar = col
end
function PANEL:SetBarColorAR( col )
	self.m_colARBar = col
end
function PANEL:SetFullGradient( bool )
	self.m_fullBar = bool
end
function PANEL:SetPlayer( ent )
	self.m_entPly = ent
end
function PANEL:Paint( intW, intH )

	if !self.Pushed3D then
		-- Its a scientifically proven fact that blur improves a script
		if IsValid(self) then
			local x, y = self:LocalToScreen(0, 0)

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( m_matBlur )

			for i = 1, 3 do
				m_matBlur:SetFloat( "$blur", ( i / 10 ) * 20 )
				m_matBlur:Recompute()

				render.UpdateScreenEffectTexture()
				surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
			end
		end
	end
	surface.SetDrawColor( self.m_colBackground )
	surface.DrawRect( 0, 0, intW, intH )
	
	//surface.SetDrawColor( self.m_colBackground )
	//surface.DrawRect( 0, 0, intW, intH )
	if (intW -2) *self.m_fFractionHP > 0 then
		//surface.SetDrawColor( self.m_colBar )
		//surface.DrawRect( 0, 0, (intW) *self.m_fFraction, intH  )
		surface.SetDrawColor(
			math.max( 0, self.m_colHPBar.r ),
			math.max( 0, self.m_colHPBar.g ),
			math.max( 0, self.m_colHPBar.b ),
			255*self.m_fFractionHP
		)
		
		surface.SetTexture( TEX_GRADIENT_LEFT )
		surface.DrawTexturedRectRotated( intW-2, (intH/2)+4, intH, 5, -90 )
		surface.SetTexture( TEX_GRADIENT_LEFT ) 
		//local half = intH  /2 
		
		if self.m_fullBar and !GUI3D.config.Enabled and !self.Pushed3D then
		intW = intW*2
		end
		//surface.DrawTexturedRect( 5, 0, intW*self.m_fFractionHP, 5 )
		//surface.DrawTexturedRect( 0, 0, 5, intH )
		//surface.DrawTexturedRectRotated( 0 +(intW  *self.m_fFraction) /2, intH -(half /2), (intW -2) *self.m_fFraction, half, 0 )
		//surface.DrawTexturedRectRotated( 0 +(intW  *self.m_fFractionHP)/2, 2, intW *self.m_fFractionHP, 5, 180 )
		local x1, x2 = ((intW-(intW*self.m_fFractionHP))/2)+intW/2, ((intW*self.m_fFractionHP))
		//print(x1, x2)
		surface.DrawTexturedRectRotated( x1, 2, x2+1, 5, 180 ) 
	end
	
	if (intW -2) *self.m_fFractionAR > 0 then
		//surface.SetDrawColor( self.m_colBar )
		//surface.DrawRect( 0, 0, (intW) *self.m_fFraction, intH  )
		surface.SetDrawColor(
			math.max( 0, self.m_colARBar.r ),
			math.max( 0, self.m_colARBar.g ),
			math.max( 0, self.m_colARBar.b ),
			255*self.m_fFractionAR
		)
		//surface.DrawRect( 0, 0, 5, intH )
		surface.SetTexture( TEX_GRADIENT_LEFT )
		surface.DrawTexturedRectRotated( intW-2, intH/2, intH-5-4, 5, 90 )
		surface.SetTexture( TEX_GRADIENT_LEFT ) 
		//local half = intH  /2 
		
		if self.m_fullBar and !GUI3D.config.Enabled and !self.Pushed3D then
			intW = intW*2
		end
		//surface.DrawTexturedRect( 5, 0, intW*self.m_fFractionHP, 5 )
		//surface.DrawTexturedRect( 0, 0, 5, intH )
		//surface.DrawTexturedRectRotated( 0 +(intW  *self.m_fFraction) /2, intH -(half /2), (intW -2) *self.m_fFraction, half, 0 )
		
		//w = intW-(intW-(intW*self.m_fFraction))
		
		//surface.DrawTexturedRectRotated( 0 +(intW  *self.m_fFraction) /2, intH -(half /2), (intW -2) *self.m_fFraction, half, 0 )
		//print(self.m_fFractionAR)
		//print(0 +(intW+(intW  *self.m_fFractionAR)))
		local x1, x2 = ((intW-(intW*self.m_fFractionAR))/2)+intW/2, ((intW*self.m_fFractionAR))+1
		//print(x1, x2)
		surface.DrawTexturedRectRotated( x1, intH-2, x2, 5, 180 ) 
	end
	
	if IsValid(self.m_entPly) and self.m_entPly:IsPlayer() and self.m_entPly.Talking and self.m_entPly:GetNWBool("is_radio") then
		DrawTexturedRect( 10, 10, (intH-20), (intH-20), MAIN_TEXTCOLOR, m_matVoice )
	end
	surface.SetDrawColor( 0, 0, 0, 255 )
	//surface.DrawRect( 0, 0, intW, 1 ) --top
	//surface.DrawRect( 0, 0, 1, intH ) --left side
	//surface.DrawRect( intW -1, 0, 1, intH ) --right side
	//surface.DrawRect( 0, intH -1, intW, 1 ) --bottom
end
vgui.Register( "MBVoicePanel", PANEL, "EditablePanel" )

/*
timer.Simple(2,function()
	hook.Add("PlayerStartVoice","hud2",function( ply )
		//if !IsValid(LocalPlayer()) or !LocalPlayer():IsPlayer() then return end
		if IsValid(ply.vp) and ispanel(ply.vp) then
			ply.vp:Remove()
		end
		ply.vp = vgui.Create("MBVoice",m_pnlVoices)
		if !IsValid(ply.vp) or !ispanel(ply.vp) then return end

		ply.vp:Setup(ply)
	end)
end)

hook.Add("Tick","destroy",function()
	for _,ply in pairs(player.GetAll())do
		if !ply.vp or !ispanel(ply.vp) then continue end
		if !ply:IsSpeaking() and IsValid(ply.vp) then
			ply.vp:SetDestroy(EndVoice)
		end
	end
end)
*/
//hook.Remove("HUDPaint","_VoiceChatDraw")

/*
hook.Add("HUDPaint","_VoiceChatDraw",function()
	if (!VoiceEna) then return end
	
	local D = 0

	for k,v in pairs( player.GetAll() ) do
		if (v.Talking) then
			local H = 30 + 30*D
			D = D+1
			
			local V = v:VoiceVolume()
			local D = MAIN_COLOR
			
			VOCOL.r = math.Clamp(D.r-100*V,0,255)
			VOCOL.g = math.Clamp(D.g+200*V,0,255)
			VOCOL.b = math.Clamp(D.b-100*V,0,255)
			
			DrawRect( 0, H, 200, 25, VOCOL )
			
			DrawTexturedRect( 180, H+4, 16, 16, MAIN_TEXTCOLOR, VoiceMat )
			DrawText( v:Nick(), "Trebuchet18", 4, H+3, MAIN_TEXTCOLOR )
		end
	end
end)
*/