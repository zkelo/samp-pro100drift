//==============================================================================
#include <a_samp>
//==============================================================================
forward OnHideMenuForPlayer(Menu:menuid, playerid);
forward OnShowMenuForPlayer(Menu:menuid, playerid);
forward OnDDosAttackAttempt(type, playerid, ip[]);
forward AntiFlood(playerid);
forward PlayerKick(playerid);
forward ShowMessagesCountTop10(playerid);
//==============================================================================
//==============================================================================
new PlayerSlot[MAX_PLAYERS], PlayerName[MAX_PLAYERS][MAX_PLAYER_NAME];
new Configs[20];
new oldpickup[MAX_PLAYERS];
new Menu:MenuShowed[MAX_PLAYERS];
new MessagesCount[MAX_PLAYERS], OtherMessages[MAX_PLAYERS];
//new File:ServerLogFile;
new /*addostimer, */lastchecktime;
new timerhack;
//==============================================================================
native gpci(playerid,const serial[],maxlen);
//==============================================================================
#define F3		1	//Защита от атак неправильного тюнинга | 1 - включено | 0 - выключено
#define F5		1	//Защита от песочницы/ботов | 1 - включено | 0 - выключено
#define F6		1	//Защита от атак по пингу | 1 - включено | 0 - выключено
#define F12		1	//Защита от краша через флуд в KillChat | 1 - включено | 0 - выключено
#define F16		1	//Защита от обработки несуществующих игроков | 1 - включено | 0 - выключено
//==============================================================================
#define MAX_CONNECTIONS_FROM_IP     3 	//максимум подключений с одного ip
//==============================================================================
#define DISALLOWED_ADDRESS "DA0E5085558CCACC88ECCA40C4CEC49A9408EEE8"
#define DISALLOWED_ADDRESS1 "264FCA7D0F73429BD4F98A77AC6B232DDBD3863878C"
#define DISALLOWED_ADDRESS2 "DA0E5085558CCACC88ECCA40C4CEC49A9408EEE8"
//==============================================================================
#define COLOR_RED	                    0xAA3333AA
//==============================================================================
#define MAX_MESSAGES                    5000
#define ATTACK_TYPE_PLAYERID            1
#define ATTACK_TYPE_IP                  2
//==============================================================================

//==============================================================================
stock GetNumberOfPlayersOnThisIP(test_ip[]){
	new against_ip[32+1];
	new x = 0;
	new ip_count = 0;
	for(x=0; x<MAX_PLAYERS; x++) {
		if(IsPlayerConnected(x)) {
		    GetPlayerIp(x,against_ip,32);
		    if(!strcmp(against_ip,test_ip)) ip_count++;
		}
	}
	return ip_count;}
//==============================================================================
public OnFilterScriptInit() {
    new ip[16];
	GetServerVarAsString("bind", ip, sizeof (ip));
	if(!strlen(ip) || strcmp(ip, "127.0.0.1") && strcmp(ip, "127.0.0.1")) { printf("Ошибка безопасности... Неверный IP сервера."); return false; }
	/**************************************************************************/
	for(new i=0; i<MAX_PLAYERS; i++) { MessagesCount[i] = 9999999; }
	/**************************************************************************/
	print("\t---------------------------------------------------------\n");
	print("\t{FF0000}[Античит] {FFFFFF} The Protect SA:MP security: [Загружен 100%]\n");
	print("\t[HOOKIPS]: Успешно подключён к 127.0.0.1:7777\n");
	print("\t[LICENSE]: Сopyright by #Rem © 2013-2014 reserved\n");
	print("\t---------------------------------------------------------\n");
	/**************************************************************************/
    for(new i=0; i<MAX_PLAYERS; i++) MessagesCount[i] = 9999999; SetTimer("NetworkUpdate", 3000, true);
    //addostimer = SetTimer("AntiDDoS", 100, true);
    timerhack = SetTimer("AntyVehHack", 3000, 1);
    /**************************************************************************/
    //ServerLogFile = fileOpen("server_log.txt", io_Read);
	//new FileID = ini_openFile("[DoSProtect]/DoS-Protect_Config.ini");
	new String[10];
	for(new A; A != sizeof(Configs); A++) {
		format(String, 10, "Config%d", A+1); }
		//ini_getInteger(FileID, String, Configs[A]); }
	//ini_closeFile(FileID);
	return 1; }
