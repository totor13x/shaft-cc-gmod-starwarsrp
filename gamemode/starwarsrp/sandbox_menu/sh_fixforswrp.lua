
--[[---------------------------------------------------------
   Name: gamemode:CanTool( ply, trace, mode )
   Return true if the player is allowed to use this tool
-----------------------------------------------------------]]
function GM:CanTool( ply, trace, mode )

	-- The jeep spazzes out when applying something
	-- todo: Find out what it's reacting badly to and change it in _physprops
	if ( mode == "physprop" && trace.Entity:IsValid() && trace.Entity:GetClass() == "prop_vehicle_jeep" ) then
		return false
	end
	
	-- If we have a toolsallowed table, check to make sure the toolmode is in it
	if ( trace.Entity.m_tblToolsAllowed ) then
	
		local vFound = false	
		for k, v in pairs( trace.Entity.m_tblToolsAllowed ) do
			if ( mode == v ) then vFound = true end
		end

		if ( !vFound ) then return false end

	end
	
	-- Give the entity a chance to decide
	if ( trace.Entity.CanTool ) then
		return trace.Entity:CanTool( ply, trace, mode )
	end

	return true
	 
end



local meta = FindMetaTable( "Player" )

-- Return if there's nothing to add on to
if ( !meta ) then return end

g_SBoxObjects = {}

function meta:CheckLimit( str )

	-- No limits in single player
	if ( game.SinglePlayer() ) then return true end

	local c = cvars.Number( "sbox_max" .. str, 0 )

	if ( c < 0 ) then return true end
	if ( self:GetCount( str ) > c - 1 ) then
		if ( SERVER ) then self:LimitHit( str ) end
		return false
	end

	return true

end

function meta:GetCount( str, minus )

	if ( CLIENT ) then
		return self:GetNWInt( "Count." .. str, 0 )
	end

	minus = minus or 0

	if ( !self:IsValid() ) then return end

	local key = self:UniqueID()
	local tab = g_SBoxObjects[ key ]

	if ( !tab || !tab[ str ] ) then

		self:SetNWInt( "Count." .. str, 0 )
		return 0

	end

	local c = 0

	for k, v in pairs( tab[ str ] ) do

		if ( IsValid( v ) && !v:IsMarkedForDeletion() ) then
			c = c + 1
		else
			tab[ str ][ k ] = nil
		end

	end

	self:SetNWInt( "Count." .. str, math.max( c - minus, 0 ) )

	return c

end

function meta:AddCount( str, ent )

	if ( SERVER ) then

		local key = self:UniqueID()
		g_SBoxObjects[ key ] = g_SBoxObjects[ key ] or {}
		g_SBoxObjects[ key ][ str ] = g_SBoxObjects[ key ][ str ] or {}

		local tab = g_SBoxObjects[ key ][ str ]

		table.insert( tab, ent )

		-- Update count (for client)
		self:GetCount( str )

		ent:CallOnRemove( "GetCountUpdate", function( ent, ply, str ) ply:GetCount( str ) end, self, str )

	end

end

function meta:LimitHit( str )

	self:SendLua( 'hook.Run("LimitHit","' .. str .. '")' )

end

function meta:AddCleanup( type, ent )

	cleanup.Add( self, type, ent )

end

if ( SERVER ) then

	function meta:GetTool( mode )

		local wep = self:GetWeapon( "gmod_tool" )
		if ( !IsValid( wep ) ) then return nil end

		local tool = wep:GetToolObject( mode )
		if ( !tool ) then return nil end

		return tool

	end

	function meta:SendHint( str, delay )

		self.Hints = self.Hints or {}
		if ( self.Hints[ str ] ) then return end

		self:SendLua( 'hook.Run("AddHint","' .. str .. '","' .. delay .. '")' )
		self.Hints[ str ] = true

	end

	function meta:SuppressHint( str )

		self.Hints = self.Hints or {}
		if ( self.Hints[ str ] ) then return end

		self:SendLua( 'hook.Run("SuppressHint","' .. str .. '")' )
		self.Hints[ str ] = true

	end

else

	function meta:GetTool( mode )

		local wep
		for _, ent in pairs( ents.FindByClass( "gmod_tool" ) ) do
			if ( ent:GetOwner() == self ) then wep = ent break end
		end
		if ( !IsValid( wep ) ) then return nil end

		local tool = wep:GetToolObject( mode )
		if ( !tool ) then return nil end

		return tool

	end

end
