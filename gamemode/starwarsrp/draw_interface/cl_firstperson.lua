
if SERVER then return end

CreateClientConVar("swv_status", "1", true, true)
CreateClientConVar("iv_viewsmooth", "0.2", true, true)
CreateClientConVar("iv_crosshair", "1", true, true)
CreateClientConVar("iv_in_r", "255", true, true)
CreateClientConVar("iv_in_g", "255", true, true)
CreateClientConVar("iv_in_b", "255", true, true)
CreateClientConVar("iv_in_a", "150", true, true)
CreateClientConVar("iv_out_r", "0", true, true)
CreateClientConVar("iv_out_g", "0", true, true)
CreateClientConVar("iv_out_b", "0", true, true)
CreateClientConVar("iv_out_a", "125", true, true)

local ViewOffsetUp = 0
local ViewOffsetForward = 3
local ViewOffsetForward2 = 0
local ViewOffsetLeftRight = 0
local RollDependency = 0.1
local CurView = nil
local holdType
local traceHit = false
local eyeAt
local HeadScale = false
function IFPP_ShouldDrawLocalPlayer()
	if GetConVarNumber("swv_status") > 0 then
		
		if not IsValid(LocalPlayer()) then return end
		wep = LocalPlayer():GetActiveWeapon()
		if IsValid(wep) and wep.IsCurrentlyScoped and wep:IsCurrentlyScoped() then return false end
		if traceHit and not LocalPlayer():InVehicle() then
			return false
		else
			return true
		end
	else
		return false
	end
end

hook.Add("ShouldDrawLocalPlayer", "IFPP_ShouldDrawLocalPlayer", IFPP_ShouldDrawLocalPlayer)

local function FirstPersonPerspective(ply, pos, angles, fov)
	HeadScale = false
	local calc, allow = hook.Run("SWRP::CalcView", ply, pos, angles )
	if calc then
		if allow then
			local run = hook.Run("SWRP::CalcViewEyes", ply, calc )
			if run then
				calc = run
			end
		end
		return calc
	end
	
	eyeAtt = ply:GetAttachment(ply:LookupAttachment("eyes"))
	local forwardVec = ply:GetAimVector()
	local FT = 0.02
	local eyeAngles = ply:EyeAngles()
	local wep = ply:GetActiveWeapon()
	//print(FrameTime())
	//print(traceHit)
	if GetConVarNumber("swv_status") < 1 or not ply:Alive() or (traceHit and not ply:InVehicle()) or not eyeAtt then
		return
	end
	if not CurView then
		CurView = angles
	else
		CurView = LerpAngle(FT * (35 * (1 - math.Clamp(GetConVarNumber("iv_viewsmooth"), 0, 0.6))), CurView, angles + Angle(0, 0, eyeAtt.Ang.r * RollDependency))
	end
	
	wep = LocalPlayer():GetActiveWeapon()
	
	if IsValid(wep) and wep.IsCurrentlyScoped and wep:IsCurrentlyScoped() then return GAMEMODE:CalcView(ply, pos, angles, fov, 0.1) end
	
	if IsValid(wep) then
		holdType = wep:GetHoldType()
	else
		holdType = "normal"
	end
	
	if holdType then
		if holdType == "smg" or holdType == "ar2" or holdType == "rpg" then
			ViewOffsetLeftRight = math.Approach(ViewOffsetLeftRight, -1, 0.5)
		else
			ViewOffsetLeftRight = math.Approach(ViewOffsetLeftRight, 0, 0.5)
		end
	else
		ViewOffsetLeftRight = math.Approach(ViewOffsetLeftRight, 0, 0.5)
	end
	local view = {}
	
	if ply:WaterLevel() >= 3 then
		ViewOffsetUp = math.Approach(ViewOffsetUp, 0, 0.5)
		ViewOffsetForward = math.Approach(ViewOffsetForward, 8, 0.5)
		RollDependency = Lerp(FT * 15, RollDependency, 0.5)
	else
		ViewOffsetUp = math.Approach(ViewOffsetUp, math.Clamp(eyeAngles.p * -0.1, 0, 10), 0.5)
		ViewOffsetForward = math.Approach(ViewOffsetForward, 5 + math.Clamp(eyeAngles.p * 0.1, 0, 5), 0.5)
		RollDependency = Lerp(FT * 15, RollDependency, 0.05)
	end
	
	
	if ply:InVehicle() then
		//ViewOffsetForward2 = 2
	else
		ViewOffsetForward2 = -4
	end
	
	if eyeAtt then
		HeadScale = true
		view.origin = eyeAtt.Pos + (Vector(forwardVec.x * (ViewOffsetForward + ViewOffsetForward2), forwardVec.y * (ViewOffsetForward + ViewOffsetForward2), 0)) + Vector(0, 0, ViewOffsetUp) + ply:GetRight() * ViewOffsetLeftRight
		view.angles = CurView
		view.fov = 90
		//view.znear = 0.1
		local run = hook.Run("SWRP::CalcViewEyes", ply, view )
		if run then
			view = run
		end
		//print(view.angles)
		return GAMEMODE:CalcView(ply, view.origin, view.angles, view.fov, view.znear)
	end
