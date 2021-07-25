GUI3D = GUI3D or {}
function GUI3D:GetMeshPos()
	local angles = LocalPlayer():EyeAngles()
	
	local vehicle = LocalPlayer():GetVehicle()
	
	if IsValid(vehicle) then
		//angles = vehicle:LocalToWorldAngles(angles)
	end
	
	local pos = EyePos() + angles:Forward() * (self.config.OffsetAlways + self.config.AdditionalOffset)
	
	return pos
end

local function sign(x)
	if x < 0 then
		return -1
	elseif x > 0 then
		return 1
	else
		return 0
	end
end

local function ClampABS(a, b)
	if math.abs(a) < b then
		return b * sign(a)
	else
		return a
	end
end

function GUI3D:ApproachAngles(a, b, SpeedP, SpeedY, min)
	return Angle(
		math.ApproachAngle(a.p, b.p, ClampABS(math.AngleDifference(a.p, b.p), min) * SpeedP * FrameTime()),
		math.ApproachAngle(a.y, b.y, ClampABS(math.AngleDifference(a.y, b.y), min) * SpeedY * FrameTime()),
		a.r
	)
end

local CurAngle
local OldAngle
local LastChanged

function GUI3D:GetMeshAngle()
	local angle
	
	if GUI3D.config.CalcViewAngle then
		angle = EyeAngles()
	else
		angle = LocalPlayer():EyeAngles()
	end
	
	if GUI3D.BarrelRoll then
		angle.r = math.sin((CurTime() - GUI3D.BarrelRoll) / 2) * 360
		
		if GUI3D.OldRoll and angle.r < GUI3D.OldRoll then
			GUI3D.BarrelRoll = nil
			GUI3D.OldRoll = nil
		end
		
		if GUI3D.BarrelRoll then
			GUI3D.OldRoll = angle.r
		end
	elseif GUI3D.config.Rotating then
		angle.r = math.sin(CurTime() * 2) * 360
	elseif GUI3D.config.Shaking then
		angle.r = math.sin(CurTime() * 2) * 8
	end
	
	if GUI3D.config.ApproachAngles then
		local frame = FrameNumber()
		
		local speed = GUI3D.config.ApproachAnglesSpeed
		
		if LastChanged then
			if LastChanged != frame then
				OldAngle = CurAngle
				CurAngle = self:ApproachAngles(OldAngle, angle, speed, speed * ScrH() / ScrW(), 0)
				LastChanged = frame
			end
		else
			CurAngle = angle
			OldAngle = angle
			LastChanged = frame
		end
		
		return CurAngle
	else
		return angle
	end
end

function GUI3D:FromMeshLocalToWorld(pos)
	pos = Vector(pos) //Copy from reference
	
	pos:Rotate(self:GetMeshAngle())
	pos = pos + self:GetMeshPos()
	
	return pos
end

hook.Add("PreDrawTranslucentRenderables", "GUI3D_FixEyeFuncs", function()
	EyePos()
	EyeAngles()
end)

local AngleOffset

function GUI3D:CalcView(origin, angles, fov)
	if GUI3D.config.Enabled and GUI3D.config.LookAtCursor and GUI3D:IsWindowHovered() then
		local view = {}
		view.origin = origin
		view.fov = fov
		
		local speed = GUI3D.config.LookingAtCursorSpeed
		
		if true then
			angles:Normalize()
			
			local x, y = gui.MousePos()
			local goal = GUI3D.OldAimVector(angles, LocalPlayer():GetFOV(), x, y, ScrW(), ScrH()):Angle()
			goal:Normalize()
			
			local MaxYaw = GUI3D.config.MaxLookAtCursorAngle
			local MaxPitch = MaxYaw * ScrH() / ScrW() * 1.3
			
			local DifferenceP = math.AngleDifference(goal.p, angles.p)
			if math.abs(DifferenceP) > MaxPitch then
				goal.p = angles.p + MaxPitch * GUI3D:Sign(DifferenceP)
			end
			
			local DifferenceY = math.AngleDifference(goal.y, angles.y)
			if math.abs(DifferenceY) > MaxYaw then
				goal.y = angles.y + MaxYaw * GUI3D:Sign(DifferenceY)
			end
			
			local FinalAngle = GUI3D:ApproachAngles(angles + (AngleOffset or Angle(0, 0, 0)), goal, speed, speed, 0.5)
			
			view.angles = FinalAngle
			AngleOffset = FinalAngle - angles
		else
			if AngleOffset then
				speed = speed * 5
				local FinalAngle = GUI3D:ApproachAngles(angles + AngleOffset, angles, speed, speed, 2)
				view.angles = FinalAngle
				
				if FinalAngle == angles then
					AngleOffset = nil
				else
					AngleOffset = FinalAngle - angles
				end
			else
				view.angles = angles
			end
		end
		
		return view
	end
end

function GUI3D:CalcViewModelView(pos, ang)
	if GUI3D.config.Enabled and AngleOffset then
		ang = ang + AngleOffset
		
		return pos, ang
	end
end

hook.Add("InitPostEntity", "hud_replaceswep", function()
	local function ModifyCalcView(func)
		return function(...)
			local ret = func(...)
			
			if ret then
				local origin = ret.origin or EyePos()
				local angles = ret.angles or EyeAngles()
				local fov = ret.fov or LocalPlayer():GetFOV()
				
				local modified = GUI3D:CalcView(origin, angles, fov)
				
				if modified then
					ret.origin = modified.origin or ret.origin
					ret.angles = modified.angles or ret.angles
					ret.fov = modified.fov or ret.fov
				end
				
				return ret
			end
		end
	end
	
	local function ModifyCalcViewModelView(func)
		return function(wep, vm, oldPos, oldAng, pos, ang, ...)
			local rpos, rang = func(wep, vm, oldPos, oldAng, pos, ang, ...)
			
			if rpos and rang then
				local mrpos, mrang = GUI3D:CalcViewModelView(rpos, rang)
				
				return (mrpos or rpos), (mrang or rang)
			end
		end
	end
	
	GAMEMODE["SWRP::CalcViewEyes"] = ModifyCalcView(GAMEMODE["CalcViewEyes"] or function() end)
	//GAMEMODE["CalcViewModelView"] = ModifyCalcViewModelView(GAMEMODE["CalcViewModelView"] or function() end)
end)

