#include <a_samp>
#include <ARAC_FS>

#undef MAX_PLAYERS
const MAX_PLAYERS = 501;

new Text:ServerTextDrawOne;
new Text:ServerTextDrawTwo;
new Text:ServerTextDrawThree[MAX_PLAYERS];
new Text:ServerTextDrawFour[MAX_PLAYERS];
new Text:ServerTextDrawFive[MAX_PLAYERS];
new ServerTimerOne;
new ServerTimerTwo;
new PlayerMoney[MAX_PLAYERS];
new PlayerScore[MAX_PLAYERS];
new PlayerCombo[MAX_PLAYERS];
new Float:PlayerPositionX[MAX_PLAYERS];
new Float:PlayerPositionY[MAX_PLAYERS];
new Float:PlayerPositionZ[MAX_PLAYERS];
new PlayerTimerOne[MAX_PLAYERS];

forward PlayerUpdate();
forward PlayerDrift();
forward PlayerDriftEnd(Player);

Float:PlayerTheoreticAngle(Player)
{
	new Float:X;
	new Float:Y;
	new Float:Z;
	GetVehiclePos(GetPlayerVehicleID(Player),X,Y,Z);
	new Float:NewX;
	if(X > PlayerPositionX[Player]) NewX = X - PlayerPositionX[Player];
	if(X < PlayerPositionX[Player]) NewX = PlayerPositionX[Player] - X;
	new Float:NewY;
	if(Y > PlayerPositionY[Player]) NewY = Y - PlayerPositionY[Player];
	if(Y < PlayerPositionY[Player]) NewY = PlayerPositionY[Player] - Y;
	new Float:Sinus;
	new Float:Cosinus;
	Cosinus = floatsqroot(floatpower(floatabs(floatsub(X,PlayerPositionX[Player])),2) + floatpower(floatabs(floatsub(Y,PlayerPositionY[Player])),2));
	new Float:TheoreticAngle;
	if(PlayerPositionX[Player] > X && PlayerPositionY[Player] > Y)
	{
		Sinus = asin(NewX / Cosinus);
		TheoreticAngle = floatsub(floatsub(floatadd(Sinus,90),floatmul(Sinus,2)),-90.0);
	}
	if(PlayerPositionX[Player] > X && PlayerPositionY[Player] < Y)
	{
		Sinus = asin(NewX / Cosinus);
		TheoreticAngle = floatsub(floatadd(Sinus,180),180.0);
	}
	if(PlayerPositionX[Player] < X && PlayerPositionY[Player] < Y)
	{
		Sinus = acos(NewY / Cosinus);
		TheoreticAngle = floatsub(floatadd(Sinus,360),floatmul(Sinus,2));
	}
	if(PlayerPositionX[Player] < X && PlayerPositionY[Player] > Y)
	{
		Sinus = asin(NewX / Cosinus);
		TheoreticAngle = floatadd(Sinus,180);
	}
	if(TheoreticAngle == 0.0) GetVehicleZAngle(GetPlayerVehicleID(Player),TheoreticAngle);
	return TheoreticAngle;
}

