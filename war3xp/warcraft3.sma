/* AMX Mod script. 
* 
*  Warcraft 3 XP by SpaceDude 
*  Update/Modifications by: Mr. B, Dopefish, Tri Moon, Mike4066, [AoL]LuckyJ, 
*				[AoL]Demandred, Pimp Daddy, Denkkar Seffyd, rACEmic
* 
*  Read warcraft3.txt for installation information.
*  Read wc3changelog.txt for info about this plugins history of changes.
*		
*  Version 2.22.9 RC19 , last modified 9/20/2003
*
*  Supports AMX 0.9.6 (by default) and AMX 0.9.3 (with compile option)
*
*/ 


/* 
XP FORMULAS:

Bombing Bonus For Terrorists:
	       Planter: 3 * xpgiven[playerlevel]	
	    Supporters: BOMBPLANTXP + xpgiven[playerlevel]	
	  Kill Defuser: xpgiven[victimlevel]
       Spawn With Bomb: xpgiven[playerlevel]
           Pickup Bomb: xpgiven[playerlevel]
             Drop Bomb: -xpgiven[playerlevel]
	    
Bombing Bonus For Counter-Terrorists:
	       Defuser: 3 * xpgiven[playerlevel]	
	    Supporters: BOMBPLANTXP + xpgiven[playerlevel]	
	Defuse Attempt:	xpgiven[playerlevel]
     Kill Bomb Carrier: xpgiven[victimlevel]
	  
Hostage Bonus For Counter-Terrorists:
Hostage Grab:		xpgiven[playerlevel]
Hostage Rescue:Rescuer: -1 * xpgiven[playerlevel]    <--- HAA-HAA hostage theives, teach them
	    Supporters: HOSTAGEXP + xpgiven[playerlevel]

Hostage Bonus For Terrorists:	
Kill Hostage Rescuer:   KILLRESCUEMANXP +  2 * xpgiven[victimlevel]

Hostage Punishment For ALL:
Hostage Killing: 	KilledHostageIndex[id] * xpgiven[playerlevel] <--- This amount is subtracted

VIP Bonus For Counter-Terrorists:
	VIP Spawn Bonus: xpgiven[playerlevel]
     	     VIP Escape: xpgiven[playerlevel]
     VIP Escape Support: ESCAPEXP + xpgiven[playerlevel]]

VIP Bonus For Terrorists:
	 VIP Kill Bonus: VIP_KILL_BONUS + xpgiven[playerlevel]
	 
Regular Kill:   	 xpgiven[victimlevel]
Headshot Kill:   	 HEADSHOT_BONUS + xpgiven[victimlevel]	
Multi-Kill:		 Do you want this? It's the only bonus I havn't awarded yet... ;-)

 		       level =  0 1  2  3  4  5  6  7  8  9 10
 		     xpgiven = {6,8,10,12,14,16,20,24,28,32,40}  
*/

#include <amxmod>
#include <amxconst>

/* ---------------------------------- Enter Warcraft 3 configuration area --------------------------------------	*/

#define AMX_VERSION_093	0	// Set 0 for AMX 0.9.6	 or   set 1 for AMX 0.9.3
				// Note: Putting 0 means you must have Vexd_Utilities.
				// Putting 1 means you are using the war3.dll.
				// You also need their respective include files.

#define MYSQL_ENABLED 1		// Set this to 0 to disable and use the War3users.ini save method.

// Set Warcraft 3 for your Counterstrike version		
#define STEAM_POWERED 1  	// Set to 1 if you are running Counterstrike 1.6, leave at 0 for 1.5

#define BOMBPLANT_XP_BONUS 50		// What you see is what you get 
#define DEFUSE_XP_BONUS 50		// These are set correctly for longterm XP
#define HOSTAGE_XP_BONUS 50		// Ex: 87 bomb plant bonus, gives you87 XP
#define KILLRESCUEMAN_XP_BONUS 50	// For short term XP, this is multiplied by 10
#define KILL_BOMB_CARRIER 25		// Set to 0 to disable entirely. Otherwise set to base XP to award.
#define VIP_KILL_BONUS 50		// Set to VIP killing reward. Note: You can give exactly 0 XP for this, by setting to 0.
#define VIP_ESCAPE_BONUS 50		// Set to VIP escape reward.
#define TOME_XP_BONUS 15		// XP for buy a tome of experience.

#define HOSTAGE_TOUCH_BONUS 1 	// Set 1 to enable.
#define ATTEMPT_DEFUSE_BONUS 1  // Set 1 to enable. 

#define HEADSHOT_BONUS 10 	// Set integer to number given as reward for headshot kills.
#define DEFUSER_KILL_BONUS 1 	// Set 1 to enable. Gives Bonus for killing the bomb defuser.
#define BOMB_EVENT_BONUS 1	// Set 1 to enable. Bonus for spawn, pickup, drop bomb.
#define VIP_SPAWN_BONUS 1	// Set 1 to enable.


#define BOMBSHAREXPRADIUS 1000	// Old value is 2500, this reached all the way to the H in de_dust when planting at B.
#define HOSTAGESHAREXPRADIUS 1000

#define OBJECTIVE_XP_PRINT 1	// If enabled, will print private messages to client console showing the XP they gain 
				// for completeting an objective. This will let even the n00bs catch on to quick XP
				// gain by being near the action.	
	
/*			
Hostage Punishment Formula: (this info may be innacurate)

Punishment Activation: 		When player kills HOSTAGE_KILL_MAX, or more, hostages.
Number of 3 damage slaps:  	hostages killed * 2
Amount of XP removed: 		hostages killed * xpgiven[id]			
*/	
#define HOSTAGE_KILL_MAX 3	// Max hostages that can be killed without punishment.	
#define HOSTAGE_KILL_SLAP 1	// Set 1 to enable. Slaps player.	
#define HOSTAGE_KILL_XP 1 	// Set 1 to enable. Removes XP.	
#define FORGIVE_HOSTKILL_ROUND 1 // Set 1 to enable. Resets hostages killed tracking each round.
		
		
// Database/Users.ini Pruning Control
#define DAYS_BEFORE_DELETE 14	// No longer uses sv_daysbeforedelete. Applies to INI save method as well.	
				// Level modifier no longer exists.				

// Works flawlessly
#define MYSQL_AUTO_PRUNING 1	// Automatically prunes the database of old users at a mapchange 
				// occuring between 5:36 to 5:59 AM. 
				
				
// Statistics Blocks designed for Warcraft 3 CS 1.5 (DOES NOT WORK IN CS 1.6)
#define WAR3STATS 0		// Set to 1 to enable.
				// Displays correct Attacker / Victim damage, hits, and XP gain.
				// Players can type "stats" at any time.
				
#define WAR3_MYSQL_TOP15 0	// MYSQL and WAR3STATS required for this one. Set 1 to enable.
				// Gives players Skill ratings, Rank, and Top 15 player list.
				// Will save rank to war3stats table (creates automatically).	
				// If MSYQL pruning is enabled, the war3stats table is pruned as well,
				// if there's a mapchange between 5:05 to 5:35 AM. 
				// Skill = Kills (inc. Ultimates) + Objective Points - Deaths					
	
// Prevent XP exploits using objectives on a near empty server (ex: at 5:00 AM)
#define XPLOIT_PROTECT 4	// Set minimum number of players for objective XP handouts.
				// Ex: Set to 4, you need exactly 4 players for XP Bonus'.	

// Optional player ability to re-arrange their skill tree. Access with war3menu.
#define OPT_RESETSKILLS 1 	// Players have been asking for this... here it is. GJ Dopefish.

// Ultimate Skills Tweaking Area
#define LIGHTNING_DAMAGE 50	// Orc lightning is usually at 50 HP damage
#define EXPLOSION_RANGE 300     // Undead Suicide bomber is usually at 300 range
#define ULTIMATESEARCHTIME 50 	// How long you hear beep beep beep for... default is 50.

#define ULTIMATE_WARMUP 25.0	// Ultimates do not work for X seconds with this feature.
#define CHAINLIGHTNING_COOLDOWN 40.0	// Default is 45.0
#define ENTANGLEROOTS_COOLDOWN 40.0	// Default is 45.0
#define TELEPORT_COOLDOWN 40.0	// Default is 10.0 for old teleport code.
				// A value similar to Lightning and Entangle is recommended for new teleport code.	
		
#define BLINK_HUMAN_ULTIMATE 1 	// Set 1 to enable. Teleports player to where they are aiming. 
				// Note: to balance it, I made players "dizzy" when they do it.

#define BLINK_RADIUS	400	// In this radius, enemies with the immunity necklace will cause the 
				// teleport to fail. (For Human Blick ultimate only).	
	
// Forces player to wait before re-attempting to teleport if the teleportation fails.
#define RETRY_COOLDOWN 3.0	// Default is 3.0, no effect if BLINK_HUMAN_ULTIMATE is 0
	

// Modify level requirements for getting the Ultimate skill.
#define MODIFIED_ULT_LEVEL 0 	// Set 1 to enable modified skill requirements.				
#define UNDEAD_ULT 6		// Default values is 6 for each race.
#define HUMAN_ULT 6
#define ORC_ULT 6
#define ELF_ULT 6

						
	
// XP Reseting At Level 11 - Need feedback for what to do with this (ex: delete it all?)
// WARNING: Do not enable. A situation could occur where the player will not get his God Mode on reset.
#define XPRESET 0      		// Set to 0 to disable code that detects level 11 and resets char.
#define RESETLEVEL 7       		// Hard level to reset XP too. Player can also choose random (1 to 10). 
#define MIN_RESET_LEVEL	5		// If the player rolls the dice on reset and gets level < MIN_RESET_LEVEL, give 2nd chance.
#define RESET_XP_LEVEL_NOSAVE 6700 	// Should be greater than level 10 (5500), no effect if XPRESET 0.
#define RESET_XP_LEVEL_SAVE 102400     	// Should be greater than level 10 (51200), no effect if XPRESET 0.
#define GOD_BLESS_ROUNDNUM 4 		// Number of rounds a reseted player gets God Mode for.	
	
// Miscelleaneous changes	
#define KNIFEINVISIBILITY 70  	// Version 2.22.8 has this at 60 which makes players easier to see.
 
#define ORCNECKLACE 0 		// Set to 1 if the Necklace should protect against Orc Grenades
#define ORCNADE_CVAR 1 		// Set to 1 to create an Orc Grenade CVAR. 				
				// amx_cvar mp_alloworcnade 0 to disable orc grenades.
				// Recommend plugin to set it for specific maps.
				// Get one here: http://amxmod.net/forums/viewtopic.php?p=40104

#define XP_CHANGEABLE_OUTSIDE 1 // Enabling this will allow you to remove XP from another plugin with
				// this command:  server_cmd("wc3_changexp %d %d",id,xpAmount) 
				
#define WARN_SUICIDERS 1 	// Tells Undead Scourges their bomb is armed when they hit ultimate key.
				// A second key press then detonates it. This resolves accidental explosion problem.				

#define ULTIMATE_READY_SOUND 0	// Set 1 to enable. When your ultimate is ready again it says "Power Restored".								
				// Send me a better sound please! denkkar@261.recongamer.com
#define ULTIMATE_READY_ICON 1	// Flashes a Lightning symbol on the left when Ultimate is ready.
			
#define SLAY_LOSERS 1		// Set 1 to enable. Slays the losing team.
				// Ex: T's plant the bomb. CT's don't defuse. CT's are slayed.
			
// Optional HUD Event Warnings
#define BOMB_WARNINGS  1	// Warns when bomb is planted, defused, etc. HUD and sound countdown on plant.
				// WARNING: Designed for AMX 0.9.6 or better. Poor performance otherwise.
			
#define VIP_EVENTS 1		// VIP spawns, killed, escapes HUD messages.
#define HOSTAGE_EVENTS 1	// Hostage killed, rescued, touched, HUD messages (touched sent to CT only).


#define SHOPMENU_IN_BUYZONE 1	// Restrict shopmenu to buyzone area

#define SPAWN_PROTECT 8.0	// Protects players from premature death for 10.0 seconds.
				// Set to 0 to disable.
						
#define NON_ULTIMATE_VIP 1	// Stop VIP's from using Ultimate abilities. Warns them too.
				// Set 1 to deny them their powers.	
			
#define MULTI_WEP_FIX	1	// Multi-weapon fix, set 1 to enable. Disarms before re-incarnation.
				// No side effects! No double weapons. 		
				
#define DISABLE_FORCESKIN 1	// Set to 1 to disable forceskin code (from SpaceDude I presume).
				// This will fix issues with a different player model appearing on death.	
				

/* --------- NEXT TWO OPTIONS SHOULD BE SET TO ZERO  (FOR DEV USE) --------- */	
#define DEBUG_LOGGER	0	// Logs crap to log file. For Denkkar's entertainment.
#define TEST_MODE 0		// Gives every client who connects a level 10 char. For testing only.				
							
/* ---------------------------------- Exit Warcraft 3 configuration area --------------------------------------	*/		

/*     Just kidding, scroll down another page and there's a 2nd area you can configure ;-)        */

#define TE_BEAMPOINTS 0
#define TE_EXPLOSION 3
#define TE_EXPLFLAG_NONE 0
#define TE_SMOKE 5
#define TE_BEAMENTS 8
#define TE_IMPLOSION 14
#define TE_SPRITETRAIL 15
#define TE_BEAMCYLINDER	21
#define TE_BEAMFOLLOW 22
#define TE_ELIGHT 28
#define TE_PLAYERATTACHMENT 124
#define BLASTCIRCLES_RADIUS 250
#define EXPLOSION_MAX_DAMAGE 50
#define LIGHTNING_RANGE 500
#define TELEPORT_RADIUS 50
#define MAXGLOW 150
#define BOOTSPEED 285.0
#define CLAWSOFATTACK 10
#define CLOAKINVISIBILITY 160
#define MASKPERCENT 0.3
#define FROSTSPEED 125.0
#define HEALTHBONUS 40
#define ELF_EVADE_ADJ 1024

#define MAX_NAME_LENGTH 31
#define MAX_VAR_LENGTH 64 
#define MAX_PLAYERS 32 
#define MAX_TEXT_LENGTH 512 
#define EVENT_MSG_ALL   0 
#define EVENT_MSG_T      1 
#define EVENT_MSG_CT   2 
			
#define ANKH 1
#define BOOTS 2
#define CLAWS 3
#define CLOAK 4
#define MASK 5
#define IMMUNITY 6
#define FROST 7
#define HEALTH 8
#define TOME 9

/* ---------------------------------- Enter Warcraft 3 configuration area 2--------------------------------------	*/		


//                 Ankh, Boots,Claws,Cloak, Mask, Necklace,  Orb, Health, Tome
new itemcost[9] = {1500,  2000, 1000,  800, 2000,     1000, 2000,   1000, 4000}

new Float:p_vampiric[3] = {0.15,0.30,0.45}	// Vampiric Aura (skill 1)
new p_vampirichealth[3] = {100,100,100}		// Vampiric Aura Max Health (skill 1)
new Float:p_unholy[3] = {260.0,285.0,310.0}	// Unholy Aura (skill 2)
new Float:p_levitation[3] = {0.8,0.6,0.4}	// Levitation (skill 3)

new p_invisibility[3] = {180,150,120}		// Invisibility (skill 1)
new p_devotion[3] = {115,130,145}		// Devotion Aura (skill 2)
new Float:p_bash[3] = {0.15,0.30,0.45}		// Bash (skill 3)

new Float:p_critical[3] = {0.15,0.15,0.15}	// Critical Strike (skill 1)
new Float:p_grenade[3] = {1.0,3.0,5.0}		// Critical Grenade (skill 2)
new Float:p_ankh[3] = {0.333,0.666,1.0}		// Equipment reincarnation (skill 3)

new Float:p_evasion[3] = {0.1,0.2,0.3}		// Evasion (skill 1)
new Float:p_thorns[3] = {0.05,0.1,0.15}		// Thorns Aura (skill 2)
new Float:p_trueshot[3] = {0.13,0.27,0.40}	// Trueshot Aura (skill 3)

/* ---------------------------------- Exit Warcraft 3 configuration area 2--------------------------------------	*/		

//#if AMX_VERSION_093
	#include <war3>
//#else
	//#include <Vexd_Utilities>
//#endif

#if MYSQL_ENABLED
	#include <mysql>
	new bool:needsSQLEntry[33]          // does player have an account?
	new mysql
	new mysqltablename[64]
#else
	new Float:lastupdate
	new savedline[64][128]
	new XPFILENAME[] = "war3users.ini"
#endif


#if STEAM_POWERED
	new zoomed[33]
#endif

new freezetime = 0
#if ULTIMATE_READY_ICON
	new gmsgIcon 
#endif
#if WAR3STATS
	new dmgStat[33][33]	
	new hitStat[33][33]
	new xpStat[33][33]
#endif
#if WAR3_MYSQL_TOP15 
	new warStatTable[10] = "war3stats"
	new warRankTable[10] = "war3ranks"
	new skillStat[33] 	// Skill, frags-deaths+objectives
	new rank[33]		// Relative to all players skill
	new top15[15][32]	// Names of the top 15 players
	new bool:needsStatsEntry[33]	// For players without an existing mySQL stats entry
#endif


#if SHOPMENU_IN_BUYZONE
	new bool:isBuyzone[33] 
#endif

#if DEBUG_LOGGER	
	new logfilename[256] = "addons/amx/logs/war3load.log"
	new logfile2[256] = "addons/amx/logs/war3save.log"
	//log_to_file(logfilename,"%s dealt %d damage to %s",attacker,damage,victim) 
#endif


new p_level[33]
new p_skills[33][5]
new iglow[33][4]
new armorondeath[33]
new savedweapons[33][32]
new savednumber[33]
new playerxp[33]
new KilledHostageIndex[33]
new gHostageSaverIndex[33] 
new playeritem[33]
#if MULTI_WEP_FIX
	new playerItemOld[33]
#endif
new bool:p_evadenextshot[33]
new bool:diedlastround[33]
new bool:stunned[33]
new bool:slowed[33]
new bool:issearching[33]
new bool:lightninghit[33]
new bool:ultimateused[33]
new bool:gogogo


#if OPT_RESETSKILLS
	new bool:resetskill[33]
#endif

#if XPLOIT_PROTECT
	new bool:antiExploit
#endif




new bool:hasgrenade[33]
new bool:hasdefuse[33]
new bool:helmet[33]
new bool:changingrace[33]
new bool:changingteam[33]
new bool:knifeselected[33]
new bool:warcraft3
new bool:saved_xp
#if !BLINK_HUMAN_ULTIMATE
	new bool:endround
#endif

new Float:voting
new Float:vote_ratio
new option
new bombdefuser
new vipID = 0

#if ATTEMPT_DEFUSE_BONUS
        new bombDefuserIndex[33]
#endif

#if KILL_BOMB_CARRIER
	new bombCarrier
#endif

#if XPRESET
	new resetedPlayerID[33]
	new godBlessed[33]	
#endif


#if BLINK_HUMAN_ULTIMATE
	new savedOldLoc[33][3]
	new savedNewLoc[33][3]
#else 
	new teleportid[33][32]
	new bool:teleportmenu[33]
#endif

#if WARN_SUICIDERS
	new suicideAttempt[33]	
#endif

#if SLAY_LOSERS
	new white
#endif


#if BOMB_WARNINGS
	new gBombTimer
#endif

new gmsgStatusText
new gmsgDeathMsg
new gmsgFade
new gmsgShake
new g_sModelIndexFireball
new g_sModelIndexSmoke
new iBeam4
new m_iTrail
new m_iSpriteTexture
new lightning
new flaresprite 



#if XPRESET
	new xplevel[12] = {0,100,300,600,1000,1500,2100,2800,3600,4500,5500,RESET_XP_LEVEL_NOSAVE}
	new xpgiven[12] = {60,80,100,120,140,160,180,200,220,240,260,260}
#else
	new xplevel[11] = {0,100,300,600,1000,1500,2100,2800,3600,4500,5500}
	new xpgiven[11] = {60,80,100,120,140,160,180,200,220,240,260}
#endif



new KILLRESCUEMANXP = KILLRESCUEMAN_XP_BONUS  * 10
new HOSTAGEXP = HOSTAGE_XP_BONUS * 10 
new DEFUSEXP = DEFUSE_XP_BONUS * 10
new BOMBPLANTXP = BOMBPLANT_XP_BONUS * 10 
new XPBONUS = TOME_XP_BONUS * 10

new Float:weaponxpmultiplier[31] = {1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0}

new racename[5][] = {"No race","Undead Scourge","Human Alliance","Orcish Horde","Night Elves of Kalimdor"}
new shortracename[5][] = {"No race","Undead", "Human", "Orc", "Night Elf"}

new itemname[9][] = {"Item: Ankh","Item: Boots","Item: Claws","Item: Cloak","Item: Mask","Item: Necklace","Item: Orb","Item: Periapt","Item: Tome"}
new longItemName[9][] = {"Ankh of Reincarnation","Boots of Speed","Claws of Attack +6","Cloak of Shadows","Mask of Death","Necklace of Immunity","Orb of Frost","Periapt of Health","Tome of Experience"}

new race1skill[4][] = {"Vampiric Aura","Unholy Aura","Levitation","Suicide Bomber"}
new race2skill[4][] = {"Invisibility","Devotion Aura","Bash","Teleport"}
new race3skill[4][] = {"Critical Strike","Critical Grenade","Equipment Reincarnation","Chain Lightning"}
new race4skill[4][] = {"Evasion","Thorns Aura","Trueshot Aura","Entangle Roots"}

public set_xpmultiplier(){
        if (!get_cvar_num("mp_weaponxpmodifier"))
                return PLUGIN_CONTINUE

        weaponxpmultiplier[CSW_USP] = 1.25
        weaponxpmultiplier[CSW_DEAGLE] = 1.25
        weaponxpmultiplier[CSW_GLOCK18] = 1.25
        weaponxpmultiplier[CSW_ELITE] = 1.5
        weaponxpmultiplier[CSW_P228] = 1.5
        weaponxpmultiplier[CSW_FIVESEVEN] = 1.5

        weaponxpmultiplier[CSW_XM1014] = 1.25
        weaponxpmultiplier[CSW_M3] = 1.5

        weaponxpmultiplier[CSW_MP5NAVY] = 1.0
        weaponxpmultiplier[CSW_UMP45] = 1.25
        weaponxpmultiplier[CSW_P90] = 1.25
        weaponxpmultiplier[CSW_TMP] = 1.5
        weaponxpmultiplier[CSW_MAC10] = 1.5

        weaponxpmultiplier[CSW_AWP] = 1.0
        weaponxpmultiplier[CSW_M4A1] = 1.0
        weaponxpmultiplier[CSW_AK47] = 1.0
        weaponxpmultiplier[CSW_AUG] = 1.0
        weaponxpmultiplier[CSW_SG552] = 1.0
        weaponxpmultiplier[CSW_G3SG1] = 1.25
        weaponxpmultiplier[CSW_SG550] = 1.25
        weaponxpmultiplier[CSW_M249] = 1.25
        weaponxpmultiplier[CSW_SCOUT] = 1.25

        weaponxpmultiplier[CSW_HEGRENADE] = 1.0
        weaponxpmultiplier[CSW_KNIFE] = 2.0

        weaponxpmultiplier[CSW_C4] = 1.0
        weaponxpmultiplier[CSW_SMOKEGRENADE] = 1.0
        weaponxpmultiplier[CSW_FLASHBANG] = 1.0
        return PLUGIN_CONTINUE
}




