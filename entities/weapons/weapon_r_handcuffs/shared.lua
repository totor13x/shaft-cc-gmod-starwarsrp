if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Handcuffs"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "ToBadForYou"
SWEP.Instructions = "Left Click: Restrain/Release. \nRight Click: Force Players out of vehicle. \nReload: Inspect."
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.HoldType = "pistol";
SWEP.ViewModel = "models/swrphandcuffs/swrphandcuffs.mdl";
SWEP.WorldModel = "models/swrphandcuffs/swrphandcuffs.mdl";
SWEP.UseHands = false

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "melee"
SWEP.Category = "ToBadForYou"
SWEP.UID = 76561198208634281

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

local LangTbl = RHandcuffsConfig.Language[RHandcuffsConfig.LanguageToUse]

function SWEP:Initialize() self:SetWeaponHoldType("pistol") end
function SWEP:CanPrimaryAttack ( ) return true; end

function SWEP:PlayCuffSound(Time)
	timer.Simple(Time, function() if IsValid(self) then self:EmitSound(RHandcuffsConfig.CuffSound) end end)
	timer.Simple(Time+1, function() if IsValid(self) then self:EmitSound(RHandcuffsConfig.CuffSound) end end)
end
if CLIENT then
	SWEP.Pos = Vector( 9.49, 2, -9.371 )
	SWEP.Ang = Vector( 12, 65, -22.19 )
	function SWEP:GetViewModelPosition( EyePos, EyeAng )
		local Mul = 1.0

		local Offset = self.Pos

		if ( self.Ang ) then
			EyeAng = EyeAng * 1

			EyeAng:RotateAroundAxis( EyeAng:Right(), 	self.Ang.x * Mul )
			EyeAng:RotateAroundAxis( EyeAng:Up(), 		self.Ang.y * Mul )
			EyeAng:RotateAroundAxis( EyeAng:Forward(),	self.Ang.z * Mul )
		end

		local Right 	= EyeAng:Right()
		local Up 		= EyeAng:Up()
		local Forward 	= EyeAng:Forward()

		EyePos = EyePos + Offset.x * Right * Mul
		EyePos = EyePos + Offset.y * Forward * Mul
		EyePos = EyePos + Offset.z * Up * Mul

		return EyePos, EyeAng
	end
	local WorldModel = ClientsideModel( SWEP.WorldModel )

	-- Settings...
	WorldModel:SetSkin( 1 )
	WorldModel:SetNoDraw( true )

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if ( IsValid( _Owner ) ) then
			-- Specify a good position
			local offsetVec = Vector( 12, 119, -5 )
			local offsetAng = Angle( 20, 25, 100 )

			local boneid = _Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ) -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix( boneid )
			if !matrix then return end

			local newPos, newAng = LocalToWorld( offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles() )

			WorldModel:SetPos( newPos )
			WorldModel:SetAngles( newAng )

			WorldModel:SetupBones()
		else
			WorldModel:SetPos( self:GetPos() )
			WorldModel:SetAngles( self:GetAngles() )
		end
		WorldModel:SetModelScale(2,0)
		WorldModel:DrawModel()
	end
end

function SWEP:Think()
	local PlayerToCuff = self.AttemptToCuff
	if IsValid(PlayerToCuff) then
		local vm = self.Owner:GetViewModel();
		local ResetSeq, Time1 = vm:LookupSequence("Reset")
		
		if self.CuffingRagdoll then
			if PlayerToCuff:GetPos():Distance(self.Owner:GetPos()) > 400 then
				PlayerToCuff = nil
				vm:SendViewModelMatchingSequence(ResetSeq)	
				vm:SetPlaybackRate(2)	
			elseif CurTime() >= self.AttemptCuffFinish then
				if SERVER then
					PlayerToCuff.tazeplayer.LastRHCCuffed = self.Owner
					PlayerToCuff.tazeplayer.TazedRHCRestrained = true
				end
				PlayerToCuff.RagdollCuffed = true
				self.AttemptToCuff = nil
				vm:SendViewModelMatchingSequence(ResetSeq)	
				vm:SetPlaybackRate(2)		
			end
		else
			local TraceEnt = self.Owner:GetEyeTrace().Entity
			if !IsValid(TraceEnt) or TraceEnt != PlayerToCuff or TraceEnt:GetPos():Distance(self.Owner:GetPos()) > RHandcuffsConfig.CuffRange then
				self.AttemptToCuff = nil
				vm:SendViewModelMatchingSequence(ResetSeq)	
				vm:SetPlaybackRate(2)	
			elseif CurTime() >= self.AttemptCuffFinish then
				if SERVER then
					PlayerToCuff:RHCRestrain(self.Owner)
				end
				self.AttemptToCuff = nil	
				vm:SendViewModelMatchingSequence(ResetSeq)	
				vm:SetPlaybackRate(2)
			end	
		end	
	end
