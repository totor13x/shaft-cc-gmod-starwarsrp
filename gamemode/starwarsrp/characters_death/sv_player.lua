local plyMeta = FindMetaTable("Player")
local entMeta = FindMetaTable("Entity")

function GM:PlayerDeathThink( ply )
	if (ply.DeathTime or 0)+SWRP.Config.TimeRespawn < CurTime() and ply:KeyPressed(IN_JUMP) then
		ply:Spawn()
	end
end

hook.Add("PostPlayerDeath", "SWRP.Player::PostPlayerDeath", function(ply)
	ply:SetNWBool("JetEnabled", false)
end)