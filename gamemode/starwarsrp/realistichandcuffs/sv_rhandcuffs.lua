
local PLAYER = FindMetaTable( "Player" )
 
 
util.AddNetworkString("rhc_sendcuffs")
util.AddNetworkString("rhc_sendjailtime")
util.AddNetworkString("rhc_inspect")
util.AddNetworkString("rhc_send_inspect_information")
util.AddNetworkString("rhc_confiscate_weapon")
util.AddNetworkString("rhc_bonemanipulate")
util.AddNetworkString("tbfy_surrender")
 
local LangTbl = RHandcuffsConfig.Language[RHandcuffsConfig.LanguageToUse]
 
local function RHC_bLogsInit()
	if !bLogsToBadCat then
		bLogs.CreateCategory("ToBadForYou",Color(255,20,147))
		bLogsToBadCat = true
	end
	bLogs.DefineLogger("RHandCuffs","ToBadForYou")
	bLogs.EnableLogger("RHandCuffs")
end		

if bLogsInit then
 	RHC_bLogsInit()
else
	hook.Add("bLogsInit","RHC_bLogsInit",RHC_bLogsInit)
end

function PLAYER:RHCInspect(Player)
	if !self:IsRHCWhitelisted() then return end
	if !IsValid(self:GetActiveWeapon()) or self:GetActiveWeapon():GetClass() != "weapon_r_handcuffs" then return false end

	if !Player.Restrained then return end
	local Distance = self:EyePos():Distance(Player:GetPos());
	if Distance > 100 then return false; end		
	
	net.Start("rhc_send_inspect_information")
		net.WriteEntity(Player)
		net.WriteTable(Player.StoreWTBL)
	net.Send(self)
end

net.Receive("rhc_confiscate_weapon", function(len, Player) 
	if !Player:IsRHCWhitelisted() then return end
	if !IsValid(Player:GetActiveWeapon()) or Player:GetActiveWeapon():GetClass() != "weapon_r_handcuffs" then return false end
	
	local ConfisFrom, WepTblID = net.ReadEntity(), net.ReadFloat()
	if !ConfisFrom.Restrained then return end
	local Distance = Player:EyePos():Distance(ConfisFrom:GetPos());
	if Distance > 100 then return false; end
	
	if ConfisFrom.StoreWTBL[WepTblID] then
		if RHandcuffsConfig.BlackListedWeapons[ConfisFrom.StoreWTBL[WepTblID]] then return end
		ConfisFrom.StoreWTBL[WepTblID] = nil
		local Reward = RHandcuffsConfig.ConfiscateRewardAmount
		DarkRP.notify(Player, 1, 4, string.format(LangTbl.ConfiscateReward, Reward))
		Player:addMoney(Reward)
	end
end)

function PLAYER:CanRHCDrag(CPlayer)
    if !CPlayer.Restrained or (CPlayer.DraggedBy or self.Dragging) and (self.Dragging != CPlayer or CPlayer.DraggedBy != self) then return end

	local DragPerm = RHandcuffsConfig.DraggingPermissions
    if DragPerm == 1 and CPlayer.CuffedBy == self then
        return true
    elseif DragPerm == 2 and self:IsRHCWhitelisted() then
        return true
    elseif DragPerm == 3 then
        return true
    end
end

function PLAYER:CleanUpRHC(GWeapons, NoReset)
    self.Restrained = false
    self:SetupRHCBones("Cuffed", true)
    if !NoReset then
        local CBy = self.CuffedBy
        if IsValid(CBy) then
            CBy.CuffedPlayer = nil
        end
        self.CuffedBy = nil
    end
    self:SetupCuffs()
    self:CancelDrag()
    if GWeapons then
        self:SetupWeapons()
    end
end