// Player Events 
public event_player_action() 
{ 
   new sArg[MAX_VAR_LENGTH], sAction[MAX_VAR_LENGTH] 
   new sName[MAX_NAME_LENGTH] 
   
   #if HOSTAGE_EVENTS
   	new sMsg[MAX_TEXT_LENGTH] 
   #endif
   #if BOMB_WARNINGS && (HOSTAGE_EVENTS == 0 )
   	new sMsg[MAX_TEXT_LENGTH]   	
   #endif
   
   #if VIP_EVENTS && (HOSTAGE_EVENTS == 0) && (BOMB_WARNINGS == 0)  
   	new sMsg[MAX_TEXT_LENGTH]   
   #endif
   
   new id, iUserId 
  
    
   read_logargv(0,sArg,MAX_VAR_LENGTH) 
   read_logargv(2,sAction,MAX_VAR_LENGTH) 
   parse_loguser(sArg,sName,MAX_NAME_LENGTH,iUserId) 
   id = find_player("k",iUserId) 

   // Bomb planted 
   if (equal(sAction,"Planted_The_Bomb")) {  
   	 #if BOMB_WARNINGS
        	format(sMsg,MAX_TEXT_LENGTH,"%s planted the bomb!",sName) 
         	display_msg(sMsg,255,0,0,EVENT_MSG_ALL) 
        
               	new parmB[2]
            	gBombTimer = get_cvar_num("mp_c4timer")
            	 
            	 // Why Denkkar why? Well... umm... it's accurate at least ;-)
            	if( gBombTimer > 40 ){             		             		         
            		parmB[0] = 40 	
            		// set_task(Float:time,const function[],id = 0,parameter[]="",len = 0,flags[]="", repeat = 0);	
            		set_task(gBombTimer-40.0,"bomb_count_control",99180,parmB,2) 
            		parmB[0] = 30
            		set_task(gBombTimer-30.0,"bomb_count_control",99180,parmB,2) 
            		parmB[0] = 20
        		set_task(gBombTimer-20.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 10
        		set_task(gBombTimer-10.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 6
        		set_task(gBombTimer-6.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 5
        		set_task(gBombTimer-5.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 4
        		set_task(gBombTimer-4.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 3
        		set_task(gBombTimer-3.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 2
        		set_task(gBombTimer-2.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 1
        		set_task(gBombTimer-1.0,"bomb_count_control",99180,parmB,2)
            	}else if( gBombTimer > 30 ){            		 
            		parmB[0] = 30
            		set_task(gBombTimer-30.0,"bomb_count_control",99180,parmB,2) 
            		parmB[0] = 20
        		set_task(gBombTimer-20.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 10
        		set_task(gBombTimer-10.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 6
        		set_task(gBombTimer-6.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 5
        		set_task(gBombTimer-5.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 4
        		set_task(gBombTimer-4.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 3
        		set_task(gBombTimer-3.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 2
        		set_task(gBombTimer-2.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 1
        		set_task(gBombTimer-1.0,"bomb_count_control",99180,parmB,2)
        	}else if( gBombTimer > 20 ){        		  		
            		parmB[0] = 20
        		set_task(gBombTimer-20.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 10
        		set_task(gBombTimer-10.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 6
        		set_task(gBombTimer-6.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 5
        		set_task(gBombTimer-5.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 4
        		set_task(gBombTimer-4.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 3
        		set_task(gBombTimer-3.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 2
        		set_task(gBombTimer-2.0,"bomb_count_control",99180,parmB,2)
        		parmB[0] = 1
        		set_task(gBombTimer-1.0,"bomb_count_control",99180,parmB,2)
        	}
        	// ELSE: Your c4 timer is really messed up dude
        		
            	
         #endif 
         
                 
         
        if (warcraft3==false)
		return PLUGIN_CONTINUE
	new origin[3]
	new teamname[32]
	new players[32]
	new numplayers
	new targetorigin[3]
	new targetid
	
	get_user_origin(id, origin)
	get_user_team(id, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
		
	
		
	new temp
	#if XPLOIT_PROTECT						
		if( antiExploit ){
			temp =  3 * xpgiven[p_level[id]]
		}																
	#else
		temp = 3 * xpgiven[p_level[id]]												
	#endif
	
	playerxp[id]+=  temp
				
	#if OBJECTIVE_XP_PRINT	
		//set_hudmessage(0, 160, 97, -1.45, 0.85, 2, 6.0, 15.0, 0.2, 0.3,100);
		//show_hudmessage(targetid,"+%d XP for personally planting the bomb",temp );						
		client_print(id,print_chat, "[WC3] %s recieved %d extra XP for personally planting the bomb.",sName,temp)
	#endif	
			
	
	for (new i=0; i<numplayers; ++i){		// Includes self
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS){
			
			#if XPLOIT_PROTECT						
				if( antiExploit ){
					temp = BOMBPLANTXP + xpgiven[p_level[targetid]]
				}																
			#else
				temp = BOMBPLANTXP + xpgiven[p_level[targetid]]										
			#endif
			
			#if WAR3_MYSQL_TOP15 
				skillStat[targetid] += 2
			#endif
			
			playerxp[targetid]+=  temp
										
			#if OBJECTIVE_XP_PRINT				
				get_user_name(targetid,sName,31)	
				//set_hudmessage(0, 160, 97, -1.05, 0.85, 2, 6.0, 15.0, 0.2, 0.3,101);
				//show_hudmessage(targetid,"^n +%d XP for bomb plant support",temp );					
				client_print(targetid,print_chat, "[WC3] %s recieved %d for supporting the bomb planting effort.",sName,temp)
			#endif					
		}
		displaylevel(targetid, 1)
	}
   } 
   
   // Bomb defused 
   else if (equal(sAction,"Defused_The_Bomb")) { 
      	#if BOMB_WARNINGS
         	format(sMsg,MAX_TEXT_LENGTH,"%s defused the bomb with approximately %d seconds left!",sName,gBombTimer) 
        	display_msg(sMsg,0,100,255,EVENT_MSG_ALL)        	
    	#endif  
      

	if (warcraft3==false)
		return PLUGIN_CONTINUE
	new origin[3]
	new teamname[32]
	new players[32]
	new numplayers
	new targetorigin[3]
	new targetid
	
	get_user_origin(id, origin)
	get_user_team(id, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
	
			
	new temp
	#if XPLOIT_PROTECT						
		if( antiExploit ){
			temp =  3 *  xpgiven[p_level[id]]
		}																
	#else
		temp = 3 *  xpgiven[p_level[id]]											
	#endif
	
	playerxp[id]+=  temp
			
	#if OBJECTIVE_XP_PRINT						
		client_print(id,print_chat, "[WC3] %s recieved %d extra XP for defusing the bomb.",sName,temp)
	#endif	
	
	
		
	for (new i=0; i<numplayers; ++i){		// Includes self
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS){
			
			#if XPLOIT_PROTECT						
				if( antiExploit ){
					temp = DEFUSEXP +  xpgiven[p_level[targetid]]
				}																
			#else
				temp = DEFUSEXP +  xpgiven[p_level[targetid]]										
			#endif
			
			#if WAR3_MYSQL_TOP15 
				skillStat[targetid] += 2
			#endif
				
			playerxp[targetid]+=  temp
						
			#if OBJECTIVE_XP_PRINT				
				get_user_name(targetid,sName,31)						
				client_print(targetid,print_chat, "[WC3] %s recieved %d for supporting the bomb defusing effort.",sName,temp)
			#endif					
		}
		displaylevel(targetid, 1)
	}		
   } 
   // Bomb defusing with a kit 
   else if (equal(sAction,"Begin_Bomb_Defuse_With_Kit")) { 
      #if BOMB_WARNINGS
         format(sMsg,MAX_TEXT_LENGTH,"%s is defusing the bomb with a wire cutter...^n",sName) 
         display_msg(sMsg,0,100,255,EVENT_MSG_CT) 
      #endif   
      
      if (warcraft3==false)
		return PLUGIN_CONTINUE
        
        #if ATTEMPT_DEFUSE_BONUS        	
               if( (++bombDefuserIndex[id] == 1) && (get_user_team(id) == 2) ){  // Team 1 = Terror, Team 2 = CT
                          
                       	new temp
			#if XPLOIT_PROTECT						
				if( antiExploit ){
					temp =  xpgiven[p_level[id]]
				}																
			#else
				temp =  xpgiven[p_level[id]]											
			#endif
			
			#if WAR3_MYSQL_TOP15 
				skillStat[id]++
			#endif
			
			playerxp[id]+=  temp
					
			#if OBJECTIVE_XP_PRINT				  						
				client_print(id,print_chat, "[WC3] %s recieved %d XP for cutting the red wire on the bomb.",sName,temp)
			#endif	 
			displaylevel(id, 1)  
               }
               

	#endif
   } 
   // Bomb defusing without a kit 
   else if (equal(sAction,"Begin_Bomb_Defuse_Without_Kit")) { 
      #if BOMB_WARNINGS
         format(sMsg,MAX_TEXT_LENGTH,"%s is defusing the bomb with his bare hands...^n",sName) 
         display_msg(sMsg,0,100,255,EVENT_MSG_CT) 
      #endif
      
      if (warcraft3==false)
		return PLUGIN_CONTINUE
	        
        #if ATTEMPT_DEFUSE_BONUS        	
               if( (++bombDefuserIndex[id] == 1) && (get_user_team(id) == 2) ){  // Team 1 = Terror, Team 2 = CT
                          
                       	new temp
			#if XPLOIT_PROTECT						
				if( antiExploit ){
					temp =  xpgiven[p_level[id]]
				}																
			#else
				temp =  xpgiven[p_level[id]]											
			#endif
			
			#if WAR3_MYSQL_TOP15 
				skillStat[id]++
			#endif
			
			playerxp[bombdefuser]+=  temp
					
			#if OBJECTIVE_XP_PRINT										
				client_print(id,print_chat, "[WC3] %s recieved %d XP for attempting to defuse bare handed.^n",id,temp)
			#endif	 
			displaylevel(id, 1)  
               }
               

	#endif
   } 
   // Spawned with the bomb 
   else if (equal(sAction,"Spawned_With_The_Bomb")) { 
      #if BOMB_WARNINGS	      	
	        format(sMsg,MAX_TEXT_LENGTH,"%s has the bomb!",sName) 
         	display_msg(sMsg,0,200,0,EVENT_MSG_T) 
      #endif
      if (warcraft3==false)
		return PLUGIN_CONTINUE
	
	#if KILL_BOMB_CARRIER
		bombCarrier = id
	#endif
      
      #if BOMB_EVENT_BONUS        	
                                   
                new temp
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]											
		#endif
		
		#if WAR3_MYSQL_TOP15 
			skillStat[id]++
		#endif
		
		playerxp[id]+=  temp
				
		#if OBJECTIVE_XP_PRINT			   						
			client_print(id,print_chat, "[WC3] %s recieved %d XP for spawning with the bomb.",sName,temp)
		#endif	 
		displaylevel(id, 1)  
                         
	#endif
   } 
   // Dropped bomb 
   else if (equal(sAction,"Dropped_The_Bomb")) { 
      
       if (warcraft3==false)
		return PLUGIN_CONTINUE
      
      #if KILL_BOMB_CARRIER
		bombCarrier = 0
	#endif
      
      #if BOMB_EVENT_BONUS        	
                                   
                new temp
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]											
		#endif
		
		#if WAR3_MYSQL_TOP15 
			skillStat[id]--
		#endif
		
		playerxp[id] -=  temp
				
		#if OBJECTIVE_XP_PRINT			   						
			client_print(id,print_chat, "[WC3] %s lost the %d XP bomb carrying bonus.",sName,temp)
		#endif	 
		displaylevel(id, 1)  
                         
	#endif
   } 
   // Picked up bomb 
   else if (equal(sAction,"Got_The_Bomb")) { 
    
      
     	if (warcraft3==false)
		return PLUGIN_CONTINUE
      
      	#if KILL_BOMB_CARRIER
		bombCarrier = id
	#endif
      
      #if BOMB_EVENT_BONUS        	
                                   
                new temp
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]											
		#endif
		
		#if WAR3_MYSQL_TOP15 
			skillStat[id]++
		#endif
		
		playerxp[id]+=  temp
				
		#if OBJECTIVE_XP_PRINT			   						
			client_print(id,print_chat, "[WC3] %s gained %d XP for picking up the bomb.",sName,temp)
		#endif	 
		displaylevel(id, 1)  
                         
	#endif
   } 
   // Hostage touched 
   else if (equal(sAction,"Touched_A_Hostage")) { 
      #if HOSTAGE_EVENTS
         format(sMsg,MAX_TEXT_LENGTH,"%s found a hostage!",sName) 
         display_msg(sMsg,0,50,128,EVENT_MSG_CT) 
      #endif
      
      if (warcraft3==false)
		return PLUGIN_CONTINUE
      
      #if HOSTAGE_TOUCH_BONUS
		
		new temp
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]										
		#endif
		
		#if WAR3_MYSQL_TOP15 
			skillStat[id]++
		#endif
		
		playerxp[id]+=  temp
				
		#if OBJECTIVE_XP_PRINT		   						
			client_print(id,print_chat, "[WC3] %s recieved %d XP for beginning to escort the hostage to safety.",sName,temp)
		#endif			
		
		displaylevel(id, 1)		
	
	#endif
   } 
   // Hostage rescued 
   else if (equal(sAction,"Rescued_A_Hostage")) { 
      #if HOSTAGE_EVENTS 
         format(sMsg,MAX_TEXT_LENGTH,"%s rescued a hostage!",sName) 
         display_msg(sMsg,0,100,255,EVENT_MSG_ALL) 
      #endif
      
      
	new origin[3]
	new teamname[32]
	new players[32]
	new numplayers
	new targetorigin[3]
	new targetid		
	
	get_user_origin(id, origin)
	get_user_team(id, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
	
	new temp
	#if XPLOIT_PROTECT						
		if( antiExploit ){
			temp = -1 *  xpgiven[p_level[id]]
		}																
	#else
		temp = -1 *  xpgiven[p_level[id]]												
	#endif
		
	playerxp[id]+=  temp
			
	#if OBJECTIVE_XP_PRINT								
		client_print(id,print_chat, "[WC3] %s lost %d XP to the hostage theif tax.",sName,temp)
	#endif	
	
	// Supporters and self				
	for (new i=0; i<numplayers; ++i){		
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS){
			
			#if XPLOIT_PROTECT						
				if( antiExploit ){
					temp = HOSTAGEXP +  xpgiven[p_level[targetid]]	
				}																
			#else
				temp = HOSTAGEXP +  xpgiven[p_level[targetid]]										
			#endif
			
			#if WAR3_MYSQL_TOP15 
				skillStat[targetid]++
			#endif
				
			playerxp[targetid]+=  temp
						
			#if OBJECTIVE_XP_PRINT					
				get_user_name(targetid,sName,31)						
				client_print(targetid,print_chat, "[WC3] %s recieved %d for supporting the hostage run.",sName,temp)
			#endif					
		}				
	}				
	displaylevel(targetid, 1)
      
   } 
   // Hostage killed 
   else if (equal(sAction,"Killed_A_Hostage")) { 
     	#if HOSTAGE_EVENTS
            format(sMsg,MAX_TEXT_LENGTH,"%s killed a hostage!",sName) 
            display_msg(sMsg,255,175,0,EVENT_MSG_ALL)          
      	#endif
      	
      	#if WAR3_MYSQL_TOP15 
		skillStat[id] -= 2
	#endif
     			
	#if HOSTAGE_KILL_SLAP		
		KilledHostageIndex[id] += 1
		if (KilledHostageIndex[id] >= HOSTAGE_KILL_MAX) {
			new parm[3] 
			parm[0] = id
			parm[1] = KilledHostageIndex[id] * 3
			parm[2] = 1
			set_task(3.1, "hostage_kill_punish", 10435, parm, 3, "", 0)											
			client_cmd(id,"spk scientist/youinsane.wav")
			client_print(0,print_chat, "[WC3] %s will be punished for killing hostages.",sName)	
		}else {
			client_cmd(id,"spk scientist/stopattacking.wav")
			user_slap(id,1)
			client_print(0,print_chat, "[WC3] %s was lightly slapped for killing a hostage.",sName)				
		}
	#endif
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	
	#if HOSTAGE_KILL_XP
		new temp
		if (KilledHostageIndex[id] >= HOSTAGE_KILL_MAX) {
			temp = (KilledHostageIndex[id] - 1) *  xpgiven[p_level[id]]
			playerxp[id] -= temp
			#if OBJECTIVE_XP_PRINT												
				client_print(id,print_chat, "[WC3] %s lost %d XP for killing a hostage.",sName,temp)		
			#endif
		}		
	#endif	
		
			
	displaylevel(id, 1)
   } 
   // VIP spawn 
   else if (equal(sAction,"Became_VIP")) { 
      #if VIP_EVENTS
         format(sMsg,MAX_TEXT_LENGTH,"%s has become the VIP!",sName) 
         display_msg(sMsg,0,200,0,EVENT_MSG_ALL) 
      #endif 
      
      vipID = id
      
      if (warcraft3==false)
		return PLUGIN_CONTINUE
      
      #if VIP_SPAWN_BONUS
		
		new temp
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]										
		#endif
		
		#if WAR3_MYSQL_TOP15 
			skillStat[id]++
		#endif
		
		playerxp[id]+=  temp
				
		#if OBJECTIVE_XP_PRINT		   						
			client_print(id,print_chat, "[WC3] %s recieved %d XP for being so important.",sName,temp)
		#endif			
		
		displaylevel(id, 1)		
	
	#endif
      
	} 
	// VIP assassinated 
	else if (equal(sAction,"Assassinated_The_VIP")) { 
		new sNameVIP[MAX_NAME_LENGTH] 
		get_user_name( vipID,sNameVIP,MAX_NAME_LENGTH) 		
	#if VIP_EVENTS             
		format(sMsg,MAX_TEXT_LENGTH,"%s assassinated %s the VIP!",sName,sNameVIP) 
		display_msg(sMsg,255,0,0,EVENT_MSG_ALL) 
	
	#endif
	
	if (warcraft3==false)
		return PLUGIN_CONTINUE
      
      #if VIP_KILL_BONUS
		
		new temp
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp = VIP_KILL_BONUS + xpgiven[p_level[id]]
			}																
		#else
			temp = VIP_KILL_BONUS + xpgiven[p_level[id]]										
		#endif
		
		#if WAR3_MYSQL_TOP15 
			skillStat[id]++
		#endif
		
		playerxp[id]+=  temp
				
		#if OBJECTIVE_XP_PRINT		   						
			client_print(id,print_chat, "[WC3] %s gained %d XP for assinating %s the VIP.",sName,sNameVIP) 
		#endif			
		
		displaylevel(id, 1)		
	
	#endif
   } 
	// VIP escaped 
	else if (equal(sAction,"Escaped_As_VIP")) { 		
		#if VIP_EVENTS 
	         	format(sMsg,MAX_TEXT_LENGTH,"%s the VIP has escaped!",sName) 
	         	display_msg(sMsg,0,100,255,EVENT_MSG_ALL) 
		#endif
      
	if (warcraft3==false)
		return PLUGIN_CONTINUE
		       	
	
	new origin[3]
	new teamname[32]
	new players[32]
	new numplayers
	new targetorigin[3]
	new targetid
	
	
	get_user_origin(id, origin)
	get_user_team(id, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
			
	new temp
	#if XPLOIT_PROTECT						
		if( antiExploit ){
			temp = xpgiven[p_level[id]]
		}																
	#else
		temp = xpgiven[p_level[id]]												
	#endif
	
	playerxp[id]+=  temp
				
	#if OBJECTIVE_XP_PRINT	
		new nName[31]		
		//set_hudmessage(0, 160, 97, -1.45, 0.85, 2, 6.0, 15.0, 0.2, 0.3,100);
		//show_hudmessage(targetid,"+%d XP for personally planting the bomb",temp );						
		client_print(id,print_chat, "[WC3] %s gained %d extra XP for evading assasination.",sName,temp)
	#endif	
			
	
	for (new i=0; i<numplayers; ++i){		// Includes self
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS){
			
			#if XPLOIT_PROTECT						
				if( antiExploit ){
					temp = VIP_ESCAPE_BONUS + xpgiven[p_level[targetid]]
				}																
			#else
				temp = VIP_ESCAPE_BONUS + xpgiven[p_level[targetid]]										
			#endif
			
			#if WAR3_MYSQL_TOP15 
				skillStat[targetid] += 2
			#endif
			
			playerxp[targetid]+=  temp
										
			#if OBJECTIVE_XP_PRINT				
				get_user_name(targetid,nName,31)	
				//set_hudmessage(0, 160, 97, -1.05, 0.85, 2, 6.0, 15.0, 0.2, 0.3,101);
				//show_hudmessage(targetid,"^n +%d XP for bomb plant support",temp );					
				client_print(targetid,print_chat, "[WC3] %s recieved %d for helping the %s escape.",nName,temp,sName)
			#endif					
		}
		displaylevel(targetid, 1)
	}
      
      
   } 
   return PLUGIN_HANDLED 
}


#if BOMB_WARNINGS
// Bomb counter 
public bomb_count_control( parmB[2]  ) 
{ 
	new sMsg[20]	     
	new sSound[MAX_VAR_LENGTH] 
		
	gBombTimer = parmB[0]		
	
	if (parmB[0] == 40 || parmB[0] == 30 || parmB[0] == 20 || parmB[0] == 10) { 
		
		num_to_word(parmB[0],sSound,MAX_VAR_LENGTH) 
		client_cmd(0,"spk ^"vox/%s seconds until explosion^"",sSound) 
		
		format(sMsg,MAX_TEXT_LENGTH,"%d",parmB[0]) 
		display_msg(sMsg,255,0,0,EVENT_MSG_ALL) 
		
	}else{
		
		num_to_word(parmB[0],sSound,MAX_VAR_LENGTH) 
		client_cmd(0,"spk ^"vox/%s^"",sSound) 
		
		format(sMsg,MAX_TEXT_LENGTH,"%d",parmB[0]) 
		display_msg(sMsg,255,0,0,EVENT_MSG_ALL)
		
	} 
   	
  	return PLUGIN_CONTINUE 
} 
#endif


public display_msg(msg[],r,g,b,team) 
{ 
   set_hudmessage(r,g,b,-1.0,0.6,0,0.0,6.0,0.6,0.6,937) 
   if (team > 0 ) { 
      new iPlayer, iPlayers[MAX_PLAYERS], iNumPlayers 
      get_players(iPlayers,iNumPlayers,"a") 
      for (new i = 0; i < iNumPlayers; i++) { 
         iPlayer = iPlayers[i] 
         if (get_user_team(iPlayer)==team) { 
            show_hudmessage(iPlayer,msg) 
         } 
      } 
   }else { 
      show_hudmessage(0,msg) 
   } 
} 


public got_defuse(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	hasdefuse[id]=true
	return PLUGIN_CONTINUE
}


public handle_gogogo(id)
{
	if (gogogo==true)
	{
		return PLUGIN_CONTINUE
	}
	
	client_cmd(id,"echo Hah, nice try. You can't say Go Go Go during freezetime.")
	set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
	show_hudmessage(id,"You may not use this command during freezetime!")
	return PLUGIN_HANDLED
	
}


#if XPRESET 
public xp_loss_scream1(ids[]){	
	client_cmd(0,"spk scientist/scream04.wav") // Player notices XP loss... initial scream
	return PLUGIN_CONTINUE
}

public xp_loss_scream2(ids[]){	
	client_cmd(ids[0],"say OMG, my XP!!! My XP is gone!") // Makes player scream with real gusto
	client_cmd(0,"spk scientist/scream20.wav")	
	return PLUGIN_CONTINUE
}

public xp_loss_laughter(ids[]){	
	client_cmd(ids[0],"say Noooo! Noooooooooooooooo!") // Player is in denial
	client_cmd(0,"spk hgrunt/c2a3_hg_laugh.wav")
	return PLUGIN_CONTINUE
}

public xp_reset_rise(ids[]){
	new id = ids[0]
	new name[33]
	get_user_name( id, name,31)		
	set_user_maxspeed(id,0.0)
	set_user_gravity(id,-0.0001)
	set_user_health(id, 5000)	
	client_cmd(id,"+jump")

	client_print(id,print_chat, "[GOD] Come on up %s and we'll discuss the XP reset.",name)
	
	return PLUGIN_CONTINUE
}

public xp_reset_heaven(ids[]){
	new id = ids[0]	
	new name[33]
	new keys = (1<<0) | (1<<1)
	
	get_user_name( id, name,31)
	client_print(id,print_chat, "[GOD] I realize I've been harsh on you %s, so I'll grant you your greatest wish.",name)
	client_cmd(id,"-jump;wait;wait;-jump")
		

	
	
	if (is_user_bot(id)){
		playerxp[id] = 0
		return PLUGIN_HANDLED
	}

	new menu_msg[256]	
	format(menu_msg,255,"Your Wish Is:\w^n^n1. Give back level %d ^n2. Roll the dice for level", RESETLEVEL)
	show_menu(id,keys,menu_msg,-1)
	
	return PLUGIN_CONTINUE
}

public xp_choice(id,key){
	
	if (key == 0){
		playerxp[id] = xplevel[RESETLEVEL]					
	}else if (key == 1){
		new temp
		temp = random_num(0,10)
		if( temp < MIN_RESET_LEVEL ){
			client_print(id,print_chat, "[GOD] My poor son, the dice granted you only level %d, let me roll again for you.", temp)
			temp = random_num(MIN_RESET_LEVEL,10)  // Not taking any chances that the player gets screwed
		}
		playerxp[id] = xplevel[temp]
		
	}else{
		playerxp[id] = xplevel[RESETLEVEL]		
	}
	
	resetedPlayerID[id] = 0
	
	// This isn't tight
	select_skill(id, 0)	
	displaylevel(id, 1)
	select_skill(id, 0)
		
		
	new name[33]
	get_user_name( id, name,31)
	
	client_print(id,print_chat, "[GOD] %s, go kick ass now with my holy blessing!",name)
	set_user_gravity(id, 5.0)
	new ids[2]
	ids[0] = id
	godBlessed[id] = GOD_BLESS_ROUNDNUM
	
	new inum
	new players[32]
	get_players(players,inum,"c") 
        for(new i = 0 ;i < inum; ++i) 
            client_cmd(players[i],"speak ^"warning to all, got mode reached at level eleven^"") 

	
	
	// This isn't very tight either... but seems to work
	set_task(2.3, "xp_reset_godmode", 11008, ids, 1, "a", 0)
	set_task(10.0, "xp_reset_select", 11009, ids, 1, "a", 3)
	set_task(11.0, "xp_reset_level", 11010, ids, 1, "a", 3)
	return PLUGIN_CONTINUE
}

public xp_reset_godmode(ids[]){
	
	new godid = ids[0]
	new name[33]
	get_user_name( godid, name,31)

	
	//set_hudmessage(red, green, blue, Float:x=-1.0, Float:y=0.35, effects=0, Float:fxtime=6.0, Float:holdtime=12.0, Float:fadeintime=0.1, Float:fadeouttime=0.2,channel=4);
	set_hudmessage(178, 14, 41, -1.0, 0.65, 1, 6.0, 15.0, 0.2, 0.3,4);
	show_hudmessage(0,"%s Has God Mode",name );
	
	 
	set_task(6.0, "xp_reset_left", 110012, ids, 1, "a", 0)
	
	set_user_armor(godid, 250)
	set_user_gravity(godid, 1.0)	
	set_user_health(godid, 5370)  // Give back any health lost in the fall
	set_user_maxspeed(godid,300.0)
	resetedPlayerID[godid] = 0 // Redundant just to be sure
		
	return PLUGIN_CONTINUE
}

public xp_reset_left(ids[]){
	new id
	id = ids[0]
	
	new inum
	new players[32]
	get_players(players,inum,"c") 
	
        
	if( godBlessed[id] == 5 ){
		for(new i = 0 ;i < inum; ++i) 
            		client_cmd(players[i],"speak ^"four round remaining of got mode, quick run for your life^"") 
	}else if( godBlessed[id] == 4 ){
		for(new i = 0 ;i < inum; ++i) 
            		client_cmd(players[i],"speak ^"three round remaining of got mode, quick run for your life^"") 
		
	}else if( godBlessed[id] == 3 ){
		for(new i = 0 ;i < inum; ++i) 
            		client_cmd(players[i],"speak ^"two round remaining of got mode, quick run for your life^"") 
		
	}else if( godBlessed[id] == 2 ){
		for(new i = 0 ;i < inum; ++i) 
            		client_cmd(players[i],"speak ^"one round remaining of got mode, quick run for your life^"") 
		
	}else if(godBlessed[id] == 1 ){
		for(new i = 0 ;i < inum; ++i) 
            		client_cmd(players[i],"speak ^"did you no this is the last round of got mode^"") 	
	}
	return PLUGIN_CONTINUE
}


public xp_reset_level(ids[]){
	new id = ids[0]
	say_level(id)
	return PLUGIN_CONTINUE
}

public xp_reset_select(ids[]){
	new id = ids[0]
	select_skill(id, 0)
	return PLUGIN_CONTINUE
}

#endif



public displaylevel(id,hide){
	#if XPRESET
		if( resetedPlayerID[id] > 0 ){ 			
			return PLUGIN_CONTINUE
		}		
	#endif
	
	if (id==0 || !(p_skills[id][0]>0) || !(p_skills[id][0]<5))
		return PLUGIN_CONTINUE

	new oldlevel = p_level[id]

	if (playerxp[id]<0)
		playerxp[id]=0

	for (new i=0; i<=10; ++i){
		if (playerxp[id]>=xplevel[i])
			p_level[id]=i
		else
			break
	}
	
	#if XPRESET       // Reset XP @ Level 11		
		new resetplayername[32]
		new ids[2] 	
		get_user_name(id,resetplayername,31)
		ids[0] = id		
			
		if( playerxp[id]>=xplevel[11] ){
			if (file_exists("sound/warcraft3/Levelupcaster.wav")==1)
				emit_sound(id,CHAN_STATIC, "warcraft3/Levelupcaster.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			else
				emit_sound(id,CHAN_STATIC, "plats/elevbell1.wav", 1.0, ATTN_NORM, 0, PITCH_LOW)
						
			resetedPlayerID[id] += 1		
			p_level[id] = 0
			p_skills[id][1] = 0
			p_skills[id][2] = 0
			p_skills[id][3] = 0
			p_skills[id][4] = 0
			client_print(0,print_chat, "[WC3] %s level 11 %s is too strong for us and has been exiled.",resetplayername,shortracename[p_skills[id][0]])	
			set_task(2.3, "xp_loss_scream1", 11001, ids, 1, "a", 0)		
			set_task(4.9, "xp_loss_scream2", 11002, ids, 1, "a", 0)
			set_task(7.9, "xp_loss_laughter", 11003, ids, 1, "a", 0)			
		}
	#endif
	

	new xpstring[256]
	// XP is displayed as "Reseted" for the reseted player. This hides the fact that XP hasn't even been touched. Yet.
	

	#if XPRESET
       		if (p_level[id]==0 && resetedPlayerID[id])
               		format(xpstring,255,"%s   XP: Reseted  %s",racename[p_skills[id][0]], playeritem[id]?itemname[playeritem[id]-1]:"")
              	else if (p_level[id]==0 )
               		format(xpstring,255,"%s   XP: %d/%d  %s",racename[p_skills[id][0]],playerxp[id],xplevel[p_level[id]+1], playeritem[id]?itemname[playeritem[id]-1]:"")
          
              	else if (p_level[id]<11)
        #else
	        if (p_level[id]==0)
	        	format(xpstring,255,"%s   XP: %d/%d  %s",racename[p_skills[id][0]],playerxp[id],xplevel[p_level[id]+1], playeritem[id]?itemname[playeritem[id]-1]:"")
	        else if (p_level[id]<10)
        #endif
                	format(xpstring,255,"%s Level %d   XP: %d/%d  %s",shortracename[p_skills[id][0]],p_level[id],playerxp[id],xplevel[p_level[id]+1], playeritem[id]?itemname[playeritem[id]-1]:"")
        	else	
	       		format(xpstring,255,"%s Level %d   XP: %d  %s",shortracename[p_skills[id][0]],p_level[id],playerxp[id], playeritem[id]?itemname[playeritem[id]-1]:"")
	

	message_begin( MSG_ONE, gmsgStatusText, {0,0,0}, id)
	write_byte(0)
	write_string(xpstring)
	message_end()

	
	if (p_level[id] > oldlevel && is_user_alive(id)){			// Level Gained
		set_hudmessage(200, 100, 0, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
		show_hudmessage(id,"You gained a Level")
		if (file_exists("sound/warcraft3/Levelupcaster.wav")==1)
			emit_sound(id,CHAN_STATIC, "warcraft3/Levelupcaster.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		else
			emit_sound(id,CHAN_STATIC, "plats/elevbell1.wav", 1.0, ATTN_NORM, 0, PITCH_LOW)
	}

	
	// This code checks if your level dropped (ex: you lost XP), and removes the appropriate skill
	// I found that in certain situation it could fail, so if you lose a level, you now have to 
	// rechoose all your skills. It's far safer this way. It will recover even if you claim to 
	// have 1000 levels of the ultimate skill.
	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	while (skillsused>p_level[id]){
		
		set_hudmessage(200, 100, 0, -1.0, 0.25, 0, 1.0, 14.0, 0.1, 0.2, 2)
		show_hudmessage(id,"You lost a Level")
		
		p_skills[id][1]=0
		p_skills[id][2]=0
		p_skills[id][3]=0
		p_skills[id][4]=0
		skillsused = 0
	}
		

	if (hide!=1 && p_skills[id][0]!=0){
		new temp[128]
		new message[256]

		format(message,255,"%s",racename[p_skills[id][0]])
		if (p_level[id]){
			format(temp,127,"^nLevel %d",p_level[id])
			add(message,255,temp)
		}

		new skillcounter = 0
		new skillcurrentrace[4][64]

		while (skillcounter < 4){
			if (p_skills[id][0] == 1){
				copy(skillcurrentrace[skillcounter],63,race1skill[skillcounter])
			}
			else if (p_skills[id][0] == 2){
				copy(skillcurrentrace[skillcounter],63,race2skill[skillcounter])
			}
			else if (p_skills[id][0] == 3){
				copy(skillcurrentrace[skillcounter],63,race3skill[skillcounter])
			}
			else if (p_skills[id][0] == 4){
				copy(skillcurrentrace[skillcounter],63,race4skill[skillcounter])
			}
			++skillcounter
		}

		if (p_skills[id][1]){
			format(temp,127,"^n%s Level %d",skillcurrentrace[0],p_skills[id][1])
			add(message,255,temp)
		}
		if (p_skills[id][2]){
			format(temp,127,"^n%s Level %d",skillcurrentrace[1],p_skills[id][2])
			add(message,255,temp)
		}
		if (p_skills[id][3]){
			format(temp,127,"^n%s Level %d",skillcurrentrace[2],p_skills[id][3])
			add(message,255,temp)
		}
		if (p_skills[id][4]){
			format(temp,127,"^nUltimate: %s",skillcurrentrace[3])
			add(message,255,temp)
		}

		set_hudmessage(255, 255, 255, -1.0, 0.3, 0, 3.0, 5.0, 0.1, 0.2, 2)
		show_hudmessage(id,message)
	}

	if (p_skills[id][0] == 1 && p_skills[id][3]>0 && p_skills[id][3]<4){		// Levitation
		if (get_user_gravity(id)!=p_levitation[p_skills[id][3]-1])
			set_user_gravity(id,p_levitation[p_skills[id][3]-1])
	}
	else if (get_user_gravity(id)!=1.0)
		set_user_gravity(id,1.0)


	if (p_skills[id][0] == 2 && p_skills[id][1] && playeritem[id]==CLOAK){		// Invisibility	& Cloack of Shadows
		new highestinvis=(p_invisibility[p_skills[id][1]-1]>CLOAKINVISIBILITY)?p_invisibility[p_skills[id][1]-1]:CLOAKINVISIBILITY
		if (knifeselected[id]){
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,highestinvis-p_invisibility[2]+KNIFEINVISIBILITY)
		}
		else
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,highestinvis)
	}
	else if (p_skills[id][0] == 2 && p_skills[id][1]){		// Invisibility
		if (knifeselected[id]){
			new invisibility = p_invisibility[p_skills[id][1]-1]-p_invisibility[2]+KNIFEINVISIBILITY
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,invisibility)
		}
		else
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,p_invisibility[p_skills[id][1]-1])
	}
	else if (playeritem[id]==CLOAK){			// Cloack of Shadows
		if (knifeselected[id]){
			new invisibility = CLOAKINVISIBILITY-p_invisibility[2]+KNIFEINVISIBILITY
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,invisibility)
		}
		else
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,CLOAKINVISIBILITY)
	}
	else
		set_user_rendering(id)


	if (p_skills[id][0] != 4 || !p_skills[id][1]){	// Evasion
		if (get_user_health(id)>=500)
			set_user_health(id,get_user_health(id)-ELF_EVADE_ADJ)
	}
	

	new parm[1]
	parm[0]=id
	unholyspeed(parm)

	return PLUGIN_CONTINUE
}

public death(){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new killer_id = read_data(1)
	new victim_id = read_data(2)
	new headshot = read_data(3)
	new weaponname[20]
	read_data(4,weaponname,31)
	new weapon
	get_user_attacker(victim_id,weapon)

	#if ULTIMATE_READY_ICON
		icon_controller(victim_id, 0, 0,0, 0 ) 		
	#endif

	#if WAR3STATS
		new statsParm[2]
		statsParm[0] = victim_id
		statsParm[1] = 10
		set_task(2.0,"display_stats",10129,statsParm,2)				
	#endif	
	
	#if WAR3_MYSQL_TOP15 
		skillStat[victim_id]--
	#endif

	if (!(killer_id==victim_id && !headshot && equal(weaponname,"world"))){
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(killer_id)
		write_byte(victim_id)
		write_byte(headshot)
		write_string(weaponname)
		message_end()
	}

	if (p_skills[victim_id][0]==1 && p_skills[victim_id][4] && !changingteam[victim_id] && !ultimateused[victim_id] ){	// Suicide Bomber
		emit_sound(victim_id,CHAN_STATIC, "ambience/particle_suck1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		new parm[2]
		parm[0]=victim_id
		parm[1]=6
		set_task(0.5,"apacheexplode",1,parm,2)
		set_task(0.5,"blastcircles",2,parm,2)

		new origin[3]
		get_user_origin(victim_id,origin)
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
		write_byte( TE_IMPLOSION )
		write_coord(origin[0])
		write_coord(origin[1])
		write_coord(origin[2])
		write_byte(100)
		write_byte(20)
		write_byte(5)
		message_end()
	}

	changingteam[victim_id]=false


	diedlastround[victim_id]=true
	armorondeath[victim_id]=get_user_armor(victim_id)

	for (new i=0; i<32; ++i){		// Equipment Reincarnation
		savedweapons[victim_id][i]=0
	}

	savednumber[victim_id]=0
	get_user_weapons(victim_id,savedweapons[victim_id],savednumber[victim_id])

	if (killer_id && killer_id!=victim_id && victim_id){
		if (get_user_team(killer_id)==get_user_team(victim_id)){
			playerxp[killer_id]-=xpgiven[p_level[killer_id]]
			#if WAR3STATS
				xpStat[killer_id][victim_id] -= xpgiven[p_level[killer_id]]
			#endif	
			#if WAR3_MYSQL_TOP15 
				skillStat[killer_id]--
			#endif
		}
		else{
			if (!get_cvar_num("mp_weaponxpmodifier")){
				playerxp[killer_id]+=xpgiven[p_level[victim_id]]
				#if WAR3STATS
					xpStat[killer_id][victim_id] += xpgiven[p_level[victim_id]]
				#endif
				#if WAR3_MYSQL_TOP15 
					skillStat[killer_id]++
				#endif
				if( headshot ){
					playerxp[killer_id]+= HEADSHOT_BONUS
					#if WAR3STATS
						xpStat[killer_id][victim_id] +=HEADSHOT_BONUS
					#endif
				}		
			}else{
				playerxp[killer_id]+=floatround(xpgiven[p_level[victim_id]]*weaponxpmultiplier[weapon])
				#if WAR3STATS
					xpStat[killer_id][victim_id] += floatround(xpgiven[p_level[victim_id]]*weaponxpmultiplier[weapon])
				#endif
				#if WAR3_MYSQL_TOP15 
					skillStat[killer_id]++
				#endif
				if( headshot ){
					playerxp[killer_id]+= HEADSHOT_BONUS
					#if WAR3STATS
						xpStat[killer_id][victim_id] +=HEADSHOT_BONUS
					#endif
				}
			}
				
			if (gHostageSaverIndex[victim_id]){						
					new temp
					#if XPLOIT_PROTECT						
						if( antiExploit ){
							temp = KILLRESCUEMANXP +  2 * xpgiven[p_level[victim_id]]
						}																
					#else
						temp = KILLRESCUEMANXP +  2 * xpgiven[p_level[victim_id]]											
					#endif
					
					playerxp[killer_id]+=  temp
					#if WAR3STATS
						xpStat[killer_id][victim_id] +=temp
					#endif
					#if WAR3_MYSQL_TOP15 
						skillStat[killer_id]++
					#endif
							
					#if OBJECTIVE_XP_PRINT
						new killersname[33]
						get_user_name(killer_id,killersname,31)						
						client_print(killer_id,print_chat, "[WC3] %s recieved %d XP for killing the hostage rescuer.",killersname,temp)
					#endif	
			}
			#if DEFUSER_KILL_BONUS
				if (victim_id==bombdefuser){						
					new temp
					#if XPLOIT_PROTECT						
						if( antiExploit ){
							temp = DEFUSER_KILL_BONUS +  xpgiven[p_level[victim_id]]
						}																
					#else
						temp = DEFUSER_KILL_BONUS +  xpgiven[p_level[victim_id]]											
					#endif
					
					playerxp[killer_id]+=  temp
					#if WAR3STATS
						xpStat[killer_id][victim_id] +=temp	
					#endif
					#if WAR3_MYSQL_TOP15 
						skillStat[killer_id]++
					#endif
							
					#if OBJECTIVE_XP_PRINT
						new killersname[33]
						get_user_name(killer_id,killersname,31)						
						client_print(killer_id,print_chat, "[WC3] %s recieved %d XP for killing the bomb defuser.",killersname,temp)
					#endif	
				}
			#endif	
			#if KILL_BOMB_CARRIER				 
				 if (victim_id==bombCarrier){						
					new temp
					#if XPLOIT_PROTECT						
						if( antiExploit ){
							temp = KILL_BOMB_CARRIER +  xpgiven[p_level[victim_id]]
						}																
					#else
						temp = KILL_BOMB_CARRIER +  xpgiven[p_level[victim_id]]											
					#endif
					
					playerxp[killer_id]+=  temp
					#if WAR3STATS
						xpStat[killer_id][victim_id] += temp
					#endif
					#if WAR3_MYSQL_TOP15 
						skillStat[killer_id]++
					#endif
							
					#if OBJECTIVE_XP_PRINT
						new killersname[33]
						get_user_name(killer_id,killersname,31)						
						client_print(killer_id,print_chat, "[WC3] %s recieved %d XP for killing the bomb carrier.",killersname,temp)
					#endif	
				}
			#endif
					
		}
		displaylevel(killer_id, 1)
	}

	new parameter[1]
	parameter[0]=victim_id
	set_task(1.0,"getuserinput",3,parameter,1)

	return PLUGIN_CONTINUE
}

public getuserinput(parm[1]){
	new id = parm[0]
	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	if (p_skills[id][0] == 0){
		if (!saved_xp)
			select_race(id)
	
	}else if (skillsused < p_level[id]){
		select_skill(id,0)
	
	}else{	
		displaylevel(id, 0)
		
	}

	return PLUGIN_HANDLED
}

public restart_round(){
	if (warcraft3==false || saved_xp)
		return PLUGIN_CONTINUE

	new players[32]
	new numplayers
	new id
	get_players(players, numplayers)

	for (new i=0; i<numplayers; i++){
		id = players[i]
		p_skills[id][1] = 0
		p_skills[id][2] = 0
		p_skills[id][3] = 0
		p_skills[id][4] = 0
		p_level[id] = 0
		playerxp[id] = 0
		playeritem[id] = 0
	}
	
	return PLUGIN_CONTINUE
}

#if SPAWN_PROTECT
	public spawn_protect(parmS[2]){ 
				
		
		if( parmS[1] ){
			
			set_user_rendering(parmS[0],kRenderFxGlowShell,101,78,153, kRenderNormal, 16)
		
			parmS[1] = 0
			set_task(2.0,"glow_change",102215,parmS,2)			
				
			set_user_godmode(parmS[0])
			message_begin(MSG_ONE,gmsgFade,{0,0,0},parmS[0])
			write_short( 1<<10 ) // fade lasts this long duration
			write_short( 1<<10 ) // fade lasts this long hold time
			write_short( 1<<12 ) // fade type (in / out)
			write_byte( 101 ) // fade red
			write_byte( 78 ) // fade green
			write_byte( 153 ) // fade blue
			write_byte( MAXGLOW ) // fade alpha
			message_end()
		}else{
			set_user_rendering(parmS[0])
		}
		
		return PLUGIN_CONTINUE
	}
#endif

public new_round(id){ 
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	
	new parm[2]
	parm[0]=id		
	stunned[id]=false
	slowed[id]=false
	hasgrenade[id]=false
	changingrace[id]=false	
	gogogo=false
	
	#if !MULTI_WEP_FIX		
		new weaponid, weaponname[20], ammoname[20], reincarnate = 0	
	#endif
	
	#if !BLINK_HUMAN_ULTIMATE
		endround=false
	#endif
	
	
	#if SPAWN_PROTECT
		set_user_godmode(id,1)
		new parmS[2]
		parmS[0] = id
		parmS[1] = 1
		set_task(SPAWN_PROTECT,"spawn_protect",1,parmS,2)
	#endif		
	
	
	#if ULTIMATE_WARMUP		
		remove_task(50+id) 	// Stop any cooldowns in effect		
		ultimateused[id]=true
		new cooldownparm[1]	
		cooldownparm[0]=id										
		set_task(ULTIMATE_WARMUP,"cooldown",50+id,cooldownparm,1)
		
		#if ULTIMATE_READY_ICON
			icon_controller(id, 0, 0,0, 0 ) 				
		#endif		
	#else
		ultimateused[id]=false
		#if ULTIMATE_READY_SOUND			
			emit_sound(id,CHAN_ITEM, "fvox/power_restored.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		#endif
		#if ULTIMATE_READY_ICON
			if( p_skills[id][0] == 1 ){
				icon_controller(id, 2, 150,0, 0 ) 
			}else if( p_skills[id][0] == 2 ){
				icon_controller(id, 1, 0, 0, 255 ) 
			}else if( p_skills[id][0] == 3 ){
				icon_controller(id, 1, 255, 255, 0 ) 
			}else{
				icon_controller(id, 1, 0, 255, 0 ) 
			}
		#endif			
	#endif
	
	#if KILL_BOMB_CARRIER
		bombCarrier = 0
	#endif
	
	#if FORGIVE_HOSTKILL_ROUND
		KilledHostageIndex[id] = 0
	#endif
	
	gHostageSaverIndex[id] = 0
        #if ATTEMPT_DEFUSE_BONUS
        	bombDefuserIndex[id] = 0
        #endif
        #if WARN_SUICIDERS
		suicideAttempt[id] = 0
	#endif	
		
	
	#if STEAM_POWERED
		set_user_maxspeed(id,1.0)
	#endif
	
	
	#if ORCNADE_CVAR
		if( get_cvar_num("mp_alloworcnade") == 0 ){
			set_hudmessage(178, 14, 41, -1.0, 0.90, 2, 6.0, 15.0, 0.2, 0.3,4);
			show_hudmessage(id,"Orc Grenades Off^nNormal Damage Only" );	
			//client_print(id,print_chat, "[WC3] WARNING: Orc grenades are disabled on this map.")
		}
	#endif
	
	#if XPRESET        
	
                if (resetedPlayerID[id] ){                	
                	resetedPlayerID[id] = 0
                	new ids[2]
                	ids[0] = id
           
                	set_task(1.0,"xp_reset_rise",11004,ids,1,"a", 0)       
                	set_task(8.0,"xp_reset_heaven",11005,ids,1,"a", 0)  
                	return PLUGIN_CONTINUE                  	
                }else if( godBlessed[id] > 1 ){
                	godBlessed[id] -= 1
                	new ids[2]
                	ids[0] = id
                	xp_reset_godmode(ids[0])	                	
                }else if( godBlessed[id] == 1 ){
                	godBlessed[id] = 0
                	new name[33]
			get_user_name( id, name,31)
                	set_hudmessage(178, 14, 41, -1.0, 0.65, 1, 6.0, 15.0, 0.2, 0.3,4);
			show_hudmessage(id,"God Mode Disabled");
			client_print(id,print_chat, "[GOD] %s, rape is a sin my son, I'm afraid your on your own now.",name)	
        	}
        #endif
		
	if (p_skills[id][0] == 0){
		select_race(id)
	}
	
	#if XPLOIT_PROTECT
		new number_of_noobs 		
		new nubs[32]
		
		get_players(nubs, number_of_noobs) 	
		antiExploit = true	
		if( number_of_noobs < XPLOIT_PROTECT ){
			antiExploit = false
		}
		
	#endif
	
	#if MULTI_WEP_FIX					
		set_task(0.1, "weapon_controller", 10091, parm, 2)	
		if (diedlastround[id]){
			playerItemOld[id] = playeritem[id]
			playeritem[id]=0
		}			
	#else	
		
		if (diedlastround[id]){			// Equipment Reincarnation
			new Float:randomnumber = random_float(0.0,1.0)
			if (p_skills[id][0] == 3 && p_skills[id][3] && randomnumber <= p_ankh[p_skills[id][3]-1])
				reincarnate=1
			if (playeritem[id]==ANKH)
				reincarnate=1			
			if (reincarnate){
	                        new gaveweapon = 0
				if (armorondeath[id]){
					if (helmet[id])
						give_item(id,"item_assaultsuit")
					else
						give_item(id,"item_kevlar")
					set_user_armor(id,armorondeath[id])
				}
				if (hasdefuse[id])
					give_item(id,"item_thighpack")
	
				for (new j=0; j < savednumber[id] && j < 32 && gaveweapon==0; ++j){
					weaponid=savedweapons[id][j]
					if (weaponid==3){
						weaponname="weapon_scout"
						ammoname="ammo_762nato"
					}
					else if (weaponid==4){
					#if STEAM_POWERED
						give_item(id,"weapon_hegrenade")
					#else
						weaponname=""
						ammoname=""
						parm[1]=4
						set_task(1.0,"buy_weapons",96,parm,2)
						set_user_money(id,get_user_money(id)+300,0)
					#endif
					}
					else if (weaponid==5){
						weaponname="weapon_xm1014"
						ammoname="ammo_buckshot"
					}
					else if (weaponid==7){
						weaponname="weapon_mac10"
						ammoname="ammo_45acp"
					}
					else if (weaponid==8){
						weaponname="weapon_aug"
						ammoname="ammo_556nato"
					}
					else if (weaponid==9){
					#if STEAM_POWERED
						give_item(id,"weapon_smokegrenade")	
					#else
						weaponname=""
						ammoname=""
						parm[1]=5
						set_task(1.0,"buy_weapons",96,parm,2)
						set_user_money(id,get_user_money(id)+300,0)
					#endif
					}
					else if (weaponid==12){
						weaponname="weapon_ump45"
						ammoname="ammo_45acp"
					}
					else if (weaponid==13){
						weaponname="weapon_sg550"
						ammoname="ammo_556nato"
					}
					#if STEAM_POWERED
					else if (weaponid==14){
						weaponname="weapon_galil"
						ammoname="ammo_556nato"
					}
					else if (weaponid==15){
						weaponname="weapon_famas"
						ammoname="ammo_556nato"
					}
					#endif
					else if (weaponid==18){
						weaponname="weapon_awp"
						ammoname="ammo_338magnum"
					}
					else if (weaponid==19){
						weaponname="weapon_mp5navy"
						ammoname="ammo_9mm"
					}
					else if (weaponid==20){
						weaponname="weapon_m249"
						ammoname="ammo_556natobox"
					}
					else if (weaponid==21){
						weaponname="weapon_m3"
						ammoname="ammo_buckshot"
					}
					else if (weaponid==22){
						weaponname="weapon_m4a1"
						ammoname="ammo_556nato"
					}
					else if (weaponid==23){
						weaponname="weapon_tmp"
						ammoname="ammo_9mm"
					}
					else if (weaponid==24){
						weaponname="weapon_g3sg1"
						ammoname="ammo_762nato"
					}
					else if (weaponid==25){
					#if STEAM_POWERED
						give_item(id,"weapon_flashbang")	
					#else
						weaponname=""
						ammoname=""
						parm[1]=3
						set_task(1.0,"buy_weapons",96,parm,2)
						set_user_money(id,get_user_money(id)+200,0)
					#endif
					}
					else if (weaponid==27){
						weaponname="weapon_sg552"
						ammoname="ammo_556nato"
					}
					else if (weaponid==28){
						weaponname="weapon_ak47"
						ammoname="ammo_762nato"
					}
					else if (weaponid==30){
						weaponname="weapon_p90"
						ammoname="ammo_57mm"
					}
					else{
						weaponname=""
						ammoname=""
					}
					if (contain(weaponname,"weapon_")==0){	// -1 if no match found, 0 if match
						give_item(id,weaponname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						gaveweapon=1
					}
				}
	
				if (iglow[id][1] < 1){
					parm[0] = id
					set_task(0.1,"glow_change",4,parm,2)
				} 
				iglow[id][1] += 100
				iglow[id][0] = 0
				iglow[id][2] = 0
				iglow[id][3] = 0
				if (iglow[id][1]>MAXGLOW)
					iglow[id][1]=MAXGLOW
				message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
				write_short( 1<<10 ) // fade lasts this long duration
				write_short( 1<<10 ) // fade lasts this long hold time
				write_short( 1<<12 ) // fade type (in / out)
				write_byte( 0 ) // fade red
				write_byte( 255 ) // fade green
				write_byte( 0 ) // fade blue
				write_byte( iglow[id][1] ) // fade alpha
				message_end()
			}
			else{
				hasdefuse[id]=false
			}
		}
		
		if (diedlastround[id])		
			playeritem[id]=0

		diedlastround[id]=false
		
	#endif
		
	
	if (p_skills[id][0] == 4 && p_skills[id][1] ){		// Evasion
		
		// Allows Night Elves a chance to evade the first bullet to hit them.		
		new Float:randomnumber = random_float(0.0,1.0)
		if ( randomnumber <= p_evasion[p_skills[id][1]-1]){
			p_evadenextshot[id]=true		
		}else{
			p_evadenextshot[id]=false		
		}
		
		
		if(  p_evadenextshot[id] ){
				set_user_health(id,1124)
		}
		
		
	}
	else if (p_skills[id][0] == 2 && p_skills[id][2]){		// Devotion Aura
		set_user_health(id,p_devotion[p_skills[id][2]-1])
	}
	if (playeritem[id]==HEALTH)
		set_user_health(id,get_user_health(id)+HEALTHBONUS)
	#if OPT_RESETSKILLS
        	if (resetskill[id]) {
                	p_skills[id][1]=0
	                p_skills[id][2]=0
        	        p_skills[id][3]=0
	                p_skills[id][4]=0
	                p_level[id] = 0
        	        resetskill[id]=false
	                displaylevel(id, 1)
		}
	#endif

	
	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	if (skillsused < p_level[id]){
		select_skill(id,0)
	}
	else {
		displaylevel(id, 1)
	}
	return PLUGIN_CONTINUE
}

public buy_weapons(parm[]){
	new id=parm[0]
	new menunum=parm[1]
	new string[2]
	num_to_str(menunum,string,1)

	engclient_cmd(id,"buyequip")
	engclient_cmd(id,"menuselect",string)
	client_cmd(id,"slot10")

	return PLUGIN_CONTINUE
}




#if WAR3STATS
public display_stats(statsParm[2]){
	new id = statsParm[0]
	new Float:showTime = float( statsParm[1] )
	
	if ( (warcraft3==false) && id) // If ID is 0 somehow, just bomb out of here quick.
		return PLUGIN_CONTINUE
		
	//show_motd(id,"addons/amx/stats.html","Denk Stats - WC3 Style")	
	//return PLUGIN_CONTINUE
	
	new players[32]
	new numberofplayers	
	new string[256] 
	new vicString[1024]
	new vicLen = 9
	new attString[1024]
	new attLen = 11
	new stringLen	
	new damage 
	new attacker[31],victim[31]
	new i
	new bool:hadVictim = false
	new bool:hadAttacker = false
	
	get_players(players, numberofplayers)
		
	copy(vicString,vicLen,"Victims:^n");		
	copy(attString,attLen,"Attackers:^n");
						
	for( i = 0; i < numberofplayers; i++ ){	
							
		damage = dmgStat[id][players[i]]
		if( damage != 0){ // if damage occured
			hadVictim = true
			get_user_name(players[i], victim,32)
			
			if( xpStat[id][players[i]] >= 0 ){
				stringLen = format(string,127,"%s    %dHP    %dHits    %dXP^n",victim,damage,hitStat[id][players[i]], xpStat[id][players[i]]) 
			}else{
				stringLen = format(string,127,"%s    %dHP    %dHits   -%dXP^n",victim,damage,hitStat[id][players[i]], xpStat[id][players[i]]) 
			}
			vicLen = format(vicString,vicLen+stringLen+1,"%s%s",vicString,string);
										
		}
		damage = dmgStat[players[i]][id]
		if( damage != 0){ // if damage occured
			hadAttacker = true
			get_user_name(players[i], attacker,32)					
			
			stringLen = format(string,127,"%s    %d HP    %d Hits^n",attacker,damage,hitStat[players[i]][id]) 
			attLen = format(attString,attLen+stringLen+1,"%s%s",attString,string);					
		}			
				
	}
	
	// Stats Display Block --- Victims
	if( hadVictim ){		
		//set_hudmessage(red, green, blue,x=-1.0,y=0.35,fx,fxtime=6.0, holdtime=12.0, fadeintime=0.1, fadeouttime=0.2,channel=4);
		set_hudmessage(0,255,0,0.65,0.25,0,0.0,showTime,0.9,2.15,83) 
	      	show_hudmessage(id,vicString) 
	}else{
		stringLen = format(string,127,"^nNone") 
		format(vicString,vicLen+stringLen,"%s%s",vicString,string);
		set_hudmessage(0,255,0,0.65,0.25,0,0.0,showTime,0.9,2.15,83) 
	      	show_hudmessage(id,vicString) 
	}
	
	// Stats Display Block --- Attackers
	if( hadAttacker ){		
		set_hudmessage(255,255,0,0.65,0.55,0,0.0,showTime,0.9,2.15,84) 
      		show_hudmessage(id,attString) 
	}else{
		stringLen = format(string,127,"^nNone") 
		format(attString,attLen+stringLen,"%s%s",attString,string);
		set_hudmessage(255,255,0,0.65,0.55,0,0.0,showTime,0.9,2.15,84) 
      		show_hudmessage(id,attString) 
	}
	
	#if WAR3_MYSQL_TOP15
		// Skill and Rank Display mini-Block
		format(string,127,"Your Skill: %d^nYour Rank: %d",skillStat[id],rank[id] )
		set_hudmessage(0,255,0,-0.8,0.25,0,0.0,showTime,0.9,2.15,82) 
	      	show_hudmessage(id,string) 
	      	
	      	// Top 15 Block
	      	attLen = 8
	      	copy(attString,attLen,"Top 15:^n");
	      	for( i = 0; i < 15; i++ ){
	      		stringLen = format(string,127,"%d. %s^n",i+1,top15[i]) 
			attLen = format(attString,attLen+stringLen+1,"%s%s",attString,string);
	      	}
		//set_hudmessage(255,255,0,-0.70,0.4,0,0.0,showTime,0.9,2.15,81) 
	      	//show_hudmessage(id,attString) 
	      	show_motd(id,attString,"Denk Stats - WC3 Style")
	#endif      	
      		
	return PLUGIN_HANDLED		
}

public reset_stats(){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
		
	new players[32]
	new numberofplayers
	get_players(players, numberofplayers)
	for(new i = 0; i < numberofplayers; i++ ){	
		for( new j = 0; j < numberofplayers; j++ ){	
			dmgStat[players[i]][players[j]] = 0
			hitStat[players[i]][players[j]] = 0
			xpStat[players[i]][players[j]] = 0				
		}
	}
	return PLUGIN_CONTINUE		
}

#endif	




public end_round(){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new players[32]
	new numberofplayers
	get_players(players, numberofplayers)	
	new i
	new parameter[1]
	new id	
	
	#if BOMB_WARNINGS && !AMX_VERSION_093
			
		for(i = 0 ; i < 11; i++ ){
			if( task_exists( 99180 ) ){
				remove_task( 99180 )					
			}	
		}			
	#endif
	
	
	for (i = 0; i < numberofplayers; ++i){
		id = players[i]               
		parameter[0]=id	
		set_task(1.0,"getuserinput",5,parameter,1)		
	}
	#if !BLINK_HUMAN_ULTIMATE
		endround=true
	#endif
	if (saved_xp)
	{
		#if MYSQL_ENABLED
			write_all()
		#else
			update_file(0)	//modded for different update_file method.
		#endif
	}
		
	#if SLAY_LOSERS
		new parm[32] 
		new len = read_data(2,parm,31) 
		set_task(1.0,"slay_those_losers",0,parm, len + 1) 
	#endif

	return PLUGIN_CONTINUE
}

#if SLAY_LOSERS
public end_round_draw(){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new players[32]
	new numberofplayers
	get_players(players, numberofplayers)	
	new i
	new parameter[1]
	new id
	
	
	#if BOMB_WARNINGS && !AMX_VERSION_093			
		for(i = 0 ; i < 11; i++ ){
			if( task_exists( 99180 ) ){
				remove_task( 99180 )					
			}	
		}			
	#endif
	
	for (i = 0; i < numberofplayers; ++i){
		id = players[i]              
		parameter[0]=id
		set_task(1.0,"getuserinput",5,parameter,1)				
	}
	#if !BLINK_HUMAN_ULTIMATE
		endround=true
	#endif
	if (saved_xp)
	{
		#if MYSQL_ENABLED
			write_all()
		#else
			update_file(0)	//modded for different update_file method.
		#endif
	}
		

	return PLUGIN_CONTINUE
}


// Slays each player who failed to stop the other team from completing the objective.
// A random slay method is chosen for each player.
public slay_those_losers(parm[]) { 
	new origin[3], srco[3]
	new player[32], playersnum 
	new id
			
	get_players(player,playersnum,"ea",(parm[7] == 't') ? "CT" : "TERRORIST" ) 
	
	for(new i = 0; i < playersnum; ++i){	
		id = player[i]	
		get_user_origin(id,origin)			
		origin[2] -= 26
		srco[0]=origin[0]+150
		srco[1]=origin[1]+150
		srco[2]=origin[2]+800
		switch(random_num(1,3)){	
			case 1:{
				slay_lightning(srco,origin)
				emit_sound(id,CHAN_ITEM, "ambience/thunder_clap.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			}
			case 2:{
				slay_blood(origin)
				emit_sound(id,CHAN_ITEM, "weapons/headshot2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			}
			case 3:	{
				slay_explode(origin)
				emit_sound(id,CHAN_ITEM, "weapons/explode3.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			}
		}
		set_hudmessage(178, 14, 41, -1.0, -0.4, 1, 0.5, 1.7, 0.2, 0.2,5);
		show_hudmessage(id,"Failure Is Not An Option^nYou Die Now");
		user_kill(id,1)	
		playerxp[id] += xpgiven[p_level[id]]
	}	
} 
	

slay_explode(vec1[3]) { 
	// blast circles 
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY,vec1) 
	write_byte( 21 ) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2] + 16) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2] + 1936) 
	write_short( white ) 
	write_byte( 0 ) // startframe 
	write_byte( 0 ) // framerate 
	write_byte( 2 ) // life 
	write_byte( 16 ) // width 
	write_byte( 0 ) // noise 
	write_byte( 188 ) // r 
	write_byte( 220 ) // g 
	write_byte( 255 ) // b 
	write_byte( 255 ) //brightness 
	write_byte( 0 ) // speed 
	message_end()
	//Explosion2 
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY) 
	write_byte( 12 ) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2]) 
	write_byte( 188 ) // byte (scale in 0.1's) 
	write_byte( 10 ) // byte (framerate) 
	message_end()
	//Smoke 
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY,vec1) 
	write_byte( 5 ) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2]) 
	write_short( g_sModelIndexSmoke ) 
	write_byte( 2 )  
	write_byte( 10 )  
	message_end()
} 

slay_blood(vec1[3]) { 
	//LAVASPLASH 
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY) 
	write_byte( 10 ) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2]) 
	message_end() 
} 

slay_lightning(vec1[3],vec2[3]) { 
	//Lightning 
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY) 
	write_byte( 0 ) 
	write_coord(vec1[0]) 
	write_coord(vec1[1]) 
	write_coord(vec1[2]) 
	write_coord(vec2[0]) 
	write_coord(vec2[1]) 
	write_coord(vec2[2]) 
	write_short( lightning ) 
	write_byte( 1 ) // framestart 
	write_byte( 5 ) // framerate 
	write_byte( 2 ) // life 
	write_byte( 20 ) // width 
	write_byte( 30 ) // noise 
	write_byte( 200 ) // r, g, b 
	write_byte( 200 ) // r, g, b 
	write_byte( 200 ) // r, g, b 
	write_byte( 200 ) // brightness 
	write_byte( 200 ) // speed 
	message_end()
	//Sparks 
	message_begin( MSG_PVS, SVC_TEMPENTITY,vec2) 
	write_byte( 9 ) 
	write_coord( vec2[0] ) 
	write_coord( vec2[1] ) 
	write_coord( vec2[2] ) 
	message_end()
	//Smoke     
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY,vec2) 
	write_byte( 5 ) 
	write_coord(vec2[0]) 
	write_coord(vec2[1]) 
	write_coord(vec2[2]) 
	write_short( g_sModelIndexSmoke ) 
	write_byte( 10 )  
	write_byte( 10 )  
	message_end()
}

	
#endif

public select_skill(id,saychat){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	if (p_skills[id][0] == 0){
		if (saychat==1){
			set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
			show_hudmessage(id,"You must select a race before selecting skills!")
		}
		else
			client_cmd(id,"echo You must select a race before selecting skills!")
		return PLUGIN_HANDLED
	}

	new message[256]
	new temp[128]

	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]

	if (skillsused>=p_level[id]){
		if (saychat==1){
			set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
			show_hudmessage(id,"You have already used up all your skill points!")
		}
		else
			client_cmd(id,"echo You have already used up all your skill points!")
		return PLUGIN_HANDLED
	}

	if (is_user_bot(id)){
		new randomskill
		while (skillsused < p_level[id]){
			randomskill = random_num(1,3)
			if (p_skills[id][4]==0 && p_level[id]>=6)
				p_skills[id][4]=1
			else if (p_skills[id][randomskill]!=3 && p_level[id]>2*p_skills[id][randomskill]){
				++p_skills[id][randomskill]
			}
			skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
		}
		return PLUGIN_HANDLED
	}

	format(message,255,"\ySelect Skill:\w^n")

	new skillcounter = 0
	new skillcurrentrace[4][64]

	while (skillcounter < 4){
		if (p_skills[id][0] == 1){
			copy(skillcurrentrace[skillcounter],63,race1skill[skillcounter])
		}
		else if (p_skills[id][0] == 2){
			copy(skillcurrentrace[skillcounter],63,race2skill[skillcounter])
		}
		else if (p_skills[id][0] == 3){
			copy(skillcurrentrace[skillcounter],63,race3skill[skillcounter])
		}
		else if (p_skills[id][0] == 4){
			copy(skillcurrentrace[skillcounter],63,race4skill[skillcounter])
		}
		++skillcounter
	}

	skillcounter = 1
	while (skillcounter< 4){
		if (p_skills[id][skillcounter]!=3){
			if (p_level[id]<=2*p_skills[id][skillcounter]){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			format(temp,127,"^n%d. %s Level %d\w",skillcounter,skillcurrentrace[skillcounter-1],p_skills[id][skillcounter]+1)
			add(message,255,temp)
		}
		++skillcounter
	}
	if (p_skills[id][4]==0){		
		#if MODIFIED_ULT_LEVEL
			if(  p_skills[id][0]==1 && p_level[id] < UNDEAD_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			if(  p_skills[id][0]==2 && p_level[id] < HUMAN_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			if(  p_skills[id][0]==3 && p_level[id] < ORC_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			if(  p_skills[id][0]==4 && p_level[id] < ELF_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
		#else
			if (p_level[id]<=5){
				format(temp,127,"\d")
				add(message,255,temp)
			}
		#endif
		format(temp,127,"^n4. Ultimate: %s\w",skillcurrentrace[3])
		add(message,255,temp)
	}

	new keys = (1<<9)

	if (p_skills[id][1]!=3 && p_level[id]>2*p_skills[id][1] && skillsused<p_level[id])
		keys |= (1<<0)
	if (p_skills[id][2]!=3 && p_level[id]>2*p_skills[id][2] && skillsused<p_level[id])
		keys |= (1<<1)
	if (p_skills[id][3]!=3 && p_level[id]>2*p_skills[id][3] && skillsused<p_level[id])
		keys |= (1<<2)
	
	#if MODIFIED_ULT_LEVEL
		if (p_skills[id][4]==0 && skillsused<p_level[id]){			
			if( p_level[id]>= UNDEAD_ULT) 
				keys |= (1<<3)
			
			if(  p_level[id]>= HUMAN_ULT) 
				keys |= (1<<3)
			
			if(   p_level[id]>= ORC_ULT) 
				keys |= (1<<3)
			
			if(  p_level[id]>= ELF_ULT) 
				keys |= (1<<3)
			
		}
	#else
		if (p_skills[id][4]==0 && p_level[id]>=6 && skillsused<p_level[id])
			keys |= (1<<3)
	#endif	
	

	format(temp,127,"^n^n0. Cancel")
	add(message,255,temp)
	show_menu(id,keys,message,-1)
	if (saychat==1)
		return PLUGIN_CONTINUE
	return PLUGIN_HANDLED
}

public set_skill(id,key){
	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]

	if (key == 0 && p_skills[id][1]!=3 && p_level[id]>2*p_skills[id][1] && skillsused<p_level[id])
		++p_skills[id][1]
	else if (key == 1 && p_skills[id][2]!=3 && p_level[id]>2*p_skills[id][2] && skillsused<p_level[id])
		++p_skills[id][2]
	else if (key == 2 && p_skills[id][3]!=3 && p_level[id]>2*p_skills[id][3] && skillsused<p_level[id])
		++p_skills[id][3]
		
	// This block allows admins to easily change level requirements for ultimate skills.
	#if MODIFIED_ULT_LEVEL
		else if(key == 3 && p_skills[id][4]==0 && skillsused<p_level[id]){
						
			if(  p_skills[id][0]==1 && p_level[id]>= UNDEAD_ULT) p_skills[id][4]=1
			
			if(  p_skills[id][0]==2 && p_level[id]>= HUMAN_ULT) p_skills[id][4]=1
			
			if(  p_skills[id][0]==3 && p_level[id]>= ORC_ULT) p_skills[id][4]=1
			
			if(  p_skills[id][0]==4 && p_level[id]>= ELF_ULT) p_skills[id][4]=1
			
		}
	#else
		else if (key == 3 && p_skills[id][4]==0 && p_level[id]>=6 && skillsused<p_level[id])
		p_skills[id][4]=1
	#endif	
	
		else if (key == 9)
			return PLUGIN_HANDLED

	// Count up the new skillused
	skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4] 
	
	if (skillsused < p_level[id])
		select_skill(id,0)
	else
		displaylevel(id, 0)

	return PLUGIN_HANDLED
}

public change_race(id,saychat){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

        if (p_skills[id][0]==0)
                select_race(id)


        if (is_user_alive(id) && !freezetime){
                if (saychat==1){
                        set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
                        show_hudmessage(id,"You can only change your race when you are dead!")
                }
                else{
                        client_cmd(id,"echo You can only change your race when you are dead!")
                }
                return PLUGIN_CONTINUE
        }
	

	if (get_cvar_num("mp_allowchangerace")==1 || p_skills[id][0]==0){
		if (saved_xp){
			if (!changingrace[id]){
				#if MYSQL_ENABLED
					write_xp_to_file(id, "")
				#else
					addtosavequeue(id)
				#endif
				changingrace[id]=true
				get_xp_from_file(id,1)
			}
			else if (saychat==1){
				set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
				show_hudmessage(id,"You can't change race more than once per round!")
			}
			else{
				client_cmd(id,"echo You can't change race more than once per round!")
			}
		}
		else
		{
			if (!changingrace[id]){
				select_race(id)
			}
			else if (saychat==1){
				set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
				show_hudmessage(id,"You can't change race more than once per round!")
			}
			else{
				client_cmd(id,"echo You can't change race more than once per round!")
			}
		}
	}
	else{
		if (saychat==1){
			set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
			show_hudmessage(id,"Server is not allowing race change!")
		}
		else{
			client_cmd(id,"echo Server is not allowing race change!")
		}
	}
	if (saychat==1)
		return PLUGIN_CONTINUE
	return PLUGIN_HANDLED
}


public select_race(id){

	if (is_user_bot(id)){
		p_skills[id][0] = random_num(1,4)
		return PLUGIN_HANDLED
	}

	new menu_msg[256]
	format(menu_msg,255,"\ySelect Race:\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n^n\
							5. Auto-select", racename[1],\
							racename[2], racename[3], racename[4])

	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),menu_msg,-1)
	return PLUGIN_CONTINUE
}


public set_race(id,key){
	new oldrace = p_skills[id][0]
	if (key == 0)
		p_skills[id][0] = 1
	else if (key == 1)
		p_skills[id][0] = 2
	else if (key == 2)
		p_skills[id][0] = 3
	else if (key == 3)
		p_skills[id][0] = 4
	else if (key == 4)
		p_skills[id][0] = random_num(1,4)

	if (p_skills[id][0] == oldrace)
		return PLUGIN_CONTINUE

	p_skills[id][1] = 0
	p_skills[id][2] = 0
	p_skills[id][3] = 0
	p_skills[id][4] = 0

	if (get_user_health(id)>100)
		set_user_health(id,100)

	if (saved_xp){
		playerxp[id] = 0
		p_level[id] = 0
		get_xp_from_file(id,0)
	}

	if (get_user_team(id)==0){
		engclient_cmd(id, "chooseteam")
		return PLUGIN_CONTINUE
	}
	else {
		new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]
		if (skillsused < p_level[id])
			select_skill(id,0)
	}
	return PLUGIN_CONTINUE
}


public damage_event(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new weapon, bodypart, enemy = get_user_attacker(id,weapon,bodypart)
	new damage

	new victimisdead=0
	new enemyisdead=0
	new victimkilled=0
	new enemykilled=0

	if (is_user_alive(id)==0)
		victimisdead=1

	if (is_user_alive(enemy)==0)
		enemyisdead=1
	
	#if WAR3STATS	
		damage = read_data(2)	
		dmgStat[enemy][id] += damage
		hitStat[enemy][id]++
	#endif
//	client_print(0,print_chat,"%d attacked %d with %d",enemy,id,weapon)

	if (enemy==id && weapon==0){
		return PLUGIN_CONTINUE
	}
	else if (enemy==0){
		return PLUGIN_CONTINUE
	}

	if (is_user_bot(enemy) && p_skills[enemy][4]==1){
		if (p_skills[enemy][0]==3 || p_skills[enemy][0]==4){
			ultimate(enemy)
		}
	}

	if (p_skills[id][0] == 4){		// Evasion
		if (p_skills[id][1]) {
			
			new healthadjustment
			
			
			new bool:p_evadecurrentshot = p_evadenextshot[id]
			new Float:randomnumber = random_float(0.0,1.0)
			if (randomnumber <= p_evasion[p_skills[id][1]-1]){
				p_evadenextshot[id]=true
				
				if (get_user_health(id)<=100 + HEALTHBONUS){
					healthadjustment = ELF_EVADE_ADJ
				}
				
			}
			else{
				p_evadenextshot[id]=false
				
				if (get_user_health(id)>100 + HEALTHBONUS){
					healthadjustment = -ELF_EVADE_ADJ
				}
				
			}
			if (p_evadecurrentshot){
				damage = read_data(2)
				#if WAR3STATS		
					dmgStat[enemy][id] += damage
				#endif
				
				set_user_health(id, get_user_health(id) + damage + healthadjustment)
				
				if (iglow[id][2] < 1){
					new parm[2]
					parm[0] = id
					set_task(0.1,"glow_change",7,parm,2)
				}
				iglow[id][2] += damage
				iglow[id][0] = 0
				iglow[id][1] = 0
				iglow[id][3] = 0
				if (iglow[id][2]>MAXGLOW)
					iglow[id][2]=MAXGLOW

				message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
				write_short( 1<<10 ) // fade lasts this long duration
				write_short( 1<<10 ) // fade lasts this long hold time
				write_short( 1<<12 ) // fade type (in / out)
				write_byte( 0 ) // fade red
				write_byte( 0 ) // fade green
				write_byte( 255 ) // fade blue
				write_byte( iglow[id][2] ) // fade alpha
				message_end()
				return PLUGIN_CONTINUE
			}
			
			
			if( !p_evadecurrentshot){
				set_user_health(id, get_user_health(id) + healthadjustment)
			}	
						
		}
		if (p_skills[id][2]) {		// Thorns Aura
			damage = read_data(2)
			damage = floatround(float(damage) * p_thorns[p_skills[id][2]-1])
			
			#if WAR3STATS		
				dmgStat[enemy][id] += damage
			#endif
			
			
			
			if (get_user_health(enemy) - damage<=0){
				enemykilled = 1
			}				
			else if (get_user_health(enemy) - damage<=ELF_EVADE_ADJ && get_user_health(enemy)>500){
					enemykilled = 1
			}					
			else{
				enemykilled = 0
			}
			

			if (enemykilled){
				set_user_health(enemy, -1)
				#if WAR3_MYSQL_TOP15 
					skillStat[id]++
					skillStat[enemy]--
				#endif
			}else{
				set_user_health(enemy, get_user_health(enemy) - damage)
			}
			if (iglow[enemy][0] < 1){
				new parm[2]
				parm[0] = enemy
				set_task(0.1,"glow_change",8,parm,2)
			}
			iglow[enemy][0] += 3*damage
			iglow[enemy][1] = 0
			iglow[enemy][2] = 0
			iglow[enemy][3] = 0
			if (iglow[enemy][0]>MAXGLOW)
				iglow[enemy][0]=MAXGLOW

			message_begin(MSG_ONE,gmsgFade,{0,0,0},enemy)
			write_short( 1<<10 ) // fade lasts this long duration
			write_short( 1<<10 ) // fade lasts this long hold time
			write_short( 1<<12 ) // fade type (in / out)
			write_byte( 255 ) // fade red
			write_byte( 0 ) // fade green
			write_byte( 0 ) // fade blue
			write_byte( iglow[enemy][0] ) // fade alpha
			message_end()
		}
	}

	if (p_skills[enemy][0] == 1){	// Vampiric Aura
		if (p_skills[enemy][1]) {
			damage = read_data(2)			
			damage = floatround(float(damage) * p_vampiric[p_skills[enemy][1]-1])
			
			set_user_health(enemy, get_user_health(enemy) + damage)

			if (get_user_health(enemy) > p_vampirichealth[p_skills[enemy][1]-1]+ (playeritem[enemy]==HEALTH ? HEALTHBONUS : 0) ){
				set_user_health(enemy, p_vampirichealth[p_skills[enemy][1]-1]+ (playeritem[enemy]==HEALTH ? HEALTHBONUS : 0) )
			}

			if (iglow[enemy][1] < 1){
				new parm[2]
				parm[0] = enemy
				set_task(0.1,"glow_change",9,parm,2)
			}
			iglow[enemy][1] += damage
			iglow[enemy][0] = 0
			iglow[enemy][2] = 0
			iglow[enemy][3] = 0
			if (iglow[enemy][1]>MAXGLOW)
				iglow[enemy][1]=MAXGLOW

			message_begin(MSG_ONE,gmsgFade,{0,0,0},enemy)
			write_short( 1<<10 ) // fade lasts this long duration
			write_short( 1<<10 ) // fade lasts this long hold time
			write_short( 1<<12 ) // fade type (in / out)
			write_byte( 0 ) // fade red
			write_byte( 255 ) // fade green
			write_byte( 0 ) // fade blue
			write_byte( iglow[enemy][1] ) // fade alpha
			message_end()
		}
	}

	else if (p_skills[enemy][0] == 2){	// Bash (DOESN'T WORK ON BOTS)
		if (p_skills[enemy][3]) {
			new Float:randomnumber = random_float(0.0,1.0)
			if (randomnumber <= p_bash[p_skills[enemy][3]-1] && get_user_maxspeed(id)>10 && !slowed[id]){		// Cannot bash if already bashed or frosted
				new normalspeed = floatround(get_user_maxspeed(id))
				set_user_maxspeed(id,1.0)	// Replace "id" with "enemy" to test bash on self
				stunned[id]=true
				new parm[2]
				parm[0]=id			// Replace "id" with "enemy" to test bash on self
				parm[1]=normalspeed
				set_task(1.0,"reset_maxspeed",10,parm,2)

				if (iglow[id][3] < 1){
					parm[0] = id
					parm[1] = 0
					set_task(0.1,"glow_change",11,parm,2)
				}
				iglow[id][3] += 100
				iglow[id][0] = 0
				iglow[id][1] = 0
				iglow[id][2] = 0
				if (iglow[id][3]>MAXGLOW)
					iglow[id][3]=MAXGLOW

				message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
				write_short( 1<<10 ) // fade lasts this long duration
				write_short( 1<<10 ) // fade lasts this long hold time
				write_short( 1<<12 ) // fade type (in / out)
				write_byte( 255 ) // fade red
				write_byte( 255 ) // fade green
				write_byte( 255 ) // fade blue
				write_byte( iglow[id][3] ) // fade alpha
				message_end()
			}
		}
	}

	else if (p_skills[enemy][0] == 3){	// Critical Strike
		if (p_skills[enemy][1]) {
			new Float:randomnumber = random_float(0.0,1.0)
			if (randomnumber <= p_critical[p_skills[enemy][1]-1]){
				damage = read_data(2)				
				damage = floatround(float(damage) * p_skills[enemy][1])	// Will be either 1, 2 or 3 times damage induced depending on skill level
				#if WAR3STATS		
					dmgStat[enemy][id] += damage
				#endif
				
				if (get_user_health(id) - damage<=0)
					victimkilled = 1
				
				if (get_user_health(id) - damage<=ELF_EVADE_ADJ && get_user_health(id)>500)
					victimkilled = 1
				
				if (victimkilled){
					set_user_health(id, -1)
					#if WAR3_MYSQL_TOP15 
						skillStat[enemy]++
						skillStat[id]--
					#endif
				}else{
					set_user_health(id, get_user_health(id) - damage)
				}
				if (iglow[id][0] < 1){
					new parm[2]
					parm[0] = id
					set_task(0.1,"glow_change",12,parm,2)
				}
				iglow[id][0] += damage
				iglow[id][1] = 0
				iglow[id][2] = 0
				iglow[id][3] = 0
				if (iglow[id][0]>MAXGLOW)
					iglow[id][0]=MAXGLOW

				message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
				write_short( 1<<10 ) // fade lasts this long duration
				write_short( 1<<10 ) // fade lasts this long hold time
				write_short( 1<<12 ) // fade type (in / out)
				write_byte( 255 ) // fade red
				write_byte( 0 ) // fade green
				write_byte( 0 ) // fade blue
				write_byte( iglow[id][0] ) // fade alpha
				message_end()
			}
		}
		

		// The easy to read Orc nade blocking code block		
		new bool:orcNadePermit = true		
		
	#if ORCNADE_CVAR 
		if(!get_cvar_num("mp_alloworcnade")) { 
			orcNadePermit = false; 
		} 
	#endif 
        #if ORCNECKLACE         // If true, Necklace blocks Orc nades. 
                if(playeritem[id] == IMMUNITY) { 
			orcNadePermit = false; 
		} 
	#endif 	
		
		if ( (weapon == 4) && p_skills[enemy][2] && orcNadePermit ){	
			
			damage = read_data(2)
			
			damage = floatround(float(damage) * p_grenade[p_skills[enemy][2]-1])
			#if WAR3STATS		
				dmgStat[enemy][id] += damage
			#endif
			
			if (get_user_health(id) - damage<=0)
				victimkilled = 1
			
			if (get_user_health(id) - damage<=ELF_EVADE_ADJ && get_user_health(id)>500)
				victimkilled = 1
			
			if (victimkilled){
				set_user_health(id, -1)
				#if WAR3_MYSQL_TOP15 
					skillStat[enemy]++
					skillStat[id]--
				#endif
			}else{
				set_user_health(id,get_user_health(id) - damage)
			}
			if (iglow[id][0] < 1){
				new parm[2]
				parm[0] = id
				set_task(0.1,"glow_change",13,parm,2)
			}
			iglow[id][0] += damage
			iglow[id][1] = 0
			iglow[id][2] = 0
			iglow[id][3] = 0
			if (iglow[id][0]>MAXGLOW)
				iglow[id][0]=MAXGLOW
			message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
			write_short( 1<<10 ) // fade lasts this long duration
			write_short( 1<<10 ) // fade lasts this long hold time
			write_short( 1<<12 ) // fade type (in / out)
			write_byte( 255 ) // fade red
			write_byte( 0 ) // fade green
			write_byte( 0 ) // fade blue
			write_byte( iglow[id][0] ) // fade alpha
			message_end()
		}		
	}

	else if (p_skills[enemy][0] == 4){	// Trueshot Aura
		if (p_skills[enemy][3]) {
			damage = read_data(2)
			damage = floatround(float(damage) * p_trueshot[p_skills[enemy][3]-1])
			#if WAR3STATS		
				dmgStat[enemy][id] += damage
			#endif
			
			if (get_user_health(id) - damage<=0)
				victimkilled = 1
			
			if (get_user_health(id) - damage<=ELF_EVADE_ADJ && get_user_health(id)>500)
				victimkilled = 1
			
			if (victimkilled){
				set_user_health(id, -1)
				#if WAR3_MYSQL_TOP15 
					skillStat[enemy]++
					skillStat[id]--
				#endif
			}else{
				set_user_health(id, get_user_health(id) - damage)
			}

			if (iglow[id][0] < 1){
				new parm[2]
				parm[0] = id
				set_task(0.1,"glow_change",14,parm,2)
			}
			iglow[id][0] += 2*damage
			iglow[id][1] = 0
			iglow[id][2] = 0
			iglow[id][3] = 0
			if (iglow[id][0]>MAXGLOW)
				iglow[id][0]=MAXGLOW

			message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
			write_short( 1<<10 ) // fade lasts this long duration
			write_short( 1<<10 ) // fade lasts this long hold time
			write_short( 1<<12 ) // fade type (in / out)
			write_byte( 255 ) // fade red
			write_byte( 0 ) // fade green
			write_byte( 0 ) // fade blue
			write_byte( iglow[id][0] ) // fade alpha
			message_end()
		}
	}

	if (playeritem[enemy] == CLAWS){	// Claws of Attack
		damage = CLAWSOFATTACK
		#if WAR3STATS		
			dmgStat[enemy][id] += damage
		#endif
		
		if (get_user_health(id) - damage<=0)
			victimkilled = 1
		
		if (get_user_health(id) - damage<=ELF_EVADE_ADJ && get_user_health(id)>500)
			victimkilled = 1
	
		if (victimkilled){
			set_user_health(id, -1)
			#if WAR3_MYSQL_TOP15 
				skillStat[enemy]++
				skillStat[id]--
			#endif
		}else{
			set_user_health(id, get_user_health(id) - damage)
		}

		if (iglow[id][0] < 1){
			new parm[2]
			parm[0] = id
			set_task(0.1,"glow_change",14,parm,2)
		}
		iglow[id][0] += 2*damage
		iglow[id][1] = 0
		iglow[id][2] = 0
		iglow[id][3] = 0
		if (iglow[id][0]>MAXGLOW)

		iglow[id][0]=MAXGLOW
		message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
		write_short( 1<<10 ) // fade lasts this long duration
		write_short( 1<<10 ) // fade lasts this long hold time
		write_short( 1<<12 ) // fade type (in / out)
		write_byte( 255 ) // fade red
		write_byte( 0 ) // fade green
		write_byte( 0 ) // fade blue
		write_byte( iglow[id][0] ) // fade alpha
		message_end()
	}
	else if (playeritem[enemy] == MASK){		// Mask of Death
		damage = read_data(2)
		
		damage = floatround(float(damage) * MASKPERCENT)		
		set_user_health(enemy, get_user_health(enemy) + damage)

                if (get_user_health(enemy) > (p_skills[enemy][0]==2 ? p_devotion[p_skills[enemy][2]-1] : 100) ){
                        set_user_health(enemy, (p_skills[enemy][0]==2 ? p_devotion[p_skills[enemy][2]-1] : 100) )
                }


		if (iglow[enemy][1] < 1){
			new parm[2]
			parm[0] = enemy
			set_task(0.1,"glow_change",9,parm,2)
		}
		iglow[enemy][1] += damage
		iglow[enemy][0] = 0
		iglow[enemy][2] = 0
		iglow[enemy][3] = 0
		if (iglow[enemy][1]>MAXGLOW)
			iglow[enemy][1]=MAXGLOW

		message_begin(MSG_ONE,gmsgFade,{0,0,0},enemy)
		write_short( 1<<10 ) // fade lasts this long duration
		write_short( 1<<10 ) // fade lasts this long hold time
		write_short( 1<<12 ) // fade type (in / out)
		write_byte( 0 ) // fade red
		write_byte( 255 ) // fade green
		write_byte( 0 ) // fade blue
		write_byte( iglow[enemy][1] ) // fade alpha
		message_end()
	}
	else if (playeritem[enemy] == FROST){	// Frost (DOESN'T WORK ON BOTS)
		if (get_user_maxspeed(id)>10 && !slowed[id]){		// Cannot frost if bashed or frosted
			new normalspeed = floatround(get_user_maxspeed(id))
			set_user_maxspeed(id,FROSTSPEED)	// Replace "id" with "enemy" to test bash on self
			slowed[id]=true
			new parm[2]
			parm[0]=id			// Replace "id" with "enemy" to test bash on self
			parm[1]=normalspeed
			set_task(1.0,"reset_maxspeed",10,parm,2)

			if (iglow[id][3] < 1){
				parm[0] = id
				parm[1] = 0
				set_task(0.1,"glow_change",11,parm,2)
			}
			iglow[id][3] += 100
			iglow[id][0] = 0
			iglow[id][1] = 0
			iglow[id][2] = 0
			if (iglow[id][3]>MAXGLOW)
				iglow[id][3]=MAXGLOW

			message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
			write_short( 1<<10 ) // fade lasts this long duration
			write_short( 1<<10 ) // fade lasts this long hold time
			write_short( 1<<12 ) // fade type (in / out)
			write_byte( 255 ) // fade red
			write_byte( 255 ) // fade green
			write_byte( 255 ) // fade blue
			write_byte( iglow[id][3] ) // fade alpha
			message_end()
		}
	}

	if (enemykilled && !enemyisdead){	// due to thorns aura
		if (get_user_team(id)!=get_user_team(enemy)){
			set_user_frags(id, get_user_frags(id)+1)
			set_user_frags(enemy, get_user_frags(enemy)+1)
			playerxp[id]+=xpgiven[p_level[enemy]]
			#if WAR3STATS
				xpStat[id][enemy] += xpgiven[p_level[enemy]]
			#endif
			displaylevel(id, 1)
		}
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(id)
		write_byte(enemy)
		write_byte(0)
		write_string(race4skill[1])
		message_end()
	}

	if (victimkilled && !victimisdead){		// due to all aggressive auras
		new headshot
		if (bodypart==1)
			headshot=1
		else
			headshot=0
		new weaponname[32]

		switch (weapon)
		{
		case 1:
			weaponname = "p228"
		case 3:
			weaponname = "scout"
		case 4:
			weaponname = "grenade"
		case 5:
			weaponname = "xm1014"
		case 7:
			weaponname = "mac10"
		case 8:
			weaponname = "aug"
		case 10:
			weaponname = "elite"
		case 11:
			weaponname = "fiveseven"
		case 12:
			weaponname = "ump45"
		case 13:
			weaponname = "sg550"
		case 16:
			weaponname = "usp"
		case 17:
			weaponname = "glock18"
		case 18:
			weaponname = "awp"
		case 19:
			weaponname = "mp5navy"
		case 20:
			weaponname = "m249"
		case 21:
			weaponname = "m3"
		case 22:
			weaponname = "m4a1"
		case 23:
			weaponname = "tmp"
		case 24:
			weaponname = "g3sg1"
		case 26:
			weaponname = "deagle"
		case 27:
			weaponname = "sg552"
		case 28:
			weaponname = "ak47"
		case 29:
			weaponname = "knife"
		case 30:
			weaponname = "p90"
		}
		if (!victimisdead){
			if (get_user_team(id)!=get_user_team(enemy)){
				set_user_frags(id, get_user_frags(id)+1)
				set_user_frags(enemy, get_user_frags(enemy)+1)
				if (!get_cvar_num("mp_weaponxpmodifier")){
					playerxp[enemy]+=xpgiven[p_level[id]]
					#if WAR3STATS
						xpStat[enemy][id] += xpgiven[p_level[id]]
					#endif
				}else{
					playerxp[enemy]+=floatround(xpgiven[p_level[id]]*weaponxpmultiplier[weapon])
					#if WAR3STATS
						xpStat[enemy][id] += floatround(xpgiven[p_level[id]]*weaponxpmultiplier[weapon])
					#endif
				}
			}
			else{
				set_user_frags(id, get_user_frags(id)+1)
				set_user_frags(enemy, get_user_frags(enemy)-1)
				playerxp[enemy]-=xpgiven[p_level[enemy]]
				#if WAR3STATS
					xpStat[enemy][id] -=xpgiven[p_level[enemy]]
				#endif
			}
		}
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(enemy)
		write_byte(id)
		write_byte(headshot)
		write_string(weaponname)
		message_end()
		displaylevel(enemy, 1)
	}

	return PLUGIN_CONTINUE
} 

public glow_change(parm[]){
	new id = parm[0]

	if (p_skills[id][0]==2 && p_skills[id][1]){	// Don't glow if player is invisible
		iglow[id][0] = 0
		iglow[id][1] = 0
		iglow[id][2] = 0
		iglow[id][3] = 0
	}
	if (playeritem[id]==CLOAK){		// Don't glow if player is invisible
		iglow[id][0] = 0
		iglow[id][1] = 0
		iglow[id][2] = 0
		iglow[id][3] = 0
	}
	else if (iglow[id][0] > 5){
		set_user_rendering(id,kRenderFxGlowShell,iglow[id][0],0,0, kRenderNormal, 16)
		iglow[id][0] -= 5
		set_task(0.2,"glow_change",15,parm,2)
	}
	else if (iglow[id][1] > 5){
		set_user_rendering(id,kRenderFxGlowShell,0,iglow[id][1],0, kRenderNormal, 16)
		iglow[id][1] -= 5
		set_task(0.2,"glow_change",16,parm,2)
	}
	else if (iglow[id][2] > 5){
		set_user_rendering(id,kRenderFxGlowShell,0,0,iglow[id][2], kRenderNormal, 16)
		iglow[id][2] -= 5
		set_task(0.2,"glow_change",17,parm,2)
	}
	else if (iglow[id][3] > 5){
		set_user_rendering(id,kRenderFxGlowShell,iglow[id][3],iglow[id][3],iglow[id][3], kRenderNormal, 16)
		iglow[id][3] -= 5
		set_task(0.2,"glow_change",18,parm,2)
	}
	else{
		iglow[id][0] = 0
		iglow[id][1] = 0
		iglow[id][2] = 0
		iglow[id][3] = 0
		set_user_rendering(id)
	}
	return PLUGIN_CONTINUE
}

public reset_maxspeed(parm[]){
	new enemy = parm[0]
	new normalspeed = parm[1]
	stunned[enemy]=false
	slowed[enemy]=false
	set_user_maxspeed(enemy, float(normalspeed))
	return PLUGIN_CONTINUE
}

#if STEAM_POWERED
public zoomed2(id){
    zoomed[id]=1
}

public unzoomed(id){
    zoomed[id]=0
}
#endif

public change_weapon(id) {
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	if (p_skills[id][0] == 2 && p_skills[id][1]){	// Invisibility
		if (read_data(2)==29){
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,p_invisibility[p_skills[id][1]-1]-p_invisibility[2]+KNIFEINVISIBILITY)
			knifeselected[id]=true
		}
		else{
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,p_invisibility[p_skills[id][1]-1])
			knifeselected[id]=false
		}
	}
	else if (playeritem[id]==CLOAK){
		if (read_data(2)==29){
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,CLOAKINVISIBILITY-p_invisibility[2]+KNIFEINVISIBILITY)
			knifeselected[id]=true
		}
		else{
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,CLOAKINVISIBILITY)
			knifeselected[id]=false
		}
	}
	#if STEAM_POWERED
	        new weaponnum = (read_data(2)) 
	        if (!freezetime && !slowed[id] && !stunned[id]) {                
	                if (weaponnum==3){ //scout
	                        if (zoomed[id]==1)
	                                set_user_maxspeed(id,220.0)
	                        else
	                                set_user_maxspeed(id,260.0) //220 zoomed
	                }       
	                else if (weaponnum==4){ //hegrenad
	                        set_user_maxspeed(id,260.0)
	                }
	                else if (weaponnum==5){ //xm1014
	                        set_user_maxspeed(id,230.0)
	                }
	                else if (weaponnum==7){ //mac10
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==8){ //aug - bollup
	                        set_user_maxspeed(id,240.0)
	                }
	                else if (weaponnum==9){ //smokegrenade
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==12){ //ump45
	                        set_user_maxspeed(id,250.0)
	                }
	     	        else if (weaponnum==13){ //sg550
	                        if (zoomed[id]==1)
	                                set_user_maxspeed(id,150.0)
	                        else
	                                set_user_maxspeed(id,210.0) //150 zoomed
	                }
	                else if (weaponnum==18){ //awp
	                        if (zoomed[id]==1)
	                                set_user_maxspeed(id,150.0)
	                        else
	                                set_user_maxspeed(id,210.0) //150 zoomed
	                }
	                else if (weaponnum==19){ //mp5
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==20){ //m249
	                        set_user_maxspeed(id,220.0)
	                }
	                else if (weaponnum==21){ //auto-shotty (m3)
	                        set_user_maxspeed(id,240.0)
	                }
	                else if (weaponnum==14){ //galil
	                        set_user_maxspeed(id,240.0)
	                }
	                else if (weaponnum==15){ //famas
	                        set_user_maxspeed(id,240.0)
	                }
	                else if (weaponnum==22){ //M4A1
	                        set_user_maxspeed(id,230.0)
	                }
	                else if (weaponnum==23){ //TMP
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==24){ //G3SG1
	                        if (zoomed[id]==1)
	                                set_user_maxspeed(id,150.0)
	                        else
	                                set_user_maxspeed(id,210.0) //150 zoomed
	                }
	                else if (weaponnum==25){ //flashbang
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==27){ //sg552
	                        set_user_maxspeed(id,235.0)
	                }
	                else if (weaponnum==28){ //AK47
	                        set_user_maxspeed(id,221.0)
	                }
	                else if (weaponnum==30){ //P90
	                        set_user_maxspeed(id,245.0)
	                }
	                else if (weaponnum==1){ //p228
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==10 ){ //elite
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==11){ //fiveseven
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==26){ //deagle
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==16){ //usp
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==17){ //glock
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==29){ //knife
	                        set_user_maxspeed(id,250.0)
	                }
	                else if (weaponnum==6){ //BOMB
	                        set_user_maxspeed(id,250.0)
	                }
	        }
	#endif
	new parm[1]
	parm[0]=id
	unholyspeed(parm)

	return PLUGIN_CONTINUE
}

