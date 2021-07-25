local CMoveData = FindMetaTable( "CMoveData" )

function CMoveData:RemoveKeys( keys )
	-- Using bitwise operations to clear the key bits.
	local newbuttons = bit.band( self:GetButtons(), bit.bnot( keys ) )
	self:SetButtons( newbuttons )
end

if IsValid(m_Cursor3D2D) then
	m_Cursor3D2D:Remove()
end
local origin = Vector(0, 0, 0)
local angle = Angle(0, 0, 0)
local normal = Vector(0, 0, 0)
local scale = 0
local maxrange = 0

-- Helper functions

local function getCursorPos()
	local p = util.IntersectRayWithPlane(EyePos(), EyeVector(), origin, normal)

	-- if there wasn't an intersection, don't calculate anything.
	if not p then return end
	if WorldToLocal(LocalPlayer():GetShootPos(), Angle(0,0,0), origin, angle).z < 0 then return end

	if maxrange > 0 then
		if p:Distance(LocalPlayer():EyePos()) > maxrange then
			return
		end
	end

	local pos = WorldToLocal(p, Angle(0,0,0), origin, angle)
	return pos.x, -pos.y
end

local function getParents(pnl)
	local parents = {}
	local parent = pnl:GetParent()
	while parent do
		table.insert(parents, parent)
		parent = parent:GetParent()
	end
	return parents
end

local function absolutePanelPos(pnl)
	local x, y = pnl:GetPos()
	local parents = getParents(pnl)
	
	for _, parent in ipairs(parents) do
		local px, py = parent:GetPos()
		x = x + px
		y = y + py
	end
	
	return x, y
end

local function pointInsidePanel(pnl, x, y)
	local px, py = absolutePanelPos(pnl)
	local sx, sy = pnl:GetSize()

	if not x or not y then return end

	x = x / scale
	y = y / scale

	return pnl:IsVisible() and x >= px and y >= py and x <= px + sx and y <= py + sy
end

-- Input

local inputWindows = {}
local usedpanel = {}
local input_trigger = false
local input_trigger_down_stop = false

local function isMouseOver(pnl)
	return pointInsidePanel(pnl, getCursorPos())
end

local function postPanelEvent(pnl, event, ...)
	if not IsValid(pnl) or not pnl:IsVisible() or not pointInsidePanel(pnl, getCursorPos()) then return false end

	local handled = false
	
	for i, child in pairs(table.Reverse(pnl:GetChildren())) do
		if not child:IsMouseInputEnabled() then continue end
		
		if postPanelEvent(child, event, ...) then
			handled = true
			break
		end
	end
	
	if not handled and pnl[event] then
		pnl[event](pnl, ...)
		usedpanel[pnl] = {...}
		return true
	else
		return false
	end
end

-- Always have issue, but less
local function checkHover(pnl, x, y, found)
	if not (x and y) then
		x, y = getCursorPos()
	end

	local validchild = false
	for c, child in pairs(table.Reverse(pnl:GetChildren())) do
		if not child:IsMouseInputEnabled() then continue end
		
		local check = checkHover(child, x, y, found or validchild)

		if check then
			validchild = true
		end
	end

	if found then
		if pnl.Hovered then
			pnl.Hovered = false
			if pnl.OnCursorExited then pnl:OnCursorExited() end
		end
	else
		if not validchild and pointInsidePanel(pnl, x, y) then
			pnl.Hovered = true
			if pnl.OnCursorEntered then pnl:OnCursorEntered() end

			return true
		else
			pnl.Hovered = false
			if pnl.OnCursorExited then pnl:OnCursorExited() end
		end
	end

	return false
end

