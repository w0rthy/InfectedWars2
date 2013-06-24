broadcasts = {}
broadcasts[1] = "Press F1 to view achievements and rewards!"
broadcasts[2] = "Welcome to the Infected Wars 2 Beta!"
broadcasts[3] = "Press F2 to view your statistics!"
broadcasts[4] = "Report any bugs or lua errors to Carnifex."
broadcasts[5] = "Current IW2 Version : 0.7 Beta, IW2 DB: 0.6, Hash Library: 1.1C"

local nextbrd = 1
local nexttime = CurTime() + 15
function Broadcast()
	if CurTime()>=nexttime then
		for k, v in pairs(player.GetAll()) do
			v:PrintMessage( HUD_PRINTTALK, broadcasts[nextbrd] )
		end
		nextbrd = nextbrd + 1
		if nextbrd > 5 then nextbrd = 1 end
		nexttime = CurTime()+15
	end
end
hook.Add( "Think", "Broadcast", Broadcast )