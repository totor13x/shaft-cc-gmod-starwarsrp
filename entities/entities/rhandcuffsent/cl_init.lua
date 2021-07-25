include('shared.lua')

net.Receive("rhc_sendcuffs", function()
	local Player, Cuffs = net.ReadEntity(), net.ReadEntity()
	
	Cuffs.CuffedPlayer = Player
end)

function ENT:Initialize()
	self.CSBoneMani = RHandcuffsConfig.BoneManipulateClientside
end

function ENT:Think ()	
end

function ENT:Draw()
	local owner = self.CuffedPlayer
	if owner == LocalPlayer() then return end	
	if !IsValid(owner) or !owner or !owner:IsPlayer() or !owner:Alive() then return end
	
	local boneindex = owner:LookupBone("ValveBiped.Bip01_R_Hand")
	if boneindex then
		local pos, ang = owner:GetBonePosition(boneindex)
		if pos and pos ~= owner:GetPos() then	
			ang:RotateAroundAxis(ang:Right(),20)
			ang:RotateAroundAxis(ang:Up(),140)
			ang:RotateAroundAxis(ang:Forward(), 130)
			
			self:SetModelScale(2.5,0)
			self.Entity:SetPos(pos + ang:Right()*3 - ang:Up()*137 + ang:Forward()*70)
			self.Entity:SetAngles(ang)
			/*print(owner:GetSequenceName(owner:GetSequence()))
			print("-")
			print(owner:GetSequence())*/
		end
    end	
	self.Entity:DrawModel()
end

function ENT:OnRemove( )
end	
