if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "smg"

if CLIENT then
	SWEP.PrintName = "M249 MG"			
	SWEP.Slot = 2
	SWEP.SlotPos = 5
	SWEP.ViewModelFlip = false
	SWEP.IconLetter = "z"
	SWEP.SelectFont = "CSSelectIcons"
	killicon.AddFont("iw_m249", "CSKillIcons", "z", Color( 0, 0, 255, 255 ))
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel			= "models/weapons/w_mach_m249para.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_M249.Single")
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 100
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ConeMoving		= 0.17
SWEP.Primary.ConeCrouching	= 0.04

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject" 

SWEP.IronSightsPos = Vector (4.7392, -6.3991, 1.6964)
SWEP.IronSightsAng = Vector (2.2392, -0, 0)

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self.dt.ironsights = false

	if self.Owner:GetNetworkedInt("Class")==2 then
		Bonus = true
	else
		Bonus = false
	end
end