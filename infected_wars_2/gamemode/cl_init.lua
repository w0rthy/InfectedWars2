include('db.lua')
include('shared.lua')
include('player.lua')

if CLIENT then //Only in GMod 13
surface.CreateFont( "Doom", {font = "DooM", size = ScreenScale(10), weight = 200 } )
surface.CreateFont( "DoomLarge", {font = "DooM", size = ScreenScale(12), weight = 200 } )
surface.CreateFont( "DoomSmall", {font = "DooM", size = ScreenScale(7), weight = 200 } )
surface.CreateFont( "DoomBold", {font = "DooM", size = ScreenScale(5), weight = 700 } )
surface.CreateFont( "DoomSlim", {font = "DooM", size = ScreenScale(9), weight = 10 } )
end

function GM:HUDShouldDraw( element )
	local dntdrw = { "CHudHealth", "CHudArmor", "CHudAmmo", "CHudSuit" }
	for k = 0, #dntdrw do if dntdrw[k]==element then return false end
	end
	return self.BaseClass:HUDShouldDraw( element )
end

local function getWeaponList( set )
	local wlist = {}
	local wlnext = 1
	if LocalPlayer():Team() == 0 then
		for k, v in pairs(set.human) do
			local av = true
			for ke, va in pairs(set.human[k].req) do
				if lachieve[va] != 1 and va != "none" then av = false end
			end
			if av == true then wlist[wlnext] = k wlnext = wlnext + 1 end
		end
	else
		for k, v in pairs(set.infected) do
			local av = true
			for ke, va in pairs(set.infected[k].req) do
				if lachieve[va] != 1 and va != "none" then av = false end
			end
			if av == true then wlist[wlnext] = k wlnext = wlnext + 1 end
		end
	end
	return wlist
end

local function copyWepData( set )
	local final = {}
	local weplist = getWeaponList(set)
	if LocalPlayer():Team() == 0 then
		for k, v in pairs(weplist) do
			final[k] = set.human[v]
		end
	else
		for k, v in pairs(weplist) do
			final[k] = set.infected[v]
		end
	end
	return final
end

local function LoadoutSelection( )
	local selectedPWeapon = 1
	local selectedSWeapon = 1
	local selectedUtil = 1
	local selectedClass = 1
	local frame = vgui.Create( "DFrame" )
	frame:SetPos( ScrW()/4,ScrH()/4 )
	frame:SetSize( ScrW()/2, ScrH()/2 )
	frame:SetTitle( "Loadout Selection" )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()

	local pweaponSelect = vgui.Create( "DListView", frame )
		pweaponSelect:SetPos( ScrW()/256, 30 )
		pweaponSelect:SetSize( ScrW()/4.2, ScrH()/6 )
		pweaponSelect:SetMultiSelect( false )
	local pwpnlist = copyWepData(pweapons)
			
			pweaponSelect:AddColumn( "Primary Weapons" )
			pweaponSelect:AddColumn( "Description" )
			for k, v in pairs(pwpnlist) do
				pweaponSelect:AddLine( v.name, v.desc )
			end

	local sweaponSelect = vgui.Create( "DListView", frame )
		sweaponSelect:SetPos( ScrW()/4, 30 )
		sweaponSelect:SetSize( ScrW()/4.2, ScrH()/6 )
		sweaponSelect:SetMultiSelect( false )
	local swpnlist = copyWepData(sweapons)

			sweaponSelect:AddColumn( "Secondary Weapons" )
			sweaponSelect:AddColumn( "Description" )
			for k, v in pairs(swpnlist) do
				sweaponSelect:AddLine( v.name, v.desc )
			end

	local utilSelect = vgui.Create( "DListView", frame )
		utilSelect:SetPos( ScrW()/256, ScrH()/6+40 )
		utilSelect:SetSize( ScrW()/4.2, ScrH()/6 )
		utilSelect:SetMultiSelect( false )
	local utillist = copyWepData(utilities)
	
			utilSelect:AddColumn( "Utilities" )
			utilSelect:AddColumn( "Description" )
			for k, v in pairs(utillist) do
				utilSelect:AddLine( v.name, v.desc )
			end

	local classesSelect = vgui.Create( "DListView", frame )
		classesSelect:SetPos( ScrW()/4, ScrH()/6+40 )
		classesSelect:SetSize( ScrW()/4.2, ScrH()/6 )
		classesSelect:SetMultiSelect( false )
		classesSelect:AddColumn( "Classes" )
		classesSelect:AddColumn( "Description" )

		if LocalPlayer():Team()==0 then
			for k, v in pairs(classes.human) do
				classesSelect:AddLine( v.name, v.desc )
			end
		else
			for k, v in pairs(classes.infected) do
				classesSelect:AddLine( v.name, v.desc )
			end
		end
	
	local done = vgui.Create( "DButton", frame )
		done:SetPos( ScrW()/5.15, ScrH()/2.5 )
		done:SetSize( 200, 67 )
		done:SetText( "Done" )
		done.DoClick = function()
			selectedPWeapon = pweaponSelect:GetSelectedLine() or 1
			selectedSWeapon = sweaponSelect:GetSelectedLine() or 1
			selectedUtil = utilSelect:GetSelectedLine() or 1
			selectedClass = classesSelect:GetSelectedLine() or 1
			RunConsoleCommand("iw2_spawn",""..getWeaponList(pweapons)[selectedPWeapon],""..getWeaponList(sweapons)[selectedSWeapon],""..getWeaponList(utilities)[selectedUtil],""..selectedClass)
			frame:Close()
		end
		