end

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav")
	//self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:DoAnim(ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND)

	local Trace = self.Owner:GetEyeTrace()
		
	self.Weapon:SetNextPrimaryFire(CurTime() + 3)
		
	local TPlayer = Trace.Entity
	if !IsValid(TPlayer) then return false end
	local Distance = self.Owner:EyePos():Distance(TPlayer:GetPos());
	if Distance > 400 then return false; end
	if TPlayer:GetNWBool("rks_restrained", false) then
		if SERVER then
			DarkRP.notify(self.Owner, 1, 4, LangTbl.CantCuffRestrained)
		end
		return
	end	
	if TPlayer:IsPlayer() and !TPlayer:IsRHCWhitelisted() and !IsValid(self.AttemptToCuff) then
		if TPlayer:GetNWBool("rhc_cuffed", false) then
			if SERVER then
				TPlayer:RHCRestrain(self.Owner)
			end
		else
			self.CuffingRagdoll = false
			self.AttemptToCuff = TPlayer
			self.AttemptCuffFinish = CurTime() + RHandcuffsConfig.CuffTime
			self.AttemptCuffStart = CurTime()
			local vm = self.Owner:GetViewModel();
			local DeploySeq, Time = vm:LookupSequence("Deploy")
	
			vm:SendViewModelMatchingSequence(DeploySeq)	
			vm:SetPlaybackRate(2)
			self:PlayCuffSound(.3)
		end
	elseif !TPlayer.RagdollCuffed and TPlayer:GetNWBool("CanRHCArrest", false) then
		self.CuffingRagdoll = true
		self.AttemptToCuff = TPlayer
		self.AttemptCuffFinish = CurTime() + RHandcuffsConfig.CuffTime
		self.AttemptCuffStart = CurTime()
		local vm = self.Owner:GetViewModel();
		local DeploySeq, Time = vm:LookupSequence("Deploy")
	
		vm:SendViewModelMatchingSequence(DeploySeq)	
		vm:SetPlaybackRate(2)
		self:PlayCuffSound(.3)
	end
end

function SWEP:Reload()
	if self.NextRPress and self.NextRPress > CurTime() then return end
	self.NextRPress = CurTime() + 1
	if CLIENT then return end
	
	if !self.Owner:IsRHCWhitelisted() then return end
	
	local Trace = self.Owner:GetEyeTrace()
		
	self.Weapon:SetNextPrimaryFire(CurTime() + 3)
		
	local TPlayer = Trace.Entity
	local Distance = self.Owner:EyePos():Distance(TPlayer:GetPos());
	if Distance > 100 then return false; end	
	
	if TPlayer.Restrained then	
		self.Owner:RHCInspect(TPlayer)
	end
end	

function SWEP:SecondaryAttack()
	if SERVER then 
		self.Weapon:SetNextSecondaryFire(CurTime() + 1)
		local Player = self.Owner
		local Trace = Player:GetEyeTrace()
	
		local TVehicle = Trace.Entity
		local Distance = Player:GetPos():Distance(TVehicle:GetPos());
		if Distance > 300 then return false; end	
		if IsValid(TVehicle) and TVehicle:IsVehicle() then
			if vcmod1 then 
				if !Player.Dragging then
					for k,v in pairs(TVehicle:VC_GetPlayers()) do
						if v.Restrained then 
							local DraggedByP = v.DraggedBy
							if IsValid(DraggedByP) then
								DraggedByP.Dragging = nil
							end
							v.DraggedBy = nil
							v:ExitVehicle()
						end
					end
				elseif Player.Dragging then
					local PlayerDragged = Player.Dragging
					if IsValid(PlayerDragged) then
						local SeatsTBL = TVehicle:VC_GetSeatsAvailable()
						if #SeatsTBL < 1 then DarkRP.notify(Player, 1, 4, LangTbl.NoSeats) if !IsValid(TVehicle:GetDriver()) then PlayerDragged:EnterVehicle(TVehicle) DarkRP.notify(Player, 1, 4, LangTbl.PlayerPutInDriver) end return end
						for k,v in pairs(SeatsTBL) do
							local SeatsDist = Player:GetPos():Distance(v:GetPos())
							if SeatsDist < 80 then
								PlayerDragged:EnterVehicle(v)
								break
							end
						end
					end				
				end
			elseif NOVA_Config then
				if !Player.Dragging then
					local Passengers = TVehicle:CMGetAllPassengers()
					for k,v in pairs(Passengers) do
						if v and v:IsPlayer() and v.Restrained then
							local DraggedByP = v.DraggedBy
							if IsValid(DraggedByP) then
								DraggedByP.Dragging = nil
							end
							v.DraggedBy = nil
							v:ExitVehicle()	
						end	
					end
				elseif Player.Dragging then
					local PlayerDragged = Player.Dragging
					if IsValid(PlayerDragged) then
						local SeatsTBL = table.Copy(TVehicle.CmodSeats)
						for k,v in pairs(SeatsTBL) do
							local Driver = v:GetDriver()
							if IsValid(Driver) and Driver:IsPlayer() then
								SeatsTBL[k] = nil
							end
						end
						if table.Count(SeatsTBL) < 1 then DarkRP.notify(Player, 1, 4, LangTbl.NoSeats) if !IsValid(TVehicle:GetDriver()) then PlayerDragged:EnterVehicle(TVehicle) DarkRP.notify(Player, 1, 4, LangTbl.PlayerPutInDriver) end return end
						for k,v in pairs(SeatsTBL) do
							local SeatsDist = Player:GetPos():Distance(v:GetPos())
							if SeatsDist < 80 then
								PlayerDragged:EnterVehicle(v)
								break
							end
						end
					end				
				end
			elseif TVehicle.Seats then
				if !Player.Dragging then
					local Seats = TVehicle.Seats
					for k,v in pairs(Seats) do
						local Passenger = v:GetDriver()
						if IsValid(Passenger) and Passenger.Restrained then
							local DraggedByP = Passenger.DraggedBy
							if IsValid(DraggedByP) then
								DraggedByP.Dragging = nil
							end
							Passenger.DraggedBy = nil
							Passenger:ExitVehicle()	
						end	
					end				
				elseif Player.Dragging then
					local PlayerDragged = Player.Dragging
					if IsValid(PlayerDragged) then
						local SeatsTBL = TVehicle.Seats
						SeatsTBL[1] = nil
						for k,v in pairs(SeatsTBL) do
							local Driver = v:GetDriver()
							if IsValid(Driver) and Driver:IsPlayer() then
								SeatsTBL[k] = nil
							end
						end
						if #SeatsTBL < 1 then DarkRP.notify(Player, 1, 4, LangTbl.NoSeats) return end
						for k,v in pairs(SeatsTBL) do
							local SeatsDist = Player:GetPos():Distance(v:GetPos())
							if SeatsDist < 150 then
								PlayerDragged:EnterVehicle(v)
								break
							end
						end
					end					
				end	
			elseif Player.Dragging and !vcmod1 then
				local DragPlayer = Player.Dragging
				if IsValid(DragPlayer) then
					DragPlayer:EnterVehicle(TVehicle)
				end	
			elseif IsValid(TVehicle:GetDriver()) and TVehicle:GetDriver().Restrained then
				TVehicle:GetDriver():ExitVehicle()				
			end	
		end
	end			
