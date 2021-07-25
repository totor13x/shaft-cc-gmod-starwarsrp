local meta = FindMetaTable("Player")
function meta:IsTyping()
	if self.Typing then
		return true
	end
    if self.Talking && self:GetNWBool("is_radio") then
        return true
    end
	return false
end

hook.Add("SWRP::FinishChat", "SWRP::IsTyping.Finish", function()
    netstreamSWRP.Start("SWRP::Typing", false)
end)

hook.Add("SWRP::StartChat", "SWRP::IsTyping.Start", function()
    netstreamSWRP.Start("SWRP::Typing", true)
end)

netstreamSWRP.Hook("SWRP::TypingSync", function(ply, bool)
    if IsValid(ply) then
		ply.Typing = bool
	end
end)