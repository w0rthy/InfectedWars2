//ROTTEN FLESH
local tick = 0
function RottenFlesh()
	if tick > CurTime() then return end
	for k, v in pairs(player.GetAll()) do
		if v:Team() == 1 and v:GetUtility() == 2 then
			for ke, va in pairs(ents.FindInSphere( v:GetPos(), 128 )) do
				if va:IsPlayer() and va:Alive() and va:IsValid() and va:Team() == 0 then va:TakeDamage( 1, v, v ) end
			end
		end
	end
	tick = CurTime()+0.5
end
hook.Add( "Think", "RottenFlesh", RottenFlesh )

//ON KILL ACHIEVEMENTS
function OnKillAchievements( ply, attacker, dmginfo )
	if ply:Team() == 1 then
		//FIRST ONE ACHIEVEMENT
		UnlockAchievement( attacker, "firstone" )
		//SPRAY N PREY
		if attacker.pweapon == 4 and attacker:Frags()>=4 then UnlockAchievement( attacker, "spray" ) end
		//PISTOL PETE
		if attacker.sweapon == 1 and attacker:Frags()>=9 then UnlockAchievement( attacker, "pete" ) end
		//MARKSMAN
		if attacker:GetPos():Distance(ply:GetPos()) >= 1560 then UnlockAchievement( attacker, "marksman" ) end
	end
end
hook.Add( "DoPlayerDeath", "OnKillAchievements", OnKillAchievements )