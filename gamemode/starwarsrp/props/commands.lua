function CCSpawn( ply, command, arguments )

	-- We don't support this command from dedicated server console
	if ( !IsValid( ply ) ) then return end

	if ( arguments[ 1 ] == nil ) then return end
	if ( arguments[ 1 ]:find( "%.[/\\]" ) ) then return end
	-- Clean up the path from attempted blacklist bypasses
	arguments[ 1 ] = arguments[ 1 ]:gsub( "\\\\+", "/" )
	arguments[ 1 ] = arguments[ 1 ]:gsub( "//+", "/" )
	arguments[ 1 ] = arguments[ 1 ]:gsub( "\\/+", "/" )
	arguments[ 1 ] = arguments[ 1 ]:gsub( "/\\+", "/" )

	//if ( !gamemode.Call( "PlayerSpawnObject", ply, arguments[ 1 ], arguments[ 2 ] ) ) then return end
	if ( !util.IsValidModel( arguments[ 1 ] ) ) then return end
	local iSkin = tonumber( arguments[ 2 ] ) or 0
	local strBody = arguments[ 3 ] or nil

	if ( util.IsValidProp( arguments[ 1 ] ) ) then

		GMODSpawnProp( ply, arguments[ 1 ], iSkin, strBody )
		return

	end

	if ( util.IsValidRagdoll( arguments[ 1 ] ) ) then

		GMODSpawnRagdoll( ply, arguments[ 1 ], iSkin, strBody )
		return

	end

	-- Not a ragdoll or prop.. must be an 'effect' - spawn it as one
	GMODSpawnEffect( ply, arguments[ 1 ], iSkin, strBody )

end
concommand.Add( "gm_spawn", CCSpawn, nil, "Spawns props/ragdolls" )


function GMODSpawnProp( ply, model, iSkin, strBody )

	//if ( !gamemode.Call( "PlayerSpawnProp", ply, model ) ) then return end

	local e = DoPlayerEntitySpawn( ply, "prop_physics", model, iSkin, strBody )
	if ( !IsValid( e ) ) then return end

	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedProp", ply, model, e )
	end

	-- This didn't work out - todo: Find a better way.
	--timer.Simple( 0.01, CheckPropSolid, e, COLLISION_GROUP_NONE, COLLISION_GROUP_WORLD )

	FixInvalidPhysicsObject( e )

	DoPropSpawnedEffect( e )

	undo.Create( "Prop" )
		undo.SetPlayer( ply )
		undo.AddEntity( e )
	undo.Finish( "Prop (" .. tostring( model ) .. ")" )

	ply:AddCleanup( "props", e )

end

function GMODSpawnEffect( ply, model, iSkin, strBody )

	//if ( !gamemode.Call( "PlayerSpawnEffect", ply, model ) ) then return end

	local e = DoPlayerEntitySpawn( ply, "prop_effect", model, iSkin, strBody )
	if ( !IsValid( e ) ) then return end

	if ( IsValid( ply ) ) then
		gamemode.Call( "PlayerSpawnedEffect", ply, model, e )
	end

	if ( IsValid( e.AttachedEntity ) ) then
		DoPropSpawnedEffect( e.AttachedEntity )
	end

	undo.Create( "Effect" )
		undo.SetPlayer( ply )
		undo.AddEntity( e )
	undo.Finish( "Effect (" .. tostring( model ) .. ")" )

	ply:AddCleanup( "effects", e )

end

function DoPlayerEntitySpawn( ply, entity_name, model, iSkin, strBody )

	local vStart = ply:GetShootPos()
	local vForward = ply:GetAimVector()

	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + ( vForward * 2048 )
	trace.filter = ply

	local tr = util.TraceLine( trace )

	-- Prevent spawning too close
	--[[if ( !tr.Hit || tr.Fraction < 0.05 ) then
		return
	end]]

	local ent = ents.Create( entity_name )
	if ( !IsValid( ent ) ) then return end

	local ang = ply:EyeAngles()
	ang.yaw = ang.yaw + 180 -- Rotate it 180 degrees in my favour
	ang.roll = 0
	ang.pitch = 0

	if ( entity_name == "prop_ragdoll" ) then
		ang.pitch = -90
		tr.HitPos = tr.HitPos
	end

	ent:SetModel( model )
	ent:SetSkin( iSkin )
	ent:SetAngles( ang )
	ent:SetBodyGroups( strBody )
	ent:SetPos( tr.HitPos )
	ent:Spawn()
	ent:Activate()

	-- Special case for effects
	if ( entity_name == "prop_effect" && IsValid( ent.AttachedEntity ) ) then
		ent.AttachedEntity:SetBodyGroups( strBody )
	end

	-- Attempt to move the object so it sits flush
	-- We could do a TraceEntity instead of doing all
	-- of this - but it feels off after the old way

	local vFlushPoint = tr.HitPos - ( tr.HitNormal * 512 )	-- Find a point that is definitely out of the object in the direction of the floor
	vFlushPoint = ent:NearestPoint( vFlushPoint )			-- Find the nearest point inside the object to that point
	vFlushPoint = ent:GetPos() - vFlushPoint				-- Get the difference
	vFlushPoint = tr.HitPos + vFlushPoint					-- Add it to our target pos

	if ( entity_name != "prop_ragdoll" ) then

		-- Set new position
		ent:SetPos( vFlushPoint )
		ply:SendLua( "achievements.SpawnedProp()" )

	else

		-- With ragdolls we need to move each physobject
		local VecOffset = vFlushPoint - ent:GetPos()
		for i = 0, ent:GetPhysicsObjectCount() - 1 do
			local phys = ent:GetPhysicsObjectNum( i )
			phys:SetPos( phys:GetPos() + VecOffset )
		end

		ply:SendLua( "achievements.SpawnedRagdoll()" )

	end

	return ent

end
function FixInvalidPhysicsObject( Prop )

	local PhysObj = Prop:GetPhysicsObject()
	if ( !IsValid( PhysObj ) ) then return end

	local min, max = PhysObj:GetAABB()
	if ( !min or !max ) then return end

	local PhysSize = ( min - max ):Length()
	if ( PhysSize > 5 ) then return end

	local min = Prop:OBBMins()
	local max = Prop:OBBMaxs()
	if ( !min or !max ) then return end

	local ModelSize = ( min - max ):Length()
	local Difference = math.abs( ModelSize - PhysSize )
	if ( Difference < 10 ) then return end

	-- This physics object is definitiely weird.
	-- Make a new one.

	Prop:PhysicsInitBox( min, max )
	Prop:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

	local PhysObj = Prop:GetPhysicsObject()
	if ( !IsValid( PhysObj ) ) then return end

	PhysObj:SetMass( 100 )
	PhysObj:Wake()

end