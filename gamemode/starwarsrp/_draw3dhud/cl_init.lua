function GUI3D:IsWindowHovered()
	if system.IsWindows() then
		return system.HasFocus()
	end
	
	return true
end

function GUI3D:IsPushed()
	local rt = render.GetRenderTarget()
	
	if !rt then return false end
	
	return string.StartWith(rt:GetName(), "gui3d_")
end
concommand.Add("gui3d_calcviewangle", function(ply, cmd, args)
	GUI3D:ChangeConfig("CalcViewAngle", tobool(args[1]))
end)

concommand.Add("gui3d_offset", function(ply, cmd, args)
	GUI3D:ChangeConfig("AdditionalOffset", tonumber(args[1]) or 0)
end)

concommand.Add("gui3d_doabarrelroll", function(ply, cmd, args)
	if !GUI3D.BarrelRoll then
		GUI3D.BarrelRoll = CurTime()
	end
end)

local OldScrW
local OldScrH
local OldFOV

hook.Add("Think", "GUI3D_ParametersChanging", function()
	local scrw = ScrW()
	local scrh = ScrH()
	local fov = LocalPlayer():GetFOV()
	
	if !OldScrW then
		OldScrW = scrw
	end
	
	if !OldScrH then
		OldScrH = scrh
	end
	
	if !OldFOV then
		OldFOV = fov
	end
	
	if OldScrW != scrw or OldScrH != scrh then
		chat.AddText(Color(255, 0, 0), "GUI3D: You have changed resolution. I highly recommend you to reconnect to the server")
		
		OldScrW = scrw
		OldScrH = scrh
	end
	
	if OldFOV != fov then
		GUI3D:CalculateOffset()
		OldFOV = fov
	end
end)

