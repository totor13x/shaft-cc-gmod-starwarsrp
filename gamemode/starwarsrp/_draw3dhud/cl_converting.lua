local VectorMeta = FindMetaTable("Vector")

GUI3D.OldScreenToVector = GUI3D.OldScreenToVector or gui.ScreenToVector
GUI3D.OldAimVector = GUI3D.OldAimVector or util.AimVector
GUI3D.OldToScreen = GUI3D.OldToScreen or VectorMeta.ToScreen
/*
function GUI3D:FromMeshToScreen(x, y)
	local vertices = self.Vertices
	
	x = ScrW() - x
	
	if !vertices or #vertices == 0 then
		return x, y
	end
	
	local width = #vertices - 1
	local height = #vertices[1] - 1
	
	local PointX = x / ScrW() * width + 1
	local PointY = y / ScrH() * height + 1
	
	local VertexX = math.Clamp(math.floor(PointX), 1, width)
	local VertexY = math.Clamp(math.floor(PointY), 1, height)
	
	local StartPos = vertices[VertexX][VertexY].pos
	
	local DirectionX
	
	if VertexX == width then
		DirectionX = vertices[VertexX][VertexY].pos - vertices[VertexX - 1][VertexY].pos
	else
		DirectionX = vertices[VertexX + 1][VertexY].pos - vertices[VertexX][VertexY].pos
	end
	
	local DirectionY
	
	if VertexY == height then
		DirectionY = vertices[VertexX][VertexY].pos - vertices[VertexX][VertexY - 1].pos
	else
		DirectionY = vertices[VertexX][VertexY + 1].pos - vertices[VertexX][VertexY].pos
	end
	 
	local pos = (StartPos + DirectionX * (PointX - VertexX) + DirectionY * (PointY - VertexY))
	
	return GUI3D.OldToScreen(GUI3D:FromMeshLocalToWorld(pos))
end
*/
function GUI3D:IntersectRayWithGUIMesh(origin, direction)
	direction = direction:GetNormalized()
	local vertices = self.Vertices
	
	local width = #vertices
	local height = #vertices[1]
	 
	for i = 1, #vertices - 1 do
		local a = GUI3D:FromMeshLocalToWorld(vertices[i + 1][height].pos) //Left bottom
		local b = GUI3D:FromMeshLocalToWorld(vertices[i + 1][1].pos) //Left top
		local c = GUI3D:FromMeshLocalToWorld(vertices[i][height].pos) //Right bottom
		
		local normal = (b - a):Cross(c - a):GetNormalized()
		
		local it = util.IntersectRayWithPlane(origin, direction, a, normal)
		
		if it then
			local bta = b - a
			local cta = c - a
			
			local ab = a:Dot(bta)
			local ib = it:Dot(bta)
			local bb = b:Dot(bta)
			
			local ac = a:Dot(cta)
			local ic = it:Dot(cta)
			local cc = c:Dot(cta)
			
			if ab <= ib and ib <= bb and ac <= ic and ic <= cc then
				return it
			end
		end
	end
	
	return false
end

function GUI3D:FromScreenToMesh(x, y)
	return GUI3D:IntersectRayWithGUIMesh(EyePos(), GUI3D.OldScreenToVector(x, y))
end
/*
if GUI3D.config.ReplaceConverterFunctions then
	function gui.ScreenToVector(x, y)
		local data = GUI3D:FromMeshToScreen(x, y)
		return GUI3D.OldScreenToVector(data.x, data.y)
	end

	function util.AimVector(ang, fov, x, y, scrw, scrh)
		data = GUI3D:FromMeshToScreen(x, y)
		return GUI3D.OldAimVector(ang, fov, data.x, data.y, scrw, scrh)
	end

	local ErrorReturn = {
		x = -100,
		y = -100,
		visible = false
	}

	function VectorMeta:ToScreen()
		if !GUI3D.OldToScreen(self).visible then
			return ErrorReturn
		end
		
		local pos = GUI3D:IntersectRayWithGUIMesh(self, EyePos() - self)
		
		if pos then
			return GUI3D.OldToScreen(pos)
		else
			return ErrorReturn
		end
	end
end

//Thanks this awesome guy https://facepunch.com/showthread.php?t=1343786
if GUI3D.config.ReplaceBlendFunction then
	GUI3D.OldSetBlend = GUI3D.OldSetBlend or render.SetBlend
	function render.SetBlend(blending)
		if GUI3D:IsPushed() then
			blending = math.Clamp(blending, 0, 0.99)
		end
		
		GUI3D.OldSetBlend(blending)
	end
end

if GUI3D.config.ReplaceUpdateScreenEffectTexture then
	GUI3D.OldUpdateScreenEffectTexture = GUI3D.OldUpdateScreenEffectTexture or render.UpdateScreenEffectTexture
	function render.UpdateScreenEffectTexture()
		local pushed = GUI3D:IsPushed()
		
		if pushed then
			GUI3D:Pop()
		end
		
		GUI3D.OldUpdateScreenEffectTexture()
		
		if pushed then
			GUI3D:Push()
		end
	end
end*/

