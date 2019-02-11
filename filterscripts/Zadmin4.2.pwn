
/*******************************************************************************
*                      ---=== [Zuc's Admin system] ===---                      *
*                                  "Zadmin"                                    *
*                             --- Version 4.2 ---                              *
*                              "Copyright© Zuc"                                *
*******************************************************************************/

#include <a_samp>
#include <Zdini>

ZucSecurity(){
new secure[][]={"Unarmed (Fist)","Brass K"};
#pragma unused secure
}

new SecondRconPass[]="secondrconpass"; //IMPORTANT: Owner! Remember the password you put here!
#define LanguageToLoad "Zadmin_English"
#define MaxRconLoginAttempts 3 // after these attempts (for wrong pass) player will be kicked!

#define MAX_SERVER_PLAYERS 50 // on players who have a higher ID than this, system will not work!!
new ZadminSignaturePosition=1; // max is '4'
#define MAX_LANGUAGE_TEXTS 455 // do not change this!
new LanguageText[MAX_LANGUAGE_TEXTS+1][256];
#define show_zadmin_log_events

/*******************************************************************************
*                          <=[Variabili e defines]=>                           *
*******************************************************************************/

#define dcmd(%1,%2,%3) if((strcmp((%3)[1],#%1,true,(%2))==0)&&((((%3)[(%2)+1]==0)&&(dcmd_%1(playerid,"")))||(((%3)[(%2)+1]==32)&&(dcmd_%1(playerid,(%3)[(%2)+2]))))) return 1
#define RemoveCapsLock(%1) for ( new ToLowerChar; ToLowerChar < strlen( %1 ); ToLowerChar ++ ) if ( %1[ ToLowerChar ]> 64 && %1[ ToLowerChar ] < 91 ) %1[ ToLowerChar ] += 32

#define MainFolder "ZASystem/"
#define UsersFolder "ZASystem/Users/"
#define ConfigsFolder "ZASystem/Config/"
#define LanguagesFolder "ZASystem/Config/Languages"
#define LanguagesFile "ZASystem/Config/Languages/%s.txt"
#define AkaFile "ZASystem/aka.txt"
#define MaxPlayersRecordFile "ZASystem/MaxPlayersRecord.sav"
#define IpBansFile "ZASystem/IpBans.cfg"
#define ReportedPlayersFile "ZASystem/Reported.txt"
#define KickedPlayersFile "ZASystem/KICKED_PLAYERS.sav"
#define BannedPlayersFile "ZASystem/BANNED_PLAYERS.sav"
#define AnticheatConfigFile "ZASystem/Config/AnticheatConfig.ini"
#define EnableCmdsConfigFile "ZASystem/Config/EnableCmds.ini"
#define OptionsConfigFile "ZASystem/Config/OptionsConfig.ini"
#define CmdsLevelsFile "ZASystem/Config/CmdsLevels.ini"
#define UsersFile "ZASystem/Users/%s.sav"
#define ForbiddenWordsFile "ZASystem/ForbiddenWords.cfg"
#define ForbiddenPartsOfNameFile "ZASystem/ForbiddenPartOfName.cfg"

#define ANTI_WEAPONS
#define ANTI_ARMOUR
#define ANTI_HEALTH
#define ANTI_MONEY
#define ANTI_PING

#define AFK_MAX_SECONDS 45

#define MAX_SERVER_STRING 256
#define ShowZadminSignature

#define PISTOL 22
#define SILENCED_PISTOL 23
#define DEAGLE 24
#define AK47 30
#define M4 31
#define TEC9 32
#define MICRO_UZI 28
#define MP5 29
#define GRENADES 16
#define MOLOTOVS 18
#define TEAR_GAS 17
#define NIGHT_STICK 3
#define KNIFE 4
#define SHOTGUN 25
#define SAWNOFF_SHOTGUN 26
#define COMBAT_SHOTGUN 27
#define MICRO_UZI 28
#define RIFLE 33
#define SNIPER_RIFLE 34
#define RPG 35
#define ROCKET_LAUNCHER 36
#define FLAME_THROWER 37
#define MINIGUN 38
#define SPRAY_PAINT 41
#define FIRE_EXTINGUER 42
#define PARACHUTE 46
#define SACHET_CHARGERS 39
#define DETONATOR 40

/*******************************************************************************
*                            <=[Livelli cmd admin]=>                           *
*******************************************************************************/

#define MUTE_ALL_LEVEL                 /**/ Options[MaxAdminLevel] //
#define UNMUTE_ALL_LEVEL               /**/ Options[MaxAdminLevel] //
#define KICK_ALL_LEVEL                 /**/ Options[MaxAdminLevel] //
#define BAN_ALL_LEVEL                  /**/ Options[MaxAdminLevel] //
#define JAIL_ALL_LEVEL                 /**/ Options[MaxAdminLevel] //
#define UNJAIL_ALL_LEVEL               /**/ Options[MaxAdminLevel] //
#define FREEZE_ALL_LEVEL               /**/ Options[MaxAdminLevel] //
#define UNFREEZE_ALL_LEVEL             /**/ Options[MaxAdminLevel] //
#define SLAP_ALL_LEVEL                 /**/ Options[MaxAdminLevel] //
#define EXPLODE_ALL_LEVEL              /**/ Options[MaxAdminLevel] //
#define GET_ALL_LEVEL                  /**/ Options[MaxAdminLevel] //
#define DIE_ALL_LEVEL                  /**/ Options[MaxAdminLevel] //
#define GIVE_MONEY_ALL_LEVEL           /**/ Options[MaxAdminLevel] //
#define RESET_WEAP_ALL_LEVEL           /**/ Options[MaxAdminLevel] //
#define RESET_ALL_LEVEL                /**/ Options[MaxAdminLevel] //
#define DISARM_ALL_LEVEL               /**/ Options[MaxAdminLevel] //
#define SETSKIN_ALL_LEVEL              /**/ Options[MaxAdminLevel] //
#define WEAPON_ALL_LEVEL               /**/ Options[MaxAdminLevel] //

/*******************************************************************************
*                                 <=[COLORI]=>                                 *
*******************************************************************************/

#define COLOR_YELLOWGREEN 0x9ACD32AA     //verde militare
#define COLOR_GREY 0xAFAFAFAA            //grigio
#define COLOR_LIGHTGREEN 0x81F628AA      //verde chiaro
#define COLOR_YELLOW 0xF6F600AA          //giallo
#define COLOR_LIGHTBLUE 0x33CCFFAA       //azzurro
#define COLOR_BLUE 0x0050F6AA            //blu
#define COLOR_GREEN 0x33AA33AA           // verde
#define COLOR_RED 0xF60000AA             // rosso
#define COLOR_ORANGE 0xFF9900AA          //arancione
#define COLOR_LIGHTRED 0xF60000AA        //rosso acceso
#define COLOR_WHITE 0xFFFFFFFF           //bianco
#define COLOR_BLACK 0x000000AA           //nero
#define COLOR_PINK 0xFF66FFAA            //rosa
#define COLOR_ZADMINBLUE 0x6D4CEBAA      //celeste scuretto
#define COLOR_GOLD 0xE3B515AA            //admins color
#define COLOR_VIP 0x53F6A9AA             //vips color

/*******************************************************************************
*                                <=[VARIABILI]=>                               *
*******************************************************************************/

new name[24],pname[24],incriminato[24],adminname[24],string[MAX_SERVER_STRING],strrep[MAX_SERVER_STRING],str[MAX_SERVER_STRING];
new player;
new PlayersCount;
new AdminsCount;
new PlayerVehicle[MAX_SERVER_PLAYERS];

new VehicleNames[212][] = {
"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
"Jetmax","Hotring","Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B",
"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monstera",
"Monsterb","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
"Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};
new WeaponNames[47][] = {
"Unarmed","Brass Knuckless","Golf Club","Night Stick","Knife","Basketball Bat","Shovel","Pool Cue",
"Katana","Chainsaw","Purple Dildo","White Dildo","Long White Dildo","White Dildo 2","Flowers","Cane",
"Grenades","Tear Gas","Molotovs","Missle1","Missle2","Missle3","Pistol","Silenced Pistol","Desert Eagle","Shotgun",
"Sawnoff Shotgun","Combat Shotgun","Micro UZI","MP5","AK47","M4","Tec9","Rifle","Sniper Rifle","RPG",
"Rocket Launcher","Flame Thrower","Minigun","Sachet Chargers","Detonator","Spry Paint","Fire Extinguer",
"Camera","Nightvision Goggles","Thermal Goggles","Parachute"
};
new Colori[8]={ // Car Colors for command /veh
0,1,2,3,6,56,79,86};

new playerspammer;

new strhd[256];
new RBannedPlayers[100][256],RBannedPlayersCount;
new Text:SchedaReports1;
new Text:SchedaReports2;
new Text:SchedaReports3;
new Text:SchedaReports4;
new Text:SchedaReports5;

enum PlayerData{
     pLoggedin[MAX_SERVER_PLAYERS],
     pScore[MAX_SERVER_PLAYERS],
     pDeaths[MAX_SERVER_PLAYERS],
     pKills[MAX_SERVER_PLAYERS],
     pPassword2[MAX_SERVER_PLAYERS],
	 pAdminlevel[MAX_SERVER_PLAYERS],
	 pCash[MAX_SERVER_PLAYERS],
	 bool:pJailed[MAX_SERVER_PLAYERS],
	 bool:pFreezed[MAX_SERVER_PLAYERS],
	 bool:pMuted[MAX_SERVER_PLAYERS],
	 pMuteWarnings[MAX_SERVER_PLAYERS],
	 pSpamWarnings[MAX_SERVER_PLAYERS],
	 pPingWarnings[MAX_SERVER_PLAYERS],
	 bool:pFlood[MAX_SERVER_PLAYERS],
	 bool:pCFlood[MAX_SERVER_PLAYERS],
	 pFloodding[MAX_SERVER_PLAYERS],
	 bool:pVehicleLocked[MAX_SERVER_PLAYERS],
	 pWarning[MAX_SERVER_PLAYERS],
	 pBanWarning[MAX_SERVER_PLAYERS],
	 pSkin[MAX_SERVER_PLAYERS],
	 pLoginAttempts[MAX_SERVER_PLAYERS],
	 pVip[MAX_SERVER_PLAYERS],
	 pVotesForKick[MAX_SERVER_PLAYERS],
	 pVotesForBan[MAX_SERVER_PLAYERS]};
new Account[MAX_SERVER_PLAYERS][PlayerData];

new bool:MyVoteK[MAX_SERVER_PLAYERS][MAX_SERVER_PLAYERS];
new bool:MyVoteB[MAX_SERVER_PLAYERS][MAX_SERVER_PLAYERS];
new bool:MyVoteC[MAX_SERVER_PLAYERS];
new bool:VoteCcarsActive;
new bool:PlayerInVotekick[MAX_SERVER_PLAYERS];
new bool:PlayerInVoteban[MAX_SERVER_PLAYERS];
new bool:IsVoteBanStarted[MAX_SERVER_PLAYERS];
new bool:JustSpawned[MAX_SERVER_PLAYERS];
new bool:IsBot[MAX_SERVER_PLAYERS];
new VotesForCcars;
new VoteKickTimer[MAX_SERVER_PLAYERS];
new VoteBanTimer[MAX_SERVER_PLAYERS];
new VoteCcarsTimer;

new Float:X1[MAX_SERVER_PLAYERS],Float:Y1[MAX_SERVER_PLAYERS],Float:Z1[MAX_SERVER_PLAYERS];
new Float:X2[MAX_SERVER_PLAYERS],Float:Y2[MAX_SERVER_PLAYERS],Float:Z2[MAX_SERVER_PLAYERS];
new Float:health1,Float:health2;
new Var1[MAX_SERVER_PLAYERS];
new PlayerAfkTime[MAX_SERVER_PLAYERS];
new Text3D:AfkPlayerLabels[MAX_SERVER_PLAYERS];
new AfkTimer[MAX_SERVER_PLAYERS];
new AfkTimer2[MAX_SERVER_PLAYERS];
new bool:IsAFK[MAX_SERVER_PLAYERS];

new ForbiddenWords[100][MAX_SERVER_STRING],ForbiddenWordCount;
new ForbiddenPartOfName[50][MAX_SERVER_STRING],ForbiddenPartOfNameCount;
enum ServerData{ // Cmds Enable/Disable
  VoteKick,VoteBan,VoteCcars, Veh, GiveCar, Pm,
  Heal, Armour, GetIp, Jetpack, Mute, UnMute,
  GetVHealth, SetVHealth, Spec, SpecOff,
  kick, ban, SavePersonalCar, Fix, Flip,
  Jail, UnJail, GiveMoney, Reset, ResetWarnings,
  Freeze, UnFreeze, Die, Slap, SaveSkin,
  Goto, Get, TelePlayer, VGoto, VGet,
  Explode, Setskin, SetskinToMe, Setscore,
  Setweather, Setplayerweather,
  Settime, Setplayertime,PlayerData2,
  ClearChat, Gmx, Ccars,
  TempAdmin, MakeAdmin, MakeMeGodAdmin,
  Weapon, Count2, MakeVip, RemoveVip,
  Setplayerinterior, God, SGod,
  ChangeName, Warn, BanWarn, Lock, UnLock, CarColor, Crash,
  Burn, Disarm,RemoveWeapon,Eject, SetName,
  Setgravity, AChat, Announce, ForbidWord};
new ServerInfo[ServerData];

new pWorld;
new bool:AllowFixing[MAX_SERVER_PLAYERS];
new bool:Spectated[MAX_SERVER_PLAYERS];

enum ServerOptions{ // Options
  AntiSpawnKill,AntiSpawnKillSeconds,MaxVotesForKick,MaxVotesForBan,
  MaxVotesForCcars,AFKSystem, AutoLogin, RegisterInDialog, AntiSpam,
  Readcmds, AntiFlood, AllowCmdsOnAdmins,AntiBots,RconSecurity,
  AntiSwear, AntiForbiddenPartOfName,
  Language[128], ConnectMessages, AdminColor, AntiCmdFlood,
  AutomaticAdminColor, MaxAdminLevel,MaxVipLevel, MaxMoney,
  MaxHealth, MaxArmour, MustRegister, MustLogin,
  MaxPing, MaxPingWarnings, MaxMuteWarnings, MaxSpamWarnings, MaxFloodTimes,
  MaxFloodSeconds,MaxCFloodSeconds, ServerWeather,AntiCapsLock,
  MaxWarnings, MaxBanWarnings, AntiDriveBy, AntiHeliKill,
  // anti weapons hack //
  AntiJetpack, AntiMinigun, AntiRPG, AntiBazooka,
  AntiMolotovs, AntiGrenades, AntiSachetChargers, AntiDetonator,
  AntiTearGas, AntiFlameThrower, AntiShotgun, AntiSawnoffShotgun,
  AntiCombatShotgun, AntiRifle, AntiRifleSniper,
  AntiSprayPaint, AntiFireExtinguer};
new Options[ServerOptions];

enum CommandLevels{
  Veh, GiveCar, Mute, UnMute, Spec, SpecOff,
  kick, ban, Fix, Flip, SaveSkin, Jail, UnJail,
  GiveMoney, GetVHealth, SetVHealth, Reset, GetIp,
  ResetWarnings, Heal, Armour, Jetpack, Freeze,
  UnFreeze, Die, Slap, Goto, Get, TelePlayer,
  VGoto, VGet, Explode, Setskin, SetskinToMe, Setscore,
  Setweather, Setplayerweather, Settime, Setplayertime,PlayerData2,
  ClearChat, Gmx, Ccars, TempAdmin, MakeAdmin, MakeMeGodAdmin,
  Weapon, Count2, MakeVip, RemoveVip, Setplayerinterior,
  God, SGod, Anticheat, EnableCommands,
  ChangeName, Warn, BanWarn, SetOptions, Lock, UnLock,
  CarColor, Crash, Burn, Disarm,RemoveWeapon,Eject,
  SetName, Setgravity, AChat, Announce ,ForbidWord};
new CmdsOptions[CommandLevels];

new bool:ServerOK;
new bool:Banned[MAX_SERVER_PLAYERS];
new bool:Warninging[MAX_SERVER_PLAYERS];
new bool:BanWarninging[MAX_SERVER_PLAYERS];
new bool:CountActive;
new bool:GodActive[MAX_SERVER_PLAYERS];
new bool:Spawned[MAX_SERVER_PLAYERS];
new bool:IsRealRconAdmin[MAX_SERVER_PLAYERS];
new tempo0,tempo1,tempo2,tempo3,tempo4;
new MuteTimer[MAX_SERVER_PLAYERS];
new JailTimer[MAX_SERVER_PLAYERS];
new Count3;
new CARS[5000];
new Text:testo;
new NumeroAuto;
new RconLoginAttempts[MAX_SERVER_PLAYERS];

new LastReport1[MAX_SERVER_STRING];
new LastReport2[MAX_SERVER_STRING];
new LastReport3[MAX_SERVER_STRING];

new RegistrationDialog=100;
new LoginDialog=101;
new LogoutDialog=102;
new ChangePass1Dialog=103;
new ChangePass2Dialog=104;
new RconSafeCode=105;
new EnableCommandsDialog1=106;
new EnableCommandsDialog2=107;
new EnableCommandsDialog3=108;
new AnticheatItemsDialog=109;
new ServerOptionsDialog=110;
new ServerOptionsDialog2=111;

new CmdPmDialog=112;
new CmdKickDialog=113;
new CmdBanDialog=114;
new CmdFixDialog=115;
new CmdFlipDialog=116;
new CmdSpecDialog=117;
new CmdSpecoffDialog=118;
new CmdJailDialog=119;
new CmdUnjailDialog=120;
new CmdFreezeDialog=121;
new CmdUnfreezeDialog=122;
new CmdHealDialog=123;
new CmdArmourDialog=124;
new CmdGetipDialog=125;
new CmdGetVHealthDialog=126;
new CmdSetVHealthDialog=127;
new CmdMuteDialog=128;
new CmdUnmuteDialog=129;
new CmdResetDialog=130;
new CmdSetskinDialog=131;
new CmdSetskinToMeDialog=132;
new CmdSetscoreDialog=133;
new CmdSlapDialog=134;
new CmdDieDialog=135;
new CmdGivemoneyDialog=136;
new CmdExplodeDialog=137;
new CmdSavePCarDialog=138;
new CmdGetDialog=139;
new CmdGotoDialog=140;
new CmdVgetDialog=141;
new CmdVgotoDialog=142;
new CmdTeleplayerDialog=143;
new CmdGivecarDialog=144;
new CmdSettimeDialog=145;
new CmdSetweatherDialog=146;
new CmdGmxDialog=147;
new CmdCchatDialog=148;
new CmdCcarsDialog=149;
new CmdTempadminDialog=150;
new CmdMakeadminDialog=151;
new CmdMakeVipDialog=152;
new CmdRemoveVipDialog=153;
new CmdMakemegodadminDialog=154;
new CmdSetplayerinteriorDialog=155;
new CmdSetplayertimeDialog=156;
new CmdPlayerData2Dialog=157;
new CmdSetplayerweatherDialog=158;
new CmdWeaponDialog=159;
new CmdCountDialog=160;
new CmdAsayDialog=161;
new CmdAnnounceDialog=162;
new CmdLockDialog=163;
new CmdUnlockDialog=164;
new CmdCarcolorDialog=165;
new CmdSetnameDialog=166;
new CmdCrashDialog=167;
new CmdBurnDialog=168;
new CmdDisarmDialog=169;
new CmdRemoveWeaponDialog=170;
new CmdVehDialog=171;
new CmdJetpackDialog=172;
new CmdSaveskinDialog=173;

new AntiJetpackDialog=174;
new AntiMinigunDialog=175;
new AntiRpgDialog=176;
new AntiBazookaDialog=177;
new AntiFlameThrowerDialog=178;
new AntiMolotovsDialog=179;
new AntiGrenadesDialog=180;
new AntiSachetChargersDialog=181;
new AntiDetonatorDialog=182;
new AntiTearGasDialog=183;
new AntiShotgunDialog=184;
new AntiSawnoffShotgunDialog=185;
new AntiCombatShotgunDialog=186;
new AntiRifleDialog=187;
new AntiRifleSniperDialog=188;
new AntiSprayPaintDialog=189;
new AntiFireExtinguerDialog=190;

new AntiSpawnKillDialog=191;
new AntiBotsDialog=192;
new RconSecurityDialog=193;
new ReadCmdsDialog=194;
new AutoLoginDialog=195;
new MaxVotesForKickDialog=196;
new MaxVotesForBanDialog=197;
new MaxVotesForCcarsDialog=198;
new AFKSystemDialog=199;
new ConnectMessagesDialog=200;
new AutomaticAdminColorDialog=201;
new AntiFloodDialog=202;
new AntiSpamDialog=203;
new AntiSwearDialog=204;
new AntiForbiddenPartOfNameDialog=205;
new LanguageDialog=206;
new MaxMoneyDialog=207;
new MaxHealthDialog=208;
new MaxArmourDialog=209;
new MaxPingDialog=210;
new MaxPingWarningsDialog=211;
new MaxMuteWarningsDialog=212;
new MaxSpamWarningsDialog=513;
new MaxFloodTimesDialog=214;
new MaxFloodSecondsDialog=215;
new MaxCFloodSecondsDialog=216;
new AllowCmdsOnAdminsDialog=217;
new RegisterInDialogDialog=218;
new MustRegisterDialog=219;
new MustLoginDialog=220;
new MaxWarningsDialog=221;
new MaxBanWarningsDialog=222;
new AntiDriveByDialog=223;
new AntiHeliKillDialog=224;
new AntiCapsLockDialog=225;

/*******************************************************************************
*                                 <=[FORWARDS]=>                               *
*******************************************************************************/

forward ServerConfiguration();
forward AntiHealthHack();
forward AntiWeaponsHack();
forward AntiHighPing();
forward SavePlayerStat();
forward OpeningFS();
forward FloodTimer(playerid);
forward CFloodTimer(playerid);
forward CountTimer();
forward CountReady();
forward UnMutePlayerTimer(playerid);
forward UnJailPlayerTimer(playerid);
forward ReFreezePlayer(playerid);
forward ReJailPlayer(playerid);
forward SpawnPlayerZ(playerid);
forward StopVoteKickPlayer(playerid);
forward StopVoteBanPlayer(playerid);
forward StopVoteCcars();
forward StopWarninging(playerid);
forward StopBanWarninging(playerid);
forward AllowPlayerFixing(playerid);
forward CheckPlayersAFK(playerid);
forward JustSpawnedDelete(playerid);
forward SpawnKillFunction(playerid);
forward CheckIfIsPlayerBot(playerid);
forward ReactiveAfkTimer(playerid);
forward RconChanger();
forward AntiDriveByTimer();

Float:GetDistance(Float:x1,Float:y1,Float:z1,Float:xx,Float:yy,Float:zz){
  return Float:floatsqroot(floatpower(floatabs(floatsub(xx,x1)),2)+floatpower(floatabs(floatsub(yy,y1)),2)+floatpower(floatabs(floatsub(zz,z1)),2));}

/*******************************************************************************
*                                 <=[ZASystem]=>                               *
*******************************************************************************/

public OnFilterScriptInit(){
	PlayersCount=0;
    NumeroAuto=2000;
    LastReport1="No report";
    LastReport2="No report";
    LastReport3="No report";
    
    new lanfile[256];
    format(lanfile,sizeof(lanfile),LanguagesFile);
    if(!dini_Isset(lanfile,"Language")) dini_Set(lanfile,"Language","Zadmin_English");
    LoadLanguage(LanguageToLoad);
    
	#if defined ShowZadminSignature
	if(ZadminSignaturePosition<1 || ZadminSignaturePosition>4)ZadminSignaturePosition=3; // "3" is the standard one.
	if(ZadminSignaturePosition==1)testo = TextDrawCreate(1.000000, 1.000000, "Zadmin v4.2"); // up; left
	if(ZadminSignaturePosition==2)testo = TextDrawCreate(560.000000, 1.000000, "Zadmin v4.2"); // up; right
	if(ZadminSignaturePosition==3)testo = TextDrawCreate(1.000000, 440.000000, "Zadmin v4.2"); // down; left
	if(ZadminSignaturePosition==4)testo = TextDrawCreate(560.000000, 440.000000, "Zadmin v4.2"); // down; right
	TextDrawBackgroundColor(testo, 16777215);
	TextDrawFont(testo, 0);
	TextDrawLetterSize(testo, 0.439998, 0.700000);
	TextDrawColor(testo, 65535);
	TextDrawSetOutline(testo, 1);
	TextDrawSetProportional(testo, 1);
	#endif
	
	SchedaReports1 = TextDrawCreate(660.000000, -2.000000, "                   ");
	TextDrawBackgroundColor(SchedaReports1, 255);
	TextDrawFont(SchedaReports1, 1);
	TextDrawLetterSize(SchedaReports1, 0.500000, 2.899999);
	TextDrawColor(SchedaReports1, -1);
	TextDrawSetOutline(SchedaReports1, 0);
	TextDrawSetProportional(SchedaReports1, 1);
	TextDrawSetShadow(SchedaReports1, 1);
	TextDrawUseBox(SchedaReports1, 1);
	TextDrawBoxColor(SchedaReports1, 0x0000004F);
	TextDrawTextSize(SchedaReports1, -10.000000, 658.000000);

	SchedaReports2 = TextDrawCreate(150.000000, 121.000000, "                                                                    ");
	TextDrawBackgroundColor(SchedaReports2, 255);
	TextDrawFont(SchedaReports2, 1);
	TextDrawLetterSize(SchedaReports2, 0.500000, 11.100000);
	TextDrawColor(SchedaReports2, -1);
	TextDrawSetOutline(SchedaReports2, 0);
	TextDrawSetProportional(SchedaReports2, 1);
	TextDrawSetShadow(SchedaReports2, 1);
	TextDrawUseBox(SchedaReports2, 1);
	TextDrawBoxColor(SchedaReports2, 255);
	TextDrawTextSize(SchedaReports2, 503.000000, 0.000000);

	SchedaReports3 = TextDrawCreate(262.000000, 121.000000, "Last 3 Reports:");
	TextDrawBackgroundColor(SchedaReports3, 65535);
	TextDrawFont(SchedaReports3, 1);
	TextDrawLetterSize(SchedaReports3, 0.500000, 1.500000);
	TextDrawColor(SchedaReports3, -1);
	TextDrawSetOutline(SchedaReports3, 1);
	TextDrawSetProportional(SchedaReports3, 1);

	SchedaReports4 = TextDrawCreate(155.000000, 140.000000, "  ");
	TextDrawBackgroundColor(SchedaReports4, 255);
	TextDrawFont(SchedaReports4, 1);
	TextDrawLetterSize(SchedaReports4, 0.240000, 1.099999);
	TextDrawColor(SchedaReports4, -1);
	TextDrawSetOutline(SchedaReports4, 0);
	TextDrawSetProportional(SchedaReports4, 1);
	TextDrawSetShadow(SchedaReports4, 1);
	
	SchedaReports5 = TextDrawCreate(320.000000, 210.00, "Type /reportsoff to close window");
	TextDrawBackgroundColor(SchedaReports5, 65535);
	TextDrawFont(SchedaReports5, 1);
	TextDrawLetterSize(SchedaReports5, 0.240000, 0.800000);
	TextDrawColor(SchedaReports5, -1);
	TextDrawSetOutline(SchedaReports5, 1);
	TextDrawSetProportional(SchedaReports5, 1);
	TextDrawAlignment(SchedaReports5,2);
	
	format(strrep,sizeof(strrep),"%s~n~%s~n~%s",LastReport1,LastReport2,LastReport3);
    TextDrawSetString(SchedaReports4,strrep);
	
	SetTimer("OpeningFS",8000,0);
	SetTimer("RconChanger",1000,1);
	SetTimer("AntiDriveByTimer",1000,1);
	tempo0=SetTimer("ServerConfiguration",30000,1);
	tempo1=SetTimer("SavePlayerStat",60000,1);
    tempo2=SetTimer("AntiHealthHack",5000,1);
    tempo3=SetTimer("AntiWeaponsHack",2200,1);
    tempo4=SetTimer("AntiHighPing",6000,1);
    ServerOK=true;
    Count3=5;
    if(!dini_Exists(IpBansFile)) dini_Create(IpBansFile);
    new Master[MAX_SERVER_STRING];
	format(Master,sizeof(Master),OptionsConfigFile);
    new file3[MAX_SERVER_STRING];
	format(file3,sizeof(file3),ForbiddenWordsFile);
	if(!dini_Exists(AkaFile)) dini_Create(AkaFile);
    if(!dini_Exists(file3)){
    dini_Create(file3);}
    format(file3,sizeof(file3),ForbiddenPartsOfNameFile);
    if(!dini_Exists(file3)){
    dini_Create(file3);}
    format(file3,sizeof(file3),MaxPlayersRecordFile);
    if(!dini_Exists(file3)){
    dini_Create(file3);
	if(!dini_Isset(file3,"PlayersRecord"))dini_IntSet(file3,"PlayersRecord",0);}

    if(!fexist(MainFolder)){
	    printf("\n\n > WARNING: Folder '%s' Missing From Scriptfiles\n",MainFolder);
	    SendRconCommand("unloadfs Zadmin4.2");
		return 1;}
    if(!fexist(UsersFolder)){
	    printf("\n\n > WARNING: Folder '%s' Missing From Scriptfiles\n",UsersFolder);
		SendRconCommand("unloadfs Zadmin4.2");
		return 1;}
    if(!fexist(ConfigsFolder)){
	    printf("\n\n > WARNING: Folder '%s' Missing From Scriptfiles\n",ConfigsFolder);
	    SendRconCommand("unloadfs Zadmin4.2");
		return 1;}
    if(!fexist(LanguagesFolder)){
	    printf("\n\n > WARNING: Folder '%s' Missing From Scriptfiles\n",LanguagesFolder);
	    SendRconCommand("unloadfs Zadmin4.2");
		return 1;}

    new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
    if(!dini_Exists(file)){
      dini_Create(file);
	  print(LanguageText[437]);}
	if(!dini_Isset(file,"pm")) dini_IntSet(file,"pm",1);
	if(!dini_Isset(file,"saveskin")) dini_IntSet(file,"saveskin",1);
	if(!dini_Isset(file,"veh")) dini_IntSet(file,"veh",1);
	if(!dini_Isset(file,"givecar")) dini_IntSet(file,"givecar",1);
	if(!dini_Isset(file,"heal")) dini_IntSet(file,"heal",1);
	if(!dini_Isset(file,"jetpack")) dini_IntSet(file,"jetpack",1);
	if(!dini_Isset(file,"armour")) dini_IntSet(file,"armour",1);
	if(!dini_Isset(file,"getip")) dini_IntSet(file,"getip",1);
	if(!dini_Isset(file,"getvhealth")) dini_IntSet(file,"getvhealth",1);
	if(!dini_Isset(file,"setvhealth")) dini_IntSet(file,"setvhealth",1);
	if(!dini_Isset(file,"mute")) dini_IntSet(file,"mute",1);
	if(!dini_Isset(file,"unmute")) dini_IntSet(file,"unmute",1);
	if(!dini_Isset(file,"spec")) dini_IntSet(file,"spec",1);
	if(!dini_Isset(file,"specoff")) dini_IntSet(file,"specoff",1);
	if(!dini_Isset(file,"kick")) dini_IntSet(file,"kick",1);
	if(!dini_Isset(file,"ban")) dini_IntSet(file,"ban",1);
	if(!dini_Isset(file,"fix")) dini_IntSet(file,"fix",1);
	if(!dini_Isset(file,"flip")) dini_IntSet(file,"flip",1);
	if(!dini_Isset(file,"jail")) dini_IntSet(file,"jail",1);
	if(!dini_Isset(file,"unjail")) dini_IntSet(file,"unjail",1);
	if(!dini_Isset(file,"givemoney")) dini_IntSet(file,"givemoney",1);
	if(!dini_Isset(file,"reset")) dini_IntSet(file,"reset",1);
	if(!dini_Isset(file,"freeze")) dini_IntSet(file,"freeze",1);
	if(!dini_Isset(file,"unfreeze")) dini_IntSet(file,"unfreeze",1);
	if(!dini_Isset(file,"die")) dini_IntSet(file,"die",1);
	if(!dini_Isset(file,"slap")) dini_IntSet(file,"slap",1);
	if(!dini_Isset(file,"goto")) dini_IntSet(file,"goto",1);
	if(!dini_Isset(file,"get")) dini_IntSet(file,"get",1);
	if(!dini_Isset(file,"vgoto")) dini_IntSet(file,"vgoto",1);
	if(!dini_Isset(file,"vget")) dini_IntSet(file,"vget",1);
	if(!dini_Isset(file,"teleplayer")) dini_IntSet(file,"teleplayer",1);
	if(!dini_Isset(file,"explode")) dini_IntSet(file,"explode",1);
	if(!dini_Isset(file,"setskin")) dini_IntSet(file,"setskin",1);
	if(!dini_Isset(file,"setskintome")) dini_IntSet(file,"setskintome",1);
	if(!dini_Isset(file,"setscore")) dini_IntSet(file,"setscore",1);
	if(!dini_Isset(file,"setweather")) dini_IntSet(file,"setweather",1);
	if(!dini_Isset(file,"setplayerweather")) dini_IntSet(file,"setplayerweather",1);
	if(!dini_Isset(file,"settime")) dini_IntSet(file,"settime",1);
	if(!dini_Isset(file,"setplayertime")) dini_IntSet(file,"setplayertime",1);
	if(!dini_Isset(file,"playerdata2")) dini_IntSet(file,"playerdata2",1);
	if(!dini_Isset(file,"cleatchat")) dini_IntSet(file,"clearchat",1);
	if(!dini_Isset(file,"gmx")) dini_IntSet(file,"gmx",1);
	if(!dini_Isset(file,"ccars")) dini_IntSet(file,"ccars",1);
	if(!dini_Isset(file,"tempadmin")) dini_IntSet(file,"tempadmin",1);
	if(!dini_Isset(file,"makeadmin")) dini_IntSet(file,"makeadmin",1);
	if(!dini_Isset(file,"makevip")) dini_IntSet(file,"makevip",1);
	if(!dini_Isset(file,"removevip")) dini_IntSet(file,"removevip",1);
	if(!dini_Isset(file,"makemegodadmin")) dini_IntSet(file,"makemegodadmin",1);
	if(!dini_Isset(file,"weapon")) dini_IntSet(file,"weapon",1);
	if(!dini_Isset(file,"count")) dini_IntSet(file,"count",1);
	if(!dini_Isset(file,"setplayerinterior")) dini_IntSet(file,"setplayerinterior",1);
	if(!dini_Isset(file,"god")) dini_IntSet(file,"god",1);
	if(!dini_Isset(file,"sgod")) dini_IntSet(file,"sgod",1);
	if(!dini_Isset(file,"changename")) dini_IntSet(file,"changename",0);
	if(!dini_Isset(file,"votekick")) dini_IntSet(file,"votekick",1);
	if(!dini_Isset(file,"voteban")) dini_IntSet(file,"voteban",0);
	if(!dini_Isset(file,"voteccars")) dini_IntSet(file,"voteccars",1);
	if(!dini_Isset(file,"warn")) dini_IntSet(file,"warn",1);
	if(!dini_Isset(file,"banwarn")) dini_IntSet(file,"banwarn",0);
	if(!dini_Isset(file,"lock")) dini_IntSet(file,"lock",1);
	if(!dini_Isset(file,"unlock")) dini_IntSet(file,"unlock",1);
	if(!dini_Isset(file,"carcolor")) dini_IntSet(file,"carcolor",1);
	if(!dini_Isset(file,"crash")) dini_IntSet(file,"crash",1);
	if(!dini_Isset(file,"burn")) dini_IntSet(file,"burn",1);
	if(!dini_Isset(file,"disarm")) dini_IntSet(file,"disarm",1);
	if(!dini_Isset(file,"removeweapon")) dini_IntSet(file,"removeweapon",1);
	if(!dini_Isset(file,"setname")) dini_IntSet(file,"setname",1);
	if(!dini_Isset(file,"eject")) dini_IntSet(file,"eject",1);
	if(!dini_Isset(file,"resetwarnings")) dini_IntSet(file,"resetwarnings",1);
	if(!dini_Isset(file,"setgravity")) dini_IntSet(file,"setgravity",1);
	if(!dini_Isset(file,"achat")) dini_IntSet(file,"achat",1);
	if(!dini_Isset(file,"announce")) dini_IntSet(file,"announce",1);
	if(!dini_Isset(file,"forbidword")) dini_IntSet(file,"forbidword",1);
	if(!dini_Isset(file,"savepersonalcar")) dini_IntSet(file,"savepersonalcar",1);
    print(LanguageText[438]);

    format(file,sizeof(file),CmdsLevelsFile);
    if(!dini_Exists(file)){
      dini_Create(file);
	  print(LanguageText[439]);}
	if(!dini_Isset(file,"SaveSkin")) dini_IntSet(file,"SaveSkin",0);
	if(!dini_Isset(file,"Veh")) dini_IntSet(file,"Veh",0);
    if(!dini_Isset(file,"GiveCar")) dini_IntSet(file,"GiveCar",2);
    if(!dini_Isset(file,"GetIp")) dini_IntSet(file,"GetIp",1);
    if(!dini_Isset(file,"GetVHealth")) dini_IntSet(file,"GetVHealth",1);
    if(!dini_Isset(file,"SetVHealth")) dini_IntSet(file,"SetVHealth",2);
	if(!dini_Isset(file,"Mute")) dini_IntSet(file,"Mute",2);
	if(!dini_Isset(file,"UnMute")) dini_IntSet(file,"UnMute",2);
	if(!dini_Isset(file,"Spec")) dini_IntSet(file,"Spec",1);
	if(!dini_Isset(file,"SpecOff")) dini_IntSet(file,"SpecOff",1);
	if(!dini_Isset(file,"Heal")) dini_IntSet(file,"Heal",1);
	if(!dini_Isset(file,"Jetpack")) dini_IntSet(file,"Jetpack",1);
	if(!dini_Isset(file,"Armour")) dini_IntSet(file,"Armour",1);
	if(!dini_Isset(file,"Kick")) dini_IntSet(file,"Kick",3);
	if(!dini_Isset(file,"Ban")) dini_IntSet(file,"Ban",6);
	if(!dini_Isset(file,"Jail")) dini_IntSet(file,"Jail",4);
	if(!dini_Isset(file,"UnJail")) dini_IntSet(file,"UnJail",4);
	if(!dini_Isset(file,"GiveMoney")) dini_IntSet(file,"GiveMoney",2);
	if(!dini_Isset(file,"Reset")) dini_IntSet(file,"Reset",8);
	if(!dini_Isset(file,"Freeze")) dini_IntSet(file,"Freeze",5);
	if(!dini_Isset(file,"UnFreeze")) dini_IntSet(file,"UnFreeze",5);
	if(!dini_Isset(file,"Fix")) dini_IntSet(file,"Fix",1);
	if(!dini_Isset(file,"Flip")) dini_IntSet(file,"Flip",1);
	if(!dini_Isset(file,"Die")) dini_IntSet(file,"Die",9);
	if(!dini_Isset(file,"Slap")) dini_IntSet(file,"Slap",4);
	if(!dini_Isset(file,"Goto")) dini_IntSet(file,"Goto",2);
	if(!dini_Isset(file,"Get")) dini_IntSet(file,"Get",3);
	if(!dini_Isset(file,"VGoto")) dini_IntSet(file,"VGoto",2);
	if(!dini_Isset(file,"VGet")) dini_IntSet(file,"VGet",3);
	if(!dini_Isset(file,"TelePlayer")) dini_IntSet(file,"TelePlayer",4);
	if(!dini_Isset(file,"Explode")) dini_IntSet(file,"Explode",4);
	if(!dini_Isset(file,"Setskin")) dini_IntSet(file,"Setskin",2);
	if(!dini_Isset(file,"SetskinToMe")) dini_IntSet(file,"SetskinToMe",0);
	if(!dini_Isset(file,"Setscore")) dini_IntSet(file,"Setscore",5);
	if(!dini_Isset(file,"SetWeather")) dini_IntSet(file,"SetWeather",3);
	if(!dini_Isset(file,"SetPlayerWeather")) dini_IntSet(file,"SetPlayerWeather",2);
	if(!dini_Isset(file,"SetTime")) dini_IntSet(file,"SetTime",3);
	if(!dini_Isset(file,"SetPlayerTime")) dini_IntSet(file,"SetPlayerTime",2);
	if(!dini_Isset(file,"PlayerData2")) dini_IntSet(file,"PlayerData2",1);
	if(!dini_Isset(file,"CleatChat")) dini_IntSet(file,"ClearChat",1);
	if(!dini_Isset(file,"Gmx")) dini_IntSet(file,"Gmx",10);
	if(!dini_Isset(file,"Ccars")) dini_IntSet(file,"Ccars",5);
	if(!dini_Isset(file,"TempAdmin")) dini_IntSet(file,"TempAdmin",1);
	if(!dini_Isset(file,"MakeAdmin")) dini_IntSet(file,"MakeAdmin",1);
	if(!dini_Isset(file,"MakeVip")) dini_IntSet(file,"MakeVip",6);
	if(!dini_Isset(file,"RemoveVip")) dini_IntSet(file,"RemoveVip",6);
	if(!dini_Isset(file,"Weapon")) dini_IntSet(file,"Weapon",7);
	if(!dini_Isset(file,"Count")) dini_IntSet(file,"Count",1);
	if(!dini_Isset(file,"SetPlayerInterior")) dini_IntSet(file,"SetPlayerInterior",8);
	if(!dini_Isset(file,"God")) dini_IntSet(file,"God",10);
	if(!dini_Isset(file,"SGod")) dini_IntSet(file,"SGod",10);
	if(!dini_Isset(file,"ChangeName")) dini_IntSet(file,"ChangeName",3);
	if(!dini_Isset(file,"Warn")) dini_IntSet(file,"Warn",1);
	if(!dini_Isset(file,"BanWarn")) dini_IntSet(file,"BanWarn",2);
	if(!dini_Isset(file,"Lock")) dini_IntSet(file,"Lock",0);
	if(!dini_Isset(file,"UnLock")) dini_IntSet(file,"UnLock",0);
	if(!dini_Isset(file,"CarColor")) dini_IntSet(file,"CarColor",0);
	if(!dini_Isset(file,"Crash")) dini_IntSet(file,"Crash",3);
	if(!dini_Isset(file,"Burn")) dini_IntSet(file,"Burn",4);
	if(!dini_Isset(file,"Disarm")) dini_IntSet(file,"Disarm",1);
	if(!dini_Isset(file,"RemoveWeapon")) dini_IntSet(file,"RemoveWeapon",3);
	if(!dini_Isset(file,"SetName")) dini_IntSet(file,"SetName",7);
	if(!dini_Isset(file,"Eject")) dini_IntSet(file,"Eject",3);
	if(!dini_Isset(file,"ResetWarnings")) dini_IntSet(file,"ResetWarnings",5);
	if(!dini_Isset(file,"SetGravity")) dini_IntSet(file,"SetGravity",9);
	if(!dini_Isset(file,"AChat")) dini_IntSet(file,"AChat",1);
	if(!dini_Isset(file,"Announce")) dini_IntSet(file,"Announce",2);
	if(!dini_Isset(file,"ForbidWord")) dini_IntSet(file,"ForbidWord",4);
	print(LanguageText[440]);
	
	format(file,sizeof(file),OptionsConfigFile);
    if(!dini_Exists(file)){
      dini_Create(file);
	  print(LanguageText[441]);}
    if(!dini_Isset(file,"RegisterInDialog")) dini_IntSet(file,"RegisterInDialog",1);
    if(!dini_Isset(file,"AllowCmdsOnAdmins")) dini_IntSet(file,"AllowCmdsOnAdmins",0);
    if(!dini_Isset(file,"Language")) dini_Set(file,"Language","Zadmin_English");
	if(!dini_Isset(file,"AntiFlood")) dini_IntSet(file,"AntiFlood",1);
	if(!dini_Isset(file,"AntiSpam")) dini_IntSet(file,"AntiSpam",1);
	if(!dini_Isset(file,"AntiSpawnKill")) dini_IntSet(file,"AntiSpawnKill",1);
	if(!dini_Isset(file,"AntiSpawnKillSeconds")) dini_IntSet(file,"AntiSpawnKillSeconds",5);
	if(!dini_Isset(file,"AntiBots")) dini_IntSet(file,"AntiBots",1);
	if(!dini_Isset(file,"RconSecurity")) dini_IntSet(file,"RconSecurity",1);
	if(!dini_Isset(file,"ReadCmds")) dini_IntSet(file,"ReadCmds",1);
	if(!dini_Isset(file,"MustRegister")) dini_IntSet(file,"MustRegister",0);
	if(!dini_Isset(file,"MustLogin")) dini_IntSet(file,"MustLogin",1);
	if(!dini_Isset(file,"AutoLogin")) dini_IntSet(file,"AutoLogin",1);
	if(!dini_Isset(file,"MaxVotesForKick")) dini_IntSet(file,"MaxVotesForKick",5);
	if(!dini_Isset(file,"MaxVotesForBan")) dini_IntSet(file,"MaxVotesForBan",10);
	if(!dini_Isset(file,"MaxVotesForCcars")) dini_IntSet(file,"MaxVotesForCcars",5);
	if(!dini_Isset(file,"AFKSystem")) dini_IntSet(file,"AFKSystem",1);
	if(!dini_Isset(file,"AntiSwear")) dini_IntSet(file,"AntiSwear",1);
	if(!dini_Isset(file,"AntiForbiddenPartOfName")) dini_IntSet(file,"AntiForbiddenPartOfName",0);
	if(!dini_Isset(file,"ConnectMessages")) dini_IntSet(file,"ConnectMessages",1);
	if(!dini_Isset(file,"AdminColor")) dini_IntSet(file,"AdminColor",0xE3B515AA);
	if(!dini_Isset(file,"AutomaticAdminColor")) dini_IntSet(file,"AutomaticAdminColor",1);
    if(!dini_Isset(file,"MaxAdminLevel")) dini_IntSet(file,"MaxAdminLevel",10); //don't need more than 10.
    if(!dini_Isset(file,"MaxVipLevel")) dini_IntSet(file,"MaxVipLevel",3);
	if(!dini_Isset(file,"MaxPing")) dini_IntSet(file,"MaxPing",800);
	if(!dini_Isset(file,"AntiCmdFlood")) dini_IntSet(file,"AntiCmdFlood",1);
	if(!dini_Isset(file,"MaxPingWarnings")) dini_IntSet(file,"MaxPingWarnings",5);
	if(!dini_Isset(file,"MaxMuteWarnings")) dini_IntSet(file,"MaxMuteWarnings",3);
	if(!dini_Isset(file,"MaxSpamWarnings")) dini_IntSet(file,"MaxSpamWarnings",3);
	if(!dini_Isset(file,"MaxFloodTimes")) dini_IntSet(file,"MaxFloodTimes",5);
	if(!dini_Isset(file,"MaxFloodSeconds")) dini_IntSet(file,"MaxFloodSeconds",1);
	if(!dini_Isset(file,"MaxCFloodSeconds")) dini_IntSet(file,"MaxCFloodSeconds",2);
	if(!dini_Isset(file,"MaxWarnings")) dini_IntSet(file,"MaxWarnings",3);
	if(!dini_Isset(file,"MaxBanWarnings")) dini_IntSet(file,"MaxBanWarnings",6);
	if(!dini_Isset(file,"AntiDriveBy")) dini_IntSet(file,"AntiDriveBy",0);
	if(!dini_Isset(file,"AntiHeliKill")) dini_IntSet(file,"AntiHeliKill",0);
	if(!dini_Isset(file,"AntiCapsLock")) dini_IntSet(file,"AntiCapsLock",0);
	if(!dini_Isset(file,"ServerWeather")) dini_IntSet(file,"ServerWeather",1);
	if(!dini_Isset(file,"SetOptions")) dini_IntSet(file,"SetOptions",8);
	if(!dini_Isset(file,"EnableCommands")) dini_IntSet(file,"EnableCommands",8);
	if(!dini_Isset(file,"AntiCheat")) dini_IntSet(file,"AntiCheat",8);
	
	format(file,sizeof(file),AnticheatConfigFile);
    if(!dini_Exists(file)){
      dini_Create(file);
	  print(LanguageText[442]);}
    if(!dini_Isset(file,"MaxMoney")) dini_IntSet(file,"MaxMoney",999999999);
	if(!dini_Isset(file,"Maxhealth")) dini_IntSet(file,"MaxHealth",100);
	if(!dini_Isset(file,"MaxArmour")) dini_IntSet(file,"MaxArmour",100);
	if(!dini_Isset(file,"AntiJetpack")) dini_IntSet(file,"AntiJetpack",0);
	if(!dini_Isset(file,"AntiMinigun")) dini_IntSet(file,"AntiMinigun",0);
	if(!dini_Isset(file,"AntiRPG")) dini_IntSet(file,"AntiRPG",0);
	if(!dini_Isset(file,"AntiBazooka")) dini_IntSet(file,"AntiBazooka",1);
	if(!dini_Isset(file,"AntiFlameThrower")) dini_IntSet(file,"AntiFlameThrower",0);
	if(!dini_Isset(file,"AntiMolotovs")) dini_IntSet(file,"AntiMolotovs",1);
	if(!dini_Isset(file,"AntiGrenades")) dini_IntSet(file,"AntiGrenades",0);
	if(!dini_Isset(file,"AntiSachetChargers")) dini_IntSet(file,"AntiSachetChargers",1);
	if(!dini_Isset(file,"AntiDetonator")) dini_IntSet(file,"AntiDetonator",1);
	if(!dini_Isset(file,"AntiTearGas")) dini_IntSet(file,"AntiTearGas",1);
	if(!dini_Isset(file,"AntiShotgun")) dini_IntSet(file,"AntiShotgun",0);
	if(!dini_Isset(file,"AntiSawnoffShotgun")) dini_IntSet(file,"AntiSawnoffShotgun",0);
	if(!dini_Isset(file,"AntiCombatShotgun")) dini_IntSet(file,"AntiCombatShotgun",0);
	if(!dini_Isset(file,"AntiRifle")) dini_IntSet(file,"AntiRifle",0);
	if(!dini_Isset(file,"AntiRifleSniper")) dini_IntSet(file,"AntiRifleSniper",0);
	if(!dini_Isset(file,"AntiSprayPaint")) dini_IntSet(file,"AntiSprayPaint",0);
	if(!dini_Isset(file,"AntiFireExtinguer")) dini_IntSet(file,"AntiFireExtinguer",0);
	print(LanguageText[443]);

    LoadForbiddenPartsOfName();
    LoadForbiddenWords();
	LoadIpBans();
	printf(LanguageText[446], RBannedPlayersCount);
	ServerConfiguration();
    print(LanguageText[405]);

	print("\n*************************************");
	print("*            [FS]Zadmin             *");
	print("*               v4.2                *");
	print(LanguageText[403]);
	print("*            By [ZFM]Zuc            *");
	print("*************************************\n");

	return 1;}
	
stock LoadForbiddenWords(){
	new File:file2,stringa3[256];
    file2 = fopen(ForbiddenWordsFile,io_read);
	while(fread(file2,stringa3)){
		for(new i=0, j=strlen(stringa3); i<j; i++) if(stringa3[i]=='\n'||stringa3[i]=='\r') stringa3[i]='\0';
        ForbiddenWords[ForbiddenWordCount] = stringa3;
        ForbiddenWordCount++;}
    fclose(file2);
	printf(LanguageText[444], ForbiddenWordCount);}
	
stock LoadForbiddenPartsOfName(){
    new File:file2,stringa3[256];
    file2 = fopen(ForbiddenPartsOfNameFile,io_read);
	while(fread(file2,stringa3)){
		for(new i=0, j=strlen(stringa3); i<j; i++) if(stringa3[i]=='\n'||stringa3[i]=='\r') stringa3[i]='\0';
        ForbiddenPartOfName[ForbiddenPartOfNameCount] = stringa3;
        ForbiddenPartOfNameCount++;}
    fclose(file2);
	printf(LanguageText[445], ForbiddenPartOfNameCount);}
	
stock LoadLanguage(language[]){
  new lfile[256];format(lfile,sizeof(lfile),LanguagesFile,language);
  new ministr[24];
  printf("- Loading language '%s'...",language);
  for(new i=0;i<MAX_LANGUAGE_TEXTS;i++){
	format(ministr,sizeof(ministr),"text%d",i);
    LanguageText[i]=dini_Get(lfile,ministr);}
  printf(LanguageText[455],language);}

public OnFilterScriptExit(){
    new Master[MAX_SERVER_STRING]; format(Master,sizeof(Master),OptionsConfigFile);
	KillTimer(tempo0);
	KillTimer(tempo1);
	KillTimer(tempo2);
	KillTimer(tempo3);
	KillTimer(tempo4);
	ServerOK=false;
    TextDrawDestroy(Text:testo);
    print("\n**************************************");
	print("*     ---===  [FS]Zadmin  ===---     *");
	print("*                v4.2                *");
	print(LanguageText[404]);
	print("*************************************\n");
	return 1;}

/*******************************************************************************
*                             <=[OnPlayerConnect]=>                            *
*******************************************************************************/

public OnPlayerConnect(playerid){
    IsBot[playerid]=false;
	if(Options[AntiBots]==1){
      CheckIfIsPlayerBot(playerid);}
	if(IsBot[playerid]==true)return -1;
	
	new pfile[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],tmp3[MAX_SERVER_STRING];
    gpci(playerid,tmp3,sizeof(tmp3));

    for(new i=0;i<RBannedPlayersCount;i++){
      if(strcmp(tmp3,RBannedPlayers[i],true)==0){
		GetPlayerName(playerid,pname,sizeof(pname));
		printf(LanguageText[447],pname);
		Ban(playerid);
		format(str,sizeof(str),LanguageText[448],pname);
		SendClientMessageToAll(COLOR_YELLOW,str);}}
	
    PlayerVehicle[playerid]=-1;
    JustSpawned[playerid]=false;
    if(Options[AFKSystem]==1){
      IsAFK[playerid]=false;
      AfkPlayerLabels[playerid]=Create3DTextLabel("  ",0x21DD00FF,0.0,0.0,0.0,200.0,0);
      AfkTimer[playerid]=SetTimerEx("CheckPlayersAFK",500,1,"d",playerid);
	  X1[playerid]=0;Y1[playerid]=0;Z1[playerid]=0;
	  X2[playerid]=0;Y2[playerid]=0;Z2[playerid]=0;}
    
    Spectated[playerid]=false;
    TextDrawHideForPlayer(playerid,SchedaReports1);
    TextDrawHideForPlayer(playerid,SchedaReports2);
    TextDrawHideForPlayer(playerid,SchedaReports3);
    TextDrawHideForPlayer(playerid,SchedaReports4);
    TextDrawHideForPlayer(playerid,SchedaReports5);
    Account[playerid][pCFlood]=false;
    TextDrawShowForPlayer(playerid,Text:testo);
		
    GetPlayerName(playerid, pname, sizeof(pname));
    IsVoteBanStarted[playerid]=false;
    Account[playerid][pJailed]=false;
    Account[playerid][pFreezed]=false;
    Spawned[playerid]=false;
    Account[playerid][pSkin]=0;
    Account[playerid][pVip]=0;
    Account[playerid][pLoggedin]=0;
    Account[playerid][pVotesForKick]=0;
    Account[playerid][pVotesForBan]=0;
    Account[playerid][pAdminlevel]=0;
    Account[playerid][pWarning]=0;
    Account[playerid][pBanWarning]=0;
    Account[playerid][pMuted]=false;
    Account[playerid][pFlood]=false;
    Account[playerid][pMuteWarnings]=0;
    Account[playerid][pPingWarnings]=0;
    Account[playerid][pSpamWarnings]=0;
    GetPlayerName(playerid,pname,sizeof(pname));
    format(pfile, sizeof(pfile), UsersFile, pname);
    
    if(!fexist(pfile)){
      if(Options[MustLogin]==0){
	    SendClientMessage(playerid,COLOR_ORANGE,LanguageText[3]);}
      if(Options[MustLogin]==1){
	    SendClientMessage(playerid,COLOR_ORANGE,LanguageText[4]),GameTextForPlayer(playerid,LanguageText[15],3000,3);
		ShowPlayerDialog(playerid,RegistrationDialog,DIALOG_STYLE_INPUT,LanguageText[100],LanguageText[104],LanguageText[102],"NO");}}

    GetPlayerIp(playerid,tmp3,sizeof(tmp3));
    tmp2 = dini_Get(pfile,"ip");
    if(fexist(pfile)){
      if(Options[AutoLogin]==0){
        SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[6]);
        Account[playerid][pLoggedin]=0;}
	  if(Options[AutoLogin]==1){
	    if(strcmp(tmp3,tmp2,true)==0){
          OnPlayerLogin(playerid);
          if(Account[playerid][pAdminlevel]==0){
		    format(str, sizeof(str), LanguageText[7], pname, dini_Int(pfile,"score"),dini_Int(pfile,"money"));
			SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}
          if(Account[playerid][pAdminlevel]>=1){
		    format(str, sizeof(str), LanguageText[8], pname, Account[playerid][pAdminlevel], dini_Int(pfile,"score"),dini_Int(pfile,"money"));
		    SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}}}}

	if(Options[ConnectMessages]==1){
	new stmp3[50]; GetPlayerIp(playerid,stmp3,sizeof(stmp3));
    new pAKA[MAX_SERVER_STRING]; pAKA = dini_Get(AkaFile,stmp3);
    GetPlayerName(playerid,pname,sizeof(pname));
	if(strlen(pAKA)<3) format(str,sizeof(str),LanguageText[409], pname, playerid),SendClientMessageToAll(COLOR_GREY,str),print(str);
	else if(!strcmp(pAKA,pname,true)) format(str,sizeof(str),LanguageText[409], pname, playerid),SendClientMessageToAll(COLOR_GREY,str),print(str);
    else format(str,sizeof(str),LanguageText[410], pname, playerid, pAKA),MessageToAdmins(COLOR_GREY,str),print(str);
	if(strlen(pAKA) == 0) dini_Set(AkaFile, stmp3, pname);else{
	  if(strfind(pAKA,pname,true)==-1){
		format(string,sizeof(string),"%s,%s", pAKA, pname);
        dini_Set(AkaFile, stmp3, string);}}}
        
    Account[playerid][pLoginAttempts]=0;
    RconLoginAttempts[playerid]=0;
    IsRealRconAdmin[playerid]=false;
	PlayersCount++;
	new ff[MAX_SERVER_STRING];format(ff,sizeof(ff),MaxPlayersRecordFile);
    if(PlayersCount>dini_Int(ff,"PlayersRecord")){
	  dini_IntSet(ff,"PlayersRecord",PlayersCount);}
    Banned[playerid]=false;
    GetPlayerName(playerid,name,sizeof(name));
    
    if(Options[AntiForbiddenPartOfName]==1){
      for(new s=0; s<ForbiddenPartOfNameCount; s++){
	    new pos;
	    while((pos=strfind(name,ForbiddenPartOfName[s],true))!=-1)for(new i=pos,j=pos+strlen(ForbiddenPartOfName[s]);i<j;i++){
		  SendClientMessage(playerid,COLOR_RED, LanguageText[9]);
		  Kick(playerid);
		  format(string,sizeof(string),LanguageText[10],name,playerid);
		  SendClientMessageToAll(COLOR_LIGHTRED, string);
		  print(string);}}}
	return 1;}

/*******************************************************************************
*                           <=[OnPlayerDisconnect]=>                           *
*******************************************************************************/

public OnPlayerDisconnect(playerid, reason){
	if(IsBot[playerid]==true)return 1;
    PlayersCount--;
    
    if(Options[AFKSystem]==1){
      KillTimer(AfkTimer[playerid]);
      KillTimer(AfkTimer2[playerid]);
      Delete3DTextLabel(AfkPlayerLabels[playerid]);}

    Spawned[playerid]=false;
    
	Account[playerid][pVotesForKick]=0;
	Account[playerid][pVotesForBan]=0;
    PlayerInVotekick[playerid]=false;
    PlayerInVoteban[playerid]=false;
    KillTimer(VoteKickTimer[player]);
    KillTimer(VoteBanTimer[player]);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      MyVoteK[i][playerid]=false;
	  MyVoteB[i][playerid]=false;}
    MyVoteC[playerid]=false;
    new stringa[128],file[MAX_SERVER_STRING];
    GetPlayerName(playerid, name, sizeof(name));
    switch(reason){
      case 0: format(stringa, sizeof(stringa), LanguageText[11], name);
      case 1: format(stringa, sizeof(stringa), LanguageText[12], name);
      case 2:{
        if(Banned[playerid]==false){
          format(stringa, sizeof(stringa), LanguageText[13], name);}
	    if(Banned[playerid]==true){
          format(stringa, sizeof(stringa), LanguageText[14], name);}}}
		         
    if(Options[ConnectMessages]==1){
      SendClientMessageToAll(COLOR_GREY, stringa);}
	print(stringa);
    Banned[playerid]=false;
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
    OnPlayerLogout(playerid);
    Account[playerid][pMuteWarnings]=0;
    Account[playerid][pSpamWarnings]=0;
    Account[playerid][pPingWarnings]=0;
    Account[playerid][pFloodding]=0;
    Account[playerid][pJailed]=false;
    Account[playerid][pFreezed]=false;
    Account[playerid][pMuted]=false;
    Account[playerid][pFlood]=false;
    Account[playerid][pVehicleLocked]=false;
    Account[playerid][pWarning]=0;
    Account[playerid][pBanWarning]=0;
    Account[playerid][pSkin]=0;
    if(Account[playerid][pLoggedin]==1){
	  dini_IntSet(file,"muted",0);
	  dini_IntSet(file,"jailed",0);
	  dini_IntSet(file,"freezed",0);}
    Spawned[playerid]=false;
    GodActive[playerid]=false;
    ResetPlayerWeapons(playerid);
    KillTimer(MuteTimer[playerid]);
    KillTimer(JailTimer[playerid]);
	return 1;}
	
/*******************************************************************************
*                              <=[OnPlayerDeath]=>                             *
*******************************************************************************/
	
public OnPlayerDeath(playerid, killerid, reason){
  Account[killerid][pKills]++;
  //SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
  Account[playerid][pDeaths]++;
  
  PlayerAfkTime[playerid]=0;
  Var1[playerid]=0;
  Spawned[playerid]=false;
  IsAFK[playerid]=false;
  
  if(Options[AntiSpawnKill]==1){
	if(JustSpawned[playerid]==true){
      GameTextForPlayer(killerid,LanguageText[407],5000,3);
	  GetPlayerName(killerid,name,sizeof(name));
	  format(string,sizeof string,LanguageText[406],name);
      SendClientMessageToAll(COLOR_YELLOW,string);
      if(IsPlayerInAnyVehicle(killerid)){
		new Float:a,Float:b,Float:c;
		GetPlayerPos(killerid,a,b,c);
		CreateExplosion(a,b,c,12,100);}
	  SetPlayerHealth(killerid,0);}}
	  
  if(Options[AntiDriveBy]==1){
	new Float:x,Float:y,Float:z,Float:x1,Float:y1,Float:z1;
	GetPlayerPos(killerid,x,y,z);GetPlayerPos(playerid,x1,y1,z1);
    new Float:distance=GetDistance(x,y,z,x1,y1,z1);
    if(IsPlayerInAnyVehicle(killerid) && !IsPlayerInPlane(killerid)){
	  if((GetPlayerState(killerid)==PLAYER_STATE_DRIVER && (reason==MICRO_UZI || reason==MP5 || reason==TEC9) && reason!=49 && distance<25) || (GetPlayerState(killerid)==PLAYER_STATE_PASSENGER && distance<50)){ // if killer makes DRIVE BY...
	    SetPlayerHealth(killerid,0);
	    GameTextForPlayer(killerid,LanguageText[451],5000,3);
	    GetPlayerName(killerid,name,sizeof(name));
        format(string,sizeof string,LanguageText[452],name);
        SendClientMessageToAll(COLOR_LIGHTRED,string);print(string);
	    return 1;}}}
	    
  if(Options[AntiHeliKill]==1){
	if(reason==50){ // heli-kill
	  SetPlayerHealth(killerid,0);
	  GetPlayerName(killerid,name,sizeof(name));
	  format(string,sizeof string,LanguageText[453],name);
      SendClientMessageToAll(COLOR_LIGHTRED,string);
	  GameTextForPlayer(killerid,LanguageText[454],5000,3);}}
	    
  return 1;}
  
/*******************************************************************************
*                              <=[OnPlayerSpawn]=>                             *
*******************************************************************************/
  
public SpawnKillFunction(playerid){
  if(Options[AntiSpawnKill]==1){
    JustSpawned[playerid]=true;
    SetTimerEx("JustSpawnedDelete",Options[AntiSpawnKillSeconds]*1000,0,"d",playerid);}}

public OnPlayerSpawn(playerid){
    IsAFK[playerid]=false;
    SpawnKillFunction(playerid);
    Attach3DTextLabelToPlayer(AfkPlayerLabels[playerid],playerid,0.0,0.0,0.4);
    PlayerAfkTime[playerid]=0;
    Var1[playerid]=1;
    Spawned[playerid]=true;

    AllowFixing[playerid]=true;
    Account[playerid][pCFlood]=false;
    Spawned[playerid]=false;
    SetTimerEx("SpawnPlayerZ",1000,0,"d",playerid);
	if(Account[playerid][pSkin]!=0){
	  SetPlayerSkin(playerid,Account[playerid][pSkin]);}
    ZucSecurity();
    SetPlayerHealth(playerid,Options[MaxHealth]);
    if(Account[playerid][pVip]>=1){
	  if(Options[AutomaticAdminColor]==1){
	    SetPlayerColor(playerid,COLOR_VIP);}}
    if(Account[playerid][pAdminlevel]>=1){
	  if(Options[AutomaticAdminColor]==1){
	    SetPlayerColor(playerid,Options[AdminColor]);}}
	if(Account[playerid][pJailed]==true){
      SetTimerEx("ReJailPlayer",2000,0,"d",playerid);}
    if(Account[playerid][pFreezed]==true){
	  SetTimerEx("ReFreezePlayer",2000,0,"d",playerid);}
    if(Account[playerid][pJailed]==false && Account[playerid][pFreezed]==false){
	  TogglePlayerControllable(playerid,1);}
    return 1;}
    
/*******************************************************************************
*                          <=[OnPlayerRequestClass]=>                          *
*******************************************************************************/
    
public OnPlayerRequestClass(playerid, classid){
  Account[playerid][pSkin]=0;
  if(Options[MustRegister]==1){
	if(!IsPlayerRegistered(playerid)){
      GameTextForPlayer(playerid,LanguageText[15],5000,3);}}
  if(Options[MustLogin]==1){
    if(IsPlayerRegistered(playerid)){
	  if(Account[playerid][pLoggedin]==0){
        GameTextForPlayer(playerid,LanguageText[16],5000,3);}}}
  return 1;}
  
/*******************************************************************************
*                          <=[OnPlayerRequestSpawn]=>                          *
*******************************************************************************/

public OnPlayerRequestSpawn(playerid){
  Account[playerid][pSkin]=GetPlayerSkin(playerid);
  if(Options[MustRegister]==1){
	if(!IsPlayerRegistered(playerid)){
	  GetPlayerName(playerid,name,sizeof(name));
	  SendClientMessage(playerid,COLOR_ORANGE,LanguageText[17]);
	  GameTextForPlayer(playerid,LanguageText[411],3000,3);
	  ShowPlayerDialog(playerid,RegistrationDialog,DIALOG_STYLE_INPUT,LanguageText[100],LanguageText[5],LanguageText[102],"NO");
	  return 0;}}
  if(Options[MustLogin]==1){
    if(IsPlayerRegistered(playerid)){
	  if(Account[playerid][pLoggedin]==0){
        GameTextForPlayer(playerid,LanguageText[16],5000,3);
		return 0;}}}
  return 1;}
	
/*******************************************************************************
*                              <=[OnRconCommand]=>                             *
*******************************************************************************/

public OnRconCommand(cmd[]){
    if(!strcmp(cmd, "achat", .length=5)){
	  new message[MAX_SERVER_STRING],arg_1=argpos(cmd),Index,tmp[MAX_SERVER_STRING]; tmp = strtok(cmd,Index);
	  if(!cmd[arg_1]){
	    print(LanguageText[19]);}else{
	  format(message, sizeof(message), LanguageText[18], cmd[5]);
	  MessageToAdmins(COLOR_PINK, message);
	  printf(LanguageText[408], cmd[5]);}
	  return 1;}
//----------------------------------------------------------------------------//
    if(!strcmp(cmd, "pm", .length = 2)){
	    new arg_1=argpos(cmd), arg_2=argpos(cmd, arg_1),targetid=strval(cmd[arg_1]), message[MAX_SERVER_STRING];
    	if(!cmd[arg_1] || cmd[arg_1]<'0' || cmd[arg_1]>'9' || targetid>200 || targetid<0 || !cmd[arg_2]){
	        print(LanguageText[20]);}
	    else if(!IsPlayerConnected(targetid)){
		    print(LanguageText[41]);}
    	else{
	        format(message, sizeof(message), "RCON admin => PM: %s", cmd[arg_2]);
			SendClientMessage(targetid, COLOR_PINK, message);
   	        printf(LanguageText[21], cmd[arg_1]);}
	    return 1;}
	    
	if(strcmp("ccars",cmd, true)==0){
      print(LanguageText[412]);
      SendClientMessageToAll(COLOR_ZADMINBLUE,LanguageText[22]);
      for(new i=2000;i<5000;i++){
	    DestroyVehicle(CARS[i]);
		NumeroAuto=2000;}
	  return 1;}
	return 0;}
	
/*******************************************************************************
*                              <=[OnPlayerText]=>                              *
*******************************************************************************/

public OnPlayerText(playerid, text[]){
    IfAfk(playerid);

	if(text[0] == '*'){
	  if(Account[playerid][pVip]>=1){
        if(Account[playerid][pMuted]==true){
		  SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[23]);
		  return 1;}
		if(Account[playerid][pMuted]==false){
	      new string4[128]; GetPlayerName(playerid,name,sizeof(name));
	      format(string4,sizeof(string4),"* [VIP] %s: %s *",name, text[1]), MessageToVips(COLOR_LIGHTBLUE,string4);}}
      if(Account[playerid][pAdminlevel]>=1){
	    new string4[128]; GetPlayerName(playerid,name,sizeof(name));
	    format(string4,sizeof(string4),"* [ADMIN] %s: %s *",name, text[1]), MessageToVips(COLOR_LIGHTBLUE,string4);}
	  return 0;}
	  
	if(Options[AntiCapsLock]==1){
	  if(Account[playerid][pAdminlevel]==0){
	    RemoveCapsLock(text);}}

	if(Options[AntiSwear]==1)if(Account[playerid][pAdminlevel]==0){
      for(new s=0; s<ForbiddenWordCount; s++){
        new pos;
	    while((pos=strfind(text,ForbiddenWords[s],true))!=-1) for(new i=pos, j=pos+strlen(ForbiddenWords[s]); i<j; i++) text[i]='*';}}

    if(text[0] == '#' && Account[playerid][pAdminlevel]>=1){
	  new string4[128]; GetPlayerName(playerid,name,sizeof(name));
	  format(string4,sizeof(string4),LanguageText[24],name, text[1]);
	  MessageToAdmins(COLOR_LIGHTGREEN,string4);
	  return 0;}

    if(Account[playerid][pMuted]==true){
      GetPlayerName(playerid,name,sizeof(name));
      if(Account[playerid][pMuteWarnings]==Options[MaxMuteWarnings]){
        format(string, sizeof(string), LanguageText[25],name,Account[playerid][pMuteWarnings],Options[MaxMuteWarnings]);
		SendClientMessageToAll(COLOR_YELLOW,string);
		GameTextForPlayer(playerid,LanguageText[27],20000,3);
        Account[playerid][pMuteWarnings]=0;Kick(playerid);
		return 0;}
	  if(Account[playerid][pMuteWarnings]<Options[MaxMuteWarnings]){
	    format(string, sizeof(string), LanguageText[26],Account[playerid][pMuteWarnings],Options[MaxMuteWarnings]);
		SendClientMessage(playerid,COLOR_LIGHTRED,string);
		GameTextForPlayer(playerid,LanguageText[28],2000,3);
	    Account[playerid][pMuteWarnings]++;
	    return 0;}}
	    
    if(Options[AntiSpam]==1)if(Account[playerid][pAdminlevel]==0){
      playerspammer=playerid;
	  if(CheckIfSpam(text)==1){
        if(Options[MaxSpamWarnings]==0){
		  SendClientMessage(playerid,COLOR_YELLOW,LanguageText[29]);
          Account[playerid][pSpamWarnings]=0;
          GetPlayerName(playerid,name,sizeof(name));Kick(playerid);
		  format(string, sizeof(string), LanguageText[30],name);
          SendClientMessageToAll(COLOR_LIGHTRED,string);
		  return 0;}
	    if(Options[MaxSpamWarnings]>0){
		  if(Account[playerid][pSpamWarnings]>=Options[MaxSpamWarnings]-1){
            format(string, sizeof(string), LanguageText[31],Account[playerid][pSpamWarnings],Options[MaxSpamWarnings]);
            SendClientMessage(playerid,COLOR_YELLOW,string);
            Account[playerid][pSpamWarnings]=0;
            GetPlayerName(playerid,name,sizeof(name));Kick(playerid);
			format(string, sizeof(string), LanguageText[30],name);
            SendClientMessageToAll(COLOR_LIGHTRED,string);
			return 0;}
		  if(Account[playerid][pSpamWarnings]<Options[MaxSpamWarnings]){
            Account[playerid][pSpamWarnings]++;
            format(string, sizeof(string), LanguageText[32],Account[playerid][pSpamWarnings],Options[MaxSpamWarnings]);
            SendClientMessage(playerid,COLOR_LIGHTRED,string);}}
        return 0;}}

	if(Options[AntiFlood]==1){
	if(Account[playerid][pFlood]==false){
	  SetTimerEx("FloodTimer",Options[MaxFloodSeconds]*1000,0,"d",playerid);
	  Account[playerid][pFlood]=true;
	  return 1;}
      else if(Account[playerid][pFlood]==true){
        if(Account[playerid][pFloodding]==Options[MaxFloodTimes]-1){
          GetPlayerName(playerid,name,sizeof(name));
          Account[playerid][pFloodding]++;
          format(str,sizeof(str),LanguageText[33],name),SendClientMessageToAll(COLOR_YELLOW,str),print(str);
          Account[playerid][pFloodding]=0;
		  Kick(playerid);}
          else if(Account[playerid][pFloodding]<Options[MaxFloodTimes]){
          Account[playerid][pFloodding]++;
          format(str,sizeof(str),LanguageText[34],Account[playerid][pFloodding], Options[MaxFloodTimes]),SendClientMessage(playerid,COLOR_LIGHTRED,str);
		  return 0;}}}
	return 1;}
	
/*public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid){
  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
    if(IsPlayerConnected(i)&&GetPlayerState(i)==PLAYER_STATE_SPECTATING){
      SetPlayerInterior(i,newinteriorid);}}
  return 1;}

public OnPlayerStateChange(playerid, newstate, oldstate){
  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
    if(IsPlayerConnected(i)){
	  if(GetPlayerState(i)==PLAYER_STATE_SPECTATING){
		if(!IsPlayerInAnyVehicle(playerid)){
          PlayerSpectatePlayer(i,playerid);}
        if(IsPlayerInAnyVehicle(playerid)){
          PlayerSpectateVehicle(i,GetPlayerVehicleID(playerid));}}}}
  return 1;}*/
	
/*******************************************************************************
*                          <=[OnPlayerCommandText]=>                           *
*******************************************************************************/

public OnPlayerCommandText(playerid, cmdtext[]){
    IfAfk(playerid);
	if(Account[playerid][pJailed]==true){
	  if(Account[playerid][pAdminlevel]==0){
        SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[35]);
	    return 1;}
	  return 1;}
    if(Account[playerid][pFreezed]==true){
	  if(Account[playerid][pAdminlevel]==0){
        SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[36]);
	    return 1;}
	  return 1;}
	if(Options[AntiCmdFlood]==1){
      if(Account[playerid][pCFlood]==true){
        SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[37]);
	    return 1;}
	  if(Account[playerid][pCFlood]==false){
	    Account[playerid][pCFlood]=true;
	    SetTimerEx("CFloodTimer",Options[MaxCFloodSeconds]*1000,0,"d",playerid);}}
	  
    if(Options[Readcmds]==1){
	  GetPlayerName(playerid,name,sizeof(name));
	  format(string, sizeof(string), LanguageText[38],name,playerid,cmdtext);
      MessageToAdmins(COLOR_GREY,string);print(string);}
	GetPlayerName(playerid,name,sizeof(name));
	dcmd(makeaccount, 11, cmdtext);
	dcmd(renameaccount, 13, cmdtext);
	dcmd(removeaccount, 13, cmdtext);
	dcmd(setaccountdata, 14, cmdtext);
	dcmd(defultsetting, 13, cmdtext);
    // register system //
    dcmd(register, 8, cmdtext);
    dcmd(login, 5, cmdtext);
    dcmd(logout, 6, cmdtext);
    dcmd(changepass, 10, cmdtext);
    dcmd(saveskin, 8, cmdtext);
    dcmd(myskin, 6, cmdtext);
    dcmd(stats, 5, cmdtext);
    /*************************
    ****** FOR PLAYERS: ******
    *************************/
    dcmd(afk, 3, cmdtext); // NEW cmd!
    dcmd(pm, 2, cmdtext);
    dcmd(admins, 6, cmdtext);
    dcmd(vips, 4, cmdtext);
    dcmd(savepersonalcar, 15, cmdtext);
    dcmd(replacepersonalcar, 18, cmdtext);
    dcmd(mycar, 5, cmdtext); // NEW cmd!
    dcmd(antistealing, 12, cmdtext); //NEW cmd!
    dcmd(report, 6, cmdtext);
    dcmd(veh, 3, cmdtext);
    dcmd(vipcolor,8,cmdtext);
    dcmd(carcolor,8,cmdtext);
    dcmd(zadminhelp, 10, cmdtext);
    dcmd(countdown, 9, cmdtext);
    dcmd(changename,10,cmdtext);
    dcmd(votekick, 8, cmdtext);
    dcmd(voteban, 7, cmdtext);
    dcmd(voteccars, 9, cmdtext);
    dcmd(vipcmds, 7, cmdtext);
    /**************************
    ******* FOR ADMINS: *******
    **************************/
    dcmd(playersrecord, 13, cmdtext);
    dcmd(muted,5,cmdtext);
    dcmd(freezed,7,cmdtext);
    dcmd(jailed,6,cmdtext);
    dcmd(asay,4,cmdtext);
    dcmd(announce,8,cmdtext);
    dcmd(lock,4,cmdtext);
    dcmd(unlock,6,cmdtext);
    dcmd(jetp,4,cmdtext);
    dcmd(heal,4,cmdtext);
    dcmd(armour,6,cmdtext);
    dcmd(gmx,3,cmdtext);
    dcmd(reports, 7, cmdtext);
    dcmd(reportsoff, 10, cmdtext);
    dcmd(admincolor,10,cmdtext);
    dcmd(god,3,cmdtext);
    dcmd(sgod,4,cmdtext);
    dcmd(fix,3,cmdtext);
    dcmd(fixpv,5,cmdtext);
    dcmd(flip,4,cmdtext);
    dcmd(reloadzadmin,12,cmdtext);
    dcmd(unloadzadmin,12,cmdtext);
    dcmd(vipcmds, 7, cmdtext); // NEW cmd!
    dcmd(admincmd1, 9, cmdtext);
    dcmd(admincmd2, 9, cmdtext);
    dcmd(setweather,10,cmdtext);
    dcmd(settime,7,cmdtext);
    dcmd(ccars,5,cmdtext);
    dcmd(cchat,5,cmdtext);
    dcmd(setgravity,10,cmdtext);
    dcmd(command,7,cmdtext);
    dcmd(anticheat,9,cmdtext);
    dcmd(set, 3, cmdtext);
    dcmd(forbidword, 10, cmdtext);
    // single admin commands //
    dcmd(spec,4,cmdtext);
    dcmd(specoff,7,cmdtext);
    dcmd(warn,4,cmdtext);
    dcmd(banwarn,7,cmdtext); //NEW cmd!
    dcmd(givecar, 7, cmdtext);
    dcmd(crash,5,cmdtext);
    dcmd(burn,4,cmdtext);
    dcmd(disarm,6,cmdtext);
    dcmd(removeweapon,12,cmdtext);
    dcmd(eject,5,cmdtext);
    dcmd(setname,7,cmdtext);
    dcmd(resetwarnings,13,cmdtext);
    dcmd(getip,5,cmdtext);
    dcmd(getvhealth, 10, cmdtext);
    dcmd(setvhealth, 10, cmdtext);
    dcmd(mute,4,cmdtext);
    dcmd(unmute,6,cmdtext);
    dcmd(kick,4,cmdtext);
    dcmd(ban,3,cmdtext);
    dcmd(rangeban,8,cmdtext);
    dcmd(jail,4,cmdtext);
    dcmd(unjail,6,cmdtext);
    dcmd(freeze,6,cmdtext);
    dcmd(unfreeze,8,cmdtext);
    dcmd(reset,5,cmdtext);
    dcmd(givemoney,9,cmdtext);
    dcmd(setscore,8,cmdtext);
    dcmd(setskin,7,cmdtext);
    dcmd(setskintome,11,cmdtext);
    dcmd(slap,4,cmdtext);
    dcmd(explode,7,cmdtext);
    dcmd(goto,4,cmdtext);
    dcmd(vgoto,5,cmdtext);
    dcmd(teleplayer, 10, cmdtext);
    dcmd(get,3,cmdtext);
    dcmd(vget,4,cmdtext);
    dcmd(tempadmin,9,cmdtext);
    dcmd(makeadmin,9,cmdtext);
    dcmd(makevip,7,cmdtext);
    dcmd(removevip,9,cmdtext);
    dcmd(makemegodadmin,14,cmdtext);
    dcmd(die,3,cmdtext);
    dcmd(setplayerinterior,17,cmdtext);
    dcmd(weapon,6,cmdtext);
    dcmd(setplayerweather,16,cmdtext);
    dcmd(setplayertime,13,cmdtext);
    dcmd(playerdata,10,cmdtext);
    // multiple admin commands //
    dcmd(aheal,5,cmdtext);
    dcmd(aarmour,7,cmdtext);
    dcmd(adisarm,7,cmdtext);
    dcmd(amute,5,cmdtext);
    dcmd(aunmute,7,cmdtext);
    dcmd(akick,5,cmdtext);
    dcmd(aban,4,cmdtext);
    dcmd(ajail,5,cmdtext);
    dcmd(aunjail,7,cmdtext);
    dcmd(afreeze,7,cmdtext);
    dcmd(aunfreeze,9,cmdtext);
    dcmd(areset,6,cmdtext);
    dcmd(asetskin,8,cmdtext);
    dcmd(aslap,5,cmdtext);
    dcmd(aexplode,8,cmdtext);
    dcmd(aget,4,cmdtext);
    dcmd(adie,4,cmdtext);
    dcmd(aweapon,7,cmdtext);
	return 0;}

/*******************************************************************************
*                              <=[COMANDI DCMD]=>                              *
*******************************************************************************/

dcmd_afk(playerid,params[]){
  #pragma unused params
  KillTimer(AfkTimer[playerid]);
  AfkTimer2[playerid]=SetTimerEx("ReactiveAfkTimer",2000,0,"d",playerid);
  PlayerAfkTime[playerid]=AFK_MAX_SECONDS+1;
  SetPlayerInAFK(playerid);
  return 1;}

dcmd_pm(playerid,params[]){
  if(ServerInfo[Pm]==0){
    CommandDisabled(playerid);}
  if(ServerInfo[Pm]==1){
    new tmp[MAX_SERVER_STRING],Index; tmp = strtok(params, Index);
    if(!strlen(tmp)){
        SendClientMessage(playerid, COLOR_WHITE, LanguageText[20]);
        return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
    if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(player==playerid){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[42]);
      return 1;}
    if(Options[AntiFlood]==1){
	if(Account[playerid][pFlood]==false && Account[playerid][pMuted]==false && IsPlayerConnected(player)){
	  SetTimerEx("FloodTimer",Options[MaxFloodSeconds]*1000,0,"d",playerid);
	  Account[playerid][pFlood]=true;
	  GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
	  format(string, sizeof(string), LanguageText[43], adminname,playerid, params[2]),SendClientMessage(player,COLOR_LIGHTGREEN,string);
	  format(string, sizeof(string), LanguageText[44],incriminato, player, params[2]),SendClientMessage(playerid,COLOR_LIGHTGREEN,string);
	  return 1;}
      else if(Account[playerid][pFlood]==true){
        if(Account[playerid][pFloodding]==Options[MaxFloodTimes]-1){
          GetPlayerName(playerid,name,sizeof(name));
          Account[playerid][pFloodding]++;
          format(str,sizeof(str),LanguageText[33],name),SendClientMessageToAll(COLOR_YELLOW,str),print(str);
          Account[playerid][pFloodding]=0;
		  Kick(playerid);}
          else if(Account[playerid][pFloodding]<Options[MaxFloodTimes]){
          Account[playerid][pFloodding]++;
          format(str,sizeof(str),LanguageText[34],Account[playerid][pFloodding], Options[MaxFloodTimes]),SendClientMessage(playerid,COLOR_LIGHTRED,str);
		  return 1;}}}
    GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
	format(string, sizeof(string), LanguageText[43], adminname,playerid, params[2]),SendClientMessage(player,COLOR_LIGHTGREEN,string);
	format(string, sizeof(string), LanguageText[44],incriminato, player, params[2]),SendClientMessage(playerid,COLOR_LIGHTGREEN,string);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_admins(playerid,params[]){
  #pragma unused params
  new Var,VarR;
  for(new x=0;x<MAX_SERVER_PLAYERS;x++){
    if(Account[x][pAdminlevel]>=1){
	  Var=1;}
    if(IsRealRconAdmin[x]==true){
	  VarR=1;}}
  if(Var==1){
    SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[45]);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i)){
	    if(Account[i][pAdminlevel]>=1){
	      new name2[24];
          GetPlayerName(i, name2, sizeof(name2));
          format(str, sizeof(str), LanguageText[46], name2, i, Account[i][pAdminlevel]), SendClientMessage(playerid, COLOR_WHITE, str);}}}}
  if(VarR==1){
	for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i)){
		if(IsRealRconAdmin[i]==true){
	      new name2[24];
          GetPlayerName(i, name2, sizeof(name2));
          format(str, sizeof(str), LanguageText[47], name2, i), SendClientMessage(playerid, COLOR_YELLOW, str);}}}}
  if(Var==0 && VarR==0){
    SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[48]);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[49]);}
  Var=0;
  VarR=0;
  return 1;}
//----------------------------------------------------------------------------//
dcmd_savepersonalcar(playerid,params[]){
  if(ServerInfo[SavePersonalCar]==0){
	CommandDisabled(playerid);
	return 1;}
  if(ServerInfo[SavePersonalCar]==1){
  new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],col1,col2,Index;tmp=strtok(params,Index);tmp2=strtok(params,Index);
  if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[50]);
	  return 1;}
  if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[51]);
	  return 1;}
  col1 = strval(tmp);
  col2 = strval(tmp2);
  if(!IsPlayerRegistered(playerid)){
    SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[52]);
	return 1;}
  if(Account[playerid][pVip]==0 && Account[playerid][pAdminlevel]==0){
    SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[53]);
	return 1;}
  if(Account[playerid][pVip]>=1 || Account[playerid][pAdminlevel]>=1){
  if(!IsPlayerInAnyVehicle(playerid)){
	SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[54]);
	return 1;}
  if(IsPlayerInAnyVehicle(playerid)){
	new file[MAX_SERVER_STRING];
	new Float:nx,Float:ny,Float:nz,Float:nrot,Model;
	new Var[50];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
    if(dini_Isset(file,"ID") && dini_Isset(file,"X")  && dini_Isset(file,"Y") && dini_Isset(file,"Z") && dini_Isset(file,"ROT") && dini_Isset(file,"COLOR1") && dini_Isset(file,"COLOR2")){
      SendClientMessage(playerid,COLOR_ORANGE,LanguageText[55]);}
    if(!dini_Isset(file,"ID") && !dini_Isset(file,"X")  && !dini_Isset(file,"Y") && !dini_Isset(file,"Z") && !dini_Isset(file,"ROT") && !dini_Isset(file,"COLOR1") && !dini_Isset(file,"COLOR2")){
      GetPlayerPos(playerid,nx,ny,nz);
      GetVehicleZAngle(GetPlayerVehicleID(playerid),nrot);
      Model=GetVehicleModel(GetPlayerVehicleID(playerid));
      dini_IntSet(file,"ID",Model);
      format(Var, sizeof(Var),"%0.2f", nx);
      dini_IntSet(file,"X",strval(Var));
      format(Var, sizeof(Var),"%0.2f", ny);
      dini_IntSet(file,"Y",strval(Var));
      format(Var, sizeof(Var),"%0.2f", nz+0.5);
      dini_IntSet(file,"Z",strval(Var));
      format(Var, sizeof(Var),"%0.2f", nrot);
      dini_IntSet(file,"ROT",strval(Var));
      dini_IntSet(file,"COLOR1",col1);
      dini_IntSet(file,"COLOR2",col2);
      dini_IntSet(file,"AntiCarStealing",1);
      PlayerVehicle[playerid]=GetPlayerVehicleID(playerid);
	  SendClientMessage(playerid,COLOR_GREEN,LanguageText[56]);
	  format(string, sizeof(string), "- [P.Vehicle] %s has saved his personal vehicle!", pname),print(string);}}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_mycar(playerid,params[]){
  #pragma unused params
  if(ServerInfo[SavePersonalCar]==0){
	CommandDisabled(playerid);}
  if(ServerInfo[SavePersonalCar]==1){
  if(!IsPlayerRegistered(playerid)){
    SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[52]);
	return 1;}
  if(Account[playerid][pVip]==0 && Account[playerid][pAdminlevel]==0){
    SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[53]);
	return 1;}
  if(Account[playerid][pVip]>=1 || Account[playerid][pAdminlevel]>=1){
    new file[MAX_SERVER_STRING];
	new Float:nx,Float:ny,Float:nz,Float:nrot;
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
    if(!dini_Isset(file,"ID") && !dini_Isset(file,"X")  && !dini_Isset(file,"Y") && !dini_Isset(file,"Z") && !dini_Isset(file,"ROT") && !dini_Isset(file,"COLOR1") && !dini_Isset(file,"COLOR2")){
      GetPlayerPos(playerid,nx,ny,nz);
      GetPlayerFacingAngle(playerid,nrot);
	  SetVehiclePos(PlayerVehicle[playerid],nx+4,ny,nz+0.5);
	  SetVehicleZAngle(PlayerVehicle[playerid],nrot);
	  SendClientMessage(playerid,COLOR_GREEN,LanguageText[57]);
	  format(string, sizeof(string), "- [P.Vehicle] %s has teleported his personal vehicle to him!", pname),print(string);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_replacepersonalcar(playerid,params[]){
  if(ServerInfo[SavePersonalCar]==0){
	CommandDisabled(playerid);
	return 1;}
  if(ServerInfo[SavePersonalCar]==1){
  new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],col1,col2,Index;tmp=strtok(params,Index);tmp2=strtok(params,Index);
  if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[58]);
	  return 1;}
  if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[59]);
	  return 1;}
  col1 = strval(tmp);
  col2 = strval(tmp2);
  if(!IsPlayerRegistered(playerid)){
    SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[52]);
	return 1;}
  if(Account[playerid][pVip]==0 && Account[playerid][pAdminlevel]==0){
    SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[53]);
	return 1;}
  if(Account[playerid][pVip]>=1 || Account[playerid][pAdminlevel]>=1){
  if(!IsPlayerInAnyVehicle(playerid)){
	SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[54]);
	return 1;}
  if(IsPlayerInAnyVehicle(playerid)){
	new file[MAX_SERVER_STRING];
	new Float:nx,Float:ny,Float:nz,Float:nrot,Model;
	new Var[50];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
    if(!dini_Isset(file,"ID") && !dini_Isset(file,"X")  && !dini_Isset(file,"Y") && !dini_Isset(file,"Z") && !dini_Isset(file,"ROT") && !dini_Isset(file,"COLOR1") && !dini_Isset(file,"COLOR2")){
      SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[60]);
	  return 1;}
    if(dini_Isset(file,"ID") && dini_Isset(file,"X")  && dini_Isset(file,"Y") && dini_Isset(file,"Z") && dini_Isset(file,"ROT") && dini_Isset(file,"COLOR1") && dini_Isset(file,"COLOR2")){
      GetPlayerPos(playerid,nx,ny,nz);
      GetVehicleZAngle(GetPlayerVehicleID(playerid),nrot);
      Model=GetVehicleModel(GetPlayerVehicleID(playerid));
      dini_IntSet(file,"ID",Model);
      format(Var, sizeof(Var),"%0.2f", nx);
      dini_IntSet(file,"X",strval(Var));
      format(Var, sizeof(Var),"%0.2f", ny);
      dini_IntSet(file,"Y",strval(Var));
      format(Var, sizeof(Var),"%0.2f", nz+0.5);
      dini_IntSet(file,"Z",strval(Var));
      format(Var, sizeof(Var),"%0.2f", nrot);
      dini_IntSet(file,"ROT",strval(Var));
      dini_IntSet(file,"COLOR1",col1);
      dini_IntSet(file,"COLOR2",col2);
      dini_IntSet(file,"AntiCarStealing",1);
      if(!IsPlayerInVehicle(playerid,PlayerVehicle[playerid]))DestroyVehicle(PlayerVehicle[playerid]);
      PlayerVehicle[playerid]=GetPlayerVehicleID(playerid);
	  SendClientMessage(playerid,COLOR_GREEN,LanguageText[61]);
	  format(string, sizeof(string), "- [P.Vehicle] %s has replaced his personal vehicle!", pname),print(string);}}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_antistealing(playerid,params[]){
    new tmp[MAX_SERVER_STRING],Index;tmp=strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[62]);
	  return 1;}
	player = strval(tmp);
	if(player!=0 && player!=1){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[63]);
      return 1;}
	GetPlayerName(playerid,name,sizeof(name));
	new pfile[256];format(pfile,256,UsersFile,name);
	if(player==0){
	  format(string,256,LanguageText[64],name);}
    if(player==1){
	  format(string,256,LanguageText[65],name);}
	SendClientMessageToAll(COLOR_LIGHTBLUE,string);
	dini_IntSet(pfile,"AntiCarStealing",player);
    return 1;}
//----------------------------------------------------------------------------//
dcmd_vips(playerid,params[]){
  #pragma unused params
  new Var;
  for(new x=0;x<MAX_SERVER_PLAYERS;x++){
    if(Account[x][pVip]>=1){
	  Var=1;}}
  if(Var==1){
    SendClientMessage(playerid, COLOR_VIP, LanguageText[66]);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i)){
	    if(Account[i][pVip]>=1){
	      new name2[24];
          GetPlayerName(i, name2, sizeof(name2));
          format(str, sizeof(str), LanguageText[46], name2, i, Account[i][pVip]), SendClientMessage(playerid, COLOR_WHITE, str);}}}}
  if(Var==0){
    SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[67]);
    SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[68]);}
  Var=0;
  return 1;}
//----------------------------------------------------------------------------//
dcmd_report(playerid,params[]){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],reason[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);tmp2 = strtok(params,Index);
    if(!strlen(tmp)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[69]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    format(string,sizeof(string),"%s",params[2]);
    reason=string;
    if(!strlen(tmp2)){
	  reason="No Reason Given";}
    new File:Reported = fopen(ReportedPlayersFile,io_append);player = strval(tmp);
    GetPlayerName(playerid, adminname, sizeof(adminname)); GetPlayerName(player, incriminato, sizeof(incriminato));
	format(string, sizeof(string), "'%s'(id: %d) reported '%s'(id: %d) [reason: %s] \r\n", adminname, playerid, incriminato, player, reason);
    fwrite(Reported,string);fclose(Reported);
    format(string, sizeof(string), "--- REPORT: '%s'(id: %d) reported '%s'(id: %d) [reason: %s] ---", adminname, playerid, incriminato, player, reason);
    MessageToAdmins(COLOR_ZADMINBLUE,string);
    format(string, sizeof(string), "%s(id:%d) => %s(id:%d) [reason: %s]", adminname, playerid, incriminato, player, reason);
    LastReport1=LastReport2;
    LastReport2=LastReport3;
    LastReport3=string;
    format(strrep,sizeof(strrep),"1: %s~n~2: %s~n~3: %s",LastReport3,LastReport2,LastReport1);
    TextDrawSetString(SchedaReports4,strrep);
	format(string, sizeof(string), LanguageText[70],incriminato);
	SendClientMessage(playerid,COLOR_LIGHTGREEN, string);
    printf("^^^REPORT: '%s'(id: %d) reported '%s'(id: %d) [reason: %s]", adminname, playerid, incriminato, player, reason);
    GameTextToAdmins("NEW REPORT by a player!",3000,3);
    return 1;}
//----------------------------------------------------------------------------//
dcmd_reports(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=1){
    new File:Reported = fopen(ReportedPlayersFile,io_read);
    if(!fexist(ReportedPlayersFile)){
      SendClientMessage(playerid,COLOR_ZADMINBLUE,LanguageText[71]);
	  return 1;}
    fclose(Reported);
    TextDrawShowForPlayer(playerid,SchedaReports1);
    TextDrawShowForPlayer(playerid,SchedaReports2);
    TextDrawShowForPlayer(playerid,SchedaReports3);
    TextDrawShowForPlayer(playerid,SchedaReports4);
	TextDrawShowForPlayer(playerid,SchedaReports5);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_reportsoff(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=1){
    TextDrawHideForPlayer(playerid,SchedaReports1);
    TextDrawHideForPlayer(playerid,SchedaReports2);
    TextDrawHideForPlayer(playerid,SchedaReports3);
    TextDrawHideForPlayer(playerid,SchedaReports4);
	TextDrawHideForPlayer(playerid,SchedaReports5);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_zadminhelp(playerid,params[]){
  #pragma unused params
  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[72]);
  SendClientMessage(playerid, COLOR_WHITE, "REGISTER: /register /login /logout /stats /changepass");
  SendClientMessage(playerid, COLOR_WHITE, "CMDS: /votekick /voteban /report /admins /vips /countdown /veh /saveskin /myskin /vipcmds");
  SendClientMessage(playerid, COLOR_LIGHTRED, "************************************************************************");
  return 1;}
//----------------------------------------------------------------------------//
dcmd_carcolor(playerid,params[]){
  if(ServerInfo[CarColor]==0){
    CommandDisabled(playerid);}
  new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],Index,color1,color2; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
  if(Account[playerid][pAdminlevel]>=CmdsOptions[CarColor]) if(ServerInfo[CarColor]==1){
    if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[73]);
      return 1;}
    if(!strlen(tmp2)) color2=random(126); else color2=strval(tmp2);
	color1=strval(tmp);
	if(!IsPlayerInAnyVehicle(playerid)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[74]);
      return 1;}
	if(color1>126 || color1<0){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[75]);
      return 1;}
    if(color2>126 || color2<0){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[75]);
      return 1;}
	if(IsPlayerInAnyVehicle(playerid)){
	  ChangeVehicleColor(GetPlayerVehicleID(playerid),color1,color2);
	  format(string,sizeof(string),LanguageText[76],name, color1, color2);
	  SendClientMessageToAll(COLOR_GREEN,string),print(string);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_veh(playerid,params[]){
  if(ServerInfo[Veh]==0){
    CommandDisabled(playerid);
	return 0;}
  new Float:x,Float:y,Float:z,Float:xrot,interior;
  new col1,col2;
  new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],tmp3[MAX_SERVER_STRING],Index,carretta; tmp = strtok(params,Index); tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Veh]) if(ServerInfo[Veh]==1){
    if(IsPlayerInAnyVehicle(playerid)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[77]);
	  return 1;}
	if(!IsPlayerInAnyVehicle(playerid)){
    if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[78]);
      return 1;}
    if(!strlen(tmp2)){
      col1=Colori[random(8)];}
    if(!strlen(tmp3)){
      col2=Colori[random(8)];}
    if(!IsNumeric(tmp)) carretta=GetVehicleModelIDFromName(tmp); else
      carretta = strval(tmp);
    if(carretta<400 || carretta>611){
	  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[79]);
	  return 1;}
	switch(carretta){
	  case 406,417,425,432,433,435,441,443,447,449,450,464,465,476,501,511,512,520,537,538,519,553,563,564,569,570,577,584,590,591,592:{ //forbidden vehicles (but allowed only to admins and VIPs)
	    if(Account[playerid][pVip]<2 && Account[playerid][pAdminlevel]==0){
		  SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[80]);
		  return 1;}}}
    if(carretta==537 || carretta==538){
      interior=GetPlayerInterior(playerid);
      GetPlayerPos(playerid,Float:x,Float:y,Float:z);GetPlayerFacingAngle(playerid,Float:xrot);
      GetPlayerName(playerid,name,sizeof(name));
      if(strlen(tmp2))col1=strval(tmp2);
      if(strlen(tmp3))col2=strval(tmp3);
      CARS[NumeroAuto]=AddStaticVehicleEx(carretta,x+4,y,z,xrot,col1,col2,9999),LinkVehicleToInterior(CARS[NumeroAuto],interior);SetVehicleVirtualWorld(CARS[NumeroAuto],GetPlayerVirtualWorld(playerid));
      NumeroAuto++;
      format(string,sizeof(string),LanguageText[81],name, VehicleNames[carretta-400],col1,col2);
	  SendClientMessageToAll(COLOR_GREEN,string),print(string);}else{
    interior=GetPlayerInterior(playerid);
    GetPlayerPos(playerid,x,y,z);GetPlayerFacingAngle(playerid,xrot);
    GetPlayerName(playerid,name,sizeof(name));
    if(strlen(tmp2))col1=strval(tmp2);
    if(strlen(tmp3))col2=strval(tmp3);
	CARS[NumeroAuto]=CreateVehicle(carretta,x+4,y,z+0.3,xrot,col1,col2,9999),LinkVehicleToInterior(CARS[NumeroAuto],interior);SetVehicleVirtualWorld(CARS[NumeroAuto],GetPlayerVirtualWorld(playerid));
    NumeroAuto++;
	format(string,sizeof(string),LanguageText[81],name, VehicleNames[carretta-400],col1,col2);
	SendClientMessageToAll(COLOR_GREEN,string),print(string);}
	}}else{
  format(str, sizeof(str), LanguageText[0], CmdsOptions[Veh]);
  SendClientMessage(playerid, COLOR_LIGHTRED, str);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_givecar(playerid,params[]){
  if(ServerInfo[GiveCar]==0){
    CommandDisabled(playerid);}
  new Float:x,Float:y,Float:z,Float:xrot,interior;
  new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],Index,carretta; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
  if(Account[playerid][pAdminlevel]>=CmdsOptions[GiveCar]) if(ServerInfo[GiveCar]==1){
    if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[83]);
      return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[84]);
      return 1;}
    if(!IsNumeric(tmp2)) carretta=GetVehicleModelIDFromName(tmp2); else
      carretta = strval(tmp2);
    if(carretta<400 || carretta>611){
	  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[79]);
	  return 1;}
    player = strval(tmp);
    interior=GetPlayerInterior(player);
    GetPlayerPos(player,Float:x,Float:y,Float:z);GetPlayerFacingAngle(player,Float:xrot);
    GetPlayerName(playerid,name,sizeof(name));GetPlayerName(player,incriminato,sizeof(incriminato));
    format(string,sizeof(string),LanguageText[85],name, VehicleNames[carretta-400], incriminato);
	SendClientMessageToAll(COLOR_ZADMINBLUE,string);
    CARS[NumeroAuto]=CreateVehicle(carretta,x+4,y,z,xrot,Colori[random(8)],Colori[random(8)],9999),LinkVehicleToInterior(CARS[NumeroAuto],interior);SetVehicleVirtualWorld(CARS[NumeroAuto],GetPlayerVirtualWorld(playerid));
    NumeroAuto++;}else{
  format(str, sizeof(str), LanguageText[0], CmdsOptions[Veh]);
  SendClientMessage(playerid, COLOR_LIGHTRED, str);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_countdown(playerid,params[]){
  #pragma unused params
  if(ServerInfo[Count2]==0){
    CommandDisabled(playerid);}
  new mstr[MAX_SERVER_STRING];
  if(ServerInfo[Count2]==1){
	if(CountActive==true){
	  SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[86]);
	  return 1;}
	if(CountActive==false){
	  CountActive=true;
	  pWorld=GetPlayerVirtualWorld(playerid);
	  SetTimer("CountReady",7000,0);
      GetPlayerName(playerid, name, sizeof(name));
      format(string,sizeof(string),LanguageText[87],name),SendClientMessageToAll(COLOR_GREEN,string);
      format(mstr,sizeof(mstr),"~y~%d", Count3);
	  GameTextForAll(mstr,800,3);
	  SetTimer("CountTimer",1000,0);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setaccountdata(playerid, params[]){
	if(Account[playerid][pAdminlevel]>=9){
    new file[MAX_SERVER_STRING],idx,tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],tmp3[MAX_SERVER_STRING],tmp4[MAX_SERVER_STRING],tmp5[MAX_SERVER_STRING],tmp6[MAX_SERVER_STRING];tmp=strtok(params,idx);tmp2=strtok(params,idx);tmp3=strtok(params,idx);tmp4=strtok(params,idx);tmp5=strtok(params,idx);tmp6=strtok(params,idx);
    if(!strlen(tmp)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[88]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[88]);
	  return 1;}
    if(!strlen(tmp3)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[88]);
	  return 1;}
    if(!strlen(tmp4)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[88]);
	  return 1;}
    if(!strlen(tmp5)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[88]);
	  return 1;}
    if(!strlen(tmp6)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[88]);
	  return 1;}
    format(file, sizeof(file), UsersFile, tmp);
    if(!dini_Exists(file)){
	  SendClientMessage(playerid, COLOR_RED, LanguageText[89]);
	  return 1;}
    dini_Set(file, "adminlevel", tmp2);
    dini_Set(file, "score", tmp3);
    dini_Set(file, "money", tmp6);
    dini_Set(file, "deaths", tmp4);
    dini_Set(file, "kills", tmp5);
    player=strval(tmp);
	format(str, sizeof(str), LanguageText[90], tmp,strval(tmp2),strval(tmp3),strval(tmp4),strval(tmp5),strval(tmp6));
	SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_makeaccount(playerid, params[]){
	if(Account[playerid][pAdminlevel]>=6){
    new file[MAX_SERVER_STRING],idx,tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING];tmp=strtok(params,idx);tmp2=strtok(params,idx);
    if(!strlen(tmp)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[91]);
	  return 1;}
    if(!strlen(tmp2)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[91]);
	  return 1;}
    format(file, sizeof(file), UsersFile, tmp);
    if(dini_Exists(file)){
	  SendClientMessage(playerid, COLOR_RED, LanguageText[420]);
	  return 1;}
    dini_Create(file);
    new tmp3[50];
    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
    GetPlayerIp(playerid,tmp3,50);
    dini_Set(file,"ip",tmp3);
    dini_IntSet(file, "hashPW", udb_hash(tmp2));
    dini_Set(file, "password", tmp2);
    dini_IntSet(file, "adminlevel", 0);
    dini_IntSet(file, "VIP", 0);
    dini_IntSet(file, "score", 0);
    dini_IntSet(file, "money", 0);
    dini_IntSet(file, "deaths", 0);
    dini_IntSet(file, "kills", 0);
    dini_IntSet(file, "muted", 0);
    dini_IntSet(file, "freezed", 0);
    dini_IntSet(file, "jailed", 0);
    printf("New account: '%s' with pass '%s'", tmp,tmp2);
	format(str, sizeof(str), LanguageText[92], tmp,tmp2);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_renameaccount(playerid, params[]){
	if(Account[playerid][pAdminlevel]>=6){
    new file[MAX_SERVER_STRING],f2[MAX_SERVER_STRING],idx,tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING];tmp=strtok(params,idx);tmp2=strtok(params,idx);
    if(!strlen(tmp)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[82]);
	  return 1;}
    if(!strlen(tmp2)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[82]);
	  return 1;}
    format(file, sizeof(file), UsersFile, tmp);
    if(!dini_Exists(file)){
	  SendClientMessage(playerid, COLOR_RED, LanguageText[89]);
	  return 1;}
    format(f2, sizeof(f2), UsersFile, tmp2);
    fcopy(file,f2);
	dini_Remove(file);
	format(str, sizeof(str), LanguageText[93], tmp,tmp2);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_removeaccount(playerid, params[]){
	if(Account[playerid][pAdminlevel]>=9){
    new file[MAX_SERVER_STRING],idx,tmp[MAX_SERVER_STRING];tmp=strtok(params,idx);
    if(!strlen(tmp)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[94]);
	  return 1;}
    format(file, sizeof(file), UsersFile, tmp);
    if(!dini_Exists(file)){
	  SendClientMessage(playerid, COLOR_RED, LanguageText[89]);
	  return 1;}
	dini_Remove(file);
	format(str, sizeof(str), LanguageText[95], tmp);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_defultsetting(playerid, params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]==Options[MaxAdminLevel]){
    new file[MAX_SERVER_STRING];
    format(file,sizeof(file),EnableCmdsConfigFile);
    dini_Remove(file),dini_Create(file);
	dini_IntSet(file,"pm",1);
	dini_IntSet(file,"veh",1);
	dini_IntSet(file,"givecar",1);
	dini_IntSet(file,"heal",1);
	dini_IntSet(file,"jetpack",1);
	dini_IntSet(file,"armour",1);
	dini_IntSet(file,"getip",1);
	dini_IntSet(file,"getvhealth",1);
	dini_IntSet(file,"setvhealth",1);
	dini_IntSet(file,"mute",1);
	dini_IntSet(file,"unmute",1);
	dini_IntSet(file,"spec",1);
	dini_IntSet(file,"specoff",1);
	dini_IntSet(file,"kick",1);
	dini_IntSet(file,"ban",1);
	dini_IntSet(file,"fix",1);
	dini_IntSet(file,"flip",1);
	dini_IntSet(file,"jail",1);
	dini_IntSet(file,"unjail",1);
	dini_IntSet(file,"givemoney",1);
	dini_IntSet(file,"reset",1);
	dini_IntSet(file,"freeze",1);
	dini_IntSet(file,"unfreeze",1);
	dini_IntSet(file,"die",1);
	dini_IntSet(file,"slap",1);
	dini_IntSet(file,"goto",1);
	dini_IntSet(file,"get",1);
	dini_IntSet(file,"vgoto",1);
	dini_IntSet(file,"vget",1);
	dini_IntSet(file,"teleplayer",1);
	dini_IntSet(file,"explode",1);
	dini_IntSet(file,"setskin",1);
	dini_IntSet(file,"setskintome",1);
	dini_IntSet(file,"setscore",1);
	dini_IntSet(file,"setweather",1);
	dini_IntSet(file,"setplayerweather",1);
	dini_IntSet(file,"settime",1);
	dini_IntSet(file,"setplayertime",1);
	dini_IntSet(file,"playerdata2",1);
	dini_IntSet(file,"clearchat",1);
	dini_IntSet(file,"gmx",1);
	dini_IntSet(file,"ccars",1);
	dini_IntSet(file,"tempadmin",1);
	dini_IntSet(file,"makeadmin",1);
	dini_IntSet(file,"makevip",1);
	dini_IntSet(file,"removevip",1);
	dini_IntSet(file,"makemegodadmin",1);
	dini_IntSet(file,"weapon",1);
	dini_IntSet(file,"count",1);
	dini_IntSet(file,"setplayerinterior",1);
	dini_IntSet(file,"god",1);
	dini_IntSet(file,"sgod",1);
	dini_IntSet(file,"changename",0);
	dini_IntSet(file,"votekick",1);
	dini_IntSet(file,"voteban",0);
	dini_IntSet(file,"voteccars",1);
	dini_IntSet(file,"warn",1);
	dini_IntSet(file,"banwarn",1);
	dini_IntSet(file,"lock",1);
	dini_IntSet(file,"unlock",1);
	dini_IntSet(file,"carcolor",1);
	dini_IntSet(file,"crash",1);
	dini_IntSet(file,"disarm",1);
	dini_IntSet(file,"burn",1);
	dini_IntSet(file,"removeweapon",1);
	dini_IntSet(file,"setname",1);
	dini_IntSet(file,"eject",1);
	dini_IntSet(file,"resetwarnings",1);
	dini_IntSet(file,"setgravity",1);
	dini_IntSet(file,"achat",1);
	dini_IntSet(file,"announce",1);
	dini_IntSet(file,"forbidword",1);
	dini_IntSet(file,"savepersonalcar",1);

	format(file, sizeof(file), OptionsConfigFile);
    dini_Remove(file),dini_Create(file);
    dini_IntSet(file,"RegisterInDialog",1);
    dini_IntSet(file,"AllowCmdsOnAdmins",0);
    dini_Set(file,"Language","Zadmin_English");
	dini_IntSet(file,"AntiFlood",1);
	dini_IntSet(file,"AntiSpam",1);
	dini_IntSet(file,"AntiSpawnKill",1);
	dini_IntSet(file,"AntiSpawnKillSeconds",5);
	dini_IntSet(file,"AntiBots",1);
	dini_IntSet(file,"RconSecurity",1);
	dini_IntSet(file,"ReadCmds",1);
	dini_IntSet(file,"MustRegister",0);
	dini_IntSet(file,"MustLogin",1);
	dini_IntSet(file,"AutoLogin",1);
	dini_IntSet(file,"MaxVotesForKick",5);
	dini_IntSet(file,"MaxVotesForBan",10);
	dini_IntSet(file,"MaxVotesForCcars",5);
	dini_IntSet(file,"AFKSystem",1);
	dini_IntSet(file,"AntiSwear",1);
	dini_IntSet(file,"AntiForbiddenPartOfName",0);
	dini_IntSet(file,"ConnectMessages",1);
	dini_IntSet(file,"AdminColor",0xE3B515AA);
	dini_IntSet(file,"AutomaticAdminColor",0);
	dini_IntSet(file,"MaxAdminLevel",10); //don't need more than 10.
	dini_IntSet(file,"MaxVipLevel",3);
	dini_IntSet(file,"MaxPing",800);
	dini_IntSet(file,"AntiCmdFlood",1);
	dini_IntSet(file,"MaxPingWarnings",5);
	dini_IntSet(file,"MaxMuteWarnings",3);
	dini_IntSet(file,"MaxSpamWarnings",3);
	dini_IntSet(file,"MaxFloodTimes",5);
	dini_IntSet(file,"MaxFloodSeconds",1);
	dini_IntSet(file,"MaxCFloodSeconds",2);
	dini_IntSet(file,"MaxWarnings",3);
	dini_IntSet(file,"MaxBanWarnings",3);
	dini_IntSet(file,"MaxBanWarnings",6);
	dini_IntSet(file,"AntiDriveBy",0);
	dini_IntSet(file,"AntiHeliKill",0);
	dini_IntSet(file,"AntiCapsLock",0);
	dini_IntSet(file,"ServerWeather",1);
	dini_IntSet(file,"SetOptions",8);
	dini_IntSet(file,"EnableCommands",8);
	dini_IntSet(file,"AntiCheat",8);
	print(LanguageText[96]);
	
	format(file, sizeof(file), AnticheatConfigFile);
    dini_Remove(file),dini_Create(file);
    dini_IntSet(file,"MaxMoney",1000000);
	dini_IntSet(file,"MaxHealth",100);
	dini_IntSet(file,"MaxArmour",100);
    dini_IntSet(file,"AntiJetpack",0);
    dini_IntSet(file,"AntiMinigun",0);
	dini_IntSet(file,"AntiRPG",0);
	dini_IntSet(file,"AntiBazooka",1);
	dini_IntSet(file,"AntiFlameThrower",0);
	dini_IntSet(file,"AntiMolotovs",1);
	dini_IntSet(file,"AntiGrenades",1);
	dini_IntSet(file,"AntiSachetChargers",1);
	dini_IntSet(file,"AntiDetonator",1);
	dini_IntSet(file,"AntiTearGas",0);
	dini_IntSet(file,"AntiShotgun",0);
	dini_IntSet(file,"AntiSawnoffShotgun",0);
	dini_IntSet(file,"AntiCombatShotgun",0);
	dini_IntSet(file,"AntiRifle",0);
	dini_IntSet(file,"AntiRifleSniper",0);
	dini_IntSet(file,"AntiSprayPaint",0);
	dini_IntSet(file,"AntiFireExtinguer",0);
	print(LanguageText[97]);

	format(file,sizeof(file),CmdsLevelsFile);
    dini_Remove(file),dini_Create(file);
	dini_IntSet(file,"Veh",0);
    dini_IntSet(file,"GiveCar",2);
    dini_IntSet(file,"GetIp",1);
    dini_IntSet(file,"GetVHealth",1);
    dini_IntSet(file,"SetVHealth",2);
	dini_IntSet(file,"Mute",2);
	dini_IntSet(file,"UnMute",2);
	dini_IntSet(file,"Spec",1);
	dini_IntSet(file,"SpecOff",1);
	dini_IntSet(file,"Heal",1);
	dini_IntSet(file,"Jetpack",1);
	dini_IntSet(file,"Armour",1);
	dini_IntSet(file,"Kick",3);
	dini_IntSet(file,"Ban",6);
	dini_IntSet(file,"Jail",4);
	dini_IntSet(file,"UnJail",4);
	dini_IntSet(file,"GiveMoney",2);
	dini_IntSet(file,"Reset",8);
	dini_IntSet(file,"Freeze",5);
	dini_IntSet(file,"UnFreeze",5);
	dini_IntSet(file,"Fix",0);
	dini_IntSet(file,"Flip",1);
	dini_IntSet(file,"Die",9);
	dini_IntSet(file,"Slap",4);
	dini_IntSet(file,"Goto",2);
	dini_IntSet(file,"Get",3);
	dini_IntSet(file,"VGoto",2);
	dini_IntSet(file,"VGet",3);
	dini_IntSet(file,"TelePlayer",4);
	dini_IntSet(file,"Explode",4);
	dini_IntSet(file,"Setskin",2);
	dini_IntSet(file,"SetskinToMe",0);
	dini_IntSet(file,"Setscore",5);
	dini_IntSet(file,"SetWeather",3);
	dini_IntSet(file,"SetPlayerWeather",2);
	dini_IntSet(file,"SetTime",3);
	dini_IntSet(file,"SetPlayerTime",2);
	dini_IntSet(file,"PlayerData2",1);
	dini_IntSet(file,"ClearChat",1);
	dini_IntSet(file,"Gmx",10);
	dini_IntSet(file,"Ccars",5);
	dini_IntSet(file,"TempAdmin",1);
	dini_IntSet(file,"MakeAdmin",1);
	dini_IntSet(file,"MakeVip",6);
	dini_IntSet(file,"RemoveVip",6);
	dini_IntSet(file,"Weapon",7);
	dini_IntSet(file,"Count",1);
	dini_IntSet(file,"SetPlayerInterior",8);
	dini_IntSet(file,"God",10);
	dini_IntSet(file,"SGod",10);
	dini_IntSet(file,"ChangeName",3);
	dini_IntSet(file,"Warn",1);
	dini_IntSet(file,"BanWarn",2);
	dini_IntSet(file,"Lock",0);
	dini_IntSet(file,"UnLock",0);
	dini_IntSet(file,"CarColor",0);
	dini_IntSet(file,"Crash",3);
	dini_IntSet(file,"Burn",4);
	dini_IntSet(file,"Disarm",1);
	dini_IntSet(file,"RemoveWeapon",3);
	dini_IntSet(file,"SetName",7);
	dini_IntSet(file,"Eject",3);
	dini_IntSet(file,"ResetWarnings",5);
	dini_IntSet(file,"SetGravity",9);
	dini_IntSet(file,"AChat",1);
	dini_IntSet(file,"Announce",2);
	dini_IntSet(file,"ForbidWord",4);
	ServerConfiguration();}
  return 1;}
  
dcmd_playersrecord(playerid, params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=1){
    new file[MAX_SERVER_STRING];format(file,sizeof(file),MaxPlayersRecordFile);
    format(string,sizeof(string),LanguageText[421],dini_Int(file,"PlayersRecord"));
    SendClientMessage(playerid,COLOR_LIGHTRED,"------------------------");
    SendClientMessage(playerid,COLOR_LIGHTGREEN,string);
    SendClientMessage(playerid,COLOR_LIGHTRED,"------------------------");}
  return 1;}
  
/*******************************************************************************
*                              <=[REGISTRAZIONE]=>                             *
*******************************************************************************/

dcmd_register(playerid, params[]){
    new file[MAX_SERVER_STRING];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
    if(dini_Exists(file)){
	  ShowPlayerDialog(playerid,LoginDialog,DIALOG_STYLE_INPUT,LanguageText[99],LanguageText[98],LanguageText[103],"NO");
	  return 1;}
    if(Options[RegisterInDialog]==0){
      if(!strlen(params)){
	    SendClientMessage(playerid, COLOR_WHITE, LanguageText[101]);
		return 1;}}
    if(Options[RegisterInDialog]==1){
	  ShowPlayerDialog(playerid,RegistrationDialog,DIALOG_STYLE_INPUT,LanguageText[100],LanguageText[5],LanguageText[102],"NO");}
    if(Options[RegisterInDialog]==0){
      Account[playerid][pScore]=GetPlayerScore(playerid);
      Account[playerid][pCash]=GetPlayerMoney(playerid);
      Account[playerid][pLoggedin]=1;
	  PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	  OnPlayerRegister(playerid, params);
      printf("<<<< %s registered [password %s] >>>>", pname, params);}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_login(playerid, params[]){
    GetPlayerName(playerid, pname, sizeof(pname));
    new file[MAX_SERVER_STRING];format(file, sizeof(file), UsersFile, pname);
    if(!dini_Exists(file)){
	  SendClientMessage(playerid, COLOR_RED, LanguageText[105]);
	  return 1;}
    if(Options[RegisterInDialog]==0){
      if(!strlen(params)){
	    SendClientMessage(playerid, COLOR_WHITE, LanguageText[106]);
		return 1;}}
    if(Account[playerid][pLoggedin]==1){
	  SendClientMessage(playerid, COLOR_RED, LanguageText[107]);
	  return 1;}
    if(Options[RegisterInDialog]==1){
	  ShowPlayerDialog(playerid,LoginDialog,DIALOG_STYLE_INPUT,LanguageText[99],LanguageText[108],LanguageText[103],"NO");}
    if(Options[RegisterInDialog]==0){
    new tmp[MAX_SERVER_STRING]; tmp = dini_Get(file, "hashPW");
    if(udb_hash(params) != strval(tmp)){
        SendClientMessage(playerid, COLOR_RED, LanguageText[109]);}else{
          OnPlayerLogin(playerid);
          GetPlayerName(playerid,name,sizeof(name));
          if(Account[playerid][pAdminlevel]==0){
		    format(str, sizeof(str), LanguageText[7],name, dini_Int(file,"score"), Account[playerid][pCash]);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}
          if(Account[playerid][pAdminlevel]>=1){
		    format(str, sizeof(str), LanguageText[8],name, Account[playerid][pAdminlevel], dini_Int(file,"score"), Account[playerid][pCash]);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}
          printf("%s (%i) logged in with password %s", pname, playerid, params);}}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_logout(playerid, params[]){
    new file[MAX_SERVER_STRING];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
    new tmp[MAX_SERVER_STRING]; tmp = dini_Get(file, "hashPW");
    if(Account[playerid][pLoggedin]==0){
	  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[110]);
	  return 1;}
    if(Options[RegisterInDialog]==0){
      if(!strlen(params)){
	    SendClientMessage(playerid, COLOR_WHITE, LanguageText[111]);
		return 1;}}
    if(Options[RegisterInDialog]==1){
	  ShowPlayerDialog(playerid,LogoutDialog,DIALOG_STYLE_INPUT,LanguageText[113],LanguageText[112],LanguageText[114],"NO");}
    if(Options[RegisterInDialog]==0){
	if(udb_hash(params) != strval(tmp)){
        SendClientMessage(playerid, COLOR_RED,LanguageText[109]);}else{
	OnPlayerLogout(playerid);
    SendClientMessage(playerid, COLOR_YELLOW, LanguageText[115]);
    printf("%s Unlogged [password %s]", pname, params);}}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_changepass(playerid, params[]){
    new file[MAX_SERVER_STRING], tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
    if(Account[playerid][pLoggedin]==0){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[422]);
	  return 1;}
    if(Options[RegisterInDialog]==0){
    if(!strlen(tmp)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[116]);
	  return 1;}
    if(!strlen(tmp2)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[116]);
	  return 1;}}
    if(!dini_Exists(file)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[105]);
	  return 1;}
    if(Account[playerid][pLoggedin]!=1){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[117]);
	  return 1;}
    if(Options[RegisterInDialog]==1){
	  ShowPlayerDialog(playerid,ChangePass1Dialog,DIALOG_STYLE_INPUT,LanguageText[118],LanguageText[120],LanguageText[119],"NO");
	  return 1;}
    new tmp3[MAX_SERVER_STRING]; tmp3 = dini_Get(file, "hashPW");
    if(udb_hash(tmp) != strval(tmp3)){
        SendClientMessage(playerid, COLOR_RED, LanguageText[109]);}else{
          PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	      dini_IntSet(file, "hashPW", udb_hash(tmp2));
          dini_Set(file, "password", tmp2);
		  format(str, sizeof(str), LanguageText[121], pname, tmp2);
		  SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
          printf("%s (%i) changed password. New = %s", pname, playerid, tmp2);}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_changename(playerid, params[]){
    if(ServerInfo[ChangeName]==0){
    CommandDisabled(playerid);}
	if(ServerInfo[ChangeName]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
    GetPlayerName(playerid, pname, sizeof(pname));
    if(!strlen(tmp)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[122]);
	  return 1;}
    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
    SetPlayerName(playerid,tmp);
    format(str, sizeof(str), LanguageText[123], pname, tmp);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
    printf("%s (%i) changed his name to \"%s\"", pname, playerid, tmp);}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_votekick(playerid, params[]){
    if(ServerInfo[VoteKick]==0){
    CommandDisabled(playerid);}
	if(ServerInfo[VoteKick]==1){
	AdminsNumber();
	if(AdminsCount>0){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[124]);
	  return 1;}
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);tmp2 = strtok(params,Index);
    if(!strlen(tmp)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[125]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	if(strval(tmp)==playerid){
	  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[127]);
	  return 1;}
    player=strval(tmp);
    if(Account[player][pAdminlevel]>=1){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[128]);
	  return 1;}
    if(!strlen(tmp2)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[125]);
	  return 1;}
	if(MyVoteK[playerid][player]==true){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[129]);
	  return 1;}
    if(MyVoteK[playerid][player]==false){
    if(PlayerInVotekick[player]==false)VoteKickTimer[player]=SetTimerEx("StopVoteKickPlayer",60000,0,"d",player);
    PlayerInVotekick[player]=true;
	GetPlayerName(playerid, pname, sizeof(pname));
	GetPlayerName(player, incriminato, sizeof(incriminato));
	MyVoteK[playerid][player]=true;
    if(Account[player][pVotesForKick]==Options[MaxVotesForKick]-1){
      Account[player][pVotesForKick]++;
      format(str, sizeof(str), LanguageText[130], pname,incriminato,params[2],Account[player][pVotesForKick],Options[MaxVotesForKick]),SendClientMessageToAll(COLOR_ZADMINBLUE, str);
      format(str, sizeof(str), LanguageText[131], incriminato,params[2]),SendClientMessage(player,COLOR_YELLOW, str);
	  Kick(player);
      format(str, sizeof(str), LanguageText[132], incriminato,params[2]),SendClientMessageToAll(COLOR_YELLOW, str);
	  Account[player][pVotesForKick]=0;
	  PlayerInVotekick[player]=false;
	  PlayerInVoteban[player]=false;
	  KillTimer(VoteKickTimer[player]);
      KillTimer(VoteBanTimer[player]);
      for(new i=0;i<MAX_SERVER_PLAYERS;i++){
        MyVoteK[i][player]=false;
	    MyVoteB[i][player]=false;}
	  return 1;}
    if(Account[player][pVotesForKick]<Options[MaxVotesForKick]){
      Account[player][pVotesForKick]++;
      format(str, sizeof(str), LanguageText[130], pname,incriminato,params[2],Account[player][pVotesForKick],Options[MaxVotesForKick]),SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  format(str, sizeof(str), LanguageText[133], player),SendClientMessageToAll(COLOR_ORANGE, str);}}}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_voteban(playerid, params[]){
    if(ServerInfo[VoteBan]==0){
      CommandDisabled(playerid);}
	if(ServerInfo[VoteBan]==1){
	AdminsNumber();
	if(AdminsCount>0){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[134]);
	  return 1;}
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);tmp2 = strtok(params,Index);
    if(!strlen(tmp)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[135]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	if(strval(tmp)==playerid){
	  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[136]);
	  return 1;}
    player=strval(tmp);
    if(IsVoteBanStarted[player]==false){
	if(Account[playerid][pVip]==0){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[137]);}
	return 1;}
    IsVoteBanStarted[player]=true;
    if(IsVoteBanStarted[player]==true){
    if(Account[player][pAdminlevel]>=1){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[138]);
	  return 1;}
    if(!strlen(tmp2)){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[135]);
	  return 1;}
	if(MyVoteB[playerid][player]==true){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[129]);
	  return 1;}
    if(MyVoteB[playerid][player]==false){
    if(PlayerInVoteban[player]==false)VoteBanTimer[player]=SetTimerEx("StopVoteBanPlayer",60000,0,"d",player);
    PlayerInVoteban[player]=true;
	GetPlayerName(playerid, pname, sizeof(pname));
	GetPlayerName(player, incriminato, sizeof(incriminato));
	MyVoteB[playerid][player]=true;
    if(Account[player][pVotesForBan]==Options[MaxVotesForBan]-1){
      Account[player][pVotesForBan]++;
      format(str, sizeof(str), LanguageText[139], pname,incriminato,params[2],Account[player][pVotesForBan],Options[MaxVotesForBan]),SendClientMessageToAll(COLOR_ZADMINBLUE, str);
      format(str, sizeof(str), LanguageText[140], incriminato,params[2]),SendClientMessage(player,COLOR_YELLOW, str);
	  Ban(player);
      format(str, sizeof(str), LanguageText[141], incriminato,params[2]),SendClientMessageToAll(COLOR_YELLOW, str);
	  Account[player][pVotesForBan]=0;
	  PlayerInVoteban[player]=false;
	  PlayerInVotekick[player]=false;
	  KillTimer(VoteKickTimer[player]);
      KillTimer(VoteBanTimer[player]);
      IsVoteBanStarted[player]=false;
      for(new i=0;i<MAX_SERVER_PLAYERS;i++){
        MyVoteK[i][player]=false;
	    MyVoteB[i][player]=false;}
	  return 1;}
    if(Account[player][pVotesForKick]<Options[MaxVotesForBan]){
      Account[player][pVotesForBan]++;
      format(str, sizeof(str), LanguageText[139], pname,incriminato,params[2],Account[player][pVotesForBan],Options[MaxVotesForBan]),SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  format(str, sizeof(str), LanguageText[142], player),SendClientMessageToAll(COLOR_ORANGE, str);}}}}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_voteccars(playerid, params[]){
    if(ServerInfo[VoteCcars]==0){
      CommandDisabled(playerid);}
	if(ServerInfo[VoteCcars]==1){
	AdminsNumber();
	if(AdminsCount>0){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[143]);
	  return 1;}
	GetPlayerName(playerid, pname, sizeof(pname));
	GetPlayerName(player, incriminato, sizeof(incriminato));
	if(MyVoteC[playerid]==true){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[129]);
	  return 1;}
	MyVoteC[playerid]=true;
	if(VoteCcarsActive==false)VoteCcarsTimer=SetTimer("StopVoteCcarsPlayer",60000,0);
    if(VotesForCcars==Options[MaxVotesForCcars]-1){
      format(str, sizeof(str), LanguageText[144], pname,params[2],VotesForCcars,Options[MaxVotesForCcars]),SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
		MyVoteC[i]=false;}
      format(str, sizeof(str), LanguageText[145], incriminato,params[2]),SendClientMessageToAll(COLOR_YELLOW, str);
	  VotesForCcars=0;
	  VoteCcarsActive=false;
	  KillTimer(VoteCcarsTimer);
	  for(new i=2000;i<5000;i++){
	    DestroyVehicle(CARS[i]);
	    NumeroAuto=2000;}
	  return 1;}
    if(VotesForCcars<Options[MaxVotesForCcars]-1){
      VotesForCcars++;
      format(str, sizeof(str), LanguageText[144], pname,VotesForCcars,Options[MaxVotesForCcars]),SendClientMessageToAll(COLOR_ZADMINBLUE, str);}}
    return 1;}
//----------------------------------------------------------------------------//
dcmd_saveskin(playerid, params[]){
  #pragma unused params
  if(ServerInfo[SaveSkin]==0){
    CommandDisabled(playerid);}
  if(ServerInfo[SaveSkin]==1){
    if(Account[playerid][pLoggedin]==0){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[422]);
	  return 1;}
    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
    new file[MAX_SERVER_STRING];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
    format(str,sizeof(str),LanguageText[146],GetPlayerSkin(playerid)),SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
    printf("%s (%i) saved his skin \"%d\"", pname, playerid, GetPlayerSkin(playerid));
    dini_IntSet(file,"MySkin",GetPlayerSkin(playerid));
	Account[playerid][pSkin]=dini_Int(file,"MySkin");}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_myskin(playerid, params[]){
  #pragma unused params
  if(ServerInfo[SaveSkin]==0){
    CommandDisabled(playerid);}
  if(ServerInfo[SaveSkin]==1){
    if(Account[playerid][pLoggedin]==0){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[422]);
	  return 1;}
    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
    new file[MAX_SERVER_STRING];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
    format(str,sizeof(str),LanguageText[147],dini_Int(file,"MySkin")),SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
    printf("%s (%i) loaded his skin \"%d\"", pname, playerid, dini_Int(file,"MySkin"));
    SetPlayerSkin(playerid,dini_Int(file,"MySkin"));
	Account[playerid][pSkin]=dini_Int(file,"MySkin");}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_stats(playerid, params[]){
    #pragma unused params
    new file[MAX_SERVER_STRING];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), UsersFile, pname);
	if(Account[playerid][pLoggedin]==0){
	  SendClientMessage(playerid, COLOR_WHITE, LanguageText[422]);
	  return 1;}
    format(str, sizeof(str), LanguageText[148], pname),SendClientMessage(playerid,COLOR_GREEN,str);
    if(Account[playerid][pAdminlevel]>=1)format(str, sizeof(str), "ADMIN LEVEL: %d", Account[playerid][pAdminlevel]),SendClientMessage(playerid,COLOR_YELLOW,str);
	format(str, sizeof(str), "SCORE: %d", Account[playerid][pScore]),SendClientMessage(playerid,COLOR_WHITE,str);
    format(str, sizeof(str), "DEATHS: %d", Account[playerid][pDeaths]),SendClientMessage(playerid,COLOR_WHITE,str);
    format(str, sizeof(str), "KILLS: %d", Account[playerid][pKills]),SendClientMessage(playerid,COLOR_WHITE,str);
    format(str, sizeof(str), "MONEY: %d$", Account[playerid][pCash]),SendClientMessage(playerid,COLOR_WHITE,str);
    if(Account[playerid][pVip]>=1 || Account[playerid][pAdminlevel]>=1){
      if(!dini_Isset(file,"ID") && !dini_Isset(file,"X")  && !dini_Isset(file,"Y") && !dini_Isset(file,"Z") && !dini_Isset(file,"ROT") && !dini_Isset(file,"COLOR1") && !dini_Isset(file,"COLOR2")){
	    SendClientMessage(playerid,COLOR_WHITE,"NO personal vehicle.");}
	  if(dini_Isset(file,"ID") && dini_Isset(file,"X")  && dini_Isset(file,"Y") && dini_Isset(file,"Z") && dini_Isset(file,"ROT") && dini_Isset(file,"COLOR1") && dini_Isset(file,"COLOR2")){
	    format(str, sizeof(str), "PERSONAL VEHICLE: %s", VehicleNames[dini_Int(file,"ID")-400]),SendClientMessage(playerid,COLOR_WHITE,str);}}
    SendClientMessage(playerid,COLOR_GREEN,"***************************");
    printf("%s (%i) checked his stats", pname, playerid);
    return 1;}

/*******************************************************************************
*                             <=[COMANDI ADMINS]=>                             *
*******************************************************************************/

dcmd_admincmd1(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=1){
    SendClientMessage(playerid, COLOR_ZADMINBLUE, LanguageText[149]);
    SendClientMessage(playerid, COLOR_WHITE, "/asay /announce  |  # [text] (it's private admin chat!)  /admincmd2 /admincolor /playersrecord /defultsetting");
    SendClientMessage(playerid, COLOR_WHITE, "/muted /freezed /jailed /makevip /removevip /savepersonalcar /replacepersonalcar");
    SendClientMessage(playerid, COLOR_WHITE, "/veh /fix /fixpv /flip /givecar /heal /jetp /armour /mute /unmute /jail /unjail /disarm /removeweapon /reset /warn");
    SendClientMessage(playerid, COLOR_WHITE, "/setweather /settime /carcolor /getip /getvhealth /setvhealth /eject /burn /crash /teleplayer /setname /banwarn");
    SendClientMessage(playerid, COLOR_WHITE, "/die /lock /unlock /god /sgod /get /goto /vget /vgoto /setskin /setskintome /setscore /kick /ban /rangeban /freeze");
    SendClientMessage(playerid, COLOR_WHITE, "/unfreeze /slap /explode /spec /specoff /givemoney /setplayerinterior /cchat /reports /reportsoff /gmx /lock");
    SendClientMessage(playerid, COLOR_WHITE, "/setplayerweather /setplayertime /tempAdmin /makeadmin /playerdata /makeaccount /renameaccount /deleteaccount");
	SendClientMessage(playerid, COLOR_YELLOW, LanguageText[150]);
	SendClientMessage(playerid, COLOR_LIGHTRED, "***************************************************************************");}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_vipcmds(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pVip]>=1 || Account[playerid][pAdminlevel]>=1){
    SendClientMessage(playerid, COLOR_ZADMINBLUE, LanguageText[151]);
    SendClientMessage(playerid, COLOR_WHITE, "/veh /votekick /voteban /voteccars /vipcolor /fix /flip "#COL_YELLOW"* [text]");
    SendClientMessage(playerid, COLOR_YELLOW, "PERSONAL VEHICLE: "#COL_WHITE"/savepersonalvehicle /replacepersonalvehicle /mycar /antistealing");
    SendClientMessage(playerid, COLOR_LIGHTRED, "***************************************************************************");}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_admincmd2(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=1){
    SendClientMessage(playerid, COLOR_ZADMINBLUE, LanguageText[152]);
    SendClientMessage(playerid, COLOR_WHITE, "/aheal /aarmour/amute /aunmute /ajail /aunjail /agivemoney /adie /adisarm /areset");
    SendClientMessage(playerid, COLOR_WHITE, "/aexplode /akick /aban /afreeze /aunfreeze /aslap /aget /agoto /asetweather /asettime");
	SendClientMessage(playerid, COLOR_LIGHTRED, "***************************************************************************");}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_admincolor(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=1){
    SendClientMessage(playerid, Options[AdminColor], LanguageText[153]);
    SetPlayerColor(playerid,Options[AdminColor]);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_vipcolor(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pVip]>=1){
    SendClientMessage(playerid, COLOR_VIP, LanguageText[154]);
    SetPlayerColor(playerid,COLOR_VIP);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_muted(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]==0){
    SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[155]);
    return 1;}
  if(Account[playerid][pAdminlevel]>=1){
  new Var;
  for(new x=0;x<MAX_SERVER_PLAYERS;x++){
    if(Account[x][pMuted]==true){
	  Var=1;}}
  if(Var==1){
    SendClientMessage(playerid, COLOR_VIP, LanguageText[156]);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i)){
	    if(Account[i][pMuted]==true){
	      new name2[24];
          GetPlayerName(i, name2, sizeof(name2));
          format(str, sizeof(str), "- %s", name2), SendClientMessage(playerid, COLOR_WHITE, str);}}}}
  if(Var==0){
    SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[157]);}
  Var=0;}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_freezed(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]==0){
    SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[155]);
    return 1;}
  if(Account[playerid][pAdminlevel]>=1){
  new Var;
  for(new x=0;x<MAX_SERVER_PLAYERS;x++){
    if(Account[x][pFreezed]==true){
	  Var=1;}}
  if(Var==1){
    SendClientMessage(playerid, COLOR_VIP, LanguageText[158]);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i)){
	    if(Account[i][pFreezed]==true){
	      new name2[24];
          GetPlayerName(i, name2, sizeof(name2));
          format(str, sizeof(str), "- %s", name2), SendClientMessage(playerid, COLOR_WHITE, str);}}}}
  if(Var==0){
    SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[159]);}
  Var=0;}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_jailed(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]==0){
    SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[155]);
    return 1;}
  if(Account[playerid][pAdminlevel]>=1){
  new Var;
  for(new x=0;x<MAX_SERVER_PLAYERS;x++){
    if(Account[x][pJailed]==true){
	  Var=1;}}
  if(Var==1){
    SendClientMessage(playerid, COLOR_VIP, LanguageText[160]);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i)){
	    if(Account[i][pJailed]==true){
	      new name2[24];
          GetPlayerName(i, name2, sizeof(name2));
          format(str, sizeof(str), "- %s", name2), SendClientMessage(playerid, COLOR_WHITE, str);}}}}
  if(Var==0){
    SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[161]);}
  Var=0;}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_asay(playerid,params[]){
  if(ServerInfo[AChat]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]>=CmdsOptions[AChat] || IsRealRconAdmin[playerid]==true){
	if(ServerInfo[AChat]==1){
    new tmp[MAX_SERVER_STRING],Index; tmp = strtok(params,Index);
    if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[162]);
      return 1;}
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(string, sizeof(string), "*Admin* %s: %s", adminname, params), SendClientMessageToAll(COLOR_ZADMINBLUE,string);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_announce(playerid,params[]){
  if(ServerInfo[AChat]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]>=CmdsOptions[AChat] || IsRealRconAdmin[playerid]==true){
	if(ServerInfo[AChat]==1){
    new tmp[MAX_SERVER_STRING],Index; tmp = strtok(params,Index);
    if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[163]);
      return 1;}
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(string, sizeof(string), LanguageText[164], adminname, params);
	GameTextForAll(string,4000,3);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_lock(playerid,params[]){
  #pragma unused params
  if(ServerInfo[Lock]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Lock] && ServerInfo[Lock]==1){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Lock]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Lock]){
    if(!IsPlayerInAnyVehicle(playerid)){
	  SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[423]);
	  return 1;}
	if(IsPlayerInAnyVehicle(playerid)){
      if(Account[playerid][pVehicleLocked]==true){
		SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[165]);
		return 1;}
      if(Account[playerid][pVehicleLocked]==false){
      GetPlayerName(playerid, adminname, sizeof(adminname));
      Account[playerid][pVehicleLocked]=true;
      SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),playerid,false,true);
      format(string, sizeof(string), LanguageText[166], adminname);
	  SendClientMessageToAll(COLOR_RED,string);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_unlock(playerid,params[]){
  #pragma unused params
  if(ServerInfo[UnLock]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[UnLock] && ServerInfo[UnLock]==1){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[UnLock]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[UnLock]){
    if(!IsPlayerInAnyVehicle(playerid)){
	  SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[423]);
	  return 1;}
	if(IsPlayerInAnyVehicle(playerid)){
      if(Account[playerid][pVehicleLocked]==false){
		SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[167]);
		return 1;}
	  if(Account[playerid][pVehicleLocked]==true){
        Account[playerid][pVehicleLocked]=false;
        SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),playerid,false,false);
        GetPlayerName(playerid, adminname, sizeof(adminname));
        format(string, sizeof(string), LanguageText[168], adminname);
		SendClientMessageToAll(COLOR_GREEN,string);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_reloadzadmin(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]==Options[MaxAdminLevel]){
    SendClientMessage(playerid, COLOR_ZADMINBLUE, LanguageText[169]);
	SendRconCommand("reloadfs Zadmin4.2");}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_unloadzadmin(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=Options[MaxAdminLevel]){
    SendClientMessage(playerid, COLOR_ZADMINBLUE, LanguageText[170]);
	SendRconCommand("unloadfs Zadmin4.2");}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_god(playerid,params[]){
  #pragma unused params
  if(ServerInfo[God]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[God]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[God]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[God]) if(ServerInfo[God]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
	if(Account[playerid][pAdminlevel]>=1)format(string, sizeof(string), LanguageText[171], adminname);
	if(Account[playerid][pAdminlevel]==0)format(string, sizeof(string), LanguageText[172], adminname);
    SendClientMessageToAll(COLOR_ZADMINBLUE, string);
    SetPlayerHealth(playerid,100000);
    GivePlayerWeapon(playerid,16,50000); GivePlayerWeapon(playerid,26,50000);
	GodActive[playerid]=true;}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_sgod(playerid,params[]){
  #pragma unused params
  if(ServerInfo[SGod]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[SGod]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[SGod]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[SGod]) if(ServerInfo[SGod]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
	if(Account[playerid][pAdminlevel]>=1)format(string, sizeof(string), LanguageText[173], adminname);
	if(Account[playerid][pAdminlevel]==0)format(string, sizeof(string), LanguageText[174], adminname);
	SendClientMessageToAll(COLOR_ZADMINBLUE, string);
    SetPlayerHealth(playerid,Options[MaxHealth]);
	GodActive[playerid]=false;}
  return 1;}
  
//**************************[ SINGLE ADMIN COMMANDS ]*************************//
  
dcmd_jetp(playerid,params[]){
  #pragma unused params
  if(ServerInfo[Jetpack]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Jetpack]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Jetpack]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}
  if(Options[AntiJetpack]==1){
    SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[175]);
	return 1;}
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Jetpack]) if(ServerInfo[Jetpack]==1){
    SetPlayerSpecialAction(playerid, 2);
    GetPlayerName(playerid,adminname,sizeof(adminname));
	format(string, sizeof(string), LanguageText[424], adminname);
    SendClientMessageToAll(COLOR_ZADMINBLUE,string);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_heal(playerid,params[]){
  #pragma unused params
  if(ServerInfo[Heal]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Heal]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Heal]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Heal]) if(ServerInfo[Heal]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],Index; tmp = strtok(params,Index);tmp2 = strtok(params,Index);
    if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[425]);
      return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    player=strval(tmp);
    if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
    GetPlayerName(playerid, adminname, sizeof(adminname));
    GetPlayerName(player, incriminato, sizeof(incriminato));
    if(!strlen(tmp2)){
      if(Account[playerid][pAdminlevel]>=1)format(string, sizeof(string), LanguageText[176],adminname, incriminato, Options[MaxHealth]);
	  if(Account[playerid][pAdminlevel]==0)format(string, sizeof(string), LanguageText[177],adminname, incriminato, Options[MaxHealth]);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);
      SetPlayerHealth(player,Options[MaxHealth]);
      return 1;}
	new vita=strval(tmp2);
	if(vita>Options[MaxHealth]){
      format(string, sizeof(string), LanguageText[178], vita, Options[MaxHealth]);
      SendClientMessage(playerid,COLOR_LIGHTRED,string);
      return 1;}
    if(vita==0){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[179]);
      return 1;}
    if(vita>0 && vita<=Options[MaxHealth]){
      GetPlayerName(playerid, adminname, sizeof(adminname));
      GetPlayerName(player, incriminato, sizeof(incriminato));
	  if(Account[playerid][pAdminlevel]>=1)format(string, sizeof(string), LanguageText[176],adminname, incriminato, Options[MaxHealth]);
	  if(Account[playerid][pAdminlevel]==0)format(string, sizeof(string), LanguageText[177],adminname, incriminato, Options[MaxHealth]);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);
      SetPlayerHealth(player,vita);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_armour(playerid,params[]){
  #pragma unused params
  if(ServerInfo[Armour]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Armour]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Armour]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Armour]) if(ServerInfo[Armour]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],Index; tmp = strtok(params,Index);tmp2 = strtok(params,Index);
    if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[180]);
      return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    player=strval(tmp);
    if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
    if(!strlen(tmp2)){
      GetPlayerName(playerid, adminname, sizeof(adminname));
      GetPlayerName(player, incriminato, sizeof(incriminato));
	  if(Account[playerid][pAdminlevel]>=1)format(string, sizeof(string), LanguageText[181],adminname, incriminato, Options[MaxArmour]);
	  if(Account[playerid][pAdminlevel]==0)format(string, sizeof(string), LanguageText[182],adminname, incriminato, Options[MaxArmour]);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);
      SetPlayerArmour(player,Options[MaxArmour]);
      return 1;}
	new vita=strval(tmp2);
	if(vita>Options[MaxArmour]){
      format(string, sizeof(string), LanguageText[183], vita, Options[MaxArmour]);
      SendClientMessage(playerid,COLOR_LIGHTRED,string);
      return 1;}
    if(vita>=0 && vita<=Options[MaxArmour]){
      GetPlayerName(playerid, adminname, sizeof(adminname));
      GetPlayerName(player, incriminato, sizeof(incriminato));
	  if(Account[playerid][pAdminlevel]>=1)format(string, sizeof(string), LanguageText[181],adminname, incriminato, Options[MaxArmour]);
	  if(Account[playerid][pAdminlevel]==0)format(string, sizeof(string), LanguageText[182],adminname, incriminato, Options[MaxArmour]);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);
      SetPlayerArmour(player,vita);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_burn(playerid,params[]){
  if(ServerInfo[Burn]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Burn]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Burn]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Burn]) if(ServerInfo[Burn]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
    new Float:X,Float:Y,Float:Z;
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[184]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  GetPlayerName(playerid, adminname, sizeof(adminname));
      GetPlayerPos(player,X,Y,Z);
	  CreateExplosion(X,Y,Z+3,1,10);
      if(Account[playerid][pAdminlevel]>=1)format(string, sizeof(string), LanguageText[185],adminname, incriminato);
	  if(Account[playerid][pAdminlevel]==0)format(string, sizeof(string), LanguageText[186],adminname, incriminato);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_crash(playerid,params[]){
  if(ServerInfo[Crash]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Crash]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Crash]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Crash]) if(ServerInfo[Crash]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
    new Float:X,Float:Y,Float:Z;
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[187]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  GetPlayerName(playerid, adminname, sizeof(adminname));
      GetPlayerPos(player,X,Y,Z);
	  new objectcrash[200];
      for(new o=0;o<200;o++){
		new i=0;
	    objectcrash[i]=CreatePlayerObject(player,189298743,X,Y,Z,0,0,0);
		i++;}
      for(new o=0;o<200;o++)DestroyObject(o);
	  format(string, sizeof(string), LanguageText[188],adminname, incriminato);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_disarm(playerid,params[]){
  if(ServerInfo[Disarm]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Disarm]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Disarm]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Disarm]) if(ServerInfo[Disarm]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[189]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  GetPlayerName(player, incriminato, sizeof(incriminato));GetPlayerName(playerid, adminname, sizeof(adminname));
	  ResetPlayerWeapons(player);
	  format(string, sizeof(string), LanguageText[190],adminname, incriminato);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_removeweapon(playerid,params[]){
  if(ServerInfo[RemoveWeapon]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[RemoveWeapon]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[RemoveWeapon]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[RemoveWeapon]) if(ServerInfo[RemoveWeapon]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], weap, Index; tmp = strtok(params,Index);tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[191]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[191]);
	  return 1;}
	player = strval(tmp);
	if(!IsNumeric(tmp2)) weap=GetWeaponModelIDFromName(tmp2); else
      weap=strval(tmp2);
	if(weap==0){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[192]);
	  return 1;}
    if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  SetPlayerAmmo(player,weap+1,0);
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  GetPlayerName(playerid, adminname, sizeof(adminname));
	  format(string, sizeof(string), LanguageText[193],adminname, incriminato, WeaponNames[weap+1]);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_spec(playerid,params[]){
  if(ServerInfo[Spec]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Spec]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Spec]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if((Account[playerid][pAdminlevel]>=CmdsOptions[Spec]) || (Account[playerid][pAdminlevel]<=CmdsOptions[Spec] && IsRealRconAdmin[playerid]==true)){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[194]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  if(Spawned[player]==false){
        SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[195]);
	    return 1;}
	  if(Spawned[player]==true){
		if(player==playerid){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[196]);
	      return 1;}
	    GetPlayerName(player, incriminato, sizeof(incriminato));
	    GetPlayerName(playerid, adminname, sizeof(adminname));
        TogglePlayerSpectating(playerid, 1);
        Spectated[player]=true;
        SetPlayerInterior(playerid,GetPlayerInterior(player));
        if(!IsPlayerInAnyVehicle(player))PlayerSpectatePlayer(playerid, player, SPECTATE_MODE_NORMAL);else
        if(IsPlayerInAnyVehicle(player))PlayerSpectateVehicle(playerid, GetPlayerVehicleID(player), SPECTATE_MODE_NORMAL);
	    format(string, sizeof(string), LanguageText[197], incriminato);
		SendClientMessage(playerid, COLOR_ZADMINBLUE, string);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_specoff(playerid,params[]){
  #pragma unused params
  if(ServerInfo[SpecOff]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[SpecOff]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Spec]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if((Account[playerid][pAdminlevel]>=CmdsOptions[SpecOff]) || (Account[playerid][pAdminlevel]<=CmdsOptions[SpecOff] && IsRealRconAdmin[playerid]==true)) if(ServerInfo[SpecOff]==1){
    SetPlayerInterior(playerid,0);
    Spectated[player]=false;
    TogglePlayerSpectating(playerid,0);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_mute(playerid,params[]){
  if(ServerInfo[Mute]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Mute]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Mute]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Mute]) if(ServerInfo[Mute]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],minuti, Index,minmin=1,maxmin=10; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[198]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[198]);
	  return 1;}
	player = strval(tmp);
	minuti = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  if(Account[player][pMuted]==true){
        SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[199]);
	    return 1;}
	  if(minuti<minmin){
        format(string,sizeof(string),LanguageText[200],minmin);
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
        return 1;}
      if(minuti>maxmin){
        format(string,sizeof(string),LanguageText[201],maxmin);
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
        return 1;}
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,incriminato);
	  GetPlayerName(playerid, adminname, sizeof(adminname));
	  MuteTimer[player]=SetTimerEx("UnMutePlayerTimer",minuti*60000,0,"d",player);
      format(str, sizeof(str), LanguageText[202], adminname, incriminato, minuti);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  GameTextForPlayer(player,LanguageText[430],5000,3);
      Account[player][pMuted]=true;
      dini_IntSet(file,"muted",1);
      Account[player][pMuteWarnings]=1;}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_unmute(playerid,params[]){
  if(ServerInfo[UnMute]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[UnMute]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[UnMute]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[UnMute]) if(ServerInfo[UnMute]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[203]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,incriminato);
	  GetPlayerName(playerid, adminname, sizeof(adminname));
      format(str, sizeof(str), LanguageText[204], adminname, incriminato);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, str);
      GameTextForPlayer(player,LanguageText[205],5000,3);
      Account[player][pMuted]=false;
      dini_IntSet(file,"muted",false);
      Account[player][pMuteWarnings]=0;
      KillTimer(MuteTimer[player]);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_getip(playerid,params[]){
  new strip[256];
  if(ServerInfo[GetIp]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[GetIp]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[GetIp]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[GetIp]) if(ServerInfo[GetIp]==1){
    new tmp[MAX_SERVER_STRING],tmp2[50], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[206]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  GetPlayerName(playerid, adminname, sizeof(adminname));
	  GetPlayerIp(player,tmp2,sizeof(tmp2));
	  format(strip,sizeof(strip),LanguageText[207], incriminato, player, tmp2, dini_Get(AkaFile,tmp2));
	  SendClientMessage(playerid,COLOR_ZADMINBLUE,strip);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_getvhealth(playerid,params[]){
  if(ServerInfo[GetVHealth]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[GetVHealth]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[GetVHealth]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[GetVHealth]) if(ServerInfo[GetVHealth]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[208]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	new Float:Vhealth;
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  GetVehicleHealth(GetPlayerVehicleID(player),Vhealth);
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  format(str,sizeof(str),LanguageText[209], incriminato, Vhealth);
	  SendClientMessage(playerid,COLOR_ZADMINBLUE,str);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setvhealth(playerid,params[]){
  if(ServerInfo[SetVHealth]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[SetVHealth]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[SetVHealth]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[SetVHealth]) if(ServerInfo[SetVHealth]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],VHealth, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[210]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[210]);
	  return 1;}
	player = strval(tmp);
	VHealth=strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  if(!IsPlayerInAnyVehicle(player)){
		SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[211]);
	    return 1;}
	  if(IsPlayerInAnyVehicle(player)){
	    GetPlayerName(playerid, adminname, sizeof(adminname));
	    GetPlayerName(player, incriminato, sizeof(incriminato));
	    format(str,sizeof(str),LanguageText[212],adminname, incriminato, VHealth);
		SendClientMessage(playerid,COLOR_ZADMINBLUE,str);
	    SetVehicleHealth(GetPlayerVehicleID(player),VHealth);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_jail(playerid,params[]){
  if(ServerInfo[Jail]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Jail]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Jail]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Jail]) if(ServerInfo[Jail]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],minuti,minmin=1,maxmin=10,Index;tmp=strtok(params,Index);tmp2=strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[213]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[213]);
	  return 1;}
	player = strval(tmp);
	minuti = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
      if(minuti<minmin){
        format(string,sizeof(string),LanguageText[200],minmin);
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
        return 1;}
      if(minuti>maxmin){
        format(string,sizeof(string),LanguageText[201],maxmin);
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
        return 1;}
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,incriminato);
	  GetPlayerName(playerid, adminname, sizeof(adminname));
      format(str, sizeof(str), LanguageText[214], adminname, incriminato, minuti);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, str);
      GameTextForPlayer(player,LanguageText[215],5000,3);
      SetPlayerHealth(player,1);SetPlayerInterior(player,6);
      ResetPlayerWeapons(player);
      Account[player][pJailed]=true;
      dini_IntSet(file,"jailed",1);
      JailTimer[player]=SetTimerEx("UnJailPlayerTimer",minuti*60000,0,"d",player);
      SetPlayerPos(player,264.0535,77.2942,1001.0391);SetPlayerFacingAngle(player,270.0);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_unjail(playerid,params[]){
  if(ServerInfo[UnJail]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[UnJail]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[UnJail]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[UnJail]) if(ServerInfo[UnJail]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[216]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,incriminato);
	  GetPlayerName(playerid, adminname, sizeof(adminname));
      format(str, sizeof(str), LanguageText[217], adminname, incriminato);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, str);
      GameTextForPlayer(player,LanguageText[218],5000,3);
      SetPlayerHealth(playerid,Options[MaxHealth]);SetPlayerInterior(player,0);
      ResetPlayerWeapons(player);
      Account[player][pJailed]=false;
      dini_IntSet(file,"jailed",0);
      KillTimer(JailTimer[player]);
      SpawnPlayer(player);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_warn(playerid,params[]){
  if(ServerInfo[Warn]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Warn]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Warn]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Warn]){
	if(ServerInfo[Warn]==1){
        new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	    if(!strlen(tmp)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[219]);
			return 1;}
        if(!IsNumeric(tmp)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
          return 1;}
        if(!strlen(tmp2)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[219]);
			return 1;}
		player = strval(tmp);
		if(!IsPlayerConnected(player)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	      return 1;}
		if(IsPlayerConnected(player)){
		  if(playerid==player){
            SendClientMessage(playerid, COLOR_RED, LanguageText[220]);}else{
			if(Warninging[playerid]==true){
              SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[221]);
	          return 1;}
		    if(Account[player][pAdminlevel]>=1){
              SendClientMessage(playerid, COLOR_RED, LanguageText[222]);}else{
		 	  GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
		 	  if(Account[player][pWarning]==Options[MaxWarnings]-1){
				format(str, sizeof(str), LanguageText[223], adminname, incriminato, params[2], Account[player][pWarning],Options[MaxWarnings]);
				SendClientMessageToAll(COLOR_YELLOW, str);
			    Account[player][pWarning]=0;
                Kick(player);
                return 1;}
		 	  if(Account[player][pWarning]<Options[MaxWarnings]){
		 	  Account[player][pWarning]++;
		 	  Warninging[playerid]=true;SetTimerEx("StopWarninging",10000,0,"d",playerid);
              format(str, sizeof(str), LanguageText[223], adminname, incriminato, params[2], Account[player][pWarning],Options[MaxWarnings]);
			  SendClientMessageToAll(COLOR_YELLOW, str);
		      printf(LanguageText[223],adminname, incriminato, params[2], Account[player][pWarning],Options[MaxWarnings]);}}}}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_banwarn(playerid,params[]){
  if(ServerInfo[BanWarn]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[BanWarn]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[BanWarn]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[BanWarn]){
	if(ServerInfo[BanWarn]==1){
        new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	    if(!strlen(tmp)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[224]);
			return 1;}
        if(!IsNumeric(tmp)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
          return 1;}
        if(!strlen(tmp2)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[224]);
			return 1;}
		player = strval(tmp);
		if(!IsPlayerConnected(player)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	      return 1;}
		if(IsPlayerConnected(player)){
		  if(playerid==player){
            SendClientMessage(playerid, COLOR_RED, LanguageText[220]);}else{
			if(BanWarninging[playerid]==true){
              SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[221]);
	          return 1;}
		    if(Account[player][pAdminlevel]>=1){
              SendClientMessage(playerid, COLOR_RED, LanguageText[222]);}else{
		 	  GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
		 	  if(Account[player][pBanWarning]==Options[MaxBanWarnings]-1){
				format(str, sizeof(str), LanguageText[225], adminname, incriminato, params[2], Account[player][pBanWarning],Options[MaxBanWarnings]);
				SendClientMessageToAll(COLOR_YELLOW, str);
			    Account[player][pBanWarning]=0;
                Ban(player);
                return 1;}
		 	  if(Account[player][pBanWarning]<Options[MaxWarnings]){
		 	  Account[player][pBanWarning]++;
		 	  BanWarninging[playerid]=true;SetTimerEx("StopBanWarninging",10000,0,"d",playerid);
              format(str, sizeof(str), LanguageText[225], adminname, incriminato, params[2], Account[player][pBanWarning],Options[MaxBanWarnings]);
			  SendClientMessageToAll(COLOR_YELLOW, str);
		      printf(LanguageText[225],adminname, incriminato, params[2], Account[player][pBanWarning],Options[MaxBanWarnings]);}}}}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_kick(playerid,params[]){
  if(ServerInfo[kick]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[kick]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[kick]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[kick]){
	if(ServerInfo[kick]==1){
        new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	    if(!strlen(tmp)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[226]);
			return 1;}
        if(!IsNumeric(tmp)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
          return 1;}
        if(!strlen(tmp2)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[226]);
			return 1;}
		player = strval(tmp);
		if(!IsPlayerConnected(player)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	      return 1;}
		if(IsPlayerConnected(player)){
		  if(player==playerid){
            SendClientMessage(playerid, COLOR_RED, LanguageText[227]);
			return 1;}
          if(Options[AllowCmdsOnAdmins]==0){
			if(Account[player][pAdminlevel]>=1){
              SendClientMessage(playerid, COLOR_RED, LanguageText[228]);
			  return 1;}
	        if(Account[player][pAdminlevel]==0){
			  GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
              format(str, sizeof(str), LanguageText[229], adminname, incriminato, params[2]);
			  SendClientMessageToAll(COLOR_YELLOW, str);
		      GameTextForPlayer(player,LanguageText[230],20000,3);
		      new File:reported = fopen(KickedPlayersFile,io_append);
		      fwrite(reported, str);
		      fclose(reported);
		      printf(LanguageText[229],adminname, incriminato, params[2]); Kick(player);
			  return 1;}}
          if(Options[AllowCmdsOnAdmins]==1){
	 	      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
              format(str, sizeof(str), LanguageText[229], adminname, incriminato, params[2]);
			  SendClientMessageToAll(COLOR_YELLOW, str);
		      GameTextForPlayer(player,LanguageText[230],20000,3);
		      new File:reported = fopen(KickedPlayersFile,io_append);
		      fwrite(reported, str);
		      fclose(reported);
		      printf(LanguageText[229],adminname, incriminato, params[2]); Kick(player);}}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_ban(playerid,params[]){
  if(ServerInfo[ban]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[ban]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[ban]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[ban]){
	if(ServerInfo[ban]==1){
        new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	    if(!strlen(tmp)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[231]);
			return 1;}
        if(!IsNumeric(tmp)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
          return 1;}
        if(!strlen(tmp2)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[231]);
			return 1;}
		player = strval(tmp);
		if(!IsPlayerConnected(player)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	      return 1;}
		if(IsPlayerConnected(player)){
		  if(player==playerid){
            SendClientMessage(playerid, COLOR_RED, LanguageText[232]);
			return 1;}
          if(Options[AllowCmdsOnAdmins]==0){
			if(Account[player][pAdminlevel]>=1){
              SendClientMessage(playerid, COLOR_RED, LanguageText[233]);
			  return 1;}
	        if(Account[player][pAdminlevel]==0){
              Banned[playerid]=true;
			  GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
              format(str, sizeof(str), LanguageText[234], adminname, incriminato, params[2]);
			  SendClientMessageToAll(COLOR_YELLOW, str);
		      GameTextForPlayer(player,LanguageText[235],20000,3);
		      new File:reported = fopen(BannedPlayersFile,io_append);
		      fwrite(reported, str);
		      fclose(reported);
		      printf(LanguageText[234],adminname, incriminato, params[2]); Ban(player);
			  return 1;}}
          if(Options[AllowCmdsOnAdmins]==1){
              Banned[playerid]=true;
	 	      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
              format(str, sizeof(str), LanguageText[234], adminname, incriminato, params[2]);
			  SendClientMessageToAll(COLOR_YELLOW, str);
		      GameTextForPlayer(player,LanguageText[235],20000,3);
		      new File:reported = fopen(BannedPlayersFile,io_append);
		      fwrite(reported, str);
		      fclose(reported);
		      printf(LanguageText[234],adminname, incriminato, params[2]); Ban(player);}}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_rangeban(playerid,params[]){
  if(ServerInfo[ban]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[ban]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[ban]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[ban]){
	if(ServerInfo[ban]==1){
        new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	    if(!strlen(tmp)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[426]);
			return 1;}
        if(!IsNumeric(tmp)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
          return 1;}
        if(!strlen(tmp2)){
			SendClientMessage(playerid, COLOR_WHITE, LanguageText[426]);
			return 1;}
		player = strval(tmp);
		if(!IsPlayerConnected(player)){
          SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	      return 1;}
		if(IsPlayerConnected(player)){
		  if(player==playerid){
            SendClientMessage(playerid, COLOR_RED, LanguageText[232]);
			return 1;}
          if(Options[AllowCmdsOnAdmins]==0){
		    if(Account[player][pAdminlevel]>=1){
              SendClientMessage(playerid, COLOR_RED, LanguageText[233]);
			  return 1;}
            if(Account[player][pAdminlevel]==0){
              Banned[player]=true;
			  GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
              format(str, sizeof(str), LanguageText[427], adminname, incriminato, params[2]);
			  SendClientMessageToAll(COLOR_YELLOW, str);
		      GameTextForPlayer(player,LanguageText[428],20000,3);
  	          gpci(player, strhd, sizeof(strhd));
	          new File:ipbans = fopen(IpBansFile,io_append);
	          format(str,sizeof(str),"%s\r\n",strhd);
	          fwrite(ipbans, str);
	          fclose(ipbans);Ban(player);
	          SendClientMessage(playerid,COLOR_YELLOW,str);
	          LoadIpBans();
		      printf(LanguageText[427],adminname, incriminato, params[2]);
			  return 1;}}
          if(Options[AllowCmdsOnAdmins]==1){
              Banned[player]=true;
	 	      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
              format(str, sizeof(str), LanguageText[427], adminname, incriminato, params[2]);
			  SendClientMessageToAll(COLOR_YELLOW, str);
		      GameTextForPlayer(player,LanguageText[428],20000,3);
  	          gpci(player, strhd, sizeof(strhd));
	          new File:ipbans = fopen(IpBansFile,io_append);
	          format(str,sizeof(str),"%s\r\n",strhd);
	          fwrite(ipbans, str);
	          fclose(ipbans);Ban(player);
	          SendClientMessage(playerid,COLOR_YELLOW,str);
	          LoadIpBans();
		      printf(LanguageText[427],adminname, incriminato, params[2]);}}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_freeze(playerid,params[]){
  if(ServerInfo[Freeze]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Freeze]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Freeze]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Freeze]) if(ServerInfo[Freeze]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[236]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  new file[MAX_SERVER_STRING];
	  GetPlayerName(player, incriminato, sizeof(incriminato));format(file,sizeof(file),UsersFile,incriminato);
	  GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(str, sizeof(str), LanguageText[237],adminname, incriminato);
      SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  TogglePlayerControllable(player,0);Account[player][pFreezed]=true;
      dini_IntSet(file, "freezed", 0);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_unfreeze(playerid,params[]){
  if(ServerInfo[UnFreeze]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[UnFreeze]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[UnFreeze]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[UnFreeze]) if(ServerInfo[UnFreeze]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[238]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
      new file[MAX_SERVER_STRING];
	  GetPlayerName(player, incriminato, sizeof(incriminato));format(file,sizeof(file),UsersFile,incriminato);
	  GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(str, sizeof(str), LanguageText[239],adminname, incriminato);
      SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  TogglePlayerControllable(player,1);Account[player][pFreezed]=false;
	  dini_IntSet(file, "freezed", 0);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setweather(playerid,params[]){
  if(ServerInfo[Setweather]==0){
    CommandDisabled(playerid);}
  new str2[MAX_SERVER_STRING];
  if(Account[playerid][pAdminlevel]<CmdsOptions[Setweather]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Setweather]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Setweather]) if(ServerInfo[Setweather]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[240]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(str2, sizeof(str2), LanguageText[241], adminname, player);
	SendClientMessageToAll(COLOR_ZADMINBLUE, str2);
    format(str2,sizeof(str2),OptionsConfigFile);
	dini_IntSet(str2,"ServerWeather",player);
	SetWeather(player);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_settime(playerid,params[]){
  if(ServerInfo[Settime]==0){
    CommandDisabled(playerid);}
  new str2[MAX_SERVER_STRING];
  if(Account[playerid][pAdminlevel]<CmdsOptions[Settime]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Settime]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Settime]) if(ServerInfo[Settime]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[242]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(str2, sizeof(str2), LanguageText[243], adminname, player);
	SendClientMessageToAll(COLOR_ZADMINBLUE, str2);
    SetWorldTime(player);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setgravity(playerid,params[]){
  if(ServerInfo[Setgravity]==0){
    CommandDisabled(playerid);}
  new str2[MAX_SERVER_STRING];
  if(Account[playerid][pAdminlevel]<CmdsOptions[Setgravity]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Setgravity]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Setgravity]) if(ServerInfo[Setgravity]==1){
    new tmp[MAX_SERVER_STRING], Index,grr; tmp = strtok(params,Index);
    new Float:Gravity = floatstr(tmp);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[244]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	Gravity=strval(tmp);
	grr=strval(tmp);
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(str2, sizeof(str2), LanguageText[245], adminname, grr);
	SendClientMessageToAll(COLOR_ZADMINBLUE, str2);
    SetGravity(Gravity/1000);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_slap(playerid,params[]){
  if(ServerInfo[Slap]==0){
    CommandDisabled(playerid);}
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]<CmdsOptions[Slap]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Slap]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Slap]) if(ServerInfo[Slap]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[246]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
	  GetPlayerPos(player, Float:X,Float:Y,Float:Z);
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(str, sizeof(str), LanguageText[247],adminname, incriminato);
      SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  GameTextForPlayer(player, LanguageText[248],3000,4); SetPlayerPos(player,X,Y,Z+50);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_explode(playerid,params[]){
  if(ServerInfo[Explode]==0){
    CommandDisabled(playerid);}
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]<CmdsOptions[Explode]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Explode]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Explode]) if(ServerInfo[Explode]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[249]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
	  GetPlayerPos(player, Float:X,Float:Y,Float:Z);
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(str, sizeof(str), LanguageText[250],adminname, incriminato);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  GameTextForPlayer(player, LanguageText[251],3000,4); CreateExplosion(X,Y,Z,10,1200);CreateExplosion(X,Y,Z,10,1200);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_get(playerid,params[]){
  if(ServerInfo[Get]==0){
    CommandDisabled(playerid);}
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]<CmdsOptions[Get]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Get]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Get]) if(ServerInfo[Get]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[252]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player) && GetPlayerVirtualWorld(player)==GetPlayerVirtualWorld(playerid)){
	  GetPlayerPos(playerid, Float:X,Float:Y,Float:Z);
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(str, sizeof(str), LanguageText[253],adminname, incriminato);
      SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  SetPlayerPos(player,X+3,Y,Z);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_vget(playerid,params[]){
  if(ServerInfo[VGet]==0){
    CommandDisabled(playerid);}
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]<CmdsOptions[VGet]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[VGet]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[VGet]) if(ServerInfo[VGet]==1){
    new tmp[MAX_SERVER_STRING],INTERIOR, Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[254]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player) && GetPlayerVirtualWorld(player)==GetPlayerVirtualWorld(playerid)){
      if(!IsPlayerInAnyVehicle(player)){
        SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[255]);
	    return 1;}
      if(IsPlayerInAnyVehicle(player)){
	    GetPlayerPos(playerid, Float:X,Float:Y,Float:Z);
	    INTERIOR=GetPlayerInterior(playerid);
        GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
        format(string, sizeof(string), LanguageText[256], adminname, incriminato);
		SendClientMessageToAll(COLOR_LIGHTRED, string);
        if(IsPlayerInAnyVehicle(player)) TelePlayerVehicle(player,X,Y,Z,0,INTERIOR);else
	    SetPlayerPos(player,X+3,Y,Z);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_goto(playerid,params[]){
  if(ServerInfo[Goto]==0){
    CommandDisabled(playerid);}
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]<CmdsOptions[Goto]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Goto]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Goto]) if(ServerInfo[Goto]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[257]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player) && GetPlayerVirtualWorld(playerid)==GetPlayerVirtualWorld(player)){
	  GetPlayerPos(player, Float:X,Float:Y,Float:Z);
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(str, sizeof(str), LanguageText[258],adminname, incriminato);
      SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  SetPlayerPos(playerid,X+3,Y,Z);
	  SetPlayerInterior(playerid,GetPlayerInterior(player));}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_vgoto(playerid,params[]){
  if(ServerInfo[VGoto]==0){
    CommandDisabled(playerid);}
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]<CmdsOptions[VGoto]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[VGoto]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[VGoto]) if(ServerInfo[VGoto]==1){
    new tmp[MAX_SERVER_STRING],INTERIOR, Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[259]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player) && GetPlayerVirtualWorld(playerid)==GetPlayerVirtualWorld(player)){
	  if(!IsPlayerInAnyVehicle(playerid)){
        SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[260]);
	    return 1;}
      if(IsPlayerInAnyVehicle(playerid)){
	    GetPlayerPos(player, Float:X,Float:Y,Float:Z);
	    INTERIOR=GetPlayerInterior(player);
        GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	    format(str, sizeof(str), LanguageText[261],adminname, incriminato);
        SendClientMessageToAll(COLOR_ZADMINBLUE, str);
        if(IsPlayerInAnyVehicle(playerid))TelePlayerVehicle(playerid,X,Y,Z,0,INTERIOR);else
	    SetPlayerPos(playerid,X+3,Y,Z);
		SetPlayerInterior(playerid,GetPlayerInterior(player));
		LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(player));}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_teleplayer(playerid,params[]){
  if(ServerInfo[TelePlayer]==0){
    CommandDisabled(playerid);}
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]<CmdsOptions[TelePlayer]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[TelePlayer]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[TelePlayer]) if(ServerInfo[TelePlayer]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], player2, secondoplayer[24], Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[262]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[262]);
	  return 1;}
	player = strval(tmp);
	player2 = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[263]);
	  return 1;}
    if(!IsPlayerConnected(player2)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[264]);
	  return 1;}
	if(IsPlayerConnected(player) && IsPlayerConnected(player2) && GetPlayerVirtualWorld(player)==GetPlayerVirtualWorld(player2)){
	  GetPlayerPos(player2, Float:X,Float:Y,Float:Z);
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname)); GetPlayerName(player2, secondoplayer, sizeof(secondoplayer));
   	  format(str, sizeof(str), LanguageText[265],adminname, incriminato, secondoplayer);
      SendClientMessageToAll(COLOR_ZADMINBLUE, str);
	  SetPlayerPos(player,X+3,Y,Z);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_eject(playerid,params[]){
  if(ServerInfo[Eject]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Eject]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Eject]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Eject]) if(ServerInfo[Eject]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[266]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
	  if(!IsPlayerInAnyVehicle(player)){
        SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[429]);
        return 1;}
      if(IsPlayerInAnyVehicle(player)){
        GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
        format(string, sizeof(string), LanguageText[267], adminname, incriminato);
	    SendClientMessageToAll(COLOR_LIGHTRED, string);
	    RemovePlayerFromVehicle(player);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setname(playerid,params[]){
  if(ServerInfo[SetName]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[SetName]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[SetName]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[SetName]) if(ServerInfo[SetName]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING], Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[268]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[268]);
	  return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(string, sizeof(string), LanguageText[269], incriminato, tmp2);
      SendClientMessage(playerid, COLOR_YELLOW, string);
      format(string, sizeof(string), LanguageText[270], adminname, incriminato, tmp2);
	  SendClientMessageToAll(COLOR_LIGHTRED, string);
	  SetPlayerName(player,tmp2);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_resetwarnings(playerid,params[]){
  if(ServerInfo[ResetWarnings]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[ResetWarnings]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[ResetWarnings]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[ResetWarnings]) if(ServerInfo[ResetWarnings]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[271]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
      format(string, sizeof(string), LanguageText[272], adminname, incriminato);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);
      Account[player][pMuteWarnings]=0;
      Account[player][pPingWarnings]=0;
      Account[player][pFloodding]=0;
      Account[player][pFlood]=false;
      Account[player][pWarning]=0;
	  Account[player][pSpamWarnings]=0;}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_reset(playerid,params[]){
  if(ServerInfo[Reset]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Reset]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Reset]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Reset]) if(ServerInfo[Reset]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[273]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(string, sizeof(string), LanguageText[274], adminname, incriminato);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);
	  ResetPlayerWeapons(player);SetPlayerHealth(player,1);ResetPlayerMoney(player);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_fix(playerid,params[]){
  #pragma unused params
  if(ServerInfo[Fix]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Fix] && Account[playerid][pVip]==0){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Fix]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Fix] || Account[playerid][pVip]>=1) if(ServerInfo[Fix]==1){
    GetPlayerName(playerid,pname,sizeof(pname));
    if(IsPlayerInAnyVehicle(playerid)){
      if(AllowFixing[playerid]==false){
        SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[275]);
	    return 1;}
  	  if(AllowFixing[playerid]==true){
        RepairVehicle(GetPlayerVehicleID(playerid));
        AllowFixing[playerid]=false;
        SetTimerEx("AllowPlayerFixing",60*1000,0,"d",playerid);
        GameTextForPlayer(playerid,LanguageText[276],3000,4);
        format(string,sizeof(string),LanguageText[277],pname);
		SendClientMessageToAll(COLOR_GREEN,string);}}
	    else{
	      SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[74]);
	      return 1;}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_fixpv(playerid,params[]){
  new strip[256];
  if(ServerInfo[Fix]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<1){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[GetIp]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=1) if(ServerInfo[Fix]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[449]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
	  return 1;}
	if(IsPlayerConnected(player)){
	  if(!IsPlayerInAnyVehicle(player)){
		SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[211]);
		return 1;}
	  if(IsPlayerInAnyVehicle(player)){
		RepairVehicle(GetPlayerVehicleID(player));
	    GetPlayerName(player, incriminato, sizeof(incriminato));
	    GetPlayerName(playerid, adminname, sizeof(adminname));
	    format(strip,sizeof(strip),LanguageText[450], adminname,incriminato);
	    SendClientMessageToAll(COLOR_ZADMINBLUE,strip);
		GameTextForPlayer(player,LanguageText[276],3000,4);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_flip(playerid,params[]){
  #pragma unused params
  if(ServerInfo[Flip]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Flip] && Account[playerid][pVip]==0){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Flip]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Flip] || Account[playerid][pVip]>=1) if(ServerInfo[Flip]==1){
    new Float:x,Float:y,Float:z,Float:ang,vehicle;
    vehicle=GetPlayerVehicleID(playerid);
    GetPlayerName(playerid,pname,sizeof(pname));
    if(IsPlayerInAnyVehicle(playerid)){
	  GetPlayerPos(playerid,x,y,z);GetVehicleZAngle(vehicle, ang);
	  SetVehiclePos(vehicle,x,y,z);SetVehicleZAngle(vehicle,ang);
	  GameTextForPlayer(playerid,LanguageText[278],3000,4);
      format(string,sizeof(string),LanguageText[279],pname);
	  SendClientMessageToAll(COLOR_GREEN,string);}
	  else{
	    SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[74]);
	    return 1;}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_gmx(playerid,params[]){
  #pragma unused params
  if(ServerInfo[Gmx]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Gmx]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Gmx]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Gmx]) if(ServerInfo[Gmx]==1){
	SendRconCommand("gmx");
	GameTextForAll(LanguageText[280],8000,3);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_ccars(playerid,params[]){
  #pragma unused params
  if(ServerInfo[Ccars]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Ccars]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Ccars]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Ccars]) if(ServerInfo[Ccars]==1){
	GetPlayerName(playerid,adminname,24);
    format(string,sizeof(string),LanguageText[281],name);
	SendClientMessageToAll(COLOR_ZADMINBLUE,string);
    for(new i=2000;i<5000;i++){
	  DestroyVehicle(CARS[i]);
	  NumeroAuto=2000;}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_givemoney(playerid,params[]){
  if(ServerInfo[GiveMoney]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[GiveMoney]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[GiveMoney]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[GiveMoney]) if(ServerInfo[GiveMoney]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],ammount, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[282]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[282]);
	  return 1;}
	player = strval(tmp);
	ammount = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(ammount<0){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[283]);
	  return 1;}
    GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	format(string, sizeof(string), LanguageText[284], adminname, incriminato, ammount);
    SendClientMessageToAll(COLOR_LIGHTRED, string);
    #if defined SpecialAntiMoneyHack
	  GiveZMoney(player,ammount);
	#else
      GivePlayerMoney(player,ammount);
	#endif
	}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_tempadmin(playerid,params[]){
  if(ServerInfo[TempAdmin]==0){
    CommandDisabled(playerid);}
  new file2[MAX_SERVER_STRING];
  if(Account[playerid][pAdminlevel]<CmdsOptions[TempAdmin] && IsRealRconAdmin[playerid]==false){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[TempAdmin]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[TempAdmin] || IsRealRconAdmin[playerid]==true) if(ServerInfo[TempAdmin]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],livello, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[285]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[285]);
	  return 1;}
	player = strval(tmp);
	livello = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
	  if(livello>Account[playerid][pAdminlevel]){
		SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[286]);
		return 1;}else
      if(livello>Options[MaxAdminLevel]){
		SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[287]);
		return 1;}else
      GetPlayerName(player, incriminato, sizeof(incriminato));
	  GetPlayerName(playerid, adminname, sizeof(adminname));
	  format(file2, sizeof(file2), UsersFile, incriminato);
      format(string, sizeof(string), LanguageText[288], adminname, incriminato, livello);
	  SendClientMessageToAll(COLOR_LIGHTRED, string);
	  GameTextForPlayer(player,LanguageText[431],3000,6);
      Account[player][pAdminlevel]=livello;}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_makemegodadmin(playerid,params[]){
  #pragma unused params
  if(ServerInfo[MakeMeGodAdmin]==0){
    CommandDisabled(playerid);}
  new file2[MAX_SERVER_STRING];
  if(ServerInfo[MakeMeGodAdmin]==1){
    if(IsRealRconAdmin[playerid]==false){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[289]);}else
    if(IsRealRconAdmin[playerid]==true){
      GetPlayerName(playerid, adminname, sizeof(adminname));
      format(file2, sizeof(file2), UsersFile, adminname);
   	  format(string, sizeof(string), LanguageText[290], adminname, Options[MaxAdminLevel]);
	  SendClientMessageToAll(COLOR_LIGHTRED, string);
	  GameTextForPlayer(player,LanguageText[432],3000,6);
      Account[playerid][pAdminlevel]=Options[MaxAdminLevel];
	  dini_IntSet(file2, "adminlevel", Options[MaxAdminLevel]);
	  Account[playerid][pVip]=0;
	  dini_IntSet(file2, "VIP", 0);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_makeadmin(playerid,params[]){
  if(ServerInfo[MakeAdmin]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[MakeAdmin] && IsRealRconAdmin[playerid]==false){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[MakeAdmin]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[MakeAdmin] || IsRealRconAdmin[playerid]==true) if(ServerInfo[MakeAdmin]==1){
    new file2[MAX_SERVER_STRING],tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],livello, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[291]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[291]);
	  return 1;}
    player = strval(tmp);
    if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[41]);
	  return 1;}
	livello = strval(tmp2);
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato));
      format(file2, sizeof(file2), UsersFile, incriminato);
      if(!fexist(file2)){
        SendClientMessage(playerid, COLOR_WHITE, LanguageText[292]);
	    return 1;}
      if(livello>Account[playerid][pAdminlevel]){
		SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[286]);
		return 1;}else
      if(livello>Options[MaxAdminLevel]){
		SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[287]);
		return 1;}
	  if(livello<Account[player][pAdminlevel] && livello>=0){
		  GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	      format(string, sizeof(string), LanguageText[293], adminname, incriminato, livello);
		  SendClientMessageToAll(COLOR_LIGHTRED, string);
		  GameTextForPlayer(player,LanguageText[433],3000,6);
          Account[player][pAdminlevel]=livello;
	      dini_IntSet(file2, "adminlevel", livello);}else
      if(livello<=Options[MaxAdminLevel] && livello>=0){
		if(Account[player][pVip]>=1)Account[player][pVip]=0;
	    GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	    format(string, sizeof(string), LanguageText[294], adminname, incriminato, livello);
		SendClientMessageToAll(COLOR_GREEN, string);
		GameTextForPlayer(player,LanguageText[432],3000,6);
        Account[player][pAdminlevel]=livello;
	    dini_IntSet(file2, "adminlevel", livello);
		Account[player][pVip]=0;
	    dini_IntSet(file2, "VIP", 0);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_makevip(playerid,params[]){
  if(ServerInfo[MakeVip]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[MakeVip] && IsRealRconAdmin[playerid]==false){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[MakeVip]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[MakeVip] || IsRealRconAdmin[playerid]==true) if(ServerInfo[MakeVip]==1){
    new file2[MAX_SERVER_STRING],tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],livello, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[295]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[295]);
	  return 1;}
    player = strval(tmp);
    if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	livello = strval(tmp2);
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato));
      format(file2, sizeof(file2), UsersFile, incriminato);
      if(!fexist(file2)){
        SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[296]);
	    return 1;}
      if(livello>Options[MaxVipLevel]){
		SendClientMessage(playerid,COLOR_LIGHTRED,LanguageText[287]);
		return 1;}
	  if(livello<Account[player][pVip] && livello>=0){
        SendClientMessage(playerid, COLOR_WHITE, LanguageText[298]);
	    return 1;}
      if(livello<=Options[MaxVipLevel] && livello>=0){
	    GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	    format(string, sizeof(string), LanguageText[297], adminname, incriminato, livello);
		SendClientMessageToAll(COLOR_GREEN, string);
		GameTextForPlayer(player,LanguageText[436],3000,6);
        Account[player][pVip]=livello;
        Account[player][pAdminlevel]=0;
	    dini_IntSet(file2, "VIP", livello);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_removevip(playerid,params[]){
  if(ServerInfo[RemoveVip]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[RemoveVip] && IsRealRconAdmin[playerid]==false){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[RemoveVip]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[RemoveVip] || IsRealRconAdmin[playerid]==true) if(ServerInfo[RemoveVip]==1){
    new file2[MAX_SERVER_STRING],tmp[MAX_SERVER_STRING],Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[298]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    player = strval(tmp);
    if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato));
      format(file2, sizeof(file2), UsersFile, incriminato);
      if(!fexist(file2)){
        SendClientMessage(playerid, COLOR_WHITE, LanguageText[299]);
	    return 1;}
	  GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(string, sizeof(string), LanguageText[300], adminname, incriminato);
      SendClientMessageToAll(COLOR_LIGHTRED, string);
	  GameTextForPlayer(player,LanguageText[433],3000,6);
      Account[player][pVip]=0;
	  dini_IntSet(file2, "VIP", 0);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setskin(playerid,params[]){
  if(ServerInfo[Setskin]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Setskin]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Setskin]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Setskin]) if(ServerInfo[Setskin]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],skin, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[301]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[301]);
	  return 1;}
	player = strval(tmp);
	skin = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      if(skin>299 || skin<0){
        SendClientMessage(playerid, COLOR_WHITE, LanguageText[302]);
	    return 1;}
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
      format(string, sizeof(string), LanguageText[303], adminname, incriminato, skin);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);
      SetPlayerSkin(player,skin);
	  Account[player][pSkin]=skin;}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setskintome(playerid,params[]){
  if(ServerInfo[Setskin]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pVip]<2 && Account[playerid][pAdminlevel]<CmdsOptions[Setskin]){
    format(string, sizeof(string), "Devi avere livello admin %d per usare questo CMD (o essere VIP lvl 2)!!!", CmdsOptions[Setskin]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pVip]>=2 || Account[playerid][pAdminlevel]>=CmdsOptions[Setskin]) if(ServerInfo[Setskin]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[304]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
    if(player>299 || player<0){
        SendClientMessage(playerid, COLOR_WHITE, LanguageText[302]);
	    return 1;}
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(string, sizeof(string), LanguageText[305], adminname,player);
	SendClientMessageToAll(COLOR_ZADMINBLUE, string);
    SetPlayerSkin(playerid,player);
	Account[playerid][pSkin]=player;}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setscore(playerid,params[]){
  if(ServerInfo[Setscore]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Setscore]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Setscore]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Setscore]) if(ServerInfo[Setscore]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],score, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[306]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[306]);
	  return 1;}
	player = strval(tmp);
	score = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
      format(string, sizeof(string), LanguageText[307], adminname, incriminato, score);
	  SendClientMessageToAll(COLOR_ZADMINBLUE, string);
	  Account[player][pScore]=score;
	  SetPlayerScore(player,score);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setplayerinterior(playerid,params[]){
  if(ServerInfo[Setplayerinterior]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Setplayerinterior]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Setplayerinterior]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Setplayerinterior]) if(ServerInfo[Setplayerinterior]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],livello, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[308]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[308]);
	  return 1;}
    if(!IsNumeric(tmp2)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	livello = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));
   	  format(string, sizeof(string), LanguageText[309], adminname, incriminato, livello);
      SendClientMessageToAll(COLOR_LIGHTRED, string);
      SetPlayerInterior(player,livello);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_die(playerid,params[]){
  if(ServerInfo[Die]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Die]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Die]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Die]) if(ServerInfo[Die]==1){
    new tmp[MAX_SERVER_STRING], Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[310]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
	  GetPlayerName(player, incriminato, sizeof(incriminato));
	  GetPlayerName(playerid, adminname, sizeof(adminname));
	  SetPlayerHealth(player,0);
      format(str, sizeof(str), LanguageText[311], adminname, incriminato); SendClientMessageToAll(COLOR_YELLOW, str);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_cchat(playerid,params[]){
  #pragma unused params
  if(ServerInfo[ClearChat]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[ClearChat]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[ClearChat]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[ClearChat]) if(ServerInfo[ClearChat]==1){
    for(new i=0;i<100;i++)SendClientMessageToAll(COLOR_WHITE,"  ");}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_weapon(playerid,params[]){
  if(ServerInfo[Weapon]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Weapon]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Weapon]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Weapon]){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],tmp3[MAX_SERVER_STRING],arma,ammo, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[312]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[312]);
	  return 1;}
    if(!strlen(tmp3)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[312]);
	  return 1;}
	player = strval(tmp);
	if(!IsNumeric(tmp2)) arma=GetWeaponModelIDFromName(tmp2); else
      arma = strval(tmp2);
	ammo = strval(tmp3);
	GetPlayerName(player, incriminato, sizeof(incriminato));
	GetPlayerName(playerid, adminname, sizeof(adminname));
	switch(arma){
	  case MINIGUN:{
        if(Options[AntiMinigun]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
      case RPG:{
        if(Options[AntiRPG]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
      case ROCKET_LAUNCHER:{
        if(Options[AntiBazooka]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case FLAME_THROWER:{
        if(Options[AntiFlameThrower]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case MOLOTOVS:{
        if(Options[AntiMolotovs]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case GRENADES:{
        if(Options[AntiGrenades]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case SACHET_CHARGERS:{
        if(Options[AntiSachetChargers]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case DETONATOR:{
        if(Options[AntiDetonator]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case TEAR_GAS:{
        if(Options[AntiTearGas]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case SHOTGUN:{
        if(Options[AntiShotgun]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case SAWNOFF_SHOTGUN:{
        if(Options[AntiSawnoffShotgun]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case COMBAT_SHOTGUN:{
        if(Options[AntiCombatShotgun]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case RIFLE:{
        if(Options[AntiRifle]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case SNIPER_RIFLE:{
        if(Options[AntiRifleSniper]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
      case SPRAY_PAINT:{
        if(Options[AntiSprayPaint]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case FIRE_EXTINGUER:{
        if(Options[AntiFireExtinguer]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}}
    if(arma<0 || arma>46){
	  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[79]);
	  return 1;}else{
    format(str, sizeof(str), LanguageText[314], adminname, incriminato, WeaponNames[arma+1], ammo);
	SendClientMessageToAll(COLOR_YELLOW, str);
	GivePlayerWeapon(player,arma+1,ammo);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_command(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=CmdsOptions[EnableCommands] || IsRealRconAdmin[playerid]==true){
    ShowFirstCommandsDialog(playerid);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_anticheat(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Anticheat] || IsRealRconAdmin[playerid]==true){
    ShowAnticheatItemsDialog(playerid);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_set(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=CmdsOptions[SetOptions] || IsRealRconAdmin[playerid]==true){
    ShowOptionsConfigDialog(playerid);}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setplayerweather(playerid,params[]){
  if(ServerInfo[Setplayerweather]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Setplayerweather]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Setplayerweather]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Setplayerweather]) if(ServerInfo[Setplayerweather]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],tempo, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[315]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[315]);
	  return 1;}
    if(!IsNumeric(tmp2)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	tempo = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));GetPlayerName(player, incriminato, sizeof(incriminato));
      format(string, sizeof(string), LanguageText[316], adminname, tempo, incriminato); SendClientMessageToAll(COLOR_LIGHTRED, string);
      SetPlayerWeather(player,tempo);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_setplayertime(playerid,params[]){
  if(ServerInfo[Setplayertime]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[Setplayertime]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[Setplayertime]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[Setplayertime]) if(ServerInfo[Setplayertime]==1){
    new tmp[MAX_SERVER_STRING],tmp2[MAX_SERVER_STRING],tempo, Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[317]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
    if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[317]);
	  return 1;}
    if(!IsNumeric(tmp2)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	tempo = strval(tmp2);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato)); GetPlayerName(playerid, adminname, sizeof(adminname));GetPlayerName(player, incriminato, sizeof(incriminato));
   	  format(string, sizeof(string), LanguageText[318], adminname,incriminato, tempo); SendClientMessage(player, COLOR_LIGHTRED, string);
      SetPlayerTime(player,tempo,0);}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_playerdata(playerid,params[]){
  if(ServerInfo[PlayerData2]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[PlayerData2]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[PlayerData2]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[PlayerData2]) if(ServerInfo[PlayerData2]==1){
    new tmp[MAX_SERVER_STRING],file[MAX_SERVER_STRING],Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[319]);
	  return 1;}
    if(!IsNumeric(tmp)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[40]);
      return 1;}
	player = strval(tmp);
	if(!IsPlayerConnected(player)){
      SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[41]);
      return 1;}
	if(IsPlayerConnected(player)){
      if(!IsPlayerRegistered(player)){
		SendClientMessage(playerid, COLOR_WHITE, LanguageText[434]);
	    return 1;}
	  if(IsPlayerRegistered(player)){
      GetPlayerName(player, incriminato, sizeof(incriminato));
      format(file,sizeof(file),UsersFile,incriminato);
      format(string, sizeof(string), LanguageText[320], incriminato); SendClientMessage(playerid, COLOR_GREEN, string);
      format(string, sizeof(string), LanguageText[321], dini_Get(string,"RegistrationDate")); SendClientMessage(playerid, COLOR_WHITE, string);
	  format(string, sizeof(string), LanguageText[322], Account[player][pCash]); SendClientMessage(playerid, COLOR_WHITE, string);
	  format(string, sizeof(string), LanguageText[323], Account[player][pScore]); SendClientMessage(playerid, COLOR_WHITE, string);
	  format(string, sizeof(string), LanguageText[324], Account[player][pDeaths]); SendClientMessage(playerid, COLOR_WHITE, string);
	  format(string, sizeof(string), LanguageText[325], Account[player][pKills]); SendClientMessage(playerid, COLOR_WHITE, string);
	  format(string, sizeof(string), LanguageText[326], dini_Int(file,"MySkin")); SendClientMessage(playerid, COLOR_WHITE, string);
	  SendClientMessage(playerid,COLOR_GREEN,"******************************************");}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_forbidword(playerid,params[]){
  if(ServerInfo[ForbidWord]==0){
    CommandDisabled(playerid);}
  if(Account[playerid][pAdminlevel]<CmdsOptions[ForbidWord]){
    format(string, sizeof(string), LanguageText[0], CmdsOptions[ForbidWord]);
	SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=CmdsOptions[ForbidWord]) if(ServerInfo[ForbidWord]==1){
    new tmp[MAX_SERVER_STRING],File:F,Index; tmp = strtok(params,Index);
	if(!strlen(tmp)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[327]);
	  return 1;}
	format(string,sizeof(string),"%s\r\n",params);
	F = fopen(ForbiddenWordsFile,io_append);
	fwrite(F,string);fclose(F);
	format(string,sizeof(string),"%s",params);
    GetPlayerName(playerid, adminname, sizeof(adminname));
   	format(string, sizeof(string), LanguageText[328], adminname, string); SendClientMessage(player, COLOR_LIGHTRED, string);print(string);}
  return 1;}
  
//*************************[ Multiple ADMIN COMMANDS ]************************//

dcmd_aheal(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=1) if(ServerInfo[Heal]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(string, sizeof(string), LanguageText[329], adminname);
	SendClientMessageToAll(COLOR_WHITE, string);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i)){
       SetPlayerHealth(i,Options[MaxHealth]);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_aarmour(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=1) if(ServerInfo[Armour]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(string, sizeof(string), LanguageText[330], adminname);
	SendClientMessageToAll(COLOR_WHITE, string);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i)){
       SetPlayerArmour(i,Options[MaxArmour]);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_adisarm(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=DISARM_ALL_LEVEL) if(ServerInfo[Disarm]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(str, sizeof(str), LanguageText[331], adminname, incriminato);
	SendClientMessageToAll(COLOR_YELLOW, str);
	SendClientMessage(playerid, COLOR_WHITE, LanguageText[436]);
	for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0){
        GameTextForPlayer(i,LanguageText[332],2000,3);
        Account[i][pMuteWarnings]=1;}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_amute(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=MUTE_ALL_LEVEL) if(ServerInfo[Mute]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(str, sizeof(str), LanguageText[333], adminname, incriminato);
	SendClientMessageToAll(COLOR_LIGHTRED, str);
	for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(i!=playerid && Account[i][pAdminlevel]==0){
        GameTextForPlayer(i,LanguageText[334],5000,3);
        Account[i][pMuted]=true;
        Account[i][pMuteWarnings]=1;}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_aunmute(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=UNMUTE_ALL_LEVEL) if(ServerInfo[Mute]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(str, sizeof(str), LanguageText[335], adminname, incriminato);
	SendClientMessageToAll(COLOR_GREEN, str);
	for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(i!=playerid && Account[i][pAdminlevel]==0){
        GameTextForPlayer(i,LanguageText[336],5000,3);
        Account[i][pMuted]=false;
        Account[i][pMuteWarnings]=0;
		KillTimer(MuteTimer[i]);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_ajail(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=JAIL_ALL_LEVEL) if(ServerInfo[Jail]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(str, sizeof(str), LanguageText[337], adminname, incriminato);
	SendClientMessageToAll(COLOR_YELLOW, str);
	for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0){
        GameTextForPlayer(i,LanguageText[338],5000,3);
        SetPlayerHealth(i,1);SetPlayerInterior(i,6);
        ResetPlayerWeapons(i);
        Account[i][pJailed]=true;
        SetPlayerPos(i,264.0535,77.2942,1001.0391);SetPlayerFacingAngle(i,270.0);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_aunjail(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=UNJAIL_ALL_LEVEL) if(ServerInfo[UnJail]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(str, sizeof(str), LanguageText[339], adminname);
	SendClientMessageToAll(COLOR_YELLOW, str);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0)if(Account[i][pJailed]==true){
        GameTextForPlayer(i,LanguageText[340],5000,3);
        SetPlayerHealth(i,Options[MaxHealth]);SetPlayerInterior(i,0);
        ResetPlayerWeapons(i);
        KillTimer(JailTimer[i]);
        Account[i][pJailed]=false;
        OnPlayerSpawn(i);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_akick(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=KICK_ALL_LEVEL) if(ServerInfo[kick]==1){
       GetPlayerName(playerid, adminname, sizeof(adminname));
   	   format(str, sizeof(str), LanguageText[341], adminname, params[2]);
       SendClientMessageToAll(COLOR_YELLOW, str);
       new File:reported = fopen(KickedPlayersFile,io_append);
	   fwrite(reported, str);
	   fclose(reported);
	   printf("[ADMIN]: %s kicked all players",adminname, params[2]);
	   for(new i=0;i<MAX_SERVER_PLAYERS;i++){
          if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0){
		      GameTextForPlayer(i,LanguageText[342],20000,3);
			  Kick(i);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_aban(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=BAN_ALL_LEVEL) if(ServerInfo[ban]==1){
       GetPlayerName(playerid, adminname, sizeof(adminname));
   	   format(str, sizeof(str), LanguageText[343], adminname, params[2]);
       SendClientMessageToAll(COLOR_LIGHTRED, str);
       new File:reported = fopen(BannedPlayersFile,io_append);
	   fwrite(reported, str);
	   fclose(reported);
	   printf("[ADMIN]: %s banned all players",adminname, params[2]);
	   for(new i=0;i<MAX_SERVER_PLAYERS;i++){
          if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0){
		      GameTextForPlayer(i,LanguageText[344],20000,3);
			  Ban(i);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_afreeze(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=FREEZE_ALL_LEVEL) if(ServerInfo[Freeze]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
   	format(str, sizeof(str), LanguageText[345],adminname, params[2]);
	SendClientMessageToAll(COLOR_LIGHTRED, str);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0){
	    TogglePlayerControllable(i,0);Account[i][pFreezed]=true;
	    GameTextForPlayer(i,LanguageText[346],5000,3);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_aunfreeze(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=UNFREEZE_ALL_LEVEL) if(ServerInfo[UnFreeze]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
   	format(str, sizeof(str), LanguageText[347],adminname, params[2]);
	SendClientMessageToAll(COLOR_LIGHTRED, str);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      if(IsPlayerConnected(i)){
	    TogglePlayerControllable(i,1);Account[i][pFreezed]=false;
	    GameTextForPlayer(i,LanguageText[348],5000,3);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_aslap(playerid,params[]){
  #pragma unused params
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]>=SLAP_ALL_LEVEL) if(ServerInfo[Slap]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(str, sizeof(str), LanguageText[349],adminname, params[2]);
	SendClientMessageToAll(COLOR_LIGHTRED, str);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0){
	  GetPlayerPos(i, Float:X,Float:Y,Float:Z);
	  GameTextForPlayer(i, LanguageText[350],3000,4);
	  SetPlayerPos(i,X,Y,Z+50);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_aexplode(playerid,params[]){
  #pragma unused params
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]>=EXPLODE_ALL_LEVEL) if(ServerInfo[Explode]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
   	format(string, sizeof(string), LanguageText[351], adminname);
    SendClientMessageToAll(COLOR_LIGHTRED, string);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0){
	  GetPlayerPos(i, X,Y,Z);
	  GameTextForPlayer(i, LanguageText[352],3000,4);
	  CreateExplosion(X,Y,Z,7,12000);CreateExplosion(X,Y,Z,7,12000);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_aget(playerid,params[]){
  #pragma unused params
  new Float:X,Float:Y,Float:Z;
  if(Account[playerid][pAdminlevel]>=GET_ALL_LEVEL) if(ServerInfo[Get]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
   	format(string, sizeof(string), LanguageText[353], adminname);
    SendClientMessageToAll(COLOR_LIGHTRED, string);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      if(IsPlayerConnected(i) && i!=playerid && GetPlayerVirtualWorld(i)==GetPlayerVirtualWorld(playerid)){
	  GetPlayerPos(playerid, X,Y,Z);
	  GameTextForPlayer(i, LanguageText[354],3000,4);
	  SetPlayerPos(i,X+3,Y+2,Z);
	  SetPlayerInterior(i,GetPlayerInterior(playerid));}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_areset(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=RESET_ALL_LEVEL) if(ServerInfo[Reset]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
   	format(string, sizeof(string), LanguageText[355], adminname);
	SendClientMessageToAll(COLOR_LIGHTRED, string);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0){
	  GameTextForPlayer(i, LanguageText[356],3000,4);
	  ResetPlayerWeapons(i);SetPlayerHealth(i,1);SetPlayerArmour(i,0);ResetPlayerMoney(i);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_asetskin(playerid,params[]){
  if(Account[playerid][pAdminlevel]>=SETSKIN_ALL_LEVEL) if(ServerInfo[Setskin]==1){
    new tmp2[MAX_SERVER_STRING],livello, Index; tmp2 = strtok(params,Index);
	if(!strlen(params)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[357]);
	  return 1;}
	livello = strval(tmp2);
	GetPlayerName(playerid, adminname, sizeof(adminname));
   	format(string, sizeof(string), LanguageText[358], adminname, incriminato, livello);
	SendClientMessageToAll(COLOR_LIGHTRED, string);
	for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      if(IsPlayerConnected(i) && i!=playerid){
        SetPlayerSkin(i,livello);
		Account[i][pSkin]=livello;}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_adie(playerid,params[]){
  #pragma unused params
  if(Account[playerid][pAdminlevel]>=DIE_ALL_LEVEL) if(ServerInfo[Die]==1){
    GetPlayerName(playerid, adminname, sizeof(adminname));
   	format(string, sizeof(string), LanguageText[359], adminname);
	SendClientMessageToAll(COLOR_LIGHTRED, string);
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      if(IsPlayerConnected(i) && i!=playerid && Account[i][pAdminlevel]==0){
	  GameTextForPlayer(i, LanguageText[360],3000,4);
	  SetPlayerHealth(i,0);SetPlayerArmour(i,0);}}}
  return 1;}
//----------------------------------------------------------------------------//
dcmd_aweapon(playerid,params[]){
  if(Account[playerid][pAdminlevel]<WEAPON_ALL_LEVEL){
    format(string, sizeof(string), LanguageText[0], WEAPON_ALL_LEVEL);SendClientMessage(playerid, COLOR_LIGHTRED, string);}else
  if(Account[playerid][pAdminlevel]>=WEAPON_ALL_LEVEL){
    new tmp2[MAX_SERVER_STRING],tmp3[MAX_SERVER_STRING],arma,ammo, Index; tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
	if(!strlen(tmp2)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[361]);
	  return 1;}
    if(!strlen(tmp3)){
      SendClientMessage(playerid, COLOR_WHITE, LanguageText[361]);
	  return 1;}
	GetPlayerName(playerid, adminname, sizeof(adminname));
	ammo = strval(tmp3);
	if(!IsNumeric(tmp2)) arma=GetWeaponModelIDFromName(tmp2); else
      arma = strval(tmp2);
    switch(arma){
	  case MINIGUN:{
        if(Options[AntiMinigun]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
      case RPG:{
        if(Options[AntiRPG]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
      case ROCKET_LAUNCHER:{
        if(Options[AntiBazooka]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case FLAME_THROWER:{
        if(Options[AntiFlameThrower]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case MOLOTOVS:{
        if(Options[AntiMolotovs]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case GRENADES:{
        if(Options[AntiGrenades]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case SACHET_CHARGERS:{
        if(Options[AntiSachetChargers]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case DETONATOR:{
        if(Options[AntiDetonator]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case TEAR_GAS:{
        if(Options[AntiTearGas]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case SHOTGUN:{
        if(Options[AntiShotgun]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case SAWNOFF_SHOTGUN:{
        if(Options[AntiSawnoffShotgun]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case COMBAT_SHOTGUN:{
        if(Options[AntiCombatShotgun]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case RIFLE:{
        if(Options[AntiRifle]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case SNIPER_RIFLE:{
        if(Options[AntiRifleSniper]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
      case SPRAY_PAINT:{
        if(Options[AntiSprayPaint]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}
	  case FIRE_EXTINGUER:{
        if(Options[AntiFireExtinguer]==1){
		  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[313]);
	      return 1;}}}
    if(arma<0 || arma>46){
	  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[79]);
	  return 1;}
    format(str, sizeof(str), LanguageText[362], adminname, WeaponNames[arma+1], ammo);
	SendClientMessageToAll(COLOR_YELLOW, str);
	for(new i=0;i<MAX_SERVER_PLAYERS;i++) if(IsPlayerConnected(i)){
	  GivePlayerWeapon(i,arma+1,ammo);}}
  return 1;}
  
//****************************************************************************//

public OnRconLoginAttempt(ip[], password[], success){
  new Pl,tmp3[50];
  if(Options[RconSecurity]==2){
	  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	    if(IsPlayerConnected(i)){
	      GetPlayerIp(i,tmp3,sizeof(tmp3));
	      if((!strcmp(tmp3,ip,true))){
	        Pl=i;}}}
	  SendClientMessage(Pl,COLOR_LIGHTRED,LanguageText[419]);
	  IsRealRconAdmin[Pl]=false;}

  if(!success){
    for(new i=0;i<MAX_SERVER_PLAYERS;i++)if(IsPlayerConnected(i)){
	  GetPlayerIp(i,tmp3,sizeof(tmp3));
	  if((!strcmp(tmp3,ip,true))){
	    Pl=i;}}
    SendClientMessage(Pl,COLOR_LIGHTRED,"Rcon Fail");
    printf(LanguageText[363],ip, password);}
  if(success){

    if(Options[RconSecurity]==0){
      for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	    if(IsPlayerConnected(i)){
	      GetPlayerIp(i,tmp3,sizeof(tmp3));
	      if((!strcmp(tmp3,ip,true))){
	        Pl=i;}}}
      IsRealRconAdmin[Pl]=true;
	  GetPlayerName(Pl,name,sizeof(name));
	  SendClientMessage(Pl,COLOR_LIGHTGREEN,LanguageText[377]);
	  format(string,sizeof(string),LanguageText[435],name);print(string);
	  return 1;}
	  
	if(Options[RconSecurity]==1){
      for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	    if(IsPlayerConnected(i)){
	      GetPlayerIp(i,tmp3,sizeof(tmp3));
	      if((!strcmp(tmp3,ip,true))){
	        Pl=i;}}}
      SendClientMessage(Pl,COLOR_GREEN,LanguageText[364]);
      ShowPlayerDialog(Pl,RconSafeCode,DIALOG_STYLE_INPUT,LanguageText[374],LanguageText[375],LanguageText[99],"KickMe");}}
  return 1;}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
  if(dialogid == RegistrationDialog){
    if(response==1){
	  Account[playerid][pScore]=GetPlayerScore(playerid);
      Account[playerid][pCash]=GetPlayerMoney(playerid);
      Account[playerid][pLoggedin]=1;
	  PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	  OnPlayerRegister(playerid, inputtext);
      printf("<<<< %s registered [password %s] >>>>", pname, inputtext);}
	if(response==0){
	  if(Options[MustRegister]==1){
        ShowPlayerDialog(playerid,RegistrationDialog,DIALOG_STYLE_INPUT,LanguageText[100],LanguageText[104],LanguageText[102],"NO");}}
	return 1;}
	
  if(dialogid == LoginDialog){
    if(response==1){
	  GetPlayerName(playerid,name,sizeof(name));
	  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,name);
	  new tmp[MAX_SERVER_STRING]; tmp = dini_Get(file, "hashPW");
      if(udb_hash(inputtext) != strval(tmp)){
        if(Account[playerid][pLoginAttempts]==5){
          Account[playerid][pLoginAttempts]=0;
		  ShowPlayerDialog(playerid,LoginDialog,DIALOG_STYLE_INPUT,LanguageText[367],LanguageText[368],"OK","");
		  Kick(playerid);}
		if(Account[playerid][pLoginAttempts]<5){
          Account[playerid][pLoginAttempts]++;
		  ShowPlayerDialog(playerid,LoginDialog,DIALOG_STYLE_INPUT,LanguageText[99],LanguageText[369],LanguageText[103],"NO");}}else{
      OnPlayerLogin(playerid);
      GetPlayerName(playerid,name,sizeof(name));
      if(Account[playerid][pAdminlevel]==0){
		    format(str, sizeof(str), LanguageText[7],name, dini_Int(file,"score"), Account[playerid][pCash]);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}
      if(Account[playerid][pAdminlevel]>=1){
		    format(str, sizeof(str), LanguageText[8],name, Account[playerid][pAdminlevel], dini_Int(file,"score"), Account[playerid][pCash]);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, str);}
      printf("LOGIN: %s (%i) logged in with password %s", name, playerid, inputtext);}}
	if(response==0){
	  }
	return 1;}
	
  if(dialogid == LogoutDialog){
    if(response==1){
	  GetPlayerName(playerid,name,sizeof(name));
	  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,name);
	  new tmp[MAX_SERVER_STRING]; tmp = dini_Get(file, "hashPW");
      if(udb_hash(inputtext) != strval(tmp)){
		ShowPlayerDialog(playerid,LogoutDialog,DIALOG_STYLE_INPUT,LanguageText[113],LanguageText[418],LanguageText[114],"NO");}else{
          OnPlayerLogout(playerid);
          SendClientMessage(playerid, COLOR_YELLOW, LanguageText[115]);
          printf("LOGOUT: %s Unlogged [password %s]", name, inputtext);}}
	if(response==0){
	  }
	return 1;}
	
  if(dialogid == ChangePass1Dialog){
    if(response==1){
	  GetPlayerName(playerid,name,sizeof(name));
	  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,name);
	  new tmp[MAX_SERVER_STRING]; tmp = dini_Get(file, "hashPW");
      if(udb_hash(inputtext) != strval(tmp)){
		ShowPlayerDialog(playerid,ChangePass1Dialog,DIALOG_STYLE_INPUT,LanguageText[118],LanguageText[371],LanguageText[119],"NO");}else{
          ShowPlayerDialog(playerid,ChangePass2Dialog,DIALOG_STYLE_INPUT,LanguageText[118],LanguageText[417],LanguageText[372],"NO");}}
	if(response==0){
	  }
	return 1;}
	
  if(dialogid == ChangePass2Dialog){
    if(response==1){
	  GetPlayerName(playerid,name,sizeof(name));
	  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,name);
      PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
	  dini_IntSet(file, "hashPW", udb_hash(inputtext));
      dini_Set(file, "password", inputtext);
	  format(str, sizeof(str), LanguageText[121], name, inputtext),SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
	  SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
      printf("CHANGEPASS: %s changed password to '%s'", name, inputtext);}
	if(response==0){
	  }
	return 1;}

  if(dialogid == RconSafeCode){
	if(response==1){
	  if(udb_hash(inputtext)!=udb_hash(SecondRconPass)){
        if(RconLoginAttempts[playerid]<MaxRconLoginAttempts){
          RconLoginAttempts[playerid]++;
          format(string,sizeof(string),LanguageText[373],RconLoginAttempts[playerid],MaxRconLoginAttempts);
	      SendClientMessage(playerid,COLOR_YELLOW,string);
		  ShowPlayerDialog(playerid,RconSafeCode,DIALOG_STYLE_INPUT,LanguageText[374],LanguageText[416],LanguageText[99],"KickMe");}
	    if(RconLoginAttempts[playerid]==MaxRconLoginAttempts){
	      GetPlayerName(playerid,name,sizeof(name));
	      format(string,sizeof(string),LanguageText[376],RconLoginAttempts[playerid],MaxRconLoginAttempts);
          SendClientMessage(playerid,COLOR_YELLOW,string);print(string);
	      Kick(playerid);
	      RconLoginAttempts[playerid]=0;
          format(string,sizeof(string),LanguageText[379],name);
          SendClientMessageToAll(COLOR_YELLOW,string);}}
	  if(udb_hash(inputtext)==udb_hash(SecondRconPass)){
	    IsRealRconAdmin[playerid]=true;
	    GetPlayerName(playerid,name,sizeof(name));
		SendClientMessage(playerid,COLOR_LIGHTGREEN,LanguageText[377]);
		format(string,sizeof(string),"RCON: %s has completely logged in as RCON Admin.",name);print(string);}}
	if(response==0){
      GetPlayerName(playerid,name,sizeof(name));
      SendClientMessage(playerid,COLOR_YELLOW,LanguageText[378]);
      format(string,sizeof(string),LanguageText[379],name);
      SendClientMessageToAll(COLOR_YELLOW,string);print(string);
	  Kick(playerid);
	  RconLoginAttempts[playerid]=0;}
	return 1;}

  if(dialogid == EnableCommandsDialog1){
	if(response==1)if(Account[playerid][pAdminlevel]>=CmdsOptions[EnableCommands] || IsRealRconAdmin[playerid]==true){
   	  if(listitem == 0)ShowPlayerDialog(playerid, CmdPmDialog, DIALOG_STYLE_LIST, "Command /pm:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 1)ShowPlayerDialog(playerid, CmdKickDialog, DIALOG_STYLE_LIST, "Command /Kick:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 2)ShowPlayerDialog(playerid, CmdBanDialog, DIALOG_STYLE_LIST, "Command /Ban:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 3)ShowPlayerDialog(playerid, CmdFixDialog, DIALOG_STYLE_LIST, "Command /Fix:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 4)ShowPlayerDialog(playerid, CmdFlipDialog, DIALOG_STYLE_LIST, "Command /Flip:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 5)ShowPlayerDialog(playerid, CmdSpecDialog, DIALOG_STYLE_LIST, "Command /Spec:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 6)ShowPlayerDialog(playerid, CmdSpecoffDialog, DIALOG_STYLE_LIST, "Command /Specoff:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 7)ShowPlayerDialog(playerid, CmdJailDialog, DIALOG_STYLE_LIST, "Command /Jail:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 8)ShowPlayerDialog(playerid, CmdUnjailDialog, DIALOG_STYLE_LIST, "Command /Unjail:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 9)ShowPlayerDialog(playerid, CmdFreezeDialog, DIALOG_STYLE_LIST, "Command /Freeze:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 10)ShowPlayerDialog(playerid, CmdUnfreezeDialog, DIALOG_STYLE_LIST, "Command /Unfreeze:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 11)ShowPlayerDialog(playerid, CmdHealDialog, DIALOG_STYLE_LIST, "Command /Heal:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 12)ShowPlayerDialog(playerid, CmdArmourDialog, DIALOG_STYLE_LIST, "Command /Armour:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 13)ShowPlayerDialog(playerid, CmdGetipDialog, DIALOG_STYLE_LIST, "Command /Getip:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 14)ShowPlayerDialog(playerid, CmdMuteDialog, DIALOG_STYLE_LIST, "Command /Mute:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 15)ShowPlayerDialog(playerid, CmdUnmuteDialog, DIALOG_STYLE_LIST, "Command /Unmute:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 16)ShowPlayerDialog(playerid, CmdResetDialog, DIALOG_STYLE_LIST, "Command /Reset:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 17)ShowPlayerDialog(playerid, CmdSetskinDialog, DIALOG_STYLE_LIST, "Command /Setskin:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 18)ShowPlayerDialog(playerid, CmdSetskinToMeDialog, DIALOG_STYLE_LIST, "Command /Setskintome:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 19)ShowPlayerDialog(playerid, CmdSetscoreDialog, DIALOG_STYLE_LIST, "Command /Setscore:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 20)ShowPlayerDialog(playerid, CmdSlapDialog, DIALOG_STYLE_LIST, "Command /Slap:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 21)ShowPlayerDialog(playerid, CmdDieDialog, DIALOG_STYLE_LIST, "Command /Die:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 22)ShowPlayerDialog(playerid, CmdGivemoneyDialog, DIALOG_STYLE_LIST, "Command /Givemoney:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 23)ShowPlayerDialog(playerid, CmdExplodeDialog, DIALOG_STYLE_LIST, "Command /Explode:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 24)ShowPlayerDialog(playerid, CmdGetDialog, DIALOG_STYLE_LIST, "Command /Get:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 25)ShowPlayerDialog(playerid, CmdGotoDialog, DIALOG_STYLE_LIST, "Command /Goto:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 26)ShowPlayerDialog(playerid, CmdVgetDialog, DIALOG_STYLE_LIST, "Command /Vget:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 27)ShowPlayerDialog(playerid, CmdVgotoDialog, DIALOG_STYLE_LIST, "Command /Vgoto:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 28)ShowPlayerDialog(playerid, CmdTeleplayerDialog, DIALOG_STYLE_LIST, "Command /Teleplayer:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 29)ShowSecondCommandsDialog(playerid);}
	return 1;}

  if(dialogid == EnableCommandsDialog2){
	if(response==1)if(Account[playerid][pAdminlevel]>=CmdsOptions[EnableCommands] || IsRealRconAdmin[playerid]==true){
	  if(listitem == 0)ShowPlayerDialog(playerid, CmdGivecarDialog, DIALOG_STYLE_LIST, "Command /Givecar:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 1)ShowPlayerDialog(playerid, CmdSettimeDialog, DIALOG_STYLE_LIST, "Command /Settime:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 2)ShowPlayerDialog(playerid, CmdSetweatherDialog, DIALOG_STYLE_LIST, "Command /Setweather:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 3)ShowPlayerDialog(playerid, CmdGmxDialog, DIALOG_STYLE_LIST, "Command /Gmx:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 4)ShowPlayerDialog(playerid, CmdCchatDialog, DIALOG_STYLE_LIST, "Command /Cchat:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 5)ShowPlayerDialog(playerid, CmdCcarsDialog, DIALOG_STYLE_LIST, "Command /Ccars:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 6)ShowPlayerDialog(playerid, CmdTempadminDialog, DIALOG_STYLE_LIST, "Command /Tempadmin:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 7)ShowPlayerDialog(playerid, CmdMakeadminDialog, DIALOG_STYLE_LIST, "Command /Makeadmin:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 8)ShowPlayerDialog(playerid, CmdMakemegodadminDialog, DIALOG_STYLE_LIST, "Command /Makemegodadmin:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 9)ShowPlayerDialog(playerid, CmdSetplayerinteriorDialog, DIALOG_STYLE_LIST, "Command /Setplayerinterior:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 10)ShowPlayerDialog(playerid, CmdSetplayertimeDialog, DIALOG_STYLE_LIST, "Command /Setplayertime:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 11)ShowPlayerDialog(playerid, CmdPlayerData2Dialog, DIALOG_STYLE_LIST, "Command /Playerdata:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 12)ShowPlayerDialog(playerid, CmdSetplayerweatherDialog, DIALOG_STYLE_LIST, "Command /Setplayerweather:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 13)ShowPlayerDialog(playerid, CmdWeaponDialog, DIALOG_STYLE_LIST, "Command /Weapon:","ENABLE\nDISABLE", "OK", "ESC");
      if(listitem == 14)ShowPlayerDialog(playerid, CmdCountDialog, DIALOG_STYLE_LIST, "Command /Count:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 15)ShowPlayerDialog(playerid, CmdAsayDialog, DIALOG_STYLE_LIST, "Command /Asay:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 16)ShowPlayerDialog(playerid, CmdAnnounceDialog, DIALOG_STYLE_LIST, "Command /Announce:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 17)ShowPlayerDialog(playerid, CmdLockDialog, DIALOG_STYLE_LIST, "Command /Lock:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 18)ShowPlayerDialog(playerid, CmdUnlockDialog, DIALOG_STYLE_LIST, "Command /Unlock:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 19)ShowPlayerDialog(playerid, CmdCarcolorDialog, DIALOG_STYLE_LIST, "Command /Carcolor:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 20)ShowPlayerDialog(playerid, CmdSetnameDialog, DIALOG_STYLE_LIST, "Command /Setname:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 21)ShowPlayerDialog(playerid, CmdCrashDialog, DIALOG_STYLE_LIST, "Command /Crash:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 22)ShowPlayerDialog(playerid, CmdBurnDialog, DIALOG_STYLE_LIST, "Command /Burn:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 23)ShowPlayerDialog(playerid, CmdDisarmDialog, DIALOG_STYLE_LIST, "Command /Disarm:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 24)ShowPlayerDialog(playerid, CmdRemoveWeaponDialog, DIALOG_STYLE_LIST, "Command /Removeweapon:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 25)ShowPlayerDialog(playerid, CmdVehDialog, DIALOG_STYLE_LIST, "Command /Veh:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 26)ShowPlayerDialog(playerid, CmdGetVHealthDialog, DIALOG_STYLE_LIST, "Command /Getvhealth:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 27)ShowThirdCommandsDialog(playerid);}
    return 1;}
    
  if(dialogid == EnableCommandsDialog3){
	if(response==1)if(Account[playerid][pAdminlevel]>=CmdsOptions[EnableCommands] || IsRealRconAdmin[playerid]==true){
      if(listitem == 0)ShowPlayerDialog(playerid, CmdSetVHealthDialog, DIALOG_STYLE_LIST, "Command /Setvhealth:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 1)ShowPlayerDialog(playerid, CmdJetpackDialog, DIALOG_STYLE_LIST, "Command /Jetp (jetpack):","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 2)ShowPlayerDialog(playerid, CmdSaveskinDialog, DIALOG_STYLE_LIST, "Command /SaveSkin and /Myskin:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 3)ShowPlayerDialog(playerid, CmdMakeVipDialog, DIALOG_STYLE_LIST, "Command /Makevip:","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 4)ShowPlayerDialog(playerid, CmdRemoveVipDialog, DIALOG_STYLE_LIST, "Command /RemoveVip","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem == 5)ShowPlayerDialog(playerid, CmdSavePCarDialog, DIALOG_STYLE_LIST, "Command /savepersonalcar & /replacepersonalcar","ENABLE\nDISABLE", "OK", "ESC");}
    return 1;}
    
  if(dialogid==AnticheatItemsDialog){
    if(response==1)if(Account[playerid][pAdminlevel]>=CmdsOptions[Anticheat] || IsRealRconAdmin[playerid]==true){
      if(listitem==0)ShowPlayerDialog(playerid, MaxMoneyDialog, DIALOG_STYLE_LIST, "Max Money","1000\n10000\n100000\n1000000\n10000000\n999999999\nDisable Anti Money Hack", "OK", "ESC");
	  if(listitem==1)ShowPlayerDialog(playerid, MaxHealthDialog, DIALOG_STYLE_LIST, "Max Health","50\n100", "OK", "ESC");
	  if(listitem==2)ShowPlayerDialog(playerid, MaxArmourDialog, DIALOG_STYLE_LIST, "Max Armour","0\n50\n100", "OK", "ESC");
	  if(listitem==3)ShowPlayerDialog(playerid, AntiJetpackDialog, DIALOG_STYLE_LIST, "Anti Jetpack Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==4)ShowPlayerDialog(playerid, AntiMinigunDialog, DIALOG_STYLE_LIST, "Anti Minigun Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==5)ShowPlayerDialog(playerid, AntiRpgDialog, DIALOG_STYLE_LIST, "Anti RPG Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==6)ShowPlayerDialog(playerid, AntiBazookaDialog, DIALOG_STYLE_LIST, "Anti Bazooka Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==7)ShowPlayerDialog(playerid, AntiFlameThrowerDialog, DIALOG_STYLE_LIST, "Anti Flame Thrower Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==8)ShowPlayerDialog(playerid, AntiMolotovsDialog, DIALOG_STYLE_LIST, "Anti Molotovs Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==9)ShowPlayerDialog(playerid, AntiGrenadesDialog, DIALOG_STYLE_LIST, "Anti Grenades Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==10)ShowPlayerDialog(playerid, AntiSachetChargersDialog, DIALOG_STYLE_LIST, "Anti Sachet Chargers Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==11)ShowPlayerDialog(playerid, AntiDetonatorDialog, DIALOG_STYLE_LIST, "Anti Detonator Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==12)ShowPlayerDialog(playerid, AntiTearGasDialog, DIALOG_STYLE_LIST, "Anti Tear Gas Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==13)ShowPlayerDialog(playerid, AntiShotgunDialog, DIALOG_STYLE_LIST, "Anti Shotgun Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==14)ShowPlayerDialog(playerid, AntiSawnoffShotgunDialog, DIALOG_STYLE_LIST, "Anti Sawnoff Shotgun Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==15)ShowPlayerDialog(playerid, AntiCombatShotgunDialog, DIALOG_STYLE_LIST, "Anti Combat Shotgun Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==16)ShowPlayerDialog(playerid, AntiRifleDialog, DIALOG_STYLE_LIST, "Anti Rifle Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==17)ShowPlayerDialog(playerid, AntiRifleSniperDialog, DIALOG_STYLE_LIST, "Anti Rifle Sniper Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==18)ShowPlayerDialog(playerid, AntiSprayPaintDialog, DIALOG_STYLE_LIST, "Anti Spray Paint Hack","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==19)ShowPlayerDialog(playerid, AntiFireExtinguerDialog, DIALOG_STYLE_LIST, "Anti Fire Extinguer Hack","ENABLE\nDISABLE", "OK", "ESC");}
	return 1;}

  if(dialogid==ServerOptionsDialog){
    if(response==1)if(Account[playerid][pAdminlevel]>=CmdsOptions[SetOptions] || IsRealRconAdmin[playerid]==true){
	  if(listitem==0)ShowPlayerDialog(playerid, ReadCmdsDialog, DIALOG_STYLE_LIST, "Read Cmds","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==1)ShowPlayerDialog(playerid, AutoLoginDialog, DIALOG_STYLE_LIST, "Auto Login","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==2)ShowPlayerDialog(playerid, ConnectMessagesDialog, DIALOG_STYLE_LIST, "Connect Messaged","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==3)ShowPlayerDialog(playerid, AutomaticAdminColorDialog, DIALOG_STYLE_LIST, "Automatic Admin Color","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==4)ShowPlayerDialog(playerid, AntiFloodDialog, DIALOG_STYLE_LIST, "Anti Flood","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==5)ShowPlayerDialog(playerid, AntiSpamDialog, DIALOG_STYLE_LIST, "Anti Spam","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==6)ShowPlayerDialog(playerid, AntiSwearDialog, DIALOG_STYLE_LIST, "Anti Swear","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==7)ShowPlayerDialog(playerid, AntiForbiddenPartOfNameDialog, DIALOG_STYLE_LIST, "Anti Forbidden Part of name","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==8)ShowPlayerDialog(playerid, LanguageDialog, DIALOG_STYLE_LIST, "Language","Italiano\nEnglish\nEspaniol (not existing)\nDeutsch (not existing)", "OK", "ESC");
	  if(listitem==9)ShowPlayerDialog(playerid, MaxPingDialog, DIALOG_STYLE_LIST, "Max Ping","300\n600\n900\n1200\n633565", "OK", "ESC");
	  if(listitem==10)ShowPlayerDialog(playerid, MaxPingWarningsDialog, DIALOG_STYLE_LIST, "Max Ping Warnings","3\n5\n10", "OK", "ESC");
	  if(listitem==11)ShowPlayerDialog(playerid, MaxMuteWarningsDialog, DIALOG_STYLE_LIST, "Max Mute Warnings","3\n5\n10", "OK", "ESC");
	  if(listitem==12)ShowPlayerDialog(playerid, MaxSpamWarningsDialog, DIALOG_STYLE_LIST, "Max Spam Warnings","0 (=direct KICK)\n3\n5\n10", "OK", "ESC");
	  if(listitem==13)ShowPlayerDialog(playerid, MaxFloodTimesDialog, DIALOG_STYLE_LIST, "Mas Flood Times","3\n5\n10\n20", "OK", "ESC");
	  if(listitem==14)ShowPlayerDialog(playerid, MaxFloodSecondsDialog, DIALOG_STYLE_LIST, "Max Flood Seconds","1\n2\n3\n4\n5", "OK", "ESC");
	  if(listitem==15)ShowPlayerDialog(playerid, MaxCFloodSecondsDialog, DIALOG_STYLE_LIST, "Max CommandFlood Seconds","1\n2\n3\n4\n5", "OK", "ESC");
	  if(listitem==16)ShowPlayerDialog(playerid, AllowCmdsOnAdminsDialog, DIALOG_STYLE_LIST, "Allow Commands On Admins","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==17)ShowPlayerDialog(playerid, RegisterInDialogDialog, DIALOG_STYLE_LIST, "Registration","BY COMMAND\nBY DIALOG", "OK", "ESC");
	  if(listitem==18)ShowPlayerDialog(playerid, MustRegisterDialog, DIALOG_STYLE_LIST, "Must Register","YES\nNO", "OK", "ESC");
	  if(listitem==19)ShowPlayerDialog(playerid, MustLoginDialog, DIALOG_STYLE_LIST, "Must Login","YES\nNO", "OK", "ESC");
	  if(listitem==20)ShowOptionsConfigDialog2(playerid);}
	return 1;}
	
  if(dialogid==ServerOptionsDialog2)if(Account[playerid][pAdminlevel]>=1){
    if(response==1)if(Account[playerid][pAdminlevel]>=CmdsOptions[SetOptions] || IsRealRconAdmin[playerid]==true){
      if(listitem==0)ShowPlayerDialog(playerid, MaxWarningsDialog, DIALOG_STYLE_LIST, "Max Warnings","3\n5\n10", "OK", "ESC");
	  if(listitem==1)ShowPlayerDialog(playerid, MaxBanWarningsDialog, DIALOG_STYLE_LIST, "Max Ban Warnings","5\n10\n15", "OK", "ESC");
	  if(listitem==2)ShowPlayerDialog(playerid, MaxVotesForKickDialog, DIALOG_STYLE_LIST, "Max Votes to Kick a Player","3\n5\n10", "OK", "ESC");
	  if(listitem==3)ShowPlayerDialog(playerid, MaxVotesForBanDialog, DIALOG_STYLE_LIST, "Max Votes to Ban a Player","5\n10\n15\n30", "OK", "ESC");
	  if(listitem==4)ShowPlayerDialog(playerid, MaxVotesForCcarsDialog, DIALOG_STYLE_LIST, "Max Votes to Clear Spawned Vehicles","3\n5\n10\n20", "OK", "ESC");
	  if(listitem==5)ShowPlayerDialog(playerid, AFKSystemDialog, DIALOG_STYLE_LIST, "AFK System","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==6)ShowPlayerDialog(playerid, AntiSpawnKillDialog, DIALOG_STYLE_LIST, "Anti Spawnkill","ENABLE\nDISABLE\n5 seconds\n10 seconds", "OK", "ESC");
	  if(listitem==7)ShowPlayerDialog(playerid, AntiBotsDialog, DIALOG_STYLE_LIST, "Anti Bots","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==8)ShowPlayerDialog(playerid, RconSecurityDialog, DIALOG_STYLE_LIST, "RCON SECURITY Mode","Disable (use normal RCON)\nSecond RCON\nRcon Changing every second", "OK", "ESC");
	  if(listitem==9)ShowPlayerDialog(playerid, AntiDriveByDialog, DIALOG_STYLE_LIST, "Anti Driveby","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==10)ShowPlayerDialog(playerid, AntiHeliKillDialog, DIALOG_STYLE_LIST, "Anti Helicopter blades kill","ENABLE\nDISABLE", "OK", "ESC");
	  if(listitem==11)ShowPlayerDialog(playerid, AntiCapsLockDialog, DIALOG_STYLE_LIST, "Anti Caps Lock","ENABLE\nDISABLE", "OK", "ESC");}
	return 1;}
	
  if(dialogid == CmdPmDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"pm",1),ServerInfo[Pm]=1,GameTextForAll("~r~/pm ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"pm",0),ServerInfo[Pm]=0,GameTextForAll("~r~/pm ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdKickDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"kick",1),ServerInfo[kick]=1,GameTextForAll("~r~/kick ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"kick",0),ServerInfo[kick]=0,GameTextForAll("~r~/kick ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdBanDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"ban",1),ServerInfo[ban]=1,GameTextForAll("~r~/ban ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"ban",0),ServerInfo[ban]=0,GameTextForAll("~r~/ban ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdFixDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"fix",1),ServerInfo[Fix]=1,GameTextForAll("~r~/fix ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"fix",0),ServerInfo[Fix]=0,GameTextForAll("~r~/fix ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdFlipDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"flip",1),ServerInfo[Flip]=1,GameTextForAll("~r~/flip ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"flip",0),ServerInfo[Flip]=0,GameTextForAll("~r~/flip ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSpecDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"spec",1),ServerInfo[Spec]=1,GameTextForAll("~r~/spec ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"spec",0),ServerInfo[Spec]=0,GameTextForAll("~r~/spec ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSpecoffDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"specoff",1),ServerInfo[SpecOff]=1,GameTextForAll("~r~/specoff ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"specoff",0),ServerInfo[SpecOff]=0,GameTextForAll("~r~/specoff ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdJailDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"jail",1),ServerInfo[Jail]=1,GameTextForAll("~r~/jail ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"jail",0),ServerInfo[Jail]=0,GameTextForAll("~r~/jail ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdUnjailDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"unjail",1),ServerInfo[UnJail]=1,GameTextForAll("~r~/unjail ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"unjail",0),ServerInfo[UnJail]=0,GameTextForAll("~r~/unjail ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdFreezeDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"freeze",1),ServerInfo[Freeze]=1,GameTextForAll("~r~/freeze ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"freeze",0),ServerInfo[Freeze]=0,GameTextForAll("~r~/freeze ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdUnfreezeDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"unfreeze",1),ServerInfo[UnFreeze]=1,GameTextForAll("~r~/unfreeze ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"unfreeze",0),ServerInfo[UnFreeze]=0,GameTextForAll("~r~/unfreeze ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdHealDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"heal",1),ServerInfo[Heal]=1,GameTextForAll("~r~/heal ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"heal",0),ServerInfo[Heal]=0,GameTextForAll("~r~/heal ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdArmourDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"armour",1),ServerInfo[Armour]=1,GameTextForAll("~r~/armour ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"armour",0),ServerInfo[Armour]=0,GameTextForAll("~r~/armour ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdGetipDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"getip",1),ServerInfo[GetIp]=1,GameTextForAll("~r~/getip ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"getip",0),ServerInfo[GetIp]=0,GameTextForAll("~r~/getip ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdMuteDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"mute",1),ServerInfo[Mute]=1,GameTextForAll("~r~/mute ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"mute",0),ServerInfo[Mute]=0,GameTextForAll("~r~/mute ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdUnmuteDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"unmute",1),ServerInfo[UnMute]=1,GameTextForAll("~r~/unmute ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"unmute",0),ServerInfo[UnMute]=0,GameTextForAll("~r~/unmute ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdResetDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"reset",1),ServerInfo[Reset]=1,GameTextForAll("~r~/reset ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"reset",0),ServerInfo[Reset]=0,GameTextForAll("~r~/reset ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSetskinDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"setskin",1),ServerInfo[Setskin]=1,GameTextForAll("~r~/setskin ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"setskin",0),ServerInfo[Setskin]=0,GameTextForAll("~r~/setskin ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSetskinToMeDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"setskintome",1),ServerInfo[SetskinToMe]=1,GameTextForAll("~r~/setskintome ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"setskintome",0),ServerInfo[SetskinToMe]=0,GameTextForAll("~r~/setskintome ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSetscoreDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"setscore",1),ServerInfo[Setscore]=1,GameTextForAll("~r~/setscore ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"setscore",0),ServerInfo[Setscore]=0,GameTextForAll("~r~/setscore ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSlapDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"slap",1),ServerInfo[Slap]=1,GameTextForAll("~r~/slap ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"slap",0),ServerInfo[Slap]=0,GameTextForAll("~r~/slap ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdDieDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"die",1),ServerInfo[Die]=1,GameTextForAll("~r~/die ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"die",0),ServerInfo[Die]=0,GameTextForAll("~r~/die ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdGivemoneyDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"givemoney",1),ServerInfo[GiveMoney]=1,GameTextForAll("~r~/givemoney ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"givemoney",0),ServerInfo[GiveMoney]=0,GameTextForAll("~r~/givemoney ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdExplodeDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"explode",1),ServerInfo[Explode]=1,GameTextForAll("~r~/explode ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"explode",0),ServerInfo[Explode]=0,GameTextForAll("~r~/explode ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSavePCarDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"savepersonalcar",1),ServerInfo[SavePersonalCar]=1,GameTextForAll("~r~/savepersonalcar & /replacepersonalcar ~w~command have been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"savepersonalcar",0),ServerInfo[SavePersonalCar]=0,GameTextForAll("~r~/savepersonalcar & /replacepersonalcar ~w~command have been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdGetDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"get",1),ServerInfo[Get]=1,GameTextForAll("~r~/get ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"get",0),ServerInfo[Get]=0,GameTextForAll("~r~/get ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdGotoDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"goto",1),ServerInfo[Goto]=1,GameTextForAll("~r~/goto ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"goto",0),ServerInfo[Goto]=0,GameTextForAll("~r~/goto ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdVgetDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"vget",1),ServerInfo[VGet]=1,GameTextForAll("~r~/vget ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"vget",0),ServerInfo[VGet]=0,GameTextForAll("~r~/vget ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdVgotoDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"vgoto",1),ServerInfo[VGoto]=1,GameTextForAll("~r~/vgoto ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"vgoto",0),ServerInfo[VGoto]=0,GameTextForAll("~r~/vgoto ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdTeleplayerDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"teleplayer",1),ServerInfo[TelePlayer]=1,GameTextForAll("~r~/teleplayer ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"teleplayer",0),ServerInfo[TelePlayer]=0,GameTextForAll("~r~/teleplayer ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdGivecarDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"givecar",1),ServerInfo[GiveCar]=1,GameTextForAll("~r~/givecar ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"givecar",0),ServerInfo[GiveCar]=0,GameTextForAll("~r~/givecar ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSettimeDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"settime",1),ServerInfo[Settime]=1,GameTextForAll("~r~/settime ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"settime",0),ServerInfo[Settime]=0,GameTextForAll("~r~/settime ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSetweatherDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"setweather",1),ServerInfo[Setweather]=1,GameTextForAll("~r~/setweather ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"setweather",0),ServerInfo[Setweather]=0,GameTextForAll("~r~/setweather ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdGmxDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"gmx",1),ServerInfo[Gmx]=1,GameTextForAll("~r~/gmx ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"gmx",0),ServerInfo[Gmx]=0,GameTextForAll("~r~/gmx ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdCchatDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"clearchat",1),ServerInfo[ClearChat]=1,GameTextForAll("~r~/cchat ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"clearchat",0),ServerInfo[ClearChat]=0,GameTextForAll("~r~/cchat ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdCcarsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"ccars",1),ServerInfo[Ccars]=1,GameTextForAll("~r~/ccars ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"ccars",0),ServerInfo[Ccars]=0,GameTextForAll("~r~/ccars ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdTempadminDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"tempadmin",1),ServerInfo[TempAdmin]=1,GameTextForAll("~r~/tempadmin ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"tempadmin",0),ServerInfo[TempAdmin]=0,GameTextForAll("~r~/tempadmin ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdMakeadminDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"makeadmin",1),ServerInfo[MakeAdmin]=1,GameTextForAll("~r~/makeadmin ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"makeadmin",0),ServerInfo[MakeAdmin]=0,GameTextForAll("~r~/makeadmin ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdMakemegodadminDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"makemegodadmin",1),ServerInfo[MakeMeGodAdmin]=1,GameTextForAll("~r~/makemegodadmin ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"makemegodadmin",0),ServerInfo[MakeMeGodAdmin]=0,GameTextForAll("~r~/makemegodadmin ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSetplayerinteriorDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"setplayerinterior",1),ServerInfo[Setplayerinterior]=1,GameTextForAll("~r~/setplayerinterior ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"setplayerinterior",0),ServerInfo[Setplayerinterior]=0,GameTextForAll("~r~/setplayerinterior ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSetplayertimeDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"setplayertime",1),ServerInfo[Setplayertime]=1,GameTextForAll("~r~/setplayertime ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"setplayertime",0),ServerInfo[Setplayertime]=0,GameTextForAll("~r~/setplayertime ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdPlayerData2Dialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"playerdata2",1),ServerInfo[PlayerData2]=1,GameTextForAll("~r~/playerdata ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"playerdata2",0),ServerInfo[PlayerData2]=0,GameTextForAll("~r~/playerdata ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSetplayerweatherDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"setplayerweather",1),ServerInfo[Setplayerweather]=1,GameTextForAll("~r~/setplayerweather ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"setplayerweather",0),ServerInfo[Setplayerweather]=0,GameTextForAll("~r~/setplayerweather ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdWeaponDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"weapon",1),ServerInfo[Weapon]=1,GameTextForAll("~r~/weapon ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"weapon",0),ServerInfo[Weapon]=0,GameTextForAll("~r~/weapon ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdCountDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"count",1),ServerInfo[Count2]=1,GameTextForAll("~r~/count ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"count",0),ServerInfo[Count2]=0,GameTextForAll("~r~/count ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdAsayDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"achat",1),ServerInfo[AChat]=1,GameTextForAll("~r~/asay ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"achat",0),ServerInfo[AChat]=0,GameTextForAll("~r~/asay ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdAnnounceDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"achat",1),ServerInfo[AChat]=1,GameTextForAll("~r~/announce ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"achat",0),ServerInfo[AChat]=0,GameTextForAll("~r~/announce ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdLockDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"lock",1),ServerInfo[Lock]=1,GameTextForAll("~r~/lock ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"lock",0),ServerInfo[Lock]=0,GameTextForAll("~r~/lock ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdUnlockDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"unlock",1),ServerInfo[UnLock]=1,GameTextForAll("~r~/unlock ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"unlock",0),ServerInfo[UnLock]=0,GameTextForAll("~r~/unlock ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdCarcolorDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"carcolor",1),ServerInfo[CarColor]=1,GameTextForAll("~r~/carcolor ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"carcolor",0),ServerInfo[CarColor]=0,GameTextForAll("~r~/carcolor ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSetnameDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"setname",1),ServerInfo[SetName]=1,GameTextForAll("~r~/setname ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"setname",0),ServerInfo[SetName]=0,GameTextForAll("~r~/setname ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdCrashDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"crash",1),ServerInfo[Crash]=1,GameTextForAll("~r~/crash ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"crash",0),ServerInfo[Crash]=0,GameTextForAll("~r~/crash ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdBurnDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"burn",1),ServerInfo[Burn]=1,GameTextForAll("~r~/burn ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"burn",0),ServerInfo[Burn]=0,GameTextForAll("~r~/burn ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdDisarmDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"disarm",1),ServerInfo[Disarm]=1,GameTextForAll("~r~/disarm ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"disarm",0),ServerInfo[Disarm]=0,GameTextForAll("~r~/disarm ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdRemoveWeaponDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"removeweapon",1),ServerInfo[RemoveWeapon]=1,GameTextForAll("~r~/removeweapon ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"removeweapon",0),ServerInfo[RemoveWeapon]=0,GameTextForAll("~r~/removeweapon ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdVehDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"veh",1),ServerInfo[Veh]=1,GameTextForAll("~r~/veh ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"veh",0),ServerInfo[Veh]=0,GameTextForAll("~r~/veh ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdGetVHealthDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"getvhealth",1),ServerInfo[GetVHealth]=1,GameTextForAll("~r~/getvhealth ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"getvhealth",0),ServerInfo[GetVHealth]=0,GameTextForAll("~r~/getvhealth ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSetVHealthDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"setvhealth",1),ServerInfo[SetVHealth]=1,GameTextForAll("~r~/setvhealth ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"setvhealth",0),ServerInfo[SetVHealth]=0,GameTextForAll("~r~/setvhealth ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdJetpackDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"jetpack",1),ServerInfo[Jetpack]=1,GameTextForAll("~r~/jetp ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"jetpack",0),ServerInfo[Jetpack]=0,GameTextForAll("~r~/jetp ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdSaveskinDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowFirstCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"saveskin",1),ServerInfo[SaveSkin]=1,GameTextForAll("~r~/saveskin and /myskin ~w~commands have been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"saveskin",0),ServerInfo[SaveSkin]=0,GameTextForAll("~r~/saveskin and /myskin ~w~commands have been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdMakeVipDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"makevip",1),ServerInfo[MakeVip]=1,GameTextForAll("~r~/makevip ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"makevip",0),ServerInfo[MakeVip]=0,GameTextForAll("~r~/makevip ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == CmdRemoveVipDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowSecondCommandsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),EnableCmdsConfigFile);
	  if(listitem == 0)dini_IntSet(file,"removevip",1),ServerInfo[RemoveVip]=1,GameTextForAll("~r~/removevip ~w~command has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"removevip",0),ServerInfo[RemoveVip]=0,GameTextForAll("~r~/removevip ~w~command has been ~r~disabled.",3000,3);}
	return 1;}
//****************************************************************************//
  if(dialogid == AntiJetpackDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiJetpack",1),GameTextForAll("~r~Anti Jetpack ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiJetpack",0),GameTextForAll("~r~Anti Jetpack ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiMinigunDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiMinigun",1),GameTextForAll("~r~Anti Minigun ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiMinigun",0),GameTextForAll("~r~Anti Minigun ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiRpgDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiRPG",1),GameTextForAll("~r~Anti RPG ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiRPG",0),GameTextForAll("~r~Anti RPG ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiBazookaDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiBazooka",1),GameTextForAll("~r~Anti Bazooka ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiBazooka",0),GameTextForAll("~r~Anti Bazooka ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiFlameThrowerDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiFlameThrower",1),GameTextForAll("~r~Anti Flame Thrower ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiFlameThrower",0),GameTextForAll("~r~Anti Flame Thrower ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiMolotovsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiMolotovs",1),GameTextForAll("~r~Anti Molotovs ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiMolotovs",0),GameTextForAll("~r~Anti Molotovs ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiGrenadesDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiGrenades",1),GameTextForAll("~r~Anti Grenades ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiGrenades",0),GameTextForAll("~r~Anti Grenades ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiSachetChargersDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiSachetChargers",1),GameTextForAll("~r~Anti Sachet Chargers ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiSachetChargers",0),GameTextForAll("~r~Anti Sachet Chargers ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiDetonatorDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiDetonator",1),GameTextForAll("~r~Anti Detonator ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiDetonator",0),GameTextForAll("~r~Anti Detonator ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiTearGasDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiTearGas",1),GameTextForAll("~r~Anti Tear Gas ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiTearGas",0),GameTextForAll("~r~Anti Tear Gas ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiShotgunDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiShotgun",1),GameTextForAll("~r~Anti Shotgun ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiShotgun",0),GameTextForAll("~r~Anti Shotgun ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiSawnoffShotgunDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiSawnoffShotgun",1),GameTextForAll("~r~Anti Sawnoff Shotgun ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiSawnoffShotgun",0),GameTextForAll("~r~Anti Sawnoff Shotgun ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiCombatShotgunDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiCombatShotgun",1),GameTextForAll("~r~Anti Combat Shotgun ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiCombatShotgun",0),GameTextForAll("~r~Anti Combat Shotgun ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiRifleDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiRifle",1),GameTextForAll("~r~Anti Rifle ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiRifle",0),GameTextForAll("~r~Anti Rifle ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiRifleSniperDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiRifleSniper",1),GameTextForAll("~r~Anti Rifle Sniper ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiRifleSniper",0),GameTextForAll("~r~Anti Rifle Sniper ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiSprayPaintDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiSprayPaint",1),GameTextForAll("~r~Anti Spray Paint ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiSprayPaint",0),GameTextForAll("~r~Anti Spray Paint ~w~has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiFireExtinguerDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowAnticheatItemsDialog(playerid);
    if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),AnticheatConfigFile);
	  if(listitem == 0)dini_IntSet(file,"AntiFireExtinguer",1),GameTextForAll("~r~Anti Fire Extinguer ~w~has been ~g~enabled.",3000,3);
	  if(listitem == 1)dini_IntSet(file,"AntiFireExtinguer",0),GameTextForAll("~r~Anti Fire Extinguer ~w~has been ~r~disabled.",3000,3);}
	return 1;}
//****************************************************************************//
  if(dialogid == ReadCmdsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[Readcmds]=1,dini_IntSet(file,"ReadCmds",1),GameTextForAll("~r~Read Cmds ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[Readcmds]=0,dini_IntSet(file,"ReadCmds",0),GameTextForAll("~r~Read Cmds ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiSpawnKillDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AntiSpawnKill]=1,dini_IntSet(file,"AntiSpawnKill",1),GameTextForAll("~r~Anti Spawnkill ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AntiSpawnKill]=0,dini_IntSet(file,"AntiSpawnKill",0),GameTextForAll("~r~Anti Spawnkill ~w~option has been ~r~disabled.",3000,3);
	  if(listitem == 2)Options[AntiSpawnKillSeconds]=5,dini_IntSet(file,"AntiSpawnKillSeconds",5),GameTextForAll("~r~Anti Spawnkill Seconds ~w~option has been ~n~set to ~y~5.",3000,5);
	  if(listitem == 3)Options[AntiSpawnKillSeconds]=10,dini_IntSet(file,"AntiSpawnKillSeconds",10),GameTextForAll("~r~Anti Spawnkill Seconds ~w~option has been ~n~set to ~y~10.",3000,5);}
	return 1;}
  if(dialogid == AntiDriveByDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AntiDriveBy]=1,dini_IntSet(file,"AntiDriveBy",1),GameTextForAll("~r~Anti Driveby ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AntiDriveBy]=0,dini_IntSet(file,"AntiDriveBy",0),GameTextForAll("~r~Anti Driveby ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiHeliKillDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AntiHeliKill]=1,dini_IntSet(file,"AntiHeliKill",1),GameTextForAll("~r~Anti Helikill ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AntiHeliKill]=0,dini_IntSet(file,"AntiHeliKill",0),GameTextForAll("~r~Anti Helikill ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiCapsLockDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AntiCapsLock]=1,dini_IntSet(file,"AntiCapsLock",1),GameTextForAll("~r~Anti Caps Lock ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AntiCapsLock]=0,dini_IntSet(file,"AntiCapsLock",0),GameTextForAll("~r~Anti Caps Lock ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiBotsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AntiBots]=1,dini_IntSet(file,"AntiBots",1),GameTextForAll("~r~Anti Bots ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AntiBots]=0,dini_IntSet(file,"AntiBots",0),GameTextForAll("~r~Anti Bots ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == RconSecurityDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[RconSecurity]=0,dini_IntSet(file,"RconSecurity",0),GameTextForAll("~r~Rcon Security ~w~option has been ~g~Disabled (Use normal RCON).",3000,3);
	  if(listitem == 1)Options[RconSecurity]=1,dini_IntSet(file,"RconSecurity",1),GameTextForAll("~r~Rcon Security ~w~option has been set ~g~Using Second Rcon.",3000,3);
	  if(listitem == 2)Options[RconSecurity]=2,dini_IntSet(file,"RconSecurity",2),GameTextForAll("~r~Rcon Security ~w~option has been ~r~Rcon changing every second.",3000,3);}
	return 1;}
  if(dialogid == AutoLoginDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AutoLogin]=1,dini_IntSet(file,"AutoLogin",1),GameTextForAll("~r~Auto Login ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AutoLogin]=0,dini_IntSet(file,"AutoLogin",0),GameTextForAll("~r~Auto Login ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == ConnectMessagesDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[ConnectMessages]=1,dini_IntSet(file,"ConnectMessages",1),GameTextForAll("~r~Connect Messages ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[ConnectMessages]=0,dini_IntSet(file,"ConnectMessages",0),GameTextForAll("~r~Connect Messages ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AutomaticAdminColorDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AutomaticAdminColor]=1,dini_IntSet(file,"AutomaticAdminColor",1),GameTextForAll("~r~Automatic Admin Color ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AutomaticAdminColor]=0,dini_IntSet(file,"AutomaticAdminColor",0),GameTextForAll("~r~Automatic Admin Color ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiFloodDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AntiFlood]=1,dini_IntSet(file,"AntiFlood",1),GameTextForAll("~r~Anti Flood ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AntiFlood]=0,dini_IntSet(file,"AntiFlood",0),GameTextForAll("~r~Anti Flood ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiSpamDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AntiSpam]=1,dini_IntSet(file,"AntiSpam",1),GameTextForAll("~r~Anti Spam ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AntiSpam]=0,dini_IntSet(file,"AntiSpam",0),GameTextForAll("~r~Anti Spam ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiSwearDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AntiSwear]=1,dini_IntSet(file,"AntiSwear",1),GameTextForAll("~r~Anti Swear ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AntiSwear]=0,dini_IntSet(file,"AntiSwear",0),GameTextForAll("~r~Anti Swear ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == AntiForbiddenPartOfNameDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AntiForbiddenPartOfName]=1,dini_IntSet(file,"AntiForbiddenPartOfName",1),GameTextForAll("~r~Anti Forbidden Part Of Name ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AntiForbiddenPartOfName]=0,dini_IntSet(file,"AntiForbiddenPartOfName",0),GameTextForAll("~r~Anti Forbidden Part Of Name ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == LanguageDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0){
		SendClientMessage(playerid,COLOR_LIGHTGREEN,"* Loading language: Italian ...");
	    LoadLanguage("Zadmin_Italian");
		GameTextForAll("~r~Language ~w~set to ~g~ITALIANO.",3000,3);}
	  if(listitem == 1){
        SendClientMessage(playerid,COLOR_LIGHTGREEN,"* Loading language: English ...");
	    LoadLanguage("Zadmin_English");
		GameTextForAll("~r~Language ~w~set to ~r~ENGLISH.",3000,3);}
	  if(listitem == 2)return 1;
	  if(listitem == 3)return 1;
	  if(listitem == 4)return 1;
	  if(listitem == 5)return 1;
	  if(listitem == 6)return 1;
	  if(listitem == 7)return 1;}
	return 1;}
  if(dialogid == MaxMoneyDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxMoney]=1000,dini_IntSet(file,"MaxMoney",1000),GameTextForAll("~r~MaxMoney ~w~set to ~g~1000$.",3000,3);
	  if(listitem == 1)Options[MaxMoney]=10000,dini_IntSet(file,"MaxMoney",10000),GameTextForAll("~r~MaxMoney ~w~set to ~g~10000$.",3000,3);
	  if(listitem == 2)Options[MaxMoney]=100000,dini_IntSet(file,"MaxMoney",100000),GameTextForAll("~r~MaxMoney ~w~set to ~g~100000$.",3000,3);
	  if(listitem == 3)Options[MaxMoney]=1000000,dini_IntSet(file,"MaxMoney",1000000),GameTextForAll("~r~MaxMoney ~w~set to ~g~1000000$.",3000,3);
	  if(listitem == 4)Options[MaxMoney]=10000000,dini_IntSet(file,"MaxMoney",10000000),GameTextForAll("~r~MaxMoney ~w~set to ~g~10000000$.",3000,3);
	  if(listitem == 5)Options[MaxMoney]=99999999999,dini_IntSet(file,"MaxMoney",99999999999),GameTextForAll("~r~MaxMoney ~w~set to ~g~99999999999$.",3000,3);
	  if(listitem == 6)Options[MaxMoney]=999999999999999999999999999,dini_IntSet(file,"MaxMoney",999999999999999999999999999),GameTextForAll("~r~Anti Money Hack ~r~Disabled$.",3000,3);}
	return 1;}
  if(dialogid == MaxHealthDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxHealth]=50,dini_IntSet(file,"MaxHealth",50),GameTextForAll("~r~Max Health ~w~set to ~g~50.",3000,3);
	  if(listitem == 1)Options[MaxHealth]=100,dini_IntSet(file,"MaxHealth",100),GameTextForAll("~r~Max Health ~w~set to ~g~100.",3000,3);}
	return 1;}
  if(dialogid == MaxArmourDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxArmour]=0,dini_IntSet(file,"MaxArmour",0),GameTextForAll("~r~Max Armour ~w~set to ~g~0.",3000,3);
	  if(listitem == 1)Options[MaxArmour]=50,dini_IntSet(file,"MaxArmour",50),GameTextForAll("~r~Max Armour ~w~set to ~g~50.",3000,3);
	  if(listitem == 2)Options[MaxArmour]=100,dini_IntSet(file,"MaxArmour",100),GameTextForAll("~r~Max Armour ~w~set to ~g~100.",3000,3);}
	return 1;}
  if(dialogid == MaxPingDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxPing]=300,dini_IntSet(file,"MaxPing",300),GameTextForAll("~r~Max Ping ~w~set to ~g~300.",3000,3);
	  if(listitem == 1)Options[MaxPing]=600,dini_IntSet(file,"MaxPing",600),GameTextForAll("~r~Max Ping ~w~set to ~g~600.",3000,3);
	  if(listitem == 2)Options[MaxPing]=900,dini_IntSet(file,"MaxPing",900),GameTextForAll("~r~Max Ping ~w~set to ~g~900.",3000,3);
	  if(listitem == 3)Options[MaxPing]=1200,dini_IntSet(file,"MaxPing",1200),GameTextForAll("~r~Max Ping ~w~set to ~g~1200.",3000,3);}
	return 1;}
  if(dialogid == MaxPingWarningsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxPingWarnings]=3,dini_IntSet(file,"MaxPingWarnings",3),GameTextForAll("~r~Max Ping Warnings ~w~set to ~g~3.",3000,3);
	  if(listitem == 1)Options[MaxPingWarnings]=5,dini_IntSet(file,"MaxPingWarnings",5),GameTextForAll("~r~Max Ping Warnings ~w~set to ~g~5.",3000,3);
	  if(listitem == 2)Options[MaxPingWarnings]=10,dini_IntSet(file,"MaxPingWarnings",10),GameTextForAll("~r~Max Ping Warnings ~w~set to ~g~10.",3000,3);}
	return 1;}
  if(dialogid == MaxMuteWarningsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxMuteWarnings]=3,dini_IntSet(file,"MaxMuteWarnings",3),GameTextForAll("~r~Max Mute Warnings ~w~set to ~g~3.",3000,3);
	  if(listitem == 1)Options[MaxMuteWarnings]=5,dini_IntSet(file,"MaxMuteWarnings",5),GameTextForAll("~r~Max Mute Warnings ~w~set to ~g~5.",3000,3);
	  if(listitem == 2)Options[MaxMuteWarnings]=10,dini_IntSet(file,"MaxMuteWarnings",10),GameTextForAll("~r~Max Mute Warnings ~w~set to ~g~10.",3000,3);}
	return 1;}
  if(dialogid == MaxSpamWarningsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxSpamWarnings]=0,dini_IntSet(file,"MaxSpamWarnings",0),GameTextForAll("~r~Max Spam Warnings ~w~set to ~n~~g~Direct KICK.",3000,3);
	  if(listitem == 1)Options[MaxSpamWarnings]=3,dini_IntSet(file,"MaxSpamWarnings",3),GameTextForAll("~r~Max Spam Warnings ~w~set to ~g~3.",3000,3);
	  if(listitem == 2)Options[MaxSpamWarnings]=5,dini_IntSet(file,"MaxSpamWarnings",5),GameTextForAll("~r~Max Spam Warnings ~w~set to ~g~5.",3000,3);
	  if(listitem == 3)Options[MaxSpamWarnings]=10,dini_IntSet(file,"MaxSpamWarnings",10),GameTextForAll("~r~Max Spam Warnings ~w~set to ~g~10.",3000,3);}
	return 1;}
  if(dialogid == MaxFloodTimesDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxFloodTimes]=3,dini_IntSet(file,"MaxFloodTimes",3),GameTextForAll("~r~Max Flood Times ~w~set to ~g~3.",3000,3);
	  if(listitem == 1)Options[MaxFloodTimes]=5,dini_IntSet(file,"MaxFloodTimes",5),GameTextForAll("~r~Max Flood Times ~w~set to ~g~5.",3000,3);
	  if(listitem == 2)Options[MaxFloodTimes]=10,dini_IntSet(file,"MaxFloodTimes",10),GameTextForAll("~r~Max Flood Times ~w~set to ~g~10.",3000,3);
	  if(listitem == 3)Options[MaxFloodTimes]=20,dini_IntSet(file,"MaxFloodTimes",20),GameTextForAll("~r~Max Flood Times ~w~set to ~g~20.",3000,3);}
	return 1;}
  if(dialogid == MaxFloodSecondsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxFloodSeconds]=1,dini_IntSet(file,"MaxFloodSeconds",1),GameTextForAll("~r~Max Flood Seconds ~w~set to ~g~1 second.",3000,3);
	  if(listitem == 1)Options[MaxFloodSeconds]=2,dini_IntSet(file,"MaxFloodSeconds",2),GameTextForAll("~r~Max Flood Seconds ~w~set to ~g~2 seconds.",3000,3);
	  if(listitem == 2)Options[MaxFloodSeconds]=3,dini_IntSet(file,"MaxFloodSeconds",3),GameTextForAll("~r~Max Flood Seconds ~w~set to ~g~3 seconds.",3000,3);
	  if(listitem == 3)Options[MaxFloodSeconds]=4,dini_IntSet(file,"MaxFloodSeconds",4),GameTextForAll("~r~Max Flood Seconds ~w~set to ~g~4 seconds.",3000,3);
	  if(listitem == 4)Options[MaxFloodSeconds]=5,dini_IntSet(file,"MaxFloodSeconds",5),GameTextForAll("~r~Max Flood Seconds ~w~set to ~g~5 seconds.",3000,3);}
	return 1;}
  if(dialogid == MaxCFloodSecondsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxCFloodSeconds]=1,dini_IntSet(file,"MaxCFloodSeconds",1),GameTextForAll("~r~Max CommandFlood Seconds ~w~set to ~g~1 second.",3000,3);
	  if(listitem == 1)Options[MaxCFloodSeconds]=2,dini_IntSet(file,"MaxCFloodSeconds",2),GameTextForAll("~r~Max CommandFlood Seconds ~w~set to ~g~2 seconds.",3000,3);
	  if(listitem == 2)Options[MaxCFloodSeconds]=3,dini_IntSet(file,"MaxCFloodSeconds",3),GameTextForAll("~r~Max CommandFlood Seconds ~w~set to ~g~3 seconds.",3000,3);
	  if(listitem == 3)Options[MaxCFloodSeconds]=4,dini_IntSet(file,"MaxCFloodSeconds",4),GameTextForAll("~r~Max CommandFlood Seconds ~w~set to ~g~4 seconds.",3000,3);
	  if(listitem == 4)Options[MaxCFloodSeconds]=5,dini_IntSet(file,"MaxCFloodSeconds",5),GameTextForAll("~r~Max CommandFlood Seconds ~w~set to ~g~5 seconds.",3000,3);}
	return 1;}
  if(dialogid == AllowCmdsOnAdminsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[AllowCmdsOnAdmins]=1,dini_IntSet(file,"AllowCmdsOnAdmins",1),GameTextForAll("~r~Allow Commands On Admins ~w~option has been ~g~enabled.",3000,3);
	  if(listitem == 1)Options[AllowCmdsOnAdmins]=0,dini_IntSet(file,"AllowCmdsOnAdmins",0),GameTextForAll("~r~Allow Commands On Admins ~w~option has been ~r~disabled.",3000,3);}
	return 1;}
  if(dialogid == RegisterInDialogDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[RegisterInDialog]=1,dini_IntSet(file,"RegisterInDialog",0),GameTextForAll("~r~Registration ~w~option has been set ~g~BY COMMAND.",3000,3);
	  if(listitem == 1)Options[RegisterInDialog]=0,dini_IntSet(file,"RegisterInDialog",1),GameTextForAll("~r~Registration ~w~option has been set ~r~BY DIALOG.",3000,3);}
	return 1;}
  if(dialogid == MustRegisterDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MustRegister]=1,dini_IntSet(file,"MustRegister",1),GameTextForAll("~r~Must Registration ~w~option has been ~g~ENABLED.",3000,3);
	  if(listitem == 1)Options[MustRegister]=0,dini_IntSet(file,"MustRegister",0),GameTextForAll("~r~Must Registration ~w~option has been ~r~DISABLED.",3000,3);}
	return 1;}
  if(dialogid == MustLoginDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MustLogin]=1,dini_IntSet(file,"MustLogin",1),GameTextForAll("~r~Must Login ~w~option has been set ~g~ENABLED.",3000,3);
	  if(listitem == 1)Options[MustLogin]=0,dini_IntSet(file,"MustLogin",0),GameTextForAll("~r~Must Login ~w~option has been set ~r~DISABLED.",3000,3);}
	return 1;}
  if(dialogid == MaxWarningsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxWarnings]=3,dini_IntSet(file,"MaxWarnings",3),GameTextForAll("~r~Max Warnings ~w~option has been set to ~g~3.",3000,3);
	  if(listitem == 1)Options[MaxWarnings]=5,dini_IntSet(file,"MaxWarnings",5),GameTextForAll("~r~Max Warnings ~w~option has been set to ~r~5.",3000,3);
	  if(listitem == 2)Options[MaxWarnings]=10,dini_IntSet(file,"MaxWarnings",10),GameTextForAll("~r~Max Warnings ~w~option has been set to ~r~10.",3000,3);}
	return 1;}
  if(dialogid == MaxBanWarningsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxBanWarnings]=5,dini_IntSet(file,"MaxBanWarnings",5),GameTextForAll("~r~Max Ban Warnings ~w~option has been set to ~g~5.",3000,3);
	  if(listitem == 1)Options[MaxBanWarnings]=10,dini_IntSet(file,"MaxBanWarnings",10),GameTextForAll("~r~Max Ban Warnings ~w~option has been set to ~r~10.",3000,3);
	  if(listitem == 2)Options[MaxBanWarnings]=15,dini_IntSet(file,"MaxBanWarnings",15),GameTextForAll("~r~Max Ban Warnings ~w~option has been set to ~r~15.",3000,3);}
	return 1;}
  if(dialogid == MaxVotesForKickDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxVotesForKick]=3,dini_IntSet(file,"MaxVotesForKick",3),GameTextForAll("~r~Maximum Votes to Kick a Player ~w~have been set to ~g~3.",3000,3);
	  if(listitem == 1)Options[MaxVotesForKick]=5,dini_IntSet(file,"MaxVotesForKick",5),GameTextForAll("~r~Maximum Votes to Kick a Player ~w~have been set to ~r~5.",3000,3);
	  if(listitem == 2)Options[MaxVotesForKick]=10,dini_IntSet(file,"MaxVotesForKick",10),GameTextForAll("~r~Maximum Votes to Kick a Player ~w~have been set to ~r~10.",3000,3);}
	return 1;}
  if(dialogid == MaxVotesForBanDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxVotesForBan]=5,dini_IntSet(file,"MaxVotesForBan",5),GameTextForAll("~r~Maximum Votes to Kick a Player ~w~have been set to ~g~5.",3000,3);
	  if(listitem == 1)Options[MaxVotesForBan]=10,dini_IntSet(file,"MaxVotesForBan",10),GameTextForAll("~r~Maximum Votes to Kick a Player ~w~have been set to ~r~10.",3000,3);
	  if(listitem == 2)Options[MaxVotesForBan]=15,dini_IntSet(file,"MaxVotesForBan",15),GameTextForAll("~r~Maximum Votes to Kick a Player ~w~have been set to ~r~15.",3000,3);
	  if(listitem == 3)Options[MaxVotesForBan]=30,dini_IntSet(file,"MaxVotesForBan",30),GameTextForAll("~r~Maximum Votes to Kick a Player ~w~have been set to ~r~30.",3000,3);}
	return 1;}
  if(dialogid == MaxVotesForCcarsDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0)Options[MaxVotesForCcars]=3,dini_IntSet(file,"MaxVotesForCcars",3),GameTextForAll("~r~Maximum Votes to ~n~Clear Spawned Vehicles ~w~have been set to ~g~3.",3000,3);
	  if(listitem == 1)Options[MaxVotesForCcars]=5,dini_IntSet(file,"MaxVotesForCcars",5),GameTextForAll("~r~Maximum Votes to ~n~Clear Spawned Vehicles ~w~have been set to ~r~5.",3000,3);
	  if(listitem == 2)Options[MaxVotesForCcars]=10,dini_IntSet(file,"MaxVotesForCcars",10),GameTextForAll("~r~Maximum Votes to ~n~Clear Spawned Vehicles ~w~have been set to ~r~10.",3000,3);
	  if(listitem == 3)Options[MaxVotesForCcars]=20,dini_IntSet(file,"MaxVotesForCcars",20),GameTextForAll("~r~Maximum Votes to ~n~Clear Spawned Vehicles ~w~have been set to ~r~20.",3000,3);}
	return 1;}
  if(dialogid == AFKSystemDialog)if(Account[playerid][pAdminlevel]>=1){
    if(response==0)ShowOptionsConfigDialog(playerid);
	if(response==1){
      new file[MAX_SERVER_STRING];format(file,sizeof(file),OptionsConfigFile);
	  if(listitem == 0){
	    Options[AFKSystem]=1;
		dini_IntSet(file,"AFKSystem",1);
		GameTextForAll("~r~AFK System ~w~has been ~g~ENABLED.",3000,3);
		for(new i=0;i<MAX_SERVER_PLAYERS;i++)if(IsPlayerConnected(i)){
		  AfkTimer[i]=SetTimerEx("CheckPlayersAFK",500,1,"d",i);}}
	  if(listitem == 1){
	    Options[AFKSystem]=0,dini_IntSet(file,"AFKSystem",0);
		GameTextForAll("~r~AFK System ~w~has been ~r~DISABLED.",3000,3);
		for(new i=0;i<MAX_SERVER_PLAYERS;i++)if(IsPlayerConnected(i))KillTimer(AfkTimer[i]);}}
	return 1;}
  return 1;}
  
/*******************************************************************************
*                   OnPlayerEnterVehicle(playerid,vehicleid)                   *
*******************************************************************************/

public OnPlayerEnterVehicle(playerid,vehicleid){
  IfAfk(playerid);
  new Var=501;
  new afile[256];
  new Float:x,Float:y,Float:z;
  for(new i=0;i<MAX_SERVER_PLAYERS;i++)if(IsPlayerConnected(i)){
    if(vehicleid==PlayerVehicle[i]){
      Var=i;}}
  if(Var!=501 && vehicleid!=PlayerVehicle[playerid]){
	GetPlayerName(Var,name,24);
	format(afile,256,UsersFile,name);
	if(dini_Int(afile,"AntiCarStealing")==1){
      format(string,sizeof(string),LanguageText[380],name);
      SendClientMessage(playerid,COLOR_LIGHTRED,string);
      //TogglePlayerControllable(playerid,1);
	  GetPlayerPos(playerid,x,y,z);
	  SetPlayerPos(playerid,x,y,z+0.3);}
    if(dini_Int(afile,"AntiCarStealing")==0){
      format(string,sizeof(string),LanguageText[381],name);
	  SendClientMessage(playerid,COLOR_GREEN,string);}
    Var=501;}
  return 1;}

public OnPlayerExitVehicle(playerid,vehicleid){
  IfAfk(playerid);
  return 1;}
  
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){
  IfAfk(playerid);
  return 1;}

/*******************************************************************************
*                                  <=[STOCKS]=>                                *
*******************************************************************************/
stock ShowFirstCommandsDialog(playerid){
  ShowPlayerDialog(playerid, EnableCommandsDialog1, DIALOG_STYLE_LIST, "Commands Enable Options 1:\nSelect the command you want to\nEnable or\nDisable","/pm\n/kick\n/ban\n/fix\n/flip\n/spec\n/specoff\n/jail\n/unjail\n/freeze\n/unfreeze\n/heal\n/armour\n/getip\n/mute\n/unmute\n/reset\n/setskin\n/setskintome\n/setscore\n/slap\n/die\n/givemoney\n/explode\n/get\n/goto\n/vget\n/vgoto\n/teleplayer\n"#COL_GREEN"> NEXT COMMANDS <", "Next", "Return");}
//----------------------------------------------------------------------------//
stock ShowSecondCommandsDialog(playerid){
  ShowPlayerDialog(playerid, EnableCommandsDialog2, DIALOG_STYLE_LIST, "Commands Enable Options 2:\nSelect the command you want to\nEnable or\nDisable","/givecar\n/settime\n/setweather\n/gmx\n/cchat\n/ccars\n/tempadmin\n/makeadmin\n/makemegodadmin\n/setplayerinterior\n/setplayertime\n/playerdata\n/setplayerweather\n/weapon\n/count\n/asay\n/announce\n/lock\n/unlock\n/carcolor\n/setname\n/crash\n/burn\n/disarm\n/removeweapon\n/veh\n/GetVHealth\n"#COL_GREEN">> NEXT COMMANDS <<", "Next", "Return");}
//----------------------------------------------------------------------------//
stock ShowThirdCommandsDialog(playerid){
  ShowPlayerDialog(playerid, EnableCommandsDialog3, DIALOG_STYLE_LIST, "Commands Enable Options 2:\nSelect the command you want to\nEnable or\nDisable","SetVHealth\n/Jetp (jetpack)\n/saveskin\n/makevip\n/removevip\n/savepersonalcar", "Next", "Return");}
//----------------------------------------------------------------------------//
stock ShowAnticheatItemsDialog(playerid){
  ShowPlayerDialog(playerid, AnticheatItemsDialog, DIALOG_STYLE_LIST, "ANTICHEAT OPTIONS:\nWhat do you want to modify?","Max Money\nMax Health\nMax Armour\nAnti Jetpack\nAnti Minigun\nAnti RPG\nAnti Bazooka\nAnti Flame Thrower\nAnti Molotovs\nAnti Grenades\nAnti Sachet Chargers\nAnti Detonator\nAnti Tear Gas\nAnti Shotgun\nAnti Sawnoff Shotgun\nAnti Combat Shotgun\nAnti Rifle\nAnti Rifle Sniper\nAnti Spray Paint\nAnti Fire Extinguer", "Next", "Return");}
//----------------------------------------------------------------------------//
stock ShowOptionsConfigDialog(playerid){
  ShowPlayerDialog(playerid, ServerOptionsDialog, DIALOG_STYLE_LIST, "SERVER OPTIONS:\nWhat do you want to modify?","Read Cmds\nAuto Login\nConnct Messages\nAutomatic Admin Color\nAnti Flood\nAnti Spam\nAnti Swear\nAnti Forbidden Part of Name\nLanguage\nMax Ping\nMax Ping Warnings\nMax Mute Warnings\nMax Spam Warnings\nMax Flood Times\nMax Flood Seconds\nMax CommandFlood Seconds\nAllow Commands On Admins\nRegistration Type\nMust Register\nMust Login\n"#COL_GREEN">> NEXT OPTIONS <<", "Next", "Return");}
//----------------------------------------------------------------------------//
stock ShowOptionsConfigDialog2(playerid){
  ShowPlayerDialog(playerid, ServerOptionsDialog2, DIALOG_STYLE_LIST, "SERVER OPTIONS:\nWhat do you want to modify?","Max Warnings\nMax Ban Warnings\nMax Votekicks\nMax Votebans\nMax Voteccars\nAFK System\n\nAnti Spawnkill\nAnti Bots\nRCON Security\nAnti Driveby\nAnti Helikill\nAnti Caps Lock", "Next", "Return");}
//----------------------------------------------------------------------------//
stock IfAfk(playerid){
  PlayerAfkTime[playerid]=0;
  if(IsAFK[playerid]==true){
    SetPlayerOffAFK(playerid);
	IsAFK[playerid]=false;}}

stock SetPlayerInAFK(playerid){
  Update3DTextLabelText(AfkPlayerLabels[playerid],0x21DD00FF,">> AFK <<");
  GetPlayerName(playerid,name,sizeof(name));
  format(str,sizeof(str),"--- %s is AFK!",name);
  SendClientMessageToAll(0x21DD00FF,str);print(str);
  IsAFK[playerid]=true;}

stock SetPlayerOffAFK(playerid){
  Update3DTextLabelText(AfkPlayerLabels[playerid],0x21DD00FF,"  ");
  GetPlayerName(playerid,name,sizeof(name));
  format(str,sizeof(str),"--- %s is back from AFK!",name);
  SendClientMessageToAll(0x21DD00FF,str);print(str);
  IsAFK[playerid]=false;}

stock LoadIpBans(){
  new File:st;
  RBannedPlayersCount=0;
  if((st = fopen(IpBansFile,io_read))){
    while(fread(st,str)){
      for(new i=0, j=strlen(str); i<j; i++) if(str[i]=='\n'||str[i]=='\r') str[i]='\0';
      RBannedPlayers[RBannedPlayersCount] = str;
      RBannedPlayersCount++;}
	fclose(st);}
  return 1;}
  
stock IsPlayerInPlane(playerid){
  switch(GetVehicleModel(GetPlayerVehicleID(playerid))){
	case 476,520,460,511,512,513,519,553,577,592,593: return 1;}
  return 0;}
//----------------------------------------------------------------------------//
stock MessageToAdmins(color,const stringa2[]){
  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	if(IsPlayerConnected(i)==1)if(Account[i][pAdminlevel]>=1)SendClientMessage(i, color, stringa2);}
  return 1;}
//----------------------------------------------------------------------------//
stock GameTextToAdmins(const stringa2[],time,type){
  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	if(IsPlayerConnected(i)==1)if(Account[i][pAdminlevel]>=1)GameTextForPlayer(i, stringa2, time, type);}
  return 1;}
//----------------------------------------------------------------------------//
stock MessageToVips(color,const stringa2[]){
  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	if(IsPlayerConnected(i)==1)if(Account[i][pVip]>=1 || Account[i][pAdminlevel]>=1)SendClientMessage(i, color, stringa2);}
  return 1;}
//----------------------------------------------------------------------------//
stock IsNumeric(line[]){
  for(new i=0, j=strlen(line); i<j; i++){
    if(line[i]>'9' || line[i]<'0') return 0;}
  return 1;}
//----------------------------------------------------------------------------//
stock GetVehicleModelIDFromName(vname[]){
  for(new i=0; i<211; i++){
    if(strfind(VehicleNames[i], vname, true)!=-1)
      return i+400;}
  return -1;}
//----------------------------------------------------------------------------//
stock AdminsNumber(){
  new Var=0;
  for(new a=0;a<MAX_SERVER_PLAYERS;a++){
    if(Account[a][pAdminlevel]>=1){
	  Var++;}}
  AdminsCount=Var;
  Var=0;}
//----------------------------------------------------------------------------//
stock GetWeaponModelIDFromName(wname[]){
  for(new i=0; i<46; i++){
    if(strfind(WeaponNames[i], wname, true)!=-1)
      return i-1;}
  return -1;}
//----------------------------------------------------------------------------//
argpos(const stringa5[],idx=0,sep=' '){
  for(new i=idx, j=strlen(stringa5); i<j; i++)
    if(stringa5[i]==sep && stringa5[i+1]!=sep)
      return i+1;
  return -1;}
//----------------------------------------------------------------------------//
stock IsPlayerRegistered(playerid){
  new kname[24];
  GetPlayerName(playerid, kname, sizeof(kname));
  new file[MAX_SERVER_STRING];format(file, sizeof(file), UsersFile, kname);
  if(dini_Exists(file)){
    return 1;}
  else return 0;}
//----------------------------------------------------------------------------//
stock OnPlayerRegister(playerid, params[]){
  new file[MAX_SERVER_STRING],tmp3[100],year,month,day; getdate(year,month,day);
  GetPlayerName(playerid, pname, sizeof(pname));
  format(file, sizeof(file), UsersFile, pname);
  dini_Create(file);
  PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
  GetPlayerIp(playerid,tmp3,100);
  format(str, sizeof(str), "%d/%d/%d",day,month,year);
  dini_Set(file,"RegistrationDate",str);
  dini_Set(file,"ip",tmp3);
  dini_IntSet(file, "hashPW", udb_hash(params));
  dini_Set(file, "password", params);
  dini_IntSet(file, "adminlevel", 0);
  dini_IntSet(file, "VIP", 0);
  dini_IntSet(file, "score", Account[playerid][pScore]);
  dini_IntSet(file, "money", Account[playerid][pCash]);
  dini_IntSet(file, "deaths", Account[playerid][pDeaths]);
  dini_IntSet(file, "kills", Account[playerid][pKills]);
  dini_IntSet(file, "muted", 0);
  dini_IntSet(file, "freezed", 0);
  dini_IntSet(file, "jailed", 0);
  format(str, sizeof(str), LanguageText[382], pname, params);
  SendClientMessage(playerid, COLOR_LIGHTGREEN, str);
  format(str, sizeof(str), LanguageText[383], pname);
  MessageToAdmins(COLOR_GREY,str);
  if(Options[AutoLogin]==0){
    Account[playerid][pLoggedin]=0;
    dini_IntSet(file, "loggedin", Account[playerid][pLoggedin]);
    SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[384]);}
  if(Options[AutoLogin]==1){
    Account[playerid][pLoggedin]=1;
    PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
    dini_IntSet(file, "loggedin", Account[playerid][pLoggedin]);
    SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[385]);}}
//----------------------------------------------------------------------------//
stock OnPlayerLogin(playerid){
  GetPlayerName(playerid, pname, sizeof(pname));
  new file[MAX_SERVER_STRING],tmp3[100];format(file,sizeof(file),UsersFile, pname);
  if(dini_Isset(file,"ID") && dini_Isset(file,"X")  && dini_Isset(file,"Y") && dini_Isset(file,"Z") && dini_Isset(file,"ROT") && dini_Isset(file,"COLOR1") && dini_Isset(file,"COLOR2")){
	PlayerVehicle[playerid]=CreateVehicle(dini_Int(file,"ID"),dini_Int(file,"X"),dini_Int(file,"Y"),dini_Int(file,"Z"),dini_Int(file,"ROT"),dini_Int(file,"COLOR1"),dini_Int(file,"COLOR2"),100);
	SendClientMessage(playerid, COLOR_LIGHTGREEN, LanguageText[386]);}
  GetPlayerIp(playerid,tmp3,sizeof(tmp3));
  dini_Set(file,"ip",tmp3);
  PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
  Account[playerid][pLoggedin]=1;
  Account[playerid][pScore]=dini_Int(file,"score");
  Account[playerid][pDeaths]=dini_Int(file,"deaths");
  Account[playerid][pKills]=dini_Int(file,"kills");
  Account[playerid][pAdminlevel]=dini_Int(file, "adminlevel");
  Account[playerid][pVip]=dini_Int(file, "VIP");
  Account[playerid][pCash]=dini_Int(file, "money");
  dini_IntSet(file, "loggedin", Account[playerid][pLoggedin]);
  SetPlayerScore(playerid, Account[playerid][pScore]);
  #if defined SpecialAntiMoneyHack
	GiveZMoney(playerid, Account[playerid][pCash]-GetPlayerMoney(playerid));
  #else
    GivePlayerMoney(playerid, Account[playerid][pCash]-GetPlayerMoney(playerid));
  #endif
  }
//----------------------------------------------------------------------------//
stock OnPlayerLogout(playerid){
  GetPlayerName(playerid, pname, sizeof(pname));
  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile, pname);
  if(Account[playerid][pLoggedin]==1){
	SavePlayerData(playerid);
    dini_IntSet(file, "loggedin", 0);}
  if(PlayerVehicle[playerid]!=-1){
    DestroyVehicle(PlayerVehicle[playerid]);
    format(string, sizeof(string), LanguageText[387], pname);
	print(string);}
  Account[playerid][pDeaths]=0;
  Account[playerid][pKills]=0;
  Account[playerid][pLoggedin]=0;
  Account[playerid][pScore]=0;
  Account[playerid][pCash]=0;
  Account[playerid][pAdminlevel]=0;
  Account[playerid][pVip]=0;}
//----------------------------------------------------------------------------//
stock SavePlayerData(playerid){
  GetPlayerName(playerid, pname, sizeof(pname));
  new file[MAX_SERVER_STRING];format(file, sizeof(file), UsersFile, pname);
  Account[playerid][pCash]=GetPlayerMoney(playerid);
  Account[playerid][pScore]=GetPlayerScore(playerid);
  dini_IntSet(file, "score", GetPlayerScore(playerid));
  dini_IntSet(file, "money", Account[playerid][pCash]);
  dini_IntSet(file, "deaths", Account[playerid][pDeaths]);
  dini_IntSet(file, "kills", Account[playerid][pKills]);
  if(Account[playerid][pMuted]==true)dini_IntSet(file, "muted", 1);
  if(Account[playerid][pMuted]==false)dini_IntSet(file, "muted", 0);
  if(Account[playerid][pFreezed]==true)dini_IntSet(file, "freezed", 1);
  if(Account[playerid][pFreezed]==false)dini_IntSet(file, "freezed", 0);
  if(Account[playerid][pJailed]==true)dini_IntSet(file, "jailed", 1);
  if(Account[playerid][pJailed]==false)dini_IntSet(file, "jailed", 0);
  dini_IntSet(file, "loggedin", Account[playerid][pLoggedin]);}
//----------------------------------------------------------------------------//
stock TelePlayerVehicle(playerid,Float:X,Float:Y,Float:Z,Float:ROT,INT){
  new VehicleID = GetPlayerVehicleID(playerid);
  SetVehiclePos(VehicleID,X,Y,Z); LinkVehicleToInterior(VehicleID,INT);SetVehicleZAngle(VehicleID,ROT);
  SetVehicleVirtualWorld(VehicleID, GetPlayerVirtualWorld(playerid));
  return 1;}
//----------------------------------------------------------------------------//
stock CommandDisabled(playerid){
  SendClientMessage(playerid, COLOR_LIGHTRED, LanguageText[388]);
  return 1;}
//----------------------------------------------------------------------------//
stock SpammingText(type[]){
  new strspam[128];
  GetPlayerName(playerspammer,name,sizeof(name));
  format(strspam,sizeof(strspam),LanguageText[415],name,type);
  print(strspam);
  return 1;}
//----------------------------------------------------------------------------//
stock CheckIfSpam(ChatText[]){
  new Spamming,Spam1,Spam2,Spam3,Spam4;
  for(Spamming=0;Spamming<strlen(ChatText);Spamming++){
    if(ChatText[Spamming]=='.' || ChatText[Spamming]==',' || ChatText[Spamming]=='.')Spam1++;
    if(ChatText[Spamming]=='0' || ChatText[Spamming]=='1' || ChatText[Spamming]=='2' || ChatText[Spamming]=='3' || ChatText[Spamming]=='4' || ChatText[Spamming]=='5' || ChatText[Spamming]=='6' || ChatText[Spamming]=='7' || ChatText[Spamming]=='8' || ChatText[Spamming]=='9')Spam2++;
    if(ChatText[Spamming]=='w' || ChatText[Spamming]=='W')Spam3++;
    if(ChatText[Spamming]==':')Spam4++;}
  if(Spam1>=3 && Spam2>=4){
	SpammingText("IP Adress"); //find IP
	return 1;}
  if(Spam3>=3){
    SpammingText("Link");
	return 1;}
  if(strfind(ChatText,".com",true)!=-1|| strfind(ChatText, "http", true) != -1 || strfind(ChatText, ".org", true) != -1 || strfind(ChatText, ".net", true) != -1 || strfind(ChatText, ".es", true) != -1 || strfind(ChatText, ".tk", true) != -1 || strfind(ChatText, ".it", true) != -1){
    SpammingText("URL");
	return 1;}
  if(Spam4>=1&&Spam2>=4){
    SpammingText("IP Port");
	return 1;}
  return 0;}

public AntiDriveByTimer(){
  if(Options[AntiDriveBy]==1){
    for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	  if(IsPlayerConnected(i))if(!IsPlayerNPC(i)){
	    if(IsPlayerInAnyVehicle(i)){
		  GivePlayerWeapon(i,1,1);}}}}
  return 1;}

public CheckIfIsPlayerBot(playerid){
  if(IsPlayerConnected(playerid)){
    if(IsPlayerNPC(playerid)){
      IsBot[playerid]=true;
	  KickBot(playerid,1);
	  return 1;}
    if(GetPlayerPing(playerid)<1){
      IsBot[playerid]=true;
	  KickBot(playerid,2);}
	new ip[20],ip2[20];GetPlayerIp(playerid,ip,sizeof(ip));
	for(new i=0;i<MAX_SERVER_PLAYERS;i++)if(IsPlayerConnected(i)){
	  GetPlayerIp(i,ip2,sizeof(ip2));
	  if(strcmp(ip,ip2,true)==0)if(i!=playerid){
        IsBot[playerid]=true;
	    KickBot(playerid,3);
		return 1;}}}
  return 1;}
  
stock KickBot(playerid,zcase){
  new ip[20];GetPlayerIp(playerid,ip,sizeof(ip));
  GetPlayerName(playerid,name,sizeof(name));
  Kick(playerid);
  format(string,sizeof(string),LanguageText[414],name,playerid,ip,GetPlayerPing(playerid), zcase);
  SendClientMessageToAll(COLOR_YELLOW,string);
  printf("ANTI BOTS: Possible bot has been kicked: =>  %s (ID:%d); Case %d", name, playerid, zcase);}
  
/*******************************************************************************
*                                  <=[TIMERS]=>                                *
*******************************************************************************/

public ReactiveAfkTimer(playerid){
  AfkTimer[playerid]=SetTimerEx("CheckPlayersAFK",500,1,"d",playerid);
  return 1;}

public CheckPlayersAFK(playerid){
  if(Spawned[playerid]==true){
	if(Var1[playerid]==1){
	    GetPlayerPos(playerid,X1[playerid],Y1[playerid],Z1[playerid]);
	    Var1[playerid]=2;
	    GetPlayerHealth(playerid,health1);
		return 1;}
    if(Var1[playerid]==2){
	    GetPlayerPos(playerid,X2[playerid],Y2[playerid],Z2[playerid]);
		Var1[playerid]=1;
		GetPlayerHealth(playerid,health2);
		if(health1!=health2){
          IfAfk(playerid);}
        if(X1[playerid]!=X2[playerid] || Y1[playerid]!=Y2[playerid] || Z1[playerid]!=Z2[playerid]){
          IfAfk(playerid);}
	    if(X1[playerid]==X2[playerid] && Y1[playerid]==Y2[playerid] &&Z1[playerid]==Z2[playerid]){
          if(PlayerAfkTime[playerid]==AFK_MAX_SECONDS && IsAFK[playerid]==false){
            SetPlayerInAFK(playerid);}
		  if(PlayerAfkTime[playerid]==0 && IsAFK[playerid]==true){
            SetPlayerOffAFK(playerid);}
		  PlayerAfkTime[playerid]++;}}}
  return 1;}
  
public JustSpawnedDelete(playerid){
  JustSpawned[playerid]=false;
  return 1;}

public ReFreezePlayer(playerid){
  TogglePlayerControllable(playerid,0);
  new file[MAX_SERVER_STRING];GetPlayerName(playerid, incriminato, sizeof(incriminato));format(file,sizeof(file),UsersFile,incriminato);
  dini_IntSet(file,"freezed",1);
  GameTextForPlayer(playerid,LanguageText[389],5000,3);
  #if defined show_zadmin_log_events
  printf("Zadmin: re-freezed playerid %d",playerid);
  #endif
  return 1;}

public ReJailPlayer(playerid){
  SetPlayerPos(playerid,264.0535,77.2942,1001.0391);
  new file[MAX_SERVER_STRING];GetPlayerName(playerid, incriminato, sizeof(incriminato));format(file,sizeof(file),UsersFile,incriminato);
  dini_IntSet(file,"jailed",1);
  GameTextForPlayer(playerid,LanguageText[390],5000,3);
  SetPlayerHealth(player,1);
  SetPlayerInterior(player,6);
  ResetPlayerWeapons(player);
  #if defined show_zadmin_log_events
  printf("Zadmin: re-jailed playerid %d",playerid);
  #endif
  return 1;}
  
public RconChanger(){
  if(Options[RconSecurity]==2){
    format(string,256,"rcon_password %s",WeaponNames[random(30)]);
    SendRconCommand(string);}
  return 1;}

public StopWarninging(playerid){
  Warninging[playerid]=false;
  return 1;}
  
public StopBanWarninging(playerid){
  BanWarninging[playerid]=false;
  return 1;}
  
public SpawnPlayerZ(playerid){
  Spawned[playerid]=true;
  return 1;}

public SavePlayerStat(){
  #if defined show_zadmin_log_events
  print("Zadmin: Saving Player Stats");
  #endif
  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
	if(IsPlayerConnected(i)){
	  if(Spawned[i]==true){
		if(Account[i][pLoggedin]==1){
          SavePlayerData(i);}}}}
  return 1;}

public AllowPlayerFixing(playerid){
  AllowFixing[playerid]=true;
  return 1;}

public ServerConfiguration(){
	#if defined show_zadmin_log_events
	print("Zadmin: Updating Config...");
	#endif
    LoadIpBans();
    new file[MAX_SERVER_STRING]; format(file,sizeof(file),EnableCmdsConfigFile);
    if(dini_Exists(file)){
		ServerInfo[SaveSkin] = dini_Int(file,"saveskin");
		ServerInfo[Pm] = dini_Int(file,"pm");
		ServerInfo[Veh] = dini_Int(file,"veh");
		ServerInfo[GiveCar] = dini_Int(file,"givecar");
		ServerInfo[GetVHealth] = dini_Int(file,"getvhealth");
		ServerInfo[SetVHealth] = dini_Int(file,"setvhealth");
        ServerInfo[Heal] = dini_Int(file,"heal");
        ServerInfo[Jetpack] = dini_Int(file,"jetpack");
        ServerInfo[Armour] = dini_Int(file,"armour");
		ServerInfo[Mute] = dini_Int(file,"mute");
		ServerInfo[GetIp] = dini_Int(file,"getip");
		ServerInfo[UnMute] = dini_Int(file,"unmute");
		ServerInfo[Spec] = dini_Int(file,"spec");
		ServerInfo[SpecOff] = dini_Int(file,"specoff");
		ServerInfo[kick] = dini_Int(file,"kick");
		ServerInfo[ban] = dini_Int(file,"ban");
		ServerInfo[Fix] = dini_Int(file,"fix");
		ServerInfo[Flip] = dini_Int(file,"flip");
		ServerInfo[Jail] = dini_Int(file,"jail");
		ServerInfo[UnJail] = dini_Int(file,"unjail");
		ServerInfo[GiveMoney] = dini_Int(file,"givemoney");
		ServerInfo[Reset] = dini_Int(file,"reset");
		ServerInfo[Freeze] = dini_Int(file,"freeze");
		ServerInfo[UnFreeze] = dini_Int(file,"unfreeze");
		ServerInfo[Die] = dini_Int(file,"die");
		ServerInfo[Slap] = dini_Int(file,"slap");
		ServerInfo[Goto] = dini_Int(file,"goto");
		ServerInfo[Get] = dini_Int(file,"get");
		ServerInfo[VGoto] = dini_Int(file,"vgoto");
		ServerInfo[VGet] = dini_Int(file,"vget");
		ServerInfo[TelePlayer] = dini_Int(file,"teleplayer");
		ServerInfo[Explode] = dini_Int(file,"explode");
		ServerInfo[Setscore] = dini_Int(file,"setscore");
		ServerInfo[Setskin] = dini_Int(file,"setskin");
		ServerInfo[SetskinToMe] = dini_Int(file,"setskintome");
		ServerInfo[Setweather] = dini_Int(file,"setweather");
		ServerInfo[Setplayerweather] = dini_Int(file,"setplayerweather");
		ServerInfo[Settime] = dini_Int(file,"settime");
		ServerInfo[Setplayertime] = dini_Int(file,"setplayertime");
		ServerInfo[PlayerData2] = dini_Int(file,"playerdata2");
		ServerInfo[ClearChat] = dini_Int(file,"clearchat");
		ServerInfo[Gmx] = dini_Int(file,"gmx");
		ServerInfo[Ccars] = dini_Int(file,"ccars");
		ServerInfo[TempAdmin] = dini_Int(file,"tempadmin");
		ServerInfo[MakeAdmin] = dini_Int(file,"makeadmin");
		ServerInfo[MakeVip] = dini_Int(file,"makevip");
		ServerInfo[RemoveVip] = dini_Int(file,"removevip");
		ServerInfo[MakeMeGodAdmin] = dini_Int(file,"makemegodadmin");
		ServerInfo[Weapon] = dini_Int(file,"weapon");
		ServerInfo[Count2] = dini_Int(file,"count");
		ServerInfo[Setplayerinterior] = dini_Int(file,"setplayerinterior");
		ServerInfo[God] = dini_Int(file,"god");
		ServerInfo[SGod] = dini_Int(file,"sgod");
		ServerInfo[ChangeName] = dini_Int(file,"changename");
		ServerInfo[VoteKick] = dini_Int(file,"votekick");
		ServerInfo[VoteBan] = dini_Int(file,"voteban");
		ServerInfo[VoteCcars] = dini_Int(file,"voteccars");
		ServerInfo[Warn] = dini_Int(file,"warn");
		ServerInfo[Lock] = dini_Int(file,"lock");
		ServerInfo[UnLock] = dini_Int(file,"unlock");
		ServerInfo[CarColor] = dini_Int(file,"carcolor");
		ServerInfo[Crash] = dini_Int(file,"crash");
		ServerInfo[Burn] = dini_Int(file,"burn");
		ServerInfo[Disarm] = dini_Int(file,"disarm");
		ServerInfo[RemoveWeapon] = dini_Int(file,"removeweapon");
		ServerInfo[SetName] = dini_Int(file,"setname");
		ServerInfo[Eject] = dini_Int(file,"eject");
		ServerInfo[ResetWarnings] = dini_Int(file,"resetwarnings");
		ServerInfo[Setgravity] = dini_Int(file,"setgravity");
		ServerInfo[AChat] = dini_Int(file,"achat");
		ServerInfo[Announce] = dini_Int(file,"announce");
		ServerInfo[ForbidWord] = dini_Int(file,"forbidword");
		ServerInfo[SavePersonalCar] = dini_Int(file,"savepersonalcar");}

    format(file,sizeof(file),OptionsConfigFile);
	if(dini_Exists(file)){
        Options[RegisterInDialog] = dini_Int(file,"RegisterInDialog");
        Options[AllowCmdsOnAdmins] = dini_Int(file,"AllowCmdsOnAdmins");
        Options[AntiSpawnKill] = dini_Int(file,"AntiSpawnKill");
        Options[AntiSpawnKillSeconds] = dini_Int(file,"AntiSpawnKillSeconds");
        Options[AntiBots] = dini_Int(file,"AntiBots");
        Options[RconSecurity] = dini_Int(file,"RconSecurity");
        Options[Readcmds] = dini_Int(file,"ReadCmds");
        Options[AntiFlood] = dini_Int(file,"AntiFlood");
        Options[AntiSpam] = dini_Int(file,"AntiSpam");
		Options[AutoLogin] = dini_Int(file,"AutoLogin");
		Options[MaxVotesForKick] = dini_Int(file,"MaxVotesForKick");
		Options[MaxVotesForBan] = dini_Int(file,"MaxVotesForBan");
		Options[MaxVotesForCcars] = dini_Int(file,"MaxVotesForCcars");
		Options[AntiSwear] = dini_Int(file,"AntiSwear");
		Options[AntiForbiddenPartOfName] = dini_Int(file,"AntiForbiddenPartOfName");
        Options[ConnectMessages] = dini_Int(file,"ConnectMessages");
        Options[AFKSystem] = dini_Int(file,"AFKSystem");
        Options[AdminColor] = dini_Int(file,"AdminColor");
        Options[AutomaticAdminColor] = dini_Int(file,"AutomaticAdminColor");
		Options[MaxAdminLevel] = dini_Int(file,"MaxAdminLevel");
		Options[MaxVipLevel] = dini_Int(file,"MaxVipLevel");
        Options[MustRegister] = dini_Int(file,"MustRegister");
        Options[MustLogin] = dini_Int(file,"MustLogin");
        Options[MaxPing] = dini_Int(file,"MaxPing");
        Options[AntiCmdFlood] = dini_Int(file,"AntiCmdFlood");
        Options[MaxPingWarnings] = dini_Int(file,"MaxPingWarnings");
		Options[MaxMuteWarnings] = dini_Int(file,"MaxMuteWarnings");
		Options[MaxSpamWarnings] = dini_Int(file,"MaxSpamWarnings");
		Options[MaxFloodTimes] = dini_Int(file,"MaxFloodTimes");
		Options[MaxFloodSeconds] = dini_Int(file,"MaxFloodSeconds");
		Options[MaxCFloodSeconds] = dini_Int(file,"MaxCFloodSeconds");
		Options[MaxWarnings] = dini_Int(file,"MaxWarnings");
		Options[MaxBanWarnings] = dini_Int(file,"MaxBanWarnings");
		Options[AntiDriveBy] = dini_Int(file,"AntiDriveBy");
		Options[AntiHeliKill] = dini_Int(file,"AntiHeliKill");
		Options[AntiCapsLock] = dini_Int(file,"AntiCapsLock");
		Options[ServerWeather] = dini_Int(file,"ServerWeather");SetWeather(Options[ServerWeather]);
		CmdsOptions[EnableCommands] = dini_Int(file,"EnableCommands");
		CmdsOptions[Anticheat] = dini_Int(file,"Anticheat");
		CmdsOptions[SetOptions] = dini_Int(file,"SetOptions");}
		
    format(file,sizeof(file),AnticheatConfigFile);
	if(dini_Exists(file)){
        Options[MaxMoney] = dini_Int(file,"MaxMoney");
        Options[MaxHealth] = dini_Int(file,"MaxHealth");
        Options[MaxArmour] = dini_Int(file,"MaxArmour");
		Options[AntiJetpack] = dini_Int(file,"AntiJetpack");
		Options[AntiMinigun] = dini_Int(file,"AntiMinigun");
		Options[AntiRPG] = dini_Int(file,"AntiRPG");
		Options[AntiBazooka] = dini_Int(file,"AntiBazooka");
		Options[AntiFlameThrower] = dini_Int(file,"AntiFlameThrower");
		Options[AntiMolotovs] = dini_Int(file,"AntiMolotovs");
		Options[AntiGrenades] = dini_Int(file,"AntiGrenades");
		Options[AntiTearGas] = dini_Int(file,"AntiTearGas");
		Options[AntiSachetChargers] = dini_Int(file,"AntiSachetChargers");
		Options[AntiDetonator] = dini_Int(file,"AntiDetonator");
		Options[AntiShotgun] = dini_Int(file,"AntiShotgun");
		Options[AntiSawnoffShotgun] = dini_Int(file,"AntiSawnoffShotgun");
		Options[AntiCombatShotgun] = dini_Int(file,"AntiCombatShotgun");
		Options[AntiRifle] = dini_Int(file,"AntiRifle");
		Options[AntiRifleSniper] = dini_Int(file,"AntiRifleSniper");
		Options[AntiSprayPaint] = dini_Int(file,"AntiSprayPaint");
		Options[AntiFireExtinguer] = dini_Int(file,"AntiFireExtinguer");}
		
    format(file,sizeof(file),CmdsLevelsFile);
	if(dini_Exists(file)){
        CmdsOptions[SaveSkin] = dini_Int(file,"SaveSkin");
        CmdsOptions[Veh] = dini_Int(file,"Veh");
        CmdsOptions[GiveCar] = dini_Int(file,"GiveCar");
        CmdsOptions[GetVHealth] = dini_Int(file,"GetVHealth");
        CmdsOptions[SetVHealth] = dini_Int(file,"SetVHealth");
        CmdsOptions[GetIp] = dini_Int(file,"GetIp");
		CmdsOptions[Mute] = dini_Int(file,"Mute");
		CmdsOptions[UnMute] = dini_Int(file,"UnMute");
		CmdsOptions[Spec] = dini_Int(file,"Spec");
		CmdsOptions[SpecOff] = dini_Int(file,"SpecOff");
		CmdsOptions[Heal] = dini_Int(file,"Heal");
		CmdsOptions[Jetpack] = dini_Int(file,"Jetpack");
		CmdsOptions[Armour] = dini_Int(file,"Armour");
		CmdsOptions[kick] = dini_Int(file,"Kick");
		CmdsOptions[ban] = dini_Int(file,"Ban");
		CmdsOptions[Fix] = dini_Int(file,"Fix");
		CmdsOptions[Flip] = dini_Int(file,"Flip");
		CmdsOptions[Jail] = dini_Int(file,"Jail");
		CmdsOptions[UnJail] = dini_Int(file,"UnJail");
		CmdsOptions[GiveMoney] = dini_Int(file,"GiveMoney");
		CmdsOptions[Reset] = dini_Int(file,"Reset");
		CmdsOptions[Freeze] = dini_Int(file,"Freeze");
		CmdsOptions[UnFreeze] = dini_Int(file,"UnFreeze");
		CmdsOptions[Die] = dini_Int(file,"Die");
		CmdsOptions[Slap] = dini_Int(file,"Slap");
		CmdsOptions[Goto] = dini_Int(file,"Goto");
		CmdsOptions[Get] = dini_Int(file,"Get");
		CmdsOptions[VGoto] = dini_Int(file,"VGoto");
		CmdsOptions[VGet] = dini_Int(file,"VGet");
		CmdsOptions[TelePlayer] = dini_Int(file,"TelePlayer");
		CmdsOptions[Explode] = dini_Int(file,"Explode");
		CmdsOptions[Setscore] = dini_Int(file,"Setscore");
		CmdsOptions[Setskin] = dini_Int(file,"Setskin");
		CmdsOptions[SetskinToMe] = dini_Int(file,"SetskinToMe");
		CmdsOptions[Setweather] = dini_Int(file,"SetWeather");
		CmdsOptions[Setplayerweather] = dini_Int(file,"SetPlayerWeather");
		CmdsOptions[Settime] = dini_Int(file,"SetTime");
		CmdsOptions[Setplayertime] = dini_Int(file,"SetPlayerTime");
		CmdsOptions[PlayerData2] = dini_Int(file,"PlayerData2");
		CmdsOptions[ClearChat] = dini_Int(file,"ClearChat");
		CmdsOptions[Gmx] = dini_Int(file,"Gmx");
		CmdsOptions[Ccars] = dini_Int(file,"Ccars");
		CmdsOptions[TempAdmin] = dini_Int(file,"TempAdmin");
		CmdsOptions[MakeAdmin] = dini_Int(file,"MakeAdmin");
		CmdsOptions[MakeVip] = dini_Int(file,"MakeVip");
		CmdsOptions[RemoveVip] = dini_Int(file,"RemoveVip");
		CmdsOptions[Weapon] = dini_Int(file,"Weapon");
		CmdsOptions[Count2] = dini_Int(file,"Count");
		CmdsOptions[Setplayerinterior] = dini_Int(file,"SetPlayerInterior");
		CmdsOptions[God] = dini_Int(file,"God");
		CmdsOptions[SGod] = dini_Int(file,"SGod");
		CmdsOptions[ChangeName] = dini_Int(file,"ChangeName");
		CmdsOptions[Warn] = dini_Int(file,"Warn");
		CmdsOptions[Lock] = dini_Int(file,"Lock");
		CmdsOptions[UnLock] = dini_Int(file,"UnLock");
		CmdsOptions[CarColor] = dini_Int(file,"CarColor");
		CmdsOptions[Crash] = dini_Int(file,"Crash");
		CmdsOptions[Burn] = dini_Int(file,"Burn");
		CmdsOptions[Disarm] = dini_Int(file,"Disarm");
		CmdsOptions[RemoveWeapon] = dini_Int(file,"RemoveWeapon");
		CmdsOptions[SetName] = dini_Int(file,"SetName");
		CmdsOptions[Eject] = dini_Int(file,"Eject");
		CmdsOptions[ResetWarnings] = dini_Int(file,"ResetWarnings");
		CmdsOptions[Setgravity] = dini_Int(file,"SetGravity");
		CmdsOptions[AChat] = dini_Int(file,"AChat");
		CmdsOptions[Announce] = dini_Int(file,"Announce");
		CmdsOptions[ForbidWord] = dini_Int(file,"ForbidWord");}

    ForbiddenWordCount=0;
    new File:F = fopen(ForbiddenWordsFile,io_read);
	while(fread(F,string)){
		for(new i=0, j=strlen(string); i<j; i++) if(string[i]=='\n'||string[i]=='\r') string[i]='\0';
        ForbiddenWords[ForbiddenWordCount] = string;
        ForbiddenWordCount++;}
	fclose(F);
	#if defined show_zadmin_log_events
	print("Zadmin: Updated Config.");
	#endif
	return 1;}
//----------------------------------------------------------------------------//
public OpeningFS(){
  ServerOK=true;
  return 1;}
//----------------------------------------------------------------------------//
public StopVoteKickPlayer(playerid){
  Account[playerid][pVotesForKick]=0;
  PlayerInVotekick[playerid]=false;
  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
    MyVoteK[i][playerid]=false;}
  GetPlayerName(playerid,incriminato,sizeof(incriminato));
  format(str, sizeof(str), LanguageText[391], incriminato);
  SendClientMessageToAll(COLOR_YELLOW, str);
  printf("Zadmin: %s",str);
  return 1;}
//----------------------------------------------------------------------------//
public StopVoteBanPlayer(playerid){
  Account[playerid][pVotesForBan]=0;
  PlayerInVoteban[playerid]=false;
  IsVoteBanStarted[playerid]=false;
  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
    MyVoteB[i][playerid]=false;}
  GetPlayerName(playerid,incriminato,sizeof(incriminato));
  format(str, sizeof(str), LanguageText[392], incriminato);
  SendClientMessageToAll(COLOR_YELLOW, str);
  printf("Zadmin: %s",str);
  return 1;}
//----------------------------------------------------------------------------//
public StopVoteCcars(){
  for(new i=0;i<MAX_SERVER_PLAYERS;i++){
    MyVoteC[i]=false;}
  VoteCcarsActive=false;
  SendClientMessageToAll(COLOR_YELLOW, LanguageText[393]);
  print(LanguageText[393]);
  return 1;}
//----------------------------------------------------------------------------//
public FloodTimer(playerid){
  Account[playerid][pFlood]=false;
  return 1;}
//----------------------------------------------------------------------------//
public CFloodTimer(playerid){
  Account[playerid][pCFlood]=false;
  return 1;}
//----------------------------------------------------------------------------//
public CountReady(){
  CountActive=false;
  return 1;}
//----------------------------------------------------------------------------//
public CountTimer(){
  new mstr[MAX_SERVER_STRING],counttimer;
  if(Count3>0){
	for(new i=0;i<MAX_SERVER_PLAYERS;i++)if(GetPlayerVirtualWorld(i)==pWorld){
      PlayerPlaySound(i,1056,0.0,0.0,0.0);}
    Count3--;
	format(mstr,sizeof(mstr),"~r~%d", Count3);
	GameTextForAll(mstr,1000,3);
	counttimer=SetTimer("CountTimer",1000,0);}
  if(Count3==0){
    for(new i=0;i<MAX_SERVER_PLAYERS;i++)if(GetPlayerVirtualWorld(i)==pWorld){
      PlayerPlaySound(i,1057,0.0,0.0,0.0);}
    GameTextForAll(LanguageText[394],1000,3);
	KillTimer(counttimer);
	Count3=5;}
  return 1;}

public UnMutePlayerTimer(playerid){
  GetPlayerName(playerid, incriminato, sizeof(incriminato));
  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,incriminato);
  format(str, sizeof(str), LanguageText[395], incriminato);
  SendClientMessageToAll(COLOR_YELLOW, str);
  GameTextForPlayer(playerid,LanguageText[205],5000,3);
  Account[playerid][pMuted]=false;
  Account[playerid][pMuteWarnings]=0;
  dini_IntSet(file,"muted",0);
  return 1;}
  
public UnJailPlayerTimer(playerid){
  GetPlayerName(playerid, incriminato, sizeof(incriminato));
  new file[MAX_SERVER_STRING];format(file,sizeof(file),UsersFile,incriminato);
  format(str, sizeof(str), LanguageText[396], incriminato);
  SendClientMessageToAll(COLOR_YELLOW, str);
  GameTextForPlayer(playerid,LanguageText[413],5000,3);
  Account[playerid][pJailed]=false;
  dini_IntSet(file,"jailed",0);
  return 1;}

/*******************************************************************************
*                           <=[Anticheat Timers]=>                             *
*******************************************************************************/

public AntiHealthHack(){
	for(new i=0;i<MAX_SERVER_PLAYERS;i++){
      if(IsPlayerConnected(i)){
        #if defined ANTI_HEALTH
        new Float:health;
	    GetPlayerHealth(i,health);
	    GetPlayerName(i, name, sizeof(name));
        if(Spawned[i]==true){
		  if(GodActive[i]==false){
            if(health>Options[MaxHealth]){
              KickPlayer(i,"Health Hack");}}}
        #endif

        #if defined ANTI_HEALTH
	    new Float:armour;
        GetPlayerArmour(i,Float:armour);
        if(Spawned[i]==true){
          if(GodActive[i]==false){
		    if(armour>Options[MaxArmour]){
              KickPlayer(i,"Armour Hack");}}}
        #endif

        #if defined ANTI_VEH_HEALTH
	    new Float:vehhealth;
        if(Spawned[i]==true){
            GetVehicleHealth(GetPlayerVehicleID(i),Float:vehhealth);
			if(vehhealth>1000){
              KickPlayer(i,"Vehicle Health Hack");}}
		#endif

		#if defined ANTI_MONEY
	    new Float:money;
		if(IsPlayerConnected(i)){
          if(Spawned[i]==true){
            money=GetPlayerMoney(i);
			if(money>Options[MaxMoney]){
              KickPlayer(i,"Money Hack");}}}
		#endif
		}}
	return 1;}

public AntiHighPing(){
   #if defined ANTI_PING
	for(new i=0; i<MAX_SERVER_PLAYERS; i++){
		if(IsPlayerConnected(i)){
          GetPlayerName(i, pname, sizeof(pname));
          if(Spawned[i]==true){
          if(ServerOK==true){
			if(GetPlayerPing(i) > Options[MaxPing])if(!IsPlayerNPC(i)){
			  if(Account[i][pPingWarnings]<Options[MaxPingWarnings]){
                  Account[i][pPingWarnings]++;
			      format(string,sizeof(string),LanguageText[397], pname, GetPlayerPing(i), Options[MaxPing], Account[i][pPingWarnings], Options[MaxPingWarnings]);
		  	      SendClientMessageToAll(COLOR_YELLOW,string);}
              if(Account[i][pPingWarnings]==Options[MaxPingWarnings]){
			      Account[i][pPingWarnings]=0;
			      format(string,sizeof(string),LanguageText[398], pname, Options[MaxPing]);
		  	      SendClientMessageToAll(COLOR_YELLOW,string);print(string);GameTextForPlayer(i,LanguageText[399],10000,3);
		          Kick(i);}}}}}}
	#endif
	return 1;}
//----------------------------------------------------------------------------//
public AntiWeaponsHack(){
    #if defined ANTI_WEAPONS
	for(new i = 0; i < MAX_SERVER_PLAYERS; i++){
      new weapon=GetPlayerWeapon(i);
      GetPlayerName(i, pname, sizeof(pname));
	  if(IsPlayerConnected(i) && !IsPlayerNPC(i)) if(ServerOK==true){
		if(Spawned[i]==true){
		if(GetPlayerSpecialAction(i)==2){
		  if(Options[AntiJetpack]==1){
			KickPlayer(i,"Jetpack Hack");}}
		switch(weapon){
		  case MINIGUN:{
			if(Options[AntiMinigun]==1){
			  KickPlayer(i,"Minigun Hack");}}
          case FLAME_THROWER:{
            if(Options[AntiFlameThrower]==1){
			  KickPlayer(i,"Flame Thrower Hack");}}
          case MOLOTOVS:{
            if(Options[AntiMolotovs]==1){
			  KickPlayer(i,"Molotovs Hack");}}
          case GRENADES:{
            if(Options[AntiGrenades]==1){
              KickPlayer(i,"Grenades Hack");}}
          case TEAR_GAS:{
            if(Options[AntiTearGas]==1){
			  KickPlayer(i,"Tear Gas Hack");}}
          case RPG:{
            if(Options[AntiRPG]==1){
			  KickPlayer(i,"RPG Hack");}}
          case ROCKET_LAUNCHER:{
            if(Options[AntiBazooka]==1){
			  KickPlayer(i,"Rocket Launcher Hack");}}
          case SACHET_CHARGERS:{
            if(Options[AntiSachetChargers]==1){
			  KickPlayer(i,"Sachet Chargers Hack");}}
          case DETONATOR:{
            if(Options[AntiDetonator]==1){
			  KickPlayer(i,"Detonator Hack");}}
          case SHOTGUN:{
            if(Options[AntiShotgun]==1){
			  KickPlayer(i,"Shotgun Hack");}}
          case SAWNOFF_SHOTGUN:{
            if(Options[AntiSawnoffShotgun]==1){
			  KickPlayer(i,"Sawnoff Shotgun Hack");}}
          case COMBAT_SHOTGUN:{
            if(Options[AntiCombatShotgun]==1){
			  KickPlayer(i,"Combat Shotgun Hack");}}
          case RIFLE:{
            if(Options[AntiRifle]==1){
			  KickPlayer(i,"Rifle Hack");}}
          case SNIPER_RIFLE:{
            if(Options[AntiRifleSniper]==1){
              KickPlayer(i,"Rifle Sniper Hack");}}
          case SPRAY_PAINT:{
            if(Options[AntiSprayPaint]==1){
              KickPlayer(i,"Spray Paint Hack");}}
          case FIRE_EXTINGUER:{
            if(Options[AntiFireExtinguer]==1){
              KickPlayer(i,"Fire Extinguer Hack");}}}}}}
	 #endif
	 return 1;}
	 
stock KickPlayer(playerid,reason[]){
    GetPlayerName(playerid, name, sizeof(name));
    format(string,sizeof(string),LanguageText[400], name,reason);
	GameTextForPlayer(playerid,string,10000,3);
	format(string,sizeof(string),LanguageText[401], reason);
	SendClientMessage(playerid,COLOR_YELLOW,string);
    Kick(playerid);
	format(string,sizeof(string),LanguageText[402], name,reason);
	SendClientMessageToAll(COLOR_YELLOW,string);}

/*******************************************************************************
*                                   <=[EOF]=>                                  *
*******************************************************************************/
