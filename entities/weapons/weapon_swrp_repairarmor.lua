SWEP.Base = "weapon_base"

SWEP.HoldType = "slam"
SWEP.PrintName = "Восстановление брони"
SWEP.NextThinkTime = 0
SWEP.ViewModel = "models/weapons/custom/v_defib.mdl"
SWEP.WorldModel = "models/pg_props/pg_stargate/pg_shot_used.mdl"
SWEP.MaxCharge = 5 -- стандартный КД
SWEP.MaxChargeRepair = 10 -- Кулдаун после успешного восстановления
SWEP.RepairAR = 20 -- Восстановление брони
function SWEP:SetupDataTables()
    self:NetworkVar("Float", 1, "Charge")
    self:NetworkVar("Float", 2, "MaxCharge")
end

function SWEP:Initialize()
    self:SetHoldType( self.HoldType )
    self:SetCharge(0)
    self:SetMaxCharge(self.MaxCharge)
end 

function SWEP:PrimaryAttack()
    if self:GetCharge() > 0 then return end

    local tr = util.TraceLine({
        start = self.Owner:EyePos(),
        endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 80,
        filter = self.Owner
    })
    local target = tr.Entity
    if IsValid(target) && target:Alive() then
        self.SelectedRepair = target
        self:SetMaxCharge(self.MaxCharge)
    end
    self:SetNextPrimaryFire(CurTime() + 1.2)
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end

function SWEP:Think()
    if CLIENT then return end 
    if self.NextThinkTime > CurTime() then return end
    self.NextThinkTime = CurTime()+0.1

    local gch = self:GetCharge()
    if IsValid(self.SelectedRepair) then
        local tr = util.TraceLine({
            start = self.Owner:EyePos(),
            endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 80,
            filter = self.Owner
        })
        local target = self.SelectedRepair
        if tr.Entity == target then
            if gch >= self.MaxCharge then
                self:SetCharge(self.MaxChargeRepair)
                self:SetMaxCharge(self.MaxChargeRepair)
                self.SelectedRepair = nil
                local _ar = target:Armor()+self.RepairAR
                if _ar > target:GetMaxArmor() then
                    _ar = target:GetMaxArmor()
                end
                target:SetArmor(_ar)
                self.Owner:DoAnimCustom("g_righthandpoint")

                SWRPChatText(true)
                    :Add(self.Owner:CharNick(), Color(212,100,59))
                    :Add(' пополнил броню ', Color(255,255,255))
                    :Add(target:CharNick(), Color(212,100,59))
                    :Add(' на ', Color(255,255,255))
                    :Add(self.RepairAR.." ед", Color(212,100,59))
                    :SendWhoHear(self.Owner) 

                return
            end
            self:SetCharge(gch+0.1)
            return
        else
            self.SelectedRepair = nil
        end
    end
    if gch > 0 then
        local boom = gch-0.1
        if boom < 0 then boom = 0 end
        self:SetCharge(boom)
    end
end

function SWEP:DrawWorldModel()
	if IsValid( self.Owner ) then   
		local iBone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if(iBone) then
            self.Pos, self.Ang = self.Owner:GetBonePosition(iBone)
            self:SetRenderOrigin(self.Pos + self.Ang:Forward() * 4 + self.Ang:Right() * 1.5)
            self:SetRenderAngles(self.Ang)
            local Mat = Matrix()
            Mat:Scale(Vector(0.8, 0.8, 0.8))
            self:EnableMatrix("RenderMultiply",Mat)
	    end
	end
	
	self:DrawModel()
end

function SWEP:Holster()
    return true
end

function SWEP:DrawHUD()
    local progress = self:GetCharge()
    progress = math.Remap(progress, 0, self:GetMaxCharge(), 0, 100)
    
    SWRP:ChangeCProgress(progress)
end