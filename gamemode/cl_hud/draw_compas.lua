local nd = 0
local nti = 360 / 10
local noi = 18

local function DrawCompass()

    local lp = LocalPlayer()   
    local size = ScrW()/1.5  
	local x, y = ScrW()/2 + 115, 45
    
	if IsValid(lp) then
        local dir = EyeAngles().y - nd
       
        for i=0, nti -1 do
            local ang = i * 10
			local dif = math.AngleDifference(ang, dir)
            local offang = ( noi*15 )/2.8
           
            if math.abs(dif) < offang then
                local alpha = math.Clamp( 1-(math.abs(dif)/(offang)) , 0, 1 ) * 255
               
               
                local dif2 = size / noi  
                local pos = dif/20 * dif2/1
                local text = ""
                local font = "SmallSymbol"
                local clr = Color(200,200,200,alpha)
               
                if ang % 20 == 0 then
                    text = ang
                    clr = Color(235,235,235,alpha)
				end
				
                if ang == 0 then
                    text = 360
                    font = "BigSymbol"
                    clr = Color(255,255,255,alpha)
                end
				if ang == 180 then
                    text = ang
                    font = "BigSymbol"
                    clr = Color(255,255,255,alpha)
                end
				if ang == 90 then
                    text = ang
                    font = "BigSymbol"
                    clr = Color(255,255,255,alpha)
                end
				if ang == 270 then
                    text = ang
                    font = "BigSymbol"
                    clr = Color(255,255,255,alpha)
                end
               

				draw.DrawText("I\n"..text, font, x - 115 - pos , y - 35, clr, TEXT_ALIGN_CENTER )
                surface.SetDrawColor( Color ( 255, 255, 255, 255) )
				//draw.DrawText("X", "MBDefaultFontLarge", x - 120, y - 35, Color(255,255,255), TEXT_ALIGN_CENTER )
                surface.DrawRect( x - 120+5, y - 35 , 5,2 )  
                surface.DrawRect( x - 120+5, y - 35+9 , 5,2 )             
              			  
            end
           
        end
   
    end
end

hook.Add("HUDPaint", "Platidengi", function()

DrawCompass()

end)