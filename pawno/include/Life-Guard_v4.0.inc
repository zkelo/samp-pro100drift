//================================[Include]=====================================
#include <a_samp>
//=================================[New's]======================================
enum LInfo {
    nName[MAX_PLAYER_NAME],
	Float:nHeal,
	Float:nArm,
	nCash
};
new LifeInfo[MAX_PLAYERS][LInfo];

new LifeStr[144];
new F[4], S[2], Mes[3][144];
new Life;

#define life_getInteger ini_getInteger
#define life_getString ini_getString
#define life_openFile ini_openFile
#define life_closeFile ini_closeFile
#define COLOR_LIGHTREDL 	0xFF6347AA
#define SendAdm         	"[A] Игрок %s [ID %d] Подозревается в читерстве!"
//==============================[Forwards]======================================
forward LifeGuard();
forward LifeRemove(playerid);
//================================[Public]======================================
public LifeGuard()
{
	foreach(new i : Player)
	{
	    if(F[3] == 1 && IsPlayerAdmin(i)) continue;
	    if(GetPVarInt(i, "AntiBreik") > 0) SetPVarInt(i, "AntiBreik", GetPVarInt(i, "AntiBreik") - 1);
	    HealthCheckL(i), ArmourCheckL(i), MoneyCheckL(i), AirBrk(i);
	}
	return true;
}

public LifeRemove(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPVarInt(playerid,"Remove") == 1)
	{
		DeletePVar(playerid,"Remove");
		KillTimer(Life);
		Kick(playerid);
	}
	else if(!IsPlayerInAnyVehicle(playerid) && GetPVarInt(playerid,"Remove") == 1)
	{
		DeletePVar(playerid,"Remove");
		KillTimer(Life);
	}
}

public OnGameModeInit()
{
    LoadCfg(), LoadSlap(), LoadMes();
	SetTimer("LifeGuard",1000,1);
	CallLocalFunction("Life_OnGameModeInit", "");
	return true;
}

public OnPlayerSpawn(playerid)
{
    SetPVarInt(playerid, "AntiBreik", 3);
    SetLifeHeal(playerid, 100.0);
	CallLocalFunction("Life_OnPlayerSpawn", "i",playerid);
	return true;
}

public OnPlayerConnect(playerid)
{
    SetPVarInt(playerid, "AntiBreik", 1000);
    GetPlayerName(playerid, LifeInfo[playerid][nName], MAX_PLAYER_NAME);
    CallLocalFunction("Life_OnPlayerConnect", "i", playerid);
    return true;
}
//===============================[Stock's]======================================
stock SetLifePos(playerid, Float:x, Float:y, Float:z)
{
    SetPlayerPos(playerid, x, y, z);
	SetPVarFloat(playerid, "PosX", x);
	SetPVarFloat(playerid, "PosY", y);
	SetPVarFloat(playerid, "PosZ", z);
	SetPVarInt(playerid, "AntiBreik", 3);
}

stock SetLifeHeal(playerid, Float:Heal)
{
	LifeInfo[playerid][nHeal] = Heal;
	SetPlayerHealth(playerid, Heal);
}

stock SetLifeArmour(playerid, Float: Arm)
{
	LifeInfo[playerid][nArm] = Arm;
	SetPlayerArmour(playerid, Arm);
}

stock GiveLifeMoney(playerid, amount)
{
	LifeInfo[playerid][nCash] += amount;
	GivePlayerMoney(playerid, amount);
}

stock SetLifeMoney(playerid, amount)
{
	LifeInfo[playerid][nCash] = amount;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, amount);
}

stock ResetLifeMoney(playerid)
{
	LifeInfo[playerid][nCash] = 0;
	ResetPlayerMoney(playerid);
}

stock GetLifeMoney(playerid) return LifeInfo[playerid][nCash];

stock HealthCheckL(i)
{
	new Float:Heal;
 	GetPlayerHealth(i, Heal);
  	if(LifeInfo[i][nHeal] < Heal) SetPlayerHealth(i, LifeInfo[i][nHeal]);
   	else LifeInfo[i][nHeal] = Heal;
}

stock ArmourCheckL(i)
{
	new Float:Arm;
 	GetPlayerArmour(i, Arm);
  	if(LifeInfo[i][nArm] < Arm) SetPlayerArmour(i, LifeInfo[i][nArm]);
  	else LifeInfo[i][nArm] = Arm;
}

stock MoneyCheckL(i)
{
	if(GetPlayerMoney(i) > LifeInfo[i][nCash])
	{
		if((GetPlayerMoney(i) - LifeInfo[i][nCash]) > 1) SetLifeMoney(i,LifeInfo[i][nCash]);
	}
}

stock SendAdminMes(color, str[])
{
    foreach(new i : Player) { if(IsPlayerAdmin(i)) SendClientMessage(i, color, str); }
	return true;
}

stock RemoveFromVehicle(playerid)
{
	SetPVarInt(playerid,"Remove", 1);
	RemovePlayerFromVehicle(playerid);
	Life = SetTimerEx("LifeRemove",3000,0,"i",playerid);
	return true;
}

