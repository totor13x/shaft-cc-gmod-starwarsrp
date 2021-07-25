local meta = FindMetaTable('Player')

//Для прикольных сорсовских анимаций
function meta:DoAnim(animID)
    self:AnimRestartGesture(GESTURE_SLOT_CUSTOM, animID, true)
    netstreamSWRP.Start(_, "SWRP::DoAnim", self, animID)
end

//Для своих анимаций
function meta:EnableCustomGesture(seq)
    self:SetNWBool("SWRP.Anim.Gestured::Enabled", true)
    self:SetNWString("SWRP.Anim.Gestured::Animation", seq) 
end
function meta:DisableCustomGesture()
    self:SetNWBool("SWRP.Anim.Gestured::Enabled", false)
end

//Для прикольных своих секьенсев
function meta:DoAnimCustom(animID)
    netstreamSWRP.Start(_, "SWRP::DoAnimCustom", self, animID)
end