end
net.Receive( "Loadout", function( len )
	LoadoutSelection() end)

function DrawDBMenu()
	local dbmenu = vgui.Create( "DFrame" )
		dbmenu:SetPos( ScrW()/4,ScrH()/4 )
		dbmenu:SetSize( ScrW()/2, ScrH()/2 )
		dbmenu:SetTitle( "Achievements" )
		dbmenu:SetDraggable( true )
		dbmenu:ShowCloseButton( true )
		dbmenu:MakePopup()
	local dblist = vgui.Create( "DListView", dbmenu )
		dblist:SetPos( 0,20 )
		dblist:SetSize( ScrW()/2, ScrH()/2-20 )
		dblist:SetMultiSelect( false )
		dblist:AddColumn( "Achievement" )
		dblist:AddColumn( "Description" )
		dblist:AddColumn( "Unlocks" )
		dblist:AddColumn( "Unlocked" )
		for k, v in pairs(achieve) do
			local unlocks = {}
			local nextpos = 1
			for ke, va in pairs(pweapons.human) do
				if k == va.req[1] then unlocks[nextpos] = va.name nextpos = nextpos + 1 end
			end
			for ke, va in pairs(sweapons.human) do
				if k == va.req[1] then unlocks[nextpos] = va.name nextpos = nextpos + 1 end
			end
			for ke, va in pairs(utilities.human) do
				if k == va.req[1] then unlocks[nextpos] = va.name nextpos = nextpos + 1 end
			end
			for ke, va in pairs(pweapons.infected) do
				if k == va.req[1] then unlocks[nextpos] = va.name nextpos = nextpos + 1 end
			end
			for ke, va in pairs(sweapons.infected) do
				if k == va.req[1] then unlocks[nextpos] = va.name nextpos = nextpos + 1 end
			end
			for ke, va in pairs(utilities.infected) do
				if k == va.req[1] then unlocks[nextpos] = va.name nextpos = nextpos + 1 end
			end
			local unlockstring = ""
			for ke, va in pairs(unlocks) do
				unlockstring = (unlockstring..va..",")
			end
			if unlockstring == "" then unlockstring = "none" else unlockstring = string.sub( unlockstring, 1, string.len(unlockstring)-1 ) end
			local unlocked = ""
			if lachieve[k] == 1 then unlocked = "yes" else unlocked = "no" end
			dblist:AddLine( v.name, v.desc, unlockstring, unlocked )
		end

end

function DrawStatMenu()
	local statmenu = vgui.Create( "DFrame" )
		statmenu:SetPos( ScrW()/4,ScrH()/4 )
		statmenu:SetSize( ScrW()/2, ScrH()/2 )
		statmenu:SetTitle( "Statistics" )
		statmenu:SetDraggable( true )
		statmenu:ShowCloseButton( true )
		statmenu:MakePopup()
	local statlist = vgui.Create( "DListView", statmenu )
		statlist:SetPos( 0,20 )
		statlist:SetSize( ScrW()/2, ScrH()/2-20 )
		statlist:SetMultiSelect( false )
		statlist:AddColumn( "Stat" )
		statlist:AddColumn( "Value" )
		for k, v in pairs(stats) do
			if k != "achievements" then
				statlist:AddLine( k, v or 0 )
			end
		end
