concommand.Add("cmd_pnlSelectFrame", function(ply,cmd,args)
	if GAMEMODE.Char and tonumber(GAMEMODE.Char.rank) >= CPL && GAMEMODE.Char.role_selected == "0" then
        if IsValid(m_pnlSelectFrame) then
            m_pnlSelectFrame:Remove() 
        end

        m_pnlSelectFrame = vgui.Create("DFrame")
        m_pnlSelectFrame:SetSize(200,200+20)
        m_pnlSelectFrame:SetTitle("Выбор класса")
        m_pnlSelectFrame:Center()
        m_pnlSelectFrame:MakePopup() 

        local DLabel = vgui.Create("DLabel", m_pnlSelectFrame)
        DLabel:SetText(
[[
Боец ]]..(LocalPlayer():CharName())..[[, сейчас перед тобой предстоит выбор своего будущего пути по профессии. Выбирай тщательно, ведь назад пути нет. Полную информацию о развитие в профессии ты можешь посмотреть в КПК Discord.
Да прибудет с тобой сила!
]]
        )
        DLabel:SetPos(5, 30)
        DLabel:SetSize(200-5-5,200- (20+20)-10-30)
        DLabel:SetWrap(true)
        DLabel.Paint = function(s,w,h) 
            //surface.SetDrawColor( Color( 30, 30, 30, 110 ) )
            //surface.DrawRect( 0, 0, w, h )
        end
        local DermaPanelTextex = vgui.Create("DScrollPanel",m_pnlSelectFrame)
        DermaPanelTextex:SetPos(5, 200-20-20-10)
        DermaPanelTextex:SetSize(200-5-5,20+20+20+5)
        DermaPanelTextex.Paint = function(s,w,h) 
            //surface.SetDrawColor( Color( 30, 30, 30, 110 ) )
            //surface.DrawRect( 0, 0, w, h )
        end
        for i,v in pairs(GAMEMODE.RolesWithCreate) do
            button = vgui.Create( "DButton", DermaPanelTextex)
            button:Dock(TOP)
            button:DockMargin(0,0,0,0)
            button:SetText(SWRP.Roles:DRoleName(v)) 
            button.DoClick = function(s)
                if IsValid(m_pnlSelectFrame) then 
                    local q = util.CreateDialog("Ты уверен?",
                    "Выбранную специализацию уже не сменить. Ты выбрал ветвь: "..s:GetText(),
                    "только в рамках одной специализации",
                    function()
                        netstreamSWRP.Start("Char.SelectedRole", v); 
                        m_pnlSelectFrame:Remove()
                    end,
                    "Yes",
                    function() end,
                    "No");
                    
                end
                //netstreamSWRP.Start("Roles::RoleUP", {sid = form.id, role = v.id})
                //timer.Simple(0, function() -- Маленький фикс
                //    RunConsoleCommand("cmd_pnlBatalion", form.id)
                //end)
            end
        end
	end
end)