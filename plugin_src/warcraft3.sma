/* AMXX Mod script. 
* 
*  Warcraft 3 XP 
*  Original idea and code by SpaceDude 
*
*  Version 2.6.4
*
*  Read readme.txt for a desription of the plugin.
*  Read installer.txt for installation information.
*  Read changelog.txt for info about this plugins history of changes.
*		
*
*  Update/Modifications by: 	Mr. B, Dopefish, Tri Moon, Mike4066, [AoL]LuckyJ, 
*				[AoL]Demandred, Pimp Daddy, Denkkar Seffyd, rACEmic,
*				willyumyum, trinity, ferret, No FuN, SniperBeamer,
*				Johnny got his gun, Lazarus Long
* 
*  Maintainer of the 2.6.x code: Michael McKoy a.k.a. "ferret"
*  Maintainer of the 2.5.x and prior code: Ryan Schulze a.k.a. "DopeFish"
*
*
* (C)2003-2005 "Spacedude" and all people listed under "Update/Modifications"
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
* http://wc3mods.net/forums/index.php?c=6
*/

new const WAR3XP_PLUGINNAME[] = "Warcraft 3 XP";
new const WAR3XP_VERSION[]    = "2.6.4";
new const WAR3XP_DATE[]       = __DATE__;
new const WAR3XP_PLUGINNAME_SHORT[] = "war3xp";

#include <amxmodx>
#include <amxmisc>

// Pre-compilation configuration, edit to your needs:
// if you change something in warcraft3.cfg, you will have to recompile the plugin
// Linux: ./amxxsc warcraft3.sma -o../plugins/warcraft3.amxx
// Win:     amxxsc warcraft3.sma -o../plugins/warcraft3.amxx
#include "warcraft3.cfg"

// Options not set in warcraft3.cfg get set to the default value here.
// Yeah I know this blows up the .sma code to ungodly dimensions but 
// it dosen't have any impact on the .amx file and makes it easier for
// admins to maintain their .cfg

#if !defined(NEW_DAMAGEEVENT)
	#define NEW_DAMAGEEVENT 0
#endif

#if !defined (SHORT_TERM)
      #define SHORT_TERM 1
#endif
#if !defined (MYSQL_ENABLED)
      #define MYSQL_ENABLED 0
#endif
#if !defined (VAULT_SAVE)
	#if MYSQL_ENABLED
		#define VAULT_SAVE 0
	#else
		#define VAULT_SAVE 1
	#endif
#endif
#if VAULT_SAVE
	#if !defined (CONVERT_TO_VAULT)
	      #define CONVERT_TO_VAULT 0
	#endif
	#if !defined (VAULT_PROTECT)
	      #define VAULT_PROTECT 1
	#endif
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
#if !defined (STARTINGLEVEL)
      #define STARTINGLEVEL 0
#endif
#if !defined (EXPANDED_RACES)
      #define EXPANDED_RACES 0
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
#if !defined (ORCNADELESS)
      #define ORCNADELESS 1
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
#if !defined (SHOPMENU_IN_BUYZONE)
      #define SHOPMENU_IN_BUYZONE 1
#endif
#if !defined (NON_ULTIMATE_VIP)
      #define NON_ULTIMATE_VIP 1
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
#if !defined (ORC_SPAM_FIX)
      #define ORC_SPAM_FIX 0
#endif
#if !defined(REINCARNATION_DELETE)
	#define REINCARNATION_DELETE 0
#endif
#if !defined(ROUNDEND_SAVEALL)
	#define ROUNDEND_SAVEALL 1
#endif


// Expanded Races.. No need to include if not enabled.
#if EXPANDED_RACES
	#if !defined (BLOOD_ELF_ULT)
		#define BLOOD_ELF_ULT 6
	#endif
	#if !defined (TROLL_ULT)
		#define TROLL_ULT 6
	#endif
	#if !defined (DWARF_ULT)
		#define DWARF_ULT 6
	#endif
	#if !defined (LICH_ULT)
		#define LICH_ULT 6
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
	#if !defined (HEALINGWAND_HEALTH)
		#define HEALINGWAND_HEALTH 10
	#endif
	#if !defined (HEALINGWAND_RANGE)
		#define HEALINGWAND_RANGE 400
	#endif
	#if !defined (HEALINGWAND_COOLDOWN)
		#define HEALINGWAND_COOLDOWN 40.0
	#endif
	#if !defined (TROLL_REGEN_FLASH)
		#define TROLL_REGEN_FLASH 1
	#endif
	#if !defined (DWARF_SMOKE)
		#define DWARF_SMOKE 1
	#endif
	#if !defined (AVATAR_DURATION)
		#define AVATAR_DURATION 2.0
	#endif
	#if !defined (AVATAR_COOLDOWN)
		#define AVATAR_COOLDOWN 40.0
	#endif
	#if !defined (FROSTNOVA_RANGE)
		#define FROSTNOVA_RANGE 400
	#endif
	#if !defined (FROSTNOVA_DURATION)
		#define FROSTNOVA_DURATION 5.0
	#endif	
	#if !defined (FROSTNOVA_COOLDOWN)
		#define FROSTNOVA_COOLDOWN 40.0
	#endif
#endif
// End of configuration check

#include <engine>
#include <fun>
#include <cstrike>

// We saw memory leaks with some of the new code.. Let's see
// if giving a little more memory helps.
#pragma dynamic 6144
                                                                                 
#if MYSQL_ENABLED
	// Prints debug information regarding SQL statments and replies
	#if !defined (SQL_DEBUG)
		#define SQL_DEBUG 0
	#endif
	// Type of SQL being used
	#define SQL_FAIL -1
	#define SQL_NONE 0
	#define SQL_MYSQL 1
	#define SQL_SQLITE 2
	// Type of SQlite database synchronization
	#define SQLITE_SYNC_OFF 0
	#define SQLITE_SYNC_NORMAL 1
	#define SQLITE_SYNC_FULL 2
	new const PATHTOMYSQLCFG[] = "addons/amxmodx/configs/mysql.cfg"
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
#if EXPANDED_RACES
#define DWARF_AVATAR_ADJ 10240
#endif

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

#define BOMBSHAREXPRADIUS 1000
#define HOSTAGESHAREXPRADIUS 1000

/* ---------------------------------- Enter Warcraft 3 configuration area 2--------------------------------------	*/		
//                 Ankh, Boots,Claws,Cloak, Mask, Necklace,  Orb, Health, Tome
new itemcost[9] = {1500,  2000, 1000,  800, 2000,     1000, 2000,   1000, 4000}

// UNDEAD SKILLS
new Float:p_vampiric[3] = {0.15,0.30,0.45}	// Vampiric Aura (skill 1)
new p_vampirichealth[3] = {100,100,100}		// Vampiric Aura Max Health (skill 1)
new Float:p_unholy[3] = {260.0,285.0,310.0}	// Unholy Aura (skill 2)
new Float:p_levitation[3] = {0.8,0.6,0.4}	// Levitation (skill 3)

// HUMAN SKILLS
new p_invisibility[3] = {180,150,120}		// Invisibility (skill 1)
#if BLINK_HUMAN_ULTIMATE
	new p_devotion[3] = {120,140,160}	// Devotion Aura (skill 2) (Teleport where aiming)
#else
	new p_devotion[3] = {125,150,175}	// Devotion Aura (skill 2) (Teleport to teammates)
#endif
new Float:p_bash[3] = {0.15,0.30,0.45}		// Bash (skill 3)

// ORC SKILLS
new Float:p_critical[3] = {0.15,0.15,0.15}	// Critical Strike (skill 1)
#if ORCNECKLACE
	new Float:p_grenade[3] = {2.0,3.0,5.0}	// Critical Grenade (skill 2) (Strength if necklace protects)
#else
	#if ORCNADELESS
		new Float:p_grenade[3] = {1.5,2.25,3.25}	// Critical Grenade (skill 2) (Strength if necklace dosen't protect)
	#else
		new Float:p_grenade[3] = {2.0,3.0,5.0}		// Full damage if ORCNADE_LESS is disabled.
	#endif
#endif
new Float:p_ankh[3] = {0.333,0.666,1.0}		// Equipment reincarnation (skill 3)

// NIGHTELF SKILLS
new Float:p_evasion[3] = {0.1,0.2,0.3}		// Evasion (skill 1)
new Float:p_thorns[3] = {0.05,0.15,0.25}	// Thorns Aura (skill 2)
new Float:p_trueshot[3] = {0.13,0.27,0.40}	// Trueshot Aura (skill 3)

// No need to include other races if disabled
#if EXPANDED_RACES
	// BLOODELF SKILLS
	new p_crimsonarmor[3] = {25,50,100}		// Crimson Armor (skill 1)
	new Float:p_manashield[3] = {0.1,0.2,0.35}	// Mana Shield (skill 2)
	new p_bloodlust[3] = {3,6,10}			// Bloodlust (skill 3)
	new Float:p_bloodslow[3] = {210.0,190.0,170.0}	// bloodslow (slowed speed of enemies effected by bloodlust)

	// TROLL SKILLS
	new Float:p_silence[3] = {0.33,0.66,1.00}	// Silent Run (skill 1)
	new p_regen[3] = {50,75,100}			// Regeneration (skill 2) (Max health regenerated)
	new Float:p_regenrate = 2.0			// Regeneration (skill 2) (Number of seconds between ticks)
	new p_regenhp = 3				// Regeneration (skill 2) (Amount per tick)
	new p_berserk[3] = {20,40,60}			// Berserk (skill 3) (Berserk works when health is below this)
	new p_berserkdamage = 15			// Berserk (skill 3) (Additional damage added)
	
	// DWARF SKILLS
	new p_grenades[3] = {1,2,3}			// Grenades (skill 1)
	new p_mitharmor[3] = {3,6,10}			// Mithril Armor (skill 2)
	new p_ammoclip[3] = {3,6,10}			// Extra Ammo (skill 3)
	
	// LICH SKILLS
	new Float:p_iceshards[3] = {0.10,0.15,0.20}	// Ice Shards (skill 1)
	new Float:p_terror[3] = {0.10,0.20,0.30}	// Terror (skill 2)
	new Float:p_frostarmor[3] = {0.15,0.30,0.45}	// Frost Armor (skill 3) (Percent chance)
	new p_frostarmormax[3] = {100,100,100}		// Frost ARmor (skill 2) (Max armor)
#endif

/* ---------------------------------- Exit Warcraft 3 configuration area 2--------------------------------------	*/		

#if SHORT_TERM && MYSQL_ENABLED
	Dont_have_short_term_AND_mysql__ = 0		// look at me, I create compiler errors
#endif
#if !SHORT_TERM
	#if MYSQL_ENABLED
		#include <dbi>
		new Sql:mysql
		new Result:res
		new mysqltablename[64]
		new const g_MySQL[] = "MySQL"
		new const g_SQLite[] = "SQLite"
		new SQLtype[16]
		new iSQLtype = SQL_NONE
	#else
		#include <vault>
		#if CONVERT_TO_VAULT   
			new XPFILENAME[] = "war3users.ini"   
		#endif 
	#endif
#endif

