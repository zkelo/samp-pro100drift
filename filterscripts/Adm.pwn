#include <a_samp>
#include <dINI>
#include <dutils>
#include <md6>
#include <ARAC_FS>

#pragma unused ret_memcpy

#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_BRIGHTRED 0xFF0000AA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_VIOLET 0x9955DEEE
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_SEAGREEN 0x00EEADDF
#define COLOR_GRAYWHITE 0xEEEEFFC4
#define COLOR_LIGHTNEUTRALBLUE 0xABCDEF66
#define COLOR_GREENISHGOLD 0xCCFFDD56
#define COLOR_LIGHTBLUEGREEN 0x0FFDD349
#define COLOR_NEUTRALBLUE 0xABCDEF01
#define COLOR_LIGHTCYAN 0xAAFFCC33
#define COLOR_LEMON 0xDDDD2357
#define COLOR_MEDIUMBLUE 0x63AFF00A
#define COLOR_NEUTRAL 0xABCDEF97
#define COLOR_BLACK 0x00000000
#define COLOR_NEUTRALGREEN 0x81CFAB00
#define COLOR_DARKGREEN 0x12900BBF
#define COLOR_LIGHTGREEN 0x24FF0AB9
#define COLOR_DARKBLUE 0x300FFAAB
#define COLOR_BLUEGREEN 0x46BBAA00
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_PURPLE 0x800080AA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_RED1 0xFF0000AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BROWN 0x993300AA
#define COLOR_CYAN 0x99FFFFAA
#define COLOR_TAN 0xFFFFCCAA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_KHAKI 0x999900AA
#define COLOR_LIME 0x99FF00AA
#define COLOR_SYSTEM 0xEFEFF7AA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6	0xF0F0F0FF

/* -------------- ���������� � ������ --------- */
// "GetPlayerLevel" - ������������ ��� �������� ������ ������
// "GetPlayerALevel" - ������������ ��� �������� �����-������ ������
// "GetPlayerDLevel" - ������������ ��� �������� �����-������ ������
// "GetPlayerVLevel" - ������������ ��� �������� VIP-������ ������
// "GetPlayerKLevel" - ������������ ��� �������� ����-������ ������
/* ------------------ ����� ------------------- */
#pragma dynamic			30000                           // ������������ ������, ��������� ��� �������

#define ACCOUNT			"/data/accounts/%s.ini"         // ���� � ����� �������� ������
#define BANLIST         "/data/banlist.ini"             // ���� � ����� ��������

#define MAX_WARNS       3                               // ����. ���������� ������
#define PASS_MAXS       15                              // ����. ���������� ������ � ������
#define PASS_MINS       6                               // ���. ���������� ������ � ������
#define MAX_BANS		100                           // ����. ���-�� ���������� �������

#define PARAM_PASS      "Password"                      // �������� "������"
#define PARAM_SKIN      "Skin"                          // �������� "����"
#define PARAM_MONEYS    "Moneys"                        // �������� "������"
#define PARAM_MUTED     "Muted"                         // �������� "��� ����"				(���������� � ��������)
#define PARAM_BANNED    "Banned"                        // �������� "��� ��������"          (���������� � �����)
#define PARAM_WARNS     "Warns"                         // �������� "���������� ������"
#define PARAM_KILLS     "Kills"                         // �������� "���-�� �������"
#define PARAM_DEATHS    "Deaths"                        // �������� "���-�� �������"
#define PARAM_LVL       "Level"                         // �������� "����� �������"
#define PARAM_ALVL      "ALevel"                        // �������� "�����-�������"
#define PARAM_DLVL      "DLevel"                        // �������� "�����-�������"
#define PARAM_KLVL      "KLevel"                        // �������� "����-�������"
#define PARAM_VLVL      "VLevel"                        // �������� "VIP-�������"