//==============================================================================
public OnFilterScriptExit(){
	/*KillTimer(addostimer);*/
	KillTimer(timerhack);
	return 1;}
//==============================================================================
public OnPlayerRequestClass(playerid, classid){
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;}
//==============================================================================
public OnPlayerConnect(playerid) {
    new str[100];
	gpci(playerid,str,sizeof(str));
	if(!strcmp(str,DISALLOWED_ADDRESS,true))
	{
		SendClientMessage(playerid, 0xFFFF00, "{FF0000}[Античит] {FFFFFF}Ты был(а) забанен(а) за попытку использования программы c RakSamp платформой.");
		BanEx(playerid,"RakSAMP");
	}
	if(!strcmp(str,DISALLOWED_ADDRESS1,true))
	{
		SendClientMessage(playerid, 0xFFFF00, "{FF0000}[Античит] {FFFFFF}Ты был(а) забанен(а) за попытку использования программы c RakSamp платформой.");
		BanEx(playerid,"RakSAMP");
	}
	if(!strcmp(str,DISALLOWED_ADDRESS2,true))
	{
		SendClientMessage(playerid, 0xFFFF00, "{FF0000}[Античит] {FFFFFF}Ты был(а) забанен(а) за попытку использования программы c RakSamp платформой.");
		BanEx(playerid,"RakSAMP");
	}
	//==========================================================================
	new unk[0x30];
	gpci(playerid, unk, 0x30);
	if(strcmp(unk, "E8CCEEFECEE5E98DD08CDAE88") != -1)
	{
		SendClientMessage(playerid, 0xFFFF00, "{FF0000}[Античит] {FFFFFF}Ты был(а) забанен(а) за попытку использования DDoS программы.");
		BanEx(playerid, "Использование DDoS софта");
    }
    //==========================================================================
    new FP5=F5;
	if(FP5==1){
	new connecting_ip[32+1];
	GetPlayerIp(playerid,connecting_ip,32);
	new num_players_on_ip = GetNumberOfPlayersOnThisIP(connecting_ip);
    //==========================================================================
	if(num_players_on_ip > MAX_CONNECTIONS_FROM_IP) {
		printf("{FF0000}[Античит] {FFFFFF} Connecting player(%d) exceeded %d IP connections from %s.", playerid, MAX_CONNECTIONS_FROM_IP, connecting_ip);
	    Kick(playerid);
	    return 1;
	}}
    //==========================================================================
	new FP16=F16;
	if(FP16==1){
	if(!IsPlayerConnected(playerid)) return Kick(playerid);}
	//==========================================================================
	SendClientMessage(playerid, COLOR_RED, "DoS:Protect - Успешно загружен");
    SendClientMessage(playerid, COLOR_RED, "Разработчик: #Rem");
    SendClientMessage(playerid, COLOR_RED, "Лицензия: 195.211.101.117:7812");
    //==========================================================================
	/*new PlayerIP[2][16];
	GetPlayerName(playerid, PlayerName[playerid], MAX_PLAYER_NAME); GetPlayerIp(playerid, PlayerIP[0], 16);
	if(PlayerSlot[playerid] && Configs[2] != 0) return Slap(playerid, Configs[2], "подключение в один слот", "Connecting a single slot");
	else PlayerSlot[playerid] = true;
	if(Configs[9] != 0) {
		GetPlayerIp(playerid, PlayerIP[0], 16);
		for(new A, B, C = GetMaxPlayers(); A != C; A++) {
			if(!PlayerSlot[A] || IsPlayerNPC(A) || A == playerid) continue;
			GetPlayerIp(A, PlayerIP[1], 16);
			if(!strcmp(PlayerIP[0], PlayerIP[1])) {
				B++;
				if(B == Configs[9]) {
					printf("{FF0000}[Античит] {FFFFFF} Игрок %s был забанен за %d подключений с одного IP", PlayerName[playerid], Configs[9]);
					BanEx(playerid, "{FF0000}[Античит] {FFFFFF} Connecting from the same IP");
					SetPVarInt(playerid, "Kicked", 1); SetPVarInt(playerid, "DialogID", -1);
					return 1; } } } }*/
	return 1;
}
//==============================================================================
public OnGameModeExit() {
	for(new A, B = GetMaxPlayers(); A != B; A++) {
		if(!PlayerSlot[A] || IsPlayerNPC(A)) continue;
		PlayerSlot[A] = false; }
	return true; }
