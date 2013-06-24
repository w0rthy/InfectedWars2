AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("db.lua")
AddCSLuaFile("player.lua")
include('shared.lua')
include('db.lua')
include('sv_player.lua')
include('savesys.lua')
include('broadcast.lua')
include('content.lua')

ROUNDSTART = ROUNDSTART or 0
ROUNDSTOP = ROUNDSTOP or 0
ROUNDACTIVE = ROUNDACTIVE or false
LASTSTAND = LASTSTAND or false
LASTSTANDSTART = LASTSTNADSTART or 0
LASTSTANDSTOP = LASTSTANDSTOP or 0
LASTSTANDNICK = LASTSTANDNICK or ""
ROUNDNUM = ROUNDNUM or 0
WINNER = WINNER or 0

function GM:Initialize()
	print( "beginning content mounting" )
	files = {
		"materials/infectedwars/HUD/armorhit.vmt",
		"materials/infectedwars/bullet.vmt",
		"materials/infectedwars/HUD/crosshair4.vmt",
		"materials/infectedwars/HUD/gradient2.vmt",
		"materials/infectedwars/HUD/HHUD.vmt",
		"materials/infectedwars/HUD/ZHUD.vmt",
		"materials/infectedwars/HUD/HUD_assault.vmt",
		"materials/infectedwars/HUD/HUD_zombie.vmt",
		"materials/infectedwars/sniper_corner.vmt",
		"materials/infectedwars/specialforces.vmt",
		"materials/infectedwars/undeadlegion.vmt",
		"materials/infectedwars/armor.vmt",
		"materials/infectedwars/vision.vmt",
		"materials/infectedwars/speed.vmt",
		"materials/infectedwars/regen.vmt",
		"materials/effects/infectedwars/black_tracer.vmt",
		"resource/fonts/doom.ttf",
		"resource/fonts/HL2MP.ttf",
		"sound/infectedwars/bomb_beep.wav",
		"sound/infectedwars/hornetgun.wav",
		"sound/infectedwars/iw_lasthuman.mp3",
		"sound/infectedwars/scream.wav",
		"sound/infectedwars/swarmblaster.wav",
		"materials/infectedwars/laststand.vmt"}
	for k = 1, #files do
		print( "mounting content: "..files[k] )
		resource.AddFile( files[k] )
	end
	if ROUNDACTIVE == false then
	StartRound()
	print("Round has started") end
end

MapList = {
	"cs_assault",
	"cs_compound",
	"cs_havana",
	"cs_office",
	"cs_wolfenstein",
	"de_cbble",
	"de_port",
	"de_piranesi",
	"de_nuke",
	"de_prodigy",
	"cs_italy",
	"dm_baclcony_beta4",
	"dm_outlying_v2",
	"dm_biohazard",
	"de_train",
	"dm_iw_metalgrounds"
}

function GetNextMap()
	LASTPLAYED = LASTPLAYED or ""
	local nextmap = ""
	while( nextmap == "" ) do
	local rand = table.Random( MapList )
	if rand != LASTPLAYED and rand != game.GetMap() then
		nextmap = rand
		LASTPLAYED = game.GetMap() end
	end
	return nextmap
end

function StartRound()
	ROUNDSTART=CurTime()
	ROUNDACTIVE=true
	ROUNDNUM=ROUNDNUM+1
	for k, v in pairs( player.GetAll() ) do
		GAMEMODE:SendTime( v, ROUNDSTART )
		v.InfKills = 0
		v.HumKills = 0
		v:SetFrags( 0 )
		v:SetDeaths( 0 )
		v:SetTeam( 0 )
		v:StripWeapons()
		SetData( v, "round" )
		v:Spawn()
	end
	timer.Simple(30, function() SelectInfected() end )
end

function SelectInfected()
	if team.NumPlayers( 0 ) > 1 then
		local toSelect = 1
		if team.NumPlayers( 0 ) > 5 then toSelect = 2 end
		if team.NumPlayers( 0 ) > 10 then toSelect = 3 end
		if team.NumPlayers( 0 ) > 15 then toSelect = 4 end
		toSelect = toSelect - team.NumPlayers( 1 )
		if toSelect <= 0 then return end
		selected = {}
		for k = 1, toSelect do
			selected[k] = table.Random( team.GetPlayers( 0 ) )
		end
		for k, v in pairs(selected) do
			for j, i in pairs(player.GetAll()) do
				i:PrintMessage( HUD_PRINTTALK, v:Nick().." has been selected to join the Infected." )
			end
			v:SetVelocity( Vector( 0, 0, 3000 ) )
			v:EmitSound("npc/strider/fire.wav")
			timer.Simple( 0.1, function()
				if v:IsValid() then
					v:Kill()
				end 
			end)
		end
	end