new Params[10][512] = { // ��������� ������ ������� ����� �����������, �.�. � ���� ���� ������ �������������� ������
    PARAM_MUTED,
    PARAM_BANNED,
    PARAM_WARNS,
	PARAM_KILLS,
	PARAM_DEATHS,
	PARAM_LVL,
	PARAM_ALVL,
	PARAM_DLVL,
	PARAM_KLVL,
	PARAM_VLVL
};

forward ComputeMuteTime(playerid);
forward OnPlayerRussianCommandText(playerid, cmdtext[]);
forward ComputeBanTime();
forward PlayerKick(playerid);
forward PlayerBan(playerid);

/* ------ ������� ������� ������ ������: ------- */
/* 			�����-������� + ����-�������
	�� ������ �������� ���� "CalcPlayerLevel"   */
/* ------------------- ����� ------------------ */
#define LDLG_ID     	5705
#define LDLG_NAME   	"����"
#define LDLG_STR    	"���� ��� ���������������.\n������� ��� ������:"
// ���������
#define LOGIN_INVPASS   "�� ����� �������� ������. ��������� ����\n{C6C6C6}� ��� �������� %i �������"
#define LOGIN_BAN       "�� ����� �������� ������ ��������� ���.\n�� ���� �������� �� %i ����"
/* ---------------- ����������� --------------- */
#define RDLG_ID			5706
#define RDLG_NAME		"�����������"
#define RDLG_STR		"����� ���������� �� P100D.\n�����������������, ����� ���� ������:"
// ���������
#define REG_INVPASS     "������ ������ ���� ������ �� 6 �� 15 ������"
#define REG_INVPASS2    "� ������ ������������ ����������� �������. ��������� ����"
/* ---------------- ��������� ----------------- */
#define MSG_CONNECT     "{A2FF00}[+] {FFFFFF}%s"
#define MSG_DISCONNECT  "{FF4200}[-] {FFFFFF}%s"
#define MSG_PKICKED     "������������� %s ������ %s. �������: %s"
#define MSG_PMUTED      "%s ������� ��� ���� �� �������������� %s �� %i �����"
#define MSG_PMUTEDP     "� ��� ��� ����. �� ������: %i ���."
#define MSG_PBANNED     "������������� %s ������� %s �� %i �����. �������: %s"
#define MSG_PBANNEDP    "��� ������� ������������. �� ������������� ��������: %i �."
#define MSG_PWARNED     "������������� %s ����� warn %s. �������: %s"
#define MSG_PWARNEDP    "�� �������� warn. ���� �� �������, �� �� ������� ������ ���, � ����� ������� ��� �������� � �����"

#define MSG_APANELAUTH  "������� ������ ��������:"
#define MSG_APANELAUTHY "����������� ������ �������"
#define MSG_APANELAUTHN "����������� ��������� �������: �� ����� �������� ������.\n��������� ����?"

#define MSG_KICKHLP     ".��� [ID] [�������]"
#define MSG_BANHLP      ".��� [ID] [�������] [����� (����)]"
#define MSG_WRNHLP      ".���� [ID] [�������]"
#define MSG_MUTEHLP     ".���� [ID] [����� (�������)]"
#define MSG_GOTOHLP     ".�� [ID]"
#define MSG_GETHLP      ".��� [ID]"
#define MSG_SPECHLP     ".�� [ID]"
#define MSG_UNSPECHLP   ".��� [ID]"
#define MSG_ACHATHLP    ".� [���������]"
#define MSG_SMONEYSHLP  ".������ [ID] [�����]"
#define MSG_SSCOREHLP   ".���� [ID] [���-��]"

#define MSG_CMDDISALLOW "�� �� ��������� ��������������� �������"
#define MSG_UNKNCMD     "����� ������� �� ����������. ����������� ������� ������ ������� ��� ���������������"
/* ---------------- ������� ------------------- */
#define command(%0)		if(!strcmp(CMDar,%0,true))
#define Kick(%0)		SetTimerEx("PlayerKick",1000,false,"i",%0)
#define Ban(%0)			SetTimerEx("PlayerBan",1000,false,"i",%0)
/* -------------------------------------------- */

