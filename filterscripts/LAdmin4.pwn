#include <a_samp>
#include <lethaldudb2>
#include <ARAC_FS>

#undef MAX_PLAYERS
const MAX_PLAYERS=501;

#pragma dynamic 145000

/*
|===============================================|
|		--== LethaL Adminscript ==--            |
|	        -==  Version 4  ==--                |
|  --== Translation and updating by Alien ==-	|
|===============================================|
*/

//-----------------------------------------------------------------------------------//

//#define USE_MENUS       	// Comment to remove all menus.  Uncomment to enable menus
//#define DISPLAY_CONFIG 	// displays configuration in console window on filterscript load
//#define SAVE_LOGS           // Comment if your server runs linux (logs wont be saved)
#define ENABLE_SPEC         // Comment if you are using a spectate system already
#define USE_STATS           // Comment to disable /stats
//#define ANTI_MINIGUN        // Displays who has a minigun
//#define USE_AREGISTER       // Changes /register, /login etc to  /areister, /alogin etc
//#define HIDE_ADMINS 		// Displays number of admins online instead of level and names
#define ENABLE_FAKE_CMDS   	// Comment to disable /fakechat, /fakedeath, /fakecmd commanads

//-----------------------------------------------------------------------------------//

#define MAX_WARNINGS 3      // /warn command

#define MAX_REPORTS 7
#define MAX_CHAT_LINES 7

#define SPAM_MAX_MSGS 5
#define SPAM_TIMELIMIT 15 // SECONDS

#define PING_MAX_EXCEEDS 4
#define PING_TIMELIMIT 60 // SECONDS

#define MAX_FAIL_LOGINS 4

new TimeToLogin[MAX_PLAYERS];

forward PlayerKick(playerid);
public PlayerKick(playerid)
{
	Kick(playerid);
}
#define Kick(%0) SetTimerEx("PlayerKick",1000,false,"i",%0)
forward PlayerBan(playerid);
public PlayerBan(playerid)
{
	Ban(playerid);
}
#define Ban(%0) SetTimerEx("PlayerBan",1000,false,"i",%0)

// Admin Area
new AdminArea[6] = {
	377, 	// X
	170, 	// Y
	1008, 	// Z
	90,     // Angle
	3,      // Interior
	0		// Virtual World
};

//-=Main colours=-
#define blue 0x375FFFFF
#define red 0xFF0000AA

#define COLOR_GREEN 0x33AA33AA
#define green 0x33FF33AA
#define yellow 0xFFFF00AA
#define grey 0xC0C0C0AA
#define blue1 0x2641FEAA
#define lightblue 0x33CCFFAA
#define orange 0xFF9900AA
#define black 0x2C2727AA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_PURPLE 0x800080AA
#define COLOR_BLACK 0x000000AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_GREEN1 0x33AA33AA
#define COLOR_BROWN 0xA52A2AAA
#define COLOR_VIOLET 0x54137DFF
#define COLOR_RED 0xFF6347AA

#define fixchars(%1) for(new charfixloop=0;charfixloop<strlen(%1);charfixloop++)if(%1[charfixloop]<0)%1[charfixloop]+=256
// DCMD
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

// Caps
#define UpperToLower(%1) for ( new ToLowerChar; ToLowerChar < strlen( %1 ); ToLowerChar ++ ) if ( %1[ ToLowerChar ]> 64 && %1[ ToLowerChar ] < 91 ) %1[ ToLowerChar ] += 32

// Spec
#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2

// Enums
enum PlayerData
{
	Registered,
	LoggedIn,
	Level,
	Muted,
	Caps,
	Jailed,
	JailTime,
	Frozen,
	FreezeTime,
	Kills,
	Deaths,
	MuteWarnings,
	Warnings,
	Spawned,
	TimesSpawned,
	God,
	GodCar,
	DoorsLocked,
	Invis,
	SpamCount,
	SpamTime,
	PingCount,
	PingTime,
	BotPing,
	pPing[PING_MAX_EXCEEDS],
	blip,
	blipS,
	pColour,
	pCar,
	SpecID,
	SpecType,
bool:AllowedIn,
	FailLogin,
};
new PlayerInfo[MAX_PLAYERS][PlayerData];

enum ServerData
{
	MaxPing,
	ReadPMs,
	ReadCmds,
	MaxAdminLevel,
	AdminOnlySkins,
	AdminSkin,
	AdminSkin2,
	NameKick,
	PartNameKick,
	AntiBot,
	AntiSpam,
	AntiSwear,
	NoCaps,
	Locked,
	Password[128],
	GiveWeap,
	GiveMoney,
	ConnectMessages,
	AdminCmdMsg,
	AutoLogin,
	MaxMuteWarnings,
	DisableChat,
	MustLogin,
};
new ServerInfo[ServerData];

new Float:Pos[MAX_PLAYERS][4];

// rcon
new Chat[MAX_CHAT_LINES][128];

//Timers
new InvisTimer;
new GodTimer;
new BlipTimer[MAX_PLAYERS];
new JailTimer[MAX_PLAYERS];
new FreezeTimer[MAX_PLAYERS];
new LockKickTimer[MAX_PLAYERS];

// Menus
#if defined USE_MENUS
new Menu:LMainMenu, Menu:AdminEnable, Menu:AdminDisable,
Menu:LVehicles, Menu:twodoor, Menu:fourdoor, Menu:fastcar, Menu:Othercars,
Menu:bikes, Menu:boats, Menu:planes, Menu:helicopters,
Menu:XWeapons, Menu:XWeaponsBig, Menu:XWeaponsSmall, Menu:XWeaponsMore,
Menu:LWeather,Menu:LTime,
Menu:LTuneMenu, Menu:PaintMenu, Menu:LCars, Menu:LCars2,
Menu:LTele, Menu:LasVenturasMenu, Menu:LosSantosMenu, Menu:SanFierroMenu,
Menu:DesertMenu, Menu:FlintMenu, Menu:MountChiliadMenu,	Menu:InteriorsMenu;
#endif

// Forbidden Names & Words
new BadNames[100][100], // Whole Names
BadNameCount = 0,
BadPartNames[100][100], // Part of name
BadPartNameCount = 0,
ForbiddenWords[100][100],
ForbiddenWordCount = 0;

// Report
new Reports[MAX_REPORTS][128];

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
	"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
	"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A","Luggage Trailer B",
	"Stair Trailer","Boxville","Farm Plow","Utility Trailer" };

//==============================================================================

