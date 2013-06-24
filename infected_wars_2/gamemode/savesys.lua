function GM:WriteData( ply )

	local path = "data_"..string.Replace( string.sub( ply:SteamID(), 9 ), ":", "-" )..".txt"
	
	ply.Stats["name"] = ply:Name()
	ply.Stats["id"] = ply:SteamID()
	ply.Stats["humkills"] = ply.Data.Global["humkills"] or 0
	ply.Stats["infkills"] = ply.Data.Global["infkills"] or 0
	ply.Stats["deaths"] = ply.Data.Global["deaths"] or 0
	ply.Stats["healed"] = ply.Data.Global["healed"] or 0
	ply.Stats["damage"] = ply.Data.Global["damage"] or 0
	
	for k, v in pairs(achieve) do
		ply.Stats["achievements"][k] = ply.Data.Global["achievements"][k] or 0
	end

	local data = util.TableToKeyValues( ply.Stats )
	
	ply:PrintMessage( HUD_PRINTTALK, "Your stats have been saved" )
	
	file.Write( path, data )
end

function GM:GetBlankStats( ply )
	local data =
	[["0"
	{
		"name"		"]]..ply:Name()..[["
		"id"		"]]..ply:SteamID()..[["
		"humkills"	"0"
		"infkills"	"0"
		"deaths"	"0"
		"healed"	"0"
		"damage"	"0"

		"achievements"
		{
]]
	
	for k, v in pairs(achieve) do
		data = data..'		"'..k..'" "0"\n'
	end
	
	data=data..[[
		}
	
	}]]
	
	return data
end

function GM:WriteBlankData( ply )
	
	local path = "data_"..string.Replace( string.sub( ply:SteamID(), 9 ), ":", "-" )..".txt"
	local data = GAMEMODE:GetBlankStats( ply )
	
	file.Write( path, data )
end

function GM:ReadData( ply )

	ply.Stats = {}
	
	local path = "data_"..string.Replace( string.sub( ply:SteamID(), 9 ), ":", "-" )..".txt"
	
	if !file.Exists( "data_"..string.Replace( string.sub( ply:SteamID(), 9 ), ":", "-" )..".txt", "DATA" ) then
		GAMEMODE:WriteBlankData( ply )
	end
	
	local data = file.Read( "data_"..string.Replace( string.sub( ply:SteamID(), 9 ), ":", "-" )..".txt", "DATA" )
	ply.Stats = util.KeyValuesToTable( GAMEMODE:GetBlankStats( ply ) )
	local contents = util.KeyValuesToTable( data )
	table.Merge( ply.Stats, contents )
end