new strtmp[2048],banCalc;

public OnFilterScriptInit()
{
	print("--------------------------------------");
	print(" �����-������� ���������");
	print("--------------------------------------");
	banCalc = SetTimer("ComputeBanTime",1000,true);
	return 1;
}

public OnFilterScriptExit()
{
	print("--------------------------------------");
	print(" �����-������� ���������");
	print("--------------------------------------");
	KillTimer(banCalc);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	strtmp = GetPlayerParam(playerid,PARAM_BANNED);
	if(strval(strtmp))
	{
	    format(strtmp,sizeof(strtmp),MSG_PBANNEDP,strval(strtmp));
	    SendClientMessage(playerid,COLOR_LIGHTRED,strtmp);
	    Kick(playerid);
	    return 1;
	}
	
	format(strtmp,sizeof(strtmp),MSG_CONNECT,PlayerName(playerid));
	SendClientMessageToAll(-1,strtmp);
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	#pragma unused reason
	
	format(strtmp,sizeof(strtmp),MSG_DISCONNECT,PlayerName(playerid));
	SendClientMessageToAll(-1,strtmp);
	
	DeletePVar(playerid,"Authorized");
	DeletePVar(playerid,"Registered");
	DeletePVar(playerid,"Muted");
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	for(new sc=0; sc<25; sc++) SendClientMessage(playerid,-1,"\t");
	SendClientMessage(playerid,COLOR_TAN,	"============================================================");
	SendClientMessage(playerid,COLOR_LIGHTGREEN,	"\t�������� ��� ����: pro100drift.ru\n");
	SendClientMessage(playerid,COLOR_LIGHTGREEN,	"\t� ����� ������ ��: vk.com/p100d\n\n");
	SendClientMessage(playerid,COLOR_YELLOW,		"\t��� ����������� ���������� ����� �������� � ������� - /help\n");
	SendClientMessage(playerid,COLOR_LIGHTBLUE,		"\t��� ����� ���������� ���� ����������� ������� � ���������� Smarter's Localization\n");
	SendClientMessage(playerid,COLOR_TAN,	"============================================================");
	if(FindPlayerAccount(playerid))
	{
	    SetPVarInt(playerid,"Registered",1);
	    SetPVarInt(playerid,"Authorized",0);
		SendClientMessage(playerid,COLOR_GREENISHGOLD,"\t���� ������� ���������������. ������� /login [��� ������] ��� �����������");
	}
	else
	{
	    SetPVarInt(playerid,"Registered",0);
	    SetPVarInt(playerid,"Authorized",0);
		SendClientMessage(playerid,COLOR_GREENISHGOLD,"\t����� ����������! ������� /register [��� ������] ��� �����������");
	}
	SendClientMessage(playerid,COLOR_TAN,	"============================================================");
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	#pragma unused reason
	
	new pdeaths,kkills;
	pdeaths = strval(GetPlayerParam(playerid,PARAM_DEATHS));
	kkills  = strval(GetPlayerParam(killerid,PARAM_KILLS));
	format(strtmp,sizeof(strtmp),"%i",pdeaths+1);
	SetPlayerParam(playerid,PARAM_DEATHS,strtmp);
	format(strtmp,sizeof(strtmp),"%i",kkills+1);
	SetPlayerParam(killerid,PARAM_KILLS,strtmp);
	
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(!strfind(text,".",true,0))
	{
		OnPlayerRussianCommandText(playerid, text);
		return 0;
	}
	
	if(GetPVarInt(playerid,"Muted"))
	{
	    format(strtmp,sizeof(strtmp),MSG_PMUTEDP,strval(GetPlayerParam(playerid,PARAM_MUTED)));
	    SendClientMessage(playerid,COLOR_GREY,strtmp);
	}
	
	return 1;
}