stock VehicleIsCar(Vehicle)
{
	switch(GetVehicleModel(Vehicle))
	{
	case 480: return 1;
	case 533: return 1;
	case 439: return 1;
	case 555: return 1;
	case 536: return 1;
	case 575: return 1;
	case 534: return 1;
	case 567: return 1;
	case 535: return 1;
	case 566: return 1;
	case 576: return 1;
	case 412: return 1;
	case 445: return 1;
	case 504: return 1;
	case 401: return 1;
	case 518: return 1;
	case 527: return 1;
	case 542: return 1;
	case 507: return 1;
	case 562: return 1;
	case 585: return 1;
	case 419: return 1;
	case 526: return 1;
	case 604: return 1;
	case 466: return 1;
	case 492: return 1;
	case 474: return 1;
	case 546: return 1;
	case 517: return 1;
	case 410: return 1;
	case 551: return 1;
	case 516: return 1;
	case 467: return 1;
	case 426: return 1;
	case 436: return 1;
	case 547: return 1;
	case 405: return 1;
	case 580: return 1;
	case 560: return 1;
	case 550: return 1;
	case 549: return 1;
	case 540: return 1;
	case 491: return 1;
	case 529: return 1;
	case 421: return 1;
	case 602: return 1;
	case 429: return 1;
	case 496: return 1;
	case 402: return 1;
	case 541: return 1;
	case 415: return 1;
	case 589: return 1;
	case 587: return 1;
	case 565: return 1;
	case 494: return 1;
	case 502: return 1;
	case 503: return 1;
	case 411: return 1;
	case 559: return 1;
	case 603: return 1;
	case 475: return 1;
	case 506: return 1;
	case 451: return 1;
	case 558: return 1;
	case 477: return 1;
	case 418: return 1;
	case 404: return 1;
	case 479: return 1;
	case 458: return 1;
	case 561: return 1;
	}
	return 0;
}

stock VehicleSpeed(Vehicle)
{
	new Float:X;
	new Float:Y;
	new Float:Z;
	GetVehicleVelocity(Vehicle,X,Y,Z);
	new Float:Speed;
	Speed = floatsqroot(floatpower(floatabs(X),2.0) + floatpower(floatabs(Y),2.0) + floatpower(floatabs(Z),2.0)) * 200.0;
	return floatround(Speed);
}

public OnFilterScriptInit()
{
	ServerTextDrawOne = TextDrawCreate(320.000000,250.000000,"-");
	TextDrawAlignment(ServerTextDrawOne,2);
	TextDrawBackgroundColor(ServerTextDrawOne,80);
	TextDrawFont(ServerTextDrawOne,1);
	TextDrawLetterSize(ServerTextDrawOne,15.000000,30.000000);
	TextDrawColor(ServerTextDrawOne,80);
	TextDrawSetOutline(ServerTextDrawOne,0);
	TextDrawSetProportional(ServerTextDrawOne,1);
	TextDrawSetShadow(ServerTextDrawOne,1);
	ServerTextDrawTwo = TextDrawCreate(320.000000,395.000000,"~G~ƒpœ˜¦");
	TextDrawAlignment(ServerTextDrawTwo,2);
	TextDrawBackgroundColor(ServerTextDrawTwo,255);
	TextDrawFont(ServerTextDrawTwo,3);
	TextDrawLetterSize(ServerTextDrawTwo,0.500000,1.000000);
	TextDrawColor(ServerTextDrawTwo,-1);
	TextDrawSetOutline(ServerTextDrawTwo,1);
	TextDrawSetProportional(ServerTextDrawTwo,1);
	for(new Player; Player < GetMaxPlayers(); Player++)
	{
		ServerTextDrawThree[Player] = TextDrawCreate(250.000000,405.000000," ");
		TextDrawBackgroundColor(ServerTextDrawThree[Player],255);
		TextDrawFont(ServerTextDrawThree[Player],2);
		TextDrawLetterSize(ServerTextDrawThree[Player],0.200000,1.000000);
		TextDrawColor(ServerTextDrawThree[Player],-1);
		TextDrawSetOutline(ServerTextDrawThree[Player],1);
		TextDrawSetProportional(ServerTextDrawThree[Player],1);
		ServerTextDrawFour[Player] = TextDrawCreate(250.000000,415.000000," ");
		TextDrawBackgroundColor(ServerTextDrawFour[Player],255);
		TextDrawFont(ServerTextDrawFour[Player],2);
		TextDrawLetterSize(ServerTextDrawFour[Player],0.200000,1.000000);
		TextDrawColor(ServerTextDrawFour[Player],-1);
		TextDrawSetOutline(ServerTextDrawFour[Player],1);
		TextDrawSetProportional(ServerTextDrawFour[Player],1);
		ServerTextDrawFive[Player] = TextDrawCreate(250.000000,425.000000," ");
		TextDrawBackgroundColor(ServerTextDrawFive[Player],255);
		TextDrawFont(ServerTextDrawFive[Player],2);
		TextDrawLetterSize(ServerTextDrawFive[Player],0.200000,1.000000);
		TextDrawColor(ServerTextDrawFive[Player],-1);
		TextDrawSetOutline(ServerTextDrawFive[Player],1);
		TextDrawSetProportional(ServerTextDrawFive[Player],1);
	}
	ServerTimerOne = SetTimer("PlayerUpdate",1000,1);
	ServerTimerTwo = SetTimer("PlayerDrift",500,1);
	return 1;
}

