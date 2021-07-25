SWRP.PlayersVisible = {}

hook.Add("PostPlayerDraw", "SWRP::PlayerVisible::PostPlayerDraw", function(ply)
	SWRP.PlayersVisible[ply] = true
	hook.Run("SWRP::PostPlayerDraw", ply)
end)
hook.Add("Think", "SWRP::PlayerVisible::Think", function()
	SWRP.PlayersVisible = {}
end)
/*
if IsValid(MERender) then
	MERender:Remove()
end

MERender = vgui.Create( "DFrame" )
MERender:SetSize( 250, 250 )
MERender:SetPos(5,25)
//MERender:MakePopup()  

function MERender:Paint( w, h )

	local x, y = self:GetPos()

	render.RenderView( {
		origin = Vector(0,0,32)+LocalPlayer():GetPos()+EyeAngles():Forward()*50,
		angles = Angle( 0, -90, 0 ),
		x = x, y = y,
		w = w, h = h
	} )

end
*/