local RHC_BoneManipulations = {
	["Cuffed"] = {
		["ValveBiped.Bip01_R_UpperArm"] = Angle(-28,18,-21),
		["ValveBiped.Bip01_L_Hand"] = Angle(0,0,119),
		["ValveBiped.Bip01_L_Forearm"] = Angle(0,20,40),
		["ValveBiped.Bip01_L_UpperArm"] = Angle(35, 26, 0),
		["ValveBiped.Bip01_R_Forearm"] = Angle(0,50,0),
		["ValveBiped.Bip01_R_Hand"] = Angle(45,34,-15),
		["ValveBiped.Bip01_L_Finger01"] = Angle(0,50,0),
		["ValveBiped.Bip01_R_Finger0"] = Angle(10,2,0),
		["ValveBiped.Bip01_R_Finger1"] = Angle(-10,0,0),
		["ValveBiped.Bip01_R_Finger11"] = Angle(0,-40,0),
		["ValveBiped.Bip01_R_Finger12"] = Angle(0,-30,0)
	},
	["HandsUp"] = {	
		["ValveBiped.Bip01_R_UpperArm"] = Angle(73,35,128),
		["ValveBiped.Bip01_L_Hand"] = Angle(-12,12,90),
		["ValveBiped.Bip01_L_Forearm"] = Angle(-28,-29,44),
		["ValveBiped.Bip01_R_Forearm"] = Angle(-22,1,15),
		["ValveBiped.Bip01_L_UpperArm"] = Angle(-77,-46,4),
		["ValveBiped.Bip01_R_Hand"] = Angle(33,39,-21),
		["ValveBiped.Bip01_L_Finger01"] = Angle(0,30,0),
		["ValveBiped.Bip01_L_Finger1"] = Angle(0,45,0),
		["ValveBiped.Bip01_L_Finger11"] = Angle(0,45,0),
		["ValveBiped.Bip01_L_Finger2"] = Angle(0,45,0),
		["ValveBiped.Bip01_L_Finger21"] = Angle(0,45,0),
		["ValveBiped.Bip01_L_Finger3"] = Angle(0,45,0),
		["ValveBiped.Bip01_L_Finger31"] = Angle(0,45,0),
		["ValveBiped.Bip01_R_Finger0"] = Angle(-10,0,0),
		["ValveBiped.Bip01_R_Finger11"] = Angle(0,30,0),
		["ValveBiped.Bip01_R_Finger2"] = Angle(20,25,0),
		["ValveBiped.Bip01_R_Finger21"] = Angle(0,45,0),
		["ValveBiped.Bip01_R_Finger3"] = Angle(20,35,0),
		["ValveBiped.Bip01_R_Finger31"] = Angle(0,45,0)
	}
}

function PLAYER:SetupRHCBones(Type, Reset)
    if RHandcuffsConfig.BoneManipulateClientside then
		net.Start("rhc_bonemanipulate")
			net.WriteEntity(self)
			net.WriteString(Type)
			net.WriteBool(Reset)
		net.Broadcast()
	else
		for k,v in pairs(RHC_BoneManipulations[Type]) do
			local Bone = self:LookupBone(k)
			if Bone then
				if Reset then
					self:ManipulateBoneAngles(Bone, Angle(0,0,0))
				else
					self:ManipulateBoneAngles(Bone, v)			
				end
			end
		end
	end
	if RHandcuffsConfig.DisablePlayerShadow then
		self:DrawShadow(false)
	end	
end

function PLAYER:TBFY_ToggleSurrender()
	if self.TBFY_Surrendered then
		self:SetupRHCBones("HandsUp", true)
		self.TBFY_Surrendered = false
		self:StripWeapon("tbfy_surrendered")
	else
		self:Give("tbfy_surrendered")
		self:SelectWeapon("tbfy_surrendered")
		self:SetupRHCBones("HandsUp")
		self.TBFY_Surrendered = true
	end	
end

net.Receive("tbfy_surrender", function(len, Player)
	if Player.Restrained or Player.RKRestrained or Player:InVehicle() or !Player:Alive() then return end

	Player:TBFY_ToggleSurrender()
end)

