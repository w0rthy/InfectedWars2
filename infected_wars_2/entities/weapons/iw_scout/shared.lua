if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.HoldType = "ar2"

if CLIENT then
	SWEP.PrintName = "Scout .30"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 3
	SWEP.SlotPos = 4
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = true
	SWEP.IconLetter = "n"
	SWEP.SelectFont = "CSSelectIcons"
	killicon.AddFont("iw_scout", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base				= "iw_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_scout.mdl"

SWEP.Weight				= 6
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false


SWEP.Primary.Sound			= Sound("Weapon_Scout.Single")
SWEP.Primary.Recoil			= 3.0
SWEP.Primary.Damage			= 62
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 1.8
SWEP.Primary.DefaultClip	= 22
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "XBowBolt"
SWEP.Primary.ReloadDelay	= 1.5
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ConeMoving		= 0.1
SWEP.Primary.ConeCrouching	= 0.03
SWEP.Primary.OrigCone		= SWEP.Primary.Cone
SWEP.Primary.OrigConeMoving	= SWEP.Primary.ConeMoving
SWEP.Primary.OrigConeCrouching = SWEP.Primary.ConeCrouching
SWEP.Primary.ZoomedCone		= 0.01
SWEP.Primary.ZoomedConeMoving = 0.06
SWEP.Primary.ZoomedConeCrouching = 0

SWEP.MuzzleEffect			= "rg_muzzle_rifle"
SWEP.ShellEffect			= "rg_shelleject_rifle" 
SWEP.EjectDelay				= 0.53

SWEP.Secondary.Delay = 0.5

SWEP.NextReload = 0

SWEP.ZoomSound = Sound("weapons/sniper/sniper_zoomin.wav")
SWEP.DeZoomSound = Sound("weapons/sniper/sniper_zoomout.wav")
SWEP.ZoomFOV = 20

SWEP.IronSightsPos 			= Vector (4.9906, -9.5434, 2.5078)
SWEP.IronSightsAng 			= Vector (0, 0, 0)

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)

	-- unzoom while reloading
	self:SetZoom(false)
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	
	self.dt.ironsights = false
	self.dt.zoomed = false
end

function SWEP:SetupDataTables()

	self:DTVar( "Bool", 0, "zoomed" )
	self:DTVar( "Bool", 1, "ironsights" )

end


function SWEP:SecondaryAttack()
	self.Weapon.NextZoom = self.Weapon.NextZoom or CurTime()
	if CurTime() < self.Weapon.NextZoom then return end
	self.Weapon.NextZoom = CurTime() + self.Secondary.Delay

	local zoomed = !self.dt.zoomed
	
	self:SetZoom(zoomed)
end

function SWEP:SetZoom( b )

	if ( self.dt.zoomed == b ) then return end
	
	if (b == false) then
		if SERVER then
			self.Owner:SetFOV(75, 0.5)
			self.Weapon:EmitSound(self.DeZoomSound, 50, 100)
			self.Owner:DrawViewModel(true)
		else
			self.FadeAlpha = 255
			self.Scoped = false
			DrawCrHair = true
			surface.PlaySound(self.DeZoomSound)
		end
		self.Primary.Cone			= self.Primary.OrigCone
		self.Primary.ConeMoving		= self.Primary.OrigConeMoving
		self.Primary.ConeCrouching	= self.Primary.OrigConeCrouching
		
		self:SetIronsights(false)
	else
		if SERVER then
			self.Owner:SetFOV(self.ZoomFOV, 0.5)
			self.Weapon:EmitSound(self.ZoomSound, 50, 100)
			timer.Simple(0.45,function()
				if not (self.Owner:IsValid()) then return end
				self.Owner:DrawViewModel(false)
			end)
		else
			timer.Simple(0.5,function()
				self.Scoped = true
			end)
			DrawCrHair = false
			surface.PlaySound(self.ZoomSound)
		end
		self.Primary.Cone			= self.Primary.ZoomedCone
		self.Primary.ConeMoving		= self.Primary.ZoomedConeMoving
		self.Primary.ConeCrouching	= self.Primary.ZoomedConeCrouching
		
		self:SetIronsights(true)
	end
	
	self.dt.zoomed = b
end

function SWEP:Holster()
	self:SetZoom(false)
	return true
end

if CLIENT then
	SWEP.Scoped = false
	SWEP.FadeAlpha = 0
	SWEP.FadeSpeed = 800
	
	-- Replaces the DrawHUD function because I want to draw my HUD in front of the scope
	function SWEP:DrawHUD()
	local w = ScrW()
	local h = ScrH()
		if self.dt.zoomed then
			if self.Scoped then
				if self.FadeAlpha > 0 then
					self.FadeAlpha = math.max(0,self.FadeAlpha-FrameTime()*self.FadeSpeed)
					surface.SetDrawColor(0, 0, 0, self.FadeAlpha)
					surface.DrawRect(0, 0, w, h)
				end
				
				self.ScLength = h*0.4
				
				surface.SetDrawColor(75, 110, 190, 50)
				surface.DrawRect(0,h*0.5-3,w,6)
				surface.DrawRect(w*0.5-3,0,6,h)
				surface.SetDrawColor(75, 110, 190, 100)
				surface.DrawRect(0,h*0.5-2,w,4)
				surface.DrawRect(w*0.5-2,0,4,h)
				
				self.ScX1 = 0.5*(w-self.ScLength)
				self.ScY1 = 0.5*(h-self.ScLength)
				self.ScX2 = 0.5*(w+self.ScLength)
				self.ScY2 = 0.5*(h+self.ScLength)

				surface.SetDrawColor(0, 0, 0, 255)
				surface.SetTexture(surface.GetTextureID("infectedwars/sniper_corner"))
				surface.DrawTexturedRectRotated(self.ScX1,self.ScY1,self.ScLength,self.ScLength,0)
				surface.DrawTexturedRectRotated(self.ScX1,self.ScY2,self.ScLength,self.ScLength,90)			
				surface.DrawTexturedRectRotated(self.ScX2,self.ScY2,self.ScLength,self.ScLength,180)
				surface.DrawTexturedRectRotated(self.ScX2,self.ScY1,self.ScLength,self.ScLength,270)

				self.ScLength = h*0.795 -- Weird fix, but it seems to work... (test on 1024x768 till 1920x1200)
				self.ScX1 = 0.5*(w-self.ScLength)
				self.ScY1 = 0.5*(h-self.ScLength)
				self.ScX2 = 0.5*(w+self.ScLength)
				self.ScY2 = 0.5*(h+self.ScLength)		
				
				surface.SetDrawColor(0,0,0,255)
				surface.DrawRect(0,0,w,self.ScY1)
				surface.DrawRect(0,self.ScY2,w,h-self.ScY2)
				surface.DrawRect(0,self.ScY1,self.ScX1,self.ScY2-self.ScY1)
				surface.DrawRect(self.ScX2,self.ScY1,w-self.ScX2,self.ScY2-self.ScY1)	
			else
				if self.FadeAlpha <= 255 then
					self.FadeAlpha = math.min(255,self.FadeAlpha+FrameTime()*self.FadeSpeed)
					surface.SetDrawColor(0, 0, 0, self.FadeAlpha)
					surface.DrawRect(0, 0, w, h)
				end
			end
		else
			if self.FadeAlpha > 0 then
				self.FadeAlpha = math.max(0,self.FadeAlpha-FrameTime()*self.FadeSpeed)
				surface.SetDrawColor(0, 0, 0, self.FadeAlpha)
				surface.DrawRect(0, 0, w, h)
			end
		end
	end
end
