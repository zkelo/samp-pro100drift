/*=========================Инклуды=========================*/
#include <a_samp>
#include <streamer>
#include <sscanf2>
#include <Dini>
#include <ini>
#include <time>
/*=========================Дефайны=========================*/
#define RBUTTON 0 //Right Button
#define LBUTTON 1 //Left Button
#define USERFILE_DIRECTION "Accounts/%s.acc"
#define MAX_LOG_TRIES 4
#define RegisterDialog 946
#define LoginDialog 945
#define RADIO 888
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_VERDEMILITARE 0x9ACD32AA
#define COLOR_DM 0x00A3F0AA  
#define COLOR_GRIGIO 0xAFAFAFAA          //Серый
#define COLOR_GRIGIOSCURO 0x5F5251AA     //Темно-серый
#define COLOR_VERDECHIARO 0x81F628AA     //Светло-зеленый
#define COLOR_GIALLO 0xFFFF00AA          //Желтый
#define COLOR_BLU 0x0050F6AA             //(Фиг знает может синий а может и нет)
#define COLOR_VERDE 0x33AA33AA           //Зеленый
#define COLOR_NERO 0x000000AA            //Черный
#define COLOR_BLUCHIARO 0x33CCFFAA       //синий
#define COLOR_MARRONE 0x663300AA         //Браун
#define COLOR_VIOLA 0x990099AA           //Пурпурный
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_GREEN 0x00FF00AA
#define COLOR_RED 0xFF0000AA
#define SLOT 1
#define MAX_HOUSES 1000
#define COLOR_ORANGE 0xFF9900AA
#define ADMINFS_MESSAGE_COLOR 0xFF444499
#define PM_INCOMING_COLOR     0xFFFF22AA
#define PM_OUTGOING_COLOR     0xFFCC2299
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define MAX_IP 2
#define DERBY 39
/*=========================Переменные=========================*/
//=========================Спидометр=========================//
new
Text:speedom[122],
Text:mysp[16],
Float:ST[4],
spedom[MAX_PLAYERS];
//===================================================//
new Text:Clock;
new ta4ka[MAX_PLAYERS];
new ta4katest[MAX_PLAYERS];
new neon[MAX_PLAYERS][2];
new countdown[MAX_PLAYERS];
new dives[MAX_PLAYERS];
new bool:lmec[MAX_PLAYERS];
//=====================Регистрация===========================//
enum pVariableData
{
	pSkin,
	pKills, pDeaths,
	gPlayerLogged,
	gLogTries
}
new pData[MAX_PLAYERS][pVariableData];
//==========================================================//
//***=========================Место Spawn Игрока=========================***//
new Float:RandomSpawn[][4] = {
	{2540.6499,-1460.9518,24.0276},
	{2180.6038,-2272.9414,13.4850},
	{1768.48999023,-1890.65979004,13.26507759},
	{1803.05432129,-1927.93017578,12.96369362},
	{2686.23901367,-1687.44445801,9.43534851},
	{2306.79736328,-1667.30126953,14.55416298},
	{1618.42761230,-1136.30419922,23.90625000},
	{1244.02990723,-749.27777100,94.37997437},
	{-304.69631958,1574.84655762,75.35937500},
	{-679.18835449,949.61035156,12.13281250},
	{-1583.23474121,813.13385010,6.82031250},
	{-1975.12548828,259.89416504,35.17187500},
	{-2027.33947754,-96.44725800,35.16406250}
};
/*=========================Форварды=========================*/
forward ClockSync(playerid);
forward RandomPlayerScreen(playerid);
forward OnPlayerUpdateEx(playerid);
forward OnPlayerLogin(playerid, pass[]);
forward OnPlayerRegister(playerid, pass[]);
forward Countdown();
forward Check();
forward Check2();
forward Check3();
forward AutoRepair();
forward AutoFlip();
forward SpamMessage();
forward SpamMessage2();
forward settime(playerid);
/*=========================Инфо, при включении мода=========================*/
main(){ }
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
				SendClientMessage(i, 0x81F628AA, "Неверный пароль от rcon. Пожалуйста, больше так не делайте."); \
				Kick(i);
			}
		}
	}
	return 1;
}

public SpamMessage()
{

	SendClientMessageToAll(COLOR_LIGHTBLUE,"");
	SendClientMessageToAll(COLOR_LIGHTBLUE,"Тут крч реклама будет :D");
	SendClientMessageToAll(COLOR_LIGHTBLUE,"");
	return 0;

}