//==============================================================================
public OnPlayerRequestSpawn(playerid) {
    new FP16=F16;
	if(FP16==1){
	if(!IsPlayerConnected(playerid)) return Kick(playerid);}
	MessagesCount[playerid] = 9999999;
	return 1; }
//==============================================================================
public OnPlayerDisconnect(playerid, reason) {
    new FP16=F16;
	if(FP16==1){
	if(!IsPlayerConnected(playerid)) return Kick(playerid);}
	SetPVarInt(playerid, "Kicked", 0);
	PlayerSlot[playerid] = false;
	MessagesCount[playerid] = 99999999;
	return 1; }
//==============================================================================
public OnPlayerCommandText(playerid, cmdtext[]) {
    if(!strcmp(cmdtext, "/DoSPanel", true)) {
        if(!IsPlayerAdmin(playerid))return 1;
        SetTimerEx("ShowMessagesCountTop10", 4000-(GetTickCount()-lastchecktime), false, "d", playerid);
        return 1; }
    return 0; }
//==============================================================================
public OnVehicleDeath(vehicleid, killerid) {
	new GetTime = gettime();
	if(GetPVarInt(killerid, "VehicleDeathTime") > GetTime && Configs[5] != 0) Slap(killerid, Configs[5], "флуд спавном транспорта", "Flood Spawn Vehicle");
	else SetPVarInt(killerid, "VehicleDeathTime", GetTime+5);
	//MessagesCount[playerid] = 9999999;
	return 1; }
//==============================================================================
public OnPlayerStateChange(playerid, newstate, oldstate) {
	if(Configs[6] != 0) {
		if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_PASSENGER
				|| oldstate == PLAYER_STATE_PASSENGER && newstate == PLAYER_STATE_DRIVER) Slap(playerid, Configs[6], "краш OnPlayerStateChange", "Crash OnPlayerStateChange"); }
	MessagesCount[playerid] = 9999999;
	return 1; }
//==============================================================================
public OnRconCommand(cmd[]) { if(!Configs[0]) return 0; return 1; }
//==============================================================================
public PlayerKick(playerid) { Kick(playerid); }
//==============================================================================
public OnPlayerSelectedMenuRow(playerid, row) {
	new iTickCount = GetTickCount();
	if(GetPVarInt(playerid, "PlayerSelectedMenuRowTime") > iTickCount && Configs[7] != 0) Slap(playerid, Configs[7], "флуд OnPlayerSelectedMenuRow", "Flood OnPlayerSelectedMenuRow");
	else SetPVarInt(playerid, "PlayerSelectedMenuRowTime", iTickCount+50);
	MessagesCount[playerid] = 9999999;
	return 1; }