-- Mouse input
/*

hook.Add("KeyPress", "VGUI3D2DMousePress", function(_, key)
	if input.IsKeyDown(KEY_LALT) and key == (IN_ATTACK or IN_ATTACK2) then
		for pnl in pairs(inputWindows) do
			if IsValid(pnl) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal

				//local key = input.IsKeyDown(KEY_LSHIFT) and MOUSE_RIGHT or MOUSE_LEFT
				
				postPanelEvent(pnl, "OnMousePressed", key)
			end
		end
	end
end)
*/
/*
hook.Add("KeyRelease", "VGUI3D2DMouseRelease", function(_, key)
	//if input.IsKeyDown(KEY_LALT) and key == (IN_ATTACK or IN_ATTACK2) then
	//print(input.IsKeyDown(KEY_LALT), input_trigger)
	//print(input_trigger_down_stop)
	if input.IsKeyDown(KEY_LALT) and key == (IN_ATTACK or IN_ATTACK2) then
		for pnl, key in pairs(usedpanel) do
			if IsValid(pnl) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal

				if pnl["OnMouseReleased"] then
					pnl["OnMouseReleased"](pnl, key[1])
				end
				if pnl["DoClick"] then
					pnl["DoClick"](pnl)
				end

				usedpanel[pnl] = nil
				inputWindows[pnl] = nil
				input_trigger = false
			end
		end
	end
end)
*/
local ba, bn = bit.band, bit.bnot
hook.Add("PlayerButtonDown", "VGUI3D2DPlayerButtonDown", function(_, button)
	if input.IsKeyDown(KEY_LALT) and button == (MOUSE_LEFT or MOUSE_RIGHT) then
		local key = button == MOUSE_LEFT and IN_ATTACK or IN_ATTACK2
		for pnl in pairs(inputWindows) do
			if IsValid(pnl) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal
				
				postPanelEvent(pnl, "OnMousePressed", key)
			end
		end
	end
end)
hook.Add("PlayerButtonUp", "VGUI3D2DPlayerButtonUp", function(_, button)
	if input.IsKeyDown(KEY_LALT) and button == (MOUSE_LEFT or MOUSE_RIGHT) then
		for pnl, key in pairs(usedpanel) do
			if IsValid(pnl) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal

				if pnl["OnMouseReleased"] then
					pnl["OnMouseReleased"](pnl, key[1])
				end
				if pnl["DoClick"] then
					pnl["DoClick"](pnl)
				end

				usedpanel[pnl] = nil
				inputWindows[pnl] = nil
				input_trigger = false
			end
		end
	end
end)

hook.Add( "CreateMove", "Draw::Immersive_NotifKeyPress", function( cmd )
    local ButtonData = cmd:GetButtons()
	if ( m_IsCursorVisible && ba( ButtonData, IN_ATTACK ) > 0 ) then
		cmd:SetButtons( ba( ButtonData, bn( IN_ATTACK  ) ) )
	end
end )


function vgui.Start3D2D(pos, ang, res)
	origin = pos
	scale = res
	angle = ang
	normal = ang:Up()
	maxrange = 0
	
	cam.Start3D2D(pos, ang, res)
end

function vgui.MaxRange3D2D(range)
	maxrange = isnumber(range) and range or 0
end

function vgui.IsPointingPanel(pnl)
	origin = pnl.Origin
	scale = pnl.Scale
	angle = pnl.Angle
	normal = pnl.Normal

	return pointInsidePanel(pnl, getCursorPos())
end

local Panel = FindMetaTable("Panel")
function Panel:Paint3D2D()
	if not self:IsValid() then return end
	
	-- Add it to the list of windows to receive input
	inputWindows[self] = true

	-- Override gui.MouseX and gui.MouseY for certain stuff
	local oldMouseX = gui.MouseX
	local oldMouseY = gui.MouseY
	local cx, cy = getCursorPos()

	function gui.MouseX()
		return (cx or 0) / scale
	end
	function gui.MouseY()
		return (cy or 0) / scale
	end
	
	-- Override think of DFrame's to correct the mouse pos by changing the active orientation
	if self.Think then
		if not self.OThink then
			self.OThink = self.Think
			
			self.Think = function()
				origin = self.Origin
				scale = self.Scale
				angle = self.Angle
				normal = self.Normal
				
				self:OThink()
			end
		end
	end
	
	-- Update the hover state of controls
	local _, tab = checkHover(self)
	
	-- Store the orientation of the window to calculate the position outside the render loop
	self.Origin = origin
	self.Scale = scale
	self.Angle = angle
	self.Normal = normal
	
	-- Draw it manually
	self:SetPaintedManually(false)
		self:PaintManual()
	self:SetPaintedManually(true)

	gui.MouseX = oldMouseX
	gui.MouseY = oldMouseY