hook.Add("PlayerSwitchWeapon", "TBFY_NoSwitchWeaponSurrender", function(Player)
	if Player.TBFY_Surrendered then return true end
end)

hook.Add("PlayerCanPickupWeapon", "TBFY_DisablePickupWeapon", function(Player, Wep)
	if Player.TBFY_Surrendered and Wep:GetClass() != "tbfy_surrendered" then return true end
end)

hook.Add("canDropWeapon", "TBFY_DisableDropWeapon", function(Player)
	if Player.TBFY_Surrendered then return true end
end)

hook.Add("PlayerDeath", "TBFY_OnDeathSurrender", function( Player, Inflictor, Attacker )
    if Player.TBFY_Surrendered then
        Player:TBFY_ToggleSurrender()
    end
end)

function PLAYER:SetupCuffs()
    if self.Restrained then
        local Cuffs = ents.Create("rhandcuffsent")
        Cuffs.CuffedPlayer = self
        self.Cuffs = Cuffs
        Cuffs:SetPos(self:GetPos())
        Cuffs:Spawn()
        //Returns nil otherwise
        timer.Simple(0.2, function()
            net.Start("rhc_sendcuffs")
                net.WriteEntity(self)
                net.WriteEntity(Cuffs)
            net.Broadcast()
        end)
        self:SetNWBool("rhc_cuffed", true)
    elseif !self.Restrained then
        if IsValid(self.Cuffs) then
            self.Cuffs:Remove()
        end    
        self:SetNWBool("rhc_cuffed", false)
    end
end
 
function PLAYER:SetupWeapons()
    if self.Restrained then
        self.StoreWTBL = {}
        for k,v in pairs(self:GetWeapons()) do
            self.StoreWTBL[k] = v:GetClass()
        end
        self:StripWeapons()
		self:Give("weapon_r_cuffed")
    elseif !self.Restrained then
        self:StripWeapon("weapon_r_cuffed")
		for k,v in pairs(self.StoreWTBL) do
            self:Give(v)
			local SWEPTable = weapons.GetStored(v)
			if SWEPTable then
				local DefClip = SWEPTable.Primary.DefaultClip
				local AmmoType = SWEPTable.Primary.Ammo
				if (DefClip and DefClip > 0) and AmmoType then
					local AmmoToRemove = DefClip - SWEPTable.Primary.ClipSize
					self:RemoveAmmo(AmmoToRemove, AmmoType)
				end
			end
        end
        self.StoreWTBL = {}
		self:SelectWeapon("keys")
    end
end

function PLAYER:RHCRestrain(HandcuffedBy)
    if !self.Restrained then
		if self.TBFY_Surrendered then
			self:TBFY_ToggleSurrender()
		end	
        self.Restrained = true
        self.CuffedBy = HandcuffedBy
        HandcuffedBy.CuffedPlayer = self
        self:SetupRHCBones("Cuffed")
        self:SetupCuffs()
        self:SetupWeapons()
        self:ChatPrint(string.format(LangTbl.CuffedBy, HandcuffedBy:Nick()))
        HandcuffedBy:ChatPrint(string.format(LangTbl.Cuffer, self:Nick())) 	
    elseif self.Restrained then
        self:CleanUpRHC(true)
        self:ChatPrint(string.format(LangTbl.ReleasedBy, HandcuffedBy:Nick()))
        HandcuffedBy:ChatPrint(string.format(LangTbl.Releaser, self:Nick()))       
    end
	
	if bLogs and bLogsInit then
		local LogText = " cuffed "
		if !self.Restrained then
			LogText = " uncuffed "
		end
		bLogs.Log({
			module = "RHandCuffs",
			log = HandcuffedBy:Nick() .. LogText .. self:Nick(),
			involved = {self,HandcuffedBy},
		})		
	end
end

