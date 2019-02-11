//GameMode by Kilav//
//Начал создавать мод в 21.12.2012//

// 4 - FIGHT_STYLE_NORMAL
// 5 - FIGHT_STYLE_BOXING
// 6 - FIGHT_STYLE_KUNGFU
// 7 - FIGHT_STYLE_KNEEHEAD
// 15 - FIGHT_STYLE_GRABKICK
// 26 - FIGHT_STYLE_ELBOW
#include <a_samp>
#include <streamer>
#include <mxini>

#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_GREEN 0x00FF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define RED 0xFF0000AA
#define YELLOW 0xFFFF00AA
#define RADIO 3000
#define COLOR_RED 0xFF0000AA
#define SLOT 1
#define OKNOPRI             1
#define COLOR_ORANGE 0xFF9900AA
#define ADMINFS_MESSAGE_COLOR 0x00FF00AA
#define PM_INCOMING_COLOR     0xFF0000AA
#define PM_OUTGOING_COLOR     0x00FF00AA
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#pragma tabsize 0

new HostName[3][] = {
"(UA|RUS)•CУПЕРСКИЙ•Д]R[IФТ•ЗА]X[oДиТе!!!",
"(UA|RUS)•CУПЕРСКИЙ•Д]R[IФТ•ЗА]X[oДиТе!!!",
"(UA|RUS)•CУПЕРСКИЙ•Д]R[IФТ•ЗА]X[oДиТе!!!"
};
new ta4ka[MAX_PLAYERS];
//DALNOBOY4IK
new Fura[2],Pricep[10],Text3D:Pricep3dtext[10],Checkpoint[MAX_PLAYERS];
//DALNOBOY4IK
new ta4katest[MAX_PLAYERS];
new neon[MAX_PLAYERS][4];
new countdown[MAX_PLAYERS];
new shapka[MAX_PLAYERS];
new Text:Times;
new Text:prostomap;
new Text3D:status[MAX_PLAYERS];
new migalki[MAX_PLAYERS][2];
new h[MAX_PLAYERS],m[MAX_PLAYERS];
//Грузчик
// Это массив с координатами "подбора" груза
new Float:checkLoader[7][3] = {
{-147.6650, 1112.1145, 19.7500},
{-147.7197, 1126.3038, 19.7422},
{-119.9986, 1136.4095, 19.7422},
{-102.0431, 1129.7157, 19.7500},
{-77.8152, 1133.7041, 19.7422},
{-83.7967, 1124.8478, 19.7422},
{-79.5303, 1111.5229, 19.7500}
};
// А здесь координаты "разгрузки"
new Float:checkLoaderUnload[3][3] = {
{-110.3317, 1117.3340, 19.7422},
{-113.2839, 1117.6509, 19.7422},
{-107.6272, 1117.7480, 19.7422}
};
new hereCheckLoader[MAX_PLAYERS];
new hereCheckUnLoader[MAX_PLAYERS];
new drawer[MAX_PLAYERS];
//Грузчик

enum pInfo {
    pMoney,
    pAdmin,
    pScore,
};
new PlayerInfo[MAX_PLAYERS][pInfo];

new Float:RandomSpawn[][4] = {
	{-35.0012, -2053.9026, 4.2100},
	{-2648.0852, -28.9023, 6.8332},
	{836.17846679688,-2046.5209960938,14.065537452698},
	{-325.1331,1533.0276,75.3594},
	{-1665.5055, -240.7661, 20.7860},
	{-2686.0317, 1253.7795, 58.3045},
	{-35.2330, -2053.7017, 5.2701}
};
forward SetName();
forward settime(playerid);
forward Countdown();
forward Check();
forward OtherTimer();
forward AutoRepair();
forward AutoFlip();
forward FireworksSystem();
forward UpdateFireworksSystem();
forward DestroyPickups();
//=========DALNOBOY4IK
forward RazgruzFurui(playerid);
//=========DALNOBOY4IK
forward SaveAccounts();


main()
{
	print("\n----------------------------------");
	print("Drift_Russian\nBy Kilav");
    print("\n----------------------------------");

}