end

hook.Add("CalcView", "FirstPersonPerspective", FirstPersonPerspective)
local dist = 500
function IFPP_DotCrosshair()
	if GetConVarNumber("iv_crosshair") < 1 then
		return
	end

	local ply = LocalPlayer()

	if GetConVarNumber("swv_status") < 1 or not ply:Alive() or traceHit then
		return
	end
		if not IsValid(LocalPlayer()) then return end
		wep = LocalPlayer():GetActiveWeapon()
		if IsValid(wep) and wep.IsCurrentlyScoped and wep:IsCurrentlyScoped() then return false end
	
	local IN_R = 255
	local IN_G = 255
	local IN_B = 255
	local IN_A = 255
	
	local OUT_R = 0
	local OUT_G = 0
	local OUT_B = 0
	local OUT_A = 255
	local traceline = {}
	traceline.start = ply:GetShootPos()
	
	traceline.endpos = traceline.start + ply:GetAimVector() * dist
	traceline.filter = ply
	local trace = util.TraceLine(traceline)
	
	local pos = trace.HitPos:ToScreen()
		
	local disat = math.Remap(trace.HitPos:Distance(EyePos()), 0, dist, 0,255)
	IN_A = disat
	OUT_A = disat
	surface.SetDrawColor(OUT_R, OUT_G, OUT_B, OUT_A)
	surface.DrawRect(pos.x - 2, pos.y - 1, 5, 5)
	
	surface.SetDrawColor(IN_R, IN_G, IN_B, IN_A)
	surface.DrawRect(pos.x - 1, pos.y, 3, 3)
end

hook.Add("HUDPaint", "IFPP_DotCrosshairHUD", IFPP_DotCrosshair)