end

function GM:PlayerInitialSpawn( ply )
	ply:SetFrags( 0 )
	ply:SetDeaths( 0 )
	ply.InfKills = 0
	ply.HumKills = 0
	
	if CurTime()>ROUNDSTART+180 then
		ply:SetTeam(1) else ply:SetTeam(0)
		end
	savetimer = savetimer + 1
	GAMEMODE:ReadData( ply )
	SetData( ply, "init" )
	SetData( ply, "round" )
	GAMEMODE:SendAchieves( ply )
end

function GM:PlayerSpawn( ply )
	if ply:IsValid() and ROUNDACTIVE == true then ply:Lock() end
	SetData( ply, "life" )
	timer.Simple( 1, function()
		if ply:IsValid() then
		net.Start( "Loadout" )
		net.Send( ply )
		ply:GodEnable()
		ply:SetNoCollideWithTeammates( true )
		if ply:Team() == 0 then
			ply:SetModel( classes.human[1].pmodel )
		else
			ply:SetModel( classes.infected[1].pmodel )
		end
		//spawn protection
		timer.Simple( 7, function()
			ply:GodDisable()
		end)
		end 
	end)
end

function GM:PlayerAuthed( ply, sid, uid )
	print("Player "..ply:Nick().." has been authenticated with UID: "..uid)
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	if ply:Team()==1 then
		ply:AddDeaths( 1 )
		ply.Data.Global["deaths"] = ply.Data.Global["deaths"] + 1
		local rand = math.random( 100 )
		if rand>0 and rand<35 then
			SpawnAmmo( ply:GetPos()+Vector( 0, 0, 50 ) )
		end
	end
	if ply:Team()==0 then ply:SetTeam(1) ply.Data.Global["deaths"] = ply.Data.Global["deaths"] + 1 end
	ply:CreateRagdoll()
	if attacker:IsValid() and attacker:IsPlayer() then
		if attacker != ply then
			AddKill( attacker )
		end
	end
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	
	 if ( hitgroup == HITGROUP_HEAD ) then
		//HELMET UTILITY
		if ply:Team()==0 and ply:GetUtility() == 3 then
		dmginfo:ScaleDamage( 0.7 )
		else
		dmginfo:ScaleDamage( 1.4 )
		if ply:Team()==1 then UnlockAchievement( dmginfo:GetAttacker(), "headshot" ) end
		if ply:Team()==1 and dmginfo:GetAttacker().pweapon == 5 then UnlockAchievement( dmginfo:GetAttacker(), "hipower" ) end
		end
	 
	 else
		dmginfo:ScaleDamage( 0.7 )
	end

	return dmginfo 
end

function GM:ShouldCollide( ent1, ent2 )
	if ((ent1:IsPlayer() and ent2:IsPlayer()) and ent1:Team() == ent2:Team()) then return false
	end
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	if ( attacker:IsPlayer() and attacker:Team() == ply:Team() ) then
		return false
	end
	return true
end

