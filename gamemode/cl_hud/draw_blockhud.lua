BlocksHUD = BlocksHUD or {}

function GM:AddBlockCHud(Str)
	BlocksHUD[Str] = true 
end

hook.Add( "HUDShouldDraw", "ShouldDraw", function( name )
	if (BlocksHUD[name]) then return false end 
end)