public OnFilterScriptInit()
{
	print("\n________________________________________");
	print("________________________________________");
	print("           LAdmin Loading...            ");
	print("________________________________________");

	if(!fexist("ladmin/"))
	{
		print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
		SetTimerEx("PrintWarning",2500,0,"s","ladmin");
		return 1;
	}
	if(!fexist("ladmin/logs/"))
	{
		print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
		SetTimerEx("PrintWarning",2500,0,"s","ladmin/logs");
		return 1;
	}
	if(!fexist("ladmin/config/"))
	{
		print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
		SetTimerEx("PrintWarning",2500,0,"s","ladmin/config");
		return 1;
	}
	if(!fexist("ladmin/users/"))
	{
		print("\n\n > WARNING: Folder Missing From Scriptfiles\n");
		SetTimerEx("PrintWarning",2500,0,"s","ladmin/users");
		return 1;
	}

	UpdateConfig();

	#if defined DISPLAY_CONFIG
	ConfigInConsole();
	#endif

	//===================== [ The Menus ]===========================//
	#if defined USE_MENUS

	LMainMenu = CreateMenu("FLABHOE MEHU", 2,  55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(LMainMenu, 0, "BS6EPNTE OZQNU:");
	AddMenuItem(LMainMenu, 0, "BKLU4NTJ");
	AddMenuItem(LMainMenu, 0, "BSKLU4NTJ");
	AddMenuItem(LMainMenu, 0, "ZOFODA");
	AddMenuItem(LMainMenu, 0, "BPEMR");
	AddMenuItem(LMainMenu, 0, "BCE TA4KN");
	AddMenuItem(LMainMenu, 0, "BNZ-TA4KN");
	AddMenuItem(LMainMenu, 0, "TUHNHF");
	AddMenuItem(LMainMenu, 0, "OPYGNR");
	AddMenuItem(LMainMenu, 0, "TELEZOPT");
	AddMenuItem(LMainMenu, 0, "BSXOD");//

	AdminEnable = CreateMenu("~b~MEHU",2, 55.0, 200.0, 150.0, 80.0);
	SetMenuColumnHeader(AdminEnable, 0, "BKLU4NTJ:");
	AddMenuItem(AdminEnable, 0, "AHTN-MAT");
	AddMenuItem(AdminEnable, 0, "HNK-KNK");
	AddMenuItem(AdminEnable, 0, "AHTN-CZAM");
	AddMenuItem(AdminEnable, 0, "ZNHF-KNK");
	AddMenuItem(AdminEnable, 0, "4NTATJ KOMAHDS");
	AddMenuItem(AdminEnable, 0, "4NTATJ ZPNBATS");
	AddMenuItem(AdminEnable, 0, "AHTN-KAZC LOK");
	AddMenuItem(AdminEnable, 0, "KOHEKT-COO6WEHNR");
	AddMenuItem(AdminEnable, 0, "4NTATJ ADMNH-KMD");
	AddMenuItem(AdminEnable, 0, "ABTO-LOFNH");
	AddMenuItem(AdminEnable, 0, "HA3AD");

	AdminDisable = CreateMenu("~b~MEHU",2, 55.0, 200.0, 150.0, 80.0);
	SetMenuColumnHeader(AdminDisable, 0, "BSKLU4NTJ:");
	AddMenuItem(AdminDisable, 0, "AHTN-MAT");
	AddMenuItem(AdminDisable, 0, "HNK-KNK");
	AddMenuItem(AdminDisable, 0, "AHTN-CZAM");
	AddMenuItem(AdminDisable, 0, "ZNHF-KNK");
	AddMenuItem(AdminDisable, 0, "4NTATJ KOMAHDS");
	AddMenuItem(AdminDisable, 0, "4NTATJ ZPNBATS");
	AddMenuItem(AdminDisable, 0, "AHTN-KAZC LOK");
	AddMenuItem(AdminDisable, 0, "KOHEKT-COO6WEHNR");
	AddMenuItem(AdminDisable, 0, "4NTATJ ADMNH-KMD");
	AddMenuItem(AdminDisable, 0, "ABTO-LOFNH");
	AddMenuItem(AdminDisable, 0, "HA3AD");

	LWeather = CreateMenu("~b~MEHU",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(LWeather, 0, "BS6EPNTE ZOFODY:");
	AddMenuItem(LWeather, 0, "COLHE4HAR");
	AddMenuItem(LWeather, 0, "ZECO4HSN WTOPM");
	AddMenuItem(LWeather, 0, "FPO3A");
	AddMenuItem(LWeather, 0, "TYMAH");
	AddMenuItem(LWeather, 0, "O6LA4HAR");
	AddMenuItem(LWeather, 0, "CNLJHSN DOGDJ");
	AddMenuItem(LWeather, 0, "ZYPZYPHOE HE6O");
	AddMenuItem(LWeather, 0, "4EPHOE/6ELOE HE6O");
	AddMenuItem(LWeather, 0, "TEMHO-3ELEHOE HE6O");
	AddMenuItem(LWeather, 0, "GAPA");
	AddMenuItem(LWeather,0,"HA3AD");

	LTime = CreateMenu("~b~MEHU", 2,  55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(LTime, 0, "BS6EPNTE BPEMR:");
	AddMenuItem(LTime, 0, "YTPO");
	AddMenuItem(LTime, 0, "ZOLDEHJ");
	AddMenuItem(LTime, 0, "ZOLDNK");
	AddMenuItem(LTime, 0, "BE4EP");
	AddMenuItem(LTime, 0, "HO4J");
	AddMenuItem(LTime, 0, "HA3AD");

	LCars = CreateMenu("~b~MENU", 2,  55.0, 150.0, 100.0, 80.0);
	SetMenuColumnHeader(LCars, 0, "BS6EPNTE MAWNHY:");
	AddMenuItem(LCars, 0, "TYPU3MO");
	AddMenuItem(LCars, 0, "6AHDUTO");
	AddMenuItem(LCars, 0, "BOPTEKC");
	AddMenuItem(LCars, 0, "HPF");
	AddMenuItem(LCars, 0, "C.B.A.T");
	AddMenuItem(LCars, 0, "XUHTEP");
	AddMenuItem(LCars, 0, "LGETMAKC(LODKA)");
	AddMenuItem(LCars, 0, "TAHK");
	AddMenuItem(LCars, 0, "MOHCTP");
	AddMenuItem(LCars, 0, "Sea Sparrow");
	AddMenuItem(LCars, 0, "DALEE");
	AddMenuItem(LCars, 0, "HA3AD");

	LCars2 = CreateMenu("~b~MEHU", 2,  55.0, 150.0, 100.0, 80.0);
	SetMenuColumnHeader(LCars2, 0, "BS6EPNTE MAWNHY:");
	AddMenuItem(LCars2, 0, "DAMZEP");
	AddMenuItem(LCars2, 0, "NFP. TAHK");
	AddMenuItem(LCars2, 0, "NFP. 6AHDNT");
	AddMenuItem(LCars2, 0, "NFP. 6APOH");
	AddMenuItem(LCars2, 0, "NFP. FO6LNH");
	AddMenuItem(LCars2, 0, "NFP. PENDEP");
	AddMenuItem(LCars2, 0, "NFP. FOPWOK");
	AddMenuItem(LCars2, 0, "TPAMBAN");
	AddMenuItem(LCars2, 0, "HA3AD");

	LTuneMenu = CreateMenu("~b~MEHU",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(LTuneMenu, 0, "BS6EPNTE KOMZOHEHT:");
	AddMenuItem(LTuneMenu,0,"A3OT");
	AddMenuItem(LTuneMenu,0,"FNDPABLNKA");
	AddMenuItem(LTuneMenu,0,"ZPOB. KOLECA");
	AddMenuItem(LTuneMenu,0,"N3F. KOLECA");
	AddMenuItem(LTuneMenu,0,"DOCT. KOLECA");
	AddMenuItem(LTuneMenu,0,"MEFA KOLECA");
	AddMenuItem(LTuneMenu,0,"NMZOPT KOLECA");
	AddMenuItem(LTuneMenu,0,"ABTOM. KOLECA");
	AddMenuItem(LTuneMenu,0,"BE3DEXOD. KOLECA");
	AddMenuItem(LTuneMenu,0,"KLACCNK KOLECA");
	AddMenuItem(LTuneMenu,0,"KPACKA");
	AddMenuItem(LTuneMenu,0,"HA3AD");

	PaintMenu = CreateMenu("~b~MEHU",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(PaintMenu, 0, "BA6EPNTE KPACKY:");
	AddMenuItem(PaintMenu,0,"KPACKA 1");
	AddMenuItem(PaintMenu,0,"KPACKA 2");
	AddMenuItem(PaintMenu,0,"KPACKA 3");
	AddMenuItem(PaintMenu,0,"KPACKA 4");
	AddMenuItem(PaintMenu,0,"KPACKA 5");
	AddMenuItem(PaintMenu,0,"4EPHSN");
	AddMenuItem(PaintMenu,0,"6ELSN");
	AddMenuItem(PaintMenu,0,"CNHNN");
	AddMenuItem(PaintMenu,0,"PO3OBSN");
	AddMenuItem(PaintMenu,0,"HA3AD");

	LVehicles = CreateMenu("~b~MEHU",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(LVehicles, 0, "BS6EPNTE KATEFOPNU:");
	AddMenuItem(LVehicles,0,"2-DBEPHSE");
	AddMenuItem(LVehicles,0,"4-DBEPHSE");
	AddMenuItem(LVehicles,0,"FOHO4HSE");
	AddMenuItem(LVehicles,0,"OCTALJHSE");
	AddMenuItem(LVehicles,0,"MOTS");
	AddMenuItem(LVehicles,0,"LODKN");
	AddMenuItem(LVehicles,0,"CAMOLETS");
	AddMenuItem(LVehicles,0,"BEPTOLETS");
	AddMenuItem(LVehicles,0,"HA3AD");

	twodoor = CreateMenu("~b~2-DBEPHSE",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(twodoor, 0, "BS6EPNTE MAWNHY:");
	AddMenuItem(twodoor,0,"Feltzer");//533
	AddMenuItem(twodoor,0,"Stallion");//139
	AddMenuItem(twodoor,0,"Windsor");//555
	AddMenuItem(twodoor,0,"Bobcat");//422
	AddMenuItem(twodoor,0,"Yosemite");//554
	AddMenuItem(twodoor,0,"Broadway");//575
	AddMenuItem(twodoor,0,"Blade");//536
	AddMenuItem(twodoor,0,"Slamvan");//535
	AddMenuItem(twodoor,0,"Tornado");//576
	AddMenuItem(twodoor,0,"Bravura");//401
	AddMenuItem(twodoor,0,"Fortune");//526
	AddMenuItem(twodoor,0,"HA3AD");

	fourdoor = CreateMenu("~b~4-DBEPHSE",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(fourdoor, 0, "BS6EPNTE MAWNHY:");
	AddMenuItem(fourdoor,0,"Perenniel");//404
	AddMenuItem(fourdoor,0,"Tahoma");//566
	AddMenuItem(fourdoor,0,"Voodoo");//412
	AddMenuItem(fourdoor,0,"Admiral");//445
	AddMenuItem(fourdoor,0,"Elegant");//507
	AddMenuItem(fourdoor,0,"Glendale");//466
	AddMenuItem(fourdoor,0,"Intruder");//546
	AddMenuItem(fourdoor,0,"Merit");//551
	AddMenuItem(fourdoor,0,"Oceanic");//467
	AddMenuItem(fourdoor,0,"Premier");//426
	AddMenuItem(fourdoor,0,"Sentinel");//405
	AddMenuItem(fourdoor,0,"HA3AD");

	fastcar = CreateMenu("~b~FOHO4HSE",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(fastcar, 0, "BS6EPNTE MAWNHY:");
	AddMenuItem(fastcar,0,"Comet");//480
	AddMenuItem(fastcar,0,"Buffalo");//402
	AddMenuItem(fastcar,0,"Cheetah");//415
	AddMenuItem(fastcar,0,"Euros");//587
	AddMenuItem(fastcar,0,"Hotring Racer");//494
	AddMenuItem(fastcar,0,"Infernus");//411
	AddMenuItem(fastcar,0,"Phoenix");//603
	AddMenuItem(fastcar,0,"Super GT");//506
	AddMenuItem(fastcar,0,"Turismo");//451
	AddMenuItem(fastcar,0,"ZR-350");//477
	AddMenuItem(fastcar,0,"Bullet");//541
	AddMenuItem(fastcar,0,"HA3AD");

	Othercars = CreateMenu("~b~OCTALJHSE",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(Othercars, 0, "BS6EPNTE MAWNHY:");
	AddMenuItem(Othercars,0,"MOHCTP");//556
	AddMenuItem(Othercars,0,"MYCOPKA");//408
	AddMenuItem(Othercars,0,"ABT6YC-PA6O4NN");//431
	AddMenuItem(Othercars,0,"ABT6UC-TYP");//437
	AddMenuItem(Othercars,0,"ZOLNQENCKNN FP.");//427
	AddMenuItem(Othercars,0,"TAHK");//432
	AddMenuItem(Othercars,0,"C.B.A.T.");//601
	AddMenuItem(Othercars,0,"6ETOHOMEWALKA");//524
	AddMenuItem(Othercars,0,"FPY3OBNK");//455
	AddMenuItem(Othercars,0,"6V");//424
	AddMenuItem(Othercars,0,"DUH");//573
	AddMenuItem(Othercars,0,"HA3AD");

	bikes = CreateMenu("~b~MOTS",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(bikes, 0, "BS6EPNTE MOT:");
	AddMenuItem(bikes,0,"BF-400");
	AddMenuItem(bikes,0,"BMX");
	AddMenuItem(bikes,0,"Faggio");
	AddMenuItem(bikes,0,"FCR-900");
	AddMenuItem(bikes,0,"Freeway");
	AddMenuItem(bikes,0,"NRG-500");
	AddMenuItem(bikes,0,"PCJ-600");
	AddMenuItem(bikes,0,"Pizzaboy");
	AddMenuItem(bikes,0,"Quad");
	AddMenuItem(bikes,0,"Sanchez");
	AddMenuItem(bikes,0,"Wayfarer");
	AddMenuItem(bikes,0,"HA3AD");

	boats = CreateMenu("~b~LODKN",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(boats, 0, "BS6EPNTE LODKY:");
	AddMenuItem(boats,0,"Coastguard");//472
	AddMenuItem(boats,0,"Dingy");//473
	AddMenuItem(boats,0,"Jetmax");//493
	AddMenuItem(boats,0,"Launch");//595
	AddMenuItem(boats,0,"Marquis");//484
	AddMenuItem(boats,0,"Predator");//430
	AddMenuItem(boats,0,"Reefer");//453
	AddMenuItem(boats,0,"Speeder");//452
	AddMenuItem(boats,0,"Squallo");//446
	AddMenuItem(boats,0,"Tropic");//454
	AddMenuItem(boats,0,"HA3AD");

	planes = CreateMenu("~b~CAMOLETS",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(planes, 0, "BS6EPNTE CAMOLET:");
	AddMenuItem(planes,0,"Andromada");//592
	AddMenuItem(planes,0,"AT400");//577
	AddMenuItem(planes,0,"Beagle");//511
	AddMenuItem(planes,0,"Cropduster");//512
	AddMenuItem(planes,0,"Dodo");//593
	AddMenuItem(planes,0,"Hydra");//520
	AddMenuItem(planes,0,"Nevada");//553
	AddMenuItem(planes,0,"Rustler");//476
	AddMenuItem(planes,0,"Shamal");//519
	AddMenuItem(planes,0,"Skimmer");//460
	AddMenuItem(planes,0,"Stuntplane");//513
	AddMenuItem(planes,0,"HA3AD");

	helicopters = CreateMenu("~b~BEPTOLETS",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(helicopters, 0, "BS6EPNTE BEPTOLETS:");
	AddMenuItem(helicopters,0,"Cargobob");//
	AddMenuItem(helicopters,0,"Hunter");//
	AddMenuItem(helicopters,0,"Leviathan");//
	AddMenuItem(helicopters,0,"Maverick");//
	AddMenuItem(helicopters,0,"News Chopper");//
	AddMenuItem(helicopters,0,"Police Maverick");//
	AddMenuItem(helicopters,0,"Raindance");//
	AddMenuItem(helicopters,0,"Seasparrow");//
	AddMenuItem(helicopters,0,"Sparrow");//
	AddMenuItem(helicopters,0,"HA3AD");

	XWeapons = CreateMenu("~b~MENU",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(XWeapons, 0, "BS6EPNTE OPYGNE:");
	AddMenuItem(XWeapons,0,"ZNCTOLET");//0
	AddMenuItem(XWeapons,0,"M4");
	AddMenuItem(XWeapons,0,"A6PS");
	AddMenuItem(XWeapons,0,"DPO6OBNK");
	AddMenuItem(XWeapons,0,"Y3N");
	AddMenuItem(XWeapons,0,"6A3YKA");
	AddMenuItem(XWeapons,0,"MNHNFAH");//6
	AddMenuItem(XWeapons,0,"CHANEPKA");
	AddMenuItem(XWeapons,0,"6NF-OPYGNR");
	AddMenuItem(XWeapons,0,"MNHN-OPYGNR");//9
	AddMenuItem(XWeapons,0,"DALEE");
	AddMenuItem(XWeapons,0,"HA3AD");//11

	XWeaponsBig = CreateMenu("~b~MEHU",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(XWeaponsBig, 0, "BS6EPNTE OPYGNE:");
	AddMenuItem(XWeaponsBig,0,"WOTFAH");
	AddMenuItem(XWeaponsBig,0,"AK-47");
	AddMenuItem(XWeaponsBig,0,"DEPEB. CHANEPKA");
	AddMenuItem(XWeaponsBig,0,"ABTO-6A3YKA");
	AddMenuItem(XWeaponsBig,0,"OFHEMET");
	AddMenuItem(XWeaponsBig,0,"CMF");
	AddMenuItem(XWeaponsBig,0,"TEKN");
	AddMenuItem(XWeaponsBig,0,"HA3AD");

	XWeaponsSmall = CreateMenu("~b~MEHUs",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(XWeaponsBig, 0, "BS6EPNTE OPYGNE:");
	AddMenuItem(XWeaponsSmall,0,"2 ZECTA");
	AddMenuItem(XWeaponsSmall,0,"ZECT C FLYW.");
	AddMenuItem(XWeaponsSmall,0,"MOLOTOBA");
	AddMenuItem(XWeaponsSmall,0,"OFHETYWNTELJ");
	AddMenuItem(XWeaponsSmall,0,"CZPEN");
	AddMenuItem(XWeaponsSmall,0,"FPAHATS");
	AddMenuItem(XWeaponsSmall,0,"KATAHA");
	AddMenuItem(XWeaponsSmall,0,"6EH3OZNLA");
	AddMenuItem(XWeaponsSmall,0,"HA3AD");

	XWeaponsMore = CreateMenu("~b~MEHU",2, 55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(XWeaponsBig, 0, "BS6EPNTE OPYGNE:");
	AddMenuItem(XWeaponsMore,0,"DGETZAT");
	AddMenuItem(XWeaponsMore,0,"HOG");
	AddMenuItem(XWeaponsMore,0,"QBETS");
	AddMenuItem(XWeaponsMore,0,"KANEPA");
	AddMenuItem(XWeaponsMore,0,"KNN");
	AddMenuItem(XWeaponsMore,0,"6NTA");
	AddMenuItem(XWeaponsMore,0,"KLUWKA");
	AddMenuItem(XWeaponsMore,0,"6ECK. ZATPOHS");
	AddMenuItem(XWeaponsMore,0,"HA3AD");

	LTele = CreateMenu("TELEZOPT", 2,  55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(LTele, 0, "KYDA BAC ZOPTHYTJ?");
	AddMenuItem(LTele, 0, "Las Venturas");//0
	AddMenuItem(LTele, 0, "Los Santos");//1
	AddMenuItem(LTele, 0, "San Fierro");//2
	AddMenuItem(LTele, 0, "The Desert");//3
	AddMenuItem(LTele, 0, "Flint Country");//4
	AddMenuItem(LTele, 0, "FOPA Chiliad");//5
	AddMenuItem(LTele, 0, "NHTEPJEPS");//6
	AddMenuItem(LTele, 0, "HA3AD");//8

	LasVenturasMenu = CreateMenu("Las Venturas", 2,  55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(LasVenturasMenu, 0, "KYDA BAC ZOPTHYTJ?");
	AddMenuItem(LasVenturasMenu, 0, "CTPNZ-KLY6");//0
	AddMenuItem(LasVenturasMenu, 0, "Come-A-Lot");//1
	AddMenuItem(LasVenturasMenu, 0, "LB ANPOZOPT");//2
	AddMenuItem(LasVenturasMenu, 0, "KACC Military Fuels");//3
	AddMenuItem(LasVenturasMenu, 0, "Yellow Bell Golf Club");//4
	AddMenuItem(LasVenturasMenu, 0, "Baseball Pitch");//5
	AddMenuItem(LasVenturasMenu, 0, "HA3AD");//6

	LosSantosMenu = CreateMenu("Los Santos", 2,  55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(LosSantosMenu, 0, "KYDA BAC ZOPTHYTJ?");
	AddMenuItem(LosSantosMenu, 0, "Ganton");//0
	AddMenuItem(LosSantosMenu, 0, "LS Airport");//1
	AddMenuItem(LosSantosMenu, 0, "Ocean Docks");//2
	AddMenuItem(LosSantosMenu, 0, "Pershing Square");//3
	AddMenuItem(LosSantosMenu, 0, "Verdant Bluffs");//4
	AddMenuItem(LosSantosMenu, 0, "Santa Maria Beach");//5
	AddMenuItem(LosSantosMenu, 0, "Mulholland");//6
	AddMenuItem(LosSantosMenu, 0, "Richman");//7
	AddMenuItem(LosSantosMenu, 0, "HA3AD");//8

	SanFierroMenu = CreateMenu("San Fierro", 2,  55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(SanFierroMenu, 0, "KYDA BAC ZOPTHYTJ?");
	AddMenuItem(SanFierroMenu, 0, "SF Station");//0
	AddMenuItem(SanFierroMenu, 0, "SF Airport");//1
	AddMenuItem(SanFierroMenu, 0, "Ocean Flats");//2
	AddMenuItem(SanFierroMenu, 0, "Avispa Country Club");//3
	AddMenuItem(SanFierroMenu, 0, "Easter Basin (docks)");//4
	AddMenuItem(SanFierroMenu, 0, "Esplanade North");//5
	AddMenuItem(SanFierroMenu, 0, "Battery Point");//6
	AddMenuItem(SanFierroMenu, 0, "HA3AD");//7

	DesertMenu = CreateMenu("The Desert", 2,  55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(DesertMenu, 0, "KYDA BAC ZOPTHYTJ?");
	AddMenuItem(DesertMenu, 0, "Aircraft Graveyard");//0
	AddMenuItem(DesertMenu, 0, "Area 51");//1
	AddMenuItem(DesertMenu, 0, "The Big Ear");//2
	AddMenuItem(DesertMenu, 0, "The Sherman Dam");//3
	AddMenuItem(DesertMenu, 0, "Las Barrancas");//4
	AddMenuItem(DesertMenu, 0, "El Quebrados");//5
	AddMenuItem(DesertMenu, 0, "Octane Springs");//6
	AddMenuItem(DesertMenu, 0, "HA3AD");//7

	FlintMenu = CreateMenu("Flint Country", 2,  55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(FlintMenu, 0, "KYDA BAC ZOPTHYTJ?");
	AddMenuItem(FlintMenu, 0, "The Lake");//0
	AddMenuItem(FlintMenu, 0, "Leafy Hollow");//1
	AddMenuItem(FlintMenu, 0, "The Farm");//2
	AddMenuItem(FlintMenu, 0, "Shady Cabin");//3
	AddMenuItem(FlintMenu, 0, "Flint Range");//4
	AddMenuItem(FlintMenu, 0, "Becon Hill");//5
	AddMenuItem(FlintMenu, 0, "Fallen Tree");//6
	AddMenuItem(FlintMenu, 0, "HA3AD");//7

	MountChiliadMenu = CreateMenu("Mount Chiliad", 2,  55.0, 200.0, 100.0, 80.0);
	SetMenuColumnHeader(MountChiliadMenu, 0, "KYDA BAC ZOPTHYTJ?");
	AddMenuItem(MountChiliadMenu, 0, "Chiliad Jump");//0
	AddMenuItem(MountChiliadMenu, 0, "Bottom Of Chiliad");//1
	AddMenuItem(MountChiliadMenu, 0, "Highest Point");//2
	AddMenuItem(MountChiliadMenu, 0, "Chiliad Path");//3
	AddMenuItem(MountChiliadMenu, 0, "HA3AD");//7

	InteriorsMenu = CreateMenu("Interiors", 2,  55.0, 200.0, 130.0, 80.0);
	SetMenuColumnHeader(InteriorsMenu, 0, "KYDA BAC ZOPTHYTJ?");
	AddMenuItem(InteriorsMenu, 0, "Planning Department");//0
	AddMenuItem(InteriorsMenu, 0, "LV PD");//1
	AddMenuItem(InteriorsMenu, 0, "Pizza Stack");//2
	AddMenuItem(InteriorsMenu, 0, "RC Battlefield");//3
	AddMenuItem(InteriorsMenu, 0, "Caligula's Casino");//4
	AddMenuItem(InteriorsMenu, 0, "Big Smoke's Crack Palace");//5
	AddMenuItem(InteriorsMenu, 0, "Madd Dogg's Mansion");//6
	AddMenuItem(InteriorsMenu, 0, "Dirtbike Stadium");//7
	AddMenuItem(InteriorsMenu, 0, "Vice Stadium (duel)");//8
	AddMenuItem(InteriorsMenu, 0, "Ammu-nation");//9
	AddMenuItem(InteriorsMenu, 0, "Atrium");//7
	AddMenuItem(InteriorsMenu, 0, "HA3AD");//8
	#endif

	for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) OnPlayerConnect(i);
	for(new i = 1; i < MAX_CHAT_LINES; i++) Chat[i] = "<none>";
	for(new i = 1; i < MAX_REPORTS; i++) Reports[i] = "<none>";
	GodTimer = SetTimer("GodUpdate",2000,1);

	new year,month,day;	getdate(year, month, day);
	new hour,minute,second; gettime(hour,minute,second);

	print("________________________________________");
	print("           LAdmin Version 4.0           ");
	print("                Loaded                  ");
	print("________________________________________");
	printf("     Date: %d/%d/%d  Time: %d:%d :%d   ",day,month,year, hour, minute, second);
	print("________________________________________");
	print("________________________________________\n");
	return 1;
}
//==============================================================================
public OnFilterScriptExit()
{
	KillTimer(GodTimer);
	if(InvisTimer) KillTimer(InvisTimer);
	#if defined USE_MENUS
	DestroyAllMenus();
	#endif

	new year,month,day;	getdate(year, month, day);
	new hour,minute,second; gettime(hour,minute,second);
	print("\n________________________________________");
	print("________________________________________");
	print("           LAdmin Unloaded              ");
	print("________________________________________");
	printf("     Date: %d/%d/%d  Time: %d:%d :%d   ",day,month,year, hour, minute, second);
	print("________________________________________");
	print("________________________________________\n");
	return 1;
}

//==============================================================================

public OnPlayerConnect(playerid)
{
	//SetTimerEx("AntiMoneyHack",3000,true,"%i",playerid);
	PlayerInfo[playerid][Deaths] = 0;
	PlayerInfo[playerid][Kills] = 0;
	PlayerInfo[playerid][Jailed] = 0;
	PlayerInfo[playerid][Frozen] = 0;
	PlayerInfo[playerid][Level] = 0;
	PlayerInfo[playerid][LoggedIn] = 0;
	PlayerInfo[playerid][Registered] = 0;
	PlayerInfo[playerid][God] = 0;
	PlayerInfo[playerid][GodCar] = 0;
	PlayerInfo[playerid][TimesSpawned] = 0;
	PlayerInfo[playerid][Muted] = 0;
	PlayerInfo[playerid][MuteWarnings] = 0;
	PlayerInfo[playerid][Warnings] = 0;
	PlayerInfo[playerid][Caps] = 0;
	PlayerInfo[playerid][Invis] = 0;
	PlayerInfo[playerid][DoorsLocked] = 0;
	PlayerInfo[playerid][pCar] = -1;
	for(new i; i<PING_MAX_EXCEEDS; i++) PlayerInfo[playerid][pPing][i] = 0;
	PlayerInfo[playerid][SpamCount] = 0;
	PlayerInfo[playerid][SpamTime] = 0;
	PlayerInfo[playerid][PingCount] = 0;
	PlayerInfo[playerid][PingTime] = 0;
	PlayerInfo[playerid][FailLogin] = 0;
	//------------------------------------------------------
	new PlayerName[MAX_PLAYER_NAME], string[128], str[128], file[256];
	GetPlayerName(playerid, PlayerName, MAX_PLAYER_NAME);
	new tmp3[50]; GetPlayerIp(playerid,tmp3,50);
	//-----------------------------------------------------
	if(ServerInfo[ConnectMessages] == 1)
	{
		new pAKA[256]; pAKA = dini_Get("ladmin/config/aka.txt",tmp3);
		if (strlen(pAKA) < 3) format(str,sizeof(str),"*** %s (%d) вошел(ла) в игру", PlayerName, playerid);
		else if (!strcmp(pAKA,PlayerName,true)) format(str,sizeof(str),"*** %s (%d) вошел(ла) в игру", PlayerName, playerid);
		else format(str,sizeof(str),"*** %s (%d) вошел(ла) в игру (ники: %s)", PlayerName, playerid, pAKA );

		for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && playerid != i)
		{
			if(PlayerInfo[i][Level] > 2) SendClientMessage(i,grey,str);
			else {
				format(string,sizeof(string),"*** %s (%d) вошел(ла) в игру", PlayerName, playerid);
				SendClientMessage(i,grey,string);
			}
		}
	}
	//-----------------------------------------------------
	if (dUserINT(PlayerName2(playerid)).("banned") == 1)
	{
		SendClientMessage(playerid, red, "Ваше имя забанено на этом сервере!");
		format(string,sizeof(string)," %s ID:%d был автоматически кикнут. (Причина: Имя забанено на этом сервере)",PlayerName,playerid);
		SendClientMessageToAll(COLOR_RED, string);  print(string);
		SaveToFile("KickLog",string);  Kick(playerid);
	}
	//-----------------------------------------------------
	if (dUserINT(PlayerName2(playerid)).("Muted") == 1)
	{
	    PlayerInfo[playerid][Muted] = 1;
	}
	//-----------------------------------------------------
	if(ServerInfo[NameKick] == 1) {
		for(new s = 0; s < BadNameCount; s++) {
			if(!strcmp(BadNames[s],PlayerName,true)) {
				SendClientMessage(playerid,red, "Ваше имя находится в чёрном списке!");
				format(string,sizeof(string)," %s ID:%d был автоматически кикнут. (Причина: Имя в чёрном списке)",PlayerName,playerid);
				SendClientMessageToAll(COLOR_RED, string);  print(string);
				SaveToFile("KickLog",string);  Kick(playerid);
				return 1;
			}
		}
	}
	//-----------------------------------------------------
	if(ServerInfo[PartNameKick] == 1) {
		for(new s = 0; s < BadPartNameCount; s++) {
			new pos;
			while((pos = strfind(PlayerName,BadPartNames[s],true)) != -1) for(new i = pos, j = pos + strlen(BadPartNames[s]); i < j; i++)
			{
				SendClientMessage(playerid,red, "Ваш ник запрещен на сервере.");
				format(string,sizeof(string)," %s ID:%d был автоматически кикнут. (Причина: Запрещённый ник)",PlayerName,playerid);
				SendClientMessageToAll(COLOR_RED, string);  print(string);
				SaveToFile("KickLog",string);  Kick(playerid);
				return 1;
			}
		}
	}
	//-----------------------------------------------------
	if(ServerInfo[Locked] == 1) {
		PlayerInfo[playerid][AllowedIn] = false;
		SendClientMessage(playerid,red,"{FFFFFF}Сервер закрыт! Вы можете открыть сервер или через 20сек. вас кикнет!");
		SendClientMessage(playerid,red,"{FFFFFF} Используйте команду /password [пароль]");
		LockKickTimer[playerid] = SetTimerEx("AutoKick", 20000, 0, "i", playerid);
	}
	//-----------------------------------------------------
	if(strlen(dini_Get("ladmin/config/aka.txt", tmp3)) == 0) dini_Set("ladmin/config/aka.txt", tmp3, PlayerName);
	else
	{
		if( strfind( dini_Get("ladmin/config/aka.txt", tmp3), PlayerName, true) == -1 )
		{
			format(string,sizeof(string),"%s,%s", dini_Get("ladmin/config/aka.txt",tmp3), PlayerName);
			dini_Set("ladmin/config/aka.txt", tmp3, string);
		}
	}
	//-----------------------------------------------------
	if(udb_Exists(PlayerName2(playerid)))
	{
		PlayerInfo[playerid][Registered] = 1;
		format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(PlayerName));
		new tmp2[256]; tmp2 = dini_Get(file,"ip");
		if( (!strcmp(tmp3,tmp2,true)) && (ServerInfo[AutoLogin] == 1) )
		{
			LoginPlayer(playerid);
			if(PlayerInfo[playerid][Level] > 0)
			{
				format(string,sizeof(string),"{FFFFFF}Вы автоматически авторизованы. (Уровень %d)", PlayerInfo[playerid][Level] );
				SendClientMessage(playerid,green,string);
			}
			else SendClientMessage(playerid,green,"{FFFFFF}Вы автоматически авторизованы.");
		}
		else SendClientMessage(playerid,-1,"{FFFFFF}Ваш ник зарегистрирован. Введите {FFF000}/login {FFFFFF}для входа");
	}
	else SendClientMessage(playerid,-1,"{FFFFFF}Ваш ник не зарегистрирован. Введите {FFF000}/register {FFFFFF}для регистрации");
	
	return 1;
}

//==============================================================================

forward AutoKick(playerid);
public AutoKick(playerid)
{
	if( IsPlayerConnected(playerid) && ServerInfo[Locked] == 1 && PlayerInfo[playerid][AllowedIn] == false) {
		new string[128];
		SendClientMessage(playerid,COLOR_RED," Вы были кикнуты системой. (Причина: Сервер закрыт)");
		format(string,sizeof(string)," %s ID:%d был автоматически кикнут. (Причина: Сервер закрыт)",PlayerName2(playerid),playerid);
		SaveToFile("KickLog",string);  Kick(playerid);
		SendClientMessageToAll(COLOR_RED, string); print(string);
	}
	return 1;
}

//==============================================================================

public OnPlayerDisconnect(playerid, reason)
{
	new PlayerName[MAX_PLAYER_NAME], str[128];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));

	if(ServerInfo[ConnectMessages] == 1)
	{
		switch (reason) {
		case 0:	format(str, sizeof(str), "*** %s (%d) вышел(ла) из игры (Вылет)", PlayerName, playerid);
		case 1:	format(str, sizeof(str), "*** %s (%d) вышел(ла) из игры (Выход)", PlayerName, playerid);
		case 2:	format(str, sizeof(str), "*** %s (%d) вышел(ла) из игры (Кикнут либо забанен)", PlayerName, playerid);
		}
		SendClientMessageToAll(grey, str);
	}

	if(PlayerInfo[playerid][LoggedIn] == 1)	SavePlayer(playerid);
	if(udb_Exists(PlayerName2(playerid))) dUserSetINT(PlayerName2(playerid)).("loggedin",0);
	PlayerInfo[playerid][LoggedIn] = 0;
	PlayerInfo[playerid][Level] = 0;
	PlayerInfo[playerid][Jailed] = 0;
	PlayerInfo[playerid][Frozen] = 0;

	if(PlayerInfo[playerid][Jailed] == 1) KillTimer( JailTimer[playerid] );
	if(PlayerInfo[playerid][Frozen] == 1) KillTimer( FreezeTimer[playerid] );
	if(ServerInfo[Locked] == 1)	KillTimer( LockKickTimer[playerid] );

	if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);

	#if defined ENABLE_SPEC
	for(new x=0; x<GetMaxPlayers(); x++)
	if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid)
	AdvanceSpectate(x);
	#endif

	return 1;
}

forward DelayKillPlayer(playerid);
public DelayKillPlayer(playerid)
{
	SetPlayerHealth(playerid,0.0);
	ForceClassSelection(playerid);
}

//==============================================================================
public OnPlayerSpawn(playerid)
{
	if(!PlayerInfo[playerid][LoggedIn])
	{
		SendClientMessage(playerid,-1,"{FF9212}Вы должны залогиниться/зарегистрироваться в течение {1266FF}45 секунд{FF9212}, иначе будете кикнуты!");
		TimeToLogin[playerid] = SetTimerEx("PlayerKick",45000,false,"i",playerid);
	}
	
	if(ServerInfo[Locked] == 1 && PlayerInfo[playerid][AllowedIn] == false)
	{
		GameTextForPlayer(playerid,"~r~CEPBEP 3AKPST ~n~OTKPONTE EFO KOMAHDON~n~/password <ZAPOLJ>",4000,3);
		SetTimerEx("DelayKillPlayer", 2500,0,"d",playerid);
		return 1;
	}

	if(ServerInfo[MustLogin] == 1 && PlayerInfo[playerid][Registered] == 1 && PlayerInfo[playerid][LoggedIn] == 0)
	{
		GameTextForPlayer(playerid,"~r~BS DOLGHS 3ALOFNHNTJCR!",4000,3);
		SetTimerEx("DelayKillPlayer", 2500,0,"d",playerid);
		return 1;
	}

	PlayerInfo[playerid][Spawned] = 1;

	if(PlayerInfo[playerid][Frozen] == 1) {
		TogglePlayerControllable(playerid,false); return SendClientMessage(playerid,red,"{FFFFFF} Вам не поможет esc, вы наказаны и все еще заморожены");
	}

	if(PlayerInfo[playerid][Jailed] == 1) {
		SetTimerEx("JailPlayer",3000,0,"d",playerid); return SendClientMessage(playerid,red,"{FFFFFF} Вам не поможет esc, вы наказаны и все еще в тюрьме");
	}

	if(ServerInfo[AdminOnlySkins] == 1) {
		if( (GetPlayerSkin(playerid) == ServerInfo[AdminSkin]) || (GetPlayerSkin(playerid) == ServerInfo[AdminSkin2]) ) {
			if(PlayerInfo[playerid][Level] >= 1)
			GameTextForPlayer(playerid,"~b~DO6PO ZOGALOBATJ~n~ ~w~ADMNH",3000,1);
			else {
				GameTextForPlayer(playerid,"~r~CKNH DLR ~n~ADMNHNCTPATOPOB",4000,1);
				SetTimerEx("DelayKillPlayer", 2500,0,"d",playerid);
				return 1;
			}
		}
	}

	if((dUserINT(PlayerName2(playerid)).("UseSkin")) == 1)
	if((PlayerInfo[playerid][Level] >= 1) && (PlayerInfo[playerid][LoggedIn] == 1))
	SetPlayerSkin(playerid,(dUserINT(PlayerName2(playerid)).("FavSkin")) );

	if(ServerInfo[GiveWeap] == 1) {
		if(PlayerInfo[playerid][LoggedIn] == 1) {
			PlayerInfo[playerid][TimesSpawned]++;
			if(PlayerInfo[playerid][TimesSpawned] == 1)
			{
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap1"), dUserINT(PlayerName2(playerid)).("weap1ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap2"), dUserINT(PlayerName2(playerid)).("weap2ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap3"), dUserINT(PlayerName2(playerid)).("weap3ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap4"), dUserINT(PlayerName2(playerid)).("weap4ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap5"), dUserINT(PlayerName2(playerid)).("weap5ammo")	);
				GivePlayerWeapon(playerid, dUserINT(PlayerName2(playerid)).("weap6"), dUserINT(PlayerName2(playerid)).("weap6ammo")	);
			}
		}
	}
	return 1;
}

//==============================================================================

public OnPlayerDeath(playerid, killerid, reason)
{
	if(playerid==INVALID_PLAYER_ID || killerid==INVALID_PLAYER_ID) return 1;

	#if defined ENABLE_SPEC
	for(new x=0; x<GetMaxPlayers(); x++)
	if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid)
	AdvanceSpectate(x);
	#endif

	#if defined USE_STATS
	PlayerInfo[playerid][Deaths]++;
	PlayerInfo[killerid][Kills]++;
	#endif

	return 1;
}

//==============================================================================

public OnPlayerText(playerid, text[])
{
	if(!PlayerInfo[playerid][LoggedIn])
	{
		SendClientMessage(playerid,-1,"{FFFFFF}Вы должны залогиниться, чтобы писать в чат");
		return 0;
	}
	
	fixchars(text);
	if(text[0] == '#' && PlayerInfo[playerid][Level] >= 1) {
		new string[128]; GetPlayerName(playerid,string,sizeof(string));
		format(string,sizeof(string)," Админ чат: %s: %s",string,text[1]); MessageToAdmins(green,string);
		return 0;
	}

	if(ServerInfo[DisableChat] == 1) {
		SendClientMessage(playerid,red,"{FFFFFF} Чат отключен");
		return 0;
	}

	if(PlayerInfo[playerid][Muted] == 1)
	{
		PlayerInfo[playerid][MuteWarnings]++;
		new string[128];
		if(PlayerInfo[playerid][MuteWarnings] < ServerInfo[MaxMuteWarnings]) {
			format(string, sizeof(string)," ПРЕДУПРЕЖДЕНИЕ: Вы заткнуты, если будете продолжать писать, то вас кикнет. (Предупреждения:%d/%d)", PlayerInfo[playerid][MuteWarnings], ServerInfo[MaxMuteWarnings] );
			SendClientMessage(playerid,red,string);
		} else {
			SendClientMessage(playerid,red,"{FFFFFF} Вас предупреждали ! Вы кикнуты");
			format(string, sizeof(string)," ***%s (ID %d) был кикнут за превышеный лимит предупреждений", PlayerName2(playerid), playerid);
			SendClientMessageToAll(COLOR_RED,string);
			SaveToFile("KickLog",string); Kick(playerid);
		} return 0;
	}

	if(ServerInfo[AntiSpam] == 1 && (PlayerInfo[playerid][Level] == 0 && !IsPlayerAdmin(playerid)) )
	{
		if(PlayerInfo[playerid][SpamCount] == 0) PlayerInfo[playerid][SpamTime] = TimeStamp();

		PlayerInfo[playerid][SpamCount]++;
		if(TimeStamp() - PlayerInfo[playerid][SpamTime] > SPAM_TIMELIMIT) { // Its OK your messages were far enough apart
			PlayerInfo[playerid][SpamCount] = 0;
			PlayerInfo[playerid][SpamTime] = TimeStamp();
		}
		else if(PlayerInfo[playerid][SpamCount] == SPAM_MAX_MSGS) {
			new string[64]; format(string,sizeof(string)," %s был кикнут системой (Флуд/Спам)", PlayerName2(playerid));
			SendClientMessageToAll(COLOR_RED,string); print(string);
			SaveToFile("KickLog",string);
			Kick(playerid);
		}
		else if(PlayerInfo[playerid][SpamCount] == SPAM_MAX_MSGS-1) {
			SendClientMessage(playerid,red,"{FFFFFF} ПРЕДУПРЕЖДЕНИЕ: Дальше кик.");
			return 0;
		}
	}

	if(ServerInfo[AntiSwear] == 1 && PlayerInfo[playerid][Level] < ServerInfo[MaxAdminLevel])
	for(new s = 0; s < ForbiddenWordCount; s++)
	{
		new pos;
		while((pos = strfind(text,ForbiddenWords[s],true)) != -1) for(new i = pos, j = pos + strlen(ForbiddenWords[s]); i < j; i++) text[i] = '*';
	}

	if(PlayerInfo[playerid][Caps] == 1) UpperToLower(text);
	if(ServerInfo[NoCaps] == 1) UpperToLower(text);

	for(new i = 1; i < MAX_CHAT_LINES-1; i++) Chat[i] = Chat[i+1];
	//new ChatSTR[128]; GetPlayerName(playerid,ChatSTR,sizeof(ChatSTR)); format(ChatSTR,128,"[lchat]%s: %s",ChatSTR, text[0] );
	//Chat[MAX_CHAT_LINES-1] = ChatSTR;
	return 1;
}

//==============================================================================
public OnPlayerPrivmsg(playerid, recieverid, text[])
{
	fixchars(text);
	if(ServerInfo[ReadPMs] == 1 && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel])
	{
		new string[128],recievername[MAX_PLAYER_NAME];
		GetPlayerName(playerid, string, sizeof(string)); GetPlayerName(recieverid, recievername, sizeof(recievername));
		format(string, sizeof(string), "***ЛС: %s пишет %s: %s", string, recievername, text);
		for (new a = 0; a < GetMaxPlayers(); a++) if (IsPlayerConnected(a) && (PlayerInfo[a][Level] >= ServerInfo[MaxAdminLevel]) && a != playerid)
		SendClientMessage(a, yellow, string);
	}

	if(PlayerInfo[playerid][Muted] == 1)
	{
		new string[128];
		PlayerInfo[playerid][MuteWarnings]++;
		if(PlayerInfo[playerid][MuteWarnings] < ServerInfo[MaxMuteWarnings]) {
			format(string, sizeof(string)," ПРЕДУПРЕЖДЕНИЕ: Вы что тупой? Сказали же что вы заткнуты,если будете далее писать то вас кикнет. (Предупреждения: %d/%d)", PlayerInfo[playerid][MuteWarnings], ServerInfo[MaxMuteWarnings] );
			SendClientMessage(playerid,red,string);
		} else {
			SendClientMessage(playerid,red,"{FFFFFF} Вас предупреждали! Вы кикнуты");
			GetPlayerName(playerid, string, sizeof(string));
			format(string, sizeof(string)," %s [ID %d] Кикнут за высокий лимит предупреждений", string, playerid);
			SendClientMessageToAll(COLOR_RED,string);
			SaveToFile("KickLog",string); Kick(playerid);
		} return 0;
	}
	return 1;
}

forward HighLight(playerid);
public HighLight(playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;
	if(PlayerInfo[playerid][blipS] == 0) { SetPlayerColor(playerid, 0xFF0000AA); PlayerInfo[playerid][blipS] = 1; }
	else { SetPlayerColor(playerid, 0x33FF33AA); PlayerInfo[playerid][blipS] = 0; }
	return 0;
}

//===================== [ DCMD Commands ]=======================================

dcmd_giveweapon(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
		new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/giveweapon [id игрока] [id оружия или название] [патроны]");
		new player1 = strval(tmp), weap, ammo, WeapName[32], string[128];
		if(!strlen(tmp3) || !IsNumeric(tmp3) || strval(tmp3) <= 0 || strval(tmp3) > 99999) ammo = 500; else ammo = strval(tmp3);
		if(!IsNumeric(tmp2)) weap = GetWeaponIDFromName(tmp2); else weap = strval(tmp2);
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(!IsValidWeapon(weap)) return SendClientMessage(playerid,red,"{FFFFFF}Неверный ID оружия");
			CMDMessageToAdmins(playerid,"GIVEWEAPON");
			GetWeaponName(weap,WeapName,32);
			format(string, sizeof(string), " Вы дали игроку %s оружие %s(ID:%d) с %d патронами", PlayerName2(player1), WeapName, weap, ammo); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s дал вам оружие %s(ID:%d) с %d патронами", PlayerName2(playerid), WeapName, weap, ammo); SendClientMessage(player1,COLOR_GREEN,string); }
			return GivePlayerWeapon(player1, weap, ammo);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 2 уровень, чтобы использовать эту команду");
}

dcmd_sethealth(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/sethealth [id игрока] [кол-во здоровья]");
		if(strval(tmp2) < 0 || strval(tmp2) > 100 && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid, red, " {FFFFFF}Не допустимое кол-во здоровья");
		new player1 = strval(tmp), health = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETHEALTH");
			format(string, sizeof(string), " Вы установили игроку %s здоровье %d", pName(player1), health); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам здоровье на %d", pName(playerid), health); SendClientMessage(player1,COLOR_GREEN,string); }
			return SetPlayerHealth(player1, health);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setarmour(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setarmour [id игрока] [кол-во брони]");
		if(strval(tmp2) < 0 || strval(tmp2) > 100 && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid, red, " {FFFFFF}Не допустимое кол-во брони");
		new player1 = strval(tmp), armour = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETARMOUR");
			format(string, sizeof(string), " Вы установили игроку %s броню %d", pName(player1), armour); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам броню на %d", pName(playerid), armour); SendClientMessage(player1,COLOR_GREEN,string); }
			return SetPlayerArmour(player1, armour);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setcash(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setcash [id игрока] [сумма]");
		new player1 = strval(tmp), cash = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETCASH");
			format(string, sizeof(string), " Вы установили игроку %s сумму $%d", pName(player1), cash); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам сумму $%d", pName(playerid), cash); SendClientMessage(player1,COLOR_GREEN,string); }
			ResetPlayerMoney(player1);
			return GivePlayerMoney(player1,cash);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setscore(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setscore [id игрока] [score]");
		new player1 = strval(tmp), score = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETSCORE");
			format(string, sizeof(string), " Вы установили игроку %s рекорд %d", pName(player1), score); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам рекорд %d", pName(playerid), score); SendClientMessage(player1,COLOR_GREEN,string); }
			return SetPlayerScore(player1, score);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setskin(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setskin [id игрока] [id скина]");
		new player1 = strval(tmp), skin = strval(tmp2), string[128];
		if(!IsValidSkin(skin)) return SendClientMessage(playerid, red, " {FFFFFF}Invaild Skin ID");
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETSKIN");
			format(string, sizeof(string), " Вы установили игроку %s скин %d", pName(player1), skin); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %sустановил вам скин %d", pName(playerid), skin); SendClientMessage(player1,COLOR_GREEN,string); }
			return SetPlayerSkin(player1, skin);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setwanted(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setwanted [id игрока] [уровень]");
		new player1 = strval(tmp), wanted = strval(tmp2), string[128];
		//		if(wanted > 6) return SendClientMessage(playerid, red, " {FFFFFF}Invaild wanted level");
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETWANTED");
			format(string, sizeof(string), " Вы установили игроку %s уровень розыскиваемости %d", pName(player1), wanted); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам уровень розыскиваемости %d", pName(playerid), wanted); SendClientMessage(player1,COLOR_GREEN,string); }
			return SetPlayerWantedLevel(player1, wanted);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setname(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setname [id игрока] [новое имя]");
		new player1 = strval(tmp), length = strlen(tmp2), string[128];
		if(length < 3 || length > MAX_PLAYER_NAME) return SendClientMessage(playerid,red,"{FFFFFF}Не верная длинна имени");
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETNAME");
			format(string, sizeof(string), " Вы установили %s новое имя <<%s>>", pName(player1), tmp2); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам новое имя <<%s>>", pName(playerid), tmp2); SendClientMessage(player1,COLOR_GREEN,string); }
			SetPlayerName(player1, tmp2);
			return OnPlayerConnect(player1);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setcolour(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) {
			SendClientMessage(playerid, red, " {FFFFFF}/setcolour [id игрока] [№ цвета]");
			return SendClientMessage(playerid, red, " Допустимые цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
		}
		new player1 = strval(tmp), Colour = strval(tmp2), string[128], colour[24];
		if(Colour > 9) return SendClientMessage(playerid, red, " Допустимые цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETCOLOUR");
			switch (Colour)
			{
			case 0: { SetPlayerColor(player1,black); colour = "черный"; }
			case 1: { SetPlayerColor(player1,COLOR_WHITE); colour = "белый"; }
			case 2: { SetPlayerColor(player1,red); colour = "красный"; }
			case 3: { SetPlayerColor(player1,orange); colour = "оранжевый"; }
			case 4: { SetPlayerColor(player1,orange); colour = "желтый"; }
			case 5: { SetPlayerColor(player1,COLOR_GREEN1); colour = "зеленый"; }
			case 6: { SetPlayerColor(player1,COLOR_BLUE); colour = "синий"; }
			case 7: { SetPlayerColor(player1,COLOR_PURPLE); colour = "фиолетовый"; }
			case 8: { SetPlayerColor(player1,COLOR_BROWN); colour = "коричневый"; }
			case 9: { SetPlayerColor(player1,COLOR_PINK); colour = "розовый"; }
			}
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s сменил вам цвет на %s ", pName(playerid), colour); SendClientMessage(player1,COLOR_GREEN,string); }
			format(string, sizeof(string), " Вы сменили цвет игрока %s на %s", pName(player1), colour);
			return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setweather(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setweather [id игрока] [id погоды]");
		new player1 = strval(tmp), weather = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETWEATHER");
			format(string, sizeof(string), " Вы сменили погоду %s на %d", pName(player1), weather); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s сменил погоду на %d", pName(playerid), weather); SendClientMessage(player1,COLOR_GREEN,string); }
			SetPlayerWeather(player1,weather); PlayerPlaySound(player1,1057,0.0,0.0,0.0);
			return PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_settime(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/settime [id игрока] [время]");
		new player1 = strval(tmp), time = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETTIME");
			format(string, sizeof(string), " Вы сменили игроку %s время на %d:00", pName(player1), time); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s сменил вам время на %d:00", pName(playerid), time); SendClientMessage(player1,COLOR_GREEN,string); }
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
			return SetPlayerTime(player1, time, 0);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setworld(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setworld [id игрока] [виртуальный мир]");
		new player1 = strval(tmp), time = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETWORLD");
			format(string, sizeof(string), " Вы установили игроку %s виртуальный мир на %d", pName(player1), time); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам виртуальный мир на %d", pName(playerid), time); SendClientMessage(player1,COLOR_GREEN,string); }
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
			return SetPlayerVirtualWorld(player1, time);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setinterior(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setinterior [id игрока] [interior]");
		new player1 = strval(tmp), time = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SETINTERIOR");
			format(string, sizeof(string), " Вы установили интерьер игроку %s на %d", pName(player1), time); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил вам интерьер на %d", pName(playerid), time); SendClientMessage(player1,COLOR_GREEN,string); }
			PlayerPlaySound(player1,1057,0.0,0.0,0.0);
			return SetPlayerInterior(player1, time);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setmytime(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setmytime [время]");
		new time = strval(params), string[128];
		CMDMessageToAdmins(playerid,"SETMYTIME");
		format(string,sizeof(string)," Вы установили себе время %d:00", time); SendClientMessage(playerid,COLOR_GREEN,string);
		return SetPlayerTime(playerid, time, 0);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_force(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 4) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/force [id игрока]");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"FORCE");
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s заставил вас заного выбрать скин", pName(playerid) ); SendClientMessage(player1,COLOR_RED,string); }
			format(string,sizeof(string)," Вы заставили игрока %s заного выбрать скин", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
			ForceClassSelection(player1);
			return SetPlayerHealth(player1,0.0);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_eject(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/eject [id игрока]");
		new player1 = strval(params), string[128], Float:x, Float:y, Float:z;
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(IsPlayerInAnyVehicle(player1)) {
				CMDMessageToAdmins(playerid,"EJECT");
				if(player1 != playerid) { format(string,sizeof(string)," Админ %s выкинул вас из транспорта", pName(playerid) ); SendClientMessage(player1,COLOR_RED,string); }
				format(string,sizeof(string)," Вы выкинули игрока %s из транспорта", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
				GetPlayerPos(player1,x,y,z);
				return SetPlayerPos(player1,x,y,z+3);
			} else return SendClientMessage(playerid,red,"{FFFFFF}Игрок не в транспорте");
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_lockcar(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
			for(new i = 0; i < GetMaxPlayers(); i++) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,true);
			CMDMessageToAdmins(playerid,"LOCKCAR");
			PlayerInfo[playerid][DoorsLocked] = 1;
			new string[128]; format(string,sizeof(string)," Админ %s закрыл двери своего транспорта", pName(playerid));
			return SendClientMessageToAll(COLOR_GREEN,string);
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете закрыть двери в этом транспорте");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_unlockcar(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
			for(new i = 0; i < GetMaxPlayers(); i++) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,false);
			CMDMessageToAdmins(playerid,"UNLOCKCAR");
			PlayerInfo[playerid][DoorsLocked] = 0;
			new string[128]; format(string,sizeof(string)," Админ %s открыл двери своего транспорта", pName(playerid));
			return SendClientMessageToAll(COLOR_GREEN,string);
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете открыть двери в этом транспорте");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_burn(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/burn [id игрока]");
		new player1 = strval(params), string[128], Float:x, Float:y, Float:z;
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"BURN");
			format(string, sizeof(string), " Вы подожгли %s", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s вас поджог", pName(playerid)); SendClientMessage(player1,COLOR_RED,string); }
			GetPlayerPos(player1, x, y, z);
			return CreateExplosion(x, y , z + 3, 1, 10);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_spawnplayer(playerid,params[])
{
	return dcmd_spawn(playerid,params);
}

dcmd_spawn(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/spawn [id игрока]");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"SPAWNPLAYER");
			format(string, sizeof(string), " Вы вернули игрока %s на место спавна", pName(player1)); SendClientMessage(playerid,COLOR_GREEN,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s вернул вас на место спавна", pName(playerid)); SendClientMessage(player1,COLOR_GREEN,string); }
			SetPlayerPos(player1, 0.0, 0.0, 0.0);
			return SpawnPlayer(player1);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_disarm(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/disarm [id игрока]");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"DISARM");  PlayerPlaySound(player1,1057,0.0,0.0,0.0);
			format(string, sizeof(string), " Вы разоружили игрока %s", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s разоружил вас", pName(playerid)); SendClientMessage(player1,COLOR_RED,string); }
			ResetPlayerWeapons(player1);
			return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_crash(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 9) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/crash [id игрока]");
		new player1 = strval(params), string[128], Float:X,Float:Y,Float:Z;
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"CRASH");
			GetPlayerPos(player1,X,Y,Z);
			new objectcrash[10];
			for(new m=0; m<sizeof(objectcrash); m++)
			{
				objectcrash[m] = CreatePlayerObject(player1,11111111,X,Y,Z,0,0,0);
				DestroyObject(objectcrash[m]);
			}
			format(string, sizeof(string), " Вы заставили вылететь игрока %s из игры", pName(player1) );
			return SendClientMessage(playerid,COLOR_RED, string);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_ip(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 9) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/ip [id игрока]");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"IP");
			new tmp3[50]; GetPlayerIp(player1,tmp3,50);
			format(string,sizeof(string)," IP игрока %s - %s", pName(player1), tmp3);
			return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_bankrupt(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 9) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/bankrupt [id игрока]");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"BANKRUPT");
			format(string, sizeof(string), " Вы сделали банкротом игрока %s", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
			if(player1 != playerid) { format(string,sizeof(string)," Админ %s сделал вас банкротом", pName(playerid)); SendClientMessage(player1,COLOR_RED,string); }
			return ResetPlayerMoney(player1);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_sbankrupt(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 10) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/sbankrupt [id игрока]");
		new player1 = strval(params), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"BANKRUPT");
			format(string, sizeof(string), " Вы сделали игрока %s банкротом", pName(player1)); SendClientMessage(playerid,COLOR_RED,string);
			return ResetPlayerMoney(player1);
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_kill(playerid,params[]) {
	#pragma unused params
	return SetPlayerHealth(playerid,0.0);
}

dcmd_register(playerid,params[])
{
	if (PlayerInfo[playerid][LoggedIn] == 1) return SendClientMessage(playerid,red,"{FFFFFF}Вы зарегистрированы и авторизованы.");
	if (udb_Exists(PlayerName2(playerid))) return SendClientMessage(playerid,red,"{FFFFFF}Этот ник зарегистрирован, если он ваш то залогинитесь командой /login [password].");
	if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/register [пароль]");
	if (udb_Create(PlayerName2(playerid),params))
	{
		new file[256],name[MAX_PLAYER_NAME], tmp3[100];
		new strdate[20], year,month,day;	getdate(year, month, day);
		GetPlayerName(playerid,name,sizeof(name)); format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(name));
		GetPlayerIp(playerid,tmp3,100);	dini_Set(file,"ip",tmp3);
		dUserSetINT(PlayerName2(playerid)).("registered",1);
		format(strdate, sizeof(strdate), "%d/%d/%d",day,month,year);
		dini_Set(file,"RegisteredDate",strdate);
		dUserSetINT(PlayerName2(playerid)).("loggedin",1);
		dUserSetINT(PlayerName2(playerid)).("banned",0);
		dUserSetINT(PlayerName2(playerid)).("level",0);
		dUserSetINT(PlayerName2(playerid)).("LastOn",0);
		dUserSetINT(PlayerName2(playerid)).("money",0);
		dUserSetINT(PlayerName2(playerid)).("kills",0);
		dUserSetINT(PlayerName2(playerid)).("deaths",0);
		dUserSetINT(PlayerName2(playerid)).("Muted",0);
		PlayerInfo[playerid][LoggedIn] = 1;
		PlayerInfo[playerid][Registered] = 1;
		SendClientMessage(playerid, green, "{FFFFFF}Вы успешно зарегистрировались, и автоматически авторизованы");
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		KillTimer(TimeToLogin[playerid]);
		return 1;
	}
	return 1;
}

dcmd_login(playerid,params[])
{
	if (PlayerInfo[playerid][LoggedIn] == 1) return SendClientMessage(playerid,red,"{FFFFFF}Вы успешно авторизовались.");
	if (!udb_Exists(PlayerName2(playerid))) return SendClientMessage(playerid,red,"{FFFFFF}Учетной записи не существует. Пожалуйста, введите /register [пароль].");
	if (!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/login [пароль]");
	if (udb_CheckLogin(PlayerName2(playerid),params))
	{
		new file[256], tmp3[100], string[128];
		format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(PlayerName2(playerid)) );
		GetPlayerIp(playerid,tmp3,100);
		dini_Set(file,"ip",tmp3);
		LoginPlayer(playerid);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		KillTimer(TimeToLogin[playerid]);
		if(PlayerInfo[playerid][Level] > 0)
		{
			format(string,sizeof(string),"{FFFFFF}Вы успешно авторизовались. (Уровень %d)", PlayerInfo[playerid][Level] );
			SendClientMessage(playerid,green,string);
		} else SendClientMessage(playerid,green,"{FFFFFF}Вы успешно авторизовались");
		return 1;
	}
	else
	{
		PlayerInfo[playerid][FailLogin]++;
		printf("LOGIN: %s has failed to login, Wrong password (%s) Attempt (%d)", PlayerName2(playerid), params, PlayerInfo[playerid][FailLogin] );
		if(PlayerInfo[playerid][FailLogin] == MAX_FAIL_LOGINS)
		{
			new string[128]; format(string, sizeof(string), " %s кикнут системой (Причина: Несколько раз ввел неверный пароль)", PlayerName2(playerid) );
			SendClientMessageToAll(COLOR_RED, string); print(string);
			Kick(playerid);
		}
		return SendClientMessage(playerid,red,"{FFFFFF}Вы не авторизовались! Неверный пароль");
	}
}

dcmd_time(playerid,params[]) {
	#pragma unused params
	new string[64], hour,minuite,second; gettime(hour,minuite,second);
	format(string, sizeof(string), "~g~|~w~%d:%d~g~|", hour, minuite);
	return GameTextForPlayer(playerid, string, 5000, 1);
}

dcmd_ubound(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 9) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/ubound [id игрока]");
		new string[128], player1 = strval(params);

		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"UBOUND");
			SetPlayerWorldBounds(player1, 9999.9, -9999.9, 9999.9, -9999.9 );
			format(string, sizeof(string)," Админ %s удалил ваши мировые границы", PlayerName2(playerid)); if(player1 != playerid) SendClientMessage(player1,COLOR_GREEN,string);
			format(string,sizeof(string)," Вы удалили с игрока %s все мировые границы", PlayerName2(player1));
			return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_lhelp(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] && PlayerInfo[playerid][Level] >= 1) {
		SendClientMessage(playerid,blue,"--== [ LAdmin Помощь ] ==--");
		SendClientMessage(playerid,blue, "Команды для админов:  /lcommands   |   Авторы: /lcredits");
		SendClientMessage(playerid,blue, "Система регистрации: /register, /login, /changepass, /stats, /resetstats.  Also  /time, /report");
		SendClientMessage(playerid,blue, "Это русская версия LAdmin4");
		SendClientMessage(playerid,blue, "ВАЖНО: Если вы сменили мод то перегрузите скрипты");
	}
	else if(PlayerInfo[playerid][LoggedIn] && PlayerInfo[playerid][Level] < 1) {
		SendClientMessage(playerid,green, "Ваши команды: /register, /login, /report, /stats, /time, /changepass, /resetstats, /getid");
	}
	else if(PlayerInfo[playerid][LoggedIn] == 0) {
		SendClientMessage(playerid,green, "Ваши команды: /time, /getid     (Вы должны залогиниться чтобы использовать команды)");
	} return 1;
}

dcmd_lcmds(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] > 0)
	{
		SendClientMessage(playerid,blue,"    ---= [ Все комады по категориям] ==---");
		SendClientMessage(playerid,lightblue," ОСНОВНЫЕ: getinfo, lmenu, announce, write, miniguns, richlist, lspec(off), move, lweaps, adminarea, giveweapon");
		SendClientMessage(playerid,lightblue," ОСНОВНЫЕ: slap, burn, warn, kick, ban, explode, jail, freeze, mute, crash, ubound, god, godcar, invis, ping");
		SendClientMessage(playerid,lightblue," ОСНОВНЫЕ: setping, lockserver, enable/disable, setlevel, setinterior, givecar, jetpack, force, spawn");
		SendClientMessage(playerid,lightblue," МАШИНЫ: flip, fix, repair, lockcar, eject, ltc [1-13], car, lcar, lbike, lplane, lheli, lboat, lnos, cm");
		SendClientMessage(playerid,lightblue," ТЕЛЕПОРТ: goto, gethere, get, teleplayer, ltele, vgoto, lgoto, moveplayer");
		SendClientMessage(playerid,lightblue," УСТАНОВИТЬ: set(cash/health/armour/gravity/name/time/weather/skin/colour/wanted/templevel)");
		SendClientMessage(playerid,lightblue," УСТАН.ВСЕ: setall(world/weather/wanted/time/score/cash)");
		SendClientMessage(playerid,lightblue," ВСЕМ: giveallweapon, healall, armourall, freezeall, kickall, ejectall, killall, disarmall, slapall, spawnall");
	}
	return 1;
}

dcmd_lcommands(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] > 0) {
		SendClientMessage(playerid,green,"(1) FLIP, FIX, REPAIR, LP, CARCOLOUR, LTUNE, SETMYTIME, TIME, GETID, LINKCAR, LNOS, LHY");
		SendClientMessage(playerid,green,"(1) ANNOUNCE, ANNOUNCE2, (UN) LOCKCAR, DISARM, GOTO, ADMINAREA, LCAR, LBIKE, LTC, CM (giveme), LSLOWMO, JETPACK");
	}
	if(PlayerInfo[playerid][Level] > 1) {
		SendClientMessage(playerid,COLOR_GREEN,"(2) SLAP, LSPEC (OFF), LSPECVEHICLE, BURN, WARN, MUTE, UNMUTE, GIVEWEAPON, GETINFO, LASTON, WRITE, CLEARCHAT, ASAY");
	}
	if(PlayerInfo[playerid][Level] > 2) {
		SendClientMessage(playerid,green,"(3) SETCASH, SETSKIN, SETCOLOUR, SETWANTED, LMENU, LTELE, LVEHICLE, SETINTERIOR, LWEAPONS, LTMENU, SPAWN");
		SendClientMessage(playerid,green,"(3) KICK, EXPLODE,  EJECT, JAIL, UNJAIL, FREEZE, UNFREEZE, MOVE, LWEAPS, LAMMO, BOTCHECK");
	}
	if(PlayerInfo[playerid][Level] > 3) {
		SendClientMessage(playerid,COLOR_GREEN,"(4)GETHERE, TELEPLAYER, CAR, CARHEALTH, DESTROY, LTIME, LWEATHER, CAPS, FORCE");
	}
	if(PlayerInfo[playerid][Level] > 4) {
		SendClientMessage(playerid,green,"(5) SETHEALTH, SETARMOUR, SETGRAVITY, SETNAME, SETWEATHER, SETTIME, SETWORLD, HEALALL, ARMOURALL");
	}
	if(PlayerInfo[playerid][Level] > 5) {
		SendClientMessage(playerid,COLOR_GREEN,"(6) SETALLWORLD, SETALLWEATHER, SETALLWANTED, SETALLTIME, GIVEALLWEAPON, SETALLSCORE, SETALLCASH, GIVEALLCASH");
	}
	if(PlayerInfo[playerid][Level] > 6) {
		SendClientMessage(playerid,green,"(7) BAN, SETPING, DISABLE, ENABLE, FORBID (NAME/WORD), SETTEMPLEVEL, CC, (UN) INVIS, UCONFIG");
	}
	if(PlayerInfo[playerid][Level] > 7) {
		SendClientMessage(playerid,COLOR_GREEN,"(8) KILLALL, DISARMALL, KICKALL, EJECTALL, FREEZEALL, UNFREEZEALL, SPAWNALL, (UN) LOCKSERVER, GOD, GODCAR");
	}
	if(PlayerInfo[playerid][Level] > 8) {
		SendClientMessage(playerid,green,"(9) SLAPALL, UBOUND, FAKEDEATH, FAKECHAT, FAKECMD, CRASH, DIE, IP, BANKRUPT, LWEAPS, LHELI");
	}
	if(PlayerInfo[playerid][Level] > 9) SendClientMessage(playerid,COLOR_GREEN,"(10) SETLEVEL, OBJECT, PICKUP, (UN)LOADFS, GMX, RELOADLADMIN");
	if(IsPlayerAdmin(playerid)) SendClientMessage(playerid,blue,"(RCON) INFO, PM, MSG, ANN, ASAY, AKA, CHAT, UCONFIG");
	if(PlayerInfo[playerid][Level] < 1 ) {
		SendClientMessage(playerid,green, " Ваши команды: /register, /login, /report, /stats, /time, /changepass, /resetstats, /getid");
	}
	return 1;
}

dcmd_lconfig(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] > 0)
	{
		new string[128];
		SendClientMessage(playerid,blue,"    ---=== LAdmin Конфигурации ===---");
		format(string, sizeof(string), " Максимальный пинг: %dms | Читать приваты %d | Читать команды %d | Максимальный уровень %d | Админ скины %d", ServerInfo[MaxPing],  ServerInfo[ReadPMs],  ServerInfo[ReadCmds],  ServerInfo[MaxAdminLevel],  ServerInfo[AdminOnlySkins] );
		SendClientMessage(playerid,blue,string);
		format(string, sizeof(string), " Админ скин1 %d | Админскин2 %d | Кик по нику %d | Анти-бот %d | Анти-спам %d | Анти-мат %d", ServerInfo[AdminSkin], ServerInfo[AdminSkin2], ServerInfo[NameKick], ServerInfo[AntiBot], ServerInfo[AntiSpam], ServerInfo[AntiSwear] );
		SendClientMessage(playerid,blue,string);
		format(string, sizeof(string), " Анти-капс %d | Закрыт %d | Пароль %s | Сохран. оруж. %d | Сохран. деньги %d | Коннект-сообщ. %d | Читать АДМ-команды %d", ServerInfo[NoCaps], ServerInfo[Locked], ServerInfo[Password], ServerInfo[GiveWeap], ServerInfo[GiveMoney], ServerInfo[ConnectMessages], ServerInfo[AdminCmdMsg] );
		SendClientMessage(playerid,blue,string);
		format(string, sizeof(string), " Авто-логин %d | Максимум предупрежд. %d | Чат %d | Должен залогиниться %d", ServerInfo[AutoLogin], ServerInfo[MaxMuteWarnings], ServerInfo[DisableChat], ServerInfo[MustLogin] );
		SendClientMessage(playerid,blue,string);
	}
	return 1;
}

dcmd_getinfo(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/getinfo [id игрока]");
		new player1, string[128];
		player1 = strval(params);

		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			new playerip[128], Float:x, Float:y, Float:z, tmp2[256], file[256],
			year, month, day, P1Jailed[4], P1Frozen[4], P1Logged[4], P1Register[4], RegDate[256], TimesOn;

			GetPlayerIp(player1, playerip, sizeof(playerip));
			GetPlayerPos(player1,x,y,z);
			getdate(year, month, day);
			format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(PlayerName2(player1)));

			if(PlayerInfo[player1][Jailed] == 1) P1Jailed = "Да"; else P1Jailed = "Нет";
			if(PlayerInfo[player1][Frozen] == 1) P1Frozen = "Да"; else P1Frozen = "Нет";
			if(PlayerInfo[player1][LoggedIn] == 1) P1Logged = "Да"; else P1Logged = "Нет";
			if(fexist(file)) P1Register = "Да"; else P1Register = "Нет";
			if(dUserINT(PlayerName2(player1)).("LastOn")==0) tmp2 = "Never"; else tmp2 = dini_Get(file,"LastOn");
			if(strlen(dini_Get(file,"RegisteredDate")) < 3) RegDate = "n/a"; else RegDate = dini_Get(file,"RegisteredDate");
			TimesOn = dUserINT(PlayerName2(player1)).("TimesOnServer");

			new Sum, Average, w;
			while (w < PING_MAX_EXCEEDS) {
				Sum += PlayerInfo[player1][pPing][w];
				w++;
			}
			Average = (Sum / PING_MAX_EXCEEDS);

			format(string, sizeof(string)," (Информация о игроке)  ---====> Ник: %s  ID: %d <====---", PlayerName2(player1), player1);
			SendClientMessage(playerid,lightblue,string);
			new Float:h[2]; GetPlayerHealth(player1,h[0]); GetPlayerArmour(player1,h[1]);
			format(string, sizeof(string)," Жизни: %d  Броня: %d  Рекорд: %d  Сумма: %d  Скин: %d  IP: %s  Пинг: %d  Средний Пинг: %d",h[0],h[1],
			GetPlayerScore(player1),GetPlayerMoney(player1),GetPlayerSkin(player1),playerip,GetPlayerPing(player1), Average );
			SendClientMessage(playerid,red,string);
			format(string, sizeof(string)," Внутренняя: %d  Виртуальный мир: %d  Розыск: %d  X %0.1f  Y %0.1f  Z %0.1f", GetPlayerInterior(player1), GetPlayerVirtualWorld(player1), GetPlayerWantedLevel(player1), Float:x,Float:y,Float:z);
			SendClientMessage(playerid,orange,string);
			format(string, sizeof(string)," На сервере: %d  Убил: %d  Смертей: %d  Коэфиц.: %0.2f  Админ уровень: %d", TimesOn, PlayerInfo[player1][Kills], PlayerInfo[player1][Deaths], Float:PlayerInfo[player1][Kills]/Float:PlayerInfo[player1][Deaths], PlayerInfo[player1][Level] );
			SendClientMessage(playerid,yellow,string);
			format(string, sizeof(string)," Зареган: %s  Залогинен: %s  Посажен: %s  Заморожен: %s", P1Register, P1Logged, P1Jailed, P1Frozen );
			SendClientMessage(playerid,green,string);
			format(string, sizeof(string)," Последн. на серве: %s  Дата регистрации: %s  Сегоднешняя дата: %d/%d/%d", tmp2, RegDate, day,month,year );
			SendClientMessage(playerid,COLOR_GREEN,string);

			if(IsPlayerInAnyVehicle(player1)) {
				new Float:VHealth, carid = GetPlayerVehicleID(playerid); GetVehicleHealth(carid,VHealth);
				format(string, sizeof(string)," ID Машины: %d  Модель: %d  Имя машины: %s  Здоровье машины: %d",carid, GetVehicleModel(carid), VehicleNames[GetVehicleModel(carid)-400], floatround(VHealth) );
				SendClientMessage(playerid,COLOR_BLUE,string);
			}

			new slot, ammo, weap, Count, WeapName[24], WeapSTR[128], p; WeapSTR = " Оружия: ";
			for (slot = 0; slot < 14; slot++) {	GetPlayerWeaponData(player1, slot, weap, ammo); if( ammo != 0 && weap != 0) Count++; }
			if(Count < 1) return SendClientMessage(playerid,lightblue," У игрока нет оружия");
			else {
				for (slot = 0; slot < 14; slot++)
				{
					GetPlayerWeaponData(player1, slot, weap, ammo);
					if (ammo > 0 && weap > 0)
					{
						GetWeaponName(weap, WeapName, sizeof(WeapName) );
						if (ammo == 65535 || ammo == 1) format(WeapSTR,sizeof(WeapSTR),"%s%s (1)",WeapSTR, WeapName);
						else format(WeapSTR,sizeof(WeapSTR),"%s%s (%d)",WeapSTR, WeapName, ammo);
						p++;
						if(p >= 5) { SendClientMessage(playerid, lightblue, WeapSTR); format(WeapSTR, sizeof(WeapSTR), "Weaps: "); p = 0;
						} else format(WeapSTR, sizeof(WeapSTR), "%s,  ", WeapSTR);
					}
				}
				if(p <= 4 && p > 0) {
					string[strlen(string)-3] = '.';
					SendClientMessage(playerid, lightblue, WeapSTR);
				}
			}
			return 1;
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 2 уровень, чтобы использовать эту команду");
}

dcmd_disable(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 7 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) {
			SendClientMessage(playerid,red,"{FFFFFF}/disable [antiswear / namekick / antispam / ping / readcmds / readpms /caps / admincmdmsgs");
			return SendClientMessage(playerid,red,"{FFFFFF}       /connectmsgs / autologin ]");
		}
		new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
		if(strcmp(params,"antiswear",true) == 0) {
			ServerInfo[AntiSwear] = 0;
			dini_IntSet(file,"AntiSwear",0);
			format(string,sizeof(string)," Админ %s выключил антимат", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"namekick",true) == 0) {
			ServerInfo[NameKick] = 0;
			dini_IntSet(file,"NameKick",0);
			format(string,sizeof(string)," Админ %s выключил кик ника", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"antispam",true) == 0)	{
			ServerInfo[AntiSpam] = 0;
			dini_IntSet(file,"AntiSpam",0);
			format(string,sizeof(string)," Админ %s выключил антиспам", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"ping",true) == 0)	{
			ServerInfo[MaxPing] = 0;
			dini_IntSet(file,"MaxPing",0);
			format(string,sizeof(string)," Админ %s выключил пинг кик", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"readcmds",true) == 0) {
			ServerInfo[ReadCmds] = 0;
			dini_IntSet(file,"ReadCMDs",0);
			format(string,sizeof(string)," Админ %s выключил читать команды", PlayerName2(playerid));
			MessageToAdmins(blue,string);
		} else if(strcmp(params,"readpms",true) == 0) {
			ServerInfo[ReadPMs] = 0;
			dini_IntSet(file,"ReadPMs",0);
			format(string,sizeof(string)," Админ %s выключил читать приваты", PlayerName2(playerid));
			MessageToAdmins(blue,string);
		} else if(strcmp(params,"caps",true) == 0)	{
			ServerInfo[NoCaps] = 1;
			dini_IntSet(file,"NoCaps",1);
			format(string,sizeof(string)," Админ %s выключил анти капс лок", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"admincmdmsgs",true) == 0) {
			ServerInfo[AdminCmdMsg] = 0;
			dini_IntSet(file,"AdminCMDMessages",0);
			format(string,sizeof(string)," Админ %s выключил коннект сообщения", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else if(strcmp(params,"connectmsgs",true) == 0)	{
			ServerInfo[ConnectMessages] = 0;
			dini_IntSet(file,"ConnectMessages",0);
			format(string,sizeof(string)," Админ %s выключил коннект и дисконнект сообщения", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else if(strcmp(params,"autologin",true) == 0)	{
			ServerInfo[AutoLogin] = 0;
			dini_IntSet(file,"AutoLogin",0);
			format(string,sizeof(string)," Админ %s выключил автологин", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else {
			SendClientMessage(playerid,red,"{FFFFFF}/disable [antiswear / namekick / antispam / ping / readcmds / readpms /caps /cmdmsg ]");
		} return 1;
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_enable(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 7 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) {
			SendClientMessage(playerid,red,"{FFFFFF}/enable [antiswear / namekick / antispam / ping / readcmds / readpms /caps / admincmdmsgs");
			return SendClientMessage(playerid,red,"{FFFFFF}       /connectmsgs / autologin ]");
		}
		new string[128], file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
		if(strcmp(params,"antiswear",true) == 0) {
			ServerInfo[AntiSwear] = 1;
			dini_IntSet(file,"AntiSwear",1);
			format(string,sizeof(string)," Админ %s включил антимат", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"namekick",true) == 0)	{
			ServerInfo[NameKick] = 1;
			format(string,sizeof(string),"*Админ %s включил кик ника", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"antispam",true) == 0)	{
			ServerInfo[AntiSpam] = 1;
			dini_IntSet(file,"AntiSpam",1);
			format(string,sizeof(string),"*Админ %s включил анти спам", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"ping",true) == 0)	{
			ServerInfo[MaxPing] = 800;
			dini_IntSet(file,"MaxPing",800);
			format(string,sizeof(string),"*Админ %s включил пинг кмк", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"readcmds",true) == 0)	{
			ServerInfo[ReadCmds] = 1;
			dini_IntSet(file,"ReadCMDs",1);
			format(string,sizeof(string),"*Админ %s включил читать команды", PlayerName2(playerid));
			MessageToAdmins(blue,string);
		} else if(strcmp(params,"readpms",true) == 0) {
			ServerInfo[ReadPMs] = 1;
			dini_IntSet(file,"ReadPMs",1);
			format(string,sizeof(string),"*Админ %s включил читать приваты", PlayerName2(playerid));
			MessageToAdmins(blue,string);
		} else if(strcmp(params,"caps",true) == 0)	{
			ServerInfo[NoCaps] = 0;
			dini_IntSet(file,"NoCaps",0);
			format(string,sizeof(string),"*Админ %s включил анти капс лок", PlayerName2(playerid));
			SendClientMessageToAll(blue,string);
		} else if(strcmp(params,"admincmdmsgs",true) == 0)	{
			ServerInfo[AdminCmdMsg] = 1;
			dini_IntSet(file,"AdminCmdMessages",1);
			format(string,sizeof(string),"*Админ %s включил читать админ команды", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else if(strcmp(params,"connectmsgs",true) == 0) {
			ServerInfo[ConnectMessages] = 1;
			dini_IntSet(file,"ConnectMessages",1);
			format(string,sizeof(string),"*Админ %s включил читать коннект и дисконнект сообщения", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else if(strcmp(params,"autologin",true) == 0) {
			ServerInfo[AutoLogin] = 1;
			dini_IntSet(file,"AutoLogin",1);
			format(string,sizeof(string),"*Админ %s включил автологин", PlayerName2(playerid));
			MessageToAdmins(green,string);
		} else {
			SendClientMessage(playerid,red,"{FFFFFF}/enable [antiswear / namekick / antispam / ping / readcmds / readpms /caps /cmdmsg ]");
		} return 1;
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_lweaps(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 9) {
		GivePlayerWeapon(playerid,28,1000); GivePlayerWeapon(playerid,31,1000); GivePlayerWeapon(playerid,34,1000);
		GivePlayerWeapon(playerid,38,1000); GivePlayerWeapon(playerid,16,1000);	GivePlayerWeapon(playerid,42,1000);
		GivePlayerWeapon(playerid,14,1000); GivePlayerWeapon(playerid,46,1000);	GivePlayerWeapon(playerid,9,1);
		GivePlayerWeapon(playerid,24,1000); GivePlayerWeapon(playerid,26,1000); return 1;
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 9 уровень, чтобы использовать эту команду");
}

dcmd_lammo(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		MaxAmmo(playerid);
		return CMDMessageToAdmins(playerid,"LAMMO");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 3 уровень, чтобы использовать эту команду");
}

dcmd_vr(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if (IsPlayerInAnyVehicle(playerid)) {
			SetVehicleHealth(GetPlayerVehicleID(playerid),1250.0);
			return SendClientMessage(playerid,COLOR_GREEN," Тачка зафиксирована");
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не в машине");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
}

dcmd_fix(playerid,params[])
{
	return dcmd_vr(playerid, params);
}

dcmd_repair(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if (IsPlayerInAnyVehicle(playerid)) {
			GetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), Pos[playerid][3]);
			SetPlayerCameraPos(playerid, 1929.0, 2137.0, 11.0);
			SetPlayerCameraLookAt(playerid,1935.0, 2138.0, 11.5);
			SetVehiclePos(GetPlayerVehicleID(playerid), 1974.0,2162.0,11.0);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), -90);
			SetTimerEx("RepairCar",5000,0,"i",playerid);
			return SendClientMessage(playerid,COLOR_GREEN," Ваша машина будет готова через 5 секунд...");
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не в машине");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
}

dcmd_ltune(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
			new LVehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(LVehicleID);
			switch(LModel)
			{
			case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
				return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете тюнинговать этот транспорт");
			}
			CMDMessageToAdmins(playerid,"LTUNE");
			SetVehicleHealth(LVehicleID,2000.0);
			TuneLCar(LVehicleID);
			return PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не в машине");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть 1, уровня чтобы использовать эту команду");
}

dcmd_lhy(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
			new LVehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(LVehicleID);
			switch(LModel)
			{
			case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
				return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете тюнинговать этот транспорт!");
			}
			AddVehicleComponent(LVehicleID, 1087);
			return PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не в машине");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть 1, уровня чтобы использовать эту команду");
}

dcmd_lcar(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if (!IsPlayerInAnyVehicle(playerid)) {
			CarSpawner(playerid,415);
			CMDMessageToAdmins(playerid,"LCAR");
			return SendClientMessage(playerid,COLOR_GREEN," Вы наколдовали себе машину");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас есть машина");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть 1 уровня, чтобы использовать эту команду");
}

dcmd_lbike(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if (!IsPlayerInAnyVehicle(playerid)) {
			CarSpawner(playerid,522);
			CMDMessageToAdmins(playerid,"LBIKE");
			return SendClientMessage(playerid,COLOR_GREEN," Вы наколдовали себе мотоцикл");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас есть машина");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть 1 уровня, чтобы использовать эту команду");
}

dcmd_lheli(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 2) {
		if (!IsPlayerInAnyVehicle(playerid)) {
			CarSpawner(playerid,487);
			CMDMessageToAdmins(playerid,"LHELI");
			return SendClientMessage(playerid,COLOR_GREEN," Вы наколдовали себе вертолет");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас есть машина");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть 2 уровня, чтобы использовать эту команду");
}

dcmd_lboat(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 2) {
		if (!IsPlayerInAnyVehicle(playerid)) {
			CarSpawner(playerid,493);
			CMDMessageToAdmins(playerid,"LBOAT");
			return SendClientMessage(playerid,COLOR_GREEN," Вы наколдовали себе лодку");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас есть машина");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть 2 уровня, чтобы использовать эту команду");
}

dcmd_lplane(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 2) {
		if (!IsPlayerInAnyVehicle(playerid)) {
			CarSpawner(playerid,513);
			CMDMessageToAdmins(playerid,"LPLANE");
			return SendClientMessage(playerid,COLOR_GREEN," Вы наколдовали себе самолет");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас есть машина");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть 2 уровня, чтобы использовать эту команду");
}

dcmd_lnos(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {
			switch(GetVehicleModel( GetPlayerVehicleID(playerid) )) {
			case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
				return SendClientMessage(playerid,red,"{FFFFFF}Вы не в машине!");
			}
			AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
			return PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть в машине.");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_linkcar(playerid,params[]) {
	#pragma unused params
	if(IsPlayerInAnyVehicle(playerid)) {
		LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(playerid));
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(playerid));
		return SendClientMessage(playerid,COLOR_GREEN, " Теперь ваш транспорт может находится в помещении");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть в транспорте.");
}

dcmd_car(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 4) {
		new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
		if(!strlen(tmp)) return SendClientMessage(playerid, red, " {FFFFFF}/car [id модели или имя] [цвет 1] [цвет 2]");
		new car, colour1, colour2, string[128];
		if(!IsNumeric(tmp)) car = GetVehicleModelIDFromName(tmp); else car = strval(tmp);
		if(car < 400 || car > 611) return  SendClientMessage(playerid, red, " {FFFFFF}Не верная модель транспорта");
		if(!strlen(tmp2)) colour1 = random(126); else colour1 = strval(tmp2);
		if(!strlen(tmp3)) colour2 = random(126); else colour2 = strval(tmp3);
		if(PlayerInfo[playerid][pCar] != -1 && !IsPlayerAdmin(playerid) ) CarDeleter(PlayerInfo[playerid][pCar]);
		new LVehicleID,Float:X,Float:Y,Float:Z, Float:Angle,int1;	GetPlayerPos(playerid, X,Y,Z);	GetPlayerFacingAngle(playerid,Angle);   int1 = GetPlayerInterior(playerid);
		LVehicleID = CreateVehicle(car, X+3,Y,Z, Angle, colour1, colour2, -1); LinkVehicleToInterior(LVehicleID,int1);
		PlayerInfo[playerid][pCar] = LVehicleID;
		CMDMessageToAdmins(playerid,"CAR");
		format(string, sizeof(string), " %s наколдовал себе транспорт %s(ID модели:%d) с цветами (%d, %d), at %0.2f, %0.2f, %0.2f", pName(playerid), VehicleNames[car-400], car, colour1, colour2, X, Y, Z);
		SaveToFile("CarSpawns",string);
		format(string, sizeof(string), " Вы наколдовали себе транспорт %s(ID модели:%d) с цветами (%d, %d)", VehicleNames[car-400], car, colour1, colour2);
		return SendClientMessage(playerid,COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 4 уровень, чтобы использовать эту команду");
}

dcmd_carhealth(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 4) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/carhealth [id игрока] [здоровье]");
		new player1 = strval(tmp), health = strval(tmp2), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(IsPlayerInAnyVehicle(player1)) {
				CMDMessageToAdmins(playerid,"CARHEALTH");
				format(string, sizeof(string), " Вы установили игроку %s здоровье транспорта на %d", pName(player1), health); SendClientMessage(playerid,COLOR_GREEN,string);
				if(player1 != playerid) { format(string,sizeof(string)," Админ %s установил здоровье вашего транспорта на%d", pName(playerid), health); SendClientMessage(player1,COLOR_GREEN,string); }
				return SetVehicleHealth(GetPlayerVehicleID(player1), health);
			} else return SendClientMessage(playerid,red,"{FFFFFF}Игрок не в машине");
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_carcolour(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1) {
		new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "{FFFFFF}/carcolour [id игрока] [цвет 1] [цвет 2]");
		new player1 = strval(tmp), colour1, colour2, string[128];
		if(!strlen(tmp2)) colour1 = random(126); else colour1 = strval(tmp2);
		if(!strlen(tmp3)) colour2 = random(126); else colour2 = strval(tmp3);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(IsPlayerInAnyVehicle(player1)) {
				CMDMessageToAdmins(playerid,"CARCOLOUR");
				format(string, sizeof(string), " Вы изменили цвет игроку %s транспорта %s на %d,%d", pName(player1), VehicleNames[GetVehicleModel(GetPlayerVehicleID(player1))-400], colour1, colour2 ); SendClientMessage(playerid,COLOR_GREEN,string);
				if(player1 != playerid) { format(string,sizeof(string)," Админ %s изменил цвет вашего транспорта %s на %d,%d", pName(playerid), VehicleNames[GetVehicleModel(GetPlayerVehicleID(player1))-400], colour1, colour2 ); SendClientMessage(player1,COLOR_GREEN,string); }
				return ChangeVehicleColor(GetPlayerVehicleID(player1), colour1, colour2);
			} else return SendClientMessage(playerid,red,"{FFFFFF}Игрок не в машине");
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_god(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8 || IsPlayerAdmin(playerid)) {
		if(PlayerInfo[playerid][God] == 0)	{
			PlayerInfo[playerid][God] = 1;
			SetPlayerHealth(playerid,100000);
			GivePlayerWeapon(playerid,16,50000); GivePlayerWeapon(playerid,26,50000);
			SendClientMessage(playerid,green," ВКЛЮЧЕН РЕЖИМ БОГА");
			return CMDMessageToAdmins(playerid,"GOD");
		} else {
			PlayerInfo[playerid][God] = 0;
			SendClientMessage(playerid,red,"{FFFFFF} ВЫКЛЮЧЕН РЕЖИМ БОГА");
			SetPlayerHealth(playerid, 100);
		} return GivePlayerWeapon(playerid,35,0);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_sgod(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 10 || IsPlayerAdmin(playerid)) {
		if(PlayerInfo[playerid][God] == 0)	{
			PlayerInfo[playerid][God] = 1;
			SetPlayerHealth(playerid,100000);
			GivePlayerWeapon(playerid,16,50000); GivePlayerWeapon(playerid,26,50000);
			return SendClientMessage(playerid,green," ВКЛЮЧЕН РЕЖИМ БОГА");
		} else	{
			PlayerInfo[playerid][God] = 0;
			SendClientMessage(playerid,red,"{FFFFFF} ВЫКЛЮЧЕН РЕЖИМ БОГА");
			SetPlayerHealth(playerid, 100); return GivePlayerWeapon(playerid,35,0);	}
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 10 уровень");
}

dcmd_godcar(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8 || IsPlayerAdmin(playerid)) {
		if(IsPlayerInAnyVehicle(playerid)) {
			if(PlayerInfo[playerid][GodCar] == 0) {
				PlayerInfo[playerid][GodCar] = 1;
				CMDMessageToAdmins(playerid,"GODCAR");
				return SendClientMessage(playerid,green," ВАША ТАЧКА НЕ УЯЗВИМА");
			} else {
				PlayerInfo[playerid][GodCar] = 0;
				return SendClientMessage(playerid,red,"{FFFFFF} ВАША ТАЧКА УЯЗВИМА"); }
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть в машине");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_die(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 9 || IsPlayerAdmin(playerid)) {
		new Float:x, Float:y, Float:z ;
		GetPlayerPos( playerid, Float:x, Float:y, Float:z );
		CreateExplosion(Float:x+10, Float:y, Float:z, 8,10.0);
		CreateExplosion(Float:x-10, Float:y, Float:z, 8,10.0);
		CreateExplosion(Float:x, Float:y+10, Float:z, 8,10.0);
		CreateExplosion(Float:x, Float:y-10, Float:z, 8,10.0);
		CreateExplosion(Float:x+10, Float:y+10, Float:z, 8,10.0);
		CreateExplosion(Float:x-10, Float:y+10, Float:z, 8,10.0);
		return CreateExplosion(Float:x-10, Float:y-10, Float:z, 8,10.0);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 9 уровень");
}

dcmd_getid(playerid,params[]) {
	if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/getid [ник]");
	new found, string[128], playername[MAX_PLAYER_NAME];
	format(string,sizeof(string)," Инфо о: %s",params);
	SendClientMessage(playerid,COLOR_GREEN,string);
	for(new i=0; i <= GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			GetPlayerName(i, playername, MAX_PLAYER_NAME);
			new namelen = strlen(playername);
			new bool:searched=false;
			for(new pos=0; pos <= namelen; pos++)
			{
				if(searched != true)
				{
					if(strfind(playername,params,true) == pos)
					{
						found++;
						format(string,sizeof(string),"%d. %s (ID: %d)",found,playername,i);
						SendClientMessage(playerid, green ,string);
						searched = true;
					}
				}
			}
		}
	}
	if(found == 0) SendClientMessage(playerid, lightblue, " Нет такого игрока или неверное имя");
	return 1;
}

dcmd_asay(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 2) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/asay [текст]");
		new string[128]; format(string, sizeof(string), "**Админ %s: %s", PlayerName2(playerid), params[0] );
		return SendClientMessageToAll(COLOR_VIOLET,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 2 уровень");
}

dcmd_setping(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 7 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setping [пинг] (0-чтобы выключить)");
		new string[128], ping = strval(params);
		ServerInfo[MaxPing] = ping;
		CMDMessageToAdmins(playerid,"SETPING");
		new file[256]; format(file,sizeof(file),"ladmin/config/Config.ini");
		dini_IntSet(file,"MaxPing",ping);
		for(new i = 0; i <= GetMaxPlayers(); i++) if(IsPlayerConnected(i)) PlayerPlaySound(i,1057,0.0,0.0,0.0);
		if(ping == 0) format(string,sizeof(string)," Админ %s выключил максимальный пинг", PlayerName2(playerid), ping);
		else format(string,sizeof(string)," Админ %s изменил максимальный пинг на %d", PlayerName2(playerid), ping);
		return SendClientMessageToAll(COLOR_GREEN,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 7 уровень");
}

dcmd_ping(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/ping [id игрока]");
		new player1 = strval(params), string[128];
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			new Sum, Average, x;
			while (x < PING_MAX_EXCEEDS) {
				Sum += PlayerInfo[player1][pPing][x];
				x++;
			}
			Average = (Sum / PING_MAX_EXCEEDS);
			format(string, sizeof(string), " %s(id %d) Его пинг: %d   (Пинг меняется: %d, %d, %d, %d)", PlayerName2(player1), player1, Average, PlayerInfo[player1][pPing][0], PlayerInfo[player1][pPing][1], PlayerInfo[player1][pPing][2], PlayerInfo[player1][pPing][3] );
			return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_highlight(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/highlight [id игрока]");
		new player1, playername[MAX_PLAYER_NAME], string[128];
		player1 = strval(params);

		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			GetPlayerName(player1, playername, sizeof(playername));
			if(PlayerInfo[player1][blip] == 0) {
				CMDMessageToAdmins(playerid,"HIGHLIGHT");
				PlayerInfo[player1][pColour] = GetPlayerColor(player1);
				PlayerInfo[player1][blip] = 1;
				BlipTimer[player1] = SetTimerEx("HighLight", 1000, 1, "i", player1);
				format(string,sizeof(string)," Вы сделали мигающим цвет ника %s", playername);
			} else {
				KillTimer( BlipTimer[player1] );
				PlayerInfo[player1][blip] = 0;
				SetPlayerColor(player1, PlayerInfo[player1][pColour] );
				format(string,sizeof(string)," Вы остановили мигание ника %s", playername);
			}
			return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_setgravity(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 5) {
		if(!strlen(params)||!(strval(params)<=50&&strval(params)>=-50)) return SendClientMessage(playerid,red,"{FFFFFF}/setgravity <-50.0 - 50.0>");
		CMDMessageToAdmins(playerid,"SETGRAVITY");
		new string[128],adminname[MAX_PLAYER_NAME]; GetPlayerName(playerid, adminname, sizeof(adminname)); new Float:Gravity = floatstr(params);format(string,sizeof(string),"Admnistrator %s has set the gravity to %f",adminname,Gravity);
		SetGravity(Gravity); return SendClientMessageToAll(blue,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_lcredits(playerid,params[]) {
	#pragma unused params
	return SendClientMessage(playerid,green,"LAdmin. Админскрипт для sa-mp 0.2.x. Создатель: LethaL. Переводчик: Alien Версия: 4. Релиз: 07/2008");
}

dcmd_serverinfo(playerid,params[]) {
	#pragma unused params
	new TotalVehicles = CreateVehicle(411, 0, 0, 0, 0, 0, 0, 1000);    DestroyVehicle(TotalVehicles);
	new numo = CreateObject(1245,0,0,1000,0,0,0);	DestroyObject(numo);
	new nump = CreatePickup(371,2,0,0,1000);	DestroyPickup(nump);
	new gz = GangZoneCreate(3,3,5,5);	GangZoneDestroy(gz);

	new model[250], nummodel;
	for(new i=1;i<TotalVehicles;i++) model[GetVehicleModel(i)-400]++;
	for(new i=0;i<250;i++)	if(model[i]!=0)	nummodel++;

	new string[256];
	format(string,sizeof(string)," Инфо о серве: [ Игроков: %d || Максимум: %d ] [Пропорция %0.2f ]",ConnectedPlayers(),GetMaxPlayers(),Float:ConnectedPlayers() / Float:GetMaxPlayers() );
	SendClientMessage(playerid,green,string);
	format(string,sizeof(string)," Инфо о серве: [ Машин: %d || Моделей %d || Игроков в машинах: %d || В тачке %d / На мотах %d ]",TotalVehicles-1,nummodel, InVehCount(),InCarCount(),OnBikeCount() );
	SendClientMessage(playerid,green,string);
	format(string,sizeof(string)," Инфо о серве: [ Объектов: %d || Пикапы %d || Ганг-зон %d ]",numo-1, nump, gz);
	SendClientMessage(playerid,green,string);
	format(string,sizeof(string)," Инфо о серве: [ посажено игроков %d || Заморожено игроков %d || Заткнуто %d ]",JailedPlayers(),FrozenPlayers(), MutedPlayers() );
	return SendClientMessage(playerid,green,string);
}

dcmd_announce(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/announce <текст>");
		CMDMessageToAdmins(playerid,"ANNOUNCE");
		return GameTextForAll(params,4000,3);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
}

dcmd_announce2(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1 || IsPlayerAdmin(playerid)) {
		new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index) ,tmp3 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!strlen(tmp3)) return SendClientMessage(playerid,red,"{FFFFFF}/announce <стиль> <время> <текст>");
		if(!(strval(tmp) >= 0 && strval(tmp) <= 6) || strval(tmp) == 2)	return SendClientMessage(playerid,red,"{FFFFFF}Неверный стиль текста. Range: 0 - 6");
		CMDMessageToAdmins(playerid,"ANNOUNCE2");
		return GameTextForAll(tmp3,strval(tmp2),strval(tmp) );
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
}

dcmd_lslowmo(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		new Float:x, Float:y, Float:z; GetPlayerPos(playerid, x, y, z); CreatePickup(1241, 4, x, y, z);
		return CMDMessageToAdmins(playerid,"LSLOWMO");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_jetpack(playerid,params[]) {
	if(!strlen(params))	{
		if(PlayerInfo[playerid][Level] >= 1 || IsPlayerAdmin(playerid)) {
			SendClientMessage(playerid,blue," Вы получили летающий ранец.");
			CMDMessageToAdmins(playerid,"JETPACK");
			return SetPlayerSpecialAction(playerid, 2);
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
	} else {
		new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
		player1 = strval(params);
		if(PlayerInfo[playerid][Level] >= 4)	{
			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)	{
				CMDMessageToAdmins(playerid,"JETPACK");		SetPlayerSpecialAction(player1, 2);
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
				format(string,sizeof(string)," Админ %s дал вам летающий ранец",adminname); SendClientMessage(player1,COLOR_GREEN,string);
				format(string,sizeof(string)," Вы дали игроку %s летающий ранец", playername);
				return SendClientMessage(playerid,COLOR_GREEN,string);
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
	}
}

dcmd_destroycar(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 4) return EraseVehicle(GetPlayerVehicleID(playerid));
	else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}
dcmd_ltc(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(!IsPlayerInAnyVehicle(playerid)) {
			if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
			new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
			LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); CMDMessageToAdmins(playerid,"LTunedCar");	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);
			AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
			AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
			AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,0);
			SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
			return PlayerInfo[playerid][pCar] = LVehicleIDt;
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас есть машина");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
}

dcmd_warp(playerid,params[])
{
	return dcmd_teleplayer(playerid,params);
}

dcmd_teleplayer(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 4 || IsPlayerAdmin(playerid)) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp) || !IsNumeric(tmp2)) return SendClientMessage(playerid, red, "{FFFFFF}/warp или /teleplayer [id 1-ого игрока] к [id 2-ого игрока]");
		new player1 = strval(tmp), player2 = strval(tmp2), string[128], Float:plocx,Float:plocy,Float:plocz;
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(IsPlayerConnected(player2) && player2 != INVALID_PLAYER_ID) {
				CMDMessageToAdmins(playerid,"TELEPLAYER");
				GetPlayerPos(player2, plocx, plocy, plocz);
				new intid = GetPlayerInterior(player2);	SetPlayerInterior(player1,intid);
				SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(player2));
				if (GetPlayerState(player1) == PLAYER_STATE_DRIVER)
				{
					new VehicleID = GetPlayerVehicleID(player1);
					SetVehiclePos(VehicleID, plocx, plocy+4, plocz); LinkVehicleToInterior(VehicleID,intid);
					SetVehicleVirtualWorld(VehicleID, GetPlayerVirtualWorld(player2) );
				}
				else SetPlayerPos(player1,plocx,plocy+2, plocz);
				format(string,sizeof(string)," Админ %s телепортировал %s к %s", pName(playerid), pName(player1), pName(player2) );
				SendClientMessage(player1,COLOR_GREEN,string); SendClientMessage(player2,blue,string);
				format(string,sizeof(string)," Вы телепортировали игрока %s к %s", pName(player1), pName(player2) );
				return SendClientMessage(playerid,COLOR_GREEN,string);
			} else return SendClientMessage(playerid, red, " Нет второго игрока");
		} else return SendClientMessage(playerid, red, " Нет первого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_goto(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/goto [id игрока через запятую]");
		new player1 = strval(params), playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"GOTO");
			new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z); SetPlayerInterior(playerid,GetPlayerInterior(player1));
			SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(player1));
			if(GetPlayerState(playerid) == 2)	{
				SetVehiclePos(GetPlayerVehicleID(playerid),x+3,y,z);	LinkVehicleToInterior(GetPlayerVehicleID(playerid),GetPlayerInterior(player1));
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),GetPlayerVirtualWorld(player1));
			} else SetPlayerPos(playerid,x+2,y,z);
			GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
			//format(string,sizeof(string),"Administrator %s has teleported to you",adminname);	SendClientMessage(player1,blue,string);
			format(string,sizeof(string)," Вы телепортировались к %s", playername); return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_vgoto(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/vgoto [id машины]");
		new player1, string[128];
		player1 = strval(params);
		CMDMessageToAdmins(playerid,"VGOTO");
		new Float:x, Float:y, Float:z;	GetVehiclePos(player1,x,y,z);
		SetPlayerVirtualWorld(playerid,GetVehicleVirtualWorld(player1));
		if(GetPlayerState(playerid) == 2)	{
			SetVehiclePos(GetPlayerVehicleID(playerid),x+3,y,z);
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetVehicleVirtualWorld(player1) );
		} else SetPlayerPos(playerid,x+2,y,z);
		format(string,sizeof(string)," Вы телепортировались к машине %d", player1);
		return SendClientMessage(playerid,COLOR_GREEN,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_vget(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/vget [id машины]");
		new player1, string[128];
		player1 = strval(params);
		CMDMessageToAdmins(playerid,"VGET");
		new Float:x, Float:y, Float:z;	GetPlayerPos(playerid,x,y,z);
		SetVehiclePos(player1,x+3,y,z);
		SetVehicleVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
		format(string,sizeof(string)," Вы телепортировали к себе машину %d", player1);
		return SendClientMessage(playerid,COLOR_GREEN,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_lgoto(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
		new Float:x, Float:y, Float:z;
		new tmp[256], tmp2[256], tmp3[256];
		new string[128], Index;	tmp = strtok(params,Index); tmp2 = strtok(params,Index); tmp3 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3)) return SendClientMessage(playerid,red,"{FFFFFF}/lgoto [x] [y] [z]");
		x = strval(tmp);		y = strval(tmp2);		z = strval(tmp3);
		CMDMessageToAdmins(playerid,"LGOTO");
		if(GetPlayerState(playerid) == 2) SetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
		else SetPlayerPos(playerid,x,y,z);
		format(string,sizeof(string)," Вы телепортированы на %f, %f, %f", x,y,z); return SendClientMessage(playerid,COLOR_GREEN,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_givecar(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/givecar [id игрока]");
		new player1 = strval(params), playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerInAnyVehicle(player1)) return SendClientMessage(playerid,red,"{FFFFFF}У игрока есть машина");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"GIVECAR");
			new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z);
			CarSpawner(player1,415);
			GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string,sizeof(string)," Админ %s дал вам машину",adminname);	SendClientMessage(player1,COLOR_GREEN,string);
			format(string,sizeof(string)," Вы дали игроку %s машину", playername); return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_gethere(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 4) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/gethere [id игрока]");
		new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
		player1 = strval(params);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"GETHERE");
			new Float:x, Float:y, Float:z;	GetPlayerPos(playerid,x,y,z); SetPlayerInterior(player1,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
			if(GetPlayerState(player1) == 2)	{
				new VehicleID = GetPlayerVehicleID(player1);
				SetVehiclePos(VehicleID,x+3,y,z);   LinkVehicleToInterior(VehicleID,GetPlayerInterior(playerid));
				SetVehicleVirtualWorld(GetPlayerVehicleID(player1),GetPlayerVirtualWorld(playerid));
			} else SetPlayerPos(player1,x+2,y,z);
			GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string,sizeof(string)," Админ %s телепортировал вас к себе",adminname);	SendClientMessage(player1,COLOR_GREEN,string);
			format(string,sizeof(string)," Вы телепортировали %s к себе", playername); return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_get(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3|| IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/get [id игрока]");
		new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
		player1 = strval(params);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"GET");
			new Float:x, Float:y, Float:z;	GetPlayerPos(playerid,x,y,z); SetPlayerInterior(player1,GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(player1,GetPlayerVirtualWorld(playerid));
			if(GetPlayerState(player1) == 2)	{
				new VehicleID = GetPlayerVehicleID(player1);
				SetVehiclePos(VehicleID,x+3,y,z);   LinkVehicleToInterior(VehicleID,GetPlayerInterior(playerid));
				SetVehicleVirtualWorld(GetPlayerVehicleID(player1),GetPlayerVirtualWorld(playerid));
			} else SetPlayerPos(player1,x+2,y,z);
			GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string,sizeof(string)," Админ %s доставил вас к себе",adminname);	SendClientMessage(player1,COLOR_GREEN,string);
			format(string,sizeof(string)," Вы доставили игрока %s к себе", playername); return SendClientMessage(playerid,COLOR_GREEN,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_fu(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/fu [id игрока]");
		new player1 = strval(params), string[128], NewName[MAX_PLAYER_NAME];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать эту команду на админов");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"FU");
			SetPlayerHealth(player1,1.0); SetPlayerArmour(player1,0.0); ResetPlayerWeapons(player1);ResetPlayerMoney(player1);GivePlayerWeapon(player1,12,1);
			SetPlayerSkin(player1, 137); SetPlayerScore(player1, 0); SetPlayerColor(player1,COLOR_PINK); SetPlayerWeather(player1,19); SetPlayerWantedLevel(player1,6);
			format(NewName,sizeof(NewName),"[Hy6]%s", pName(player1) ); SetPlayerName(player1,NewName);
			if(IsPlayerInAnyVehicle(player1)) EraseVehicle(GetPlayerVehicleID(player1));
			if(player1 != playerid)	{ format(string,sizeof(string)," ~w~%s: ~r~TS HY6", pName(playerid) ); GameTextForPlayer(player1, string, 2500, 3); }
			format(string,sizeof(string)," Вы сделали нубом %s", pName(player1) ); return SendClientMessage(playerid,blue,string);
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_warn(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
		new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/warn [id игрока] [причина]");
		new warned = strval(tmp), str[128];
		if(PlayerInfo[warned][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(warned) && warned != INVALID_PLAYER_ID) {
			if(warned != playerid) {
				CMDMessageToAdmins(playerid,"WARN");
				PlayerInfo[warned][Warnings]++;
				if( PlayerInfo[warned][Warnings] == MAX_WARNINGS) {
					format(str, sizeof (str), "***Админ %s предупредил игрока %s по причине: %s (Всего причин: %d/%d)***", pName(playerid), pName(warned), params[1+strlen(tmp)], PlayerInfo[warned][Warnings], MAX_WARNINGS);
					SendClientMessageToAll(COLOR_RED, str);
					SaveToFile("KickLog",str);	Kick(warned);
					return PlayerInfo[warned][Warnings] = 0;
				} else {
					format(str, sizeof (str), "***Админ %s предупредил игрока %s по причине %s (Всего причин: %d/%d)***", pName(playerid), pName(warned), params[1+strlen(tmp)], PlayerInfo[warned][Warnings], MAX_WARNINGS);
					return SendClientMessageToAll(yellow, str);
				}
			} else return SendClientMessage(playerid, red, " {FFFFFF}Вы не можете предупредить себя");
		} else return SendClientMessage(playerid, red, " {FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_kick(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3) {
			new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/kick [id] [причина]");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
				CMDMessageToAdmins(playerid,"KICK");
				if(!strlen(tmp2)) {
					format(string,sizeof(string)," Игрока %s кикнул админ %s [нет причины] ",playername,adminname); SendClientMessageToAll(COLOR_RED,string);
					SaveToFile("KickLog",string); print(string); return Kick(player1);
				} else {
					format(string,sizeof(string)," %s кикнул админ %s [причина: %s] ",playername,adminname,params[2]); SendClientMessageToAll(COLOR_RED,string);
					SaveToFile("KickLog",string); print(string); return Kick(player1); }
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не авторизованы");
}

dcmd_ban(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 7) {
			new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/ban [id] [причина]");
			if(!strlen(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}Вы должны ввести причину");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
				new year,month,day,hour,minuite,second; getdate(year, month, day); gettime(hour,minuite,second);
				CMDMessageToAdmins(playerid,"BAN");
				format(string,sizeof(string)," Игрок %s забанен админом %s [причина: %s] [Дата: %d/%d/%d] [Время: %d:%d]",playername,adminname,params[2],day,month,year,hour,minuite);
				SendClientMessageToAll(COLOR_RED,string);
				SaveToFile("BanLog",string);
				print(string);
				if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("banned",0);
				format(string,sizeof(string)," Забанен админом %s. Причина: %s", adminname, params[2] );
				return BanEx(player1, string);
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_rban(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 9) {
			new ip[128], tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/rban [id игрока] [причина]");
			if(!strlen(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}Вы должны ввести причину");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
				new year,month,day,hour,minuite,second; getdate(year, month, day); gettime(hour,minuite,second);
				CMDMessageToAdmins(playerid,"RBAN");
				format(string,sizeof(string)," Игрок %s забанен на один раунд админом %s [причина: %s] [Дата: %d/%d/%d] [Время: %d:%d]",playername,adminname,params[2],day,month,year,hour,minuite);
				SendClientMessageToAll(COLOR_RED,string);
				SaveToFile("BanLog",string);
				print(string);
				if(udb_Exists(PlayerName2(player1)) && PlayerInfo[player1][LoggedIn] == 1) dUserSetINT(PlayerName2(player1)).("banned",1);
				GetPlayerIp(player1,ip,sizeof(ip));
				strdel(ip,strlen(ip)-2,strlen(ip));
				format(ip,128,"%s**",ip);
				format(ip,128,"banip %s",ip);
				SendRconCommand(ip);
				return 1;
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_slap(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
			new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/slap [id игрока] [причина]");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
				CMDMessageToAdmins(playerid,"SLAP");
				new Float:hp; GetPlayerHealth(player1,hp);
				new Float:x, Float:y, Float:z; SetPlayerHealth(player1,hp-25);
				GetPlayerPos(player1,x,y,z); SetPlayerPos(player1,x,y,z+5); PlayerPlaySound(playerid,1190,0.0,0.0,0.0); PlayerPlaySound(player1,1190,0.0,0.0,0.0);

				if(strlen(tmp2)) {
					format(string,sizeof(string)," Вас пнул администратор %s по причине %s ",adminname,params[2]);	SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," Вы пнули игрока %s по причине %s ",playername,params[2]); return SendClientMessage(playerid,COLOR_RED,string);
				} else {
					format(string,sizeof(string)," Вас пнул администратор %s ",adminname);	SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," Вы пнули игрока %s",playername); return SendClientMessage(playerid,COLOR_RED,string); }
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_explode(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3) {
			new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/explode [id игрока] [причина]");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				GetPlayerName(player1, playername, sizeof(playername)); 	GetPlayerName(playerid, adminname, sizeof(adminname));
				CMDMessageToAdmins(playerid,"EXPLODE");
				new Float:burnx, Float:burny, Float:burnz; GetPlayerPos(player1,burnx, burny, burnz); CreateExplosion(burnx, burny , burnz, 7,10.0);

				if(strlen(tmp2)) {
					format(string,sizeof(string)," Вы были взорваны админом %s [причина: %s]",adminname,params[2]); SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," Вы взорвали игрока %s [причина: %s]", playername,params[2]); return SendClientMessage(playerid,COLOR_RED,string);
				} else {
					format(string,sizeof(string)," Вы были взорваны админом %s",adminname); SendClientMessage(player1,COLOR_RED,string);
					format(string,sizeof(string)," Вы взорвали игрока %s", playername); return SendClientMessage(playerid,COLOR_RED,string); }
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_jail(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3) {
			new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/jail [id игрока] [минуты] [причина]");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				if(PlayerInfo[player1][Jailed] == 0) {
					GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
					new jtime = strval(tmp2);
					if(jtime == 0) jtime = 9999;

					SetPVarInt(player1,"inJail",1);
					CMDMessageToAdmins(playerid,"JAIL");
					PlayerInfo[player1][JailTime] = jtime*1000*60;
					SetTimerEx("JailPlayer",5000,0,"d",player1);
					SetTimerEx("Jail1",1000,0,"d",player1);
					PlayerInfo[player1][Jailed] = 1;

					if(jtime == 9999) {
						if(!strlen(params[strlen(tmp2)+1])) format(string,sizeof(string)," Админ %s посадил %s ",adminname, playername);
						else format(string,sizeof(string)," Админ %s посадил игрока %s [причина: %s]",adminname, playername, params[strlen(tmp)+1] );
					} else {
						if(!strlen(tmp3)) format(string,sizeof(string)," Админ %s посадил игрока %s на %d минут",adminname, playername, jtime);
						else format(string,sizeof(string)," Админ %s посадил игрока %s на %d минут [причина: %s]",adminname, playername, jtime, params[strlen(tmp2)+strlen(tmp)+1] );
					}
					return SendClientMessageToAll(COLOR_RED,string);
				} else return SendClientMessage(playerid, red, " Игрок уже посажен");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_unjail(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3) {
			new tmp[256], Index; tmp = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/unjail [id игрока]");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				if(PlayerInfo[player1][Jailed] == 1) {
					SetPVarInt(player1,"inJail",0);
					GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
					format(string,sizeof(string)," Админ %s выпустил тебя",adminname);	SendClientMessage(player1,COLOR_GREEN,string);
					format(string,sizeof(string)," Админ %s выпустил %s",adminname, playername);
					JailRelease(player1);
					return SendClientMessageToAll(COLOR_GREEN,string);
				} else return SendClientMessage(playerid, red, " Игрок не посажен");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_jailed(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
			new bool:First2 = false, Count, adminname[MAX_PLAYER_NAME], string[128], i;
			for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Jailed]) Count++;
			if(Count == 0) return SendClientMessage(playerid,red, " Нет посаженых игроков");

			for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Jailed]) {
				GetPlayerName(i, adminname, sizeof(adminname));
				if(!First2) { format(string, sizeof(string), " Посаженые игроки: (%d)%s", i,adminname); First2 = true; }
				else format(string,sizeof(string),"%s, (%d)%s ",string,i,adminname);
			}
			return SendClientMessage(playerid,COLOR_WHITE,string);
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_freeze(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3) {
			new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/freeze [id игрока] [минуты] [причина]");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(PlayerInfo[player1][Frozen] == 0) {
					GetPlayerName(player1, playername, sizeof(playername)); GetPlayerName(playerid, adminname, sizeof(adminname));
					new ftime = strval(tmp2);
					if(ftime == 0) ftime = 9999;

					CMDMessageToAdmins(playerid,"FREEZE");
					TogglePlayerControllable(player1,false); PlayerInfo[player1][Frozen] = 1; PlayerPlaySound(player1,1057,0.0,0.0,0.0);
					PlayerInfo[player1][FreezeTime] = ftime*1000*60;
					FreezeTimer[player1] = SetTimerEx("UnFreezeMe",PlayerInfo[player1][FreezeTime],0,"d",player1);

					if(ftime == 9999) {
						if(!strlen(params[strlen(tmp2)+1])) format(string,sizeof(string)," Админ %s заморозил %s ",adminname, playername);
						else format(string,sizeof(string)," Админ %s заморозил %s [причина: %s]",adminname, playername, params[strlen(tmp)+1] );
					} else {
						if(!strlen(tmp3)) format(string,sizeof(string)," Админ %s заморозил %s на %d минут",adminname, playername, ftime);
						else format(string,sizeof(string)," Админ %s заморозил %s на %d минут [причина: %s]",adminname, playername, ftime, params[strlen(tmp2)+strlen(tmp)+1] );
					}
					return SendClientMessageToAll(COLOR_RED,string);
				} else return SendClientMessage(playerid, red, " Игрок уже заморожен");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_unfreeze(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3|| IsPlayerAdmin(playerid)) {
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/unfreeze [id игрока]");
			new player1, string[128];
			player1 = strval(params);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(PlayerInfo[player1][Frozen] == 1) {
					CMDMessageToAdmins(playerid,"UNFREEZE");
					UnFreezeMe(player1);
					format(string,sizeof(string)," Админ %s разморозил вас", PlayerName2(playerid) ); SendClientMessage(player1,COLOR_GREEN,string);
					format(string,sizeof(string)," Админ %s разморозил %s", PlayerName2(playerid), PlayerName2(player1));
					return SendClientMessageToAll(COLOR_GREEN,string);
				} else return SendClientMessage(playerid, red, " Игрок не заморожен");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_frozen(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
			new bool:First2 = false, Count, adminname[MAX_PLAYER_NAME], string[128], i;
			for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Frozen]) Count++;
			if(Count == 0) return SendClientMessage(playerid,red, " Нет замороженых игроков");

			for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Frozen]) {
				GetPlayerName(i, adminname, sizeof(adminname));
				if(!First2) { format(string, sizeof(string), " Замороженые игроки: (%d)%s", i,adminname); First2 = true; }
				else format(string,sizeof(string),"%s, (%d)%s ",string,i,adminname);
			}
			return SendClientMessage(playerid,COLOR_WHITE,string);
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_mute(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
			new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/mute [id игрока] [причина]");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				if(PlayerInfo[player1][Muted] == 0) {
					GetPlayerName(player1, playername, sizeof(playername)); 	GetPlayerName(playerid, adminname, sizeof(adminname));
					CMDMessageToAdmins(playerid,"MUTE");
					PlayerPlaySound(player1,1057,0.0,0.0,0.0);  PlayerInfo[player1][Muted] = 1; PlayerInfo[player1][MuteWarnings] = 0;

					if(strlen(tmp2)) {
						format(string,sizeof(string)," Вы были заткнуты админом %s [причина: %s]",adminname,params[2]); SendClientMessage(player1,COLOR_RED,string);
						format(string,sizeof(string)," Вы заткнули игрока %s [причина: %s]", playername,params[2]); return SendClientMessage(playerid,COLOR_RED,string);
					} else {
						format(string,sizeof(string)," Вы были заткнуты админом %s",adminname); SendClientMessage(player1,COLOR_RED,string);
						format(string,sizeof(string)," Вы заткнули игрока %s", playername); return SendClientMessage(playerid,COLOR_RED,string); }
				} else return SendClientMessage(playerid, red, " Игрок уже заткнут");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_unmute(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/unmute [id игрока]");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(params);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
				if(PlayerInfo[player1][Muted] == 1) {
					GetPlayerName(player1, playername, sizeof(playername)); 	GetPlayerName(playerid, adminname, sizeof(adminname));
					CMDMessageToAdmins(playerid,"UNMUTE");
					PlayerPlaySound(player1,1057,0.0,0.0,0.0);  PlayerInfo[player1][Muted] = 0; PlayerInfo[player1][MuteWarnings] = 0;
					format(string,sizeof(string)," Вам дал свободу голоса админ %s",adminname); SendClientMessage(player1,COLOR_GREEN,string);
					format(string,sizeof(string)," Вы разоткнули игрока %s", playername); return SendClientMessage(playerid,COLOR_GREEN,string);
				} else return SendClientMessage(playerid, red, " Игрок не заткнут");
			} else return SendClientMessage(playerid, red, " Нет такого игрока или он выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_muted(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 2) {
			new bool:First2 = false, Count, adminname[MAX_PLAYER_NAME], string[128], i;
			for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Muted]) Count++;
			if(Count == 0) return SendClientMessage(playerid,red, " Нет заткнутых игроков");

			for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Muted]) {
				GetPlayerName(i, adminname, sizeof(adminname));
				if(!First2) { format(string, sizeof(string), " Заткнутые игроки: (%d)%s", i,adminname); First2 = true; }
				else format(string,sizeof(string),"%s, (%d)%s ",string,i,adminname);
			}
			return SendClientMessage(playerid,COLOR_WHITE,string);
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_akill(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 3|| IsPlayerAdmin(playerid)) {
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/akill [id игрока]");
			new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(params);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if( (PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel] ) )
				return SendClientMessage(playerid, red, " Вы не можете убить админа выше вас уровнем");
				CMDMessageToAdmins(playerid,"AKILL");
				GetPlayerName(player1, playername, sizeof(playername));	GetPlayerName(playerid, adminname, sizeof(adminname));
				format(string,sizeof(string)," Админ %s убил вас",adminname);	SendClientMessage(player1,COLOR_RED,string);
				format(string,sizeof(string)," Вы убили игрока %s",playername); SendClientMessage(playerid,COLOR_RED,string);
				return SetPlayerHealth(player1,0.0);
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_weaps(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/weaps [id игрока]");
		new player1, string[128], string2[64], WeapName[24], slot, weap, ammo, Count, x;
		player1 = strval(params);

		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			format(string2,sizeof(string2),"[>> %s Оружия (id:%d) <<]", PlayerName2(player1), player1); SendClientMessage(playerid,COLOR_GREEN,string2);
			for (slot = 0; slot < 14; slot++) {	GetPlayerWeaponData(player1, slot, weap, ammo); if( ammo != 0 && weap != 0) Count++; }
			if(Count < 1) return SendClientMessage(playerid,COLOR_GREEN," У игрока нет оружия");

			if(Count >= 1)
			{
				for (slot = 0; slot < 14; slot++)
				{
					GetPlayerWeaponData(player1, slot, weap, ammo);
					if( ammo != 0 && weap != 0)
					{
						GetWeaponName(weap, WeapName, sizeof(WeapName) );
						if(ammo == 65535 || ammo == 1) format(string,sizeof(string),"%s%s (1)",string, WeapName );
						else format(string,sizeof(string),"%s%s (%d)",string, WeapName, ammo );
						x++;
						if(x >= 5)
						{
							SendClientMessage(playerid, blue, string);
							x = 0;
							format(string, sizeof(string), "");
						}
						else format(string, sizeof(string), "%s,  ", string);
					}
				}
				if(x <= 4 && x > 0) {
					string[strlen(string)-3] = '.';
					SendClientMessage(playerid, blue, string);
				}
			}
			return 1;
		} else return SendClientMessage(playerid, red, " Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_aka(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/aka [id игрока]");
		new player1, playername[MAX_PLAYER_NAME], str[128], tmp3[50];
		player1 = strval(params);
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			GetPlayerIp(player1,tmp3,50);
			GetPlayerName(player1, playername, sizeof(playername));
			format(str,sizeof(str),"AKA: [%s id:%d] [%s] %s", playername, player1, tmp3, dini_Get("ladmin/config/aka.txt",tmp3) );
			return SendClientMessage(playerid,blue,str);
		} else return SendClientMessage(playerid, red, " Нет такого игрока or is yourself");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_screen(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
		new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/screen [id игрока] [текст]");
		new player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
		player1 = strval(params);

		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid && (PlayerInfo[player1][Level] != ServerInfo[MaxAdminLevel]) ) {
			GetPlayerName(player1, playername, sizeof(playername));		GetPlayerName(playerid, adminname, sizeof(adminname));
			CMDMessageToAdmins(playerid,"SCREEN");
			format(string,sizeof(string)," Админ %s отправил вам сообщение на экран",adminname);	SendClientMessage(player1,COLOR_GREEN,string);
			format(string,sizeof(string)," Вы отправили игроку %s сообщение на экран (%s)", playername, params[2]); SendClientMessage(playerid,COLOR_GREEN,string);
			return GameTextForPlayer(player1, params[2],4000,3);
		} else return SendClientMessage(playerid, red, " Нет такого игрока или это вы или это админ выше вас уровнем");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_laston(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
		new tmp2[256], file[256],player1, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], str[128];
		GetPlayerName(playerid, adminname, sizeof(adminname));

		if(!strlen(params)) {
			format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(adminname));
			if(!fexist(file)) return SendClientMessage(playerid, red, " {FFFFFF}Нет зарегистрированых игроков, которые заходили сюда в ближайшее время");
			if(dUserINT(PlayerName2(playerid)).("LastOn")==0) {	format(str, sizeof(str),"Never"); tmp2 = str;
			} else { tmp2 = dini_Get(file,"LastOn"); }
			format(str, sizeof(str),"You were last on the server on %s",tmp2);
			return SendClientMessage(playerid, red, str);
		}
		player1 = strval(params);
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid) {
			CMDMessageToAdmins(playerid,"LASTON");
			GetPlayerName(player1,playername,sizeof(playername)); format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(playername));
			if(!fexist(file)) return SendClientMessage(playerid, red, " {FFFFFF}Нет зарегистрированых игроков, которые заходили сюда в ближайшее время");
			if(dUserINT(PlayerName2(player1)).("LastOn")==0) { format(str, sizeof(str),"Never"); tmp2 = str;
			} else { tmp2 = dini_Get(file,"LastOn"); }
			format(str, sizeof(str)," %s был последним на сервере %s",playername,tmp2);
			return SendClientMessage(playerid, red, str);
		} else return SendClientMessage(playerid, red, " Нет такого игрока или это вы");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_admins(playerid,params[]) {
	#pragma unused params
	new Count[2], i, string[128];
	for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i))
	{
		if(PlayerInfo[i][Level] > 0) Count[0]++;
		if(IsPlayerAdmin(i)) Count[1]++;
	}

	#if defined HIDE_ADMINS
	if(PlayerInfo[playerid][Level] == 0) {
		if(Count[0] >= 1) {
			format(string, sizeof(string), " Здесь %d админов. Используйте /report <id игрока> <причина> и ваша жалоба на игрока будет отправлена администраторам", Count[0]);
			return SendClientMessage(playerid, blue, string);
		} else return SendClientMessage(playerid, blue, " Нет админов в игре");
	}
	#endif

	if( (Count[0] == 0 && Count[1] == 0) || (Count[0] == 0 && Count[1] >= 1 && PlayerInfo[playerid][Level] == 0) ) return SendClientMessage(playerid, blue, " Нет админов в игре");

	if(Count[0] == 1) {
		for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Level] > 0) {
			format(string, sizeof(string), " Админ: (ID:%d)%s [%d]", i, PlayerName2(i), PlayerInfo[i][Level] ); SendClientMessage(playerid, blue, string);
		}
	}

	if(Count[0] > 1) {
		new x; format(string, sizeof(string), " Админы: ");
		for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Level] > 0)
		{
			format(string,sizeof(string),"%s(ID:%d)%s [%d]",string,i,PlayerName2(i),PlayerInfo[i][Level]);
			x++;
			if(x >= 5) {
				SendClientMessage(playerid, blue, string); format(string, sizeof(string), "Admins: "); x = 0;
			}
			else format(string, sizeof(string), "%s,  ", string);
		}
		if(x <= 4 && x > 0) {
			string[strlen(string)-3] = '.';
			SendClientMessage(playerid, blue, string);
		}
	}

	if( (Count[1] == 1) && (PlayerInfo[playerid][Level] > 0) ) {
		for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && IsPlayerAdmin(i)) {
			format(string, sizeof(string), " RCON Админ: (ID:%d)%s", i, PlayerName2(i)); SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	if(Count[1] > 1) {
		new x; format(string, sizeof(string), " RCON Админы: ");
		for(i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && IsPlayerAdmin(i))
		{
			format(string,sizeof(string),"%s(ID:%d)%s",string,i,PlayerName2(i));
			x++;
			if(x >= 5) {
				SendClientMessage(playerid, COLOR_WHITE, string); format(string, sizeof(string), " RCON Админы: "); x = 0;
			}
			else format(string, sizeof(string), "%s,  ", string);
		}
		if(x <= 4 && x > 0) {
			string[strlen(string)-3] = '.';
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	return 1;
}

dcmd_morning(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		CMDMessageToAdmins(playerid,"MORNING");
		return SetPlayerTime(playerid,7,0);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
}

dcmd_adminarea(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		CMDMessageToAdmins(playerid,"ADMINAREA");
		SetPlayerPos(playerid, AdminArea[0], AdminArea[1], AdminArea[2]);
		SetPlayerFacingAngle(playerid, AdminArea[3]);
		SetPlayerInterior(playerid, AdminArea[4]);
		SetPlayerVirtualWorld(playerid, AdminArea[5]);
		return GameTextForPlayer(playerid,"DO6PO ZOGALOBATJ ADMNH!",1000,3);
	} else {
		SetPlayerHealth(playerid,1.0);
		new string[100]; format(string, sizeof(string),"%s телепортировался в убежище для админов", PlayerName2(playerid) );
		MessageToAdmins(red,string);
	} return SendClientMessage(playerid,red, " {FFFFFF}У вас нет доступа к этой команде.");
}

dcmd_setlevel(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 10 || IsPlayerAdmin(playerid)) {
			new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
			if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setlevel [id игрока] [уровень]");
			new player1, level, playername[MAX_PLAYER_NAME], adminname[MAX_PLAYER_NAME], string[128];
			player1 = strval(tmp);
			if(!strlen(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/setlevel [id игрока] [уровень]");
			level = strval(tmp2);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(PlayerInfo[player1][LoggedIn] == 1) {
					if(level > ServerInfo[MaxAdminLevel] ) return SendClientMessage(playerid,red,"{FFFFFF}Неверный уровень");
					if(level == PlayerInfo[player1][Level]) return SendClientMessage(playerid,red,"{FFFFFF}Игрок уже этого уровня");
					CMDMessageToAdmins(playerid,"SETLEVEL");
					GetPlayerName(player1, playername, sizeof(playername));	GetPlayerName(playerid, adminname, sizeof(adminname));
					new year,month,day;   getdate(year, month, day); new hour,minute,second; gettime(hour,minute,second);

					if(level > 0) format(string,sizeof(string)," Админ %s повысил вас в уровне %d",adminname, level);
					else format(string,sizeof(string)," Админ %s понизил вас в уровне %d",adminname, level);
					SendClientMessage(player1,COLOR_GREEN,string);

					if(level > PlayerInfo[player1][Level]) GameTextForPlayer(player1,"ZOBSCNLN", 2000, 3);
					else GameTextForPlayer(player1,"ZOHN3NLN", 2000, 3);

					format(string,sizeof(string)," Вы сделали игрока %s %d уровня %d/%d/%d в %d:%d:%d", playername, level, day, month, year, hour, minute, second); SendClientMessage(playerid,COLOR_GREEN,string);
					format(string,sizeof(string)," Админ %s сделал %s %d уровня %d/%d/%d в %d:%d:%d",adminname, playername, level, day, month, year, hour, minute, second);
					SaveToFile("AdminLog",string);
					dUserSetINT(PlayerName2(player1)).("level",(level));
					PlayerInfo[player1][Level] = level;
					return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
				} else return SendClientMessage(playerid,red,"{FFFFFF}Игрок должен быть зарегистрирован и залогинен");
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_settemplevel(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1) {
		if(PlayerInfo[playerid][Level] >= 7 || IsPlayerAdmin(playerid)) {
			new tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
			if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/settemplevel [id игрока] [уровень]");
			new player1, level, string[128];
			player1 = strval(tmp);
			level = strval(tmp2);

			if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
				if(PlayerInfo[player1][LoggedIn] == 1) {
					if(level > ServerInfo[MaxAdminLevel] ) return SendClientMessage(playerid,red,"{FFFFFF}Неверный уровень");
					if(level == PlayerInfo[player1][Level]) return SendClientMessage(playerid,red,"{FFFFFF}Игрок уже этого уровня");
					CMDMessageToAdmins(playerid,"SETTEMPLEVEL");
					new year,month,day; getdate(year, month, day); new hour,minute,second; gettime(hour,minute,second);

					if(level > 0) format(string,sizeof(string)," Админ %s временно повысил вас в уровне %d", pName(playerid), level);
					else format(string,sizeof(string)," Админ %s временно понизил вас в уровне %d", pName(playerid), level);
					SendClientMessage(player1,blue,string);

					if(level > PlayerInfo[player1][Level]) GameTextForPlayer(player1,"ZOBSCNLN", 2000, 3);
					else GameTextForPlayer(player1,"ZOHN3NLN", 2000, 3);

					format(string,sizeof(string)," Вы сделали игрока %s временно %d уровнем %d/%d/%d в %d:%d:%d", pName(player1), level, day, month, year, hour, minute, second); SendClientMessage(playerid,blue,string);
					format(string,sizeof(string)," Админ %s сделал вас временно %s уровнем %d %d/%d/%d в %d:%d:%d",pName(playerid), pName(player1), level, day, month, year, hour, minute, second);
					SaveToFile("TempAdminLog",string);
					PlayerInfo[player1][Level] = level;
					return PlayerPlaySound(player1,1057,0.0,0.0,0.0);
				} else return SendClientMessage(playerid,red,"{FFFFFF}Игрок должен зарегаться или залогиниться");
			} else return SendClientMessage(playerid, red, " Нет такого игрока");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
}

dcmd_report(playerid,params[]) {
	new reported, tmp[256], tmp2[256], Index;		tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/report [id игрока] [причина жалобы]");
	reported = strval(tmp);

	if(IsPlayerConnected(reported) && reported != INVALID_PLAYER_ID) {
		if(PlayerInfo[reported][Level] == ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете пожаловаться на админа");
		if(playerid == reported) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете пожаловаться на себя");
		if(strlen(params) > 7) {
			new reportedname[MAX_PLAYER_NAME], reporter[MAX_PLAYER_NAME], str[128], hour,minute,second; gettime(hour,minute,second);
			GetPlayerName(reported, reportedname, sizeof(reportedname));	GetPlayerName(playerid, reporter, sizeof(reporter));
			format(str, sizeof(str), " ||НОВАЯ ЖАЛОБА||  %s(%d) жалуется на %s(%d) Причина: %s |@%d:%d:%d|", reporter,playerid, reportedname, reported, params[strlen(tmp)+1], hour,minute,second);
			MessageToAdmins(COLOR_WHITE,str);
			SaveToFile("ReportLog",str);
			format(str, sizeof(str), " ЖАЛОБА(%d:%d:%d): %s(%d) жалуется %s(%d) Причина: %s", hour,minute,second, reporter,playerid, reportedname, reported, params[strlen(tmp)+1]);
			for(new i = 1; i < MAX_REPORTS-1; i++) Reports[i] = Reports[i+1];
			Reports[MAX_REPORTS-1] = str;
			return SendClientMessage(playerid,yellow, " Ваша жалоба отправлена всем админам, которые сейчас в игре.");
		} else return SendClientMessage(playerid,red,"{FFFFFF}Слишком короткая жалоба");
	} else return SendClientMessage(playerid, red, " Нет такого игрока");
}

dcmd_reports(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		new ReportCount;
		for(new i = 1; i < MAX_REPORTS; i++)
		{
			if(strcmp( Reports[i], "<none>", true) != 0) { ReportCount++; SendClientMessage(playerid,COLOR_WHITE,Reports[i]); }
		}
		if(ReportCount == 0) SendClientMessage(playerid,COLOR_WHITE," Нет ни одной жалобы");
	} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
	return 1;
}

dcmd_richlist(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		new string[128], Slot1 = -1, Slot2 = -1, Slot3 = -1, Slot4 = -1, HighestCash = -9999;
		SendClientMessage(playerid,COLOR_WHITE," Список богачей:");

		for(new x=0; x<GetMaxPlayers(); x++) if (IsPlayerConnected(x)) if (GetPlayerMoney(x) >= HighestCash) {
			HighestCash = GetPlayerMoney(x);
			Slot1 = x;
		}
		HighestCash = -9999;
		for(new x=0; x<GetMaxPlayers(); x++) if (IsPlayerConnected(x) && x != Slot1) if (GetPlayerMoney(x) >= HighestCash) {
			HighestCash = GetPlayerMoney(x);
			Slot2 = x;
		}
		HighestCash = -9999;
		for(new x=0; x<GetMaxPlayers(); x++) if (IsPlayerConnected(x) && x != Slot1 && x != Slot2) if (GetPlayerMoney(x) >= HighestCash) {
			HighestCash = GetPlayerMoney(x);
			Slot3 = x;
		}
		HighestCash = -9999;
		for(new x=0; x<GetMaxPlayers(); x++) if (IsPlayerConnected(x) && x != Slot1 && x != Slot2 && x != Slot3) if (GetPlayerMoney(x) >= HighestCash) {
			HighestCash = GetPlayerMoney(x);
			Slot4 = x;
		}
		format(string, sizeof(string), "(%d) %s - $%d", Slot1,PlayerName2(Slot1),GetPlayerMoney(Slot1) );
		SendClientMessage(playerid,COLOR_WHITE,string);
		if(Slot2 != -1)	{
			format(string, sizeof(string), "(%d) %s - $%d", Slot2,PlayerName2(Slot2),GetPlayerMoney(Slot2) );
			SendClientMessage(playerid,COLOR_WHITE,string);
		}
		if(Slot3 != -1)	{
			format(string, sizeof(string), "(%d) %s - $%d", Slot3,PlayerName2(Slot3),GetPlayerMoney(Slot3) );
			SendClientMessage(playerid,COLOR_WHITE,string);
		}
		if(Slot4 != -1)	{
			format(string, sizeof(string), "(%d) %s - $%d", Slot4,PlayerName2(Slot4),GetPlayerMoney(Slot4) );
			SendClientMessage(playerid,COLOR_WHITE,string);
		}
		return 1;
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_miniguns(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		new bool:First2 = false, Count, string[128], i, slot, weap, ammo;
		for(i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i)) {
				for(slot = 0; slot < 14; slot++) {
					GetPlayerWeaponData(i, slot, weap, ammo);
					if(ammo != 0 && weap == 38) {
						Count++;
						if(!First2) { format(string, sizeof(string), " Миниган: (%d)%s(патроны:%d)", i, PlayerName2(i), ammo); First2 = true; }
						else format(string,sizeof(string),"%s, (%d)%s(патроны:%d) ",string, i, PlayerName2(i), ammo);
					}
				}
			}
		}
		if(Count == 0) return SendClientMessage(playerid,COLOR_WHITE," Нет игроков с миниганом"); else return SendClientMessage(playerid,COLOR_WHITE,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_uconfig(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 7)
	{
		UpdateConfig();
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return CMDMessageToAdmins(playerid,"UCONFIG");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 7 уровень чтобы использовать эту команду");
}

dcmd_botcheck(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		for(new i=0; i<GetMaxPlayers(); i++) BotCheck(i);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return CMDMessageToAdmins(playerid,"BOTCHECK");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 3 уровень чтобы использовать эту команду");
}

dcmd_lockserver(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 8) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/lockserver [пароль]");
		new adminname[MAX_PLAYER_NAME], string[128];
		ServerInfo[Locked] = 1;
		strmid(ServerInfo[Password], params[0], 0, strlen(params[0]), 128);
		GetPlayerName(playerid, adminname, sizeof(adminname));
		format(string, sizeof(string), " Админ %s закрыл сервер",adminname);
		SendClientMessageToAll(red,"________________________________________");
		SendClientMessageToAll(red," ");
		SendClientMessageToAll(red,string);
		SendClientMessageToAll(red,"________________________________________");
		for(new i = 0; i <= GetMaxPlayers(); i++) if(IsPlayerConnected(i)) { PlayerPlaySound(i,1057,0.0,0.0,0.0); PlayerInfo[i][AllowedIn] = true; }
		CMDMessageToAdmins(playerid,"LOCKSERVER");
		format(string, sizeof(string), " Админ %s закрыл сервер под паролем '%s'",adminname, ServerInfo[Password] );
		return MessageToAdmins(COLOR_WHITE, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_unlockserver(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		if(ServerInfo[Locked] == 1) {
			new adminname[MAX_PLAYER_NAME], string[128];
			ServerInfo[Locked] = 0;
			strmid(ServerInfo[Password], "", 0, strlen(""), 128);
			GetPlayerName(playerid, adminname, sizeof(adminname));
			format(string, sizeof(string), " Админ %s открыл сервер",adminname);
			SendClientMessageToAll(green,"________________________________________");
			SendClientMessageToAll(green," ");
			SendClientMessageToAll(green,string);
			SendClientMessageToAll(green,"________________________________________");
			for(new i = 0; i <= GetMaxPlayers(); i++) if(IsPlayerConnected(i)) { PlayerPlaySound(i,1057,0.0,0.0,0.0); PlayerInfo[i][AllowedIn] = true; }
			return CMDMessageToAdmins(playerid,"UNLOCKSERVER");
		} else return SendClientMessage(playerid,red,"{FFFFFF}Сервер не закрыт");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас нет доступа к этой команде");
}

dcmd_password(playerid,params[]) {
	if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/password [пароль]");
	if(ServerInfo[Locked] == 1) {
		if(PlayerInfo[playerid][AllowedIn] == false) {
			if(!strcmp(ServerInfo[Password],params[0],true)) {
				KillTimer( LockKickTimer[playerid] );
				PlayerInfo[playerid][AllowedIn] = true;
				new string[128];
				SendClientMessage(playerid,COLOR_WHITE," Вы правильно ввели пароль сервера!");
				format(string, sizeof(string), " %s успешно ввел пароль сервера!",PlayerName2(playerid));
				return MessageToAdmins(COLOR_WHITE, string);
			} else
			{
				return SendClientMessage(playerid,red,"{FFFFFF}Неверный пароль");
			}
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны залогиниться");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Сервер не закрыт");
}

//------------------------------------------------------------------------------
dcmd_forbidname(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 7) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/forbidname [ник]");
		new File:BLfile, string[128];
		BLfile = fopen("ladmin/config/ForbiddenNames.cfg",io_append);
		format(string,sizeof(string),"%s\r\n",params[1]);
		fwrite(BLfile,string);
		fclose(BLfile);
		UpdateConfig();
		CMDMessageToAdmins(playerid,"FORBIDNAME");
		format(string, sizeof(string), " Админ %s занес имя - %s в черный список", pName(playerid), params );
		return MessageToAdmins(green,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть 7 уровня");
}

dcmd_forbidword(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 7) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/forbidword [слово]");
		new File:BLfile, string[128];
		BLfile = fopen("ladmin/config/ForbiddenWords.cfg",io_append);
		format(string,sizeof(string),"%s\r\n",params[1]);
		fwrite(BLfile,string);
		fclose(BLfile);
		UpdateConfig();
		CMDMessageToAdmins(playerid,"FORBIDWORD");
		format(string, sizeof(string), " Админ %s занес слово - %s в антимат", pName(playerid), params );
		return MessageToAdmins(green,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть 7 уровня");
}

//==========================[ Spectate Commands ]===============================
#if defined ENABLE_SPEC

dcmd_lspec(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
		if(!strlen(params) || !IsNumeric(params)) return SendClientMessage(playerid, red, " {FFFFFF}/lspec [id игрока]");
		new specplayerid = strval(params);
		if(PlayerInfo[specplayerid][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(specplayerid) && specplayerid != INVALID_PLAYER_ID) {
			if(specplayerid == playerid) return SendClientMessage(playerid, red, " {FFFFFF}Вы не можете следить за собой");
			if(GetPlayerState(specplayerid) == PLAYER_STATE_SPECTATING && PlayerInfo[specplayerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, red, "Spectate: Player spectating someone else");
			if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, red, "Spectate: Player not spawned");
			if( (PlayerInfo[specplayerid][Level] != ServerInfo[MaxAdminLevel]) || (PlayerInfo[specplayerid][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] == ServerInfo[MaxAdminLevel]) )	{
				StartSpectate(playerid, specplayerid);
				CMDMessageToAdmins(playerid,"LSPEC");
				GetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
				GetPlayerFacingAngle(playerid,Pos[playerid][3]);
				return SendClientMessage(playerid,COLOR_GREEN," Вы следите за игроком");
			} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете следить за админом, выше вас уровнем");
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 2 уровень");
}

dcmd_lspecvehicle(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 2) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/lspecvehicle [id транспорта]");
		new specvehicleid = strval(params);
		if(specvehicleid < MAX_VEHICLES) {
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectateVehicle(playerid, specvehicleid);
			PlayerInfo[playerid][SpecID] = specvehicleid;
			PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
			CMDMessageToAdmins(playerid,"SPEC VEHICLE");
			GetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
			GetPlayerFacingAngle(playerid,Pos[playerid][3]);
			return SendClientMessage(playerid,COLOR_GREEN," Вы следите за транспортом");
		} else return SendClientMessage(playerid,red, " {FFFFFF}Неверный id транспорта");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 2 уровень");
}
dcmd_lspecoff(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 2) {
		if(PlayerInfo[playerid][SpecType] != ADMIN_SPEC_TYPE_NONE) {
			StopSpectate(playerid);
			SetTimerEx("PosAfterSpec",3000,0,"d",playerid);
			return SendClientMessage(playerid,COLOR_GREEN," Вы перестали следить");
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не следите");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 2 уровень");
}

#endif

//==========================[ CHAT COMMANDS ]===================================

dcmd_disablechat(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		CMDMessageToAdmins(playerid,"DISABLECHAT");
		new string[128];
		if(ServerInfo[DisableChat] == 0) {
			ServerInfo[DisableChat] = 1;
			format(string,sizeof(string)," Админ %s отключил чат", pName(playerid) );
		} else {
			ServerInfo[DisableChat] = 0;
			format(string,sizeof(string)," Админ %s включил чат", pName(playerid) );
		} return SendClientMessageToAll(COLOR_GREEN,string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 3 уровень");
}

dcmd_clearchat(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 2) {
		CMDMessageToAdmins(playerid,"CLEARCHAT");
		for(new i = 0; i < 11; i++) SendClientMessageToAll(green," "); return 1;
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 2 уровень");
}

dcmd_cc(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 7) {
		CMDMessageToAdmins(playerid,"CC");
		for(new i = 0; i < 50; i++) SendClientMessageToAll(green," "); return 1;
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 7 уровень");
}

dcmd_caps(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 4) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || IsNumeric(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/caps [id игрока] [on/off]");
		new player1 = strval(tmp), string[128];
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(strcmp(tmp2,"on",true) == 0)	{
				CMDMessageToAdmins(playerid,"CAPS");
				PlayerInfo[player1][Caps] = 0;
				if(player1 != playerid) { format(string,sizeof(string)," Админ %s дал вам возможность писать большими буквами", pName(playerid) ); SendClientMessage(player1,COLOR_GREEN,string); }
				format(string,sizeof(string)," Вы дали возможность игроку %s писать большими буквами", pName(player1) ); return SendClientMessage(playerid,COLOR_GREEN,string);
			} else if(strcmp(tmp2,"off",true) == 0)	{
				CMDMessageToAdmins(playerid,"CAPS");
				PlayerInfo[player1][Caps] = 1;
				if(player1 != playerid) { format(string,sizeof(string)," Админ %s отобрал у вас возможность писать большими буквами", pName(playerid) ); SendClientMessage(player1,COLOR_RED,string); }
				format(string,sizeof(string)," Вы отобрли возможность игроку %s писать большими буквами", pName(player1) ); return SendClientMessage(playerid,COLOR_RED,string);
			} else return SendClientMessage(playerid, red, " {FFFFFF}/caps [playerid] [on/off]");
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

//==================[ Invisible Commands ]======================================
dcmd_invisible(playerid,params[])
{
	return dcmd_invis(playerid,params);
}

dcmd_invis(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 7) {
		if(IsPlayerInAnyVehicle(playerid)) {
			LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(playerid)+1);
		}
		else {
			new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleID;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
			new int1 = GetPlayerInterior(playerid);
			LVehicleID = CreateVehicle(411,X,Y,Z,Angle,1,-1,-1); PutPlayerInVehicle(playerid,LVehicleID,0);
			LinkVehicleToInterior(LVehicleID,int1 + 1);
		}
		CMDMessageToAdmins(playerid,"INVIS");
		PlayerInfo[playerid][Invis] = 1;
		if(!InvisTimer) InvisTimer = SetTimer("HideNameTag",100,1);
		return SendClientMessage(playerid,red,"{FFFFFF} Вы теперь не видимы");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 7 уровень");
}

dcmd_uninvis(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 7) {
		if(PlayerInfo[playerid][Invis] == 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(playerid));
			}
			CMDMessageToAdmins(playerid,"UNINVIS");
			PlayerInfo[playerid][Invis] = 0;
			new InvisCount;
			for(new i=0; i<GetMaxPlayers(); i++) if(PlayerInfo[i][Invis] == 1) InvisCount++;
			if(InvisCount == 0) if(InvisTimer) KillTimer(InvisTimer);
			return SendClientMessage(playerid,green," Вы теперь видимы");
		} else return SendClientMessage(playerid,red,"{FFFFFF} Вы и так видимы");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 7 уровень");
}

dcmd_killinvis(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 7) {
		KillTimer(InvisTimer);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return CMDMessageToAdmins(playerid,"KILLINVIS");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 7 уровень");
}

//==================[ Object & Pickup ]=========================================
dcmd_pickup(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 10 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/pickup [id пикапа]");
		new pickup = strval(params), string[128], Float:x, Float:y, Float:z, Float:a;
		CMDMessageToAdmins(playerid,"PICKUP");
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		x += (3 * floatsin(-a, degrees));
		y += (3 * floatcos(-a, degrees));
		CreatePickup(pickup, 2, x+2, y, z);
		format(string, sizeof(string), " CreatePickup(%d, 2, %0.2f, %0.2f, %0.2f);", pickup, x+2, y, z);
		SaveToFile("Pickups",string);
		return SendClientMessage(playerid,yellow, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_object(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 10 || IsPlayerAdmin(playerid)) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"{FFFFFF}/object [id обьекта]");
		new object = strval(params), string[128], Float:x, Float:y, Float:z, Float:a;
		CMDMessageToAdmins(playerid,"OBJECT");
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		x += (3 * floatsin(-a, degrees));
		y += (3 * floatcos(-a, degrees));
		CreateObject(object, x, y, z, 0.0, 0.0, a);
		format(string, sizeof(string), " CreateObject(%d, %0.2f, %0.2f, %0.2f, 0.00, 0.00, %0.2f);", object, x, y, z, a);
		SaveToFile("Objects",string);
		format(string, sizeof(string), " Вы создали оъбект %d, с координатами %0.2f, %0.2f, %0.2f , %0.2f", object, x, y, z, a);
		return SendClientMessage(playerid,yellow, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

//===================[ Move ]===================================================

dcmd_move(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/move [up/down/+x/-x/+y/-y/off]");
		new Float:X, Float:Y, Float:Z;
		if(strcmp(params,"up",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X,Y,Z+5); SetCameraBehindPlayer(playerid); }
		else if(strcmp(params,"down",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X,Y,Z-5); SetCameraBehindPlayer(playerid); }
		else if(strcmp(params,"+x",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X+5,Y,Z);	}
		else if(strcmp(params,"-x",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X-5,Y,Z); }
		else if(strcmp(params,"+y",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X,Y+5,Z);	}
		else if(strcmp(params,"-y",true) == 0)	{
			TogglePlayerControllable(playerid,false); GetPlayerPos(playerid,X,Y,Z);	SetPlayerPos(playerid,X,Y-5,Z);	}
		else if(strcmp(params,"off",true) == 0)	{
			TogglePlayerControllable(playerid,true);	}
		else return SendClientMessage(playerid,red,"{FFFFFF}/move [up/down/+x/-x/+y/-y/off]");
		return 1;
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_moveplayer(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp)) return SendClientMessage(playerid, red, " {FFFFFF}/moveplayer [id игрока] [up/down/+x/-x/+y/-y/off]");
		new Float:X, Float:Y, Float:Z, player1 = strval(tmp);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			if(strcmp(tmp2,"up",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X,Y,Z+5); SetCameraBehindPlayer(player1);	}
			else if(strcmp(tmp2,"down",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X,Y,Z-5); SetCameraBehindPlayer(player1);	}
			else if(strcmp(tmp2,"+x",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X+5,Y,Z);	}
			else if(strcmp(tmp2,"-x",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X-5,Y,Z); }
			else if(strcmp(tmp2,"+y",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X,Y+5,Z);	}
			else if(strcmp(tmp2,"-y",true) == 0)	{
				GetPlayerPos(player1,X,Y,Z);	SetPlayerPos(player1,X,Y-5,Z);	}
			else SendClientMessage(playerid,red,"{FFFFFF}/moveplayer [up/down/+x/-x/+y/-y/off]");
			return 1;
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

//===================[ Fake ]===================================================

#if defined ENABLE_FAKE_CMDS
dcmd_fakedeath(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 9) {
		new tmp[256], tmp2[256], tmp3[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index), tmp3 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !strlen(tmp3)) return SendClientMessage(playerid, red, " {FFFFFF}/fakedeath [убийца] [смертник] [id оружия]");
		new killer = strval(tmp), killee = strval(tmp2), weap = strval(tmp3);
		if(!IsValidWeapon(weap)) return SendClientMessage(playerid,red,"{FFFFFF}Неверный id оружия");
		if(PlayerInfo[killer][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(PlayerInfo[killee][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");

		if(IsPlayerConnected(killer) && killer != INVALID_PLAYER_ID) {
			if(IsPlayerConnected(killee) && killee != INVALID_PLAYER_ID) {
				CMDMessageToAdmins(playerid,"FAKEDEATH");
				SendDeathMessage(killer,killee,weap);
				return SendClientMessage(playerid,COLOR_GREEN," Поддельное сообщение о смерти отправлено");
			} else return SendClientMessage(playerid,red,"{FFFFFF}Смертник не подключен к игре");
		} else return SendClientMessage(playerid,red,"{FFFFFF}Убийца не подключен к игре");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_fakechat(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 9) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/fakechat [id игрока] [текст]");
		new player1 = strval(tmp);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"FAKECHAT");
			SendPlayerMessageToAll(player1, params[strlen(tmp)+1]);
			return SendClientMessage(playerid,COLOR_GREEN," Поддельное сообщение в чат отправлено");
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_fakecmd(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 9) {
		new tmp[256], tmp2[256], Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) || !strlen(tmp2)) return SendClientMessage(playerid, red, " {FFFFFF}/fakecmd [id игрока] [команда]");
		new player1 = strval(tmp);
		if(PlayerInfo[player1][Level] == ServerInfo[MaxAdminLevel] && PlayerInfo[playerid][Level] != ServerInfo[MaxAdminLevel]) return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете использовать команду на этом уровне");
		if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID) {
			CMDMessageToAdmins(playerid,"FAKECMD");
			CallRemoteFunction("OnPlayerCommandText", "is", player1, tmp2);
			return SendClientMessage(playerid,COLOR_GREEN," Команда у указанного игрока сработала");
		} else return SendClientMessage(playerid,red,"{FFFFFF} Нет такого игрока");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}
#endif

//----------------------------------------------------------------------------//
// 		             	/all Commands                                         //
//----------------------------------------------------------------------------//

dcmd_spawnall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"SPAWNAll");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerPos(i, 0.0, 0.0, 0.0); SpawnPlayer(i);
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s вернул на спавн всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_muteall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"MUTEALL");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); PlayerInfo[i][Muted] = 1; PlayerInfo[i][MuteWarnings] = 0;
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s заткнул всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_unmuteall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"UNMUTEAll");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); PlayerInfo[i][Muted] = 0; PlayerInfo[i][MuteWarnings] = 0;
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s разоткнул всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_getall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"GETAll");
		new Float:x,Float:y,Float:z, interior = GetPlayerInterior(playerid);
		GetPlayerPos(playerid,x,y,z);
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerPos(i,x+(playerid/4)+1,y+(playerid/4),z); SetPlayerInterior(i,interior);
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s телепортировал всех игроков к себе", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_healall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 5) {
		CMDMessageToAdmins(playerid,"HEALALL");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerHealth(i,100.0);
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s вылечил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 5 уровень");
}

dcmd_armourall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 5) {
		CMDMessageToAdmins(playerid,"ARMOURALL");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerArmour(i,100.0);
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s подарил всем по полной броне", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 5 уровень");
}

dcmd_killall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"KILLALL");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerHealth(i,0.0);
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s убил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_freezeall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"FREEZEALL");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); TogglePlayerControllable(playerid,false); PlayerInfo[i][Frozen] = 1;
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s зморозил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_unfreezeall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"UNFREEZEALL");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); TogglePlayerControllable(playerid,true); PlayerInfo[i][Frozen] = 0;
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s разморозил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_kickall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"KICKALL");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); Kick(i);
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s кикнул всех игроков", pName(playerid) );
		SaveToFile("KickLog",string);
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_slapall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 9) {
		CMDMessageToAdmins(playerid,"SLAPALL");
		new Float:x, Float:y, Float:z;
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1190,0.0,0.0,0.0); GetPlayerPos(i,x,y,z);	SetPlayerPos(i,x,y,z+4);
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s пнул всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 9 уровень");
}

dcmd_explodeall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 9) {
		CMDMessageToAdmins(playerid,"EXPLODEALL");
		new Float:x, Float:y, Float:z;
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1190,0.0,0.0,0.0); GetPlayerPos(i,x,y,z);	CreateExplosion(x, y , z, 7, 10.0);
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s взорвал всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 9 уровень");
}

dcmd_disarmall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"DISARMALL");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); ResetPlayerWeapons(i);
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s разоружил всех игроков", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