function GM:EntityTakeDamage( ent, dmg )
	/*if dmg:GetAttacker():IsValid() and dmg:GetAttacker():IsPlayer() then
			for k, v in pairs(classes.human[dmg:GetAttacker():GetClass()].bonus) do
				if dmg:GetAttacker():GetActiveWeapon():GetPrimaryAmmoType()!=3 and dmg:GetAttacker():GetActiveWeapon():GetPrimaryAmmoType()!=-1 then
					if dmg:GetAttacker():Team()==0 then
						if v == pweapons.human[dmg:GetAttacker().pweapon].type then
							dmg:SetDamage(dmg:GetDamage()*1.15)
						end
					else
						if v == pweapons.infected[dmg:GetAttacker().pweapon].type then
							dmg:SetDamage(dmg:GetDamage()*1.15)
						end
					end
				else
					if dmg:GetAttacker():Team()==0 then
						if v == sweapons.human[dmg:GetAttacker().sweapon].type then
							dmg:SetDamage(dmg:GetDamage()*1.15)
						end
					else
						if v == sweapons.infected[dmg:GetAttacker().sweapon].type then
							dmg:SetDamage(dmg:GetDamage()*1.15)
						end
					end
				end
			end
		end*/
	if ent:IsPlayer() and ent:Team() == 0 then
		if ent:GetSuitMode()==0 and ent:GetSuit() > 0 then
			ent:SetSuit( math.Max(ent:GetSuit()-dmg:GetDamage(),0) )
			dmg:SetDamage( math.Max(dmg:GetDamage() - (ent:GetSuit()+dmg:GetDamage()), 0) )
		end
	end
	dmg:GetAttacker().leeched = dmg:GetAttacker().leeched or 0
	if dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():Team() == 1 and dmg:GetAttacker():GetUtility()==1 and ent:IsPlayer() then dmg:GetAttacker():SetHealth(math.min(dmg:GetAttacker():Health()+math.ceil(dmg:GetBaseDamage()*0.2),dmg:GetAttacker():GetMHealth())) dmg:GetAttacker().leeched = dmg:GetAttacker().leeched + dmg:GetBaseDamage()*0.2 end
	if dmg:GetAttacker().leeched >= 100 then UnlockAchievement( dmg:GetAttacker(), "leech" ) end
	if ent:IsPlayer() then GAMEMODE:SendHit( ent ) end
	
	if dmg:GetAttacker():IsPlayer() then
	dmg:GetAttacker().Data.Round.Damage = dmg:GetAttacker().Data.Round.Damage + dmg:GetDamage()
	dmg:GetAttacker().Data.Life.Damage = dmg:GetAttacker().Data.Life.Damage + dmg:GetDamage()
	dmg:GetAttacker().Data.Global["damage"] = dmg:GetAttacker().Data.Global["damage"] + dmg:GetDamage()
	end
	return dmg
end

function GM:Think()
	suittimer = suittimer or 0
	savetimer = savetimer or 0
	stattimer = stattimer or 0
	if ROUNDACTIVE == true then
		if team.NumPlayers( 0 ) == 1 and team.NumPlayers( 1 ) > 0 and LASTSTAND == false then LastStand() end
		if team.NumPlayers( 0 ) <= 0 and team.NumPlayers( 1 ) > 1 then WINNER = 1 EndRound() end
		if 960<=CurTime()-ROUNDSTART then WINNER = 0 EndRound() end
		local deaths = 0
		for k, v in pairs(team.GetPlayers( 1 )) do deaths = deaths + v:Deaths() end
		if (team.NumPlayers( 1 )*5+30-deaths) <= 0 then WINNER = 0 EndRound() end
		if LASTSTAND == true and team.NumPlayers( 0 ) == 0 then WINNER = 1 EndRound() end
	end
	if (suittimer < CurTime()) then
		for k, ply in pairs( player.GetAll() ) do
			if ROUNDACTIVE == false then ply:Lock() end
			if ply:Team()==0 and ply:GetActiveWeapon():IsValid() then
				//HUMANS
				if  !(ply:GetSuit() > 0) then GAMEMODE:PlayClientSound( ply, 2 ) end
				if ply:GetSuitMode() == 2 and ply:GetSuit() <= 0 then ply:ChangeSuit( tempagil ) end
				if ply:GetSuitMode() != 0 then
					if ply:GetUtility() == 2 and ply:GetSuitMode() == 1 then
						ply:SetSuit( math.Max(math.Min( ply:GetSuit()-suitmodes[ply:GetSuitMode()].drain*1.34, ply:GetSuitMax()),0))
					else
						ply:SetSuit( math.Max(math.Min( ply:GetSuit()-suitmodes[ply:GetSuitMode()].drain, ply:GetSuitMax()),0))
					end
				end
				if ply:GetSuitMode() == 1 then ply:SetHealth( math.Min( ply:Health()+1, ply:GetMHealth() ) ) end
			end
		end
		suittimer = CurTime()+0.8
	end
	if savetimer <= CurTime() then
		savetimer = CurTime() + 30
		for k, v in pairs(player.GetAll()) do
			GAMEMODE:WriteData( v )
		end
	end
	if stattimer < CurTime() then
		stattimer = CurTime() + 10
		for k, v in pairs(player.GetAll()) do
			net.Start( "Stats" )
			net.WriteTable( v.Data.Global )
			net.Send( v )
		end
	end
end

