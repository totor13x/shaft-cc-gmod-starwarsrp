local surface = surface
local draw = draw

local PANEL = {}

local meta = FindMetaTable("Panel")
function meta:FormatCheck(text)
	self.Paint = function()
		draw.SimpleText(text, "S_Light_15", 20, 6, Color(200, 200, 200,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) 
	end
	self.Button.Paint = function(self)
		if self:GetChecked() then
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 91, 191, 63, 255)) 
		else
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 191, 63, 42, 255)) 
		end
	end
end


local PANEL = {}

function PANEL:Init()
	self.Width 		= SC.W
	self.Height 	= SC.H
	self.TeamBased 	= false
	self.IsOpen 	= false
	self.IsVis 		= false
	self.HasLoaded 	= false
	self.Alpha 		= 0
	self.BlurMat	= Material("pp/blurscreen")
	self.NextHide	= math.ceil(os.time()) + SC.FadeTime

	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)
	self:SetPos(SC.X, SC.Y)
	self:SetSize(self.Width, self.Height)
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self:DockPadding(5, 30, 5, 5) 

	self.Config = vgui.Create("DPanel")
	self.Config:SetPos(SC.X, SC.Y + self.Height)
	self.Config:SetSize(self.Width, 40)
	self.Config:SetVisible(false)

	self.TimeCheck = vgui.Create("DCheckBoxLabel", self.Config)
	self.TimeCheck:SetPos(10, self.Config:GetTall()/2 - self.TimeCheck:GetTall()/2)
	self.TimeCheck:SetText("")
	self.TimeCheck:SetValue(SC.Time)
	self.TimeCheck.OnChange = function()
        if SC.Time then
        	SC.Time = false
        else
        	SC.Time = true
        end
    end
	self.TimeCheck:SetSize(self.Width, 20)
	self.TimeCheck:FormatCheck("Timestamps?")

	self.ConnectCheck = vgui.Create("DCheckBoxLabel", self.Config)
	self.ConnectCheck:SetPos(130, self.Config:GetTall()/2 - self.ConnectCheck:GetTall()/2)
	self.ConnectCheck:SetText("")
	self.ConnectCheck:SetValue(SC.JoinLeave)
	self.ConnectCheck.OnChange = function()
        if SC.JoinLeave then
        	SC.JoinLeave = false
        else
        	SC.JoinLeave = true
        end
    end
	self.ConnectCheck:SetSize(self.Width, 20)
	self.ConnectCheck:FormatCheck("Enable join and leaving messages?")

	self.SoundCheck = vgui.Create("DCheckBoxLabel", self.Config)
	self.SoundCheck:SetPos(395, self.Config:GetTall()/2 - self.SoundCheck:GetTall()/2)
	self.SoundCheck:SetText("")
	self.SoundCheck:SetValue(SC.Sound)
	self.SoundCheck.OnChange = function()
        if SC.Sound then
        	SC.Sound = false
        else
        	SC.Sound = true
        end
    end
	self.SoundCheck:SetSize(self.Width, 20)
	self.SoundCheck:FormatCheck("Play sounds?")

	self.CloseB = vgui.Create("DButton", self)
	self.CloseB:SetPos(self:GetWide() - 80, 0)
	self.CloseB:SetText("")
	self.CloseB:SetSize(80, 24)
	self.CloseB.DoClick = function()
		self.Config:ToggleVisible() 
	end	

	self.TextB = vgui.Create("RichText", self)
	self.TextB:SetSize(400, self.Height - 61)
	self.TextB:Dock(TOP)
	self.TextB:InsertColorChange(46, 46, 46, 255)
	self.TextB:SetText("")

	self.TextB.PerformLayout = function()
		self.TextB:SetFontInternal("S_Light_15")
		if self.IsVis then
			if self.TextB:GetNumLines() > (self.Height - 84) / 18 then
				self.TextB:SetVerticalScrollbarEnabled(true) 
			else
				self.TextB:SetVerticalScrollbarEnabled(false)
			end
		end
		if not self.IsOpen then
			self.TextB:SetVerticalScrollbarEnabled(false)
		end
	end

	self.EnterB = vgui.Create("DButton", self)
	self.EnterB:SetPos(self:GetWide() - 45, self:GetTall() - 25)
	self.EnterB:SetSize(40, 21)
	self.EnterB:SetText("")

	self.TextEntry = vgui.Create("DTextEntry", self)
	self.TextEntry:SetSize(self.Width - 55, 21)
	self.TextEntry:SetPos(5, self:GetTall() - 25)
	self.TextEntry:SetPaintBackgroundEnabled(true)
	self.TextEntry:SetCursorColor(Color(250, 250, 250, 255))
	self.TextEntry:SetTextColor(Color(250, 250, 250, 255))
	self.TextEntry.PerformLayout = function(self)
		self:SetFontInternal("S_Light_15")
		self:SetBGColor(Color(46, 46, 46, self.Alpha))
	end
	
	self.EnterB.DoClick = function() self:DoChat() end
	self.TextEntry.OnEnter = function() self:DoChat() end
		
