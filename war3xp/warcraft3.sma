/* AMX Mod script. 
* 
*  Warcraft 3 XP 
*  Original idea and code by SpaceDude 
*
*  Version pre-2.22.12
*
*  Read readme.txt for a desription of the plugin.
*  Read installer.txt for installation information.
*  Read changelog.txt for info about this plugins history of changes.
*		
*
*  Update/Modifications by: 	Mr. B, Dopefish, Tri Moon, Mike4066, [AoL]LuckyJ, 
*				[AoL]Demandred, Pimp Daddy, Denkkar Seffyd, rACEmic,
*				willyumyum, trinity, ferret, No FuN, SniperBeamer
* 
*  Maintainer of the 2.22.x code: Ryan Schulze a.k.a. "DopeFish"
* 
*
*
* (C)2003-2004 "Spacedude" and all people listed under "Update/Modifications"
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*
* Give credit where due. 
* http://www.opensource.org/
* http://www.gnu.org/
*
*
* Support Forum:
* http://www.insanejustice.com/forum/forumdisplay.php?s=&forumid=35
*/


#include <amxmodx>
			
			
// Pre-compilation configuration, edit to your needs:
// if you change something in warcraft3.cfg, you will have to recompile the plugin
// Linux: ./sc warcraft3.sma -o../plugins/warcraft3.amx
// Win:     sc warcraft3.sma -o../plugins/warcraft3.amx
#include "warcraft3.cfg"

//Using AMX Config, no need to ask users any more.
//To override the amx setting uncomment the next line for cs1.5, leave for 1.6
//#define NO_STEAM
                                                                                                                        
#if defined (NO_STEAM)
   #define STEAM_POWERED 0
#else
   #define STEAM_POWERED 1
#endif

// Some versions of amxconst.inc don't have theese entries
// so we'll doublecheck that they exist.
#if !defined (CSW_GALI)
      #define CSW_GALI 14
#endif
#if !defined (CSW_FAMAS)
      #define CSW_FAMAS 15
#endif

// Options not set in warcraft3.cfg get set to the default value here.
// Yeah I know this blows up the .sma code to ungodly dimensions but 
// it dosen't have any impact on the .amx file and makes it easier for
// admins to maintain their .cfg

#if !defined (WC3_MODULE)
      #define WC3_MODULE 0
#endif
#if !defined (SHORT_TERM)
      #define SHORT_TERM 1
#endif
#if !defined (MYSQL_ENABLED)
      #define MYSQL_ENABLED 0
#endif
#if !defined (VAULT_SAVE)
      #define VAULT_SAVE 0
#endif
#if !defined (LANG_ENG)
      #define LANG_ENG 1
#endif
#if !defined (LANG_GER)
      #define LANG_GER 0
#endif
#if !defined (LANG_FRE)
      #define LANG_FRE 0
#endif
#if !defined (CONVERT_TO_VAULT)
      #define CONVERT_TO_VAULT 0
#endif
#if !defined (VAULT_PROTECT)
      #define VAULT_PROTECT 1
#endif
#if !defined (DAYS_BEFORE_DELETE)
      #define DAYS_BEFORE_DELETE 14
#endif
#if !defined (MYSQL_AUTO_PRUNING)
      #define MYSQL_AUTO_PRUNING 0
#endif
#if !defined (VAULT_PRUNE_LIMIT)
      #define VAULT_PRUNE_LIMIT 5
#endif
#if !defined (SAVE_WITH_IP)
      #define SAVE_WITH_IP 0
#endif
#if !defined (XP_CHANGEABLE_OUTSIDE)
      #define XP_CHANGEABLE_OUTSIDE 0
#endif
#if !defined (SLAY_LOSERS)
      #define SLAY_LOSERS 0
#endif
#if !defined (STARTINGLEVEL)
      #define STARTINGLEVEL 0
#endif
#if !defined (BOMBPLANT_XP_BONUS)
      #define BOMBPLANT_XP_BONUS 6
#endif
#if !defined (DEFUSE_XP_BONUS)
      #define DEFUSE_XP_BONUS 6
#endif
#if !defined (HOSTAGE_XP_BONUS)
      #define HOSTAGE_XP_BONUS 6
#endif
#if !defined (KILLRESCUEMAN_XP_BONUS)
      #define KILLRESCUEMAN_XP_BONUS 6
#endif
#if !defined (KILL_BOMB_CARRIER)
      #define KILL_BOMB_CARRIER 6
#endif
#if !defined (VIP_KILL_BONUS)
      #define VIP_KILL_BONUS 6
#endif
#if !defined (VIP_ESCAPE_BONUS)
      #define VIP_ESCAPE_BONUS 6
#endif
#if !defined (TOME_XP_BONUS)
      #define TOME_XP_BONUS 20
#endif
#if !defined (HOSTAGE_TOUCH_BONUS)
      #define HOSTAGE_TOUCH_BONUS 1
#endif
#if !defined (ATTEMPT_DEFUSE_BONUS)
      #define ATTEMPT_DEFUSE_BONUS 1
#endif
#if !defined (HEADSHOT_BONUS)
      #define HEADSHOT_BONUS 3
#endif
#if !defined (DEFUSER_KILL_BONUS)
      #define DEFUSER_KILL_BONUS 1
#endif
#if !defined (BOMB_EVENT_BONUS)
      #define BOMB_EVENT_BONUS 0
#endif
#if !defined (VIP_SPAWN_BONUS)
      #define VIP_SPAWN_BONUS 0
#endif
#if !defined (BOMBSHAREXPRADIUS)
      #define BOMBSHAREXPRADIUS 1000
#endif
#if !defined (HOSTAGESHAREXPRADIUS)
      #define HOSTAGESHAREXPRADIUS 1000
#endif
#if !defined (OBJECTIVE_XP_PRINT)
      #define OBJECTIVE_XP_PRINT 1
#endif
#if !defined (HOSTAGE_KILL_MAX)
      #define HOSTAGE_KILL_MAX 3
#endif
#if !defined (HOSTAGE_KILL_SLAP)
      #define HOSTAGE_KILL_SLAP 1
#endif
#if !defined (HOSTAGE_KILL_XP)
      #define HOSTAGE_KILL_XP 1
#endif
#if !defined (FORGIVE_HOSTKILL_ROUND)
      #define FORGIVE_HOSTKILL_ROUND 1
#endif
#if !defined (HOSTAGE_TAX)
      #define HOSTAGE_TAX 0
#endif
#if !defined (WAR3STATS)
      #define WAR3STATS 0
#endif
#if !defined (WAR3_MYSQL_TOP15)
      #define WAR3_MYSQL_TOP15 0
#endif
#if !defined (XPLOIT_PROTECT)
      #define XPLOIT_PROTECT 4
#endif
#if !defined (OPT_RESETSKILLS)
      #define OPT_RESETSKILLS 1
#endif
#if !defined (ITEMS_DROPABLE)
      #define ITEMS_DROPABLE 1
#endif
#if !defined (ULTIMATESEARCHTIME)
      #define ULTIMATESEARCHTIME 50
#endif
#if !defined (ULTIMATE_WARMUP)
      #define ULTIMATE_WARMUP 10.0
#endif
#if !defined (ULTIMATE_READY_SOUND)
      #define ULTIMATE_READY_SOUND 0
#endif
#if !defined (ULTIMATE_READY_ICON)
      #define ULTIMATE_READY_ICON 1
#endif
#if !defined (ULTIMATE_FIRST_ROUND)
      #define ULTIMATE_FIRST_ROUND 1
#endif
#if !defined (EXPLOSION_RANGE)
      #define EXPLOSION_RANGE 200
#endif
#if !defined (WARN_SUICIDERS)
      #define WARN_SUICIDERS 1
#endif
#if !defined (EXPLOSION_MAX_DAMAGE)
      #define EXPLOSION_MAX_DAMAGE 75
#endif
#if !defined (TELEPORT_COOLDOWN)
      #define TELEPORT_COOLDOWN 20.0
#endif
#if !defined (KNIFEINVISIBILITY)
      #define KNIFEINVISIBILITY 70
#endif
#if !defined (BLINK_HUMAN_ULTIMATE)
      #define BLINK_HUMAN_ULTIMATE 1
#endif
#if !defined (RETRY_COOLDOWN)
      #define RETRY_COOLDOWN 3.0
#endif
#if !defined (BLINK_RADIUS)
      #define BLINK_RADIUS 250
#endif
#if !defined (CHAINLIGHTNING_COOLDOWN)
      #define CHAINLIGHTNING_COOLDOWN 40.0
#endif
#if !defined (LIGHTNING_DAMAGE)
      #define LIGHTNING_DAMAGE 50
#endif
#if !defined (ORCNECKLACE)
      #define ORCNECKLACE 1
#endif
#if !defined (ORCNADE_CVAR)
      #define ORCNADE_CVAR 0
#endif
#if !defined (NIGHTELF_DROPWEAPON)
      #define NIGHTELF_DROPWEAPON 0
#endif
#if !defined (ENTANGLEROOTS_COOLDOWN)
      #define ENTANGLEROOTS_COOLDOWN 40.0
#endif
#if !defined (SHADOWSTRIKE_DAMAGE)
      #define SHADOWSTRIKE_DAMAGE 10
#endif
#if !defined (SHADOWSTRIKE_DURATION)
      #define SHADOWSTRIKE_DURATION 10
#endif
#if !defined (SHADOWSTRIKE_COOLDOWN)
      #define SHADOWSTRIKE_COOLDOWN 40.0
#endif
#if !defined (MODIFIED_ULT_LEVEL)
      #define MODIFIED_ULT_LEVEL 0
#endif
#if !defined (UNDEAD_ULT)
      #define UNDEAD_ULT 6
#endif
#if !defined (HUMAN_ULT)
      #define HUMAN_ULT 6
#endif
#if !defined (ORC_ULT)
      #define ORC_ULT 6
#endif
#if !defined (ELF_ULT)
      #define ELF_ULT 6
#endif
#if !defined (BLOOD_ELF_ULT)
      #define BLOOD_ELF_ULT 6
#endif
#if !defined (XPRESET)
      #define XPRESET 0
#endif
#if !defined (RESETLEVEL)
      #define RESETLEVEL 7
#endif
#if !defined (MIN_RESET_LEVEL)
      #define MIN_RESET_LEVEL 5
#endif
#if !defined (RESET_XP_LEVEL_NOSAVE)
      #define RESET_XP_LEVEL_NOSAVE 6700
#endif
#if !defined (RESET_XP_LEVEL_SAVE)
      #define RESET_XP_LEVEL_SAVE 102400
#endif
#if !defined (GOD_BLESS_ROUNDNUM)
      #define GOD_BLESS_ROUNDNUM 4
#endif
#if !defined (BOMB_WARNINGS)
      #define BOMB_WARNINGS  0
#endif
#if !defined (VIP_EVENTS)
      #define VIP_EVENTS 0
#endif
#if !defined (HOSTAGE_EVENTS)
      #define HOSTAGE_EVENTS 0
#endif
#if !defined (SHOPMENU_IN_BUYZONE)
      #define SHOPMENU_IN_BUYZONE 1
#endif
#if !defined (SPAWN_PROTECT)
      #define SPAWN_PROTECT 0
#endif
#if !defined (NON_ULTIMATE_VIP)
      #define NON_ULTIMATE_VIP 1
#endif
#if !defined (MULTI_WEP_FIX)
      #define MULTI_WEP_FIX 1
#endif
#if !defined (DISABLE_FORCESKIN)
      #define DISABLE_FORCESKIN 1
#endif
#if !defined (DEBUG_LOGGER)
      #define DEBUG_LOGGER 0
#endif
#if !defined (TEST_MODE)
      #define TEST_MODE 0
#endif
#if !defined (TELEPORT_RESTRICTION)
      #define TELEPORT_RESTRICTION 0
#endif
#if !defined (TELEPORT_RESTRICTION_HEIGHT)
      #define TELEPORT_RESTRICTION_HEIGHT 60
#endif
#if !defined (TELEPORT_RESTRICTION_DISTANCE)
      #define TELEPORT_RESTRICTION_DISTANCE 1200
#endif

// End of configuration check

#if defined _amxmodx_included
        #include <engine>
	#include <fun>
        #include <cstrike>
	#if WC3_MODULE
		#define WC3_MODULE 0
	#endif
#else
        #if WC3_MODULE
                #include <war3>
        #else
                #include <Vexd_Utilities>
		#include <xtrafun>
        #endif
#endif
                                                                                 
// This makes sure the mysql from amx config gets loaded if the warcraft3 plugins uses mysql.
#if MYSQL_ENABLED
	#if defined _amxmodx_included
		new const PATHTOMYSQLCFG[] = "addons/amxx/configs/mysql.cfg"
	#else
        	new const PATHTOMYSQLCFG[] = "addons/amx/mysql.cfg"
        #endif
#endif
                                                                                                                        
#if !ULTIMATE_FIRST_ROUND
	new bool:first_round
#endif

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
#define TE_KILLPLAYERATTACHMENTS 125
#define BLASTCIRCLES_RADIUS 250
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

#define MAX_NAME_LENGTH 32
#define MAX_ID_LENGTH 32
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
#if BLINK_HUMAN_ULTIMATE
	new p_devotion[3] = {120,140,160}	// Devotion Aura (skill 2) (Teleport where aiming)
#else
	new p_devotion[3] = {125,150,175}	// Devotion Aura (skill 2) (Teleport to teammates)
#endif
new Float:p_bash[3] = {0.15,0.30,0.45}		// Bash (skill 3)

new Float:p_critical[3] = {0.15,0.15,0.15}	// Critical Strike (skill 1)
#if ORCNECKLACE
	new Float:p_grenade[3] = {2.0,3.0,5.0}	// Critical Grenade (skill 2) (Strength if necklace protects)
#else
	new Float:p_grenade[3] = {1.5,2.25,3.25}	// Critical Grenade (skill 2) (Strength if necklace dosen't protect)
#endif
new Float:p_ankh[3] = {0.333,0.666,1.0}		// Equipment reincarnation (skill 3)

new Float:p_evasion[3] = {0.1,0.2,0.3}		// Evasion (skill 1)
new Float:p_thorns[3] = {0.05,0.15,0.25}	// Thorns Aura (skill 2)
new Float:p_trueshot[3] = {0.13,0.27,0.40}	// Trueshot Aura (skill 3)

// blood elf skill identifiers 
new p_crimsonarmor[3] = {25,50,100}		// Crimson Armor (skill 1)
new Float:p_manashield[3] = {0.1,0.2,0.35}	// Mana Shield (skill 2)
new p_bloodlust[3] = {3,6,10}			// Bloodlust (skill 3)
new Float:p_bloodslow[3] = {210.0,190.0,170.0}	// bloodslow (slowed speed of enemies effected by bloodlust)

/* ---------------------------------- Exit Warcraft 3 configuration area 2--------------------------------------	*/		

#if SHORT_TERM && MYSQL_ENABLED
	Dont_have_short_term_AND_mysql__ = 0		// look at me, I create compiler errors
#endif
#if SHORT_TERM && VAULT_SAVE
	Dont_have_short_term_AND_vault__ = 0		// look at me, I create compiler errors
#endif
#if !defined _amxmodx_included
	#if ITEMS_DROPABLE && WC3_MODULE
		Items_dropable_requires_Vexd__ = 0		// look at me, I create compiler errors
	#endif
#endif
#if !SHORT_TERM
	#if MYSQL_ENABLED
		#include <mysql>
		new bool:needsSQLEntry[33]          // does player have an account?
		new mysql
		new mysqltablename[64]
	#else
		
#if VAULT_SAVE
			#include <vault>
			#if CONVERT_TO_VAULT
				new XPFILENAME[] = "war3users.ini"
			#endif
		#else
			new Float:lastupdate
			new savedline[64][128]
			new XPFILENAME[] = "war3users.ini"
		#endif
	#endif
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
	#if defined _amxmodx_included
		new logfilename[256] = "addons/amxx/logs/war3load.log"
		new logfile2[256] = "addons/amxx/logs/war3save.log"		
	#else
		new logfilename[256] = "addons/amx/logs/war3load.log"
		new logfile2[256] = "addons/amx/logs/war3save.log"
	#endif
#endif

new friend[33]
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

// reset countdown for ultimate when target isn't found
new reset_count[33]

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
new bool:p_spectator[33]
#if ITEMS_DROPABLE
	new bool:canpickup[33]
#endif
#if !WC3_MODULE || defined _amxmodx_included
	new const HEGRENADE_MODEL[] = "models/w_hegrenade.mdl"
#endif
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
new bool:showicons[33]
new bool:warcraft3
new bool:saved_xp

new vip_id 			// blood elves VIP armor check
new rest_countdown[33]		// blood elves code

#if !BLINK_HUMAN_ULTIMATE
	new bool:endround
#endif

new Float:voting
new Float:vote_ratio
new Float:fExplodeTime
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
new race_0
new race_1
new race_2
new race_3
new race_4
new race_5

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
#if LANG_ENG
	new racename[6][] = {"No race","Undead Scourge","Human Alliance","Orcish Horde","Night Elves of Kalimdor", "Lordaeron Blood Elves"}
	new shortracename[6][] = {"No race","Undead", "Human", "Orc", "Night Elf", "Blood Elf"}

	new itemname[9][] = {"Item: Ankh","Item: Boots","Item: Claws","Item: Cloak","Item: Mask","Item: Necklace","Item: Orb","Item: Periapt","Item: Tome"}
	new longItemName[9][] = {"Ankh of Reincarnation","Boots of Speed","Claws of Attack +6","Cloak of Shadows","Mask of Death","Necklace of Immunity","Orb of Frost","Periapt of Health","Tome of Experience"}

	new race1skill[4][] = {"Vampiric Aura","Unholy Aura","Levitation","Suicide Bomber"}
	new race2skill[4][] = {"Invisibility","Devotion Aura","Bash","Teleport"}
	new race3skill[4][] = {"Critical Strike","Critical Grenade","Equipment Reincarnation","Chain Lightning"}
	new race4skill[4][] = {"Evasion","Thorns Aura","Trueshot Aura","Entangle Roots"}
	new race5skill[4][] = {"Crimson Armor","Mana Shield","Bloodlust","Shadowstrike"}
#endif
#if LANG_GER
        new racename[6][] = {"Keine Rasse","Untote Plage","Menschliche Allianz","Orkische Horde","Nachtelfen von Kalimdor","Lordaeron Blut Elfen"}
        new shortracename[6][] = {"Keine Rasse","Untote","Menschen","Orks","Nachtelfen","Blutelfen"}

        new itemname[9][] = {"Item: Ankh","Item: Stiefel","Item: Klauen","Item: Mantel","Item: Maske","Item: Halskette","Item: Frost","Item: Gesundheit","Item: Erfahrung"}
        new longItemName[9][] = {"Ankh der Reinkarnation","Stiefel der Geschwindigkeit","Klauen des Angriffs +6","Mantel des Schattens","Maske des Todes","Halskette der Immunitaet","Frostkugel","Gesundheitsstein","Buch der Erfahrung"}

	new race1skill[4][] = {"Vampir Aura","Unheilige Aura","Schweben","Selbstmord-Bomber"}
	new race2skill[4][] = {"Unsichtbarkeit","Hingabe Aura","Hieb","Teleportieren"}
	new race3skill[4][] = {"Kritische Treffer","Kritische Granaten","Ausruestungs Reinkarnation","Kettenblitz"}
	new race4skill[4][] = {"Ausweichen","Dornen Aura","Schadens Aura","Wucherwurzeln"}
        new race5skill[4][] = {"Blutrote Ruestung","Mana Schild","Blutrausch","Schattenstoss"}
#endif
#if LANG_FRE
	new racename[6][] = {"Aucune Race","Le Fleau des Morts Vivants","L'Alliance Humaine","L'Horde des Orc","Elfes de la Nuit de Kalimdor", "Elfes Sanguinaire de Lordaeron"}
	new shortracename[6][] = {"Aucune Race","Mort Vivant","Humain","Orc","Elfes de la Nuit","Elfes Sanguinaire"}

	new itemname[9][] = {"Objet: Ankh","Objet: Boots","Objet: Claws","Objet: Cloak","Objet: Mask","Objet: Necklace","Objet: Orb","Objet: Periapt","Objet: Tome"}
	new longItemName[9][] = {"Ankh de Reincarnation","Bottes de Vitesse","Griffes d'Attaque +6","Manteau d'Ombres","Masque de Mort","Collier d'Immunite","Orbe de Glace","Amulette de Vie","Tome d'Experience"}

	new race1skill[4][] = {"Aura Vampirique","Aura Impie","Levitation","Kamikaze"}
	new race2skill[4][] = {"Invisibilite","Aura de Devotion ","Bash","Teleportation"}
	new race3skill[4][] = {"Coup Critique","Grenade Ultime","Reincarnation de l'Equipement","Chaine d'Eclairs"}
	new race4skill[4][] = {"Esquive","Aura d'Epines","Aura de Degats ","Racines Agripantes"}
	new race5skill[4][] = {"Armure Enchanter","Mana de Protection","La soif de Sang","L'ombre de frappe"}