function LastStand()
	LASTSTANDSTART = CurTime()
	LASTSTAND = true
	LASTSTANDNICK = team.GetPlayers(0)[1]:Nick()
	for k, v in pairs(player.GetAll()) do
		GAMEMODE:SendPaint( v )
		GAMEMODE:PlayClientSound( v, 6 )
	end
end

function CheckRAchieves()
	for k, v in pairs(player.GetAll()) do
	end
end

function EndRound()
	CheckRAchieves()
	LASTSTANDSTOP = CurTime()
	ROUNDACTIVE = false
	ROUNDSTOP = CurTime()
	LASTSTAND = false
	GAMEMODE:SendStopSounds( )
	for k, v in pairs(player.GetAll()) do
	GAMEMODE:SendFinalStats( v )
	GAMEMODE:WriteData( v )
	end
	timer.Simple(25, function()
		if ROUNDNUM >= 2 then RunConsoleCommand( "changelevel", GetNextMap() )
		else StartRound()
		end
	end)
		
end

function GM:PlayerSelectSpawn( ply )
	if ply:Team()==0 then
		return table.Random(HumanSpawns)
	else
		return table.Random(InfectedSpawns)
	end
end

function GM:KeyPress( ply, key )
if ply:Team() != 0 then return end
	if( key == IN_SPEED ) then
		if !(ply:GetSuit() > 4) then return end
		tempagil = ply:GetSuitMode()
		ply:ChangeSuit( 2 )
		ply:SetSuit( math.Max(ply:GetSuit() - 4, 0) )
	end
	
	if( key == IN_USE ) then
		if ply:GetSuitMode() != 1 then
			ply:ChangeSuit( 1 ) else
			ply:ChangeSuit( 0 ) end
	end

end

function GM:KeyRelease( ply, key )
if ply:Team() != 0 then return end

	if( key == IN_SPEED ) then
		if ply:GetSuitMode()!=tempagil and ply:GetSuitMode()!=2 then return end
		ply:ChangeSuit( tempagil )
	end
end

//EVENT HANDLERS
function iwSpawn( ply, cmd, args )
	if !(args[1]) then return end
	ply:UnLock()
	ply:GodDisable()
	if	ply:Team()==0 then
		ply:SetClass( tonumber(args[4]) )
		ply:SetMHealth( classes.human[tonumber(args[4])].Health )
		ply:SetHealth( ply:GetMHealth() )
		ply:Give(pweapons.human[tonumber(args[1])].object)
		ply.pweapon = tonumber(args[1])
		ply:Give(sweapons.human[tonumber(args[2])].object)
		ply.sweapon = tonumber(args[2])
		ply:Give("iw_knife")
		ply:SetUtility( tonumber(args[3]) )
		ply:SetWalkSpeed( classes.human[tonumber(args[4])].mspd )
		ply:SetSuitMax( classes.human[tonumber(args[4])].Suit )
		ply:SetSuit( ply:GetSuitMax() )
		ply:ChangeSuit( 0 )
		ply:SetModel( classes.human[tonumber(args[4])].pmodel )
		ply:SetJumpPower(220)
	else
		ply:SetClass( tonumber(args[4]) )
		ply:SetMHealth( classes.infected[tonumber(args[4])].Health )
		ply:SetHealth( ply:GetMHealth() )
		ply:Give(pweapons.infected[tonumber(args[1])].object)
		ply.pweapon = tonumber(args[1])
		ply:Give(sweapons.infected[tonumber(args[2])].object)
		ply.sweapon = tonumber(args[2])
		ply:Give("iw_inf_knife")
		ply:SetUtility( tonumber(args[3]) )
		ply:SetWalkSpeed( classes.infected[tonumber(args[4])].mspd )
		ply:SetModel( classes.infected[tonumber(args[4])].pmodel )
		if tonumber(args[4]) == 2 then ply:SetJumpPower(420) else ply:SetJumpPower(200) end
	end
	ply:SetRunSpeed( ply:GetWalkSpeed() )
end

function SpawnAmmo( pos )
	local Box = ents.Create("ammodrop")
	local Force = 200+math.random(0,50)
	
	Box:SetPos(pos)
	Box:SetAngles( Vector(math.random(-1,1),math.random(-1,1),math.random(-1,1)):GetNormal():Angle() )
	Box:Spawn()
	
	Box:Activate()
	
	local Phys = Box:GetPhysicsObject()
	Phys:SetVelocity(Vector(0,0,1) * Force)
end

