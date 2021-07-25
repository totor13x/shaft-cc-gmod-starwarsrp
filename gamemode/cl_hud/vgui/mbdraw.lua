
function draw.DrawFancyRect( intX, intY, intW, intH, intSlantLeft, intSlantRight, matMaterial )
	intSlantLeft, intSlantRight = math.rad(intSlantLeft), math.rad(intSlantRight)

	local ladj = (intSlantLeft == 90 or intSlantLeft == 270) and 0 or ((1 /math.tan(intSlantLeft)) *intH)
	local radj = (intSlantRight == 90 or intSlantRight == 270) and 0 or ((1 /math.tan(intSlantRight)) *intH)

	local tl = ladj > 0 and ladj or 0
	local bl = ladj > 0 and 0 or -ladj
	local tr = radj > 0 and 0 or -radj
	local br = radj > 0 and radj or 0

	if matMaterial then surface.SetMaterial( matMaterial ) else draw.NoTexture() end
	surface.DrawPoly{
		{ x = intX +tl, y = intY },
		{ x = intX +intW -tr, y = intY },
		{ x = intX +intW -br, y = intY +intH },
		{ x = intX +bl, y = intY +intH }
	}
	
end

local PANEL = {}
function PANEL:Init()
	self:SetMouseInputEnabled( false )
	self.m_colBackground = Color( 40, 40, 40, 255 )
	self.m_colBar = Color( 255, 50, 50, 255 )
end
function PANEL:SetBackgroundColor( col )
	self.m_colBackground = col
end
function PANEL:Paint( intW, intH )
	/*
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
	*/
	surface.SetDrawColor( self.m_colBackground )
	surface.DrawRect( 0, 0, intW, intH )
	
end
vgui.Register( "MBPanel", PANEL, "DPanel" )