dcmd_ejectall(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 8) {
		CMDMessageToAdmins(playerid,"EJECTALL");
		new Float:x, Float:y, Float:z;
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && (i != playerid) && i != ServerInfo[MaxAdminLevel]) {
				if(IsPlayerInAnyVehicle(i)) {
					PlayerPlaySound(i,1057,0.0,0.0,0.0); GetPlayerPos(i,x,y,z); SetPlayerPos(i,x,y,z+3);
				}
			}
		}
		new string[128]; format(string,sizeof(string)," Админ %s выкинул всех из транспорта", pName(playerid) );
		return SendClientMessageToAll(COLOR_RED, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 8 уровень");
}

//-------------==== Set All Commands ====-------------//

dcmd_setallskin(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 3) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setallskin [id скина]");
		new var = strval(params), string[128];
		if(!IsValidSkin(var)) return SendClientMessage(playerid, red, " {FFFFFF}Неверный id скина");
		CMDMessageToAdmins(playerid,"SETALLSKIN");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerSkin(i,var);
			}
		}
		format(string,sizeof(string)," Админ %s установил всем скин %d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setallwanted(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setallwanted [уровень розыска]");
		new var = strval(params), string[128];
		CMDMessageToAdmins(playerid,"SETALLWANTED");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerWantedLevel(i,var);
			}
		}
		format(string,sizeof(string)," Админ %s установил всем уровень розыскиваемости %d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setallweather(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setallweather [id погоды]");
		new var = strval(params), string[128];
		CMDMessageToAdmins(playerid,"SETALLWEATHER");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerWeather(i, var);
			}
		}
		format(string,sizeof(string),"Админ %s установил всем погоду %d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setalltime(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setalltime [время]");
		new var = strval(params), string[128];
		if(var > 24) return SendClientMessage(playerid, red, " {FFFFFF}Не верное время");
		CMDMessageToAdmins(playerid,"SETALLTIME");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerTime(i, var, 0);
			}
		}
		format(string,sizeof(string)," Админ %s установил всем время %d:00", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setallworld(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setallworld [виртуальный мир]");
		new var = strval(params), string[128];
		CMDMessageToAdmins(playerid,"SETALLWORLD");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerVirtualWorld(i,var);
			}
		}
		format(string,sizeof(string)," Админ %s установил всем виртуальный мир %d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setallscore(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setallscore [рекорд]");
		new var = strval(params), string[128];
		CMDMessageToAdmins(playerid,"SETALLSCORE");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); SetPlayerScore(i,var);
			}
		}
		format(string,sizeof(string)," Админ %s установил всем рекорд %d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_setallcash(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/setallcash [сумма]");
		new var = strval(params), string[128];
		CMDMessageToAdmins(playerid,"SETALLCASH");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); ResetPlayerMoney(i); GivePlayerMoney(i,var);
			}
		}
		format(string,sizeof(string)," Админ %s установил всем сумму на руках $%d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_giveallcash(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/giveallcash [сумма]");
		new var = strval(params), string[128];
		CMDMessageToAdmins(playerid,"GIVEALLCASH");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); GivePlayerMoney(i,var);
			}
		}
		format(string,sizeof(string)," Админ %s подарил всем по $%d", pName(playerid), var );
		return SendClientMessageToAll(COLOR_GREEN, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

dcmd_giveallweapon(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 6) {
		new tmp[256], tmp2[256], Index, ammo, weap, WeapName[32], string[128]; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp) ) return SendClientMessage(playerid, red, " {FFFFFF}/giveallweapon [id оружия или название оружия] [патроны]");
		if(!strlen(tmp2) || !IsNumeric(tmp2) || strval(tmp2) <= 0 || strval(tmp2) > 99999) ammo = 500;
		if(!IsNumeric(tmp)) weap = GetWeaponIDFromName(tmp); else weap = strval(tmp);
		if(!IsValidWeapon(weap)) return SendClientMessage(playerid,red,"{FFFFFF}Неверный id оружия");
		CMDMessageToAdmins(playerid,"GIVEALLWEAPON");
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i) && i != playerid && i != ServerInfo[MaxAdminLevel]) {
				PlayerPlaySound(i,1057,0.0,0.0,0.0); GivePlayerWeapon(i,weap,ammo);
			}
		}
		GetWeaponName(weap, WeapName, sizeof(WeapName) );
		format(string,sizeof(string)," Админ %s дал всем оружие %s(ID:%d) с %d патронами", pName(playerid), WeapName, weap, ammo);
		return SendClientMessageToAll(blue, string);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}