public freezetimedone(id) {
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	#if STEAM_POWERED
		set_user_maxspeed(id,240.0)
	#endif
	#if WAR3STATS
		reset_stats()
	#endif	
	
	gogogo=true
	freezetime = 0
	new parm[1]
	parm[0]=id
	set_task(0.1,"unholyspeed",19,parm,1)

	return PLUGIN_CONTINUE
}

public unholyspeed(parm[1]){
	new id = parm[0]

	if (stunned[id]){
		set_user_maxspeed(id,1.0)
	}
	else if (slowed[id]){
		set_user_maxspeed(id,FROSTSPEED)
	}
	#if STEAM_POWERED
	else if (p_skills[id][0] == 1 && p_skills[id][2]){              // Unholy Aura
       	        if (get_user_maxspeed(id)>10 && get_user_maxspeed(id)!=p_unholy[p_skills[id][2]-1]){
			set_user_maxspeed(id,(p_unholy[p_skills[id][2]-1]))
		}
	}
	#else
	else if (get_user_maxspeed(id)>10 && p_skills[id][0] == 1 && p_skills[id][2]){		// Unholy Aura
		if (get_user_maxspeed(id)!=p_unholy[p_skills[id][2]-1]){
			set_user_maxspeed(id,(p_unholy[p_skills[id][2]-1]))
		}
	}
	#endif
	else if (get_user_maxspeed(id)>10 && playeritem[id]==BOOTS){			// Boots of Speed
		if (get_user_maxspeed(id)!=BOOTSPEED){
			set_user_maxspeed(id,BOOTSPEED)
		}
	}
	return PLUGIN_CONTINUE
}

