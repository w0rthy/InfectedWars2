if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "smg"

if CLIENT then
	SWEP.PrintName = "MP7 4.6mm"			
	SWEP.Slot = 2
	SWEP.SlotPos = 5
	SWEP.ViewModelFlip = false
	SWEP.IconLetter = "/"
	SWEP.SelectFont = "HL2SelectIcons"
	killicon.AddFont("iw_lsmg", "HL2KillIcons", "/", Color( 0, 0, 255, 255 ))
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_SMG1.Single")
SWEP.Primary.Recoil			= 2.2
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 45
SWEP.Primary.Delay			= 0.06
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.08
SWEP.Primary.ConeMoving		= 0.15
SWEP.Primary.ConeCrouching	= 0.06

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject" 

SWEP.IronSightsPos = Vector (4.7392, -6.3991, 1.6964)
SWEP.IronSightsAng = Vector (2.2392, -0, 0)