include("shared.lua")

SWEP.PrintName = "Knife"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

	surface.CreateFont( "CSKillIcons", {
		size = ScreenScale(30),
		weight = 500,
		antialias = true,
		shadow = true,
		font = "csd"})
	surface.CreateFont( "CSSelectIcons", {
		size = ScreenScale(60),
		weight = 500,
		antialias = true,
		shadow = true,
		font = "csd"})

SWEP.Slot = 0
SWEP.SlotPos = 0
killicon.AddFont( "iw_knife", "CSKillIcons", "j", Color( 0, 0, 255, 255 ) )

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CurTime() < self.Weapon:GetNetworkedFloat("LastShootTime", -100) + self.Primary.Delay then return end

	local trace = util.TraceLine( {self.Owner:GetPos(), self.Owner:GetForward()*80, {self.Owner, self.Entity}, MASK_ALL} )

	if trace.Hit then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			util.Decal("Blood", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		else
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end
	end

	self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:Think()
end

if CLIENT then
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "j", "CSSelectIcons", x + wide/2, y + tall*0.3, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
		// Draw weapon info box
		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end

function SWEP:PrintWeaponInfo( x, y, alpha )
end
 