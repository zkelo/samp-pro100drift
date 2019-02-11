#include <a_samp>

#if defined ARAC_included
	#endinput
#else
	#define ARAC_included
#endif

#if defined ARAC_MAX_PLAYERS
	#endinput
#else
	#define ARAC_MAX_PLAYERS 70
#endif

new ARAC_PMTimer[ARAC_MAX_PLAYERS];

stock Initialize(playerid)
{
	SetPVarInt(playerid,"ARAC_PMoney",0);
	ARAC_PMTimer[playerid] = SetTimerEx("ARAC_CheckPlayer",1500,true,"i",playerid);
	return 1;
}

stock DeInitialize(playerid)
{
	DeletePVar(playerid,"ARAC_PMoney");
	KillTimer(ARAC_PMTimer[playerid]);
	return 1;
}

stock ARAC_GivePlayerMoney(playerid,money)
{
	return SetPVarInt(playerid,"ARAC_PMoney",GetPVarInt(playerid,"ARAC_PMoney")+money);
}

stock ARAC_GetPlayerMoney(playerid)
{
	return GetPVarInt(playerid,"ARAC_PMoney");
}

stock ARAC_ResetPlayerMoney(playerid)
{
	return SetPVarInt(playerid,"ARAC_PMoney",0);
}

forward ARAC_CheckPlayer(playerid);
public ARAC_CheckPlayer(playerid)
{
	if(GetPVarInt(playerid,"ARAC_PMoney")!=GetPlayerMoney(playerid))
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,GetPVarInt(playerid,"ARAC_PMoney"));
	}
	return 1;
}

#define GivePlayerMoney ARAC_GivePlayerMoney
#define GetPlayerMoney ARAC_GetPlayerMoney
#define ResetPlayerMoney ARAC_ResetPlayerMoney