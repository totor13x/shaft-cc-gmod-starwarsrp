GUI3D.Texture = GetRenderTarget("gui3d_rt" .. os.time(), ScrW(), ScrH(), false)

GUI3D.Material = CreateMaterial("gui3d_mat" .. os.time(), "UnlitGeneric", {
	["$basetexture"]	= GUI3D.Texture:GetName(),
	["$vertexalpha"]	= 1,
	["$nolod"]			= 1,
})

render.PushRenderTarget(GUI3D.Texture)
	render.OverrideAlphaWriteEnable(true, true)
	render.Clear(0, 0, 0, 0, true, true)
	render.SetBlend(0.99)
render.PopRenderTarget()

local wireframe = Material("editor/wireframe")

hook.Add("PostDrawHUD", "GUI3D_DrawGUI", function()
/*
	if GUI3D.Replaced then
		GUI3D:Push()
		GUI3D.config.Cursor(gui.MousePos())
		GUI3D:Pop()
	end
	*/
	
	GUI3D.Replaced = false
	
	if GUI3D.Mesh and GUI3D.config.Enabled and GUI3D.GetMeshPos/* and !GUI3D.Clear*/ then
		
		if not IsValid(LocalPlayer()) then return end
		wep = LocalPlayer():GetActiveWeapon()
		if IsValid(wep) and wep.IsCurrentlyScoped and wep:IsCurrentlyScoped() then return end
		cam.Start3D(EyePos(), EyeAngles(), nil, 0, 0, ScrW(), ScrH(), nil, nil)
			if GUI3D.config.Wireframe then
				render.SetMaterial(wireframe)
			else
				GUI3D.Material:SetTexture("$basetexture", GUI3D.Texture)
				render.SetMaterial(GUI3D.Material)
			end
			
			local matrix = Matrix()
			matrix:Translate(GUI3D:GetMeshPos())
			matrix:Rotate(GUI3D:GetMeshAngle())
			
			cam.PushModelMatrix(matrix)
			
			GUI3D.Mesh:Draw()
			GUI3D.Clear = true
			
			cam.PopModelMatrix()
		cam.End3D()
	end
end)

timer.Simple(1, function()
	function Derma_DrawBackgroundBlur(panel, starttime)
		local size = 1

		if starttime then
			size = math.Clamp(SysTime() - starttime, 0, 0.5)
		end
		
		if size > 0 then
			size = size + 0.5
			render.BlurRenderTarget(GUI3D.Texture, size, size, 0)
		end
	end
	
	if GUI3D.config.ReplaceDrawFunctions then
		//For code that use it not in RenderScreenspaceEffects hook
		local funcs = {
			"DrawBloom",
			"DrawColorModify",
			"DrawMaterialOverlay",
			"DrawMotionBlur",
			"DrawSharpen",
			"DrawSobel",
			"DrawSunbeams",
			"DrawTexturize",
			"DrawToyTown",
		}
		
		GUI3D.OldDrawFuncs = GUI3D.OldDrawFuncs or {}
		
		for _, v in pairs(funcs) do
			if _G[v] then
				GUI3D.OldDrawFuncs[v] = GUI3D.OldDrawFuncs[v] or _G[v]
				
				_G[v] = function(...)
					local pushed = GUI3D:IsPushed()
					
					if pushed then
						GUI3D:Pop()
					end
					
					GUI3D.OldDrawFuncs[v](...)
					
					if pushed then
						GUI3D:Push()
					end
				end
			end
		end
	end
end)
/*
hook.Add("InitPostEntity", "hud_RepalceOffset", function()
	timer.Simple(1, function()
		local SwepsList = weapons.GetList()
		
		for _, swep in pairs(SwepsList) do
			local class = swep.ClassName
			
			if !class then continue end
			
			if swep.TranslateFOV then
				local old = swep.TranslateFOV
				swep.TranslateFOV = function(...)
					local fov = old(...)
					GUI3D:CalculateOffset(fov)
					
					return fov
				end
			end
			
			weapons.Register(swep, class)
		end
	end)
end)

*/