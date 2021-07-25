SWEP.Base = "weapon_base"

SWEP.HoldType = "slam"
SWEP.PrintName = "Фонарь"
SWEP.EnabledFlashlight = false

SWEP.ViewModel = "models/weapons/custom/v_defib.mdl"
SWEP.WorldModel = "models/maxofs2d/lamp_flashlight.mdl"

netstreamSWRP.Hook("Flashlight.Enable", function(wep, enable)
    if (enable) then
        wep:OnFlashlight()
    else
        wep:OffFlashlight()
    end
end)
function SWEP:OnFlashlight()
    if (!IsValid(self.Flashlight)) then    
        local lamp = ProjectedTexture()

        lamp:SetTexture( "effects/flashlight001" )
        lamp:SetFarZ( 1000 ) 

        lamp:SetPos( self.Pos )
        lamp:SetAngles( self.Ang )
        lamp:Update()
        self.Flashlight = lamp
    end
end

function SWEP:OffFlashlight()
    if (IsValid(self.Flashlight)) then
        self.Flashlight:Remove()
        self.Flashlight = nil
        return
    end
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    if !IsFirstTimePredicted() then return end
    if !self.EnabledFlashlight then
        self.EnabledFlashlight = true
        netstreamSWRP.Start(_, "Flashlight.Enable", self, true)
    else
        self.EnabledFlashlight = false
        netstreamSWRP.Start(_, "Flashlight.Enable", self, false)
    end
end
function SWEP:SecondaryAttack()
end
function SWEP:Reload()
end
function SWEP:Holster()
    if SERVER then
        if self.EnabledFlashlight then
            self.EnabledFlashlight = false
            netstreamSWRP.Start(_, "Flashlight.Enable", self, false)
        end
    end
    return true
end

function SWEP:Think()
    self.Pos, self.Ang = self.Pos or Vector(), self.Ang or Angle()
    if IsValid(self.Flashlight) then
        self.Flashlight:SetPos(self.Pos + self.Ang:Forward() * 15 + self.Ang:Right() * 1)
        self.Flashlight:SetAngles(self.Ang)
        self.Flashlight:Update()
    end
end

function SWEP:DrawWorldModel()
	if IsValid( self.Owner ) then   
		local iBone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if(iBone) then
            self.Pos, self.Ang = self.Owner:GetBonePosition(iBone)
            self:SetRenderOrigin(self.Pos + self.Ang:Forward() * 6 + self.Ang:Right() * 1)
            self:SetRenderAngles(self.Ang)
            local Mat = Matrix()
            Mat:Scale(Vector(0.4, 0.4, 0.4))
            self:EnableMatrix("RenderMultiply",Mat)
	    end
	end
	
	self:DrawModel()
end

hook.Add("Tick", "FlashLight.Tick", function()
    for i,v in pairs(player.GetAll()) do
        if v:Alive() then
            local wep = v:GetActiveWeapon()
            if IsValid(wep) then
                wep.Pos, wep.Ang = wep.Pos or Vector(), wep.Ang or Angle()
                if IsValid(wep.Flashlight) then
                    wep.Flashlight:SetPos(wep.Pos + wep.Ang:Forward() * 15 + wep.Ang:Right() * 1)
                    wep.Flashlight:SetAngles(wep.Ang)
                    wep.Flashlight:Update()
                end
            end
        end
    end
end)