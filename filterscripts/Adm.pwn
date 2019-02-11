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

/* -------------- Информация о стоках --------- */
// "GetPlayerLevel" - используется для проверки уровня игрока
// "GetPlayerALevel" - используется для проверки админ-уровня игрока
// "GetPlayerDLevel" - используется для проверки дрифт-уровня игрока
// "GetPlayerVLevel" - используется для проверки VIP-уровня игрока
// "GetPlayerKLevel" - используется для проверки килл-уровня игрока
/* ------------------ Общее ------------------- */
#pragma dynamic			30000                           // Пространство памяти, требуемое для скрипта

#define ACCOUNT			"/data/accounts/%s.ini"         // Путь к файлу аккаунта игрока
#define BANLIST         "/data/banlist.ini"             // Путь к файлу банлиста

#define MAX_WARNS       3                               // Макс. количество варнов
#define PASS_MAXS       15                              // Макс. количество знаков в пароле
#define PASS_MINS       6                               // Мин. количество знаков в пароле
#define MAX_BANS		100                           // Макс. кол-во забаненных игроков

#define PARAM_PASS      "Password"                      // Параметр "Пароль"
#define PARAM_SKIN      "Skin"                          // Параметр "Скин"
#define PARAM_MONEYS    "Moneys"                        // Параметр "Деньги"
#define PARAM_MUTED     "Muted"                         // Параметр "Бан чата"				(измеряется в секундах)
#define PARAM_BANNED    "Banned"                        // Параметр "Бан аккаунта"          (измеряется в часах)
#define PARAM_WARNS     "Warns"                         // Параметр "Количество варнов"
#define PARAM_KILLS     "Kills"                         // Параметр "Кол-во убийств"
#define PARAM_DEATHS    "Deaths"                        // Параметр "Кол-во смертей"
#define PARAM_LVL       "Level"                         // Параметр "Общий уровень"
#define PARAM_ALVL      "ALevel"                        // Параметр "Админ-уровень"
#define PARAM_DLVL      "DLevel"                        // Параметр "Дрифт-уровень"
#define PARAM_KLVL      "KLevel"                        // Параметр "Килл-уровень"
#define PARAM_VLVL      "VLevel"                        // Параметр "VIP-уровень"