#endif
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
        #if STEAM_POWERED
		weaponxpmultiplier[CSW_FAMAS] = 1.0
	        weaponxpmultiplier[CSW_GALI] = 1.0        
       	#endif
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
	fExplodeTime = get_gametime() + get_cvar_float( "mp_c4timer" )
   	 #if BOMB_WARNINGS
		#if LANG_ENG
        		format(sMsg,MAX_TEXT_LENGTH,"%s planted the bomb!",sName) 
		#endif
		#if LANG_GER
        		format(sMsg,MAX_TEXT_LENGTH,"%s hat die Bombe gelegt!",sName) 
		#endif
		#if LANG_FRE
        		format(sMsg,MAX_TEXT_LENGTH,"%s a ammorce la bombe!",sName) 
		#endif		
         	display_msg(sMsg,255,0,0,EVENT_MSG_ALL) 
        
               	new parmB[2]
            	gBombTimer = get_cvar_num("mp_c4timer")
            	 
            	// Why Denkkar why? Well... umm... it's accurate at least ;-)
		// rotflmao *gg* ok, nice.
            	if( gBombTimer > 40 ){             		             		         
            		parmB[0] = 40 	
            		//  (Float:time,const function[],id = 0,parameter[]="",len = 0,flags[]="", repeat = 0);	
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
		#if LANG_ENG
			client_print(id,print_chat, "[WC3] %s recieved %d extra XP for personally planting the bomb.",sName,temp)
		#endif
		#if LANG_GER
			client_print(id,print_chat, "[WC3] %s bekam %d extra XP fuer das legen der Bombe.",sName,temp)
		#endif
		#if LANG_FRE
			client_print(id,print_chat, "[WC3] %s a recu %d XP supplementaires pour avoir personnellement amorce la bombe.",sName,temp)
		#endif		
	#endif	
			
	
	for (new i=0; i<numplayers; ++i){
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if ((get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS) &&(targetid != id)){
			
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
				get_user_name(targetid,sName,MAX_NAME_LENGTH-1)	
				//set_hudmessage(0, 160, 97, -1.05, 0.85, 2, 6.0, 15.0, 0.2, 0.3,101);
				//show_hudmessage(targetid,"^n +%d XP for bomb plant support",temp );					
				#if LANG_ENG
					client_print(targetid,print_chat, "[WC3] %s recieved %d for supporting the bomb planting effort.",sName,temp)
				#endif
				#if LANG_GER
					client_print(targetid,print_chat, "[WC3] %s bekam %d XP fuer das helfen beim legen der Bombe.",sName,temp)
				#endif
				#if LANG_FRE				
					client_print(id,print_chat, "[WC3] %s a recu %d pour avoir couvert la pose de la bombe.",sName,temp)
				#endif				
			#endif					
		}
		displaylevel(targetid, 1)
	}
   } 
   
   // Bomb defused 
   else if (equal(sAction,"Defused_The_Bomb")) { 
      	#if BOMB_WARNINGS
		#if LANG_ENG
	         	format(sMsg,MAX_TEXT_LENGTH,"%s defused the bomb with approximately %d seconds left!",sName,gBombTimer) 
		#endif
		#if LANG_GER
	         	format(sMsg,MAX_TEXT_LENGTH,"%s entschaerfte die Bombe mit ungefaehr %d sekunden uebrig!",sName,gBombTimer) 
		#endif
		#if LANG_FRE
	         	format(sMsg,MAX_TEXT_LENGTH,"%s a desamorce la bombe avec %d secondes restantes!",sName,gBombTimer) 
		#endif		
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
		#if LANG_ENG
			client_print(id,print_chat, "[WC3] %s recieved %d extra XP for defusing the bomb.",sName,temp)
		#endif
		#if LANG_GER
			client_print(id,print_chat, "[WC3] %s bekam %d extra XP fuer das entschaerfen der Bombe.",sName,temp)
		#endif
		#if LANG_FRE
			client_print(id,print_chat, "[WC3] %s a recu %d XP supplementaires pour avoir desamorce la bombe.",sName,temp)
		#endif		
	#endif	
	
	
		
	for (new i=0; i<numplayers; ++i){
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS &&(targetid != id)){
			
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
				#if LANG_ENG
					client_print(targetid,print_chat, "[WC3] %s recieved %d for supporting the bomb defusing effort.",sName,temp)
				#endif
				#if LANG_GER
					client_print(targetid,print_chat, "[WC3] %s bekam %d fuer das helfen beim entschaerfen der Bombe.",sName,temp)
				#endif
				#if LANG_FRE
					client_print(targetid,print_chat, "[WC3] %s a recu %d pour avoir couvert le desamorcage de la bombe.",sName,temp)
				#endif				
			#endif					
		}
		displaylevel(targetid, 1)
	}		
   } 
   // Bomb defusing with a kit 
   else if (equal(sAction,"Begin_Bomb_Defuse_With_Kit")) { 
      #if BOMB_WARNINGS
	 #if LANG_ENG
         	format(sMsg,MAX_TEXT_LENGTH,"%s is defusing the bomb with a wire cutter...^n",sName) 
	 #endif
	 #if LANG_GER
         	format(sMsg,MAX_TEXT_LENGTH,"%s entschaerft die Bombe mit einen Seitschschneider...^n",sName) 
	 #endif
	 #if LANG_FRE
         	format(sMsg,MAX_TEXT_LENGTH,"%s desamorce la bombe avec un kit de desamorcage...^n",sName) 
	 #endif	 
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
				#if LANG_ENG
					client_print(id,print_chat, "[WC3] %s recieved %d XP for cutting the red wire on the bomb.",sName,temp)
				#endif
				#if LANG_GER
					client_print(id,print_chat, "[WC3] %s bekam %d XP fuer das entschaerfen der Bombe.",sName,temp)
				#endif
				#if LANG_FRE
					client_print(id,print_chat, "[WC3] %s a recu %d XP pour avoir desamorce la Bombe.",sName,temp)
				#endif
			#endif	 
			displaylevel(id, 1)  
               }
               

	#endif
   } 
   // Bomb defusing without a kit 
   else if (equal(sAction,"Begin_Bomb_Defuse_Without_Kit")) { 
      #if BOMB_WARNINGS
	 #if LANG_ENG
         	format(sMsg,MAX_TEXT_LENGTH,"%s is defusing the bomb with his bare hands...^n",sName) 
	 #endif
	 #if LANG_GER
         	format(sMsg,MAX_TEXT_LENGTH,"%s entschaerft die Bombe ohne Werkzeuge ...^n",sName) 
	 #endif
 	 #if LANG_FRE
         	format(sMsg,MAX_TEXT_LENGTH,"%s desamorce la bombe a mains nues...^n",sName) 
	 #endif	 
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
				#if LANG_ENG
					client_print(id,print_chat, "[WC3] %s recieved %d XP for attempting to defuse bare handed.^n",id,temp)
				#endif
				#if LANG_GER
					client_print(id,print_chat, "[WC3] %s bekam %d XP fuer den Versuch ohne Werkzeuge die Bombe zu entschaerfen.^n",id,temp)
				#endif
				#if LANG_FRE
					client_print(id,print_chat, "[WC3] %s a recu %d XP pour avoir essaye de desamorcer la bombe a mains nues.^n",id,temp)
				#endif				
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
			#if LANG_ENG
				client_print(id,print_chat, "[WC3] %s recieved %d XP for spawning with the bomb.",sName,temp)
			#endif
			#if LANG_GER
				client_print(id,print_chat, "[WC3] %s bekam %d XP als Bombentraeger.",sName,temp)
			#endif
			#if LANG_FRE
				client_print(id,print_chat, "[WC3] %s a recu %d XP pour etre apparu avec la bombe.",sName,temp)
			#endif			
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
			#if LANG_ENG
				client_print(id,print_chat, "[WC3] %s lost the %d XP bomb carrying bonus.",sName,temp)
			#endif
			#if LANG_GER
				client_print(id,print_chat, "[WC3] %s verlor die %d XP Bombentraeger Bonus.",sName,temp)
			#endif
			#if LANG_FRE
				client_print(id,print_chat, "[WC3] %s a perdu les %d XP de bonus pour avoir perdu la bombe.",sName,temp)
			#endif
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
			#if LANG_ENG
				client_print(id,print_chat, "[WC3] %s gained %d XP for picking up the bomb.",sName,temp)
			#endif
			#if LANG_GER
				client_print(id,print_chat, "[WC3] %s bekam %d XP fuer das Aufheben der Bombe.",sName,temp)
			#endif
			#if LANG_FRE
				client_print(id,print_chat, "[WC3] %s a gagne %d XP pour avoir ramasse la bombe.",sName,temp)
			#endif			
		#endif	 
		displaylevel(id, 1)  
                         
	#endif
   } 
   // Hostage touched 
   else if (equal(sAction,"Touched_A_Hostage")) { 
      #if HOSTAGE_EVENTS
	 #if LANG_ENG
            format(sMsg,MAX_TEXT_LENGTH,"%s found a hostage!",sName) 
	 #endif
	 #if LANG_GER
            format(sMsg,MAX_TEXT_LENGTH,"%s hat einen Geisel gefunden!",sName) 
	 #endif
	 #if LANG_FRE
            format(sMsg,MAX_TEXT_LENGTH,"%s a trouve un otage!",sName) 
	 #endif	 
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
			#if LANG_ENG
				client_print(id,print_chat, "[WC3] %s recieved %d XP for beginning to escort the hostage to safety.",sName,temp)
			#endif
			#if LANG_GER
				client_print(id,print_chat, "[WC3] %s bekam %d XP fuer das mitnehmen einer Geisel.",sName,temp)
			#endif
			#if LANG_FRE
				client_print(id,print_chat, "[WC3] %s a recu %d XP pour avoir commence a escorter un otage.",sName,temp)
			#endif			
		#endif			
		
		displaylevel(id, 1)		
	
	#endif
   } 
   // Hostage rescued 
   else if (equal(sAction,"Rescued_A_Hostage")) { 
      #if HOSTAGE_EVENTS 
	 #if LANG_ENG
           format(sMsg,MAX_TEXT_LENGTH,"%s rescued a hostage!",sName) 
	 #endif
	 #if LANG_GER
           format(sMsg,MAX_TEXT_LENGTH,"%s rettete einen Geisel!",sName) 
	 #endif
	 #if LANG_FRE
           format(sMsg,MAX_TEXT_LENGTH,"%s a secouru un otage!",sName) 
	 #endif
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
	#if HOSTAGE_TAX
	#if XPLOIT_PROTECT						
		if( antiExploit ){
			temp = -1 *  xpgiven[p_level[id]]
		}																
	#else
		temp = -1 *  xpgiven[p_level[id]]												
	#endif
		
	playerxp[id]+=  temp
			
	#if OBJECTIVE_XP_PRINT								
		#if LANG_ENG
			client_print(id,print_chat, "[WC3] %s lost %d XP to the hostage theif tax.",sName,temp)
		#endif 
		#if LANG_GER
			client_print(id,print_chat, "[WC3] %s verlor %d XP an den Geisel Dieb Steuer..",sName,temp)
		#endif
		#if LANG_FRE
			client_print(id,print_chat, "[WC3] %s a perdu %d XP pour avoir vole un otage.",sName,temp)
		#endif		 
	#endif	
	#endif	
	for (new i=0; i<numplayers; ++i){		
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS &&(targetid != id)){
			
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
				#if LANG_ENG
					client_print(targetid,print_chat, "[WC3] %s recieved %d XP for supporting the hostage run.",sName,temp)
				#endif
				#if LANG_GER
					client_print(targetid,print_chat, "[WC3] %s bekam %d XP fuer das unterstuetzen der Geiselrettung.",sName,temp)
				#endif
				#if LANG_FRE
					client_print(targetid,print_chat, "[WC3] %s a recu %d XP pour avoir couvert le sauvetage des otages.",sName,temp)
				#endif				
			#endif					
		}				
	}				
	displaylevel(targetid, 1)
      
   } 
   // Hostage killed 
   else if (equal(sAction,"Killed_A_Hostage")) { 
     	#if HOSTAGE_EVENTS
	    #if LANG_ENG
            	format(sMsg,MAX_TEXT_LENGTH,"%s killed a hostage!",sName) 
	    #endif
	    #if LANG_GER
            	format(sMsg,MAX_TEXT_LENGTH,"%s toetete einen geisel!",sName) 
	    #endif
	    #if LANG_FRE
            	format(sMsg,MAX_TEXT_LENGTH,"%s a tue un otage!",sName) 
	    #endif	    
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
			#if LANG_ENG
				client_print(0,print_chat, "[WC3] %s will be punished for killing hostages.",sName)	
			#endif
			#if LANG_GER
				client_print(0,print_chat, "[WC3] %s wird bestraft fuer das Toeten von Geiseln.",sName)	
			#endif
			#if LANG_FRE
				client_print(0,print_chat, "[WC3] %s va etre puni pour avoir tue un otage.",sName)	
			#endif			
		}else {
			client_cmd(id,"spk scientist/stopattacking.wav")
			user_slap(id,1)
			#if LANG_ENG
				client_print(0,print_chat, "[WC3] %s was lightly slapped for killing a hostage.",sName)				
			#endif
			#if LANG_GER
				client_print(0,print_chat, "[WC3] %s wurde dezent geschlagen fuer das Toeten von Geiseln.",sName)				
			#endif
			#if LANG_FRE
				client_print(0,print_chat, "[WC3] %s a ete gifle pour avoir tue un otage.",sName)				
			#endif			
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
				#if LANG_ENG
					client_print(id,print_chat, "[WC3] %s lost %d XP for killing a hostage.",sName,temp)		
				#endif
				#if LANG_GER
					client_print(id,print_chat, "[WC3] %s verlor %d XP fuer das Toeten von Geiseln.",sName,temp)		
				#endif
				#if LANG_FRE
					client_print(id,print_chat, "[WC3] %s a perdu %d XP pour avoir tue un otage.",sName,temp)		
				#endif				
			#endif
		}		
	#endif	
		
			
	displaylevel(id, 1)
   } 
   // VIP spawn 
   else if (equal(sAction,"Became_VIP")) { 
      #if VIP_EVENTS
	 #if LANG_ENG
         	format(sMsg,MAX_TEXT_LENGTH,"%s has become the VIP!",sName) 
	 #endif
	 #if LANG_GER
         	format(sMsg,MAX_TEXT_LENGTH,"%s ist jetzt ein VIP!",sName) 
	 #endif
	 #if LANG_FRE
         	format(sMsg,MAX_TEXT_LENGTH,"%s est le bienvenu comme VIP!",sName) 
	 #endif
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
			#if LANG_ENG
				client_print(id,print_chat, "[WC3] %s recieved %d XP for being so important.",sName,temp)
			#endif
			#if LANG_GER
				client_print(id,print_chat, "[WC3] %s bekam %d XP weil er so wichtig ist.",sName,temp)
			#endif
			#if LANG_FRE
				client_print(id,print_chat, "[WC3] %s a recu %d XP pour etre aussi important.",sName,temp)
			#endif			
		#endif			
		
		displaylevel(id, 1)		
	
	#endif
      
	} 
	// VIP assassinated 
	else if (equal(sAction,"Assassinated_The_VIP")) { 
		new sNameVIP[MAX_NAME_LENGTH] 
		get_user_name( vipID,sNameVIP,MAX_NAME_LENGTH-1) 		
	#if VIP_EVENTS             
		#if LANG_ENG
			format(sMsg,MAX_TEXT_LENGTH,"%s assassinated %s the VIP!",sName,sNameVIP) 
		#endif
		#if LANG_GER
			format(sMsg,MAX_TEXT_LENGTH,"%s toetete %s den VIP!",sName,sNameVIP) 
		#endif
		#if LANG_FRE
			format(sMsg,MAX_TEXT_LENGTH,"%s a assassine le VIP %s !",sName,sNameVIP) 
		#endif
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
			#if LANG_ENG
				client_print(id,print_chat, "[WC3] %s gained %d XP for assinating %s the VIP.",sName,sNameVIP) 
			#endif
			#if LANG_GER
				client_print(id,print_chat, "[WC3] %s bekam %d XP fuer das toeten von %s den VIP.",sName,sNameVIP) 
			#endif
			#if LANG_FRE
				client_print(id,print_chat, "[WC3] %s a gagne %d XP pour avoir assassine le VIP %s.",sName,sNameVIP) 
			#endif			
		#endif			
		
		displaylevel(id, 1)		
	
	#endif
   } 
	// VIP escaped 
	else if (equal(sAction,"Escaped_As_VIP")) { 		
		#if VIP_EVENTS 
			#if LANG_ENG
	         		format(sMsg,MAX_TEXT_LENGTH,"%s the VIP has escaped!",sName) 
			#endif
			#if LANG_GER
	         		format(sMsg,MAX_TEXT_LENGTH,"Der VIP %s ist entkommen!",sName) 
			#endif
			#if LANG_FRE
	         		format(sMsg,MAX_TEXT_LENGTH,"Le VIP %s a reussi a s'echapper!",sName) 
			#endif			
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
		new nName[MAX_NAME_LENGTH]		
		//set_hudmessage(0, 160, 97, -1.45, 0.85, 2, 6.0, 15.0, 0.2, 0.3,100);
		//show_hudmessage(targetid,"+%d XP for personally planting the bomb",temp );						
		#if LANG_ENG
			client_print(id,print_chat, "[WC3] %s gained %d extra XP for evading assasination.",sName,temp)
		#endif
		#if LANG_GER
			client_print(id,print_chat, "[WC3] %s bekam %d extra XP weil er den Attentat entkam.",sName,temp)
		#endif
		#if LANG_FRE
			client_print(id,print_chat, "[WC3] %s a gagne %d XP supplementaires pour avoir reussi a s'echapper.",sName,temp)
		#endif		
	#endif	
			
	
	for (new i=0; i<numplayers; ++i){
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS &&(targetid != id)){
			
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
				get_user_name(targetid,nName,MAX_NAME_LENGTH-1)	
				//set_hudmessage(0, 160, 97, -1.05, 0.85, 2, 6.0, 15.0, 0.2, 0.3,101);
				//show_hudmessage(targetid,"^n +%d XP for bomb plant support",temp );					
				#if LANG_ENG
					client_print(targetid,print_chat, "[WC3] %s recieved %d XP for helping the %s escape.",nName,temp,sName)
				#endif
				#if LANG_GER
					client_print(targetid,print_chat, "[WC3] %s bekam %d XP weil er %s beim Flucht half.",nName,temp,sName)
				#endif
				#if LANG_FRE
					client_print(targetid,print_chat, "[WC3] %s a recu %d XP pour avoir aide le VIP %s a s'echapper.",nName,temp,sName)
				#endif				
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


#if XPRESET 
public xp_loss_scream1(ids[]){	
	client_cmd(0,"spk scientist/scream04.wav") // Player notices XP loss... initial scream
	return PLUGIN_CONTINUE
}

public xp_loss_scream2(ids[]){	
#if LANG_ENG
	client_cmd(ids[0],"say OMG, my XP!!! My XP is gone!") // Makes player scream with real gusto
#endif
#if LANG_GER
	client_cmd(ids[0],"say Oh Gott, mein XP!!! Mein XP ist weg!") // Makes player scream with real gusto
#endif
#if LANG_FRE
	client_cmd(ids[0],"say Mon dieu !!!, Mon XP!!! Mon XP s'est envole!") // Makes player scream with real gusto
#endif
	client_cmd(0,"spk scientist/scream20.wav")	
	return PLUGIN_CONTINUE
}

public xp_loss_laughter(ids[]){	
#if LANG_ENG
	client_cmd(ids[0],"say Noooo! Noooooooooooooooo!") // Player is in denial
#endif
#if LANG_GER
	client_cmd(ids[0],"say Neeeiiiin! Neeeeeeiiiiiiinnnnnn!") // Player is in denial
#endif
#if LANG_FRE
	client_cmd(ids[0],"say Noooon! Noooooooooooooooon!") // Player is in denial
#endif
	client_cmd(0,"spk hgrunt/c2a3_hg_laugh.wav")
	return PLUGIN_CONTINUE
}

public xp_reset_rise(ids[]){
	new id = ids[0]
	new name[MAX_NAME_LENGTH]
	get_user_name( id, name,MAX_NAME_LENGTH-1)		
	set_user_maxspeed(id,0.0)
	set_user_gravity(id,-0.0001)
	set_user_health(id, 5000)	
	client_cmd(id,"+jump")
	#if LANG_ENG
		client_print(id,print_chat, "[GOD] Come on up %s and we'll discuss the XP reset.",name)
	#endif
	#if LANG_GER
		client_print(id,print_chat, "[GOTT] Komm mal zu mir hoch %s und wir diskutieren den XP Reset.",name)
	#endif
	#if LANG_FRE
		client_print(id,print_chat, "[DIEU] Reviens vers moi %s et nous discuterons de ton XP.",name)
	#endif
	return PLUGIN_CONTINUE
}

public xp_reset_heaven(ids[]){
	new id = ids[0]	
	new name[MAX_NAME_LENGTH]
	new keys = (1<<0) | (1<<1)
	
	get_user_name( id, name,MAX_NAME_LENGTH-1)
	#if LANG_ENG
		client_print(id,print_chat, "[GOD] I realize I've been harsh on you %s, so I'll grant you your greatest wish.",name)
	#endif
        #if LANG_GER
		client_print(id,print_chat, "[GOTT] Ich gestehe, ich war zu Streng zu dir %s, Ich gebe dir sein sehnigster Wunsch.",name)
	#endif
        #if LANG_FRE
		client_print(id,print_chat, "[DIEU] Je me rends compte que j'ai ete dur avec toi %s, donc je t'accorderai ton plus grand desir ..",name)
	#endif	
	client_cmd(id,"-jump;wait;wait;-jump")
		

	
	
	if (is_user_bot(id)){
		playerxp[id] = 0
		return PLUGIN_HANDLED
	}

	new menu_msg[256]	
	#if LANG_ENG
		format(menu_msg,255,"Your Wish Is:\w^n^n1. Give back level %d ^n2. Roll the dice for level", RESETLEVEL)
	#endif
	#if LANG_GER
		format(menu_msg,255,"Dein Wunsch:\w^n^n1. Gib mir Level %d ^n2. Wuerfele eine Level", RESETLEVEL)
	#endif
	#if LANG_FRE
		format(menu_msg,255,"Quel est ton desir ?\w^n^n1. De retrouver ton niveau %d. ^n2. De jeter les des pour ton niveau.", RESETLEVEL)
	#endif	
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
			#if LANG_ENG
				client_print(id,print_chat, "[GOD] My poor son, the dice granted you only level %d, let me roll again for you.", temp)
			#endif
			#if LANG_GER
				client_print(id,print_chat, "[GOTT] Mein Sohn, die Wuerfe gaben dir nur Level %d, lass mich mal fuer dich wuerfeln.", temp)
			#endif
			#if LANG_FRE
				client_print(id,print_chat, "[Dieu] Mon pauvre fils, les des t'ont accorde seulement le niveau %d, me laisses-tu retirer les des de nouveau pour toi.", temp)
			#endif			
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
		
		
	new name[MAX_NAME_LENGTH]
	get_user_name( id, name,MAX_NAME_LENGTH-1)
	#if LANG_ENG
		client_print(id,print_chat, "[GOD] %s, go kick ass now with my holy blessing!",name)
	#endif
	#if LANG_GER
		client_print(id,print_chat, "[GOTT] %s, gehe nun und trete den anderen in den hintern!",name)
	#endif
	#if LANG_FRE
		client_print(id,print_chat, "[DIEU] %s, va botter des fesses maintenant avec ma sainte benediction!",name) // ici dieu donne un ordre au joueur 
	#endif	
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
	new name[MAX_NAME_LENGTH]
	get_user_name( godid, name,MAX_NAME_LENGTH-1)

	
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
	
	if (id==0 || !(p_skills[id][0]>0) || !(p_skills[id][0]<6))
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
		new resetplayername[MAX_NAME_LENGTH]
		new ids[2] 	
		get_user_name(id,resetplayername,MAX_NAME_LENGTH-1)
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
			#if LANG_ENG
				client_print(0,print_chat, "[WC3] %s level 11 %s is too strong for us and has been exiled.",resetplayername,shortracename[p_skills[id][0]])	
			#endif
			#if LANG_GER
				client_print(0,print_chat, "[WC3] %s ist Level 11 %s und zu stark fuer uns, er wird ins Exil geschickt.",resetplayername,shortracename[p_skills[id][0]])	
			#endif
			#if LANG_FRE
				client_print(0,print_chat, "[WC3] %s a atteint le niveau 11 en %s, il est trop fort pour nous donc il a ete banni.",resetplayername,shortracename[p_skills[id][0]])	
			#endif			
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
		#if LANG_ENG
		show_hudmessage(id,"You gained a Level")
		#endif
		#if LANG_GER
		show_hudmessage(id,"Du bist ein Level aufgestiegen")
		#endif
		#if LANG_FRE
		show_hudmessage(id,"Tu as gagne un niveau.")
		#endif
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
		#if LANG_ENG
		show_hudmessage(id,"You lost a Level")
		#endif
		#if LANG_GER
		show_hudmessage(id,"Du hast ein Level verloren")
		#endif
		#if LANG_FRE
		show_hudmessage(id,"Tu as perdu un niveau")
		#endif
		
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
			else if (p_skills[id][0] == 5){
				copy(skillcurrentrace[skillcounter],63,race5skill[skillcounter])
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

//		set_hudmessage(255, 255, 255, -1.0, 0.3, 0, 3.0, 5.0, 0.1, 0.2, 2)
//		show_hudmessage(id,message)
		client_print(id,print_chat,message)
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
	#if ITEMS_DROPABLE
		wc3_dropitem(victim_id)
	#endif
	

	if (!(killer_id==victim_id && !headshot && equal(weaponname,"world"))){
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(killer_id)
		write_byte(victim_id)
		write_byte(headshot)
		write_string(weaponname)
		message_end()
	}
	
	#if ULTIMATE_FIRST_ROUND
	if (p_skills[victim_id][0]==1 && p_skills[victim_id][4] && !changingteam[victim_id] && !ultimateused[victim_id] ){	// Suicide Bomber
	#else
	if (p_skills[victim_id][0]==1 && p_skills[victim_id][4] && !changingteam[victim_id] && !ultimateused[victim_id] && first_round == false){	// Suicide Bomber
	#endif
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

	diedlastround[victim_id]=true
	
	for (new i=0; i<32; ++i)
	{		// Equipment Reincarnation reset
		savedweapons[victim_id][i]=0
	}
			
	savednumber[victim_id]=0
	
	if ((p_skills[victim_id][0] == 3 && p_skills[victim_id][3]) || playeritem[victim_id]==ANKH) // If you're an orc or have an Ankh of Reincarnation...
	{		
		armorondeath[victim_id]=get_user_armor(victim_id)
		get_user_weapons(victim_id,savedweapons[victim_id],savednumber[victim_id])
	}
	else
	{
		new team[32]
		savednumber[victim_id]=1
		get_user_team(victim_id,team,31)
		if(!contain(team,"CT"))
			savedweapons[victim_id][0]=CSW_USP
		else if(!contain(team,"TERRORIST"))
			savedweapons[victim_id][0]=CSW_GLOCK18
	}

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
						new killersname[MAX_NAME_LENGTH]
						get_user_name(killer_id,killersname,MAX_NAME_LENGTH-1)						
						#if LANG_ENG
							client_print(killer_id,print_chat, "[WC3] %s recieved %d XP for killing the hostage rescuer.",killersname,temp)
						#endif
						#if LANG_GER
							client_print(killer_id,print_chat, "[WC3] %s bekam %d XP fuer das Toeten vom Geiseln retter.",killersname,temp)
						#endif
						#if LANG_FRE
							client_print(killer_id,print_chat, "[WC3] %s a recu %d XP pour avoir tue le sauveteur d'otages.",killersname,temp)
						#endif						
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
						new killersname[MAX_NAME_LENGTH]
						get_user_name(killer_id,killersname,MAX_NAME_LENGTH-1)						
						#if LANG_ENG
							client_print(killer_id,print_chat, "[WC3] %s recieved %d XP for killing the bomb defuser.",killersname,temp)
						#endif
						#if LANG_GER
							client_print(killer_id,print_chat, "[WC3] %s bekam %d XP fuer das Toeten vom Bomben entschaerfer.",killersname,temp)
						#endif
						#if LANG_FRE
							client_print(killer_id,print_chat, "[WC3] %s a recu %d XP pour avoir tue le CT qui desamorcait.",killersname,temp)
						#endif						
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
						new killersname[MAX_NAME_LENGTH]
						get_user_name(killer_id,killersname,MAX_NAME_LENGTH-1)						
						#if LANG_ENG
							client_print(killer_id,print_chat, "[WC3] %s recieved %d XP for killing the bomb carrier.",killersname,temp)
						#endif
						#if LANG_GER
							client_print(killer_id,print_chat, "[WC3] %s bekam %d XP fuer das Toeten vom Bombentraeger.",killersname,temp)
						#endif
						#if LANG_FRE
							client_print(killer_id,print_chat, "[WC3] %s a recu %d XP pour avoir tue le poseur de bombe.",killersname,temp)
						#endif						
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
	new parmF[1]
	parmF[0]=id
	stunned[id]=false
	slowed[id]=false
	hasgrenade[id]=false
	
	issearching[id]=false // if player is searching when the round ends, this resets that value to 0
	freezetime = 1
	set_task(get_cvar_float("mp_freezetime"),"freezetimedone",66323+id,parmF,1)
	
	// remove tasks for shadowstrike (blood elf ult) if a new round starts
	remove_task(8000+id)
	remove_task(89+id)
	remove_task(99180)
	
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
	
	#if WAR3STATS
		reset_stats()
	#endif	
	#if ITEMS_DROPABLE
		canpickup[id] = true
		new stray_items = 0
		do {
			#if defined _amxmodx_included			
	                        stray_items = find_ent_by_class(stray_items,"wc3item")
				if(stray_items > 0)
					remove_entity(stray_items)
			#else
	                        stray_items = find_entity(stray_items,classname,"wc3item")
				if(stray_items > 0)
					RemoveEntity(stray_items)
			#endif
		}
		while(stray_items)
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
		set_user_maxspeed(id, 1.0)
	#endif
	
	
	#if ORCNADE_CVAR
		if( get_cvar_num("mp_alloworcnade") == 0 ){
			set_hudmessage(178, 14, 41, -1.0, 0.90, 2, 6.0, 15.0, 0.2, 0.3,4);
			#if LANG_ENG
				show_hudmessage(id,"Orc Grenades Off^nNormal Damage Only" );	
			#endif
			#if LANG_GER
				show_hudmessage(id,"Orc Granaten Ausgeschaltet^nNormaler Schaden" );	
			#endif
			#if LANG_FRE
				show_hudmessage(id,"Les Grenades des Orcs sont desactivees^nDommages normaux seulement" );	
			#endif
			//client_print(id,print_chat, "[WC3] WARNING: Orc grenades are disabled on this map.")
		}
	#endif
	
	#if XPRESET
		new ids[2]
                ids[0] = id
                if (resetedPlayerID[id] ){                	
                	resetedPlayerID[id] = 0
                	set_task(1.0,"xp_reset_rise",11004,ids,1,"a", 0)       
                	set_task(8.0,"xp_reset_heaven",11005,ids,1,"a", 0)  
                	return PLUGIN_CONTINUE                  	
                }else if( godBlessed[id] > 1 ){
                	godBlessed[id] -= 1
                	xp_reset_godmode(ids[0])	                	
                }else if( godBlessed[id] == 1 ){
                	godBlessed[id] = 0
                	new name[MAX_NAME_LENGTH]
			get_user_name( id, name,MAX_NAME_LENGTH-1)
                	set_hudmessage(178, 14, 41, -1.0, 0.65, 1, 6.0, 15.0, 0.2, 0.3,4);
			#if LANG_ENG
				show_hudmessage(id,"God Mode Disabled");
				client_print(id,print_chat, "[GOD] %s, rape is a sin my son, I'm afraid your on your own now.",name)	
			#endif
			#if LANG_GER
				show_hudmessage(id,"God Mode Ausgeschaltet");
				client_print(id,print_chat, "[GOD] %s, rape is a sin my son, I'm afraid your on your own now.",name)	
			#endif
			#if LANG_FRE
				show_hudmessage(id,"Le Mode Dieu est desactive");
				client_print(id,print_chat, "[DIEU] %s, le viol est un peche mon fils, j'ai peur que tu sois seul maintenant.",name)	
			#endif			
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
	
	changingrace[id]=false
	
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
	
	// VIP armor check after reincarnation..
	if(get_user_armor(id)>100)
	{
			if(id != vip_id)
				set_user_armor(id, 100)
	}
	
	
	// next line beginning of blood elf Crimson armor 
	if (p_skills[id][0] == 5 && p_skills[id][1]){		// Crimson Armor
		if(get_user_armor(id) > 100)     // makes sure that ankh of reincarnation
			set_user_armor(id, 0)    // doesn't cause them to have some weird armor value
		give_item(id,"item_assaultsuit")
		new currentarmor = get_user_armor(id)
		set_user_armor(id ,currentarmor + p_crimsonarmor[p_skills[id][1]-1])
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
	
	#if STARTINGLEVEL
		if ( playerxp[id] < xplevel[STARTINGLEVEL] ) {
			playerxp[id] = xplevel[STARTINGLEVEL]
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
	
	new players[32]
	new numberofplayers	
	new string[256] 
	new vicString[1024]
	new vicLen = 9
	new attString[1024]
	new attLen = 11
	new stringLen	
	new damage 
	new attacker[MAX_NAME_LENGTH],victim[MAX_NAME_LENGTH]
	new i
	new bool:hadVictim = false
	new bool:hadAttacker = false
	
	get_players(players, numberofplayers)
	
	#if LANG_ENG
		copy(vicString,vicLen,"Victims:^n");		
		copy(attString,attLen,"Attackers:^n");
	#endif
	#if LANG_GER	
		copy(vicString,vicLen,"Opfer:^n");		
		copy(attString,attLen,"Angreifer:^n");
	#endif
	#if LANG_FRE	
		copy(vicString,vicLen,"Victimes:^n");		
		copy(attString,attLen,"Attaquants:^n");
	#endif	
						
	for( i = 0; i < numberofplayers; i++ ){	
							
		damage = dmgStat[id][players[i]]
		if( damage != 0){ // if damage occured
			hadVictim = true
			get_user_name(players[i], victim,MAX_NAME_LENGTH-1)
			#if LANG_ENG
				if( xpStat[id][players[i]] >= 0 ){
					stringLen = format(string,127,"%s    %dHP    %dHits    %dXP^n",victim,damage,hitStat[id][players[i]], xpStat[id][players[i]]) 
				}else{
					stringLen = format(string,127,"%s    %dHP    %dHits   -%dXP^n",victim,damage,hitStat[id][players[i]], xpStat[id][players[i]]) 
				}
			#endif
			#if LANG_GER
				if( xpStat[id][players[i]] >= 0 ){
					stringLen = format(string,127,"%s    %dHP    %dTreffer    %dXP^n",victim,damage,hitStat[id][players[i]], xpStat[id][players[i]]) 
				}else{
					stringLen = format(string,127,"%s    %dHP    %dTreffer   -%dXP^n",victim,damage,hitStat[id][players[i]], xpStat[id][players[i]]) 
				}
			#endif
			#if LANG_FRE
				if( xpStat[id][players[i]] >= 0 ){
					stringLen = format(string,127,"%s    %dHP    %dImpacts    %dXP^n",victim,damage,hitStat[id][players[i]], xpStat[id][players[i]]) 
				}else{
					stringLen = format(string,127,"%s    %dHP    %dImpacts   -%dXP^n",victim,damage,hitStat[id][players[i]], xpStat[id][players[i]]) 
				}
			#endif			
			vicLen = format(vicString,vicLen+stringLen+1,"%s%s",vicString,string);
										
		}
		damage = dmgStat[players[i]][id]
		if( damage != 0){ // if damage occured
			hadAttacker = true
			get_user_name(players[i], attacker,MAX_NAME_LENGTH-1)					
			#if LANG_ENG
				stringLen = format(string,127,"%s    %d HP    %d Hits^n",attacker,damage,hitStat[players[i]][id]) 
			#endif
			#if LANG_GER		
				stringLen = format(string,127,"%s    %d HP    %d Treffer^n",attacker,damage,hitStat[players[i]][id]) 
			#endif
			#if LANG_FRE
				stringLen = format(string,127,"%s    %d HP    %d Impacts^n",attacker,damage,hitStat[players[i]][id]) 
			#endif			
			attLen = format(attString,attLen+stringLen+1,"%s%s",attString,string);					
		}			
				
	}
	
	// Stats Display Block --- Victims
	if( hadVictim ){		
		//set_hudmessage(red, green, blue,x=-1.0,y=0.35,fx,fxtime=6.0, holdtime=12.0, fadeintime=0.1, fadeouttime=0.2,channel=4);
		set_hudmessage(0,255,0,0.65,0.25,0,0.0,showTime,0.9,2.15,83) 
	      	show_hudmessage(id,vicString) 
	}else{
		#if LANG_ENG
			stringLen = format(string,127,"^nNone") 
		#endif
		#if LANG_GER
			stringLen = format(string,127,"^nKeine") 
		#endif
		#if LANG_FRE
			stringLen = format(string,127,"^nAucun") 
		#endif		
		format(vicString,vicLen+stringLen,"%s%s",vicString,string);
		set_hudmessage(0,255,0,0.65,0.25,0,0.0,showTime,0.9,2.15,83) 
	      	show_hudmessage(id,vicString) 
	}
	
	// Stats Display Block --- Attackers
	if( hadAttacker ){		
		set_hudmessage(255,255,0,0.65,0.55,0,0.0,showTime,0.9,2.15,84) 
      		show_hudmessage(id,attString) 
	}else{
		#if LANG_ENG
			stringLen = format(string,127,"^nNone") 
		#endif
		#if LANG_GER
			stringLen = format(string,127,"^nKeine") 
		#endif
		#if LANG_FRE
			stringLen = format(string,127,"^nAucun") 
		#endif		
		format(attString,attLen+stringLen,"%s%s",attString,string);
		set_hudmessage(255,255,0,0.65,0.55,0,0.0,showTime,0.9,2.15,84) 
      		show_hudmessage(id,attString) 
	}
	
	#if WAR3_MYSQL_TOP15
		// Skill and Rank Display mini-Block
		#if LANG_ENG
			format(string,127,"Your Skill: %d^nYour Rank: %d",skillStat[id],rank[id] )
		#endif
		#if LANG_GER
			format(string,127,"Dein Skill: %d^nDein Rang: %d",skillStat[id],rank[id] )
		#endif
		#if LANG_FRE
			format(string,127,"Ton Skill: %d^nTon Rang: %d",skillStat[id],rank[id] )
		#endif		
		set_hudmessage(0,255,0,-0.8,0.25,0,0.0,showTime,0.9,2.15,82) 
	      	show_hudmessage(id,string) 
	      	
	      	// Top 15 Block
	      	attLen = 8
		#if LANG_ENG
		      	copy(attString,attLen,"Top 15:^n");
		#endif
		#if LANG_GER
		      	copy(attString,attLen,"Top 15:^n");
		#endif
		#if LANG_FRE
		      	copy(attString,attLen,"Top 15:^n");
		#endif		
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
        
	#if BOMB_WARNINGS
			
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
	
	#if !ULTIMATE_FIRST_ROUND
		first_round = false
	#endif
	

	#if !SHORT_TERM
		if (saved_xp)
		{
			#if MYSQL_ENABLED || VAULT_SAVE
				write_all()
			#else
				update_file(0)	//modded for different update_file method.
			#endif
		}
	#endif
		
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
	
	
	#if BOMB_WARNINGS		
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

	#if !SHORT_TERM
		if (saved_xp)
		{
			#if MYSQL_ENABLED || VAULT_SAVE
				write_all()
			#else
				update_file(0)	//modded for different update_file method.
			#endif
		}
	#endif

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
		#if LANG_ENG
			show_hudmessage(id,"Failure Is Not An Option^nYou Die Now");
		#endif
		#if LANG_GER
			show_hudmessage(id,"Niederlage wird nicht toleriert^nstirb jetzt");
		#endif
		#if LANG_FRE
			show_hudmessage(id,"L'echec n'est pas une option^nMeurs maintenant");
		#endif		
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
			#if LANG_ENG
				show_hudmessage(id,"You must select a race before selecting skills!")
			#endif
			#if LANG_GER
				show_hudmessage(id,"Du musst eine Rasse waehlen, bevor du eine Fertigkeit auswaehlen kannst!")
			#endif
			#if LANG_FRE
				show_hudmessage(id,"Tu dois choisir ta race avant de pouvoir selectionner tes competences!")
			#endif			
		}
		else
			#if LANG_ENG
				client_cmd(id,"echo You must select a race before selecting skills!")
			#endif
			#if LANG_GER
				client_cmd(id,"echo Du musst eine Rasse waehlen, bevor du eine Fertigkeit auswaehlen kannst!")
			#endif
			#if LANG_FRE
				client_cmd(id,"echo Tu dois choisir ta race avant de pouvoir selectionner tes competences!!")
			#endif			
		return PLUGIN_HANDLED
	}

	new message[256]
	new temp[128]

	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]

	if (skillsused>=p_level[id]){
		if (saychat==1){
			set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
			#if LANG_ENG
				show_hudmessage(id,"You have already used up all your skill points!")
			#endif
			#if LANG_GER
				show_hudmessage(id,"Du hast bereits alle Fertigkeitspunkte aufgebraucht!")
			#endif
			#if LANG_FRE
				show_hudmessage(id,"Tu as deja utilise tous tes points de competence!")
			#endif			
		}
		else
			#if LANG_ENG
				client_cmd(id,"echo You have already used up all your skill points!")
			#endif
			#if LANG_GER
				client_cmd(id,"echo Du hast bereits alle Fertigkeitspunkte aufgebraucht!")
			#endif
			#if LANG_FRE
				client_cmd(id,"echo Tu as deja utilise tous tes points de competence!")
			#endif			
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
	
	#if LANG_ENG
		format(message,255,"\ySelect Skill:\w^n")
	#endif
	#if LANG_GER
		format(message,255,"\yWaehle eine Fertigkeit:\w^n")
	#endif
	#if LANG_FRE
		format(message,255,"\yChoisi ta Competence:\w^n")
	#endif	

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
		else if (p_skills[id][0] == 5){ // BLOOD ELF
			copy(skillcurrentrace[skillcounter],63,race5skill[skillcounter])
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
			#if LANG_ENG
				format(temp,127,"^n%d. %s Level %d\w",skillcounter,skillcurrentrace[skillcounter-1],p_skills[id][skillcounter]+1)
			#endif
			#if LANG_GER
				format(temp,127,"^n%d. %s Level %d\w",skillcounter,skillcurrentrace[skillcounter-1],p_skills[id][skillcounter]+1)
			#endif
			#if LANG_FRE
				format(temp,127,"^n%d. %s Niveau %d\w",skillcounter,skillcurrentrace[skillcounter-1],p_skills[id][skillcounter]+1)
			#endif			
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
			if(  p_skills[id][0]==4 && p_level[id] < BLOOD_ELF_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
		#else
			if (p_level[id]<=5){
				format(temp,127,"\d")
				add(message,255,temp)
			}
		#endif
		#if LANG_ENG
			format(temp,127,"^n4. Ultimate: %s\w",skillcurrentrace[3])
		#endif
		#if LANG_GER
			format(temp,127,"^n4. Ultimate: %s\w",skillcurrentrace[3])
		#endif
		#if LANG_FRE
			format(temp,127,"^n4. Ultime: %s\w",skillcurrentrace[3])
		#endif		
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
			if(  p_level[id]>=BLOOD_ELF_ULT)
				keys |= (1<<3)
			
		}
	#else
		if (p_skills[id][4]==0 && p_level[id]>=6 && skillsused<p_level[id])
			keys |= (1<<3)
	#endif	
	
	#if LANG_ENG
		format(temp,127,"^n^n0. Cancel")
	#endif
	#if LANG_GER
		format(temp,127,"^n^n0. Abbrechen")
	#endif
	#if LANG_FRE
		format(temp,127,"^n^n0. Annuler")
	#endif	
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
			
			if(  p_skills[id][0]==5 && p_level[id]>= BLOOD_ELF_ULT) p_skills[id][4]=1
			
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
			#if LANG_ENG
	                        show_hudmessage(id,"You can only change your race when you are dead or at the beginning of the round!")
			#endif
			#if LANG_GER
	                        show_hudmessage(id,"Du kannst die Rasse nur wechseln wenn du Tot bist oder am Anfang der Runde!")
			#endif
			#if LANG_FRE
	                        show_hudmessage(id,"Tu peux seulement changer de race lorsque tu es mort ou en debut de round!")
			#endif			
                }
                else{
			#if LANG_ENG
	                        client_cmd(id,"echo You can only change your race when you are dead or at the beginning of the round!")
			#endif
			#if LANG_GER
	                        client_cmd(id,"echo Du kannst die Rasse nur wechseln wenn du Tot bist oder am Anfang der Runde!")
			#endif
			#if LANG_FRE
	                        client_cmd(id,"echo Tu peux seulement changer de race lorsque tu es mort ou en debut de round!")
			#endif			
                }
                return PLUGIN_CONTINUE
        }
	

	if (get_cvar_num("mp_allowchangerace")==1 || p_skills[id][0]==0){
		#if !SHORT_TERM
			if (saved_xp){
				if (!changingrace[id]){
					#if MYSQL_ENABLED || VAULT_SAVE
						write_xp_to_file(id, "")
					#else
						addtosavequeue(id)
					#endif
					changingrace[id]=true
					get_xp_from_file(id,1)
				}
				else if (saychat==1){
					set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
					#if LANG_ENG
						show_hudmessage(id,"You can't change race more than once per round!")
					#endif
					#if LANG_GER
						show_hudmessage(id,"Du kannst die Rasse nur ein mal pro Runde wechseln!")
					#endif
					#if LANG_FRE
						show_hudmessage(id,"Tu ne peux pas changer de race plus d'une fois par round!")
					#endif					
				}
				else{
					#if LANG_ENG
						client_cmd(id,"echo You can't change race more than once per round!")
					#endif
					#if LANG_GER
						client_cmd(id,"echo Du kannst die Rasse nur ein mal pro Runde wechseln!")
					#endif
					#if LANG_FRE
						client_cmd(id,"echo Tu ne peux pas changer de race plus d'une fois par round!")
					#endif					
				}
			}
			else
			{
		#endif
			if (!changingrace[id]){
				select_race(id)
			}
			else if (saychat==1){
				set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
				#if LANG_ENG
					show_hudmessage(id,"You can't change race more than once per round!")
				#endif
				#if LANG_GER
					show_hudmessage(id,"Du kannst die Rasse nur ein mal pro Runde wechseln!")
				#endif
				#if LANG_FRE
					show_hudmessage(id,"Tu ne peux pas changer de race plus d'une fois par round!")
				#endif				
			}
			else{
				#if LANG_ENG
					client_cmd(id,"echo You can't change race more than once per round!")
				#endif
				#if LANG_GER
					client_cmd(id,"echo Du kannst die Rasse nur ein mal pro Runde wechseln!")
				#endif
				#if LANG_FRE
					client_cmd(id,"echo Tu ne peux pas changer de race plus d'une fois par round!!")
				#endif				
			}
		#if !SHORT_TERM
			}
		#endif
	}
	else{
		if (saychat==1){
			set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
			#if LANG_ENG
				show_hudmessage(id,"Server is not allowing race change!")
			#endif
			#if LANG_GER
				show_hudmessage(id,"Der Server erlaubt kein Wechseln der Rasse!")
			#endif
			#if LANG_FRE
				show_hudmessage(id,"Le Serveur ne permet pas le changement de race!")
			#endif			
		}
		else{
			#if LANG_ENG
				client_cmd(id,"echo Server is not allowing race change!")
			#endif
			#if LANG_GER
				client_cmd(id,"echo Der Server erlaubt kein Wechseln der Rasse!")
			#endif
			#if LANG_FRE
				client_cmd(id,"echo Le Serveur ne permet pas le changement de race!")
			#endif			
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
	#if LANG_ENG
		format(menu_msg,255,"\ySelect Race:\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n5. %s^n^n\ 
								6. Auto-select", racename[1],\ 
								racename[2], racename[3], racename[4], racename[5]) 
	#endif
	#if LANG_GER
		format(menu_msg,255,"\yWaehle eine Rasse::\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n5. %s^n^n\ 
								6. Auto-Auswahl", racename[1],\ 
								racename[2], racename[3], racename[4], racename[5]) 
	#endif
	#if LANG_FRE
		format(menu_msg,255,"\yChoisi ta Race:\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n5. %s^n^n\ 
								6. Selection Automatique", racename[1],\ 
								racename[2], racename[3], racename[4], racename[5]) 
	#endif	
                                                        // above added 5th race, and modified auto select to be #6
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5),menu_msg,-1) // added 5th menu possiblity
	return PLUGIN_CONTINUE
}

public vip_spawn(id){
	vip_id = id
}

public set_race(id,key){
	new oldrace = p_skills[id][0]
	
	if (is_user_alive(id) && !freezetime)
	{
		changingrace[id]=false
		set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
		#if LANG_ENG	
			show_hudmessage(id,"You must select your race while dead or during freezetime!")
		#endif
		#if LANG_GER
			show_hudmessage(id,"Du muss deine Rasse waehlen beim Freezetime am Rundenanfang oder wenn du Tot bist!")
		#endif
		#if LANG_FRE
			show_hudmessage(id,"Tu dois choisir ta race lorsque tu es mort ou pendant freezetime!")
		#endif		
	
		return PLUGIN_CONTINUE
	}
	
	if (key == 0)
		p_skills[id][0] = 1
	else if (key == 1)
		p_skills[id][0] = 2
	else if (key == 2)
		p_skills[id][0] = 3
	else if (key == 3)
		p_skills[id][0] = 4
	else if (key == 4)
		p_skills[id][0] = 5  
	else if (key == 5)               // changed what this key does
		p_skills[id][0] = random_num(1,5) // changed range of random nums

	if (p_skills[id][0] == oldrace)
		return PLUGIN_CONTINUE

	p_skills[id][1] = 0
	p_skills[id][2] = 0
	p_skills[id][3] = 0
	p_skills[id][4] = 0

	if (get_user_health(id)>100)
		set_user_health(id,100)

	if(get_user_armor(id)>100 || oldrace==5){
		if(id != vip_id)
			set_user_armor(id, 100)
	}

	#if !SHORT_TERM
		if (saved_xp){
			playerxp[id] = 0
			p_level[id] = 0
			get_xp_from_file(id,0)
		}
	#endif

	if (get_user_team(id)==0){
		engclient_cmd(id, "chooseteam")
		return PLUGIN_CONTINUE
	}
	else {
		new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]
		if (skillsused < p_level[id])
			select_skill(id,0)
	}

	// makes sure devotion and crimson armor get applied immediately
	if(p_skills[id][0] == 2 && p_skills[id][2] && get_user_health(id) <= 100){
		set_user_health(id,p_devotion[p_skills[id][2]-1])
	}
	else
		if(p_skills[id][0] == 5 && p_skills[id][1] && get_user_armor(id) <= 100){
			give_item(id,"item_assaultsuit")
			new currentarmor = get_user_armor(id)
			set_user_armor(id ,currentarmor + p_crimsonarmor[p_skills[id][1]-1])
	} 

	return PLUGIN_CONTINUE
}

public bLust_restore(parm[2]){
	new id       = parm[0]
	new targetid = parm[1]
	remove_task(8800+id)
      	
	if ( playeritem[targetid] == BOOTS ){
		set_user_maxspeed(targetid, BOOTSPEED)
	}
	
	if ( playeritem[id] == BOOTS){
		set_user_maxspeed(id, BOOTSPEED) // should fix permanent slowdown bug
	}
	
	if (p_skills[targetid][0] == 1 && p_skills[targetid][2]){              // Unholy Aura
		set_user_maxspeed(targetid,(p_unholy[p_skills[targetid][2]-1]))
		set_user_maxspeed(id, 250.0) // should fix permanent slowdown bug
	}else
	if (p_skills[targetid][0] == 1 && !p_skills[targetid][2]){
		set_user_maxspeed(targetid, 250.0)
		set_user_maxspeed(id, 250.0) // should fix permanent slowdown bug
	}
	
	if (p_skills[targetid][0] != 1){
		set_user_maxspeed(targetid, 250.0)
		set_user_maxspeed(id, 250.0) // should fix permanent slowdown bug
	}
}

public bLust_reduce(parm[2]){
	new id       = parm[0]
	new targetid = parm[1]
      
	if(is_user_alive(id) && is_user_alive(targetid)){
		if(id != targetid){
			if(rest_countdown[targetid] < 1){
				bLust_restore(parm)
			}
			else{
				set_user_maxspeed(targetid, p_bloodslow[p_skills[id][3]-1])
				rest_countdown[targetid]--
			}
		}else{ /* can't target self */ }
	}else{
		if(!is_user_alive(targetid) || !is_user_alive(id)){
			rest_countdown[targetid]=0
		}
	}
}

public damage_event(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new weapon, bodypart, enemy = get_user_attacker(id,weapon,bodypart)
	new damage
	new bool:p_evadecurrentshot
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

	if ( !enemy && get_gametime() - fExplodeTime < 1.0 && get_user_health(id)<1) {
	        diedlastround[id]=true
        	armorondeath[id]=get_user_armor(id)
	        for (new n=0; n<32; ++n){ 
        		savedweapons[id][n]=0
	        }
	        savednumber[id]=0
	        get_user_weapons(id,savedweapons[id],savednumber[id])
	}

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
	
	if (p_skills[id][0] == 5){
		if (p_skills[id][2]) {  // Mana Shield
			damage = read_data(2) // get the damage dealt from the damage event
			new damage1 = get_user_health(id)
			if(damage1 > 1){
				damage = floatround(float(get_user_health(id)) + floatround(float(damage) * p_manashield[p_skills[id][2]-1]))
   				set_user_health(id, damage)
   			}
   			else{ /* do nothing */ }   			
   		}
	}
	if (p_skills[id][0] == 4){		// Evasion
		if (p_skills[id][1]) {
			
			new healthadjustment
			
			
			p_evadecurrentshot = p_evadenextshot[id]
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
			if (get_user_health(id) <= damage) {
                                damage = floatround(float(get_user_health(id)) * p_thorns[p_skills[id][2]-1])
                                if (damage <=0) {
                                        damage = 0
                                }       
                        } else {
                                damage = floatround(float(damage) * p_thorns[p_skills[id][2]-1])
                        }       
                        if (p_skills[id][0] == 4){              // Nightelf damage -> no health for that
                                if (p_skills[id][1]) {          
                                        if (p_evadecurrentshot) {
                                                damage = 0;
                                        }       
                                }       
                        }       
                        
			                
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
			if (get_user_health(id) < 0 ){damage += get_user_health(id);} 
			damage = floatround(float(damage) * p_vampiric[p_skills[enemy][1]-1])
			if (p_skills[id][0] == 4)// Nightelf Evasion -> no health for that
			{ 
				if (p_skills[id][1]) 
				{
					if (p_evadecurrentshot) 
					{
						damage = 0;
					}
				}
			}

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
					logKill(enemy, id, race3skill[1])
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

	else if (p_skills[enemy][0] == 5){ // bloodlust
		if (p_skills[enemy][3]) {
			// slowdown code
			new slowed_parm[2]
			slowed_parm[0] = enemy
			slowed_parm[1] = id
			rest_countdown[id] = 10
			// debug
			//client_print(0, print_chat, "should be entering speed reduction")
			bLust_reduce(slowed_parm)
			set_task(0.20, "bLust_reduce",8800+id, slowed_parm, 3, "a", 9) // slow-down
			// end slowdown code
			if(playeritem[enemy] != CLAWS){
				//damage = read_data(2) // if we were adding some %age we'd need this
				// damage = floatround(float(damage) * p_bloodlust[p_skills[enemy][3]-1]) // if multiplier were being used
				//client_print(0, print_chat, "Normal damage for this shot: %d", damage)
				damage = p_bloodlust[p_skills[enemy][3]-1] // this line should create the damage with added bloodlust bonus
				//client_print(0, print_chat, "current enemy health is: %d ", get_user_health(id))
				//client_print(0, print_chat, "Bloodlust added: %d, making it: %d total", p_bloodlust[p_skills[enemy][3]-1], damage)
				#if WAR3STATS      
					dmgStat[enemy][id] += damage
				#endif

				if (get_user_health(id) - damage<=0)
					victimkilled = 1

				if (get_user_health(id) - damage<=ELF_EVADE_ADJ && get_user_health(id)>500)
					victimkilled = 1

				if (victimkilled)
					set_user_health(id, -1)
				else
					set_user_health(id, get_user_health(id) - damage)

				//client_print(0, print_chat, "current enemy (after subtraction) health is: %d ", get_user_health(id))
			}
			else{}
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
		logKill(id, enemy, race4skill[1])
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
	                        set_user_maxspeed(id,260.0)
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
	                        set_user_maxspeed(id,260.0)
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
	                        set_user_maxspeed(id,260.0)
	                }
	                else if (weaponnum==10 ){ //elite
	                        set_user_maxspeed(id,260.0)
	                }
	                else if (weaponnum==11){ //fiveseven
	                        set_user_maxspeed(id,260.0)
	                }
	                else if (weaponnum==26){ //deagle
	                        set_user_maxspeed(id,260.0)
	                }
	                else if (weaponnum==16){ //usp
	                        set_user_maxspeed(id,260.0)
	                }
	                else if (weaponnum==17){ //glock
	                        set_user_maxspeed(id,260.0)
	                }
	                else if (weaponnum==29){ //knife
	                        set_user_maxspeed(id,260.0)
	                }
	                else if (weaponnum==6){ //BOMB
	                        set_user_maxspeed(id,260.0)
	                }
	        }
	#endif

	if (!freezetime)
	{
		new parm[1]
		parm[0]=id
		unholyspeed(parm)
	}

	return PLUGIN_CONTINUE
}

public freezetimedone(parm[1]) {
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	
	freezetime = 0
	#if STEAM_POWERED
		new id = parm[0]
		set_user_maxspeed(id,240.0)
	#endif
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
			}
			if (playerItemOld[id]==ANKH){
				reincarnate = true				
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
				if( iweapons[a] != CSW_C4 ){
					get_weaponname(iweapons[a],wpname,31)
					client_cmd(id,"drop",wpname)
				}
			}
			client_cmd(id,"weapon_knife")
			origin[2] += 2005
			if(p_skills[id][0] == 5 && p_skills[id][1]){
                        
                        } else{
				if (armorondeath[id]){
					if (helmet[id])
						give_item(id,"item_assaultsuit")
					else
						give_item(id,"item_kevlar")
					set_user_armor(id,armorondeath[id])
				}
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
		} else {
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
		
	new name[MAX_NAME_LENGTH], message[2048]
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
		get_user_name(playerid,name,MAX_NAME_LENGTH-1)
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
				format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[3],p_level[playerid],skill1,skill2,skill3,skill4)
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
		else if (p_skills[playerid][0]==5){
			if(p_skills[playerid][1])
				format(skill1,63,", %s %d",race5skill[0],p_skills[playerid][1])
			if(p_skills[playerid][2])
				format(skill2,63,", %s %d",race5skill[1],p_skills[playerid][2])
			if(p_skills[playerid][3])
				format(skill3,63,", %s %d",race5skill[2],p_skills[playerid][3])
			if(p_skills[playerid][4])
				format(skill4,63,", %s",race5skill[3])
			#if STEAM_POWERED
				format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[5],p_level[playerid],skill1,skill2,skill3,skill4)
			#else
				format(temp,255,"%s - %s %d%s%s%s%s^n",name,racename[5],p_level[playerid],skill1,skill2,skill3,skill4)
			#endif
		}
		else if (p_skills[playerid][0]==0){
			#if STEAM_POWERED
				#if LANG_ENG
					format(temp,1023,"%s - race not yet selected<br>",name)
				#endif
				#if LANG_GER
					format(temp,1023,"%s - noch keine Rasse gewaehlt<br>",name)
				#endif
				#if LANG_FRE
					format(temp,1023,"%s - n'a pas encore choisi sa race<br>",name)
				#endif				
			#else
				#if LANG_ENG
					format(temp,255,"%s - race not yet selected^n",name)
				#endif
				#if LANG_GER
					format(temp,255,"%s - noch keine Rasse gewaehlt^n",name)
				#endif
				#if LANG_FRE
					format(temp,255,"%s - n'a pas encore choisi sa race^n",name)
				#endif				
			#endif
		}
		add(message,2047,temp)
	}
	if (saychat==1){
		#if LANG_ENG
			show_motd(id,message,"Warcraft 3 XP Player Skills")
		#endif
		#if LANG_GER
			show_motd(id,message,"Warcraft 3 XP Spieler Fertigkeiten")
		#endif
		#if LANG_FRE
			show_motd(id,message,"Warcraft 3 XP Competances des Joueurs")
		#endif		
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
	#if LANG_ENG
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
                	format(message,2047,message,floatround(p_critical[0]*100),floatround(p_grenade[0]),floatround(p_grenade[1]),floatround(p_grenade[2]),floatround(p_ankh[0]*100),floatround(p_ankh[1]*100),floatround(p_ankh[2]*100))
        	}                  
	        else if (p_skills[id][0]==4){
        	        format(title,63,"%s Skills",racename[4])
	                message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Evasion: Gives you a (%d%%, %d%% or %d%%) chance of evading each shot<p>\
	                           Thorns Aura: Does (%d%%, %d%% or %d%%) mirror damage to the person who shot you<p>\
	                           Trueshot Aura: Does (%d%%, %d%% or %d%%) extra damage to the enemy<p>\
	                           Ultimate, Entangle Roots: Allows you to prevent an enemy player from moving for 10 seconds"
	                format(message,2047,message,floatround(p_evasion[0]*100),floatround(p_evasion[1]*100),floatround(p_evasion[2]*100),floatround(p_thorns[0]*100),floatround(p_thorns[1]*100),floatround(p_thorns[2]*100),floatround(p_trueshot[0]*100),floatround(p_trueshot[1]*100),floatround(p_trueshot[2]*100))
        	}
        	else if (p_skills[id][0]==5){
			format(title,63,"%s Skills",racename[5])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Crimson Armor: Gives you full armor plus (%d, %d or %d) at the start of the round.<p>\
				Mana Shield: Any damage you take from enemies, except a kill shot, is reduced by (%d%%, %d%%, %d%%)<p>\
				Bloodlust: Adds (%d, %d or %d) damage to each bullet. Movement speed of enemy is also reduced temporarily.<p>\
				Ultimate, Shadowstrike: Emits a powerful damaging force at an enemy in your sights"
			format(message,2047,message,p_crimsonarmor[0],p_crimsonarmor[1],p_crimsonarmor[2],floatround(p_manashield[0]*100),floatround(p_manashield[1]*100),floatround(p_manashield[2]*100),p_bloodlust[0],p_bloodlust[1],p_bloodlust[2])
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
	        else
	        if (p_skills[id][0]==5){
	        	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    Then press the key (shift in this case) you should hear a beeping sound, this means that you are searching for<br> a target. \
                                    Once you hear the beeping sound aim your crosshair at a player.<br> You have 10 seconds to find a target before it gives up."
                	add(message,1023,temp)
	        }
	#endif
        #if LANG_GER
	        if (p_skills[id][0]==1){
			
        	        format(title,63,"%s Fertigkeiten",racename[1])
                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Vampir Aura: Gibt dir (%d%%, %d%% oder %d%%) des Schadens, den du verursacht hast als Lebenspunkte zurueck<p>\
                	Unheilige Aura: Erhoeht die Geschwindigkeit und mit allen Waffen ist man gleich schnell<p>\
	                Schweben: Ermoeglicht dir hoeher zu sprinden, indem deine Schwerkraft verringert wird<p>\
	                Ultimate, Selbstmord-Bomber: Wenn du stirbst, explodierst du und toetest nahegelegene Feinde"
	                format(message,2047,message,floatround(p_vampiric[0]*100),floatround(p_vampiric[1]*100),floatround(p_vampiric[2]*100))
	        }       
	        else if (p_skills[id][0]==2){
	        	#if BLINK_HUMAN_ULTIMATE
	        		format(title,63,"%s Fertigkeiten",racename[2])
	                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Unsichtbarkeit: Macht dich teilweise unsichtbar<p>\
                           	Hingabe Aura: Gibt dir (%d, %d oder %d) Lebenspunkte am Rundenstart<p>\
				Hieb: Wenn du auf jemanden schiesst, hast du eine (%d%%, %d%% oder %d%%) Chance ihn fuer eine Sekunde unbeweglich zu machen<p>\
                           	Ultimate, Teleportieren: Du kannst dich dahin teleportieren wo du gerade hinzielst."
		       		format(message,2047,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
	        	#else
	        		format(title,63,"%s Fertigkeiten",racename[2])
	                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Unsichtbarkeit: Macht dich teilweise unsichtbar<p>\
                           	Hingabe Aura: Gibt dir (%d, %d oder %d) Lebenspunkte am Rundenstart<p>\
				Hieb: Wenn du auf jemanden schiesst, hast du eine (%d%%, %d%% oder %d%%) Chance ihn fuer eine Sekunde unbeweglich zu machen<p>\
                           	Ultimate, Teleportieren: Ermoeglicht dir dich zu einem Teamkollegen zu teleportieren (10 Sekunden Aufladezeit)"
		        	format(message,2047,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
	        	#endif	              
        	}                  
	        else if (p_skills[id][0]==3){
        	        format(title,63,"%s Fertigkeiten",racename[3])
                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Kritische Treffer: Der Schaden jedes Treffers steigt mit der Wahrscheinlichkeit von %d%% um das (2-, 3-, oder 4-) Fache<p>\
                           	Kritische Granaten: Granaten verursachen immer das (%d, %d oder %d) Fache Schaden<p>\
	                        Reinkarnation: Eine (%d%%, %d%% oder %d%%) Chance die Ausruestung nach dem Tod zu behalten<p>\
        	                Ultimate, Kettenblitz: Verursacht einen Blitz, der zu nahegelegenen Gegner springt"
                	format(message,2047,message,floatround(p_critical[0]*100),floatround(p_grenade[0]),floatround(p_grenade[1]),floatround(p_grenade[2]),floatround(p_ankh[0]*100),floatround(p_ankh[1]*100),floatround(p_ankh[2]*100))
        	}                  
	        else if (p_skills[id][0]==4){
        	        format(title,63,"%s Fertigkeiten",racename[4])
	                message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Ausweichen: Gibt dir eine (%d%%, %d%% oder %d%%) Chance Schuessen auszuweichen<p>\
	                           Dornen Aura: Spiegelt (%d%%, %d%% or %d%%) Schaden zur Person, die auf dich schoss, zurueck<p>\
	                           Schadens Aura: Verursacht (%d%%, %d%% oder %d%%) mehr Schaden auf jeden Schuss<p>\
	                           Ultimate, Wucherwurzeln: Ein Gegner kann sich fuer 10 Sekunden nicht mehr Bewegen"
	                format(message,2047,message,floatround(p_evasion[0]*100),floatround(p_evasion[1]*100),floatround(p_evasion[2]*100),floatround(p_thorns[0]*100),floatround(p_thorns[1]*100),floatround(p_thorns[2]*100),floatround(p_trueshot[0]*100),floatround(p_trueshot[1]*100),floatround(p_trueshot[2]*100))
        	}
        	else if (p_skills[id][0]==5){
			format(title,63,"%s Fertigkeiten",racename[5])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Blutrote Ruestung: Gibt dir komplette Ausruestung plus (%d, %d or %d) am Anfang der Runde.<p>\
				Mana Schild: Jeder Treffer von Gegner (ausser toedliche Treffer) werden um (%d%%, %d%%, %d%%) verringert<p>\
				Blutrausch: Fuegt (%d, %d or %d) Schaden zu jeder Kugel hinzu, Gegner wird kurz verlangsamt.<p>\
				Ultimate, Schattenstoss: Verursacht Schaden zur Gegner auf den man zielt"
			format(message,2047,message,p_crimsonarmor[0],p_crimsonarmor[1],p_crimsonarmor[2],floatround(p_manashield[0]*100),floatround(p_manashield[1]*100),floatround(p_manashield[2]*100),p_bloodlust[0],p_bloodlust[1],p_bloodlust[2])
		}
	        else{
	                client_cmd(id,"echo Du musst eine Rasse waehlen, bevor du die Informationen anschauen kannst!")
        	        return PLUGIN_HANDLED
	        }
        	if (p_skills[id][0]==1){
                	new temp[]="<br>&nbsp;<br>&nbsp;<br>Beachte: um die Ultimate Fertigkeit ausloesen zu koennen, musst du eine Taste auf ^"ultimate^" binden, z.B. bind ^"shift^" ^"ultimate^"<br>\
                            	    Wenn du nun diese Taste drueckst (z.B. shift) bei dieser Rasse, explodierst du und<br> nimmst dabei hoffentlich Gegner mit."
                	add(message,1023,temp)
	        }else
	        if (p_skills[id][0]==2 || p_skills[id][0]==3 || p_skills[id][0]==4){
	                new temp[]="<br>&nbsp;<br>&nbsp;<br>Beachte: um die Ultimate Fertigkeit ausloesen zu koennen, musst du eine Taste auf ^"ultimate^" binden, z.B. bind ^"shift^" ^"ultimate^"<br>\
                            	    Dann musst du die Taste druecken (z.B. shift). Du solltest ein Piepen hoeren. Das bedeutet, dass ein Ziel gesucht wird. \
                                    Sobald du das Piepen hoerst, ziele auf einen Spieler und warte bis es eingelockt ist. Du hast 5 Sekunden um ein Ziel zu finden, bevor es aufhoert."
                	add(message,1023,temp)
	        }
	        else
	        if (p_skills[id][0]==5){
	                new temp[]="<br>&nbsp;<br>&nbsp;<br>Beachte: um die Ultimate Fertigkeit ausloesen zu koennen, musst du eine Taste auf ^"ultimate^" binden, z.B. bind ^"shift^" ^"ultimate^"<br>\
                            	    Dann musst du die Taste druecken (z.B. shift). Du solltest ein Piepen hoeren. Das bedeutet, dass ein Ziel gesucht wird. \
                                    Sobald du das Piepen hoerst, ziele auf einen Spieler und warte bis es eingelockt ist. Du hast 10 Sekunden um ein Ziel zu finden, bevor es aufhoert."
                	add(message,1023,temp)
	        }
	#endif
        #if LANG_FRE
	        if (p_skills[id][0]==1){
			
        	        format(title,63,"Competences des %s.",racename[1])
                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Aura Vampirique: Draine (%d%%, %d%% ou %d%%) des dommages causés.<p>\
                	Aura Impie: Donne un bonus de vitesse, toutes les armes font courrir a la meme vitesse<p>\
	                Lévitation: Permet de sauter plus haut en diminuant la gravité<p>\
	                Ultimate, Kamikaze: Quand tu meurs tu exploses en causant des degats aux ennemis proches."
	                format(message,2047,message,floatround(p_vampiric[0]*100),floatround(p_vampiric[1]*100),floatround(p_vampiric[2]*100))
	        }       
	        else if (p_skills[id][0]==2){
	        	#if BLINK_HUMAN_ULTIMATE
	        		format(title,63,"Competences des %s.",racename[2])
	                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Invisibilite: Te rend partiellement invisible, tu seras plus difficile a voir<p>\
                           	Aura de Devotion: Te donne (%d, %d ou %d) de vie au debut du round<p>\
				Bash: Quand tu touches quelqu'un tu as (%d%%, %d%% ou %d%%) de chance de l'immobiliser 1 seconde.<p>\
                           	Ultimate, Téléportation: Permet de téléporter là ou tu vises (evites les plafonds)."
		       		format(message,2047,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
	        	#else
	        		format(title,63,"Competences des %s.",racename[2])
	                	message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Invisibilite: Te rend partiellement invisible, Tu seras plus difficile a voir<p>\
                           	Aura de Devotion: Te donnes (%d, %d ou %d) de vie au debut du round<p>\
				Bash: Quand tu touches quelqu'un tu as (%d%%, %d%% ou %d%%) de chance de l'immobiliser 1 seconde.<p>\
                           	Ultimate, Téléportation: Permet de téléporter sur un coequipier (10 secondes entre chaque)"
		        	format(message,2047,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
	        	#endif	              
        	}                  
		else if (p_skills[id][0]==3){
			format(title,63,"Competences des %s.",racename[3])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Coup Critique: Te donne %d%% de chance de multiplier les dmgs par (2,3,ou 4)<p>\
			Grenade Ultime: Les grenades feront (%d, %d ou %d) fois plus de dommages.<p>\
			Réincarnation de l'Equipement: Te donne (%d%%, %d%% ou %d%%) de chance de récupérer l'équipement apres être mort.<p>\
			Ultimate, Chaine d'Eclairs: Crée un eclair qui saute de joueur en joueur, a chaque saut il perd de sa puissance."
			format(message,2047,message,floatround(p_critical[0]*100),floatround(p_grenade[0]),floatround(p_grenade[1]),floatround(p_grenade[2]),floatround(p_ankh[0]*100),floatround(p_ankh[1]*100),floatround(p_ankh[2]*100))
		}
		else if (p_skills[id][0]==4){
			format(title,63,"Competences des %s.",racename[4])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Ausweichen: Esquive: Te donne (%d%%, %d%%, %d%%) de chance d'éviter chaque coup<p>\
			Aura d'Epines: Fait (%d%%, %d%%, %d%%) de dmg a la personne qui t'a touché.<p>\
			Aura de Degats: Fait (%d%%, %d%%, %d%%) de dmg supplémentaires a l'ennemi.<p>\
			Ultimate, Racines agrippantes: Te permet d'empecher un joueur ennemi de bouger pendant 10 secondes."
			format(message,2047,message,floatround(p_evasion[0]*100),floatround(p_evasion[1]*100),floatround(p_evasion[2]*100),floatround(p_thorns[0]*100),floatround(p_thorns[1]*100),floatround(p_thorns[2]*100),floatround(p_trueshot[0]*100),floatround(p_trueshot[1]*100),floatround(p_trueshot[2]*100))
		}
		else if (p_skills[id][0]==5){
		format(title,63,"Competences des %s.",racename[5])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Armure Enchanter: Te donne l'armure complete plus (%d, %d, %d) au commencement du round.<p>\
			Mana de Protection: Tous les dmg non mortels que tu prendras seront réduits par (%d%%, %d%%, %d%%).<p>\
			La Soif de Sang: Ajoute (%d, %d , %d) de dmg à chaque balle et la vitesse de l'ennemi est reduite temporairement.<p>\
			Ultimate, L'ombre de Frappe: Emet une puissante force destructrice à un ennemi qui est dans ton champs de vision."
			format(message,2047,message,p_crimsonarmor[0],p_crimsonarmor[1],p_crimsonarmor[2],floatround(p_manashield[0]*100),floatround(p_manashield[1]*100),floatround(p_manashield[2]*100),p_bloodlust[0],p_bloodlust[1],p_bloodlust[2])
		}		
	        else{
	                client_cmd(id,"echo Tu dois choisir une race avant de pourvoir voir l'information de ses competences!")
        	        return PLUGIN_HANDLED
	        }
        	if (p_skills[id][0]==1){
                	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: pour utiliser les competences ultimes, binde une touche ^"ultimate^", c'est a dire : bind ^"shift^" ^"ultimate^"<br>\
                            	    Quand tu appuies sur la touche (shift dans ce cas) avec cette race, tu exploseras et avec un peu de chance tu tueras avec toi quelques un de tes ennemis."
                	add(message,1023,temp)
	        }else
	        if (p_skills[id][0]==2 || p_skills[id][0]==3 || p_skills[id][0]==4){
	                new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: pour utiliser les competences ultimes, binde une touche ^"ultimate^", c'est a dire bind ^"shift^" ^"ultimate^"<br>\
                            	    Quand tu appuies sur la touche (shift dans ce cas) tu devrais entendre un bip, cela signifie que tu cherches une cible. \
                                    Quand tu as entendu le bip Mets ta cible sur un joueur et attends qu'elle se fixe. Tu as 5 secondes pour trouver une cible avant que ça ne s'arrete."
                	add(message,1023,temp)
	        }
	        else
	        if (p_skills[id][0]==5){
	                new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: pour utiliser les competences ultimes, binde une touche ^"ultimate^", c'est a dire bind ^"shift^" ^"ultimate^"<br>\
                            	    Quand tu appuies sur la touche (shift dans ce cas) tu devrais entendre un bip, cela signifie que tu cherches une cible. \
                                    Quand tu as entendu le bip Mets ta cible sur un joueur et attends qu'elle se fixe. Tu as 10 secondes pour trouver une cible avant que ça ne s'arrete."
                	add(message,1023,temp)
	        }
	#endif	
	#else
        #if LANG_ENG
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
			format(message,1023,message,floatround(p_critical[0]*100),floatround(p_grenade[0]),floatround(p_grenade[1]),floatround(p_grenade[2]),floatround(p_ankh[0]*100),floatround(p_ankh[1]*100),floatround(p_ankh[2]*100))
		}
		else if (p_skills[id][0]==4){
			format(title,63,"%s Skills",racename[4])
			message = "Evasion: Gives you a (%d%%, %d%% or %d%%) chance of evading each shot^n^n\
				   Thorns Aura: Does (%d%%, %d%% or %d%%) mirror damage to the person who shot you^n^n\
				   Trueshot Aura: Does (%d%%, %d%% or %d%%) extra damage to the enemy^n^n\
				   Ultimate, Entangle Roots: Allows you to prevent an enemy player from moving for 10 seconds"
			format(message,1023,message,floatround(p_evasion[0]*100),floatround(p_evasion[1]*100),floatround(p_evasion[2]*100),floatround(p_thorns[0]*100),floatround(p_thorns[1]*100),floatround(p_thorns[2]*100),floatround(p_trueshot[0]*100),floatround(p_trueshot[1]*100),floatround(p_trueshot[2]*100))
		}
		else if (p_skills[id][0]==5){
			format(title,63,"%s Skills",racename[5])
			message = "Crimson Armor: Gives you full armor plus (%d, %d or %d) at the start of the round.^n^n\
				Mana Shield: Any damage you take from enemies, except that which would kill you, is reduced by (%d%%, %d%%, %d%%)^n^n\
				Bloodlust: Each shot adds (%d, %d or %d) damage to the enemy. Movement speed of those who attack you is reduced temporarily.^n^n\
				Ultimate, Shadowstrike: Emits a powerful damaging force at an enemy in your sights"
			format(message,2047,message,p_crimsonarmor[0],p_crimsonarmor[1],p_crimsonarmor[2],floatround(p_manashield[0]*100),floatround(p_manashield[1]*100),floatround(p_manashield[2]*100),p_bloodlust[0],p_bloodlust[1],p_bloodlust[2])
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
		else
		if (p_skills[id][0]==5){
			new temp[]="^n^n^nNote: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"^n\
				    Then press the key (shift in this case) you should hear a beeping sound, this means that you are searching for a target. \
				    Once you hear the beeping sound aim your crosshair at a player. You have 10 seconds to find a target before it gives up."
			add(message,1023,temp)
		}
        #endif
        #if LANG_GER
		if (p_skills[id][0]==1){
			format(title,63,"%s Fertigkeiten",racename[1])
			message = "Vampiric Aura: Vampir Aura: Gibt dir (%d%%, %d%% oder %d%%) des Schadens, den du verursacht hast als Lebenspunkte zurueck^n^n\
				   Unheilige Aura: Erhoeht die Geschwindigkeit und mit allen Waffen ist man gleich schnell^n^n\
				   Schweben: Ermoeglicht dir hoeher zu sprinden, indem deine Schwerkraft verringert wird^n^n\
				   Ultimate, Selbstmord-Bomber: Wenn du stirbst, explodierst du und toetest nahegelegene Feinde"
			format(message,1023,message,floatround(p_vampiric[0]*100),floatround(p_vampiric[1]*100),floatround(p_vampiric[2]*100))
		}
		else if (p_skills[id][0]==2){
			#if BLINK_HUMAN_ULTIMATE
				format(title,63,"%s Fertigkeiten",racename[2])
				message = "Unsichtbarkeit: Macht dich teilweise unsichtbar; es wird schwerer dich zu sehen^n^n\
			           Hingabe Aura: Gibt dir (%d, %d oder %d) Lebenspunkte am Rundenstart^n^n\
				   Hieb: Wenn du auf jemanden schiesst, hast du eine (%d%%, %d%% oder %d%%) Chance ihn fuer eine Sekunde unbeweglich zu machen^n^n\
				   Ultimate, Teleportieren: DU kannst dich dahin teleportieren wo du gerade hinzielst."
				format(message,1023,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
			#else
				format(title,63,"%s Fertigkeiten",racename[2])
				message = "Unsichtbarkeit: Macht dich teilweise unsichtbar; es wird schwerer dich zu sehen^n^n\
			           Hingabe Aura: Gibt dir (%d, %d oder %d) Lebenspunkte am Rundenstart^n^n\
				   Hieb: Wenn du auf jemanden schiesst, hast du eine (%d%%, %d%% oder %d%%) Chance ihn fuer eine Sekunde unbeweglich zu machen^n^n\
				   Ultimate, Teleportieren: Ermoeglicht dir dich zu einem Teamkollegen zu teleportieren (10 Sekunden Aufladezeit)"
				format(message,1023,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
			#endif
			
		}
		else if (p_skills[id][0]==3){
			format(title,63,"%s Fertigkeiten",racename[3])
			message = "Kritische Treffer: Der Schaden jedes Treffers steigt mit der Wahrscheinlichkeit von %d%% um das (2-, 3-, oder 4-) Fache^n^n\
				   Kritische Granaten: Granaten verursachen immer das (%d, %d oder %d) Fache des normalen Schaden^n^n\
				   Ausruestungs Reinkarnation: Gibt dir eine (%d%%, %d%% oder %d%%) Chance die Ausruestung nach dem Tod zu behalten^n^n\
				   Ultimate, Kettenblitz: Verursacht einen Blitz, der zu nahegelegenen Gegner springt"
			format(message,1023,message,floatround(p_critical[0]*100),floatround(p_grenade[0]),floatround(p_grenade[1]),floatround(p_grenade[2]),floatround(p_ankh[0]*100),floatround(p_ankh[1]*100),floatround(p_ankh[2]*100))
		}
		else if (p_skills[id][0]==4){
			format(title,63,"%s Fertigkeiten",racename[4])
	                message = "Ausweichen: Gibt dir eine (%d%%, %d%% oder %d%%) Chance Schuessen auszuweichen^n^n\
        	                   Dornen Aura: Spiegelt (%d%%, %d%% or %d%%) Schaden zur Person, die auf dich schoss, zurueck^n^n\
                	           Schadens Aura: Verursacht (%d%%, %d%% oder %d%%) mehr Schaden auf jeden Schuss^n^n\
                        	   Ultimate, Wucherwurzeln: Ein Gegner kann sich fuer 10 Sekunden nicht mehr Bewegen"
			format(message,1023,message,floatround(p_evasion[0]*100),floatround(p_evasion[1]*100),floatround(p_evasion[2]*100),floatround(p_thorns[0]*100),floatround(p_thorns[1]*100),floatround(p_thorns[2]*100),floatround(p_trueshot[0]*100),floatround(p_trueshot[1]*100),floatround(p_trueshot[2]*100))
		}
		else if (p_skills[id][0]==5){
			format(title,63,"%s Fertigkeiten",racename[5])
			message = "Blutrote Ruestung: Gibt dir komplette Ausruestung plus (%d, %d or %d) am Anfang der Runde.^n^n\
				Mana Schild: Jeder Treffer von Gegner (ausser toedliche Treffer) werden um (%d%%, %d%%, %d%%) verringer^n^n\
				Blutrausch: Fuegt (%d, %d or %d) Schaden zu jeder Kugel hinzu, Gegner wird kurz verlangsamt.^n^n\
				Ultimate, Schattenstoss: Verursacht Schaden zur Gegner auf den man zielt"
			format(message,2047,message,p_crimsonarmor[0],p_crimsonarmor[1],p_crimsonarmor[2],floatround(p_manashield[0]*100),floatround(p_manashield[1]*100),floatround(p_manashield[2]*100),p_bloodlust[0],p_bloodlust[1],p_bloodlust[2])
		}
		else {
			client_cmd(id,"echo Du musst eine Rasse waehlen, bevor du die Informationen anschauen kannst!")
			return PLUGIN_HANDLED
		}
	        if (p_skills[id][0]==1){
	                new temp[]="^n^n^nBeachte: um die Ultimate Fertigkeit ausloesen zu koennen, musst du eine Taste auf ^"ultimate^" binden, z.B. bind ^"shift^" ^"ultimate^"^n\
	                            Wenn du nun diese Taste drueckst (z.B. shift) bei dieser Rasse, explodierst du und<br> nimmst dabei hoffentlich Gegner mit."
	                add(message,1023,temp)
	        }else
		if (p_skills[id][0]==2 || p_skills[id][0]==3 || p_skills[id][0]==4){
			new temp[]="^n^n^nBeachte: um die Ultimate Fertigkeit ausloesen zu koennen, musst du eine Taste auf ^"ultimate^" binden, z.B. bind ^"shift^" ^"ultimate^"^n\
				    Dann musst du die Taste druecken (z.B. shift). Du solltest ein Piepen hoeren. Das bedeutet, dass ein Ziel gesucht wird. \
				    Sobald du das Piepen hoerst, ziele auf einen Spieler und warte bis es eingelockt ist. Du hast 5 Sekunden um ein Ziel zu finden, bevor es aufhoert."
			add(message,1023,temp)
		}
		else
		if (p_skills[id][0]==5){
			new temp[]="^n^n^nBeachte: um die Ultimate Fertigkeit ausloesen zu koennen, musst du eine Taste auf ^"ultimate^" binden, z.B. bind ^"shift^" ^"ultimate^"^n\
				    Dann musst du die Taste druecken (z.B. shift). Du solltest ein Piepen hoeren. Das bedeutet, dass ein Ziel gesucht wird. \
				    Sobald du das Piepen hoerst, ziele auf einen Spieler und warte bis es eingelockt ist. Du hast 10 Sekunden um ein Ziel zu finden, bevor es aufhoert."
			add(message,1023,temp)
		}
        #endif
        #if LANG_FRE
		if (p_skills[id][0]==1){
			format(title,63,"Competences des %s.",racename[1])
			message = "Aura Vampirique: Draine (%d%%, %d%% ou %d%%) des dommages causés.^n^n\
				   Aura Impie: Donne un bonus de vitesse, toutes les armes font courrir à la même vitesse.^n^n\
				   Lévitation: Permet de sauter plus haut en diminuant la gravité^n^n\
				   Ultimate, Kamikaze: Quand tu meurs tu exploses en causant des dégats aux ennemis proches."
			format(message,1023,message,floatround(p_vampiric[0]*100),floatround(p_vampiric[1]*100),floatround(p_vampiric[2]*100))
		}
		else if (p_skills[id][0]==2){
			#if BLINK_HUMAN_ULTIMATE
				format(title,63,"Competences des %s.",racename[2])
				message = "Invisibilite: Te rend partiellement invisible, Tu seras plus difficile à voir.^n^n\
			           Aura de Devotion: Te donnes (%d, %d ou %d) de vie au debut du round.^n^n\
				   Bash: Quand tu touches quelqu'un tu as (%d%%, %d%% ou %d%%) de chance de l'immobiliser 1 seconde.^n^n\
				   Ultimate, Téléportation: Permet de téléporter là ou tu vises (evites les plafonds)."
				format(message,1023,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
			#else
				format(title,63,"Competences des %s.",racename[2])
				message = "Invisibilite: Te rend partiellement invisible, Tu seras plus difficile a voir.^n^n\
			           Aura de Devotion: Te donnes (%d, %d ou %d) de vie au debut du round.^n^n\
				   Bash: Quand tu touches quelqu'un tu as (%d%%, %d%% ou %d%%) de chance de l'immobiliser 1 seconde.^n^n\
				   Ultimate, Téléportation: Permet de téléporter sur un coéquipier (10 secondes entre chaque)"
				format(message,1023,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
			#endif
			
		}
		else if (p_skills[id][0]==3){
			format(title,63,"Competences des %s.",racename[3])
			message = "Coup Critique: Te donne %d%% de chance de multiplier les dommages par (2, 3, ou 4).^n^n\
				   Grenade Ultime: Les grenades feront toujours (%d, %d ou %d) fois plus de dommages que la normale.^n^n\
				   Réincarnation de l'Equipement: Te donne (%d%%, %d%% or %d%%) de chance de recupérer l'équipement apres être mort.^n^n\
				   Ultimate, Chaine d'Eclairs: Crée un eclair qui saute de joueur en joueur, à chaque saut il perd de sa puissance."
			format(message,1023,message,floatround(p_critical[0]*100),floatround(p_grenade[0])+1,floatround(p_grenade[1])+1,floatround(p_grenade[2])+1,floatround(p_ankh[0]*100),floatround(p_ankh[1]*100),floatround(p_ankh[2]*100))
		}
		else if (p_skills[id][0]==4){
			format(title,63,"Competences des %s.",racename[4])
			message = "Esquive: Te donne (%d%%, %d%% ou %d%%) de chance d'éviter chaque coup^n^n\
				   Aura d'Epines: Fait (%d%%, %d%% ou %d%%) de dommage à la personne qui t'a touché^n^n\
				   Aura de Degats: Fait (%d%%, %d%% ou %d%%) de dommages supplémentaires à l'ennemi^n^n\
				   Ultimate, Racines agrippantes: Te permet d'empecher un joueur ennemi de bouger pendant 10 secondes"
			format(message,1023,message,floatround(p_evasion[0]*100),floatround(p_evasion[1]*100),floatround(p_evasion[2]*100),floatround(p_thorns[0]*100),floatround(p_thorns[1]*100),floatround(p_thorns[2]*100),floatround(p_trueshot[0]*100),floatround(p_trueshot[1]*100),floatround(p_trueshot[2]*100))
		}
		else if (p_skills[id][0]==5){
			format(title,63,"Competences des %s.",racename[5])
			message = "Armure Enchanter: Te donne l'armure complete plus (%d, %d ou %d) au commencement du round.^n^n\
				Mana de Protection: Tout les dommages non mortels que tu prendras seront réduits par (%d%%, %d%%, %d%%)^n^n\
				La Soif de Sang: Ajoute (%d, %d or %d)de dommage a chaque balle. La vitesse de l'ennemi est également reduite temporairement.^n^n\
				Ultimate, L'ombre de Frappe: Emet une force destructrice puissante à un ennemi se situant dans ton  champs de vision."
			format(message,2047,message,p_crimsonarmor[0],p_crimsonarmor[1],p_crimsonarmor[2],floatround(p_manashield[0]*100),floatround(p_manashield[1]*100),floatround(p_manashield[2]*100),p_bloodlust[0],p_bloodlust[1],p_bloodlust[2])
		}
		else {
			client_cmd(id,"echo Tu dois choisir une race avant de pourvoir voir l'information de ces competences!")
			return PLUGIN_HANDLED
		}
	        if (p_skills[id][0]==1){
	                new temp[]="^n^n^nNote: pour utiliser les competences ultimes, binde une touche ^"ultimate^", c'est à dire : bind ^"shift^" ^"ultimate^"^n\
	                            Quand tu appuies sur la touche (shift dans ce cas) avec cette race, tu exploseras et avec un peu de chance tu tuer avec toi quelques un de tes ennemis."
	                add(message,1023,temp)
	        }else
		if (p_skills[id][0]==2 || p_skills[id][0]==3 || p_skills[id][0]==4){
			new temp[]="^n^n^nNote: pour utiliser les competences ultimes, binde une touche ^"ultimate^", c'est a dire bind ^"shift^" ^"ultimate^"^n\
			    Quand tu appuies sur la touche (shift dans ce cas) tu devrais entendre un bip, cela signifie que tu cherches une cible. \
			    Quand tu as entendu le bip Mets ta cible sur un joueur et attends qu'elle se fixe. Tu as 5 secondes pour trouver une cible avant que ca ne s'arrete."
			add(message,1023,temp)
		}
		else
		if (p_skills[id][0]==5){
			new temp[]="^n^n^nNote: pour utiliser les competences ultimes, binde une touche ^"ultimate^", c'est a dire bind ^"shift^" ^"ultimate^"^n\
				    Quand tu appuies sur la touche (shift dans ce cas) tu devrais entendre un bip, cela signifie que tu cherches une cible. \
				    Quand tu as entendu le bip Mets ta cible sur un joueur et attends qu'elle se fixe. Tu as 10 secondes pour trouver une cible avant que ça ne s'arrete"
			add(message,1023,temp)
		}
        #endif        
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
	#if LANG_ENG
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
	#endif
        #if LANG_GER
	      	pos += format(message[pos], 2047-pos, "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>")
	        pos += format(message[pos], 2047-pos, "Der Shop funktioniert gleich wie das Kaufen von Waffen,<br> \
                                                ausser dass du ueberall kaufen kannst. Du kannst immer<br> \
                                                nur ein Gegenstand haben. Wenn du einen Gegenstand kaufst, obwohl du<br> \
                                                du schon einen hast, geht der vorherige Gegenstand verloren.<br>")
        	pos += format(message[pos], 2047-pos, "Um Gegenstaende kaufen zu koennen musst du eine Taste auf ^"shopmenu^" binden, z.B. bind i shopmenu<br><br>")
	        pos += format(message[pos], 2047-pos, "Ankh der Reinkarnation: Wenn du stirbst, bekommst du deine Ausruestung in der naechsten Runde wieder<br>")
	        pos += format(message[pos], 2047-pos, "Boots of Speed: Stiefel der Geschwindigkeit: Ermoeglicht dir schneller zu rennen<br>")
	        pos += format(message[pos], 2047-pos, "Klauen des Angriffs +6: Bei jedem Treffer wird dem Gegner zusaetzlich 6 HP abgezogen<br>")
	        pos += format(message[pos], 2047-pos, "Mantel des Schattens: Macht dich teilweise unsichtbar; wird beim Halten des Messers erhoeht<br>")
	        pos += format(message[pos], 2047-pos, "Maske des Todes: Fuer jeden Treffer bekommst du zusaetzlich HP<br>")
	        pos += format(message[pos], 2047-pos, "Kette der Immunitaet: Du bist immun gegen gegnerische Ultimates<br>")
	        pos += format(message[pos], 2047-pos, "Frostkugel: Verlangsamt deinen Gegner, wenn du ihn triffst<br>")
	        pos += format(message[pos], 2047-pos, "Gesundheitsstein: Du erhaelst zusätzlich HP<br>")
	        pos += format(message[pos], 2047-pos, "Buch der Erfahrung: Du erhaelst automatisch Erfahrung; der Gegenstand wird sofort benutzt<br>")

	#endif
        #if LANG_FRE
	      	pos += format(message[pos], 2047-pos, "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>")
		pos += format(message[pos], 2047-pos, "Les objets fonctionnent de la même manière que l'achat d'armes, sauf que tu peux en acheter n'importe où.<br> \
							Tu peux tenir seulement un objet à la fois, à l'exception du tome d'expérience<br> \
							(tu peux en acheter autant qu'il y en a sans perdre l'objet actuel).<br> \
							Si tu achetes un objet en en tenant déjà un, l'objet d'avant sera perdu.<br>")
		pos += format(message[pos], 2047-pos, "Pour acheter des objets tu dois binder une touche ^"shopmenu^" par exemple (bind i shopmenu).<br>")
		pos += format(message[pos], 2047-pos, "Ankh de Reincarnation : Te permet de récupérer ton équipement le round suivant.<br>")
		pos += format(message[pos], 2047-pos, "Bots de Vitesse : Te permet de courrir plus rapidement.<br>")
		pos += format(message[pos], 2047-pos, "Griffes d'Attaque +6 : Te permet de faire 6 hp suplementaires à chaque impact sur tes ennemis.<br>")
		pos += format(message[pos], 2047-pos, "Manteau d'Ombres : Te rend partiellement invisible, l'invisibilité augmente en tenant le couteau.<br>")
		pos += format(message[pos], 2047-pos, "Masque de Mort : Te permet de recevoir de la vie lorsque tu fais des dommages sur tes ennemis.<br>")
		pos += format(message[pos], 2047-pos, "Collier d'Immunité : Te permet d'être imunisé contre les compétences ultimes ainsi qu'aux Grenades Ultimes.<br>")
		pos += format(message[pos], 2047-pos, "Orbe de Glace : Te permet de ralentir ton ennemi quand tu le frappes.<br>")
		pos += format(message[pos], 2047-pos, "Amulette de Vie : Te permet de recevoir de la vie supplémentaire.<br>")
		pos += format(message[pos], 2047-pos, "Tome d'Experience : Te permet d'acquérir automatiquement de  l'experience, l'objet est utilisé au moment de l'achat.<br>")
	#endif	
	#else
	#if LANG_ENG
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
        #if LANG_GER
	        pos += format(message[pos], 1023-pos, "Der Shop funktioniert gleich wie das Kaufen von Waffen, \
                                                ausser dass du ueberall kaufen kannst. Du kannst immer \
                                                nur ein Gegenstand haben. Wenn du einen Gegenstand kaufst, obwohl du \
                                                du schon einen hast, geht der vorherige Gegenstand verloren.^n")
	        pos += format(message[pos], 1023-pos, "Um Gegenstaende kaufen zu koennen musst du eine Taste auf ^"shopmenu^" binden, z.B. bind i shopmenu^n^n")
        	pos += format(message[pos], 1023-pos, "Ankh der Reinkarnation: Wenn du stirbst, bekommst du deine Ausruestung in der naechsten Runde wieder^n")
	        pos += format(message[pos], 1023-pos, "Boots of Speed: Stiefel der Geschwindigkeit: Ermoeglicht dir schneller zu rennen^n")
	        pos += format(message[pos], 1023-pos, "Klauen des Angriffs +6: Bei jedem Treffer wird dem Gegner zusaetzlich 6 HP abgezogen^n")
	        pos += format(message[pos], 1023-pos, "Mantel des Schattens: Macht dich teilweise unsichtbar; wird beim Halten des Messers erhoeht^n")
	        pos += format(message[pos], 1023-pos, "Maske des Todes: Fuer jeden Treffer bekommst du zusaetzlich HP^n")
	        pos += format(message[pos], 1023-pos, "Kette der Immunitaet: Du bist immun gegen gegnerische Ultimates^n")
	        pos += format(message[pos], 1023-pos, "Frostkugel: Verlangsamt deinen Gegner, wenn du ihn triffst^n")
	        pos += format(message[pos], 1023-pos, "Gesundheitsstein: Du erhaelst zusätzlich HP^n")
	        pos += format(message[pos], 1023-pos, "Buch der Erfahrung: Du erhaelst automatisch Erfahrung; der Gegenstand wird sofort benutzt^n")
	#endif
        #if LANG_FRE
		pos += format(message[pos], 1023-pos, "Les objets fonctionnent de la meme manière que l'achat d'armes, sauf tu peux en acheter n'importe où. \
							Tu peux tenir seulement un objet à la fois, à l'exception du tome d'expérience \
							(tu peux en acheter autant qu'il y en a sans perdre l'objet actuel). \
							Si tu achetes un objet en en tenant déjà un, l'objet d'avant sera perdu.^n")
		pos += format(message[pos], 1023-pos, "Pour acheter des objets tu dois binder une touche ^"shopmenu^" par exemple (bind i shopmenu).^n^n")
		pos += format(message[pos], 1023-pos, "Ankh de Reincarnation : Te permet de récuperer ton equipement le round suivant.^n")
		pos += format(message[pos], 1023-pos, "Bots de Vitesse : Te permet de courrir plus rapidement.^n")
		pos += format(message[pos], 1023-pos, "Griffes d'Attaque +6 : Te permet de faire 6 hp supplémentaires à chaque impact sur tes ennemis.^n")
		pos += format(message[pos], 1023-pos, "Manteau d'Ombres : Te rend partiellement invisible, l'invisibilité  augmente en tenant le couteau.^n")
		pos += format(message[pos], 1023-pos, "Masque de Mort : Te permet de recevoir de la vie lorsque tu fais des dommages sur tes ennemis.^n")
		pos += format(message[pos], 1023-pos, "Collier d'Immunité : Te permet d'être imunisé contre les compétences ultimes ainsi qu'aux Grenades Ultimes^n")
		pos += format(message[pos], 1023-pos, "Orbe de Glace : Te permet de ralentir ton ennemi quand tu le frappes.^n")
		pos += format(message[pos], 1023-pos, "Amulette de Vie : Te permet de recevoir de la vie supplementaire.^n")
		pos += format(message[pos], 1023-pos, "Tome d'Experience : Te permet d'acquérir Automatiquement de l'experience, l'objet est utilisé au moment de l'achat.^n")
	#endif	
	#endif
	show_motd(id,message,title)
	if (saychat==1)
		return PLUGIN_CONTINUE
	return PLUGIN_HANDLED
}

public war3_info(id){
	#if LANG_ENG
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
	#endif
	#if LANG_GER
        console_print(id,"---- Warcraft 3 Hilfe: Befehle ----")
        console_print(id,"Client:")
        console_print(id,"war3menu - Zeige WarCraft3 XP Menue")
        console_print(id,"selectskill - Ermoeglicht dir Fertigkeiten auszuwaehlen, bevor die naechste Runde startet")
        console_print(id,"changerace - Ermoeglicht dir waehrend des Spiels die Rasse zu waechseln (wenn mp_allowchangerace = 1)")
        console_print(id,"playerskills - Zeigt dir, welche Fertigkeiten andere Spieler ausgewaehlt haben")
        console_print(id,"skillsinfo - Zeigt dir Informationen ueber die Fertigkeiten deiner Rasse an")
        console_print(id,"itemsinfo - Zeigt dir eine Liste der Gegenstaende und ihre Wirkung an")
        console_print(id,"war3vote - Startet eine Abstimmung, ob das Plugin an- bzw. ausgeschaltet werden soll")
        console_print(id,"Server:")
        console_print(id,"sv_warcraft3 - Das Plugin An/Aus schalten (Standard 1, an)")
        console_print(id,"sv_allowwar3vote - Abstimmungen erlauben/verbieten (Standard 1, an)")
        console_print(id,"mp_allowchangerace - Ermoeglicht Leuten waehrend des Spiels die Rasse zu wechseln (Standard 0, aus)")
        console_print(id,"mp_forceskin - Zwingt den Spieler das zur Rasse dazugehoerende Skin zu waehlen (Standard 0, aus)")
        console_print(id,"mp_weaponxpmodifier - Mehr Erfahrung fuer das Nutzen schwaecherer Waffen (Standard 1, an)")
        console_print(id,"mp_savexp - Speichert die Erfahrung in eine txt Datei und stellt sie wieder her, wenn ein Spieler wiederkommt (Standard 0)")
        console_print(id,"mp_xpmultiplier - Stellt die Erfahrung als ein Multiplikator ein, die benoetigt wird, um ein Level aufzusteigen (Standard 1.0)")
        console_print(id,"mp_savebyname - Speichert die Erfahrung anhand des Nicknames, anstatt der WonID oder der IP (Standard 0)")
        console_print(id,"sv_daysbeforedelete - Siehe warcraft3.txt fuer mehr Informationen (Standard 1)")
        console_print(id,"sv_dayslevelmodifier - Siehe warcraft3.txt fuer mehr Informationen (Standard 3)")
        console_print(id,"---- Warcraft 3 Hilfe: Befehle ----")
	#endif
	#if LANG_FRE
        console_print(id,"---- Warcraft 3 aide: Commandes ----")
        console_print(id,"Joueur:")
        console_print(id,"war3menu - Affiche le Menu de WarCraft3")
        console_print(id,"selectskill - Te permet de choisir des competences avant le debut du round suivant")
        console_print(id,"changerace - Te permet de changer de race pendant le jeu si mp_allowchangerace est a 1")
        console_print(id,"playerskills - Affiche quelles competences les autres joueurs ont choisi")
        console_print(id,"skillsinfo - Affiche les infos de toutes les competence de la race que tu as choisie")
        console_print(id,"itemsinfo - Affiche la liste des objets et t'indique ce qu'ils font")
        console_print(id,"war3vote - Lance un Vote pour activer ou desactiver le Plugin Warcraft 3")
        console_print(id,"Serveur:")
        console_print(id,"sv_warcraft3 - Active ou desactive le plugin (par defaut 1, active)")
        console_print(id,"sv_allowwar3vote - Active ou desactive le vote (par defaut 1, active)")
        console_print(id,"mp_allowchangerace - Permet de changer de race pendant le jeu (par defaut 0, desactive)")
        console_print(id,"mp_forceskin - Oblige les joueurs à choisir un skin en fonction de leur race (par defaut 0, desactive)")
        console_print(id,"mp_weaponxpmodifier - Donne de l'XP supplementaire lorsque tu utilises certaines armes plus faibles (par defaut 1, active)")
        console_print(id,"mp_savexp -  Sauvegarde l'XP dans un fichier txt et le reprend quand un joueur se reconnecte (par defaut 0)")
        console_print(id,"mp_xpmultiplier - Definit le nombre d'XP necessaires pour gagner un Level par rapport e la normale (par defaut 1.0)")
        console_print(id,"mp_savebyname - Sauvegarde l'XP par le pseudo plutôt que par le WonID ou l'IP (par defaut 0)")
        console_print(id,"sv_daysbeforedelete - Voir warcraft3.txt pour plus d'infos (par defaut 1)")
        console_print(id,"sv_dayslevelmodifier - Voir warcraft3.txt pour plus d'infos (par defaut 3)")
        console_print(id,"---- Warcraft 3 Aide: Commandes ----")
	#endif	
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
	#if LANG_ENG
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
	#endif
	#if LANG_GER
	        pos += format(message[pos], 2047-pos, "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>")
	        pos += format(message[pos], 2047-pos, "Warcraft 3 ist ein AMX Plugin fuer Counter-Strike, das von SpaceDude geschrieben wurde.<br>")
	        pos += format(message[pos], 2047-pos, "Am Anfang bekommst du die Wahl zwischen 4 verschiedenen Rassen,<br>")
	        pos += format(message[pos], 2047-pos, "ede Rasse hat 3 grundlegende Fertigkeiten und ein Ultimate.<br>")
	        pos += format(message[pos], 2047-pos, "Um Zugang zu den Fertigkeiten zu bekommen, musst du Erfahrung bekommen, in dem du gegnerische Spieler toetest<br>")
	        pos += format(message[pos], 2047-pos, "oder Missionsziele erfuellst. Wenn du genug Erfahrung hast, <br>")
	        pos += format(message[pos], 2047-pos, "um ein Level aufzusteigen, bekommst du die Moeglichkeit neue Fertigkeiten zu waehlen.<br>")
	        pos += format(message[pos], 2047-pos, "Hier sind einige Befehle die du kennen solltest, um die Vorteile des Plugins ausnutzen zu koennen.<br>&nbsp;<br>")
	        pos += format(message[pos], 2047-pos, "Client Befehle:<br>")
	        pos += format(message[pos], 2047-pos, "say /selectskill - Ermoeglicht dir Fertigkeiten auszuwaehlen, bevor die naechste Runde startet<br>")
	        pos += format(message[pos], 2047-pos, "say /playerskills - Zeigt dir an, welche Fertigkeiten andere Spieler ausgewaehlt haben<br>")
	        pos += format(message[pos], 2047-pos, "say /changerace - Ermoeglicht dir waehrend des Spiels die Rasse zu waechseln<br>")
	        pos += format(message[pos], 2047-pos, "say /skillsinfo - Zeigt dir Informationen ueber die Fertigkeiten deiner Rasse an<br>")
	        pos += format(message[pos], 2047-pos, "say /itemsinfo - Zeigt dir eine Liste der Gegenstaende und ihre Wirkung an<br>")
	        pos += format(message[pos], 2047-pos, "say /level - Zeigt dir an welche Rasse, welchen Level und welche Fertigkeiten du hast<br>")
	        pos += format(message[pos], 2047-pos, "say /war3menu - Zeige WarCraft3 XP Spieler Menue<br>")
	#endif
	#if LANG_FRE
	        pos += format(message[pos], 2047-pos, "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>")
	        pos += format(message[pos], 2047-pos, "Warcraft 3 est un plugin AMX pour Counter-Strike, écrit par SpaceDude .<br>")
	        pos += format(message[pos], 2047-pos, "Au début du jeu vous avez le choix entre 5 races différentes,<br>")
	        pos += format(message[pos], 2047-pos, "chaque race a 3 compétences de base à choisir en plus d'une Ultime.<br>")
	        pos += format(message[pos], 2047-pos, "Pour accéder à ces compétences vous devez obtenir de l'expérience en tuant des ennemies <br>")
	        pos += format(message[pos], 2047-pos, "et compléter des objectifs. Quand vous avez assez d'XP pour accéder au  niveau suivant vous serez, <br>")
	        pos += format(message[pos], 2047-pos, "en mesure de choisir une nouvelle compétence à la fin du round ou quand vous serez mort.<br>")
	        pos += format(message[pos], 2047-pos, "Il ya quelques commandes que vous devez connaître afin de tirer avantage de ce plugin.<br>&nbsp;<br>")
	        pos += format(message[pos], 2047-pos, "Commandes client :<br>")
	        pos += format(message[pos], 2047-pos, "say /selectskill - Permet de choisir les compétences avant le début du prochain round<br>")
	        pos += format(message[pos], 2047-pos, "say /playerskills - Montre les compétences choisies par les autres joueurs<br>")
	        pos += format(message[pos], 2047-pos, "say /skillsinfo - Montre ce que fait chaque compétence pour la race choisie<br>")
	        pos += format(message[pos], 2047-pos, "say /itemsinfo - Montre une liste des objets et leur pouvoirs<br>")
	        pos += format(message[pos], 2047-pos, "say /level - Montre les race, level et compétences  que vous avez<br>")
	        pos += format(message[pos], 2047-pos, "say /war3menu - Assiche le menu WarCraft3 XP<br>")
	#endif	
	#else
	#if LANG_ENG
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
	#if LANG_GER
	        format(title,63,"Warcraft 3 Hilfe ")
	        temp = "Warcraft 3 ist ein AMX Plugin fuer Counter-Strike, das von SpaceDude geschrieben wurde.^nAm Anfang \
        	        bekommst du die Wahl zwischen 4 verschiedenen Rassen, jede Rasse hat 3 grundlegende Fertigkeiten \
                	und ein Ultimate. Um Zugang zu den Fertigkeiten zu bekommen, musst du Erfahrung bekommen, in dem du \
	                gegnerische Spieler toetest oder Missionsziele erfuellst. Wenn du genug Erfahrung hast, \
	                um ein Level aufzusteigen, bekommst du die Moeglichkeit neue Fertigkeiten zu waehlen. "
        	add(message,1023,temp)
	        temp = "Hier sind einige Befehle die du kennen solltest, \
        	        um die Vorteile des Plugins ausnutzen zu koennen.^n^nClient Befehle:^n\
                	say /selectskill - Ermoeglicht dir Fertigkeiten auszuwaehlen, bevor die naechste Runde startet^n\
	                say /changerace - Ermoeglicht dir waehrend des Spiels die Rasse zu waechseln, wenn mp_allowchangerace = 1^n\
        	        say /playerskills - Zeigt dir an, welche Fertigkeiten andere Spieler ausgewaehlt haben^n"
	        add(message,1023,temp)
        	temp = "say /skillsinfo - Zeigt dir Informationen ueber die Fertigkeiten deiner Rasse an^n\
	                say /itemsinfo - Zeigt dir eine Liste der Gegenstaende und ihre Wirkung an^n\
        	        say /level - Zeigt dir an welche Rasse, welchen Level und welche Fertigkeiten du hast^n\
                	say /war3vote - Startet eine Abstimmung, ob das Plugin an- bzw. ausgeschaltet wird"
	        add(message,1023,temp)
	#endif
		#if LANG_FRE
	        format(title,63,"Warcraft 3 Hilfe ")
	        temp = "Warcraft 3 est un plugin d'AMX pour Counter-Strike ecrit par SpaceDude.^nAu debut du  \
        	        jeu tu as le choix entre 4 races differentes, chacune ayant 3 competences de base au choix \
        	        ainsi qu'un ultimate. Pour avoir acces a ces competences tu dois gagner de l'experience en tuant \
        	        des ennemis et en reussissant les objectifs. Quand tu as gagne assez d'XP pour changer de niveau, \
        	        il donne la possiblite de selectionner une competences a la fin du round ou quand tu seras mort. "
        	add(message,1023,temp)
	        temp = "Quelques commandes que tu dois connaitre \
        	        pour tirer un profit maximum du plugin.^n^nCommandes joueurs:^n\
        	        say /selectskill - Te permet de selectionner tes competences avant le demarrage du prochain round^n\
        	        say /changerace - Te permet de changer de race si mp_allowchangerace est 1^n\
        	        say /playerskills - Te montre quelles competences les autres joueurs ont choisi^n"
	        add(message,1023,temp)
        	temp = "say /skillsinfo - Te montre chaque competence de la race que tu as choisie^n\
        	        say /itemsinfo - Te montre la liste des objets et t'indique se qu'ils font^n\
        	        say /level - Te montre la race, le niveau et les competences que tu as^n\
        	        say /war3vote - Voter pour activer ou desactiver le plugin"
	        add(message,1023,temp)
	#endif
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
		#if LANG_ENG
	                show_hudmessage(id,"Your skills will NOT be reset next round")
		#endif
		#if LANG_GER
	                show_hudmessage(id,"Deine Fertigkeiten werden in die naechste Runde NICHT zurueckgesetzt")
		#endif
		#if LANG_FRE
	                show_hudmessage(id,"Tes competences ne seront pas remises au prochain round")
		#endif		
		resetskill[id]=false
	}else{
                set_hudmessage(200, 100, 0, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
		#if LANG_ENG
	                show_hudmessage(id,"Your skills will be reset next round")
		#endif
		#if LANG_GER
	                show_hudmessage(id,"Deine Fertigkeiten werden in die naechste Runde zurueckgesetzt")
		#endif
		#if LANG_FRE
	                show_hudmessage(id,"Tes competences ne seront pas remises au prochain round")
		#endif		
		resetskill[id]=true	
	}
        return PLUGIN_HANDLED
}
#endif

public ultimate(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
		
	#if !ULTIMATE_FIRST_ROUND
		if(first_round == true)
		{
			set_hudmessage(0, 255, 0, -1.0, -0.4, 0, 1.5, 6.7, 0.5, 0.5,5)
			#if LANG_ENG
				show_hudmessage(id,"Ultimates are not allowed on the first round of the map.")
			#endif
                        #if LANG_GER
				show_hudmessage(id,"Ultimates sind in der ersten Runder der Map nicht erlaubt")
			#endif
                        #if LANG_FRE
				show_hudmessage(id,"Les pouvoirs ultimes ne sont pas autorises pendant le premier round d'une carte.")
			#endif			
			return PLUGIN_HANDLED
		}
	#endif	
		
	#if NON_ULTIMATE_VIP
		if( id == vipID ){
			set_hudmessage(0, 255, 0, -1.0, -0.4, 0, 1.5, 6.7, 0.5, 0.5,5)
			#if LANG_ENG
				show_hudmessage(id,"VIP's don't have Ultimate Abilities")
			#endif
	                #if LANG_GER
				show_hudmessage(id,"VIP's duerfen keine Ultimate Faehigkeiten benutzen")
			#endif
	                #if LANG_FRE
				show_hudmessage(id,"Le VIP n'a pas de Competence Ultime")
			#endif			
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
					#if LANG_ENG
						show_hudmessage(id,"Suicide Bomb Armed^nPress Again To Detonate");					
					#endif
					#if LANG_GER
						show_hudmessage(id,"Selbsmordbombe^nNochmal ausloesen zum zuenden");					
					#endif
					#if LANG_FRE
						show_hudmessage(id,"Tu es pres pour etre Kamikaze^nAppuies de nouveau pour exploser.");					
					#endif					
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
	
				new isTeleportRestricted;
				isTeleportRestricted = 0;
				#if TELEPORT_RESTRICTION
					if( (newLocation[2] - oldLocation[2] ) > TELEPORT_RESTRICTION_HEIGHT)
					{
						isTeleportRestricted = 1;
					}
					if(get_distance(newLocation,oldLocation) > TELEPORT_RESTRICTION_DISTANCE)
					{
						newLocation[0] = ((((newLocation[0] - oldLocation[0]) * TELEPORT_RESTRICTION_DISTANCE) / get_distance(newLocation,oldLocation)) + oldLocation[0]);
						newLocation[1] = ((((newLocation[1] - oldLocation[1]) * TELEPORT_RESTRICTION_DISTANCE) / get_distance(newLocation,oldLocation)) + oldLocation[1]);
					}
				#endif
				//if we dont exceed the height allowed we are allowed to teleport.
				//if we exceed the distance allowed, the distance is shortened to the maximum distance allowed.
				if(isTeleportRestricted==0)
				{	
					
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
				}
				//end of restriction process
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
					#if LANG_ENG
						show_hudmessage(id,"No valid teleport targets found!")
					#endif
					#if LANG_GER
						show_hudmessage(id,"Keine Ziele zum teleportieren gefunden!")
					#endif
					#if LANG_FRE
						show_hudmessage(id,"Aucun endroit valide trouve pour se teleporter!")
					#endif					
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
		else if (!issearching[id] && p_skills[id][0] == 5 && p_skills[id][4] == 1 && !ultimateused[id]){
			reset_count[id] = (SHADOWSTRIKE_DURATION * 5) - 1
		        new parm[2]
		        parm[0] = id
		        parm[1] = SHADOWSTRIKE_DURATION
		        shadow_search(parm)  // Shadowstrike
		        shadow_sound(parm)
		        set_task(0.2, "shadow_search",8000+id, parm, 2, "a", (SHADOWSTRIKE_DURATION * 5)-2) // shadowstrike - 10 seconds, ticks every .2 seconds
		        set_task(1.0, "shadow_sound",89+id, parm, 2, "a", SHADOWSTRIKE_DURATION-2) // shadowstrike sound
		}
	}
	return PLUGIN_HANDLED
}

public shadow_sound(parm[2]){
	new id = parm[0]
	if(!is_user_alive(id))
		remove_task(89+id)
	emit_sound(id,CHAN_ITEM, "turret/tu_ping.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}

public shadow_damage(id,targetid,damage){	
	new current, body
	new targetorigin[3]
	get_user_origin(targetid, targetorigin)
	new bool:targetdied
	new bool:targetdead
	targetdied=false
	targetdead=false
	new player_name[MAX_NAME_LENGTH] 
	get_user_name(id,player_name,MAX_NAME_LENGTH-1)
	if (is_user_alive(targetid))
		targetdead=false
	else
		targetdead=true
	//client_print(0, print_chat, "targetdied: %d - targetdead: %d", targetdied, targetdead)
	if (get_user_health(targetid)-damage<=0)
		targetdied=true
	
	get_user_aiming(id, current, body)
	if(targetid == current){
		set_user_health(targetid, get_user_health(targetid)- damage)
		//client_print(targetid, print_chat, "%s^'s Shadowstrike has infected you for %d damage", player_name, damage)
	}
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY, {125,0,125} ) 
	write_byte(14)		// tracers moving toward a point
	write_coord(targetorigin[0]) 
	write_coord(targetorigin[1]) 
	write_coord(targetorigin[2]) 
	write_byte (100)
	write_byte (60)
	write_byte (10) 
	message_end()
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY ) 
	write_byte(9) // 8 random tracers with gravity, ricochet sprite
	write_coord(targetorigin[0])
	write_coord(targetorigin[1])
	write_coord(targetorigin[2])
	message_end()
	//set_user_health(targetid,get_user_health(targetid)-damage)
	if (get_user_armor(targetid)-damage<=0)
		set_user_armor(targetid,0)
	else
		set_user_armor(targetid,get_user_armor(targetid)-damage)

	if (targetdied && !targetdead){
		// debug line
		//client_print(0, print_chat, "inside targetdied && !targetdead loop")
		remove_task(8000+id)
		set_user_frags(id, get_user_frags(id)+1)
		set_user_frags(targetid, get_user_frags(targetid)+1)
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(id)
		write_byte(targetid)
		write_byte(0)
		write_string(race5skill[3])
		message_end()
		playerxp[id]+=xpgiven[p_level[targetid]]
		displaylevel(id, 1)
		logKill(id, targetid, race5skill[3])
	}
	return PLUGIN_CONTINUE
}
public shadow_search(parm[2]){
	new id = parm[0]
	new enemy, body
	get_user_aiming(id,enemy,body)
	
	if(!is_user_alive(id)){
		// client_print(0, print_chat, "shadowstrike task removed")
		remove_task(8000+id)
	}
	if ( 0<enemy<=32 && is_user_alive(id) && get_user_team(id)!=get_user_team(enemy) && playeritem[enemy]!=IMMUNITY){
		// client_print(0, print_chat, "we found a target")
		issearching[id]=false
		ultimateused[id]=true
		if (file_exists("sound/warcraft3/EntanglingRootsTarget1.wav")==1)
			emit_sound(enemy,CHAN_ITEM, "warcraft3/EntanglingRootsTarget1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		else
			emit_sound(enemy,CHAN_ITEM, "weapons/cbar_hitbod3.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		
		// debug line
		//client_print(0, print_chat, "inside targetting statement")
		
		shadow_damage(id, enemy, SHADOWSTRIKE_DAMAGE) // shadowstrike damage application
		
		new cooldownparm[1]
		cooldownparm[0]=id
		set_task(SHADOWSTRIKE_COOLDOWN,"cooldown",50+id,cooldownparm,1)
	}
	else{
		issearching[id]=true
		new resetparm[1]
		resetparm[0] = id
		reset_search(resetparm)
	}
	return PLUGIN_CONTINUE
}

public reset_search(parm[1]){
	new id = parm[0]
	if(reset_count[id] == 0){
		issearching[id]=false
		// client_print(0, print_chat, "should be reset to start ultimate again")	
	}
	else{
		--reset_count[id]
		// client_print(0, print_chat, "resetparm %d", reset_count[id])
	}
	return PLUGIN_CONTINUE
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
							#if LANG_ENG
								show_hudmessage(id,"Teleport Failed^nEnemy Has Immunity");
							#endif
							#if LANG_GER
								show_hudmessage(id,"Teleportieren Fehlgeschlagen^nGegner hat Immunitaet");
							#endif
							#if LANG_FRE
								show_hudmessage(id,"La Teleportation a rate^nL'ennemi a l'Immunite");
							#endif									
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
		new name[MAX_NAME_LENGTH]
		new origin[3]
		new targetorigin[3]
		new distancebetween
		new temp[64]
		new i
		new keys = (1<<9)
		
		#if LANG_ENG	
			new menu_body[512]="\yTeleport to:\w^n"
		#endif
		#if LANG_GER
			new menu_body[512]="\yTeleportieren zu:\w^n"
		#endif
		#if LANG_FRE
			new menu_body[512]="\ySe Teleporter sur:\w^n"
		#endif		
		get_user_origin(id,origin)
		for (i = 0; i < numberofplayers; ++i){
			targetid=teleportid[id][i]
			get_user_name(targetid,name,MAX_NAME_LENGTH-1)
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
		#if LANG_ENG
			format(temp,63,"^n^n\w0. Cancel")
		#endif
		#if LANG_GER
			format(temp,63,"^n^n\w0. Abbruch")
		#endif
		#if LANG_FRE
			format(temp,63,"^n^n\w0. Annuler")
		#endif		
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
		#if NIGHTELF_DROPWEAPON
			new wpname[32]
			new ammo, clip, wpid = get_user_weapon(enemy,clip,ammo)
			get_weaponname(wpid,wpname,31)
			client_cmd(id,"drop",wpname)
		#endif
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
		}else if( p_skills[id][0] == 4 ){
			write_string( "dmg_bio" ) // night elf sprite name 	
		}else if( p_skills[id][0] == 5 ){
			write_string( "dmg_poison" ) // blood elf sprite name
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
		logKill(caster, targetid, race3skill[3])
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
				logKill(id, targetid, race1skill[3])
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
	p_spectator[id] = false
	#if !SHORT_TERM
		if (is_user_bot(id) && saved_xp){
			playerxp[id]= xplevel[floatround(random_float(0.0,3.16)*random_float(0.0,3.16))]
			p_skills[id][0] = random_num(1,4)
			return PLUGIN_CONTINUE
		}
	#endif
	
	showicons[id]=true
	
	return PLUGIN_CONTINUE
}

#if !SHORT_TERM
	public client_disconnect(id){
		if (saved_xp && !is_user_bot(id) && p_skills[id][0] && playerxp[id]){
			#if MYSQL_ENABLED || VAULT_SAVE
				write_xp_to_file(id, "")
			#else
				addtosavequeue(id)
			#endif
		}
		return PLUGIN_CONTINUE
	}

#if !MYSQL_ENABLED && !VAULT_SAVE
	public addtosavequeue(id){
		if (p_skills[id][0] && playerxp[id]){
			new playerid[MAX_ID_LENGTH], playername[MAX_NAME_LENGTH], timet[32], i=0

			#if !STEAM_POWERED
				if (get_user_wonid(id)!=-1)
					num_to_str(get_user_wonid(id),playerid,31)	// by wonid
				else
			#endif
			#if SAVE_WITH_IP
				get_user_ip(id,playerid,MAX_ID_LENGTH-1,0)
			#else
				get_user_authid(id,playerid,MAX_ID_LENGTH-1)
			#endif
			while (!equal(savedline[i],"") && i<64){
				i++
			}
			if (i>=64)
				return PLUGIN_CONTINUE
			get_time("%m %d %H %M",timet,31)
			get_user_name(id,playername,MAX_NAME_LENGTH-1)
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
			lastupdate = get_gametime()	// in seconds
		}
		
		return PLUGIN_CONTINUE	
	}
#endif

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
			#if !SHORT_TERM
				if (saved_xp){
					get_xp_from_file(id,1)
				}
				else
			#endif
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
		#if LANG_ENG
			console_print(id,"There is already one voting...")
		#endif
		#if LANG_GER
			console_print(id,"Eine Abstimmung laeuft bereits...")
		#endif
		#if LANG_FRE
			console_print(id,"Il y a deja un vote en cours...")
		#endif		
		return PLUGIN_HANDLED
	}
	if (voting > 0.0 && voting + get_cvar_float("amx_vote_delay") > get_gametime()) {
		console_print(id,"Voting not allowed at this time")
		return PLUGIN_HANDLED
	}
	new keys = (1<<0)|(1<<1)
	new menu_msg[256]
	if (warcraft3==false)
	#if LANG_ENG
		format(menu_msg,255,"\yEnable Warcraft 3 Plugin:\w^n^n1.  Yes^n2.  No")
        #endif
        #if LANG_GER
		format(menu_msg,255,"\yWarcraft 3 Plugin aktivieren:\w^n^n1.  Ja^n2.  Nein")
	#endif
        #if LANG_FRE
		format(menu_msg,255,"\yActiver le Plugin Warcraft 3:\w^n^n1.  Oui^n2.  Non")
	#endif
	else
	#if LANG_ENG
		format(menu_msg,255,"\yDisable Warcraft 3 Plugin:\w^n^n1.  Yes^n2.  No")		
	#endif
	#if LANG_GER
		format(menu_msg,255,"\yWarcraft 3 Plugin deaktivieren:\w^n^n1.  Ja^n2.  Nein")		
	#endif
        #if LANG_FRE
		format(menu_msg,255,"\yDesactiver le Plugin Warcraft 3:\w^n^n1.  Oui^n2.  Non")
	#endif
	new Float:vote_time = get_cvar_float("amx_vote_time") + 2.0
	voting = get_gametime() + vote_time
	vote_ratio = get_cvar_float("amx_votewar3_ratio")
	show_menu(0,keys,menu_msg,floatround(vote_time))
	set_task(vote_time,"check_votes")
	#if LANG_ENG
	console_print(id,"Voting has started...")		
	#endif
	#if LANG_GER
	console_print(id,"Abstimmung hat begonnen...")		
	#endif
        #if LANG_FRE
	console_print(id,"Le vote a commence ...")
	#endif	
	option=0
	if (saychat==1)
		return PLUGIN_CONTINUE
	return PLUGIN_HANDLED
}

public vote_count(id,key){
	if (get_cvar_float("amx_vote_answers")) {
		new name[MAX_NAME_LENGTH]
		get_user_name(id,name,MAX_NAME_LENGTH-1)
		#if LANG_ENG
			client_print(0,print_chat,"* %s voted %s",name,key ? "against" : "for" )
		#endif
		#if LANG_GER
			client_print(0,print_chat,"* %s voted %s",name,key ? "dagegen" : "dafuer" )
		#endif
		#if LANG_FRE
			client_print(0,print_chat,"* %s a vote %s.",name,key ? "contre" : "pour" )
		#endif		
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
		#if LANG_ENG
			client_print(0,print_chat,"* Voting failed (yes ^"%d^") (no ^"%d^") (needed ^"%.2f^")", option, inum-option,vote_ratio)
		#endif
		#if LANG_GER
			client_print(0,print_chat,"* Abstimmung fehlgeschlagen (ja ^"%d^") (nein ^"%d^") (benoetigt ^"%.2f^")", option, inum-option,vote_ratio)
		#endif
		#if LANG_FRE
			client_print(0,print_chat,"* Le vote a rate. (oui ^"%d^") (non ^"%d^") (besoin de ^"%.2f^")", option, inum-option,vote_ratio)
		#endif		
	
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
	#if LANG_ENG
		client_print(0,print_chat,"* Voting successful (ratio ^"%.2f^") (needed ^"%.2f^"). \
			The result: Warcraft 3 Plugin %s", result_v,vote_ratio,status)
	#endif
	#if LANG_GER
                client_print(0,print_chat,"* Abstimmung erfolgreich (ratio ^"%.2f^") (benoetigt ^"%.2f^"). \
                        The result: Warcraft 3 Plugin %s", result_v,vote_ratio,status)
	#endif
	#if LANG_FRE
                client_print(0,print_chat,"* Le vote a reussi (ratio ^"%.2f^") (besoin de ^"%.2f^"). \
                        Le resultat: %s Le Plugin Warcraft 3", result_v,vote_ratio,status)
	#endif	
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
                wc3_menuMain(id)
	else if (equali(said,"^"/icons^"") || equali(said,"^"icons^""))
                icons(id)                
        else if (equali(said,"^"/savexp^"") || equali(said,"^"savexp^""))
        	save_xp_info(id)  
        #if WAR3STATS
	        else if (equali(said,"^"stats^"") )
	        	display_stats(statsParm)    
	#endif       
	return PLUGIN_CONTINUE
}

public display_race_select(){
	new id, idtext[3], menu_msg[256]
	new racexp1[8], racexp2[8], racexp3[8], racexp4[8], racexp5[8]
	read_argv(1,idtext,2)
	read_argv(2,racexp1,7)
	read_argv(3,racexp2,7)
	read_argv(4,racexp3,7)
	read_argv(5,racexp4,7)
	read_argv(6,racexp5,7)
	
	id = str_to_num(idtext)
	#if LANG_ENG
		format(menu_msg,255,"\ySelect Race:\RExperience^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n\w5. %s\y\R%s^n^n\
			\w6. Auto-select", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4, racename[5], racexp5)
	#endif
	#if LANG_GER
		format(menu_msg,255,"\yWaehle eine Rasse:\RErfahrung^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n\w5. %s\y\R%s^n^n\
			\w6. Auto-Auswahl", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4, racename[5], racexp5)
	#endif
	#if LANG_FRE
		format(menu_msg,255,"\yChoisi ta Race:\RExperience^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n\w5. %s\y\R%s^n^n\
			\w6. Selection Automtique", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4, racename[5], racexp5)
	#endif	
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5),menu_msg,-1)
	return PLUGIN_HANDLED
}

public save_xp_info(id){
	if( get_cvar_num("mp_savexp") ){
		#if MYSQL_ENABLED
			#if LANG_ENG
				client_print(id,print_chat, "[WC3] XP is saved to a reliable database automatically.")
			#endif
			#if LANG_GER
				client_print(id,print_chat, "[WC3] XP wird zuverlaessig automatisch in eine Datenbank gespeichert.")
			#endif
			#if LANG_FRE
				client_print(id,print_chat, "[WC3] L'XP est sauvegarde automatiquement dans une base de donnees fiable.")
			#endif
		#else
			#if LANG_ENG
				client_print(id,print_chat, "[WC3] XP is saved automatically, but not in a database, you may experience lost XP.")
			#endif
                        #if LANG_GER
				client_print(id,print_chat, "[WC3] XP wird automatisch gespeichert, aber nicht in eine Datanbank, XP kann verlorengehen.")
			#endif
                        #if LANG_FRE
				client_print(id,print_chat, "[WC3] L'XP est sauvegarde automatiquement, mais pas dans une base de donnees, tu risques de perdre l'XP.")
			#endif
		#endif
	}else{
		#if LANG_ENG
			client_print(id,print_chat, "[WC3] XP is not saved on this server at this time, sorry!")
		#endif
                #if LANG_GER
			client_print(id,print_chat, "[WC3] XP wird auf diesen Server nicht gespeichert!")	
		#endif
                #if LANG_FRE
			client_print(id,print_chat, "[WC3] L'XP n'est pas sauvegarde sur ce serveur pour l'instant, desole!")	
		#endif

	}
	
	return PLUGIN_CONTINUE
}

public check_war3(){
	if (get_cvar_num("sv_warcraft3")==0){
		warcraft3=false
		#if defined _amxmodx_included
			set_msg_block(gmsgDeathMsg,BLOCK_NOT)
		#else
			#if WC3_MODULE
				block_message(0)
			#else
				MessageBlock( gmsgDeathMsg,BLOCK_NOT)
			#endif
		#endif
	}
	else{
		warcraft3=true
		#if defined _amxmodx_included
			set_msg_block(gmsgDeathMsg,BLOCK_SET)	
		#else
			#if WC3_MODULE
				block_message(gmsgDeathMsg)
			#else
				MessageBlock( gmsgDeathMsg,BLOCK_SET)
			#endif
		#endif
	}
	return PLUGIN_CONTINUE
}

#if !SHORT_TERM

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

	new playerid[MAX_ID_LENGTH], playername[MAX_NAME_LENGTH]

	#if !MYSQL_ENABLED
		#if VAULT_SAVE
			new currentrace[2]
		#else
			new xp[8], currentrace[2]
		#endif		
	#endif
	
	if (id){
		get_user_name(id,playername,MAX_NAME_LENGTH-1)

		#if !MYSQL_ENABLED
			format(currentrace,1,"%d",p_skills[id][0])
		#endif

		#if !STEAM_POWERED
			if (get_user_wonid(id)!=-1)
				num_to_str(get_user_wonid(id),playerid,31)	// by wonid
			else
		#endif
		#if SAVE_WITH_IP
			get_user_ip(id,playerid,MAX_ID_LENGTH-1,0)
		#else
			get_user_authid(id,playerid,MAX_ID_LENGTH-1)		// by AUTHID (Steam Users)
		#endif
	}

	#if !MYSQL_ENABLED && !VAULT_SAVE
	else{
		parse(givenline, playerid,31, playername,31, xp,7, currentrace,1)
	}
	#endif

	#if MYSQL_ENABLED
		new mquery[1024]
		
		if( contain(playername,"'") != -1 ){
			format(playername,31, "bad_name_quote")
//			while(containi(playername,"'") != -1) replace(playername,32,"'","\'") 
		}else if( contain(playername,"!") != -1 ){
			format(playername,31, "bad_name_exclaim")
//			while(containi(playername,"!") != -1) replace(playername,32,"!","\!") 			
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
				new nameo[MAX_NAME_LENGTH]
				get_user_name(id,nameo,MAX_NAME_LENGTH-1)
				log_to_file(logfile2,"%s saved %d skill",nameo,skillStat[id])
			#endif
			
		#endif
		
	#else
	#if VAULT_SAVE

		if (id && playerxp[id] && p_skills[id][0])
		{
			new vaultkey[64], vaultdata[128], timet[32], index[32]
			get_time("%m %d",timet,31)		
			format(vaultkey, 63, "%s_%s", playerid, currentrace)
			format(vaultdata, 127, "%d %d %d %d %d %d",playerxp[id],p_skills[id][0],
				p_skills[id][1],p_skills[id][2],p_skills[id][3],p_skills[id][4])
			set_vaultdata(vaultkey,vaultdata)
						
			// Prune Information Setup
			format(vaultkey, 63,"%s",playerid)							
			
			if(!vaultdata_exists(vaultkey))
			{
				get_vaultdata("war3index", index, 31);
				format(vaultdata,127,"%d ^"%s^" %s",index,playername,timet)
				set_vaultdata(vaultkey,vaultdata)
				format(vaultkey,63,"pruneindex_%s",index)
				set_vaultdata(vaultkey,playerid)
				format(index,31,"%d",(str_to_num(index)+1))
				set_vaultdata("war3index",index)
			}
			else
			{	
				get_vaultdata(vaultkey,vaultdata,127)
				parse(vaultdata,index,31)
				format(vaultdata,127,"%d ^"%s^" %s",index,playername,timet)
				set_vaultdata(vaultkey,vaultdata)
			}				
		}
		
	#else
		new race[2]
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
		#if !VAULT_SAVE
			new nextline=0
			new textline[128], textlength
			new matchfound = 0
		#endif
	#endif

	new playerid[MAX_ID_LENGTH], playername[MAX_NAME_LENGTH]
	new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
	new racexp[5]={0,0,0,0,0}

	get_user_name(id,playername,MAX_NAME_LENGTH-1)

	#if !STEAM_POWERED
		if (get_user_wonid(id)!=-1)
			num_to_str(get_user_wonid(id),playerid,31)	// by wonid
		else
	#endif
	#if SAVE_WITH_IP
		get_user_ip(id,playerid,MAX_ID_LENGTH-1,0)
	#else
		get_user_authid(id,playerid,MAX_ID_LENGTH-1)
	#endif
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
				if (str_to_num(race)>=1 && str_to_num(race)<=5)
					racexp[str_to_num(race)-1] = str_to_num(xp)
				mysql_check_error()
			}
	
			if (p_skills[id][0])
				racexp[p_skills[id][0]-1]=playerxp[id]
			server_cmd("display_race_select %d %d %d %d %d %d",id, racexp[0], racexp[1], racexp[2], racexp[3], racexp[4])
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
					new nameo[MAX_NAME_LENGTH]
					get_user_name(id,nameo,MAX_NAME_LENGTH-1)
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
	#if VAULT_SAVE
	
		new vaultkey[64], vaultdata[128], currentrace[2]
		format(currentrace,1,"%d",p_skills[id][0])
				
		if(returnrace)
		{			
			for(new i=1;i < 6; i++)
			{
			
				format(vaultkey, 63, "%s_%d", playerid, i)
				if (vaultdata_exists(vaultkey))
				{
					get_vaultdata(vaultkey, vaultdata,127)
					parse(vaultdata,xp,7,race,1,skill1,1,skill2,1,skill3,1,skill4,1)
					
					racexp[i-1] = str_to_num(xp)
				}
				else
				{
					racexp[i-1] = 0
				}
				
				if (p_skills[id][0])
					racexp[p_skills[id][0]-1]=playerxp[id]
				server_cmd("display_race_select %d %d %d %d %d %d",id, racexp[0], racexp[1], racexp[2], racexp[3], racexp[4])
			}			
		}
		else
		{
			format(vaultkey, 63, "%s_%s", playerid, currentrace)
			if(vaultdata_exists(vaultkey))
			{
				get_vaultdata(vaultkey, vaultdata, 127)
				parse(vaultdata,xp,7,race,1,skill1,1,skill2,1,skill3,1,skill4,1)
				
				playerxp[id]=str_to_num(xp)
				p_skills[id][1]=str_to_num(skill1)
				p_skills[id][2]=str_to_num(skill2)
				p_skills[id][3]=str_to_num(skill3)
				p_skills[id][4]=str_to_num(skill4)

				displaylevel(id,0)
			}
			else
			{
				playerxp[id]=0
				p_skills[id][1]=0
				p_skills[id][2]=0
				p_skills[id][3]=0
				p_skills[id][4]=0
				displaylevel(id,0)
			}
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
			server_cmd("display_race_select %d %d %d %d %d %d",id, racexp[0], racexp[1], racexp[2], racexp[3], racexp[4])
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
	#endif
	
	return PLUGIN_CONTINUE
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
			server_cmd("exec %s", PATHTOMYSQLCFG)
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

	public mysql_check_error(){
		new merror[256]
		mysql_error(mysql,merror,255)
		if (merror[0])
		{
			server_print("MYSQL Error Query: %s", merror)
		}
	}

#else
#if !VAULT_SAVE
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
#endif

public plugin_end(){
	if (!warcraft3 || !saved_xp)
		return PLUGIN_CONTINUE

	#if MYSQL_ENABLED
		write_all()
		#if MYSQL_AUTO_PRUNING || WAR3_MYSQL_TOP15
			new mquery[1024]
		#endif

		#if MYSQL_AUTO_PRUNING
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
	#if VAULT_SAVE
		write_all()
		
		// Prune Code follows
		new index, nIndex, strIndex[31], vaultkey[64], playerid[32], playername[MAX_NAME_LENGTH]
		new currentmonth[3], currentday[3], vaultdata[128], junk[32]
		new dayofyear, currentdayofyear, month[3] = "", day[3] = ""
		new daysinmonth[12] = {31,28,31,30,31,30,31,31,30,31,30,31}
		new bool:prunetime=false
		
		get_time("%d",currentday,2)
		get_time("%m",currentmonth,2)
		
		currentdayofyear = str_to_num(currentday)
		for (new i=1; i<str_to_num(currentmonth); i++)
			currentdayofyear+=daysinmonth[i-1]

		get_vaultdata("prunedate",vaultdata,127)
		parse(vaultdata,month,2,day,2)
		dayofyear = str_to_num(day)+VAULT_PRUNE_LIMIT
		for(new j=1; j<str_to_num(month); j++)
			dayofyear+=daysinmonth[j-1]
		if(dayofyear>365)
			dayofyear-=365			
		
		if(dayofyear<=currentdayofyear)
		{
			format(vaultdata,127,"%s %s",currentmonth,currentday)
			set_vaultdata("prunedate",vaultdata)
			prunetime=true
		}
		else
			prunetime=false

		month = ""
		day = ""
			
		get_vaultdata("war3index",vaultdata,127)
		nIndex = str_to_num(vaultdata)
		index = 1

		while(index < nIndex && prunetime)
		{
			format(vaultkey,63,"pruneindex_%d",index)
			if(vaultdata_exists(vaultkey))
			{	
				get_vaultdata(vaultkey,playerid,31)
				get_vaultdata(playerid,vaultdata,127)
				parse(vaultdata,junk,31,playername,MAX_NAME_LENGTH-1,month,2,day,2)
				
				dayofyear = str_to_num(day)+DAYS_BEFORE_DELETE
				for(new j=1; j<str_to_num(month); j++)
					dayofyear+=daysinmonth[j-1]
				if(dayofyear>365)
					dayofyear-=365
				
				month = ""
				day = ""
				
				if(dayofyear<=currentdayofyear)
				{	
					for(new i=1;i < 6; i++)
					{
						format(vaultkey, 63, "%s_%d", playerid, i)
						remove_vaultdata(vaultkey)
					}
					format(vaultkey,63,"pruneindex_%d",index)
					remove_vaultdata(vaultkey)
					format(vaultkey,63,"%s",playerid)
					remove_vaultdata(vaultkey)
				}
				else
					index++
			}
			else
			{
				if(--nIndex > 1)
				{	
					num_to_str(nIndex,strIndex,31)
					format(vaultkey,63,"pruneindex_%s",strIndex)
					get_vaultdata(vaultkey,playerid,31)
					remove_vaultdata(vaultkey)
					format(vaultkey,63,"pruneindex_%d",index)
					set_vaultdata(vaultkey,playerid)
					get_vaultdata(playerid,vaultdata,127)
					parse(vaultdata,junk,31,playername,MAX_NAME_LENGTH-1,month,2,day,2)				
					format(vaultdata,127,"%d ^"%s^" %s %s",index,playername,month,day)
					set_vaultdata(playerid,vaultdata)
					set_vaultdata("war3index",strIndex)
				}
				else
					set_vaultdata("war3index","1")
			}	
		}
		
	#else
		update_file(0)
		write_all()
		new nextline=0
		new textline[128], textlength, playerid[32], playername[MAX_NAME_LENGTH]
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
						parse(textline, playerid,31, playername,MAX_NAME_LENGTH-1, xp,7, race,1, skill1,1, skill2,1, skill3,1, skill4,1, month,2, day,2, hour,2, minutes,2)
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
			if (equali(textline,mapname))
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
		
	}
	return PLUGIN_CONTINUE
}

#endif

#if ITEMS_DROPABLE
public wc3_dropitem(id) {

	if (playeritem[id] == 0) 
		return PLUGIN_HANDLED
	if (!is_user_alive(id) && playeritem[id] == ANKH)
		return PLUGIN_HANDLED
	if (playeritem[id] == HEALTH && get_user_health(id) < 40)
		return PLUGIN_HANDLED
		
        new NewItem
	#if defined _amxmodx_included
	        NewItem = create_entity("info_target")
	#else
        	NewItem = CreateEntity("info_target")
	#endif
	canpickup[id] = false
	if(NewItem == 0) {
   		return PLUGIN_HANDLED_MAIN
   	}
	new ident[1]
	new Float:g_origin[3]
	new Float:velocity[3]
	new Float:MinBox[3]
	new Float:MaxBox[3]
	new Float:Color[3]
	MinBox[0] = -5.0
	MinBox[1] = -5.0
	MinBox[2] = -5.0
	MaxBox[0] = 5.0
	MaxBox[1] = 5.0
	MaxBox[2] = 5.0

	switch (playeritem[id]) {
		case ANKH: 	{Color[0] = 255.0 ; Color[1] = 255.0 ; Color[2] = 10.0 ;}
		case BOOTS: 	{Color[0] = 10.0  ; Color[1] = 10.0  ; Color[2] = 255.0;}
		case CLAWS: 	{Color[0] = 255.0 ; Color[1] = 10.0  ; Color[2] = 10.0 ;}
		case CLOAK: 	{Color[0] = 10.0  ; Color[1] = 255.0 ; Color[2] = 255.0;}
		case MASK: 	{Color[0] = 10.0  ; Color[1] = 255.0 ; Color[2] = 10.0 ;}
		case IMMUNITY: 	{Color[0] = 96.0  ; Color[1] = 36.0  ; Color[2] = 196.0;}
		case FROST: 	{Color[0] = 255.0 ; Color[1] = 255.0 ; Color[2] = 255.0;}
		case HEALTH: 	{Color[0] = 255.0 ; Color[1] = 10.0  ; Color[2] = 255.0;}
	}
	
	#if defined _amxmodx_included
                entity_set_int(NewItem, EV_INT_renderfx, kRenderFxGlowShell)
                entity_set_float(NewItem, EV_FL_renderamt, 150.0)
                entity_set_int(NewItem, EV_INT_rendermode, kRenderTransAlpha)
                entity_set_vector(NewItem, EV_VEC_rendercolor,Color)
                                                                                                                            
                entity_set_string(NewItem, EV_SZ_classname, "wc3item")
                entity_set_model(NewItem, "models/rshell_big.mdl")
                                                                                                                            
                entity_set_vector(NewItem, EV_VEC_mins, MinBox)
                entity_set_vector(NewItem, EV_VEC_maxs, MaxBox)
                entity_get_vector(id, EV_VEC_origin, g_origin)
                entity_set_origin(NewItem, g_origin)
                                                                                                                            
                entity_set_int(NewItem, EV_INT_effects, 32)
                entity_set_int(NewItem, EV_INT_solid, 1)
                entity_set_int(NewItem, EV_INT_movetype, 6)
                entity_set_edict(NewItem, EV_ENT_owner, id)
                entity_set_int(NewItem, EV_INT_iuser4, playeritem[id])
                                                                                                                            
                VelocityByAim(id, 400 , velocity)
                entity_set_vector(NewItem, EV_VEC_velocity, velocity)
	#else
		Entvars_Set_Int(NewItem, EV_INT_renderfx, kRenderFxGlowShell)
		Entvars_Set_Float(NewItem, EV_FL_renderamt, 150.0)
		Entvars_Set_Int(NewItem, EV_INT_rendermode, kRenderTransAlpha)
		Entvars_Set_Vector(NewItem, EV_VEC_rendercolor,Color)

		Entvars_Set_String(NewItem, EV_SZ_classname, "wc3item") 
		ENT_SetModel(NewItem, "models/rshell_big.mdl") 

		Entvars_Set_Vector(NewItem, EV_VEC_mins, MinBox) 
		Entvars_Set_Vector(NewItem, EV_VEC_maxs, MaxBox) 
		Entvars_Get_Vector(id, EV_VEC_origin, g_origin)
		ENT_SetOrigin(NewItem, g_origin) 

		Entvars_Set_Int(NewItem, EV_INT_effects, 32) 
		Entvars_Set_Int(NewItem, EV_INT_solid, 1)    
		Entvars_Set_Int(NewItem, EV_INT_movetype, 6)
		Entvars_Set_Edict(NewItem, EV_ENT_owner, id)
		Entvars_Set_Int(NewItem, EV_INT_iuser4, playeritem[id])
	
		VelocityByAim(id, 400 , velocity)
		Entvars_Set_Vector(NewItem, EV_VEC_velocity, velocity)
	#endif	

	emit_sound(NewItem, CHAN_WEAPON, "weapons/knife_slash2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM) 
	ident[0] = id
	set_task(0.3,"safedrop",2300+id,ident,1)
	if (playeritem[id] == BOOTS && is_user_alive(id))
		set_user_maxspeed(id,240.0)
	if (playeritem[id]==HEALTH && is_user_alive(id))
		set_user_health(id,get_user_health(id)-HEALTHBONUS)
	if (playeritem[id]==CLOAK && is_user_alive(id))	
		set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransAdd,255)
	playeritem[id] = 0
	new parm[1]
	parm[0]=id
	set_task(0.1,"unholyspeed",19,parm,1)
	displaylevel(id, 1)
	return PLUGIN_HANDLED
}

public safedrop(ident[]) {
	canpickup[ident[0]] = true
	remove_task(1001+ident[0])
	return PLUGIN_HANDLED
}
#endif

#if ITEMS_DROPABLE

#if defined _amxmodx_included
public pfn_touch(ptr, ptd) {
   	new itemClassName[MAX_NAME_LENGTH], playerClassname[MAX_NAME_LENGTH]
	entity_get_string(ptr, EV_SZ_classname, itemClassName, MAX_NAME_LENGTH-1);
   	entity_get_string(ptd, EV_SZ_classname, playerClassname, MAX_NAME_LENGTH-1) 
    	if(equal(itemClassName,"wc3item") && equal(playerClassname,"player")) {
		if(!canpickup[ptd])
			return PLUGIN_CONTINUE
   		if (playeritem[ptd] == 0) {
			playeritem[ptd] = entity_get_int(ptr, EV_INT_iuser4)
			if (playeritem[ptd]==HEALTH)
				set_user_health(ptd,get_user_health(ptd)+HEALTHBONUS)
			emit_sound(ptr, CHAN_WEAPON, "items/equip_nvg.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			#if LANG_ENG
				client_print(ptd,print_chat,"You picked up: %s",longItemName[playeritem[ptd]-1])
			#endif
			#if LANG_GER
				client_print(ptd,print_chat,"Du hast folgendes aufgehoben: %s",longItemName[playeritem[ptd]-1])
			#endif
			#if LANG_FRE
				client_print(ptd,print_chat,"Tu as gagne: %s",longItemName[playeritem[ptd]-1])
			#endif
	   		remove_entity(ptr)
   			displaylevel(ptd, 1)
   		}
   	}
	return PLUGIN_CONTINUE
}
#else

public vexd_pfntouch(pToucher, pTouched) {
	new itemClassName[MAX_NAME_LENGTH], playerClassname[MAX_NAME_LENGTH]
	Entvars_Get_String(pToucher, EV_SZ_classname, itemClassName, MAX_NAME_LENGTH-1);
	Entvars_Get_String(pTouched, EV_SZ_classname, playerClassname, MAX_NAME_LENGTH-1)
	if(equal(itemClassName,"wc3item") && equal(playerClassname,"player")) {
		if(!canpickup[pTouched])
			return PLUGIN_HANDLED
		if (playeritem[pTouched] == 0) {
			playeritem[pTouched] = Entvars_Get_Int(pToucher, EV_INT_iuser4)
			if (playeritem[pTouched]==HEALTH)
				set_user_health(pTouched,get_user_health(pTouched)+HEALTHBONUS)
			emit_sound(pToucher, CHAN_WEAPON, "items/equip_nvg.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			#if LANG_ENG
				client_print(pTouched,print_chat,"You picked up: %s",longItemName[playeritem[pTouched]-1])
			#endif
			#if LANG_GER
				client_print(pTouched,print_chat,"Du hast folgendes aufgehoben: %s",longItemName[playeritem[pTouched]-1])
			#endif
			#if LANG_FRE
				client_print(pTouched,print_chat,"Tu as gagne: %s",longItemName[playeritem[pTouched]-1])
			#endif
			RemoveEntity(pToucher)
			displaylevel(pTouched, 1)
		}
	}
	return 1;
}
#endif
#endif

public shopmenu(id){
	#if SHOPMENU_IN_BUYZONE
        	if (warcraft3==false){
               		return PLUGIN_CONTINUE
               	}else if( get_cvar_num("mp_shopzone") && isBuyzone[id] == false ){
               		return PLUGIN_CONTINUE
        	}
        #else               
               	if (warcraft3==false)
               		return PLUGIN_CONTINUE
        #endif

	new pos = 0
	new keys = (1<<0|1<<1|1<<2|1<<3|1<<4|1<<5|1<<6|1<<7|1<<8|1<<9)
	new menu_body[512]
	#if LANG_ENG
		pos += format(menu_body[pos], 511-pos, "\yBuy Item\R$   Cost^n^n")
	#endif
	#if LANG_GER
		pos += format(menu_body[pos], 511-pos, "\yKaufe Gegenstand\R$   Kosten^n^n")
	#endif
	#if LANG_FRE
		pos += format(menu_body[pos], 511-pos, "\yAchat d'Objets\R$   Cout^n^n")
	#endif	
	for (new i = 0; i<9; i++){
		pos += format(menu_body[pos], 511-pos, "\w%d. %s\y\R%d^n",i+1,longItemName[i],itemcost[i])
	}
	#if LANG_ENG
		pos += format(menu_body[pos], 511-pos, "^n\w0. Exit")
	#endif
        #if LANG_GER
		pos += format(menu_body[pos], 511-pos, "^n\w0. Schliessen")
	#endif
        #if LANG_FRE
		pos += format(menu_body[pos], 511-pos, "^n\w0. Quitter")
	#endif	
        if (is_user_alive(id))
		show_menu(id,keys,menu_body,-1)
	return PLUGIN_HANDLED
}

public buy_item(id,key){
	#if defined _amxmodx_included
		new usermoney = cs_get_user_money(id) 
	#else
		new usermoney = get_user_money(id) 
	#endif
	if (key==9)
		return PLUGIN_HANDLED
	if (playeritem[id] > 0 && !(key==TOME-1))
		usermoney = usermoney + itemcost[playeritem[id]-1]
	if (usermoney<itemcost[key]){
	#if LANG_ENG
		client_print(id,print_center,"You have insufficient funds!")
	#endif
	#if LANG_GER
		client_print(id,print_center,"Du hast nicht genuegend Geld!")
	#endif
	#if LANG_FRE
		client_print(id,print_center,"Tu n'as pas assez d'argent!")
	#endif	
		return PLUGIN_HANDLED
	}
	else if (key==TOME-1){
		#if defined _amxmodx_included
			cs_set_user_money(id,usermoney-itemcost[key],1)
		#else
			set_user_money(id,usermoney-itemcost[key],1)
		#endif
		playerxp[id]+=XPBONUS	// Give XP bonus for buying Tome of Experience
	}
	else{
		#if defined _amxmodx_included
			cs_set_user_money(id,usermoney-itemcost[key],1)
		#else
			set_user_money(id,usermoney-itemcost[key],1)
		#endif
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


public wc3_menuMain(id)
{
        new pos = 0
        new menu_body[512]
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<9)
	#if LANG_ENG
		new menu_items[3][]= {  "Commands",
					"Settings",
					"Help" }
		pos += format(menu_body[pos], 511-pos, "\yWarCraft3 XP Menu^n^n")	
	#endif
	#if LANG_GER
		new menu_items[3][]= {  "Befehle",
					"Einstellungen",
					"Hilfe" }	
		pos += format(menu_body[pos], 511-pos, "\yWarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menu_items[3][]= {  "Commande",
					"Arrangements",
					"Aide" }	
		pos += format(menu_body[pos], 511-pos, "\yMenu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<3; i++)
	{
		pos += format(menu_body[pos], 511-pos, "\w%d. %s^n",i+1,menu_items[i])
	}
	#if LANG_ENG
		pos += format(menu_body[pos], 511-pos, "^n\w0. Exit")
	#endif
	#if LANG_GER
		pos += format(menu_body[pos], 511-pos, "^n\w0. Schliessen")
	#endif
	#if LANG_FRE
		pos += format(menu_body[pos], 511-pos, "^n\w0. Quitter")
	#endif	
        show_menu(id,keys,menu_body,-1)
        return PLUGIN_HANDLED
}

public do_wc3menuMain(id,key){
        switch (key){
                case 0: wc3_menuCommand(id)
                case 1: wc3_menuSetting(id)
                case 2: wc3_menuHelp(id)
                default:        return PLUGIN_HANDLED
        }
        if (file_exists("sound/warcraft3/PickUpItem.wav")==1)
                emit_sound(id,CHAN_STATIC, "warcraft3/PickUpItem.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)

        return PLUGIN_HANDLED
}

public wc3_menuCommand(id)
{
        new pos = 0
        new menu_body[512]
        #if ITEMS_DROPABLE
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9)
	#if LANG_ENG
		new menu_items[5][]= {	"Change Race",
					"Select Skills",
					"Player Skills",
					"Buy Item",
					"Drop Item" }
		pos += format(menu_body[pos], 511-pos, "\yCommands - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menu_items[5][]= {	"Rasse wechseln",
					"Waehle Skills",
					"Spieler Skills",
					"Item kaufen",
					"Item fallenlassen" }
		pos += format(menu_body[pos], 511-pos, "\yBefehle - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menu_items[5][]= {	"Changer de Race",
					"Choisis ta Competence",
					"Competences des Joueurs",
					"Menu d'Achat",
					"Drop Item" }	
		pos += format(menu_body[pos], 511-pos, "\yCommande - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<5; i++)
	{
		pos += format(menu_body[pos], 511-pos, "\w%d. %s^n",i+1,menu_items[i])
	}
	#else
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9)
	#if LANG_ENG
		new menu_items[4][]= {	"Change Race",
					"Select Skills",
					"Player Skills",
					"Shop Menu" }
		pos += format(menu_body[pos], 511-pos, "\yCommands - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menu_items[4][]= {	"Rasse wechseln",
					"Waehle Skills",
					"Spieler Skills",
					"Shop Menue" }
		pos += format(menu_body[pos], 511-pos, "\yBefehle - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menu_items[4][]= {	"Changer de Race",
					"Choisis ta Competence",
					"Competences des Joueurs",
					"Menu d'Achat" }	
		pos += format(menu_body[pos], 511-pos, "\yCommande - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<4; i++)
	{
		pos += format(menu_body[pos], 511-pos, "\w%d. %s^n",i+1,menu_items[i])
	}	
	#endif
	#if LANG_ENG
		pos += format(menu_body[pos], 511-pos, "^n\w0. Exit")
	#endif
	#if LANG_GER
		pos += format(menu_body[pos], 511-pos, "^n\w0. Schliessen")
	#endif
	#if LANG_FRE
		pos += format(menu_body[pos], 511-pos, "^n\w0. Quitter")
	#endif	
        show_menu(id,keys,menu_body,-1)
        return PLUGIN_HANDLED
}

public do_wc3menuCommand(id,key)
{
	switch (key)
	{
		case 0: change_race(id,1)
		case 1: select_skill(id,1)
		case 2: player_skills(id,1)
		case 3: shopmenu(id)
		#if ITEMS_DROPABLE
			case 4: wc3_dropitem(id)
		#endif
		default: return PLUGIN_HANDLED
	}
        if (file_exists("sound/warcraft3/PickUpItem.wav")==1)
                emit_sound(id,CHAN_STATIC, "warcraft3/PickUpItem.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
        return PLUGIN_HANDLED	
}

public wc3_menuSetting(id)
{
        new pos = 0
        new menu_body[512]
        #if OPT_RESETSKILLS
	new keys = (1<<0)|(1<<1)|(1<<9)
	#if LANG_ENG
		new menu_items[2][]= {	"Toggle Icons",
					"Reset Skills" }
		pos += format(menu_body[pos], 511-pos, "\ySettings - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menu_items[2][]= {	"Toggle Icons",
					"Reset Skills" }
		pos += format(menu_body[pos], 511-pos, "\yEinstellungen - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menu_items[2][]= {	"Toggle Icons",
					"Annule les Competences" }	
		pos += format(menu_body[pos], 511-pos, "\yArrangements - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<2; i++)
	{
		pos += format(menu_body[pos], 511-pos, "\w%d. %s^n",i+1,menu_items[i])
	}
	#else
	new keys = (1<<0)|(1<<9)
	#if LANG_ENG
		new menu_items[1][]= {	"Toggle Icons" }
		pos += format(menu_body[pos], 511-pos, "\ySettings - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menu_items[1][]= {	"Toggle Icons" }
		pos += format(menu_body[pos], 511-pos, "\yEinstellungen - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menu_items[1][]= {	"Toggle Icons" }	
		pos += format(menu_body[pos], 511-pos, "\yArrangements - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<1; i++)
	{
		pos += format(menu_body[pos], 511-pos, "\w%d. %s^n",i+1,menu_items[i])
	}	
	#endif
	#if LANG_ENG
		pos += format(menu_body[pos], 511-pos, "^n\w0. Exit")
	#endif
	#if LANG_GER
		pos += format(menu_body[pos], 511-pos, "^n\w0. Schliessen")
	#endif
	#if LANG_FRE
		pos += format(menu_body[pos], 511-pos, "^n\w0. Quitter")
	#endif	
        show_menu(id,keys,menu_body,-1)
        return PLUGIN_HANDLED  
}

public do_wc3menuSetting(id,key)
{
	switch (key)
	{
		case 0: icons(id)
		#if OPT_RESETSKILLS
			case 1: resetskills(id)
		#endif		
		default: return PLUGIN_HANDLED
	}
        if (file_exists("sound/warcraft3/PickUpItem.wav")==1)
                emit_sound(id,CHAN_STATIC, "warcraft3/PickUpItem.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
        return PLUGIN_HANDLED	
}

public wc3_menuHelp(id)
{
        new pos = 0
        new menu_body[512]
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<9)
	#if LANG_ENG
		new menu_items[3][]= {	"War3 Help",
					"Skills Info",
					"Items Info" }
		pos += format(menu_body[pos], 511-pos, "\yHelp - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menu_items[3][]= {	"War3 Hilfe",
					"Skills Info",
					"Items Info" }
		pos += format(menu_body[pos], 511-pos, "\yHilfe - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menu_items[3][]= {	"War3 Aide",
					"Info des Competences",
					"Info sur les Objets" }	
		pos += format(menu_body[pos], 511-pos, "\yAide - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<3; i++)
	{
		pos += format(menu_body[pos], 511-pos, "\w%d. %s^n",i+1,menu_items[i])
	}
	#if LANG_ENG
		pos += format(menu_body[pos], 511-pos, "^n\w0. Exit")
	#endif
	#if LANG_GER
		pos += format(menu_body[pos], 511-pos, "^n\w0. Schliessen")
	#endif
	#if LANG_FRE
		pos += format(menu_body[pos], 511-pos, "^n\w0. Quitter")
	#endif	
        show_menu(id,keys,menu_body,-1)
        return PLUGIN_HANDLED        
}

public do_wc3menuHelp(id,key)
{
	switch (key)
	{
		case 0: saywar3_info(id)		
		case 1: skills_info(id,1)
		case 2: items_info(id,1)
		default: return PLUGIN_HANDLED
	}
        if (file_exists("sound/warcraft3/PickUpItem.wav")==1)
                emit_sound(id,CHAN_STATIC, "warcraft3/PickUpItem.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
        return PLUGIN_HANDLED	
}


// -------- modified Code From Wc3 FT
// -------- an admin requested this

public setSpectator(id) 
{ 
	new arg[12] 
	read_data( 2 , arg , 11 ) 
	p_spectator[id] = ( arg[10] == '2' ) ? true : false 
}

public spec_info(id)
{
	if (warcraft3==false)
                        return PLUGIN_CONTINUE
	if(!p_spectator[id])
			return PLUGIN_CONTINUE
	new p_data = read_data(2)
	if (!is_user_connected(p_data))
			return PLUGIN_CONTINUE 
	new name[32]
	get_user_name( p_data ,name,31) 
	new temp[512]
	new message[1048]

	if (playerxp[p_data]<0)
		playerxp[p_data]=0

	for (new i=0; i<=10; ++i){
		if (playerxp[p_data]>=xplevel[i])
			p_level[p_data]=i
		else
			break
	}

	format(temp,511,"Player: %s ^n",name)
	add(message,1047,temp)
	if (p_level[p_data]==0)
		format(temp,511,"%s   XP: %d/%d",shortracename[p_skills[p_data][0]],playerxp[p_data],xplevel[p_level[p_data]+1])
	else if (p_level[p_data]<10)
		format(temp,511,"%s Level %d   XP: %d/%d",shortracename[p_skills[p_data][0]],p_level[p_data],playerxp[p_data],xplevel[p_level[p_data]+1])
	else
		format(temp,511,"%s Level %d   XP: %d/%d",shortracename[p_skills[p_data][0]],p_level[p_data],xplevel[10],xplevel[10])

	add(message,1047,temp)
	if (playeritem[p_data]!=0){
			format(temp,511,"    %s ",playeritem[p_data]?itemname[playeritem[p_data]-1]:"")
	}
	else
		format(temp,511," ")
	new health = get_user_health(p_data)
	add(message,1047,temp)
	if (health>500)
		health-=1024
	#if LANG_ENG
		#if defined _amxmodx_included
			format(temp,511,"^nHealth: %d Armor: %d^nMoney: %d",health, get_user_armor(p_data), cs_get_user_money(p_data))
		#else
			format(temp,511,"^nHealth: %d Armor: %d^nMoney: %d",health, get_user_armor(p_data), get_user_money(p_data))
		#endif
	#endif
	#if LANG_GER
		#if defined _amxmodx_included
			format(temp,511,"^nHealth: %d Armor: %d^nGeld: %d",health, get_user_armor(p_data), cs_get_user_money(p_data))
		#else
			format(temp,511,"^nHealth: %d Armor: %d^nGeld: %d",health, get_user_armor(p_data), get_user_money(p_data))
		#endif
	#endif
	#if LANG_FRE
		#if defined _amxmodx_included
			format(temp,511,"^nVie: %d Armure: %d^nArgent: %d",health, get_user_armor(p_data), cs_get_user_money(p_data))
		#else
			format(temp,511,"^nVie: %d Armure: %d^nArgent: %d",health, get_user_armor(p_data), get_user_money(p_data))
		#endif
	#endif
	add(message,1047,temp)
	set_hudmessage(255,255,255,0.018,0.9,2, 1.5, 12.0, 0.02, 5.0, 1) 
	show_hudmessage(id,message) 
	
	return PLUGIN_CONTINUE	

}

public icons(id)
{
	if(showicons[id])
	{
		set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
		#if LANG_ENG
			show_hudmessage(id,"You will no longer see teammate race icons.")
		#endif
		#if LANG_GER
			show_hudmessage(id,"Icons von Teamkameraden werden nicht angezeigt.")
		#endif
		#if LANG_FRE
			show_hudmessage(id,"Tu ne verras plus les icones de la race de tes coequipiers.")
		#endif
		showicons[id]=false
	}
	else
	{
		showicons[id]=true
		set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
		#if LANG_ENG
			show_hudmessage(id,"You will now see teammate race icons.")
		#endif
                #if LANG_GER
			show_hudmessage(id,"Icons von Teamkameraden werden angezeigt.")
                #endif
		#if LANG_FRE
			show_hudmessage(id,"Tu verras maintenant les icones de la race de tes coequipiers.")
		#endif                
	}
	
	return PLUGIN_HANDLED
}

#if SHOPMENU_IN_BUYZONE
public BuyZone(id) 
{
	if (get_cvar_num("mp_shopzone")){ 
		if (read_data(1)){ 
			isBuyzone[id] = true 
		}else{ 
			isBuyzone[id] = false 
		} 
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

//---- Borrowed from amx_gasnades --------------------------------------------------------------
/* Log a kill using standard HL-logging format */
stock logKill(attacker, victim, weaponDescription[] )
  {
    //Save Hummiliation
    new namea[MAX_NAME_LENGTH],namev[MAX_NAME_LENGTH],authida[MAX_ID_LENGTH],authidv[MAX_ID_LENGTH],teama[8],teamv[8]

    //Info On Attacker
    get_user_name(attacker,namea,MAX_NAME_LENGTH-1)
    get_user_team(attacker,teama,7)
    #if SAVE_WITH_IP
        get_user_ip(attacker,authida,MAX_ID_LENGTH-1,0)
    #else
        get_user_authid(attacker,authida,MAX_ID_LENGTH-1)
    #endif
    //Info On Victim
    get_user_name(victim,namev,MAX_NAME_LENGTH-1)
    get_user_team(victim,teamv,7)
    #if SAVE_WITH_IP
	get_user_ip(victim,authidv,MAX_ID_LENGTH-1,0)
    #else
        get_user_authid(victim,authidv,MAX_ID_LENGTH-1)
    #endif    
    //Log This Kill
    log_message("^"%s<%d><%s><%s>^" killed ^"%s<%d><%s><%s>^" with ^"%s^"",
    namea,get_user_userid(attacker),authida,teama,namev,get_user_userid(victim),authidv,teamv, weaponDescription )
  }
//----------------------------------------------------------------------------------------------

public show_race(id) {
  if (get_cvar_num("sv_wc3icons") && warcraft3 && showicons[id]){
    new tid = read_data(2)
    new icon
    switch (p_skills[tid][0]) {
      case 1:  icon = race_1
      case 2:  icon = race_2
      case 3:  icon = race_3
      case 4:  icon = race_4
      case 5:  icon = race_5
      default: icon = race_0    
    }
    if (friend[id] == 1){
      message_begin( MSG_ONE, SVC_TEMPENTITY, { 0, 0, 0 }, id )
      write_byte( TE_PLAYERATTACHMENT )
      write_byte(tid)
      write_coord(40)
      write_short(icon)
      write_short(10)
      message_end()
    }
  }
  return PLUGIN_CONTINUE
}

public hide_race(id) {
  if (get_cvar_num("sv_wc3icons")){
    new tid = read_data(2)
    message_begin( MSG_ONE, SVC_TEMPENTITY, { 0, 0, 0 }, id )
    write_byte( TE_KILLPLAYERATTACHMENTS )
    write_byte(tid)
    message_end()
  }
  return PLUGIN_CONTINUE
}
#if !WC3_MODULE || defined _amxmodx_included
public orcgren(parm[]){
    	new id = parm[0]
    	new string[MAX_NAME_LENGTH], grenadeid = 0
    	do
    	{
        	grenadeid = get_grenade_id(id, string, MAX_NAME_LENGTH-1, grenadeid)
    	} while (grenadeid &&!equali(HEGRENADE_MODEL,string));

    	if (grenadeid) {
		new Float:Color[3]
		Color[0] = 255.0 ; Color[1] = 10.0  ; Color[2] = 10.0 ;
		#if defined _amxmodx_included
			entity_set_int(grenadeid, EV_INT_renderfx, kRenderFxGlowShell)
			entity_set_float(grenadeid, EV_FL_renderamt, 10.0)
			entity_set_vector(grenadeid, EV_VEC_rendercolor,Color)
		#else
			Entvars_Set_Int(grenadeid, EV_INT_renderfx, kRenderFxGlowShell)
			Entvars_Set_Float(grenadeid, EV_FL_renderamt, 10.0)
			Entvars_Set_Vector(grenadeid, EV_VEC_rendercolor,Color)
		#endif
	}
}

public GrenTextMsg(id){
	new name[MAX_NAME_LENGTH]
	read_data(3, name, MAX_NAME_LENGTH-1)
	if (id==find_player("a",name) && p_skills[id][0] == 3 && p_skills[id][2])
	{	
		new parm[1]
		parm[0] = id
		set_task(0.1,"orcgren",347,parm,1)
	}
	return PLUGIN_CONTINUE
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

	if (get_cvar_num("sv_allowdownload")){
		race_1 = precache_model("sprites/warcraft3/i_undead.spr")
		race_2 = precache_model("sprites/warcraft3/i_human.spr")
		race_3 = precache_model("sprites/warcraft3/i_orc.spr")
		race_4 = precache_model("sprites/warcraft3/i_nightelf.spr")
		race_5 = precache_model("sprites/warcraft3/i_bloodelf.spr")
		race_0 = precache_model("sprites/warcraft3/i_none.spr")
	}
	
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
	#if ITEMS_DROPABLE
                precache_model("models/rshell_big.mdl")
		precache_sound("weapons/knife_slash2.wav")
		precache_sound("items/equip_nvg.wav")
        #endif
	
	/* Some custom player models don't render transparent, let's make sure the client has the originals */
        force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/arctic/arctic.mdl")
        force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/gign/gign.mdl")
        force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/gsg9/gsg9.mdl")
        force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/guerilla/guerilla.mdl")
        force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/leet/leet.mdl")
        force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/sas/sas.mdl")
        force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/terror/terror.mdl")
        force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/urban/urban.mdl")
        force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/vip/vip.mdl")
        set_cvar_float("mp_consistency",1.0)

        server_print("[WC3] Forcing unmodified player models") 
        #if SHORT_TERM
		#if defined _amxmodx_included
			server_print("[WC3] Using Engine Module, Short Term XP Modus")
		#else
       		 	#if WC3_MODULE
        			server_print("[WC3] Using WC3 Module, Short Term XP Modus")
	        	#else
       				server_print("[WC3] Using Vexd Module, Short Term XP Modus")
			#endif
        	#endif
        #else
		#if defined _amxmodx_included
       			server_print("[WC3] Using Engine Module, Long Term XP Modus, saving xp with: vault[%d] mysql[%d]",VAULT_SAVE,MYSQL_ENABLED)
		#else
	              	#if WC3_MODULE
        			server_print("[WC3] Using WC3 Module, Long Term XP Modus, saving xp with: vault[%d] mysql[%d]",VAULT_SAVE,MYSQL_ENABLED)
        		#else
        			server_print("[WC3] Using Vexd Module, Long Term XP Modus, saving xp with: vault[%d] mysql[%d]",VAULT_SAVE,MYSQL_ENABLED)
	        	#endif
		#endif
        #endif

	return PLUGIN_CONTINUE
}

public set_team(id) {
  if (get_cvar_num("sv_wc3icons")){
    friend[id] = read_data(2)
  }
}

public inconsistent_file(id, const filename[], reason[256] ){
   new name[MAX_NAME_LENGTH]
   get_user_name(id,name,MAX_NAME_LENGTH-1)
   server_print("I: %s for %s",filename,name)
   server_print("R: %s",reason)
   format(reason,255,"File %s may be outdated or modified",filename)
   return PLUGIN_HANDLED
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

	#if !ULTIMATE_FIRST_ROUND
		first_round = true
	#endif
	
	gmsgDeathMsg = get_user_msgid("DeathMsg")
	gmsgFade = get_user_msgid("ScreenFade")
	gmsgShake = get_user_msgid("ScreenShake")
	gmsgStatusText = get_user_msgid("StatusText")
	#if defined _amxmodx_included
		register_plugin("Warcraft 3 XP","2.5","AMX(X) Community")
		register_cvar("Warcraft_3_XP", "2.5",FCVAR_SERVER)
	#else
		register_plugin("Warcraft 3 XP","pre-2.22.12","AMX(X) Community")
		register_cvar("Warcraft_3_XP", "pre-2.22.12",FCVAR_SERVER)	
	#endif
	#if LANG_ENG
		register_menucmd(register_menuid("\yWarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<9),"do_wc3menuMain")
		#if ITEMS_DROPABLE
			register_menucmd(register_menuid("\yCommands - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9),"do_wc3menuCommand")
		#else
			register_menucmd(register_menuid("\yCommands - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9),"do_wc3menuCommand")
		#endif
		#if OPT_RESETSKILLS
			register_menucmd(register_menuid("\ySettings - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<9),"do_wc3menuSetting")
		#else
			register_menucmd(register_menuid("\ySettings - WarCraft3 XP Menu"),(1<<0)|(1<<9),"do_wc3menuSetting")
		#endif
		register_menucmd(register_menuid("\yHelp - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<9),"do_wc3menuHelp")
		register_menucmd(register_menuid("\ySelect Race:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5),"set_race")
		register_menucmd(register_menuid("\ySelect Skill:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9),"set_skill")
		#if !BLINK_HUMAN_ULTIMATE
			register_menucmd(register_menuid("\yTeleport to:"),1023,"set_target")
		#endif
		register_menucmd(register_menuid("\yBuy Item"),1023,"buy_item")
	#endif
	#if LANG_GER
		register_menucmd(register_menuid("\yWarCraft3 XP Menue"),(1<<0)|(1<<1)|(1<<2)|(1<<9),"do_wc3menuMain")
		#if ITEMS_DROPABLE
			register_menucmd(register_menuid("\yBefehle - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9),"do_wc3menuCommand")
		#else
			register_menucmd(register_menuid("\yBefehle - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9),"do_wc3menuCommand")
		#endif
		#if OPT_RESETSKILLS
			register_menucmd(register_menuid("\yEinstellungen - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<9),"do_wc3menuSetting")
		#else
			register_menucmd(register_menuid("\yEinstellungen - WarCraft3 XP Menu"),(1<<0)|(1<<9),"do_wc3menuSetting")
		#endif
		register_menucmd(register_menuid("\yHilfe - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<9),"do_wc3menuHelp")		
		register_menucmd(register_menuid("\yWaehle eine Rasse:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5),"set_race")
		register_menucmd(register_menuid("\yWaehle eine Fertigkeit:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9),"set_skill")
		#if !BLINK_HUMAN_ULTIMATE
			register_menucmd(register_menuid("\yTeleportieren zu:"),1023,"set_target")
		#endif
		register_menucmd(register_menuid("\yKaufe Gegenstand"),1023,"buy_item")
	#endif
	#if LANG_FRE
		register_menucmd(register_menuid("\yMenu de WarCraft3 XP"),(1<<0)|(1<<1)|(1<<2)|(1<<9),"do_wc3menuMain")
		#if ITEMS_DROPABLE
			register_menucmd(register_menuid("\yCommande - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9),"do_wc3menuCommand")
		#else
			register_menucmd(register_menuid("\yCommande - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9),"do_wc3menuCommand")
		#endif
		#if OPT_RESETSKILLS
			register_menucmd(register_menuid("\yArrangements - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<9),"do_wc3menuSetting")
		#else
			register_menucmd(register_menuid("\yArrangements - WarCraft3 XP Menu"),(1<<0)|(1<<9),"do_wc3menuSetting")
		#endif
		register_menucmd(register_menuid("\yAide - WarCraft3 XP Menu"),(1<<0)|(1<<1)|(1<<2)|(1<<9),"do_wc3menuHelp")		
		register_menucmd(register_menuid("\yChoisi ta Race:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5),"set_race")
		register_menucmd(register_menuid("\yChoisi ta Competence:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9),"set_skill")
		#if !BLINK_HUMAN_ULTIMATE
			register_menucmd(register_menuid("\ySe Teleporter sur:"),1023,"set_target")
		#endif
		register_menucmd(register_menuid("\yAchat d'Objets"),1023,"buy_item")
	#endif	
	register_menucmd(register_menuid("Warcraft 3 Plugin:") ,(1<<0)|(1<<1),"vote_count") 
	#if XPRESET
		#if LANG_ENG
			register_menucmd(register_menuid("Your Wish Is:") ,(1<<0)|(1<<1),"xp_choice") 
		#endif
		#if LANG_GER
			register_menucmd(register_menuid("Dein Wunsch:") ,(1<<0)|(1<<1),"xp_choice")
		#endif
		#if LANG_FRE
			register_menucmd(register_menuid("Quel est ton desir ?") ,(1<<0)|(1<<1),"xp_choice")
		#endif		
	#endif
	#if !DISABLE_FORCESKIN
		register_menucmd(register_menuid("Terrorist_Select"),1023,"forceskin")
		register_menucmd(register_menuid("CT_Select"),1023,"forceskin")
		register_menucmd(-26,1023,"forceskin")		// VGUI
		register_menucmd(-27,1023,"forceskin")		// VGUI
	#endif
        register_clcmd("war3menu","wc3_menuMain",-1,"- Show WarCraft3 XP Player menu")
	register_clcmd("changerace","change_race",-1,"changerace")	// mp_allowchangerace must be set to 1
	register_clcmd("selectskill","select_skill",-1,"selectskill")	// Use "selectskill" console command to lvl up
	register_concmd("playerskills","player_skills",-1,"playerskills")
	register_clcmd("skillsinfo","skills_info",-1,"skillsinfo")
	register_clcmd("itemsinfo","items_info",-1,"itemsinfo")
	register_clcmd("war3help","war3_info",-1,"war3help")	
	register_clcmd("savexp","save_xp_info",-1,"savexp")
	register_clcmd("war3vote","war3_vote",-1,"war3vote")
	register_clcmd("ultimate","ultimate",-1,"ultimate")
	register_clcmd("icons","icons",-1,"- Turn off race icons above teammates heads.")
	register_clcmd("shopmenu","shopmenu",-1,"shopmenu")
	register_clcmd("say","check_say")
	register_clcmd("say_team","check_say")
	register_srvcmd("display_race_select","display_race_select")		// For internal use only (don't use this this command)
	#if ITEMS_DROPABLE
		register_clcmd("dropitem","wc3_dropitem",0,"")
	#endif
	#if XP_CHANGEABLE_OUTSIDE
		register_srvcmd("wc3_changexp","changeXP")
	#endif
	
	#if SLAY_LOSERS	
		register_event("SendAudio","end_round","a","2=%!MRAD_terwin","2=%!MRAD_ctwin") 
		register_event("SendAudio","end_round_draw","a","2=%!MRAD_rounddraw") 
	#else
		register_event("SendAudio","end_round","a","2=%!MRAD_terwin","2=%!MRAD_ctwin","2=%!MRAD_rounddraw") 
	#endif
	
	register_event("Battery","vip_spawn","b","1=200")
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
	#if !WC3_MODULE
		register_event("TextMsg","GrenTextMsg","b","2&#Game_radio", "4&#Fire_in_the_hole")
	#endif
	register_event("StatusValue","set_team","be","1=1")
	register_event("StatusValue","show_race","be","1=2","2!0")
	register_event("StatusValue","hide_race","be","1=1","2=0")
	register_event("TextMsg","setSpectator","bd","2&ec_Mod") 
	register_event("StatusValue","spec_info","bd","1=2")	
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
	
	#if SHORT_TERM
		register_cvar("mp_savexp","0",FCVAR_SERVER)
	#else
		register_cvar("mp_savexp","1",FCVAR_SERVER)
		register_cvar("mp_savebyname","0")
		#if VAULT_SAVE
			// Vault initialization. First we check for war3index.
			// If it doesn't exist, this is a fresh Vault. We set
			// the default information required by the Vault.
			// If war3index exists, we have a previous Vault. We
			// then check for the Vault version. If it doesn't exist
			// the Vault is the oldest version and needs converted.
			// We then check to ensure there is a prune date, which
			// was not part of the original version either.
			if(!vaultdata_exists("war3index"))
			{
				set_vaultdata("war3index","1")
				set_vaultdata("vault_version","1.00")
				set_vaultdata("prunedate","1 1")
			}
			else
			{
				if(!vaultdata_exists("vault_version"))
				{
					set_vaultdata("vault_version","1.00")
					convert_vault()
				}
				if(!vaultdata_exists("prunedate"))
					set_vaultdata("prunedate","1 1")
			}
			
			#if CONVERT_TO_VAULT
				// This is for converting from war3users.ini to Vault.
				// Please read warcraft3.cfg for more information
				convert_to_vault()			
			#endif			
		#endif
	#endif

        #if SHOPMENU_IN_BUYZONE
                register_cvar("mp_shopzone","1")
        #endif

	register_cvar("mp_xpmultiplier","1.0",FCVAR_SERVER)
	register_cvar("mp_weaponxpmodifier","1")
	register_cvar("sv_warcraft3","1",FCVAR_SERVER)
	register_cvar("sv_allowwar3vote","1",0)
	register_cvar("sv_wc3icons","1")
	
	if (!cvar_exists("amx_vote_delay"))
		register_cvar("amx_vote_delay","60")
	if (!cvar_exists("amx_vote_time"))
		register_cvar("amx_vote_time","10")
	if (!cvar_exists("amx_vote_answers"))
		register_cvar("amx_vote_answers","1")

	#if MYSQL_ENABLED && !SHORT_TERM
		server_cmd("exec %s", PATHTOMYSQLCFG)
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

	#if !TEST_MODE && !SHORT_TERM
		set_task(1.0,"set_longtermxp",458)
		#if MYSQL_ENABLED
			set_task(1.0,"set_mysql",324)
		#endif
	#endif

	set_xpmultiplier()
	return PLUGIN_CONTINUE
}

#if VAULT_SAVE
public convert_vault()
{
	new index, nIndex, vaultkey[64], vaultdata[128], playerid[32], playername[MAX_NAME_LENGTH]
	new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
	new month[3], day[3], mMonth, mDay
		
	get_vaultdata("war3index",vaultdata,127)
	nIndex = str_to_num(vaultdata)
	index = 1

	while(index < nIndex)
	{
		format(vaultkey,63,"pruneindex_%d",index)
		get_vaultdata(vaultkey,playerid,31)
		
		mDay = 0
		mMonth = 0

		for(new i=1; i<6; i++)
		{
			format(vaultkey,63,"%s_%d",playerid,i)
			if(vaultdata_exists(vaultkey))
			{
				get_vaultdata(vaultkey,vaultdata,127)
				parse(vaultdata, playerid,31, playername,MAX_NAME_LENGTH-1, xp,7, race,1, skill1,1, skill2,1, skill3,1, skill4,1, month,2, day,2)
				
				if(mMonth == 0 || mDay == 0)
				{
					mMonth = str_to_num(month)
					mDay = str_to_num(day)
				}
				else if(str_to_num(month) > mMonth)
				{
					mMonth = str_to_num(month)
					if(str_to_num(day) > mDay)
						mDay = str_to_num(day)
				}
				
				format(vaultdata,127,"%s %s %s %s %s %s",xp,race,skill1,skill2,skill3,skill4)
				set_vaultdata(vaultkey,vaultdata)
			}
		}
		
		if(mMonth == 0)
			mMonth=1
		if(mDay == 0)
			mDay=1
			
		format(vaultdata,127,"%d ^"%s^" %d %d",index,playername,mMonth,mDay)
		set_vaultdata(playerid,vaultdata)

		index++		
	}

	return PLUGIN_CONTINUE
}

#if CONVERT_TO_VAULT
public convert_to_vault()
{

	new index[32], vaultkey[64], vaultdata[128], playerid[32], playername[MAX_NAME_LENGTH]
	new textline[128], nextline, textlength
	new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
	new month[3], day[3]
	#if !VAULT_PROTECT
		new omonth[3], oday[3], mMonth, mDay
	#endif
	
		
	if(file_exists(XPFILENAME))
	{
		do
		{
			nextline = read_file(XPFILENAME,nextline,textline,127,textlength)
						
			if(textlength && contain(textline,"**") && contain(textline,"##"))
			{
			
				parse(textline,playerid,31,playername,MAX_NAME_LENGTH-1,xp,7,race,1,skill1,1,skill2,1,skill3,1,skill4,1,month,2,day,2)
				
				format(vaultkey,63,"%s_%s",playerid,race)


				#if VAULT_PROTECT   // If we're protecting the Vault, check if the key exists first.
				if(!vaultdata_exists(vaultkey))
				{
				#endif
				
					format(vaultdata, 127, "%s %s %s %s %s %s",xp,race,skill1,skill2,skill3,skill4)
					set_vaultdata(vaultkey,vaultdata)
				
				#if VAULT_PROTECT
				}
				#endif
				
				if(!vaultdata_exists(playerid))
				{
					get_vaultdata("war3index", index, 31);
					format(vaultdata,127,"%s ^"%s^" %s %s",index,playername,month,day)
					set_vaultdata(playerid,vaultdata)
					format(vaultkey,63,"pruneindex_%s",index)
					set_vaultdata(vaultkey,playerid)
					format(index,31,"%d",(str_to_num(index)+1))
					set_vaultdata("war3index",index)
				}
				#if !VAULT_PROTECT   // If we're protecting the vault, leave the current key alone.
				else
				{
					mMonth=str_to_num(month)
					mDay=str_to_num(day)
					get_vaultdata(playerid,vaultdata,127)
					parse(vaultdata,index,31,playername,MAX_NAME_LENGTH-1,omonth,2,oday,2)
					if(str_to_num(oday) > mDay)
						mDay=str_to_num(oday)
					if(str_to_num(omonth) > mMonth)
						mMonth=str_to_num(omonth)
					format(vaultdata,127,"%s ^"%s^" %d %d",index,playername,mMonth,mDay)
					set_vaultdata(playerid,vaultdata)					
				}
				#endif					
			}
			
			write_file("war3users.bak",textline,-1)
			write_file(XPFILENAME,"",nextline-1)
			
		} while (nextline)
		
		delete_file(XPFILENAME)
	}

	return PLUGIN_CONTINUE
}

#endif
#endif
