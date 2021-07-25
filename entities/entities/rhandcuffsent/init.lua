AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/swrphandcuffs/swrphandcuffs.mdl")	
	self.Entity:PhysicsInit( SOLID_NONE )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetUseType( SIMPLE_USE )
	self.Entity:DrawShadow( false ) 
end

function ENT:Use( activator, caller )
end

function ENT:Touch(TouchEnt)
    if self.Entity.Touched and self.Entity.Touched > CurTime() then return ; end
	self.Entity.Touched = CurTime() + 1;
end