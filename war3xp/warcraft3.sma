/* AMX Mod script. 
* 
*  Warcraft 3 XP
*  by SpaceDude 
*  email: eayumns@nottingham.ac.uk 
*  MSN: eayumns@nottingham.ac.uk 
*  ICQ: 1615758
*  IRC: Quakenet, nickname: "SpaceDude"
* 
*  Read warcraft3.txt for more info on this plugin
*
*  mysql version from Mr. B modded a bit 
*  by dopefish for si-ka.net
*
*  ########## Dopy's Changelog #######
*  hell of a lot of bugfixes from other people put in here
*
*  changed invisibility a bit
*
*  cleaned up weapon reincarnation and put some stuff from 2.30 in
*
*  put in most bugfixes from 2.21 into this version
*
*  added all changes from "guest" that weren't alredy in here
*  > http://spacedude.games-fed.com/forum/viewtopic.php?t=1326&start=0
*
*  #################
*
*  v2.22.3
*
*/ 

#include <amxmod>
#include <mysql>
#include <war3>

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
#define EXPLOSION_RANGE 300
#define EXPLOSION_MAX_DAMAGE 50
#define LIGHTNING_RANGE 500
#define TELEPORT_RADIUS 50
#define MAXGLOW 150
#define ULTIMATESEARCHTIME 50
#define TELEPORT_COOLDOWN 7.0
#define CHAINLIGHTNING_COOLDOWN 20.0
#define ENTANGLEROOTS_COOLDOWN 20.0
#define BOMBSHAREXPRADIUS 500
#define HOSTAGESHAREXPRADIUS 1000
#define BOOTSPEED 275.0
#define CLAWSOFATTACK 10
#define CLOAKINVISIBILITY 150
#define KNIFEINVISIBILITY 30
#define MASKPERCENT 0.333
#define FROSTSPEED 0.0
#define HEALTHBONUS 25

#define ANKH 1
#define BOOTS 2
#define CLAWS 3
#define CLOAK 4
#define MASK 5
#define IMMUNITY 6
#define FROST 7
#define HEALTH 8
#define TOME 9

new Float:maxgetxptime = 60.0
new Float:lastendround
new daysbeforedelete
new dayslevelmodifier

new p_level[33]
new p_skills[33][5]
new iglow[33][4]
new armorondeath[33]
new savedweapons[33][32]
new savednumber[33]
new teleportid[33][32]
new playerxp[33]
new pmoney[33]
new playeritem[33]
new savedline[64][128]
new bool:p_evadenextshot[33]
new bool:diedlastround[33]
new bool:stunned[33]
new bool:slowed[33]
new bool:issearching[33]
new bool:lightninghit[33]
new bool:ultimateused[33]
new bool:cheatson[33]
new bool:teleportmenu[33]
new bool:hasgrenade[33]
new bool:hasdefuse[33]
new bool:helmet[33]
new bool:changingrace[33]
new bool:changingteam[33]
new bool:knifeselected[33]
// new readxp[33] COMMENTED OUT, NO LONGER USED
new bool:warcraft3
new bool:savexp
new bool:endround
new bool:mysqlcvar
new Float:voting
new Float:vote_ratio
new Float:lastupdate
new option
new bombplanter
new bombdefuser
new hostagesaver

new mysql
new mysqltablename[64]

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

new Float:p_vampiric[3] = {0.15,0.30,0.45}	// Vampiric Aura (skill 1)
new p_vampirichealth[3] = {100,100,100}		// Vampiric Aura Max Health (skill 1)
new Float:p_unholy[3] = {250.0,275.0,300.0}	// Unholy Aura (skill 2)
new Float:p_levitation[3] = {0.85,0.7,0.45}	// Levitation (skill 3)

new p_invisibility[3] = {180,150,120}		// Invisibility (skill 1)
new p_devotion[3] = {100+HEALTHBONUS,100+2*HEALTHBONUS,100+3*HEALTHBONUS}		// Devotion Aura (skill 2)
new Float:p_bash[3] = {0.15,0.30,0.45}		// Bash (skill 3)

new Float:p_critical[3] = {0.15,0.2,0.333}	// Critical Strike (skill 1)
new Float:p_grenade[3] = {1.0,2.0,3.0}		// Critical Grenade (skill 2)
new Float:p_ankh[3] = {0.333,0.666,1.0}		// Equipment reincarnation (skill 3)

new Float:p_evasion[3] = {0.1,0.2,0.3}		// Evasion (skill 1)
new Float:p_thorns[3] = {0.05,0.1,0.2}		// Thorns Aura (skill 2)
new Float:p_trueshot[3] = {0.15,0.3,0.45}	// Trueshot Aura (skill 3)

new xplevel[11] = {0,100,300,600,1000,1500,2100,2800,3600,4500,5500}
new xpgiven[11] = {60,80,100,120,140,160,180,200,220,240,260}
new BOMBPLANTXP = 100
new DEFUSEXP = 100
new HOSTAGEXP = 100
new KILLRESCUEMANXP = 100
new XPBONUS = 1000
new XPFILENAME[] = "war3users.ini"
new Float:weaponxpmultiplier[31] = {1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0}

new racename[4][] = {"Undead Scourge","Human Alliance","Orcish Horde","Night Elves of Kalimdor"}
new shortracename[4][] = {"Undead", "Human", "Orc", "Night Elf"}

new itemname[9][] = {"Ankh of Reincarnation","Boots of Speed","Claws of Attack +6","Cloak of Shadows","Mask of Death","Necklace of Immunity","Orb of Frost","Periapt of Health","Tome of Experience"}
new itemcost[9] = {1500,1500,1000,800,2000,1000,2000,1000,5000}

new race1skill[4][] = {"Vampiric Aura","Unholy Aura","Levitation","Suicide Bomber"}
new race2skill[4][] = {"Invisibility","Devotion Aura","Bash","Teleport"}
new race3skill[4][] = {"Critical Strike","Critical Grenade","Equipment Reincarnation","Chain Lightning"}
new race4skill[4][] = {"Evasion","Thorns Aura","Trueshot Aura","Entangle Roots"}

public set_xpmultiplier(){
        if (!get_cvar_num("mp_weaponxpmodifier"))
                return PLUGIN_CONTINUE

        weaponxpmultiplier[CSW_USP] = 3.0
        weaponxpmultiplier[CSW_DEAGLE] = 1.5
        weaponxpmultiplier[CSW_GLOCK18] = 3.0
        weaponxpmultiplier[CSW_ELITE] = 2.5
        weaponxpmultiplier[CSW_P228] = 3.5
        weaponxpmultiplier[CSW_FIVESEVEN] = 3.5

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
        weaponxpmultiplier[CSW_G3SG1] = 2.25
        weaponxpmultiplier[CSW_SG550] = 2.25
        weaponxpmultiplier[CSW_M249] = 1.25
        weaponxpmultiplier[CSW_SCOUT] = 2.0

        weaponxpmultiplier[CSW_HEGRENADE] = 3.0
        weaponxpmultiplier[CSW_KNIFE] = 10.0

        weaponxpmultiplier[CSW_C4] = 1.0
        weaponxpmultiplier[CSW_SMOKEGRENADE] = 1.0
        weaponxpmultiplier[CSW_FLASHBANG] = 1.0
        return PLUGIN_CONTINUE
}