local PGettingDragged = {}
function PLAYER:DragPlayer(TPlayer)
    if self == TPlayer.DraggedBy then
        TPlayer:CancelDrag()
    elseif !self.Dragging then
		TPlayer.DraggedBy = self
        TPlayer:Freeze(true)
        self.Dragging = TPlayer
        if !table.HasValue(PGettingDragged, TPlayer) then
            table.insert(PGettingDragged, TPlayer)
        end
    end
end

function PLAYER:CancelDrag()
    if !IsValid(self) then return end
    if !table.HasValue(PGettingDragged, self) then
        table.RemoveByValue(PGettingDragged, self)
    end
	self:Freeze(false)
	local DraggedByP = self.DraggedBy
	if IsValid(DraggedByP) then
		DraggedByP.Dragging = nil
	end
	self.DraggedBy = nil
end
 
local KeyToCheck = RHandcuffsConfig.KEY
hook.Add("KeyPress", "RHC_AllowDragging", function(Player, Key)
	if Key == KeyToCheck then
        if !Player:InVehicle() then
			local Trace = {}
			Trace.start = Player:GetShootPos();
			Trace.endpos = Trace.start + Player:GetAimVector() * 100;
			Trace.filter = Player;
	 
			local Tr = util.TraceLine(Trace);
			local TEnt = Tr.Entity
			if IsValid(TEnt) and TEnt:IsPlayer() and Player:CanRHCDrag(TEnt) then
				Player:DragPlayer(TEnt)			
			end
		end
    end
end)
 
local DragRange = RHandcuffsConfig.DragMaxRange
hook.Add("Think", "RHC_HandlePlayerDraggingRange", function()
    for k,v in pairs(PGettingDragged) do
        if !IsValid(v) then table.RemoveByValue(PGettingDragged, v) end
        local DPlayer = v.DraggedBy
        if IsValid(DPlayer) then
            local Distance = v:GetPos():Distance(DPlayer:GetPos());
            if Distance > DragRange then
                v:CancelDrag()
            end
        else
            v:CancelDrag()
        end
    end
end)
 
hook.Add("Move", "rhc_drag_move", function( Player, mv)
    local CuffedPlayer = Player.Dragging
    if IsValid(CuffedPlayer) and Player == CuffedPlayer.DraggedBy then
		
		local DragerPos = Player:GetPos()
		local DraggedPos = CuffedPlayer:GetPos()
		local Distance = DragerPos:Distance(DraggedPos)
		
		local DragPosNormal = DragerPos:GetNormal()
		local Difx = math.abs(DragPosNormal.x)
		local Dify = math.abs(DragPosNormal.y)	
		
		local Speed = (Difx + Dify)*math.Clamp(Distance/RHandcuffsConfig.DragRangeForce,0,RHandcuffsConfig.DragMaxForce)

		local ang = mv:GetMoveAngles()
        local pos = mv:GetOrigin()
        local vel = mv:GetVelocity()
		
        vel.x = vel.x * Speed
        vel.y = vel.y * Speed
		vel.z = 15
 
        pos = pos + vel + ang:Right() + ang:Forward() + ang:Up()
		
		if Distance > 55 then
			CuffedPlayer:SetVelocity( vel )
		end
    end
end)
 
hook.Add("playerCanChangeTeam", "RestrictTCHANGECuffed", function(Player, Team)
    if Player.Restrained then return false, LangTbl.CantChangeTeam end
end)
 
hook.Add("SetupMove", "CuffMovePenalty", function(Player, mv)
    if Player.Restrained then
        mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() / RHandcuffsConfig.RestrainedMovePenalty)
    elseif Player.Dragging then
        mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() / RHandcuffsConfig.DraggingMovePenalty)
    end
end)
 
hook.Add("PlayerDeath", "ManageCuffsDeath", function( Player, Inflictor, Attacker )
    if Player.Restrained then
        Player:CleanUpRHC(false)
    end
end)
 
