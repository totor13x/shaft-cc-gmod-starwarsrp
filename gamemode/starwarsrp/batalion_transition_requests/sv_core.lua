SWRP.TransitionAbility = {}
SWRP.TransitionAbility.List = SWRP.TransitionAbility.List or {}
SWRP.TransitionAbility.Requests = SWRP.TransitionAbility.Requests or {}
/*
//sql.Query("DROP TABLE transition_ability")
if !sql.TableExists("transition_ability") then
    sql.Query("CREATE TABLE transition_ability( charid INTEGER )")
    //print("Creating TransitionAbility table")
end
local q = sql.Query("SELECT * FROM transition_ability") or {}
for k,v in pairs(q) do
    SWRP.TransitionAbility[v.charid] = true;
end
*/
function SWRP.TransitionAbility:RefreshData(clearother)
    if !clearother then
        local CharsOnServer = {}
        for i,v in pairs(player.GetAll()) do
            if v.Char then
                CharsOnServer[v.Char.id] = true
            end
        end
    end

    SWRP.TransitionAbility.List = {}
    local q = sql.Query("SELECT * FROM transition_ability") or {}
    for k,v in pairs(q) do
        //print(v.charid, CharsOnServer[v.charid], (CharsOnServer and CharsOnServer[v.charid]) or (CharsOnServer == nil))
        if (CharsOnServer and !CharsOnServer[v.charid]) then continue end
            SWRP.TransitionAbility.List[v.charid] = true;
        //end
    end
    
end
function SWRP.TransitionAbility:Update(ply)
    netstreamSWRP.Start(ply, "SWRP.TA:Update", SWRP.TransitionAbility.List )
end

hook.Add("SWRP::LoadoutCharacter","SWRP.TransitionAbility.LoadChar", function()
    SWRP.TransitionAbility:RefreshData()
    SWRP.TransitionAbility:Update()
end)
//util.AddNetworkString("enable_transition")
netstreamSWRP.Hook("enable_transition", function(pl, charid, enab)
    if enab then
        sql.Query( "INSERT INTO transition_ability( charid ) VALUES ( " ..  charid .. ")" )
    else
        sql.Query( "DELETE FROM transition_ability WHERE charid = " ..  tonumber(charid))
    end
    SWRP.TransitionAbility:RefreshData(true)
    //SWRP.TransitionAbility:Update()
    
	pl:ConCommand("cmd_pnlBatalion "..charid) -- Да, здесь этому находиться лучше

end)

netstreamSWRP.Hook("AcceptTransition", function(pl, charid, accept)
    --
    if accept then
        local Char = table.Copy(GAMEMODE:GetCharacterID(tonumber(charid)))
        local data = sql.QueryRow("SELECT * FROM transition_requests WHERE charid = '" .. charid .. "'")
    
        Char.batalion = data.new_bat
        if tonumber(Char.rank)  < MSG then
            Char.rank = math.max(Char.rank - 1, PVT)
        elseif tonumber(Char.rank) < MLT then
            Char.rank = Char.rank - 2
        elseif tonumber(Char.rank) < MAJ then
            Char.rank = Char.rank - 3
        elseif tonumber(Char.rank) < CC then
            Char.rank = Char.rank - 4
        else
            Char.rank = math.max(Char.rank - 6, PVT)
        end

        if data.new_bat == "ARC" then
            Char.rank = PVT
        end

        SWRP.Roles:FindRelativeClassesBlockBats(Char.role, Char.rank, Char.batalion, Char, function(Char, data)
            Char.role = data.id
        end)

        //local tab = table.Copy(GAMEMODE:GetCharacterID(charid))
        GAMEMODE:SaveCharacter({Char = Char})
        GAMEMODE:UpdateCharacterModel(charid)

        local ply = player.GetBySteamID(data.sid)
        if ply and tonumber(ply:CharID()) == tonumber(charid) then
            ply:CharacterSelect(charid)
        end
    end
    sql.Query( "DELETE FROM transition_ability WHERE charid = " ..  tonumber(charid))
    sql.Query( "DELETE FROM transition_requests WHERE charid = " ..  tonumber(charid))
    SWRP.TransitionAbility:RefreshData()
    SWRP.TransitionAbility:Update()
    /*
    //if ply and ply.Char.id == charid then
        ply:CharacterSave({Char = tab})
        GAMEMODE:UpdateCharacterModel(ply.Char.id)
        ply:CharacterSelect(ply.Char.id)
    //end
    */
    
    //SWRP.TransitionRequests = sql.Query("SELECT * FROM transition_requests")
    //PrintTable(SWRP.TransitionRequests)
    //sql.Query("DELETE FROM transition_requests WHERE charid = " .. charid .. "")
    //SWRP.TransitionAbility:RefreshData()
    //SWRP.TransitionAbility:Update()
    //SWRP.TransitionRequests = sql.Query("SELECT * FROM transition_requests")
    //print("PrInTiNg SWRP.TransitionRequests")
    //PrintTable(SWRP.TransitionRequests or {})
    //print(charid)
    //PrintTable(SWRP.TransitionRequests)
    //netstreamSWRP.Start(nil, "DeleteFromClient", charid)
    
end)

netstreamSWRP.Hook("AddTranslationRequestSv", function(pl, charid, sid, nbat)
    print(nbat, pl.Char.rank, LT) 
    if pl.Char.batalion == nbat then

        SWRPChatText(true)
            :Add('Нельзя переходить в свой ', Color(255,255,255))
            :Add("батальон", Color(212,100,59))
            :Add('.', Color(255,255,255))
            :Send(pl)
        return 
    end
    if "ARC" == nbat && (tonumber(pl.Char.rank) < LT) then
    	
        SWRPChatText(true)
            :Add('В батальон ', Color(255,255,255))
            :Add("ARC", Color(212,100,59))
            :Add(' можно перевестить со звания ', Color(255,255,255))
            :Add("LT", Color(212,100,59))
            :Add('.', Color(255,255,255))
            :Send(pl)
        return 
    end

    SWRPChatText(true)
        :Add('Ты подал заявку на перевод в батальон ', Color(255,255,255))
        :Add(nbat, Color(212,100,59))
        :Add('.', Color(255,255,255))
        :Send(pl)
    sql.Query( "INSERT INTO transition_requests( charid, sid, new_bat ) VALUES( " ..  charid .. ", '" .. sid .. "', '" .. nbat .. "')" )
    //SWRP.TransitionAbility:RefreshData()
    //SWRP.TransitionAbility:Update()
    //netstreamSWRP.Start(nil, "AddToClient", charid, nbat, sid)
end)

SWRP.TransitionAbility:RefreshData(true)
SWRP.TransitionAbility:Update()