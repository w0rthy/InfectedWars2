local ply = FindMetaTable("Player")
if !ply then return end

function ply:SetUtility( num )
	self.Utility = num
	GAMEMODE:SendUtility( self, num )
end

function ply:SetMHealth( num )
	self.MaxHealth = num
	self:SetMaxHealth( num )
	GAMEMODE:SendMaxHealth( self, num )
end

function ply:ChangeSuit( num )
	if self:GetSuitMode() == 2 and num != 2 and tmpjmp then self:SetJumpPower( tmpjmp ) end
	if num == 2 and !(self:GetSuit() > 0) then return end
	if num != self.SMode then GAMEMODE:PlayClientSound( self, 1 ) end
	self.SMode = num
	if self:GetSuitMode() == 2 then self:SetRunSpeed( self:GetWalkSpeed()*2.25 ) tmpjmp = self:GetJumpPower() self:SetJumpPower( self:GetJumpPower()*2.2 ) else self:SetRunSpeed( self:GetWalkSpeed() ) end
	GAMEMODE:SendSuitMode( self, self.SMode )
end

function ply:SetSuit( num )
	self.Suit = num
	GAMEMODE:SendSuit( self, num )
end

function ply:SetSuitMax( num )
	self.SuitMax = num
	GAMEMODE:SendSuitMax( self, num )
end

function ply:SetClass( num )
	self:SetNetworkedInt("Class", num)
end