//================================[ Menu Commands ]=============================

#if defined USE_MENUS

dcmd_lmenu(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		if(IsPlayerInAnyVehicle(playerid)) {
			TogglePlayerControllable(playerid,false); return ShowMenuForPlayer(LMainMenu,playerid);
		} else return ShowMenuForPlayer(LMainMenu,playerid);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}
dcmd_ltele(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		if(IsPlayerInAnyVehicle(playerid)) {
			TogglePlayerControllable(playerid,false); return ShowMenuForPlayer(LTele,playerid);
		} else return ShowMenuForPlayer(LTele,playerid);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}
dcmd_lweather(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 4) {
		if(IsPlayerInAnyVehicle(playerid)) {
			TogglePlayerControllable(playerid,false); return ShowMenuForPlayer(LWeather,playerid);
		} else return ShowMenuForPlayer(LWeather,playerid);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}
dcmd_ltime(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 4) {
		if(IsPlayerInAnyVehicle(playerid)) {
			TogglePlayerControllable(playerid,false); return ShowMenuForPlayer(LTime,playerid);
		} else return ShowMenuForPlayer(LTime,playerid);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}
dcmd_cm(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт.");
		else { ShowMenuForPlayer(LCars,playerid); return TogglePlayerControllable(playerid,false);  }
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}
dcmd_ltmenu(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		if(IsPlayerInAnyVehicle(playerid)) {
			new LVehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(LVehicleID);
			switch(LModel) { case 448,461,462,463,468,471,509,510,521,522,523,581,586,449: return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете тюнинговать этот транспорт!"); }
			TogglePlayerControllable(playerid,false); return ShowMenuForPlayer(LTuneMenu,playerid);
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете тюнинговать этот транспорт");
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}
dcmd_lweapons(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		if(IsPlayerInAnyVehicle(playerid)) {
			TogglePlayerControllable(playerid,false); return ShowMenuForPlayer(XWeapons,playerid);
		} else return ShowMenuForPlayer(XWeapons,playerid);
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}
dcmd_lvehicle(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 3) {
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт.");
		else { ShowMenuForPlayer(LVehicles,playerid); return TogglePlayerControllable(playerid,false);  }
	} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
}

#endif

//----------------------===== Place & Skin Saving =====-------------------------
dcmd_gotoplace(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1 && PlayerInfo[playerid][Level] >= 1)	{
		if (dUserINT(PlayerName2(playerid)).("x")!=0) {
			PutAtPos(playerid);
			SetPlayerVirtualWorld(playerid, (dUserINT(PlayerName2(playerid)).("world")) );
			return SendClientMessage(playerid,yellow,"{FFFFFF}Вы успешно телепортировались на сохраненное место");
		} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны сохранить место в которое хотите телепортироваться /saveplace");
	} else return SendClientMessage(playerid,red, " {FFFFFF}Вы должны быть админом");
}

