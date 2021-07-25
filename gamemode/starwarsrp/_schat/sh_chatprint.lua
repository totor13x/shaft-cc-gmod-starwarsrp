if CLIENT then
	netstreamSWRP.Hook("Chat::Print", function (tabl)
		local msgs = {}
		for i,v in pairs(tabl) do
			local str = v.text
			local col = v.color
			table.insert(msgs, Color(col.r, col.g, col.b, col.a))
			table.insert(msgs, str)
		end
		chat.AddText(unpack(msgs))
	end)

else
	local meta = {}
	meta.__index = meta

	function meta:Add(string, color)
		local t = {}
		t.text = string 
		t.color = color or self.default_color or color_white
		table.insert(self.msgs, t)
		return self
	end

	function meta:Broadcast()
		netstreamSWRP.Start(nil, "Chat::Print", self.msgs)
		return self
	end

	function meta:Send(players)
		if players == nil then
			netstreamSWRP.Start(nil, "Chat::Print", self.msgs)
		else
			netstreamSWRP.Start(players, "Chat::Print", self.msgs)
		end
		return self
	end
	
	function meta:SendWhoHear(ply, withradio)
		local plys = {}
		withradio = withradio or false
		for i,v in pairs(player.GetAll()) do
			local bool1, bool2 = SWRP.Radio.PlayerCanHearPlayersVoice( v, ply )
			if bool1 then
				if withradio then  
					if !bool2 then
						plys[#plys+1] = v
					end
				else
					plys[#plys+1] = v
				end
			end
		end
		self:Send(plys)
		return self
	end
	
	function SWRPChatText(msgs)
		local t = {}
		t.msgs = {}
		if istable(msgs) then
			t.msgs = msgs
		end
		setmetatable(t, meta)
		if isbool(msgs) then
			t:Add('[',Color(233,242,249))
			t:Add("✻", Color(212,100,59))
			t:Add('] ',Color(233,242,249))
		end
		return t
	end 
end