public SpamMessage2()
{

	SendClientMessageToAll(COLOR_LIGHTBLUE,"");
	SendClientMessageToAll(COLOR_LIGHTBLUE,"Тут крч реклама будет :D");
	SendClientMessageToAll(COLOR_LIGHTBLUE,"");
	

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
public OnGameModeInit()
{
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	SetGameModeText("Russian~Drift v1.3");//Имя мода
	UsePlayerPedAnims();
	SetTimer("Check",1000, true);//таймер для проверки
	SetTimer("Check2",1000, true);//таймер для проверки
	SetTimer("Check3",1000, true);
	SetTimer("SetName",10,0);
	SetTimer("Countdown",1000,1);//таймер отсчёта
	SetTimer("SpamMessage", 240000, 2);
	SetTimer("SpamMessage2",150000, 1);
	SetTimer("AutoRepair", 700, true);
	SendRconCommand("mapname Russia ¤ Россия");
	Clock = TextDrawCreate(547.000000,24.000000,"00:00");
	TextDrawAlignment(Clock,0);
	TextDrawBackgroundColor(Clock,0x000000ff);
	TextDrawFont(Clock,3);
	TextDrawLetterSize(Clock,0.6,1.9);
	TextDrawColor(Clock,0x00F6F6F6);
	TextDrawSetOutline(Clock,2);
	TextDrawSetProportional(Clock,1);
	TextDrawSetShadow(Clock,1);
	speedom[32] = TextDrawCreate(37.401531, 432.959899,".");
	TextDrawColor(speedom[32],0xffffffff);
	mysp[0] = TextDrawCreate(30,410,"0");
	TextDrawColor(mysp[0],0xffffffff);
	mysp[1] = TextDrawCreate(14,394,"20");
	TextDrawColor(mysp[1],0xCBFFBFff);
	mysp[2] = TextDrawCreate(8,375,"40");
	TextDrawColor(mysp[2],0x94FF7Dff);
	mysp[3] = TextDrawCreate(14,355,"60");
	TextDrawColor(mysp[3],0xB5FE63ff);
	mysp[4] = TextDrawCreate(26,336,"80");
	TextDrawColor(mysp[4],0xEBFE63ff);
	mysp[5] = TextDrawCreate(57,321,"100");
	TextDrawColor(mysp[5],0xFFE862ff);
	mysp[6] = TextDrawCreate(96,321,"120");
	TextDrawColor(mysp[6],0xFFD362ff);
	mysp[7] = TextDrawCreate(131,336,"140");
	TextDrawColor(mysp[7],0xFEB063ff);
	mysp[8] = TextDrawCreate(145,355,"160");
	TextDrawColor(mysp[8],0xFEA043ff);
	mysp[9] = TextDrawCreate(151,375,"180");
	TextDrawColor(mysp[9],0xFE7B43ff);
	mysp[10] = TextDrawCreate(145,394,"200");
	TextDrawColor(mysp[10],0xFE5A43ff);
	mysp[11] = TextDrawCreate(132,410,"220");
	TextDrawColor(mysp[11],0xFF2D2Dff);
	for(new i=0; i<12; i++)
	TextDrawAlignment(mysp[i],0),
	TextDrawBackgroundColor(mysp[i],0x00000022),
	TextDrawSetOutline(mysp[i],1),
	TextDrawSetProportional(mysp[i],1),
	TextDrawSetShadow(mysp[i],1),
	TextDrawFont(mysp[i],2),
	TextDrawLetterSize(mysp[i],0.3,1.1);
	mysp[12] = TextDrawCreate(88.5,380,"-");
	TextDrawAlignment(mysp[12],0),
	TextDrawLetterSize(mysp[12],3.5, 0.6),
	TextDrawBackgroundColor(mysp[12],0x00ff0022),
	TextDrawColor(mysp[12],0x00000099),
	TextDrawSetOutline(mysp[12],1),
	TextDrawSetProportional(mysp[2],1),
	TextDrawSetShadow(mysp[12],1),
	TextDrawFont(mysp[12],1);
	mysp[13] = TextDrawCreate(48,380,"-");
	TextDrawAlignment(mysp[13],0),
	TextDrawLetterSize(mysp[13],3.5, 0.6),
	TextDrawBackgroundColor(mysp[13],0x00ff0022),
	TextDrawColor(mysp[13],0x00000099),
	TextDrawSetOutline(mysp[13],1),
	TextDrawSetProportional(mysp[13],1),
	TextDrawSetShadow(mysp[13],1),
	TextDrawFont(mysp[13],1);
	mysp[14] = TextDrawCreate(86.7,254,"-");
	TextDrawAlignment(mysp[14],0),
	TextDrawLetterSize(mysp[14],0.10, 20),
	TextDrawBackgroundColor(mysp[14],0x00ff0022),
	TextDrawColor(mysp[14],0x00000088),
	TextDrawSetOutline(mysp[14],1),
	TextDrawSetProportional(mysp[14],1),
	TextDrawSetShadow(mysp[14],1),
	TextDrawFont(mysp[14],1);
	mysp[15] = TextDrawCreate(86.7,285,"-");
	TextDrawAlignment(mysp[15],0),
	TextDrawLetterSize(mysp[15],0.10, 20),
	TextDrawBackgroundColor(mysp[15],0x00ff0022),
	TextDrawColor(mysp[15],0x00000088),
	TextDrawSetOutline(mysp[15],1),
	TextDrawSetProportional(mysp[15],1),
	TextDrawSetShadow(mysp[15],1),
	TextDrawFont(mysp[15],1);
	speedom[0] = TextDrawCreate(35.324634, 430.428039,".");
	TextDrawColor(speedom[0],0xffffffff);
	speedom[1] = TextDrawCreate(33.430648, 427.784698,".");
	TextDrawColor(speedom[1],0xffffffff);
	speedom[2] = TextDrawCreate(31.862686, 425.281860,".");
	TextDrawColor(speedom[2],0xffffffff);
	speedom[3] = TextDrawCreate(30.776248, 423.329376,".");
	TextDrawColor(speedom[3],0xffffffff);
	speedom[4] = TextDrawCreate(29.404899, 420.520385,".");
	TextDrawColor(speedom[4],0xCBFFBFff);
	speedom[5] = TextDrawCreate(28.617698, 418.673034,".");
	TextDrawColor(speedom[5],0xCBFFBFff);
	speedom[6] = TextDrawCreate(27.498638, 415.608367,".");
	TextDrawColor(speedom[6],0xCBFFBFff);
	speedom[7] = TextDrawCreate(26.861858, 413.517364,".");
	TextDrawColor(speedom[7],0xCBFFBFff);
	speedom[8] = TextDrawCreate(26.108127, 410.468261,".");
	TextDrawColor(speedom[8],0xCBFFBFff);
	speedom[9] = TextDrawCreate(25.531257, 407.269378,".");
	TextDrawColor(speedom[9],0x94FF7Dff);
	speedom[10] = TextDrawCreate(25.234642, 404.838317,".");
	TextDrawColor(speedom[10],0xB0FA5Fff);
	speedom[11] = TextDrawCreate(25.036220, 401.902801,".");
	TextDrawColor(speedom[11],0xB0FA5Fff);
	speedom[12] = TextDrawCreate(25.000000, 399.998657,".");
	TextDrawColor(speedom[12],0xB0FA5Fff);
	speedom[13] = TextDrawCreate(25.095291, 396.914550,".");
	TextDrawColor(speedom[13],0xB0FA5Fff);
	speedom[14] = TextDrawCreate(25.267501, 394.834869,".");
	TextDrawColor(speedom[14],0xB0FA5Fff);
	speedom[15] = TextDrawCreate(25.720287, 391.543640,".");
	TextDrawColor(speedom[15],0xB0FA5Fff);
	speedom[16] = TextDrawCreate(26.200008, 389.111450,".");
	TextDrawColor(speedom[16],0xB0FA5Fff);
	speedom[17] = TextDrawCreate(26.535270, 387.704895,".");
	TextDrawColor(speedom[17],0xB0FA5Fff);
	speedom[18] = TextDrawCreate(27.115295, 385.610595,".");
	TextDrawColor(speedom[18],0xB0FA5Fff);
	speedom[19] = TextDrawCreate(27.573451, 384.165771,".");
	TextDrawColor(speedom[19],0xB0FA5Fff);
	speedom[20] = TextDrawCreate(28.353984, 381.995849,".");
	TextDrawColor(speedom[20],0xD3FB5Eff);
	speedom[21] = TextDrawCreate(29.110584, 380.146484,".");
	TextDrawColor(speedom[21],0xD3FB5Eff);
	speedom[22] = TextDrawCreate(30.003578, 378.198120,".");
	TextDrawColor(speedom[22],0xD3FB5Eff);
	speedom[23] = TextDrawCreate(30.943103, 376.357025,".");
	TextDrawColor(speedom[23],0xD3FB5Eff);
	speedom[24] = TextDrawCreate(31.610439, 375.153564,".");
	TextDrawColor(speedom[24],0xD3FB5Eff);
	speedom[25] = TextDrawCreate(32.650913, 373.418884,".");
	TextDrawColor(speedom[25],0xD3FB5Eff);
	speedom[26] = TextDrawCreate(33.421348, 372.229217,".");
	TextDrawColor(speedom[26],0xD3FB5Eff);
	speedom[27] = TextDrawCreate(34.611717, 370.524810,".");
	TextDrawColor(speedom[27],0xD3FB5Eff);
	speedom[28] = TextDrawCreate(35.456802, 369.400390,".");
	TextDrawColor(speedom[28],0xD3FB5Eff);
	speedom[29] = TextDrawCreate(36.784107, 367.758026,".");
	TextDrawColor(speedom[29],0xD3FB5Eff);
	speedom[30] = TextDrawCreate(38.190975, 366.160736,".");
	TextDrawColor(speedom[30],0xE4FC5Cff);
	speedom[31] = TextDrawCreate(39.222682, 365.071746,".");
	TextDrawColor(speedom[31],0xE4FC5Cff);
	speedom[33] = TextDrawCreate(40.596107, 363.718170,".");
	TextDrawColor(speedom[33],0xE4FC5Cff);
	speedom[34] = TextDrawCreate(41.608734, 362.784088,".");
	TextDrawColor(speedom[34],0xE4FC5Cff);
	speedom[35] = TextDrawCreate(43.259990, 361.366180,".");
	TextDrawColor(speedom[35],0xE4FC5Cff);
	speedom[36] = TextDrawCreate(44.814285, 360.139953,".");
	TextDrawColor(speedom[36],0xE4FC5Cff);
	speedom[37] = TextDrawCreate(46.029258, 359.248352,".");
	TextDrawColor(speedom[37],0xE4FC5Cff);
	speedom[38] = TextDrawCreate(47.527160, 358.223907,".");
	TextDrawColor(speedom[38],0xE4FC5Cff);
	speedom[39] = TextDrawCreate(48.674690, 357.491424,".");
	TextDrawColor(speedom[39],0xE4FC5Cff);
	speedom[40] = TextDrawCreate(50.482131, 356.423919,".");
	TextDrawColor(speedom[40],0xF4FD5Bff);
	speedom[41] = TextDrawCreate(51.687698, 355.767242,".");
	TextDrawColor(speedom[41],0xF4FD5Bff);
	speedom[42] = TextDrawCreate(53.342453, 354.933929,".");
	TextDrawColor(speedom[42],0xF4FD5Bff);
	speedom[43] = TextDrawCreate(54.511066, 354.390747,".");
	TextDrawColor(speedom[43],0xF4FD5Bff);
	speedom[44] = TextDrawCreate(56.331035, 353.616058,".");
	TextDrawColor(speedom[44],0xF4FD5Bff);
	speedom[45] = TextDrawCreate(57.556175, 353.141571,".");
	TextDrawColor(speedom[45],0xF4FD5Bff);
	speedom[46] = TextDrawCreate(59.383964, 352.501159,".");
	TextDrawColor(speedom[46],0xF4FD5Bff);
	speedom[47] = TextDrawCreate(60.627845, 352.110107,".");
	TextDrawColor(speedom[47],0xF4FD5Bff);
	speedom[48] = TextDrawCreate(62.537475, 351.578063,".");
	TextDrawColor(speedom[48],0xF4FD5Bff);
	speedom[49] = TextDrawCreate(64.620719, 351.089172,".");
	TextDrawColor(speedom[49],0xF4FD5Bff);
	speedom[49] = TextDrawCreate(65.886276, 350.837615,".");
	TextDrawColor(speedom[49],0xF4FD5Bff);
	speedom[50] = TextDrawCreate(66.909934, 350.658843,".");
	TextDrawColor(speedom[50],0xFDF15Bff);
	speedom[51] = TextDrawCreate(67.868965, 350.511138,".");
	TextDrawColor(speedom[51],0xFDF15Bff);
	speedom[52] = TextDrawCreate(68.636573, 350.406585,".");
	TextDrawColor(speedom[52],0xFDF15Bff);
	speedom[53] = TextDrawCreate(69.574790, 350.295196,".");
	TextDrawColor(speedom[53],0xFDF15Bff);
	speedom[54] = TextDrawCreate(70.186012, 350.232299,".");
	TextDrawColor(speedom[54],0xFDF15Bff);
	speedom[55] = TextDrawCreate(71.071029, 350.154602,".");
	TextDrawColor(speedom[55],0xFDF15Bff);
	speedom[56] = TextDrawCreate(72.028015, 350.088409,".");
	TextDrawColor(speedom[56],0xFDF15Bff);
	speedom[57] = TextDrawCreate(72.950660, 350.042022,".");
	TextDrawColor(speedom[57],0xFDF15Bff);
	speedom[58] = TextDrawCreate(73.908653, 350.011901,".");
	TextDrawColor(speedom[58],0xFDF15Bff);
	speedom[59] = TextDrawCreate(74.877418, 350.000152,".");
	TextDrawColor(speedom[59],0xFDF15Bff);
	speedom[60] = TextDrawCreate(75.529548, 350.002807,".");
	TextDrawColor(speedom[60],0xFDF15Bff);
	speedom[61] = TextDrawCreate(76.50307, 350.022583,".");
	TextDrawColor(speedom[61],0xFDF15Bff);
	speedom[62] = TextDrawCreate(77.154121, 350.046417,".");//350.046417
	TextDrawColor(speedom[62],0xFDDD5Bff);
	speedom[63] = TextDrawCreate(77.636695, 350.515754,".");
	TextDrawColor(speedom[63],0xFDDD5Bff);
	speedom[64] = TextDrawCreate(80.818321, 350.518463,".");
	TextDrawColor(speedom[64],0xFDDD5Bff);
	speedom[65] = TextDrawCreate(83.280525, 350.223236,".");
	TextDrawColor(speedom[65],0xFDDD5Bff);
	speedom[66] = TextDrawCreate(88.507255, 350.002563,".");
	TextDrawColor(speedom[66],0xFDDD5Bff);
	speedom[67] = TextDrawCreate(91.731109, 350.139404,".");
	TextDrawColor(speedom[67],0xFDDD5Bff);
	speedom[68] = TextDrawCreate(93.899375, 350.349243,".");
	TextDrawColor(speedom[68],0xFDDD5Bff);
	speedom[69] = TextDrawCreate(97.121894, 350.839141,".");
	TextDrawColor(speedom[69],0xFDDD5Bff);
	speedom[70] = TextDrawCreate(99.525985, 351.346618,".");
	TextDrawColor(speedom[70],0xFDDD5Bff);
	speedom[71] = TextDrawCreate(102.386077, 352.114288,".");
	TextDrawColor(speedom[71],0xFDDD5Bff);
	speedom[72] = TextDrawCreate(105.100166, 353.015075,".");
	TextDrawColor(speedom[72],0xFDC55Bff);
	speedom[73] = TextDrawCreate(107.222015, 353.842498,".");
	TextDrawColor(speedom[73],0xFDC55Bff);
	speedom[74] = TextDrawCreate(110.218063, 355.207611,".");
	TextDrawColor(speedom[74],0xFDC55Bff);
	speedom[75] = TextDrawCreate(111.976905, 356.123962,".");
	TextDrawColor(speedom[75],0xFDC55Bff);
	speedom[76] = TextDrawCreate(114.802116, 357.790435,".");
	TextDrawColor(speedom[76],0xFDC55Bff);
	speedom[77] = TextDrawCreate(117.422355, 359.573211,".");
	TextDrawColor(speedom[77],0xFDC55Bff);
	speedom[78] = TextDrawCreate(119.910507, 361.506896,".");
	TextDrawColor(speedom[78],0xFDC55Bff);
	speedom[79] = TextDrawCreate(122.429077, 363.742065,".");
	TextDrawColor(speedom[79],0xFDC55Bff);
	speedom[79] = TextDrawCreate(123.822807, 365.118408,".");
	TextDrawColor(speedom[79],0xFDC55Bff);
	speedom[80] = TextDrawCreate(125.720169, 367.179443,".");
	TextDrawColor(speedom[80],0xFDC55Bff);
	speedom[81] = TextDrawCreate(126.392639, 367.968688,".");
	TextDrawColor(speedom[81],0xFDB55Bff);
	speedom[82] = TextDrawCreate(127.487609, 369.328704,".");
	TextDrawColor(speedom[82],0xFDB55Bff);
	speedom[83] = TextDrawCreate(128.528839, 370.718383,".");
	TextDrawColor(speedom[83],0xFDB55Bff);
	speedom[84] = TextDrawCreate(129.195327, 371.663726,".");
	TextDrawColor(speedom[84],0xFDB55Bff);
	speedom[85] = TextDrawCreate(130.168090, 373.132690,".");
	TextDrawColor(speedom[85],0xFDB55Bff);
	speedom[85] = TextDrawCreate(130.760299, 374.085571,".");
	TextDrawColor(speedom[85],0xFDB55Bff);
	speedom[86] = TextDrawCreate(131.582199, 375.493011,".");
	TextDrawColor(speedom[86],0xFDB55Bff);
	speedom[87] = TextDrawCreate(132.427856, 377.061706,".");
	TextDrawColor(speedom[87],0xFDB55Bff);
	speedom[88] = TextDrawCreate(133.163421, 378.546203,".");
	TextDrawColor(speedom[88],0xFDB55Bff);
	speedom[89] = TextDrawCreate(133.883193, 380.132141,".");
	TextDrawColor(speedom[89],0xFD985Bff);
	speedom[90] = TextDrawCreate(134.401977, 381.375885,".");
	TextDrawColor(speedom[90],0xFD985Bff);
	speedom[91] = TextDrawCreate(135.010574, 382.970458,".");
	TextDrawColor(speedom[91],0xFD985Bff);
	speedom[92] = TextDrawCreate(135.570129, 384.602508,".");
	TextDrawColor(speedom[92],0xFD985Bff);
	speedom[93] = TextDrawCreate(136.047302, 386.163177,".");
	TextDrawColor(speedom[93],0xFD985Bff);
	speedom[93] = TextDrawCreate(136.494491, 387.822784,".");
	TextDrawColor(speedom[93],0xFD985Bff);
	speedom[94] = TextDrawCreate(136.873580, 389.446655,".");
	TextDrawColor(speedom[94],0xFD985Bff);
	speedom[95] = TextDrawCreate(137.115264, 390.635650,".");
	TextDrawColor(speedom[95],0xFD985Bff);
	speedom[96] = TextDrawCreate(137.389709, 392.211761,".");
	TextDrawColor(speedom[96],0xFD985Bff);
	speedom[97] = TextDrawCreate(137.621185, 393.856933,".");
	TextDrawColor(speedom[97],0xFD985Bff);
	speedom[98] = TextDrawCreate(137.800460, 395.537536,".");
	TextDrawColor(speedom[98],0xFD985Bff);
	speedom[99] = TextDrawCreate(137.923156, 397.228851,".");
	TextDrawColor(speedom[99],0xFD7B5Bff);
	speedom[100] = TextDrawCreate(137.976669, 398.472717,".");
	TextDrawColor(speedom[100],0xFD7B5Bff);
	speedom[101] = TextDrawCreate(137.999984, 400.037475,".");
	TextDrawColor(speedom[101],0xFD7B5Bff);
	speedom[102] = TextDrawCreate(137.986587, 401.157867,".");
	TextDrawColor(speedom[102],0xFD7B5Bff);
	speedom[103] = TextDrawCreate(137.919891, 402.829284,".");
	TextDrawColor(speedom[103],0xFD7B5Bff);
	speedom[104] = TextDrawCreate(137.842941, 403.959960,".");
	TextDrawColor(speedom[104],0xFD7B5Bff);
	speedom[105] = TextDrawCreate(137.687438, 405.581939,".");
	TextDrawColor(speedom[105],0xFD7B5Bff);
	speedom[106] = TextDrawCreate(137.546539, 406.718597,".");
	TextDrawColor(speedom[106],0xFD7B5Bff);
	speedom[107] = TextDrawCreate(137.307159, 408.294769,".");
	TextDrawColor(speedom[107],0xFD7B5Bff);
	speedom[108] = TextDrawCreate(137.116668, 409.357025,".");
	TextDrawColor(speedom[108],0xFD7B5Bff);
	speedom[109] = TextDrawCreate(136.795135, 410.910339,".");
	TextDrawColor(speedom[109],0xFD7B5Bff);
	speedom[110] = TextDrawCreate(136.549652, 411.955352,".");
	TextDrawColor(speedom[110],0xFB2D2Dff);
	speedom[111] = TextDrawCreate(136.123794, 413.568359,".");
	TextDrawColor(speedom[111],0xFB2D2Dff);
	speedom[112] = TextDrawCreate(135.673797, 415.073486,".");
	TextDrawColor(speedom[112],0xFB2D2Dff);
	speedom[113] = TextDrawCreate(135.333312, 416.110778,".");
	TextDrawColor(speedom[113],0xFB2D2Dff);
	speedom[114] = TextDrawCreate(134.806640, 417.582305,".");
	TextDrawColor(speedom[114],0xFB2D2Dff);
	speedom[115] = TextDrawCreate(134.434539, 418.542755,".");
	TextDrawColor(speedom[115],0xFB2D2Dff);
	speedom[116] = TextDrawCreate(133.800064, 420.058776,".");
	TextDrawColor(speedom[116],0xFB2D2Dff);
	speedom[117] = TextDrawCreate(133.344879, 421.067535,".");
	TextDrawColor(speedom[117],0xFB2D2Dff);
	speedom[118] = TextDrawCreate(132.881042, 422.038391,".");
	TextDrawColor(speedom[118],0xFB2D2Dff);
	speedom[119] = TextDrawCreate(132.206527, 423.361999,".");
	TextDrawColor(speedom[119],0xFB2D2Dff);
	speedom[120] = TextDrawCreate(131.400131, 424.827972,".");
	TextDrawColor(speedom[120],0xFB2D2Dff);
	speedom[121] = TextDrawCreate(131.301269, 425.000000,".");
	TextDrawColor(speedom[121],0xFB2D2Dff);
	for(new i=0; i<122; i++)
	TextDrawLetterSize(speedom[i], 0.73, -2.60),
	TextDrawSetOutline(speedom[i], 0),
	TextDrawSetShadow(speedom[i], 1),
	TextDrawSetOutline(speedom[i],1),
	TextDrawBackgroundColor(speedom[i],0x00000022);
	SetTimer("ClockSync", 1000, 1);
	AllowAdminTeleport(1);



	new rand = random(sizeof(RandomSpawn));	//Скины игроков!!!
	AddPlayerClass(292,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(293,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(107,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(29,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(299,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(28,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(21,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(101,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(138,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(154,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(167,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(48,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(179,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(181,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(268,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(269,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(270,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(271,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(272,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(283,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(284,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(285,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(286,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(287,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(255,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(256,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(257,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(258,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(259,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(260,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(261,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(262,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(263,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(264,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(274,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(275,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(276,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(1,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(2,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(290,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(291,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(292,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(293,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(294,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(295,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(296,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(297,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(298,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(299,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(277,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(278,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(279,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(288,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(47,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(48,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(49,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(50,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(51,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(52,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(53,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(54,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(55,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(56,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(57,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(58,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(59,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(60,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(61,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(62,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(63,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(64,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(66,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(67,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(68,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(69,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(70,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(71,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(72,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(73,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(75,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(76,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(78,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(79,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(80,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(81,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(82,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(83,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(84,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(85,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(87,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(88,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(89,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(91,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(92,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(93,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(95,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(96,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(97,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(98,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(99,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(100,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
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
	AddPlayerClass(111,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(112,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(113,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(114,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(115,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(116,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(117,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(118,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(120,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(121,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(122,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(123,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(124,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(125,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(126,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(127,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(128,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(129,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(131,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(133,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(134,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(135,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(136,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(137,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(138,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(139,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(140,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(141,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(142,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(143,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(144,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(145,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(146,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(147,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(148,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(150,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(151,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(152,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(153,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(154,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(155,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(156,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(157,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(158,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(159,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(160,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(161,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(162,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(163,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(164,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(165,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(166,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(167,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(168,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(169,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(170,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(171,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(172,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(173,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(174,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(175,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(176,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(177,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(178,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(179,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(180,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(181,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(182,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(183,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(184,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
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
	AddPlayerClass(196,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(197,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(198,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(199,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(200,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(201,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(202,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(203,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(204,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(205,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(206,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(207,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(209,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(210,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(211,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(212,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(213,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(214,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(215,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(216,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(217,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(218,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(219,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(220,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(221,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(222,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(223,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(224,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(225,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(226,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(227,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(228,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(229,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(230,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(231,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(232,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(233,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(234,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(235,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(236,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(237,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(238,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(239,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(240,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(241,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(242,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(243,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(244,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(245,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(246,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(247,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(248,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(249,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(250,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(251,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(253,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	//========================================Большое Ухо=========================================//
	CreateDynamicObject(970, -314.84174, 1511.37708, 75.03060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -319.67203, 1511.35876, 75.03060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -324.53329, 1511.36157, 75.03060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -329.43716, 1511.37000, 75.03060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -334.33975, 1511.36792, 75.03060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -339.17902, 1511.37415, 75.03060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -344.20633, 1511.34839, 75.03060,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -317.27872, 1511.24951, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -322.14749, 1511.24158, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -326.99197, 1511.23364, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -331.91089, 1511.24133, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -336.79092, 1511.23499, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -341.70673, 1511.24231, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -291.20279, 1513.05444, 75.03060,   0.00000, 0.00000, 43.00000);
	CreateDynamicObject(970, -287.21030, 1516.68640, 75.03060,   0.00000, 0.00000, 42.00000);
	CreateDynamicObject(970, -283.26782, 1520.20593, 75.03060,   0.00000, 0.00000, 42.00000);
	CreateDynamicObject(970, -279.37152, 1523.76624, 75.03060,   0.00000, 0.00000, 42.00000);
	CreateDynamicObject(970, -275.56403, 1527.28430, 75.03060,   0.00000, 0.00000, 43.00000);
	CreateDynamicObject(970, -271.85107, 1530.78381, 75.03060,   0.00000, 0.00000, 43.00000);
	CreateDynamicObject(970, -268.21912, 1534.23938, 75.03060,   0.00000, 0.00000, 43.00000);
	CreateDynamicObject(970, -264.45520, 1537.71411, 75.03060,   0.00000, 0.00000, 43.00000);
	CreateDynamicObject(1215, -289.18655, 1514.76953, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -285.20322, 1518.34424, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -281.26709, 1521.91956, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -277.41837, 1525.41125, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -273.65982, 1528.94373, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -269.98560, 1532.43066, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -266.28604, 1535.91296, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -262.58414, 1539.32336, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -260.02573, 1543.74890, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -260.79657, 1541.12097, 75.03060,   0.00000, 0.00000, 43.00000);
	CreateDynamicObject(970, -262.70645, 1546.39795, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(1215, -299.75308, 1583.48120, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -264.66318, 1548.42603, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, -266.78226, 1550.40259, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(970, -270.66214, 1554.24597, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(970, -274.49377, 1558.07568, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(970, -278.26773, 1561.88623, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(970, -282.19186, 1565.83167, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(970, -286.19397, 1569.82678, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(970, -290.06738, 1573.68311, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(970, -293.97940, 1577.59692, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(970, -297.86783, 1581.51501, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(970, -301.75937, 1585.39087, 75.03060,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(1215, -295.87756, 1579.59143, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -291.98840, 1575.67908, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -288.09293, 1571.81763, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -284.12897, 1567.92334, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -280.16211, 1563.89038, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -276.32962, 1560.05249, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -272.48260, 1556.20142, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -268.65149, 1552.42102, 75.03450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(983, -1186.00366, 1807.92493, 40.29050,   0.00000, 0.00000, -1.00000);
	CreateDynamicObject(983, -1186.38098, 1789.06836, 40.69050,   -4.00000, 0.00000, -1.00000);
	CreateDynamicObject(1215, -1186.15173, 1804.45178, 40.28810,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -1186.44983, 1792.56995, 40.28810,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -326.97208, 1594.80969, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -332.43726, 1589.90051, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -341.73239, 1580.40088, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -346.57318, 1575.28906, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -351.29868, 1580.21191, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -360.96368, 1589.81946, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -366.44061, 1594.95447, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -361.68848, 1599.58813, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -351.89008, 1609.49231, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -346.68878, 1614.88940, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -341.58774, 1609.87415, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -332.18805, 1600.24548, 82.89450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -337.19891, 1604.57361, 83.51450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -337.39890, 1585.83179, 83.51450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -355.94666, 1585.74329, 83.51450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -356.01135, 1604.34229, 83.51450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -337.46732, 1594.47485, 97.21450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -347.30640, 1585.93030, 97.21450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -355.90198, 1595.74060, 97.21450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -355.90198, 1595.74060, 97.21450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -345.91028, 1604.30737, 97.21450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -346.43585, 1603.39819, 102.55450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -346.70099, 1587.44800, 102.55450,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -318.41708, 1309.33411, 52.73470,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -323.47409, 1309.27014, 52.29470,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, -327.57346, 1309.23010, 52.29470,   0.00000, 0.00000, 0.00000);
	return 1;
}

stock GetNumberOfPlayersOnThisIP(test_ip[])
{
	new against_ip[32+1];
	new x = 0;
	new ip_count = 0;
	for(x=0; x<MAX_PLAYERS; x++) {
		if(IsPlayerConnected(x)) {
			GetPlayerIp(x,against_ip,32);
			if(!strcmp(against_ip,test_ip)) ip_count++;
		}
	}
	return ip_count;
}
public OnGameModeExit()
{
	for(new i=0; i<122; i++)
	TextDrawDestroy(speedom[i]);
	for(new l=0; l<16; l++)
	TextDrawDestroy(mysp[l]);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, -1657.0343,1216.7537,13.6719);
	SetPlayerFacingAngle(playerid, 199.4727);
	SetPlayerCameraPos(playerid, -1654.8575,1213.5493,13.6719);
	SetPlayerCameraLookAt(playerid, -1657.0343,1216.7537,13.6719);
	return 1;
}
public OnPlayerConnect(playerid)
{
	new string[192],pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pName,sizeof(pName));
	pData[playerid][pKills]=0; pData[playerid][pDeaths]=0;
	pData[playerid][pSkin]=0;

	pData[playerid][gPlayerLogged]=0; pData[playerid][gLogTries]=0;
	RandomPlayerScreen(playerid);
	format(string,sizeof(string),USERFILE_DIRECTION,pName);
	if(fexist(string))
	{
		format(string,sizeof(string),"{7eff00}Здравствуйте {FF0000}%s\n{3eff00}Вы здесь уже зарегистированы\n{00ff37}ВВедите свой пароль, чтобы войти в игру:",pName);
		ShowPlayerDialog(playerid, LoginDialog, DIALOG_STYLE_INPUT, "{ffc300}Вход в игру", string, "Войти", "Отмена");
	}
	else
	{
		format(string,sizeof(string),"{ddff00}Здравствуйте {FF0000}%s\n{9cff00}Вы здесь не зарегистированы\n{4cff00}Придумайте себе пароль и введите его в поле:",pName);
		ShowPlayerDialog(playerid, RegisterDialog, DIALOG_STYLE_INPUT, "{ffc300}Регистрация", string, "Войти", "Отмена");
	}
	dives[playerid] = 0;
	new connect_ip[32+1];
	GetPlayerIp(playerid,connect_ip,32);
	new num_ip = GetNumberOfPlayersOnThisIP(connect_ip);
	if(num_ip > MAX_IP)
	{
		Ban(playerid);
		return 1;
	}
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "");
	SendClientMessage(playerid, 0x5353FFAA, "{00FF00}|=================================| {FF0000}Добро Пожаловать {00FF00}|=================================|");
	SendClientMessage(playerid, 0x5353FFAA, "{FF0000}Russian~Drift: {FFFFFF}Обязательно прочтите {00FF00}правила игры {FFFFFF}на сервере: {00FF00}/rules");
	SendClientMessage(playerid, 0x5353FFAA, "{FF0000}Russian~Drift: {FFFFFF}Мы рады видеть вас на {FFFF00}Russian~Drift{FFFFFF}, для справки введите {00FF00}/help");
	SendClientMessage(playerid, 0x5353FFAA, "{FF0000}Russian~Drift: {FFFFFF}Чтобы открыть меню телепортов введите: {0099FF}/menu > телепорты");
	SendClientMessage(playerid, 0x5353FFAA, "{FF0000}Russian~Drift: {FFFFFF}Чтобы поприветствовать всех игроков,введите: {0099FF}/hh");
	SendClientMessage(playerid, 0x5353FFAA, "{FF0000}Russian~Drift: {FFFFFF}Чтобы попрощаться со всеми игроками,введите: {0099FF}/bb");
	SendClientMessage(playerid, 0x5353FFAA, "{FF0000}Russian~Drift: {FFFFFF}Для входа в меню нажмите {FFFF00}Alt {FFFFFF}или {FFFF00}2 (вы должны быть в автомобиле)");
	SendClientMessage(playerid, 0x5353FFAA, "{00FF00}|=================================| {FF0000}Добро Пожаловать {00FF00}|=================================|");
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	OnPlayerUpdateEx(playerid);
	return 1;
}


public OnPlayerSpawn(playerid)
{
	SetPlayerWeather(playerid, 0);
	new rand = random(sizeof(RandomSpawn));
	SetPlayerPos(playerid,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2]);
	SetPlayerHealth(playerid,100);
	SetPlayerArmour(playerid,100);
	GivePlayerWeapon(playerid, 43, 1000);
	SetPlayerInterior(playerid,0);
	TextDrawShowForPlayer(playerid,Clock);

	//иконки на карте
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
}

public OnPlayerDeath(playerid, killerid, reason)
{
	GameTextForPlayer(playerid,"~r~YMEP",3000,2);
	GameTextForPlayer(killerid,"~r~+200000",2000,1);
	GivePlayerMoney(killerid, 200000);
	SendDeathMessage(killerid,playerid,reason);
	pData[playerid][pDeaths]+=1;
	if(killerid != INVALID_PLAYER_ID) { pData[killerid][pKills]+=1; }
	return 1;
}
stock strcharsplit(const string[], &index, seperator=' ')
{
	new result[20], i = 0;
	if (index != 0) index++;
	while (string[index] && string[index] != seperator)
	{
		result[i++] = string[index++];
	}
	return result;
}
stock PlayerName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pname,sizeof(pname));
	return pname;
	ScoreUp();
	if(IsPlayerConnected(killerid) && killerid != INVALID_PLAYER_ID)
	{
		new Score = GetPlayerMoney(killerid);
		if(Score >= 0 && Score < 20000) format(PlayerInf[killerid][Level],200,"{FFFFFF}*{00CCFF}Игрок{FFFFFF}*\n*Уровень: {00CCFF}1{FFFFFF}.*\n*{00CCFF}Нуб в дрифтинге{FFFFFF}*");
		if(Score >= 20000 && Score < 50000) format(PlayerInf[killerid][Level],200,"{FFFFFF}*Игрок{FFFFFF}*\n*Уровень: {00CCFF}2{FFFFFF}.*\n*{00CCFF}НовичёГГ{FFFFFF}*");
		if(Score >= 50000 && Score < 80000) format(PlayerInf[killerid][Level],200,"{FFFFFF}*{00CCFF}Игрок{FFFFFF}*\n*Уровень: {00CCFF}3{FFFFFF}.*\n*{00CCFF}Начинающтй Дрифтер{FFFFFF}*");
		if(Score >= 80000 && Score < 120000) format(PlayerInf[killerid][Level],200,"{FFFFFF}*{00CCFF}Игрок{FFFFFF}*\n*Уровень: {00CCFF}4{FFFFFF}.*\n*{00CCFF}Проживающий{FFFFFF}*");
		if(Score >= 120000 && Score < 150000) format(PlayerInf[killerid][Level],200,"{FFFFFF}*{00CCFF}Игрок{FFFFFF}*\n*Уровень: {00CCFF}5{FFFFFF}.*\n*{00CCFF}Свой{FFFFFF}*");
		if(Score >= 150000 && Score < 180000) format(PlayerInf[killerid][Level],200,"{FFFFFF}*{00CCFF}Игрок{FFFFFF}*\n*Уровень: {00CCFF}6{FFFFFF}.*\n*{00CCFF}Пахан{FFFFFF}*");
		if(Score >= 180000 && Score < 200000) format(PlayerInf[killerid][Level],200,"{FFFFFF}*{00CCFF}*ViP*{FFFFFF}*\n*Уровень: {00CCFF}7{FFFFFF}.*\n*{00CCFF}Pro Drifter{FFFFFF}*");
		if(Score >= 200000 && Score < 250000) format(PlayerInf[killerid][Level],200,"{FFFFFF}*{00CCFF}*ViP*{FFFFFF}*\n*Уровень: {00CCFF}8{FFFFFF}.*\n*{00CCFF}ViP{FFFFFF}*");
		if(Score >= 250000 && Score < 270000) format(PlayerInf[killerid][Level],200,"{FFFFFF}*{00CCFF}*ViP*{FFFFFF}*\n*Уровень: {00CCFF}9{FFFFFF}.*\n*{00CCFF}Гловарь{FFFFFF}*");
		if(Score >= 270000 ) format(PlayerInf[killerid][Level],200,"{FFFFFF}*{00CCFF}*ViP*{FFFFFF}*\n*Уровень: {00CCFF}*10*{FFFFFF}.*\n*{00CCFF}Король Дрифта{FFFFFF}*");
		Update3DTextLabelText(Level3D[killerid],0x00FF00FF,PlayerInf[killerid][Level]);
	}
	return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
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

	if(strcmp("/pm", cmd, true) == 0)
	{
		tmp = strtok(cmdtext,idx);

		if(!strlen(tmp) || strlen(tmp) > 5) {
			SendClientMessage(playerid,COLOR_RED,"[Сервер]: /pm (id) (сообщение)");
			return 1;
		}

		new id = strval(tmp);
		gMessage = strrest(cmdtext,idx);

		if(!strlen(gMessage)) {
			SendClientMessage(playerid,COLOR_RED,"[Сервер]: /pm (id) (сообщение)");
			return 1;
		}

		if(!IsPlayerConnected(id)) {
			SendClientMessage(playerid,COLOR_RED,"[Сервер] : Нет такого ID");
			return 1;
		}

		if(playerid != id) {
			GetPlayerName(id,iName,sizeof(iName));
			GetPlayerName(playerid,pName,sizeof(pName));
			format(Message,sizeof(Message),"Личное сообщение: %s(%d): %s",iName,id,gMessage);
			SendClientMessage(playerid,PM_OUTGOING_COLOR,Message);
			format(Message,sizeof(Message),"Личное сообщение: %s(%d): %s",pName,playerid,gMessage);
			SendClientMessage(id,PM_INCOMING_COLOR,Message);
			PlayerPlaySound(id,1085,0.0,0.0,0.0);
		}
		else {
			SendClientMessage(playerid,ADMINFS_MESSAGE_COLOR,"[Сервер]Пишешь в pm себе?");
		}
		return 1;
	}


	if(strcmp(cmd, "/kill", true) == 0)
	{
		SetPlayerHealth(playerid,0);
		PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
		return 1;
	}




	if(strcmp(cmd, "/poff", true) == 0)
	{
		ClearAnimations(playerid);
		return 1;
	}

	if (strcmp("/r", cmdtext, true, 10) == 0)
	{
		SetPlayerScore(playerid, 0);
		ResetPlayerMoney(playerid);
		SendClientMessage(playerid, 0x00FF00AA, "[Сервер]Ваш счет упешно обнулен :-)");
		return 1;
	}
	if(strcmp(cmdtext, "/colors", true)==0)
	{
		ShowPlayerDialog(playerid,794,DIALOG_STYLE_LIST,"{FF0000}Меню цветов","{FF0000}Красный\n{BEBEBE}Серый\n{006400}Зеленый\n{EEA2AD}Розовый\n{00FF00}Лайм\n{0000FF}Синий\n{FFFF00}Желтый\n{00FFFF}Голубой\n{FFA500}Оранжевый\n{FF00FF}Магента\n{FF6347}Томатный\n{551A8B}Индиго\n{B8860B}Золотой\n{698B22}Оливковый\n{9ACD32}Желто-Зеленый\n{8B4513}Коричневый\n{EE6A50}Коралловый\n{FF4500}Красно-оранжевый\nОтключить цвет","Применить"," Отмена");
		return 1;
	}
	if(strcmp(cmdtext, "/admhelp", true) == 0)
	{
		new string4[777];
		strcat(string4, "{FF0000}1 {00FF00}уровень : {FF0000}50{00FFFF}рублей\r\n");
		strcat(string4, "{FF0000}2 {00FF00}уровень : {FF0000}100{00FFFF}рублей\r\n");
		strcat(string4, "{FF0000}3 {00FF00}уровень : {FF0000}150{00FFFF}рублей\r\n");
		strcat(string4, "{FF0000}4 {00FF00}уровень : {FF0000}200{00FFFF}рублей\r\n");
		strcat(string4, "{FF0000}5 {00FF00}уровень : {FF0000}250{00FFFF}рублей\r\n");
		strcat(string4, "{FF0000}6 {00FF00}уровень : {FF0000}300{00FFFF}рублей\r\n");
		strcat(string4, "{FF0000}7 {00FF00}уровень : {FF0000}350{00FFFF}рублей\r\n");
		strcat(string4, "{FF0000}8 {00FF00}уровень : {FF0000}400{00FFFF}рублей\r\n");
		strcat(string4, "{FF0000}9 {00FF00}уровень : {FF0000}500{00FFFF}рублей\r\n");
		strcat(string4, "{FF0000}*{FFFF00}По-поводу покупки админки обращаться:\r\n");
		strcat(string4, "{0066FF}ВКонтакте: {FFFFFF}vk.com/miraclegame\r\n");
		strcat(string4, "{00FFFF}Skype: {FFFF00}nndrift");
		ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{FF0000}Extreme~Drift: {FFFFFF}Админка на сервере", string4, "Ок", "");
		return 1;
	}
	

	if(strcmp("/rules", cmdtext, true, 10) == 0)
	{
		new string9[777];
		strcat(string9, "{00FFFF}Правила сервера •°•Русский•[Extreme~Drift]•Сервер•°•:\r\n");
		strcat(string9, "\r\n");
		strcat(string9, "{FF0000}1) {00CCFF}Запрещено использовать читы/хаки/cleo{00FFFF}*{FF6464} - наказание кик/бан.\r\n");
		strcat(string9, "{FF0000}2) {00ACFF}Запрещено материться в чате - наказание мут/кик.\r\n");
		strcat(string9, "{FF0000}3) {0083FF}Запрещено использовать ники админов - наказание бан.\r\n");
		strcat(string9, "{FF0000}4) {0054FF}Запрещено использовать безсмысленые ники или ник содержащие мат - наказание кик.\r\n");
		strcat(string9, "{FF0000}5) {0000FF}Запрещено рекламировать свой сервер/сайт в чате - наказание бан.\r\n");
		strcat(string9, "{FF0000}6) {2C00FF}Запрещено флудить в чате - наказание мут/кик.\r\n");
		strcat(string9, "{FF0000}7) {5F00FF}Запрещено флудить командами - наказание кик.\r\n");
		strcat(string9, "{FF0000}7) {5F00FF}Запрещено использовать баги: +С, слайд и т.д.\r\n");
		strcat(string9, "{00FFFF}*{9B00FF}(если cleo не даёт никакого преимущества над другими игроками, тогда оно разрешено)\r\n");
		ShowPlayerDialog(playerid,1002, DIALOG_STYLE_MSGBOX, "{FF0000}Extreme~Drift: {FFFFFF}Правила сервера", string9, "Прочитал", "");
		return 1;
	}




	if(strcmp(cmdtext, "/help", true) == 0)
	{
		ShowPlayerDialog(playerid, 1040,DIALOG_STYLE_MSGBOX,"{FF0000}Extreme~Drift: {FFFFFF}О Сервере","{00FF00}Правила сервера: {00FFFF}/rules\n{00FF00}Команды сервера: {00FFFF}/cmd\n{00FF00}Купить админку: {00FFFF}/admhelp","Ок","");

		return 1;
	}


	if(strcmp(cmdtext, "/cmd", true) == 0)
	{
		new string2[777];
		strcat(string2, "{FFFF00}/hh - Поздороватся со всеми\r\n");
		strcat(string2, "{FFFF00}/bb - Попрощатся со всеми\r\n");
		strcat(string2, "{FFFF00}/pm - Личные сообщения\r\n");
		strcat(string2, "{FFFF00}/count - Запустить отсчёт\r\n");
		strcat(string2, "{FFFF00}/admins - Админы онлайн\r\n");
		strcat(string2, "{FFFF00}/housemenu - Управление домом\r\n");
		strcat(string2, "{FFFF00}/gang - Система Банд\r\n");
		strcat(string2, "{FFFF00}/admhelp - Информация по-получению админки\r\n");
		strcat(string2, "{FFFF00}/dt - Режим дрифт тренировки\r\n");
		strcat(string2, "{FFFF00}/r - Обнуличть очки\r\n");
		strcat(string2, "{FFFF00}/colors - Смена цвета ника\r\n");
		strcat(string2, "{FFFF00}/givecash - Передать денег игроку\r\n");
		strcat(string2, "{FFFF00}/cmd - Список команд сервера\r\n");
		ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{FF0000}Extreme~Drift: {FFFFFF}Команды сервера", string2, "Прочитал", "");
		return 1;
	}



	//---------------------Команды /qq /bb----------------------------//
	if(!strcmp("/hh", cmdtext, true, 10))
	{
		new var8[30], var9[256];
		GetPlayerName(playerid, var8, 30);
		format(var9, 256, "{7CFC00}Игрок %s Сказал всем ПРИВЕТ {FFFF00}", var8);
		SendClientMessageToAll(0x00FF00AA, var9);
		return 1;
	}
	if(!strcmp("/bb", cmdtext, true, 10))
	{
		new var8[30], var9[256];
		GetPlayerName(playerid, var8, 30);
		format(var9, 256, "{FFFF66}Игрок %s {00FF00}Прощается со всеми {F0F000}", var8);
		SendClientMessageToAll(0x00FF00AA, var9);
		return 1;
	}
	//-----------------------------Функция передача денег---------------------------|
	if(strcmp(cmd, "/givecash", true) == 0) {
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "0xFF0000AA,[Сервер]: /pay [ид игрока] [сколько]");
			return 1;
		}
		giveplayerid = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "0xFF0000AA,[Сервер]: /pay [ид игрока] [сколько]");
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
				format(string, sizeof(string), "*Вы отправили %s(ID: %d), $%d.", giveplayer,giveplayerid, moneys);
				SendClientMessage(playerid, COLOR_RED, string);
				format(string, sizeof(string), "*Вы получили $%d от %s(ID: %d).", moneys, sendername, playerid);
				SendClientMessage(giveplayerid, COLOR_RED, string);
				printf("%s(ID:%d) передал %d игроку %s(ID:%d)",sendername, playerid, moneys, giveplayer, giveplayerid);
			}
			else {
				SendClientMessage(playerid, COLOR_RED, "*Неверная сумма.");
			}
		}
		else {
			format(string, sizeof(string), "%d неактивный игрок.", giveplayerid);
			SendClientMessage(playerid, COLOR_RED, string);
		}
		return 1;
	}
	if (strcmp("/menu", cmdtext, true, 10) == 0)
	{
		new string8[777];
		strcat(string8, "{FFFFFF}Тюнинг\r\n");
		strcat(string8, "{FFFFFF}Перевернуть тачку\r\n");
		strcat(string8, "{FFFFFF}Телепорты\r\n");
		strcat(string8, "{FFFFFF}ДеадМатчи\r\n");
		strcat(string8, "{FFFF00}Mp3 Плеер\r\n");
		strcat(string8, "{FFFFFF}Автомобили\r\n");
		strcat(string8, "{FFFFFF}Управление персонажем\r\n");
		strcat(string8, "{FFFFFF}Помощь\r\n");
		strcat(string8, "{FFFFFF}Отсчёт\r\n");
		strcat(string8, "{FF3300}Управление Авто\r\n");
		strcat(string8, "{FFFFFF}Покупка Оружия\r\n");
		strcat(string8, "{00FFFF}Система Банд\r\n");
		ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "{FF0000}Extreme~Drift: {FFFFFF}Меню", string8, "Выбрать", "Выход");
		return 1;
	}
	if(!strcmp(cmd, "/gang", true))
	{
		ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "{FF0000}[Samp-Play]{FFFFFF} - Gang Menu", "\
		Создать банду\
		\nРедактировать\
		\nПригласить в банду\
		\nУйти из банды\
		", "Выбрать", "Отмена");
		return true;
	}


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

	dcmd(dt, 2, cmdtext);
	return 0;
}


public OnPlayerText(playerid, text[])
{
	SetPlayerChatBubble(playerid, text, 0xAED06FAA, 250.0, 8000);
	new string[256], sendername[32];
	GetPlayerName(playerid, sendername, 32);
	format(string, sizeof(string), "%s(%d)", sendername, playerid);
	SetPlayerName(playerid, string);
	format(string, 128, "%s", text);
	SendPlayerMessageToAll(playerid, string);
	SetPlayerName(playerid, sendername);
	return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	OnPlayerUpdateEx(playerid);
	if (newkeys == 262144) OnPlayerCommandText(playerid,"/radio");
	if ((newkeys==KEY_SUBMISSION))
	{
		if(IsPlayerInAnyVehicle(playerid))
		ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "{FF0000}Extreme~Drift: {FFFFFF}Меню", "{FFFFFF}Тюнинг\n{FFFFFF}Перевернуть тачку\n{FFFFFF}Телепорты\n{FFFFFF}ДеадМатчи\n{FFFF00}Mp3 Плеер\n{FFFFFF}Автомобили\n{FFFFFF}Управление персонажем\n{FFFFFF}Помощь\n{FFFFFF}Отсчёт\n{FF3300}Управление Авто\n{FFFFFF}Покупка Оружия\n{00FFFF}Система Банд", "Выбрать", "Выход");
	}

	if ((newkeys==1024))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "{FF0000}Extreme~Drift: {FFFFFF}Меню", "{FFFFFF}Тюнинг\n{FFFFFF}Перевернуть тачку\n{FFFFFF}Телепорты\n{FFFFFF}ДеадМатчи\n{FFFF00}Mp3 Плеер\n{FFFFFF}Автомобили\n{FFFFFF}Управление персонажем\n{FFFFFF}Помощь\n{FFFFFF}Отсчёт\n{FF3300}Управление Авто\n{FFFFFF}Покупка Оружия\n{00FFFF}Система Банд", "Выбрать", "Выход");
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
	new string[256],pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pName,sizeof(pName));
	switch(dialogid)
	{
	case RegisterDialog:
		{
			switch(response)
			{
			case RBUTTON: { return Kick(playerid); }
			case LBUTTON:
				{
					new tmp[256],tmppass[64],idx;
					tmp = strtok(inputtext, idx);
					if(!strlen(tmp)) {
						format(string,sizeof(string),"{ddff00}Здравствуйте {FF0000}%s\n{9cff00}Вы здесь не зарегистированы\n{4cff00}Придумайте себе пароль и введите его в поле:",pName);
						return ShowPlayerDialog(playerid, RegisterDialog, DIALOG_STYLE_INPUT, "{ffc300}Регистрация", string, "Войти", "Отмена"); }
					strmid(tmppass,tmp,0,strlen(inputtext),255);
					OnPlayerRegister(playerid, tmppass);
				}
			}
		}
	case LoginDialog:
		{
			switch(response)
			{
			case RBUTTON: { return Kick(playerid); }
			case LBUTTON:
				{
					new tmp[256],tmppass[64],idx;
					tmp = strtok(inputtext, idx);
					if(!strlen(tmp)) {
						format(string,sizeof(string),"{7eff00}Здравствуйте {FF0000}%s \n{3eff00}Вы здесь уже зарегистированы\n{00ff37}ВВедите свой пароль, чтобы войти в игру:",pName);
						return ShowPlayerDialog(playerid, LoginDialog, DIALOG_STYLE_INPUT, "{ffc300}Вход в игру", string, "Войти", "Отмена"); }
					strmid(tmppass,tmp,0,strlen(inputtext),255);
					OnPlayerLogin(playerid, tmppass);
				}
			}
		}
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
			else if(listitem == 2)//капот зак
			{
				GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
				SetVehicleParamsEx(carid,engine,lights,alarm,doors,false,boot,objective);
			}
			else if(listitem == 3)//багажник зак
			{
				GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
				SetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,false,objective);
			}
			else if(listitem == 5)
			{
				ShowPlayerDialog(playerid,1,DIALOG_STYLE_LIST,"Неоновая подсветка","{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\n{FFFF00}Желтый\n{FEBFEF}Розовый\nБелый\nУдалить Неон","Выбрать","Отмена");
			}
			else if(listitem == 4)//смена номера
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_INPUT,"{33FF00}Смена номера","{FF3300}Введите номера авто в окошко","Готово","Отмена");
				return 1;
			}
		}
	}
	if(dialogid == 2000)
	{
		if(response == 1)
		{
			switch(listitem)
			{
			case 0:
				{
					SetPlayerAttachedObject(playerid, 0, 18649, 6, 0.07000, 0.03000, 0.80000, 90.000000, 0.000000, 0.000000, 1.3, 0.7, 2.3);
					lmec[playerid] = true;
					GivePlayerWeapon(playerid, 8, 1);
				}
			case 1:
				{
					SetPlayerAttachedObject(playerid, 0, 18650, 6, 0.07000, 0.03000, 0.80000, 90.000000, 0.000000, 0.000000, 1.3, 0.7, 2.3);
					lmec[playerid] = true;
					GivePlayerWeapon(playerid, 8, 1);
				}
			case 2:
				{
					SetPlayerAttachedObject(playerid, 0, 18648, 6, 0.07000, 0.03000, 0.80000, 90.000000, 0.000000, 0.000000, 1.3, 0.7, 2.3);
					lmec[playerid] = true;
					GivePlayerWeapon(playerid, 8, 1);
				}
			case 3:
				{
					SetPlayerAttachedObject(playerid, 0, 18647, 6, 0.07000, 0.03000, 0.80000, 90.000000, 0.000000, 0.000000, 1.3, 0.7, 2.3);
					lmec[playerid] = true;
					GivePlayerWeapon(playerid, 8, 1);
				}
			case 4:
				{
					SetPlayerAttachedObject(playerid, 0, 18652, 6, 0.07000, 0.03000, 0.80000, 90.000000, 0.000000, 0.000000, 1.3, 0.7, 2.3);
					lmec[playerid] = true;
					GivePlayerWeapon(playerid, 8, 1);
				}
			case 5:
				{
					SetPlayerAttachedObject(playerid, 0, 18651, 6, 0.07000, 0.03000, 0.80000, 90.000000, 0.000000, 0.000000, 1.3, 0.7, 2.3);
					lmec[playerid] = true;
					GivePlayerWeapon(playerid, 8, 1);
				}
			case 6:
				{
					RemovePlayerAttachedObject(playerid,0);
					lmec[playerid] = false;
				}
			}
		}
		return 1;
	}
	if(dialogid == 999)
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerTime(playerid, 12, 00);
			}
			if(listitem == 1)
			{
				SetPlayerTime(playerid, 00, 00);
			}
		}
	}
	if(dialogid == 7)
	{
		if(response)
		{
			if(listitem == 0)
			{
				new string14[777];
				strcat(string14, "\r\n");
				strcat(string14, "\r\n");
				strcat(string14, "{00FFFF}Cоздатель мода: {FF0000}Ri[tm]iX\r\n");
				strcat(string14, "\r\n");
				strcat(string14, "{00FFFF}Связь: {FFFFFF}vk.com/miraclegame {00FFFF}Skype: {FFFFFF}nndrift\r\n");
				strcat(string14, "\r\n");
				strcat(string14, "{FFFF00}-------------------------------------------------------\r\n");
				strcat(string14, "\r\n");
				strcat(string14, "{00FFFF}Создатель сервера(проекта): {FF0000}Ri[tm]iX\r\n");
				strcat(string14, "\r\n");
				strcat(string14, "{00FFFF}Связь: {FFFFFF}vk.com/miraclegame {00FFFF}Skype: {FFFFFF}nndrift\r\n");
				strcat(string14, "\r\n");
				strcat(string14, "\r\n");
				ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{FF0000}Extreme~Drift: {FFFFFF}Администрация", string14, "Прочитал", "");
			}
			if(listitem == 1)
			{
				return OnPlayerCommandText(playerid,"/admhelp");
			}
			if(listitem == 2)
			{
				return OnPlayerCommandText(playerid,"/cmd");
			}
			if(listitem == 3)
			{
				new string3[777];
				strcat(string3, "{00FFFF}      [Открытие] 12.12.2013\r\n");
				strcat(string3, "{00FFFF}12 декабря 2013года открылся наш сервер •°•Русский•[Extreme~Drift]•Сервер•°•\r\n");
				strcat(string3, "{00FFFF}Не забудьте записать наш IP:77.220.175.80:7794\r\n");
				strcat(string3, "{00FFFF}\r\n");
				strcat(string3, "{00FFFF}      [Обновление] 12.12.2013\r\n");
				strcat(string3, "{00FFFF}Обнулены все дома,добавлены 150 новый домов.\r\n");
				strcat(string3, "{00FFFF}Добавлены новые телепорты\r\n");
				strcat(string3, "{00FFFF}\r\n");
				ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{FF0000}Extreme~Drift: {FFFFFF}Новости сервера", string3, "Прочитал", "");
			}
			if(listitem == 4)
			{
				return OnPlayerCommandText(playerid,"/rules");
			}
			if(listitem == 5)
			{
				new string22[777];
				strcat(string22, "{00FF1E}Помощь по домам •°•Русский•[Extreme~Drift]•Сервер•°•\r\n");
				strcat(string22, "\r\n");
				strcat(string22, "{00FF3B}На сервере прусутствует более 500 домов.\r\n");
				strcat(string22, "{00FF7C}Все они раставлены по всему SA. У каждого дома своя цена.\r\n");
				strcat(string22, "{00FFAE}Каждый дом имеет свой интерьер. Интерьеров всего 10.\r\n");
				strcat(string22, "{00FFD5}После покупки дома вы сможете сделать следующее:\r\n");
				strcat(string22, "{00FFFF}- {FAA856}Указать дому желаемое название.\r\n");
				strcat(string22, "{00ACFF}- {FAA856}Установить пароль на ваш дом чтобы войти в него могли только вы вводя ваш пароль.\r\n");
				strcat(string22, "{0054FF}- {FAA856}Изменить интерьер вашего дома.\r\n");
				strcat(string22, "{00FFFF}{0000FF}- {FAA856}Также договорясь с админом можно поставить автомобиль возле дома который не пропадёт.\r\n");
				strcat(string22, "{00FFFF}{2C00FF}Ваш дом никто не сможет купить и он никогда не пропадёт.\r\n");
				ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{FF0000}Extreme~Drift: {FFFFFF}Помощь по домам", string22, "Прочитал", "");
			}
			if(listitem == 6)
			{
				new string13[777];
				strcat(string13, "{FF8000}Связь/Сайт •°•Русский•[Extreme~Drift]•Сервер•°•\r\n");
				strcat(string13, "\r\n");
				strcat(string13, "{FF8000}Наша официальная группа вконтакте: vk.com/extreme_gta\r\n");
				strcat(string13, "{FF8000}Наш официальный сайт:\r\n");
				strcat(string13, "{FF8000}Сайт в данный момент на реконструкции, все интересующие вас вопросы можно задавать в группе\r\n");
				ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{FF0000}Extreme~Drift: {FFFFFF}Связь/Сайт", string13, "Прочитал", "");
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
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_INPUT,"{33FF00}Смена номера","{FF3300}Введите номера авто в окошко","Готово","Отмена");
				return 1;
			}
			if(strlen(inputtext) > 10)
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_INPUT,"{33FF00}Смена номера","{FF3300}Cлишком длинный номер!\n{FF3300}Введите номера авто в окошко","Готово","Отмена");
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
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски\nГидравлика\nАрхангел Тюнинг\nЦвет\nВинилы ", "Выбрать", "Назад");
					else SendClientMessage(playerid, COLOR_RED, "Ты не водитель машины!");
				}
				else SendClientMessage(playerid, COLOR_LIGHTBLUE, "Ты не в машине.");
			}
			if(listitem == 1)
			{
				SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.0);
			}
			if(listitem == 2)ShowPlayerDialog(playerid, 5, DIALOG_STYLE_LIST, "Телепорты", "Ухо","Выбрать", "Назад");
			if(listitem == 3)ShowPlayerDialog(playerid, 60, DIALOG_STYLE_LIST,"{0000ff}ДеадМатч-Меню", "{ff8800}ДеадМатч-Дигл\n{ea7500}ДеадМат-Шот\n{ffff00}ДеадМатч Дигл + Шот\n{ccff00}ДеадМатч-M4\n{00ff00}ДеадМатч-M5\n{00ff00}ДеадМатч-Савн\n{c7fcec}ДеадМатч-Пила\n{008cf0}ДеадМатч-Тек9\n{660099}ДеадМатч-Пляж\nСounter-Strike","Выбрать","Назад");
			if(listitem == 4)ShowPlayerDialog(playerid, 100, DIALOG_STYLE_LIST,"{0099FF}Радио","\n{FF3300}Зайцев FM (POP)\"\n{66FFFF}Зайцев FM (Disco)\"\n{FF3300}Зайцев FM (Club)\"\n{FF0000}Зайцев FM (RnB)\"\n{FFCC00}Эвропа +\"\n{FFCCFF}Maks FM\"\n{FF33CC}Казантип FM\"\n{FF3300}TanZ FM\"\n{FF3300}Рок Прорыв FM\"\n{FF0000}DJ РАДИО FM\"\n{FF3300}MIX Radio FM\"\n{FFCC00}Electro FM\"\n{0099FF}Record FM\"\nNEW FM\"\n{FF3300}[DJ]_Zheka\"\n{66FFFF}Выключить радио", "OK", "Назад");
			if(listitem == 5)
			{
				if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,0xFF0000AA,"Вы уже в транспорте");
				ShowPlayerDialog(playerid,9,DIALOG_STYLE_LIST,".::Выбери тачку!::.","Elegy\nSultan\nInfernus\nBanshee\nBuffalo\nHuntley\nCheetah\nTurismo\nQuad-bike\nSlamvan\nBlade\nBullet\nJester\nHotring\nBandito\nWindsor\nStretch\nSabre\nCopCarLa\nKart\nSuperGT\nNRG-500\nSanchez\nBMX\nMtBike\nStart\nFCR-900\nSandKing\nHammer\nBroadway\nSavanna\nZR-350\nPCJ-600\nFreeway\nBuccaneer\nSweeper\nWayfarer\nBus\nStallion\nLandstalker\nSeasparrow\nCaddy\nSolair\nRemington\nFeltzer\nBF-400\nDFT-30","ОК","Назад");
				return 1;
			}
			if(listitem == 6)ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "{0099FF}Управление Персонажем", "Пополнить броню\nПополнить жизни\nСменить скин\nСамоубийство\nСтиль Боя\nОбьекты", "Выбрать", "Отмена");
			if(listitem == 7)ShowPlayerDialog(playerid, 7, DIALOG_STYLE_LIST, "{0099FF}.::Помощь::.", "Администрация\nАдминка на сервере \nКоманды Сервера\nНовости сервера\nПравила сервера\nПомощь по домам\nСвязь/Сайт", "ОК", "Назад");
			if(listitem == 8)return OnPlayerCommandText(playerid,"/count");
			if(listitem == 9)
			{
				if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,0xFF0000AA,"Вы должны быть в машине!");
				ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Авто-Меню","{0099FF}Открыть капот\n{FF3300}Открыть багажник\n{66FFFF}Закрыть капот\n{FFCC00}Закрыть багажник\n{FF3300}Сменить номер\n{FF3300}Неон","Выбрать","Отмена");
			}

			if(listitem == 10)ShowPlayerDialog(playerid, 2345, DIALOG_STYLE_LIST, "Меню оружия", "Deagle {FFFF00}[3000$]\nНож {FFFF00}[400$]\nБита {FFFF00}[1000$]\nГранаты {FFFF00}[1500$]\n9-мм {FFFF00}[2000$]\nSDP {FFFF00}[2300$]\nShotgun {FFFF00}[5000$]\nCombat Shotgun {FFFF00}[8000$]\nMicro SMG/Uzi {FFFF00}[6500$]\nMP-5 {FFFF00}[6800$]\nАК-47 {FFFF00}[7000$]\nМ4 {FFFF00}[7000$]\nТес-9 {FFFF00}[5000$]\nSniper Rifle {FFFF00}[8000$]\nПарашют {FFFF00}[5000$]","ОК","Назад");
			{
				if(listitem == 11)return OnPlayerCommandText(playerid,"/gang");
			}
		}
	}
	if(dialogid == 2345)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(GetPlayerMoney(playerid) <3000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 24, 500 ); 
				GivePlayerMoney(playerid, -3000); 
				SendClientMessage(playerid, COLOR_GIALLO ,"{FF0000}Russian~Drift: {FFFFFF}Deagle куплен.");
			}
			else if(listitem == 1)
			{
				if(GetPlayerMoney(playerid) <400) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 4, 1000);
				GivePlayerMoney(playerid, -400);
				SendClientMessage(playerid, COLOR_GREEN,"{FF0000}Russian~Drift: {FFFFFF}Нож куплен.");
			}
			else if(listitem == 2)
			{
				if(GetPlayerMoney(playerid) <1000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 5, 1000);
				GivePlayerMoney(playerid, -1000);
				SendClientMessage(playerid, COLOR_RED,"{FF0000}Russian~Drift: {FFFFFF}Бита куплена.");
			}
			else if(listitem == 3)
			{
				if(GetPlayerMoney(playerid) <1500) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 16, 1000);
				GivePlayerMoney(playerid, -1500);
				SendClientMessage(playerid, COLOR_GREEN,"{FF0000}Russian~Drift: {FFFFFF}Гранаты куплены.");
			}
			else if(listitem == 4)
			{
				if(GetPlayerMoney(playerid) <2000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 22, 1000);
				GivePlayerMoney(playerid, -2000);
				SendClientMessage(playerid, COLOR_ORANGE,"{FF0000}Russian~Drift: {FFFFFF}9-ММ куплен.");
			}
			else if(listitem == 5)
			{
				if(GetPlayerMoney(playerid) <2300) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 23, 1000);
				GivePlayerMoney(playerid, -2300);
				SendClientMessage(playerid, COLOR_GIALLO ,"{FF0000}Russian~Drift: {FFFFFF}SDP куплен.");
			}
			else if(listitem == 6)
			{
				if(GetPlayerMoney(playerid) <5000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 25, 1000);
				GivePlayerMoney(playerid, -5000); 
				SendClientMessage(playerid, COLOR_RED,"{FF0000}Russian~Drift: {FFFFFF}Shotgun куплен.");
			}
			else if(listitem == 7)
			{
				if(GetPlayerMoney(playerid) <8000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 27, 1000);
				GivePlayerMoney(playerid, -8000); 
				SendClientMessage(playerid, COLOR_GIALLO ,"{FF0000}Russian~Drift: {FFFFFF}Combat Shotgun куплен.");
			}
			else if(listitem == 8)
			{
				if(GetPlayerMoney(playerid) <6500) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 28, 1000);
				GivePlayerMoney(playerid, -6500);
				SendClientMessage(playerid, COLOR_GIALLO ,"{FF0000}Russian~Drift: {FFFFFF}Micro SMG/Uzi куплен.");
			}
			else if(listitem == 9)
			{
				if(GetPlayerMoney(playerid) <6800) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 29, 1000);
				GivePlayerMoney(playerid, -6800);
				SendClientMessage(playerid, COLOR_GREEN,"{FF0000}Russian~Drift: {FFFFFF}MP-5 куплен.");
			}
			else if(listitem == 10)
			{
				if(GetPlayerMoney(playerid) <7000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 30, 1000);
				GivePlayerMoney(playerid, -7000);
				SendClientMessage(playerid, COLOR_GIALLO ,"{FF0000}Russian~Drift: {FFFFFF}АК-47 куплен.");
			}
			else if(listitem == 11)
			{
				if(GetPlayerMoney(playerid) <7000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 31, 1000);
				GivePlayerMoney(playerid, -7000);
				SendClientMessage(playerid, COLOR_RED,"{FF0000}Russian~Drift: {FFFFFF}M4 куплен.");
			}
			else if(listitem == 12)
			{
				if(GetPlayerMoney(playerid) <5000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 32, 1000);
				GivePlayerMoney(playerid, -5000);
				SendClientMessage(playerid, COLOR_GIALLO ,"{FF0000}Russian~Drift: {FFFFFF}Тес-9 куплен.");
			}
			else if(listitem == 13)
			{
				if(GetPlayerMoney(playerid) <8000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 34, 1000);
				GivePlayerMoney(playerid, -8000);
				SendClientMessage(playerid, COLOR_GREEN,"{FF0000}Russian~Drift: {FFFFFF}Sniper Rifle куплен.");
			}
			else if(listitem == 14)
			{
				if(GetPlayerMoney(playerid) <5000) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Russian~Drift: {FFFFFF}Недостаточно средств");
				GivePlayerWeapon(playerid, 46, 1000);
				GivePlayerMoney(playerid, -5000);
				SendClientMessage(playerid, COLOR_RED,"{FF0000}Russian~Drift: {FFFFFF}Парашют куплен.");
			}
			return 1;
		}
	}
	if(dialogid == 100)//Радио
	{
		if(response)
		{
			if(listitem == 0)
			{
				PlayAudioStreamForPlayer(playerid,"http://radio.zaycev.fm:9002/ZaycevFM(128).m3u");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Зайцев FM (POP)");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 1)
			{
				PlayAudioStreamForPlayer(playerid,"http://radio.zaycev.fm:9002/disco/ZaycevFM(128).m3u");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Зайцев FM (Disco)");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 2)
			{
				PlayAudioStreamForPlayer(playerid,"http://radio.zaycev.fm:9002/electronic/ZaycevFM(128).m3u");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Зайцев FM (Club)");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 3)
			{
				PlayAudioStreamForPlayer(playerid,"http://radio.zaycev.fm:9002/rnb/ZaycevFM(128).m3u");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Зайцев FM (RnB)");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 4)
			{
				PlayAudioStreamForPlayer(playerid,"http://webcast.emg.fm:55655/europaplus128.mp3");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Эвропа +");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 5)
			{
				PlayAudioStreamForPlayer(playerid,"http://radio.maks-fm.ru:8000/maksfm128.m3u");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Maks FM");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 6)
			{
				PlayAudioStreamForPlayer(playerid,"http://radio.kazantip-fm.ru:8000/mp396");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Казантип FM");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 7)
			{
				PlayAudioStreamForPlayer(playerid,"http://server.msp-portal.com:8000/listen.pls");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: TanZ FM");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 8)
			{
				PlayAudioStreamForPlayer(playerid,"http://stream4.radiostyle.ru:8004/free");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Рок Прорыв FM");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 9)
			{
				PlayAudioStreamForPlayer(playerid,"http://77.232.137.226:8000/djradio2");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: DJ РАДИО FM");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 10)
			{
				PlayAudioStreamForPlayer(playerid,"http://listen4.myradio24.com:9000/8474.m3u");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: MIX Radio FM");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 11)
			{
				PlayAudioStreamForPlayer(playerid,"http://nikes.3dn.ru/m3u/electro.m3u");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Electro FM");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 12)
			{
				PlayAudioStreamForPlayer(playerid,"http://online.radiorecord.ru:8102/club_128");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: Record FM");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 13)
			{
				PlayAudioStreamForPlayer(playerid,"http://hobbes.idobi.com/;stream.mp3");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: NEW FM");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 14)
			{
				PlayAudioStreamForPlayer(playerid,"http://driftingserver.ucoz.ru/bob_sin.mp3");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Радио волна: [DJ]_SERGEY");
				SendClientMessage(playerid, COLOR_ORANGE,"[Сервер] Подождите 5 секунд для появы сигнала.");
				return 1;
			}
			if(listitem == 15)
			{
				StopAudioStreamForPlayer(playerid);
				SendClientMessage(playerid, COLOR_GREEN,"[Сервер] Радио выключено");
				return 1;
			}
		}

	}
	if(dialogid == 60)//Дм крч
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerPos(playerid,1784.7914,-1118.2589,84.4766);
				SetPlayerFacingAngle(playerid,91.2318);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Deagle DM ", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Deagle DM");
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid,24,99999);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
			}
			if(listitem == 1)
			{
				SetPlayerPos(playerid,-1753.9039,792.2205,167.6563);
				SetPlayerFacingAngle(playerid,175.5191);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Shotgun DM ", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Shotgun DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,25,99999);
			}
			if(listitem == 2)
			{
				SetPlayerPos(playerid,-573.2476,2594.3606,65.8368);
				SetPlayerFacingAngle(playerid,267.3033);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Deagle+Shot DM ", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Deagle+Shot DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,25,99999);
				GivePlayerWeapon(playerid,24,99999);
			}
			if(listitem == 3)
			{
				SetPlayerPos(playerid,-1776.4392,576.1358,234.8906);
				SetPlayerFacingAngle(playerid,114.4186);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на M4 DM ", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на M4 DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,31,99999);
			}
			if(listitem == 4)
			{
				SetPlayerPos(playerid,-1848.9814,1062.0646,145.1297);
				SetPlayerFacingAngle(playerid,274.5101);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на M5 DM ", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на M5 DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,29,99999);
			}
			if(listitem == 5)
			{
				SetPlayerPos(playerid,207.2202,-41.2427,10.0644);
				SetPlayerFacingAngle(playerid,186.8460);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Sawn DM ", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Sawn DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,26,99999);
			}
			if(listitem == 6)
			{
				SetPlayerPos(playerid,295.4582,-1610.4799,114.4219);
				SetPlayerFacingAngle(playerid,86.8917);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Chainsaw DM ", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Chainsaw DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,9,99999);
			}
			if(listitem == 7)
			{
				SetPlayerPos(playerid,2578.2263,1343.5131,78.4764);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Tec 9 DM ", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Tec 9 DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,32,99999);
			}
			if(listitem == 8)
			{
				SetPlayerPos(playerid,2147.8677,-76.6750,2.9725);
				SetPlayerFacingAngle(playerid,271.3768);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Пляж DM ", name);
				SendClientMessageToAll(COLOR_DM, string);
				SendClientMessage(playerid, 0x33FF33AA," Вы телепортировались на Пляж 9 DM");
				ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPlayerArmour(playerid,100);
				GivePlayerWeapon(playerid,31,99999);
				GivePlayerWeapon(playerid,26,99999);
				GivePlayerWeapon(playerid,28,99999);
				GivePlayerWeapon(playerid,22,99999);
			}
			if(listitem == 9)
			{
				SetPlayerPos(playerid,26.3714,1539.8698,12.7632);
				ResetPlayerWeapons(playerid);
				SetPlayerInterior(playerid, 0);
				GivePlayerWeapon(playerid, 34, 40);
				GivePlayerWeapon(playerid, 4, 0);
				GivePlayerWeapon(playerid, 16, 1);
				GivePlayerWeapon(playerid, 24, 42);
				GivePlayerWeapon(playerid, 30, 120);
				SetPlayerArmour(playerid,100);
				SetPlayerHealth(playerid,100);
				new name[MAX_PLAYER_NAME+1];
				GetPlayerName(playerid, name, sizeof(name));
				format(string, sizeof(string), "Игрок %s телепортировался на Counter-Strike DM", name);
				SendClientMessageToAll(COLOR_DM, string);

			}

		}
	}

	if(dialogid == 8)//upravl persom
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerArmour(playerid,100);
				ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST,"{FF0000}Управление Персонажем","Пополнить броню\nПополнить жизни\nСменить скин\n{0099FF}Самоубийство\nСтиль Боя\nОбьекты", "OK", "Назад");
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
				ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "{FF0000}Управление Персонажем", "Пополнить броню\nПополнить жизни\nСменить скин\nСамоубийство\nСтиль Боя\nОбьекты", "OK", "Назад");
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
			}
			if(listitem == 5)
			{
				new string7777[777];
				strcat(string7777, "{FF0000}1. Шляпа Санты\r\n");
				strcat(string7777, "{FF2C00}2. Попугай на плече\r\n");
				strcat(string7777, "{FF5000}3. Попугай\r\n");
				strcat(string7777, "{FF8700}4. Бегемот\r\n");
				strcat(string7777, "{FFA700}5. Кепка\r\n");
				strcat(string7777, "{FFDC00}6. Кейс в руке\r\n");
				strcat(string7777, "{FFFB00}7. Мешок денег\r\n");
				strcat(string7777, "{C4FF00}8. Акула\r\n");
				strcat(string7777, "{7BFF00}9. Дельфин\r\n");
				strcat(string7777, "{00FF00}10. Шапка курицы\r\n");
				strcat(string7777, "{00FF1E}11. Щит на спине\r\n");
				strcat(string7777, "{00FF3B}12. Щит в руке\r\n");
				strcat(string7777, "{00FF7C}13. Фонарик\r\n");
				strcat(string7777, "{00FFAE}14. ЭлектроШок\r\n");
				strcat(string7777, "{00FFD5}15. Огневые руки\r\n");
				strcat(string7777, "{00FFFF}16. Красный дым\r\n");
				strcat(string7777, "{00CCFF}17. Баскетбольный мяч\r\n");
				strcat(string7777, "{00ACFF}18. Водяной шар\r\n");
				strcat(string7777, "{0083FF}19. Доска для серфинга #1\r\n");
				strcat(string7777, "{0054FF}20. Гитара на спине\r\n");
				strcat(string7777, "{0000FF}21. Гамбургер\r\n");
				strcat(string7777, "{2C00FF}22. Бутылка\r\n");
				strcat(string7777, "{5F00FF}23. Пожарная шапка\r\n");
				strcat(string7777, "{9B00FF}24. Магнитофон\r\n");
				strcat(string7777, "{CB00FF}25. Рога\r\n");
				strcat(string7777, "{FF0000}26. Факел в левой руке\r\n");
				strcat(string7777, "{FF5000}28. Голова CJ\r\n");
				strcat(string7777, "{FF8700}29. Грабли в левой руке\r\n");
				strcat(string7777, "{ffffff}***** Снять всё *****\r\n");
				ShowPlayerDialog(playerid, 894, DIALOG_STYLE_LIST, "{FF0000}Объекты", string7777, "OK", "назад");
			}
			if(listitem == 2)ShowPlayerDialog(playerid, 10, DIALOG_STYLE_INPUT, "{33FF00}Смена скина", "{FF3300}Введите id", "OK", "назад");
			if(listitem == 4)
			{
				ShowPlayerDialog(playerid, 1515, DIALOG_STYLE_LIST, "Стиль боя", "Обычный\n{33FF00}Бокс\n{FF3300}Конг-Фу\n{0099FF}Головой об колено\n{66FFFF}Захват-удар\n{FF0000}Ель-Боу", "OK", "Назад");
			}
		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "{FF0000}Extreme~Drift: {FFFFFF}Меню", "{FFFFFF}Тюнинг\n{FFFFFF}Перевернуть тачку\n{FFFFFF}Телепорты\n{FFFFFF}ДеадМатчи\n{FFFF00}Mp3 Плеер\n{FFFFFF}Автомобили\n{FFFFFF}Управление персонажем\n{FFFFFF}Помощь\n{FFFFFF}Отсчёт\n{FF3300}Управление Авто\n{FFFFFF}Покупка Оружия\n{00FFFF}Система Банд", "Выбрать", "Выход");
	}

	if(dialogid == 894)//Объекты
	{
		if(response)
		{
			if(listitem == 0) // Шляпа Санты
			{
				SetPlayerAttachedObject( playerid, 0, 19065, 2, 0.121128, 0.023578, 0.001139, 222.540847, 90.773872, 211.130859, 1.098305, 1.122310, 1.106640 ); // SantaHat
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 1) // Попугай на плече
			{
				SetPlayerAttachedObject( playerid, 0, 19078, 1, 0.329150, -0.072101, 0.156082, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); // TheParrot1
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 2) // Попугай
			{
				SetPlayerAttachedObject( playerid, 0, 19078, 1, -1.097527, -0.348305, -0.008029, 0.000000, 0.000000, 0.000000, 8.073966, 8.073966, 8.073966 ); // TheParrot1 - parrot man
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 3) // Бегемот
			{
				SetPlayerAttachedObject( playerid, 0, 1371, 1, 0.037538, 0.000000, -0.020199, 350.928314, 89.107200, 180.974227, 1.000000, 1.000000, 1.000000 ); // CJ_HIPPO_BIN - /hippo
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 4) // Кепка
			{
				SetPlayerAttachedObject( playerid, 0, 18939, 2, 0.147825, 0.010626, -0.004892, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); // CapBack1 - Sapca RuTeN
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 5) // Кейс в руке
			{
				SetPlayerAttachedObject( playerid, 0, 1210, 6, 0.259532, -0.043030, -0.009978, 85.185333, 271.380615, 253.650283, 1.000000, 1.000000, 1.000000 ); // briefcase - briefcase
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 6) // Мешок денег
			{
				SetPlayerAttachedObject( playerid, 0, 1550, 15, 0.016491, 0.205742, -0.208498, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); // CJ_MONEY_BAG - money
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 7) // Акула
			{
				SetPlayerAttachedObject( playerid, 0, 1608, 1, 0.201047, -1.839761, -0.010739, 0.000000, 90.005447, 0.000000, 1.000000, 1.000000, 1.000000 ); // shark - shark
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 8) // Дельфин
			{
				SetPlayerAttachedObject( playerid, 0, 1607, 1, 0.000000, 0.000000, 0.000000, 0.000000, 86.543479, 0.000000, 1.000000, 1.000000, 1.000000 ); // dolphin - /dolphin
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 9) // Шапка курицы
			{
				SetPlayerAttachedObject( playerid, 0, 19137, 2, 0.110959, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); // CluckinBellHat1 - 7
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 10) // Щит на руке
			{
				SetPlayerAttachedObject(playerid, 0 , 18637, 1, 0, -0.1, 0.18, 90, 0, 272, 1, 1, 1);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 11) // Щит на спине
			{
				SetPlayerAttachedObject(playerid, 0, 18637, 4, 0.3, 0, 0, 0, 170, 270, 1, 1, 1);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 12) // Фонарик
			{
				SetPlayerAttachedObject(playerid, 0,18641, 5, 0.1, 0.02, -0.05, 0, 0, 0, 1, 1, 1);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 13) // Электрошок
			{
				SetPlayerAttachedObject(playerid, 0,18642, 5, 0.12, 0.02, -0.05, 0, 0, 45,1,1,1);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 14) // огневые руки
			{
				SetPlayerAttachedObject( playerid, 0, 18693, 6, 0.033288, 0.000000, -1.647527, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); ////правая рука
				SetPlayerAttachedObject( playerid, 0, 18693, 5, 0.036614, 1.886157, 0.782101, 145.929061, 0.000000, 0.000000, 0.469734, 200.000000, 1.000000 ); //левая рука
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 15)
			{
				SetPlayerAttachedObject( playerid, 0, 18728, 2, 0.134301, 1.475258, -0.192459, 82.870338, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 16)
			{
				SetPlayerAttachedObject( playerid, 0, 2114, 2, 0.043076, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 17)//Водяной шар
			{
				SetPlayerAttachedObject( playerid, 0, 18844, 1, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -0.027590, -0.027590, -0.027590 );
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 18)// Доска для серфинга #1
			{
				SetPlayerAttachedObject ( playerid, 0, 2404, 1, 0.0089, -0.1350, -0.0129, 1.00, 125.49, 0.89, 0.86, 0.78, 0.71);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 19)//Гитара на спине
			{
				SetPlayerAttachedObject ( playerid, 0, 19317, 1, 0.2330, -0.0989, -0.0299, -2.49, 88.09, 2.09, 0.73, 1.89, 0.71);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 20)//Гамбургер
			{
				SetPlayerAttachedObject(playerid, 0, 2703, 2, -0.6070, 0.2190, -0.0129, 176.99, 0.00, 0.00, 7.11, 6.89, 6.92);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 21)//бутылка
			{
				SetPlayerAttachedObject(playerid, 0, 1486, 1, 0.1590, 0.0180, 0.0040, -90.49, 91.09, 12.80, 9.14, 10.51, 6.60);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 22) //Пожарная шапка
			{
				SetPlayerAttachedObject(playerid, 0, 19330, 2, 0.1730, -0.0180, 0.0029, 0.00, 0.00, 0.00, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 23)//магнитола
			{
				SetPlayerAttachedObject(playerid, 0, 2226, 5, 0.3089, 0.0089, 0.0380, -20.29, -99.49, 0.00, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 24)//рога
			{
				SetPlayerAttachedObject(playerid, 0, 19314, 2, 0.1360, 0.0680, 0.0019, -0.29, 0.00, -46.79, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 25)//факел в левой руке
			{
				SetPlayerAttachedObject(playerid, 0, 3461, 5, -0.4580, -0.2119, -0.4439, 153.10, -46.59, 80.80, 0.45, 0.89, 0.73);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 26)//голова CJ
			{
				SetPlayerAttachedObject(playerid, 0, 18963, 2, 0.0989, 0.0140, -0.0069, 85.49, 87.10, 6.89, 1.37, 1.38, 1.12);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 27)//Грабли в левой руке
			{
				SetPlayerAttachedObject(playerid, 0, 18890, 5, 0.0519, -0.0409, 0.1460, 0.00, 0.00, 0.00, 1.00, 1.00, 1.00);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			}
			if(listitem == 28)
			{
				RemovePlayerAttachedObject(playerid, 0);
				DestroyPlayerObject(playerid, 18728);
			}
		}
	}
	if(dialogid == 1515)//СТИЛИ БОЯ
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
				SendClientMessage(playerid, 0xFFFFFFAA, "{FF0000}Вы выбрали стиль боя:Обычный. Использование: Правая кнопка мыши + F");
			}
			if(listitem == 1)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
				SendClientMessage(playerid, 0xFFFFFFAA, "{FF0000}Вы выбрали стиль боя:Бокс. Использование: Правая кнопка мыши + F");
			}
			if(listitem == 2)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
				SendClientMessage(playerid, 0xFFFFFFAA, "{FF0000}Вы выбрали стиль боя:Конг-Фу. Использование: Правая кнопка мыши + F");
			}
			if(listitem == 3)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
				SendClientMessage(playerid, 0xFFFFFFAA, "{FF0000}Вы выбрали стиль боя:Головой об колено. Использование: Правая кнопка мыши + F");
			}
			if(listitem == 4)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
				SendClientMessage(playerid, 0xFFFFFFAA, "{FF0000}Вы выбрали стиль боя:Захват-удар. Использование: Правая кнопка мыши + F");
			}
			if(listitem == 5)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
				SendClientMessage(playerid, 0xFFFFFFAA, "{FF0000}Вы выбрали стиль боя:ЭльБоу. Использование: Правая кнопка мыши + F");
			}
		}
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
				ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски\nГидравлика\nАрхангел Тюнинг\nЦвет\nВинилы", "Выбрать", "Назад");
			}
			if(listitem == 2)
			{
				new Car = GetPlayerVehicleID(playerid), Model = GetVehicleModel(Car);
				switch(Model)
				{
				case 559,560,561,562,565,558: ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "{FF3300}Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
				default: SendClientMessage(playerid,0xFF0000AA,"Вы должны быть в: Elegy, Stratum, Flash, Sultan,  ");
				}
			}
			if(listitem == 3)ShowPlayerDialog(playerid, 13, DIALOG_STYLE_LIST, "Выбор цвета", "Красный \nСиний \nЖелтый \nЗеленый \nСерый \nОранжевый \nЧерный \nБелый \nФиолетовый \nСалатовый", "ОК", "Назад");
			if(listitem == 4)ShowPlayerDialog(playerid, 14, DIALOG_STYLE_LIST, "Выбор винила", "Винил №1 \nВинил №2 \nВинил №3 ", "ОК", "Назад");
		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "{FF0000}Extreme~Drift: {FFFFFF}Меню", "{FFFFFF}Тюнинг\n{FFFFFF}Перевернуть тачку\n{FFFFFF}Телепорты\n{FFFFFF}ДеадМатчи\n{FFFF00}Mp3 Плеер\n{FFFFFF}Автомобили\n{FFFFFF}Управление персонажем\n{FFFFFF}Помощь\n{FFFFFF}Отсчёт\n{FF3300}Управление Авто\n{FFFFFF}Покупка Оружия\n{00FFFF}Система Банд", "Выбрать", "Выход");
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
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски\nГидравлика\nАрхангел Тюнинг\nЦвет\nВинилы", "Выбрать", "Назад");
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
			if(listitem == 8)ChangeVehicleColor(vehicleid, 149, 149);
			if(listitem == 9)ChangeVehicleColor(vehicleid, 147, 147);


			PlayerPlaySound(playerid,1134,0.0,0.0,0.0);
			ShowPlayerDialog(playerid, 13, DIALOG_STYLE_LIST, "Выбор цвета", "Красный \nСиний \nЖелтый \nЗеленый \nСерый \nОранжевый \nЧерный \nБелый \nФиолетовый \nСалатовый", "ОК", "Назад");
		}
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски\nГидравлика\nАрхангел Тюнинг\nЦвет\nВинилы", "Выбрать", "Назад");
	}

	if(dialogid == 9)//car spawning into
	{
		if(response)//написано не мной, взято из чьего-то меню, тем не менее - автору спасибо.
		{
			new carvlad[20],Float:X,Float:Y,Float:Z,Float:Angle,id;
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
			case 6: carvlad = "Cheetah", id = 415;
			case 7: carvlad = "Turismo", id = 451;
			case 8: carvlad = "Quad", id = 471;
			case 9: carvlad = "Slamvan", id = 535;
			case 10: carvlad = "Blade", id = 536;
			case 11: carvlad = "Bullet", id = 541;
			case 12: carvlad = "Jester", id = 559;
			case 13: carvlad = "Hotrina", id = 502;
			case 14: carvlad = "Bandito", id = 568;
			case 15: carvlad = "Windsor", id = 555;
			case 16: carvlad = "Stretch", id = 409;
			case 17: carvlad = "Sabre", id = 475;
			case 18: carvlad = "CopCarLA", id = 596;
			case 19: carvlad = "Kart", id = 571;
			case 20: carvlad = "SuperGt", id = 506;
			case 21: carvlad = "Nrg500", id = 522;
			case 22: carvlad = "Sanchez", id = 468;
			case 23: carvlad = "Bmx", id = 481;
			case 24: carvlad = "MtBike", id = 510;
			case 25: carvlad = "Start", id = 565;
			case 26: carvlad = "FCR-900", id = 521;
			case 27: carvlad = "SandKing", id = 495;
			case 28: carvlad = "Hammer", id = 470;
			case 29: carvlad = "Broadway", id = 575;
			case 30: carvlad = "Savanna", id = 567;
			case 31: carvlad = "ZR-350", id = 477;
			case 32: carvlad = "PCJ-600", id = 461;
			case 33: carvlad = "Freeway", id = 463;
			case 34: carvlad = "Buccaneer", id = 518;
			case 35: carvlad = "Sweeper", id = 574;
			case 36: carvlad = "Wayfarer", id = 586;
			case 37: carvlad = "Bus", id = 437;
			case 38: carvlad = "Stallion", id = 439;
			case 39: carvlad = "Landstalker", id = 400;
			case 40: carvlad = "Seasparrow", id = 447;
			case 41: carvlad = "Caddy", id = 457;
			case 42: carvlad = "Solair", id = 458;
			case 43: carvlad = "Remington", id = 534;
			case 44: carvlad = "Feltzer", id = 533;
			case 45: carvlad = "BF-400", id = 581;
			case 46: carvlad = "DFT-30", id = 578;
			}
			format(string,sizeof(string),"{FF0000}Extreme~Drift: {FFFFFF}%s {00FFFF}Заспавнен",carvlad); SendClientMessage(playerid,0x21DD00FF,string);
			if(ta4katest[playerid] == 1)DestroyVehicle(ta4ka[playerid]);
			ta4ka[playerid] = CreateVehicle(id,X,Y,Z,Angle,-1,-1,50000);
			if(GetPlayerInterior(playerid)) LinkVehicleToInterior(ta4ka[playerid],GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(ta4ka[playerid],GetPlayerVirtualWorld(playerid));
			PutPlayerInVehicle(playerid,ta4ka[playerid],0);
			PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			ta4katest[playerid] = 1;
		}
		return 1;
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
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски\nГидравлика\nАрхангел Тюнинг\nЦвет\nВинилы", "Выбрать", "Назад");
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
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски\nГидравлика\nАрхангел Тюнинг\nЦвет\nВинилы", "Выбрать", "Назад");
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
		else ShowPlayerDialog(playerid, 10, DIALOG_STYLE_INPUT, "{33FF00}Смена скина", "{FF3300}Введите id", "OK", "назад");
	}
	if(dialogid == 5)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -325.1331,1533.0276,75.3594);
				else SetPlayerPos(playerid, -325.1331,1533.0276,75.3594);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Большое Ухо");
				return 1;
			}

			if(listitem == 1)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1685.1092, 944.9697, 10.5394);
				else SetPlayerPos(playerid, 1685.1092, 944.9697, 10.5394);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Парковку");
				return 1;
			}
			if(listitem == 2)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1423.38,-2598.04,13.27);
				else SetPlayerPos(playerid, 1423.38,-2598.04,13.27);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Аэропорт LS");
				return 1;
			}
			if(listitem == 3)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1479.66,1205.61,10.82);
				else SetPlayerPos(playerid, 1479.66,1205.61,10.82);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Аэропорт LV");
				return 1;
			}
			if(listitem == 4)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid),-884.28814697266, 550.00549316406, 5.3881149291992);
				else SetPlayerPos(playerid, -884.28814697266, 550.00549316406, 5.3881149291992);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Островок раздолья");
				return 1;
			}
			if(listitem == 5)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1241.1146,-745.0139,95.0895);
				else SetPlayerPos(playerid, 1241.1146,-745.0139,95.0895);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Гору Вайнвуд");
				return 1;
			}
			if(listitem == 6)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1574.58410645,713.25219727,10.66216087);
				else SetPlayerPos(playerid, 1574.58410645,713.25219727,10.66216087);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Склад-симметрия");
				return 1;
			}
			if(listitem == 7)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -113.16453552,583.32196045,3.14548969);
				else SetPlayerPos(playerid, -113.16453552,583.32196045,3.14548969);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Форт Карсон");
				return 1;
			}

			if(listitem == 8)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1668, -240, 15.0);
				else SetPlayerPos(playerid, -1668, -240, 15.0);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Взлётную полосу Аэропорта SF");
				return 1;
			}

			if(listitem == 9)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1195.292114,16.669136,14.148437);
				else SetPlayerPos(playerid, -1195.292114,16.669136,14.148437);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Пирс в Аэропорту SF");
				return 1;
			}
			if(listitem == 10)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 2710.8738, 1329.6749, 7.4631);
				else SetPlayerPos(playerid, 2710.8738, 1329.6749, 7.4631);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Драг 3");
				return 1;
			}
			if(listitem == 11)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1670.05, 530.93, 37.97);
				else SetPlayerPos(playerid, -1670.05, 530.93, 37.97);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Драг 4");
				return 1;
			}
			if(listitem == 12)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2143.2683,1038.7053,79.8516);
				else SetPlayerPos(playerid, -2143.2683,1038.7053,79.8516);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Драг 5");
				return 1;
			}
			if(listitem == 13)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1611.75, 286.35, 6.91);
				else SetPlayerPos(playerid, -1611.75, 286.35, 6.91);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Дрифт 1");
				return 1;
			}

			if(listitem == 14)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2455.2300, 1569.4902, 7.9226);
				else SetPlayerPos(playerid, -2455.2300, 1569.4902, 7.9226);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Дрифт 2");
				return 1;
			}
			if(listitem == 15)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -768.7189, 1932.5999, 5.5358);
				else SetPlayerPos(playerid, -768.7189, 1932.5999, 5.5358);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Дрифт 3");
				return 1;
			}
			if(listitem == 16)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 2068.3232,2381.8252,45.2265);
				else SetPlayerPos(playerid, 2068.3232,2381.8252,45.2265);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Дрифт 4");
				return 1;
			}
			if(listitem == 17)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1465.1069,422.6227,30.1100);
				else SetPlayerPos(playerid, -1465.1069,422.6227,30.1100);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Дрифт 5");
				return 1;
			}
			if(listitem == 18)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 2304.3979,1533.8732,10.8320);
				else SetPlayerPos(playerid, 2304.3979,1533.8732,10.8320);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Дрифт 6");
				return 1;
			}
			if(listitem == 19)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1939.8640,543.1359,207.1314);
				else SetPlayerPos(playerid, -1939.8640,543.1359,207.1314);
				SendClientMessage(playerid, 0xFFCC2299,"Добро пожаловать на Stunt");
				return 1;
			}
			if(listitem == 20)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 2837.9384765625, -1723.27734375, 39.450527191162);
				else SetPlayerPos(playerid, 2837.9384765625, -1723.27734375, 39.450527191162);
				SetPlayerInterior(playerid,0);
				SendClientMessage(playerid, 0xFF0000AA,"[ИНФО]: Добро пожаловать на Dерби");
				return 1;
			}
			if(listitem == 21)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -671.1672,1531.2892,82.5145);
				else SetPlayerPos(playerid, -671.1672,1531.2892,82.5145);
				SetPlayerInterior(playerid,0);
				SendClientMessage(playerid, 0xFF0000AA,"[ИНФО]: Добро пожаловать на Stunt 4");
				return 1;
			}
		}
	}

	if(dialogid == 794)
	{
		if(response)
		{
			switch(listitem)
			{
			case 0:
				{
					SetPlayerColor(playerid,0xAA3333AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован красный цвет");
				}
			case 1:
				{
					SetPlayerColor(playerid,0xAFAFAFAA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован серый цвет");
				}
			case 2:
				{
					SetPlayerColor(playerid,0x008000AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован зеленый цвет");
				}
			case 3:
				{
					SetPlayerColor(playerid,0xFF80FFAA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован розовый цвет");
				}
			case 4:
				{
					SetPlayerColor(playerid,0x00FF40AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован цвет лайма");
				}
			case 5:
				{
					SetPlayerColor(playerid,0x0000FFAA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован синий цвет");
				}
			case 6:
				{
					SetPlayerColor(playerid,0xFFFF00AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован желтый цвет");
				}
			case 7:
				{
					SetPlayerColor(playerid,0x00FFFFAA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован голубой цвет");
				}
			case 8:
				{
					SetPlayerColor(playerid,0xFF8000AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован оранжевый цвет");
				}
			case 9:
				{
					SetPlayerColor(playerid,0xFF00FFAA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован цвет 'Магента'");
				}
			case 10:
				{
					SetPlayerColor(playerid,0xF96C77AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован томатный цвет");
				}
			case 11:
				{
					SetPlayerColor(playerid,0x400080AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован цвет 'Индиго'");
				}
			case 12:
				{
					SetPlayerColor(playerid,0x808000AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован золотой цвет");
				}
			case 13:
				{
					SetPlayerColor(playerid,0x808040AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован оливковый цвет");
				}
			case 14:
				{
					SetPlayerColor(playerid,0x809E21AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован желто-зеленый цвет");
				}
			case 15:
				{
					SetPlayerColor(playerid,0x804040AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован коричневый цвет");
				}
			case 16:
				{
					SetPlayerColor(playerid,0xAD163DAA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован коралловый цвет");
				}
			case 17:
				{
					SetPlayerColor(playerid,0xFF4500AA);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован красно-оранжевый цвет");
				}
			case 18:
				{
					SetPlayerColor(playerid,0xFFFFFF00);
					SendClientMessage(playerid, COLOR_GREEN, "Активирован режим невидимости");
				}
			}
		}
	}
	return 0;
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

			PlayerPlaySound(i,1057,0.0,0.0,0.0);
			countdown[i]=-1;
		}
	}
}

dcmd_dt(playerid, params[])
{
	new str[64];
	if (!strlen(params)) return SendClientMessage(playerid, 0xFF0000AA, "[INFO]: /dt [мир]"); //Grey colour
	if (strval(params) < 0) return SendClientMessage(playerid, 0xFF0000AA, "[INFO]: Число должно быть больше нуля"); //Grey colour
	new ii = strval(params);
	SetPlayerVirtualWorld(playerid,ii);
	format(str,64,"[INFO]: Ваш мир изменён на %d",ii);
	SendClientMessage(playerid, 0xFF8040AA,str); //Grey colour
	if(ii!=0)return SendClientMessage(playerid, 0x00FF00AA, ">>>[INFO]: Вы в режиме дрифт тренировки"); //Grey colour
	SendClientMessage(playerid, 0x00FF00AA, ">>>[INFO]: Режим дрифт тренировки выключен"); //Grey colour
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

/*stock strtok(const string[], &index)
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
} */
forward SetName();
public SetName()
{
	SendRconCommand("hostname  [0.3x] ¤ Russian • Drift • Server ¤ [RUS]");
	SetTimer("SetName2", 10, 0);
}
forward SetName2();
public SetName2()
{
	SendRconCommand("hostname  [0.3x] ¤ Russian • Drift • Server ¤ [RUS]");
	SetTimer("SetName3", 10, 0);
}
forward SetName3();
public SetName3()
{
	SendRconCommand("hostname  [0.3x] ¤ Russian • Drift • Server ¤ [RUS]");
	SetTimer("SetName", 10, 0);
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new carid = GetPlayerVehicleID(playerid);
	new engine,lights,alarm,doors,bonnet,boot,objective;
	// play an internet radio stream when they are in a vehicle
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
		SetVehicleParamsEx(carid,true,lights,alarm,doors,bonnet,boot,objective);

	}
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
		GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
		SetVehicleParamsEx(carid,engine,false,alarm,doors,bonnet,boot,objective);
		GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
		SetVehicleParamsEx(carid,false,lights,alarm,doors,bonnet,boot,objective);
	}
	if(newstate == PLAYER_STATE_DRIVER && BikeVeh(playerid, GiveModel(playerid)) == 1)
	{
		for(new l=0; l<16; l++)
		TextDrawShowForPlayer(playerid, mysp[l]);
	}
	else if(newstate == PLAYER_STATE_ONFOOT)
	{
		for(new i=0; i<122; i++)
		TextDrawHideForPlayer(playerid, speedom[i]);
		for(new l=0; l<16; l++)
		TextDrawHideForPlayer(playerid, mysp[l]);
	}
	return 0;
}
public OnPlayerStreamIn(playerid, forplayerid)
{
	OnPlayerUpdateEx(playerid);
	return 1;
}

public OnPlayerRegister(playerid, pass[])
{
	new string[64],pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pName,sizeof(pName));
	format(string,sizeof(string),USERFILE_DIRECTION,pName);
	if(!dini_Exists(string))
	{
		dini_Create(string);
		dini_Set(string,"Password",pass);
		dini_IntSet(string,"Kills",pData[playerid][pKills]);
		dini_IntSet(string,"Deaths",pData[playerid][pDeaths]);
		dini_IntSet(string,"Skin",pData[playerid][pSkin]);
		pData[playerid][gPlayerLogged]=1;
		CallRemoteFunction("OnPlayerSpawn","i",playerid);
		return 1;
	}
	return 1;
}

public OnPlayerLogin(playerid, pass[])
{
	new string[128],pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pName,sizeof(pName));
	format(string,sizeof(string),USERFILE_DIRECTION,pName);
	if(!strcmp(pass,dini_Get(string,"Password"),false))
	{
		pData[playerid][pKills] = dini_Int(string,"Kills");
		pData[playerid][pDeaths] = dini_Int(string,"Deaths");
		pData[playerid][pSkin] = dini_Int(string,"Skin");
		CallRemoteFunction("OnPlayerSpawn","i",playerid);
		pData[playerid][gPlayerLogged] = 1;
	}
	else
	{
		pData[playerid][gLogTries]+=1;
		if(pData[playerid][gLogTries] >= MAX_LOG_TRIES)
		{
			format(string,sizeof(string),"{7eff00}Ты ввёл пароль неправильно уже {FF0000}%d.\n{3eff00}У нас подозрение,что ты взломщик,ты кикнут.\n{00ff37}Если ты забыл пароль,то свяжись с администрацией.",MAX_LOG_TRIES);
			ShowPlayerDialog(playerid,947,DIALOG_STYLE_MSGBOX,"{ffc300}Login Failed",string,"~","~");
			Kick(playerid);
		}
		else
		{
			format(string,sizeof(string),"{7eff00}Неправильный пароль!\n{3eff00}Попробуй ещё.\n{00ff37}Попыток осталось: {FF0000}'%d'",(MAX_LOG_TRIES-pData[playerid][gLogTries]));
			ShowPlayerDialog(playerid, LoginDialog, DIALOG_STYLE_INPUT, "{ffc300}Вход в игру", string, "Войти", "Отмена");
		}
	}
	return 1;
}
public OnPlayerUpdateEx(playerid)
{
	new string[64],pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pName,sizeof(pName));
	format(string,sizeof(string),USERFILE_DIRECTION,pName);
	if(dini_Exists(string) && pData[playerid][gPlayerLogged])
	{
		dini_IntSet(string,"Kills",pData[playerid][pKills]);
		dini_IntSet(string,"Deaths",pData[playerid][pDeaths]);
		dini_IntSet(string,"Skin",GetPlayerSkin(playerid));
		return 1;
	}
	return 1;
}
public RandomPlayerScreen(playerid) {
	new screen = random(10);
	SetPlayerInterior(playerid, 0);
	switch(screen) {
	case 0: {
			SetPlayerPos(playerid,-346.083618,1599.942139,164.472366);
			SetPlayerCameraPos(playerid,-345.877228,1601.342896,164.518951);
			SetPlayerCameraLookAt(playerid,-340.641968,1938.658447,83.722984); }
	case 1: {
			SetPlayerPos(playerid,1485.0194,-892.1475,74.4098);
			SetPlayerCameraPos(playerid,1479.7717,-886.2401,73.9461);
			SetPlayerCameraLookAt(playerid,1415.3817,-807.9097,85.0613); }
	case 2: {
			SetPlayerPos(playerid,589.1550,373.1002,15.7948);
			SetPlayerCameraPos(playerid,543.9864,349.3647,14.9968);
			SetPlayerCameraLookAt(playerid,422.1727,599.0107,19.1812); }
	case 3: {
			SetPlayerPos(playerid,2155.0137,1129.7897,18.6397);
			SetPlayerCameraPos(playerid,2149.3992,1132.6051,24.3125);
			SetPlayerCameraLookAt(playerid,2105.0222,1156.5306,11.6470); }
	case 4: {
			SetPlayerPos(playerid,-2818.1499,1144.0898,19.2409);
			SetPlayerCameraPos(playerid,-2808.0366,1161.1864,20.3125);
			SetPlayerCameraLookAt(playerid,-2817.9348,1143.5291,19.3762); }
	case 5: {
			SetPlayerPos(playerid,2144.2822,1279.8054,7.9840);
			SetPlayerCameraPos(playerid,2154.24,1306.50,41.46);
			SetPlayerCameraLookAt(playerid,2273.45,1262.09,33.78); }
	case 6: {
			SetPlayerPos(playerid,-1771.7858,-565.5638,-0.5834);
			SetPlayerCameraPos(playerid,-1771.4641,-566.3715,16.4844);
			SetPlayerCameraLookAt(playerid,2105.0222,1156.5306,11.6470); }
	case 7: {
			SetPlayerPos(playerid,-1254.7159,953.9262,139.2734);
			SetPlayerCameraPos(playerid,-1256.6115,953.2058,139.2734);
			SetPlayerCameraLookAt(playerid,-1529.6639,689.2731,45.3311); }
	case 8: {
			SetPlayerPos(playerid,-2295.7979,712.2764,69.7422);
			SetPlayerCameraPos(playerid,-2265.6101,730.9575,49.2969);
			SetPlayerCameraLookAt(playerid,-2243.5103,731.5889,62.7217); }
	case 9: {
			SetPlayerPos(playerid,50.0000,50.0000,70.0000);
			SetPlayerCameraPos(playerid,50.0000,50.0000,70.2203);
			SetPlayerCameraLookAt(playerid,499.8851,504.5435,7.6593); } } }
public ClockSync(playerid)
{
	new string[256];
	new hour, minute, second;
	gettime(hour,minute,second);
	if(hour < 10 && minute < 10)
	{
		format(string, sizeof(string), "0%d:0%d", hour, minute);
	}
	else if(hour < 10 && minute > 9)
	{
		format(string, sizeof(string), "0%d:%d", hour, minute);
	}
	else if(hour > 9 && minute < 10)
	{
		format(string, sizeof(string), "%d:0%d", hour, minute);
	}
	else
	{
		format(string, sizeof(string), "%d:%d", hour, minute);
	}
	TextDrawSetString(Text:Clock, string);
	SetWorldTime(hour);
}
public OnPlayerUpdate(playerid){
	if(IsPlayerInAnyVehicle(playerid) == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && spedom[playerid] == 1){
		GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
		ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
		UpdateSpeed(playerid, floatround(ST[3]));
	}
	return 1;
}
stock UpdateSpeed(playerid, speed){
	for(new i=0; i<122; i++)
	TextDrawHideForPlayer(playerid, speedom[i]);
	switch(speed){
	case 0..3:     TextDrawShowForPlayer(playerid, speedom[0]);
	case 4..6:     TextDrawShowForPlayer(playerid, speedom[1]);
	case 7..9:     TextDrawShowForPlayer(playerid, speedom[2]);
	case 10..12:   TextDrawShowForPlayer(playerid, speedom[3]);
	case 13..15:   TextDrawShowForPlayer(playerid, speedom[4]);
	case 16..18:   TextDrawShowForPlayer(playerid, speedom[5]);
	case 19..21:   TextDrawShowForPlayer(playerid, speedom[6]);
	case 22..24:   TextDrawShowForPlayer(playerid, speedom[7]);
	case 25..27:   TextDrawShowForPlayer(playerid, speedom[8]);
	case 28..30:   TextDrawShowForPlayer(playerid, speedom[9]);
	case 31..33:   TextDrawShowForPlayer(playerid, speedom[10]);
	case 34..36:   TextDrawShowForPlayer(playerid, speedom[11]);
	case 37..39:   TextDrawShowForPlayer(playerid, speedom[12]);
	case 40..42:   TextDrawShowForPlayer(playerid, speedom[13]);
	case 43..45:   TextDrawShowForPlayer(playerid, speedom[14]);
	case 46..48:   TextDrawShowForPlayer(playerid, speedom[15]);
	case 49..51:   TextDrawShowForPlayer(playerid, speedom[16]);
	case 52..54:   TextDrawShowForPlayer(playerid, speedom[17]);
	case 55..57:   TextDrawShowForPlayer(playerid, speedom[18]);
	case 58..59:   TextDrawShowForPlayer(playerid, speedom[19]);
	case 60:       TextDrawShowForPlayer(playerid, speedom[20]);
	case 61:       TextDrawShowForPlayer(playerid, speedom[21]);
	case 62:       TextDrawShowForPlayer(playerid, speedom[22]);
	case 63:       TextDrawShowForPlayer(playerid, speedom[23]);
	case 64:       TextDrawShowForPlayer(playerid, speedom[24]);
	case 65:       TextDrawShowForPlayer(playerid, speedom[25]);
	case 66:       TextDrawShowForPlayer(playerid, speedom[26]);
	case 67:       TextDrawShowForPlayer(playerid, speedom[27]);
	case 68:       TextDrawShowForPlayer(playerid, speedom[28]);
	case 69:       TextDrawShowForPlayer(playerid, speedom[29]);
	case 70:       TextDrawShowForPlayer(playerid, speedom[30]);
	case 71:       TextDrawShowForPlayer(playerid, speedom[31]);
	case 72:       TextDrawShowForPlayer(playerid, speedom[33]);
	case 73:       TextDrawShowForPlayer(playerid, speedom[34]);
	case 74:       TextDrawShowForPlayer(playerid, speedom[35]);
	case 75:       TextDrawShowForPlayer(playerid, speedom[36]);
	case 76:       TextDrawShowForPlayer(playerid, speedom[37]);
	case 77:       TextDrawShowForPlayer(playerid, speedom[38]);
	case 78:       TextDrawShowForPlayer(playerid, speedom[39]);
	case 79:       TextDrawShowForPlayer(playerid, speedom[40]);
	case 80:       TextDrawShowForPlayer(playerid, speedom[41]);
	case 81:       TextDrawShowForPlayer(playerid, speedom[42]);
	case 82:       TextDrawShowForPlayer(playerid, speedom[43]);
	case 83:       TextDrawShowForPlayer(playerid, speedom[44]);
	case 84:       TextDrawShowForPlayer(playerid, speedom[45]);
	case 85:       TextDrawShowForPlayer(playerid, speedom[46]);
	case 86:       TextDrawShowForPlayer(playerid, speedom[47]);
	case 87:       TextDrawShowForPlayer(playerid, speedom[48]);
	case 88:       TextDrawShowForPlayer(playerid, speedom[49]);
	case 89:       TextDrawShowForPlayer(playerid, speedom[50]);
	case 90:       TextDrawShowForPlayer(playerid, speedom[51]);
	case 91:       TextDrawShowForPlayer(playerid, speedom[52]);
	case 92:       TextDrawShowForPlayer(playerid, speedom[53]);
	case 93:       TextDrawShowForPlayer(playerid, speedom[54]);
	case 94:       TextDrawShowForPlayer(playerid, speedom[55]);
	case 95:       TextDrawShowForPlayer(playerid, speedom[56]);
	case 96:       TextDrawShowForPlayer(playerid, speedom[57]);
	case 97:       TextDrawShowForPlayer(playerid, speedom[58]);
	case 98:       TextDrawShowForPlayer(playerid, speedom[59]);
	case 99:       TextDrawShowForPlayer(playerid, speedom[60]);
	case 100:      TextDrawShowForPlayer(playerid, speedom[61]);
	case 101..103: TextDrawShowForPlayer(playerid, speedom[61]);
	case 104..106: TextDrawShowForPlayer(playerid, speedom[62]);
	case 107..109: TextDrawShowForPlayer(playerid, speedom[63]);
	case 110..112: TextDrawShowForPlayer(playerid, speedom[64]);
	case 113..115: TextDrawShowForPlayer(playerid, speedom[65]);
	case 116,117: TextDrawShowForPlayer(playerid, speedom[67]);
	case 118,119: TextDrawShowForPlayer(playerid, speedom[68]);
	case 120,121: TextDrawShowForPlayer(playerid, speedom[69]);
	case 122,123: TextDrawShowForPlayer(playerid, speedom[70]);
	case 124,125: TextDrawShowForPlayer(playerid, speedom[71]);
	case 126,127: TextDrawShowForPlayer(playerid, speedom[72]);
	case 128,129: TextDrawShowForPlayer(playerid, speedom[73]);
	case 130,131: TextDrawShowForPlayer(playerid, speedom[74]);
	case 132,133: TextDrawShowForPlayer(playerid, speedom[75]);
	case 134,135: TextDrawShowForPlayer(playerid, speedom[76]);
	case 136,137: TextDrawShowForPlayer(playerid, speedom[77]);
	case 138,139: TextDrawShowForPlayer(playerid, speedom[78]);
	case 140,141: TextDrawShowForPlayer(playerid, speedom[79]);
	case 142,143: TextDrawShowForPlayer(playerid, speedom[80]);
	case 144,145: TextDrawShowForPlayer(playerid, speedom[81]);
	case 146,147: TextDrawShowForPlayer(playerid, speedom[82]);
	case 148,149: TextDrawShowForPlayer(playerid, speedom[83]);
	case 150,151: TextDrawShowForPlayer(playerid, speedom[84]);
	case 152,153: TextDrawShowForPlayer(playerid, speedom[85]);
	case 154,155: TextDrawShowForPlayer(playerid, speedom[86]);
	case 156,157: TextDrawShowForPlayer(playerid, speedom[87]);
	case 158,159: TextDrawShowForPlayer(playerid, speedom[88]);
	case 160,161: TextDrawShowForPlayer(playerid, speedom[89]);
	case 162,163: TextDrawShowForPlayer(playerid, speedom[90]);
	case 164,165: TextDrawShowForPlayer(playerid, speedom[91]);
	case 166,167: TextDrawShowForPlayer(playerid, speedom[92]);
	case 168,169: TextDrawShowForPlayer(playerid, speedom[93]);
	case 170,171: TextDrawShowForPlayer(playerid, speedom[94]);
	case 172,173: TextDrawShowForPlayer(playerid, speedom[95]);
	case 174,175: TextDrawShowForPlayer(playerid, speedom[96]);
	case 176,177: TextDrawShowForPlayer(playerid, speedom[97]);
	case 178,179: TextDrawShowForPlayer(playerid, speedom[98]);
	case 180,181: TextDrawShowForPlayer(playerid, speedom[99]);
	case 182,183: TextDrawShowForPlayer(playerid, speedom[100]);
	case 184,185: TextDrawShowForPlayer(playerid, speedom[101]);
	case 186,187: TextDrawShowForPlayer(playerid, speedom[102]);
	case 188,189: TextDrawShowForPlayer(playerid, speedom[103]);
	case 190,191: TextDrawShowForPlayer(playerid, speedom[104]);
	case 192,193: TextDrawShowForPlayer(playerid, speedom[105]);
	case 194,195: TextDrawShowForPlayer(playerid, speedom[106]);
	case 196,197: TextDrawShowForPlayer(playerid, speedom[107]);
	case 198,199: TextDrawShowForPlayer(playerid, speedom[108]);
	case 200,201: TextDrawShowForPlayer(playerid, speedom[109]);
	case 202,203: TextDrawShowForPlayer(playerid, speedom[110]);
	case 204:      TextDrawShowForPlayer(playerid, speedom[111]);
	case 205:      TextDrawShowForPlayer(playerid, speedom[112]);
	case 206:      TextDrawShowForPlayer(playerid, speedom[113]);
	case 207:      TextDrawShowForPlayer(playerid, speedom[114]);
	case 208,209: TextDrawShowForPlayer(playerid, speedom[115]);
	case 210,211: TextDrawShowForPlayer(playerid, speedom[116]);
	case 212,213: TextDrawShowForPlayer(playerid, speedom[117]);
	case 214,215: TextDrawShowForPlayer(playerid, speedom[118]);
	case 216,217: TextDrawShowForPlayer(playerid, speedom[119]);
	case 218:      TextDrawShowForPlayer(playerid, speedom[120]);
	default:       TextDrawShowForPlayer(playerid, speedom[121]);
	}
	return 1;
}

stock BikeVeh(i, id){
	switch(id){
	case 509,481,510,441,564,465,464: spedom[i] = 0;
	default: spedom[i] = 1;
	}
	return spedom[i];
}
stock GiveModel(playerid){
	new car = GetPlayerVehicleID(playerid);
	return GetVehicleModel(car);
}
