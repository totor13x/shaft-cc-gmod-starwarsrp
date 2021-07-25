local function YawHeadView()
    local ang, bool, sens = Angle(), false, GetConVar('sensitivity'):GetFloat()

    hook.Add('InputMouseApply','SWRP::YawHead.MaxAng',function(cmd,a,o,r)
        if bool then
            ang.p=math.Clamp(ang.p+o*sens/500,-45,45)
            ang.y=math.Clamp(ang.y-a*sens/500,-60,60)
            cmd:SetMouseX(0)
            cmd:SetMouseY(0)
            return true 
        elseif ang.p~=0 or ang.y~=0 then 
            ang.p=math.Approach(ang.p,0,math.max(math.abs(ang.p),0.2)*FrameTime()*10)
            ang.y=math.Approach(ang.y,0,math.max(math.abs(ang.y),0.2)*FrameTime()*10)
        end 
    end)
    hook.Add('PlayerButtonDown','SWRP::YawHead.PlayerButtonDown',function(ply,enum)
        if enum == KEY_LALT and IsFirstTimePredicted() then 
            local vehicle = LocalPlayer():GetVehicle()
            
            if !IsValid(vehicle) then
                bool = true 
            end
        end
    end)
    hook.Add('PlayerButtonUp','SWRP::YawHead.PlayerButtonUp',function(ply,enum)
        if enum == KEY_LALT and IsFirstTimePredicted() then 
            bool = false
        end 
    end)
	hook.Add("SWRP::CalcViewEyes", "SWRP::YawHead.CalcView", function( ply, view )
        if ang.p~=0 or ang.y~=0 then 
            view.angles = view.angles+ang
            return view
        end
    end)
    LastSendNet = 0
    hook.Add("Think", "SWRP::YawHead.SendNet", function()
        SWRP.LastHeadYawAng = ang
        if ang.p~=0 or ang.y~=0 then 
            if LastSendNet > CurTime() then return end
            local newang = Angle(0,0,0)
            newang.r = ang.y
            newang.y = ang.p * -1
            netstreamSWRP.Start("ChangeYawPos", newang)
            LastSendNet = CurTime()+0.1
        end
    end)
end

hook.Add("InitPostEntity", "SWRP::YawHeadView", YawHeadView)
YawHeadView()