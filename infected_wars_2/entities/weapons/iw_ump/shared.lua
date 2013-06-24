if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "smg"

if CLIENT then
	SWEP.PrintName = "UMP .45"			
	SWEP.Slot = 2
	SWEP.SlotPos = 5
	SWEP.IconLetter = "q"
	killicon.AddFont("iw_ump", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_ump45.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_UMP45.Single")
SWEP.Primary.Recoil			= 4.5
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ConeMoving		= 0.10
SWEP.Primary.ConeCrouching	= 0.042

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "none" 

SWEP.IronSightsPos = Vector (7.3038, -5.5599, 3.1777)
SWEP.IronSightsAng = Vector (-1.211, 0.2592, 2.4161)