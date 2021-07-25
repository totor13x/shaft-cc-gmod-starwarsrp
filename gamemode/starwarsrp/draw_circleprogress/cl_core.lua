
local flat = Material("vgui/white.vtf")
local sin,cos,rad = math.sin,math.cos,math.rad
local CirclePasses = 200
local CircleMargin = 0
local HealthCircleMargin = 0
local HealthCircleWidth = 80+80
local PortraitPos = Vector(0 , 0 )
local TPercent = 0
local scaled = HealthCircleWidth/4
local MarginWidth = 8

SWRP.LastChangeTime = 0
SWRP.CursorProgress = 0
function SWRP:ChangeCProgress(percent)
    SWRP.CursorProgress = percent
    SWRP.CursorLastChangeCursor = 0
    SWRP.CursorProgressLastChangeTick = 0
end
hook.Add("Tick", "Cursor::DrawCircleProgress", function()
    if SWRP.CursorProgress ~= 0 && SWRP.CursorProgress == SWRP.LastChangeCursor then
        if SWRP.CursorProgressLastChangeTick > 4 then
            SWRP.CursorProgressLastChangeTick = 0
            SWRP.CursorProgress = 0
        end
        SWRP.CursorProgressLastChangeTick = SWRP.CursorProgressLastChangeTick + 1
    else
        SWRP.LastChangeCursor = SWRP.CursorProgress
    end
end)

hook.Add("Cursor::Cam3D2D", "Cursor::DrawCircleProgress", function(poscur, angcur)
	poscur = poscur+angcur:Up()*0.4
	cam.Start3D2D(poscur,angcur, 0.03)
    cam.IgnoreZ(true)
    surface.SetMaterial(flat)
    surface.SetDrawColor( 255, 255, 255, 255 )
    for a = 10, math.Clamp( SWRP.CursorProgress / (100/CirclePasses), 0, CirclePasses - 1 ) do
        surface.DrawTexturedRectRotated( 
            PortraitPos.x - cos( rad( -a * 360/CirclePasses -80 ) ) * (HealthCircleWidth/2 - HealthCircleMargin), 
            PortraitPos.y + sin( rad( -a * 360/CirclePasses -80 ) ) * (HealthCircleWidth/2 - HealthCircleMargin), 
            MarginWidth, 
            scaled - sin( rad(360/CirclePasses) ) * HealthCircleWidth * 2, 
            -a * 360/CirclePasses -80
        )
    end
    cam.IgnoreZ(false)
    cam.End3D2D()
end)


local dist = 500
hook.Add("HUDPaint", "IFPP_DotCrosshairDrawCircle", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
		wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep.IsCurrentlyScoped and wep:IsCurrentlyScoped() then return false end

        
	local traceline = {}
	traceline.start = ply:GetShootPos()
	
	traceline.endpos = traceline.start + ply:GetAimVector() * dist
	traceline.filter = ply
	local trace = util.TraceLine(traceline)
	
	local pos = trace.HitPos:ToScreen()
		
	local disat = math.Remap(trace.HitPos:Distance(EyePos()), 0, dist, -100,255)
    //print(disat)
    if disat < 0 then disat = 0 end
    surface.SetMaterial(flat)
    surface.SetDrawColor( 255, 255, 255, disat )
    local width = HealthCircleWidth /6
    local margin = HealthCircleMargin /6
    local scaled_2 = width/6
    local marginwid = MarginWidth/4
    //print(scaled_2)
    for a = 10, math.Clamp( SWRP.CursorProgress / (100/CirclePasses), 0, CirclePasses - 1 ) do
        surface.DrawTexturedRectRotated( 
            pos.x - cos( rad( -a * 360/CirclePasses -80 ) ) * (width/2 - margin), 
            pos.y + sin( rad( -a * 360/CirclePasses -80 ) ) * (width/2 - margin), 
            marginwid, 
            scaled_2 - sin( rad(360/CirclePasses) ) * width * 2, 
            -a * 360/CirclePasses -80
        )
    end
end)