//==============================================================================
public OnRconLoginAttempt(ip[], password[], success) {
	if(!success || !Configs[0]) {
		new IP[16], PasswordFail[MAX_PLAYERS];
		for(new A, B = GetMaxPlayers(); A != B; A++) {
			if(!PlayerSlot[A] || IsPlayerNPC(A)) continue;
			GetPlayerIp(A, IP, 16);
			if(!strcmp(ip, IP)) {
				PasswordFail[A]++;
				if(PasswordFail[A] == Configs[10] || !Configs[0]) {
					printf("{FF0000}[Античит] {FFFFFF} Игрок %s был забанен за попытку взлома RCON", PlayerName[A]);
					BanEx(A, "DoS: RconHack");
					SetPVarInt(A, "Kicked", 1); } } } }
	return 1; }
//==============================================================================
forward NetworkUpdate();
public NetworkUpdate() {
    new stats[300], idx, pos, msgs;
    for(new i=0; i<MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            idx = 0;
            GetPlayerNetworkStats(i, stats, sizeof(stats));
            pos = strfind(stats, "Messages received: ", false, 204); msgs = strval(strtok(stats[pos+19], idx));
            if(msgs - MessagesCount[i] > MAX_MESSAGES) {
                  new pname[MAX_PLAYER_NAME];
                  GetPlayerName(i, pname, sizeof(pname));
                  printf("{FF0000}[Античит] {FFFFFF} id:%d|%s|DoS:Attack(Packets)", pname, i);
                  BanEx(i, "DoS: Packets"); }
            MessagesCount[i] = msgs;
            lastchecktime = GetTickCount(); } } }
//==============================================================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	new iTickCount = GetTickCount();
	if(GetPVarInt(playerid, "DialogResponseTime") > iTickCount && Configs[1] != 0) return Slap(playerid, Configs[1], "флуд диалогами", "Flood Dialogs");
	else SetPVarInt(playerid, "DialogResponse", iTickCount+250);
	if(GetPVarInt(playerid, "DialogID") != dialogid && Configs[8] != 0) return Slap(playerid, Configs[8], "подмену диалогов", "Replance Dialogs");
	SetPVarInt(playerid, "DialogID", -1);
	while(strfind(inputtext, "%s",true) !=-1) {
	   strdel(inputtext,strfind(inputtext, "%s",true),strfind(inputtext, "%s",true)+2); }
	while(strfind(inputtext, "%",true) !=-1) {
	   strdel(inputtext,strfind(inputtext, "%",true),strfind(inputtext, "%",true)+2); }
   	new len = strlen (inputtext);
    for(new i = 0; i < len; ++i) {
        if(inputtext [i] == '%') {
			inputtext [i] = '#';
			MessagesCount[playerid] = 9999999;
			return false; } }
	return 1; }
//==============================================================================
public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
	new GetTime = gettime();
	if(GetPVarInt(playerid, "ClickPlayer") > GetTime && Configs[13] != 0) Slap(playerid, Configs[13], "Click PlayerFlood", "Click Player Flood");
	else SetPVarInt(playerid, "ClickPlayer", GetTime+1);
	MessagesCount[playerid] = 9999999;
	return true; }
//==============================================================================
public OnPlayerPickUpPickup(playerid, pickupid) {
	new GetTime = gettime();
	if(GetPVarInt(playerid, "PickupPickup") > GetTime && Configs[14] != 0) {
		if(pickupid != oldpickup[playerid]) {
			Slap(playerid, Configs[14], "OnPlayerPickupPickupflood", "OnPlayerPickupPickupflood");
			return true; } }
	SetPVarInt(playerid, "PickupPickup", GetTime+1);
	oldpickup[playerid] = pickupid;
	MessagesCount[playerid] = 9999999;
	return true; }
//==============================================================================
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	new iTickCount = GetTickCount();
	if(GetPVarInt(playerid, "Entervehicle") > iTickCount && Configs[17] != 0) Slap(playerid, Configs[17], "флуд OnPlayerEnterVehicle", "Flood OnPlayerEnterVehicle");
	else SetPVarInt(playerid, "Entervehicle", iTickCount+50);
	return true; }
