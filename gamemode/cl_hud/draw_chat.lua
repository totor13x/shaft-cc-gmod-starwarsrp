
local MAT_SHIELD = Material( "icon16/shield.png", "noclamp" )
local MAT_LOCK = Material( "icon16/lock.png", "noclamp" )

local Panel = {}
function Panel:Init()
if !SWRP.Radio.ID then
local poziv = vgui.Create("DButton", self) 
	poziv:SetPos(5,30)
	poziv:SetSize(226-10,20)
	poziv:SetText("Создать новый канал") 
	poziv.DoClick = function(s,w,h)
		//netstreamSWRP.Request("Char.Select", tabl[1].id)
		if IsValid(m_pnlRadio) then m_pnlRadio:Remove() end 
		m_pnlRadio = vgui.Create("DFrame")  
		m_pnlRadio:SetSize( 226, 30+25+25 )
		m_pnlRadio:Center()
		m_pnlRadio:MakePopup()
		
		local ggc = vgui.Create("DTextEntry", m_pnlRadio) 
		ggc:SetPos(5,30)
		ggc:SetSize(226-10,20)
		ggc:SetPlaceholderText("Введите частоту") 
		
		local poziv = vgui.Create("DButton", m_pnlRadio) 
		poziv:SetPos(5,30+25)
		poziv:SetSize(226-10,20)
		poziv:SetText("Создать новый канал") 
		poziv.DoClick = function(s)
			netstreamSWRP.Start("Radio::Create", {id = ggc:GetValue()})
			if IsValid(m_pnlRadio) then m_pnlRadio:Remove() end 
		end
	end
	
local poziv = vgui.Create("DButton", self) 
	poziv:SetPos(5,30+25)
	poziv:SetSize(226-10,20)
	poziv:SetText("Присоединиться к созданному") 
	poziv.DoClick = function(s,w,h)
		if IsValid(m_pnlRadio) then m_pnlRadio:Remove() end 
		m_pnlRadio = vgui.Create("DFrame")  
		m_pnlRadio:SetSize( 226, 30+25+25 )
		m_pnlRadio:Center()
		m_pnlRadio:MakePopup()
		
		local ggc = vgui.Create("DTextEntry", m_pnlRadio) 
		ggc:SetPos(5,30)
		ggc:SetSize(226-10,20)
		ggc:SetPlaceholderText("Введите частоту") 
		
		local poziv = vgui.Create("DButton", m_pnlRadio) 
		poziv:SetPos(5,30+25)
		poziv:SetSize(226-10,20)
		poziv:SetText("Присоединиться") 
		poziv.DoClick = function(s)
			netstreamSWRP.Start("Radio::Join", {id = ggc:GetValue()})
			if IsValid(m_pnlRadio) then m_pnlRadio:Remove() end 
		end
	end
else
	local poziv = vgui.Create("DLabel", self) 
		poziv:SetPos(5,30)
		poziv:SetSize(226-10,20)
		poziv:SetText("Выбрана частота: "..SWRP.Radio.ID) 
		
		local poziv = vgui.Create("DButton", self) 
		poziv:SetPos(5,30+25)
		poziv:SetSize(226-10,20)
		poziv:SetText("Покинуть канал") 
		poziv.DoClick = function(s)
			netstreamSWRP.Start("Radio::Leave", ply)
			if IsValid(m_pnlRadio) then m_pnlRadio:Remove() end 
		end
	end
end

vgui.Register( "MBChatRadioMenu", Panel, "DFrame" )