SWRP.Props = SWRP.Props or {}
SWRP.Props.Protect = SWRP.Props.Protect or {}
hook.Add("InitPostEntity", "SWRP::PropProtect", function()
	for k, v in pairs( ents.GetAll() ) do
		SWRP.Props.Protect[v] = true
	end
end)
local BlockedEntities = {"func_breakable", "func_physbox", "prop_door_rotating", "prop_dynamic", "ent_money", "gmod_sw_door", "prop_vehicle_pod", "texstickers_carplate", "type_drug", "lithium_obsidian_printer", "npc_lsd_dealer", "sent_base_lsd", "ent_coffee_maker", "lithium_donator_printer", "ent_fire", "savedprop", "env_sun", "gmod_sent", "jukebox", "casinokit_machine", "casinokit_seat", "casinokit_dealernpc", "casinokit_slot_fruits", "casinokit_slot_videobj", "casinokit_slot_videopoker", "casinokit_roulette", "casinokit_craps", "casinokit_blackjack", "sent_arc_slotmachine"}

hook.Add("PhysgunPickup", "SWRP::PropProtectPhysgunPickup", function( pPlayer, eEnt)
	if SWRP.Props.Protect[eEnt] then
		return false
	end

	if table.HasValue( BlockedEntities, eEnt:GetClass() ) then return false end
end)
		
hook.Add("GravGunPickupAllowed", "SWRP::PropProtectGravGunPickupAllowed", function(ply, ent)
	if SWRP.Props.Protect[ent] then
		return false
	end
end)