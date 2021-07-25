
print('sh rp_commands')
if SERVER then
    concommand.Add("create_laat", function(ply)
        local ship = ents.Create("lunasflightschool_laatgunshipblue")
        local pos = ply:GetEyeTrace().HitPos
        ship:SetPos(pos)
        ship:Spawn()
    end)
end