public OnPlayerRussianCommandText(playerid, cmdtext[])
{
	if(!strval(GetPlayerParam(playerid,PARAM_ALVL)))
	{
		SendClientMessage(playerid,COLOR_GREY,MSG_CMDDISALLOW);
		return 0;
	}

	new CMDar[512],IDxAR,tmpar[512];
	CMDar = strtok(cmdtext,IDxAR);
	
	command(".���")
	{
	    tmpar = strtok(cmdtext,IDxAR);
	    if(!strlen(tmpar))
	    {
	        SendClientMessage(playerid,-1,MSG_KICKHLP);
	        return 1;
	    }
	    new kickedplayerid = strval(tmpar);

	    tmpar = strrest(cmdtext,IDxAR);
	    if(!strlen(tmpar))
	    {
	        SendClientMessage(playerid,-1,MSG_KICKHLP);
	        return 1;
	    }
	    
	    format(strtmp,sizeof(strtmp),MSG_PKICKED,PlayerName(playerid),PlayerName(kickedplayerid),tmpar);
	    SendClientMessageToAll(COLOR_LIGHTRED,strtmp);
	    Kick(kickedplayerid);

		return 1;
	}
	
	command(".���")
	{
	    tmpar = strtok(cmdtext,IDxAR);
	    if(!strlen(tmpar))
	    {
	        SendClientMessage(playerid,-1,MSG_BANHLP);
	        return 1;
	    }
	    new bannedplayerid = strval(tmpar);

	    tmpar = strtok(cmdtext,IDxAR);
	    if(!strlen(tmpar))
	    {
	        SendClientMessage(playerid,-1,MSG_BANHLP);
	        return 1;
	    }
	    strtmp = tmpar;

		tmpar = strtok(cmdtext,IDxAR);
	    if(!strlen(tmpar))
	    {
	        SendClientMessage(playerid,-1,MSG_BANHLP);
	        return 1;
	    }
	    new hours = strval(tmpar);

        SetPlayerParam(bannedplayerid,PARAM_BANNED,tmpar);
        AddPlayerInBanlist(bannedplayerid,hours);
	    format(strtmp,sizeof(strtmp),MSG_PBANNED,PlayerName(playerid),PlayerName(bannedplayerid),hours,strtmp);
	    SendClientMessageToAll(COLOR_LIGHTRED,strtmp);
	    Ban(bannedplayerid);

		return 1;
	}
	
	SendClientMessage(playerid,COLOR_GREY,MSG_UNKNCMD);
	
	return 0;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

stock SignUp(playerid,password[])	// �����������
{
	if(!GetDump(playerid)) return 0;
	format(strtmp,sizeof(strtmp),ACCOUNT,PlayerName(playerid));

	dini_Set(strtmp,PARAM_PASS,md6(password));
	dini_IntSet(strtmp,PARAM_SKIN,GetPlayerSkin(playerid));
	dini_IntSet(strtmp,PARAM_MONEYS,GetPlayerMoney(playerid));
	for(new i=0; i<sizeof(Params); i++)
	{
	    dini_IntSet(strtmp,Params[i],0);
	}
	
	return 1;
}

stock SingIn(playerid)          	// �����������
{
	if(!GetDump(playerid)) return 0;
	format(strtmp,sizeof(strtmp),ACCOUNT,PlayerName(playerid));
	
	SetPlayerSkin(playerid,dini_Int(strtmp,PARAM_SKIN,GetPlayerSkin(playerid)));
	GivePlayerMoney(playerid,dini_Int(strtmp,PARAM_MONEYS,GetPlayerMoney(playerid)));
	for(new i=0; i<sizeof(Params); i++)
	{
	    dini_Int(strtmp,Params[i],0);
	}
	
	if(strval(GetPlayerParam(playerid,PARAM_MUTED)))
	{
	    ComputeMuteTime(playerid);
	    SetTimerEx("ComputeMuteTime",1000,true,"%i",playerid);
	}

	return 1;
}

public ComputeMuteTime(playerid)
{
	new mtimesec = strval(GetPlayerParam(playerid,PARAM_MUTED));
	
	if(mtimesec)
	{
	    mtimesec--;
	    format(strtmp,sizeof(strtmp),"%i",mtimesec);
	    SetPlayerParam(playerid,PARAM_MUTED,strtmp);
	    SetPVarInt(playerid,"Muted",1);
	}
	else SetPVarInt(playerid,"Muted",0);
	
	return 1;
}

stock GetPlayerParam(playerid,param[])  // ���������� STRING
{
	format(strtmp,sizeof(strtmp),ACCOUNT,PlayerName(playerid));
	
	if(dini_Isset(strtmp,param))
	{
	    strtmp = dini_Get(strtmp,param);
	}

	return strtmp;
}

stock SetPlayerParam(playerid,param[],value[])
{
	format(strtmp,sizeof(strtmp),ACCOUNT,PlayerName(playerid));
	dini_Set(strtmp,param,value);
}

stock FindPlayerAccount(playerid)
{
	format(strtmp,sizeof(strtmp),ACCOUNT,PlayerName(playerid));

	if(!dini_Exists(strtmp)) return 0;
	else return 1;
}

stock VerifyPassword(playerid,password[])           // �������� ������
{
	if(!GetDump(playerid)) return 0;
	format(strtmp,sizeof(strtmp),ACCOUNT,PlayerName(playerid));
	
	strtmp = dini_Get(strtmp,PARAM_PASS);
	password = md6(password);
	if(!strcmp(password,strtmp)) return 1;
	else return 0;
}

stock AddPlayerInBanlist(playerid,time) // time - ���-�� �����
{
	for(new q=1; q<MAX_BANS+1; q++)
	{
	    format(strtmp,sizeof(strtmp),"Pl%i",q);
	    if(dini_Isset(BANLIST,strtmp)) continue;
	    
	    dini_Set(BANLIST,strtmp,PlayerName(playerid));
	    
	    strtmp = dini_Get(BANLIST,strtmp);
	    new p[sizeof(strtmp)]; p = strtmp;
	    
	    format(strtmp,sizeof(strtmp),ACCOUNT,p);
	    dini_IntSet(strtmp,PARAM_BANNED,time*60*60*1000);
	}
	return 1;
}

public ComputeBanTime()
{
	for(new z=1; z<MAX_BANS+1; z++)
	{
	    format(strtmp,sizeof(strtmp),"Pl%i",z);
	    if(!dini_Isset(BANLIST,strtmp)) continue;
	    
	    strtmp = dini_Get(BANLIST,strtmp);
	    new p[sizeof(strtmp)]; p = strtmp;
	    format(strtmp,sizeof(strtmp),ACCOUNT,p);
	    
	    new bantime = dini_Int(strtmp,PARAM_BANNED);
	    if(!bantime)
	    {
	    	new strtmp2[64]; format(strtmp2,sizeof(strtmp2),"Pl%i",z);
	        dini_Unset(BANLIST,strtmp2);
	        continue;
	    }
	    
	    bantime = bantime - 1; new bantimestr[128];
	    format(strtmp,sizeof(strtmp),ACCOUNT,p);
	    format(bantimestr,sizeof(bantimestr),"%i",bantime);
	    dini_Set(strtmp,PARAM_BANNED,bantimestr);
	}
	return 1;
}

public PlayerKick(playerid)
{
	Kick(playerid);
}

public PlayerBan(playerid)
{
	Ban(playerid);
}

stock GetDump(playerid)
{
	format(strtmp,sizeof(strtmp),ACCOUNT,PlayerName(playerid));
	if(!dini_Exists(strtmp))
	{
		if(!dini_Create(strtmp)) return 0;
		else return 1;
	}
	else return 1;
}

stock PlayerName(playerid)
{
	GetPlayerName(playerid,strtmp,sizeof(strtmp));
	return strtmp;
}

strrest(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[128];
	while ((index < length) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