#if MULTI_WEP_FIX
	public weapon_controller( parm[2]  ){
		
		if (warcraft3==false)
			return PLUGIN_CONTINUE
		
		new id = parm[0]		
		new origin[3]
		new weaponid, weaponname[20], ammoname[20]
		new bool:reincarnate	
		new iweapons[32], wpname[32], inum
		get_user_weapons(id,iweapons,inum)
		
		reincarnate = false
						
		// Save weapons of people who survived: otherwise the stripper will nab them...
		if( diedlastround[id] == false ){  // LIVED LAST ROUND
			reincarnate = false			
		}
		                    		
		// Equipement & Eligibility Check for Re-Incarnation
		if ( diedlastround[id]){	// DIED LAST ROUND		
			new Float:randomnumber = random_float(0.0,1.0)   
			
			if (p_skills[id][0] == 3 && p_skills[id][3] && randomnumber <= p_ankh[p_skills[id][3]-1]){
				reincarnate = true				
				//client_print(id,print_chat, "skill detected")
			}
			if (playerItemOld[id]==ANKH){
				reincarnate = true				
				//client_print(id,print_chat, "Ankh  detected")
			}
				
			diedlastround[id]=false
		}			
			
		// Equipement Re-Incarnation: Includes pistols. Also, living ppl need to be re-incarnated.
		if (reincarnate){					
				// Disarm and Isolate Player Before Re-Incarnation
				get_user_origin(id,origin)
				origin[2] -= 2000
				set_user_origin(id,origin)
				for(new a=0;a<inum;++a){
					if( iweapons[a] != CSW_C4){
						get_weaponname(iweapons[a],wpname,31)
						engclient_cmd(id,"drop",wpname)
					}
				}
				engclient_cmd(id,"weapon_knife")
				origin[2] += 2005
				
				
				if (armorondeath[id]){
					if (helmet[id])
						give_item(id,"item_assaultsuit")
					else
						give_item(id,"item_kevlar")
					set_user_armor(id,armorondeath[id])
				}
				if (hasdefuse[id])
					give_item(id,"item_thighpack")
	
				for (new j=0; (j < savednumber[id]) && (j < 32); ++j){
					weaponid=savedweapons[id][j]
	

					if( weaponid==CSW_USP){
						weaponname="weapon_usp"
						ammoname="ammo_45acp"
						
					}
					else if( weaponid==CSW_ELITE){
						weaponname="weapon_elite"
						ammoname="ammo_9mm"
						
					}
					else if( weaponid==CSW_FIVESEVEN){
						weaponname="weapon_fiveseven"
						ammoname="ammo_57mm"
						
					}
					else if( weaponid==CSW_GLOCK18){
						weaponname="weapon_glock18"
						ammoname="ammo_9mm"
						
					}
					else if( weaponid==CSW_DEAGLE){
						weaponname="weapon_deagle"
						ammoname="ammo_50ae"
						
					}
					else if( weaponid==CSW_P228){
						weaponname="weapon_p228"
						ammoname="ammo_357sig"
						
					}
					else if (weaponid==3){
						weaponname="weapon_scout"
						ammoname="ammo_762nato"
					}
					else if (weaponid==4){
					#if STEAM_POWERED
						give_item(id,"weapon_hegrenade")
					#else
						weaponname=""
						ammoname=""
						parm[1]=4
						set_task(1.0,"buy_weapons",96,parm,2)
						set_user_money(id,get_user_money(id)+300,0)
					#endif
					}
					else if (weaponid==5){
						weaponname="weapon_xm1014"
						ammoname="ammo_buckshot"
					}
					else if (weaponid==7){
						weaponname="weapon_mac10"
						ammoname="ammo_45acp"
					}
					else if (weaponid==8){
						weaponname="weapon_aug"
						ammoname="ammo_556nato"
					}
					else if (weaponid==9){
					#if STEAM_POWERED
						give_item(id,"weapon_smokegrenade")	
					#else
						weaponname=""
						ammoname=""
						parm[1]=5
						set_task(1.0,"buy_weapons",96,parm,2)
						set_user_money(id,get_user_money(id)+300,0)
					#endif
					}
					else if (weaponid==12){
						weaponname="weapon_ump45"
						ammoname="ammo_45acp"
					}
					else if (weaponid==13){
						weaponname="weapon_sg550"
						ammoname="ammo_556nato"
					}
					#if STEAM_POWERED
					else if (weaponid==14){
						weaponname="weapon_galil"
						ammoname="ammo_556nato"
					}
					else if (weaponid==15){
						weaponname="weapon_famas"
						ammoname="ammo_556nato"
					}
					#endif
					else if (weaponid==18){
						weaponname="weapon_awp"
						ammoname="ammo_338magnum"
					}
					else if (weaponid==19){
						weaponname="weapon_mp5navy"
						ammoname="ammo_9mm"				
					}
					else if (weaponid==20){
						weaponname="weapon_m249"
						ammoname="ammo_556natobox"
					}
					else if (weaponid==21){
						weaponname="weapon_m3"
						ammoname="ammo_buckshot"
					}
					else if (weaponid==22){
						weaponname="weapon_m4a1"
						ammoname="ammo_556nato"
					}
					else if (weaponid==23){
						weaponname="weapon_tmp"
						ammoname="ammo_9mm"
					}
					else if (weaponid==24){
						weaponname="weapon_g3sg1"
						ammoname="ammo_762nato"
					}
					else if (weaponid==25){
					#if STEAM_POWERED
						give_item(id,"weapon_flashbang")	
					#else
						weaponname=""
						ammoname=""
						parm[1]=3
						set_task(1.0,"buy_weapons",96,parm,2)
						set_user_money(id,get_user_money(id)+200,0)
					#endif
					}
					else if (weaponid==27){
						weaponname="weapon_sg552"
						ammoname="ammo_556nato"
					}
					else if (weaponid==28){
						weaponname="weapon_ak47"
						ammoname="ammo_762nato"
					}
					else if (weaponid==30){
						weaponname="weapon_p90"
						ammoname="ammo_57mm"
					}
					else{
						weaponname=""
						ammoname=""
					}
					if (contain(weaponname,"weapon_")==0){	// -1 if no match found, 0 if match
						give_item(id,weaponname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)
						give_item(id,ammoname)						
					}
				}
	
				if (iglow[id][1] < 1){
					parm[0] = id
					set_task(0.1,"glow_change",4,parm,2)
				} 
				iglow[id][1] += 100
				iglow[id][0] = 0
				iglow[id][2] = 0
				iglow[id][3] = 0
				if (iglow[id][1]>MAXGLOW)
					iglow[id][1]=MAXGLOW
				message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
				write_short( 1<<10 ) // fade lasts this long duration
				write_short( 1<<10 ) // fade lasts this long hold time
				write_short( 1<<12 ) // fade type (in / out)
				write_byte( 0 ) // fade red
				write_byte( 255 ) // fade green
				write_byte( 0 ) // fade blue
				write_byte( iglow[id][1] ) // fade alpha
				message_end()
			
			
				// Restore Re-Incarnated Player to the map
				set_user_origin(id,origin)
			}else{
				hasdefuse[id]=false					
			}
		
		return PLUGIN_HANDLED	
	}	