dcmd_saveplace(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1 && PlayerInfo[playerid][Level] >= 1)	{
		new Float:x,Float:y,Float:z, interior;
		GetPlayerPos(playerid,x,y,z);	interior = GetPlayerInterior(playerid);
		dUserSetINT(PlayerName2(playerid)).("x",floatround(x));
		dUserSetINT(PlayerName2(playerid)).("y",floatround(y));
		dUserSetINT(PlayerName2(playerid)).("z",floatround(z));
		dUserSetINT(PlayerName2(playerid)).("interior",interior);
		dUserSetINT(PlayerName2(playerid)).("world", (GetPlayerVirtualWorld(playerid)) );
		return SendClientMessage(playerid,yellow,"{FFFFFF}Вы успешно сохранили координаты, и можете телепортироваться сюда командой /gotoplace");
	} else return SendClientMessage(playerid,red, " {FFFFFF}Вы должны быть админом");
}

dcmd_saveskin(playerid,params[]) {
	if(PlayerInfo[playerid][Level] >= 1 && PlayerInfo[playerid][LoggedIn] == 1) {
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/saveskin [id скина]");
		new string[128], SkinID = strval(params);
		if((SkinID == 0)||(SkinID == 7)||(SkinID >= 9 && SkinID <= 41)||(SkinID >= 43 && SkinID <= 64)||(SkinID >= 66 && SkinID <= 73)||(SkinID >= 75 && SkinID <= 85)||(SkinID >= 87 && SkinID <= 118)||(SkinID >= 120 && SkinID <= 148)||(SkinID >= 150 && SkinID <= 207)||(SkinID >= 209 && SkinID <= 264)||(SkinID >= 274 && SkinID <= 288)||(SkinID >= 290 && SkinID <= 299))
		{
			dUserSetINT(PlayerName2(playerid)).("FavSkin",SkinID);
			format(string, sizeof(string), " Вы успешно сохранили скин (ID %d)",SkinID);
			SendClientMessage(playerid,yellow,string);
			SendClientMessage(playerid,yellow,"{FFFFFF}Напишите: /useskin - чтобы скин выбирался при спавне или /dontuseskin - чтобы прекратить эту операцию");
			dUserSetINT(PlayerName2(playerid)).("UseSkin",1);
			return CMDMessageToAdmins(playerid,"SAVESKIN");
		} else return SendClientMessage(playerid, green, " {FFFFFF}Неверный id скина");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть админом");
}

dcmd_useskin(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1 && PlayerInfo[playerid][LoggedIn] == 1) {
		dUserSetINT(PlayerName2(playerid)).("UseSkin",1);
		SetPlayerSkin(playerid,dUserINT(PlayerName2(playerid)).("FavSkin"));
		return SendClientMessage(playerid,yellow,"{FFFFFF}Вы сменили на сохраненный скин");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть админом");
}

dcmd_dontuseskin(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][Level] >= 1 && PlayerInfo[playerid][LoggedIn] == 1) {
		dUserSetINT(PlayerName2(playerid)).("UseSkin",0);
		return SendClientMessage(playerid,yellow,"{FFFFFF}Вы остановили процедуру выбора авто-скина");
	} else return SendClientMessage(playerid,red,"{FFFFFF}Вы должны быть админом");
}