end

function vgui.End3D2D()
	cam.End3D2D()
end

function vgui.DrawCursor(Pnl)
	m_IsCursorVisible = false
	local x,y = getCursorPos()
	if IsValid(Pnl) then
		if !IsValid(m_Cursor3D2D) then
			m_Cursor3D2D = vgui.Create( "DImage" )
			m_Cursor3D2D:SetPos( 0, 0 )
			m_Cursor3D2D:SetSize( 16, 16 )
			m_Cursor3D2D:SetImage( "icon16/cursor.png" )
		else
			m_Cursor3D2D:Paint3D2D()
			if (pointInsidePanel(Pnl, x, y)) then
				m_IsCursorVisible = true
				m_Cursor3D2D:SetVisible( true )
				m_Cursor3D2D:SetPos( x/scale,y/scale )
			else
				m_Cursor3D2D:SetVisible( false )
			end
		end
	else
		m_Cursor3D2D:Remove()
	end
end
--[[
	
3D2D VGUI Wrapper
Copyright (c) 2015-2017 Alexander Overvoorde, Matt Stevens

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--


--[[
local origin = Vector(0, 0, 0)
local angle = Angle(0, 0, 0)
local normal = Vector(0, 0, 0)
local scale = 0
local maxrange = 0

-- Helper functions

local function getCursorPos()
	//LocalPlayer():EyePos()
	//EyePos();
	//print(LocalPlayer():GetAimVector())
	/*

	local startpos = LocalPlayer():EyePos()
	local angles = EyeAngles()
	local endpos = startpos
	endpos:Rotate(angles) // angles:Forward()*600
	endpos = endpos + angles:Forward()*2e3 
	*/
	//print(endpos:Distance(startpos ), ' ----------')
	 
	local startpos = EyePos()
	local endpos = startpos + EyeVector():Angle():Forward()*20000 
	local engtest = LocalToWorld(Vector(0,300/20,0),Angle(0,-90,90), endpos, EyeAngles())
	//print(endpos)  
	//print(origin) 
	
	local p = util.IntersectRayWithPlane(startpos, engtest, origin, normal)
	-- if there wasn't an intersection, don't calculate anything.
	if not p then return end
	if WorldToLocal(LocalPlayer():GetShootPos(), Angle(0,0,0), origin, angle).z < 0 then return end
	if maxrange > 0 then
		if p:Distance(LocalPlayer():EyePos()) > maxrange then
			return
		end
	end
	//print(p)
	local pos = WorldToLocal(p, Angle(0,0,0), origin, angle) 
	return pos.x, -pos.y
end

local function getParents(pnl)
	local parents = {}
	local parent = pnl:GetParent()
	while parent do
		table.insert(parents, parent)
		parent = parent:GetParent()
	end
	return parents
end

local function absolutePanelPos(pnl)
	local x, y = pnl:GetPos()
	local parents = getParents(pnl)
	
	for _, parent in ipairs(parents) do
		local px, py = parent:GetPos()
		x = x + px
		y = y + py
	end
	
	return x, y
end

local function pointInsidePanel(pnl, x, y)
	local px, py = absolutePanelPos(pnl)
	local sx, sy = pnl:GetSize()

	if not x or not y then return end

	x = x / scale
	y = y / scale

	return pnl:IsVisible() and x >= px and y >= py and x <= px + sx and y <= py + sy
end

-- Input

local inputWindows = {}
local usedpanel = {}

local function isMouseOver(pnl)
	return pointInsidePanel(pnl, getCursorPos())
end

local function postPanelEvent(pnl, event, ...)
	if not IsValid(pnl) or not pnl:IsVisible() or not pointInsidePanel(pnl, getCursorPos()) then return false end

	local handled = false
	
	for i, child in pairs(table.Reverse(pnl:GetChildren())) do
		if not child:IsMouseInputEnabled() then continue end
		
		if postPanelEvent(child, event, ...) then
			handled = true
			break
		end
	end
	
	if not handled and pnl[event] then
		pnl[event](pnl, ...)
		usedpanel[pnl] = {...}
		return true
	else
		return false
	end
end

-- Always have issue, but less
local function checkHover(pnl, x, y, found)
	if not (x and y) then
		x, y = getCursorPos()
	end
	local validchild = false
	for c, child in pairs(table.Reverse(pnl:GetChildren())) do
		if not child:IsMouseInputEnabled() then continue end
		
		local check = checkHover(child, x, y, found or validchild)

		if check then
			validchild = true 
		end
	end
	print(x,y,validchild) 
	if found then
		if pnl.Hovered then
			pnl.Hovered = false
			if pnl.OnCursorExited then pnl:OnCursorExited() end
		end
	else
		if not validchild and pointInsidePanel(pnl, x, y) then
			pnl.Hovered = true
			if pnl.OnCursorEntered then pnl:OnCursorEntered() end

			return true
		else
			pnl.Hovered = false
			if pnl.OnCursorExited then pnl:OnCursorExited() end
		end
	end

	return false
end

-- Mouse input

hook.Add("KeyPress", "VGUI3D2DMousePress", function(_, key)
	
	if key == IN_WALK then
		for pnl in pairs(inputWindows) do
			if IsValid(pnl) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal

				//local key = input.IsKeyDown(KEY_LSHIFT) and MOUSE_RIGHT or MOUSE_LEFT
				local key = MOUSE_RIGHT or MOUSE_LEFT
				postPanelEvent(pnl, "OnMousePressed", key)
			end
		end
	end
	
end)

hook.Add("KeyRelease", "VGUI3D2DMouseRelease", function(_, key)
	if key == IN_WALK then
		for pnl, key in pairs(usedpanel) do
			if IsValid(pnl) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				normal = pnl.Normal

				if pnl["OnMouseReleased"] then
					pnl["OnMouseReleased"](pnl, key[1])
				end

				usedpanel[pnl] = nil
			end
		end
	end
	
end)

function vgui.Start3D2D(pos, ang, res)
	origin = pos
	scale = res
	angle = ang
	normal = ang:Up()
	maxrange = 0
	
	cam.Start3D2D(pos, ang, res)
end

function vgui.MaxRange3D2D(range)
	maxrange = isnumber(range) and range or 0
end

function vgui.IsPointingPanel(pnl)
	origin = pnl.Origin
	scale = pnl.Scale
	angle = pnl.Angle
	normal = pnl.Normal

	return pointInsidePanel(pnl, getCursorPos())
end

local Panel = FindMetaTable("Panel")
function Panel:Paint3D2D()
	if not self:IsValid() then return end
	
	-- Add it to the list of windows to receive input
	inputWindows[self] = true

	-- Override gui.MouseX and gui.MouseY for certain stuff
	local oldMouseX = gui.MouseX
	local oldMouseY = gui.MouseY
	local cx, cy = getCursorPos()

	function gui.MouseX()
		return (cx or 0) / scale
	end
	function gui.MouseY()
		return (cy or 0) / scale
	end
	
	-- Override think of DFrame's to correct the mouse pos by changing the active orientation
	if self.Think then
		if not self.OThink then
			self.OThink = self.Think
			
			self.Think = function()
				origin = self.Origin
				scale = self.Scale
				angle = self.Angle
				normal = self.Normal
				
				self:OThink()
			end
		end
	end
	
	-- Update the hover state of controls
	local _, tab = checkHover(self)
	
	-- Store the orientation of the window to calculate the position outside the render loop
	self.Origin = origin
	self.Scale = scale
	self.Angle = angle
	self.Normal = normal
	
	-- Draw it manually
	self:SetPaintedManually(false)
		self:PaintManual()
	self:SetPaintedManually(true)

	gui.MouseX = oldMouseX
	gui.MouseY = oldMouseY
end

function vgui.End3D2D()
	cam.End3D2D()
end
]]--