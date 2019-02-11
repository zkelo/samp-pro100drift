#include <a_samp>
#include <streamer>
#include <sscanf2>
#include <a_players>
#include <mxINI>
#include <a_deamx>

#undef MAX_PLAYERS
const MAX_PLAYERS=100; // Максимальное количество игроков сервера (изменить на своё)

#define COLOR_GOLD 0xFFD700AA
#define COLOR_GREEN2 0x7FFF00AA
#define COLOR_SEA 0x00808000
#define COLOR_DM 0x00A3F0AA
#define Cvet_1 0x00ff00FF
#define Cvet_2 0xbfff00FF
#define Cvet_3 0x66ff00FF
#define Cvet_4 0x30d5c8FF
#define Cvet_5 0xadff2fFF
#define Cvet_6 0x013220FF
#define Cvet_7 0x5da130FF
#define Cvet_8 0xff0000FF
#define Cvet_9 0xff2400FF
#define Cvet_10 0xffa500FF
#define Cvet_11 0x964b00FF
#define Cvet_12 0xc41e3aFF
#define Cvet_13 0xbb4488FF
#define Cvet_14 0xff9900FF
#define Cvet_15 0xdc143cFF
#define COLOR_BLUR 0x2ECCFAFF
#define COLOR_BLUE 0x33AAFFFF
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_GREEN 0x00FF00AA
#define COLOR_RED 0xFF0000AA
#define COLOR_WHITE 0xFF33FFAA
#define COLOR_YELLOW 0xFFFF00AA
#define MAX_HOUSES 1000
#define COLOR_ORANGE 0xFF9900AA
#define ADMINFS_MESSAGE_COLOR 0xFF444499
#define PM_INCOMING_COLOR     0xFFFF22AA
#define PM_OUTGOING_COLOR     0xFFCC2299
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#pragma tabsize 0

//--------------------------------------------- Переменные для таймеров -------------------------------|
new UPDTimer[MAX_PLAYERS], OtherTimerVar[MAX_PLAYERS], CheckTimer[MAX_PLAYERS], CountownTimer[MAX_PLAYERS], AutoRepairTimer[MAX_PLAYERS], AdvTimer[MAX_PLAYERS];
//-----------------------------------------------------------------------------------------------------|

new Text:HelpDraw;
new ta4ka[MAX_PLAYERS];
new ta4katest[MAX_PLAYERS];
new neon[MAX_PLAYERS][2];
new countdown[MAX_PLAYERS];
new h[MAX_PLAYERS],m[MAX_PLAYERS];
new Float:RandomSpawn[][4] = {
    {2540.6499,-1460.9518,24.0276},
    {2180.6038,-2272.9414,13.4850},
    {1775.5583,-1909.0343,13.3861},
	{-1945.7518,487.0891,31.9688},
	{-1921.0516,716.1599,46.5625}
};
new Text:mod;
new Text:vk;
new clist[17][] = {
/*0*/            {"Выключить цвет\n"},
/*1*/            {"Зеленый\n"},
/*2*/            {"Светло-Зеленый\n"},
/*3*/            {"Ярко-Зеленый\n"},
/*4*/            {"Бирюзовый\n"},
/*5*/            {"Желто-Зеленый\n"},
/*6*/            {"Темно-Зеленый\n"},
/*7*/            {"Серо-Зеленый\n"},
/*8*/            {"Красный\n"},
/*9*/            {"Ярко-красный\n"},
/*10*/            {"Оранженвый\n"},
/*11*/            {"Коричневый\n"},
/*12*/            {"Тёмно-красный\n"},
/*13*/            {"Серо-красный\n"},
/*14*/            {"Жёлто-оранжевый\n"},
/*15*/            {"Малиновый\n"},
/*34*/            {""}
};
new Colorf[MAX_PLAYERS];
new flasher[MAX_PLAYERS][2];
//Переменные для телепортов по пикапу в квартиры админов
new teleport;
new teleport2;
new teleport3;
new teleport4;
new teleport5;
new teleport6;
new teleport7;
new teleport8;
new teleport9;
new teleport10;
//------------------------------------------------------

new oplayers, Precord, Drecord, Mrecord, Yrecord, THrecord, TMrecord;


new CrashCars1[] = {//двуместный транспорт
401,402,403,407,408,410,411,412,413,414,415,416,417,419,422,423,424,427,428,429,433,434,
436,440,443,444,447,451,455,456,457,459,461,462,463,468,469,471,474,475,477,478,480,482,
483,489,491,494,495,496,498,499,500,502,503,504,505,506,508,511,514,515,517,518,521,522,
523,524,525,526,527528,533,534,535,537,538,541,542,543,544,545 ,548,549,552,554,556,557,
558,559,562,563,565,573,574,575,576,578,581,582, 586,587,588,589,599,600,601,602,603,605,609
};
new CrashCars2[] = {//одноместный транспорт
406,425,430,432,441,446,448,452,453,454,460,464,465,472,473,476,481,
484,485,486,493,501,509,510,512,513,519,520,530,531,532,539,553,564,
568,571,572,577,583,592,593,594,595
};
//Ворота баз
new gates;
new gates2;
////
//Форварды
forward OtherTimer();
forward Countdown();
forward Check();
forward AutoRepair();
forward AutoFlip();
forward Reklama();
forward Reklama1();
forward lsnewsClose();//
forward LoadRecord();
forward SaveRecord();
forward OnPlayerRegister(playerid, password[]); //паблик отвечающий за регистрацию
forward OnPlayerLogin(playerid,password[]); //паблик отвечающий за логин
forward SaveAccounts(); //сток отвечающий за сохранение аккаунта
forward Record(playerid);
forward ConnectedPlayers();
forward OnPlayerUPD(playerid);
static
	armedbody_pTick[MAX_PLAYERS];

main()
{
	print("\n----------------------------------");
	print("Drift loading 100%\n\n.");
	print("----------------------------------\n");
}

public AutoRepair()
{
	for(new playerid=0; playerid<MAX_PLAYERS; playerid++)
	{
	    if (IsPlayerInAnyVehicle(playerid))
	    {
			new Float:CarHP;
			GetVehicleHealth(GetPlayerVehicleID(playerid), CarHP);
            if (CarHP < 999)
            {
				RepairVehicle(GetPlayerVehicleID(playerid));
			}
		}
	}
	return 1;
}

public OtherTimer()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
    new Colors[] = { 0x00ff0099, 0x5E5A80FF, 0x157DECFF , 0x9E7BFFFF , 0x659EC7FF , 0xF778A1FF , 0x43C6DBFF , 0xC9BE62FF , 0xFBB117FF, 0xC11B17FF, 0xFBBBB9FF };
      TextDrawHideForPlayer(i,HelpDraw);
      TextDrawColor(HelpDraw,Colors[random(sizeof(Colors))]);
      TextDrawShowForPlayer(i,HelpDraw);
      SetTimer("TextdrawColorChange", 100, 0);
        }
    }
    
public OnGameModeInit()
{

    DisableInteriorEnterExits();
    HelpDraw = TextDrawCreate(499.000000,4.000000,"   DRIFT WORLD ");
    TextDrawAlignment(HelpDraw,0);
    TextDrawBackgroundColor(HelpDraw,0x00000066);
    TextDrawFont(HelpDraw,3);
    TextDrawLetterSize(HelpDraw,0.299999,1.300000);
    TextDrawColor(HelpDraw,0xffffffff);
    TextDrawSetOutline(HelpDraw,1);
    TextDrawSetProportional(HelpDraw,1);
    UsePlayerPedAnims();
    SendRconCommand("hostname [0.3е] Таз Дрифт™ - Лихие 90-е| ");
	SetGameModeText("  •••Таз Дрифт•••");//game mode name

	SendRconCommand("mapname Drift Streets ");
	AllowAdminTeleport(1);
	

	new rand = random(sizeof(RandomSpawn));	//Скины
	AddPlayerClass(292,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(293,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(295,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(21,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(23,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(28,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(29,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(41,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(47,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(63,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(64,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(83,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(93,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(91,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(101,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(102,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(103,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(104,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(105,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(106,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(107,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(108,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(109,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(110,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(113,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(114,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(115,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(116,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(117,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(118,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(119,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(120,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(121,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(134,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(135,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(136,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(137,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(141,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(143,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(147,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(150,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(151,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(152,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(156,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(169,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(170,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(176,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(177,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(178,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(179,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(180,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(185,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(186,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(187,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(188,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(189,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(190,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(191,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(192,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(193,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(194,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(195,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(203,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(204,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(228,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(229,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(233,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(240,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(241,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(242,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(249,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(250,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(251,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(252,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(258,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(259,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(269,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(270,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(271,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(285,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(295,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
//==================================================КАРТА=======МОДА==========================================================================
//Ухо By Gamer
CreateDynamicObject(8661, -328.29980, 1524.69922, 74.40000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(8661, -328.25845, 1517.43848, 74.38000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(8661, -288.32709, 1525.68335, 74.40000,   -0.02000, 0.00000, 0.00000);
CreateDynamicObject(8661, -288.30551, 1517.40820, 74.38000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(8661, -295.20279, 1566.94104, 74.38000,   0.00000, 0.00000, 313.99481);
CreateDynamicObject(8661, -278.83978, 1548.66064, 74.38000,   0.00000, 0.00000, 313.99481);
CreateDynamicObject(8661, -283.14523, 1544.52417, 74.38000,   0.00000, 0.00000, 313.99481);
CreateDynamicObject(16362, -275.83530, 1552.79150, 77.46000,   0.00000, 0.00000, 45.00000);
CreateDynamicObject(16362, -292.89301, 1569.73547, 77.44000,   0.00000, 0.00000, 45.00000);
CreateDynamicObject(982, -268.28598, 1551.72119, 75.21620,   0.00000, 0.00000, 45.00000);
CreateDynamicObject(982, -286.41464, 1569.88977, 75.21620,   0.00000, 0.00000, 45.00000);
CreateDynamicObject(982, -294.35742, 1577.81470, 75.21620,   0.00000, 0.00000, 45.00000);
CreateDynamicObject(9482, -302.23795, 1507.13660, 78.58560,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(19279, -307.78256, 1507.62329, 74.45140,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19279, -296.70892, 1507.61877, 74.45140,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1262, -307.69299, 1507.50391, 77.37390,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1262, -296.69217, 1507.55078, 77.37390,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(984, -302.30069, 1507.39807, 72.60160,   90.00000, 0.00000, 90.00000);
CreateDynamicObject(1262, -301.91147, 1507.85059, 77.69390,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1262, -302.57327, 1507.71875, 77.69390,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1262, -302.57330, 1507.71875, 75.75390,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1262, -301.91150, 1507.85059, 75.75390,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2780, -310.71579, 1506.90417, 73.77430,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2780, -293.15469, 1506.98083, 73.81430,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(14467, -313.29999, 1536.00000, 77.30000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(2790, -333.60001, 1537.40002, 76.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(9192, -300.29999, 1539.50000, 79.40000,   0.00000, 0.00000, 76.00000);
CreateDynamicObject(1251, -304.91229, 1507.36035, 74.33310,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(1251, -300.14981, 1507.34814, 74.33310,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(10281, -321.00000, 1536.40002, 76.80000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1302, -324.79999, 1536.50000, 74.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1302, -326.00000, 1536.50000, 74.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(984, -347.41220, 1517.87268, 75.03250,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(984, -332.18579, 1507.41504, 75.03250,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(983, -322.54541, 1507.40308, 75.07250,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(983, -316.06659, 1507.37427, 75.07250,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(983, -341.84183, 1507.41846, 75.07250,   0.00000, 0.00000, 90.00000);
CreateDynamicObject(983, -347.42062, 1510.64832, 75.07250,   0.00000, 0.00000, 360.00000);
CreateDynamicObject(983, -344.21698, 1507.42627, 75.07250,   0.00000, 0.00000, -270.00000);
CreateDynamicObject(16133, -452.22656, 1833.27344, 67.41406,   3.14159, 0.00000, 0.04363);
CreateDynamicObject(984, -347.40491, 1529.07874, 75.03250,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(984, -263.83362, 1538.25696, 75.17250,   0.00000, 0.00000, 133.00000);
CreateDynamicObject(984, -273.25693, 1529.48364, 75.17250,   0.00000, 0.00000, 133.00000);
CreateDynamicObject(984, -282.70670, 1520.81763, 75.17250,   0.00000, 0.00000, 132.00000);
CreateDynamicObject(983, -289.87390, 1514.36401, 75.21250,   0.00000, 0.00000, 132.00000);
CreateDynamicObject(983, -291.05710, 1513.29163, 75.21250,   0.00000, 0.00000, 132.00000);
CreateDynamicObject(14467, -294.38748, 1508.94885, 77.19190,   0.00000, 0.00000, -113.00000);
CreateDynamicObject(14467, -310.47672, 1508.88318, 77.19190,   0.00000, 0.00000, 88.00000);
CreateDynamicObject(19279, -308.45325, 1507.63708, 74.45140,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19279, -296.04633, 1507.60400, 74.45140,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3472, -289.47256, 1535.94421, 74.39420,   0.00000, 0.00000, 47.00000);
CreateDynamicObject(19127, -313.07867, 1506.99170, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -316.08655, 1507.20520, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -319.30099, 1507.12012, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -322.54535, 1507.16895, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -325.78729, 1507.21008, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -329.02930, 1507.25110, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -332.21744, 1507.15649, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -335.37921, 1507.26147, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -338.59564, 1507.24695, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -341.86954, 1507.36035, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -345.05148, 1507.27917, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.59656, 1507.41528, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.58572, 1510.62561, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.61224, 1513.03552, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.63446, 1516.22131, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.59698, 1519.45374, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.59772, 1522.66260, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.62314, 1525.82886, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.69846, 1529.03394, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.63077, 1532.22717, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19127, -347.61707, 1535.43701, 75.10340,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -293.25998, 1511.01440, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -290.92996, 1513.14685, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -288.55579, 1515.30115, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -286.13629, 1517.43945, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -283.79099, 1519.60742, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -281.37302, 1521.69336, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(8661, -300.20001, 1562.09998, 74.40000,   0.00000, 0.00000, 313.99481);
CreateDynamicObject(19124, -279.05789, 1523.87769, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -276.69559, 1526.10022, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -274.34216, 1528.30005, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -271.98914, 1530.44250, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -269.63589, 1532.61365, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -267.23895, 1534.84131, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -264.92688, 1537.06506, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -262.56357, 1539.23853, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -260.25171, 1541.45313, 75.13420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -260.28751, 1543.85266, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -262.57373, 1546.10669, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -264.77240, 1548.42322, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -267.03253, 1550.66931, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -269.27859, 1552.97961, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -271.56805, 1555.19800, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -273.84433, 1557.44592, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -276.10373, 1559.69800, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -278.39267, 1562.07288, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -280.65109, 1564.32251, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -282.90198, 1566.59924, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -285.13843, 1568.86182, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -287.37656, 1571.18115, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -289.64551, 1573.42126, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -291.99673, 1575.62695, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -294.21811, 1577.88501, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -296.50052, 1580.13586, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -298.72849, 1582.46838, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -300.98389, 1584.73938, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19124, -303.44379, 1587.05103, 75.09420,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(983, -305.65179, 1584.71252, 75.19750,   0.00000, 0.00000, -45.00000);
CreateDynamicObject(983, -310.22400, 1580.14600, 75.19750,   0.00000, 0.00000, -45.00000);
CreateDynamicObject(983, -314.77032, 1575.58813, 75.19750,   0.00000, 0.00000, -45.00000);
CreateDynamicObject(983, -318.73123, 1571.63123, 75.19750,   0.00000, 0.00000, -45.00000);
CreateDynamicObject(984, -316.58987, 1564.69336, 75.19640,   0.00000, 0.00000, 43.00000);
CreateDynamicObject(19123, -305.77576, 1584.81311, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -308.07773, 1582.55859, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -310.37662, 1580.22009, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -312.67615, 1578.03662, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -314.92261, 1575.72998, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -317.15668, 1573.49365, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -319.25900, 1571.21338, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -321.08859, 1569.28418, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -318.96515, 1566.85913, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -316.77081, 1564.58105, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -314.50507, 1562.26245, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(19123, -312.39655, 1559.86292, 75.07900,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1491, -341.62460, 1534.88110, 74.60000,   0.00000, 0.00000, 182.00000);
CreateDynamicObject(1491, -344.60001, 1534.80005, 74.60000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(1561, -344.05380, 1549.57642, 74.60000,   0.00000, 0.00000, 181.99950);
CreateDynamicObject(1561, -345.52051, 1549.52295, 74.60000,   0.00000, 0.00000, 182.00000);
CreateDynamicObject(16151, -340.46210, 1545.17871, 74.90000,   0.00000, 0.00000, 0.00000);
CreateDynamicObject(3921, -346.33591, 1538.48535, 75.06000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(3921, -346.33154, 1545.46362, 75.06000,   0.00000, 0.00000, 180.00000);
CreateDynamicObject(2571, -340.65079, 1538.38562, 74.55910,   0.00000, 0.00000, -111.00000);
CreateDynamicObject(3472, -318.51547, 1535.87891, 74.39420,   0.00000, 0.00000, 47.00000);
CreateDynamicObject(3472, -337.16266, 1536.20325, 74.39420,   0.00000, 0.00000, 47.00000);
CreateDynamicObject(3472, -308.36908, 1502.72717, 74.39420,   0.00000, 0.00000, 47.00000);
CreateDynamicObject(3472, -307.76456, 1496.30164, 74.35420,   0.00000, 0.00000, 47.00000);
CreateDynamicObject(3472, -307.41159, 1490.11401, 74.35420,   0.00000, 0.00000, 47.00000);
CreateDynamicObject(3472, -294.41638, 1490.50720, 74.45420,   0.00000, 0.00000, 47.00000);
CreateDynamicObject(3472, -295.22745, 1503.44312, 74.39420,   0.00000, 0.00000, 47.00000);
CreateDynamicObject(3472, -295.01193, 1497.26392, 74.35420,   0.00000, 0.00000, 47.00000);
//Кс зона
CreateDynamicObject(11088,11.39355469,1530.79785156,17.10690498,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(cf_ext_dem_sfs) (1)
CreateDynamicObject(11425,-24.13992882,1519.40429688,13.37168884,0.00000000,0.00000000,268.00000000,-1,-1,-1,400.0); //object(des_adobehooses1) (1)
CreateDynamicObject(11427,-59.27343750,1519.42480469,18.83986282,0.00000000,0.00000000,169.99694824,-1,-1,-1,400.0); //object(des_adobech) (1)
CreateDynamicObject(11440,-46.85805130,1498.24853516,11.12500954,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo1) (1)
CreateDynamicObject(11444,-32.66200256,1485.78649902,11.67500114,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo2) (1)
CreateDynamicObject(11425,-1.71582031,1483.81250000,13.37168884,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_adobehooses1) (2)
CreateDynamicObject(11428,-45.53079224,1535.68383789,17.65346909,0.00000000,0.00000000,129.99572754,-1,-1,-1,400.0); //object(des_indruin02) (1)
CreateDynamicObject(11440,-39.58090973,1513.20678711,11.13103104,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo1) (2)
CreateDynamicObject(11440,52.89167786,1501.13549805,11.10000992,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo1) (3)
CreateDynamicObject(11442,-17.90039825,1478.49487305,11.67500114,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (1)
CreateDynamicObject(11445,40.55740738,1483.58935547,11.67500114,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo06) (1)
CreateDynamicObject(11492,48.60552597,1554.99243164,11.47500420,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_rshed1_) (1)
CreateDynamicObject(11459,61.71430969,1539.36999512,11.50602341,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo11) (1)
CreateDynamicObject(11457,51.78515625,1534.22851562,11.27500725,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo09) (1)
CreateDynamicObject(11440,22.22757149,1558.66735840,11.28103065,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo1) (4)
CreateDynamicObject(11442,-20.48148918,1568.88269043,11.62500191,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (2)
CreateDynamicObject(3279,-28.39682579,1557.54248047,11.70000076,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(a51_spottower) (1)
CreateDynamicObject(3279,-60.76557159,1505.33789062,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(a51_spottower) (2)
CreateDynamicObject(3279,18.64076233,1504.20581055,11.76966381,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(a51_spottower) (3)
CreateDynamicObject(3279,-5.64424324,1486.77783203,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(a51_spottower) (4)
CreateDynamicObject(3279,66.15112305,1516.88757324,11.75000191,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(a51_spottower) (6)
CreateDynamicObject(3279,14.76146889,1550.64758301,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(a51_spottower) (7)
CreateDynamicObject(3279,-5.80990791,1572.52343750,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(a51_spottower) (8)
CreateDynamicObject(3279,-21.24704742,1603.67138672,24.71391487,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(a51_spottower) (9)
CreateDynamicObject(3279,23.27245522,1617.66064453,23.98921585,358.09793091,341.98974609,299.38174438,-1,-1,-1,400.0); //object(a51_spottower) (10)
CreateDynamicObject(3279,42.10429001,1598.32043457,27.29174042,0.00000000,0.00000000,62.00000000,-1,-1,-1,400.0); //object(a51_spottower) (11)
CreateDynamicObject(3279,-74.14198303,1573.16857910,20.07663345,0.00000000,0.00000000,50.00000000,-1,-1,-1,400.0); //object(a51_spottower) (12)
CreateDynamicObject(3279,-64.16227722,1608.24414062,21.68597603,12.00000000,0.00000000,100.00000000,-1,-1,-1,400.0); //object(a51_spottower) (13)
CreateDynamicObject(3279,95.37085724,1532.01867676,14.36106682,0.00000000,0.00000000,300.00000000,-1,-1,-1,400.0); //object(a51_spottower) (14)
CreateDynamicObject(3279,-29.48935699,1449.12023926,9.98191643,352.12231445,349.90374756,288.60198975,-1,-1,-1,400.0); //object(a51_spottower) (15)
CreateDynamicObject(3279,26.78252411,1446.37817383,11.11869812,0.00000000,342.00000000,290.00000000,-1,-1,-1,400.0); //object(a51_spottower) (16)
CreateDynamicObject(3279,73.21582031,1472.51562500,9.29774284,341.99890137,0.00000000,339.99938965,-1,-1,-1,400.0); //object(a51_spottower) (17)
CreateDynamicObject(3279,114.59971619,1581.14538574,28.50854683,24.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(a51_spottower) (18)
CreateDynamicObject(3279,91.98788452,1606.44238281,26.94906807,8.00000000,0.00000000,32.00000000,-1,-1,-1,400.0); //object(a51_spottower) (19)
CreateDynamicObject(11446,44.35117340,1564.66076660,11.60000229,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo07) (1)
CreateDynamicObject(11445,39.60933685,1570.75427246,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo06) (2)
CreateDynamicObject(11444,52.36035919,1569.13293457,11.60000229,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo2) (2)
CreateDynamicObject(11446,29.57835770,1571.51342773,11.75000000,0.00000000,0.00000000,32.00000000,-1,-1,-1,400.0); //object(des_pueblo07) (2)
CreateDynamicObject(11428,8.28795242,1573.21289062,16.95950317,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_indruin02) (2)
CreateDynamicObject(11427,-28.22853851,1530.19030762,18.79588699,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_adobech) (2)
CreateDynamicObject(11442,-18.97460556,1513.83178711,11.50000381,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (3)
CreateDynamicObject(11443,-32.63393402,1495.09729004,11.27500534,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo4) (1)
CreateDynamicObject(11441,20.58934021,1490.01818848,11.62500191,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (1)
CreateDynamicObject(11441,22.13263512,1480.44055176,11.65000153,0.00000000,0.00000000,240.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (2)
CreateDynamicObject(11442,47.78327179,1491.02539062,11.50000381,0.00000000,0.00000000,320.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (4)
CreateDynamicObject(11441,66.77010345,1505.24853516,11.75602341,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (3)
CreateDynamicObject(11441,64.51130676,1526.04516602,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (4)
CreateDynamicObject(11441,65.49880981,1531.64807129,11.75000000,0.00000000,0.00000000,152.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (5)
CreateDynamicObject(11440,93.26179504,1546.68359375,15.28085136,0.00000000,0.00000000,50.00000000,-1,-1,-1,400.0); //object(des_pueblo1) (5)
CreateDynamicObject(11428,90.00682831,1500.34033203,16.51323891,3.73709106,4.76013184,347.68649292,-1,-1,-1,400.0); //object(des_indruin02) (3)
CreateDynamicObject(11426,100.79296875,1515.11035156,11.18389034,9.50000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_adobe03) (1)
CreateDynamicObject(11442,115.94517517,1502.31250000,9.26373100,0.00000000,0.00000000,30.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (5)
CreateDynamicObject(11442,51.34179688,1455.78027344,12.51997185,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (6)
CreateDynamicObject(11440,-3.92187500,1441.15527344,11.34714508,0.00000000,0.00000000,305.99670410,-1,-1,-1,400.0); //object(des_pueblo1) (6)
CreateDynamicObject(11445,15.29546547,1440.98681641,12.82229424,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo06) (3)
CreateDynamicObject(11446,-16.90917969,1446.00195312,11.95339298,0.00000000,0.00000000,189.99755859,-1,-1,-1,400.0); //object(des_pueblo07) (3)
CreateDynamicObject(11447,-17.53456879,1455.63061523,12.92852211,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo08) (1)
CreateDynamicObject(11445,-66.03710938,1482.62792969,12.34497643,0.24987793,358.24996948,0.00762939,-1,-1,-1,400.0); //object(des_pueblo06) (4)
CreateDynamicObject(11428,-81.13378906,1498.07421875,16.62991524,1.96655273,349.99145508,16.34216309,-1,-1,-1,400.0); //object(des_indruin02) (4)
CreateDynamicObject(11440,-83.66142273,1553.80969238,17.32989311,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo1) (7)
CreateDynamicObject(11440,-77.87735748,1590.42907715,19.03844070,0.00000000,0.00000000,6.00000000,-1,-1,-1,400.0); //object(des_pueblo1) (8)
CreateDynamicObject(11445,-45.58261108,1607.33105469,24.33002663,0.00000000,0.00000000,142.00000000,-1,-1,-1,400.0); //object(des_pueblo06) (5)
CreateDynamicObject(11446,-10.69552994,1602.50842285,25.07114601,0.00000000,0.00000000,30.00000000,-1,-1,-1,400.0); //object(des_pueblo07) (4)
CreateDynamicObject(11445,5.53906250,1602.32031250,25.70122910,353.50000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo06) (6)
CreateDynamicObject(11446,17.22632217,1601.77978516,26.95508957,0.00000000,0.00000000,60.00000000,-1,-1,-1,400.0); //object(des_pueblo07) (5)
CreateDynamicObject(11443,28.90039062,1598.58300781,27.38588524,0.00000000,0.00000000,309.99572754,-1,-1,-1,400.0); //object(des_pueblo4) (2)
CreateDynamicObject(11442,57.23560333,1592.57531738,27.19487572,0.00000000,0.00000000,296.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (7)
CreateDynamicObject(11441,82.84088135,1598.48876953,25.89921379,0.00000000,0.00000000,294.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (6)
CreateDynamicObject(11440,69.62695312,1603.51660156,24.93751335,353.00000000,0.00000000,19.99511719,-1,-1,-1,400.0); //object(des_pueblo1) (9)
CreateDynamicObject(11427,44.07421875,1618.33203125,30.19685745,356.08395386,11.77789307,60.81219482,-1,-1,-1,400.0); //object(des_adobech) (3)
CreateDynamicObject(11425,-1.57910156,1614.93066406,24.93722725,346.26055908,357.68151855,359.44674683,-1,-1,-1,400.0); //object(des_adobehooses1) (3)
CreateDynamicObject(11428,-42.89648438,1621.94042969,26.92713737,0.00000000,12.00000000,103.99658203,-1,-1,-1,400.0); //object(des_indruin02) (5)
CreateDynamicObject(11440,-57.18069458,1574.85205078,19.40796852,6.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo1) (10)
CreateDynamicObject(11441,-54.45557404,1533.12768555,11.75000000,0.00000000,0.00000000,46.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (7)
CreateDynamicObject(11441,-62.18692017,1529.86535645,11.75000000,0.00000000,0.00000000,56.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (8)
CreateDynamicObject(11441,-49.04937363,1540.17077637,11.75000000,0.00000000,0.00000000,104.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (9)
CreateDynamicObject(11441,-43.06010437,1488.75097656,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (10)
CreateDynamicObject(11441,-35.55252838,1502.16796875,11.75000000,0.00000000,0.00000000,74.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (11)
CreateDynamicObject(11442,60.44181061,1474.94616699,12.33252144,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (8)
CreateDynamicObject(11442,-76.29003906,1513.47949219,12.63221169,359.26782227,12.50103760,0.16235352,-1,-1,-1,400.0); //object(des_pueblo3) (9)
CreateDynamicObject(11442,-49.41210938,1473.76171875,12.48012352,355.25000000,0.00000000,69.99938965,-1,-1,-1,400.0); //object(des_pueblo3) (10)
CreateDynamicObject(11443,-36.94380951,1462.24096680,12.74638176,0.00000000,0.00000000,100.00000000,-1,-1,-1,400.0); //object(des_pueblo4) (3)
CreateDynamicObject(11444,15.96977234,1457.49438477,13.41581345,0.00000000,0.00000000,290.00000000,-1,-1,-1,400.0); //object(des_pueblo2) (3)
CreateDynamicObject(11443,5.97363281,1466.96484375,12.91345787,0.24176025,345.24987793,260.06057739,-1,-1,-1,400.0); //object(des_pueblo4) (4)
CreateDynamicObject(11442,32.36718750,1462.89257812,13.74642372,0.00000000,0.00000000,149.99633789,-1,-1,-1,400.0); //object(des_pueblo3) (11)
CreateDynamicObject(11442,80.06347656,1528.43164062,13.74084282,359.00213623,3.75057983,240.06176758,-1,-1,-1,400.0); //object(des_pueblo3) (12)
CreateDynamicObject(11442,94.65917969,1584.24609375,27.23160934,0.00000000,349.99694824,317.99926758,-1,-1,-1,400.0); //object(des_pueblo3) (13)
CreateDynamicObject(11441,29.07385635,1547.61376953,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (12)
CreateDynamicObject(11441,34.69346237,1561.28076172,11.75602341,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (13)
CreateDynamicObject(11441,41.99515915,1543.19824219,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (14)
CreateDynamicObject(11441,45.86892319,1520.63171387,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (15)
CreateDynamicObject(11441,59.58566284,1517.99230957,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (16)
CreateDynamicObject(11441,52.33769226,1544.25354004,11.75000000,0.00000000,0.00000000,46.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (17)
CreateDynamicObject(11441,69.56905365,1492.93310547,12.73072720,0.00000000,0.00000000,44.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (18)
CreateDynamicObject(11441,48.27575302,1472.55615234,13.37082195,0.00000000,0.00000000,40.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (19)
CreateDynamicObject(11441,33.38951874,1490.32580566,11.75000000,0.00000000,0.00000000,72.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (20)
CreateDynamicObject(11441,5.45251083,1488.54125977,11.75000000,0.00000000,0.00000000,64.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (21)
CreateDynamicObject(11441,-8.94433594,1467.77734375,13.16621590,356.00976562,355.99026489,359.72052002,-1,-1,-1,400.0); //object(des_pueblo5) (22)
CreateDynamicObject(11441,-23.55170631,1466.76770020,12.96571255,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (23)
CreateDynamicObject(11441,-17.29100418,1497.94079590,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (24)
CreateDynamicObject(11441,-35.45489883,1476.61669922,11.91085625,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (25)
CreateDynamicObject(11441,-54.07519531,1489.38476562,12.58029556,8.22735596,14.65414429,49.85531616,-1,-1,-1,400.0); //object(des_pueblo5) (26)
CreateDynamicObject(11441,-60.07324219,1474.58886719,11.88917255,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (27)
CreateDynamicObject(11441,-45.60073471,1457.64282227,12.07471657,0.00000000,0.00000000,120.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (28)
CreateDynamicObject(11441,-20.56054688,1440.52539062,11.32461166,0.00000000,0.00000000,159.99938965,-1,-1,-1,400.0); //object(des_pueblo5) (29)
CreateDynamicObject(11441,-6.41503906,1431.59570312,11.24961281,0.00000000,0.00000000,159.99389648,-1,-1,-1,400.0); //object(des_pueblo5) (30)
CreateDynamicObject(11441,22.41894531,1430.97851562,11.92216110,1.74938965,1.50070190,359.95416260,-1,-1,-1,400.0); //object(des_pueblo5) (31)
CreateDynamicObject(11441,41.06640625,1439.30664062,12.68830490,359.25033569,1.75015259,52.02120972,-1,-1,-1,400.0); //object(des_pueblo5) (32)
CreateDynamicObject(11441,56.03125000,1444.46777344,11.79400063,357.00482178,3.25445557,300.16839600,-1,-1,-1,400.0); //object(des_pueblo5) (33)
CreateDynamicObject(11441,-64.08876038,1464.36901855,10.70021057,0.00000000,0.00000000,120.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (34)
CreateDynamicObject(11442,-61.89074326,1555.21826172,18.08532333,0.00000000,0.00000000,30.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (14)
CreateDynamicObject(11442,-76.27956390,1621.37145996,20.69282532,0.00000000,0.00000000,316.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (15)
CreateDynamicObject(11442,108.32519531,1597.19238281,28.66092682,358.50000000,0.00000000,29.99816895,-1,-1,-1,400.0); //object(des_pueblo3) (16)
CreateDynamicObject(11442,115.27014160,1529.81335449,13.16141891,0.00000000,0.00000000,84.00000000,-1,-1,-1,400.0); //object(des_pueblo3) (17)
CreateDynamicObject(11446,-19.72596169,1547.25671387,11.75602150,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo07) (6)
CreateDynamicObject(11446,22.63277054,1469.83300781,12.62115574,350.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo07) (7)
CreateDynamicObject(11446,73.35941315,1542.99060059,13.22923851,354.52038574,335.88284302,359.55212402,-1,-1,-1,400.0); //object(des_pueblo07) (8)
CreateDynamicObject(695,35.61067200,1613.51452637,30.15418816,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_scabtg) (1)
CreateDynamicObject(694,-90.88413239,1582.47875977,23.45396423,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_redwoodgrp) (1)
CreateDynamicObject(694,-67.69046783,1647.33715820,19.50544357,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_redwoodgrp) (2)
CreateDynamicObject(689,-43.02234650,1426.95935059,9.09030151,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_copse1) (1)
CreateDynamicObject(689,-29.84834290,1429.69433594,8.94030380,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_copse1) (2)
CreateDynamicObject(683,145.01171875,1585.92578125,33.02599716,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_group) (1)
CreateDynamicObject(683,70.16210938,1461.53808594,11.21506691,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_group) (2)
CreateDynamicObject(683,78.36768341,1515.49926758,11.74015617,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_group) (3)
CreateDynamicObject(683,-49.65624237,1600.74365234,24.00297928,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_group) (4)
CreateDynamicObject(683,-17.94304848,1560.71105957,11.75000000,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_group) (5)
CreateDynamicObject(683,-2.44773865,1506.28283691,11.76315308,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_group) (6)
CreateDynamicObject(683,-4.43457031,1462.32128906,13.64342117,2.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_group) (7)
CreateDynamicObject(838,76.07701874,1448.21960449,12.65692329,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(dead_tree_9) (1)
CreateDynamicObject(839,83.85203552,1457.48986816,11.21940804,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(dead_tree_11) (1)
CreateDynamicObject(843,77.57162476,1495.67272949,13.39622879,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(dead_tree_15) (1)
CreateDynamicObject(844,92.39669800,1519.38720703,13.46102619,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(dead_tree_16) (1)
CreateDynamicObject(846,106.29631042,1541.58105469,15.98761749,6.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(dead_tree_18) (1)
CreateDynamicObject(847,99.37926483,1496.53930664,12.71765518,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(dead_tree_19) (1)
CreateDynamicObject(12807,-123.15187073,1424.55187988,11.98972130,9.75000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sw_logs4) (1)
CreateDynamicObject(18273,-0.03754874,1529.37023926,31.69785309,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(cw2_weefirz08) (1)
CreateDynamicObject(790,-2.42152786,1629.34863281,20.66007996,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sm_fir_tallgroup) (1)
CreateDynamicObject(864,-52.66627121,1464.24243164,11.94914436,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(sand_combush1) (1)
CreateDynamicObject(11442,-32.86594009,1582.40222168,15.98803902,359.03411865,15.00219727,359.75885010,-1,-1,-1,400.0); //object(des_pueblo3) (18)
CreateDynamicObject(11441,-47.47829437,1565.41357422,18.15082550,0.00000000,18.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (35)
CreateDynamicObject(11441,-18.94961929,1581.87133789,11.74999809,0.00000000,0.00000000,230.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (36)
CreateDynamicObject(11441,45.34637070,1556.23657227,11.75602341,0.00000000,0.00000000,300.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (37)
CreateDynamicObject(11441,32.04117966,1534.20507812,11.76966476,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (38)
CreateDynamicObject(11443,1.24387169,1533.09960938,11.76966667,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo4) (5)
CreateDynamicObject(11441,30.27392387,1522.16723633,11.76315498,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (39)
CreateDynamicObject(11441,-9.96101761,1473.97595215,11.75602436,0.00000000,0.00000000,90.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (40)
CreateDynamicObject(11441,6.91229057,1504.02563477,11.76966381,0.00000000,0.00000000,52.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (41)
CreateDynamicObject(11441,-62.97911072,1541.55847168,14.68398857,0.00000000,55.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (42)
CreateDynamicObject(11444,-51.09960938,1550.50878906,15.99558258,3.53259277,38.33496094,325.95999146,-1,-1,-1,400.0); //object(des_pueblo2) (4)
CreateDynamicObject(11441,-48.92210770,1587.20788574,21.34633827,358.05941772,14.00820923,0.48403931,-1,-1,-1,400.0); //object(des_pueblo5) (43)
CreateDynamicObject(11441,-31.83277130,1597.92041016,24.49545479,0.00000000,0.00000000,230.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (44)
CreateDynamicObject(11441,-5.95905304,1549.68750000,11.76315498,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (45)
CreateDynamicObject(11441,10.36285210,1557.18591309,11.75000000,0.00000000,0.00000000,60.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (46)
CreateDynamicObject(11441,70.65429688,1565.67187500,13.87289333,359.75000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(des_pueblo5) (47)
CreateDynamicObject(3279,9.19628906,1590.90429688,17.50793076,0.00000000,319.99877930,90.00000000,-1,-1,-1,400.0); //object(a51_spottower) (20)
CreateDynamicObject(1225,-17.44799232,1597.39318848,25.67115784,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (1)
CreateDynamicObject(1225,-38.87304688,1610.82873535,24.96720505,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (2)
CreateDynamicObject(1225,-26.17926025,1545.33996582,12.15575504,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (3)
CreateDynamicObject(1225,-13.46191406,1581.17187500,12.15575504,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (4)
CreateDynamicObject(1225,-53.71972656,1562.23632812,19.57032013,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (5)
CreateDynamicObject(1225,-40.91076660,1469.71691895,13.77743244,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (6)
CreateDynamicObject(1225,-34.29492188,1521.99609375,12.16177845,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (7)
CreateDynamicObject(1225,-20.10839844,1494.00781250,12.15575504,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (8)
CreateDynamicObject(1225,-2.03710938,1477.54003906,12.16177845,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (9)
CreateDynamicObject(1225,27.08591461,1455.54016113,14.12065220,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (10)
CreateDynamicObject(1225,38.53022385,1488.50341797,12.15575504,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (11)
CreateDynamicObject(1225,67.95399475,1483.63061523,13.05847454,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (12)
CreateDynamicObject(1225,53.25002289,1532.02172852,14.78232479,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (13)
CreateDynamicObject(1225,56.44824219,1511.28906250,12.15575504,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (14)
CreateDynamicObject(1225,19.92583847,1551.74462891,12.15575504,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (15)
CreateDynamicObject(1225,47.10937500,1550.72460938,12.15575504,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (16)
CreateDynamicObject(1225,-6.58227348,1557.38732910,12.16891003,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (17)
CreateDynamicObject(1225,31.03171539,1516.20556641,12.16891003,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (18)
CreateDynamicObject(1225,-7.61621094,1558.25683594,12.16891003,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (19)
CreateDynamicObject(1225,-9.79492188,1528.62207031,12.16891003,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (20)
CreateDynamicObject(11088,11.39355469,1530.79785156,17.10690498,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(cf_ext_dem_sfs) (1)
CreateDynamicObject(1225,30.06347656,1531.10351562,12.16891003,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (21)
CreateDynamicObject(1225,6.97558594,1519.94531250,12.17541981,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (22)
CreateDynamicObject(1225,-4.75747252,1458.71899414,14.41119862,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (23)
CreateDynamicObject(1225,11.17187500,1501.76855469,12.16891003,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(barrel4) (24)
CreateDynamicObject(1395,29.94042778,1481.84606934,44.28005981,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(twrcrane_l_03) (1)
CreateDynamicObject(1384,29.87783813,1481.90197754,96.83226013,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(twrcrane_m_01) (1)
CreateDynamicObject(11400,29.88260078,1531.04260254,99.67449188,0.00000000,0.00000000,90.00000000,-1,-1,-1,400.0); //object(acwinch1b_sfs02) (1)
CreateDynamicObject(3287,-30.93980217,1614.37329102,29.17645073,0.00000000,0.00000000,0.00000000,-1,-1,-1,400.0); //object(cxrf_oiltank) (1)
//------______________________________Аквапарк______________________------------
CreateDynamicObject(10830,285.13000000,-1918.17000000,7.65000000,0.00000000,0.00000000,45.65000000); //
CreateDynamicObject(12990,273.66000000,-1908.59000000,0.51000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(12990,273.65000000,-1926.06000000,0.51000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(12990,297.66000000,-1912.46000000,0.51000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(12990,297.66000000,-1925.65000000,0.51000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1655,343.93000000,-1998.08000000,0.00000000,0.00000000,0.00000000,274.65000000); //
CreateDynamicObject(1655,350.84000000,-1997.48000000,4.00000000,13.90000000,0.00000000,274.64000000); //
CreateDynamicObject(7392,359.36000000,-2009.68000000,10.81000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(9958,281.75000000,-2030.92000000,5.00000000,0.00000000,0.00000000,268.69000000); //
CreateDynamicObject(1217,271.89000000,-1940.48000000,1.36000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1217,272.71000000,-1940.51000000,1.36000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1217,273.71000000,-1940.55000000,1.36000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1217,274.71000000,-1940.59000000,1.36000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1217,275.46000000,-1940.61000000,1.36000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1217,295.99000000,-1940.13000000,1.36000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1217,296.99000000,-1940.17000000,1.36000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1217,297.99000000,-1940.21000000,1.36000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1217,299.24000000,-1940.26000000,1.36000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,200.54000000,-1932.07000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,195.10000000,-1928.99000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,190.54000000,-1926.40000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,186.19000000,-1923.94000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,182.05000000,-1921.59000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,176.51000000,-1930.80000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,180.46000000,-1933.47000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,183.45000000,-1935.27000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,188.38000000,-1938.24000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,193.74000000,-1941.46000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,190.95000000,-1939.78000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1243,197.31000000,-1930.19000000,-4.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1655,178.35000000,-1925.54000000,0.00000000,0.00000000,0.00000000,63.52000000); //
CreateDynamicObject(1655,172.96000000,-1922.91000000,3.50000000,15.88000000,0.00000000,63.52000000); //
CreateDynamicObject(16401,270.18000000,-2014.25000000,-0.50000000,0.00000000,0.00000000,274.65000000); //
CreateDynamicObject(621,311.50000000,-1940.38000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,259.07000000,-1941.04000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,232.87000000,-1982.35000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,242.02000000,-2036.34000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,335.84000000,-2028.85000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,296.90000000,-1971.85000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,343.65000000,-1966.15000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,325.50000000,-2070.28000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1631,290.43000000,-2012.41000000,0.00000000,3.97000000,3.97000000,159.51000000); //
CreateDynamicObject(13641,220.59000000,-2014.25000000,1.50000000,0.00000000,0.00000000,219.06000000); //
CreateDynamicObject(13641,201.26000000,-2030.82000000,1.50000000,0.00000000,0.00000000,36.44000000); //
CreateDynamicObject(18451,175.14000000,-1966.98000000,0.50000000,0.00000000,0.00000000,91.31000000); //
CreateDynamicObject(3472,269.58000000,-1892.81000000,0.09000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,301.25000000,-1896.17000000,0.09000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,308.89000000,-1894.54000000,12.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,308.84000000,-1900.55000000,12.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,309.04000000,-1907.53000000,12.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,309.29000000,-1915.51000000,12.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,309.21000000,-1925.26000000,12.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,309.18000000,-1932.26000000,12.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,309.05000000,-1940.50000000,12.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,299.69000000,-1940.84000000,13.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,291.85000000,-1940.95000000,15.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,285.16000000,-1940.95000000,16.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,278.83000000,-1941.06000000,15.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,272.00000000,-1940.72000000,14.35000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,263.77000000,-1941.04000000,13.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,261.42000000,-1932.82000000,13.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,260.85000000,-1925.30000000,13.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,261.42000000,-1918.58000000,13.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,260.25000000,-1911.70000000,13.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,260.39000000,-1904.18000000,13.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3877,260.42000000,-1897.91000000,13.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(7073,156.33000000,-1943.25000000,21.15000000,0.00000000,0.00000000,13.89000000); //
CreateDynamicObject(1225,207.69000000,-2018.31000000,11.40000000,0.00000000,91.31000000,316.33000000); //
CreateDynamicObject(1225,214.30000000,-2026.79000000,11.40000000,0.00000000,91.31000000,316.33000000); //
CreateDynamicObject(13593,269.40000000,-2046.54000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,272.22000000,-2046.43000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,274.97000000,-2046.36000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,277.72000000,-2046.19000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,280.22000000,-2046.25000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,282.73000000,-2046.23000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,285.24000000,-2046.17000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,287.73000000,-2046.27000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,290.08000000,-2046.11000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,292.83000000,-2046.05000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(13593,295.08000000,-2045.97000000,0.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,342.74000000,-1991.00000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,342.82000000,-1991.75000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,342.90000000,-1992.49000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,342.99000000,-1993.24000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,344.08000000,-2003.18000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,344.17000000,-2003.92000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,344.25000000,-2004.67000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,344.33000000,-2005.41000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,344.33000000,-2005.41000000,0.86000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,344.25000000,-2004.67000000,0.86000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,344.16000000,-2003.92000000,0.86000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,344.08000000,-2003.17000000,0.86000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,342.74000000,-1991.00000000,0.86000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,342.82000000,-1991.75000000,0.86000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,342.90000000,-1992.49000000,0.86000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1554,342.99000000,-1993.24000000,0.86000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3080,393.64000000,-1988.88000000,0.75000000,0.00000000,0.00000000,91.31000000); //
CreateDynamicObject(3080,393.57000000,-1984.91000000,0.75000000,0.00000000,0.00000000,91.31000000); //
CreateDynamicObject(3080,393.50000000,-1981.42000000,0.75000000,0.00000000,0.00000000,91.31000000); //
CreateDynamicObject(3080,388.49000000,-1981.52000000,3.75000000,13.89000000,0.00000000,91.31000000); //
CreateDynamicObject(3080,388.52000000,-1985.52000000,3.75000000,13.89000000,0.00000000,91.30000000); //
CreateDynamicObject(3080,388.66000000,-1989.27000000,3.75000000,13.89000000,0.00000000,91.30000000); //
CreateDynamicObject(1655,165.60000000,-2008.56000000,0.84000000,0.00000000,0.00000000,99.25000000); //
CreateDynamicObject(1655,164.41000000,-2000.89000000,0.84000000,0.00000000,0.00000000,99.24000000); //
CreateDynamicObject(1655,159.71000000,-2001.57000000,3.59000000,15.88000000,0.00000000,99.24000000); //
CreateDynamicObject(1655,160.90000000,-2009.36000000,3.59000000,15.88000000,0.00000000,99.24000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,1.00000000,0.00000000,0.00000000,276.63000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,3.75000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,6.75000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,9.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,12.25000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,15.00000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,17.75000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,20.75000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,20.75000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,18.00000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,15.00000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,12.00000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,9.00000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,6.25000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,3.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,0.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,152.90000000,-2011.58000000,0.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,152.90000000,-2011.58000000,3.25000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,152.90000000,-2011.58000000,5.25000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,151.73000000,-2001.65000000,5.25000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,151.73000000,-2001.65000000,2.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,151.73000000,-2001.65000000,0.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,23.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,26.25000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,150.62000000,-1991.69000000,26.25000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,23.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,154.17000000,-2021.52000000,26.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,152.97000000,-2011.34000000,26.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,151.78000000,-2001.66000000,26.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,151.78000000,-2001.66000000,23.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(1684,152.96000000,-2011.34000000,23.50000000,0.00000000,0.00000000,276.62000000); //
CreateDynamicObject(621,260.65000000,-1889.56000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,309.30000000,-1893.92000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,314.00000000,-1899.35000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,312.19000000,-1895.43000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,258.70000000,-1896.44000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(621,258.52000000,-1893.16000000,-1.25000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3552,307.98000000,-1894.41000000,16.73000000,0.00000000,0.00000000,18.69000000); //
CreateDynamicObject(3552,261.29000000,-1894.87000000,16.73000000,0.00000000,0.00000000,353.79000000); //
CreateDynamicObject(1655,168.67000000,-1909.87000000,1.82000000,15.88000000,0.00000000,87.18000000); //
CreateDynamicObject(1655,169.15000000,-1901.20000000,1.82000000,15.88000000,0.00000000,87.18000000); //
CreateDynamicObject(7392,361.30000000,-1885.32000000,16.26000000,0.00000000,0.00000000,359.70000000); //
CreateDynamicObject(18750,230.80000000,-1760.82000000,33.88000000,90.00000000,0.00000000,358.43000000); //
CreateDynamicObject(18846,284.74000000,-1895.15000000,20.23000000,0.00000000,0.00000000,180.97000000); //
CreateDynamicObject(18846,277.62000000,-1895.28000000,19.12000000,0.00000000,0.00000000,178.80000000); //
CreateDynamicObject(18846,292.13000000,-1894.93000000,19.12000000,0.00000000,0.00000000,178.80000000); //
CreateDynamicObject(18844,233.91000000,-2139.23000000,-0.88000000,90.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18822,352.81000000,-1915.75000000,9.03000000,0.00000000,-73.00000000,90.00000000); //
CreateDynamicObject(18822,352.89000000,-1960.00000000,27.99000000,0.00000000,108.00000000,90.20000000); //
CreateDynamicObject(18809,353.05000000,-2008.00000000,33.13000000,-90.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18809,353.08000000,-2057.83000000,33.13000000,-90.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18826,350.34000000,-2092.88000000,48.83000000,-10.00000000,0.00000000,90.00000000); //
CreateDynamicObject(18826,344.86000000,-2072.03000000,48.83000000,-10.00000000,0.00000000,270.00000000); //
CreateDynamicObject(18826,339.37000000,-2092.95000000,48.83000000,-10.00000000,0.00000000,90.00000000); //
CreateDynamicObject(18826,333.89000000,-2071.99000000,48.83000000,-10.00000000,0.00000000,270.00000000); //
CreateDynamicObject(18826,328.37000000,-2092.96000000,48.83000000,-10.00000000,0.00000000,90.00000000); //
CreateDynamicObject(18826,322.82000000,-2071.92000000,48.83000000,-10.00000000,0.00000000,270.00000000); //
CreateDynamicObject(18809,320.07000000,-2107.31000000,33.13000000,-90.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18809,320.08000000,-2157.22000000,33.13000000,-90.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18809,319.95000000,-2206.92000000,33.13000000,-90.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18822,313.10000000,-2255.11000000,33.30000000,90.00000000,0.00000000,157.78000000); //
CreateDynamicObject(18822,280.82000000,-2289.33000000,33.30000000,90.00000000,0.00000000,115.60000000); //
CreateDynamicObject(18822,233.91000000,-2294.10000000,33.30000000,90.00000000,0.00000000,76.04000000); //
CreateDynamicObject(18822,194.89000000,-2267.88000000,33.50000000,90.00000000,0.00000000,36.21000000); //
CreateDynamicObject(18809,175.51000000,-2223.22000000,33.59000000,0.00000000,-90.00000000,286.74000000); //
CreateDynamicObject(18809,161.08000000,-2175.37000000,33.59000000,0.00000000,-90.00000000,286.74000000); //
CreateDynamicObject(18809,148.84000000,-2126.95000000,33.59000000,0.00000000,-90.00000000,281.92000000); //
CreateDynamicObject(18809,140.49000000,-2077.99000000,33.59000000,0.00000000,-90.00000000,277.61000000); //
CreateDynamicObject(18809,136.04000000,-2028.61000000,33.59000000,0.00000000,-90.00000000,272.82000000); //
CreateDynamicObject(18809,133.59000000,-1978.81000000,33.59000000,0.00000000,-90.00000000,272.82000000); //
CreateDynamicObject(18809,131.09000000,-1930.10000000,30.15000000,0.00000000,-98.00000000,273.00000000); //
CreateDynamicObject(18809,129.50000000,-1881.09000000,23.19000000,0.00000000,-98.00000000,270.80000000); //
CreateDynamicObject(18824,140.36000000,-1838.99000000,12.70000000,-109.00000000,0.00000000,314.91000000); //
CreateDynamicObject(3364,322.64000000,-1830.29000000,2.16000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(971,158.53000000,-1827.59000000,2.96000000,96.00000000,0.00000000,270.00000000); //
AddStaticVehicleEx(493, 292.7691, -1931.1865, 0.0000, 179.3649, -1, -1, 100);
AddStaticVehicleEx(493, 292.5287, -1909.8075, 0.0000, 179.3627, -1, -1, 100);
AddStaticVehicleEx(493, 302.5141, -1910.3544, 0.0000, 179.3627, -1, -1, 100);
AddStaticVehicleEx(493, 303.0970, -1934.2050, 0.0000, 179.3573, -1, -1, 100);
AddStaticVehicleEx(446, 268.4485, -1934.9374, 0.0000, 181.3500, -1, -1, 100);
AddStaticVehicleEx(446, 268.1511, -1910.3079, 0.0000, 181.3458, -1, -1, 100);
AddStaticVehicleEx(446, 278.4165, -1910.7870, 0.0000, 181.3458, -1, -1, 100);
AddStaticVehicleEx(446, 279.3409, -1934.2803, 0.0000, 181.3458, -1, -1, 100);
AddStaticVehicleEx(454, 285.3713, -1911.2118, 0.0000, 181.3500, -1, -1, 100);
//Гора
CreateDynamicObject(11431,-2244.81000000,-1706.95000000,480.82000000,0.00000000,0.00000000,137.83000000); //
CreateDynamicObject(11431,-2251.64000000,-1700.57000000,481.02000000,0.00000000,0.00000000,138.47000000); //
CreateDynamicObject(11431,-2258.84000000,-1693.70000000,480.94000000,0.00000000,0.00000000,137.36000000); //
CreateDynamicObject(11431,-2267.22000000,-1688.13000000,481.11000000,0.00000000,0.00000000,192.65000000); //
CreateDynamicObject(3511,-2261.46000000,-1689.85000000,479.49000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2254.99000000,-1697.13000000,479.29000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2247.94000000,-1703.88000000,479.19000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2242.37000000,-1711.81000000,479.19000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18090,-2237.25000000,-1719.30000000,482.55000000,0.00000000,0.00000000,8.28000000); //
CreateDynamicObject(3511,-2272.10000000,-1688.12000000,479.08000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2278.89000000,-1715.65000000,472.70000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2282.85000000,-1703.70000000,476.59000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2285.09000000,-1720.14000000,470.70000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2289.64000000,-1706.38000000,475.70000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3583,-2284.37000000,-1682.71000000,483.04000000,0.00000000,0.00000000,214.39000000); //
CreateDynamicObject(1675,-2348.46000000,-1610.16000000,485.81000000,0.00000000,0.00000000,254.46000000); //
CreateDynamicObject(1675,-2338.23000000,-1588.01000000,485.67000000,0.00000000,0.00000000,235.78000000); //
CreateDynamicObject(3616,-2349.63000000,-1632.84000000,485.53000000,0.00000000,0.00000000,93.24000000); //
CreateDynamicObject(3616,-2341.98000000,-1656.59000000,485.73000000,0.00000000,0.00000000,119.18000000); //
CreateDynamicObject(3511,-2341.34000000,-1599.59000000,482.19000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2348.12000000,-1620.55000000,482.19000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2346.71000000,-1645.05000000,482.59000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2335.87000000,-1667.41000000,481.49000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1544,-2238.73000000,-1717.52000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1544,-2238.66000000,-1718.46000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1544,-2238.51000000,-1719.40000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18789,-2233.91000000,-1579.37000000,480.88000000,0.00000000,0.00000000,26.10000000); //
CreateDynamicObject(18800,-2131.21000000,-1554.44000000,492.22000000,0.00000000,0.00000000,25.71000000); //
CreateDynamicObject(738,-2331.30000000,-1674.48000000,482.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2325.61000000,-1680.10000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2321.29000000,-1684.54000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2317.59000000,-1679.32000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2313.76000000,-1674.56000000,482.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2301.63000000,-1701.15000000,478.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2307.51000000,-1696.07000000,480.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2313.20000000,-1690.91000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2304.30000000,-1691.15000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2300.17000000,-1685.91000000,482.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18800,-2183.82000000,-1580.07000000,515.74000000,0.00000000,0.00000000,205.68000000); //
CreateDynamicObject(18750,-2376.39000000,-1618.87000000,515.45000000,87.00000000,6.00000000,69.65000000); //
CreateDynamicObject(18804,-2100.30000000,-1516.18000000,527.79000000,0.00000000,0.00000000,24.54000000); //
CreateDynamicObject(18779,-2028.00000000,-1476.60000000,536.83000000,0.00000000,0.00000000,204.68000000); //
CreateDynamicObject(18786,-2240.24000000,-1739.30000000,481.15000000,0.00000000,0.00000000,126.65000000); //
CreateDynamicObject(738,-2295.54000000,-1706.10000000,476.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2300.11000000,-1601.29000000,480.49000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2288.68000000,-1617.21000000,481.90000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,-2262.42000000,-1714.58000000,478.59000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,-2325.99000000,-1672.96000000,481.70000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3606,-2290.74000000,-1660.11000000,484.94000000,0.00000000,0.00000000,256.20000000); //
CreateDynamicObject(3606,-2287.79000000,-1636.34000000,485.55000000,0.00000000,0.00000000,270.64000000); //
CreateDynamicObject(3511,-2288.56000000,-1648.38000000,481.49000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2288.06000000,-1673.60000000,481.19000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3511,-2328.08000000,-1581.40000000,482.08000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2303.93000000,-1595.76000000,482.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2310.39000000,-1592.25000000,482.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2316.94000000,-1588.94000000,482.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-2323.67000000,-1586.28000000,483.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(19122,-2285.08000000,-1611.90000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(19122,-2291.05000000,-1599.88000000,481.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,-2313.71000000,-1641.01000000,482.28000000,0.00000000,0.00000000,0.00000000); //
AddStaticVehicleEx(411,-2306.90450000,-1688.48280000,481.40100000,336.07080000,-1,-1,15); //Infernus
AddStaticVehicleEx(411,-2310.16430000,-1686.86000000,481.54080000,336.04090000,-1,-1,15); //Infernus
AddStaticVehicleEx(522,-2316.99980000,-1683.01670000,481.51010000,324.16780000,-1,-1,15); //NRG-500
AddStaticVehicleEx(522,-2314.53030000,-1684.54790000,481.48430000,330.52240000,-1,-1,15); //NRG-500
//Остров
CreateObject(18751, 596.34637, -2068.30737, 3.46339,   0.00000, 0.00000, 0.00000);
CreateObject(18751, 536.69910, -2068.82202, 2.66657,   0.00000, 0.00000, 0.00000);
CreateObject(11496, 515.63983, -2043.84985, 7.60534,   0.00000, 0.00000, 0.00000);
CreateObject(11496, 515.62939, -2059.83936, 7.60530,   0.00000, 0.00000, 0.00000);
CreateObject(11496, 515.61908, -2075.83008, 7.60530,   0.00000, 0.00000, 0.00000);
CreateObject(11496, 515.61078, -2091.83154, 7.60530,   0.00000, 0.00000, 0.00000);
CreateObject(11496, 512.18420, -2033.36011, 7.60530,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 501.68451, -2036.82104, 7.60530,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 501.70401, -2052.81470, 7.60530,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 501.71170, -2068.79492, 7.60530,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 501.72400, -2084.79346, 7.60530,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 505.17981, -2095.27856, 7.60530,   0.00000, 0.00000, 270.00000);
CreateObject(3648, 508.01010, -2087.96069, 10.55300,   0.00000, 0.00000, -180.00000);
CreateObject(11496, 508.65665, -2079.49536, 7.58530,   0.00000, 0.00000, 180.00000);
CreateObject(3640, 507.30945, -2071.60181, 12.26150,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 510.62582, -2061.88550, 7.58530,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 510.65671, -2047.18677, 7.58530,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 515.69330, -2079.85571, 7.58530,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 504.89444, -2062.25537, 7.58530,   0.00000, 0.00000, 360.00000);
CreateObject(11496, 502.87411, -2047.24585, 7.58530,   0.00000, 0.00000, 360.00000);
CreateObject(11496, 510.73071, -2043.86646, 7.56530,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 502.96829, -2043.80347, 7.56530,   0.00000, 0.00000, 360.00000);
CreateObject(3648, 506.66141, -2054.48535, 10.55300,   0.00000, 0.00000, -180.00000);
CreateObject(11496, 543.45758, -2088.39331, 9.84066,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 559.40601, -2088.39478, 9.84066,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 575.39697, -2088.36133, 9.84066,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 539.99298, -2098.87427, 9.84070,   0.00000, 0.00000, 180.00000);
CreateObject(11490, 560.33850, -2097.88281, 8.54900,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 550.47089, -2102.33936, 9.84070,   0.00000, 0.00000, 270.00000);
CreateObject(11496, 568.35864, -2102.30273, 9.84070,   0.00000, 0.00000, 270.00000);
CreateObject(11496, 578.85040, -2098.85278, 9.84070,   0.00000, 0.00000, 360.00000);
CreateObject(11496, 557.39313, -2102.31177, 9.82070,   0.00000, 0.00000, 270.00000);
CreateObject(11496, 568.37860, -2093.34692, 9.84070,   0.00000, 0.00000, 270.00000);
CreateObject(11496, 550.44879, -2093.37549, 9.84070,   0.00000, 0.00000, 270.00000);
CreateObject(11496, 591.38043, -2088.39551, 9.84066,   0.00000, 0.00000, 90.00000);
CreateObject(19452, 560.37720, -2090.50952, 11.51665,   0.00000, 0.00000, 90.00000);
CreateObject(19452, 560.82324, -2102.36865, 12.23800,   0.00000, 0.00000, 90.00000);
CreateObject(1649, 562.52380, -2090.51709, 13.81900,   0.00000, -135.00000, 0.00000);
CreateObject(1649, 558.28027, -2090.47412, 13.93320,   0.00000, 135.00000, 0.00000);
CreateObject(1569, 559.50360, -2089.23071, 10.04120,   0.00000, 0.00000, 0.00000);
CreateObject(11496, 594.83820, -2098.88965, 9.84070,   0.00000, 0.00000, 360.00000);
CreateObject(11496, 586.97510, -2102.31421, 9.82070,   0.00000, 0.00000, 270.00000);
CreateObject(3640, 506.95349, -2039.54346, 12.26150,   0.00000, 0.00000, 90.00000);
CreateObject(3648, 587.33881, -2096.04346, 12.76980,   0.00000, 0.00000, -90.00000);
CreateObject(11496, 613.47504, -2088.46069, 9.83850,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 613.47742, -2072.46631, 9.83850,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 613.48560, -2056.47681, 9.83850,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 613.49554, -2040.47302, 9.83850,   0.00000, 0.00000, 180.00000);
CreateObject(11496, 623.95209, -2091.93335, 9.83850,   0.00000, 0.00000, 270.00000);
CreateObject(11496, 627.41089, -2081.44067, 9.83850,   0.00000, 0.00000, 360.00000);
CreateObject(11496, 627.41455, -2065.44824, 9.83850,   0.00000, 0.00000, 360.00000);
CreateObject(11496, 627.42261, -2049.45337, 9.83850,   0.00000, 0.00000, 360.00000);
CreateObject(11496, 623.98633, -2037.02063, 9.83850,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 623.91290, -2044.02429, 9.81850,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 623.70258, -2050.91602, 9.81850,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 623.73773, -2058.05884, 9.81850,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 623.56085, -2065.13940, 9.81850,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 623.96240, -2072.09253, 9.81850,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 623.88837, -2079.03003, 9.81850,   0.00000, 0.00000, 90.00000);
CreateObject(11496, 623.58667, -2086.99390, 9.81850,   0.00000, 0.00000, 90.00000);
CreateObject(3648, 621.19019, -2042.80225, 12.75750,   0.00000, 0.00000, 0.00000);
CreateObject(3640, 622.01056, -2059.30884, 14.46980,   0.00000, 0.00000, -90.00000);
CreateObject(5520, 622.40472, -2080.75391, 15.15860,   0.00000, 0.00000, -90.00000);
CreateObject(11496, 623.73901, -2082.95166, 9.79850,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.11029, -2031.58728, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.09869, -2034.78699, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.09393, -2042.90552, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.10565, -2048.35693, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.10083, -2051.95679, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.09790, -2059.39844, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.07892, -2064.82251, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.05890, -2066.82495, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.07446, -2075.01147, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.09229, -2080.45361, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.08459, -2084.43481, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.06390, -2091.49561, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 520.06580, -2097.11597, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 517.30963, -2099.76172, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 511.86911, -2099.74756, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 506.40912, -2099.74146, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 500.96634, -2099.75098, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 499.76517, -2099.73047, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 517.30170, -2080.60669, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 511.85855, -2080.60767, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 517.34351, -2062.27222, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 511.88550, -2062.26294, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 506.43771, -2062.25269, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 517.31738, -2047.42395, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 511.87158, -2047.42200, 8.36220,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 517.39954, -2028.90747, 8.36220,   0.00000, 0.00000, 180.00000);
CreateObject(1408, 511.94080, -2028.90161, 8.36220,   0.00000, 0.00000, 180.00000);
CreateObject(1408, 506.49338, -2028.89868, 8.36220,   0.00000, 0.00000, 180.00000);
CreateObject(1408, 501.04022, -2028.90710, 8.36220,   0.00000, 0.00000, 180.00000);
CreateObject(3361, 522.94202, -2038.84729, 5.72540,   0.00000, 0.00000, 0.00000);
CreateObject(3361, 522.94202, -2038.84729, 5.72540,   0.00000, 0.00000, 0.00000);
CreateObject(3361, 522.96295, -2055.70435, 5.72540,   0.00000, 0.00000, 0.00000);
CreateObject(3361, 522.93658, -2070.80420, 5.72540,   0.00000, 0.00000, 0.00000);
CreateObject(3361, 522.88812, -2087.94482, 5.72540,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 538.22711, -2083.94092, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 543.66669, -2083.92041, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 549.09418, -2083.92310, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 554.53656, -2083.93164, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 556.13623, -2083.93555, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 563.99951, -2083.92993, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 569.45972, -2083.91748, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 574.93939, -2083.89331, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 580.38367, -2083.89917, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 583.96820, -2083.90283, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 591.35114, -2083.92432, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 596.66980, -2083.92163, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 599.30249, -2086.64575, 10.60170,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 599.29926, -2092.10571, 10.60170,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 599.29602, -2097.56396, 10.60170,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 599.29443, -2103.00269, 10.60170,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 579.45782, -2086.67920, 10.60170,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 579.44940, -2092.12305, 10.60170,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 579.45496, -2097.52466, 10.60170,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 535.53296, -2086.65308, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 535.52350, -2092.12158, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 535.52887, -2097.58154, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 535.53650, -2103.04492, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(3361, 560.08569, -2081.11841, 7.94930,   0.00000, 0.00000, 90.00000);
CreateObject(3361, 587.63525, -2081.00464, 7.94930,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 505.08801, -2031.70288, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 508.44049, -2047.07532, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 504.45404, -2062.39111, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 506.69336, -2079.82227, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 505.59601, -2097.02271, 8.36220,   0.00000, 0.00000, 90.00000);
CreateObject(1408, 579.31793, -2097.01123, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 609.01453, -2093.67896, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.00983, -2088.23779, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.00177, -2080.73169, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.01434, -2075.27832, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.00397, -2069.81201, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.00519, -2064.35156, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.03009, -2056.84351, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.01385, -2051.42334, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.02155, -2045.32288, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.04218, -2037.96069, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 609.04224, -2035.19739, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 611.78870, -2032.57556, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 617.25104, -2032.58264, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 622.73114, -2032.56287, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 628.15100, -2032.56226, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 611.81073, -2050.64478, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 617.25916, -2050.63623, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 611.78613, -2068.17944, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 617.17096, -2068.17969, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 623.16266, -2035.28809, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 621.92255, -2050.44189, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 619.10718, -2069.50415, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(1408, 611.69189, -2096.37622, 10.60170,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 617.14789, -2096.39209, 10.60170,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 622.60779, -2096.38892, 10.60170,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 628.05847, -2096.38843, 10.60170,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 623.70959, -2093.66870, 10.60170,   0.00000, 0.00000, -90.00000);
CreateObject(3361, 606.08807, -2084.57471, 7.94930,   0.00000, 0.00000, 180.00000);
CreateObject(3361, 606.18695, -2060.63867, 7.94930,   0.00000, 0.00000, 180.00000);
CreateObject(3361, 606.21539, -2041.62256, 7.94930,   0.00000, 0.00000, 180.00000);
CreateObject(3361, 600.71210, -2041.62561, 4.27270,   0.00000, 0.00000, 180.00000);
CreateObject(625, 520.96289, -2029.61157, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(625, 521.25720, -2043.44861, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(625, 521.18976, -2050.09937, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(625, 521.07275, -2061.53809, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(625, 521.29852, -2066.12354, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(625, 521.27570, -2075.92676, 8.52080,   0.00000, 0.00000, 1.56000);
CreateObject(625, 521.26379, -2083.00952, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(625, 521.11176, -2099.02661, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(625, 508.13220, -2099.11475, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(625, 514.42407, -2099.09351, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(625, 521.19202, -2093.19067, 8.52080,   0.00000, 0.00000, 0.00000);
CreateObject(1408, 538.35492, -2100.51855, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(1408, 596.48364, -2099.47485, 10.60170,   0.00000, 0.00000, -180.00000);
CreateObject(625, 537.99426, -2099.93091, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 537.98566, -2091.72412, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 538.03540, -2084.54517, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 547.51581, -2084.64941, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 556.75525, -2084.56421, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 569.14368, -2084.54053, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 577.90741, -2084.58887, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 584.38672, -2084.78662, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 593.32849, -2084.45459, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 600.30096, -2084.66113, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 600.43201, -2091.56982, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 600.41272, -2098.88696, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 597.55048, -2103.22925, 10.84430,   0.00000, 0.00000, 0.00000);
CreateObject(625, 622.28424, -2093.97656, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 609.77924, -2093.89795, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 609.63550, -2087.09814, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 609.75598, -2079.01001, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 609.72266, -2067.24902, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 609.69000, -2055.88818, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 609.72540, -2048.19995, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 609.63318, -2038.14087, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 616.83441, -2031.49023, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 622.50604, -2031.41577, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(625, 627.71228, -2032.58594, 10.84430,   0.00000, 0.00000, 87.71998);
CreateObject(18228, 627.82111, -2022.18042, -5.65032,   0.00000, 0.00000, 132.89998);
CreateObject(710, 590.78564, -2049.71436, 20.61799,   0.00000, 0.00000, 0.00000);
CreateObject(710, 580.28424, -2070.23413, 18.10714,   0.00000, 0.00000, 0.00000);
CreateObject(710, 535.91705, -2068.75464, 22.83529,   0.00000, 0.00000, 0.00000);
CreateObject(710, 538.07758, -2048.14478, 18.99059,   0.00000, 0.00000, 0.00000);
CreateObject(710, 543.91187, -2054.99121, 18.99059,   0.00000, 0.00000, 0.00000);
CreateObject(710, 526.35406, -2112.86890, 15.61975,   0.00000, 0.00000, 0.00000);
CreateObject(18228, 505.32523, -2116.62793, -5.65032,   0.00000, 0.00000, 300.89996);
CreateObject(710, 497.02563, -2101.55884, 15.61975,   0.00000, 0.00000, 0.00000);
CreateObject(710, 492.16971, -2081.14038, 14.39736,   0.00000, 0.00000, 0.00000);
CreateObject(710, 489.92517, -2051.07983, 14.39736,   0.00000, 0.00000, 0.00000);
CreateObject(710, 513.52838, -2023.81995, 14.39736,   0.00000, 0.00000, 0.00000);
CreateObject(710, 606.65698, -2066.92529, 22.86846,   0.00000, 0.00000, 0.00000);
CreateObject(710, 636.40021, -2032.36523, 18.33943,   0.00000, 0.00000, 0.00000);
CreateObject(710, 642.04413, -2058.50610, 14.31365,   0.00000, 0.00000, 0.00000);
CreateObject(710, 642.27826, -2080.59692, 14.31365,   0.00000, 0.00000, 0.00000);
CreateObject(710, 630.78766, -2103.22266, 19.36145,   0.00000, 0.00000, 0.00000);
CreateObject(710, 590.13196, -2108.65405, 16.78982,   0.00000, 0.00000, 0.00000);
CreateObject(710, 549.99487, -2117.69873, 16.78982,   0.00000, 0.00000, 0.00000);
CreateObject(740, 609.03760, -2108.42480, -12.37333,   0.00000, 0.00000, 0.00000);
CreateObject(740, 523.13727, -2106.58716, -12.37333,   0.00000, 0.00000, 0.00000);
CreateObject(740, 565.37238, -2116.48120, -22.24227,   0.00000, 0.00000, 0.00000);
CreateObject(740, 627.43164, -2110.46240, -27.10451,   0.00000, 0.00000, 0.00000);
CreateObject(740, 636.22125, -2071.85181, -12.37333,   0.00000, 0.00000, 0.00000);
CreateObject(740, 644.86536, -2043.57507, -25.76430,   0.00000, 0.00000, 0.00000);
CreateObject(740, 491.43634, -2068.17505, -24.32100,   0.00000, 0.00000, 0.00000);
CreateObject(622, 631.36157, -2018.19727, -0.16370,   0.00000, 0.00000, -4.68000);
CreateObject(622, 493.83286, -2031.41455, -0.16370,   0.00000, 0.00000, 54.36002);
CreateObject(622, 641.16187, -2026.84900, -0.16370,   0.00000, 0.00000, -67.74000);
CreateObject(18228, 487.53516, -2040.79456, -5.65032,   0.00000, 0.00000, 220.91998);
CreateObject(18228, 639.39563, -2107.05200, -5.65032,   0.00000, 0.00000, 356.39996);
CreateObject(622, 639.08826, -2106.23291, -0.16370,   0.00000, 0.00000, -67.74000);
CreateObject(622, 494.86606, -2110.51904, -0.16370,   0.00000, 0.00000, -208.79996);
CreateObject(622, 485.19919, -2047.86450, -0.16370,   0.00000, 0.00000, 87.12000);
CreateObject(6296, 561.40698, -2038.62146, 6.10189,   0.00000, 0.00000, 89.45999);
CreateObject(11495, 524.56134, -2015.90405, 1.23730,   0.00000, 0.00000, 180.00000);
CreateObject(11495, 524.55823, -2006.73865, 1.21730,   0.00000, 0.00000, 180.00000);
CreateObject(822, 590.69611, -2049.03638, 6.03149,   0.00000, 0.00000, 0.00000);
CreateObject(822, 606.04852, -2066.08496, 8.82695,   0.00000, 0.00000, 0.00000);
CreateObject(822, 580.31525, -2069.87817, 7.51925,   0.00000, 0.00000, 0.00000);
CreateObject(740, 582.08197, -2068.64575, -27.10451,   0.00000, 0.00000, 0.00000);
CreateObject(822, 581.95587, -2069.36230, 7.51925,   0.00000, 0.00000, 0.00000);
CreateObject(822, 535.84045, -2068.27734, 8.83406,   0.00000, 0.00000, 0.00000);
CreateObject(822, 543.79559, -2054.24854, 7.11698,   0.00000, 0.00000, 0.00000);
CreateObject(822, 538.47992, -2047.32007, 4.86358,   0.00000, 0.00000, 0.00000);
CreateObject(822, 567.09656, -2032.93518, 3.56001,   0.00000, 0.00000, 0.00000);
CreateObject(822, 568.32629, -2033.14075, 3.56001,   0.00000, 0.00000, 0.00000);
CreateObject(822, 569.54504, -2035.42090, 3.56001,   0.00000, 0.00000, 0.00000);
CreateObject(822, 570.24640, -2037.36267, 4.26906,   0.00000, 0.00000, 0.00000);
CreateObject(822, 571.24878, -2040.71545, 4.57207,   0.00000, 0.00000, -74.16000);
CreateObject(822, 555.74994, -2032.37830, 3.56001,   0.00000, 0.00000, 262.62000);
CreateObject(822, 553.37451, -2034.77319, 3.56001,   0.00000, 0.00000, 284.40002);
CreateObject(822, 552.61444, -2037.61487, 3.56001,   0.00000, 0.00000, 284.40002);
CreateObject(822, 553.17200, -2040.58630, 4.07011,   0.00000, 0.00000, 284.40002);
CreateObject(822, 554.39764, -2043.42468, 4.47615,   0.00000, 0.00000, 284.40002);
CreateObject(1255, 515.10352, -2031.35095, 8.34530,   0.00000, 0.00000, 40.44000);
CreateObject(1255, 514.82526, -2033.60291, 8.34530,   0.00000, 0.00000, 0.12000);
CreateObject(1255, 517.34985, -2034.36621, 8.34530,   0.00000, 0.00000, 54.12000);
CreateObject(1255, 612.88312, -2035.30103, 10.60110,   0.00000, 0.00000, 147.48000);
CreateObject(1255, 612.84558, -2037.61768, 10.60110,   0.00000, 0.00000, 138.84001);
CreateObject(1255, 610.57007, -2037.28296, 10.60110,   0.00000, 0.00000, 103.01999);
CreateObject(1255, 572.40955, -2032.23059, 5.24213,   0.00000, 0.00000, 88.80000);
CreateObject(1255, 578.10449, -2032.83508, 4.42593,   0.00000, 0.00000, 61.67999);
CreateObject(1255, 582.03247, -2033.12073, 4.52896,   0.00000, 0.00000, 90.89999);
CreateObject(1255, 586.28754, -2032.91736, 4.52896,   0.00000, 0.00000, 90.30000);
CreateObject(1255, 589.70398, -2032.98462, 4.93096,   0.00000, 0.00000, 90.30000);
CreateObject(18751, 607.93988, -2010.18469, -4.53550,   0.00000, 0.00000, -94.20000);
CreateObject(18751, 610.01587, -1984.05420, -4.53550,   0.00000, 0.00000, -94.20000);
CreateObject(18751, 603.90295, -1963.33630, -4.53550,   0.00000, 0.00000, -273.05991);
CreateObject(18751, 614.68036, -1938.68530, -4.53550,   0.00000, 0.00000, -198.71989);
CreateObject(18751, 623.38385, -1918.77917, -4.53550,   0.00000, 0.00000, -120.71990);
CreateObject(622, 633.86127, -1919.66357, -0.44779,   0.00000, 0.00000, 244.97997);
CreateObject(622, 602.32483, -1914.62744, -0.44779,   0.00000, 0.00000, 108.53996);
CreateObject(710, 628.90405, -1929.86938, 13.84110,   0.00000, 0.00000, 0.00000);
CreateObject(710, 596.36719, -1932.80823, 13.78244,   0.00000, 0.00000, 0.00000);
CreateObject(710, 620.21619, -2015.49182, 13.78244,   0.00000, 0.00000, 0.00000);
CreateObject(18751, 607.11755, -2024.68176, -3.05497,   0.00000, 0.00000, -229.25999);
CreateObject(896, 638.11700, -1919.77466, 0.17528,   0.00000, 0.00000, 0.00000);
CreateObject(896, 648.00592, -1924.91724, 0.17528,   0.00000, 0.00000, -61.86000);
CreateObject(896, 636.75464, -1930.35645, 0.17528,   0.00000, 0.00000, -61.86000);
CreateObject(896, 596.02026, -1921.69116, 0.17528,   0.00000, 0.00000, -70.98000);
CreateObject(896, 597.96564, -1913.68665, 0.17528,   0.00000, 0.00000, 43.19999);
CreateObject(896, 599.49670, -1928.47351, 0.17528,   0.00000, 0.00000, 87.06000);
//Драг 1, Драг 2.
AddStaticVehicle(563,-1706.04199219,-231.16503906,21.31699944,180.00000000,-1,-1); //Raindance
AddStaticVehicle(526,-1680.12805176,-243.85400391,13.68000031,314.00000000,-1,-1); //Fortune
AddStaticVehicle(526,-1676.44494629,-249.25199890,13.68000031,135.99475098,-1,-1); //Fortune
AddStaticVehicle(603,-1643.91894531,-174.21600342,14.15100002,136.00000000,-1,-1); //Phoenix
AddStaticVehicle(562,-1639.38696289,-177.35000610,14.20199966,136.00000000,-1,-1); //Elegy
AddStaticVehicle(429,-1676.57299805,-215.75000000,13.89799976,0.00000000,-1,-1); //Banshee
AddStaticVehicle(402,-1680.65905762,-211.72999573,14.08800030,0.00000000,-1,-1); //Buffalo
AddStaticVehicle(411,-1684.90625000,-207.91503906,13.94799995,0.00000000,-1,-1); //Infernus
AddStaticVehicle(415,-1689.26293945,-203.80599976,13.99800014,0.00000000,-1,-1); //Cheetah
AddStaticVehicle(573,-1624.52502441,-251.78799438,14.95900059,0.00000000,-1,-1); //Duneride
AddStaticVehicle(573,-1619.88903809,-247.19599915,14.96400070,0.00000000,-1,-1); //Duneride
AddStaticVehicle(556,-1605.73144531,-259.98632812,14.00000000,279.99755859,-1,-1); //Monster A
AddStaticVehicle(556,-1610.07604980,-265.67999268,13.99994755,279.99755859,-1,-1); //Monster A
AddStaticVehicle(420,-1265.39196777,-30.07200050,13.99800014,182.00000000,-1,-1); //Taxi
AddStaticVehicle(477,-1268.57604980,-79.15599823,13.99800014,44.00000000,-1,-1); //ZR-350
AddStaticVehicle(477,-1276.53894043,-71.07700348,13.99800014,43.99475098,-1,-1); //ZR-350
AddStaticVehicle(402,-1256.32702637,-37.21599960,14.08800030,0.00000000,-1,-1); //Buffalo
AddStaticVehicle(402,-1252.49401855,-41.27799988,14.08800030,0.00000000,-1,-1); //Buffalo
AddStaticVehicle(535,-1245.04003906,-19.35400009,13.98799992,316.00000000,-1,-1); //Slamvan
AddStaticVehicle(535,-1241.05603027,-23.43600082,13.98799992,315.99475098,-1,-1); //Slamvan
AddStaticVehicle(535,-1237.09497070,-27.32200050,13.98799992,316.00000000,-1,-1); //Slamvan
AddStaticVehicle(535,-1233.01904297,-31.38199997,13.98799992,315.99975586,-1,-1); //Slamvan
AddStaticVehicle(535,-1228.94201660,-35.40900040,13.98799992,315.99975586,-1,-1); //Slamvan
AddStaticVehicle(560,-1693.32604980,-199.08500671,13.99499989,0.00000000,1,1); //Sultan
AddStaticVehicle(467,-1686.43896484,-195.82600403,13.99100018,0.00000000,6,1); //Oceanic
CreateDynamicObject(10830,-1642.10253906,-150.60742188,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (1)
CreateDynamicObject(10830,-1608.75598145,-117.21900177,21.35000038,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (2)
CreateDynamicObject(10830,-1575.47595215,-83.87400055,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (3)
CreateDynamicObject(10830,-1542.11804199,-50.51800156,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (4)
CreateDynamicObject(10830,-1508.62402344,-16.99900055,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (5)
CreateDynamicObject(10830,-1475.76403809,15.85499954,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (6)
CreateDynamicObject(10830,-1442.74511719,48.77832031,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (7)
CreateDynamicObject(10830,-1409.72497559,81.94599915,21.34700012,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (8)
CreateDynamicObject(10830,-1376.98095703,114.72200012,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (9)
CreateDynamicObject(10830,-1343.98205566,147.79899597,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (10)
CreateDynamicObject(10830,-1310.69628906,181.05468750,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (11)
CreateDynamicObject(10830,-1276.80603027,214.87699890,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (12)
CreateDynamicObject(10830,-1243.28405762,248.55000305,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (13)
CreateDynamicObject(10830,-1210.21594238,281.66900635,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (14)
CreateDynamicObject(10830,-1176.29003906,315.70001221,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (15)
CreateDynamicObject(10830,-1142.29199219,349.63900757,21.45700073,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (16)
CreateDynamicObject(10765,-1655.97558594,-163.75488281,13.20699978,0.00000000,0.00000000,0.00000000); //object(skidmarks_sfse) (1)
CreateDynamicObject(10830,-1109.60302734,382.14498901,21.35499954,0.00000000,0.00000000,0.00000000); //object(drydock2_sfse) (17)
CreateDynamicObject(7033,-1654.62304688,-162.51699829,17.52099991,0.00000000,0.00000000,136.00000000); //object(vgnhsegate02) (1)
CreateDynamicObject(970,-1639.02697754,-167.80499268,13.69999981,0.00000000,0.00000000,315.99975586); //object(fencesmallb) (4)
CreateDynamicObject(970,-1636.04895020,-170.65600586,13.76200008,0.00000000,0.00000000,315.99975586); //object(fencesmallb) (5)
CreateDynamicObject(970,-1633.33105469,-173.27000427,13.79799938,0.00000000,0.00000000,315.99975586); //object(fencesmallb) (6)
CreateDynamicObject(970,-1643.87304688,-168.11599731,13.75800037,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (7)
CreateDynamicObject(970,-1646.73498535,-171.08799744,13.75800037,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (8)
CreateDynamicObject(970,-1649.60998535,-174.05099487,13.75800037,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (9)
CreateDynamicObject(970,-1660.62695312,-151.97500610,13.75800037,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (10)
CreateDynamicObject(970,-1663.48205566,-154.94900513,13.75800037,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (11)
CreateDynamicObject(970,-1666.35095215,-157.91499329,13.75800037,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (12)
CreateDynamicObject(970,-1670.18200684,-157.27600098,13.75800037,0.00000000,0.00000000,135.99975586); //object(fencesmallb) (13)
CreateDynamicObject(970,-1673.05200195,-154.34300232,13.69999981,0.00000000,0.00000000,135.99426270); //object(fencesmallb) (14)
CreateDynamicObject(3852,-1671.86999512,-148.61399841,15.05200005,0.00000000,0.00000000,314.86315918); //object(sf_jump) (1)
CreateDynamicObject(7971,-1674.72497559,-242.34800720,17.96999931,0.00000000,0.00000000,46.00000000); //object(vgnprtlstation03) (1)
CreateDynamicObject(700,-1710.81103516,-209.39500427,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (1)
CreateDynamicObject(700,-1706.84899902,-200.79499817,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (2)
CreateDynamicObject(700,-1701.15405273,-191.32299805,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (3)
CreateDynamicObject(700,-1695.41101074,-183.06399536,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (4)
CreateDynamicObject(700,-1689.60400391,-175.89999390,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (5)
CreateDynamicObject(700,-1678.86499023,-164.47999573,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (6)
CreateDynamicObject(700,-1672.14697266,-157.83799744,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (7)
CreateDynamicObject(10838,-1654.89648438,-199.46972656,26.39599991,0.00000000,0.00000000,315.99975586); //object(airwelcomesign_sfse) (1)
CreateDynamicObject(970,-1668.72094727,-216.04299927,13.69999981,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (15)
CreateDynamicObject(970,-1671.56701660,-219.00700378,13.69999981,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (16)
CreateDynamicObject(970,-1673.07495117,-220.53599548,13.69999981,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (17)
CreateDynamicObject(970,-1670.23803711,-214.65899658,13.69499969,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (18)
CreateDynamicObject(970,-1671.78698730,-216.29100037,13.69999981,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (19)
CreateDynamicObject(970,-1674.28100586,-218.86399841,13.69999981,0.00000000,0.00000000,225.99975586); //object(fencesmallb) (20)
CreateDynamicObject(700,-1669.31604004,-215.13200378,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (12)
CreateDynamicObject(700,-1671.64196777,-217.43400574,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (13)
CreateDynamicObject(700,-1673.47302246,-219.38499451,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (14)
CreateDynamicObject(9527,-1692.35803223,-229.25000000,19.12400055,0.00000000,0.00000000,88.00000000); //object(boigas_sfw01) (1)
CreateDynamicObject(700,-1684.59301758,-170.02099609,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (15)
CreateDynamicObject(16002,-1635.35205078,-188.71600342,13.14799976,0.00000000,0.00000000,0.00000000); //object(drvin_sign) (1)
CreateDynamicObject(700,-1626.25878906,-188.47460938,13.14500046,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (16)
CreateDynamicObject(700,-1614.66198730,-189.50000000,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (17)
CreateDynamicObject(700,-1603.96105957,-189.80599976,13.19299984,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (18)
CreateDynamicObject(700,-1595.18701172,-190.42900085,13.19099998,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (19)
CreateDynamicObject(700,-1587.09375000,-185.54687500,13.20300007,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(18803,-1512.68896484,-20.47900009,12.41100025,0.00000000,0.00000000,44.98999023); //object(mbridge150m1) (1)
CreateDynamicObject(19280,-1560.28295898,-79.05699921,13.21899986,0.00000000,0.00000000,146.00000000); //object(carrooflight1) (1)
CreateDynamicObject(19280,-1570.95605469,-67.73000336,13.21899986,0.00000000,0.00000000,140.00000000); //object(carrooflight1) (2)
CreateDynamicObject(19282,-1660.69104004,-166.49400330,15.10499954,0.00000000,0.00000000,0.00000000); //object(pointlight2) (1)
CreateDynamicObject(19283,-1660.66394043,-166.51899719,14.54599953,0.00000000,0.00000000,0.00000000); //object(pointlight3) (1)
CreateDynamicObject(19284,-1660.67199707,-166.51199341,13.92500019,0.00000000,0.00000000,0.00000000); //object(pointlight4) (1)
CreateDynamicObject(19282,-1658.41394043,-168.69299316,15.13799953,0.00000000,0.00000000,0.00000000); //object(pointlight2) (2)
CreateDynamicObject(19283,-1658.40405273,-168.70199585,14.62100029,0.00000000,0.00000000,0.00000000); //object(pointlight3) (2)
CreateDynamicObject(19284,-1658.43798828,-168.66999817,14.11699963,0.00000000,0.00000000,0.00000000); //object(pointlight4) (2)
CreateDynamicObject(18750,-828.89898682,383.03100586,48.47700119,90.00000000,0.00000000,313.99475098); //object(samplogobig) (1)
CreateDynamicObject(18824,-1627.30102539,-268.99798584,21.60099983,0.00000000,296.00000000,46.00000000); //object(tube50mglass90bend1) (1)
CreateDynamicObject(18824,-1650.36804199,-292.83401489,51.00299835,0.00000000,122.00000000,45.99978638); //object(tube50mglass90bend1) (2)
CreateDynamicObject(18824,-1686.42382812,-314.26562500,58.44969940,90.00000000,0.00000000,93.99902344); //object(tube50mglass90bend1) (3)
CreateDynamicObject(18809,-1697.70703125,-256.42285156,58.41099930,90.00000000,0.00000000,321.99829102); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1667.00585938,-217.12207031,58.37400055,90.00000000,0.00000000,321.99829102); //object(tube50mglass1) (2)
CreateDynamicObject(18809,-1636.44799805,-178.00300598,58.35998917,90.00000000,0.00000000,321.99829102); //object(tube50mglass1) (3)
CreateDynamicObject(970,-1702.46496582,-249.16700745,13.69999981,0.00000000,0.00000000,135.99975586); //object(fencesmallb) (21)
CreateDynamicObject(970,-1699.50805664,-252.04200745,13.69999981,0.00000000,0.00000000,135.99426270); //object(fencesmallb) (22)
CreateDynamicObject(970,-1696.54895020,-254.90299988,13.69499969,0.00000000,0.00000000,135.99426270); //object(fencesmallb) (23)
CreateDynamicObject(970,-1693.60400391,-257.74499512,13.69499969,0.00000000,0.00000000,135.99426270); //object(fencesmallb) (24)
CreateDynamicObject(970,-1690.63403320,-260.62399292,13.69999981,0.00000000,0.00000000,135.99426270); //object(fencesmallb) (25)
CreateDynamicObject(970,-1687.68701172,-263.50100708,13.69999981,0.00000000,0.00000000,135.99426270); //object(fencesmallb) (26)
CreateDynamicObject(970,-1684.73400879,-266.37701416,13.69999981,0.00000000,0.00000000,135.99426270); //object(fencesmallb) (27)
CreateDynamicObject(970,-1681.79101562,-269.24600220,13.69999981,0.00000000,0.00000000,135.99426270); //object(fencesmallb) (28)
CreateDynamicObject(18809,-1606.33007812,-139.46679688,58.38040161,90.00000000,0.00000000,321.99829102); //object(tube50mglass1) (4)
CreateDynamicObject(18809,-1575.81896973,-100.38899994,58.27399826,90.00000000,0.00000000,321.99829102); //object(tube50mglass1) (4)
CreateDynamicObject(18809,-1545.49511719,-61.58000183,58.28299713,90.00000000,0.00000000,321.99829102); //object(tube50mglass1) (4)
CreateDynamicObject(18809,-1515.00000000,-22.53700066,58.28299713,90.00000000,0.00000000,321.99829102); //object(tube50mglass1) (4)
CreateDynamicObject(18809,-1485.12988281,15.70699978,58.26599884,90.00000000,0.00000000,321.99829102); //object(tube50mglass1) (4)
CreateDynamicObject(1415,-1698.02294922,-218.63299561,13.38399982,0.00000000,0.00000000,134.00000000); //object(dyn_dumpster) (1)
CreateDynamicObject(18809,-1454.25988770,55.20800018,58.16350174,90.00000000,0.00000000,321.99829102); //object(tube50mglass1) (4)
CreateDynamicObject(18824,-1419.16699219,83.30664062,58.09700012,90.00000000,0.00000000,281.99707031); //object(tube50mglass90bend1) (3)
CreateDynamicObject(18809,-1375.30664062,70.62792969,58.11500168,90.00000000,0.00000000,239.99633789); //object(tube50mglass1) (1)
CreateDynamicObject(10765,-1200.31396484,20.79800034,13.14799976,0.00000000,0.00000000,0.00000000); //object(skidmarks_sfse) (1)
CreateDynamicObject(18809,-1332.08203125,45.59960938,58.09400177,90.00000000,0.00000000,239.99084473); //object(tube50mglass1) (1)
CreateDynamicObject(18824,-1298.51904297,13.48600006,58.09999847,90.00000000,0.00000000,197.99707031); //object(tube50mglass90bend1) (3)
CreateDynamicObject(7520,-1239.91699219,-30.39100075,13.14799976,0.00000000,0.00000000,136.00000000); //object(vgnlowbuild203) (1)
CreateDynamicObject(19129,-1660.15820312,-221.65039062,13.21100044,0.00000000,0.00000000,315.99975586); //object(dancefloor2) (1)
CreateDynamicObject(19129,-1646.33898926,-207.35499573,13.21100044,0.00000000,0.00000000,315.99975586); //object(dancefloor2) (2)
CreateDynamicObject(19129,-1632.41394043,-193.07600403,13.21100044,0.00000000,0.00000000,315.99975586); //object(dancefloor2) (3)
CreateDynamicObject(700,-1156.73803711,29.96500015,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1167.18994141,20.59600067,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1174.67797852,12.53299999,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1183.35095215,3.66100001,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1192.13000488,-5.60099983,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1203.45996094,-16.61899948,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1212.34704590,-25.40099907,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1192.83801270,67.27700043,13.14099979,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1200.41601562,74.70200348,13.14099979,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1208.57995605,83.14399719,13.14099979,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1216.59301758,91.39499664,13.14099979,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1224.84497070,99.83100128,13.14099979,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1232.30395508,107.11599731,13.14099979,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1238.65295410,113.40599823,13.14099979,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1244.60351562,119.79687500,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(9132,-1205.11999512,69.69899750,32.25500107,0.00000000,0.00000000,171.99951172); //object(triadcasign_lvs) (1)
CreateDynamicObject(18809,-1309.08996582,-30.96400070,58.09989929,90.00000000,0.00000000,149.99633789); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1334.05700684,-74.15699768,58.04399872,90.00000000,0.00000000,149.99087524); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1358.60644531,-116.49804688,58.11299896,90.00000000,0.00000000,149.99087524); //object(tube50mglass1) (1)
CreateDynamicObject(5033,-1302.30273438,-58.94824219,26.73500061,0.00000000,0.00000000,45.99975586); //object(unmainstat_las) (1)
CreateDynamicObject(18803,-1522.31799316,-96.26200104,27.76899910,0.00000000,20.00000000,334.00000000); //object(mbridge150m1) (2)
CreateDynamicObject(18789,-1652.71191406,-32.64599991,53.28699875,0.00000000,0.00000000,334.00000000); //object(mroad150m) (1)
CreateDynamicObject(18800,-1751.51293945,-9.84399986,41.19998932,0.00000000,0.00000000,154.00000000); //object(mroadhelix1) (2)
CreateDynamicObject(18800,-1737.96704102,-66.90200043,41.34400177,0.00000000,0.00000000,333.99536133); //object(mroadhelix1) (4)
CreateDynamicObject(18800,-1805.19299316,-84.99099731,41.37300110,0.00000000,0.00000000,153.98986816); //object(mroadhelix1) (5)
CreateDynamicObject(18800,-1786.29980469,-144.41000366,41.30099869,0.00000000,0.00000000,333.98437500); //object(mroadhelix1) (6)
CreateDynamicObject(18800,-1837.24401855,-119.86100006,64.79998779,0.00000000,0.00000000,153.97888184); //object(mroadhelix1) (7)
CreateDynamicObject(18789,-1748.10998535,-137.79499817,76.91799927,0.00000000,0.00000000,333.99536133); //object(mroad150m) (5)
CreateDynamicObject(18789,-1614.55895996,-202.97300720,76.90999603,0.00000000,0.00000000,333.99536133); //object(mroad150m) (6)
CreateDynamicObject(18800,-1515.37304688,-226.10000610,64.73899841,0.00000000,0.00000000,333.97888184); //object(mroadhelix1) (8)
CreateDynamicObject(18800,-1561.41198730,-203.94900513,41.13399887,0.00000000,0.00000000,153.97888184); //object(mroadhelix1) (9)
CreateDynamicObject(18789,-1493.17199707,-262.43499756,29.72299957,0.00000000,0.00000000,333.99536133); //object(mroad150m) (7)
CreateDynamicObject(18789,-1375.66894531,-319.71679688,29.71800041,0.00000000,0.00000000,333.98986816); //object(mroad150m) (8)
CreateDynamicObject(18789,-1270.65405273,-370.87500000,29.85199928,0.00000000,0.00000000,333.99536133); //object(mroad150m) (9)
CreateDynamicObject(18800,-1182.94396973,-388.26199341,17.64900017,0.00000000,0.00000000,333.97888184); //object(mroadhelix1) (11)
CreateDynamicObject(700,-1247.71997070,14.97399998,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1242.41894531,20.11899948,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1237.20104980,26.04199982,13.14799976,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(10838,-1174.14001465,48.48199844,29.70100021,0.00000000,0.00000000,43.99975586); //object(airwelcomesign_sfse) (1)
CreateDynamicObject(978,-1158.64794922,32.79600143,13.98900032,0.00000000,0.00000000,134.99450684); //object(sub_roadright) (1)
CreateDynamicObject(978,-1189.94201660,66.33599854,13.98200035,0.00000000,0.00000000,134.98904419); //object(sub_roadright) (2)
CreateDynamicObject(978,-1196.53698730,72.94599915,13.98200035,0.00000000,0.00000000,134.98904419); //object(sub_roadright) (3)
CreateDynamicObject(978,-1203.05798340,79.46399689,13.98200035,0.00000000,0.00000000,134.98904419); //object(sub_roadright) (4)
CreateDynamicObject(978,-1209.43798828,85.84999847,13.98200035,0.00000000,0.00000000,134.98904419); //object(sub_roadright) (5)
CreateDynamicObject(978,-1215.98400879,92.40299988,13.98200035,0.00000000,0.00000000,134.98904419); //object(sub_roadright) (6)
CreateDynamicObject(978,-1222.61901855,99.02600098,13.98200035,0.00000000,0.00000000,134.98904419); //object(sub_roadright) (7)
CreateDynamicObject(978,-1229.24694824,105.66200256,13.98200035,0.00000000,0.00000000,134.98904419); //object(sub_roadright) (8)
CreateDynamicObject(978,-1235.87402344,112.30400085,13.98200035,0.00000000,0.00000000,134.98904419); //object(sub_roadright) (9)
CreateDynamicObject(978,-1242.47204590,112.39399719,13.97799969,0.00000000,0.00000000,224.98901367); //object(sub_roadright) (10)
CreateDynamicObject(978,-1245.90600586,108.95200348,13.98200035,0.00000000,0.00000000,224.98901367); //object(sub_roadright) (11)
CreateDynamicObject(18789,-1112.96997070,94.27100372,12.72000027,0.00000000,0.00000000,43.98986816); //object(mroad150m) (8)
CreateDynamicObject(18789,-1126.15295410,107.66799927,12.74600029,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(18789,-1007.13201904,196.39300537,12.70300007,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(18809,-1383.58605957,-159.68699646,58.09998703,90.00000000,0.00000000,149.99087524); //object(tube50mglass1) (1)
CreateDynamicObject(18789,-1018.56097412,211.51100159,12.81980038,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(18789,-900.05798340,299.73699951,12.69939995,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(18789,-914.50500488,311.90301514,12.81500053,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(18789,-807.37500000,389.23199463,12.67099953,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(18789,-815.70300293,407.29598999,12.79909992,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(18789,-712.86798096,506.64001465,12.95899963,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(18789,-700.02697754,492.68798828,12.68400002,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(10765,2073.46899414,842.92700195,5.79600000,0.00000000,0.00000000,134.00000000); //object(skidmarks_sfse) (2)
CreateDynamicObject(18789,-639.76702881,550.78302002,12.63599968,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(18789,-652.98699951,564.46600342,12.96199989,0.00000000,0.00000000,43.98925781); //object(mroad150m) (8)
CreateDynamicObject(1655,-602.82000732,613.42797852,14.60599995,0.00000000,0.00000000,314.00000000); //object(waterjumpx2) (1)
CreateDynamicObject(1655,-588.52600098,599.48400879,14.27999973,0.00000000,0.00000000,313.99475098); //object(waterjumpx2) (2)
CreateDynamicObject(18809,-1405.72094727,-198.01499939,58.07400131,90.00000000,0.00000000,149.99087524); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1430.28796387,-240.44000244,58.10599899,90.00000000,0.00000000,149.99087524); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1455.34204102,-283.82800293,58.06900024,90.00000000,0.00000000,149.99087524); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1480.26000977,-326.97601318,58.11119843,90.00000000,0.00000000,149.99087524); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1504.88098145,-369.56298828,58.08499908,90.00000000,0.00000000,149.99087524); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1529.64794922,-412.40200806,58.01699829,90.00000000,0.00000000,149.99087524); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1713.61901855,-367.92098999,58.20999908,90.00000000,0.00000000,237.99633789); //object(tube50mglass1) (1)
CreateDynamicObject(18824,-1561.24609375,-446.41992188,58.05899811,90.00000000,0.00000000,109.98962402); //object(tube50mglass90bend1) (3)
CreateDynamicObject(18809,-1604.92297363,-435.93399048,57.95500183,90.00000000,0.00000000,237.99084473); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1647.17797852,-409.37600708,58.00000000,90.00000000,0.00000000,237.98535156); //object(tube50mglass1) (1)
CreateDynamicObject(18809,-1689.03503418,-383.19000244,58.00000000,90.00000000,0.00000000,237.98535156); //object(tube50mglass1) (1)
CreateDynamicObject(18824,-1742.48803711,-334.40399170,58.24000168,90.00000000,0.00000000,9.99902344); //object(tube50mglass90bend1) (3)
CreateDynamicObject(700,-1074.39196777,387.74301147,13.54699993,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1068.84497070,393.14199829,13.54699993,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1062.21203613,399.70199585,13.54699993,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1059.64294434,409.09500122,13.53999996,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1068.78796387,418.54901123,13.53999996,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1080.71801758,429.29998779,13.53999996,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1087.67602539,434.77099609,13.54599953,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1094.42797852,431.11300659,13.54699993,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1101.54699707,423.31698608,13.54699993,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(700,-1106.59594727,417.88500977,13.54699993,0.00000000,0.00000000,0.00000000); //object(sm_veg_tree6) (20)
CreateDynamicObject(982,-1713.46386719,-238.59863281,19.14122963,0.00000000,0.00000000,0.00000000); //object(fenceshit) (1)
CreateDynamicObject(8229,-1102.32995605,424.02801514,16.24799919,0.00000000,0.00000000,44.00000000); //object(vgsbikeschl02) (1)
CreateDynamicObject(8229,-1093.93103027,432.08898926,16.24799919,0.00000000,0.00000000,43.99475098); //object(vgsbikeschl02) (2)
CreateDynamicObject(8229,-1078.14001465,431.97399902,16.24099922,0.00000000,0.00000000,315.99475098); //object(vgsbikeschl02) (3)
CreateDynamicObject(8229,-1069.96398926,423.89498901,16.24099922,0.00000000,0.00000000,315.99426270); //object(vgsbikeschl02) (4)
CreateDynamicObject(8229,-1058.55798340,412.84201050,16.24099922,0.00000000,0.00000000,315.99426270); //object(vgsbikeschl02) (5)
CreateDynamicObject(8229,-1058.83496094,397.76699829,16.04000092,0.00000000,0.00000000,223.99426270); //object(vgsbikeschl02) (6)
CreateDynamicObject(8229,-1074.70898438,382.40798950,16.09499931,0.00000000,0.00000000,223.98925781); //object(vgsbikeschl02) (7)
CreateDynamicObject(5817,-1698.44995117,-217.04899597,15.76599979,0.00000000,0.00000000,43.99804688); //object(odrampbit01) (2)
CreateDynamicObject(984,-1174.45300293,49.71900177,13.78499985,90.00000000,0.00000000,44.00000000); //object(fenceshit2) (1)
CreateDynamicObject(984,-1173.58801270,48.78799820,13.78499985,90.00000000,0.00000000,43.99475098); //object(fenceshit2) (2)
CreateDynamicObject(984,-1172.72705078,47.90399933,13.78499985,90.00000000,0.00000000,43.99475098); //object(fenceshit2) (3)
CreateDynamicObject(1262,-1173.55200195,48.65299988,17.27599907,0.00000000,0.00000000,136.00000000); //object(mtraffic4) (1)
CreateDynamicObject(18818,-1722.16394043,-300.38500977,58.37600327,90.00000000,0.00000000,232.00000000); //object(tube50mglasst1) (1)
//городок=======================================================================
CreateDynamicObject(6991,-129.55000000,-1706.53000000,1.55000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(3749,-129.60000000,-1766.95000000,6.97000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(11245,-119.90000000,-1764.45000000,8.36000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-120.64000000,-1764.45000000,8.33000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-121.24000000,-1764.45000000,8.31000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-121.87000000,-1764.45000000,8.28000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-122.48000000,-1764.45000000,8.26000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-123.09000000,-1764.45000000,8.23000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-123.72000000,-1764.45000000,8.21000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-135.28000000,-1764.45000000,8.32000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-135.72000000,-1764.45000000,8.33000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-136.06000000,-1764.45000000,8.28000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-136.63000000,-1764.45000000,8.28000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-137.17000000,-1764.45000000,8.33000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-137.73000000,-1764.45000000,8.34000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-138.37000000,-1764.45000000,8.28000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-138.89000000,-1764.45000000,8.30000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(11245,-139.35000000,-1764.45000000,8.30000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(17596,-129.55000000,-1814.86000000,1.49000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(17598,-91.22000000,-1885.83000000,1.38000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(17599,-38.59000000,-1926.63000000,1.38000000,359.84000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-2.97000000,-1886.61000000,1.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-3.14000000,-1926.56000000,1.30000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6257,3.15000000,-1892.71000000,8.62000000,0.00000000,0.00000000,179.99000000); //
CreateDynamicObject(1561,-5.66000000,-1895.75000000,1.32000000,0.00000000,0.00000000,270.00000000); //
CreateDynamicObject(6959,-42.80000000,-1997.28000000,1.44000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-1.46000000,-1997.21000000,1.44000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3314,3.32000000,-2038.87000000,2.38000000,0.00000000,0.00000000,180.00000000); //
CreateDynamicObject(738,-80.34000000,-1933.59000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-80.40000000,-1931.09000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3314,-21.69000000,-2038.89000000,2.38000000,0.00000000,0.00000000,179.99000000); //
CreateDynamicObject(3314,-46.64000000,-2038.89000000,2.38000000,0.00000000,0.00000000,179.99000000); //
CreateDynamicObject(738,-80.38000000,-1928.18000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-80.38000000,-1928.18000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-75.10000000,-1933.52000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-70.20000000,-1933.63000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-53.60000000,-1954.17000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-61.76000000,-1933.46000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-57.86000000,-1933.39000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3599,-8.05000000,-1926.01000000,7.22000000,0.00000000,0.00000000,270.00000000); //
CreateDynamicObject(6959,-42.72000000,-2037.26000000,1.44000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(970,-1.05000000,-1933.94000000,8.82000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(970,-1.07000000,-1929.83000000,8.82000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-1.35000000,-2037.21000000,1.44000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(970,0.98000000,-1931.85000000,8.82000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(6959,39.30000000,-1996.97000000,1.44000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,38.99000000,-2036.96000000,1.44000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(970,-11.49000000,-1921.18000000,8.82000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(970,-11.53000000,-1913.67000000,5.32000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(970,-13.57000000,-1923.27000000,8.82000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(3314,28.24000000,-2038.94000000,2.38000000,0.00000000,0.00000000,179.99000000); //
CreateDynamicObject(970,-13.60000000,-1927.41000000,8.82000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(970,-13.60000000,-1928.24000000,5.32000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(970,-13.57000000,-1915.75000000,5.32000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(970,-13.58000000,-1919.92000000,5.32000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(970,-13.61000000,-1924.07000000,5.32000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(6959,-62.44000000,-1914.05000000,1.30000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(970,-15.87000000,-1936.31000000,5.32000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(8572,-14.33000000,-1939.41000000,3.49000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(979,-136.84000000,-1901.65000000,2.43000000,0.00000000,0.00000000,272.25000000); //
CreateDynamicObject(979,-137.18000000,-1892.35000000,2.23000000,0.00000000,359.75000000,272.25000000); //
CreateDynamicObject(1504,-11.41000000,-1936.74000000,4.78000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,-138.35000000,-1883.17000000,2.23000000,0.00000000,359.75000000,284.74000000); //
CreateDynamicObject(979,-139.25000000,-1873.97000000,2.23000000,0.00000000,359.75000000,268.49000000); //
CreateDynamicObject(979,-139.01000000,-1864.68000000,2.23000000,0.00000000,359.75000000,268.49000000); //
CreateDynamicObject(979,-138.62000000,-1855.34000000,2.23000000,0.00000000,359.75000000,268.49000000); //
CreateDynamicObject(979,-138.64000000,-1846.03000000,2.23000000,0.00000000,359.75000000,271.24000000); //
CreateDynamicObject(8948,-11.43000000,-1919.58000000,2.79000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-25.64000000,-1897.70000000,1.38000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-25.66000000,-1903.80000000,1.40000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-25.95000000,-1911.78000000,1.42000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-25.82000000,-1923.88000000,1.45000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-25.58000000,-1930.03000000,1.47000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-25.45000000,-1936.31000000,1.49000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-25.45000000,-1941.43000000,1.50000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-26.20000000,-1946.83000000,1.51000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-99.34000000,-1855.96000000,1.53000000,0.00000000,0.25000000,0.00000000); //
CreateDynamicObject(6959,-58.12000000,-1856.01000000,1.47000000,0.25000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-16.95000000,-1856.09000000,1.47000000,0.25000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-99.21000000,-1816.69000000,1.54000000,0.00000000,0.25000000,0.00000000); //
CreateDynamicObject(6959,-99.27000000,-1776.75000000,1.54000000,0.00000000,0.25000000,0.00000000); //
CreateDynamicObject(6959,-159.91000000,-1821.00000000,1.61000000,0.00000000,0.25000000,0.00000000); //
CreateDynamicObject(979,-138.94000000,-1772.97000000,2.41000000,0.00000000,359.75000000,271.24000000); //
CreateDynamicObject(979,-138.87000000,-1782.27000000,2.41000000,0.00000000,359.75000000,271.24000000); //
CreateDynamicObject(979,-138.68000000,-1791.60000000,2.41000000,0.00000000,359.75000000,271.24000000); //
CreateDynamicObject(6959,-116.63000000,-1912.42000000,1.30000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-94.57000000,-1913.88000000,1.30000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3443,-121.97000000,-1916.79000000,4.14000000,0.00000000,0.00000000,180.00000000); //
CreateDynamicObject(3454,-169.17000000,-1819.89000000,5.72000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(3454,-150.43000000,-1820.28000000,5.75000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(973,-138.75000000,-1760.32000000,2.57000000,0.00000000,3.50000000,270.00000000); //
CreateDynamicObject(973,-138.75000000,-1750.98000000,3.23000000,0.00000000,4.25000000,270.00000000); //
CreateDynamicObject(973,-119.94000000,-1760.20000000,2.58000000,0.00000000,355.75000000,90.00000000); //
CreateDynamicObject(979,-144.05000000,-1840.53000000,2.33000000,4.00000000,357.74000000,1.14000000); //
CreateDynamicObject(973,-119.94000000,-1751.16000000,3.22000000,0.00000000,355.75000000,90.00000000); //
CreateDynamicObject(973,-139.34000000,-1661.85000000,3.23000000,0.00000000,356.00000000,270.00000000); //
CreateDynamicObject(973,-139.34000000,-1652.58000000,2.58000000,0.00000000,356.00000000,270.00000000); //
CreateDynamicObject(973,-139.22000000,-1643.35000000,2.54000000,0.00000000,2.50000000,270.00000000); //
CreateDynamicObject(973,-120.07000000,-1653.44000000,2.65000000,0.00000000,4.00000000,91.00000000); //
CreateDynamicObject(973,-67.71000000,-2020.38000000,2.33000000,0.00000000,5.75000000,359.50000000); //
CreateDynamicObject(973,-120.30000000,-1644.29000000,2.54000000,0.00000000,358.00000000,91.00000000); //
CreateDynamicObject(3445,45.97000000,-2042.70000000,4.43000000,0.00000000,0.00000000,180.00000000); //
CreateDynamicObject(3446,50.75000000,-1991.27000000,4.94000000,0.00000000,0.50000000,0.25000000); //
CreateDynamicObject(3445,-32.52000000,-1861.59000000,4.44000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3446,-50.75000000,-1861.60000000,4.86000000,0.25000000,0.00000000,0.00000000); //
CreateDynamicObject(3445,32.53000000,-1991.70000000,4.46000000,0.00000000,0.00000000,0.25000000); //
CreateDynamicObject(3446,13.58000000,-1989.94000000,4.80000000,358.75000000,0.00000000,0.00000000); //
CreateDynamicObject(8838,-80.09000000,-1980.03000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(8838,-80.09000000,-1985.14000000,-0.14000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3449,-9.59000000,-1988.65000000,2.87000000,0.00000000,0.00000000,180.00000000); //
CreateDynamicObject(6959,-62.87000000,-1953.93000000,1.30000000,0.00000000,0.25000000,0.00000000); //
CreateDynamicObject(1215,-63.58000000,-1987.58000000,1.96000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1215,-63.60000000,-1977.61000000,1.96000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1215,-96.56000000,-1977.81000000,1.96000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1215,-96.52000000,-1987.51000000,1.96000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(5812,-105.10000000,-1828.88000000,1.79000000,0.00000000,0.10000000,0.00000000); //
CreateDynamicObject(645,-103.70000000,-1807.05000000,2.37000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(645,-104.18000000,-1815.43000000,2.38000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(645,-104.03000000,-1823.53000000,2.38000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(645,-104.09000000,-1831.82000000,2.38000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(645,-104.39000000,-1838.77000000,2.39000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(645,-104.41000000,-1844.60000000,2.39000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(645,-104.33000000,-1851.86000000,2.39000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-113.53000000,-1800.68000000,1.74000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-113.63000000,-1812.25000000,1.75000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-113.42000000,-1823.10000000,1.75000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-113.05000000,-1833.57000000,1.75000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-112.35000000,-1841.29000000,1.76000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-112.26000000,-1849.11000000,1.75000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-112.62000000,-1857.89000000,1.73000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-112.40000000,-1864.48000000,1.66000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-105.00000000,-1865.10000000,1.62000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-96.89000000,-1865.52000000,1.58000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6991,-109.91000000,-2010.81000000,0.72000000,0.00000000,0.00000000,180.00000000); //
CreateDynamicObject(669,-96.14000000,-1858.08000000,1.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-95.49000000,-1849.84000000,1.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-95.48000000,-1840.63000000,1.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-95.64000000,-1832.10000000,1.59000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-95.65000000,-1823.70000000,1.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-95.82000000,-1816.15000000,1.59000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-95.86000000,-1807.65000000,1.59000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-95.72000000,-1799.17000000,1.58000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-95.73000000,-1793.46000000,1.58000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-105.60000000,-1792.89000000,1.69000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(669,-115.06000000,-1792.06000000,1.74000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(5120,-150.02000000,-2059.51000000,0.38000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-104.90000000,-2127.26000000,0.38000000,0.00000000,0.00000000,225.00000000); //
CreateDynamicObject(7419,-59.88000000,-2133.01000000,-6.06000000,0.00000000,0.00000000,315.00000000); //
CreateDynamicObject(6959,-48.57000000,-2183.85000000,0.35000000,0.00000000,0.00000000,225.00000000); //
CreateDynamicObject(6959,-76.83000000,-2155.53000000,0.36000000,0.00000000,0.00000000,225.00000000); //
CreateDynamicObject(6296,-61.20000000,-1961.48000000,3.51000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(738,-54.51000000,-1970.35000000,2.02000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(8131,-56.47000000,-1941.91000000,11.94000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-57.78000000,-1942.65000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-57.42000000,-1940.72000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-19.51000000,-2154.68000000,0.38000000,0.00000000,0.00000000,225.00000000); //
CreateDynamicObject(870,-57.42000000,-1940.72000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-55.52000000,-1940.76000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-55.27000000,-1943.13000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-56.55000000,-1942.33000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-57.96000000,-1943.33000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-58.06000000,-1940.34000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-55.48000000,-1940.46000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-55.09000000,-1941.72000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(870,-56.36000000,-1942.14000000,1.99000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6959,-47.81000000,-2126.45000000,0.38000000,0.00000000,0.00000000,225.00000000); //
CreateDynamicObject(6959,-75.90000000,-2098.62000000,0.38000000,0.00000000,0.00000000,225.00000000); //
CreateDynamicObject(979,-153.08000000,-1840.73000000,2.33000000,3.99000000,357.74000000,1.14000000); //
CreateDynamicObject(979,-161.86000000,-1840.75000000,2.33000000,3.99000000,357.74000000,359.14000000); //
CreateDynamicObject(979,-170.99000000,-1840.62000000,2.33000000,3.99000000,357.73000000,359.14000000); //
CreateDynamicObject(979,-175.96000000,-1840.59000000,2.33000000,3.99000000,357.73000000,359.14000000); //
CreateDynamicObject(9241,-75.20000000,-1859.98000000,3.08000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(11677,-122.58000000,-1780.61000000,6.44000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(17064,-108.03000000,-1765.58000000,1.55000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(17065,-86.73000000,-1763.75000000,5.77000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1676,-93.16000000,-1768.60000000,3.48000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1676,-81.00000000,-1768.47000000,3.54000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1676,-80.72000000,-1761.17000000,3.30000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1676,-93.03000000,-1761.07000000,3.40000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(982,-78.79000000,-1769.72000000,2.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(982,-78.82000000,-1795.32000000,2.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(982,-78.94000000,-1820.89000000,2.10000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(982,-91.65000000,-1756.85000000,2.16000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(983,-107.70000000,-1756.76000000,2.23000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,-180.14000000,-1835.77000000,2.41000000,3.99000000,359.74000000,269.00000000); //
CreateDynamicObject(983,-114.09000000,-1756.79000000,2.26000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(1280,-79.32000000,-1780.11000000,1.82000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(979,-180.03000000,-1826.66000000,2.41000000,3.99000000,359.73000000,268.99000000); //
CreateDynamicObject(1280,-79.29000000,-1789.88000000,1.82000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1280,-79.27000000,-1797.84000000,1.82000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1280,-79.29000000,-1807.54000000,1.82000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1280,-79.32000000,-1817.17000000,1.82000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1280,-79.59000000,-1825.56000000,1.83000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3443,-8.22000000,-1862.95000000,4.29000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(979,-179.88000000,-1818.09000000,2.41000000,3.99000000,359.73000000,268.99000000); //
CreateDynamicObject(979,-179.74000000,-1809.23000000,2.41000000,3.99000000,359.73000000,268.99000000); //
CreateDynamicObject(979,-179.67000000,-1805.71000000,2.41000000,3.99000000,359.73000000,268.99000000); //
CreateDynamicObject(979,-175.05000000,-1801.11000000,2.41000000,3.99000000,359.73000000,178.99000000); //
CreateDynamicObject(3486,-57.72000000,-1913.43000000,8.23000000,0.00000000,0.00000000,180.00000000); //
CreateDynamicObject(979,-166.11000000,-1801.30000000,2.41000000,3.99000000,359.73000000,178.99000000); //
CreateDynamicObject(979,-152.29000000,-1801.40000000,2.41000000,3.99000000,359.73000000,179.99000000); //
CreateDynamicObject(979,-143.45000000,-1801.45000000,2.41000000,3.99000000,359.73000000,178.99000000); //
CreateDynamicObject(979,-159.57000000,-1801.29000000,2.41000000,3.99000000,359.73000000,178.99000000); //
CreateDynamicObject(979,-138.59000000,-1797.15000000,2.41000000,0.00000000,359.75000000,271.24000000); //
CreateDynamicObject(979,-102.26000000,-1932.64000000,1.92000000,0.00000000,359.75000000,179.24000000); //
CreateDynamicObject(979,-92.91000000,-1932.89000000,1.92000000,0.00000000,359.75000000,179.23000000); //
CreateDynamicObject(3588,-89.56000000,-1914.11000000,3.88000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(979,-87.18000000,-1932.96000000,1.92000000,0.00000000,359.75000000,179.23000000); //
CreateDynamicObject(979,-83.01000000,-1937.63000000,2.17000000,0.00000000,359.75000000,269.23000000); //
CreateDynamicObject(979,-83.13000000,-1946.76000000,2.17000000,0.00000000,359.75000000,269.23000000); //
CreateDynamicObject(979,-83.29000000,-1955.70000000,2.17000000,0.00000000,359.75000000,269.23000000); //
CreateDynamicObject(979,-83.40000000,-1965.00000000,2.17000000,0.00000000,359.75000000,269.23000000); //
CreateDynamicObject(979,-83.45000000,-1969.00000000,2.17000000,0.00000000,359.75000000,269.23000000); //
CreateDynamicObject(979,-78.92000000,-1973.46000000,2.17000000,0.00000000,359.75000000,1.23000000); //
CreateDynamicObject(979,-70.87000000,-1973.24000000,2.17000000,0.00000000,359.75000000,1.22000000); //
CreateDynamicObject(979,-61.95000000,-1973.01000000,2.17000000,0.00000000,359.75000000,1.22000000); //
CreateDynamicObject(979,-58.40000000,-1972.97000000,2.17000000,0.00000000,359.75000000,1.22000000); //
CreateDynamicObject(979,-53.50000000,-1974.35000000,2.17000000,0.00000000,359.75000000,269.22000000); //
CreateDynamicObject(979,-58.45000000,-1977.68000000,2.17000000,0.00000000,359.75000000,179.22000000); //
CreateDynamicObject(979,-29.47000000,-1977.37000000,2.25000000,0.00000000,359.75000000,179.23000000); //
CreateDynamicObject(979,-33.71000000,-1973.07000000,2.16000000,0.00000000,0.00000000,82.00000000); //
CreateDynamicObject(973,-119.98000000,-1662.58000000,3.29000000,0.00000000,4.00000000,90.99000000); //
CreateDynamicObject(979,-31.41000000,-1964.09000000,2.41000000,0.00000000,0.00000000,67.25000000); //
CreateDynamicObject(973,-67.40000000,-2001.20000000,2.36000000,0.00000000,356.25000000,180.24000000); //
CreateDynamicObject(979,-27.79000000,-1955.47000000,2.38000000,0.00000000,0.00000000,67.24000000); //
CreateDynamicObject(973,-154.33000000,-2001.64000000,2.46000000,357.26000000,4.00000000,182.68000000); //
CreateDynamicObject(979,-25.31000000,-1946.68000000,2.35000000,0.00000000,0.00000000,82.00000000); //
CreateDynamicObject(973,-163.17000000,-2001.97000000,1.86000000,0.00000000,3.75000000,182.49000000); //
CreateDynamicObject(979,-20.65000000,-1946.25000000,2.11000000,0.00000000,359.75000000,1.22000000); //
CreateDynamicObject(979,-11.27000000,-1946.14000000,2.11000000,0.00000000,359.75000000,1.22000000); //
CreateDynamicObject(979,-2.06000000,-1945.97000000,2.11000000,0.00000000,359.75000000,1.22000000); //
CreateDynamicObject(979,7.17000000,-1945.78000000,2.11000000,0.00000000,359.75000000,1.22000000); //
CreateDynamicObject(979,11.86000000,-1940.98000000,2.11000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,11.85000000,-1931.61000000,2.11000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,11.86000000,-1922.27000000,2.11000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,11.86000000,-1912.90000000,2.11000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,11.86000000,-1903.57000000,2.11000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,12.06000000,-1883.35000000,2.03000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,12.05000000,-1873.99000000,2.03000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,7.31000000,-1869.32000000,2.03000000,0.00000000,359.75000000,179.22000000); //
CreateDynamicObject(982,-66.15000000,-1836.35000000,2.21000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(982,-40.56000000,-1836.35000000,2.21000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(982,-15.00000000,-1836.39000000,2.20000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(973,-154.52000000,-2020.72000000,2.51000000,0.00000000,356.00000000,0.24000000); //
CreateDynamicObject(973,-163.88000000,-2020.68000000,1.93000000,356.01000000,356.49000000,359.99000000); //
CreateDynamicObject(983,-0.51000000,-1836.36000000,2.20000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(983,2.65000000,-1839.54000000,2.20000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(979,54.85000000,-2056.88000000,2.25000000,0.00000000,359.75000000,1.22000000); //
CreateDynamicObject(979,59.57000000,-2051.83000000,2.25000000,0.00000000,359.75000000,91.22000000); //
CreateDynamicObject(983,2.63000000,-1843.92000000,2.20000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(979,59.66000000,-2043.40000000,2.25000000,0.00000000,359.75000000,85.96000000); //
CreateDynamicObject(979,59.81000000,-2034.83000000,2.25000000,0.00000000,359.75000000,91.21000000); //
CreateDynamicObject(979,59.72000000,-2026.70000000,2.25000000,0.00000000,359.75000000,91.21000000); //
CreateDynamicObject(979,59.53000000,-2017.75000000,2.25000000,0.00000000,359.75000000,91.21000000); //
CreateDynamicObject(979,59.71000000,-2009.54000000,2.25000000,0.00000000,359.75000000,85.21000000); //
CreateDynamicObject(979,-189.45000000,-2004.38000000,1.35000000,0.00000000,0.00000000,270.00000000); //
CreateDynamicObject(979,-170.16000000,-2024.63000000,1.35000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,-189.44000000,-2013.72000000,1.35000000,0.00000000,0.00000000,269.99000000); //
CreateDynamicObject(979,-189.47000000,-2023.05000000,1.35000000,0.00000000,0.00000000,269.99000000); //
CreateDynamicObject(979,-189.45000000,-2032.37000000,1.35000000,0.00000000,0.00000000,269.99000000); //
CreateDynamicObject(979,-188.53000000,-2041.66000000,1.35000000,0.00000000,0.00000000,281.99000000); //
CreateDynamicObject(979,-185.68000000,-2050.49000000,1.35000000,0.00000000,0.00000000,293.99000000); //
CreateDynamicObject(979,-181.14000000,-2058.64000000,1.35000000,0.00000000,0.00000000,303.99000000); //
CreateDynamicObject(979,-175.22000000,-2065.84000000,1.35000000,0.00000000,0.00000000,314.49000000); //
CreateDynamicObject(979,-184.29000000,-2001.15000000,1.35000000,0.00000000,0.00000000,179.99000000); //
CreateDynamicObject(979,-175.01000000,-2001.18000000,1.35000000,0.00000000,0.00000000,179.99000000); //
CreateDynamicObject(979,-168.67000000,-2072.51000000,1.35000000,0.00000000,0.00000000,314.48000000); //
CreateDynamicObject(979,-162.14000000,-2079.19000000,1.35000000,0.00000000,0.00000000,314.48000000); //
CreateDynamicObject(979,-155.58000000,-2085.88000000,1.35000000,0.00000000,0.00000000,314.48000000); //
CreateDynamicObject(979,-149.09000000,-2092.49000000,1.35000000,0.00000000,0.00000000,314.48000000); //
CreateDynamicObject(979,-142.51000000,-2099.16000000,1.35000000,0.00000000,0.00000000,314.48000000); //
CreateDynamicObject(979,-135.96000000,-2105.85000000,1.35000000,0.00000000,0.00000000,314.48000000); //
CreateDynamicObject(979,-129.40000000,-2112.54000000,1.35000000,0.00000000,0.00000000,314.48000000); //
CreateDynamicObject(979,-124.47000000,-2117.60000000,1.35000000,0.00000000,0.00000000,314.48000000); //
CreateDynamicObject(979,-170.16000000,-2034.00000000,1.35000000,0.00000000,0.00000000,90.00000000); //
CreateDynamicObject(979,-168.41000000,-2042.96000000,1.35000000,0.00000000,0.00000000,112.25000000); //
CreateDynamicObject(979,-164.12000000,-2051.10000000,1.35000000,0.00000000,0.00000000,124.25000000); //
CreateDynamicObject(979,-158.18000000,-2058.25000000,1.35000000,0.00000000,0.00000000,135.24000000); //
CreateDynamicObject(979,-151.52000000,-2064.82000000,1.35000000,0.00000000,0.00000000,135.24000000); //
CreateDynamicObject(979,-144.83000000,-2071.38000000,1.35000000,0.00000000,0.00000000,135.24000000); //
CreateDynamicObject(979,-138.15000000,-2077.92000000,1.34000000,0.00000000,0.00000000,135.24000000); //
CreateDynamicObject(979,-131.50000000,-2084.51000000,1.34000000,0.00000000,0.00000000,135.24000000); //
CreateDynamicObject(979,-124.85000000,-2091.08000000,1.34000000,0.00000000,0.00000000,135.24000000); //
CreateDynamicObject(979,-118.24000000,-2097.65000000,1.34000000,0.00000000,0.00000000,135.24000000); //
CreateDynamicObject(979,-111.60000000,-2104.27000000,1.35000000,0.00000000,0.00000000,135.24000000); //
CreateDynamicObject(979,-106.63000000,-2109.01000000,1.18000000,0.00000000,0.00000000,135.24000000); //
CreateDynamicObject(979,-120.11000000,-2125.51000000,1.18000000,0.00000000,0.00000000,286.98000000); //
//-------------------------------------Заброшка---------------------------------
CreateDynamicObject(18858,203.38000000,2523.75000000,24.41000000,0.00000000,0.00000000,90.36000000); //
CreateDynamicObject(18858,203.29000000,2509.42000000,24.34000000,0.00000000,0.00000000,268.30000000); //
CreateDynamicObject(18858,203.04000000,2495.37000000,24.23000000,0.00000000,0.00000000,268.63000000); //
CreateDynamicObject(18858,202.88000000,2481.20000000,24.01000000,0.00000000,0.00000000,270.72000000); //
CreateDynamicObject(18780,325.75000000,2575.81000000,26.94000000,0.00000000,0.00000000,89.64000000); //
CreateDynamicObject(18780,325.97000000,2613.85000000,90.42000000,0.00000000,-64.00000000,89.82000000); //
CreateDynamicObject(18780,290.40000000,2574.73000000,27.37000000,0.00000000,0.00000000,90.68000000); //
CreateDynamicObject(18780,289.89000000,2613.78000000,91.91000000,0.00000000,-63.00000000,90.59000000); //
CreateDynamicObject(8355,313.17000000,2470.69000000,19.31000000,0.00000000,-26.00000000,269.75000000); //
CreateDynamicObject(8355,175.06000000,2470.84000000,19.31000000,0.00000000,26.00000000,90.09000000); //
CreateDynamicObject(8355,36.97000000,2470.61000000,19.31000000,0.00000000,26.00000000,90.08000000); //
CreateDynamicObject(8355,484.54000000,2501.01000000,46.86000000,-29.00000000,0.00000000,88.96000000); //
CreateDynamicObject(8355,603.41000000,2498.95000000,114.15000000,30.00000000,0.00000000,269.00000000); //
CreateDynamicObject(18783,373.42000000,2442.61000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,390.09000000,2422.75000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,390.10000000,2402.77000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,390.14000000,2382.82000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,353.38000000,2442.63000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,333.38000000,2442.66000000,25.61000000,0.00000000,0.00000000,359.90000000); //
CreateDynamicObject(18783,370.08000000,2422.62000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,350.08000000,2422.62000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,330.12000000,2422.68000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,370.16000000,2402.66000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,350.15000000,2402.66000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,330.17000000,2402.73000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,370.15000000,2382.80000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,350.17000000,2382.80000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,330.20000000,2382.77000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,410.09000000,2422.75000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,410.10000000,2402.76000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,410.10000000,2382.81000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,430.09000000,2422.70000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,430.12000000,2402.84000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,430.11000000,2382.90000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,450.07000000,2422.76000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,450.04000000,2402.86000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,450.04000000,2382.85000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18784,470.05000000,2422.77000000,25.61000000,0.00000000,0.00000000,180.03000000); //
CreateDynamicObject(18784,469.73000000,2402.79000000,25.61000000,0.00000000,0.00000000,179.30000000); //
CreateDynamicObject(18784,470.03000000,2382.94000000,25.61000000,0.00000000,0.00000000,180.08000000); //
CreateDynamicObject(18783,450.07000000,2362.93000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,430.11000000,2362.95000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,410.25000000,2363.02000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,390.33000000,2363.03000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,370.43000000,2363.03000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,350.63000000,2363.08000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,330.63000000,2363.11000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18784,470.09000000,2362.98000000,25.61000000,0.00000000,0.00000000,180.22000000); //
CreateDynamicObject(18783,400.66000000,2343.06000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,380.91000000,2343.08000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,360.96000000,2343.06000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,341.06000000,2343.08000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,321.27000000,2343.16000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,379.10000000,2323.39000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,359.09000000,2323.14000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,339.24000000,2323.29000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,319.38000000,2323.16000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,358.78000000,2303.23000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,338.84000000,2303.32000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,319.39000000,2303.16000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,332.81000000,2283.35000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,319.40000000,2283.22000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,313.47000000,2442.85000000,25.61000000,0.00000000,0.00000000,359.29000000); //
CreateDynamicObject(18783,313.37000000,2383.08000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,313.37000000,2403.06000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,313.37000000,2423.07000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,313.34000000,2363.15000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,313.47000000,2343.15000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,313.34000000,2323.15000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,313.38000000,2303.23000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,313.39000000,2283.36000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,436.22000000,2441.21000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,456.24000000,2441.21000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,436.21000000,2461.20000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,456.21000000,2461.20000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18784,476.20000000,2441.22000000,25.61000000,0.00000000,0.00000000,180.12000000); //
CreateDynamicObject(18784,476.06000000,2461.22000000,25.61000000,0.00000000,0.00000000,180.06000000); //
CreateDynamicObject(18782,152.50000000,2509.04000000,16.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18782,252.36000000,2489.95000000,16.41000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18782,345.76000000,2516.75000000,16.63000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.58000000,2442.96000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.64000000,2442.95000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,253.89000000,2443.01000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.17000000,2443.02000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.43000000,2443.07000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.66000000,2443.07000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,175.23000000,2443.07000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,155.43000000,2443.14000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.83000000,2443.12000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,116.04000000,2443.10000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,96.41000000,2443.07000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,76.63000000,2443.04000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,57.37000000,2443.06000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,37.56000000,2443.02000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,17.64000000,2443.01000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-2.01000000,2443.01000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-21.98000000,2443.02000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.44000000,2423.09000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.46000000,2383.17000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.46000000,2403.17000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.53000000,2363.22000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.51000000,2343.29000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.57000000,2323.28000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.58000000,2303.26000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.58000000,2283.35000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.61000000,2422.96000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.68000000,2403.03000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.68000000,2383.07000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.66000000,2363.12000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.65000000,2343.23000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.75000000,2323.35000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.79000000,2303.41000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.89000000,2283.52000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,273.90000000,2263.55000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,293.69000000,2263.62000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,306.29000000,2266.47000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.22000000,2423.08000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.19000000,2423.09000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.02000000,2423.96000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,253.91000000,2423.64000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,253.94000000,2403.82000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.08000000,2404.08000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.37000000,2404.11000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.45000000,2344.54000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,254.15000000,2383.81000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.17000000,2384.31000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.38000000,2384.33000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.30000000,2364.49000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,254.18000000,2343.98000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,254.13000000,2363.95000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.23000000,2364.49000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.31000000,2344.52000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,254.16000000,2324.06000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.23000000,2324.50000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.46000000,2324.81000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,253.87000000,2304.71000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.28000000,2304.66000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.46000000,2304.94000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,254.00000000,2284.87000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.25000000,2284.88000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.47000000,2285.01000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,253.91000000,2265.01000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,234.49000000,2265.21000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,214.62000000,2265.12000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,174.41000000,2423.20000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,154.84000000,2423.33000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.46000000,2403.10000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,174.56000000,2403.45000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,154.85000000,2403.42000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.49000000,2383.10000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,174.59000000,2383.60000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,155.00000000,2383.44000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.45000000,2363.24000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,174.63000000,2363.61000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,155.03000000,2363.48000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.49000000,2343.26000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,174.71000000,2343.85000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,155.07000000,2343.84000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.05000000,2423.28000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.07000000,2403.29000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.08000000,2383.35000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.15000000,2363.43000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,115.24000000,2423.20000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,115.26000000,2403.21000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,115.30000000,2383.36000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.13000000,2343.74000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,95.44000000,2423.15000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,95.41000000,2403.16000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,115.39000000,2343.79000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,115.34000000,2363.54000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,95.41000000,2383.43000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,95.38000000,2363.58000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,95.41000000,2343.87000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,75.46000000,2423.16000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,75.47000000,2403.30000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,75.39000000,2383.45000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,75.38000000,2363.62000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,75.46000000,2343.65000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,55.65000000,2383.43000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,55.57000000,2403.27000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,55.57000000,2423.12000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,35.64000000,2423.30000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,35.73000000,2403.40000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,56.01000000,2363.67000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,56.03000000,2343.77000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,35.67000000,2383.48000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,36.20000000,2363.59000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,36.13000000,2343.80000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.72000000,2323.33000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.71000000,2303.47000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.67000000,2283.57000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,174.88000000,2323.95000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,174.89000000,2304.00000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,174.97000000,2284.04000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,155.20000000,2284.40000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,155.13000000,2304.22000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,155.11000000,2324.03000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.45000000,2323.80000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.42000000,2303.98000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.44000000,2284.11000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,194.65000000,2263.72000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,174.93000000,2264.04000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,155.21000000,2264.73000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,135.33000000,2264.71000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,115.74000000,2323.87000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,115.70000000,2303.89000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,115.76000000,2284.09000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,115.76000000,2264.30000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,96.11000000,2324.15000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,96.14000000,2304.23000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,96.12000000,2284.25000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,76.18000000,2323.95000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,76.33000000,2304.36000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,76.36000000,2284.39000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,56.36000000,2323.80000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,56.39000000,2304.03000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,56.37000000,2284.68000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,36.36000000,2323.83000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,36.37000000,2303.94000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,36.38000000,2284.05000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,15.90000000,2423.58000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,15.86000000,2403.60000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-3.90000000,2423.43000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-3.70000000,2403.43000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-21.91000000,2423.40000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-21.84000000,2403.39000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,16.19000000,2383.71000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-3.61000000,2383.66000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-21.79000000,2383.49000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,16.34000000,2363.85000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-3.41000000,2363.81000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-21.85000000,2363.55000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-3.65000000,2343.91000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,16.17000000,2343.98000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,16.68000000,2324.11000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,16.78000000,2304.28000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-23.44000000,2343.96000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,16.78000000,2285.91000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-3.11000000,2324.11000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-3.15000000,2304.42000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-2.95000000,2284.56000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-23.01000000,2324.11000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-22.97000000,2304.18000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-22.95000000,2284.69000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-40.87000000,2442.99000000,23.13000000,0.00000000,-15.00000000,0.00000000); //
CreateDynamicObject(18783,-58.80000000,2442.99000000,16.05000000,0.00000000,-28.00000000,360.00000000); //
CreateDynamicObject(18783,-40.89000000,2423.02000000,23.13000000,0.00000000,-15.00000000,0.00000000); //
CreateDynamicObject(18783,-40.83000000,2403.03000000,23.13000000,0.00000000,-15.00000000,0.00000000); //
CreateDynamicObject(18783,-40.82000000,2383.12000000,23.13000000,0.00000000,-15.00000000,0.00000000); //
CreateDynamicObject(18783,-40.59000000,2363.22000000,23.13000000,0.00000000,-15.00000000,0.00000000); //
CreateDynamicObject(18783,-42.36000000,2343.25000000,23.13000000,0.00000000,-15.00000000,0.00000000); //
CreateDynamicObject(18783,-42.02000000,2324.06000000,23.13000000,0.00000000,-15.00000000,0.00000000); //
CreateDynamicObject(18783,-41.98000000,2304.14000000,23.13000000,0.00000000,-15.00000000,0.00000000); //
CreateDynamicObject(18783,-42.01000000,2284.16000000,23.13000000,0.00000000,-15.00000000,0.00000000); //
CreateDynamicObject(18783,-58.79000000,2422.99000000,16.05000000,0.00000000,-28.00000000,360.00000000); //
CreateDynamicObject(18783,-58.75000000,2382.99000000,16.05000000,0.00000000,-28.00000000,360.00000000); //
CreateDynamicObject(18783,-58.82000000,2402.96000000,16.05000000,0.00000000,-28.00000000,360.00000000); //
CreateDynamicObject(18783,-58.58000000,2363.22000000,16.05000000,0.00000000,-28.00000000,360.00000000); //
CreateDynamicObject(18783,-60.24000000,2343.25000000,16.04000000,0.00000000,-28.00000000,360.00000000); //
CreateDynamicObject(18783,-59.99000000,2323.36000000,16.14000000,0.00000000,-28.00000000,360.00000000); //
CreateDynamicObject(18779,-24.02000000,2347.72000000,34.84000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-42.24000000,2468.11000000,14.59000000,-11.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18779,-31.66000000,2469.49000000,23.22000000,0.00000000,0.00000000,90.26000000); //
CreateDynamicObject(18779,-47.82000000,2469.17000000,23.33000000,0.00000000,0.00000000,104.72000000); //
CreateDynamicObject(18783,-41.04000000,2448.78000000,16.42000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,436.25000000,2469.78000000,17.91000000,-84.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,456.25000000,2469.65000000,17.87000000,-85.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,373.50000000,2450.33000000,25.61000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18750,343.41000000,2296.87000000,46.29000000,-270.00000000,0.00000000,214.00000000); //
CreateDynamicObject(18750,176.70000000,2258.86000000,46.09000000,90.00000000,0.00000000,178.00000000); //
CreateDynamicObject(18834,384.44000000,2445.63000000,48.09000000,0.00000000,0.00000000,178.31000000); //
CreateDynamicObject(18829,343.80000000,2445.97000000,65.00000000,0.00000000,-88.00000000,0.00000000); //
CreateDynamicObject(18829,294.09000000,2445.76000000,66.51000000,0.00000000,-88.00000000,0.00000000); //
CreateDynamicObject(18829,244.60000000,2445.77000000,68.13000000,0.00000000,-88.00000000,0.00000000); //
CreateDynamicObject(18829,194.63000000,2445.75000000,69.86000000,0.00000000,-88.00000000,0.00000000); //
CreateDynamicObject(18829,145.03000000,2445.69000000,71.47000000,0.00000000,-88.00000000,0.00000000); //
CreateDynamicObject(19005,105.97000000,2445.68000000,70.51000000,0.00000000,0.00000000,89.59000000); //
CreateDynamicObject(18777,180.53000000,2302.69000000,30.60000000,0.00000000,0.00000000,174.05000000); //
CreateDynamicObject(18777,180.68000000,2303.40000000,56.52000000,0.00000000,0.00000000,175.69000000); //
CreateDynamicObject(18777,180.56000000,2303.42000000,82.59000000,0.00000000,0.00000000,175.43000000); //
CreateDynamicObject(18801,149.62000000,2303.78000000,128.81000000,0.00000000,0.00000000,272.69000000); //
CreateDynamicObject(18801,129.96000000,2300.69000000,128.81000000,0.00000000,0.00000000,272.51000000); //
CreateDynamicObject(18781,136.10000000,2379.62000000,38.82000000,0.00000000,0.00000000,112.53000000); //
CreateDynamicObject(18781,101.94000000,2365.56000000,38.82000000,0.00000000,0.00000000,291.84000000); //
CreateDynamicObject(19005,266.31000000,2263.55000000,30.74000000,0.00000000,0.00000000,184.10000000); //
CreateDynamicObject(18843,267.11000000,2254.33000000,88.64000000,180.00000000,0.00000000,77.24000000); //
CreateDynamicObject(8493,213.15000000,2360.57000000,45.63000000,0.00000000,0.00000000,97.74000000); //
CreateDynamicObject(18786,222.06000000,2381.48000000,30.35000000,0.00000000,0.00000000,99.79000000); //
CreateDynamicObject(18786,229.40000000,2343.92000000,30.35000000,0.00000000,0.00000000,278.20000000); //
CreateDynamicObject(18779,388.29000000,2358.97000000,35.44000000,0.00000000,0.00000000,143.06000000); //
CreateDynamicObject(18779,399.36000000,2350.61000000,54.09000000,0.00000000,48.00000000,143.00000000); //
CreateDynamicObject(18779,395.84000000,2353.44000000,74.05000000,0.00000000,106.00000000,141.81000000); //
CreateDynamicObject(19005,119.33000000,2286.60000000,109.07000000,0.00000000,0.00000000,176.03000000); //
CreateDynamicObject(19001,440.24000000,2393.85000000,37.89000000,0.00000000,0.00000000,357.94000000); //
CreateDynamicObject(19005,462.31000000,2404.92000000,29.76000000,0.00000000,0.00000000,266.40000000); //
CreateDynamicObject(19005,476.12000000,2404.10000000,39.34000000,28.00000000,0.00000000,267.00000000); //
CreateDynamicObject(19005,486.22000000,2403.59000000,57.76000000,47.00000000,0.00000000,266.98000000); //
CreateDynamicObject(18784,219.66000000,2485.97000000,17.75000000,0.00000000,0.00000000,179.94000000); //
CreateDynamicObject(18784,219.67000000,2505.91000000,17.75000000,0.00000000,0.00000000,179.85000000); //
CreateDynamicObject(18784,219.66000000,2525.89000000,17.75000000,0.00000000,0.00000000,179.88000000); //
CreateDynamicObject(18784,188.53000000,2485.70000000,17.75000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18784,188.50000000,2505.57000000,17.75000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18784,188.50000000,2525.51000000,17.75000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(19129,418.78000000,2517.32000000,15.52000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(19129,418.77000000,2497.44000000,15.52000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(19129,418.72000000,2477.53000000,15.52000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(19129,398.96000000,2518.57000000,15.52000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(19129,398.96000000,2498.69000000,15.52000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(19129,398.96000000,2478.71000000,15.52000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(19129,379.07000000,2478.71000000,15.52000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6869,32.27000000,2562.12000000,-5.16000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(8411,171.54000000,2556.02000000,-3.15000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18780,246.92000000,2532.75000000,27.31000000,0.00000000,0.00000000,160.26000000); //
CreateDynamicObject(18786,141.33000000,2555.53000000,63.76000000,0.00000000,0.00000000,0.60000000); //
CreateDynamicObject(18779,522.13000000,2507.39000000,76.69000000,0.00000000,-28.00000000,0.00000000); //
CreateDynamicObject(18779,521.52000000,2480.93000000,76.69000000,0.00000000,-28.00000000,0.00000000); //
CreateDynamicObject(18789,404.89000000,2485.78000000,64.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18789,404.90000000,2501.80000000,64.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18789,404.85000000,2517.85000000,65.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18789,255.05000000,2485.78000000,64.60000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18789,254.95000000,2517.86000000,65.00000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18780,227.16000000,2486.24000000,76.49000000,0.00000000,0.00000000,179.71000000); //
CreateDynamicObject(18780,230.04000000,2518.07000000,76.49000000,0.00000000,0.00000000,179.71000000); //
CreateDynamicObject(18779,318.49000000,2495.80000000,74.58000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18786,-22.43000000,2554.58000000,54.24000000,0.00000000,0.00000000,10.07000000); //
CreateDynamicObject(18783,672.95000000,2468.19000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,672.91000000,2488.14000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,672.85000000,2508.10000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,672.87000000,2528.05000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,692.66000000,2527.97000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,692.64000000,2507.96000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,692.62000000,2488.04000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,692.92000000,2468.16000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,712.48000000,2527.95000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,712.43000000,2508.10000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,712.41000000,2488.14000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,712.47000000,2468.19000000,146.24000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(6188,-101.56000000,2500.18000000,7.76000000,-19.00000000,0.00000000,269.00000000); //
CreateDynamicObject(6189,-354.42000000,2504.51000000,92.70000000,-19.00000000,0.00000000,269.00000000); //
CreateDynamicObject(6189,-230.98000000,2502.31000000,50.19000000,-19.00000000,0.00000000,269.00000000); //
CreateDynamicObject(18786,-75.44000000,2500.30000000,17.73000000,0.00000000,0.00000000,359.80000000); //
CreateDynamicObject(18778,-156.78000000,2492.29000000,42.04000000,0.00000000,0.00000000,269.83000000); //
CreateDynamicObject(18778,-149.11000000,2492.28000000,45.96000000,11.00000000,0.00000000,270.00000000); //
CreateDynamicObject(18778,-275.87000000,2511.75000000,83.76000000,0.00000000,0.00000000,268.16000000); //
CreateDynamicObject(18778,-268.13000000,2511.50000000,87.72000000,10.00000000,0.00000000,268.00000000); //
CreateDynamicObject(18778,-355.66000000,2495.79000000,111.11000000,0.00000000,0.00000000,269.44000000); //
CreateDynamicObject(18778,-348.05000000,2495.75000000,115.14000000,14.00000000,0.00000000,270.00000000); //
CreateDynamicObject(18824,55.36000000,2575.17000000,65.56000000,64.00000000,-2.00000000,253.00000000); //
CreateDynamicObject(18809,13.34000000,2564.54000000,81.72000000,62.00000000,-58.00000000,0.84000000); //
CreateDynamicObject(18824,-17.69000000,2533.79000000,96.29000000,67.00000000,0.00000000,346.77000000); //
CreateDynamicObject(18809,-4.14000000,2490.08000000,107.43000000,85.00000000,0.00000000,30.69000000); //
CreateDynamicObject(18783,-420.24000000,2528.77000000,124.98000000,0.00000000,0.00000000,359.39000000); //
CreateDynamicObject(18783,-420.43000000,2508.86000000,124.98000000,0.00000000,0.00000000,358.97000000); //
CreateDynamicObject(18783,-420.71000000,2489.08000000,124.98000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-440.53000000,2489.08000000,124.98000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-440.31000000,2508.87000000,124.98000000,0.00000000,0.00000000,358.88000000); //
CreateDynamicObject(18783,-439.95000000,2528.76000000,124.98000000,0.00000000,0.00000000,358.88000000); //
CreateDynamicObject(18783,-460.44000000,2489.10000000,124.98000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-460.27000000,2508.76000000,124.98000000,0.00000000,0.00000000,359.17000000); //
CreateDynamicObject(18783,-459.95000000,2528.74000000,124.98000000,0.00000000,0.00000000,359.49000000); //
CreateDynamicObject(18783,-480.20000000,2489.16000000,124.98000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18783,-480.09000000,2509.00000000,124.98000000,0.00000000,0.00000000,359.08000000); //
CreateDynamicObject(18783,-479.79000000,2528.84000000,124.98000000,0.00000000,0.00000000,359.26000000); //
CreateDynamicObject(18750,44.01000000,2535.84000000,33.07000000,87.00000000,0.00000000,0.00000000); //
CreateDynamicObject(18784,18.75000000,2503.40000000,17.79000000,0.00000000,0.00000000,359.49000000); //
CreateDynamicObject(18846,31.06000000,2503.58000000,20.12000000,0.00000000,0.00000000,179.49000000); //
CreateDynamicObject(18784,42.95000000,2503.10000000,17.79000000,0.00000000,0.00000000,178.98000000); //
CreateDynamicObject(18846,429.68000000,2479.13000000,20.02000000,0.00000000,0.00000000,262.22000000); //
CreateDynamicObject(18835,28.63000000,2433.86000000,91.66000000,0.00000000,0.00000000,26.73000000); //
CreateDynamicObject(18830,-35.55000000,2403.07000000,34.28000000,0.00000000,220.00000000,0.00000000); //
CreateDynamicObject(18846,0.02000000,2298.05000000,32.96000000,0.00000000,0.00000000,150.11000000); //
CreateDynamicObject(18831,29.88000000,2428.47000000,67.89000000,-4.00000000,-47.00000000,291.56000000); //
CreateDynamicObject(18858,150.47000000,2428.12000000,36.83000000,0.00000000,0.00000000,89.28000000); //
CreateDynamicObject(18858,155.72000000,2427.79000000,36.83000000,0.00000000,0.00000000,88.84000000); //
CreateDynamicObject(18858,160.64000000,2427.77000000,36.83000000,0.00000000,0.00000000,270.47000000); //
CreateDynamicObject(18858,144.71000000,2427.61000000,36.83000000,0.00000000,0.00000000,88.90000000); //
CreateDynamicObject(18784,173.02000000,2428.11000000,30.07000000,0.00000000,0.00000000,180.22000000); //
CreateDynamicObject(18784,132.21000000,2427.09000000,30.07000000,0.00000000,0.00000000,1.77000000); //
AddStaticVehicleEx(411,-481.77150000,2483.76460000,128.63620000,299.24680000,-1,-1,15); //Infernus
AddStaticVehicleEx(411,-458.30450000,2483.19820000,128.15670000,0.00000000,-1,-1,15); //Infernus
AddStaticVehicleEx(411,-484.97420000,2511.36940000,128.82930000,268.12620000,-1,-1,15); //Infernus
AddStaticVehicleEx(411,-483.66070000,2535.28170000,128.73240000,240.47080000,-1,-1,15); //Infernus
AddStaticVehicleEx(411,-449.92350000,2535.07960000,129.69330000,179.06100000,-1,-1,15); //Infernus
AddStaticVehicleEx(411,687.66410000,2507.98950000,150.53580000,90.65240000,-1,-1,15); //Infernus
AddStaticVehicleEx(411,688.58700000,2489.12790000,151.29770000,89.83930000,-1,-1,15); //Infernus
////======================================================[Stunt Las Venturas]=================================================================
    CreateDynamicObject(3256,1363.56000000,1291.41000000,9.82000000,0.00000000,355.99000000,43.99000000); //
    CreateDynamicObject(11487,1464.42000000,1318.73000000,24.30000000,0.00000000,0.00000000,321.99000000); //
    CreateDynamicObject(19131,1358.93000000,1471.82000000,13.09000000,359.26000000,42.50000000,86.67000000); //
    CreateDynamicObject(19131,1339.92000000,1471.89000000,13.09000000,359.25000000,42.50000000,86.67000000); //
    CreateDynamicObject(3458,1543.77000000,1319.80000000,9.68000000,329.23000000,0.28000000,2.14000000); //
    CreateDynamicObject(3458,1543.84000000,1315.53000000,12.38000000,325.73000000,0.29000000,2.15000000); //
    CreateDynamicObject(3458,1543.86000000,1311.63000000,15.36000000,319.47000000,0.31000000,2.19000000); //
    CreateDynamicObject(3458,1543.94000000,1307.91000000,18.73000000,316.22000000,0.32000000,2.21000000); //
    CreateDynamicObject(3458,1544.08000000,1304.51000000,22.16000000,313.22000000,0.34000000,2.23000000); //
    CreateDynamicObject(3458,1544.14000000,1301.26000000,25.86000000,309.47000000,0.37000000,2.27000000); //
    CreateDynamicObject(3458,1544.23000000,1298.28000000,29.81000000,304.71000000,0.41000000,2.32000000); //
    CreateDynamicObject(3458,1544.20000000,1296.01000000,34.08000000,291.21000000,0.63000000,2.58000000); //
    CreateDynamicObject(3458,1544.36000000,1294.75000000,39.08000000,277.21000000,1.83000000,3.80000000); //
    CreateDynamicObject(3458,1544.29000000,1294.59000000,43.83000000,273.54000000,176.27000000,178.26000000); //
    CreateDynamicObject(3458,1544.47000000,1295.24000000,48.26000000,284.28000000,179.06000000,181.07000000); //
    CreateDynamicObject(3458,1544.87000000,1296.73000000,52.61000000,294.78000000,179.45000000,181.48000000); //
    CreateDynamicObject(3458,1544.69000000,1298.99000000,56.98000000,299.52000000,179.52000000,181.57000000); //
    CreateDynamicObject(3458,1544.25000000,1301.50000000,60.83000000,305.52000000,179.59000000,181.65000000); //
    CreateDynamicObject(3458,1543.87000000,1304.83000000,64.58000000,318.02000000,179.68000000,181.76000000); //
    CreateDynamicObject(3458,1544.15000000,1308.58000000,67.26000000,331.27000000,179.72000000,181.84000000); //
    CreateDynamicObject(3458,1544.24000000,1312.95000000,68.83000000,349.52000000,179.75000000,181.93000000); //
    CreateDynamicObject(17639,1551.72000000,1363.18000000,42.46000000,0.00000000,0.00000000,90.50000000); //
    CreateDynamicObject(17639,1536.76000000,1363.02000000,42.41000000,0.00000000,0.00000000,90.49000000); //
    CreateDynamicObject(3458,1546.56000000,1414.17000000,42.13000000,30.47000000,0.28000000,359.82000000); //
    CreateDynamicObject(3458,1546.56000000,1418.01000000,44.86000000,41.22000000,0.32000000,359.75000000); //
    CreateDynamicObject(3458,1546.52000000,1421.27000000,48.18000000,49.72000000,0.37000000,359.68000000); //
    CreateDynamicObject(3458,1546.61000000,1424.24000000,52.06000000,55.71000000,0.42000000,359.60000000); //
    CreateDynamicObject(3458,1546.65000000,1426.79000000,56.46000000,63.96000000,0.53000000,359.46000000); //
    CreateDynamicObject(3458,1546.53000000,1428.58000000,60.78000000,70.96000000,0.71000000,359.26000000); //
    CreateDynamicObject(3458,1546.43000000,1430.00000000,65.16000000,73.21000000,0.80000000,359.16000000); //
    CreateDynamicObject(3458,1546.36000000,1431.10000000,69.83000000,80.20000000,1.36000000,358.59000000); //
    CreateDynamicObject(3458,1546.33000000,1431.60000000,74.33000000,87.94000000,6.45000000,353.47000000); //
    CreateDynamicObject(3458,1546.34000000,1431.45000000,78.98000000,84.54000000,177.57000000,182.33000000); //
    CreateDynamicObject(3458,1546.29000000,1430.67000000,83.53000000,74.54000000,179.13000000,180.74000000); //
    CreateDynamicObject(3458,1546.16000000,1429.16000000,87.73000000,66.04000000,179.42000000,180.42000000); //
    CreateDynamicObject(3458,1546.34000000,1426.61000000,92.13000000,54.03000000,179.60000000,180.22000000); //
    CreateDynamicObject(3458,1546.54000000,1423.57000000,95.88000000,47.78000000,179.64000000,180.15000000); //
    CreateDynamicObject(3458,1546.73000000,1420.32000000,99.11000000,42.03000000,179.68000000,180.10000000); //
    CreateDynamicObject(3458,1546.99000000,1416.48000000,101.73000000,26.53000000,179.73000000,180.00000000); //
    CreateDynamicObject(3458,1546.80000000,1411.68000000,103.31000000,10.03000000,179.75000000,179.92000000); //
    CreateDynamicObject(17639,1536.76000000,1363.02000000,77.41000000,0.00000000,0.00000000,90.48000000); //
    CreateDynamicObject(17639,1551.73000000,1362.83000000,77.41000000,359.50000000,0.00000000,90.49000000); //
    CreateDynamicObject(3458,1546.17000000,1311.15000000,77.18000000,328.21000000,0.28000000,0.03000000); //
    CreateDynamicObject(3458,1546.10000000,1307.15000000,80.03000000,320.96000000,0.31000000,0.07000000); //
    CreateDynamicObject(3458,1546.03000000,1303.64000000,83.03000000,317.96000000,0.32000000,0.09000000); //
    CreateDynamicObject(3458,1546.03000000,1300.45000000,86.21000000,311.71000000,0.35000000,0.14000000); //
    CreateDynamicObject(3458,1546.05000000,1297.57000000,90.08000000,301.45000000,0.44000000,0.25000000); //
    CreateDynamicObject(3458,1545.88000000,1295.45000000,94.31000000,292.45000000,0.60000000,0.43000000); //
    CreateDynamicObject(3458,1545.76000000,1293.95000000,98.98000000,282.95000000,1.02000000,0.87000000); //
    CreateDynamicObject(3458,1545.76000000,1293.13000000,103.33000000,278.70000000,1.52000000,1.37000000); //
    CreateDynamicObject(3458,1545.76000000,1292.80000000,108.01000000,270.83000000,163.98000000,163.85000000); //
    CreateDynamicObject(3458,1545.76000000,1293.13000000,112.46000000,278.05000000,178.36000000,178.25000000); //
    CreateDynamicObject(3458,1545.61000000,1294.09000000,116.66000000,288.04000000,179.26000000,179.16000000); //
    CreateDynamicObject(3458,1545.66000000,1296.01000000,121.23000000,297.79000000,179.50000000,179.43000000); //
    CreateDynamicObject(3458,1545.51000000,1298.35000000,125.08000000,304.28000000,179.59000000,179.53000000); //
    CreateDynamicObject(3458,1545.12000000,1301.56000000,128.98000000,314.03000000,179.66000000,179.63000000); //
    CreateDynamicObject(3458,1545.12000000,1305.48000000,132.28000000,324.28000000,179.71000000,179.70000000); //
    CreateDynamicObject(3458,1545.16000000,1309.87000000,134.83000000,335.52000000,179.74000000,179.76000000); //
    CreateDynamicObject(3458,1545.20000000,1314.75000000,136.51000000,346.02000000,179.75000000,179.81000000); //
    CreateDynamicObject(3458,1545.47000000,1319.31000000,137.23000000,357.26000000,179.75000000,179.86000000); //
    CreateDynamicObject(17639,1550.65000000,1364.54000000,114.16000000,359.49000000,0.00000000,90.49000000); //
    CreateDynamicObject(17639,1535.52000000,1364.43000000,114.01000000,359.49000000,0.00000000,90.49000000); //
    CreateDynamicObject(4853,1528.24000000,1458.99000000,110.80000000,351.99000000,0.00000000,271.99000000); //
    CreateDynamicObject(4853,1538.85000000,1459.32000000,110.97000000,9.99000000,0.00000000,271.99000000); //
    CreateDynamicObject(4853,1547.00000000,1459.39000000,111.00000000,350.99000000,0.00000000,271.99000000); //
    CreateDynamicObject(4853,1557.71000000,1459.62000000,111.15000000,10.49000000,0.00000000,271.99000000); //
    CreateDynamicObject(3627,1539.94000000,1511.04000000,113.67000000,0.21000000,30.49000000,271.36000000); //
    CreateDynamicObject(11487,1418.88000000,1305.59000000,24.37000000,0.25000000,0.00000000,141.99000000); //
    CreateDynamicObject(5052,1429.92000000,1347.65000000,43.43000000,0.00000000,0.00000000,195.99000000); //
    CreateDynamicObject(1655,1379.59000000,1507.21000000,44.28000000,0.00000000,0.00000000,17.99000000); //
    CreateDynamicObject(1655,1387.83000000,1509.87000000,44.28000000,0.00000000,0.00000000,17.99000000); //
    CreateDynamicObject(1655,1385.74000000,1516.45000000,48.18000000,13.75000000,0.00000000,17.99000000); //
    CreateDynamicObject(1655,1377.48000000,1513.79000000,48.18000000,13.74000000,0.00000000,17.99000000); //
    CreateDynamicObject(2745,1300.13000000,1265.31000000,11.02000000,0.00000000,0.00000000,172.00000000); //
    CreateDynamicObject(2745,1302.67000000,1265.02000000,11.02000000,0.00000000,0.00000000,171.99000000); //
    CreateDynamicObject(2745,1304.56000000,1264.97000000,11.02000000,0.00000000,0.00000000,171.99000000); //
    CreateDynamicObject(3471,1333.73000000,1265.60000000,11.09000000,0.00000000,0.00000000,88.00000000); //
    CreateDynamicObject(3471,1338.30000000,1265.52000000,11.09000000,0.00000000,0.00000000,87.99000000); //
    CreateDynamicObject(13831,1353.32000000,1324.72000000,52.69000000,0.00000000,0.00000000,290.00000000); //
    CreateDynamicObject(3256,1335.91000000,1358.40000000,10.14000000,0.00000000,355.99000000,137.99000000); //
    CreateDynamicObject(3627,1317.93000000,1275.17000000,13.65000000,0.00000000,358.00000000,91.24000000); //
    CreateDynamicObject(974,1360.78000000,1296.97000000,23.99000000,274.00000000,0.00000000,292.00000000); //
    CreateDynamicObject(974,1358.36000000,1303.01000000,23.99000000,273.99000000,0.00000000,291.99000000); //
    CreateDynamicObject(974,1355.79000000,1308.97000000,23.99000000,273.99000000,0.00000000,291.99000000); //
    CreateDynamicObject(974,1353.29000000,1315.11000000,23.99000000,273.99000000,0.00000000,291.99000000); //
    CreateDynamicObject(974,1350.87000000,1321.15000000,23.99000000,273.99000000,0.00000000,291.99000000); //
    CreateDynamicObject(974,1348.46000000,1327.04000000,23.99000000,273.99000000,0.00000000,291.99000000); //
    CreateDynamicObject(974,1345.94000000,1333.22000000,23.99000000,273.99000000,0.00000000,291.99000000); //
    CreateDynamicObject(974,1343.52000000,1339.29000000,23.99000000,273.99000000,0.00000000,291.99000000); //
    CreateDynamicObject(974,1341.03000000,1345.46000000,23.99000000,273.99000000,0.00000000,291.99000000); //
    CreateDynamicObject(974,1338.46000000,1351.63000000,23.99000000,273.99000000,0.00000000,291.99000000); //
    CreateDynamicObject(7522,1271.34000000,1298.31000000,14.06000000,0.00000000,0.00000000,89.50000000); //
    CreateDynamicObject(8041,1322.63000000,1356.72000000,15.16000000,0.00000000,359.00000000,88.00000000); //
    CreateDynamicObject(8041,1303.19000000,1357.44000000,15.16000000,0.00000000,358.99000000,87.99000000); //
    CreateDynamicObject(1584,1351.87000000,1311.38000000,23.79000000,0.00000000,0.00000000,112.00000000); //
    CreateDynamicObject(1584,1349.06000000,1318.29000000,23.79000000,0.00000000,0.00000000,111.99000000); //
    CreateDynamicObject(1584,1345.96000000,1325.40000000,23.79000000,0.00000000,0.00000000,111.99000000); //
    CreateDynamicObject(1584,1342.78000000,1333.52000000,23.79000000,0.00000000,0.00000000,111.99000000); //
    CreateDynamicObject(1584,1339.48000000,1341.61000000,23.79000000,0.00000000,0.00000000,111.99000000); //
    CreateDynamicObject(1584,1336.65000000,1348.77000000,23.79000000,0.00000000,0.00000000,111.99000000); //
    CreateDynamicObject(1584,1355.63000000,1302.46000000,23.79000000,0.00000000,0.00000000,111.99000000); //
    CreateDynamicObject(1583,1297.95000000,1283.31000000,17.63000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1583,1306.40000000,1283.53000000,17.68000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1583,1308.20000000,1283.53000000,17.68000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1583,1316.70000000,1283.59000000,17.68000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1583,1318.53000000,1283.64000000,17.68000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1583,1327.03000000,1283.92000000,17.68000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1583,1328.86000000,1283.92000000,17.68000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1583,1337.26000000,1284.12000000,17.68000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(14628,1282.00000000,1298.68000000,15.49000000,0.00000000,0.00000000,274.00000000); //
    CreateDynamicObject(3507,1334.72000000,1353.85000000,9.82000000,0.00000000,0.00000000,296.00000000); //
    CreateDynamicObject(3507,1348.31000000,1324.28000000,9.82000000,0.00000000,0.00000000,257.99000000); //
    CreateDynamicObject(3507,1359.69000000,1293.54000000,9.82000000,0.00000000,0.00000000,257.99000000); //
    CreateDynamicObject(3507,1349.15000000,1286.91000000,9.82000000,0.00000000,0.00000000,257.99000000); //
    CreateDynamicObject(3507,1333.19000000,1285.02000000,9.82000000,0.00000000,0.00000000,257.99000000); //
    CreateDynamicObject(3507,1323.35000000,1285.68000000,9.82000000,0.00000000,0.00000000,257.99000000); //
    CreateDynamicObject(3507,1312.76000000,1285.09000000,9.82000000,0.00000000,0.00000000,257.99000000); //
    CreateDynamicObject(3507,1302.20000000,1283.71000000,9.82000000,0.00000000,0.00000000,257.99000000); //
    CreateDynamicObject(3507,1312.83000000,1355.47000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(3507,1294.07000000,1356.39000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(3507,1293.73000000,1349.19000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(3507,1292.84000000,1336.25000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(3507,1293.26000000,1312.97000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(3507,1281.52000000,1298.63000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(8483,1276.78000000,1267.84000000,14.82000000,0.00000000,355.99000000,41.99000000); //
    CreateDynamicObject(3434,1282.89000000,1272.01000000,21.85000000,0.00000000,0.00000000,136.25000000); //
    CreateDynamicObject(11489,1326.30000000,1328.49000000,9.82000000,0.00000000,0.00000000,158.00000000); //
    CreateDynamicObject(3507,1333.05000000,1349.25000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(3507,1331.37000000,1344.67000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(3507,1329.74000000,1340.18000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(3507,1328.11000000,1335.72000000,9.69000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(3507,1326.68000000,1331.13000000,9.82000000,0.00000000,0.00000000,295.99000000); //
    CreateDynamicObject(18733,1365.22000000,1558.85000000,10.13000000,0.00000000,0.00000000,269.99000000); //
    CreateDynamicObject(18733,1364.85000000,1569.02000000,10.13000000,0.00000000,0.00000000,89.99000000); //
    CreateDynamicObject(18736,1365.73000000,1564.05000000,14.49000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1325.60000000,1326.80000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1293.34000000,1312.81000000,9.82000000,0.00000000,0.00000000,314.99000000); //
    CreateDynamicObject(3515,1324.14000000,1324.48000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1322.23000000,1321.61000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1320.16000000,1318.48000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1317.99000000,1315.33000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1315.91000000,1312.21000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1313.83000000,1309.06000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1311.99000000,1306.28000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1310.06000000,1303.37000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1308.40000000,1300.87000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1306.49000000,1297.99000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1304.69000000,1295.28000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1302.90000000,1292.57000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1302.31000000,1289.16000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1301.91000000,1285.53000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1305.66000000,1302.89000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1302.74000000,1305.04000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1299.48000000,1307.45000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1316.38000000,1307.38000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1319.61000000,1305.41000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1322.64000000,1303.06000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1325.52000000,1300.72000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1328.72000000,1298.52000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1331.54000000,1296.03000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1334.86000000,1293.98000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1337.88000000,1291.57000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1341.68000000,1290.70000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1345.30000000,1290.08000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3515,1348.27000000,1288.48000000,8.94000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(7073,1601.81000000,1555.38000000,24.46000000,326.00000000,0.00000000,2.00000000); //
    CreateDynamicObject(7073,1695.73000000,1612.38000000,24.46000000,325.99000000,0.00000000,184.00000000); //
    CreateDynamicObject(7073,1697.79000000,1594.93000000,24.46000000,325.99000000,0.00000000,359.99000000); //
    CreateDynamicObject(7073,1672.95000000,1583.48000000,24.46000000,325.99000000,0.00000000,359.99000000); //
    CreateDynamicObject(7073,1668.05000000,1600.54000000,24.46000000,325.99000000,0.00000000,201.24000000); //
    CreateDynamicObject(7073,1640.81000000,1589.24000000,24.46000000,325.99000000,0.00000000,201.24000000); //
    CreateDynamicObject(7073,1649.20000000,1573.23000000,24.46000000,325.99000000,0.00000000,25.24000000); //
    CreateDynamicObject(7073,1623.09000000,1566.35000000,24.46000000,325.99000000,0.00000000,25.24000000); //
    CreateDynamicObject(7073,1614.46000000,1582.09000000,24.46000000,325.99000000,0.00000000,203.24000000); //
    CreateDynamicObject(7073,1597.61000000,1572.68000000,24.46000000,325.99000000,0.00000000,193.99000000); //
    CreateDynamicObject(7392,1599.31000000,1567.51000000,42.66000000,0.00000000,0.00000000,13.24000000); //
    CreateDynamicObject(7392,1696.80000000,1606.81000000,42.66000000,0.00000000,0.00000000,3.24000000); //
    CreateDynamicObject(16776,1504.49000000,1512.88000000,9.49000000,0.00000000,0.00000000,265.99000000); //
    CreateDynamicObject(16776,1461.34000000,1513.93000000,9.44000000,0.00000000,0.00000000,91.99000000); //
    CreateDynamicObject(1602,1284.29000000,1270.58000000,17.00000000,277.20000000,33.78000000,359.57000000); //
    CreateDynamicObject(1602,1284.76000000,1270.79000000,17.00000000,277.20000000,33.77000000,359.57000000); //
    CreateDynamicObject(1602,1284.76000000,1270.79000000,16.70000000,277.20000000,33.77000000,359.57000000); //
    CreateDynamicObject(1602,1284.54000000,1271.00000000,16.70000000,277.20000000,33.77000000,359.57000000); //
    CreateDynamicObject(1602,1281.42000000,1273.88000000,16.70000000,277.20000000,33.77000000,359.57000000); //
    CreateDynamicObject(1602,1281.15000000,1273.59000000,17.05000000,277.20000000,33.77000000,359.57000000); //
    CreateDynamicObject(1602,1281.35000000,1273.40000000,17.05000000,277.20000000,33.77000000,359.57000000); //
    CreateDynamicObject(1602,1281.35000000,1273.40000000,16.75000000,277.20000000,33.77000000,359.57000000); //
    CreateDynamicObject(1634,1273.05000000,1396.18000000,11.11000000,0.00000000,1.00000000,92.00000000); //
    CreateDynamicObject(1634,1266.19000000,1396.03000000,16.23000000,22.49000000,1.08000000,91.58000000); //
    CreateDynamicObject(1634,1262.50000000,1395.95000000,24.11000000,54.48000000,1.71000000,90.59000000); //
    CreateDynamicObject(1634,1262.68000000,1396.03000000,31.41000000,78.70000000,5.07000000,87.01000000); //
    CreateDynamicObject(1634,1266.06000000,1396.18000000,38.16000000,75.22000000,176.10000000,275.75000000); //
    CreateDynamicObject(1634,1272.49000000,1396.45000000,43.18000000,51.25000000,178.41000000,273.21000000); //
    CreateDynamicObject(18736,1365.59000000,1564.07000000,22.24000000,4.25000000,0.00000000,268.00000000); //
    CreateDynamicObject(12956,1531.64000000,1635.27000000,13.64000000,0.00000000,0.00000000,274.00000000); //
    CreateDynamicObject(1634,1516.28000000,1624.07000000,10.71000000,0.00000000,0.00000000,31.99000000); //
    CreateDynamicObject(8841,1477.50000000,1847.34000000,14.37000000,42.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(8841,1477.61000000,1860.93000000,35.72000000,74.24000000,0.00000000,0.00000000); //
    CreateDynamicObject(8841,1477.72000000,1863.83000000,60.77000000,87.76000000,180.00000000,180.00000000); //
    CreateDynamicObject(8841,1477.16000000,1853.15000000,84.77000000,43.00000000,179.99000000,179.98000000); //
    CreateDynamicObject(9076,1569.94000000,1470.46000000,24.71000000,2.00000000,0.00000000,2.00000000); //
    CreateDynamicObject(1655,1538.95000000,1469.98000000,10.84000000,0.00000000,0.00000000,273.99000000); //
    CreateDynamicObject(1655,1546.41000000,1470.50000000,15.02000000,13.00000000,0.00000000,273.99000000); //
    CreateDynamicObject(1655,1552.38000000,1470.84000000,21.19000000,32.49000000,0.00000000,273.99000000); //
    CreateDynamicObject(1655,1556.03000000,1471.02000000,28.09000000,46.74000000,0.00000000,273.99000000); //
    CreateDynamicObject(1655,1557.87000000,1471.18000000,36.42000000,62.74000000,0.00000000,273.99000000); //
    CreateDynamicObject(1655,1557.24000000,1471.11000000,43.99000000,81.98000000,0.00000000,273.99000000); //
    CreateDynamicObject(1655,1553.20000000,1470.82000000,50.99000000,67.77000000,180.00000000,93.99000000); //
    CreateDynamicObject(3510,1409.59000000,1483.58000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1409.33000000,1512.92000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1409.31000000,1535.90000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1401.02000000,1557.93000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1401.62000000,1574.80000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1409.47000000,1610.47000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1409.25000000,1634.74000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1409.40000000,1656.03000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1409.76000000,1682.21000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1415.65000000,1702.98000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1439.23000000,1710.23000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1454.95000000,1696.63000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1456.74000000,1679.00000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1457.44000000,1657.98000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1456.95000000,1633.62000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1457.22000000,1611.80000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1456.83000000,1586.40000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1469.95000000,1572.74000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1456.88000000,1542.72000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1456.92000000,1523.39000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1456.90000000,1504.81000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3510,1456.83000000,1483.97000000,9.82000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(8397,1335.58000000,1438.58000000,20.20000000,359.48000000,0.00000000,271.99000000); //
    CreateDynamicObject(8493,1518.72000000,1756.46000000,28.46000000,0.00000000,0.00000000,91.99000000); //
    CreateDynamicObject(8620,1413.10000000,1408.51000000,65.42000000,0.00000000,0.00000000,14.00000000); //
    CreateDynamicObject(8620,1399.11000000,1457.11000000,66.57000000,0.00000000,0.00000000,13.99000000); //
    CreateDynamicObject(9078,1306.92000000,1399.21000000,14.16000000,0.00000000,0.00000000,30.00000000); //
    CreateDynamicObject(1634,1345.77000000,1397.33000000,9.71000000,0.00000000,0.99000000,93.74000000); //
    CreateDynamicObject(3092,1485.76000000,1512.76000000,10.64000000,44.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3092,1485.67000000,1512.99000000,10.64000000,43.99000000,0.00000000,0.00000000); //
    CreateDynamicObject(3092,1485.34000000,1513.13000000,10.64000000,43.99000000,0.00000000,0.00000000); //
    CreateDynamicObject(3092,1487.88000000,1514.18000000,10.64000000,43.99000000,0.00000000,124.00000000); //
    CreateDynamicObject(3092,1486.63000000,1513.93000000,10.64000000,43.98000000,0.00000000,123.99000000); //
    CreateDynamicObject(3092,1485.74000000,1514.11000000,10.64000000,43.98000000,0.00000000,123.99000000); //
    CreateDynamicObject(3092,1484.92000000,1513.49000000,10.64000000,43.98000000,0.00000000,253.99000000); //
    CreateDynamicObject(3092,1486.77000000,1512.80000000,10.64000000,43.98000000,0.00000000,21.99000000); //
    CreateDynamicObject(3092,1487.05000000,1513.21000000,10.64000000,43.98000000,0.00000000,63.98000000); //
    CreateDynamicObject(3092,1486.38000000,1513.86000000,11.14000000,43.98000000,0.00000000,63.98000000); //
    CreateDynamicObject(18736,1444.52000000,1518.92000000,15.29000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1409.36000000,1442.12000000,9.59000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1409.32000000,1399.46000000,9.59000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1409.55000000,1376.64000000,9.59000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1409.84000000,1324.48000000,9.59000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1456.91000000,1330.73000000,9.59000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1457.51000000,1367.81000000,9.59000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1457.28000000,1407.77000000,9.59000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3472,1457.15000000,1442.83000000,9.59000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1531.97000000,1727.81000000,10.79000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1530.34000000,1782.18000000,10.79000000,0.00000000,0.00000000,181.99000000); //
    CreateDynamicObject(8397,1326.72000000,1438.26000000,20.20000000,359.48000000,0.00000000,271.98000000); //
    CreateDynamicObject(8397,1317.90000000,1437.97000000,20.20000000,359.48000000,0.00000000,271.98000000); //
    CreateDynamicObject(8397,1304.00000000,1437.59000000,7.13000000,45.48000000,0.00000000,271.98000000); //
    CreateDynamicObject(5052,1394.48000000,1470.09000000,43.41000000,0.00000000,0.00000000,16.24000000); //
    CreateDynamicObject(17053,1429.51000000,1408.67000000,6.16000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(17053,1429.12000000,1387.41000000,6.16000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(1683,1430.44000000,1749.20000000,15.76000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1441.05000000,1733.29000000,10.71000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1441.20000000,1770.53000000,10.69000000,0.00000000,0.00000000,176.00000000); //
    CreateDynamicObject(3458,1439.42000000,1306.31000000,42.01000000,359.24000000,0.25000000,16.25000000); //
    CreateDynamicObject(3458,1440.87000000,1301.58000000,42.06000000,359.24000000,0.24000000,16.00000000); //
    CreateDynamicObject(3458,1436.73000000,1310.74000000,41.93000000,359.24000000,0.24000000,16.00000000); //
    CreateDynamicObject(1655,1446.71000000,1685.26000000,11.12000000,0.00000000,0.00000000,273.99000000); //
    CreateDynamicObject(1655,1451.10000000,1685.59000000,14.47000000,23.00000000,0.00000000,273.99000000); //
    CreateDynamicObject(1655,1454.56000000,1684.62000000,18.79000000,34.99000000,0.00000000,273.99000000); //
    CreateDynamicObject(1655,1457.50000000,1684.17000000,24.29000000,44.74000000,358.94000000,274.73000000); //
    CreateDynamicObject(1655,1458.89000000,1682.87000000,30.71000000,64.98000000,358.21000000,275.60000000); //
    CreateDynamicObject(1655,1458.83000000,1681.47000000,35.87000000,73.72000000,357.30000000,276.56000000); //
    CreateDynamicObject(1655,1456.81000000,1680.44000000,42.70000000,86.18000000,191.43000000,82.56000000); //
    CreateDynamicObject(1655,1453.02000000,1678.81000000,49.15000000,75.73000000,183.06000000,90.99000000); //
    CreateDynamicObject(1655,1447.40000000,1677.02000000,54.59000000,56.50000000,179.10000000,94.70000000); //
    CreateDynamicObject(1655,1440.33000000,1674.94000000,57.98000000,39.99000000,179.35000000,94.36000000); //
    CreateDynamicObject(1655,1433.12000000,1673.67000000,59.09000000,22.99000000,179.45000000,94.15000000); //
    CreateDynamicObject(1655,1425.78000000,1671.99000000,57.52000000,359.99000000,179.49000000,93.94000000); //
    CreateDynamicObject(1655,1421.24000000,1670.15000000,54.34000000,340.24000000,179.45000000,93.75000000); //
    CreateDynamicObject(1655,1418.55000000,1668.62000000,50.44000000,322.99000000,179.35000000,93.54000000); //
    CreateDynamicObject(1655,1416.14000000,1666.46000000,44.32000000,308.48000000,179.17000000,93.29000000); //
    CreateDynamicObject(1655,1416.02000000,1664.80000000,38.10000000,284.74000000,177.97000000,91.97000000); //
    CreateDynamicObject(1655,1417.90000000,1662.92000000,32.67000000,272.57000000,11.59000000,285.51000000); //
    CreateDynamicObject(1655,1421.78000000,1661.76000000,26.54000000,285.52000000,1.92000000,275.79000000); //
    CreateDynamicObject(1655,1426.03000000,1661.78000000,22.26000000,298.51000000,1.07000000,274.88000000); //
    CreateDynamicObject(1655,1431.28000000,1662.22000000,19.07000000,313.01000000,0.75000000,274.48000000); //
    CreateDynamicObject(1655,1436.23000000,1662.71000000,18.74000000,339.00000000,0.54000000,274.12000000); //
    CreateDynamicObject(1655,1441.61000000,1663.08000000,20.08000000,2.00000000,0.50000000,272.91000000); //
    CreateDynamicObject(17639,1378.42000000,1819.37000000,26.11000000,0.00000000,339.74000000,90.48000000); //
    CreateDynamicObject(1634,1505.51000000,1686.08000000,11.11000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1505.59000000,1692.00000000,14.91000000,14.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1505.59000000,1697.15000000,20.29000000,27.50000000,0.00000000,0.00000000); //
    CreateDynamicObject(3627,1602.01000000,1632.76000000,17.45000000,33.49000000,359.99000000,271.49000000); //
    CreateDynamicObject(18732,1549.54000000,1271.07000000,12.18000000,0.00000000,0.00000000,255.99000000); //
    CreateDynamicObject(18778,1421.99000000,1499.34000000,12.10000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(16302,1481.51000000,1514.68000000,16.15000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(16302,1313.47000000,1612.21000000,16.15000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1655,1336.35000000,1612.94000000,11.12000000,0.00000000,0.00000000,91.98000000); //
    CreateDynamicObject(1655,1331.00000000,1612.66000000,14.32000000,13.50000000,0.00000000,91.98000000); //
    CreateDynamicObject(1655,1326.40000000,1612.50000000,18.45000000,24.49000000,0.00000000,91.98000000); //
    CreateDynamicObject(18568,1542.04000000,1746.20000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18568,1526.90000000,1745.05000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18568,1512.21000000,1744.50000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18568,1534.54000000,1740.35000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18568,1518.61000000,1740.36000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18568,1546.46000000,1766.98000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18568,1532.08000000,1766.46000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18568,1517.47000000,1765.23000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18568,1540.54000000,1772.63000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18568,1524.33000000,1771.42000000,10.60000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1530.43000000,1778.89000000,12.59000000,6.74000000,0.00000000,181.99000000); //
    CreateDynamicObject(1634,1532.07000000,1733.29000000,14.29000000,14.75000000,0.00000000,0.00000000); //
    CreateDynamicObject(18733,1443.04000000,1256.95000000,9.83000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18733,1434.79000000,1256.27000000,9.83000000,0.00000000,0.00000000,182.00000000); //
    CreateDynamicObject(18732,1520.07000000,1825.80000000,10.82000000,0.00000000,0.00000000,255.99000000); //
    CreateDynamicObject(1634,1345.49000000,1401.29000000,9.66000000,0.24000000,0.99000000,93.74000000); //
    CreateDynamicObject(18750,1312.85000000,1254.31000000,39.59000000,88.72000000,78.68000000,103.31000000); //
    CreateDynamicObject(18779,1380.72000000,1229.76000000,19.81000000,0.00000000,0.00000000,92.00000000); //
    CreateDynamicObject(18779,1381.13000000,1216.35000000,38.65000000,0.00000000,50.00000000,91.99000000); //
    CreateDynamicObject(18779,1380.88000000,1224.11000000,65.34000000,0.00000000,98.75000000,91.74000000); //
    CreateDynamicObject(18789,1405.56000000,1185.20000000,48.54000000,0.00000000,328.00000000,273.50000000); //
    CreateDynamicObject(18789,1413.24000000,1060.00000000,126.92000000,0.00000000,327.99000000,273.49000000); //
    CreateDynamicObject(18778,1416.80000000,998.44000000,167.57000000,32.97000000,2.38000000,178.95000000); //
    CreateDynamicObject(18778,1401.81000000,1246.82000000,10.85000000,320.50000000,358.37000000,357.21000000); //
    CreateDynamicObject(1655,1404.21000000,1263.89000000,11.12000000,0.00000000,0.00000000,2.24000000); //
    CreateDynamicObject(1655,1404.02000000,1267.60000000,13.31000000,13.50000000,0.00000000,2.24000000); //
    CreateDynamicObject(1655,1403.91000000,1271.28000000,17.79000000,39.49000000,0.00000000,2.23000000); //
    CreateDynamicObject(18845,1383.29000000,1509.40000000,88.08000000,0.00000000,12.00000000,290.00000000); //
    CreateDynamicObject(18779,1455.73000000,1281.95000000,19.96000000,0.00000000,7.99000000,105.99000000); //
    CreateDynamicObject(18779,1458.67000000,1271.61000000,40.37000000,0.00000000,55.99000000,105.99000000); //
    CreateDynamicObject(18779,1458.67000000,1271.61000000,51.36000000,0.00000000,91.99000000,105.99000000); //
    CreateDynamicObject(18860,1306.18000000,1536.87000000,57.81000000,0.00000000,0.00000000,207.99000000); //
    CreateDynamicObject(1655,1336.52000000,1579.88000000,11.12000000,0.00000000,0.00000000,135.98000000); //
    CreateDynamicObject(1655,1332.89000000,1576.15000000,14.68000000,20.00000000,0.00000000,135.98000000); //
    CreateDynamicObject(1655,1330.14000000,1573.38000000,20.04000000,39.99000000,0.00000000,135.98000000); //
    CreateDynamicObject(1655,1328.93000000,1572.14000000,25.60000000,59.99000000,0.00000000,133.98000000); //
    CreateDynamicObject(1655,1329.18000000,1572.43000000,31.88000000,79.98000000,0.00000000,133.97000000); //
    CreateDynamicObject(1655,1330.72000000,1574.02000000,36.59000000,80.01000000,180.00000000,313.97000000); //
    CreateDynamicObject(1655,1348.34000000,1519.91000000,11.12000000,10.75000000,0.00000000,53.98000000); //
    CreateDynamicObject(1655,1345.39000000,1522.06000000,14.33000000,30.50000000,0.00000000,53.98000000); //
    CreateDynamicObject(1655,1343.09000000,1523.82000000,20.34000000,51.99000000,0.00000000,53.98000000); //
    CreateDynamicObject(1655,1349.10000000,1519.38000000,10.59000000,5.74000000,0.00000000,54.23000000); //
    CreateDynamicObject(1655,1342.70000000,1524.16000000,26.46000000,73.49000000,0.00000000,54.98000000); //
    CreateDynamicObject(1655,1343.81000000,1523.39000000,31.95000000,88.49000000,180.00000000,234.98000000); //
    CreateDynamicObject(1655,1346.06000000,1521.52000000,36.66000000,72.24000000,179.99000000,234.97000000); //
    CreateDynamicObject(18855,1338.06000000,1559.21000000,45.36000000,0.00000000,0.00000000,36.00000000); //
    CreateDynamicObject(18852,1403.09000000,1607.54000000,73.73000000,274.00000000,180.00000000,126.99000000); //
    CreateDynamicObject(1655,1441.87000000,1637.26000000,66.26000000,359.00000000,8.00000000,305.38000000); //
    CreateDynamicObject(18783,1600.45000000,1311.14000000,10.12000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18778,1586.54000000,1310.36000000,10.95000000,0.00000000,0.00000000,269.99000000); //
    CreateDynamicObject(18786,1476.53000000,1195.43000000,12.32000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(18786,1476.53000000,1195.43000000,12.32000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(18784,1600.50000000,1331.11000000,10.11000000,0.00000000,0.00000000,270.00000000); //
    CreateDynamicObject(18784,1600.60000000,1291.45000000,10.13000000,0.00000000,0.00000000,90.49000000); //
    CreateDynamicObject(18784,1377.72000000,1742.93000000,12.06000000,0.00000000,0.00000000,268.99000000); //
    CreateDynamicObject(18784,1377.60000000,1731.74000000,16.82000000,359.76000000,342.24000000,269.91000000); //
    CreateDynamicObject(18784,1377.76000000,1727.81000000,18.75000000,359.78000000,328.24000000,269.85000000); //
    CreateDynamicObject(1634,1384.69000000,1775.98000000,9.31000000,344.74000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1381.26000000,1775.99000000,9.31000000,344.74000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1377.48000000,1776.00000000,9.31000000,344.74000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1373.69000000,1776.01000000,9.31000000,344.74000000,0.00000000,0.00000000); //
    CreateDynamicObject(17639,1377.27000000,1957.92000000,77.35000000,0.00000000,339.74000000,90.48000000); //
    CreateDynamicObject(18784,1376.59000000,2002.36000000,97.82000000,359.36000000,327.49000000,91.08000000); //
    CreateDynamicObject(1634,1384.74000000,1907.67000000,59.27000000,342.74000000,0.00000000,193.49000000); //
    CreateDynamicObject(17639,1378.04000000,1873.02000000,45.88000000,0.00000000,339.74000000,90.48000000); //
    CreateDynamicObject(1634,1386.24000000,1901.36000000,61.14000000,357.49000000,0.00000000,193.49000000); //
    CreateDynamicObject(1634,1387.12000000,1897.65000000,63.09000000,5.74000000,0.00000000,193.49000000); //
    CreateDynamicObject(18786,1476.82000000,1183.23000000,18.25000000,359.77000000,23.75000000,90.10000000); //
    CreateDynamicObject(18786,1476.97000000,1174.87000000,28.52000000,0.31000000,50.49000000,89.61000000); //
    CreateDynamicObject(18786,1477.05000000,1173.06000000,38.01000000,0.06000000,82.74000000,89.50000000); //
    CreateDynamicObject(18786,1477.17000000,1175.85000000,47.43000000,359.88000000,103.98000000,89.51000000); //
    CreateDynamicObject(18786,1477.00000000,1185.97000000,58.71000000,359.68000000,129.23000000,89.60000000); //
    CreateDynamicObject(1634,1513.51000000,1622.36000000,10.71000000,0.00000000,0.00000000,31.99000000); //
    CreateDynamicObject(1634,1519.77000000,1626.17000000,10.71000000,0.00000000,0.00000000,31.99000000); //
    CreateDynamicObject(18790,1555.78000000,1819.72000000,30.97000000,358.66000000,306.22000000,358.18000000); //
    CreateDynamicObject(1634,1532.72000000,1814.18000000,10.04000000,354.75000000,358.74000000,267.88000000); //
    CreateDynamicObject(1634,1533.09000000,1818.29000000,10.04000000,355.24000000,358.99000000,267.91000000); //
    CreateDynamicObject(1634,1533.42000000,1822.27000000,10.04000000,355.74000000,358.98000000,267.91000000); //
    CreateDynamicObject(1634,1533.74000000,1825.86000000,10.04000000,355.99000000,358.98000000,267.91000000); //
    CreateDynamicObject(18789,1472.83000000,1822.18000000,66.33000000,0.00000000,0.00000000,358.25000000); //
    CreateDynamicObject(18789,1326.44000000,1826.68000000,66.33000000,0.00000000,0.00000000,358.24000000); //
    CreateDynamicObject(18801,1262.80000000,1838.24000000,89.33000000,0.00000000,0.00000000,5.50000000); //
    CreateDynamicObject(1634,1445.11000000,1733.24000000,10.71000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1634,1526.29000000,1782.02000000,10.79000000,0.00000000,0.00000000,181.99000000); //
    CreateDynamicObject(1634,1526.44000000,1778.79000000,12.59000000,6.74000000,0.00000000,181.99000000); //
    CreateDynamicObject(18784,1480.04000000,1480.22000000,12.14000000,0.00000000,0.00000000,88.99000000); //
    CreateDynamicObject(18784,1480.05000000,1545.40000000,12.14000000,0.00000000,0.00000000,266.98000000); //
    CreateDynamicObject(18778,1421.98000000,1507.35000000,12.10000000,0.00000000,0.00000000,179.50000000); //
    CreateDynamicObject(18779,1442.37000000,1618.59000000,19.81000000,0.00000000,7.99000000,235.99000000); //
    CreateDynamicObject(18779,1420.30000000,1613.75000000,19.81000000,0.00000000,7.99000000,295.99000000); //
    CreateDynamicObject(18800,1528.68000000,1259.86000000,30.01000000,356.19000000,342.20000000,358.77000000); //
    CreateDynamicObject(1655,1498.17000000,1241.08000000,36.40000000,359.75000000,5.25000000,89.51000000); //
    CreateDynamicObject(1655,1498.20000000,1234.20000000,37.00000000,359.74000000,5.24000000,89.51000000); //
    CreateDynamicObject(17053,1428.87000000,1366.71000000,6.16000000,0.00000000,0.00000000,92.00000000); //
    CreateDynamicObject(18801,1344.08000000,1683.91000000,32.52000000,0.00000000,2.75000000,2.00000000); //
    CreateDynamicObject(1655,1341.71000000,1693.23000000,10.74000000,0.00000000,0.00000000,85.98000000); //
    CreateDynamicObject(1655,1280.84000000,1645.65000000,20.16000000,0.00000000,0.00000000,85.97000000); //
    CreateDynamicObject(1655,1276.61000000,1645.98000000,22.51000000,11.75000000,0.00000000,85.97000000); //
    CreateDynamicObject(1655,1281.26000000,1593.64000000,20.58000000,11.74000000,0.00000000,125.97000000); //
    CreateDynamicObject(1655,1277.29000000,1590.75000000,24.88000000,25.49000000,0.00000000,125.96000000); //
    CreateDynamicObject(18802,1410.58000000,1565.92000000,11.34000000,0.00000000,0.00000000,358.00000000); //
    CreateDynamicObject(18802,1460.71000000,1564.24000000,11.29000000,0.00000000,0.00000000,180.00000000); //
    CreateDynamicObject(3510,1470.21000000,1555.43000000,9.88000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18825,1557.66000000,1691.00000000,23.57000000,0.00000000,346.00000000,182.00000000); //
    CreateDynamicObject(18836,1510.37000000,1191.59000000,14.55000000,0.00000000,0.00000000,30.25000000); //
    CreateDynamicObject(18838,1526.65000000,1164.38000000,21.31000000,0.00000000,352.00000000,122.50000000); //
    CreateDynamicObject(18836,1509.46000000,1190.48000000,32.79000000,6.00000000,0.00000000,33.49000000); //
    CreateDynamicObject(18859,1581.58000000,1411.74000000,20.94000000,0.00000000,0.00000000,288.99000000); //
    CreateDynamicObject(18781,1320.92000000,1486.61000000,21.20000000,2.24000000,359.74000000,104.00000000); //
    CreateDynamicObject(18781,1313.92000000,1484.78000000,33.07000000,48.24000000,359.62000000,104.28000000); //
    CreateDynamicObject(18781,1315.10000000,1485.14000000,43.57000000,80.48000000,358.45000000,105.51000000); //
    CreateDynamicObject(18784,1443.56000000,1504.73000000,12.14000000,0.00000000,0.00000000,88.98000000); //
    CreateDynamicObject(18784,1443.90000000,1524.65000000,12.14000000,0.00000000,0.00000000,268.98000000); //
    CreateDynamicObject(18791,1437.38000000,1844.37000000,23.13000000,352.28000000,339.05000000,105.80000000); //
    CreateDynamicObject(18791,1422.79000000,1870.90000000,33.88000000,344.15000000,338.12000000,128.24000000); //
    CreateDynamicObject(18791,1385.18000000,1894.24000000,47.73000000,336.78000000,344.46000000,155.98000000); //
    CreateDynamicObject(1634,1348.45000000,1895.32000000,53.59000000,13.30000000,338.65000000,88.63000000); //
    CreateDynamicObject(1634,1348.66000000,1898.76000000,55.34000000,16.23000000,337.55000000,90.08000000); //
    CreateDynamicObject(1634,1348.66000000,1898.76000000,55.34000000,16.23000000,337.55000000,90.08000000); //
///================================================================[Mega Stunt #1]======================================================
    CreateObject(18754, -4565.27, 1442.01, 16.86,   0.00, 0.00, 0.00);
    CreateObject(18754, -4565.28, 1690.76, 16.86,   0.00, 0.00, 0.00);
    CreateObject(18754, -4316.55, 1690.75, 16.86,   0.00, 0.00, 0.00);
    CreateObject(18754, -4316.53, 1442.00, 16.86,   0.00, 0.00, 0.00);
    CreateObject(18754, -4316.53, 1193.27, 16.86,   0.00, 0.00, 0.00);
    CreateObject(18754, -4565.28, 1193.27, 16.86,   0.00, 0.00, 0.00);
    CreateObject(18778, -4656.95, 1704.22, 18.44,   0.00, 0.00, 0.00);
    CreateObject(18778, -4641.51, 1704.22, 18.44,   0.00, 0.00, 0.00);
    CreateObject(18778, -4656.96, 1707.43, 19.98,   10.00, 0.00, 0.00);
    CreateObject(18778, -4641.63, 1707.43, 19.98,   10.00, 0.00, 0.00);
    CreateObject(18778, -4656.96, 1711.77, 23.17,   20.00, 0.00, 0.00);
    CreateObject(18778, -4641.64, 1711.77, 23.17,   20.00, 0.00, 0.00);
    CreateObject(19071, -4650.01, 1762.18, 36.78,   0.00, 0.00, 0.00);
    CreateObject(18837, -4644.55, 1816.71, 42.13,   90.00, 0.00, 315.39);
    CreateObject(18783, -4649.88, 1800.22, 34.81,   0.00, 0.00, 0.00);
    CreateObject(18839, -4608.96, 1816.71, 42.13,   90.00, 0.00, 247.81);
    CreateObject(18839, -4575.93, 1783.70, 31.26,   65.00, 0.00, 197.44);
    CreateObject(18836, -4575.29, 1743.86, 22.36,   0.00, 0.00, 355.90);
    CreateObject(18836, -4578.86, 1694.02, 22.36,   0.00, 0.00, 355.90);
    CreateObject(18836, -4581.29, 1657.32, 23.37,   -5.00, 0.00, 355.90);
    CreateObject(18836, -4584.62, 1613.23, 27.42,   -5.00, 0.00, 355.24);
    CreateObject(18836, -4588.03, 1573.79, 30.87,   -5.00, 0.00, 355.24);
    CreateObject(18838, -4585.37, 1540.03, 37.60,   55.00, 0.00, 78.87);
    CreateObject(18838, -4582.04, 1555.59, 46.80,   55.00, 0.00, 256.78);
    CreateObject(18838, -4585.90, 1540.11, 55.96,   55.00, 0.00, 75.52);
    CreateObject(18838, -4582.21, 1555.13, 65.03,   55.00, 0.00, 256.78);
    CreateObject(18838, -4586.10, 1539.71, 73.98,   55.00, 0.00, 75.52);
    CreateObject(18838, -4582.01, 1554.87, 83.10,   55.00, 0.00, 254.46);
    CreateObject(18783, -4601.01, 1546.04, 80.29,   0.00, 0.00, 231.78);
    CreateObject(18781, -4623.03, 1493.06, 25.41,   0.00, 0.00, 0.00);
    CreateObject(18783, -4623.03, 1530.34, 46.76,   0.00, 0.00, 0.00);
    CreateObject(18781, -4623.03, 1559.21, 55.97,   0.00, 0.00, 0.00);
    CreateObject(18783, -4623.03, 1550.10, 46.76,   0.00, 0.00, 0.00);
    CreateObject(18783, -4623.03, 1595.57, 71.80,   15.00, 0.00, 0.00);
    CreateObject(18783, -4623.03, 1614.58, 74.30,   0.00, 0.00, 0.00);
    CreateObject(18783, -4603.25, 1614.58, 74.30,   0.00, 0.00, 0.00);
    CreateObject(18783, -4583.25, 1614.58, 74.30,   0.00, 0.00, 0.00);
    CreateObject(18780, -4548.27, 1614.58, 84.23,   0.00, 0.00, 0.00);
    CreateObject(18783, -4563.60, 1614.58, 74.30,   0.00, 0.00, 0.00);
    CreateObject(18783, -4543.69, 1614.58, 74.30,   0.00, 0.00, 0.00);
    CreateObject(18783, -4523.85, 1614.58, 74.30,   0.00, 0.00, 0.00);
    CreateObject(18847, -4796.37, 1364.80, 18.70,   0.00, 0.00, 90.00);
    CreateObject(18784, -4625.98, 1392.43, 19.47,   0.00, 0.00, 180.00);
    CreateObject(18784, -4636.23, 1392.43, 23.86,   0.00, -15.00, 180.00);
    CreateObject(18784, -4640.84, 1392.43, 27.08,   0.00, -25.00, 180.00);
    CreateObject(18784, -4643.15, 1392.43, 28.92,   0.00, -30.00, 180.00);
    CreateObject(18784, -4646.60, 1392.43, 32.39,   0.00, -40.00, 180.00);
    CreateObject(18830, -4569.32, 1489.58, 17.00,   180.00, 25.00, 0.00);
    CreateObject(18830, -4557.67, 1489.58, 26.74,   180.00, 55.00, 0.00);
    CreateObject(18827, -4569.25, 1392.43, 20.66,   0.00, 0.00, 90.00);
    CreateObject(18809, -4525.39, 1323.79, 31.52,   65.00, 0.00, 0.00);
    CreateObject(18809, -4525.40, 1278.56, 52.64,   65.00, 0.00, 0.00);
    CreateObject(18843, -4525.39, 1211.68, 83.87,   65.00, 0.00, 0.00);
    CreateObject(19071, -4563.71, 1111.81, 19.41,   5.00, 0.00, 90.00);
    CreateObject(19071, -4623.22, 1111.81, 24.61,   5.00, 0.00, 90.00);
    CreateObject(19071, -4679.91, 1111.81, 32.12,   10.00, 0.00, 90.00);
    CreateObject(19071, -4709.09, 1111.81, 41.81,   25.00, 0.00, 90.00);
    CreateObject(19071, -4735.54, 1111.81, 54.69,   30.00, 0.00, 90.00);
    CreateObject(19071, -4780.08, 1111.81, 88.57,   45.00, 0.00, 90.00);
    CreateObject(19071, -4796.74, 1111.81, 105.35,   50.00, 0.00, 90.00);
    CreateObject(19071, -4845.57, 1111.77, 128.38,   0.00, 0.00, 90.00);
    CreateObject(18982, -4914.66, 1111.77, 132.15,   0.00, 0.00, 270.00);
    CreateObject(3499, -4880.87, 1114.67, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.76, 1113.98, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.79, 1112.97, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.23, 1112.06, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.84, 1111.06, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.88, 1109.85, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.93, 1108.90, 126.47,   75.00, 0.00, 90.00);
    CreateObject(18982, -5014.63, 1111.77, 132.15,   0.00, 0.00, 270.00);
    CreateObject(18982, -5114.63, 1111.76, 132.15,   0.00, 0.00, 270.00);
    CreateObject(18987, -5173.47, 1111.67, 132.14,   90.00, 0.00, 270.00);
    CreateObject(18991, -5193.90, 1119.63, 132.14,   90.00, 0.00, 0.00);
    CreateObject(18985, -5135.99, 1127.59, 132.14,   0.00, 0.00, 90.00);
    CreateObject(18985, -5036.01, 1127.59, 132.14,   0.00, 0.00, 90.00);
    CreateObject(18985, -4936.04, 1127.59, 132.14,   0.00, 0.00, 90.00);
    CreateObject(18985, -4836.36, 1127.59, 132.14,   0.00, 0.00, 90.00);
    CreateObject(18985, -4736.40, 1127.59, 132.14,   0.00, 0.00, 90.00);
    CreateObject(18991, -4678.86, 1127.62, 140.03,   0.00, 0.00, 180.00);
    CreateObject(18991, -4694.61, 1119.66, 147.98,   90.00, 0.00, 0.00);
    CreateObject(18999, -4586.80, 1111.69, 147.97,   90.00, 0.00, 90.00);
    CreateObject(19000, -4386.80, 1111.69, 147.97,   90.00, 0.00, 90.00);
    CreateObject(18844, -4237.86, 1111.59, 147.97,   90.00, 0.00, 90.00);
    CreateObject(19001, -4452.22, 1506.89, 27.30,   0.00, 0.00, 90.00);
    CreateObject(19005, -4447.35, 1488.72, 18.00,   0.00, 0.00, 180.00);
    CreateObject(19005, -4435.02, 1488.73, 18.00,   0.00, 0.00, 180.00);
    CreateObject(19005, -4400.77, 1541.60, 22.75,   10.00, 0.00, 180.00);
    CreateObject(19005, -4400.79, 1541.34, 23.47,   15.00, 0.00, 180.00);
    CreateObject(19005, -4400.82, 1539.62, 24.63,   20.00, 0.00, 180.00);
    CreateObject(19005, -4400.86, 1537.43, 26.59,   30.00, 0.00, 180.00);
    CreateObject(18778, -4378.43, 1665.37, 18.77,   0.00, 0.00, 0.00);
    CreateObject(18778, -4378.42, 1667.24, 19.60,   5.00, 0.00, 0.00);
    CreateObject(18778, -4378.42, 1670.87, 21.76,   15.00, 0.00, 0.30);
    CreateObject(18778, -4378.44, 1674.82, 25.25,   25.00, 0.00, 0.30);
    CreateObject(3499, -4810.18, 1124.79, 126.47,   75.00, 0.00, 270.00);
    CreateObject(3499, -4810.24, 1125.45, 126.47,   75.00, 0.00, 270.00);
    CreateObject(3499, -4810.20, 1126.22, 126.47,   75.00, 0.00, 270.00);
    CreateObject(3499, -4810.15, 1127.03, 126.47,   75.00, 0.00, 270.00);
    CreateObject(3499, -4810.13, 1127.84, 126.47,   75.00, 0.00, 270.00);
    CreateObject(3499, -4810.03, 1128.82, 126.47,   75.00, 0.00, 270.00);
    CreateObject(3499, -4810.00, 1129.77, 126.47,   75.00, 0.00, 270.00);
    CreateObject(3499, -4880.42, 1130.33, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.52, 1129.57, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.62, 1128.70, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.56, 1127.85, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.63, 1126.71, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.73, 1125.63, 126.47,   75.00, 0.00, 90.00);
    CreateObject(3499, -4880.84, 1124.68, 126.47,   75.00, 0.00, 90.00);
    CreateObject(18855, -4214.75, 1655.59, 34.43,   65.00, 0.00, 209.43);
    CreateObject(18855, -4275.77, 1627.90, 61.22,   65.00, 0.00, 19.37);
    CreateObject(18855, -4214.11, 1647.80, 88.06,   65.00, 0.00, 196.40);
    CreateObject(18855, -4272.79, 1628.85, 114.96,   65.00, 0.00, 19.37);
    CreateObject(18828, -4275.92, 1386.66, 91.00,   0.00, 0.00, 136.93);
    CreateObject(18845, -4298.38, 1427.62, 201.85,   0.00, 0.00, 230.96);
    CreateObject(18783, -4305.06, 1420.30, 159.72,   0.00, 0.00, 0.00);
    CreateObject(19005, -4303.53, 1420.09, 157.02,   0.00, 0.00, 325.45);
    CreateObject(18801, -4254.67, 1192.19, 40.41,   0.00, 0.00, 75.67);
    CreateObject(18788, -4272.18, 1176.73, 16.64,   0.00, 0.00, 65.61);
    CreateObject(18801, -4290.24, 1160.05, 40.41,   0.00, 0.00, 75.67);
    CreateObject(18788, -4308.22, 1143.52, 16.64,   0.00, 0.00, 65.61);
    CreateObject(18801, -4323.76, 1132.47, 40.41,   0.00, 0.00, 75.67);
    CreateObject(18788, -4341.17, 1117.23, 16.64,   0.00, 0.00, 65.61);
    CreateObject(18801, -4357.17, 1105.19, 40.41,   0.00, 0.00, 75.67);
    CreateObject(18788, -4375.07, 1088.80, 16.64,   0.00, 0.00, 65.61);
    CreateObject(18788, -4391.52, 1052.49, 16.64,   0.00, 0.00, 65.61);
    CreateObject(18788, -4401.25, 1031.02, 18.02,   0.00, 5.00, 65.61);
    CreateObject(18788, -4399.75, 1034.19, 18.02,   0.00, 10.00, 65.61);
    CreateObject(18788, -4400.86, 1031.73, 18.02,   0.00, 15.00, 65.61);
    CreateObject(18788, -4404.32, 1024.06, 19.98,   0.00, 25.00, 65.61);
    CreateObject(18788, -4408.54, 1014.76, 24.15,   0.00, 30.00, 65.61);
    CreateObject(18788, -4418.30, 993.23, 37.79,   0.00, 30.00, 65.61);
    CreateObject(18788, -4433.53, 959.67, 47.68,   0.00, 0.00, 65.61);
    CreateObject(18800, -4470.66, 930.88, 59.47,   0.00, 0.00, 247.23);
    CreateObject(18788, -4473.05, 982.73, 71.03,   0.00, 0.00, 65.61);
    CreateObject(18788, -4457.87, 1015.91, 61.00,   0.00, 30.00, 65.61);
    CreateObject(18788, -4444.43, 1045.62, 42.18,   0.00, 30.00, 65.61);
    CreateObject(18788, -4439.29, 1056.85, 35.03,   0.00, 25.00, 65.61);
    CreateObject(18788, -4434.94, 1066.47, 30.11,   0.00, 20.00, 65.61);
    CreateObject(18788, -4429.78, 1077.86, 24.76,   0.00, 12.00, 65.61);
    CreateObject(18788, -4421.48, 1096.12, 20.50,   0.00, 12.00, 65.61);
    CreateObject(18788, -4418.89, 1101.85, 18.05,   0.00, 5.00, 65.61);
    CreateObject(18788, -4410.13, 1121.24, 16.50,   0.00, 0.00, 65.81);
    CreateObject(18788, -4393.77, 1157.67, 16.50,   0.00, 0.00, 65.81);
    CreateObject(18829, -4326.92, 1252.40, 22.10,   0.00, 90.00, 90.00);
    CreateObject(18829, -4326.96, 1302.40, 22.10,   0.00, 90.00, 90.00);
    CreateObject(18831, -4326.98, 1338.23, 26.78,   0.00, -45.00, 270.00);
    CreateObject(18831, -4326.98, 1338.23, 49.20,   0.00, 45.00, 270.00);
    CreateObject(18831, -4322.39, 1316.33, 53.92,   90.00, 45.00, 0.00);
    CreateObject(18831, -4300.98, 1316.29, 53.92,   90.00, 45.00, 90.00);
    CreateObject(18831, -4291.67, 1338.53, 53.92,   90.00, 45.00, 270.00);
    CreateObject(18831, -4269.38, 1347.84, 53.92,   90.00, 45.00, 90.00);
    CreateObject(18833, -4266.94, 1383.40, 53.94,   90.00, 0.00, 196.22);
    CreateObject(18829, -4293.49, 1425.23, 53.94,   90.00, 0.00, 217.31);
    CreateObject(18831, -4315.79, 1452.64, 58.53,   0.00, -45.00, 313.69);
    CreateObject(18831, -4319.04, 1451.37, 80.66,   0.00, 45.00, 270.00);
    CreateObject(18750, -4432.55, 1809.59, 35.76,   90.00, 0.00, 0.00);
    CreateObject(18855, -4213.83, 1650.00, 141.79,   65.00, 0.00, 200.15);
    CreateObject(18855, -4291.96, 1683.15, 141.78,   65.00, 0.00, 19.37);
    CreateObject(18855, -4251.54, 1758.95, 114.87,   -65.00, 0.00, 200.15);
    CreateObject(18855, -4311.76, 1737.27, 87.95,   -65.00, 0.00, 19.37);
    CreateObject(18855, -4252.61, 1758.50, 61.04,   -65.00, 0.00, 200.15);
    CreateObject(18855, -4311.76, 1737.27, 34.14,   -65.00, 0.00, 19.37);
    CreateObject(18855, -4232.67, 1701.25, 20.73,   90.00, 0.00, 200.15);
    CreateObject(18855, -4291.49, 1677.37, 31.56,   650.00, 0.00, 20.50);
    CreateObject(18855, -4230.92, 1703.44, 53.31,   -70.00, 0.00, 205.95);
    CreateObject(18855, -4259.63, 1624.32, 82.40,   55.00, 0.00, 30.97);
    CreateObject(18855, -4203.14, 1657.36, 114.07,   65.00, 0.00, 204.75);
    CreateObject(18855, -4261.29, 1631.42, 140.89,   65.00, 0.00, 23.40);
    CreateObject(18855, -4183.16, 1599.16, 167.70,   -65.00, 0.00, 197.36);
    CreateObject(18855, -4224.49, 1524.15, 189.29,   75.00, 90.00, 285.21);
    CreateObject(18855, -4158.07, 1529.32, 163.00,   -55.00, 0.00, 183.71);
    CreateObject(18855, -4223.05, 1528.47, 126.54,   -55.00, 0.00, 357.79);
    CreateObject(18855, -4159.34, 1525.44, 90.05,   -55.00, 0.00, 176.74);
    CreateObject(18855, -4224.13, 1528.41, 85.13,   65.00, 0.00, 353.06);
    CreateObject(18855, -4160.68, 1512.25, 76.06,   -45.00, 0.00, 169.27);
    CreateObject(18855, -4215.12, 1572.48, 40.04,   65.00, 0.00, 353.06);
    CreateObject(18855, -4149.89, 1564.81, 26.56,   90.00, 0.00, 178.63);
    CreateObject(18852, -4232.25, 1533.70, 26.54,   90.00, 0.00, 90.00);
    CreateObject(18852, -4331.01, 1533.74, 22.24,   -95.00, 0.00, 90.00);
    CreateObject(18790, -4484.99, 1646.23, 17.10,   0.00, 0.00, 90.00);
    CreateObject(18800, -4461.98, 1567.61, 29.61,   0.00, 0.00, 270.00);
    CreateObject(18800, -4507.82, 1723.61, 29.71,   0.00, 0.00, 90.00);
    CreateObject(3499, -4433.83, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4434.78, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4435.73, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4436.70, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4437.63, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4438.78, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4439.93, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4441.10, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4442.19, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4443.28, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4444.40, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4445.45, 1602.71, 16.82,   75.00, 0.00, 0.00);
    CreateObject(3499, -4536.05, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4535.03, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4534.01, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4533.07, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4531.91, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4530.74, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4529.49, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4528.22, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4527.23, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4526.19, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(3499, -4524.94, 1688.46, 16.82,   75.00, 0.00, 180.00);
    CreateObject(18783, -4613.39, 1530.32, 80.29,   0.00, 0.00, 231.78);
    CreateObject(18783, -4625.77, 1514.61, 80.29,   0.00, 0.00, 231.78);
    CreateObject(18783, -4638.13, 1498.89, 80.29,   0.00, 0.00, 231.78);
    CreateObject(18778, -4638.66, 1496.86, 83.37,   0.00, 0.00, -231.78);
    CreateObject(18778, -4641.23, 1494.85, 84.95,   10.00, 0.00, -231.78);
    CreateObject(18778, -4642.68, 1493.72, 86.11,   20.00, 0.00, -231.78);
    CreateObject(18783, -4665.55, 1476.33, 103.40,   0.00, 0.00, -231.78);
    CreateObject(18783, -4653.18, 1460.62, 103.40,   0.00, 0.00, -231.78);
    CreateObject(18783, -4640.81, 1444.91, 103.40,   0.00, 0.00, -231.78);
    CreateObject(18778, -4633.71, 1436.79, 107.34,   0.00, 0.00, 226.40);
    CreateObject(18778, -4631.70, 1434.88, 108.78,   10.00, 0.00, 226.40);
    CreateObject(18778, -4630.79, 1434.02, 109.72,   20.00, 0.00, 226.40);
    CreateObject(18778, -4644.73, 1492.10, 88.57,   30.00, 0.00, -231.78);
    CreateObject(19146, -4589.91, 1548.85, 92.60,   -10.00, 0.00, 115.00);
    CreateObject(19147, -4590.53, 1548.88, 92.60,   -10.00, 0.00, 115.00);
    CreateObject(19148, -4591.07, 1549.21, 92.60,   -10.00, 0.00, 115.00);
    CreateObject(19149, -4591.61, 1549.30, 92.60,   -10.00, 0.00, 115.00);
    CreateObject(19005, -4304.31, 1422.88, 158.47,   -15.00, 0.00, 140.18);
    CreateObject(3499, -4407.88, 1751.33, 17.00,   0.00, 0.00, 0.00);
    CreateObject(3499, -4407.87, 1756.57, 21.89,   90.00, 0.00, 0.00);
    CreateObject(3499, -4407.72, 1761.76, 17.00,   0.00, 0.00, 0.00);
    CreateObject(3499, -4397.26, 1751.14, 17.00,   0.00, 0.00, 0.00);
    CreateObject(3499, -4397.25, 1756.40, 21.89,   90.00, 0.00, 0.00);
    CreateObject(3499, -4402.52, 1761.56, 21.89,   90.00, 0.00, 90.00);
    CreateObject(3499, -4397.27, 1761.66, 17.00,   0.00, 0.00, 0.00);
    CreateObject(18766, -4402.44, 1754.78, 21.89,   90.00, 0.00, 0.00);
    CreateObject(18766, -4402.52, 1759.12, 21.89,   90.00, 0.00, 0.00);
    CreateObject(18766, -4402.55, 1750.17, 21.10,   -70.00, 0.00, 0.00);
    CreateObject(18766, -4402.55, 1745.67, 19.46,   -70.00, 0.00, 0.00);
    CreateObject(18766, -4402.55, 1741.01, 17.76,   -70.00, 0.00, 0.00);
    CreateObject(3524, -4397.31, 1751.14, 20.74,   0.00, 0.00, 314.93);
    CreateObject(3524, -4407.87, 1751.35, 20.74,   0.00, 0.00, 46.90);
    CreateObject(3524, -4407.82, 1761.84, 20.74,   0.00, 0.00, 46.90);
    CreateObject(3524, -4397.29, 1761.55, 20.74,   0.00, 0.00, 314.93);
///==========================================[Дрифт зона ОСТРОВ в /drift вроде 4 зона]=================================
	CreateDynamicObject(16109,3293.72753906,-3169.38964844,21.25000000,0.00000000,0.00000000,0.00000000); //object(radar_bit_03) (1)
	CreateDynamicObject(16109,3418.80566406,-3008.86816406,62.30300140,0.00000000,0.20001221,59.54589844); //object(radar_bit_03) (2)
	CreateDynamicObject(16109,3130.50561523,-3071.67138672,21.24720001,0.00000000,0.00000000,178.65002441); //object(radar_bit_03) (3)
	CreateDynamicObject(16147,3169.63061523,-3048.02563477,18.04222870,354.04504395,0.00000000,180.00000000); //object(radar_bit_02) (2)
	CreateDynamicObject(16147,3155.78295898,-2989.48852539,30.49109650,354.04504395,0.00000000,225.65502930); //object(radar_bit_02) (3)
	CreateDynamicObject(16169,3378.55151367,-3130.33178711,-0.98841667,0.00000000,5.74987793,99.25006104); //object(n_bit_14) (1)
	CreateDynamicObject(16192,3421.59350586,-3090.57495117,31.72991562,0.00000000,0.00000000,324.26995850); //object(cen_bit_01) (2)
	CreateDynamicObject(16192,3430.08520508,-3266.16650391,37.87557983,0.00000000,0.00000000,186.59002686); //object(cen_bit_01) (3)
	CreateDynamicObject(16192,3199.90869141,-3244.34765625,-17.62492561,0.00000000,358.01501465,190.55926514); //object(cen_bit_01) (4)
	CreateDynamicObject(16192,3259.86596680,-3254.08935547,-25.27211380,0.00000000,350.07507324,260.03430176); //object(cen_bit_01) (5)
	CreateDynamicObject(16192,3346.28686523,-3277.55395508,-20.52541351,0.00000000,350.07507324,256.06433105); //object(cen_bit_01) (6)
	CreateDynamicObject(16192,3145.56518555,-3182.53271484,6.31226158,0.00000000,352.06005859,13.17846680); //object(cen_bit_01) (7)
	CreateDynamicObject(16133,3193.57031250,-3139.28930664,2.46150875,0.00000000,354.04504395,244.15246582); //object(des_rockgp2_18) (1)
	CreateDynamicObject(16133,3214.08642578,-3154.11694336,7.51510429,0.00000000,352.06005859,210.40747070); //object(des_rockgp2_18) (2)
	CreateDynamicObject(16133,3205.68823242,-3092.13500977,4.79844284,0.00000000,7.93994141,11.19165039); //object(des_rockgp2_18) (3)
	CreateDynamicObject(16133,3230.64184570,-3099.53320312,2.52258492,0.00000000,7.93994141,295.76165771); //object(des_rockgp2_18) (4)
	CreateDynamicObject(16133,3318.99707031,-3057.94042969,37.95656204,1.98303223,13.89221191,166.01989746); //object(des_rockgp2_18) (6)
	CreateDynamicObject(16133,3295.60302734,-3266.21508789,13.59748077,1.98498535,352.06005859,257.33111572); //object(des_rockgp2_18) (7)
	CreateDynamicObject(16097,3384.19165039,-3100.31079102,-5.65186310,3.97000122,1.98498535,1.26928711); //object(n_bit_16) (2)
	CreateDynamicObject(16097,3182.49511719,-3327.07495117,16.89935493,0.00000000,1.98498535,315.61425781); //object(n_bit_16) (3)
	CreateDynamicObject(16192,3160.74609375,-3305.59350586,-17.18136978,0.00000000,354.04504395,76.69848633); //object(cen_bit_01) (9)
	CreateDynamicObject(16192,3400.16088867,-3352.41210938,-27.34200287,0.00000000,354.04504395,100.51849365); //object(cen_bit_01) (10)
	CreateDynamicObject(16192,3431.75854492,-3339.89599609,-28.11530685,0.00000000,354.04504395,84.63848877); //object(cen_bit_01) (11)
	CreateDynamicObject(16192,3492.65405273,-3320.65234375,-20.04432678,0.00000000,354.04504395,134.26351929); //object(cen_bit_01) (12)
	CreateDynamicObject(16192,3514.64355469,-3241.60229492,-16.08846474,0.00000000,354.04504395,168.00848389); //object(cen_bit_01) (14)
	CreateDynamicObject(16192,3528.14965820,-3122.39282227,30.61719513,0.00000000,356.03002930,238.75097656); //object(cen_bit_01) (15)
	CreateDynamicObject(16192,3553.82080078,-3104.39477539,22.30434036,354.04504395,356.03002930,138.06649780); //object(cen_bit_01) (16)
	CreateDynamicObject(16192,3616.69238281,-2987.59130859,26.73355865,0.00000000,356.03002930,231.36151123); //object(cen_bit_01) (17)
	CreateDynamicObject(16192,3513.43041992,-2907.39208984,52.00254059,0.00000000,356.03002930,238.58398438); //object(cen_bit_01) (18)
	CreateDynamicObject(16192,3446.62060547,-2870.46362305,51.43860626,0.00000000,356.03002930,250.49401855); //object(cen_bit_01) (19)
	CreateDynamicObject(16192,3328.97753906,-2950.98095703,47.76010132,0.00000000,354.04504395,268.35888672); //object(cen_bit_01) (20)
	CreateDynamicObject(16192,3299.39282227,-3012.00537109,24.26906204,0.00000000,354.04504395,282.25378418); //object(cen_bit_01) (21)
	CreateDynamicObject(16133,3236.81738281,-3085.41992188,24.90491486,1.98498535,13.89489746,193.81115723); //object(des_rockgp2_18) (8)
	CreateDynamicObject(16097,3259.48632812,-3058.86132812,50.58118439,0.00000000,0.00000000,260.03442383); //object(n_bit_16) (4)
	CreateDynamicObject(16097,3256.91796875,-3273.46093750,17.27640533,0.00000000,0.00000000,343.40380859); //object(n_bit_16) (5)
	CreateDynamicObject(16097,3156.37060547,-3063.18017578,4.97239304,0.00000000,0.00000000,244.15441895); //object(n_bit_16) (6)
	CreateDynamicObject(16097,3185.33764648,-2943.00024414,28.27877808,0.00000000,0.00000000,198.49938965); //object(n_bit_16) (7)
	CreateDynamicObject(16192,3636.28442383,-2875.46948242,-3.45599556,0.00000000,356.03002930,231.36151123); //object(cen_bit_01) (22)
	CreateDynamicObject(16192,3548.95336914,-2828.78588867,-15.45046425,0.00000000,356.03002930,219.45153809); //object(cen_bit_01) (23)
	CreateDynamicObject(16192,3446.62377930,-2760.26586914,-4.13566780,0.00000000,356.03002930,255.18151855); //object(cen_bit_01) (24)
	CreateDynamicObject(16192,3320.89282227,-2884.15795898,66.18688965,0.00000000,356.03002930,282.97131348); //object(cen_bit_01) (25)
	CreateDynamicObject(16192,3332.74194336,-2765.81030273,-1.90367222,0.00000000,354.04504395,282.97131348); //object(cen_bit_01) (26)
	CreateDynamicObject(16192,3238.82763672,-2814.40234375,0.86692715,0.00000000,354.04504395,318.70104980); //object(cen_bit_01) (27)
	CreateDynamicObject(16192,3227.22900391,-2848.19531250,45.91938782,0.00000000,354.04504395,350.46081543); //object(cen_bit_01) (28)
	CreateDynamicObject(16097,3254.63012695,-2919.09545898,68.70491791,0.00000000,356.03002930,73.44433594); //object(n_bit_16) (8)
	CreateDynamicObject(16192,3067.17309570,-2882.31933594,38.99808884,0.00000000,348.09008789,79.78515625); //object(cen_bit_01) (29)
	CreateDynamicObject(16192,2994.80371094,-3027.93823242,17.58457184,0.00000000,348.09008789,358.40014648); //object(cen_bit_01) (30)
	CreateDynamicObject(16192,2996.31494141,-3093.36425781,18.03097916,0.00000000,350.07507324,354.43017578); //object(cen_bit_01) (31)
	CreateDynamicObject(16192,3008.74609375,-2902.95947266,14.45249748,0.00000000,348.09008789,352.44519043); //object(cen_bit_01) (32)
	CreateDynamicObject(16192,3194.90673828,-2731.33911133,16.78513336,0.00000000,354.04504395,10.31015015); //object(cen_bit_01) (33)
	CreateDynamicObject(16192,3040.35131836,-2768.82275391,12.58029175,0.00000000,354.04504395,67.87515259); //object(cen_bit_01) (34)
	CreateDynamicObject(16192,2935.19165039,-2841.44042969,-17.71456528,0.00000000,354.04504395,93.68017578); //object(cen_bit_01) (35)
	CreateDynamicObject(16097,3036.77734375,-3168.94213867,46.21961975,0.00000000,0.00000000,1.98431396); //object(n_bit_16) (9)
	CreateDynamicObject(16192,2989.79882812,-3263.80615234,30.62277222,0.00000000,348.09008789,81.77008057); //object(cen_bit_01) (36)
	CreateDynamicObject(16097,3351.19970703,-3152.77416992,43.66624451,0.00000000,0.00000000,236.21441650); //object(n_bit_16) (10)
	CreateDynamicObject(16097,3061.76660156,-2968.45166016,35.60267639,0.00000000,0.00000000,297.74914551); //object(n_bit_16) (11)
	CreateObject(16771,3086.35229492,-3178.98095703,53.20843506,0.00000000,0.00000000,0.00000000); //object(des_savhangr) (1)
	CreateDynamicObject(16192,3065.23364258,-3275.68457031,37.27136230,0.00000000,348.09008789,71.84509277); //object(cen_bit_01) (37)
	CreateDynamicObject(16133,3119.56933594,-3173.56176758,34.75222015,0.00000000,3.96997070,174.67749023); //object(des_rockgp2_18) (9)
	CreateDynamicObject(16133,3097.27636719,-3210.57128906,36.37182617,0.00000000,3.96606445,83.36425781); //object(des_rockgp2_18) (10)
	CreateDynamicObject(16133,3055.35351562,-3177.54882812,34.41638947,0.00000000,3.96606445,174.67712402); //object(des_rockgp2_18) (11)
	CreateDynamicObject(16097,3091.10742188,-2706.37182617,-14.64836884,0.00000000,0.00000000,297.74914551); //object(n_bit_16) (1)
	CreateDynamicObject(16097,3155.36230469,-2847.86303711,56.39349747,0.00000000,0.00000000,325.53894043); //object(n_bit_16) (12)
	CreateDynamicObject(16097,3561.30664062,-3012.59155273,49.25526428,0.00000000,0.00000000,236.21441650); //object(n_bit_16) (13)
	CreateDynamicObject(16192,3712.32348633,-3064.62866211,-5.94915962,0.00000000,356.03002930,231.36151123); //object(cen_bit_01) (1)
	CreateDynamicObject(16192,2875.02050781,-3185.36181641,-27.84468651,0.00000000,0.00000000,81.77008057); //object(cen_bit_01) (8)
	CreateDynamicObject(16192,3113.37304688,-3346.97558594,-0.64605331,0.00000000,346.10510254,125.44009399); //object(cen_bit_01) (13)
	CreateDynamicObject(16097,3169.04296875,-3341.40576172,17.52517700,0.00000000,1.98498535,315.61425781); //object(n_bit_16) (15)
	CreateDynamicObject(16097,3110.42822266,-3345.72363281,-48.50517654,0.00000000,3.96997070,88.60827637); //object(n_bit_16) (16)
	CreateDynamicObject(5005,3035.98608398,-3154.62158203,44.61174774,245.00000000,0.00000000,0.00000000); //object(lasrunwall1_las) (3)
	CreateDynamicObject(713,3121.73315430,-2976.10449219,23.05955315,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (1)
	CreateDynamicObject(713,3195.07666016,-3128.91821289,6.14409542,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (3)
	CreateDynamicObject(713,3323.04199219,-3258.28466797,24.49352646,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (4)
	CreateDynamicObject(713,3250.57983398,-3119.58496094,31.83481598,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (5)
	CreateDynamicObject(713,3329.60766602,-3152.41259766,42.54951477,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (7)
	CreateDynamicObject(713,3502.85400391,-3050.09057617,63.91354370,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (8)
	CreateDynamicObject(713,3350.33593750,-3020.76562500,73.06049347,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (9)
	CreateDynamicObject(713,3458.55444336,-2968.33227539,83.54203796,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (10)
	CreateDynamicObject(652,3362.65332031,-2937.66577148,87.35626221,0.00000000,0.00000000,59.54998779); //object(sjmpalmbig) (1)
	CreateDynamicObject(652,3358.80444336,-2975.98413086,76.03807831,0.00000000,0.00000000,0.00000000); //object(sjmpalmbig) (2)
	CreateDynamicObject(652,3376.47900391,-3058.63256836,50.48693848,0.00000000,0.00000000,0.00000000); //object(sjmpalmbig) (3)
	CreateDynamicObject(652,3329.61523438,-3042.76513672,46.83695602,0.00000000,0.00000000,0.00000000); //object(sjmpalmbig) (4)
	CreateDynamicObject(652,3251.35742188,-3200.14721680,15.68209457,0.00000000,0.00000000,0.00000000); //object(sjmpalmbig) (5)
	CreateDynamicObject(652,3230.14965820,-3114.70043945,7.21575928,0.00000000,0.00000000,232.96002197); //object(sjmpalmbig) (6)
	CreateDynamicObject(652,3167.42651367,-3145.49072266,33.22251129,0.00000000,0.00000000,146.89001465); //object(sjmpalmbig) (8)
	CreateDynamicObject(652,3073.91967773,-3055.75048828,42.25520325,0.00000000,0.00000000,276.62994385); //object(sjmpalmbig) (9)
	CreateDynamicObject(774,3072.31372070,-3003.63623047,26.13934517,0.00000000,0.00000000,0.00000000); //object(elmsparse_hi) (1)
	CreateDynamicObject(774,3131.04858398,-3025.17602539,23.82796288,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (2)
	CreateDynamicObject(774,3273.15942383,-3239.93652344,20.68541718,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (3)
	CreateDynamicObject(774,3293.71557617,-3216.75854492,22.14736176,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (4)
	CreateDynamicObject(774,3300.15429688,-3094.35498047,41.02587509,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (5)
	CreateDynamicObject(774,3510.26464844,-2987.95922852,65.94020081,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (6)
	CreateDynamicObject(774,3378.88061523,-2960.81738281,81.55638885,0.00000000,0.00000000,85.35504150); //object(elmsparse_hi) (7)
	CreateDynamicObject(774,3416.21582031,-2969.20849609,82.93252563,0.00000000,0.00000000,129.02502441); //object(elmsparse_hi) (8)
	CreateDynamicObject(750,3094.59716797,-3079.77148438,42.61096191,0.00000000,0.00000000,0.00000000); //object(sm_scrb_column2) (1)
	CreateDynamicObject(750,3122.61743164,-3004.35595703,23.33788490,0.00000000,0.00000000,0.00000000); //object(sm_scrb_column2) (2)
	CreateDynamicObject(750,3304.64941406,-3238.89208984,23.94256973,0.00000000,0.00000000,0.00000000); //object(sm_scrb_column2) (3)
	CreateDynamicObject(774,3094.41650391,-3086.68603516,42.48906326,0.00000000,0.00000000,71.46002197); //object(elmsparse_hi) (9)
	CreateDynamicObject(774,3097.70581055,-3130.49584961,43.68058395,0.00000000,0.00000000,71.46002197); //object(elmsparse_hi) (10)
	CreateDynamicObject(713,3120.56298828,-3147.60449219,42.42094803,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (11)
	CreateDynamicObject(5409,3088.12060547,-2974.31347656,28.44096947,359.00000000,1.00000000,354.24505615); //object(laepetrol1a) (1)
	CreateDynamicObject(1686,3110.62963867,-2976.84008789,23.71279335,0.00000000,0.00000000,354.04498291); //object(petrolpumpnew) (1)
	CreateDynamicObject(1686,3111.35815430,-2969.45703125,23.58357430,0.00000000,0.00000000,356.03002930); //object(petrolpumpnew) (2)
	CreateDynamicObject(1225,3119.94799805,-2976.60546875,23.55832672,0.00000000,0.00000000,0.00000000); //object(barrel4) (1)
	CreateDynamicObject(1225,3118.64868164,-2976.85302734,23.62574387,0.00000000,0.00000000,0.00000000); //object(barrel4) (2)
	CreateDynamicObject(1225,3117.25683594,-2976.91284180,23.69744682,0.00000000,0.00000000,0.00000000); //object(barrel4) (4)
	CreateDynamicObject(1225,3115.42626953,-2976.73339844,23.79113960,0.00000000,0.00000000,0.00000000); //object(barrel4) (5)
	CreateDynamicObject(3286,3326.81127930,-3240.99707031,29.39734077,0.00000000,0.00000000,181.34996033); //object(cxrf_watertwr) (1)
	CreateDynamicObject(3927,3386.87622070,-2946.61157227,87.84114838,0.00000000,0.00000000,65.50500488); //object(d_sign01) (1)
	CreateDynamicObject(3337,3474.52246094,-3012.29931641,66.91246033,0.00000000,358.01498413,355.31433105); //object(cxrf_desertsig) (1)
	CreateDynamicObject(2960,3099.04443359,-3157.23974609,56.94538498,0.00000000,298.46496582,0.00000000); //object(kmb_beam) (2)
	CreateDynamicObject(2960,3097.02124023,-3157.24731445,57.19212341,0.00000000,248.84027100,0.00000000); //object(kmb_beam) (3)
	CreateDynamicObject(2960,3095.29248047,-3157.29003906,56.99952316,0.00000000,91.31002808,0.00000000); //object(kmb_beam) (4)
	CreateDynamicObject(2960,3092.80468750,-3157.23876953,58.85164261,0.00000000,178.65002441,0.00000000); //object(kmb_beam) (5)
	CreateDynamicObject(2960,3092.80468750,-3157.27465820,57.25843048,0.00000000,178.65002441,0.00000000); //object(kmb_beam) (6)
	CreateDynamicObject(2960,3092.79125977,-3157.26904297,55.23782349,0.00000000,180.63500977,0.00000000); //object(kmb_beam) (7)
	CreateDynamicObject(2960,3088.70776367,-3157.21875000,57.04912186,0.00000000,269.95996094,0.00000000); //object(kmb_beam) (8)
	CreateDynamicObject(2960,3086.49511719,-3157.23583984,58.62276459,0.00000000,168.72497559,0.00000000); //object(kmb_beam) (9)
	CreateDynamicObject(2960,3086.52124023,-3157.27465820,57.61690903,0.00000000,188.57501221,0.00000000); //object(kmb_beam) (10)
	CreateDynamicObject(2960,3086.82202148,-3157.25585938,56.04747391,0.00000000,148.87500000,0.00000000); //object(kmb_beam) (11)
	CreateDynamicObject(2960,3083.32543945,-3157.29711914,57.09838486,0.00000000,91.30996704,0.00000000); //object(kmb_beam) (12)
	CreateDynamicObject(2960,3081.10791016,-3157.24536133,59.19356537,0.00000000,180.63500977,0.00000000); //object(kmb_beam) (13)
	CreateDynamicObject(2960,3078.75024414,-3157.26391602,57.03874588,0.00000000,269.95996094,0.00000000); //object(kmb_beam) (14)
	CreateDynamicObject(2960,3080.97387695,-3157.27465820,55.44621658,0.00000000,359.28430176,0.00000000); //object(kmb_beam) (15)
	CreateDynamicObject(2960,3077.85986328,-3157.22680664,57.19897842,0.00000000,90.59362793,0.00000000); //object(kmb_beam) (16)
	CreateDynamicObject(2960,3076.10546875,-3157.20922852,57.20688248,0.00000000,132.27871704,0.00000000); //object(kmb_beam) (17)
	CreateDynamicObject(2960,3074.45605469,-3157.25024414,57.20158768,0.00000000,88.60864258,0.00000000); //object(kmb_beam) (18)
	CreateDynamicObject(2960,3072.51367188,-3157.22851562,57.30870819,0.00000000,60.81863403,0.00000000); //object(kmb_beam) (19)
	CreateDynamicObject(2960,3070.12841797,-3157.29516602,57.17990112,0.00000000,122.35363770,0.00000000); //object(kmb_beam) (20)
	CreateDynamicObject(2960,3071.36059570,-3157.20654297,56.54159546,0.00000000,179.91857910,0.00000000); //object(kmb_beam) (21)
	CreateDynamicObject(16097,3327.70410156,-2877.06835938,36.49160004,0.00000000,0.00000000,325.53894043); //object(n_bit_16) (14)
	CreateDynamicObject(16133,3055.74682617,-3184.29248047,32.15997696,0.00000000,3.96606445,174.67712402); //object(des_rockgp2_18) (11)
	CreateDynamicObject(16133,3307.51928711,-3049.72509766,27.08466339,1.98303223,13.89221191,233.50988770); //object(des_rockgp2_18) (6)
	CreateDynamicObject(16133,3106.07153320,-3204.89428711,25.72065735,0.00000000,3.96606445,81.37927246); //object(des_rockgp2_18) (10)
	CreateDynamicObject(16133,3077.81713867,-3208.11889648,65.89302063,0.00000000,3.96606445,81.37573242); //object(des_rockgp2_18) (10)
///=======================================[Drift 5 HARD]================================================================================
	CreateDynamicObject(18800, 964.83, 1459.83, 20.68,   0.00, 0.00, 269.00);
	CreateDynamicObject(18800, 965.50, 1517.51, 44.20,   0.00, 0.00, 89.22);
	CreateDynamicObject(18800, 964.83, 1459.83, 67.72,   0.00, 0.00, 269.00);
	CreateDynamicObject(18800, 965.38, 1514.54, 91.25,   0.00, 0.00, 89.42);
	CreateDynamicObject(18800, 964.83, 1459.83, 114.84,   0.00, 0.00, 269.00);
	CreateDynamicObject(18800, 965.38, 1514.54, 138.40,   0.00, 0.00, 89.42);
	CreateDynamicObject(18800, 964.83, 1459.83, 161.99,   0.00, 0.00, 269.00);
	CreateDynamicObject(19129, 942.11, 1498.92, 174.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 942.10, 1509.11, 184.44,   89.00, 0.00, 0.00);
	CreateDynamicObject(19129, 932.30, 1499.03, 184.44,   91.00, 0.00, 90.00);
	CreateDynamicObject(19129, 951.69, 1499.05, 184.44,   91.00, 0.00, -91.00);
	CreateDynamicObject(19129, 942.07, 1499.17, 194.28,   -180.00, 0.00, 359.00);
	CreateDynamicObject(19123, 934.40, 1470.30, 175.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 949.81, 1469.61, 175.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19121, 995.55, 1480.66, 105.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19121, 980.07, 1480.97, 104.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 980.16, 1489.31, 57.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 980.16, 1489.31, 57.85,   0.00, 0.00, 0.00);
	//Parkour Hard
    CreateObject(2991,2099.86694336,-1778.19396973,272.98095703,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (1)
	CreateDynamicObject(2991,2099.85083008,-1777.18750000,273.01486206,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (2)
	CreateDynamicObject(2991,2099.91015625,-1779.17712402,272.97930908,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (3)
	CreateDynamicObject(2991,2099.88012695,-1781.03063965,272.99331665,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (4)
	CreateDynamicObject(2991,2103.00634766,-1777.13989258,273.00399780,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (5)
	CreateDynamicObject(2991,2103.14013672,-1777.98376465,273.02850342,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (6)
	CreateDynamicObject(2991,2103.16113281,-1778.98608398,273.02050781,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (7)
	CreateDynamicObject(2991,2103.21264648,-1779.92016602,272.97085571,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (8)
	CreateDynamicObject(2991,2103.24194336,-1781.09338379,272.98138428,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (9)
	CreateDynamicObject(991,2101.55468750,-1776.32617188,274.86016846,0.00000000,0.00000000,0.00000000); //object(bar_barriergate1) (1)
	CreateDynamicObject(991,2101.38793945,-1781.88208008,274.83862305,0.00000000,0.00000000,180.00000000); //object(bar_barriergate1) (2)
	CreateDynamicObject(991,2104.77050781,-1779.03027344,274.86581421,0.00000000,0.00000000,270.00000000); //object(bar_barriergate1) (3)
	CreateDynamicObject(17019,2071.28320312,-1782.61132812,271.64913940,0.00000000,0.00000000,0.00000000); //object(cuntfrates1) (1)
	CreateDynamicObject(991,2078.77441406,-1779.24633789,278.86621094,0.00000000,0.00000000,90.00000000); //object(bar_barriergate1) (4)
	CreateDynamicObject(991,2078.80688477,-1776.02062988,278.86621094,0.00000000,0.00000000,90.00000000); //object(bar_barriergate1) (5)
	CreateDynamicObject(991,2069.06445312,-1779.27990723,278.86621094,0.00000000,0.00000000,269.99450684); //object(bar_barriergate1) (6)
	CreateDynamicObject(991,2069.05590820,-1775.93249512,278.86621094,0.00000000,0.00000000,269.99450684); //object(bar_barriergate1) (7)
	CreateDynamicObject(991,2075.50268555,-1772.68884277,278.86621094,0.00000000,0.00000000,0.00000000); //object(bar_barriergate1) (8)
	CreateDynamicObject(991,2072.40014648,-1772.68103027,278.86621094,0.00000000,0.00000000,0.00000000); //object(bar_barriergate1) (9)
	CreateDynamicObject(991,2075.43066406,-1782.52893066,278.86621094,0.00000000,0.00000000,0.00000000); //object(bar_barriergate1) (10)
	CreateDynamicObject(991,2072.35058594,-1782.52111816,278.86621094,0.00000000,0.00000000,0.00000000); //object(bar_barriergate1) (11)
	CreateDynamicObject(991,2075.40136719,-1781.29589844,280.07778931,270.00000000,0.00000000,0.00000000); //object(bar_barriergate1) (12)
	CreateDynamicObject(991,2075.41796875,-1773.87487793,280.07635498,269.99450684,0.00000000,0.00000000); //object(bar_barriergate1) (13)
	CreateDynamicObject(991,2072.42480469,-1773.88281250,280.05917358,269.99450684,0.00000000,0.00000000); //object(bar_barriergate1) (14)
	CreateDynamicObject(991,2072.42822266,-1781.40795898,280.07305908,269.99450684,0.00000000,0.00000000); //object(bar_barriergate1) (15)
	CreateDynamicObject(3062,2092.17749023,-1792.61254883,276.15420532,0.00000000,0.00000000,0.00000000); //object(container_door) (1)
	CreateDynamicObject(1337,2092.70117188,-1792.65625000,276.01931763,0.00000000,0.00000000,0.00000000); //object(binnt07_la) (2)
	CreateDynamicObject(2934,2083.84594727,-1779.10180664,275.10290527,0.00000000,0.00000000,0.00000000); //object(kmb_container_red) (1)
	CreateDynamicObject(2934,2083.93920898,-1776.22631836,275.10290527,0.00000000,0.00000000,0.00000000); //object(kmb_container_red) (2)
	CreateDynamicObject(2934,2085.41186523,-1781.06481934,275.10290527,0.00000000,0.00000000,90.00000000); //object(kmb_container_red) (3)
	CreateDynamicObject(2934,2090.15771484,-1781.05651855,275.10290527,0.00000000,0.00000000,90.00000000); //object(kmb_container_red) (4)
	CreateDynamicObject(991,2094.69287109,-1781.76708984,274.86621094,0.00000000,0.00000000,179.99450684); //object(bar_barriergate1) (16)
	CreateDynamicObject(991,2098.71069336,-1785.30078125,274.86621094,0.00000000,0.00000000,269.99450684); //object(bar_barriergate1) (17)
	CreateDynamicObject(991,2098.75048828,-1789.00109863,274.86621094,0.00000000,0.00000000,269.99450684); //object(bar_barriergate1) (18)
	CreateDynamicObject(991,2095.42260742,-1792.36389160,274.86621094,0.00000000,0.00000000,179.99450684); //object(bar_barriergate1) (19)
	CreateDynamicObject(991,2095.54663086,-1791.09777832,276.06549072,269.99450684,0.00000000,0.00000000); //object(bar_barriergate1) (20)
	CreateDynamicObject(991,2095.61035156,-1788.61718750,276.08486938,269.98901367,0.00000000,0.00000000); //object(bar_barriergate1) (21)
	CreateDynamicObject(991,2095.44726562,-1783.98498535,276.07458496,269.98901367,0.00000000,0.00000000); //object(bar_barriergate1) (22)
	CreateDynamicObject(991,2095.46215820,-1786.31250000,276.07962036,269.98901367,0.00000000,0.00000000); //object(bar_barriergate1) (21)
	CreateDynamicObject(991,2095.42236328,-1783.04528809,275.99557495,269.98901367,0.00000000,0.00000000); //object(bar_barriergate1) (22)
	CreateDynamicObject(991,2098.25292969,-1773.02648926,274.86621094,0.00000000,0.00000000,270.00000000); //object(bar_barriergate1) (3)
	CreateDynamicObject(991,2094.96704102,-1772.67370605,274.86621094,0.00000000,0.00000000,0.00000000); //object(bar_barriergate1) (1)
	CreateDynamicObject(991,2088.33520508,-1772.63793945,274.86621094,0.00000000,0.00000000,0.00000000); //object(bar_barriergate1) (1)
	CreateDynamicObject(2358,2074.05639648,-1787.60974121,277.54568481,0.00000000,0.00000000,0.00000000); //object(ammo_box_c2) (1)
	CreateDynamicObject(2358,2074.04370117,-1787.80004883,277.51348877,0.00000000,0.00000000,0.00000000); //object(ammo_box_c2) (2)
	CreateDynamicObject(2358,2074.05322266,-1787.40124512,277.55221558,0.00000000,0.00000000,0.00000000); //object(ammo_box_c2) (3)
	CreateDynamicObject(2358,2074.39868164,-1787.79785156,277.56579590,0.00000000,0.00000000,0.00000000); //object(ammo_box_c2) (4)
	CreateDynamicObject(2358,2074.41137695,-1787.41271973,277.55856323,0.00000000,0.00000000,0.00000000); //object(ammo_box_c2) (5)
	CreateDynamicObject(2935,2078.78662109,-1787.62048340,275.10290527,0.00000000,0.00000000,0.00000000); //object(kmb_container_yel) (2)
	CreateDynamicObject(3043,2040.32177734,-1783.11633301,275.65960693,0.00000000,0.00000000,90.00000000); //object(kmb_container_open) (1)
	CreateDynamicObject(5244,2019.75585938,-1781.53210449,274.59085083,0.00000000,0.00000000,0.00000000); //object(lasntrk1im03) (1)
	CreateDynamicObject(2932,2002.27221680,-1780.69653320,275.53585815,0.00000000,0.00000000,90.00000000); //object(kmb_container_blue) (1)
	CreateDynamicObject(2991,1992.86352539,-1780.77416992,276.44903564,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (10)
	CreateDynamicObject(2991,1989.84582520,-1780.77966309,276.47946167,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (11)
	CreateDynamicObject(3567,1975.89746094,-1780.80578613,274.89105225,0.00000000,0.00000000,90.00000000); //object(lasnfltrail) (1)
	CreateDynamicObject(3585,1966.11547852,-1780.06091309,276.62030029,0.00000000,0.00000000,90.00000000); //object(lastran1_la02) (1)
	CreateDynamicObject(3564,1963.15893555,-1780.20629883,274.12377930,0.00000000,0.00000000,0.00000000); //object(lastran1_la01) (1)
	CreateDynamicObject(942,1956.71594238,-1780.07238770,277.26727295,0.00000000,0.00000000,0.00000000); //object(cj_df_unit_2) (1)
	CreateDynamicObject(2679,1952.09045410,-1779.59924316,278.99411011,90.00000000,0.00000000,90.00000000); //object(cj_chris_crate_rd) (1)
	CreateDynamicObject(3630,1945.95922852,-1779.93933105,279.44741821,0.00000000,0.00000000,0.00000000); //object(crdboxes2_las) (1)
	CreateDynamicObject(5261,1934.40917969,-1779.91442871,278.84396362,0.00000000,0.00000000,180.00000000); //object(las2dkwar03) (1)
	CreateDynamicObject(7317,1923.19226074,-1783.43750000,285.87942505,0.00000000,0.00000000,90.00000000); //object(plantbox17) (1)
	CreateDynamicObject(7527,1887.25952148,-1780.10046387,281.89361572,0.00000000,0.00000000,0.00000000); //object(vegasnfrates03) (1)
	CreateDynamicObject(12930,1909.76220703,-1786.88342285,286.45663452,0.00000000,0.00000000,0.00000000); //object(sw_pipepile02) (1)
	CreateDynamicObject(3799,1924.75280762,-1774.87438965,283.82666016,0.00000000,0.00000000,0.00000000); //object(acbox2_sfs) (1)
	CreateDynamicObject(3799,1914.36840820,-1780.90625000,283.90139771,0.00000000,0.00000000,0.00000000); //object(acbox2_sfs) (2)
	CreateDynamicObject(5262,1855.75402832,-1779.88085938,285.87454224,0.00000000,0.00000000,180.00000000); //object(las2dkwar04) (1)
	CreateDynamicObject(8884,1837.64233398,-1780.11694336,286.90850830,0.00000000,0.00000000,0.00000000); //object(vgsefrght02) (1)
	CreateDynamicObject(9587,1801.84460449,-1787.28820801,283.16705322,0.00000000,0.00000000,0.00000000); //object(freight_box_sfw01) (1)
	CreateDynamicObject(3569,1814.33398438,-1784.23596191,287.23379517,0.00000000,0.00000000,0.00000000); //object(lasntrk3) (1)
	CreateDynamicObject(3569,1800.00549316,-1784.14843750,287.23379517,0.00000000,0.00000000,0.00000000); //object(lasntrk3) (2)
	CreateDynamicObject(3572,1765.10607910,-1781.45812988,289.01330566,0.00000000,0.00000000,0.00000000); //object(lasdkrt4) (1)
	CreateDynamicObject(3572,1757.25292969,-1781.62780762,287.34191895,0.00000000,0.00000000,0.00000000); //object(lasdkrt4) (2)
	CreateDynamicObject(3571,1737.45678711,-1787.96484375,280.39257812,0.00000000,0.00000000,0.00000000); //object(lasdkrt3) (1)
	CreateDynamicObject(3361,1731.55725098,-1788.03417969,283.53713989,0.00000000,0.00000000,0.00000000); //object(cxref_woodstair) (1)
	CreateDynamicObject(3361,1723.70520020,-1788.13610840,287.87274170,0.00000000,0.00000000,0.00000000); //object(cxref_woodstair) (2)
	CreateDynamicObject(3399,1713.98962402,-1788.19836426,292.21466064,0.00000000,0.00000000,180.00000000); //object(cxrf_a51_stairs) (1)
	CreateDynamicObject(2932,1705.40502930,-1788.48535156,293.97470093,0.00000000,0.00000000,0.00000000); //object(kmb_container_blue) (2)
	CreateDynamicObject(8883,1683.70507812,-1787.81250000,292.02139282,0.00000000,0.00000000,90.00000000); //object(vgsefrght01) (1)
	CreateDynamicObject(3799,1690.84826660,-1788.38671875,292.02731323,0.00000000,0.00000000,0.00000000); //object(acbox2_sfs) (3)
	CreateDynamicObject(2935,1663.06872559,-1787.93652344,293.94183350,0.00000000,0.00000000,0.00000000); //object(kmb_container_yel) (1)
	CreateDynamicObject(12861,1564.02783203,-1785.74060059,290.41714478,0.00000000,0.00000000,270.00000000); //object(sw_cont05) (1)
	CreateDynamicObject(3570,1589.01672363,-1779.88098145,295.76965332,0.00000000,0.00000000,0.00000000); //object(lasdkrt2) (1)
	CreateDynamicObject(3570,1574.63305664,-1779.68212891,299.76965332,0.00000000,0.00000000,0.00000000); //object(lasdkrt2) (2)
	CreateDynamicObject(942,1556.27209473,-1782.29846191,303.13586426,0.00000000,0.00000000,0.00000000); //object(cj_df_unit_2) (2)
	CreateDynamicObject(8884,1538.32116699,-1782.01477051,304.40289307,0.00000000,0.00000000,0.00000000); //object(vgsefrght02) (2)
	CreateDynamicObject(3633,1551.62097168,-1782.24401855,304.88360596,0.00000000,0.00000000,0.00000000); //object(imoildrum4_las) (1)
	CreateDynamicObject(1337,1504.24609375,-1782.21093750,228.41210938,0.00000000,0.00000000,0.00000000); //object(binnt07_la) (3)
	CreateDynamicObject(16322,1528.10522461,-1778.22094727,308.53564453,0.00000000,0.00000000,0.00000000); //object(a51_plat) (1)
	CreateDynamicObject(16649,1525.23754883,-1770.46789551,309.38449097,0.00000000,0.00000000,90.00000000); //object(a51_entstair) (1)
	CreateDynamicObject(14877,1525.46264648,-1761.08264160,310.45651245,0.00000000,0.00000000,90.00000000); //object(michelle-stairs) (1)
	CreateDynamicObject(2935,1525.34765625,-1753.14172363,310.99584961,0.00000000,0.00000000,0.00000000); //object(kmb_container_yel) (3)
	CreateDynamicObject(3621,1525.54760742,-1691.46252441,303.05459595,0.00000000,0.00000000,90.00000000); //object(rbigcrate_las) (1)
	CreateDynamicObject(3632,1524.61755371,-1735.53869629,308.59506226,0.00000000,0.00000000,0.00000000); //object(imoildrum_las) (1)
	CreateDynamicObject(3632,1524.59521484,-1737.74890137,306.23269653,0.00000000,0.00000000,0.00000000); //object(imoildrum_las) (2)
	CreateDynamicObject(3632,1524.61877441,-1735.21008301,308.59927368,0.00000000,0.00000000,0.00000000); //object(imoildrum_las) (3)
	CreateDynamicObject(3632,1524.61682129,-1734.88146973,308.59249878,0.00000000,0.00000000,0.00000000); //object(imoildrum_las) (4)
	CreateDynamicObject(3632,1524.60803223,-1734.55285645,308.64364624,0.00000000,0.00000000,0.00000000); //object(imoildrum_las) (5)
	CreateDynamicObject(3632,1524.60119629,-1734.22424316,308.63378906,0.00000000,0.00000000,0.00000000); //object(imoildrum_las) (6)
	CreateDynamicObject(3632,1524.61645508,-1733.89562988,308.58947754,0.00000000,0.00000000,0.00000000); //object(imoildrum_las) (7)
	CreateDynamicObject(1431,1525.37072754,-1722.56774902,306.30551147,0.00000000,0.00000000,0.00000000); //object(dyn_box_pile) (1)
	CreateDynamicObject(1271,1522.03820801,-1722.74938965,306.18417358,0.00000000,0.00000000,0.00000000); //object(gunbox) (1)
	CreateDynamicObject(1271,1529.07409668,-1722.72216797,306.16525269,0.00000000,0.00000000,0.00000000); //object(gunbox) (2)
	CreateDynamicObject(925,1527.57043457,-1722.63647461,306.81982422,0.00000000,0.00000000,0.00000000); //object(rack2) (1)
	CreateDynamicObject(2912,1525.59350586,-1690.66577148,305.75790405,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (1)
	CreateDynamicObject(2912,1525.58569336,-1691.32812500,305.75790405,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (2)
	CreateDynamicObject(2912,1525.59680176,-1690.65368652,306.45791626,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (3)
	CreateDynamicObject(2669,1525.51452637,-1653.09411621,307.09817505,0.00000000,0.00000000,0.00000000); //object(cj_chris_crate) (1)
	CreateDynamicObject(9316,1510.35168457,-1636.80078125,306.54107666,0.00000000,0.00000000,90.00000000); //object(shopstairssfn1) (1)
	CreateDynamicObject(2960,1493.03283691,-1644.11425781,309.01608276,0.00000000,0.00000000,0.00000000); //object(kmb_beam) (1)
	CreateDynamicObject(2960,1492.79833984,-1640.73266602,308.71118164,0.00000000,0.00000000,0.00000000); //object(kmb_beam) (2)
	CreateDynamicObject(2960,1492.76049805,-1642.39611816,308.94296265,0.00000000,0.00000000,0.00000000); //object(kmb_beam) (3)
	CreateDynamicObject(2960,1490.86840820,-1642.40051270,309.03302002,0.00000000,0.00000000,90.00000000); //object(kmb_beam) (4)
	CreateDynamicObject(2960,1488.54772949,-1642.37353516,308.93539429,0.00000000,0.00000000,0.00000000); //object(kmb_beam) (5)
	CreateDynamicObject(2960,1488.40515137,-1641.99475098,309.01672363,0.00000000,0.00000000,0.00000000); //object(kmb_beam) (6)
	CreateDynamicObject(2960,1488.44006348,-1642.69213867,309.03302002,0.00000000,0.00000000,0.00000000); //object(kmb_beam) (7)
	CreateDynamicObject(2935,1658.11669922,-1785.98632812,294.14578247,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (5)
	CreateDynamicObject(2935,1658.25427246,-1789.05224609,294.09738159,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (6)
	CreateDynamicObject(2935,1652.09704590,-1789.03771973,294.08645630,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (7)
	CreateDynamicObject(2935,1645.47570801,-1789.03088379,294.05813599,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (8)
	CreateDynamicObject(2935,1638.51733398,-1789.03918457,294.07168579,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (9)
	CreateDynamicObject(9124,1650.48327637,-1819.32946777,305.37982178,0.00000000,0.00000000,0.00000000); //object(crsplcneon) (1)
	CreateDynamicObject(2935,1640.87963867,-1790.99279785,294.05270386,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (10)
	CreateDynamicObject(2935,1645.44567871,-1790.99462891,294.02804565,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (11)
	CreateDynamicObject(2935,1649.02172852,-1791.03125000,294.01132202,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (12)
	CreateDynamicObject(2935,1652.65637207,-1791.04016113,294.03067017,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (13)
	CreateDynamicObject(2935,1656.22045898,-1791.02624512,293.95919800,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (14)
	CreateDynamicObject(2935,1662.14562988,-1791.10351562,294.00170898,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (15)
	CreateDynamicObject(2935,1651.51782227,-1786.03967285,294.18368530,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (16)
	CreateDynamicObject(2935,1636.18725586,-1789.01464844,296.97705078,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (17)
	CreateDynamicObject(2935,1632.59704590,-1789.00378418,296.98168945,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (18)
	CreateDynamicObject(2935,1629.00683594,-1788.91430664,297.01440430,0.00000000,0.00000000,90.00000000); //object(kmb_container_yel) (19)
	CreateDynamicObject(16601,1626.99645996,-1786.09960938,294.43774414,0.00000000,0.00000000,0.00000000); //object(by_fuel07) (1)
	CreateDynamicObject(17019,1612.06652832,-1774.33142090,288.49020386,0.00000000,0.00000000,0.00000000); //object(cuntfrates1) (2)
 //Драг 5
   AddStaticVehicle(560,-2133.04394531,1045.31701660,79.84700012,0.00000000,6,1); //Sultan
   CreateDynamicObject(8172,-2143.01293945,651.73101807,67.76200104,0.00000000,0.00000000,0.00000000); //object(vgssairportland07) (1)
   CreateDynamicObject(8172,-2143.07202148,522.83599854,67.75400543,0.00000000,0.00000000,0.00000000); //object(vgssairportland07) (2)
   CreateDynamicObject(8150,-2154.77001953,543.59600830,70.83899689,0.00000000,0.00000000,270.00000000); //object(vgsselecfence04) (1)
   CreateDynamicObject(8150,-2154.78588867,660.82098389,70.84700012,0.00000000,0.00000000,270.00000000); //object(vgsselecfence04) (2)
   CreateDynamicObject(8150,-2131.85205078,656.72302246,70.84700012,0.00000000,0.00000000,90.00000000); //object(vgsselecfence04) (3)
   CreateDynamicObject(8150,-2131.75805664,542.93402100,70.83899689,0.00000000,0.00000000,90.00000000); //object(vgsselecfence04) (5)
   CreateDynamicObject(8149,-2154.87890625,756.41302490,70.66400146,0.00000000,0.00000000,0.00000000); //object(vgsselecfence03) (1)
   CreateDynamicObject(8149,-2132.15307617,767.44299316,70.66000366,0.00000000,0.00000000,180.00000000); //object(vgsselecfence03) (2)
   CreateDynamicObject(984,-2129.34399414,918.59698486,79.48799896,0.00000000,0.00000000,0.00000000); //object(fenceshit2) (1)
   CreateDynamicObject(984,-2156.73706055,917.99401855,79.48799896,0.00000000,0.00000000,0.00000000); //object(fenceshit2) (2)
   CreateDynamicObject(984,-2160.24804688,930.07202148,79.63700104,0.00000000,0.00000000,34.00000000); //object(fenceshit2) (3)
   CreateDynamicObject(984,-2160.06494141,906.04302979,79.65200043,0.00000000,0.00000000,327.99719238); //object(fenceshit2) (4)
   CreateDynamicObject(984,-2129.15502930,958.02398682,79.60399628,0.00000000,0.00000000,0.00000000); //object(fenceshit2) (5)
   CreateDynamicObject(984,-2129.20898438,970.81500244,79.64399719,0.00000000,0.00000000,0.00000000); //object(fenceshit2) (6)
   CreateDynamicObject(982,-2161.63208008,1017.91497803,79.54299927,0.00000000,0.00000000,0.00000000); //object(fenceshit) (1)
   CreateDynamicObject(705,-2129.36010742,836.65899658,68.55500031,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (1)
   CreateDynamicObject(705,-2157.19702148,833.42999268,68.55599976,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (2)
   CreateDynamicObject(705,-2156.36889648,924.77197266,79.00000000,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (3)
   CreateDynamicObject(705,-2156.03002930,911.65899658,79.00000000,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (4)
   CreateDynamicObject(705,-2128.52001953,926.08398438,78.91799927,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (5)
   CreateDynamicObject(705,-2128.80908203,910.42102051,78.99199677,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (6)
   CreateDynamicObject(705,-2165.71997070,1014.71002197,79.00800323,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (7)
   CreateDynamicObject(705,-2165.85107422,1020.13000488,78.85900116,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (8)
   CreateDynamicObject(705,-2165.95996094,1025.64794922,79.00800323,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (9)
   CreateDynamicObject(983,-2129.18310547,839.56201172,69.24600220,0.00000000,0.00000000,284.00000000); //object(fenceshit3) (1)
   CreateDynamicObject(983,-2157.16894531,837.14501953,69.23999786,0.00000000,0.00000000,233.99658203); //object(fenceshit3) (2)
   CreateDynamicObject(705,-2154.10498047,481.15100098,67.73799896,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (10)
   CreateDynamicObject(705,-2131.28100586,479.94900513,67.73799896,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (11)
   CreateDynamicObject(994,-2131.59301758,472.34298706,67.73799896,0.00000000,0.00000000,90.00000000); //object(lhouse_barrier2) (1)
   CreateDynamicObject(994,-2154.02587891,472.81298828,67.73799896,0.00000000,0.00000000,89.99499512); //object(lhouse_barrier2) (2)
   CreateDynamicObject(994,-2154.06201172,466.64001465,67.73799896,0.00000000,0.00000000,89.99450684); //object(lhouse_barrier2) (3)
   CreateDynamicObject(994,-2154.05004883,460.45700073,67.73799896,0.00000000,0.00000000,89.99450684); //object(lhouse_barrier2) (4)
   CreateDynamicObject(994,-2154.08496094,454.30398560,67.73799896,0.00000000,0.00000000,89.99450684); //object(lhouse_barrier2) (5)
   CreateDynamicObject(994,-2147.85205078,454.31698608,67.74600220,0.00000000,0.00000000,179.99450684); //object(lhouse_barrier2) (6)
   CreateDynamicObject(994,-2141.67089844,454.32699585,67.73799896,0.00000000,0.00000000,179.99450684); //object(lhouse_barrier2) (7)
   CreateDynamicObject(994,-2135.51708984,454.32299805,67.73799896,0.00000000,0.00000000,179.99450684); //object(lhouse_barrier2) (8)
   CreateDynamicObject(994,-2131.81689453,454.25100708,67.73799896,0.00000000,0.00000000,179.99450684); //object(lhouse_barrier2) (9)
   CreateDynamicObject(994,-2131.60888672,466.18399048,67.73799896,0.00000000,0.00000000,89.99450684); //object(lhouse_barrier2) (10)
   CreateDynamicObject(994,-2131.60498047,460.00900269,67.73799896,0.00000000,0.00000000,89.99450684); //object(lhouse_barrier2) (11)
   CreateDynamicObject(994,-2131.58691406,454.27999878,67.73799896,0.00000000,0.00000000,89.99450684); //object(lhouse_barrier2) (12)
   CreateDynamicObject(1237,-2131.66601562,454.19100952,67.73799896,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (1)
   CreateDynamicObject(705,-2157.25488281,450.69601440,67.74600220,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (12)
   CreateDynamicObject(705,-2148.83007812,449.58300781,67.74600220,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (13)
   CreateDynamicObject(705,-2139.90209961,449.43499756,67.73799896,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (14)
   CreateDynamicObject(705,-2132.11206055,449.48498535,67.73799896,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (15)
   CreateDynamicObject(705,-2126.93310547,454.58700562,67.74600220,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (16)
   CreateDynamicObject(705,-2126.65087891,461.90499878,67.73799896,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (17)
   CreateDynamicObject(705,-2126.68505859,469.29199219,67.73799896,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (18)
   CreateDynamicObject(705,-2127.55810547,475.23498535,67.73799896,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (19)
   CreateDynamicObject(3749,-2142.87109375,480.28799438,73.59700012,0.00000000,0.00000000,0.00000000); //object(clubgate01_lax) (1)
   CreateDynamicObject(3749,-2142.42797852,1029.08605957,84.70999908,0.00000000,0.00000000,0.00000000); //object(clubgate01_lax) (2)
   CreateDynamicObject(984,-2127.18603516,1027.05798340,79.64399719,0.00000000,0.00000000,90.00000000); //object(fenceshit2) (7)
   CreateDynamicObject(984,-2158.17089844,1029.31799316,79.64399719,0.00000000,0.00000000,70.00000000); //object(fenceshit2) (8)
   CreateDynamicObject(705,-2128.20410156,977.38000488,79.00800323,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (20)
   CreateDynamicObject(705,-2152.45288086,482.94799805,67.73799896,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (21)
   CreateDynamicObject(705,-2132.62695312,482.30801392,67.73799896,0.00000000,0.00000000,93.99902344); //object(sm_veg_tree7vbig) (22)
   	//drift3
	CreateVehicle(562,1275.80004883,-2011.09997559,58.79999924,89.99951172,-1,-1,15); //Elegy
	CreateVehicle(562,1275.80004883,-2013.50000000,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1275.90002441,-2016.00000000,58.70000076,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1275.50000000,-2018.59997559,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1275.69995117,-2021.19995117,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1275.69995117,-2024.19995117,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1275.80004883,-2027.30004883,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1275.90002441,-2030.30004883,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1275.80004883,-2036.59997559,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1275.90002441,-2042.09997559,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1275.90002441,-2039.59997559,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateVehicle(562,1276.19995117,-2044.80004883,58.79999924,89.99450684,-1,-1,15); //Elegy
	CreateDynamicObject(982,1279.59997559,-2033.40002441,58.59999847,0.00000000,0.00000000,0.00000000); //object(fenceshit) (1)
	CreateDynamicObject(982,1279.59997559,-2020.50000000,58.59999847,0.00000000,0.00000000,0.00000000); //object(fenceshit) (2)
	CreateDynamicObject(982,1243.00000000,-2020.50000000,59.65777588,0.00000000,0.00000000,0.00000000); //object(fenceshit) (3)
	CreateDynamicObject(982,1243.09997559,-2046.00000000,59.70000076,0.00000000,0.00000000,0.00000000); //object(fenceshit) (4)
	CreateDynamicObject(982,1255.59997559,-2007.69995117,59.20000076,0.00000000,0.00000000,89.00000000); //object(fenceshit) (6)
	CreateDynamicObject(983,1271.40002441,-2007.69995117,58.79999924,0.00000000,0.00000000,270.00000000); //object(fenceshit3) (1)
	CreateDynamicObject(983,1276.40002441,-2007.59997559,58.59999847,0.00000000,0.00000000,269.99499512); //object(fenceshit3) (2)
	CreateDynamicObject(18275,1279.19995117,-2053.39990234,60.20000076,0.00000000,0.00000000,270.00000000); //object(cw2_mtbfinish) (1)
	CreateDynamicObject(18275,1279.00000000,-2059.39990234,60.20000076,0.00000000,0.00000000,270.00000000); //object(cw2_mtbfinish) (2)
	CreateDynamicObject(970,1279.40002441,-2048.30004883,58.70000076,0.00000000,0.00000000,270.00000000); //object(fencesmallb) (1)
	CreateDynamicObject(970,1279.09997559,-2064.10009766,58.70000076,0.00000000,0.00000000,268.00000000); //object(fencesmallb) (3)
	CreateDynamicObject(982,1266.09997559,-2065.69995117,59.09999847,359.00000000,0.00000000,270.00000000); //object(fenceshit) (9)
	CreateDynamicObject(983,1243.09997559,-2062.00000000,59.70000076,0.00000000,0.00000000,0.00000000); //object(fenceshit3) (6)
	CreateDynamicObject(983,1246.30004883,-2065.30004883,59.70000076,0.00000000,0.00000000,88.00000000); //object(fenceshit3) (7)
	CreateDynamicObject(983,1251.40002441,-2065.50000000,59.59999847,1.00000000,0.00000000,90.00000000); //object(fenceshit3) (9)
	CreateDynamicObject(8251,1266.30004883,-2020.69995117,62.09999847,0.00000000,0.00000000,270.00000000); //object(pltschlhnger02_lvs) (1)
	CreateDynamicObject(978,1260.50000000,-1946.09997559,29.79999924,0.00000000,0.00000000,329.99792480); //object(sub_roadright) (2)
	CreateDynamicObject(978,1197.59997559,-1989.00000000,-12.00000000,0.00000000,0.00000000,319.99633789); //object(sub_roadright) (4)
	CreateDynamicObject(978,1254.00000000,-1941.19995117,30.00000000,0.00000000,3.00000000,315.90002441); //object(sub_roadright) (5)
	CreateDynamicObject(978,1248.50000000,-1933.80004883,30.60000038,0.00000000,2.99926758,297.89538574); //object(sub_roadright) (6)
	CreateDynamicObject(978,1175.40002441,-1913.19995117,-19.60000038,0.00000000,2.99926758,279.89428711); //object(sub_roadright) (7)
	CreateDynamicObject(978,1245.80004883,-1925.19995117,31.00000000,0.00000000,2.00000000,275.89318848); //object(sub_roadright) (8)
	CreateDynamicObject(978,1246.80004883,-1916.59997559,30.79999924,0.00000000,357.00000000,249.88867188); //object(sub_roadright) (9)
	CreateDynamicObject(978,1251.30004883,-1908.90002441,30.29999924,0.00000000,356.00000000,227.88458252); //object(sub_roadright) (10)
	CreateDynamicObject(978,1258.80004883,-1904.30004883,29.60000038,0.00000000,355.00000000,195.87988281); //object(sub_roadright) (12)
	CreateDynamicObject(16092,1426.50000000,-1883.00000000,12.39999962,0.00000000,0.00000000,270.00000000); //object(des_pipestrut05) (1)
	CreateDynamicObject(13629,1426.80004883,-1886.19995117,25.20000076,0.00000000,0.00000000,90.00000000); //object(8screen01) (1)
//drift4
	AddStaticVehicleEx(560,-2399.89990234,-612.79998779,132.50000000,34.00000000,1,1,15); //Sultan
	AddStaticVehicleEx(560,-2397.60009766,-611.29998779,132.50000000,33.99719238,1,1,15); //Sultan
	AddStaticVehicleEx(560,-2395.30004883,-609.59997559,132.50000000,33.99719238,1,1,15); //Sultan
	AddStaticVehicleEx(560,-2392.80004883,-607.59997559,132.50000000,33.99719238,1,1,15); //Sultan
	AddStaticVehicleEx(562,-2416.89990234,-589.00000000,132.39999390,214.00000000,1,1,15); //Elegy
	AddStaticVehicleEx(562,-2414.10009766,-587.40002441,132.39999390,213.99719238,1,1,15); //Elegy
	AddStaticVehicleEx(562,-2411.60009766,-585.79998779,132.39999390,213.99719238,1,1,15); //Elegy
	AddStaticVehicleEx(562,-2408.89990234,-584.09997559,132.39999390,213.99719238,1,1,15); //Elegy
	CreateObject(3049,-2419.50000000,-600.00000000,133.80000305,0.00000000,0.00000000,348.00000000); //object(des_quarrygate) (1)
	CreateObject(3049,-2432.89990234,-609.20001221,133.80000305,0.00000000,0.00000000,257.99743652); //object(des_quarrygate) (2)
	CreateObject(3049,-2430.39990234,-612.79998779,133.80000305,0.00000000,0.00000000,305.99194336); //object(des_quarrygate) (3)
	CreateObject(3049,-2417.00000000,-603.59997559,133.80000305,0.00000000,0.00000000,305.99121094); //object(des_quarrygate) (4)
	CreateObject(1238,-2421.89990234,-618.79998779,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (3)
	CreateObject(1238,-2420.39990234,-617.70001221,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (4)
	CreateObject(1238,-2421.19921875,-618.19921875,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (5)
	CreateObject(1238,-2419.60009766,-617.20001221,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (6)
	CreateObject(1238,-2418.80004883,-616.59997559,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (7)
	CreateObject(1238,-2418.00000000,-616.09997559,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (8)
	CreateObject(1238,-2417.19995117,-615.50000000,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (9)
	CreateObject(1238,-2416.39990234,-614.90002441,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (10)
	CreateObject(1238,-2415.50000000,-614.29998779,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (11)
	CreateObject(1238,-2414.69995117,-613.79998779,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (12)
	CreateObject(1238,-2414.00000000,-613.29998779,131.89999390,0.00000000,0.00000000,0.00000000); //object(trafficcone) (13)
	CreateObject(3463,-2430.30004883,-598.59997559,131.30000305,0.00000000,0.00000000,34.00000000); //object(vegaslampost2) (1)
	CreateObject(1262,-2430.10009766,-598.90002441,137.00000000,0.00000000,0.00000000,214.00000000); //object(mtraffic4) (2)
	CreateObject(978,-2635.80004883,-497.79998779,70.30000305,0.00000000,0.00000000,282.00000000); //object(sub_roadright) (2)
	CreateObject(978,-2631.30004883,-505.50000000,70.30000305,0.00000000,0.00000000,317.99560547); //object(sub_roadright) (3)
	CreateObject(979,-2669.50000000,-400.50000000,31.89999962,0.00000000,0.00000000,230.00000000); //object(sub_roadleft) (6)
	CreateObject(979,-2678.39990234,-414.20001221,31.89999962,0.00000000,0.00000000,243.99877930); //object(sub_roadleft) (7)
	CreateObject(979,-2659.60009766,-389.60000610,31.89999962,0.00000000,0.00000000,219.99877930); //object(sub_roadleft) (8)
	CreateObject(979,-2783.19995117,-494.29998779,7.00000000,0.00000000,0.00000000,233.99536133); //object(sub_roadleft) (9)
	CreateObject(979,-2780.19995117,-490.20001221,7.00000000,0.00000000,0.00000000,233.99230957); //object(sub_roadleft) (10)
	CreateObject(979,-2773.69995117,-489.29998779,7.00000000,0.00000000,0.00000000,143.99230957); //object(sub_roadleft) (11)
	CreateObject(979,-2782.10009766,-500.89999390,7.00000000,0.00000000,0.00000000,323.99230957); //object(sub_roadleft) (12)
	CreateObject(14560,-2391.50000000,-589.70001221,136.00000000,0.00000000,0.00000000,36.00000000); //object(triad_bar) (1)
	CreateObject(3049,-2409.00000000,-611.40002441,133.80000305,0.00000000,0.00000000,305.99121094); //object(des_quarrygate) (5)
	CreateObject(3049,-2406.00000000,-614.50000000,133.80000305,0.00000000,0.00000000,313.99121094); //object(des_quarrygate) (6)
	CreateObject(3049,-2403.00000000,-617.59997559,133.80000305,0.00000000,0.00000000,313.98925781); //object(des_quarrygate) (7)
	CreateObject(3049,-2399.89990234,-620.59997559,133.80000305,0.00000000,0.00000000,315.98925781); //object(des_quarrygate) (8)
	CreateObject(3049,-2398.10009766,-622.00000000,133.80000305,0.00000000,0.00000000,317.98876953); //object(des_quarrygate) (9)
//drift6
	CreateDynamicObject(982,2307.30004883,1490.30004883,42.50000000,0.00000000,0.00000000,0.00000000); //object(fenceshit) (1)
	CreateDynamicObject(982,2307.30004883,1464.69995117,42.50000000,0.00000000,0.00000000,0.00000000); //object(fenceshit) (2)
	CreateDynamicObject(982,2307.30004883,1439.09997559,42.50000000,0.00000000,0.00000000,0.00000000); //object(fenceshit) (4)
	CreateDynamicObject(982,2307.30004883,1415.09997559,42.50000000,0.00000000,0.00000000,0.00000000); //object(fenceshit) (5)
	CreateDynamicObject(979,2302.69995117,1402.59997559,42.70000076,0.00000000,0.00000000,177.99609375); //object(sub_roadleft) (2)
	CreateDynamicObject(979,2302.60009766,1503.00000000,42.70000076,0.00000000,0.00000000,359.99499512); //object(sub_roadleft) (4)
	CreateDynamicObject(18275,2310.80004883,1402.80004883,44.09999847,0.00000000,0.00000000,0.00000000); //object(cw2_mtbfinish) (1)
	CreateDynamicObject(18275,2316.80004883,1402.90002441,44.09999847,0.00000000,0.00000000,0.00000000); //object(cw2_mtbfinish) (2)
	CreateDynamicObject(18275,2322.80004883,1402.80004883,44.09999847,0.00000000,0.00000000,0.00000000); //object(cw2_mtbfinish) (3)
	CreateDynamicObject(18275,2328.80004883,1402.80004883,44.09999847,0.00000000,0.00000000,0.00000000); //object(cw2_mtbfinish) (4)
	CreateDynamicObject(18275,2334.80004883,1402.80004883,44.09999847,0.00000000,0.00000000,0.00000000); //object(cw2_mtbfinish) (5)
	CreateDynamicObject(18275,2340.80004883,1402.80004883,44.09999847,0.00000000,0.00000000,0.00000000); //object(cw2_mtbfinish) (6)
	CreateDynamicObject(979,2345.39990234,1398.30004883,42.70000076,0.00000000,0.00000000,113.99499512); //object(sub_roadleft) (5)
	CreateDynamicObject(1262,2307.69995117,1402.19995117,44.40000153,0.00000000,0.00000000,182.00000000); //object(mtraffic4) (1)
	CreateDynamicObject(1262,2313.69995117,1402.19995117,44.40000153,0.00000000,0.00000000,181.99951172); //object(mtraffic4) (2)
	CreateDynamicObject(1262,2319.69995117,1402.19995117,44.50000000,0.00000000,0.00000000,181.99951172); //object(mtraffic4) (3)
	CreateDynamicObject(1262,2325.69995117,1402.19995117,44.59999847,0.00000000,0.00000000,181.99951172); //object(mtraffic4) (4)
	CreateDynamicObject(1262,2331.80004883,1402.19995117,44.50000000,0.00000000,0.00000000,181.99951172); //object(mtraffic4) (5)
	CreateDynamicObject(1262,2337.69995117,1402.19995117,44.59999847,0.00000000,0.00000000,181.99951172); //object(mtraffic4) (6)
	CreateDynamicObject(1262,2343.69995117,1402.19995117,44.50000000,0.00000000,0.00000000,181.99951172); //object(mtraffic4) (7)
	CreateDynamicObject(979,2312.89990234,1517.40002441,42.70000076,0.00000000,0.00000000,149.99279785); //object(sub_roadleft) (7)
	CreateDynamicObject(979,2304.30004883,1520.40002441,42.70000076,0.00000000,0.00000000,169.99084473); //object(sub_roadleft) (8)
	CreateDynamicObject(979,2295.19995117,1520.40002441,42.70000076,0.00000000,0.00000000,189.98596191); //object(sub_roadleft) (9)
	CreateDynamicObject(979,2287.00000000,1517.69995117,42.70000076,0.00000000,0.00000000,205.98107910); //object(sub_roadleft) (10)
	CreateDynamicObject(979,2312.00000000,1403.40002441,36.29999924,0.00000000,0.00000000,179.97717285); //object(sub_roadleft) (12)
	CreateDynamicObject(979,2302.30004883,1403.30004883,36.29999924,0.00000000,0.00000000,179.97351074); //object(sub_roadleft) (13)
	CreateDynamicObject(1237,2307.10009766,1403.40002441,35.40000153,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (1)
	CreateDynamicObject(979,2291.00000000,1393.69995117,36.29999924,0.00000000,0.00000000,321.97253418); //object(sub_roadleft) (15)
	CreateDynamicObject(979,2298.80004883,1388.59997559,36.29999924,0.00000000,0.00000000,331.97082520); //object(sub_roadleft) (16)
	CreateDynamicObject(979,2307.60009766,1386.19995117,36.29999924,0.00000000,0.00000000,357.96838379); //object(sub_roadleft) (17)
	CreateDynamicObject(979,2316.30004883,1388.30004883,36.29999924,0.00000000,0.00000000,27.96752930); //object(sub_roadleft) (18)
	CreateDynamicObject(979,2324.00000000,1393.09997559,36.29999924,0.00000000,0.00000000,35.96569824); //object(sub_roadleft) (19)
	CreateDynamicObject(979,2312.69995117,1503.09997559,29.89999962,0.00000000,0.00000000,359.96374512); //object(sub_roadleft) (21)
	CreateDynamicObject(979,2302.80004883,1503.09997559,29.89999962,0.00000000,0.00000000,359.96252441); //object(sub_roadleft) (22)
	CreateDynamicObject(1237,2307.69995117,1503.00000000,29.00000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (3)
	CreateDynamicObject(979,2324.69995117,1514.30004883,29.89999962,0.00000000,0.00000000,141.96157837); //object(sub_roadleft) (23)
	CreateDynamicObject(979,2316.50000000,1518.30004883,29.89999962,0.00000000,0.00000000,165.95983887); //object(sub_roadleft) (25)
	CreateDynamicObject(979,2307.30004883,1519.09997559,29.89999962,0.00000000,0.00000000,183.95947266); //object(sub_roadleft) (27)
	CreateDynamicObject(979,2298.30004883,1517.69995117,29.89999962,0.00000000,0.00000000,193.95507812); //object(sub_roadleft) (29)
	CreateDynamicObject(979,2290.00000000,1514.09997559,29.89999962,0.00000000,0.00000000,211.95263672); //object(sub_roadleft) (30)
	CreateDynamicObject(979,2302.19995117,1403.40002441,23.50000000,0.00000000,0.00000000,179.94824219); //object(sub_roadleft) (32)
	CreateDynamicObject(979,2311.89990234,1403.30004883,23.50000000,0.00000000,0.00000000,179.94555664); //object(sub_roadleft) (33)
	CreateDynamicObject(1237,2307.00000000,1403.40002441,22.60000038,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (5)
	CreateDynamicObject(979,2289.80004883,1392.90002441,23.50000000,0.00000000,0.00000000,327.94506836); //object(sub_roadleft) (35)
	CreateDynamicObject(979,2298.30004883,1389.09997559,23.50000000,0.00000000,0.00000000,343.94189453); //object(sub_roadleft) (36)
	CreateDynamicObject(979,2307.39990234,1387.80004883,23.50000000,0.00000000,0.00000000,359.93798828); //object(sub_roadleft) (37)
	CreateDynamicObject(979,2316.60009766,1389.09997559,23.50000000,0.00000000,0.00000000,15.93408203); //object(sub_roadleft) (38)
	CreateDynamicObject(979,2324.89990234,1392.80004883,23.50000000,0.00000000,0.00000000,31.93017578); //object(sub_roadleft) (39)
	CreateDynamicObject(979,2312.69995117,1503.00000000,17.10000038,0.00000000,0.00000000,359.96154785); //object(sub_roadleft) (42)
	CreateDynamicObject(979,2302.60009766,1503.00000000,17.10000038,0.00000000,0.00000000,359.96154785); //object(sub_roadleft) (43)
	CreateDynamicObject(1237,2307.69995117,1502.90002441,16.20000076,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (6)
	CreateDynamicObject(979,2324.80004883,1514.50000000,17.10000038,0.00000000,0.00000000,145.96154785); //object(sub_roadleft) (44)
	CreateDynamicObject(979,2316.50000000,1518.59997559,17.10000038,0.00000000,0.00000000,161.95886230); //object(sub_roadleft) (45)
	CreateDynamicObject(979,2307.50000000,1520.00000000,17.10000038,0.00000000,0.00000000,179.95495605); //object(sub_roadleft) (46)
	CreateDynamicObject(979,2298.50000000,1518.40002441,17.10000038,0.00000000,0.00000000,199.95056152); //object(sub_roadleft) (47)
	CreateDynamicObject(979,2290.60009766,1513.80004883,17.10000038,0.00000000,0.00000000,219.94567871); //object(sub_roadleft) (48)
	CreateDynamicObject(1238,2297.00000000,1392.59997559,10.10000038,0.00000000,0.00000000,0.00000000); //object(trafficcone) (6)
	CreateDynamicObject(1238,2297.10009766,1390.69995117,10.10000038,0.00000000,0.00000000,0.00000000); //object(trafficcone) (7)
	CreateDynamicObject(1238,2297.00000000,1388.80004883,10.10000038,0.00000000,0.00000000,0.00000000); //object(trafficcone) (8)
	CreateDynamicObject(1238,2297.10009766,1386.69995117,10.10000038,0.00000000,0.00000000,0.00000000); //object(trafficcone) (9)
	CreateDynamicObject(1238,2297.10009766,1384.59997559,10.10000038,0.00000000,0.00000000,0.00000000); //object(trafficcone) (10)
	CreateDynamicObject(1238,2272.30004883,1396.59997559,10.10000038,0.00000000,0.00000000,0.00000000); //object(trafficcone) (14)
//drift8
	CreateDynamicObject(5191,-1434.69921875,1145.39941406,8.89999962,0.00000000,0.00000000,90.00000000); //object(nwdkbridd_las2)(3)
	CreateDynamicObject(5191,-1549.40002441,1145.69995117,-4.40000010,13.24475098,0.00000000,269.98901367); //object(nwdkbridd_las2)(4)
	CreateDynamicObject(5184,-1305.90002441,1150.30004883,33.50000000,0.00000000,0.00000000,0.00000000); //object(mdock1a_las2)(2)
	CreateDynamicObject(5184,-1351.80004883,1192.50000000,33.40000153,0.00000000,0.00000000,270.00000000); //object(mdock1a_las2)(5)
	CreateDynamicObject(5184,-1388.59997559,1230.09997559,33.50000000,0.00000000,0.00000000,359.98901367); //object(mdock1a_las2)(6)
	CreateDynamicObject(5184,-1434.69995117,1272.40002441,33.40000153,0.00000000,0.00000000,269.98901367); //object(mdock1a_las2)(7)
	CreateDynamicObject(5184,-1512.50000000,1349.90002441,33.50000000,0.00000000,0.00000000,359.97802734); //object(mdock1a_las2)(9)
	CreateDynamicObject(5184,-1512.50000000,1432.00000000,33.50000000,0.00000000,0.00000000,179.97253418); //object(mdock1a_las2)(11)
	CreateDynamicObject(5184,-1382.69921875,1431.89941406,33.50000000,0.00000000,0.00000000,179.96154785); //object(mdock1a_las2)(12)
	CreateDynamicObject(5184,-1252.89941406,1431.89941406,33.50000000,0.00000000,0.00000000,179.95056152); //object(mdock1a_las2)(13)
	CreateDynamicObject(5184,-1183.40002441,1389.69995117,33.40000153,0.00000000,0.00000000,89.95056152); //object(mdock1a_las2)(14)
	CreateDynamicObject(5184,-1224.69995117,1256.90002441,33.50000000,0.00000000,0.00000000,89.94506836); //object(mdock1a_las2)(15)
	CreateDynamicObject(5184,-1267.00000000,1150.30004883,33.50000000,0.00000000,0.00000000,359.94506836); //object(mdock1a_las2)(16)
	CreateDynamicObject(5184,-1224.80004883,1196.00000000,33.50000000,0.00000000,0.00000000,89.93957520); //object(mdock1a_las2)(17)
	CreateDynamicObject(6959,-1556.80004883,1351.09997559,14.80000019,0.00000000,0.00000000,0.00000000); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1556.80004883,1391.09997559,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(3)
	CreateDynamicObject(6959,-1556.80004883,1431.00000000,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(5184,-1512.50000000,1373.69995117,33.40000153,0.00000000,0.00000000,179.97802734); //object(mdock1a_las2)(9)
	CreateDynamicObject(6959,-1515.50000000,1351.09997559,14.80000019,0.00000000,0.00000000,0.00000000); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1474.19995117,1351.09997559,14.80000019,0.00000000,0.00000000,0.00000000); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1515.50000000,1391.09997559,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(3)
	CreateDynamicObject(6959,-1474.19995117,1391.09997559,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(3)
	CreateDynamicObject(6959,-1515.50000000,1431.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1474.19995117,1431.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1432.90002441,1431.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1432.90002441,1391.09997559,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(3)
	CreateDynamicObject(6959,-1432.90002441,1351.09997559,14.80000019,0.00000000,0.00000000,0.00000000); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1432.89941406,1311.19921875,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1391.69995117,1431.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1350.40002441,1431.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1309.09997559,1431.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1267.80004883,1431.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1226.50000000,1431.09960938,14.80000019,0.00000000,0.00000000,359.98352051); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1185.19995117,1431.00000000,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(5184,-1229.40002441,1432.00000000,33.50000000,0.00000000,0.00000000,179.95056152); //object(mdock1a_las2)(13)
	CreateDynamicObject(6959,-1185.19995117,1391.00000000,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1432.90002441,1271.30004883,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1432.89941406,1231.29980469,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1391.59960938,1231.29980469,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1350.29980469,1231.29980469,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1350.30004883,1191.30004883,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(2)
	CreateDynamicObject(6959,-1350.19921875,1151.39941406,14.80000019,0.00000000,0.00000000,179.99450684); //object(vegasnbball1)(2)
	CreateDynamicObject(5184,-1225.69995117,1309.80004883,33.40000153,0.00000000,0.00000000,359.94506836); //object(mdock1a_las2)(15)
	CreateDynamicObject(6959,-1185.19995117,1351.00000000,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1185.19995117,1311.00000000,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(5184,-1183.40002441,1355.90002441,33.40000153,0.00000000,0.00000000,89.94506836); //object(mdock1a_las2)(15)
	CreateDynamicObject(6959,-1226.50000000,1311.00000000,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1226.50000000,1271.00000000,14.80000019,0.00000000,0.00000000,359.98352051); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1226.50000000,1231.00000000,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1226.40002441,1191.30004883,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1226.50000000,1151.30004883,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1267.80004883,1151.30004883,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1309.09960938,1151.29980469,14.80000019,0.00000000,0.00000000,359.97802734); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1309.00000000,1191.29980469,14.80000019,0.00000000,0.00000000,359.97802734); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1309.00000000,1231.29980469,14.80000019,0.00000000,0.00000000,359.97802734); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1267.69921875,1191.29980469,14.80000019,0.00000000,0.00000000,359.98352051); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1267.79980469,1231.29980469,14.80000019,0.00000000,0.00000000,359.97802734); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1267.80004883,1271.30004883,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1267.80004883,1311.30004883,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1309.09960938,1271.19921875,14.80000019,0.00000000,0.00000000,359.98352051); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1350.40002441,1271.19995117,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1391.69995117,1271.19995117,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1391.69995117,1311.19995117,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1391.59997559,1351.19995117,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1391.59997559,1391.19995117,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1350.40002441,1311.19995117,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1350.30004883,1351.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1350.30004883,1391.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1309.00000000,1391.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1267.69995117,1391.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1226.40002441,1391.00000000,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1226.30004883,1351.00000000,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1267.59997559,1351.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1308.90002441,1351.09997559,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(6959,-1309.09997559,1311.19995117,14.80000019,0.00000000,0.00000000,359.98901367); //object(vegasnbball1)(4)
	CreateDynamicObject(982,-1370.80004883,1168.09997559,15.39999962,0.00000000,0.00000000,0.00000000); //object(fenceshit)(1)
	CreateDynamicObject(982,-1370.80004883,1198.50000000,15.39999962,0.00000000,0.00000000,0.00000000); //object(fenceshit)(2)
	CreateDynamicObject(982,-1370.80004883,1193.69995117,15.39999962,0.00000000,0.00000000,0.00000000); //object(fenceshit)(3)
	CreateDynamicObject(982,-1383.80004883,1211.30004883,15.39999962,0.00000000,0.00000000,90.00000000); //object(fenceshit)(4)
	CreateDynamicObject(982,-1409.40002441,1211.30004883,15.39999962,0.00000000,0.00000000,89.99450684); //object(fenceshit)(5)
	CreateDynamicObject(982,-1435.00000000,1211.30004883,15.39999962,0.00000000,0.00000000,89.99450684); //object(fenceshit)(6)
	CreateDynamicObject(982,-1439.80004883,1211.30004883,15.39999962,0.00000000,0.00000000,90.00000000); //object(fenceshit)(7)
	CreateDynamicObject(982,-1452.59997559,1224.09997559,15.39999962,0.00000000,0.00000000,179.99450684); //object(fenceshit)(8)
	CreateDynamicObject(982,-1452.59997559,1249.69995117,15.39999962,0.00000000,0.00000000,179.98901367); //object(fenceshit)(9)
	CreateDynamicObject(982,-1452.59997559,1275.30004883,15.39999962,0.00000000,0.00000000,179.98901367); //object(fenceshit)(10)
	CreateDynamicObject(982,-1452.59997559,1300.90002441,15.39999962,0.00000000,0.00000000,179.98901367); //object(fenceshit)(11)
	CreateDynamicObject(982,-1452.59997559,1318.50000000,15.39999962,0.00000000,0.00000000,179.98901367); //object(fenceshit)(12)
	CreateDynamicObject(982,-1465.40002441,1331.30004883,15.39999962,0.00000000,0.00000000,269.98901367); //object(fenceshit)(13)
	CreateDynamicObject(982,-1491.00000000,1331.30004883,15.39999962,0.00000000,0.00000000,269.98352051); //object(fenceshit)(14)
	CreateDynamicObject(982,-1516.59997559,1331.30004883,15.39999962,0.00000000,0.00000000,269.98352051); //object(fenceshit)(15)
	CreateDynamicObject(982,-1542.19995117,1331.30004883,15.39999962,0.00000000,0.00000000,269.98352051); //object(fenceshit)(16)
	CreateDynamicObject(982,-1564.59997559,1331.30004883,15.39999962,0.00000000,0.00000000,269.98352051); //object(fenceshit)(17)
	CreateDynamicObject(982,-1577.40002441,1344.09997559,15.39999962,0.00000000,0.00000000,179.98352051); //object(fenceshit)(18)
	CreateDynamicObject(982,-1577.40002441,1369.69995117,15.39999962,0.00000000,0.00000000,179.98352051); //object(fenceshit)(19)
	CreateDynamicObject(982,-1577.40002441,1395.30004883,15.39999962,0.00000000,0.00000000,179.98352051); //object(fenceshit)(20)
	CreateDynamicObject(982,-1577.40002441,1420.90002441,15.39999962,0.00000000,0.00000000,179.98352051); //object(fenceshit)(21)
	CreateDynamicObject(982,-1577.40002441,1438.50000000,15.39999962,0.00000000,0.00000000,179.98352051); //object(fenceshit)(22)
	CreateDynamicObject(982,-1564.59997559,1451.30004883,15.39999962,0.00000000,0.00000000,89.98352051); //object(fenceshit)(23)
	CreateDynamicObject(982,-1539.00000000,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(24)
	CreateDynamicObject(982,-1513.40002441,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(25)
	CreateDynamicObject(982,-1487.80004883,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(26)
	CreateDynamicObject(982,-1462.19995117,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(27)
	CreateDynamicObject(982,-1436.59997559,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(28)
	CreateDynamicObject(982,-1411.00000000,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(29)
	CreateDynamicObject(982,-1385.40002441,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(30)
	CreateDynamicObject(982,-1359.80004883,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(31)
	CreateDynamicObject(982,-1334.19995117,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(32)
	CreateDynamicObject(982,-1308.59997559,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(33)
	CreateDynamicObject(982,-1283.00000000,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(34)
	CreateDynamicObject(982,-1257.40002441,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(35)
	CreateDynamicObject(982,-1231.80004883,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(37)
	CreateDynamicObject(982,-1206.19995117,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(38)
	CreateDynamicObject(982,-1180.59997559,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(39)
	CreateDynamicObject(982,-1177.40002441,1451.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(40)
	CreateDynamicObject(982,-1164.59997559,1438.50000000,15.39999962,0.00000000,0.00000000,359.97802734); //object(fenceshit)(41)
	CreateDynamicObject(982,-1164.59997559,1412.90002441,15.39999962,0.00000000,0.00000000,359.97802734); //object(fenceshit)(42)
	CreateDynamicObject(982,-1164.59997559,1387.30004883,15.39999962,0.00000000,0.00000000,359.97802734); //object(fenceshit)(43)
	CreateDynamicObject(982,-1164.59997559,1361.69995117,15.39999962,0.00000000,0.00000000,359.97802734); //object(fenceshit)(44)
	CreateDynamicObject(982,-1164.59997559,1336.09997559,15.39999962,0.00000000,0.00000000,359.97802734); //object(fenceshit)(45)
	CreateDynamicObject(982,-1164.59997559,1310.50000000,15.39999962,0.00000000,0.00000000,359.97802734); //object(fenceshit)(46)
	CreateDynamicObject(982,-1164.59997559,1304.09997559,15.39999962,0.00000000,0.00000000,359.97802734); //object(fenceshit)(47)
	CreateDynamicObject(982,-1177.40002441,1291.30004883,15.39999962,0.00000000,0.00000000,269.97802734); //object(fenceshit)(48)
	CreateDynamicObject(982,-1193.40002441,1291.30004883,15.39999962,0.00000000,0.00000000,269.97253418); //object(fenceshit)(49)
	CreateDynamicObject(982,-1206.19995117,1278.50000000,15.39999962,0.00000000,0.00000000,359.97253418); //object(fenceshit)(50)
	CreateDynamicObject(982,-1206.19995117,1252.90002441,15.39999962,0.00000000,0.00000000,359.97253418); //object(fenceshit)(51)
	CreateDynamicObject(982,-1206.19995117,1227.30004883,15.39999962,0.00000000,0.00000000,359.97253418); //object(fenceshit)(52)
	CreateDynamicObject(982,-1206.19995117,1201.69995117,15.39999962,0.00000000,0.00000000,359.97253418); //object(fenceshit)(53)
	CreateDynamicObject(982,-1206.19995117,1176.09997559,15.39999962,0.00000000,0.00000000,359.97253418); //object(fenceshit)(54)
	CreateDynamicObject(982,-1206.19995117,1150.50000000,15.39999962,0.00000000,0.00000000,359.97253418); //object(fenceshit)(55)
	CreateDynamicObject(982,-1206.19995117,1144.09997559,15.39999962,0.00000000,0.00000000,359.97253418); //object(fenceshit)(56)
	CreateDynamicObject(982,-1219.00000000,1131.30004883,15.39999962,0.00000000,0.00000000,269.97253418); //object(fenceshit)(57)
	CreateDynamicObject(982,-1244.59997559,1131.30004883,15.39999962,0.00000000,0.00000000,269.96704102); //object(fenceshit)(58)
	CreateDynamicObject(982,-1270.19995117,1131.30004883,15.39999962,0.00000000,0.00000000,269.96704102); //object(fenceshit)(59)
	CreateDynamicObject(982,-1295.79980469,1131.29980469,15.39999962,0.00000000,0.00000000,269.96154785); //object(fenceshit)(60)
	CreateDynamicObject(982,-1321.40002441,1131.30004883,15.39999962,0.00000000,0.00000000,269.96704102); //object(fenceshit)(61)
	CreateDynamicObject(982,-1347.00000000,1131.30004883,15.39999962,0.00000000,0.00000000,269.96704102); //object(fenceshit)(62)
	CreateDynamicObject(982,-1358.19995117,1131.30004883,15.39999962,0.00000000,0.00000000,269.96704102); //object(fenceshit)(63)
	CreateDynamicObject(983,-1371.00000000,1134.50000000,15.39999962,0.00000000,0.00000000,0.00000000); //object(fenceshit3)(1)
	CreateDynamicObject(982,-1358.09997559,1211.30004883,15.39999962,0.00000000,0.00000000,89.98901367); //object(fenceshit)(67)
	CreateDynamicObject(982,-1332.50000000,1211.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1306.89941406,1211.29980469,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1269.30004883,1211.30004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1294.09960938,1198.50000000,15.39999962,0.00000000,0.00000000,179.96154785); //object(fenceshit)(67)
	CreateDynamicObject(982,-1294.09997559,1172.90002441,15.39999962,0.00000000,0.00000000,179.96154785); //object(fenceshit)(67)
	CreateDynamicObject(982,-1294.09997559,1166.50000000,15.39999962,0.00000000,0.00000000,179.96154785); //object(fenceshit)(67)
	CreateDynamicObject(982,-1306.90002441,1153.69995117,15.39999962,0.00000000,0.00000000,269.96154785); //object(fenceshit)(67)
	CreateDynamicObject(982,-1370.80004883,1166.50000000,15.39999962,0.00000000,0.00000000,179.96154785); //object(fenceshit)(67)
	CreateDynamicObject(982,-1358.00000000,1153.69995117,15.39999962,0.00000000,0.00000000,269.95605469); //object(fenceshit)(67)
	CreateDynamicObject(982,-1350.00000000,1153.69995117,15.39999962,0.00000000,0.00000000,269.95605469); //object(fenceshit)(67)
	CreateDynamicObject(1696,-1297.09997559,1157.30004883,14.69999981,340.75000000,0.00000000,0.00000000); //object(roofstuff15)(1)
	CreateDynamicObject(1696,-1297.09997559,1163.40002441,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(2)
	CreateDynamicObject(1696,-1297.09997559,1169.50000000,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(3)
	CreateDynamicObject(1696,-1297.09960938,1175.59960938,14.69999981,340.74096600,0.00000000,0.00000000); //object(roofstuff15)(4)
	CreateDynamicObject(1696,-1297.09997559,1181.69995117,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(5)
	CreateDynamicObject(1696,-1297.09997559,1187.80004883,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(6)
	CreateDynamicObject(1696,-1297.09960938,1193.89941406,14.69999981,340.74096600,0.00000000,0.00000000); //object(roofstuff15)(7)
	CreateDynamicObject(1696,-1297.09960938,1199.89941406,14.69999981,340.74096600,0.00000000,0.00000000); //object(roofstuff15)(8)
	CreateDynamicObject(1696,-1297.09997559,1206.00000000,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(9)
	CreateDynamicObject(1696,-1297.09997559,1208.69995117,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(10)
	CreateDynamicObject(1696,-1302.50000000,1208.69995117,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(11)
	CreateDynamicObject(1696,-1302.50000000,1202.59997559,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(12)
	CreateDynamicObject(1696,-1302.50000000,1196.50000000,14.69999981,340.74096600,0.00000000,0.00000000); //object(roofstuff15)(13)
	CreateDynamicObject(1696,-1302.50000000,1190.40002441,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(14)
	CreateDynamicObject(1696,-1302.50000000,1184.30004883,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(15)
	CreateDynamicObject(1696,-1302.50000000,1178.19995117,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(16)
	CreateDynamicObject(1696,-1302.50000000,1172.09997559,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(17)
	CreateDynamicObject(1696,-1302.50000000,1166.00000000,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(18)
	CreateDynamicObject(1696,-1302.50000000,1159.90002441,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(19)
	CreateDynamicObject(1696,-1302.50000000,1157.30004883,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(20)
	CreateDynamicObject(1696,-1307.90002441,1157.30004883,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(21)
	CreateDynamicObject(1696,-1307.90002441,1163.40002441,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(22)
	CreateDynamicObject(1696,-1307.89941406,1169.50000000,14.69999981,340.74096600,0.00000000,0.00000000); //object(roofstuff15)(23)
	CreateDynamicObject(1696,-1307.89941406,1175.59960938,14.69999981,340.74096600,0.00000000,0.00000000); //object(roofstuff15)(24)
	CreateDynamicObject(1696,-1307.90002441,1181.69995117,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(25)
	CreateDynamicObject(1696,-1307.89941406,1187.79980469,14.69999981,340.74096600,0.00000000,0.00000000); //object(roofstuff15)(26)
	CreateDynamicObject(1696,-1307.90002441,1193.90002441,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(27)
	CreateDynamicObject(1696,-1307.89941406,1200.00000000,14.69999981,340.74096600,0.00000000,0.00000000); //object(roofstuff15)(28)
	CreateDynamicObject(1696,-1307.90002441,1206.09997559,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(29)
	CreateDynamicObject(1696,-1307.90002441,1208.69995117,14.69999981,340.74645900,0.00000000,0.00000000); //object(roofstuff15)(30)
	CreateDynamicObject(970,-1310.30004883,1155.80004883,15.30000019,0.00000000,0.00000000,90.00000000); //object(fencesmallb)(1)
	CreateDynamicObject(970,-1310.30004883,1159.90002441,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(2)
	CreateDynamicObject(970,-1310.30004883,1164.00000000,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(3)
	CreateDynamicObject(970,-1310.30004883,1168.09997559,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(4)
	CreateDynamicObject(970,-1310.29980469,1172.19921875,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(5)
	CreateDynamicObject(970,-1310.30004883,1176.30004883,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(6)
	CreateDynamicObject(970,-1310.30004883,1192.80004883,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(10)
	CreateDynamicObject(970,-1310.30004883,1196.90002441,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(11)
	CreateDynamicObject(970,-1310.30004883,1201.00000000,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(12)
	CreateDynamicObject(970,-1310.30004883,1205.09997559,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(13)
	CreateDynamicObject(970,-1310.30004883,1209.19995117,15.30000019,0.00000000,0.00000000,89.99450684); //object(fencesmallb)(14)
	CreateDynamicObject(780,-1303.00000000,1203.59997559,14.89999962,0.00000000,0.00000000,0.00000000); //object(elmsparse_hism)(1)
	CreateDynamicObject(780,-1303.00000000,1203.59960938,14.89999962,0.00000000,0.00000000,0.00000000); //object(elmsparse_hism)(2)
	CreateDynamicObject(782,-1302.30004883,1166.19995117,14.89999962,0.00000000,0.00000000,0.00000000); //object(elmtreegrn_hism)(1)
	CreateDynamicObject(782,-1302.29980469,1166.19921875,14.89999962,0.00000000,0.00000000,0.00000000); //object(elmtreegrn_hism)(2)
	CreateDynamicObject(782,-1302.50000000,1184.69995117,14.89999962,0.00000000,0.00000000,90.00000000); //object(elmtreegrn_hism)(3)
	CreateDynamicObject(9682,-1376.69995117,1167.59997559,1.29999995,0.00000000,0.00000000,0.00000000); //object(carspaces1_sfw)(1)
	CreateDynamicObject(982,-1343.59997559,1153.69995117,15.39999962,0.00000000,0.00000000,269.95605469); //object(fenceshit)(67)
	CreateDynamicObject(8843,-1333.50000000,1195.90002441,14.80000019,0.99975586,0.00000000,90.00000000); //object(arrows01_lvs)(4)
	CreateDynamicObject(8843,-1358.40002441,1188.90002441,14.80000019,0.99975586,0.00000000,179.99450684); //object(arrows01_lvs)(5)
	CreateDynamicObject(8843,-1349.90002441,1166.30004883,14.80000019,0.99975586,0.00000000,269.98901367); //object(arrows01_lvs)(6)
	CreateDynamicObject(8843,-1327.30004883,1167.40002441,14.80000019,0.99975586,0.00000000,180.00000000); //object(arrows01_lvs)(7)
	CreateDynamicObject(8843,-1322.09997559,1154.80004883,14.80000019,0.99975586,0.00000000,359.98352051); //object(arrows01_lvs)(8)
	CreateDynamicObject(982,-1243.69995117,1211.30004883,15.39999962,0.00000000,0.00000000,89.97253418); //object(fenceshit)(67)
	CreateDynamicObject(982,-1218.09997559,1211.30004883,15.39999962,0.00000000,0.00000000,89.97253418); //object(fenceshit)(67)
	CreateDynamicObject(6910,-1246.59997559,1182.59997559,19.50000000,0.00000000,0.00000000,90.00000000); //object(vgnprtlstation_01)(1)
	CreateDynamicObject(982,-1282.09997559,1198.50000000,15.39999962,0.00000000,0.00000000,179.97253418); //object(fenceshit)(67)
	CreateDynamicObject(982,-1282.09997559,1182.50000000,15.39999962,0.00000000,0.00000000,179.96154785); //object(fenceshit)(67)
	CreateDynamicObject(5401,-1277.19995117,1195.50000000,16.79999924,0.00000000,0.00000000,280.00000000); //object(laegarages1nw)(1)
	CreateDynamicObject(5401,-1277.09997559,1188.00000000,16.79999924,0.00000000,0.00000000,279.98657227); //object(laegarages1nw)(2)
	CreateDynamicObject(982,-1282.09997559,1144.09997559,15.39999962,0.00000000,0.00000000,179.96154785); //object(fenceshit)(67)
	CreateDynamicObject(1673,-1309.59960938,1221.00000000,18.50000000,0.00000000,0.00000000,270.00000000); //object(roadsign)(1)
	CreateDynamicObject(1673,-1310.50000000,1221.69995117,18.50000000,0.00000000,0.00000000,89.99450684); //object(roadsign)(2)
	CreateDynamicObject(982,-1322.89941406,1231.39941406,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1297.30004883,1231.40002441,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1348.50000000,1231.40002441,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1374.09997559,1231.40002441,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1399.69995117,1231.40002441,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(983,-1415.50000000,1232.50000000,15.50000000,0.00000000,0.00000000,70.00000000); //object(fenceshit3)(2)
	CreateDynamicObject(983,-1420.59997559,1236.09997559,15.50000000,0.00000000,0.00000000,39.99389648); //object(fenceshit3)(3)
	CreateDynamicObject(983,-1423.19995117,1241.69995117,15.50000000,0.00000000,0.00000000,9.98474121); //object(fenceshit3)(4)
	CreateDynamicObject(983,-1423.19995117,1248.00000000,15.50000000,0.00000000,0.00000000,349.97558594); //object(fenceshit3)(5)
	CreateDynamicObject(983,-1420.59997559,1253.59997559,15.50000000,0.00000000,0.00000000,319.96948242); //object(fenceshit3)(6)
	CreateDynamicObject(983,-1415.50000000,1257.09997559,15.50000000,0.00000000,0.00000000,288.96582031); //object(fenceshit3)(7)
	CreateDynamicObject(983,-1409.30004883,1257.59997559,15.50000000,0.00000000,0.00000000,259.95690918); //object(fenceshit3)(8)
	CreateDynamicObject(983,-1403.69995117,1255.00000000,15.50000000,0.00000000,0.00000000,229.94750977); //object(fenceshit3)(9)
	CreateDynamicObject(983,-1398.80004883,1250.90002441,15.50000000,0.00000000,0.00000000,229.94384766); //object(fenceshit3)(10)
	CreateDynamicObject(983,-1393.90002441,1246.80004883,15.50000000,0.00000000,0.00000000,229.94384766); //object(fenceshit3)(11)
	CreateDynamicObject(983,-1389.00000000,1242.69995117,15.50000000,0.00000000,0.00000000,229.94384766); //object(fenceshit3)(12)
	CreateDynamicObject(983,-1384.09997559,1238.59997559,15.50000000,0.00000000,0.00000000,229.94384766); //object(fenceshit3)(13)
	CreateDynamicObject(983,-1378.90002441,1234.90002441,15.50000000,0.00000000,0.00000000,239.19384766); //object(fenceshit3)(14)
	CreateDynamicObject(983,-1430.09997559,1211.90002441,15.50000000,0.00000000,0.00000000,79.98474121); //object(fenceshit3)(16)
	CreateDynamicObject(983,-1436.19995117,1213.50000000,15.50000000,0.00000000,0.00000000,69.97497559); //object(fenceshit3)(17)
	CreateDynamicObject(983,-1442.00000000,1216.19995117,15.50000000,0.00000000,0.00000000,59.97192383); //object(fenceshit3)(18)
	CreateDynamicObject(983,-1447.19995117,1219.80004883,15.50000000,0.00000000,0.00000000,49.96887207); //object(fenceshit3)(19)
	CreateDynamicObject(983,-1451.09997559,1224.80004883,15.50000000,0.00000000,0.00000000,25.96032715); //object(fenceshit3)(20)
	CreateDynamicObject(983,-1452.00000000,1260.80004883,15.50000000,0.00000000,0.00000000,349.94970703); //object(fenceshit3)(21)
	CreateDynamicObject(983,-1449.80004883,1266.69995117,15.50000000,0.00000000,0.00000000,327.94750977); //object(fenceshit3)(22)
	CreateDynamicObject(983,-1445.30004883,1271.00000000,15.50000000,0.00000000,0.00000000,299.94738770); //object(fenceshit3)(23)
	CreateDynamicObject(983,-1439.50000000,1273.69995117,15.50000000,0.00000000,0.00000000,289.94323730); //object(fenceshit3)(24)
	CreateDynamicObject(983,-1433.50000000,1275.90002441,15.50000000,0.00000000,0.00000000,289.93469238); //object(fenceshit3)(25)
	CreateDynamicObject(983,-1427.50000000,1278.09997559,15.50000000,0.00000000,0.00000000,289.93469238); //object(fenceshit3)(26)
	CreateDynamicObject(983,-1421.30004883,1279.69995117,15.50000000,0.00000000,0.00000000,279.18469238); //object(fenceshit3)(27)
	CreateDynamicObject(983,-1414.90002441,1280.19995117,15.50000000,0.00000000,0.00000000,269.93457031); //object(fenceshit3)(28)
	CreateDynamicObject(983,-1408.50000000,1280.19995117,15.50000000,0.00000000,0.00000000,269.93408203); //object(fenceshit3)(29)
	CreateDynamicObject(983,-1402.09997559,1279.59997559,15.50000000,0.00000000,0.00000000,259.43408203); //object(fenceshit3)(30)
	CreateDynamicObject(983,-1396.19995117,1277.40002441,15.50000000,0.00000000,0.00000000,239.67565918); //object(fenceshit3)(31)
	CreateDynamicObject(983,-1391.00000000,1273.69995117,15.50000000,0.00000000,0.00000000,229.66674805); //object(fenceshit3)(32)
	CreateDynamicObject(983,-1391.00000000,1273.69921875,15.50000000,0.00000000,0.00000000,229.90820312); //object(fenceshit3)(33)
	CreateDynamicObject(983,-1386.09997559,1269.59997559,15.50000000,0.00000000,0.00000000,229.89990234); //object(fenceshit3)(34)
	CreateDynamicObject(983,-1381.19995117,1265.50000000,15.50000000,0.00000000,0.00000000,229.89990234); //object(fenceshit3)(35)
	CreateDynamicObject(983,-1376.30004883,1261.40002441,15.50000000,0.00000000,0.00000000,229.89990234); //object(fenceshit3)(36)
	CreateDynamicObject(983,-1371.09997559,1257.69995117,15.50000000,0.00000000,0.00000000,239.89990234); //object(fenceshit3)(37)
	CreateDynamicObject(983,-1365.30004883,1255.00000000,15.50000000,0.00000000,0.00000000,249.89746094); //object(fenceshit3)(38)
	CreateDynamicObject(983,-1359.09997559,1253.40002441,15.50000000,0.00000000,0.00000000,261.14501953); //object(fenceshit3)(39)
	CreateDynamicObject(983,-1352.69921875,1252.89941406,15.50000000,0.00000000,0.00000000,270.13732910); //object(fenceshit3)(40)
	CreateDynamicObject(983,-1373.09997559,1232.40002441,15.50000000,0.00000000,0.00000000,255.18884277); //object(fenceshit3)(41)
	CreateDynamicObject(982,-1348.50000000,1231.39941406,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1336.80004883,1252.80004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1319.19995117,1252.80004883,15.39999962,0.00000000,0.00000000,89.97802734); //object(fenceshit)(67)
	CreateDynamicObject(969,-1291.19995117,1238.00000000,0.00000000,0.00000000,0.00000000,0.00000000); //object(electricgate)(1)
	CreateDynamicObject(983,-1303.09997559,1252.80004883,15.39999962,0.00000000,0.00000000,270.00000000); //object(fenceshit3)(42)
	CreateDynamicObject(983,-1296.90002441,1253.90002441,15.39999962,0.00000000,0.00000000,289.99450684); //object(fenceshit3)(43)
	CreateDynamicObject(983,-1291.40002441,1257.09997559,15.39999962,0.00000000,0.00000000,309.98962402); //object(fenceshit3)(44)
	CreateDynamicObject(983,-1287.40002441,1261.90002441,15.39999962,0.00000000,0.00000000,329.97924805); //object(fenceshit3)(45)
	CreateDynamicObject(983,-1285.19995117,1267.80004883,15.39999962,0.00000000,0.00000000,349.96887207); //object(fenceshit3)(46)
	CreateDynamicObject(983,-1285.19995117,1274.09997559,15.39999962,0.00000000,0.00000000,9.95849609); //object(fenceshit3)(47)
	CreateDynamicObject(983,-1287.40002441,1280.00000000,15.39999962,0.00000000,0.00000000,30.44812012); //object(fenceshit3)(48)
	CreateDynamicObject(983,-1291.80004883,1284.40002441,15.39999962,0.00000000,0.00000000,59.93762207); //object(fenceshit3)(49)
	CreateDynamicObject(983,-1297.69995117,1286.59997559,15.39999962,0.00000000,0.00000000,79.93041992); //object(fenceshit3)(50)
	CreateDynamicObject(983,-1304.00000000,1286.59997559,15.39999962,0.00000000,0.00000000,99.92553711); //object(fenceshit3)(51)
	CreateDynamicObject(983,-1309.90002441,1284.50000000,15.39999962,0.00000000,0.00000000,119.91516113); //object(fenceshit3)(52)
	CreateDynamicObject(983,-1314.69995117,1280.50000000,15.39999962,0.00000000,0.00000000,139.90478516); //object(fenceshit3)(53)
	CreateDynamicObject(983,-1318.40002441,1275.30004883,15.39999962,0.00000000,0.00000000,149.89990234); //object(fenceshit3)(54)
	CreateDynamicObject(983,-1321.59997559,1269.80004883,15.39999962,0.00000000,0.00000000,149.89196777); //object(fenceshit3)(55)
	CreateDynamicObject(983,-1324.80004883,1264.30004883,15.39999962,0.00000000,0.00000000,149.88647461); //object(fenceshit3)(56)
	CreateDynamicObject(983,-1328.50000000,1259.09997559,15.39999962,0.00000000,0.00000000,139.38647461); //object(fenceshit3)(57)
	CreateDynamicObject(983,-1333.40002441,1255.09997559,15.39999962,0.00000000,0.00000000,117.87805176); //object(fenceshit3)(58)
	CreateDynamicObject(983,-1339.40002441,1253.19995117,15.39999962,0.00000000,0.00000000,97.37231445); //object(fenceshit3)(59)
	CreateDynamicObject(983,-1287.90002441,1232.50000000,15.39999962,0.00000000,0.00000000,289.98962402); //object(fenceshit3)(60)
	CreateDynamicObject(983,-1282.09997559,1235.19995117,15.39999962,0.00000000,0.00000000,299.98962402); //object(fenceshit3)(61)
	CreateDynamicObject(983,-1276.90002441,1238.80004883,15.39999962,0.00000000,0.00000000,309.98168945); //object(fenceshit3)(62)
	CreateDynamicObject(983,-1272.40002441,1243.30004883,15.39999962,0.00000000,0.00000000,319.97375488); //object(fenceshit3)(63)
	CreateDynamicObject(983,-1268.69995117,1248.50000000,15.39999962,0.00000000,0.00000000,329.97131348); //object(fenceshit3)(64)
	CreateDynamicObject(983,-1266.00000000,1254.30004883,15.39999962,0.00000000,0.00000000,339.96337891); //object(fenceshit3)(65)
	CreateDynamicObject(983,-1264.30004883,1260.50000000,15.39999962,0.00000000,0.00000000,349.95544434); //object(fenceshit3)(66)
	CreateDynamicObject(983,-1263.69995117,1266.80004883,15.39999962,0.00000000,0.00000000,359.95300293); //object(fenceshit3)(67)
	CreateDynamicObject(983,-1263.69995117,1273.19995117,15.39999962,0.00000000,0.00000000,359.94506836); //object(fenceshit3)(68)
	CreateDynamicObject(983,-1263.69995117,1279.59997559,15.39999962,0.00000000,0.00000000,359.94506836); //object(fenceshit3)(69)
	CreateDynamicObject(983,-1264.19995117,1285.90002441,15.39999962,0.00000000,0.00000000,9.68408203); //object(fenceshit3)(70)
	CreateDynamicObject(983,-1265.80004883,1292.09997559,15.39999962,0.00000000,0.00000000,19.67346191); //object(fenceshit3)(71)
	CreateDynamicObject(983,-1268.50000000,1297.90002441,15.39999962,0.00000000,0.00000000,29.67102051); //object(fenceshit3)(72)
	CreateDynamicObject(983,-1272.50000000,1302.69995117,15.39999962,0.00000000,0.00000000,49.66308594); //object(fenceshit3)(73)
	CreateDynamicObject(983,-1277.69995117,1306.40002441,15.39999962,0.00000000,0.00000000,59.65270996); //object(fenceshit3)(74)
	CreateDynamicObject(983,-1283.40002441,1309.09997559,15.39999962,0.00000000,0.00000000,69.64477539); //object(fenceshit3)(75)
	CreateDynamicObject(983,-1289.50000000,1310.80004883,15.39999962,0.00000000,0.00000000,79.64233398); //object(fenceshit3)(76)
	CreateDynamicObject(983,-1295.90002441,1311.40002441,15.39999962,0.00000000,0.00000000,89.63989258); //object(fenceshit3)(77)
	CreateDynamicObject(983,-1302.30004883,1311.40002441,15.39999962,0.00000000,0.00000000,89.63745117); //object(fenceshit3)(78)
	CreateDynamicObject(983,-1308.69995117,1311.50000000,15.39999962,0.00000000,0.00000000,89.63745117); //object(fenceshit3)(79)
	CreateDynamicObject(983,-1315.09997559,1311.00000000,15.39999962,0.00000000,0.00000000,99.63745117); //object(fenceshit3)(80)
	CreateDynamicObject(983,-1321.30004883,1309.40002441,15.39999962,0.00000000,0.00000000,109.63500977); //object(fenceshit3)(81)
	CreateDynamicObject(983,-1326.80004883,1306.30004883,15.39999962,0.00000000,0.00000000,129.62707520); //object(fenceshit3)(82)
	CreateDynamicObject(983,-1330.90002441,1301.50000000,15.39999962,0.00000000,0.00000000,149.61669922); //object(fenceshit3)(83)
	CreateDynamicObject(983,-1334.19995117,1296.00000000,15.39999962,0.00000000,0.00000000,149.61181641); //object(fenceshit3)(84)
	CreateDynamicObject(983,-1337.40002441,1290.50000000,15.39999962,0.00000000,0.00000000,149.61181641); //object(fenceshit3)(85)
	CreateDynamicObject(983,-1340.59997559,1285.00000000,15.39999962,0.00000000,0.00000000,149.61181641); //object(fenceshit3)(86)
	CreateDynamicObject(983,-1343.80004883,1279.50000000,15.39999962,0.00000000,0.00000000,149.61181641); //object(fenceshit3)(87)
	CreateDynamicObject(983,-1348.19995117,1275.19995117,15.39999962,0.00000000,0.00000000,119.61181641); //object(fenceshit3)(88)
	CreateDynamicObject(983,-1354.09997559,1274.09997559,15.39999962,0.00000000,0.00000000,79.60266113); //object(fenceshit3)(89)
	CreateDynamicObject(983,-1359.69995117,1276.69995117,15.39999962,0.00000000,0.00000000,49.59594727); //object(fenceshit3)(90)
	CreateDynamicObject(982,-1370.30004883,1288.59997559,15.39999962,0.00000000,0.00000000,39.97802734); //object(fenceshit)(67)
	CreateDynamicObject(982,-1384.90002441,1309.50000000,15.39999962,0.00000000,0.00000000,29.97375488); //object(fenceshit)(67)
	CreateDynamicObject(982,-1399.90002441,1286.90002441,15.39999962,0.00000000,0.00000000,29.96520996); //object(fenceshit)(67)
	CreateDynamicObject(982,-1412.69995117,1309.09997559,15.39999962,0.00000000,0.00000000,29.96520996); //object(fenceshit)(67)
	CreateDynamicObject(982,-1397.69995117,1331.69995117,15.39999962,0.00000000,0.00000000,29.96520996); //object(fenceshit)(67)
	CreateDynamicObject(983,-1421.19995117,1322.59997559,15.39999962,0.00000000,0.00000000,39.59594727); //object(fenceshit3)(91)
	CreateDynamicObject(983,-1425.69995117,1327.09997559,15.39999962,0.00000000,0.00000000,49.58923340); //object(fenceshit3)(92)
	CreateDynamicObject(983,-1430.90002441,1330.80004883,15.39999962,0.00000000,0.00000000,59.58679199); //object(fenceshit3)(93)
	CreateDynamicObject(983,-1436.59997559,1333.50000000,15.39999962,0.00000000,0.00000000,69.57885742); //object(fenceshit3)(94)
	CreateDynamicObject(983,-1442.69995117,1335.19995117,15.39999962,0.00000000,0.00000000,79.57092285); //object(fenceshit3)(95)
	CreateDynamicObject(983,-1449.00000000,1335.80004883,15.39999962,0.00000000,0.00000000,89.56848145); //object(fenceshit3)(96)
	CreateDynamicObject(982,-1464.80004883,1338.09997559,15.39999962,0.00000000,0.00000000,79.95605469); //object(fenceshit)(67)
	CreateDynamicObject(983,-1406.09997559,1345.19995117,15.39999962,0.00000000,0.00000000,39.57885742); //object(fenceshit3)(97)
	CreateDynamicObject(983,-1410.59997559,1349.80004883,15.39999962,0.00000000,0.00000000,49.57275391); //object(fenceshit3)(98)
	CreateDynamicObject(983,-1415.80004883,1353.50000000,15.39999962,0.00000000,0.00000000,59.56481934); //object(fenceshit3)(99)
	CreateDynamicObject(983,-1421.59997559,1356.30004883,15.39999962,0.00000000,0.00000000,69.55688477); //object(fenceshit3)(100)
	CreateDynamicObject(983,-1427.69995117,1358.00000000,15.39999962,0.00000000,0.00000000,79.54895020); //object(fenceshit3)(101)
	CreateDynamicObject(983,-1434.00000000,1359.19995117,15.39999962,0.00000000,0.00000000,79.54650879); //object(fenceshit3)(102)
	CreateDynamicObject(983,-1440.30004883,1359.80004883,15.39999962,0.00000000,0.00000000,89.54650879); //object(fenceshit3)(103)
	CreateDynamicObject(982,-1456.09997559,1362.00000000,15.39999962,0.00000000,0.00000000,79.95605469); //object(fenceshit)(67)
	CreateDynamicObject(982,-1481.30004883,1366.50000000,15.39999962,0.00000000,0.00000000,79.94750977); //object(fenceshit)(67)
	CreateDynamicObject(982,-1490.00000000,1342.59997559,15.39999962,0.00000000,0.00000000,79.94750977); //object(fenceshit)(67)
	CreateDynamicObject(983,-1497.00000000,1369.30004883,15.39999962,0.00000000,0.00000000,79.54650879); //object(fenceshit3)(105)
	CreateDynamicObject(983,-1503.09997559,1371.00000000,15.39999962,0.00000000,0.00000000,69.54650879); //object(fenceshit3)(106)
	CreateDynamicObject(983,-1508.80004883,1373.69995117,15.39999962,0.00000000,0.00000000,59.53796387); //object(fenceshit3)(107)
	CreateDynamicObject(983,-1514.00000000,1377.40002441,15.39999962,0.00000000,0.00000000,49.52941895); //object(fenceshit3)(108)
	CreateDynamicObject(983,-1518.50000000,1382.00000000,15.39999962,0.00000000,0.00000000,39.52087402); //object(fenceshit3)(109)
	CreateDynamicObject(983,-1521.59997559,1387.50000000,15.39999962,0.00000000,0.00000000,19.51782227); //object(fenceshit3)(110)
	CreateDynamicObject(983,-1522.59997559,1393.69995117,15.39999962,0.00000000,0.00000000,359.51171875); //object(fenceshit3)(111)
	CreateDynamicObject(983,-1521.40002441,1399.90002441,15.39999962,0.00000000,0.00000000,339.51660156); //object(fenceshit3)(112)
	CreateDynamicObject(983,-1518.19995117,1405.40002441,15.39999962,0.00000000,0.00000000,319.51049805); //object(fenceshit3)(113)
	CreateDynamicObject(983,-1513.09997559,1408.90002441,15.39999962,0.00000000,0.00000000,289.50439453); //object(fenceshit3)(114)
	CreateDynamicObject(983,-1506.90002441,1409.90002441,15.39999962,0.00000000,0.00000000,269.49523926); //object(fenceshit3)(115)
	CreateDynamicObject(983,-1501.00000000,1408.19995117,15.39999962,0.00000000,0.00000000,239.49462891); //object(fenceshit3)(116)
	CreateDynamicObject(983,-1496.19995117,1404.09997559,15.39999962,0.00000000,0.00000000,219.48547363); //object(fenceshit3)(117)
	CreateDynamicObject(983,-1493.09997559,1398.59997559,15.39999962,0.00000000,0.00000000,199.47937012); //object(fenceshit3)(118)
	CreateDynamicObject(983,-1491.50000000,1392.40002441,15.39999962,0.00000000,0.00000000,189.47326660); //object(fenceshit3)(119)
	CreateDynamicObject(983,-1490.50000000,1386.09997559,15.39999962,0.00000000,0.00000000,189.47021484); //object(fenceshit3)(120)
	CreateDynamicObject(983,-1488.90002441,1380.00000000,15.39999962,0.00000000,0.00000000,199.47021484); //object(fenceshit3)(121)
	CreateDynamicObject(983,-1485.80004883,1374.50000000,15.39999962,0.00000000,0.00000000,219.46228027); //object(fenceshit3)(122)
	CreateDynamicObject(983,-1481.30004883,1370.00000000,15.39999962,0.00000000,0.00000000,230.70739746); //object(fenceshit3)(123)
	CreateDynamicObject(983,-1475.90002441,1366.80004883,15.39999962,0.00000000,0.00000000,248.95190430); //object(fenceshit3)(124)
	CreateDynamicObject(983,-1469.80004883,1364.80004883,15.39999962,0.00000000,0.00000000,254.94470215); //object(fenceshit3)(125)
	CreateDynamicObject(983,-1505.69995117,1345.40002441,15.39999962,0.00000000,0.00000000,79.52087402); //object(fenceshit3)(126)
	CreateDynamicObject(983,-1511.80004883,1347.09997559,15.39999962,0.00000000,0.00000000,69.51354980); //object(fenceshit3)(127)
	CreateDynamicObject(983,-1517.59997559,1349.80004883,15.39999962,0.00000000,0.00000000,59.50500488); //object(fenceshit3)(128)
	CreateDynamicObject(983,-1522.80004883,1353.50000000,15.39999962,0.00000000,0.00000000,49.50195312); //object(fenceshit3)(129)
	CreateDynamicObject(983,-1527.30004883,1358.09997559,15.39999962,0.00000000,0.00000000,39.49890137); //object(fenceshit3)(130)
	CreateDynamicObject(983,-1531.00000000,1363.40002441,15.39999962,0.00000000,0.00000000,29.49584961); //object(fenceshit3)(131)
	CreateDynamicObject(983,-1534.09997559,1369.00000000,15.39999962,0.00000000,0.00000000,29.48730469); //object(fenceshit3)(135)
	CreateDynamicObject(983,-1536.80004883,1374.80004883,15.39999962,0.00000000,0.00000000,19.48730469); //object(fenceshit3)(136)
	CreateDynamicObject(983,-1538.90002441,1380.80004883,15.39999962,0.00000000,0.00000000,19.47875977); //object(fenceshit3)(137)
	CreateDynamicObject(983,-1540.50000000,1387.00000000,15.39999962,0.00000000,0.00000000,9.47875977); //object(fenceshit3)(138)
	CreateDynamicObject(983,-1541.59997559,1393.30004883,15.39999962,0.00000000,0.00000000,9.47570801); //object(fenceshit3)(139)
	CreateDynamicObject(984,-1542.19995117,1402.90002441,15.39999962,0.00000000,0.00000000,0.00000000); //object(fenceshit2)(1)
	CreateDynamicObject(984,-1540.00000000,1415.30004883,15.39999962,0.00000000,0.00000000,340.00000000); //object(fenceshit2)(2)
	CreateDynamicObject(984,-1533.69995117,1426.19995117,15.39999962,0.00000000,0.00000000,319.99389648); //object(fenceshit2)(3)
	CreateDynamicObject(984,-1523.59997559,1433.30004883,15.39999962,0.00000000,0.00000000,289.98779297); //object(fenceshit2)(4)
	CreateDynamicObject(984,-1511.19995117,1435.50000000,15.39999962,0.00000000,0.00000000,269.98413086); //object(fenceshit2)(5)
	CreateDynamicObject(984,-1498.80004883,1433.30004883,15.39999962,0.00000000,0.00000000,249.97802734); //object(fenceshit2)(6)
	CreateDynamicObject(984,-1487.90002441,1427.00000000,15.39999962,0.00000000,0.00000000,229.96948242); //object(fenceshit2)(7)
	CreateDynamicObject(984,-1478.90002441,1418.00000000,15.39999962,0.00000000,0.00000000,219.96582031); //object(fenceshit2)(8)
	CreateDynamicObject(984,-1472.59997559,1407.09997559,15.39999962,0.00000000,0.00000000,199.95727539); //object(fenceshit2)(9)
	CreateDynamicObject(984,-1469.30004883,1394.80004883,15.39999962,0.00000000,0.00000000,189.95117188); //object(fenceshit2)(10)
	CreateDynamicObject(983,-1467.09997559,1385.50000000,15.39999962,0.00000000,0.00000000,199.45739746); //object(fenceshit3)(140)
	CreateDynamicObject(983,-1464.00000000,1380.00000000,15.39999962,0.00000000,0.00000000,219.45678711); //object(fenceshit3)(141)
	CreateDynamicObject(983,-1459.19995117,1375.90002441,15.39999962,0.00000000,0.00000000,239.45190430); //object(fenceshit3)(142)
	CreateDynamicObject(983,-1453.30004883,1373.69995117,15.39999962,0.00000000,0.00000000,259.44702148); //object(fenceshit3)(143)
	CreateDynamicObject(983,-1447.00000000,1373.59997559,15.39999962,0.00000000,0.00000000,279.43664551); //object(fenceshit3)(144)
	CreateDynamicObject(983,-1441.09997559,1375.69995117,15.39999962,0.00000000,0.00000000,299.43176270); //object(fenceshit3)(145)
	CreateDynamicObject(983,-1436.19995117,1379.69995117,15.39999962,0.00000000,0.00000000,319.42138672); //object(fenceshit3)(146)
	CreateDynamicObject(983,-1436.19921875,1379.69921875,15.39999962,0.00000000,0.00000000,319.41101074); //object(fenceshit3)(147)
	CreateDynamicObject(982,-1425.90002441,1391.90002441,15.39999962,0.00000000,0.00000000,139.96520996); //object(fenceshit)(67)
	CreateDynamicObject(982,-1409.40002441,1411.50000000,15.39999962,0.00000000,0.00000000,139.95483398); //object(fenceshit)(67)
	CreateDynamicObject(983,-1434.09997559,1360.90002441,15.39999962,0.00000000,0.00000000,289.43176270); //object(fenceshit3)(148)
	CreateDynamicObject(983,-1428.69995117,1363.90002441,15.39999962,0.00000000,0.00000000,309.42382812); //object(fenceshit3)(149)
	CreateDynamicObject(983,-1424.09997559,1368.40002441,15.39999962,0.00000000,0.00000000,319.41894531); //object(fenceshit3)(150)
	CreateDynamicObject(982,-1413.80004883,1380.59997559,15.39999962,0.00000000,0.00000000,139.95483398); //object(fenceshit)(67)
	CreateDynamicObject(982,-1397.30004883,1400.19995117,15.39999962,0.00000000,0.00000000,139.95480347); //object(fenceshit)(67)
	CreateDynamicObject(984,-1396.30004883,1425.40002441,15.39999962,0.00000000,0.00000000,310.00000000); //object(fenceshit2)(11)
	CreateDynamicObject(984,-1385.90002441,1432.69995117,15.39999962,0.00000000,0.00000000,299.99023438); //object(fenceshit2)(12)
	CreateDynamicObject(984,-1374.30004883,1438.09997559,15.39999962,0.00000000,0.00000000,289.98168945); //object(fenceshit2)(13)
	CreateDynamicObject(984,-1362.00000000,1441.40002441,15.39999962,0.00000000,0.00000000,279.97863770); //object(fenceshit2)(14)
	CreateDynamicObject(984,-1349.30004883,1442.50000000,15.39999962,0.00000000,0.00000000,269.97558594); //object(fenceshit2)(15)
	CreateDynamicObject(984,-1384.09997559,1414.09997559,15.39999962,0.00000000,0.00000000,309.96704102); //object(fenceshit2)(16)
	CreateDynamicObject(984,-1373.19995117,1420.40002441,15.39999962,0.00000000,0.00000000,289.96276855); //object(fenceshit2)(17)
	CreateDynamicObject(984,-1360.90002441,1423.69995117,15.39999962,0.00000000,0.00000000,279.95666504); //object(fenceshit2)(18)
	CreateDynamicObject(984,-1348.19995117,1424.80004883,15.39999962,0.00000000,0.00000000,269.94812012); //object(fenceshit2)(19)
	CreateDynamicObject(982,-1329.00000000,1424.80004883,15.39999962,0.00000000,0.00000000,89.95483398); //object(fenceshit)(67)
	CreateDynamicObject(982,-1330.09997559,1442.50000000,15.39999962,0.00000000,0.00000000,89.95056152); //object(fenceshit)(67)
	CreateDynamicObject(982,-1304.50000000,1442.50000000,15.39999962,0.00000000,0.00000000,89.95056152); //object(fenceshit)(67)
	CreateDynamicObject(982,-1278.90002441,1442.50000000,15.39999962,0.00000000,0.00000000,89.95056152); //object(fenceshit)(67)
	CreateDynamicObject(982,-1253.30004883,1442.50000000,15.39999962,0.00000000,0.00000000,89.95056152); //object(fenceshit)(67)
	CreateDynamicObject(982,-1303.40002441,1424.80004883,15.39999962,0.00000000,0.00000000,89.95056152); //object(fenceshit)(67)
	CreateDynamicObject(982,-1277.80004883,1424.80004883,15.39999962,0.00000000,0.00000000,89.95056152); //object(fenceshit)(67)
	CreateDynamicObject(982,-1252.19995117,1424.80004883,15.39999962,0.00000000,0.00000000,89.95056152); //object(fenceshit)(67)
	CreateDynamicObject(983,-1236.19995117,1424.69995117,15.50000000,0.00000000,0.00000000,90.00000000); //object(fenceshit3)(151)
	CreateDynamicObject(983,-1230.00000000,1423.59997559,15.50000000,0.00000000,0.00000000,69.99450684); //object(fenceshit3)(152)
	CreateDynamicObject(983,-1224.59997559,1420.50000000,15.50000000,0.00000000,0.00000000,49.99389648); //object(fenceshit3)(153)
	CreateDynamicObject(983,-1220.50000000,1415.69995117,15.50000000,0.00000000,0.00000000,29.98779297); //object(fenceshit3)(154)
	CreateDynamicObject(983,-1218.30004883,1409.80004883,15.50000000,0.00000000,0.00000000,9.98718262); //object(fenceshit3)(155)
	CreateDynamicObject(983,-1218.30004883,1403.50000000,15.50000000,0.00000000,0.00000000,349.98107910); //object(fenceshit3)(156)
	CreateDynamicObject(983,-1220.50000000,1397.50000000,15.50000000,0.00000000,0.00000000,329.97497559); //object(fenceshit3)(157)
	CreateDynamicObject(983,-1224.59997559,1392.69995117,15.50000000,0.00000000,0.00000000,309.96887207); //object(fenceshit3)(158)
	CreateDynamicObject(983,-1230.09997559,1389.50000000,15.50000000,0.00000000,0.00000000,289.96276855); //object(fenceshit3)(159)
	CreateDynamicObject(983,-1236.30004883,1388.40002441,15.50000000,0.00000000,0.00000000,269.95666504); //object(fenceshit3)(160)
	CreateDynamicObject(984,-1234.09997559,1442.50000000,15.39999962,0.00000000,0.00000000,90.00000000); //object(fenceshit2)(20)
	CreateDynamicObject(984,-1221.40002441,1441.40002441,15.39999962,0.00000000,0.00000000,79.99450684); //object(fenceshit2)(21)
	CreateDynamicObject(984,-1209.09997559,1438.09997559,15.39999962,0.00000000,0.00000000,69.99145508); //object(fenceshit2)(22)
	CreateDynamicObject(984,-1198.19995117,1431.80004883,15.39999962,0.00000000,0.00000000,49.98291016); //object(fenceshit2)(23)
	CreateDynamicObject(984,-1190.09997559,1422.09997559,15.39999962,0.00000000,0.00000000,29.97680664); //object(fenceshit2)(24)
	CreateDynamicObject(984,-1186.90002441,1410.09997559,15.39999962,0.00000000,0.00000000,359.97619629); //object(fenceshit2)(25)
	CreateDynamicObject(984,-1189.09997559,1397.69995117,15.39999962,0.00000000,0.00000000,339.97802734); //object(fenceshit2)(26)
	CreateDynamicObject(984,-1195.40002441,1386.80004883,15.39999962,0.00000000,0.00000000,319.97192383); //object(fenceshit2)(27)
	CreateDynamicObject(984,-1205.09997559,1378.69995117,15.39999962,0.00000000,0.00000000,299.97131348); //object(fenceshit2)(28)
	CreateDynamicObject(984,-1216.59997559,1373.40002441,15.39999962,0.00000000,0.00000000,289.96520996); //object(fenceshit2)(29)
	CreateDynamicObject(984,-1228.90002441,1370.09997559,15.39999962,0.00000000,0.00000000,279.95666504); //object(fenceshit2)(30)
	CreateDynamicObject(984,-1241.59997559,1369.00000000,15.39999962,0.00000000,0.00000000,269.94812012); //object(fenceshit2)(31)
	CreateDynamicObject(984,-1245.80004883,1389.59997559,15.39999962,0.00000000,0.00000000,259.94506836); //object(fenceshit2)(32)
	CreateDynamicObject(984,-1258.09997559,1392.90002441,15.39999962,0.00000000,0.00000000,249.94201660); //object(fenceshit2)(33)
	CreateDynamicObject(984,-1270.50000000,1395.09997559,15.39999962,0.00000000,0.00000000,269.93347168); //object(fenceshit2)(34)
	CreateDynamicObject(984,-1282.90002441,1392.90002441,15.39999962,0.00000000,0.00000000,289.92309570); //object(fenceshit2)(35)
	CreateDynamicObject(984,-1293.00000000,1385.80004883,15.39999962,0.00000000,0.00000000,319.91821289); //object(fenceshit2)(36)
	CreateDynamicObject(984,-1298.19995117,1374.59997559,15.39999962,0.00000000,0.00000000,349.91088867); //object(fenceshit2)(37)
	CreateDynamicObject(984,-1297.19995117,1362.30004883,15.39999962,0.00000000,0.00000000,19.90356445); //object(fenceshit2)(38)
	CreateDynamicObject(984,-1290.90002441,1351.40002441,15.39999962,0.00000000,0.00000000,39.89624023); //object(fenceshit2)(39)
	CreateDynamicObject(984,-1281.90002441,1342.40002441,15.39999962,0.00000000,0.00000000,49.88586426); //object(fenceshit2)(40)
	CreateDynamicObject(983,-1251.00000000,1370.09997559,15.50000000,0.00000000,0.00000000,249.95605469); //object(fenceshit3)(161)
	CreateDynamicObject(983,-1256.80004883,1372.69995117,15.50000000,0.00000000,0.00000000,239.94995117); //object(fenceshit3)(162)
	CreateDynamicObject(983,-1262.69995117,1374.90002441,15.50000000,0.00000000,0.00000000,259.94140625); //object(fenceshit3)(163)
	CreateDynamicObject(983,-1269.00000000,1374.90002441,15.50000000,0.00000000,0.00000000,279.93652344); //object(fenceshit3)(164)
	CreateDynamicObject(983,-1274.90002441,1372.80004883,15.50000000,0.00000000,0.00000000,299.92614746); //object(fenceshit3)(165)
	CreateDynamicObject(983,-1278.80004883,1368.19995117,15.50000000,0.00000000,0.00000000,339.92126465); //object(fenceshit3)(166)
	CreateDynamicObject(983,-1279.30004883,1362.00000000,15.50000000,0.00000000,0.00000000,9.91699219); //object(fenceshit3)(167)
	CreateDynamicObject(983,-1276.69995117,1356.40002441,15.50000000,0.00000000,0.00000000,39.90966797); //object(fenceshit3)(168)
	CreateDynamicObject(983,-1272.69995117,1351.50000000,15.50000000,0.00000000,0.00000000,39.90783691); //object(fenceshit3)(169)
	CreateDynamicObject(984,-1265.69995117,1345.00000000,15.39999962,0.00000000,0.00000000,49.87792969); //object(fenceshit2)(41)
	CreateDynamicObject(984,-1272.90002441,1333.40002441,15.39999962,0.00000000,0.00000000,39.86694336); //object(fenceshit2)(42)
	CreateDynamicObject(984,-1265.59997559,1323.00000000,15.39999962,0.00000000,0.00000000,29.86389160); //object(fenceshit2)(43)
	CreateDynamicObject(984,-1260.19995117,1311.40002441,15.39999962,0.00000000,0.00000000,19.85534668); //object(fenceshit2)(44)
	CreateDynamicObject(984,-1257.00000000,1299.09997559,15.39999962,0.00000000,0.00000000,9.84680176); //object(fenceshit2)(45)
	CreateDynamicObject(984,-1255.50000000,1286.40002441,15.39999962,0.00000000,0.00000000,3.84375000); //object(fenceshit2)(46)
	CreateDynamicObject(984,-1255.90002441,1336.69995117,15.39999962,0.00000000,0.00000000,49.86694336); //object(fenceshit2)(47)
	CreateDynamicObject(984,-1246.90002441,1327.69995117,15.39999962,0.00000000,0.00000000,39.86694336); //object(fenceshit2)(48)
	CreateDynamicObject(984,-1239.59997559,1317.30004883,15.39999962,0.00000000,0.00000000,29.86389160); //object(fenceshit2)(49)
	CreateDynamicObject(984,-1234.19995117,1305.69995117,15.39999962,0.00000000,0.00000000,19.85534668); //object(fenceshit2)(50)
	CreateDynamicObject(984,-1230.90002441,1293.40002441,15.39999962,0.00000000,0.00000000,9.84680176); //object(fenceshit2)(51)
	CreateDynamicObject(984,-1229.80004883,1280.69995117,15.39999962,0.00000000,0.00000000,359.84375000); //object(fenceshit2)(52)
	CreateDynamicObject(984,-1230.09997559,1267.90002441,15.39999962,0.00000000,0.00000000,357.84069824); //object(fenceshit2)(53)
	CreateDynamicObject(984,-1255.80004883,1273.69995117,15.39999962,0.00000000,0.00000000,353.83972168); //object(fenceshit2)(55)
	CreateDynamicObject(984,-1258.30004883,1261.19995117,15.39999962,0.00000000,0.00000000,343.84216309); //object(fenceshit2)(56)
	CreateDynamicObject(984,-1262.90002441,1249.30004883,15.39999962,0.00000000,0.00000000,333.83911133); //object(fenceshit2)(57)
	CreateDynamicObject(983,-1267.69995117,1241.09997559,15.39999962,0.00000000,0.00000000,320.00000000); //object(fenceshit3)(170)
	CreateDynamicObject(983,-1272.19995117,1236.59997559,15.39999962,0.00000000,0.00000000,309.99328613); //object(fenceshit3)(171)
	CreateDynamicObject(983,-1277.69995117,1233.50000000,15.39999962,0.00000000,0.00000000,287.98474121); //object(fenceshit3)(172)
	CreateDynamicObject(983,-1281.40002441,1232.40002441,15.39999962,0.00000000,0.00000000,287.97912598); //object(fenceshit3)(174)
	CreateDynamicObject(984,-1231.69995117,1255.30004883,15.39999962,0.00000000,0.00000000,347.83569336); //object(fenceshit2)(58)
	CreateDynamicObject(984,-1235.50000000,1243.09997559,15.39999962,0.00000000,0.00000000,337.83264160); //object(fenceshit2)(59)
	CreateDynamicObject(984,-1241.30004883,1231.80004883,15.39999962,0.00000000,0.00000000,327.82409668); //object(fenceshit2)(60)
	CreateDynamicObject(984,-1249.00000000,1221.59997559,15.39999962,0.00000000,0.00000000,317.81555176); //object(fenceshit2)(61)
	CreateDynamicObject(984,-1259.00000000,1214.09997559,15.39999962,0.00000000,0.00000000,295.80700684); //object(fenceshit2)(62)
	CreateDynamicObject(1237,-1282.09997559,1211.30004883,14.80000019,0.00000000,0.00000000,0.00000000); //object(strtbarrier01)(1)
	CreateDynamicObject(1237,-1294.09997559,1211.30004883,14.80000019,0.00000000,0.00000000,0.00000000); //object(strtbarrier01)(2)
	CreateDynamicObject(1237,-1282.09997559,1156.90002441,14.80000019,0.00000000,0.00000000,0.00000000); //object(strtbarrier01)(3)
	CreateDynamicObject(1237,-1282.09997559,1169.69995117,14.80000019,0.00000000,0.00000000,0.00000000); //object(strtbarrier01)(4)
	CreateDynamicObject(1237,-1319.69995117,1153.69995117,14.80000019,0.00000000,0.00000000,0.00000000); //object(strtbarrier01)(5)
	CreateDynamicObject(1237,-1330.80004883,1153.69995117,14.80000019,0.00000000,0.00000000,0.00000000); //object(strtbarrier01)(6)
	CreateDynamicObject(3881,-1365.80004883,1138.30004883,16.60000038,0.00000000,0.00000000,270.00000000); //object(airsecbooth_sfse)(1)
	CreateDynamicObject(3882,-1365.19995117,1138.00000000,15.69999981,0.00000000,0.00000000,0.00000000); //object(airsecboothint_sfse)(1)
	CreateDynamicObject(3337,-1310.00000000,1187.09997559,14.00000000,0.00000000,0.00000000,179.99450684); //object(cxrf_desertsig)(2)
	CreateDynamicObject(3337,-1310.00000000,1182.09997559,14.00000000,0.00000000,0.00000000,179.99450684); //object(cxrf_desertsig)(3)
	CreateDynamicObject(6958,-1541.09997559,1145.59997559,13.89999962,0.00000000,0.00000000,0.00000000); //object(vgnmallsigns14)(1)
	CreateDynamicObject(9191,-1360.90002441,1153.69995117,11.50000000,0.00000000,0.00000000,0.00000000); //object(vgeastbillbrd03)(1)
	CreateDynamicObject(9191,-1344.19995117,1153.69995117,11.50000000,0.00000000,0.00000000,0.00000000); //object(vgeastbillbrd03)(2)
	CreateDynamicObject(9191,-1339.19995117,1153.69995117,11.50000000,0.00000000,0.00000000,0.00000000); //object(vgeastbillbrd03)(3)
	CreateDynamicObject(9191,-1311.30004883,1153.69995117,11.50000000,0.00000000,0.00000000,0.00000000); //object(vgeastbillbrd03)(4)
	CreateDynamicObject(9191,-1302.50000000,1153.69995117,11.50000000,0.00000000,0.00000000,0.00000000); //object(vgeastbillbrd03)(5)
	CreateDynamicObject(9191,-1294.00000000,1161.69995117,11.50000000,0.00000000,0.00000000,90.00000000); //object(vgeastbillbrd03)(6)
	CreateDynamicObject(9191,-1294.00000000,1178.59997559,11.50000000,0.00000000,0.00000000,89.99450684); //object(vgeastbillbrd03)(7)
	CreateDynamicObject(9191,-1294.00000000,1195.40002441,11.50000000,0.00000000,0.00000000,89.99450684); //object(vgeastbillbrd03)(8)
	CreateDynamicObject(9191,-1294.00000000,1202.69995117,11.50000000,0.00000000,0.00000000,89.99450684); //object(vgeastbillbrd03)(9)
	CreateDynamicObject(9191,-1310.40002441,1162.50000000,11.50000000,0.00000000,0.00000000,269.99450684); //object(vgeastbillbrd03)(10)
	CreateDynamicObject(9191,-1310.40002441,1179.30004883,11.50000000,0.00000000,0.00000000,269.98901367); //object(vgeastbillbrd03)(11)
	CreateDynamicObject(9191,-1310.40002441,1196.09997559,11.50000000,0.00000000,0.00000000,269.98901367); //object(vgeastbillbrd03)(12)
	CreateDynamicObject(9191,-1310.40002441,1202.80004883,11.50000000,0.00000000,0.00000000,269.98901367); //object(vgeastbillbrd03)(13)
	CreateDynamicObject(9191,-1318.80004883,1211.30004883,11.50000000,0.00000000,0.00000000,359.98901367); //object(vgeastbillbrd03)(14)
	CreateDynamicObject(9191,-1335.69995117,1211.30004883,11.50000000,0.00000000,0.00000000,359.98352051); //object(vgeastbillbrd03)(15)
	CreateDynamicObject(9191,-1352.50000000,1211.30004883,11.50000000,0.00000000,0.00000000,359.98352051); //object(vgeastbillbrd03)(16)
	CreateDynamicObject(9191,-1362.59997559,1211.30004883,11.50000000,0.00000000,0.00000000,359.98352051); //object(vgeastbillbrd03)(17)
	CreateDynamicObject(9191,-1370.80004883,1203.30004883,11.50000000,0.00000000,0.00000000,89.98352051); //object(vgeastbillbrd03)(18)
	CreateDynamicObject(9191,-1370.80004883,1186.40002441,11.50000000,0.00000000,0.00000000,89.97802734); //object(vgeastbillbrd03)(19)
	CreateDynamicObject(9191,-1370.80004883,1169.59997559,11.50000000,0.00000000,0.00000000,89.97802734); //object(vgeastbillbrd03)(20)
	CreateDynamicObject(9191,-1370.80004883,1163.90002441,11.50000000,0.00000000,0.00000000,89.97802734); //object(vgeastbillbrd03)(21)
	CreateDynamicObject(9191,-1282.09997559,1148.09997559,11.50000000,0.00000000,0.00000000,89.97802734); //object(vgeastbillbrd03)(22)
	CreateDynamicObject(9191,-1282.09997559,1139.59997559,11.50000000,0.00000000,0.00000000,89.97802734); //object(vgeastbillbrd03)(23)
	CreateDynamicObject(9191,-1282.09997559,1178.30004883,11.50000000,0.00000000,0.00000000,89.97802734); //object(vgeastbillbrd03)(24)
	CreateDynamicObject(9191,-1282.09997559,1195.09997559,11.50000000,0.00000000,0.00000000,89.97802734); //object(vgeastbillbrd03)(25)
	CreateDynamicObject(9191,-1282.09997559,1203.09997559,11.50000000,0.00000000,0.00000000,89.97802734); //object(vgeastbillbrd03)(26)
	CreateDynamicObject(7662,-1309.19995117,1167.80004883,14.30000019,0.00000000,0.00000000,0.00000000); //object(miragehedge14)(3)
	CreateDynamicObject(8991,-1309.50000000,1202.30004883,15.60000038,0.00000000,0.00000000,270.00000000); //object(bush12_lvs)(1)
	CreateDynamicObject(8991,-1309.50000000,1168.69995117,15.50000000,0.00000000,0.00000000,270.00000000); //object(bush12_lvs)(2)
	CreateDynamicObject(8991,-1309.00000000,1168.59997559,15.50000000,0.00000000,0.00000000,89.99450684); //object(bush12_lvs)(3)
	CreateDynamicObject(8991,-1309.00000000,1202.19995117,15.60000038,0.00000000,0.00000000,89.99450684); //object(bush12_lvs)(4)
	CreateDynamicObject(1280,-1303.50000000,1198.40002441,15.30000019,0.00000000,0.00000000,0.00000000); //object(parkbench1)(1)
	CreateDynamicObject(1280,-1302.90002441,1198.40002441,15.30000019,0.00000000,0.00000000,180.00000000); //object(parkbench1)(2)
	CreateDynamicObject(1280,-1303.00000000,1191.40002441,15.30000019,0.00000000,0.00000000,179.99450684); //object(parkbench1)(3)
	CreateDynamicObject(1280,-1303.69995117,1191.40002441,15.30000019,0.00000000,0.00000000,359.99450684); //object(parkbench1)(4)
	CreateDynamicObject(1280,-1303.69995117,1179.69995117,15.30000019,0.00000000,0.00000000,359.98901367); //object(parkbench1)(5)
	CreateDynamicObject(1280,-1303.09997559,1179.69995117,15.30000019,0.00000000,0.00000000,179.98901367); //object(parkbench1)(6)
	CreateDynamicObject(1280,-1303.09997559,1172.69995117,15.30000019,0.00000000,0.00000000,179.98352051); //object(parkbench1)(7)
	CreateDynamicObject(1280,-1303.69995117,1172.69995117,15.30000019,0.00000000,0.00000000,359.98352051); //object(parkbench1)(8)
	CreateDynamicObject(3398,-1412.30004883,1231.90002441,16.89999962,0.00000000,0.00000000,330.00000000); //object(cxrf_floodlite_)(1)
	CreateDynamicObject(3398,-1416.50000000,1255.40002441,16.89999962,0.00000000,0.00000000,219.99633789); //object(cxrf_floodlite_)(2)
	CreateDynamicObject(3398,-1422.80004883,1241.80004883,16.89999962,0.00000000,0.00000000,279.99023438); //object(cxrf_floodlite_)(3)
	CreateDynamicObject(3398,-1392.50000000,1232.40002441,16.89999962,0.00000000,0.00000000,359.98657227); //object(cxrf_floodlite_)(4)
	CreateDynamicObject(3398,-1402.09997559,1251.59997559,16.89999962,0.00000000,0.00000000,139.98352051); //object(cxrf_floodlite_)(5)
	CreateDynamicObject(3398,-1321.59997559,1253.00000000,16.89999962,0.00000000,0.00000000,359.98229980); //object(cxrf_floodlite_)(6)
	CreateDynamicObject(3398,-1300.19995117,1253.59997559,16.89999962,0.00000000,0.00000000,29.98352051); //object(cxrf_floodlite_)(7)
	CreateDynamicObject(3398,-1287.40002441,1264.40002441,16.89999962,0.00000000,0.00000000,79.97619629); //object(cxrf_floodlite_)(8)
	CreateDynamicObject(3398,-1289.19995117,1282.19995117,16.89999962,0.00000000,0.00000000,159.96948242); //object(cxrf_floodlite_)(9)
	CreateDynamicObject(3398,-1306.80004883,1285.80004883,16.89999962,0.00000000,0.00000000,209.96093750); //object(cxrf_floodlite_)(10)
	CreateDynamicObject(3398,-1341.19995117,1286.59997559,16.89999962,0.00000000,0.00000000,59.95971680); //object(cxrf_floodlite_)(11)
	CreateDynamicObject(3398,-1350.80004883,1274.69995117,16.89999962,0.00000000,0.00000000,359.95239258); //object(cxrf_floodlite_)(12)
	CreateDynamicObject(3398,-1365.80004883,1285.40002441,16.89999962,0.00000000,0.00000000,309.95605469); //object(cxrf_floodlite_)(13)
	CreateDynamicObject(3398,-1379.00000000,1300.00000000,16.89999962,0.00000000,0.00000000,299.95178223); //object(cxrf_floodlite_)(14)
	CreateDynamicObject(3398,-1412.00000000,1306.40002441,16.89999962,0.00000000,0.00000000,119.94323730); //object(cxrf_floodlite_)(15)
	CreateDynamicObject(3398,-1419.59997559,1320.59997559,16.89999962,0.00000000,0.00000000,129.94323730); //object(cxrf_floodlite_)(16)
	CreateDynamicObject(3398,-1431.40002441,1331.00000000,16.89999962,0.00000000,0.00000000,149.93530273); //object(cxrf_floodlite_)(17)
	CreateDynamicObject(3398,-1445.80004883,1335.50000000,16.89999962,0.00000000,0.00000000,179.92492676); //object(cxrf_floodlite_)(18)
	CreateDynamicObject(3398,-1483.09997559,1367.69995117,16.89999962,0.00000000,0.00000000,349.91760254); //object(cxrf_floodlite_)(19)
	CreateDynamicObject(3398,-1501.40002441,1371.09997559,16.89999962,0.00000000,0.00000000,339.90905762); //object(cxrf_floodlite_)(20)
	CreateDynamicObject(3398,-1516.80004883,1381.30004883,16.89999962,0.00000000,0.00000000,309.90051270); //object(cxrf_floodlite_)(21)
	CreateDynamicObject(3398,-1518.90002441,1403.50000000,16.89999962,0.00000000,0.00000000,229.89135742); //object(cxrf_floodlite_)(22)
	CreateDynamicObject(3398,-1504.19995117,1409.09997559,16.89999962,0.00000000,0.00000000,169.88342285); //object(cxrf_floodlite_)(23)
	CreateDynamicObject(3398,-1492.69995117,1395.09997559,16.89999962,0.00000000,0.00000000,89.88159180); //object(cxrf_floodlite_)(24)
	CreateDynamicObject(3398,-1465.40002441,1383.19995117,16.89999962,0.00000000,0.00000000,299.87915039); //object(cxrf_floodlite_)(26)
	CreateDynamicObject(3398,-1453.30004883,1374.59997559,16.89999962,0.00000000,0.00000000,359.87182617); //object(cxrf_floodlite_)(27)
	CreateDynamicObject(3398,-1438.59997559,1378.30004883,16.89999962,0.00000000,0.00000000,39.86816406); //object(cxrf_floodlite_)(28)
	CreateDynamicObject(3398,-1413.50000000,1380.59997559,16.89999962,0.00000000,0.00000000,229.86389160); //object(cxrf_floodlite_)(29)
	CreateDynamicObject(3398,-1412.50000000,1409.50000000,16.89999962,0.00000000,0.00000000,49.86145020); //object(cxrf_floodlite_)(30)
	CreateDynamicObject(3398,-1387.00000000,1410.19995117,16.89999962,0.00000000,0.00000000,229.86145020); //object(cxrf_floodlite_)(31)
	CreateDynamicObject(3398,-1372.80004883,1419.40002441,16.89999962,0.00000000,0.00000000,199.85595703); //object(cxrf_floodlite_)(32)
	CreateDynamicObject(3398,-1354.80004883,1423.59997559,16.89999962,0.00000000,0.00000000,179.85229492); //object(cxrf_floodlite_)(33)
	CreateDynamicObject(3398,-1327.69995117,1443.40002441,16.89999962,0.00000000,0.00000000,359.85168457); //object(cxrf_floodlite_)(34)
	CreateDynamicObject(3398,-1300.80004883,1423.69995117,16.89999962,0.00000000,0.00000000,179.84069824); //object(cxrf_floodlite_)(35)
	CreateDynamicObject(3398,-1274.09997559,1443.69995117,16.89999962,0.00000000,0.00000000,359.82971191); //object(cxrf_floodlite_)(36)
	CreateDynamicObject(3398,-1249.30004883,1423.80004883,16.89999962,0.00000000,0.00000000,179.81872559); //object(cxrf_floodlite_)(37)
	CreateDynamicObject(3398,-1228.30004883,1422.59997559,16.89999962,0.00000000,0.00000000,149.81872559); //object(cxrf_floodlite_)(38)
	CreateDynamicObject(3398,-1220.09997559,1410.59997559,16.89999962,0.00000000,0.00000000,89.80957031); //object(cxrf_floodlite_)(39)
	CreateDynamicObject(3398,-1224.09997559,1394.69995117,16.89999962,0.00000000,0.00000000,39.80224609); //object(cxrf_floodlite_)(40)
	CreateDynamicObject(3398,-1239.59997559,1389.90002441,16.89999962,0.00000000,0.00000000,349.79797363); //object(cxrf_floodlite_)(41)
	CreateDynamicObject(3398,-1260.00000000,1373.80004883,16.89999962,0.00000000,0.00000000,159.78820801); //object(cxrf_floodlite_)(42)
	CreateDynamicObject(3398,-1271.90002441,1373.69995117,16.89999962,0.00000000,0.00000000,199.77966309); //object(cxrf_floodlite_)(43)
	CreateDynamicObject(3398,-1278.90002441,1364.19995117,16.89999962,0.00000000,0.00000000,279.76989746); //object(cxrf_floodlite_)(44)
	CreateDynamicObject(3398,-1272.00000000,1351.30004883,16.89999962,0.00000000,0.00000000,309.76135254); //object(cxrf_floodlite_)(45)
	CreateDynamicObject(3398,-1269.30004883,1327.00000000,16.89999962,0.00000000,0.00000000,129.75952148); //object(cxrf_floodlite_)(46)
	CreateDynamicObject(3398,-1240.69995117,1321.80004883,16.89999962,0.00000000,0.00000000,299.75402832); //object(cxrf_floodlite_)(47)
	CreateDynamicObject(3398,-1257.19995117,1294.80004883,16.89999962,0.00000000,0.00000000,99.75097656); //object(cxrf_floodlite_)(48)
	CreateDynamicObject(3398,-1229.30004883,1277.30004883,16.89999962,0.00000000,0.00000000,269.75036621); //object(cxrf_floodlite_)(49)
	CreateDynamicObject(3398,-1261.30004883,1254.59997559,16.89999962,0.00000000,0.00000000,69.74731445); //object(cxrf_floodlite_)(50)
	CreateDynamicObject(3398,-1248.69995117,1218.50000000,16.89999962,0.00000000,0.00000000,229.74670410); //object(cxrf_floodlite_)(51)
	CreateDynamicObject(3398,-1279.30004883,1235.30004883,16.89999962,0.00000000,0.00000000,19.74609375); //object(cxrf_floodlite_)(52)
	CreateDynamicObject(3398,-1310.09997559,1153.80004883,16.89999962,0.00000000,0.00000000,269.74243164); //object(cxrf_floodlite_)(53)
	CreateDynamicObject(3398,-1294.90002441,1154.00000000,16.89999962,0.00000000,0.00000000,49.73632812); //object(cxrf_floodlite_)(54)
	CreateDynamicObject(3398,-1370.00000000,1154.50000000,16.89999962,0.00000000,0.00000000,129.72961426); //object(cxrf_floodlite_)(55)
	CreateDynamicObject(3398,-1370.30004883,1208.69995117,16.89999962,0.00000000,0.00000000,29.72106934); //object(cxrf_floodlite_)(56)
	CreateDynamicObject(3398,-1311.50000000,1210.40002441,16.89999962,0.00000000,0.00000000,319.71801758); //object(cxrf_floodlite_)(57)
	CreateDynamicObject(1676,-1252.19995117,1182.59997559,16.20000076,0.00000000,0.00000000,270.00000000); //object(washgaspump)(1)
	CreateDynamicObject(1262,-1310.09997559,1221.00000000,21.00000000,0.00000000,0.00000000,270.00000000); //object(mtraffic4)(1)
	CreateDynamicObject(1262,-1310.09997559,1221.50000000,21.00000000,0.00000000,0.00000000,269.99450684); //object(mtraffic4)(2)
	CreateDynamicObject(1262,-1310.09997559,1220.50000000,21.00000000,0.00000000,0.00000000,269.99450684); //object(mtraffic4)(3)
	CreateDynamicObject(1262,-1310.00000000,1211.40002441,21.00000000,0.00000000,0.00000000,269.99450684); //object(mtraffic4)(4)
	CreateDynamicObject(1262,-1310.00000000,1231.19995117,21.00000000,0.00000000,0.00000000,269.99450684); //object(mtraffic4)(6)
	CreateDynamicObject(8331,-1310.80004883,1214.59997559,7.59999990,0.00000000,0.00000000,20.00000000); //object(vgsbboardsigns18)(1)
	CreateDynamicObject(2728,-1390.90002441,1136.59997559,16.79999924,90.00000000,180.59375000,359.40612793); //object(ds_backlight)(1)
	CreateDynamicObject(2728,-1390.69995117,1154.50000000,16.79999924,90.00000000,180.59326172,179.40124512); //object(ds_backlight)(2)
	CreateDynamicObject(1676,-1241.19995117,1182.59997559,16.20000076,0.00000000,0.00000000,269.99450684); //object(washgaspump)(1)
	CreateDynamicObject(713,-1260.69995117,1186.90002441,15.10000038,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1)(2)
	CreateDynamicObject(713,-1260.30004883,1169.40002441,15.10000038,0.00000000,0.00000000,100.00000000); //object(veg_bevtree1)(3)
//drift11
	CreateVehicle(562,-2980.69995117,2578.30004883,5.00000000,62.00000000,-1,-1,15); //Elegy
	CreateVehicle(562,-2981.89990234,2581.80004883,5.00000000,61.99584961,-1,-1,15); //Elegy
	CreateVehicle(562,-2983.50000000,2586.10009766,5.00000000,61.99584961,-1,-1,15); //Elegy
	CreateVehicle(562,-2985.60009766,2589.80004883,5.00000000,61.99584961,-1,-1,15); //Elegy
	CreateVehicle(562,-3011.89990234,2581.00000000,5.00000000,279.99584961,-1,-1,15); //Elegy
	CreateVehicle(562,-3008.19995117,2586.80004883,5.00000000,279.99206543,-1,-1,15); //Elegy
	CreateVehicle(562,-3010.50000000,2584.00000000,5.00000000,279.99206543,-1,-1,15); //Elegy
	CreateVehicle(562,-3006.19995117,2589.69995117,5.00000000,279.99206543,-1,-1,15); //Elegy
	CreateDynamicObject(13607,-2995.39990234,2586.69995117,6.69999981,0.00000000,0.00000000,0.00000000); //object(ringwalls) (1)
	CreateDynamicObject(978,-3004.69995117,2605.50000000,4.00000000,0.00000000,0.00000000,26.00000000); //object(sub_roadright) (2)
	CreateDynamicObject(978,-3011.80004883,2599.89990234,4.00000000,0.00000000,0.00000000,49.99914551); //object(sub_roadright) (7)
	CreateDynamicObject(978,-3015.69995117,2591.89990234,4.00000000,0.00000000,0.00000000,77.99877930); //object(sub_roadright) (8)
	CreateDynamicObject(978,-3015.89990234,2582.80004883,4.00000000,0.00000000,0.00000000,99.99743652); //object(sub_roadright) (9)
	CreateDynamicObject(978,-3012.39990234,2574.50000000,4.00000000,0.00000000,0.00000000,125.99206543); //object(sub_roadright) (10)
	CreateDynamicObject(978,-3005.60009766,2568.39990234,4.00000000,0.00000000,0.00000000,149.99121094); //object(sub_roadright) (11)
	CreateDynamicObject(978,-2997.00000000,2565.80004883,4.00000000,0.00000000,0.00000000,175.99090576); //object(sub_roadright) (13)
	CreateDynamicObject(978,-2988.19995117,2567.00000000,4.00000000,0.00000000,0.00000000,199.98999023); //object(sub_roadright) (14)
	CreateDynamicObject(978,-2980.60009766,2571.89990234,4.00000000,0.00000000,0.00000000,225.98962402); //object(sub_roadright) (15)
	CreateDynamicObject(978,-2975.80004883,2579.60009766,4.00000000,0.00000000,0.00000000,249.98876953); //object(sub_roadright) (16)
	CreateDynamicObject(978,-2974.60009766,2588.50000000,4.00000000,0.00000000,0.00000000,273.98840332); //object(sub_roadright) (17)
	CreateDynamicObject(978,-2977.19995117,2597.10009766,4.00000000,0.00000000,0.00000000,299.98803711); //object(sub_roadright) (18)
	CreateDynamicObject(978,-2983.30004883,2603.80004883,4.00000000,0.00000000,0.00000000,323.98718262); //object(sub_roadright) (19)
	CreateDynamicObject(1237,-2986.89990234,2606.30004883,3.00000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (1)
	CreateDynamicObject(1237,-3000.60009766,2607.69995117,3.00000000,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (2)
	CreateDynamicObject(983,-3000.60009766,2604.30004883,3.90000010,0.00000000,0.00000000,0.00000000); //object(fenceshit3) (1)
	CreateDynamicObject(983,-2987.50000000,2602.80004883,3.90000010,0.00000000,0.00000000,352.00000000); //object(fenceshit3) (2)
	CreateDynamicObject(983,-3002.60009766,2598.60009766,3.79999995,0.00000000,0.00000000,322.00000000); //object(fenceshit3) (4)
	CreateDynamicObject(983,-3006.50000000,2593.60009766,3.79999995,0.00000000,0.00000000,321.99829102); //object(fenceshit3) (5)
	CreateDynamicObject(983,-3010.39990234,2588.60009766,3.79999995,0.00000000,0.00000000,321.99829102); //object(fenceshit3) (6)
	CreateDynamicObject(983,-3013.39990234,2584.80004883,3.79999995,0.00000000,0.00000000,321.99829102); //object(fenceshit3) (7)
	CreateDynamicObject(983,-2986.39990234,2596.80004883,3.90000010,0.00000000,0.00000000,27.99829102); //object(fenceshit3) (9)
	CreateDynamicObject(983,-2983.30004883,2591.19995117,3.79999995,0.00000000,0.00000000,27.99316406); //object(fenceshit3) (18)
	CreateDynamicObject(983,-2980.39990234,2585.60009766,3.79999995,0.00000000,0.00000000,27.99316406); //object(fenceshit3) (19)
	CreateDynamicObject(983,-2978.19995117,2581.30004883,3.90000010,0.00000000,0.00000000,27.99316406); //object(fenceshit3) (20)
	CreateDynamicObject(983,-3023.89990234,2611.89990234,3.79999995,0.00000000,0.00000000,320.00000000); //object(fenceshit3) (23)
	CreateDynamicObject(983,-3027.60009766,2606.80004883,3.79999995,0.00000000,0.00000000,327.99877930); //object(fenceshit3) (24)
	CreateDynamicObject(983,-3030.50000000,2601.10009766,3.79999995,0.00000000,0.00000000,337.99682617); //object(fenceshit3) (25)
	CreateDynamicObject(983,-3032.39990234,2595.00000000,3.79999995,0.00000000,0.00000000,347.99438477); //object(fenceshit3) (26)
	CreateDynamicObject(983,-3033.19995117,2588.69995117,3.79999995,0.00000000,0.00000000,357.99194336); //object(fenceshit3) (27)
	CreateDynamicObject(983,-3033.00000000,2582.30004883,3.79999995,0.00000000,0.00000000,5.98950195); //object(fenceshit3) (28)
	CreateDynamicObject(983,-3031.80004883,2576.10009766,3.79999995,0.00000000,0.00000000,15.98754883); //object(fenceshit3) (29)
	CreateDynamicObject(983,-3029.60009766,2570.19995117,3.79999995,0.00000000,0.00000000,25.98510742); //object(fenceshit3) (30)
	CreateDynamicObject(983,-3026.30004883,2564.69995117,3.79999995,0.00000000,0.00000000,35.98266602); //object(fenceshit3) (32)
	CreateDynamicObject(983,-3022.10009766,2559.89990234,3.79999995,0.00000000,0.00000000,45.98022461); //object(fenceshit3) (33)
	CreateDynamicObject(983,-3017.19995117,2555.80004883,3.79999995,0.00000000,0.00000000,53.97778320); //object(fenceshit3) (35)
	CreateDynamicObject(983,-3011.80004883,2552.50000000,3.79999995,0.00000000,0.00000000,63.97583008); //object(fenceshit3) (36)
	CreateDynamicObject(983,-3005.89990234,2550.19995117,3.79999995,0.00000000,0.00000000,73.97338867); //object(fenceshit3) (37)
	CreateDynamicObject(983,-2999.60009766,2549.00000000,3.79999995,0.00000000,0.00000000,83.97094727); //object(fenceshit3) (38)
	CreateDynamicObject(983,-2993.30004883,2548.80004883,3.79999995,0.00000000,0.00000000,91.96850586); //object(fenceshit3) (39)
	CreateDynamicObject(983,-2987.10009766,2549.60009766,3.79999995,0.00000000,0.00000000,103.96655273); //object(fenceshit3) (40)
	CreateDynamicObject(983,-2981.10009766,2551.50000000,3.79999995,0.00000000,0.00000000,111.96362305); //object(fenceshit3) (41)
	CreateDynamicObject(983,-2975.39990234,2554.39990234,3.79999995,0.00000000,0.00000000,121.96173096); //object(fenceshit3) (42)
	CreateDynamicObject(983,-2970.30004883,2558.10009766,3.79999995,0.00000000,0.00000000,131.95922852); //object(fenceshit3) (43)
	CreateDynamicObject(983,-2965.89990234,2562.69995117,3.79999995,0.00000000,0.00000000,141.95678711); //object(fenceshit3) (44)
	CreateDynamicObject(983,-2962.30004883,2568.00000000,3.79999995,0.00000000,0.00000000,149.95434570); //object(fenceshit3) (45)
	CreateDynamicObject(983,-2959.60009766,2573.80004883,3.79999995,0.00000000,0.00000000,159.95239258); //object(fenceshit3) (46)
	CreateDynamicObject(983,-2958.00000000,2580.00000000,3.90000010,0.00000000,0.00000000,169.94995117); //object(fenceshit3) (47)
	CreateDynamicObject(983,-2957.39990234,2586.30004883,3.90000010,0.00000000,0.00000000,179.94750977); //object(fenceshit3) (48)
	CreateDynamicObject(983,-2957.89990234,2592.60009766,3.90000010,0.00000000,0.00000000,189.94506836); //object(fenceshit3) (49)
	CreateDynamicObject(983,-2959.39990234,2598.80004883,3.79999995,0.00000000,0.00000000,197.94262695); //object(fenceshit3) (50)
	CreateDynamicObject(983,-2961.89990234,2604.60009766,3.79999995,0.00000000,0.00000000,207.94067383); //object(fenceshit3) (52)
	CreateDynamicObject(983,-2965.30004883,2609.89990234,3.79999995,0.00000000,0.00000000,217.93823242); //object(fenceshit3) (53)
	CreateDynamicObject(983,-2969.60009766,2614.60009766,3.79999995,0.00000000,0.00000000,225.93579102); //object(fenceshit3) (54)
	CreateDynamicObject(983,-2974.60009766,2618.60009766,3.79999995,0.00000000,0.00000000,235.93383789); //object(fenceshit3) (55)
	CreateDynamicObject(983,-2980.19995117,2621.60009766,3.79999995,0.00000000,0.00000000,247.93139648); //object(fenceshit3) (56)
	CreateDynamicObject(983,-2986.30004883,2623.60009766,3.79999995,0.00000000,0.00000000,255.92846680); //object(fenceshit3) (57)
	CreateDynamicObject(983,-2992.60009766,2624.60009766,3.79999995,0.00000000,0.00000000,265.92651367); //object(fenceshit3) (58)
	CreateDynamicObject(983,-2998.89990234,2624.60009766,3.79999995,0.00000000,0.00000000,275.92407227); //object(fenceshit3) (59)
	CreateDynamicObject(983,-3005.19995117,2623.50000000,3.79999995,0.00000000,0.00000000,283.92163086); //object(fenceshit3) (60)
	CreateDynamicObject(983,-3011.19995117,2621.50000000,3.79999995,0.00000000,0.00000000,293.91967773); //object(fenceshit3) (63)
	CreateDynamicObject(983,-3016.80004883,2618.39990234,3.79999995,0.00000000,0.00000000,303.91723633); //object(fenceshit3) (64)
	CreateDynamicObject(983,-3020.50000000,2615.30004883,3.79999995,0.00000000,0.00000000,311.91479492); //object(fenceshit3) (65)
///==========================================[Дрифт зона ОСТРОВ в /drift вроде 4 зона]=================================
	CreateDynamicObject(16109,3293.72753906,-3169.38964844,21.25000000,0.00000000,0.00000000,0.00000000); //object(radar_bit_03) (1)
	CreateDynamicObject(16109,3418.80566406,-3008.86816406,62.30300140,0.00000000,0.20001221,59.54589844); //object(radar_bit_03) (2)
	CreateDynamicObject(16109,3130.50561523,-3071.67138672,21.24720001,0.00000000,0.00000000,178.65002441); //object(radar_bit_03) (3)
	CreateDynamicObject(16147,3169.63061523,-3048.02563477,18.04222870,354.04504395,0.00000000,180.00000000); //object(radar_bit_02) (2)
	CreateDynamicObject(16147,3155.78295898,-2989.48852539,30.49109650,354.04504395,0.00000000,225.65502930); //object(radar_bit_02) (3)
	CreateDynamicObject(16169,3378.55151367,-3130.33178711,-0.98841667,0.00000000,5.74987793,99.25006104); //object(n_bit_14) (1)
	CreateDynamicObject(16192,3421.59350586,-3090.57495117,31.72991562,0.00000000,0.00000000,324.26995850); //object(cen_bit_01) (2)
	CreateDynamicObject(16192,3430.08520508,-3266.16650391,37.87557983,0.00000000,0.00000000,186.59002686); //object(cen_bit_01) (3)
	CreateDynamicObject(16192,3199.90869141,-3244.34765625,-17.62492561,0.00000000,358.01501465,190.55926514); //object(cen_bit_01) (4)
	CreateDynamicObject(16192,3259.86596680,-3254.08935547,-25.27211380,0.00000000,350.07507324,260.03430176); //object(cen_bit_01) (5)
	CreateDynamicObject(16192,3346.28686523,-3277.55395508,-20.52541351,0.00000000,350.07507324,256.06433105); //object(cen_bit_01) (6)
	CreateDynamicObject(16192,3145.56518555,-3182.53271484,6.31226158,0.00000000,352.06005859,13.17846680); //object(cen_bit_01) (7)
	CreateDynamicObject(16133,3193.57031250,-3139.28930664,2.46150875,0.00000000,354.04504395,244.15246582); //object(des_rockgp2_18) (1)
	CreateDynamicObject(16133,3214.08642578,-3154.11694336,7.51510429,0.00000000,352.06005859,210.40747070); //object(des_rockgp2_18) (2)
	CreateDynamicObject(16133,3205.68823242,-3092.13500977,4.79844284,0.00000000,7.93994141,11.19165039); //object(des_rockgp2_18) (3)
	CreateDynamicObject(16133,3230.64184570,-3099.53320312,2.52258492,0.00000000,7.93994141,295.76165771); //object(des_rockgp2_18) (4)
	CreateDynamicObject(16133,3318.99707031,-3057.94042969,37.95656204,1.98303223,13.89221191,166.01989746); //object(des_rockgp2_18) (6)
	CreateDynamicObject(16133,3295.60302734,-3266.21508789,13.59748077,1.98498535,352.06005859,257.33111572); //object(des_rockgp2_18) (7)
	CreateDynamicObject(16097,3384.19165039,-3100.31079102,-5.65186310,3.97000122,1.98498535,1.26928711); //object(n_bit_16) (2)
	CreateDynamicObject(16097,3182.49511719,-3327.07495117,16.89935493,0.00000000,1.98498535,315.61425781); //object(n_bit_16) (3)
	CreateDynamicObject(16192,3160.74609375,-3305.59350586,-17.18136978,0.00000000,354.04504395,76.69848633); //object(cen_bit_01) (9)
	CreateDynamicObject(16192,3400.16088867,-3352.41210938,-27.34200287,0.00000000,354.04504395,100.51849365); //object(cen_bit_01) (10)
	CreateDynamicObject(16192,3431.75854492,-3339.89599609,-28.11530685,0.00000000,354.04504395,84.63848877); //object(cen_bit_01) (11)
	CreateDynamicObject(16192,3492.65405273,-3320.65234375,-20.04432678,0.00000000,354.04504395,134.26351929); //object(cen_bit_01) (12)
	CreateDynamicObject(16192,3514.64355469,-3241.60229492,-16.08846474,0.00000000,354.04504395,168.00848389); //object(cen_bit_01) (14)
	CreateDynamicObject(16192,3528.14965820,-3122.39282227,30.61719513,0.00000000,356.03002930,238.75097656); //object(cen_bit_01) (15)
	CreateDynamicObject(16192,3553.82080078,-3104.39477539,22.30434036,354.04504395,356.03002930,138.06649780); //object(cen_bit_01) (16)
	CreateDynamicObject(16192,3616.69238281,-2987.59130859,26.73355865,0.00000000,356.03002930,231.36151123); //object(cen_bit_01) (17)
	CreateDynamicObject(16192,3513.43041992,-2907.39208984,52.00254059,0.00000000,356.03002930,238.58398438); //object(cen_bit_01) (18)
	CreateDynamicObject(16192,3446.62060547,-2870.46362305,51.43860626,0.00000000,356.03002930,250.49401855); //object(cen_bit_01) (19)
	CreateDynamicObject(16192,3328.97753906,-2950.98095703,47.76010132,0.00000000,354.04504395,268.35888672); //object(cen_bit_01) (20)
	CreateDynamicObject(16192,3299.39282227,-3012.00537109,24.26906204,0.00000000,354.04504395,282.25378418); //object(cen_bit_01) (21)
	CreateDynamicObject(16133,3236.81738281,-3085.41992188,24.90491486,1.98498535,13.89489746,193.81115723); //object(des_rockgp2_18) (8)
	CreateDynamicObject(16097,3259.48632812,-3058.86132812,50.58118439,0.00000000,0.00000000,260.03442383); //object(n_bit_16) (4)
	CreateDynamicObject(16097,3256.91796875,-3273.46093750,17.27640533,0.00000000,0.00000000,343.40380859); //object(n_bit_16) (5)
	CreateDynamicObject(16097,3156.37060547,-3063.18017578,4.97239304,0.00000000,0.00000000,244.15441895); //object(n_bit_16) (6)
	CreateDynamicObject(16097,3185.33764648,-2943.00024414,28.27877808,0.00000000,0.00000000,198.49938965); //object(n_bit_16) (7)
	CreateDynamicObject(16192,3636.28442383,-2875.46948242,-3.45599556,0.00000000,356.03002930,231.36151123); //object(cen_bit_01) (22)
	CreateDynamicObject(16192,3548.95336914,-2828.78588867,-15.45046425,0.00000000,356.03002930,219.45153809); //object(cen_bit_01) (23)
	CreateDynamicObject(16192,3446.62377930,-2760.26586914,-4.13566780,0.00000000,356.03002930,255.18151855); //object(cen_bit_01) (24)
	CreateDynamicObject(16192,3320.89282227,-2884.15795898,66.18688965,0.00000000,356.03002930,282.97131348); //object(cen_bit_01) (25)
	CreateDynamicObject(16192,3332.74194336,-2765.81030273,-1.90367222,0.00000000,354.04504395,282.97131348); //object(cen_bit_01) (26)
	CreateDynamicObject(16192,3238.82763672,-2814.40234375,0.86692715,0.00000000,354.04504395,318.70104980); //object(cen_bit_01) (27)
	CreateDynamicObject(16192,3227.22900391,-2848.19531250,45.91938782,0.00000000,354.04504395,350.46081543); //object(cen_bit_01) (28)
	CreateDynamicObject(16097,3254.63012695,-2919.09545898,68.70491791,0.00000000,356.03002930,73.44433594); //object(n_bit_16) (8)
	CreateDynamicObject(16192,3067.17309570,-2882.31933594,38.99808884,0.00000000,348.09008789,79.78515625); //object(cen_bit_01) (29)
	CreateDynamicObject(16192,2994.80371094,-3027.93823242,17.58457184,0.00000000,348.09008789,358.40014648); //object(cen_bit_01) (30)
	CreateDynamicObject(16192,2996.31494141,-3093.36425781,18.03097916,0.00000000,350.07507324,354.43017578); //object(cen_bit_01) (31)
	CreateDynamicObject(16192,3008.74609375,-2902.95947266,14.45249748,0.00000000,348.09008789,352.44519043); //object(cen_bit_01) (32)
	CreateDynamicObject(16192,3194.90673828,-2731.33911133,16.78513336,0.00000000,354.04504395,10.31015015); //object(cen_bit_01) (33)
	CreateDynamicObject(16192,3040.35131836,-2768.82275391,12.58029175,0.00000000,354.04504395,67.87515259); //object(cen_bit_01) (34)
	CreateDynamicObject(16192,2935.19165039,-2841.44042969,-17.71456528,0.00000000,354.04504395,93.68017578); //object(cen_bit_01) (35)
	CreateDynamicObject(16097,3036.77734375,-3168.94213867,46.21961975,0.00000000,0.00000000,1.98431396); //object(n_bit_16) (9)
	CreateDynamicObject(16192,2989.79882812,-3263.80615234,30.62277222,0.00000000,348.09008789,81.77008057); //object(cen_bit_01) (36)
	CreateDynamicObject(16097,3351.19970703,-3152.77416992,43.66624451,0.00000000,0.00000000,236.21441650); //object(n_bit_16) (10)
	CreateDynamicObject(16097,3061.76660156,-2968.45166016,35.60267639,0.00000000,0.00000000,297.74914551); //object(n_bit_16) (11)
	CreateObject(16771,3086.35229492,-3178.98095703,53.20843506,0.00000000,0.00000000,0.00000000); //object(des_savhangr) (1)
	CreateDynamicObject(16192,3065.23364258,-3275.68457031,37.27136230,0.00000000,348.09008789,71.84509277); //object(cen_bit_01) (37)
	CreateDynamicObject(16133,3119.56933594,-3173.56176758,34.75222015,0.00000000,3.96997070,174.67749023); //object(des_rockgp2_18) (9)
	CreateDynamicObject(16133,3097.27636719,-3210.57128906,36.37182617,0.00000000,3.96606445,83.36425781); //object(des_rockgp2_18) (10)
	CreateDynamicObject(16133,3055.35351562,-3177.54882812,34.41638947,0.00000000,3.96606445,174.67712402); //object(des_rockgp2_18) (11)
	CreateDynamicObject(16097,3091.10742188,-2706.37182617,-14.64836884,0.00000000,0.00000000,297.74914551); //object(n_bit_16) (1)
	CreateDynamicObject(16097,3155.36230469,-2847.86303711,56.39349747,0.00000000,0.00000000,325.53894043); //object(n_bit_16) (12)
	CreateDynamicObject(16097,3561.30664062,-3012.59155273,49.25526428,0.00000000,0.00000000,236.21441650); //object(n_bit_16) (13)
	CreateDynamicObject(16192,3712.32348633,-3064.62866211,-5.94915962,0.00000000,356.03002930,231.36151123); //object(cen_bit_01) (1)
	CreateDynamicObject(16192,2875.02050781,-3185.36181641,-27.84468651,0.00000000,0.00000000,81.77008057); //object(cen_bit_01) (8)
	CreateDynamicObject(16192,3113.37304688,-3346.97558594,-0.64605331,0.00000000,346.10510254,125.44009399); //object(cen_bit_01) (13)
	CreateDynamicObject(16097,3169.04296875,-3341.40576172,17.52517700,0.00000000,1.98498535,315.61425781); //object(n_bit_16) (15)
	CreateDynamicObject(16097,3110.42822266,-3345.72363281,-48.50517654,0.00000000,3.96997070,88.60827637); //object(n_bit_16) (16)
	CreateDynamicObject(5005,3035.98608398,-3154.62158203,44.61174774,245.00000000,0.00000000,0.00000000); //object(lasrunwall1_las) (3)
	CreateDynamicObject(713,3121.73315430,-2976.10449219,23.05955315,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (1)
	CreateDynamicObject(713,3195.07666016,-3128.91821289,6.14409542,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (3)
	CreateDynamicObject(713,3323.04199219,-3258.28466797,24.49352646,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (4)
	CreateDynamicObject(713,3250.57983398,-3119.58496094,31.83481598,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (5)
	CreateDynamicObject(713,3329.60766602,-3152.41259766,42.54951477,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (7)
	CreateDynamicObject(713,3502.85400391,-3050.09057617,63.91354370,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (8)
	CreateDynamicObject(713,3350.33593750,-3020.76562500,73.06049347,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (9)
	CreateDynamicObject(713,3458.55444336,-2968.33227539,83.54203796,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (10)
	CreateDynamicObject(652,3362.65332031,-2937.66577148,87.35626221,0.00000000,0.00000000,59.54998779); //object(sjmpalmbig) (1)
	CreateDynamicObject(652,3358.80444336,-2975.98413086,76.03807831,0.00000000,0.00000000,0.00000000); //object(sjmpalmbig) (2)
	CreateDynamicObject(652,3376.47900391,-3058.63256836,50.48693848,0.00000000,0.00000000,0.00000000); //object(sjmpalmbig) (3)
	CreateDynamicObject(652,3329.61523438,-3042.76513672,46.83695602,0.00000000,0.00000000,0.00000000); //object(sjmpalmbig) (4)
	CreateDynamicObject(652,3251.35742188,-3200.14721680,15.68209457,0.00000000,0.00000000,0.00000000); //object(sjmpalmbig) (5)
	CreateDynamicObject(652,3230.14965820,-3114.70043945,7.21575928,0.00000000,0.00000000,232.96002197); //object(sjmpalmbig) (6)
	CreateDynamicObject(652,3167.42651367,-3145.49072266,33.22251129,0.00000000,0.00000000,146.89001465); //object(sjmpalmbig) (8)
	CreateDynamicObject(652,3073.91967773,-3055.75048828,42.25520325,0.00000000,0.00000000,276.62994385); //object(sjmpalmbig) (9)
	CreateDynamicObject(774,3072.31372070,-3003.63623047,26.13934517,0.00000000,0.00000000,0.00000000); //object(elmsparse_hi) (1)
	CreateDynamicObject(774,3131.04858398,-3025.17602539,23.82796288,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (2)
	CreateDynamicObject(774,3273.15942383,-3239.93652344,20.68541718,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (3)
	CreateDynamicObject(774,3293.71557617,-3216.75854492,22.14736176,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (4)
	CreateDynamicObject(774,3300.15429688,-3094.35498047,41.02587509,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (5)
	CreateDynamicObject(774,3510.26464844,-2987.95922852,65.94020081,0.00000000,0.00000000,103.22003174); //object(elmsparse_hi) (6)
	CreateDynamicObject(774,3378.88061523,-2960.81738281,81.55638885,0.00000000,0.00000000,85.35504150); //object(elmsparse_hi) (7)
	CreateDynamicObject(774,3416.21582031,-2969.20849609,82.93252563,0.00000000,0.00000000,129.02502441); //object(elmsparse_hi) (8)
	CreateDynamicObject(750,3094.59716797,-3079.77148438,42.61096191,0.00000000,0.00000000,0.00000000); //object(sm_scrb_column2) (1)
	CreateDynamicObject(750,3122.61743164,-3004.35595703,23.33788490,0.00000000,0.00000000,0.00000000); //object(sm_scrb_column2) (2)
	CreateDynamicObject(750,3304.64941406,-3238.89208984,23.94256973,0.00000000,0.00000000,0.00000000); //object(sm_scrb_column2) (3)
	CreateDynamicObject(774,3094.41650391,-3086.68603516,42.48906326,0.00000000,0.00000000,71.46002197); //object(elmsparse_hi) (9)
	CreateDynamicObject(774,3097.70581055,-3130.49584961,43.68058395,0.00000000,0.00000000,71.46002197); //object(elmsparse_hi) (10)
	CreateDynamicObject(713,3120.56298828,-3147.60449219,42.42094803,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (11)
	CreateDynamicObject(5409,3088.12060547,-2974.31347656,28.44096947,359.00000000,1.00000000,354.24505615); //object(laepetrol1a) (1)
	CreateDynamicObject(1686,3110.62963867,-2976.84008789,23.71279335,0.00000000,0.00000000,354.04498291); //object(petrolpumpnew) (1)
	CreateDynamicObject(1686,3111.35815430,-2969.45703125,23.58357430,0.00000000,0.00000000,356.03002930); //object(petrolpumpnew) (2)
	CreateDynamicObject(1225,3119.94799805,-2976.60546875,23.55832672,0.00000000,0.00000000,0.00000000); //object(barrel4) (1)
	CreateDynamicObject(1225,3118.64868164,-2976.85302734,23.62574387,0.00000000,0.00000000,0.00000000); //object(barrel4) (2)
	CreateDynamicObject(1225,3117.25683594,-2976.91284180,23.69744682,0.00000000,0.00000000,0.00000000); //object(barrel4) (4)
	CreateDynamicObject(1225,3115.42626953,-2976.73339844,23.79113960,0.00000000,0.00000000,0.00000000); //object(barrel4) (5)
	CreateDynamicObject(3286,3326.81127930,-3240.99707031,29.39734077,0.00000000,0.00000000,181.34996033); //object(cxrf_watertwr) (1)
	CreateDynamicObject(3927,3386.87622070,-2946.61157227,87.84114838,0.00000000,0.00000000,65.50500488); //object(d_sign01) (1)
	CreateDynamicObject(3337,3474.52246094,-3012.29931641,66.91246033,0.00000000,358.01498413,355.31433105); //object(cxrf_desertsig) (1)
	CreateDynamicObject(2960,3099.04443359,-3157.23974609,56.94538498,0.00000000,298.46496582,0.00000000); //object(kmb_beam) (2)
	CreateDynamicObject(2960,3097.02124023,-3157.24731445,57.19212341,0.00000000,248.84027100,0.00000000); //object(kmb_beam) (3)
	CreateDynamicObject(2960,3095.29248047,-3157.29003906,56.99952316,0.00000000,91.31002808,0.00000000); //object(kmb_beam) (4)
	CreateDynamicObject(2960,3092.80468750,-3157.23876953,58.85164261,0.00000000,178.65002441,0.00000000); //object(kmb_beam) (5)
	CreateDynamicObject(2960,3092.80468750,-3157.27465820,57.25843048,0.00000000,178.65002441,0.00000000); //object(kmb_beam) (6)
	CreateDynamicObject(2960,3092.79125977,-3157.26904297,55.23782349,0.00000000,180.63500977,0.00000000); //object(kmb_beam) (7)
	CreateDynamicObject(2960,3088.70776367,-3157.21875000,57.04912186,0.00000000,269.95996094,0.00000000); //object(kmb_beam) (8)
	CreateDynamicObject(2960,3086.49511719,-3157.23583984,58.62276459,0.00000000,168.72497559,0.00000000); //object(kmb_beam) (9)
	CreateDynamicObject(2960,3086.52124023,-3157.27465820,57.61690903,0.00000000,188.57501221,0.00000000); //object(kmb_beam) (10)
	CreateDynamicObject(2960,3086.82202148,-3157.25585938,56.04747391,0.00000000,148.87500000,0.00000000); //object(kmb_beam) (11)
	CreateDynamicObject(2960,3083.32543945,-3157.29711914,57.09838486,0.00000000,91.30996704,0.00000000); //object(kmb_beam) (12)
	CreateDynamicObject(2960,3081.10791016,-3157.24536133,59.19356537,0.00000000,180.63500977,0.00000000); //object(kmb_beam) (13)
	CreateDynamicObject(2960,3078.75024414,-3157.26391602,57.03874588,0.00000000,269.95996094,0.00000000); //object(kmb_beam) (14)
	CreateDynamicObject(2960,3080.97387695,-3157.27465820,55.44621658,0.00000000,359.28430176,0.00000000); //object(kmb_beam) (15)
	CreateDynamicObject(2960,3077.85986328,-3157.22680664,57.19897842,0.00000000,90.59362793,0.00000000); //object(kmb_beam) (16)
	CreateDynamicObject(2960,3076.10546875,-3157.20922852,57.20688248,0.00000000,132.27871704,0.00000000); //object(kmb_beam) (17)
	CreateDynamicObject(2960,3074.45605469,-3157.25024414,57.20158768,0.00000000,88.60864258,0.00000000); //object(kmb_beam) (18)
	CreateDynamicObject(2960,3072.51367188,-3157.22851562,57.30870819,0.00000000,60.81863403,0.00000000); //object(kmb_beam) (19)
	CreateDynamicObject(2960,3070.12841797,-3157.29516602,57.17990112,0.00000000,122.35363770,0.00000000); //object(kmb_beam) (20)
	CreateDynamicObject(2960,3071.36059570,-3157.20654297,56.54159546,0.00000000,179.91857910,0.00000000); //object(kmb_beam) (21)
	CreateDynamicObject(16097,3327.70410156,-2877.06835938,36.49160004,0.00000000,0.00000000,325.53894043); //object(n_bit_16) (14)
	CreateDynamicObject(16133,3055.74682617,-3184.29248047,32.15997696,0.00000000,3.96606445,174.67712402); //object(des_rockgp2_18) (11)
	CreateDynamicObject(16133,3307.51928711,-3049.72509766,27.08466339,1.98303223,13.89221191,233.50988770); //object(des_rockgp2_18) (6)
	CreateDynamicObject(16133,3106.07153320,-3204.89428711,25.72065735,0.00000000,3.96606445,81.37927246); //object(des_rockgp2_18) (10)
	CreateDynamicObject(16133,3077.81713867,-3208.11889648,65.89302063,0.00000000,3.96606445,81.37573242); //object(des_rockgp2_18) (10)
///=======================================[Drift 5 HARD]================================================================================
	CreateDynamicObject(18800, 964.83, 1459.83, 20.68,   0.00, 0.00, 269.00);
	CreateDynamicObject(18800, 965.50, 1517.51, 44.20,   0.00, 0.00, 89.22);
	CreateDynamicObject(18800, 964.83, 1459.83, 67.72,   0.00, 0.00, 269.00);
	CreateDynamicObject(18800, 965.38, 1514.54, 91.25,   0.00, 0.00, 89.42);
	CreateDynamicObject(18800, 964.83, 1459.83, 114.84,   0.00, 0.00, 269.00);
	CreateDynamicObject(18800, 965.38, 1514.54, 138.40,   0.00, 0.00, 89.42);
	CreateDynamicObject(18800, 964.83, 1459.83, 161.99,   0.00, 0.00, 269.00);
	CreateDynamicObject(19129, 942.11, 1498.92, 174.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 942.10, 1509.11, 184.44,   89.00, 0.00, 0.00);
	CreateDynamicObject(19129, 932.30, 1499.03, 184.44,   91.00, 0.00, 90.00);
	CreateDynamicObject(19129, 951.69, 1499.05, 184.44,   91.00, 0.00, -91.00);
	CreateDynamicObject(19129, 942.07, 1499.17, 194.28,   -180.00, 0.00, 359.00);
	CreateDynamicObject(19123, 934.40, 1470.30, 175.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19123, 949.81, 1469.61, 175.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(19121, 995.55, 1480.66, 105.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19121, 980.07, 1480.97, 104.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 980.16, 1489.31, 57.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(19122, 980.16, 1489.31, 57.85,   0.00, 0.00, 0.00);
//------Парковка........
CreateDynamicObject(4139,998.80000000,-2310.04000000,12.53000000,0.00000000,0.00000000,30.31000000); //
CreateDynamicObject(3749,1041.94000000,-2311.63000000,17.80000000,0.00000000,0.00000000,-60.62000000); //
CreateDynamicObject(5837,1038.04000000,-2296.93000000,13.65000000,0.00000000,0.00000000,117.74000000); //
CreateDynamicObject(8675,1024.67000000,-2290.38000000,21.09000000,0.00000000,0.00000000,-60.62000000); //
CreateDynamicObject(974,1033.64000000,-2302.95000000,12.25000000,0.00000000,0.00000000,-16.41000000); //
CreateDynamicObject(994,1032.78000000,-2302.59000000,15.04000000,0.00000000,0.00000000,-18.20000000); //
CreateDynamicObject(984,1039.48000000,-2324.07000000,12.93000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(984,1028.44000000,-2330.55000000,12.93000000,0.00000000,0.00000000,-59.69000000); //
CreateDynamicObject(984,1017.36000000,-2337.01000000,12.93000000,0.00000000,0.00000000,-60.55000000); //
CreateDynamicObject(984,1006.24000000,-2343.41000000,12.93000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(984,1004.27000000,-2344.59000000,12.93000000,0.00000000,0.00000000,-58.83000000); //
CreateDynamicObject(984,995.58000000,-2342.40000000,12.93000000,0.00000000,0.00000000,30.31000000); //
CreateDynamicObject(984,989.17000000,-2331.30000000,12.93000000,0.00000000,0.86000000,29.45000000); //
CreateDynamicObject(984,984.77000000,-2323.54000000,12.93000000,0.00000000,0.00000000,29.45000000); //
CreateDynamicObject(984,975.93000000,-2320.92000000,12.93000000,0.00000000,0.00000000,118.59000000); //
CreateDynamicObject(984,1007.99000000,-2276.78000000,12.99000000,0.00000000,0.00000000,30.31000000); //
CreateDynamicObject(984,998.24000000,-2272.44000000,12.99000000,0.00000000,0.00000000,-60.55000000); //
CreateDynamicObject(984,987.15000000,-2278.79000000,12.96000000,0.00000000,0.00000000,-59.69000000); //
CreateDynamicObject(984,976.07000000,-2285.15000000,12.93000000,0.00000000,0.00000000,-60.55000000); //
CreateDynamicObject(984,965.08000000,-2291.69000000,12.93000000,0.00000000,0.00000000,-57.97000000); //
CreateDynamicObject(984,954.20000000,-2298.21000000,13.02000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(18450,927.07000000,-2340.56000000,11.73000000,0.00000000,0.00000000,30.31000000); //
CreateDynamicObject(18450,919.23000000,-2327.18000000,11.62000000,0.00000000,0.00000000,30.31000000); //
CreateDynamicObject(3330,954.53000000,-2315.52000000,1.62000000,0.00000000,0.00000000,-59.69000000); //
CreateDynamicObject(3279,1005.15000000,-2316.74000000,13.02000000,0.00000000,0.00000000,31.17000000); //
CreateDynamicObject(800,1040.32000000,-2321.84000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(9339,937.89000000,-2307.50000000,13.31000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,915.68000000,-2320.43000000,13.34000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(18450,858.09000000,-2380.88000000,11.76000000,0.00000000,0.00000000,30.31000000); //
CreateDynamicObject(18450,850.42000000,-2367.42000000,11.64000000,0.00000000,0.00000000,30.31000000); //
CreateDynamicObject(10236,1037.24000000,-2299.68000000,26.52000000,0.00000000,0.00000000,-67.50000000); //
CreateDynamicObject(10281,1045.15000000,-2310.68000000,19.30000000,0.00000000,0.00000000,119.53000000); //
CreateDynamicObject(3330,887.40000000,-2355.05000000,1.52000000,0.00000000,0.00000000,-64.06000000); //
CreateDynamicObject(7419,723.54000000,-2396.31000000,5.27000000,0.00000000,-1.00000000,-240.00000000); //
CreateDynamicObject(8420,790.13000000,-2422.52000000,11.40000000,0.00000000,-1.00000000,29.67000000); //
CreateDynamicObject(4642,954.33000000,-2315.66000000,13.67000000,0.00000000,0.00000000,32.03000000); //
CreateDynamicObject(8040,733.17000000,-2443.27000000,11.76000000,0.00000000,0.00000000,30.00000000); //
CreateDynamicObject(5710,819.15000000,-2447.98000000,16.39000000,-1.00000000,0.00000000,122.00000000); //
CreateDynamicObject(3458,752.59000000,-2471.14000000,12.55000000,0.00000000,0.00000000,30.00000000); //
CreateDynamicObject(3458,755.17000000,-2475.54000000,12.55000000,0.00000000,0.00000000,210.00000000); //
CreateDynamicObject(984,1007.99000000,-2276.78000000,12.99000000,0.00000000,0.00000000,30.31000000); //
CreateDynamicObject(984,969.98000000,-2324.29000000,12.93000000,0.00000000,0.00000000,120.21000000); //
CreateDynamicObject(974,728.93000000,-2508.88000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(3472,770.73000000,-2463.61000000,14.28000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(9339,893.18000000,-2333.52000000,13.34000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,870.68000000,-2346.61000000,13.34000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,848.36000000,-2359.62000000,13.34000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,825.96000000,-2372.65000000,13.34000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,822.08000000,-2374.91000000,13.34000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(800,1033.57000000,-2325.83000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,1027.06000000,-2329.71000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,1019.58000000,-2333.49000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,1011.01000000,-2338.00000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,1001.63000000,-2342.78000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,994.36000000,-2336.77000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,989.89000000,-2329.66000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,985.66000000,-2321.81000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,980.40000000,-2316.45000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,973.76000000,-2320.48000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,965.84000000,-2324.45000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,949.97000000,-2318.79000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,953.73000000,-2301.23000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,961.72000000,-2296.46000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,969.29000000,-2291.96000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,976.08000000,-2287.98000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,982.48000000,-2284.27000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,990.48000000,-2280.32000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,997.61000000,-2276.89000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,1004.96000000,-2277.32000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,1002.11000000,-2272.07000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,1002.11000000,-2272.07000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,1008.51000000,-2283.28000000,14.22000000,0.00000000,0.00000000,-0.36000000); //
CreateDynamicObject(800,1004.96000000,-2277.32000000,14.22000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(800,1012.01000000,-2289.11000000,14.22000000,0.00000000,0.00000000,-0.36000000); //
CreateDynamicObject(800,1014.82000000,-2295.06000000,14.22000000,0.00000000,0.00000000,-0.36000000); //
CreateDynamicObject(800,1017.53000000,-2300.82000000,14.22000000,0.00000000,0.00000000,-0.36000000); //
CreateDynamicObject(800,1020.39000000,-2306.54000000,14.22000000,0.00000000,0.00000000,-0.36000000); //
CreateDynamicObject(800,1024.80000000,-2310.43000000,14.22000000,0.00000000,0.00000000,-0.36000000); //
CreateDynamicObject(800,1029.31000000,-2308.61000000,14.22000000,0.00000000,0.00000000,-0.36000000); //
CreateDynamicObject(800,1033.17000000,-2306.70000000,14.22000000,0.00000000,0.00000000,-0.36000000); //
CreateDynamicObject(974,828.99000000,-2410.42000000,14.43000000,0.00000000,0.00000000,119.00000000); //
CreateDynamicObject(3330,819.73000000,-2392.62000000,1.52000000,0.00000000,0.00000000,-64.06000000); //
CreateDynamicObject(3472,999.70000000,-2308.69000000,12.91000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,995.60000000,-2301.16000000,12.91000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,992.22000000,-2294.55000000,12.91000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(9339,953.98000000,-2333.88000000,13.31000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,931.47000000,-2347.00000000,13.31000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,909.10000000,-2360.03000000,13.31000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,886.55000000,-2373.18000000,13.31000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,864.30000000,-2386.13000000,13.31000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,841.92000000,-2399.19000000,13.31000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(9339,839.27000000,-2400.74000000,13.31000000,0.00000000,0.00000000,-59.77000000); //
CreateDynamicObject(8040,751.40000000,-2474.92000000,11.78000000,0.00000000,0.00000000,30.00000000); //
CreateDynamicObject(974,832.25000000,-2416.24000000,14.43000000,0.00000000,0.00000000,119.00000000); //
CreateDynamicObject(974,835.48000000,-2422.05000000,14.39000000,0.00000000,0.00000000,119.00000000); //
CreateDynamicObject(974,838.72000000,-2427.89000000,14.43000000,0.00000000,0.00000000,119.00000000); //
CreateDynamicObject(974,841.94000000,-2433.68000000,14.43000000,0.00000000,0.00000000,119.00000000); //
CreateDynamicObject(974,842.61000000,-2434.93000000,14.43000000,0.00000000,0.00000000,119.00000000); //
CreateDynamicObject(974,842.94000000,-2438.64000000,14.43000000,0.00000000,0.00000000,24.17000000); //
CreateDynamicObject(974,734.69000000,-2505.53000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,740.50000000,-2502.21000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,746.26000000,-2498.86000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,752.01000000,-2495.53000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,757.81000000,-2492.13000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,763.55000000,-2488.81000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,769.31000000,-2485.48000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,775.05000000,-2482.16000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,780.73000000,-2478.90000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,786.50000000,-2475.56000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,792.20000000,-2472.23000000,15.28000000,0.00000000,0.00000000,210.12000000); //
CreateDynamicObject(974,793.14000000,-2467.93000000,15.28000000,0.00000000,0.00000000,300.05000000); //
CreateDynamicObject(974,813.05000000,-2460.55000000,15.28000000,0.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,810.52000000,-2377.63000000,14.04000000,0.00000000,0.00000000,299.64000000); //
CreateDynamicObject(974,807.22000000,-2371.83000000,14.04000000,0.00000000,0.00000000,299.64000000); //
CreateDynamicObject(974,802.21000000,-2369.66000000,14.05000000,0.00000000,0.00000000,29.70000000); //
CreateDynamicObject(974,806.67000000,-2370.89000000,14.04000000,0.00000000,0.00000000,299.64000000); //
CreateDynamicObject(974,796.45000000,-2372.97000000,14.04000000,0.00000000,0.00000000,30.00000000); //
CreateDynamicObject(974,790.69000000,-2376.30000000,14.04000000,0.00000000,0.00000000,30.00000000); //
CreateDynamicObject(974,784.99000000,-2379.59000000,14.04000000,0.00000000,0.00000000,30.00000000); //
CreateDynamicObject(974,779.21000000,-2382.93000000,14.04000000,0.00000000,0.00000000,30.00000000); //
CreateDynamicObject(974,773.48000000,-2386.26000000,14.04000000,0.00000000,0.00000000,30.00000000); //
CreateDynamicObject(974,768.53000000,-2389.14000000,14.04000000,0.00000000,0.00000000,30.00000000); //
CreateDynamicObject(3524,807.62000000,-2443.16000000,15.59000000,0.00000000,0.00000000,-146.25000000); //
CreateDynamicObject(3524,819.87000000,-2435.24000000,15.84000000,0.00000000,0.00000000,-157.50000000); //
CreateDynamicObject(3528,817.24000000,-2444.19000000,19.31000000,0.00000000,0.86000000,112.50000000); //
CreateDynamicObject(7073,831.74000000,-2415.96000000,30.31000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(7388,820.90000000,-2450.42000000,21.76000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1283,817.59000000,-2389.92000000,15.06000000,0.00000000,0.00000000,-60.62000000); //
CreateDynamicObject(1283,822.31000000,-2398.44000000,15.18000000,0.00000000,0.00000000,118.59000000); //
CreateDynamicObject(14560,792.21000000,-2386.91000000,16.10000000,0.00000000,0.00000000,-56.25000000); //
CreateDynamicObject(967,819.85000000,-2393.12000000,11.78000000,0.00000000,0.00000000,31.17000000); //
CreateDynamicObject(967,820.89000000,-2394.85000000,11.80000000,0.00000000,0.00000000,-149.69000000); //
CreateDynamicObject(5837,834.76000000,-2429.91000000,13.58000000,0.00000000,0.00000000,-118.99000000); //
CreateDynamicObject(1832,810.12000000,-2452.67000000,12.70000000,0.00000000,0.00000000,34.38000000); //
CreateDynamicObject(1836,810.22000000,-2455.87000000,12.46000000,0.00000000,0.00000000,121.17000000); //
CreateDynamicObject(1523,816.87000000,-2446.87000000,12.88000000,0.00000000,0.00000000,33.75000000); //
CreateDynamicObject(1523,819.45000000,-2445.16000000,12.89000000,0.00000000,0.00000000,-146.25000000); //
CreateDynamicObject(643,820.75000000,-2451.67000000,13.28000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1486,820.69000000,-2451.72000000,13.83000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1520,820.50000000,-2451.67000000,13.74000000,-89.38000000,0.00000000,0.00000000); //
CreateDynamicObject(1543,820.44000000,-2451.97000000,13.68000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1546,820.78000000,-2451.94000000,13.77000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(16151,818.91000000,-2459.41000000,13.13000000,0.00000000,0.00000000,-62.11000000); //
CreateDynamicObject(1820,829.02000000,-2453.36000000,12.85000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(1518,829.35000000,-2452.74000000,13.64000000,0.00000000,0.00000000,-101.25000000); //
CreateDynamicObject(974,795.39000000,-2465.31000000,14.15000000,0.00000000,0.00000000,207.38000000); //
CreateDynamicObject(974,798.32000000,-2463.82000000,14.15000000,0.00000000,0.00000000,207.38000000); //
CreateDynamicObject(974,793.14000000,-2467.93000000,15.28000000,0.00000000,0.00000000,300.05000000); //
CreateDynamicObject(974,815.32000000,-2458.58000000,12.41000000,-89.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,812.10000000,-2453.93000000,12.51000000,-89.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,816.77000000,-2451.03000000,12.62000000,-89.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,820.30000000,-2456.65000000,12.62000000,-89.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,821.44000000,-2448.13000000,12.62000000,-89.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,824.93000000,-2453.74000000,12.62000000,-89.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,829.59000000,-2450.83000000,12.82000000,-89.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,826.08000000,-2445.20000000,12.82000000,-89.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,792.11000000,-2466.18000000,15.28000000,0.00000000,0.00000000,300.05000000); //
CreateDynamicObject(974,809.50000000,-2454.87000000,15.28000000,0.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,829.48000000,-2450.78000000,15.28000000,0.00000000,0.00000000,302.00000000); //
CreateDynamicObject(974,825.95000000,-2445.12000000,15.28000000,0.00000000,0.00000000,302.00000000); //
CreateDynamicObject(3472,764.79000000,-2467.05000000,14.28000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,758.02000000,-2470.76000000,14.28000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,750.53000000,-2475.09000000,14.28000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,743.00000000,-2479.54000000,14.28000000,0.00000000,0.00000000,0.00000000); //
CreateDynamicObject(3472,736.64000000,-2483.38000000,14.28000000,0.00000000,0.00000000,0.00000000); //
AddStaticVehicleEx(411,707.72150000,-2369.75170000,26.14650000,210.05260000,-1,-1,15); //Infernus
AddStaticVehicleEx(411,714.60280000,-2365.55880000,26.24750000,210.05260000,-1,-1,15); //Infernus
AddStaticVehicleEx(541,723.42330000,-2402.03520000,28.43550000,29.95190000,-1,-1,15); //Bullet
AddStaticVehicleEx(541,718.82760000,-2404.86330000,28.43550000,29.95190000,-1,-1,15); //Bullet
AddStaticVehicleEx(541,730.32930000,-2398.19190000,28.43550000,29.95190000,-1,-1,15); //Bullet
AddStaticVehicleEx(581,710.48440000,-2403.63230000,29.23510000,298.67320000,-1,-1,15); //BF-400
AddStaticVehicleEx(581,709.37620000,-2401.56670000,29.23510000,298.31320000,-1,-1,15); //BF-400
AddStaticVehicleEx(581,705.58220000,-2396.33810000,28.31680000,298.31320000,-1,-1,15); //BF-400
AddStaticVehicleEx(581,703.41710000,-2392.55130000,27.80670000,298.31320000,-1,-1,15); //BF-400
AddStaticVehicleEx(560,764.80360000,-2462.13090000,12.31180000,30.37070000,-1,-1,15); //Sultan
AddStaticVehicleEx(560,761.87390000,-2463.90190000,12.31180000,30.37070000,-1,-1,15); //Sultan
AddStaticVehicleEx(560,759.20310000,-2465.56760000,12.31180000,30.37070000,-1,-1,15); //Sultan
return 1;
}

public OnGameModeExit()
{
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerInterior(playerid,17);
    SetPlayerPos(playerid,486.5686,-13.7128,1000.6796);
    SetPlayerFacingAngle(playerid, 110.4393);
    SetPlayerCameraPos(playerid,484.5686,-15.7128,1001.6796);
    SetPlayerCameraLookAt(playerid,486.5686,-13.7128,1000.6796);
    ApplyAnimation(playerid,"DANCING","DAN_Loop_A",4.0,1,0,0,0,-1);
    return 1;
}
public OnPlayerConnect(playerid)
{
    UPDTimer[playerid] = SetTimer("OnPlayerUPD",100,1);
    OtherTimerVar[playerid] = SetTimer("OtherTimer", 1000, 1);
    CheckTimer[playerid] = SetTimer("Check",1000,1);//таймер для проверки
	CountownTimer[playerid] = SetTimer("Countdown",1000,1);//таймер отсчёта
	AutoRepairTimer[playerid] = SetTimer("AutoRepair", 1000, true);
    AdvTimer[playerid] = SetTimer("Reklama",1800000,1);//реклама через каждые 10минут
	GivePlayerMoney(playerid, 100000);
	Colorf[playerid] = 0;
	//Удалённые обьекты
	RemoveBuildingForPlayer(playerid, 11372, -2076.4375, -107.9297, 36.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 11014, -2076.4375, -107.9297, 36.9688, 0.25);
	//-----------------
	SetPlayerInterior(playerid,0);
    SetPlayerPos(playerid,1290.4126,-801.3624,96.4609);
    SetPlayerFacingAngle(playerid, 315.0);
    SetPlayerCameraPos(playerid,1292.7673,-798.4016,97);
    SetPlayerCameraLookAt(playerid,1290.4126,-801.3624,96.4609);
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"Таз Дрифт™: {FFFF00}Добро пожаловать, на {ff0000}Таз Дрифт™ - Лихие 90-е ");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"Таз Дрифт™: {FFFF00}Обязательно прочтите {00FF00}правила {00FF00}игры {FFFF00}на сервере:{00FF00}/rules");
 	SendClientMessage(playerid, COLOR_LIGHTBLUE,"Таз Дрифт™: {FFFF00}Чтобы поприветствовать всех игроков,введите:{00FFFF}/hh");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"Таз Дрифт™: {FFFF00}Чтобы попрощатся со всеми игроками,введите:{00FFFF}/bb");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"Таз Дрифт™: {FFFF00}Главный Администратор {00FFFF}GAME{FF0000}R");
	SendClientMessage(playerid, COLOR_LIGHTBLUE,"Таз Дрифт™: {FFFF00}Для входа в меню нажмите {00FFFF}Alt {FFFF00}или {00FFFF}2(вы должны быть в автомобиле)");
//Иконки на карте
//	SetPlayerMapIcon(playerid,номер иконки,координаты,id иконки,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,0,2025.5804,1007.8265,10.8203,25,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,1,2189.6609,1677.3126,11.3131,25,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,2,2536.4409,2081.6021,10.8203,6,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,3,2157.1365,941.1958,10.8203,6,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,5,-1507.9429,2608.5994,55.8359,6,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,6,-2625.8647,210.6339,4.6173,6,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,8,238.7927,-177.8448,1.5781,6,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,9,2401.8452,-1979.5873,13.5469,6,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,10,1364.5735,-1278.8613,13.5469,6,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,11,1545.9814,-1675.3253,13.5614,30,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,12,-1619.5039,684.9335,7.1901,30,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,13,2295.0627,2457.1348,10.8203,30,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,14,631.0374,-572.1962,16.3359,30,0xFFFFFFFF);
    SetPlayerMapIcon(playerid,15,-325.1331,1533.0276,75.3594,53,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,16,-2207.1196,-991.9159,36.8409,53,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,17,1583.3257,-2375.7019,13.3750,53,0xFFFFFFFF);
	SetPlayerMapIcon(playerid,18,1241.1146,-745.0139,95.0895,53,0xFFFFFFFF);
//-----------------------ТЕКСТ-ДРАВЫ-----------------------------------------|
    //Текст-драв:
	TextDrawCreate(501, 110, "");
    //Текст-драв: Название сервера
    mod = TextDrawCreate(501, 100, "");
    TextDrawAlignment(mod, 1);
    TextDrawFont(mod, 1);
    TextDrawSetOutline(mod,2);
    TextDrawLetterSize(mod, 0.35, 1);
    TextDrawColor(mod, 0x8DFF00FF);
    TextDrawSetShadow(mod, 1);
    TextDrawShowForPlayer(playerid, mod);
    //Текст-драв: Группа ВКонтакте
    vk = TextDrawCreate(4.000000, 427.000000, "vk.com/drift_world_dm");
    TextDrawAlignment(vk, 1);
    TextDrawFont(vk, 1);
    TextDrawSetOutline(vk,0);
    TextDrawLetterSize(vk, 0.500000, 1.000000);
    TextDrawColor(vk,  0xFFFFFFAA);
    TextDrawSetShadow(vk, 1);
    TextDrawShowForPlayer(playerid, vk);
//---------------------------------------------------------------------------|
	//----------------------------- АНТИ-БОТ --------------------------------|
	new ip[16];
	GetPlayerIp(playerid,ip,sizeof(ip));
	new num_ip = GetNumberOfPlayersOnThisIP(ip);
	if(num_ip > 2)
	{
		RangeBan(playerid);
	}
    return 1;
}
public OnPlayerDisconnect(playerid,reason)
{
    TextDrawHideForPlayer(playerid, HelpDraw);
	oplayers--;
	KillTimer(UPDTimer[playerid]);
    KillTimer(OtherTimerVar[playerid]);
    KillTimer(CheckTimer[playerid]);
	KillTimer(CountownTimer[playerid]);
	KillTimer(AutoRepairTimer[playerid]);
    KillTimer(AdvTimer[playerid]);
}

public OnPlayerSpawn(playerid)
{
    SetPlayerWeather(playerid, 10);
	SetWorldTime(00);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 43, 50);
	GivePlayerWeapon(playerid, 46, 30);
	new rand = random(sizeof(RandomSpawn));
	SetPlayerPos(playerid,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2]);
	SetPlayerInterior(playerid,0);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    StopAudioStreamForPlayer(playerid);
    GameTextForPlayer(playerid,"~r~ymep",3000,2);
    GameTextForPlayer(killerid,"~r~+100000",2000,1);
    GivePlayerMoney(killerid, 100000);
    SendDeathMessage(killerid,playerid,reason);
	return 1;
}

stock SavePlayer(playerid)
{
    new string[64];// Масив с путём для файла
    new playername[MAX_PLAYER_NAME];// Масив для получения имени игрока
    new Float:health;
    GetPlayerName(playerid, playername, sizeof(playername));// Получаем Имя игрока
    GetPlayerHealth(playerid,health); //Получаем кол-во хп
    format(string, sizeof(string), "players/%s.ini", playername);// Добавляем имя игрока, в путь для сохранения
    new iniFile = ini_openFile(string);// Открываем файл по тому пути который указали.
    ini_setString(iniFile,"Pass",Player[playerid][pPass]);// Записываем пароль игрока в файл
    ini_setFloat(iniFile,"Heal",health);
    ini_setInteger(iniFile,"Money",GetPlayerMoney(playerid));
    ini_closeFile(iniFile);// Закрываем файл
}
stock PlayerName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pname,sizeof(pname));
	return pname;
}
stock GetNumberOfPlayersOnThisIP(test_ip[])
{
	new against_ip[32+1];
	new x = 0;
	new ip_count = 0;
	for(x=0; x<MAX_PLAYERS; x++)
	{
		if(IsPlayerConnected(x))
		{
			GetPlayerIp(x,against_ip,32);
			if(!strcmp(against_ip,test_ip)) ip_count++;
		}
	}
	return ip_count;
}
stock RangeBan(playerid)
{
	new pos, oldpos, ip[15], ip2[15], tmp[21];
	GetPlayerIp(playerid, ip, sizeof(ip));
	pos = strfind(ip, ".", true);
	pos++;
	for(new i = 0; i < pos; i++)
	{
		ip2[i] = ip[pos-pos+i];
	}
	pos--;
	ip[pos] = ' ';
	oldpos = pos;
	oldpos++;
	pos = strfind(ip, ".", true);
	pos++;
	for(new i = oldpos; i < pos; i++)
	{
		ip2[i] = ip[pos-pos+i];
	}
	format(ip2, sizeof(ip2), "%s*.*", ip2);
	format(tmp, sizeof(tmp), "banip %s", ip2);
	SendRconCommand(tmp);
	return ip2;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
//----------------- бан диалог ------------------------------/

//-----------------------------------------------------------
//-------------Приветствие------------------------------

 if(strcmp(cmdtext, "/hh", true) == 0)
  	{
		new str[128];
        format(str,128,"{00CCFF}..::{00ACFF}%s {00CCFF}приветствует {00ACFF}всех {0083FF}игроков!!!::..",PlayerName(playerid));
	    SendClientMessageToAll(COLOR_RED,str);
		return 1;
	}
	if(strcmp(cmdtext, "/bb", true) == 0)
	{
		new str[128];
        format(str,128,"{00CCFF}..::{00ACFF}%s {00CCFF}прощается {00ACFF}со всеми!!!::..",PlayerName(playerid));
	    SendClientMessageToAll(COLOR_RED,str);
		return 1;
	}

//------------------------------------------------------
//-----------------------------------------------------------------------------------//
if (strcmp("/color", cmdtext, true) == 0)
    {
        if(IsPlayerConnected(playerid))
        {
            new rabotadialog[3000];
            format(rabotadialog,sizeof(rabotadialog), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
            clist[0],clist[1],
            clist[2],clist[3],
            clist[4],clist[5],
            clist[6],clist[7],
            clist[8],clist[9],
            clist[10],clist[11],
            clist[12],clist[13],
            clist[14],clist[15],
			clist[16]);
            ShowPlayerDialog(playerid,89,DIALOG_STYLE_LIST,"Меню цвета",rabotadialog,"Выбрать","Отмена");
            return 1;
        }
    }

if(strcmp(cmdtext, "/buygun", true) == 0)
    {
        if(IsPlayerConnected(playerid))
        {
    ShowPlayerDialog(playerid, 7, DIALOG_STYLE_LIST, "{FFE4B5}Покупка оружия","Deagle {FFFF00}[3000$]\nTec-9 {FFFF00}[5000$]\nМ4 {FFFF00}[7000$]\nАК-47 {FFFF00}[7000$]\nSawnoff Shotgun {FFFF00}[11000$]\nCombat Shotgun {FFFF00}[10000$]\nShotgun {FFFF00}[5000$]\nMicro SMG/Uzi {FFFF00}[6500$]\nSniper Rifle {FFFF00}[8000$]\nПарашут {FFFF00}[5000$]","Купить","отмена");
    return 1;
    }
    }

if(!strcmp(cmdtext, "/resetscore", true))
    {
    ResetPlayerMoney(playerid);
    return 1;
    }

 if(strcmp(cmdtext, "/fm", true) == 0)
    {
        if(IsPlayerConnected(playerid))
        {
            ShowPlayerDialog(playerid,2112,DIALOG_STYLE_LIST,"Радио","Радио Record FM\nРадио Zaycev FM\nРадио Real-FM\nРадио Official Euro FM\nРадио Jazz FM\nРадио Hits FM\nРадио Record-Dubster FM\nРадио Maks FM\nРадио Europa +\nХит FM\nЛучшее радио киева\nDubstep FM\nSoundtrack FM\nElectro House FM\nВыключить радио","Выбрать","Закрыть");
        }
        return true;
    }


    new cmd[256];
	new	tmp[256];
	new Message[256];
	new gMessage[256];
	new pName[MAX_PLAYER_NAME+1];
	new iName[MAX_PLAYER_NAME+1];
    new playermoney;
    new giveplayer[MAX_PLAYER_NAME];
    new giveplayerid, moneys, idx;
    new sendername[MAX_PLAYER_NAME];
    new string[256];
    cmd = strtok(cmdtext, idx);
    
if(strcmp(cmd, "/pm", true) == 0)
    {
        tmp = strtok(cmdtext,idx);

        if(!strlen(tmp) || strlen(tmp) > 5) {
            SendClientMessage(playerid,COLOR_RED,"Сервер: /pm (id) (сообщение)");
            return 1;
        }

        new id = strval(tmp);
        gMessage = strrest(cmdtext,idx);

        if(!strlen(gMessage)) {
            SendClientMessage(playerid,COLOR_RED,"Сервер: /pm (id) (сообщение)");
            return 1;
        }

        if(!IsPlayerConnected(id)) {
            SendClientMessage(playerid,COLOR_RED,"Сервер: Сообщение небыло отправлено! Нет такого ID!");
            return 1;
        }

        if(playerid != id) {
            GetPlayerName(id,iName,sizeof(iName));
            GetPlayerName(playerid,pName,sizeof(pName));
            format(Message,sizeof(Message),"Сообщение лички: %s(%d): %s",iName,id,gMessage);
            SendClientMessage(playerid,PM_OUTGOING_COLOR,Message);
            format(Message,sizeof(Message),"Сообщение лички: %s(%d): %s",pName,playerid,gMessage);
            SendClientMessage(id,PM_INCOMING_COLOR,Message);
            PlayerPlaySound(id,1085,0.0,0.0,0.0);
        }
        else {
            SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"Сообщение небыло отправлено, вы не можете писать в pm самому себе!!!");
        }
         dcmd(dt, 2, cmdtext);
        return 1;
}
//-----------------------------------------------------------Новые команды , и анимки)))
//Анимки
    if(strcmp(cmd, "/piss", true) == 0)
    {
        SetPlayerSpecialAction(playerid,68);
        new str[128];
       	format(str,128,"*** %s пописал за углом :D", PlayerName(playerid));
	    SendClientMessageToAll(COLOR_BLUE,str);
	    return 1;
    }
//Ворота базы
    if(strcmp("/ba1", cmdtext, true, 10) == 0)
    {
		if(gates2==0)
		{
			MoveObject(gates, -2116.69995117,-80.30000305,37.09999847,5);
	    	SendClientMessage(playerid,0x00FF00AA,"Вы открыли базу.");
	    	gates2=1;
	    }
	    else
	    {
	    	MoveObject(gates, -2126.60009766,-80.50000000,37.09999847,5);
    		SendClientMessage(playerid,0x00FF00AA,"Вы закрыли базу.");
            gates2=0;
		}
    	return 1;
	   }
    
	if(strcmp(cmd, "/givemoney", true) == 0) {
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "ИНФО: /givemoney [ид игрока] [сколько]");
			return 1;
		}
		giveplayerid = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "ИНФО: /givemoney [ид игрока] [сколько]");
			return 1;
		}
 		moneys = strval(tmp);


		if (IsPlayerConnected(giveplayerid)) {
			GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			playermoney = GetPlayerMoney(playerid);
			if (moneys > 0 && playermoney >= moneys) {
				GivePlayerMoney(playerid, (0 - moneys));
				GivePlayerMoney(giveplayerid, moneys);
				format(string, sizeof(string), "*Вы отправили %s[ID: %d], $%d.", giveplayer,giveplayerid, moneys);
				SendClientMessage(playerid, COLOR_RED, string);
				format(string, sizeof(string), "*Вы получили $%d от %s[ID: %d].", moneys, sendername, playerid);
				SendClientMessage(giveplayerid, COLOR_RED, string);
				printf("%s(ID:%d) передал %d игроку %s[ID:%d]",sendername, playerid, moneys, giveplayer, giveplayerid);
			}
			else {
				SendClientMessage(playerid, COLOR_RED, "*Неверная сумма. (Деньги не отправлены.)");
			}
		}
		else {
				format(string, sizeof(string), "%d не активный игрок. (Деньги не отправлены.)", giveplayerid);
				SendClientMessage(playerid, COLOR_RED, string);
			}
            return 1;
    }
     if (strcmp(cmd, "/migalka", true) == 0)
    {
        if(IsPlayerConnected(playerid))
            {
                if(Colorf[playerid] == 0)
                {
                    flasher[playerid][0] = CreateDynamicObject(18646,0,0,0,0,0,0);
                    flasher[playerid][1] = CreateDynamicObject(18646,0,0,0,0,0,0);
                    AttachObjectToVehicle(flasher[playerid][0], GetPlayerVehicleID(playerid), -0.5, -0.2, 0.8, 2.0, 2.0, 3.0);
                    AttachObjectToVehicle(flasher[playerid][1], GetPlayerVehicleID(playerid), -0.5, -0.2, 0.8, 2.0, 2.0, 3.0);
                    SendClientMessage(playerid, 0xFFFFFFAA, "[Сервер] Вы устанавили мигалку!");
                    Colorf[playerid] = 1;
                }
                else
                {
                    DestroyObject(flasher[playerid][0]);
                    DestroyObject(flasher[playerid][1]);
                    SendClientMessage(playerid, 0xFFFFFFAA, "[Сервер] Вы убрали мигалку!");
                    Colorf[playerid] = 0;
                }
            }
        return 1;
    }
    
    
    if(strcmp("/rules", cmdtext, true, 10) == 0)
    {
        new String[2048];
        strins(String,"{FF0000} Здравствуйте! Сейчас я ознакомлю вас с правилами сервера.   \n",strlen(String));
        strins(String,"\n",strlen(String));
        strins(String,"{FF2C00}Читайте нормально. Чтобы потом не возникало вопросов.\n",strlen(String));
        strins(String,"{FF5000}На сервере запрещено!!!\n",strlen(String));
        strins(String,"{FF8700}1. Читёрство около админа, или же читёрство которое мешает другому любому игроку.\n",strlen(String));
        strins(String,"{FFA700}2. Запрещено использовать ники кланов. Типо [ADM] , [Admins] \n",strlen(String));
        strins(String,"{FFDC00}если вы не админ.\n",strlen(String));
        strins(String,"{FFFB00}3. Запрещено УБИВАТЬ АДМИНОВ!!! Так как они этого не лююбят и могут въебать бан:D\n",strlen(String));
        strins(String,"{C4FF00}4. Запрещён спид-хак. Если вы его используете то вас кикает автоматически.\n",strlen(String));
     	strins(String,"{7BFF00}5. Запрещены оскорбления в  сторону админов. Они  тоже такие же люди как и вы.\n",strlen(String));
        strins(String,"{00FF00}6. Запрещены CLEO типо как телепорт по клику.\n",strlen(String));
        strins(String,"{00FF1E}ПРАВИЛА ЕЩЁ НЕ ВСЕ, ПРИНОСИМ ВАМ СВОИ ИЗВЕНЕНИЯ!!!\n",strlen(String));
        strins(String,"{00FF3B}ПОЖАЛУЙСТА ПОЕТИТЕ НАШУ ГРУППУ vk.com/drift_world_dm\n",strlen(String));
	    strins(String,"{FFFFFF} *******ПРИЯТНОЙ ВАМ ИГРЫ :D \n",strlen(String));
	    strins(String,"{FFFFFF}                              * Всего доброго! ;)\n",strlen(String));
        strins(String,"\n",strlen(String));
	    ShowPlayerDialog(playerid,1002, DIALOG_STYLE_MSGBOX, "{FFFFFF}Правила сервера!", String, "Ок", "");
	    GivePlayerMoney(playerid, 0);
        return 1;
    }
    if(strcmp("/adm", cmdtext, true, 10) == 0)
    {
        ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "Админка на сервере:","{FF0000}1{00FF00}уровень: {FF0000}50рублей\n{FF0000}2{00FF00}уровень: {FF0000}80рублей\n{FF0000}3{00FF00}уровень: {FF0000}100рублей\n{FF0000}4{00FF00}уровень: {FF0000}120рублей\n{FF0000}5{00FF00}уровень: {FF0000}180рублей\n{FF0000}6{00FF00}уровень: {FF0000}200рублей\n{FF0000}7{00FF00}уровень: {FF0000}250рублей\n{FF0000}8{00FF00}уровень: {FF0000}300рублей\n{FF0000}9{00FF00}уровень: {FF0000}350рублей","Ок","");
        return 1;
    }
       
       if(strcmp("/help", cmdtext, true, 10) == 0)
    {
        new String[2048];
        strins(String,"{FF0000} ..:: Команды сервера ::..\n",strlen(String));
        strins(String,"\n",strlen(String));
        strins(String,"{FF2C00}/cmds - основные команды сервера\n",strlen(String));
        strins(String,"{FF5000}/rules - правила сервера\n",strlen(String));
        strins(String,"{FF8700}/adm - посмотреть цены на админки\n",strlen(String));
        strins(String,"{FFA700}/admins - посмотреть кто из адм онлайн.\n",strlen(String));
        strins(String,"{FF2C00}/givemoney - передать денег\n",strlen(String));
        strins(String,"{FF2C00}/pm - отправить личное сообщение\n",strlen(String));
        strins(String,"{FF5000}/color - сменить цвет ника\n",strlen(String));
        strins(String,"{FF5000}/fm - слушать радио\n",strlen(String));
        strins(String,"{FF5000}/hi - поздороватся со всеми\n",strlen(String));
        strins(String,"{FF8700}/bb - попрощатся со всеми\n",strlen(String));
        strins(String,"{FF5000}/d1-8 - Телепорт на дрифт\n",strlen(String));
        strins(String,"{FF2C00}/drag1-3 - Телепорт на драг\n",strlen(String));
        strins(String,"{FF2C00}/stunt1-2 - Телепорт на стунты\n",strlen(String));
        strins(String,"{FF8700}/tunel1-2 - Телепорт на тунели\n",strlen(String));
        strins(String,"{FF2C00}/race - Телепорт на Гонки\n",strlen(String));
        strins(String,"{FF2C00}/count - отчёт\n",strlen(String));
        strins(String,"{FF2C00}/buygun - купить оружие\n",strlen(String));
        strins(String,"{FF2C00}/migalka - поставить мигалку на авто\n",strlen(String));
        strins(String,"{FF8700}/gang - система банды\n",strlen(String));
        strins(String,"{FF8700}/resetscore - Сброс очков\n",strlen(String));
        strins(String,"{FF2C00}/piss - посцать :D\n",strlen(String));
        strins(String,"{FFDC00}Все остольное вы можете узнать в игровом меню сервера: ALT ( Пешком ) и 2 ( В машине )\n",strlen(String));
	    ShowPlayerDialog(playerid,1002, DIALOG_STYLE_MSGBOX, "{FFFFFF}Команды сервера", String, "Ок", "");
	    GivePlayerMoney(playerid, 0);
        return 1;
    }

//Конец новых команд------------------------------------------------------------------


if(strcmp("/cmds", cmdtext, true, 10) == 0)
	{
	   ShowPlayerDialog(playerid,2011,DIALOG_STYLE_MSGBOX,"{FFFF66}Команды ","Меню на Alt - пешком,2 - в машине, /menu\n/pm [id] [сообщение] - отправить личное сообщение\n/adm - Цены на админки\n/resetscore - обнулить счёт\n/piss - посцать :D","Ок","");
	   return 1;
    }

//Конец анимаций!!!

	if(strcmp(cmdtext, "/d1", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -325.1331,1533.0276,75.3594);
	 	else SetPlayerPos(playerid, -325.1331,1533.0276,75.3594);
		SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Большое Ухо");
		return 1;
	}

    	if(strcmp(cmdtext, "/kva", true) == 0)
	{
        SetPlayerPos(playerid, 1018.2896,-1169.0984,50.9513);
		SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать ко мне на Хату");
		return 1;
	}

	if(strcmp(cmdtext, "/d2", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2207.1196,-991.9159,36.8409);
 		else SetPlayerPos(playerid, -2207.1196,-991.9159,36.8409);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Холм SF");
		return 1;
	}

	if(strcmp(cmdtext, "/d3", true) == 0)
 {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1583.4438476563,-2376.037109375,15.782542228699);
	 	else SetPlayerPos(playerid, 1583.4438476563,-2376.037109375,15.782542228699);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать в Аэропорт Лос Сантоса");
		return 1;
	}

	if(strcmp(cmdtext, "/drag1", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1668, -240,14.010653495789);
	 	else SetPlayerPos(playerid, -1668, -240, 15.0);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Взлётную полосу Аэропорта SF");
		return 1;
	}

	if(strcmp(cmdtext, "/d4", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1241.1146,-745.0139,95.0895);
	 	else SetPlayerPos(playerid, 1241.1146,-745.0139,95.0895);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Гору Вайнвуд");
		return 1;
	}

	if(strcmp(cmdtext, "/d5", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid),-884.28814697266, 550.00549316406, 5.3881149291992);
	 	else SetPlayerPos(playerid, -884.28814697266, 550.00549316406, 5.3881149291992);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Островок раздолья");
		return 1;
	}

	if(strcmp(cmdtext, "/d6", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -113.16453552,583.32196045,3.14548969);
	 	else SetPlayerPos(playerid, -113.16453552,583.32196045,3.14548969);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать в Форт Карсон");
		return 1;
	}

	if(strcmp(cmdtext, "/d7", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1685.10925293,944.96972656,10.53941059);
 		else SetPlayerPos(playerid, 1685.10925293,944.96972656,10.53941059);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Парковку");
		return 1;
	}

	if(strcmp(cmdtext, "/d8", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1574.58410645,713.25219727,10.66216087);
	 	else SetPlayerPos(playerid, 1574.58410645,713.25219727,10.66216087);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Склад-симметрия");
		return 1;
	}

	if(strcmp(cmdtext, "/drag2", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1195.292114,16.669136,14.148437);
	 	else SetPlayerPos(playerid, -1195.292114,16.669136,14.148437);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Пирс в Аэропорту SF");
		return 1;
	}
	
	if(strcmp(cmdtext, "/stunt1", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 414.4188,2499.3838,16.4844);
	 	else SetPlayerPos(playerid, 414.4188,2499.3838,16.4844);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на ");
		return 1;
	}
	
    if(strcmp(cmdtext, "/tunel", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1452.6688,-1063.4215,218.3833);
	 	else SetPlayerPos(playerid, 1452.6688,-1063.4215,218.3833);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Тунель");
		return 1;
	}
	if(strcmp(cmdtext, "/tunel2", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1579.9016,-1245.0582,287.9953);
	 	else SetPlayerPos(playerid, 1579.9016,-1245.0582,287.9953);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Тунель 2");
		return 1;
	}
	if(strcmp(cmdtext, "/stunt2", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1911.5897,-2264.5842,13.5543);
	 	else SetPlayerPos(playerid, 1911.5897,-2264.5842,13.5543);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Стунт 2");
		return 1;
	}
	if(strcmp(cmdtext, "/race", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2286.6729,-41.5808,61.9933);
	 	else SetPlayerPos(playerid, -2286.6729,-41.5808,61.9933);
		SendClientMessage(playerid, 0xFFD700AA,"Добро пожаловать на Стунт - Race SF");
		return 1;
	}
	if (strcmp("/menu", cmdtext, true, 10) == 0)ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "Тюнинг\nПеревернуть тачку\nТелепорты\n{FFCCFF}Телепорты 2 NEW!\nКоманды сервера\nАвтомобили\n{0000FF}Радио NEW!\n{EE4000}Отсчёт\n{00FF00}Управление Авто\nПомощь\nОфициальные {FF0000}Банды\nКупить Оружие\nУправление персонажем\nАнимации\n{FFCCFF}Сброс очков\n{0000FF}Смена цвета ника", "Выбрать", "Выход");
	if (strcmp("/count", cmdtext, true, 10) == 0)
	{
        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)return SendClientMessage(playerid, 0xFF0000AA,"[INFO]: Вы должны быть в тачке");
 		new Float: X, Float:Y, Float: Z;
   		GetPlayerPos(playerid, X, Y, Z);
	    countdown[playerid]=11;
		for(new i=0;i<MAX_PLAYERS;i++)
		if(IsPlayerInRangeOfPoint(i,15.0,X,Y,Z))
		{
			if(GetPlayerState(i) != PLAYER_STATE_ONFOOT && countdown[i]==-1)countdown[i]=11;
		}
		return 1;
	}
		return 0;
	}

public OnPlayerText(playerid, text[])
{
	new string[256], sendername[32], name[32];
	GetPlayerName(playerid, sendername, 32);
	format(string, sizeof(string), "%s{ffffff}(id: %d): %s", name, playerid, text);
	SetPlayerName(playerid, string);
	SendPlayerMessageToAll(playerid, string);
	if(strfind(text,"[Aliance of Cheaters]Site Clan: AoC-GTA.RU[PizDoS Bot 0.3x || by AlexDrift]",true) == 0) return BanEx(playerid, "AntiDoS: PizDoS_Bot");
    if(strfind(text,"Бля админы скажите что делать чтобы дальше регаться у меня ничего нетууу",true) == 0) return BanEx(playerid, "AntiDoS: PizDoS_Bot");
    if(strfind(text,"Бля админы скажите",true) == 0) return BanEx(playerid, "AntiDoS: PizDoS_Bot");
    return 0;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{

	if ((newkeys==KEY_SUBMISSION))
	{
		if(IsPlayerInAnyVehicle(playerid))
		ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "{0099FF}>>Тюнинг Авто\n{FFFF00}>>Перевернуть Авто\n{99CC66}>>Меню Телепортов\n{99CC66}>>{15ff00}ДеадМатчи\n{FF0000}>>Создатели Мода\n{00FF00}>>Автомобили\n{FFFF00}>>MP3-Плеер\n{FF3300}>>Отсчёт\n{FFA500}>>Управление авто\n{1E90FF}>>Помощь\n{FFFFFF}>>Официальные {FF0000}Банды\n{00FFFF}>>*{00FF00}Оружие{00FFFF}*\n>>Управление персонажем\n{00FFFF}>>Анимации\n{FFFF00}>>Сброс Очков\n{00FA9A}>>Смена цвета ника", "Выбрать", "Выход");
	}

	if ((newkeys==1024))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "{0099FF}>>Тюнинг Авто\n{FFFF00}>>Перевернуть Авто\n{99CC66}>>Меню Телепортов\n{99CC66}>>{15ff00}ДеадМатчи\n{FF0000}>>Создатели Мода\n{00FF00}>>Автомобили\n{FFFF00}>>MP3-Плеер\n{FF3300}>>Отсчёт\n{FFA500}>>Управление авто\n{1E90FF}>>Помощь\n{FFFFFF}>>Официальные {FF0000}Банды\n{00FFFF}>>*{00FF00}Оружие{00FFFF}*\n>>Управление персонажем\n{00FFFF}>>Анимации\n{FFFF00}>>Сброс Очков\n{00FA9A}>>Смена цвета ника", "Выбрать", "Выход");
	}

	if( newkeys == 1 || newkeys == 9 || newkeys == 33 && oldkeys != 1 || oldkeys != 9 || oldkeys != 33)
	{
		new Car = GetPlayerVehicleID(playerid), Model = GetVehicleModel(Car);
		switch(Model)
		{
			case 446,432,448,452,424,453,454,461,462,463,468,471,430,472,449,473,481,484,493,495,509,510,521,538,522,523,532,537,570,581,586,590,569,595,604,611: return 0;
		}
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
	}
    return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == 89)
    {
        if(response == 1)
        {
        if(listitem == 0)
        {
        SetPlayerColor(playerid,COLOR_WHITE);
        }
        if(listitem == 1)
        {
        SetPlayerColor(playerid,Cvet_1);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 2)
        {
        SetPlayerColor(playerid,Cvet_2);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 3)
        {
        SetPlayerColor(playerid,Cvet_3);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 4)
        {
        SetPlayerColor(playerid,Cvet_4);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 5)
        {
        SetPlayerColor(playerid,Cvet_5);
		SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 6)
        {
        SetPlayerColor(playerid,Cvet_6);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 7)
        {
        SetPlayerColor(playerid,Cvet_7);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 8)
        {
        SetPlayerColor(playerid,Cvet_8);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 9)
        {
        SetPlayerColor(playerid,Cvet_9);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 10)
        {
        SetPlayerColor(playerid,Cvet_10);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 11)
        {
        SetPlayerColor(playerid,Cvet_11);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 12)
        {
        SetPlayerColor(playerid,Cvet_12);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 13)
        {
        SetPlayerColor(playerid,Cvet_13);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 14)
        {
        SetPlayerColor(playerid,Cvet_14);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        if(listitem == 15)
        {
        SetPlayerColor(playerid,Cvet_15);
        SendClientMessage(playerid, COLOR_GREEN, "[Сервер] Вы активировали цвет.");
        }
        else
        {
        }
    }
    }



if(dialogid ==7)// покупка оружия
    {
        if(response)
        {
            if(listitem == 0)// 
            {
                if(GetPlayerMoney(playerid) <3000) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 24, 500 ); // Deagle
                GivePlayerMoney(playerid, -3000); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили Deagle.");
                return 1;
            }

            if(listitem == 1)// 
            {
                if(GetPlayerMoney(playerid) <5000) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 32, 5000); // Tec-9
                GivePlayerMoney(playerid, -5000); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили Tec-9.");
                return 1;
            }

            if(listitem == 2)// 
            {
                if(GetPlayerMoney(playerid) <7000) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 31, 7000); // m4
                GivePlayerMoney(playerid, -7000); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили M4.");
                return 1;
            }
            if(listitem == 3)// 
            {
                if(GetPlayerMoney(playerid) <7000) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 30, 7000); //Ak 47
                GivePlayerMoney(playerid, -7000); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили AK-47.");
                return 1;
            }
            if(listitem == 4)// 
            {
                if(GetPlayerMoney(playerid) <11000) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 26, 7000); // Sawnoff Shotgun
                GivePlayerMoney(playerid, -11000); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили Sawnoff Shotgun.");
                return 1;
            }
            if(listitem == 5)// iiia? no?i?ee
            {
                if(GetPlayerMoney(playerid) <8000) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 27, 2000); //Combat Shotgun
                GivePlayerMoney(playerid, -8000); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили Combat Shotgun.");
                return 1;
            }
            if(listitem == 6)// iiia? no?i?ee
            {
                if(GetPlayerMoney(playerid) <5000) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 25, 2000); //Shotgun
                GivePlayerMoney(playerid, -5000); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили Shotgun.");
                return 1;
            }
            if(listitem == 7)// iiia? no?i?ee
            {
                if(GetPlayerMoney(playerid) <6500) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 28, 5000); //Micro SMG/Uzi
                GivePlayerMoney(playerid, -6500); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили Micro SMG/Uzi.");
                return 1;
            }
            if(listitem == 8)// iiia? no?i?ee
            {
                if(GetPlayerMoney(playerid) <8000) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 34, 2000); //Combat Shotgun
                GivePlayerMoney(playerid, -8000); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили Sniper Rifle.");
                return 1;
			}
            if(listitem == 9)// iiia? no?i?ee
            {
                if(GetPlayerMoney(playerid) <5000) return SendClientMessage(playerid, COLOR_WHITE, "Недостаточно средств");
                GivePlayerWeapon(playerid, 46,221); //Combat Shotgun
                GivePlayerMoney(playerid, -5000); // noieiinou
                SendClientMessage(playerid, COLOR_GREEN2, "[Сервер] Вы купили Парашут.");
                return 1;
            }
        }
        return 1;
    }

if(dialogid == 2112)
    {
        if(response)
        {
            if(listitem == 0)
            {
                PlayAudioStreamForPlayer(playerid,"http://vsyaka-vsyachina.ru/m3u/rr192-28kbps.m3u");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Record FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 1)
            {
                PlayAudioStreamForPlayer(playerid,"http://www.zaycev.fm:9001/rnb/ZaycevFM(128)");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Zaycev FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 2)
            {
                PlayAudioStreamForPlayer(playerid,"http://rp-mygame.my1.ru/MG/real.pls");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Real FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 3)
            {
                PlayAudioStreamForPlayer(playerid,"http://rp-mygame.my1.ru/MG/mg-fm.m3u");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Official Euro FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 4)
            {
                PlayAudioStreamForPlayer(playerid,"http://rp-mygame.my1.ru/MG/mg-fm.m3u");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Jazz FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 5)
            {
                PlayAudioStreamForPlayer(playerid,"http://rp-mygame.my1.ru/MG/hits.pls");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Hits FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 6)
            {
                PlayAudioStreamForPlayer(playerid,"http://online.radiorecord.ru:8102/dub_128");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Record-Dubstep FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 7)
			{
                PlayAudioStreamForPlayer(playerid,"http://radio.maks-fm.ru:8000/maksfm128.m3u");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Maks FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 8)
            {
                PlayAudioStreamForPlayer(playerid,"http://webcast.emg.fm:55655/europaplus128.mp3");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Europa + FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 9)
            {
                PlayAudioStreamForPlayer(playerid,"http://www.hitfm.ua/HitFM.m3u");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Хит FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 10)
            {
                PlayAudioStreamForPlayer(playerid,"http://myradio.ua/alias/top-100-kiev128mp.m3u");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Лучшее радио Киева");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 11)
            {
                PlayAudioStreamForPlayer(playerid,"http://myradio.ua/alias/dubstep128mp.m3u");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Dubstep FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 12)
            {
                PlayAudioStreamForPlayer(playerid,"http://myradio.ua/alias/soundtrack128mp.m3u");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Soundtrack FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 13)
            {
                PlayAudioStreamForPlayer(playerid,"http://myradio.ua/alias/Electro-House128mp.m3u");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Радио волна: Electro House FM");
                SendClientMessage(playerid, COLOR_ORANGE, "[Сервер] Подождите 5 секунд для появы сигнала.");
            }
            if(listitem == 14)
            {
                StopAudioStreamForPlayer(playerid);
                SendClientMessage(playerid,COLOR_GREEN,"[Сервер] Радио отключено.");
            }
        }
        else { }
    }

    new carid = GetPlayerVehicleID(playerid);
	new engine,lights,alarm,doors,bonnet,boot,objective;
    if(dialogid == 0)//так же не моё, из AutoMenu
	{
		if(response)
		{
			if(listitem == 0)//капот отк
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,lights,alarm,doors,true,boot,objective);
			}
			else if(listitem == 1)//багажник отк
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,true,objective);
			}
			else if(listitem == 2)//свет вкл
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,true,alarm,doors,bonnet,boot,objective);
			}
			else if(listitem == 3)//сигнал вкл
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,lights,true,doors,bonnet,boot,objective);
			}
			else if(listitem == 4)//двери блок
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,lights,alarm,true,bonnet,boot,objective);
			}
			else if(listitem == 5)//мотор старт
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,true,lights,alarm,doors,bonnet,boot,objective);
			}
			else if(listitem == 6)//капот зак
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,lights,alarm,doors,false,boot,objective);
			}
			else if(listitem == 7)//багажник зак
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,false,objective);
			}
			else if(listitem == 8)//свет выкл
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,false,alarm,doors,bonnet,boot,objective);
			}
			else if(listitem == 9)//сигнал выкл
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,lights,false,doors,bonnet,boot,objective);
			}
			else if(listitem == 10)//двери откр
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,engine,lights,alarm,false,bonnet,boot,objective);
			}
			else if(listitem == 11)//мотор стоп
			{
			    GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
              	SetVehicleParamsEx(carid,false,lights,alarm,doors,bonnet,boot,objective);
			}
			else if(listitem == 12)
			{
			    ShowPlayerDialog(playerid,1,DIALOG_STYLE_LIST,"{FFE4B5}Неоновая подсветка","{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\n{FFFF00}Желтый\n{FEBFEF}Розовый\nБелый\nУдалить Неон","Выбрать","Отмена");
			}
			else if(listitem == 13)//смена номера
			{
			    ShowPlayerDialog(playerid,2,DIALOG_STYLE_INPUT,"{FFE4B5}Смена номера","{0033CC}Введите номера авто в окошко","Готово","Отмена");
			}
			else if(listitem == 13)//смена номера
			{
			    new one = CreateObject(18646,0,0,0,0,0,0,100.0);
                AttachObjectToVehicle(one, GetPlayerVehicleID(playerid), -0.4, -0.1, 0.87, 0.0, 0.0, 0.0);
				return 1;
			}
		}
	}
	if(dialogid == 1)
	{
		if(response)
		{
			if(listitem == 0)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(18647,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18647,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem == 1)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(18648,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18648,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem == 2)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(18649,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18649,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem==3)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(18650,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18650,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem==4)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(18651,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18651,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem==5)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(18652,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18652,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem==6)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
			}
		}
	}
	if(dialogid == 2)
	{
		if(response)
		{
		    if(!strlen(inputtext))
	    	{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_INPUT,"{FFFF00}Смена номера","Введите номера авто в окошко","Готово","Отмена");
				return 1;
	    	}
	    	if(strlen(inputtext) > 10)
	    	{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_INPUT,"{FFFF00}Смена номера","Cлишком длинный номер!\nВведите номера авто в окошко","Готово","Отмена");
				return 1;
	    	}
            new Float:x,Float:y,Float:z,Float:ang;
            SetVehicleNumberPlate(GetPlayerVehicleID(playerid), inputtext);
			GetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
			GetVehicleZAngle(GetPlayerVehicleID(playerid),ang);
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			SetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
			PutPlayerInVehicle(playerid,GetPlayerVehicleID(playerid),0);
			SetVehicleZAngle(GetPlayerVehicleID(playerid),ang);
		}
	}

	if(dialogid == 3)//главное меню
	{
		if(response)
		{
		    if(listitem == 0)
			{
				if(IsPlayerInAnyVehicle(playerid))
				{
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "{FFFF00}>>Диски \n{4b0082}>>Гидравлика\n{ffd700}>>Архангел Тюнинг \n{42aaff}>>Цвет \n{ff0000}>>Винилы ", "Выбрать", "Назад");
					else SendClientMessage(playerid, COLOR_RED, "Ты не водитель тачки!");
				}
    			else SendClientMessage(playerid, COLOR_RED, "Ты не в тачке.");
			}
			if(listitem == 1)//remont
		    {
            	SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.0);
			 }
			if(listitem == 2)ShowPlayerDialog(playerid, 5, DIALOG_STYLE_LIST, "Телепорты", "Большое Ухо\nХолм SF\nАквапарк\nГора\nФорт Карсон\nПарковка\nСклад-Симметрия\nДраг 1\nДраг 2\nДраг 3\nДраг 4\nДраг 5\nДрифт 1\nДрифт 2\nДрифт 3\nДрифт 4\nДрифт 5\nДрифт 6\nДрифт 7\nГородок\nЗаброшка\nStunt LV\nПарковка\nMeGa-Stunt", "Выбрать", "Назад");
			if(listitem == 13)ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "Меню Анимации", "{99FF33}Напитки и Cигареты\n{99FF33}Танцевать\n{99FF33}Звонить\n{99FF33}Остановить анимацию", "OK", "Назад");
			if(listitem == 4)ShowPlayerDialog(playerid, 7, DIALOG_STYLE_MSGBOX, "Создатели Мода", "{FFFF00}Создатель мода - {00FFFF}GAM{FF0000}ER\n{00FF00}Владелец проэкта - {00FFFF}GAM{FF0000}ER{FFFFFF}\n\n{FFFFFF}Контакты:\n\n{00FFFF}Skype:\n{FFFFFF}Pro100_Drifter\n\n{00FFFF}[B]{00FF00}контакте\n{FF0000}vk.com/pro_gamer_pro\n\n{FFFF00}ICQ\n\n", "OK", "");
			if(listitem == 5)//авто
			{
        		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,0x21DD00FF,"Вы уже в транспорте");
				ShowPlayerDialog(playerid,9,DIALOG_STYLE_LIST,"Покупка авто","Elegy\nSultan\nInfernus\nBanshee\nBufallo\nHuntley\nChetah\nTurismo\nSlamvan\nBlade\nBullet\nJester\nBandito\nWinsdor\nStrech\nSuperGT\nNRG-500\nSanchez\nStratum\nUranus\nClub\nMonster","ОК","Назад");
				return 1;
			}
			if(listitem == 12)ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "Управление Персонажем", "{FFE4C4}>>Пополнить броню\n{800000}>>Пополнить жизни\n{FFFF00}>>Сменить скин\n{00FF00}>>Самоубийство", "OK", "Назад");
            if(listitem == 7)return OnPlayerCommandText(playerid,"/count");
            if(listitem == 8)
            {
                if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,0xFFFFFFFF,"Вы должны быть в машине!");
				ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Авто-Меню","Открыть капот\nОткрыть багажник\nВключить свет\nВключить сигнализацию\nЗакрыть двери\nЗапустить мотор\
				\nЗакрыть капот\nЗакрыть багажник\nВыключить свет\nВыключить сигнализацию\nОткрыть двери\nЗаглушить мотор\nНеон\nСменить номер\n","Выбрать","Отмена");
			}
			if(listitem == 9)ShowPlayerDialog(playerid, 55, DIALOG_STYLE_LIST, "Помощь", "Правила сервера\nКоманды Сервера\nАдминка на сервере\nАдминистрация\nВозможные проблемы", "Выбрать", "Назад");
			if(listitem == 10)ShowPlayerDialog(playerid, 56, DIALOG_STYLE_LIST, "Официальные банды", "{00FF00}Банда {00FFFF}Elegy {FFFFFF}Drift {FF0000}Clan{00FF00}\n{FF0000}Как добавить?\n{00FF00}Банда {FFFFFF}БПА{FF0000}N\n{00FFFF}Место Свободно {FFFF00}[Skype:{00FF00}Pro100Drifter{00FF00}]", "Выбрать", "Назад");
			if(listitem == 3)ShowPlayerDialog(playerid, 60, DIALOG_STYLE_LIST, "{0000ff}ДеадМатч-Меню", "\n{ff8800}ДеадМатч-Дигл\n{ea7500}ДеадМат-Шот\n{ffff00}ДеадМатч Дигл + Шот\n{ccff00}ДеадМатч-M4\n{00ff00}ДеадМатч-M5\n{00ff00}ДеадМатч-Савн\n{c7fcec}ДеадМатч-Пила\n{7df9ff}ДеадМатч-Area\n{008cf0}ДеадМатч-Тек9\n{660099}ДеадМатч-Пляж\nСounter-Strike", "Выбрать", "Назад");
			if(listitem == 6)return OnPlayerCommandText(playerid,"/fm");
			if(listitem == 11)return OnPlayerCommandText(playerid,"/buygun");
			if(listitem == 14)return OnPlayerCommandText(playerid,"/resetscore");
			if(listitem == 15)return OnPlayerCommandText(playerid,"/color");
		}
	}

	if(dialogid == 8)//upravl persom
	{
		if(response)
		{
			if(listitem == 0)
		    {
				SetPlayerArmour(playerid,100);
				ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "Управление Персонажем", "{FFE4C4}>>Пополнить броню\n{800000}>>Пополнить жизни\n{FFFF00}>>Сменить скин\n{00FF00}>>Самоубийство", "OK", "Назад");
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
			}
			if(listitem == 3)
		    {
				SetPlayerHealth(playerid,0);
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
			}
			if(listitem == 1)
			{
				SetPlayerHealth(playerid,100);
				ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "Управление Персонажем", "{FFE4C4}>>Пополнить броню\n{800000}>>Пополнить жизни\n{FFFF00}>>Сменить скин\n{00FF00}>>Самоубийство", "OK", "Назад");
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
			}
        	if(listitem == 2)ShowPlayerDialog(playerid, 10, DIALOG_STYLE_INPUT, "Смена скина", "Введите ID", "OK", "назад");
        	if(listitem == 4)
			{
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,30,100);
				GivePlayerWeapon(playerid,4,100);
				GivePlayerWeapon(playerid,28,100);
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
			}
		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "{0099FF}>>Тюнинг Авто\n{FFFF00}>>Перевернуть Авто\n{99CC66}>>Меню Телепортов\n{99CC66}>>{15ff00}ДеадМатчи\n{FF0000}>>Создатели Мода\n{00FF00}>>Автомобили\n{FFFF00}>>MP3-Плеер\n{FF3300}>>Отсчёт\n{FFA500}>>Управление авто\n{1E90FF}>>Помощь\n{FFFFFF}>>Официальные {FF0000}Банды\n{00FFFF}>>*{00FF00}Оружие{00FFFF}*\n>>Управление персонажем\n{00FFFF}>>Анимации\n{FFFF00}>>Сброс Очков\n{00FA9A}>>Смена цвета ника", "Выбрать", "Выход");

}

	if(dialogid == 4)//tuning menu главная
	{
		if(response)
		{
		    if(listitem == 0)
		    {
		    	ShowPlayerDialog(playerid, 11, DIALOG_STYLE_LIST, "Список дисков", "Shadow\nMega\nWires\nClassic\nRimshine\nCutter\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic", "OK", "Назад");
			}
			if(listitem == 1)
		    {
		    	new vehicleid = GetPlayerVehicleID(playerid);
				AddVehicleComponent(vehicleid,1087);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "{FFFF00}>>Диски \n{4b0082}>>Гидравлика\n{ffd700}>>Архангел Тюнинг \n{42aaff}>>Цвет \n{ff0000}>>Винилы ", "Выбрать", "Назад");
			}
			if(listitem == 2)
			{
			    new Car = GetPlayerVehicleID(playerid), Model = GetVehicleModel(Car);
				switch(Model)
				{
					case 559,560,561,562,565: ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					default: SendClientMessage(playerid,0xFFFFFFFF,"Вы должны быть в: Елегия, Стратум, Флеш, Султан, Уранус");
				}
			}
			if(listitem == 3)ShowPlayerDialog(playerid, 13, DIALOG_STYLE_LIST, "Выбор цвета", "{FF0000}Красный \n{00CCFF}Голубой \n{FFFF33}Желтый \n{00FF00}Зеленый \n{CCCCCC}Серый \n{FF9933}Оранжевый \nЧерный \n{FFFFFF}Белый", "ОК", "Назад");
			if(listitem == 4)ShowPlayerDialog(playerid, 14, DIALOG_STYLE_LIST, "Выбор винила", "Винил №1 \nВинил №2 \nВинил №3 ", "ОК", "Назад");
		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "{0099FF}>>Тюнинг Авто\n{FFFF00}>>Перевернуть Авто\n{99CC66}>>Меню Телепортов\n{99CC66}>>{15ff00}ДеадМатчи\n{FF0000}>>Создатели Мода\n{00FF00}>>Автомобили\n{FFFF00}>>MP3-Плеер\n{FF3300}>>Отсчёт\n{FFA500}>>Управление авто\n{1E90FF}>>Помощь\n{FFFFFF}>>Официальные {FF0000}Банды\n{00FFFF}>>*{00FF00}Оружие{00FFFF}*\n>>Управление персонажем\n{00FFFF}>>Анимации\n{FFFF00}>>Сброс Очков\n{00FA9A}>>Смена цвета ника", "Выбрать", "Выход");
	}


	if(dialogid == 11)//spisok diskov
	{
		if(response)
		{
			new vehicleid = GetPlayerVehicleID(playerid);

		    if(listitem == 0)AddVehicleComponent(vehicleid,1073);
			if(listitem == 1)AddVehicleComponent(vehicleid,1074);
			if(listitem == 2)AddVehicleComponent(vehicleid,1076);
			if(listitem == 3)AddVehicleComponent(vehicleid,1077);
			if(listitem == 4)AddVehicleComponent(vehicleid,1075);
			if(listitem == 5)AddVehicleComponent(vehicleid,1079);
			if(listitem == 6)AddVehicleComponent(vehicleid,1078);
			if(listitem == 7)AddVehicleComponent(vehicleid,1080);
			if(listitem == 8)AddVehicleComponent(vehicleid,1081);
			if(listitem == 9)AddVehicleComponent(vehicleid,1082);
			if(listitem == 10)AddVehicleComponent(vehicleid,1083);
			if(listitem == 11)AddVehicleComponent(vehicleid,1084);
			if(listitem == 12)AddVehicleComponent(vehicleid,1085);

			PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			ShowPlayerDialog(playerid, 11, DIALOG_STYLE_LIST, "Список дисков", "Shadow\nMega\nWires\nClassic\nRimshine\nCutter\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic", "OK", "Назад");
		}
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "{FFFF00}>>Диски \n{4b0082}>>Гидравлика\n{ffd700}>>Архангел Тюнинг \n{42aaff}>>Цвет \n{ff0000}>>Винилы ", "Выбрать", "Назад");
		}

	if(dialogid == 13)//colors             cveta
	{
		if(response)
		{
		    new vehicleid = GetPlayerVehicleID(playerid);

 			if(listitem == 0)ChangeVehicleColor(vehicleid, 3, 3);
			if(listitem == 1)ChangeVehicleColor(vehicleid, 79, 79);
			if(listitem == 2)ChangeVehicleColor(vehicleid, 65, 65);
			if(listitem == 3)ChangeVehicleColor(vehicleid, 86, 86);
			if(listitem == 4)ChangeVehicleColor(vehicleid, 9, 9);
			if(listitem == 5)ChangeVehicleColor(vehicleid, 6, 6);
			if(listitem == 6)ChangeVehicleColor(vehicleid, 0, 0);
			if(listitem == 7)ChangeVehicleColor(vehicleid, 1, 1);

			PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
			ShowPlayerDialog(playerid, 13, DIALOG_STYLE_LIST, "Выбор цвета", "{FF0000}Красный \n{00CCFF}Голубой \n{FFFF33}Желтый \n{00FF00}Зеленый \n{CCCCCC}Серый \n{FF9933}Оранжевый \nЧерный \n{FFFFFF}Белый", "ОК", "Назад");
		}
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "{FFFF00}>>Диски \n{4b0082}>>Гидравлика\n{ffd700}>>Архангел Тюнинг \n{42aaff}>>Цвет \n{ff0000}>>Винилы ", "Выбрать", "Назад");
	}

	if(dialogid == 9)//car spawning into
	{
		if(response)//машинное меню
		{
			new carvlad[20],Float:X,Float:Y,Float:Z,Float:Angle,id,string[256];
			GetPlayerPos(playerid,X,Y,Z);
			GetPlayerFacingAngle(playerid,Angle);
			switch(listitem)
			{
				case 0: carvlad = "Elegy", id = 562;
				case 1: carvlad = "Sultan", id = 560;
				case 2: carvlad = "Infernus", id = 411;
				case 3: carvlad = "Banshee", id = 429;
				case 4: carvlad = "Buffalo", id = 402;
				case 5: carvlad = "Huntley", id = 579;
				case 6: carvlad = "Cheetan", id = 415;
				case 7: carvlad = "Turismo", id = 451;
				case 8: carvlad = "Slamvan", id = 535;
				case 9: carvlad = "Blade", id = 536;
				case 10: carvlad = "Bullet", id = 541;
				case 11: carvlad = "Jester", id = 559;
				case 12: carvlad = "Bandito", id = 568;
				case 13: carvlad = "Vinsdor", id = 555;
				case 14: carvlad = "Strech", id = 409;
				case 15: carvlad = "SuperGT", id = 506;
				case 16: carvlad = "NRG-500", id = 522;
				case 17: carvlad = "Sanchez", id = 468;
                case 18: carvlad = "Стратум", id = 561;
                case 19: carvlad = "Uranus", id = 558;
                case 20: carvlad = "Club", id = 589;
                case 21: carvlad = "Monster", id = 444;
			}
			format(string,sizeof(string),"{00ccff}Таз Дрифт™: {FF0000}%s {00FFFF}заспавнен ",carvlad); SendClientMessage(playerid,0x21DD00FF,string);
			if(ta4katest[playerid] == 1)DestroyVehicle(ta4ka[playerid]);
			ta4ka[playerid] = CreateVehicle(id,X,Y,Z,Angle,-1,-1,50000);
			if(GetPlayerInterior(playerid)) LinkVehicleToInterior(ta4ka[playerid],GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(ta4ka[playerid],GetPlayerVirtualWorld(playerid));
			PutPlayerInVehicle(playerid,ta4ka[playerid],0);
			ta4katest[playerid] = 1;
			PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		}
		return 1;
	}

	if(dialogid == 6)//Меню анимации взято из скрипта Panther'a
	{
  		if(response)
  		{
			if(listitem == 0)ShowPlayerDialog(playerid, 15, DIALOG_STYLE_LIST, "Напитки и Cигареты", "Пиво\nСигареты\nВодка\nСпрайт\nЛечь", "OK", "Назад");
            if(listitem == 1)ShowPlayerDialog(playerid, 16, DIALOG_STYLE_LIST, "Танцевать", "Танец - 1\nТанец - 2\nТанец - 3\nТанец - 4\nРуки Вверх", "OK", "Назад");
            if(listitem == 2)ShowPlayerDialog(playerid, 17, DIALOG_STYLE_LIST, "Звонить", "Звонить\nБухой с трубой =D", "OK", "Назад");
            if(listitem == 3)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                SetPlayerDrunkLevel(playerid, 0);
                SetPlayerSpecialAction (playerid, 13 - SPECIAL_ACTION_STOPUSECELLPHONE);
		        SendClientMessage(playerid, 0xFFFFFFAA, "Ты остановил анимацию можеш двигаться!");
			}
   			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
 		}
	}

	if(dialogid == 15)//anim buhlo
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DRINK_BEER );
    	        SendClientMessage(playerid, 0xFFFFFFAA, "Ты чё за рулём? Выпей лучьше водки!");
			}
			if(listitem == 1)
			{
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_SMOKE_CIGGY );
    	        SendClientMessage(playerid, 0xFFFFFFAA, "Курни..!");
			}
			if(listitem == 2)
			{
			    SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DRINK_WINE );
    	        SendClientMessage(playerid, 0xFFFFFFAA, "Оооо, это тема ёпт)");
			}
			if(listitem == 3)
			{
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DRINK_SPRUNK );
    	        SendClientMessage(playerid, 0xFFFFFFAA, "Выпей спрайту");
			}
			if(listitem == 4)
			{
				ApplyAnimation(playerid,"CRACK","crckdeth2",4.1,0,1,1,1,1);
    	        SendClientMessage(playerid, 0xFFFFFFAA, "Напился бичуга, теперь поспи, эээээххх...");
			}
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
   		}
		else ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "{33FFFF}Меню Анимации", "{99FF33}Напитки и Cигареты\n{99FF33}Танцевать\n{99FF33}Звонить\n{99FF33}Остановить анимацию", "OK", "Назад");
   }
   	if(dialogid == 55)
	{
		if(response)
		{
			if(listitem == 0)
			{
				return OnPlayerCommandText(playerid,"/rules");
			}
			if(listitem == 1)
			{
				return OnPlayerCommandText(playerid,"/help");
			}
			if(listitem == 2)
			{
			    ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "Админка на сервере:","{FF0000}1{00FF00}уровень: {FF0000}50рублей\n{FF0000}2{00FF00}уровень: {FF0000}80рублей\n{FF0000}3{00FF00}уровень: {FF0000}100рублей\n{FF0000}4{00FF00}уровень: {FF0000}120рублей\n{FF0000}5{00FF00}уровень: {FF0000}180рублей\n{FF0000}6{00FF00}уровень: {FF0000}200рублей\n{FF0000}7{00FF00}уровень: {FF0000}250рублей\n{FF0000}8{00FF00}уровень: {FF0000}300рублей\n{FF0000}9{00FF00}уровень: {FF0000}350рублей","Ок","");
			}
			if(listitem == 3)
			{
			    ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{33FF00}Администрация", "{00FF00}Главный админ:\n{00FFFF}GAM{FF0000}ER\n\n\n{FF4500}Зам админ\nEMOtion\n\n\n\n{FFFF00}Обычные админы:\n\n\n","Ок","");
			}
			if(listitem == 4)
			{
			    ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{33FF00}Возможные проблемы", "{FF3300}Если Радио не работает, попробуйте прибавить громкости в {33FF00}меню игры (ESC)\nЕсли не загружаются текстуры (дороги), {33FF00}выйдите из машины", "OK", "");
			}
			if(listitem == 5)
			{
			    ShowPlayerDialog(playerid, 1024,DIALOG_STYLE_MSGBOX,"{FFFF66}Услуги от | DRIFT WORLD |:","{FF0000}Маппинг (малый) = 40 рублей!\nМаппинг (большой) = 100 рублей\n\nСкриптинг\n\nСкриптёр на сервер: = 140 рублей\nКупить наш мод: = 500 рублей (с pwn)\n¦¦•DRIFT WORLD•¦¦","Ок","");
			}
   		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "{0099FF}>>Тюнинг Авто\n{FFFF00}>>Перевернуть Авто\n{99CC66}>>Меню Телепортов\n{99CC66}>>{15ff00}ДеадМатчи\n{FF0000}>>Создатели Мода\n{00FF00}>>Автомобили\n{FFFF00}>>MP3-Плеер\n{FF3300}>>Отсчёт\n{FFA500}>>Управление авто\n{1E90FF}>>Помощь\n{FFFFFF}>>Официальные {FF0000}Банды\n{00FFFF}>>*{00FF00}Оружие{00FFFF}*\n>>Управление персонажем\n{00FFFF}>>Анимации\n{FFFF00}>>Сброс Очков\n{00FA9A}>>Смена цвета ника", "Выбрать", "Выход");
   }
   
   if(dialogid == 56)
	{
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid, 1022,DIALOG_STYLE_MSGBOX,"{00FF00}Банда {00FFFF}Elegy {FFFFFF}Drift {FF0000}Clan{00FF00} :","{00FF00}Основатель клана:\n{00FFFF}GAM{FF0000}ER\n\n{00FF00}В клане:\n{FFFF00}пусто\n{FFFFFF}пусто\n{FFFFFF}пусто\n\n","Ок","");
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid, 1023,DIALOG_STYLE_MSGBOX,"{FFFF66}Как добавить сюда мой клан? И какой смысл?:","{FF0000}Для начало собъясню смысл.\nВы давно хотели чтобы у вашего клана поивалась крутая база?\n{FFFF00}Конечно же да, это стоит всего 30 рублей в месяц.\nМы добавим ваш клан в официальные {FF0000}Банды, и у вас появится возможность:\nИметь свою базу.(Какую вы попросите, на заказ)\nЕсли что обратится к гл Админам, которые вам помогут.\n\n| DRIFT RUSSIA |","Ок","");
			}
			if(listitem == 2)
			{
				ShowPlayerDialog(playerid, 1027,DIALOG_STYLE_MSGBOX,"{FFFF66}Клан Пусто:","{0066FF}Основатель клана:\n{FFFFFF}пусто\n\n{00FF00}В клане:\n{FFFFFF}пусто\n{FFFFFF}пусто\n{FFFFFF}пусто\n\n","Ок","");
			}
			if(listitem == 3)
			{
				ShowPlayerDialog(playerid, 1028,DIALOG_STYLE_MSGBOX,"{FFFF66}Клан пусто:","{0066FF}Основатель клана:\n{FFFFFF}пусто\n\n{00FF00}В клане:\n{FFFFFF}пусто\n{FFFFFF}пусто\n{FFFFFF}пусто\n\n","Ок","");
			}

   		}
   		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "{0099FF}>>Тюнинг Авто\n{FFFF00}>>Перевернуть Авто\n{99CC66}>>Меню Телепортов\n{99CC66}>>{15ff00}ДеадМатчи\n{FF0000}>>Создатели Мода\n{00FF00}>>Автомобили\n{FFFF00}>>MP3-Плеер\n{FF3300}>>Отсчёт\n{FFA500}>>Управление авто\n{1E90FF}>>Помощь\n{FFFFFF}>>Официальные {FF0000}Банды\n{00FFFF}>>*{00FF00}Оружие{00FFFF}*\n>>Управление персонажем\n{00FFFF}>>Анимации\n{FFFF00}>>Сброс Очков\n{00FA9A}>>Смена цвета ника", "Выбрать", "Выход");
   }

   if(dialogid == 16)//anim dance
   {
		if(response)
  		{
  			if(listitem == 0)
			{
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE1);
    	        SendClientMessage(playerid, 0xFFFFFFAA, "Стиль - 1 ;D");
		    }
            if(listitem == 1)
			{
		        SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE2);
                SendClientMessage(playerid, 0xFFFFFFAA, "Стиль - 2 ;D");
		    }
             if(listitem == 2)
			{
			    SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE3);
    	        SendClientMessage(playerid, 0xFFFFFFAA, "Стиль - 3 ;D");
			}
            if(listitem == 3)
			{
		       SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE4);
    	       SendClientMessage(playerid, 0xFFFFFFAA, "Танец шлюхи - 4 ;D");
		    }
            if(listitem == 4)
			{
			   SetPlayerSpecialAction (playerid, SPECIAL_ACTION_HANDSUP);
    	       SendClientMessage(playerid, 0xFFFFFFAA, "Я здаюсь уёбки!");
		    }
      		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		}
		else ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "{33FFFF}Меню Анимации", "{99FF33}Напитки и Cигареты\n{99FF33}Танцевать\n{99FF33}Звонить\n{99FF33}Остановить анимацию", "OK", "Назад");
	}

 	if(dialogid == 60)//Телепорты 2
	{
		if(response)
		{

			if(listitem == 0)
			{
			    SetPlayerPos(playerid,1784.7914,-1118.2589,84.4766);
				SetPlayerFacingAngle(playerid,91.2318);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Deagle DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Deagle DM");
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid,24,99999);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				return 1;
			}
			if(listitem == 1)
			{
			    SetPlayerPos(playerid,-1753.9039,792.2205,167.6563);
				SetPlayerFacingAngle(playerid,175.5191);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Shotgun DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Shotgun DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,25,99999);
				return 1;
			}
			if(listitem == 2)
			{
			    SetPlayerPos(playerid,-573.2476,2594.3606,65.8368);
				SetPlayerFacingAngle(playerid,267.3033);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Deagle+Shot DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Deagle+Shot DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,25,99999);
				GivePlayerWeapon(playerid,24,99999);
				return 1;
			}
			if(listitem == 3)
			{
			    SetPlayerPos(playerid,-1776.4392,576.1358,234.8906);
				SetPlayerFacingAngle(playerid,114.4186);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на M4 DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на M4 DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,31,99999);
				return 1;
			}
			if(listitem == 4)
			{
			    SetPlayerPos(playerid,-1848.9814,1062.0646,145.1297);
				SetPlayerFacingAngle(playerid,274.5101);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на M5 DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на M5 DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,29,99999);
				return 1;
			}
			if(listitem == 5)
		 	{
			    SetPlayerPos(playerid,207.2202,-41.2427,10.0644);
				SetPlayerFacingAngle(playerid,186.8460);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Sawn DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Sawn DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,26,99999);
				return 1;
			}
			if(listitem == 6)
		 	{
			 	SetPlayerPos(playerid,295.4582,-1610.4799,114.4219);
				SetPlayerFacingAngle(playerid,86.8917);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Chainsaw DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Chainsaw DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,9,99999);
				return 1;
			}
				if(listitem == 7)
			{

				SetPlayerPos(playerid,-1393.8346,494.6871,19.5001);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Area 9 DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Area 9 DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,33,99999);
				GivePlayerWeapon(playerid,30,99999);
				GivePlayerWeapon(playerid,24,99999);
				return 1;
			}
				if(listitem == 8)
			{
			    SetPlayerPos(playerid,2578.2263,1343.5131,78.4764);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Tec 9 DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Tec 9 DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,32,99999);
				return 1;
			}
				if(listitem == 9)
			{
			    SetPlayerPos(playerid,2147.8677,-76.6750,2.9725);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Пляж DM (/DM)", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Пляж 9 DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
			    GivePlayerWeapon(playerid,31,99999);
			    GivePlayerWeapon(playerid,26,99999);
			    GivePlayerWeapon(playerid,28,99999);
			    GivePlayerWeapon(playerid,22,99999);
				return 1;
			}
				if(listitem == 10)
			{
                SetPlayerPos(playerid,-9.6049,1560.5602,12.7632);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				new string[256];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Counter Strike", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Counter Strike");
				ResetPlayerWeapons(playerid);
				ResetPlayerWeapons(playerid);
		        SetPlayerInterior(playerid, 0);
	            GivePlayerWeapon(playerid, 34, 40);
	            GivePlayerWeapon(playerid, 4, 0);
	            GivePlayerWeapon(playerid, 16, 1);
	            GivePlayerWeapon(playerid, 24, 42);
                GivePlayerWeapon(playerid, 30, 120);
	            SetPlayerArmour(playerid,20);
	            SetPlayerHealth(playerid,20.0);
				return 1;
			}
		
   		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "{0099FF}>>Тюнинг Авто\n{FFFF00}>>Перевернуть Авто\n{99CC66}>>Меню Телепортов\n{99CC66}>>{15ff00}ДеадМатчи\n{FF0000}>>Создатели Мода\n{00FF00}>>Автомобили\n{FFFF00}>>MP3-Плеер\n{FF3300}>>Отсчёт\n{FFA500}>>Управление авто\n{1E90FF}>>Помощь\n{FFFFFF}>>Официальные {FF0000}Банды\n{00FFFF}>>*{00FF00}Оружие{00FFFF}*\n>>Управление персонажем\n{00FFFF}>>Анимации\n{FFFF00}>>Сброс Очков\n{00FA9A}>>Смена цвета ника", "Выбрать", "Выход");
   }

	if(dialogid == 17)//Звонки
 	{
  		if(response)
    	{
  			if(listitem == 0)
			{
			   SetPlayerSpecialAction (playerid, SPECIAL_ACTION_USECELLPHONE);
    	       SendClientMessage(playerid, 0xFFFFFFAA, "Алё?");
               GivePlayerMoney(playerid,-50);
		    }
            if(listitem == 1)
			{
		        SetPlayerDrunkLevel(playerid, 2323000);
	            SendClientMessage(playerid, 0xFFFFFFAA, "OMG Ты напился в стельку!(чтобы снять эффект выберите (Остановить анимацию)");
		    }
		    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
      	}
      	else ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "{33FFFF}Меню Анимации", "{99FF33}Напитки и Cигареты\n{99FF33}Танцевать\n{99FF33}Звонить\n{99FF33}Остановить анимацию", "OK", "Назад");
	}

	if(dialogid == 14)//vinils
 	{
  		if(response)
    	{
		    new vehicleid = GetPlayerVehicleID(playerid);
			ChangeVehiclePaintjob(vehicleid,listitem+1);
		    PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
			ShowPlayerDialog(playerid, 14, DIALOG_STYLE_LIST, "Выбор винила", "Винил №1 \nВинил №2 \nВинил №3 ", "ОК", "Назад");
		}
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "{FFFF00}>>Диски \n{4b0082}>>Гидравлика\n{ffd700}>>Архангел Тюнинг \n{42aaff}>>Цвет \n{ff0000}>>Винилы ", "Выбрать", "Назад");
	 }

 	if(dialogid == 12)//WAA tune
 	{
  		if(response)
    	{
  			if(listitem == 0)// x front
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1172);
				if(cartype == 560)AddVehicleComponent(vehicleid,1170);
				if(cartype == 565)AddVehicleComponent(vehicleid,1152);
				if(cartype == 559)AddVehicleComponent(vehicleid,1173);
				if(cartype == 561)AddVehicleComponent(vehicleid,1157);
				if(cartype == 558)AddVehicleComponent(vehicleid,1165);

				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}

			if(listitem == 1)//alien front
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1171);
				if(cartype == 560)AddVehicleComponent(vehicleid,1169);
				if(cartype == 565)AddVehicleComponent(vehicleid,1153);
				if(cartype == 559)AddVehicleComponent(vehicleid,1160);
				if(cartype == 561)AddVehicleComponent(vehicleid,1155);
				if(cartype == 558)AddVehicleComponent(vehicleid,1166);

				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}

			if(listitem == 2)//x rear
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1148);
				if(cartype == 560)AddVehicleComponent(vehicleid,1140);
				if(cartype == 565)AddVehicleComponent(vehicleid,1151);
				if(cartype == 559)AddVehicleComponent(vehicleid,1161);
				if(cartype == 561)AddVehicleComponent(vehicleid,1156);
				if(cartype == 558)AddVehicleComponent(vehicleid,1167);

				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}

			if(listitem == 3)//alien rear
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1149);
				if(cartype == 560)AddVehicleComponent(vehicleid,1141);
				if(cartype == 565)AddVehicleComponent(vehicleid,1150);
				if(cartype == 559)AddVehicleComponent(vehicleid,1159);
				if(cartype == 561)AddVehicleComponent(vehicleid,1154);
				if(cartype == 558)AddVehicleComponent(vehicleid,1168);

				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}

			if(listitem == 4)//x spoiler
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1146);
				if(cartype == 560)AddVehicleComponent(vehicleid,1139);
				if(cartype == 565)AddVehicleComponent(vehicleid,1050);
				if(cartype == 559)AddVehicleComponent(vehicleid,1158);
				if(cartype == 561)AddVehicleComponent(vehicleid,1160);
				if(cartype == 558)AddVehicleComponent(vehicleid,1163);

				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}
			if(listitem == 5)//alien spoiler
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1147);
				if(cartype == 560)AddVehicleComponent(vehicleid,1138);
				if(cartype == 565)AddVehicleComponent(vehicleid,1049);
				if(cartype == 559)AddVehicleComponent(vehicleid,1162);
				if(cartype == 561)AddVehicleComponent(vehicleid,1058);
				if(cartype == 558)AddVehicleComponent(vehicleid,1164);

				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}
			if(listitem == 6)//x side
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)
				{
					AddVehicleComponent(vehicleid,1041);
					AddVehicleComponent(vehicleid,1039);
				}
				if(cartype == 560)
				{
					AddVehicleComponent(vehicleid,1031);
					AddVehicleComponent(vehicleid,1030);
				}
				if(cartype == 565)
				{
					AddVehicleComponent(vehicleid,1052);
					AddVehicleComponent(vehicleid,1048);
				}
				if(cartype == 559)
				{
					AddVehicleComponent(vehicleid,1070);
					AddVehicleComponent(vehicleid,1072);
				}
				if(cartype == 561)
				{
					AddVehicleComponent(vehicleid,1057);
					AddVehicleComponent(vehicleid,1063);
				}
				if(cartype == 558)
				{
					AddVehicleComponent(vehicleid,1093);
                	AddVehicleComponent(vehicleid,1095);
				}

				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}

			if(listitem == 7)//alien side
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)
				{
					AddVehicleComponent(vehicleid,1036);
					AddVehicleComponent(vehicleid,1040);
				}
				if(cartype == 560)
				{
					AddVehicleComponent(vehicleid,1026);
					AddVehicleComponent(vehicleid,1027);
				}
				if(cartype == 565)
				{
					AddVehicleComponent(vehicleid,1051);
					AddVehicleComponent(vehicleid,1047);
				}
				if(cartype == 559)
				{
					AddVehicleComponent(vehicleid,1069);
					AddVehicleComponent(vehicleid,1071);
				}
				if(cartype == 561)
				{
					AddVehicleComponent(vehicleid,1056);
					AddVehicleComponent(vehicleid,1062);
				}
				if(cartype == 558)
				{
					AddVehicleComponent(vehicleid,1090);
                	AddVehicleComponent(vehicleid,1094);
				}

				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}

			if(listitem == 8)//x roof
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1035);
				if(cartype == 560)AddVehicleComponent(vehicleid,1033);
				if(cartype == 565)AddVehicleComponent(vehicleid,1052);
				if(cartype == 559)AddVehicleComponent(vehicleid,1068);
				if(cartype == 561)AddVehicleComponent(vehicleid,1061);
				if(cartype == 558)AddVehicleComponent(vehicleid,1091);

            	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}

			if(listitem == 9)//alien roof
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1038);
				if(cartype == 560)AddVehicleComponent(vehicleid,1032);
				if(cartype == 565)AddVehicleComponent(vehicleid,1054);
				if(cartype == 559)AddVehicleComponent(vehicleid,1067);
				if(cartype == 561)AddVehicleComponent(vehicleid,1055);
				if(cartype == 558)AddVehicleComponent(vehicleid,1088);

	            PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}
			if(listitem == 10)//x echaust
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1037);
				if(cartype == 560)AddVehicleComponent(vehicleid,1029);
				if(cartype == 565)AddVehicleComponent(vehicleid,1045);
				if(cartype == 559)AddVehicleComponent(vehicleid,1066);
				if(cartype == 561)AddVehicleComponent(vehicleid,1059);
				if(cartype == 558)AddVehicleComponent(vehicleid,1089);

                PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}
            if(listitem == 11)//alien echaust
			{
    			new vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);

				if(cartype == 562)AddVehicleComponent(vehicleid,1034);
				if(cartype == 560)AddVehicleComponent(vehicleid,1028);
				if(cartype == 565)AddVehicleComponent(vehicleid,1046);
				if(cartype == 559)AddVehicleComponent(vehicleid,1065);
				if(cartype == 561)AddVehicleComponent(vehicleid,1064);
				if(cartype == 558)AddVehicleComponent(vehicleid,1092);

                PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
			}
 		}
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "{FFFF00}>>Диски \n{4b0082}>>Гидравлика\n{ffd700}>>Архангел Тюнинг \n{42aaff}>>Цвет \n{ff0000}>>Винилы ", "Выбрать", "Назад");
		return 1;
	}


	if(dialogid == 10)//skins
	{
		if(response)
		{
			if(strval(inputtext) >= 0 && strval(inputtext) <= 300)
			{
	  			SetPlayerSkin(playerid,strval(inputtext));
	  			PlayerPlaySound(playerid,1150,0.0,0.0,0.0);
			}
		}
		else ShowPlayerDialog(playerid, 10, DIALOG_STYLE_INPUT, "Смена скина", "Введите ID", "OK", "назад");
	}

	if(dialogid == 5)
   	{
		if(response)
  		{
 			if(listitem == 0)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -325.1331,1533.0276,75.3594);
			 	else SetPlayerPos(playerid, -325.1331,1533.0276,75.3594);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Большое Ухо");
				return 1;
			}

			if(listitem == 1)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2207.1196,-991.9159,36.8409);
		 		else SetPlayerPos(playerid, -2207.1196,-991.9159,36.8409);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Холм SF");
				return 1;
			}

			if(listitem == 2)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 324.342163,-1841.188354,3.574475);
			 	else SetPlayerPos(playerid, 324.342163,-1841.188354,3.574475);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать в Аквапарк");
				return 1;
			}

			if(listitem == 3)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2310.0208,-1654.1530,483.6927);
			 	else SetPlayerPos(playerid, -2310.0208,-1654.1530,483.6927);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Гору ");
				return 1;
			}

			if(listitem == 4)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -113.16453552,583.32196045,3.14548969);
			 	else SetPlayerPos(playerid, -113.16453552,583.32196045,3.14548969);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Форт Карсон");
				return 1;
			}

			if(listitem == 5)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1685.10925293,944.96972656,10.53941059);
		 		else SetPlayerPos(playerid, 1685.10925293,944.96972656,10.53941059);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Дрифт Парковку");
				return 1;
			}

			if(listitem == 6)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1574.58410645,713.25219727,10.66216087);
			 	else SetPlayerPos(playerid, 1574.58410645,713.25219727,10.66216087);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Склад-симметрия");
				return 1;
			}

			if(listitem == 7)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1668, -240,14.010653495789);
			 	else SetPlayerPos(playerid, -1668, -240, 15.0);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Драг 1");
				return 1;
			}

			if(listitem == 8)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1195.292114,16.669136,14.148437);
			 	else SetPlayerPos(playerid, -1195.292114,16.669136,14.148437);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Драг 2");
				return 1;
			}

			if(listitem == 9)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 2710.8738, 1329.6749, 7.4631);
			 	else SetPlayerPos(playerid, 2710.8738, 1329.6749, 7.4631);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Драг 3 ");
				return 1;
			}
			if(listitem == 10)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1670.05, 530.93, 37.97);
			 	else SetPlayerPos(playerid, -1670.05, 530.93, 37.97);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Драг 4");
				return 1;
			}

			if(listitem == 11)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2143.2683,1038.7053,79.8516);
			 	else SetPlayerPos(playerid, -2143.2683,1038.7053,79.8516);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Драг 5");
				return 1;
			}

			if(listitem == 12)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1261.6563,-2010.9485,59.3726);
			 	else SetPlayerPos(playerid, 1261.6563,-2010.9485,59.3726);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Дрифт 1");
				return 1;
			}

			if(listitem == 13)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1662.8085,268.1893,7.1875);
			 	else SetPlayerPos(playerid, -1662.8085,268.1893,7.1875);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Дрифт 2");
				return 1;
			}

			if(listitem == 14)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 2327.1482,1389.1229,42.8203);
			 	else SetPlayerPos(playerid, 2327.1482,1389.1229,42.8203);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Дрифт 3");
				return 1;
			}

			if(listitem == 15)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1539.0199,1146.5350,7.1875);
			 	else SetPlayerPos(playerid, -1539.0199,1146.5350,7.1875);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Дрифт 4");
				return 1;
			}

			if(listitem == 16)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2994.6130,2577.9629,4.1609);
			 	else SetPlayerPos(playerid, -2994.6130,2577.9629,4.1609);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Дрифт 5");
				return 1;
			}

			if(listitem == 17)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 3087.1345,-3194.6936,47.6537);
			 	else SetPlayerPos(playerid, 3087.1345,-3194.6936,47.6537);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Дрифт 6!");
				return 1;
			}

			if(listitem == 18)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 942.8232,1498.8528,175.5703);
			 	else SetPlayerPos(playerid, 942.8232,1498.8528,175.5703);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Дрифт 7");
				return 1;
			}
			
			if(listitem == 19)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -130.99,-1633.11,3.38);
			 	else SetPlayerPos(playerid, -130.99,-1633.11,3.38);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Городок");
				return 1;
			}
			
			if(listitem == 20)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 406.1716,2442.7126,16.5000);
			 	else SetPlayerPos(playerid, 406.1716,2442.7126,16.5000);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Заброшку");
				return 1;
			}
			
			if(listitem == 21)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1609.0588,1170.6176,14.2188);
			 	else SetPlayerPos(playerid, 1609.0588,1170.6176,14.2188);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Стант ЛВ");
				return 1;
			}
			
			if(listitem == 22)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 804.8349,-2381.7952,12.9593);
			 	else SetPlayerPos(playerid, 804.8349,-2381.7952,12.9593);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на Парковку");
				return 1;
			}
			
			if(listitem == 23)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -4402.8853, 1753.8873, 23.6262);
			 	else SetPlayerPos(playerid, -4402.8853, 1753.8873, 23.6262);
				SendClientMessage(playerid, 0xFFD700AA,"{00ccff}Таз Дрифт™: {FFFF00}Добро пожаловать на MeGa-Stunt #1");
				return 1;
			}


		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "{0099FF}>>Тюнинг Авто\n{FFFF00}>>Перевернуть Авто\n{99CC66}>>Меню Телепортов\n{99CC66}>>{15ff00}ДеадМатчи\n{FF0000}>>Создатели Мода\n{00FF00}>>Автомобили\n{FFFF00}>>MP3-Плеер\n{FF3300}>>Отсчёт\n{FFA500}>>Управление авто\n{1E90FF}>>Помощь\n{FFFFFF}>>Официальные {FF0000}Банды\n{00FFFF}>>*{00FF00}Оружие{00FFFF}*\n>>Управление персонажем\n{00FFFF}>>Анимации\n{FFFF00}>>Сброс Очков\n{00FA9A}>>Смена цвета ника", "Выбрать", "Выход");
	}
	return 0;
}

public Check()
{
	for(new i=0;i<MAX_PLAYERS;i++)
	if(IsPlayerConnected(i))
	{
		m[i]+=1;
		if (m[i] > 59)
		{
 			h[i]++; m[i] = 0;
  			if(h[i] > 23) h[i] = 0;
		}

		if(GetSpeedKM(i)>300)
		{
			switch(GetVehicleModel(GetPlayerVehicleID(i)))
			{
			    case 0,592,577,511,512,593,520,553,476,519,460,513: printf("ID%d driving %d with velocity %skm",i,GetVehicleModel(GetPlayerVehicleID(i)),GetSpeedKM(i));
				default:
				{

				}
			}
		}
	}
}

public Countdown()
{
	for(new i=0;i<MAX_PLAYERS;i++)
	if(IsPlayerConnected(i))
	{
			if(countdown[i]>0)
			{
				countdown[i]-=1;
				new str[6];
				format(str,6,"...%d",countdown[i]);
				GameTextForPlayer(i,str,950,4);
				PlayerPlaySound(i,1056,0.0,0.0,0.0);
				if(countdown[i]<4)TogglePlayerControllable(i,0);
			}
			if(countdown[i]==0)
			{
			    TogglePlayerControllable(i,1);
				GameTextForPlayer(i,"~r~GO GO GO!",500,4);
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				countdown[i]=-1;
			}
	}
}


dcmd_dt(playerid, params[])
{
	new str[64];
	if (!strlen(params)) return SendClientMessage(playerid, 0xFFCC2299, "[Информация]: /dt [мир]"); //Grey colour
	if (strval(params) < 0) return SendClientMessage(playerid, 0xFFCC2299, "[Информация]: Число должно быть больше нуля"); //Grey colour
	new ii = strval(params);
	SetPlayerVirtualWorld(playerid,ii);
	format(str,64,"[INFO]: Ваш мир изменён на %d",ii);
	SendClientMessage(playerid, 0xFF8040AA,str); //Grey colour
	if(ii!=0)return SendClientMessage(playerid, 0xFFCC2299, ">>>[Информация]: Вы в режиме дрифт тренировки"); //Grey colour
	SendClientMessage(playerid, 0xFFCC2299, ">>>[Информация]: Режим дрифт тренировки выключен"); //Grey colour
	return 1;
}

stock GetSpeedKM(playerid)
{
  new
   Float:PosX,
   Float:PosY,
   Float:PosZ,
   Float:PlayerSpeedDistance;

   	GetVehicleVelocity(GetPlayerVehicleID(playerid), PosX, PosY, PosZ);
  	PlayerSpeedDistance = floatmul(floatsqroot(floatadd(floatadd(floatpower(PosX, 2), floatpower(PosY, 2)),  floatpower(PosZ, 2))), 170.0);
  	new spe = floatround(PlayerSpeedDistance * 1);
  	return spe;
}

//------------------------------------------------

stock strrest(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[128];
	while ((index < length) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    if(!success)
    {
        printf("Ошибка при входе с IP %s использование пароля %s",ip, password);
        new pip[16];
        for(new i=0; i<MAX_PLAYERS; i++)
        {
            GetPlayerIp(i, pip, sizeof(pip));
            if(!strcmp(ip, pip, true))
            {
                SendClientMessage(i, 0xFFFFFFFF, "Неверный пароль от rcon. Пожалуйста, больше так не делайте."); \
                Kick(i);
            }
        }
    }
    return 1;
}

public Reklama()
{
SendClientMessageToAll(COLOR_LIGHTBLUE,"Таз Дрифт™: {FFFF00}По вопросам покупки админки обращайтесь в {00FFFF}Skype:{FFFF00}Pro100_Drifter|{00FFFF}[B]контакте:{FFFF00}vk.com/pro_gamer_pro");
return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerUPD(playerid)
{
    if(GetTickCount() - armedbody_pTick[playerid] > 113){ //prefix check itter
		new
			weaponid[13],weaponammo[13],pArmedWeapon;
		pArmedWeapon = GetPlayerWeapon(playerid);
		GetPlayerWeaponData(playerid,1,weaponid[1],weaponammo[1]);
		GetPlayerWeaponData(playerid,2,weaponid[2],weaponammo[2]);
		GetPlayerWeaponData(playerid,4,weaponid[4],weaponammo[4]);
		GetPlayerWeaponData(playerid,5,weaponid[5],weaponammo[5]);
		GetPlayerWeaponData(playerid,7,weaponid[7],weaponammo[7]);
		if(weaponid[1] && weaponammo[1] > 0){
			if(pArmedWeapon != weaponid[1]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,0)){
					SetPlayerAttachedObject(playerid,0,GetWeaponModel(weaponid[1]),1, 0.199999, -0.139999, 0.030000, 0.500007, -115.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,0)){
					RemovePlayerAttachedObject(playerid,0);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,0)){
			RemovePlayerAttachedObject(playerid,0);
		}
		if(weaponid[2] && weaponammo[2] > 0){
			if(pArmedWeapon != weaponid[2]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,1)){
					SetPlayerAttachedObject(playerid,1,GetWeaponModel(weaponid[2]),8, -0.079999, -0.039999, 0.109999, -90.100006, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,1)){
					RemovePlayerAttachedObject(playerid,1);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,1)){
			RemovePlayerAttachedObject(playerid,1);
		}
		if(weaponid[4] && weaponammo[4] > 0){
			if(pArmedWeapon != weaponid[4]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,2)){
					SetPlayerAttachedObject(playerid,2,GetWeaponModel(weaponid[4]),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,2)){
					RemovePlayerAttachedObject(playerid,2);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,2)){
			RemovePlayerAttachedObject(playerid,2);
		}
		if(weaponid[5] && weaponammo[5] > 0){
			if(pArmedWeapon != weaponid[5]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,3)){
					SetPlayerAttachedObject(playerid,3,GetWeaponModel(weaponid[5]),1, 0.200000, -0.119999, -0.059999, 0.000000, 206.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,3)){
					RemovePlayerAttachedObject(playerid,3);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,3)){
			RemovePlayerAttachedObject(playerid,3);
		}
		if(weaponid[7] && weaponammo[7] > 0){
			if(pArmedWeapon != weaponid[7]){
				if(!IsPlayerAttachedObjectSlotUsed(playerid,4)){
					SetPlayerAttachedObject(playerid,4,GetWeaponModel(weaponid[7]),1,-0.100000, 0.000000, -0.100000, 84.399932, 112.000000, 10.000000, 1.099999, 1.000000, 1.000000);
				}
			}
			else {
				if(IsPlayerAttachedObjectSlotUsed(playerid,4)){
					RemovePlayerAttachedObject(playerid,4);
				}
			}
		}
		else if(IsPlayerAttachedObjectSlotUsed(playerid,4)){
			RemovePlayerAttachedObject(playerid,4);
		}
		armedbody_pTick[playerid] = GetTickCount();
	}
	return true;
}

//by Double-O-Seven
stock GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
	    case 1:
	        return 331;

		case 2..8:
		    return weaponid+331;

        case 9:
		    return 341;

		case 10..15:
			return weaponid+311;

		case 16..18:
		    return weaponid+326;

		case 22..29:
		    return weaponid+324;

		case 30,31:
		    return weaponid+325;

		case 32:
		    return 372;

		case 46:
		    return 371;
	}
	return 0;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
if(newstate == PLAYER_STATE_PASSENGER)
 {
   for(new i; i<111; i++)
   {
       if(GetVehicleModel(GetPlayerVehicleID(playerid))==CrashCars1[i]&&GetPlayerVehicleSeat(playerid) > 1)
       {
       Kick(playerid);
       }
   }

   for(new i; i<43; i++)
   {
       if(GetVehicleModel(GetPlayerVehicleID(playerid))==CrashCars2[i])
       {
       Kick(playerid);
       }
   }
 }

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == teleport)
    {

    }
    if(pickupid == teleport2)
    {

    }
    if(pickupid == teleport4)
{

}
if(pickupid == teleport3)
{

}
if(pickupid == teleport5)
{

}
if(pickupid == teleport6)
{

}
if(pickupid == teleport7)
{

}
if(pickupid == teleport8)
{

}
if(pickupid == teleport9)
{

}
if(pickupid == teleport10)
{

}
	return 1;
}
public LoadRecord()
{
    new strFromFile[24], arrCoords[6][5], File: file = fopen("porecords", io_read);
    if (file)
    {
        fread(file, strFromFile);
        split(strFromFile, arrCoords, ',');
        Precord = strval(arrCoords[0]);
        Drecord = strval(arrCoords[1]);
        Mrecord = strval(arrCoords[2]);
        Yrecord = strval(arrCoords[3]);
        THrecord = strval(arrCoords[4]);
        TMrecord = strval(arrCoords[5]);
        fclose(file);
    }
    return 1;
}
public SaveRecord()
{
    new coordsstring[24];
    format(coordsstring, sizeof(coordsstring), "%d,%d,%d,%d,%d,%d", Precord, Drecord, Mrecord, Yrecord, THrecord, TMrecord);
    new File: file = fopen("porecords", io_write);
    fwrite(file, coordsstring);
    fclose(file);
    return 1;
}
public ConnectedPlayers()
{
    new Connected;
    for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && !IsPlayerNPC(i)) Connected++;
    return Connected;
}

stock split(const strsrc[], strdest[][], delimiter)
{
    new i, li;
    new aNum;
    new len;
    while(i <= strlen(strsrc))
    {
        if(strsrc[i] == delimiter || i == strlen(strsrc))
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
    }

