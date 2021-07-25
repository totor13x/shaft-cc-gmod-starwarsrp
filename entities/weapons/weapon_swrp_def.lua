local STATE_NONE, STATE_PROGRESS, STATE_ERROR = 0, 1, 2
local color_red = Color(255, 0, 0)
SWEP.Base = "weapon_base"

SWEP.HoldType = "slam"
SWEP.ViewModel = Model("models/weapons/custom/v_defib.mdl")
SWEP.WorldModel = Model("models/weapons/custom/w_defib.mdl")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Sound				= ""

if CLIENT then
  SWEP.PrintName = "Дефибриллятор"
SWEP.Slot			= 2
SWEP.SlotPos		= 1
SWEP.ViewModelFOV		=75
	SWEP.CSMuzzleFlashes	= true
	SWEP.UseHands = true


  surface.CreateFont("DefibText", {
    font = "Tahoma",
    size = 13,
    weight = 700,
    shadow = true
  })

  function SWEP:DrawHUD()
    local state = self:GetDefibState()
    local scrW, scrH = ScrW(), ScrH()
    local progress = 1
    local outlineCol, progressCol, progressText = color_white, color_white, ""

    if state == STATE_PROGRESS then
      local startTime, endTime = self:GetDefibStartTime(), self:GetDefibStartTime() + 5

      progress = math.TimeFraction(startTime, endTime, CurTime())

      if progress <= 0 then
        return
      end

      outlineCol = Color(0, 100, 0)
      progressCol = Color(0, 255, 0, (math.abs(math.sin(RealTime() * 3)) * 100) + 20)
      progressText = self:GetStateText() or "Возрождаем"
    elseif state == STATE_ERROR then
      outlineCol = color_red
      progressCol = Color(255, 0, 0, math.abs(math.sin(RealTime() * 15)) * 255)
      progressText = self:GetStateText() or ""
    else
      return
    end

    progress = math.Clamp(progress, 0, 1)

    SWRP:ChangeCProgress(progress*100)
    //surface.SetDrawColor(outlineCol)
    //surface.DrawOutlinedRect(scrW / 2 - (200 / 2) - 1, scrH / 2 + 10 - 1, 202, 16)

    //surface.SetDrawColor(progressCol)
    //surface.DrawRect(scrW / 2  - (200 / 2), scrH / 2 + 10, 200 * progress, 14)

    surface.SetFont("DefibText")
    local textW, textH = surface.GetTextSize(progressText)

    surface.SetTextPos(scrW / 2 - 100 + 2, scrH / 2 - 20 + textH)
    surface.SetTextColor(color_white)
    surface.DrawText(progressText)
  end
end

function SWEP:SetupDataTables()
  self:NetworkVar("Int", 0, "DefibState")
  self:NetworkVar("Float", 1, "DefibStartTime")

  self:NetworkVar("String", 0, "StateText")
end

function SWEP:Initialize()
  self:SetDefibState(STATE_NONE)
  self:SetDefibStartTime(0)
PrecacheParticleSystem("white_lightning")
end

function SWEP:Deploy()
  self:SetDefibState(STATE_NONE)
  self:SetDefibStartTime(0)

  return true
end

function SWEP:Holster()
  self:SetDefibState(STATE_NONE)
  self:SetDefibStartTime(0)

  return true
end


function SWEP:PrimaryAttack()
  if CLIENT then return end

  local tr = util.TraceLine({
    start = self.Owner:EyePos(),
    endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 80,
    filter = self.Owner
  })
	//print(self.Owner.LastLooked:Nick())
	//print(tr.Entity:GetNWEntity("RagdollOwner"))
	local owner = tr.Entity:GetNWEntity("RagdollOwner")
	//print(owner:SteamID())
	
	//
	  
  if IsValid(tr.Entity) and tr.Entity:GetClass() == "prop_ragdoll" then
    if owner:IsValid() and not owner:UniqueID() or tr.Entity:GetNWInt("OwnerTimeDeath") - CurTime() > SWRP.Config.TimeRespawn then
      self:FireError("ОШИБКА - ПОЛНОСТЬЮ МЕРТВ")
      return
    end   
	
	-- if owner:Team() == 1 then    
		-- self:FireError("ОШИБКА - ПОЛНОСТЬЮ МЕРТВ")
      -- return
    -- end
	local ply
	if !owner or !owner:IsValid() then    
		self:FireError("ОШИБКА - ПОЛНОСТЬЮ МЕРТВ")
		return
    else
		ply = player.GetByUniqueID(owner:UniqueID())
	end
	
    if IsValid(ply) then
      self:BeginDefib(ply, tr.Entity)
    else
      self:FireError("ОШИБКА - ПОЛНОСТЬЮ МЕРТВ")
      return
    end
  else
    self:FireError("ОШИБКА - НЕОПОЗНАНАЯ ЦЕЛЬ")
  end

end

function SWEP:SecondaryAttack()
end

function SWEP:BeginDefib(ply, ragdoll)

local spawnPos = self:FindPosition(ragdoll)

  if not spawnPos then
    self:FireError("ОШИБКА - В КОМНАТЕ НЕДОСТАТОЧНО МЕСТА")
    return
  end

  self:SetStateText("ДЕФИБРИЛЛЯЦИЯ - "..string.upper(ply:CharName()))
  self:SetDefibState(STATE_PROGRESS)
  self:SetDefibStartTime(CurTime())

  self.TargetPly = ply
  self.TargetRagdoll = ragdoll

  self:SetNextPrimaryFire(CurTime() + 6)
