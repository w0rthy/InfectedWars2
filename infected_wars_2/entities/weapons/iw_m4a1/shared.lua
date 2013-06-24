local Bonus = Bonus or false
if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "smg"

if CLIENT then
	SWEP.PrintName = "M4A1 AR"			
	SWEP.Slot = 2
	SWEP.SlotPos = 5
	SWEP.ViewModelFlip = true
	SWEP.IconLetter = "w"
	SWEP.SelectFont = "CSSelectIcons"
	killicon.AddFont("iw_m4a1", "CSKillIcons", "w", Color( 0, 0, 255, 255 ))
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_M4a1.Single")
SWEP.Primary.Recoil			= 1.25
SWEP.Primary.Damage			= 16
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 28
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ConeMoving		= 0.12
SWEP.Primary.ConeCrouching	= 0.03

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject" 

SWEP.IronSightsPos = Vector (4.7392, -6.3991, 1.6964)
SWEP.IronSightsAng = Vector (2.2392, -0, 0)

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self.dt.ironsights = false
end