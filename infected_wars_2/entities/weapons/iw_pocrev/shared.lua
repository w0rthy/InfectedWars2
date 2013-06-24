if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "pistol"

if CLIENT then
	SWEP.PrintName = "Pocket Revolver"
	SWEP.Author	= "Carnifex"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70
	SWEP.IconLetter = "-"
	SWEP.SelectFont = "HL2SelectIcons"
	
	killicon.AddFont( "iw_pocrev", "HL2KillIcons", "-", Color( 0, 0, 255, 255 ) )
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_357.Single")
SWEP.Primary.Recoil			= 3.2
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.065
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 10
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.035
SWEP.Primary.ConeMoving		= 0.055
SWEP.Primary.ConeCrouching	= 0.01

SWEP.MuzzleEffect			= "rg_muzzle_pistol"

SWEP.IronSightsPos = Vector (-5.7225, -14.2307, 4.0085)
SWEP.IronSightsAng = Vector (0.661, -1.2504, 1.1892)