// **NEW CODE**
public displaylevel(id,hide){
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

	new xpstring[256]
	if (p_level[id]==0)
		format(xpstring,255,"%s   XP: %d/%d   %s",shortracename[p_skills[id][0]-1],playerxp[id],xplevel[1], playeritem[id]?itemname[playeritem[id]-1]:"")
	else if (p_level[id]<10)
		format(xpstring,255,"%s Level %d   XP: %d/%d   %s",shortracename[p_skills[id][0]-1],p_level[id],playerxp[id],xplevel[p_level[id]+1], playeritem[id]?itemname[playeritem[id]-1]:"")
	else
		format(xpstring,255,"%s Level %d   XP: %d/%d   %s",shortracename[p_skills[id][0]-1],p_level[id],xplevel[10],xplevel[10], playeritem[id]?itemname[playeritem[id]-1]:"")

	message_begin( MSG_ONE, gmsgStatusText, {0,0,0}, id)
	write_byte(0)
	write_string(xpstring)
	message_end()

	if (cheatson[id] && get_cvar_num("sv_cheats")==1)
		p_level[id]=10

	if (p_level[id] > oldlevel && is_user_alive(id)){			// Level Gained
		set_hudmessage(200, 100, 0, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
		show_hudmessage(id,"You gained a Level")
		if (file_exists("sound/warcraft3/Levelupcaster.wav")==1)
			emit_sound(id,CHAN_STATIC, "warcraft3/Levelupcaster.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		else
			emit_sound(id,CHAN_STATIC, "plats/elevbell1.wav", 1.0, ATTN_NORM, 0, PITCH_LOW)
	}

	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	while (skillsused>p_level[id]){
		if (p_skills[id][4]==1 && p_level[id]<6)
			p_skills[id][4]=0
		else if (p_skills[id][1]>=p_skills[id][2] && p_skills[id][1]>=p_skills[id][3])
			--p_skills[id][1]
		else if (p_skills[id][2]>=p_skills[id][1] && p_skills[id][2]>=p_skills[id][3])
			--p_skills[id][2]
		else if (p_skills[id][3]>=p_skills[id][1] && p_skills[id][3]>=p_skills[id][2])
			--p_skills[id][3]
		skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	}

	if (hide!=1 && p_skills[id][0]!=0){
		new temp[128]
		new message[256]

		format(message,255,"%s",racename[p_skills[id][0]-1])
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
//			new invisibility = p_invisibility[p_skills[id][1]-1]/2
			new invisibility = p_invisibility[p_skills[id][1]-1]-p_invisibility[2]+KNIFEINVISIBILITY
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,invisibility)
		}
		else
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,p_invisibility[p_skills[id][1]-1])
	}
	else if (playeritem[id]==CLOAK){			// Cloack of Shadows
		if (knifeselected[id]){
//			new invisibility = CLOAKINVISIBILITY/2
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
			set_user_health(id,get_user_health(id)-1024)
	}

	new parm[1]
	parm[0]=id
	unholyspeed(parm)

	return PLUGIN_CONTINUE
}
// **END OF NEW CODE**

/*
-------ORIGINAL CODE-------
public displaylevel(id,hide){
	if (id==0)
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
	if (p_level[id]==0)
		format(xpstring,255,"%s   XP: %d/%d   %s",racename[p_skills[id][0]-1],playerxp[id],xplevel[p_level[id]+1], playeritem[id]?itemname[playeritem[id]-1]:"")
	else if (p_level[id]<10)
		format(xpstring,255,"%s Level %d   XP: %d/%d   %s",racename[p_skills[id][0]-1],p_level[id],playerxp[id],xplevel[p_level[id]+1], playeritem[id]?itemname[playeritem[id]-1]:"")
	else
		format(xpstring,255,"%s Level %d   XP: %d/%d   %s",racename[p_skills[id][0]-1],p_level[id],xplevel[10],xplevel[10], playeritem[id]?itemname[playeritem[id]-1]:"")

	message_begin( MSG_ONE, gmsgStatusText, {0,0,0}, id)
	write_byte(0)
	write_string(xpstring)
	message_end()

	if (cheatson[id] && get_cvar_num("sv_cheats")==1)
		p_level[id]=10

	if (p_level[id] > oldlevel){			// Level Gained
		set_hudmessage(200, 100, 0, -1.0, 0.25, 0, 1.0, 2.0, 0.1, 0.2, 2)
		show_hudmessage(id,"You gained a Level")
		if (file_exists("sound/warcraft3/Levelupcaster.wav")==1)
			emit_sound(id,CHAN_STATIC, "warcraft3/Levelupcaster.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		else
			emit_sound(id,CHAN_STATIC, "plats/elevbell1.wav", 1.0, ATTN_NORM, 0, PITCH_LOW)
	}

	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	while (skillsused>p_level[id]){
		if (p_skills[id][4]==1 && p_level[id]<6)
			p_skills[id][4]=0
		else if (p_skills[id][1]>=p_skills[id][2] && p_skills[id][1]>=p_skills[id][3])
			--p_skills[id][1]
		else if (p_skills[id][2]>=p_skills[id][1] && p_skills[id][2]>=p_skills[id][3])
			--p_skills[id][2]
		else if (p_skills[id][3]>=p_skills[id][1] && p_skills[id][3]>=p_skills[id][2])
			--p_skills[id][3]
		skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	}

	if (hide!=1 && p_skills[id][0]!=0){
		new temp[128]
		new message[256]

		format(message,255,"%s",racename[p_skills[id][0]-1])
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

	if (p_skills[id][0] == 1 && p_skills[id][3]){		// Levitation
		if (get_user_gravity(id)!=p_levitation[p_skills[id][3]-1])
			set_user_gravity(id,p_levitation[p_skills[id][3]-1])
	}
	else if (get_user_gravity(id)!=1.0)
		set_user_gravity(id,1.0)

	if (p_skills[id][0] == 2 && p_skills[id][1]){		// Invisibility
		if (knifeselected[id]){
//			new invisibility = p_invisibility[p_skills[id][1]-1]/2
			new invisibility = p_invisibility[p_skills[id][1]-1]-p_invisibility[2]+KNIFEINVISIBILITY
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,invisibility)
		}
		else
			set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransTexture,p_invisibility[p_skills[id][1]-1])
	}
	else if (playeritem[id]==CLOAK){
		if (knifeselected[id]){
//			new invisibility = CLOAKINVISIBILITY/2
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
			set_user_health(id,get_user_health(id)-1024)
	}

	new parm[1]
	parm[0]=id
	unholyspeed(parm)

	return PLUGIN_CONTINUE
}
-------END OF ORIGINAL CODE-------
*/

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

	if (!(killer_id==victim_id && !headshot && equal(weaponname,"world"))){
		message_begin( MSG_ALL, gmsgDeathMsg,{0,0,0},0)
		write_byte(killer_id)
		write_byte(victim_id)
		write_byte(headshot)
		write_string(weaponname)
		message_end()
	}

	if (p_skills[victim_id][0]==1 && p_skills[victim_id][4] && !changingteam[victim_id]){	// Suicide Bomber
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
		}
		else{
			if (!get_cvar_num("mp_weaponxpmodifier"))
				playerxp[killer_id]+=xpgiven[p_level[victim_id]]
			else
				playerxp[killer_id]+=floatround(xpgiven[p_level[victim_id]]*weaponxpmultiplier[weapon])
			if (victim_id==hostagesaver)
				playerxp[killer_id]+=KILLRESCUEMANXP
		}
		displaylevel(killer_id, 1)
	}

	new skinparm[1]
	skinparm[0]=victim_id
	set_task(0.1,"setskin",36,skinparm,1)

	new parameter[1]
	parameter[0]=victim_id
	set_task(1.0,"getuserinput",3,parameter,1)

	return PLUGIN_CONTINUE
}

public getuserinput(parm[1]){
	new id = parm[0]
	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	if (p_skills[id][0] == 0){
		if (!savexp)
			select_race(id)
	}
	else if (skillsused < p_level[id])
		select_skill(id,0)
	else
		displaylevel(id, 0)

	return PLUGIN_HANDLED
}

