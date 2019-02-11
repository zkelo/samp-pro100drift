#include <a_samp>

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

#define GivePlayerMoney ARAC_GivePlayerMoney
#define GetPlayerMoney ARAC_GetPlayerMoney
#define ResetPlayerMoney ARAC_ResetPlayerMoney