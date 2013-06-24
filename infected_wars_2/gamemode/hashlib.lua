/*********
**********
**********	Hash Library
**********	By: Carnifex
**********
*********/
hash = {}

hash.Roll = function( a )
	local b = math.random( 100 )
	if a<b then return true
	else return false end
end

hash.Roll2 = function( a, b )
	local c = math.random( b )
	if a<c then return true
	else return false end
end

hash.SendSound = function( a, b )
	net.Start( "hashsound" )
	net.WriteString( a )
	if b!=nil then net.Send( b )
	else net.Broadcast() end
end
util.AddNetworkString( "hashsound" )

hash.DeepLoop = function( a, b )
	for k, v in pairs(a) do
		for ke, va in pairs(v) do
			b( ke, va )
		end
	end
end