public OnFilterScriptExit()
{
	TextDrawDestroy(ServerTextDrawOne);
	TextDrawDestroy(ServerTextDrawTwo);
	for(new Player; Player < GetMaxPlayers(); Player++)
	{
		TextDrawDestroy(ServerTextDrawThree[Player]);
		TextDrawDestroy(ServerTextDrawFour[Player]);
		TextDrawDestroy(ServerTextDrawFive[Player]);
	}
	KillTimer(ServerTimerOne);
	KillTimer(ServerTimerTwo);
	return 1;
}

public OnPlayerConnect(playerid)
{
	TextDrawHideForPlayer(playerid,ServerTextDrawOne);
	TextDrawHideForPlayer(playerid,ServerTextDrawTwo);
	TextDrawHideForPlayer(playerid,ServerTextDrawThree[playerid]);
	TextDrawHideForPlayer(playerid,ServerTextDrawFour[playerid]);
	TextDrawHideForPlayer(playerid,ServerTextDrawFive[playerid]);
	TextDrawSetString(ServerTextDrawThree[playerid]," ");
	TextDrawSetString(ServerTextDrawFour[playerid]," ");
	TextDrawSetString(ServerTextDrawFive[playerid]," ");
	PlayerMoney[playerid] = 0;
	PlayerScore[playerid] = 0;
	PlayerCombo[playerid] = 1;
	PlayerPositionX[playerid] = 0.0;
	PlayerPositionY[playerid] = 0.0;
	PlayerPositionZ[playerid] = 0.0;
	KillTimer(PlayerTimerOne[playerid]);
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	TextDrawHideForPlayer(playerid,ServerTextDrawOne);
	TextDrawHideForPlayer(playerid,ServerTextDrawTwo);
	TextDrawHideForPlayer(playerid,ServerTextDrawThree[playerid]);
	TextDrawHideForPlayer(playerid,ServerTextDrawFour[playerid]);
	TextDrawHideForPlayer(playerid,ServerTextDrawFive[playerid]);
	TextDrawSetString(ServerTextDrawThree[playerid]," ");
	TextDrawSetString(ServerTextDrawFour[playerid]," ");
	TextDrawSetString(ServerTextDrawFive[playerid]," ");
	PlayerMoney[playerid] = 0;
	PlayerScore[playerid] = 0;
	PlayerCombo[playerid] = 1;
	PlayerPositionX[playerid] = 0.0;
	PlayerPositionY[playerid] = 0.0;
	PlayerPositionZ[playerid] = 0.0;
	KillTimer(PlayerTimerOne[playerid]);
	return 1;
}

public PlayerUpdate()
{
	for(new Player; Player < GetMaxPlayers(); Player++)
	{
		if(IsPlayerConnected(Player) && GetPlayerState(Player) == PLAYER_STATE_DRIVER && VehicleIsCar(GetPlayerVehicleID(Player))) GetVehiclePos(GetPlayerVehicleID(Player),PlayerPositionX[Player],PlayerPositionY[Player],PlayerPositionZ[Player]);
	}
	return 1;
}

