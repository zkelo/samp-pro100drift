#include <a_samp>

#undef MAX_PLAYERS
const MAX_PLAYERS=50;

public OnPlayerUpdate(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid)==PLAYER_STATE_PASSENGER)
	{
	    for(new i; i<MAX_PLAYERS; i++)
	    {
	        if(!IsPlayerInAnyVehicle(i)) continue;
	        if(GetPlayerVehicleID(i)!=GetPlayerVehicleID(playerid)) continue;
	        if(GetPlayerState(i)!=PLAYER_STATE_DRIVER)
	        {
	            if(GetPlayerVehicleSpeed(playerid)>3) SendClientMessage(playerid,-1,"»спользуешь {FFF000}Car Shot? {FFBB00}јй €й €й, как не стыдно! {0078FF} =)");
	        }
	        else continue;
	    }
	}
	
	return 1;
}

stock GetPlayerVehicleSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 100.3;
    return floatround(ST[3]);
}