function IFPP_DotCrosshair3D()
	if GetConVarNumber("iv_crosshair") < 1 then
		return
	end

	local ply = LocalPlayer()

	if GetConVarNumber("swv_status") < 1 or not ply:Alive() or traceHit then
		return
	end
		if not IsValid(LocalPlayer()) then return end
		wep = LocalPlayer():GetActiveWeapon()
		if IsValid(wep) and wep.IsCurrentlyScoped and wep:IsCurrentlyScoped() then return false end
	
	local IN_R = 255
	local IN_G = 255
	local IN_B = 255
	local IN_A = 255
	
	local OUT_R = 0
	local OUT_G = 0
	local OUT_B = 0
	local OUT_A = 255
	local traceline = {}
	traceline.start = ply:GetShootPos()
	
	-- if 
	-- SWRP.Thirdperson and 
	-- SWRP.Thirdperson.Enabled and 
	-- SWRP.Thirdperson.Enabled:GetBool() == true and 
	-- ply:Alive() 
	-- and (ply:Team() ~= TEAM_SPECTATOR) then
		-- local ang = EyeAngles()
		-- traceline.start = 
				-- traceline.start
				-- + ang:Forward()*-SWRP.Thirdperson.Dist
				-- + Vector(0,0,SWRP.Thirdperson.Nije)
				-- + ang:Right()*SWRP.Thirdperson.DistR
				-- + ang:Up()
	-- end
	traceline.endpos = traceline.start + ply:GetAimVector() * 600
	traceline.filter = ply
	local trace = util.TraceLine(traceline)

	
	
	if trace.HitPos:Distance(EyePos()) < dist then
	local pos_cross=trace.Hit and trace.HitNormal or-ply:GetAimVector()

	if math.abs(pos_cross.z)>.98 then
		pos_cross:Add(-ply:GetAimVector()*.01)
	end 

	local poscur,angcur=LocalToWorld(Vector(0,0,0),Angle(0,90,90), trace.HitPos, pos_cross:Angle())

	cam.Start3D2D(poscur,angcur, 0.03)
	cam.IgnoreZ(true)
		draw.RoundedBox(100, (-60/2),-60/2,60,60,Color(OUT_R, OUT_G, OUT_B, OUT_A))
		draw.RoundedBox(100, (-60/2)+5,(-60/2)+5,60-10,60-10,Color(IN_R, IN_G, IN_B, IN_A))
	cam.IgnoreZ(false)
	cam.End3D2D()
	poscur = poscur+angcur:Up()*-0.4
	hook.Run("Cursor::Cam3D2D", poscur, angcur)
	end
	/*
	local trace = util.TraceLine(traceline)
	local pos = trace.HitPos:ToScreen()
	local ang = trace.HitNormal:Angle()
	
	ang:RotateAroundAxis( ang:Right(), 90 )
	local r = 60
	local poscur = trace.HitPos+ang:Up()*-0.4
	if trace.HitPos:Distance(EyePos()) < dist then
		cam.Start3D2D( poscur, ang, 0.03 )

			draw.RoundedBox(10, (-60/2),-60/2,60,60,Color(OUT_R, OUT_G, OUT_B, OUT_A))
			draw.RoundedBox(10, (-60/2)+5,(-60/2)+5,60-10,60-10,Color(IN_R, IN_G, IN_B, IN_A))
			
		cam.End3D2D()
		hook.Run("Cursor::Cam3D2D", poscur, ang)
	end
	*/
end

hook.Add("PostDrawTranslucentRenderables", "IFPP_DotCrosshairRed", IFPP_DotCrosshair3D)

hook.Add("DoAnimationEvent", "IFPP::ChangeEvent", function(ply, event, data)
	if ply == LocalPlayer() and event == PLAYERANIMEVENT_RELOAD then
	
		local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
		if HeadScale then
			ply:ManipulateBoneScale(bone, Vector(0.01, 0.01, 0.01))
		else
			ply:ManipulateBoneScale(bone, Vector(1,1,1))
		end
		
	end
end)

function IFPP_Think()
	local ply = LocalPlayer()
	
	if GetConVarNumber("swv_status") < 1 or not ply:Alive() then
		return
	end
	/*
	ply.BuildBonePositions = function(ply, numbon, numphysbon)
		if GetConVarNumber("swv_status") < 1 then
			return
		end
		
		print('aa')
		local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
		local matrix = ply:GetBoneMatrix(bone)
			
		if matrix then
			matrix:Scale(Vector(0.001, 0.001, 0.001))
			matrix:Translate(Vector(0, 0, 0))
			ply:SetBoneMatrix(bone, matrix)
		end
	end
	*/
	
	local eyeAng = ply:EyeAngles()
	
	if eyeAtt then
	
		local forwardVec = ply:GetAimVector()
		
		local tr = {}
		tr.start = eyeAtt.Pos
		tr.endpos = tr.start + Vector(forwardVec.x, forwardVec.y, 0) * 20 -- by getting only the X and Y values, I can get what's ahead of the player, and not up/down, because other methods seem to fail.
		tr.filter = ply
		
		local trace = util.TraceLine(tr)
		
		if trace.Hit then
			//traceHit = true
		else
			traceHit = false
		end
	end