function UnlockAchievement( ply, data )
	if !ply:IsPlayer() then return end
	if ply.Data.Global["achievements"][data] != 1 then
		ply.Data.Global["achievements"][data] = 1
		GAMEMODE:PlayClientSound( ply, 3 )
		for k, v in pairs(player.GetAll()) do
			v:PrintMessage( HUD_PRINTTALK, ply:Nick().." has unlocked the "..achieve[data].name.." achievement!" )
		end
	end
	GAMEMODE:SendAchieves( ply )
end

function AddKill( ply )
	ply:AddFrags( 1 )
	ply.Data.Life.Kills = ply.Data.Life.Kills + 1
	if ply:Team() == 0 then
		ply.Data.Global["infkills"] = ply.Data.Global["infkills"] + 1
		ply.InfKills = ply.InfKills + 1
	else
		ply.Data.Global["humkills"] = ply.Data.Global["humkills"] + 1
		ply.HumKills = ply.HumKills + 1
	end
end

function GM:InitPostEntity( )	

	local toDestroy = ents.FindByClass("prop_ragdoll")
	toDestroy = table.Add(toDestroy, ents.FindByClass("npc_zombie"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("npc_maker"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("npc_template_maker"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("npc_maker_template"))	
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_physicscannon"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_crowbar"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_stunstick"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_357"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_pistol"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_smg1"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_ar2"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_crossbow"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_shotgun"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_rpg"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_slam"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_pumpshotgun"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_ak47"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_deagle"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_fiveseven"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_glock"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_m4"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_mac10"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_mp5"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_para"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_tmp"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("weapon_frag"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_357"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_357_large"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_pistol"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_pistol_large"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_box_buckshot"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_ar2"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_ar2_large"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_ar2_altfire"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_dynamic_resupply"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_rpg_round"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_item_crate"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_crate"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_crossbow"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_smg1"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_smg1_large"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_ammo_smg1_grenade"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_box_buckshot"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("func_healthcharger"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("func_recharge"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_healthcharger"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_battery"))
	toDestroy = table.Add(toDestroy, ents.FindByClass("item_suitcharger"))
    toDestroy = table.Add(toDestroy, ents.FindByClass("item_healthkit"))
    toDestroy = table.Add(toDestroy, ents.FindByClass("item_healthvial"))
	for _, ent in pairs(toDestroy) do
		ent:Remove()
	end
	
	HumanSpawns = {}
	HumanSpawns = ents.FindByClass( "info_player_human" )
	HumanSpawns = table.Add( HumanSpawns, ents.FindByClass( "info_player_combine" ) )
	HumanSpawns = table.Add( HumanSpawns, ents.FindByClass( "info_player_allies" ) )
	HumanSpawns = table.Add( HumanSpawns, ents.FindByClass( "info_player_terrorist" ) )
	if #HumanSpawns <= 0 then
		HumanSpawns = table.Add( HumanSpawns, ents.FindByClass( "info_player_start" ) )
		HumanSpawns = table.Add( HumanSpawns, ents.FindByClass( "info_player_deathmatch" ) )
	end
	if #HumanSpawns <= 0 then
		HumanSpawns = table.Add( HumanSpawns, ents.FindByClass( "gmod_player_start" ) )
	end
	
	InfectedSpawns = {}
	InfectedSpawns = ents.FindByClass( "info_player_undead" )
	InfectedSpawns = table.Add( InfectedSpawns, ents.FindByClass( "info_player_zombie" ) )
	InfectedSpawns = table.Add( InfectedSpawns, ents.FindByClass( "info_player_rebel" ) )
	InfectedSpawns = table.Add( InfectedSpawns, ents.FindByClass( "info_player_axis" ) )
	InfectedSpawns = table.Add( InfectedSpawns, ents.FindByClass( "info_player_counterterrorist" ) )
	if #InfectedSpawns <= 0 then
		InfectedSpawns = table.Add( InfectedSpawns, ents.FindByClass( "info_player_start" ) )
		InfectedSpawns = table.Add( InfectedSpawns, ents.FindByClass( "info_player_deathmatch" ) )
	end
	if #InfectedSpawns <= 0 then
		InfectedSpawns = table.Add( InfectedSpawns, ents.FindByClass( "gmod_player_start" ) )
	end
end

function SetData( ply, type )
	if type == "init" then
		ply.Data = {}
		ply.Data.Life = {}
		ply.Data.Round = {}
		ply.Data.Global = ply.Stats
	end
	if type == "life" then
		if ! ply.Data then SetData( ply, "init" ) end
		ply.Data.Life.Kills = 0
		ply.Data.Life.Damage = 0
		ply.Data.Life.Healing = 0
		ply.Data.Life.sysvaro = CurTime()
		ply.Data.Life.time = CurTime() - ply.Data.Life.sysvaro
	end
	if type == "round" then
		if ! ply.Data then SetData( ply, "init" ) end
		ply.Data.Round.Damage = 0
		ply.Data.Round.Healing = 0
	end
end

function GM:SendUtility ( ply, num )
	net.Start( "Utility" )
	net.WriteInt( num, 8 )
	net.Send( ply )
end

function GM:SendMaxHealth( ply, num )
	net.Start( "MaxHealth" )
	net.WriteInt( num, 16 )
	net.Send( ply )
end

function GM:SendSuitMode( ply, num )
	net.Start( "SuitMode" )
	net.WriteInt( num, 8 )
	net.Send( ply )
end

function GM:SendSuit( ply, num )
	net.Start( "Suit" )
	net.WriteInt( num, 16 )
	net.Send( ply )
end

function GM:SendSuitMax( ply, num )
	net.Start( "SuitMax" )
	net.WriteInt( num, 16 )
	net.Send( ply )
end

function GM:PlayClientSound( ply, num )
	net.Start( "CSound" )
	net.WriteInt( num, 8 )
	net.Send( ply )
end

function GM:SendHit( ply )
	net.Start( "Hit" )
	net.Send( ply )
end

function GM:SendTime( ply, num )
	net.Start( "Time" )
	net.WriteInt( num, 16 )
	net.Send( ply )
end

function GM:SendPaint( ply )
	net.Start( "Paint" )
	net.Send( ply )
end

function GM:SendStopSounds()
	for k, v in pairs(player.GetAll()) do
		net.Start( "StopSound" )
		net.Send( v )
	end
end

function GM:SendAchieves( ply )
	net.Start( "Achieve" )
	net.WriteTable( ply.Data.Global["achievements"] )
	net.Send( ply )
end

function GM:ShowHelp( ply )
	net.Start( "DBmenu" )
	net.Send( ply )
end

function GM:ShowTeam( ply )
	net.Start( "Statmenu" )
	net.Send( ply )
end

//STATS
function GetMostInfKills()
	local amt = 0
	local name = ""
	for k, v in pairs(player.GetAll()) do
		if v.InfKills > amt then name = v:Nick() amt = v.InfKills end
	end
	tab = {amount = amt, nick = name}
	return tab
end
function GetMostHumKills()
	local amt = 0
	local name = ""
	for k, v in pairs(player.GetAll()) do 
		if v.HumKills > amt then name = v:Nick() amt = v.HumKills end
	end
	tab = {amount = amt, nick = name}
	return tab
end
function GetMostDeaths()
	local amt = 0
	local name = ""
	for k, v in pairs(player.GetAll()) do
		if v:Deaths() > amt then name = v:Nick() amt = v:Deaths() end
	end
	tab = {amount = amt, nick = name}
	return tab
end
function GM:SendFinalStats( ply )
	stats = {}
	stats.RoundTime = ROUNDSTOP - ROUNDSTART
	stats.LastStandTime = LASTSTANDSTOP - LASTSTANDSTART
	stats.LastStandNick = LASTSTANDNICK
	stats.MostInfKills = GetMostInfKills()
	stats.MostHumKills = GetMostHumKills()
	stats.MostDeaths = GetMostDeaths()
	stats.Winner = WINNER
	net.Start( "FinalStats" )
	net.WriteTable( stats )
	net.Send( ply )
end

//NET MODULES
util.AddNetworkString( "Loadout" )
util.AddNetworkString( "Utility" )
util.AddNetworkString( "MaxHealth" )
util.AddNetworkString( "SuitMode" )
util.AddNetworkString( "Suit" )
util.AddNetworkString( "SuitMax" )
util.AddNetworkString( "CSound" )
util.AddNetworkString( "Hit" )
util.AddNetworkString( "Time" )
util.AddNetworkString( "Paint" )
util.AddNetworkString( "StopSound" )
util.AddNetworkString( "FinalStats" )
util.AddNetworkString( "Achieve" )
util.AddNetworkString( "DBmenu" )
util.AddNetworkString( "Statmenu" )
util.AddNetworkString( "Stats" )

//CMD COMMANDS
concommand.Add( "iw2_spawn", iwSpawn )