//====================== [REGISTER  &  LOGIN] ==================================
#if defined USE_AREGISTER

dcmd_aregister(playerid,params[])
{
	if (PlayerInfo[playerid][LoggedIn] == 1) return SendClientMessage(playerid,red,"{FFFFFF}Вы уже зарегистрированы и авторизованы.");
	if (udb_Exists(PlayerName2(playerid))) return SendClientMessage(playerid,red,"{FFFFFF}Этот ник зарегистрирован, если он ваш то залоинитесь командой /alogin [пароль].");
	if (strlen(params) == 0) return SendClientMessage(playerid,red,"{FFFFFF}/aregister [пароль]'");
	if (strlen(params) < 4 || strlen(params) > 20) return SendClientMessage(playerid,red,"{FFFFFF}Длинна пароля не должна быть большой");
	if (udb_Create(PlayerName2(playerid),params))
	{
		new file[256],name[MAX_PLAYER_NAME], tmp3[100];
		new strdate[20], year,month,day;	getdate(year, month, day);
		GetPlayerName(playerid,name,sizeof(name)); format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(name));
		GetPlayerIp(playerid,tmp3,100);	dini_Set(file,"ip",tmp3);
		//    	dini_Set(file,"password",params);
		dUserSetINT(PlayerName2(playerid)).("registered",1);
		format(strdate, sizeof(strdate), "%d/%d/%d",day,month,year);
		dini_Set(file,"RegisteredDate",strdate);
		dUserSetINT(PlayerName2(playerid)).("loggedin",1);
		dUserSetINT(PlayerName2(playerid)).("banned",0);
		dUserSetINT(PlayerName2(playerid)).("level",0);
		dUserSetINT(PlayerName2(playerid)).("LastOn",0);
		dUserSetINT(PlayerName2(playerid)).("money",0);
		dUserSetINT(PlayerName2(playerid)).("kills",0);
		dUserSetINT(PlayerName2(playerid)).("deaths",0);
		PlayerInfo[playerid][LoggedIn] = 1;
		PlayerInfo[playerid][Registered] = 1;
		SendClientMessage(playerid, green, "{FFFFFF}Вы зарегистрированы, вы автоматически авторизованы");
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return 1;
	}
	return 1;
}

dcmd_alogin(playerid,params[])
{
	if (PlayerInfo[playerid][LoggedIn] == 1) return SendClientMessage(playerid,red,"{FFFFFF}Вы уже зарегистрированы и авторизованы.");
	if (!udb_Exists(PlayerName2(playerid))) return SendClientMessage(playerid,red,"{FFFFFF}Ник не зарегистрирован. Пожалуйста, зарегистрируйтесь командой /aregister [пароль]'.");
	if (strlen(params)==0) return SendClientMessage(playerid,red,"{FFFFFF}'/alogin [password]'");
	if (udb_CheckLogin(PlayerName2(playerid),params))
	{
		new file[256], tmp3[100], string[128];
		format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(PlayerName2(playerid)) );
		GetPlayerIp(playerid,tmp3,100);
		dini_Set(file,"ip",tmp3);
		LoginPlayer(playerid);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		if(PlayerInfo[playerid][Level] > 0) {
			format(string,sizeof(string),"{FFFFFF}Вы успешно авторизовались. (Уровень %d)", PlayerInfo[playerid][Level] );
			return SendClientMessage(playerid,green,string);
		} else return SendClientMessage(playerid,green,"{FFFFFF}Вы успешно авторизовались");
	}
	else {
		PlayerInfo[playerid][FailLogin]++;
		printf("LOGIN: %s has failed to login, Wrong password (%s) Attempt (%d)", PlayerName2(playerid), params, PlayerInfo[playerid][FailLogin] );
		if(PlayerInfo[playerid][FailLogin] == MAX_FAIL_LOGINS)
		{
			new string[128]; format(string, sizeof(string), " %s кикнут системой (Причина: Несколько раз ввел неверный пароль)", PlayerName2(playerid) );
			SendClientMessageToAll(COLOR_RED, string); print(string);
			Kick(playerid);
		}
		return SendClientMessage(playerid,red,"{FFFFFF}Не правильный пароль!");
	}
}

dcmd_achangepass(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1)	{
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/achangepass [пароль]");
		if(strlen(params) < 4) return SendClientMessage(playerid,red,"{FFFFFF}Неверный пароль");
		new string[128];
		dUserSetINT(PlayerName2(playerid)).("password_hash",udb_hash(params) );
		dUserSet(PlayerName2(playerid)).("Password",params);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		format(string, sizeof(string),"{FFFFFF}Вы успешно сменили свой пароль на [ %s ]",params);
		return SendClientMessage(playerid,yellow,string);
	} else return SendClientMessage(playerid,red, " {FFFFFF}Вы должны зарегистрироваться чтобы использовать эту команду");
}

#if defined USE_STATS
dcmd_aresetstats(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1)	{
		// save as backup
		dUserSetINT(PlayerName2(playerid)).("oldkills",PlayerInfo[playerid][Kills]);
		dUserSetINT(PlayerName2(playerid)).("olddeaths",PlayerInfo[playerid][Deaths]);
		// stats reset
		PlayerInfo[playerid][Kills] = 0;
		PlayerInfo[playerid][Deaths] = 0;
		dUserSetINT(PlayerName2(playerid)).("kills",PlayerInfo[playerid][Kills]);
		dUserSetINT(PlayerName2(playerid)).("deaths",PlayerInfo[playerid][Deaths]);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return SendClientMessage(playerid,yellow,"{FFFFFF}Вы успешно перезагрузили вашу статистику. Вас убили и вы умерли: 0 раз");
	} else return SendClientMessage(playerid,red, " {FFFFFF}Вы должны зарегистрироваться чтобы использовать эту команду");
}

dcmd_astats(playerid,params[]) {
	new string[128], pDeaths, player1;
	if(!strlen(params)) player1 = playerid;
	else player1 = strval(params);

	if(IsPlayerConnected(player1)) {
		if(PlayerInfo[player1][Deaths] == 0) pDeaths = 1; else pDeaths = PlayerInfo[player1][Deaths];
		format(string, sizeof(string), " *** Статистика %s:  Убил: %d | Сдох: %d | Процент: %0.2f | Денег: $%d ",PlayerName2(player1), PlayerInfo[player1][Kills], PlayerInfo[player1][Deaths], Float:PlayerInfo[player1][Kills]/Float:pDeaths,GetPlayerMoney(player1));
		return SendClientMessage(playerid, green, string);
	} else return SendClientMessage(playerid, red, " Нет такого игрока!");
}
#endif


#else

dcmd_changepass(playerid,params[]) {
	if(PlayerInfo[playerid][LoggedIn] == 1)	{
		if(!strlen(params)) return SendClientMessage(playerid, red, " {FFFFFF}/changepass [новый пароль]");
		if(strlen(params) < 4) return SendClientMessage(playerid,red,"{FFFFFF}Неверный пароль");
		new string[128];
		dUserSetINT(PlayerName2(playerid)).("password_hash",udb_hash(params) );
		dUserSet(PlayerName2(playerid)).("Password",params);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		format(string, sizeof(string),"{FFFFFF}Вы успешно сменили пароль на [ %s ]",params);
		return SendClientMessage(playerid,yellow,string);
	} else return SendClientMessage(playerid,red, " {FFFFFF}Вы должны зарегистрироваться, чтобы использовать эту команду");
}

#if defined USE_STATS
dcmd_resetstats(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][LoggedIn] == 1)	{
		// save as backup
		dUserSetINT(PlayerName2(playerid)).("oldkills",PlayerInfo[playerid][Kills]);
		dUserSetINT(PlayerName2(playerid)).("olddeaths",PlayerInfo[playerid][Deaths]);
		// stats reset
		PlayerInfo[playerid][Kills] = 0;
		PlayerInfo[playerid][Deaths] = 0;
		dUserSetINT(PlayerName2(playerid)).("kills",PlayerInfo[playerid][Kills]);
		dUserSetINT(PlayerName2(playerid)).("deaths",PlayerInfo[playerid][Deaths]);
		PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
		return SendClientMessage(playerid,yellow,"{FFFFFF}Ваша статистика успешно перезагружена. Вас убили и вы умерли: 0 раз");
	} else return SendClientMessage(playerid,red, " {FFFFFF}Вы должны зарегистрироваться, чтобы использовать эту команду");
}
#endif

#if defined USE_STATS
dcmd_stats(playerid,params[]) {
	new string[128], pDeaths, player1;
	if(!strlen(params)) player1 = playerid;
	else player1 = strval(params);

	if(IsPlayerConnected(player1)) {
		if(PlayerInfo[player1][Deaths] == 0) pDeaths = 1; else pDeaths = PlayerInfo[player1][Deaths];
		format(string, sizeof(string), " *** Статистика %s:  Убил: %d | Сдох: %d | Процент: %0.2f | Деньги: $%d ",PlayerName2(player1), PlayerInfo[player1][Kills], PlayerInfo[player1][Deaths], Float:PlayerInfo[player1][Kills]/Float:pDeaths,GetPlayerMoney(player1));
		return SendClientMessage(playerid, green, string);
	} else return SendClientMessage(playerid, red, " Нет такого игрока!");
}
#endif


#endif


LoginPlayer(playerid)
{
	if(ServerInfo[GiveMoney] == 1) {ResetPlayerMoney(playerid); GivePlayerMoney(playerid,dUserINT(PlayerName2(playerid)).("money")); }
	dUserSetINT(PlayerName2(playerid)).("loggedin",1);
	PlayerInfo[playerid][Deaths] = (dUserINT(PlayerName2(playerid)).("deaths"));
	PlayerInfo[playerid][Kills] = (dUserINT(PlayerName2(playerid)).("kills"));
	PlayerInfo[playerid][Level] = (dUserINT(PlayerName2(playerid)).("level"));
	PlayerInfo[playerid][Registered] = 1;
	PlayerInfo[playerid][LoggedIn] = 1;
}

//==============================================================================
public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!PlayerInfo[playerid][LoggedIn] && strcmp("/login",cmdtext,true)==-1 && strcmp("/register",cmdtext,true)==-1)
	{
	    SendClientMessage(playerid,-1,"{FFFFFF}Вы должны залогиниться, чтобы использовать команды!");
	    return 1;
	}
	
	fixchars(cmdtext);
	if(PlayerInfo[playerid][Jailed] == 1 && PlayerInfo[playerid][Level] < 1) return
	SendClientMessage(playerid,red,"{FFFFFF} Вы не можете пользоваться командами в тюрьме");

	new cmd[256], string[128], tmp[256], idx;
	cmd = strtok(cmdtext, idx);
	
	dcmd(register,8,cmdtext);
	dcmd(login,5,cmdtext);

	#if defined USE_AREGISTER
	dcmd(aregister,9,cmdtext);
	dcmd(alogin,6,cmdtext);
	dcmd(achangepass,11,cmdtext);

	#if defined USE_STATS
	dcmd(astats,6,cmdtext);
	dcmd(aresetstats,11,cmdtext);
	#endif

	#else
	dcmd(changepass,10,cmdtext);
	dcmd(stats,5,cmdtext);
	dcmd(resetstats,10,cmdtext);
	#endif

	dcmd(report,6,cmdtext);
	dcmd(reports,7,cmdtext);

	//================ [ Read Comamands ] ===========================//
	if(ServerInfo[ReadCmds] == 1)
	{
		format(string, sizeof(string), " %s(ID:%d) использовал команду: %s", pName(playerid),playerid,cmdtext);
		for(new i = 0; i < GetMaxPlayers(); i++) {
			if(IsPlayerConnected(i)) {
				if( (PlayerInfo[i][Level] > PlayerInfo[playerid][Level]) && (PlayerInfo[i][Level] > 1) && (i != playerid) ) {
					SendClientMessage(i, grey, string);
				}
			}
		}
	}

	//-= Spectate Commands =-//
	#if defined ENABLE_SPEC
	dcmd(lspec,5,cmdtext);
	dcmd(lspecoff,8,cmdtext);
	dcmd(lspecvehicle,12,cmdtext);
	#endif

	//-= Chat Commands =-//
	dcmd(disablechat,11,cmdtext);
	dcmd(clearchat,9,cmdtext);
	dcmd(cc,2,cmdtext);
	dcmd(caps,4,cmdtext);

	//-= Vehicle Commands =-//
	dcmd(destroycar,10,cmdtext);
	dcmd(lockcar,7,cmdtext);
	dcmd(unlockcar,9,cmdtext);
	dcmd(carhealth,9,cmdtext);
	dcmd(carcolour,9,cmdtext);
	dcmd(car,3,cmdtext);
	dcmd(vr,2,cmdtext);
	dcmd(fix,3,cmdtext);
	dcmd(repair,6,cmdtext);
	dcmd(ltune,5,cmdtext);
	dcmd(lhy,3,cmdtext);
	dcmd(lcar,4,cmdtext);
	dcmd(lbike,5,cmdtext);
	dcmd(lheli,5,cmdtext);
	dcmd(lboat,5,cmdtext);
	dcmd(lnos,4,cmdtext);
	dcmd(lplane,6,cmdtext);
	dcmd(vgoto,5,cmdtext);
	dcmd(vget,4,cmdtext);
	dcmd(givecar,7,cmdtext);
	dcmd(ltc,3,cmdtext);
	dcmd(linkcar,7,cmdtext);

	//-= Playerid Commands =-//
	dcmd(crash,5,cmdtext);
	dcmd(ip,2,cmdtext);
	dcmd(force,5,cmdtext);
	dcmd(burn,4,cmdtext);
	dcmd(spawn,5,cmdtext);
	dcmd(spawnplayer,11,cmdtext);
	dcmd(disarm,6,cmdtext);
	dcmd(eject,5,cmdtext);
	dcmd(bankrupt,8,cmdtext);
	dcmd(sbankrupt,9,cmdtext);
	dcmd(setworld,8,cmdtext);
	dcmd(setinterior,11,cmdtext);
	dcmd(ubound,6,cmdtext);
	dcmd(setwanted,9,cmdtext);
	dcmd(setcolour,9,cmdtext);
	dcmd(settime,7,cmdtext);
	dcmd(setweather,10,cmdtext);
	dcmd(setname,7,cmdtext);
	dcmd(setskin,7,cmdtext);
	dcmd(setscore,8,cmdtext);
	dcmd(setcash,7,cmdtext);
	dcmd(sethealth,9,cmdtext);
	dcmd(setarmour,9,cmdtext);
	dcmd(giveweapon,10,cmdtext);
	dcmd(warp,4,cmdtext);
	dcmd(teleplayer,10,cmdtext);
	dcmd(goto,4,cmdtext);
	dcmd(gethere,7,cmdtext);
	dcmd(get,3,cmdtext);
	dcmd(setlevel,8,cmdtext);
	dcmd(settemplevel,12,cmdtext);
	dcmd(fu,2,cmdtext);
	dcmd(warn,4,cmdtext);
	dcmd(kick,4,cmdtext);
	dcmd(ban,3,cmdtext);
	dcmd(rban,4,cmdtext);
	dcmd(slap,4,cmdtext);
	dcmd(explode,7,cmdtext);
	dcmd(jail,4,cmdtext);
	dcmd(unjail,6,cmdtext);
	dcmd(jailed,6,cmdtext);
	dcmd(freeze,6,cmdtext);
	dcmd(unfreeze,8,cmdtext);
	dcmd(frozen,6,cmdtext);
	dcmd(mute,4,cmdtext);
	dcmd(unmute,6,cmdtext);
	dcmd(muted,5,cmdtext);
	dcmd(akill,5,cmdtext);
	dcmd(weaps,5,cmdtext);
	dcmd(screen,6,cmdtext);
	dcmd(lgoto,5,cmdtext);
	dcmd(aka,3,cmdtext);
	dcmd(highlight,9,cmdtext);

	//-= /All Commands =-//
	dcmd(healall,7,cmdtext);
	dcmd(armourall,9,cmdtext);
	dcmd(muteall,7,cmdtext);
	dcmd(unmuteall,9,cmdtext);
	dcmd(killall,7,cmdtext);
	dcmd(getall,6,cmdtext);
	dcmd(spawnall,8,cmdtext);
	dcmd(freezeall,9,cmdtext);
	dcmd(unfreezeall,11,cmdtext);
	dcmd(explodeall,10,cmdtext);
	dcmd(kickall,7,cmdtext);
	dcmd(slapall,7,cmdtext);
	dcmd(ejectall,8,cmdtext);
	dcmd(disarmall,9,cmdtext);
	dcmd(setallskin,10,cmdtext);
	dcmd(setallwanted,12,cmdtext);
	dcmd(setallweather,13,cmdtext);
	dcmd(setalltime,10,cmdtext);
	dcmd(setallworld,11,cmdtext);
	dcmd(setallscore,11,cmdtext);
	dcmd(setallcash,10,cmdtext);
	dcmd(giveallcash,11,cmdtext);
	dcmd(giveallweapon,13,cmdtext);

	//-= No params =-//
	dcmd(lslowmo,7,cmdtext);
	dcmd(lweaps,6,cmdtext);
	dcmd(lammo,5,cmdtext);
	dcmd(god,3,cmdtext);
	dcmd(sgod,4,cmdtext);
	dcmd(godcar,6,cmdtext);
	dcmd(die,3,cmdtext);
	dcmd(jetpack,7,cmdtext);
	dcmd(admins,6,cmdtext);
	dcmd(morning,7,cmdtext);

	//-= Admin special =-//
	dcmd(saveplace,9,cmdtext);
	dcmd(gotoplace,9,cmdtext);
	dcmd(saveskin,8,cmdtext);
	dcmd(useskin,7,cmdtext);
	dcmd(dontuseskin,11,cmdtext);

	//-= Config =-//
	dcmd(disable,7,cmdtext);
	dcmd(enable,6,cmdtext);
	dcmd(setping,7,cmdtext);
	dcmd(setgravity,10,cmdtext);
	dcmd(uconfig,7,cmdtext);
	dcmd(lconfig,7,cmdtext);
	dcmd(forbidname,10,cmdtext);
	dcmd(forbidword,10,cmdtext);

	//-= Misc =-//
	dcmd(setmytime,9,cmdtext);
	dcmd(kill,4,cmdtext);
	dcmd(time,4,cmdtext);
	dcmd(lhelp,5,cmdtext);
	dcmd(lcmds,5,cmdtext);
	dcmd(lcommands,9,cmdtext);
	dcmd(lcredits,8,cmdtext);
	dcmd(serverinfo,10,cmdtext);
	dcmd(getid,5,cmdtext);
	dcmd(getinfo,7,cmdtext);
	dcmd(laston,6,cmdtext);
	dcmd(ping,4,cmdtext);
	dcmd(asay,4,cmdtext);
	dcmd(password,8,cmdtext);
	dcmd(lockserver,10,cmdtext);
	dcmd(unlockserver,12,cmdtext);
	dcmd(adminarea,9,cmdtext);
	dcmd(announce,8,cmdtext);
	dcmd(announce2,9,cmdtext);
	dcmd(richlist,8,cmdtext);
	dcmd(miniguns,8,cmdtext);
	dcmd(botcheck,8,cmdtext);
	dcmd(object,6,cmdtext);
	dcmd(pickup,6,cmdtext);
	dcmd(invisible,9,cmdtext);
	dcmd(killinvis,9,cmdtext);
	dcmd(invis,5,cmdtext);
	dcmd(uninvis,7,cmdtext);
	dcmd(move,4,cmdtext);
	dcmd(moveplayer,10,cmdtext);

	#if defined ENABLE_FAKE_CMDS
	dcmd(fakedeath,9,cmdtext);
	dcmd(fakechat,8,cmdtext);
	dcmd(fakecmd,7,cmdtext);
	#endif

	//-= Menu Commands =-//
	#if defined USE_MENUS
	dcmd(lmenu,5,cmdtext);
	dcmd(ltele,5,cmdtext);
	dcmd(lvehicle,8,cmdtext);
	dcmd(lweapons,8,cmdtext);
	dcmd(lweather,8,cmdtext);
	dcmd(ltmenu,6,cmdtext);
	dcmd(ltime,5,cmdtext);
	dcmd(cm,2,cmdtext);
	#endif




	//========================= [ Car Commands ]====================================

	if(strcmp(cmdtext, "/ltunedcar2", true)==0 || strcmp(cmdtext, "/ltc2", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); CMDMessageToAdmins(playerid,"LTunedCar");	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
				AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
				AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,1);
				SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = LVehicleIDt;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar3", true)==0 || strcmp(cmdtext, "/ltc3", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); CMDMessageToAdmins(playerid,"LTunedCar");	    AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
				AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,2);
				SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = LVehicleIDt;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar4", true)==0 || strcmp(cmdtext, "/ltc4", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(559,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				AddVehicleComponent(carid,1065);    AddVehicleComponent(carid,1067);    AddVehicleComponent(carid,1162); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073);	ChangeVehiclePaintjob(carid,1);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar5", true)==0 || strcmp(cmdtext, "/ltc5", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(565,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				AddVehicleComponent(carid,1046); AddVehicleComponent(carid,1049); AddVehicleComponent(carid,1053); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar6", true)==0 || strcmp(cmdtext, "/ltc6", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				AddVehicleComponent(carid,1088); AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1139); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar7", true)==0 || strcmp(cmdtext, "/ltc7", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(561,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				AddVehicleComponent(carid,1055); AddVehicleComponent(carid,1058); AddVehicleComponent(carid,1064); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar8", true)==0 || strcmp(cmdtext, "/ltc8", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar9", true)==0 || strcmp(cmdtext, "/ltc9", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(567,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				AddVehicleComponent(carid,1102); AddVehicleComponent(carid,1129); AddVehicleComponent(carid,1133); AddVehicleComponent(carid,1186); AddVehicleComponent(carid,1188); ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1085); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1086);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar10", true)==0 || strcmp(cmdtext, "/ltc10", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1166); AddVehicleComponent(carid,1165); AddVehicleComponent(carid,1090);
				AddVehicleComponent(carid,1094); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1163);//SPOILER
				AddVehicleComponent(carid,1091); ChangeVehiclePaintjob(carid,2);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar11", true)==0 || strcmp(cmdtext, "/ltc11", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(557,X,Y,Z,Angle,1,1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1081);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar12", true)==0 || strcmp(cmdtext, "/ltc12", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) {
				SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			} else  {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(535,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1109); AddVehicleComponent(carid,1115); AddVehicleComponent(carid,1117); AddVehicleComponent(carid,1073); AddVehicleComponent(carid,1010);
				AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1114); AddVehicleComponent(carid,1081); AddVehicleComponent(carid,1119); AddVehicleComponent(carid,1121);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmdtext, "/ltunedcar13", true)==0 || strcmp(cmdtext, "/ltc13", true)==0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if(IsPlayerInAnyVehicle(playerid)) SendClientMessage(playerid,red,"{FFFFFF}У вас есть транспорт");
			else {
				if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
				new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
				carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0); CMDMessageToAdmins(playerid,"LTunedCar");
				AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147);
				AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,0);
				SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
				PlayerInfo[playerid][pCar] = carid;
			}
		} else SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");
		return 1;	}
	//------------------------------------------------------------------------------
	if(strcmp(cmd, "/lp", true) == 0)	{
		if(PlayerInfo[playerid][Level] >= 1) {
			if (GetPlayerState(playerid) == 2)
			{
				new VehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(VehicleID);
				switch(LModel) { case 448,461,462,463,468,471,509,510,521,522,523,581,586, 449: return SendClientMessage(playerid,red,"{FFFFFF}Вы не можете тюнинговать этот транспорт"); }
				new str[128], Float:pos[3];	format(str, sizeof(str), "%s", cmdtext[2]);
				SetVehicleNumberPlate(VehicleID, str);
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);	SetPlayerPos(playerid, pos[0]+1, pos[1], pos[2]);
				SetVehicleToRespawn(VehicleID); SetVehiclePos(VehicleID, pos[0], pos[1], pos[2]);
				SetTimerEx("TuneLCar",4000,0,"d",VehicleID);    PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				SendClientMessage(playerid, COLOR_GREEN, " Ваша машина была изьята на прокачку");   CMDMessageToAdmins(playerid,"LP");
			} else {
				SendClientMessage(playerid,red,"{FFFFFF}Вы не в машине");	}
		} else	{
			SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 1 уровень");   }
		return 1;	}

	//------------------------------------------------------------------------------
	if(strcmp(cmd, "/spam", true) == 0)	{
		if(PlayerInfo[playerid][Level] >= 10) {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) {
				SendClientMessage(playerid, red, " {FFFFFF}/spam [№ цвета] [текст]");
				SendClientMessage(playerid, red, " Цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
				return 1;
			}
			new Colour = strval(tmp);
			if(Colour > 9 ) return SendClientMessage(playerid, red, " Цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
			tmp = strtok(cmdtext, idx);

			format(string,sizeof(string)," %s",cmdtext[8]);

			if(Colour == 0) 	 for(new i; i < 50; i++) SendClientMessageToAll(black,string);
			else if(Colour == 1) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_WHITE,string);
			else if(Colour == 2) for(new i; i < 50; i++) SendClientMessageToAll(red,string);
			else if(Colour == 3) for(new i; i < 50; i++) SendClientMessageToAll(orange,string);
			else if(Colour == 4) for(new i; i < 50; i++) SendClientMessageToAll(yellow,string);
			else if(Colour == 5) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_GREEN1,string);
			else if(Colour == 6) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_BLUE,string);
			else if(Colour == 7) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_PURPLE,string);
			else if(Colour == 8) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_BROWN,string);
			else if(Colour == 9) for(new i; i < 50; i++) SendClientMessageToAll(COLOR_PINK,string);
			return 1;
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 10 уровень");
	}

	//------------------------------------------------------------------------------
	if(strcmp(cmd, "/write", true) == 0) {
		if(PlayerInfo[playerid][Level] >= 2) {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) {
				SendClientMessage(playerid, red, " {FFFFFF}/write [№ цвета] [текст]");
				return SendClientMessage(playerid, red, " Цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
			}
			new Colour;
			Colour = strval(tmp);
			if(Colour > 9 )	{
				SendClientMessage(playerid, red, " {FFFFFF}/write [Colour] [Text]");
				return SendClientMessage(playerid, red, " Цвета: 0=черный 1=белый 2=красный 3=оранжевый 4=желтый 5=зеленый 6=синий 7=фиолетовый 8=коричневый 9=розовый");
			}
			tmp = strtok(cmdtext, idx);

			CMDMessageToAdmins(playerid,"WRITE");

			if(Colour == 0) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(black,string); return 1;	}
			else if(Colour == 1) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(COLOR_WHITE,string); return 1;	}
			else if(Colour == 2) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(red,string); return 1;	}
			else if(Colour == 3) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(orange,string); return 1;	}
			else if(Colour == 4) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(yellow,string); return 1;	}
			else if(Colour == 5) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(COLOR_GREEN1,string); return 1;	}
			else if(Colour == 6) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(COLOR_BLUE,string); return 1;	}
			else if(Colour == 7) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(COLOR_PURPLE,string); return 1;	}
			else if(Colour == 8) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(COLOR_BROWN,string); return 1;	}
			else if(Colour == 9) {	format(string,sizeof(string)," %s",cmdtext[9]);	SendClientMessageToAll(COLOR_PINK,string); return 1;	}
			return 1;
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас должен быть 2 уровень");
	}

	//------------------------------------------------------------------------------
	//                      Remote Console
	//------------------------------------------------------------------------------

	if(strcmp(cmd, "/loadfs", true) == 0) {
		if(PlayerInfo[playerid][Level] >= 10) {
			new str[128]; format(str,sizeof(string),"%s",cmdtext[1]); SendRconCommand(str);
			return SendClientMessage(playerid,COLOR_WHITE," Скрипт загружен, если вы ввели верное название файла");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	}

	if(strcmp(cmd, "/unloadfs", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 10) {
			new str[128]; format(str,sizeof(string),"%s",cmdtext[1]); SendRconCommand(str);
			return SendClientMessage(playerid,COLOR_WHITE," Скрипт выгружен, если вы ввели верное название файла");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	}

	if(strcmp(cmd, "/changemode", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 10) {
			new str[128]; format(str,sizeof(string),"%s",cmdtext[1]); SendRconCommand(str);
			return SendClientMessage(playerid,COLOR_WHITE," Сейчас будет сменен мод, если вы верно ввели название файла");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	}

	if(strcmp(cmd, "/gmx", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 10) {
			OnFilterScriptExit(); SetTimer("RestartGM",5000,0);
			return SendClientMessage(playerid,COLOR_WHITE," Сейчас будет рестарт");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	}

	if(strcmp(cmd, "/loadladmin", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 10) {
			SendRconCommand("loadfs ladmin4");
			return SendClientMessage(playerid,COLOR_WHITE," Админка загружена");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	}

	if(strcmp(cmd, "/unloadladmin", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 10) {
			SendRconCommand("unloadfs ladmin4");
			return SendClientMessage(playerid,COLOR_WHITE," Админка выгружена");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	}

	if(strcmp(cmd, "/reloadladmin", true) == 0)	 {
		if(PlayerInfo[playerid][Level] >= 10 || IsPlayerAdmin(playerid) ) {
			SendRconCommand("reloadfs ladmin4");
			SendClientMessage(playerid,COLOR_WHITE," Админка перезагружена");
			return CMDMessageToAdmins(playerid,"RELOADLADMIN");
		} else return SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
	}


	return 0;
}


//==============================================================================
#if defined ENABLE_SPEC

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	new x = 0;
	while(x!=GetMaxPlayers()) {
		if( IsPlayerConnected(x) &&	GetPlayerState(x) == PLAYER_STATE_SPECTATING &&
				PlayerInfo[x][SpecID] == playerid && PlayerInfo[x][SpecType] == ADMIN_SPEC_TYPE_PLAYER )
		{
			SetPlayerInterior(x,newinteriorid);
		}
		x++;
	}
}

//==============================================================================
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][SpecID] != INVALID_PLAYER_ID)
	{
		if(newkeys == KEY_JUMP) AdvanceSpectate(playerid);
		else if(newkeys == KEY_SPRINT) ReverseSpectate(playerid);
	}
	return 1;
}

//==============================================================================
public OnPlayerEnterVehicle(playerid, vehicleid) {
	for(new x=0; x<GetMaxPlayers(); x++) {
		if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid) {
			TogglePlayerSpectating(x, 1);
			PlayerSpectateVehicle(x, vehicleid);
			PlayerInfo[x][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
		}
	}
	return 1;
}
//==============================================================================
public OnPlayerStateChange(playerid, newstate, oldstate) {
	switch(newstate) {
	case PLAYER_STATE_ONFOOT: {
			switch(oldstate) {
			case PLAYER_STATE_DRIVER: OnPlayerExitVehicle(playerid,255);
			case PLAYER_STATE_PASSENGER: OnPlayerExitVehicle(playerid,255);
			}
		}
	}
	return 1;
}

#endif
//==============================================================================
public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(PlayerInfo[playerid][Invis] == 1) EraseVehicle(vehicleid);
	if(PlayerInfo[playerid][DoorsLocked] == 1) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),playerid,false,false);

