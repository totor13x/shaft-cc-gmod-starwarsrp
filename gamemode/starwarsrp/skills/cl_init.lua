function GM:GetCharacterSkills(id)
	if self.Char and self.Char.skills and self.Char.skills[id] then
		return self.Char.skills[id]
	end
	return self and self.Needs and self.Needs.Config[id] or 1
end

hook.Add('StartCommand', 'stamina.block', function(ply, cmd)

    /*
    if cmd:KeyDown(IN_WALK) then
        local fwd = cmd:GetForwardMove()
        local side = cmd:GetSideMove()
        if fwd < 0 or (fwd == 0 and side ~= 0) then
            cmd:RemoveKey(IN_SPEED)
            cmd:RemoveKey(IN_WALK)
        end
    end
    */
    local duck = SWRP.StaminaNeeds.Duck * GAMEMODE:GetCharacterSkills("StaminaDuck")
    if cmd:KeyDown(IN_DUCK) && ply:GetNWInt("Needs.Stamina") < duck then
        cmd:RemoveKey(IN_DUCK)
    end
    local jump = SWRP.StaminaNeeds.Jump * GAMEMODE:GetCharacterSkills("StaminaJump")
    if cmd:KeyDown(IN_JUMP) && ply:GetNWInt("Needs.Stamina") < jump then
        cmd:RemoveKey(IN_JUMP)
    end
    /*
    local jump = SWRP.StaminaNeeds.Jump * self:GetCharacterSkills("StaminaJump")
    if key == IN_JUMP and self:IsOnGround() and self.m_tblNeeds.Stamina >= jump  then
        self.m_tblNeeds.lastJumpTrue = true
        GAMEMODE.Needs:ChangePlayerStamina( self, -jump )
    end
    if cmd:KeyDown(IN_JUMP) then
        if ply:GetJumpPower() == 0 and not ply:InVehicle() then
            cmd:RemoveKey(IN_JUMP)
        end
    end

    if cmd:KeyDown(IN_DUCK) then
		if key == IN_DUCK and self.m_tblNeeds.Stamina >= duck then
        
    */
end)

