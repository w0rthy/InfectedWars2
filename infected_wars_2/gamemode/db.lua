pweapons = {}
pweapons.human={}
pweapons.infected = {}
sweapons = {}
sweapons.human = {}
sweapons.infected = {}
utilities = {}
utilities.human = {}
utilities.infected = {}
suitmodes = {}
sound = {}
texture = {}
classes = {}
classes.human = {}
classes.infected = {}
//HUMAN PRIMARY
pweapons.human[1]={name = "Light SMG", desc = "An smg that is most effective in close range encounters.", object = "iw_mp7", wmodel = "models/weapons/w_smg1.mdl", type = "SMG", req = {"none"}}
pweapons.human[2]={name = "M4A1 AR", desc = "A decent all-purpose weapon.", object = "iw_m4a1", wmodel = "models/weapons/w_rif_m4a1.mdl", req = {"firstone"}}
pweapons.human[3]={name = "M249 MG", desc = "A heavy support weapon with a high rate of fire and clip size", object = "iw_m249", wmodel = "models/weapons/w_mach_m249para.mdl", type = "AR", req = {"spray"}}
pweapons.human[4]={name = "M3 SG", desc = "A good shotgun with decent accuracy and damage.", object = "iw_m3super90", wmodel = "models/weapons/w_shot_m3super90.mdl", type = "SG", req = {"none"}}
pweapons.human[5]={name = "Scout RF", desc = "A light rifle with good accuracy.", object = "iw_scout", wmodel = "models/weapons/w_snip_scout.mdl", type = "RF", req = {"marksman"}}
//HUMAN SECONDARY
sweapons.human[1]={name = "9mm", desc = "An ordinary pistol with a good clip size.", object = "iw_9mm", wmodel = "models/weapons/w_Pistol.mdl", type = "SD", req = {"none"}}
sweapons.human[2]={name = ".38 Revolver", desc = "Much more powerful than the 9mm but has a much smaller clip.", object = "iw_pocrev", wmodel = "models/weapons/w_357.mdl", req = {"headshot"}}
sweapons.human[3]={name = "Glock .40", desc = "A powerful handgun with good damage and accuracy.", object = "iw_glock", wmodel = "models/weapons/w_pist_glock18.mdl", type = "SD", req = {"pete"}}
sweapons.human[4]={name = "Desert Eagle .50", desc = "A large handgun that suffers from accuracy and clip size.", object = "iw_deagle", wmodel = "models/weapons/w_pist_deagle.mdl", type = "SD", req = {"hipower"}}
//INFECTED PRIMARY
pweapons.infected[1]={name = "Swarm Blaster", desc = "Decent weapon that can deal good damage at closer ranges.", object = "iw_inf_swarmblaster", wmodel = "models/weapons/w_smg1.mdl", type = "SMG", req = {"none"}}
pweapons.infected[2]={name = "Hell Raiser", desc = "Lower damage weapon that makes up for it with greater accuracy and a suit drain.", object = "iw_inf_hellraiser", wmodel = "models/weapons/w_rif_galil.mdl", type = "SP", req = {"leech"}}
//INFECTED SECONDARY
sweapons.infected[1]={name = "Hornet Gun", desc = "Your average infected sidearm, you should replace this quickly once you get better options.", object = "iw_inf_hornetgun", wmodel = "models/weapons/w_Pistol.mdl", type = "SD", req = {"none"}}
//HUMAN UTILITIES
utilities.human[1]={name = "Rangefinder", desc = "Displays range to the target and increases accuracy with all weapons.", wmodel = "models/props_c17/consolebox01a.mdl", req = {"none"}}
utilities.human[2]={name = "Recharger", desc = "Increases rate of suit recharge.", wmodel = "models/props_combine/suit_charger001.mdl", req = {"helping"}}
utilities.human[3]={name = "Helmet", desc = "Headshots no longer do bonus damage to you.", wmodel = "", req = {"fortheteam"}}
//UNDEAD UTILITIES
utilities.infected[1]={name = "Leech", desc = "Heals you for a percent of damage dealt.", wmodel = "models/Gibs/Antlion_gib_Large_2.mdl", req = {"none"}}
utilities.infected[2]={name = "Rotten Flesh", desc = "Slightly damages all enemies around you.", wmodel = "models/Humans/corpse1.mdl", req = {"none"}}
//SUIT MODES
suitmodes[0]={name = "Armor", col = Color( 0, 0, 255, 255 ), drain = 0}
suitmodes[1]={name = "Regen", col = Color( 255, 255, 0, 255), drain = -3}
suitmodes[2]={name = "Agility", col = Color( 255, 0, 0, 255), drain = 4}
//SOUND INDEX
sound[1]={desc = "suit change", path = "items/battery_pickup.wav"}
sound[2]={desc = "out of suit", path = "common/warning.wav"}
sound[3]={desc = "achievement unlock", path = "weapons/physcannon/energy_disintegrate5.wav"}
sound[4]={desc = "hit sound 1", path = "weapons/crossbow/hitbod1.wav"}
sound[5]={desc = "hit sound 2", path = "weapons/crossbow/hitbod1.wav"}
sound[6]={desc = "last stand music", path = "infectedwars/iw_lasthuman.mp3"}
sound[7]={desc = "human win music", path = "music/HL2_song32.mp3"}
sound[8]={desc = "infected win music", path = "music/Ravenholm_1.mp3"}
//CLASS INDEX
classes.human[1]={name = "Assault", desc = "Offensive class that has bonuses when using Assault Rifles and Shotguns.", Health = 120, Suit = 120, mspd = 270, bonus = {"AR","SG"}, pmodel = "models/player/combine_soldier.mdl"}
classes.human[2]={name = "Support", desc = "This class has good health and gains bonuses when using Machine Guns.", Health = 140, Suit = 110, mspd = 270, bonus = {"MG"}, pmodel = "models/player/combine_soldier_prisonguard.mdl"}
classes.human[3]={name = "Scout", desc = "Maneuverable and agile class that has bonuses when using Sniper Rifles and Pistols.", Health = 105, Suit = 130, mspd = 310, bonus = {"RF","SD"}, pmodel = "models/player/police.mdl"}
classes.human[4]={name = "Supplies", desc = "A class aimed at helping others on your team. Procures a bonus when using Sub-Machine Guns.", Health = 120, Suit = 130, mspd = 280, bonus = {"SMG"}, pmodel = "models/player/combine_super_soldier.mdl"}
//INFECTED
classes.infected[1]={name = "Zombie", desc = "Standard class that has bonuses to using Rifles and other accurate weapons.", Health = 160, mspd = 270, bonus = {"AR","RF"}, pmodel = "models/player/zombie_classic.mdl"}
classes.infected[2]={name = "Bones", desc = "Agile and quick class that has bonuses when using Shotguns and Sub-Machine Guns.", Health = 110, mspd = 390, bonus = {"SMG","SG"}, pmodel = "models/player/zombie_fast.mdl"}
classes.infected[3]={name = "Warghoul", desc = "Beefy class that has bonuses when using Pistols and special weapons.", Health = 160, mspd = 270, bonus = {"SD","SP"}, pmodel = "models/Humans/corpse1.mdl"}
//ACHIEVEMENTS
achieve = {}
achieve["firstone"] = {name = "First One", desc = "Kill an infected", type = "passive"}
achieve["spray"] = {name = "Spray n' Prey", desc = "Kill 5 infected with the M3 in one round", type = "round"}
achieve["marksman"] = {name = "Marksman", desc = "kill an infected over 40m away", type = "passive"}
achieve["fortheteam"] = {name = "For The Team", desc = "Take one for the team", type = "passive"}
achieve["headshot"] = {name = "Headshot", desc = "Shoot an infected in the head", type = "passive"}
achieve["pete"] = {name = "Pistol Pete", desc = "Accumulate 10 kills with the 9mm in one round", type = "round"}
achieve["hipower"] = {name = "High-Powered", desc = "Deal a headshot with the scout", type = "passive"}
achieve["leech"] = {name = "Leech", desc = "Steal 100 health in one life.", type = "life"}
achieve["helping"] = {name = "Helping Hand", desc = "Heal 200 health in one life", type = "round"}