if true then return end
local ments

local radialOpen = false
local prevSelected, prevSelectedVertex

function SWRP:OpenRadialMenu(elements)
	radialOpen = true
	gui.EnableScreenClicker(true)
	ments = elements or {}
	prevSelected = nil
end

function SWRP:CloseRadialMenu()
	radialOpen = false
	gui.EnableScreenClicker(false)
end

local function getSelected()
	local mx, my = gui.MousePos()
	local sw,sh = ScrW(), ScrH()
	local total = #ments
	local w = math.min(sw * 0.45, sh * 0.45)
	local h = w
	local sx, sy = sw / 2, sh / 2
	local x2,y2 = mx - sx, my - sy
	local ang = 0
	local dis = math.sqrt(x2 ^ 2 + y2 ^ 2)
	if dis / w <= 1 then
		if y2 <= 0 && x2 <= 0 then
			ang = math.acos(x2 / dis)
		elseif x2 > 0 && y2 <= 0 then
			ang = -math.asin(y2 / dis)
		elseif x2 <= 0 && y2 > 0 then
			ang = math.asin(y2 / dis) + math.pi
		else
			ang = math.pi * 2 - math.acos(x2 / dis)
		end
		return math.floor((1 - (ang - math.pi / 2 - math.pi / total) / (math.pi * 2) % 1) * total) + 1
	end
end

function SWRP:RadialMousePressed(code, vec)
	if radialOpen then
		local selected = getSelected()
		if selected && selected > 0 && code == MOUSE_LEFT then
			if selected && ments[selected] then
			//print(ments[selected].Code)
			local anotherarg = nil
			if ments[selected].Code == 'think' or ments[selected].Code == 'see' then
				anotherarg = LocalPlayer():GetNWString("LastLooked")
			end
				RunConsoleCommand("mu_taunt", ments[selected].Code, anotherarg)
			end
		end
		self:CloseRadialMenu()
	end
end

local elements
local function addElement(transCode, code)
	local t = {}
	t.TransCode = transCode
	t.Code = code
	table.insert(elements, t)
end

concommand.Add("+menu", function (client, com, args, full)
	if client:Alive() && client:Team() == 2 then
		elements = {}
		addElement("Хелп!", "help")
		addElement("Пошутить", "funny")
		addElement("Крикнуть", "scream")
        addElement("Мрачный", "morose")

		SWRP:OpenRadialMenu(elements)
	end
end)

concommand.Add("-menu", function (client, com, args, full)
	SWRP:RadialMousePressed(MOUSE_LEFT)
end)

local tex = surface.GetTextureID("VGUI/white.vmt")

local circleVertex

local fontHeight = draw.GetFontHeight("S_Light_20")
function SWRP:DrawRadialMenu()
	if radialOpen then
		local sw,sh = ScrW(), ScrH()
		local total = #ments
		local w = math.min(sw * 0.45, sh * 0.45)
		local h = w
		local sx, sy = sw / 2, sh / 2

		local selected = getSelected() or -1


		if !circleVertex then
			circleVertex = {}
			local max = 50
			for i = 0, max do
				local vx, vy = math.cos((math.pi * 2) * i / max), math.sin((math.pi * 2) * i / max)

				table.insert(circleVertex, {x = sx + w* 1 * vx, y= sy + h* 1 * vy})
			end
		end

		surface.SetTexture(tex)
		local defaultTextCol = color_white
		if selected <= 0 || selected ~= selected then
			surface.SetDrawColor(20,20,20,180)
		else
			surface.SetDrawColor(20,20,20,120)
			defaultTextCol = Color(150,150,150)
		end
		surface.DrawPoly(circleVertex)

		local add = math.pi * 1.5 + math.pi / total
		local add2 = math.pi * 1.5 - math.pi / total

		for k,ment in pairs(ments) do
			local x,y = math.cos((k - 1) / total * math.pi * 2 + math.pi * 1.5), math.sin((k - 1) / total * math.pi * 2 + math.pi * 1.5)

			local lx, ly = math.cos((k - 1) / total * math.pi * 2 + add), math.sin((k - 1) / total * math.pi * 2 + add)

			local textCol = defaultTextCol
			if selected == k then
				local vertexes = prevSelectedVertex

				if prevSelected != selected then
					prevSelected = selected
					vertexes = {}
					prevSelectedVertex = vertexes
					local lx2, ly2 = math.cos((k - 1) / total * math.pi * 2 + add2), math.sin((k - 1) / total * math.pi * 2 + add2)

					table.insert(vertexes, {x = sx, y = sy})

					table.insert(vertexes, {x = sx + w* 1 * lx2, y= sy + h* 1 * ly2})

					local max = math.floor(50 / total)
					for i = 0, max do
						local addv = (add - add2) * i / max + add2
						local vx, vy = math.cos((k - 1) / total * math.pi * 2 + addv), math.sin((k - 1) / total * math.pi * 2 + addv)

						table.insert(vertexes, {x = sx + w* 1 * vx, y= sy + h* 1 * vy})
					end

					table.insert(vertexes, {x = sx + w* 1 * lx, y= sy + h* 1 * ly})

				end

				surface.SetTexture(tex)
				surface.SetDrawColor(20,120,255,120)
				surface.DrawPoly(vertexes)

				textCol = color_white
			end

			drawTextShadow(ment.TransCode, "S_Light_30", sx + w * 0.6 * x, sy + h * 0.6 * y - fontHeight / 3,textCol, 1)

		end
	end
end