#endif

	


public say_level(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE


	displaylevel(id, 0)
	return PLUGIN_CONTINUE
}

public player_skills(id,saychat){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
		
	new name[32], message[2048]
	#if STEAM_POWERED
		new temp[1024]
	#else	
		new temp[256]
	#endif
	
	new skill1[64], skill2[64], skill3[64], skill4[64]
	new players[32]
	new numberofplayers
	get_players(players, numberofplayers)
	new i
	new playerid
	#if STEAM_POWERED
		 add(message,2047,"<HTML><head></head><body bgcolor=#000000><font color=#FFB000>")
	#endif
	for (i = 0; i < numberofplayers; ++i){
		skill1=""
		skill2=""
		skill3=""
		skill4=""
		playerid=players[i]
		get_user_name(playerid,name,31)
		if (p_skills[playerid][0]==1){
			if(p_skills[playerid][1])
				format(skill1,63,", %s %d",race1skill[0],p_skills[playerid][1])
			if(p_skills[playerid][2])
				format(skill2,63,", %s %d",race1skill[1],p_skills[playerid][2])
			if(p_skills[playerid][3])
				format(skill3,63,", %s %d",race1skill[2],p_skills[playerid][3])
			if(p_skills[playerid][4])
				format(skill4,63,", %s",race1skill[3])
			#if STEAM_POWERED
				format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[1],p_level[playerid],skill1,skill2,skill3,skill4)
			#else
				format(temp,255,"%s - %s %d%s%s%s%s^n",name,racename[1],p_level[playerid],skill1,skill2,skill3,skill4)
			#endif
		}
		else if (p_skills[playerid][0]==2){
			if(p_skills[playerid][1])
				format(skill1,63,", %s %d",race2skill[0],p_skills[playerid][1])
			if(p_skills[playerid][2])
				format(skill2,63,", %s %d",race2skill[1],p_skills[playerid][2])
			if(p_skills[playerid][3])
				format(skill3,63,", %s %d",race2skill[2],p_skills[playerid][3])
			if(p_skills[playerid][4])
				format(skill4,63,", %s",race2skill[3])
			#if STEAM_POWERED
				format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[2],p_level[playerid],skill1,skill2,skill3,skill4)
			#else
				format(temp,255,"%s - %s %d%s%s%s%s^n",name,racename[2],p_level[playerid],skill1,skill2,skill3,skill4)
			#endif
		}
		else if (p_skills[playerid][0]==3){
			if(p_skills[playerid][1])
				format(skill1,63,", %s %d",race3skill[0],p_skills[playerid][1])
			if(p_skills[playerid][2])
				format(skill2,63,", %s %d",race3skill[1],p_skills[playerid][2])
			if(p_skills[playerid][3])
				format(skill3,63,", %s %d",race3skill[2],p_skills[playerid][3])
			if(p_skills[playerid][4])
				format(skill4,63,", %s",race3skill[3])
			#if STEAM_POWERED
				format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[2],p_level[playerid],skill1,skill2,skill3,skill4)
			#else
				format(temp,255,"%s - %s %d%s%s%s%s^n",name,racename[3],p_level[playerid],skill1,skill2,skill3,skill4)
			#endif
		}
		else if (p_skills[playerid][0]==4){
			if(p_skills[playerid][1])
				format(skill1,63,", %s %d",race4skill[0],p_skills[playerid][1])
			if(p_skills[playerid][2])
				format(skill2,63,", %s %d",race4skill[1],p_skills[playerid][2])
			if(p_skills[playerid][3])
				format(skill3,63,", %s %d",race4skill[2],p_skills[playerid][3])
			if(p_skills[playerid][4])
				format(skill4,63,", %s",race4skill[3])
			#if STEAM_POWERED
				format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[4],p_level[playerid],skill1,skill2,skill3,skill4)
			#else
				format(temp,255,"%s - %s %d%s%s%s%s^n",name,racename[4],p_level[playerid],skill1,skill2,skill3,skill4)
			#endif
		}
		else if (p_skills[playerid][0]==0){
			#if STEAM_POWERED
				format(temp,1023,"%s - race not yet selected<br>",name)
			#else
				format(temp,255,"%s - race not yet selected^n",name)
			#endif
		}
		add(message,2047,temp)
	}
	if (saychat==1){
		show_motd(id,message,"Warcraft 3 XP Player Skills")
		return PLUGIN_CONTINUE
	}
	else{
		console_print(id,message)
	}
	return PLUGIN_HANDLED
}

