function GUI3D:Push(x, y, w, h)
	if GUI3D.config.Enabled and !GUI3D.config.DisablePushing then
		if self:IsPushed() then
			self:Pop()
		end
		
		GUI3D.Replaced = true
		
		local rt = render.GetRenderTarget()
		
		render.SetRenderTarget(self.Texture)
		-- If texture wasn't cleared
		if self.Clear then 
			local color = GUI3D.config.BackgroundColor
			render.Clear(color.r, color.g, color.b, color.a, true)
			
			self.Clear = false
		end
		
		if x then
			render.SetViewPort(x, y, ScrW(), ScrH())
		end
		
		cam.Start2D()
		render.OverrideAlphaWriteEnable(true, true)
		
		self.OldRT = rt
	end
end

function GUI3D:CapturePanel(pnl)
	pnl.offx = x or 0
	pnl.offy = y or 0
	pnl.old_paint = pnl.old_paint or pnl.Paint or function() end
	
	pnl.Paint = function(pself, w, h)
		local x, y = pself:LocalToScreen(0, 0)
		
		local parent = pnl:GetParent()
		
		GUI3D:Push(x, y, w, h)
		
		local ret = pnl.old_paint(pself, w, h)
		
		if ret then
			return ret
		end
	end
	
	pnl.Pushed3D = true
	pnl.old_paintover = pnl.old_paintover or pnl.PaintOver or function() end
	pnl.PaintOver = function(pself, w, h)
		local ret
		
		ret = pnl.old_paintover(pself, w, h)
		
		GUI3D:Pop()
		
		if ret then
			return ret
		end
	end 
	//print(pnl:GetChildren()) 
	for _, v in pairs(pnl:GetChildren()) do
		GUI3D:CapturePanel(v, true)
	end
end

function GUI3D:Pop()
	if GUI3D.config.Enabled then
		if !self:IsPushed() then return false end
		
		cam.End2D()
		render.SetRenderTarget(self.OldRT)
		render.SetViewPort(0, 0, ScrW(), ScrH())
		
		self.OldRT = nil
		
		return true
	end
end
/*
hook.Add("InitPostEntity", "GUI3D_Capture", function()
	if !GUI3D.Replaced then
		GUI3D.Replaced = true
		
		//For non-windows it isn't working
		if system.IsWindows() then
			//Replacing cursor
			local meta = FindMetaTable("Panel")
			GUI3D.OldSetCursor = GUI3D.OldSetCursor or meta.SetCursor
			function meta:SetCursor()
				GUI3D.OldSetCursor(self, "blank")
			end
			
			local function RecursiveReplacement(pnl)
				pnl:SetCursor()
				
				for _, child in pairs(pnl:GetChildren()) do
					RecursiveReplacement(child)
				end
			end

			RecursiveReplacement(vgui.GetWorldPanel())

			GUI3D.OldVguiCreate = GUI3D.OldVguiCreate or vgui.Create
			function vgui.Create(...)
				local pnl = GUI3D.OldVguiCreate(...)
				
				if IsValid(pnl) then
					RecursiveReplacement(pnl)
				end
				
				return pnl
			end
		end
		
		
		
		//3D panels

		//World panel rendered first, so in this panel we push our RT
		local pnl = vgui.GetWorldPanel()

		pnl.gui3d_OldPaint = pnl.gui3d_OldPaint or pnl.Paint
		if !pnl.gui3d_OldPaint then
			pnl.gui3d_OldPaint = function() end
		end

		pnl.Paint = function(...)
			GUI3D:Push()
			
			if pnl.gui3d_OldPaint then
				pnl.gui3d_OldPaint(...)
			end
		end
		
		

		hook.Add("PostRender", "GUI3D_PopRT", function()
			GUI3D:Pop()
		end)

		hook.Add("HUDPaintBackground", "GUI3D_HUDCapture", function()
			GUI3D:Push()
		end)

		hook.Add("HUDShouldDraw", "GUI3D_3DHUD", function()
			GUI3D:Push()
		end)



		//Replacing hooks

		//Another addon such as ULib can completely rewrite hook.Add function, so we should wait while they do their dirty things
		timer.Simple(0.5, function()
			local function ModifyFunction(func)
				return function(...)
					local ShouldPush = GUI3D.Texture != nil
					
					if ShouldPush then
						GUI3D:Push()
					end
					
					local ret = { func(...) }
					
					if ShouldPush then
						GUI3D:Pop()
					end
					
					return unpack(ret)
				end
			end
			
			//These hooks may not be called
			local hooks = {
				"PreDrawHUD",
				"HUDPaintBackground",
				"PostRenderVGUI"
			}
			
			local HooksTable = hook.GetTable()
			
			//Replace existing hooks
			for _, event in pairs(hooks) do
				if HooksTable[event] then
					for name, func in pairs(HooksTable[event]) do
						if !string.StartWith(name, "GUI3D_") then
							hook.Add(event, name, ModifyFunction(func))
						end
					end
				end
				
				if isfunction(GAMEMODE[event]) then
					//I don't know why, but GAMEMODE["HUDPaintBackground"] ruins all
					if event != "HUDPaintBackground" then
						GAMEMODE[event] = ModifyFunction(GAMEMODE[event])
					end
				end
			end
			
			//Replace future hooks
			GUI3D.OldHookAdd = GUI3D.OldHookAdd or hook.Add
			function hook.Add(event, name, callback, ...)
				if table.HasValue(hooks, event) and !string.StartWith(name, "GUI3D_") then
					callback = ModifyFunction(callback)
				end
				
				return GUI3D.OldHookAdd(event, name, callback, ...)
			end
			
			local SwepsList = weapons.GetList()
			local all = table.HasValue(GUI3D.config.WeaponsHUDIn2D, "*")
			
			for _, swep in pairs(SwepsList) do
				local class = swep.ClassName
				
				if !class then continue end
				
				if (all or table.HasValue(GUI3D.config.WeaponsHUDIn2D, class)) and swep.DrawHUD then
					swep.gui3d_olddraw = swep.gui3d_olddraw or swep.DrawHUD
					
					swep.DrawHUD = function(...)
						local pushed = GUI3D:IsPushed()
						
						if pushed then
							GUI3D:Pop()
						end
						
						swep.gui3d_olddraw(...)
						
						if pushed then
							GUI3D:Push()
						end
					end
					
					weapons.Register(swep, class)
				end
			end
		end)
	end

	hook.Remove("InitPostEntity", "GUI3D_Capture")
end)*/

