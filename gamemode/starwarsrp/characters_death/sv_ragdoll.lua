local plyMeta = FindMetaTable("Player")
if !plyMeta.CreateRagdollOld then
	plyMeta.CreateRagdollOld = plyMeta.CreateRagdoll
end

function plyMeta:CreateRagdoll(attacker, dmginfo)

	local ent = ents.Create( "prop_ragdoll" )
	ent:SetNWEntity("RagdollOwner", self)
	ent:SetModel(self:GetModel())
	ent:Spawn()
	

	ent:SetSkin(0)
	for i = 1, #ent:GetBodyGroups() do
		local bg = ent:GetBodyGroups()[i]
		if bg then
			ent:SetBodygroup(i,0)
		end
	end
		
	ent:SetModel(self.Char.model)
	ent:SetBodyGroups(self.Char.bodygroup)
	ent:SetSkin(self.Char.skin)
	
	
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	self:SetNWEntity("DeathRagdoll", ent )
	
	self:Spectate( OBS_MODE_CHASE )
	self:SpectateEntity( ent )
	
	self.DeathTime = CurTime()
	
	ent:SetNWInt("OwnerTimeDeath", CurTime())
	ent:SetNWString("SteamidOw", self:SteamID())
	ent:SetNWString("CharName", self:CharName())
	
	local vel = self:GetVelocity()
	for bone = 0, ent:GetPhysicsObjectCount() - 1 do
		local phys = ent:GetPhysicsObjectNum( bone )
		if IsValid(phys) then
			local pos, ang = self:GetBonePosition( ent:TranslatePhysBoneToBone( bone ) )
			phys:SetPos(pos)
			phys:SetAngles(ang)
			phys:AddVelocity(vel)
		end
	end
	timer.Simple(SWRP.Config.TimeRespawn, function()
		print(self, self:GetNWEntity("DeathRagdoll"))
		if IsValid(ent) then
			local corpse = ent
			corpse.oldname=corpse:GetName()
			corpse:SetName("fizzled"..corpse:EntIndex().."");
			local dissolver = ents.Create( "env_entity_dissolver" );
			if IsValid(dissolver) then
				dissolver:SetPos( corpse:GetPos() );
				dissolver:SetOwner( corpse );
				dissolver:Spawn();
				dissolver:Activate();
				dissolver:SetKeyValue( "target", "fizzled"..corpse:EntIndex().."" );
				dissolver:SetKeyValue( "magnitude", 100 );
				dissolver:SetKeyValue( "dissolvetype", 0 );
				dissolver:Fire( "Dissolve" );
				timer.Simple( 1, function()
					if IsValid(corpse) then 
						corpse:SetName(corpseoldname)
					end
				end)
			end
		end
	end)
	if ent.SetBystanderColor then
		ent:SetBystanderColor(self:GetBystanderColor(true))
	end
end
