RunConsoleCommand("sv_tfa_cmenu", 0)

concommand.Add("cycle_wep", function(ply)
	if IsValid(ply) then
		if ply.GetActiveWeapon and ply:GetActiveWeapon()  and ply:GetActiveWeapon().CycleSafety then ply:GetActiveWeapon():CycleSafety() end
	end
end)