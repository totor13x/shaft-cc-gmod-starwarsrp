if SERVER then
	util.AddNetworkString("SChatMsg")

	local meta = FindMetaTable("Player")
	_OldPrintMessageSelf = _OldPrintMessageSelf or meta.PrintMessage
	function meta:PrintMessage(typ, str)
		if typ == HUD_PRINTTALK then
			net.Start("SChatMsg")
				net.WriteString(str)
			net.Send(self)
		else
			_OldPrintMessageSelf(self, typ, str)
		end
	end

	_OldPrintMessage = _OldPrintMessage or PrintMessage
	function PrintMessage(typ, str)
		if typ == HUD_PRINTTALK then
			net.Start("SChatMsg")
				net.WriteString(str)
			net.Broadcast()
		else
			_OldPrintMessage(typ, str)
		end
	end

	util.AddNetworkString("SChatListen")
	gameevent.Listen("player_connect")
	hook.Add("player_connect", "SCJoin", function(data)
		net.Start("SChatListen")
			net.WriteBit(true)
			net.WriteString(data.name)
		net.Broadcast()
	end)

	gameevent.Listen("player_disconnect")
	hook.Add("player_disconnect", "SCLeave", function(data)
		net.Start("SChatListen")
			net.WriteBit(false)
			net.WriteString(data.name)
		net.Broadcast()
	end)
	else


surface.CreateFont("SChatText", {font = "default", weight = 500, size = 16, blursize = 0, antialias = true, shadow = true})
surface.CreateFont("SChatTitle", {font = "default", weight = 100, size = 18, blursize = 0, antialias = true}) 


if IsValid(SChat) then
	SChat:Remove()
end
SChat = SChat or nil

hook.Add("HUDShouldDraw", "SCHideHUD", function(v)
	if v == "CHudChat" then return false end
end)

hook.Add("PlayerBindPress", "SCBind", function(ply, bind, pressed)
	if ply == LocalPlayer() then
		if bind == "messagemode" and pressed then
			if not IsValid(SChat) then 
				SChat = vgui.Create("SCBox")
			end
			SChat.TeamBased = false
			SChat:DoOpen()
			return true
		elseif bind == "messagemode2" and pressed then
			if not IsValid(SChat) then 
				SChat = vgui.Create("SCBox")
			end
			SChat.TeamBased = true
			SChat:DoOpen()
			return true
		end
	end
end)

_chatAddText = _chatAddText or chat.AddText
function chat.AddText(...)
	_chatAddText(...)
	SChat = SChat or vgui.Create("SCBox")
	SChat:AddText(...)
	if SC.Sound then
		if SC.CustomSound then
			surface.PlaySound(SC.SoundPath)
		else
			chat.PlaySound()
		end		
	end
end

function chat.GetChatBoxPos() 
	return SC.X, SC.Y
end

function chat.GetChatBoxSize() 
	return SC.W, SC.H
end

hook.Add("OnPlayerChat", "SCTags", function(ply, msg, team, dead, prefixText, col1, col2)
	if GAMEMODE.FolderName == "darkrp" then
		if SC.Rank then
			for k, v in pairs(SC.Ranks) do
				if ply:GetNWString("usergroup") == v[1] then
					chat.AddText(v[3](ply), v[2] .. " ", col1, prefixText, col2, ": " .. msg)
					return true
				end
			end
		end
		chat.AddText(col1, prefixText, col2, ": " .. msg)
		return true
	end
end)

net.Receive("SChatListen", function()
	local j = net.ReadBit()
	j = tobool(j)

	local c
	if j then
		c = "connecting to"
	else
		c = "disconnecting from"
	end
	local n = net.ReadString()
	if SC.JoinLeave then
		chat.AddText(Color(118, 132, 191), "[SChat] ", Color(255, 255, 255, 255), n .. " is ".. c .. " the server.")
	end
end)

net.Receive("SChatMsg", function()
	local str = net.ReadString()
	chat.AddText(Color(151, 211, 255), str)
end)

end

--Do this down here because meta table functions hate me 
local meta = FindMetaTable("Player")
function meta:ChatPrint(str)
	if SERVER then
		net.Start("SChatMsg")
			net.WriteString(str)
		net.Send(self)
	else
		chat.AddText(str)
	end
end