public skills_info(id,saychat){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new message[1024]
	new title[64]
	#if STEAM_POWERED
	        if (p_skills[id][0]==1){
        	        format(title,63,"%s Skills",racename[1])
                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Vampiric Aura: Gives you (%d%%, %d%% or %d%%) of the damage you do in attack back as health<p>\
                	Unholy Aura: Gives you a speed boost, also all weapons make you go at the same speed<p>\
	                Levitation: Allows you to jump higher by reducing your gravity<p>\
	                Ultimate, Suicide Bomber: When you die you will explode killing nearby enemies and regenerate"
	                format(message,2047,message,floatround(p_vampiric[0]*100),floatround(p_vampiric[1]*100),floatround(p_vampiric[2]*100))
	        }       
	        else if (p_skills[id][0]==2){
	        	#if BLINK_HUMAN_ULTIMATE
	        		format(title,63,"%s Skills",racename[2])
	                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Invisibility: Makes you partially invisible, you will be harder to see<p>\
                           	Devotion Aura: Gives you (%d, %d or %d) health at the start of the round.<p>\
				Bash: When you shoot someone you have a (%d%%, %d%% or %d%%) chance of rendering them immobile for 1 second<p>\
                           	Ultimate, Teleport: Allows you to teleport to where you aim (avoid ceilings)."
		       		format(message,2047,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
	        	#else
	        		format(title,63,"%s Skills",racename[2])
	               		message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Invisibility: Makes you partially invisible, you will be harder to see<p>\
                           	Devotion Aura: Gives you (%d, %d or %d) health at the start of the round.<p>\
				Bash: When you shoot someone you have a (%d%%, %d%% or %d%%) chance of rendering them immobile for 1 second<p>\
                           	Ultimate, Teleport: Allows you to teleport to a team mate (10 seconds cooldown)"
		        	format(message,2047,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
	        	#endif	              
        	}                  
	        else if (p_skills[id][0]==3){
        	        format(title,63,"%s Skills",racename[3])
                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Critical Strike: Gives you a %d%% chance of doing (2, 3, or 4) times normal damage<p>\
                           	Critical Grenade: Grenades will ALWAYS do (%d, %d or %d) times normal damage<p>\
	                        Equipment Reincarnation: Gives you a (%d%%, %d%% or %d%%) chance of regaining your equipment on death<p>\
        	                Ultimate, Chain Lightning: Discharges a bolt of lightning that jumps to all nearby enemies"
                	format(message,2047,message,floatround(p_critical[0]*100),floatround(p_grenade[0])+1,floatround(p_grenade[1])+1,floatround(p_grenade[2])+1,floatround(p_ankh[0]*100),floatround(p_ankh[1]*100),floatround(p_ankh[2]*100))
        	}                  
	        else if (p_skills[id][0]==4){
        	        format(title,63,"%s Skills",racename[4])
	                message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Evasion: Gives you a (%d%%, %d%% or %d%%) chance of evading each shot<p>\
	                           Thorns Aura: Does (%d%%, %d%% or %d%%) mirror damage to the person who shot you<p>\
	                           Trueshot Aura: Does (%d%%, %d%% or %d%%) extra damage to the enemy<p>\
	                           Ultimate, Entangle Roots: Allows you to prevent an enemy player from moving for 10 seconds"
	                format(message,2047,message,floatround(p_evasion[0]*100),floatround(p_evasion[1]*100),floatround(p_evasion[2]*100),floatround(p_thorns[0]*100),floatround(p_thorns[1]*100),floatround(p_thorns[2]*100),floatround(p_trueshot[0]*100),floatround(p_trueshot[1]*100),floatround(p_trueshot[2]*100))
        	}
	        else{
	                client_cmd(id,"echo You must select a race before viewing the skills information!")
        	        return PLUGIN_HANDLED
	        }
        	if (p_skills[id][0]==1){
                	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    When you press the key (shift in this case) with this race, you will detonate and hopefully<br> take a few enemies with you."
                	add(message,1023,temp)
	        }else
	        if (p_skills[id][0]==2 || p_skills[id][0]==3 || p_skills[id][0]==4){
	                new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    Then press the key (shift in this case) you should hear a beeping sound, this means that you are searching for<br> a target. \
                                    Once you hear the beeping sound aim your crosshair at a player and wait until it locks on.<br> You have 5 seconds to find a target before it gives up."
                	add(message,1023,temp)
	        }
	#else
		if (p_skills[id][0]==1){
			format(title,63,"%s Skills",racename[1])
			message = "Vampiric Aura: Gives you (%d%%, %d%% or %d%%) of the damage you do in attack back as health^n^n\
				   Unholy Aura: Gives you a speed boost, also all weapons make you go at the same speed^n^n\
				   Levitation: Allows you to jump higher by reducing your gravity^n^n\
				   Ultimate, Suicide Bomber: When you die you will explode killing nearby enemies"
			format(message,1023,message,floatround(p_vampiric[0]*100),floatround(p_vampiric[1]*100),floatround(p_vampiric[2]*100))
		}
		else if (p_skills[id][0]==2){
			#if BLINK_HUMAN_ULTIMATE
				format(title,63,"%s Skills",racename[2])
				message = "Invisibility: Makes you partially invisible, you will be harder to see^n^n\
			           Devotion Aura: Gives you (%d, %d or %d) health at the start of the round.^n^n\
				   Bash: When you shoot someone you have a (%d%%, %d%% or %d%%) chance of rendering them immobile for 1 second^n^n\
				   Ultimate, Teleport: Allows you to teleport to where you aim (avoid ceilings)."
				format(message,1023,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
			#else
				format(title,63,"%s Skills",racename[2])
				message = "Invisibility: Makes you partially invisible, you will be harder to see^n^n\
			           Devotion Aura: Gives you (%d, %d or %d) health at the start of the round.^n^n\
				   Bash: When you shoot someone you have a (%d%%, %d%% or %d%%) chance of rendering them immobile for 1 second^n^n\
				   Ultimate, Teleport: Allows you to teleport to a team mate (10 seconds cooldown)"
				format(message,1023,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
			#endif
			
		}
		else if (p_skills[id][0]==3){
			format(title,63,"%s Skills",racename[3])
			message = "Critical Strike: Gives you a %d%% chance of doing (2, 3, or 4) times normal damage^n^n\
				   Critical Grenade: Grenades will ALWAYS do (%d, %d or %d) times normal damage^n^n\
				   Equipment Reincarnation: Gives you a (%d%%, %d%% or %d%%) chance of regaining your equipment on death^n^n\
				   Ultimate, Chain Lightning: Discharges a bolt of lightning that jumps to all nearby enemies"
			format(message,1023,message,floatround(p_critical[0]*100),floatround(p_grenade[0])+1,floatround(p_grenade[1])+1,floatround(p_grenade[2])+1,floatround(p_ankh[0]*100),floatround(p_ankh[1]*100),floatround(p_ankh[2]*100))
		}
		else if (p_skills[id][0]==4){
			format(title,63,"%s Skills",racename[4])
			message = "Evasion: Gives you a (%d%%, %d%% or %d%%) chance of evading each shot^n^n\
				   Thorns Aura: Does (%d%%, %d%% or %d%%) mirror damage to the person who shot you^n^n\
				   Trueshot Aura: Does (%d%%, %d%% or %d%%) extra damage to the enemy^n^n\
				   Ultimate, Entangle Roots: Allows you to prevent an enemy player from moving for 10 seconds"
			format(message,1023,message,floatround(p_evasion[0]*100),floatround(p_evasion[1]*100),floatround(p_evasion[2]*100),floatround(p_thorns[0]*100),floatround(p_thorns[1]*100),floatround(p_thorns[2]*100),floatround(p_trueshot[0]*100),floatround(p_trueshot[1]*100),floatround(p_trueshot[2]*100))
		}
		else {
			client_cmd(id,"echo You must select a race before viewing the skills information!")
			return PLUGIN_HANDLED
		}
	        if (p_skills[id][0]==1){
	                new temp[]="^n^n^nNote: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"^n\
	                            When you press the key (shift in this case) with this race, you will detonate and hopefully take a few enemies with you."
	                add(message,1023,temp)
	        }else
		if (p_skills[id][0]==2 || p_skills[id][0]==3 || p_skills[id][0]==4){
			new temp[]="^n^n^nNote: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"^n\
				    Then press the key (shift in this case) you should hear a beeping sound, this means that you are searching for a target. \
				    Once you hear the beeping sound aim your crosshair at a player and wait until it locks on. You have 5 seconds to find a target before it gives up."
			add(message,1023,temp)
		}
	#endif
	show_motd(id,message,title)
	if (saychat==1)
		return PLUGIN_CONTINUE
	return PLUGIN_HANDLED
}

public items_info(id,saychat){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	#if STEAM_POWERED
	        new message[2048]
	        new title[] = "Items Information"
	#else
		new message[1024]
		new title[] = "Items"
	#endif
	new pos = 0
	
	#if STEAM_POWERED
	      	pos += format(message[pos], 2047-pos, "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>")
	        pos += format(message[pos], 2047-pos, "The shop works in the same way as buying weapons, except you can buy anywhere.<br>\
	                                                You can hold only 1 item at a time, with the exception of the tome of experience <br>\
	                                                (you can buy as many as these as you want without losing your current item). If you <br>\
	                                                buy an item while already holding an item your previous item will be lost.<br>")
	        pos += format(message[pos], 2047-pos, "In order to buy items you must bind a key to ^"shopmenu^" for example (bind i shopmenu)<br><br>&nbsp;<br>")
	        pos += format(message[pos], 2047-pos, "Ankh of Reincarnation: If you die you will retreive your equipment the following round<br>")
	        pos += format(message[pos], 2047-pos, "Boots of Speed: Allows you to run faster<br>")
	        pos += format(message[pos], 2047-pos, "Claws of Attack +6: An additional 6 hp will be removed from the enemy on every hit<br>")
	        pos += format(message[pos], 2047-pos, "Cloak of Shadows: Makes you partially invisible, invisibility is increased when holding the knife<br>")
	        pos += format(message[pos], 2047-pos, "Mask of Death: You will receive health for every hit on the enemy<br>")
	        pos += format(message[pos], 2047-pos, "Necklace of Immunity: You will be immune to enemy ultimates<br>")
	        pos += format(message[pos], 2047-pos, "Orb of Frost: Slows your enemy down when you hit him<br>")
	        pos += format(message[pos], 2047-pos, "Periapt of Health: Receive extra health<br>")
	        pos += format(message[pos], 2047-pos, "Tome of Experience: Automatically gain experience, the item is used on purchase<br>")
	#else
		pos += format(message[pos], 1023-pos, "The shop works in the same way as buying weapons, except you can buy anywhere. You can hold only \
							1 item at a time, with the exception of the tome of experience (you can buy as many as these as \
							you want without losing your current item). If you buy an item while already holding an \
							item your previous item will be lost.^n")
		pos += format(message[pos], 1023-pos, "In order to buy items you must bind a key to ^"shopmenu^" for example (bind i shopmenu)^n^n")
		pos += format(message[pos], 1023-pos, "Ankh of Reincarnation: If you die you will retreive your equipment the following round^n")
		pos += format(message[pos], 1023-pos, "Boots of Speed: Allows you to run faster^n")
		pos += format(message[pos], 1023-pos, "Claws of Attack +6: An additional 6 hp will be removed from the enemy on every hit^n")
		pos += format(message[pos], 1023-pos, "Cloak of Shadows: Makes you partially invisible, invisibility is increased when holding the knife^n")
		pos += format(message[pos], 1023-pos, "Mask of Death: You will receive health for every hit on the enemy^n")
		pos += format(message[pos], 1023-pos, "Necklace of Immunity: You will be imune enemy ultimates^n")
		pos += format(message[pos], 1023-pos, "Orb of Frost: Slows your enemy down when you hit him^n")
		pos += format(message[pos], 1023-pos, "Periapt of Health: Receive extra health^n")
		pos += format(message[pos], 1023-pos, "Tome of Experience: Automatically gain experience, the item is used on purchase^n")
	#endif
	show_motd(id,message,title)
	if (saychat==1)
		return PLUGIN_CONTINUE
	return PLUGIN_HANDLED
}

public war3_info(id){
	console_print(id,"---- Warcraft 3 Help: Commands ----")
	console_print(id,"Client:")
        console_print(id,"war3menu - Show WarCraft3 XP Player menu")
	console_print(id,"selectskill - Allows you to select skills before the start of the next round")
	console_print(id,"changerace - Allows you to change race during the game if mp_allowchangerace is 1")
	console_print(id,"playerskills - Shows you what skills other players have chosen")
	console_print(id,"skillsinfo - Shows you what each skill does for the race you have selected")
	console_print(id,"itemsinfo - Shows you a list of items and what they do")
	console_print(id,"war3vote - Vote to switch the plugin on or off")	
	console_print(id,"Server:")
	console_print(id,"sv_warcraft3 - Enable/Disable the plugin (default 1, enabled)")
	console_print(id,"sv_allowwar3vote - Enabled/Disable voting (default 1, enabled)")
	console_print(id,"mp_allowchangerace - Allow people to change race during the game (default 0, disabled)")
	console_print(id,"mp_forceskin - Forces player to choose skin according to race (default 0, disabled)")
        console_print(id,"mp_weaponxpmodifier - gives additional XP for using certain weaker weapons (default 1, enabled)")
	console_print(id,"mp_savexp - save XP to a txt file and restore it when player reconnects (default 0)")
	console_print(id,"mp_xpmultiplier - set the level required to gain a level as a multiple (default 1.0)")
	console_print(id,"---- Warcraft 3 Help: Commands ----")
	return PLUGIN_HANDLED
}

public saywar3_info(id){
	#if STEAM_POWERED
	        new message[2048]
	        new pos = 0
	#else
		new message[1024]
		new temp[512]
	#endif
	new title[64]
	format(title,63,"Warcraft 3 Help")
	#if STEAM_POWERED
	        pos += format(message[pos], 2047-pos, "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>")
	        pos += format(message[pos], 2047-pos, "Warcraft 3 is an AMX plugin for Counter-Strike written by SpaceDude.<br>")
	        pos += format(message[pos], 2047-pos, "At the start of the game you are given a choice of 4 different races,<br>")
	        pos += format(message[pos], 2047-pos, "each race has 3 basic skills to choose from as well as an ultimate. <br>")
	        pos += format(message[pos], 2047-pos, "To gain access to these skills you must get experience by killing enemy players <br>")
	        pos += format(message[pos], 2047-pos, "and completing objectives. When you have enough XP to gain a level you will be<br>")
	        pos += format(message[pos], 2047-pos, "able to select a new skill at the end of the round or when you die.<br>")
	        pos += format(message[pos], 2047-pos, "There are a few commands you need to know in order take full advantage of the plugin.<br>&nbsp;<br>")
	        pos += format(message[pos], 2047-pos, "Client Commands:<br>")
	        pos += format(message[pos], 2047-pos, "say /selectskill - Allows you to select skills before the start of the next round<br>")
	        pos += format(message[pos], 2047-pos, "say /playerskills - Shows you what skills other players have chosen<br>")
	        pos += format(message[pos], 2047-pos, "say /skillsinfo - Shows you what each skill does for the race you have selected<br>")
	        pos += format(message[pos], 2047-pos, "say /itemsinfo - Shows you a list of items and what they do<br>")
	        pos += format(message[pos], 2047-pos, "say /level - Shows you what race, level and skills you have<br>")
	        pos += format(message[pos], 2047-pos, "say /war3menu - Show WarCraft3 XP Player menu<br>")
	#else
		temp = "Warcraft 3 is an AMX plugin for Counter-Strike written by SpaceDude.^nAt the start of the \
			game you are given a choice of 4 different races, each race has 3 basic skills to choose from \
			as well as an ultimate. To gain access to these skills you must get experience by killing \
			enemy players and completing objectives. When you have enough XP to gain a level you will be \
			able to select a new skill at the end of the round or when you die. "
		add(message,1023,temp)
		temp = "There are a few commands you need to know \
			in order take full advantage of the plugin.^n^nClient Commands:^n\
			say /selectskill - Allows you to select skills before the start of the next round^n\
			say /changerace - Allows you to change race if mp_allowchangerace is 1^n\
			say /playerskills - Shows you what skills other players have chosen^n"
		add(message,1023,temp)
		temp = "say /skillsinfo - Shows you what each skill does for the race you have selected^n\
			say /itemsinfo - Shows you a list of items and what they do^n\
			say /level - Shows you what race, level and skills you have^n\
			say /war3vote - Vote to switch the plugin on and off"
		add(message,1023,temp)
	#endif
	show_motd(id,message,title)
	return PLUGIN_CONTINUE
}



#if OPT_RESETSKILLS
public resetskills(id){
        if (warcraft3==false)
                return PLUGIN_CONTINUE

	if (resetskill[id]) {
                set_hudmessage(200, 100, 0, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
                show_hudmessage(id,"Your skills will NOT be reset next round")
		resetskill[id]=false
	}else{
                set_hudmessage(200, 100, 0, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
                show_hudmessage(id,"Your skills will be reset next round")
		resetskill[id]=true	
	}
        return PLUGIN_HANDLED
}
#endif



public ultimate(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
		
	#if NON_ULTIMATE_VIP
		if( id == vipID ){
			set_hudmessage(0, 255, 0, -1.0, -0.4, 0, 1.5, 6.7, 0.5, 0.5,5)
			show_hudmessage(id,"VIP's don't have Ultimate Abilities")
			return PLUGIN_HANDLED				
		}	
	#endif

	#if TEST_MODE
		ultimateused[id] = false
	#endif
	
	#if ULTIMATE_READY_ICON
		if ( p_skills[id][4]==1 && !ultimateused[id]){
			icon_controller(id, 0, 0,0, 0 ) 			
		}
	#endif


	if (is_user_alive(id)){
		if (p_skills[id][0]==1 && p_skills[id][4]==1 && !ultimateused[id]){
			#if WARN_SUICIDERS
				if( suicideAttempt[id] ){
					user_kill(id,1)					
				}else{
					suicideAttempt[id] = 1
					set_hudmessage(178, 14, 41, -1.0, -0.4, 1, 0.5, 1.7, 0.2, 0.2,5);
					show_hudmessage(id,"Suicide Bomb Armed^nPress Again To Detonate");					
				
					#if ULTIMATE_READY_ICON
						icon_controller(id, 1, 255,170, 0 ) 							
					#endif			
				}
			#else
				user_kill(id,1)
			#endif
		}

		if (p_skills[id][0]==2 && p_skills[id][4]==1 &&  !ultimateused[id] && !stunned[id]  ){	// Teleport
			
			#if BLINK_HUMAN_ULTIMATE
				/*
				native get_user_origin(index, origin[3], mode = 0); 
				 Gets origin from player.
				Modes:
				0 - current position.
				1 - position from eyes (weapon aiming).
				2 - end position from player position.
				3 - end position from eyes (hit point for weapon). <--- Hello hello
				4 - position of last bullet hit (only CS).  
				*/						
				
				new oldLocation[3]
				new newLocation[3]
				new parm[3]
				parm[0] = id	
				
				// This will cause Teleportation Blueness
				message_begin(MSG_ONE, gmsgFade, {0,0,0}, id) // use the magic #1 for "one client"  
				write_short(1<<12) // fade lasts this long duration  
				write_short(1<<8) // fade lasts this long hold time  
				write_short(1<<0) // fade type IN 
				write_byte(76) // fade red  
				write_byte(163) // fade green  
				write_byte(223) // fade blue    
				write_byte(200) // fade alpha    
				message_end() 
						
				get_user_origin(id, oldLocation)
				oldLocation[2] += 30 // Make sure it doesn't teleport you back into the ground.
				savedOldLoc[id] = oldLocation					
				get_user_origin(id, newLocation, 3)				
				
				//client_print(id,print_chat,"origin: x:%i y:%i z%i",oldLocation[0],oldLocation[1],oldLocation[2])
				//client_print(id,print_chat,"look at: x:%i y:%i z%i",newLocation[0],newLocation[1],newLocation[2])
	
				
				if( (newLocation[0] - oldLocation[0] ) > 0 ){
					newLocation[0] -= 50
				}else{
					newLocation[0] += 50
				}
				
				
				if( (newLocation[1] - oldLocation[1] ) > 0 ){
					newLocation[1] -= 50
				}else{
					newLocation[1] += 50
				}
				
				
				newLocation[2] += 40				
				
				savedNewLoc[id] = newLocation
				
				//client_print(id,print_chat,"arrive at: x:%i y:%i z%i",newLocation[0],newLocation[1],newLocation[2])
				
				if (file_exists("sound/warcraft3/MassTeleportTarget.wav")==1)
					emit_sound(id,CHAN_STATIC, "warcraft3/MassTeleportTarget.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
				else
					emit_sound(id,CHAN_STATIC, "x/x_shoot1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				// blast circles
				message_begin( MSG_PAS, SVC_TEMPENTITY, oldLocation )
				write_byte( TE_BEAMCYLINDER )
				write_coord( oldLocation[0])
				write_coord( oldLocation[1])
				write_coord( oldLocation[2] + 10)
				write_coord( oldLocation[0])
				write_coord( oldLocation[1])
				write_coord( oldLocation[2] + 10 + TELEPORT_RADIUS)
				write_short( m_iSpriteTexture )
				write_byte( 0 ) // startframe
				write_byte( 0 ) // framerate
				write_byte( 3 ) // life
				write_byte( 60 )  // width
				write_byte( 0 )	// noise
				write_byte( 255 )  // red
				write_byte( 255 )  // green
				write_byte( 255 )  // blue
				write_byte( 255 ) //brightness
				write_byte( 0 ) // speed
				message_end()
				
				// Stop bomb planting...
				client_cmd(id,"-use")
				
				// Test sending player, should work most of the time.
				set_user_origin( id, newLocation)		
								
				
				// Check if Blink laned you in a wall, if so, abort
				parm[1] = 1
				set_task(0.1, "blink_controller", 10098, parm, 2)
								
				ultimateused[id]=true
				
				//client_print(id,print_chat,"origin: x:%i y:%i z%i",oldLocation[0],oldLocation[1],oldLocation[2])
				//client_print(id,print_chat,"blink to, x:%i y:%i z%i",newLocation[0],newLocation[1],newLocation[2])
	
				
				if (file_exists("sound/warcraft3/MassTeleportTarget.wav")==1)
					emit_sound(id,CHAN_STATIC, "warcraft3/MassTeleportTarget.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
				else
					emit_sound(id,CHAN_STATIC, "x/x_shoot1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
				
				
				message_begin( MSG_PAS, SVC_TEMPENTITY, newLocation )
				write_byte( TE_BEAMCYLINDER )
				write_coord( newLocation[0])
				write_coord( newLocation[1])
				write_coord( newLocation[2] + 90)
				write_coord( newLocation[0])
				write_coord( newLocation[1])
				write_coord( newLocation[2] + 90 + TELEPORT_RADIUS)
				write_short( m_iSpriteTexture )
				write_byte( 0 ) // startframe
				write_byte( 0 ) // framerate
				write_byte( 3 ) // life
				write_byte( 60 )  // width
				write_byte( 0 )	// noise
				write_byte( 255 )  // red
				write_byte( 255 )  // green
				write_byte( 255 )  // blue
				write_byte( 255 ) //brightness
				write_byte( 0 ) // speed
				message_end()			
					
			#else
				new i
				new j
				new tmp
				new numberofplayers
				new targetid
				new targetid2
				new teamname[32]
				new distancebetween
				new distancebetween2
				new origin[3]
				new targetorigin[3]
				new targetorigin2[3]
				get_user_team(id, teamname, 31)
				get_players(teleportid[id],numberofplayers,"ae",teamname)
				get_user_origin(id,origin)
				for (i=0; i<numberofplayers; i++) {	// Sort by closest to furthest
					for (j=i+1; j<numberofplayers; j++){
						targetid=teleportid[id][i]
						get_user_origin(targetid,targetorigin)
						distancebetween = get_distance(origin,targetorigin)
						targetid2=teleportid[id][j]
						get_user_origin(targetid2,targetorigin2)
						distancebetween2 = get_distance(origin,targetorigin2)
						if (distancebetween2 < distancebetween && targetid2!=id) {	// Don't put self first
							tmp = teleportid[id][i]
							teleportid[id][i] = teleportid[id][j]
							teleportid[id][j] = tmp
						}
						else if (targetid==id) {	// Put self last
							tmp = teleportid[id][i]
							teleportid[id][i] = teleportid[id][j]
							teleportid[id][j] = tmp
						}
					}
				}
	
				if (numberofplayers > 9)
					numberofplayers=9
				else
					--numberofplayers	// Remove self from list
				if (numberofplayers){
					remove_task(666+id)
					teleportmenu[id]=true
					new menuparm[2]
					menuparm[0]=id
					menuparm[1]=numberofplayers
					telemenu(menuparm)
				}
				else{
					set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
					show_hudmessage(id,"No valid teleport targets found!")
				}
			#endif
		}

		else if (!issearching[id] && p_skills[id][0]==3 && p_skills[id][4]==1 && !ultimateused[id]){
			new parm[2]
			parm[0]=id
			parm[1]=ULTIMATESEARCHTIME
			lightsearchtarget(parm)		// Chain Lightning
		}

		else if (!issearching[id] && p_skills[id][0]==4 && p_skills[id][4]==1 && !ultimateused[id]){
			new parm[2]
			parm[0]=id
			parm[1]=ULTIMATESEARCHTIME
			searchtarget(parm)		// Entangle Roots
		}
	}

	return PLUGIN_HANDLED
}



#if BLINK_HUMAN_ULTIMATE

	public blink_controller(parm[2]){
		new id = parm[0]	 
		new newLocation[3]
		new curLocation[3]
		new oldLocation[3]
		new origin[3]		
			
		if( parm[1] == 1){	// Teleport failure check and unsticker
			new coolparm[1]
			coolparm[0] = id
			
			newLocation = savedNewLoc[id]
			get_user_origin(id, curLocation, 0)
			//client_print(id,print_chat,"blinked to: x:%i y:%i z%i",newLocation[0],newLocation[1],newLocation[2])
			//client_print(id,print_chat,"currently: x:%i y:%i z%i",curLocation[0],curLocation[1],curLocation[2])
		
			
			if( newLocation[2] == curLocation[2] ){ // Teleportation Failure
				
				oldLocation = savedOldLoc[id]
				//client_print(id,print_chat,"sent back to: x:%i y:%i z%i",oldLocation[0],oldLocation[1],oldLocation[2])						
				
				//set_hudmessage(red, green, blue, Float:x=-1.0, Float:y=1.45, effects=0, Float:fxtime=6.0, Float:holdtime=12.0, Float:fadeintime=0.1, Float:fadeouttime=0.2,channel=4);
				set_hudmessage(255, 255, 10, -1.0, -0.4, 1, 0.5, RETRY_COOLDOWN, 0.2, 0.2,5);
				show_hudmessage(id,"Teleport Failed^nBad Destination");
				set_user_origin( id, oldLocation)	
								
				parm[1] = 0
				set_task(0.1, "blink_controller", 0, parm, 2) 
				set_task(RETRY_COOLDOWN,"cooldown",50 + id,coolparm,1)
				
				#if ULTIMATE_READY_ICON
					icon_controller(id, 1, 0,0, 255 ) 					
				#endif	
				
			}else{ // Teleportation Success if not near player with Ankh
				
				new teamname[32]
				new players[32]
				new numplayers
				new targetorigin[3]
				new targetid
				new bool:teleportSuccess = true

				get_user_origin(id, origin)
				get_user_team(id, teamname, 31)
				
				if( contain(teamname, "CT") != -1 ){		
							
					get_players(players, numplayers, "ae", "TERRORIST")
				}else{					
					get_players(players, numplayers, "ae", "CT")
				}					
				
			
				for (new i=0; i<numplayers; ++i){		
					targetid=players[i]
					if( playeritem[targetid] == IMMUNITY ){
						
						get_user_origin(targetid, targetorigin)
						if (get_distance(origin, targetorigin)<=BLINK_RADIUS){	
																				
							oldLocation = savedOldLoc[id]
							//client_print(id,print_chat,"sent back to: x:%i y:%i z%i",oldLocation[0],oldLocation[1],oldLocation[2])						
							
							//set_hudmessage(red, green, blue, Float:x=-1.0, Float:y=1.45, effects=0, Float:fxtime=6.0, Float:holdtime=12.0, Float:fadeintime=0.1, Float:fadeouttime=0.2,channel=4);
							set_hudmessage(255, 255, 10, -1.0, -0.4, 1, 0.5, RETRY_COOLDOWN, 0.2, 0.2,5);
							show_hudmessage(id,"Teleport Failed^nEnemy Has Immunity");
							set_user_origin( id, oldLocation)							
							
							parm[1] = 0
							set_task(0.1, "blink_controller", 0, parm, 2) 
							set_task(RETRY_COOLDOWN,"cooldown",50 + id,coolparm,1)
							teleportSuccess = false	
							#if ULTIMATE_READY_ICON
								icon_controller(id, 1, 0,0, 255 ) 
							#endif							
						}
					}
				}
				
				if( teleportSuccess ){
					parm[1] = 2				
					set_task(TELEPORT_COOLDOWN,"cooldown",50 + id,coolparm,1)		
					// Call phase 2 of the blindness
					set_task(0.6, "blink_controller", 0, parm, 2)
									
				
					// Sprays white bubbles everywhere
					get_user_origin(id,origin)
					message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
					write_byte( TE_SPRITETRAIL )
					write_coord( origin[0])
					write_coord( origin[1])
					write_coord( origin[2] + 40)
					write_coord( origin[0])
					write_coord( origin[1])
					write_coord( origin[2])
					write_short( flaresprite )
					write_byte( 30 ) // count
					write_byte( 10 ) // life
					write_byte( 1 )  // scale
					write_byte( 50 )	// velocity
					write_byte( 10 )  // randomness in velocity
					message_end()	
				}					
			}	
		}else if( parm[1] == 2) {	// Make the Teleport Blues hold..
			
		    	message_begin(MSG_ONE, gmsgFade, {0,0,0}, id) // use the magic #1 for "one client" 
		     	write_short(1<<0) // fade lasts this long duration 
		    	write_short(1<<0) // fade lasts this long hold time 
		    	write_short(1<<2) // fade type HOLD 
		  	write_byte(76) // fade red  
			write_byte(163) // fade green  
			write_byte(223) // fade blue    
			write_byte(200) // fade alpha   
			message_end() 
			parm[1] = 0
		     	set_task(3.0, "blink_controller", 0, parm, 2)
		      
		}else{		
			// Teleport Blueness goes away
			message_begin(MSG_ONE, gmsgFade, {0,0,0}, id) // use the magic #1 for "one client"  
			write_short(1<<12) // fade lasts this long duration  
			write_short(1<<8) // fade lasts this long hold time  
			write_short(1<<1) // fade type OUT 
			write_byte(76) // fade red  
			write_byte(163) // fade green  
			write_byte(223) // fade blue    
			write_byte(200) // fade alpha   
			message_end() 
		}						
		return PLUGIN_CONTINUE
	}
	
#else

	public set_target(id,key){		// Teleport
		new targetid = teleportid[id][key]
		remove_task(666+id)
		teleportmenu[id]=false
		client_cmd(id,"slot10")
		if (is_user_alive(id) && is_user_alive(targetid) && get_user_maxspeed(id)>10 && get_user_team(id)==get_user_team(targetid) && key!=9 && !ultimateused[id] && !endround){
			ultimateused[id]=true
			new waitparm[6]
			waitparm[0]=id
			waitparm[1]=targetid
			waitparm[5]=floatround(get_user_maxspeed(id))
			set_user_maxspeed(id,1.0)
			stunned[id]=true
			telewaitstop(waitparm)
			new cooldownparm[1]
			cooldownparm[0]=id
			set_task(TELEPORT_COOLDOWN,"cooldown",50+id,cooldownparm,1)
		}
	
		return PLUGIN_HANDLED
	}



	public telemenu(parm[2]){
		new id = parm[0]
		new numberofplayers = parm[1]
		new targetid
		new name[32]
		new origin[3]
		new targetorigin[3]
		new distancebetween
		new temp[64]
		new i
		new keys = (1<<9)
	
		new menu_body[512]="\yTeleport to:\w^n"
		get_user_origin(id,origin)
		for (i = 0; i < numberofplayers; ++i){
			targetid=teleportid[id][i]
			get_user_name(targetid,name,31)
			get_user_origin(targetid,targetorigin)
			distancebetween = get_distance(origin,targetorigin)
			if (is_user_alive(targetid)){
				format(temp,63,"^n\w%d. %s (\y%dm\w)",i+1,name,distancebetween/40)
				keys |= (1<<i)
			}
			else
				format(temp,63,"^n\d%d. %s",i+1,name)
			add(menu_body,255,temp)
		}
		format(temp,63,"^n^n\w0. Cancel")
		add(menu_body,255,temp)
		show_menu(id,keys,menu_body,-1)
	
		new menuparm[2]
		menuparm[0]=id
		menuparm[1]=numberofplayers
		if (teleportmenu[id])
			set_task(1.0,"telemenu",666+id,parm,2)
		return PLUGIN_HANDLED
	}


	
	public telewaitstop(parm[6]){
		new id=parm[0]
		new origin[3]
		get_user_origin(id, origin)
		if (origin[0]==parm[2] && origin[1]==parm[3] && origin[2]==parm[4]){
			new normalspeed = parm[5]
			new resetparm[2]
			resetparm[0]=id
			resetparm[1]=normalspeed
			set_task(0.6,"reset_maxspeed",28,resetparm,2)
			new teleportparm[6]
			teleportparm[0]=parm[0]
			teleportparm[1]=parm[1]
			teleport(teleportparm)
		}
		else{
			parm[2]=origin[0]
			parm[3]=origin[1]
			parm[4]=origin[2]
			set_task(0.1,"telewaitstop",29,parm,6)
		}
		return PLUGIN_CONTINUE
	}
	
	public teleport(parm[6]){		// Teleport
		new id=parm[0]
		new target=parm[1]
		new origin[3]
		get_user_origin(id,origin)
		new targetorigin[3]
		targetorigin[0]=parm[3]
		targetorigin[1]=parm[4]
		targetorigin[2]=parm[5]
	
		if (parm[2]==0){
	
			if (file_exists("sound/warcraft3/MassTeleportTarget.wav")==1)
				emit_sound(id,CHAN_STATIC, "warcraft3/MassTeleportTarget.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			else
				emit_sound(id,CHAN_STATIC, "x/x_shoot1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	
			if (p_skills[id][1]==0 && playeritem[id]!=CLOAK){	// Don't glow if player is invisible
				set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransAdd,255)
			}
			// blast circles
			message_begin( MSG_PAS, SVC_TEMPENTITY, origin )
			write_byte( TE_BEAMCYLINDER )
			write_coord( origin[0])
			write_coord( origin[1])
			write_coord( origin[2] + 10)
			write_coord( origin[0])
			write_coord( origin[1])
			write_coord( origin[2] + 10 + TELEPORT_RADIUS)
			write_short( m_iSpriteTexture )
			write_byte( 0 ) // startframe
			write_byte( 0 ) // framerate
			write_byte( 3 ) // life
			write_byte( 60 )  // width
			write_byte( 0 )	// noise
			write_byte( 255 )  // red
			write_byte( 255 )  // green
			write_byte( 255 )  // blue
			write_byte( 255 ) //brightness
			write_byte( 0 ) // speed
			message_end()
	
			get_user_origin(target,targetorigin)
	
			if (file_exists("sound/warcraft3/MassTeleportTarget.wav")==1)
				emit_sound(target,CHAN_STATIC, "warcraft3/MassTeleportTarget.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			else
				emit_sound(target,CHAN_STATIC, "x/x_shoot1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	
			message_begin( MSG_PAS, SVC_TEMPENTITY, origin )
			write_byte( TE_BEAMCYLINDER )
			write_coord( targetorigin[0])
			write_coord( targetorigin[1])
			write_coord( targetorigin[2] + 90)
			write_coord( targetorigin[0])
			write_coord( targetorigin[1])
			write_coord( targetorigin[2] + 90 + TELEPORT_RADIUS)
			write_short( m_iSpriteTexture )
			write_byte( 0 ) // startframe
			write_byte( 0 ) // framerate
			write_byte( 3 ) // life
			write_byte( 60 )  // width
			write_byte( 0 )	// noise
			write_byte( 255 )  // red
			write_byte( 255 )  // green
			write_byte( 255 )  // blue
			write_byte( 255 ) //brightness
			write_byte( 0 ) // speed
			message_end()
	
			parm[3]=targetorigin[0]
			parm[4]=targetorigin[1]
			parm[5]=targetorigin[2]
		}
	
		if (parm[2]==1){
			targetorigin[2]+=80
			if (p_skills[id][1]==0 && playeritem[id]!=CLOAK){	// Don't glow if player is invisible
				set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,128)
			}
			set_user_origin(id, targetorigin)
			message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
			write_byte( TE_SPRITETRAIL )
			write_coord( origin[0])
			write_coord( origin[1])
			write_coord( origin[2] + 40)
			write_coord( origin[0])
			write_coord( origin[1])
			write_coord( origin[2])
			write_short( flaresprite )
			write_byte( 30 ) // count
			write_byte( 10 ) // life
			write_byte( 1 )  // scale
			write_byte( 50 )	// velocity
			write_byte( 10 )  // randomness in velocity
			message_end()
			new fadeinparm[3]
			fadeinparm[0]=id
			fadeinparm[1]=3
			fadeinparm[2]=targetorigin[2]
			teleportfadein(fadeinparm)
		}
		++parm[2]
		if (parm[2]<2)
			set_task(0.3,"teleport",30,parm,6)
		return PLUGIN_CONTINUE
	}
	
	public teleportfadein(parm[3]){
		new id = parm[0]
		if (parm[1]==3 && p_skills[id][1]==0 && playeritem[id]!=CLOAK)	// Don't glow if player is invisible
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,170)
		if (parm[1]==2 && p_skills[id][1]==0 && playeritem[id]!=CLOAK)	// Don't glow if player is invisible
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,212)
		if (parm[1]==1){
			if (p_skills[id][1]==0 && playeritem[id]!=CLOAK){	// Don't glow if player is invisible
				set_user_rendering(id)
			}
			new origin[3]
			get_user_origin(id,origin)
			if (origin[2]==parm[2]){
				origin[2]-=80
				new unstickparm[4]
				unstickparm[0]=id
				unstickparm[1]=origin[0]
				unstickparm[2]=origin[1]
				unstickparm[3]=origin[2]
				unstick(unstickparm)
			}
		}
		--parm[1]
		if (parm[1]>0)
			set_task(0.1,"teleportfadein",31,parm,3)
		return PLUGIN_CONTINUE
	}
	
	public unstick(parm[4]){
		new id=parm[0]
		new origin[3]
		new targetorigin[3]
		origin[0]=parm[1]
		origin[1]=parm[2]
		origin[2]=parm[3]
		new players[32]
		new numberofplayers
		get_players(players, numberofplayers)
		new i
		new playerid
		new bool:clear
		clear = true
		new distancebetween
		new tolerance = 100
		for (i = 0; i < numberofplayers; ++i){
			playerid=players[i]
			get_user_origin(playerid,targetorigin)
			distancebetween = get_distance(origin,targetorigin)
			if (distancebetween<tolerance && is_user_alive(playerid) && playerid!=id){
				clear=false
			}
		}
		if (clear){
			set_user_origin(id,origin)
		}
		else{
			set_task(0.1,"unstick",32,parm,4)
		}
		return PLUGIN_CONTINUE
	}
	// Perhaps you got lost, this ends the Teleport Block
	// This is the end of the ELSE part of it, which is the OLD Teleport Code.
#endif		



public searchtarget(parm[2]){
	new id = parm[0]
	new enemy, body
	get_user_aiming(id,enemy,body)
	if ( 0<enemy<=32 && !stunned[enemy] && get_user_team(id)!=get_user_team(enemy) && playeritem[enemy]!=IMMUNITY){
		issearching[id]=false
		ultimateused[id]=true
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
		write_byte( TE_BEAMFOLLOW );
		write_short(enemy);	// entity
		write_short(m_iTrail );	// model
		write_byte( 10 ); // life
		write_byte( 5 );  // width
		write_byte( 10 );	// r, g, b
		write_byte( 108 );	// r, g, b
		write_byte( 23 );	// r, g, b
		write_byte( 255 );	// brightness
		message_end();  // move PHS/PVS data sending into here (SEND_ALL, SEND_PVS, SEND_PHS)

		if (file_exists("sound/warcraft3/EntanglingRootsTarget1.wav")==1)
			emit_sound(id,CHAN_ITEM, "warcraft3/EntanglingRootsTarget1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		else
			emit_sound(id,CHAN_ITEM, "weapons/cbar_hitbod3.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)

		
		new waitparm[6]
		waitparm[0]=enemy
		waitparm[1]=100
		waitparm[5]=floatround(get_user_maxspeed(enemy))
		set_user_maxspeed(enemy,1.0)			
		waitstop(waitparm)
		
		stunned[enemy]=true
		new cooldownparm[1]
		cooldownparm[0]=id
		set_task(ENTANGLEROOTS_COOLDOWN,"cooldown",50+id,cooldownparm,1)		
	}
	else{
		issearching[id]=true
		new counter = parm[1]
		while (counter >= 0){
			counter -= 10
			if (counter==0)
				emit_sound(id,CHAN_ITEM, "turret/tu_ping.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		}			
		--parm[1]
		if (parm[1]>0 && get_user_health(id)>0){
			set_task(0.1,"searchtarget",21,parm,2)
		}else{
			issearching[id]=false
			
			#if ULTIMATE_READY_ICON
				icon_controller(id, 1, 0, 255, 0 ) 	
			#endif	
		}
	}
	return PLUGIN_CONTINUE
}

#if ULTIMATE_READY_ICON
	icon_controller( id, status, r,g,b ){
		
		message_begin( MSG_ONE, gmsgIcon, {0,0,0}, id ) 
		write_byte( status ) // status 	0 = OFF, 1 = HOLD, 2 = FLASH
		if( p_skills[id][0] == 1 ){
			write_string( "dmg_rad" ) // undead sprite name 	
		}else if( p_skills[id][0] == 2 ){
			write_string( "item_longjump" ) // human sprite name 	
		}else if( p_skills[id][0] == 3 ){
			write_string( "dmg_shock" ) // orc sprite name 	
		}else{
			write_string( "dmg_bio" ) // night elf sprite name 	
		}		
		write_byte( r ) // red 
		write_byte( g ) // green 
		write_byte( b ) // blue 
		message_end() 	
	
		return PLUGIN_CONTINUE
	}
#endif

public waitstop(parm[6]){
	new id=parm[0]
	new origin[3]
	get_user_origin(id, origin)
	
	// This check is necessary, because we don't want to draw rings until the player hits ground
	if (origin[0]==parm[2] && origin[1]==parm[3] && origin[2]==parm[4]){
		new normalspeed = parm[5]
		new resetparm[2]
		resetparm[0]=id
		resetparm[1]=normalspeed
		set_task(10.0,"reset_maxspeed",11022,resetparm,2)
		new entangleparm[2]
		entangleparm[0]=parm[0]
		entangleparm[1]=parm[1]
		entangle(entangleparm)
	}
	else{
		parm[2]=origin[0]
		parm[3]=origin[1]
		parm[4]=origin[2]
		set_task(0.1,"waitstop",23,parm,6)
	}
	return PLUGIN_CONTINUE
}


public entangle(parm[2]){	// Entangle Roots (DOESN'T WORK ON BOTS)
	new id=parm[0]
	new life=parm[1]
	new radius = 20
	new counter = 0
	new origin[3]
	new x1
	new y1
	new x2
	new y2
	get_user_origin(id,origin)

	if (file_exists("sound/warcraft3/EntanglingRootsTarget1.wav")==1)
		emit_sound(id,CHAN_STATIC, "warcraft3/EntanglingRootsTarget1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	else
		emit_sound(id,CHAN_STATIC, "weapons/electro5.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)

	while (counter<=7){
		if (counter==0 || counter==8)
			x1= -radius
		else if (counter==1 || counter==7)
			x1= -radius*100/141
		else if (counter==2 || counter==6)
			x1= 0
		else if (counter==3 || counter==5)
			x1= radius*100/141
		else if (counter==4)
			x1= radius
		if (counter<=4)
			y1 = sqrt(radius*radius-x1*x1)
		else
			y1 = -sqrt(radius*radius-x1*x1)
		++counter
		if (counter==0 || counter==8)
			x2= -radius
		else if (counter==1 || counter==7)
			x2= -radius*100/141
		else if (counter==2 || counter==6)
			x2= 0
		else if (counter==3 || counter==5)
			x2= radius*100/141
		else if (counter==4)
			x2= radius
		if (counter<=4)
			y2 = sqrt(radius*radius-x2*x2)
		else
			y2 = -sqrt(radius*radius-x2*x2)
		new height=16+2*counter
		while (height > -40){

			message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
			write_byte( 0 )
			write_coord(origin[0]+x1)
			write_coord(origin[1]+y1)
			write_coord(origin[2]+height)
			write_coord(origin[0]+x2)
			write_coord(origin[1]+y2)
			write_coord(origin[2]+height+2)
			write_short(iBeam4)	// model
			write_byte( 0 ) // start frame
			write_byte( 0 ) // framerate
			write_byte( life ) // life
			write_byte( 10 )  // width
			write_byte( 5 )	// noise
			write_byte( 10 )	// r, g, b
			write_byte( 108 )	// r, g, b
			write_byte( 23 )	// r, g, b
			write_byte( 255 )	// brightness
			write_byte( 0 )		// speed
			message_end()

			height -= 16
		}

	}
	return PLUGIN_CONTINUE
}

public lightsearchtarget(parm[2]){
	new id = parm[0]
	new enemy, body
	get_user_aiming(id,enemy,body)
	if ( 0<enemy<=32 && get_user_team(id)!=get_user_team(enemy) && playeritem[enemy]!=IMMUNITY){
		ultimateused[id]=true
		new linewidth = 80
		new damage = LIGHTNING_DAMAGE
		issearching[id]=false
		lightningeffect(id,enemy,linewidth,damage,id)
		new lightparm[4]
		lightparm[0]=enemy
		lightparm[1]=damage
		lightparm[2]=linewidth
		lightparm[3]=id
		set_task(0.2,"lightningnext",24,lightparm,4)
		new cooldownparm[1]
		cooldownparm[0]=id
		set_task(CHAINLIGHTNING_COOLDOWN,"cooldown",50+id,cooldownparm,1)
	}
	else{
		issearching[id]=true
		new counter = parm[1]
		while (counter >= 0){
			counter -= 10
			if (counter==0)
				emit_sound(id,CHAN_ITEM, "turret/tu_ping.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		}
		--parm[1]	
		if (parm[1]>0 && get_user_health(id)>=0){
			set_task(0.1,"lightsearchtarget",26,parm,2)
		}else{
			issearching[id]=false
			
			#if ULTIMATE_READY_ICON
				icon_controller(id, 1, 255, 255, 0 ) 					
			#endif	
		}	
	}
	return PLUGIN_CONTINUE
}

public lightningnext(parm[4]){		// Chain Lightning
	new id=parm[0]
	new caster=parm[3]
	new origin[3]
	get_user_origin(id, origin)
	new players[32]
	new numberofplayers
	new teamname[32]
	get_user_team(id, teamname, 31)
	get_players(players, numberofplayers,"ae",teamname)
	new i
	new targetid = 0
	new distancebetween = 0
	new targetorigin[3]
	new damage = parm[1]*2/3
	new linewidth = parm[2]*2/3
	new closestdistance = 0
	new closestid = 0
	for (i = 0; i < numberofplayers; ++i){
		targetid=players[i]
		if (get_user_team(id)==get_user_team(targetid) && is_user_alive(targetid)){
			get_user_origin(targetid,targetorigin)
			distancebetween=get_distance(origin,targetorigin)
			if (distancebetween < LIGHTNING_RANGE && !lightninghit[targetid] && playeritem[targetid]!=IMMUNITY){
				if (distancebetween < closestdistance || closestid==0){
					closestdistance = distancebetween
					closestid = targetid
				}
			}
		}
	}

	if (closestid){
		lightningeffect(id,closestid,linewidth,damage,caster)
		parm[0]=targetid
		parm[1]=damage
		parm[2]=linewidth
		parm[3]=caster
		set_task(0.2,"lightningnext",27,parm,4)
	}
	else{
		for (i = 0; i < numberofplayers; ++i){
			targetid=players[i]
			lightninghit[targetid]=false
		}
	}
	return PLUGIN_CONTINUE
}

public lightningeffect(id,targetid,linewidth,damage,caster){

	new bool:targetdied
	new bool:targetdead
	new temp
	lightninghit[targetid]=true
	targetdead=false

	if (is_user_alive(targetid))
		targetdead=false
	else
		targetdead=true
	
	
	
	if (get_user_health(targetid)>500){		// Evasion kill
		if (get_user_health(targetid)-damage<=ELF_EVADE_ADJ){
			set_user_health(targetid, -1)
			targetdied=true
			
		}
	}
	else if (get_user_health(targetid)-damage<=0){
		targetdied=true		
	}

	set_user_health(targetid,get_user_health(targetid)-damage)
	
	#if WAR3STATS			
		dmgStat[id][targetid] += damage
		hitStat[id][targetid]++
	#endif
	
		
	temp = get_user_armor(targetid)
	if (temp - damage <= 0){
		set_user_armor(targetid,0)
	}else{
		temp -= random_num(1, damage-5)
		if( temp > 0 )
			set_user_armor(targetid,temp)
		else 
			set_user_armor(targetid,0)
	}

	if (targetdied && !targetdead){
		set_user_frags(caster, get_user_frags(caster)+1)
		set_user_frags(targetid, get_user_frags(targetid)+1)
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(caster)
		write_byte(targetid)
		write_byte(0)
		write_string(race3skill[3])
		message_end()
		playerxp[caster]+=xpgiven[p_level[targetid]]
		#if WAR3STATS
			xpStat[caster][targetid] += xpgiven[p_level[targetid]]
		#endif
		#if WAR3_MYSQL_TOP15	
			skillStat[id] += 1		
		#endif
		displaylevel(caster, 1)
	}

	message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
	write_byte( TE_BEAMENTS );
	write_short(id);	// start entity
	write_short(targetid);	// entity
	write_short(lightning );	// model
	write_byte( 0 ); // starting frame
	write_byte( 15 );  // frame rate
	write_byte( 10 );  // life
	write_byte( linewidth );  // line width
	write_byte( 10 );  // noise amplitude
	write_byte( 255 );	// r, g, b
	write_byte( 255 );	// r, g, b
	write_byte( 255 );	// r, g, b
	write_byte( 255 );	// brightness
	write_byte( 0 );	// scroll speed
	message_end();

	new origin[3]
	get_user_origin(targetid,origin)

	message_begin( MSG_BROADCAST, SVC_TEMPENTITY );
	write_byte( TE_ELIGHT );
	write_short(targetid);	// entity
	write_coord(origin[0])  // initial position
	write_coord(origin[1])  // initial position
	write_coord(origin[2])  // initial position
	write_coord(100)	  // radius
	write_byte( 255 );	// r, g, b
	write_byte( 255 );	// r, g, b
	write_byte( 255 );	// r, g, b
	write_byte( 10 );  // life
	write_coord(0)	// decay rate
	message_end();

	if (file_exists("sound/warcraft3/LightningBolt.wav")==1)
		emit_sound(id,CHAN_ITEM, "warcraft3/LightningBolt.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	else
		emit_sound(id,CHAN_ITEM, "weapons/gauss2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)

	return PLUGIN_CONTINUE
}

public cooldown(parm[1]){
	new id = parm[0]
		
	if( is_user_alive( id )  && p_skills[id][4]){	// Only active if person is alive and has ultimate
		ultimateused[id]=false
		#if ULTIMATE_READY_SOUND			
			emit_sound(id,CHAN_ITEM, "fvox/power_restored.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		#endif
		#if ULTIMATE_READY_ICON
			if( p_skills[id][0] == 1 ){
				icon_controller(id, 2, 150,0, 0 ) 
			}else if( p_skills[id][0] == 2 ){
				icon_controller(id, 1, 0, 0, 255 ) 
			}else if( p_skills[id][0] == 3 ){
				icon_controller(id, 1, 255, 255, 0 ) 
			}else{
				icon_controller(id, 1, 0, 255, 0 ) 
			}
		#endif
		
		
	}
	return PLUGIN_CONTINUE
}


public apacheexplode(parm[2]){		// Suicide Bomber
	new id = parm[0]
	new origin[3]
	get_user_origin(id,origin)

	// random explosions
	message_begin( MSG_PVS, SVC_TEMPENTITY, origin )
	write_byte( TE_EXPLOSION) // This just makes a dynamic light now
	write_coord( origin[0] + random_num( -100, 100 ))
	write_coord( origin[1] + random_num( -100, 100 ))
	write_coord( origin[2] + random_num( -50, 50 ))
	write_short( g_sModelIndexFireball )
	write_byte( random_num(0,20) + 20  ) // scale * 10
	write_byte( 12  ) // framerate
	write_byte( TE_EXPLFLAG_NONE )
	message_end()

	// lots of smoke
	message_begin( MSG_PVS, SVC_TEMPENTITY, origin )
	write_byte( TE_SMOKE )
	write_coord( origin[0] + random_num( -100, 100 ))
	write_coord( origin[1] + random_num( -100, 100 ))
	write_coord( origin[2] + random_num( -50, 50 ))
	write_short( g_sModelIndexSmoke )
	write_byte( 60 ) // scale * 10
	write_byte( 10  ) // framerate
	message_end()

	new players[32]
	new numberofplayers
	get_players(players, numberofplayers)
	new i
	new targetid
	new distancebetween
	new targetorigin[3]
	new damage
	new multiplier
	new bool:targetdied
	new bool:targetdead
	targetdied = false
	for (i = 0; i < numberofplayers; ++i){
		targetdied=false
		targetid=players[i]
		get_user_origin(targetid,targetorigin)
		distancebetween=get_distance(origin,targetorigin)
		if (distancebetween < EXPLOSION_RANGE && get_user_team(id)!=get_user_team(targetid) && playeritem[targetid]!=IMMUNITY){
			multiplier=EXPLOSION_MAX_DAMAGE*EXPLOSION_MAX_DAMAGE/EXPLOSION_RANGE
			damage=(EXPLOSION_RANGE-distancebetween)*multiplier
			damage=sqrt(damage)
			
			#if WAR3STATS						
				dmgStat[id][targetid] += damage
				hitStat[id][targetid]++
			#endif
			
			if (is_user_alive(targetid))
				targetdead=false
			else
				targetdead=true
				
			
			if (get_user_health(targetid)>500){		// Evasion kill
				if (get_user_health(targetid)-damage<=ELF_EVADE_ADJ){
					set_user_health(targetid, -1)
					targetdied=true
				}
			}
			
			if (get_user_health(targetid)-damage<=0)
				targetdied=true
			set_user_health(targetid, get_user_health(targetid)-damage)
			if (targetdied && !targetdead){
				set_user_frags(id, get_user_frags(id)+1)
				set_user_frags(targetid, get_user_frags(targetid)+1)
				message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
				write_byte(id)
				write_byte(targetid)
				write_byte(0)
				write_string(race1skill[3])
				message_end()
				playerxp[id]+=xpgiven[p_level[targetid]]
				#if WAR3STATS
					xpStat[id][targetid] += xpgiven[p_level[targetid]]
				#endif
				#if WAR3_MYSQL_TOP15	
					skillStat[id] += 1		
				#endif
				displaylevel(id, 1)
			}
                }

		if (distancebetween < EXPLOSION_RANGE){
			message_begin(MSG_ONE,gmsgShake,{0,0,0},targetid)
			write_short( 1<<14 )// amplitude
			write_short( 1<<13 )// duration
			write_short( 1<<14 )// frequency
			message_end()
		}
	}

	--parm[1]
	if (parm[1]>0)
		set_task(0.1,"apacheexplode",33,parm,2)
	return PLUGIN_CONTINUE
}

public blastcircles(parm[2]){
	new id = parm[0]
	new origin[3]
	get_user_origin(id,origin)

	// blast circles
	message_begin( MSG_PAS, SVC_TEMPENTITY, origin )
	write_byte( TE_BEAMCYLINDER )
	write_coord( origin[0])
	write_coord( origin[1])
	write_coord( origin[2] - 16)
	write_coord( origin[0])
	write_coord( origin[1])
	write_coord( origin[2] - 16 + BLASTCIRCLES_RADIUS)
	write_short( m_iSpriteTexture )
	write_byte( 0 ) // startframe
	write_byte( 0 ) // framerate
	write_byte( 6 ) // life
	write_byte( 16 )  // width
	write_byte( 0 )	// noise
	write_byte( 188 )
	write_byte( 220 )
	write_byte( 255 )
	write_byte( 255 ) //brightness
	write_byte( 0 ) // speed
	message_end()

	message_begin( MSG_PAS, SVC_TEMPENTITY, origin )
	write_byte( TE_BEAMCYLINDER )
	write_coord( origin[0])
	write_coord( origin[1])
	write_coord( origin[2] - 16)
	write_coord( origin[0])
	write_coord( origin[1])
	write_coord( origin[2] - 16 + ( BLASTCIRCLES_RADIUS / 2 ))
	write_short( m_iSpriteTexture )
	write_byte( 0 ) // startframe
	write_byte( 0 ) // framerate
	write_byte( 6 ) // life
	write_byte( 16 )  // width
	write_byte( 0 )	// noise
	write_byte( 188 )
	write_byte( 220 )
	write_byte( 255 )
	write_byte( 255 ) //brightness
	write_byte( 0 ) // speed
	message_end()

	return PLUGIN_CONTINUE
}

public sqrt(num) {
	new div = num
	new result = 1
	while (div > result) {			// end when div == result, or just below
		div = (div + result) / 2	// take mean value as new divisor
		result = num / div
	}
	return div
}

public client_connect(id){
	
	#if TEST_MODE
		playerxp[id] =300000
		p_skills[id][0] = 0
		p_skills[id][1] = 3
		p_skills[id][2] = 3
		p_skills[id][3] = 3
		p_skills[id][4] = 1
		p_level[id] = 10
	#else
		p_skills[id][0] = 0
		p_skills[id][1] = 0
		p_skills[id][2] = 0
		p_skills[id][3] = 0
		p_skills[id][4] = 0
		p_level[id] = 0
		playerxp[id] = 0
	#endif
	#if WAR3_MYSQL_TOP15
		skillStat[id] = -1000
		for( new i = 0; i < 33; i++ ){
			dmgStat[id][i] = 0
			hitStat[id][i] = 0
			xpStat[id][i] = 0
		}
	#endif
	playeritem[id] = 0
	


	if (is_user_bot(id) && saved_xp){
		playerxp[id]= xplevel[floatround(random_float(0.0,3.16)*random_float(0.0,3.16))]
		p_skills[id][0] = random_num(1,4)
		return PLUGIN_CONTINUE
	}

	return PLUGIN_CONTINUE
}

public client_disconnect(id){
	if (saved_xp && !is_user_bot(id) && p_skills[id][0] && playerxp[id]){
		#if MYSQL_ENABLED
			write_xp_to_file(id, "")
		#else
			addtosavequeue(id)
		#endif
	}
	return PLUGIN_CONTINUE
}

#if !MYSQL_ENABLED
	public addtosavequeue(id){
		if (p_skills[id][0] && playerxp[id]){
			new playerid[32], playername[32], timet[32], i=0
			if (get_user_wonid(id)!=-1)
				num_to_str(get_user_wonid(id),playerid,31)	// by wonid
			else
				get_user_authid(id,playerid,31)		// by ip
			while (!equal(savedline[i],"") && i<64){
				i++
			}
			if (i>=64)
				return PLUGIN_CONTINUE
			get_time("%m %d %H %M",timet,31)
			get_user_name(id,playername,31)
			format(savedline[i], 127, "%s ^"%s^" %d %d %d %d %d %d %s",playerid,playername,playerxp[id],
				p_skills[id][0],p_skills[id][1],p_skills[id][2],p_skills[id][3],p_skills[id][4], timet)
		}
		return PLUGIN_CONTINUE
	}

	public update_file(tid){
		new i
		for (i=0; i<64; i++){
			if (!equal(savedline[i],"")){
				write_xp_to_file(0,savedline[i])
			}
			savedline[i]=""
		}
		if (lastupdate + 600.0 < get_gametime()){
			write_all()
		}
		lastupdate = get_gametime()	// in seconds
		return PLUGIN_CONTINUE	
	}
#endif


#if !DISABLE_FORCESKIN
	public forceskin(id,key){
	
		if (warcraft3==false)
			return PLUGIN_CONTINUE
	
		changingteam[id]=false
	
		if (p_skills[id][0]!=0){
			new skin[2]
			num_to_str(p_skills[id][0],skin,1)
			engclient_cmd(id,"menuselect",skin)
			return PLUGIN_CONTINUE
		}
		else{
			if (saved_xp){
				get_xp_from_file(id,1)
			}
			else
				select_race(id)
		}
	
		return PLUGIN_CONTINUE
	}


public auto_join(id){

	if (warcraft3==false)
		return PLUGIN_CONTINUE

	changingteam[id]=true
	new vguimenus[8]
	get_user_info(id,"_vgui_menus",vguimenus,7)

	if (get_cvar_num("mp_forceskin")==0 || str_to_num(vguimenus)==1)
		return PLUGIN_CONTINUE

	if (p_skills[id][0]==0){
		new parm[1]
		parm[0]=id
		set_task(1.0,"auto_join_delay",34,parm,1)
	}

	return PLUGIN_CONTINUE
}

public auto_join_delay(parm[1]){
	new id = parm[0]
	if (p_skills[id][0]==0){
		set_task(1.0,"auto_join_delay",35,parm,1)
		if (!saved_xp)
			select_race(id)
	}
	return PLUGIN_CONTINUE
}

public auto_skin(id){

	if (warcraft3==false || get_cvar_num("mp_forceskin")==0)
		return PLUGIN_CONTINUE

	client_cmd(id,"slot5")		// Clear the menu, correct skin will be select automatically

	return PLUGIN_CONTINUE
}
#endif

public war3_vote(id,saychat) {

	if (get_cvar_num("sv_allowwar3vote")==0)
		return PLUGIN_CONTINUE
	
	if (voting > get_gametime()){
		console_print(id,"There is already one voting...")
		return PLUGIN_HANDLED
	}
	if (voting > 0.0 && voting + get_cvar_float("amx_vote_delay") > get_gametime()) {
		console_print(id,"Voting not allowed at this time")
		return PLUGIN_HANDLED
	}
	new keys = (1<<0)|(1<<1)
	new menu_msg[256]
	if (warcraft3==false)
		format(menu_msg,255,"\yEnable Warcraft 3 Plugin:\w^n^n1.  Yes^n2.  No")
	else
		format(menu_msg,255,"\yDisable Warcraft 3 Plugin:\w^n^n1.  Yes^n2.  No")		
	new Float:vote_time = get_cvar_float("amx_vote_time") + 2.0
	voting = get_gametime() + vote_time
	vote_ratio = get_cvar_float("amx_votewar3_ratio")
	show_menu(0,keys,menu_msg,floatround(vote_time))
	set_task(vote_time,"check_votes")
	console_print(id,"Voting has started...")
	option=0
	if (saychat==1)
		return PLUGIN_CONTINUE
	return PLUGIN_HANDLED
}

public vote_count(id,key){
	if (get_cvar_float("amx_vote_answers")) {
		new name[32]
		get_user_name(id,name,31)
		client_print(0,print_chat,"* %s voted %s",name,key ? "against" : "for" )
	}
	if (!key) ++option
	return PLUGIN_HANDLED
}

public check_votes() { 
	new status[32]
	new players[32], inum
	get_players(players,inum,"c")
	new Float:result_v = inum ? (float(option) / float(inum)) : 0.0
	if (result_v<vote_ratio){
		client_print(0,print_chat,"* Voting failed (yes ^"%d^") (no ^"%d^") (needed ^"%.2f^")",
			option, inum-option,vote_ratio)
		return PLUGIN_HANDLED
	}
	if (warcraft3==false){
		set_cvar_num("sv_warcraft3",1)
		status="Enabled"
	}
	else{
		set_cvar_num("sv_warcraft3",0)
		status="Disabled"
	}
	client_print(0,print_chat,"* Voting successful (ratio ^"%.2f^") (needed ^"%.2f^"). \
		The result: Warcraft 3 Plugin %s", result_v,vote_ratio,status)
	return PLUGIN_HANDLED
} 


#if HOSTAGE_KILL_SLAP
public hostage_kill_punish(parm[3]){	
	if( parm[2] == 1 ) {
		user_slap(parm[0],3) 	
		parm[2] = 0	
		set_task(0.1, "hostage_kill_punish", 10435, parm, 3, "a", parm[1])
	}else{
		user_slap(parm[0],3) 
	}
	return PLUGIN_CONTINUE
}

#endif



public armor_type(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	if (read_data(1))
		helmet[id]=true
	else
		helmet[id]=false
	return PLUGIN_CONTINUE
}

public check_say(id){
	new said[32]
	read_args(said,31) 
	#if WAR3STATS
		new statsParm[2]
		statsParm[0] = id
		statsParm[1] = 20
	#endif
		

	if (equali(said,"^"/changerace^"") || equali(said,"^"changerace^""))
		change_race(id,1)
	else if (equali(said,"^"/selectskill^"") || equali(said,"^"selectskill^""))
		select_skill(id,1)
	else if (equali(said,"^"/playerskills^"") || equali(said,"^"playerskills^""))
		player_skills(id,1)
	else if (equali(said,"^"/skillsinfo^"") || equali(said,"^"skillsinfo^""))
		skills_info(id,1)
	else if (equali(said,"^"/war3vote^"") || equali(said,"^"war3vote^""))
		war3_vote(id,1)
	else if (equali(said,"^"/war3help^"") || equali(said,"^"war3help^"") || equali(said,"^"/wc3help^"") || equali(said,"^"wc3help^""))
		saywar3_info(id)	
	else if (equali(said,"^"/level^"") || equali(said,"^"level^""))
		say_level(id)
	else if (equali(said,"^"/itemsinfo^"") || equali(said,"^"itemsinfo^""))
		items_info(id,1)
        else if (equali(said,"^"/war3menu^"") || equali(said,"^"war3menu^""))
                WC3_Menu(id)
        else if (equali(said,"^"/savexp^"") || equali(said,"^"savexp^""))
        	save_xp_info(id)  
        #if WAR3STATS
	        else if (equali(said,"^"stats^"") )
	        	display_stats(statsParm)    
	#endif       
	return PLUGIN_CONTINUE
}

public save_xp_info(id){
	if( get_cvar_num("mp_savexp") ){
		#if MYSQL_ENABLED
			client_print(id,print_chat, "[WC3] XP is saved to a reliable database automatically.")
		#else
			client_print(id,print_chat, "[WC3] XP is saved automatically, but not in a database, you may experience lost XP.")
		#endif
	}else{
		client_print(id,print_chat, "[WC3] XP is not saved on this server at this time, sorry!")
	}
	
	return PLUGIN_CONTINUE
}

public check_war3(){
	if (get_cvar_num("sv_warcraft3")==0){
		warcraft3=false
		//#if AMX_VERSION_093
		block_message(0)
		//#else
		//	MessageBlock( gmsgDeathMsg,BLOCK_NOT)
		//#endif
	}
	else{
		warcraft3=true
		//#if AMX_VERSION_093
		block_message(gmsgDeathMsg)
		//#else
		//	MessageBlock( gmsgDeathMsg,BLOCK_SET)
		//#endif
	}
	return PLUGIN_CONTINUE
}

public write_all(){
	if (warcraft3 && saved_xp){
		new players[32], numofplayers, id
		get_players(players, numofplayers)
		for (new i=0; i<numofplayers; i++){
			id = players[i]
			if (p_skills[id][0] && playerxp[id])
				write_xp_to_file(id,"")
		}
	}
	return PLUGIN_CONTINUE
}

public write_xp_to_file(id,givenline[128]){
	if (is_user_bot(id) || !saved_xp)
		return PLUGIN_CONTINUE

	new playerid[32], playername[32]

	
	if (id){
		get_user_name(id,playername,31)

		#if !MYSQL_ENABLED
			format(currentrace,1,"%d",p_skills[id][0])
		#endif

		//if (get_user_wonid(id)!=-1)
			//num_to_str(get_user_wonid(id),playerid,31)	// by wonid
		//else
//			get_user_ip(id,playerid,31)		**Uncomment this line if you want to use IPs. Make sure you comment the next line if you uncomment this one**
		get_user_authid(id,playerid,31)		// by AUTHID (Steam Users)
		
		
		
		//console_print(0,"steam playerid %s\n", playerid)
	}

	#if !MYSQL_ENABLED
	else{
		parse(givenline, playerid,31, playername,31, xp,7, currentrace,1)
	}
	#endif

	#if MYSQL_ENABLED
		new mquery[1024]
		
		if( contain(playername,"'") != -1 ){
			format(playername,31, "bad_name_quote")
		}else if( contain(playername,"!") != -1 ){
			format(playername,31, "bad_name_exclaim")
		}			
			
		if (needsSQLEntry[id])
		{
			format(mquery, 1023, "INSERT INTO `%s` (playerid,playername,xp,race,skill1,skill2,skill3,skill4) VALUES \
				('%s','%s',%d,%d,%d,%d,%d,%d)", mysqltablename, playerid, playername, playerxp[id],  p_skills[id][0], \
				p_skills[id][1], p_skills[id][2], p_skills[id][3], p_skills[id][4])
			needsSQLEntry[id] = false
		}
		else
		{
			format(mquery, 1023, "UPDATE `%s` SET playername='%s',xp=%d,skill1=%d,skill2=%d,skill3=%d,skill4=%d WHERE \
				playerid='%s' AND race=%d AND xp<%d", mysqltablename, playername, playerxp[id], p_skills[id][1], \
				p_skills[id][2], p_skills[id][3], p_skills[id][4], playerid, p_skills[id][0], playerxp[id])
		}
		//console_print(0,"%s\n", mquery)
		mysql_query(mysql,mquery)
		mysql_check_error()
		
		#if WAR3_MYSQL_TOP15
			//console_print(0,"Dumping %d skill for player", skillStat[id])
		
			// Save the "skill" value of the player
			if( skillStat[id] > 0 ){
				if( needsStatsEntry[id] ){
	
					format(mquery, 1023, "INSERT INTO `%s` (playerid,playername,skill) VALUES \
						('%s','%s',%d)", warStatTable, playerid, playername, skillStat[id])
					needsStatsEntry[id] = false				
				}else{
			
					format(mquery, 1023, "UPDATE `%s` SET playername='%s',skill=%d WHERE \
						playerid='%s'", warStatTable, playername, skillStat[id],playerid)				
				}			
				mysql_query(mysql,mquery)
				mysql_check_error()
			}
			
			#if DEBUG_LOGGER
				new nameo[32]
				get_user_name(id,nameo,31)
				log_to_file(logfile2,"%s saved %d skill",nameo,skillStat[id])
			#endif
			
		#endif
		
	#else
		new xp[8], race[2], currentrace[2]
		new nextline=0
		new textline[128], textlength, timet[32], matchfound
	
		if (file_exists(XPFILENAME)){
			do{
				matchfound = 0
				nextline=read_file(XPFILENAME,nextline,textline,127,textlength)
				if (get_cvar_num("mp_savebyname")==1 && contain(textline,playername)!=-1)
					matchfound = 1
				else if (get_cvar_num("mp_savebyname")==0 && contain(textline,playerid)==0)
					matchfound = 1
				if (matchfound){
					parse(textline, playerid,31, playername,31, xp,7, race,1)
					if (str_to_num(currentrace)==str_to_num(race)){
						break
					}
				}
			} while (nextline)
		}
		else{
			textline="** WonID/IP, Name, XP, Race, Skill1, Skill2, Skill3, Ultimate, Month, Day, Hour, Minutes"
			write_file(XPFILENAME,textline,0)
			textline="** Last Update:"
			write_file(XPFILENAME,textline,1)
			get_time("%m %d %H %M",timet,31)
			format(textline, 127, "## %s", timet)
			write_file(XPFILENAME,textline,2)
			nextline=0
		}
		if (id && playerxp[id] && p_skills[id][0]){
			get_time("%m %d %H %M",timet,31)
			format(textline, 127, "%s ^"%s^" %d %d %d %d %d %d %s",playerid,playername,playerxp[id],
				p_skills[id][0],p_skills[id][1],p_skills[id][2],p_skills[id][3],p_skills[id][4], timet)
			write_file(XPFILENAME,textline,nextline-1)
		}
		else{
			write_file(XPFILENAME,givenline,nextline-1)
		}

	#endif
	return PLUGIN_CONTINUE
}

public get_xp_from_file(id,returnrace){

	if (!saved_xp)
		return PLUGIN_CONTINUE

	if (!id)
		return PLUGIN_CONTINUE

	#if MYSQL_ENABLED
		new mquery[1024]
	#else
		new nextline=0
		new textline[128], textlength
		new matchfound = 0
	#endif

	new playerid[32], playername[32]
	new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
	new racexp[4]={0,0,0,0}

	get_user_name(id,playername,31)
	//if (get_user_wonid(id)!=-1)
	//	num_to_str(get_user_wonid(id),playerid,31)	// by wonid
	//else
	get_user_authid(id,playerid,31)		// by ip

	#if MYSQL_ENABLED
		if (returnrace)
		{
			if (get_cvar_num("mp_savebyname")==1)
				format(mquery, 1023, "SELECT * FROM `%s` WHERE playername='%s'",mysqltablename,playername)
			else
				format(mquery, 1023, "SELECT * FROM `%s` WHERE playerid='%s'",mysqltablename,playerid)
			mysql_query(mysql,mquery)
			
			
			
			//console_print(0, mquery)
			
			
			mysql_check_error()
			while (mysql_nextrow(mysql))
			{
				mysql_getfield(mysql,3,xp,7)
				mysql_getfield(mysql,4,race,1)
				if (str_to_num(race)>=1 && str_to_num(race)<=4)
					racexp[str_to_num(race)-1] = str_to_num(xp)
				mysql_check_error()
			}
	
			if (p_skills[id][0])
				racexp[p_skills[id][0]-1]=playerxp[id]
			server_cmd("display_race_select %d %d %d %d %d",id, racexp[0], racexp[1], racexp[2], racexp[3])
		}
		else
		{
			if (get_cvar_num("mp_savebyname")==1)
				format(mquery, 1023, "SELECT * FROM `%s` WHERE playername='%s' AND race='%d'",mysqltablename,playername,p_skills[id][0])
			else
				format(mquery, 1023, "SELECT * FROM `%s` WHERE playerid='%s' AND race='%d'",mysqltablename,playerid,p_skills[id][0])
			mysql_query(mysql,mquery)
			mysql_check_error()
			if (mysql_nextrow(mysql)){
				mysql_getfield(mysql,3,xp,7)
				mysql_getfield(mysql,5,skill1,1)
				mysql_getfield(mysql,6,skill2,1)
				mysql_getfield(mysql,7,skill3,1)
				mysql_getfield(mysql,8,skill4,1)
				playerxp[id]=str_to_num(xp)
				needsSQLEntry[id] = false;         	 // entry has been found, so no new SQL entry needs to be created
				p_skills[id][1]=str_to_num(skill1)
				p_skills[id][2]=str_to_num(skill2)
				p_skills[id][3]=str_to_num(skill3)
				p_skills[id][4]=str_to_num(skill4)
				displaylevel(id,0)
			}
			else{
				playerxp[id]=0
				needsSQLEntry[id] = true;         	 // entry has not been found, so a new SQL entry needs to be created
				p_skills[id][1]=0
				p_skills[id][2]=0
				p_skills[id][3]=0
				p_skills[id][4]=0
				displaylevel(id,0)
			}
			#if WAR3_MYSQL_TOP15
			
				// Get the "skill" value of the player from the database
				if (get_cvar_num("mp_savebyname")==1)
					format(mquery, 1023, "SELECT `skill` FROM `%s` WHERE playername='%s'",warStatTable,playername)
				else
					format(mquery, 1023, "SELECT `skill` FROM `%s` WHERE playerid='%s'",warStatTable,playerid)
				mysql_query(mysql,mquery)
				mysql_check_error()
				new temp[10]				
				if ( mysql_nextrow(mysql) ){					
					mysql_getfield(mysql,1,temp,9)
					skillStat[id] = str_to_num(temp)					 
					//console_print(0, temp)
					needsStatsEntry[id] = false					
				}else{					
					skillStat[id] = 500					
					needsStatsEntry[id] = true 
				}
				#if DEBUG_LOGGER
					new nameo[32]
					get_user_name(id,nameo,31)
					log_to_file(logfilename,"%s loaded %d skill",nameo,skillStat[id])
				#endif
				
				// Get the "ranking" of the player from the database
				format(mquery, 1023, "SELECT `rank` FROM `%s` WHERE playerid='%s'",warRankTable,playerid)
				mysql_query(mysql,mquery)
				mysql_check_error()
								
				if ( mysql_nextrow(mysql) ){					
					mysql_getfield(mysql,1,temp,9)
					rank[id] = str_to_num(temp)
					//console_print(0, temp)										
				}else{					
					rank[id] = 0						
				}
			
			#endif
		}
	#else
		if (file_exists(XPFILENAME)){
			do{
				matchfound = 0
				nextline=read_file(XPFILENAME,nextline,textline,127,textlength)
				if (get_cvar_num("mp_savebyname")==1 && contain(textline,playername)!=-1)
					matchfound = 1
				else if (get_cvar_num("mp_savebyname")==0 && contain(textline,playerid)==0)
					matchfound = 1
				if (matchfound){
					parse(textline, playerid,31, playername,31, xp,7, race,1, skill1,1, skill2,1, skill3,1, skill4,1)
					if (p_skills[id][0]==str_to_num(race) && !returnrace){
						playerxp[id]=str_to_num(xp)
						p_skills[id][1]=str_to_num(skill1)
						p_skills[id][2]=str_to_num(skill2)
						p_skills[id][3]=str_to_num(skill3)
						p_skills[id][4]=str_to_num(skill4)
						displaylevel(id,0)
						break
					}
					else if (returnrace){
						if (str_to_num(race)>=1 && str_to_num(race)<=4)
							racexp[str_to_num(race)-1] = str_to_num(xp)
					}
				}
			} while (nextline)
		}
		if (returnrace){
			if (p_skills[id][0])
				racexp[p_skills[id][0]-1]=playerxp[id]
			server_cmd("display_race_select %d %d %d %d %d",id, racexp[0], racexp[1], racexp[2], racexp[3])
		}
		else if (!nextline){
			playerxp[id]=0
			p_skills[id][1]=0
			p_skills[id][2]=0
			p_skills[id][3]=0
			p_skills[id][4]=0
			displaylevel(id,0)
		}
	#endif
	return PLUGIN_CONTINUE
}

public display_race_select(){
	new id, idtext[3], menu_msg[256]
	new racexp1[8], racexp2[8], racexp3[8], racexp4[8]
	read_argv(1,idtext,2)
	read_argv(2,racexp1,7)
	read_argv(3,racexp2,7)
	read_argv(4,racexp3,7)
	read_argv(5,racexp4,7)

	id = str_to_num(idtext)
	format(menu_msg,255,"\ySelect Race:\RExperience^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n^n\
		\w5. Auto-select", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4)
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),menu_msg,-1)
	return PLUGIN_HANDLED
}

#if MYSQL_ENABLED
	public mysql_check_error(){
		new merror[256]
		mysql_error(mysql,merror,255)
		if (merror[0])
		{
			server_print("MYSQL Error Query: %s", merror)
		}
	}

#else
	public remove_empty_lines(){
		new nextline=0
		new textline[128], textlength
		new tempfile[32]="war3user.tmp"
		if (file_exists(tempfile))
			delete_file(tempfile)
	
		if (file_exists(XPFILENAME) && !file_exists(tempfile)){
			do{
				nextline=read_file(XPFILENAME,nextline,textline,127,textlength)
				if (textlength && nextline){
					write_file(tempfile,textline,-1)
				}
			} while (nextline)
			if (delete_file(XPFILENAME)){
				do{
					nextline=read_file(tempfile,nextline,textline,127,textlength)
					if (textlength && nextline){
						write_file(XPFILENAME,textline,-1)
					}
				} while (nextline)
			}
			delete_file(tempfile)
		}
		return PLUGIN_CONTINUE
	}
#endif


public plugin_end(){
	if (!warcraft3 || !saved_xp)
		return PLUGIN_CONTINUE

	#if MYSQL_ENABLED
		write_all()

		#if MYSQL_AUTO_PRUNING
			new mquery[1024]
			new currentHour[3]  
			new currentMin[3]      			
			
			get_time("%H",currentHour,2)
			get_time("%M",currentMin,2)
			
			// At 5:36 AM until 5:59 AM a mapchange will trigger an auto-prune.
			if( (str_to_num( currentHour) == 5) && (str_to_num( currentMin) > 35 ) ){
					
				// Timestamp format: 20030912122142
				// Y = 2003 M = 09 D = 12 H = 12 M = 21 S = 42	
										
				format(mquery, 1023, "DELETE FROM `%s` WHERE `time` + %d < now()",mysqltablename, DAYS_BEFORE_DELETE * 1000000) 
				//console_print(0,mquery)			
				mysql_query(mysql,mquery)
				mysql_check_error()					
			}
			
			#if WAR3_MYSQL_TOP15
				// At 5:05 AM until 5:36 AM a mapchange will trigger a stats auto-prune
				if( (str_to_num( currentHour) == 5) && (str_to_num( currentMin) > 5 ) && (str_to_num( currentMin) <= 35 ) ){
					format(mquery, 1023, "DELETE FROM `%s` WHERE `time` + %d < now()",warStatTable, DAYS_BEFORE_DELETE * 1000000) 
					//console_print(0,mquery)			
					mysql_query(mysql,mquery)
					mysql_check_error()
				}
			#endif
		#endif
		
		// Update rankings for the next map
		#if WAR3_MYSQL_TOP15
			//console_print(0, "Dumping to war3ranks table")
			
			// Delete everything from the old Rank Table
			format(mquery, 1023, "DELETE FROM `war3ranks`")
			mysql_query(mysql,mquery)
			mysql_check_error()
			
			// Create a Rank Table from the updated Skill table
			format(mquery, 1023, "SELECT @i := 0")
			mysql_query(mysql,mquery)
			mysql_check_error()
			
			format(mquery, 1023, "INSERT INTO `%s` (`playerid`,`playername`,`rank`) \
				SELECT `playerid`,`playername`, @i := @i + 1 \
				FROM `%s`  \
				GROUP BY `playerid` \
				ORDER BY `skill` DESC", warRankTable,warStatTable)
								
			mysql_query(mysql,mquery)
			mysql_check_error()
		#endif

		mysql_close(mysql)

	#else
		update_file(0)
		new nextline=0
		new textline[128], textlength, playerid[32], playername[32]
		new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
		new month[3], day[3], hour[3], minutes[3], temp[3], timet[32]
		new currentmonth[3], currentday[3], currenthour[3],dayofyear, currentdayofyear
		new xpnumber, i, playerlevel
		new daysinmonth[12] = {31,28,31,30,31,30,31,31,30,31,30,31}
	
		if (file_exists(XPFILENAME)){
			do{
				nextline=read_file(XPFILENAME,nextline,textline,127,textlength)
				if (contain(textline,"##")==0){
					parse(textline, temp,2, month,2, day,2, hour,2, minutes,2)
					break
				}
			} while (nextline)
			get_time("%d",currentday,2)
			get_time("%m",currentmonth,2)
			get_time("%H",currenthour,2)
			if (!equal(currentday,day,2) || !equal(currentmonth,month,2)){
				client_print(0,print_chat,"Updating %s...",XPFILENAME)
				get_time("%m %d %H %M",timet,31)
				format(textline, 127, "## %s", timet)
				write_file(XPFILENAME,textline,nextline-1)
				currentdayofyear = str_to_num(currentday)
				for (i=1; i<str_to_num(currentmonth); i++){
					currentdayofyear+=daysinmonth[i-1]
				}
				nextline=0
				do{
					nextline=read_file(XPFILENAME,nextline,textline,127,textlength)
					if (textlength && contain(textline,"**") && contain(textline,"##")){	// contain() returns 0 if the first two characters are equal
						parse(textline, playerid,31, playername,31, xp,7, race,1, skill1,1, skill2,1, skill3,1, skill4,1, month,2, day,2, hour,2, minutes,2)
						xpnumber = str_to_num(xp)
						for (i=1; i<=10; ++i){
							if (xpnumber>=xplevel[i])
								playerlevel=i
							else
								break
						}
						dayofyear = str_to_num(day)+DAYS_BEFORE_DELETE+playerlevel
						for (i=1; i<str_to_num(month); i++){
							dayofyear+=daysinmonth[i-1]
						}
						if (dayofyear>365)
							dayofyear-=365
						if (dayofyear <= currentdayofyear){
							write_file(XPFILENAME,"",nextline-1)
						}
					}
				} while (nextline)
				remove_empty_lines()
			}
		}
	#endif

	return PLUGIN_CONTINUE
}

public set_longtermxp(){
	new textline[64], nextline=0, textlength, mapname[64]
	new filename[32] = "war3maps.ini"
	get_mapname(mapname,63)
	if (file_exists(filename)){
		do{
			nextline = read_file(filename,nextline,textline,63,textlength)
			if (equal(textline,mapname))
				return PLUGIN_CONTINUE
		} while(nextline)
	}
	if (get_cvar_num("mp_savexp")){
		new Float:xpmultiplier=get_cvar_float("mp_xpmultiplier")
		saved_xp=true
		
		BOMBPLANTXP /= 10
		DEFUSEXP /= 10
		HOSTAGEXP /= 10
		KILLRESCUEMANXP /= 10
		XPBONUS /= 10
		 
		#if XPRESET
			xpgiven = {6,8,10,12,14,16,20,24,28,32,40,40}
			xplevel = {0,100,200,400,800,1600,3200,6400,12800,25600,51200, RESET_XP_LEVEL_SAVE }
			for (new i=0; i<12; i++){			
				xplevel[i] =  floatround(xplevel[i] * xpmultiplier)			
			}
		#else
			xpgiven = {6,8,10,12,14,16,20,24,28,32,40}
			xplevel = {0,100,200,400,800,1600,3200,6400,12800,25600,51200}
			for (new i=0; i<11; i++){			
				xplevel[i] =  floatround(xplevel[i] * xpmultiplier)			
			}
		#endif		
		
		// Preparation for 100 levels of XP
		#if 0
			xpgiven = {5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16, \
			17,17,18,18,19,19,20,20,21,21,22,22,23,23,24,24,25,25,26,26,27,27,28,28, \
			29,29,30,30,31,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,40,40, \
			41,41,42,42,43,43,44,44,45,45,46,46,47,47,48,48,49,49,50,50,51,51,52,52, \
			53,53,54,54,55,55}
		
			xplevel = {25,50,100,175,275,400,550,725,925,1150,1400,1675,1975,2300,2650,3025,3425,3850, \
			4300,4775,5275,5800,6350,6925,7525,8150,8800,9475,10175,10900,11650,12425,13225, \
			14050,14900,15775,16675,17600,18550,19525,20525,21550,22600,23675,24775,25900, \
			27050 ,28225,29425 ,30650 ,31900 ,33175 ,34475 ,35800 ,37150 ,38525 ,39925, \
			41350 ,42800 ,44275 ,45775 ,47300 ,48850 ,50425 ,52025 ,53650 ,55300 ,56975, \
			58675 ,60400 ,62150 ,63925 ,65725 ,67550 ,69400 ,71275 ,73175 ,75100 ,77050, \
			79025 ,81025 ,83050 ,85100 ,87175 ,89275 ,91400 ,93550 ,95725 ,97925 ,100150 , \
			102400 ,104675 ,106975 ,109300 ,111650 ,114025 ,116425 ,118850 ,121300 ,123775} 
			
			for (new i=0; i<101; i++){			
				xplevel[i] =  floatround(xplevel[i] * xpmultiplier)			
			}
		#endif	
	}
	return PLUGIN_CONTINUE
}

public menu_item(id,key){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
		
	
		
	// The only way to stop a script is to just stop the person from buying.
	// And then to buy it for them, of course.
	engclient_cmd(id,"menuselect","10")  
	
	
	if( key==0 ){	// Kevlar
		engclient_cmd(id,"buyequip")
		engclient_cmd(id,"menuselect","1") 
		engclient_cmd(id,"menuselect","10")  			
	}else if( key == 1 ){ // Kevlar & Helmet
		engclient_cmd(id,"buyequip")
		engclient_cmd(id,"menuselect","2") 
		engclient_cmd(id,"menuselect","10")  
	}else if( key == 2 ){ // Flash bang
		engclient_cmd(id,"buyequip")
		engclient_cmd(id,"menuselect","3") 
		engclient_cmd(id,"menuselect","10")  
	}else if( key == 3 ){ // Grenade
		if (hasgrenade[id]){				
			engclient_cmd(id,"menuselect","10")
			set_hudmessage(200, 100, 0, -1.0, 0.25, 0, 1.0, 5.0, 0.1, 0.2, 1)
			show_hudmessage(id,"No grenade spamming! One HE grenade per round maximum.")
		}else{
			engclient_cmd(id,"buyequip")
			engclient_cmd(id,"menuselect","4") 
			engclient_cmd(id,"menuselect","10")  
			hasgrenade[id]=true
		}
	}else if( key == 4 ){ // Smoke Grenade
		engclient_cmd(id,"buyequip")
		engclient_cmd(id,"menuselect","5") 
		engclient_cmd(id,"menuselect","10")  
	}else if( key == 5 ){ // Defuser Kit
		engclient_cmd(id,"buyequip")
		engclient_cmd(id,"menuselect","6") 
		engclient_cmd(id,"menuselect","10")  
	}else if( key == 6 ){ // Night Vision Goggles
		engclient_cmd(id,"buyequip")
		engclient_cmd(id,"menuselect","7") 
		engclient_cmd(id,"menuselect","10")  
	}
	client_cmd(id,"slot10") // Close the menu? M'kay.
			
		
	
	return PLUGIN_HANDLED
}



public shopmenu(id){
	#if SHOPMENU_IN_BUYZONE
        	if (warcraft3==false){
               		return PLUGIN_CONTINUE
               	}else if( isBuyzone[id] == false ){
               		return PLUGIN_CONTINUE
        	}
        #else               
               	if (warcraft3==false)
               		return PLUGIN_CONTINUE
        #endif

	new pos = 0
	new keys = (1<<0|1<<1|1<<2|1<<3|1<<4|1<<5|1<<6|1<<7|1<<8|1<<9)
	new menu_body[512]
	pos += format(menu_body[pos], 511-pos, "\yBuy Item\R$   Cost^n^n")
	for (new i = 0; i<9; i++){
		pos += format(menu_body[pos], 511-pos, "\w%d. %s\y\R%d^n",i+1,longItemName[i],itemcost[i])
	}
	pos += format(menu_body[pos], 511-pos, "^n\w0. Exit")
        if (is_user_alive(id))
		show_menu(id,keys,menu_body,-1)
	return PLUGIN_HANDLED
}

public buy_item(id,key){
	new usermoney = get_user_money(id)
	if (key==9)
		return PLUGIN_HANDLED
	else if (usermoney<itemcost[key]){
		client_print(id,print_center,"You have insufficient funds!")
		return PLUGIN_HANDLED
	}
	else if (key==TOME-1){
		set_user_money(id,usermoney-itemcost[key],1)
		playerxp[id]+=XPBONUS	// Give XP bonus for buying Tome of Experience
	}
	else{
		set_user_money(id,usermoney-itemcost[key],1)
		if (playeritem[id]==HEALTH)		// Remove health bonus after buying new item
			set_user_health(id,get_user_health(id)-HEALTHBONUS)
		playeritem[id]=key+1
		if (playeritem[id]==HEALTH)		// Give health bonus for buying periapt of health
			set_user_health(id,get_user_health(id)+HEALTHBONUS)
	}
	if (file_exists("sound/warcraft3/PickUpItem.wav")==1)
		emit_sound(id,CHAN_STATIC, "warcraft3/PickUpItem.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	displaylevel(id,1)
	return PLUGIN_HANDLED
}

public WC3_Menu(id){
        new pos = 0
        new menu_body[512]
	#if OPT_RESETSKILLS
	        new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8)|(1<<9)
        	new menu_items[9][]= {  "Change Race",
                                                                        "Shop Menu",
                                                                        "Select Skills",
                                                                        "Show Level",
                                                                        "Player Skills",
                                                                        "Skills Info",
                                                                        "Items Info",
                                                                        "War3 Help",
                                                                        "Reset Skills" }
	        pos += format(menu_body[pos], 511-pos, "\yWarCraft3 XP Menu^n^n")
        	for (new i = 0; i<9; i++){
	                pos += format(menu_body[pos], 511-pos, "\w%d. %s^n",i+1,menu_items[i])
        	}
        #else
                new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<9)
                new menu_items[8][]= {  "Change Race",
                                                                        "Shop Menu",
                                                                        "Select Skills",
                                                                        "Show Level",
                                                                        "Player Skills",
                                                                        "Skills Info",
                                                                        "Items Info",
                                                                        "War3 Help"}
                pos += format(menu_body[pos], 511-pos, "\yWarCraft3 XP Menu^n^n")
                for (new i = 0; i<8; i++){
                        pos += format(menu_body[pos], 511-pos, "\w%d. %s^n",i+1,menu_items[i])
                }
	#endif
	pos += format(menu_body[pos], 511-pos, "^n\w0. Exit")
        show_menu(id,keys,menu_body,-1)
        return PLUGIN_HANDLED
}

public do_wc3menu(id,key){
        switch (key){
                case 0: change_race(id,1)
                case 1: shopmenu(id)
                case 2: select_skill(id,1)
                case 3: say_level(id)
                case 4: player_skills(id,1)
                case 5: skills_info(id,1)
                case 6: items_info(id,1)
                case 7: saywar3_info(id)
		#if OPT_RESETSKILLS
	                case 8: resetskills(id)
		#endif
                default:        return PLUGIN_HANDLED
        }
        if (file_exists("sound/warcraft3/PickUpItem.wav")==1)
                emit_sound(id,CHAN_STATIC, "warcraft3/PickUpItem.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)

        return PLUGIN_HANDLED
}

#if MYSQL_ENABLED
	public set_mysql(){
		new filename[32] = "war3mysql.ini"
		new nextline=0, textlength
	
		get_cvar_string("sv_mysqltablename",mysqltablename,63)		
		new mhost[64], muser[32], mpass[32], mdb[32], primarykey[128]
		new merror[256]
		new mquery[512]
		format (mquery, 511, "CREATE TABLE IF NOT EXISTS `%s` ( `playerid` VARCHAR(32) NOT NULL, `playername` VARCHAR(32) NOT NULL, `xp` INT(10) NOT NULL, `race` TINYINT(4) NOT NULL, \
				`skill1` TINYINT(4), `skill2` TINYINT(4), `skill3` TINYINT(4), `skill4` TINYINT(4), `time` TIMESTAMP( 14 ) NOT NULL, PRIMARY KEY (playerid,race))",mysqltablename)
	
			
		if (file_exists(filename)){
			nextline = read_file(filename,nextline,mhost,63,textlength)
			nextline = read_file(filename,nextline,muser,31,textlength)
			nextline = read_file(filename,nextline,mpass,31,textlength)
			nextline = read_file(filename,nextline,mdb,31,textlength)
		}
		else{
			server_cmd("exec addons/amx/mysql.cfg")
			get_cvar_string("amx_mysql_host",mhost,63)
			get_cvar_string("amx_mysql_user",muser,31)
			get_cvar_string("amx_mysql_pass",mpass,31)
			get_cvar_string("amx_mysql_db",mdb,31)
		}
	
		mysql = mysql_connect(mhost,muser,mpass,mdb,merror,256)
		if (merror[0]) 
		{
			server_print("MYSQL Error Connect: %s", merror)
		} 
		mysql_query(mysql,mquery)
		mysql_check_error()
		
		#if WAR3_MYSQL_TOP15
			// Create the Skills table
			format (mquery, 511, "CREATE TABLE IF NOT EXISTS `%s` ( `playerid` VARCHAR(32) NOT NULL, \
				 `playername` varchar(32) NOT NULL default '', `skill` int(10) NOT NULL default '500', \
				 `time` TIMESTAMP( 14 ) NOT NULL, PRIMARY KEY (playerid) )",warStatTable)
			mysql_query(mysql,mquery)
			mysql_check_error()
			
			// Create the Rankings table, note this is a temporary table. It's being used as a "View"
			format (mquery, 511, "CREATE TABLE IF NOT EXISTS `%s` ( `playerid` VARCHAR(32) NOT NULL, \
				 `playername` VARCHAR(32) NOT NULL default '',`rank` int(10) NOT NULL default '0', \
				 PRIMARY KEY (playerid) )",warRankTable)
			mysql_query(mysql,mquery)
			mysql_check_error()
			
			// Retrieve the Top 15 players
			format (mquery, 511, "SELECT `playername` FROM `%s` LIMIT 0, 15", warRankTable)
			mysql_query(mysql,mquery)
			mysql_check_error()
			
			
			for(new i = 0; i < 15; ++i){
				if( mysql_nextrow(mysql) ){
					mysql_getfield(mysql,1,top15[i],31)	
				}else{
					format(top15[i],31,"-- Empty --") 	
				}		
			} 			
			
			
		#endif
	
		format(mquery, 511, "show index from `%s`", mysqltablename)
		mysql_query(mysql,mquery)
		mysql_check_error()
		if (mysql_nextrow(mysql)){
			mysql_getfield(mysql,5,primarykey,127)
		}
	
		if (get_cvar_num("mp_savebyname")==1 && contain(primarykey,"playername")){	// contain() returns 0 if the two strings match exactly
			format(mquery, 511, "ALTER TABLE `%s` DROP PRIMARY KEY , ADD PRIMARY KEY ( `playername` , `race` )", mysqltablename)
			mysql_query(mysql,mquery)
			mysql_check_error()
		}
		else if (get_cvar_num("mp_savebyname")==0 && contain(primarykey,"playerid")){	// contain() returns 0 if the two strings match exactly
			format(mquery, 511, "ALTER TABLE `%s` DROP PRIMARY KEY , ADD PRIMARY KEY ( `playerid` , `race` )", mysqltablename)
			mysql_query(mysql,mquery)
			mysql_check_error()
		}
		return PLUGIN_CONTINUE
	}
#endif

#if SHOPMENU_IN_BUYZONE
public BuyZone(id) 
{ 
	if (read_data(1)){ 
		isBuyzone[id] = true 
	}else{ 
		isBuyzone[id] = false 
	} 

	return PLUGIN_CONTINUE 
} 
#endif

#if XP_CHANGEABLE_OUTSIDE
	public changeXP(){ 
		new arg1[4] 
		new arg2[8] 
		read_argv(1,arg1,3) 
		read_argv(2,arg2,7) 
			
		new id=str_to_num(arg1) 
		new xp=str_to_num(arg2)
	 
	  	if( (playerxp[id] + xp) < 0 ){ 
	  		playerxp[id] = 0 
		}else{
	   		playerxp[id] += xp 
	   	}
	   	displaylevel(id, 1) 
	}
#endif

public plugin_precache() {
	g_sModelIndexFireball = precache_model("sprites/zerogxplode.spr")
	g_sModelIndexSmoke = precache_model("sprites/steam1.spr")
	m_iSpriteTexture = precache_model( "sprites/shockwave.spr")
	flaresprite = precache_model( "sprites/blueflare2.spr")
	iBeam4 = precache_model("sprites/zbeam4.spr")
	m_iTrail = precache_model("sprites/smoke.spr")
	lightning = precache_model("sprites/lgtning.spr")
	
	

	precache_sound("ambience/particle_suck1.wav")
	precache_sound("turret/tu_ping.wav")

	if (file_exists("sound/warcraft3/EntanglingRootsTarget1.wav"))
		precache_sound("warcraft3/EntanglingRootsTarget1.wav")
	else{
		precache_sound("weapons/electro5.wav")
		precache_sound("weapons/cbar_hitbod3.wav")
	}

	if (file_exists("sound/warcraft3/Levelupcaster.wav"))
		precache_sound("warcraft3/Levelupcaster.wav")
	else
		precache_sound("plats/elevbell1.wav")

	if (file_exists("sound/warcraft3/LightningBolt.wav"))
		precache_sound("warcraft3/LightningBolt.wav")
	else
		precache_sound("weapons/gauss2.wav")

	if (file_exists("sound/warcraft3/MassTeleportTarget.wav"))
		precache_sound("warcraft3/MassTeleportTarget.wav")
	else
		precache_sound("x/x_shoot1.wav")

	if (file_exists("sound/warcraft3/PickUpItem.wav"))
		precache_sound("warcraft3/PickUpItem.wav")

	#if ULTIMATE_READY_SOUND
		precache_sound("fvox/power_restored.wav")
	#endif
	
	#if SLAY_LOSERS
		white = precache_model("sprites/white.spr")
		precache_sound( "ambience/thunder_clap.wav")
		precache_sound( "weapons/headshot2.wav")
		precache_sound( "weapons/explode3.wav")
	#endif
	
	return PLUGIN_CONTINUE
}

public plugin_init()
{
	#if MULTI_WEP_FIX
		for( new i = 0; i < 33; i++ ){
			playeritem[i] = 0
			diedlastround[i]=false
			playerItemOld[i] = 0
			#if WAR3STATS
				for( new j = 0; j < 33; j++ ){
					dmgStat[i][j]	= 0
			 		hitStat[i][j] = 0
					xpStat[i][j] = 0
				}
				
			#endif
		}
	#endif
	
	#if ULTIMATE_READY_ICON
		gmsgIcon = get_user_msgid("StatusIcon") 		
	#endif

	gmsgDeathMsg = get_user_msgid("DeathMsg")
	gmsgFade = get_user_msgid("ScreenFade")
	gmsgShake = get_user_msgid("ScreenShake")
	gmsgStatusText = get_user_msgid("StatusText")
	register_plugin("Warcraft 3 XP","2.22.9","SpaceDude, etc.")
	register_cvar("Warcraft_3_XP", "2.22.9_RC_19",FCVAR_SERVER)
	register_menucmd(register_menuid("\ySelect Race:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),"set_race")
	register_menucmd(register_menuid("\ySelect Skill:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9),"set_skill")
	#if !BLINK_HUMAN_ULTIMATE
		register_menucmd(register_menuid("\yTeleport to:"),1023,"set_target")
	#endif
	register_menucmd(register_menuid("\yBuy Item"),1023,"buy_item")
	register_menucmd(register_menuid("Warcraft 3 Plugin:") ,(1<<0)|(1<<1),"vote_count") 
	
	#if XPRESET
		register_menucmd(register_menuid("Your Wish Is:") ,(1<<0)|(1<<1),"xp_choice") 
	#endif
	#if !DISABLE_FORCESKIN
		register_menucmd(register_menuid("Terrorist_Select"),1023,"forceskin")
		register_menucmd(register_menuid("CT_Select"),1023,"forceskin")
		register_menucmd(-26,1023,"forceskin")		// VGUI
		register_menucmd(-27,1023,"forceskin")		// VGUI
	#endif
	register_menucmd(register_menuid("BuyItem"),1023,"menu_item")
	register_menucmd(-34,1023,"menu_item")
        register_menucmd(register_menuid("\yWarCraft3 XP Menu"),1023,"do_wc3menu")
        register_clcmd("war3menu","WC3_Menu",-1,"- Show WarCraft3 XP Player menu")
	register_clcmd("changerace","change_race",-1,"changerace")	// mp_allowchangerace must be set to 1
	register_clcmd("selectskill","select_skill",-1,"selectskill")	// Use "selectskill" console command to lvl up
	register_concmd("playerskills","player_skills",-1,"playerskills")
	register_clcmd("skillsinfo","skills_info",-1,"skillsinfo")
	register_clcmd("itemsinfo","items_info",-1,"itemsinfo")
	register_clcmd("war3help","war3_info",-1,"war3help")	
	register_clcmd("savexp","save_xp_info",-1,"savexp")
	register_clcmd("war3vote","war3_vote",-1,"war3vote")
	register_clcmd("ultimate","ultimate",-1,"ultimate")
	register_clcmd("shopmenu","shopmenu",-1,"shopmenu")
	register_clcmd("say","check_say")
	register_clcmd("say_team","check_say")
	register_clcmd("go","handle_gogogo",-1,"handle_gogogo")
  	register_clcmd("radio2","handle_gogogo",-1,"handle_gogogo")
	register_srvcmd("display_race_select","display_race_select")		// For internal use only (don't use this this command)
	#if XP_CHANGEABLE_OUTSIDE
		register_srvcmd("wc3_changexp","changeXP")
	#endif
	
	#if SLAY_LOSERS	
		register_event("SendAudio","end_round","a","2=%!MRAD_terwin","2=%!MRAD_ctwin") 
		register_event("SendAudio","end_round_draw","a","2=%!MRAD_rounddraw") 
	#else
		register_event("SendAudio","end_round","a","2=%!MRAD_terwin","2=%!MRAD_ctwin","2=%!MRAD_rounddraw") 
	#endif
	
	register_event("SendAudio","freezetimedone","b","2=%!MRAD_GO","2=%!MRAD_MOVEOUT","2=%!MRAD_LETSGO","2=%!MRAD_LOCKNLOAD")
	register_event("CurWeapon","change_weapon","be","1=1")
	register_event("DeathMsg","death","a")
	register_event("ResetHUD", "new_round", "b")
	register_event("Damage", "damage_event", "b", "2!0")
	
	#if !DISABLE_FORCESKIN
		register_event("ShowMenu","auto_join","b","4&Team_Select")
		register_event("VGUIMenu","auto_join","b","1=2")
		register_event("ShowMenu","auto_skin","b","4&CT_Select")
		register_event("ShowMenu","auto_skin","b","4&Terrorist_Select")
		register_cvar("mp_forceskin","0",0)	
	#endif
	register_event("StatusIcon", "got_defuse", "be", "1=1", "1=2", "2=defuser")
	#if SHOPMENU_IN_BUYZONE
		register_event("StatusIcon","BuyZone","be","2=buyzone") 
	#endif
	register_event("ArmorType", "armor_type", "be")
	register_event("TextMsg","restart_round","a","2&#Game_will_restart_in")	
	
	// Log events: Requires AMX 0.9.3 or better
   	register_logevent("event_player_action",3,"1=triggered") 
		
	#if STEAM_POWERED
	        register_event("SetFOV","zoomed2","be","1<90")
	        register_event("SetFOV","unzoomed","be","1=90")
	#endif
	register_cvar("mp_allowchangerace","0",0)
	#if ORCNADE_CVAR
		register_cvar("mp_alloworcnade","1",0)
	#endif
	#if XPRESET
		register_cvar("Lvl_11_Reset","1",FCVAR_SERVER)
	#else
		register_cvar("Lvl_11_Reset","0",FCVAR_SERVER)
	#endif	
	
	register_cvar("mp_savexp","0",FCVAR_SERVER)
	register_cvar("mp_xpmultiplier","1.0",FCVAR_SERVER)
	register_cvar("mp_savebyname","0")
	register_cvar("mp_weaponxpmodifier","1")
	register_cvar("sv_warcraft3","1",FCVAR_SERVER)
	register_cvar("sv_allowwar3vote","1",0)
	if (!cvar_exists("amx_vote_delay"))
		register_cvar("amx_vote_delay","60")
	if (!cvar_exists("amx_vote_time"))
		register_cvar("amx_vote_time","10")
	if (!cvar_exists("amx_vote_answers"))
		register_cvar("amx_vote_answers","1")
	#if MYSQL_ENABLED
		if (!cvar_exists("amx_mysql_host"))
			register_cvar("amx_mysql_host","127.0.0.1")
		if (!cvar_exists("amx_mysql_user"))
			register_cvar("amx_mysql_user","")
		if (!cvar_exists("amx_mysql_pass"))
			register_cvar("amx_mysql_pass","")
		if (!cvar_exists("amx_mysql_db"))
			register_cvar("amx_mysql_db","war3base")
		register_cvar("sv_mysqltablename","war3users")
	#endif
	register_cvar("amx_votewar3_ratio","0.70")
	
	set_task(10.0,"check_war3",456,"",0,"b")
	
	set_task(1.0,"check_war3",457)
	#if !TEST_MODE
		set_task(1.0,"set_longtermxp",458)
		#if MYSQL_ENABLED
			set_task(1.0,"set_mysql",324)
		#endif
	#endif
	set_xpmultiplier()
	return PLUGIN_CONTINUE
}
