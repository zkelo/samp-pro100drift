forward OnPlayerRazmoroz(playerid);
forward OnPlayerInVehicle(playerid);
forward OnPlayerInVehicle2(playerid);
forward OnPlayerOnVeh(playerid);
forward KickPublic(playerid);
//=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=//
public OnPlayerRazmoroz(playerid) return TogglePlayerControllable(playerid,1);
//=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=//
public OnPlayerInVehicle(playerid)
{
   if(!IsPlayerInAnyVehicle(playerid)) return 1;
   new Float:x, Float:y, Float:z;
   GetPlayerPos(playerid, x, y, z);
   SetPlayerPos(playerid, x, y, z+2);
   SetTimerEx("OnPlayerInVehicle2", 500, false, "i", playerid);
   return 1;
}
public OnPlayerInVehicle2(playerid)
{
   if(!IsPlayerInAnyVehicle(playerid)) return 1;
   KickWithMessage(playerid, 0x33AA33FF, "{FF3030}[AнтиЧит] {E98A8A}Bы были кикнуты. Пpичинa: [NOP RemovePlayerFromVehicle]");
   return 1;
}
public OnPlayerOnVeh(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) return 1;
 	if(GetPVarInt(playerid, "BohelCAR") == 1) return SetPVarInt(playerid,"BohelCAR",0);
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) KickWithMessage(playerid, 0x33AA33FF, "{FF3030}[AнтиЧит] {E98A8A}Bы были кикнуты. Пpичинa: [NOP PutPlayerInVehicle]");
	return 1;
}
public KickPublic(playerid) return Kick(playerid);
//=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=//

stock ShowPlayerDialogID(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	SetPVarInt(playerid,"DialogID",dialogid);
	return ShowPlayerDialog(playerid,dialogid,style,caption,info,button1,button2);
}

stock ST_SetPlayerPosEx(playerid,Float:x,Float:y,Float:z)
{
	TogglePlayerControllable(playerid,0);
	SetTimerEx("OnPlayerRazmoroz", 1000, false, "i", playerid);
	return SetPlayerPos(playerid,Float:x,Float:y,Float:z+1);
}
stock SetPlayerPas(playerid,Float:x,Float:y,Float:z)
{
	return SetPlayerPos(playerid,Float:x,Float:y,Float:z);
}

stock ST_PutPlayerInVehicle(playerid,vehicleid,seatid)
{
	SetPVarInt(playerid,"BohelCAR",0);
	SetPVarInt(playerid,"ac_car_id",vehicleid);
	SetTimerEx("OnPlayerOnVeh", 1000, false, "i", playerid);
	return PutPlayerInVehicle(playerid,vehicleid,seatid);
}
stock ST_RemovePlayerFromVehicle(playerid)
{
	SetTimerEx("OnPlayerInVehicle", 2400, false, "i", playerid);
	return RemovePlayerFromVehicle(playerid);
}

stock ST_GivePlayerMoney(playerid, money)
{
    SetPVarInt(playerid,"R_Money",GetPVarInt(playerid,"R_Money")+money);
	return GivePlayerMoney(playerid, money);
}
stock ST_ResetPlayerMoney(playerid)
{
    SetPVarInt(playerid,"R_Money",0);
	return ResetPlayerMoney(playerid);
}
stock ST_GetPlayerMoney(playerid)
{
	return GetPVarInt(playerid,"R_Money");
}

stock KickWithMessage(playerid, color, message[])
{
	SendClientMessage(playerid, color, message);
	SetTimerEx("KickPublic", GetPlayerPing(playerid)*2, 0, "d", playerid);
	return true;
}
stock Float:ST_GetPlayerHealth(playerid) return GetPVarFloat(playerid,"HealtH");
stock Float:ST_GetPlayerArmour(playerid) return GetPVarFloat(playerid,"ArmouR");
stock ST_SetPlayerHealth(playerid, Float:health)
{
    SetPVarFloat(playerid,"HealtH",health);SetPlayerHealth(playerid, health);
	if(ST_GetPlayerHealth(playerid) >=101.0) ST_SetPlayerHealth(playerid,100.0);
	return 1;
}
stock ST_SetPlayerArmour(playerid, Float:armour)
{
    SetPVarFloat(playerid,"ArmouR",armour);
	return SetPlayerArmour(playerid, armour);
}
stock ST_GivePlayerHealth(playerid,health)
{
	ST_SetPlayerHealth(playerid, ST_GetPlayerHealth(playerid)+health);
 	if(ST_GetPlayerHealth(playerid) >= 101.0) ST_SetPlayerHealth(playerid,100.0);
	return 1;
}
stock ST_SetPlayerSkin(playerid, skinid)
{
    ClearAnimations(playerid, 1);ClearAnimations(playerid);
	return SetPlayerSkin(playerid, skinid);
}
stock ST_SetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size)
{
    DisablePlayerCheckpoint(playerid);
	return SetPlayerCheckpoint(playerid, Float:x, Float:y, Float:z, Float:size);
}
//====================================================//
//#undef MAX_PLAYERS //
//const MAX_PLAYERS = 22;// Количество слотов севрера!
#define ST_MAX_PLAYERS 200
//====================================================//

#define GetPlayerMoney ST_GetPlayerMoney
#define ResetPlayerMoney ST_ResetPlayerMoney
#define GivePlayerMoney ST_GivePlayerMoney
#define RemovePlayerFromVehicle ST_RemovePlayerFromVehicle
#define PutPlayerInVehicle ST_PutPlayerInVehicle
#define ShowPlayerDialog ShowPlayerDialogID
#define SetPlayerHealth ST_SetPlayerHealth
#define SetPlayerArmour ST_SetPlayerArmour
#define GetPlayerHealth ST_GetPlayerHealth
#define GetPlayerArmour ST_GetPlayerArmour
#define SetPlayerPos SetPlayerPas
#define SetPlayerSkin ST_SetPlayerSkin
#define SetPlayerCheckpoint ST_SetPlayerCheckpoint