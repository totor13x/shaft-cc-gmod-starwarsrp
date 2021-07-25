SWRP.Ents = SWRP.Ents or {}

print('entis')

function SWRP.Ents:RegisterItem( tblItem )
	self.m_tblItemRegister = self.m_tblItemRegister or {}
	self.m_tblItemRegister[tblItem.Name] = tblItem
	print( "\t\tRegistered item ".. tblItem.Name )
end

function SWRP.Ents:RegisterItemLimit( ID, number )
	//self.m_tblItemRegister[tblItem.Name] = tblItem
	//print( "\t\tRegistered item ".. tblItem.Name )
end


function SWRP.Ents:GetItems()
	return self.m_tblItemRegister
end

function SWRP.Ents:GetItem( strItemName )
	return self.m_tblItemRegister[strItemName]
end

function SWRP.Ents:MakeItemDrop( pOwner, strItemID, intAmount, bOwnerless )
	local itemData = self:GetItem( strItemID )
	if not itemData or not itemData.CanDrop then return false end

	local tr = util.TraceLine{
		start = pOwner:GetShootPos(),
		endpos = pOwner:GetShootPos() +pOwner:GetAimVector() *150,
		filter = pOwner,
	}
	local spawnPos = tr.HitPos

	for i = 1, intAmount do
		if itemData.DropFunction then
			itemData.DropFunction( pOwner, spawnPos, Angle(0, pOwner:GetAimVector():Angle().y, 0), bOwnerless )
		end

		local ent = ents.Create( itemData.DropClass or "prop_physics" )
		ent:SetAngles( Angle(0, pOwner:GetAimVector():Angle().y, 0) )
		ent:SetModel( itemData.Model )
		if itemData.Skin then ent:SetSkin( itemData.Skin ) end
		ent.IsItem = true
		ent.ItemID = strItemID
		ent.ItemData = itemData
		ent.CreatedBy = pOwner
		ent.CreatedBySID = pOwner:SteamID()
		ent:Spawn()
		ent:Activate()
		ent:SetPos( spawnPos )
		if not bOwnerless then ent:SetPlayerOwner( pOwner ) end

		local vFlushPoint = spawnPos -(tr.HitNormal *512)
		vFlushPoint = ent:NearestPoint( vFlushPoint )
		vFlushPoint = ent:GetPos() -vFlushPoint
		vFlushPoint = spawnPos +vFlushPoint +Vector(0, 0, 2)
		ent:SetPos( vFlushPoint )
		
		if itemData.SetupEntity then
			itemData:SetupEntity( ent )
		end

		table.insert(pOwner.m_tblItemSpawn, ent) // %Remove this
		hook.Run( "PlayerDropItem", GAMEMODE, pOwner, strItemID, bOwnerless, ent )
		hook.Call( "PlayerDroppedItem", GAMEMODE, pOwner, strItemID, bOwnerless, ent )
	end

	return true
end

hook.Add("PlayerDisconnected", function ( ply )
	pPlayer.m_tblItemSpawn = pPlayer.m_tblItemSpawn or {} 
	for i,v in pairs(pPlayer.m_tblItemSpawn) do
		SafeRemoveEntity(v)
	end
end) 

hook.Add("PlayerDropItem", function (pPlayer, strItemID, bOwnerless, ent )
	pPlayer.m_tblItemSpawn = pPlayer.m_tblItemSpawn or {}
	print(pPlayer, strItemID, bOwnerless, ent )
	table.insert(pPlayer.m_tblItemSpawn, ent)
end)
if SERVER then 
	concommand.Add("__create_item", function( pPlayer, strCmd, tblArgs )
		local id = tblArgs[1]
		pPlayer.m_tblItemSpawn = pPlayer.m_tblItemSpawn or {}
		print(table.Count(pPlayer.m_tblItemSpawn))
		if #pPlayer.m_tblItemSpawn > 25 then
			local data = {} 
			data.text, data.type, data.length = "Лимит по пропам", NOTIFY_ERROR, 7
			netstreamSWRP.Start( pPlayer, "GM:Notification", data )
			return 
		end
		
		SWRP.Ents:MakeItemDrop( pPlayer, id, 1, true )
	end)
end