public AutoRepair()
{
	for(new playerid=0; playerid<MAX_PLAYERS; playerid++)
	{
	    if (IsPlayerInAnyVehicle(playerid))
	    {
			new Float:CarHP;
			GetVehicleHealth(GetPlayerVehicleID(playerid), CarHP);
            if (CarHP < 1000)
            {
				RepairVehicle(GetPlayerVehicleID(playerid));
			}
		}
	}
	return 1;
}
public OnGameModeInit()
{
	//===============Работа дальнобойщика
	Fura[0] = AddStaticVehicleEx(515,12.1930,-224.1917,6.4553,90.0913,-1,-1,180); // Фура № 1
	AddStaticVehicleEx(515,12.2435,-232.4889,6.4411,89.7957,-1,-1,180); // Фура № 2
	AddStaticVehicleEx(515,12.2912,-240.7080,6.4506,89.8790,-1,-1,180); // Фура № 3
	AddStaticVehicleEx(403,12.8029,-248.9818,6.0362,90.7330,-1,-1,180); // Фура
	AddStaticVehicleEx(403,12.9481,-257.2370,6.0355,90.5530,-1,-1,180); // Фура
	AddStaticVehicleEx(403,12.8305,-265.2685,6.0354,89.7056,-1,-1,180); // Фура
	AddStaticVehicleEx(514,-18.8261,-220.4126,6.0162,175.5331,-1,-1,180); // Фура
	AddStaticVehicleEx(514,-26.6368,-219.4905,6.0159,175.7046,-1,-1,180); // Фура
	Fura[1] = AddStaticVehicleEx(514,-34.4157,-218.6096,6.0108,175.0944,-1,-1,180); // Фура
	Pricep[0] = AddStaticVehicleEx(435,-55.1299,-224.4092,6.0257,266.6206,-1,-1,180); // Прицеп № 1
	Pricep[1] = AddStaticVehicleEx(435,-23.1413,-274.3386,6.0080,180.5373,-1,-1,180); // Прицеп № 2
	Pricep[2] = AddStaticVehicleEx(435,-14.7631,-274.5206,6.0191,180.1252,-1,-1,180); // Прицеп № 3
	Pricep[3] = AddStaticVehicleEx(584,-61.6196,-321.5299,6.0160,270.4092,-1,-1,180); // Прицеп
	Pricep[4] = AddStaticVehicleEx(591,-61.4658,-307.4087,6.0192,270.4079,-1,-1,180); // Прицеп
	Pricep[5] = AddStaticVehicleEx(450,-1.2615,-339.9842,6.0233,89.0408,-1,-1,180); // Прицеп
	Pricep[6] = AddStaticVehicleEx(450,-1.2152,-322.3202,6.0038,89.9523,-1,-1,180); // Прицеп
	Pricep[7] = AddStaticVehicleEx(450,-1.1001,-301.1582,6.0088,89.6910,-1,-1,180); // Прицеп
	Pricep[8] = AddStaticVehicleEx(591,-116.4185,-322.6622,2.0134,179.6741,-1,-1,180); // Прицеп
	Pricep[9] = AddStaticVehicleEx(584,-231.7576,-190.1307,2.0194,259.2906,-1,-1,180); // Прицеп
	Pricep3dtext[0] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Аммуниция{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[0], Pricep[0], 0.0, 0.0, 0.0);
	Pricep3dtext[1] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Спиртные напитки{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[1], Pricep[1], 0.0, 0.0, 0.0);
	Pricep3dtext[2] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Одежда{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[2], Pricep[2], 0.0, 0.0, 0.0);
	Pricep3dtext[3] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Бензин{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[3], Pricep[3], 0.0, 0.0, 0.0);
	Pricep3dtext[4] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Подпольный склад компонентов тюнинга{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[4], Pricep[4], 0.0, 0.0, 0.0);
	Pricep3dtext[5] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Щебень{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[5], Pricep[5], 0.0, 0.0, 0.0);
	Pricep3dtext[6] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Песок{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[6], Pricep[6], 0.0, 0.0, 0.0);
	Pricep3dtext[7] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Известняк{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[7], Pricep[7], 0.0, 0.0, 0.0);
	Pricep3dtext[8] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Замороженные продукты{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[8], Pricep[8], 0.0, 0.0, 0.0);
	Pricep3dtext[9] = Create3DTextLabel("{ffa500}[Груз: {FFFFFF}Бензин{ffa500}]", YELLOW, 0.0, 0.0, -100.0, 50.0, 0, 1);
	Attach3DTextLabelToVehicle(Pricep3dtext[9], Pricep[9], 0.0, 0.0, 0.0);
	//===============Работа дальнобойщика
	//===================================
	 prostomap = TextDrawCreate(499.000000,4.000000,"        ");
         TextDrawAlignment(prostomap,0);
         TextDrawBackgroundColor(prostomap,0x00000066);
         TextDrawFont(prostomap,3);
         TextDrawLetterSize(prostomap,0.299999,1.300000);
         TextDrawColor(prostomap,0xffffffff);
         TextDrawSetOutline(prostomap,1);
         TextDrawSetProportional(prostomap,1);
         SetTimer("OtherTimer", 1000, 1);
	//===================================
    new p = GetMaxPlayers();
for(new i=0; i < p; i++)
    {
        SetPVarInt(i, "laser", 0);
        SetPVarInt(i, "color", 18643);
    }

	SetGameModeText("Drift_Russian v1.3");//game mode name
	SetTimer("Check",1000,1);//таймер для проверки
	SetTimer("Countdown",1000,1);//таймер отсчёта
	SetTimer("AutoRepair", 1000, true);

	SetTimer("settime",1000,true);
	Times = TextDrawCreate(551.000000, 431.000000, "--");
	TextDrawBackgroundColor(Times, 255);
	TextDrawFont(Times, 3);
	TextDrawLetterSize(Times, 0.549999, 1.700000);
	TextDrawColor(Times, 16711935);
	TextDrawSetOutline(Times, 1);
	TextDrawSetProportional(Times, 1);

	AllowAdminTeleport(1);
 	Create3DTextLabel("Добро пожаловать к нам на сервер!\nСвязь сомной:\nСкайп: ar161ru\nГл. Админ: Sanya161RU\nНа сервере есть меню, вызвать его можно на\nALT(пешком) и на 2 (в машине)",0x00FFFFAA,-35.2330, -2053.7017, 5.2701,50.0,0,1);

	new rand = random(sizeof(RandomSpawn));	//классы
	AddPlayerClass(217,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(60,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(188,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(172,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(185,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(115,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(110,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(121,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(122,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(123,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(185,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(286,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(23,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(217,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(19,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(22,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(21,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(223,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(214,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(285,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(149,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(89,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
    AddPlayerClass(90,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(91,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(93,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(141,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(152,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(169,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(192,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
	AddPlayerClass(216,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2], RandomSpawn[rand][3],0,-1,46,-1,43,40);
		//Ухо
	CreateDynamicObject(16092, -302.22, 1508.37, 74.00,   0.00, 0.00, 90.00);
	CreateDynamicObject(12929, -267.79, 1540.69, 73.39,   0.00, 0.00, 45.00);
	CreateDynamicObject(12929, -273.55, 1546.45, 73.39,   0.00, 0.00, 45.00);
	CreateDynamicObject(12929, -279.37, 1552.20, 73.39,   0.00, 0.00, 45.00);
	CreateDynamicObject(12929, -285.17, 1558.03, 73.38,   0.00, 0.00, 45.00);
	CreateDynamicObject(979, -285.76, 1569.14, 75.11,   0.00, 0.00, 135.00);
	CreateDynamicObject(979, -292.39, 1575.79, 75.11,   0.00, 0.00, 135.00);
	CreateDynamicObject(979, -298.95, 1582.35, 75.11,   0.00, 0.00, 135.00);
	CreateDynamicObject(979, -305.60, 1582.36, 75.11,   0.00, 0.00, 225.00);
	CreateDynamicObject(979, -312.19, 1575.78, 75.11,   0.00, 0.00, 225.00);
	CreateDynamicObject(983, -317.42, 1570.46, 75.00,   0.00, 0.00, 135.00);
	CreateDynamicObject(983, -317.44, 1565.92, 75.00,   0.00, 0.00, 224.00);
	CreateDynamicObject(983, -312.96, 1561.36, 75.00,   0.00, 0.00, 224.00);
	CreateDynamicObject(711, -319.60, 1568.15, 79.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -311.04, 1558.88, 79.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(737, -338.11, 1538.03, 74.62,   0.00, 0.00, 40.00);
	CreateDynamicObject(3281, -302.18, 1535.90, 75.20,   0.00, 0.00, -40.00);
	CreateDynamicObject(3281, -304.89, 1538.17, 75.20,   0.00, 0.00, -40.00);
	CreateDynamicObject(3281, -261.18, 1541.57, 75.20,   0.00, 0.00, 43.00);
	CreateDynamicObject(3281, -261.18, 1541.57, 75.97,   0.00, 0.00, 43.00);
	CreateDynamicObject(987, -321.46, 1508.12, 74.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, -333.42, 1508.16, 74.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, -345.36, 1508.20, 74.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, -356.73, 1511.76, 74.00,   0.00, 0.00, -18.00);
	CreateDynamicObject(710, -308.95, 1508.28, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -295.36, 1508.40, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -299.09, 1509.22, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -300.61, 1509.29, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -302.10, 1509.30, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -303.64, 1509.30, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -305.17, 1509.30, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -302.49, 1404.66, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -305.48, 1402.01, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -309.41, 1401.55, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.13, 1403.74, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -293.82, 1394.35, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -301.00, 1389.73, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -309.59, 1388.29, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -318.40, 1392.01, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -359.73, 1392.51, 57.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -356.80, 1387.24, 57.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -353.72, 1381.97, 57.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -350.67, 1376.49, 57.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.18, 1330.22, 52.72,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.00, 1327.88, 52.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.06, 1324.90, 52.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.79, 1321.13, 52.17,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -314.43, 1317.55, 51.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -316.70, 1313.58, 51.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -320.14, 1310.61, 51.23,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -313.16, 1331.54, 58.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -310.98, 1331.61, 58.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -308.91, 1331.41, 58.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -326.75, 1328.48, 58.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -327.52, 1324.95, 57.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -330.21, 1322.73, 57.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -333.30, 1323.27, 56.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -336.52, 1325.74, 56.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -347.89, 1317.55, 55.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -351.25, 1320.93, 55.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -340.25, 1328.91, 55.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -357.44, 1355.82, 47.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -369.13, 1350.36, 47.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -372.09, 1355.65, 47.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -361.00, 1362.84, 46.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -363.89, 1368.30, 46.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -374.85, 1360.37, 47.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -411.81, 1433.71, 41.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -401.91, 1445.23, 40.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -404.75, 1448.74, 40.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -408.68, 1451.70, 40.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -412.88, 1453.72, 39.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -417.95, 1454.92, 39.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -422.81, 1455.00, 39.04,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -428.83, 1454.02, 38.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -432.73, 1452.57, 38.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -413.90, 1436.97, 39.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -417.94, 1439.98, 39.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -422.64, 1440.26, 38.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -426.68, 1438.35, 38.16,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -430.46, 1436.16, 38.16,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -433.94, 1433.76, 38.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -437.84, 1432.20, 37.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -441.61, 1431.41, 38.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -445.26, 1430.66, 38.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -443.54, 1431.23, 33.00,   0.00, 0.00, 11.00);
	CreateDynamicObject(3281, -446.86, 1430.55, 33.00,   0.00, 0.00, 11.00);
	CreateDynamicObject(3281, -439.75, 1431.97, 33.00,   0.00, 0.00, 11.00);
	CreateDynamicObject(3281, -435.98, 1433.03, 33.00,   0.00, 0.00, 18.00);
	CreateDynamicObject(3877, -431.90, 1434.72, 33.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -428.41, 1437.28, 33.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -424.72, 1439.79, 33.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -420.05, 1440.81, 33.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -433.81, 1451.67, 34.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -435.73, 1450.96, 34.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -430.85, 1453.32, 34.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -426.03, 1454.47, 34.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -437.59, 1466.93, 33.04,   0.00, 0.00, -84.00);
	CreateDynamicObject(981, -440.58, 1497.42, 33.68,   0.00, 0.00, -84.00);
	CreateDynamicObject(710, -442.21, 1512.24, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -454.86, 1512.73, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -455.63, 1521.19, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -442.74, 1521.77, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -443.48, 1529.58, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -456.26, 1528.10, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -427.69, 1670.51, 37.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -416.77, 1663.39, 37.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -395.70, 1741.41, 41.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -391.87, 1750.14, 41.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -390.36, 1753.07, 41.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -396.96, 1738.31, 41.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -405.75, 1926.26, 57.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -393.97, 1920.11, 57.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -385.63, 1909.28, 57.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -418.26, 1927.27, 57.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -399.41, 1903.09, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -403.20, 1907.69, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -409.22, 1910.78, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -415.57, 1911.26, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -421.57, 1908.98, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -427.40, 1758.64, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -417.72, 1769.89, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -439.29, 1752.07, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -453.23, 1750.63, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -467.46, 1757.56, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -456.16, 1769.28, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -451.12, 1766.55, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -444.45, 1767.12, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -437.19, 1770.98, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -432.25, 1776.73, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -484.86, 1947.42, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -486.99, 1934.99, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -486.36, 1923.83, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -472.08, 1943.34, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -473.17, 1934.73, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -472.95, 1925.60, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -371.87, 2071.44, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -378.52, 2081.62, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -388.05, 2088.10, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -398.67, 2090.33, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -410.14, 2086.20, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -401.39, 2073.09, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -394.11, 2073.55, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -389.57, 2070.64, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -386.83, 2066.62, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -386.30, 2063.10, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -398.38, 2074.39, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -508.90, 1984.00, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -514.83, 1982.64, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -514.55, 1984.71, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -519.62, 1985.92, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -520.97, 1982.44, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -526.17, 1984.10, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -526.17, 1984.10, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -523.86, 1988.66, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -539.73, 1981.25, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -531.65, 1976.02, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -521.81, 1973.71, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -509.43, 1975.03, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -498.03, 1978.60, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -543.73, 2000.45, 59.00,   0.00, 0.00, -40.00);
	CreateDynamicObject(3877, -562.43, 2015.04, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -576.84, 2024.71, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -595.43, 2035.37, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -613.22, 2043.60, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -633.12, 2051.65, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -661.55, 2059.52, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -686.89, 2062.46, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -703.72, 2062.76, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -726.36, 2061.76, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -747.89, 2058.46, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -794.12, 2045.40, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -811.84, 2037.24, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -832.78, 2025.49, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -849.98, 2012.37, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -874.89, 1993.20, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -876.48, 1988.60, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -879.89, 1992.04, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -882.66, 1987.48, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -879.86, 1984.76, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -882.89, 1982.42, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -883.50, 1978.88, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -894.03, 1982.00, 60.00,   0.00, 0.00, -91.00);
	CreateDynamicObject(3281, -894.00, 1985.59, 60.00,   0.00, 0.00, -91.00);
	CreateDynamicObject(3281, -893.95, 1989.16, 60.00,   0.00, 0.00, -91.00);
	CreateDynamicObject(3281, -893.91, 1992.78, 60.00,   0.00, 0.00, -91.00);
	CreateDynamicObject(8556, -904.00, 1998.47, 63.97,   0.00, 0.00, 40.00);
	CreateDynamicObject(3877, -845.85, 1850.21, 60.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -858.90, 1848.91, 60.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -849.57, 1817.99, 59.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -853.00, 1810.05, 59.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -857.43, 1804.18, 59.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -847.33, 1825.11, 59.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1049.74, 1854.08, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1041.39, 1841.07, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1046.70, 1837.40, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1054.59, 1850.92, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1134.88, 1795.56, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1143.57, 1794.02, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1149.75, 1792.84, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1156.13, 1792.25, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1169.27, 1792.19, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1181.00, 1792.23, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1170.66, 1804.71, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1188.95, 1804.78, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1180.17, 1804.90, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1184.40, 1805.08, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1175.40, 1804.63, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1184.29, 1792.33, 39.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(16092, -1191.04, 1798.33, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1187.96, 1792.37, 39.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(8483, -373.25, 1492.06, 72.27,   0.00, 0.00, -73.98);
	CreateDynamicObject(3877, -342.52, 1461.54, 65.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -346.12, 1466.18, 64.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -351.94, 1470.21, 64.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -359.74, 1471.65, 64.19,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -367.10, 1471.33, 63.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -374.57, 1469.10, 62.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -377.95, 1467.96, 70.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -388.10, 1451.63, 68.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -355.04, 1453.80, 72.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -362.79, 1456.65, 71.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -370.27, 1453.83, 70.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -370.74, 1447.56, 69.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -368.72, 1440.16, 69.11,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, -1196.80, 1792.25, 41.22,   0.00, 0.00, -4.32);
	CreateDynamicObject(3578, -1206.57, 1793.61, 41.22,   0.00, 0.00, -11.34);
	CreateDynamicObject(3578, -1216.68, 1795.63, 41.22,   0.00, 0.00, -11.34);
	CreateDynamicObject(3578, -1221.32, 1801.68, 41.22,   0.00, 0.00, -91.02);
	CreateDynamicObject(3578, -1216.10, 1816.36, 41.22,   0.00, 0.00, -188.70);
	CreateDynamicObject(979, -273.88, 1529.04, 75.11,   0.00, 0.00, 403.26);
	CreateDynamicObject(979, -280.74, 1522.77, 75.11,   0.00, 0.00, 402.12);
	CreateDynamicObject(979, -287.65, 1516.53, 75.11,   0.00, 0.00, 402.12);
	CreateDynamicObject(979, -292.64, 1511.99, 75.11,   0.00, 0.00, 402.12);
	CreateDynamicObject(979, -347.05, 1530.27, 75.12,   0.00, 0.00, -90.06);
	CreateDynamicObject(979, -347.05, 1520.96, 75.12,   0.00, 0.00, -90.06);
	CreateDynamicObject(979, -347.05, 1513.18, 75.12,   0.00, 0.00, -90.06);
	CreateDynamicObject(714, -348.89, 1532.93, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(714, -349.14, 1517.23, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -882.34, 1964.71, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -880.82, 1958.41, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -879.41, 1952.67, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -877.84, 1946.30, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -876.17, 1940.84, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -874.67, 1935.31, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -873.11, 1929.37, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -871.28, 1922.84, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -869.26, 1915.45, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -867.19, 1908.31, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -865.10, 1900.65, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -863.14, 1893.99, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -861.33, 1887.27, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -859.34, 1879.73, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -857.23, 1871.73, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -855.10, 1863.29, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -852.86, 1852.81, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(979, -1160.98, 1792.23, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1170.25, 1792.24, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1179.60, 1792.24, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1151.33, 1792.33, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1175.08, 1804.49, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1184.38, 1804.49, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, -1221.08, 1811.83, 41.22,   0.00, 0.00, -91.02);
	CreateDynamicObject(3578, -1207.28, 1814.97, 41.22,   0.00, 0.00, -188.70);
	CreateDynamicObject(3578, -1195.19, 1808.22, 41.22,   0.00, 0.00, -218.22);
	CreateDynamicObject(3578, -1198.81, 1811.04, 41.22,   0.00, 0.00, -218.22);
	CreateDynamicObject(979, -305.19, 1534.56, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(979, -314.53, 1534.55, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(979, -321.33, 1534.55, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(979, -333.48, 1534.57, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(979, -342.25, 1534.55, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(710, -295.34, 1501.45, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -294.84, 1494.10, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -293.95, 1484.66, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -308.53, 1501.33, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -307.64, 1492.86, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -306.95, 1485.67, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(16151, -300.29, 1541.16, 74.89,   0.00, 0.00, 135.06);
	CreateDynamicObject(18655, -298.20, 1545.12, 77.04,   -4.00, -18.00, 93.00);
	CreateDynamicObject(714, -312.37, 1539.49, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(714, -270.35, 1530.84, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(714, -286.46, 1515.81, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(714, -290.96, 1576.52, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -384.52, 1460.99, 68.92,   0.00, 0.00, 0.00);
	//////////////////АВТО//////////////////////////
	CreateVehicle(562, -283.4048, 1559.3527, 74.9563, 135.3600, -1, -1, 100);
	CreateVehicle(562, -283.4048, 1559.3527, 74.9563, 135.3600, -1, -1, 100);
	CreateVehicle(560, -278.3853, 1554.3157, 74.9176, 133.4400, -1, -1, 100);
	CreateVehicle(560, -270.9072, 1549.2454, 74.9176, 133.4400, -1, -1, 100);
	CreateVehicle(562, -265.5812, 1542.5355, 74.8834, 133.0199, -1, -1, 100);

	//Drag 1
	CreateDynamicObject(18789, 843.38714599609, -2142.3776855469, 11.420000076294, 0, 0, 270);
	CreateDynamicObject(18789, 829.52862548828, -2142.5529785156, 11.420000076294, 0, 0, 270);
	CreateDynamicObject(18789, 829.52752685547, -2292.3359375, 11.420000076294, 0, 0, 270);
	CreateDynamicObject(18789, 843.3876953125, -2292.375, 11.420000076294, 0, 0, 270);
	CreateDynamicObject(16089, 829.419921875, -2068.3601074219, 11.8671875, 0, 0, 270);
	CreateDynamicObject(16089, 843.4345703125, -2068.3671875, 11.8671875, 0, 0, 270);
	CreateDynamicObject(18789, 843.38586425781, -2440.7834472656, 11.420000076294, 0, 0, 270);
	CreateDynamicObject(18789, 829.52264404297, -2440.7778320313, 11.420000076294, 0, 0, 270);
	CreateDynamicObject(8040, 843.62536621094, -2533.6926269531, 10.974996566772, 0, 0, 180);
	CreateDynamicObject(984, 804.22613525391, -2530.5849609375, 10.853678703308, 0, 0, 0);
	CreateDynamicObject(984, 804.22961425781, -2543.3676757813, 10.853678703308, 0, 0, 0);
	CreateDynamicObject(1696, 824.51470947266, -2518.1364746094, 10.74160861969, 0, 0, 0);
	CreateDynamicObject(1696, 829.91979980469, -2518.1245117188, 10.74160861969, 0, 0, 0);
	CreateDynamicObject(1696, 832.39581298828, -2518.1052246094, 10.74160861969, 0, 0, 0);
	CreateDynamicObject(1696, 839.95446777344, -2518.1162109375, 10.74160861969, 0, 0, 0);
	CreateDynamicObject(1696, 845.33477783203, -2518.1081542969, 10.74160861969, 0, 0, 0);
	CreateDynamicObject(1696, 847.88812255859, -2518.1345214844, 10.74160861969, 0, 0, 0);
	CreateDynamicObject(16089, 843.48541259766, -2514.9204101563, 11.763750076294, 0, 0, 270);
	CreateDynamicObject(16089, 829.37890625, -2514.9228515625, 11.763750076294, 0, 0, 270);
    //Chiliad
	CreateDynamicObject(1237,-2305.45556641,-1671.97753906,482.54373169,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (2)
	CreateDynamicObject(1237,-2298.87573242,-1668.56005859,482.66110229,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (3)
	CreateDynamicObject(1237,-2312.50537109,-1676.37780762,481.44485474,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (4)
	CreateDynamicObject(1237,-2316.79223633,-1682.30334473,481.44485474,0.00000000,0.00000000,0.00000000); //object(strtbarrier01) (5)
	CreateDynamicObject(11611,-2346.55102539,-1830.23852539,432.25942993,0.00000000,0.00000000,292.00000000); //object(des_sherrifsgn02) (2)
	CreateDynamicObject(978,-2527.05493164,-1714.80871582,401.87835693,0.00000000,0.00000000,244.00000000); //object(sub_roadright) (1)
	CreateDynamicObject(979,-2787.48730469,-1752.90429688,141.38078308,0.00000000,0.00000000,288.00000000); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2434.29711914,-2085.10815430,123.70716858,0.00000000,352.00000000,171.99993896); //object(sub_roadleft) (2)
	CreateDynamicObject(979,-2443.03198242,-2082.44042969,124.53217316,0.00000000,357.99645996,153.99645996); //object(sub_roadleft) (4)
	CreateDynamicObject(18275,-2348.97875977,-2216.12744141,27.79026604,0.00000000,0.00000000,0.00000000); //object(cw2_mtbfinish) (1)
////////////////////////////УХО_2012///////////////////////////////////
	CreateDynamicObject(16092, -302.22, 1508.37, 74.00,   0.00, 0.00, 90.00);
	CreateDynamicObject(12929, -267.79, 1540.69, 73.39,   0.00, 0.00, 45.00);
	CreateDynamicObject(12929, -273.55, 1546.45, 73.39,   0.00, 0.00, 45.00);
	CreateDynamicObject(12929, -279.37, 1552.20, 73.39,   0.00, 0.00, 45.00);
	CreateDynamicObject(12929, -285.17, 1558.03, 73.38,   0.00, 0.00, 45.00);
	CreateDynamicObject(979, -285.76, 1569.14, 75.11,   0.00, 0.00, 135.00);
	CreateDynamicObject(979, -292.39, 1575.79, 75.11,   0.00, 0.00, 135.00);
	CreateDynamicObject(979, -298.95, 1582.35, 75.11,   0.00, 0.00, 135.00);
	CreateDynamicObject(979, -305.60, 1582.36, 75.11,   0.00, 0.00, 225.00);
	CreateDynamicObject(979, -312.19, 1575.78, 75.11,   0.00, 0.00, 225.00);
	CreateDynamicObject(983, -317.42, 1570.46, 75.00,   0.00, 0.00, 135.00);
	CreateDynamicObject(983, -317.44, 1565.92, 75.00,   0.00, 0.00, 224.00);
	CreateDynamicObject(983, -312.96, 1561.36, 75.00,   0.00, 0.00, 224.00);
	CreateDynamicObject(711, -319.60, 1568.15, 79.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -311.04, 1558.88, 79.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(737, -338.11, 1538.03, 74.62,   0.00, 0.00, 40.00);
	CreateDynamicObject(3281, -302.18, 1535.90, 75.20,   0.00, 0.00, -40.00);
	CreateDynamicObject(3281, -304.89, 1538.17, 75.20,   0.00, 0.00, -40.00);
	CreateDynamicObject(3281, -261.18, 1541.57, 75.20,   0.00, 0.00, 43.00);
	CreateDynamicObject(3281, -261.18, 1541.57, 75.97,   0.00, 0.00, 43.00);
	CreateDynamicObject(987, -321.46, 1508.12, 74.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, -333.42, 1508.16, 74.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, -345.36, 1508.20, 74.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, -356.73, 1511.76, 74.00,   0.00, 0.00, -18.00);
	CreateDynamicObject(710, -308.95, 1508.28, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -295.36, 1508.40, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -299.09, 1509.22, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -300.61, 1509.29, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -302.10, 1509.30, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -303.64, 1509.30, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -305.17, 1509.30, 81.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -302.49, 1404.66, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -305.48, 1402.01, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -309.41, 1401.55, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.13, 1403.74, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -293.82, 1394.35, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -301.00, 1389.73, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -309.59, 1388.29, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -318.40, 1392.01, 72.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -359.73, 1392.51, 57.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -356.80, 1387.24, 57.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -353.72, 1381.97, 57.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -350.67, 1376.49, 57.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.18, 1330.22, 52.72,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.00, 1327.88, 52.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.06, 1324.90, 52.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -312.79, 1321.13, 52.17,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -314.43, 1317.55, 51.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -316.70, 1313.58, 51.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -320.14, 1310.61, 51.23,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -313.16, 1331.54, 58.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -310.98, 1331.61, 58.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -308.91, 1331.41, 58.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -326.75, 1328.48, 58.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -327.52, 1324.95, 57.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -330.21, 1322.73, 57.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -333.30, 1323.27, 56.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -336.52, 1325.74, 56.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -347.89, 1317.55, 55.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -351.25, 1320.93, 55.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -340.25, 1328.91, 55.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -357.44, 1355.82, 47.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -369.13, 1350.36, 47.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -372.09, 1355.65, 47.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -361.00, 1362.84, 46.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -363.89, 1368.30, 46.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -374.85, 1360.37, 47.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -411.81, 1433.71, 41.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -401.91, 1445.23, 40.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -404.75, 1448.74, 40.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -408.68, 1451.70, 40.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -412.88, 1453.72, 39.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -417.95, 1454.92, 39.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -422.81, 1455.00, 39.04,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -428.83, 1454.02, 38.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -432.73, 1452.57, 38.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -413.90, 1436.97, 39.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -417.94, 1439.98, 39.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -422.64, 1440.26, 38.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -426.68, 1438.35, 38.16,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -430.46, 1436.16, 38.16,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -433.94, 1433.76, 38.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -437.84, 1432.20, 37.65,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -441.61, 1431.41, 38.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -445.26, 1430.66, 38.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -443.54, 1431.23, 33.00,   0.00, 0.00, 11.00);
	CreateDynamicObject(3281, -446.86, 1430.55, 33.00,   0.00, 0.00, 11.00);
	CreateDynamicObject(3281, -439.75, 1431.97, 33.00,   0.00, 0.00, 11.00);
	CreateDynamicObject(3281, -435.98, 1433.03, 33.00,   0.00, 0.00, 18.00);
	CreateDynamicObject(3877, -431.90, 1434.72, 33.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -428.41, 1437.28, 33.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -424.72, 1439.79, 33.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -420.05, 1440.81, 33.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -433.81, 1451.67, 34.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -435.73, 1450.96, 34.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -430.85, 1453.32, 34.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -426.03, 1454.47, 34.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -437.59, 1466.93, 33.04,   0.00, 0.00, -84.00);
	CreateDynamicObject(981, -440.58, 1497.42, 33.68,   0.00, 0.00, -84.00);
	CreateDynamicObject(710, -442.21, 1512.24, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -454.86, 1512.73, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -455.63, 1521.19, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -442.74, 1521.77, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -443.48, 1529.58, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -456.26, 1528.10, 38.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -427.69, 1670.51, 37.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -416.77, 1663.39, 37.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -395.70, 1741.41, 41.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -391.87, 1750.14, 41.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -390.36, 1753.07, 41.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -396.96, 1738.31, 41.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -405.75, 1926.26, 57.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -393.97, 1920.11, 57.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -385.63, 1909.28, 57.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -418.26, 1927.27, 57.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -399.41, 1903.09, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -403.20, 1907.69, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -409.22, 1910.78, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -415.57, 1911.26, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -421.57, 1908.98, 58.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -427.40, 1758.64, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -417.72, 1769.89, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -439.29, 1752.07, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -453.23, 1750.63, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -467.46, 1757.56, 71.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -456.16, 1769.28, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -451.12, 1766.55, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -444.45, 1767.12, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -437.19, 1770.98, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -432.25, 1776.73, 72.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -484.86, 1947.42, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -486.99, 1934.99, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -486.36, 1923.83, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -472.08, 1943.34, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -473.17, 1934.73, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -472.95, 1925.60, 86.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -371.87, 2071.44, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -378.52, 2081.62, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -388.05, 2088.10, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -398.67, 2090.33, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -410.14, 2086.20, 60.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -401.39, 2073.09, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -394.11, 2073.55, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -389.57, 2070.64, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -386.83, 2066.62, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -386.30, 2063.10, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -398.38, 2074.39, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -508.90, 1984.00, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -514.83, 1982.64, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -514.55, 1984.71, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -519.62, 1985.92, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -520.97, 1982.44, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -526.17, 1984.10, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -526.17, 1984.10, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -523.86, 1988.66, 59.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -539.73, 1981.25, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -531.65, 1976.02, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -521.81, 1973.71, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -509.43, 1975.03, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -498.03, 1978.60, 61.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -543.73, 2000.45, 59.00,   0.00, 0.00, -40.00);
	CreateDynamicObject(3877, -562.43, 2015.04, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -576.84, 2024.71, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -595.43, 2035.37, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -613.22, 2043.60, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -633.12, 2051.65, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -661.55, 2059.52, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -686.89, 2062.46, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -703.72, 2062.76, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -726.36, 2061.76, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -747.89, 2058.46, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -794.12, 2045.40, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -811.84, 2037.24, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -832.78, 2025.49, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -849.98, 2012.37, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -874.89, 1993.20, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -876.48, 1988.60, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -879.89, 1992.04, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -882.66, 1987.48, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -879.86, 1984.76, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -882.89, 1982.42, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -883.50, 1978.88, 59.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -894.03, 1982.00, 60.00,   0.00, 0.00, -91.00);
	CreateDynamicObject(3281, -894.00, 1985.59, 60.00,   0.00, 0.00, -91.00);
	CreateDynamicObject(3281, -893.95, 1989.16, 60.00,   0.00, 0.00, -91.00);
	CreateDynamicObject(3281, -893.91, 1992.78, 60.00,   0.00, 0.00, -91.00);
	CreateDynamicObject(8556, -904.00, 1998.47, 63.97,   0.00, 0.00, 40.00);
	CreateDynamicObject(3877, -845.85, 1850.21, 60.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -858.90, 1848.91, 60.59,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -849.57, 1817.99, 59.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -853.00, 1810.05, 59.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -857.43, 1804.18, 59.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -847.33, 1825.11, 59.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1049.74, 1854.08, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1041.39, 1841.07, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1046.70, 1837.40, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1054.59, 1850.92, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1134.88, 1795.56, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1143.57, 1794.02, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1149.75, 1792.84, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1156.13, 1792.25, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1169.27, 1792.19, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1181.00, 1792.23, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1170.66, 1804.71, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1188.95, 1804.78, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1180.17, 1804.90, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1184.40, 1805.08, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1175.40, 1804.63, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1184.29, 1792.33, 39.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(16092, -1191.04, 1798.33, 40.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1187.96, 1792.37, 39.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(8483, -373.25, 1492.06, 72.27,   0.00, 0.00, -73.98);
	CreateDynamicObject(3877, -342.52, 1461.54, 65.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -346.12, 1466.18, 64.91,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -351.94, 1470.21, 64.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -359.74, 1471.65, 64.19,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -367.10, 1471.33, 63.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -374.57, 1469.10, 62.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -377.95, 1467.96, 70.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -388.10, 1451.63, 68.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -355.04, 1453.80, 72.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -362.79, 1456.65, 71.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -370.27, 1453.83, 70.36,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -370.74, 1447.56, 69.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -368.72, 1440.16, 69.11,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, -1196.80, 1792.25, 41.22,   0.00, 0.00, -4.32);
	CreateDynamicObject(3578, -1206.57, 1793.61, 41.22,   0.00, 0.00, -11.34);
	CreateDynamicObject(3578, -1216.68, 1795.63, 41.22,   0.00, 0.00, -11.34);
	CreateDynamicObject(3578, -1221.32, 1801.68, 41.22,   0.00, 0.00, -91.02);
	CreateDynamicObject(3578, -1216.10, 1816.36, 41.22,   0.00, 0.00, -188.70);
	CreateDynamicObject(979, -273.88, 1529.04, 75.11,   0.00, 0.00, 403.26);
	CreateDynamicObject(979, -280.74, 1522.77, 75.11,   0.00, 0.00, 402.12);
	CreateDynamicObject(979, -287.65, 1516.53, 75.11,   0.00, 0.00, 402.12);
	CreateDynamicObject(979, -292.64, 1511.99, 75.11,   0.00, 0.00, 402.12);
	CreateDynamicObject(979, -347.05, 1530.27, 75.12,   0.00, 0.00, -90.06);
	CreateDynamicObject(979, -347.05, 1520.96, 75.12,   0.00, 0.00, -90.06);
	CreateDynamicObject(979, -347.05, 1513.18, 75.12,   0.00, 0.00, -90.06);
	CreateDynamicObject(714, -348.89, 1532.93, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(714, -349.14, 1517.23, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -882.34, 1964.71, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -880.82, 1958.41, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -879.41, 1952.67, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -877.84, 1946.30, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -876.17, 1940.84, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -874.67, 1935.31, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -873.11, 1929.37, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -871.28, 1922.84, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -869.26, 1915.45, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -867.19, 1908.31, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -865.10, 1900.65, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -863.14, 1893.99, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -861.33, 1887.27, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -859.34, 1879.73, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -857.23, 1871.73, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -855.10, 1863.29, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(3877, -852.86, 1852.81, 59.48,   0.00, 0.00, 15.30);
	CreateDynamicObject(979, -1160.98, 1792.23, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1170.25, 1792.24, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1179.60, 1792.24, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1151.33, 1792.33, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1175.08, 1804.49, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1184.38, 1804.49, 39.84,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, -1221.08, 1811.83, 41.22,   0.00, 0.00, -91.02);
	CreateDynamicObject(3578, -1207.28, 1814.97, 41.22,   0.00, 0.00, -188.70);
	CreateDynamicObject(3578, -1195.19, 1808.22, 41.22,   0.00, 0.00, -218.22);
	CreateDynamicObject(3578, -1198.81, 1811.04, 41.22,   0.00, 0.00, -218.22);
	CreateDynamicObject(979, -305.19, 1534.56, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(979, -314.53, 1534.55, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(979, -321.33, 1534.55, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(979, -333.48, 1534.57, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(979, -342.25, 1534.55, 75.32,   0.00, 0.00, 180.06);
	CreateDynamicObject(710, -295.34, 1501.45, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -294.84, 1494.10, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -293.95, 1484.66, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -308.53, 1501.33, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -307.64, 1492.86, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -306.95, 1485.67, 80.14,   0.00, 0.00, 0.00);
	CreateDynamicObject(16151, -300.29, 1541.16, 74.89,   0.00, 0.00, 135.06);
	CreateDynamicObject(18655, -298.20, 1545.12, 77.04,   -4.00, -18.00, 93.00);
	CreateDynamicObject(714, -312.37, 1539.49, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(714, -270.35, 1530.84, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(714, -286.46, 1515.81, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(714, -290.96, 1576.52, 69.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -384.52, 1460.99, 68.92,   0.00, 0.00, 0.00);
	//////////////////АВТО//////////////////////////
	CreateVehicle(562, -283.4048, 1559.3527, 74.9563, 135.3600, -1, -1, 100);
	CreateVehicle(562, -283.4048, 1559.3527, 74.9563, 135.3600, -1, -1, 100);
	CreateVehicle(560, -278.3853, 1554.3157, 74.9176, 133.4400, -1, -1, 100);
	CreateVehicle(560, -270.9072, 1549.2454, 74.9176, 133.4400, -1, -1, 100);
	CreateVehicle(562, -265.5812, 1542.5355, 74.8834, 133.0199, -1, -1, 100);
	//Ёлка
    CreateDynamicObject(4206,1479.69995117,-1639.59997559,14.00000000,0.00000000,0.00000000,80.00000000); //object(pershingpool_lan) (2)
	CreateDynamicObject(4206,1479.69995117,-1639.80004883,13.80000019,0.00000000,0.00000000,99.99633789); //object(pershingpool_lan) (4)
	CreateDynamicObject(4206,1479.69995117,-1639.59997559,13.89999962,0.00000000,0.00000000,79.99694824); //object(pershingpool_lan) (6)
	CreateDynamicObject(4206,1479.69995117,-1639.59997559,13.80000019,0.00000000,0.00000000,119.99694824); //object(pershingpool_lan) (7)
	CreateDynamicObject(727,1480.40002441,-1639.30004883,14.00000000,0.00000000,0.00000000,0.00000000); //object(tree_hipoly04) (1)
	CreateDynamicObject(727,1480.39941406,-1639.29980469,14.00000000,0.00000000,0.00000000,20.00000000); //object(tree_hipoly04) (5)
	CreateDynamicObject(727,1480.39941406,-1639.29980469,14.00000000,0.00000000,0.00000000,69.99511719); //object(tree_hipoly04) (6)
	CreateDynamicObject(727,1480.39941406,-1639.29980469,14.00000000,0.00000000,0.00000000,169.99389648); //object(tree_hipoly04) (7)
	CreateDynamicObject(6400,1486.30004883,-1631.80004883,14.00000000,0.00000000,270.00000000,320.00000000); //object(spraydoor_law2) (1)
	CreateDynamicObject(6400,1483.30004883,-1630.09997559,14.00000000,0.00000000,270.00000000,339.99877930); //object(spraydoor_law2) (2)
	CreateDynamicObject(6400,1479.59997559,-1629.40002441,14.00000000,0.00000000,270.00000000,359.99389648); //object(spraydoor_law2) (3)
	CreateDynamicObject(6400,1476.19995117,-1630.09997559,14.00000000,0.00000000,270.00000000,19.98901367); //object(spraydoor_law2) (4)
	CreateDynamicObject(6400,1473.09997559,-1631.90002441,14.00000000,0.00000000,270.00000000,39.98413086); //object(spraydoor_law2) (5)
	CreateDynamicObject(6400,1471.00000000,-1634.30004883,14.00000000,0.00000000,270.00000000,59.97924805); //object(spraydoor_law2) (6)
	CreateDynamicObject(6400,1469.59997559,-1637.69995117,14.00000000,0.00000000,270.00000000,79.97436523); //object(spraydoor_law2) (7)
	CreateDynamicObject(6400,1469.69995117,-1641.19995117,14.00000000,0.00000000,270.00000000,99.96945190); //object(spraydoor_law2) (8)
	CreateDynamicObject(6400,1470.80004883,-1644.59997559,14.00000000,0.00000000,270.00000000,119.96459961); //object(spraydoor_law2) (9)
	CreateDynamicObject(6400,1473.00000000,-1647.40002441,14.00000000,0.00000000,270.00000000,139.95971680); //object(spraydoor_law2) (10)
	CreateDynamicObject(6400,1476.00000000,-1649.09997559,14.00000000,0.00000000,270.00000000,159.95483398); //object(spraydoor_law2) (11)
	CreateDynamicObject(6400,1479.40002441,-1649.59997559,14.00000000,0.00000000,270.00000000,179.94995117); //object(spraydoor_law2) (12)
	CreateDynamicObject(6400,1482.90002441,-1649.30004883,14.00000000,0.00000000,270.00000000,199.94506836); //object(spraydoor_law2) (13)
	CreateDynamicObject(6400,1486.00000000,-1647.40002441,14.00000000,0.00000000,270.00000000,219.94018555); //object(spraydoor_law2) (14)
	CreateDynamicObject(6400,1488.30004883,-1644.69995117,14.00000000,0.00000000,270.00000000,239.93530273); //object(spraydoor_law2) (15)
	CreateDynamicObject(6400,1489.50000000,-1641.50000000,14.00000000,0.00000000,270.00000000,259.93041992); //object(spraydoor_law2) (16)
	CreateDynamicObject(6400,1489.40002441,-1637.90002441,14.00000000,0.00000000,270.00000000,279.92553711); //object(spraydoor_law2) (17)
	CreateDynamicObject(6400,1488.50000000,-1634.59997559,14.00000000,0.00000000,270.00000000,299.92065430); //object(spraydoor_law2) (18)
	CreateDynamicObject(6400,1484.59997559,-1636.90002441,14.00000000,0.00000000,270.00000000,299.91577148); //object(spraydoor_law2) (19)
	CreateDynamicObject(6400,1482.30004883,-1634.30004883,14.00000000,0.00000000,270.00000000,319.91577148); //object(spraydoor_law2) (20)
	CreateDynamicObject(6400,1479.69995117,-1633.90002441,14.00000000,0.00000000,270.00000000,359.91088867); //object(spraydoor_law2) (21)
	CreateDynamicObject(6400,1476.80004883,-1634.69995117,14.00000000,0.00000000,270.00000000,39.90661621); //object(spraydoor_law2) (22)
	CreateDynamicObject(6400,1474.59997559,-1636.80004883,14.00000000,0.00000000,270.00000000,69.90234375); //object(spraydoor_law2) (23)
	CreateDynamicObject(6400,1474.00000000,-1639.90002441,14.00000000,0.00000000,270.00000000,99.90051270); //object(spraydoor_law2) (24)
	CreateDynamicObject(6400,1474.80004883,-1642.80004883,14.00000000,0.00000000,270.00000000,129.89868164); //object(spraydoor_law2) (25)
	CreateDynamicObject(6400,1477.50000000,-1644.90002441,14.00000000,0.00000000,270.00000000,159.89685059); //object(spraydoor_law2) (26)
	CreateDynamicObject(6400,1480.59997559,-1645.30004883,14.00000000,0.00000000,270.00000000,189.89501953); //object(spraydoor_law2) (27)
	CreateDynamicObject(6400,1485.30004883,-1640.30004883,14.00000000,0.00000000,270.00000000,269.91577148); //object(spraydoor_law2) (28)
	CreateDynamicObject(6400,1484.30004883,-1643.40002441,14.00000000,0.00000000,270.00000000,229.91210938); //object(spraydoor_law2) (29)
	CreateDynamicObject(6400,1482.40002441,-1644.69995117,14.00000000,0.00000000,270.00000000,199.91088867); //object(spraydoor_law2) (30)
	CreateDynamicObject(6400,1480.40002441,-1640.69995117,14.00000000,0.00000000,270.00000000,199.90722656); //object(spraydoor_law2) (31)
	CreateDynamicObject(6400,1478.00000000,-1640.30004883,14.00000000,0.00000000,270.00000000,70.15722656); //object(spraydoor_law2) (32)
	CreateDynamicObject(6400,1481.30004883,-1639.30004883,14.00000000,0.00000000,270.00000000,110.15322876); //object(spraydoor_law2) (33)
	CreateDynamicObject(6400,1479.59997559,-1637.59997559,14.00000000,0.00000000,270.00000000,230.14892578); //object(spraydoor_law2) (34)
	CreateDynamicObject(3038,1481.19995117,-1639.00000000,26.50000000,283.99475098,0.00000000,9.99755859); //object(ct_lanterns) (10)
	CreateDynamicObject(3038,1480.90002441,-1641.59997559,21.79999924,307.99108887,0.00000000,259.99755859); //object(ct_lanterns) (11)
	CreateDynamicObject(3038,1479.90002441,-1639.69995117,27.79999924,271.99996948,180.00000000,79.99691772); //object(ct_lanterns) (13)
	CreateDynamicObject(3038,1479.00000000,-1639.50000000,17.50000000,47.98889160,0.00000000,349.99694824); //object(ct_lanterns) (15)
	CreateDynamicObject(3038,1482.09997559,-1638.50000000,19.50000000,47.97729492,0.00000000,99.98046875); //object(ct_lanterns) (19)
	CreateDynamicObject(954,1480.80004883,-1634.59997559,19.00000000,12.31460571,308.36386108,213.70143127); //object(cj_horse_shoe) (1)
	CreateDynamicObject(1212,1482.69995117,-1635.69995117,22.20000076,0.00000000,0.00000000,0.00000000); //object(money) (1)
	CreateDynamicObject(1212,1479.30004883,-1634.59997559,22.20000076,0.00000000,0.00000000,0.00000000); //object(money) (2)
	CreateDynamicObject(1212,1478.30004883,-1640.59997559,16.79999924,0.00000000,0.00000000,0.00000000); //object(money) (3)
	CreateDynamicObject(1213,1476.50000000,-1639.40002441,18.39999962,0.00000000,0.00000000,0.00000000); //object(mine) (1)
	CreateDynamicObject(1213,1476.90002441,-1643.50000000,18.39999962,0.00000000,0.00000000,0.00000000); //object(mine) (2)
	CreateDynamicObject(1213,1475.40002441,-1639.09997559,21.20000076,0.00000000,0.00000000,0.00000000); //object(mine) (3)
	CreateDynamicObject(1213,1475.40002441,-1639.09997559,27.50000000,0.00000000,0.00000000,0.00000000); //object(mine) (4)
	CreateDynamicObject(1213,1477.59997559,-1640.19995117,24.00000000,0.00000000,0.00000000,0.00000000); //object(mine) (5)
	CreateDynamicObject(1213,1480.50000000,-1637.09997559,22.00000000,0.00000000,0.00000000,0.00000000); //object(mine) (6)
	CreateDynamicObject(1213,1483.50000000,-1637.19995117,22.00000000,0.00000000,0.00000000,0.00000000); //object(mine) (7)
	CreateDynamicObject(1213,1479.30004883,-1634.50000000,22.00000000,0.00000000,0.00000000,0.00000000); //object(mine) (8)
	CreateDynamicObject(1213,1481.50000000,-1636.59997559,17.79999924,0.00000000,0.00000000,0.00000000); //object(mine) (9)
	CreateDynamicObject(1213,1480.19995117,-1638.80004883,17.79999924,0.00000000,0.00000000,0.00000000); //object(mine) (10)
	CreateDynamicObject(1213,1481.50000000,-1636.80004883,23.60000038,0.00000000,0.00000000,0.00000000); //object(mine) (11)
	CreateDynamicObject(1213,1479.09997559,-1640.19995117,26.39999962,0.00000000,0.00000000,0.00000000); //object(mine) (12)
	CreateDynamicObject(1213,1481.50000000,-1636.80004883,29.20000076,0.00000000,0.00000000,0.00000000); //object(mine) (13)
	CreateDynamicObject(1213,1480.19995117,-1638.69995117,32.50000000,0.00000000,0.00000000,0.00000000); //object(mine) (14)
	CreateDynamicObject(1213,1480.09997559,-1641.69995117,23.50000000,0.00000000,0.00000000,0.00000000); //object(mine) (15)
	CreateDynamicObject(1213,1476.69995117,-1640.30004883,22.00000000,0.00000000,0.00000000,0.00000000); //object(mine) (16)
	CreateDynamicObject(1213,1478.00000000,-1637.90002441,25.00000000,0.00000000,0.00000000,0.00000000); //object(mine) (17)
	CreateDynamicObject(1213,1481.30004883,-1643.80004883,21.79999924,0.00000000,0.00000000,0.00000000); //object(mine) (18)
	CreateDynamicObject(1239,1479.50000000,-1638.30004883,32.50000000,0.00000000,0.00000000,0.00000000); //object(info) (1)
	CreateDynamicObject(1239,1482.40002441,-1639.50000000,28.00000000,0.00000000,0.00000000,0.00000000); //object(info) (2)
	CreateDynamicObject(1239,1479.00000000,-1641.69995117,24.50000000,0.00000000,0.00000000,0.00000000); //object(info) (3)
	CreateDynamicObject(1239,1478.00000000,-1638.00000000,26.79999924,0.00000000,0.00000000,0.00000000); //object(info) (4)
	CreateDynamicObject(1239,1480.59997559,-1636.40002441,28.10000038,0.00000000,0.00000000,0.00000000); //object(info) (5)
	CreateDynamicObject(1239,1482.90002441,-1641.90002441,28.10000038,0.00000000,0.00000000,0.00000000); //object(info) (6)
	CreateDynamicObject(1240,1481.19995117,-1639.40002441,33.29999924,0.00000000,0.00000000,0.00000000); //object(health) (1)
	CreateDynamicObject(1240,1478.50000000,-1638.90002441,33.29999924,0.00000000,0.00000000,0.00000000); //object(health) (2)
	CreateDynamicObject(1240,1479.90002441,-1640.19995117,29.79999924,0.00000000,0.00000000,0.00000000); //object(health) (3)
	CreateDynamicObject(1240,1479.89941406,-1640.19921875,29.79999924,0.00000000,0.00000000,0.00000000); //object(health) (4)
	CreateDynamicObject(1240,1480.69995117,-1637.69995117,27.79999924,0.00000000,0.00000000,0.00000000); //object(health) (5)
	CreateDynamicObject(1240,1482.90002441,-1640.30004883,27.79999924,0.00000000,0.00000000,0.00000000); //object(health) (6)
	CreateDynamicObject(1240,1481.00000000,-1642.19995117,29.79999924,0.00000000,0.00000000,0.00000000); //object(health) (7)
	CreateDynamicObject(1240,1478.59997559,-1637.80004883,29.79999924,0.00000000,0.00000000,0.00000000); //object(health) (8)
	CreateDynamicObject(1240,1481.00000000,-1637.59997559,27.29999924,0.00000000,0.00000000,0.00000000); //object(health) (9)
	CreateDynamicObject(1241,1481.50000000,-1638.40002441,32.29999924,0.00000000,0.00000000,0.00000000); //object(adrenaline) (1)
	CreateDynamicObject(1241,1478.80004883,-1639.80004883,29.10000038,0.00000000,0.00000000,0.00000000); //object(adrenaline) (3)
	CreateDynamicObject(1241,1478.90002441,-1636.80004883,21.60000038,0.00000000,0.00000000,0.00000000); //object(adrenaline) (4)
	CreateDynamicObject(1241,1481.09997559,-1638.09997559,16.89999962,0.00000000,0.00000000,0.00000000); //object(adrenaline) (5)
	CreateDynamicObject(1241,1480.30004883,-1642.80004883,20.20000076,0.00000000,0.00000000,0.00000000); //object(adrenaline) (6)
	CreateDynamicObject(1241,1478.00000000,-1641.90002441,23.50000000,0.00000000,0.00000000,0.00000000); //object(adrenaline) (7)
	CreateDynamicObject(1241,1483.90002441,-1642.40002441,20.00000000,0.00000000,0.00000000,0.00000000); //object(adrenaline) (8)
	CreateDynamicObject(1247,1480.09997559,-1639.69995117,34.59999847,0.00000000,0.00000000,0.00000000); //object(bribe) (2)
	CreateDynamicObject(1247,1481.30004883,-1638.80004883,31.39999962,0.00000000,0.00000000,0.00000000); //object(bribe) (3)
	CreateDynamicObject(1247,1480.80004883,-1641.80004883,27.20000076,0.00000000,0.00000000,0.00000000); //object(bribe) (4)
	CreateDynamicObject(1247,1478.90002441,-1636.90002441,25.70000076,0.00000000,0.00000000,0.00000000); //object(bribe) (5)
	CreateDynamicObject(1247,1480.69995117,-1638.00000000,29.50000000,0.00000000,0.00000000,0.00000000); //object(bribe) (6)
	CreateDynamicObject(1247,1483.30004883,-1639.80004883,24.79999924,0.00000000,0.00000000,0.00000000); //object(bribe) (7)
	CreateDynamicObject(1247,1478.40002441,-1638.80004883,24.79999924,0.00000000,0.00000000,0.00000000); //object(bribe) (8)
	CreateDynamicObject(1253,1480.80004883,-1639.50000000,32.29999924,0.00000000,0.00000000,0.00000000); //object(camerapickup) (1)
	CreateDynamicObject(1253,1480.00000000,-1637.50000000,28.29999924,0.00000000,0.00000000,0.00000000); //object(camerapickup) (2)
	CreateDynamicObject(1253,1478.19995117,-1640.30004883,28.29999924,0.00000000,0.00000000,0.00000000); //object(camerapickup) (3)
	CreateDynamicObject(1253,1478.19995117,-1640.30004883,23.00000000,0.00000000,0.00000000,0.00000000); //object(camerapickup) (4)
	CreateDynamicObject(1253,1481.80004883,-1643.00000000,23.00000000,0.00000000,0.00000000,0.00000000); //object(camerapickup) (5)
	CreateDynamicObject(1253,1483.00000000,-1638.90002441,28.60000038,0.00000000,0.00000000,0.00000000); //object(camerapickup) (6)
	CreateDynamicObject(1253,1482.09997559,-1640.50000000,12.10000038,0.00000000,0.00000000,0.00000000); //object(camerapickup) (7)
	CreateDynamicObject(1253,1481.40002441,-1635.00000000,12.10000038,0.00000000,0.00000000,0.00000000); //object(camerapickup) (8)
	CreateDynamicObject(1253,1481.39941406,-1635.00000000,12.10000038,0.00000000,0.00000000,0.00000000); //object(camerapickup) (9)
	CreateDynamicObject(1274,1480.50000000,-1637.30004883,34.29999924,0.00000000,0.00000000,0.00000000); //object(bigdollar) (1)
	CreateDynamicObject(1274,1479.59997559,-1639.90002441,30.29999924,0.00000000,0.00000000,0.00000000); //object(bigdollar) (2)
	CreateDynamicObject(1274,1482.30004883,-1639.40002441,33.09999847,0.00000000,0.00000000,0.00000000); //object(bigdollar) (3)
	CreateDynamicObject(1274,1480.19995117,-1638.59997559,24.29999924,0.00000000,0.00000000,0.00000000); //object(bigdollar) (4)
	CreateDynamicObject(1274,1482.30004883,-1639.00000000,27.10000038,0.00000000,0.00000000,0.00000000); //object(bigdollar) (5)
	CreateDynamicObject(1274,1481.00000000,-1641.30004883,22.39999962,0.00000000,0.00000000,0.00000000); //object(bigdollar) (6)
	CreateDynamicObject(1274,1478.59997559,-1637.00000000,19.70000076,0.00000000,0.00000000,0.00000000); //object(bigdollar) (7)
	CreateDynamicObject(1276,1479.19995117,-1638.40002441,32.00000000,0.00000000,0.00000000,0.00000000); //object(package1) (1)
	CreateDynamicObject(1276,1479.80004883,-1641.19995117,27.29999924,0.00000000,0.00000000,0.00000000); //object(package1) (2)
	CreateDynamicObject(1276,1482.00000000,-1639.09997559,30.60000038,0.00000000,0.00000000,0.00000000); //object(package1) (3)
	CreateDynamicObject(1276,1481.80004883,-1639.30004883,25.10000038,0.00000000,0.00000000,0.00000000); //object(package1) (4)
	CreateDynamicObject(1276,1477.69995117,-1639.40002441,21.60000038,0.00000000,0.00000000,0.00000000); //object(package1) (5)
	CreateDynamicObject(1276,1482.59997559,-1641.59997559,16.10000038,0.00000000,0.00000000,0.00000000); //object(package1) (6)
	CreateDynamicObject(1276,1480.59997559,-1635.90002441,17.89999962,0.00000000,0.00000000,0.00000000); //object(package1) (7)
	CreateDynamicObject(1314,1482.09997559,-1638.90002441,25.39999962,0.00000000,0.00000000,0.00000000); //object(twoplayer) (1)
	CreateDynamicObject(1314,1480.30004883,-1641.69995117,25.39999962,0.00000000,0.00000000,0.00000000); //object(twoplayer) (2)
	CreateDynamicObject(1314,1480.30004883,-1641.69995117,33.00000000,0.00000000,0.00000000,0.00000000); //object(twoplayer) (3)
	CreateDynamicObject(1314,1480.00000000,-1638.90002441,31.00000000,0.00000000,0.00000000,0.00000000); //object(twoplayer) (4)
	CreateDynamicObject(1314,1481.40002441,-1637.90002441,29.00000000,0.00000000,0.00000000,0.00000000); //object(twoplayer) (5)
	CreateDynamicObject(1314,1482.59997559,-1640.90002441,26.29999924,0.00000000,0.00000000,0.00000000); //object(twoplayer) (6)
	CreateDynamicObject(1314,1477.90002441,-1638.80004883,23.50000000,0.00000000,0.00000000,0.00000000); //object(twoplayer) (7)
	CreateDynamicObject(1314,1480.19995117,-1638.00000000,31.20000076,0.00000000,0.00000000,0.00000000); //object(twoplayer) (8)
	CreateDynamicObject(997,1486.19995117,-1629.09997559,13.60000038,0.00000000,0.00000000,320.00000000); //object(lhouse_barrier3) (1)
	CreateDynamicObject(997,1489.40002441,-1632.00000000,13.60000038,0.00000000,0.00000000,299.99877930); //object(lhouse_barrier3) (2)
	CreateDynamicObject(997,1482.30004883,-1627.50000000,13.60000038,0.00000000,0.00000000,339.99877930); //object(lhouse_barrier3) (3)
	CreateDynamicObject(997,1478.00000000,-1627.30004883,13.60000038,0.00000000,0.00000000,359.99389648); //object(lhouse_barrier3) (4)
	CreateDynamicObject(997,1473.80004883,-1628.59997559,13.60000038,0.00000000,0.00000000,19.98901367); //object(lhouse_barrier3) (5)
	CreateDynamicObject(997,1470.40002441,-1631.19995117,13.60000038,0.00000000,0.00000000,39.98413086); //object(lhouse_barrier3) (6)
	CreateDynamicObject(997,1468.09997559,-1634.80004883,13.60000038,0.00000000,0.00000000,59.97924805); //object(lhouse_barrier3) (7)
	CreateDynamicObject(997,1467.19995117,-1639.00000000,13.60000038,0.00000000,0.00000000,79.97436523); //object(lhouse_barrier3) (8)
	CreateDynamicObject(997,1467.69995117,-1643.30004883,13.60000038,0.00000000,0.00000000,99.96945190); //object(lhouse_barrier3) (9)
	CreateDynamicObject(997,1469.69995117,-1647.09997559,13.60000038,0.00000000,0.00000000,119.96459961); //object(lhouse_barrier3) (10)
	CreateDynamicObject(997,1472.80004883,-1650.09997559,13.60000038,0.00000000,0.00000000,139.95971680); //object(lhouse_barrier3) (11)
	CreateDynamicObject(997,1476.90002441,-1651.69995117,13.60000038,0.00000000,0.00000000,159.95483398); //object(lhouse_barrier3) (12)
	CreateDynamicObject(997,1481.09997559,-1651.90002441,13.60000038,0.00000000,0.00000000,179.94995117); //object(lhouse_barrier3) (13)
	CreateDynamicObject(997,1488.69995117,-1648.00000000,13.60000038,0.00000000,0.00000000,219.94018555); //object(lhouse_barrier3) (15)
	CreateDynamicObject(997,1491.00000000,-1644.40002441,13.60000038,0.00000000,0.00000000,239.93530273); //object(lhouse_barrier3) (16)
	CreateDynamicObject(997,1492.00000000,-1640.19995117,13.60000038,0.00000000,0.00000000,259.93041992); //object(lhouse_barrier3) (17)
	CreateDynamicObject(997,1491.40002441,-1635.90002441,13.60000038,0.00000000,0.00000000,279.92553711); //object(lhouse_barrier3) (18)
	CreateDynamicObject(6299,1453.00000000,-1639.09997559,15.30000019,0.00000000,0.00000000,0.00000000); //object(pier03c_law2) (1)
	CreateDynamicObject(6462,1488.00000000,-1651.80004883,15.10000038,0.00000000,0.00000000,90.00000000); //object(pier04a_law2) (1)
	CreateDynamicObject(3860,1498.59997559,-1642.30004883,14.19999981,0.00000000,0.00000000,270.00000000); //object(marketstall04_sfxrf) (1)
	CreateDynamicObject(3862,1498.59997559,-1637.40002441,14.19999981,0.00000000,0.00000000,270.00000000); //object(marketstall02_sfxrf) (1)
	CreateDynamicObject(3863,1498.59997559,-1633.00000000,14.19999981,0.00000000,0.00000000,270.00000000); //object(marketstall03_sfxrf) (1)
	CreateDynamicObject(14395,1486.19995117,-1653.69995117,11.89999962,0.00000000,0.00000000,110.00000000); //object(dr_gsnew11) (1)
	CreateDynamicObject(902,1480.69995117,-1639.00000000,36.70000076,77.83685303,260.67590332,69.53417969); //object(starfish) (1)
	CreateDynamicObject(902,1480.80004883,-1639.30004883,36.70000076,77.83264160,260.67260742,249.53247070); //object(starfish) (2)
	CreateDynamicObject(902,1480.79980469,-1639.29980469,36.70000076,77.83264160,260.66711426,329.52697754); //object(starfish) (3)
	CreateDynamicObject(902,1480.79980469,-1639.29980469,36.70000076,75.85641479,262.02392578,148.20251465); //object(starfish) (4)
	CreateDynamicObject(9123,1480.00000000,-1639.40002441,-11.00000000,0.00000000,90.00000000,356.00000000); //object(ballyneon01) (1)
	//ЕЛКА В LS//
	CreateDynamicObject(19129, 836.30, -2052.81, 11.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(984, 846.29, -2056.39, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(984, 846.29, -2049.24, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 843.08, -2042.81, 12.53,   0.00, 0.00, 89.76);
	CreateDynamicObject(983, 838.71, -2042.80, 12.53,   0.00, 0.00, 89.76);
	CreateDynamicObject(983, 843.04, -2062.81, 12.53,   0.00, 0.00, 89.76);
	CreateDynamicObject(983, 836.62, -2062.81, 12.53,   0.00, 0.00, 89.76);
	CreateDynamicObject(983, 830.26, -2062.77, 12.53,   0.00, 0.00, 89.76);
	CreateDynamicObject(983, 829.51, -2062.77, 12.53,   0.00, 0.00, 89.76);
	CreateDynamicObject(984, 826.29, -2056.31, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(984, 826.28, -2049.25, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, 829.48, -2042.86, 12.53,   0.00, 0.00, 89.76);
	CreateDynamicObject(18655, 846.25, -2042.90, 11.83,   0.00, 0.00, 37.68);
	CreateDynamicObject(18655, 846.17, -2062.76, 11.83,   0.00, 0.00, -47.28);
	CreateDynamicObject(18655, 826.43, -2062.71, 11.83,   0.00, 0.00, -123.36);
	CreateDynamicObject(18655, 826.38, -2042.93, 11.83,   0.00, 0.00, -213.96);
	CreateDynamicObject(19057, 834.51, -2053.94, 12.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19057, 836.01, -2054.00, 12.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19057, 836.60, -2052.51, 12.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19057, 835.50, -2051.23, 12.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19057, 834.14, -2052.57, 12.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19076, 835.54, -2052.56, 11.85,   0.00, 0.00, 0.00);
	//Респавн//
	CreateDynamicObject(18789, 101.35, -1838.01, 2.56,   0.00, 0.00, 57.00);
	CreateDynamicObject(18789, 19.84, -1963.55, 2.56,   0.00, 0.00, 57.00);
	CreateDynamicObject(8417, -30.43, -2042.95, 2.88,   0.00, 180.00, -32.00);
	CreateDynamicObject(11490, -34.33, -2052.63, 2.75,   0.00, 0.00, 147.42);
	CreateDynamicObject(11491, -28.41, -2043.32, 4.24,   0.00, 0.00, 147.30);
	CreateDynamicObject(1723, -28.46, -2045.37, 4.33,   0.00, 0.00, -212.76);
	CreateDynamicObject(1516, -28.59, -2043.76, 4.51,   0.00, 0.00, -32.10);
	CreateDynamicObject(2964, -23.49, -2045.56, 4.37,   0.00, 0.00, -32.76);
	CreateDynamicObject(3524, -28.79, -2040.88, 5.27,   0.00, 0.00, 145.20);
	CreateDynamicObject(3524, -31.16, -2039.14, 5.27,   0.00, 0.00, 145.20);
	CreateDynamicObject(11665, -38.53, -2053.22, 5.01,   0.00, 0.00, 12.12);
	CreateDynamicObject(16151, -29.96, -2052.73, 4.68,   0.00, 0.00, -32.16);
	CreateDynamicObject(2233, -33.05, -2058.85, 4.35,   0.00, 0.00, -153.60);
	CreateDynamicObject(2239, -31.94, -2055.40, 4.21,   0.00, 0.00, -198.48);
	CreateDynamicObject(14806, -35.96, -2047.61, 5.31,   0.00, 0.00, 57.00);
	CreateDynamicObject(984, -11.46, -2051.60, 3.56,   0.00, 0.00, 148.02);
	CreateDynamicObject(984, -18.21, -2062.38, 3.56,   0.00, 0.00, 148.02);
	CreateDynamicObject(984, -20.09, -2065.39, 3.56,   0.00, 0.00, 148.02);
	CreateDynamicObject(984, -28.87, -2067.41, 3.56,   0.00, 0.00, 237.78);
	CreateDynamicObject(984, -50.44, -2054.00, 3.56,   0.00, 0.00, 238.08);
	CreateDynamicObject(984, -39.58, -2060.77, 3.56,   0.00, 0.00, 238.08);
	CreateDynamicObject(984, -53.11, -2052.32, 3.56,   0.00, 0.00, 238.08);
	CreateDynamicObject(984, -55.16, -2043.53, 3.56,   0.00, 0.00, 148.02);
	CreateDynamicObject(984, -48.42, -2032.74, 3.56,   0.00, 0.00, 148.02);
	CreateDynamicObject(984, -41.60, -2021.87, 3.56,   0.00, 0.00, 148.02);
	CreateDynamicObject(984, -40.71, -2020.50, 3.56,   0.00, 0.00, 148.02);
	CreateDynamicObject(984, -5.67, -2042.42, 3.56,   0.00, 0.00, 148.02);
	CreateDynamicObject(983, -4.97, -2035.26, 3.56,   0.00, 0.00, 57.72);
	CreateDynamicObject(983, -10.40, -2031.85, 3.56,   0.00, 0.00, 57.72);
	CreateDynamicObject(983, -11.37, -2031.25, 3.56,   0.00, 0.00, 57.72);
	CreateDynamicObject(983, -34.58, -2016.84, 3.56,   0.00, 0.00, 57.72);
	CreateDynamicObject(983, -29.79, -2019.83, 3.56,   0.00, 0.00, 57.72);
	CreateDynamicObject(3511, -37.08, -2016.50, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -42.44, -2025.07, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -47.57, -2033.27, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -52.54, -2041.22, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -57.09, -2048.50, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -48.59, -2053.78, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -40.23, -2059.03, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -31.04, -2064.70, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -23.77, -2069.19, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -18.46, -2060.50, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -13.37, -2052.20, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -8.35, -2044.38, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -3.88, -2037.19, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -3.88, -2037.19, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -13.77, -2030.99, 2.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3511, -28.34, -2021.92, 2.76,   0.00, 0.00, 0.00);
	//УКРОШЕНИЯ ГРУВ
	CreateDynamicObject(3520, 2309.07, -1649.13, 13.10,   0.00, 0.00, 90.00);
	CreateDynamicObject(3520, 2313.52, -1649.03, 13.13,   0.00, 0.00, 90.00);
	CreateDynamicObject(3520, 2317.62, -1648.99, 12.93,   0.00, 0.00, 90.00);
	CreateDynamicObject(3520, 2322.19, -1649.15, 12.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(1408, 2309.92, -1648.02, 14.22,   356.88, 0.00, -3.14);
	CreateDynamicObject(1408, 2315.15, -1648.03, 14.22,   356.88, 0.00, -3.14);
	CreateDynamicObject(1408, 2320.36, -1648.06, 14.22,   356.88, 0.00, -3.14);
	CreateDynamicObject(1408, 2325.17, -1648.09, 14.22,   356.88, 0.00, -3.14);
	CreateDynamicObject(700, 2329.22, -1653.10, 12.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2320.67, -1652.74, 12.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2307.46, -1652.68, 12.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2301.19, -1652.69, 12.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2292.22, -1652.67, 13.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2276.65, -1652.95, 13.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2266.52, -1652.55, 13.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(638, 2284.20, -1648.50, 14.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(638, 2286.73, -1648.49, 14.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(638, 2289.40, -1648.47, 14.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(638, 2291.97, -1648.46, 14.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(638, 2278.45, -1648.58, 14.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(638, 2275.83, -1648.54, 14.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(748, 2277.45, -1644.77, 14.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2330.03, -1665.25, 12.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2319.85, -1665.46, 12.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2311.46, -1665.39, 12.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2301.23, -1665.16, 12.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2274.31, -1665.35, 14.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2260.00, -1665.39, 14.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2242.41, -1661.72, 14.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2245.27, -1648.77, 14.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(3749, 2240.59, -1654.30, 19.63,   0.00, 0.00, 77.00);
	CreateDynamicObject(3660, 2266.26, -1665.16, 16.13,   0.00, 0.00, 0.00);
	CreateDynamicObject(3660, 2284.74, -1652.28, 15.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(8676, 2274.33, -1671.35, 23.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 2354.08, -1652.92, 12.26,   0.00, 0.00, 42.00);
	CreateDynamicObject(700, 2368.15, -1653.08, 12.55,   0.00, 0.00, 42.00);
	CreateDynamicObject(700, 2354.36, -1665.15, 12.55,   0.00, 0.00, 42.00);
	CreateDynamicObject(700, 2348.67, -1671.48, 12.47,   0.00, 0.00, -62.00);
	CreateDynamicObject(700, 2348.62, -1685.47, 12.47,   0.00, 0.00, -62.00);
	CreateDynamicObject(700, 2348.84, -1702.39, 12.47,   0.00, 0.00, -62.00);
	CreateDynamicObject(700, 2336.15, -1671.79, 12.47,   0.00, 0.00, -62.00);
	CreateDynamicObject(700, 2336.04, -1686.13, 12.47,   0.00, 0.00, -62.00);
	CreateDynamicObject(700, 2336.22, -1700.99, 12.47,   0.00, 0.00, -62.00);
	CreateDynamicObject(3614, 2494.29, -1709.15, 13.39,   0.00, 0.00, -180.00);
	CreateDynamicObject(3509, 2465.19, -1666.34, 11.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(3509, 2466.08, -1652.10, 11.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(3517, 2483.45, -1652.61, 22.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(3517, 2501.84, -1654.22, 22.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(3517, 2510.06, -1663.82, 22.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(3517, 2508.92, -1676.86, 22.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(3517, 2502.50, -1683.37, 22.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(3517, 2493.58, -1685.33, 22.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(3517, 2479.73, -1684.73, 22.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(3532, 2490.79, -1685.35, 12.72,   0.00, 0.00, 90.00);
	CreateDynamicObject(3532, 2486.31, -1685.12, 12.72,   0.00, 0.00, 90.00);
	CreateDynamicObject(3532, 2482.01, -1684.89, 12.72,   0.00, 0.00, 81.00);
	CreateDynamicObject(3532, 2505.26, -1681.38, 12.72,   0.00, 0.00, 134.00);
	CreateDynamicObject(3532, 2508.09, -1678.09, 12.72,   0.00, 0.00, 146.00);
	CreateDynamicObject(3532, 2509.10, -1661.19, 12.72,   0.00, 0.00, 33.00);
	CreateDynamicObject(3532, 2510.58, -1665.61, 12.99,   0.00, 0.00, 14.00);
	CreateDynamicObject(3532, 2503.66, -1655.41, 12.99,   0.00, 0.00, 54.00);
	CreateDynamicObject(3532, 2492.87, -1652.82, 12.99,   0.00, 0.00, 91.00);
	CreateDynamicObject(3532, 2490.20, -1652.60, 12.71,   0.00, 0.00, 91.00);
	CreateDynamicObject(3532, 2482.02, -1652.47, 12.92,   0.00, 0.00, -85.00);
	CreateDynamicObject(3532, 2477.77, -1652.48, 12.92,   0.00, 0.00, -85.00);
	CreateDynamicObject(3532, 2470.51, -1652.38, 12.92,   0.00, 0.00, -85.00);
	CreateDynamicObject(3532, 2473.66, -1652.50, 12.92,   0.00, 0.00, -85.00);
	CreateDynamicObject(3557, 2440.52, -1673.13, 14.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3557, 2426.19, -1673.07, 14.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(3604, 2456.23, -1672.83, 14.81,   0.00, 0.00, -180.00);
	CreateDynamicObject(3532, 2450.11, -1666.99, 12.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3532, 2462.45, -1667.09, 12.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3604, 2429.40, -1644.06, 14.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1410, 2437.85, -1648.84, 13.28,   356.86, 0.00, -3.12);
	CreateDynamicObject(700, 2370.20, -1665.23, 12.55,   0.00, 0.00, 42.00);
	CreateDynamicObject(700, 2390.12, -1664.94, 12.55,   0.00, 0.00, 42.00);
	CreateDynamicObject(700, 2389.74, -1652.99, 12.55,   0.00, 0.00, 42.00);
	CreateDynamicObject(700, 2399.79, -1653.03, 12.55,   0.00, 0.00, 42.00);
	CreateDynamicObject(700, 2407.38, -1653.05, 12.49,   0.00, 0.00, 42.00);
	CreateDynamicObject(700, 2420.90, -1652.93, 12.49,   0.00, 0.00, 42.00);
	CreateDynamicObject(801, 2420.41, -1652.98, 11.69,   0.00, 0.00, 0.00);
	CreateDynamicObject(801, 2417.30, -1673.73, 11.69,   0.00, 0.00, 62.00);
	CreateDynamicObject(801, 2434.45, -1667.08, 11.69,   0.00, 0.00, 0.00);
	CreateDynamicObject(1408, 2398.17, -1664.30, 13.05,   0.00, 0.00, -180.00);
	CreateDynamicObject(1408, 2403.42, -1664.27, 13.05,   0.00, 0.00, -180.00);
	CreateDynamicObject(1408, 2408.62, -1664.24, 13.05,   0.00, 0.00, -180.00);
	CreateDynamicObject(1408, 2413.02, -1664.25, 13.05,   0.00, 0.00, -180.00);
	CreateDynamicObject(751, 2349.93, -1667.09, 12.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(759, 2336.11, -1686.27, 11.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(759, 2336.23, -1672.21, 11.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(759, 2330.21, -1665.69, 11.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(726, 2350.66, -1742.48, 12.04,   0.00, 0.00, 0.00);
	CreateDynamicObject(726, 2400.39, -1742.64, 12.04,   0.00, 0.00, 0.00);
	CreateDynamicObject(726, 2302.49, -1742.64, 12.04,   0.00, 0.00, 0.00);
	CreateDynamicObject(726, 2248.04, -1742.33, 12.04,   0.00, 0.00, 47.00);
	CreateDynamicObject(13562, 2232.05, -1719.63, 22.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(737, 2193.87, -1721.62, 12.61,   0.00, 0.00, 47.00);
	CreateDynamicObject(737, 2193.60, -1740.14, 12.61,   0.00, 0.00, 47.00);
	CreateDynamicObject(745, 2192.67, -1718.45, 12.30,   0.00, 0.00, 47.00);
	CreateDynamicObject(745, 2174.40, -1719.66, 12.30,   0.00, 0.00, 302.00);
	CreateDynamicObject(18761, 2183.78, -1719.56, 15.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(18761, 2193.45, -1731.15, 15.95,   0.00, 0.00, 90.00);
	CreateDynamicObject(18751, 2214.51, -1638.40, 8.49,   0.00, 0.00, -25.00);
	CreateDynamicObject(8618, 2173.28, -1738.32, 31.86,   0.00, 0.00, -90.00);
	CreateDynamicObject(8563, 2173.77, -1766.42, 20.79,   0.00, 0.00, -127.00);
	CreateDynamicObject(8556, 2178.03, -1778.35, 16.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(809, 2190.94, -1770.87, 11.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(809, 2189.68, -1771.52, 11.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(809, 2190.37, -1783.50, 11.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(809, 2190.49, -1785.23, 11.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(809, 2180.15, -1770.64, 11.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(8537, 2170.09, -1713.56, 24.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(620, 2201.00, -1659.22, 12.31,   356.86, 0.00, 3.14);
	CreateDynamicObject(620, 2196.36, -1680.21, 12.31,   356.86, 0.00, 3.14);
	CreateDynamicObject(620, 2194.12, -1697.11, 11.21,   356.86, 0.00, 3.14);
	CreateDynamicObject(620, 2193.10, -1711.82, 11.82,   356.86, 0.00, 3.14);
	CreateDynamicObject(669, 2221.73, -1639.70, 14.28,   356.86, 0.00, 3.14);
	CreateDynamicObject(669, 2218.35, -1658.34, 14.28,   356.86, 0.00, 3.14);
	CreateDynamicObject(708, 2381.67, -1740.74, 12.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 2324.12, -1740.80, 12.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 2273.46, -1740.68, 12.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 2226.57, -1741.26, 12.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(744, 2487.89, -1668.67, 12.33,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 2487.25, -1669.03, 10.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(744, 2487.19, -1672.75, 11.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(744, 2485.38, -1669.93, 12.13,   0.00, 0.00, 0.00);
	CreateDynamicObject(744, 2489.43, -1671.62, 12.27,   0.00, 0.00, 0.00);
	//NEW DRIFT//
	CreateDynamicObject(984, 1492.27, 1254.41, 10.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(984, 1458.73, 1247.92, 10.43,   0.00, 0.00, 89.94);
	CreateDynamicObject(984, 1492.25, 1264.49, 10.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(984, 1492.25, 1277.26, 10.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(984, 1492.26, 1290.08, 10.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(984, 1492.26, 1302.88, 10.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.97, 1322.03, 10.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1492.01, 1334.62, 9.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1492.07, 1339.38, 9.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1492.17, 1344.10, 9.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1492.01, 1356.93, 10.43,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.99, 1382.52, 10.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.98, 1408.12, 10.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.96, 1433.69, 10.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.92, 1459.25, 10.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1492.00, 1472.04, 9.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1492.07, 1476.68, 9.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1492.00, 1481.69, 9.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.99, 1494.64, 10.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.97, 1520.29, 10.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.95, 1545.89, 10.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.94, 1571.47, 10.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.91, 1597.09, 10.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1491.92, 1622.71, 10.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1491.82, 1635.27, 9.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1492.03, 1639.78, 9.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1492.17, 1643.55, 9.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1492.14, 1656.62, 10.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1492.12, 1682.19, 10.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1487.48, 1706.87, 10.53,   0.00, 0.00, 21.36);
	CreateDynamicObject(982, 1473.20, 1727.20, 10.53,   0.00, 0.00, 48.60);
	CreateDynamicObject(982, 1451.81, 1740.46, 10.53,   0.00, 0.00, 67.92);
	CreateDynamicObject(982, 1448.77, 1741.64, 10.53,   0.00, 0.00, 67.92);
	CreateDynamicObject(3578, 1431.98, 1747.03, 10.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 1421.92, 1746.34, 10.54,   0.00, 0.00, 7.92);
	CreateDynamicObject(3578, 1413.90, 1744.14, 10.54,   0.00, 0.00, 19.80);
	CreateDynamicObject(3578, 1404.72, 1739.81, 10.54,   0.00, 0.00, 31.08);
	CreateDynamicObject(3578, 1396.40, 1734.17, 10.54,   0.00, 0.00, 37.38);
	CreateDynamicObject(3578, 1388.94, 1727.34, 10.54,   0.00, 0.00, 47.64);
	CreateDynamicObject(3578, 1382.97, 1719.07, 10.54,   0.00, 0.00, 60.30);
	CreateDynamicObject(3578, 1378.51, 1710.05, 10.54,   0.00, 0.00, 67.32);
	CreateDynamicObject(3578, 1375.40, 1700.46, 10.54,   0.00, 0.00, 77.04);
	CreateDynamicObject(3578, 1373.72, 1690.74, 10.54,   0.00, 0.00, 84.36);
	CreateDynamicObject(982, 1457.37, 1315.66, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.40, 1341.23, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.44, 1366.79, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.51, 1392.36, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.48, 1417.98, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.53, 1443.55, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.53, 1469.14, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.52, 1494.69, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.55, 1520.26, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.58, 1545.84, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.60, 1571.42, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.63, 1597.01, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.65, 1622.60, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.67, 1648.19, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.73, 1673.75, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1457.76, 1679.77, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 1455.01, 1696.88, 10.57,   0.00, 0.00, -60.90);
	CreateDynamicObject(3578, 1449.20, 1705.21, 10.57,   0.00, 0.00, -48.66);
	CreateDynamicObject(3578, 1441.29, 1711.02, 10.57,   0.00, 0.00, -24.06);
	CreateDynamicObject(3578, 1431.82, 1712.67, 10.57,   0.00, 0.00, 3.84);
	CreateDynamicObject(3578, 1422.49, 1710.02, 10.57,   0.00, 0.00, 27.78);
	CreateDynamicObject(3578, 1414.55, 1704.12, 10.57,   0.00, 0.00, 45.42);
	CreateDynamicObject(3578, 1409.95, 1695.74, 10.57,   0.00, 0.00, 77.16);
	CreateDynamicObject(982, 1408.87, 1678.11, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.88, 1652.54, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.90, 1626.98, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.86, 1601.39, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.84, 1575.81, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.81, 1550.27, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.79, 1524.72, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.79, 1499.13, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.76, 1473.57, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.74, 1448.00, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.75, 1422.44, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.76, 1396.88, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.75, 1371.35, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.74, 1345.78, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1374.02, 1674.90, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.02, 1649.32, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.03, 1623.77, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.02, 1598.18, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.05, 1572.61, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.05, 1547.03, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.08, 1521.39, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.08, 1495.79, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.12, 1470.21, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.15, 1444.60, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.19, 1418.98, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.17, 1393.40, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.20, 1367.80, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.21, 1342.20, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(982, 1374.19, 1316.60, 10.48,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 1374.77, 1298.73, 10.58,   0.00, 0.00, -79.98);
	CreateDynamicObject(3578, 1376.53, 1288.77, 10.58,   0.00, 0.00, -79.98);
	CreateDynamicObject(3578, 1379.59, 1279.14, 10.58,   0.00, 0.00, -64.62);
	CreateDynamicObject(3578, 1384.53, 1270.42, 10.58,   0.00, 0.00, -55.86);
	CreateDynamicObject(3578, 1391.18, 1262.75, 10.58,   -0.42, 0.00, -42.24);
	CreateDynamicObject(3578, 1399.09, 1256.38, 10.58,   -0.42, 0.00, -35.16);
	CreateDynamicObject(3578, 1407.92, 1251.38, 10.58,   -0.42, 0.00, -23.58);
	CreateDynamicObject(3578, 1417.49, 1247.90, 10.58,   -0.42, 0.00, -16.14);
	CreateDynamicObject(3578, 1427.31, 1246.07, 10.57,   -0.42, 0.00, -4.62);
	CreateDynamicObject(3578, 1437.42, 1246.32, 10.57,   -0.42, 0.00, 7.56);
	CreateDynamicObject(3578, 1447.37, 1247.65, 10.57,   -0.42, 0.00, 7.56);
	CreateDynamicObject(984, 1471.52, 1248.00, 10.43,   0.00, 0.00, 89.94);
	CreateDynamicObject(984, 1484.30, 1248.05, 10.43,   0.00, 0.00, 89.94);
	CreateDynamicObject(984, 1485.87, 1248.03, 10.43,   0.00, 0.00, 89.94);
	CreateDynamicObject(982, 1408.70, 1320.19, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 1408.65, 1315.03, 10.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 1410.32, 1297.38, 10.60,   0.00, 0.00, -76.26);
	CreateDynamicObject(3578, 1414.68, 1288.74, 10.60,   0.00, 0.00, -49.32);
	CreateDynamicObject(3578, 1422.65, 1282.98, 10.60,   0.00, 0.00, -22.02);
	CreateDynamicObject(3578, 1432.35, 1280.88, 10.60,   0.00, 0.00, -2.04);
	CreateDynamicObject(3578, 1442.14, 1282.29, 10.60,   0.00, 0.00, 19.14);
	CreateDynamicObject(3578, 1450.10, 1287.67, 10.60,   0.00, 0.00, 49.14);
	CreateDynamicObject(3578, 1454.93, 1296.28, 10.60,   0.00, 0.00, 72.84);
	CreateDynamicObject(3578, 1455.49, 1298.05, 10.60,   0.00, 0.00, 72.84);
	CreateDynamicObject(8884, 1429.50, 1292.75, 12.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(8884, 1430.55, 1311.37, 12.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(8884, 1430.41, 1336.97, 12.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(8884, 1431.70, 1365.10, 12.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1445.99, 1394.41, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1437.28, 1394.45, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1428.06, 1394.44, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1428.27, 1441.84, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1437.36, 1441.85, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1446.37, 1441.81, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1447.06, 1489.61, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1438.17, 1489.56, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1428.90, 1489.52, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1429.05, 1537.94, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1438.32, 1537.95, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1447.54, 1537.92, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1447.87, 1584.29, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1438.64, 1584.33, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1429.55, 1584.35, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1428.62, 1632.33, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1437.81, 1632.27, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1446.54, 1632.28, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1446.80, 1678.20, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1437.83, 1678.13, 12.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(8883, 1428.64, 1678.05, 12.93,   0.00, 0.00, 0.00);
	//Аква_трЭк//
	CreateDynamicObject(19073, -1312.30, 392.98, 30.04,   0.00, 0.00, 90.00);
	CreateDynamicObject(19073, -1252.54, 392.97, 30.04,   0.00, 0.00, 90.00);
	CreateDynamicObject(19073, -1193.32, 393.00, 30.04,   0.00, 0.00, 90.00);
	CreateDynamicObject(19073, -1133.37, 393.02, 30.04,   0.00, 0.00, 90.00);
	CreateDynamicObject(19073, -1073.43, 393.03, 30.04,   0.00, 0.00, 90.00);
	CreateDynamicObject(19070, -1014.29, 393.05, 24.78,   0.00, 0.00, 90.00);
	CreateDynamicObject(19070, -957.30, 393.07, 14.68,   0.00, 0.00, 90.00);
	CreateDynamicObject(19071, -899.02, 393.10, 9.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19071, -839.39, 393.04, 9.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19070, -782.28, 393.05, 14.50,   0.00, 0.00, -90.00);
	CreateDynamicObject(19073, -723.89, 393.05, 19.75,   0.00, 0.00, 90.00);
	CreateDynamicObject(19073, -664.22, 393.06, 19.75,   0.00, 0.00, 90.00);
	CreateDynamicObject(19073, -605.92, 393.17, 10.54,   18.00, 0.00, 90.00);
	CreateDynamicObject(19073, -548.99, 393.21, 1.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(19070, -490.61, 393.20, -6.30,   -25.00, 0.00, -90.00);
	CreateDynamicObject(18761, -519.44, 383.26, 5.61,   0.00, 0.00, 90.00);
	CreateDynamicObject(0, -514.89, 403.14, 5.61,   0.00, 0.00, 90.00);
	CreateDynamicObject(18761, -519.39, 403.29, 5.61,   0.00, 0.00, 90.00);
	CreateDynamicObject(18761, -1334.44, 403.32, 35.54,   0.00, 0.00, -90.00);
	CreateDynamicObject(18761, -1334.49, 382.70, 35.54,   0.00, 0.00, -90.00);
	CreateDynamicObject(3281, -1336.50, 412.37, 31.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1340.06, 412.41, 31.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1336.43, 373.59, 31.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1340.06, 373.63, 31.83,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1339.42, 393.24, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1314.23, 393.06, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1292.43, 393.02, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1271.27, 392.84, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1250.12, 392.76, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1220.93, 392.97, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1194.82, 392.77, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1163.54, 392.75, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1139.67, 392.94, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1114.71, 393.46, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1089.35, 392.88, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(711, -1049.25, 392.70, 35.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(1632, -1046.03, 409.85, 30.88,   0.00, 0.00, -92.00);
	CreateDynamicObject(1632, -1046.15, 405.72, 30.88,   0.00, 0.00, -92.00);
	CreateDynamicObject(1632, -1046.44, 399.86, 30.88,   0.00, 0.00, -92.00);
	CreateDynamicObject(1632, -1046.58, 395.74, 30.88,   0.00, 0.00, -92.00);
	CreateDynamicObject(1632, -1046.46, 390.12, 30.88,   0.00, 0.00, -92.00);
	CreateDynamicObject(1632, -1046.63, 386.23, 30.88,   0.00, 0.00, -92.00);
	CreateDynamicObject(1632, -1046.86, 379.97, 30.88,   0.00, 0.00, -92.00);
	CreateDynamicObject(1632, -1047.00, 375.85, 30.88,   0.00, 0.00, -92.00);
	CreateDynamicObject(8150, -1271.23, 373.36, 33.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8150, -1148.16, 373.30, 33.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(8150, -1270.57, 412.47, 33.80,   0.00, 0.00, -180.00);
	CreateDynamicObject(8150, -1147.45, 412.48, 33.80,   0.00, 0.00, -180.00);
	CreateDynamicObject(18649, -1341.31, 402.97, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1339.39, 402.98, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1337.42, 402.98, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1335.41, 402.98, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1333.44, 402.98, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1331.51, 402.97, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1329.57, 402.96, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1327.57, 402.93, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1325.66, 402.93, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1323.68, 402.95, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1321.71, 402.95, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1319.76, 402.94, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1317.82, 402.94, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1315.87, 402.94, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1313.92, 402.94, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1312.01, 402.93, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1310.08, 402.95, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1308.15, 402.94, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1306.15, 402.95, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1302.30, 402.90, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1304.26, 402.94, 31.07,   0.00, 0.00, 90.00);
	CreateDynamicObject(18649, -1300.40, 402.87, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1298.38, 402.85, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1296.40, 402.85, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1294.46, 402.82, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1292.52, 402.76, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1290.61, 402.76, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1288.64, 402.74, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1288.64, 402.74, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1286.68, 402.70, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1284.75, 402.65, 31.07,   0.00, 0.00, 89.10);
	CreateDynamicObject(18649, -1282.84, 402.69, 31.07,   0.00, 0.00, 96.00);
	CreateDynamicObject(18649, -1278.88, 402.80, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1280.86, 402.80, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1276.96, 402.80, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1275.04, 402.81, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1273.10, 402.83, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1271.18, 402.84, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1269.18, 402.87, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1267.21, 402.83, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1265.30, 402.77, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1263.35, 402.76, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1261.36, 402.76, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1259.36, 402.76, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1257.38, 402.78, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1255.43, 402.78, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1253.48, 402.77, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1251.52, 402.79, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1249.48, 402.75, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1247.53, 402.77, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1245.59, 402.76, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1243.57, 402.76, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1241.60, 402.79, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1239.62, 402.78, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1237.68, 402.77, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1235.66, 402.77, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1233.68, 402.76, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1231.75, 402.74, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1229.85, 402.71, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1227.87, 402.74, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1225.99, 402.70, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1224.09, 402.71, 31.07,   0.00, 0.00, 90.10);
	CreateDynamicObject(18649, -1223.00, 402.95, 31.07,   0.00, 0.00, 0.10);
	CreateDynamicObject(18651, -1341.23, 383.02, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1339.29, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1337.32, 383.02, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1335.36, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1333.37, 383.02, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1331.41, 383.00, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1329.39, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1327.36, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1325.44, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1323.46, 383.02, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1321.52, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1319.53, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1317.55, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1315.57, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1313.66, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1311.68, 383.00, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1309.72, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1307.71, 383.00, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1305.81, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1303.83, 382.99, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1301.86, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1299.90, 382.99, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1297.96, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1295.96, 382.99, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1293.96, 382.96, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1291.98, 382.96, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1290.01, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1288.04, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1286.07, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1284.11, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1282.16, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1280.24, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1278.24, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1276.22, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1274.22, 383.00, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1272.22, 382.96, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1270.26, 382.96, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1268.26, 382.96, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1266.32, 382.99, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1264.36, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1262.36, 382.99, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1260.46, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1258.49, 382.97, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1256.51, 382.99, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1254.51, 383.00, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1252.55, 382.99, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1250.68, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1248.69, 382.99, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1246.69, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1244.73, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1242.79, 383.01, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1240.85, 383.00, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1238.87, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1236.93, 382.98, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1235.09, 382.99, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1233.19, 382.97, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1231.24, 382.97, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1229.28, 382.96, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1227.40, 382.96, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1225.44, 382.96, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1223.71, 382.95, 31.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(18651, -1222.66, 383.08, 31.06,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -909.79, 382.99, 9.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -879.30, 382.90, 9.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -852.12, 382.86, 9.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -824.78, 382.81, 9.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -909.88, 402.93, 9.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -879.86, 403.07, 9.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -852.49, 403.05, 9.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -825.29, 403.04, 9.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -1334.68, 394.61, 34.44,   0.00, 0.00, 47.00);
	CreateDynamicObject(1262, -1334.76, 412.20, 34.44,   0.00, 0.00, 113.00);
	CreateDynamicObject(1262, -1334.87, 391.54, 34.44,   0.00, 0.00, 113.00);
	CreateDynamicObject(1262, -1334.87, 391.54, 34.44,   0.00, 0.00, 113.00);
	CreateDynamicObject(1262, -1334.79, 373.98, 34.44,   0.00, 0.00, 47.00);
	//Авто//
	CreateVehicle(539, -1337.8693, 378.3651, 30.6646, -90.0000, -1, -1, 100);
	CreateVehicle(539, -1336.6345, 387.6984, 30.6646, -90.0000, -1, -1, 100);
	CreateVehicle(539, -1336.1472, 398.1333, 30.6646, -90.0000, -1, -1, 100);
	CreateVehicle(539, -1336.3433, 408.1300, 30.6646, -90.0000, -1, -1, 100);
	//TRACK 8//
	CreateDynamicObject(16092, 2824.50, -1840.99, 9.38,   0.00, 0.00, 90.00);
	CreateDynamicObject(1237, 2836.71, -1829.02, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2837.93, -1818.48, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2839.24, -1809.59, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2840.66, -1800.28, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2842.26, -1790.56, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2835.07, -1791.60, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2832.88, -1806.63, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2837.43, -1772.87, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2838.85, -1763.32, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2840.38, -1753.59, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2841.94, -1743.65, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2845.62, -1722.79, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2844.15, -1731.22, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2847.78, -1713.02, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2850.14, -1703.65, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2852.65, -1694.46, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2854.41, -1687.48, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2856.37, -1680.25, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2858.48, -1673.05, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2861.83, -1669.98, 10.00,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2858.48, -1673.05, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2865.18, -1669.79, 10.00,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2866.45, -1672.37, 10.00,   0.00, 0.00, 0.06);
	CreateDynamicObject(978, 2844.82, -1663.09, 10.41,   0.00, 0.00, -113.00);
	CreateDynamicObject(978, 2849.65, -1655.37, 10.41,   0.00, 0.00, -131.00);
	CreateDynamicObject(978, 2856.92, -1650.29, 10.41,   0.00, 0.00, -159.00);
	CreateDynamicObject(978, 2865.83, -1649.19, 10.41,   0.00, 0.00, -187.00);
	CreateDynamicObject(978, 2874.14, -1652.48, 10.41,   0.00, 0.00, -216.00);
	CreateDynamicObject(978, 2879.74, -1659.44, 10.41,   0.00, 0.00, -246.00);
	CreateDynamicObject(978, 2880.09, -1667.42, 10.41,   0.00, 0.00, 73.00);
	CreateDynamicObject(1237, 2881.31, -1663.49, 10.00,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2878.72, -1672.05, 10.00,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2876.35, -1679.93, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2874.57, -1686.89, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2871.23, -1699.47, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2865.03, -1678.13, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2867.60, -1713.60, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2873.04, -1693.04, 10.52,   0.00, 0.00, -105.00);
	CreateDynamicObject(3578, 2869.48, -1706.73, 10.52,   0.00, 0.00, -104.00);
	CreateDynamicObject(1237, 2862.84, -1686.38, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2860.98, -1694.43, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2858.76, -1702.26, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2856.87, -1709.48, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2866.00, -1720.37, 10.52,   0.00, 0.00, -104.00);
	CreateDynamicObject(3578, 2863.34, -1734.33, 10.52,   0.00, 0.00, -99.00);
	CreateDynamicObject(1237, 2864.37, -1727.51, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2862.17, -1741.21, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2861.20, -1748.53, 10.52,   0.00, 0.00, -99.00);
	CreateDynamicObject(1237, 2859.82, -1755.21, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2858.97, -1762.09, 10.52,   0.00, 0.00, -99.00);
	CreateDynamicObject(1237, 2854.57, -1718.02, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2852.60, -1727.73, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2850.71, -1738.76, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2849.36, -1747.05, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2857.69, -1768.75, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2856.85, -1775.10, 10.52,   0.00, 0.00, -99.00);
	CreateDynamicObject(1237, 2855.43, -1781.72, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2854.49, -1788.61, 10.52,   0.00, 0.00, -99.00);
	CreateDynamicObject(1237, 2853.26, -1794.98, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2852.33, -1801.56, 10.52,   0.00, 0.00, -99.00);
	CreateDynamicObject(1237, 2851.07, -1807.96, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2850.24, -1814.22, 10.52,   0.00, 0.00, -99.00);
	CreateDynamicObject(1237, 2849.00, -1820.53, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2848.52, -1826.96, 10.52,   0.00, 0.00, -95.00);
	CreateDynamicObject(1237, 2847.67, -1833.63, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2847.34, -1840.45, 10.52,   0.00, 0.00, -95.00);
	CreateDynamicObject(1237, 2846.58, -1847.30, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2846.03, -1854.06, 10.52,   0.00, 0.00, -95.00);
	CreateDynamicObject(1237, 2845.24, -1860.61, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2844.81, -1866.95, 10.52,   0.00, 0.00, -95.00);
	CreateDynamicObject(1237, 2844.11, -1873.92, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2848.53, -1887.18, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 2848.55, -1897.49, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(1237, 2843.65, -1877.27, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2843.51, -1880.34, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2843.93, -1882.42, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2845.15, -1883.89, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2846.67, -1884.88, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2830.49, -1886.03, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 2830.48, -1896.34, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(1237, 2830.39, -1879.70, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2830.55, -1876.89, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2830.70, -1873.09, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2817.62, -1901.27, 10.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, 2827.52, -1901.27, 10.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, 2848.52, -1884.54, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2848.56, -1888.18, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2848.57, -1891.79, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2848.55, -1895.40, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2848.57, -1899.00, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 2847.72, -1976.05, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 2847.69, -1986.27, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3281, 2847.65, -1973.07, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2847.69, -1976.72, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2847.72, -1980.29, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2847.71, -1983.91, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2847.70, -1987.52, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2847.72, -1991.15, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2847.64, -1969.43, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3578, 2830.61, -1987.73, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 2830.65, -1977.47, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(1237, 2830.79, -1971.61, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2830.59, -1997.96, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 2830.58, -2008.10, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 2830.56, -2018.24, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 2830.52, -2028.52, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(1447, 2816.09, -2058.85, 11.38,   0.00, 0.00, 4.00);
	CreateDynamicObject(1447, 2821.30, -2058.52, 11.38,   0.00, 0.00, 4.00);
	CreateDynamicObject(1447, 2826.49, -2057.64, 11.38,   0.00, 0.00, 16.00);
	CreateDynamicObject(1447, 2831.43, -2055.84, 11.38,   0.00, 0.00, 24.00);
	CreateDynamicObject(1447, 2836.01, -2053.30, 11.38,   0.00, 0.00, 35.00);
	CreateDynamicObject(1447, 2840.08, -2049.94, 11.38,   0.00, 0.00, 45.00);
	CreateDynamicObject(1447, 2842.75, -2045.58, 11.38,   0.00, 0.00, 73.00);
	CreateDynamicObject(1447, 2844.20, -2040.57, 11.38,   0.00, 0.00, 76.00);
	CreateDynamicObject(620, 2845.56, -2037.92, 9.80,   356.86, 0.00, 3.14);
	CreateDynamicObject(1237, 2846.02, -2037.37, 9.94,   0.00, 0.00, 0.12);
	CreateDynamicObject(1237, 2830.44, -2035.19, 9.94,   0.00, 0.00, 0.12);
	CreateDynamicObject(1237, 2824.55, -2038.99, 9.94,   0.00, 0.00, 0.12);
	CreateDynamicObject(3578, 2817.60, -2038.79, 10.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 2827.08, -2038.77, 9.94,   0.00, 0.00, 0.12);
	CreateDynamicObject(1237, 2824.55, -2038.99, 9.94,   0.00, 0.00, 0.12);
	CreateDynamicObject(1237, 2829.32, -2037.51, 9.94,   0.00, 0.00, -0.48);
	CreateDynamicObject(8150, 2750.61, -2059.47, 10.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(620, 2814.15, -2059.03, 9.80,   356.86, 0.00, 3.14);
	CreateDynamicObject(671, 2827.45, -2036.24, 9.85,   356.86, 0.00, 3.14);
	CreateDynamicObject(671, 2821.27, -2036.70, 9.85,   356.86, 0.00, 3.32);
	CreateDynamicObject(671, 2845.78, -2045.61, 9.85,   356.86, 0.00, 3.14);
	CreateDynamicObject(671, 2828.51, -2029.14, 9.85,   356.86, 0.00, 3.32);
	CreateDynamicObject(671, 2828.51, -2029.14, 9.85,   356.86, 0.00, 3.32);
	CreateDynamicObject(671, 2841.57, -2052.40, 9.85,   356.86, 0.00, 3.14);
	CreateDynamicObject(671, 2835.56, -2057.04, 9.85,   356.86, 0.00, 3.14);
	CreateDynamicObject(671, 2827.53, -2059.88, 9.85,   356.86, 0.00, 3.14);
	CreateDynamicObject(671, 2820.29, -2060.97, 9.85,   356.86, 0.00, 3.14);
	CreateDynamicObject(671, 2814.32, -2060.38, 9.85,   356.86, 0.00, 3.14);
	CreateDynamicObject(3281, 2704.11, -2041.08, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2704.08, -2044.66, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2704.08, -2048.25, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2704.04, -2051.82, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2704.00, -2055.40, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2703.99, -2056.99, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(4527, 2698.61, -2053.40, 13.65,   0.00, 0.00, 135.00);
	CreateDynamicObject(4527, 2698.09, -2043.74, 13.65,   0.00, 0.00, 157.00);
	CreateDynamicObject(4527, 2699.45, -2004.22, 13.65,   0.00, 0.00, 139.00);
	CreateDynamicObject(3281, 2704.14, -1995.73, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2704.16, -1999.33, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2704.16, -2002.95, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2704.15, -2006.55, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2704.16, -2010.16, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2704.16, -2012.03, 13.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(4517, 2713.66, -1974.92, 14.09,   0.00, 0.00, 180.00);
	CreateDynamicObject(3281, 2722.51, -1984.35, 13.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, 2718.95, -1984.34, 13.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, 2715.34, -1984.36, 13.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, 2711.70, -1984.35, 13.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, 2708.06, -1984.33, 13.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, 2704.42, -1984.27, 13.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, 2765.78, -2003.07, 13.19,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, 2775.01, -2003.08, 13.19,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, 2779.70, -1989.18, 13.19,   0.00, 0.00, 90.00);
	CreateDynamicObject(979, 2779.69, -1998.43, 13.19,   0.00, 0.00, 90.00);
	CreateDynamicObject(708, 2761.05, -2003.62, 12.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(4517, 2747.82, -1891.33, 11.43,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 2758.23, -1885.47, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3578, 2758.21, -1895.69, 10.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3281, 2758.25, -1882.25, 11.85,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2758.24, -1885.88, 11.85,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2758.22, -1889.48, 11.85,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2758.23, -1893.11, 11.85,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2758.22, -1896.72, 11.85,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2758.17, -1900.32, 11.85,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2830.43, -1883.06, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2830.43, -1886.69, 11.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, 2830.46, -1890.31, 11.99,   0.00, 0.00, 89.94);
	CreateDynamicObject(3281, 2830.48, -1893.94, 11.99,   0.00, 0.00, 89.94);
	CreateDynamicObject(3281, 2830.45, -1897.54, 11.99,   0.00, 0.00, 89.94);
	CreateDynamicObject(3281, 2830.46, -1901.14, 11.99,   0.00, 0.00, 89.94);
	CreateDynamicObject(3819, 2850.51, -1887.63, 10.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3819, 2850.48, -1896.22, 10.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3785, 2819.88, -1841.64, 9.94,   -180.00, 90.00, 0.00);
	CreateDynamicObject(3785, 2820.82, -1841.66, 9.94,   -180.00, 90.00, 0.00);
	CreateDynamicObject(3785, 2821.99, -1841.68, 9.94,   -180.00, 90.00, 0.00);
	CreateDynamicObject(3785, 2823.09, -1841.68, 9.94,   -180.00, 90.00, 0.00);
	CreateDynamicObject(3785, 2824.15, -1841.68, 9.94,   -180.00, 90.00, 0.00);
	CreateDynamicObject(3785, 2825.25, -1841.67, 9.94,   -180.00, 90.00, 0.00);
	CreateDynamicObject(3785, 2826.43, -1841.67, 9.94,   -180.00, 90.00, 0.00);
	CreateDynamicObject(3785, 2827.60, -1841.66, 9.94,   -180.00, 90.00, 0.00);
	CreateDynamicObject(3785, 2829.02, -1841.68, 9.94,   -180.00, 90.00, 0.00);
	CreateDynamicObject(1262, 2817.68, -1841.88, 13.16,   0.00, 0.00, -180.00);
	CreateDynamicObject(1262, 2817.68, -1841.88, 15.35,   0.00, 0.00, -180.00);
	CreateDynamicObject(1262, 2831.21, -1841.89, 13.16,   0.00, 0.00, -180.00);
	CreateDynamicObject(1262, 2831.21, -1841.78, 15.35,   0.00, 0.00, -180.00);
	CreateDynamicObject(1237, 2848.02, -1755.06, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2846.70, -1765.07, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(1237, 2845.20, -1773.69, 9.94,   0.00, 0.00, 0.06);
	CreateDynamicObject(3578, 2836.04, -1784.27, 10.52,   0.00, 0.00, -97.00);
	CreateDynamicObject(3578, 2834.24, -1798.66, 10.52,   0.00, 0.00, -97.00);
	CreateDynamicObject(3578, 2832.18, -1814.72, 10.52,   0.00, 0.00, -97.00);
	CreateDynamicObject(3578, 2830.99, -1829.68, 10.52,   0.00, 0.00, -92.00);
	CreateDynamicObject(1237, 2831.21, -1822.08, 10.00,   0.00, 0.00, 0.00);
	//CAR//
	CreateVehicle(560, 2807.1804, -1860.3766, 9.4314, 0.0000, -1, -1, 100);
	CreateVehicle(561, 2802.7620, -1860.0729, 9.6053, 0.0000, -1, -1, 100);
	CreateVehicle(562, 2795.0498, -1858.9697, 9.4267, -69.0000, -1, -1, 100);
	CreateVehicle(562, 2794.0933, -1862.9471, 9.4267, -69.0000, -1, -1, 100);
	CreateVehicle(565, 2793.4539, -1867.0912, 9.3872, -69.0000, -1, -1, 100);
	//DRIFT//
	CreateDynamicObject(8171, -1396.78, 355.05, 6.15,   0.00, 0.00, 90.00);
	CreateDynamicObject(8171, -1396.96, 426.82, 6.15,   0.00, 0.00, 90.00);
	CreateDynamicObject(8171, -1307.85, 372.85, 6.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1341.83, 306.27, 6.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1316.08, 306.24, 6.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1300.63, 308.02, 6.69,   0.00, 0.00, -55.00);
	CreateDynamicObject(983, -1295.39, 311.69, 6.69,   0.00, 0.00, -55.00);
	CreateDynamicObject(3877, -1292.63, 313.55, 7.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1292.78, 326.58, 6.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1292.81, 352.17, 6.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1305.59, 365.00, 6.75,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1326.38, 364.98, 6.75,   0.00, 0.00, 90.00);
	CreateDynamicObject(3877, -1339.13, 364.95, 7.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1333.73, 344.36, 6.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1333.86, 330.52, 6.81,   0.00, 0.00, 180.00);
	CreateDynamicObject(979, -1329.35, 335.09, 6.81,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, -1329.36, 339.71, 6.81,   0.00, 0.00, -90.00);
	CreateDynamicObject(18846, -1330.76, 332.25, 10.95,   0.00, 0.00, 90.00);
	CreateDynamicObject(18846, -1330.54, 342.60, 10.95,   0.00, 0.00, 90.00);
	CreateDynamicObject(979, -1385.08, 370.39, 6.93,   0.00, 0.00, -180.00);
	CreateDynamicObject(979, -1425.27, 370.72, 6.93,   0.00, 0.00, -180.00);
	CreateDynamicObject(979, -1469.36, 365.61, 6.88,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, -1469.35, 356.35, 6.88,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, -1465.77, 348.65, 6.88,   0.00, 0.00, -40.00);
	CreateDynamicObject(979, -1458.67, 342.68, 6.88,   0.00, 0.00, -40.00);
	CreateDynamicObject(979, -1462.59, 401.36, 6.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(979, -1462.58, 392.06, 6.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(979, -1462.57, 382.72, 6.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(979, -1462.58, 375.46, 6.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(979, -1469.44, 416.36, 6.88,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, -1469.43, 425.71, 6.88,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, -1466.12, 433.65, 6.88,   0.00, 0.00, -135.00);
	CreateDynamicObject(979, -1459.10, 439.10, 6.88,   0.00, 0.00, -149.00);
	CreateDynamicObject(979, -1425.25, 411.53, 6.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1384.76, 411.51, 6.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1325.32, 416.12, 6.82,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1312.61, 419.26, 6.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1312.60, 425.63, 6.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1312.60, 432.01, 6.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1299.83, 435.15, 6.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1274.28, 435.22, 6.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1248.68, 435.22, 6.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1325.10, 447.45, 6.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1325.48, 451.68, 6.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1299.92, 451.72, 6.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1299.52, 447.45, 6.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1274.00, 447.46, 6.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1274.21, 451.81, 6.71,   0.00, 0.00, 90.00);
	CreateDynamicObject(979, -1256.85, 451.74, 6.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, -1256.55, 447.48, 6.86,   0.00, 0.00, 180.00);
	CreateDynamicObject(3877, -1251.93, 447.51, 7.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -1251.99, 451.86, 7.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -1251.96, 449.74, 7.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1235.85, 448.10, 6.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1235.87, 468.90, 6.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1235.87, 468.90, 7.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1235.87, 448.12, 7.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1235.98, 456.05, 9.28,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1254.41, 457.86, 10.65,   0.00, 0.00, 135.00);
	CreateDynamicObject(10830, -1288.42, 457.92, 10.65,   0.00, 0.00, 135.00);
	CreateDynamicObject(981, -1323.14, 449.53, 6.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(981, -1289.68, 449.66, 6.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(8150, -1375.25, 481.75, 7.00,   0.00, 0.00, 180.00);
	CreateDynamicObject(8150, -1444.26, 481.74, 7.00,   0.00, 0.00, 180.00);
	CreateDynamicObject(982, -1376.98, 467.19, 6.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1402.58, 467.20, 6.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1428.16, 467.16, 6.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1453.75, 467.13, 6.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(3877, -1466.57, 467.22, 7.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -1363.97, 467.21, 7.34,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1527.27, 459.01, 6.75,   0.00, 0.00, -47.00);
	CreateDynamicObject(983, -1531.94, 454.64, 6.75,   0.00, 0.00, -47.00);
	CreateDynamicObject(983, -1536.59, 450.27, 6.75,   0.00, 0.00, -47.00);
	CreateDynamicObject(983, -1541.28, 445.88, 6.75,   0.00, 0.00, -47.00);
	CreateDynamicObject(983, -1545.97, 441.53, 6.75,   0.00, 0.00, -47.00);
	CreateDynamicObject(983, -1550.70, 437.11, 6.75,   0.00, 0.00, -47.00);
	CreateDynamicObject(983, -1554.80, 432.28, 6.75,   0.00, 0.00, -33.00);
	CreateDynamicObject(983, -1558.26, 426.95, 6.75,   0.00, 0.00, -33.00);
	CreateDynamicObject(983, -1561.78, 421.59, 6.75,   0.00, 0.00, -33.00);
	CreateDynamicObject(983, -1565.27, 416.21, 6.75,   0.00, 0.00, -33.00);
	CreateDynamicObject(983, -1568.75, 410.83, 6.75,   0.00, 0.00, -33.00);
	CreateDynamicObject(983, -1572.24, 405.47, 6.75,   0.00, 0.00, -33.00);
	CreateDynamicObject(983, -1576.05, 400.34, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1580.21, 395.43, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1584.34, 390.54, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1588.48, 385.64, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1592.60, 380.72, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1596.72, 375.81, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1600.83, 370.97, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1604.96, 366.07, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1608.05, 360.59, 6.75,   0.00, 0.00, -18.00);
	CreateDynamicObject(981, -1596.62, 373.61, 6.82,   0.00, 0.00, 47.00);
	CreateDynamicObject(705, -1583.55, 385.76, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, -1550.03, 433.02, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, -1564.12, 411.99, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, -1564.12, 411.99, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, -1527.58, 454.50, 5.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(972, -1640.59, 350.49, 3.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(972, -1640.53, 325.53, 3.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(972, -1640.56, 300.68, 3.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(972, -1640.46, 276.02, 3.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1367.42, 306.25, 6.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1393.01, 306.25, 6.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1418.60, 306.24, 6.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1431.33, 302.95, 6.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1431.32, 296.57, 6.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1434.56, 293.43, 6.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1440.95, 293.44, 6.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1444.12, 293.44, 6.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1476.31, 305.85, 6.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1469.92, 305.85, 6.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1463.52, 305.83, 6.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1457.17, 305.79, 6.81,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1453.98, 309.00, 6.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1453.95, 315.39, 6.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1453.90, 321.74, 6.81,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1451.80, 327.33, 6.81,   0.00, 0.00, -40.00);
	CreateDynamicObject(982, -1447.33, 280.67, 6.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1449.38, 265.40, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1451.40, 262.95, 6.75,   0.00, 0.00, -40.00);
	CreateDynamicObject(983, -1476.26, 283.37, 6.75,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1469.85, 283.33, 6.75,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1466.64, 286.53, 6.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1466.65, 292.94, 6.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1466.64, 299.33, 6.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1466.63, 302.50, 6.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1454.37, 306.42, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1466.53, 305.86, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1467.02, 283.60, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1446.50, 292.77, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1430.96, 305.80, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1446.09, 282.91, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1446.09, 272.47, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1449.25, 263.47, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1413.20, 305.02, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1398.07, 304.80, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1382.86, 304.97, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1366.15, 305.04, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1350.70, 305.41, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1328.99, 305.71, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1302.97, 306.40, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1293.10, 364.79, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1301.74, 366.36, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1309.63, 366.43, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1319.34, 366.16, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1329.52, 366.35, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1291.87, 348.14, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1332.57, 339.40, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1332.57, 339.40, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1291.76, 335.60, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1291.85, 322.34, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1295.36, 309.93, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1291.55, 358.90, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1327.88, 415.97, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1312.72, 416.47, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1312.70, 433.19, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1319.25, 449.83, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1326.95, 449.82, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1387.97, 466.86, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1403.49, 466.96, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1418.72, 467.19, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1442.73, 466.83, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1534.95, 482.58, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1526.13, 482.11, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1637.23, 364.73, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1638.40, 347.88, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1638.23, 323.59, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1638.06, 299.32, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -1638.59, 275.76, 15.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(16092, -1562.39, 271.87, 5.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(16107, -1576.51, 312.62, 5.73,   0.00, 0.00, 0.00);
	CreateDynamicObject(16108, -1689.28, 283.19, 10.47,   0.00, 0.00, -185.00);
	CreateDynamicObject(939, -1690.15, 305.50, 8.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(907, -1663.63, 267.17, 10.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(11292, -1663.17, 266.24, 7.50,   0.00, 0.00, 178.00);
	CreateDynamicObject(1432, -1678.20, 277.79, 6.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(1432, -1689.12, 277.93, 6.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(1432, -1683.51, 282.26, 6.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(1432, -1676.04, 273.68, 6.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(1432, -1683.64, 275.26, 6.32,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, -1669.41, 292.92, 8.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, -1657.71, 293.06, 8.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, -1646.27, 293.12, 8.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, -1607.66, 313.12, 8.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, -1607.55, 303.34, 8.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(1597, -1607.42, 293.40, 8.64,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1575.88, 283.21, 6.78,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1595.10, 283.19, 6.78,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1608.08, 304.23, 6.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(3819, -1567.87, 286.57, 7.03,   0.00, 0.00, 90.00);
	CreateDynamicObject(3819, -1576.46, 286.56, 7.03,   0.00, 0.00, 90.00);
	CreateDynamicObject(3819, -1585.03, 286.54, 7.03,   0.00, 0.00, 90.00);
	CreateDynamicObject(14780, -1600.80, 312.12, 6.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(14780, -1591.24, 303.59, 6.89,   0.00, 0.00, 0.00);
	CreateDynamicObject(3819, -1593.31, 310.88, 7.03,   0.00, 0.00, 47.00);
	CreateDynamicObject(3281, -1563.15, 281.30, 7.13,   0.00, 0.00, 90.00);
	CreateDynamicObject(3281, -1563.13, 262.47, 7.13,   0.00, 0.00, 90.00);
	CreateDynamicObject(1262, -1563.21, 272.74, 13.43,   0.00, 0.00, 90.00);
	CreateDynamicObject(1262, -1563.22, 271.86, 13.43,   0.00, 0.00, 90.00);
	CreateDynamicObject(1262, -1563.22, 271.11, 13.43,   0.00, 0.00, 90.00);
	CreateDynamicObject(1262, -1563.30, 278.64, 13.43,   0.00, 0.00, 90.00);
	CreateDynamicObject(1262, -1563.29, 265.22, 13.43,   0.00, 0.00, 90.00);
	//CAR//
	CreateVehicle(435, -1677.5411, 309.3838, 7.6727, 0.0000, -1, -1, 100);
	CreateVehicle(435, -1668.8073, 308.7726, 7.6727, 0.0000, -1, -1, 100);
	CreateVehicle(435, -1664.2653, 308.6521, 7.6727, 0.0000, -1, -1, 100);
	CreateVehicle(451, -1654.0114, 265.4293, 7.6727, -127.0000, -1, -1, 100);
	CreateVehicle(463, -1673.4833, 273.6189, 6.6668, 156.0000, -1, -1, 100);
	CreateVehicle(463, -1671.4594, 273.2874, 6.6668, 156.0000, -1, -1, 100);
	CreateVehicle(475, -1685.2133, 294.0147, 6.8957, 156.0000, -1, -1, 100);
	CreateVehicle(475, -1694.5144, 294.1759, 6.8957, 156.0000, -1, -1, 100);
	CreateVehicle(477, -1641.9377, 290.7267, 6.8957, 156.0000, -1, -1, 100);
	CreateVehicle(477, -1642.1327, 303.0198, 6.8957, 156.0000, -1, -1, 100);
	CreateVehicle(494, -1641.3536, 277.9368, 6.9471, 90.0000, -1, -1, 100);
	CreateVehicle(494, -1641.5748, 273.4676, 6.9471, 90.0000, -1, -1, 100);
	//New трасса
	CreateObject(19129, -2186.89, -126.74, 60.80,   0.00, 0.00, 0.00);
	CreateObject(19129, -2206.82, -126.75, 60.80,   0.00, 0.00, 0.00);
	CreateObject(18784, -2206.91, -106.75, 63.33,   0.00, 0.00, 89.88);
	CreateObject(18784, -2186.97, -106.85, 63.33,   0.00, 0.00, 89.88);
	CreateObject(18783, -2196.65, -86.83, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2196.63, -66.80, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2196.59, -46.84, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2176.58, -46.88, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2156.57, -46.93, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2136.53, -46.94, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18784, -2136.52, -46.97, 68.23,   0.00, 0.00, 0.00);
	CreateObject(18783, -2103.91, -46.64, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2083.97, -46.65, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2083.96, -26.71, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2083.95, -6.78, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2083.95, 13.29, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2083.90, 33.25, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18784, -2084.02, 33.29, 68.29,   0.00, 0.00, 90.24);
	CreateObject(18783, -2084.35, 64.83, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2084.36, 84.70, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2084.38, 104.69, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2104.35, 104.68, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2124.30, 104.70, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2144.29, 104.72, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2164.30, 104.79, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2184.18, 104.82, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2184.21, 84.77, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2184.23, 64.88, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2204.22, 64.91, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2224.18, 64.93, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2244.03, 64.94, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2244.01, 44.97, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2243.98, 25.07, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2244.29, 5.43, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2264.01, 5.43, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2284.02, 5.33, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2284.00, -14.68, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2283.98, -34.65, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2283.97, -54.53, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2284.04, -74.51, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2284.06, -94.38, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2284.09, -114.34, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2264.10, -114.38, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2264.05, -134.07, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2263.99, -154.06, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2264.00, -174.03, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2244.03, -174.11, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2224.02, -174.13, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2204.19, -174.12, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2184.17, -174.12, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2184.17, -154.12, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2204.11, -154.11, 63.32,   0.00, 0.00, 0.00);
	CreateObject(18783, -2224.07, -154.13, 63.32,   0.00, 0.00, 0.00);
	CreateObject(3578, -2201.43, -37.47, 66.55,   0.00, 0.00, 0.06);
	CreateObject(3578, -2191.14, -37.46, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2206.03, -43.05, 66.55,   0.00, 0.00, 89.70);
	CreateObject(3578, -2206.09, -53.28, 66.55,   0.00, 0.00, 89.70);
	CreateObject(3578, -2089.36, -56.04, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2079.09, -56.06, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2074.57, -50.38, 66.55,   0.00, 0.00, 89.88);
	CreateObject(3578, -2074.54, -40.09, 66.55,   0.00, 0.00, 89.88);
	CreateObject(3578, -2079.56, 114.11, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2089.83, 114.13, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2074.90, 108.49, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2189.04, 114.23, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2178.72, 114.26, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2074.96, 98.35, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2193.64, 108.58, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2193.67, 98.41, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2193.65, 80.11, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2199.29, 74.35, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2179.42, 55.44, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2189.67, 55.49, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2174.78, 61.08, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2174.76, 71.32, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2248.94, 74.35, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2238.76, 74.33, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2253.43, 68.66, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2253.49, 58.43, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2253.39, 20.51, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2259.13, 14.82, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2234.55, 0.54, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2240.32, -4.07, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2250.59, -4.06, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2288.83, 14.75, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2278.61, 14.74, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2234.52, 10.78, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2293.43, 9.05, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2293.47, -1.21, 66.55,   0.00, 0.00, 89.82);
	CreateObject(3578, -2293.47, -119.22, 66.55,   0.00, 0.00, 90.06);
	CreateObject(3578, -2287.85, -123.77, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2293.48, -109.00, 66.55,   0.00, 0.00, 90.06);
	CreateObject(3578, -2268.93, -104.96, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2259.24, -104.96, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2254.65, -110.62, 66.55,   0.00, 0.00, 90.06);
	CreateObject(3578, -2279.11, -123.79, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2254.66, -120.82, 66.55,   0.00, 0.00, 90.06);
	CreateObject(3578, -2273.45, -129.58, 66.55,   0.00, 0.00, 90.06);
	CreateObject(3578, -2273.47, -139.80, 66.55,   0.00, 0.00, 90.06);
	CreateObject(3578, -2273.43, -178.91, 66.55,   0.00, 0.00, 90.06);
	CreateObject(3578, -2273.43, -168.71, 66.55,   0.00, 0.00, 90.06);
	CreateObject(3578, -2267.81, -183.47, 66.55,   0.00, 0.00, 0.00);
	CreateObject(3578, -2257.55, -183.47, 66.55,   0.00, 0.00, 0.00);
	//машины
	CreateVehicle(560, -2179.1560, -134.9117, 61.4721, 0.0000, -1, -1, 100);
	CreateVehicle(560, -2185.4407, -134.9697, 61.4721, 0.0000, -1, -1, 100);
	CreateVehicle(560, -2214.5435, -134.9431, 61.4721, 0.0000, -1, -1, 100);
	CreateVehicle(560, -2208.2690, -134.9756, 61.4721, 0.0000, -1, -1, 100);
	//////////////кафешка
    CreateDynamicObject(18762,1289.95000000,-1869.53000000,12.50000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18766,1300.08000000,-1880.95000000,13.00000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18766,1291.80000000,-1880.88000000,13.00000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18766,1287.32000000,-1876.34000000,13.00000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(18766,1287.31000000,-1873.96000000,13.00000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(18766,1304.57000000,-1876.49000000,13.00000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(1491,1290.41000000,-1869.19000000,12.54000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18762,1292.42000000,-1869.50000000,12.50000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(18762,1295.30000000,-1869.50000000,13.00000000,90.00000000,90.00000000,0.00000000); //
    CreateDynamicObject(18762,1300.24000000,-1869.48000000,13.00000000,90.00000000,90.00000000,0.00000000); //
    CreateDynamicObject(18762,1305.14000000,-1869.48000000,13.00000000,90.00000000,90.00000000,0.00000000); //
    CreateDynamicObject(18762,1287.45000000,-1869.52000000,13.00000000,90.00000000,90.00000000,0.00000000); //
    CreateDynamicObject(18766,1304.58000000,-1873.99000000,13.00000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(19325,1296.06000000,-1869.20000000,13.00000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(19325,1302.65000000,-1869.20000000,13.00000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(19325,1287.00000000,-1869.14000000,13.00000000,0.00000000,0.00000000,90.00000000); //
    CreateDynamicObject(3095,1302.52000000,-1873.56000000,15.00000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3095,1293.59000000,-1873.54000000,15.00000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3095,1284.68000000,-1873.55000000,15.00000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3095,1300.54000000,-1882.47000000,15.00000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(3095,1291.58000000,-1882.40000000,15.00000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(19128,1302.35000000,-1871.84000000,12.50000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(19128,1302.39000000,-1875.76000000,12.50000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(19128,1302.40000000,-1879.65000000,12.50000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(19128,1298.48000000,-1871.82000000,12.50000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(19128,1298.47000000,-1875.75000000,12.50000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(19128,1298.48000000,-1879.68000000,12.50000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(16151,1288.84000000,-1876.01000000,12.87000000,0.00000000,0.00000000,180.00000000); //
    CreateDynamicObject(1408,1302.31000000,-1862.34000000,13.10000000,0.00000000,0.00000000,180.00000000); //
    CreateDynamicObject(1408,1297.10000000,-1862.34000000,13.10000000,0.00000000,0.00000000,180.00000000); //
    CreateDynamicObject(1408,1294.68000000,-1862.33000000,13.10000000,0.00000000,0.00000000,180.00000000); //
    CreateDynamicObject(1408,1287.80000000,-1862.36000000,13.10000000,0.00000000,0.00000000,180.00000000); //
    CreateDynamicObject(1491,1290.47000000,-1862.36000000,11.00000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1481,1304.18000000,-1868.19000000,13.20000000,0.00000000,0.00000000,-130.00000000); //
    CreateDynamicObject(1281,1302.72000000,-1865.04000000,13.35000000,0.00000000,0.00000000,30.00000000); //
    CreateDynamicObject(1281,1298.00000000,-1864.37000000,13.35000000,0.00000000,0.00000000,-10.00000000); //
    CreateDynamicObject(1281,1295.11000000,-1866.82000000,13.35000000,0.00000000,0.00000000,60.00000000); //
    CreateDynamicObject(1723,1293.24000000,-1870.54000000,12.55000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(2315,1293.53000000,-1872.13000000,12.55000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1723,1295.51000000,-1879.87000000,12.55000000,0.00000000,0.00000000,180.00000000); //
    CreateDynamicObject(1510,1294.24000000,-1872.06000000,13.05000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1670,1294.97000000,-1872.18000000,13.05000000,0.00000000,0.00000000,30.00000000); //
    CreateDynamicObject(1486,1293.81000000,-1872.25000000,13.18000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1486,1293.20000000,-1871.82000000,13.18000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1486,1293.38000000,-1872.21000000,13.18000000,0.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1485,1294.06000000,-1872.01000000,13.09000000,50.00000000,0.00000000,0.00000000); //
    CreateDynamicObject(1485,1294.22000000,-1872.25000000,13.09000000,50.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(1670,1297.14000000,-1864.35000000,13.46000000,0.00000000,0.00000000,50.00000000); //
	CreateDynamicObject(1670,1298.31000000,-1864.64000000,13.46000000,0.00000000,0.00000000,30.00000000); //
	CreateDynamicObject(1670,1295.26000000,-1866.16000000,13.46000000,0.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(1670,1302.11000000,-1865.05000000,13.46000000,0.00000000,0.00000000,120.00000000); //
	CreateDynamicObject(1518,1289.78000000,-1874.46000000,13.77000000,0.00000000,0.00000000,-30.00000000); //
	CreateDynamicObject(982,1294.75000000,-1869.12000000,16.24000000,0.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(3534,1302.78000000,-1869.70000000,16.70000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(3534,1299.55000000,-1869.73000000,16.70000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(3534,1296.37000000,-1869.73000000,16.70000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(3534,1293.17000000,-1869.74000000,16.70000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(3534,1289.91000000,-1869.67000000,16.70000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(3534,1287.25000000,-1869.60000000,16.70000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19122,1304.83000000,-1862.54000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19122,1302.98000000,-1862.47000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19124,1301.29000000,-1862.49000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19125,1299.65000000,-1862.52000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19126,1298.08000000,-1862.52000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19127,1296.06000000,-1862.48000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19122,1294.21000000,-1862.52000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19122,1292.54000000,-1862.50000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19123,1290.25000000,-1862.57000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19124,1288.48000000,-1862.64000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19125,1287.38000000,-1862.55000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(18192,1299.10000000,-1873.74000000,15.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(18102,1301.84000000,-1871.69000000,15.55000000,0.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(18102,1297.74000000,-1871.34000000,15.55000000,0.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(18102,1292.00000000,-1871.44000000,15.55000000,0.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(1827,1294.54000000,-1878.31000000,12.55000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(1486,1295.09000000,-1878.07000000,13.18000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(1486,1294.53000000,-1878.77000000,13.18000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(1486,1294.01000000,-1877.75000000,13.18000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(1575,1294.58000000,-1877.67000000,12.98000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(1212,1294.95000000,-1878.66000000,12.97000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(1212,1293.89000000,-1878.36000000,12.97000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(349,1294.17000000,-1877.98000000,13.09000000,90.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(1330,1288.14000000,-1870.38000000,13.00000000,0.00000000,0.00000000,0.00000000); //
		//Drag 2
	CreateDynamicObject(3578, -2668.29, 1270.20, 55.00,   0.00, 0.00, 0.00);
CreateDynamicObject(3578, -2668.46, 1270.19, 55.00,   0.00, 0.00, 0.00);
CreateDynamicObject(3578, -2694.61, 1270.23, 55.00,   0.00, 0.00, 0.00);
CreateDynamicObject(3578, -2694.65, 1270.19, 55.00,   0.00, 0.00, 0.00);
CreateDynamicObject(712, -2698.62, 1268.07, 63.54,   0.00, 0.00, 0.00);
CreateDynamicObject(712, -2692.39, 1268.08, 63.54,   0.00, 0.00, 0.00);
CreateDynamicObject(712, -2670.85, 1268.38, 63.54,   0.00, 0.00, 0.00);
CreateDynamicObject(712, -2664.18, 1268.32, 63.54,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2691.80, 1280.91, 54.27,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2697.73, 1280.88, 54.27,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2695.07, 1280.94, 54.27,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2664.51, 1280.10, 54.27,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2667.93, 1280.13, 54.27,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2671.19, 1280.24, 54.27,   0.00, 0.00, 0.00);
CreateDynamicObject(3877, -2672.55, 1265.08, 56.85,   0.00, 0.00, 0.00);
CreateDynamicObject(3877, -2681.87, 1265.22, 56.85,   0.00, 0.00, 0.00);
CreateDynamicObject(3877, -2690.59, 1265.21, 56.85,   0.00, 0.00, 0.00);
CreateDynamicObject(19127, -2689.61, 1267.85, 55.40,   0.00, 0.00, 0.00);
CreateDynamicObject(19127, -2689.58, 1268.76, 55.40,   0.00, 0.00, 0.00);
CreateDynamicObject(19127, -2689.58, 1269.69, 55.40,   0.00, 0.00, 0.00);
CreateDynamicObject(19127, -2680.88, 1267.87, 55.40,   0.00, 0.00, 0.00);
CreateDynamicObject(19127, -2680.85, 1268.75, 55.40,   0.00, 0.00, 0.00);
CreateDynamicObject(19127, -2680.85, 1269.57, 55.40,   0.00, 0.00, 0.00);
CreateDynamicObject(19127, -2673.47, 1267.84, 55.40,   0.00, 0.00, 0.00);
CreateDynamicObject(19127, -2673.48, 1268.86, 55.40,   0.00, 0.00, 0.00);
CreateDynamicObject(19127, -2673.49, 1269.62, 55.40,   0.00, 0.00, 0.00);
CreateDynamicObject(16092, -2675.10, 1295.07, 53.81,   0.00, 0.00, 89.94);
CreateDynamicObject(16092, -2689.01, 1295.06, 53.81,   0.00, 0.00, 89.94);
CreateDynamicObject(1237, -2667.35, 1295.50, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2666.75, 1295.44, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2666.17, 1295.40, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2665.66, 1295.38, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2665.17, 1295.29, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2696.67, 1295.65, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2697.37, 1295.66, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2698.05, 1295.67, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2698.77, 1295.74, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2699.41, 1295.84, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1237, -2664.69, 1295.27, 54.03,   0.00, 0.00, 0.00);
CreateDynamicObject(1262, -2676.65, 1294.01, 61.37,   0.00, 0.00, -181.44);
CreateDynamicObject(1262, -2676.18, 1294.05, 61.37,   0.00, 0.00, -181.44);
CreateDynamicObject(1262, -2675.71, 1294.13, 61.37,   0.00, 0.00, -181.44);
CreateDynamicObject(1262, -2690.59, 1293.95, 61.37,   0.00, 0.00, -181.44);
CreateDynamicObject(1262, -2690.11, 1293.93, 61.37,   0.00, 0.00, -181.44);
CreateDynamicObject(1262, -2689.65, 1293.93, 61.37,   0.00, 0.00, -181.44);
CreateDynamicObject(3749, -2673.72, 2143.70, 60.17,   0.00, 0.00, 1.44);
CreateDynamicObject(3749, -2689.95, 2143.28, 60.17,   0.00, 0.00, 1.44);
CreateDynamicObject(3578, -2696.54, 2177.73, 55.13,   0.00, 0.00, 5.22);
CreateDynamicObject(3578, -2686.34, 2178.65, 55.14,   0.00, 0.00, 5.22);
CreateDynamicObject(3578, -2676.21, 2179.57, 55.13,   0.00, 0.00, 5.22);
CreateDynamicObject(3578, -2666.54, 2180.43, 55.13,   0.00, 0.00, 5.22);
CreateDynamicObject(712, -2699.68, 2176.35, 63.44,   0.00, 0.00, 0.00);
CreateDynamicObject(712, -2690.22, 2177.26, 62.96,   0.00, 0.00, 0.00);
CreateDynamicObject(712, -2682.67, 2178.16, 62.96,   0.00, 0.00, 0.00);
CreateDynamicObject(712, -2675.41, 2179.15, 62.96,   0.00, 0.00, 0.00);
CreateDynamicObject(712, -2665.65, 2179.53, 62.96,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2698.42, 2147.39, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2698.49, 2151.80, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2698.53, 2156.11, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2698.53, 2160.22, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2698.60, 2164.02, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2698.67, 2167.65, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2698.89, 2171.23, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2699.28, 2174.26, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2681.60, 2147.91, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2681.79, 2151.41, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2681.84, 2154.99, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2682.04, 2158.65, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2682.27, 2162.59, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2682.48, 2166.48, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2682.40, 2170.16, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2682.19, 2173.51, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2682.14, 2176.23, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2665.28, 2148.95, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2665.46, 2152.86, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2665.63, 2156.79, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2665.69, 2160.53, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2665.89, 2164.64, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2666.02, 2168.44, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2666.24, 2172.22, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2666.35, 2175.97, 55.08,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2671.48, 2178.99, 54.31,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2678.84, 2178.28, 54.61,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2695.44, 2177.20, 54.38,   0.00, 0.00, 0.00);
CreateDynamicObject(700, -2685.79, 2178.11, 54.38,   0.00, 0.00, 0.00);

	//Drag 1
	CreateDynamicObject(8150, -1624.50, -108.76, 15.73,   0.00, 0.00, -135.00);
	CreateDynamicObject(8150, -1537.48, -21.86, 15.73,   0.00, 0.00, -135.00);
	CreateDynamicObject(8150, -1450.64, 65.05, 15.73,   0.00, 0.00, -135.00);
	CreateDynamicObject(8150, -1363.65, 151.97, 15.73,   0.00, 0.00, -135.00);
	CreateDynamicObject(8150, -1276.67, 238.88, 15.73,   0.00, 0.00, -135.00);
	CreateDynamicObject(8150, -1189.63, 325.89, 15.73,   0.00, 0.00, -135.00);
	CreateDynamicObject(8150, -1168.34, 302.83, 15.73,   0.00, 0.00, 45.00);
	CreateDynamicObject(8150, -1255.26, 215.80, 15.73,   0.00, 0.00, 45.00);
	CreateDynamicObject(8150, -1342.28, 128.81, 15.73,   0.00, 0.00, 45.00);
	CreateDynamicObject(8150, -1429.23, 41.85, 15.73,   0.00, 0.00, 45.00);
	CreateDynamicObject(8150, -1516.18, -45.10, 15.73,   0.00, 0.00, 45.00);
	CreateDynamicObject(8150, -1602.17, -131.07, 15.73,   0.00, 0.00, 45.00);
	CreateDynamicObject(8556, -1660.71, -167.48, 17.46,   0.00, 0.00, -45.00);
	CreateDynamicObject(3877, -1647.08, -173.97, 14.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -1656.64, -164.16, 14.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -1667.16, -154.16, 14.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1672.94, -162.49, 14.12,   0.00, 0.00, 45.00);
	CreateDynamicObject(3281, -1670.38, -159.93, 14.12,   0.00, 0.00, 45.00);
	CreateDynamicObject(3281, -1667.84, -157.35, 14.12,   0.00, 0.00, 45.00);
	CreateDynamicObject(3281, -1655.10, -179.92, 14.06,   0.00, 0.00, 45.00);
	CreateDynamicObject(3281, -1652.49, -177.31, 14.06,   0.00, 0.00, 45.00);
	CreateDynamicObject(3281, -1649.95, -174.78, 14.06,   0.00, 0.00, 45.00);
	CreateDynamicObject(16092, -1645.79, -163.76, 13.14,   0.00, 0.00, 45.00);
	CreateDynamicObject(16092, -1656.25, -153.27, 13.14,   0.00, 0.00, 45.00);
	CreateDynamicObject(1262, -1647.62, -163.11, 20.54,   0.00, 0.00, 135.00);
	CreateDynamicObject(1262, -1646.53, -164.20, 20.54,   0.00, 0.00, 135.00);
	CreateDynamicObject(1262, -1645.44, -165.25, 20.54,   0.00, 0.00, 135.00);
	CreateDynamicObject(1262, -1655.89, -154.78, 20.54,   0.00, 0.00, 135.00);
	CreateDynamicObject(1262, -1656.88, -153.80, 20.54,   0.00, 0.00, 135.00);
	CreateDynamicObject(1262, -1657.96, -152.75, 20.54,   0.00, 0.00, 135.00);
	CreateDynamicObject(3578, -1141.11, 373.55, 13.89,   0.00, 0.00, 45.00);
	CreateDynamicObject(3578, -1133.80, 380.79, 13.89,   0.00, 0.00, 45.00);
	CreateDynamicObject(3578, -1126.53, 388.01, 13.89,   0.00, 0.00, 45.00);
	CreateDynamicObject(3578, -1120.14, 350.67, 13.89,   0.00, 0.00, 45.00);
	CreateDynamicObject(3578, -1112.91, 357.88, 13.89,   0.00, 0.00, 45.00);
	CreateDynamicObject(3578, -1105.66, 365.10, 13.89,   0.00, 0.00, 45.00);
	CreateDynamicObject(3578, -1099.24, 372.77, 13.89,   0.00, 0.00, 55.00);
	CreateDynamicObject(3578, -1099.81, 380.34, 13.89,   0.00, 0.00, -45.00);
	CreateDynamicObject(3578, -1118.43, 393.55, 13.89,   0.00, 0.00, -156.00);
	CreateDynamicObject(3578, -1111.12, 391.45, 13.89,   0.00, 0.00, -224.00);
	CreateDynamicObject(3578, -1105.94, 386.39, 13.89,   0.00, 0.00, -224.00);
	CreateDynamicObject(710, -1114.30, 395.26, 24.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1107.58, 388.17, 24.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1103.68, 384.49, 24.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(710, -1096.42, 377.00, 24.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1647.37, -154.81, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1647.37, -154.81, 14.96,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1647.37, -154.81, 16.18,   0.00, 0.00, -45.00);
	CreateDynamicObject(3485, -1566.13, -256.05, 20.29,   0.00, 0.00, 225.00);
	CreateDynamicObject(3485, -1587.56, -277.55, 20.29,   0.00, 0.00, 225.00);
	CreateDynamicObject(3485, -1608.92, -298.89, 20.29,   0.00, 0.00, 225.00);
	CreateDynamicObject(3485, -1630.29, -320.28, 20.29,   0.00, 0.00, 225.00);
	CreateDynamicObject(3605, -1520.91, -118.74, 19.02,   0.00, 0.00, 45.00);
	CreateDynamicObject(3605, -1492.20, -90.27, 19.02,   0.00, 0.00, 45.00);
	CreateDynamicObject(982, -1629.27, -136.70, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1611.14, -118.58, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1593.02, -100.48, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1574.91, -82.40, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1556.81, -64.34, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1538.76, -46.26, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1520.65, -28.17, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1502.52, -10.10, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1484.42, 7.98, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1466.26, 26.06, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1448.17, 44.15, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1430.08, 62.24, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1411.97, 80.36, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1393.92, 98.49, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1375.79, 116.59, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1357.68, 134.71, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1339.60, 152.79, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1321.50, 170.88, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1303.38, 188.96, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1285.28, 207.09, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1267.13, 225.19, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1249.07, 243.26, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1230.95, 261.33, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1212.87, 279.38, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1194.77, 297.45, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1176.69, 315.51, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1158.58, 333.61, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(700, -1122.69, 348.06, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1118.03, 352.61, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1113.94, 356.73, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1109.76, 360.95, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1106.12, 364.59, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1102.24, 368.41, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1098.62, 373.63, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1100.38, 381.00, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1105.83, 386.37, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1111.63, 392.01, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1123.12, 391.59, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1119.11, 393.42, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1127.78, 387.09, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1131.88, 382.94, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1136.92, 377.96, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1144.07, 370.87, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1140.18, 374.73, 13.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1636.50, -184.51, 12.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1625.37, -188.74, 12.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1609.51, -189.69, 12.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(19051, -1629.96, -228.12, 13.11,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, -1244.66, -1.51, 12.38,   0.00, 0.00, 0.00);
	CreateDynamicObject(8150, -1264.19, -83.57, 16.10,   0.00, 0.00, 45.00);
	CreateDynamicObject(8150, -1361.94, -180.92, 16.10,   0.00, 0.00, 45.00);
	CreateDynamicObject(700, -1631.81, -186.35, 12.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1617.35, -189.09, 12.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(7520, -1225.79, -23.79, 13.38,   0.00, 0.00, 135.00);
	CreateDynamicObject(10377, -1241.56, -141.81, 31.15,   0.00, 0.00, -135.24);
	CreateDynamicObject(3486, -1267.25, -227.17, 20.25,   0.00, 0.00, 134.94);
	CreateDynamicObject(3486, -1288.50, -205.87, 20.25,   0.00, 0.00, 134.94);
	CreateDynamicObject(3486, -1309.50, -184.89, 20.25,   0.00, 0.00, 134.94);
	CreateDynamicObject(3607, -1515.86, -200.41, 19.11,   0.00, 0.00, -135.06);
	CreateDynamicObject(3607, -1488.01, -172.46, 19.11,   0.00, 0.00, -135.06);
	CreateDynamicObject(3607, -1460.21, -144.64, 19.11,   0.00, 0.00, -135.06);
	CreateDynamicObject(3605, -1578.50, -176.11, 19.02,   0.00, 0.00, 45.00);
	CreateDynamicObject(3605, -1550.19, -147.76, 19.02,   0.00, 0.00, 45.00);
	CreateDynamicObject(10830, -1639.79, -148.61, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1606.02, -114.83, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1572.30, -81.10, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1538.41, -47.21, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1504.58, -13.28, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1470.66, 20.69, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1436.79, 54.59, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1403.02, 88.37, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1369.21, 122.16, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1335.49, 156.04, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1301.68, 189.87, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1267.88, 223.63, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1234.04, 257.62, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1200.22, 291.42, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1166.52, 325.20, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(10830, -1150.72, 341.02, 21.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(3485, -1536.88, -226.14, 20.29,   0.00, 0.00, 225.00);
	CreateDynamicObject(9582, -1687.15, -308.59, 21.85,   0.00, 0.00, 135.00);
	CreateDynamicObject(1501, -1711.73, -288.36, 13.05,   0.00, 0.00, -210.00);
	CreateDynamicObject(12950, -1700.21, -281.86, 14.24,   0.00, 0.00, -120.00);
	CreateDynamicObject(12950, -1694.72, -285.04, 18.98,   0.00, 0.00, -120.00);
	CreateDynamicObject(12950, -1689.29, -288.16, 23.82,   0.00, 0.00, -120.00);
	CreateDynamicObject(983, -1682.41, -292.86, 27.05,   0.00, 90.00, 62.00);
	CreateDynamicObject(983, -1681.83, -291.77, 27.05,   0.00, 90.00, 62.00);
	CreateDynamicObject(983, -1681.60, -291.31, 27.67,   0.00, 0.00, 62.00);
	CreateDynamicObject(983, -1680.38, -295.56, 27.67,   0.00, 0.00, -30.00);
	CreateDynamicObject(983, -1700.59, -278.76, 13.77,   0.00, 0.00, 45.00);
	CreateDynamicObject(983, -1696.08, -283.26, 13.77,   0.00, 0.00, 45.00);
	CreateDynamicObject(983, -1691.58, -287.82, 13.77,   0.00, 0.00, 45.00);
	CreateDynamicObject(983, -1712.24, -267.08, 13.77,   0.00, 0.00, 45.00);
	CreateDynamicObject(983, -1716.77, -262.55, 13.77,   0.00, 0.00, 45.00);
	CreateDynamicObject(983, -1720.13, -259.18, 13.77,   0.00, 0.00, 45.00);
	CreateDynamicObject(983, -1722.39, -260.11, 13.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1722.38, -266.47, 13.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1722.37, -272.83, 13.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1722.36, -279.21, 13.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1722.34, -285.56, 13.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1722.37, -291.89, 13.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(1501, -1705.52, -286.70, 13.05,   0.00, 0.00, -155.00);
	CreateDynamicObject(1501, -1702.72, -285.37, 13.05,   0.00, 0.00, -155.00);
	CreateDynamicObject(19071, -1678.98, -295.74, 0.49,   90.00, 0.00, 150.00);
	CreateDynamicObject(18649, -1664.13, -299.96, 13.33,   0.00, 0.00, 62.00);
	CreateDynamicObject(18649, -1673.07, -294.81, 13.33,   0.00, 0.00, 62.00);
	CreateDynamicObject(18649, -1681.80, -290.35, 13.33,   0.00, 0.00, 62.00);
	CreateDynamicObject(18649, -1690.77, -285.82, 13.33,   0.00, 0.00, 62.00);
	CreateDynamicObject(18751, -1179.77, -46.53, 4.78,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -1132.53, 4.57, 4.78,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -1119.99, -104.65, 4.78,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -1060.29, -25.66, 4.78,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -1044.54, -153.30, 4.78,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -986.88, -87.81, 4.78,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -933.98, -1.02, 7.74,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -994.90, 51.03, 7.74,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -1052.69, 69.68, 7.74,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -990.41, 138.73, 7.74,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -894.43, 103.80, 7.74,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -876.30, 196.98, 7.74,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -958.74, 241.17, 7.74,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -865.02, 284.37, 7.74,   0.00, 0.00, -40.00);
	CreateDynamicObject(18751, -809.14, 244.88, 7.74,   0.00, 0.00, -40.00);
	CreateDynamicObject(9132, -1597.05, -193.30, 32.15,   0.00, 0.00, -45.24);
	CreateDynamicObject(9132, -1557.78, -232.73, 32.15,   0.00, 0.00, -45.24);
	CreateDynamicObject(700, -1699.54, -280.13, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1702.98, -276.60, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1710.26, -269.40, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1713.57, -265.94, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1716.90, -262.55, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1721.51, -258.13, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1722.49, -263.32, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1722.35, -268.36, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1722.39, -273.17, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1722.39, -277.71, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1722.37, -282.49, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1722.39, -287.19, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -1722.25, -291.99, 12.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(18784, -1645.02, -246.01, 15.58,   0.00, 0.00, 135.60);
	CreateDynamicObject(18784, -1659.00, -260.30, 15.62,   0.00, 0.00, 135.60);
	CreateDynamicObject(18783, -1659.29, -232.05, 15.58,   0.00, 0.00, 45.60);
	CreateDynamicObject(18783, -1673.25, -246.32, 15.64,   0.00, 0.00, 45.60);
	CreateDynamicObject(984, -1663.92, -222.51, 18.80,   0.00, 0.00, -44.34);
	CreateDynamicObject(984, -1672.85, -231.65, 18.80,   0.00, 0.00, -44.34);
	CreateDynamicObject(984, -1681.80, -240.79, 18.80,   0.00, 0.00, -44.34);
	CreateDynamicObject(984, -1682.85, -241.87, 18.80,   0.00, 0.00, -44.34);
	CreateDynamicObject(984, -1682.74, -250.97, 18.80,   0.00, 0.00, -134.52);
	CreateDynamicObject(984, -1677.59, -256.04, 18.80,   0.00, 0.00, -134.52);
	CreateDynamicObject(984, -1654.86, -222.45, 18.80,   0.00, 0.00, -134.52);
	CreateDynamicObject(984, -1649.69, -227.52, 18.80,   0.00, 0.00, -134.52);
	CreateDynamicObject(1231, -1672.98, -260.20, 20.77,   0.00, 0.00, -45.54);
	CreateDynamicObject(1231, -1678.41, -254.93, 20.77,   0.00, 0.00, -45.54);
	CreateDynamicObject(1231, -1682.52, -250.90, 20.77,   0.00, 0.00, -45.54);
	CreateDynamicObject(1231, -1687.02, -246.45, 20.77,   0.00, 0.00, -45.54);
	CreateDynamicObject(1231, -1681.58, -240.87, 20.77,   0.00, 0.00, 45.36);
	CreateDynamicObject(1231, -1675.97, -235.19, 20.77,   0.00, 0.00, 45.36);
	CreateDynamicObject(1231, -1670.36, -229.48, 20.77,   0.00, 0.00, 45.36);
	CreateDynamicObject(1231, -1664.73, -223.79, 20.77,   0.00, 0.00, 45.36);
	CreateDynamicObject(1231, -1659.41, -218.32, 20.77,   0.00, 0.00, 137.34);
	CreateDynamicObject(1231, -1654.41, -223.28, 20.77,   0.00, 0.00, 137.34);
	CreateDynamicObject(1231, -1650.60, -227.03, 20.77,   0.00, 0.00, 137.34);
	CreateDynamicObject(1231, -1645.45, -232.02, 20.77,   0.00, 0.00, 137.34);
	CreateDynamicObject(18783, -1705.83, -161.64, 10.68,   0.00, 0.00, 45.60);
	CreateDynamicObject(18783, -1715.64, -179.98, 10.68,   0.00, 0.00, 45.60);
	CreateDynamicObject(18783, -1719.80, -175.91, 10.68,   0.00, 0.00, 45.60);
	CreateDynamicObject(18783, -1703.18, -164.24, 10.68,   0.00, 0.00, 45.60);
	CreateDynamicObject(18784, -1720.14, -147.69, 10.69,   0.00, 0.00, -44.22);
	CreateDynamicObject(18784, -1734.08, -161.97, 10.69,   0.00, 0.00, -44.22);
	CreateDynamicObject(18784, -1748.45, -147.99, 5.80,   0.00, 0.00, -44.22);
	CreateDynamicObject(18784, -1734.47, -133.73, 5.84,   0.00, 0.00, -44.22);
	CreateDynamicObject(18784, -1748.69, -119.89, 0.93,   0.00, 0.00, -44.22);
	CreateDynamicObject(18784, -1762.65, -134.21, 0.93,   0.00, 0.00, -44.22);
	CreateDynamicObject(8150, -1373.57, -192.55, 16.10,   0.00, 0.00, 45.00);
	CreateDynamicObject(8150, -1271.57, -284.10, 16.10,   0.00, 0.00, 45.00);
	CreateDynamicObject(8150, -1176.31, -159.53, 16.10,   0.00, 0.00, 64.26);
	CreateDynamicObject(8150, -1258.53, -271.06, 16.10,   0.00, 0.00, 45.00);
	CreateDynamicObject(3814, -1172.62, -109.36, 19.77,   0.00, 0.00, 0.00);
	CreateDynamicObject(3749, -1210.58, -221.39, 18.76,   0.00, 0.00, 44.04);
	CreateDynamicObject(3749, -1312.43, -133.06, 18.76,   0.00, 0.00, 44.04);
	CreateDynamicObject(982, -1140.47, 351.71, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(982, -1137.08, 355.10, 13.74,   0.00, 0.00, -45.00);
	CreateDynamicObject(3877, -1128.11, 364.16, 13.89,   0.00, 0.00, -44.04);
	CreateDynamicObject(3877, -1132.56, 359.49, 13.89,   0.00, 0.00, -44.04);
	CreateDynamicObject(3877, -1137.11, 354.94, 13.89,   0.00, 0.00, -44.04);
	CreateDynamicObject(3877, -1141.66, 350.47, 13.89,   0.00, 0.00, -44.04);
	CreateDynamicObject(3877, -1146.08, 345.95, 13.89,   0.00, 0.00, -44.04);
	CreateDynamicObject(3877, -1150.71, 341.55, 13.89,   0.00, 0.00, -44.04);
	CreateDynamicObject(10377, -1433.16, -31.54, 31.28,   0.00, 0.00, -45.00);
	CreateDynamicObject(10377, -1345.29, 52.51, 31.28,   0.00, 0.00, -45.00);
	CreateDynamicObject(18783, -1705.83, -161.64, 5.97,   0.00, 0.00, 45.60);
	CreateDynamicObject(18783, -1705.83, -161.64, 1.27,   0.00, 0.00, 45.60);
	//DRAG SF
	CreateObject(18766, -2326.44, 1087.96, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2321.56, 1087.01, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2316.65, 1086.04, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2323.60, 1079.18, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2329.29, 1072.99, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2324.39, 1072.05, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2319.49, 1071.09, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18765, -2327.17, 1069.63, 56.47,   0.00, -90.00, 80.00);
	CreateObject(18765, -2322.45, 1068.59, 56.47,   0.00, -90.00, 80.00);
	CreateObject(18766, -2330.16, 1067.08, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2325.23, 1066.11, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2320.33, 1065.17, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2324.38, 1085.49, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2332.73, 1052.18, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2327.81, 1051.22, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2322.93, 1050.28, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2327.20, 1058.76, 56.51,   0.00, -90.00, -11.00);
	CreateObject(18766, -2325.32, 1080.58, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2326.26, 1075.70, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2327.19, 1070.80, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2328.11, 1065.94, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2329.05, 1061.05, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2330.00, 1056.16, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2330.49, 1053.74, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2318.89, 1084.44, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2319.83, 1079.63, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2320.75, 1074.89, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2321.73, 1069.99, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2322.73, 1065.07, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2323.65, 1060.17, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2324.58, 1055.34, 61.01,   -90.00, 0.00, -11.00);
	CreateObject(18766, -2325.00, 1052.89, 61.03,   -90.00, 0.00, -11.00);
	CreateObject(18762, -2320.39, 1060.44, 60.04,   -90.00, 11.00, 0.00);
	CreateObject(18762, -2321.57, 1054.57, 60.04,   -90.00, 11.00, 0.00);
	CreateObject(18762, -2321.00, 1057.49, 58.18,   0.00, 0.00, 347.08);
	CreateObject(18762, -2321.00, 1057.49, 56.91,   0.00, 0.00, 347.08);
	CreateObject(1262, -2317.25, 1075.09, 60.05,   0.00, -90.00, 83.00);
	CreateObject(1262, -2322.18, 1054.42, 60.05,   0.00, -90.00, 83.00);
	CreateObject(1263, -2321.58, 1057.55, 58.80,   0.00, 0.00, 0.00);
	CreateObject(18762, -2316.72, 1074.80, 60.04,   -90.00, 11.00, 0.00);
	CreateObject(18762, -2316.11, 1077.67, 58.38,   0.00, 0.00, 347.08);
	CreateObject(18762, -2316.11, 1077.67, 56.91,   0.00, 0.00, 347.08);
	CreateObject(18762, -2315.80, 1080.63, 60.04,   -90.00, 11.00, 0.00);
	CreateObject(1262, -2321.02, 1060.40, 60.05,   0.00, -90.00, 83.00);
	CreateObject(1262, -2316.45, 1080.72, 60.05,   0.00, -90.00, 83.00);
	CreateObject(1263, -2316.70, 1077.83, 58.80,   0.00, 0.00, 0.00);
	CreateObject(19128, -2348.64, 1075.27, 54.68,   0.00, 0.00, -18.00);
	CreateObject(19128, -2347.99, 1070.88, 54.68,   0.00, 0.00, -18.00);
	CreateObject(19128, -2345.54, 1078.43, 54.78,   0.00, 0.00, -18.00);
	CreateObject(19128, -2345.57, 1078.47, 54.68,   0.00, 0.00, -18.00);
	CreateObject(19128, -2348.64, 1075.27, 54.78,   0.00, 0.00, -18.00);
	CreateObject(19128, -2347.99, 1070.88, 54.78,   0.00, 0.00, -18.00);
	CreateObject(19128, -2344.87, 1074.03, 54.68,   0.00, 0.00, -18.00);
	CreateObject(19128, -2344.87, 1074.03, 54.78,   0.00, 0.00, -18.00);
	CreateObject(19125, -2344.24, 1075.84, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2343.35, 1075.53, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2342.58, 1075.29, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2342.75, 1074.49, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2342.99, 1073.74, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2343.30, 1073.00, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2343.53, 1072.34, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2343.72, 1071.75, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2344.48, 1071.95, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2345.25, 1072.17, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2348.13, 1077.21, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2349.02, 1077.43, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2349.84, 1077.61, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2350.10, 1076.89, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2350.33, 1076.12, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2350.55, 1075.40, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2350.73, 1074.75, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2350.89, 1074.04, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2350.10, 1073.85, 55.25,   0.00, 0.00, 0.00);
	CreateObject(19125, -2349.34, 1073.59, 55.25,   0.00, 0.00, 0.00);
	CreateObject(973, -2280.30, 1064.89, 55.39,   0.00, 0.00, 180.00);
	CreateObject(973, -2289.68, 1064.91, 55.39,   0.00, 0.00, 180.00);
	CreateObject(973, -2299.03, 1065.15, 55.39,   0.00, 0.00, 177.00);
	CreateObject(973, -2308.34, 1065.78, 55.39,   0.00, 0.00, 175.00);
	CreateObject(973, -2317.69, 1066.60, 55.39,   0.00, 0.00, 175.00);
	CreateObject(973, -2252.79, 1064.89, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2243.45, 1064.90, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2234.09, 1064.94, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2224.72, 1064.93, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2220.50, 1064.94, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2192.74, 1064.76, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2183.38, 1064.76, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2173.99, 1064.77, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2164.62, 1064.78, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2155.24, 1064.78, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2145.88, 1064.79, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2140.58, 1064.77, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2112.75, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2103.38, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2094.03, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2084.67, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2075.30, 1064.87, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2065.92, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2056.58, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2047.22, 1064.84, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2037.88, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2028.51, 1064.87, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2019.12, 1064.87, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2009.81, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -2000.47, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -1991.12, 1064.85, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -1981.73, 1064.82, 55.50,   0.00, 0.00, 180.00);
	CreateObject(973, -1973.68, 1064.86, 55.50,   0.00, 0.00, 180.00);
	CreateObject(18761, -1968.49, 1055.81, 55.71,   0.00, 0.00, 90.00);
	CreateObject(18761, -1968.11, 1076.94, 55.71,   0.00, 0.00, 90.00);
	CreateObject(973, -2062.63, 1089.70, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -2053.25, 1089.65, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -2043.91, 1089.67, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -2034.54, 1089.67, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -2025.18, 1089.69, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -2015.80, 1089.69, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -2006.43, 1089.68, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -1997.07, 1089.70, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -1987.71, 1089.70, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -1981.11, 1089.70, 55.54,   0.00, 0.00, 180.00);
	CreateObject(973, -1972.27, 1087.49, 55.54,   0.00, 0.00, 152.00);
	CreateObject(973, -2062.69, 1042.27, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2053.34, 1042.23, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2043.98, 1042.20, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2034.62, 1042.14, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2025.26, 1042.13, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2015.85, 1042.15, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2006.51, 1042.14, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -1997.13, 1042.13, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -1987.74, 1042.10, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -1978.36, 1042.13, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2252.77, 1066.99, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2243.39, 1066.96, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2280.60, 1067.01, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2289.95, 1067.00, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2299.28, 1067.08, 55.50,   0.00, 0.00, -1.00);
	CreateObject(973, -2308.60, 1067.48, 55.50,   0.00, 0.00, -4.00);
	CreateObject(973, -2317.75, 1068.14, 55.50,   0.00, 0.00, -4.00);
	CreateObject(973, -2234.05, 1066.93, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2224.67, 1066.89, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2220.64, 1066.88, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2192.72, 1066.87, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2183.37, 1066.84, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2173.98, 1066.84, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2164.60, 1066.85, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2155.24, 1066.83, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2145.92, 1066.79, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2140.58, 1066.78, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2112.68, 1066.97, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2103.30, 1066.93, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2093.95, 1066.92, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2084.57, 1066.89, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2075.20, 1066.90, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2065.82, 1066.94, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2056.43, 1066.93, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2047.07, 1066.92, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2037.77, 1066.93, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2028.42, 1066.92, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2019.08, 1066.92, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2009.74, 1066.91, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -2000.38, 1066.86, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -1991.00, 1066.86, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -1981.66, 1066.86, 55.50,   0.00, 0.00, 0.00);
	CreateObject(973, -1972.82, 1067.44, 55.50,   0.00, 0.00, 7.00);
	CreateObject(19121, -2329.01, 1088.88, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2320.67, 1079.48, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2326.14, 1080.02, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2326.37, 1079.25, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2332.07, 1073.97, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2333.17, 1067.35, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2329.86, 1059.64, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2330.02, 1058.87, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2335.30, 1053.02, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2335.44, 1052.38, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2329.16, 1088.05, 55.17,   0.00, 0.00, 0.00);
	CreateObject(19121, -2321.38, 1079.56, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2322.04, 1079.66, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2322.61, 1079.73, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.18, 1079.78, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.80, 1079.85, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.43, 1079.92, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.40, 1079.38, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.02, 1078.91, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.46, 1078.52, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2322.93, 1078.26, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2322.41, 1078.12, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2321.94, 1078.19, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2321.60, 1078.32, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2321.22, 1078.50, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2320.94, 1078.77, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2320.67, 1079.12, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2321.61, 1074.78, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2322.21, 1074.94, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2322.76, 1075.07, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.32, 1075.21, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.89, 1075.33, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.44, 1075.44, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2325.09, 1075.55, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2321.72, 1074.33, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2321.82, 1073.82, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2322.21, 1073.48, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2322.73, 1073.40, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.06, 1073.56, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.21, 1073.94, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.14, 1074.44, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.09, 1074.80, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.64, 1074.07, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.08, 1073.84, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.51, 1073.62, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.93, 1073.41, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2325.45, 1073.31, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2326.15, 1070.04, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2325.81, 1069.71, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2325.40, 1069.32, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.94, 1068.95, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.54, 1068.57, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.27, 1068.26, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.93, 1067.90, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.55, 1067.50, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.24, 1067.02, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2323.74, 1067.05, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.26, 1067.11, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.73, 1067.20, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2325.21, 1067.27, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2325.70, 1067.36, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2326.11, 1067.42, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2326.58, 1067.51, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.86, 1068.42, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.92, 1068.04, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.98, 1067.63, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2325.24, 1060.66, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.93, 1061.01, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.61, 1061.60, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.61, 1062.33, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2324.94, 1062.96, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2325.60, 1063.21, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2326.12, 1063.40, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2326.71, 1063.50, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2327.23, 1063.37, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2327.66, 1062.87, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2327.90, 1062.31, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2327.98, 1061.71, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2327.57, 1061.33, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2327.00, 1061.01, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2326.89, 1061.46, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2327.04, 1060.60, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2327.60, 1060.65, 61.33,   0.00, 0.00, 0.00);
	CreateObject(19121, -2328.20, 1060.69, 61.33,   0.00, 0.00, 0.00);
	//DRAG SF
	//DRAG 2
	CreateDynamicObject(3578, -2668.29, 1270.20, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, -2668.46, 1270.19, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, -2694.61, 1270.23, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, -2694.65, 1270.19, 55.00,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -2698.62, 1268.07, 63.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -2692.39, 1268.08, 63.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -2670.85, 1268.38, 63.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -2664.18, 1268.32, 63.54,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2691.80, 1280.91, 54.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2697.73, 1280.88, 54.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2695.07, 1280.94, 54.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2664.51, 1280.10, 54.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2667.93, 1280.13, 54.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2671.19, 1280.24, 54.27,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -2672.55, 1265.08, 56.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -2681.87, 1265.22, 56.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(3877, -2690.59, 1265.21, 56.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -2689.61, 1267.85, 55.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -2689.58, 1268.76, 55.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -2689.58, 1269.69, 55.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -2680.88, 1267.87, 55.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -2680.85, 1268.75, 55.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -2680.85, 1269.57, 55.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -2673.47, 1267.84, 55.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -2673.48, 1268.86, 55.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -2673.49, 1269.62, 55.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(16092, -2675.10, 1295.07, 53.81,   0.00, 0.00, 89.94);
	CreateDynamicObject(16092, -2689.01, 1295.06, 53.81,   0.00, 0.00, 89.94);
	CreateDynamicObject(1237, -2667.35, 1295.50, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2666.75, 1295.44, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2666.17, 1295.40, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2665.66, 1295.38, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2665.17, 1295.29, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2696.67, 1295.65, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2697.37, 1295.66, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2698.05, 1295.67, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2698.77, 1295.74, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2699.41, 1295.84, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, -2664.69, 1295.27, 54.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -2676.65, 1294.01, 61.37,   0.00, 0.00, -181.44);
	CreateDynamicObject(1262, -2676.18, 1294.05, 61.37,   0.00, 0.00, -181.44);
	CreateDynamicObject(1262, -2675.71, 1294.13, 61.37,   0.00, 0.00, -181.44);
	CreateDynamicObject(1262, -2690.59, 1293.95, 61.37,   0.00, 0.00, -181.44);
	CreateDynamicObject(1262, -2690.11, 1293.93, 61.37,   0.00, 0.00, -181.44);
	CreateDynamicObject(1262, -2689.65, 1293.93, 61.37,   0.00, 0.00, -181.44);
	CreateDynamicObject(3749, -2673.72, 2143.70, 60.17,   0.00, 0.00, 1.44);
	CreateDynamicObject(3749, -2689.95, 2143.28, 60.17,   0.00, 0.00, 1.44);
	CreateDynamicObject(3578, -2696.54, 2177.73, 55.13,   0.00, 0.00, 5.22);
	CreateDynamicObject(3578, -2686.34, 2178.65, 55.14,   0.00, 0.00, 5.22);
	CreateDynamicObject(3578, -2676.21, 2179.57, 55.13,   0.00, 0.00, 5.22);
	CreateDynamicObject(3578, -2666.54, 2180.43, 55.13,   0.00, 0.00, 5.22);
	CreateDynamicObject(712, -2699.68, 2176.35, 63.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -2690.22, 2177.26, 62.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -2682.67, 2178.16, 62.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -2675.41, 2179.15, 62.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(712, -2665.65, 2179.53, 62.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2698.42, 2147.39, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2698.49, 2151.80, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2698.53, 2156.11, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2698.53, 2160.22, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2698.60, 2164.02, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2698.67, 2167.65, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2698.89, 2171.23, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2699.28, 2174.26, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2681.60, 2147.91, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2681.79, 2151.41, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2681.84, 2154.99, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2682.04, 2158.65, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2682.27, 2162.59, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2682.48, 2166.48, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2682.40, 2170.16, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2682.19, 2173.51, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2682.14, 2176.23, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2665.28, 2148.95, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2665.46, 2152.86, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2665.63, 2156.79, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2665.69, 2160.53, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2665.89, 2164.64, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2666.02, 2168.44, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2666.24, 2172.22, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2666.35, 2175.97, 55.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2671.48, 2178.99, 54.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2678.84, 2178.28, 54.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2695.44, 2177.20, 54.38,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, -2685.79, 2178.11, 54.38,   0.00, 0.00, 0.00);
	//DRAG 2
	//Drag 4
	CreateDynamicObject(6189, -1123.33, 94.17, -1.36,   0.00, 0.00, 135.30);
	CreateDynamicObject(6189, -1031.41, 187.05, -1.36,   0.00, 0.00, 135.30);
	CreateDynamicObject(6189, -939.61, 279.81, -1.36,   0.00, 0.00, 135.30);
	CreateDynamicObject(6189, -847.82, 372.59, -1.36,   0.00, 0.00, 135.30);
	CreateDynamicObject(6189, -755.77, 465.62, -1.36,   0.00, 0.00, 135.30);
	CreateDynamicObject(6189, -663.93, 558.38, -1.36,   0.00, 0.00, 135.30);
	CreateDynamicObject(3578, -1208.45, 62.94, 13.91,   0.00, 0.00, 316.57);
	CreateDynamicObject(3620, -1200.27, 54.73, 26.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(14396, -1164.20, 50.51, 11.72,   0.00, 0.00, 0.00);
	CreateDynamicObject(14397, -1159.04, 36.70, 12.30,   0.00, 0.00, 315.35);
	CreateDynamicObject(14397, -1170.44, 47.97, 12.30,   0.00, 0.00, 315.34);
	CreateDynamicObject(3927, -1161.61, 54.63, 15.75,   0.00, 0.00, 318.32);
	CreateDynamicObject(18285, -1208.90, 48.00, 13.22,   0.00, 0.00, 340.15);
	CreateDynamicObject(3578, -1201.31, 56.14, 13.92,   0.00, 0.00, 316.56);
	CreateDynamicObject(3578, -1197.26, 52.23, 13.93,   0.00, 0.00, 316.56);
	CreateDynamicObject(3578, -1188.27, 52.28, 13.93,   0.00, 0.00, 43.90);
	CreateDynamicObject(10079, -1183.00, 57.83, 16.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(1215, -1192.77, 48.24, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(1238, -1157.80, 34.04, 13.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(1238, -1155.68, 31.93, 13.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(1238, -1156.70, 32.96, 13.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(1262, -1163.53, 56.13, 16.45,   0.00, 0.00, 138.70);
	CreateDynamicObject(996, -1168.85, 48.58, 13.90,   0.00, 0.00, 46.64);
	CreateDynamicObject(1655, -628.03, 606.96, 14.45,   0.00, 0.00, 315.11);
	CreateDynamicObject(1655, -616.81, 595.46, 14.25,   359.50, 359.50, 315.11);
	CreateDynamicObject(1262, -1161.93, 54.52, 16.45,   0.00, 0.00, 138.70);
	CreateDynamicObject(736, -1212.09, 66.01, 24.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(736, -1210.11, 64.16, 24.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(736, -1208.00, 62.20, 24.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(736, -1205.72, 60.01, 24.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(736, -1203.36, 57.71, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1200.95, 55.30, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1198.70, 53.28, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1196.46, 51.04, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1194.15, 48.97, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1192.04, 48.91, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1190.89, 50.00, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1189.74, 51.12, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1188.54, 52.28, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1187.23, 53.49, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1185.99, 54.72, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1185.08, 55.64, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(3578, -1246.39, 37.31, 13.91,   0.00, 0.00, 316.57);
	CreateDynamicObject(3578, -1253.87, 44.41, 13.91,   0.00, 0.00, 316.57);
	CreateDynamicObject(736, -1213.20, -27.78, 24.38,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1206.77, -21.47, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1199.96, -15.03, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1193.35, -8.43, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1186.70, -1.78, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1179.95, 4.92, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1173.48, 11.43, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1166.85, 18.05, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1160.38, 24.81, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(736, -1154.66, 30.80, 24.37,   0.00, 0.00, -0.30);
	CreateDynamicObject(3927, -1163.05, 55.93, 15.75,   0.00, 0.00, 318.32);
	CreateDynamicObject(1263, -1162.62, 55.25, 16.50,   0.00, 0.00, 45.00);
	CreateDynamicObject(18761, -1170.18, 47.81, 13.14,   0.00, 0.00, -45.00);
	CreateDynamicObject(19127, -1163.38, 41.20, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1162.95, 40.77, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1162.49, 40.33, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1162.05, 39.89, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1161.59, 39.43, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1161.13, 38.96, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1160.62, 38.47, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1160.14, 37.98, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1159.64, 37.50, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1159.18, 37.09, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1158.68, 36.56, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1158.14, 36.01, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1176.96, 54.61, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1177.55, 55.21, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1178.17, 55.87, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1178.84, 56.53, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1179.43, 57.10, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1180.10, 57.77, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1180.71, 58.32, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(19127, -1181.20, 58.87, 13.71,   0.00, 0.00, 0.00);
	CreateDynamicObject(3578, -1212.77, 67.05, 13.91,   0.00, 0.00, 316.57);
	CreateDynamicObject(736, -1214.12, 68.00, 24.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(736, -1216.47, 70.27, 24.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(3749, -1242.54, -6.38, 18.78,   0.00, 0.00, -70.00);
	CreateDynamicObject(987, -1228.82, -23.41, 13.25,   0.00, 0.00, 135.00);
	CreateDynamicObject(987, -1220.40, -31.89, 13.25,   0.00, 0.00, 135.00);
	CreateDynamicObject(987, -1216.17, -36.11, 13.25,   0.00, 0.00, 135.00);
	CreateDynamicObject(987, -1244.10, 3.61, 13.25,   0.00, 0.00, 100.00);
	CreateDynamicObject(987, -1245.16, 9.49, 13.25,   0.00, 0.00, 100.00);
	//Drag 4
	/////ЗОНА ЖИЛЫХ ДОМОВ ЗАБРОШЕНЫЙ АЭРО
	CreateDynamicObject(3485, 363.00, 2459.71, 22.45,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 333.01, 2459.77, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 302.96, 2459.80, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 272.78, 2459.77, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 242.85, 2459.72, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 212.87, 2459.67, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 182.83, 2459.76, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 152.71, 2459.73, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 122.74, 2459.71, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 92.69, 2459.65, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 62.59, 2459.71, 22.51,   0.00, 0.00, 180.00);
	CreateDynamicObject(987, 47.81, 2486.33, 15.06,   0.00, 0.00, -90.00);
	CreateDynamicObject(987, 47.84, 2498.31, 15.06,   0.00, 0.00, -90.00);
	CreateDynamicObject(3749, 49.39, 2507.35, 20.79,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 47.74, 2528.62, 15.06,   0.00, 0.00, -90.00);
	CreateDynamicObject(3485, 62.71, 2545.32, 22.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 47.68, 2540.45, 15.06,   0.00, 0.00, -90.00);
	CreateDynamicObject(987, 47.67, 2552.41, 15.06,   0.00, 0.00, -90.00);
	CreateDynamicObject(987, 47.64, 2564.10, 15.06,   0.00, 0.00, -90.00);
	CreateDynamicObject(3485, 92.73, 2545.24, 22.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(3485, 122.81, 2545.30, 22.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(3485, 152.86, 2545.43, 22.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(3485, 182.91, 2545.44, 22.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 90.56, 2503.01, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 110.05, 2502.89, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 129.61, 2502.72, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 151.88, 2502.21, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 172.55, 2502.42, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 192.92, 2502.64, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 213.80, 2502.75, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 234.40, 2502.65, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 255.42, 2502.67, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 275.23, 2502.53, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 294.34, 2502.14, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 314.15, 2501.89, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(3618, 333.89, 2501.37, 17.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 312.76, 2497.29, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 333.73, 2495.55, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 294.02, 2497.08, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 274.76, 2497.48, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 255.22, 2497.43, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 234.27, 2497.24, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 213.28, 2497.62, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 192.16, 2497.96, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 172.21, 2497.85, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 151.42, 2497.19, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 129.23, 2496.81, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 110.00, 2497.95, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 90.08, 2498.20, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 49.57, 2494.45, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 50.03, 2520.70, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 49.35, 2477.33, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(8171, 66.67, 2507.04, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(8171, 106.54, 2511.34, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(8171, 195.51, 2489.23, 15.57,   0.00, 0.00, 90.00);
	CreateDynamicObject(8171, 333.75, 2489.27, 15.57,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, 356.12, 2507.68, 16.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, 381.70, 2507.68, 16.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, 210.59, 2528.43, 16.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, 236.14, 2528.45, 16.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, 261.64, 2528.40, 16.06,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, 261.64, 2528.40, 17.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, 236.13, 2528.45, 17.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, 210.57, 2528.46, 17.33,   0.00, 0.00, 90.00);
	CreateDynamicObject(700, 187.78, 2531.85, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 157.22, 2532.07, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 127.15, 2532.11, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 97.57, 2531.41, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 67.11, 2531.38, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 118.57, 2473.61, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 88.30, 2473.80, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 146.31, 2474.27, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 178.00, 2473.90, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 208.21, 2473.61, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 236.80, 2474.26, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 268.57, 2473.82, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 298.47, 2473.73, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 327.67, 2474.21, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 358.53, 2473.59, 15.44,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, 407.28, 2507.70, 16.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, 421.62, 2507.69, 16.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(705, 434.65, 2484.34, 15.09,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, 435.76, 2495.62, 15.09,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, 436.19, 2506.64, 15.07,   0.00, 0.00, 0.00);
	///АВТО
	CreateVehicle(500, 53.1754, 2470.3130, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 82.9805, 2468.9907, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 113.5509, 2470.3118, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 142.7917, 2469.0437, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 173.2648, 2468.7581, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 202.8778, 2468.8442, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 233.3651, 2468.2192, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 262.8473, 2468.7144, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 293.2834, 2468.3779, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 324.1805, 2467.5403, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(500, 354.4369, 2467.4255, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(400, 421.2015, 2440.2991, 16.5992, 0.0000, -1, -1, 100);
	CreateVehicle(400, 416.9727, 2440.3877, 16.5992, 0.0000, -1, -1, 100);
	CreateVehicle(411, 412.3554, 2439.2610, 16.1910, 0.0000, -1, -1, 100);
	CreateVehicle(411, 408.0128, 2439.1023, 16.1910, 0.0000, -1, -1, 100);
	CreateVehicle(411, 403.2173, 2439.2554, 16.1910, 0.0000, -1, -1, 100);
	CreateVehicle(420, 399.0354, 2439.4329, 16.4478, 0.0000, -1, -1, 100);
	CreateVehicle(420, 393.9641, 2439.4695, 16.4478, 0.0000, -1, -1, 100);
	CreateVehicle(420, 388.6141, 2439.2195, 16.4478, 0.0000, -1, -1, 100);
	CreateVehicle(433, 387.9282, 2451.2930, 16.7121, 0.0000, -1, -1, 100);
	CreateVehicle(433, 387.5977, 2463.6980, 16.7121, 0.0000, -1, -1, 100);
	CreateVehicle(555, 392.9495, 2448.5493, 16.2062, 0.0000, -1, -1, 100);
	CreateVehicle(555, 397.0062, 2448.2883, 16.2062, 0.0000, -1, -1, 100);
	CreateVehicle(555, 400.8618, 2447.9651, 16.2062, 0.0000, -1, -1, 100);
	CreateVehicle(556, 405.6714, 2447.0994, 16.3812, 0.0000, -1, -1, 100);
	CreateVehicle(556, 410.6863, 2446.9001, 16.3812, 0.0000, -1, -1, 100);
	CreateVehicle(556, 417.7257, 2446.4026, 16.3812, 0.0000, -1, -1, 100);
	CreateVehicle(429, 418.9120, 2453.4229, 16.0535, 0.0000, -1, -1, 100);
	CreateVehicle(429, 418.8726, 2459.8767, 16.0535, 0.0000, -1, -1, 100);
	CreateVehicle(429, 422.9153, 2459.9807, 16.0535, 0.0000, -1, -1, 100);
	CreateVehicle(431, 413.1609, 2459.3435, 16.5406, 0.0000, -1, -1, 100);
	CreateVehicle(431, 407.6654, 2459.2576, 16.5406, 0.0000, -1, -1, 100);
	CreateVehicle(431, 402.2072, 2459.1094, 16.5406, 0.0000, -1, -1, 100);
	CreateVehicle(431, 395.8808, 2459.0830, 16.5406, 0.0000, -1, -1, 100);
	CreateVehicle(500, 346.4049, 2504.1785, 16.4893, 0.0000, -1, -1, 100);
	CreateVehicle(508, 350.1299, 2504.4294, 16.8521, 0.0000, -1, -1, 100);
	CreateVehicle(508, 355.8916, 2504.4124, 16.8521, 0.0000, -1, -1, 100);
	CreateVehicle(508, 360.9249, 2504.3047, 16.8521, 0.0000, -1, -1, 100);
	CreateVehicle(515, 366.7675, 2502.1196, 17.6347, 0.0000, -1, -1, 100);
	CreateVehicle(515, 372.0346, 2502.1555, 17.6347, 0.0000, -1, -1, 100);
	CreateVehicle(515, 377.1854, 2502.0313, 17.6347, 0.0000, -1, -1, 100);
	CreateVehicle(515, 382.6477, 2501.9897, 17.6347, 0.0000, -1, -1, 100);
	CreateVehicle(561, 341.1386, 2502.7009, 16.4351, 0.0000, -1, -1, 100);
	CreateVehicle(561, 351.2650, 2469.0085, 16.4351, 0.0000, -1, -1, 100);
	CreateVehicle(450, 415.3338, 2503.1760, 17.0173, 90.0000, -1, -1, 100);
	CreateVehicle(450, 415.1612, 2496.8772, 17.0173, 90.0000, -1, -1, 100);
	CreateVehicle(450, 415.5002, 2489.7871, 17.0173, 90.0000, -1, -1, 100);
	CreateVehicle(450, 415.7406, 2482.4844, 17.0173, 90.0000, -1, -1, 100);
	//Зона жилых домов забр.аэро
	//////////////////ЗОНА ДОМОВ///////////////////////////////////////////
	CreateDynamicObject(3583, -1110.08, -1242.97, 131.16,   0.00, 0.00, 0.00);
	CreateDynamicObject(3583, -1110.21, -1224.51, 131.16,   0.00, 0.00, 0.00);
	CreateDynamicObject(3601, -1128.84, -1213.08, 135.99,   0.00, 0.00, 180.00);
	CreateDynamicObject(3601, -1142.38, -1213.07, 135.99,   0.00, 0.00, 180.00);
	CreateDynamicObject(3601, -1156.12, -1213.05, 135.99,   0.00, 0.00, 180.00);
	CreateDynamicObject(3601, -1169.90, -1213.02, 135.99,   0.00, 0.00, 180.00);
	CreateDynamicObject(3601, -1183.58, -1213.05, 135.99,   0.00, 0.00, 180.00);
	CreateDynamicObject(3601, -1197.24, -1213.01, 135.99,   0.00, 0.00, 180.00);
	CreateDynamicObject(3715, -1047.11, -1313.41, 137.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(3825, -1127.92, -1181.57, 132.75,   0.00, 0.00, 90.00);
	CreateDynamicObject(3825, -1136.38, -1181.60, 132.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(3825, -1144.91, -1181.62, 132.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(3825, -1153.46, -1181.59, 132.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(3825, -1162.01, -1181.57, 132.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(3825, -1170.46, -1181.56, 132.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(3601, -1182.05, -1181.78, 135.67,   0.00, 0.00, -90.00);
	CreateDynamicObject(983, -1166.19, -1172.67, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1174.46, -1172.68, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1171.23, -1169.50, 128.78,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1157.71, -1172.70, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1160.07, -1172.67, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1149.22, -1172.71, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1151.51, -1172.68, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1143.01, -1172.69, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1140.66, -1172.69, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1134.43, -1172.71, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1132.27, -1172.65, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1125.97, -1172.66, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1123.67, -1172.66, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(3580, -1098.09, -1159.12, 132.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(3580, -1098.05, -1171.29, 132.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(3580, -1098.02, -1183.35, 132.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(3580, -1098.01, -1195.49, 132.65,   0.00, 0.00, 90.00);
	CreateDynamicObject(986, -1123.59, -1204.14, 129.12,   0.00, 0.00, -90.00);
	CreateDynamicObject(986, -1123.84, -1189.37, 129.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(983, -1132.16, -1189.41, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1140.61, -1189.39, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1149.22, -1189.43, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1157.75, -1189.41, 128.87,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1166.28, -1189.39, 128.78,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1166.28, -1189.39, 130.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1157.75, -1189.41, 130.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1149.22, -1189.43, 130.04,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1140.61, -1189.39, 130.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1132.16, -1189.41, 130.05,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1208.86, -1030.29, 129.34,   18.00, 0.00, 180.00);
	CreateDynamicObject(18769, -1208.90, -1049.24, 135.48,   18.00, 0.00, 180.00);
	CreateDynamicObject(18769, -1208.91, -1068.48, 138.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1188.99, -1068.50, 138.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1188.89, -1048.97, 141.64,   18.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1188.88, -1029.67, 144.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1188.89, -1009.81, 144.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1168.96, -1009.81, 144.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1149.01, -1009.82, 144.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1148.97, -990.03, 144.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1149.00, -970.13, 144.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1148.99, -950.26, 144.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1129.24, -950.26, 144.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1110.21, -950.30, 148.91,   25.00, 0.00, -90.00);
	CreateDynamicObject(18769, -1091.50, -950.28, 153.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1071.58, -950.29, 153.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1071.54, -930.52, 153.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1071.59, -910.92, 153.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1051.86, -910.93, 153.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1031.97, -910.96, 153.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1012.12, -910.97, 153.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1011.97, -930.13, 150.00,   18.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1011.99, -948.88, 143.94,   18.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1012.00, -967.79, 137.77,   18.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1011.99, -986.67, 131.63,   18.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1011.98, -1005.86, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1011.97, -1025.83, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1031.91, -1025.73, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1051.87, -1025.71, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1071.85, -1025.70, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1071.89, -1005.78, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1071.88, -985.82, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1071.90, -965.88, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1091.81, -965.87, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1111.77, -965.86, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1131.66, -965.88, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1151.62, -965.86, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1171.59, -965.85, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1191.52, -965.90, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1211.46, -965.90, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1208.83, -1019.03, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1208.83, -999.08, 128.48,   0.00, 0.00, 0.00);
	CreateDynamicObject(18769, -1208.90, -985.45, 128.48,   0.00, 0.00, 0.90);
	CreateDynamicObject(983, -1199.08, -1025.24, 129.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1199.09, -1018.84, 129.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1199.17, -1006.42, 129.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1199.18, -1000.01, 129.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1199.18, -993.59, 129.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1199.16, -987.19, 129.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1199.14, -980.84, 129.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1186.40, -975.64, 129.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1160.79, -975.62, 129.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1135.22, -975.65, 129.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1109.56, -975.65, 129.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1075.25, -956.40, 129.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1062.44, -969.20, 129.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1062.44, -994.79, 129.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1081.63, -988.71, 129.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1081.63, -1014.30, 129.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1068.52, -1035.17, 129.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1049.07, -1016.33, 129.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1042.92, -1035.16, 129.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1017.34, -1035.20, 129.74,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1002.36, -1016.75, 129.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1015.50, -901.47, 154.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1041.13, -901.48, 154.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1042.40, -920.52, 154.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1061.71, -937.90, 154.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1081.11, -914.41, 154.31,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1074.90, -959.82, 154.31,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1145.68, -940.78, 145.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(982, -1158.45, -953.57, 145.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1158.42, -979.18, 145.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1139.20, -982.97, 145.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(982, -1198.66, -1012.79, 145.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(983, -1195.88, -1015.00, 128.09,   18.00, 90.00, 90.00);
	CreateDynamicObject(983, -1195.90, -1013.77, 128.09,   18.00, 90.00, 90.00);
	CreateDynamicObject(983, -1195.91, -1012.51, 128.09,   18.00, 90.00, 90.00);
	CreateDynamicObject(983, -1195.90, -1011.24, 128.09,   18.00, 90.00, 90.00);
	CreateDynamicObject(983, -1195.92, -1010.00, 128.09,   18.00, 90.00, 90.00);
	CreateDynamicObject(18761, -1209.12, -1008.75, 132.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1089.88, -956.34, 129.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1093.50, -956.31, 129.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1097.16, -956.29, 129.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1100.82, -956.30, 129.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1104.40, -956.26, 129.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1108.02, -956.24, 129.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1111.67, -956.23, 129.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1115.33, -956.24, 129.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1118.95, -956.23, 129.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(3281, -1122.62, -956.23, 129.96,   0.00, 0.00, 0.00);
	//////////АВТО///////////////////////
	CreateVehicle(411, -1105.8749, -1226.0164, 128.9749, 0.0000, -1, -1, 100);
	CreateVehicle(411, -1105.5986, -1243.5820, 128.9749, 0.0000, -1, -1, 100);
	CreateVehicle(532, -1108.5115, -1267.2603, 130.4681, 0.0000, -1, -1, 100);
	CreateVehicle(532, -1107.7830, -1279.4520, 130.4681, 0.0000, -1, -1, 100);
	CreateVehicle(532, -1097.1641, -1279.4508, 130.4681, 0.0000, -1, -1, 100);
	CreateVehicle(560, -1106.3564, -1200.2292, 128.7705, 0.0000, -1, -1, 100);
	CreateVehicle(560, -1106.4279, -1187.3973, 128.7705, 0.0000, -1, -1, 100);
	CreateVehicle(560, -1106.2649, -1176.4689, 128.7705, 0.0000, -1, -1, 100);
	CreateVehicle(560, -1106.6687, -1165.7971, 128.7705, 0.0000, -1, -1, 100);
	CreateVehicle(560, -1129.8733, -1190.0282, 128.7705, 0.0000, -1, -1, 100);
	//////////////////////////РУБЛЕВКА//////////////////////////////////////
	CreateDynamicObject(3443, 1517.88, -2465.82, 15.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(3443, 1548.81, -2465.77, 15.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(3443, 1579.61, -2465.82, 15.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(3443, 1610.45, -2465.83, 15.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1640.95, -2461.57, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1671.09, -2461.59, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1700.99, -2461.75, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1731.28, -2461.71, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1761.31, -2461.79, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1791.23, -2461.88, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1821.27, -2461.91, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1819.19, -2429.71, 19.53,   0.00, 0.00, 90.00);
	CreateDynamicObject(3486, 1819.02, -2401.51, 19.53,   0.00, 0.00, 90.00);
	CreateDynamicObject(3486, 1862.26, -2399.77, 19.53,   0.00, 0.00, -90.00);
	CreateDynamicObject(3486, 1862.27, -2429.99, 19.53,   0.00, 0.00, -90.00);
	CreateDynamicObject(3486, 1860.28, -2461.80, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1822.01, -2527.67, 19.53,   0.00, 0.00, 90.00);
	CreateDynamicObject(3486, 1822.14, -2557.61, 19.53,   0.00, 0.00, 90.00);
	CreateDynamicObject(3486, 1884.15, -2559.67, 19.53,   0.00, 0.00, 90.00);
	CreateDynamicObject(3485, 1790.34, -2555.61, 19.53,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1760.39, -2555.56, 19.53,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1730.47, -2555.56, 19.53,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1700.42, -2555.62, 19.53,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1719.44, -2673.73, 19.53,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1689.53, -2626.66, 19.53,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1659.46, -2626.66, 19.55,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1629.30, -2626.58, 19.55,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1599.37, -2626.56, 19.55,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1569.49, -2626.58, 19.55,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1539.52, -2626.63, 19.55,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1509.49, -2626.63, 19.55,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1479.43, -2626.65, 19.55,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1449.38, -2626.62, 19.55,   0.00, 0.00, 180.00);
	CreateDynamicObject(3485, 1419.30, -2626.55, 19.55,   0.00, 0.00, 180.00);
	CreateDynamicObject(3445, 1511.61, -2526.94, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3445, 1511.92, -2562.75, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3445, 1493.59, -2562.78, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3445, 1475.31, -2562.77, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3445, 1457.22, -2562.73, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3445, 1439.12, -2562.77, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3445, 1493.53, -2526.96, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3445, 1475.36, -2526.93, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3445, 1457.12, -2526.96, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3445, 1438.94, -2526.92, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3445, 1530.04, -2562.68, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3445, 1548.18, -2562.64, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3445, 1566.35, -2562.61, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3445, 1584.38, -2562.60, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3445, 1621.61, -2562.61, 15.62,   0.00, 0.00, -180.00);
	CreateDynamicObject(3749, 1603.02, -2575.07, 17.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3445, 1529.64, -2526.93, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3445, 1547.73, -2526.90, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3445, 1565.63, -2526.91, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(3445, 1583.79, -2526.90, 15.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(4100, 1600.04, -2512.55, 13.01,   0.00, 0.00, -40.00);
	CreateDynamicObject(4100, 1613.78, -2512.62, 13.01,   0.00, 0.00, -40.00);
	CreateDynamicObject(4100, 1625.10, -2512.60, 13.01,   0.00, 0.00, -40.00);
	CreateDynamicObject(4100, 1631.84, -2524.13, 13.01,   0.00, 0.00, -130.00);
	CreateDynamicObject(4100, 1631.80, -2537.83, 13.01,   0.00, 0.00, -130.00);
	CreateDynamicObject(4100, 1631.73, -2551.51, 13.01,   0.00, 0.00, -130.00);
	CreateDynamicObject(4100, 1631.69, -2565.19, 13.01,   0.00, 0.00, -130.00);
	CreateDynamicObject(4100, 1685.55, -2532.12, 13.01,   0.00, 0.00, -130.00);
	CreateDynamicObject(4100, 1685.55, -2518.46, 13.01,   0.00, 0.00, -130.00);
	CreateDynamicObject(3749, 1695.16, -2512.01, 17.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3749, 1725.16, -2511.90, 17.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3749, 1754.90, -2512.04, 17.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3749, 1783.75, -2511.95, 17.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1804.90, -2512.71, 12.29,   0.00, 0.00, 180.00);
	CreateDynamicObject(987, 1774.09, -2512.65, 12.29,   0.00, 0.00, 180.00);
	CreateDynamicObject(987, 1745.38, -2512.64, 12.29,   0.00, 0.00, 180.00);
	CreateDynamicObject(987, 1715.79, -2512.58, 12.29,   0.00, 0.00, 180.00);
	CreateDynamicObject(987, 1715.63, -2525.98, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1715.61, -2537.91, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1715.65, -2549.86, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1744.96, -2526.17, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1744.97, -2538.08, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1744.92, -2550.03, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1774.83, -2525.41, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1774.80, -2537.31, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1774.81, -2549.24, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(3486, 1893.99, -2428.10, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1924.09, -2428.14, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3486, 1954.24, -2428.23, 19.53,   0.00, 0.00, 0.00);
	CreateDynamicObject(3749, 1884.96, -2476.87, 17.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3749, 1916.41, -2476.99, 17.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(3749, 1947.74, -2476.94, 17.86,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1894.66, -2478.67, 12.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1926.21, -2478.76, 12.29,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1957.62, -2478.75, 12.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1969.41, -2478.80, 12.32,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1969.43, -2466.92, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1969.45, -2454.97, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1938.95, -2454.07, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1938.99, -2466.02, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1938.96, -2477.92, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1908.87, -2454.27, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1908.86, -2466.20, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1908.87, -2478.12, 12.29,   0.00, 0.00, 90.00);
	CreateDynamicObject(705, 1901.22, -2474.47, 11.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, 1933.66, -2474.01, 11.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, 1964.33, -2474.61, 11.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, 1907.10, -2523.37, 11.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(705, 1858.67, -2521.70, 11.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1794.14, -2493.96, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1838.37, -2493.83, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1818.53, -2493.90, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1763.04, -2493.79, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1716.52, -2493.85, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1740.82, -2493.88, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1673.31, -2493.98, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1632.16, -2494.03, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1652.47, -2493.92, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1673.84, -2512.75, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1679.86, -2512.71, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1632.45, -2512.60, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1626.38, -2513.72, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1617.81, -2513.94, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1609.55, -2513.50, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1601.56, -2513.24, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1592.12, -2549.99, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1573.67, -2549.43, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1555.49, -2549.37, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1537.16, -2549.11, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1518.76, -2549.27, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1501.42, -2549.35, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1482.64, -2549.72, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1464.71, -2549.20, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1446.52, -2549.50, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1504.51, -2477.46, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1504.55, -2482.70, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1504.32, -2489.24, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1504.29, -2495.74, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1504.37, -2500.51, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1504.02, -2505.51, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1503.59, -2510.00, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(3485, 1413.20, -2549.13, 19.55,   0.00, 0.00, 90.00);
	CreateDynamicObject(700, 1426.64, -2574.85, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1419.80, -2574.87, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1411.82, -2574.89, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1404.08, -2574.86, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1396.32, -2574.69, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1396.27, -2570.03, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1396.16, -2564.40, 12.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1434.09, -2593.36, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1456.50, -2592.91, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1503.57, -2593.47, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1535.71, -2591.65, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1568.45, -2593.32, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1598.66, -2593.62, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1632.55, -2592.98, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(708, 1672.68, -2593.06, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(708, 1673.66, -2558.62, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(708, 1673.59, -2535.32, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(708, 1733.05, -2633.04, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(708, 1732.79, -2638.11, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(708, 1752.99, -2606.25, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(708, 1749.86, -2565.91, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(708, 1779.61, -2564.88, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(708, 1812.06, -2567.31, 12.18,   0.00, 0.00, 3.78);
	CreateDynamicObject(987, 1805.11, -2572.47, 11.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1816.96, -2572.48, 11.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1828.79, -2572.49, 11.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1846.42, -2572.57, 11.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1858.36, -2572.59, 11.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1870.27, -2572.70, 11.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(8251, 1898.22, -2560.19, 16.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(8251, 1934.76, -2525.79, 15.89,   0.00, 0.00, 90.00);
	CreateDynamicObject(8251, 1959.33, -2525.77, 15.89,   0.00, 0.00, 90.00);
	CreateDynamicObject(8251, 1984.59, -2525.77, 15.89,   0.00, 0.00, 90.00);
	CreateDynamicObject(8251, 2009.10, -2500.18, 15.89,   0.00, 0.00, -180.00);
	CreateDynamicObject(8251, 2009.06, -2474.84, 15.89,   0.00, 0.00, -180.00);
	CreateDynamicObject(8251, 1983.35, -2450.29, 15.89,   0.00, 0.00, -90.00);
	CreateDynamicObject(705, 1998.42, -2457.69, 11.94,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1845.59, -2424.68, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1846.51, -2394.43, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1856.12, -2385.47, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1850.82, -2385.52, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1845.78, -2385.45, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1837.07, -2385.19, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1833.07, -2384.96, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1829.06, -2384.91, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(700, 1824.03, -2385.14, 12.47,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1502.72, -2449.75, 12.34,   0.00, 0.00, -90.00);
	CreateDynamicObject(987, 1502.69, -2461.71, 12.34,   0.00, 0.00, -90.00);
	CreateDynamicObject(987, 1502.63, -2485.59, 12.34,   0.00, 0.00, -90.00);
	CreateDynamicObject(987, 1502.67, -2473.71, 12.34,   0.00, 0.00, -90.00);
	CreateDynamicObject(987, 1502.63, -2497.51, 12.34,   0.00, 0.00, -90.00);
	CreateDynamicObject(987, 1502.60, -2509.48, 12.34,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, 1400.22, -2609.97, 13.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(979, 1396.16, -2605.21, 13.20,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, 1396.19, -2595.93, 13.20,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, 1396.18, -2586.74, 13.20,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, 1396.20, -2577.57, 13.20,   0.00, 0.00, -90.00);
	CreateDynamicObject(979, 1396.22, -2568.60, 13.20,   0.00, 0.00, -90.00);
	CreateDynamicObject(3486, 1747.03, -2587.04, 19.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(3486, 1747.02, -2617.25, 19.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(708, 1517.94, -2514.95, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1535.23, -2514.93, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1554.18, -2514.44, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1571.84, -2514.63, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1590.11, -2514.32, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1551.19, -2453.59, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1517.50, -2453.89, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1578.03, -2453.10, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1606.71, -2453.46, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1630.23, -2449.21, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1659.77, -2449.50, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1690.03, -2450.19, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1720.13, -2448.66, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1749.47, -2448.78, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1780.71, -2449.61, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1808.44, -2448.61, 12.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(708, 1808.33, -2411.09, 12.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1911.44, -2572.55, 11.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(987, 1923.29, -2572.61, 11.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1923.37, -2560.78, 11.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(987, 1923.39, -2550.87, 11.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, 1911.87, -2513.50, 13.69,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, 1814.44, -2511.08, 13.69,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, 1650.06, -2513.50, 13.76,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, 1654.86, -2513.47, 13.76,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, 1663.19, -2608.25, 13.76,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, 1543.47, -2608.30, 13.76,   0.00, 0.00, -90.00);
	CreateDynamicObject(1257, 1678.60, -2479.55, 13.61,   0.00, 0.00, 90.00);
	CreateDynamicObject(1257, 1564.99, -2477.61, 13.61,   0.00, 0.00, 90.00);
	//////////////АВТО///////////////////////////////////////////////////
	CreateVehicle(411, 1515.5227, -2500.0483, 13.2481, 0.0000, -1, -1, 100);
	CreateVehicle(409, 1976.2980, -2449.0986, 13.1603, 0.0000, -1, -1, 100);
	CreateVehicle(409, 1980.8339, -2449.5149, 13.1603, 0.0000, -1, -1, 100);
	CreateVehicle(409, 1986.6786, -2449.5195, 13.1603, 0.0000, -1, -1, 100);
	CreateVehicle(409, 1991.0930, -2449.7786, 13.1603, 0.0000, -1, -1, 100);
	CreateVehicle(409, 2013.2906, -2468.6604, 13.1603, 0.0000, -1, -1, 100);
	CreateVehicle(409, 2008.3827, -2468.6042, 13.1603, 0.0000, -1, -1, 100);
	CreateVehicle(409, 2003.8682, -2468.5562, 13.1603, 0.0000, -1, -1, 100);
	CreateVehicle(409, 1999.4150, -2468.3945, 13.1603, 0.0000, -1, -1, 100);
	CreateVehicle(431, 2004.5010, -2480.7590, 13.6524, 91.0000, -1, -1, 100);
	CreateVehicle(437, 2004.8131, -2492.7827, 14.1309, 90.0000, -1, -1, 100);
	CreateVehicle(437, 2004.6017, -2499.0798, 14.1309, 90.0000, -1, -1, 100);
	CreateVehicle(437, 2004.6527, -2505.7476, 14.1309, 90.0000, -1, -1, 100);
	CreateVehicle(420, 1991.8214, -2527.6685, 13.3894, 0.0000, -1, -1, 100);
	CreateVehicle(420, 1991.6572, -2516.9280, 13.3894, 0.0000, -1, -1, 100);
	CreateVehicle(420, 1985.5238, -2526.6221, 13.3894, 0.0000, -1, -1, 100);
	CreateVehicle(420, 1978.5959, -2527.6267, 13.3894, 0.0000, -1, -1, 100);
	CreateVehicle(420, 1985.5256, -2516.9309, 13.3894, 0.0000, -1, -1, 100);
	CreateVehicle(420, 1978.9531, -2517.0872, 13.3894, 0.0000, -1, -1, 100);
	return 1;
}

public OnGameModeExit()
{
	new p = GetMaxPlayers();
	for (new i=0; i < p; i++) {
	SetPVarInt(i, "laser", 0);
	RemovePlayerAttachedObject(i, 0);
}
	print("\n----------------------------------");
	print("Drift RUSSIAN...");
	print("----------------------------------\n");
	print("Пожалуйста, не стирайте мои авторские права");
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
 	SetPlayerPos(playerid, 1330.5118,-985.2089,33.8966);
	SetPlayerFacingAngle(playerid,265.1334);
	SetPlayerCameraPos(playerid, 1334.7155,-985.2899,33.8966);
	SetPlayerCameraLookAt(playerid, 1330.5118,-985.2089,33.8966);
	return 1;
}

public OnPlayerConnect(playerid)
{
//        switch(random(1))// данное число должно равняться последнему case.
//{
//	case 0: PlayAudioStreamForPlayer(playerid,"http://www.prostomap.ru/server/connect.mp3"); // Музыка при входе
//}
	SetPVarInt(playerid, "laser", 0);
	SetPVarInt(playerid, "color", 18643);
    ShowPlayerDialog(playerid, 278, DIALOG_STYLE_MSGBOX, ".:Добро пожаловать!:.", "{7CFC00}Вызов меню: ALT(пешком), 2(в машине)\n{1E90FF}Зарегистрируйтесь /register\n{00BFFF}Если вы зарегистрированы пишите /login\n{FFFF00}Группа ВК сервера vk.com/pro_sto_map\n{FF33FF}Сайт сервера PROSTOMAP.RU\nГлавный админ сервера Sanya161RU\nУдАчНоЙ ИгРы На НаШеМ СеРвЕрЕ", "OK", "");
    TextDrawShowForPlayer(playerid,Text:Times);
    SetPlayerTime(playerid,0,0);
	h[playerid]=21;m[playerid]=20;
	new str[128];
	format(str,128,"%s вошёл (ла) на сервер.", PlayerName(playerid));
	SendClientMessageToAll(COLOR_GREEN,str);

	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
    TextDrawHideForPlayer(playerid, prostomap);
    SetPVarInt(playerid, "laser", 0);
    SaveAccount(playerid); // Сохранение аккаунтов
    RemovePlayerAttachedObject(playerid,2);
	DestroyObject(migalki[playerid][0]);
	DestroyObject(migalki[playerid][1]);
	new str[128];
    format(str,128,"%s  вышел (ла) с сервера.", PlayerName(playerid));
	SendClientMessageToAll(COLOR_RED,str);
}
public SetName()
{
    new string[256];
    new rand = random(sizeof(HostName));
    format(string,sizeof(string),"hostname %s",HostName[rand][0]);
    SendRconCommand(string);
    return 1;
}
public OnPlayerSpawn(playerid)
{
	StopAudioStreamForPlayer(playerid); // выключает музыку после того как мы ввели пароль
	//TEKCTDRAV
		new rand = random(sizeof(RandomSpawn));
	SetPlayerPos(playerid,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2]);
	GivePlayerWeapon(playerid,23,100);
	GivePlayerWeapon(playerid,30,100);
	GivePlayerWeapon(playerid,43,77);
	GivePlayerWeapon(playerid,29,100);
	GivePlayerWeapon(playerid,1,1000);
	GivePlayerWeapon(playerid,25,100);
	GivePlayerWeapon(playerid,33,100);

	new Text:textdraw;
    textdraw = TextDrawCreate(430, 430, " ");

    TextDrawTextSize(Text:textdraw, 3, 3);
    TextDrawColor(Text:textdraw, -1);
    TextDrawBoxColor(Text:textdraw, -1347440726);
    TextDrawSetOutline(Text:textdraw, 1);
    TextDrawBackgroundColor(Text:textdraw, 170);
    TextDrawFont(Text:textdraw, 3);
    TextDrawSetProportional(Text:textdraw, 1);
    TextDrawShowForPlayer(playerid, textdraw);
	//TEKCTDRAV
	GivePlayerWeapon(playerid,43,77);
	GivePlayerWeapon(playerid,46,100);
	GivePlayerWeapon(playerid,1,1);
    SetPlayerInterior(playerid,0);
	SetPlayerPos(playerid,-35.2330, -2053.7017, 5.2701);
	SetCameraBehindPlayer(playerid);
    SetPlayerTime(playerid,0,0);
	SetPlayerPos(playerid,RandomSpawn[rand][0], RandomSpawn[rand][1], RandomSpawn[rand][2]);
	return 1;
}


public OnPlayerStateChange(playerid)
{
	new newstate;
	if(newstate == PLAYER_STATE_DRIVER)
{
            if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 530) // 530 это погрузчик
  {
      new rand = random(sizeof(checkLoader));
      hereCheckLoader[playerid] = CreateDynamicCP(checkLoader[rand][0], checkLoader[rand][1], checkLoader[rand][2], 1.6, -1, -1, playerid, 100.0);
      ShowPlayerDialog(playerid, 666, DIALOG_STYLE_MSGBOX, "Грузчик", "Отправляйся на красный чекпойнт за грузом.", "Хорошо", ""); // Покажем игроку диалог о том что он может начинать работать
  }
}
// Если игрок вылез из кара, удалим чекпойнты
else if(newstate == PLAYER_STATE_ONFOOT)
{
    if(hereCheckLoader[playerid]) DestroyDynamicCP(hereCheckLoader[playerid]);
    if(hereCheckUnLoader[playerid]) DestroyDynamicCP(hereCheckUnLoader[playerid]);
}
return 1;
}
stock PlayerName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pname,sizeof(pname));
	return pname;
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
	if(strcmp("/смс", cmd, true) == 0)
	{
		tmp = strtok(cmdtext,idx);

		if(!strlen(tmp) || strlen(tmp) > 5) {
			SendClientMessage(playerid,COLOR_RED,"[Drift_Russian]: /смс (id) (сообщение)");
			return 1;
		}

		new id = strval(tmp);
        gMessage = strrest(cmdtext,idx);

		if(!strlen(gMessage)) {
			SendClientMessage(playerid,COLOR_RED,"[Drift_Russian]: /смс (id) (сообщение)");
			return 1;
		}

		if(!IsPlayerConnected(id)) {
			SendClientMessage(playerid,COLOR_RED,"[Drift_Russian]: Нет такого id");
			return 1;
		}

		if(playerid != id) {
			GetPlayerName(id,iName,sizeof(iName));
			GetPlayerName(playerid,pName,sizeof(pName));
			format(Message,sizeof(Message),">> %s(%d): %s",iName,id,gMessage);
			SendClientMessage(playerid,PM_OUTGOING_COLOR,Message);
			format(Message,sizeof(Message),"** %s(%d): %s",pName,playerid,gMessage);
			SendClientMessage(id,PM_INCOMING_COLOR,Message);
			PlayerPlaySound(id,1085,0.0,0.0,0.0);
		}
		else {
			SendClientMessage(playerid,COLOR_RED,"Вы пишете смс себе. Выберите другой id");
		}
		return 1;
		}
		//=============================DALNOBOY4IK
		if(strcmp("/daltp", cmdtext, true, 10) == 0)
{
SetPlayerInterior(playerid,0);
SetPlayerPos(playerid,2.6937,-256.4706,5.4297);
SendClientMessage(playerid,-1,"{FFFF00}Чтобы начать работу дальнобойщика, сядьте в грузовик, подберите любой прицеп и наберите{FF0000}/Dalnstart");
return 1;
}
if(strcmp("/dalnstart", cmdtext, true, 10) == 0)
{

    if(IsPlayerInRangeOfPoint(playerid,200.0,-75.1052,-289.7339,6.4286))
        {
                new model = GetVehicleModel(GetPlayerVehicleID(playerid));
                if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && model==515 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER && model==514 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER && model==403)
                {
                        SendClientMessage(playerid,RED,"Вы должны быть в Фуре за рулём!");
                        return true;
                }
                if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
                {
                        SendClientMessage(playerid,RED,"Вы не подцепили прицеп!");
                        return true;
                }
                DisablePlayerCheckpoint(playerid);
                GameTextForPlayer(playerid, "~r~Goto redmarker", 2500, 1);
                Checkpoint[playerid] = 1;
                new traileid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
                if(traileid == Pricep[5] || traileid == Pricep[6] || traileid == Pricep[7])
                {
                        new rand666=random(4);
                        switch (rand666)
                        {
                                case 0:SetPlayerCheckpoint(playerid,-2101.1555,208.4684,34.8973,8.0);
                        case 1:SetPlayerCheckpoint(playerid,2801.4639,-2436.1069,13.2421,8.0);
                                case 2:SetPlayerCheckpoint(playerid,2619.9587,833.6466,4.9254,8.0);
                        case 3:SetPlayerCheckpoint(playerid,680.4613,896.6621,-40.3721,8.0);
                }
                }
                if(traileid == Pricep[3] || traileid == Pricep[9])
                {
                        new rand666=random(4);
                        switch (rand666)
                        {
                                case 0:SetPlayerCheckpoint(playerid,2193.5149,2476.3335,10.8203,8.0);
                        case 1:SetPlayerCheckpoint(playerid,-2442.1062,953.0255,45.2969,8.0);
                        case 2:SetPlayerCheckpoint(playerid,-1624.4644,-2697.6082,48.5391,8.0);
                                case 3:SetPlayerCheckpoint(playerid,1918.5468,-1792.2303,13.3828,8.0);
                        }
                }
                if(traileid == Pricep[8] || traileid == Pricep[4])
                {
                        new rand666=random(4);
                        switch (rand666)
                        {
                                case 0:SetPlayerCheckpoint(playerid,2119.4260,-1826.5001,13.5549,8.0);
                                case 1:SetPlayerCheckpoint(playerid,2073.7229,2225.8416,10.8203,8.0);
                                case 2:SetPlayerCheckpoint(playerid,1383.9170,264.0096,19.5669,8.0);
                                case 3:SetPlayerCheckpoint(playerid,-1802.8058,960.6457,24.8906,8.0);
                        }
                }
                if(traileid == Pricep[2])
                {
                        new rand666=random(4);
                        switch (rand666)
                        {
                                case 0:SetPlayerCheckpoint(playerid,505.3549,-1366.4999,16.1252,8.0);
                                case 1:SetPlayerCheckpoint(playerid,2247.9878,-1663.3557,15.4690,8.0);
                                case 2:SetPlayerCheckpoint(playerid,2105.0955,2248.5913,11.0234,8.0);
                                case 3:SetPlayerCheckpoint(playerid,-1889.1820,874.3929,35.1719,8.0);
                        }
                }
                if(traileid == Pricep[1])
                {
                        new rand666=random(4);
                        switch (rand666)
                        {
                                case 0:SetPlayerCheckpoint(playerid,2303.3145,-1635.1567,14.1720,8.0);
                                case 1:SetPlayerCheckpoint(playerid,1830.3245,-1682.8469,13.1551,8.0);
                                case 2:SetPlayerCheckpoint(playerid,-2244.7861,-87.9356,34.9299,8.0);
                                case 3:SetPlayerCheckpoint(playerid,-2555.2585,191.8923,5.7216,8.0);
                }
                }
                if(traileid == Pricep[0])
                {
                        new rand666=random(4);
                        switch (rand666)
                        {
                                case 0:SetPlayerCheckpoint(playerid,1363.6267,-1282.4384,13.5469,8.0);
                                case 1:SetPlayerCheckpoint(playerid,2394.5999,-1978.2787,13.1115,8.0);
                                case 2:SetPlayerCheckpoint(playerid,2156.1287,940.5781,10.4309,8.0);
                                case 3:SetPlayerCheckpoint(playerid,-2626.6106,211.0776,4.2099,8.0);
                        }
                }
        }else{SendClientMessage(playerid,RED,"Вы не находитесь в дальнобое");}
        return 1;
}
		//=============================DALNOBOY4IK
 		//-----------------------------ADMINKA
	 if(strcmp(cmdtext, "/цены", true)==0)
	{
 	ShowPlayerDialog(playerid,914,DIALOG_STYLE_MSGBOX,"{FFB6C1}Цены на админку","5 уровень - 50 рублей (месяц)\n6 уровень - 60 рублей (месяц)\n7 уровень - 70 рублей (месяц)\n8 уровень - 80 рублей (месяц)\n9 уровень - 90 рублей месяц\n{00FF00}10 уровень - 150 рублей (навсегда)\n{FFFF00}11 уровень 200 рублей (навсегда)\nКупить админку можно у администратора {B8860B}Sanya161RU\n","OK","");
	return 1;
	}
		//-----------------------------ADMINKA
	if(strcmp(cmdtext, "/colors", true)==0)
	{
	ShowPlayerDialog(playerid,794,DIALOG_STYLE_LIST,"{FFB6C1}Меню цветов","{FF0000}Красный\n{BEBEBE}Серый\n{006400}Зеленый\n{EEA2AD}Розовый\n{00FF00}Лайм\n{0000FF}Синий\n{FFFF00}Желтый\n{00FFFF}Голубой\n{FFA500}Оранжевый\n{FF00FF}Магента\n{FF6347}Томатный\n{551A8B}Индиго\n{B8860B}Золотой\n{698B22}Оливковый\n{9ACD32}Желто-Зеленый\n{8B4513}Коричневый\n{EE6A50}Коралловый\n{FF4500}Красно-оранжевый\nОтключить цвет","Применить"," Отмена");
	return 1;
	}
	if(strcmp(cmd, "/sts", true) == 0)
   {
      new length = strlen(cmdtext);
      while((idx < length) && (cmdtext[idx] <= ' ')){ idx++; }
      new offset = idx; new result[64];
      while((idx < length) && ((idx - offset) < (sizeof(result) - 1))){ result[idx - offset] = cmdtext[idx]; idx++; }
      result[idx - offset] = EOS;
      if(!strlen(result)) return SendClientMessage(playerid,COLOR_GREEN,"[Drift_Russian]: /sts [Ваш статус]");
      format(string, sizeof(string), "{FF3300}%s ",result);
      SendClientMessage(playerid, COLOR_GREEN, string);
      status[playerid] = Create3DTextLabel(string, 0xFFFFFFAA, 5.77, 5.77, 5.77, 10.0, 0, 1);
      Attach3DTextLabelToPlayer(status[playerid], playerid, 0.0, 0.0, 0.4);
      Update3DTextLabelText(status[playerid], 0xFFFFFFAA, string);
      return 1;
   }
	if(strcmp(cmd, "/del", true) == 0)
   {
    Delete3DTextLabel(status[playerid]);//[i]
    SendClientMessage(playerid, COLOR_RED, "Вы удалили статус");
    }
if(strcmp(cmdtext, "/radio", true) == 0)
 {
     if(IsPlayerConnected(playerid))
     {
            ShowPlayerDialog(playerid, RADIO, DIALOG_STYLE_LIST, "Радио","Зайцев FM\nЕвропа плюс\nGama-Life FM\nICE FM\n{FF3300}Выключить радио", "Ok", "Выход");
        }
        return 1;
    }
	//-----------------------------------------------------Приветствие
	if(strcmp(cmdtext, "/hi", true) == 0)
	{
		new str[128];
        format(str,128,"[Drift_Russian]: {FF9900}%s {9400D3}СкАзАл(A) {FFFF00}ВсЕм {7D26CD}ПрИвЕт", PlayerName(playerid));
	    SendClientMessageToAll(COLOR_RED,str);
		return 1;
	}
	if(strcmp(cmdtext, "/bb", true) == 0)
	{
		new str[128];
        format(str,128,"[Drift_Russian]: {FF9900}%s {9400D3}СкАзАл(A) {FFFF00}ВсЕм {7D26CD}ПоКа", PlayerName(playerid));
	    SendClientMessageToAll(COLOR_LIGHTBLUE,str);
		return 1;
	}
	//-----------------------------------------------------Приветствие
    //-----------------------------------------------------PAY
 	if(strcmp(cmd, "/givemoney", true) == 0) {
		tmp = strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_WHITE, "Используйте: /givemoney [ид игрока] [сколько]");
			return 1;
		}
		giveplayerid = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) {
		SendClientMessage(playerid, COLOR_WHITE, "Используйте: /givemoney [ид игрока] [сколько]");
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
				format(string, sizeof(string), "%d не активный игрок.", giveplayerid);
				SendClientMessage(playerid, COLOR_RED, string);
			}
            return 1;
    }
    //-----------------------------------------------------PAY
	//LASERS
	if(strcmp(cmd, "/laser", true) == 0)
    {
       if (PlayerInfo[playerid][pAdmin] >= 0)
        {
            ShowPlayerDialog(playerid,132,DIALOG_STYLE_LIST,"Лазер","{FF0000}Включить\n{0000FF}Выключить\n{FF9900}Цвет","Enter","Exit");
            return 1;
        }
    }
    //LASERS END

	if (strcmp("/r", cmdtext, true, 10) == 0)
 {
     SetPlayerScore(playerid, 0);
     SendClientMessage(playerid, 0x00FF00AA, "Вы обнулили очки");
  return 1;
 }
	if (strcmp("/menu", cmdtext, true, 10) == 0)ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "Тюнинг\nТелепорты\nАнимации\nРадио\nАвтомобили\nУправление персонажем\nПомощь\n{FFFF00}Отсчёт\n{33FF00}Настройки\n{FF3300}Управление Авто\n{0033CC}Сброс очков\n{FF00FF}Перевернуть авто", "Выбрать", "Выход");
	if (strcmp("/count", cmdtext, true, 10) == 0)
	{
        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)return SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы должны быть в машине");
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
	if(strcmp(cmd, "/shapka", true) == 0)
{
    if(IsPlayerConnected(playerid))
    {
        if(shapka[playerid] == 0)
        {
            SetPlayerAttachedObject(playerid,2, 19064, 2, 0.13, 0.0, 0.0, 0.0, 80.0, 80.0);
            shapka[playerid] = 1;
        }
        else
        {
            RemovePlayerAttachedObject(playerid, 2);
            DestroyPlayerObject(playerid, 19064);
            shapka[playerid] = 0;
        }
    }
    return 1;
}

	dcmd(dt, 2, cmdtext);
	return true;
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
    if (newkeys == 262144) OnPlayerCommandText(playerid,"/radio");
	if ((newkeys==KEY_SUBMISSION))
	{
		if(IsPlayerInAnyVehicle(playerid))
		ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "Тюнинг\nТелепорты\nАнимации\nРадио\nАвтомобили\nУправление персонажем\nПомощь\n{FFFF00}Отсчёт\n{33FF00}Настройки\n{FF3300}Управление Авто\n{0033CC}Сброс очков\n{33FF00}Перевернуть авто", "Выбрать", "Выход");
	}

	if ((newkeys==1024))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "Тюнинг\nТелепорты\nАнимации\nРадио\nАвтомобили\nУправление персонажем\nПомощь\n{FFFF00}Отсчёт\n{33FF00}Настройки\n{FF3300}Управление Авто\n{0033CC}Сброс очков\n{33FF00}Перевернуть авто", "Выбрать", "Выход");
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
public OnPlayerEnterDynamicCP(playerid)
{
	new checkpointid;
if(checkpointid == hereCheckLoader[playerid])
{
    drawer[playerid] = CreateDynamicObject(1224, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    AttachObjectToVehicle(drawer[playerid], GetPlayerVehicleID(playerid), 0.0, 0.6, 0.6, 0.0, 0.0, 0.0);
    new rand = random(sizeof(checkLoaderUnload));
    hereCheckUnLoader[playerid] = CreateDynamicCP(checkLoaderUnload[rand][0], checkLoaderUnload[rand][1], checkLoaderUnload[rand][2], 1.6, -1, -1, playerid, 100.0);
    DestroyDynamicCP(hereCheckLoader[playerid]);
}
// Если игрок сгрузил ящик
else if(checkpointid == hereCheckUnLoader[playerid])
{
    GivePlayerMoney(playerid, 20); // При желании вы можете записывать деньги в переменную а выдавать при зарплате
    GameTextForPlayer(playerid, "~g~+20$", 3000, 4);
    new rand = random(sizeof(checkLoader));
    hereCheckLoader[playerid] = CreateDynamicCP(checkLoader[rand][0], checkLoader[rand][1], checkLoader[rand][2], 1.6, -1, -1, playerid, 100.0);
    DestroyDynamicCP(hereCheckUnLoader[playerid]);
    DestroyDynamicObject(drawer[playerid]);
}
return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
if(Checkpoint[playerid] == 1)
        {
                if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
                {
                SendClientMessage(playerid, RED,"Наебать решил? иди ищи прицеп!");
                DisablePlayerCheckpoint(playerid);
                return true;
                }
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid,0);
                SendClientMessage(playerid, RED,"Подождите какое-то време пока разгрузят фуру!");
                SetTimerEx("RazgruzFurui",25000,false,"i",playerid);
        }
        else if(Checkpoint[playerid] == 2)
        {
        if(IsPlayerInAnyVehicle(playerid))
        {
                        if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
                        {
                        SendClientMessage(playerid, RED,"Наебать решил? иди ищи прицеп!");
                        DisablePlayerCheckpoint(playerid);
                        return true;
                        }
                        new zarplata = 10000 + random(10000);
                        new string[64];
                        format(string, sizeof(string), "Вы доставили груз и получили $%d", zarplata);
                        SendClientMessage(playerid, YELLOW,string);
                        GivePlayerMoney(playerid, zarplata);
                        Checkpoint[playerid] = 0;
                DisablePlayerCheckpoint(playerid);
                SetVehicleToRespawn(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                }
        }
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

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
			     ShowPlayerDialog(playerid,1,DIALOG_STYLE_LIST,"Обьекты на машину","{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\n{FFFF00}Желтый\n{FEBFEF}Розовый\nБелый\nГолубой\nОранжевый\nЛёгкий Зелёный\nЛёгкий Желтый\nМентовская мигалка\nFBI мигалка\nУдалить Неон","Выбрать","Отмена");
			}
			else if(listitem == 4)//смена номера
			{
			    ShowPlayerDialog(playerid,2,DIALOG_STYLE_INPUT,"{33FF00}Смена номера","{FF3300}Введите номера авто в окошко","Готово","Отмена");
				return 1;
			}
		}
	}
	if(dialogid == 999)
	{
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerTime(playerid, 00, 00);
			}
			if(listitem == 1)
			{
				SetPlayerTime(playerid, 01, 00);
			}
			if(listitem == 2)
			{
				SetPlayerTime(playerid, 02, 00);
			}
			if(listitem == 3)
			{
				SetPlayerTime(playerid, 03, 00);
			}
			if(listitem == 4)
			{
				SetPlayerTime(playerid, 04, 00);
			}
			if(listitem == 5)
			{
				SetPlayerTime(playerid, 05, 00);
			}
			if(listitem == 6)
			{
				SetPlayerTime(playerid, 06, 00);
			}
			if(listitem == 7)
			{
				SetPlayerTime(playerid, 07, 00);
			}
			if(listitem == 8)
			{
				SetPlayerTime(playerid, 08, 00);
			}
			if(listitem == 9)
			{
				SetPlayerTime(playerid, 09, 00);
			}
			if(listitem == 10)
			{
				SetPlayerTime(playerid, 10, 00);
			}
			if(listitem == 11)
			{
				SetPlayerTime(playerid, 11, 00);
			}
			if(listitem == 12)
			{
				SetPlayerTime(playerid, 12, 00);
			}
			if(listitem == 13)
			{
				SetPlayerTime(playerid, 13, 00);
			}
			if(listitem == 14)
			{
				SetPlayerTime(playerid, 14, 00);
			}
			if(listitem == 15)
			{
				SetPlayerTime(playerid, 15, 00);
			}
			if(listitem == 16)
			{
				SetPlayerTime(playerid, 16, 00);
			}
			if(listitem == 17)
			{
				SetPlayerTime(playerid, 17, 00);
			}
			if(listitem == 18)
			{
				SetPlayerTime(playerid, 18, 00);
			}
			if(listitem == 19)
			{
				SetPlayerTime(playerid, 19, 00);
			}
			if(listitem == 20)
			{
				SetPlayerTime(playerid, 20, 00);
			}
			if(listitem == 21)
			{
				SetPlayerTime(playerid, 21, 00);
			}
			if(listitem == 22)
			{
				SetPlayerTime(playerid, 22, 00);
			}
			if(listitem == 23)
			{
				SetPlayerTime(playerid, 23, 00);
			}
	    }
	}
	 //////LASERS
 if(dialogid == 132)
    {
        if(response)
        {
            if(listitem == 0)
            {
                SetPVarInt(playerid, "laser", 1);
                SetPVarInt(playerid, "color", GetPVarInt(playerid, "color"));
            }
            if(listitem == 1)
            {
                SetPVarInt(playerid, "laser", 0);
                RemovePlayerAttachedObject(playerid, 0);
            }
            if(listitem == 2)
            {
                ShowPlayerDialog(playerid,133,DIALOG_STYLE_LIST,"Цвета","{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\n{FFFF00}Желтый\n{FEBFEF}Розовый\nОранжевый","Enter","Exit");
            }
        }
        return 1;
    }
 if(dialogid == 133)
    {
        if(response)
        {
            if(listitem == 0)
            {
                SetPVarInt(playerid, "color", 18643);
            }
            if(listitem == 1)
            {
                SetPVarInt(playerid, "color", 19080);
            }
            if(listitem == 2)
            {
                SetPVarInt(playerid, "color", 19083);
            }
            if(listitem == 3)
            {
                SetPVarInt(playerid, "color", 19084);
            }
            if(listitem == 4)
            {
                SetPVarInt(playerid, "color", 19081);
            }
            if(listitem == 5)
            {
                SetPVarInt(playerid, "color", 19082);
            }
        }
        return 1;
    }
 //////LASERS END
	if(dialogid == 7)
	{
		if(response)
		{
			if(listitem == 0)
			{
		    	ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{33FF00}Администрация", "{33FF00}Создатели мода - {FF3300}Boufen and Kilav\n\n{33FF00}СоздаТель сервера (проекта) - {FF3300}Sanya161RU", "OK", "");
            }
			if(listitem == 1)
            {
                ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{33FF00}Платные услуги", "{33FF00}По вопросам покупки админки {FF3300}(150 рублей 10 лвл навсегда) писать\n\n В{FF3300}Скайп: ar161ru", "OK", "");
         	}
 		    if(listitem == 2)
			{
		    	ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{33FF00}Команды сервера", "{FF3300}/menu - {33FF00}вызвать меню сервера\n\n{FF3300}/r - {33FF00}сбросить очки\n\n{FF3300}/colors - {33FF00}выбрать цвет ника\n\n/hi , /bb - Приветствие на сервере\n\n{FF3300}/radio - {33FF00}вызвать меню радио\n\n{FF3300}/count - {33FF00}отсчёт\n\n{FF3300}/цены - {33FF00}цены на админки\n\n{FF3300}/sts - {33FF00}поставить статус ({FF3300}/del - {33FF00}удалить статус) ", "OK", "");
            }
            if(listitem == 3)
			{
		    	ShowPlayerDialog(playerid, 88, DIALOG_STYLE_MSGBOX, "{33FF00}Возможные проблемы", "{FF3300}Если радио не работает, попробуйте прибавить громкости в {33FF00}меню игры (ESC)", "OK", "");
            }
			if(listitem == 4)ShowPlayerDialog(playerid, 432, DIALOG_STYLE_MSGBOX, "{33FF00}Обновления v1.3", "{33FF00}Добавлен пункт меню {FF3300}(Управление персонажем => Объекты)\n\n{33FF00}Добавлен пункт меню {FF3300}(Управление персонажем => Покупка оружия)\n\n{33FF00}Добавлен пункт {FF3300(Управление персонажем=>Лазеры)\n\nДобавлен {FF3300}Античит\n\n{33FF00}Добавлен новый {FF3300}Неон", "OK", "");
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
			else if(listitem == 3)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(18650,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18650,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem == 4)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(18651,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18651,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem == 5)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(18652,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18652,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem == 6)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				DestroyObject(neon[playerid][2]);
				DestroyObject(neon[playerid][3]);
				neon[playerid][0] = CreateObject(18648,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18648,0,0,0,0,0,0,100.0);
				neon[playerid][2] = CreateObject(18649,0,0,0,0,0,0,100.0);
				neon[playerid][3] = CreateObject(18649,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][2], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][3], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem == 7)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				DestroyObject(neon[playerid][2]);
				DestroyObject(neon[playerid][3]);
				neon[playerid][0] = CreateObject(18647,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18647,0,0,0,0,0,0,100.0);
				neon[playerid][2] = CreateObject(18650,0,0,0,0,0,0,100.0);
				neon[playerid][3] = CreateObject(18650,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][2], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][3], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem == 8)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				DestroyObject(neon[playerid][2]);
				DestroyObject(neon[playerid][3]);
				neon[playerid][0] = CreateObject(18649,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18649,0,0,0,0,0,0,100.0);
				neon[playerid][2] = CreateObject(18652,0,0,0,0,0,0,100.0);
				neon[playerid][3] = CreateObject(18652,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][2], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][3], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
   			else if(listitem==9)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				DestroyObject(neon[playerid][2]);
				DestroyObject(neon[playerid][3]);
				neon[playerid][0] = CreateObject(18652,0,0,0,0,0,0,100.0);
				neon[playerid][1] = CreateObject(18652,0,0,0,0,0,0,100.0);
				neon[playerid][2] = CreateObject(18650,0,0,0,0,0,0,100.0);
				neon[playerid][3] = CreateObject(18650,0,0,0,0,0,0,100.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][2], GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][3], GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			}
			else if(listitem == 10)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				neon[playerid][0] = CreateObject(19420,0,0,0.78,0,0,0,0.0);
				neon[playerid][1] = CreateObject(18646,0,0,0.78,0,0,0,0.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), 0, 0.0, 0.78, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], GetPlayerVehicleID(playerid), 0, 0.0, 0.78, 0.0, 0.0, 0.0);
			}
			else if(listitem == 11)
			{
				DestroyObject(neon[playerid][0]);
				neon[playerid][0] = CreateObject(18646,0,0,0.78,0,0,0,0.0);
				AttachObjectToVehicle(neon[playerid][0], GetPlayerVehicleID(playerid), 0, 0.0, 0.78, 0.0, 0.0, 0.0);
			}
			else if(listitem==12)
			{
				DestroyObject(neon[playerid][0]);
				DestroyObject(neon[playerid][1]);
				DestroyObject(neon[playerid][2]);
				DestroyObject(neon[playerid][3]);
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
					if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски \nГидравлика \nАрхангел Тюнинг \nЦвет \nВинилы ", "Выбрать", "Назад");
					else SendClientMessage(playerid, COLOR_RED, "Ты не водитель машины!");
				}
    			else SendClientMessage(playerid, COLOR_RED, "Ты не в машине.");
			}

			if(listitem == 1)ShowPlayerDialog(playerid, 5, DIALOG_STYLE_LIST, "Телепорты", "Дрифт места\nДраг места\nРаллийные трассы\nРазное", "Выбрать", "Назад");
			if(listitem == 2)ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "Меню Анимации", "Напитки и Cигареты\nТанцы\nЗвонки\nРазное\n{33FF00}Остановить анимацию", "OK", "Назад");
            if(listitem == 3)return OnPlayerCommandText(playerid,"/radio");
		    if(listitem == 4)
			{
        		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,0xFF0000AA,"Вы уже в транспорте");
				ShowPlayerDialog(playerid,9,DIALOG_STYLE_LIST,"Автомобили","{33FF00}Elegy\nSultan\nInfernus\nBanshee\nBaffalo\nCheetah\nTurismo\nUranus\nBullet\nJester\nPhoenix\nSuperGT\nFlash\nZR-350\nHuntley\nStretch\nPolice\nTaxi\nNRG-500\nSanchez\nKart\nBMX\nMtBike\nMaverick\nShamal\nBeagle","ОК","Назад");
				return 1;
     		}
			if(listitem == 5)ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "Управление Персонажем", "Пополнить броню\nПополнить жизни\nСменить скин\n{33FF00}Объекты\n{33FF00}Лаз{0000ff}еры\nСтили боя\nКупить оружие\n{FF3300}Самоубийство", "OK", "Назад");
            if(listitem == 6)ShowPlayerDialog(playerid, 7, DIALOG_STYLE_LIST, "Помощь", "Администрация\nПлатные услуги\nКоманды сервера\nВозможные проблемы\nОбновления", "ОК", "Назад");
            if(listitem == 7)return OnPlayerCommandText(playerid,"/count");
            if(listitem == 8)ShowPlayerDialog(playerid, 3013, DIALOG_STYLE_LIST, "Настройки", "Цвет ника\nВремя сервера\nНовогодняя шапка", "ОК", "Назад");
            if(listitem == 9)
            {
                if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,0xFF0000AA,"Вы должны быть в машине!");
				ShowPlayerDialog(playerid,0,DIALOG_STYLE_LIST,"Управление авто","Открыть капот\nОткрыть багажник\nЗакрыть капот\nЗакрыть багажник\nСменить номер\nНеон","Выбрать","Отмена");
			}
  			if(listitem == 10)return OnPlayerCommandText(playerid,"/r");
			if(listitem == 11)//remont
		    {
            	SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.0);
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
				ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "Управление Персонажем", "Пополнить броню\nПополнить жизни\nСменить скин\n{{33FF00}Обьекты\n{{33FF00}Лаз{{0000ff}еры\nСамоубийство", "OK", "Назад");
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
			}
			if(listitem == 3)ShowPlayerDialog(playerid, 1111, DIALOG_STYLE_LIST, "Объекты", "Красный дым\nБаскетбольный мяч\nВодяной шар\nЛоготип sa-mp\n{FF3300}Убрать объекты", "ОК", "Назад");
			if(listitem == 4)ShowPlayerDialog(playerid,132,DIALOG_STYLE_LIST,"Лазер","{FF0000}Включить\n{0000FF}Выключить\n{FF9900}Цвет","Enter","Exit");
			if(listitem == 6)ShowPlayerDialog(playerid,564,DIALOG_STYLE_LIST,"Купить оружие","M4A1\nAK-47\nDesert Eagle\nСнайперка\nНож\nОбрезы\nГранаты\nМолотов\nMicro SMG/UZI\nSilent Pistol\nБита\nБазука","Enter","Exit");
			if(listitem == 7)
		    {
				SetPlayerHealth(playerid,0);
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
			}
			if(listitem == 5)ShowPlayerDialog(playerid,563,DIALOG_STYLE_LIST,"Стили боя","Бокс\nКунфу\nОб Колено\nНормальный\nКик боксёр","Enter","Exit");
			if(listitem == 1)
			{
				SetPlayerHealth(playerid,100);
				ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "Управление Персонажем", "Пополнить броню\nПополнить жизни\nСменить скин\n{{33FF00}Обьекты\n{{33FF00}Лаз{{0000ff}еры\nСамоубийство", "OK", "Назад");
				PlayerPlaySound(playerid,1149,0.0,0.0,0.0);
			}
			if(listitem == 2)ShowPlayerDialog(playerid, 10, DIALOG_STYLE_INPUT, "{33FF00}Смена скина", "{FF3300}Введите id", "OK", "назад");
		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "Тюнинг\nТелепорты\nАнимации\nРадио\nАвтомобили\nУправление персонажем\nПомощь\n{FFFF00}Отсчёт\n{33FF00}Настройки\n{FF3300}Управление Авто\n{0033CC}Сброс очков\n{33FF00}Перевернуть авто", "Выбрать", "Выход");
}
    if(dialogid == 564)
	{
		if(response)
		{
			if(listitem == 0)
			{
   			GivePlayerMoney(playerid,-1500);
    		GivePlayerWeapon(playerid,31,100);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили M4A1");
			}
			if(listitem == 1)
			{
			GivePlayerMoney(playerid,-1400);
    		GivePlayerWeapon(playerid,30,100);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили AK-47");
			}
			if(listitem == 2)
			{
			GivePlayerMoney(playerid,-500);
    		GivePlayerWeapon(playerid,24,20);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Desert Eagle");
			}
			if(listitem == 3)
			{
			GivePlayerMoney(playerid,-1500);
    		GivePlayerWeapon(playerid,34,20);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Снайперку");
			}
			if(listitem == 4)
			{
			GivePlayerMoney(playerid,-100);
    		GivePlayerWeapon(playerid,4,1);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Нож");
			}
			if(listitem == 5)
			{
			GivePlayerMoney(playerid,-700);
    		GivePlayerWeapon(playerid,26,20);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Обрезы");
			}
			if(listitem == 6)
			{
			GivePlayerMoney(playerid,-500);
    		GivePlayerWeapon(playerid,16,4);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Гранаты");
			}
			if(listitem == 7)
			{
			GivePlayerMoney(playerid,-500);
    		GivePlayerWeapon(playerid,18,5);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Коктель молотова");
			}
			if(listitem == 8)
			{
			GivePlayerMoney(playerid,-800);
    		GivePlayerWeapon(playerid,28,350);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Micro SMG/UZI");
			}
			if(listitem == 9)
			{
			GivePlayerMoney(playerid,-500);
    		GivePlayerWeapon(playerid,23,30);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Silent Pistol");
			}
			if(listitem == 10)
			{
			GivePlayerMoney(playerid,-150);
    		GivePlayerWeapon(playerid,5,1);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Биту");
			}
			if(listitem == 11)
			{
			GivePlayerMoney(playerid,-5000);
    		GivePlayerWeapon(playerid,35,8);
    		SendClientMessage(playerid,COLOR_RED,"Вы купили Базуку");
			}
		}
	}
	if(dialogid == 563)
	{
		if(response)
		{
			if(listitem == 0)
			{
			SetPlayerFightingStyle(playerid, 5);
	 		SendClientMessage(playerid, COLOR_GREEN, "Теперь у вас стиль боя 'Бокс'");
 			return 1;
			}
			if(listitem == 1)
			{
			SetPlayerFightingStyle(playerid, 6);
		 	SendClientMessage(playerid, COLOR_GREEN, "Теперь у вас стиль боя 'Кунфу'");
		 	return 1;
			}
			if(listitem == 2)
			{
			SetPlayerFightingStyle(playerid, 7);
		 	SendClientMessage(playerid, COLOR_GREEN, "Теперь у вас стиль боя 'Об колено'");
		 	return 1;
			}
			if(listitem == 3)
			{
			SetPlayerFightingStyle(playerid, 4);
 			SendClientMessage(playerid, COLOR_GREEN, "Теперь у вас стиль боя 'Нормальный'");
			return 1;
			}
			if(listitem == 4)
			{
			SetPlayerFightingStyle(playerid, 15);
 			SendClientMessage(playerid, COLOR_GREEN, "Теперь у вас стиль боя 'Кик боксёр'");
 			return 1;
			}
		}
	}

	if(dialogid == 1111)//Объекты
	{
		if(response)
		{
			if(listitem == 0)
		    {
		    SetPlayerAttachedObject( playerid, 0, 18728, 2, 0.134301, 1.475258, -0.192459, 82.870338, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );
			}
			if(listitem == 1)
			{
			SetPlayerAttachedObject( playerid, 0, 2114, 2, 0.043076, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );
			}
			if(listitem == 2)
		    {
		    SetPlayerAttachedObject( playerid, 0, 18844, 1, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, -0.027590, -0.027590, -0.027590 );
			}
			if(listitem == 3)
			{
            SetPlayerAttachedObject( playerid, 0, 18749, 2, 0.264992, 0.043229, -0.004249, 0.000000, 87.368362, 165.130233, 1.000000, 1.000000, 1.000000 );
			}
            if(listitem == 4)
            {
            RemovePlayerAttachedObject(playerid, 0);
            DestroyPlayerObject(playerid, 18728);
			}
		}
	}
	if(dialogid == 3013)//Настройки
	{
		if(response)
		{
			if(listitem == 0)return OnPlayerCommandText(playerid,"/colors");
			if(listitem == 1)
			{
                ShowPlayerDialog(playerid, 999, DIALOG_STYLE_LIST, "Время", "00:00\n01:00\n02:00\n03:00\n04:00\n05:00\n06:00\n07:00\n08:00\n09:00\n10:00\n11:00\n12:00\n13:00\n14:00\n15:00\n16:00\n17:00\n18:00\n19:00\n20:00\n21:00\n22:00\n23:00", "Выбор", "Отмена");
   			}
   			if(listitem == 2)return OnPlayerCommandText(playerid,"/shapka");
		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "Тюнинг\nТелепорты\nАнимации\nРадио\nАвтомобили\nУправление персонажем\nПомощь\n{FFFF00}Отсчёт\n{33FF00}Настройки\n{FF3300}Управление Авто\n{0033CC}Сброс очков\n{33FF00}Перевернуть авто", "Выбрать", "Выход");
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
				ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски \nГидравлика \nАрхангел Тюнинг \nЦвет \nВинилы ", "Выбрать", "Назад");
			}
			if(listitem == 2)
			{
			    new Car = GetPlayerVehicleID(playerid), Model = GetVehicleModel(Car);
				switch(Model)
				{
					case 559,560,561,562,565,558: ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Тюнинг Wheel Arch Angels", "Передний бампер X-flow\nПередний бампер Alien\nЗадний бампер X-Flow\nЗадний бампер Alien\nСпойлер X-Flow \nСпойлер Alien \nБоковая юбка X-Flow \nБоковая юбка Alien\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nВыхлоп X-flow\nВыхлоп Alien", "OK", "Назад");
					default: SendClientMessage(playerid,0xFF0000AA,"Вы должны быть в: Elegy, Stratum, Flash, Sultan,  ");
				}
			}
			if(listitem == 3)ShowPlayerDialog(playerid, 13, DIALOG_STYLE_LIST, "Выбор цвета", "Красный \nСиний \nЖелтый \nЗеленый \nСерый \nОранжевый \nЧерный \nБелый \nФиолетовый \nСалатовый", "ОК", "Назад");
			if(listitem == 4)ShowPlayerDialog(playerid, 14, DIALOG_STYLE_LIST, "Выбор винила", "Винил №1 \nВинил №2 \nВинил №3 ", "ОК", "Назад");
		}
		else ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "Игровое меню", "Тюнинг\nТелепорты\nАнимации\nРадио\nАвтомобили\nУправление персонажем\nПомощь\n{FFFF00}Отсчёт\n{33FF00}Настройки\n{FF3300}Управление Авто\n{0033CC}Сброс очков\n{33FF00}Перевернуть авто", "Выбрать", "Выход");
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
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски \nГидравлика \nАрхангел Тюнинг \nЦвет \nВинилы ", "Выбрать", "Назад");
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
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски \nГидравлика \nАрхангел Тюнинг \nЦвет \nВинилы ", "Выбрать", "Назад");
	}

  	if(dialogid == 9)//car spawning into
	{
		if(response)//написано не мной, взято из чьего-то меню, тем не менее - автору спасибо.
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
				case 5: carvlad = "Cheetah", id = 415;
				case 6: carvlad = "Turismo", id = 451;
				case 7: carvlad = "Uranus", id = 558;
				case 8: carvlad = "Bullet", id = 541;
				case 9: carvlad = "Jester", id = 559;
				case 10: carvlad = "Phoenix", id = 603;
				case 11: carvlad = "SuperGt", id = 506;
				case 12: carvlad = "Flash", id = 565;
				case 13: carvlad = "ZR-350", id = 477;
				case 14: carvlad = "Huntley", id = 579;
				case 15: carvlad = "Stretch", id = 409;
				case 16: carvlad = "CopCarLA", id = 596;
				case 17: carvlad = "Taxi", id = 420;
				case 18: carvlad = "Nrg500", id = 522;
				case 19: carvlad = "Sanchez", id = 468;
				case 20: carvlad = "Kart", id = 571;
				case 21: carvlad = "Bmx", id = 481;
				case 22: carvlad = "MtBike", id = 510;
				case 23: carvlad = "Maverick", id = 487;
				case 24: carvlad = "Shamal", id = 519;
				case 25: carvlad = "Beagle", id = 511;
			}
			format(string,sizeof(string),"%s заспавнен",carvlad); SendClientMessage(playerid,0x21DD00FF,string);
			if(ta4katest[playerid] == 1)DestroyVehicle(ta4ka[playerid]);
			ta4ka[playerid] = CreateVehicle(id,X,Y,Z,Angle,-1,-1,50000);
			if(GetPlayerInterior(playerid)) LinkVehicleToInterior(ta4ka[playerid],GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(ta4ka[playerid],GetPlayerVirtualWorld(playerid));
			PutPlayerInVehicle(playerid,ta4ka[playerid],0);
			ta4katest[playerid] = 1;
		}
		return 1;
	}
	if(dialogid == 6)//Меню анимации взято из скрипта Panther'a
	{
  		if(response)
  		{
			if(listitem == 0)ShowPlayerDialog(playerid, 15, DIALOG_STYLE_LIST, "Напитки и Cигареты", "Сигарета\nПиво\nВино\nСпрайт\n{33FF00}Опьянение", "OK", "Назад");
            if(listitem == 1)ShowPlayerDialog(playerid, 16, DIALOG_STYLE_LIST, "Танцы", "Танец - 1\nТанец - 2\nТанец - 3\nТанец - 4", "OK", "Назад");
            if(listitem == 2)ShowPlayerDialog(playerid, 17, DIALOG_STYLE_LIST, "Звонки", "Звонок", "OK", "Назад");
            if(listitem == 3)ShowPlayerDialog(playerid, 3012, DIALOG_STYLE_LIST, "Разное", "Руки вверх\nОблегчение", "OK", "Назад");
            if(listitem == 4)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
                SetPlayerDrunkLevel(playerid, 0);
                SetPlayerSpecialAction (playerid, 13 - SPECIAL_ACTION_STOPUSECELLPHONE);
		        SendClientMessage(playerid, 0x00FF00AA, "Ты остановил анимацию, можешь двигаться.");
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
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_SMOKE_CIGGY );
    	        SendClientMessage(playerid, 0x00FF00AA, "Анимация - Курение");
			}
			if(listitem == 1)
			{
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DRINK_BEER );
    	        SendClientMessage(playerid, 0x00FF00AA, "Анимация - Пиво");
			}
			if(listitem == 2)
			{
			    SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DRINK_WINE );
    	        SendClientMessage(playerid, 0x00FF00AA, "Анимация - Вино");
			}
			if(listitem == 3)
			{
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DRINK_SPRUNK );
    	        SendClientMessage(playerid, 0x00FF00AA, "Анимация - Спрайт");
			}
            if(listitem == 4)
			{
		        SetPlayerDrunkLevel(playerid, 2323000);
	            SendClientMessage(playerid, 0x00FF00AA, "Анимация - Опьянение {33FF00}(чтобы снять эффект выберите (Остановить анимацию))");
		    }
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
   		}
		else ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "Меню Анимации", "Напитки и Cигареты\nТанцы\nЗвонки\nРазное\n{33FF00}Остановить анимацию", "OK", "Назад");
   }

   if(dialogid == 16)//anim dance
   {
		if(response)
  		{
  			if(listitem == 0)
			{
				SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE1);
    	        SendClientMessage(playerid, 0x00FF00AA, "Танец - 1");
		    }
            if(listitem == 1)
			{
		        SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE2);
                SendClientMessage(playerid, 0x00FF00AA, "Танец - 2");
		    }
             if(listitem == 2)
			{
			    SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE3);
    	        SendClientMessage(playerid, 0x00FF00AA, "Танец - 3");
			}
            if(listitem == 3)
			{
		       SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE4);
    	       SendClientMessage(playerid, 0x00FF00AA, "Танец - 4");
		    }
      		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		}
		else ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "Меню Анимации", "Напитки и Cигареты\nТанцы\nЗвонки\nРазное\n{33FF00}Остановить анимацию", "OK", "Назад");
	}


	if(dialogid == 17)//Звонки
 	{
  		if(response)
    	{
  			if(listitem == 0)
			{
			   SetPlayerSpecialAction (playerid, SPECIAL_ACTION_USECELLPHONE);
    	       SendClientMessage(playerid, 0x00FF00AA, "Анимация - Звонок");
               GivePlayerMoney(playerid,-50);
		    }
		    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
      	}
      	else ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "Меню Анимации", "Напитки и Cигареты\nТанцы\nЗвонки\nРазное\n{33FF00}Остановить анимацию", "OK", "Назад");
	}
		if(dialogid == 3012)
 	{
  		if(response)
    	{
            if(listitem == 0)
			{
			   SetPlayerSpecialAction (playerid, SPECIAL_ACTION_HANDSUP);
    	       SendClientMessage(playerid, 0x00FF00AA, "Анимация - Руки Вверх");
		    }
	        if(listitem == 1)
            {
            SetPlayerSpecialAction(playerid,68);
            SendClientMessage(playerid, 0x00FF00AA, "Анимация - облегчение");
            }
		    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
      	}
      	else ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "Меню Анимации", "Напитки и Cигареты\nТанцы\nЗвонки\nРазное\n{33FF00}Остановить анимацию", "OK", "Назад");
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
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски \nГидравлика \nАрхангел Тюнинг \nЦвет \nВинилы ", "Выбрать", "Назад");
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
		else ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "Тюнинг меню", "Диски \nГидравлика \nАрхангел Тюнинг \nЦвет \nВинилы ", "Выбрать", "Назад");
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
            if(listitem == 0)ShowPlayerDialog(playerid, 1256, DIALOG_STYLE_LIST, "Дрифт места", "Ухо\nDrift_ZoNe\nTRACK 8\nTrack SF", "Выбрать", "Назад");
			if(listitem == 1)ShowPlayerDialog(playerid, 555, DIALOG_STYLE_LIST, "Драг места", "Пляж ЛС\nДраг 1\nАква_трЭк\nDrag 2\nDrag SF", "Выбрать", "Назад");
 			if(listitem == 2)ShowPlayerDialog(playerid, 1278, DIALOG_STYLE_LIST, "Раллийные трассы", "Гора Чилиад", "Выбрать", "Назад");
   			if(listitem == 3)ShowPlayerDialog(playerid, 1289, DIALOG_STYLE_LIST, "Разное", "Место спавна\nЗона домов - 1\nЗона домов - 2\nРублёвка", "Выбрать", "Назад");

		}
 }
 	if(dialogid == 1256)
   	{
		if(response)
    {
    if(listitem == 0)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -325.1331,1533.0276,75.3594);
			 	else SetPlayerPos(playerid, -325.1331,1533.0276,75.3594);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}Ухо");
				return 1;
				}
	if(listitem == 1)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1664.0024, 280.5399, 7.2187);
			 	else SetPlayerPos(playerid, -1664.0024, 280.5399, 7.2187);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}DRIFT_Zone");
				return 1;
				}
	if(listitem == 2)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 2815.7805, -1850.8785, 11.5169);
			 	else SetPlayerPos(playerid, 2815.7805, -1850.8785, 11.5169);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}TRACK 8");
				return 1;
				}
	if(listitem == 3)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2197.0579, -129.7366, 61.4721);
			 	else SetPlayerPos(playerid, -2197.0579, -129.7366, 61.4721);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}TRACK SF");
				return 1;
				}

		}
 }
  	if(dialogid == 555)
   	{
		if(response)
    {
    if(listitem == 0)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 836.17846679688,-2046.5209960938,14.065537452698);
			 	else SetPlayerPos(playerid, 836.17846679688,-2046.5209960938,14.065537452698);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}Пляж ЛС");
				return 1;
				}

		}
    if(listitem == 1)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1674.3914, -245.5447, 18.6717);
			 	else SetPlayerPos(playerid, -1674.3914, -245.5447, 18.6717);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}Drag-1");
				return 1;
				}
    if(listitem == 2)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1353.6614, 392.5081, 31.4973);
			 	else SetPlayerPos(playerid, -1353.6614, 392.5081, 31.4973);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}Аква_трэк");
				return 1;
				}
    if(listitem == 3)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2686.0317, 1253.7795, 58.3045);
			 	else SetPlayerPos(playerid, -2686.0317, 1253.7795, 58.3045);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}Драг 2");
				return 1;
				}
    if(listitem == 4)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2346.9370,1074.4822,55.4164);
			 	else SetPlayerPos(playerid, -2346.9370,1074.4822,55.4164);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}Драг SF");
				return 1;
				}
    if(listitem == 5)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2346.9370,1074.4822,55.4164);
			 	else SetPlayerPos(playerid, -2346.9370,1074.4822,55.4164);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}Драг SF");
				return 1;
			}
 	}
   	if(dialogid == 1278)
   	{
		if(response)
    {
    if(listitem == 0)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -2335.4683, -1620.7100, 483.4157);
			 	else SetPlayerPos(playerid, -2335.4683, -1620.7100, 483.4157);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}Ралли");
				return 1;
				}

		}
 }
    	if(dialogid == 1289)
   	{
		if(response)
    {
    if(listitem == 0)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1703.4146,1333.7198,7.1763);
			 	else SetPlayerPos(playerid, -35.0012, -2053.9026, 4.2100);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы на {FF3300}Место спавна");
				return 1;
				}
	if(listitem == 1)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 38.7763, 2507.7305, 15.4951);
			 	else SetPlayerPos(playerid, 38.7763, 2507.7305, 15.4951);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы в {FF3300}Зону домов - 1");
				return 1;
				}
 	if(listitem == 2)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), -1113.5021, -1192.6265, 130.0602);
			 	else SetPlayerPos(playerid, -1113.5021, -1192.6265, 130.0602);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы в {FF3300}Зону домов - 2");
				return 1;
				}
	if(listitem == 3)
			{
				if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)SetVehiclePos(GetPlayerVehicleID(playerid), 1862.3062, -2369.0867, 14.4088);
			 	else SetPlayerPos(playerid, 1862.3062, -2369.0867, 14.4088);
				SendClientMessage(playerid, 0xFF0000AA,"[Drift_Russian]: Вы телепортированы в {FF3300}Рублёвку");
				return 1;
			}
	}
	}
 else if(dialogid == RADIO)
 {
  if(response)
  {
   if(listitem == 0)// (1)
   {
            PlayAudioStreamForPlayer(playerid,"http://www.zaycev.fm:9001/rnb/ZaycevFM(128)");
   }
   if(listitem == 1)// (2)
   {
             PlayAudioStreamForPlayer(playerid,"http://webcast.emg.fm:55655/europaplus128.mp3");
   }
   if(listitem == 2)// (3)
   {
             PlayAudioStreamForPlayer(playerid,"http://prostomap.ru/Drift_Russian.m3u");
   }
   if(listitem == 3)// (6)
   {
            PlayAudioStreamForPlayer(playerid,"http://icefm.ru/etc/live.m3u");
   }
if(listitem == 4)// (7)
   {
            StopAudioStreamForPlayer(playerid);
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
				GameTextForPlayer(i,"~r~Drift_Russian",500,4);
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				countdown[i]=-1;
			}
	}
}


dcmd_dt(playerid, params[])
{
	new str[64];
	if (!strlen(params)) return SendClientMessage(playerid, 0xFF0000AA, "[Drift_Russian]: /dt [мир]"); //Grey colour
	if (strval(params) < 0) return SendClientMessage(playerid, 0xFF0000AA, "[Drift_Russian]: Число должно быть больше нуля"); //Grey colour
	new ii = strval(params);
	SetPlayerVirtualWorld(playerid,ii);
	format(str,64,"[Drift Battle]: Ваш мир изменён на %d",ii);
	SendClientMessage(playerid, 0x00FF00AA,str); //Grey colour
	if(ii!=0)return SendClientMessage(playerid, 0x00FF00AA, "[Drift_Russian]: Вы в режиме дрифт тренировки"); //Grey colour
	SendClientMessage(playerid, 0x00FF00AA, "[Drift_Russian]: Режим дрифт тренировки выключен"); //Grey colour
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
public settime(playerid)
{
        new string[256],year,month,day,hours,minutes,seconds;
        getdate(year, month, day), gettime(hours, minutes, seconds);
        format(string, sizeof string, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
        TextDrawSetString(Times, string);
}
public SaveAccounts() // Сохраняет данные
{
	for(new f; f < GetMaxPlayers(); f++)
	{
	if(!IsPlayerConnected(f))continue;
	SaveAccount(f);
	}
}

public OnPlayerUpdate(playerid)
{
	//ANTI-4IT
	new animlib[30], animname[30] ;
 GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
 if(strcmp(animlib, "PED", true) == 0 && strcmp(animname, "RUN_PLAYER", true) == 0 && GetPlayerSkin(playerid) != 0)
 {
 if(!IsPlayerInAnyVehicle(playerid))
 {
 SendClientMessage(playerid,0xFFFF00FF, "[Drift_Russian]: Для игры на сервере удалите читы!!!");
 Kick(playerid);
 }
 }
	//ANTI-4IT
    if(GetPVarInt(playerid, "laser"))
        {
            RemovePlayerAttachedObject(playerid, 0);
            if(IsPlayerInAnyVehicle(playerid)) return 1;
            switch (GetPlayerWeapon(playerid))
            {
            case 22:
                {
                    if(IsPlayerAiming(playerid))
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.108249, 0.030232, 0.118051, 1.468254, 350.512573, 364.284240);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.108249, 0.030232, 0.118051, 1.468254, 349.862579, 364.784240);
                        }
                    }
                    else
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                        }
                    }
                }
            case 23:
                {
                    if(IsPlayerAiming(playerid))
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.108249, 0.030232, 0.118051, 1.468254, 350.512573, 364.284240);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.108249, 0.030232, 0.118051, 1.468254, 349.862579, 364.784240);
                        }
                    }
                    else
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                        }
                    }
                }
            case 27:
                {
                    if(IsPlayerAiming(playerid))
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.588246, -0.022766, 0.138052, -11.531745, 347.712585, 352.784271);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.588246, -0.022766, 0.138052, 1.468254, 350.712585, 352.784271);
                        }
                    }
                    else
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.563249, -0.01976, 0.134051, -11.131746, 351.602722, 351.384216);
                        }
                    }
                }
            case 30:
                {
                    if(IsPlayerAiming(playerid))
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.628249, -0.027766, 0.078052, -6.621746, 352.552642, 355.084289);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.628249, -0.027766, 0.078052, -1.621746, 356.202667, 355.084289);
                        }
                    }
                    else
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
                        }
                    }
                }
            case 31:
                {
                    if(IsPlayerAiming(playerid))
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
                        }
                    }
                    else
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
                        }
                    }
                }
            case 34:
                {
                    if(IsPlayerAiming(playerid))
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
                        }
                        return 1;
                    }
                    else
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.658248, -0.03276, 0.133051, -11.631746, 355.302673, 353.584259);
                        }
                    }
                }
            case 29:
                {
                    if(IsPlayerAiming(playerid))
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.298249, -0.02776, 0.158052, -11.631746, 359.302673, 357.584259);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.298249, -0.02776, 0.158052, 8.368253, 358.302673, 352.584259);
                        }
                    }
                    else
                    {
                        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
                        }
                        else
                        {
                            SetPlayerAttachedObject(playerid, 0, GetPVarInt(playerid, "color"), 6, 0.293249, -0.027759, 0.195051, -12.131746, 354.302734, 352.484222);
                        }
                    }
                }
            }
        }
        	return 1;
}


//==============================================================================
stock SaveAccount(playerid) // Сохраняет данные
{
    new PlayerNick6[MAX_PLAYER_NAME], account[128];
    GetPlayerName(playerid,PlayerNick6,sizeof(PlayerNick6));
    format(account,sizeof(account), "users/%s.ini", PlayerNick6);
    new iniFile = ini_openFile(account);
    ini_setInteger(iniFile, "Money", GetPlayerMoney(playerid));
    ini_setInteger(iniFile,"Admin",PlayerInfo[playerid][pAdmin]);
    ini_setInteger(iniFile, "Score", GetPlayerScore(playerid));
    ini_closeFile(iniFile);
    return 1;
}
stock IsPlayerAiming(playerid)
{
    new anim = GetPlayerAnimationIndex(playerid);
    if((anim == 1167) || (anim == 1365) || (anim == 1643) || (anim == 1453) || (anim == 220)) return 1;
    return 0;
}
//====================================================
public OtherTimer()
 {
     for(new i = 0; i < MAX_PLAYERS; i++)
         {
         new Colors[] = { 0x00ff0099, 0x5E5A80FF, 0x157DECFF , 0x9E7BFFFF , 0x659EC7FF , 0xF778A1FF , 0x43C6DBFF , 0xC9BE62FF , 0xFBB117FF, 0xC11B17FF, 0xFBBBB9FF };
         TextDrawHideForPlayer(i,prostomap);
         TextDrawColor(prostomap,Colors[random(sizeof(Colors))]);
         TextDrawShowForPlayer(i,prostomap);
         SetTimer("TextdrawColorChange", 100, 0);
         }
     }
//====================================================
//========================
public RazgruzFurui(playerid)
{
TogglePlayerControllable(playerid,1);
SendClientMessage(playerid, RED,"Разгрузка фуры завершена...");
SendClientMessage(playerid,-1,"Верните прицеп обратно где взяли, там же вам выдадут зарплату за рейс");
Checkpoint[playerid] = 2;
SetPlayerCheckpoint(playerid,-0.8136,-249.4456,5.0401,8.0);
return true;
}
//========================
