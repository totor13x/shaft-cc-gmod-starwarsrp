local cacheradio = {}
SWRP.Radio = SWRP.Radio or {}
SWRP.Radio.Plys = {}

//SWRP.Radio.ID = "909"
//SWRP.Radio.Plys = player.GetAll() 

netstreamSWRP.Hook("Radio::Refresh", function(data)
	//print('-------------------------')
	//PrintTable(data)
	
	SWRP.Radio = data
	
	timer.Simple(0, function()
		if IsValid(m_pnlVoices) then
			m_pnlVoices:SetVisible(true)
		end
		for i,v in pairs(SWRP.Radio.Plys) do
			cacheradio[v] = true
		end
	end)
end)

local radio_sounds = {

	on = {
		'npc/combine_soldier/vo/on1.wav',
		//'npc/combine_soldier/vo/on2.wav'
	},

	off = {
		'npc/combine_soldier/vo/off1.wav',
		//'npc/combine_soldier/vo/off2.wav'
	}

}
local on = radio_sounds.on
local off = radio_sounds.off

//hook.Add("PlayerButtonDown", "VGUI3D2DPlayerButtonDown", function(_, button)
//	if input.IsKeyDown(KEY_LALT) and button == (MOUSE_LEFT or MOUSE_RIGHT) then

//end)
/*


hook.Add("PlayerBindPress", "RadioCheck", function(ply, bind, pressed)
	if bind == "+walk" then
		-- set voice type here just in case shift is no longer down when the
		-- PlayerStartVoice hook runs, which might be the case when switching to
		-- steam overlay
		
		RunConsoleCommand("radio_use", "false")
	end
end)
*/ 
hook.Add("PlayerButtonDown", "Radio::PlayerButtonDown", function(ply, key)
   if not IsFirstTimePredicted() then return end
   if not IsValid(ply) or ply != LocalPlayer() then return end
   if key == KEY_LALT and SWRP.Radio.ID then
	print(key == KEY_LALT, "DOWN")
   		RunConsoleCommand("radio_use", "true") 
      //timer.Simple(0.05, function() RunConsoleCommand("+voicerecord")  end)
   end
end)

hook.Add("PlayerButtonUp", "Radio::PlayerButtonUp", function(ply, key)
   	if not IsFirstTimePredicted() then return end
   	if not IsValid(ply) or ply != LocalPlayer() then return end

   	if key == KEY_LALT and SWRP.Radio.ID then
	print(key == KEY_LALT, "UP")
   		RunConsoleCommand("radio_use", "false") 
      //timer.Simple(0.05, function() RunConsoleCommand("-voicerecord") end)
   	end
end)

function GM:PlayerStartVoice( ply )
	local lp = LocalPlayer()
	if not IsValid(ply) then return end
    //if (LocalPlayer():KeyDown(IN_WALK)) and (LocalPlayer():KeyDownLast(IN_WALK)) and SWRP.Ranks:DGetPriv(self.Char.rank, 'Radio') then
	if ply:GetNWBool("is_radio") then
		surface.PlaySound(on[math.random(1, #on)])
	//	RunConsoleCommand("radio_use", "true")
	//else
		//RunConsoleCommand("radio_use", "false")
	end
	ply.Talking = true
end

function GM:PlayerEndVoice( ply )
	

	local lp = LocalPlayer()
	if not IsValid(ply) then return end
	if ply:GetNWBool("is_radio") then
		surface.PlaySound(off[math.random(1, #off)])
	//	RunConsoleCommand("radio_use", "false")
	end
	ply.Talking = nil
end

hook.Add("SWRP::PostPlayerDraw", "SWRP.Radio::PostPlayerDraw", function(ply)
	if cacheradio[ply] then
		outline.Add(ply, Color(255,150,109), OUTLINE_MODE_VISIBLE)
	end
end)