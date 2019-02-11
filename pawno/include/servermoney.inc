#include <a_samp>

forward SM_GivePlayerCash(playerid,cash);
forward SM_OnPlayerUPD(playerid);
forward SM_OnGameModeInit();
forward SM_OnPlayerUpdate(playerid);

#undef MAX_PLAYERS
 const MAX_PLAYERS=50;

new PlayerMoney[MAX_PLAYERS];

public SM_OnGameModeInit()
{
    SetTimer("SM_OnPlayerUPD",1000,1);
	return 1;
}

public SM_GivePlayerCash(playerid,cash)
{
	ResetPlayerMoney(playerid);
	if(cash<0 || cash>0) PlayerMoney[playerid] = PlayerMoney[playerid] + cash;
	return 1;
}

public SM_OnPlayerUpdate(playerid){return 1;}

public SM_OnPlayerUPD(playerid)
{
	ResetPlayerMoney(playerid);
	SM_GivePlayerCash(playerid,PlayerMoney[playerid]);
	return 1;
}
