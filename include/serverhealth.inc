/*  Инклуд "Серверные ХП и броня"         
    Автор инклуда: Sanya161RU	  
   --------------------------------------
   Добавить ко всем дефайнам:
   #define SetPlayerHealth SetPlayerHP
   #define SetPlayerArmour SetPlayerAP
   #define GetPlayerHealth GetPlayerHP
   #define GetPlayerArmour GetPlayerAP
   --------------------------------------
   Добавить в паблик OnPlayerConnect:
   SetPVarFloat(playerid,"PlayerHP",DefaultValue);
   SetPVarFloat(playerid,"PlayerAP",DefaultValue);                      
   SetTimerEx("AntiHealthHack",1000,true,"%i",playerid);
   -------------------------------------- */
#include <a_samp>

#undef MAX_PLAYERS
 const MAX_PLAYERS=50;

//#define GetPVarFloat(%1,%2) if(GetPVarType(%1,%2)==float) return GetPVarInt(%1, %2)
#define DefaultValue 0.1

#if !defined DefaultValue
	#error Define the "DefaultValue" now! Include can't work without this define.
	#error Type of "DefaultValue" must be is float (and be >0.0 and <100.0).
#endif

forward AntiHealthHack(playerid);

public AntiHealthHack(playerid)
{
	if(GetPlayerHealth(playerid)>GetPVarFloat(playerid,"PlayerHP") || GetPlayerArmour(playerid)>GetPVarFloat(playerid,"PlayerAP"))
	{
		return 1;
	}
	if(GetPlayerHealth(playerid)<GetPVarFloat(playerid,"PlayerHP") || GetPlayerArmour(playerid)<GetPVarFloat(playerid,"PlayerAP"))
	{
		return 1;
	}
	if(GetPlayerHealth(playerid)==GetPVarFloat(playerid,"PlayerHP") || GetPlayerArmour(playerid)==GetPVarFloat(playerid,"PlayerAP")) return 1;
	return 0;
}

stock GetPlayerHP(playerid)
{
	return GetPVarFloat(playerid,"PlayerHP");
}

stock GetPlayerAP(playerid)
{
	return GetPVarFloat(playerid,"PlayerAP");
}

stock SetPlayerHP(playerid, Float:health)
{
	SetPlayerHealth(playerid,GetPVarFloat(playerid,"PlayerHP");
	return 1;
}

stock SetPlayerAP(playerid, Float:armour)
{
	SetPlayerArmour(playerid,GetPVarFloat(playerid,"PlayerAP");
	return 1;
}

stock GetPVarFloat(playerid, varname)
{
	if(GetPVarType(playerid,varname)==float) return GetPVarInt(playerid,varname)+0.0;
}