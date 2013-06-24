AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "ClavusElite"
ENT.Purpose			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

util.PrecacheModel("models/Items/BoxSRounds.mdl")
util.PrecacheSound("items/ammo_pickup.wav")

if CLIENT then

	function ENT:Draw()
		self.BaseClass.Draw(self)
	end

	function ENT:OnRemove()
	end

	function ENT:Think()	
	end
end

if SERVER then

	function ENT:Initialize()
		self.Entity:SetModel("models/Items/BoxSRounds.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self.Entity:DrawShadow( true )
		self.active = false
		self:SetTrigger(true)
		timer.Simple(1,function() self.active = true end)
	end	
	
	function ENT:StartTouch( ent )
		if self.active and ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() == 0 then
			local weps = ent:GetWeapons()
			local atype = ""
			for k, v in pairs(weps) do
				if v:IsValid() and v:GetPrimaryAmmoType() ~= nil then
					if v:GetPrimaryAmmoType() == "grenade" then
						ent:GiveAmmo(1, v:GetPrimaryAmmoType())
					else
						local clips = 1
						if v:Clip1() <= 20 then
							clips = 3
						elseif v:Clip1() <= 50 then
							clips = 2
						elseif v:Clip1() <= 100 then
							clips = 1
						end
						
						ent:GiveAmmo(math.ceil(v:Clip1()*clips), v:GetPrimaryAmmoType())
					end
				end
			end
			timer.Simple(0,function () self:Remove() end)
			function self:StartTouch() end
		end
	end
	
	function ENT:OnRemove()
		active = false
	end

end
