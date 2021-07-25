--[[---------------------------------------------------------
   Name: gamemode:UpdateAnimation()
   Desc: Animation updates (pose params etc) should be done here
-----------------------------------------------------------]]
function GM:CustomAnimation( ply )
	ply.CustomGestureWeight = ply.CustomGestureWeight || 0

	if ply:IsGestured() then
		ply.CustomGestureWeight = math.Approach( ply.CustomGestureWeight, 1, FrameTime() * 5.0 )
	else
		ply.CustomGestureWeight = math.Approach( ply.CustomGestureWeight, 0, FrameTime() * 5.0 )
	end

	if ( ply.CustomGestureWeight > 0 ) then
		local gest = ply:LookupSequence(ply:GetNWString("SWRP.Anim.Gestured::Animation"))
		ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, gest, 0, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, ply.CustomGestureWeight )
	end
end
--
-- If you don't want the player to grab his ear in your gamemode then
-- just override this.
--
function GM:GrabEarAnimation( ply )

	ply.ChatGestureWeight = ply.ChatGestureWeight || 0

	-- Don't show this when we're playing a taunt!
	if ( ply:IsPlayingTaunt() ) then return end
	if ( ply:IsGestured() ) then return end

	if ( ply:IsTyping() ) then
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 1, FrameTime() * 5.0 )
	else
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 0, FrameTime() * 5.0 )
	end

	if ( ply.ChatGestureWeight > 0 ) then

		ply:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, ply.ChatGestureWeight )

	end

end

--
-- Moves the mouth when talking on voicecom
--
function GM:MouthMoveAnimation( ply )

	local flexes = {
		ply:GetFlexIDByName( "jaw_drop" ),
		ply:GetFlexIDByName( "left_part" ),
		ply:GetFlexIDByName( "right_part" ),
		ply:GetFlexIDByName( "left_mouth_drop" ),
		ply:GetFlexIDByName( "right_mouth_drop" )
	}

	local weight = ply:IsSpeaking() && math.Clamp( ply:VoiceVolume() * 2, 0, 2 ) || 0

	for k, v in pairs( flexes ) do
		ply:SetFlexWeight( v, weight )
	end
end

hook.Add("CalcMainActivity", "SWRP.CalculateAnimations", function( ply, velocity )
	local calcIdeal, CalcSeqOverride = hook.Run("SWRP::CalcMainActivity", ply, velocity)
	if calcIdeal then
		return calcIdeal, CalcSeqOverride
	else
		ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1

		self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround )
		if ( self:HandlePlayerNoClipping( ply, velocity ) ||
			self:HandlePlayerDriving( ply ) ||
			self:HandlePlayerVaulting( ply, velocity ) ||
			self:HandlePlayerJumping( ply, velocity ) ||
			self:HandlePlayerSwimming( ply, velocity ) ||
			self:HandlePlayerDucking( ply, velocity ) ) then
		else
			local len2d = velocity:Length2DSqr()
			//print(len2d, ply:GetRole(JEDI))
			if ( !ply:GetRole(JEDI) && len2d > 90000 ) then 
				ply.CalcIdeal = ACT_HL2MP_RUN_FAST
			elseif ( len2d > 20000 ) then 
				ply.CalcIdeal = ACT_MP_RUN
			elseif ( len2d > 0.25 ) then 
				ply.CalcIdeal = ACT_MP_WALK 
			end
		end

		ply.m_bWasOnGround = ply:IsOnGround()
		ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )

		return ply.CalcIdeal, ply.CalcSeqOverride
	end
end)

local meta = FindMetaTable('Player')
function meta:IsGestured()
    return self:GetNWBool("SWRP.Anim.Gestured::Enabled") 
end

function meta:DoAnim(animID)
    self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, animID, true)
end
netstreamSWRP.Hook('SWRP::DoAnim', function(ply, animID)
	if IsValid(ply) then
	    ply:DoAnim(animID)
	end
end)
function meta:DoAnimCustom(animID)
	local gest = self:LookupSequence( animID )
	self:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, gest, 0, true )
end
netstreamSWRP.Hook('SWRP::DoAnimCustom', function(ply, animID)
	if IsValid(ply) then
	    ply:DoAnimCustom(animID)
	end
end)