//==============================================================================
public OnPlayerUpdate(playerid) {
    new Float:x,Float:y,Float:z;
	GetPlayerCameraFrontVector(playerid,x,y,z);
	if(x > 1.0 || x < -1.0 || y > 1.0 || y < -1.0 || z > 1.0 || z < -1.0) {
	return false; } MessagesCount[playerid] = 9999999;
	return true; }
//==============================================================================
public OnPlayerText(playerid, text[]) {
	if(strfind(text, "Zeta-Hack.ru PizDoS Bot by AlexDrift", true) != -1) return BanEx(playerid,"DoS: PizDoS_Bot");
	if(strfind(text, "++++Zeta-Hack.ru++++ PizDoS Bot by AlexDrift", true) != -1) return BanEx(playerid,"DoS: PizDoS_Bot");
	if(strfind(text,"PizDoS Bot",true) == 0) return BanEx(playerid, "{FF0000}[Античит] {FFFFFF} DoS:Attack(PizDoS_Bot)");
	if(strfind(text,"[CaypDos]: Автор Caypen",true) == 0) return BanEx(playerid, "DoS: CaypDos");
	
    MessagesCount[playerid] = 9999999;
	return true; }
//==============================================================================
public OnVehiclePaintjob(playerid, vehicleid, paintjobid){
    if(paintjobid>2){
    new FP3=F3;
	if(FP3==1){
    ChangeVehiclePaintjob( vehicleid, 0 );
    SetVehicleToRespawn(vehicleid);
	SetPlayerHealth(playerid,0);
    }}
    return 1;}
//==============================================================================
public OnVehicleMod(playerid, vehicleid, componentid){
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && IsPlayerConnected(playerid)){
	    new Float:Vec[3];
	    GetPlayerCameraFrontVector(playerid, Vec[0], Vec[1], Vec[2]);
	    for(new i = 0; i < sizeof(Vec); i++) if(floatabs(Vec[i]) > 10.0) Kick(playerid);}
	if(componentid!=1010 && GetPlayerInterior(playerid)==0){
	new FP3=F3;
	if(FP3==1){
    RemoveVehicleComponent(vehicleid,componentid);
    SetVehicleToRespawn(vehicleid);
	SetPlayerHealth(playerid,0);
	}}
	return 1;}
//==============================================================================
//==============================================================================
public OnHideMenuForPlayer(Menu:menuid, playerid) {
	if(!IsPlayerConnected(playerid)) return 1;
	new GetTime = gettime();
	if(GetPVarInt(playerid, "HideMenuFlood") > GetTime && Configs[16] != 0)return Slap(playerid, Configs[16], "HideMenuFlood", "HideMenuFlood");
	if(!IsValidMenu(menuid) && GetPVarInt(playerid, "Kicked") == 0 || menuid != MenuShowed[playerid] && GetPVarInt(playerid, "Kicked") == 0) {
		if(playerid != INVALID_PLAYER_ID && playerid <= MAX_PLAYERS)return Slap(playerid, Configs[11], "краш HideMenu", "Crash HideMenu");
		return true; }
	HideMenuForPlayer(menuid, playerid);
	SetPVarInt(playerid, "HideMenuFlood", GetTime+1);
	return 1; }
//==============================================================================
public OnShowMenuForPlayer(Menu:menuid, playerid) {
	if(!IsPlayerConnected(playerid)) return 1;
	if(!IsValidMenu(menuid) && GetPVarInt(playerid, "Kicked") == 0) {
		if(playerid != INVALID_PLAYER_ID && playerid <= MAX_PLAYERS)return Slap(playerid, Configs[12], "краш HideMenu", "Crash HideMenu");
		return true; }
	MenuShowed[playerid] = menuid;
	ShowMenuForPlayer(menuid, playerid);
	return 1; }
