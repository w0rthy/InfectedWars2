local ply = FindMetaTable("Player")
if !ply then return end

function ply:GetUtility()
	return self.Utility or 1
end

function ply:GetMHealth()
	return self.MaxHealth or 100
end

function ply:GetSuitMode()
	return self.SMode or 0
end

function ply:GetSuit()
	return self.Suit or 0
end

function ply:GetSuitMax()
	return self.SuitMax or 100
end

function ply:GetClass()
	return self:GetNetworkedInt("Class") or 1
end