public restart_round(){
	if (warcraft3==false || savexp)
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

public new_round(id){ 
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	ultimateused[id]=false
	stunned[id]=false
	slowed[id]=false
	hasgrenade[id]=false
	changingrace[id]=false
	endround=false
	hostagesaver=0
	new weaponid, weaponname[20], ammoname[20], parm[2], reincarnate = 0
//	new secondary
	parm[0]=id

	if (p_skills[id][0] == 0){
		if (!savexp)
			select_race(id)
		return PLUGIN_HANDLED
	}

	if (diedlastround[id]){			// Equipment Reincarnation
		new Float:randomnumber = random_float(0.0,1.0)
		if (p_skills[id][0] == 3 && p_skills[id][3] && randomnumber <= p_ankh[p_skills[id][3]-1])
			reincarnate=1
		if (playeritem[id]==ANKH)
			reincarnate=1			
		if (reincarnate){
			if (armorondeath[id]){
				if (helmet[id])
					give_item(id,"item_assaultsuit")
				else
					give_item(id,"item_kevlar")
				set_user_armor(id,armorondeath[id])
			}
			if (hasdefuse[id])
				give_item(id,"item_thighpack")

			for (new j=0; j < savednumber[id] && j < 32; ++j){
//				secondary = false
				weaponid=savedweapons[id][j]
				if (weaponid==3){
					weaponname="weapon_scout"
					ammoname="ammo_762nato"
				}
				else if (weaponid==4){
					weaponname=""
					ammoname=""
					parm[1]=4
					set_task(1.0,"buy_weapons",96,parm,2)
					set_user_money(id,get_user_money(id)+300,0)
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
					weaponname=""
					ammoname=""
					parm[1]=5
					set_task(1.0,"buy_weapons",96,parm,2)
					set_user_money(id,get_user_money(id)+300,0)
				}
				else if (weaponid==12){
					weaponname="weapon_ump45"
					ammoname="ammo_45acp"
				}
				else if (weaponid==13){
					weaponname="weapon_sg550"
					ammoname="ammo_556nato"
				}
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
					weaponname=""
					ammoname=""
					parm[1]=3
					set_task(1.0,"buy_weapons",96,parm,2)
					set_user_money(id,get_user_money(id)+200,0)
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
/*				else if (weaponid==1){
					secondary=true
					weaponname="weapon_p228"
					ammoname="ammo_357sig"
				}
				else if (weaponid==10){
					secondary=true
					weaponname="weapon_elite"
					ammoname="ammo_9mm"
				}
				else if (weaponid==11){
					secondary=true
					weaponname="weapon_fiveseven"
					ammoname="ammo_57mm"
				}
				else if (weaponid==16){
					secondary=true
					weaponname="weapon_usp"
					ammoname="ammo_45acp"
				}
				else if (weaponid==17){
					secondary=true
					weaponname="weapon_glock18"
					ammoname="ammo_9mm"
				}
				else if (weaponid==26){
					secondary=true
					weaponname="weapon_deagle"
					ammoname="ammo_50ae"
				}*/
				else{
					weaponname=""
					ammoname=""
				}
/*				if (secondary){
					engclient_cmd(id,"weapon_glock18")
					engclient_cmd(id,"weapon_usp")
					engclient_cmd(id,"drop")
				}*/
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
				set_task(0.01,"glow_change",4,parm,2)
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

	if (p_skills[id][0] == 4 && p_skills[id][1] && p_evadenextshot[id]){		// Evasion
		set_user_health(id,1124)
	}
	else if (p_skills[id][0] == 2 && p_skills[id][2]){		// Devotion Aura
		set_user_health(id,p_devotion[p_skills[id][2]-1])
	}
	if (playeritem[id]==HEALTH)
		set_user_health(id,get_user_health(id)+HEALTHBONUS)

	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	if (skillsused < p_level[id]){
		select_skill(id,0)
	}
	else {
		displaylevel(id, 0)
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

public end_round(){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new players[32]
	new numberofplayers
	get_players(players, numberofplayers)
	new i
	new parameter[1]
	for (i = 0; i < numberofplayers; ++i){
		parameter[0]=players[i]
		set_task(1.0,"getuserinput",5,parameter,1)
	}
	endround=true
	if (savexp)
		update_file(0)	//modded for different update_file method.

	lastendround=get_gametime()

	return PLUGIN_CONTINUE
}

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
		if (p_level[id]<=5){
			format(temp,127,"\d")
			add(message,255,temp)
		}
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
	if (p_skills[id][4]==0 && p_level[id]>=6 && skillsused<p_level[id])
		keys |= (1<<3)

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
	else if (key == 3 && p_skills[id][4]==0 && p_level[id]>=6 && skillsused<p_level[id])
		p_skills[id][4]=1
	else if (key == 9)
		return PLUGIN_HANDLED

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

	if (get_cvar_num("mp_allowchangerace")==1 || p_skills[id][0]==0){
		if (savexp){
			if (!changingrace[id]){
				addtosavequeue(id)
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

/*
-------ORIGINAL CODE-------
public change_race(id,saychat){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	if (get_cvar_num("mp_allowchangerace")==1 || p_skills[id][0]==0){
		if (savexp){
			if (maxgetxptime > get_gametime()){
				write_xp_to_file(id,"")
				get_xp_from_file(id,1)
			}
			else{
				readxp[id]=1
				if (saychat==1){
					set_hudmessage(200, 100, 0, -1.0, 0.3, 0, 1.0, 5.0, 0.1, 0.2, 3)
					show_hudmessage(id,"Wait until the end of the round and the race menu will popup!")
				}
				else{
					client_cmd(id,"echo Wait until the end of the round and the race menu will popup!")
				}
			}
		}
		else
			select_race(id)
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
-------END OF ORIGINAL CODE-------
*/

public select_race(id){

	if (is_user_bot(id)){
		p_skills[id][0] = random_num(1,4)
		return PLUGIN_HANDLED
	}

	new menu_msg[256]
	format(menu_msg,255,"\ySelect Race:\w^n^n1. %s^n2. %s^n3. %s^n4. %s^n^n\
							5. Auto-select", racename[0],\
							racename[1], racename[2], racename[3])

	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),menu_msg,-1)
	return PLUGIN_CONTINUE
}

public currentskin(id){
	new skin[16]
	get_user_info(id,"model",skin,15)
	if (contain(skin,"terror")!=-1 || contain(skin,"urban")!=-1)
		return 1
	else if (contain(skin,"leet")!=-1 || contain(skin,"gsg9")!=-1)
		return 2
	else if (contain(skin,"arctic")!=-1 || contain(skin,"sas")!=-1)
		return 3
	else if (contain(skin,"guerilla")!=-1 || contain(skin,"gign")!=-1)
		return 4
	return 0
}

public setskin(parm[1]){
	new id = parm[0]
	if (currentskin(id)!=p_skills[id][0] && get_user_team(id)!=0){
		if (is_user_alive(id))
			set_user_frags(id,get_user_frags(id)+1)
		engclient_cmd(id, "chooseteam")
		if (get_user_team(id)==1){
			engclient_cmd(id, "menuselect", "1")
		}
		else if (get_user_team(id)==2){
			engclient_cmd(id, "menuselect", "2")
		}
		new skin[2]
		num_to_str(p_skills[id][0],skin,1)
		engclient_cmd(id,"menuselect",skin)
		client_cmd(id,"slot5")	// clear menu
	}
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

	if (savexp){
		playerxp[id] = 0
		p_level[id] = 0
		get_xp_from_file(id,0)
	}

	if (get_user_team(id)==0){
		engclient_cmd(id, "chooseteam")
		return PLUGIN_CONTINUE
	}
	if (get_cvar_num("mp_forceskin")==1 || is_user_alive(id)==0){
		new parm[1]
		parm[0]=id
		setskin(parm)
	}
	else {
		new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]
		if (skillsused < p_level[id])
			select_skill(id,0)
	}
	return PLUGIN_CONTINUE
}

/*
-------ORIGINAL CODE-------
public set_race(id,key){
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

	p_skills[id][1] = 0
	p_skills[id][2] = 0
	p_skills[id][3] = 0
	p_skills[id][4] = 0

	if (savexp){
		playerxp[id] = 0
		p_level[id] = 0
		if (lastendround+10.0 < get_gametime() && maxgetxptime < get_gametime())
			readxp[id]=2
		else
			get_xp_from_file(id,0)
	}

	if (get_user_team(id)==0){
		engclient_cmd(id, "chooseteam")
		return PLUGIN_HANDLED
	}
	if (get_cvar_num("mp_forceskin")==1 || is_user_alive(id)==0){
		new parm[1]
		parm[0]=id
		setskin(parm)
	}
	else {
		new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]
		if (skillsused < p_level[id])
			select_skill(id,0)
	}
	return PLUGIN_HANDLED
}
-------END OF ORIGINAL CODE-------
*/

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
		set_task(TELEPORT_COOLDOWN,"cooldown",6,cooldownparm,1)
	}

	return PLUGIN_HANDLED
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
				if (get_user_health(id)<=100){
					healthadjustment = 1024
				}
			}
			else{
				p_evadenextshot[id]=false
				if (get_user_health(id)>100){
					healthadjustment = -1024
				}
			}
			if (p_evadecurrentshot){
				damage = read_data(2)
				set_user_health(id, get_user_health(id) + damage + healthadjustment)

				if (iglow[id][2] < 1){
					new parm[2]
					parm[0] = id
					set_task(0.01,"glow_change",7,parm,2)
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
			else
				set_user_health(id, get_user_health(id) + healthadjustment)
		}
		if (p_skills[id][2]) {		// Thorns Aura
			damage = read_data(2)
			damage = floatround(float(damage) * p_thorns[p_skills[id][2]-1])
			if (get_user_health(enemy) - damage<=0)
				enemykilled = 1
			else if (get_user_health(enemy) - damage<=1024 && get_user_health(enemy)>500)
				enemykilled = 1
			else
				enemykilled = 0

			if (enemykilled)
				set_user_health(enemy, -1)
			else
				set_user_health(enemy, get_user_health(enemy) - damage)

			if (iglow[enemy][0] < 1){
				new parm[2]
				parm[0] = enemy
				set_task(0.01,"glow_change",8,parm,2)
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
				set_task(0.01,"glow_change",9,parm,2)
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
					set_task(0.01,"glow_change",11,parm,2)
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
				if (get_user_health(id) - damage<=1024 && get_user_health(id)>500)
					victimkilled = 1
				if (victimkilled)
					set_user_health(id, -1)
				else
					set_user_health(id, get_user_health(id) - damage)

				if (iglow[id][0] < 1){
					new parm[2]
					parm[0] = id
					set_task(0.01,"glow_change",12,parm,2)
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
		if (p_skills[enemy][2] && playeritem[id]!=IMMUNITY){		// Critical Grenade
			if (weapon == 4){
				damage = read_data(2)
				damage = floatround(float(damage) * p_grenade[p_skills[enemy][2]-1])
				if (get_user_health(id) - damage<=0)
					victimkilled = 1
				if (get_user_health(id) - damage<=1024 && get_user_health(id)>500)
					victimkilled = 1
				if (victimkilled)
					set_user_health(id, -1)
				else
					set_user_health(id,get_user_health(id) - damage)

				if (iglow[id][0] < 1){
					new parm[2]
					parm[0] = id
					set_task(0.01,"glow_change",13,parm,2)
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
	}

	else if (p_skills[enemy][0] == 4){	// Trueshot Aura
		if (p_skills[enemy][3]) {
			damage = read_data(2)
			damage = floatround(float(damage) * p_trueshot[p_skills[enemy][3]-1])
			if (get_user_health(id) - damage<=0)
				victimkilled = 1
			if (get_user_health(id) - damage<=1024 && get_user_health(id)>500)
				victimkilled = 1
			if (victimkilled)
				set_user_health(id, -1)
			else
				set_user_health(id, get_user_health(id) - damage)

			if (iglow[id][0] < 1){
				new parm[2]
				parm[0] = id
				set_task(0.01,"glow_change",14,parm,2)
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
		if (get_user_health(id) - damage<=0)
			victimkilled = 1
		if (get_user_health(id) - damage<=1024 && get_user_health(id)>500)
			victimkilled = 1
		if (victimkilled)
			set_user_health(id, -1)
		else
			set_user_health(id, get_user_health(id) - damage)

		if (iglow[id][0] < 1){
			new parm[2]
			parm[0] = id
			set_task(0.01,"glow_change",14,parm,2)
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
			set_task(0.01,"glow_change",9,parm,2)
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
				set_task(0.01,"glow_change",11,parm,2)
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
				if (!get_cvar_num("mp_weaponxpmodifier"))
					playerxp[enemy]+=xpgiven[p_level[id]]
				else
					playerxp[enemy]+=floatround(xpgiven[p_level[id]]*weaponxpmultiplier[weapon])
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

	new parm[1]
	parm[0]=id
	unholyspeed(parm)

	return PLUGIN_CONTINUE
}

public freezetimedone(id) {
	if (warcraft3==false)
		return PLUGIN_CONTINUE

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
	else if (get_user_maxspeed(id)>10 && p_skills[id][0] == 1 && p_skills[id][2]){		// Unholy Aura
		if (get_user_maxspeed(id)!=p_unholy[p_skills[id][2]-1]){
			set_user_maxspeed(id,(p_unholy[p_skills[id][2]-1]))
		}
	}
	else if (get_user_maxspeed(id)>10 && playeritem[id]==BOOTS){			// Boots of Speed
		if (get_user_maxspeed(id)!=BOOTSPEED){
			set_user_maxspeed(id,BOOTSPEED)
		}
	}
	return PLUGIN_CONTINUE
}

public say_level(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	displaylevel(id, 0)
	return PLUGIN_CONTINUE
}

public player_skills(id,saychat){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new name[32], temp[256], message[2048]
	new skill1[64], skill2[64], skill3[64], skill4[64]
	new players[32]
	new numberofplayers
	get_players(players, numberofplayers)
	new i
	new playerid
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
			format(temp,255,"%s - %s %d%s%s%s%s^n",name,racename[0],p_level[playerid],skill1,skill2,skill3,skill4)
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
			format(temp,255,"%s - %s %d%s%s%s%s^n",name,racename[1],p_level[playerid],skill1,skill2,skill3,skill4)
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
			format(temp,255,"%s - %s %d%s%s%s%s^n",name,racename[2],p_level[playerid],skill1,skill2,skill3,skill4)
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
			format(temp,255,"%s - %s %d%s%s%s%s^n",name,racename[3],p_level[playerid],skill1,skill2,skill3,skill4)
		}
		else if (p_skills[playerid][0]==0){
			format(temp,255,"%s - race not yet selected^n",name)
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
	if (p_skills[id][0]==1){
		format(title,63,"%s Skills",racename[0])
		message = "Vampiric Aura: Gives you (%d%%, %d%% or %d%%) of the damage you do in attack back as health^n^n\
			   Unholy Aura: Gives you a speed boost, also all weapons make you go at the same speed^n^n\
			   Levitation: Allows you to jump higher by reducing your gravity^n^n\
			   Ultimate, Suicide Bomber: When you die you will explode killing nearby enemies"
		format(message,1023,message,floatround(p_vampiric[0]*100),floatround(p_vampiric[1]*100),floatround(p_vampiric[2]*100))
	}
	else if (p_skills[id][0]==2){
		format(title,63,"%s Skills",racename[1])
		message = "Invisibility: Makes you partially invisible, you will be harder to see^n^n\
		           Devotion Aura: Gives you (%d, %d or %d) health at the start of the round.^n^n\
			   Bash: When you shoot someone you have a (%d%%, %d%% or %d%%) chance of rendering them immobile for 1 second^n^n\
			   Ultimate, Teleport: Allows you to teleport to a team mate (10 seconds cooldown)"
		format(message,1023,message,p_devotion[0],p_devotion[1],p_devotion[2],floatround(p_bash[0]*100),floatround(p_bash[1]*100),floatround(p_bash[2]*100))
	}
	else if (p_skills[id][0]==3){
		format(title,63,"%s Skills",racename[2])
		message = "Critical Strike: Gives you a %d%% chance of doing (2, 3, or 4) times normal damage^n^n\
			   Critical Grenade: Grenades will ALWAYS do (%d, %d or %d) times normal damage^n^n\
			   Equipment Reincarnation: Gives you a (%d%%, %d%% or %d%%) chance of regaining your equipment on death^n^n\
			   Ultimate, Chain Lightning: Discharges a bolt of lightning that jumps to all nearby enemies"
		format(message,1023,message,floatround(p_critical[0]*100),floatround(p_grenade[0])+1,floatround(p_grenade[1])+1,floatround(p_grenade[2])+1,floatround(p_ankh[0]*100),floatround(p_ankh[1]*100),floatround(p_ankh[2]*100))
	}
	else if (p_skills[id][0]==4){
		format(title,63,"%s Skills",racename[3])
		message = "Evasion: Gives you a (%d%%, %d%% or %d%%) chance of evading each shot^n^n\
			   Thorns Aura: Does (%d%%, %d%% or %d%%) mirror damage to the person who shot you^n^n\
			   Trueshot Aura: Does (%d%%, %d%% or %d%%) extra damage to the enemy^n^n\
			   Ultimate, Entangle Roots: Allows you to prevent an enemy player from moving for 10 seconds"
		format(message,1023,message,floatround(p_evasion[0]*100),floatround(p_evasion[1]*100),floatround(p_evasion[2]*100),floatround(p_thorns[0]*100),floatround(p_thorns[1]*100),floatround(p_thorns[2]*100),floatround(p_trueshot[0]*100),floatround(p_trueshot[1]*100),floatround(p_trueshot[2]*100))
	}
	else{
		client_cmd(id,"echo You must select a race before viewing the skills information!")
		return PLUGIN_HANDLED
	}
	if (p_skills[id][0]==2 || p_skills[id][0]==3 || p_skills[id][0]==4){
		new temp[]="^n^n^nNote: to use ultimate skills, bind a key to ^"ultimate^", e.g. bind ^"shift^" ^"ultimate^"^n\
			    Then press the key (shift in this case) you should hear a beeping sound, this means that you are searching for a target. \
			    Once you hear the beeping sound aim your crosshair at a player and wait until it locks on. You have 5 seconds to find a target before it gives up."
		add(message,1023,temp)
	}
	show_motd(id,message,title)
	if (saychat==1)
		return PLUGIN_CONTINUE
	return PLUGIN_HANDLED
}

public items_info(id,saychat){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	new message[1024]
	new title[] = "Items"
	new pos = 0

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

	show_motd(id,message,title)
	if (saychat==1)
		return PLUGIN_CONTINUE
	return PLUGIN_HANDLED
}

public war3_info(id){
	console_print(id,"---- Warcraft 3 Help: Commands ----")
	console_print(id,"Client:")
	console_print(id,"selectskill - Allows you to select skills before the start of the next round")
	console_print(id,"changerace - Allows you to change race during the game if mp_allowchangerace is 1")
	console_print(id,"playerskills - Shows you what skills other players have chosen")
	console_print(id,"skillsinfo - Shows you what each skill does for the race you have selected")
	console_print(id,"itemsinfo - Shows you a list of items and what they do")
	console_print(id,"war3vote - Vote to switch the plugin on or off")
	console_print(id,"iamadirtycheater - if sv_cheats is 1 then it will set you to level 10")
	console_print(id,"cheatsoff - will set your level back to what it should be")
	console_print(id,"Server:")
	console_print(id,"sv_warcraft3 - Enable/Disable the plugin (default 1, enabled)")
	console_print(id,"sv_allowwar3vote - Enabled/Disable voting (default 1, enabled)")
	console_print(id,"sv_cheats - this is a standard HL cvar, but you need this if you want to cheat :)")
	console_print(id,"mp_allowchangerace - Allow people to change race during the game (default 0, disabled)")
	console_print(id,"mp_forceskin - Forces player to choose skin according to race (default 0, disabled)")
        console_print(id,"mp_grenadeprotection - prevents buying more than 1 HE gren per round (default 1, enabled)")
        console_print(id,"mp_weaponxpmodifier - gives additional XP for using certain weaker weapons (default 1, enabled)")
	console_print(id,"mp_savexp - save XP to a txt file and restore it when player reconnects (default 0)")
	console_print(id,"mp_xpmultiplier - set the level required to gain a level as a multiple (default 1.0)")
	console_print(id,"sv_daysbeforedelete - see warcraft3.txt for more info on this (default 1)")
	console_print(id,"sv_dayslevelmodifier - see warcraft3.txt for more info on this (default 3)")
	console_print(id,"---- Warcraft 3 Help: Commands ----")
	return PLUGIN_HANDLED
}

public saywar3_info(id){
	new message[1024]
	new temp[512]
	new title[64]
	format(title,63,"Warcraft 3 Help")
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
	show_motd(id,message,title)
	return PLUGIN_CONTINUE
}

public cheat(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	if (get_cvar_num("sv_cheats")!=1)
		return PLUGIN_CONTINUE

	cheatson[id]=true

	client_cmd(id,"echo You are now level 10, select your skills from the menu")

	displaylevel(id, 1)

	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	if (skillsused < p_level[id]){
		select_skill(id,0)
	}

	return PLUGIN_HANDLED
}

public cheatsoff(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	if (get_cvar_num("sv_cheats")!=1)
		return PLUGIN_CONTINUE

	cheatson[id]=false

	client_cmd(id,"echo You correct level is now set, select your skills from the menu")

	p_skills[id][1]=0
	p_skills[id][2]=0
	p_skills[id][3]=0
	p_skills[id][4]=0

	displaylevel(id, 1)

	new skillsused = p_skills[id][1]+p_skills[id][2]+p_skills[id][3]+p_skills[id][4]
	if (skillsused < p_level[id]){
		select_skill(id,0)
	}

	return PLUGIN_HANDLED
}

public ultimate(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	if (is_user_alive(id)){
		if (p_skills[id][0]==1 && p_skills[id][4]==1){
			user_kill(id,1)
		}

		if (p_skills[id][0]==2 && p_skills[id][4]==1 && !ultimateused[id] && !endround){	// Telport
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

public searchtarget(parm[2]){
	new id = parm[0]
	new enemy, body
	get_user_aiming(id,enemy,body)
	if ( 0<enemy<=32 && get_user_maxspeed(enemy)>10 && get_user_team(id)!=get_user_team(enemy) && playeritem[enemy]!=IMMUNITY){
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
		stunned[enemy]=true
		waitstop(waitparm)
		new cooldownparm[1]
		cooldownparm[0]=id
		set_task(ENTANGLEROOTS_COOLDOWN,"cooldown",20,cooldownparm,1)
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
		if (parm[1]>0 && get_user_health(id)>0)
			set_task(0.1,"searchtarget",21,parm,2)
		else
			issearching[id]=false
	}
	return PLUGIN_CONTINUE
}

public waitstop(parm[6]){
	new id=parm[0]
	new origin[3]
	get_user_origin(id, origin)
	if (origin[0]==parm[2] && origin[1]==parm[3] && origin[2]==parm[4]){
		new normalspeed = parm[5]
		new resetparm[2]
		resetparm[0]=id
		resetparm[1]=normalspeed
		set_task(float(parm[1]/10),"reset_maxspeed",22,resetparm,2)
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
		new damage = 50
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
		set_task(CHAINLIGHTNING_COOLDOWN,"cooldown",25,cooldownparm,1)
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
		if (parm[1]>0 && get_user_health(id)>=0)
			set_task(0.1,"lightsearchtarget",26,parm,2)
		else
			issearching[id]=false
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
	lightninghit[targetid]=true
	targetdead=false

	if (is_user_alive(targetid))
		targetdead=false
	else
		targetdead=true

	if (get_user_health(targetid)>500){		// Evasion kill
		if (get_user_health(targetid)-damage<=1024){
			set_user_health(targetid, -1)
			targetdied=true
		}
	}
	else if (get_user_health(targetid)-damage<=0)
		targetdied=true

	set_user_health(targetid,get_user_health(targetid)-damage)
	if (get_user_armor(targetid)-damage<=0)
		set_user_armor(targetid,0)
	else
		set_user_armor(targetid,get_user_armor(targetid)-damage)

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
	ultimateused[parm[0]]=false
	return PLUGIN_CONTINUE
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
			if (is_user_alive(targetid))
				targetdead=false
			else
				targetdead=true
			if (get_user_health(targetid)>500){		// Evasion kill
				if (get_user_health(targetid)-damage<=1024){
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
	p_skills[id][0] = 0
	p_skills[id][1] = 0
	p_skills[id][2] = 0
	p_skills[id][3] = 0
	p_skills[id][4] = 0
	p_level[id] = 0
	playerxp[id] = 0
	playeritem[id] = 0
	cheatson[id]=false

	if (is_user_bot(id) && savexp){
		playerxp[id]=xplevel[floatround(random_float(0.0,3.16)*random_float(0.0,3.16))]
		p_skills[id][0] = random_num(1,4)
		return PLUGIN_CONTINUE
	}

	return PLUGIN_CONTINUE
}

// **START OF NEW CODE**
public client_disconnect(id){
	if (savexp && !is_user_bot(id) && p_skills[id][0] && playerxp[id]){
		addtosavequeue(id)
	}
	return PLUGIN_CONTINUE
}
// **END OF NEW CODE**

/*
-------ORIGINAL CODE-------
public client_disconnect(id){
	if (savexp && warcraft3 && !is_user_bot(id) && p_skills[id][0] && playerxp[id]){
		new playerid[32], playername[32], time[32], i=0
		if (get_user_wonid(id)!=-1)
			num_to_str(get_user_wonid(id),playerid,31)	// by wonid
		else
			get_user_authid(id,playerid,31)		// by ip
		while (!equal(savedline[i],"") && i<32){
			i++
		}
		if (i>=32)
			return PLUGIN_CONTINUE
		get_time("%m %d %H %M",time,31)
		get_user_name(id,playername,31)
		format(savedline[i], 127, "%s ^"%s^" %d %d %d %d %d %d %s",playerid,playername,playerxp[id],
			p_skills[id][0],p_skills[id][1],p_skills[id][2],p_skills[id][3],p_skills[id][4], time)
	}
	return PLUGIN_CONTINUE
}
-------END OF ORIGINAL CODE-------
*/

// **START OF NEW CODE** (this code does not replace another function, it is new to 2.20)
public addtosavequeue(id){
	if (p_skills[id][0] && playerxp[id]){
		new playerid[32], playername[32], time[32], i=0
		if (get_user_wonid(id)!=-1)
			num_to_str(get_user_wonid(id),playerid,31)	// by wonid
		else
			get_user_authid(id,playerid,31)		// by ip
		while (!equal(savedline[i],"") && i<64){
			i++
		}
		if (i>=64)
			return PLUGIN_CONTINUE
		get_time("%m %d %H %M",time,31)
		get_user_name(id,playername,31)
		format(savedline[i], 127, "%s ^"%s^" %d %d %d %d %d %d %s",playerid,playername,playerxp[id],
			p_skills[id][0],p_skills[id][1],p_skills[id][2],p_skills[id][3],p_skills[id][4], time)
	}
	return PLUGIN_CONTINUE
}
// **END OF NEW CODE**

// **START OF NEW CODE**
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
		if (savexp){
			get_xp_from_file(id,1)
		}
		else
			select_race(id)
	}

	return PLUGIN_CONTINUE
}
// **END OF NEW CODE**

/*
-------ORIGINAL CODE-------
public forceskin(id,key){

	if (warcraft3==false)
		return PLUGIN_CONTINUE

	changingteam[id]=false

	if (p_skills[id][0]!=0){
		new skin[2]
		num_to_str(p_skills[id][0],skin,1)
		engclient_cmd(id,"menuselect",skin)
		return PLUGIN_HANDLED
	}
	else{
		if (savexp){
			if (maxgetxptime > get_gametime())
				get_xp_from_file(id,1)
			else
				readxp[id]=1
		}
		else
			select_race(id)
	}

	return PLUGIN_CONTINUE
}
-------END OF ORIGINAL CODE-------
*/

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
		if (!savexp)
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

public got_defuse(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	hasdefuse[id]=true
	return PLUGIN_CONTINUE
}

public got_bomb(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	bombplanter=id
	return PLUGIN_CONTINUE
}

public bomb_planted(){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	new origin[3]
	new teamname[32]
	new players[32]
	new numplayers
	new targetorigin[3]
	new targetid
	playerxp[bombplanter]+=BOMBPLANTXP/2
	get_user_origin(bombplanter, origin)
	get_user_team(bombplanter, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
	for (new i=0; i<numplayers; ++i){		// Includes self
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS){
			playerxp[targetid]+=BOMBPLANTXP/2
		}
		displaylevel(targetid, 1)
	}
	return PLUGIN_CONTINUE
}

public bomb_defusing(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	bombdefuser = id
	return PLUGIN_CONTINUE
}

public bomb_defused(){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	new origin[3]
	new teamname[32]
	new players[32]
	new numplayers
	new targetorigin[3]
	new targetid
	playerxp[bombdefuser]+=DEFUSEXP/2
	get_user_origin(bombdefuser, origin)
	get_user_team(bombdefuser, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
	for (new i=0; i<numplayers; ++i){		// Includes self
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=BOMBSHAREXPRADIUS){
			playerxp[targetid]+=DEFUSEXP/2
		}
		displaylevel(targetid, 1)
	}
	return PLUGIN_CONTINUE
}

public host_got(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	new money = read_data(1)
	if (money - pmoney[id] == 150) {
		hostagesaver = id
	}
	pmoney[id] = money
	return PLUGIN_CONTINUE
}

public host_res(){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	new origin[3]
	new teamname[32]
	new players[32]
	new numplayers
	new targetorigin[3]
	new targetid
	playerxp[hostagesaver]+=HOSTAGEXP/2
	get_user_origin(hostagesaver, origin)
	get_user_team(hostagesaver, teamname, 31)
	get_players(players, numplayers, "ae", teamname)
	for (new i=0; i<numplayers; ++i){		// Includes self
		targetid=players[i]
		get_user_origin(targetid, targetorigin)
		if (get_distance(origin, targetorigin)<=HOSTAGESHAREXPRADIUS){
			playerxp[targetid]+=HOSTAGEXP/2
		}
		displaylevel(targetid, 1)
	}
	return PLUGIN_CONTINUE
}

public host_killed(id){
	if (warcraft3==false)
		return PLUGIN_CONTINUE
	playerxp[id]-=xpgiven[p_level[id]]
	displaylevel(id, 1)
	return PLUGIN_CONTINUE
}

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
	else if (equali(said,"^"/war3help^"") || equali(said,"^"war3help^""))
		saywar3_info(id)
	else if (equali(said,"^"/level^"") || equali(said,"^"level^""))
		say_level(id)
	else if (equali(said,"^"/itemsinfo^"") || equali(said,"^"itemsinfo^""))
		items_info(id,1)
	return PLUGIN_CONTINUE
}

public check_war3(){
	if (get_cvar_num("sv_warcraft3")==0){
		warcraft3=false
		block_message(0)
	}
	else{
		warcraft3=true
		block_message(gmsgDeathMsg)
	}
	return PLUGIN_CONTINUE
}

// **START OF NEW CODE**
public write_all(){
	if (warcraft3 && savexp){
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
// **END OF NEW CODE**

/*
-------ORIGINAL CODE-------
public get_write_all(setting){		// setting: 1 - read, 2 - write
	if (warcraft3 && savexp){
		new players[32], numofplayers, id
		get_players(players, numofplayers)
		for (new i=0; i<numofplayers; i++){
			id = players[i]
			if (setting==1)
				get_xp_from_file(id,0)
			if (setting==2){
				if (p_skills[id][0] && playerxp[id])
					write_xp_to_file(id,"")
			}
		}
	}
	return PLUGIN_CONTINUE
}
-------END OF ORIGINAL CODE-------
*/

public write_xp_to_file(id,givenline[128]){
	if (is_user_bot(id) || !savexp)
		return PLUGIN_CONTINUE
	new nextline=0
	new textline[128], textlength, playerid[32], playername[32]
	new xp[8], race[2], time[32], currentrace[2], matchfound
	new skill1[2], skill2[2], skill3[2], skill4[2]
	if (id){
		get_user_name(id,playername,31)
		format(currentrace,1,"%d",p_skills[id][0])
		if (get_user_wonid(id)!=-1)
			num_to_str(get_user_wonid(id),playerid,31)	// by wonid
		else

//			get_user_ip(id,playerid,31)		**Uncomment this line if you want to use IPs. Make sure you comment the next line if you uncomment this one**
			get_user_authid(id,playerid,31)		// by AUTHID (Steam Users)
	}
	else{
		parse(givenline, playerid,31, playername,31, xp,7, currentrace,1)
	}
	if (!mysqlcvar)
	{
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
			get_time("%m %d %H %M",time,31)
			format(textline, 127, "## %s", time)
			write_file(XPFILENAME,textline,2)
			nextline=0
		}
		if (id && playerxp[id] && p_skills[id][0]){
			get_time("%m %d %H %M",time,31)
			format(textline, 127, "%s ^"%s^" %d %d %d %d %d %d %s",playerid,playername,playerxp[id],
				p_skills[id][0],p_skills[id][1],p_skills[id][2],p_skills[id][3],p_skills[id][4], time)
			write_file(XPFILENAME,textline,nextline-1)
		}
		else{
			write_file(XPFILENAME,givenline,nextline-1)
		}
	}
	else{
		new mquery[1024]
		if (id){
			format(mquery, 1023, "REPLACE INTO `%s` SET playerid='%s',playername='%s',xp='%d',race='%d',skill1='%d',skill2='%d', \
				skill3='%d',skill4='%d'",mysqltablename,playerid,playername,playerxp[id], p_skills[id][0], \ 
				p_skills[id][1],p_skills[id][2],p_skills[id][3],p_skills[id][4])
		}
		else{
			parse(givenline, playerid,31, playername,31, xp,7, race,1, skill1,1, skill2,1, skill3,1, skill4,1)
			format(mquery, 1023, "REPLACE INTO `%s` SET playerid='%s',playername='%s',xp='%s',race='%s',skill1='%s',skill2='%s', \
				skill3='%s',skill4='%s'",mysqltablename,playerid,playername,xp, race, skill1,skill2,skill3,skill4)
		}

		mysql_query(mysql,mquery)
		mysql_check_error()
	}
	return PLUGIN_CONTINUE
}

// **START OF MODIFICATION**
public get_xp_from_file(id,returnrace){

	if (!savexp)
		return PLUGIN_CONTINUE

	if (!id)
		return PLUGIN_CONTINUE

	new nextline=0
	new textline[128], textlength, playerid[32], playername[32]
	new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
	new racexp[4]={0,0,0,0}
	new matchfound = 0
	get_user_name(id,playername,31)
	if (get_user_wonid(id)!=-1)
		num_to_str(get_user_wonid(id),playerid,31)	// by wonid
	else
		get_user_authid(id,playerid,31)		// by ip
	if (!mysqlcvar){
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
	}
	else{
		new mquery[1024]
		if (returnrace)
		{
			if (get_cvar_num("mp_savebyname")==1)
				format(mquery, 1023, "SELECT * FROM `%s` WHERE playername='%s'",mysqltablename,playername)
			else
				format(mquery, 1023, "SELECT * FROM `%s` WHERE playerid='%s'",mysqltablename,playerid)
			mysql_query(mysql,mquery)
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
				p_skills[id][1]=str_to_num(skill1)
				p_skills[id][2]=str_to_num(skill2)
				p_skills[id][3]=str_to_num(skill3)
				p_skills[id][4]=str_to_num(skill4)
				displaylevel(id,0)
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
	}
	return PLUGIN_CONTINUE
}
// **END OF MODIFICATION**

/*
-------ORIGINAL CODING-------
public get_xp_from_file(id,returnrace){
	if (!savexp)
		return PLUGIN_CONTINUE

	new nextline=0
	new textline[128], textlength, playerid[32], playername[32]
	new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
	new racexp[4]={0,0,0,0}, menu_msg[256]
	new matchfound = 0
	get_user_name(id,playername,31)
	if (get_user_wonid(id)!=-1)
		num_to_str(get_user_wonid(id),playerid,31)	// by wonid
	else
		get_user_authid(id,playerid,31)		// by ip
	if(!mysqlcvar){
		if (file_exists(XPFILENAME)){
			get_write_all(2)
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
			format(menu_msg,255,"\ySelect Race:\RExperience^n^n\w1. %s\y\R%d^n\w2. %s\y\R%d^n\w3. %s\y\R%d^n\w4. %s\y\R%d^n^n\
				\w5. Auto-select", racename[0], racexp[0], racename[1], racexp[1], racename[2], racexp[2], racename[3], racexp[3])
			show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),menu_msg,-1)
		}
		else if (!nextline){
			playerxp[id]=0
			p_skills[id][1]=0
			p_skills[id][2]=0
			p_skills[id][3]=0
			p_skills[id][4]=0
			displaylevel(id,0)
		}
	}
	else{
		new mquery[1024]
		if (returnrace)
		{
			if (get_cvar_num("mp_savebyname")==1)
				format(mquery, 1023, "SELECT * FROM `%s` WHERE playername='%s'",mysqltablename,playername)
			else
				format(mquery, 1023, "SELECT * FROM `%s` WHERE playerid='%s'",mysqltablename,playerid)
			mysql_query(mysql,mquery)
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
				p_skills[id][1]=str_to_num(skill1)
				p_skills[id][2]=str_to_num(skill2)
				p_skills[id][3]=str_to_num(skill3)
				p_skills[id][4]=str_to_num(skill4)
				displaylevel(id,0)
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
	}
	return PLUGIN_CONTINUE
}
-------END OF ORIGINAL CODE-------
*/

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
		\w5. Auto-select", racename[0], racexp1, racename[1], racexp2, racename[2], racexp3, racename[3], racexp4)
	show_menu(id,(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),menu_msg,-1)
	return PLUGIN_HANDLED
}

public mysql_check_error(){
	new merror[256]
	mysql_error(mysql,merror,255)
	if (merror[0])
	{
		server_print("MYSQL Error Query: %s", merror)
	}
}

public remove_empty_lines(){
	if(!mysqlcvar){
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
	}
	return PLUGIN_CONTINUE
}


public plugin_end(){
	if (!warcraft3 || !savexp)
		return PLUGIN_CONTINUE
	update_file(0)
	change_map()
	if (mysqlcvar)
		mysql_close(mysql)
	return PLUGIN_CONTINUE
}

public change_map(){
	if (!savexp || !warcraft3)
		return PLUGIN_CONTINUE
	new nextline=0
	new textline[128], textlength, playerid[32], playername[32]
	new xp[8], race[2], skill1[2], skill2[2], skill3[2], skill4[2]
	new month[3], day[3], hour[3], minutes[3], temp[3], time[32]
	new currentmonth[3], currentday[3], currenthour[3],dayofyear, currentdayofyear
	new xpnumber, i, playerlevel
	new daysinmonth[12] = {31,28,31,30,31,30,31,31,30,31,30,31}
//	get_write_all(2)
	if(!mysqlcvar){
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
				get_time("%m %d %H %M",time,31)
				format(textline, 127, "## %s", time)
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
						dayofyear = str_to_num(day)+daysbeforedelete+(playerlevel/dayslevelmodifier)
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

/*
-------ORIGINAL CODE-------
public update_file(){
	new i
	new players[32], numofplayers, id
	get_players(players, numofplayers)
	for (i=0; i<numofplayers; i++){
		id = players[i]
		if (readxp[id]==1){
			write_xp_to_file(id,"")
			get_xp_from_file(id,1)
		}
		else if (readxp[id]==2)
			get_xp_from_file(id,0)
	}
	for (i=0; i<33; i++){
		readxp[i]=0
	}
	for (i=0; i<32; i++){
		if (!equal(savedline[i],"")){
			write_xp_to_file(0,savedline[i])
		}
		savedline[i]=""
	}
	if (lastupdate + 600.0 < get_gametime()){
		get_write_all(2)
	}
	lastupdate = get_gametime()	// in seconds
	return PLUGIN_CONTINUE	
}
-------END OF ORIGINAL CODE-------
*/

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
		savexp=true
		xpgiven = {6,8,10,12,14,16,20,24,28,32,40}
		BOMBPLANTXP /= 10
		DEFUSEXP /= 10
		HOSTAGEXP /= 10
		KILLRESCUEMANXP /= 10
		XPBONUS /= 10
		xplevel = {0,100,200,400,800,1600,3200,6400,12800,25600,51200}
		for (new i=0; i<11; i++){
			xplevel[i] =  floatround(xplevel[i] * xpmultiplier)
		}
		daysbeforedelete = get_cvar_num("sv_daysbeforedelete")
		dayslevelmodifier = get_cvar_num("sv_dayslevelmodifier")
		if (!dayslevelmodifier)
			dayslevelmodifier=100		// will cause modifier to be ignored (level/100 = 0)
	}
	return PLUGIN_CONTINUE
}

public menu_item(id,key){
	if (warcraft3==false)
		return PLUGIN_CONTINUE

	if (key==3 && get_cvar_num("mp_grenadeprotection")==1)
	{
		if (hasgrenade[id]){
			engclient_cmd(id,"menuselect","10")
			set_hudmessage(200, 100, 0, -1.0, 0.25, 0, 1.0, 5.0, 0.1, 0.2, 1)
			show_hudmessage(id,"No grenade spamming! One grenade per round maximum.")
		}
		else{
			hasgrenade[id]=true
		}
	}
	return PLUGIN_CONTINUE
}

public shopmenu(id){
        if (warcraft3==false)
                return PLUGIN_CONTINUE

	new pos = 0
	new keys = (1<<0|1<<1|1<<2|1<<3|1<<4|1<<5|1<<6|1<<7|1<<8|1<<9)
	new menu_body[512]
	pos += format(menu_body[pos], 511-pos, "\yBuy Item\R$   Cost^n^n")
	for (new i = 0; i<9; i++){
		pos += format(menu_body[pos], 511-pos, "\w%d. %s\y\R%d^n",i+1,itemname[i],itemcost[i])
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

public set_mysql(){
	if (get_cvar_num("sv_mysql"))
	{
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
		mysqlcvar=true

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

	return PLUGIN_CONTINUE
}

public plugin_init()
{
	gmsgDeathMsg = get_user_msgid("DeathMsg")
	gmsgFade = get_user_msgid("ScreenFade")
	gmsgShake = get_user_msgid("ScreenShake")
	gmsgStatusText = get_user_msgid("StatusText")
	register_plugin("Warcraft 3 XP","2.22.3","SpaceDude")
	register_cvar("Warcraft_3_XP", "2.22",FCVAR_SERVER)
	register_menucmd(register_menuid("\ySelect Race:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4),"set_race")
	register_menucmd(register_menuid("\ySelect Skill:"),(1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<9),"set_skill")
	register_menucmd(register_menuid("\yTeleport to:"),1023,"set_target")
	register_menucmd(register_menuid("\yBuy Item"),1023,"buy_item")
	register_menucmd(register_menuid("Warcraft 3 Plugin:") ,(1<<0)|(1<<1),"vote_count") 
	register_menucmd(register_menuid("Terrorist_Select"),1023,"forceskin")
	register_menucmd(register_menuid("CT_Select"),1023,"forceskin")
	register_menucmd(-26,1023,"forceskin")		// VGUI
	register_menucmd(-27,1023,"forceskin")		// VGUI
	register_menucmd(register_menuid("BuyItem"),1023,"menu_item")
	register_menucmd(-34,1023,"menu_item")
	register_clcmd("changerace","change_race",-1,"changerace")	// mp_allowchangerace must be set to 1
	register_clcmd("selectskill","select_skill",-1,"selectskill")	// Use "selectskill" console command to lvl up
	register_concmd("playerskills","player_skills",-1,"playerskills")
	register_clcmd("skillsinfo","skills_info",-1,"skillsinfo")
	register_clcmd("itemsinfo","items_info",-1,"itemsinfo")
	register_clcmd("war3help","war3_info",-1,"war3help")
	register_clcmd("war3vote","war3_vote",-1,"war3vote")
	register_clcmd("ultimate","ultimate",-1,"ultimate")
	register_clcmd("iamadirtycheater","cheat",-1,"iamadirtycheater")
	register_clcmd("cheatsoff","cheatsoff",-1,"cheatsoff")
	register_clcmd("shopmenu","shopmenu",-1,"shopmenu")
	register_clcmd("say","check_say")
	register_clcmd("say_team","check_say")
	register_srvcmd("display_race_select","display_race_select")		// For internal use only (don't use this this command)
	register_event("SendAudio","end_round","a","2=%!MRAD_terwin","2=%!MRAD_ctwin","2=%!MRAD_rounddraw") 
	register_event("SendAudio","freezetimedone","b","2=%!MRAD_GO","2=%!MRAD_MOVEOUT","2=%!MRAD_LETSGO","2=%!MRAD_LOCKNLOAD")
	register_event("CurWeapon","change_weapon","be","1=1")
	register_event("DeathMsg","death","a")
	register_event("ResetHUD", "new_round", "b")
	register_event("Damage", "damage_event", "b", "2!0")
	register_event("ShowMenu","auto_join","b","4&Team_Select")
	register_event("VGUIMenu","auto_join","b","1=2")
	register_event("ShowMenu","auto_skin","b","4&CT_Select")
	register_event("ShowMenu","auto_skin","b","4&Terrorist_Select")
	register_event("StatusIcon", "got_defuse", "be", "1=1", "1=2", "2=defuser")
	register_event("StatusIcon", "got_bomb", "be", "1=1", "1=2", "2=c4")
	register_event("ArmorType", "armor_type", "be")
	register_event("TextMsg","restart_round","a","2&#Game_will_restart_in")
	register_event("TextMsg","host_killed","b","2&#Killed_Hostage") 
	register_event("SendAudio", "bomb_planted", "a", "2&%!MRAD_BOMBPL")
	register_event("SendAudio", "bomb_defused", "a", "2&%!MRAD_BOMBDEF")
	register_event("SendAudio", "host_res", "a", "2&%!MRAD_rescued")
	register_event("BarTime", "bomb_defusing", "be", "1=10", "1=5")
	register_event("Money","host_got","b","2=1")
	register_cvar("mp_allowchangerace","0",0)
	register_cvar("mp_forceskin","0",0)
	register_cvar("mp_grenadeprotection","1",0)
	register_cvar("mp_savexp","0",FCVAR_SERVER)
	register_cvar("mp_xpmultiplier","1.0")
	register_cvar("mp_savebyname","0")
	register_cvar("mp_weaponxpmodifier","1")
	register_cvar("sv_warcraft3","1",0)
	register_cvar("sv_allowwar3vote","1",0)
	if (!cvar_exists("amx_vote_delay"))
		register_cvar("amx_vote_delay","60")
	if (!cvar_exists("amx_vote_time"))
		register_cvar("amx_vote_time","10")
	if (!cvar_exists("amx_vote_answers"))
		register_cvar("amx_vote_answers","1")
	if (!cvar_exists("amx_mysql_host"))
		register_cvar("amx_mysql_host","127.0.0.1")
	if (!cvar_exists("amx_mysql_user"))
		register_cvar("amx_mysql_user","root")
	if (!cvar_exists("amx_mysql_pass"))
		register_cvar("amx_mysql_pass","")
	if (!cvar_exists("amx_mysql_db"))
		register_cvar("amx_mysql_db","amx")
	register_cvar("amx_votewar3_ratio","0.70")
	register_cvar("sv_daysbeforedelete","1")
	register_cvar("sv_mysql","0")
	register_cvar("sv_mysqltablename","war3users")
	register_cvar("sv_dayslevelmodifier","3")
	set_task(10.0,"check_war3",456,"",0,"b")
	set_task(1.0,"check_war3",457)
	set_task(1.0,"set_longtermxp",458)
	set_task(1.0,"set_mysql",324)
	set_xpmultiplier()
	return PLUGIN_CONTINUE
}