end

if CLIENT then

	local flat = Material("vgui/white.vtf")
	local sin,cos,rad = math.sin,math.cos,math.rad --it slightly increases the speed.
	local HUDAlpha = 245
	local CirclePasses = 100
	local PortraitScale = ScrW() / 14
	local CircleMargin = 0
	local HealthCircleMargin = 7
	local HealthCircleWidth = 20
	local PortraitPos = Vector(PortraitScale + 20 , ScrH() - PortraitScale - CircleMargin )
	
	function SWEP:DrawHUD()
		local PlayerToCuff = self.AttemptToCuff
		if !IsValid(PlayerToCuff) then return end

		local time = self.AttemptCuffFinish - self.AttemptCuffStart
		local curtime = CurTime() - self.AttemptCuffStart
		local percent = math.Clamp(curtime / time, 0, 1)	
		local w = ScrW()
		local h = ScrH()
		local Nick = ""
		if self.CuffingRagdoll then
			Nick = LangTbl.TazedPlayer
		else 
			Nick = PlayerToCuff:Nick()
		end

		local TPercent = math.Round(percent*100)
		local TextToDisplay = string.format(LangTbl.CuffingText, Nick)
		//draw.DrawText(TextToDisplay .. " (" .. TPercent .. "%)", "Trebuchet24", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
		SWRP:ChangeCProgress(TPercent)
		//SWRP.CursorProgress = TPercent
		/*


    	surface.SetMaterial(flat)
        surface.SetDrawColor( 230, 13, 46, 255 )
		for a = 0, math.Clamp( TPercent / (100/CirclePasses), 0, CirclePasses - 1 ) do
			surface.DrawTexturedRectRotated( 
				PortraitPos.x - cos( rad( -a * 360/CirclePasses -90 ) ) * (PortraitScale - HealthCircleWidth/2 - HealthCircleMargin), 
				PortraitPos.y + sin( rad( -a * 360/CirclePasses -90 ) ) * (PortraitScale - HealthCircleWidth/2 - HealthCircleMargin), 
				HealthCircleWidth, 
				12 - sin( rad(360/CirclePasses) ) * HealthCircleWidth * 2, 
				-a * 360/CirclePasses -90
			)
		end
		/*

		local numSquares = 36 --How many squares do we want to draw?
		local interval = 360 / numSquares
		local centerX, centerY = 200, 500
		local radius = 120

		for degrees = 1, 360, interval do --Start at 1, go to 360, and skip forward at even intervals.

			local x, y = PointOnCircle( degrees, radius, centerX, centerY )

			//draw.RoundedBox( 4, x, y, 30, 30, Color( 255, 255, 0 ) )

		end
*/
	end
end