public PlayerDrift()
{
	for(new Player; Player < GetMaxPlayers(); Player++)
	{
		if(IsPlayerConnected(Player) && GetPlayerState(Player) == PLAYER_STATE_DRIVER && VehicleIsCar(GetPlayerVehicleID(Player)))
		{
			new Float:Angle;
			GetVehicleZAngle(GetPlayerVehicleID(Player),Angle);
			if(floatabs(floatsub(Angle,PlayerTheoreticAngle(Player))) < 90.0 && floatabs(floatsub(Angle,PlayerTheoreticAngle(Player))) > 10.0 && VehicleSpeed(GetPlayerVehicleID(Player)) < 300 && VehicleSpeed(GetPlayerVehicleID(Player)) > 80)
			{
				if(PlayerMoney[Player] == 0 && PlayerScore[Player] == 0 && PlayerCombo[Player] == 1)
				{
					TextDrawShowForPlayer(Player,ServerTextDrawOne);
					TextDrawShowForPlayer(Player,ServerTextDrawTwo);
					TextDrawShowForPlayer(Player,ServerTextDrawThree[Player]);
					TextDrawShowForPlayer(Player,ServerTextDrawFour[Player]);
					TextDrawShowForPlayer(Player,ServerTextDrawFive[Player]);
					TextDrawSetString(ServerTextDrawThree[Player]," ");
					TextDrawSetString(ServerTextDrawFour[Player]," ");
					TextDrawSetString(ServerTextDrawFive[Player]," ");
				}
				PlayerMoney[Player] += floatround(floatabs(floatsub(Angle,PlayerTheoreticAngle(Player))) * (VehicleSpeed(GetPlayerVehicleID(Player)) * 0.1)) / 10;
				PlayerScore[Player] += floatround(floatabs(floatsub(Angle,PlayerTheoreticAngle(Player))) * 3 * (VehicleSpeed(GetPlayerVehicleID(Player)) * 0.1)) / 10;
				PlayerCombo[Player] = PlayerScore[Player] / 1000;
				if(PlayerCombo[Player] < 1) PlayerCombo[Player] = 1;
				new String[100];
				format(String,sizeof(String),"~B~~H~ƒe®©™œ Ÿa špœ˜¦: ~W~~H~%d$",PlayerMoney[Player]);
				TextDrawSetString(ServerTextDrawThree[Player],String);
				format(String,sizeof(String),"~B~~H~O¤kœ Ÿa špœ˜¦: ~W~~H~%d",PlayerScore[Player]);
				TextDrawSetString(ServerTextDrawFour[Player],String);
				format(String,sizeof(String),"~B~~H~Ko¯—o-¯®o›œ¦ež©: ~W~~H~X%d",PlayerCombo[Player]);
				TextDrawSetString(ServerTextDrawFive[Player],String);
				KillTimer(PlayerTimerOne[Player]);
				PlayerTimerOne[Player] = SetTimerEx("PlayerDriftEnd",3000,0,"d",Player);
			}
		}
	}
	return 1;
}

public PlayerDriftEnd(Player)
{
	TextDrawHideForPlayer(Player,ServerTextDrawOne);
	TextDrawHideForPlayer(Player,ServerTextDrawTwo);
	TextDrawHideForPlayer(Player,ServerTextDrawThree[Player]);
	TextDrawHideForPlayer(Player,ServerTextDrawFour[Player]);
	TextDrawHideForPlayer(Player,ServerTextDrawFive[Player]);
	TextDrawSetString(ServerTextDrawThree[Player]," ");
	TextDrawSetString(ServerTextDrawFour[Player]," ");
	TextDrawSetString(ServerTextDrawFive[Player]," ");
	GivePlayerMoney(Player,PlayerMoney[Player]);
	SetPlayerScore(Player,GetPlayerScore(Player) + PlayerScore[Player] * PlayerCombo[Player]);
	PlayerMoney[Player] = 0;
	PlayerScore[Player] = 0;
	PlayerCombo[Player] = 1;
	return 1;
}