// This is used for a variety of purposes. It contains the names of the 30 weapon ids and
// their corresponding ammo types. A "" is inserted if the weapon doesn't exist in CS or
// there is no ammo type, such as with grenades.
new gWpnNames[32][32] = {"weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "", "weapon_mac10", "weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550", "weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249", "weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552", "weapon_ak47", "weapon_knife", "weapon_p90", "", ""}
new gWpnAmmo[32][32] = {"ammo_357sig", "", "ammo_762nato", "", "ammo_buckshot", "", "ammo_45acp", "ammo_556nato", "", "ammo_9mm", "ammo_57mm", "ammo_45acp", "ammo_556nato", "ammo_556nato", "ammo_556nato", "ammo_45acp", "ammo_9mm", "ammo_338magnum", "ammo_9mm", "ammo_556natobox", "ammo_buckshot", "ammo_556nato", "ammo_9mm", "ammo_762nato", "", "ammo_50ae", "ammo_556nato", "ammo_762nato", "", "ammo_57mm", "", ""}
new gWpnUsed[33]
new Float:gTrueSpeed[33]

new bool:bFreezeTime = false

#if ULTIMATE_READY_ICON
	new gmsgIcon 
#endif

#if SHOPMENU_IN_BUYZONE
	new bool:isBuyzone[33] 
#endif

#if DEBUG_LOGGER	
	new logfilename[256] = "addons/amxmodx/logs/war3load.log"
	new logfile2[256] = "addons/amxmodx/logs/war3save.log"		
#endif

new friend[33]
new p_level[33]
new p_skills[33][5]
new iglow[33][4]
new playerxp[33]
new KilledHostageIndex[33]
new gHostageSaverIndex[33] 
new playeritem[33]

// Reincarnation
new armorondeath[33]
new savedweapons[33][32]
new savednumber[33]

//orc nade spam fix
#if ORC_SPAM_FIX
       new bool:thrownorcnade[33]
#endif

new playerItemOld[33]
new bool:p_evadenextshot[33]
new bool:diedlastround[33]
new bool:slowed[33]		
new bool:stunned[33]
new bool:issearching[33]
new bool:lightninghit[33]
new bool:ultimateused[33]
new bool:p_spectator[33]

#if ITEMS_DROPABLE
	new bool:canpickup[33]
#endif

new const HEGRENADE_MODEL[] = "models/w_hegrenade.mdl"

#if OPT_RESETSKILLS
	new bool:resetskill[33]
#endif

#if XPLOIT_PROTECT
	new bool:antiExploit
#endif

new bool:hasdefuse[33]
new bool:helmet[33]
new bool:changingrace[33]
new bool:showicons[33]
new bool:warcraft3
new bool:saved_xp

new bool:gRoundOver = false
new bool:gNewSpawn = false

new Float:voting
new Float:vote_ratio
new Float:fExplodeTime
new option
//new bombdefuser

#if ATTEMPT_DEFUSE_BONUS
        new bombDefuserIndex[33]
#endif

#if KILL_BOMB_CARRIER
	new bombCarrier
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

#if EXPANDED_RACES
new race_5
new race_6
new race_7
new race_8

// Blood Elf Variables
new iBloodLust[33]		// Bloodlust'd? 0 = false, 1-3 for skill level

// Dwarf Variables
new iDwarfGrenades[33][3]	// Keep up with how many grenades a dwarf player has used
new iDwarfReload[33]		// Keep up with when to reload dwarf ammo clips
new bool:bDwarfAmmo[33][33]	// Keep up with whether or not a player's ammo clip has been enlarged.
new bool:bDwarfAvatar[33]	// Is player in Avatar form?
new iDwarfAvatarHP[33]		// Original player health before Avatar form.

// Lich Variables
new bool:bFrostNova[33]		// Frostnova'd? True/false
#endif

// Night Elves Entangle
new bool:bEntangled[33]

new vip_id 			// VIP CHECK

new xplevel[11] = {0,100,300,600,1000,1500,2100,2800,3600,4500,5500}
new xpgiven[11] = {60,80,100,120,140,160,180,200,220,240,260}

new KILLRESCUEMANXP = KILLRESCUEMAN_XP_BONUS  * 10
new HOSTAGEXP = HOSTAGE_XP_BONUS * 10 
new DEFUSEXP = DEFUSE_XP_BONUS * 10
new BOMBPLANTXP = BOMBPLANT_XP_BONUS * 10 
new XPBONUS = TOME_XP_BONUS * 10

new Float:weaponxpmultiplier[31] = {1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0}

#if LANG_ENG
	#if !EXPANDED_RACES
		new racename[5][] = {"No race","Undead Scourge","Human Alliance","Orcish Horde","Night Elves of Kalimdor"}
		new shortracename[5][] = {"No race","Undead", "Human", "Orc", "Night Elf"}
	#else
		new racename[9][] = {"No race","Undead Scourge","Human Alliance","Orcish Horde","Night Elves of Kalimdor", "Lordaeron Blood Elves","Darkspear Trolls","Dwarves of Khaz Modan","Lich of the Frozen North"}
		new shortracename[9][] = {"No race","Undead", "Human", "Orc", "Night Elf", "Blood Elf", "Troll", "Dwarf", "Lich"}
		new race5skill[4][] = {"Crimson Armor","Mana Shield","Bloodlust","Shadowstrike"}
		new race6skill[4][] = {"Silent Run","Regeneration","Berserk","Healing Wand"}
		new race7skill[4][] = {"Grenade Sack","Mithril Armor","Extended Ammunition","Avatar"}
		new race8skill[4][] = {"Ice Shards","Terror","Frost Armor","Frost Nova"}
	#endif

	new itemname[9][] = {"Item: Ankh","Item: Boots","Item: Claws","Item: Cloak","Item: Mask","Item: Necklace","Item: Orb","Item: Periapt","Item: Tome"}
	new longItemName[9][] = {"Ankh of Reincarnation","Boots of Speed","Claws of Attack +6","Cloak of Shadows","Mask of Death","Necklace of Immunity","Orb of Frost","Periapt of Health","Tome of Experience"}

	new race1skill[4][] = {"Vampiric Aura","Unholy Aura","Levitation","Suicide Bomber"}
	new race2skill[4][] = {"Invisibility","Devotion Aura","Bash","Teleport"}
	new race3skill[4][] = {"Critical Strike","Critical Grenade","Equipment Reincarnation","Chain Lightning"}
	new race4skill[4][] = {"Evasion","Thorns Aura","Trueshot Aura","Entangle Roots"}

#endif
#if LANG_GER
	#if !EXPANDED_RACES
        	new racename[5][] = {"Keine Rasse","Untote Plage","Menschliche Allianz","Orkische Horde","Nachtelfen von Kalimdor"}
	        new shortracename[5][] = {"Keine Rasse","Untote","Menschen","Orks","Nachtelfen"}
	#else
		new racename[9][] = {"Keine Rasse","Untote Plage","Menschliche Allianz","Orkische Horde","Nachtelfen von Kalimdor","Lordaeron Blut Elfen","Darkspear Trolls","Dwarves of Khaz Modan","Lich of the Frozen North"}
		new shortracename[9][] = {"Keine Rasse","Untote","Menschen","Orks","Nachtelfen","Blutelfen", "Troll", "Dwarf", "Lich"}
	        new race5skill[4][] = {"Blutrote Ruestung","Mana Schild","Blutrausch","Schattenstoss"}
		new race6skill[4][] = {"Silent Run","Regeneration","Berserk","Healing Wand"}
		new race7skill[4][] = {"Grenade Sack","Mithril Armor","Extended Ammunition","Avatar"}
		new race8skill[4][] = {"Ice Shards","Terror","Frost Armor","Frost Nova"}
	#endif

        new itemname[9][] = {"Item: Ankh","Item: Stiefel","Item: Klauen","Item: Mantel","Item: Maske","Item: Halskette","Item: Frost","Item: Gesundheit","Item: Erfahrung"}
        new longItemName[9][] = {"Ankh der Reinkarnation","Stiefel der Geschwindigkeit","Klauen des Angriffs +6","Mantel des Schattens","Maske des Todes","Halskette der Immunitaet","Frostkugel","Gesundheitsstein","Buch der Erfahrung"}

	new race1skill[4][] = {"Vampir Aura","Unheilige Aura","Schweben","Selbstmord-Bomber"}
	new race2skill[4][] = {"Unsichtbarkeit","Hingabe Aura","Hieb","Teleportieren"}
	new race3skill[4][] = {"Kritische Treffer","Kritische Granaten","Ausruestungs Reinkarnation","Kettenblitz"}
	new race4skill[4][] = {"Ausweichen","Dornen Aura","Schadens Aura","Wucherwurzeln"}

#endif
#if LANG_FRE
	#if !EXPANDED_RACES
		new racename[5][] = {"Aucune Race","Le Fleau des Morts Vivants","L'Alliance Humaine","L'Horde des Orc","Elfes de la Nuit de Kalimdor"}
		new shortracename[5][] = {"Aucune Race","Mort Vivant","Humain","Orc","Elfes de la Nuit"}
	#else
		new racename[9][] = {"Aucune Race","Le Fleau des Morts Vivants","L'Alliance Humaine","L'Horde des Orc","Elfes de la Nuit de Kalimdor", "Elfes Sanguinaire de Lordaeron","Darkspear Trolls","Dwarves of Khaz Modan","Lich of the Frozen North"}
		new shortracename[9][] = {"Aucune Race","Mort Vivant","Humain","Orc","Elfes de la Nuit","Elfes Sanguinaire", "Troll", "Dwarf", "Lich"}
		new race5skill[4][] = {"Armure Enchanter","Mana de Protection","La soif de Sang","L'ombre de frappe"}
		new race6skill[4][] = {"Silent Run","Regeneration","Berserk","Healing Wand"}
		new race7skill[4][] = {"Grenade Sack","Mithril Armor","Extended Ammunition","Avatar"}
		new race8skill[4][] = {"Ice Shards","Terror","Frost Armor","Frost Nova"}
	#endif

	new itemname[9][] = {"Objet: Ankh","Objet: Boots","Objet: Claws","Objet: Cloak","Objet: Mask","Objet: Necklace","Objet: Orb","Objet: Periapt","Objet: Tome"}
	new longItemName[9][] = {"Ankh de Reincarnation","Bottes de Vitesse","Griffes d'Attaque +6","Manteau d'Ombres","Masque de Mort","Collier d'Immunite","Orbe de Glace","Amulette de Vie","Tome d'Experience"}

	new race1skill[4][] = {"Aura Vampirique","Aura Impie","Levitation","Kamikaze"}
	new race2skill[4][] = {"Invisibilite","Aura de Devotion ","Bash","Teleportation"}
	new race3skill[4][] = {"Coup Critique","Grenade Ultime","Reincarnation de l'Equipement","Chaine d'Eclairs"}
	new race4skill[4][] = {"Esquive","Aura d'Epines","Aura de Degats ","Racines Agripantes"}
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
	weaponxpmultiplier[CSW_FAMAS] = 1.0
        weaponxpmultiplier[CSW_GALI] = 1.0        
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
   if (warcraft3==false)
        return PLUGIN_CONTINUE

   new sArg[MAX_VAR_LENGTH], sAction[MAX_VAR_LENGTH] 
   new sName[MAX_NAME_LENGTH] 
   
   new id, iUserId 
      
   read_logargv(0,sArg,MAX_VAR_LENGTH) 
   read_logargv(2,sAction,MAX_VAR_LENGTH) 
   parse_loguser(sArg,sName,MAX_NAME_LENGTH,iUserId) 
   id = find_player("k",iUserId) 

   // Bomb planted 
   if (equal(sAction,"Planted_The_Bomb")) {  
	fExplodeTime = get_gametime() + get_cvar_float( "mp_c4timer" )

	new origin[3]
	new teamname[32]
	new players[MAX_PLAYERS]
	new numplayers
	new targetorigin[3]
	new targetid
	
	get_user_origin(id, origin)
	get_user_team(id, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
		
	new temp
	temp = 0
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
			
			playerxp[targetid]+=  temp
										
			#if OBJECTIVE_XP_PRINT				
				get_user_name(targetid,sName,MAX_NAME_LENGTH-1)	
				//set_hudmessage(0, 160, 97, -1.05, 0.85, 2, 6.0, 15.0, 0.2, 0.3,101);
				//show_hudmessage(targetid,"^n +%d XP for bomb plant support",temp );					
				#if LANG_ENG
					client_print(targetid,print_chat, "[WC3] %s recieved %d XP for supporting the bomb planting effort.",sName,temp)
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
      
	new origin[3]
	new teamname[32]
	new players[MAX_PLAYERS]
	new numplayers
	new targetorigin[3]
	new targetid
	
	get_user_origin(id, origin)
	get_user_team(id, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
	
	new temp
	temp = 0
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
        
        #if ATTEMPT_DEFUSE_BONUS        	
               if( (++bombDefuserIndex[id] == 1) && (get_user_team(id) == 2) ){  // Team 1 = Terror, Team 2 = CT
                          
                       	new temp
			temp = 0
			#if XPLOIT_PROTECT						
				if( antiExploit ){
					temp =  xpgiven[p_level[id]]
				}																
			#else
				temp =  xpgiven[p_level[id]]											
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
      
        #if ATTEMPT_DEFUSE_BONUS        	
               if( (++bombDefuserIndex[id] == 1) && (get_user_team(id) == 2) ){  // Team 1 = Terror, Team 2 = CT
                          
                       	new temp
			temp = 0
			#if XPLOIT_PROTECT						
				if( antiExploit ){
					temp =  xpgiven[p_level[id]]
				}																
			#else
				temp =  xpgiven[p_level[id]]											
			#endif
			
			playerxp[id]+=  temp
					
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
	
	#if KILL_BOMB_CARRIER
		bombCarrier = id
	#endif
      
      #if BOMB_EVENT_BONUS        	
                                   
                new temp
		temp = 0
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]											
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
      
      #if KILL_BOMB_CARRIER
		bombCarrier = 0
	#endif
      
      #if BOMB_EVENT_BONUS        	
                                   
                new temp
		temp = 0
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]											
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
      
      	#if KILL_BOMB_CARRIER
		bombCarrier = id
	#endif
      
      #if BOMB_EVENT_BONUS        	
                                   
                new temp
		temp = 0
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]											
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
      
      #if HOSTAGE_TOUCH_BONUS
		
		new temp
		temp = 0
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]										
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
	new origin[3]
	new teamname[32]
	new players[MAX_PLAYERS]
	new numplayers
	new targetorigin[3]
	new targetid		
	
	get_user_origin(id, origin)
	get_user_team(id, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
	new temp
	temp = 0
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
	
	#if HOSTAGE_KILL_XP
		new temp
		temp = 0
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
      vip_id = id
      
      #if VIP_SPAWN_BONUS
		
		new temp
		temp = 0
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp =  xpgiven[p_level[id]]
			}																
		#else
			temp =  xpgiven[p_level[id]]										
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
		get_user_name( vip_id,sNameVIP,MAX_NAME_LENGTH-1) 		
		
		if (warcraft3==false)
			return PLUGIN_CONTINUE
      
      #if VIP_KILL_BONUS
		
		new temp
		temp = 0
		#if XPLOIT_PROTECT						
			if( antiExploit ){
				temp = VIP_KILL_BONUS + xpgiven[p_level[id]]
			}																
		#else
			temp = VIP_KILL_BONUS + xpgiven[p_level[id]]										
		#endif
		
		playerxp[id]+=  temp
				
		#if OBJECTIVE_XP_PRINT		   						
			#if LANG_ENG
				client_print(id,print_chat, "[WC3] %s gained %d XP for assassinating %s the VIP.",sName,temp,sNameVIP) 
			#endif
			#if LANG_GER
				client_print(id,print_chat, "[WC3] %s bekam %d XP fuer das toeten von %s den VIP.",sName,temp,sNameVIP) 
			#endif
			#if LANG_FRE
				client_print(id,print_chat, "[WC3] %s a gagne %d XP pour avoir assassine le VIP %s.",sName,temp,sNameVIP) 
			#endif			
		#endif			
		
		displaylevel(id, 1)		
	
	#endif
   } 
	// VIP escaped 
	else if (equal(sAction,"Escaped_As_VIP")) { 		
		       	
	new origin[3]
	new teamname[32]
	new players[MAX_PLAYERS]
	new numplayers
	new targetorigin[3]
	new targetid
	
	get_user_origin(id, origin)
	get_user_team(id, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
			
	new temp
	temp = 0
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

public displaylevel(id,hide){
	#if !EXPANDED_RACES
	if (id==0 || !(p_skills[id][0]>0) || !(p_skills[id][0]<5) || !is_user_connected(id))
	#else
	if (id==0 || !(p_skills[id][0]>0) || !(p_skills[id][0]<9) || !is_user_connected(id))
	#endif
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
	
	new xpstring[256]
	// XP is displayed as "Reseted" for the reseted player. This hides the fact that XP hasn't even been touched. Yet.
	
        if (p_level[id]==0)
        	format(xpstring,255,"%s   XP: %d/%d  %s",racename[p_skills[id][0]],playerxp[id],xplevel[p_level[id]+1], playeritem[id]?itemname[playeritem[id]-1]:"")
        else if (p_level[id]<10)
               	format(xpstring,255,"%s Level %d   XP: %d/%d  %s",shortracename[p_skills[id][0]],p_level[id],playerxp[id],xplevel[p_level[id]+1], playeritem[id]?itemname[playeritem[id]-1]:"")
       	else	
       		format(xpstring,255,"%s Level %d   XP: %d  %s",shortracename[p_skills[id][0]],p_level[id],playerxp[id], playeritem[id]?itemname[playeritem[id]-1]:"")
	

	// Ferret note - review this later, centerid/hud bug
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

		format(message,255,"%s ",racename[p_skills[id][0]])
		if (p_level[id]){
			format(temp,127,"^nLevel %d ",p_level[id])
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
			#if EXPANDED_RACES
			else if (p_skills[id][0] == 5){
				copy(skillcurrentrace[skillcounter],63,race5skill[skillcounter])
			}
			else if (p_skills[id][0] == 6){
				copy(skillcurrentrace[skillcounter],63,race6skill[skillcounter])
			}
			else if (p_skills[id][0] == 7){
				copy(skillcurrentrace[skillcounter],63,race7skill[skillcounter])
			}
			else if (p_skills[id][0] == 8){
				copy(skillcurrentrace[skillcounter],63,race8skill[skillcounter])
			}			
			#endif
			++skillcounter
		}

		if (p_skills[id][1]){
			format(temp,127,"^n%s Level %d ",skillcurrentrace[0],p_skills[id][1])
			add(message,255,temp)
		}
		if (p_skills[id][2]){
			format(temp,127,"^n%s Level %d ",skillcurrentrace[1],p_skills[id][2])
			add(message,255,temp)
		}
		if (p_skills[id][3]){
			format(temp,127,"^n%s Level %d ",skillcurrentrace[2],p_skills[id][3])
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
		if(gWpnUsed[id] == CSW_KNIFE)
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,highestinvis-p_invisibility[2]+KNIFEINVISIBILITY)
		else
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,highestinvis)
	}
	else if (p_skills[id][0] == 2 && p_skills[id][1]){		// Invisibility
		if (gWpnUsed[id] == CSW_KNIFE){
			new invisibility = p_invisibility[p_skills[id][1]-1]-p_invisibility[2]+KNIFEINVISIBILITY
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,invisibility)
		}
		else
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,p_invisibility[p_skills[id][1]-1])
	}
	else if (playeritem[id]==CLOAK){			// Cloack of Shadows
		if(gWpnUsed[id] == CSW_KNIFE){
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
	
	speed_controller(id)

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

	#if ITEMS_DROPABLE
		wc3_dropitem(victim_id)
	#endif
	
	#if EXPANDED_RACES
	// This is to reset the tracking for dwarf ammo clip skill
	if(p_skills[victim_id][0] == 7 && p_skills[victim_id][3])
	{
		for(new wpncnt = 0; wpncnt<33; wpncnt++)
			bDwarfAmmo[victim_id][wpncnt] = false
	}
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
	if (p_skills[victim_id][0]==1 && p_skills[victim_id][4] && !ultimateused[victim_id] ){	// Suicide Bomber
	#else
	if (p_skills[victim_id][0]==1 && p_skills[victim_id][4] && !ultimateused[victim_id] && first_round == false){	// Suicide Bomber
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
	
	if((p_skills[victim_id][0] == 3 && p_skills[victim_id][3]) || playeritem[victim_id]==ANKH) // If you're an orc or have an Ankh of Reincarnation...
	{
		for (new i=0; i<32; ++i)
			savedweapons[victim_id][i]=0
			
		savednumber[victim_id]=0
		armorondeath[victim_id]=get_user_armor(victim_id)
		get_user_weapons(victim_id,savedweapons[victim_id],savednumber[victim_id])
		hasdefuse[victim_id] = (cs_get_user_defuse(victim_id) ? true : false)
	}
	
	gWpnUsed[victim_id] = 0

	if (killer_id && killer_id!=victim_id && victim_id){
		if (get_user_team(killer_id)==get_user_team(victim_id))
			playerxp[killer_id]-=xpgiven[p_level[killer_id]]
		else{
			if (!get_cvar_num("mp_weaponxpmodifier")){
				playerxp[killer_id]+=xpgiven[p_level[victim_id]]
				if( headshot ){
					playerxp[killer_id]+= HEADSHOT_BONUS
				}		
			}else{
				playerxp[killer_id]+=floatround(xpgiven[p_level[victim_id]]*weaponxpmultiplier[weapon])
				if( headshot ){
					playerxp[killer_id]+= HEADSHOT_BONUS
				}
			}
				
			if (gHostageSaverIndex[victim_id]){						
					new temp
					temp = 0
					#if XPLOIT_PROTECT						
						if( antiExploit ){
							temp = KILLRESCUEMANXP +  2 * xpgiven[p_level[victim_id]]
						}																
					#else
						temp = KILLRESCUEMANXP +  2 * xpgiven[p_level[victim_id]]											
					#endif
					
					playerxp[killer_id]+=  temp
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
			// Why is this commented out? Because it never occurs. Currently the
			// bomb defuser variable is NEVER set.
			/*
				if (victim_id==bombdefuser){						
					new temp
					temp = 0
					#if XPLOIT_PROTECT						
						if( antiExploit ){
							temp = DEFUSER_KILL_BONUS +  xpgiven[p_level[victim_id]]
						}																
					#else
						temp = DEFUSER_KILL_BONUS +  xpgiven[p_level[victim_id]]											
					#endif
					
					playerxp[killer_id]+=  temp
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
			*/
			#endif	
			#if KILL_BOMB_CARRIER				 
				 if (victim_id==bombCarrier){						
					new temp
					temp = 0
					#if XPLOIT_PROTECT						
						if( antiExploit ){
							temp = KILL_BOMB_CARRIER +  xpgiven[p_level[victim_id]]
						}																
					#else
						temp = KILL_BOMB_CARRIER +  xpgiven[p_level[victim_id]]											
					#endif
					
					playerxp[killer_id]+=  temp
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

	new players[MAX_PLAYERS]
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

public player_spawn(id)
{ 
	if(warcraft3==false || !is_user_connected(id) || !is_user_alive(id))
		return PLUGIN_CONTINUE
		
	new iParm[2]
	iParm[0] = id
	iParm[1] = 0
	
	issearching[id]=false // if player is searching when the round ends, this resets that value to 0

	if(gNewSpawn && gRoundOver)
	{
		gNewSpawn = false
		bFreezeTime = true
		#if ITEMS_DROPABLE
		new stray_items = 0
		do
		{
			stray_items = find_ent_by_class(stray_items,"wc3item")
			if(stray_items > 0)
				remove_entity(stray_items)
		}
		while(stray_items)
		#endif	
	}
	
	if(!gRoundOver)
		speed_reset(iParm)
	
	#if ITEMS_DROPABLE
	canpickup[id] = true
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
			#if EXPANDED_RACES
			}else if( p_skills[id][0] == 5 ){
				icon_controller(id, 1, 255, 0, 0 ) 			
			}else if( p_skills[id][0] == 6 ){
				icon_controller(id, 1, 0, 255, 100 ) 			
			}else if( p_skills[id][0] == 7 ){
				icon_controller(id, 1, 255, 255, 0 ) 			
			}else if( p_skills[id][0] == 8 ){
				icon_controller(id, 1, 55, 55, 255 ) 			
			#endif
			}else{
				icon_controller(id, 1, 0, 255, 0 ) 
			}
		#endif			
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
	
	#if ORCNADE_CVAR
	if(get_cvar_num("mp_alloworcnade") == 0)
	{
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
	}
	#endif
	#if ORC_SPAM_FIX
		thrownorcnade[id] = false
	#endif
	
	if (p_skills[id][0] == 0)
		select_race(id)

	changingrace[id]=false
	
	if(diedlastround[id])
	{
		if((p_skills[id][0] == 3 && p_skills[id][3] && savednumber[id]) || playeritem[id]==ANKH)
			set_task(0.1, "reincarnation_controller", 10091, iParm, 2)
			
		playerItemOld[id] = playeritem[id]
		playeritem[id]=0
	}
	diedlastround[id] = false
	
	if(p_skills[id][0] == 4 && p_skills[id][1])
	{		
		// Allows Night Elves a chance to evade the first bullet to hit them.		
		new Float:randomnumber = random_float(0.0,1.0)
		if(randomnumber <= p_evasion[p_skills[id][1]-1])
			p_evadenextshot[id]=true		
		else
			p_evadenextshot[id]=false		
	
		if(p_evadenextshot[id])
			set_user_health(id,100+ELF_EVADE_ADJ)
	}
	
	// VIP armor check after reincarnation..
	if(get_user_armor(id)>100 && id != vip_id)
		set_user_armor(id, 100)
	
	if (p_skills[id][0] == 2 && p_skills[id][2])		// Devotion Aura
		set_user_health(id,p_devotion[p_skills[id][2]-1])
	#if EXPANDED_RACES 
	else if(p_skills[id][0] == 5 && p_skills[id][1])
	{
		if(get_user_armor(id) > 100)     // makes sure that ankh of reincarnation
			set_user_armor(id, 0)    // doesn't cause them to have some weird armor value
		set_task(0.5,"bloodelf_givearmor",3500+id,iParm,2)
	}
	
	// Remove tasks for shadowstrike (blood elf ult) if a new round starts
	remove_task(8000+id)
	remove_task(89+id)
	
	// Troll Regen
	remove_task(7700+id)
	if(p_skills[id][0] == 6 && p_skills[id][2])
		set_task(p_regenrate,"troll_regen",7700+id,iParm,2,"b")
		
	// Troll Healing Wand
	remove_task(6600+id)
	
	// Troll Silent Walk
	remove_task(5500+id)
	set_user_footsteps(id,0)
	if(p_skills[id][0] == 6 && p_skills[id][1])
	{
		if(p_skills[id][1] != 3)
			set_task(2.0,"troll_silence",5500+id,iParm,2,"b")
		else
			set_user_footsteps(id,1)		
	}
	
	// Make sure dwarf avatar is gone.
	bDwarfAvatar[id] = false
	remove_task(4400+id)
	
	// Dwarf Grenades must be reset
	if(p_skills[id][0] == 7 && p_skills[id][1])
	{
		iDwarfGrenades[id][0] = 1
		iDwarfGrenades[id][1] = 1
		iDwarfGrenades[id][2] = 1
		iParm[1] = 0
		set_task(get_cvar_float("mp_freezetime")+0.5,"dwarf_givegrenade",999,iParm,2)
	}
	#endif

	if(playeritem[id]==HEALTH)
		set_user_health(id,get_user_health(id)+HEALTHBONUS)
		
	#if OPT_RESETSKILLS
       	if(resetskill[id])
       	{
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
	if(playerxp[id] < xplevel[STARTINGLEVEL])
	{
		playerxp[id] = xplevel[STARTINGLEVEL]
		displaylevel(id, 1)
	}
	#endif
	
	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	
	if (skillsused < p_level[id])
		select_skill(id,0)
	else
		displaylevel(id,1)

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

// These used to be part of new_round(), which has been renamed to
// player_spawn(). These only need to be done once per round, not
// once every time a player is spawned or has a hud refresh.
public start_round()
{
	bFreezeTime = false
	gRoundOver = false

	#if KILL_BOMB_CARRIER
	bombCarrier = 0
	#endif
	
	new iNumPlayers
	new iPlayers[MAX_PLAYERS]
	get_players(iPlayers, iNumPlayers)

	#if XPLOIT_PROTECT
	antiExploit = true
	if(iNumPlayers < XPLOIT_PROTECT)
		antiExploit = false
	#endif
	
	new iParm[2]
	iParm[1] = 0
	
	for(new i = 0; i < iNumPlayers; i++)
	{
		iParm[0] = iPlayers[i]
		speed_reset(iParm)
	}

	return PLUGIN_CONTINUE
}

public end_round()
{
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new players[MAX_PLAYERS]
	new numberofplayers
	get_players(players, numberofplayers)	
	new parameter[1]

	for(new i = 0; i < numberofplayers; ++i)
	{
		parameter[0] = players[i]
		set_task(1.0,"getuserinput",5,parameter,1)
	}
	
	gNewSpawn = true
	gRoundOver = true
	
	#if !ULTIMATE_FIRST_ROUND
	first_round = false
	#endif

	#if !SHORT_TERM && ROUNDEND_SAVEALL
	if (saved_xp)
		write_all()
	#endif
		
	return PLUGIN_CONTINUE
}

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

		#if EXPANDED_RACES
		else if (p_skills[id][0] == 5){ // BLOOD ELF
			copy(skillcurrentrace[skillcounter],63,race5skill[skillcounter])
		}
		else if (p_skills[id][0] == 6){ // TROLL
			copy(skillcurrentrace[skillcounter],63,race6skill[skillcounter])
		}
		else if (p_skills[id][0] == 7){ // DWARF
			copy(skillcurrentrace[skillcounter],63,race7skill[skillcounter])
		}
		else if (p_skills[id][0] == 8){ // LICH
			copy(skillcurrentrace[skillcounter],63,race8skill[skillcounter])
		}
		#endif
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
			else if(  p_skills[id][0]==2 && p_level[id] < HUMAN_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			else if(  p_skills[id][0]==3 && p_level[id] < ORC_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			else if(  p_skills[id][0]==4 && p_level[id] < ELF_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			#if EXPANDED_RACES
			else if(  p_skills[id][0]==5 && p_level[id] < BLOOD_ELF_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			else if(  p_skills[id][0]==6 && p_level[id] < TROLL_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			else if(  p_skills[id][0]==7 && p_level[id] < DWARF_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			else if(  p_skills[id][0]==8 && p_level[id] < LICH_ULT){
				format(temp,127,"\d")
				add(message,255,temp)
			}
			#endif
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
			
			if( p_level[id]>= HUMAN_ULT) 
				keys |= (1<<3)
			
			if( p_level[id]>= ORC_ULT) 
				keys |= (1<<3)
			
			if( p_level[id]>= ELF_ULT) 
				keys |= (1<<3)
							
			#if EXPANDED_RACES
			if( p_level[id]>= BLOOD_ELF_ULT)
				keys |= (1<<3)
			
			if( p_level[id]>= TROLL_ULT)
				keys |= (1<<3)
				
			if( p_level[id]>= DWARF_ULT)
				keys |= (1<<3)
				
			if( p_level[id]>= LICH_ULT)
				keys |= (1<<3)
			#endif
			
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
						
			#if EXPANDED_RACES
			if(  p_skills[id][0]==5 && p_level[id]>= BLOOD_ELF_ULT) p_skills[id][4]=1
			if(  p_skills[id][0]==6 && p_level[id]>= TROLL_ULT) p_skills[id][4]=1
			if(  p_skills[id][0]==7 && p_level[id]>= DWARF_ULT) p_skills[id][4]=1
			if(  p_skills[id][0]==8 && p_level[id]>= LICH_ULT) p_skills[id][4]=1
			#endif			
			
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
		
        if (get_cvar_num("mp_changeracepastfreezetime")==0){
		if (is_user_alive(id) && !bFreezeTime){
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
	}

	if (get_cvar_num("mp_allowchangerace")==1 || p_skills[id][0]==0){
		#if !SHORT_TERM
			if (saved_xp){
				if (!changingrace[id]){
					write_xp_to_file(id, "")
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
		#if !EXPANDED_RACES
		p_skills[id][0] = random_num(1,4)
		#else
		p_skills[id][0] = random_num(1,8)
		#endif
		return PLUGIN_HANDLED
	}

	new menu_msg[256]
	
	#if !EXPANDED_RACES
	#if LANG_ENG
		format(menu_msg,255,"\ySelect Race:\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n^n\ 
								5. Auto-select", racename[1],\ 
								racename[2], racename[3], racename[4]) 
	#endif
	#if LANG_GER
		format(menu_msg,255,"\yWaehle eine Rasse::\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n^n\ 
								5. Auto-Auswahl", racename[1],\ 
								racename[2], racename[3], racename[4]) 
	#endif
	#if LANG_FRE
		format(menu_msg,255,"\yChoisi ta Race:\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n^n\ 
								5. Selection Automatique", racename[1],\ 
								racename[2], racename[3], racename[4]) 
	#endif	
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),menu_msg,-1)
	#else
	#if LANG_ENG
		format(menu_msg,255,"\ySelect Race:\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n5. %s^n6. %s^n7. %s^n8. %s^n^n\ 
								9. Auto-select", racename[1],\ 
								racename[2], racename[3], racename[4], racename[5],racename[6],racename[7],racename[8]) 
	#endif
	#if LANG_GER
		format(menu_msg,255,"\yWaehle eine Rasse::\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n5. %s^n6. %s^n7. %s^n8. %s^n^n\ 
								9. Auto-Auswahl", racename[1],\ 
								racename[2], racename[3], racename[4], racename[5],racename[6],racename[7],racename[8]) 
	#endif
	#if LANG_FRE
		format(menu_msg,255,"\yChoisi ta Race:\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n5. %s^n6. %s^n7. %s^n8. %s^n^n\ 
								9. Selection Automatique", racename[1],\ 
								racename[2], racename[3], racename[4], racename[5],racename[6],racename[7],racename[8]) 
	#endif	
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8),menu_msg,-1)
	#endif

	return PLUGIN_CONTINUE
}

public set_race(id,key)
{

        if (get_cvar_num("mp_changeracepastfreezetime")==0)
	{
		if (is_user_alive(id) && !bFreezeTime)
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
	}

	new oldrace = p_skills[id][0]

	if (key == 0)
		p_skills[id][0] = 1
	else if (key == 1)
		p_skills[id][0] = 2
	else if (key == 2)
		p_skills[id][0] = 3
	else if (key == 3)
		p_skills[id][0] = 4
	#if !EXPANDED_RACES
	else if (key == 4)               // changed what this key does
		p_skills[id][0] = random_num(1,4) // changed range of random nums
	#else
	else if (key == 4)
		p_skills[id][0] = 5  
	else if (key == 5)
		p_skills[id][0] = 6
	else if (key == 6)
		p_skills[id][0] = 7 
	else if (key == 7)
		p_skills[id][0] = 8 
	else if (key == 8)
		p_skills[id][0] = random_num(1,8)
	#endif

	if (p_skills[id][0] == oldrace)
		return PLUGIN_CONTINUE

	p_skills[id][1] = 0
	p_skills[id][2] = 0
	p_skills[id][3] = 0
	p_skills[id][4] = 0

	if(get_user_health(id)>100)
		set_user_health(id,100)

	#if !EXPANDED_RACES
	if(get_user_armor(id) > 100 && id != vip_id)
	#else
	if((get_user_armor(id) > 100 && id != vip_id) || oldrace==5)
	#endif
			set_user_armor(id, 100)

	#if !SHORT_TERM
		if (saved_xp){
			playerxp[id] = 0
			p_level[id] = 0
			get_xp_from_file(id,0)
		}
	#endif
			
	#if EXPANDED_RACES
	new iParm[2]; iParm[0] = id; iParm[1] = 0;
	// Troll Regen
	remove_task(7700+id)
	if(p_skills[id][0] == 6 && p_skills[id][2])
		set_task(p_regenrate,"troll_regen",7700+id,iParm,2,"b")
	
	// Troll Silent Walk
	remove_task(5500+id)
	set_user_footsteps(id,0)
	if(p_skills[id][0] == 6 && p_skills[id][1])
	{
		if(p_skills[id][1] != 3)
			set_task(2.0,"troll_silence",5500+id,iParm,2,"b")
		else
			set_user_footsteps(id,1)		
	}
		
	// Dwarf Grenades must be reset
	if(p_skills[id][0] == 7 && p_skills[id][1] && is_user_alive(id))
	{
		iDwarfGrenades[id][0] = 1
		iDwarfGrenades[id][1] = 1
		iDwarfGrenades[id][2] = 1
		new dwarfparm[2]
		dwarfparm[0] = id
		dwarfparm[1] = 0
		set_task(0.5,"dwarf_givegrenade",999,dwarfparm,2)
	}
	#endif

	if (get_user_team(id)==0)
	{
		engclient_cmd(id, "chooseteam")
		return PLUGIN_CONTINUE
	}
	else
	{
		new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]
		if (skillsused < p_level[id])
			select_skill(id,0)
	}

	// makes sure devotion and crimson armor get applied immediately
	if(p_skills[id][0] == 2 && p_skills[id][2] && get_user_health(id) <= 100)
		set_user_health(id,p_devotion[p_skills[id][2]-1])
	#if EXPANDED_RACES
	else if(p_skills[id][0] == 5 && p_skills[id][1])
	{
		if(get_user_armor(id) > 100)
			set_user_armor(id, 0)
		new parm[2]; parm[0] = id
		set_task(0.5,"bloodelf_givearmor",3500+id,parm,2)
	}
	#endif

	return PLUGIN_CONTINUE
}

#if !NEW_DAMAGEEVENT
public damage_event(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new weapon, bodypart, enemy = get_user_attacker(id,weapon,bodypart)
	new damage = read_data(2)
	new bool:p_evadecurrentshot
	new victimisdead=0
	new enemyisdead=0
	new victimkilled=0
	new enemykilled=0

	if (is_user_alive(id)==0)
		victimisdead=1

	if (is_user_alive(enemy)==0)
		enemyisdead=1
	
	#if EXPANDED_RACES
	// Dwarf Avatar
	// ------------
	// If the victim is currently using the Avatar ultimate, and the enemy
	// doesn't have the Necklace of Immunity, give back the health and exit
	// out. There's no need to go further in this function, in this case.
	//
	if(p_skills[id][0] == 7 && p_skills[id][4] && bDwarfAvatar[id] && playeritem[enemy] != IMMUNITY && !enemyisdead)
	{
		damage = read_data(2)
		set_user_health(id,get_user_health(id)+damage)
		return PLUGIN_CONTINUE
	}
	#endif

	// ferret note - we may need to revisit this to check concerning reincarnation bug fixed in the death event
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

	// This is an interesting idea.. - ferret
	if (is_user_bot(enemy) && p_skills[enemy][4]==1){
		if (p_skills[enemy][0]==3 || p_skills[enemy][0]==4){
			ultimate(enemy)
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
	
	// Expanded race code, Handles the Blood Elf "Mana Shield" skill, Dwarf "Mithril Armor",
	// and the Lich "Ice Shards" skill.
	#if EXPANDED_RACES	
	else if (p_skills[id][0] == 5){
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
	else if(p_skills[id][0] == 7)
	{
		if(p_skills[id][2]) // Dwarf Mithril Armor
		{
			if(get_user_health(id) > 0)
			{
				damage = read_data(2)
				
				if(damage >= p_mitharmor[p_skills[id][2]-1]+5)
					set_user_health(id,get_user_health(id)+p_mitharmor[p_skills[id][2]-1])
			
			}
		}
	}
	else if(p_skills[id][0] == 8)
	{
		if(p_skills[id][1]) // Lich Ice Shards
		{
			new Float:randomnumber = random_float(0.0,1.0)
			if (randomnumber <= p_iceshards[p_skills[id][1]-1])
			{
				damage = read_data(2)
			
				if (get_user_health(enemy) - damage <= 0 || (get_user_health(enemy) - damage <= ELF_EVADE_ADJ && get_user_health(enemy) > 500))
				{
					enemykilled = 1
					set_user_health(enemy, -1)
				}
				else
				{
					enemykilled = 0
					set_user_health(enemy, get_user_health(enemy) - damage)
					
				}
				
	
				if (iglow[enemy][0] < 1 || iglow[enemy][2] < 1){
					new parm[2]
					parm[0] = enemy
					set_task(0.1,"glow_change",8,parm,2)
				}
				
				iglow[enemy][0] += 3*damage
				iglow[enemy][1] = 0
				iglow[enemy][2] += 3*damage
				iglow[enemy][3] = 0
				if (iglow[enemy][0]>MAXGLOW)
					iglow[enemy][0]=MAXGLOW
					
				message_begin(MSG_ONE,gmsgFade,{0,0,0},enemy)
				write_short( 1<<10 ) // fade lasts this long duration
				write_short( 1<<10 ) // fade lasts this long hold time
				write_short( 1<<12 ) // fade type (in / out)
				write_byte( 255 ) // fade red
				write_byte( 0 ) // fade green
				write_byte( 255 ) // fade blue
				write_byte( iglow[enemy][0] ) // fade alpha
				message_end()
				
			}
		}
	}
	#endif

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
			if (randomnumber <= p_bash[p_skills[enemy][3]-1] && !stunned[id]){		// Cannot bash if already bashed or frosted
				stunned[id]=true
				new parm[2]
				parm[0]=id			// Replace "id" with "enemy" to test bash on self
				parm[1]=1
				set_task(1.0,"speed_reset",500+id,parm,2)
				speed_controller(id)

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
				
				if (get_user_health(id) - damage<=0)
					victimkilled = 1
				
				if (get_user_health(id) - damage<=ELF_EVADE_ADJ && get_user_health(id)>500)
					victimkilled = 1
				
				if (victimkilled){
					set_user_health(id, -1)
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
			
			if (get_user_health(id) - damage<=0)
				victimkilled = 1
			
			if (get_user_health(id) - damage<=ELF_EVADE_ADJ && get_user_health(id)>500)
				victimkilled = 1
			
			if (victimkilled){
				set_user_health(id, -1)
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
			
			if (get_user_health(id) - damage<=0)
				victimkilled = 1
			
			if (get_user_health(id) - damage<=ELF_EVADE_ADJ && get_user_health(id)>500)
				victimkilled = 1
			
			if (victimkilled){
				set_user_health(id, -1)
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

	// Expanded race code, Handles the Blood Elf "Bloodlust" skill, Troll "Berserk" skill, Lich "Terror" and
	// "Frost Armor" skills.
	#if EXPANDED_RACES
	else if (p_skills[enemy][0] == 5)
	{
		if (p_skills[enemy][3])
		{
			// slowdown code
			
			iBloodLust[id] = p_skills[enemy][3]
			new slowed_parm[2]
			slowed_parm[0] = id
			slowed_parm[1] = 3
			set_task(2.0,"speed_reset",8800+id,slowed_parm,2)
			speed_controller(id)
			// end slowdown code
			
			if(playeritem[enemy] != CLAWS)
			{
				if (get_user_health(id) - p_bloodlust[p_skills[enemy][3]-1] <= 0 || (get_user_health(id) - p_bloodlust[p_skills[enemy][3]-1] <= ELF_EVADE_ADJ && get_user_health(id) > 500))
				{
					victimkilled = 1
					set_user_health(id, -1)
				}
				else
					set_user_health(id, get_user_health(id) - p_bloodlust[p_skills[enemy][3]-1])
			}
		}
	}
	else if (p_skills[enemy][0] == 6) 
	{
		if(p_skills[enemy][3]) // Troll Berserk
		{
			if(get_user_health(enemy) < p_berserk[p_skills[enemy][3]-1])
			{
					
				if(get_user_health(id) - p_berserkdamage <= 0 || (get_user_health(id) - p_berserkdamage <= ELF_EVADE_ADJ && get_user_health(id) > 500))
				{
					victimkilled = 1
					set_user_health(id, -1)
				}
				else
					set_user_health(id, get_user_health(id) - p_berserkdamage)
					
				if (iglow[id][0] < 1 || iglow[id][1] < 1)
				{
					new parm[2]
					parm[0] = id
					set_task(0.1,"glow_change",14,parm,2)
				}
				
				iglow[id][0] += p_berserkdamage*2
				iglow[id][1] += p_berserkdamage
				iglow[id][2] = 0
				iglow[id][3] = 0
				if (iglow[id][0]>MAXGLOW)
					iglow[id][0]=MAXGLOW
				
				message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
				write_short( 1<<10 ) // fade lasts this long duration
				write_short( 1<<10 ) // fade lasts this long hold time
				write_short( 1<<12 ) // fade type (in / out)
				write_byte( 255 ) // fade red
				write_byte( 150 ) // fade green
				write_byte( 0 ) // fade blue
				write_byte( iglow[id][0] ) // fade alpha
				message_end()
			}
		}	
	}
	else if (p_skills[enemy][0] == 8) 
	{
		if(p_skills[enemy][2]) // Lich Terror
		{
			// Decide if Terror succeeded, then blind enemy for a few seconds
			new Float:randomnumber = random_float(0.0,1.0)
			if (randomnumber <= p_terror[p_skills[enemy][2]-1])
			{
				message_begin(MSG_ONE, gmsgFade,{0,0,0},id) // use the magic #1 for "one client"  
				write_short( 1<<13 ) // fade lasts this long duration  
				write_short( 1<<12 ) // fade lasts this long hold time  
				write_short( 1<<1 ) // fade type IN 
				write_byte( 50 ) // fade red  
				write_byte( 0 ) // fade green  
				write_byte( 0 ) // fade blue    
				write_byte( 220 ) // fade alpha    
				message_end() 
			}
		}
		if(p_skills[enemy][3]) // Lich Frost Armor
		{
		
			new Float:randomnumber = random_float(0.0,1.0)
			if (randomnumber <= p_frostarmor[p_skills[enemy][3]-1])
			{
				if(get_user_armor(enemy) <= p_frostarmormax[p_skills[enemy][3]-1]) 
				{ 
					damage = read_data(2)			
					damage += get_user_armor(enemy)
					if(damage > p_frostarmormax[p_skills[enemy][3]-1]) { damage = p_frostarmormax[p_skills[enemy][3]-1]; }
					set_user_armor(enemy,damage)
			
					if (iglow[enemy][1] < 1 || iglow[enemy][2] < 1)
					{
						new parm[2]
						parm[0] = enemy
						set_task(0.1,"glow_change",9,parm,2)
					}
		
					iglow[enemy][0] = 0
					iglow[enemy][1] += damage
					iglow[enemy][2] += floatround(float(damage)*0.40)
					iglow[enemy][3] = 0
					if (iglow[enemy][1]>MAXGLOW)
						iglow[enemy][1]=MAXGLOW
			
					message_begin(MSG_ONE,gmsgFade,{0,0,0},enemy)
					write_short( 1<<10 ) // fade lasts this long duration
					write_short( 1<<10 ) // fade lasts this long hold time
					write_short( 1<<12 ) // fade type (in / out)
					write_byte( 0 ) // fade red
					write_byte( 255 ) // fade green
					write_byte( 100 ) // fade blue
					write_byte( iglow[enemy][1] ) // fade alpha
					message_end()
				}
			}
		}	
	}	
	#endif

	if (playeritem[enemy] == CLAWS){	// Claws of Attack
		damage = CLAWSOFATTACK
		
		if (get_user_health(id) - damage<=0)
			victimkilled = 1
		
		if (get_user_health(id) - damage<=ELF_EVADE_ADJ && get_user_health(id)>500)
			victimkilled = 1
	
		if (victimkilled){
			set_user_health(id, -1)
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

                if (get_user_health(enemy) > (p_skills[enemy][0]==2 ? ( p_skills[enemy][2] ? p_devotion[p_skills[enemy][2]-1] : 100) : 100) ){
                        set_user_health(enemy, (p_skills[enemy][0]==2 ? ( p_skills[enemy][2] ? p_devotion[p_skills[enemy][2]-1] : 100) : 100) )
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
		if (!slowed[id]){		// Cannot frost if bashed or frosted
			slowed[id]=true
			
			new parm[2]
			parm[0]=id			// Replace "id" with "enemy" to test bash on self
			parm[1]=2
			set_task(1.0,"speed_reset",550+id,parm,2)
			speed_controller(id)

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

	#if EXPANDED_RACES
	// Dwarf Avatar
	// ------------
	// If the attacking enemy has Necklace of Immunity, we need to make sure the
	// Avatar-affected player is treated correctly. If their health is below 0 once
	// the adjustment is removed, the player is dead. We clean up the Avatar task and
	// variables. Otherwise adjust their stored health for when Avatar ends.
	//
	if(p_skills[id][0] == 7 && p_skills[id][4] && bDwarfAvatar[id] && playeritem[enemy] == IMMUNITY)
	{
		if(get_user_health(id) - DWARF_AVATAR_ADJ <= 0)
		{
			set_user_health(id,-1)
			victimkilled = 1
			bDwarfAvatar[id] = false
			iDwarfAvatarHP[id] = 0
			remove_task(4400+id)
		}
		else
			iDwarfAvatarHP[id] = get_user_health(id) - DWARF_AVATAR_ADJ
	}
	#endif


	if (enemykilled && !enemyisdead){	// due to thorns aura or ice shards
		if (get_user_team(id)!=get_user_team(enemy)){
			set_user_frags(id, get_user_frags(id)+1)
			set_user_frags(enemy, get_user_frags(enemy)+1)
			playerxp[id]+=xpgiven[p_level[enemy]]
			displaylevel(id, 1)
		}
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(id)
		write_byte(enemy)
		write_byte(0)
		
		#if EXPANDED_RACES
		if(p_skills[id][0] == 4)
		{
		#endif
			write_string(race4skill[1])
			message_end()
			logKill(id, enemy, race4skill[1])
		#if EXPANDED_RACES
		}
		else
		{
			write_string(race8skill[0])
			message_end()
			logKill(id, enemy, race8skill[0])
		}
		#endif
		
	}

	if (victimkilled && !victimisdead){		// due to all aggressive auras
		new headshot
		if (bodypart==1)
			headshot=1
		else
			headshot=0
		new weaponname[32]

		// MISSING STEAM WEAPONS!!! - ferret
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
		case 14:
			weaponname = "galil"
		case 15:
			weaponname = "famas"
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
				}else{
					playerxp[enemy]+=floatround(xpgiven[p_level[id]]*weaponxpmultiplier[weapon])
				}
			}
			else{
				set_user_frags(id, get_user_frags(id)+1)
				set_user_frags(enemy, get_user_frags(enemy)-1)
				playerxp[enemy]-=xpgiven[p_level[enemy]]
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
#else
public damage_event(id)
{
	if (warcraft3==false)
		return PLUGIN_CONTINUE
		
	new weapon, bodypart, enemy = get_user_attacker(id,weapon,bodypart)
	new damage = read_data(2)
	new iParm[2]
	iParm[0] = id
	iParm[1] = 0

	#if EXPANDED_RACES
	// Dwarf Avatar
	// ------------
	// If the victim is currently using the Avatar ultimate, and the enemy
	// doesn't have the Necklace of Immunity, give back the health and exit
	// out. There's no need to go further in this function, in this case.
	//
	if(p_skills[id][0] == 7 && p_skills[id][4] && bDwarfAvatar[id] && playeritem[enemy] != IMMUNITY)
	{
		set_user_health(id,get_user_health(id)+damage)
		return PLUGIN_CONTINUE
	}
	#endif

	new bool:p_evadecurrentshot = false

	new bool:bVictimDead = false
	new bool:bEnemyDead = false
	
	new iVictimHealth = get_user_health(id)
	new iEnemyHealth = get_user_health(enemy)

	if (!is_user_alive(id))
		bVictimDead=true
	if (!is_user_alive(enemy))
		bEnemyDead=true
	
	if(!enemy && get_gametime() - fExplodeTime < 1.0 && get_user_health(id)<1) 
	{
	        diedlastround[id]=true
	        if(playeritem[id] == ANKH || (p_skills[id][0] == 3 && p_skills[id][3]))
	        {
        		armorondeath[id]=get_user_armor(id)
        		for(new n=0; n<32; ++n)
        			savedweapons[id][n]=0
	        	savednumber[id]=0
	        	get_user_weapons(id,savedweapons[id],savednumber[id])
	        }
	}

	if(enemy==id && weapon==0) return PLUGIN_CONTINUE
	else if(enemy==0) return PLUGIN_CONTINUE 

	if (is_user_bot(enemy) && p_skills[enemy][4]==1){
		if (p_skills[enemy][0]==3 || p_skills[enemy][0]==4){
			ultimate(enemy)
		}
	}
	
	// Victim Skill Block
	// ------------------
	// This block of code is for the skills activated when
	// the victim ihas damage event skills. These include the Night
	// Elf skills Evasion and Thorns, If Expanded Races is enabled,
	// it also includes the Blood Elf skill Mana Shield, the Dwarf
	// skill Mithril Armor, and the Lich skill Ice Shards.
	//
	// The victim cannot die in this block, if still alive. The
	// enemy can though.
	//
	if(p_skills[id][0] == 4)
	{
		if(p_skills[id][1] && !bVictimDead)
		{
			p_evadecurrentshot = p_evadenextshot[id]
			new Float:randomnumber = random_float(0.0,1.0)
			if (randomnumber <= p_evasion[p_skills[id][1]-1]){
				p_evadenextshot[id] = true
				
				if (iVictimHealth <= 100 + HEALTHBONUS)
					iVictimHealth += ELF_EVADE_ADJ
			}
			else{
				p_evadenextshot[id] = false
				
				if (iVictimHealth > 100 + HEALTHBONUS)
					iVictimHealth += -ELF_EVADE_ADJ
			}
			
			if (p_evadecurrentshot)
			{
				iVictimHealth += damage
				set_user_health(id,iVictimHealth)
				
				iglow[id][2] += damage
								
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
		}
		if (p_skills[id][2] && !bEnemyDead)
		{
		
			if(iVictimHealth < 0)
				iEnemyHealth -= floatround(float(damage + iVictimHealth) * p_thorns[p_skills[id][2]-1])
			else
				iEnemyHealth -= floatround(float(damage) * p_thorns[p_skills[id][2]-1])
				
			iglow[enemy][0] += 3*damage

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
	#if EXPANDED_RACES
	else if(p_skills[id][0] == 5)
	{
		if(p_skills[id][2] && !bVictimDead)
			iVictimHealth += floatround(float(damage) * p_manashield[p_skills[id][2]-1])
	}
	else if(p_skills[id][0] == 7)
	{
		if(p_skills[id][2] && !bVictimDead)
		{
			if(damage >= p_mitharmor[p_skills[id][2]-1]+5)
				iVictimHealth += p_mitharmor[p_skills[id][2]-1]
		}
	}
	else if(p_skills[id][0] == 8)
	{
		if(p_skills[id][1] && !bEnemyDead)
		{
			new Float:randomnumber = random_float(0.0,1.0)
			if (randomnumber <= p_iceshards[p_skills[id][1]-1])
			{
				iEnemyHealth -= damage
			
				iglow[enemy][0] += 3*damage
				iglow[enemy][2] += 3*damage
					
				message_begin(MSG_ONE,gmsgFade,{0,0,0},enemy)
				write_short( 1<<10 ) // fade lasts this long duration
				write_short( 1<<10 ) // fade lasts this long hold time
				write_short( 1<<12 ) // fade type (in / out)
				write_byte( 255 ) // fade red
				write_byte( 0 ) // fade green
				write_byte( 255 ) // fade blue
				write_byte( iglow[enemy][0] ) // fade alpha
				message_end()
			}				
		}
	}
	#endif 

	// Enemy Skill Block
	// -----------------
	// This block of code is for the skills activated when
	// the enemy has a skill based on damage event. These
	// include the Undead skill Vampiric Aura, the Human skill
	// Bash, the Orc skills Critical Strike and Critical Grenade,
	// the Night Elf skill True Shot Aura. If Expanded Races is
	// enabled, it also includes the Blood Elf skill Bloodlust,
	// the Troll skill Berserk, and the Lich skills Terror and
	// Frost Armor
	//
	// The enemy cannot die in this block, if still alive. The
	// victim can though.
	//
	if(p_skills[enemy][0] == 1)
	{
		if(p_skills[enemy][1] && !bEnemyDead)
		{
			if(iVictimHealth < 0)
				iEnemyHealth += floatround(float(damage + iVictimHealth) * p_vampiric[p_skills[enemy][1]-1])
			else
				iEnemyHealth += floatround(float(damage) * p_vampiric[p_skills[enemy][1]-1])			
			
			if(iEnemyHealth > p_vampirichealth[p_skills[enemy][1]-1] + (playeritem[enemy] == HEALTH ? HEALTHBONUS : 0))
				iEnemyHealth = p_vampirichealth[p_skills[enemy][1]-1] + (playeritem[enemy] == HEALTH ? HEALTHBONUS : 0)
	
			iglow[enemy][1] += damage
	
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
	else if(!bVictimDead)
	{
		if(p_skills[enemy][0] == 2)
		{
			if(p_skills[enemy][3])
			{
				new Float:randomnumber = random_float(0.0,1.0)
				if (randomnumber <= p_bash[p_skills[enemy][3]-1] && !stunned[id])
				{
				
					stunned[id] = true
					iParm[1] = 1
					set_task(1.0,"speed_reset",500+id,iParm,2)
		
					iglow[id][3] += 100
		
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
		else if(p_skills[enemy][0] == 3)
		{
			if (p_skills[enemy][1]) 
			{
				new Float:randomnumber = random_float(0.0,1.0)
				if (randomnumber <= p_critical[p_skills[enemy][1]-1])
				{
					iVictimHealth -= floatround(float(damage) * p_skills[enemy][1])
	
					iglow[id][0] += damage
	
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
			
			// Orc Nade Code
			new bool:bPermitOrcNade = true
			
			#if ORCNADE_CVAR
			if(!get_cvar_num("mp_alloworcnade"))
				bPermitOrcNade = false
			#endif
			#if ORCNECKLACE
			if(playeritem[id] == IMMUNITY)
				bPermitOrcNade = false
			#endif
			
			if(p_skills[enemy][2] && weapon == 4 && bPermitOrcNade)
			{
			
				iVictimHealth -= floatround(float(damage) * p_grenade[p_skills[enemy][2]-1])
		
				iglow[id][0] += damage

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
		else if(p_skills[enemy][0] == 4)
		{
			if(p_skills[enemy][3])
			{
				iVictimHealth -= floatround(float(damage) * p_trueshot[p_skills[enemy][3]-1])
			
				iglow[id][0] += 2*damage
		
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
	#if EXPANDED_RACES
		else if(p_skills[enemy][0] == 5)
		{
			if(p_skills[enemy][3])
			{
				iBloodLust[id] = p_skills[enemy][3]
				iParm[1] = 3
				set_task(2.0,"speed_reset",8800+id,iParm,2)
			
				if(playeritem[enemy] != CLAWS)
					iVictimHealth -= p_bloodlust[p_skills[enemy][3]-1]
			}
		}
		else if(p_skills[enemy][0] == 6)
		{
			if(p_skills[enemy][3])
			{
				if(iEnemyHealth < p_berserk[p_skills[enemy][3]-1])
				{
					iVictimHealth -= p_berserkdamage
						
					iglow[id][0] += p_berserkdamage*2
					iglow[id][1] += p_berserkdamage
					
					message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
					write_short( 1<<10 ) // fade lasts this long duration
					write_short( 1<<10 ) // fade lasts this long hold time
					write_short( 1<<12 ) // fade type (in / out)
					write_byte( 255 ) // fade red
					write_byte( 150 ) // fade green
					write_byte( 0 ) // fade blue
					write_byte( iglow[id][0] ) // fade alpha
					message_end()
				}
			}
		}
		else if(p_skills[enemy][0] == 8)
		{
			if(p_skills[enemy][2])
			{
				new Float:randomnumber = random_float(0.0,1.0)
				if (randomnumber <= p_terror[p_skills[enemy][2]-1])
				{
					message_begin(MSG_ONE, gmsgFade,{0,0,0},id) // use the magic #1 for "one client"  
					write_short( 1<<13 ) // fade lasts this long duration  
					write_short( 1<<12 ) // fade lasts this long hold time  
					write_short( 1<<1 ) // fade type IN 
					write_byte( 50 ) // fade red  
					write_byte( 0 ) // fade green  
					write_byte( 0 ) // fade blue    
					write_byte( 220 ) // fade alpha    
					message_end() 
				}
			}
			if(p_skills[enemy][3])
			{
				new Float:randomnumber = random_float(0.0,1.0)
				if (randomnumber <= p_frostarmor[p_skills[enemy][3]-1])
				{
					if(get_user_armor(enemy) <= p_frostarmormax[p_skills[enemy][3]-1]) 
					{ 
						new armor
						
						if(iVictimHealth < 0)
							armor = get_user_armor(enemy) + damage + iVictimHealth
						else
							armor = get_user_armor(enemy) + damage
	
						if(armor > p_frostarmormax[p_skills[enemy][3]-1]) { armor = p_frostarmormax[p_skills[enemy][3]-1]; }
						set_user_armor(enemy,armor)
				
						iglow[enemy][1] += damage
						iglow[enemy][2] += floatround(float(damage)*0.40)
				
						message_begin(MSG_ONE,gmsgFade,{0,0,0},enemy)
						write_short( 1<<10 ) // fade lasts this long duration
						write_short( 1<<10 ) // fade lasts this long hold time
						write_short( 1<<12 ) // fade type (in / out)
						write_byte( 0 ) // fade red
						write_byte( 255 ) // fade green
						write_byte( 100 ) // fade blue
						write_byte( iglow[enemy][1] ) // fade alpha
						message_end()
					}
				}
			}	
		}
	#endif
	}

	// Item Block
	// ----------
	// This block of code handles the affects of various
	// player bought items.
	//
	if(playeritem[enemy] == MASK && !bEnemyDead)
	{
		if(iVictimHealth < 0)
			iEnemyHealth += floatround(float(damage + iVictimHealth) * MASKPERCENT)
		else
			iEnemyHealth += floatround(float(damage) * MASKPERCENT)
		
		if(iEnemyHealth > (p_skills[enemy][0]==2 ? ( p_skills[enemy][2] ? p_devotion[p_skills[enemy][2]-1] : 100) : 100))
			iEnemyHealth = (p_skills[enemy][0]==2 ? ( p_skills[enemy][2] ? p_devotion[p_skills[enemy][2]-1] : 100) : 100)
		
		iglow[enemy][1] += damage

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
	else if(!bVictimDead)
	{
		if(playeritem[enemy] == CLAWS)
		{
			iVictimHealth -= CLAWSOFATTACK
	
			iglow[id][0] += 2*damage
			
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
		else if (playeritem[enemy] == FROST)
		{
			if (!slowed[id])
			{
				slowed[id]=true
				iParm[1] = 2
				set_task(1.0,"speed_reset",550+id,iParm,2)

				iglow[id][3] += 100
	
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
	
	// Let's do the glow!
	// ------------------
	//
	if (iglow[id][0]>MAXGLOW)
		iglow[id][0]=MAXGLOW
	if (iglow[id][1]>MAXGLOW)
		iglow[id][1]=MAXGLOW
	if (iglow[id][2]>MAXGLOW)
		iglow[id][2]=MAXGLOW
	if (iglow[id][3]>MAXGLOW)
		iglow[id][3]=MAXGLOW
		
	if (iglow[enemy][0]>MAXGLOW)
		iglow[enemy][0]=MAXGLOW
	if (iglow[enemy][1]>MAXGLOW)
		iglow[enemy][1]=MAXGLOW
	if (iglow[enemy][2]>MAXGLOW)
		iglow[enemy][2]=MAXGLOW
	if (iglow[enemy][3]>MAXGLOW)
		iglow[enemy][3]=MAXGLOW
		
	if (iglow[id][0] > 0 || iglow[id][1] > 0 || iglow[id][2] > 0 || iglow[id][3] > 0)
		set_task(0.1,"glow_change",14,iParm,2)
	if (iglow[enemy][0] > 0 || iglow[enemy][1] > 0 || iglow[enemy][2] > 0 || iglow[enemy][3] > 0)
	{
		iParm[0] = enemy
		set_task(0.1,"glow_change",14,iParm,2)
	}
	
	#if EXPANDED_RACES
	// Dwarf Avatar
	// ------------
	// If the attacking enemy has Necklace of Immunity, we need to make sure the
	// Avatar-affected player is treated correctly. If their health is below 0 once
	// the adjustment is removed, the player is dead. We clean up the Avatar task and
	// variables. Otherwise adjust their stored health for when Avatar ends.
	//
	if(p_skills[id][0] == 7 && p_skills[id][4] && bDwarfAvatar[id] && playeritem[enemy] == IMMUNITY)
	{
		if(iVictimHealth - DWARF_AVATAR_ADJ <= 0)
		{
			iVictimHealth = 0
			bDwarfAvatar[id] = false
			iDwarfAvatarHP[id] = 0
			remove_task(4400+id)
		}
		else
			iDwarfAvatarHP[id] = iVictimHealth - DWARF_AVATAR_ADJ
	}
	#endif

	// Finale Block
	// ------------
	// Now that we've calculated all the skills, we have two values, the
	// enemy health and victim health. If they're 0 and the player isn't
	// already dead, kill the player. Otherwise set the new health.
	//
	if(!bEnemyDead && (iEnemyHealth <= 0 || (iEnemyHealth <= ELF_EVADE_ADJ && iEnemyHealth > 500)))
	{
		set_user_health(enemy,-1)
		
		if (get_user_team(id)!=get_user_team(enemy))
		{
			set_user_frags(id, get_user_frags(id)+1)
			set_user_frags(enemy, get_user_frags(enemy)+1)
			playerxp[id]+=xpgiven[p_level[enemy]]
			displaylevel(id, 1)
		}
		
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(id)
		write_byte(enemy)
		write_byte(0)
		
		if(p_skills[id][0] == 4)
		{
			write_string(race4skill[1])
			message_end()
			logKill(id, enemy, race4skill[1])
		}
		#if EXPANDED_RACES
		else if(p_skills[id][0] == 8)
		{
			write_string(race8skill[0])
			message_end()
			logKill(id, enemy, race8skill[0])
		}
		#endif
		else
		{
			write_string("BUG CHECK WAR3LOG")
			message_end()
			logKill(id, enemy, "BUG CHECK WAR3LOG")
			
			log_to_file("war3.log","[WC3] A bug has occured in damage_event()!")
			log_to_file("war3.log","[WC3] Player %d should not have just died!", enemy)
			log_to_file("war3.log","[WC3] %d was the attacker. He is race %d.", enemy, p_skills[enemy][0])
			log_to_file("war3.log","[WC3] %d was the victim. He is race %d.", id, p_skills[id][0])
			log_to_file("war3.log","[WC3] %d: %d %d %d %d - %d: %d %d %d %d", enemy, p_skills[enemy][1], p_skills[enemy][2], p_skills[enemy][3], p_skills[enemy][4], id, p_skills[id][1], p_skills[id][2], p_skills[id][3], p_skills[id][4])
		}
	}
	else
		set_user_health(enemy,iEnemyHealth)
		
	if(!bVictimDead && (iVictimHealth <= 0 || (iVictimHealth <= ELF_EVADE_ADJ && iVictimHealth > 500)))
	{
		set_user_health(id,-1)
		
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
		case 14:
			weaponname = "galil"
		case 15:
			weaponname = "famas"
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

		if (get_user_team(id)!=get_user_team(enemy))
		{
			set_user_frags(id, get_user_frags(id)+1)
			set_user_frags(enemy, get_user_frags(enemy)+1)
			if (!get_cvar_num("mp_weaponxpmodifier"))
				playerxp[enemy]+=xpgiven[p_level[id]]
			else
				playerxp[enemy]+=floatround(xpgiven[p_level[id]]*weaponxpmultiplier[weapon])
		}
		else
		{
			set_user_frags(id, get_user_frags(id)+1)
			set_user_frags(enemy, get_user_frags(enemy)-1)
			playerxp[enemy]-=xpgiven[p_level[enemy]]
		}

		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(enemy)
		write_byte(id)
		write_byte(headshot)
		write_string(weaponname)
		message_end()
		displaylevel(enemy, 1)
	}
	else
		set_user_health(id,iVictimHealth)
		
	// Last but not least, trigger the speed controller
	if(iParm[1] > 0)
		speed_controller(id)

	return PLUGIN_CONTINUE
} 
#endif

public glow_change(parm[]){
	new id = parm[0]
	
	if(!is_user_connected(id)) return PLUGIN_CONTINUE

	// Don't glow if player is invisible
	if ((p_skills[id][0]==2 && p_skills[id][1]) || playeritem[id]==CLOAK)
	{	
		iglow[id][0] = 0
		iglow[id][1] = 0
		iglow[id][2] = 0
		iglow[id][3] = 0
	}
	else if(iglow[id][0] || iglow[id][1] || iglow[id][2])
	{
		if (iglow[id][0] < 0)
			iglow[id][0] = 0
		if (iglow[id][1] < 0)
			iglow[id][1] = 0
		if (iglow[id][2] < 0)
			iglow[id][2] = 0
			
		set_user_rendering(id,kRenderFxGlowShell,iglow[id][0],iglow[id][1],iglow[id][2], kRenderNormal, 16)
	
		if (iglow[id][0] > 5)
			iglow[id][0] -= 5
		if (iglow[id][1] > 5)
			iglow[id][1] -= 5
		if (iglow[id][2] > 5)
			iglow[id][2] -= 5

		set_task(0.2,"glow_change",15,parm,2)
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

// Speed Controller Functions
// --------------------------
// The following code block contains the functions used by WC3 (As of 2.6) to
// control player speeds. speed_reset is used with the player_spawn() code as
// well skills like bash and entangle to "free" a user from those ailments. It
// currently sets players to 230.0 before calling speed_controller, this is a
// temporary fix.
//
// Speed_controller actually enforces all speed skills, as well as the freeze
// timer. Skills are tested in order of lowest speed, ie stun first (Speed of 1)
// followed by frostnova (speed of 80) and so forth, ending with undead's unholy aura
//
// The two weapon_zoom functions are used to hook when a player zooms their weapon..
// Otherwise they would be able to escape from stun/bash/etc
//
public speed_reset(iParm[2])
{
	if(!is_user_connected(iParm[0])) return PLUGIN_CONTINUE

	if(iParm[1] == 0)
	{	
		stunned[iParm[0]] = false
		slowed[iParm[0]] = false
		#if EXPANDED_RACES
		iBloodLust[iParm[0]] = 0
		bFrostNova[iParm[0]] = false
		#endif
		bEntangled[iParm[0]] = false
	}
	else if(iParm[1] == 1)
		stunned[iParm[0]] = false
	else if(iParm[1] == 2)
		slowed[iParm[0]] = false
	#if EXPANDED_RACES
	else if(iParm[1] == 3)
		iBloodLust[iParm[0]] = 0
	else if(iParm[1] == 4)
		bFrostNova[iParm[0]] = false
	#endif
	else if(iParm[1] == 5)
		bEntangled[iParm[0]] = false
	
	// Reset the user to their last known true speed (At weapon change)..
	set_user_maxspeed(iParm[0],(gTrueSpeed[iParm[0]] > 130.0 ? gTrueSpeed[iParm[0]] : 250.0))
	speed_controller(iParm[0])

	return PLUGIN_CONTINUE
}

public speed_controller(id)
{
	if(!is_user_connected(id) || !is_user_alive(id)) return PLUGIN_CONTINUE

	if(stunned[id] || bFreezeTime || bEntangled[id])
		set_user_maxspeed(id,0.1)
	#if EXPANDED_RACES
	else if(bFrostNova[id])
		set_user_maxspeed(id,80.0)
	else if(iBloodLust[id] > 0)
		set_user_maxspeed(id,p_bloodslow[iBloodLust[id]-1])
	#endif
	else if(slowed[id])
		set_user_maxspeed(id,FROSTSPEED)
	else if(p_skills[id][0] == 1 && p_skills[id][2])
		set_user_maxspeed(id,(p_unholy[p_skills[id][2]-1]))
	else if(playeritem[id]==BOOTS)
		set_user_maxspeed(id,BOOTSPEED)
	       
	return PLUGIN_CONTINUE
}

// weapon_statechange()
// --------------------
// This function is called on 4 occasions.. When a sniper rifle
// is zoomed in and out, and when a shield is opened and closed.
// These four events don't work in change_weapon() because it
// only does speed adjustments if the actual weapon id changed.
//
public weapon_statechange(id)
{
	speed_controller(id)
	return PLUGIN_CONTINUE
}

// change_weapon()
// ---------------
// Weapon changing is a good hook to reset affects, because HL triggers this a LOT. When
// the player reloads, changes weapons, fires their gun, this gets called.
//
// As of 2.6, we only do speed adjustments when the weapon changes. This helps save
// CPU because change_weapon is called everytime the player fires their weapon.
//
// We're still setting invis everytime this gets called. This also triggers the
// dwarf skill extended ammunition, when the player runs out of bullets.
//
public change_weapon(id)
{
	if (warcraft3 == false) return PLUGIN_CONTINUE

	new iWpnNum = read_data(2)

	// If the player's weapon has changed, handle some extra stuff such as
	// the speed controller and human invisiblitity.
	if(iWpnNum != gWpnUsed[id])
	{
		if(p_skills[id][0] == 2 && p_skills[id][1])
		{
			if (iWpnNum == CSW_KNIFE)
				set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,p_invisibility[p_skills[id][1]-1]-p_invisibility[2]+KNIFEINVISIBILITY)
			else
				set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,p_invisibility[p_skills[id][1]-1])
		}
		else if (playeritem[id] == CLOAK)
		{
			if (iWpnNum == CSW_KNIFE)
				set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,CLOAKINVISIBILITY-p_invisibility[2]+KNIFEINVISIBILITY)
			else
				set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,CLOAKINVISIBILITY)
		}	
	
		gWpnUsed[id] = iWpnNum
		gTrueSpeed[id] = get_user_maxspeed(id)
		speed_controller(id)
	}
	
	#if EXPANDED_RACES
	if(p_skills[id][0] == 7 && p_skills[id][3])
	{
		new iClip = read_data(3)

		if(iWpnNum != CSW_C4 && iWpnNum != CSW_KNIFE && iWpnNum != CSW_HEGRENADE && iWpnNum != CSW_SMOKEGRENADE && iWpnNum != CSW_FLASHBANG && iClip == 0)
			dwarf_reloadcmd(id)
	}
	#endif

	return PLUGIN_CONTINUE
}

// Reincarnation Controller
// ------------------------
// The following code block handles reincarnating players.
//
public reincarnation_controller(iParm[2])
{
	if (warcraft3==false || !is_user_connected(iParm[0]))
		return PLUGIN_CONTINUE
	
	new id = iParm[0]

	// If this is an Orc, we need to check their skill. If the player
	// had an Ankh, ignore this. If skill check fails, return. Nothing
	// further to do.
	if(p_skills[id][0] == 3 && p_skills[id][3] && playerItemOld[id] != ANKH)
	{
		new Float:randomnumber = random_float(0.0,1.0)   
		
		if (randomnumber > p_ankh[p_skills[id][3]-1])
			return PLUGIN_CONTINUE
	}
	
	#if EXPANDED_RACES
	// Don't bother with armor if the player is Blood Elf with
	// Crimson Armor
	if(!(p_skills[id][0] == 5 && p_skills[id][1]))
	{
	#endif
		if (armorondeath[id])
		{
			if (helmet[id])
				give_item(id,"item_assaultsuit")
			else
				give_item(id,"item_kevlar")
				
			set_user_armor(id,armorondeath[id])
		}
	#if EXPANDED_RACES
	}
	#endif

	if(hasdefuse[id])
		give_item(id,"item_thighpack")

	reincarnation_weapons(iParm)
	
	if (iglow[id][1] < 1)
		set_task(0.1,"glow_change",4,iParm,2)

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

	return PLUGIN_HANDLED	
}	

public reincarnation_weapons(iParm[2])
{
	if(warcraft3==false || !is_user_alive(iParm[0]))
		return PLUGIN_CONTINUE

	new id = iParm[0]
	
	new pistol = CSW_GLOCK18, bool:drop = true, team = get_user_team(id)
	if(team == 2)
		pistol = CSW_USP	

	for (new j=0; (j < savednumber[id]) && (j < 32); j++)
	{
		if(contain(gWpnNames[savedweapons[id][j]-1],"weapon_") == 0 && savedweapons[id][j] != CSW_C4)
		{
			give_item(id,gWpnNames[savedweapons[id][j]-1])
			client_cmd(id,gWpnNames[savedweapons[id][j]-1])
			
			if(contain(gWpnAmmo[savedweapons[id][j]-1],"ammo_") == 0)
			{
				give_item(id,gWpnAmmo[savedweapons[id][j]-1])
				give_item(id,gWpnAmmo[savedweapons[id][j]-1])
				give_item(id,gWpnAmmo[savedweapons[id][j]-1])
				give_item(id,gWpnAmmo[savedweapons[id][j]-1])
				give_item(id,gWpnAmmo[savedweapons[id][j]-1])
				give_item(id,gWpnAmmo[savedweapons[id][j]-1])
			}
			
			if(pistol == savedweapons[id][j])
				drop = false
		}
		
		savedweapons[id][j] = 0
	}
	
	if(drop)
	{
		#if !REINCARNATION_DELETE
		if (is_user_bot(id))
			engclient_cmd(id, "drop %s", gWpnNames[pistol-1])
		else
			client_cmd(id, "drop %s", gWpnNames[pistol-1])
		#else
		reincarnation_drop(id)
		#endif
	}

	savednumber[id] = 0
	
	return PLUGIN_CONTINUE
}

#if REINCARNATION_DELETE
// The ideas behind this were borrowed from the CSDM plugin
// written by BAILOPAN, then trimmed and customized to get rid
// of pistols for reincaration.
public reincarnation_drop(id)
{
	new iParm[2]
	
	if(is_user_alive(id))
	{
		if (get_user_team(id) == 1)
		{
			if (is_user_bot(id))
				engclient_cmd(id, "drop %s", "weapon_glock18")
			else
				client_cmd(id, "drop %s", "weapon_glock18")

			iParm[1] = CSW_GLOCK18
		}
		else if (get_user_team(id) == 2)
		{
			if (is_user_bot(id))
				engclient_cmd(id, "drop %s", "weapon_usp")
			else
				client_cmd(id, "drop %s", "weapon_usp")
				
			iParm[1] = CSW_USP
		}
		else
			return PLUGIN_CONTINUE
		
		iParm[0] = id
		set_task(0.5, "reincarnation_rmweapon", 0, iParm, 2)
	}
	
	return PLUGIN_CONTINUE
}

public reincarnation_rmweapon(iParm[2])
{
	// new id = iParm[0]
	new iWeapon = iParm[1]
	
	new sWpnModel[32], sWpnModel2[32], sWpnName[24]
	new tEnt, tfEnt
	new wEnt, wfEnt, woEnt

	if(iWeapon == CSW_USP)
	{
		copy(sWpnModel, 31, "models/w_usp.mdl")
		copy(sWpnName, 23, "weapon_usp")
	}	
	else if(iWeapon == CSW_GLOCK18)
	{
		copy(sWpnModel, 31, "models/w_glock18.mdl")
		copy(sWpnName, 23, "weapon_glock18")
	}
	else
		return PLUGIN_CONTINUE

	tEnt = find_ent_by_class(-1, "weaponbox")
	while(tEnt > 0)
	{
		tfEnt = find_ent_by_class(tEnt, "weaponbox")
		entity_get_string(tEnt, EV_SZ_model, sWpnModel2, 31)
		if(equal(sWpnModel,sWpnModel2))
		{
			remove_entity(tEnt)
			wEnt = find_ent_by_class(-1, sWpnName)
			
			while(wEnt > 0)
			{
				wfEnt = find_ent_by_class(wEnt, sWpnName)
				woEnt = entity_get_edict(wEnt, EV_ENT_owner)
				if(woEnt == tEnt && woEnt > 32 && woEnt)
					remove_entity(wEnt)
				wEnt = wfEnt
			}				
		}
		
		tEnt = tfEnt
	}

	return PLUGIN_CONTINUE
}
#endif

public say_level(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	displaylevel(id, 0)
	return PLUGIN_HANDLED
}

public player_skills(id,saychat){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
		
	new name[MAX_NAME_LENGTH], message[2048]
	new temp[1024]
	
	new skill1[64], skill2[64], skill3[64], skill4[64]
	new players[MAX_PLAYERS]
	new numberofplayers
	get_players(players, numberofplayers)
	new i
	new playerid

	add(message,2047,"<HTML><head></head><body bgcolor=#000000><font color=#FFB000>")

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
			format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[1],p_level[playerid],skill1,skill2,skill3,skill4)
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
			format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[2],p_level[playerid],skill1,skill2,skill3,skill4)
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
			format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[3],p_level[playerid],skill1,skill2,skill3,skill4)
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
			format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[4],p_level[playerid],skill1,skill2,skill3,skill4)
		}
		#if EXPANDED_RACES
		else if (p_skills[playerid][0]==5){
			if(p_skills[playerid][1])
				format(skill1,63,", %s %d",race5skill[0],p_skills[playerid][1])
			if(p_skills[playerid][2])
				format(skill2,63,", %s %d",race5skill[1],p_skills[playerid][2])
			if(p_skills[playerid][3])
				format(skill3,63,", %s %d",race5skill[2],p_skills[playerid][3])
			if(p_skills[playerid][4])
				format(skill4,63,", %s",race5skill[3])
			format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[5],p_level[playerid],skill1,skill2,skill3,skill4)
		}
		else if (p_skills[playerid][0]==6){
			if(p_skills[playerid][1])
				format(skill1,63,", %s %d",race6skill[0],p_skills[playerid][1])
			if(p_skills[playerid][2])
				format(skill2,63,", %s %d",race6skill[1],p_skills[playerid][2])
			if(p_skills[playerid][3])
				format(skill3,63,", %s %d",race6skill[2],p_skills[playerid][3])
			if(p_skills[playerid][4])
				format(skill4,63,", %s",race6skill[3])
			format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[6],p_level[playerid],skill1,skill2,skill3,skill4)
		}
		else if (p_skills[playerid][0]==7){
			if(p_skills[playerid][1])
				format(skill1,63,", %s %d",race7skill[0],p_skills[playerid][1])
			if(p_skills[playerid][2])
				format(skill2,63,", %s %d",race7skill[1],p_skills[playerid][2])
			if(p_skills[playerid][3])
				format(skill3,63,", %s %d",race7skill[2],p_skills[playerid][3])
			if(p_skills[playerid][4])
				format(skill4,63,", %s",race7skill[3])
			format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[7],p_level[playerid],skill1,skill2,skill3,skill4)
		}
		else if (p_skills[playerid][0]==8){
			if(p_skills[playerid][1])
				format(skill1,63,", %s %d",race8skill[0],p_skills[playerid][1])
			if(p_skills[playerid][2])
				format(skill2,63,", %s %d",race8skill[1],p_skills[playerid][2])
			if(p_skills[playerid][3])
				format(skill3,63,", %s %d",race8skill[2],p_skills[playerid][3])
			if(p_skills[playerid][4])
				format(skill4,63,", %s",race8skill[3])
			format(temp,1023,"%s - %s %d%s%s%s%s<br>",name,racename[8],p_level[playerid],skill1,skill2,skill3,skill4)
		}
		#endif		
		else if (p_skills[playerid][0]==0){
			#if LANG_ENG
				format(temp,1023,"%s - race not yet selected<br>",name)
			#endif
			#if LANG_GER
				format(temp,1023,"%s - noch keine Rasse gewaehlt<br>",name)
			#endif
			#if LANG_FRE
				format(temp,1023,"%s - n'a pas encore choisi sa race<br>",name)
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
     		#if EXPANDED_RACES
        	else if (p_skills[id][0]==5){
			format(title,63,"%s Skills",racename[5])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Crimson Armor: Gives you full armor plus (%d, %d or %d) at the start of the round.<p>\
				Mana Shield: Any damage you take from enemies, except a kill shot, is reduced by (%d%%, %d%%, %d%%)<p>\
				Bloodlust: Adds (%d, %d or %d) damage to each bullet. Movement speed of enemy is also reduced temporarily.<p>\
				Ultimate, Shadowstrike: Emits a powerful damaging force at an enemy in your sights"
			format(message,2047,message,p_crimsonarmor[0],p_crimsonarmor[1],p_crimsonarmor[2],floatround(p_manashield[0]*100),floatround(p_manashield[1]*100),floatround(p_manashield[2]*100),p_bloodlust[0],p_bloodlust[1],p_bloodlust[2])
		}
        	else if (p_skills[id][0]==6){
			format(title,63,"%s Skills",racename[6])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Silent Run: Gives you a chance at being silent with no footsteps. (%d%%, %d%% or %d%%)<p>\
				Regeneration: You regenerate health if you are below the limit. (%d, %d or %d hp)<p>\
				Berserk: Adds %d damage to each of your shots if your health is below the limit. (%d, %d or %d hp)<p>\
				Ultimate, Healing Wand: Allies near you, and yourself, are regenerated for %d health. You gain an extra 5."
			format(message,2047,message,floatround(p_silence[0]*100),floatround(p_silence[1]*100),floatround(p_silence[2]*100),p_regen[0],p_regen[1],p_regen[2],p_berserkdamage, p_berserk[0],p_berserk[1],p_berserk[2], HEALINGWAND_HEALTH*5)
		}
        	else if (p_skills[id][0]==7){
			format(title,63,"%s Skills",racename[7])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Grenade Sack: Gives you grenades (%d, %d or %d) each round..<p>\
				Mithril Armor: Any damage you take from enemies will be reduced (%d, %d, or %d), unless the damage is less than that amount plus 5.<p>\
				Extended Ammunition: Adds (%d, %d or %d) bullets to each of your weapon clips.<p>\
				Ultimate, Avatar: Gives you godmode for %d seconds."
			format(message,2047,message,p_grenades[0],p_grenades[1],p_grenades[2],p_mitharmor[0],p_mitharmor[1],p_mitharmor[2],p_ammoclip[0],p_ammoclip[1],p_ammoclip[2],floatround(AVATAR_DURATION))
		}
        	else if (p_skills[id][0]==8){
			format(title,63,"%s Skills",racename[8])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Ice Shards: You have a chance (%d%%, %d%%, or %d%%) of dealing 100%% mirror damage.<p>\
				Terror: You have a chance (%d%%, %d%%, or %d%%) of darkening your enemies screen when you shoot them.<p>\
				Frost Armor: You have a chance (%d%%, %d%%, or %d%%) of adding the amount of damage you dealt to your armor.<p>\
				Ultimate, Frost Nova: All enemies within range are drasticly slowed for %d seconds."
			format(message,2047,message,floatround(p_iceshards[0]*100),floatround(p_iceshards[1]*100),floatround(p_iceshards[2]*100),floatround(p_terror[0]*100),floatround(p_terror[1]*100),floatround(p_terror[2]*100),floatround(p_frostarmor[0]*100),floatround(p_frostarmor[1]*100),floatround(p_frostarmor[2]*100),floatround(FROSTNOVA_DURATION))
		}
		#endif
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
	        #if EXPANDED_RACES
	        else if (p_skills[id][0]==5){
	        	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    Then press the key (shift in this case) you should hear a beeping sound, this means that you are searching for<br> a target. \
                                    Once you hear the beeping sound aim your crosshair at a player.<br> You have 10 seconds to find a target before it gives up."
                	add(message,1023,temp)
	        }
	        else if (p_skills[id][0]==6 || p_skills[id][0] == 8){ 
	        	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    Then press the key (shift in this case) you should hear see colored rings radiate out from you, indicating that your ultimate\
                            	    has worked. All targets in range will be affected."
                	add(message,1023,temp)
	        }
	        else if (p_skills[id][0]==7){ 
	        	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    Then press the key (shift in this case) you should see a yellow glow. You have only a few seconds of godmode!!"
                	add(message,1023,temp)
	        }
	        #endif
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
		#if EXPANDED_RACES
        	else if (p_skills[id][0]==5){
			format(title,63,"%s Fertigkeiten",racename[5])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Blutrote Ruestung: Gibt dir komplette Ausruestung plus (%d, %d or %d) am Anfang der Runde.<p>\
				Mana Schild: Jeder Treffer von Gegner (ausser toedliche Treffer) werden um (%d%%, %d%%, %d%%) verringert<p>\
				Blutrausch: Fuegt (%d, %d or %d) Schaden zu jeder Kugel hinzu, Gegner wird kurz verlangsamt.<p>\
				Ultimate, Schattenstoss: Verursacht Schaden zur Gegner auf den man zielt"
			format(message,2047,message,p_crimsonarmor[0],p_crimsonarmor[1],p_crimsonarmor[2],floatround(p_manashield[0]*100),floatround(p_manashield[1]*100),floatround(p_manashield[2]*100),p_bloodlust[0],p_bloodlust[1],p_bloodlust[2])
		}
        	else if (p_skills[id][0]==6){
			format(title,63,"%s Skills",racename[6])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Silent Run: Gives you a chance at being silent with no footsteps. (%d%%, %d%% or %d%%)<p>\
				Regeneration: You regenerate health if you are below the limit. (%d, %d or %d hp)<p>\
				Berserk: Adds %d damage to each of your shots if your health is below the limit. (%d, %d or %d hp)<p>\
				Ultimate, Healing Wand: Allies near you, and yourself, are regenerated for %d health. You gain an extra 5."
			format(message,2047,message,floatround(p_silence[0]*100),floatround(p_silence[1]*100),floatround(p_silence[2]*100),p_regen[0],p_regen[1],p_regen[2],p_berserkdamage, p_berserk[0],p_berserk[1],p_berserk[2], HEALINGWAND_HEALTH*5)
		}
        	else if (p_skills[id][0]==7){
			format(title,63,"%s Skills",racename[7])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Grenade Sack: Gives you grenades (%d, %d or %d) each round..<p>\
				Mithril Armor: Any damage you take from enemies will be reduced (%d, %d, or %d), unless the damage is less than that amount plus 5.<p>\
				Extended Ammunition: Adds (%d, %d or %d) bullets to each of your weapon clips.<p>\
				Ultimate, Avatar: Gives you godmode for %d seconds."
			format(message,2047,message,p_grenades[0],p_grenades[1],p_grenades[2],p_mitharmor[0],p_mitharmor[1],p_mitharmor[2],p_ammoclip[0],p_ammoclip[1],p_ammoclip[2],floatround(AVATAR_DURATION))
		}
        	else if (p_skills[id][0]==8){
			format(title,63,"%s Skills",racename[8])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Ice Shards: You have a chance (%d%%, %d%%, or %d%%) of dealing 100%% mirror damage.<p>\
				Terror: You have a chance (%d%%, %d%%, or %d%%) of darkening your enemies screen when you shoot them.<p>\
				Frost Armor: You have a chance (%d%%, %d%%, or %d%%) of adding the amount of damage you dealt to your armor.<p>\
				Ultimate, Frost Nova: All enemies within range are drasticly slowed for %d seconds."
			format(message,2047,message,floatround(p_iceshards[0]*100),floatround(p_iceshards[1]*100),floatround(p_iceshards[2]*100),floatround(p_terror[0]*100),floatround(p_terror[1]*100),floatround(p_terror[2]*100),floatround(p_frostarmor[0]*100),floatround(p_frostarmor[1]*100),floatround(p_frostarmor[2]*100),floatround(FROSTNOVA_DURATION))
		}
		#endif
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
	        #if EXPANDED_RACES
	        else if (p_skills[id][0]==5){
	                new temp[]="<br>&nbsp;<br>&nbsp;<br>Beachte: um die Ultimate Fertigkeit ausloesen zu koennen, musst du eine Taste auf ^"ultimate^" binden, z.B. bind ^"shift^" ^"ultimate^"<br>\
                            	    Dann musst du die Taste druecken (z.B. shift). Du solltest ein Piepen hoeren. Das bedeutet, dass ein Ziel gesucht wird. \
                                    Sobald du das Piepen hoerst, ziele auf einen Spieler und warte bis es eingelockt ist. Du hast 10 Sekunden um ein Ziel zu finden, bevor es aufhoert."
                	add(message,1023,temp)
	        }
	        else if (p_skills[id][0]==6 || p_skills[id][0] == 8){ 
	        	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    Then press the key (shift in this case) you should hear see colored rings radiate out from you, indicating that your ultimate\
                            	    has worked. All targets in range will be affected."
                	add(message,1023,temp)
	        }
	        else if (p_skills[id][0]==7){ 
	        	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    Then press the key (shift in this case) you should see a yellow glow. You have only a few seconds of godmode!!"
                	add(message,1023,temp)
	        }
	        #endif
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
		#if EXPANDED_RACES
		else if (p_skills[id][0]==5){
			format(title,63,"Competences des %s.",racename[5])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Armure Enchanter: Te donne l'armure complete plus (%d, %d, %d) au commencement du round.<p>\
			Mana de Protection: Tous les dmg non mortels que tu prendras seront réduits par (%d%%, %d%%, %d%%).<p>\
			La Soif de Sang: Ajoute (%d, %d , %d) de dmg à chaque balle et la vitesse de l'ennemi est reduite temporairement.<p>\
			Ultimate, L'ombre de Frappe: Emet une puissante force destructrice à un ennemi qui est dans ton champs de vision."
			format(message,2047,message,p_crimsonarmor[0],p_crimsonarmor[1],p_crimsonarmor[2],floatround(p_manashield[0]*100),floatround(p_manashield[1]*100),floatround(p_manashield[2]*100),p_bloodlust[0],p_bloodlust[1],p_bloodlust[2])
		}
        	else if (p_skills[id][0]==6){
			format(title,63,"%s Skills",racename[6])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Silent Run: Gives you a chance at being silent with no footsteps. (%d%%, %d%% or %d%%)<p>\
				Regeneration: You regenerate health if you are below the limit. (%d, %d or %d hp)<p>\
				Berserk: Adds %d damage to each of your shots if your health is below the limit. (%d, %d or %d hp)<p>\
				Ultimate, Healing Wand: Allies near you, and yourself, are regenerated for %d health. You gain an extra 5."
			format(message,2047,message,floatround(p_silence[0]*100),floatround(p_silence[1]*100),floatround(p_silence[2]*100),p_regen[0],p_regen[1],p_regen[2],p_berserkdamage, p_berserk[0],p_berserk[1],p_berserk[2], HEALINGWAND_HEALTH*5)
		}
        	else if (p_skills[id][0]==7){
			format(title,63,"%s Skills",racename[7])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Grenade Sack: Gives you grenades (%d, %d or %d) each round..<p>\
				Mithril Armor: Any damage you take from enemies will be reduced (%d, %d, or %d), unless the damage is less than that amount plus 5.<p>\
				Extended Ammunition: Adds (%d, %d or %d) bullets to each of your weapon clips.<p>\
				Ultimate, Avatar: Gives you godmode for %d seconds."
			format(message,2047,message,p_grenades[0],p_grenades[1],p_grenades[2],p_mitharmor[0],p_mitharmor[1],p_mitharmor[2],p_ammoclip[0],p_ammoclip[1],p_ammoclip[2],floatround(AVATAR_DURATION))
		}
        	else if (p_skills[id][0]==8){
			format(title,63,"%s Skills",racename[8])
			message = "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>Ice Shards: You have a chance (%d%%, %d%%, or %d%%) of dealing 100%% mirror damage.<p>\
				Terror: You have a chance (%d%%, %d%%, or %d%%) of darkening your enemies screen when you shoot them.<p>\
				Frost Armor: You have a chance (%d%%, %d%%, or %d%%) of adding the amount of damage you dealt to your armor.<p>\
				Ultimate, Frost Nova: All enemies within range are drasticly slowed for %d seconds."
			format(message,2047,message,floatround(p_iceshards[0]*100),floatround(p_iceshards[1]*100),floatround(p_iceshards[2]*100),floatround(p_terror[0]*100),floatround(p_terror[1]*100),floatround(p_terror[2]*100),floatround(p_frostarmor[0]*100),floatround(p_frostarmor[1]*100),floatround(p_frostarmor[2]*100),floatround(FROSTNOVA_DURATION))
		}
		#endif
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
	        #if EXPANDED_RACES
	        else if (p_skills[id][0]==5){
	                new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: pour utiliser les competences ultimes, binde une touche ^"ultimate^", c'est a dire bind ^"shift^" ^"ultimate^"<br>\
                            	    Quand tu appuies sur la touche (shift dans ce cas) tu devrais entendre un bip, cela signifie que tu cherches une cible. \
                                    Quand tu as entendu le bip Mets ta cible sur un joueur et attends qu'elle se fixe. Tu as 10 secondes pour trouver une cible avant que ça ne s'arrete."
                	add(message,1023,temp)
	        }
	        else if (p_skills[id][0]==6 || p_skills[id][0] == 8){ 
	        	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    Then press the key (shift in this case) you should hear see colored rings radiate out from you, indicating that your ultimate\
                            	    has worked. All targets in range will be affected."
                	add(message,1023,temp)
	        }
	        else if (p_skills[id][0]==7){ 
	        	new temp[]="<br>&nbsp;<br>&nbsp;<br>Note: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"<br>\
                            	    Then press the key (shift in this case) you should see a yellow glow. You have only a few seconds of godmode!!"
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

        new message[2048]
        new title[] = "Items Information"
	new pos = 0
	
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
	console_print(id,"mp_changeracepastfreezetime - Allow people to change race while alive (default 0, disabled)")
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
        console_print(id,"mp_changeracepastfreezetime - Erlauben Sie Leuten, Rennen zu ändern, wenn lebendig (Standard 0, aus)")
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
        console_print(id,"mp_changeracepastfreezetime - Permet de changer de race tandis que vivant (par defaut 0, desactive)")
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
        new message[2048]
        new pos = 0
	new title[64]

	format(title,63,"Warcraft 3 Help")

	#if LANG_ENG
	        pos += format(message[pos], 2047-pos, "<HTML><head></head><pre><body bgcolor=#000000><font color=#FFB000>")
	        pos += format(message[pos], 2047-pos, "Warcraft 3 is an AMXX plugin for Counter-Strike written by SpaceDude.<br>")
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
	        pos += format(message[pos], 2047-pos, "Warcraft 3 ist ein AMXX Plugin fuer Counter-Strike, das von SpaceDude geschrieben wurde.<br>")
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
	        pos += format(message[pos], 2047-pos, "Warcraft 3 est un plugin AMXX pour Counter-Strike, écrit par SpaceDude .<br>")
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
		
	// Notice: Currently not working as expected, due to how CS restarts the first round
	// of most maps after a second player joins the opposing team.
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
		if( id == vip_id ){
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


	if (is_user_alive(id))
	{
		if (p_skills[id][0]==1 && p_skills[id][4]==1 && !ultimateused[id])
		{
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

		if (p_skills[id][0]==2 && p_skills[id][4]==1 &&  !ultimateused[id]){	// Teleport
			
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
		#if EXPANDED_RACES
		else if (!issearching[id] && p_skills[id][0] == 5 && p_skills[id][4] == 1 && !ultimateused[id])
		{
		        new parm[2]
		        parm[0] = id
		        parm[1] = SHADOWSTRIKE_DURATION
		        bloodelf_shadow_search(parm)  // Shadowstrike
		        bloodelf_shadow_sound(parm)
		        set_task(0.2, "bloodelf_shadow_search",8000+id, parm, 2, "a", (SHADOWSTRIKE_DURATION * 5)-2) // shadowstrike - 10 seconds, ticks every .2 seconds
		        set_task(1.0, "bloodelf_shadow_sound",89+id, parm, 2, "a", SHADOWSTRIKE_DURATION-2) // shadowstrike sound
		        set_task(float(SHADOWSTRIKE_DURATION),"bloodelf_shadow_reset",8100+id,parm,2)
		}
		else if(p_skills[id][0] == 6 && p_skills[id][4] == 1 && !ultimateused[id])
		{
			emit_sound(id,CHAN_STATIC, "ambience/particle_suck1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			new iParm[2]
			iParm[0]=id
			iParm[1]=1
			set_task(0.5,"troll_healingwand",1,iParm,2)
			set_task(0.5,"troll_healingwand_blast",2,iParm,2)
			
			new origin[3]
			get_user_origin(id,origin)
			message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
			write_byte( TE_IMPLOSION )
			write_coord(origin[0])
			write_coord(origin[1])
			write_coord(origin[2])
			write_byte(100)
			write_byte(20)
			write_byte(5)
			message_end()
					
			ultimateused[id]=true
		}
		else if(p_skills[id][0] == 7 && p_skills[id][4] == 1 && !ultimateused[id])
		{
		
			iDwarfAvatarHP[id] = get_user_health(id)
			bDwarfAvatar[id] = true
			
			set_user_health(id,iDwarfAvatarHP[id]+DWARF_AVATAR_ADJ)
		
			new iParm[2]
			iParm[0] = id
			iParm[1] = 1
			set_task(AVATAR_DURATION,"dwarf_endavatar",4400+id,iParm,2)
			
			if (iglow[id][0] < 1 || iglow[id][1] < 1)
			{
				new glowparm[2]
				glowparm[0] = id
				set_task(0.1,"glow_change",8,glowparm,2)
			}
				
			iglow[id][0] = 255
			iglow[id][1] = 255
			iglow[id][2] = 0
			iglow[id][3] = 0			
			
			message_begin(MSG_ONE,gmsgFade,{0,0,0},id)
			write_short( 1<<14) // fade lasts this long duration
			write_short( 1<<13) // fade lasts this long hold time
			write_short( 1<<1 ) // fade type (in / out)
			write_byte( 255 ) // fade red
			write_byte( 255 ) // fade green
			write_byte( 0 ) // fade blue
			write_byte( 50 ) // fade alpha
			message_end()

			new cooldownparm[1]
			cooldownparm[0]=id
			set_task(AVATAR_COOLDOWN,"cooldown",50+id,cooldownparm,1)
		
			ultimateused[id]=true
		}
		else if(p_skills[id][0] == 8 && p_skills[id][4] == 1 && !ultimateused[id])
		{
			// Stealing from Undead right now. Change these sounds!	
			emit_sound(id,CHAN_STATIC, "ambience/particle_suck1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
			new iParm[2]
			iParm[0]=id
			iParm[1]=1
			set_task(0.5,"lich_frostnova",1,iParm,2)
			set_task(0.5,"lich_frostnova_blast",2,iParm,2)
		
			new origin[3]
			get_user_origin(id,origin)
			message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
			write_byte( TE_IMPLOSION )
			write_coord(origin[0])
			write_coord(origin[1])
			write_coord(origin[2])
			write_byte(100)
			write_byte(20)
			write_byte(5)
			message_end()
			
			ultimateused[id]=true
		}
		#endif
	}
	return PLUGIN_HANDLED
}

// ferret - Code for Expanded Races
#if EXPANDED_RACES
public bloodelf_givearmor(parm[2])
{
	new id = parm[0]
	
	if(is_user_alive(id) && is_user_connected(id) && p_skills[id][1])
	{
		give_item(id,"item_assaultsuit")
		new currentarmor = get_user_armor(id)
		set_user_armor(id ,currentarmor + p_crimsonarmor[p_skills[id][1]-1])
	}
	
	return PLUGIN_CONTINUE
}

public bloodelf_shadow_sound(parm[2])
{
	new id = parm[0]
	if(!is_user_alive(id))
		remove_task(89+id)
	emit_sound(id,CHAN_ITEM, "turret/tu_ping.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}

public bloodelf_shadow_damage(id,targetid,damage)
{
	if(!is_user_connected(targetid)) return PLUGIN_CONTINUE

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

	if (get_user_health(targetid)-damage<=0)
		targetdied=true
	
	get_user_aiming(id, current, body)
	if(targetid == current)
		set_user_health(targetid, get_user_health(targetid) - damage)

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

	if (get_user_armor(targetid)-damage<=0)
		set_user_armor(targetid,0)
	else
		set_user_armor(targetid,get_user_armor(targetid)-damage)

	if (targetdied && !targetdead)
	{
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

public bloodelf_shadow_search(parm[2])
{
	new id = parm[0]
	new enemy, body
	get_user_aiming(id,enemy,body)
	
	if(!is_user_alive(id))
		remove_task(8000+id)
	
	if(is_user_connected(enemy) && is_user_alive(id) && get_user_team(id)!=get_user_team(enemy) && playeritem[enemy]!=IMMUNITY)
	{
		issearching[id]=false
		ultimateused[id]=true
		if (file_exists("sound/warcraft3/EntanglingRootsTarget1.wav")==1)
			emit_sound(enemy,CHAN_ITEM, "warcraft3/EntanglingRootsTarget1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		else
			emit_sound(enemy,CHAN_ITEM, "weapons/cbar_hitbod3.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		
		bloodelf_shadow_damage(id, enemy, SHADOWSTRIKE_DAMAGE) // shadowstrike damage application
		
		new cooldownparm[1]
		cooldownparm[0]=id
		set_task(SHADOWSTRIKE_COOLDOWN,"cooldown",50+id,cooldownparm,1)
	}
	else
		issearching[id]=true
	
	return PLUGIN_CONTINUE
}

public bloodelf_shadow_reset(iParm[2])
{
	issearching[iParm[0]] = false
	
	return PLUGIN_CONTINUE
}

// TROLL_REGEN
// -----------
// This function handles the regeneration skill for trolls.
// 
// iParm[0] is the player id.
//
public troll_regen(iParm[2])
{
	if(p_skills[iParm[0]][0] == 6 && p_skills[iParm[0]][2] && is_user_alive(iParm[0]) && is_user_connected(iParm[0]))
	{
		new iHealth = get_user_health(iParm[0])
		
		if(iHealth < p_regen[p_skills[iParm[0]][2]-1])
		{
			iHealth+=p_regenhp
			if(iHealth > p_regen[p_skills[iParm[0]][2]-1])
				iHealth = p_regen[p_skills[iParm[0]][2]-1]
				
			set_user_health(iParm[0],iHealth)		
			
			#if TROLL_REGEN_FLASH
			message_begin(MSG_ONE,gmsgFade,{0,0,0},iParm[0])
			write_short( 1<<4 ) // fade lasts this long duration
			write_short( 1<<4 ) // fade lasts this long hold time
			write_short( 1<<12 ) // fade type (in / out)
			write_byte( 100 ) // fade red
			write_byte( 255 ) // fade green
			write_byte( 100 ) // fade blue
			write_byte( 100 ) // fade alpha
			message_end()
			#endif
		}
	}
	else
		remove_task(7700+iParm[0])
		
	return PLUGIN_CONTINUE
}

// TROLL_SILENCE
// -------------
// This function controls whether or not a troll has footsteps
// or not, based on a two second timer. This is only triggered
// at skill levels 1 and 2, by default.
//
// iParm[0] is the player.
//
public troll_silence(iParm[2])
{
	if(!is_user_connected(iParm[0]))
	{
		remove_task(5500+iParm[0])
		return PLUGIN_CONTINUE
	}

	if(p_skills[iParm[0]][0] == 6 && p_skills[iParm[0]][1] && is_user_alive(iParm[0]))
	{
		new Float:randomnumber = random_float(0.0,1.0)
		if (randomnumber <= p_silence[p_skills[iParm[0]][1]-1])
			set_user_footsteps(iParm[0],1)
		else
			set_user_footsteps(iParm[0],0)
	}
	else
	{
		set_user_footsteps(iParm[0],0)
		remove_task(5500+iParm[0])	
	}

	return PLUGIN_CONTINUE
}

// TROLL_HEALINGWAND
// -----------------
// Handles finding friendly targets for the healing wand ultimate.
// 
// iParm[0] is the troll using healing wand.
//
public troll_healingwand(iParm[2])
{
	new iOrigin[3]
	get_user_origin(iParm[0],iOrigin)

	new iPlayers[MAX_PLAYERS], iNumPlayers	
	get_players(iPlayers, iNumPlayers)
	
	new i, iTarget, iDistance, iTargetOrigin[3]

	for (i = 0; i < iNumPlayers; ++i)
	{
		iTarget = iPlayers[i]
		get_user_origin(iTarget,iTargetOrigin)
		iDistance = get_distance(iOrigin,iTargetOrigin)
		if(iDistance < HEALINGWAND_RANGE && get_user_team(iParm[0]) == get_user_team(iTarget) && (playeritem[iTarget] != IMMUNITY || iTarget == iParm[0]) && get_user_health(iTarget) < ((p_skills[iTarget][0]==2 ? (p_skills[iTarget][2] ? p_devotion[p_skills[iTarget][2]-1] : 100) : 100) + (playeritem[iTarget]==HEALTH ? HEALTHBONUS : 0)) && is_user_alive(iTarget))
		{
			new iHealParm[2]
			iHealParm[0] = iParm[0]
			iHealParm[1] = iTarget
			set_task(1.0,"troll_healingwand_regen",6600+iTarget,iHealParm,2,"a",5)			
		}
	}

	--iParm[1]
	if(iParm[1]>0)
		set_task(0.1,"troll_healingwand",33,iParm,2)
	else
	{
		new cooldownparm[1]
		cooldownparm[0]=iParm[0]
		set_task(HEALINGWAND_COOLDOWN,"cooldown",50+iParm[0],cooldownparm,1)
	}
		
	return PLUGIN_CONTINUE
}

// TROLL_HEALINGWAND_REGEN
// -----------------------
// Handles regeneration for players affected by Healing Wand. The troll
// who used the ultimate gets 5 extra health.
//
// iParm[0] is troll id. iParm[1] is target id.
//
public troll_healingwand_regen(iParm[2])
{
	new iHealth = get_user_health(iParm[1])
	new iMaxHealth = (p_skills[iParm[0]][0]==2 ? ( p_skills[iParm[0]][2] ? p_devotion[p_skills[iParm[0]][2]-1] : 100) : 100) + (playeritem[iParm[0]]==HEALTH ? HEALTHBONUS : 0)
	
	if(iHealth < iMaxHealth && is_user_alive(iParm[1]) && is_user_connected(iParm[1]))
	{
		iHealth += HEALINGWAND_HEALTH

		if(iParm[0] == iParm[1])
			iHealth += 1
			
		if(iHealth >= iMaxHealth)
		{
			iHealth = iMaxHealth
			remove_task(6600+iParm[1])
		}
		
		set_user_health(iParm[1],iHealth)
		
		if (iglow[iParm[1]][1] < 1 || iglow[iParm[1]][2] < 1)
		{
			new iGlowParm[2]
			iGlowParm[0] = iParm[1]
			set_task(0.1,"glow_change",8,iGlowParm,2)
		}
			
		iglow[iParm[1]][0] = 0
		iglow[iParm[1]][1] = 50
		iglow[iParm[1]][2] = 25
		iglow[iParm[1]][3] = 0
				
		#if TROLL_REGEN_FLASH
		message_begin(MSG_ONE,gmsgFade,{0,0,0},iParm[1])
		write_short( 1<<6 ) // fade lasts this long duration
		write_short( 1<<6 ) // fade lasts this long hold time
		write_short( 1<<12 ) // fade type (in / out)
		write_byte( 0 ) // fade red
		write_byte( 255 ) // fade green
		write_byte( 100 ) // fade blue
		write_byte( 100 ) // fade alpha
		message_end()
		#endif
	}
	else
		remove_task(6600+iParm[1])
		
	return PLUGIN_CONTINUE
}

// TROLL_HEALINGWAND_BLAST
// -----------------------
// Make the pretty affects
//
// iParm[0] is the troll id
//
public troll_healingwand_blast(iParm[2])
{
	new iOrigin[3]
	get_user_origin(iParm[0],iOrigin)

	// blast circles
	message_begin( MSG_PAS, SVC_TEMPENTITY, iOrigin )
	write_byte( TE_BEAMCYLINDER )
	write_coord( iOrigin[0])
	write_coord( iOrigin[1])
	write_coord( iOrigin[2] - 16)
	write_coord( iOrigin[0])
	write_coord( iOrigin[1])
	write_coord( iOrigin[2] - 16 + BLASTCIRCLES_RADIUS)
	write_short( m_iSpriteTexture )
	write_byte( 0 ) // startframe
	write_byte( 0 ) // framerate
	write_byte( 6 ) // life
	write_byte( 16 )  // width
	write_byte( 0 )	// noise
	write_byte( 100 )
	write_byte( 255 )
	write_byte( 100 )
	write_byte( 255 ) //brightness
	write_byte( 0 ) // speed
	message_end()

	message_begin( MSG_PAS, SVC_TEMPENTITY, iOrigin )
	write_byte( TE_BEAMCYLINDER )
	write_coord( iOrigin[0])
	write_coord( iOrigin[1])
	write_coord( iOrigin[2] - 16)
	write_coord( iOrigin[0])
	write_coord( iOrigin[1])
	write_coord( iOrigin[2] - 16 + ( BLASTCIRCLES_RADIUS / 2 ))
	write_short( m_iSpriteTexture )
	write_byte( 0 ) // startframe
	write_byte( 0 ) // framerate
	write_byte( 6 ) // life
	write_byte( 16 )  // width
	write_byte( 0 )	// noise
	write_byte( 100 )
	write_byte( 255 )
	write_byte( 100 )
	write_byte( 255 ) //brightness
	write_byte( 0 ) // speed
	message_end()
	
	return PLUGIN_CONTINUE
}

// DWARF_GRENADE
// -------------
// This function is triggered by the AmmoX event. If the player is a dwarf and has
// the dwarf grenade sack skill, it checks if a grenade was thrown. If the player
// hasn't been given all of their grenades yet, it does a settask to give a new
// one.
//
// Note: The AmmoX event that triggers this doesn't use the normal weapon ids that
// exist in AMXX as CSW_<weapon> .. 11 = Flash grenade, 12 = HE grenade, and
// 13 = Smoke grenade.
//
public dwarf_grenade(id)
{
	if(is_user_alive(id) && p_skills[id][0] == 7 && p_skills[id][1] && is_user_connected(id))
	{
		new iParm[2]
		iParm[0] = id
		iParm[1] = -1
		
		new iGrenadeType = read_data(1)
		new iGrenadeCount = read_data(2)
		
		if((iGrenadeType == 12 || iGrenadeType == 11 || iGrenadeType == 13) && iGrenadeCount == 0)
		{
			if(iGrenadeType == 12 && iDwarfGrenades[id][0] < p_grenades[p_skills[id][1]-1])
				iParm[1] = 1
			else if(iGrenadeType == 11 && iDwarfGrenades[id][1] < p_grenades[p_skills[id][1]-1])
				iParm[1] = 2
			#if DWARF_SMOKE
			else if(iGrenadeType == 13 && iDwarfGrenades[id][2] < p_grenades[p_skills[id][1]-1])
				iParm[1] = 3
			#endif
			
			if(iParm[1] != -1)
				set_task(0.5,"dwarf_givegrenade",999,iParm,2)
		}
	}
	
	return PLUGIN_CONTINUE
}

// DWARF_GIVEGRENADE
// -----------------
// This function is used with settask to give out grenades for
// the Dwarf skill Grenade Sack
//
// iParm[0] is the player id. iParm[1] contains the grenade type
//
public dwarf_givegrenade(iParm[2])
{
	if(is_user_alive(iParm[0]) && is_user_connected(iParm[0]))
	{
		if(iParm[1])
			iDwarfGrenades[iParm[0]][iParm[1]-1]++
			
		if(iParm[1] == 0)
		{
			give_item(iParm[0],"weapon_hegrenade")
			give_item(iParm[0],"weapon_flashbang")
		#if DWARF_SMOKE
			give_item(iParm[0],"weapon_smokegrenade")
		#endif		
		}
		else if(iParm[1] == 1)
			give_item(iParm[0],"weapon_hegrenade")
		else if(iParm[1] == 2)
			give_item(iParm[0],"weapon_flashbang")
		#if DWARF_SMOKE
		else if(iParm[1] == 3)
			give_item(iParm[0],"weapon_smokegrenade")
		#endif
	}

	return PLUGIN_CONTINUE
}

// DWARF_RELOADCMD
// ---------------
// This function runs a server-side only command to trigger the
// the dwarf_reload() function. We could technically do without
// this but its safer to do it this way.
stock dwarf_reloadcmd(id)
	server_cmd("dwarf_reload %d", id)
	
// DWARF_RELOAD
// ------------
// This function is triggered from CHANGE_WEAPON() when the player is
// a dwarf, has no more ammo, and has the extended ammunication skill.
// After doing some checking for valid reload time and weapons, it marks
// the weapon as reloaded and gives the extra ammo. If the weapon is already
// marked as reloaded, it does a settask to DWARF_RELOADDONE() to avoid
// infinite reloading.
//
// Special Note: For now, weapons that have less than 10 bullets in their
// clip, which is level 3 of extended ammunication, will be reduced to their
// max clip size. These are the Deagle and the shotguns.
//
public dwarf_reload()
{
	new sId[4]
	read_argv(1,sId,3)
	new id = str_to_num(sId)
	
	if(!is_user_connected(id)) return
	if(iDwarfReload[id] >= get_systime() - 1) return
		
	iDwarfReload[id] = get_systime()

	new iClip, iAmmo, sWpnName[32]
	new iWpnNum = get_user_weapon(id, iClip, iAmmo)
	
	if (iWpnNum != CSW_C4 && iWpnNum != CSW_KNIFE && iWpnNum != CSW_HEGRENADE && iWpnNum != CSW_SMOKEGRENADE && iWpnNum != CSW_FLASHBANG)
	{
		get_weaponname(iWpnNum,sWpnName,31)

		new iWpnIdx = -1
		while ((iWpnIdx = find_ent_by_class(iWpnIdx, sWpnName)) != 0)
		{
			if (id == entity_get_edict(iWpnIdx, EV_ENT_owner))
			{
				if(!bDwarfAmmo[id][iWpnNum])
				{
					bDwarfAmmo[id][iWpnNum] = true
					
					new iBPAmmo = cs_get_user_bpammo(id, iWpnNum)
					new iAddAmmo = p_ammoclip[p_skills[id][3]-1] 
					
					if(iBPAmmo > 0)
					{
						if((iWpnNum == CSW_DEAGLE || iWpnNum == CSW_XM1014) && iAddAmmo > 7)
							iAddAmmo = 7
						else if(iWpnNum == CSW_M3 && iAddAmmo >8)
							iAddAmmo = 8
							
						if(iBPAmmo < iAddAmmo)
							iAddAmmo = iBPAmmo
						
						if(iAddAmmo > 0)
						{
							cs_set_user_bpammo(id, iWpnNum, iBPAmmo-iAddAmmo)
							cs_set_weapon_ammo(iWpnIdx, iAddAmmo)
						}
					}
				}
				else
				{
					new iParm[3]
					iParm[0] = id
					iParm[1] = iWpnNum
					iParm[2] = iWpnIdx
					
					set_task(0.5,"dwarf_reloaddone",3300+id,iParm,3)					
				}
				break
			}
		}
	}
}

// DWARF_RELOADDONE
// ----------------
// This function is settask called from DWARF_RELOAD. It checks the
// player's weapon clip in order to determine if a normal reload has
// occured, then resets that weapon so it can get extra ammo again.
//
// iParm[0] is the player id. iParm[1] is the weapon id. iParm[2] is
// the weapon index.
//
public dwarf_reloaddone(iParm[3])
{
	if(is_user_connected(iParm[0]) && bDwarfAmmo[iParm[0]] && is_valid_ent (iParm[2]))
	{
		new iGunAmmo = cs_get_weapon_ammo(iParm[2])
		new iBPAmmo = cs_get_user_bpammo(iParm[0], iParm[1])
	
		if(!is_user_alive(iParm[0]) || iBPAmmo == 0)
			bDwarfAmmo[iParm[0]][iParm[1]] = false
		else if((iParm[1] == CSW_XM1014 && iGunAmmo > 6) || (iParm[1] == CSW_M3 && iGunAmmo > 7))
			bDwarfAmmo[iParm[0]][iParm[1]] = false
		else if(iParm[1] != CSW_XM1014 && iParm[1] != CSW_M3 && iGunAmmo > 0)
			bDwarfAmmo[iParm[0]][iParm[1]] = false
		else
			set_task(0.5,"dwarf_reloaddone",3300+iParm[0],iParm,3)
	}
	
	return PLUGIN_CONTINUE
}

// DWARF_ENDAVATAR
// ---------------
// This function removes the Avatar ultimate from Dwarf Players.
//
// iParm[0] is the player id.
//
public dwarf_endavatar(iParm[2])
{
	remove_task(4400+iParm[0])
	bDwarfAvatar[iParm[0]] = false
	
	if(iDwarfAvatarHP[iParm[0]] > 100+(playeritem[iParm[0]]==HEALTH ? HEALTHBONUS : 0))
		iDwarfAvatarHP[iParm[0]] = 100+(playeritem[iParm[0]]==HEALTH ? HEALTHBONUS : 0)
		
	set_user_health(iParm[0],iDwarfAvatarHP[iParm[0]])
	
	if (iglow[iParm[0]][0] > 1 || iglow[iParm[0]][1] > 1 || iglow[iParm[0]][2] > 1)
	{
		new iGlowParm[2]
		iGlowParm[0] = iParm[0]
		set_task(0.1,"glow_change",8,iGlowParm,2)
	}
			
	iglow[iParm[0]][0] = 0
	iglow[iParm[0]][1] = 0
	iglow[iParm[0]][2] = 0
	iglow[iParm[0]][3] = 0
	
	return PLUGIN_CONTINUE
}

// LICH_FROSTNOVA
// --------------
// This function handles finding the valid targets for the Frostnova
// ultimate and triggering a few effects.
//
// iParm[0] is player id.
//
public lich_frostnova(iParm[2])
{
	new iOrigin[3]
	get_user_origin(iParm[0],iOrigin)
	
	new iPlayers[MAX_PLAYERS], iNumPlayers
	get_players(iPlayers,iNumPlayers)

	new i, iTarget, iDistance, iTargetOrigin[3]

	for (i = 0; i < iNumPlayers; ++i)
	{
		iTarget = iPlayers[i]
		get_user_origin(iTarget,iTargetOrigin)
		
		iDistance = get_distance(iOrigin,iTargetOrigin)
		
		if(iDistance < FROSTNOVA_RANGE && get_user_team(iParm[0]) != get_user_team(iTarget) && playeritem[iTarget] != IMMUNITY && iParm[0] != iTarget)
		{
		
			bFrostNova[iTarget] = true
			speed_controller(iTarget)
			
			new iFParm[2]; iFParm[0] = iTarget; iFParm[1] = 4
			set_task(FROSTNOVA_DURATION,"speed_reset",9900+iTarget,iFParm,2)			

			if (iglow[iTarget][0] < 1 || iglow[iTarget][1] < 1 || iglow[iTarget][2] < 1)
			{
				new iGlowParm[2]
				iGlowParm[0] = iTarget
				set_task(0.1,"glow_change",8,iGlowParm,2)
			}
			
			iglow[iTarget][0] = 50
			iglow[iTarget][1] = 50
			iglow[iTarget][2] = 150
			iglow[iTarget][3] = 0
							
			message_begin(MSG_ONE,gmsgFade,{0,0,0},iTarget)
			write_short( 1<<6 ) // fade lasts this long duration
			write_short( 1<<6 ) // fade lasts this long hold time
			write_short( 1<<12 ) // fade type (in / out)
			write_byte( 100 ) // fade red
			write_byte( 100 ) // fade green
			write_byte( 255 ) // fade blue
			write_byte( 150 ) // fade alpha
			message_end()

		}
	}

	--iParm[1]
	if (iParm[1]>0)
		set_task(0.1,"frostnova",33,iParm,2)
	else
	{
		new cooldownparm[1]
		cooldownparm[0]=iParm[0]
		set_task(FROSTNOVA_COOLDOWN,"cooldown",50+iParm[0],cooldownparm,1)
	}
		
	return PLUGIN_CONTINUE
}

// LICH_FROSTNOVA_BLAST
// --------------------
// Make some pretty effects
//
// iParm[0] is the lich player's id.
public lich_frostnova_blast(iParm[2])
{
	new iOrigin[3]
	get_user_origin(iParm[0],iOrigin)

	// blast circles
	message_begin( MSG_PAS, SVC_TEMPENTITY, iOrigin )
	write_byte( TE_BEAMCYLINDER )
	write_coord( iOrigin[0])
	write_coord( iOrigin[1])
	write_coord( iOrigin[2] - 16)
	write_coord( iOrigin[0])
	write_coord( iOrigin[1])
	write_coord( iOrigin[2] - 16 + BLASTCIRCLES_RADIUS)
	write_short( m_iSpriteTexture )
	write_byte( 0 ) // startframe
	write_byte( 0 ) // framerate
	write_byte( 6 ) // life
	write_byte( 16 )  // width
	write_byte( 0 )	// noise
	write_byte( 100 )
	write_byte( 100 )
	write_byte( 255 )
	write_byte( 255 ) //brightness
	write_byte( 0 ) // speed
	message_end()

	message_begin( MSG_PAS, SVC_TEMPENTITY, iOrigin )
	write_byte( TE_BEAMCYLINDER )
	write_coord( iOrigin[0])
	write_coord( iOrigin[1])
	write_coord( iOrigin[2] - 16)
	write_coord( iOrigin[0])
	write_coord( iOrigin[1])
	write_coord( iOrigin[2] - 16 + ( BLASTCIRCLES_RADIUS / 2 ))
	write_short( m_iSpriteTexture )
	write_byte( 0 ) // startframe
	write_byte( 0 ) // framerate
	write_byte( 6 ) // life
	write_byte( 16 )  // width
	write_byte( 0 )	// noise
	write_byte( 100 )
	write_byte( 100 )
	write_byte( 255 )
	write_byte( 255 ) //brightness
	write_byte( 0 ) // speed
	message_end()

	return PLUGIN_CONTINUE
}
#endif


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
				new players[MAX_PLAYERS]
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
		if (is_user_alive(id) && is_user_alive(targetid) && get_user_maxspeed(id)>10 && get_user_team(id)==get_user_team(targetid) && key!=9 && !ultimateused[id] && !gRoundOver){
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
			new resetparm[2]
			resetparm[0]=id
			resetparm[1]=1
			set_task(0.6,"speed_reset",600+id,resetparm,2)
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
		new players[MAX_PLAYERS]
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
	if ( enemy != 0 && is_user_connected(enemy) && !bEntangled[enemy] && get_user_team(id)!=get_user_team(enemy) && playeritem[enemy]!=IMMUNITY){
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

		
		new waitparm[5]
		waitparm[0]=enemy
		waitparm[1]=100
		bEntangled[enemy] = true
		speed_controller(enemy)
		waitstop(waitparm)
		#if NIGHTELF_DROPWEAPON
			new wpname[32]
			new ammo, clip, wpid = get_user_weapon(enemy,clip,ammo)
			get_weaponname(wpid,wpname,31)
			client_cmd(enemy,"drop",wpname)
		#endif
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
		}
		#if EXPANDED_RACES
		else if( p_skills[id][0] == 5 ){
			write_string( "dmg_poison" ) // blood elf sprite name
		}else if( p_skills[id][0] == 6 ){
			write_string( "dmg_bio" ) // troll sprite name
		}else if( p_skills[id][0] == 7 ){
			write_string( "dmg_shock" ) // dwarf sprite name
		}else if( p_skills[id][0] == 8 ){
			write_string( "dmg_poison" ) // lich sprite name
		}
		#endif
		write_byte( r ) // red 
		write_byte( g ) // green 
		write_byte( b ) // blue 
		message_end() 	
	
		return PLUGIN_CONTINUE
	}
#endif

public waitstop(parm[5]){ // just a note, this looks like NE code -ferret
	new id=parm[0]
	new origin[3]
	get_user_origin(id, origin)
	
	// This check is necessary, because we don't want to draw rings until the player hits ground
	if (origin[0]==parm[2] && origin[1]==parm[3] && origin[2]==parm[4]){
		new resetparm[2]
		resetparm[0]=id
		resetparm[1]=5
		set_task(10.0,"speed_reset",650+id,resetparm,2)
		new entangleparm[2]
		entangleparm[0]=parm[0]
		entangleparm[1]=parm[1]
		entangle(entangleparm)
	}
	else{
		parm[2]=origin[0]
		parm[3]=origin[1]
		parm[4]=origin[2]
		set_task(0.1,"waitstop",23,parm,5)
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
	if(is_user_connected(enemy) && get_user_team(id)!=get_user_team(enemy) && playeritem[enemy]!=IMMUNITY){
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
	new players[MAX_PLAYERS]
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

	if(closestid && is_user_connected(targetid)){
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

	if(!is_user_connected(targetid)) return PLUGIN_CONTINUE

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
			#if EXPANDED_RACES
			}else if( p_skills[id][0] == 5 ){
				icon_controller(id, 1, 255, 0, 0 ) 			
			}else if( p_skills[id][0] == 6 ){
				icon_controller(id, 1, 0, 255, 100 ) 			
			}else if( p_skills[id][0] == 7 ){
				icon_controller(id, 1, 255, 255, 0 ) 			
			}else if( p_skills[id][0] == 8 ){
				icon_controller(id, 1, 55, 55, 255 ) 			
			#endif
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

	new players[MAX_PLAYERS]
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
	write_byte( 255 )
	write_byte( 100 )
	write_byte( 0 )
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
	write_byte( 255 )
	write_byte( 100 )
	write_byte( 0 )
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

public client_connect(id)
{
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
	playeritem[id] = 0
	p_spectator[id] = false
	#if !SHORT_TERM
		if (is_user_bot(id) && saved_xp){
			playerxp[id]= xplevel[floatround(random_float(0.0,3.16)*random_float(0.0,3.16))]
			p_skills[id][0] = random_num(1,4)
			return PLUGIN_CONTINUE
		}
	#endif
	
	savednumber[id] = 0
	armorondeath[id] = 0
	diedlastround[id] = false
	for(new j=0; j < 32; j++)
		savedweapons[id][j] = 0

	gWpnUsed[id] = 0
	showicons[id]=true
	
	return PLUGIN_CONTINUE
}

#if !SHORT_TERM
public client_disconnected(id)
{ 
	if (saved_xp && !is_user_bot(id) && p_skills[id][0] && playerxp[id]){
		write_xp_to_file(id, "")
	}
	
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
	new players[MAX_PLAYERS], inum
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

public armor_type(id){ // ferret- this might be useful
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	if (read_data(1))
		helmet[id]=true
	else
		helmet[id]=false
	return PLUGIN_CONTINUE
}

public say_changerace(id)
{
	change_race(id,1)
	return PLUGIN_CONTINUE
}

public say_selectskill(id)
{
	select_skill(id,1)
	return PLUGIN_CONTINUE
}

public say_playerskills(id)
{
	player_skills(id,1)
	return PLUGIN_CONTINUE
}

public say_skillsinfo(id)
{
	skills_info(id,1)
	return PLUGIN_CONTINUE
}

public say_war3vote(id)
{
	war3_vote(id,1)
	return PLUGIN_CONTINUE
}

public say_itemsinfo(id)
{
	items_info(id,1)
	return PLUGIN_CONTINUE
}

public display_race_select(){
	new id, idtext[3], menu_msg[384]
	
	new racexp1[8], racexp2[8], racexp3[8], racexp4[8]
	read_argv(1,idtext,2)
	read_argv(2,racexp1,7)
	read_argv(3,racexp2,7)
	read_argv(4,racexp3,7)
	read_argv(5,racexp4,7)
	#if EXPANDED_RACES
	new racexp5[8], racexp6[8], racexp7[8], racexp8[8]
	read_argv(6,racexp5,7)
	read_argv(7,racexp6,7)
	read_argv(8,racexp7,7)
	read_argv(9,racexp8,7)
	#endif 

	id = str_to_num(idtext)
	#if !EXPANDED_RACES
	#if LANG_ENG
		format(menu_msg,255,"\ySelect Race:\RExperience^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n^n\
			\w5. Auto-select", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4)
	#endif
	#if LANG_GER
		format(menu_msg,255,"\yWaehle eine Rasse:\RErfahrung^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n^n\
			\w5. Auto-Auswahl", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4)
	#endif
	#if LANG_FRE
		format(menu_msg,255,"\yChoisi ta Race:\RExperience^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n^n\
			\w5. Selection Automtique", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4)
	#endif	
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),menu_msg,-1)
	#else
	#if LANG_ENG
		format(menu_msg,383,"\ySelect Race:\RExperience^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n\w5. %s\y\R%s^n\w6. %s\y\R%s^n\w7. %s\y\R%s^n\w8. %s\y\R%s^n^n\
			\w9. Auto-select", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4, racename[5], racexp5, racename[6], racexp6, racename[7], racexp7, racename[8], racexp8)
	#endif
	#if LANG_GER
		format(menu_msg,383,"\yWaehle eine Rasse:\RErfahrung^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n\w5. %s\y\R%s^n\w6. %s\y\R%s^n\w7. %s\y\R%s^n\w8. %s\y\R%s^n^n\
			\w9. Auto-Auswahl", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4, racename[5], racexp5, racename[6], racexp6, racename[7], racexp7, racename[8], racexp8)
	#endif
	#if LANG_FRE
		format(menu_msg,383,"\yChoisi ta Race:\RExperience^n^n\w1. %s\y\R%s^n\w2. %s\y\R%s^n\w3. %s\y\R%s^n\w4. %s\y\R%s^n\w5. %s\y\R%s^n\w6. %s\y\R%s^n\w7. %s\y\R%s^n\w8. %s\y\R%s^n^n\
			\w9. Selection Automtique", racename[1], racexp1, racename[2], racexp2, racename[3], racexp3, racename[4], racexp4, racename[5], racexp5, racename[6], racexp6, racename[7], racexp7, racename[8], racexp8)
	#endif	
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8),menu_msg,-1)
	#endif
	
	return PLUGIN_HANDLED
}

public save_xp_info(id){
	if( get_cvar_num("mp_savexp") ){
		#if MYSQL_ENABLED || VAULT_SAVE
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
		
		set_msg_block(gmsgDeathMsg,BLOCK_NOT)
	}
	else{
		warcraft3=true
		set_msg_block(gmsgDeathMsg,BLOCK_SET)	
	}
	return PLUGIN_CONTINUE
}

#if !SHORT_TERM

public write_all(){
	if (warcraft3 && saved_xp){
		new players[MAX_PLAYERS], numofplayers, id
		get_players(players, numofplayers)
		#if MYSQL_ENABLED
			if (iSQLtype == SQL_MYSQL) {
				#if SQL_DEBUG
					log_amx("[WC3] dbi_query(%d, 'SET AUTOCOMMIT=0')", mysql)
				#endif
				res = dbi_query(mysql, "SET AUTOCOMMIT=0")
				dbi_check_error(res)
				#if SQL_DEBUG
					log_amx("[WC3] dbi_query(%d, 'START TRANSACTION')", mysql)
				#endif
				res = dbi_query(mysql, "START TRANSACTION")
				dbi_check_error(res)
			} else if (iSQLtype == SQL_SQLITE) {
				#if SQL_DEBUG
					log_amx("[WC3] dbi_query(%d, 'BEGIN TRANSACTION')", mysql)
				#endif
				res = dbi_query(mysql, "BEGIN TRANSACTION")
				dbi_check_error(res)
			}
		#endif
		for (new i=0; i<numofplayers; i++){
			id = players[i]
			if (p_skills[id][0] && playerxp[id])
				write_xp_to_file(id,"")
		}
		#if MYSQL_ENABLED
			#if SQL_DEBUG
				log_amx("[WC3] dbi_query(%d, 'COMMIT')", mysql)
			#endif
			res = dbi_query(mysql, "COMMIT")
			dbi_check_error(res)
		#endif
	}
	
	return PLUGIN_CONTINUE
}

public write_xp_to_file(id,givenline[128]){
	if (is_user_bot(id) || !saved_xp)
		return PLUGIN_CONTINUE

	new playerid[MAX_ID_LENGTH], playername[MAX_NAME_LENGTH]

	#if !MYSQL_ENABLED
		new currentrace[2]
	#endif
	
	if (id){
		get_user_name(id,playername,MAX_NAME_LENGTH-1)

		#if !MYSQL_ENABLED
			format(currentrace,1,"%d",p_skills[id][0])
		#endif

		#if SAVE_WITH_IP
			get_user_ip(id,playerid,MAX_ID_LENGTH-1,0)
		#else
			get_user_authid(id,playerid,MAX_ID_LENGTH-1)		// by AUTHID (Steam Users)
		#endif
	}

	#if MYSQL_ENABLED
		new mquery[1024]
		
		if( contain(playername,"'") != -1 ){
			format(playername,31, "bad_name_quote")
//			while(containi(playername,"'") != -1) replace(playername,32,"'","\'") 
		}else if( contain(playername,"!") != -1 ){
			format(playername,31, "bad_name_exclaim")
//			while(containi(playername,"!") != -1) replace(playername,32,"!","\!") 			
		}			
			
		format(mquery, 1023, "REPLACE INTO `%s` (`playerid`, `playername`, `xp`, `race`, `skill1`, `skill2`, `skill3`, `skill4`) \
			VALUES ('%s', '%s', %d, %d, %d, %d, %d, %d)", mysqltablename, playerid, playername, playerxp[id], p_skills[id][0], \
			p_skills[id][1], p_skills[id][2], p_skills[id][3], p_skills[id][4])
		//console_print(0,"%s\n", mquery)
		#if SQL_DEBUG
			log_amx("[WC3] dbi_query(%d, %s)", mysql, mquery)
		#endif
		res = dbi_query(mysql,mquery)
		dbi_check_error(res)
	#else
		if (id && playerxp[id] && p_skills[id][0])
		{
			new vaultkey[64], vaultdata[128], index[32]
			format(vaultkey, 63, "WC3_%s_%s", playerid, currentrace)
			format(vaultdata, 127, "%d %d %d %d %d %d",playerxp[id],p_skills[id][0],
				p_skills[id][1],p_skills[id][2],p_skills[id][3],p_skills[id][4])
			set_vaultdata(vaultkey,vaultdata)
						
			// Prune Information Setup
			format(vaultkey, 63,"WC3_%s",playerid)							
			
                        if(!vaultdata_exists(vaultkey))
                        {
                                get_vaultdata("WC3_war3index", index, 31);
                                format(vaultdata,127,"%d ^"%s^" %d",str_to_num(index),playername,get_systime())
                                set_vaultdata(vaultkey,vaultdata)
                                format(vaultkey,63,"WC3_pruneindex_%d",str_to_num(index))
                                set_vaultdata(vaultkey,playerid)
                                format(index,31,"%d",(str_to_num(index)+1))
                                set_vaultdata("WC3_war3index",index)
                        }
                        else
                        {
                                get_vaultdata(vaultkey,vaultdata,127)
                                parse(vaultdata,index,31)
                                format(vaultdata,127,"%d ^"%s^" %d",str_to_num(index),playername,get_systime())
                                set_vaultdata(vaultkey,vaultdata)
                        }
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
	#endif

	new playerid[MAX_ID_LENGTH], playername[MAX_NAME_LENGTH]
	new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
	#if !EXPANDED_RACES
		new racexp[4]={0,0,0,0}
	#else
		new racexp[8]={0,0,0,0,0,0,0,0}
	#endif

	get_user_name(id,playername,MAX_NAME_LENGTH-1)

	#if SAVE_WITH_IP
		get_user_ip(id,playerid,MAX_ID_LENGTH-1,0)
	#else
		get_user_authid(id,playerid,MAX_ID_LENGTH-1)
	#endif
	#if MYSQL_ENABLED
		if (returnrace)
		{
			if (get_cvar_num("mp_savebyname")==1)
				format(mquery, 1023, "SELECT `xp`, `race` FROM `%s` WHERE (`playername` = '%s')",mysqltablename,playername)
			else
				format(mquery, 1023, "SELECT `xp`, `race` FROM `%s` WHERE (`playerid` = '%s')",mysqltablename,playerid)

			#if SQL_DEBUG
				log_amx("[WC3] dbi_query(%d, %s)", mysql, mquery)
			#endif
			res = dbi_query(mysql,mquery)
			dbi_check_error(res)

			if (res > RESULT_NONE) 
			{
				while (dbi_nextrow(res))
				{
					dbi_field(res,1,xp,7)
					dbi_field(res,2,race,1)
					#if !EXPANDED_RACES
					if (str_to_num(race)>=1 && str_to_num(race)<=4)
					#else
					if (str_to_num(race)>=1 && str_to_num(race)<=8)
					#endif
						racexp[str_to_num(race)-1] = str_to_num(xp)
				}
				dbi_free_result(res)
			}

			if (p_skills[id][0])
				racexp[p_skills[id][0]-1]=playerxp[id]
			#if !EXPANDED_RACES
			server_cmd("display_race_select %d %d %d %d %d",id, racexp[0], racexp[1], racexp[2], racexp[3])
			#else
			server_cmd("display_race_select %d %d %d %d %d %d %d %d %d",id, racexp[0], racexp[1], racexp[2], racexp[3], racexp[4],racexp[5],racexp[6],racexp[7])
			#endif
		}
		else
		{
			if (get_cvar_num("mp_savebyname")==1)
				format(mquery, 1023, "SELECT `xp`, `skill1`, `skill2`, `skill3`, `skill4` FROM `%s` WHERE (`playername` = '%s' AND `race` = %d)",mysqltablename,playername,p_skills[id][0])
			else
				format(mquery, 1023, "SELECT `xp`, `skill1`, `skill2`, `skill3`, `skill4` FROM `%s` WHERE (`playerid` = '%s' AND `race` = %d)",mysqltablename,playerid,p_skills[id][0])

			#if SQL_DEBUG
				log_amx("[WC3] dbi_query(%d, %s)", mysql, mquery)
			#endif
			res = dbi_query(mysql,mquery)
			dbi_check_error(res)

			if (res > RESULT_NONE) {
				if (dbi_nextrow(res)) {
					dbi_field(res,1,xp,7)
					dbi_field(res,2,skill1,1)
					dbi_field(res,3,skill2,1)
					dbi_field(res,4,skill3,1)
					dbi_field(res,5,skill4,1)

					playerxp[id]=str_to_num(xp)
					p_skills[id][1]=str_to_num(skill1)
					p_skills[id][2]=str_to_num(skill2)
					p_skills[id][3]=str_to_num(skill3)
					p_skills[id][4]=str_to_num(skill4)
					displaylevel(id,0)
				}
				dbi_free_result(res)
			}
			else{
				playerxp[id]=0
				p_skills[id][1]=0
				p_skills[id][2]=0
				p_skills[id][3]=0
				p_skills[id][4]=0
				displaylevel(id,0)
			}
		}
	#else
		new vaultkey[64], vaultdata[128], currentrace[2]
		format(currentrace,1,"%d",p_skills[id][0])
				
		if(returnrace)
		{		
			#if !EXPANDED_RACES
			for(new i=1;i < 5; i++)
			#else
			for(new i=1;i < 9; i++)
			#endif
			{
			
				format(vaultkey, 63, "WC3_%s_%d", playerid, i)
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
				#if !EXPANDED_RACES
				server_cmd("display_race_select %d %d %d %d %d",id, racexp[0], racexp[1], racexp[2], racexp[3])
				#else
				server_cmd("display_race_select %d %d %d %d %d %d %d %d %d",id, racexp[0], racexp[1], racexp[2], racexp[3], racexp[4], racexp[5], racexp[6], racexp[7])
				#endif
			}			
		}
		else
		{
			format(vaultkey, 63, "WC3_%s_%s", playerid, currentrace)
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
	#endif
	
	return PLUGIN_CONTINUE
}

#if MYSQL_ENABLED
	public set_mysql(){
		new filename[32] = "war3mysql.ini"
		new nextline=0, textlength
	
		get_cvar_string("sv_mysqltablename",mysqltablename,63)		
		new mhost[64], muser[32], mpass[32], mdb[128], int_check[64]
		new merror[256]
		new mquery[512]

		dbi_type(SQLtype, 15)
		#if SQL_DEBUG
			log_amx("[WC3] dbi_type: %s", SQLtype)
		#endif

		if (equali(SQLtype, g_MySQL)) {
			iSQLtype = SQL_MYSQL
			copy(SQLtype, strlen(g_MySQL)+1, g_MySQL)
		} else if (equali(SQLtype, g_SQLite)) {
			iSQLtype = SQL_SQLITE
			copy(SQLtype, strlen(g_SQLite)+1, g_SQLite)
		} else {
			iSQLtype = SQL_NONE
			log_amx("[WC3] Unsupported database type found (%s), the supported databases are %s or %s", SQLtype, g_MySQL, g_SQLite)
			return PLUGIN_CONTINUE
		}
		#if SQL_DEBUG
			log_amx("[WC3] iSQLtype = %d, SQLtype = %s", iSQLtype, SQLtype)
		#endif

		if (iSQLtype == SQL_MYSQL)
			format(mquery, 511, "CREATE TABLE IF NOT EXISTS `%s` (`playerid` VARCHAR(35) NOT NULL DEFAULT '', \
				`playername` VARCHAR(35) NOT NULL DEFAULT '', `xp` INT(11) NOT NULL DEFAULT 0, \
				`race` TINYINT(4) NOT NULL DEFAULT 0, `skill1` TINYINT(4) NOT NULL DEFAULT 0, \
				`skill2` TINYINT(4) NOT NULL DEFAULT 0, `skill3` TINYINT(4) NOT NULL DEFAULT 0, \
				`skill4` TINYINT(4) NOT NULL DEFAULT 0, `time` TIMESTAMP(14) NOT NULL, PRIMARY KEY (`playerid`, `race`))", \
				mysqltablename)
		else if (iSQLtype == SQL_SQLITE)
			format(mquery, 511, "CREATE TABLE `%s` (`playerid` VARCHAR(35) NOT NULL DEFAULT '', \
				`playername` VARCHAR(35) NOT NULL DEFAULT '', `xp` INT(11) NOT NULL DEFAULT 0, \
				`race` TINYINT(4) NOT NULL DEFAULT 0, `skill1` TINYINT(4) NOT NULL DEFAULT 0, \
				`skill2` TINYINT(4) NOT NULL DEFAULT 0, `skill3` TINYINT(4) NOT NULL DEFAULT 0, \
				`skill4` TINYINT(4) NOT NULL DEFAULT 0, `time` TIMESTAMP(14) NOT NULL DEFAULT CURRENT_TIMESTAMP, \
				PRIMARY KEY (`playerid`, `race`))", mysqltablename)

		if (file_exists(filename)){
			nextline = read_file(filename,nextline,mhost,63,textlength)
			nextline = read_file(filename,nextline,muser,31,textlength)
			nextline = read_file(filename,nextline,mpass,31,textlength)
			nextline = read_file(filename,nextline,mdb,127,textlength)
		}
		else{	
			server_cmd("exec %s", PATHTOMYSQLCFG)
			get_cvar_string("amx_sql_host",mhost,63)
			get_cvar_string("amx_sql_user",muser,31)
			get_cvar_string("amx_sql_pass",mpass,31)
			get_cvar_string("amx_sql_db",mdb,127)
		}

		#if SQL_DEBUG
			log_amx("[WC3] dbi_connect(%s, %s, %s, %s, %s, %d)", mhost, muser, mpass, mdb, merror, 256)
		#endif
		mysql = dbi_connect(mhost,muser,mpass,mdb,merror,256)
		#if SQL_DEBUG
			log_amx("[WC3] mysql=%d", mysql)
		#endif

		if (merror[0]) 
		{
			server_print("MYSQL Error Connect: %s", merror)
		} 

		if (iSQLtype != SQL_SQLITE || !sqlite_table_exists(mysql, mysqltablename)) {
			#if SQL_DEBUG
				log_amx("[WC3] dbi_query(%d, %s)", mysql, mquery)
			#endif
			res = dbi_query(mysql,mquery)
			dbi_check_error(res)
		}

		if (iSQLtype == SQL_SQLITE) {
		/*
			PRAGMA commands don't return anything so no need to check the result of the query

			Lets fine tune the database:
				"integrity_check"	- well it's what it says, we do have to check the value it
							  returns since it's important
		 		"synchronous = NORMAL"	- Put back the 2.x behaviour (faster than the defalt for 3.x)
				"synchronous = OFF"	- Way faster, but it might get corrupted data if a server os
							  system crash occurs
		 */
			format(mquery, 511, "PRAGMA integrity_check")
			#if SQL_DEBUG
				log_amx("[WC3] dbi_query(%d, %s)", mysql, mquery)
			#endif
			res = dbi_query(mysql, mquery)
			dbi_check_error(res)

			while (res && dbi_nextrow(res)>0) {
				dbi_result(res, "integrity_check", int_check, 63)
			}

			dbi_free_result(res)
			#if SQL_DEBUG
				log_amx("[WC3] int_check=%s", int_check)
			#endif

			if (!equali(int_check, "ok")) {
				log_amx("[WC3] Database integrity check failed with code: %s", int_check)
				return PLUGIN_HANDLED
			}

			format(mquery, 511, "PRAGMA synchronous = %d", SQLITE_SYNC_OFF)
			#if SQL_DEBUG
				log_amx("[WC3] dbi_query(%d, %s)", mysql, mquery)
			#endif
			res = dbi_query(mysql, mquery)
			dbi_check_error(res)
		}
		return PLUGIN_CONTINUE
	}

	public dbi_check_error(Result:Res){
		new merror[256]

		#if SQL_DEBUG
			log_amx("[WC3] res = %d", Res)
		#endif

		if (Res == RESULT_FAILED) {
			dbi_error(mysql,merror,255)
			#if SQL_DEBUG
				log_amx("[WC3] dbi_error(%d, %s, %d)", mysql, merror, strlen(merror))
			#endif
			server_print("[WC3] MYSQL Error Query: %s", merror)
			dbi_close(mysql)
			return PLUGIN_HANDLED
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
		#endif

		#if MYSQL_AUTO_PRUNING
			new currentHour[3]  
			new currentMin[3]      			
			
			get_time("%H",currentHour,2)
			get_time("%M",currentMin,2)
			
			// At 5:36 AM until 5:59 AM a mapchange will trigger an auto-prune.
			if( (str_to_num( currentHour) == 5) && (str_to_num( currentMin) > 35 ) ){
				if (iSQLtype == SQL_MYSQL) {
					// Timestamp format: 20030912122142
					// Y = 2003 M = 09 D = 12 H = 12 M = 21 S = 42	
					format(mquery, 1023, "DELETE FROM `%s` WHERE `time` + %d < now()", mysqltablename, DAYS_BEFORE_DELETE * 1000000)
				} else if (iSQLtype == SQL_SQLITE) {
					// Timestamp format: 2003-09-12 12:21:42
					// Y = 2003 M = 09 D = 12 H = 12 M = 21 S = 42
					format(mquery, 1023, "DELETE FROM `%s` WHERE ((julianday(`time`) + %d) < julianday('now'))", mysqltablename, DAYS_BEFORE_DELETE)
				}
				//console_print(0,mquery)			
				#if SQL_DEBUG
					log_amx("[WC3] dbi_query(%d, %s)", mysql, mquery)
				#endif
				res = dbi_query(mysql,mquery)
				dbi_check_error(res)

				if (iSQLtype == SQL_SQLITE) {
					format(mquery, 1023, "VACUUM `%s`", mysqltablename)
					#if SQL_DEBUG
						log_amx("[WC3] dbi_query(%d, %s)", mysql, mquery)
					#endif
					res = dbi_query(mysql, mquery)
					dbi_check_error(res)
				}
				log_amx("[WC3] The %s Database was successfully pruned %sat %s:%s", SQLtype, (iSQLtype == SQL_SQLITE) ? "and vacuumed " : "", currentHour, currentMin)
			}
		#endif
		dbi_close(mysql)
	#else
		write_all()
		
		// Prune Code follows
		new index, nIndex, strIndex[31], vaultkey[64], playerid[32], playername[MAX_NAME_LENGTH]
		new vaultdata[128], junk[32], stroldtime[32], nowtime, oldtime
		new bool:prunetime=false
		
		nowtime = get_systime()

		get_vaultdata("WC3_prunedate",vaultdata,127)
		oldtime = str_to_num(vaultdata)
		if((nowtime-oldtime) > (VAULT_PRUNE_LIMIT*86400))
		{
			prunetime=true
			format(junk,31,"%d",nowtime)
			set_vaultdata("WC3_prunedate",junk)
		}

		get_vaultdata("WC3_war3index",vaultdata,127)
		nIndex = str_to_num(vaultdata)
		index = 1

		while(index < nIndex && prunetime)
		{
			format(vaultkey,63,"WC3_pruneindex_%d",index)
			if(vaultdata_exists(vaultkey))
			{	
				get_vaultdata(vaultkey,playerid,31)
				format(vaultkey, 63, "WC3_%s",playerid)
				get_vaultdata(vaultkey,vaultdata,127)
				parse(vaultdata,junk,31,playername,MAX_NAME_LENGTH-1,stroldtime,31)
				oldtime = str_to_num(stroldtime)

				if((nowtime-oldtime) > (DAYS_BEFORE_DELETE*86400))
				{	
					#if !EXPANDED_RACES
					for(new i=1;i < 5; i++)
					#else
					for(new i=1;i < 9; i++)
					#endif
					{
						format(vaultkey, 63, "WC3_%s_%d", playerid, i)
						remove_vaultdata(vaultkey)
					}
					format(vaultkey,63,"WC3_pruneindex_%d",index)
					remove_vaultdata(vaultkey)
					format(vaultkey,63,"WC3_%s",playerid)
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
					format(vaultkey,63,"WC3_pruneindex_%s",strIndex)
					get_vaultdata(vaultkey,playerid,31)
					remove_vaultdata(vaultkey)
					format(vaultkey,63,"WC3_pruneindex_%d",index)
					set_vaultdata(vaultkey,playerid)
					format(vaultkey,63,"WC3_%s",playerid)
					get_vaultdata(vaultkey,vaultdata,127)
					parse(vaultdata,junk,31,playername,MAX_NAME_LENGTH-1,stroldtime,31)				
					format(vaultdata,127,"%d ^"%s^" %s",index,playername,stroldtime)
					set_vaultdata(vaultkey,vaultdata)
					set_vaultdata("WC3_war3index",strIndex)
				}
				else
					set_vaultdata("WC3_war3index","1")
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
		 
		xpgiven = {6,8,10,12,14,16,20,24,28,32,40}
		xplevel = {0,100,200,400,800,1600,3200,6400,12800,25600,51200}
		for (new i=0; i<11; i++){			
			xplevel[i] =  floatround(xplevel[i] * xpmultiplier)			
		}
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
        NewItem = create_entity("info_target")

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

	emit_sound(NewItem, CHAN_WEAPON, "weapons/knife_slash2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM) 
	ident[0] = id
	set_task(0.3,"safedrop",2300+id,ident,1)

	if(playeritem[id] == HEALTH)
	{
		if(get_user_health(id) > HEALTHBONUS)
			set_user_health(id,get_user_health(id)-HEALTHBONUS)
		else
			set_user_health(id,1)
	}
	else if(playeritem[id] == BOOTS)
		set_user_maxspeed(id,gTrueSpeed[id])

	playeritem[id] = 0

	displaylevel(id, 1)
	
	return PLUGIN_HANDLED
}

public safedrop(ident[]) {
	canpickup[ident[0]] = true
	remove_task(1001+ident[0])
	return PLUGIN_HANDLED
}

public pfn_touch(ptr, ptd) {
	if (!ptr || !is_user_connected(ptd))
		return PLUGIN_CONTINUE
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
	new usermoney = cs_get_user_money(id) 
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
		#if XPLOIT_PROTECT						
			if( antiExploit )
			{
				cs_set_user_money(id,usermoney-itemcost[key],1)
				playerxp[id]+=XPBONUS	// Give XP bonus for buying Tome of Experience
			}
			else
				client_print(id,print_center,"There are too few players on the server. No XP given.")
		#else
			cs_set_user_money(id,usermoney-itemcost[key],1)
			playerxp[id]+=XPBONUS	// Give XP bonus for buying Tome of Experience
		#endif
	}
	else{
		cs_set_user_money(id,usermoney-itemcost[key],1)
		if (playeritem[id]==HEALTH)		// Remove health bonus after buying new item
			set_user_health(id,get_user_health(id)-HEALTHBONUS)
		playeritem[id]=key+1
		if (playeritem[id]==HEALTH)		// Give health bonus for buying periapt of health
			set_user_health(id,get_user_health(id)+HEALTHBONUS)
	}
	if (file_exists("sound/warcraft3/PickUpItem.wav")==1 && is_user_alive(id))
		emit_sound(id,CHAN_STATIC, "warcraft3/PickUpItem.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	displaylevel(id,1)
	return PLUGIN_HANDLED
}

public wc3_givexp(id,level,cid)
{
  	if(!cmd_access(id,level,cid,1)) return PLUGIN_HANDLED
	if(!warcraft3)
	{
		console_print(id,"[WC3] The Warcraft3 Mod is currently disabled.")
		return PLUGIN_HANDLED
	}
	
	new sArgPlayer[32]
	read_argv(1,sArgPlayer,31)
	new sArgAmount[32]
	read_argv(2,sArgAmount,31)

	new xp = str_to_num(sArgAmount)

	new player = cmd_target(id,sArgPlayer,2)
	if(!player) return PLUGIN_HANDLED
	
	new name[32]; get_user_name(player,name,31)
	new name2[32]; get_user_name(id,name2,31)
	playerxp[player] += xp
	displaylevel(player,1)
	console_print(id,"[WC3] You gave %d xp to %s.",xp,name)
		
	return PLUGIN_HANDLED
}

public wc3_menuMain(id)
{
        new pos = 0
        new menubody[512]
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<9)
	#if LANG_ENG
		new menuitems[3][]= {	"Commands",
					"Settings",
					"Help" }
		pos += format(menubody[pos], 511-pos, "\yWarCraft3 XP Menu^n^n")	
	#endif
	#if LANG_GER
		new menuitems[3][]= {	"Befehle",
					"Einstellungen",
					"Hilfe" }	
		pos += format(menubody[pos], 511-pos, "\yWarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menuitems[3][]= {	"Commande",
					"Arrangements",
					"Aide" }	
		pos += format(menubody[pos], 511-pos, "\yMenu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<3; i++)
	{
		pos += format(menubody[pos], 511-pos, "\w%d. %s^n",i+1,menuitems[i])
	}
	#if LANG_ENG
		pos += format(menubody[pos], 511-pos, "^n\w0. Exit")
	#endif
	#if LANG_GER
		pos += format(menubody[pos], 511-pos, "^n\w0. Schliessen")
	#endif
	#if LANG_FRE
		pos += format(menubody[pos], 511-pos, "^n\w0. Quitter")
	#endif	
        show_menu(id,keys,menubody,-1)
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
        new menubody[512]
        #if ITEMS_DROPABLE
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<9)
	#if LANG_ENG
		new menuitems[5][]= {	"Change Race",
					"Select Skills",
					"Player Skills",
					"Buy Item",
					"Drop Item" }
		pos += format(menubody[pos], 511-pos, "\yCommands - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menuitems[5][]= {	"Rasse wechseln",
					"Waehle Skills",
					"Spieler Skills",
					"Item kaufen",
					"Item fallenlassen" }
		pos += format(menubody[pos], 511-pos, "\yBefehle - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menuitems[5][]= {	"Changer de Race",
					"Choisis ta Competence",
					"Competences des Joueurs",
					"Menu d'Achat",
					"Drop Item" }	
		pos += format(menubody[pos], 511-pos, "\yCommande - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<5; i++)
	{
		pos += format(menubody[pos], 511-pos, "\w%d. %s^n",i+1,menuitems[i])
	}
	#else
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9)
	#if LANG_ENG
		new menuitems[4][]= {	"Change Race",
					"Select Skills",
					"Player Skills",
					"Shop Menu" }
		pos += format(menubody[pos], 511-pos, "\yCommands - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menuitems[4][]= {	"Rasse wechseln",
					"Waehle Skills",
					"Spieler Skills",
					"Shop Menue" }
		pos += format(menubody[pos], 511-pos, "\yBefehle - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menuitems[4][]= {	"Changer de Race",
					"Choisis ta Competence",
					"Competences des Joueurs",
					"Menu d'Achat" }	
		pos += format(menubody[pos], 511-pos, "\yCommande - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<4; i++)
	{
		pos += format(menubody[pos], 511-pos, "\w%d. %s^n",i+1,menuitems[i])
	}	
	#endif
	#if LANG_ENG
		pos += format(menubody[pos], 511-pos, "^n\w0. Exit")
	#endif
	#if LANG_GER
		pos += format(menubody[pos], 511-pos, "^n\w0. Schliessen")
	#endif
	#if LANG_FRE
		pos += format(menubody[pos], 511-pos, "^n\w0. Quitter")
	#endif	
        show_menu(id,keys,menubody,-1)
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
        new menubody[512]
        #if OPT_RESETSKILLS
	new keys = (1<<0)|(1<<1)|(1<<9)
	#if LANG_ENG
		new menuitems[2][]= {	"Toggle Icons",
					"Reset Skills" }
		pos += format(menubody[pos], 511-pos, "\ySettings - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menuitems[2][]= {	"Toggle Icons",
					"Reset Skills" }
		pos += format(menubody[pos], 511-pos, "\yEinstellungen - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menuitems[2][]= {	"Toggle Icons",
					"Annule les Competences" }	
		pos += format(menubody[pos], 511-pos, "\yArrangements - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<2; i++)
	{
		pos += format(menubody[pos], 511-pos, "\w%d. %s^n",i+1,menuitems[i])
	}
	#else
	new keys = (1<<0)|(1<<9)
	#if LANG_ENG
		new menuitems[1][]= {	"Toggle Icons" }
		pos += format(menubody[pos], 511-pos, "\ySettings - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menuitems[1][]= {	"Toggle Icons" }
		pos += format(menubody[pos], 511-pos, "\yEinstellungen - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menuitems[1][]= {	"Toggle Icons" }	
		pos += format(menubody[pos], 511-pos, "\yArrangements - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<1; i++)
	{
		pos += format(menubody[pos], 511-pos, "\w%d. %s^n",i+1,menuitems[i])
	}	
	#endif
	#if LANG_ENG
		pos += format(menubody[pos], 511-pos, "^n\w0. Exit")
	#endif
	#if LANG_GER
		pos += format(menubody[pos], 511-pos, "^n\w0. Schliessen")
	#endif
	#if LANG_FRE
		pos += format(menubody[pos], 511-pos, "^n\w0. Quitter")
	#endif	
        show_menu(id,keys,menubody,-1)
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
        new menubody[512]
	new keys = (1<<0)|(1<<1)|(1<<2)|(1<<9)
	#if LANG_ENG
		new menuitems[3][]= {	"War3 Help",
					"Skills Info",
					"Items Info" }
		pos += format(menubody[pos], 511-pos, "\yHelp - WarCraft3 XP Menu^n^n")
	#endif
	#if LANG_GER
		new menuitems[3][]= {	"War3 Hilfe",
					"Skills Info",
					"Items Info" }
		pos += format(menubody[pos], 511-pos, "\yHilfe - WarCraft3 XP Menue^n^n")
	#endif
	#if LANG_FRE
		new menuitems[3][]= {	"War3 Aide",
					"Info des Competences",
					"Info sur les Objets" }	
		pos += format(menubody[pos], 511-pos, "\yAide - Menu de WarCraft3 XP^n^n")
	#endif
	for (new i = 0; i<3; i++)
	{
		pos += format(menubody[pos], 511-pos, "\w%d. %s^n",i+1,menuitems[i])
	}
	#if LANG_ENG
		pos += format(menubody[pos], 511-pos, "^n\w0. Exit")
	#endif
	#if LANG_GER
		pos += format(menubody[pos], 511-pos, "^n\w0. Schliessen")
	#endif
	#if LANG_FRE
		pos += format(menubody[pos], 511-pos, "^n\w0. Quitter")
	#endif	
        show_menu(id,keys,menubody,-1)
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
		format(temp,511,"^nHealth: %d Armor: %d^nMoney: %d",health, get_user_armor(p_data), cs_get_user_money(p_data))
	#endif
	#if LANG_GER
		format(temp,511,"^nHealth: %d Armor: %d^nGeld: %d",health, get_user_armor(p_data), cs_get_user_money(p_data))
	#endif
	#if LANG_FRE
		format(temp,511,"^nVie: %d Armure: %d^nArgent: %d",health, get_user_armor(p_data), cs_get_user_money(p_data))
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

public changeXP()
{ 
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

//---- Borrowed from amx_gasnades --------------------------------------------------------------
/* Log a kill using standard HL-logging format */
stock logKill(attacker, victim, weaponDescription[] )
  {
    //Save Hummiliation
    new namea[MAX_NAME_LENGTH],namev[MAX_NAME_LENGTH],authida[MAX_ID_LENGTH],authidv[MAX_ID_LENGTH],teama[10],teamv[10]

    //Info On Attacker
    get_user_name(attacker,namea,MAX_NAME_LENGTH-1)
    get_user_team(attacker,teama,9)
    #if SAVE_WITH_IP
        get_user_ip(attacker,authida,MAX_ID_LENGTH-1,0)
    #else
        get_user_authid(attacker,authida,MAX_ID_LENGTH-1)
    #endif
    //Info On Victim
    get_user_name(victim,namev,MAX_NAME_LENGTH-1)
    get_user_team(victim,teamv,9)
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
      #if EXPANDED_RACES 
      // ferret note .. reusing icons right now
      case 5:  icon = race_5
      case 6:  icon = race_6 
      case 7:  icon = race_7
      case 8:  icon = race_8
      #endif
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
		entity_set_int(grenadeid, EV_INT_renderfx, kRenderFxGlowShell)
		entity_set_float(grenadeid, EV_FL_renderamt, 10.0)
		entity_set_vector(grenadeid, EV_VEC_rendercolor,Color)
	}
	#if ORC_SPAM_FIX
		console_print(id,"Entered Fix For Orc Nades")
		if(thrownorcnade[id]) {
			//make it so the grenade blows up in their face
			new Float:velocity[3]
			velocity[0] = 0.0
			velocity[1] = 0.0
			velocity[2] = 1.0
			entity_set_vector(grenadeid, EV_VEC_velocity, velocity)
			//if someone wants to change this so it casts entangle on them, that
			//might be a better way of doing this. When i tried entangle really quick
			//it didn't like me, so i did a quick fix of teleporting them
			//back to where they threw the grenade from
			new uorigin[3]
			get_user_origin(id, uorigin)
			new parme[4]
			parme[0] = id
			parme[1] = uorigin[0]
			parme[2] = uorigin[1]
			parme[3] = uorigin[2]
			set_task(1.0,"OrcSpamTeleport",id,parme,4);
		}
		thrownorcnade[id] = true
	#endif
}
public OrcSpamTeleport(parm[4]) {
	new location[3]
	location[0] = parm[1]
	location[1] = parm[2]
	location[2] = parm[3]
	set_user_origin(parm[0], location)
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

public plugin_precache() {
	g_sModelIndexFireball = precache_model("sprites/zerogxplode.spr")
	g_sModelIndexSmoke = precache_model("sprites/steam1.spr")
	m_iSpriteTexture = precache_model( "sprites/shockwave.spr")
	flaresprite = precache_model( "sprites/blueflare2.spr")
	iBeam4 = precache_model("sprites/zbeam4.spr")
	m_iTrail = precache_model("sprites/smoke.spr")
	lightning = precache_model("sprites/lgtning.spr")

	// ferret note - we need new sprites for new races
	if (get_cvar_num("sv_allowdownload")){
		race_1 = precache_model("sprites/warcraft3/i_undead.spr")
		race_2 = precache_model("sprites/warcraft3/i_human.spr")
		race_3 = precache_model("sprites/warcraft3/i_orc.spr")
		race_4 = precache_model("sprites/warcraft3/i_nightelf.spr")
		#if EXPANDED_RACES
		race_5 = precache_model("sprites/warcraft3/i_bloodelf.spr")
		race_6 = precache_model("sprites/warcraft3/i_troll.spr")
		race_7 = precache_model("sprites/warcraft3/i_dwarf.spr")
		race_8 = precache_model("sprites/warcraft3/i_lich.spr")
		#endif
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
	
	#if ITEMS_DROPABLE
                precache_model("models/rshell_big.mdl")
		precache_sound("weapons/knife_slash2.wav")
		precache_sound("items/equip_nvg.wav")
        #endif

	/* Some custom player models don't render transparent, let's make sure the client has the originals */
	/*
	// This is booting everybody off the server maybe AMX Mod X 1.5x problem or different server/client
	// models, commenting it o rof tunow
	force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/arctic/arctic.mdl")
	force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/gign/gign.mdl")
	force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/gsg9/gsg9.mdl")
	force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/guerilla/guerilla.mdl")
	force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/leet/leet.mdl")
	force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/sas/sas.mdl")
	force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/terror/terror.mdl")
	force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/urban/urban.mdl")
	force_unmodified(force_exactfile,{0,0,0},{0,0,0},"models/player/vip/vip.mdl")
	set_cvar_num("mp_consistency",1)
	server_print("[WC3] Forcing unmodified player models")
	*/

	#if SHORT_TERM
		server_print("[WC3] Using Engine Module, Short Term XP Modus")
        #else
		server_print("[WC3] Using Engine Module, Long Term XP Modus, saving xp to: Vault[%d] SQL[%d]",VAULT_SAVE,MYSQL_ENABLED)
        #endif

	return PLUGIN_CONTINUE
}

public set_team(id) {
  if (get_cvar_num("sv_wc3icons")){
    friend[id] = read_data(2)
  }
}

// ferret note - I've temporarily turned this off, all it does it return PLUGIN_HANDLED for now.
// It interfered with demo recording.
public cmdFullUpdate(id,level,cid){
	// console_print(id,"Usage of this command will get you killed")
	// 	if(cs_get_user_team(id) != 3 && is_user_alive(id) )
	//	user_kill (id) 
	return PLUGIN_HANDLED
}

public plugin_init()
{
	for( new i = 0; i < 33; i++ )
	{
		playeritem[i] = 0
		diedlastround[i]=false
		playerItemOld[i] = 0
	}

	
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

	new szAmxCvar[64]
	format( szAmxCvar, 63 , "%s %s", WAR3XP_PLUGINNAME, WAR3XP_VERSION )

	register_plugin("Warcraft 3 XP", WAR3XP_VERSION, "ferret (Dopefish/Spacedude)")
	register_cvar("Warcraft_3_XP", WAR3XP_VERSION, FCVAR_SERVER)
	register_cvar( "amx_war3_game", "war3xp", FCVAR_SERVER )
	register_cvar( "amx_war3_version", szAmxCvar, FCVAR_SERVER )
	register_cvar( "amx_war3_date", WAR3XP_DATE, FCVAR_SERVER )


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
		#if !EXPANDED_RACES
		register_menucmd(register_menuid("\ySelect Race:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),"set_race")
		#else
		register_menucmd(register_menuid("\ySelect Race:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<8),"set_race")
		#endif
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
        register_clcmd("war3menu","wc3_menuMain",-1,"- Show WarCraft3 XP Player menu")
	register_clcmd("say /war3menu","wc3_menuMain")
	register_clcmd("say_team /war3menu","wc3_menuMain")
	register_clcmd("changerace","change_race",-1,"changerace")	// mp_allowchangerace must be set to 1
	register_clcmd("say /changerace","say_changerace")
	register_clcmd("say_team /changerace", "say_changerace") 
	register_clcmd("selectskill","select_skill",-1,"selectskill")	// Use "selectskill" console command to lvl up
	register_clcmd("say /selectskill","say_selectskill")
	register_clcmd("say_team /selectskill","say_selectskill")
	register_concmd("playerskills","player_skills",-1,"playerskills")
	register_clcmd("say /playerskills","say_playerskills")
	register_clcmd("say_team /playerskills","say_playerskills")
	register_clcmd("skillsinfo","skills_info",-1,"skillsinfo")
	register_clcmd("say /skillsinfo","say_skillsinfo")
	register_clcmd("say_team /skillsinfo","say_skillsinfo")
	register_clcmd("itemsinfo","items_info",-1,"itemsinfo")
	register_clcmd("say /itemsinfo","say_itemsinfo")
	register_clcmd("say_team /itemsinfo","say_itemsinfo")
	register_clcmd("war3help","war3_info",-1,"war3help")	
	register_clcmd("say /war3help","war3_info")
	register_clcmd("say_team /war3help","war3_info")
	register_clcmd("savexp","save_xp_info",-1,"savexp")
	register_clcmd("say /savexp","save_xp_info")
	register_clcmd("say_team /savexp","save_xp_info")
	register_clcmd("war3vote","war3_vote",-1,"war3vote")
	register_clcmd("say /war3vote","say_war3vote")
	register_clcmd("say_team /war3vote","say_war3vote")
	register_clcmd("ultimate","ultimate",-1,"ultimate")
	register_clcmd("icons","icons",-1,"- Turn off race icons above teammates heads.")
	register_clcmd("say /icons","icons")
	register_clcmd("say_team /icons","icons")
	register_clcmd("shopmenu","shopmenu",-1,"shopmenu")
	register_clcmd("say /shopmenu","shopmenu")
	register_clcmd("say_team /shopmenu","shopmenu")
	register_clcmd("level","say_level",-1,"level")
	register_clcmd("say /level","say_level")
	register_clcmd("say_team /level","say_level")
	register_concmd("fullupdate","cmdFullUpdate",-1,"fullupdate")
	register_concmd("wc3_givexp","wc3_givexp",ADMIN_RCON,"<name or #userid> <xp>")
	register_srvcmd("display_race_select","display_race_select")		// For internal use only (don't use this this command)
	#if EXPANDED_RACES
	register_srvcmd("dwarf_reload", "dwarf_reload")				// Internal use only for dwarf ammo clip skill
	register_event("AmmoX","dwarf_grenade","b")				// This event handles giving new grenades out.
	#endif 
	#if ITEMS_DROPABLE
		register_clcmd("dropitem","wc3_dropitem",0,"")
	#endif

	register_srvcmd("wc3_changexp","changeXP")
	register_srvcmd("changexp","changeXP")

	register_event("HideWeapon", "weapon_statechange", "b"); 
	register_event("SetFOV","weapon_statechange","be","1<90")   
	register_event("SetFOV","weapon_statechange","be","1=90") 
	register_event("CurWeapon","change_weapon","be","1=1")
	register_event("DeathMsg","death","a")
	register_event("ResetHUD", "player_spawn", "b")
	register_logevent("start_round", 2, "1=Round_Start")
	register_logevent("end_round", 2, "1=Round_End")
	register_logevent("end_round", 2, "1&Restart_Round_")


	register_event("Damage", "damage_event", "b", "2!0")
	#if SHOPMENU_IN_BUYZONE
		register_event("StatusIcon","BuyZone","be","2=buyzone") 
	#endif
	register_event("ArmorType", "armor_type", "be")
	register_event("TextMsg","restart_round","a","2&#Game_will_restart_in")	
	register_event("TextMsg","GrenTextMsg","b","2&#Game_radio", "4&#Fire_in_the_hole")
	register_event("StatusValue","set_team","be","1=1")
	register_event("StatusValue","show_race","be","1=2","2!0")
	register_event("StatusValue","hide_race","be","1=1","2=0")
	register_event("TextMsg","setSpectator","bd","2&ec_Mod") 
	register_event("StatusValue","spec_info","bd","1=2")	

   	register_logevent("event_player_action",3,"1=triggered") 
		
	register_cvar("mp_allowchangerace","0",0)
	register_cvar("mp_changeracepastfreezetime","0",0)
	#if ORCNADE_CVAR
		register_cvar("mp_alloworcnade","1",0)
	#endif
	#if SHORT_TERM
		register_cvar("mp_savexp","0",FCVAR_SERVER)
	#else
		register_cvar("mp_savexp","1",FCVAR_SERVER)
		register_cvar("mp_savebyname","0")
		#if !MYSQL_ENABLED
			// Vault initialization. First we check for war3index.
			// If it doesn't exist, this is a fresh Vault. We set
			// the default information required by the Vault.
			// If war3index exists, we have a previous Vault. We
			// then check for the Vault version. If it doesn't exist
			// the Vault is the oldest version and needs converted.
			// We then check to ensure there is a prune date, which
			// was not part of the original version either. The we
			// keep converting until we're at the current version.
			if(vaultdata_exists("war3index"))
			{
				if(!vaultdata_exists("vault_version"))
				{
					set_vaultdata("vault_version","1.00")
					server_print("[WC3] Old VAULT found, converting to 1.00 code.")
					convert_vault("1.00")
					server_print("[WC3] Conversion completed.")
				}
				new vaultver[32]
				get_vaultdata("vault_version",vaultver,31)
				server_print("[WC3] VAULT version: %s",vaultver)
				if(equal(vaultver,"1.00"))
				{
					set_vaultdata("vault_version","1.01")
					server_print("[WC3] Old VAULT found, converting to 1.01 code.")
					convert_vault("1.01")
					server_print("[WC3] Conversion completed.")
				}
				else
				{
					set_vaultdata("WC3_vault_version","1.02")
					server_print("[WC3] Old VAULT found, converting to 1.02 code.")
					convert_vault("1.02")
					server_print("[WC3] Conversion completed.")
				}
			}
			else if(!vaultdata_exists("WC3_war3index"))
			{
				new prunetime[32]
				format(prunetime,32,"%d",get_systime())
				set_vaultdata("WC3_war3index","1")
				set_vaultdata("WC3_vault_version","1.02")
				set_vaultdata("WC3_prunedate",prunetime)
				server_print("[WC3] No VAULT data found, initializing..")			
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
		if (!cvar_exists("amx_sql_host"))
			register_cvar("amx_sql_host","127.0.0.1")
		if (!cvar_exists("amx_sql_user"))
			register_cvar("amx_sql_user","")
		if (!cvar_exists("amx_sql_pass"))
			register_cvar("amx_sql_pass","")
		if (!cvar_exists("amx_sql_db"))
			register_cvar("amx_sql_db","war3base")
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

#if !SHORT_TERM && !MYSQL_ENABLED
public convert_vault(vaultver[32])
{
	new index, nIndex, vaultkey[64], vaultdata[128], playerid[32], playername[MAX_NAME_LENGTH]
	new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
	new month[3], day[3], mMonth, mDay
		
	get_vaultdata("war3index",vaultdata,127)
	nIndex = str_to_num(vaultdata)
	index = 1

	if(equali(vaultver,"1.00"))
	{
		get_vaultdata("war3index",vaultdata,127)
		nIndex = str_to_num(vaultdata)
		index = 1

		set_vaultdata("prunedate","1 1")

		while(index < nIndex)
		{
			format(vaultkey,63,"pruneindex_%d",index)
			get_vaultdata(vaultkey,playerid,31)
	
			mDay = 0
			mMonth = 0

			#if !EXPANDED_RACES
			for(new i=1; i<5; i++)
			#else
			for(new i=1; i<9; i++)
			#endif
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
	}
	else if(equali(vaultver,"1.01"))
	{
		get_vaultdata("war3index",vaultdata,127)
		nIndex = str_to_num(vaultdata)
		index = 1

		new pholder[4][32], timeseed, newtime
       	        new currentmonth[3], currentday[3], currentyear[5]
                new daysinmonth[12] = {31,28,31,30,31,30,31,31,30,31,30,31}

                get_time("%d",currentday,2)
       	        get_time("%m",currentmonth,2)
		get_time("%y",currentyear,4)
		format(currentyear,4,"20%s",currentyear)
		
		// We know there's been 8 leapyears since 1970 to 2004 (Its 2005 now)
		timeseed = (str_to_num(currentyear)-1979) * 31536000
		timeseed += 252979200

		format(pholder[0],32,"%d",get_systime())
		set_vaultdata("prunedate",pholder[0])

		while(index < nIndex)
		{
			format(vaultkey,63,"pruneindex_%d",index)
			get_vaultdata(vaultkey,playerid,31)
			get_vaultdata(playerid,vaultdata,127)
			parse(vaultdata,pholder[0],31,pholder[1],31,pholder[2],31,pholder[3],31)

			newtime = str_to_num(pholder[3])
			for(new i=1; i < str_to_num(pholder[2]); i++)
				newtime += str_to_num(daysinmonth[i-1])
			
			newtime = (newtime*86400)+timeseed

			if(str_to_num(pholder[2]) < str_to_num(currentmonth) || (str_to_num(pholder[2]) == str_to_num(currentmonth) && str_to_num(pholder[3]) < str_to_num(currentday)))
			{
				newtime += 31536000
				// I seriously doubt we need to worry about leapyears past 2008, but we'll check for 2012 to be silly.
				if(str_to_num(currentyear)-1 == 2004 || str_to_num(currentyear)-1 == 2008 || str_to_num(currentyear)-1 == 2012)
					newtime += 86400
			}

			format(vaultdata,127,"%d ^"%s^" %d",index,pholder[1],newtime)
			set_vaultdata(playerid,vaultdata)

			index++		
		}
	}
	else if(equali(vaultver,"1.02"))
	{
		remove_vaultdata("vault_version")
		
		get_vaultdata("war3index",vaultdata,127)
		set_vaultdata("WC3_war3index",vaultdata)
		remove_vaultdata("war3index")
		nIndex = str_to_num(vaultdata)
		index = 1
		
		get_vaultdata("prunedate",vaultdata,127)
		set_vaultdata("WC3_prunedate",vaultdata)
		remove_vaultdata("prunedate")
	
		while(index < nIndex)
		{
			format(vaultkey,63,"pruneindex_%d",index)
			get_vaultdata(vaultkey,playerid,31)
			remove_vaultdata(vaultkey)
			format(vaultkey,63,"WC3_pruneindex_%d",index)
			set_vaultdata(vaultkey,playerid)
			
			format(vaultkey,63,"%s",playerid)
			get_vaultdata(vaultkey,vaultdata,127)
			remove_vaultdata(vaultkey)
			format(vaultkey,63,"WC3_%s",playerid)
			set_vaultdata(vaultkey,vaultdata)
			
			#if !EXPANDED_RACES
			for(new i=1; i<5; i++)
			#else
			for(new i=1; i<9; i++)
			#endif
			{
				format(vaultkey,63,"%s_%d",playerid,i)
				get_vaultdata(vaultkey,vaultdata,127)
				remove_vaultdata(vaultkey)
				format(vaultkey,63,"WC3_%s_%d",playerid,i)
				set_vaultdata(vaultkey,vaultdata)			
			}
		
			index++		
		}
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
	
	new timeseed, newtime
        new currentmonth[3], currentday[3], currentyear[5]
        new daysinmonth[12] = {31,28,31,30,31,30,31,31,30,31,30,31}
	
        get_time("%d",currentday,2)
        get_time("%m",currentmonth,2)
	get_time("%y",currentyear,4)
	format(currentyear,4,"20%s",currentyear)
			
	// We know there's been 8 leapyears since 1970 to 2004 (Its 2005 now)
	timeseed = (str_to_num(currentyear)-1979) * 31536000
	timeseed += 252979200
		
	if(file_exists(XPFILENAME))
	{
		server_print("[WC3] Old saved xp file found. Converting to VAULT...")

		do
		{
			nextline = read_file(XPFILENAME,nextline,textline,127,textlength)
						
			if(textlength && contain(textline,"**") && contain(textline,"##"))
			{
			
				parse(textline,playerid,31,playername,MAX_NAME_LENGTH-1,xp,7,race,1,skill1,1,skill2,1,skill3,1,skill4,1,month,2,day,2)
				
				format(vaultkey,63,"WC3_%s_%s",playerid,race)


				#if VAULT_PROTECT   // If we're protecting the Vault, check if the key exists first.
				if(!vaultdata_exists(vaultkey))
				{
				#endif
				
					format(vaultdata, 127, "%s %s %s %s %s %s",xp,race,skill1,skill2,skill3,skill4)
					set_vaultdata(vaultkey,vaultdata)
				
				#if VAULT_PROTECT
				}
				#endif
				
				newtime = str_to_num(day)
				for(new i=1; i < str_to_num(month); i++)
					newtime += daysinmonth[i-1]
						
				newtime = (newtime*86400)+timeseed

				if(str_to_num(month) < str_to_num(currentmonth) || (str_to_num(month) == str_to_num(currentmonth) && str_to_num(day) < str_to_num(currentday)))
				{
					newtime += 31536000
					// I seriously doubt we need to worry about leapyears past 2008, but we'll check for 2012 to be silly.
					if(str_to_num(currentyear)-1 == 2004 || str_to_num(currentyear)-1 == 2008 || str_to_num(currentyear)-1 == 2012)
						newtime += 86400
				}

				format(vaultkey, 63, "WC3_%s", playerid)

				if(!vaultdata_exists(vaultkey))
				{
					get_vaultdata("WC3_war3index", index, 31);
					format(vaultdata,127,"%s ^"%s^" %d",index,playername,newtime)
					set_vaultdata(vaultkey,vaultdata)
					format(vaultkey,63,"WC3_pruneindex_%s",index)
					set_vaultdata(vaultkey,playerid)
					format(index,31,"%d",(str_to_num(index)+1))
					set_vaultdata("WC3_war3index",index)
				}
				#if !VAULT_PROTECT   // If we're protecting the vault, leave the current key alone.
				else
				{
					new sOldTime[32]
					get_vaultdata(vaultkey,vaultdata,127)
					parse(vaultdata,index,31,playername,MAX_NAME_LENGTH-1,sOldTime,31)

					if(str_to_num(sOldTime) > newtime)
						newtime = str_to_num(sOldTime)
						
					format(vaultdata,127,"%s ^"%s^" %d",index,playername,newtime)
					set_vaultdata(vaultkey,vaultdata)					
				}
				#endif					
			}
			
			write_file("war3users.bak",textline,-1)
			write_file(XPFILENAME,"",nextline-1)
			
		} while (nextline)
		
		delete_file(XPFILENAME)

		server_print("[WC3] Conversion completed.")
	}

	return PLUGIN_CONTINUE
}

#endif
#endif