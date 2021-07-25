function GUI3D:CalculateOffset(fov)
	local curfov = LocalPlayer():GetFOV()
	fov = 90
	
	local offset = self.config.Offset
	local vertices = self.Vertices
	local width = #vertices - 1
	local height = #vertices[1] - 1
	
	LocalPlayer():SetFOV(fov, 0)
	
	local left = self.OldScreenToVector(offset, offset)
	local right = self.OldScreenToVector(ScrW() - offset, offset)
	
	LocalPlayer():SetFOV(curfov, 0)
	
	local LineWidth = vertices[1][1].pos:Distance(vertices[width][1].pos)
	local LineHeight = vertices[1][1].pos:Distance(vertices[1][height].pos)
	
	local diagonal = math.sqrt(LineWidth^2 + LineHeight^2) / 2
	
	local mul = LineWidth / left:Distance(right)
	self.offset = math.sqrt((left * mul):Length()^2 - diagonal^2)
end

function GUI3D:GenerateMesh()
	local angle = math.rad(self.config.ArcAngle)
	local width = self.config.Width
	local radiusx = self.config.RadiusX
	local radiusy = self.config.RadiusY
	local height = self.config.Height
	
	local part = angle / width
	
	local vertices = {}
	
	for i = 1, width do
		vertices[i] = {}
		
		local num = i - (width + 1) / 2
		
		local x = radiusx * math.cos(part * num)
		local y = radiusy * math.sin(part * num)
		
		for j = 1, height do
			table.insert(vertices[i], {
				pos = Vector(x, y, 0),
				u = 1 - (i - 1) / (width - 1),
				v = (j - 1) / (height - 1)
			})
		end
	end
	
	local sumwidth = 0
	
	for i = 2, width do
		sumwidth = sumwidth + vertices[i - 1][1].pos:Distance(vertices[i][1].pos)
	end
	
	gap = sumwidth / width * ScrH() / ScrW() * width / height * (1)
	halfheight = gap * height / 2
	
	for i = 1, width do
		for j = 1, height do
			vertices[i][j].pos.z = (height - j + 0.5) * gap - halfheight
		end
	end
	
	local min = vertices[1][1].pos.x
	
	for i = 1, width do
		for j = 1, height do
			if vertices[i][j].pos.x < min then
				min = vertices[i][j].pos.x
			end
		end
	end
	
	for i = 1, width do
		for j = 1, height do
			vertices[i][j].pos.x = vertices[i][j].pos.x - min
		end
	end
	
	self.Vertices = table.Copy(vertices)
	self:CalculateOffset()
	
	local MeshVertices = {}
	
	for i = 1, width - 1 do
		for j = 1, height - 1 do
			local LeftDown = vertices[i + 1][j + 1]
			local LeftUp = vertices[i + 1][j]
			local RightDown = vertices[i][j + 1]
			local RightUp = vertices[i][j]
			
			table.insert(MeshVertices, LeftDown)
			table.insert(MeshVertices, LeftUp)
			table.insert(MeshVertices, RightUp)
			table.insert(MeshVertices, RightUp)
			table.insert(MeshVertices, RightDown)
			table.insert(MeshVertices, LeftDown)
		end
	end
	
	if self.Mesh then
		self.Mesh:Destroy()
	end
	
	self.Mesh = Mesh()
	self.Mesh:BuildFromTriangles(MeshVertices)
end

hook.Add("InitPostEntity", "GUI3D_SetUpMesh", function()
	timer.Simple(0, function()
		GUI3D.Initialized = true
		GUI3D:GenerateMesh()
	end)
end)
