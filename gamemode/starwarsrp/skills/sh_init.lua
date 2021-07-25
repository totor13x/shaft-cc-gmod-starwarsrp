GM.Needs = (GAMEMODE or GM).Needs or {}
GM.Needs.Config = {
	SpeedShiftMultipler = 1, // Множитель скорости ускорения | в плюс
	SpeedDuckMultipler = 1, // Множитель скорости приседания | в минус
	StaminaReduce = 0.1, // Множитель восстановления стамины | в плюс
	StaminaSpeed = 0.2, // Множитель поедания скорости | в минус
	StaminaDuck = 1, // Приседания | в минус
	StaminaJump = 1, // Прыжок | в минус
}

SWRP.StaminaNeeds = SWRP.StaminaNeeds || {}
SWRP.StaminaNeeds.Duck = 20
SWRP.StaminaNeeds.Jump = 30
local defaultduck = 20
local defaultjump = 30

if SERVER then
	function GM.Needs:ChangePlayerStamina( ply, value, changetime )  
		changetime = changetime == nil and true
		if changetime then
			ply.m_tblNeeds.StaminaTime = CurTime()
		end
		ply.m_tblNeeds.Stamina = ply.m_tblNeeds.Stamina + value
		if ply.m_tblNeeds.Stamina <= 0 then
			ply.m_tblNeeds.Stamina = 0
		end
		if ply.m_tblNeeds.Stamina >= 100 then
			ply.m_tblNeeds.Stamina = 100
		end
		ply:SetNWInt("Needs.Stamina", ply.m_tblNeeds.Stamina)
	end
	function GM.Needs:TickPlayerStamina()
		local velL
		for k, v in pairs( player.GetAll() ) do
			if not v:Alive() or v:InVehicle() then continue end
			
			velL = v:GetVelocity():Length()
			v.m_tblNeeds = v.m_tblNeeds or {}
			v.m_tblNeeds.StaminaTime = v.m_tblNeeds.StaminaTime or CurTime()
			v.m_tblNeeds.Stamina = v.m_tblNeeds.Stamina or 0

			if v:KeyDown( IN_SPEED ) then
				if velL > 45 and v.m_tblNeeds.Stamina > 0 && !v:GetRole(JEDI) then
					GAMEMODE.Needs:ChangePlayerStamina( v, -(1 * v:GetCharacterSkills("StaminaSpeed"))) 
				end
			end
			
			if v.m_tblNeeds.StaminaTime + 1 < CurTime() and v.m_tblNeeds.Stamina <= 100 then
				GAMEMODE.Needs:ChangePlayerStamina( v, (1 * (v:GetCharacterSkills("StaminaReduce"))), false )
			end

			
		end
	end
	hook.Add("Tick", "Player.Stamina", GM.Needs.TickPlayerStamina)
	function GM.Needs:JumpCrouchStamina( key )
		if !IsFirstTimePredicted() then return end
			if not self:Alive() or self:InVehicle() then return end
			self.m_tblNeeds = self.m_tblNeeds or {}
			self.m_tblNeeds.lastDuckTrue = false
			self.m_tblNeeds.lastJumpTrue = false
			local duck = SWRP.StaminaNeeds.Duck * self:GetCharacterSkills("StaminaDuck")
			if key == IN_DUCK and self.m_tblNeeds.Stamina >= duck then
				self.m_tblNeeds.lastDuckTrue = true
				GAMEMODE.Needs:ChangePlayerStamina( self, -duck )
			end
			local jump = SWRP.StaminaNeeds.Jump * self:GetCharacterSkills("StaminaJump")
			if key == IN_JUMP and self:IsOnGround() and self.m_tblNeeds.Stamina >= jump  then
				self.m_tblNeeds.lastJumpTrue = true
				GAMEMODE.Needs:ChangePlayerStamina( self, -jump )
			end
	end
	hook.Add("KeyPress", "Player.JumpCrouchStamina", GM.Needs.JumpCrouchStamina)

	local ba, bn = bit.band, bit.bnot
	function GM.Needs:JumpCrouchStaminaFix( cmd )
		if not self:Alive() or self:InVehicle() then return end
		local ButtonData = cmd:GetButtons()
		self.m_tblNeeds = self.m_tblNeeds or {}
		
		if ba( ButtonData, IN_DUCK ) > 0 and !self.m_tblNeeds.lastDuckTrue and !self:Crouching() then
			cmd:SetButtons( ba( ButtonData, bn( IN_DUCK ) ) )
		end
		if ba( ButtonData, IN_JUMP ) > 0 and !self.m_tblNeeds.lastJumpTrue then
			cmd:SetButtons( ba( ButtonData, bn( IN_JUMP ) ) )
		end
	end
	hook.Add("SetupMove", "Player.JumpCrouchStaminaFix", GM.Needs.JumpCrouchStaminaFix)

	local allowholdtype_torun = {
		pistol = true,
		grenade = true,
		melee = true,
		normal = true,
		fist = true,
		//passive = true,
		knife = true,
		duel = true,
		camera = true,
		magic = true,
		revolver = true,
	}

	local last = CurTime()
	function GM.Needs.TickPlayerChangeModifiers()
		if last + 0.4 > CurTime() then return end
		
		last = CurTime()
		
		for k, v in pairs( player.GetAll() ) do
			if not v:Alive() or v:InVehicle() then continue end
			if not v.Char then continue end
			if not v.m_tblNeeds.Stamina then continue end
			local x = 200*v:GetCharacterSkills("SpeedMultipler")
			v.m_tblNeeds = v.m_tblNeeds or {}

			local hold = v.GetActiveWeapon and v:GetActiveWeapon() and v:GetActiveWeapon().GetHoldType and v:GetActiveWeapon():GetHoldType() or false
			local speed = (200+(SWRP.maxWalkSpeed+5))-(200-(v.m_tblNeeds.Stamina*(v:GetCharacterSkills("SpeedShiftMultipler")*2)))
			if hold and !allowholdtype_torun[hold] then
				speed = math.Clamp( speed, 0, 200+(SWRP.maxWalkSpeed+5) )
			end
			if (v:GetRole(JEDI) && v.LightsaberEnabled) then
				v:SetWalkSpeed(speed)
				v:SetRunSpeed(speed)
				v:SetMaxSpeed(speed)
			else
				v:SetWalkSpeed(SWRP.maxWalkSpeed)
				v:SetRunSpeed(speed)
				v:SetMaxSpeed(speed)
			end
				v:SetDuckSpeed( 1 - (v.m_tblNeeds.Stamina/333)*(v:GetCharacterSkills("SpeedDuckMultipler")*2) )
				v:SetUnDuckSpeed( 1 - (v.m_tblNeeds.Stamina/333)*(2*v:GetCharacterSkills("SpeedDuckMultipler")*2) )
				v:SetJumpPower(230-(100-v.m_tblNeeds.Stamina))

			//print(x,(200+50)-(200-(v.m_tblNeeds.Stamina*(v:GetCharacterSkills("SpeedMultipler")*2))))yy
			//print(v.m_tblNeeds.Stamina)
			//if (v:GetRole(JEDI)) then
				//print((200+50)-(200-(v.m_tblNeeds.Stamina*(v:GetCharacterSkills("SpeedShiftMultipler")*2))))
			/*
			else
				if (v.LightsaberEnabled) then
					v:SetWalkSpeed( (200+50)-(200-(v.m_tblNeeds.Stamina*(v:GetCharacterSkills("SpeedShiftMultipler")*2))) )
					v:SetRunSpeed( (300+250)-(300-(v.m_tblNeeds.Stamina*(v:GetCharacterSkills("SpeedShiftMultipler")*3))) )
				else
					v:SetWalkSpeed( math.max(SWRP.maxWalkSpeed, 45) )
					v:SetRunSpeed((200+50)-(200-(v.m_tblNeeds.Stamina*(v:GetCharacterSkills("SpeedShiftMultipler")*2))))
				end
				v:SetDuckSpeed( 1 - (v.m_tblNeeds.Stamina/333)*(v:GetCharacterSkills("SpeedDuckMultipler")*2) )
				v:SetUnDuckSpeed( 1 - (v.m_tblNeeds.Stamina/333)*(2*v:GetCharacterSkills("SpeedDuckMultipler")*2) )
				v:SetJumpPower(230-(100-v.m_tblNeeds.Stamina))
			//end
			*/
			//print(v:GetJumpPower())
		end
	end
	hook.Add("Tick", "Player.ModifiersStamina", GM.Needs.TickPlayerChangeModifiers)
end


hook.Add('StartCommand', 'Blocked.Walk', function(ply, cmd)
    cmd:RemoveKey(IN_WALK)
end)