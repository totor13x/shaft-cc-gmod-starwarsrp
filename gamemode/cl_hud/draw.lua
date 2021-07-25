surface.CreateFont("BigSymbol", { size = 15, weight = 600, shadow = true, extended = true})
surface.CreateFont("MidSymbol", { size = 15, weight = 400, shadow = true, extended = true})
surface.CreateFont("SmallSymbol", { size = 12, weight = 400, shadow = true, extended = true})
m_matBlur = Material( "pp/blurscreen", "noclamp" )

function GM:HUDPaint()
	DrawHealthbar()
end


