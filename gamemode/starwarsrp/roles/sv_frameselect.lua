netstreamSWRP.Hook("Char.SelectedRole", function(ply, role)
    if IsValid(ply) and ply.Char and table.HasValue(GAMEMODE.RolesWithCreate, role) then
		ply.Char.role_selected = role
		ply.Char.role = role
		ply:CharacterSave()
		GAMEMODE:UpdateCharacterModel(ply.Char.id)
        ply:CharacterSelectWithoutSpawn(ply.Char.id)
        
        SWRPChatText(true)
            :Add(ply:CharNick(), Color(212,100,59))
            :Add(' взял специализацию ', Color(255,255,255))
            :Add(SWRP.Roles:DRoleName(role), Color(212,100,59))
            :SendWhoHear(ply) 
        //SWRP.Roles:DRoleName(v)
    end
end)