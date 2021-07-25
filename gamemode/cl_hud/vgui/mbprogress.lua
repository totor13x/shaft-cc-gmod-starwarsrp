
local PANEL = {}
local TEX_GRADIENT_LEFT	= surface.GetTextureID( "gui/gradient" )
local TEX_GRADIENT_DOWN = surface.GetTextureID( "gui/gradient_down" )
AccessorFunc( PANEL, "m_fFraction",	"Fraction" )
function PANEL:Init()
	self:SetMouseInputEnabled( false )
	self:SetFraction( 0 )
	self.m_colBackground = Color( 40, 40, 40, 255 )
	self.m_colBar = Color( 255, 50, 50, 255 )
end
function PANEL:SetBackgroundColor( col )
	self.m_colBackground = col
end
function PANEL:SetBarColor( col )
	self.m_colBar = col
end
function PANEL:SetFullGradient( bool )
	self.m_fullBar = bool
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
	if (intW -2) *self.m_fFraction > 0 then
		//surface.SetDrawColor( self.m_colBar )
		//surface.DrawRect( 0, 0, (intW) *self.m_fFraction, intH  )
		surface.SetDrawColor(
			math.max( 0, self.m_colBar.r ),
			math.max( 0, self.m_colBar.g ),
			math.max( 0, self.m_colBar.b ),
			255*self.m_fFraction
		)
		surface.DrawRect( 0, 0, 5, intH )
		surface.SetTexture( TEX_GRADIENT_LEFT ) 
		//local half = intH  /2 
		
		if self.m_fullBar and !GUI3D.config.Enabled and !self.Pushed3D then
		intW = intW*2
		end
		surface.DrawTexturedRect( 5, 0, intW*self.m_fFraction, 5 )
		//surface.DrawTexturedRect( 0, 0, 5, intH )
		//surface.DrawTexturedRectRotated( 0 +(intW  *self.m_fFraction) /2, intH -(half /2), (intW -2) *self.m_fFraction, half, 0 )
		surface.DrawTexturedRectRotated( 5 +(intW  *self.m_fFraction) /2, intH -2, intW *self.m_fFraction, 5, 0 )
	end
	surface.SetDrawColor( 0, 0, 0, 255 )
	//surface.DrawRect( 0, 0, intW, 1 ) --top
	//surface.DrawRect( 0, 0, 1, intH ) --left side
	//surface.DrawRect( intW -1, 0, 1, intH ) --right side
	//surface.DrawRect( 0, intH -1, intW, 1 ) --bottom
end
vgui.Register( "MBProgress", PANEL, "EditablePanel" )
