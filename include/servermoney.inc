/*  Инклуд "Серверные деньги"         
    Автор инклуда: Sanya161RU	  
   --------------------------------------
   Добавить ко всем дефайнам:
   #define GivePlayerMoney GivePlayerCash
   #define GetPlayerMoney GetPlayerCash
   -------------------------------------- 
   Добавить в паблик OnPlayerConnect:
   SetPVarInt(playerid,"PlayerMoney",0);                      
   SetTimerEx("AntiMoneyHack",1000,true,"%i",playerid);
   -------------------------------------- */

#include <a_samp>

#undef MAX_PLAYERS
 const MAX_PLAYERS=50;

forward AntiMoneyHack(playerid);

public AntiMoneyHack(playerid)
{
	if(GetPlayerMoney(playerid)>GetPVarInt(playerid,"PlayerMoney"))
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,GetPVarInt(playerid,"PlayerMoney"));
		return 1;
	}
	if(GetPlayerMoney(playerid)<GetPVarInt(playerid,"PlayerMoney"))
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid,GetPVarInt(playerid,"PlayerMoney"));
		return 1;
	}
	if(GetPlayerMoney(playerid)==GetPVarInt(playerid,"PlayerMoney")) return 1;
	return 0;
}

stock GivePlayerCash(playerid, cash)
{
	SetPVarInt(playerid,"PlayerMoney", GetPVarInt(playerid,"PlayerMoney")+cash);
	return 1;
}

stock GetPlayerCash(playerid)
{
	return GetPVarInt(playerid,"PlayerMoney");
}