end

hook.Add("Think", "IFPP_Think", IFPP_Think)

function IFPP_SetupMove(ucmd)
	if GetConVarNumber("swv_status") <= 0 or not LocalPlayer():Alive() then
		return
	end
	
	local bone1 = LocalPlayer():LookupBone("ValveBiped.Bip01_Head1")
	local bone2 = LocalPlayer():LookupBone("ValveBiped.forward")
	-- LocalPlayer():ManipulateBoneScale(bone, Vector(0.01, 0.01, 0.01))
	-- LocalPlayer():ManipulateBoneScale(bone, Vector(1,1,1))
	
	if HeadScale then
		if bone1 then
			LocalPlayer():ManipulateBoneScale(bone1, Vector(0.01, 0.01, 0.01))
		end
		if bone2 then
			LocalPlayer():ManipulateBoneScale(bone2, Vector(0.01, 0.01, 0.01))
		end
	else
		if bone1 then
			LocalPlayer():ManipulateBoneScale(bone1, Vector(1,1,1))
		end
		if bone2 then
			LocalPlayer():ManipulateBoneScale(bone2, Vector(1,1,1))
		end
	end
	
	-- LocalPlayer():ManipulateBoneScale(bone, Vector(0.01, 0.01, 0.01))
	-- LocalPlayer():ManipulateBoneScale(bone, Vector(1,1,1))
	
	local eyeAng = ucmd:GetViewAngles()
	
	ucmd:SetViewAngles(Angle(math.min(eyeAng.p, 65), eyeAng.y, eyeAng.r))
end

hook.Add("CreateMove", "IFPP_SetupMove", IFPP_SetupMove)


IFPPMenu = {}
IFPPMenu.PanelB = nil

function IFPPMenu.PanelA(panel)
	panel:ClearControls()
	
	panel:AddControl("Label", {Text = "Main control"})
	panel:AddControl("CheckBox", {Label = "IFPP: Status", Command = "swv_status"})
	
	local slider = vgui.Create("DNumSlider", panel)
	slider:SetDecimals(2)
	slider:SetMin(0.2)
	slider:SetMax(0.6)
	slider:SetConVar("iv_viewsmooth")
	slider:SetValue(GetConVarNumber("iv_viewsmooth"))
	slider:SetText("IFPP: View smooth (percentage)")
	
	panel:AddItem(slider)
	
	panel:AddControl("CheckBox", {Label = "CROSSHAIR: Status", Command = "iv_crosshair"})
	panel:AddControl("Label", {Text = "CROSSHAIR: Outline color"})
	panel:AddControl("Color", {Label = "CROSSHAIR: Outline color", Red = "iv_out_r", Green = "iv_out_g", Blue = "iv_out_b", Alpha = "iv_out_a", ShowAlpha = false, ShowHSV = true, ShowRGB = true, NumberMultiplier = "1"})
	panel:AddControl("Label", {Text = "CROSSHAIR: Inline color"})
	panel:AddControl("Color", {Label = "CROSSHAIR: Inline color", Red = "iv_in_r", Green = "iv_in_g", Blue = "iv_in_b", Alpha = "iv_in_a", ShowAlpha = false, ShowHSV = true, ShowRGB = true, NumberMultiplier = "1"})
end

function IFPPMenu.OpenSpawnMenu()
	if(IFPPMenu.PanelB) then
		IFPPMenu.PanelA(IFPPMenu.PanelB)
	end
end
hook.Add("SpawnMenuOpen", "IFPPMenu.OpenSpawnMenu", IFPPMenu.OpenSpawnMenu)

function IFPPMenu.PopulateAdminMenu()
	spawnmenu.AddToolMenuOption("Utilities", "IFPP", "IFPP", "Client", "", "", IFPPMenu.PanelA)
end
hook.Add("PopulateToolMenu", "IFPPMenu.PopulateAdminMenu", IFPPMenu.PopulateAdminMenu)