#if defined ENABLE_SPEC
	for(new x=0; x<GetMaxPlayers(); x++) {
		if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid && PlayerInfo[x][SpecType] == ADMIN_SPEC_TYPE_VEHICLE) {
			TogglePlayerSpectating(x, 1);
			PlayerSpectatePlayer(x, playerid);
			PlayerInfo[x][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
		}
	}
#endif

	return 1;
}

//==============================================================================
#if defined ENABLE_SPEC

stock StartSpectate(playerid, specplayerid)
{
	for(new x=0; x<GetMaxPlayers(); x++) {
		if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] == playerid) {
			AdvanceSpectate(x);
		}
	}
	if(IsPlayerInAnyVehicle(specplayerid)) {
		SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid));
		PlayerInfo[playerid][SpecID] = specplayerid;
		PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else {
		SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayer(playerid, specplayerid);
		PlayerInfo[playerid][SpecID] = specplayerid;
		PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	new string[100];
	GetPlayerName(specplayerid,string,sizeof(string));
	new Float:avwe[2]; GetPlayerHealth(specplayerid,avwe[0]); GetPlayerArmour(specplayerid,avwe[1]);
	format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~w~%s - id:%d~n~< HAGMNTE - ZPSFATJ >~n~GN3HN:%0.1f 6POHR:%0.1f CYMMA:%d", string,specplayerid,avwe[0],avwe[1],GetPlayerMoney(specplayerid) );
	GameTextForPlayer(playerid,string,25000,3);
	return 1;
}

stock StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	PlayerInfo[playerid][SpecID] = INVALID_PLAYER_ID;
	PlayerInfo[playerid][SpecType] = ADMIN_SPEC_TYPE_NONE;
	GameTextForPlayer(playerid,"~n~~n~~n~~w~CLEGKA 3AKOH4EHA",1000,3);
	return 1;
}

stock AdvanceSpectate(playerid)
{
	if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][SpecID] != INVALID_PLAYER_ID) {
		for(new x=PlayerInfo[playerid][SpecID]+1; x<GetMaxPlayers(); x++) {
			if(x == GetMaxPlayers()) { x = 0; }
			if(IsPlayerConnected(x) && x != playerid) {
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] != INVALID_PLAYER_ID ||
						(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else {
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

stock ReverseSpectate(playerid)
{
	if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerInfo[playerid][SpecID] != INVALID_PLAYER_ID) {
		for(new x=PlayerInfo[playerid][SpecID]-1; x>=0; x--) {
			if(x == 0) { x = GetMaxPlayers(); }
			if(IsPlayerConnected(x) && x != playerid) {
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerInfo[x][SpecID] != INVALID_PLAYER_ID ||
						(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else {
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

//-------------------------------------------
forward PosAfterSpec(playerid);
public PosAfterSpec(playerid) {
	SetPlayerPos(playerid,Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]);
	SetPlayerFacingAngle(playerid,Pos[playerid][3]);
}
#endif

//==============================================================================
EraseVehicle(vehicleid)
{
	for(new players=0;players<GetMaxPlayers();players++)
	{
		new Float:X,Float:Y,Float:Z;
		if (IsPlayerInVehicle(players,vehicleid))
		{
			GetPlayerPos(players,X,Y,Z);
			SetPlayerPos(players,X,Y,Z+2);
			SetVehicleToRespawn(vehicleid);
		}
		SetVehicleParamsForPlayer(vehicleid,players,0,1);
	}
	SetTimerEx("VehRes",3000,0,"d",vehicleid);
	return 1;
}

//==============================================================================

forward CarSpawner(playerid,model);
public CarSpawner(playerid,model)
{
	if(IsPlayerInAnyVehicle(playerid)) SendClientMessage(playerid, red, " У вас есть автомобиль!");
	else
	{
		new Float:x, Float:y, Float:z, Float:angle;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
		new vehicleid=CreateVehicle(model, x, y, z, angle, -1, -1, -1);
		PutPlayerInVehicle(playerid, vehicleid, 0);
		SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
		ChangeVehicleColor(vehicleid,0,7);
		PlayerInfo[playerid][pCar] = vehicleid;
	}
	return 1;
}

forward CarDeleter(vehicleid);
public CarDeleter(vehicleid)
{
	for(new i=0;i<GetMaxPlayers();i++) {
		new Float:X,Float:Y,Float:Z;
		if(IsPlayerInVehicle(i, vehicleid)) {
			RemovePlayerFromVehicle(i);
			GetPlayerPos(i,X,Y,Z);
			SetPlayerPos(i,X,Y+3,Z);
		}
		SetVehicleParamsForPlayer(vehicleid,i,0,1);
	}
	SetTimerEx("VehRes",1500,0,"i",vehicleid);
}

forward VehRes(vehicleid);
public VehRes(vehicleid)
{
	DestroyVehicle(vehicleid);
}

public OnVehicleSpawn(vehicleid)
{
	for(new i=0;i<GetMaxPlayers();i++)
	{
		if(vehicleid==PlayerInfo[i][pCar])
		{
			CarDeleter(vehicleid);
			PlayerInfo[i][pCar]=-1;
		}
	}
	return 1;
}
//==============================================================================
forward TuneLCar(VehicleID);
public TuneLCar(VehicleID)
{
	ChangeVehicleColor(VehicleID,0,7);
	AddVehicleComponent(VehicleID, 1010);  AddVehicleComponent(VehicleID, 1087);
}

//==============================================================================

public OnRconCommand(cmd[])
{
	if( strlen(cmd) > 50 || strlen(cmd) == 1 ) return print("Не верно введенный RCON пароль (50 раз)");

	if(strcmp(cmd, "ladmin", true)==0) {
		print("Rcon Commands");
		print("info, aka, pm, asay, ann, uconfig, chat");
		return true;
	}

	if(strcmp(cmd, "info", true)==0)
	{
		new TotalVehicles = CreateVehicle(411, 0, 0, 0, 0, 0, 0, 1000);    DestroyVehicle(TotalVehicles);
		new numo = CreateObject(1245,0,0,1000,0,0,0);	DestroyObject(numo);
		new nump = CreatePickup(371,2,0,0,1000);	DestroyPickup(nump);
		new gz = GangZoneCreate(3,3,5,5);	GangZoneDestroy(gz);

		new model[250], nummodel;
		for(new i=1;i<TotalVehicles;i++) model[GetVehicleModel(i)-400]++;
		for(new i=0;i<250;i++) { if(model[i]!=0) {	nummodel++;	}	}

		new string[256];
		print(" ===========================================================================");
		printf("                           INFO O CEPBEPE:");
		format(string,sizeof(string),"[ Players Connected: %d || Maximum Players: %d ] [Ratio %0.2f ]",ConnectedPlayers(),GetMaxPlayers(),Float:ConnectedPlayers() / Float:GetMaxPlayers() );
		printf(string);
		format(string,sizeof(string),"[ Vehicles: %d || Models %d || Players In Vehicle: %d ]",TotalVehicles-1,nummodel, InVehCount() );
		printf(string);
		format(string,sizeof(string),"[ InCar %d  ||  OnBike %d ]",InCarCount(),OnBikeCount() );
		printf(string);
		format(string,sizeof(string),"[ Objects: %d || Pickups %d  || Gangzones %d]",numo-1, nump, gz);
		printf(string);
		format(string,sizeof(string),"[ Players In Jail %d || Players Frozen %d || Muted %d ]",JailedPlayers(),FrozenPlayers(), MutedPlayers() );
		printf(string);
		format(string,sizeof(string),"[ Admins online %d  RCON admins online %d ]",AdminCount(), RconAdminCount() );
		printf(string);
		print(" ===========================================================================");
		return true;
	}

	if(!strcmp(cmd, "pm", .length = 2))
	{
		new arg_1 = argpos(cmd), arg_2 = argpos(cmd, arg_1),targetid = strval(cmd[arg_1]), message[128];

		if ( !cmd[arg_1] || cmd[arg_1] < '0' || cmd[arg_1] > '9' || targetid > GetMaxPlayers() || targetid < 0 || !cmd[arg_2])
		print(" PRAVKA: \"pm <playerid> <message>\"");

		else if ( !IsPlayerConnected(targetid) ) print("HET TAKOGO IGROKA!");
		else
		{
			format(message, sizeof(message), "[RCON из консоли]Админ ЛС: %s", cmd[arg_2]);
			SendClientMessage(targetid, COLOR_WHITE, message);
			printf("Rcon PM '%s' sent", cmd[arg_1] );
		}
		return true;
	}

	if(!strcmp(cmd, "asay", .length = 4))
	{
		new arg_1 = argpos(cmd), message[128];

		if ( !cmd[arg_1] || cmd[arg_1] < '0') print(" PRAVKA: \"asay  <message>\" (MessageToAdmins)");
		else
		{
			format(message, sizeof(message), "[RCON из консоли]Сообщение для админов: %s", cmd[arg_1]);
			MessageToAdmins(COLOR_WHITE, message);
			printf("Admin Message '%s' sent", cmd[arg_1] );
		}
		return true;
	}

	if(!strcmp(cmd, "ann", .length = 3))
	{
		new arg_1 = argpos(cmd), message[128];
		if ( !cmd[arg_1] || cmd[arg_1] < '0') print(" PRAVKA: \"ann  <message>\" (GameTextForAll)");
		else
		{
			format(message, sizeof(message), "[RCON из консоли]: %s", cmd[arg_1]);
			GameTextForAll(message,3000,3);
			printf("GameText Message '%s' sent", cmd[arg_1] );
		}
		return true;
	}

	if(!strcmp(cmd, "msg", .length = 3))
	{
		new arg_1 = argpos(cmd), message[128];
		if ( !cmd[arg_1] || cmd[arg_1] < '0') print(" PRAVKA: \"msg  <message>\" (SendClientMessageToAll)");
		else
		{
			format(message, sizeof(message), "[RCON из консоли]: %s", cmd[arg_1]);
			SendClientMessageToAll(COLOR_WHITE, message);
			printf("MessageToAll '%s' sent", cmd[arg_1] );
		}
		return true;
	}

	if(strcmp(cmd, "uconfig", true)==0)
	{
		UpdateConfig();
		print("Configuration Successfully Updated");
		return true;
	}

	if(!strcmp(cmd, "aka", .length = 3))
	{
		new arg_1 = argpos(cmd), targetid = strval(cmd[arg_1]);

		if ( !cmd[arg_1] || cmd[arg_1] < '0' || cmd[arg_1] > '9' || targetid > GetMaxPlayers() || targetid < 0)
		print(" PRAVKA: aka <playerid>");
		else if ( !IsPlayerConnected(targetid) ) print("HET TAKOGO IGROKA!");
		else
		{
			new tmp3[50], playername[MAX_PLAYER_NAME];
			GetPlayerIp(targetid,tmp3,50);
			GetPlayerName(targetid, playername, sizeof(playername));
			printf("AKA: [%s id:%d] [%s] %s", playername, targetid, tmp3, dini_Get("ladmin/config/aka.txt",tmp3) );
		}
		return true;
	}

	if(!strcmp(cmd, "chat", .length = 4)) {
		for(new i = 1; i < MAX_CHAT_LINES; i++) print(Chat[i]);
		return true;
	}

	return 0;
}

//==============================================================================
//							Menus
//==============================================================================

#if defined USE_MENUS
public OnPlayerSelectedMenuRow(playerid, row) {
	new Menu:Current = GetPlayerMenu(playerid);
	new string[128];

	if(Current == LMainMenu) {
		switch(row)
		{
		case 0:
			{	if(PlayerInfo[playerid][Level] >= 4) { ShowMenuForPlayer(AdminEnable,playerid);  TogglePlayerControllable(playerid,true);
				} else {
					SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
					TogglePlayerControllable(playerid,true);
				}
			}
		case 1:
			{	if(PlayerInfo[playerid][Level] >= 4) { ShowMenuForPlayer(AdminDisable,playerid);  TogglePlayerControllable(playerid,true);
				} else {
					SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды");
					TogglePlayerControllable(playerid,true);
				}
			}
		case 2: ShowMenuForPlayer(LWeather,playerid);
		case 3: ShowMenuForPlayer(LTime,playerid);
		case 4:	ShowMenuForPlayer(LVehicles,playerid);
		case 5:	ShowMenuForPlayer(LCars,playerid);
		case 6:
			{
				if(PlayerInfo[playerid][Level] >= 2) {
					if(IsPlayerInAnyVehicle(playerid)) {
						new LVehicleID = GetPlayerVehicleID(playerid), LModel = GetVehicleModel(LVehicleID);
						switch(LModel) { case 448,461,462,463,468,471,509,510,521,522,523,581,586,449:
							{ SendClientMessage(playerid,red,"{FFFFFF}Вы не можете тюнинговать этот транспорт");  TogglePlayerControllable(playerid,true); return 1; }  }
						TogglePlayerControllable(playerid,false);	ShowMenuForPlayer(LTuneMenu,playerid);
					}
					else { SendClientMessage(playerid,red,"{FFFFFF}Вы не можете тюнинговать этот транспорт"); TogglePlayerControllable(playerid,true); }
				} else { SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды"); TogglePlayerControllable(playerid,true);	}
			}
		case 7: { if(PlayerInfo[playerid][Level] >= 3) ShowMenuForPlayer(XWeapons,playerid); else SendClientMessage(playerid,red,"{FFFFFF}У вас недостаточно высокий уровень для использования этой команды"); TogglePlayerControllable(playerid,true);	}
		case 8:	 ShowMenuForPlayer(LTele,playerid);
		case 9:
			{
				new Menu:Currentxmenu = GetPlayerMenu(playerid);
				HideMenuForPlayer(Currentxmenu,playerid);   TogglePlayerControllable(playerid,true);
			}
		} return 1;
	}//-------------------------------------------------------------------------
	if(Current == AdminEnable) {
		new adminname[MAX_PLAYER_NAME], file[256]; GetPlayerName(playerid, adminname, sizeof(adminname));
		format(file,sizeof(file),"ladmin/config/Config.ini");
		switch(row){
		case 0: { ServerInfo[AntiSwear] = 1; dini_IntSet(file,"AntiSwear",1); format(string,sizeof(string)," Админ %s включил анти-мат",adminname); SendClientMessageToAll(COLOR_GREEN,string);	}
		case 1: { ServerInfo[NameKick] = 1; dini_IntSet(file,"NameKick",1); format(string,sizeof(string)," Админ %s включил кик по нику",adminname); SendClientMessageToAll(COLOR_GREEN,string);	}
		case 2:	{ ServerInfo[AntiSpam] = 1; dini_IntSet(file,"AntiSpam",1); format(string,sizeof(string)," Админ %s включил анти-спам",adminname); SendClientMessageToAll(COLOR_GREEN,string);	}
		case 3:	{ ServerInfo[MaxPing] = 1000; dini_IntSet(file,"MaxPing",1000); format(string,sizeof(string)," Админ %s включил кик по пингу",adminname); SendClientMessageToAll(COLOR_GREEN,string);	}
		case 4:	{ ServerInfo[ReadCmds] = 1; dini_IntSet(file,"ReadCmds",1); format(string,sizeof(string)," Админ %s включил чтение команд",adminname); MessageToAdmins(COLOR_GREEN,string);	}
		case 5:	{ ServerInfo[ReadPMs] = 1; dini_IntSet(file,"ReadPMs",1); format(string,sizeof(string)," Админ %s включил чтение приватов",adminname); MessageToAdmins(COLOR_GREEN,string); }
		case 6:	{ ServerInfo[NoCaps] = 0; dini_IntSet(file,"NoCaps",0); format(string,sizeof(string)," Админ %s включил воможность писать с капс-лок",adminname); SendClientMessageToAll(COLOR_GREEN,string); }
		case 7:	{ ServerInfo[ConnectMessages] = 1; dini_IntSet(file,"ConnectMessages",1); format(string,sizeof(string)," Админ %s включил читать коннект-сообщения",adminname); SendClientMessageToAll(COLOR_GREEN,string); }
		case 8:	{ ServerInfo[AdminCmdMsg] = 1; dini_IntSet(file,"AdminCmdMessages",1); format(string,sizeof(string)," Админ %s включил читать админ-команды",adminname); MessageToAdmins(COLOR_GREEN,string); }
		case 9:	{ ServerInfo[AutoLogin] = 1; dini_IntSet(file,"AutoLogin",1); format(string,sizeof(string)," Админ %s включил авто-логин",adminname); SendClientMessageToAll(COLOR_GREEN,string); }
		case 10: return ChangeMenu(playerid,Current,LMainMenu);
		}
		return TogglePlayerControllable(playerid,true);
	}//------------------------------------------------------------------------
	if(Current == AdminDisable) {
		new adminname[MAX_PLAYER_NAME], file[256]; GetPlayerName(playerid, adminname, sizeof(adminname));
		format(file,sizeof(file),"ladmin/config/Config.ini");
		switch(row){
		case 0: { ServerInfo[AntiSwear] = 0; dini_IntSet(file,"AntiSwear",0); format(string,sizeof(string)," Админ %s выключил анти-мат",adminname); SendClientMessageToAll(COLOR_RED,string);	}
		case 1: { ServerInfo[NameKick] = 0; dini_IntSet(file,"NameKick",0); format(string,sizeof(string)," Админ %s включил кик по нику",adminname); SendClientMessageToAll(COLOR_RED,string);	}
		case 2:	{ ServerInfo[AntiSpam] = 0; dini_IntSet(file,"AntiSpam",0); format(string,sizeof(string)," Админ %s включил анти-спам",adminname); SendClientMessageToAll(COLOR_RED,string);	}
		case 3:	{ ServerInfo[MaxPing] = 0; dini_IntSet(file,"MaxPing",0); format(string,sizeof(string)," Админ %s включил кик по пингу",adminname); SendClientMessageToAll(COLOR_RED,string);	}
		case 4:	{ ServerInfo[ReadCmds] = 0; dini_IntSet(file,"ReadCmds",0); format(string,sizeof(string)," Админ %s включил чтение команд",adminname); MessageToAdmins(COLOR_RED,string);	}
		case 5:	{ ServerInfo[ReadPMs] = 0; dini_IntSet(file,"ReadPMs",0); format(string,sizeof(string)," Админ %s включил чтение приватов",adminname); MessageToAdmins(COLOR_RED,string); }
		case 6:	{ ServerInfo[NoCaps] = 1; dini_IntSet(file,"NoCaps",1); format(string,sizeof(string)," Админ %s включил воможность писать с капс-лок",adminname); SendClientMessageToAll(COLOR_RED,string); }
		case 7:	{ ServerInfo[ConnectMessages] = 0; dini_IntSet(file,"ConnectMessages",0); format(string,sizeof(string)," Админ %s включил читать коннект-сообщения",adminname); SendClientMessageToAll(COLOR_RED,string); }
		case 8:	{ ServerInfo[AdminCmdMsg] = 0; dini_IntSet(file,"AdminCmdMessages",0); format(string,sizeof(string)," Админ %s включил читать админ-команды",adminname); MessageToAdmins(COLOR_RED,string); }
		case 9:	{ ServerInfo[AutoLogin] = 0; dini_IntSet(file,"AutoLogin",0); format(string,sizeof(string)," Админ %s включил авто-логин",adminname); SendClientMessageToAll(COLOR_RED,string); }
		case 10: return ChangeMenu(playerid,Current,LMainMenu);
		}
		return TogglePlayerControllable(playerid,true);
	}//-------------------------------------------------------------------------
	if(Current==LVehicles){
		switch(row){
		case 0: ChangeMenu(playerid,Current,twodoor);
		case 1: ChangeMenu(playerid,Current,fourdoor);
		case 2: ChangeMenu(playerid,Current,fastcar);
		case 3: ChangeMenu(playerid,Current,Othercars);
		case 4: ChangeMenu(playerid,Current,bikes);
		case 5: ChangeMenu(playerid,Current,boats);
		case 6: ChangeMenu(playerid,Current,planes);
		case 7: ChangeMenu(playerid,Current,helicopters);
		case 8: return ChangeMenu(playerid,Current,LMainMenu);
		}
		return 1;
	}
	if(Current==twodoor){
		new vehid;
		switch(row){
		case 0: vehid = 533;
		case 1: vehid = 439;
		case 2: vehid = 555;
		case 3: vehid = 422;
		case 4: vehid = 554;
		case 5: vehid = 575;
		case 6: vehid = 536;
		case 7: vehid = 535;
		case 8: vehid = 576;
		case 9: vehid = 401;
		case 10: vehid = 526;
		case 11: return ChangeMenu(playerid,Current,LVehicles);
		}
		return SelectCar(playerid,vehid,Current);
	}
	if(Current==fourdoor){
		new vehid;
		switch(row){
		case 0: vehid = 404;
		case 1: vehid = 566;
		case 2: vehid = 412;
		case 3: vehid = 445;
		case 4: vehid = 507;
		case 5: vehid = 466;
		case 6: vehid = 546;
		case 7: vehid = 511;
		case 8: vehid = 467;
		case 9: vehid = 426;
		case 10: vehid = 405;
		case 11: return ChangeMenu(playerid,Current,LVehicles);
		}
		return SelectCar(playerid,vehid,Current);
	}
	if(Current==fastcar){
		new vehid;
		switch(row){
		case 0: vehid = 480;
		case 1: vehid = 402;
		case 2: vehid = 415;
		case 3: vehid = 587;
		case 4: vehid = 494;
		case 5: vehid = 411;
		case 6: vehid = 603;
		case 7: vehid = 506;
		case 8: vehid = 451;
		case 9: vehid = 477;
		case 10: vehid = 541;
		case 11: return ChangeMenu(playerid,Current,LVehicles);
		}
		return SelectCar(playerid,vehid,Current);
	}
	if(Current==Othercars){
		new vehid;
		switch(row){
		case 0: vehid = 556;
		case 1: vehid = 408;
		case 2: vehid = 431;
		case 3: vehid = 437;
		case 4: vehid = 427;
		case 5: vehid = 432;
		case 6: vehid = 601;
		case 7: vehid = 524;
		case 8: vehid = 455;
		case 9: vehid = 424;
		case 10: vehid = 573;
		case 11: return ChangeMenu(playerid,Current,LVehicles);
		}
		return SelectCar(playerid,vehid,Current);
	}
	if(Current==bikes){
		new vehid;
		switch(row){
		case 0: vehid = 581;
		case 1: vehid = 481;
		case 2: vehid = 462;
		case 3: vehid = 521;
		case 4: vehid = 463;
		case 5: vehid = 522;
		case 6: vehid = 461;
		case 7: vehid = 448;
		case 8: vehid = 471;
		case 9: vehid = 468;
		case 10: vehid = 586;
		case 11: return ChangeMenu(playerid,Current,LVehicles);
		}
		return SelectCar(playerid,vehid,Current);
	}
	if(Current==boats){
		new vehid;
		switch(row){
		case 0: vehid = 472;
		case 1: vehid = 473;
		case 2: vehid = 493;
		case 3: vehid = 595;
		case 4: vehid = 484;
		case 5: vehid = 430;
		case 6: vehid = 453;
		case 7: vehid = 452;
		case 8: vehid = 446;
		case 9: vehid = 454;
		case 10: return ChangeMenu(playerid,Current,LVehicles);
		}
		return SelectCar(playerid,vehid,Current);
	}
	if(Current==planes){
		new vehid;
		switch(row){
		case 0: vehid = 592;
		case 1: vehid = 577;
		case 2: vehid = 511;
		case 3: vehid = 512;
		case 4: vehid = 593;
		case 5: vehid = 520;
		case 6: vehid = 553;
		case 7: vehid = 476;
		case 8: vehid = 519;
		case 9: vehid = 460;
		case 10: vehid = 513;
		case 11: return ChangeMenu(playerid,Current,LVehicles);
		}
		return SelectCar(playerid,vehid,Current);
	}
	if(Current==helicopters){
		new vehid;
		switch(row){
		case 0: vehid = 548;
		case 1: vehid = 425;
		case 2: vehid = 417;
		case 3: vehid = 487;
		case 4: vehid = 488;
		case 5: vehid = 497;
		case 6: vehid = 563;
		case 7: vehid = 447;
		case 8: vehid = 469;
		case 9: return ChangeMenu(playerid,Current,LVehicles);
		}
		return SelectCar(playerid,vehid,Current);
	}

	if(Current==XWeapons){
		switch(row){
		case 0: { GivePlayerWeapon(playerid,24,500); }
		case 1: { GivePlayerWeapon(playerid,31,500); }
		case 2: { GivePlayerWeapon(playerid,26,500); }
		case 3: { GivePlayerWeapon(playerid,27,500); }
		case 4: { GivePlayerWeapon(playerid,28,500); }
		case 5: { GivePlayerWeapon(playerid,35,500); }
		case 6: { GivePlayerWeapon(playerid,38,1000); }
		case 7: { GivePlayerWeapon(playerid,34,500); }
		case 8: return ChangeMenu(playerid,Current,XWeaponsBig);
		case 9: return ChangeMenu(playerid,Current,XWeaponsSmall);
		case 10: return ChangeMenu(playerid,Current,XWeaponsMore);
		case 11: return ChangeMenu(playerid,Current,LMainMenu);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current==XWeaponsBig){
		switch(row){
		case 0: { GivePlayerWeapon(playerid,25,500);  }
		case 1: { GivePlayerWeapon(playerid,30,500); }
		case 2: { GivePlayerWeapon(playerid,33,500); }
		case 3: { GivePlayerWeapon(playerid,36,500); }
		case 4: { GivePlayerWeapon(playerid,37,500); }
		case 5: { GivePlayerWeapon(playerid,29,500); }
		case 6: { GivePlayerWeapon(playerid,32,1000); }
		case 7: return ChangeMenu(playerid,Current,XWeapons);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current==XWeaponsSmall){
		switch(row){
		case 0: { GivePlayerWeapon(playerid,22,500); }//9mm
		case 1: { GivePlayerWeapon(playerid,23,500); }//s9
		case 2: { GivePlayerWeapon(playerid,18,500); }// MC
		case 3: { GivePlayerWeapon(playerid,42,500); }//FE
		case 4: { GivePlayerWeapon(playerid,41,500); }//spraycan
		case 5: { GivePlayerWeapon(playerid,16,500); }//grenade
		case 6: { GivePlayerWeapon(playerid,8,500); }//Katana
		case 7: { GivePlayerWeapon(playerid,9,1000); }//chainsaw
		case 8: return ChangeMenu(playerid,Current,XWeapons);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current==XWeaponsMore){
		switch(row){
		case 0: SetPlayerSpecialAction(playerid, 2);
		case 1: GivePlayerWeapon(playerid,4,500);
		case 2: GivePlayerWeapon(playerid,14,500);
		case 3: GivePlayerWeapon(playerid,43,500);
		case 4: GivePlayerWeapon(playerid,7,500);
		case 5: GivePlayerWeapon(playerid,5,500);
		case 6: GivePlayerWeapon(playerid,2,1000);
		case 7: MaxAmmo(playerid);
		case 8: return ChangeMenu(playerid,Current,XWeapons);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == LTele)
	{
		switch(row)
		{
		case 0: ChangeMenu(playerid,Current,LasVenturasMenu);
		case 1: ChangeMenu(playerid,Current,LosSantosMenu);
		case 2: ChangeMenu(playerid,Current,SanFierroMenu);
		case 3: ChangeMenu(playerid,Current,DesertMenu);
		case 4: ChangeMenu(playerid,Current,FlintMenu);
		case 5: ChangeMenu(playerid,Current,MountChiliadMenu);
		case 6: ChangeMenu(playerid,Current,InteriorsMenu);
		case 7: return ChangeMenu(playerid,Current,LMainMenu);
		}
		return 1;
	}

	if(Current == LasVenturasMenu)
	{
		switch(row)
		{
		case 0: { SetPlayerPos(playerid,2037.0,1343.0,12.0); SetPlayerInterior(playerid,0); }// strip
		case 1: { SetPlayerPos(playerid,2163.0,1121.0,23); SetPlayerInterior(playerid,0); }// come a lot
		case 2: { SetPlayerPos(playerid,1688.0,1615.0,12.0); SetPlayerInterior(playerid,0); }// lv airport
		case 3: { SetPlayerPos(playerid,2503.0,2764.0,10.0); SetPlayerInterior(playerid,0); }// military fuel
		case 4: { SetPlayerPos(playerid,1418.0,2733.0,10.0); SetPlayerInterior(playerid,0); }// golf lv
		case 5: { SetPlayerPos(playerid,1377.0,2196.0,9.0); SetPlayerInterior(playerid,0); }// pitch match
		case 6: return ChangeMenu(playerid,Current,LTele);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == LosSantosMenu)
	{
		switch(row)
		{
		case 0: { SetPlayerPos(playerid,2495.0,-1688.0,13.0); SetPlayerInterior(playerid,0); }// ganton
		case 1: { SetPlayerPos(playerid,1979.0,-2241.0,13.0); SetPlayerInterior(playerid,0); }// ls airport
		case 2: { SetPlayerPos(playerid,2744.0,-2435.0,15.0); SetPlayerInterior(playerid,0); }// docks
		case 3: { SetPlayerPos(playerid,1481.0,-1656.0,14.0); SetPlayerInterior(playerid,0); }// square
		case 4: { SetPlayerPos(playerid,1150.0,-2037.0,69.0); SetPlayerInterior(playerid,0); }// veradant bluffs
		case 5: { SetPlayerPos(playerid,425.0,-1815.0,6.0); SetPlayerInterior(playerid,0); }// santa beach
		case 6: { SetPlayerPos(playerid,1240.0,-744.0,95.0); SetPlayerInterior(playerid,0); }// mullholland
		case 7: { SetPlayerPos(playerid,679.0,-1070.0,49.0); SetPlayerInterior(playerid,0); }// richman
		case 8: return ChangeMenu(playerid,Current,LTele);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == SanFierroMenu)
	{
		switch(row)
		{
		case 0: { SetPlayerPos(playerid,-1990.0,137.0,27.0); SetPlayerInterior(playerid,0); } // sf station
		case 1: { SetPlayerPos(playerid,-1528.0,-206.0,14.0); SetPlayerInterior(playerid,0); }// sf airport
		case 2: { SetPlayerPos(playerid,-2709.0,198.0,4.0); SetPlayerInterior(playerid,0); }// ocean flats
		case 3: { SetPlayerPos(playerid,-2738.0,-295.0,6.0); SetPlayerInterior(playerid,0); }// avispa country club
		case 4: { SetPlayerPos(playerid,-1457.0,465.0,7.0); SetPlayerInterior(playerid,0); }// easter basic docks
		case 5: { SetPlayerPos(playerid,-1853.0,1404.0,7.0); SetPlayerInterior(playerid,0); }// esplanadae north
		case 6: { SetPlayerPos(playerid,-2620.0,1373.0,7.0); SetPlayerInterior(playerid,0); }// battery point
		case 7: return ChangeMenu(playerid,Current,LTele);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == DesertMenu)
	{
		switch(row)
		{
		case 0: { SetPlayerPos(playerid,416.0,2516.0,16.0); SetPlayerInterior(playerid,0); } // plane graveyard
		case 1: { SetPlayerPos(playerid,81.0,1920.0,17.0); SetPlayerInterior(playerid,0); }// area51
		case 2: { SetPlayerPos(playerid,-324.0,1516.0,75.0); SetPlayerInterior(playerid,0); }// big ear
		case 3: { SetPlayerPos(playerid,-640.0,2051.0,60.0); SetPlayerInterior(playerid,0); }// dam
		case 4: { SetPlayerPos(playerid,-766.0,1545.0,27.0); SetPlayerInterior(playerid,0); }// las barrancas
		case 5: { SetPlayerPos(playerid,-1514.0,2597.0,55.0); SetPlayerInterior(playerid,0); }// el qyebrados
		case 6: { SetPlayerPos(playerid,442.0,1427.0,9.0); SetPlayerInterior(playerid,0); }// actane springs
		case 7: return ChangeMenu(playerid,Current,LTele);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == FlintMenu)
	{
		switch(row)
		{
		case 0: { SetPlayerPos(playerid,-849.0,-1940.0,13.0);  SetPlayerInterior(playerid,0); }// lake
		case 1: { SetPlayerPos(playerid,-1107.0,-1619.0,76.0);  SetPlayerInterior(playerid,0); }// leafy hollow
		case 2: { SetPlayerPos(playerid,-1049.0,-1199.0,128.0);  SetPlayerInterior(playerid,0); }// the farm
		case 3: { SetPlayerPos(playerid,-1655.0,-2219.0,32.0);  SetPlayerInterior(playerid,0); }// shady cabin
		case 4: { SetPlayerPos(playerid,-375.0,-1441.0,25.0); SetPlayerInterior(playerid,0); }// flint range
		case 5: { SetPlayerPos(playerid,-367.0,-1049.0,59.0); SetPlayerInterior(playerid,0); }// beacon hill
		case 6: { SetPlayerPos(playerid,-494.0,-555.0,25.0); SetPlayerInterior(playerid,0); }// fallen tree
		case 7: return ChangeMenu(playerid,Current,LTele);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == MountChiliadMenu)
	{
		switch(row)
		{
		case 0: { SetPlayerPos(playerid,-2308.0,-1657.0,483.0);  SetPlayerInterior(playerid,0); }// chiliad jump
		case 1: { SetPlayerPos(playerid,-2331.0,-2180.0,35.0); SetPlayerInterior(playerid,0); }// bottom chiliad
		case 2: { SetPlayerPos(playerid,-2431.0,-1620.0,526.0);  SetPlayerInterior(playerid,0); }// highest point
		case 3: { SetPlayerPos(playerid,-2136.0,-1775.0,208.0);  SetPlayerInterior(playerid,0); }// chiliad path
		case 4: return ChangeMenu(playerid,Current,LTele);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == InteriorsMenu)
	{
		switch(row)
		{
		case 0: {	SetPlayerPos(playerid,386.5259, 173.6381, 1008.3828);	SetPlayerInterior(playerid,3); }
		case 1: {	SetPlayerPos(playerid,288.4723, 170.0647, 1007.1794);	SetPlayerInterior(playerid,3); }
		case 2: {	SetPlayerPos(playerid,372.5565, -131.3607, 1001.4922);	SetPlayerInterior(playerid,5); }
		case 3: {	SetPlayerPos(playerid,-1129.8909, 1057.5424, 1346.4141);	SetPlayerInterior(playerid,10); }
		case 4: {	SetPlayerPos(playerid,2233.9363, 1711.8038, 1011.6312);	SetPlayerInterior(playerid,1); }
		case 5: {	SetPlayerPos(playerid,2536.5322, -1294.8425, 1044.125);	SetPlayerInterior(playerid,2); }
		case 6: {	SetPlayerPos(playerid,1267.8407, -776.9587, 1091.9063);	SetPlayerInterior(playerid,5); }
		case 7: {	SetPlayerPos(playerid,-1421.5618, -663.8262, 1059.5569);	SetPlayerInterior(playerid,4); }
		case 8: {	SetPlayerPos(playerid,-1401.067, 1265.3706, 1039.8672);	SetPlayerInterior(playerid,16); }
		case 9: {	SetPlayerPos(playerid,285.8361, -39.0166, 1001.5156);	SetPlayerInterior(playerid,1); }
		case 10: {	SetPlayerPos(playerid,1727.2853, -1642.9451, 20.2254);	SetPlayerInterior(playerid,18); }
		case 11: return ChangeMenu(playerid,Current,LTele);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == LWeather)
	{
		new adminname[MAX_PLAYER_NAME]; GetPlayerName(playerid, adminname, sizeof(adminname));
		switch(row)
		{
		case 0:	{	SetWeather(5);	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);	CMDMessageToAdmins(playerid,"SETWEATHER"); format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 1:	{	SetWeather(19); PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"SETWEATHER");	format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 2:	{	SetWeather(8);  PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"SETWEATHER");	format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 3:	{	SetWeather(20);	PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"SETWEATHER");	format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 4:	{	SetWeather(9);  PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"SETWEATHER");	format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 5:	{	SetWeather(16); PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"SETWEATHER");	format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 6:	{	SetWeather(45); PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"SETWEATHER");	format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 7:	{	SetWeather(44); PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"SETWEATHER");	format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 8:	{	SetWeather(22); PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"SETWEATHER");	format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 9:	{	SetWeather(11); PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"SETWEATHER");	format(string,sizeof(string)," Админ %s сменил погоду",adminname); SendClientMessageToAll(blue,string); }
		case 10: return ChangeMenu(playerid,Current,LMainMenu);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == LTuneMenu)
	{
		switch(row)
		{
		case 0:	{	AddVehicleComponent(GetPlayerVehicleID(playerid),1010); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан");	}
		case 1:	{	AddVehicleComponent(GetPlayerVehicleID(playerid),1087); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан"); }
		case 2:	{	AddVehicleComponent(GetPlayerVehicleID(playerid),1081); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан");	}
		case 3: {	AddVehicleComponent(GetPlayerVehicleID(playerid),1078); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан");	}
		case 4:	{	AddVehicleComponent(GetPlayerVehicleID(playerid),1098); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан");	}
		case 5:	{	AddVehicleComponent(GetPlayerVehicleID(playerid),1074); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан");	}
		case 6:	{	AddVehicleComponent(GetPlayerVehicleID(playerid),1082); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан");	}
		case 7:	{	AddVehicleComponent(GetPlayerVehicleID(playerid),1085); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан");	}
		case 8:	{	AddVehicleComponent(GetPlayerVehicleID(playerid),1025); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан");	}
		case 9:	{	AddVehicleComponent(GetPlayerVehicleID(playerid),1077); PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	SendClientMessage(playerid,COLOR_GREEN," Компонент в машине создан");	}
		case 10: return ChangeMenu(playerid,Current,PaintMenu);
		case 11: return ChangeMenu(playerid,Current,LMainMenu);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == PaintMenu)
	{
		switch(row)
		{
		case 0:	{ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),0); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); SendClientMessage(playerid,COLOR_GREEN," Машина покрашена винилами № 1"); }
		case 1:	{ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),1); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); SendClientMessage(playerid,COLOR_GREEN," Машина покрашена винилами № 2"); }
		case 2:	{ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),2); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); SendClientMessage(playerid,COLOR_GREEN," Машина покрашена винилами № 3"); }
		case 3:	{ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),3); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); SendClientMessage(playerid,COLOR_GREEN," Машина покрашена винилами № 4"); }
		case 4:	{ ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),4); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); SendClientMessage(playerid,COLOR_GREEN," Машина покрашена винилами № 5"); }
		case 5:	{ ChangeVehicleColor(GetPlayerVehicleID(playerid),0,0); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); SendClientMessage(playerid,COLOR_GREEN," Машина покрашена в черный цвет"); }
		case 6:	{ ChangeVehicleColor(GetPlayerVehicleID(playerid),1,1); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); SendClientMessage(playerid,COLOR_GREEN," Машина покрашена в белый цвет"); }
		case 7:	{ ChangeVehicleColor(GetPlayerVehicleID(playerid),79,158); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); SendClientMessage(playerid,COLOR_GREEN," Машина покрашена черными винилами"); }
		case 8:	{ ChangeVehicleColor(GetPlayerVehicleID(playerid),146,183); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); SendClientMessage(playerid,COLOR_GREEN," Машина покрашена черными винилами"); }
		case 9: return ChangeMenu(playerid,Current,LTuneMenu);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == LTime)
	{
		new adminname[MAX_PLAYER_NAME]; GetPlayerName(playerid, adminname, sizeof(adminname));
		switch(row)
		{
		case 0:	{ for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) SetPlayerTime(i,7,0);	PlayerPlaySound(playerid,1057,0.0,0.0,0.0);	CMDMessageToAdmins(playerid,"LTIME MENU");	format(string,sizeof(string)," Админ %s сменил время",adminname); SendClientMessageToAll(COLOR_GREEN,string); }
		case 1:	{ for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) SetPlayerTime(i,12,0); PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"LTIME MENU");	format(string,sizeof(string)," Админ %s сменил время",adminname); SendClientMessageToAll(COLOR_GREEN,string); }
		case 2:	{ for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) SetPlayerTime(i,16,0);  PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"LTIME MENU");	format(string,sizeof(string)," Админ %s сменил время",adminname); SendClientMessageToAll(COLOR_GREEN,string); }
		case 3:	{ for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) SetPlayerTime(i,20,0);	PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"LTIME MENU");	format(string,sizeof(string)," Админ %s сменил время",adminname); SendClientMessageToAll(COLOR_GREEN,string); }
		case 4:	{ for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) SetPlayerTime(i,0,0);  PlayerPlaySound(playerid,1057,0.0,0.0,0.0); CMDMessageToAdmins(playerid,"LTIME MENU");	format(string,sizeof(string)," Админ %s сменил время",adminname); SendClientMessageToAll(COLOR_GREEN,string); }
		case 5: return ChangeMenu(playerid,Current,LMainMenu);
		}
		return TogglePlayerControllable(playerid,true);
	}

	if(Current == LCars)
	{
		new vehid;
		switch(row) {
		case 0: vehid = 451;//Turismo
		case 1: vehid = 568;//Bandito
		case 2: vehid = 539;//Vortex
		case 3: vehid = 522;//nrg
		case 4: vehid = 601;//s.w.a.t
		case 5: vehid = 425; //hunter
		case 6: vehid = 493;//jetmax
		case 7: vehid = 432;//rhino
		case 8: vehid = 444; //mt
		case 9: vehid = 447; //sea sparrow
		case 10: return ChangeMenu(playerid,Current,LCars2);
		case 11: return ChangeMenu(playerid,Current,LMainMenu);
		}
		return SelectCar(playerid,vehid,Current);
	}

	if(Current == LCars2)
	{
		new vehid;
		switch(row) {
		case 0: vehid = 406;// dumper
		case 1: vehid = 564; //rc tank
		case 2: vehid = 441;//RC Bandit
		case 3: vehid = 464;// rc baron
		case 4: vehid = 501; //rc goblin
		case 5: vehid = 465; //rc raider
		case 6: vehid = 594; // rc cam
		case 7: vehid = 449; //tram
		case 8: return ChangeMenu(playerid,Current,LCars);
		}
		return SelectCar(playerid,vehid,Current);
	}

	return 1;
}

//==============================================================================

public OnPlayerExitedMenu(playerid) {
	new Menu:Current = GetPlayerMenu(playerid);
	HideMenuForPlayer(Current,playerid);
	return TogglePlayerControllable(playerid,true);
}

//==============================================================================

ChangeMenu(playerid,Menu:oldmenu,Menu:newmenu) {
	if(IsValidMenu(oldmenu)) {
		HideMenuForPlayer(oldmenu,playerid);
		ShowMenuForPlayer(newmenu,playerid);
	}
	return 1;
}
CloseMenu(playerid,Menu:oldmenu) {
	HideMenuForPlayer(oldmenu,playerid);
	TogglePlayerControllable(playerid,1);
	return 1;
}
SelectCar(playerid,vehid,Menu:menu) {
	CloseMenu(playerid,menu);
	SetCameraBehindPlayer(playerid);
	CarSpawner(playerid,vehid);
	return 1;
}
#endif

//==================== [ Jail & Freeze ]========================================

forward Jail1(player1);
public Jail1(player1)
{
	TogglePlayerControllable(player1,false);
	new Float:x, Float:y, Float:z;	GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+10,y,z+10);SetPlayerCameraLookAt(player1,x,y,z);
	SetTimerEx("Jail2",1000,0,"d",player1);
}

forward Jail2(player1);
public Jail2(player1)
{
	new Float:x, Float:y, Float:z; GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+7,y,z+5); SetPlayerCameraLookAt(player1,x,y,z);
	if(GetPlayerState(player1) == PLAYER_STATE_ONFOOT) SetPlayerSpecialAction(player1,SPECIAL_ACTION_HANDSUP);
	//GameTextForPlayer(player1,"~r~ZOCAGEH ADMNHOM",3000,3);
	SendClientMessage(player1,-1,"{FFFFFF}Вы посажены в тюрьму администратором");
	SetTimerEx("Jail3",1000,0,"d",player1);
}

forward Jail3(player1);
public Jail3(player1)
{
	new Float:x, Float:y, Float:z; GetPlayerPos(player1,x,y,z);
	SetPlayerCameraPos(player1,x+3,y,z); SetPlayerCameraLookAt(player1,x,y,z);
}

forward JailPlayer(player1);
public JailPlayer(player1)
{
	TogglePlayerControllable(player1,true);
	SetPlayerPos(player1,-348.5646,4069.9910,31.2435);
	SetPlayerFacingAngle(player1,122.7692);
	SetPlayerInterior(player1,980);
	SetCameraBehindPlayer(player1);
	JailTimer[player1] = SetTimerEx("JailRelease",PlayerInfo[player1][JailTime],0,"d",player1);
	PlayerInfo[player1][Jailed] = 1;
}

forward JailRelease(player1);
public JailRelease(player1)
{
	KillTimer( JailTimer[player1] );
	PlayerInfo[player1][JailTime] = 0;  PlayerInfo[player1][Jailed] = 0;
	SetPlayerInterior(player1,0); SetPlayerPos(player1, 0.0, 0.0, 0.0); SpawnPlayer(player1);
	PlayerPlaySound(player1,1057,0.0,0.0,0.0);
	SendClientMessage(player1,-1,"{FFFFFF}Вы выпущены из тюрьмы");
	SetPVarInt(player1,"inJail",0);
	//GameTextForPlayer(player1,"~g~BSZYWEH ~n~N3 TUPJMS",3000,3);
}

//------------------------------------------------------------------------------
forward UnFreezeMe(player1);
public UnFreezeMe(player1)
{
	KillTimer( FreezeTimer[player1] );
	TogglePlayerControllable(player1,true);   PlayerInfo[player1][Frozen] = 0;
	PlayerPlaySound(player1,1057,0.0,0.0,0.0);	GameTextForPlayer(player1,"~g~PA3MOPOGEH",3000,3);
}

//==============================================================================
forward RepairCar(playerid);
public RepairCar(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) SetVehiclePos(GetPlayerVehicleID(playerid),Pos[playerid][0],Pos[playerid][1],Pos[playerid][2]+0.5);
	SetVehicleZAngle(GetPlayerVehicleID(playerid), Pos[playerid][3]);
	SetCameraBehindPlayer(playerid);
}

//============================ [ Timers ]=======================================

forward GodUpdate();
public GodUpdate()
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i) && PlayerInfo[i][God] == 1)
		{
			SetPlayerHealth(i,100000);
		}
		if(IsPlayerConnected(i) && PlayerInfo[i][GodCar] == 1 && IsPlayerInAnyVehicle(i))
		{
			SetVehicleHealth(GetPlayerVehicleID(i),10000);
		}
	}
}