end

function SWEP:FireError(err)
  if err then
    self:SetStateText(err)
  else
    self:SetStateText("")
  end

  self:SetDefibState(STATE_ERROR)

  timer.Simple(1, function()
    if IsValid(self) then
      self:SetDefibState(STATE_NONE)
      self:SetStateText("")
    end
  end)

  self:SetNextPrimaryFire(CurTime() + 1.2)
end

function SWEP:FireSuccess()
  self:SetDefibState(STATE_NONE)
  self:SetNextPrimaryFire(CurTime() + 5)
  
  hook.Call("UsedDefib", GAMEMODE, self.Owner)

  //self:Remove()
end

function SWEP:Think()
  if CLIENT then return end

  if self:GetDefibState() == STATE_PROGRESS then
    if not IsValid(self.Owner) then
      self:FireError()
      return
    end

    if not (IsValid(self.TargetPly) and IsValid(self.TargetRagdoll)) then
      self:FireError("ERROR11!")
      return
    end

    local tr = util.TraceLine({
      start = self.Owner:EyePos(),
      endpos = self.Owner:EyePos() + self.Owner:GetAimVector() * 80,
      filter = self.Owner
    })

    if tr.Entity ~= self.TargetRagdoll then
      self:FireError("ОШИБКА - ЦЕЛЬ ПОТЕРЯНА")
      return
    end

    if CurTime() >= self:GetDefibStartTime() + 5 then
      if self:HandleRespawn() then
        self:FireSuccess()
      else
        self:FireError("ОШИБКА - В КОМНАТЕ НЕДОСТАТОЧНО МЕСТА")
        return
      end
    end


    self:NextThink(CurTime())
    return true
  end
end

function SWEP:HandleRespawn()
  local ply, ragdoll = self.TargetPly, self.TargetRagdoll
  //local spawnPos = self:FindPosition(self.Owner)
  local spawnPos = self:FindPosition(ragdoll)

  //print(self:FindPosition(ragdoll))
  //print(spawnPos)
  
  if not spawnPos then
    return false
  end

  //local credits = CORPSE.GetCredits(ragdoll, 0)

  //ply:SetRole(ROLE_TRAITOR)
  //ply:SpawnForRound(true)
  //ply:SetRole(ROLE_TRAITOR)
  //ply:SetCredits(credits)
  -- if not self.Owner:GetRole(MEDIC_ROLE) then
  -- local chance = math.random(1,2)
	-- if chance == 1 then
	  
		-- local textrer = 'не сумел возродить'
		-- if self.Owner.ModelSex ~= "male" then
			-- textrer = 'не сумела возродить'
		-- end
		
		-- local ct = ChatText()
		-- ct:Add(self.Owner:GetBystanderName(), self.Owner:GetBystanderColor(true))
		-- ct:Add(' '..textrer..' ', Color(255,255,255))
		-- ct:Add(ply:GetBystanderName(), ply:GetBystanderColor(true))
		-- ct:Send()
		
		-- return true
	-- end
-- end
  local oldmodel = ragdoll:GetModel()
  ply:Spawn()
  ply:SetPos(spawnPos)
  ply:SetHealth(50)
  ply:SetEyeAngles(Angle(0, ragdoll:GetAngles().y, 0))
  ply:SetModel(oldmodel)
  ragdoll:Remove()
  
  ParticleEffectAttach("white_lightning",PATTACH_POINT_FOLLOW, ply ,0)
	timer.Simple(0.4, function()
		ply:StopParticles()
	end)
						
	
	SWRPChatText(true)
		:Add(self.Owner:CharNick(), Color(212,100,59))
		:Add(' вытащил с того света ', Color(255,255,255))
		:Add(ply:CharNick(), Color(212,100,59))
		:SendWhoHear(self.Owner) 
	-- local textrer = 'возродил'
	-- if self.Owner.ModelSex ~= "male" then
	-- textrer = 'возродила'
	-- end
	
	-- local ct = ChatText()
	-- ct:Add(self.Owner:GetBystanderName(), self.Owner:GetBystanderColor(true))
	-- ct:Add(' '..textrer..' ', Color(255,255,255))
	-- ct:Add(ply:GetBystanderName(), ply:GetBystanderColor(true))
	-- ct:Send()
	
//	RewardPlayer( self.Owner, 700, 'за возрождение '.. ply:GetBystanderName() )
  //SendFullStateUpdate()
  
  
  return true
end


local Positions = {}											
table.insert(Positions, Vector(0, 0, 0.2)) -- Populate Above Player
for i=0,360,22.5 do table.insert( Positions, Vector(math.cos(i),math.sin(i),0) ) end -- Populate Around Player


function SWEP:FindPosition(ply)
  local size = Vector(32, 32, 72)
  
  local StartPos = ply:GetPos()
  
  local len = #Positions
  
  for i = 1, len do
    local v = Positions[i]
    local St = StartPos + v
    local Pos = StartPos + v * 45
	
	local tr = util.TraceLine( {
		start = St,
		endpos = Pos,
		filter = ply,
	} )
	
    if(not tr.Hit) then
		local aa = util.TraceHull({
			start = Pos,
			endpos = Pos,
			mins = Vector(size.x / 2 * -1,size.y / 2 * -1,0),
			maxs = Vector(size.x / 2,size.y / 2 , size.z),
			filter = ply,
		})
		
		if(not aa.Hit) then
		  return Pos
		end
    end
  end

  return false
end