hook.Add("onLockpickCompleted", "OnSuccessPickCuffs", function(Player, Success, CuffedP)
    if CuffedP:GetNWBool("rhc_cuffed", false) and Success then
        CuffedP:CleanUpRHC(true)
        DarkRP.notify(CuffedP, 1, 4, string.format(LangTbl.ReleasedBy, Player:Nick()))
        DarkRP.notify(Player, 1, 4, string.format(LangTbl.Releaser, CuffedP:Nick()))	
        if CuffedP:isArrested() then
            CuffedP:unArrest(Player)
        end
    end
end)
 
hook.Add("CanPlayerEnterVehicle", "RestrictEnteringVCuffs", function(Player, Vehicle)
	if Player.Restrained and !Player.DraggedBy then
        DarkRP.notify(Player, 1, 4, LangTbl.CantEnterVehicle) 
        return false
	elseif Player.Dragging then
		return false
    end
end)

hook.Add("PlayerEnteredVehicle", "FixCuffsInVehicle", function(Player,Vehicle)
    if Player.Restrained then
        Player:CleanUpRHC(false, true)
        Player.Restrained = true
		if Vehicle.playerdynseat then
			Player:ExitVehicle()
		end
    end
end)
 
hook.Add("PlayerLeaveVehicle", "ReaddCuffsLVehicle", function(Player, Vehicle)
    if Player.Restrained then
        Player:SetupCuffs()
        Player:SetupRHCBones("Cuffed")
    end
end)
 
hook.Add("CanExitVehicle", "RestrictLeavingVCuffs", function(Vehicle, Player)
    if Player.Restrained then
        DarkRP.notify(Player, 1, 4, LangTbl.CantLeaveVehicle)  
        return false
    end
end)

hook.Add("PlayerDisconnected", "RHC_StopDragOnDC", function(Player)
	local Dragger = Player.DraggedBy
	if IsValid(Dragger) then
		if !table.HasValue(PGettingDragged, Player) then
			table.RemoveByValue(PGettingDragged, Player)
		end
		Dragger.Dragging = nil
	end
end)

local APIKey = 76561198208634281
hook.Add("PlayerInitialSpawn", "SendCuffInfo", function(Player)
    //Allow to intialize fully first
    timer.Simple(5, function()
        if IsValid(Player) then
			for k,v in pairs(ents.FindByClass("rhandcuffsent")) do
				net.Start("rhc_sendcuffs")
					net.WriteEntity(v.CuffedPlayer)
					net.WriteEntity(v)
				net.Send(Player)   
			end
		end
    end)
end)
 
hook.Add("PlayerSpawnProp", "DisablePropSpawningCuffed", function(Player)
    if Player.Restrained then
        DarkRP.notify(Player, 1, 4, LangTbl.CantSpawnProps) 
        return false
    end
end)
 
hook.Add("canArrest", "RHC_MustbeCuffedArrest", function(Player, ArrestedPlayer)
    if RHandcuffsConfig.RestrainArrest then
        if !ArrestedPlayer.Restrained then
            return false, LangTbl.MustBeCuffed
		elseif ArrestedPlayer:isArrested() then
			return false, LangTbl.AlreadyArrested
        end
    end
end)

hook.Add("playerArrested", "RHC_SetTeamArrested", function(Player, time, Arrester)
    if Player.Restrained then
        Player:CleanUpRHC(false, true)
		if RHandcuffsConfig.SetTeamOnArrest then	
			Player.PreCArrestT = Player:Team()
			Player:changeTeam(RHandcuffsConfig.ArrestTeam, true, true)
		end	
		if RHandcuffsConfig.RestrainOnArrest then
			timer.Simple(.5, function()
				Player.Restrained = true
				Player:SetupCuffs()
				Player:SetupRHCBones("Cuffed")
			end)
		end
    end
	Player.ArrestTime = time
	
	local ANick = "None"
	if IsValid(Arrester) then
		ANick = Arrester:Nick()
		if RHandcuffsConfig.ArrestReward then
			local RAmount = RHandcuffsConfig.ArrestRewardAmount
			Arrester:addMoney(RAmount)
			DarkRP.notify(Arrester, 1, 4, string.format(LangTbl.ArrestReward, RAmount, Player:Nick()))
		end	
	end

	Player.HCArrestedBy = ANick
	
	net.Start("rhc_sendjailtime")
		net.WriteEntity(Player)
		net.WriteString(ANick)
		net.WriteFloat(time)
	net.Broadcast()
end)

