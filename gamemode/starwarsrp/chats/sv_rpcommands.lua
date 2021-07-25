hook.Add("SWRP::PlayerSay", "SWRP::ChatCmd./me", function(ply, text, team)
    if string.StartWith(text, "/me") then
        text = string.TrimLeft(text, "/me ")
        SWRPChatText()
            :Add(ply:CharNick(), Color(212,100,59))
            :Add(' '..text, Color(255,255,255))
            //:Add(text, Color(212,100,59))
            :SendWhoHear(ply) 
        return true
    end
end)

hook.Add("SWRP::PlayerSay", "SWRP::ChatCmd.//", function(ply, text, team)
    if string.StartWith(text, "//") then
        text = string.TrimLeft(text, "// ")
        SWRPChatText(true)
            :Add("[", Color(255,255,255))
            :Add("◀", Color(212,100,59))
            :Add("] ", Color(255,255,255))
            :Add(ply:CharNick()..":", Color(212,100,59))
            :Add(' '..text, Color(255,255,255))
            //:Add(text, Color(212,100,59))
            :Broadcast() 
        return true
    end
end)

hook.Add("SWRP::PlayerSay", "SWRP::ChatCmd./do", function(ply, text, team)
    if string.StartWith(text, "/do") then
        text = string.TrimLeft(text, "/do ")
            SWRPChatText(true)
            :Add("[RP] ", Color(212,100,59))
            :Add(text, Color(255,255,255))
            //:Add(text, Color(212,100,59))
            :SendWhoHear(ply) 
        return true
    end
end)

hook.Add("SWRP::PlayerSay", "SWRP::ChatCmd./try", function(ply, text, team)
    if string.StartWith(text, "/try") then
        text = string.TrimLeft(text, "/try ")
        local change = math.random(1, 2)

        local chatTry = SWRPChatText()
            :Add(ply:CharNick(), Color(212,100,59))
            :Add(" пытается "..text, Color(255,255,255))
            if change == 1 then
                chatTry:Add(" (удачно)", Color(59,240,59))
            else
                chatTry:Add(" (неудачно)", Color(240,59,59))
            end
            chatTry:SendWhoHear(ply) 

        return true
    end
end)

hook.Add("SWRP::PlayerSay", "SWRP::ChatCmd./roll", function(ply, text, team)
    if string.StartWith(text, "/roll") then
        SWRPChatText(true)
            :Add("[/roll] ", Color(212,100,59))
            :Add(ply:CharNick(), Color(212,100,59))
            :Add(" выпало число ", Color(255,255,255))
            :Add(tostring(math.random(0, 100)), Color(212,100,59))
            :SendWhoHear(ply) 

        return true
    end
end)