
-----------------------------------------------------
if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName			= "Руки"
SWEP.Author				= "Totor"
SWEP.Purpose    		= ""
SWEP.DrawWeaponInfoBox 	= false
SWEP.ViewModel			= "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= ""
SWEP.Range 				= 140
SWEP.Time				= 0

SWEP.AnimPrefix	 			= "rpg"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 	0, 	"FriskStart" )
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:OnRemove()
end

function SWEP:Think()
	if self.Drag and (not self.Owner:KeyDown(IN_ATTACK) or not IsValid(self.Drag.Entity)) then
		self.Drag = nil
	end
	if SERVER then
		if self.Owner:KeyDown(IN_ATTACK2) and !self.EnableGesture then
			//print('Enabled')
			//print(self.Owner:LookupSequence("gesture_rukizaspinoj"))
			self.EnableGesture = true
			self.Owner:EnableCustomGesture("gesture_rukipered")
		elseif !self.Owner:KeyDown(IN_ATTACK2) and self.EnableGesture then
			//print('Disabled')
			self.EnableGesture = false
			self.Owner:DisableCustomGesture()
		end
	end
end

function SWEP:Reload()
	if CLIENT then return end
	if not IsFirstTimePredicted() then return end

	self.Owner:DoAnimCustom("g_drop_meleeweapon")
end

function SWEP:SecondaryAttack()
end

--[[ Dragging ]]--
function SWEP:PrimaryAttack()
	local Pos = self.Owner:GetShootPos()
	local Aim = self.Owner:GetAimVector()
	
	local Tr = util.TraceLine{
		start = Pos,
		endpos = Pos +Aim *self.Range,
		filter = player.GetAll(),
	}
	
	local HitEnt = Tr.Entity
	if self.Drag then 
		HitEnt = self.Drag.Entity
	else
		if not IsValid( HitEnt ) or HitEnt:GetMoveType() ~= MOVETYPE_VPHYSICS or
			HitEnt:IsVehicle() or HitEnt:GetNWBool( "NoDrag", false ) or
			HitEnt.BlockDrag or
			(HitEnt:GetClass() == "prop_physics_multiplayer" and HitEnt:GetDTBool(30)) or
			IsValid( HitEnt:GetParent() ) then 
			return
		end

		if HitEnt.CanPlayerDrag and not HitEnt:CanPlayerDrag( self.Owner ) then
			return
		end
		
		
		if not self.Drag then
			self.Drag = {
				OffPos = HitEnt:WorldToLocal(Tr.HitPos),
				Entity = HitEnt,
				Fraction = Tr.Fraction,
			}
		end
	end
	
	if CLIENT or not IsValid( HitEnt ) then return end
	
	local Phys = HitEnt:GetPhysicsObject()
	if IsValid( Phys ) then
		local Pos2 = Pos +Aim *self.Range *self.Drag.Fraction
		local OffPos = HitEnt:LocalToWorld( self.Drag.OffPos )
		local Dif = Pos2 -OffPos
		local Nom = (Dif:GetNormal() *math.min(1, Dif:Length() /100) *500 -Phys:GetVelocity()) *Phys:GetMass()
		
		Phys:ApplyForceOffset( Nom, OffPos )
		Phys:AddAngleVelocity( -Phys:GetAngleVelocity() /4 )
	end
end


if CLIENT then
	local x, y = ScrW() /2, ScrH() /2
	local MainCol = Color( 255, 255, 255, 255 )
	local Col = Color( 255, 255, 255, 255 )
	local box_w = 200
	local box_h = 40

	function SWEP:DrawHUD()
		if IsValid( self.Owner:GetVehicle() ) then return end
		local Pos = self.Owner:GetShootPos()
		local Aim = self.Owner:GetAimVector()
		
		local Tr = util.TraceLine{
			start = Pos,
			endpos = Pos +Aim *self.Range,
			filter = player.GetAll(),
		}
		
		local HitEnt = Tr.Entity
		if IsValid( HitEnt ) and HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and
			not self.rDag and
			not HitEnt.BlockDrag and
			not HitEnt:IsVehicle() and
			not IsValid( HitEnt:GetParent() ) and
			not HitEnt:GetNWBool( "NoDrag", false ) and
			not (HitEnt:GetClass() == "prop_physics_multiplayer" and HitEnt:GetDTBool(30)) and
			not (HitEnt.CanPlayerDrag and not HitEnt:CanPlayerDrag(self.Owner)) and
			not HitEnt.HideDragOverlay
			then

			self.Time = math.min( 1, self.Time +2 *FrameTime() )
		else
			self.Time = math.max( 0, self.Time -2 *FrameTime() )
		end
		
		if self.Time > 0 then
			Col.a = MainCol.a *self.Time


		end
		
		if self.Drag and IsValid( self.Drag.Entity ) then
			local Pos2 = Pos +Aim *100 *self.Drag.Fraction
			local OffPos = self.Drag.Entity:LocalToWorld( self.Drag.OffPos )
			local Dif = Pos2 -OffPos
			
			local A = OffPos:ToScreen()
			local B = Pos2:ToScreen()
			
			surface.DrawRect( A.x -2, A.y -2, 4, 4, MainCol )
			surface.DrawRect( B.x -2, B.y -2, 4, 4, MainCol )
			surface.DrawLine( A.x, A.y, B.x, B.y, MainCol )
		end
	end
end

function SWEP:PreDrawViewModel( vm, pl, wep )
	return true
end