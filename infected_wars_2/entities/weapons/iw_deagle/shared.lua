if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "pistol"

if CLIENT then
	SWEP.PrintName = "Desert Eagle .50"
	SWEP.Author	= "Carnifex"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.ViewModelFlip = true
	SWEP.ViewModelFOV = 70
	SWEP.IconLetter = "f"
	SWEP.SelectFont = "CSSelectIcons"
	
	killicon.AddFont( "iw_deagle", "CSKillIcons", "f", Color( 0, 0, 255, 255 ) )
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_deagle.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_Deagle.Single")
SWEP.Primary.Recoil			= 1.6
SWEP.Primary.Unrecoil		= 7
SWEP.Primary.Damage			= 23
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 7
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ConeMoving		= 0.06
SWEP.Primary.ConeCrouching	= 0.02

SWEP.MuzzleEffect			= "rg_muzzle_pistol"

SWEP.IronSightsPos = Vector (-5.7225, -14.2307, 4.0085)
SWEP.IronSightsAng = Vector (0.661, -1.2504, 1.1892)