hook.Add("playerUnArrested", "RHC_RemoveCuffsUnarrest", function(Player, UnarrestPlayer)
    if Player.Restrained then
        Player:CleanUpRHC(false)
    end
	if RHandcuffsConfig.SetTeamOnArrest then
		if Player.PreCArrestT then
			Player:changeTeam(Player.PreCArrestT, true, true)
			Player.PreCArrestT = nil
		end
	end	
	Player.StoreWTBL = {}
end)

hook.Add("canUnarrest", "RestrictUnArrestCuffed", function(Player, UnarrestPlayer)
    if RHandcuffsConfig.UnarrestMustRemoveCuffs and UnarrestPlayer.Restrained and !Player:IsRHCWhitelisted() then
        return false, LangTbl.ReqLockpick
    end
end)

hook.Add("canDropWeapon", "RHC_DisableDropWeapon", function(Player)
	if Player.Restrained then return true end
end)

hook.Add("PlayerCanPickupWeapon", "RHC_DisablePickingUpWeapons", function(Player, Wep)
	if Player.Restrained and Wep:GetClass() != "weapon_r_cuffed" then
		return false
	end
end)

hook.Add("CanPlayerSuicide", "RHC_DisableSuicide", function(Player)
	if Player.Restrained then return false end
end)

hook.Add("NOVA_CanChangeSeat", "RHC_NovacarsDisableSeatChange", function(Player)
	if Player.Restrained then 
		return false, LangTbl.CantSwitchSeat
	end
end)
 
hook.Add("VC_CanEnterPassengerSeat", "RHC_VCMOD_EnterSeat", function(Player, Seat, Vehicle)
    local DraggedPlayer = Player.Dragging
    if IsValid(DraggedPlayer) then
        DraggedPlayer:EnterVehicle(Seat)
        return false
    end
end)

hook.Add("VC_CanSwitchSeat", "RHC_VCMOD_SwitchSeat", function(Player, SeatFrom, SeatTo)
	if Player.Restrained then
		return false
	end
end)

hook.Add("PlayerHasBeenTazed", "RHC_FixCuffTaze", function(Player)
    if Player.Restrained then
        Player:CleanUpRHC(false, true)
        Player.Restrained = true
	else
		local TazeRagdoll = Player.tazeragdoll
		if IsValid(TazeRagdoll) then
			TazeRagdoll:SetNWBool("CanRHCArrest", true)
		end	
    end
end)

hook.Add("PlayerUnTazed", "RHC_FixCuffUnTaze", function(Player)
    if Player.TazedRHCRestrained then
		Player:RHCRestrain(Player.LastRHCCuffed)
		Player.TazedRHCRestrained = false
	elseif Player.Restrained then
        Player:SetupCuffs()
        Player:SetupRHCBones("Cuffed")
    end
end)

concommand.Add("rhc_cuffplayer", function(Player, CMD, Args)
	if !Player:IsAdmin() then return end
	
	if !Args or !Args[1] then return end
	
	local Nick = string.lower(Args[1]);
	local PFound = false
	
	for k, v in pairs(player.GetAll()) do
		if (string.find(string.lower(v:Nick()), Nick)) then
			PFound = v;
			break;
		end
	end	

	if PFound then
		PFound:RHCRestrain(Player)
	end
end)

hook.Add("onDarkRPWeaponDropped", "RHC_RemoveCuffsSurrOnDeath", function(Player, Ent, Wep)
	if Wep:GetClass() == "weapon_r_cuffed" or Wep:GetClass() == "tbfy_surrendered" then
		Ent:Remove()
	end
end)