end
	
//HUD
iwtime = iwtime or 0
function GM:HUDPaint( )

	local tcol = team.GetColor( LocalPlayer():Team() )
	local gradient = surface.GetTextureID( "infectedwars/HUD/gradient2" )
	
	//FINAL STATS
	if paintfs == true then
		paintls = false
		if finalstats.Winner == 0 then wintxt = "The Special Forces trashed the Infected" else wintxt = "The Infected devoured the Special Forces" end
		draw.SimpleText( wintxt, "DoomLarge", ScrW()/2, ScrH()/3+30, tcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "The round lasted "..math.abs(math.floor(finalstats.RoundTime/60))..":"..math.Round(finalstats.RoundTime%60), "DoomLarge", ScrW()/2, ScrH()/3+70, tcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
		draw.SimpleText( finalstats.LastStandNick.." survived for "..math.abs(math.floor(finalstats.LastStandTime/60))..":"..math.Round(finalstats.LastStandTime%60), "DoomLarge", ScrW()/2, ScrH()/3+110, tcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( finalstats.MostInfKills.nick.." killed the most infected with "..finalstats.MostInfKills.amount.." kills", "DoomLarge", ScrW()/2, ScrH()/3+150, tcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( finalstats.MostHumKills.nick.." killed the most humans with "..finalstats.MostHumKills.amount.." kills", "DoomLarge", ScrW()/2, ScrH()/3+190, tcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( finalstats.MostDeaths.nick.." was the most unfortunate with "..finalstats.MostDeaths.amount.." deaths", "DoomLarge", ScrW()/2, ScrH()/3+230, tcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return
	end
	//LAST STAND
	if paintls == true then
		local lspaint = surface.GetTextureID( "infectedwars/laststand" )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( lspaint )
		surface.DrawTexturedRect( ScrW()/3, 0, ScrW()/3, ScrH()/4*3 )
		local lsmsg = lsmsg or ""
		if LocalPlayer():Team() == 0 then lsmsg = "Survive!!!"
		else lsmsg = "Kill the last human!" end
		draw.SimpleText( lsmsg, "DoomLarge", ScrW()/2, ScrH()/2-50, tcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	//HUD OVERLAY
	if LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid() then
		if LocalPlayer():Team()==0 then
			local HHUD = surface.GetTextureID( "infectedwars/HUD/HHUD2" )
			surface.SetTexture( HHUD )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( 0, ScrH()-ScreenScale(76), ScreenScale(81), ScreenScale(76) )
		else
			local ZHUD = surface.GetTextureID( "infectedwars/HUD/ZHUD2" )
			surface.SetTexture( ZHUD )
			surface.SetDrawColor( 255, 0, 0, 255 )
			surface.DrawTexturedRect( -ScreenScale(19), ScrH()-ScreenScale(76), ScreenScale(97), ScreenScale(97) )
		end
		//HP BAR
		local hp = LocalPlayer():Health() or 0
		local hpm = LocalPlayer():GetMHealth() or 110
		surface.SetTexture( gradient )
		surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
		surface.DrawTexturedRect( ScreenScale(16), (ScrH()-ScreenScale(31))+2, ScreenScale(155), ScreenScale(19) )
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.DrawOutlinedRect( ScreenScale(16), (ScrH()-ScreenScale(31))+2, ScreenScale(155), ScreenScale(19) )
		
		surface.SetTexture( gradient )
		surface.SetDrawColor( tcol )
		surface.DrawTexturedRect( ScreenScale(16), (ScrH()-ScreenScale(31))+2, hp/hpm*ScreenScale(155), ScreenScale(19) )
		
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
		surface.DrawOutlinedRect( ScreenScale(16), (ScrH()-ScreenScale(31))+2, hp/hpm*ScreenScale(155), ScreenScale(19) )
		
		draw.SimpleText( hp.."/"..hpm, "DoomSlim", ScreenScale(91), ScrH()-ScreenScale(21), Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		//CLOCK
		if iwtime != nil then
			surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
			surface.DrawRect( 0, 0, 400, 50 )
			surface.SetTexture( gradient )
			surface.SetDrawColor( tcol )
			surface.DrawTexturedRect( 0, 0, ((960+iwtime-CurTime())/960)*400, 50 )
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect( 0, 0, 400, 50 )
			surface.DrawOutlinedRect( 0, 0, 401, 51 )
			surface.DrawOutlinedRect( 0, 0, 402, 52 )
			surface.DrawLine( 100, 0, 100, 50 )
			surface.DrawLine( 101, 0, 101, 50 )
			surface.DrawLine( 99, 0, 99, 50 )
			surface.DrawLine( 300, 0, 300, 50 )
			surface.DrawLine( 301, 0, 301, 50 )
			surface.DrawLine( 299, 0, 299, 50 )
			surface.SetDrawColor( 0, 0, 0, 180 )
			surface.DrawLine( 200, 0, 200, 50 )
			surface.DrawLine( 201, 0, 201, 50 )
			surface.DrawLine( 199, 0, 199, 50 )
			if math.Round((960+iwtime-CurTime())%10) >= 10 then secfix = 9 else secfix = math.Round((960+iwtime-CurTime())%10) end
			draw.SimpleText( math.floor((960+iwtime-CurTime())/60)..":"..(math.Round((960+iwtime-CurTime())%60)-math.Round((960+iwtime-CurTime())%10))/10 ..secfix, "DoomLarge", 200, 25, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			local specialforces = surface.GetTextureID( "infectedwars/specialforces" )
			surface.SetTexture( specialforces )
			surface.SetDrawColor( 0, 0, 50, 255 )
			surface.DrawTexturedRect( -ScreenScale(4), ScreenScale(25), ScreenScale(116), ScreenScale(39) )
			local infected = surface.GetTextureID( "infectedwars/undeadlegion" )
			surface.SetTexture( infected )
			surface.SetDrawColor( 50, 0, 0, 255 )
			surface.DrawTexturedRect( -ScreenScale(4), ScreenScale(50), ScreenScale(116), ScreenScale(39) )
			draw.SimpleText( "Special Forces : "..team.NumPlayers( 0 ), "DoomLarge", 0, ScreenScale(43), Color( 0, 0, 225, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			local deaths = 0
			for k, v in pairs(team.GetPlayers( 1 )) do deaths = deaths + v:Deaths() end
			draw.SimpleText( "Infected : "..(team.NumPlayers( 1 )*5+30-deaths), "DoomLarge", 0, ScreenScale(72), Color( 225, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		//AMMO
		if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():Clip1() > 0 then
			curammo = LocalPlayer():GetActiveWeapon():Clip1()
			ammodecal = surface.GetTextureID( "infectedwars/bullet" )
			surface.SetTexture( ammodecal )
			surface.SetDrawColor( Color( 255, 255, 255, 255 ))
			if LocalPlayer():Team() == 1 then surface.SetDrawColor( Color ( 255, 0, 0, 255 ) ) end 
			bdrawn = 0
			for k = 1, math.ceil(curammo/10) do
				brdrawn = 0
				while brdrawn<50 and bdrawn < curammo do
					surface.DrawTexturedRect( ScrW()-brdrawn*ScreenScale(3)-ScreenScale(3), ScrH()-k*ScreenScale(10), ScreenScale(3), ScreenScale(10) )
					bdrawn = bdrawn+1
					brdrawn = brdrawn+1
				end
			end
			if LocalPlayer():Team() == 0 then
			draw.SimpleText( LocalPlayer():GetActiveWeapon():Clip1().."/"..LocalPlayer():GetAmmoCount( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() ), "DoomLarge", ScrW()- ScreenScale(29), ScrH()-math.ceil(curammo/50)*ScreenScale(10)-ScreenScale(13), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			else
			draw.SimpleText( LocalPlayer():GetActiveWeapon():Clip1().."/"..LocalPlayer():GetAmmoCount( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() ), "DoomLarge", ScrW()- ScreenScale(29), ScrH()-math.ceil(curammo/50)*ScreenScale(10)-ScreenScale(13), Color( 255, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			end
		end
		
		//CROSSHAIR
		crosshair = surface.GetTextureID( "infectedwars/HUD/crosshair4" )
		surface.SetTexture( crosshair )
		surface.SetDrawColor( tcol )
		surface.DrawTexturedRect( ScrW()/2-ScreenScale(16), ScrH()/2-ScreenScale(16), ScreenScale(31), ScreenScale(31) )
		//surface.DrawLine( ScrW()/2-16, ScrH()/2, ScrW()/2+16, ScrH()/2 )
		//surface.DrawLine( ScrW()/2-16, ScrH()/2-6, ScrW()/2+16, ScrH()/2+6 )
		//surface.DrawLine( ScrW()/2-16, ScrH()/2+6, ScrW()/2+16, ScrH()/2-6 )
		
		//TEAM SPECIFICS
		//HUMAN
		if LocalPlayer():Team() == 0 and LocalPlayer():GetActiveWeapon():IsValid() then
		//SUIT BAR
			local st = LocalPlayer():GetSuit() or 0
			local stm = LocalPlayer():GetSuitMax() or 100
			
			surface.SetTexture( gradient )
			surface.SetDrawColor( Color( 255, 255, 255, 100 ) )
			surface.DrawTexturedRect( ScreenScale(16), ScrH()-ScreenScale(44), ScreenScale(136), ScreenScale(14) )
			
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
			surface.DrawOutlinedRect( ScreenScale(16), ScrH()-ScreenScale(44), ScreenScale(136), ScreenScale(14) )
			
			surface.SetTexture( gradient )
			surface.SetDrawColor( Color( 0, 255, 255, 255 ) )
			surface.DrawTexturedRect( ScreenScale(16), ScrH()-ScreenScale(44), st/stm*ScreenScale(136), ScreenScale(14) )
			
			surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
			surface.DrawOutlinedRect( ScreenScale(16), ScrH()-ScreenScale(44), st/stm*ScreenScale(136), ScreenScale(14) )
			
			draw.SimpleText( st.."/"..stm, "DoomSlim", ScreenScale(91), ScrH()-ScreenScale(37), Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		//SUIT MODE
			suitmodet = {}
			suitmodet[0]= surface.GetTextureID( "infectedwars/armor" )
			suitmodet[1]= surface.GetTextureID( "infectedwars/regen" )
			suitmodet[2]= surface.GetTextureID( "infectedwars/speed" )
			surface.SetTexture( suitmodet[LocalPlayer():GetSuitMode()] )
			surface.SetDrawColor( Color( 0, 0, 255, 255 ))
			surface.DrawTexturedRect( ScrW()-ScreenScale(39), 0, ScreenScale(39), ScreenScale(39) )
			draw.SimpleText( suitmodes[LocalPlayer():GetSuitMode()].name, "Doom", ScrW()-ScreenScale(21), ScreenScale(41), Color( 0, 0, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		//RANGEFINDER
			if LocalPlayer():GetUtility() == 1 then
				local hitp = LocalPlayer():GetEyeTrace().HitPos
				draw.SimpleText( "Range: "..math.Round((LocalPlayer():GetPos():Distance( hitp )*0.75)/39).."m", "DermaLarge", ScreenScale(45), ScrH()-ScreenScale(58), Color( 255, 255, 255, 255 ), TEXT_ALIGN_TOP, TEXT_ALIGN_LEFT )
				if LocalPlayer():GetViewModel():LookupAttachment( "muzzle" )>0 then
					local weppos = LocalPlayer():GetViewModel():GetAttachment( LocalPlayer():GetViewModel():LookupAttachment( "muzzle" ) ).Pos:ToScreen()
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawLine( weppos.x, weppos.y, ScrW()/2, ScrH()/2 )
				elseif LocalPlayer():GetViewModel():LookupAttachment( "1" )>0 then
					local weppos = LocalPlayer():GetViewModel():GetAttachment( LocalPlayer():GetViewModel():LookupAttachment( "1" ) ).Pos:ToScreen()
					surface.SetDrawColor( Color( 0, 0, 255, 255 ) )
					surface.DrawLine( weppos.x, weppos.y, ScrW()/2, ScrH()/2 )
				end
			end
			HIcon = surface.GetTextureID( "infectedwars/HUD/HUD_assault" )
			surface.SetTexture( HIcon )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( 0, ScrH()-ScreenScale(78), ScreenScale(78), ScreenScale(78) )
		end
		if LocalPlayer():Team() == 1 then
			if LocalPlayer():Alive() and LocalPlayer():GetActiveWeapon():IsValid() then
				ZIcon = surface.GetTextureID( "infectedwars/HUD/HUD_zombie" )
				surface.SetTexture( ZIcon )
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawTexturedRect( -ScreenScale(8), ScrH()-ScreenScale(97), ScreenScale(97), ScreenScale(97) )
			end
			if LocalPlayer():GetActiveWeapon():IsValid() then
				LocalPlayer():GetViewModel():SetMaterial( "models/flesh" )
			end
		else
			if LocalPlayer():GetActiveWeapon():IsValid() then
				LocalPlayer():GetViewModel():SetMaterial( "" )
			end
		end
	end
	
	return self.BaseClass:HUDPaint()
end

ahalpha = 0

function GM:HUDPaintBackground()

	//infected render effect
	if LocalPlayer():Team() == 1 then
		surface.SetDrawColor( Color( 255, 0, 0, 10 ) )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
	end

	local ahdecal = surface.GetTextureID("infectedwars/HUD/armorhit")

	if (ahalpha <= 0) then return end
	ahalpha = math.max(0,ahalpha-FrameTime()*400)
	surface.SetTexture( ahdecal )
	if LocalPlayer():Team() == 0 and LocalPlayer():GetSuit() > 0 and LocalPlayer():GetSuitMode() == 0 then
	surface.SetDrawColor( Color(0,255,255,ahalpha) )
	else
	surface.SetDrawColor( Color(255,0,0,ahalpha) )
	end
	surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
end

//IMPLEMENT THIS
function GM:HUDDrawTargetID()

end

function PlayerHit()
	surface.PlaySound( sound[math.Round(math.random( 4, 5))].path )
	ahalpha = 200
end

function PaintElement( )
	paintls = true
	timer.Simple( 6, function() paintls = false end )
end

function PaintFinalStats( )
	paintfs = true
	timer.Simple(1, function()
		surface.PlaySound(sound[7+LocalPlayer():Team()].path) end)
	timer.Simple(25, function()
		paintfs = false RunConsoleCommand("stopsound") end)
end

//VOID OVERRIDES

function GM:HUDWeaponPickedUp( wep ) end
function GM:HUDItemPickedUp( itemname ) end
function GM:HUDAmmoPickedUp( itemname, amount ) end
function GM:HUDDrawPickupHistory( ) end

//NET SHIT
net.Receive( "Utility", function( len )
	LocalPlayer().Utility = net.ReadInt( 8 ) end)
	
net.Receive( "MaxHealth", function ( len )
	LocalPlayer().MaxHealth = net.ReadInt( 16 ) end)
	
net.Receive( "SuitMode", function ( len )
	LocalPlayer().SMode = net.ReadInt( 8 ) end)

net.Receive( "Suit", function ( len )
	LocalPlayer().Suit = net.ReadInt( 16 ) end)

net.Receive( "SuitMax", function ( len )
	LocalPlayer().SuitMax = net.ReadInt( 16 ) end)
	
net.Receive( "CSound", function ( len )
	surface.PlaySound( sound[net.ReadInt( 8 )].path ) end)
	
net.Receive( "Hit", function( len )
	PlayerHit() end)
	
net.Receive( "Time", function( len )
	iwtime = net.ReadInt( 16 ) end )
	
net.Receive( "Paint", function( len )
	PaintElement( ) end )
	
net.Receive( "StopSound", function ( len )
	RunConsoleCommand( "stopsound" ) end )
finalstats = finalstats or {}
net.Receive( "FinalStats", function ( len )
	finalstats = net.ReadTable() PaintFinalStats() end )
	
lachieve = lachieve or {}
net.Receive( "Achieve", function( len )
	lachieve = net.ReadTable() end )
	
net.Receive( "DBmenu", function( len )
	DrawDBMenu() end )

net.Receive( "Statmenu", function( len )
	DrawStatMenu() end )
	
stats = stats or {}
net.Receive( "Stats", function( len )
	stats = net.ReadTable() end )