end

function PANEL:Paint()		

	self.Paint = function()	
		local x, y = self:LocalToScreen(0, 0)
		local scrW, scrH = ScrW(), ScrH()
		surface.SetDrawColor(255, 255, 255, self.Alpha)
		surface.SetMaterial(self.BlurMat)
		for i = 1, 6 do
			self.BlurMat:SetFloat("$blur", (i / 3) * 4)
			self.BlurMat:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
		end
		surface.SetDrawColor(32, 32, 32,self.Alpha)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		surface.SetDrawColor(86, 86, 92,self.Alpha)
		surface.DrawRect(0, 0, self:GetWide(), 24)
		draw.SimpleText("Чат", "S_Bold_20", 4, 2, Color(255, 255, 255,self.Alpha), TEXT_ALIGN_LEFT)
	end	

	self.CloseB.Paint = function()
		surface.SetDrawColor(62, 62, 66, self.Alpha)
		surface.DrawRect(0, 0, self.CloseB:GetWide(), self.CloseB:GetTall())
		draw.SimpleText("Settings", "S_Bold_20", self.CloseB:GetWide()/2, self.CloseB:GetTall()/2, Color(255, 255, 255, self.Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.EnterB.Paint = function()
		surface.SetDrawColor(36, 36, 36,self.Alpha)
		surface.DrawRect(0, 0, self.EnterB:GetWide(), self.EnterB:GetTall())
		local col = Color(255, 255, 255, 255)
		if self.Alpha == 0 then
			col = Color(255, 255, 255, 0)
		end
		if self.TeamBased then		
			draw.SimpleText("Team", "S_Light_15", self.EnterB:GetWide()/2, self.EnterB:GetTall()/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Say", "S_Light_15", self.EnterB:GetWide()/2, self.EnterB:GetTall()/2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	self.TextB.Paint = function()
		self.TextB:SetBGColor(Color(36, 36, 36, self.Alpha))
	end

	self.TextEntry.Paint = function()
		self.TextEntry:SetFontInternal("S_Light_15")
		self.TextEntry:SetBGColor(Color(46, 46, 46, self.Alpha))
	end

	self.Config.Paint = function()
		local x, y = self.Config:LocalToScreen(0, 0)
		local scrW, scrH = ScrW(), ScrH()
		surface.SetDrawColor(255, 255, 255, self.Alpha)
		surface.SetMaterial(self.BlurMat)
		for i = 1, 6 do
			self.BlurMat:SetFloat("$blur", (i / 3) * 4)
			self.BlurMat:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
		end
		surface.SetDrawColor(32, 32, 32, self.Alpha)
		surface.DrawRect(0, 0, self.Config:GetWide(), self.Config:GetTall())
		surface.SetDrawColor(36, 36, 36, self.Alpha)
		surface.DrawRect(4, 4, self.Config:GetWide() - 8, self.Config:GetTall() - 8)
	end

end	

function PANEL:Think()
	if not self.IsOpen then
		self:MoveToBack()
	end
	if self.NextHide < math.ceil(os.time()) then
		if not self.IsOpen and self.IsVis then
			self.IsVis = false
			self:SetVisible(false)			
			self:DoClose()

		end
	end
	if self.IsOpen then
		self.Alpha 	= Lerp(5 * FrameTime(), self.Alpha, 150)
		if input.IsKeyDown(KEY_ESCAPE) or gui.IsGameUIVisible() then
			gui.HideGameUI() 
			self.Alpha = 0
			self:DoClose()
			self:partVis()
		end
		if input.IsKeyDown(KEY_TAB) and self.TextEntry:HasFocus() then
			self.TextEntry:RequestFocus()
			self.TextEntry:SetCaretPos(#self.TextEntry:GetValue())
			local text = self.TextEntry:GetValue()
			if text == nil then return "" end
			local word
			for words in string.gmatch(text, "(%a+)") do
				word = words 
			end
			if word == nil then return end
			word = string.lower(word)
			for k, v in pairs(player.GetAll()) do
				if #word < #v:Nick() then
					if string.find(string.lower(v:Nick()), word) then
						self.TextEntry:SetText(string.gsub(text, word, v:Nick()))
					end
				end
			end
		end
	end
end

function PANEL:DoChat()
	if self.TeamBased == true then
		LocalPlayer():ConCommand("say_team \"" .. self.TextEntry:GetValue() .. "\"")
	else
		LocalPlayer():ConCommand("say \"" .. self.TextEntry:GetValue() .. "\"")
	end
	hook.Call("ChatTextChanged", GAMEMODE, "")
	self.TextEntry:SetText("")	
	self:DoClose()
	self:partVis()
end

function PANEL:DoClose()
	if not self.IsOpen then return end
	self.IsVis = false
	self.IsOpen = false
	self:SetVisible(false)
	self.Config:SetVisible(false)
	self.TextEntry:SetVerticalScrollbarEnabled(false)
	self.TextEntry:SetText("")
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	hook.Call("FinishChat", GAMEMODE, "")
	hook.Run("SWRP::FinishChat", GAMEMODE, "")
end

function PANEL:DoOpen()
	if self.IsOpen then return end			
	self.IsOpen = true
	self.IsVis 	= true
	self.Alpha 	= 0
	hook.Call("StartChat", GAMEMODE, "")
	hook.Run("SWRP::StartChat", GAMEMODE, "")
	self:SetVisible(true)
	self:MakePopup()
	self.TextEntry:RequestFocus()
	self.TextB:SetVerticalScrollbarEnabled(true)
end


function PANEL:HandlePlayerChat(p)
	if SC.Rank then
		for k, v in pairs(SC.Ranks) do
			if p:GetNWString("usergroup") == v[1] then
				local col = v[3](p)
				self.TextB:InsertColorChange(col.r, col.g, col.b, 255)
				self.TextB:AppendText(v[2].." ")
			end
		end
	end
	
	local col = team.GetColor(p:Team())
	self.TextB:InsertColorChange(col.r, col.g, col.b, col.a)
	self.TextB:AppendText(p:Nick())
end


function PANEL:AddText(...)
	self.TextB:InsertColorChange(170, 170, 170, 255)
	if SC.Time then
		self.TextB:AppendText("["..os.date("%X", os.time()).."] ")
	end
	for k, v in ipairs({...}) do
		if type(v) == "Player" then
			self:HandlePlayerChat(v)
		elseif type(v) == "string" then
			self.TextB:AppendText(v)
		elseif type(v) == "table" then
			self.TextB:InsertColorChange(v.r or 255, v.g or 255, v.b or 255, v.a or 255)
		end
	end
	self.TextB:AppendText("\n")
	if not self:IsVisible() then
		self:partVis()
	end
end

function PANEL:partVis()
	if self.IsVis then return end
	self.NextHide = math.ceil(os.time()) + SC.FadeTime
	self.IsOpen = false
	self.IsVis = true
	self:SetVisible(true)
	self.Alpha = 0
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	self.TextEntry:SetText("")
	hook.Call("ChatTextChanged", GAMEMODE, "")
end

vgui.Register("SCBox", PANEL, "DFrame")