new Params[10][512] = { // Указывать размер массива нужно обязательно, т.к. в коде этот массив пролистывается циклом
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

/* ------ Формула высчета общего уровня: ------- */
/* 			Дрифт-уровень + Килл-уровень
	За высчет отвечает сток "CalcPlayerLevel"   */
/* ------------------- Логин ------------------ */
#define LDLG_ID     	5705
#define LDLG_NAME   	"Вход"
#define LDLG_STR    	"Этот ник зарегистрирован.\nВведите ваш пароль:"
// Сообщения
#define LOGIN_INVPASS   "Вы ввели неверный пароль. Повторите ввод\n{C6C6C6}У вас осталось %i попыток"
#define LOGIN_BAN       "Вы ввели неверный пароль несколько раз.\nВы были забанены на %i дней"
/* ---------------- Регистрация --------------- */
#define RDLG_ID			5706
#define RDLG_NAME		"Регистрация"
#define RDLG_STR		"Добро пожаловать на P100D.\nЗарегистрируйтесь, введя свой пароль:"
// Сообщения
#define REG_INVPASS     "Пароль должен быть длиной от 6 до 15 знаков"
#define REG_INVPASS2    "В пароле присутствуют запрещённые символы. Повторите ввод"
/* ---------------- Сообщения ----------------- */
#define MSG_CONNECT     "{A2FF00}[+] {FFFFFF}%s"
#define MSG_DISCONNECT  "{FF4200}[-] {FFFFFF}%s"
#define MSG_PKICKED     "Администратор %s кикнул %s. Причина: %s"
#define MSG_PMUTED      "%s получил бан чата от администратора %s на %i минут"
#define MSG_PMUTEDP     "У вас бан чата. До снятия: %i сек."
#define MSG_PBANNED     "Администратор %s забанил %s на %i часов. Причина: %s"
#define MSG_PBANNEDP    "Ваш аккаунт заблокирован. До разблокировки осталось: %i ч."
#define MSG_PWARNED     "Администратор %s выдал warn %s. Причина: %s"
#define MSG_PWARNEDP    "Вы получили warn. Пока он активен, вы не сможете купить дом, а также создать или вступить в банду"

#define MSG_APANELAUTH  "Введите пароль повторно:"
#define MSG_APANELAUTHY "Авторизация прошла успешно"
#define MSG_APANELAUTHN "Авторизация потерпела неудачу: вы ввели неверный пароль.\nПовторить ввод?"

#define MSG_KICKHLP     ".кик [ID] [причина]"
#define MSG_BANHLP      ".бан [ID] [причина] [время (часы)]"
#define MSG_WRNHLP      ".варн [ID] [причина]"
#define MSG_MUTEHLP     ".кляп [ID] [время (секунды)]"
#define MSG_GOTOHLP     ".го [ID]"
#define MSG_GETHLP      ".тпс [ID]"
#define MSG_SPECHLP     ".сл [ID]"
#define MSG_UNSPECHLP   ".псл [ID]"
#define MSG_ACHATHLP    ".а [сообщение]"
#define MSG_SMONEYSHLP  ".деньги [ID] [сумма]"
#define MSG_SSCOREHLP   ".очки [ID] [кол-во]"

#define MSG_CMDDISALLOW "Вы не являетесь администратором проекта"
#define MSG_UNKNCMD     "Такой команды не существует. Внимательно изучите раздел справки для администраторов"
/* ---------------- Макросы ------------------- */
#define command(%0)		if(!strcmp(CMDar,%0,true))
#define Kick(%0)		SetTimerEx("PlayerKick",1000,false,"i",%0)
#define Ban(%0)			SetTimerEx("PlayerBan",1000,false,"i",%0)
/* -------------------------------------------- */

new strtmp[2048],banCalc;

public OnFilterScriptInit()
{
	print("--------------------------------------");
	print(" Админ-система загружена");
	print("--------------------------------------");
	banCalc = SetTimer("ComputeBanTime",1000,true);
	return 1;
}

public OnFilterScriptExit()
{
	print("--------------------------------------");
	print(" Админ-система выгружена");
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
	SendClientMessage(playerid,COLOR_LIGHTGREEN,	"\tПосетите наш сайт: pro100drift.ru\n");
	SendClientMessage(playerid,COLOR_LIGHTGREEN,	"\tА также группу ВК: vk.com/p100d\n\n");
	SendClientMessage(playerid,COLOR_YELLOW,		"\tВсю необходимую информацию можно прочесть в справке - /help\n");
	SendClientMessage(playerid,COLOR_LIGHTBLUE,		"\tДля более комфортной игры рекомендуем скачать и установить Smarter's Localization\n");
	SendClientMessage(playerid,COLOR_TAN,	"============================================================");
	if(FindPlayerAccount(playerid))
	{
	    SetPVarInt(playerid,"Registered",1);
	    SetPVarInt(playerid,"Authorized",0);
		SendClientMessage(playerid,COLOR_GREENISHGOLD,"\tЭтот никнейм зарегистрирован. Введите /login [ваш пароль] для авторизации");
	}
	else
	{
	    SetPVarInt(playerid,"Registered",0);
	    SetPVarInt(playerid,"Authorized",0);
		SendClientMessage(playerid,COLOR_GREENISHGOLD,"\tДобро пожаловать! Введите /register [ваш пароль] для регистрации");
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
	
	command(".кик")
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
	
	command(".бан")
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

stock SignUp(playerid,password[])	// Регистрация
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

stock SingIn(playerid)          	// Авторизация
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

stock GetPlayerParam(playerid,param[])  // Возвращает STRING
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

stock VerifyPassword(playerid,password[])           // Проверка пароля
{
	if(!GetDump(playerid)) return 0;
	format(strtmp,sizeof(strtmp),ACCOUNT,PlayerName(playerid));
	
	strtmp = dini_Get(strtmp,PARAM_PASS);
	password = md6(password);
	if(!strcmp(password,strtmp)) return 1;
	else return 0;
}

stock AddPlayerInBanlist(playerid,time) // time - кол-во часов
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
