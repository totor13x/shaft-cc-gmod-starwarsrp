netstreamSWRP.Hook("SWRP::Cadetcall", function (name, char_id)
    
SWRP:AddImmersiveNotification("На базу прибыл кадет "..name..". Возьмешься за обучение?", 20, 
    {Text = "Да", Color = Color(20,170,20)}, function(s)
        RunConsoleCommand("cmd_answercadet", char_id)
	    s:GetParent():GetParent():Remove()
    end,
    {Text = "Нет"}, function(s)
    	s:GetParent():GetParent():Remove()
    end
) 

end)

netstreamSWRP.Hook("SWRP::Cadetcall_Solo", function (name, char_id)
    SWRP:AddImmersiveNotification("Кадет "..name.." хочет обучаться у тебя. Возьмешься за обучение?", 20, 
        {Text = "Да", Color = Color(20,170,20)}, function(s)
            RunConsoleCommand("cmd_answercadet", char_id)
            s:GetParent():GetParent():Remove()
        end,
        {Text = "Нет"}, function(s)
            s:GetParent():GetParent():Remove()
        end
    )
end)