//==============================================================================
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys == 128 || newkeys == 16) {
  		if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
     		new Float:vec[3];
       		GetPlayerCameraFrontVector(playerid, vec[0], vec[1], vec[2]);
       		new bool:crasher = false;
         	for (new i = 0; !crasher && i < sizeof(vec); i++)
          	if (floatabs(vec[i]) > 10.0)
           	crasher = true;
            if (crasher)Kick(playerid);
            OtherMessages[playerid]++; } } }
//==============================================================================

//==============================================================================
forward AntyVehHack();
public AntyVehHack(){
    for(new i = GetMaxPlayers()-1; i != -1; --i){
        if(!(2 <= GetPlayerState(i) <= 6)) RemovePlayerFromVehicle(i);
        if(GetPlayerCameraMode(i) == 18 && GetPlayerSpecialAction(i) == 3){
                SendClientMessage(i,0x33AA33AA,"{FF0000}[Античит] {FFFFFF} Ты был(а) кикнут(а) по подозрению в читерстве!");
                Kick(i);}}
    return true;}
//==============================================================================
public OnDDosAttackAttempt(type, playerid, ip[]) {
    new string[128];
    MessagesCount[playerid] = 9999999;
	if(type == ATTACK_TYPE_PLAYERID) {
		BanEx(playerid, "DoS: Packets");
		printf("{FF0000}[Античит] {FFFFFF} | id:%d | %s | DoS:Attack(Packets)", playerid); }
	else if(type == ATTACK_TYPE_IP) {
        format(string, sizeof(string), "banip %s", ip);
		SendRconCommand(string);
		printf("{FF0000}[Античит] {FFFFFF} | id:%d | %s | DoS:Attack(Packets)", ip); } }
//==============================================================================
public ShowMessagesCountTop10(playerid) {
    new stats[300], idx, pos, msgs, SortedArray[MAX_PLAYERS][2], i, string[256], pname[MAX_PLAYER_NAME];
    for(i=0; i<MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            idx = 0;
            GetPlayerNetworkStats(i, stats, sizeof(stats));
            pos = strfind(stats, "Messages received: ", false, 209); msgs = strval(strtok(stats[pos+19], idx));
            SortedArray[i][0] = msgs - MessagesCount[i]; SortedArray[i][1] = i; } }
            
    for(i=0; i<MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            for(new j=0; j<i; j++) {
                if(SortedArray[i][0] > SortedArray[j][0]) {
                    new temp = SortedArray[i][0];
                    SortedArray[i][0] = SortedArray[j][0]; SortedArray[j][0] = temp;
                    temp = SortedArray[i][1];
                    SortedArray[i][1] = SortedArray[j][1]; SortedArray[j][1] = temp; } } } }
                    
    SendClientMessage(playerid, 0xFFFF00AA, "Top 10 high packets players:");
    
    for(i=0; i<10; i++) {
        if(IsPlayerConnected(i)) {
            GetPlayerName(SortedArray[i][1], pname, sizeof(pname));
            format(string, sizeof(string), "%d. %s[id:%d] - %d packets", i+1, pname, SortedArray[i][1], SortedArray[i][0]);
            SendClientMessage(playerid, 0xFFFF00AA, string); } }
    return 1; }
//==============================================================================
stock Slap(playerid, config, reason[], reason2[]) {
	if(!IsPlayerConnected(playerid)) return 1;
	new String[75];
	if(config == 1)
	{
		SetPVarInt(playerid, "Kicked", 1);
		format(String, 75, "{FF0000}[Античит] {FFFFFF} Игрок %s был кикнут за %s", PlayerName[playerid], reason);
		print(String);
		format(String, 75, "%s", reason);
        return BanEx(playerid, String);
	}
	else
	{
		SetPVarInt(playerid, "Kicked", 1);
		SendClientMessage(playerid,0x7FB151FF,"Ты забанен, за попытку DoS!");
		format(String, 75, "[PROTECT:DoS]: Игрок %s был забанен за %s", PlayerName[playerid], reason);
		print(String);
		format(String, 75, "%s", reason2);
		return BanEx(playerid, String);
	} }
