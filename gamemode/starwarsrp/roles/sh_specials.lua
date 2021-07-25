SWRP.SpecialRoles["StarBaxJEDI"] = {
    Parent = JEDI,
    Name = 'Старб Виндуй',
    Model = 'models/player/alyx.mdl', -- Rizonno
    BodyGroups = '0', -- Rizonno
    Skin = 0, -- Rizonno
    Rank = CM,
    Classificator = 'J',
    Batalion = "Jedi",
    OnSpawn = function(ply)
        local data = "Старб Виндуй | Conf"
        ply.PersonalSaber = {[data] = wOS.ItemList[ data ]}
        //ply.SecPersonalSaber = {[data] = wOS.ItemList[ data ]}
        
        timer.Simple(0.5, function()
            //ply:Give('weapon_lightsaber_personal')
            ply:Give('weapon_lightsaber_personal')
        end)
    end,
    Wep = {
        'weapon_lightsaber_personal',
    },
}

function SWRP.SelectSpecialRole(ply, ID)
    if ply.Char and SWRP.SpecialRoles[ID] then
        ply.Char.special_name = null
        ply.Char.special_id_role = ID
        ply.Char.name_clas = SWRP.SpecialRoles[ID].Name
        ply.Char.rank = SWRP.SpecialRoles[ID].Rank
        ply.Char.role = SWRP.SpecialRoles[ID].Parent
        ply.Char.model = SWRP.SpecialRoles[ID].Model
        ply.Char.batalion = SWRP.SpecialRoles[ID].Batalion
        ply.Char.bodygroup = SWRP.SpecialRoles[ID].BodyGroups
        ply.Char.skin = SWRP.SpecialRoles[ID].Skin
        ply.Char.clsf = SWRP.SpecialRoles[ID].Classificator
    end
end

function SWRP.SelectOnSpawnSpecialRole(ply)
    if ply.Char then
        local ID = ply.Char.special_id_role
        if SWRP.SpecialRoles[ID] then
            return SWRP.SpecialRoles[ID].OnSpawn and SWRP.SpecialRoles[ID].OnSpawn(ply) or false
        end
    end
    return false
end