stock AirBrk(playerid)
{
	if(F[2] == 1)
	{
	   	new Float:Pos[4];
	    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	    Pos[3] = floatround(GetPlayerDistanceFromPoint(playerid, GetPVarFloat(playerid, "PosX"), GetPVarFloat(playerid, "PosY"), GetPVarFloat(playerid, "PosZ")));
		if(GetPVarInt(playerid, "AntiBreik") == 0)
		{
			if(GetPVarInt(playerid, "Air") > 1) Slap(playerid);
			if(Pos[3] > 100) Slap(playerid);
		   	else if(Pos[3] < 100 && Pos[3] > 70)
   			{
		   		SetPVarInt(playerid,"Air",GetPVarInt(playerid,"Air") +1);
			   	format(LifeStr, 70, SendAdm, LifeInfo[playerid][nName], playerid);
			   	SendAdminMes(COLOR_LIGHTREDL, LifeStr);
   			}
		}
		SetPVarFloat(playerid, "PosX", Pos[0]);
		SetPVarFloat(playerid, "PosY", Pos[1]);
		SetPVarFloat(playerid, "PosZ", Pos[2]);
	}
	return true;
}

stock Slap(playerid)
{
    if(F[3] == 1 && IsPlayerAdmin(playerid)) return true;
	switch(S[0])
	{
		case 0: return true;
  		case 1: return SendMessage(playerid, COLOR_LIGHTREDL, "%s",Mes[0]), Kick(playerid);
    	case 2: return SendMessage(playerid, COLOR_LIGHTREDL, "%s",Mes[1]), Ban(playerid);
		case 3:
		{
			format(LifeStr, 70, SendAdm, LifeInfo[playerid][nName], playerid);
			return SendAdminMes(COLOR_LIGHTREDL, LifeStr);
		}
	}
	return true;
}

stock SendMessage(playerid, color, fstring[], {Float, _}:...)
{
    static const STATIC_ARGS = 3;
    new n = (numargs() - STATIC_ARGS) * (cellbits / 8);
    if(n)
    {
        new message[128], arg_start, arg_end;
        #emit CONST.alt         fstring
        #emit LCTRL          	5
        #emit ADD
        #emit STOR.S.pri        arg_start
        #emit LOAD.S.alt        n
        #emit ADD
        #emit STOR.S.pri        arg_end
        do
        {
            #emit LOAD.I
            #emit PUSH.pri
            arg_end -= (cellbits / 8);
            #emit LOAD.S.pri   arg_end
        }
        while (arg_end > arg_start);
        #emit PUSH.S          fstring
        #emit PUSH.C          128
        #emit PUSH.ADR        message
        n += (cellbits / 8) * 3;
        #emit PUSH.S          n
        #emit SYSREQ.C        format
        n += (cellbits / 8);
        #emit LCTRL          4
        #emit LOAD.S.alt     n
        #emit ADD
        #emit SCTRL          4
        return SendClientMessage(playerid, color, message);
    }
    else return SendClientMessage(playerid, color, fstring);
}

stock LoadCfg()
{
	if(!fexist("Life-Guard/Config.cfg")) return true;
 	new File = life_openFile("Life-Guard/Config.cfg");
	life_getInteger(File, "F[3]", F[0]);
	life_getInteger(File, "F[8]", F[1]);
	life_getInteger(File, "F[12]", F[2]);
	life_getInteger(File, "F[15]", F[3]);
	life_closeFile(File);
	return true;
}

stock LoadSlap()
{
	if(!fexist("Life-Guard/Slap.cfg")) return true;
 	new File = life_openFile("Life-Guard/Slap.cfg");
	life_getInteger(File, "S[1]", S[0]);
 	life_getInteger(File, "S[2]", S[1]);
  	life_closeFile(File);
	return true;
}

stock LoadMes()
{
	if(!fexist("Life-Guard/Message.cfg")) return true;
 	new File = life_openFile("Life-Guard/Message.cfg");
	life_getString(File, "Mes[0]", Mes[0]);
	life_getString(File, "Mes[1]", Mes[1]);
	life_closeFile(File);
	return true;
}
//=============================[UnDefines]======================================
#if defined _ALS_OnGameModeInit
#undef OnGameModeInit
#else
#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Life_OnGameModeInit

//#if defined _ALS_OnDialogResponse
//#undef OnDialogResponse
//#else
//#define _ALS_OnDialogResponse
//#endif
//#define OnDialogResponse Life_OnDialogResponse

#if defined _ALS_OnPlayerSpawn
#undef OnPlayerSpawn
#else
#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn Life_OnPlayerSpawn

#if defined _ALS_OnPlayerConnect
#undef OnPlayerConnect
#else
#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Life_OnPlayerConnect
//===============================[Defines]======================================
//#define ShowPlayerDialog ShowDialog
#define SetPlayerHealth SetLifeHeal
#define SetPlayerArmour SetLifeArmour
#define SetPlayerPos SetLifePos
#define GetPlayerMoney GetLifeMoney
#define GivePlayerMoney GiveLifeMoney
#define ResetPlayerMoney ResetLifeMoney
#define RemovePlayerFromVehicle RemoveFromVehicle
//==============================[Forwards]======================================
forward Life_OnGameModeInit();
forward Life_OnPlayerSpawn(playerid);
forward Life_OnPlayerConnect(playerid);
//forward Life_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