//==============================================================================
stock strtok(const string[], &index) {
    new length = strlen(string);
    while ((index < length) && (string[index] <= ' ')) {
        index++; }

    new offset = index; new result[20];
    while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1))) {
        result[index - offset] = string[index];
        index++; }
    result[index - offset] = EOS;
    return result; }
//==============================================================================
stock split(const strsrc[], strdest[][], delimiter){
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;}
		i++;}
	return 1;}
//==============================================================================

//==============================================================================
stock ScanPlayerDosExplode(playerid){
if(IsPlayerInAnyVehicle(playerid)){
new Float:hpcar;
new panelst2,doorst2,lightst2,tirest2;
GetVehicleDamageStatus(GetPlayerVehicleID(playerid),panelst2,doorst2,lightst2,tirest2);
GetVehicleHealth(GetPlayerVehicleID(playerid),hpcar);
if(hpcar==250.0 && doorst2==67372036){
new Float:Xban,Float:Yban,Float:Zban;
GetPlayerPos(playerid, Xban,Yban,Zban);
SetVehicleHealth(GetPlayerVehicleID(playerid),0);
SetPlayerPos(playerid,Xban,Yban,Zban+5);
SetPlayerHealth(playerid, 0);}}return 1;}
//==============================================================================
stock ScanPlayerDosDetal(playerid){
if(IsPlayerInAnyVehicle(playerid)){
new panelst,doorst,lightst,tirest;
GetVehicleDamageStatus(GetPlayerVehicleID(playerid),panelst,doorst,lightst,tirest);
if(panelst==858993459 && doorst==67372036 && lightst==69){
new Float:Xban,Float:Yban,Float:Zban;
GetPlayerPos(playerid, Xban,Yban,Zban);
SetPlayerPos(playerid,Xban,Yban,Zban+5);
SetPlayerHealth(playerid, 0);}}return 1;}
//==============================================================================
stock DosKillChat(playerid){
new FP12=F12;
if(FP12==1){
SetPVarInt(playerid,"K_Chater",GetPVarInt(playerid,"K_Chater") + 1);
if(GetPVarInt(playerid,"K_Chater") > 2){
new steleqepinr[170];
new nameqepinr[MAX_PLAYER_NAME];
GetPlayerName(playerid, nameqepinr, sizeof(nameqepinr));
format(steleqepinr, sizeof(steleqepinr), "Игрок %s [id: %d] получил(а) кик по причине: Флуд в KillChat", nameqepinr,playerid);
SendClientMessageToAll(0xAFAFAFAA, steleqepinr);
Kick(playerid);
}}}
//==============================================================================
stock PingError(playerid){
new FP6=F6;
if(FP6==1){
if(GetPlayerPing(playerid) > 100000){
new steleqepin[170];
new nameqepin[MAX_PLAYER_NAME];
GetPlayerName(playerid, nameqepin, sizeof(nameqepin));
format(steleqepin, sizeof(steleqepin), "Игрок %s [id: %d] получил(а) кик по причине: Высокий Пинг", nameqepin,playerid);
SendClientMessageToAll(0xAFAFAFAA, steleqepin);
Kick(playerid);
}}}
//==============================================================================
stock Project(){
new hack=LOAD;
if(hack<3)for(;;)GameModeExit(),LOAD=hack;else Nwork=1;}
stock DosRconProgram(){
Nwork=0;Project();new FP2=F2;
if(FP2==1) SendRconCommand("rcon 0");
}
//==============================================================================
stock DosBot(fo){
new FP16=F16;
if(FP16==1)Ban(fo);}
//==============================================================================
stock ScanTextAntiBag(text[])
{
for (new ilisy=0;ilisy<strlen(text);ilisy++){
if(text[ilisy]==37 || text[ilisy]==92 || text[ilisy]==123 || text[ilisy]==125 || text[ilisy]==126) text[ilisy]=35;}return 1;}
//==============================================================================