//==============================================================================
forward HideNameTag();
public HideNameTag()
{
	for (new i = 0; i < GetMaxPlayers(); i++)
	{
		for (new x = 0; x < GetMaxPlayers(); x++)
		{
			if(PlayerInfo[i][Level] < 1 && PlayerInfo[x][Invis] == 1)
			{
				ShowPlayerNameTagForPlayer(i,x,0);
				SetPlayerMarkerForPlayer(i,x, ( GetPlayerColor(x) & 0xFFFFFF00) );
			}
			else
			{
				ShowPlayerNameTagForPlayer(i,x,1);
				SetPlayerMarkerForPlayer(i,x,GetPlayerColor(x));
			}
		}
	}
	return 1;
}

//==========================[ Server Info  ]====================================

forward ConnectedPlayers();
public ConnectedPlayers()
{
	new Connected;
	for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i)) Connected++;
	return Connected;
}

forward JailedPlayers();
public JailedPlayers()
{
	new JailedCount;
	for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Jailed] == 1) JailedCount++;
	return JailedCount;
}

forward FrozenPlayers();
public FrozenPlayers()
{
	new FrozenCount; for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Frozen] == 1) FrozenCount++;
	return FrozenCount;
}

forward MutedPlayers();
public MutedPlayers()
{
	new Count; for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Muted] == 1) Count++;
	return Count;
}

forward InVehCount();
public InVehCount()
{
	new InVeh; for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) InVeh++;
	return InVeh;
}

forward OnBikeCount();
public OnBikeCount()
{
	new BikeCount;
	for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) {
		new LModel = GetVehicleModel(GetPlayerVehicleID(i));
		switch(LModel)
		{
		case 448,461,462,463,468,471,509,510,521,522,523,581,586:  BikeCount++;
		}
	}
	return BikeCount;
}

forward InCarCount();
public InCarCount()
{
	new PInCarCount;
	for(new i = 0; i < GetMaxPlayers(); i++) {
		if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) {
			new LModel = GetVehicleModel(GetPlayerVehicleID(i));
			switch(LModel)
			{
			case 448,461,462,463,468,471,509,510,521,522,523,581,586: {}
			default: PInCarCount++;
			}
		}
	}
	return PInCarCount;
}

forward AdminCount();
public AdminCount()
{
	new LAdminCount;
	for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && PlayerInfo[i][Level] >= 1)	LAdminCount++;
	return LAdminCount;
}

forward RconAdminCount();
public RconAdminCount()
{
	new rAdminCount;
	for(new i = 0; i < GetMaxPlayers(); i++) if(IsPlayerConnected(i) && IsPlayerAdmin(i)) rAdminCount++;
	return rAdminCount;
}

//==========================[ Remote Console ]==================================

forward RestartGM();
public RestartGM()
{
	SendRconCommand("gmx");
}

forward UnloadFS();
public UnloadFS()
{
	SendRconCommand("unloadfs ladmin4");
}

forward PrintWarning(const string[]);
public PrintWarning(const string[])
{
	new str[128];
	print("\n\n>		WARNING:\n");
	format(str, sizeof(str), " The  %s  folder is missing from scriptfiles", string);
	print(str);
	print("\n Please Create This Folder And Reload the Filterscript\n\n");
}

//============================[ Bot Check ]=====================================
forward BotCheck(playerid);
public BotCheck(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(GetPlayerPing(playerid) < 1)
		{
			new string[128], ip[20];  GetPlayerIp(playerid,ip,sizeof(ip));
			format(string,sizeof(string)," БОТ: %s id:%d ip: %s пинг: %d",PlayerName2(playerid),playerid,ip,GetPlayerPing(playerid));
			SaveToFile("BotKickLog",string);
			SaveToFile("KickLog",string);
			printf("[ADMIN] Possible bot has been detected (Kicked %s ID:%d)", PlayerName2(playerid), playerid);
			Kick(playerid);
		}
	}
}

//==============================================================================
forward PutAtPos(playerid);
public PutAtPos(playerid)
{
	if (dUserINT(PlayerName2(playerid)).("x")!=0) {
		SetPlayerPos(playerid, float(dUserINT(PlayerName2(playerid)).("x")), float(dUserINT(PlayerName2(playerid)).("y")), float(dUserINT(PlayerName2(playerid)).("z")) );
		SetPlayerInterior(playerid,	(dUserINT(PlayerName2(playerid)).("interior"))	);
	}
}

forward PutAtDisconectPos(playerid);
public PutAtDisconectPos(playerid)
{
	if (dUserINT(PlayerName2(playerid)).("x1")!=0) {
		SetPlayerPos(playerid, float(dUserINT(PlayerName2(playerid)).("x1")), float(dUserINT(PlayerName2(playerid)).("y1")), float(dUserINT(PlayerName2(playerid)).("z1")) );
		SetPlayerInterior(playerid,	(dUserINT(PlayerName2(playerid)).("interior1"))	);
	}
}

//==============================================================================
MaxAmmo(playerid)
{
	new slot, weap, ammo;
	for (slot = 0; slot < 14; slot++)
	{
		GetPlayerWeaponData(playerid, slot, weap, ammo);
		if(IsValidWeapon(weap))
		{
			GivePlayerWeapon(playerid, weap, 99999);
		}
	}
	return 1;
}

stock PlayerName2(playerid) {
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock pName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock TimeStamp()
{
	new time = GetTickCount() / 1000;
	return time;
}

stock PlayerSoundForAll(SoundID)
{
	for(new i = 0; i < GetMaxPlayers(); i++) PlayerPlaySound(i, SoundID, 0.0, 0.0, 0.0);
}

stock IsValidWeapon(weaponid)
{
	if (weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47) return 1;
	return 0;
}

stock IsValidSkin(SkinID)
{
	if((SkinID == 0)||(SkinID == 7)||(SkinID >= 9 && SkinID <= 41)||(SkinID >= 43 && SkinID <= 64)||(SkinID >= 66 && SkinID <= 73)||(SkinID >= 75 && SkinID <= 85)||(SkinID >= 87 && SkinID <= 118)||(SkinID >= 120 && SkinID <= 148)||(SkinID >= 150 && SkinID <= 207)||(SkinID >= 209 && SkinID <= 264)||(SkinID >= 274 && SkinID <= 288)||(SkinID >= 290 && SkinID <= 299)) return true;
	else return false;
}

stock IsNumeric(string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

GetVehicleModelIDFromName(vname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleNames[i], vname, true) != -1 )
		return i + 400;
	}
	return -1;
}

stock GetWeaponIDFromName(WeaponName[])
{
	if(strfind("molotov",WeaponName,true)!=-1) return 18;
	for(new i = 0; i <= 46; i++)
	{
		switch(i)
		{
		case 0,19,20,21,44,45: continue;
		default:
			{
				new name[32]; GetWeaponName(i,name,32);
				if(strfind(name,WeaponName,true) != -1) return i;
			}
		}
	}
	return -1;
}

stock DisableWord(const badword[], text[])
{
	for(new i=0; i<256; i++)
	{
		if (strfind(text[i], badword, true) == 0)
		{
			for(new a=0; a<256; a++)
			{
				if (a >= i && a < i+strlen(badword)) text[a]='*';
			}
		}
	}
}

argpos(const string[], idx = 0, sep = ' ')// (by yom)
{
	for(new i = idx, j = strlen(string); i < j; i++)
	if (string[i] == sep && string[i+1] != sep)
	return i+1;

	return -1;
}

//==============================================================================
forward MessageToAdmins(color,const string[]);
public MessageToAdmins(color,const string[])
{
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i) == 1) if (PlayerInfo[i][Level] >= 1) SendClientMessage(i, color, string);
	}
	return 1;
}

stock CMDMessageToAdmins(playerid,command[])
{
	if(ServerInfo[AdminCmdMsg] == 0) return 1;
	new string[128]; GetPlayerName(playerid,string,sizeof(string));
	format(string,sizeof(string)," [АДМИН] %s ИСПОЛЬЗОВАЛ КОМАНДУ %s",string,command);
	return MessageToAdmins(blue,string);
}

//==============================================================================
SavePlayer(playerid)
{
	dUserSetINT(PlayerName2(playerid)).("money",GetPlayerMoney(playerid));
	dUserSetINT(PlayerName2(playerid)).("kills",PlayerInfo[playerid][Kills]);
	dUserSetINT(PlayerName2(playerid)).("deaths",PlayerInfo[playerid][Deaths]);
	dUserSetINT(PlayerName2(playerid)).("Muted",PlayerInfo[playerid][Muted]);

	new Float:x,Float:y,Float:z, interior;
	GetPlayerPos(playerid,x,y,z);	interior = GetPlayerInterior(playerid);
	dUserSetINT(PlayerName2(playerid)).("x1",floatround(x));
	dUserSetINT(PlayerName2(playerid)).("y1",floatround(y));
	dUserSetINT(PlayerName2(playerid)).("z1",floatround(z));
	dUserSetINT(PlayerName2(playerid)).("interior1",interior);

	new weap1, ammo1, weap2, ammo2, weap3, ammo3, weap4, ammo4, weap5, ammo5, weap6, ammo6;
	GetPlayerWeaponData(playerid,2,weap1,ammo1);// hand gun
	GetPlayerWeaponData(playerid,3,weap2,ammo2);//shotgun
	GetPlayerWeaponData(playerid,4,weap3,ammo3);// SMG
	GetPlayerWeaponData(playerid,5,weap4,ammo4);// AK47 / M4
	GetPlayerWeaponData(playerid,6,weap5,ammo5);// rifle
	GetPlayerWeaponData(playerid,7,weap6,ammo6);// rocket launcher
	dUserSetINT(PlayerName2(playerid)).("weap1",weap1); dUserSetINT(PlayerName2(playerid)).("weap1ammo",ammo1);
	dUserSetINT(PlayerName2(playerid)).("weap2",weap2);	dUserSetINT(PlayerName2(playerid)).("weap2ammo",ammo2);
	dUserSetINT(PlayerName2(playerid)).("weap3",weap3);	dUserSetINT(PlayerName2(playerid)).("weap3ammo",ammo3);
	dUserSetINT(PlayerName2(playerid)).("weap4",weap4); dUserSetINT(PlayerName2(playerid)).("weap4ammo",ammo4);
	dUserSetINT(PlayerName2(playerid)).("weap5",weap5);	dUserSetINT(PlayerName2(playerid)).("weap5ammo",ammo5);
	dUserSetINT(PlayerName2(playerid)).("weap6",weap6); dUserSetINT(PlayerName2(playerid)).("weap6ammo",ammo6);

	new year,month,day;
	getdate(year, month, day);
	new strdate[20];
	format(strdate, sizeof(strdate), "%d.%d.%d",day,month,year);
	new file[256];
	format(file,sizeof(file),"/ladmin/users/%s.sav",udb_encode(PlayerName2(playerid)) );

	new Float:vbw[2]; GetPlayerHealth(playerid,vbw[0]); GetPlayerArmour(playerid,vbw[1]);
	dUserSetINT(PlayerName2(playerid)).("health",floatround(vbw[0]));
	dUserSetINT(PlayerName2(playerid)).("armour",floatround(vbw[1]));
	dini_Set(file,"LastOn",strdate);
	dUserSetINT(PlayerName2(playerid)).("loggedin",0);
	dUserSetINT(PlayerName2(playerid)).("TimesOnServer",(dUserINT(PlayerName2(playerid)).("TimesOnServer"))+1);
}

//==============================================================================
#if defined USE_MENUS
DestroyAllMenus()
{
	DestroyMenu(LVehicles); DestroyMenu(twodoor); DestroyMenu(fourdoor); DestroyMenu(fastcar); DestroyMenu(Othercars);
	DestroyMenu(bikes); DestroyMenu(boats); DestroyMenu(planes); DestroyMenu(helicopters ); DestroyMenu(LTime);
	DestroyMenu(XWeapons); DestroyMenu(XWeaponsBig); DestroyMenu(XWeaponsSmall); DestroyMenu(XWeaponsMore);
	DestroyMenu(LWeather); DestroyMenu(LTuneMenu); DestroyMenu(PaintMenu); DestroyMenu(LCars); DestroyMenu(LCars2);
	DestroyMenu(LTele); DestroyMenu(LasVenturasMenu); DestroyMenu(LosSantosMenu); DestroyMenu(SanFierroMenu);
	DestroyMenu(LMainMenu); DestroyMenu(DesertMenu); DestroyMenu(FlintMenu); DestroyMenu(MountChiliadMenu); DestroyMenu(InteriorsMenu);
	DestroyMenu(AdminEnable); DestroyMenu(AdminDisable);
}
#endif

//==============================================================================
#if defined DISPLAY_CONFIG
stock ConfigInConsole()
{
	print(" ________ Configuration ___________\n");
	print(" __________ Chat & Messages ______");
	if(ServerInfo[AntiSwear] == 0) print("  Anti Swear:              Disabled "); else print("  Anti Swear:             Enabled ");
	if(ServerInfo[AntiSpam] == 0)  print("  Anti Spam:               Disabled "); else print("  Anti Spam:              Enabled ");
	if(ServerInfo[ReadCmds] == 0)  print("  Read Cmds:               Disabled "); else print("  Read Cmds:              Enabled ");
	if(ServerInfo[ReadPMs] == 0)   print("  Read PMs:                Disabled "); else print("  Read PMs:               Enabled ");
	if(ServerInfo[ConnectMessages] == 0) print("  Connect Messages:        Disabled "); else print("  Connect Messages:       Enabled ");
	if(ServerInfo[AdminCmdMsg] == 0) print("  Admin Cmd Messages:     Disabled ");  else print("  Admin Cmd Messages:     Enabled ");
	if(ServerInfo[ReadPMs] == 0)   print("  Anti capital letters:    Disabled \n"); else print("  Anti capital letters:   Enabled \n");
	print(" __________ Skins ________________");
	if(ServerInfo[AdminOnlySkins] == 0) print("  AdminOnlySkins:         Disabled "); else print("  AdminOnlySkins:         Enabled ");
	printf("  Admin Skin 1 is:         %d", ServerInfo[AdminSkin] );
	printf("  Admin Skin 2 is:         %d\n", ServerInfo[AdminSkin2] );
	print(" ________ Server Protection ______");
	if(ServerInfo[AntiBot] == 0) print("  Anti Bot:                Disabled "); else print("  Anti Bot:                Enabled ");
	if(ServerInfo[NameKick] == 0) print("  Bad Name Kick:           Disabled\n"); else print("  Bad Name Kick:           Enabled\n");
	print(" __________ Ping Control _________");
	if(ServerInfo[MaxPing] == 0) print("  Ping Control:            Disabled"); else print("  Ping Control:            Enabled");
	printf("  Max Ping:                %d\n", ServerInfo[MaxPing] );
	print(" __________ Players ______________");
	if(ServerInfo[GiveWeap] == 0) print("  Save/Give Weaps:         Disabled"); else print("  Save/Give Weaps:         Enabled");
	if(ServerInfo[GiveMoney] == 0) print("  Save/Give Money:         Disabled\n"); else print("  Save/Give Money:         Enabled\n");
	print(" __________ Other ________________");
	printf("  Max Admin Level:         %d", ServerInfo[MaxAdminLevel] );
	if(ServerInfo[Locked] == 0) print("  Server Locked:           No"); else print("  Server Locked:           Yes");
	if(ServerInfo[AutoLogin] == 0) print("  Auto Login:             Disabled\n"); else print("  Auto Login:              Enabled\n");
}
#endif

//=====================[ Configuration ] =======================================
stock UpdateConfig()
{
	new file[256], File:file2, string[100]; format(file,sizeof(file),"ladmin/config/Config.ini");
	ForbiddenWordCount = 0;
	BadNameCount = 0;
	BadPartNameCount = 0;

	if(!dini_Exists("ladmin/config/aka.txt")) dini_Create("ladmin/config/aka.txt");

	if(!dini_Exists(file))
	{
		dini_Create(file);
		print("\n >Configuration File Successfully Created");
	}

	if(!dini_Isset(file,"MaxPing")) dini_IntSet(file,"MaxPing",1200);
	if(!dini_Isset(file,"ReadPms")) dini_IntSet(file,"ReadPMs",1);
	if(!dini_Isset(file,"ReadCmds")) dini_IntSet(file,"ReadCmds",1);
	if(!dini_Isset(file,"MaxAdminLevel")) dini_IntSet(file,"MaxAdminLevel",5);
	if(!dini_Isset(file,"AdminOnlySkins")) dini_IntSet(file,"AdminOnlySkins",0);
	if(!dini_Isset(file,"AdminSkin")) dini_IntSet(file,"AdminSkin",217);
	if(!dini_Isset(file,"AdminSkin2")) dini_IntSet(file,"AdminSkin2",214);
	if(!dini_Isset(file,"AntiBot")) dini_IntSet(file,"AntiBot",1);
	if(!dini_Isset(file,"AntiSpam")) dini_IntSet(file,"AntiSpam",1);
	if(!dini_Isset(file,"AntiSwear")) dini_IntSet(file,"AntiSwear",1);
	if(!dini_Isset(file,"NameKick")) dini_IntSet(file,"NameKick",1);
	if(!dini_Isset(file,"PartNameKick")) dini_IntSet(file,"PartNameKick",1);
	if(!dini_Isset(file,"NoCaps")) dini_IntSet(file,"NoCaps",0);
	if(!dini_Isset(file,"Locked")) dini_IntSet(file,"Locked",0);
	if(!dini_Isset(file,"SaveWeap")) dini_IntSet(file,"SaveWeap",1);
	if(!dini_Isset(file,"SaveMoney")) dini_IntSet(file,"SaveMoney",1);
	if(!dini_Isset(file,"ConnectMessages")) dini_IntSet(file,"ConnectMessages",1);
	if(!dini_Isset(file,"AdminCmdMessages")) dini_IntSet(file,"AdminCmdMessages",1);
	if(!dini_Isset(file,"AutoLogin")) dini_IntSet(file,"AutoLogin",1);
	if(!dini_Isset(file,"MaxMuteWarnings")) dini_IntSet(file,"MaxMuteWarnings",4);
	if(!dini_Isset(file,"MustLogin")) dini_IntSet(file,"MustLogin",0);

	if(dini_Exists(file))
	{
		ServerInfo[MaxPing] = dini_Int(file,"MaxPing");
		ServerInfo[ReadPMs] = dini_Int(file,"ReadPMs");
		ServerInfo[ReadCmds] = dini_Int(file,"ReadCmds");
		ServerInfo[MaxAdminLevel] = dini_Int(file,"MaxAdminLevel");
		ServerInfo[AdminOnlySkins] = dini_Int(file,"AdminOnlySkins");
		ServerInfo[AdminSkin] = dini_Int(file,"AdminSkin");
		ServerInfo[AdminSkin2] = dini_Int(file,"AdminSkin2");
		ServerInfo[AntiBot] = dini_Int(file,"AntiBot");
		ServerInfo[AntiSpam] = dini_Int(file,"AntiSpam");
		ServerInfo[AntiSwear] = dini_Int(file,"AntiSwear");
		ServerInfo[NameKick] = dini_Int(file,"NameKick");
		ServerInfo[PartNameKick] = dini_Int(file,"PartNameKick");
		ServerInfo[NoCaps] = dini_Int(file,"NoCaps");
		ServerInfo[Locked] = dini_Int(file,"Locked");
		ServerInfo[GiveWeap] = dini_Int(file,"SaveWeap");
		ServerInfo[GiveMoney] = dini_Int(file,"SaveMoney");
		ServerInfo[ConnectMessages] = dini_Int(file,"ConnectMessages");
		ServerInfo[AdminCmdMsg] = dini_Int(file,"AdminCmdMessages");
		ServerInfo[AutoLogin] = dini_Int(file,"AutoLogin");
		ServerInfo[MaxMuteWarnings] = dini_Int(file,"MaxMuteWarnings");
		ServerInfo[MustLogin] = dini_Int(file,"MustLogin");
		print("\n -Configuration Settings Loaded");
	}

	//forbidden names
	if((file2 = fopen("ladmin/config/ForbiddenNames.cfg",io_read)))
	{
		while(fread(file2,string))
		{
			for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
			BadNames[BadNameCount] = string;
			BadNameCount++;
		}
		fclose(file2);	printf(" -%d Forbidden Names Loaded", BadNameCount);
	}

	//forbidden part of names
	if((file2 = fopen("ladmin/config/ForbiddenPartNames.cfg",io_read)))
	{
		while(fread(file2,string))
		{
			for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
			BadPartNames[BadPartNameCount] = string;
			BadPartNameCount++;
		}
		fclose(file2);	printf(" -%d Forbidden Tags Loaded", BadPartNameCount);
	}

	//forbidden words
	if((file2 = fopen("ladmin/config/ForbiddenWords.cfg",io_read)))
	{
		while(fread(file2,string))
		{
			for(new i = 0, j = strlen(string); i < j; i++) if(string[i] == '\n' || string[i] == '\r') string[i] = '\0';
			ForbiddenWords[ForbiddenWordCount] = string;
			ForbiddenWordCount++;
		}
		fclose(file2);	printf(" -%d Forbidden Words Loaded", ForbiddenWordCount);
	}
}
//=====================[ SAVING DATA ] =========================================

forward SaveToFile(filename[],text[]);
public SaveToFile(filename[],text[])
{
	#if defined SAVE_LOGS
	new File:LAdminfile, filepath[256], string[256], year,month,day, hour,minute,second;
	getdate(year,month,day); gettime(hour,minute,second);

	format(filepath,sizeof(filepath),"ladmin/logs/%s.txt",filename);
	LAdminfile = fopen(filepath,io_append);
	format(string,sizeof(string),"[%d.%d.%d %d:%d:%d] %s\r\n",day,month,year,hour,minute,second,text);
	fwrite(LAdminfile,string);
	fclose(LAdminfile);
	#endif

	return 1;
}

//============================[ EOF ]===========================================

forward OnPlayerPrivmsg(playerid, recieverid, text[]);

//===========================[ Other ]==========================================

stock FakeLoginCmd(playerid, inputtext[])
{
	new tmp[512];
	format(tmp,sizeof(tmp),"/login %s",inputtext);
	OnPlayerCommandText(playerid,tmp);
	return 1;
}

stock FakeRegisterCmd(playerid, inputtext[])
{
	new tmp[512];
	format(tmp,sizeof(tmp),"/register %s",inputtext);
	OnPlayerCommandText(playerid,tmp);
	return 1;
}
