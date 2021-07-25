SWRP.Radio = SWRP.Radio or {}
SWRP.Radio.Channels = SWRP.Radio.Channels or {}
SWRP.Radio.Users = SWRP.Radio.Users or {}
/*
local bot = player.GetBots()[1]
SWRP.Radio.Channels['999'] = {}
SWRP.Radio.Channels['999'][bot] = true
SWRP.Radio.Users[bot] = '999'
*/
netstreamSWRP.Hook("Radio::Create", function(ply, tab) 
	if ply.Char and SWRP.Ranks:DGetPriv(ply.Char.rank, 'Radio') then
		if !SWRP.Radio.Channels[tab.id] then
			SWRP.Radio.Channels[tab.id] = {}
			SWRP.Radio.Users = SWRP.Radio.Users or {}
			
			SWRP.Radio.Users[ply] = tab.id
			/*
			local ms = ChatMsg()
			ms:Add('[',Color(233,242,249))
			ms:Add("⚹", Color(212,100,59))
			ms:Add('] ',Color(233,242,249))
			ms:Add(ply:CharNick(), Color(212,100,59))
			ms:Add(' перешел к частоте #',Color(255,255,255))
			ms:Add(tab.id,Color(212,100,59))
			ms:Send(ply)
			*/
			
			SWRP.Radio.Channels[tab.id][ply] = true
			SWRP.Radio:DRefreshData(ply)
		end
	end
end)

netstreamSWRP.Hook("Radio::Join", function(ply, tab)
	if ply.Char and SWRP.Ranks:DGetPriv(ply.Char.rank, 'Radio') then
		if SWRP.Radio.Channels[tab.id] then //%если канала нет - создать новый и пустить юзера%
			SWRP.Radio.Users = SWRP.Radio.Users or {}
		
			SWRP.Radio.Users[ply] = tab.id
			
			SWRP.Radio.Channels[tab.id][ply] = true
			local plys = {}
			for i,v in pairs(SWRP.Radio.Channels[SWRP.Radio.Users[ply]]) do
				table.insert(plys, i)
			end
			
			
			-- local ms = ChatMsg()
			-- ms:Add('[',Color(233,242,249))
			-- ms:Add("⚹", Color(212,100,59))
			-- ms:Add('] ',Color(233,242,249))
			-- ms:Add(ply:CharNick(), Color(212,100,59))
			-- ms:Add(' перешел к частоте #',Color(255,255,255))
			-- ms:Add(tab.id,Color(212,100,59))
			-- ms:Send(plys)
			SWRP.Radio:DRefreshData(ply)
		end
	end
end)

local function leaveply(ply)
	if SWRP.Radio.Users[ply] then 
		local id = SWRP.Radio.Users[ply]
		
		local plys = {}
		for i,v in pairs(SWRP.Radio.Channels[SWRP.Radio.Users[ply]]) do
			table.insert(plys, i)
		end		
		
		-- local ms = ChatMsg()
		-- ms:Add('[',Color(233,242,249))
		-- ms:Add("⚹", Color(212,100,59))
		-- ms:Add('] ',Color(233,242,249))
		-- ms:Add(ply:CharNick(), Color(212,100,59))
		-- ms:Add(' покинул частоту #',Color(255,255,255))
		-- ms:Add(id,Color(212,100,59))
		-- ms:Send(plys)
		
		SWRP.Radio.Channels[id][ply] = nil
		if table.Count(SWRP.Radio.Channels[id]) == 0 then
			SWRP.Radio.Channels[id] = nil
		end
		SWRP.Radio.Users[ply] = nil
		
		SWRP.Radio:DRefreshData(ply)
	end
end
hook.Add("PlayerDisconnected", "Radio::Fix", leaveply) 
netstreamSWRP.Hook("Radio::Leave", leaveply)

function SWRP.Radio:DRefreshData(ply)
	if IsValid(ply) then
		local plys = {}
		if SWRP.Radio.Users[ply] then
			for i,v in pairs(SWRP.Radio.Channels[SWRP.Radio.Users[ply]]) do
				table.insert(plys, i)
			end
		end
		local datastream = {}
		datastream.ID = SWRP.Radio.Users[ply] or nil
		datastream.Plys = plys
		netstreamSWRP.Start( SWRP.Radio.Users[ply] and plys or ply, "Radio::Refresh", datastream )
	end
end 

concommand.Add("radio_use", function(ply, cmd, args)
	if args[1] == 'true' then
		ply.radio = true
	else
		ply.radio = false
	end
	ply:SetNWBool("is_radio", ply.radio)
end)

function SWRP.Radio.PlayerCanHearPlayersVoice( listener, talker )
	if talker.radio and SWRP.Radio.Users[listener] == SWRP.Radio.Users[talker] then return true, false end
	if listener:GetPos():Distance( talker:GetPos() ) < 500 then return true, true end
	
	return false
end

hook.Add( "PlayerCanHearPlayersVoice", "Maximum Range HEAR", function( listener, talker )
	return SWRP.Radio.PlayerCanHearPlayersVoice( listener, talker )
end )

function GM:PlayerSay( ply, text, team )
	if not ply.lastChatTime then ply.lastChatTime = 0 end
	
	local chattime = 0.7
	if chattime <= 0 then return end

	if ply.lastChatTime + chattime > CurTime() then
		return ""
	else
		text = string.Trim(text)
		if text == "" then return "" end
		
		ply.lastChatTime = CurTime()
		
		local chat_cmd = hook.Run("SWRP::PlayerSay",  ply, text, team)
		if !chat_cmd then
			print(team, SWRP.Radio.Users[ply])
			if team && SWRP.Radio.Users[ply] then

				local id = SWRP.Radio.Users[ply]

				SWRPChatText()
					:Add('[', Color(255,255,255))
					:Add('Частота #'..id, Color(212,100,59))
					:Add('] ', Color(255,255,255))
					:Add(ply:CharNick(), Color(212,100,59))
					:Add(' сказал: ', Color(255,255,255))
					:Add(text, Color(212,100,59))
					:Send(table.GetKeys( SWRP.Radio.Channels[id])) 
			else
				SWRPChatText()
					:Add(ply:CharNick(), Color(212,100,59))
					:Add(' сказал: ', Color(255,255,255))
					:Add(text, Color(212,100,59))
					:SendWhoHear(ply) 
			end
		end
		
		return false
	end
end