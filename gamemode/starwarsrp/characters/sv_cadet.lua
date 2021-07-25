
hook.Add("SWRP::LoadoutCharacter", "SWRP::CadetSelector", function(char_id, ply)
    timer.Simple(0, function()
        if ply.Char.rank == "0" && ply.Char.role == "0" &&  ply.Char.batalion == "0" then
            local ms = ChatMsg()
            ms:Add('[',Color(233,242,249))
            ms:Add("⚹", Color(212,100,59))
            ms:Add('] ',Color(233,242,249))
            ms:Add('Здравия желаю, кадет ')
            ms:Add(ply:CharNick(), Color(212,100,59))
            ms:Add('. Вы прибыли на базу %name%.',Color(255,255,255))
            ms:Send(ply)
            local ms = ChatMsg()
            ms:Add('[',Color(233,242,249))
            ms:Add("⚹", Color(212,100,59))
            ms:Add('] ',Color(233,242,249))
            ms:Add('Ты можешь вызвать военнослужащих базы на помощь в обучении командой ')
            ms:Add("!обучение", Color(212,100,59))
            ms:Add('.',Color(255,255,255))
            ms:Send(ply)
        end
    end)
end)

hook.Add("SWRP::PlayerSay", "SWRP::ChatCmd./obuchenie", function(ply, text, team)
    if ply.Char and ply.Char.rank == "0" && ply.Char.role == "0" && ply.Char.batalion == "0" then
    if string.StartWith(text, "!обучение") then
        if (IsValid(ply.MasterCadet)) then
            local ms = ChatMsg()
            ms:Add('[',Color(233,242,249))
            ms:Add("⚹", Color(212,100,59))
            ms:Add('] ',Color(233,242,249))
            ms:Add('Ты не можешь вызвать ')
            ms:Add("!обучение", Color(212,100,59))
            ms:Add('. Тебя будет обучать ',Color(255,255,255))
            ms:Add(ply.MasterCadet:CharNick(), Color(212,100,59))
            ms:Add('.',Color(255,255,255))
            ms:Send(ply)
            return true
        end
        if (ply.m_lastCallCadet or 0) > CurTime() then
            local ms = ChatMsg()
            ms:Add('[',Color(233,242,249))
            ms:Add("⚹", Color(212,100,59))
            ms:Add('] ',Color(233,242,249))
            ms:Add('Подожди немного, перед тем как еще раз вызвать ')
            ms:Add("!обучение", Color(212,100,59))
            ms:Add('.',Color(255,255,255))
            ms:Send(ply)
            return true
        end
        local plys = {}
        for i,v in pairs(player.GetAll()) do
            if (v == ply) then continue end
            if not (v.Char and SWRP.Ranks:DGetPriv(v.Char.rank, 'CanAcceptCadet')) then continue end
            plys[#plys+1] = v
        end
        ply.m_lastCallCadet = CurTime()+60
        netstreamSWRP.Start(plys, "SWRP::Cadetcall", ply.Char.name_id.."|"..ply.Char.name_clas, ply:EntIndex())
	
        SWRPChatText(true)
            :Add(ply:CharNick(), Color(212,100,59))
            :Add(' запросил ', Color(255,255,255))
            :Add("обучение.", Color(212,100,59))
            :SendWhoHear(ply)

        return true
    end
    end
end)

netstreamSWRP.Hook("SWRP::Cadet.cancerTraining", function(ply, cadet)
    if IsValid(cadet.MasterCadet) then
        if cadet.MasterCadet == ply then
            cadet.m_lastCallCadet = CurTime()
            cadet.MasterCadet = nil

        
            SWRPChatText(true)
                :Add(ply:CharNick(), Color(212,100,59))
                :Add(' отказался от обучения кадета ', Color(255,255,255))
                :Add(cadet.Char.name_id.."|"..cadet.Char.name_clas, Color(212,100,59))
                :Add(".", Color(255,255,255))
                :SendWhoHear(ply)
                
            SWRPChatText(true)
                :Add(ply:CharNick(), Color(212,100,59))
                :Add(' отказался от твоего обучения.', Color(255,255,255))
                :Send(cadet)
        else
            SWRPChatText(true)
                :Add('Кадет ', Color(255,255,255))
                :Add(cadet.Char.name_id.."|"..cadet.Char.name_clas, Color(212,100,59))
                :Add(' не под твоим обучением.', Color(255,255,255))
                :Send(ply)
        end
    end
end)

netstreamSWRP.Hook("SWRP::Cadet.CallTrener", function(ply, trainer)
    if ply.Char and ply.Char.rank == "0" && ply.Char.role == "0" && ply.Char.batalion == "0" then
           if (IsValid(ply.MasterCadet)) then
                local ms = ChatMsg()
                ms:Add('[',Color(233,242,249))
                ms:Add("⚹", Color(212,100,59))
                ms:Add('] ',Color(233,242,249))
                ms:Add('Ты не можешь вызвать ')
                ms:Add("!обучение", Color(212,100,59))
                ms:Add('. Тебя будет обучать ',Color(255,255,255))
                ms:Add(ply.MasterCadet:CharNick(), Color(212,100,59))
                ms:Add('.',Color(255,255,255))
                ms:Send(ply)
                return true
            end
            if (ply.m_lastCallCadet or 0) > CurTime() then
                local ms = ChatMsg()
                ms:Add('[',Color(233,242,249))
                ms:Add("⚹", Color(212,100,59))
                ms:Add('] ',Color(233,242,249))
                ms:Add('Подожди немного, перед тем как еще раз вызвать ')
                ms:Add("!обучение", Color(212,100,59))
                ms:Add('.',Color(255,255,255))
                ms:Send(ply)
                return true
            end

            ply.m_lastCallCadet = CurTime()+60
            netstreamSWRP.Start(trainer, "SWRP::Cadetcall", ply.Char.name_id.."|"..ply.Char.name_clas, ply:EntIndex())
        
            SWRPChatText(true)
                :Add(ply:CharNick(), Color(212,100,59))
                :Add(' запросил обучение у ', Color(255,255,255))
                :Add(trainer:CharNick(), Color(212,100,59))
                :Add(".", Color(212,100,59))
                :SendWhoHear(ply)

    end
end)

concommand.Add("cmd_answercadet", function (ply, cmd, args)
    local cadet = Entity(args[1]) 
    if cadet.Char.rank == "0" && cadet.Char.role == "0" && cadet.Char.batalion == "0" then
        if ply.Char and SWRP.Ranks:DGetPriv(ply.Char.rank, 'CanAcceptCadet') then
            if !IsValid(cadet.MasterCadet) then
                cadet.MasterCadet = ply
                cadet.MasterCadetTime = CurTime()

                netstreamSWRP.Start( _, "GM:Notification", {
                    text =  ply:CharName().." взялся за обучение кадета "..cadet.Char.name_id.."|"..cadet.Char.name_clas,
                    type = NOTIFY_GENERIC,
                    length = 4
                } )
                local ms = ChatMsg()
                ms:Add('[',Color(233,242,249))
                ms:Add("⚹", Color(212,100,59))
                ms:Add('] ',Color(233,242,249))
                ms:Add('За твое обучение взялся ')
                ms:Add(cadet.MasterCadet:CharNick(), Color(212,100,59))
                ms:Add('.',Color(255,255,255))
                ms:Send(cadet)
            else
                local ms = ChatMsg()
                ms:Add('[',Color(233,242,249))
                ms:Add("⚹", Color(212,100,59))
                ms:Add('] ',Color(233,242,249))
                ms:Add('За обучение кадета ')
                ms:Add(cadet.Char.name_id.."|"..cadet.Char.name_clas, Color(212,100,59))
                ms:Add(' уже взялся ',Color(255,255,255))
                ms:Add(ply.MasterCadet:CharNick(), Color(212,100,59))
                ms:Add('.',Color(255,255,255))
                ms:Send(ply)
                return true
            end
        end
    end
end)