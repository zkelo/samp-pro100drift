#include <a_samp>
#include <streamer>
#include <mSelection>
#include <dini>
#include <crashdetect>
#include <dutils>
#include <airbreak>
#include <ARAC>

#undef MAX_PLAYERS

#pragma dynamic 45000
#pragma unused ret_memcpy

AntiDeAMX()
{
	new a[][] =
	{
		"Unarmed (Fist)",
		"Brass K"
	};
	#pragma unused a
}

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

/* ----------------------------- Форварды --------------------------- */
forward AutoRepair(playerid);
//forward AutoFlip(playerid);
forward AntiWeaponHack(playerid);
forward CancelTeleport(playerid);
forward CancelKiss(playerid);
forward OnPlayerUPD(playerid);
forward Count(playerid,a);
forward UnlockChat(playerid);
forward AR_UnFrzPlr(playerid);
forward ClockSync(playerid); // Часы на сервере
/* --------------------------- Дефайны ------------------------------ */
#define MAX_SAVED_VEHICLES 10
#define MAX_GANGS 1500
#define ACC_PFPATH "/data/accounts/%s.ini"
#define GSYS_PFILEPATH "/data/gsys/players/%s.ini"
#define GSYS_PGANGPATH "/data/gsys/gangs/%i.ini"
#define GSYS_SKINPRV_PATH "/data/gsys/skins/%i.skin"
#define GSYS_RANK_MIN 1
#define GSYS_RANK_MAX 6
#define INVALID_GANG_ID -1
#define MONEY_FOR_CREATE_GANG 1500000
/* --------------------------- Цвета -------------------------------- */
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_BRIGHTRED 0xFF0000AA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_VIOLET 0x9955DEEE
#define COLOR_LIGHTRED 0xFF99AADD
#define COLOR_SEAGREEN 0x00EEADDF
#define COLOR_GRAYWHITE 0xEEEEFFC4
#define COLOR_LIGHTNEUTRALBLUE 0xABCDEF66
#define COLOR_GREENISHGOLD 0xCCFFDD56
#define COLOR_LIGHTBLUEGREEN 0x0FFDD349
#define COLOR_NEUTRALBLUE 0xABCDEF01
#define COLOR_LIGHTCYAN 0xAAFFCC33
#define COLOR_LEMON 0xDDDD2357
#define COLOR_MEDIUMBLUE 0x63AFF00A
#define COLOR_NEUTRAL 0xABCDEF97
#define COLOR_BLACK 0x00000000
#define COLOR_NEUTRALGREEN 0x81CFAB00
#define COLOR_DARKGREEN 0x12900BBF
#define COLOR_LIGHTGREEN 0x24FF0AB9
#define COLOR_DARKBLUE 0x300FFAAB
#define COLOR_BLUEGREEN 0x46BBAA00
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_PURPLE 0x800080AA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_RED1 0xFF0000AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BROWN 0x993300AA
#define COLOR_CYAN 0x99FFFFAA
#define COLOR_TAN 0xFFFFCCAA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_KHAKI 0x999900AA
#define COLOR_LIME 0x99FF00AA
#define COLOR_SYSTEM 0xEFEFF7AA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF
/* -------------------- Идентификаторы диалогов --------------------- */
#define DIALOG_MAINMENU 1
#define DIALOG_TELEPORTS 2
#define DIALOG_TUNING 3
#define DIALOG_NICKNCOLOR 4
#define DIALOG_CARCOLORS 5
#define DIALOG_GAMESETTINGS 6
#define DIALOG_RADIO 7
#define DIALOG_HELP_MAIN 8
#define DIALOG_HELP_DATES 9
#define DIALOG_HELP_COMMANDS 10
#define DIALOG_HELP_FUNCTSINFO 11
#define DIALOG_HELP_HOTKEYS 13
#define DIALOG_PRICELIST 12
#define DIALOG_PAINTJOBS_YES 618
#define DIALOG_PAINTJOBS_NON 619
#define DIALOG_TUNING_COLORS 620
#define DIALOG_TUNING_COLORS_ENTERIDS 621
#define DIALOG_GAMESETTINGS_PFIGHTSTYLE 788
#define DIALOG_GAMESETTINGS_WEATHER_ENTERID 792
#define DIALOG_GAMESETTINGS_SETCHATCOLOR 1080
#define DIALOG_GANG_MAINMENU 845
#define DIALOG_GANG_INVITE 793
#define DIALOG_GANG_CREATE_CONFIRM 794
#define DIALOG_GANG_CREATE_COLOR 795
#define DIALOG_GANG_CREATE_NAME 796
#define DIALOG_GANG_END 797
#define DIALOG_GANG_UNINVITE 864
#define DIALOG_GANG_RSKINS 870
#define DIALOG_GANG_RSKIN 877
#define DIALOG_ATTACHM_MAIN 914
#define DIALOG_ATTACHM_BONES 915
#define DIALOG_ATTACHM_SLOT 916
#define DIALOG_NONMENU_PVEHS 1085
#define DIALOG_DM_QUE 2185
/* ------------------------- Кнопки диалогов ------------------------ */
#define DIALOG_BUTTON_CONFIRM_TEXT "Выбрать"
#define DIALOG_BUTTON_BACK_TEXT "Назад"
#define DIALOG_BUTTON_CLOSE_TEXT "Закрыть"
/* -------------------------- Константы ----------------------------- */
const MAX_PLAYERS = 501;
/* -------------- Переменные и массивы ------------------------------ */
new Text:Clock; // Часы

new bool:hicmd[MAX_PLAYERS]=false,bool:bbcmd[MAX_PLAYERS]=false,car[MAX_PLAYERS],
	vehlist,skinslist,sskinslist,bikeslist1,militarylist,vwheels,attachments,
	pickup_spawnExit,pickup_SParkVelo,pickup_BMXParkourVelo,pickup_militaryVehicles,
	TPTimer[MAX_PLAYERS],KissTimer[MAX_PLAYERS],PlayerUpdateTimer[MAX_PLAYERS],
	VehicleNeon[MAX_VEHICLES][2],StartPTimer[MAX_PLAYERS],bikeslist2,pickup_MTrialBikes,
	weaponslist,Text:site,Text:stextdrwe[MAX_PLAYERS],gsys_skinpreview[300],gskinslist,
	list_tmpvcp[MAX_PLAYERS];
new Float:DM1Spawns[4][] =
{
	{41.8843,-314.8006,2419.4182,269.2448},
	{74.0155,-212.6717,2419.4250,280.6031},
	{39.5125,-159.3369,2419.4250,230.3244},
	{72.5048,-164.8049,2423.0120,75.1995}
};
new ObjectsBones[18][512] =
{
	"Спина",
	"Голова",
	"Плечо левой руки",
	"Плечо правой руки",
	"Левая рука",
	"Правая рука",
	"Левое бедро",
	"Правое бедро",
	"Левая нога",
	"Правая нога",
	"Правые икры",
	"Левые икры",
	"Левое предплечье",
	"Правое предплечье",
	"Левая ключица",
	"Правая ключица",
	"Шея",
	"Челюсть"
};
/*new Float:GZonesPoints[][3] =
{
	{1333.7190,-1863.4155,13.5469},
	{1131.4585,-1773.7101,-96.2141},
	{-332.4944,1528.8733,75.3594},
	{-2212.5457,-979.4572,38.5249},
	{1870.4274,-1386.3281,13.5239},
	{-1979.7601,411.0576,35.1719},
	{285.0772,1919.6530,17.6406},
	{321.8886,-1798.3446,4.6964},
	{1544.5514,-1353.2316,329.4745},
	{-673.6619,-1858.2572,15.3120},
	{2495.9622,-1668.6489,13.3438},
	{-2.6400,-276.3049,1101.1018},
	{2549.9233,-1680.4445,4131.6470},
	{-429.9577,3865.1135,2.1107},
	{-2126.3999,664.1779,83.3785},
	{909.4449,829.5737,13.3516}
}; */
new	GRankName[GSYS_RANK_MAX+1][MAX_STRING] =
{
	"#",
	"Новичок",
	"Боец",
	"Воин",
	"Элитный воин",
	"Вице-лидер",
	"Лидер"
};
new PlayerColors[200] =
{
	0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,0xF4A460FF,
	0xEE82EEFF,0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,0x10DC29FF,
	0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,0x65ADEBFF,
	0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,0x3D0A4FFF,
	0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,0x057F94FF,
	0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,
	0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,
	0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,
	0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,0x3214AAFF,
	0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,0xDCDE3DFF,
	0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,0xD8C762FF,
	0xD8C762FF,0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,
	0xF4A460FF,0xEE82EEFF,0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,
	0x10DC29FF,0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,
	0x65ADEBFF,0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,
	0x3D0A4FFF,0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,
	0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,
	0x18F71FFF,0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,
	0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,
	0x2FD9DEFF,0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,
	0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,
	0xDCDE3DFF,0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,
	0xD8C762FF,0xD8C762FF
};

/* --------------------------- Макросы ----------------------------- */
#define command(%0) if(!strcmp(CMD,%0,true))
#define command_alias(%0,%1) if(!strcmp(CMD,%1,true)) return OnPlayerCommandText(playerid,%0)
#define pickup(%0) if(pickupid==%0)
#define pickups(%0,%1) if(pickupid==%0||pickupid==%1)
#define pickups_%0(%1) for(new i=0; i<%1; i++) if(pickupid==%0[i])
#define NonValid:%0(%1,%2) if(%0 < %1 || %0 > %2)
#define ShowAllNicknamesForPlayer(%0) for(new i=0; i<MAX_PLAYERS; i++) ShowPlayerNameTagForPlayer(%0,i,1)
#define HideAllNicknamesForPlayer(%0) for(new i=0; i<MAX_PLAYERS; i++) ShowPlayerNameTagForPlayer(%0,i,0)

main()
{
	print("----------------------------------");
	print("          Pro100Drift v8");
	print("----------------------------------");
	print(" Автором данного мода является Sanya161RU (Александр Рябов)");
	print(" Карта, а также скрипты, используемые сервером являются");
	print(" собственностью соответствующих владельцев");
	print(" ----------------------------------");
	print(" Сайт: pro100drift.ru");
	print(" Группа ВКонтакте: vk.com/pro100_drift");
	print("----------------------------------");
}

public OnGameModeInit()
{
	new inittemp[512];
	
	AntiDeAMX();
	
	SetGameModeText("Pro100Drift v8");
	SendRconCommand("hostname [RUN/ENG] Pro100Drift (0.3z)");
	SendRconCommand("mapname Russia");
	SendRconCommand("weburl www.vk.com/pro100.drift");
    SetTimer("ClockSync", 1000, 1); // Часы
	SetGravity(0.009);
	SetWeather(2);
	
	for(new m=1; m<300; m++)
	{
	    format(inittemp,sizeof(inittemp),GSYS_SKINPRV_PATH,m);
		gsys_skinpreview[m] = LoadModelSelectionMenu(inittemp);
	}
	
	bikeslist1 = LoadModelSelectionMenu("/data/list_vehicles_bikes1.txt");
	bikeslist2 = LoadModelSelectionMenu("/data/list_vehicles_bikes2.txt");
	vehlist = LoadModelSelectionMenu("/data/list_vehicles_all.txt");
	skinslist = LoadModelSelectionMenu("/data/list_skins.txt");
	sskinslist = LoadModelSelectionMenu("/data/list_skins.txt");
	militarylist = LoadModelSelectionMenu("/data/list_vehicles_military.txt");
	vwheels = LoadModelSelectionMenu("/data/list_vehicles_components_wheels.txt");
	weaponslist = LoadModelSelectionMenu("/data/list_weapons.txt");
	gskinslist = LoadModelSelectionMenu("/data/list_skins.txt");
	attachments = LoadModelSelectionMenu("/data/list_attachments.txt");
	
	for(new v=0; v<MAX_VEHICLES; v++) SetVehicleNumberPlate(v,"P100D");

	AllowAdminTeleport(1); // Разрешение на телепорт по клику
	AllowInteriorWeapons(1); // Оружие в интерьерах разрешено
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	UsePlayerPedAnims();
	
	/* ----------------------- 3D тексты ------------------------- */
	// Create3DTextLabel(text[], color, Float:X, Float:Y, Float:Z, Float:DrawDistance, virtualworld, testLOS)
	Create3DTextLabel("Велосипеды",0xFFFFFFFF,1877.7299,-1374.1520,13.5707,15.0,0,0);
	Create3DTextLabel("Велосипеды",0xFFFFFFFF,-1970.3802,411.0670,35.1719,15.0,0,0);
	Create3DTextLabel("Военная техника",0xFFFFFFFF,327.4213,1966.5920,17.6406,15.0,0,0);
	Create3DTextLabel("Мотоциклы",0xFFFFFFFF,-2121.7537,673.0947,83.3785,15.0,0,0);
	/* ----------------------- Пикапы ---------------------------- */
	pickup_spawnExit = CreatePickup(1318,23,1116.9735,-1779.6825,-96.2141,0);
	pickup_SParkVelo = CreatePickup(1559,23,1877.7299,-1374.1520,13.5707,0);
	pickup_BMXParkourVelo = CreatePickup(1559,23,-1970.3802,411.0670,35.1719,0);
	pickup_militaryVehicles = CreatePickup(1559,23,327.4213,1966.5920,17.6406,0);
	pickup_MTrialBikes = CreatePickup(1559,23,-2121.7537,673.0947,83.3785,0);
	/* ------------- Рекламные шиты (by Dima_Turkow) ------------ */
	new lspds = CreateObject(4238, 1538.5, -1609.8000488281, 26.0, 0.0000, 0.0000, 300.0,300.0);//
	new bb = CreateObject(7910, 1415.30004883, -1719.90002441 ,33.79999924, 0.00000000, 0.00000000,137.50000000,200);//
	new bbb = CreateObject(7910,1716.40002441,-782.20001221,73.59999847,0.00000000,0.00000000,346.24707031,200);//
	new bbbb = CreateObject(7910,1623.09997559,820.70001221,27.50000000,0.00000000,0.00000000,238.00000000,200);//
	new ss = CreateObject(4238,1786.50000000,1476.00000000,26.10000038,0.00000000,0.00000000,32.00000000,200);//
	new sss = CreateObject(4238,356.39999390,-1718.09997559,26.60000038,0.00000000,0.00000000,300.00000000,200);//
	new ssss = CreateObject(7910,1497.09997559,-945.00000000,54.09999847,0.00000000,0.00000000,112.99807739,200);//
	new dd = CreateObject(7910,1716.69995117,-778.29998779,73.59999847,0.00000000,0.00000000,180.75000000,200);//
	new ddd = CreateObject(7910,1777.50000000,888.00000000,29.89999962,0.00000000,0.00000000,127.74780273,200);//
	new dddd = CreateObject(7910,1854.59997559,-1487.69995117,25.79999924,0.00000000,0.00000000,180.00000000,200);//
	new aa = CreateObject(4238,1353.90002441,-1713.59997559,26.00000000,2.00000000,358.00000000,120.00000000,200);
	new aaa = CreateObject(4238,734.50000000,-1102.19995117,33.39999771,0.00000000,0.00000000,180.25000000,200);//
	new aaaa = CreateObject(7910,1242.90002441,1089.80004883,27.60000038,0.00000000,0.00000000,159.74511719,200);//
	new qq = CreateObject(7914,1415.50000000,-1719.69995117,34.00000000,0.00000000,0.00000000,137.96582031,200);//
	new qqq = CreateObject(7910,1408.90002441,-1408.09997559,33.59999847,0.00000000,0.00000000,262.25000000,200);//
	new qqqq = CreateObject(7910,1412.59997559,-1724.19995117,33.79999924,0.00000000,0.00000000,331.99938965,200);//
	new ww = CreateObject(7910,1863.50000000,-1450.69995117,31.70000076,0.00000000,0.00000000,38.24804688,200);//
	new www = CreateObject(7910,1629.69995117,-839.00000000,76.99998474,0.00000000,0.00000000,132.25000000,200);//
	new wwww = CreateObject(7909,219.80000305,-1434.30004883,31.00000000,0.00000000,0.00000000,0.25000000,200);//
	new ee = CreateObject(4238,704.00000000,-1115.59997559,32.20000076,0.00000000,0.00000000,5.00000000,200);//
	new eee = CreateObject(7910,1673.09997559,-711.09997559,69.00000000,0.00000000,0.00000000,187.50000000,200);//
	new eeee = CreateObject(7909,2066.80004883,-1790.30004883,28.00000000,0.00000000,0.00000000,90.50000000,200);//
	new rr = CreateObject(4238,1007.40002441,1314.59997559,30.79999924,0.00000000,0.00000000,29.25000000,200);//
	new rrr = CreateObject(7910,1240.90002441,1086.90002441,27.60000038,0.00000000,0.00000000,323.75000000,200);//
	new rrrr = CreateObject(7910,1493.59997559,-946.29998779,54.00000000,0.00000000,0.00000000,278.00000000,200);//
	new tt = CreateObject(4238,516.59997559,-1725.90002441,31.39999962,0.00000000,0.00000000,112.00000000,200);//
	new ttt = CreateObject(4238,1786.90002441,1075.90002441,26.80000114,0.00000000,0.00000000,31.25000000,200);//
	new tttt = CreateObject(4238,1805.09997559,-1691.50000000,30.79999924,0.00000000,0.00000000,175.25000000,200);//
	new yy = CreateObject(4238,597.70001221,-1744.40002441,33.20000076,0.00000000,0.00000000,290.00000000,200);//
	new yyy = CreateObject(7910,1775.00000000,885.29998779,29.90000153,0.00000000,0.00000000,324.00000000,200);//
	new yyyy = CreateObject(7909,1963.80004883,-1522.69995117,24.60000038,0.00000000,0.00000000,90.25000000,200);//
	new ff = CreateObject(7910,1628.69995117,-841.90002441,76.99998474,0.00000000,0.00000000,326.99792480,200);//
	new fff = CreateObject(7910,1861.59997559,-1448.00000000,31.70000076,0.00000000,0.00000000,233.00000000,200);//
	new ffff = CreateObject(4238,1565.30004883,-1722.50000000,31.19670486,0.00000000,0.00000000,34.75000000,200);//
	new gg = CreateObject(7910,1627.09997559,819.50000000,27.50000000,0.00000000,0.00000000,73.49682617,200);
	new ggg = CreateObject(7910,1673.50000000,-714.09997559,68.99996948,0.00000000,0.00000000,22.24816895,200);//

	SetObjectMaterialText(lspds,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(bb,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(bbb,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(bbbb,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(ss,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(sss,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(ssss,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(dd,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(ddd,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(dddd,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(aa,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(aaa,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(aaaa,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(qq,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(qqq,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(qqqq,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(ww,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(www,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(wwww,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(ee,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(eee,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(eeee,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(rr,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(rrr,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(rrrr,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(tt,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(ttt,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(tttt,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(yy,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(yyy,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(yyyy,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(rrrr,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(ff,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(fff,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(ffff,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(gg,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetObjectMaterialText(ggg,"Заказ рекламы:\nadmin@pro100drift.ru",0,OBJECT_MATERIAL_SIZE_256x128,"Arial",24,0, 0xFFFFFFFF,0xFF000000, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	/* ------------------- Карта --------------------------------- */
	// Спаун внутри здания недалеко от пляжа ЛС (Санта Мария)
	AddStaticVehicle(429,387.2999900,-1613.6000000,38.6000000,120.0000000,61,70); //Banshee
	AddStaticVehicle(411,387.0000000,-1624.9000000,38.7000000,48.0000000,75,63); //Infernus
	AddStaticVehicle(522,367.1000100,-1630.9000000,38.5000000,0.0000000,109,122); //NRG-500
	AddStaticVehicle(522,365.6000100,-1630.7000000,38.5000000,0.0000000,109,122); //NRG-500
	AddStaticVehicle(522,364.2000100,-1630.5000000,38.5000000,0.0000000,237,7); //NRG-500
	AddStaticVehicle(481,381.7999900,-1606.7000000,38.5000000,150.0000000,157,152); //BMX
	AddStaticVehicle(481,383.0000000,-1606.6000000,38.5000000,149.9960000,157,152); //BMX
	AddStaticVehicle(481,384.0000000,-1607.0000000,38.5000000,149.9960000,157,152); //BMX
	AddStaticVehicle(562,382.8999900,-1620.0000000,50.1000000,130.0000000,71,53); //Elegy
	AddStaticVehicle(429,376.0000000,-1615.2000000,50.0000000,180.0000000,245,245); //Banshee
	AddStaticVehicle(411,365.7000100,-1617.1000000,50.0000000,218.0000000,114,42); //Infernus
	AddStaticVehicle(573,358.8999900,-1620.9000000,50.4000000,218.0000000,14,49); //Duneride
	CreateDynamicObject(2290,345.6000100,-1605.3000000,37.8000000,0.0000000,0.0000000,0.0000000); //object(swk_couch_1) (1)
	CreateDynamicObject(2296,347.6000100,-1610.0000000,37.8000000,0.0000000,0.0000000,180.0000000); //object(tv_unit_1) (1)
	CreateDynamicObject(1597,373.4003900,-1619.9004000,40.5000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,373.1000100,-1629.7000000,40.5000000,0.0000000,0.0000000,356.0000000); //object(cntrlrsac1) (3)
	CreateDynamicObject(1597,373.2999900,-1610.6000000,40.5000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1) (4)
	CreateDynamicObject(3450,387.6000100,-1621.3000000,39.9000000,0.0000000,0.0000000,268.0000000); //object(vegashseplot1) (1)
	CreateDynamicObject(1360,345.0000000,-1612.8000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop3) (1)
	CreateDynamicObject(1360,345.6000100,-1619.4000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(cj_bush_prop3) (2)
	CreateDynamicObject(16151,358.7000100,-1606.3000000,37.8000000,0.0000000,0.0000000,90.0000000); //object(ufo_bar) (1)
	CreateDynamicObject(1512,366.0000000,-1605.2000000,40.9000000,0.0000000,0.0000000,0.0000000); //object(dyn_wine_03) (1)
	CreateDynamicObject(2635,359.3999900,-1610.3000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (1)
	CreateDynamicObject(2635,364.5000000,-1608.7000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (2)
	CreateDynamicObject(2635,369.8999900,-1607.7000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (3)
	CreateDynamicObject(2635,363.5000000,-1606.5000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (4)
	CreateDynamicObject(2635,367.1000100,-1606.7000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (5)
	CreateDynamicObject(2635,351.7999900,-1606.2000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (6)
	CreateDynamicObject(2635,354.3999900,-1611.5000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (7)
	CreateDynamicObject(2635,360.1000100,-1613.9000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (8)
	CreateDynamicObject(2635,363.1000100,-1612.1000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (9)
	CreateDynamicObject(2635,368.1000100,-1611.5000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_pizza_table) (10)
	CreateDynamicObject(2350,352.7000100,-1606.2000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (1)
	CreateDynamicObject(2350,350.8999900,-1606.2000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (2)
	CreateDynamicObject(2350,360.1000100,-1614.8000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (3)
	CreateDynamicObject(2350,363.2000100,-1613.1000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (4)
	CreateDynamicObject(2350,368.1000100,-1612.6000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (5)
	CreateDynamicObject(2350,364.5000000,-1609.8000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (6)
	CreateDynamicObject(2350,363.5000000,-1607.3000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (7)
	CreateDynamicObject(2350,367.1000100,-1607.5000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (8)
	CreateDynamicObject(2350,369.8999900,-1608.5000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (9)
	CreateDynamicObject(2350,370.0000000,-1606.7000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (10)
	CreateDynamicObject(2350,367.0000000,-1605.5000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (11)
	CreateDynamicObject(2350,363.5000000,-1605.7000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (12)
	CreateDynamicObject(2350,354.3999900,-1610.6000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (13)
	CreateDynamicObject(2350,354.3999900,-1612.3000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (14)
	CreateDynamicObject(2350,359.3999900,-1609.3000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (15)
	CreateDynamicObject(2350,359.5000000,-1611.2000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (16)
	CreateDynamicObject(2350,360.1000100,-1613.0000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (17)
	CreateDynamicObject(2350,363.1000100,-1611.1000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (18)
	CreateDynamicObject(2350,368.1000100,-1610.6000000,38.2000000,0.0000000,0.0000000,0.0000000); //object(cj_barstool_2) (19)
	CreateDynamicObject(955,352.7999900,-1630.0000000,37.8000000,0.0000000,0.0000000,160.0000000); //object(cj_ext_sprunk) (1)
	CreateDynamicObject(1209,354.7999900,-1630.1000000,37.8000000,0.0000000,0.0000000,160.0000000); //object(vendmach) (1)
	CreateDynamicObject(2221,351.7999900,-1606.1000000,38.7000000,0.0000000,0.0000000,0.0000000); //object(rustylow) (1)
	CreateDynamicObject(2222,354.3999900,-1611.5000000,38.7000000,0.0000000,0.0000000,0.0000000); //object(rustyhigh) (1)
	CreateDynamicObject(2768,359.3999900,-1610.2000000,38.7000000,0.0000000,0.0000000,0.0000000); //object(cj_cb_burg) (1)
	CreateDynamicObject(2840,360.0000000,-1613.9000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(gb_takeaway05) (1)
	CreateDynamicObject(1776,361.5000000,-1631.9000000,38.9000000,0.0000000,0.0000000,168.0000000); //object(cj_candyvendor) (1)
	CreateDynamicObject(1487,359.3999900,-1609.9000000,38.8000000,0.0000000,0.0000000,0.0000000); //object(dyn_wine_1) (1)
	CreateDynamicObject(1517,359.3999900,-1610.6000000,38.8000000,0.0000000,0.0000000,0.0000000); //object(dyn_wine_break) (1)
	CreateDynamicObject(1510,363.5000000,-1606.5000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(dyn_ashtry) (1)
	CreateDynamicObject(1520,363.5000000,-1606.2000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(dyn_wine_bounce) (1)
	CreateDynamicObject(1543,363.5000000,-1606.8000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(cj_beer_b_2) (1)
	CreateDynamicObject(1544,369.8999900,-1608.0000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(cj_beer_b_1) (1)
	CreateDynamicObject(1545,360.5000000,-1607.2000000,38.8000000,0.0000000,0.0000000,0.0000000); //object(cj_b_optic1) (1)
	CreateDynamicObject(1665,363.1000100,-1612.2000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(propashtray1) (1)
	CreateDynamicObject(2342,363.2000100,-1612.1000000,38.7000000,0.0000000,0.0000000,0.0000000); //object(donut_disp) (1)
	CreateDynamicObject(2769,363.3999900,-1611.9000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(cj_cj_burg2) (1)
	CreateDynamicObject(2814,364.6000100,-1608.7000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(gb_takeaway01) (1)
	CreateDynamicObject(2823,368.1000100,-1611.5000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(gb_kitchtakeway01) (1)
	CreateDynamicObject(2838,367.2000100,-1606.9000000,38.6000000,0.0000000,0.0000000,0.0000000); //object(gb_takeaway03) (1)
	CreateDynamicObject(14582,359.7000100,-1620.9000000,41.3000000,0.0000000,0.0000000,0.0000000); //object(mafiacasinobar1) (1)
	CreateDynamicObject(2890,367.6000100,-1640.8000000,49.2000000,0.0000000,0.0000000,178.0000000); //object(kmb_skip) (1)
	CreateDynamicObject(1597,399.0000000,-1626.2000000,51.9000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,398.8999900,-1614.4000000,51.9000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,394.7999900,-1606.7000000,51.9000000,0.0000000,0.0000000,270.0000000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,384.6000100,-1606.6000000,51.9000000,0.0000000,0.0000000,270.0000000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,374.1000100,-1606.3000000,51.9000000,0.0000000,0.0000000,270.0000000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,363.6000100,-1605.9000000,51.9000000,0.0000000,0.0000000,270.0000000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,352.2999900,-1605.8000000,51.9000000,0.0000000,0.0000000,270.0000000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,345.8999900,-1610.1000000,51.9000000,0.0000000,0.0000000,180.0000000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,345.5000000,-1620.1000000,51.9000000,0.0000000,0.0000000,179.9950000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,351.2000100,-1625.8000000,51.9000000,0.0000000,0.0000000,231.9950000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,346.7999900,-1624.0000000,51.9000000,0.0000000,0.0000000,269.9950000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,356.3999900,-1629.3000000,51.9000000,0.0000000,0.0000000,221.9950000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,360.7000100,-1634.3000000,51.9000000,0.0000000,0.0000000,89.9950000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,376.0000000,-1636.6000000,51.9000000,0.0000000,0.0000000,89.9950000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,382.3999900,-1636.7000000,51.9000000,0.0000000,0.0000000,89.9950000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,389.2999900,-1633.6000000,51.9000000,0.0000000,0.0000000,139.9950000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1597,395.1000100,-1630.3000000,51.9000000,0.0000000,0.0000000,89.9930000); //object(cntrlrsac1) (2)
	CreateDynamicObject(1736,345.2000100,-1604.6000000,40.1000000,0.0000000,0.0000000,0.0000000); //object(cj_stags_head) (1)
	CreateDynamicObject(1736,346.5000000,-1604.6000000,40.1000000,0.0000000,0.0000000,0.0000000); //object(cj_stags_head) (2)
	CreateDynamicObject(1736,347.7999900,-1604.7000000,40.1000000,0.0000000,0.0000000,0.0000000); //object(cj_stags_head) (3)
	// Мото-триал
	CreateDynamicObject(18783,-2108.6579590,671.4400024,79.7860031,0.0000000,0.0000000,0.0000000); //object(funboxtop1) (1)
	CreateDynamicObject(18783,-2119.1806641,671.3447266,79.7860031,0.0000000,0.0000000,0.0000000); //object(funboxtop1) (2)
	CreateDynamicObject(3578,-2128.8278809,672.6489868,83.0569992,0.0000000,0.0000000,270.2500000); //object(dockbarr1_la) (2)
	CreateDynamicObject(3578,-2128.7998047,666.9101562,83.0569992,0.0000000,0.0000000,270.2471924); //object(dockbarr1_la) (3)
	CreateDynamicObject(3578,-2123.4101562,662.0136719,83.0569992,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (4)
	CreateDynamicObject(3578,-2113.1840820,662.0109863,83.0569992,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (5)
	CreateDynamicObject(3578,-2104.0859375,662.0079956,83.0569992,0.0000000,0.0000000,0.0000000); //object(dockbarr1_la) (6)
	CreateDynamicObject(3578,-2099.1970215,666.9550171,83.0569992,0.0000000,0.0000000,270.2471924); //object(dockbarr1_la) (7)
	CreateDynamicObject(3578,-2099.2070312,677.2031250,83.0569992,0.0000000,0.0000000,270.2471924); //object(dockbarr1_la) (8)
	CreateDynamicObject(2669,-2126.5319824,674.0949707,83.5189972,0.0000000,0.0000000,0.0000000); //object(cj_chris_crate) (1)
	CreateDynamicObject(3570,-2103.7009277,664.1309814,83.7259979,0.0000000,0.0000000,0.0000000); //object(lasdkrt2) (1)
	CreateDynamicObject(3571,-2100.9619141,673.7349854,83.7259979,0.0000000,0.0000000,270.0000000); //object(lasdkrt3) (1)
	CreateDynamicObject(3572,-2106.3439941,676.4940186,83.7259979,0.0000000,0.0000000,0.0000000); //object(lasdkrt4) (1)
	CreateDynamicObject(3572,-2114.3959961,676.5510254,83.7259979,0.0000000,0.0000000,0.0000000); //object(lasdkrt4) (2)
	CreateDynamicObject(3571,-2114.4108887,676.5250244,86.4229965,0.0000000,0.0000000,0.0000000); //object(lasdkrt3) (3)
	CreateDynamicObject(5153,-2100.9528809,667.5620117,84.9270020,0.2292480,23.5001831,91.9002991); //object(stuntramp7_las2) (1)
	CreateDynamicObject(2931,-2109.9089355,676.4119873,85.0749969,0.0000000,0.0000000,88.0000000); //object(kmb_jump1) (1)
	CreateDynamicObject(3571,-2114.4050293,673.9140015,83.8229980,0.0000000,0.0000000,0.2500000); //object(lasdkrt3) (4)
	CreateDynamicObject(3570,-2114.4550781,673.9019775,86.4509964,0.0000000,0.0000000,0.0000000); //object(lasdkrt2) (4)
	CreateDynamicObject(5153,-2117.0939941,677.6589966,89.0709991,0.0000000,0.0000000,90.0000000); //object(stuntramp7_las2) (2)
	CreateDynamicObject(5153,-2117.1059570,676.4819946,88.5709991,0.0000000,0.0000000,90.0000000); //object(stuntramp7_las2) (3)
	CreateDynamicObject(2931,-2108.2661133,664.1049805,82.3779984,0.0000000,0.0000000,270.0000000); //object(kmb_jump1) (2)
	CreateDynamicObject(1696,-2117.5722656,690.7988281,90.1890030,0.0000000,0.0000000,0.0000000); //object(roofstuff15) (1)
	CreateDynamicObject(3502,-2115.3369141,724.8179932,90.5970001,0.0000000,0.0000000,0.0000000); //object(vgsn_con_tube) (1)
	CreateDynamicObject(3502,-2115.3249512,733.4639893,90.5970001,0.0000000,0.0000000,0.0000000); //object(vgsn_con_tube) (2)
	CreateDynamicObject(3502,-2115.3220215,742.2210083,90.5970001,0.0000000,0.0000000,0.0000000); //object(vgsn_con_tube) (3)
	CreateDynamicObject(3502,-2115.3190918,751.0239868,89.3970032,344.0000000,0.0000000,0.0000000); //object(vgsn_con_tube) (4)
	CreateDynamicObject(1633,-2114.8510742,792.3239746,86.8160019,0.0000000,0.0000000,0.0000000); //object(landjump) (1)
	CreateDynamicObject(18367,-2159.2871094,835.5089722,83.8870010,3.5000000,0.0000000,94.0000000); //object(cw2_bikelog) (1)
	CreateDynamicObject(3570,-2164.9890137,853.1660156,85.9729996,0.0000000,0.0000000,0.0000000); //object(lasdkrt2) (2)
	CreateDynamicObject(3571,-2164.9790039,850.6190186,85.9729996,0.0000000,0.0000000,0.0000000); //object(lasdkrt3) (2)
	CreateDynamicObject(3572,-2164.9838867,848.0250244,85.9729996,0.0000000,0.0000000,0.0000000); //object(lasdkrt4) (3)
	CreateDynamicObject(3570,-2165.0239258,845.3920288,85.9729996,0.0000000,0.0000000,0.0000000); //object(lasdkrt2) (3)
	CreateDynamicObject(3571,-2165.0000000,842.8120117,85.9729996,0.0000000,0.0000000,0.0000000); //object(lasdkrt3) (5)
	CreateDynamicObject(3572,-2164.9570312,848.0159912,88.5479965,0.0000000,0.0000000,0.0000000); //object(lasdkrt4) (4)
	CreateDynamicObject(3570,-2164.9189453,850.5930176,88.5479965,0.0000000,0.0000000,0.0000000); //object(lasdkrt2) (5)
	CreateDynamicObject(3571,-2164.9729004,853.1690063,88.5979996,0.0000000,0.0000000,0.0000000); //object(lasdkrt3) (6)
	CreateDynamicObject(3571,-2164.9589844,845.4130249,88.5479965,0.0000000,0.0000000,0.0000000); //object(lasdkrt3) (7)
	CreateDynamicObject(3571,-2164.7060547,853.2550049,91.1729965,0.0000000,0.0000000,89.2500000); //object(lasdkrt3) (8)
	CreateDynamicObject(13593,-2164.6110840,838.7100220,85.3679962,0.0000000,0.0000000,0.0000000); //object(kickramp03) (5)
	CreateDynamicObject(13593,-2164.6440430,840.1599731,85.6179962,34.0000000,0.0000000,0.0000000); //object(kickramp03) (6)
	CreateDynamicObject(5153,-2164.7990723,847.4260254,91.0210037,1.9467468,346.7422180,88.4585876); //object(stuntramp7_las2) (7)
	CreateDynamicObject(5153,-2164.6289062,853.3099976,93.5210037,1.9445801,346.7395020,88.4564209); //object(stuntramp7_las2) (8)
	CreateDynamicObject(5153,-2165.7170410,876.7249756,95.2710037,1.9445801,346.7395020,88.4564209); //object(stuntramp7_las2) (9)
	CreateDynamicObject(13648,-2252.7958984,891.4130859,95.9240036,0.0000000,0.0000000,90.0000000); //object(wall2) (1)
	CreateDynamicObject(13648,-2259.6894531,891.3593750,95.6740036,0.0000000,0.0000000,270.9997559); //object(wall2) (2)
	CreateDynamicObject(1395,-2288.0161133,936.4710083,93.7529984,82.7503662,0.0000000,182.0000000); //object(twrcrane_l_03) (1)
	CreateDynamicObject(1634,-2290.7399902,1077.8149414,101.2710037,0.0000000,0.0000000,0.0000000); //object(landjump2) (1)
	CreateDynamicObject(1634,-2290.7590332,1081.5909424,103.4209976,26.0000000,0.0000000,0.0000000); //object(landjump2) (2)
	CreateDynamicObject(979,-2283.2666016,1068.6748047,100.7399979,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(978,-2125.1030273,685.0280151,90.0220032,0.0000000,0.0000000,270.0000000); //object(sub_roadright) (2)
	CreateDynamicObject(978,-2124.5080566,710.6110229,90.0220032,0.0000000,0.0000000,270.0000000); //object(sub_roadright) (3)
	CreateDynamicObject(978,-2121.5749512,784.0880127,86.5220032,0.0000000,0.0000000,270.0000000); //object(sub_roadright) (6)
	CreateDynamicObject(978,-2126.4929199,826.1469727,86.6969986,0.0000000,0.0000000,288.0000000); //object(sub_roadright) (7)
	CreateDynamicObject(978,-2121.9838867,771.5549927,86.5220032,0.0000000,0.0000000,270.0000000); //object(sub_roadright) (8)
	CreateDynamicObject(978,-2122.8120117,757.5289917,86.5220032,0.0000000,0.0000000,270.0000000); //object(sub_roadright) (9)
	CreateDynamicObject(978,-2168.4550781,825.2548828,85.4649963,0.0000000,0.0000000,287.9901123); //object(sub_roadright) (10)
	CreateDynamicObject(978,-2169.1979980,834.3870239,85.4649963,0.0000000,0.0000000,257.9956055); //object(sub_roadright) (11)
	CreateDynamicObject(978,-2162.5061035,821.7139893,85.4649963,0.0000000,0.0000000,3.9956055); //object(sub_roadright) (12)
	CreateDynamicObject(978,-2169.4389648,860.1279907,95.3850021,0.0000000,0.0000000,273.9919434); //object(sub_roadright) (13)
	CreateDynamicObject(978,-2169.9169922,870.8790283,95.3850021,0.0000000,0.0000000,265.9880371); //object(sub_roadright) (14)
	CreateDynamicObject(978,-2176.2199707,882.3549805,96.6350021,0.0000000,0.0000000,359.9844971); //object(sub_roadright) (15)
	CreateDynamicObject(978,-2189.6040039,882.6959839,96.6350021,0.0000000,0.0000000,359.9835205); //object(sub_roadright) (16)
	CreateDynamicObject(978,-2202.1608887,882.3270264,96.6350021,0.0000000,0.0000000,359.9835205); //object(sub_roadright) (17)
	CreateDynamicObject(978,-2212.9570312,881.7940063,96.6350021,0.0000000,0.0000000,359.9835205); //object(sub_roadright) (18)
	CreateDynamicObject(978,-2225.5668945,881.6699829,96.6350021,0.0000000,0.0000000,359.9835205); //object(sub_roadright) (19)
	CreateDynamicObject(978,-2281.1530762,886.0850220,96.6350021,0.0000000,0.0000000,359.9835205); //object(sub_roadright) (20)
	CreateDynamicObject(978,-2292.4619141,888.1669922,96.6350021,0.0000000,0.0000000,323.9835205); //object(sub_roadright) (21)
	CreateDynamicObject(978,-2296.6579590,896.6729736,96.6350021,0.0000000,0.0000000,269.9813232); //object(sub_roadright) (22)
	CreateDynamicObject(978,-2296.7958984,921.0070190,96.6350021,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (23)
	CreateDynamicObject(978,-2296.8029785,938.2030029,96.6350021,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (24)
	CreateDynamicObject(978,-2297.5419922,993.1140137,100.6350021,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (25)
	CreateDynamicObject(978,-2297.6799316,1014.5579834,100.6350021,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (26)
	CreateDynamicObject(978,-2297.3491211,1038.4990234,100.6350021,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (27)
	CreateDynamicObject(978,-2297.7770996,1056.6250000,100.6350021,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (28)
	CreateDynamicObject(978,-2297.4890137,1068.5649414,100.6350021,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (29)
	CreateDynamicObject(979,-2282.7871094,1055.0859375,100.7399979,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (2)
	CreateDynamicObject(979,-2282.6899414,1038.0749512,100.7399979,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (3)
	CreateDynamicObject(979,-2282.3859863,1014.5989990,100.7399979,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (4)
	CreateDynamicObject(979,-2282.8029785,993.0759888,100.7399979,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (5)
	CreateDynamicObject(979,-2283.8059082,938.4840088,96.4899979,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (6)
	CreateDynamicObject(979,-2285.3879395,920.4190063,96.4899979,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (7)
	CreateDynamicObject(979,-2283.4719238,902.1500244,96.4400024,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (8)
	CreateDynamicObject(979,-2226.4838867,900.5499878,96.7399979,0.0000000,0.0000000,174.0000000); //object(sub_roadleft) (9)
	CreateDynamicObject(979,-2212.5759277,901.1250000,96.7399979,0.0000000,0.0000000,173.9959717); //object(sub_roadleft) (10)
	CreateDynamicObject(979,-2201.0869141,901.5999756,96.7399979,0.0000000,0.0000000,173.9959717); //object(sub_roadleft) (11)
	CreateDynamicObject(979,-2189.8959961,901.3120117,96.7399979,0.0000000,0.0000000,173.9959717); //object(sub_roadleft) (12)
	CreateDynamicObject(979,-2175.3278809,900.6619873,96.7399979,0.0000000,0.0000000,173.9959717); //object(sub_roadleft) (13)
	CreateDynamicObject(979,-2163.8149414,897.3569946,96.7399979,0.0000000,0.0000000,149.9959717); //object(sub_roadleft) (14)
	CreateDynamicObject(979,-2158.7790527,886.1939697,96.7399979,0.0000000,0.0000000,99.9908447); //object(sub_roadleft) (15)
	CreateDynamicObject(979,-2159.7739258,872.2780151,95.0400009,0.0000000,0.0000000,85.9865723); //object(sub_roadleft) (16)
	CreateDynamicObject(979,-2159.7160645,861.2319946,95.0400009,0.0000000,0.0000000,91.9844971); //object(sub_roadleft) (17)
	CreateDynamicObject(979,-2108.6259766,831.0679932,86.1900024,0.0000000,0.0000000,95.9830322); //object(sub_roadleft) (18)
	CreateDynamicObject(979,-2113.1870117,839.5469971,86.1900024,0.0000000,0.0000000,137.9820557); //object(sub_roadleft) (19)
	CreateDynamicObject(979,-2121.5700684,842.3430176,86.1900024,0.0000000,0.0000000,197.9772949); //object(sub_roadleft) (20)
	CreateDynamicObject(979,-2107.3920898,783.6530151,86.4400024,0.0000000,0.0000000,91.9736328); //object(sub_roadleft) (21)
	CreateDynamicObject(979,-2106.4589844,771.8189697,86.4400024,0.0000000,0.0000000,91.9720459); //object(sub_roadleft) (22)
	CreateDynamicObject(979,-2107.2509766,760.4260254,86.4400024,0.0000000,0.0000000,85.9720459); //object(sub_roadleft) (23)
	CreateDynamicObject(979,-2110.2590332,709.9530029,89.6900024,0.0000000,0.0000000,85.9680176); //object(sub_roadleft) (24)
	CreateDynamicObject(979,-2108.2119141,685.3010254,89.6900024,0.0000000,0.0000000,85.9680176); //object(sub_roadleft) (25)
	CreateDynamicObject(16644,-2276.3779297,1165.4560547,94.4680023,0.0000000,0.0000000,42.0000000); //object(a51_ventsouth) (1)
	CreateDynamicObject(16644,-2263.4960938,1176.9589844,94.4680023,0.0000000,0.0000000,41.9952393); //object(a51_ventsouth) (2)
	CreateDynamicObject(1503,-2257.4179688,1181.7340088,94.7659988,0.0000000,0.0000000,312.0000000); //object(dyn_ramp) (4)
	CreateDynamicObject(7515,-2221.1789551,1218.2290039,92.2030029,0.0000000,0.0000000,90.0000000); //object(vegasnfrates1) (1)
	CreateDynamicObject(7516,-2221.1799316,1213.2609863,98.1510010,0.0000000,0.0000000,0.0000000); //object(vegasnfrates02) (1)
	CreateDynamicObject(8077,-2221.0559082,1220.7509766,106.1589966,0.0000000,0.0000000,90.0000000); //object(vgsfrates06) (1)
	CreateDynamicObject(8077,-2221.1940918,1200.8549805,102.2340012,0.0000000,0.0000000,270.0000000); //object(vgsfrates06) (2)
	CreateDynamicObject(8077,-2221.1608887,1210.8050537,102.2340012,0.0000000,0.0000000,270.0000000); //object(vgsfrates06) (3)
	CreateDynamicObject(3574,-2192.0126953,1248.5664062,88.9029999,0.0000000,0.0000000,0.0000000); //object(lasdkrtgrp2) (1)
	CreateDynamicObject(3574,-2192.0458984,1240.4799805,88.9029999,0.0000000,0.0000000,0.0000000); //object(lasdkrtgrp2) (2)
	CreateDynamicObject(3573,-2193.4741211,1231.0510254,88.9029999,0.0000000,0.0000000,0.0000000); //object(lasdkrtgrp1) (1)
	CreateDynamicObject(3573,-2193.4189453,1223.0429688,88.9029999,0.0000000,0.0000000,180.0000000); //object(lasdkrtgrp1) (2)
	CreateDynamicObject(3574,-2192.1569824,1213.8100586,88.9029999,0.0000000,0.0000000,0.0000000); //object(lasdkrtgrp2) (4)
	CreateDynamicObject(3574,-2192.4689941,1205.8780518,88.9029999,0.0000000,0.0000000,180.0000000); //object(lasdkrtgrp2) (5)
	CreateDynamicObject(3575,-2196.5410156,1200.4609375,88.9029999,0.0000000,0.0000000,0.0000000); //object(lasdkrt05) (3)
	CreateDynamicObject(1633,-2206.3059082,1193.9320068,87.5110016,0.0000000,0.0000000,176.0000000); //object(landjump) (2)
	CreateDynamicObject(1633,-2206.6420898,1189.7900391,89.2610016,24.0000000,0.0000000,175.9954834); //object(landjump) (3)
	CreateDynamicObject(978,-2296.9980469,1112.1030273,110.5149994,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (30)
	CreateDynamicObject(978,-2296.5219727,1131.8060303,102.9150009,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (31)
	CreateDynamicObject(978,-2297.0639648,1150.2480469,95.1900024,0.0000000,0.0000000,269.9780273); //object(sub_roadright) (32)
	CreateDynamicObject(978,-2293.6259766,1158.4270020,95.1900024,0.0000000,0.0000000,219.9780426); //object(sub_roadright) (33)
	CreateDynamicObject(978,-2288.1425781,1161.0986328,95.1900024,0.0000000,0.0000000,183.9715576); //object(sub_roadright) (34)
	CreateDynamicObject(13648,-2252.8469238,895.0620117,95.9240036,0.0000000,0.0000000,90.0000000); //object(wall2) (1)
	CreateDynamicObject(13648,-2252.7770996,888.0369873,95.9240036,0.0000000,0.0000000,90.0000000); //object(wall2) (1)
	CreateDynamicObject(13648,-2260.0910645,887.9580078,95.6740036,0.0000000,0.0000000,270.2497559); //object(wall2) (2)
	CreateDynamicObject(13648,-2260.0170898,895.1320190,95.6740036,0.0000000,0.0000000,270.2471924); //object(wall2) (2)
	CreateDynamicObject(979,-2283.9980469,1113.3509521,110.6100006,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2282.5529785,1131.1099854,103.0250015,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2281.2236328,1148.9003906,95.3150024,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2231.1508789,1200.9000244,95.3150024,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2231.1621094,1213.9499512,95.3150024,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2231.1740723,1226.1490479,95.3150024,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2231.1831055,1238.3580322,92.5650024,0.0000000,0.0000000,90.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(978,-2238.2949219,1253.1870117,87.0510025,0.0000000,0.0000000,183.9715424); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2220.6359863,1253.4410400,87.0510025,0.0000000,0.0000000,179.9715576); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2203.5319824,1249.6719971,87.0510025,0.0000000,0.0000000,115.9670410); //object(sub_roadright) (34)
	CreateDynamicObject(5153,-2229.8869629,1130.8229980,94.2710037,0.0000000,341.9959717,270.0000000); //object(stuntramp7_las2) (4)
	CreateDynamicObject(3574,-2228.4431152,1123.9499512,95.7630005,0.0000000,0.0000000,0.0000000); //object(lasdkrtgrp2) (1)
	CreateDynamicObject(3573,-2226.9140625,1115.5644531,98.6600037,0.0000000,0.0000000,0.0000000); //object(lasdkrtgrp1) (3)
	CreateDynamicObject(5153,-2229.8310547,1121.4909668,97.2460022,0.0000000,349.7459717,270.0000000); //object(stuntramp7_las2) (5)
	CreateDynamicObject(3578,-2229.5239258,1106.4709473,97.8550034,0.0000000,0.0000000,270.0000000); //object(dockbarr1_la) (1)
	CreateDynamicObject(3578,-2229.5839844,1096.2209473,97.8550034,0.0000000,0.0000000,270.0000000); //object(dockbarr1_la) (9)
	CreateDynamicObject(3578,-2229.5930176,1086.2209473,97.8550034,0.0000000,0.0000000,270.0000000); //object(dockbarr1_la) (10)
	CreateDynamicObject(3578,-2229.6330566,1084.3199463,97.8550034,0.0000000,0.0000000,270.0000000); //object(dockbarr1_la) (11)
	CreateDynamicObject(978,-2198.4350586,1153.3669434,93.9700012,0.0000000,0.0000000,79.9670410); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2204.0239258,1142.7919922,93.9700012,0.0000000,0.0000000,47.9639893); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2213.3769531,1133.5620117,93.9700012,0.0000000,0.0000000,47.9608154); //object(sub_roadright) (34)
	CreateDynamicObject(979,-2236.5539551,1156.8800049,93.9179993,0.0000000,0.0000000,260.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2236.4309082,1137.0290527,93.9179993,0.0000000,0.0000000,271.9969482); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2238.0148926,1073.6800537,97.9420013,0.0000000,0.0000000,271.9940186); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2229.5371094,1063.4449463,97.9420013,0.0000000,0.0000000,353.9940186); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2214.6450195,1061.2910156,96.6419983,0.0000000,0.0000000,353.9904785); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2196.7109375,1059.7969971,96.6419983,0.0000000,0.0000000,359.9904785); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2181.4760742,1060.2530518,96.6419983,0.0000000,0.0000000,359.9890137); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2168.3027344,1058.7968750,96.6419983,0.0000000,0.0000000,359.9835205); //object(sub_roadleft) (1)
	CreateDynamicObject(978,-2213.8100586,1077.7010498,96.7779999,0.0000000,0.0000000,179.9608154); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2200.5249023,1077.0799561,96.7779999,0.0000000,0.0000000,177.9575195); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2183.7338867,1077.5839844,96.7779999,0.0000000,0.0000000,181.9575195); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2165.0000000,1076.7656250,96.7779999,0.0000000,0.0000000,171.9525146); //object(sub_roadright) (34)
	CreateDynamicObject(1633,-2162.9460449,1070.2590332,96.7570038,4.5000000,0.0000000,268.0000000); //object(landjump) (4)
	CreateDynamicObject(3572,-2117.7028809,1061.3509521,97.2929993,0.0000000,0.0000000,0.0000000); //object(lasdkrt4) (5)
	CreateDynamicObject(3571,-2114.9379883,1066.3549805,97.2929993,0.0000000,0.0000000,270.0000000); //object(lasdkrt3) (9)
	CreateDynamicObject(3571,-2114.9289551,1074.4090576,97.2929993,0.0000000,0.0000000,270.0000000); //object(lasdkrt3) (10)
	CreateDynamicObject(3571,-2114.8701172,1082.4300537,97.2929993,0.0000000,0.0000000,270.0000000); //object(lasdkrt3) (11)
	CreateDynamicObject(1503,-2115.3579102,1088.6359863,96.3199997,0.0000000,0.0000000,180.0000000); //object(dyn_ramp) (1)
	CreateDynamicObject(3572,-2114.8740234,1077.1390381,99.8929977,0.0000000,0.0000000,270.0000000); //object(lasdkrt4) (6)
	CreateDynamicObject(5153,-2114.8601074,1082.8570557,99.8379974,1.2226868,347.9971924,270.2599487); //object(stuntramp7_las2) (6)
	CreateDynamicObject(3571,-2114.8820801,1069.0369873,99.9179993,0.0000000,0.0000000,270.0000000); //object(lasdkrt3) (12)
	CreateDynamicObject(3571,-2114.8850098,1063.0209961,99.9929962,0.0000000,0.0000000,270.0000000); //object(lasdkrt3) (13)
	CreateDynamicObject(3571,-2114.8535156,1071.7636719,102.5680008,0.0000000,0.0000000,270.0000000); //object(lasdkrt3) (14)
	CreateDynamicObject(3572,-2114.8889160,1063.7700195,102.5899963,0.0000000,0.0000000,270.0000000); //object(lasdkrt4) (7)
	CreateDynamicObject(5153,-2114.8540039,1077.5959473,102.4629974,1.2194824,347.9919434,270.2581787); //object(stuntramp7_las2) (10)
	CreateDynamicObject(3572,-2114.8879395,1063.7709961,105.2149963,0.0000000,0.0000000,270.0000000); //object(lasdkrt4) (8)
	CreateDynamicObject(2931,-2114.8149414,1068.4589844,103.7919998,0.0000000,0.0000000,178.0000000); //object(kmb_jump1) (3)
	CreateDynamicObject(2931,-2115.0720215,1060.4560547,106.5419998,0.0000000,0.0000000,177.9949951); //object(kmb_jump1) (4)
	CreateDynamicObject(978,-2121.9013672,1095.5312500,96.6110001,0.0000000,0.0000000,171.9470215); //object(sub_roadright) (34)
	CreateDynamicObject(979,-2116.1826172,1069.9404297,100.0360031,0.0000000,0.0000000,89.9835205); //object(sub_roadleft) (1)
	CreateDynamicObject(5005,-2182.5290527,975.6400146,85.8779984,358.0594482,14.0082092,222.4840698); //object(lasrunwall1_las) (3)
	CreateDynamicObject(978,-2114.2700195,1052.4899902,107.8040009,0.0000000,0.0000000,89.9470215); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2114.4279785,1038.4499512,107.8040009,0.0000000,0.0000000,89.9450684); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2119.0869141,1026.4119873,107.8040009,0.0000000,0.0000000,23.9450684); //object(sub_roadright) (34)
	CreateDynamicObject(979,-2124.5490723,1054.2349854,108.0039978,0.0000000,0.0000000,251.9835205); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2126.2661133,1039.4749756,108.0039978,0.0000000,0.0000000,269.9824219); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2164.7849121,1001.4180298,96.9649963,0.0000000,0.0000000,215.9780273); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2170.9560547,991.7329712,96.9649963,0.0000000,0.0000000,257.9747314); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2171.6379395,973.3480225,96.8399963,0.0000000,0.0000000,269.9699707); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2176.3549805,945.9869995,96.8399963,0.0000000,0.0000000,283.9670410); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2167.1721191,936.1119995,96.8399963,0.0000000,0.0000000,359.9636230); //object(sub_roadleft) (1)
	CreateDynamicObject(13638,-2152.4489746,936.4199829,98.1949997,0.0000000,0.0000000,182.0000000); //object(stunt1) (1)
	CreateDynamicObject(13638,-2131.8969727,933.9160156,97.9199982,0.0000000,0.0000000,89.9995117); //object(stunt1) (2)
	CreateDynamicObject(3502,-2143.4799805,930.9160156,105.3949966,0.0000000,0.0000000,270.0000000); //object(vgsn_con_tube) (5)
	CreateDynamicObject(3529,-2117.8989258,928.9760132,97.2020035,52.0000000,0.0000000,0.0000000); //object(vgsn_constrbeam) (1)
	CreateDynamicObject(3529,-2117.9431152,923.5960083,99.5270004,280.0000000,180.0000000,180.0000000); //object(vgsn_constrbeam) (2)
	CreateDynamicObject(3529,-2117.9460449,917.5510254,99.5270004,279.9975586,179.9945068,359.9945068); //object(vgsn_constrbeam) (3)
	CreateDynamicObject(3529,-2117.7399902,911.5939941,99.5270004,285.9920654,179.9965820,177.9910889); //object(vgsn_constrbeam) (4)
	CreateDynamicObject(3529,-2117.9599609,905.6799927,100.0520020,83.9906006,179.9855957,178.0092163); //object(vgsn_constrbeam) (6)
	CreateDynamicObject(16073,-2086.6760254,894.2620239,92.2200012,0.0000000,0.0000000,49.9987793); //object(des_quarrybelt03) (3)
	CreateDynamicObject(3865,-2067.6269531,894.2490234,91.8300018,0.0000000,0.0000000,271.9995117); //object(concpipe_sfxrf) (2)
	CreateDynamicObject(3865,-2059.3430176,894.4559937,90.5299988,344.0000000,0.0000000,271.9995117); //object(concpipe_sfxrf) (4)
	CreateDynamicObject(3865,-2050.6079102,894.6820068,88.0299988,343.9984131,0.0000000,271.9995117); //object(concpipe_sfxrf) (5)
	CreateDynamicObject(3865,-2041.9050293,894.9069824,85.5299988,343.9984131,0.0000000,271.9995117); //object(concpipe_sfxrf) (6)
	CreateDynamicObject(3865,-2034.7629395,892.9299927,83.2549973,343.9984131,0.0000000,241.9994965); //object(concpipe_sfxrf) (7)
	CreateDynamicObject(3865,-2029.0699463,887.4370117,80.8300018,343.9929199,0.0000000,211.9958496); //object(concpipe_sfxrf) (8)
	CreateDynamicObject(3865,-2026.8160400,879.7360229,78.4300003,343.9929199,0.0000000,181.9921875); //object(concpipe_sfxrf) (9)
	CreateDynamicObject(3675,-2026.5689697,869.3909912,74.9530029,271.9999695,0.0000000,180.0000000); //object(laxrf_refinerypipe) (1)
	CreateDynamicObject(979,-2127.6789551,895.3870239,97.6610031,0.0000000,0.0000000,279.9615479); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2119.7080078,886.7369995,97.6610031,0.0000000,0.0000000,349.9591064); //object(sub_roadleft) (1)
	CreateDynamicObject(979,-2100.5339355,885.8779907,92.8109970,0.0000000,0.0000000,3.9584961); //object(sub_roadleft) (1)
	CreateDynamicObject(978,-2160.0380859,987.5670166,96.9660034,0.0000000,0.0000000,89.9450684); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2160.2180176,972.2869873,96.9660034,0.0000000,0.0000000,89.9450684); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2160.4770508,950.3369751,96.9660034,0.0000000,0.0000000,89.9450684); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2121.0668945,948.3189697,96.9660034,0.0000000,0.0000000,161.9450684); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2112.8459473,938.1019897,96.9660034,0.0000000,0.0000000,97.9439697); //object(sub_roadright) (34)
	CreateDynamicObject(978,-2112.5471191,901.0930176,97.4660034,0.0000000,0.0000000,117.9431152); //object(sub_roadright) (34)
	CreateDynamicObject(18769,-2029.0539551,836.4669800,75.2630005,0.0000000,0.0000000,0.0000000); //object(skydiveplatform1a) (1)
	CreateDynamicObject(18769,-2028.9560547,821.9619751,75.2630005,0.0000000,0.0000000,0.0000000); //object(skydiveplatform1a) (2)
	CreateDynamicObject(19002,-2029.0360107,813.0180054,84.9349976,0.0000000,0.0000000,1.9995117); //object(firehoop1) (2)
	CreateDynamicObject(19002,-2028.8020020,820.7620239,82.4349976,0.0000000,0.0000000,1.9995117); //object(firehoop1) (3)
	CreateDynamicObject(1634,-2028.6159668,826.1550293,77.3290024,0.0000000,0.0000000,182.0000000); //object(landjump2) (3)
	CreateDynamicObject(3675,-2025.9179688,869.4069824,74.9530029,271.9994812,0.0000000,179.9945068); //object(laxrf_refinerypipe) (2)
	CreateDynamicObject(3675,-2027.2419434,869.3720093,74.9530029,271.9995117,0.0000000,179.9945068); //object(laxrf_refinerypipe) (3)
	CreateDynamicObject(1634,-2026.9289551,749.6519775,68.4540024,0.0000000,0.0000000,197.9995117); //object(landjump2) (4)
	CreateDynamicObject(979,-2032.6180420,858.1259766,76.8720016,0.0000000,0.0000000,269.9550781); //object(sub_roadleft) (1)
	CreateDynamicObject(978,-2019.7860107,856.8569946,76.8720016,0.0000000,0.0000000,83.9382324); //object(sub_roadright) (34)
	CreateDynamicObject(3877,-2128.6379395,662.0180054,83.2539978,0.0000000,0.0000000,0.0000000); //object(sf_rooflite) (1)
	CreateDynamicObject(3877,-2128.6989746,677.3220215,83.2539978,0.0000000,0.0000000,0.0000000); //object(sf_rooflite) (2)
	CreateDynamicObject(3877,-2118.1350098,662.0159912,83.2539978,0.0000000,0.0000000,0.0000000); //object(sf_rooflite) (3)
	CreateDynamicObject(3877,-2109.1520996,661.9790039,83.2539978,0.0000000,0.0000000,0.0000000); //object(sf_rooflite) (4)
	CreateDynamicObject(3877,-2099.2229004,662.1160278,83.2539978,0.0000000,0.0000000,0.0000000); //object(sf_rooflite) (5)
	CreateDynamicObject(3877,-2099.2260742,677.3480225,83.2539978,0.0000000,0.0000000,0.0000000); //object(sf_rooflite) (6)
	// Алькатрас
	CreateDynamicObject(16148, -352.281006, 4077.540039, 7.565597, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(16147, -190.311996, 4065.300049, -2.239100, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(16149, -175.983994, 3861.800049, -3.731212, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(16264, -303.468994, 3781.340088, -7.051614, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(16109, -344.062012, 3898.699951, 5.135883, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(9829, -359.740753, 3855.419434, -61.709656, 0.0000, 0.0000, 30.4671);
	CreateDynamicObject(4874, -283.278656, 3798.420166, 10.977269, 0.0000, 0.0000, 172.2650);
	CreateDynamicObject(4874, -283.278656, 3798.420166, 7.877283, 0.0000, 0.0000, 172.2650);
	CreateDynamicObject(4874, -283.278656, 3798.420166, 4.627272, 0.0000, 0.0000, 172.2650);
	CreateDynamicObject(16139, -270.011261, 3824.376221, -9.043680, 0.0000, 0.0000, 135.0000);
	CreateDynamicObject(16139, -244.810059, 3796.027832, -10.335654, 0.0000, 0.0000, 67.5000);
	CreateDynamicObject(16127, -283.377930, 3774.991455, -4.936389, 0.0000, 0.0000, 168.7500);
	CreateDynamicObject(16127, -318.159485, 3784.079834, -4.734166, 0.0000, 0.0000, 168.7500);
	CreateDynamicObject(16667, -354.940216, 3815.890869, 6.507803, 0.0000, 0.0000, 154.9217);
	CreateDynamicObject(16127, -361.073792, 3804.429199, -4.818086, 0.0000, 0.0000, 153.1256);
	CreateDynamicObject(16127, -375.693146, 3829.437500, -7.525631, 17.1887, 10.3132, 121.8764);
	CreateDynamicObject(16133, -255.821655, 3846.334229, -2.559015, 0.0000, 0.0000, 146.2501);
	CreateDynamicObject(16133, -276.163757, 3876.047119, 18.259314, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(16139, -259.332642, 3862.839844, 6.511215, 0.0000, 323.0442, 123.7500);
	CreateDynamicObject(987, -306.967834, 3878.095947, 25.870365, 0.0000, 0.0000, 11.2500);
	CreateDynamicObject(987, -315.526581, 3886.679932, 26.398115, 0.0000, 2.5783, 315.0000);
	CreateDynamicObject(987, -323.811096, 3895.046387, 26.430893, 0.0000, 0.0000, 315.0000);
	CreateDynamicObject(987, -330.925476, 3904.011475, 25.436203, 0.0000, 354.8434, 308.1245);
	CreateDynamicObject(987, -337.195923, 3914.179443, 24.394951, 0.0000, 354.8434, 301.2490);
	CreateDynamicObject(987, -343.181885, 3924.066406, 22.813700, 0.0000, 352.2651, 301.2490);
	CreateDynamicObject(987, -349.170532, 3933.873779, 20.705282, 0.0000, 349.6868, 301.2490);
	CreateDynamicObject(987, -355.261597, 3944.060547, 19.057299, 0.0000, 352.2651, 301.2490);
	CreateDynamicObject(987, -361.421417, 3954.202148, 17.445929, 0.0000, 352.2651, 301.2490);
	CreateDynamicObject(987, -309.122620, 4005.298096, 29.887472, 0.0000, 0.0000, 276.0161);
	CreateDynamicObject(987, -307.831299, 3993.434570, 29.899292, 0.0000, 0.0000, 275.1566);
	CreateDynamicObject(987, -306.781952, 3981.822021, 29.891367, 0.0000, 3.4377, 275.1566);
	CreateDynamicObject(987, -305.683319, 3969.883789, 29.178947, 0.0000, 3.4377, 275.1566);
	CreateDynamicObject(987, -304.631866, 3957.958252, 28.456438, 0.0000, 3.4377, 274.2972);
	CreateDynamicObject(987, -303.730927, 3946.047363, 27.723639, 0.0000, 3.4377, 275.1566);
	CreateDynamicObject(987, -302.623871, 3933.954834, 26.999311, 0.0000, 1.7189, 273.4378);
	CreateDynamicObject(987, -301.860016, 3922.026123, 26.678772, 0.0000, 1.7189, 271.7189);
	CreateDynamicObject(987, -301.588318, 3909.729248, 26.282619, 0.0000, 0.0000, 225.7823);
	CreateDynamicObject(3279, -363.527985, 3948.506348, 16.255291, 0.0000, 0.0000, 303.7500);
	CreateDynamicObject(3279, -308.231262, 3909.005615, 25.567221, 0.0000, 0.0000, 135.0000);
	CreateDynamicObject(1294, -307.513977, 3822.205322, 12.830591, 0.0000, 0.0000, 45.0000);
	CreateDynamicObject(10828, -328.854523, 4006.648438, 33.758839, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(8656, -311.669434, 4006.655029, 21.008123, 89.3814, 0.0000, 180.0000);
	CreateDynamicObject(8656, -312.055481, 4006.761963, 35.888260, 0.0000, 269.7591, 90.0000);
	CreateDynamicObject(10828, -284.648010, 4018.398193, 33.763672, 0.0000, 0.0000, 42.4217);
	CreateDynamicObject(8656, -312.050598, 4006.539063, 35.888306, 0.0000, 269.7591, 270.0000);
	CreateDynamicObject(996, -313.744904, 4007.798096, 36.881157, 0.0000, 0.0000, 358.2811);
	CreateDynamicObject(996, -305.678711, 4007.567627, 36.880058, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(996, -304.369781, 4005.674805, 36.914696, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(996, -308.419403, 4005.717773, 36.904053, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(8656, -297.345276, 4006.806152, 21.113382, 89.3814, 0.0000, 41.4849);
	CreateDynamicObject(8656, -309.028625, 4006.266113, 20.088387, 89.3814, 0.0000, 7.7348);
	CreateDynamicObject(8656, -309.062683, 4006.528076, 20.106682, 89.3814, 0.0000, 187.7352);
	CreateDynamicObject(1965, -311.188538, 4007.445313, 33.864170, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(12985, -313.703033, 4004.734131, 33.834465, 359.1406, 0.0000, 90.0000);
	CreateDynamicObject(1698, -311.034210, 4005.904541, 36.257309, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(987, -308.908203, 4002.378906, 29.819626, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(987, -320.913239, 4002.361816, 29.832462, 0.0000, 0.0000, 157.5000);
	CreateDynamicObject(11327, -303.541565, 4007.341064, 32.193382, 0.0000, 0.0000, 90.0001);
	CreateDynamicObject(10828, -363.418976, 4006.641846, 33.760498, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(3279, -316.954956, 3852.203369, 9.011751, 0.0000, 0.0000, 33.7500);
	CreateDynamicObject(10828, -383.196533, 4006.639404, 33.763657, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(10828, -400.856445, 4027.096191, 33.763626, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(8656, -401.050781, 4009.910156, 21.116579, 89.3814, 0.0000, 270.8595);
	CreateDynamicObject(8656, -400.498657, 4006.888184, 21.095793, 89.3814, 0.0000, 185.1567);
	CreateDynamicObject(1965, -400.243622, 4009.426514, 33.854179, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(8656, -400.980469, 4020.517822, 35.914181, 0.0000, 269.7591, 180.0000);
	CreateDynamicObject(8656, -400.743927, 4020.511963, 35.910053, 0.0000, 269.7591, 360.0000);
	CreateDynamicObject(1497, -400.177917, 4007.935059, 29.850504, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(1497, -311.182556, 4007.361328, 29.850504, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(5728, -269.790771, 3850.355713, 18.994282, 0.0000, 0.0000, 352.1878);
	CreateDynamicObject(9582, -311.957581, 4052.827637, 38.332306, 0.0000, 0.0000, 345.2349);
	CreateDynamicObject(8169, -279.235107, 4051.095947, 29.675871, 0.0000, 0.0000, 287.2660);
	CreateDynamicObject(10828, -269.432220, 4032.297852, 33.760468, 0.0000, 0.0000, 42.4217);
	CreateDynamicObject(10828, -268.756989, 4056.891113, 33.769737, 0.0000, 0.0000, 135.0000);
	CreateDynamicObject(1497, -273.279938, 4060.026367, 29.647379, 0.0000, 0.0000, 225.0000);
	CreateDynamicObject(8656, -256.126709, 4044.493896, 21.159750, 89.3814, 0.0000, 173.9065);
	CreateDynamicObject(1497, -314.155090, 4101.166016, 29.395079, 0.0000, 0.0000, 225.0001);
	CreateDynamicObject(12985, -285.003632, 4070.511230, 33.501373, 356.5623, 0.0000, 45.0000);
	CreateDynamicObject(10828, -318.290527, 4106.424805, 33.804352, 0.0000, 0.0000, 135.0000);
	CreateDynamicObject(10828, -293.785095, 4081.926514, 33.784191, 0.0000, 0.0000, 135.0000);
	CreateDynamicObject(8656, -336.300873, 4124.330566, 21.193327, 89.3814, 0.0000, 304.6096);
	CreateDynamicObject(1497, -338.518585, 4125.041992, 28.981155, 0.0000, 0.0000, 315.0007);
	CreateDynamicObject(8656, -323.766418, 4089.556641, 35.958931, 0.0000, 269.7591, 316.7189);
	CreateDynamicObject(8656, -328.329071, 4116.701660, 35.971836, 0.0000, 269.7591, 225.0000);
	CreateDynamicObject(1965, -314.144745, 4101.156738, 33.372780, 0.0000, 0.0000, 135.0000);
	CreateDynamicObject(1965, -337.481934, 4124.000488, 34.852242, 0.0000, 0.0000, 45.0000);
	CreateDynamicObject(1965, -337.489532, 4124.020508, 32.897091, 0.0000, 0.0000, 45.0000);
	CreateDynamicObject(10828, -324.126129, 4112.299805, 33.821239, 0.0000, 0.0000, 135.0000);
	CreateDynamicObject(10828, -351.345276, 4113.787109, 35.059612, 0.0000, 4.2972, 45.0000);
	CreateDynamicObject(10828, -376.209076, 4088.950684, 36.374985, 0.0000, 0.0000, 45.0000);
	CreateDynamicObject(10828, -394.575134, 4060.643311, 35.088722, 0.0000, 4.2972, 249.2189);
	CreateDynamicObject(987, -347.200134, 4034.441650, 29.656929, 0.0000, 0.0000, 67.5000);
	CreateDynamicObject(987, -347.302551, 4024.470703, 29.656929, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(987, -347.305878, 4018.486572, 29.656929, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(1965, -274.259674, 4059.002930, 33.633209, 0.0000, 0.0000, 314.9999);
	CreateDynamicObject(5728, -283.406189, 3835.516602, 7.516424, 0.8594, 0.0000, 352.1878);
	CreateDynamicObject(5728, -285.537170, 3819.975342, -2.901389, 0.8594, 0.0000, 352.1878);
	CreateDynamicObject(5728, -286.301575, 3814.303711, -10.015227, 23.2048, 0.0000, 352.1878);
	CreateDynamicObject(18553, -288.837799, 3831.872070, 9.974839, 0.8594, 292.9640, 261.3283);
	CreateDynamicObject(994, -401.957245, 4005.349121, 36.181282, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(997, -257.547089, 4041.611572, 36.182404, 0.0000, 0.0000, 54.5311);
	CreateDynamicObject(997, -255.664764, 4044.153320, 36.191673, 0.0000, 0.0000, 118.5933);
	CreateDynamicObject(997, -335.986603, 4125.497559, 36.232418, 0.0000, 0.0000, 149.7650);
	CreateDynamicObject(997, -341.390686, 4125.394043, 36.231575, 0.0000, 0.0000, 32.0311);
	CreateDynamicObject(16337, -397.807922, 4009.707520, 37.197132, 0.0000, 0.0000, 225.0000);
	CreateDynamicObject(5302, -396.688873, 4007.711182, 36.286217, 0.0000, 89.3814, 135.0000);
	CreateDynamicObject(5302, -399.866302, 4010.942139, 36.311172, 0.0000, 89.3814, 134.1406);
	CreateDynamicObject(18367, -397.588959, 4009.886963, 36.319416, 95.6049, 0.0000, 315.0000);
	CreateDynamicObject(16337, -338.474701, 4122.377930, 37.246193, 0.0000, 0.0000, 90.0001);
	CreateDynamicObject(16337, -386.273224, 4075.628906, 39.681324, 0.0000, 0.0000, 146.2501);
	CreateDynamicObject(3864, -396.926666, 4010.626221, 32.059338, 0.0000, 0.0000, 225.0000);
	CreateDynamicObject(3872, -392.184143, 4015.383057, 32.877377, 0.0000, 0.0000, 225.0000);
	CreateDynamicObject(1215, -397.388519, 4011.081787, 37.639900, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -396.469818, 4010.113281, 37.673012, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -397.381653, 4011.074951, 37.060268, 0.0000, 0.0000, 348.7500);
	CreateDynamicObject(1215, -396.487518, 4010.105713, 37.100708, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -397.531982, 4010.868652, 36.589405, 0.0000, 0.0000, 348.7500);
	CreateDynamicObject(1215, -396.598694, 4010.016357, 36.580635, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(5302, -386.775085, 4075.983398, 38.846313, 0.0000, 89.3814, 55.3907);
	CreateDynamicObject(18367, -386.051147, 4075.548828, 38.866966, 95.6049, 0.0000, 236.2501);
	CreateDynamicObject(5302, -340.398499, 4123.002441, 36.408714, 0.0000, 89.3814, 359.1406);
	CreateDynamicObject(5302, -337.006195, 4122.967773, 36.418850, 0.0000, 89.3814, 359.1406);
	CreateDynamicObject(18367, -338.342072, 4122.007324, 36.434593, 95.6049, 0.0000, 168.7500);
	CreateDynamicObject(3864, -385.182404, 4074.956787, 34.439224, 0.0000, 0.0000, 146.2500);
	CreateDynamicObject(3872, -379.560669, 4071.220215, 35.228336, 0.0000, 0.0000, 146.2500);
	CreateDynamicObject(3864, -338.501373, 4121.197266, 31.964725, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(3872, -338.502380, 4114.357422, 32.821896, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(1215, -339.215942, 4121.083008, 37.571693, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -337.826355, 4121.073242, 37.574867, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -339.208069, 4121.107910, 37.084770, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -337.833191, 4121.084961, 37.080528, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -339.194641, 4121.158691, 36.551277, 0.0000, 0.0000, 236.2501);
	CreateDynamicObject(1215, -337.839661, 4121.085938, 36.537437, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -385.565643, 4074.431152, 40.116463, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -384.821259, 4075.526367, 40.095352, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -385.574219, 4074.383545, 39.549923, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -384.797302, 4075.531982, 39.549225, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -385.590759, 4074.400635, 38.933826, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1215, -384.802704, 4075.536133, 38.941471, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(3460, -341.551697, 4054.269287, 33.208031, 0.0000, 0.0000, 67.5000);
	CreateDynamicObject(3460, -338.178467, 4080.331055, 34.749626, 0.0000, 0.0000, 22.5000);
	CreateDynamicObject(2886, -311.456757, 4007.628662, 31.033083, 0.0000, 0.0000, 177.4217);
	CreateDynamicObject(1501, -280.543091, 4047.717041, 29.553473, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(987, -371.358826, 3949.214111, 15.737392, 0.0000, 351.4056, 31.2490);
	CreateDynamicObject(11327, -319.813873, 3830.636230, 10.773924, 0.0000, 0.0000, 101.2501);
	CreateDynamicObject(11327, -303.540100, 4007.352295, 33.782742, 0.0000, 0.0000, 90.0001);
	CreateDynamicObject(11327, -347.364624, 4029.474609, 32.193382, 0.0000, 0.0000, 0.0001);
	CreateDynamicObject(11327, -347.358856, 4029.460449, 34.170681, 0.0000, 0.0000, 0.0001);
	CreateDynamicObject(11327, -319.802460, 3830.653076, 12.825305, 0.0000, 0.0000, 101.2501);
	CreateDynamicObject(987, -336.033356, 3832.027588, 7.400957, 0.0000, 355.7028, 349.5321);
	CreateDynamicObject(987, -340.811218, 3842.819580, 6.615160, 0.0000, 356.5623, 293.2822);
	CreateDynamicObject(987, -343.222382, 3854.520020, 6.884872, 0.0000, 0.8594, 282.0322);
	CreateDynamicObject(987, -349.403595, 3864.978516, 7.865357, 0.0000, 4.2972, 301.0944);
	CreateDynamicObject(987, -356.964264, 3874.308350, 9.950745, 0.0000, 9.4538, 308.9067);
	CreateDynamicObject(987, -362.959259, 3884.577148, 11.466610, 0.0000, 6.8755, 300.2350);
	CreateDynamicObject(987, -367.166809, 3895.571777, 12.573673, 0.0000, 5.1566, 290.7038);
	CreateDynamicObject(987, -371.926788, 3906.438477, 13.475338, 0.0000, 4.2972, 293.2822);
	CreateDynamicObject(987, -377.261719, 3917.086670, 14.288242, 0.0000, 3.4377, 297.5793);
	CreateDynamicObject(987, -382.689240, 3927.659668, 14.871820, 0.0000, 2.5783, 297.5793);
	CreateDynamicObject(987, -388.001953, 3938.287109, 15.407955, 0.0000, 2.5783, 296.7199);
	CreateDynamicObject(987, -387.648987, 3949.955566, 15.757544, 0.0000, 1.7189, 268.1266);
	CreateDynamicObject(947, -361.771637, 4098.194336, 33.302917, 0.0000, 0.0000, 225.0000);
	CreateDynamicObject(947, -343.175903, 4079.835938, 32.760681, 0.0000, 0.0000, 45.0000);
	CreateDynamicObject(947, -350.971252, 4109.442383, 32.402206, 0.0000, 0.0000, 225.0000);
	CreateDynamicObject(947, -331.959686, 4091.781982, 32.690872, 0.0000, 0.0000, 45.0000);
	CreateDynamicObject(1412, -356.340454, 4103.866699, 31.903219, 0.0000, 0.0000, 315.0000);
	CreateDynamicObject(1412, -352.658051, 4100.196777, 31.888224, 0.0000, 0.0000, 315.0000);
	CreateDynamicObject(1412, -348.903168, 4096.514160, 31.878225, 0.0000, 0.0000, 315.0000);
	CreateDynamicObject(1412, -345.165283, 4092.815430, 31.858295, 0.0000, 0.0000, 315.0000);
	CreateDynamicObject(1412, -341.419159, 4089.100342, 31.829649, 0.0000, 0.0000, 315.0001);
	CreateDynamicObject(1412, -337.616364, 4085.410400, 31.801010, 0.0000, 0.0000, 315.0000);
	CreateDynamicObject(3865, -217.540588, 3861.715332, 1.647892, 7.7349, 336.6920, 31.9538);
	CreateDynamicObject(1414, -216.322220, 3858.704102, 0.718898, 0.0000, 67.8954, 33.7500);
	CreateDynamicObject(1414, -215.500565, 3859.244873, 1.106063, 0.0000, 223.4538, 33.7500);
	CreateDynamicObject(16123, -253.635910, 3991.806641, 16.842131, 0.0000, 311.0122, 348.7500);
	CreateDynamicObject(987, -385.995575, 3961.811768, 16.099691, 0.0000, 1.7189, 262.0332);
	CreateDynamicObject(3865, -219.496048, 3865.489014, 3.119103, 249.9922, 305.7525, 20.7038);
	CreateDynamicObject(17546, -393.756104, 3986.371338, 21.976376, 0.0000, 0.0000, 88.2037);
	CreateDynamicObject(10763, -387.751801, 3990.945068, 31.283932, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(996, -385.038086, 3970.487793, 34.127350, 0.0000, 90.2409, 0.0000);
	CreateDynamicObject(996, -384.519623, 3970.491943, 26.045677, 0.0000, 90.2409, 0.0000);
	CreateDynamicObject(996, -384.511780, 3970.486084, 34.126850, 0.0000, 90.2409, 0.0000);
	CreateDynamicObject(3257, -277.625305, 3841.864746, 19.344498, 0.0000, 0.0000, 171.3284);
	CreateDynamicObject(3475, -276.162415, 3849.908936, 21.772385, 0.0000, 0.0000, 168.7500);
	CreateDynamicObject(3475, -284.030182, 3821.947021, 21.278952, 0.0000, 0.0000, 171.3283);
	CreateDynamicObject(3475, -283.211121, 3827.886719, 21.329554, 359.1406, 0.0000, 172.1877);
	CreateDynamicObject(3475, -282.346497, 3833.749512, 21.432522, 359.1406, 0.0000, 171.3283);
	CreateDynamicObject(3475, -279.879333, 3838.875977, 21.522306, 0.0000, 0.0000, 137.5783);
	CreateDynamicObject(987, -314.819000, 3831.679443, 8.440645, 0.0000, 359.1406, 315.0000);
	CreateDynamicObject(987, -306.405609, 3823.280762, 8.611793, 0.0000, 0.0000, 346.9538);
	CreateDynamicObject(987, -294.712524, 3820.581299, 8.617189, 0.0000, 359.1406, 351.2510);
	CreateDynamicObject(3475, -384.831177, 4003.252197, 32.224487, 0.0000, 0.0000, 178.2813);
	CreateDynamicObject(3475, -385.025238, 3997.328613, 32.224487, 0.0000, 0.0000, 178.2813);
	CreateDynamicObject(3475, -385.212189, 3991.362061, 32.224487, 0.0000, 0.0000, 178.2813);
	CreateDynamicObject(3475, -385.382324, 3985.421387, 32.224487, 0.0000, 0.0000, 178.2813);
	CreateDynamicObject(3475, -385.599213, 3979.468018, 32.224487, 0.0000, 0.0000, 178.2813);
	CreateDynamicObject(3475, -385.757080, 3973.488525, 32.224487, 0.0000, 0.0000, 178.2813);
	CreateDynamicObject(17546, -405.043030, 4003.430908, 21.974125, 0.0000, 0.0000, 121.9539);
	CreateDynamicObject(1498, -393.501617, 3974.911133, 29.842155, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(3475, -388.480927, 3970.815918, 32.224487, 0.0000, 0.0000, 88.2812);
	CreateDynamicObject(3475, -402.598297, 3980.162598, 32.224487, 0.0000, 0.0000, 358.2812);
	CreateDynamicObject(3475, -402.798065, 3974.187012, 32.224487, 0.0000, 0.0000, 358.2812);
	CreateDynamicObject(3475, -400.086334, 3971.276123, 32.224487, 0.0000, 0.0000, 88.2812);
	CreateDynamicObject(3475, -404.150574, 3985.740479, 32.222237, 0.0000, 0.0000, 33.7501);
	CreateDynamicObject(3475, -407.377747, 3990.719482, 32.222237, 0.0000, 0.0000, 33.7501);
	CreateDynamicObject(3475, -410.481445, 3995.706299, 32.222237, 0.0000, 0.0000, 32.0312);
	CreateDynamicObject(3475, -413.600861, 4000.698975, 32.222237, 0.0000, 0.0000, 32.0312);
	CreateDynamicObject(3475, -416.782043, 4005.798828, 32.222237, 0.0000, 0.0000, 32.0312);
	CreateDynamicObject(3475, -419.924957, 4010.810303, 32.222237, 0.0000, 0.0000, 32.0312);
	CreateDynamicObject(3475, -422.822388, 4015.449219, 32.222237, 0.0000, 0.0000, 32.0312);
	CreateDynamicObject(3475, -422.052856, 4019.242676, 32.222237, 0.0000, 0.0000, 302.0312);
	CreateDynamicObject(8165, -411.928406, 4053.329346, 27.628073, 0.0000, 0.0000, 326.2500);
	CreateDynamicObject(8165, -412.239197, 4053.444336, 32.927246, 0.0000, 0.0000, 326.2500);
	CreateDynamicObject(8154, -360.672394, 4108.085938, 23.596632, 0.0000, 0.0000, 149.6105);
	CreateDynamicObject(8154, -360.678009, 4108.115723, 28.265793, 0.0000, 0.0000, 149.6105);
	CreateDynamicObject(8154, -360.704102, 4108.161133, 33.721962, 0.0000, 0.0000, 149.6105);
	CreateDynamicObject(8149, -264.377808, 4080.845703, 23.820486, 0.0000, 0.0000, 225.8595);
	CreateDynamicObject(8149, -264.531158, 4080.703613, 28.136635, 0.0000, 0.0000, 225.8595);
	CreateDynamicObject(8149, -264.582428, 4080.671875, 33.642998, 0.0000, 0.0000, 225.8595);
	CreateDynamicObject(8149, -228.099426, 3949.687012, 23.821583, 0.0000, 0.0000, 345.3122);
	CreateDynamicObject(8149, -228.136139, 3949.681885, 28.138916, 0.0000, 0.0000, 345.3122);
	CreateDynamicObject(8149, -228.163605, 3949.709473, 33.646675, 0.0000, 0.0000, 345.3122);
	CreateDynamicObject(8165, -245.126404, 4015.772949, 27.571745, 0.0000, 0.0000, 236.2501);
	CreateDynamicObject(8165, -245.134506, 4015.776367, 33.121712, 0.0000, 0.0000, 236.2501);
	CreateDynamicObject(3279, -257.066040, 3977.395508, 41.474121, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(5822, -257.965240, 3971.657227, 36.186954, 0.0000, 0.0000, 94.2972);
	CreateDynamicObject(987, -295.195770, 3880.393799, 25.835501, 0.0000, 358.2811, 33.7500);
	CreateDynamicObject(16116, -263.185852, 3886.978760, 13.288935, 0.0000, 0.0000, 48.5151);
	CreateDynamicObject(987, -285.485901, 3886.867920, 26.178713, 0.0000, 1.7189, 33.7500);
	CreateDynamicObject(987, -275.537628, 3893.565918, 25.827162, 0.0000, 0.0000, 22.5000);
	CreateDynamicObject(987, -264.420868, 3898.164063, 25.817183, 0.0000, 2.5783, 22.5000);
	CreateDynamicObject(987, -253.493164, 3902.693115, 25.270817, 0.0000, 4.2972, 348.7500);
	CreateDynamicObject(10828, -326.618073, 4086.545410, 33.813629, 0.0000, 0.0000, 46.7189);
	CreateDynamicObject(8656, -314.914734, 4099.108398, 21.204161, 89.3814, 0.0000, 224.0637);
	CreateDynamicObject(8656, -339.469147, 4125.640625, 21.144173, 89.3814, 0.0000, 224.1408);
	CreateDynamicObject(1280, -395.480499, 4045.317139, 30.263828, 0.0000, 0.0000, 191.2500);
	CreateDynamicObject(1280, -381.190735, 4019.731689, 30.261459, 0.0000, 0.0000, 258.7500);
	CreateDynamicObject(1280, -355.859802, 4073.839111, 30.717306, 0.0000, 0.0000, 225.0000);
	CreateDynamicObject(1508, -340.253601, 4053.725586, 31.520782, 0.0000, 0.0000, 154.9217);
	CreateDynamicObject(8656, -323.270508, 4090.098633, 35.954571, 0.0000, 269.7591, 136.7189);
	CreateDynamicObject(16766, -267.115204, 3951.647949, 43.808121, 0.0000, 0.8594, 284.6877);
	CreateDynamicObject(11461, -265.131165, 3853.659424, 30.321405, 0.0000, 0.0000, 236.2500);
	CreateDynamicObject(3530, -265.072113, 3943.650635, 34.982635, 0.0000, 0.0000, 13.0462);
	CreateDynamicObject(3530, -272.436737, 3972.284912, 35.041359, 0.0000, 0.0000, 13.0462);
	CreateDynamicObject(3530, -257.620941, 3915.692627, 36.770454, 0.0000, 0.0000, 13.0462);
	CreateDynamicObject(3530, -257.594482, 3915.704834, 32.689754, 0.0000, 0.0000, 13.0462);
	CreateDynamicObject(16116, -219.192673, 3883.099609, 3.064840, 328.2008, 70.4738, 259.5321);
	CreateDynamicObject(10402, -292.846313, 3973.801758, 29.561670, 0.0000, 1.7189, 275.1566);
	CreateDynamicObject(17049, -249.512695, 3890.276123, 28.903534, 0.0000, 0.0000, 348.7500);
	CreateDynamicObject(16766, -293.998260, 3826.706055, 1.888986, 8.5944, 30.9397, 228.3605);
	// Интерьер тюрьмы
	CreateDynamicObject(3865, 1195.845703, -72.528946, 1.383192, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(3865, 1201.585571, -72.853889, 1.871448, 314.4499, 90.1369, 78.7500);
	CreateDynamicObject(3865, 1187.530396, -72.800400, 1.211240, 357.4217, 1.7189, 95.1566);
	CreateDynamicObject(3865, 1179.112793, -73.861816, 0.500791, 353.1245, 1.7189, 101.1727);
	CreateDynamicObject(3865, 1170.514771, -75.475151, -0.516947, 353.1245, 1.7189, 101.1727);
	CreateDynamicObject(3865, 1161.720703, -76.185219, -1.325558, 355.7028, 1.7189, 89.9226);
	CreateDynamicObject(3865, 1153.098511, -75.139961, -1.580533, 0.0000, 0.0000, 78.6727);
	CreateDynamicObject(3865, 1144.747314, -72.408798, -1.191780, 4.2972, 0.0000, 67.4226);
	CreateDynamicObject(3865, 1136.508301, -69.858398, -0.497578, 4.2972, 0.0000, 78.6727);
	CreateDynamicObject(3865, 1127.836792, -68.941345, 0.476992, 7.7349, 359.1406, 89.9226);
	CreateDynamicObject(16658, 1076.411987, -64.824371, 5.850303, 0.0000, 0.0000, 360.0000);
	CreateDynamicObject(3865, 1119.165649, -68.839279, 1.330420, 3.4377, 359.1406, 89.9226);
	CreateDynamicObject(3865, 1110.510742, -67.826363, 1.598876, 0.0000, 359.1406, 78.6727);
	CreateDynamicObject(3865, 1056.667114, -59.341469, 2.554096, 0.0000, 358.1777, 180.7821);
	CreateDynamicObject(16645, 1075.724243, -66.511703, 3.514202, 0.0000, 0.0000, 360.0000);
	CreateDynamicObject(3865, 1102.463135, -65.161690, 1.642508, 0.0000, 359.1406, 67.4226);
	CreateDynamicObject(3865, 1056.856079, -47.208904, 2.544224, 0.0000, 1.7189, 0.7820);
	CreateDynamicObject(3865, 1062.835327, -53.368534, 2.531879, 0.0000, 1.7189, 270.7820);
	CreateDynamicObject(3865, 1050.677612, -53.235111, 2.510675, 0.0000, 333.2542, 90.7823);
	CreateDynamicObject(3865, 1056.910889, -53.270653, 5.355008, 0.0000, 300.6989, 315.7820);
	CreateDynamicObject(3865, 1056.895752, -53.266644, 5.336772, 0.0000, 300.6989, 237.0320);
	CreateDynamicObject(3865, 1056.940674, -53.245144, -0.249691, 0.0000, 154.6987, 315.7820);
	CreateDynamicObject(3865, 1056.959839, -53.247761, -0.287717, 0.0000, 154.6987, 225.7820);
	CreateDynamicObject(3865, 1071.374146, -53.971642, 2.315304, 3.4377, 1.7189, 79.5322);
	CreateDynamicObject(3865, 1079.262451, -56.249889, 1.842074, 3.4377, 1.7189, 68.2823);
	CreateDynamicObject(3865, 1087.301025, -59.544159, 1.423019, 1.7189, 1.7189, 68.2823);
	CreateDynamicObject(3865, 1094.495728, -62.258739, 1.438569, 357.4217, 359.1406, 73.4390);
	CreateDynamicObject(1358, 1094.503174, -63.408443, 0.836421, 302.4177, 357.4217, 337.5000);
	CreateDynamicObject(3865, 1056.686768, -42.259441, 1.970739, 314.4499, 126.2329, 180.0000);
	CreateDynamicObject(3865, 1046.375244, -53.555538, 1.904888, 314.4499, 116.7792, 270.0001);
	CreateDynamicObject(1369, 1056.164429, -45.842934, 1.743976, 315.3093, 35.2369, 318.4378);
	CreateDynamicObject(1462, 1049.807861, -52.847317, 1.182698, 67.0360, 40.3935, 258.7500);
	CreateDynamicObject(8948, 1049.067261, -67.178482, 5.140333, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(8948, 1049.139160, -66.998375, 6.546829, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(8948, 1051.331787, -63.776817, 5.147590, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(8948, 1058.579712, -63.669071, 5.147590, 0.0000, 0.0000, 91.7188);
	CreateDynamicObject(8948, 1051.350708, -63.823784, 6.555346, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(8948, 1058.575562, -63.707260, 6.542184, 0.0000, 0.0000, 91.7188);
	CreateDynamicObject(8948, 1061.188477, -63.681740, 2.065930, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(8948, 1052.247314, -63.734505, 2.028061, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(8948, 1090.573975, -61.747383, 8.449911, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(14576, 1070.728394, -34.742817, 3.078434, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(1437, 1072.527832, -65.514343, 6.973473, 295.5423, 0.0000, 180.0000);
	CreateDynamicObject(1555, 1071.632813, -70.124176, 8.349556, 3.4377, 0.0000, 0.0001);
	CreateDynamicObject(914, 1071.796997, -70.074265, 7.482104, 0.0000, 214.8598, 0.0000);
	CreateDynamicObject(8948, 1070.467896, -61.772869, 8.432522, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(1437, 1076.544922, -62.762611, 3.305780, 322.1848, 0.0000, 90.0000);
	CreateDynamicObject(1412, 1056.745728, -63.894424, 2.300166, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1239, 1072.560059, -69.798111, 8.387575, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1239, 1195.837524, -72.668808, 0.230100, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(1220, 1094.551514, -61.749298, 0.465565, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1221, 1094.725464, -61.949715, 1.266535, 29.2208, 20.6265, 0.0000);
	CreateDynamicObject(1239, 1071.889160, -35.168743, 2.483840, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1492, 1069.960815, -42.112419, -5.124367, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(18553, 1070.755859, -42.175247, -3.649266, 90.2408, 0.0000, 270.0000);
	CreateDynamicObject(14408, 1042.735107, -6.151438, 6.278552, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1967, 1065.044678, -18.986315, 4.786386, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1967, 1065.052979, -17.415012, 4.786386, 0.0000, 0.0000, 181.7189);
	CreateDynamicObject(1967, 1065.006348, -18.138250, 3.261381, 90.2408, 0.0000, 0.0000);
	CreateDynamicObject(1967, 1065.042114, -18.401146, 7.262824, 90.2408, 0.0000, 0.0000);
	CreateDynamicObject(1534, 1048.771606, 7.831377, -1.357124, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(14409, 1062.470581, -9.422371, 0.120997, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(986, 1052.521118, -8.417847, 3.220139, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(986, 1052.521118, -0.389186, 3.251442, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(986, 1052.565063, 2.176354, -2.579532, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(986, 1052.686157, -5.873131, -2.554532, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(971, 1052.551636, -16.951757, -3.314750, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(8948, 1035.202759, -17.403259, 89.768433, 358.2811, 0.0000, 180.0000);
	CreateDynamicObject(8185, 1020.308411, 7.330478, 91.676331, 0.0000, 90.2409, 269.9999);
	CreateDynamicObject(1508, 1009.980652, -8.455176, -1.406888, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(8185, 926.466919, -28.623928, -0.965509, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(971, 1060.209351, -15.520641, 6.831278, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(1499, 1015.946960, -16.932980, -3.071074, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(1499, 1012.944763, -16.952868, -3.071074, 0.0000, 0.0000, 360.0000);
	CreateDynamicObject(8185, 922.699158, -16.911819, -0.965509, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(8185, 926.446289, -16.885944, 1.536062, 0.0000, 179.6227, 270.0000);
	CreateDynamicObject(8185, 1047.733154, 8.306663, -0.890512, 180.4818, 0.0000, 269.9999);
	CreateDynamicObject(2255, 1048.482178, 7.603449, -1.405088, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(8185, 1048.364746, 9.204869, -3.245484, 0.0000, 269.7592, 90.0003);
	CreateDynamicObject(9339, 1031.388916, -17.518623, 3.132543, 0.0000, 269.7592, 269.9999);
	CreateDynamicObject(9339, 1031.388916, 4.856366, 3.132543, 0.0000, 269.7592, 90.0000);
	CreateDynamicObject(9339, 1031.388916, 4.031367, 3.132543, 0.0000, 269.7592, 90.0000);
	CreateDynamicObject(9339, 1019.913208, -8.743644, 3.132543, 0.0000, 269.7592, 180.0000);
	CreateDynamicObject(9339, 1019.110229, -5.468654, 3.132543, 0.0000, 269.7592, 180.0000);
	CreateDynamicObject(9339, 1031.388916, -16.418652, 3.132543, 0.0000, 269.7592, 270.0000);
	CreateDynamicObject(1499, 1012.153870, -24.528854, -3.071074, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1499, 1014.178711, -24.532009, -3.071074, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(16501, 1015.832092, -28.025930, -0.864719, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(16501, 1012.066101, -28.039104, -0.864719, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(16501, 1014.003174, -28.033226, -0.864719, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(16501, 1013.813171, -28.030962, -0.864719, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(16501, 1013.999084, -24.552582, 1.710276, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(2602, 1014.770325, -28.416763, -2.541760, 0.0000, 0.0000, 225.0000);
	CreateDynamicObject(2602, 1012.821777, -28.455187, -2.541760, 0.0000, 0.0000, 225.0000);
	CreateDynamicObject(3294, 1009.026367, -22.305328, -3.085595, 0.0000, 269.8632, 180.0000);
	CreateDynamicObject(3294, 1009.937317, -22.020958, -3.502339, 0.0000, 0.0000, 180.0001);
	CreateDynamicObject(3294, 1008.321594, -24.448997, -3.500935, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(3294, 1008.310120, -20.403454, -3.500674, 0.0000, 0.0000, 90.0004);
	CreateDynamicObject(3294, 1011.866333, -21.610859, -5.623923, 0.0000, 0.0000, 0.0003);
	CreateDynamicObject(2150, 1009.795898, -23.832346, -0.269890, 91.9597, 0.0000, 90.0000);
	CreateDynamicObject(2150, 1009.795898, -21.180475, -0.243319, 91.9597, 0.0000, 90.0000);
	CreateDynamicObject(2150, 1009.795898, -22.520035, -0.261603, 91.9597, 0.0000, 90.0000);
	CreateDynamicObject(2332, 1010.479858, -22.351957, -3.443364, 270.6186, 1.7189, 0.0000);
	CreateDynamicObject(2518, 1015.420532, -21.612900, -2.682857, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(2518, 1015.395508, -22.823864, -2.670018, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(2518, 1015.420532, -20.227869, -2.677568, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(18001, 1015.921021, -23.070486, -0.931512, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(16649, 1066.695190, -27.051601, 9.560216, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(8948, 1062.675415, -20.090805, 8.392888, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(979, 1069.381714, -19.954073, 7.603541, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(1651, 1066.674683, -32.162807, 11.416418, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(8229, 1068.408081, -3.637179, 7.989528, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(2173, 1069.329712, -28.883501, -4.991213, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(2173, 1073.230347, -28.902000, -4.991213, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(2205, 1071.450073, -28.903570, -4.998936, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(2356, 1070.659302, -27.823597, -4.996560, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(1498, 1012.155884, -4.217271, -3.071355, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(971, 1011.507019, -4.150609, 1.829719, 0.0000, 179.6227, 0.0000);
	CreateDynamicObject(1498, 1012.398560, -0.471042, -3.071355, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(2190, 1070.927856, -29.223568, -4.066915, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(1239, 1070.722412, -41.198956, -4.796744, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1239, 1010.593689, -10.030163, -2.870729, 0.0000, 0.0000, 292.5000);
	CreateDynamicObject(1239, 1066.599121, -31.346786, 10.520496, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(14464, 1044.397339, -29.878742, -0.148927, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(14464, 1020.573242, 17.469059, -0.173927, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(14464, 1020.573853, 17.442976, 6.201082, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(14464, 1006.495178, -18.829163, 6.201746, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(14464, 1044.411011, -29.861933, 6.176073, 0.0000, 0.0000, 270.0001);
	CreateDynamicObject(9339, 1044.329834, -16.453966, -3.341112, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1044.321167, -17.850521, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1044.314453, -19.252169, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1040.387573, -16.455074, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1040.380493, -17.851051, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1040.379272, -19.241039, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1036.347900, -16.473494, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1036.351563, -17.846746, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1036.347778, -19.235455, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1032.365234, -16.470215, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1032.365967, -17.862738, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1032.365112, -19.263700, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1028.383301, -16.459139, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1028.376953, -17.860653, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1028.370605, -19.259670, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1024.406616, -16.456877, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1024.404297, -17.840588, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1024.409424, -19.226349, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1020.662720, -16.464172, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1020.668152, -17.847347, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1020.674988, -19.236830, -2.366121, 269.7592, 0.0000, 0.0000);
	CreateDynamicObject(9339, 1017.133179, -15.857641, 9.732288, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1018.509155, -15.864792, 16.109900, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1019.863159, -15.849192, 16.085543, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1044.309204, 6.852743, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1044.309082, 5.459843, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1044.311523, 4.056484, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1040.381714, 4.062516, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1040.391235, 5.467145, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1040.393188, 6.843500, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1036.369873, 4.049647, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1036.376587, 5.444561, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1036.380981, 6.852037, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1032.349976, 4.053426, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1032.352417, 6.838749, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1032.344482, 5.446962, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1028.397827, 4.051565, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1028.399292, 5.458675, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1028.400146, 6.854933, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1024.370850, 4.053601, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1024.367432, 5.453306, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1024.358643, 6.859984, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1020.667175, 4.045816, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1020.674622, 5.433133, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1020.671631, 6.827520, -2.366121, 269.7592, 0.0000, 180.0000);
	CreateDynamicObject(9339, 1017.143860, 3.447040, 9.859531, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1018.562866, 3.418604, 16.110331, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1019.959290, 3.423086, 16.110001, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1019.968445, -0.158381, 16.233862, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1017.189270, -0.130899, 16.260441, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1018.595215, -0.166673, 16.110424, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1019.957703, -4.161370, 16.108881, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1018.544495, -4.163829, 16.235424, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1017.164856, -4.168707, 16.260450, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1019.965576, -8.163240, 16.208891, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1018.578308, -8.158398, 16.111412, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1017.186584, -8.155918, 16.235462, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1019.949158, -12.198248, 16.108904, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1018.557678, -12.202415, 16.185455, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(9339, 1017.165039, -12.199060, 16.260450, 269.7592, 0.0000, 270.0000);
	CreateDynamicObject(996, 1043.762573, -13.917768, 3.986075, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(996, 1037.829834, -13.919753, 3.986609, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(997, 1044.360840, -13.867668, 3.342156, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(996, 1022.605774, -10.862389, 3.935771, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(996, 1022.618774, -8.122116, 3.938451, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(996, 1043.766357, 1.481337, 3.961933, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(996, 1038.595093, 1.471625, 3.962842, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(997, 1044.360352, 1.421283, 3.316501, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(980, 1038.609131, -16.660349, 3.208193, 90.2409, 0.0000, 0.0000);
	CreateDynamicObject(980, 1027.100830, -16.664425, 3.208195, 90.2409, 0.0000, 0.0000);
	CreateDynamicObject(980, 1019.867188, -10.555090, 3.208193, 90.2409, 0.0000, 270.0000);
	CreateDynamicObject(980, 1019.835571, 0.948011, 3.183193, 90.2409, 0.0000, 270.0000);
	CreateDynamicObject(980, 1038.649658, 4.199170, 3.183190, 90.2409, 0.0000, 180.0000);
	CreateDynamicObject(980, 1027.123535, 4.178074, 3.208197, 90.2409, 0.0000, 180.0000);
	CreateDynamicObject(14413, 1041.496338, 0.597903, 2.976794, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(12987, 1026.994873, -0.610827, 0.673499, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(12985, 1027.026733, -11.693703, 0.698213, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(980, 1022.009521, -17.925631, 3.208193, 90.2409, 0.0000, 270.0000);
	CreateDynamicObject(980, 1021.986694, 5.672253, 3.183197, 90.2409, 0.0000, 90.0000);
	CreateDynamicObject(996, 1032.236816, -13.931599, 3.985208, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(996, 1025.361206, 1.445599, 3.968153, 0.0000, 0.0000, 359.9999);
	CreateDynamicObject(8131, 1018.465454, 7.686447, -10.746788, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1368, 1017.958252, 3.940457, -2.375461, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(1368, 1017.019348, 4.844296, -2.375461, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(1368, 1017.738159, -16.367407, -2.375461, 0.0000, 0.0000, 360.0000);
	CreateDynamicObject(1368, 1016.817383, -17.272032, -2.375461, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(16377, 1019.920593, -19.333858, -2.134865, 0.0000, 0.0000, 45.0000);
	CreateDynamicObject(1553, 1019.701233, -19.419594, -3.271343, 0.0000, 0.0000, 45.0000);
	CreateDynamicObject(1432, 1025.492798, -11.385380, -2.933396, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1432, 1025.588501, -0.911067, -2.933396, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(1216, 1059.654419, -14.411251, -2.373195, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(956, 1046.044189, -19.481501, -2.661185, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(1209, 1073.297729, -22.484615, -5.116213, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1811, 1053.733154, -12.515923, -2.438893, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(1811, 1053.772583, -9.593957, -2.438893, 0.0000, 0.0000, 90.0001);
	CreateDynamicObject(2637, 1053.798828, -11.113306, -2.660457, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(976, 1055.960327, -11.123051, -8.253289, 0.0000, 270.6186, 0.0000);
	CreateDynamicObject(16501, 1056.449951, -11.077324, 1.060280, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(16501, 1056.741577, -11.079287, -3.414718, 90.2408, 0.0000, 270.0000);
	CreateDynamicObject(1495, 1058.481812, -11.107529, -3.071358, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(2596, 1053.160400, 4.437511, 4.619444, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(2596, 1053.160400, 5.234198, 4.623643, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(2596, 1053.160645, 6.030101, 4.619221, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(1998, 1054.443115, 2.799801, 3.286365, 0.0000, 0.0000, 90.0000);
	CreateDynamicObject(2356, 1054.582886, 3.891757, 3.281017, 0.0000, 0.0000, 123.7499);
	CreateDynamicObject(1726, 1063.516602, 6.829164, 3.278780, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(1726, 1063.516968, 2.748415, 3.278780, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(1459, 1066.610352, -19.934456, 3.550243, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(979, 1066.665527, -20.138449, 5.756526, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(934, 1068.131348, -35.772526, 3.617651, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(958, 1064.478027, -35.582848, 3.166209, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(3384, 1066.185669, -35.106964, 3.431977, 0.0000, 0.0000, 270.0000);
	CreateDynamicObject(939, 1071.612793, -22.564171, 4.735274, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(910, 1073.391968, -31.710217, 3.558527, 0.0000, 0.0000, 180.0000);
	CreateDynamicObject(1227, 1071.295654, -31.924141, 2.591092, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(1299, 1068.891479, -30.850557, 2.745232, 0.0000, 0.0000, 326.2500);
	CreateDynamicObject(979, 1066.346069, -20.166031, 3.536234, 0.0000, 0.0000, 0.0000);
	// Озеленение ЛС
	CreateDynamicObject(982,1307.1999500,-1829.4000200,13.2000000,0.0000000,358.0000000,0.0000000); //object(fenceshit)(1)
	CreateDynamicObject(982,86.1000000,103.2000000,498.7999900,0.0000000,0.0000000,0.0000000); //object(fenceshit)(3)
	CreateDynamicObject(982,1307.1999500,-1803.8000500,13.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit)(2)
	CreateDynamicObject(982,1307.1999500,-1778.1999500,13.2000000,0.0000000,0.2500000,0.0000000); //object(fenceshit)(4)
	CreateDynamicObject(1237,1307.0000000,-1842.5000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01)(1)
	CreateDynamicObject(1237,1306.6999500,-1843.3000500,12.5000000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01)(2)
	CreateDynamicObject(1237,1306.0999800,-1843.8000500,12.5000000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01)(3)
	CreateDynamicObject(1237,1305.5000000,-1844.1999500,12.5000000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01)(4)
	CreateDynamicObject(982,1302.8000500,-1829.4000200,13.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit)(5)
	CreateDynamicObject(1237,1304.6999500,-1844.1999500,12.5000000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01)(5)
	CreateDynamicObject(1237,1304.0000000,-1843.9000200,12.5000000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01)(6)
	CreateDynamicObject(1237,1303.3000500,-1843.4000200,12.5000000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01)(7)
	CreateDynamicObject(1237,1303.0000000,-1842.5999800,12.5000000,0.0000000,0.0000000,0.0000000); //object(strtbarrier01)(8)
	CreateDynamicObject(982,1302.8000500,-1803.8000500,13.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit)(6)
	CreateDynamicObject(982,1302.8000500,-1778.1999500,13.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit)(7)
	CreateDynamicObject(982,1302.8000500,-1752.5999800,13.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit)(8)
	CreateDynamicObject(982,1302.8000500,-1727.0000000,13.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit)(9)
	CreateDynamicObject(982,1302.9000200,-1701.5999800,13.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit)(10)
	CreateDynamicObject(983,1304.0000000,-1685.8000500,13.2000000,0.0000000,0.0000000,341.7500000); //object(fenceshit3)(1)
	CreateDynamicObject(982,1307.1999500,-1752.5999800,13.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit)(11)
	CreateDynamicObject(982,1307.0999800,-1727.0000000,13.2000000,0.0000000,0.0000000,0.5000000); //object(fenceshit)(12)
	CreateDynamicObject(982,1307.0000000,-1701.4000200,13.2000000,0.0000000,0.0000000,0.0000000); //object(fenceshit)(13)
	CreateDynamicObject(983,1306.0000000,-1685.5000000,13.2000000,0.0000000,0.0000000,18.0000000); //object(fenceshit3)(2)
	CreateDynamicObject(869,1304.8000500,-1722.0999800,13.0000000,0.0000000,0.0000000,2.0000000); //object(veg_pflowerswee)(1)
	CreateDynamicObject(864,1305.0000000,-1712.5999800,12.5000000,0.0000000,0.0000000,0.0000000); //object(sand_combush1)(1)
	CreateDynamicObject(862,1305.0000000,-1713.5000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sand_plant05)(1)
	CreateDynamicObject(861,1304.0000000,-1712.0000000,12.5000000,0.0000000,0.0000000,0.0000000); //object(sand_plant02)(1)
	CreateDynamicObject(859,1305.4000200,-1712.3000500,12.5000000,0.0000000,0.0000000,0.0000000); //object(sand_plant04)(1)
	CreateDynamicObject(857,1304.5999800,-1718.5999800,12.9000000,0.0000000,0.0000000,0.0000000); //object(procweegrs)(1)
	CreateDynamicObject(871,1305.0999800,-1716.4000200,12.8000000,0.0000000,0.0000000,0.0000000); //object(veg_procfpatchwee)(1)
	CreateDynamicObject(869,1305.0000000,-1726.0000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(2)
	CreateDynamicObject(862,1304.3000500,-1724.1999500,12.5000000,0.0000000,0.0000000,0.0000000); //object(sand_plant05)(2)
	CreateDynamicObject(862,1305.5000000,-1723.5999800,12.5000000,0.0000000,0.0000000,0.0000000); //object(sand_plant05)(3)
	CreateDynamicObject(869,1304.8000500,-1716.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(3)
	CreateDynamicObject(869,1304.9000200,-1743.8000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(4)
	CreateDynamicObject(869,1305.1999500,-1740.6999500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(5)
	CreateDynamicObject(869,1305.0999800,-1737.4000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(6)
	CreateDynamicObject(869,1305.1999500,-1733.9000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(7)
	CreateDynamicObject(869,1305.1999500,-1746.9000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(8)
	CreateDynamicObject(869,1305.0999800,-1750.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(9)
	CreateDynamicObject(869,1305.3000500,-1755.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(10)
	CreateDynamicObject(869,1305.4000200,-1758.6999500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(11)
	CreateDynamicObject(869,1305.1999500,-1762.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(12)
	CreateDynamicObject(869,1305.3000500,-1765.5999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(13)
	CreateDynamicObject(869,1305.0999800,-1769.0000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(14)
	CreateDynamicObject(869,1305.1999500,-1772.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(15)
	CreateDynamicObject(869,1305.3000500,-1775.5999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(16)
	CreateDynamicObject(869,1305.0999800,-1782.0999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(17)
	CreateDynamicObject(869,1305.1999500,-1784.9000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(18)
	CreateDynamicObject(869,1305.0999800,-1787.5000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(19)
	CreateDynamicObject(869,1305.1999500,-1790.0999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(20)
	CreateDynamicObject(869,1305.3000500,-1792.8000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(21)
	CreateDynamicObject(869,1305.1999500,-1795.6999500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(22)
	CreateDynamicObject(869,1305.3000500,-1798.4000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(23)
	CreateDynamicObject(869,1305.3000500,-1801.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(24)
	CreateDynamicObject(869,1305.3000500,-1804.0999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(25)
	CreateDynamicObject(869,1305.1999500,-1806.5999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(26)
	CreateDynamicObject(869,1305.3000500,-1810.9000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(27)
	CreateDynamicObject(869,1305.3000500,-1813.5999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(28)
	CreateDynamicObject(869,1305.4000200,-1816.1999500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(29)
	CreateDynamicObject(869,1305.3000500,-1819.0000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(30)
	CreateDynamicObject(869,1305.4000200,-1821.8000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(31)
	CreateDynamicObject(869,1305.3000500,-1824.5000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(32)
	CreateDynamicObject(869,1305.1999500,-1827.6999500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(33)
	CreateDynamicObject(869,1305.1999500,-1830.8000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(34)
	CreateDynamicObject(869,1305.4000200,-1833.5999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(35)
	CreateDynamicObject(869,1305.3000500,-1836.5999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(36)
	CreateDynamicObject(869,1305.3000500,-1719.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(37)
	CreateDynamicObject(869,1305.0000000,-1713.5000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(38)
	CreateDynamicObject(869,1305.0000000,-1710.4000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(39)
	CreateDynamicObject(869,1305.0999800,-1707.5000000,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(40)
	CreateDynamicObject(869,1304.9000200,-1704.9000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(41)
	CreateDynamicObject(869,1305.0999800,-1701.4000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(42)
	CreateDynamicObject(869,1305.1999500,-1698.8000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(43)
	CreateDynamicObject(869,1304.9000200,-1694.1999500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(44)
	CreateDynamicObject(869,1304.9000200,-1691.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(45)
	CreateDynamicObject(869,1305.0999800,-1688.5999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowerswee)(46)
	CreateDynamicObject(1290,1305.1999500,-1774.4000200,18.6000000,0.0000000,0.0000000,4.0000000); //object(lamppost2)(1)
	CreateDynamicObject(1290,1305.0999800,-1815.9000200,18.6000000,0.0000000,0.0000000,0.0000000); //object(lamppost2)(2)
	CreateDynamicObject(1290,1305.0000000,-1832.9000200,18.6000000,0.0000000,0.0000000,0.0000000); //object(lamppost2)(3)
	CreateDynamicObject(1290,1305.0000000,-1803.4000200,18.6000000,0.0000000,0.0000000,0.0000000); //object(lamppost2)(4)
	CreateDynamicObject(1290,1304.9000200,-1787.5000000,18.6000000,0.0000000,0.0000000,0.0000000); //object(lamppost2)(5)
	CreateDynamicObject(1290,1305.1999500,-1758.9000200,18.6000000,0.0000000,0.0000000,0.0000000); //object(lamppost2)(6)
	CreateDynamicObject(1290,1304.5000000,-1723.0999800,18.6000000,0.0000000,0.0000000,0.0000000); //object(lamppost2)(7)
	CreateDynamicObject(1290,1304.6999500,-1733.5999800,18.6000000,0.0000000,0.0000000,0.0000000); //object(lamppost2)(8)
	CreateDynamicObject(1290,1304.5999800,-1748.5999800,18.6000000,0.0000000,0.0000000,0.0000000); //object(lamppost2)(9)
	CreateDynamicObject(1568,1468.4000200,-1708.9000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(1)
	CreateDynamicObject(1568,1489.0999800,-1708.5999800,13.0000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(2)
	CreateDynamicObject(1568,1488.9000200,-1698.9000200,13.0000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(3)
	CreateDynamicObject(1568,1468.3000500,-1699.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(4)
	CreateDynamicObject(1568,1468.5000000,-1688.1999500,13.0000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(5)
	CreateDynamicObject(1568,1489.0999800,-1687.6999500,13.0000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(6)
	CreateDynamicObject(1363,1469.0000000,-1701.0000000,13.9000000,0.0000000,0.0000000,324.0000000); //object(cj_phone_kiosk)(1)
	CreateDynamicObject(738,1474.0000000,-1712.9000200,13.3000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(1)
	CreateDynamicObject(738,1473.6992200,-1697.6992200,13.3000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(2)
	CreateDynamicObject(738,1473.9000200,-1687.8000500,13.3000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(3)
	CreateDynamicObject(738,1485.5000000,-1711.5000000,13.3000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(4)
	CreateDynamicObject(738,1485.5000000,-1700.3000500,13.3000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(5)
	CreateDynamicObject(738,1485.6999500,-1688.3000500,13.3000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(6)
	CreateDynamicObject(877,1461.8000500,-1697.0000000,15.3000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowers04)(1)
	CreateDynamicObject(877,1495.4000200,-1701.8000500,15.3000000,0.0000000,0.0000000,338.0000000); //object(veg_pflowers04)(2)
	CreateDynamicObject(1364,1468.5999800,-1705.1999500,13.8000000,0.0000000,0.0000000,90.0000000); //object(cj_bush_prop)(1)
	CreateDynamicObject(1364,1468.5999800,-1712.5999800,13.8000000,0.0000000,0.0000000,90.0000000); //object(cj_bush_prop)(2)
	CreateDynamicObject(1364,1468.6999500,-1694.0999800,13.8000000,0.0000000,0.0000000,90.0000000); //object(cj_bush_prop)(3)
	CreateDynamicObject(1364,1468.5000000,-1684.0000000,13.8000000,0.0000000,0.0000000,90.0000000); //object(cj_bush_prop)(4)
	CreateDynamicObject(1364,1488.6999500,-1712.6999500,13.8000000,0.0000000,0.0000000,270.0000000); //object(cj_bush_prop)(5)
	CreateDynamicObject(1364,1488.6999500,-1703.0999800,13.8000000,0.0000000,0.0000000,270.0000000); //object(cj_bush_prop)(6)
	CreateDynamicObject(1364,1488.5999800,-1693.0999800,13.8000000,0.0000000,0.0000000,270.0000000); //object(cj_bush_prop)(7)
	CreateDynamicObject(1364,1488.5000000,-1683.5999800,13.8000000,0.0000000,0.0000000,272.0000000); //object(cj_bush_prop)(8)
	CreateDynamicObject(1597,1479.6999500,-1685.4000200,15.7000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1)(2)
	CreateDynamicObject(1597,1479.5999800,-1695.3000500,15.7000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1)(3)
	CreateDynamicObject(1597,1479.5000000,-1705.0999800,15.7000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1)(4)
	CreateDynamicObject(738,1438.5999800,-1714.9000200,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(7)
	CreateDynamicObject(737,1438.5999800,-1706.1999500,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree3)(1)
	CreateDynamicObject(737,1413.5000000,-1718.0000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree3)(2)
	CreateDynamicObject(738,1415.8000500,-1713.5000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(8)
	CreateDynamicObject(3505,1417.3000500,-1719.3000500,12.5000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y01)(1)
	CreateDynamicObject(1568,1495.5999800,-1749.8000500,14.4000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(7)
	CreateDynamicObject(1568,1489.5000000,-1750.3000500,14.4000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(8)
	CreateDynamicObject(1568,1483.9000200,-1750.4000200,14.4000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(9)
	CreateDynamicObject(1568,1478.5000000,-1750.4000200,14.4000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(10)
	CreateDynamicObject(1568,1473.0000000,-1750.4000200,14.4000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(11)
	CreateDynamicObject(1568,1467.3000500,-1749.9000200,14.4000000,0.0000000,0.0000000,0.0000000); //object(chinalamp_sf)(12)
	CreateDynamicObject(738,1438.6999500,-1697.0000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(9)
	CreateDynamicObject(737,1438.5000000,-1687.1999500,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree3)(3)
	CreateDynamicObject(737,1421.6999500,-1689.0000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree3)(4)
	CreateDynamicObject(738,1421.8000500,-1677.0999800,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(10)
	CreateDynamicObject(738,1421.8000500,-1666.8000500,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(11)
	CreateDynamicObject(738,1521.5000000,-1712.4000200,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(12)
	CreateDynamicObject(738,1521.3000500,-1699.3000500,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(13)
	CreateDynamicObject(738,1521.1999500,-1681.0000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(14)
	CreateDynamicObject(737,1521.1999500,-1662.1999500,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree3)(5)
	CreateDynamicObject(737,1177.3000500,-1724.6999500,13.0000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree3)(6)
	CreateDynamicObject(738,1177.3000500,-1740.5000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(aw_streettree2)(15)
	CreateDynamicObject(1597,1177.1999500,-1750.6999500,15.2000000,0.0000000,0.0000000,0.0000000); //object(cntrlrsac1)(1)
	CreateDynamicObject(1215,1322.6999500,-1732.3000500,12.9000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(1)
	CreateDynamicObject(1215,1389.0999800,-1742.3000500,12.9000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(2)
	CreateDynamicObject(1215,1429.5999800,-1722.0999800,12.9000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(3)
	CreateDynamicObject(1215,1529.5000000,-1722.1999500,12.9000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(4)
	CreateDynamicObject(1215,1569.5000000,-1742.4000200,12.9000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(5)
	CreateDynamicObject(1215,1679.3000500,-1732.3000500,12.9000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(6)
	CreateDynamicObject(1215,1699.5999800,-1732.3000500,12.9000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(7)
	CreateDynamicObject(1215,1811.3000500,-1732.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(8)
	CreateDynamicObject(1215,1811.5000000,-1832.3000500,13.0000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(9)
	CreateDynamicObject(1337,1721.0205100,-1854.3408200,13.0793000,0.0000000,0.0000000,0.0000000); //object(binnt07_la)(1)
	CreateDynamicObject(1337,1721.0206300,-1854.3409400,13.0793000,0.0000000,0.0000000,0.0000000); //object(binnt07_la)(2)
	// Респаун
	CreateDynamicObject(19122,1335.9570312,-1865.3239746,13.1110001,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (1)
	CreateDynamicObject(19123,1331.0080566,-1863.4239502,13.1110001,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (2)
	CreateDynamicObject(19125,1336.9479980,-1861.2569580,13.1110001,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (1)
	CreateDynamicObject(19124,1332.5000000,-1859.4930420,13.1110001,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (2)
	CreateDynamicObject(19126,1331.6379395,-1861.5639648,13.1110001,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (1)
	CreateDynamicObject(19121,1336.3509521,-1863.4659424,13.1110001,0.0000000,0.0000000,0.0000000); //object(bollardlight1) (1)
	CreateDynamicObject(18739,1336.1440430,-1864.4880371,12.5970001,0.0000000,0.0000000,0.0000000); //object(water_fountain) (1)
	CreateDynamicObject(18739,1336.5729980,-1862.4770508,12.5970001,0.0000000,0.0000000,0.0000000); //object(water_fountain) (2)
	CreateDynamicObject(18739,1331.9969482,-1860.5520020,12.5970001,0.0000000,0.0000000,0.0000000); //object(water_fountain) (3)
	CreateDynamicObject(18739,1331.3299561,-1862.6099854,12.5970001,0.0000000,0.0000000,0.0000000); //object(water_fountain) (4)
	CreateObject(19358,1116.3769531,-1795.6820068,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (1)
	CreateObject(19358,1116.3919678,-1792.5959473,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (2)
	CreateObject(19358,1116.4040527,-1789.3979492,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (3)
	CreateObject(19358,1116.3890381,-1783.0589600,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (6)
	CreateObject(19358,1116.3769531,-1779.8869629,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (7)
	CreateObject(19358,1116.3759766,-1776.6779785,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (8)
	CreateObject(19358,1116.3709717,-1773.4630127,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (9)
	CreateObject(19358,1116.3740234,-1770.2900391,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (10)
	CreateObject(19358,1150.4990234,-1795.7060547,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (13)
	CreateObject(19358,1150.5078125,-1792.5292969,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (14)
	CreateObject(19358,1150.5169678,-1789.4229736,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (15)
	CreateObject(19358,1150.5100098,-1786.2340088,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (16)
	CreateObject(19358,1150.5156250,-1783.0849609,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (17)
	CreateObject(19358,1150.5040283,-1779.8790283,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (18)
	CreateObject(19358,1150.5050049,-1776.6710205,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (19)
	CreateObject(19358,1150.4980469,-1773.4890137,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (20)
	CreateObject(19358,1150.4919434,-1770.2819824,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (21)
	CreateObject(19358,1149.9589844,-1768.9139404,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (22)
	CreateObject(19358,1146.7819824,-1768.9150391,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (23)
	CreateObject(19358,1143.5957031,-1768.9160156,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (24)
	CreateObject(19358,1137.2060547,-1768.9179688,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (26)
	CreateObject(19358,1134.0040283,-1768.9189453,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (27)
	CreateObject(19358,1130.7900391,-1768.9200439,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (28)
	CreateObject(19358,1127.5760498,-1768.9210205,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (29)
	CreateObject(19358,1124.3909912,-1768.9219971,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (30)
	CreateObject(19358,1121.2031250,-1768.9228516,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (31)
	CreateObject(19358,1117.9909668,-1768.9210205,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (32)
	CreateObject(19358,1118.0290527,-1797.2139893,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (33)
	CreateObject(19358,1121.1540527,-1797.2120361,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (34)
	CreateObject(19358,1124.3249512,-1797.2130127,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (35)
	CreateObject(19358,1127.5159912,-1797.2099609,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (36)
	CreateObject(19358,1130.7139893,-1797.2030029,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (37)
	CreateObject(19358,1133.8719482,-1797.1949463,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (38)
	CreateObject(19358,1137.0670166,-1797.1879883,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (39)
	CreateObject(19358,1140.2690430,-1797.1800537,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (40)
	CreateObject(19358,1143.4300537,-1797.1949463,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (41)
	CreateObject(19358,1146.5999756,-1797.1870117,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (42)
	CreateObject(19358,1149.7020264,-1797.1789551,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (43)
	CreateObject(19378,1145.2998047,-1793.0000000,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (1)
	CreateObject(19378,1145.3994141,-1783.3779297,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (2)
	CreateObject(19378,1134.7998047,-1793.0996094,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (3)
	CreateObject(19378,1134.8994141,-1783.5000000,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (4)
	CreateObject(19378,1134.8994141,-1773.8994141,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (5)
	CreateObject(19378,1145.3994141,-1773.7998047,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (6)
	CreateObject(19378,1124.2998047,-1793.0996094,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (7)
	CreateObject(19378,1124.3994141,-1783.4599609,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (8)
	CreateObject(19378,1124.3994141,-1773.8199463,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (9)
	CreateObject(19378,1113.7998047,-1793.0996094,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (10)
	CreateObject(19378,1113.8994141,-1783.4492188,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (11)
	CreateObject(19378,1113.8994141,-1773.7998047,-97.3000031,0.0000000,90.0000000,0.0000000); //object(wall026) (12)
	CreateObject(19388,1116.3929443,-1786.2679443,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall036) (1)
	CreateObject(1555,1116.4790039,-1785.4870605,-97.1999969,0.0000000,0.0000000,270.0000000); //object(gen_doorext17) (1)
	CreateObject(19358,1116.1999512,-1786.3000488,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (44)
	CreateObject(1726,1148.3349609,-1769.6710205,-97.2139969,0.0000000,0.0000000,315.0000000); //object(mrk_seating2) (1)
	CreateObject(1726,1145.7239990,-1769.4880371,-97.2139969,0.0000000,0.0000000,0.0000000); //object(mrk_seating2) (2)
	CreateObject(1726,1149.9880371,-1771.5889893,-97.2139969,0.0000000,0.0000000,270.0000000); //object(mrk_seating2) (4)
	CreateObject(1727,1142.9659424,-1769.5870361,-97.2139969,0.0000000,0.0000000,0.0000000); //object(mrk_seating2b) (1)
	CreateObject(1727,1149.8559570,-1775.1440430,-97.2139969,0.0000000,0.0000000,270.0000000); //object(mrk_seating2b) (2)
	CreateObject(1827,1147.3299561,-1771.9570312,-97.2139969,0.0000000,0.0000000,0.0000000); //object(man_sdr_tables) (1)
	CreateObject(19358,1140.1445312,-1770.5419922,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (25)
	CreateObject(19358,1140.1650391,-1776.9248047,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (25)
	CreateObject(19358,1141.8505859,-1778.4501953,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(19358,1148.2460938,-1778.4501953,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(19358,1151.4000244,-1778.4499512,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(1738,1144.7519531,-1769.0019531,-96.5589981,0.0000000,0.0000000,0.0000000); //object(cj_radiator_old) (1)
	CreateObject(1738,1150.4189453,-1777.5080566,-96.5589981,0.0000000,0.0000000,90.0000000); //object(cj_radiator_old) (2)
	CreateObject(19358,1140.3919678,-1768.9100342,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (24)
	CreateObject(949,1140.5329590,-1769.3990479,-96.5780029,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (1)
	CreateObject(949,1141.3709717,-1769.3599854,-96.5780029,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (3)
	CreateObject(949,1142.3110352,-1769.3070068,-96.5780029,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (4)
	CreateObject(949,1144.8110352,-1769.5429688,-96.5780029,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (5)
	CreateObject(949,1149.9990234,-1774.4079590,-96.5780029,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (6)
	CreateObject(949,1150.1319580,-1776.7459717,-96.5780029,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (7)
	CreateObject(949,1150.1059570,-1778.0760498,-96.5780029,0.0000000,0.0000000,0.0000000); //object(plant_pot_4) (8)
	CreateObject(19388,1140.1479492,-1773.7359619,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall036) (2)
	CreateObject(19358,1140.0009766,-1795.5190430,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (25)
	CreateObject(19358,1139.9940186,-1792.3189697,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (25)
	CreateObject(19358,1139.9699707,-1789.1120605,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (25)
	CreateObject(19358,1138.4530029,-1787.6030273,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(19358,1132.0949707,-1787.5849609,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(19358,1125.7530518,-1787.5620117,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(19358,1119.4300537,-1787.5400391,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(19358,1116.6560059,-1787.5419922,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(19388,1135.2390137,-1787.5959473,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall036) (3)
	CreateObject(19404,1128.9219971,-1787.5710449,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall052) (1)
	CreateObject(19404,1122.5439453,-1787.5589600,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall052) (2)
	CreateObject(19358,1144.8470459,-1787.6080322,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(19358,1150.4239502,-1787.5939941,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall006) (25)
	CreateObject(19358,1144.7659912,-1789.2340088,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (25)
	CreateObject(19388,1141.6540527,-1787.6070557,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall036) (4)
	CreateObject(19358,1144.7729492,-1792.4229736,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (25)
	CreateObject(19358,1144.7850342,-1795.6240234,-95.5019989,0.0000000,0.0000000,0.0000000); //object(wall006) (25)
	CreateObject(19388,1147.8239746,-1787.5930176,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall036) (5)
	CreateObject(19404,1145.0539551,-1778.4530029,-95.5019989,0.0000000,0.0000000,90.0000000); //object(wall052) (3)
	CreateObject(2738,1149.8680420,-1796.7010498,-96.6110001,0.0000000,0.0000000,180.0000000); //object(cj_toilet_bs) (1)
	CreateObject(2738,1148.6169434,-1796.6770020,-96.6110001,0.0000000,0.0000000,179.9945068); //object(cj_toilet_bs) (2)
	CreateObject(2738,1147.3709717,-1796.8430176,-96.6110001,0.0000000,0.0000000,179.9945068); //object(cj_toilet_bs) (3)
	CreateObject(2738,1146.2779541,-1796.6619873,-96.6110001,0.0000000,0.0000000,179.9945068); //object(cj_toilet_bs) (4)
	CreateObject(2738,1145.2239990,-1796.7459717,-96.6110001,0.0000000,0.0000000,179.9945068); //object(cj_toilet_bs) (5)
	CreateObject(2739,1145.3780518,-1793.5240479,-97.2139969,0.0000000,0.0000000,90.0000000); //object(cj_b_sink1) (1)
	CreateObject(2739,1145.3559570,-1792.1660156,-97.2139969,0.0000000,0.0000000,90.0000000); //object(cj_b_sink1) (2)
	CreateObject(2739,1145.3809814,-1790.8599854,-97.2139969,0.0000000,0.0000000,90.0000000); //object(cj_b_sink1) (3)
	CreateObject(2742,1144.8520508,-1789.4260254,-95.8199997,0.0000000,0.0000000,90.0000000); //object(cj_handdrier) (1)
	CreateObject(2833,1147.0749512,-1772.3709717,-97.2139969,0.0000000,0.0000000,0.0000000); //object(gb_livingrug02) (1)
	CreateObject(2834,1146.9949951,-1773.6910400,-97.2139969,0.0000000,0.0000000,0.0000000); //object(gb_livingrug03) (2)
	CreateObject(2834,1147.0150146,-1770.9029541,-97.2139969,0.0000000,0.0000000,0.0000000); //object(gb_livingrug03) (4)
	CreateObject(1812,1117.0080566,-1790.1679688,-97.2139969,0.0000000,0.0000000,0.0000000); //object(low_bed_5) (1)
	CreateObject(1812,1119.0410156,-1790.2010498,-97.2139969,0.0000000,0.0000000,0.0000000); //object(low_bed_5) (2)
	CreateObject(1812,1121.0660400,-1790.1259766,-97.2139969,0.0000000,0.0000000,0.0000000); //object(low_bed_5) (3)
	CreateObject(1812,1124.3409424,-1790.2149658,-97.2139969,0.0000000,0.0000000,0.0000000); //object(low_bed_5) (4)
	CreateObject(1812,1127.4780273,-1790.2180176,-97.2139969,0.0000000,0.0000000,0.0000000); //object(low_bed_5) (5)
	CreateObject(1812,1125.8850098,-1790.1569824,-97.2139969,0.0000000,0.0000000,0.0000000); //object(low_bed_5) (6)
	CreateObject(1812,1130.5200195,-1790.2619629,-97.2139969,0.0000000,0.0000000,0.0000000); //object(low_bed_5) (7)
	CreateObject(1812,1132.3659668,-1790.2399902,-97.2139969,0.0000000,0.0000000,0.0000000); //object(low_bed_5) (8)
	CreateObject(1812,1116.9610596,-1794.6409912,-97.2139969,0.0000000,0.0000000,180.0000000); //object(low_bed_5) (9)
	CreateObject(1812,1119.0069580,-1794.4699707,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (10)
	CreateObject(1812,1121.1340332,-1794.4709473,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (11)
	CreateObject(1812,1123.0550537,-1794.5579834,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (12)
	CreateObject(1812,1124.9949951,-1794.5040283,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (13)
	CreateObject(1812,1126.8669434,-1794.5019531,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (14)
	CreateObject(1812,1129.2249756,-1794.5429688,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (15)
	CreateObject(1812,1131.2390137,-1794.5889893,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (17)
	CreateObject(1812,1133.2340088,-1794.5780029,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (18)
	CreateObject(1812,1135.1750488,-1794.5639648,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (19)
	CreateObject(1812,1137.2850342,-1794.5889893,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (20)
	CreateObject(1812,1139.4200439,-1794.6159668,-97.2139969,0.0000000,0.0000000,179.9945068); //object(low_bed_5) (21)
	CreateObject(1778,1150.1739502,-1787.6800537,-97.1729965,0.0000000,0.0000000,0.0000000); //object(cj_mop_pail) (1)
	CreateObject(1778,1144.4489746,-1787.6939697,-97.1620026,0.0000000,0.0000000,0.0000000); //object(cj_mop_pail) (2)
	CreateObject(2275,1120.4310303,-1769.5200195,-96.3470001,0.0000000,0.0000000,0.0000000); //object(frame_fab_4) (1)
	CreateObject(1502,1140.0849609,-1772.9630127,-97.1999969,0.0000000,0.0000000,270.0000000); //object(gen_doorint04) (1)
	CreateObject(1502,1134.4659424,-1787.5529785,-97.1859970,0.0000000,0.0000000,0.0000000); //object(gen_doorint04) (2)
	CreateObject(2763,1116.9909668,-1769.5909424,-96.8089981,0.0000000,0.0000000,0.0000000); //object(cj_chick_table_2) (1)
	CreateObject(2309,1117.0050049,-1771.1910400,-97.2139969,0.0000000,0.0000000,0.0000000); //object(med_office_chair2) (1)
	CreateObject(2309,1118.5529785,-1769.5689697,-97.2139969,0.0000000,0.0000000,90.0000000); //object(med_office_chair2) (2)
	CreateObject(2309,1119.0469971,-1769.5400391,-97.2139969,0.0000000,0.0000000,270.0000000); //object(med_office_chair2) (3)
	CreateObject(2763,1120.5169678,-1769.6230469,-96.8089981,0.0000000,0.0000000,0.0000000); //object(cj_chick_table_2) (2)
	CreateObject(2309,1122.0589600,-1769.4940186,-97.2139969,0.0000000,0.0000000,90.0000000); //object(med_office_chair2) (4)
	CreateObject(2309,1120.5229492,-1771.1049805,-97.2139969,0.0000000,0.0000000,0.0000000); //object(med_office_chair2) (5)
	CreateObject(2309,1116.9799805,-1771.5389404,-97.2139969,0.0000000,0.0000000,180.0000000); //object(med_office_chair2) (6)
	CreateObject(2763,1117.0040283,-1773.1459961,-96.8089981,0.0000000,0.0000000,0.0000000); //object(cj_chick_table_2) (3)
	CreateObject(2309,1118.3769531,-1772.9909668,-97.2139969,0.0000000,0.0000000,90.0000000); //object(med_office_chair2) (7)
	CreateObject(2309,1116.9229736,-1774.5100098,-97.2139969,0.0000000,0.0000000,0.0000000); //object(med_office_chair2) (8)
	CreateObject(2309,1120.2259521,-1774.5510254,-97.2139969,0.0000000,0.0000000,0.0000000); //object(med_office_chair2) (9)
	CreateObject(2309,1120.5190430,-1771.5000000,-97.2139969,0.0000000,0.0000000,179.9945068); //object(med_office_chair2) (10)
	CreateObject(2763,1120.3869629,-1773.0870361,-96.8089981,0.0000000,0.0000000,0.0000000); //object(cj_chick_table_2) (4)
	CreateObject(2309,1119.0169678,-1772.9799805,-97.2139969,0.0000000,0.0000000,269.9945068); //object(med_office_chair2) (11)
	CreateObject(2309,1121.8199463,-1773.1009521,-97.2139969,0.0000000,0.0000000,90.0000000); //object(med_office_chair2) (12)
	CreateObject(1502,1142.3879395,-1787.5209961,-97.1890030,0.0000000,0.0000000,180.0000000); //object(gen_doorint04) (3)
	CreateObject(1502,1147.0529785,-1787.5939941,-97.2139969,0.0000000,0.0000000,0.0000000); //object(gen_doorint04) (4)
	CreateObject(2738,1144.3270264,-1796.8349609,-96.6110001,0.0000000,0.0000000,179.9945068); //object(cj_toilet_bs) (6)
	CreateObject(2738,1143.1710205,-1796.8070068,-96.6110001,0.0000000,0.0000000,179.9945068); //object(cj_toilet_bs) (7)
	CreateObject(2738,1142.0140381,-1796.6600342,-96.6110001,0.0000000,0.0000000,179.9945068); //object(cj_toilet_bs) (8)
	CreateObject(2738,1140.8149414,-1796.7380371,-96.6110001,0.0000000,0.0000000,179.9945068); //object(cj_toilet_bs) (9)
	CreateObject(2742,1144.6610107,-1789.4449463,-95.8020020,0.0000000,0.0000000,270.0000000); //object(cj_handdrier) (2)
	CreateObject(2739,1144.0780029,-1790.0660400,-97.2139969,0.0000000,0.0000000,270.0000000); //object(cj_b_sink1) (4)
	CreateObject(2739,1144.1550293,-1791.3310547,-97.2139969,0.0000000,0.0000000,269.9945068); //object(cj_b_sink1) (5)
	CreateObject(2739,1144.1369629,-1792.9019775,-97.2139969,0.0000000,0.0000000,269.9945068); //object(cj_b_sink1) (6)
	CreateObject(2821,1116.6070557,-1769.2209473,-96.3909988,0.0000000,0.0000000,0.0000000); //object(gb_foodwrap01) (1)
	CreateObject(18981,1128.9000244,-1784.6999512,-93.3000031,0.0000000,90.0000000,0.0000000); //object(concrete1mx25mx25m) (1)
	CreateObject(18981,1138.7879639,-1784.9000244,-93.3000031,0.0000000,90.0000000,0.0000000); //object(concrete1mx25mx25m) (2)
	CreateObject(18981,1138.0000000,-1781.1330566,-93.3000031,0.0000000,90.0000000,0.0000000); //object(concrete1mx25mx25m) (3)
	CreateObject(18981,1120.0860596,-1780.8759766,-93.3000031,0.0000000,90.0000000,0.0000000); //object(concrete1mx25mx25m) (4)
	CreateObject(1808,1127.3339844,-1769.1359863,-97.2139969,0.0000000,0.0000000,0.0000000); //object(cj_watercooler2) (1)
	CreateObject(627,1139.4339600,-1772.5360107,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (1)
	CreateObject(627,1139.5920410,-1775.0069580,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (2)
	CreateObject(627,1139.6440430,-1769.5620117,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (3)
	CreateObject(627,1149.9389648,-1779.2049561,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (4)
	CreateObject(627,1149.8540039,-1787.0579834,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (5)
	CreateObject(627,1146.5450439,-1786.8330078,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (6)
	CreateObject(627,1142.9479980,-1786.8399658,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (7)
	CreateObject(627,1140.4079590,-1787.0229492,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (8)
	CreateObject(627,1136.5419922,-1786.9790039,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (9)
	CreateObject(627,1133.9420166,-1787.0849609,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (10)
	CreateObject(627,1130.4439697,-1787.0799561,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (11)
	CreateObject(627,1127.5109863,-1787.0539551,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (12)
	CreateObject(627,1124.0219727,-1786.7969971,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (14)
	CreateObject(627,1121.1120605,-1786.8959961,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (15)
	CreateObject(627,1117.1669922,-1784.9870605,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (16)
	CreateObject(627,1116.7729492,-1787.4090576,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (17)
	CreateObject(627,1122.9840088,-1769.5000000,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (18)
	CreateObject(627,1126.4219971,-1769.6850586,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (19)
	CreateObject(627,1128.5830078,-1769.6610107,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (20)
	CreateObject(627,1149.8570557,-1769.5679932,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (21)
	CreateObject(627,1140.8780518,-1774.9360352,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (22)
	CreateObject(627,1140.8339844,-1772.5849609,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (23)
	CreateObject(627,1134.1459961,-1788.1949463,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (24)
	CreateObject(627,1136.4670410,-1788.1180420,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (25)
	CreateObject(1761,1136.6049805,-1769.5839844,-97.2139969,0.0000000,0.0000000,0.0000000); //object(swank_couch_2) (1)
	CreateObject(1761,1129.4310303,-1769.4250488,-97.2139969,0.0000000,0.0000000,0.0000000); //object(swank_couch_2) (2)
	CreateObject(1761,1133.0589600,-1769.4189453,-97.2139969,0.0000000,0.0000000,0.0000000); //object(swank_couch_2) (3)
	CreateObject(1761,1139.5649414,-1775.9479980,-97.2139969,0.0000000,0.0000000,270.0000000); //object(swank_couch_2) (4)
	CreateObject(1761,1139.4040527,-1787.1629639,-97.2139969,0.0000000,0.0000000,180.0000000); //object(swank_couch_2) (6)
	CreateObject(1761,1133.1479492,-1787.0350342,-97.2139969,0.0000000,0.0000000,179.9945068); //object(swank_couch_2) (7)
	CreateObject(1761,1126.6829834,-1786.9739990,-97.2139969,0.0000000,0.0000000,179.9945068); //object(swank_couch_2) (8)
	CreateObject(1761,1123.6379395,-1769.4429932,-97.2139969,0.0000000,0.0000000,0.0000000); //object(swank_couch_2) (10)
	CreateObject(1767,1139.4449463,-1770.6159668,-97.2139969,0.0000000,0.0000000,270.0000000); //object(med_single_1) (1)
	CreateObject(1761,1145.6820068,-1786.9150391,-97.2139969,0.0000000,0.0000000,179.9945068); //object(swank_couch_2) (11)
	CreateObject(1761,1149.8869629,-1780.0550537,-97.2139969,0.0000000,0.0000000,270.0000000); //object(swank_couch_2) (12)
	CreateObject(1761,1149.8790283,-1784.0739746,-97.2139969,0.0000000,0.0000000,269.9945068); //object(swank_couch_2) (13)
	CreateObject(627,1150.0100098,-1783.1560059,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (28)
	CreateObject(1761,1146.8149414,-1778.9630127,-97.2139969,0.0000000,0.0000000,0.0000000); //object(swank_couch_2) (14)
	CreateObject(1761,1141.2170410,-1779.1459961,-97.2139969,0.0000000,0.0000000,0.0000000); //object(swank_couch_2) (15)
	CreateObject(627,1146.0899658,-1778.8869629,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (29)
	CreateObject(627,1144.0450439,-1778.8680420,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (30)
	CreateObject(627,1140.1639404,-1779.0980225,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (31)
	CreateObject(627,1132.3079834,-1769.5040283,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (32)
	CreateObject(627,1135.8909912,-1769.4090576,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (33)
	CreateObject(19325,1127.3570557,-1787.4840088,-95.1510010,0.0000000,0.0000000,270.0000000); //object(lsmall_window01) (3)
	CreateObject(19325,1122.0040283,-1787.4730225,-95.1510010,0.0000000,0.0000000,269.9945068); //object(lsmall_window01) (4)
	CreateObject(19325,1145.4520264,-1778.5379639,-95.1510010,0.0000000,0.0000000,269.9945068); //object(lsmall_window01) (5)
	CreateObject(627,1143.7719727,-1777.8060303,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (34)
	CreateObject(627,1146.5939941,-1777.7989502,-95.3690033,0.0000000,0.0000000,0.0000000); //object(veg_palmkb3) (35)
	CreateObject(1494,1116.44,-1778.97,-97.20,0.00,0.00,-90.00);
	// Ухо
	CreateDynamicObject(978,-316.3049927,1507.1219482,75.4029999,0.0000000,0.0000000,179.9945068); //object(sub_roadright) (2)
	CreateDynamicObject(978,-325.6740112,1507.1169434,75.4029999,0.0000000,0.0000000,179.9945068); //object(sub_roadright) (3)
	CreateDynamicObject(978,-335.0109863,1507.0970459,75.4069977,0.0000000,0.0000000,179.9945068); //object(sub_roadright) (4)
	CreateDynamicObject(979,-290.8210144,1511.3439941,75.4029999,0.0000000,0.0000000,221.9952393); //object(sub_roadleft) (2)
	CreateDynamicObject(979,-283.8810120,1517.5839844,75.4029999,0.0000000,0.0000000,221.9952393); //object(sub_roadleft) (3)
	CreateDynamicObject(18761,-302.2950134,1506.8609619,79.3769989,0.0000000,0.0000000,180.0000000); //object(racefinishline1) (1)
	CreateDynamicObject(979,-276.9228516,1523.8515625,75.4029999,0.0000000,0.0000000,221.9897461); //object(sub_roadleft) (15)
	CreateDynamicObject(978,-344.3599854,1507.1340332,75.3919983,0.0000000,0.0000000,179.9945068); //object(sub_roadright) (4)
	CreateDynamicObject(978,-344.3599854,1507.1340332,75.3919983,0.0000000,0.0000000,179.9945068); //object(sub_roadright) (4)
	CreateDynamicObject(978,-353.7279968,1507.1540527,75.3840027,0.0000000,0.0000000,179.9945068); //object(sub_roadright) (4)
	CreateDynamicObject(979,-269.9739990,1530.1209717,75.4029999,0.0000000,0.0000000,221.9897461); //object(sub_roadleft) (15)
	CreateDynamicObject(979,-263.0039978,1536.3869629,75.4029999,0.0000000,0.0000000,221.9897461); //object(sub_roadleft) (15)
	CreateDynamicObject(19122,-258.9509888,1542.9040527,75.1320038,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (1)
	CreateDynamicObject(19123,-310.1619873,1506.7230225,75.1299973,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (2)
	CreateDynamicObject(19123,-294.8500061,1506.7270508,75.1800003,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (5)
	CreateDynamicObject(19122,-260.8510132,1544.6760254,75.1019974,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (2)
	CreateDynamicObject(19122,-263.3410034,1547.1390381,75.1029968,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (3)
	CreateDynamicObject(19122,-265.8819885,1549.6889648,75.1019974,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (4)
	CreateDynamicObject(19122,-268.2120056,1552.0260010,75.1009979,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (5)
	CreateDynamicObject(19122,-270.6969910,1554.6309814,75.0920029,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (6)
	CreateDynamicObject(19122,-273.1329956,1557.0749512,75.0910034,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (7)
	CreateDynamicObject(19122,-275.6740112,1559.6250000,75.0889969,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (8)
	CreateDynamicObject(19122,-278.1040039,1562.0739746,75.0950012,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (9)
	CreateDynamicObject(19122,-280.5390015,1564.5179443,75.0940018,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (10)
	CreateDynamicObject(19122,-282.9739990,1566.9630127,75.0940018,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (11)
	CreateDynamicObject(19122,-285.6199951,1569.6199951,75.0930023,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (12)
	CreateDynamicObject(19122,-288.0549927,1572.0639648,75.0930023,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (13)
	CreateDynamicObject(19122,-290.4899902,1574.5080566,75.0920029,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (14)
	CreateDynamicObject(19122,-292.9249878,1576.9530029,75.0920029,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (15)
	CreateDynamicObject(19122,-295.4280090,1579.5400391,75.1360016,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (16)
	CreateDynamicObject(19122,-297.7560120,1581.8790283,75.1360016,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (17)
	CreateDynamicObject(19122,-300.3739929,1584.5059814,75.1360016,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (18)
	CreateDynamicObject(19122,-303.5490112,1587.6290283,75.1330032,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (19)
	CreateDynamicObject(19122,-305.4060059,1585.9680176,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (21)
	CreateDynamicObject(19122,-306.1669922,1585.2580566,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (31)
	CreateDynamicObject(19122,-306.6640015,1584.6109619,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (32)
	CreateDynamicObject(19122,-307.4899902,1583.7409668,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (33)
	CreateDynamicObject(19122,-308.3160095,1582.8709717,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (34)
	CreateDynamicObject(19122,-308.8609924,1582.2969971,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (35)
	CreateDynamicObject(19122,-309.4890137,1581.6529541,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (36)
	CreateDynamicObject(19122,-310.1170044,1581.0080566,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (37)
	CreateDynamicObject(19122,-310.6400146,1580.4709473,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (38)
	CreateDynamicObject(19122,-311.1629944,1579.9329834,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (39)
	CreateDynamicObject(19122,-311.6860046,1579.3959961,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (40)
	CreateDynamicObject(19122,-312.2099915,1578.8590088,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (41)
	CreateDynamicObject(19122,-312.7330017,1578.3220215,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (42)
	CreateDynamicObject(19122,-313.2560120,1577.7840576,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (43)
	CreateDynamicObject(19122,-313.7789917,1577.2469482,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (44)
	CreateDynamicObject(19122,-314.4070129,1576.6020508,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (45)
	CreateDynamicObject(19122,-314.9299927,1576.0649414,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (46)
	CreateDynamicObject(19122,-315.3489990,1575.6350098,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (47)
	CreateDynamicObject(19122,-315.8720093,1575.0980225,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (48)
	CreateDynamicObject(19122,-316.3949890,1574.5610352,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (49)
	CreateDynamicObject(19122,-316.9190063,1574.0240479,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (50)
	CreateDynamicObject(19122,-317.4419861,1573.4870605,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (51)
	CreateDynamicObject(19122,-317.9649963,1572.9489746,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (52)
	CreateDynamicObject(19122,-318.8020020,1572.0899658,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (53)
	CreateDynamicObject(19122,-319.3250122,1571.5529785,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (54)
	CreateDynamicObject(19122,-320.1629944,1570.6929932,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (55)
	CreateDynamicObject(19122,-321.3139954,1569.5109863,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (56)
	CreateDynamicObject(19122,-320.6709900,1568.8349609,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (57)
	CreateDynamicObject(19122,-320.2539978,1568.4040527,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (58)
	CreateDynamicObject(19122,-319.5230103,1567.6490479,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (59)
	CreateDynamicObject(19122,-318.6879883,1566.7869873,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (60)
	CreateDynamicObject(19122,-317.8540039,1565.9250488,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (61)
	CreateDynamicObject(19122,-316.7059937,1564.7390137,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (62)
	CreateDynamicObject(19122,-315.7669983,1563.7690430,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (63)
	CreateDynamicObject(19122,-314.6189880,1562.5839844,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (64)
	CreateDynamicObject(19122,-312.2189941,1560.1059570,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (65)
	CreateDynamicObject(19122,-313.1579895,1561.0760498,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (66)
	CreateDynamicObject(19122,-313.8890076,1561.8299561,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (67)
	CreateDynamicObject(19126,-259.8930054,1543.7850342,75.0970001,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (1)
	CreateDynamicObject(19126,-257.6480103,1541.4780273,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (2)
	CreateDynamicObject(19126,-267.0509949,1550.8170166,75.1039963,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (3)
	CreateDynamicObject(19126,-274.3619995,1558.3100586,75.0899963,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (4)
	CreateDynamicObject(19126,-281.7699890,1565.8360596,75.0889969,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (5)
	CreateDynamicObject(19126,-289.2730103,1573.3950195,75.0859985,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (6)
	CreateDynamicObject(19126,-296.4920044,1580.6020508,75.1360016,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (7)
	CreateDynamicObject(19126,-304.3970032,1586.7679443,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (8)
	CreateDynamicObject(19126,-307.9570007,1583.2010498,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (9)
	CreateDynamicObject(19126,-312.6730042,1560.6419678,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (10)
	CreateDynamicObject(19126,-315.2380066,1563.1409912,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (11)
	CreateDynamicObject(19126,-320.7969971,1570.1209717,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (12)
	CreateDynamicObject(19126,-318.3110046,1566.4079590,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (13)
	CreateDynamicObject(19123,-261.9590149,1545.7989502,75.0999985,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (10)
	CreateDynamicObject(19123,-269.3999939,1553.3890381,75.0879974,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (11)
	CreateDynamicObject(19123,-276.8779907,1560.9699707,75.0879974,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (12)
	CreateDynamicObject(19123,-284.2160034,1568.2430420,75.0920029,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (13)
	CreateDynamicObject(19123,-291.6650085,1575.7149658,75.0899963,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (14)
	CreateDynamicObject(19123,-299.0679932,1583.0959473,75.1340027,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (15)
	CreateDynamicObject(19123,-316.2550049,1564.2889404,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (16)
	CreateDynamicObject(19123,-319.1109924,1567.2220459,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (17)
	CreateDynamicObject(19123,-321.0910034,1569.1700439,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (18)
	CreateDynamicObject(19125,-264.5740051,1548.4680176,75.0839996,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (1)
	CreateDynamicObject(19125,-271.9800110,1555.9329834,75.0559998,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (2)
	CreateDynamicObject(19125,-279.1629944,1563.3809814,75.0490036,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (3)
	CreateDynamicObject(19125,-286.8450012,1570.9470215,75.0270004,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (4)
	CreateDynamicObject(19125,-294.0450134,1578.2089844,75.0770035,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (5)
	CreateDynamicObject(19125,-302.1849976,1586.2020264,75.1340027,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (6)
	CreateDynamicObject(19127,-314.3410034,1562.1459961,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (1)
	CreateDynamicObject(19127,-313.6050110,1561.4029541,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (2)
	CreateDynamicObject(19127,-317.2950134,1565.3229980,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (3)
	CreateDynamicObject(19127,-319.9249878,1568.0229492,75.1269989,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (4)
	CreateDynamicObject(16349,-297.4280090,1538.8850098,77.8359985,0.0000000,0.0000000,0.0000000); //object(dam_genturbine01) (1)
	CreateDynamicObject(1189,-325.7409973,1545.3929443,77.9509964,0.0000000,0.0000000,0.0000000); //object(fbmp_lr_sv1) (1)
	CreateDynamicObject(1188,-325.7269897,1545.3929443,77.4359970,0.0000000,0.0000000,0.0000000); //object(fbmp_lr_sv2) (1)
	CreateDynamicObject(1180,-326.1484375,1545.3925781,77.2163696,0.0000000,0.0000000,0.0000000); //object(rbmp_lr_rem1) (1)
	CreateDynamicObject(1116,-328.7229919,1545.3929443,77.6620026,0.0000000,0.0000000,0.0000000); //object(fbb_lr_slv2) (1)
	CreateDynamicObject(1115,-328.7600098,1545.3929443,77.2030029,0.0000000,0.0000000,0.0000000); //object(fbb_lr_slv1) (1)
	CreateDynamicObject(16134,-177.8619995,1492.8270264,68.5739975,0.0000000,0.0000000,0.0000000); //object(des_rockfl1_01) (1)
	CreateDynamicObject(13590,-261.7680054,1482.1319580,75.9380035,0.0000000,0.0000000,0.0000000); //object(kickbus04) (1)
	CreateDynamicObject(13636,-244.9900055,1481.8349609,76.8430023,0.0000000,0.0000000,0.0000000); //object(logramps) (1)
	CreateDynamicObject(13648,-228.0619965,1443.4599609,72.1959991,0.0000000,2.0000000,135.0000000); //object(wall2) (1)
	CreateDynamicObject(13647,-255.4730072,1416.0600586,71.0039978,0.0000000,0.0000000,45.0000000); //object(wall1) (1)
	CreateDynamicObject(1391,-251.6410065,1528.7189941,107.0930023,0.0000000,0.0000000,12.0000000); //object(twrcrane_s_03) (1)
	CreateDynamicObject(1481,-308.9429932,1540.9449463,75.2659988,0.0000000,0.0000000,316.0000000); //object(dyn_bar_b_q) (1)
	CreateDynamicObject(1433,-313.5880127,1543.7130127,74.7419968,0.0000000,0.0000000,0.0000000); //object(dyn_table_1) (1)
	CreateDynamicObject(1518,-313.4949951,1543.7180176,75.5299988,0.0000000,0.0000000,0.0000000); //object(dyn_tv_2) (2)
	CreateDynamicObject(1790,-313.4869995,1543.6479492,75.8799973,0.0000000,0.0000000,0.0000000); //object(swank_video_3) (1)
	CreateDynamicObject(1670,-313.5159912,1543.7110596,75.9550018,0.0000000,0.0000000,0.0000000); //object(propcollecttable) (1)
	CreateDynamicObject(1432,-313.7799988,1540.6519775,74.5630035,0.0000000,0.0000000,66.0000000); //object(dyn_table_2) (1)
	CreateDynamicObject(1432,-315.1419983,1538.2629395,74.5630035,0.0000000,0.0000000,139.9948730); //object(dyn_table_2) (2)
	CreateDynamicObject(1665,-315.1929932,1538.2719727,75.1890030,0.0000000,0.0000000,0.0000000); //object(propashtray1) (1)
	CreateDynamicObject(1665,-313.7879944,1540.7370605,75.1890030,0.0000000,0.0000000,88.0000000); //object(propashtray1) (2)
	CreateDynamicObject(1669,-315.4989929,1538.2760010,75.3450012,0.0000000,0.0000000,0.0000000); //object(propwinebotl1) (1)
	CreateDynamicObject(1486,-315.1159973,1538.5789795,75.3229980,0.0000000,0.0000000,0.0000000); //object(dyn_beer_1) (1)
	CreateDynamicObject(1512,-314.1250000,1540.6319580,75.3759995,0.0000000,0.0000000,0.0000000); //object(dyn_wine_03) (1)
	CreateDynamicObject(1544,-313.3779907,1540.6879883,75.1780014,0.0000000,0.0000000,0.0000000); //object(cj_beer_b_1) (1)
	CreateDynamicObject(1667,-315.4259949,1537.7390137,75.2669983,0.0000000,0.0000000,0.0000000); //object(propwineglass1) (1)
	CreateDynamicObject(1951,-313.9670105,1544.1590576,75.4380035,0.0000000,0.0000000,45.0000000); //object(kb_beer01) (1)
	CreateDynamicObject(1951,-314.0109863,1543.8199463,75.4380035,0.0000000,0.0000000,39.0000000); //object(kb_beer01) (2)
	CreateDynamicObject(1951,-313.7709961,1544.0810547,75.4380035,0.0000000,0.0000000,198.0000000); //object(kb_beer01) (3)
	// Парк в ЛС (напротив Альхамбры)
	CreateDynamicObject(869, 1776.6999, -1678.5, 14.1, 0.0, 0.0, 0.0); // объект 0
	CreateDynamicObject(869, 1775.5999, -1676.0999, 14.1, 0.0, 0.0, 270.0); // объект 1
	CreateDynamicObject(869, 1779, -1674.4000, 14.1, 0.0, 0.0, 150.0); // объект 2
	CreateDynamicObject(869, 1778.5999, -167, 14.1, 0.0, 0.0, 69.996); // объект 3
	CreateDynamicObject(869, 1777, -1673.8000, 14.1, 0.0, 0.0, 289.994); // объект 4
	CreateDynamicObject(869, 1778.8000, -1673.8000, 14.1, 0.0, 0.0, 269.99); // объект 5
	CreateDynamicObject(869, 1780, -1676.4000, 14.1, 0.0, 0.0, 139.989); // объект 6
	CreateDynamicObject(869, 1778.5999, -1678.3000, 14.1, 0.0, 0.0, 139.988); // объект 7
	CreateDynamicObject(869, 1776.1999, -1675.6999, 14.1, 0.0, 0.0, 119.988); // объект 8
	CreateDynamicObject(869, 1778.9000, -1676.0999, 14.1, 0.0, 0.0, 79.987); // объект 9
	CreateDynamicObject(869, 1777.8000, -167, 14.1, 0.0, 0.0, 59.986); // объект 10
	CreateDynamicObject(869, 1775.1999, -1675.6999, 14.1, 0.0, 0.0, 39.985); // объект 11
	CreateDynamicObject(871, 1763.4000, -1651.6999, 14.2, 0.0, 0.0, 0.0); // объект 12
	CreateDynamicObject(871, 1760.8000, -165, 14.2, 0.0, 0.0, 240.0); // объект 13
	CreateDynamicObject(871, 1762.1992, -1652.6992, 14.2, 0.0, 0.0, 329.999); // объект 14
	CreateDynamicObject(871, 1761.8994, -1651.0996, 14.2, 0.0, 0.0, 299.998); // объект 15
	CreateDynamicObject(871, 1760.6999, -1652.5999, 14.2, 0.0, 0.0, 239.996); // объект 16
	CreateDynamicObject(871, 1760.9000, -1650.4000, 14.2, 0.0, 0.0, 249.996); // объект 17
	CreateDynamicObject(871, 1762.3000, -1650.8000, 14.2, 0.0, 0.0, 239.994); // объект 18
	CreateDynamicObject(871, 1761.8000, -165, 14.2, 0.0, 0.0, 109.991); // объект 19
	CreateDynamicObject(871, 1760.0999, -1651.5, 14.2, 0.0, 0.0, 109.99); // объект 20
	CreateDynamicObject(871, 1762.8000, -1652.8000, 14.2, 0.0, 0.0, 109.99); // объект 21
	CreateDynamicObject(871, 1762.5, -1650.5, 14.2, 0.0, 0.0, 109.99); // объект 22
	CreateDynamicObject(871, 1760.6999, -1651.5, 14.2, 0.0, 0.0, 109.99); // объект 23
	CreateDynamicObject(871, 1761.3000, -165, 14.2, 0.0, 0.0, 59.99); // объект 24
	CreateDynamicObject(871, 1761, -1650.5, 14.2, 0.0, 0.0, 109.99); // объект 25
	CreateDynamicObject(6965, 1779.5999, -1652.3000, 16.9, 0.0, 0.0, 0.0); // объект 26
	CreateDynamicObject(6964, 1779.5999, -1652.3000, 13, 0.0, 0.0, 0.0); // объект 27
	CreateDynamicObject(3515, 1784, -1647.3000, 13.4, 0.0, 0.0, 0.0); // объект 28
	CreateDynamicObject(3515, 1784, -165, 13.4, 0.0, 0.0, 0.0); // объект 29
	CreateDynamicObject(3515, 1774.6999, -1656.5999, 13.4, 0.0, 0.0, 300.0); // объект 30
	CreateDynamicObject(3515, 1775.5, -1647.0999, 13.4, 0.0, 0.0, 255.998); // объект 31
	CreateDynamicObject(9833, 1779.0999, -1652.3000, 22.7, 0.0, 0.0, 0.0); // объект 32
	CreateDynamicObject(869, 1792.4000, -1641.1999, 14.1, 0.0, 0.0, 269.989); // объект 33
	CreateDynamicObject(869, 1792.4000, -1641.1999, 14.2, 0.0, 0.0, 209.989); // объект 34
	CreateDynamicObject(869, 1793.3000, -164, 14.1, 0.0, 0.0, 129.987); // объект 35
	CreateDynamicObject(869, 1793.3000, -164, 14.2, 0.0, 0.0, 179.985); // объект 36
	CreateDynamicObject(869, 1793.3000, -164, 14.1, 0.0, 0.0, 99.984); // объект 37
	CreateDynamicObject(869, 1793.1999, -164, 14.2, 0.0, 0.0, 299.981); // объект 38
	CreateDynamicObject(869, 1792, -1641.4000, 14.2, 0.0, 0.0, 299.976); // объект 39
	CreateDynamicObject(1280, 1767.3000, -1680.1999, 13.8, 0.0, 0.0, 0.0); // объект 40
	CreateDynamicObject(1280, 1767.3000, -1676.1999, 13.8, 0.0, 0.0, 0.0); // объект 41
	CreateDynamicObject(1280, 1768, -1676.1999, 13.8, 0.0, 0.0, 180.0); // объект 42
	CreateDynamicObject(1280, 1768, -1680.1999, 13.8, 0.0, 0.0, 179.995); // объект 43
	CreateDynamicObject(1280, 1767.3000, -1668.6999, 13.8, 0.0, 0.0, 0.0); // объект 44
	CreateDynamicObject(1280, 1768, -1668.6999, 13.8, 0.0, 0.0, 179.995); // объект 45
	CreateDynamicObject(1280, 1767.3000, -1664.5, 13.8, 0.0, 0.0, 0.0); // объект 46
	CreateDynamicObject(1280, 1768, -1664.5, 13.8, 0.0, 0.0, 179.995); // объект 47
	CreateDynamicObject(1280, 1768, -1660.0999, 13.8, 0.0, 0.0, 179.995); // объект 48
	CreateDynamicObject(1280, 1767.3000, -1660.0999, 13.8, 0.0, 0.0, 0.0); // объект 49
	CreateDynamicObject(1280, 1756.1999, -1641.8000, 13.8, 0.0, 0.0, 179.995); // объект 50
	CreateDynamicObject(1280, 1756.3000, -1636.8000, 13.8, 0.0, 0.0, 179.995); // объект 51
	CreateDynamicObject(1280, 1756.3000, -1625.9000, 13.8, 0.0, 0.0, 179.995); // объект 52
	CreateDynamicObject(1280, 1756.2998, -1631.5, 13.8, 0.0, 0.0, 179.995); // объект 53
	CreateDynamicObject(1280, 1756.3000, -1619.6999, 13.8, 0.0, 0.0, 179.995); // объект 54
	CreateDynamicObject(1216, 1771.5, -1681.5, 14.1, 0.0, 0.0, 180.0); // объект 55
	CreateDynamicObject(1216, 1772.6999, -1681.5, 14.1, 0.0, 0.0, 179.995); // объект 56
	CreateDynamicObject(1216, 1770.8994, -1681.5, 14.1, 0.0, 0.0, 179.995); // объект 57
	CreateDynamicObject(1216, 1772.0996, -1681.5, 14.1, 0.0, 0.0, 179.995); // объект 58
	CreateDynamicObject(1231, 1756.1999, -1639.4000, 16, 0.0, 0.0, 270.0); // объект 59
	CreateDynamicObject(1231, 1777.8000, -1666.5, 16.1, 0.0, 0.0, 270.0); // объект 60
	CreateDynamicObject(1231, 1756.4000, -1634.1999, 16, 0.0, 0.0, 270.0); // объект 61
	CreateDynamicObject(1231, 1756.5, -1622.8000, 16, 0.0, 0.0, 270.0); // объект 62
	CreateDynamicObject(1231, 1756.5, -1628.8000, 16, 0.0, 0.0, 270.0); // объект 63
	CreateDynamicObject(1231, 1787.0999, -1678.8000, 16.2, 0.0, 0.0, 270.0); // объект 64
	CreateDynamicObject(1231, 1796.4000, -1666.5999, 16.2, 0.0, 0.0, 270.0); // объект 65
	CreateDynamicObject(1231, 1806.5999, -1666.6999, 16.2, 0.0, 0.0, 270.0); // объект 66
	CreateDynamicObject(1231, 1786.8994, -1666.5, 16.2, 0.0, 0.0, 270.0); // объект 67
	CreateDynamicObject(1231, 1796.3000, -1633.1999, 16.1, 0.0, 0.0, 270.0); // объект 68
	CreateDynamicObject(1231, 1806.6999, -1678.8000, 16.2, 0.0, 0.0, 270.0); // объект 69
	CreateDynamicObject(1231, 1796.2998, -167, 16.2, 0.0, 0.0, 270.0); // объект 70
	CreateDynamicObject(1231, 1806.5, -165, 16.2, 0.0, 0.0, 270.0); // объект 71
	CreateDynamicObject(1231, 1796.3994, -165, 16.2, 0.0, 0.0, 270.0); // объект 72
	CreateDynamicObject(1231, 1786.6999, -1632.9000, 16.1, 0.0, 0.0, 270.0); // объект 73
	CreateDynamicObject(1231, 1777.6999, -163, 16.1, 0.0, 0.0, 270.0); // объект 74
	CreateDynamicObject(1231, 1768.6999, -1632.9000, 16.1, 0.0, 0.0, 270.0); // объект 75
	CreateDynamicObject(1231, 1777.6999, -162, 16.1, 0.0, 0.0, 270.0); // объект 76
	CreateDynamicObject(1231, 1768.6999, -1623.9000, 16.1, 0.0, 0.0, 270.0); // объект 77
	CreateDynamicObject(1280, 1792.4000, -1681.5, 13.9, 0.0, 0.0, 270.0); // объект 78
	CreateDynamicObject(1280, 1802, -1681.8000, 13.9, 0.0, 0.0, 269.995); // объект 79
	CreateDynamicObject(1280, 1797.5999, -1646.0999, 13.9, 0.0, 0.0, 0.0); // объект 80
	CreateDynamicObject(1280, 1797.5999, -1640.8000, 13.9, 0.0, 0.0, 0.0); // объект 81
	CreateDynamicObject(1280, 1797.5999, -1635.0999, 13.9, 0.0, 0.0, 0.0); // объект 82
	CreateDynamicObject(1280, 1797.6999, -1629.1999, 13.9, 0.0, 0.0, 0.0); // объект 83
	CreateDynamicObject(1280, 1774.1999, -1642.8000, 13.8, 0.0, 0.0, 296.0); // объект 84
	CreateDynamicObject(1280, 1779.4000, -1641.5999, 13.8, 0.0, 0.0, 269.999); // объект 85
	CreateDynamicObject(1280, 1784.0999, -1642.5999, 13.9, 0.0, 0.0, 243.995); // объект 86
	CreateDynamicObject(1280, 1787.8000, -1645.5, 13.9, 0.0, 0.0, 219.99); // объект 87
	CreateDynamicObject(1280, 1789.9000, -1649.5, 13.9, 0.0, 0.0, 193.735); // объект 88
	CreateDynamicObject(1280, 1790.0999, -1654.4000, 13.9, 0.0, 0.0, 167.733); // объект 89
	CreateDynamicObject(1280, 1788, -1658.6999, 13.9, 0.0, 0.0, 141.728); // объект 90
	CreateDynamicObject(1280, 1784.0999, -1661.9000, 13.9, 0.0, 0.0, 115.724); // объект 91
	CreateDynamicObject(1280, 1779.8000, -1662.9000, 13.8, 0.0, 0.0, 89.719); // объект 92
	CreateDynamicObject(1280, 1774.9000, -1661.9000, 13.8, 0.0, 0.0, 63.714); // объект 93
	CreateDynamicObject(1280, 1770.9000, -1645.9000, 13.8, 0.0, 0.0, 323.71); // объект 94
	CreateDynamicObject(1280, 1769.1999, -165, 13.8, 0.0, 0.0, 347.707); // объект 95
	CreateDynamicObject(1280, 1806.5999, -1675.5999, 13.9, 0.0, 0.0, 0.0); // объект 96
	CreateDynamicObject(1280, 1806.5999, -1672.5, 13.9, 0.0, 0.0, 0.0); // объект 97
	CreateDynamicObject(1280, 1806.5999, -1669.4000, 13.9, 0.0, 0.0, 0.0); // объект 98
	CreateDynamicObject(1280, 1806.5999, -1664.4000, 13.9, 0.0, 0.0, 0.0); // объект 99
	CreateDynamicObject(1280, 1806.5999, -1661.1999, 13.9, 0.0, 0.0, 0.0); // объект 100
	CreateDynamicObject(1280, 1806.5999, -1657.5999, 13.9, 0.0, 0.0, 0.0); // объект 101
	CreateDynamicObject(1280, 1806.5999, -1651.8000, 13.9, 0.0, 0.0, 0.0); // объект 102
	CreateDynamicObject(1289, 1770, -1681.8000, 14, 0.0, 0.0, 0.0); // объект 103
	CreateDynamicObject(1289, 1755, -1646.6999, 14, 0.0, 0.0, 0.0); // объект 104
	CreateDynamicObject(1289, 1755.5999, -1646.6999, 14, 0.0, 0.0, 0.0); // объект 105
	CreateDynamicObject(871, 1808.3000, -162, 12.9, 0.0, 0.0, 109.99); // объект 106
	CreateDynamicObject(871, 1807, -1626.4000, 12.9, 0.0, 0.0, 109.99); // объект 107
	CreateDynamicObject(871, 1808.4000, -1625.9000, 12.9, 0.0, 0.0, 69.99); // объект 108
	CreateDynamicObject(871, 1807.8000, -162, 12.9, 0.0, 0.0, 9.988); // объект 109
	CreateDynamicObject(871, 1806.0999, -1625.5, 12.9, 0.0, 0.0, 9.987); // объект 110
	CreateDynamicObject(871, 1806.5, -1624.3000, 12.9, 0.0, 0.0, 339.987); // объект 111
	CreateDynamicObject(871, 1806.4000, -1626.3000, 12.9, 0.0, 0.0, 339.983); // объект 112
	CreateDynamicObject(871, 1808.1999, -1624.5, 12.9, 0.0, 0.0, 339.983); // объект 113
	CreateDynamicObject(871, 1808.5, -1625.9000, 12.9, 0.0, 0.0, 339.983); // объект 114
	CreateDynamicObject(871, 1806.9000, -1626.9000, 12.9, 0.0, 0.0, 259.983); // объект 115
	CreateDynamicObject(871, 1806.8994, -1626.8994, 12.9, 0.0, 0.0, 259.98); // объект 116
	CreateDynamicObject(871, 1807.4000, -1626.6999, 12.9, 0.0, 0.0, 259.98); // объект 117
	CreateDynamicObject(871, 1806.1999, -1625.9000, 12.9, 0.0, 0.0, 259.98); // объект 118
	CreateDynamicObject(871, 1807.5999, -1624.3000, 12.9, 0.0, 0.0, 227.98); // объект 119
	// Скейт-парк ЛС
	CreateDynamicObject(6964, 1859.59, -1396.64, 10.69,   0.00, 0.00, 0.00);
	CreateDynamicObject(9131, 1862.10, -1390.50, 13.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(1251, 1861.90, -1386.80, 12.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(8229, 1885.90, -1351.10, 15.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(975, 1959.20, -1450.90, 14.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(1346, 1861.00, -1391.90, 13.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(3881, 1864.00, -1374.90, 14.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1251, 1861.90, -1379.90, 12.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(1234, 1857.00, -1393.10, 14.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(11010, 1896.60, -1363.60, 18.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1412, 1878.60, -1371.10, 13.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(1412, 1869.00, -1371.10, 13.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(1412, 1881.40, -1353.60, 13.80,   0.00, 0.00, 90.00);
	CreateDynamicObject(1237, 1871.70, -1371.10, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1876.10, -1371.10, 12.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(1251, 1874.00, -1371.00, 12.60,   0.00, 0.00, 90.00);
	CreateDynamicObject(1237, 1870.70, -1371.10, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(1237, 1876.90, -1371.10, 12.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(997, 1862.50, -1354.70, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(997, 1876.20, -1354.80, 12.50,   0.00, 0.00, 90.00);
	CreateDynamicObject(996, 1863.20, -1351.50, 13.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(994, 1870.60, -1351.70, 12.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(1251, 1865.90, -1354.70, 12.60,   0.00, 0.00, 90.00);
	CreateDynamicObject(1251, 1872.70, -1354.70, 12.60,   0.00, 0.00, 90.00);
	CreateDynamicObject(14467, 1864.20, -1374.70, 18.70,   0.00, 0.00, 270.00);
	CreateDynamicObject(792, 1881.60, -1371.80, 12.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(792, 1867.50, -1371.70, 12.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(7908, 1896.10, -1370.80, 26.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(7914, 1882.10, -1363.20, 27.80,   0.00, 0.00, 270.00);
	CreateDynamicObject(18028, 1973.20, -1351.20, -58.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1712, 1984.80, -1348.90, -60.60,   0.00, 0.00, 270.00);
	CreateDynamicObject(14807, 1948.70, -1414.60, -126.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(1506, 1974.50, -1340.30, -60.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(1951, 1971.60, -1350.00, -59.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1951, 1970.00, -1350.10, -59.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1951, 1973.40, -1353.00, -59.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1951, 1972.40, -1353.10, -59.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1951, 1971.20, -1353.10, -59.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1951, 1969.80, -1353.10, -59.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1950, 1970.40, -1353.00, -59.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1950, 1968.30, -1349.90, -59.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1950, 1966.30, -1349.90, -59.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(1669, 1968.31, -1349.62, -59.52,   0.00, 0.00, 0.00);
	CreateDynamicObject(1669, 1971.70, -1349.66, -59.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(1669, 1966.20, -1351.90, -59.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1669, 1973.30, -1350.00, -59.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(1518, 1975.86, -1351.81, -59.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(1717, 1983.30, -1343.70, -60.60,   0.00, 0.00, 90.00);
	CreateDynamicObject(2864, 1974.90, -1350.00, -59.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(2027, 1979.10, -1360.90, -59.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(2027, 1984.20, -1360.90, -59.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(2582, 1985.50, -1357.10, -59.50,   0.00, 0.00, 270.00);
	CreateDynamicObject(1245, 1908.60, -1405.00, 14.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(1503, 1931.50, -1436.50, 12.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(1632, 1919.00, -1411.90, 13.90,   0.00, 0.00, 180.00);
	CreateDynamicObject(1660, 1945.70, -1378.40, 17.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(3852, 1909.00, -1448.40, 14.30,   0.00, 0.00, 90.00);
	CreateDynamicObject(16401, 1955.50, -1425.00, 9.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(13640, 1930.20, -1401.50, 13.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(13641, 1887.70, -1426.30, 9.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(18451, 1881.20, -1404.20, 13.10,   0.00, 0.00, 180.00);
	CreateDynamicObject(3507, 1922.50, -1365.70, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(3507, 1918.40, -1359.90, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(3507, 1927.10, -1383.10, 12.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(3507, 1929.60, -1394.10, 12.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(3507, 1942.50, -1396.80, 12.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(3507, 1957.30, -1399.90, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(3507, 1966.80, -1407.90, 12.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(3507, 1971.90, -1419.40, 12.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(3507, 1973.20, -1432.00, 12.60,   0.00, 0.00, 0.00);
	CreateDynamicObject(1232, 1863.10, -1367.60, 15.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(1232, 1862.60, -1355.30, 15.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(1232, 1880.30, -1355.30, 15.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(1232, 1880.60, -1370.10, 15.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(1232, 1870.60, -1351.90, 15.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1909.20, -1446.60, 15.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1866.60, -1377.70, 17.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1861.90, -1377.70, 17.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1862.00, -1371.00, 17.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1866.30, -1371.30, 17.50,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1862.10, -1390.50, 16.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1900.10, -1425.90, 11.80,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1908.40, -1417.40, 14.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1928.10, -1416.40, 14.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1948.20, -1370.10, 20.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1956.80, -1450.90, 15.70,   0.00, 0.00, 0.00);
	CreateDynamicObject(3461, 1961.90, -1450.90, 15.40,   0.00, 0.00, 0.00);
	CreateDynamicObject(3507, 1926.40, -1373.10, 12.80,   0.00, 0.00, 0.00);
	// BMX паркур (СФ)
	CreateDynamicObject(974,-1965.00000000,405.00000000,35.00000000,90.00000000,0.00000000,0.00000000);
	CreateDynamicObject(974,-1955.00000000,405.00000000,38.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1945.00000000,405.00000000,41.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1935.00000000,405.00000000,44.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1925.00000000,405.00000000,47.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1915.00000000,405.00000000,50.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1905.00000000,405.00000000,53.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1905.00000000,415.00000000,56.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1905.00000000,425.00000000,59.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1915.00000000,425.00000000,62.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1925.00000000,425.00000000,65.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1925.00000000,435.00000000,68.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1925.00000000,445.00000000,71.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1925.00000000,455.00000000,74.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1925.00000000,465.00000000,77.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1925.00000000,475.00000000,80.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1925.00000000,485.00000000,83.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1915.00000000,485.00000000,86.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1915.00000000,495.00000000,89.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1905.00000000,495.00000000,89.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1905.00000000,485.00000000,92.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1905.00000000,475.00000000,95.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1905.00000000,465.00000000,98.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1905.00000000,455.00000000,101.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1895.00000000,455.00000000,104.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1885.00000000,455.00000000,107.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1875.00000000,455.00000000,110.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1875.00000000,465.00000000,113.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1875.00000000,475.00000000,116.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1875.00000000,485.00000000,119.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1875.00000000,495.00000000,122.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1875.00000000,505.00000000,125.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1875.00000000,515.00000000,128.00000000,90.00000000,180.00000000,180.00000000);
	CreateDynamicObject(974,-1875.00000000,525.00000000,131.00000000,90.00000000,0.00000000,0.00000000);
	CreateDynamicObject(3572,-1875.00000000,535.00000000,134.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1875.00000000,545.00000000,137.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1875.00000000,555.00000000,140.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1880.00000000,555.00000000,143.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1880.00000000,545.00000000,146.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1880.00000000,535.00000000,149.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1880.00000000,525.00000000,152.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1885.00000000,525.00000000,155.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1885.00000000,535.00000000,158.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1885.00000000,545.00000000,161.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1885.00000000,555.00000000,164.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1890.00000000,555.00000000,167.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1890.00000000,545.00000000,170.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1890.00000000,535.00000000,173.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1890.00000000,525.00000000,176.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1895.00000000,525.00000000,179.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1895.00000000,535.00000000,182.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1895.00000000,545.00000000,185.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1895.00000000,555.00000000,188.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1900.00000000,555.00000000,191.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1900.00000000,545.00000000,194.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1900.00000000,535.00000000,197.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1900.00000000,525.00000000,200.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1905.00000000,525.00000000,203.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1910.00000000,525.00000000,206.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1915.00000000,525.00000000,203.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1920.00000000,525.00000000,200.00000000,0.00000000,0.00000000,90.00000000);
	CreateDynamicObject(3572,-1875.00000000,525.00000000,131.00000000,0.00000000,0.00000000,90.00000000);
	// Болото
	CreateDynamicObject(12990,-757.7000100,-1935.8000500,5.5000000,0.0000000,0.0000000,54.2450000); //object(sw_jetty)(1)
	CreateDynamicObject(3415,-756.4000200,-1993.0000000,7.8000000,0.0000000,0.0000000,204.0000000); //object(ce_loghut1)(1)
	CreateDynamicObject(13120,-713.5996100,-1994.7998000,-37.2000000,357.9900000,0.0000000,0.0000000); //object(ce_grndpalcst03)(1)
	CreateDynamicObject(3418,-780.5999800,-1974.9000200,10.0000000,8.0000000,0.0000000,252.0000000); //object(ce_oldhut02)(1)
	CreateDynamicObject(3414,-772.2999900,-1989.0000000,9.9000000,352.0000000,0.0000000,144.0000000); //object(ce_oldhut1)(1)
	CreateDynamicObject(1442,-763.5000000,-1978.6999500,8.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0)(1)
	CreateDynamicObject(1442,-762.4000200,-1979.0000000,8.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0)(2)
	CreateDynamicObject(1442,-762.7000100,-1977.8000500,8.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0)(3)
	CreateDynamicObject(1442,-763.9000200,-1977.6999500,8.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_firebin0)(4)
	CreateDynamicObject(3425,-776.7000100,-1960.9000200,17.1000000,0.0000000,0.0000000,0.0000000); //object(nt_windmill)(1)
	CreateDynamicObject(3461,-763.5000000,-1978.6999500,7.5000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs)(1)
	CreateDynamicObject(3461,-763.0000000,-1977.8000500,7.2000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs)(2)
	CreateDynamicObject(3461,-763.7999900,-1977.6999500,7.2000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs)(3)
	CreateDynamicObject(3461,-762.2999900,-1979.0000000,7.2000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs)(4)
	CreateDynamicObject(13120,-664.7998000,-1910.3994100,-38.8000000,1.2410000,0.0000000,12.7500000); //object(ce_grndpalcst03)(2)
	CreateDynamicObject(14875,-755.4000200,-1992.5000000,9.4000000,0.0000000,0.0000000,14.0000000); //object(kylie_hay1)(1)
	CreateDynamicObject(12921,-759.5000000,-1972.9000200,10.7000000,0.0000000,0.0000000,148.0000000); //object(sw_farment01)(1)
	CreateDynamicObject(14873,-748.7999900,-1982.0999800,7.8000000,0.0000000,10.0000000,0.0000000); //object(kylie_hay)(1)
	CreateDynamicObject(3286,-748.0000000,-1990.5000000,12.2000000,0.0000000,0.0000000,0.0000000); //object(cxrf_watertwr)(1)
	CreateDynamicObject(1712,-760.2999900,-1979.1999500,7.8000000,0.0000000,0.0000000,252.0000000); //object(kb_couch05)(1)
	CreateDynamicObject(1369,-765.0000000,-1979.0000000,8.5000000,0.0000000,0.0000000,118.0000000); //object(cj_wheelchair1)(1)
	CreateDynamicObject(1368,-764.2000100,-1981.4000200,8.9000000,0.0000000,358.0000000,166.0000000); //object(cj_blocker_bench)(1)
	CreateDynamicObject(14872,-768.2999900,-1972.5000000,8.1000000,0.0000000,0.0000000,0.0000000); //object(kylie_logs)(1)
	CreateDynamicObject(14872,-767.0000000,-1973.1999500,8.1000000,0.0000000,0.0000000,0.0000000); //object(kylie_logs)(2)
	CreateDynamicObject(14872,-767.5000000,-1972.0999800,8.1000000,0.0000000,0.0000000,0.0000000); //object(kylie_logs)(3)
	CreateDynamicObject(18609,-766.2999900,-1969.4000200,8.5000000,0.0000000,3.7500000,72.0000000); //object(cs_logs06)(1)
	CreateDynamicObject(18609,-766.7999900,-1971.3000500,8.5000000,0.0000000,3.7460000,71.9990000); //object(cs_logs06)(2)
	CreateDynamicObject(18609,-766.4000200,-1970.4000200,9.2000000,0.0000000,3.7460000,71.9990000); //object(cs_logs06)(3)
	CreateDynamicObject(12990,-754.5996100,-1932.1992200,5.4000000,0.0000000,0.0000000,233.9920000); //object(sw_jetty)(4)
	CreateDynamicObject(18267,-718.5999800,-1901.9000200,7.6000000,0.0000000,0.0000000,234.0000000); //object(logcabinn)(1)
	CreateDynamicObject(3252,-731.7000100,-1899.0000000,7.5000000,0.0000000,0.0000000,0.0000000); //object(des_oldwattwr_)(1)
	CreateDynamicObject(12990,-755.2998000,-1897.0000000,5.9000000,0.0000000,0.0000000,263.9900000); //object(sw_jetty)(5)
	CreateDynamicObject(16502,-737.9000200,-1978.6999500,3.4000000,0.0000000,0.0000000,18.0000000); //object(cn2_jetty1)(1)
	CreateDynamicObject(16502,-728.5999800,-1975.5999800,4.4000000,0.0000000,0.0000000,20.2460000); //object(cn2_jetty1)(2)
	CreateDynamicObject(12990,-760.6992200,-1940.1992200,5.5000000,0.0000000,0.0000000,52.4870000); //object(sw_jetty)(6)
	CreateDynamicObject(3862,-758.5000000,-1932.8000500,6.6000000,0.0000000,0.0000000,146.0000000); //object(marketstall02_sfxrf)(1)
	CreateDynamicObject(3860,-761.5000000,-1936.9000200,6.9000000,0.0000000,0.0000000,324.0000000); //object(marketstall04_sfxrf)(1)
	CreateDynamicObject(3862,-762.5999800,-1930.1999500,6.6000000,0.0000000,0.0000000,145.9970000); //object(marketstall02_sfxrf)(2)
	CreateDynamicObject(3860,-765.5000000,-1933.9000200,6.9000000,0.0000000,0.0000000,323.9980000); //object(marketstall04_sfxrf)(2)
	CreateDynamicObject(3863,-757.2999900,-1939.9000200,6.7000000,0.0000000,2.0000000,324.0000000); //object(marketstall03_sfxrf)(1)
	CreateDynamicObject(3861,-754.5000000,-1935.8000500,6.8000000,0.0000000,0.0000000,144.0000000); //object(marketstall01_sfxrf)(1)
	CreateDynamicObject(3040,-752.0999800,-1940.3000500,8.4000000,0.0000000,0.0000000,144.0000000); //object(ct_stall2)(1)
	CreateDynamicObject(924,-751.5999800,-1941.6999500,5.7000000,0.0000000,0.0000000,0.0000000); //object(fruitcrate3)(1)
	CreateDynamicObject(924,-752.7000100,-1941.1999500,5.7000000,0.0000000,0.0000000,0.0000000); //object(fruitcrate3)(2)
	CreateDynamicObject(924,-752.5000000,-1941.9000200,5.7000000,0.0000000,0.0000000,0.0000000); //object(fruitcrate3)(3)
	CreateDynamicObject(3039,-768.5000000,-1929.3000500,5.7000000,0.0000000,0.0000000,54.0000000); //object(ct_stall1)(1)
	CreateDynamicObject(1600,-766.2000100,-1934.5999800,6.7000000,358.8810000,106.2130000,50.1590000); //object(fish2single)(1)
	CreateDynamicObject(1604,-765.2999900,-1935.0000000,6.6000000,0.0000000,86.0000000,63.2500000); //object(fish3single)(1)
	CreateDynamicObject(1603,-766.2999900,-1933.1999500,6.8000000,0.0000000,74.0000000,48.0000000); //object(jellyfish01)(1)
	CreateDynamicObject(1604,-765.4000200,-1935.0999800,6.6000000,0.0000000,85.9950000,63.2480000); //object(fish3single)(2)
	CreateDynamicObject(1604,-765.2000100,-1934.9000200,6.6000000,0.0000000,85.9950000,63.2480000); //object(fish3single)(3)
	CreateDynamicObject(1604,-765.0999800,-1934.8000500,6.6000000,0.0000000,85.9950000,63.2480000); //object(fish3single)(4)
	CreateDynamicObject(1604,-765.0000000,-1934.6999500,6.6000000,0.0000000,85.9950000,63.2480000); //object(fish3single)(5)
	CreateDynamicObject(1604,-764.9000200,-1934.5999800,6.6000000,0.0000000,85.9950000,63.2480000); //object(fish3single)(6)
	CreateDynamicObject(1604,-765.5000000,-1935.1999500,6.6000000,0.0000000,85.9950000,63.2480000); //object(fish3single)(7)
	CreateDynamicObject(1600,-766.0999800,-1934.4000200,6.7000000,358.8790000,106.2100000,50.1580000); //object(fish2single)(2)
	CreateDynamicObject(1600,-766.0000000,-1934.1999500,6.7000000,358.8790000,106.2100000,50.1580000); //object(fish2single)(3)
	CreateDynamicObject(1600,-766.2999900,-1934.5999800,6.7000000,358.8790000,106.2100000,50.1580000); //object(fish2single)(4)
	CreateDynamicObject(1600,-766.4000200,-1934.6999500,6.7000000,358.8790000,106.2100000,50.1580000); //object(fish2single)(5)
	CreateDynamicObject(1600,-766.5000000,-1934.8000500,6.7000000,358.8790000,106.2100000,50.1580000); //object(fish2single)(6)
	CreateDynamicObject(1340,-745.4000200,-1939.0999800,6.7000000,0.0000000,0.0000000,0.0000000); //object(chillidogcart)(1)
	CreateDynamicObject(2821,-753.5000000,-1936.0000000,6.4000000,0.0000000,0.0000000,0.0000000); //object(gb_foodwrap01)(1)
	CreateDynamicObject(2823,-754.0000000,-1935.6999500,6.4000000,0.0000000,0.0000000,0.0000000); //object(gb_kitchtakeway01)(1)
	CreateDynamicObject(2837,-753.5000000,-1935.5999800,6.4000000,0.0000000,0.0000000,0.0000000); //object(gb_takeaway02)(1)
	CreateDynamicObject(2840,-754.2999900,-1935.4000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(gb_takeaway05)(1)
	CreateDynamicObject(2814,-754.9000200,-1934.9000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(gb_takeaway01)(1)
	CreateDynamicObject(1371,-752.4000200,-1936.4000200,6.5000000,0.0000000,0.0000000,142.0000000); //object(cj_hippo_bin)(1)
	CreateDynamicObject(1371,-750.2999900,-1941.5999800,6.3000000,0.0000000,0.0000000,55.9980000); //object(cj_hippo_bin)(2)
	CreateDynamicObject(1371,-768.0000000,-1932.4000200,6.6000000,0.0000000,0.0000000,277.9970000); //object(cj_hippo_bin)(3)
	CreateDynamicObject(1541,-762.7999900,-1931.6999500,7.0000000,0.0000000,0.0000000,148.0000000); //object(cj_beer_taps_1)(1)
	CreateDynamicObject(1542,-763.7000100,-1931.0999800,6.8000000,0.0000000,0.0000000,136.0000000); //object(cj_beer_taps_2)(1)
	CreateDynamicObject(1545,-764.4000200,-1930.5999800,7.1000000,0.0000000,0.0000000,0.0000000); //object(cj_b_optic1)(1)
	CreateDynamicObject(1548,-761.5999800,-1929.8000500,6.3000000,0.0000000,0.0000000,146.0000000); //object(cj_drip_tray)(1)
	CreateDynamicObject(1548,-762.7999900,-1929.0000000,6.3000000,0.0000000,0.0000000,145.9970000); //object(cj_drip_tray)(2)
	CreateDynamicObject(12857,-783.9000200,-1915.6999500,3.1000000,0.0000000,0.0000000,52.0000000); //object(ce_bridge02)(2)
	CreateDynamicObject(1410,-699.7000100,-1910.5999800,6.6000000,0.0000000,10.2500000,44.0000000); //object(dyn_f_r_wood_1b)(1)
	CreateDynamicObject(1410,-703.0999800,-1913.8000500,7.2000000,0.0000000,8.0000000,43.9950000); //object(dyn_f_r_wood_1b)(2)
	CreateDynamicObject(1410,-706.4000200,-1917.0000000,7.4000000,0.0000000,3.4980000,43.9890000); //object(dyn_f_r_wood_1b)(3)
	CreateDynamicObject(1410,-709.5999800,-1920.0999800,7.7000000,0.0000000,3.4940000,43.9890000); //object(dyn_f_r_wood_1b)(4)
	CreateDynamicObject(1410,-721.7999900,-1919.0000000,7.8000000,0.0000000,3.4940000,325.9890000); //object(dyn_f_r_wood_1b)(5)
	CreateDynamicObject(1410,-712.5000000,-1922.9000200,7.2000000,0.0000000,347.4940000,43.9890000); //object(dyn_f_r_wood_1b)(6)
	CreateDynamicObject(1410,-725.5000000,-1916.4000200,8.1000000,0.0000000,3.4880000,325.9860000); //object(dyn_f_r_wood_1b)(7)
	CreateDynamicObject(1410,-729.2999900,-1913.9000200,8.5000000,0.0000000,3.4880000,325.9860000); //object(dyn_f_r_wood_1b)(8)
	CreateDynamicObject(1410,-734.5000000,-1909.5000000,8.5000000,0.0000000,3.4880000,325.9860000); //object(dyn_f_r_wood_1b)(9)
	CreateDynamicObject(1410,-738.2999900,-1906.9000200,9.0000000,0.0000000,3.4880000,325.9860000); //object(dyn_f_r_wood_1b)(10)
	CreateDynamicObject(1410,-738.9000200,-1903.8000500,8.7000000,0.0000000,358.9880000,237.9860000); //object(dyn_f_r_wood_1b)(11)
	CreateDynamicObject(1410,-736.4000200,-1900.0000000,8.5000000,0.0000000,354.9830000,237.9860000); //object(dyn_f_r_wood_1b)(12)
	CreateDynamicObject(1410,-734.0999800,-1896.0000000,8.0000000,0.0000000,355.2330000,237.9860000); //object(dyn_f_r_wood_1b)(13)
	CreateDynamicObject(1410,-731.7000100,-1892.1999500,7.7000000,0.0000000,353.4830000,237.9860000); //object(dyn_f_r_wood_1b)(14)
	CreateDynamicObject(1410,-729.9000200,-1889.1999500,7.0000000,0.0000000,353.4800000,237.9800000); //object(dyn_f_r_wood_1b)(15)
	CreateDynamicObject(1410,-716.0000000,-1923.0999800,7.0000000,1.9910000,5.4950000,325.2980000); //object(dyn_f_r_wood_1b)(16)
	CreateDynamicObject(1410,-719.0999800,-1920.9000200,7.5000000,1.9890000,5.4930000,323.0470000); //object(dyn_f_r_wood_1b)(17)
	CreateDynamicObject(1463,-709.0999800,-1911.6999500,7.2000000,0.0000000,0.0000000,46.0000000); //object(dyn_woodpile2)(1)
	CreateDynamicObject(1463,-710.0000000,-1910.9000200,7.2000000,0.0000000,0.0000000,46.0000000); //object(dyn_woodpile2)(2)
	CreateDynamicObject(1463,-710.7000100,-1910.0999800,7.2000000,0.0000000,0.0000000,46.0000000); //object(dyn_woodpile2)(3)
	CreateDynamicObject(1463,-710.2000100,-1910.5000000,7.7000000,0.0000000,0.0000000,46.0000000); //object(dyn_woodpile2)(4)
	CreateDynamicObject(1463,-709.0000000,-1911.4000200,7.7000000,0.0000000,0.0000000,46.0000000); //object(dyn_woodpile2)(5)
	CreateDynamicObject(1463,-709.5000000,-1911.0999800,8.0000000,0.0000000,0.0000000,46.0000000); //object(dyn_woodpile2)(6)
	CreateDynamicObject(1492,-722.0000000,-1905.6999500,7.7000000,0.0000000,0.0000000,328.0000000); //object(gen_doorint02)(1)
	CreateDynamicObject(14384,-720.5999800,-1898.6999500,9.2000000,0.0000000,0.0000000,58.0000000); //object(kitchen_bits)(1)
	CreateDynamicObject(912,-724.2000100,-1901.3000500,8.2000000,0.0000000,0.0000000,323.7500000); //object(bust_cabinet_2)(1)
	CreateDynamicObject(912,-725.2000100,-1900.5999800,8.2000000,0.0000000,0.0000000,323.2470000); //object(bust_cabinet_2)(2)
	CreateDynamicObject(2572,-713.0000000,-1907.0999800,7.7000000,0.0000000,0.0000000,192.0000000); //object(hotel_single_2)(1)
	CreateDynamicObject(2572,-715.9000200,-1904.6999500,7.7000000,0.0000000,0.0000000,335.9970000); //object(hotel_single_2)(2)
	CreateDynamicObject(1492,-711.7999900,-1900.8000500,7.7000000,0.0000000,0.0000000,321.9970000); //object(gen_doorint02)(2)
	CreateDynamicObject(2117,-715.5999800,-1906.3000500,7.3000000,0.0000000,0.0000000,0.0000000); //object(swank_dinning_5)(1)
	CreateDynamicObject(17124,-533.7999900,-1825.5999800,26.6000000,358.0000000,0.0000000,110.0000000); //object(cuntwland58b)(1)
	CreateDynamicObject(17124,-535.9000200,-1882.3000500,15.4000000,357.9950000,0.0000000,71.9950000); //object(cuntwland58b)(2)
	CreateDynamicObject(17124,-564.4000200,-1833.0999800,45.2000000,357.9900000,0.0000000,105.9930000); //object(cuntwland58b)(3)
	CreateDynamicObject(16203,-2226.0000000,2033.0000000,19.9000000,0.0000000,0.0000000,0.0000000); //object(cen_bit_11)(1)
	CreateDynamicObject(16113,-2132.1999500,2111.8999000,-6.8000000,0.0000000,0.0000000,44.0000000); //object(des_rockgp2_03)(1)
	CreateDynamicObject(16113,-2136.6001000,2124.1001000,-13.1000000,0.0000000,0.0000000,43.9950000); //object(des_rockgp2_03)(2)
	CreateDynamicObject(16113,-2106.1999500,2109.1001000,-13.1000000,0.0000000,4.0000000,327.9950000); //object(des_rockgp2_03)(3)
	CreateDynamicObject(16113,-2100.1001000,2072.5000000,-13.1000000,0.0000000,3.9990000,311.9910000); //object(des_rockgp2_03)(4)
	CreateDynamicObject(16113,-2099.6999500,2102.6999500,-4.4000000,0.0000000,3.9940000,323.9900000); //object(des_rockgp2_03)(6)
	CreateDynamicObject(16113,-2099.6992200,2102.6992200,-4.4000000,0.0000000,3.9880000,323.9870000); //object(des_rockgp2_03)(7)
	CreateDynamicObject(16113,-2097.3000500,2065.6001000,-15.8000000,0.0000000,3.9940000,300.2400000); //object(des_rockgp2_03)(8)
	CreateDynamicObject(16113,-2097.3999000,2041.1999500,-8.1000000,0.0000000,3.9940000,311.9900000); //object(des_rockgp2_03)(9)
	CreateDynamicObject(16118,-2094.1999500,1998.4000200,-6.5000000,0.0000000,0.0000000,0.0000000); //object(des_rockgp2_05)(1)
	CreateDynamicObject(16118,-2101.5000000,2000.5999800,-13.0000000,0.0000000,0.0000000,0.0000000); //object(des_rockgp2_05)(2)
	CreateDynamicObject(16113,-2099.6001000,2036.4000200,-13.6000000,0.0000000,3.9940000,311.9900000); //object(des_rockgp2_03)(10)
	CreateDynamicObject(16118,-2095.0000000,1954.4000200,-6.5000000,0.0000000,0.0000000,0.0000000); //object(des_rockgp2_05)(3)
	CreateDynamicObject(16118,-2098.3000500,1930.4000200,-6.5000000,0.0000000,0.0000000,0.0000000); //object(des_rockgp2_05)(4)
	CreateDynamicObject(16118,-2126.8999000,1917.4000200,-6.5000000,0.0000000,0.0000000,264.0000000); //object(des_rockgp2_05)(5)
	CreateDynamicObject(16118,-2154.8999000,1917.8000500,-6.5000000,0.0000000,0.0000000,263.9960000); //object(des_rockgp2_05)(6)
	CreateDynamicObject(16118,-2188.1001000,1919.0000000,-6.5000000,0.0000000,0.0000000,263.9960000); //object(des_rockgp2_05)(7)
	CreateDynamicObject(16118,-2217.8999000,1920.0000000,-6.5000000,0.0000000,0.0000000,263.9960000); //object(des_rockgp2_05)(8)
	CreateDynamicObject(16118,-2251.6001000,1921.1999500,-6.5000000,0.0000000,0.0000000,263.9960000); //object(des_rockgp2_05)(9)
	CreateDynamicObject(16118,-2282.3999000,1922.3000500,-6.5000000,0.0000000,0.0000000,263.9960000); //object(des_rockgp2_05)(10)
	CreateDynamicObject(16118,-2312.1999500,1923.3000500,-6.5000000,0.0000000,0.0000000,263.9960000); //object(des_rockgp2_05)(11)
	CreateDynamicObject(16118,-2324.1001000,1944.8000500,-6.5000000,0.0000000,0.0000000,347.9960000); //object(des_rockgp2_05)(12)
	CreateDynamicObject(16118,-2327.6001000,1979.5999800,-6.5000000,0.0000000,0.0000000,353.9920000); //object(des_rockgp2_05)(13)
	CreateDynamicObject(16118,-2331.8999000,2014.9000200,-6.5000000,0.0000000,0.0000000,353.9900000); //object(des_rockgp2_05)(14)
	CreateDynamicObject(16118,-2338.1001000,2029.0000000,-6.5000000,0.0000000,0.0000000,19.9900000); //object(des_rockgp2_05)(15)
	CreateDynamicObject(16118,-2345.8000500,2056.1999500,-6.5000000,0.0000000,0.0000000,357.9900000); //object(des_rockgp2_05)(16)
	CreateDynamicObject(16118,-2346.6999500,2096.3999000,-6.5000000,0.0000000,0.0000000,357.9900000); //object(des_rockgp2_05)(17)
	CreateDynamicObject(16118,-2347.5000000,2121.5000000,-6.5000000,0.0000000,0.0000000,357.9900000); //object(des_rockgp2_05)(18)
	CreateDynamicObject(16118,-2338.1001000,2152.5000000,-6.5000000,0.0000000,0.0000000,269.9900000); //object(des_rockgp2_05)(19)
	CreateDynamicObject(16118,-2308.6999500,2144.1999500,-6.5000000,0.0000000,0.0000000,237.9890000); //object(des_rockgp2_05)(20)
	CreateDynamicObject(17124,-504.2999900,-2008.0999800,45.2000000,357.9900000,0.0000000,173.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-483.2000100,-1950.5999800,45.2000000,357.9900000,0.0000000,173.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-580.0000000,-2038.5000000,45.2000000,357.9900000,0.0000000,173.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-600.6992200,-2106.0000000,42.0000000,357.9900000,0.0000000,219.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-633.0999800,-2172.3000500,45.2000000,357.9900000,0.0000000,173.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-682.7999900,-2225.6001000,45.2000000,357.9900000,0.0000000,173.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-756.9000200,-2194.1999500,45.2000000,357.9900000,0.0000000,173.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-823.2999900,-2244.8000500,45.2000000,357.9900000,0.0000000,173.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-964.7000100,-2013.3000500,45.2000000,357.9900000,0.0000000,122.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(684,-763.5999800,-1988.9000200,10.5000000,28.0000000,0.0000000,112.0000000); //object(sm_fir_log02)(1)
	CreateDynamicObject(17124,-965.7998000,-1939.7998000,51.5000000,357.9900000,0.0000000,99.9870000); //object(cuntwland58b)(3)
	CreateDynamicObject(844,-815.2000100,-1891.1999500,11.3000000,0.0000000,6.0000000,0.0000000); //object(dead_tree_16)(1)
	CreateDynamicObject(841,-814.2999900,-1893.0999800,10.3000000,0.0000000,0.0000000,0.0000000); //object(dead_tree_13)(1)
	CreateDynamicObject(840,-818.4000200,-1894.3000500,12.1000000,0.0000000,0.0000000,0.0000000); //object(dead_tree_12)(1)
	CreateDynamicObject(835,-827.0999800,-1903.6999500,13.5000000,0.0000000,0.0000000,0.0000000); //object(dead_tree_8)(1)
	CreateDynamicObject(16390,-835.9000200,-1896.4000200,11.6000000,0.0000000,0.0000000,332.0000000); //object(desn2_studbush)(1)
	CreateDynamicObject(16390,-839.5999800,-1887.9000200,11.6000000,0.0000000,0.0000000,331.9960000); //object(desn2_studbush)(2)
	CreateDynamicObject(16390,-821.0999800,-1885.5000000,11.4000000,0.0000000,4.0000000,331.9960000); //object(desn2_studbush)(3)
	CreateDynamicObject(16390,-817.2999900,-1869.0000000,11.6000000,0.0000000,0.0000000,331.9960000); //object(desn2_studbush)(4)
	CreateDynamicObject(16390,-804.0000000,-1872.6999500,10.4000000,0.0000000,0.0000000,331.9960000); //object(desn2_studbush)(5)
	CreateDynamicObject(16390,-819.9000200,-1889.0000000,10.6000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(6)
	CreateDynamicObject(16390,-815.0000000,-1880.3000500,10.9000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(7)
	CreateDynamicObject(16390,-830.0999800,-1888.6999500,10.9000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(8)
	CreateDynamicObject(16390,-844.7000100,-1909.1999500,14.4000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(9)
	CreateDynamicObject(671,-823.2000100,-1912.9000200,9.6000000,0.0000000,0.0000000,0.0000000); //object(sm_bushytree)(1)
	CreateDynamicObject(655,-814.5999800,-1905.5000000,8.7000000,0.0000000,0.0000000,0.0000000); //object(pinetree06)(1)
	CreateDynamicObject(16390,-807.2999900,-1870.5999800,13.4000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(10)
	CreateDynamicObject(16390,-813.7999900,-1875.6999500,13.4000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(11)
	CreateDynamicObject(16390,-840.9000200,-1918.4000200,13.4000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(12)
	CreateDynamicObject(16390,-865.2999900,-1942.5000000,16.2000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(13)
	CreateDynamicObject(16390,-865.4000200,-1954.4000200,16.2000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(14)
	CreateDynamicObject(16390,-875.5000000,-1957.3000500,16.2000000,0.0000000,3.9990000,331.9900000); //object(desn2_studbush)(15)
	CreateDynamicObject(16390,-854.4000200,-1964.9000200,12.0000000,0.0000000,15.4990000,341.7400000); //object(desn2_studbush)(16)
	CreateDynamicObject(16390,-861.2000100,-1967.4000200,16.5000000,354.0040000,2.0100000,330.2000000); //object(desn2_studbush)(17)
	CreateDynamicObject(683,-839.0000000,-1937.5999800,11.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(1)
	CreateDynamicObject(683,-839.4000200,-1955.3000500,11.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(2)
	CreateDynamicObject(683,-831.8994100,-1923.6992200,9.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(3)
	CreateDynamicObject(688,-823.0999800,-1916.0999800,9.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg)(1)
	CreateDynamicObject(688,-825.2999900,-1932.0999800,8.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg)(2)
	CreateDynamicObject(688,-809.2999900,-1897.6999500,8.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg)(3)
	CreateDynamicObject(688,-811.0999800,-1910.5000000,8.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg)(4)
	CreateDynamicObject(688,-821.9000200,-1902.4000200,8.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg)(5)
	CreateDynamicObject(688,-798.0999800,-1891.5999800,8.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg)(6)
	CreateDynamicObject(688,-788.4000200,-1878.5999800,8.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg)(7)
	CreateDynamicObject(688,-785.9000200,-1891.3000500,5.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_scabg)(8)
	CreateDynamicObject(18270,-834.5000000,-1923.0999800,24.5000000,0.0000000,0.0000000,0.0000000); //object(cw2_mntfir13)(1)
	CreateDynamicObject(722,-812.2000100,-1915.0000000,7.4000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(855,-735.2999900,-1954.0999800,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(1)
	CreateDynamicObject(855,-738.0000000,-1953.3000500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(2)
	CreateDynamicObject(855,-735.4000200,-1951.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(3)
	CreateDynamicObject(855,-734.0999800,-1956.1999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(4)
	CreateDynamicObject(855,-736.1992200,-1956.5000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(827,-729.2000100,-1944.5999800,7.9000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(1)
	CreateDynamicObject(827,-731.5999800,-1941.9000200,7.9000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(2)
	CreateDynamicObject(827,-728.5000000,-1941.0999800,7.9000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(3)
	CreateDynamicObject(722,-822.0996100,-1945.5996100,7.3000000,38.1610000,355.5450000,17.7480000); //object(veg_largefurs03)(2)
	CreateDynamicObject(10986,-784.7000100,-2149.1999500,25.2000000,0.0000000,0.0000000,148.0000000); //object(rubbled03_sfs)(1)
	CreateDynamicObject(10986,-782.5999800,-2156.3000500,26.2000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(2)
	CreateDynamicObject(10986,-782.0000000,-2146.6999500,25.2000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(3)
	CreateDynamicObject(10986,-785.0000000,-2149.3000500,26.0000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(4)
	CreateDynamicObject(10986,-794.0999800,-2151.3999000,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(6)
	CreateDynamicObject(10986,-788.7999900,-2146.8999000,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(7)
	CreateDynamicObject(10986,-790.5999800,-2143.6001000,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(8)
	CreateDynamicObject(10986,-789.4000200,-2145.8000500,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(9)
	CreateDynamicObject(10986,-790.7999900,-2146.8000500,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(10)
	CreateDynamicObject(10986,-791.4000200,-2147.1999500,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(11)
	CreateDynamicObject(10986,-791.4000200,-2147.3999000,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(12)
	CreateDynamicObject(10986,-791.4000200,-2147.6001000,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(13)
	CreateDynamicObject(10986,-792.5000000,-2148.3999000,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(14)
	CreateDynamicObject(10986,-792.5000000,-2148.6001000,23.8000000,0.0000000,0.0000000,103.9970000); //object(rubbled03_sfs)(15)
	CreateDynamicObject(10986,-674.5000000,-1883.9000200,6.1000000,0.0000000,0.0000000,223.9970000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-798.4000200,-2144.3999000,22.8000000,0.0000000,357.9900000,153.9900000); //object(rubbled03_sfs)(18)
	CreateDynamicObject(17124,-698.5996100,-2186.5000000,45.2000000,357.9900000,0.0000000,191.9860000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-596.1992200,-1838.0000000,34.5000000,357.9900000,0.0000000,153.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-567.4000200,-1939.4000200,28.2000000,357.9900000,0.0000000,153.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(16390,-687.5999800,-1987.8000500,13.8000000,0.0000000,0.0000000,0.0000000); //object(desn2_studbush)(18)
	CreateDynamicObject(16390,-681.5999800,-1988.0999800,16.3000000,0.0000000,0.0000000,0.0000000); //object(desn2_studbush)(19)
	CreateDynamicObject(16390,-680.5000000,-1983.4000200,15.8000000,0.0000000,0.0000000,0.0000000); //object(desn2_studbush)(20)
	CreateDynamicObject(16390,-672.5999800,-1986.0999800,20.0000000,0.0000000,0.0000000,0.0000000); //object(desn2_studbush)(21)
	CreateDynamicObject(16390,-676.0000000,-1993.9000200,20.3000000,0.0000000,0.0000000,0.0000000); //object(desn2_studbush)(22)
	CreateDynamicObject(16390,-689.0999800,-1995.4000200,18.3000000,0.0000000,352.0000000,20.0000000); //object(desn2_studbush)(23)
	CreateDynamicObject(16390,-678.0000000,-1960.5999800,14.0000000,0.0000000,351.9960000,19.9950000); //object(desn2_studbush)(24)
	CreateDynamicObject(16390,-695.0996100,-1971.7998000,12.3000000,352.0180000,355.9520000,21.4290000); //object(desn2_studbush)(25)
	CreateDynamicObject(12807,-656.5996100,-1942.5996100,17.2000000,0.0000000,3.9990000,59.9960000); //object(sw_logs4)(1)
	CreateDynamicObject(683,-668.4000200,-1917.6999500,7.2000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(4)
	CreateDynamicObject(683,-687.7999900,-1931.1999500,11.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(5)
	CreateDynamicObject(683,-685.5999800,-1978.3000500,18.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(6)
	CreateDynamicObject(683,-701.2999900,-1994.8000500,15.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(683,-710.0000000,-1970.1992200,9.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-686.5000000,-1995.1999500,18.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(9)
	CreateDynamicObject(7916,-721.0000000,-2091.3999000,16.3000000,0.0000000,0.0000000,196.0000000); //object(vegaswaterfall02)(1)
	CreateDynamicObject(7916,-712.5000000,-2090.3000500,16.3000000,0.0000000,0.0000000,195.9960000); //object(vegaswaterfall02)(2)
	CreateDynamicObject(7916,-703.4000200,-2091.6001000,18.3000000,0.0000000,0.0000000,195.9960000); //object(vegaswaterfall02)(3)
	CreateDynamicObject(7916,-697.0000000,-2084.8000500,18.3000000,0.0000000,0.0000000,195.9960000); //object(vegaswaterfall02)(4)
	CreateDynamicObject(7916,-699.7000100,-2085.1001000,16.0000000,0.0000000,0.0000000,195.9960000); //object(vegaswaterfall02)(5)
	CreateDynamicObject(7916,-755.5000000,-2095.0000000,16.0000000,0.0000000,0.0000000,165.9960000); //object(vegaswaterfall02)(6)
	CreateDynamicObject(7916,-749.5999800,-2090.8000500,14.8000000,0.0000000,0.0000000,165.9920000); //object(vegaswaterfall02)(7)
	CreateDynamicObject(7916,-728.2000100,-2092.6999500,14.8000000,0.0000000,0.0000000,175.9920000); //object(vegaswaterfall02)(8)
	CreateDynamicObject(9831,-727.5999800,-2060.1001000,5.1000000,356.0020000,357.9950000,359.8600000); //object(sfw_waterfall)(1)
	CreateDynamicObject(9831,-727.5999800,-2060.1001000,4.4000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(2)
	CreateDynamicObject(9831,-727.5999800,-2060.1001000,4.6000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(3)
	CreateDynamicObject(9831,-727.5999800,-2060.1001000,4.7000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(4)
	CreateDynamicObject(9831,-732.0999800,-2060.3000500,4.7000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(5)
	CreateDynamicObject(9831,-732.0999800,-2060.3000500,5.4000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(6)
	CreateDynamicObject(9831,-730.4000200,-2058.0000000,4.4000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(7)
	CreateDynamicObject(9831,-736.0999800,-2058.1999500,4.4000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(8)
	CreateDynamicObject(9831,-734.5999800,-2058.1001000,4.4000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(9)
	CreateDynamicObject(9831,-736.5999800,-2058.1999500,5.2000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(10)
	CreateDynamicObject(9831,-740.7999900,-2058.3999000,4.7000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(11)
	CreateDynamicObject(9831,-740.7999900,-2058.3999000,5.4000000,356.0010000,357.9950000,359.8570000); //object(sfw_waterfall)(12)
	CreateDynamicObject(9831,-765.9000200,-2055.3999000,5.2000000,356.2900000,22.0480000,1.4980000); //object(sfw_waterfall)(13)
	CreateDynamicObject(9831,-762.2999900,-2056.3999000,5.9000000,356.2870000,22.0440000,1.4940000); //object(sfw_waterfall)(14)
	CreateDynamicObject(9831,-765.7000100,-2055.3999000,5.9000000,356.2870000,22.0440000,1.4940000); //object(sfw_waterfall)(15)
	CreateDynamicObject(9831,-758.5000000,-2057.5000000,5.4000000,356.2870000,22.0440000,1.4940000); //object(sfw_waterfall)(16)
	CreateDynamicObject(9831,-751.7999900,-2059.3999000,5.4000000,356.2870000,22.0440000,1.4940000); //object(sfw_waterfall)(17)
	CreateDynamicObject(9831,-747.7000100,-2060.6001000,5.4000000,356.2870000,22.0440000,1.4940000); //object(sfw_waterfall)(18)
	CreateDynamicObject(9831,-746.2000100,-2062.6001000,6.2000000,356.2870000,22.0440000,1.4940000); //object(sfw_waterfall)(19)
	CreateDynamicObject(9831,-749.0999800,-2061.8000500,6.2000000,355.9950000,359.9950000,359.9920000); //object(sfw_waterfall)(20)
	CreateDynamicObject(9831,-752.4000200,-2062.3999000,6.2000000,355.9900000,359.9950000,359.9890000); //object(sfw_waterfall)(21)
	CreateDynamicObject(9831,-757.2999900,-2064.0000000,7.2000000,355.9900000,359.9950000,359.9890000); //object(sfw_waterfall)(22)
	CreateDynamicObject(3502,-760.0996100,-2101.5000000,18.7000000,0.0000000,0.0000000,0.0000000); //object(vgsn_con_tube)(1)
	CreateDynamicObject(3502,-743.4000200,-2107.8999000,20.2000000,0.0000000,0.0000000,0.0000000); //object(vgsn_con_tube)(2)
	CreateDynamicObject(3502,-748.5000000,-2108.8999000,20.2000000,0.0000000,0.0000000,0.0000000); //object(vgsn_con_tube)(3)
	CreateDynamicObject(3502,-754.2000100,-2105.1001000,17.5000000,0.0000000,0.0000000,0.0000000); //object(vgsn_con_tube)(4)
	CreateDynamicObject(3502,-727.0000000,-2100.3999000,19.8000000,0.0000000,0.0000000,0.0000000); //object(vgsn_con_tube)(5)
	CreateDynamicObject(3502,-734.5999800,-2103.1001000,19.8000000,0.0000000,0.0000000,0.0000000); //object(vgsn_con_tube)(6)
	CreateDynamicObject(3502,-721.9000200,-2095.5000000,19.8000000,0.0000000,0.0000000,20.0000000); //object(vgsn_con_tube)(7)
	CreateDynamicObject(3502,-730.0996100,-2101.1992200,19.8000000,0.0000000,0.0000000,3.9940000); //object(vgsn_con_tube)(8)
	CreateDynamicObject(3502,-738.4000200,-2103.1001000,19.8000000,0.0000000,0.0000000,3.9940000); //object(vgsn_con_tube)(9)
	CreateDynamicObject(18259,-819.0000000,-2054.1999500,25.6000000,0.0000000,1.2500000,221.9950000); //object(logcabinn01)(1)
	CreateDynamicObject(3286,-810.2000100,-2064.0000000,28.1000000,0.0000000,0.0000000,0.0000000); //object(cxrf_watertwr)(2)
	CreateDynamicObject(18259,-796.7999900,-2091.5000000,25.0000000,0.0000000,2.0000000,224.0000000); //object(logcabinn01)(2)
	CreateDynamicObject(18259,-677.5000000,-2034.0000000,24.3000000,0.0000000,357.9950000,3.9940000); //object(logcabinn01)(3)
	CreateDynamicObject(9831,-771.5999800,-2055.3999000,11.0000000,5.7050000,341.9070000,359.8600000); //object(sfw_waterfall)(23)
	CreateDynamicObject(9831,-773.5999800,-2053.8999000,10.3000000,3.8500000,309.8430000,2.5980000); //object(sfw_waterfall)(24)
	CreateDynamicObject(9831,-768.7999900,-2053.8999000,8.8000000,5.6270000,20.0970000,355.9490000); //object(sfw_waterfall)(25)
	CreateDynamicObject(9831,-767.0999800,-2058.6999500,11.8000000,5.9290000,8.0360000,351.1640000); //object(sfw_waterfall)(26)
	CreateDynamicObject(9831,-771.0000000,-2050.3999000,11.1000000,7.9070000,8.0650000,350.8790000); //object(sfw_waterfall)(27)
	CreateDynamicObject(16110,-876.0000000,-2020.5000000,14.3000000,0.7490000,68.0110000,326.1440000); //object(des_rockgp1_01)(1)
	CreateDynamicObject(7947,-709.4000200,-2058.0000000,7.3000000,0.0000000,0.0000000,40.0000000); //object(vegaspumphouse1)(1)
	CreateDynamicObject(7947,-790.2000100,-2044.4000200,6.8000000,354.0000000,0.0000000,315.9960000); //object(vegaspumphouse1)(2)
	CreateDynamicObject(3502,-777.0999800,-2093.3999000,18.7000000,0.0000000,0.0000000,322.0000000); //object(vgsn_con_tube)(1)
	CreateDynamicObject(3214,-659.7000100,-1850.5999800,25.8000000,0.0000000,0.0000000,318.0000000); //object(quarry_crusher)(1)
	CreateDynamicObject(16072,-646.7000100,-1842.0000000,46.9000000,11.1150000,22.4430000,239.4470000); //object(des_quarrybelt01)(1)
	CreateDynamicObject(17124,-612.0000000,-1805.8994100,40.5000000,357.9900000,0.0000000,153.9900000); //object(cuntwland58b)(3)
	CreateDynamicObject(16318,-844.5999800,-1992.1999500,20.7000000,1.9940000,2.0000000,189.9260000); //object(des_quarrybelt18)(1)
	CreateDynamicObject(16302,-656.4000200,-1848.0000000,15.7000000,0.0000000,0.0000000,0.0000000); //object(des_gravelpile04)(1)
	CreateDynamicObject(16302,-820.9000200,-1989.5000000,6.2000000,0.0000000,0.0000000,0.0000000); //object(des_gravelpile04)(2)
	CreateDynamicObject(1304,-844.5000000,-1992.0999800,22.2000000,0.0000000,0.0000000,0.0000000); //object(dyn_quarryrock02)(1)
	CreateDynamicObject(1304,-842.7000100,-1991.4000200,22.1000000,0.0000000,0.0000000,0.0000000); //object(dyn_quarryrock02)(2)
	CreateDynamicObject(1304,-847.5999800,-1993.4000200,23.1000000,0.0000000,0.0000000,0.0000000); //object(dyn_quarryrock02)(3)
	CreateDynamicObject(1304,-846.5000000,-1992.3000500,22.2000000,0.0000000,0.0000000,0.0000000); //object(dyn_quarryrock02)(4)
	CreateDynamicObject(12990,-760.0999800,-1952.9000200,5.4000000,358.5000000,0.0000000,326.4870000); //object(sw_jetty)(6)
	CreateDynamicObject(12990,-743.0999800,-1920.0000000,5.6000000,0.7450000,355.4960000,326.5440000); //object(sw_jetty)(6)
	CreateDynamicObject(16087,-705.0000000,-2087.1999500,37.2000000,276.0000000,180.0000000,204.0000000); //object(des_oilfieldpipe01)(2)
	CreateDynamicObject(16087,-704.5999800,-2088.1001000,37.1000000,275.9990000,179.9950000,204.0000000); //object(des_oilfieldpipe01)(3)
	CreateDynamicObject(16087,-704.2000100,-2089.1001000,37.1000000,275.9990000,179.9950000,204.0000000); //object(des_oilfieldpipe01)(4)
	CreateDynamicObject(7947,-697.9000200,-2085.5000000,33.3000000,0.0000000,2.0000000,245.9960000); //object(vegaspumphouse1)(3)
	CreateDynamicObject(3440,-698.7000100,-2071.8999000,21.8000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(1)
	CreateDynamicObject(3440,-698.7000100,-2071.8999000,24.0000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(7)
	CreateDynamicObject(3440,-698.7000100,-2071.8999000,26.5000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(8)
	CreateDynamicObject(3440,-698.7000100,-2071.8999000,28.8000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(9)
	CreateDynamicObject(3440,-698.7000100,-2071.8999000,31.1000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(10)
	CreateDynamicObject(3440,-698.7000100,-2071.8999000,31.9000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(11)
	CreateDynamicObject(3440,-704.5999800,-2083.6001000,21.8000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(12)
	CreateDynamicObject(3440,-704.5999800,-2083.6001000,25.5000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(13)
	CreateDynamicObject(3440,-704.5999800,-2083.6001000,28.8000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(14)
	CreateDynamicObject(3440,-704.5999800,-2083.6001000,31.1000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(15)
	CreateDynamicObject(3440,-704.5999800,-2083.6001000,32.1000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(16)
	CreateDynamicObject(3440,-707.9000200,-2090.5000000,21.8000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(17)
	CreateDynamicObject(3440,-707.9000200,-2090.5000000,25.0000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(22)
	CreateDynamicObject(3440,-707.9000200,-2090.5000000,27.8000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(23)
	CreateDynamicObject(3440,-707.9000200,-2090.5000000,30.8000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(24)
	CreateDynamicObject(3440,-707.9000200,-2090.5000000,32.1000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(25)
	CreateDynamicObject(3095,-700.2000100,-2074.0000000,33.1000000,2.0000000,0.0000000,336.0000000); //object(a51_jetdoor)(3)
	CreateDynamicObject(3095,-703.5000000,-2081.0000000,32.8000000,2.0000000,0.7470000,334.7200000); //object(a51_jetdoor)(4)
	CreateDynamicObject(3095,-706.7000100,-2087.8000500,32.5000000,2.0000000,0.7420000,334.7150000); //object(a51_jetdoor)(5)
	CreateDynamicObject(3095,-710.2000100,-2095.1999500,32.2000000,2.0000000,0.7420000,334.7150000); //object(a51_jetdoor)(6)
	CreateDynamicObject(12950,-685.7999900,-2061.3999000,26.4000000,0.0000000,0.0000000,124.0000000); //object(cos_sbanksteps03)(1)
	CreateDynamicObject(12950,-689.5000000,-2063.8999000,31.2000000,0.0000000,0.0000000,123.9970000); //object(cos_sbanksteps03)(2)
	CreateDynamicObject(3095,-696.0999800,-2067.8999000,33.4000000,2.0000000,0.0000000,316.4950000); //object(a51_jetdoor)(8)
	CreateDynamicObject(3440,-697.2999900,-2063.6001000,21.8000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(26)
	CreateDynamicObject(3440,-697.2999900,-2063.6001000,20.8000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(27)
	CreateDynamicObject(3440,-697.2999900,-2063.6001000,25.5000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(28)
	CreateDynamicObject(3440,-697.2999900,-2063.6001000,28.3000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(29)
	CreateDynamicObject(3440,-697.2999900,-2063.6001000,31.1000000,0.0000000,0.0000000,0.0000000); //object(arptpillar01_lvs)(30)
	CreateDynamicObject(14877,-700.0999800,-2069.1999500,36.0000000,0.0000000,0.0000000,238.7500000); //object(michelle-stairs)(1)
	CreateDynamicObject(14877,-700.5000000,-2070.1001000,37.1000000,359.7510000,354.0000000,239.7180000); //object(michelle-stairs)(2)
	CreateDynamicObject(3502,-753.9000200,-2107.5000000,34.1000000,0.0000000,0.0000000,293.7440000); //object(vgsn_con_tube)(8)
	CreateDynamicObject(3502,-754.5000000,-2107.1001000,39.1000000,0.0000000,0.0000000,290.9930000); //object(vgsn_con_tube)(8)
	CreateDynamicObject(12807,-656.5999800,-1942.5999800,15.2000000,0.0000000,3.9990000,59.9960000); //object(sw_logs4)(1)
	CreateDynamicObject(18249,-696.9000200,-1848.1999500,18.6000000,0.0000000,0.0000000,80.0000000); //object(cuntwjunk05)(1)
	CreateDynamicObject(18252,-727.2000100,-1851.9000200,16.4000000,1.0000000,0.7500000,201.4870000); //object(cuntwjunk08)(1)
	CreateDynamicObject(647,-715.7000100,-1981.6999500,12.5000000,0.0000000,0.0000000,0.0000000); //object(new_bushsm)(1)
	CreateDynamicObject(722,-663.7000100,-2020.0999800,23.7000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(722,-654.4000200,-2011.8000500,22.0000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(722,-669.7999900,-2013.6999500,23.7000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(722,-663.5000000,-2008.4000200,23.7000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(722,-657.9000200,-1999.0999800,23.7000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(722,-660.9000200,-2029.4000200,23.7000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(722,-671.2000100,-2022.3000500,23.7000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(722,-651.4000200,-2015.3000500,23.7000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(722,-652.7999900,-2021.1999500,23.7000000,0.0000000,0.0000000,0.0000000); //object(veg_largefurs03)(1)
	CreateDynamicObject(683,-672.9000200,-1999.5999800,18.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(683,-668.9000200,-2011.9000200,18.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(683,-660.0000000,-2020.4000200,18.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(683,-653.2999900,-2019.8000500,20.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(683,-684.5999800,-2002.6999500,17.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(683,-677.4000200,-2012.6999500,17.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(683,-693.2000100,-2015.1999500,15.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(683,-699.2999900,-2011.5999800,15.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(683,-696.4000200,-2029.9000200,10.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(7)
	CreateDynamicObject(17027,-770.0999800,-1851.6999500,14.2000000,0.0000000,0.0000000,0.0000000); //object(cunt_rockgp1_03)(1)
	CreateDynamicObject(17027,-779.2999900,-1862.9000200,9.0000000,0.0000000,0.0000000,0.0000000); //object(cunt_rockgp1_03)(2)
	CreateDynamicObject(17027,-648.0000000,-1828.3000500,30.3000000,0.0000000,0.0000000,278.0000000); //object(cunt_rockgp1_03)(3)
	CreateDynamicObject(17027,-766.2998000,-1863.3994100,7.6000000,0.0000000,0.0000000,0.0000000); //object(cunt_rockgp1_03)(4)
	CreateDynamicObject(17027,-622.9000200,-1862.8000500,27.6000000,0.0000000,0.0000000,253.9980000); //object(cunt_rockgp1_03)(5)
	CreateDynamicObject(17027,-629.7999900,-1865.4000200,33.8000000,54.1860000,72.8690000,206.8050000); //object(cunt_rockgp1_03)(6)
	CreateDynamicObject(6928,-631.4000200,-1861.3000500,24.0000000,358.2970000,260.1450000,29.8530000); //object(vegasplant03)(1)
	CreateDynamicObject(16302,-639.0999800,-1861.5000000,16.3000000,348.0000000,0.0000000,56.0000000); //object(des_gravelpile04)(3)
	CreateDynamicObject(16302,-639.0000000,-1867.9000200,14.8000000,359.9970000,0.0000000,55.9970000); //object(des_gravelpile04)(4)
	CreateDynamicObject(16302,-646.4000200,-1862.6999500,14.8000000,359.9950000,0.0000000,55.9920000); //object(des_gravelpile04)(5)
	CreateDynamicObject(16302,-650.9000200,-1865.5000000,12.6000000,359.9950000,0.0000000,55.9920000); //object(des_gravelpile04)(6)
	CreateDynamicObject(16302,-643.0999800,-1871.0999800,12.6000000,359.9950000,0.0000000,55.9920000); //object(des_gravelpile04)(7)
	CreateDynamicObject(16302,-640.2000100,-1874.0999800,12.6000000,359.9950000,0.0000000,55.9920000); //object(des_gravelpile04)(8)
	CreateDynamicObject(16302,-631.4000200,-1869.9000200,16.6000000,359.9950000,0.0000000,55.9920000); //object(des_gravelpile04)(9)
	CreateDynamicObject(16302,-642.0000000,-1855.0000000,18.4000000,359.9950000,0.0000000,55.9920000); //object(des_gravelpile04)(10)
	CreateDynamicObject(16302,-646.2999900,-1860.6999500,15.9000000,359.9950000,0.0000000,55.9920000); //object(des_gravelpile04)(11)
	CreateDynamicObject(17027,-650.2999900,-1819.5999800,30.3000000,0.0000000,8.0000000,247.9980000); //object(cunt_rockgp1_03)(7)
	CreateDynamicObject(17027,-650.9000200,-1814.3000500,48.6000000,0.0000000,17.9980000,247.9940000); //object(cunt_rockgp1_03)(8)
	CreateDynamicObject(17027,-654.0000000,-1818.8000500,42.8000000,0.0000000,17.9960000,247.9940000); //object(cunt_rockgp1_03)(9)
	CreateDynamicObject(17027,-661.7000100,-1809.0999800,38.8000000,0.0000000,17.9960000,247.9940000); //object(cunt_rockgp1_03)(10)
	CreateDynamicObject(2780,-639.9000200,-1863.0000000,19.4000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(8)
	CreateDynamicObject(2780,-637.7000100,-1866.0000000,19.4000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(9)
	CreateDynamicObject(2780,-636.5999800,-1869.5999800,19.4000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(10)
	CreateDynamicObject(2780,-637.7000100,-1868.9000200,21.4000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(11)
	CreateDynamicObject(2780,-640.0999800,-1865.6999500,21.4000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(12)
	CreateDynamicObject(2780,-642.7999900,-1862.0999800,21.4000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(13)
	CreateDynamicObject(2780,-643.2999900,-1859.3000500,21.4000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(14)
	CreateDynamicObject(2780,-636.7999900,-1865.0999800,25.2000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(15)
	CreateDynamicObject(2780,-633.2999900,-1867.8000500,25.2000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(16)
	CreateDynamicObject(2780,-637.2000100,-1865.4000200,25.2000000,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(17)
	CreateDynamicObject(8832,-661.3994100,-1881.8994100,7.6000000,0.7140000,343.2460000,34.2110000); //object(pirtebrdg01_lvs)(1)
	CreateDynamicObject(3035,-671.7999900,-1882.3000500,8.5000000,80.0120000,322.9400000,328.6400000); //object(tmp_bin)(1)
	CreateDynamicObject(3035,-669.7999900,-1885.6999500,8.0000000,80.0080000,322.9380000,12.6390000); //object(tmp_bin)(2)
	CreateDynamicObject(2890,-672.7000100,-1883.1999500,7.0000000,10.0000000,0.0000000,10.0000000); //object(kmb_skip)(1)
	CreateDynamicObject(853,-670.2999900,-1888.5000000,7.5000000,0.0000000,0.0000000,0.0000000); //object(cj_urb_rub_5)(1)
	CreateDynamicObject(10986,-676.5000000,-1884.3000500,5.1000000,3.8680000,14.7840000,222.9750000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-676.5000000,-1884.3000500,5.6000000,5.9780000,4.7740000,223.4940000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-675.5000000,-1888.0999800,5.6000000,5.9770000,4.7740000,223.4890000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-744.9000200,-2018.0000000,1.4000000,5.9770000,4.7740000,223.4890000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-676.9000200,-1881.1999500,6.1000000,5.9770000,4.7740000,233.4890000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-673.5999800,-1893.5999800,4.4000000,356.0690000,348.7210000,233.2010000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-675.7999900,-1893.5000000,4.4000000,356.0670000,348.7170000,233.1960000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(879,-742.0000000,-2024.0000000,5.4000000,0.0000000,0.0000000,0.0000000); //object(p_rubble04bcol)(1)
	CreateDynamicObject(879,-739.0999800,-2026.3000500,5.4000000,0.0000000,0.0000000,24.0000000); //object(p_rubble04bcol)(2)
	CreateDynamicObject(879,-737.4000200,-2020.1999500,5.4000000,0.0000000,0.0000000,24.0000000); //object(p_rubble04bcol)(3)
	CreateDynamicObject(879,-734.9000200,-2023.0999800,5.4000000,0.0000000,0.0000000,24.0000000); //object(p_rubble04bcol)(4)
	CreateDynamicObject(879,-732.5999800,-2026.6999500,5.4000000,0.0000000,0.0000000,24.0000000); //object(p_rubble04bcol)(5)
	CreateDynamicObject(879,-729.4000200,-2024.3000500,5.4000000,0.0000000,0.0000000,24.0000000); //object(p_rubble04bcol)(6)
	CreateDynamicObject(879,-731.4000200,-2021.0999800,5.4000000,0.0000000,0.0000000,24.0000000); //object(p_rubble04bcol)(7)
	CreateDynamicObject(879,-731.7999900,-2016.3000500,5.4000000,0.0000000,0.0000000,24.0000000); //object(p_rubble04bcol)(8)
	CreateDynamicObject(879,-735.5999800,-2028.9000200,5.4000000,0.0000000,0.0000000,24.0000000); //object(p_rubble04bcol)(9)
	CreateDynamicObject(879,-735.2000100,-2024.5000000,6.6000000,17.2800000,343.2220000,29.1170000); //object(p_rubble04bcol)(10)
	CreateDynamicObject(879,-732.9000200,-2025.4000200,6.6000000,17.2760000,343.2180000,77.1140000); //object(p_rubble04bcol)(11)
	CreateDynamicObject(10986,-679.0996100,-1883.0000000,5.6000000,5.9770000,4.7740000,223.4890000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-740.2999900,-2014.1999500,1.4000000,5.9770000,4.7740000,223.4890000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-740.4000200,-2015.6999500,2.2000000,5.9770000,4.7740000,223.4890000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-744.2999900,-2022.4000200,2.2000000,5.9770000,4.7740000,223.4890000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-744.7999900,-2022.4000200,2.0000000,5.9770000,4.7740000,223.4890000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-741.7999900,-2028.0000000,2.0000000,5.9770000,4.7740000,253.4890000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-739.4000200,-2023.5000000,3.8000000,5.9710000,4.7740000,253.4880000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-743.2000100,-2020.9000200,2.6000000,9.9570000,4.8200000,253.1500000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-734.7000100,-2030.6999500,2.6000000,9.9540000,4.8180000,295.1470000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-738.9000200,-2032.0000000,2.6000000,9.9480000,4.8120000,295.1420000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(10986,-736.4000200,-2032.0999800,2.6000000,9.9480000,4.8120000,295.1420000); //object(rubbled03_sfs)(16)
	CreateDynamicObject(879,-732.9000200,-2025.4000200,4.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(12)
	CreateDynamicObject(879,-736.5999800,-2025.0000000,4.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(13)
	CreateDynamicObject(879,-739.2000100,-2018.6999500,4.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(14)
	CreateDynamicObject(879,-736.4000200,-2017.0000000,3.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(15)
	CreateDynamicObject(879,-733.2000100,-2015.0999800,3.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(16)
	CreateDynamicObject(879,-731.0000000,-2018.6999500,3.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(17)
	CreateDynamicObject(879,-731.5999800,-2023.0999800,3.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(18)
	CreateDynamicObject(879,-732.2000100,-2025.5000000,3.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(19)
	CreateDynamicObject(879,-733.2000100,-2025.8000500,3.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(20)
	CreateDynamicObject(879,-733.5000000,-2025.4000200,3.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(21)
	CreateDynamicObject(879,-733.9000200,-2024.8000500,3.4000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(22)
	CreateDynamicObject(879,-739.2999900,-2022.9000200,1.7000000,17.2760000,343.2180000,77.1130000); //object(p_rubble04bcol)(23)
	CreateDynamicObject(13367,-735.7999900,-2022.4000200,17.7000000,0.0000000,0.0000000,0.0000000); //object(sw_watertower01)(1)
	CreateDynamicObject(683,-702.4000200,-1956.9000200,9.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-694.2999900,-1943.6999500,9.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-688.9000200,-1916.6999500,6.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-747.4000200,-1860.5000000,9.4000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-754.0999800,-1866.3000500,9.4000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-764.2000100,-1874.0000000,9.4000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-779.7999900,-1874.5000000,9.4000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-630.9000200,-1895.5999800,11.6000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-680.2999900,-1959.0999800,17.7000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-639.0000000,-1882.4000200,5.4000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-640.5000000,-1901.1999500,5.4000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-639.0996100,-1890.6992200,8.1000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-661.2000100,-1945.9000200,17.7000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-782.9000200,-2091.1001000,20.2000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-804.5000000,-2068.6999500,22.3000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-780.5000000,-2067.1992200,12.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-782.4000200,-2073.6001000,12.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-834.9000200,-2029.5000000,18.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-843.0000000,-2018.9000200,16.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-835.4000200,-2019.5999800,16.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-840.0000000,-2009.4000200,16.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-844.2999900,-2001.6999500,14.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-849.7999900,-1976.3000500,11.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(9153,-831.2000100,-2015.5000000,18.1000000,358.0190000,8.0050000,18.2780000); //object(bush14_lvs)(1)
	CreateDynamicObject(9153,-831.7999900,-2024.6999500,21.1000000,358.0170000,8.0040000,18.2760000); //object(bush14_lvs)(2)
	CreateDynamicObject(9153,-843.9000200,-2031.5000000,23.1000000,358.0170000,8.0040000,18.2760000); //object(bush14_lvs)(3)
	CreateDynamicObject(9153,-835.2000100,-2037.5999800,23.1000000,358.0170000,8.0040000,314.2760000); //object(bush14_lvs)(4)
	CreateDynamicObject(9153,-850.2000100,-1976.0000000,16.6000000,356.0140000,6.0080000,350.4150000); //object(bush14_lvs)(5)
	CreateDynamicObject(9153,-791.7000100,-2077.8999000,16.6000000,356.0120000,6.0040000,350.4140000); //object(bush14_lvs)(6)
	CreateDynamicObject(9153,-787.0000000,-2109.6999500,26.1000000,356.0120000,6.0040000,36.4140000); //object(bush14_lvs)(7)
	CreateDynamicObject(9153,-688.4000200,-2023.5999800,16.9000000,1.9790000,5.9930000,15.7870000); //object(bush14_lvs)(8)
	CreateDynamicObject(9153,-676.7999900,-1981.0000000,22.7000000,1.9780000,5.9930000,15.7820000); //object(bush14_lvs)(9)
	CreateDynamicObject(9153,-648.2999900,-1954.5999800,19.7000000,1.9780000,5.9930000,49.7820000); //object(bush14_lvs)(10)
	CreateDynamicObject(9153,-656.7999900,-1927.8000500,8.5000000,1.9720000,5.9930000,49.7790000); //object(bush14_lvs)(11)
	CreateDynamicObject(9153,-675.0000000,-1836.1999500,17.3000000,1.9720000,5.9930000,67.7790000); //object(bush14_lvs)(12)
	CreateDynamicObject(683,-674.2999900,-1838.1999500,15.7000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-671.0996100,-1843.0996100,13.5000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-738.0000000,-1861.6999500,9.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(9153,-761.2000100,-1863.1999500,9.3000000,0.0000000,0.0000000,32.0000000); //object(bush14_lvs)(13)
	CreateDynamicObject(9153,-747.0000000,-1854.6999500,11.1000000,0.0000000,0.0000000,81.9980000); //object(bush14_lvs)(14)
	CreateDynamicObject(9153,-777.0000000,-1869.6999500,8.9000000,0.0000000,0.0000000,81.9960000); //object(bush14_lvs)(15)
	CreateDynamicObject(9153,-765.2999900,-1859.0999800,10.4000000,0.0000000,0.0000000,81.9960000); //object(bush14_lvs)(16)
	CreateDynamicObject(9153,-786.9000200,-1871.8000500,11.4000000,0.0000000,0.0000000,81.9960000); //object(bush14_lvs)(17)
	CreateDynamicObject(818,-735.7999900,-1946.1999500,4.6000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(1)
	CreateDynamicObject(818,-735.2000100,-1940.6999500,4.6000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(2)
	CreateDynamicObject(818,-730.2000100,-1936.5000000,4.6000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(3)
	CreateDynamicObject(818,-721.2000100,-1943.5000000,4.6000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(4)
	CreateDynamicObject(818,-731.2000100,-1964.1999500,4.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(5)
	CreateDynamicObject(818,-749.5999800,-1958.4000200,4.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(6)
	CreateDynamicObject(818,-744.0999800,-1949.4000200,4.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(7)
	CreateDynamicObject(818,-736.0999800,-1931.6999500,4.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(8)
	CreateDynamicObject(818,-719.0000000,-1932.0999800,4.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(9)
	CreateDynamicObject(818,-727.2000100,-1956.8000500,4.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(10)
	CreateDynamicObject(818,-741.0000000,-1965.0999800,4.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(11)
	CreateDynamicObject(818,-728.9000200,-1987.9000200,4.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(12)
	CreateDynamicObject(818,-732.4000200,-2006.8000500,4.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(13)
	CreateDynamicObject(818,-752.5999800,-2012.0999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(14)
	CreateDynamicObject(818,-755.2000100,-2018.9000200,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(15)
	CreateDynamicObject(818,-762.0999800,-2026.0999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(16)
	CreateDynamicObject(818,-768.2999900,-2042.0000000,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(17)
	CreateDynamicObject(818,-751.0000000,-2035.1999500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(18)
	CreateDynamicObject(818,-765.7999900,-2034.9000200,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(19)
	CreateDynamicObject(818,-745.7000100,-2025.3000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(20)
	CreateDynamicObject(818,-743.5999800,-2031.5000000,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(21)
	CreateDynamicObject(818,-738.2000100,-2032.8000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(22)
	CreateDynamicObject(818,-738.2999900,-2040.5999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(23)
	CreateDynamicObject(818,-755.7000100,-2041.0000000,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(24)
	CreateDynamicObject(818,-725.9000200,-2034.3000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(25)
	CreateDynamicObject(818,-729.4000200,-2023.4000200,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(26)
	CreateDynamicObject(818,-730.5000000,-2018.8000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(27)
	CreateDynamicObject(818,-734.2999900,-2016.0999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(28)
	CreateDynamicObject(818,-739.2999900,-2015.8000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(29)
	CreateDynamicObject(818,-770.7999900,-2025.9000200,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(30)
	CreateDynamicObject(818,-775.0000000,-2035.1999500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(31)
	CreateDynamicObject(818,-773.9000200,-2016.4000200,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(32)
	CreateDynamicObject(818,-785.2000100,-2012.3000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(33)
	CreateDynamicObject(818,-800.9000200,-2005.1999500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(34)
	CreateDynamicObject(818,-795.7999900,-2012.5000000,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(35)
	CreateDynamicObject(818,-802.2000100,-1992.9000200,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(36)
	CreateDynamicObject(818,-805.0000000,-1984.0000000,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(37)
	CreateDynamicObject(818,-810.5000000,-1967.8000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(38)
	CreateDynamicObject(818,-803.7999900,-1973.0000000,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(39)
	CreateDynamicObject(818,-799.2000100,-1944.6999500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(40)
	CreateDynamicObject(818,-790.9000200,-1942.0999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(41)
	CreateDynamicObject(818,-813.2999900,-1955.8000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(42)
	CreateDynamicObject(818,-801.7000100,-1959.0999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(43)
	CreateDynamicObject(818,-789.5999800,-1937.3000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(44)
	CreateDynamicObject(818,-782.0999800,-1938.6999500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(45)
	CreateDynamicObject(818,-776.5999800,-1942.3000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(46)
	CreateDynamicObject(818,-769.5999800,-1945.4000200,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(47)
	CreateDynamicObject(818,-775.2999900,-1947.5000000,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(48)
	CreateDynamicObject(818,-785.5000000,-1931.5999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(49)
	CreateDynamicObject(818,-764.7999900,-1913.5000000,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(50)
	CreateDynamicObject(818,-760.9000200,-1914.5999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(51)
	CreateDynamicObject(818,-758.0999800,-1909.6999500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(52)
	CreateDynamicObject(818,-765.9000200,-1904.5000000,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(53)
	CreateDynamicObject(818,-756.2000100,-1920.1999500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(54)
	CreateDynamicObject(818,-751.2999900,-1911.5999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(55)
	CreateDynamicObject(818,-727.0999800,-1881.8000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(56)
	CreateDynamicObject(818,-718.9000200,-1884.5999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(57)
	CreateDynamicObject(818,-704.7000100,-1888.0999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(58)
	CreateDynamicObject(818,-692.7000100,-1894.0999800,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(59)
	CreateDynamicObject(818,-694.2000100,-1901.8000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(60)
	CreateDynamicObject(818,-676.2999900,-1897.1999500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(61)
	CreateDynamicObject(818,-662.5999800,-1893.3000500,5.1000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass02)(62)
	CreateDynamicObject(855,-728.4000200,-1929.1999500,4.3000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(6)
	CreateDynamicObject(855,-734.7000100,-1929.5000000,2.3000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(7)
	CreateDynamicObject(855,-730.0999800,-1951.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-723.9000200,-1953.0000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-728.5000000,-1962.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-733.7000100,-1936.5000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-724.0999800,-1935.0000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-716.7999900,-1933.3000500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-729.5999800,-1981.6999500,3.2000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-732.0000000,-2006.4000200,3.2000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-726.0000000,-2017.8000500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-723.5000000,-2027.8000500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-731.0999800,-2035.5999800,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-742.9000200,-2036.1999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-751.0000000,-2029.5999800,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-757.0999800,-2034.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-761.2000100,-2045.9000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-760.5999800,-2051.8999000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-750.4000200,-2019.5999800,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-760.4000200,-2022.9000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-766.2999900,-2029.5999800,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-792.7999900,-2011.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-774.7999900,-2015.8000500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-780.7999900,-2011.6999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-792.5999800,-2004.6999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-805.7999900,-2008.6999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-808.2999900,-1996.9000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-795.5000000,-1998.6999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-799.0000000,-1983.0000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-800.5000000,-1978.1999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-814.0000000,-1973.3000500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-806.2999900,-1963.6999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-799.2000100,-1951.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-798.7000100,-1942.3000500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-794.7999900,-1934.6999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-786.2999900,-1939.0000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-784.7000100,-1944.0000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-777.4000200,-1936.5999800,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-779.4000200,-1930.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-771.7999900,-1908.1999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-761.5000000,-1907.1999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-758.7999900,-1902.1999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-753.2999900,-1906.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-754.5000000,-1914.3000500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-719.7000100,-1882.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-722.4000200,-1878.5999800,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-711.9000200,-1883.5999800,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-699.0000000,-1886.4000200,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-698.7000100,-1894.0000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-685.5000000,-1897.1999500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-688.5000000,-1890.3000500,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(855,-667.7000100,-1895.5000000,4.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass01)(5)
	CreateDynamicObject(827,-803.9000200,-1943.3000500,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(4)
	CreateDynamicObject(827,-785.5000000,-1936.0999800,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(5)
	CreateDynamicObject(827,-771.2999900,-1942.8000500,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(6)
	CreateDynamicObject(827,-753.5999800,-1953.1999500,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(7)
	CreateDynamicObject(827,-743.7000100,-1958.3000500,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(8)
	CreateDynamicObject(827,-733.5999800,-1963.8000500,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(9)
	CreateDynamicObject(827,-735.2999900,-1952.5999800,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(10)
	CreateDynamicObject(827,-735.9000200,-1930.4000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(11)
	CreateDynamicObject(827,-721.2000100,-1933.4000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(12)
	CreateDynamicObject(827,-742.0999800,-2008.5999800,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(13)
	CreateDynamicObject(827,-765.5000000,-2015.4000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(14)
	CreateDynamicObject(827,-753.5999800,-2023.0999800,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(15)
	CreateDynamicObject(827,-770.7000100,-2034.0000000,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(16)
	CreateDynamicObject(827,-762.5000000,-2031.3000500,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(17)
	CreateDynamicObject(827,-744.7000100,-2035.5000000,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(18)
	CreateDynamicObject(827,-730.2000100,-2034.0000000,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(19)
	CreateDynamicObject(827,-793.9000200,-2004.9000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(20)
	CreateDynamicObject(827,-799.4000200,-1995.0999800,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(21)
	CreateDynamicObject(827,-813.0999800,-1980.0999800,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(22)
	CreateDynamicObject(827,-816.2999900,-1967.0999800,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(23)
	CreateDynamicObject(827,-805.0000000,-1964.3000500,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(24)
	CreateDynamicObject(827,-754.7999900,-1907.9000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(25)
	CreateDynamicObject(827,-763.2999900,-1905.4000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(26)
	CreateDynamicObject(827,-765.7000100,-1911.9000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(27)
	CreateDynamicObject(827,-718.7000100,-1882.0000000,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(28)
	CreateDynamicObject(827,-709.7000100,-1884.0000000,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(29)
	CreateDynamicObject(827,-700.5000000,-1890.9000200,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(30)
	CreateDynamicObject(827,-693.7999900,-1893.1999500,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(31)
	CreateDynamicObject(827,-689.2999900,-1901.3000500,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(32)
	CreateDynamicObject(827,-686.0000000,-1891.5999800,6.4000000,0.0000000,0.0000000,0.0000000); //object(genveg_tallgrass11)(33)
	CreateDynamicObject(16326,-846.0999800,-1918.9000200,13.7000000,0.0000000,352.0000000,140.0000000); //object(des_byoffice)(1)
	CreateDynamicObject(3109,-841.5999800,-1917.9000200,14.2000000,7.2340000,356.2200000,54.9770000); //object(imy_la_door)(1)
	CreateDynamicObject(10985,-847.0999800,-1915.1999500,12.7000000,0.0000000,0.0000000,310.0000000); //object(rubbled02_sfs)(1)
	CreateDynamicObject(10985,-843.0999800,-1913.0999800,11.5000000,0.0000000,0.0000000,309.9960000); //object(rubbled02_sfs)(2)
	CreateDynamicObject(10985,-843.0999800,-1913.0999800,12.0000000,0.0000000,0.0000000,309.9960000); //object(rubbled02_sfs)(3)
	CreateDynamicObject(10985,-843.0999800,-1913.0999800,12.0000000,0.0000000,0.0000000,309.9960000); //object(rubbled02_sfs)(4)
	CreateDynamicObject(10985,-843.0999800,-1915.3000500,11.5000000,0.0000000,0.0000000,309.9960000); //object(rubbled02_sfs)(5)
	CreateDynamicObject(10985,-841.0000000,-1916.5999800,11.5000000,0.0000000,0.0000000,351.9960000); //object(rubbled02_sfs)(6)
	CreateDynamicObject(10985,-841.5999800,-1915.5000000,11.7000000,0.0000000,0.0000000,351.9910000); //object(rubbled02_sfs)(7)
	CreateDynamicObject(10985,-843.2000100,-1914.6999500,12.0000000,0.0000000,0.0000000,351.9910000); //object(rubbled02_sfs)(8)
	CreateDynamicObject(10985,-843.4000200,-1915.6999500,12.1000000,0.0000000,0.0000000,13.9910000); //object(rubbled02_sfs)(9)
	CreateDynamicObject(10985,-840.7000100,-1915.0000000,11.9000000,0.0000000,0.0000000,13.9860000); //object(rubbled02_sfs)(10)
	CreateDynamicObject(10985,-840.2999900,-1916.5000000,11.6000000,0.0000000,0.0000000,163.9860000); //object(rubbled02_sfs)(11)
	CreateDynamicObject(10985,-844.2999900,-1918.5000000,12.3000000,0.0000000,0.0000000,163.9820000); //object(rubbled02_sfs)(12)
	CreateDynamicObject(10985,-843.5999800,-1917.0999800,12.3000000,0.0000000,0.0000000,163.9820000); //object(rubbled02_sfs)(13)
	CreateDynamicObject(17124,-956.2999900,-1868.0999800,51.5000000,357.9900000,0.0000000,93.9870000); //object(cuntwland58b)(3)
	CreateDynamicObject(17124,-906.7999900,-1801.4000200,49.0000000,357.9900000,0.0000000,69.9830000); //object(cuntwland58b)(3)
	CreateDynamicObject(683,-711.7000100,-1833.5999800,15.2000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-692.2999900,-1833.0000000,15.2000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-731.5999800,-1832.5999800,14.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-723.5999800,-1831.9000200,14.0000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-785.2000100,-2058.0000000,14.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	CreateDynamicObject(683,-794.2000100,-2054.6999500,14.8000000,0.0000000,0.0000000,0.0000000); //object(sm_fir_group)(8)
	// Паркур-зона 1
	CreateDynamicObject(17019,5.2000000,-301.2999900,1098.0999800,0.0000000,0.0000000,90.0000000); //object(cuntfrates1) (1)
	CreateDynamicObject(12860,25.1000000,-331.0000000,1099.1999500,0.0000000,0.0000000,270.0000000); //object(sw_cont04) (1)
	CreateDynamicObject(1299,7.7000000,-278.5000000,1100.5999800,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (1)
	CreateDynamicObject(1299,9.8000000,-327.7000100,1103.6999500,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (2)
	CreateDynamicObject(1299,-0.7000000,-327.1000100,1103.6999500,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (3)
	CreateDynamicObject(1299,13.9000000,-329.0000000,1107.6999500,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (4)
	CreateDynamicObject(1299,-13.8000000,-322.7999900,1103.6999500,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (5)
	CreateDynamicObject(1299,18.4000000,-310.0000000,1103.6999500,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (6)
	CreateDynamicObject(1299,23.2000000,-319.2999900,1103.6999500,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (7)
	CreateDynamicObject(1299,27.1000000,-329.5000000,1107.6999500,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (8)
	CreateDynamicObject(3378,21.6000000,-353.1000100,1110.1999500,0.0000000,0.0000000,180.1130000); //object(ce_beerpile01) (1)
	CreateDynamicObject(3378,21.4000000,-377.7000100,1105.6999500,0.0000000,0.0000000,180.1100000); //object(ce_beerpile01) (2)
	CreateDynamicObject(3378,21.6000000,-391.8999900,1108.0999800,0.0000000,0.0000000,180.1100000); //object(ce_beerpile01) (3)
	CreateDynamicObject(12932,48.8000000,-411.8999900,1102.6999500,0.0000000,0.0000000,90.0000000); //object(sw_trailer02) (1)
	CreateDynamicObject(3378,44.3000000,-426.2999900,1104.0000000,0.0000000,0.0000000,210.1100000); //object(ce_beerpile01) (4)
	CreateDynamicObject(1299,48.9000000,-432.7000100,1105.5999800,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (9)
	CreateDynamicObject(12929,77.6000000,-427.5000000,1097.5999800,0.0000000,0.0000000,90.0000000); //object(sw_shed06) (1)
	CreateDynamicObject(12929,86.3000000,-426.5000000,1098.0000000,0.0000000,0.0000000,90.0000000); //object(sw_shed06) (2)
	CreateDynamicObject(12929,88.5000000,-441.1000100,1100.5000000,0.0000000,0.0000000,90.0000000); //object(sw_shed06) (3)
	CreateDynamicObject(12929,90.2000000,-454.7000100,1102.9000200,0.0000000,0.0000000,90.0000000); //object(sw_shed06) (4)
	CreateDynamicObject(3402,108.3000000,-460.0000000,1103.8000500,0.0000000,0.0000000,358.7600000); //object(sw_tempbarn01) (1)
	CreateDynamicObject(12912,123.2000000,-465.2999900,1103.6999500,0.0000000,79.0000000,4.5880000); //object(sw_silo04) (1)
	CreateDynamicObject(3378,141.8000000,-462.3999900,1106.0999800,0.0000000,0.0000000,100.1100000); //object(ce_beerpile01) (5)
	CreateDynamicObject(13367,137.1000100,-473.6000100,1118.5000000,0.0000000,0.0000000,359.5360000); //object(sw_watertower01) (1)
	CreateDynamicObject(12918,149.0000000,-462.6000100,1106.5999800,0.0000000,0.0000000,271.4990000); //object(sw_haypile05) (1)
	CreateDynamicObject(12914,151.0000000,-460.3999900,1111.3000500,0.0000000,0.0000000,290.0000000); //object(sw_corrug01) (1)
	CreateDynamicObject(8613,156.3000000,-457.2999900,1114.4000200,0.0000000,0.0000000,0.0000000); //object(vgssstairs03_lvs) (1)
	CreateDynamicObject(3378,160.2000000,-443.5000000,1116.1999500,0.0000000,0.0000000,180.1100000); //object(ce_beerpile01) (6)
	CreateDynamicObject(3378,161.1000100,-420.7999900,1118.0999800,0.0000000,0.0000000,180.1100000); //object(ce_beerpile01) (7)
	CreateDynamicObject(3378,159.8000000,-396.8999900,1116.6999500,0.0000000,0.0000000,180.1100000); //object(ce_beerpile01) (8)
	// Паркур-зона 2
	CreateDynamicObject(3980,2491.5996100,-1673.7998000,4120.6001000,0.0000000,0.0000000,0.0000000); //object(lacityhall1_lan) (1)
	CreateDynamicObject(4550,2583.3000500,-1687.6999500,4096.2002000,95.0000000,0.0000000,88.0000000); //object(librtow1_lan) (1)
	CreateDynamicObject(1299,2562.1001000,-1687.1999500,4125.2002000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (1)
	CreateDynamicObject(1299,2702.6999500,-1692.1999500,4107.2002000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (2)
	CreateDynamicObject(1299,2749.6001000,-1694.4000200,4100.5000000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (3)
	CreateDynamicObject(1299,2782.8999000,-1695.4000200,4093.3999000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (4)
	CreateDynamicObject(1299,2782.3999000,-1705.9000200,4089.6999500,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (5)
	CreateDynamicObject(1299,2783.3999000,-1684.5999800,4089.8999000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (6)
	CreateDynamicObject(1299,2783.1999500,-1691.9000200,4094.6001000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (7)
	CreateDynamicObject(1299,2700.6001000,-1690.3000500,4109.3999000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (8)
	CreateDynamicObject(1299,2561.3000500,-1683.3000500,4129.7998000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (9)
	CreateDynamicObject(1299,2561.1001000,-1681.6999500,4126.3999000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (10)
	CreateDynamicObject(5400,2842.1999500,-1704.5000000,4094.8000500,0.0000000,0.0000000,0.0000000); //object(laeskatetube1) (2)
	CreateDynamicObject(18250,2826.3999000,-1698.0000000,4090.6999500,0.0000000,0.0000000,0.0000000); //object(cuntwjunk06) (1)
	CreateDynamicObject(18250,2845.1999500,-1700.3000500,4094.6999500,0.0000000,0.0000000,0.0000000); //object(cuntwjunk06) (2)
	CreateDynamicObject(18250,2858.6999500,-1703.0000000,4097.0000000,0.0000000,0.0000000,0.0000000); //object(cuntwjunk06) (3)
	CreateDynamicObject(18250,2877.8000500,-1705.8000500,4099.8999000,0.0000000,0.0000000,0.0000000); //object(cuntwjunk06) (4)
	CreateDynamicObject(18252,2891.6999500,-1717.8000500,4102.5000000,0.0000000,0.0000000,0.0000000); //object(cuntwjunk08) (1)
	CreateDynamicObject(18252,2892.1001000,-1727.6999500,4107.7998000,0.0000000,0.0000000,0.0000000); //object(cuntwjunk08) (2)
	CreateDynamicObject(13646,2901.0000000,-1737.5999800,4112.5000000,0.0000000,0.0000000,0.0000000); //object(ramplandpad) (1)
	CreateDynamicObject(13646,2899.8999000,-1745.1999500,4113.7002000,0.0000000,0.0000000,0.0000000); //object(ramplandpad) (2)
	CreateDynamicObject(13646,2900.1999500,-1753.3000500,4114.8999000,0.0000000,0.0000000,0.0000000); //object(ramplandpad) (3)
	CreateDynamicObject(13646,2900.1001000,-1761.5000000,4116.1001000,0.0000000,0.0000000,0.0000000); //object(ramplandpad) (4)
	CreateDynamicObject(13646,2900.5000000,-1763.8000500,4117.2998000,0.0000000,0.0000000,0.0000000); //object(ramplandpad) (5)
	CreateDynamicObject(3115,2889.3999000,-1773.4000200,4118.0000000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (1)
	CreateDynamicObject(3917,2925.3000500,-1813.0999800,4122.1001000,0.0000000,0.0000000,246.0000000); //object(lib_street17) (1)
	CreateDynamicObject(3518,2907.5000000,-1769.5000000,4118.0000000,0.0000000,0.0000000,0.0000000); //object(vgsn_rooflity) (1)
	CreateDynamicObject(3115,2883.6001000,-1776.9000200,4121.6001000,0.0000000,0.0000000,0.0000000); //object(carrier_lift1_sfse) (2)
	CreateDynamicObject(3724,2879.5996100,-1811.2998000,4134.3999000,0.0000000,0.0000000,270.0000000); //object(laxrf_cargotop) (1)
	CreateDynamicObject(1299,2882.1001000,-1818.5000000,4119.7998000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (11)
	CreateDynamicObject(1299,2879.3999000,-1819.9000200,4122.6001000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (12)
	CreateDynamicObject(1299,2876.8000500,-1797.5999800,4119.2002000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (13)
	CreateDynamicObject(1299,2876.3999000,-1806.6999500,4119.7002000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (14)
	CreateDynamicObject(1299,2877.3000500,-1805.8000500,4121.5000000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (15)
	CreateDynamicObject(1299,2874.0000000,-1806.6999500,4121.7998000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (16)
	CreateDynamicObject(1299,2877.1001000,-1832.5999800,4119.1001000,0.0000000,0.0000000,358.0000000); //object(smashboxpile) (17)
	CreateDynamicObject(1299,2880.6999500,-1833.0000000,4121.7002000,0.0000000,0.0000000,0.0000000); //object(smashboxpile) (18)
	CreateDynamicObject(17973,2934.8000500,-1798.0000000,4135.8999000,0.0000000,0.0000000,0.0000000); //object(grnd_alpha3) (1)
	CreateDynamicObject(16746,2859.6001000,-1844.5999800,4078.6999500,0.0000000,0.0000000,0.0000000); //object(des_alphabit11) (1)
	CreateDynamicObject(3043,2876.3000500,-1846.8000500,4120.5000000,0.0000000,0.0000000,0.0000000); //object(kmb_container_open) (1)
	CreateDynamicObject(3043,2876.3999000,-1853.6999500,4120.7998000,0.0000000,0.0000000,0.0000000); //object(kmb_container_open) (2)
	CreateDynamicObject(3043,2876.6001000,-1860.4000200,4120.7998000,0.0000000,0.0000000,0.0000000); //object(kmb_container_open) (3)
	CreateDynamicObject(3043,2876.1001000,-1867.1999500,4120.7998000,0.0000000,0.0000000,0.0000000); //object(kmb_container_open) (4)
	// Пляж ЛС
	CreateDynamicObject(621, 259.92, -1818.86, 1.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(18841, 184.00, -1782.73, 13.44,   62.00, 0.00, 293.00);
	CreateDynamicObject(18841, 192.28, -1801.71, 28.32,   62.00, 0.00, 114.14);
	CreateDynamicObject(18826, 153.04, -1965.43, 11.71,   -75.00, 0.00, -258.00);
	CreateDynamicObject(18826, 147.53, -1944.12, 19.99,   -75.00, 0.00, 287.14);
	CreateDynamicObject(18826, 153.46, -1963.84, 28.25,   -75.00, 0.00, 106.53);
	CreateDynamicObject(18822, 134.99, -1934.16, 32.00,   -91.00, 0.00, 356.27);
	CreateDynamicObject(18818, 156.76, -1891.73, 32.40,   -97.00, -2.00, 61.78);
	CreateDynamicObject(18809, 193.89, -1909.82, 37.01,   -84.00, 0.00, 244.20);
	CreateDynamicObject(18824, 228.56, -1939.54, 42.19,   -83.00, 0.00, 199.69);
	CreateDynamicObject(18824, 212.26, -1974.82, 47.59,   -83.00, 0.00, 110.73);
	CreateDynamicObject(18824, 177.27, -1959.03, 52.94,   -83.00, 0.00, 20.86);
	CreateDynamicObject(18809, 182.45, -1913.19, 58.21,   -84.00, 0.00, 340.80);
	CreateDynamicObject(18822, 205.99, -1871.88, 63.26,   -84.00, 0.00, 313.84);
	CreateDynamicObject(18826, 236.37, -1859.67, 79.92,   -206.00, 0.00, 203.78);
	CreateDynamicObject(18826, 223.02, -1880.99, 79.92,   -206.00, 0.00, 24.71);
	CreateDynamicObject(18826, 247.62, -1885.19, 79.92,   -206.00, 0.00, 203.78);
	CreateDynamicObject(18826, 234.36, -1906.45, 79.92,   -206.00, 0.00, 24.71);
	CreateDynamicObject(18822, 267.76, -1898.86, 72.84,   -4.00, -113.00, 23.19);
	CreateDynamicObject(18813, 344.25, -1879.53, 59.08,   0.00, 0.00, 1.43);
	CreateDynamicObject(18822, 164.21, -1841.89, 33.92,   -96.00, 0.00, 177.78);
	CreateDynamicObject(18822, 148.60, -1798.53, 38.97,   -96.00, 0.00, 221.72);
	CreateDynamicObject(18822, 107.12, -1778.10, 44.00,   -96.00, 0.00, 265.89);
	CreateDynamicObject(18824, 343.07, -1868.23, 16.99,   0.00, -43.00, 95.93);
	CreateDynamicObject(18824, 346.76, -1829.93, 10.75,   47.00, -127.00, 93.59);
	CreateDynamicObject(18809, 376.00, -1810.59, 39.83,   -46.00, 0.00, 282.92);
	CreateDynamicObject(18824, 414.59, -1804.82, 64.44,   164.00, -83.00, 358.98);
	CreateDynamicObject(18824, 453.09, -1820.98, 57.74,   52.00, -84.00, 301.63);
	CreateDynamicObject(18824, 452.51, -1861.26, 63.55,   123.00, -84.00, 225.73);
	CreateDynamicObject(18824, 419.97, -1891.92, 57.78,   77.00, -135.00, 103.91);
	CreateDynamicObject(18824, 428.42, -1930.43, 56.76,   95.00, -135.00, 190.12);
	CreateDynamicObject(18822, 471.04, -1927.81, 58.24,   -91.00, 0.00, 122.86);
	CreateDynamicObject(18813, 502.56, -1879.85, 28.72,   40.00, 0.00, 336.10);
	CreateDynamicObject(18826, 76.85, -1787.94, 61.80,   25.00, 6.00, 15.51);
	CreateDynamicObject(18826, 102.20, -1794.06, 61.80,   25.00, 6.00, 194.00);
	CreateDynamicObject(18826, 85.79, -1813.06, 59.51,   25.00, -8.00, 20.03);
	CreateDynamicObject(18826, 108.79, -1820.46, 61.70,   25.00, 6.00, 193.18);
	CreateDynamicObject(19129, 303.29, -1903.22, 2.28,   -18.00, 0.00, 356.20);
	CreateDynamicObject(19129, 301.98, -1922.46, 5.38,   0.00, 0.00, 355.82);
	CreateDynamicObject(19129, 300.57, -1940.90, 8.31,   -18.00, 0.00, 355.37);
	CreateDynamicObject(19129, 299.02, -1960.23, 11.38,   0.00, 0.00, 355.29);
	CreateDynamicObject(19005, 293.27, -1983.23, 14.61,   0.00, 0.00, 175.34);
	CreateDynamicObject(19005, 300.72, -1983.84, 14.61,   0.00, 0.00, 175.34);
	CreateDynamicObject(19005, 277.07, -1812.17, 5.70,   0.00, 0.00, 18.00);
	CreateDynamicObject(19005, 272.09, -1796.81, 17.57,   24.00, 0.00, 18.00);
	CreateDynamicObject(621, 199.05, -1845.95, 1.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(621, 268.76, -1874.44, 0.45,   0.00, 0.00, 0.00);
	CreateDynamicObject(18841, 208.89, -1771.17, 28.35,   62.00, 0.00, 296.20);
	CreateDynamicObject(18836, 234.64, -1791.36, 30.21,   -25.00, 0.00, 26.51);
	CreateDynamicObject(18836, 255.07, -1835.63, 42.75,   -4.00, 0.00, 23.31);
	CreateDynamicObject(18838, 181.20, -1873.68, 12.28,   0.00, 0.00, 10.39);
	CreateDynamicObject(621, 190.57, -1877.92, 1.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(621, 187.75, -1866.98, 1.68,   0.00, 0.00, 0.00);
	CreateDynamicObject(18840, 282.42, -1873.78, 47.10,   -97.00, 0.00, 70.46);
	CreateDynamicObject(18840, 322.58, -1855.75, 52.13,   -96.00, 0.00, 157.83);
	CreateDynamicObject(18840, 323.76, -1808.07, 54.42,   -90.00, 8.00, 343.08);
	CreateDynamicObject(18836, 363.13, -1780.82, 54.48,   0.00, 0.00, 116.70);
	CreateDynamicObject(18836, 405.68, -1759.35, 54.48,   0.00, 0.00, 116.70);
	CreateDynamicObject(18840, 451.80, -1745.60, 54.12,   -91.00, 0.00, 253.85);
	CreateDynamicObject(18838, 472.31, -1768.60, 60.93,   -25.00, 0.00, 125.76);
	CreateDynamicObject(18838, 457.80, -1759.66, 60.93,   -25.00, 0.00, -55.00);
	CreateDynamicObject(18838, 461.46, -1776.32, 60.93,   -25.00, 0.00, 125.76);
	CreateDynamicObject(18838, 446.79, -1767.45, 60.93,   -25.00, 0.00, -55.00);
	CreateDynamicObject(18836, 461.81, -1796.22, 53.76,   0.00, 0.00, 33.03);
	CreateDynamicObject(19005, 481.86, -1827.96, 51.72,   0.00, 0.00, 214.82);
	CreateDynamicObject(18836, 384.27, -1885.68, 0.36,   0.00, 4.00, 270.00);
	CreateDynamicObject(18786, 432.17, -1854.84, 4.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(18786, 420.86, -1855.00, 9.36,   0.00, 20.00, 0.94);
	CreateDynamicObject(18781, 494.29, -1828.18, 13.65,   0.00, 0.00, 330.06);
	CreateDynamicObject(18779, 244.04, -1854.18, 10.37,   -21.00, 0.00, 16.00);
	CreateDynamicObject(18779, 230.32, -1849.12, 28.67,   -27.00, 50.00, 22.94);
	CreateDynamicObject(621, 299.82, -1785.08, 1.07,   0.00, 0.00, 0.00);
	CreateDynamicObject(621, 300.13, -1785.22, -2.05,   8.00, 0.00, 0.00);
	CreateDynamicObject(621, 299.56, -1784.47, -2.05,   8.00, 0.00, 200.00);
	CreateDynamicObject(621, 267.65, -1874.50, -0.89,   6.00, 0.00, 0.00);
	CreateDynamicObject(18780, 548.92, -1848.65, 13.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(18780, 548.93, -1858.35, 13.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(18780, 548.96, -1867.91, 13.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(18780, 548.89, -1877.55, 13.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(18779, 375.73, -2027.60, 16.46,   0.00, 0.00, 89.95);
	CreateDynamicObject(18779, 375.82, -2044.25, 45.86,   0.00, 55.00, 91.58);
	CreateDynamicObject(18788, 369.85, -2011.44, 55.64,   0.00, 0.00, 90.99);
	CreateDynamicObject(18791, 363.19, -1954.72, 56.14,   0.00, 0.00, 110.63);
	CreateDynamicObject(18800, 309.86, -1917.58, 43.96,   0.00, 0.00, 129.40);
	CreateDynamicObject(18791, 328.09, -1986.82, 32.57,   0.00, 0.00, 107.58);
	CreateDynamicObject(18801, 322.62, -2025.45, 55.64,   0.00, 0.00, 91.90);
	CreateDynamicObject(18789, 312.77, -2097.85, 32.56,   0.00, 0.00, 89.97);
	CreateDynamicObject(18800, 290.58, -2199.46, 44.03,   0.00, 0.00, 270.94);
	CreateDynamicObject(18789, 267.49, -2097.50, 56.22,   0.00, 0.00, 89.68);
	CreateDynamicObject(18779, 262.00, -2042.61, 66.16,   0.00, 0.00, 268.42);
	CreateDynamicObject(621, 325.34, -1844.77, 0.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(621, 325.54, -1845.19, 0.85,   10.00, 0.00, 0.00);
	CreateDynamicObject(621, 435.83, -1874.81, 1.06,   0.00, 0.00, 0.00);
	CreateDynamicObject(621, 431.00, -1833.78, 1.06,   6.00, 0.00, 0.00);
	CreateDynamicObject(621, 482.51, -1857.99, 0.49,   0.00, 0.00, 0.00);
	CreateDynamicObject(621, 482.56, -1857.53, 0.49,   -11.00, 0.00, 0.00);
	CreateDynamicObject(621, 483.16, -1857.39, 0.49,   11.00, 0.00, 0.00);
	CreateDynamicObject(18779, 87.15, -1839.15, 51.26,   0.00, 0.00, 12.74);
	CreateDynamicObject(18646, 330.66, -1817.40, 3.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(18646, 337.58, -1817.37, 3.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(18646, 308.38, -1812.69, 3.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(18646, 308.38, -1817.33, 3.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(18637, 284.62, -1858.52, 2.10,   0.00, 0.00, 0.00);
	CreateDynamicObject(18782, 315.82, -1873.52, 2.06,   0.00, 0.00, 0.00);
	CreateDynamicObject(18782, 461.07, -1877.10, 2.88,   4.00, 0.00, 0.00);
	CreateDynamicObject(19129,207.1959991,-1812.6879883,3.5009999,0.0000000,0.0000000,0.0000000); //object(dancefloor2) (2)
	CreateDynamicObject(19122,217.1840057,-1822.7469482,3.6659999,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (1)
	CreateDynamicObject(19122,217.2640076,-1802.5639648,4.0180001,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (2)
	CreateDynamicObject(19122,197.0330048,-1802.5770264,3.8580000,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (3)
	CreateDynamicObject(19122,197.0740051,-1822.7719727,3.7509999,0.0000000,0.0000000,0.0000000); //object(bollardlight2) (4)
	CreateDynamicObject(19123,207.1759949,-1802.5410156,4.0019999,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (1)
	CreateDynamicObject(19123,207.0659943,-1822.7989502,3.7119999,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (2)
	CreateDynamicObject(19123,217.4210052,-1812.7060547,3.9540000,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (3)
	CreateDynamicObject(19123,196.9389954,-1812.6850586,4.0320001,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (4)
	CreateDynamicObject(19126,217.3880005,-1807.6629639,4.0710001,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (1)
	CreateDynamicObject(19126,217.1150055,-1817.7380371,3.8110001,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (2)
	CreateDynamicObject(19126,212.2760010,-1802.4990234,4.0180001,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (3)
	CreateDynamicObject(19126,202.1150055,-1802.5939941,3.9170001,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (4)
	CreateDynamicObject(19126,196.9830017,-1807.6600342,3.9909999,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (5)
	CreateDynamicObject(19126,197.1739960,-1817.8320312,3.8929999,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (6)
	CreateDynamicObject(19126,202.1799927,-1822.8270264,3.7330000,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (7)
	CreateDynamicObject(19126,212.2630005,-1822.6369629,3.6919999,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (8)
	CreateDynamicObject(19124,217.1470032,-1820.1970215,3.7400000,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (1)
	CreateDynamicObject(19124,213.4960022,-1822.6149902,3.6870000,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (2)
	CreateDynamicObject(19124,208.4530029,-1822.7270508,3.7070000,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (3)
	CreateDynamicObject(19124,203.4029999,-1822.6540527,3.7330000,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (4)
	CreateDynamicObject(19124,198.3880005,-1822.7010498,3.7479999,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (5)
	CreateDynamicObject(19124,197.1929932,-1818.9470215,3.8610001,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (6)
	CreateDynamicObject(19124,196.9859924,-1813.8399658,4.0100002,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (7)
	CreateDynamicObject(19124,197.0630035,-1808.9680176,4.0270000,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (8)
	CreateDynamicObject(19124,196.9290009,-1804.0050049,3.8940001,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (9)
	CreateDynamicObject(19124,200.9069977,-1802.6240234,3.8970001,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (10)
	CreateDynamicObject(19124,206.0059967,-1802.5030518,3.9809999,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (11)
	CreateDynamicObject(19124,211.0070038,-1802.4840088,4.0180001,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (12)
	CreateDynamicObject(19124,215.9250031,-1802.4899902,4.0180001,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (13)
	CreateDynamicObject(19124,217.4290009,-1806.4119873,4.0580001,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (14)
	CreateDynamicObject(19124,217.2709961,-1811.4630127,3.9909999,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (15)
	CreateDynamicObject(19124,217.1959991,-1816.4279785,4.0029998,0.0000000,0.0000000,0.0000000); //object(bollardlight4) (16)
	CreateDynamicObject(19125,199.7169952,-1802.6829834,3.8870001,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (1)
	CreateDynamicObject(19125,197.0339966,-1806.4709473,3.9600000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (2)
	CreateDynamicObject(19125,196.9689941,-1811.4799805,4.0560002,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (3)
	CreateDynamicObject(19125,197.0919952,-1816.4539795,3.9330001,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (4)
	CreateDynamicObject(19125,197.1080017,-1821.4659424,3.7890000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (5)
	CreateDynamicObject(19125,200.9069977,-1822.6960449,3.7379999,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (6)
	CreateDynamicObject(19125,205.8899994,-1822.5920410,3.7230000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (7)
	CreateDynamicObject(19125,210.8379974,-1822.7659912,3.6949999,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (8)
	CreateDynamicObject(19125,215.9759979,-1822.7629395,3.6710000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (9)
	CreateDynamicObject(19125,217.1380005,-1818.9179688,3.7770000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (10)
	CreateDynamicObject(19125,217.3300018,-1813.9050293,3.9200001,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (11)
	CreateDynamicObject(19125,217.4750061,-1808.8740234,4.0650001,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (12)
	CreateDynamicObject(19125,217.3139954,-1803.9260254,4.0320001,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (13)
	CreateDynamicObject(19125,213.3560028,-1802.4360352,4.0170002,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (14)
	CreateDynamicObject(19125,208.4510040,-1802.4560547,4.0170002,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (15)
	CreateDynamicObject(19125,203.4409943,-1802.5209961,3.9380000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (16)
	CreateDynamicObject(19127,204.6450043,-1802.5649414,3.9600000,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (1)
	CreateDynamicObject(19127,198.4080048,-1802.6879883,4.0029998,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (2)
	CreateDynamicObject(19127,197.0330048,-1805.1590576,3.9260001,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (3)
	CreateDynamicObject(19127,197.0820007,-1810.1669922,4.0580001,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (4)
	CreateDynamicObject(19127,197.1719971,-1820.2130127,3.8250000,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (5)
	CreateDynamicObject(19127,196.9609985,-1815.1949463,3.9700000,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (6)
	CreateDynamicObject(19127,199.6589966,-1822.7860107,3.7400000,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (7)
	CreateDynamicObject(19127,204.7319946,-1822.7170410,3.7249999,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (8)
	CreateDynamicObject(19127,214.7429962,-1822.6789551,3.6789999,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (9)
	CreateDynamicObject(19127,209.6569977,-1822.7419434,3.7010000,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (10)
	CreateDynamicObject(19127,217.1779938,-1821.4339600,3.7040000,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (11)
	CreateDynamicObject(19127,217.1719971,-1815.2650146,3.8820000,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (12)
	CreateDynamicObject(19127,217.5050049,-1810.1250000,4.0279999,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (13)
	CreateDynamicObject(19127,217.5870056,-1805.1870117,4.0450001,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (14)
	CreateDynamicObject(19127,214.7250061,-1802.2650146,4.0149999,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (15)
	CreateDynamicObject(19127,209.6790009,-1802.6120605,4.0190001,0.0000000,0.0000000,0.0000000); //object(bollardlight7) (16)
	// Трубы на пирсе ЛС
	CreateDynamicObject(18809, 845.05, -2090.90, 17.02,   -90.00, 2.00, 360.00);
	CreateDynamicObject(18809, 829.10, -2090.71, 17.02,   -90.00, 2.00, 360.00);
	CreateDynamicObject(18818, 850.65, -2139.88, 17.88,   -92.00, -91.00, 355.77);
	CreateDynamicObject(18824, 887.81, -2130.17, 17.55,   -91.00, -142.00, 349.14);
	CreateDynamicObject(18818, 958.74, -2027.24, 15.13,   -92.00, -273.00, 354.37);
	CreateDynamicObject(18824, 913.84, -2092.64, 16.83,   -91.00, -316.00, 357.06);
	CreateDynamicObject(18824, 952.36, -2070.41, 16.38,   -91.00, -142.00, 349.81);
	CreateDynamicObject(18824, 979.77, -1984.49, 10.84,   -100.00, -316.00, 358.90);
	CreateDynamicObject(18824, 924.42, -2025.15, 29.49,   4.00, -142.00, 178.72);
	CreateDynamicObject(18843, 914.63, -2023.45, 100.38,   0.00, 0.00, 34.43);
	CreateDynamicObject(18824, 814.61, -2133.12, 17.35,   -91.00, -142.00, 347.98);
	CreateDynamicObject(18809, 840.95, -2188.35, 18.78,   -90.00, 2.00, 0.54);
	CreateDynamicObject(18826, 854.94, -2224.76, 19.47,   -274.00, -268.00, 351.45);
	CreateDynamicObject(18826, 858.63, -2203.92, 13.35,   -69.00, 7.00, 268.11);
	CreateDynamicObject(18809, 837.57, -2235.90, 7.26,   -90.00, 2.00, 350.50);
	CreateDynamicObject(18818, 835.85, -2285.42, 8.13,   -92.00, -91.00, 348.35);
	CreateDynamicObject(18826, 864.61, -2281.10, 20.28,   -36.00, -175.00, 353.20);
	CreateDynamicObject(18826, 845.16, -2280.42, 44.64,   -131.00, -4.00, 346.87);
	CreateDynamicObject(18824, 874.80, -2286.54, 57.34,   -97.00, 0.00, 122.78);
	CreateDynamicObject(18824, 906.62, -2254.50, 61.97,   -85.00, 0.00, 301.34);
	CreateDynamicObject(18824, 949.40, -2239.26, 61.97,   -85.00, 0.00, 124.32);
	CreateDynamicObject(18824, 980.33, -2205.54, 60.44,   -89.00, 14.00, 317.84);
	CreateDynamicObject(18824, 1022.95, -2188.47, 60.44,   -89.00, -2.00, 124.44);
	CreateDynamicObject(18824, 1050.93, -2152.29, 60.44,   -89.00, -2.00, 309.37);
	CreateDynamicObject(18818, 821.10, -2324.15, 8.74,   -92.00, -91.00, 80.07);
	CreateDynamicObject(18809, 868.06, -2340.29, 10.95,   0.00, -93.00, 349.15);
	CreateDynamicObject(18809, 916.12, -2349.34, 13.54,   0.00, -93.00, 349.66);
	CreateDynamicObject(18809, 964.39, -2357.13, 16.07,   0.00, -93.00, 352.01);
	CreateDynamicObject(18809, 1012.35, -2364.42, 18.69,   0.00, -93.00, 350.56);
	CreateDynamicObject(18809, 1062.04, -2371.79, 16.77,   0.00, -83.00, 352.51);
	CreateDynamicObject(18809, 771.74, -2324.20, 6.69,   0.00, -93.00, 350.89);
	CreateDynamicObject(18826, 736.11, -2327.78, 18.69,   34.00, 0.00, 353.09);
	CreateDynamicObject(18826, 756.31, -2330.31, 45.01,   34.00, 0.00, 172.55);
	CreateDynamicObject(18824, 730.72, -2305.06, 57.96,   -91.00, -55.00, 339.92);
	CreateDynamicObject(18843, 728.87, -2240.96, 58.31,   -89.00, 0.00, 353.44);
	CreateDynamicObject(18824, 724.63, -2171.56, 59.86,   -269.00, -142.00, 0.70);
	CreateDynamicObject(18824, 690.37, -2149.33, 46.68,   -200.00, -142.00, 169.14);
	CreateDynamicObject(18824, 696.89, -2132.37, 12.49,   -200.00, 122.00, 190.69);
	CreateDynamicObject(18824, 775.42, -2130.66, 14.54,   69.00, 55.00, 346.23);
	CreateDynamicObject(18809, 735.58, -2122.85, 12.91,   -4.00, -109.00, 7.99);
	CreateDynamicObject(18809, 778.91, -2115.72, 27.99,   -4.00, -109.00, 7.89);
	CreateDynamicObject(18824, 822.10, -2098.11, 38.13,   -83.00, -146.00, 353.65);
	CreateDynamicObject(18824, 769.04, -2089.94, 12.58,   -200.00, 66.00, 261.85);
	CreateDynamicObject(18824, 820.38, -2059.56, 42.51,   -83.00, -146.00, 79.51);
	CreateDynamicObject(18824, 781.53, -2058.26, 46.94,   -83.00, -146.00, 164.68);
	CreateDynamicObject(18826, 760.97, -2087.93, 36.09,   24.00, 6.00, 84.65);
	CreateDynamicObject(18824, 784.20, -2078.88, 45.84,   -204.00, -25.00, 257.83);
	CreateDynamicObject(18809, 755.47, -2054.09, 20.28,   0.00, -91.00, 268.74);
	CreateDynamicObject(18824, 768.90, -2010.72, 17.41,   -83.00, -146.00, 166.52);
	CreateDynamicObject(18824, 807.81, -2012.58, 21.39,   76.00, -193.00, 54.77);
	CreateDynamicObject(18824, 829.06, -2050.95, 30.38,   113.00, -229.00, 273.06);
	CreateDynamicObject(18824, 868.12, -2053.98, 34.02,   40.00, -244.00, 16.22);
	CreateDynamicObject(18826, 878.99, -2022.78, 28.33,   21.00, -41.00, 274.32);
	CreateDynamicObject(18824, 857.65, -2034.23, 56.61,   40.00, -244.00, 15.82);
	CreateDynamicObject(18824, 817.17, -2031.55, 59.18,   -265.00, -244.00, 289.76);
	CreateDynamicObject(18824, 816.37, -1993.27, 57.50,   -265.00, -244.00, 200.75);
	CreateDynamicObject(18824, 853.86, -1981.31, 70.43,   -193.00, 40.00, 187.79);
	CreateDynamicObject(18824, 853.46, -1988.11, 108.75,   -193.00, -42.00, 176.91);
	CreateDynamicObject(18824, 781.64, -2106.35, 80.28,   -204.00, 17.00, 96.46);
	CreateDynamicObject(18824, 818.26, -1988.35, 136.83,   -193.00, 33.00, 6.28);
	CreateDynamicObject(18824, 820.79, -1979.60, 176.39,   -193.00, -42.00, 2.67);
	CreateDynamicObject(18824, 858.21, -1976.59, 201.41,   178.00, 136.00, 356.26);
	CreateDynamicObject(18813, 914.79, -2023.40, 217.53,   0.00, 0.00, 0.30);
	CreateDynamicObject(18824, 880.83, -1981.18, 240.35,   -193.00, -42.00, 315.60);
	CreateDynamicObject(18809, 914.86, -2023.38, 174.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(18824, 777.03, -2100.79, 120.70,   -204.00, -18.00, 346.83);
	CreateDynamicObject(18824, 811.13, -2105.41, 140.17,   -204.00, 261.00, 333.12);
	CreateDynamicObject(18824, 840.52, -2118.82, 113.03,   -212.00, 17.00, 79.55);
	CreateDynamicObject(18824, 866.41, -2102.93, 79.67,   -212.00, -164.00, 70.17);
	CreateDynamicObject(18824, 893.96, -2116.66, 50.70,   -212.00, 69.00, 344.33);
	CreateDynamicObject(18824, 936.43, -2128.51, 41.77,   11.00, 61.00, 172.14);
	CreateDynamicObject(18826, 959.32, -2121.05, 14.99,   -29.00, -74.00, 91.00);
	CreateDynamicObject(18826, 965.51, -2095.16, 33.82,   -25.00, 64.00, 7.51);
	CreateDynamicObject(18824, 1001.94, -2087.84, 24.55,   -61.00, 21.00, 141.09);
	CreateDynamicObject(19129, 842.84, -2057.97, 11.90,   0.00, 0.00, 0.00);
	CreateDynamicObject(19129, 829.94, -2057.94, 11.90,   0.00, 0.00, 0.00);
	// Гора Чилиад
	CreateDynamicObject(18838, -2347.58, -1651.98, 491.53,   -52.00, 0.00, 8.15);
	CreateDynamicObject(18838, -2332.06, -1648.79, 501.30,   -52.00, 0.00, 195.44);
	CreateDynamicObject(18838, -2342.66, -1666.54, 508.10,   76.00, 0.00, 18.15);
	CreateDynamicObject(18838, -2324.46, -1674.06, 503.32,   33.00, 0.00, 192.20);
	CreateDynamicObject(18841, -2341.09, -1683.01, 512.63,   0.00, 0.00, 17.01);
	CreateDynamicObject(18841, -2325.56, -1662.07, 524.72,   -76.00, 0.00, 196.86);
	CreateDynamicObject(18838, -2345.05, -1659.51, 524.66,   62.00, 0.00, 18.94);
	CreateDynamicObject(18838, -2328.68, -1658.28, 535.56,   25.00, 0.00, 195.47);
	CreateDynamicObject(18838, -2346.66, -1652.77, 539.01,   62.00, 0.00, 17.53);
	CreateDynamicObject(18840, -2317.48, -1645.66, 534.94,   -91.00, 0.00, 243.26);
	CreateDynamicObject(18838, -2296.07, -1670.12, 541.77,   25.00, 0.00, 108.42);
	CreateDynamicObject(18838, -2305.41, -1657.35, 550.26,   81.00, 0.00, 290.90);
	CreateDynamicObject(18841, -2320.99, -1682.19, 549.30,   -98.00, 0.00, 111.56);
	CreateDynamicObject(18838, -2336.27, -1668.52, 551.01,   120.00, 0.00, 294.10);
	CreateDynamicObject(18838, -2318.59, -1676.59, 560.41,   47.00, 0.00, 115.91);
	CreateDynamicObject(18836, -2328.05, -1645.51, 565.80,   0.00, 0.00, 27.55);
	CreateDynamicObject(18838, -2335.85, -1614.37, 563.77,   -105.00, 0.00, 299.04);
	CreateDynamicObject(18838, -2314.69, -1620.30, 559.86,   -76.00, 0.00, 120.94);
	CreateDynamicObject(18841, -2330.46, -1607.62, 554.08,   -76.00, 0.00, 297.16);
	CreateDynamicObject(18838, -2333.45, -1630.03, 543.02,   -25.00, 0.00, 111.34);
	CreateDynamicObject(18838, -2329.02, -1611.52, 538.73,   -69.00, 0.00, 290.58);
	CreateDynamicObject(18840, -2302.68, -1633.95, 541.96,   -91.00, 0.00, 65.62);
	CreateDynamicObject(18838, -2273.94, -1625.01, 539.52,   -69.00, 0.00, 201.50);
	CreateDynamicObject(18838, -2293.31, -1618.71, 531.06,   -135.00, 0.00, 21.96);
	CreateDynamicObject(18838, -2283.29, -1602.23, 531.06,   -135.00, 0.00, -156.00);
	CreateDynamicObject(18840, -2308.44, -1618.03, 532.63,   107.00, -33.00, 15.00);
	CreateDynamicObject(18840, -2288.47, -1654.60, 520.43,   107.00, -18.00, 94.72);
	CreateDynamicObject(18840, -2253.91, -1631.49, 505.03,   117.00, -18.00, 192.39);
	CreateDynamicObject(18836, -2272.40, -1594.01, 494.77,   0.00, 0.00, 215.42);
	CreateDynamicObject(18841, -2305.18, -1574.68, 490.68,   -75.00, 0.00, 306.36);
	CreateDynamicObject(18780, -2338.76, -1540.80, 493.18,   0.00, 0.00, 94.52);
	CreateDynamicObject(18782, -2338.74, -1603.78, 483.85,   0.00, 0.00, 0.00);
	CreateDynamicObject(18779, -2238.98, -1727.86, 487.63,   0.00, 0.00, 127.23);
	CreateDynamicObject(18779, -2230.06, -1721.18, 487.63,   0.00, 0.00, 127.23);
	CreateDynamicObject(18809, -2215.56, -1752.10, 513.22,   54.00, 0.00, 34.00);
	CreateDynamicObject(18809, -2193.43, -1784.71, 541.84,   54.00, 0.00, 34.10);
	CreateDynamicObject(18826, -2178.51, -1796.44, 574.11,   17.00, 40.00, 117.40);
	CreateDynamicObject(18822, -2189.80, -1762.35, 563.16,   47.00, 4.00, 0.98);
	CreateDynamicObject(18822, -2188.87, -1727.28, 530.53,   -139.00, -160.00, 34.41);
	CreateDynamicObject(18824, -2191.47, -1692.99, 501.26,   222.00, 55.00, 51.22);
	CreateDynamicObject(18843, -2148.68, -1637.33, 500.16,   -84.00, 0.00, 316.33);
	CreateDynamicObject(18844, -2346.99, -1513.98, 570.42,   8.00, 0.00, 295.79);
	CreateDynamicObject(18789, -2292.69, -1776.37, 476.00,   0.00, 0.00, -84.00);
	CreateDynamicObject(18801, -2294.67, -1849.89, 498.92,   0.00, 0.00, 280.83);
	CreateDynamicObject(18801, -2313.67, -1853.74, 498.92,   0.00, 0.00, 280.83);
	CreateDynamicObject(18800, -2344.52, -1886.21, 487.14,   0.00, 0.00, 272.33);
	CreateDynamicObject(18800, -2392.76, -1832.98, 487.14,   0.00, 0.00, 92.96);
	CreateDynamicObject(18786, -2413.80, -1868.49, 478.44,   0.00, 0.00, 93.82);
	CreateDynamicObject(18786, -2353.17, -1628.50, 486.00,   0.00, 13.00, 0.00);
	CreateDynamicObject(18786, -2365.44, -1628.27, 495.83,   0.00, 35.00, 0.00);
	CreateDynamicObject(18750, -2407.04, -1611.11, 541.67,   -273.00, -62.00, 125.02);
	CreateDynamicObject(18771, -2300.96, -1590.21, 477.20,   0.00, 0.00, 0.00);
	CreateDynamicObject(18771, -2300.96, -1590.21, 526.85,   0.00, 0.00, 344.77);
	CreateDynamicObject(18813, -2185.14, -1821.76, 479.59,   0.00, 0.00, 0.98);
	CreateDynamicObject(18824, -2183.82, -1832.13, 436.15,   -5.00, -40.00, 286.69);
	CreateDynamicObject(18824, -2186.30, -1870.63, 418.89,   -69.00, -105.00, 47.07);
	CreateDynamicObject(19002, -2202.52, -1888.05, 417.03,   0.00, 0.00, 289.42);
	CreateDynamicObject(19005, -2212.01, -1890.83, 416.05,   0.00, 0.00, 108.27);
	CreateDynamicObject(19005, -2356.26, -1580.41, 492.03,   29.00, 4.00, 62.00);
	CreateDynamicObject(18824, -2110.62, -1579.19, 506.53,   262.00, 55.00, 238.28);
	CreateDynamicObject(18809, -2133.46, -1539.90, 510.57,   -94.00, 0.00, 223.27);
	CreateDynamicObject(18843, -2184.16, -1485.27, 507.12,   -84.00, 0.00, 222.79);
	CreateDynamicObject(18824, -2239.18, -1443.44, 502.44,   -91.00, 0.00, 267.53);
	CreateDynamicObject(18824, -2268.40, -1469.59, 503.25,   -91.00, 0.00, 355.99);
	CreateDynamicObject(18822, -2250.86, -1510.15, 510.83,   1.00, -113.00, 308.00);
	CreateDynamicObject(18813, -2226.69, -1575.23, 512.65,   -33.00, 0.00, 354.48);
	CreateDynamicObject(18824, -2231.82, -1609.18, 484.81,   17.00, -82.00, 252.96);
	CreateDynamicObject(19005, -2243.80, -1641.98, 488.63,   20.00, 0.00, 157.94);
	CreateDynamicObject(19001, -2327.38, -1712.70, 488.71,   0.00, 0.00, 351.06);
	CreateDynamicObject(19001, -2331.54, -1732.40, 488.71,   0.00, 0.00, 351.06);
	CreateDynamicObject(19001, -2335.66, -1751.63, 488.71,   0.00, 0.00, 351.06);
	CreateDynamicObject(19001, -2339.66, -1771.06, 488.71,   0.00, 0.00, 351.06);
	CreateDynamicObject(19001, -2343.73, -1790.39, 488.71,   0.00, 0.00, 351.06);
	CreateDynamicObject(19001, -2347.72, -1810.23, 488.71,   0.00, 0.00, 351.06);
	CreateDynamicObject(18781, -2350.28, -1820.02, 489.81,   0.00, 0.00, 169.22);
	CreateDynamicObject(18777, -2380.16, -1659.00, 498.66,   -25.00, 0.00, 154.09);
	CreateDynamicObject(18777, -2384.63, -1668.26, 522.43,   -25.00, 0.00, 154.70);
	CreateDynamicObject(18777, -2389.07, -1677.76, 546.18,   -25.00, 0.00, 154.96);
	CreateDynamicObject(18777, -2393.35, -1687.06, 570.00,   -25.00, 0.00, 155.57);
	CreateDynamicObject(18789, -2443.83, -1742.59, 550.61,   1.00, -33.00, 63.00);
	CreateDynamicObject(18801, -2485.61, -1803.63, 530.93,   -2.00, -28.00, 71.00);
	CreateDynamicObject(18786, -2495.20, -1797.44, 512.71,   0.00, 0.00, 59.30);
	CreateDynamicObject(18786, -2501.31, -1808.13, 519.86,   0.00, 29.00, 59.00);
	CreateDynamicObject(18782, -2293.87, -1647.65, 483.65,   0.00, 0.00, 76.00);
	// Дамба
	CreateDynamicObject(18754, -711.15, 1911.40, 5.00,   0.00, 0.00, 357.05); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18754, -809.03, 1687.93, 5.00,   0.00, 0.00, 357.05); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18754, -1163.20, 1209.68, 5.00,   0.00, 0.00, 357.05); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -610.77, 1978.88, 13.93,   -105.00, 0.00, 178.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -632.27, 1980.27, 22.23,   -105.00, 0.00, 354.35); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -612.20, 1978.87, 30.49,   -105.00, 0.00, 177.28); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -641.59, 1982.85, 37.01,   -96.00, 0.00, 314.73); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18820, -653.50, 1938.97, 38.89,   -89.00, 0.00, 0.38); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -702.14, 1938.85, 38.44,   91.00, 0.00, 269.20); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -745.59, 1951.55, 36.45,   -94.00, 0.00, 43.85); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -749.46, 1990.91, 43.32,   -222.00, 47.00, 269.71); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -715.69, 1998.83, 64.48,   24.00, 97.00, 158.94); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -698.55, 1975.12, 52.07,   -55.00, -146.00, 350.85); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -730.46, 1968.19, 58.97,   -47.00, -185.00, 137.39); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -716.00, 1937.72, 80.47,   -3.00, -47.00, 134.02); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -700.41, 1920.72, 118.74,   -3.00, 40.00, 310.24); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18813, -670.00, 1885.49, 95.53,   0.00, 0.00, 359.28); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -683.40, 1886.08, 52.52,   -4.00, 229.00, 352.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -714.56, 1883.68, 56.26,   25.00, 0.00, 348.04); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -697.05, 1866.34, 56.26,   25.00, 0.00, 169.01); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -720.17, 1857.29, 56.26,   25.00, 0.00, 348.04); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -702.55, 1839.99, 56.26,   25.00, 0.00, 169.01); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -725.28, 1830.91, 56.26,   25.00, 0.00, 348.04); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -692.52, 1817.19, 71.53,   -92.00, 0.00, 78.19); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -660.09, 1803.70, 57.96,   25.00, 0.00, 168.96); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -695.42, 1804.25, 42.70,   -92.00, 0.00, 77.78); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -743.38, 1814.93, 40.94,   -92.00, 0.00, 77.07); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -778.48, 1815.89, 54.55,   25.00, 0.00, 348.13); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -753.28, 1791.31, 68.49,   -91.00, 0.00, 212.86); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -753.35, 1760.62, 53.67,   25.00, 0.00, 83.83); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -742.66, 1780.58, 37.07,   -98.00, 0.00, 266.64); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -825.63, 1931.92, 8.51,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -825.63, 1931.92, 9.20,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -825.70, 1932.42, 8.49,   -47.00, -18.00, -11.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -825.71, 1932.37, 8.98,   -120.00, -18.00, -11.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -825.91, 1932.98, 9.15,   30.00, 4.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -825.99, 1933.40, 9.18,   -18.00, -3.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -825.94, 1933.16, 8.47,   -18.00, -3.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -727.93, 1745.99, 35.76,   -92.00, 0.00, 359.31); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -728.46, 1697.09, 37.46,   -92.00, 0.00, 359.21); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -728.54, 1647.68, 39.10,   -92.00, 0.00, 0.68); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -742.52, 1612.44, 33.79,   -113.00, 0.00, 91.96); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -610.16, 1940.16, 50.23,   -184.00, 47.00, 184.78); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18843, -597.47, 1939.91, 118.10,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -654.28, 1889.16, 38.84,   91.00, 0.00, 177.86); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -667.49, 1845.26, 35.78,   -99.00, 2.00, 135.17); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -704.54, 1820.46, 27.42,   -77.00, 2.00, 323.17); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -711.64, 1774.85, 22.75,   -91.00, 0.00, 5.33); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, -707.07, 1726.10, 23.69,   -91.00, 0.00, 5.33); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -690.60, 1684.02, 24.86,   88.00, 0.00, 51.52); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, -649.11, 1665.05, 24.86,   88.00, 0.00, -127.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, -647.02, 1635.52, 16.37,   61.00, 0.00, 97.05); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18859, -595.36, 1529.53, 15.67,   0.00, 0.00, 177.57); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18859, -595.36, 1529.53, 15.67,   0.00, 0.00, 177.57); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18859, -547.55, 1527.59, 15.67,   0.00, 0.00, 177.57); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18859, -500.52, 1525.92, 15.67,   0.00, 0.00, 177.57); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19129, -825.73, 1928.34, 7.06,   0.00, 0.00, 9.99); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19129, -829.15, 1947.40, 7.06,   0.00, 0.00, 9.99); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19129, -809.94, 1951.05, 4.50,   15.00, 0.00, 100.58); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19129, -806.48, 1931.62, 4.50,   15.00, 0.00, 99.87); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18752, -646.68, 1732.42, -11.33,   0.00, 0.00, 359.89); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, -783.45, 1721.47, 8.43,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, -902.29, 1204.82, 8.43,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, -782.77, 1755.43, 8.43,   0.00, 0.00, 178.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, -761.21, 1754.19, 8.43,   0.00, 0.00, 178.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19001, -720.38, 1856.18, 15.10,   0.00, 0.00, 335.74); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19001, -710.98, 1874.01, 15.10,   0.00, 0.00, 335.74); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19001, -701.74, 1892.02, 15.10,   0.00, 0.00, 335.74); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19001, -692.52, 1909.67, 15.10,   0.00, 0.00, 335.74); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18851, -781.02, 1902.52, 12.08,   0.00, 0.00, 101.90); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -785.70, 1926.90, 26.41,   0.00, 0.00, 11.44); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, -774.12, 1870.69, 18.47,   0.00, 0.00, 102.92); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, -797.85, 1983.22, 34.31,   0.00, 0.00, 287.43); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -785.01, 1927.10, 42.29,   0.00, 0.00, 12.16); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, -769.86, 1824.35, 78.53,   -55.00, 0.00, 100.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -785.01, 1927.10, 58.13,   0.00, 0.00, 12.16); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, -797.85, 1983.22, 66.02,   0.00, 0.00, 287.43); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -785.01, 1927.10, 74.02,   0.00, 0.00, 12.16); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -775.25, 1881.52, 74.02,   0.00, 0.00, 12.16); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, -772.79, 1871.19, 50.17,   0.00, 0.00, 102.92); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -787.60, 1879.51, 83.05,   0.00, 0.00, 11.65); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, -806.12, 1933.31, 78.53,   -55.00, 0.00, 287.73); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -799.96, 1875.39, 73.94,   0.00, 0.00, 11.65); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -779.95, 1778.47, 73.94,   0.00, 0.00, 11.65); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, -774.99, 1720.97, 78.53,   -55.00, 0.00, 100.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -792.88, 1775.97, 83.10,   0.00, 0.00, 11.75); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, -810.29, 1831.31, 78.53,   -55.00, 0.00, 276.50); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -809.87, 1773.87, 74.00,   0.00, 0.00, 6.90); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, -796.89, 1617.23, 78.53,   -55.00, 0.00, 100.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -797.76, 1675.28, 74.00,   0.00, 0.00, 6.90); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, -815.91, 1672.16, 83.07,   0.00, 0.00, 13.15); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, -831.21, 1731.62, 80.98,   0.00, 0.00, 17.38); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, -837.09, 1749.88, 80.98,   0.00, 0.00, 197.61); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, -574.45, 1664.38, 13.01,   -62.00, 0.00, 353.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, -558.82, 1662.76, 20.47,   -62.00, 0.00, 175.28); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, -573.77, 1664.25, 27.94,   -62.00, 0.00, 353.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, -558.06, 1662.58, 35.44,   -62.00, 0.00, 175.28); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, -573.62, 1663.62, 42.87,   -62.00, 0.00, 357.26); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, -557.85, 1663.29, 50.28,   -62.00, 0.00, 180.49); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, -590.00, 1653.32, 54.00,   0.00, 0.00, 276.62); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, -638.91, 1647.70, 54.00,   0.00, 0.00, 276.62); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, -687.82, 1642.05, 54.00,   0.00, 0.00, 276.62); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, -735.53, 1636.61, 54.00,   0.00, 0.00, 276.62); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18840, -783.24, 1640.63, 53.60,   -91.00, 0.00, 50.96); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, -796.81, 1686.23, 53.19,   0.00, 0.00, 184.80); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18837, -795.53, 1721.95, 53.14,   270.00, 265.00, 226.78); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18837, -776.14, 1734.37, 53.14,   270.00, 265.00, 51.31); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18837, -780.61, 1756.03, 53.14,   270.00, 265.00, 142.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, -794.73, 1758.52, 48.23,   0.00, 0.00, 87.53); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, -814.00, 1759.16, 48.23,   0.00, 0.00, 267.50); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18780, -711.76, 2008.01, 16.72,   0.00, 0.00, 29.38); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18841, -736.74, 1993.43, 12.97,   187.00, -86.00, 122.57); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, -716.39, 1932.61, 14.51,   0.00, 0.00, 154.29); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, -733.10, 1888.27, 14.51,   0.00, 0.00, 113.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, -680.48, 1869.43, 14.51,   0.00, 0.00, 295.88); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, -842.90, 1647.35, 13.94,   0.00, 0.00, 7.21); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, -852.70, 1646.08, 35.75,   0.00, 69.00, 7.65); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18771, -625.71, 1577.39, 2.55,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18771, -625.71, 1577.39, 51.99,   0.00, 0.00, 345.98); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18777, -584.99, 1609.01, 7.84,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18777, -584.99, 1609.01, 33.81,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18777, -584.99, 1609.01, 59.78,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18777, -584.96, 1609.43, 85.83,   0.00, 0.00, 358.23); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18778, -565.10, 1611.45, 110.61,   0.00, 0.00, 359.06); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18786, -650.19, 1910.51, 7.79,   0.00, 0.00, 162.46); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18783, -631.45, 1904.79, 7.76,   0.00, 0.00, 344.08); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18786, -636.92, 1886.45, 12.57,   0.00, 0.00, 73.76); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18783, -642.46, 1867.41, 12.56,   0.00, 0.00, 343.76); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18786, -648.05, 1848.87, 17.43,   0.00, 0.00, 72.86); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18783, -653.96, 1830.05, 17.48,   0.00, 0.00, 341.75); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18778, -657.69, 1818.48, 21.01,   0.00, 0.00, 163.13); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18778, -659.40, 1812.93, 25.25,   30.00, 0.00, 163.76); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18754, -593.36, 1663.13, 5.00,   0.00, 0.00, 357.05); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18761, -809.76, 1929.93, 10.36,   0.00, 0.00, 280.10); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18761, -813.61, 1950.79, 10.36,   0.00, 0.00, 281.39); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18782, -753.82, 1809.88, 6.80,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18782, -671.62, 1817.26, 6.80,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18782, -716.55, 1716.34, 6.80,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18782, -784.35, 1955.06, 6.70,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18782, -678.12, 1989.50, 6.70,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18782, -691.53, 1945.75, 6.70,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19336, -731.15, 1909.04, 28.68,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19076, -810.73, 1940.07, 5.19,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19076, -808.37, 1920.33, 5.19,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19076, -815.46, 1961.23, 5.19,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18750, -715.19, 2038.42, 58.84,   89.00, 0.00, 3.33); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, -762.41, 1721.42, 8.43,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18658, -790.72, 1741.75, -15.47,   -265.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18658, -782.77, 1741.69, -15.47,   -265.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18658, -775.11, 1741.59, -15.47,   -265.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18658, -768.05, 1740.84, -15.47,   -265.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18658, -760.60, 1739.79, -15.47,   -265.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18658, -752.98, 1738.67, -15.47,   -265.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18658, -802.94, 2030.32, 23.74,   47.00, 0.00, -142.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18657, -624.06, 2036.33, 25.08,   40.00, 0.00, 133.80); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.88, 1933.32, 10.12,   12.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.20, 1935.30, 9.20,   -20.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.20, 1935.62, 9.20,   24.00, -6.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.23, 1935.94, 9.20,   -10.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.38, 1936.10, 10.14,   -10.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.43, 1936.62, 10.14,   -10.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.29, 1936.47, 9.23,   -10.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.12, 1934.90, 9.20,   12.00, 2.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.10, 1934.68, 10.22,   12.00, 2.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.43, 1936.86, 10.22,   20.00, -2.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.40, 1937.21, 9.26,   20.00, -2.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.38, 1936.87, 9.36,   -79.00, -6.00, 1.62); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -825.63, 1931.92, 10.11,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.71, 1937.74, 9.09,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.71, 1937.74, 10.11,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.76, 1938.03, 10.21,   40.00, -4.00, 10.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.73, 1938.06, 9.50,   -35.00, 1.00, 8.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -826.61, 1938.17, 9.09,   -123.00, 13.00, 2.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.29, 1938.74, 8.69,   -69.00, 84.00, 358.08); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.34, 1939.11, 8.69,   -69.00, 84.00, 358.08); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18657, -722.97, 1856.70, 25.07,   40.00, 0.00, 133.80); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18658, -685.88, 1717.11, 23.74,   47.00, 0.00, 76.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.05, 1939.82, 10.01,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.03, 1939.91, 10.51,   -88.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.15, 1940.29, 9.19,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.17, 1940.51, 9.19,   26.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.22, 1940.84, 9.19,   -18.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.23, 1941.05, 9.19,   8.00, 0.00, -2.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.56, 1942.06, 8.72,   -88.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.05, 1939.82, 9.19,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.64, 1942.80, 9.30,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.70, 1943.24, 10.51,   -88.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.71, 1943.27, 8.80,   -88.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.64, 1942.79, 10.11,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.88, 1944.08, 9.30,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.93, 1944.53, 9.80,   -88.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.93, 1944.58, 9.30,   -88.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -827.95, 1944.58, 8.89,   -88.00, -8.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -828.19, 1945.33, 9.41,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -828.21, 1945.58, 9.41,   24.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -828.23, 1945.84, 9.41,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -828.34, 1946.30, 9.41,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, -828.69, 1946.31, 10.13,   -88.00, 0.00, 276.10); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18656, -819.12, 1914.76, 2.22,   -273.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18656, -827.64, 1963.64, 2.22,   -273.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18771, -732.85, 1799.50, 3.95,   0.00, 0.00, 0.00); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18771, -935.04, 1579.99, 53.75,   0.00, 0.00, 345.76); //Stunt Дамба by WaR..Tm_Ceni[B]
	CreateDynamicObject(18771, -732.85, 1799.50, 103.49,   0.00, 0.00, 332.46); //Stunt Дамба by WaR..Tm_Ceni[B]
	// Карьер в ЛВ
	CreateDynamicObject(18838, 619.61, 847.09, -37.18,   62.00, 0.00, 127.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18838, 610.29, 859.53, -29.77,   62.00, 0.00, 306.77); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18838, 619.61, 847.09, -22.31,   62.00, 0.00, 127.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18838, 610.29, 859.53, -14.87,   62.00, 0.00, 306.77); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18838, 619.61, 847.09, -7.45,   62.00, 0.00, 127.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18838, 610.29, 859.53, -0.03,   62.00, 0.00, 306.77); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18838, 619.40, 846.76, 7.42,   62.00, 0.00, 123.84); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18836, 609.89, 878.66, 11.12,   0.00, 0.00, 207.19); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18840, 597.13, 924.57, 9.59,   86.00, 0.00, 341.23); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18839, 636.75, 949.24, 8.00,   90.00, 0.00, 274.23); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18836, 684.35, 937.91, 7.98,   0.00, 0.00, 70.23); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18836, 730.17, 921.37, 7.98,   0.00, 0.00, 70.23); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18836, 771.20, 904.72, 17.68,   -25.00, 0.00, 65.07); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18836, 816.13, 883.58, 19.87,   -20.00, 0.00, 243.62); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18822, 657.34, 766.11, -9.42,   -76.00, 0.00, 84.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 613.56, 783.76, -0.74,   83.00, 0.00, 238.37); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 572.24, 809.37, 5.13,   83.00, 0.00, 238.16); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18818, 533.70, 841.23, 8.27,   91.00, 0.00, 330.63); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 488.34, 859.40, 10.90,   83.00, 0.00, 237.34); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18824, 458.17, 892.83, 17.97,   -79.00, -8.00, 3.89); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 471.80, 935.19, 23.51,   87.00, 0.00, 146.94); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18824, 505.62, 964.05, 28.82,   -79.00, -8.00, 271.09); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 548.30, 949.10, 34.46,   87.00, 0.00, 56.55); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 589.01, 920.98, 36.93,   87.00, 0.00, 54.43); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18826, 660.53, 876.69, 27.33,   -33.00, 0.00, 140.89); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18826, 659.60, 908.11, 17.87,   -76.00, 0.00, 322.15); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 627.80, 891.77, 39.40,   87.00, 0.00, 51.57); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18826, 679.33, 900.84, 35.02,   -33.00, 0.00, 140.01); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 646.98, 916.63, 47.88,   89.00, 0.00, 50.07); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18824, 621.47, 954.00, 47.00,   -91.00, 0.00, 4.53); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18824, 646.62, 984.14, 46.09,   -91.00, 0.00, 275.73); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18824, 683.42, 966.62, 55.42,   13.00, -129.00, 320.64); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18824, 697.35, 939.18, 89.64,   -153.00, -51.00, 321.50); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18843, 749.25, 892.74, 93.35,   84.00, 0.00, 232.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18822, 806.56, 849.75, 95.54,   -4.00, -113.00, 323.90); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18813, 859.48, 815.08, 98.00,   -47.00, 0.00, 62.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18824, 881.04, 790.78, 67.10,   -40.00, -135.00, 65.03); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18824, 860.54, 758.04, 55.77,   -84.00, -142.00, 326.85); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 815.53, 765.86, 55.11,   -92.00, 0.00, 245.95); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 770.95, 786.53, 56.80,   -92.00, 0.00, 244.20); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18826, 693.27, 815.57, 74.31,   29.00, 8.00, 330.98); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 726.67, 808.05, 58.40,   -92.00, 0.00, 243.89); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18826, 706.85, 792.31, 74.31,   29.00, 8.00, 151.82); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18826, 681.78, 786.72, 71.42,   29.00, -10.00, 339.95); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18826, 693.16, 764.24, 74.11,   29.00, 8.00, 150.89); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 659.84, 771.32, 59.92,   -92.00, 0.00, 244.91); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18809, 616.06, 791.84, 61.54,   -92.00, 0.00, 244.91); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19002, 594.17, 802.03, 59.77,   0.00, 0.00, 65.63); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19005, 586.42, 806.51, 59.55,   0.00, 0.00, 64.61); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18824, 551.52, 872.96, 19.90,   2.00, -47.00, 239.65); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18844, 557.44, 884.28, 88.17,   0.00, 0.00, 282.97); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18771, 672.65, 865.09, -46.07,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18771, 672.65, 865.10, 3.51,   0.00, 0.00, 342.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18771, 672.65, 865.10, 53.08,   0.00, 0.00, 325.44); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18782, 571.78, 903.46, -42.83,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18782, 654.98, 893.78, -42.83,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18782, 619.35, 819.22, -43.13,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18779, 533.75, 894.16, -34.97,   0.00, 0.00, 350.56); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18781, 833.06, 825.06, 22.01,   0.00, 0.00, 98.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18780, 813.73, 739.70, 25.94,   0.00, 0.00, 177.54); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18800, 764.18, 625.49, 20.30,   0.00, 0.00, -62.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18789, 697.55, 702.41, 32.42,   0.00, 0.00, 298.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 640.88, 797.35, 32.33,   0.00, 0.00, 137.25); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 568.88, 823.97, 32.33,   0.00, 0.00, 182.10); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18795, 513.02, 808.34, 31.71,   0.00, 0.00, 35.48); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18801, 492.90, 805.72, 55.32,   0.00, 0.00, 39.65); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 454.66, 798.05, 32.33,   0.00, 0.00, 15.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 379.28, 804.70, 32.33,   0.00, 0.00, 334.60); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 327.71, 860.15, 32.33,   0.00, 0.00, 291.39); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18805, 320.05, 971.68, 26.79,   0.00, -4.00, 270.56); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18783, 877.65, 907.72, 14.49,   0.00, 0.00, 0.59); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 877.93, 887.85, 14.53,   0.00, 0.00, 91.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 877.44, 924.98, 19.25,   0.00, 0.00, 91.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18783, 877.07, 944.64, 19.12,   0.00, 0.00, 1.10); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 894.69, 907.53, 19.25,   0.00, 0.00, 0.22); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18783, 914.49, 907.80, 19.33,   0.00, 0.00, 1.10); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 914.73, 889.83, 24.13,   0.00, 0.00, 270.90); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18783, 915.06, 870.15, 24.11,   0.00, 0.00, 0.80); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 896.24, 869.96, 28.94,   0.00, 0.00, 180.26); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18783, 876.33, 869.77, 28.85,   0.00, 0.00, 0.80); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 876.37, 851.67, 33.65,   0.00, 0.00, 269.88); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18783, 876.06, 832.08, 33.54,   0.00, 0.00, 358.29); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 915.55, 851.67, 28.94,   0.00, 0.00, 271.68); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18783, 915.94, 832.06, 28.90,   0.00, 0.00, 0.29); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 933.73, 832.15, 33.67,   0.00, 0.00, 0.62); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18783, 953.31, 832.54, 33.59,   0.00, 0.00, 1.67); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 875.83, 813.93, 38.30,   0.00, 0.00, 269.52); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 953.89, 814.17, 38.36,   0.00, 0.00, -88.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 932.51, 908.19, 24.11,   0.00, 0.00, 1.03); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18783, 952.49, 908.53, 24.11,   0.00, 0.00, 0.80); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18784, 952.18, 927.94, 28.99,   0.00, 0.00, 91.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18786, 877.01, 962.85, 23.90,   0.00, 0.00, 270.38); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18786, 951.82, 947.02, 33.66,   0.00, 0.00, 271.64); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18786, 954.38, 794.79, 43.14,   0.00, 0.00, 90.80); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18786, 876.12, 794.24, 43.11,   0.00, 0.00, 91.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18777, 380.22, 946.86, 28.45,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18777, 380.22, 946.86, 54.40,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18772, 396.38, 1071.47, 80.41,   0.00, 0.00, 1.76); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18790, 393.49, 1229.25, 117.43,   1.00, -76.00, 89.95); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18789, 396.54, 1138.71, 129.23,   0.00, 0.00, 271.85); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 405.98, 1029.62, 129.19,   0.00, 0.00, 291.83); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 457.20, 975.57, 129.19,   0.00, 0.00, 335.09); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 533.38, 969.63, 129.19,   0.00, 0.00, -344.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18790, 606.95, 1014.72, 103.99,   0.00, 0.00, 35.74); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 681.54, 1058.46, 129.08,   0.00, 0.00, 192.80); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18791, 755.93, 1046.31, 129.08,   0.00, 0.00, 148.59); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18777, 800.57, 1032.65, 131.85,   0.00, 0.00, 212.87); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18777, 800.57, 1032.65, 157.84,   0.00, 0.00, 212.87); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18795, 794.08, 1006.30, 180.44,   0.00, 0.00, 304.09); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18778, 801.09, 986.34, 182.73,   0.00, 0.00, 199.17); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18778, 802.42, 982.36, 185.73,   22.00, 0.00, 199.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18778, 677.70, 963.94, -12.60,   0.00, 0.00, 129.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18778, 673.10, 960.19, -9.24,   16.00, 0.00, 129.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18778, 669.40, 957.08, -4.50,   30.00, 0.00, 129.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18750, 889.21, 694.99, 17.20,   91.00, 0.00, 201.05); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18750, 413.54, 862.45, 44.12,   95.00, 0.00, 99.93); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19001, 664.99, 907.62, -33.04,   0.00, 0.00, 1.40); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19129, 767.14, 837.10, 4.78,   0.00, 0.00, 355.72); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19129, 748.16, 838.54, 4.78,   0.00, 0.00, 355.72); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19129, 729.13, 839.92, 4.78,   0.00, 0.00, 355.72); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18778, 716.89, 840.82, 6.09,   0.00, 0.00, 86.36); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18778, 712.00, 841.18, 9.04,   18.00, 0.00, 85.32); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19005, 291.15, 938.42, 24.75,   11.00, 0.00, 55.51); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19005, 280.59, 945.72, 36.48,   27.00, 0.00, 55.59); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19005, 627.57, 712.37, 14.27,   0.00, 0.00, -113.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(19005, 643.43, 705.69, 26.45,   22.00, 0.00, -113.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18841, 508.39, 678.03, 21.27,   14.00, 0.00, 0.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18841, 528.97, 669.93, 21.27,   14.00, 0.00, 178.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18841, 507.99, 662.66, 21.27,   14.00, 0.00, 0.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18841, 528.74, 654.69, 21.27,   14.00, 0.00, 178.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18841, 507.85, 647.37, 21.27,   14.00, 0.00, 0.00); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18836, 542.58, 643.10, 36.66,   0.00, 0.00, 89.07); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18836, 591.78, 642.42, 36.66,   0.00, 0.00, 89.07); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18836, 640.84, 641.73, 36.66,   0.00, 0.00, 89.07); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18839, 688.51, 641.53, 40.73,   -8.00, -69.00, 181.93); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18835, 752.50, 643.05, 73.05,   47.00, 0.00, 266.82); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18839, 783.04, 642.22, 56.59,   172.00, 78.00, 2.15); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18839, 832.27, 649.98, 56.10,   -91.00, -135.00, 342.34); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18839, 863.81, 686.85, 55.45,   -91.00, -135.00, 26.54); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18778, 867.05, 712.10, 51.47,   0.00, 0.00, 359.61); //by WaR..Tm_Ceni[B] | Stunt Career
	CreateDynamicObject(18778, 867.21, 718.06, 55.03,   18.00, 0.00, 360.00); //by WaR..Tm_Ceni[B] | Stunt Career
	// Аэропорт ЛВ
	CreateDynamicObject(19129, 1334.52, 1256.19, 9.80,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19129, 1314.78, 1256.20, 9.80,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19129, 1303.59, 1256.45, 9.80,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19129, 1334.57, 1276.02, 9.80,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19129, 1314.85, 1276.07, 9.80,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19129, 1303.55, 1276.20, 9.80,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19002, 1338.36, 1285.70, 10.00,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19002, 1300.52, 1285.84, 10.00,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19002, 1319.29, 1285.90, 10.00,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18841, 1320.87, 1432.20, 28.96,   -25.00, 1.00, 275.90);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1316.02, 1397.82, 14.48,   0.00, 0.00, -178.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18841, 1336.69, 1412.53, 28.96,   -25.00, 1.00, 98.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18841, 1347.66, 1434.37, 28.96,   -25.00, 1.00, 275.90);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18841, 1363.40, 1414.71, 28.96,   -25.00, 1.00, 98.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1367.94, 1448.73, 14.48,   0.00, 0.00, -178.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1366.32, 1496.31, 14.48,   0.00, 0.00, -178.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1371.85, 1528.95, 18.16,   -62.00, 0.00, 274.52);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1380.50, 1497.30, 21.90,   0.00, 0.00, 182.51);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1382.63, 1448.22, 21.90,   0.00, 0.00, 182.51);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1384.73, 1400.39, 21.90,   0.00, 0.00, 182.51);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18841, 1390.81, 1365.82, 36.57,   18.00, -2.00, 91.52);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1403.42, 1383.53, 51.96,   -91.00, 0.00, 270.72);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1419.55, 1368.20, 51.96,   -91.00, 0.00, 91.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1435.24, 1383.98, 51.96,   -91.00, 0.00, 270.72);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1451.34, 1368.65, 51.96,   -91.00, 0.00, 91.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18839, 1459.84, 1400.18, 56.63,   -4.00, -68.00, 269.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18835, 1446.52, 1462.42, 76.63,   37.00, 0.00, 24.89);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18839, 1438.81, 1485.30, 51.32,   -18.00, -125.00, 268.47);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1437.47, 1530.30, 42.22,   0.00, 0.00, 177.23);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1447.18, 1562.32, 41.64,   -94.00, 0.00, 265.64);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1461.51, 1545.43, 41.65,   -94.00, 0.00, 83.35);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1478.78, 1559.23, 41.64,   -94.00, 0.00, 265.64);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1493.02, 1542.32, 41.65,   -94.00, 0.00, 83.35);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1510.31, 1556.25, 41.64,   -94.00, 0.00, 265.64);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1524.59, 1539.27, 41.65,   -94.00, 0.00, 83.35);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18838, 1541.89, 1553.29, 41.64,   -94.00, 0.00, 265.64);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1548.96, 1520.39, 41.06,   0.00, 0.00, 359.46);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1548.52, 1472.08, 41.06,   0.00, 0.00, 359.46);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18836, 1548.00, 1423.84, 41.06,   0.00, 0.00, 359.46);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18786, 1547.63, 1398.64, 38.29,   0.00, 0.00, 94.31);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18786, 1548.68, 1387.37, 43.92,   0.00, 22.00, 95.88);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18771, 1439.04, 1330.22, 7.55,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18750, 1324.73, 1249.04, 38.26,   92.00, 0.00, 178.65);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19001, 1517.47, 1331.65, 19.57,   0.00, 0.00, -33.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18777, 1344.20, 1320.81, 12.24,   0.00, 0.00, 344.27);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18777, 1344.20, 1320.81, 38.28,   0.00, 0.00, 344.27);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18777, 1344.17, 1320.69, 64.27,   0.00, 0.00, 344.27);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18777, 1344.17, 1320.69, 90.34,   0.00, 0.00, 344.27);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18772, 1402.72, 1433.67, 116.21,   0.00, 0.00, 341.60);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18778, 1443.51, 1554.20, 114.91,   0.00, 0.00, 342.72);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18782, 1418.47, 1310.33, 10.95,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18782, 1307.83, 1310.29, 10.95,   0.00, 0.00, -171.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18782, 1367.37, 1261.36, 10.95,   0.00, 0.00, -25.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18782, 1528.11, 1400.57, 10.95,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18800, 1605.04, 1259.63, 20.66,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18800, 1551.42, 1259.35, 44.22,   0.00, 0.00, 180.12);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18791, 1618.55, 1288.76, 56.39,   0.00, 0.00, 20.73);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18789, 1705.12, 1357.02, 56.39,   0.00, 0.00, 221.77);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18791, 1782.71, 1438.46, 56.39,   0.00, 0.00, 66.47);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18791, 1783.35, 1515.03, 56.39,   0.00, 0.00, 112.60);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18791, 1730.69, 1569.77, 56.39,   0.00, 0.00, 155.26);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18801, 1692.86, 1588.49, 79.48,   0.00, 0.00, 3.57);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18790, 1531.49, 1190.41, 13.38,   0.00, 33.00, 89.66);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18805, 1619.33, 1602.99, 55.92,   0.00, 0.00, 356.21);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18790, 1515.97, 1190.21, 13.38,   0.00, 33.00, 89.66);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18790, 1500.39, 1190.26, 13.38,   0.00, 33.00, 89.66);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18790, 1484.85, 1190.45, 13.38,   0.00, 33.00, 89.66);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18790, 1469.24, 1190.49, 13.38,   0.00, 33.00, 89.66);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18784, 1395.90, 1236.98, 11.91,   0.00, 0.00, 271.96);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18784, 1396.45, 1224.89, 18.42,   0.00, -25.00, 272.89);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18784, 1397.17, 1216.20, 29.27,   0.00, -47.00, 274.01);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18826, 1429.93, 1229.71, 31.18,   -78.00, 0.00, 358.76);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18826, 1451.06, 1228.85, 24.52,   -78.00, 0.00, 176.38);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18826, 1431.36, 1229.49, 17.91,   -78.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19005, 1449.98, 1244.73, 32.02,   0.00, 0.00, 273.85);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19005, 1583.32, 1329.72, 12.69,   0.00, 0.00, 263.27);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19005, 1600.83, 1327.47, 25.16,   22.00, 0.00, 263.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18781, 1389.85, 1571.74, 20.22,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18781, 1478.69, 1574.67, 20.22,   0.00, 0.00, 0.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18780, 1575.07, 1650.21, 21.13,   0.00, 0.00, 17.51);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18780, 1572.18, 1659.49, 21.13,   0.00, 0.00, 17.51);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18779, 1616.87, 1540.19, 18.92,   0.00, 0.00, 122.15);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18752, 1450.75, 1773.82, 9.35,   0.00, 0.00, 183.71);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18778, 1330.22, 1682.20, 11.12,   0.00, 0.00, 88.59);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18778, 1325.70, 1682.31, 13.70,   18.00, 0.00, 89.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18778, 1321.90, 1682.24, 17.87,   34.00, 0.00, 89.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18822, 1313.92, 1569.24, 16.74,   13.00, -76.00, 36.47);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18822, 1287.24, 1542.07, 42.70,   11.00, -34.00, 39.02);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18844, 1278.78, 1519.80, 111.12,   14.00, 0.00, 349.41);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18780, 1526.77, 1610.91, 71.97,   0.00, 0.00, 171.46);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18859, 1528.35, 1725.21, 20.88,   0.00, 0.00, 0.37);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18824, 1568.93, 1727.44, 40.78,   105.00, 0.00, -127.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18824, 1574.61, 1690.10, 52.16,   105.00, 0.00, 144.39);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1532.20, 1672.44, 58.51,   -91.00, 0.00, 277.05);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1483.45, 1666.36, 59.31,   -91.00, 0.00, 277.35);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18826, 1450.45, 1648.30, 51.84,   120.00, 0.00, 7.10);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18826, 1474.68, 1624.03, 51.84,   120.00, 0.00, 189.52);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1442.39, 1605.72, 60.24,   -91.00, 0.00, 277.05);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18818, 1393.27, 1607.65, 60.81,   -91.00, 0.00, 186.72);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18824, 1351.71, 1584.99, 65.99,   76.00, 0.00, 316.58);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18824, 1388.55, 1642.52, 74.72,   4.00, -40.00, 275.65);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18843, 1386.06, 1652.72, 144.72,   0.00, 0.00, 18.35);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1341.49, 1541.37, 73.92,   84.00, 0.00, 1.96);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1342.61, 1492.52, 79.07,   84.00, 0.00, 0.67);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1343.08, 1443.71, 84.16,   84.00, 0.00, 0.36);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18813, 1318.01, 1389.17, 81.41,   -33.00, 0.00, -33.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18824, 1300.50, 1362.14, 52.73,   -2.00, -76.00, 238.22);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1277.83, 1326.35, 66.19,   55.00, 0.00, 327.26);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18824, 1268.21, 1289.91, 93.44,   56.00, 16.00, 1.72);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1303.01, 1261.86, 105.19,   91.00, 0.00, 243.15);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1345.64, 1240.45, 105.99,   91.00, 0.00, 243.55);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18824, 1390.17, 1229.30, 106.03,   91.00, 0.00, 102.37);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1423.20, 1260.08, 105.19,   91.00, 0.00, 149.14);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18813, 1452.24, 1304.67, 99.93,   62.00, 0.00, 325.93);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1476.22, 1340.88, 75.30,   59.00, 0.00, 327.10);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18809, 1499.32, 1374.56, 50.74,   59.00, 0.00, 324.13);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18786, 1514.15, 1396.12, 32.81,   -6.00, -25.00, 233.02);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18786, 1519.65, 1404.10, 33.57,   -2.00, 0.00, 235.89);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18786, 1527.62, 1415.55, 40.65,   0.00, 26.00, 235.10);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19002, 1706.02, 1607.75, 10.09,   0.00, 0.00, 73.96);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19002, 1719.61, 1609.45, 10.09,   0.00, 0.00, 73.96);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19002, 1716.87, 1599.14, 10.09,   0.00, 0.00, 73.96);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19129, 1712.63, 1607.33, 8.99,   0.00, 0.00, 342.09);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18786, 1669.30, 1620.97, 11.96,   0.00, 0.00, 358.13);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18786, 1657.00, 1621.28, 17.73,   0.00, 22.00, 358.20);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19005, 1270.37, 1297.25, 12.71,   0.00, 0.00, 55.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(19005, 1271.65, 1225.61, 12.71,   0.00, 0.00, 178.00);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18780, 1264.79, 1446.61, 20.50,   0.00, 0.00, 121.61);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18780, 1308.95, 1626.94, 21.21,   0.00, 0.00, 180.93);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18780, 1309.11, 1617.76, 21.21,   0.00, 0.00, 180.93);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18780, 1309.28, 1608.10, 21.21,   0.00, 0.00, 180.93);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	CreateDynamicObject(18780, 1269.25, 1617.19, 76.91,   0.00, -55.00, 180.83);// by WaR..Tm_Ceni[B] | Stunt Las Venturas Aero
	// Пиратский корабль в ЛВ (рядом с аэропортом)
	CreateDynamicObject(18753, 1975.47, 1535.43, 8.16,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18753, 1910.45, 1531.72, 8.16,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18753, 1968.63, 1656.39, 8.16,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18753, 1939.08, 1655.40, 8.16,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18750, 1961.66, 1593.19, 61.66,   94.00, 0.00, 22.27); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, 1863.84, 1541.80, 17.67,   -105.00, 0.00, 348.27); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, 1884.68, 1536.76, 25.92,   -105.00, 0.00, 164.51); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, 1865.30, 1541.96, 34.13,   -105.00, 0.00, 345.67); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, 1877.75, 1509.72, 47.25,   -55.00, 0.00, 166.45); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18826, 1852.76, 1487.98, 47.25,   -55.00, 0.00, 352.39); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, 1881.39, 1480.12, 46.14,   47.00, -46.00, 173.79); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, 1905.66, 1508.16, 70.95,   -230.00, -46.00, 7.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, 1943.86, 1539.98, 14.70,   0.00, 0.00, 279.37); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, 1954.89, 1541.51, 14.70,   0.00, 0.00, 279.37); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, 1965.92, 1543.29, 14.70,   0.00, 0.00, 279.37); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1939.13, 1581.57, 34.35,   -132.00, 0.00, 280.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, 1937.36, 1548.79, 39.68,   0.00, 0.00, 6.41); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1933.59, 1515.79, 43.41,   -62.00, 0.00, 93.66); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1924.57, 1530.48, 39.20,   -4.00, 0.00, 278.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1919.24, 1513.94, 27.33,   -120.00, 0.00, 97.23); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18841, 1900.30, 1529.50, 35.55,   40.00, 0.00, 276.22); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18840, 1902.44, 1497.17, 45.44,   -84.00, 0.00, 50.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, 1948.97, 1490.04, 43.22,   0.00, 0.00, 89.96); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1981.48, 1483.61, 46.89,   -62.00, 0.00, 184.21); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18840, 1951.18, 1483.07, 52.97,   -84.00, 0.00, 50.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, 1937.39, 1527.90, 55.24,   0.00, 0.00, 6.21); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18841, 1948.57, 1564.23, 55.54,   91.00, 0.00, 280.37); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1967.15, 1670.11, 29.46,   -60.00, 0.00, 1.95); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1982.58, 1670.85, 37.34,   -60.00, 0.00, 183.53); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1967.15, 1670.11, 45.29,   -60.00, 0.00, 2.58); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1982.58, 1670.85, 53.20,   -60.00, 0.00, 183.22); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1967.15, 1670.11, 61.22,   -60.00, 0.00, 2.58); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1982.58, 1670.85, 69.11,   -60.00, 0.00, 183.22); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, 2034.44, 1586.36, 20.90,   -25.00, 0.00, 189.58); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1968.57, 1655.09, 73.23,   -91.00, 0.00, 4.20); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18838, 1984.84, 1640.78, 76.44,   -67.00, 0.00, 182.51); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, 1953.24, 1631.06, 77.04,   -6.00, 0.00, 94.95); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18817, 1882.34, 1628.08, 81.94,   -81.00, 0.00, 90.80); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18823, 1886.90, 1584.18, 84.69,   -94.00, 0.00, 44.85); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18810, 1930.50, 1570.22, 86.68,   -91.00, 0.00, 85.47); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18984, 1873.73, 1702.39, 83.23,   0.00, 0.00, 0.60); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, 1878.30, 1760.38, 88.68,   -47.00, 0.00, 275.18); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18984, 1886.77, 1703.58, 94.05,   0.00, 0.00, 2.30); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, 1961.55, 1559.82, 89.01,   -76.00, 0.00, 174.11); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18993, 1890.67, 1649.84, 93.61,   -84.00, 0.00, 45.28); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, 1944.96, 1645.47, 93.16,   0.00, 0.00, 267.10); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18994, 1996.41, 1637.78, 93.06,   -91.00, 0.00, 174.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, 1943.85, 1633.04, 92.96,   0.00, 0.00, 269.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, 1886.33, 1627.08, 96.71,   62.00, 0.00, 359.19); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, 1943.27, 1617.61, 100.45,   0.00, 0.00, 267.27); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18991, 1944.90, 1546.07, 89.01,   -76.00, 0.00, 354.25); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18836, 1978.50, 1534.18, 45.40,   23.00, 18.00, 29.18); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, 1995.07, 1503.04, 32.83,   -6.00, -14.00, 204.88); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, 1965.47, 1537.03, 85.24,   0.00, 0.00, 267.33); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19002, 1974.21, 1536.13, 94.89,   12.00, 0.00, -94.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19002, 1975.53, 1536.13, 95.83,   12.00, 0.00, -94.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19002, 1976.56, 1536.19, 95.83,   12.00, 0.00, -94.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19002, 1977.65, 1536.21, 96.23,   12.00, 0.00, -94.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19002, 1978.51, 1536.23, 96.85,   12.00, 0.00, -94.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19002, 1979.22, 1536.26, 97.36,   12.00, 0.00, -94.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19002, 1980.12, 1536.27, 98.08,   12.00, 0.00, -94.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19002, 1981.22, 1536.25, 98.38,   12.00, 0.00, -94.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, 1945.15, 1512.38, 75.79,   -251.00, 236.00, 1.86); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18824, 1955.45, 1477.65, 76.84,   -303.00, 226.00, 282.45); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, 1922.72, 1458.12, 101.34,   -125.00, 0.00, 281.43); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18809, 1882.89, 1450.44, 129.82,   -125.00, 0.00, 280.46); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18844, 1829.44, 1436.88, 177.65,   -4.00, -46.00, 20.40); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, 2042.29, 1612.92, 100.45,   0.00, 0.00, 267.27); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18985, 2141.27, 1608.27, 100.45,   0.00, 0.00, 267.27); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, 2201.16, 1606.20, 97.86,   0.00, 0.00, 269.59); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, 2213.80, 1606.18, 109.78,   33.00, 0.00, 271.15); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2023.82, 1525.86, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.08, 1525.86, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.35, 1525.88, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.61, 1525.91, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.50, 1526.14, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.34, 1526.29, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.53, 1526.44, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.71, 1526.61, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.49, 1526.74, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.26, 1526.81, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.04, 1526.92, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.78, 1527.02, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.58, 1527.17, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.36, 1527.32, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.15, 1527.47, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.35, 1527.60, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.60, 1527.67, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.84, 1527.72, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.67, 1527.43, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.24, 1528.26, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.50, 1528.22, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.75, 1528.17, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.00, 1528.12, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.27, 1528.49, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.38, 1528.68, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.60, 1528.68, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.66, 1528.44, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.86, 1528.44, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.01, 1528.56, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19123, 2025.06, 1528.96, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19123, 2025.10, 1529.25, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.38, 1529.59, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.40, 1529.84, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.67, 1529.87, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.96, 1529.87, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.18, 1529.86, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.42, 1530.09, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.21, 1530.36, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.98, 1530.44, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.72, 1530.53, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.90, 1530.70, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.15, 1530.79, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.97, 1530.97, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.75, 1531.12, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.98, 1531.22, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.23, 1531.26, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19122, 2025.29, 1531.64, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19122, 2025.29, 1531.76, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19122, 2025.30, 1531.89, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19122, 2025.31, 1531.98, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19122, 2025.32, 1532.07, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.14, 1532.53, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.34, 1532.65, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.41, 1532.86, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.87, 1532.52, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.61, 1532.55, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.40, 1532.70, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.40, 1532.94, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.52, 1533.10, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.33, 1533.09, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.04, 1533.51, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.28, 1533.50, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.48, 1533.51, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.59, 1533.72, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.30, 1533.73, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.96, 1533.70, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.59, 1534.08, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.36, 1534.09, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.14, 1534.11, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.87, 1534.12, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.07, 1534.29, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.08, 1534.50, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.28, 1534.59, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.52, 1534.57, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.65, 1534.56, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.67, 1534.95, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.47, 1534.97, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.26, 1534.99, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2025.05, 1534.99, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19124, 2024.67, 1535.02, 9.39,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2023.76, 1523.97, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.05, 1523.95, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.34, 1523.94, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2023.48, 1523.97, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2023.20, 1523.99, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2023.90, 1524.12, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.04, 1524.34, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.26, 1524.36, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.40, 1524.14, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.13, 1524.69, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.35, 1524.83, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.54, 1524.92, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.80, 1524.91, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.96, 1524.76, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2025.11, 1524.59, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.56, 1525.10, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.37, 1525.20, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19125, 2024.18, 1525.24, 9.38,   0.00, 0.00, 359.38); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 2000.14, 1539.10, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 2003.61, 1538.99, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 2003.56, 1542.95, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 1997.67, 1539.07, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 1999.70, 1542.91, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 2003.54, 1546.87, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 2003.53, 1550.84, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 1999.70, 1546.89, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 1999.66, 1550.86, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 1997.74, 1543.03, 12.61,   0.00, 0.00, -2.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 1997.79, 1547.03, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 1997.89, 1549.60, 12.61,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18781, 2025.18, 1484.25, 19.98,   0.00, 0.00, 55.48); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18771, 2031.90, 1543.82, 6.87,   0.00, 0.00, 0.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18771, 2031.90, 1543.82, 56.55,   0.00, 0.00, 345.44); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18771, 2031.91, 1543.82, 106.31,   0.00, 0.00, 334.64); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19128, 2033.82, 1545.05, 156.10,   0.00, 0.00, 335.50); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, 2000.10, 1647.15, 11.13,   0.00, 0.00, 27.62); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(19005, 1996.96, 1652.71, 15.87,   14.00, 0.00, 29.56); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, 2009.19, 1597.01, 10.25,   1.00, -18.00, 273.00); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18777, 2010.39, 1607.26, 29.23,   0.00, 0.00, 8.08); //by WaR..Tm_Ceni[B]
	CreateDynamicObject(18779, 2023.87, 1626.43, 62.45,   0.00, 0.00, 271.80); //by WaR..Tm_Ceni[B]
	// Драг 1
	CreateDynamicObject(6123,802.9680176,-2980.6389160,19.8239994,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (2)
	CreateDynamicObject(6123,802.9580078,-3160.4570312,19.8050003,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (3)
	CreateDynamicObject(6123,802.8939819,-3340.7910156,19.7910004,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (4)
	CreateDynamicObject(6123,802.9180298,-3520.6650391,19.7709999,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (5)
	CreateDynamicObject(6123,802.9409790,-3700.6088867,19.7509995,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (6)
	CreateDynamicObject(6123,802.9658203,-3879.9472656,19.7369995,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (7)
	CreateDynamicObject(12998,782.1630859,-3989.1259766,20.0119991,0.0000000,0.0000000,357.9949951); //object(cunte_roads80) (1)
	CreateDynamicObject(6123,762.9345703,-3875.7138672,19.9419994,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (8)
	CreateDynamicObject(6123,763.0739746,-3695.7250977,19.9260006,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (9)
	CreateDynamicObject(6123,763.0989990,-3515.6608887,19.9099998,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (10)
	CreateDynamicObject(6123,763.1129761,-3349.7438965,19.8939991,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (11)
	CreateDynamicObject(6123,763.0634766,-3170.3417969,19.8780003,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (12)
	CreateDynamicObject(6123,763.2236328,-2991.3095703,19.8619995,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (13)
	CreateDynamicObject(6123,763.3935547,-2811.5957031,19.8460007,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (14)
	CreateDynamicObject(5243,802.9130859,-2748.0878906,25.0699997,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (2)
	CreateDynamicObject(5243,802.7290039,-2831.7570801,25.0599995,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (3)
	CreateDynamicObject(5243,802.9470215,-2915.3459473,25.0550003,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (4)
	CreateDynamicObject(5243,802.9069824,-2998.0620117,25.0349998,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (5)
	CreateDynamicObject(5243,803.3649902,-3082.3920898,25.0359993,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (6)
	CreateDynamicObject(5243,803.5579834,-3163.1530762,25.0440006,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (7)
	CreateDynamicObject(5243,802.9746094,-3242.2207031,25.0319996,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (8)
	CreateDynamicObject(5243,802.8330078,-3319.2780762,25.0219994,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (9)
	CreateDynamicObject(5243,803.2719727,-3400.3720703,25.0230007,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (10)
	CreateDynamicObject(5243,803.4409790,-3442.9960938,25.0020008,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (11)
	CreateDynamicObject(5243,803.2709961,-3527.6689453,25.0100002,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (12)
	CreateDynamicObject(5243,803.0510254,-3611.2370605,24.9820004,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (13)
	CreateDynamicObject(5243,803.4660034,-3692.2170410,24.9899998,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (14)
	CreateDynamicObject(5243,802.8850098,-3771.3090820,24.9810009,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (15)
	CreateDynamicObject(5243,803.3040161,-3851.6450195,24.9680004,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (16)
	CreateDynamicObject(5243,803.0341797,-3938.6347656,24.9699993,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(712,803.0549927,-2763.5900879,29.4230003,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (2)
	CreateDynamicObject(712,802.9539795,-2810.1809082,29.4309998,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (3)
	CreateDynamicObject(712,803.0170288,-2876.8200684,29.4200001,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (4)
	CreateDynamicObject(712,802.9520264,-2935.5959473,29.4080009,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (5)
	CreateDynamicObject(712,803.1069946,-3001.7790527,29.3750000,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (6)
	CreateDynamicObject(712,802.8880005,-3065.0900879,29.4039993,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (7)
	CreateDynamicObject(712,802.7620239,-3137.3479004,29.3889999,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (8)
	CreateDynamicObject(712,803.0629883,-3183.5148926,29.3610001,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (9)
	CreateDynamicObject(712,803.2150269,-3241.2758789,29.3850002,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (10)
	CreateDynamicObject(712,802.7830200,-3309.3359375,29.3750000,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (11)
	CreateDynamicObject(712,802.8670044,-3368.9860840,29.3589993,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (12)
	CreateDynamicObject(712,803.0120239,-3460.7399902,29.3549995,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (13)
	CreateDynamicObject(712,802.8179932,-3565.4599609,29.3549995,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (14)
	CreateDynamicObject(712,802.8380127,-3676.1320801,29.3349991,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (15)
	CreateDynamicObject(712,802.4349976,-3777.3310547,29.3320007,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(11505,803.3681641,-2723.9072266,24.1900005,0.0000000,0.0000000,0.0000000); //object(des_garwcanopy) (1)
	CreateDynamicObject(6123,803.0380859,-2800.8359375,19.8080006,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (15)
	CreateDynamicObject(3593,809.7189941,-3982.3969727,20.7999992,0.0000000,0.0000000,0.0000000); //object(la_fuckcar2) (1)
	CreateDynamicObject(3593,809.6740112,-3991.2409668,20.7999992,0.0000000,0.0000000,0.0000000); //object(la_fuckcar2) (2)
	CreateDynamicObject(3593,808.5460205,-3999.4409180,20.7919998,0.0000000,0.0000000,346.0000000); //object(la_fuckcar2) (3)
	CreateDynamicObject(3593,803.4199829,-4007.8229980,20.7999992,0.0000000,0.0000000,313.9979248); //object(la_fuckcar2) (4)
	CreateDynamicObject(3593,793.2340088,-4011.4851074,20.7999992,0.0000000,0.0000000,269.9947510); //object(la_fuckcar2) (5)
	CreateDynamicObject(3593,783.8610229,-4011.0639648,20.7999992,0.0000000,0.0000000,269.9945068); //object(la_fuckcar2) (6)
	CreateDynamicObject(3593,773.5479736,-4010.9299316,20.7999992,0.0000000,0.0000000,269.9945068); //object(la_fuckcar2) (7)
	CreateDynamicObject(3593,764.9929810,-4009.2629395,20.7999992,0.0000000,0.0000000,247.9945068); //object(la_fuckcar2) (8)
	CreateDynamicObject(3593,757.6619873,-4003.5048828,20.7999992,0.0000000,0.0000000,211.9943848); //object(la_fuckcar2) (9)
	CreateDynamicObject(3593,753.4229736,-3992.6760254,20.7919998,0.0000000,0.0000000,181.9921875); //object(la_fuckcar2) (10)
	CreateDynamicObject(3593,753.8099976,-3983.4279785,20.7999992,0.0000000,0.0000000,179.9880371); //object(la_fuckcar2) (11)
	CreateDynamicObject(3593,793.3980103,-3984.2299805,20.7999992,0.0000000,0.0000000,179.9835205); //object(la_fuckcar2) (12)
	CreateDynamicObject(3593,792.8820190,-3991.9770508,20.7999992,0.0000000,0.0000000,179.9835205); //object(la_fuckcar2) (13)
	CreateDynamicObject(3593,788.0570068,-3993.4260254,20.7999992,0.0000000,0.0000000,85.9835205); //object(la_fuckcar2) (14)
	CreateDynamicObject(3593,781.4940186,-3993.3159180,20.7999992,0.0000000,0.0000000,85.9790039); //object(la_fuckcar2) (15)
	CreateDynamicObject(3593,775.1370239,-3992.5090332,20.7999992,0.0000000,0.0000000,85.9790039); //object(la_fuckcar2) (16)
	CreateDynamicObject(3593,771.0050049,-3987.7299805,20.7999992,0.0000000,0.0000000,359.9790039); //object(la_fuckcar2) (17)
	CreateDynamicObject(3593,771.0059814,-3980.8149414,20.7999992,0.0000000,0.0000000,359.9780273); //object(la_fuckcar2) (18)
	CreateDynamicObject(5243,762.7520142,-3935.1479492,25.1749992,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,762.7379761,-3858.7971191,25.1730003,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,762.5780029,-3777.1999512,25.1529999,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,762.8779907,-3698.1860352,25.1650009,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,762.9479980,-3618.5681152,25.1569996,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,762.4710083,-3538.4741211,25.1130009,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,763.2189941,-3460.9689941,25.1410007,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,763.0349731,-3381.2299805,25.1159992,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,763.0089722,-3300.7041016,25.1250000,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,762.3189697,-3220.2241211,25.1089993,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,762.9619751,-3135.3911133,25.1089993,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,762.6489868,-3053.4570312,25.0939999,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,763.0859985,-2964.7929688,25.0930004,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(712,763.2260132,-3931.7189941,29.5259991,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,762.9769897,-3895.8068848,29.4960003,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,762.9030151,-3861.0449219,29.5259991,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.3319702,-3796.5681152,29.5259991,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.3079834,-3735.8999023,29.5100002,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.1049805,-3654.2189941,29.5100002,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,762.9069824,-3561.3869629,29.4939995,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,762.9340210,-3475.4628906,29.4939995,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.4210205,-3417.0568848,29.4769993,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.0609741,-3339.9479980,29.4860001,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.2890015,-3247.8959961,29.4580002,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.0980225,-3176.9470215,29.4699993,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.1060181,-3096.8310547,29.4619999,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.4080200,-3022.6730957,29.4370003,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.3410034,-2959.3039551,29.4459991,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.5930176,-2856.9870605,29.4300003,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(712,763.3289795,-2792.9990234,29.4300003,0.0000000,0.0000000,0.0000000); //object(vgs_palm03) (16)
	CreateDynamicObject(5243,763.2189941,-2876.8549805,25.0769997,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,762.9010010,-2794.9980469,25.7670002,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(3593,807.1649780,-2710.7299805,20.5030003,0.0000000,0.0000000,268.0000000); //object(la_fuckcar2) (19)
	CreateDynamicObject(3593,798.6359863,-2711.3579102,20.5030003,0.0000000,0.0000000,267.9949951); //object(la_fuckcar2) (20)
	CreateDynamicObject(1655,763.5999756,-2726.8510742,21.1299992,0.0000000,0.0000000,0.0000000); //object(waterjumpx2) (1)
	CreateDynamicObject(5243,763.7760010,-2760.9208984,25.0769997,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(6123,764.4140015,-2535.5839844,12.0290003,0.0000000,0.0000000,0.0000000); //object(lawroads_law17) (14)
	CreateDynamicObject(1655,764.3369751,-2620.2260742,13.3090000,0.0000000,0.0000000,180.0000000); //object(waterjumpx2) (2)
	CreateDynamicObject(5243,764.6339722,-2585.1679688,17.2600002,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(5243,764.9000244,-2503.1708984,17.2600002,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (17)
	CreateDynamicObject(18800,785.6409912,-2416.0439453,22.8810005,0.0000000,0.0000000,92.0000000); //object(mroadhelix1) (1)
	CreateDynamicObject(18772,809.5460205,-2568.1650391,37.9830017,0.0000000,0.0000000,0.0000000); //object(tunnelsection1) (2)
	CreateDynamicObject(5128,809.6030273,-2740.2719727,34.3779984,0.0000000,0.0000000,0.0000000); //object(btoroad1mnk_las2) (1)
	CreateDynamicObject(5243,808.9730225,-2725.3779297,40.2949982,0.0000000,0.0000000,0.0000000); //object(riverbridls_las2) (2)
	CreateDynamicObject(18649,806.0800171,-2728.6918945,19.8160000,0.0000000,0.0000000,0.0000000); //object(greenneontube1) (1)
	CreateDynamicObject(7933,808.9719849,-2789.2229004,35.6769981,0.0000000,0.0000000,0.0000000); //object(vegascrashbar06) (1)
	CreateDynamicObject(1251,803.0919800,-2728.7199707,19.8969994,0.0000000,0.0000000,268.0000000); //object(smashbar) (1)
	CreateDynamicObject(979,803.0369873,-2771.9560547,36.0849991,0.0000000,0.0000000,270.0000000); //object(sub_roadleft) (1)
	CreateDynamicObject(979,803.2620239,-2781.7770996,36.0849991,0.0000000,0.0000000,272.0000000); //object(sub_roadleft) (2)
	CreateDynamicObject(979,815.9559937,-2781.8469238,36.0849991,0.0000000,0.0000000,272.0000000); //object(sub_roadleft) (3)
	CreateDynamicObject(979,815.6329956,-2770.0109863,36.0849991,0.0000000,0.0000000,272.0000000); //object(sub_roadleft) (4)
	CreateDynamicObject(18761,808.9169922,-2769.5590820,40.0600014,0.0000000,0.0000000,0.0000000); //object(racefinishline1) (2)
	CreateDynamicObject(618,773.9869995,-2582.6140137,12.1770000,0.0000000,0.0000000,0.0000000); //object(veg_treea3) (1)
	CreateDynamicObject(618,755.3400269,-2582.1970215,12.1770000,0.0000000,0.0000000,0.0000000); //object(veg_treea3) (2)
	CreateDynamicObject(621,763.8250122,-2601.7958984,12.0129995,0.0000000,0.0000000,0.0000000); //object(veg_palm02) (1)
	CreateDynamicObject(621,764.2009888,-2530.6430664,12.0209999,0.0000000,0.0000000,0.0000000); //object(veg_palm02) (2)
	CreateDynamicObject(18689,803.0479736,-2730.6840820,19.8419991,0.0000000,0.0000000,0.0000000); //object(fire_bike) (1)
	// Драг 2
	CreateDynamicObject(6189,2940.7219200,-1995.0589600,-4.3898500,0.0000000,0.0000000,90.0600100); //
	CreateDynamicObject(6189,3071.3640100,-1994.9169900,-4.3898500,0.0000000,0.0000000,90.0600100); //
	CreateDynamicObject(6189,3202.0656700,-1994.7862500,-4.3898500,0.0000000,0.0000000,90.0600100); //
	CreateDynamicObject(6189,3332.7221700,-1994.4632600,-4.3898500,0.0000000,0.0000000,90.0600100); //
	CreateDynamicObject(16092,2875.1093800,-2003.9437300,10.2685700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(16092,2875.0585900,-1986.2935800,10.2685700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1262,2874.0573700,-1980.0459000,15.3652700,0.0000000,0.0000000,87.0600700); //
	CreateDynamicObject(1262,2873.9794900,-1978.8657200,15.3652700,0.0000000,0.0000000,87.0600700); //
	CreateDynamicObject(1262,2874.0004900,-1992.3995400,15.3652700,0.0000000,0.0000000,87.0600700); //
	CreateDynamicObject(1262,2874.0136700,-1993.5507800,15.3652700,0.0000000,0.0000000,87.0600700); //
	CreateDynamicObject(1262,2874.0039100,-1996.5166000,15.3652700,0.0000000,0.0000000,87.0600700); //
	CreateDynamicObject(1262,2874.0244100,-1997.7435300,15.3652700,0.0000000,0.0000000,87.0600700); //
	CreateDynamicObject(1262,2874.1098600,-2009.9299300,15.3652700,0.0000000,0.0000000,87.0600700); //
	CreateDynamicObject(1262,2874.0588400,-2011.1761500,15.3652700,0.0000000,0.0000000,87.0600700); //
	CreateDynamicObject(713,2875.1591800,-1995.4353000,9.9971200,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(18809,3471.2705100,-1995.0355200,15.2270600,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18822,3519.5957000,-1988.2916300,15.2450100,272.0000000,258.0000000,10.1000000); //
	CreateDynamicObject(18809,3257.9877900,-1844.8900100,33.0231400,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(983,3397.0454100,-1981.2565900,10.8028900,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(983,3397.0053700,-1987.6718800,10.8028900,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(983,3397.0388200,-1988.7053200,10.8028900,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(983,3397.0319800,-2007.8071300,10.8028900,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(983,3397.0476100,-2001.5944800,10.8028900,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(713,3005.3244600,-1978.9464100,9.3579600,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(713,3005.0969200,-2012.0163600,9.3579600,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(713,3135.6879900,-1978.6278100,9.3579600,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(713,3135.5918000,-2012.1876200,9.3579600,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(713,3266.5063500,-1978.4118700,9.3579600,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(713,3266.1652800,-2012.1213400,9.3579600,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3532,3396.5378400,-1979.9864500,10.5529700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3532,3396.4934100,-1983.2092300,10.5529700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3532,3396.6106000,-1987.1130400,10.5529700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3532,3396.3547400,-1990.8886700,10.5529700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3532,3396.3886700,-1999.9630100,10.5529700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3532,3396.3188500,-2003.6296400,10.5529700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3532,3396.4707000,-2007.6189000,10.5529700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(3532,3396.3964800,-2009.0968000,10.5529700,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(713,3396.1247600,-2010.3043200,9.3579600,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(713,3396.7448700,-1979.0222200,9.3579600,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(18827,3332.7805200,-1842.5919200,96.8528400,0.0000000,0.0000000,-90.0000800); //
	CreateDynamicObject(18809,3257.9782700,-1842.5776400,96.9078200,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18827,3431.3972200,-1842.5896000,96.8528400,0.0000000,0.0000000,-90.0000800); //
	CreateDynamicObject(18829,3506.3247100,-1842.5378400,96.3083400,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18829,3555.8471700,-1842.6329300,96.3083400,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18829,3605.6355000,-1842.6368400,96.3083400,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18827,3679.9543500,-1842.7021500,96.2128900,0.0000000,0.0000000,-90.0000800); //
	CreateDynamicObject(18809,3421.5932600,-1995.1536900,15.2270600,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18822,3553.3029800,-1956.0402800,15.4510400,272.0000000,258.0000000,53.7200800); //
	CreateDynamicObject(18822,3556.3156700,-1909.3991700,15.7675800,272.0000000,258.0000000,94.8799800); //
	CreateDynamicObject(18822,3526.3391100,-1874.0538300,16.0459300,272.0000000,258.0000000,141.7998000); //
	CreateDynamicObject(18822,3480.3894000,-1857.2629400,16.0783600,272.0000000,258.0000000,321.6189300); //
	CreateDynamicObject(18826,3222.7529300,-1842.5914300,81.0041400,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(18809,3258.0043900,-1842.6333000,65.0954700,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18826,3293.2253400,-1843.9072300,49.0994500,4.0000000,0.0000000,-180.0000000); //
	CreateDynamicObject(18832,3225.1955600,-1844.8618200,25.0917300,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(18809,3258.0781300,-1844.9781500,16.4365200,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18809,3307.9545900,-1845.0332000,16.3722900,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18832,3449.1074200,-1843.1118200,17.3152800,98.0000000,258.0000000,48.7200200); //
	CreateDynamicObject(18832,3444.2028800,-1863.8957500,17.3152800,98.0000000,258.0000000,-136.9197800); //
	CreateDynamicObject(18822,3413.7946800,-1848.1970200,16.0783600,272.0000000,258.0000000,139.5192000); //
	CreateDynamicObject(18809,3367.6948200,-1841.8758500,16.2703000,0.0000000,90.0000000,7.1999900); //
	CreateDynamicObject(18809,3318.3515600,-1845.1564900,16.2895700,0.0000000,90.0000000,0.4200000); //
	CreateDynamicObject(18778,3237.1467300,-1844.4980500,11.1101400,0.0000000,0.0000000,90.7799900); //
	CreateDynamicObject(18810,3754.2421900,-1842.7196000,96.1725800,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18810,3803.5588400,-1842.6394000,96.1725800,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18810,3853.1093800,-1842.6927500,96.1725800,0.0000000,90.0000000,0.0000000); //
	CreateDynamicObject(18825,3888.3200700,-1842.8160400,112.1221800,0.0000000,0.0000000,-180.6000800); //
	CreateDynamicObject(18825,3868.5976600,-1844.3658400,143.7224900,0.0000000,0.0000000,-351.5999100); //
	CreateDynamicObject(18826,3886.9338400,-1826.3309300,164.3660600,113.0000000,164.0000000,25.2599900); //
	CreateDynamicObject(18826,3864.2436500,-1828.0339400,176.0922900,113.0000000,164.0000000,193.2001800); //
	CreateDynamicObject(18826,3883.6608900,-1858.0108600,176.0922900,113.0000000,164.0000000,13.0201900); //
	CreateDynamicObject(18827,3821.9104000,-1870.6825000,171.0800300,0.0000000,0.0000000,-91.8000000); //
	CreateDynamicObject(18826,3761.1684600,-1883.7465800,175.8690300,113.0000000,164.0000000,194.0394100); //
	CreateDynamicObject(18827,3820.3969700,-1900.1624800,182.8763600,0.0000000,0.0000000,-91.8000000); //
	CreateDynamicObject(18827,3919.4392100,-1903.3125000,182.8763600,0.0000000,0.0000000,-91.8000000); //
	CreateDynamicObject(18982,4019.1958000,-1906.6613800,182.8651000,0.0000000,0.0000000,-92.0000000); //
	CreateDynamicObject(18882,4142.1230500,-1908.4346900,164.5281700,0.0000000,0.0000000,-0.1200000); //
	CreateDynamicObject(18882,4142.4003900,-1908.3233600,200.9451100,0.0000000,179.0000000,-0.0600000); //
	CreateDynamicObject(18982,4142.3193400,-1783.9621600,182.8606300,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(19005,4142.0073200,-1720.9532500,181.0417900,0.0000000,0.0000000,0.0000000); //
	// Драг 3
	CreateDynamicObject(8357,257.5000000,2980.8994100,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgssairportland14)(1)
	CreateDynamicObject(8357,257.5000000,3193.6992200,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgssairportland14)(2)
	CreateDynamicObject(8357,257.5000000,3406.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgssairportland14)(3)
	CreateDynamicObject(3578,238.2000000,2930.6001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(1)
	CreateDynamicObject(3578,238.2000000,2940.8999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(2)
	CreateDynamicObject(3578,238.2000000,2951.1999500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(3)
	CreateDynamicObject(3578,238.2000000,2961.5000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(4)
	CreateDynamicObject(3578,238.2000000,2971.8000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(5)
	CreateDynamicObject(3578,238.2000000,2982.1001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(6)
	CreateDynamicObject(3578,238.1992200,2992.3994100,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(7)
	CreateDynamicObject(3578,238.1992200,3002.6992200,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(8)
	CreateDynamicObject(3578,238.2000000,3013.0000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(9)
	CreateDynamicObject(3578,238.2000000,3023.3000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(10)
	CreateDynamicObject(3578,238.2000000,3033.6001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(11)
	CreateDynamicObject(3578,238.2000000,3043.8999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(12)
	CreateDynamicObject(3578,238.2000000,3054.1999500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(13)
	CreateDynamicObject(3578,238.2000000,3064.5000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(14)
	CreateDynamicObject(3578,238.2000000,3074.8000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(15)
	CreateDynamicObject(3578,238.2000000,3085.0000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(16)
	CreateDynamicObject(3578,238.2000000,3095.3000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(17)
	CreateDynamicObject(3578,238.2000000,3105.6001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(18)
	CreateDynamicObject(3578,238.2000000,3115.8000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(19)
	CreateDynamicObject(3578,238.2000000,3126.1001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(20)
	CreateDynamicObject(3578,238.2000000,3136.1999500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(21)
	CreateDynamicObject(3578,238.2000000,3146.5000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(22)
	CreateDynamicObject(3578,238.2000000,3156.8000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(23)
	CreateDynamicObject(3578,238.2000000,3167.1001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(24)
	CreateDynamicObject(3578,238.2000000,3177.3999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(25)
	CreateDynamicObject(3578,238.2000000,3187.6001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(26)
	CreateDynamicObject(3578,238.2000000,3208.1999500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(27)
	CreateDynamicObject(3578,238.2000000,3218.5000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(28)
	CreateDynamicObject(3578,238.2000000,3228.8000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(29)
	CreateDynamicObject(3578,238.2000000,3249.3999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(30)
	CreateDynamicObject(3578,238.2000000,3280.1001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(31)
	CreateDynamicObject(3578,238.2000000,3300.6999500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(32)
	CreateDynamicObject(3578,238.2000000,3311.0000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(33)
	CreateDynamicObject(3578,238.2000000,3290.3999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(34)
	CreateDynamicObject(3578,238.2000000,3239.1001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(35)
	CreateDynamicObject(3578,238.2000000,3321.3000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(36)
	CreateDynamicObject(3578,238.2000000,3269.8999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(37)
	CreateDynamicObject(3578,238.1992200,3259.5996100,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(38)
	CreateDynamicObject(3578,238.2000000,3331.6001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(39)
	CreateDynamicObject(3578,238.2000000,3341.8999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(40)
	CreateDynamicObject(3578,238.2000000,3372.6999500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(41)
	CreateDynamicObject(3578,238.2000000,3352.1999500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(42)
	CreateDynamicObject(3578,238.2000000,3403.6001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(43)
	CreateDynamicObject(3578,238.2000000,3362.5000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(44)
	CreateDynamicObject(3578,238.2000000,3393.3000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(45)
	CreateDynamicObject(3578,238.2000000,3383.0000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(46)
	CreateDynamicObject(3578,238.2000000,3413.8999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(47)
	CreateDynamicObject(3578,238.1992200,3434.5000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(48)
	CreateDynamicObject(3578,238.2000000,3424.1999500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(49)
	CreateDynamicObject(3578,238.2000000,3455.1001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(50)
	CreateDynamicObject(3578,238.1992200,3444.7998000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(51)
	CreateDynamicObject(3578,238.2000000,3475.6999500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(52)
	CreateDynamicObject(3578,238.2000000,3197.8999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(53)
	CreateDynamicObject(3578,238.2000000,3465.3999000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(54)
	CreateDynamicObject(3578,238.2000000,3486.0000000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(55)
	CreateDynamicObject(3578,238.2000000,3496.3000500,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(56)
	CreateDynamicObject(3578,238.2000000,3506.6001000,7.9000000,0.0000000,0.0000000,90.0000000); //object(dockbarr1_la)(57)
	CreateDynamicObject(3578,243.0000000,3511.6992200,7.9000000,0.0000000,0.0000000,359.2470000); //object(dockbarr1_la)(58)
	CreateDynamicObject(3578,253.2000000,3511.5000000,7.9000000,0.0000000,0.0000000,359.2470000); //object(dockbarr1_la)(59)
	CreateDynamicObject(3578,263.5000000,3511.3999000,7.9000000,0.0000000,0.0000000,359.2470000); //object(dockbarr1_la)(60)
	CreateDynamicObject(3578,272.2000100,3511.3000500,7.9000000,0.0000000,0.0000000,359.2470000); //object(dockbarr1_la)(61)
	CreateDynamicObject(3578,276.7999900,2935.6001000,7.9000000,0.0000000,0.0000000,269.9970000); //object(dockbarr1_la)(62)
	CreateDynamicObject(3578,276.7999900,2945.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(66)
	CreateDynamicObject(3578,276.7999900,2956.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(67)
	CreateDynamicObject(3578,276.7999900,2966.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(68)
	CreateDynamicObject(3578,276.7999900,2976.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(69)
	CreateDynamicObject(3578,276.7999900,2987.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(70)
	CreateDynamicObject(3578,276.7999900,2997.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(71)
	CreateDynamicObject(3578,276.7999900,3007.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(72)
	CreateDynamicObject(3578,276.7999900,3018.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(73)
	CreateDynamicObject(3578,276.7999900,3028.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(74)
	CreateDynamicObject(3578,276.7999900,3038.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(75)
	CreateDynamicObject(3578,276.7999900,3048.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(76)
	CreateDynamicObject(3578,276.7999900,3059.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(77)
	CreateDynamicObject(3578,276.7998000,3069.2998000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(78)
	CreateDynamicObject(3578,276.7999900,3079.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(79)
	CreateDynamicObject(3578,276.7999900,3089.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(80)
	CreateDynamicObject(3578,276.7999900,3100.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(81)
	CreateDynamicObject(3578,276.7999900,3110.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(82)
	CreateDynamicObject(3578,276.7999900,3120.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(83)
	CreateDynamicObject(3578,276.7999900,3131.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(84)
	CreateDynamicObject(3578,276.7999900,3141.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(85)
	CreateDynamicObject(3578,276.7999900,3151.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(86)
	CreateDynamicObject(3578,276.7999900,3161.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(87)
	CreateDynamicObject(3578,276.7999900,3172.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(88)
	CreateDynamicObject(3578,257.5996100,2967.2998000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,257.5996100,2977.5996100,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(90)
	CreateDynamicObject(3578,257.6000100,2987.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(91)
	CreateDynamicObject(3578,257.6000100,2998.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(92)
	CreateDynamicObject(3578,257.6000100,3008.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(93)
	CreateDynamicObject(3578,257.6000100,3018.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(94)
	CreateDynamicObject(3578,257.5996100,3028.8994100,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(95)
	CreateDynamicObject(3578,257.5996100,3039.1992200,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(96)
	CreateDynamicObject(3578,257.6000100,3049.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(97)
	CreateDynamicObject(3578,257.6000100,3059.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(98)
	CreateDynamicObject(3578,257.6000100,3069.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(99)
	CreateDynamicObject(3578,257.6000100,3080.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(100)
	CreateDynamicObject(3578,257.6000100,3090.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(101)
	CreateDynamicObject(3578,257.6000100,3100.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(102)
	CreateDynamicObject(3578,257.6000100,3111.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(103)
	CreateDynamicObject(3578,257.6000100,3121.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(104)
	CreateDynamicObject(3578,257.6000100,3131.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(105)
	CreateDynamicObject(3578,257.6000100,3142.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(106)
	CreateDynamicObject(3578,257.6000100,3152.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(107)
	CreateDynamicObject(3578,257.6000100,3162.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(108)
	CreateDynamicObject(3578,257.6000100,3172.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(109)
	CreateDynamicObject(3578,257.5996100,3183.1992200,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(110)
	CreateDynamicObject(3578,257.6000100,3193.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(111)
	CreateDynamicObject(3578,257.6000100,3203.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(112)
	CreateDynamicObject(3578,257.6000100,3214.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(113)
	CreateDynamicObject(3578,257.5996100,3224.2998000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(114)
	CreateDynamicObject(3578,257.6000100,3234.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(115)
	CreateDynamicObject(3578,257.6000100,3244.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(116)
	CreateDynamicObject(3578,257.6000100,3255.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(117)
	CreateDynamicObject(3578,257.6000100,3265.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(118)
	CreateDynamicObject(3578,257.6000100,3275.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(119)
	CreateDynamicObject(3578,257.6000100,3286.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(120)
	CreateDynamicObject(3578,257.6000100,3296.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(121)
	CreateDynamicObject(3578,257.6000100,3306.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(122)
	CreateDynamicObject(3578,257.6000100,3316.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(123)
	CreateDynamicObject(3578,257.6000100,3327.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(124)
	CreateDynamicObject(3578,257.6000100,3337.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(125)
	CreateDynamicObject(3578,257.6000100,3347.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(126)
	CreateDynamicObject(3578,257.6000100,3358.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(127)
	CreateDynamicObject(3578,257.6000100,3368.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(128)
	CreateDynamicObject(3578,257.6000100,3378.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(129)
	CreateDynamicObject(3578,257.6000100,3389.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(130)
	CreateDynamicObject(3578,257.6000100,3399.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(131)
	CreateDynamicObject(3578,257.6000100,3409.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(132)
	CreateDynamicObject(3578,257.6000100,3419.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(133)
	CreateDynamicObject(3578,257.6000100,3430.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(134)
	CreateDynamicObject(3578,257.6000100,3440.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(135)
	CreateDynamicObject(3578,257.6000100,3450.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(136)
	CreateDynamicObject(3578,257.6000100,3460.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(137)
	CreateDynamicObject(3578,257.6000100,3471.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(138)
	CreateDynamicObject(3578,276.7999900,3182.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(139)
	CreateDynamicObject(3578,276.7999900,3192.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(140)
	CreateDynamicObject(3578,276.7999900,3202.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(141)
	CreateDynamicObject(3578,276.7999900,3213.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(142)
	CreateDynamicObject(3578,276.7999900,3223.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(143)
	CreateDynamicObject(3578,276.7999900,3233.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(144)
	CreateDynamicObject(3578,276.7999900,3244.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(145)
	CreateDynamicObject(3578,276.7999900,3254.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(146)
	CreateDynamicObject(3578,276.7999900,3264.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(147)
	CreateDynamicObject(3578,276.7999900,3274.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(148)
	CreateDynamicObject(3578,276.7999900,3285.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(149)
	CreateDynamicObject(3578,276.7999900,3295.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(150)
	CreateDynamicObject(3578,276.7999900,3305.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(151)
	CreateDynamicObject(3578,276.7999900,3315.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(152)
	CreateDynamicObject(3578,276.7999900,3326.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(153)
	CreateDynamicObject(3578,276.7999900,3336.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(154)
	CreateDynamicObject(3578,276.7999900,3346.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(155)
	CreateDynamicObject(3578,276.7999900,3357.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(156)
	CreateDynamicObject(3578,276.7999900,3367.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(157)
	CreateDynamicObject(3578,276.7999900,3377.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(158)
	CreateDynamicObject(3578,276.7999900,3387.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(159)
	CreateDynamicObject(3578,276.7999900,3398.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(160)
	CreateDynamicObject(3578,276.7999900,3408.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(161)
	CreateDynamicObject(3578,276.7999900,3418.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(162)
	CreateDynamicObject(3578,276.7999900,3429.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(163)
	CreateDynamicObject(3578,276.7999900,3439.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(164)
	CreateDynamicObject(3578,276.7999900,3449.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(165)
	CreateDynamicObject(3578,276.7999900,3459.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(166)
	CreateDynamicObject(3578,276.7999900,3469.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(167)
	CreateDynamicObject(3578,276.7999900,3479.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(168)
	CreateDynamicObject(3578,276.7999900,3490.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(169)
	CreateDynamicObject(3578,276.7998000,3500.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,276.7998000,3506.2998000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(171)
	CreateDynamicObject(983,273.5000000,2961.3000500,7.8000000,0.0000000,0.0000000,90.0000000); //object(fenceshit3)(1)
	CreateDynamicObject(16092,264.2999900,2962.1999500,7.1000000,0.0000000,0.0000000,90.0000000); //object(des_pipestrut05)(1)
	CreateDynamicObject(16092,250.8000000,2962.1999500,7.1000000,0.0000000,0.0000000,89.9950000); //object(des_pipestrut05)(2)
	CreateDynamicObject(3578,242.1000100,2966.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,2976.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(983,241.6000100,2961.3000500,7.8000000,0.0000000,0.0000000,90.0000000); //object(fenceshit3)(1)
	CreateDynamicObject(3578,242.1000100,2987.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,2997.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3007.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3017.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3028.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3038.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3048.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3059.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3069.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3079.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3089.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3100.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3110.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3120.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3131.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3141.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3151.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3161.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3172.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3182.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3192.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3202.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3213.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3223.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3233.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3244.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3254.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3264.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3275.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3285.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3295.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3305.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3316.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3326.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3336.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3347.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3357.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3367.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3377.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3388.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3398.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3408.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3419.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3429.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3439.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3450.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3460.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3470.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3480.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3491.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,242.1000100,3501.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(89)
	CreateDynamicObject(3578,247.0000000,3506.3000500,7.9000000,0.0000000,0.0000000,358.7470000); //object(dockbarr1_la)(58)
	CreateDynamicObject(3578,257.2999900,3506.1001000,7.9000000,0.0000000,0.0000000,358.7420000); //object(dockbarr1_la)(58)
	CreateDynamicObject(3578,267.6000100,3505.8999000,7.9000000,0.0000000,0.0000000,358.7420000); //object(dockbarr1_la)(58)
	CreateDynamicObject(1210,242.3999900,3221.3000500,8.1000000,0.0000000,0.0000000,0.0000000); //object(briefcase)(1)
	CreateDynamicObject(3578,273.0000000,3500.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3490.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3480.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3470.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(16092,250.2000000,3475.3000500,7.1000000,0.0000000,0.0000000,90.0000000); //object(des_pipestrut05)(3)
	CreateDynamicObject(16092,265.2000100,3475.3000500,7.1000000,0.0000000,0.0000000,90.0000000); //object(des_pipestrut05)(4)
	CreateDynamicObject(3578,273.0000000,3459.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3449.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3439.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3429.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3418.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3408.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3398.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3387.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3377.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3367.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3357.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3346.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3336.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3326.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3315.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3305.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3295.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3285.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3274.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3264.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3254.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3244.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3233.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3223.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3213.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3202.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3192.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3182.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3172.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3161.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3151.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3141.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3131.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3120.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3110.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3100.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3089.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3079.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3069.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3059.0000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3048.6999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3038.3999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3028.1001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3017.8000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,3007.5000000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,2997.1999500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,2986.8999000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,2976.6001000,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(3578,273.0000000,2966.3000500,7.9000000,0.0000000,0.0000000,269.9950000); //object(dockbarr1_la)(170)
	CreateDynamicObject(1262,257.5000000,2961.3999000,14.6000000,0.0000000,0.0000000,182.0000000); //object(mtraffic4)(1)
	CreateDynamicObject(1262,244.0000000,2961.5000000,14.5000000,0.0000000,0.0000000,182.0000000); //object(mtraffic4)(2)
	CreateDynamicObject(1262,250.7000000,2961.5000000,14.6000000,0.0000000,0.0000000,182.0000000); //object(mtraffic4)(3)
	CreateDynamicObject(1262,264.2999900,2961.5000000,14.6000000,0.0000000,0.0000000,182.0000000); //object(mtraffic4)(4)
	CreateDynamicObject(1262,271.0000000,2961.5000000,14.4000000,0.0000000,0.0000000,182.0000000); //object(mtraffic4)(5)
	CreateDynamicObject(1262,257.5000000,2961.3999000,10.7000000,0.0000000,0.0000000,182.0000000); //object(mtraffic4)(6)
	CreateDynamicObject(1262,270.8999900,2961.5000000,10.9000000,0.0000000,0.0000000,182.0000000); //object(mtraffic4)(7)
	CreateDynamicObject(1262,244.0000000,2961.5000000,10.8000000,0.0000000,0.0000000,182.0000000); //object(mtraffic4)(8)
	CreateDynamicObject(1215,209.1000100,3031.1001000,11.8000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(2)
	CreateDynamicObject(1215,257.6000100,2963.1001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(3)
	CreateDynamicObject(1215,257.6000100,2972.3999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(4)
	CreateDynamicObject(1215,257.6000100,2993.0000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(5)
	CreateDynamicObject(1215,257.6000100,3003.3000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(6)
	CreateDynamicObject(1215,257.6000100,3013.5000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(7)
	CreateDynamicObject(1215,257.6000100,3023.8000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(8)
	CreateDynamicObject(1215,257.7000100,3034.0000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(9)
	CreateDynamicObject(1215,257.6000100,3044.3000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(10)
	CreateDynamicObject(1215,257.6000100,3054.6001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(11)
	CreateDynamicObject(1215,257.6000100,3064.8000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(12)
	CreateDynamicObject(1215,257.6000100,3075.0000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(13)
	CreateDynamicObject(1215,257.6000100,3085.3000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(14)
	CreateDynamicObject(1215,257.6000100,3095.6001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(15)
	CreateDynamicObject(1215,257.6000100,3105.8999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(16)
	CreateDynamicObject(1215,257.6000100,3116.3000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(17)
	CreateDynamicObject(1215,257.6000100,2982.6999500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(18)
	CreateDynamicObject(1215,257.6000100,3126.5000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(19)
	CreateDynamicObject(1215,257.6000100,3136.8000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(20)
	CreateDynamicObject(1215,257.6000100,3147.1001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(21)
	CreateDynamicObject(1215,257.6000100,3157.3999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(22)
	CreateDynamicObject(1215,257.6000100,3167.6999500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(23)
	CreateDynamicObject(1215,257.6000100,3178.0000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(24)
	CreateDynamicObject(1215,257.6000100,3188.3000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(25)
	CreateDynamicObject(1215,257.6000100,3198.6001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(26)
	CreateDynamicObject(1215,257.6000100,3208.8999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(27)
	CreateDynamicObject(1215,257.6000100,3219.1999500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(28)
	CreateDynamicObject(1215,257.6000100,3229.3999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(29)
	CreateDynamicObject(1215,257.7000100,3239.6999500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(30)
	CreateDynamicObject(1215,257.6000100,3250.0000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(31)
	CreateDynamicObject(1215,257.6000100,3260.3000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(32)
	CreateDynamicObject(1215,257.6000100,3270.5000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(33)
	CreateDynamicObject(1215,257.6000100,3280.8999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(34)
	CreateDynamicObject(1215,257.6000100,3291.1999500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(35)
	CreateDynamicObject(1215,257.6000100,3301.3999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(36)
	CreateDynamicObject(1215,257.6000100,3311.6999500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(37)
	CreateDynamicObject(1215,257.6000100,3322.0000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(38)
	CreateDynamicObject(1215,257.6000100,3332.3000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(39)
	CreateDynamicObject(1215,257.6000100,3342.6001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(40)
	CreateDynamicObject(1215,257.6000100,3352.8999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(41)
	CreateDynamicObject(1215,257.6000100,3363.1999500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(42)
	CreateDynamicObject(1215,257.6000100,3373.5000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(43)
	CreateDynamicObject(1215,257.6000100,3383.8999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(44)
	CreateDynamicObject(1215,257.5000000,3394.1001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(45)
	CreateDynamicObject(1215,257.6000100,3404.3000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(46)
	CreateDynamicObject(1215,257.6000100,3414.6001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(47)
	CreateDynamicObject(1215,257.6000100,3424.8000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(48)
	CreateDynamicObject(1215,257.6000100,3435.1001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(49)
	CreateDynamicObject(1215,257.6000100,3445.3999000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(50)
	CreateDynamicObject(1215,257.6000100,3455.6999500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(51)
	CreateDynamicObject(1215,257.6000100,3466.0000000,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(52)
	CreateDynamicObject(1215,257.6000100,3474.3000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(bollardlight)(53)
	CreateDynamicObject(3506,274.7000100,2966.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(1)
	CreateDynamicObject(3506,274.7999900,2977.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(2)
	CreateDynamicObject(3506,274.7000100,2971.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(3)
	CreateDynamicObject(3506,275.0000000,2983.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(4)
	CreateDynamicObject(3506,275.2000100,2989.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(5)
	CreateDynamicObject(3506,275.1000100,2995.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(6)
	CreateDynamicObject(3506,275.2999900,3001.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(7)
	CreateDynamicObject(3506,275.3999900,3006.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(8)
	CreateDynamicObject(3506,275.2000100,3013.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(9)
	CreateDynamicObject(3506,275.2000100,3019.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(10)
	CreateDynamicObject(3506,275.2000100,3026.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(11)
	CreateDynamicObject(3506,275.2999900,3033.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(12)
	CreateDynamicObject(3506,275.2999900,3039.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(13)
	CreateDynamicObject(3506,275.3999900,3044.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(14)
	CreateDynamicObject(3506,275.5000000,3051.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(15)
	CreateDynamicObject(3506,275.5000000,3057.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(16)
	CreateDynamicObject(3506,275.5000000,3062.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(17)
	CreateDynamicObject(3506,275.6000100,3068.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(18)
	CreateDynamicObject(3506,275.6000100,3075.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(19)
	CreateDynamicObject(3506,275.3999900,3081.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(20)
	CreateDynamicObject(3506,275.3999900,3087.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(21)
	CreateDynamicObject(3506,275.6000100,3093.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(22)
	CreateDynamicObject(3506,275.7000100,3100.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(23)
	CreateDynamicObject(3506,275.7999900,3107.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(24)
	CreateDynamicObject(3506,275.7999900,3114.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(25)
	CreateDynamicObject(3506,275.8999900,3120.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(26)
	CreateDynamicObject(3506,275.7999900,3127.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(27)
	CreateDynamicObject(3506,275.7000100,3133.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(28)
	CreateDynamicObject(3506,275.7999900,3141.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(29)
	CreateDynamicObject(3506,276.0000000,3148.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(30)
	CreateDynamicObject(3506,275.8999900,3155.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(31)
	CreateDynamicObject(3506,275.8999900,3162.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(32)
	CreateDynamicObject(3506,275.7999900,3169.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(33)
	CreateDynamicObject(3506,275.8999900,3175.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(34)
	CreateDynamicObject(3506,275.7000100,3182.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(35)
	CreateDynamicObject(3506,275.6000100,3188.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(36)
	CreateDynamicObject(3506,275.8999900,3193.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(37)
	CreateDynamicObject(3506,276.0000000,3199.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(38)
	CreateDynamicObject(3506,276.0000000,3206.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(39)
	CreateDynamicObject(3506,276.0000000,3211.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(40)
	CreateDynamicObject(3506,276.0000000,3218.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(41)
	CreateDynamicObject(3506,276.0000000,3224.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(42)
	CreateDynamicObject(3506,275.6000100,3231.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(43)
	CreateDynamicObject(3506,275.7000100,3236.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(44)
	CreateDynamicObject(3506,275.8999900,3243.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(45)
	CreateDynamicObject(3506,275.8999900,3251.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(46)
	CreateDynamicObject(3506,275.7999900,3258.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(47)
	CreateDynamicObject(3506,275.8999900,3265.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(48)
	CreateDynamicObject(3506,276.0000000,3272.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(49)
	CreateDynamicObject(3506,275.8999900,3279.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(50)
	CreateDynamicObject(3506,275.7999900,3286.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(51)
	CreateDynamicObject(3506,275.7000100,3293.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(52)
	CreateDynamicObject(3506,275.7000100,3300.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(53)
	CreateDynamicObject(3506,275.7999900,3308.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(54)
	CreateDynamicObject(3506,276.1000100,3314.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(55)
	CreateDynamicObject(3506,276.0000000,3321.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(56)
	CreateDynamicObject(3506,275.8999900,3328.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(57)
	CreateDynamicObject(3506,275.7000100,3335.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(58)
	CreateDynamicObject(3506,275.7999900,3342.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(59)
	CreateDynamicObject(3506,275.7999900,3349.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(60)
	CreateDynamicObject(3506,275.8999900,3356.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(61)
	CreateDynamicObject(3506,275.7000100,3363.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(62)
	CreateDynamicObject(3506,275.7999900,3370.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(63)
	CreateDynamicObject(3506,275.7999900,3376.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(64)
	CreateDynamicObject(3506,275.7999900,3383.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(65)
	CreateDynamicObject(3506,276.1000100,3391.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(66)
	CreateDynamicObject(3506,276.0000000,3398.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(67)
	CreateDynamicObject(3506,276.0000000,3405.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(68)
	CreateDynamicObject(3506,275.8999900,3413.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(69)
	CreateDynamicObject(3506,275.7000100,3421.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(70)
	CreateDynamicObject(3506,275.7999900,3429.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(71)
	CreateDynamicObject(3506,275.7999900,3436.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(72)
	CreateDynamicObject(3506,275.7999900,3444.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(73)
	CreateDynamicObject(3506,275.8999900,3450.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(74)
	CreateDynamicObject(3506,275.7000100,3456.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(75)
	CreateDynamicObject(3506,275.7999900,3464.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(76)
	CreateDynamicObject(3506,276.0000000,3471.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(77)
	CreateDynamicObject(3506,276.0000000,3478.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(78)
	CreateDynamicObject(3506,275.8999900,3486.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(79)
	CreateDynamicObject(3506,275.8999900,3494.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(80)
	CreateDynamicObject(3506,275.8999900,3502.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(81)
	CreateDynamicObject(3506,275.8999900,3509.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(82)
	CreateDynamicObject(3506,269.7000100,3510.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(83)
	CreateDynamicObject(3506,263.2000100,3510.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(84)
	CreateDynamicObject(3506,256.2999900,3510.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(85)
	CreateDynamicObject(3506,248.8999900,3510.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(86)
	CreateDynamicObject(3506,239.3999900,3511.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(87)
	CreateDynamicObject(3506,239.2000000,3505.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(88)
	CreateDynamicObject(3506,239.1000100,3499.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(89)
	CreateDynamicObject(3506,238.8999900,3493.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(90)
	CreateDynamicObject(3506,239.0000000,3486.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(91)
	CreateDynamicObject(3506,238.8999900,3479.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(92)
	CreateDynamicObject(3506,238.8000000,3472.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(93)
	CreateDynamicObject(3506,239.0000000,3466.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(94)
	CreateDynamicObject(3506,239.0000000,3459.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(95)
	CreateDynamicObject(3506,239.1000100,3452.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(96)
	CreateDynamicObject(3506,239.1000100,3444.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(97)
	CreateDynamicObject(3506,239.3000000,3437.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(98)
	CreateDynamicObject(3506,239.2000000,3430.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(99)
	CreateDynamicObject(3506,239.1000100,3424.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(100)
	CreateDynamicObject(3506,239.3000000,3418.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(101)
	CreateDynamicObject(3506,239.5000000,3413.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(102)
	CreateDynamicObject(3506,239.5000000,3406.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(103)
	CreateDynamicObject(3506,239.5000000,3400.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(104)
	CreateDynamicObject(3506,239.6000100,3394.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(105)
	CreateDynamicObject(3506,239.5000000,3387.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(106)
	CreateDynamicObject(3506,239.6000100,3380.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(107)
	CreateDynamicObject(3506,239.2000000,3374.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(108)
	CreateDynamicObject(3506,239.2000000,3366.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(109)
	CreateDynamicObject(3506,239.3000000,3359.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(110)
	CreateDynamicObject(3506,239.2000000,3351.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(111)
	CreateDynamicObject(3506,239.2000000,3344.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(112)
	CreateDynamicObject(3506,239.1000100,3336.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(113)
	CreateDynamicObject(3506,239.0000000,3327.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(114)
	CreateDynamicObject(3506,239.1000100,3320.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(115)
	CreateDynamicObject(3506,239.3000000,3313.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(116)
	CreateDynamicObject(3506,239.1000100,3305.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(117)
	CreateDynamicObject(3506,239.1000100,3298.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(118)
	CreateDynamicObject(3506,239.3000000,3291.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(119)
	CreateDynamicObject(3506,239.2000000,3285.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(120)
	CreateDynamicObject(3506,239.1000100,3279.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(121)
	CreateDynamicObject(3506,239.3000000,3273.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(122)
	CreateDynamicObject(3506,239.5000000,3267.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(123)
	CreateDynamicObject(3506,239.5000000,3260.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(124)
	CreateDynamicObject(3506,239.3000000,3254.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(125)
	CreateDynamicObject(3506,239.3000000,3248.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(126)
	CreateDynamicObject(3506,239.2000000,3242.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(127)
	CreateDynamicObject(3506,238.8999900,3236.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(128)
	CreateDynamicObject(3506,238.8000000,3229.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(129)
	CreateDynamicObject(3506,238.8000000,3222.3000500,7.3000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(130)
	CreateDynamicObject(3506,239.2000000,3216.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(131)
	CreateDynamicObject(3506,239.1000100,3209.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(132)
	CreateDynamicObject(3506,239.1000100,3202.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(134)
	CreateDynamicObject(3506,239.1000100,3194.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(133)
	CreateDynamicObject(3506,239.0000000,3186.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(135)
	CreateDynamicObject(3506,239.0000000,3178.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(136)
	CreateDynamicObject(3506,239.0000000,3169.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(137)
	CreateDynamicObject(3506,239.1000100,3161.1001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(138)
	CreateDynamicObject(3506,238.8999900,3154.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(139)
	CreateDynamicObject(3506,238.8999900,3145.6999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(140)
	CreateDynamicObject(3506,239.0000000,3137.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(141)
	CreateDynamicObject(3506,238.8000000,3128.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(142)
	CreateDynamicObject(3506,238.8000000,3119.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(143)
	CreateDynamicObject(3506,238.8999900,3111.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(144)
	CreateDynamicObject(3506,239.0000000,3102.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(145)
	CreateDynamicObject(3506,239.0000000,3095.0000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(146)
	CreateDynamicObject(3506,239.1000100,3085.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(147)
	CreateDynamicObject(3506,239.2000000,3075.3000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(148)
	CreateDynamicObject(3506,239.0000000,3065.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(149)
	CreateDynamicObject(3506,239.1000100,3055.3999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(150)
	CreateDynamicObject(3506,239.2000000,3046.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(151)
	CreateDynamicObject(3506,238.8999900,3038.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(152)
	CreateDynamicObject(3506,238.8000000,3029.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(153)
	CreateDynamicObject(3506,239.1000100,3019.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(154)
	CreateDynamicObject(3506,239.1000100,3011.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(155)
	CreateDynamicObject(3506,239.3999900,3003.8999000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(156)
	CreateDynamicObject(3506,239.0000000,2995.8000500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(157)
	CreateDynamicObject(3506,238.8000000,2987.6999500,7.2000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(158)
	CreateDynamicObject(3506,239.0000000,2979.5000000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(159)
	CreateDynamicObject(3506,238.8999900,2969.6001000,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(160)
	CreateDynamicObject(3506,239.1000100,2963.1999500,7.1000000,0.0000000,0.0000000,0.0000000); //object(vgsn_nitree_y02)(161)
	// DM 1
	CreateDynamicObject(19340,69.1350021,-243.1199951,2414.6750488,0.0000000,0.0000000,0.0000000); //object(cslab01)(1)
	CreateDynamicObject(16118,81.0709991,-237.9869995,2417.4250488,0.0000000,0.0000000,180.0000000); //object(des_rockgp2_05)(1)
	CreateDynamicObject(16118,83.4380035,-196.3459930,2417.1750488,0.0000000,0.0000000,179.9000000); //object(des_rockgp2_05)(2)
	CreateDynamicObject(16118,83.2939987,-158.4019928,2417.6750488,0.0000000,0.0000000,179.9000000); //object(des_rockgp2_05)(3)
	CreateDynamicObject(16118,75.3649979,-279.9060059,2416.9179688,0.0000000,0.0000000,179.9000000); //object(des_rockgp2_05)(4)
	CreateDynamicObject(16118,74.5469971,-319.4270020,2417.1679688,0.0000000,0.0000000,179.9000000); //object(des_rockgp2_05)(5)
	CreateDynamicObject(16118,46.0079994,-329.9209900,2416.9179688,0.0000000,0.0000000,85.9900000); //object(des_rockgp2_05)(6)
	CreateDynamicObject(16118,24.7129993,-304.6940002,2417.1750488,0.0000000,0.0000000,355.9000000); //object(des_rockgp2_05)(7)
	CreateDynamicObject(16118,24.8610001,-260.5119934,2416.9250488,0.0000000,0.0000000,355.9000000); //object(des_rockgp2_05)(8)
	CreateDynamicObject(16118,25.5750008,-219.9089966,2417.1750488,0.0000000,0.0000000,355.9000000); //object(des_rockgp2_05)(9)
	CreateDynamicObject(16118,26.9650002,-179.8549957,2416.9250488,0.0000000,0.0000000,355.9000000); //object(des_rockgp2_05)(10)
	CreateDynamicObject(19377,71.6930008,-156.4140015,2423.6760254,0.0000000,0.0000000,270.0000000); //object(wall025)(1)
	CreateDynamicObject(19377,62.0880013,-156.4109955,2423.6760254,0.0000000,0.0000000,270.0000000); //object(wall025)(2)
	CreateDynamicObject(19377,52.4620018,-156.4089966,2423.6760254,0.0000000,0.0000000,270.0000000); //object(wall025)(3)
	CreateDynamicObject(19377,42.8400002,-156.4190063,2423.6760254,0.0000000,0.0000000,270.0000000); //object(wall025)(4)
	CreateDynamicObject(19377,34.8790016,-156.3950043,2423.6760254,0.0000000,0.0000000,270.0000000); //object(wall025)(5)
	CreateDynamicObject(19355,36.6269989,-158.0319977,2420.1750488,0.0000000,0.0000000,0.0000000); //object(wall003)(2)
	CreateDynamicObject(19355,36.6469994,-161.2359924,2420.1750488,0.0000000,0.0000000,0.0000000); //object(wall003)(3)
	CreateDynamicObject(19355,36.6440010,-164.4440002,2420.1750488,0.0000000,0.0000000,0.0000000); //object(wall003)(4)
	CreateDynamicObject(19376,36.8120003,-158.5220032,2421.9260254,0.0000000,90.0000000,0.0000000); //object(wall024)(1)
	CreateDynamicObject(19376,47.1349983,-161.2590027,2421.9260254,0.0000000,90.0000000,0.0000000); //object(wall024)(2)
	CreateDynamicObject(19376,57.6160011,-161.2449951,2421.9260254,0.0000000,90.0000000,0.0000000); //object(wall024)(3)
	CreateDynamicObject(19376,68.0729980,-161.2480011,2421.9260254,0.0000000,90.0000000,0.0000000); //object(wall024)(4)
	CreateDynamicObject(19376,78.1869965,-161.2330017,2421.9260254,0.0000000,90.0000000,0.0000000); //object(wall024)(5)
	CreateDynamicObject(19355,74.3470001,-158.0460052,2420.1750488,0.0000000,0.0000000,0.0000000); //object(wall003)(6)
	CreateDynamicObject(19355,74.3809967,-161.2310028,2420.1750488,0.0000000,0.0000000,0.0000000); //object(wall003)(7)
	CreateDynamicObject(19355,74.4079971,-164.4140015,2420.1750488,0.0000000,0.0000000,0.0000000); //object(wall003)(8)
	CreateDynamicObject(14877,39.0940018,-164.6410065,2419.7438965,0.0000000,0.0000000,180.0000000); //object(michelle-stairs)(1)
	CreateDynamicObject(19355,38.1549988,-166.0549927,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(9)
	CreateDynamicObject(19355,41.3289986,-166.0619965,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(10)
	CreateDynamicObject(19355,44.5449982,-166.0769958,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(11)
	CreateDynamicObject(19355,35.4119987,-166.0540009,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(12)
	CreateDynamicObject(19355,38.2010002,-163.0939941,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(13)
	CreateDynamicObject(19355,41.3330002,-163.0769958,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(14)
	CreateDynamicObject(19355,44.5159988,-163.0720062,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(15)
	CreateDynamicObject(19355,47.7589989,-166.0679932,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(16)
	CreateDynamicObject(19385,73.3300018,-165.9920044,2420.1750488,0.0000000,0.0000000,90.0000000); //object(wall033)(1)
	CreateDynamicObject(19401,50.9440002,-166.0599976,2420.1750488,0.0000000,0.0000000,90.0000000); //object(wall049)(1)
	CreateDynamicObject(19355,54.1440010,-166.0509949,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(17)
	CreateDynamicObject(19401,57.3300018,-166.0599976,2420.1750488,0.0000000,0.0000000,90.0000000); //object(wall049)(2)
	CreateDynamicObject(19355,60.5279999,-166.0269928,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(18)
	CreateDynamicObject(19355,63.7280006,-166.0180054,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(19)
	CreateDynamicObject(19355,66.9349976,-165.9929962,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(20)
	CreateDynamicObject(19355,70.1289978,-165.9869995,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(21)
	CreateDynamicObject(19355,75.5569992,-165.9949951,2420.1750488,0.0000000,0.0000000,270.0000000); //object(wall003)(22)
	CreateDynamicObject(19355,36.6389999,-164.3609924,2423.6750488,0.0000000,0.0000000,0.0000000); //object(wall003)(23)
	CreateDynamicObject(19355,36.6320000,-161.1600037,2423.6750488,0.0000000,0.0000000,0.0000000); //object(wall003)(24)
	CreateDynamicObject(19355,36.6409988,-157.9640045,2423.6750488,0.0000000,0.0000000,0.0000000); //object(wall003)(25)
	CreateDynamicObject(19355,38.1529999,-166.0599976,2423.6750488,0.0000000,0.0000000,270.0000000); //object(wall003)(26)
	CreateDynamicObject(19355,41.3499985,-166.0740051,2423.6750488,0.0000000,0.0000000,270.0000000); //object(wall003)(28)
	CreateDynamicObject(3499,43.8730011,-167.8820038,2416.4169922,0.0000000,0.0000000,0.0000000); //object(wdpillar02_lvs)(1)
	CreateDynamicObject(19447,47.8419991,-167.9069977,2421.9250488,0.0000000,90.0000000,89.9000000); //object(wall087)(2)
	CreateDynamicObject(19447,57.2039986,-167.9069977,2421.9250488,0.0000000,90.0000000,90.0000000); //object(wall087)(3)
	CreateDynamicObject(19401,44.5559998,-166.0809937,2423.6750488,0.0000000,0.0000000,90.0000000); //object(wall049)(3)
	CreateDynamicObject(19355,47.7719994,-166.0820007,2423.6750488,0.0000000,0.0000000,270.0000000); //object(wall003)(30)
	CreateDynamicObject(19385,50.9650002,-166.0800018,2423.6750488,0.0000000,0.0000000,90.0000000); //object(wall033)(2)
	CreateDynamicObject(19355,54.1739998,-166.0740051,2423.6750488,0.0000000,0.0000000,270.0000000); //object(wall003)(31)
	CreateDynamicObject(19401,57.3520012,-166.0650024,2423.6750488,0.0000000,0.0000000,90.0000000); //object(wall049)(4)
	CreateDynamicObject(19355,60.5349998,-166.0679932,2423.6750488,0.0000000,0.0000000,270.0000000); //object(wall003)(32)
	CreateDynamicObject(19355,63.6739998,-166.0709991,2423.6750488,0.0000000,0.0000000,270.0000000); //object(wall003)(33)
	CreateDynamicObject(19355,66.8420029,-166.0679932,2423.6750488,0.0000000,0.0000000,270.0000000); //object(wall003)(34)
	CreateDynamicObject(19401,70.0419998,-166.0659943,2423.6750488,0.0000000,0.0000000,90.0000000); //object(wall049)(5)
	CreateDynamicObject(19355,73.2470016,-166.0639954,2423.6750488,0.0000000,0.0000000,270.0000000); //object(wall003)(35)
	CreateDynamicObject(19355,73.9700012,-164.4299927,2423.7619629,0.0000000,0.0000000,0.0000000); //object(wall003)(36)
	CreateDynamicObject(19355,73.9530029,-161.2160034,2423.7619629,0.0000000,0.0000000,0.0000000); //object(wall003)(37)
	CreateDynamicObject(19355,73.9599991,-158.0520020,2423.7619629,0.0000000,0.0000000,0.0000000); //object(wall003)(38)
	CreateDynamicObject(997,61.9570007,-169.4730072,2422.0109863,0.0000000,0.0000000,90.0000000); //object(lhouse_barrier3)(1)
	CreateDynamicObject(997,58.7849998,-169.4230042,2422.0109863,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier3)(2)
	CreateDynamicObject(997,55.6910019,-169.4329987,2422.0109863,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier3)(3)
	CreateDynamicObject(997,52.5929985,-169.4199982,2422.0109863,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier3)(4)
	CreateDynamicObject(997,49.4910011,-169.4170074,2422.0109863,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier3)(5)
	CreateDynamicObject(997,46.3870010,-169.4299927,2422.0109863,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier3)(6)
	CreateDynamicObject(997,43.2799988,-169.4219971,2422.0109863,0.0000000,0.0000000,0.0000000); //object(lhouse_barrier3)(7)
	CreateDynamicObject(997,43.1489983,-169.4949951,2422.0109863,0.0000000,0.0000000,90.0000000); //object(lhouse_barrier3)(8)
	CreateDynamicObject(3499,61.3149986,-168.7290039,2416.4169922,0.0000000,0.0000000,0.0000000); //object(wdpillar02_lvs)(2)
	CreateDynamicObject(3499,52.4500008,-168.6230011,2416.4169922,0.0000000,0.0000000,0.0000000); //object(wdpillar02_lvs)(3)
	CreateDynamicObject(16118,29.2919998,-307.8800049,2428.6818848,0.0000000,90.0000000,355.0000000); //object(des_rockgp2_05)(11)
	CreateDynamicObject(19465,39.1669998,-318.6950073,2420.9699707,0.0000000,0.0000000,0.0000000); //object(wall105)(1)
	CreateDynamicObject(19464,39.1669998,-312.8020020,2420.9699707,0.0000000,0.0000000,0.0000000); //object(wall104)(1)
	CreateDynamicObject(19464,39.1920013,-306.9179993,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(2)
	CreateDynamicObject(19464,39.1920013,-301.0020142,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(3)
	CreateDynamicObject(19464,39.1889992,-295.0969849,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(4)
	CreateDynamicObject(19464,39.1800003,-289.2170105,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(5)
	CreateDynamicObject(19464,39.1809998,-283.3410034,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(6)
	CreateDynamicObject(19464,39.1990013,-277.4880066,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(7)
	CreateDynamicObject(19464,39.2099991,-271.5710144,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(8)
	CreateDynamicObject(19464,39.2120018,-265.7049866,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(9)
	CreateDynamicObject(19464,39.2050018,-259.7820129,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(10)
	CreateDynamicObject(19465,39.2200012,-253.8670044,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall105)(2)
	CreateDynamicObject(19464,39.2159996,-247.9600067,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(11)
	CreateDynamicObject(19464,39.2290001,-242.0659943,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(12)
	CreateDynamicObject(19464,39.2309990,-236.1250000,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(13)
	CreateDynamicObject(19464,39.2389984,-230.2169952,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(14)
	CreateDynamicObject(19464,39.2389984,-224.3059998,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(15)
	CreateDynamicObject(19464,39.2350006,-218.4120026,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(16)
	CreateDynamicObject(19464,39.2330017,-212.5290070,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(17)
	CreateDynamicObject(19464,39.2290001,-206.5919952,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(18)
	CreateDynamicObject(19464,39.2369995,-200.6649933,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(19)
	CreateDynamicObject(19464,39.2249985,-194.7369995,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(20)
	CreateDynamicObject(19464,39.2270012,-188.8150024,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(21)
	CreateDynamicObject(19464,39.2210007,-182.9219971,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall104)(22)
	CreateDynamicObject(19465,39.2210007,-177.0480042,2420.9770508,0.0000000,0.0000000,0.0000000); //object(wall105)(3)
	CreateDynamicObject(19464,36.3989983,-174.0140076,2420.9770508,0.0000000,0.0000000,90.0000000); //object(wall104)(26)
	CreateDynamicObject(16118,29.2919998,-263.9559937,2428.6818848,0.0000000,90.0000000,355.0000000); //object(des_rockgp2_05)(12)
	CreateDynamicObject(16118,29.2919998,-219.2209930,2428.6818848,0.0000000,90.0000000,355.0000000); //object(des_rockgp2_05)(13)
	CreateDynamicObject(16118,30.2810001,-198.2460022,2428.6818848,0.0000000,90.0000000,355.0000000); //object(des_rockgp2_05)(14)
	CreateDynamicObject(19378,39.2939987,-161.2319946,2425.5129395,0.0000000,90.0000000,0.0000000); //object(wall026)(1)
	CreateDynamicObject(19378,49.4739990,-161.2319946,2425.5129395,0.0000000,90.0000000,0.0000000); //object(wall026)(2)
	CreateDynamicObject(19378,59.9770012,-161.2319946,2425.5129395,0.0000000,90.0000000,0.0000000); //object(wall026)(3)
	CreateDynamicObject(19378,70.2279968,-161.2319946,2425.5129395,0.0000000,90.0000000,0.0000000); //object(wall026)(4)
	CreateDynamicObject(3095,43.5279999,-302.0899963,2418.4250488,0.0000000,90.0000000,90.0000000); //object(a51_jetdoor)(1)
	CreateDynamicObject(3095,52.4939995,-302.0899963,2418.4179688,0.0000000,90.0000000,89.9000000); //object(a51_jetdoor)(2)
	CreateDynamicObject(3095,64.2610016,-302.0899963,2418.4179688,0.0000000,90.0000000,90.0000000); //object(a51_jetdoor)(3)
	CreateDynamicObject(12839,63.2400017,-302.5559998,2420.1379395,0.0000000,0.0000000,90.0000000); //object(cos_sbanksteps02)(1)
	CreateDynamicObject(11441,64.9840012,-269.0780029,2418.4250488,0.0000000,0.0000000,0.0000000); //object(des_pueblo5)(1)
	CreateDynamicObject(11442,51.8339996,-210.5030060,2418.4250488,0.0000000,0.0000000,0.0000000); //object(des_pueblo3)(1)
	CreateDynamicObject(19355,50.2789993,-211.7879944,2421.6750488,0.0000000,90.0000000,270.0000000); //object(wall003)(40)
	CreateDynamicObject(11444,49.5849991,-176.6679993,2418.4250488,0.0000000,0.0000000,0.0000000); //object(des_pueblo2)(1)
	CreateDynamicObject(944,33.5750008,-185.7079926,2419.3100586,0.0000000,0.0000000,0.0000000); //object(packing_carates04)(1)
	CreateDynamicObject(944,37.6580009,-219.4360046,2419.3100586,0.0000000,0.0000000,0.0000000); //object(packing_carates04)(2)
	CreateDynamicObject(944,37.5670013,-276.2799988,2419.3100586,0.0000000,0.0000000,0.0000000); //object(packing_carates04)(3)
	CreateDynamicObject(944,37.5929985,-302.1480103,2419.3100586,0.0000000,0.0000000,0.0000000); //object(packing_carates04)(4)
	CreateDynamicObject(923,50.7229996,-265.3500061,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(1)
	CreateDynamicObject(923,62.2779999,-254.5229950,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(2)
	CreateDynamicObject(923,49.9529991,-241.1809998,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(3)
	CreateDynamicObject(923,70.6119995,-235.7089996,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(4)
	CreateDynamicObject(923,59.4539986,-231.1080017,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(5)
	CreateDynamicObject(923,70.5869980,-220.6779938,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(6)
	CreateDynamicObject(923,58.6110001,-209.8309937,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(7)
	CreateDynamicObject(923,73.6259995,-198.6580048,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(8)
	CreateDynamicObject(923,50.0019989,-192.3439941,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(9)
	CreateDynamicObject(923,67.5100021,-180.6719971,2419.3049316,0.0000000,0.0000000,0.0000000); //object(packing_carates2)(10)
	CreateDynamicObject(3567,49.8260002,-279.5239868,2419.3039551,0.0000000,0.0000000,0.0000000); //object(lasnfltrail)(1)
	CreateDynamicObject(3134,50.9720001,-271.4989929,2420.6779785,0.0000000,0.0000000,0.0000000); //object(quarry_barrel)(1)
	CreateDynamicObject(2669,41.9440002,-253.8630066,2419.7661133,0.0000000,0.0000000,270.0000000); //object(cj_chris_crate)(1)
	CreateDynamicObject(944,37.6660004,-252.3560028,2419.3100586,0.0000000,0.0000000,0.0000000); //object(packing_carates04)(5)
	CreateDynamicObject(1685,42.1669998,-253.3399963,2419.2990723,0.0000000,0.0000000,0.0000000); //object(blockpallet)(1)
	CreateDynamicObject(8885,52.3240013,-295.8389893,2421.8459473,0.0000000,0.0000000,0.0000000); //object(vgsefrght03)(1)
	CreateDynamicObject(835,70.2689972,-213.2449951,2421.3310547,0.0000000,0.0000000,0.0000000); //object(dead_tree_8)(1)
	CreateDynamicObject(3171,51.3720016,-231.7940063,2418.4250488,0.0000000,0.0000000,0.0000000); //object(trailer5_01)(1)
	CreateDynamicObject(3242,66.6729965,-227.4349976,2420.3610840,0.0000000,0.0000000,0.0000000); //object(conhoos1)(1)
	CreateDynamicObject(3253,71.6930008,-186.9660034,2418.4250488,0.0000000,0.0000000,0.0000000); //object(des_westrn11_)(1)
	CreateDynamicObject(1717,38.3670006,-158.0249939,2418.4250488,0.0000000,0.0000000,0.0000000); //object(telly_low_test)(1)
	CreateDynamicObject(2302,42.5989990,-159.5720062,2418.4250488,0.0000000,0.0000000,180.0000000); //object(low_bed_06)(1)
	CreateDynamicObject(2206,47.4659996,-157.0279999,2418.4250488,0.0000000,0.0000000,0.0000000); //object(med_office8_desk_02)(1)
	CreateDynamicObject(2206,47.4679985,-157.9550018,2418.4250488,0.0000000,0.0000000,0.0000000); //object(med_office8_desk_02)(2)
	CreateDynamicObject(2206,50.2910004,-157.0269928,2418.4250488,0.0000000,0.0000000,0.0000000); //object(med_office8_desk_02)(3)
	CreateDynamicObject(2206,50.3009987,-157.9499969,2418.4250488,0.0000000,0.0000000,0.0000000); //object(med_office8_desk_02)(4)
	CreateDynamicObject(2206,53.1419983,-157.0229950,2418.4250488,0.0000000,0.0000000,0.0000000); //object(med_office8_desk_02)(5)
	CreateDynamicObject(2206,53.1380005,-157.9450073,2418.4250488,0.0000000,0.0000000,0.0000000); //object(med_office8_desk_02)(6)
	CreateDynamicObject(2206,55.9669991,-157.0200043,2418.4250488,0.0000000,0.0000000,0.0000000); //object(med_office8_desk_02)(7)
	CreateDynamicObject(2206,55.9620018,-157.9459991,2418.4250488,0.0000000,0.0000000,0.0000000); //object(med_office8_desk_02)(8)
	CreateDynamicObject(1706,47.6930008,-156.9349976,2422.0119629,0.0000000,0.0000000,0.0000000); //object(kb_couch03)(1)
	CreateDynamicObject(936,56.4650002,-157.0110016,2422.4870605,0.0000000,0.0000000,0.0000000); //object(cj_df_worktop_2)(1)
	CreateDynamicObject(941,54.1059990,-156.9839935,2422.4870605,0.0000000,0.0000000,0.0000000); //object(cj_df_worktop_3)(1)
	CreateDynamicObject(1743,63.3339996,-157.9320068,2422.0119629,0.0000000,0.0000000,0.0000000); //object(med_cabinet_3)(1)
	CreateDynamicObject(1758,71.7829971,-157.2059937,2422.0119629,0.0000000,0.0000000,0.0000000); //object(low_single_4)(1)
	CreateDynamicObject(1819,71.0120010,-165.4889984,2418.4250488,0.0000000,0.0000000,0.0000000); //object(coffee_swank_4)(1)
	CreateDynamicObject(19401,75.4179993,-166.0460052,2423.6750488,0.0000000,0.0000000,90.0000000); //object(wall049)(6)
	CreateDynamicObject(19401,35.1100006,-166.0599976,2423.6750488,0.0000000,0.0000000,90.0000000); //object(wall049)(7)
	// Бистро
	CreateDynamicObject(19462,-1215.6892100,1837.1377000,40.6777000,0.0000000,90.0000000,316.4306900); //
	CreateDynamicObject(19462,-1222.3161600,1830.1678500,40.6777000,0.0000000,90.0000000,316.4306900); //
	CreateDynamicObject(19462,-1213.1449000,1834.7302200,40.6777000,0.0000000,90.0000000,316.4306900); //
	CreateDynamicObject(19462,-1219.7807600,1827.7568400,40.6777000,0.0000000,90.0000000,316.4306900); //
	CreateDynamicObject(19462,-1214.7502400,1822.9492200,40.6777000,0.0000000,90.0000000,316.4306900); //
	CreateDynamicObject(19372,-1226.1341600,1826.1151100,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(870,-1222.7179000,1822.5189200,40.9724000,0.0000000,0.0000000,253.6475100); //
	CreateDynamicObject(19372,-1206.5144000,1827.7296100,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(870,-1220.4256600,1820.2895500,40.9724000,0.0000000,0.0000000,253.6475100); //
	CreateDynamicObject(19325,-1206.2678200,1834.8109100,46.2606000,0.0000000,0.0000000,46.4415300); //
	CreateDynamicObject(19397,-1209.0028100,1826.5471200,42.4683000,0.0000000,0.0000000,316.6557900); //
	CreateDynamicObject(19325,-1214.5101300,1820.6557600,42.1660000,0.0000000,0.0000000,316.3822900); //
	CreateDynamicObject(19442,-1226.2724600,1827.3931900,42.4479000,0.0000000,0.0000000,46.1684000); //
	CreateDynamicObject(19442,-1216.2113000,1818.9947500,42.4479000,0.0000000,0.0000000,136.3185100); //
	CreateDynamicObject(19325,-1211.0800800,1839.3792700,46.2584000,0.0000000,0.0000000,46.5334000); //
	CreateDynamicObject(1523,-1208.4390900,1827.1092500,40.6983000,0.0000000,0.0000000,226.5170000); //
	CreateDynamicObject(1523,-1212.3883100,1831.8142100,40.6983000,0.0000000,0.0000000,316.5638100); //
	CreateDynamicObject(19325,-1216.0054900,1839.3507100,46.2498000,0.0000000,0.0000000,316.6836900); //
	CreateDynamicObject(19461,-1216.9646000,1838.2214400,42.4302000,0.0000000,0.0000000,136.3132900); //
	CreateDynamicObject(19442,-1213.1185300,1841.2597700,45.9456000,0.0000000,0.0000000,46.1684000); //
	CreateDynamicObject(14416,-1217.0174600,1831.9892600,40.9600000,0.0000000,0.0000000,46.5146000); //
	CreateDynamicObject(19462,-1217.2500000,1825.3482700,40.6777000,0.0000000,90.0000000,316.4306900); //
	CreateDynamicObject(19462,-1210.6198700,1832.3316700,40.6777000,0.0000000,90.0000000,316.4306900); //
	CreateDynamicObject(19369,-1222.8614500,1832.0918000,45.9218000,0.0000000,0.0000000,316.5083900); //
	CreateDynamicObject(19442,-1204.1394000,1832.6866500,45.9517000,0.0000000,0.0000000,46.1684000); //
	CreateDynamicObject(19450,-1218.0931400,1830.1158400,42.4539000,0.0000000,0.0000000,226.3808000); //
	CreateDynamicObject(19450,-1223.2590300,1824.5587200,42.4539000,0.0000000,0.0000000,46.4045000); //
	CreateDynamicObject(19450,-1223.4334700,1831.3252000,42.4539000,0.0000000,0.0000000,315.7466100); //
	CreateDynamicObject(19358,-1215.1572300,1833.0207500,42.4559000,0.0000000,0.0000000,46.9453000); //
	CreateDynamicObject(1843,-1224.5562700,1829.2939500,40.7632000,0.0000000,0.0000000,46.0264000); //
	CreateDynamicObject(1844,-1222.4711900,1831.4316400,40.7639000,0.0000000,0.0000000,45.4383000); //
	CreateDynamicObject(1890,-1219.8658400,1827.0784900,40.7637000,0.0000000,0.0000000,316.4346000); //
	CreateDynamicObject(1887,-1224.5654300,1826.5014600,40.7638300,0.0000000,0.0000000,135.8071100); //
	CreateDynamicObject(1984,-1217.6872600,1821.3718300,40.7643400,0.0000000,0.0000000,316.4679600); //
	CreateDynamicObject(1988,-1222.9744900,1825.1054700,40.7760000,0.0000000,0.0000000,136.9306000); //
	CreateDynamicObject(1987,-1220.9086900,1823.1235400,40.7686000,0.0000000,0.0000000,136.6941100); //
	CreateDynamicObject(1983,-1221.5523700,1823.7652600,40.7625000,0.0000000,0.0000000,136.6727000); //
	CreateDynamicObject(1987,-1222.2923600,1824.4427500,40.7686000,0.0000000,0.0000000,136.6941100); //
	CreateDynamicObject(2491,-1217.3405800,1824.1395300,40.7653100,0.0000000,0.0000000,45.8682400); //
	CreateDynamicObject(2492,-1218.1767600,1824.5708000,41.7543000,0.0000000,0.0000000,47.2875700); //
	CreateDynamicObject(2493,-1218.1672400,1824.9325000,41.7551000,0.0000000,0.0000000,135.8780100); //
	CreateDynamicObject(2494,-1218.5148900,1824.5511500,41.7877000,0.0000000,0.0000000,316.2890000); //
	CreateDynamicObject(2496,-1218.4945100,1824.8874500,41.7838000,0.0000000,0.0000000,52.0656000); //
	CreateDynamicObject(2582,-1215.4002700,1827.0876500,41.6269000,0.0000000,0.0000000,315.7207900); //
	CreateDynamicObject(2581,-1216.7877200,1828.3370400,41.2750300,0.0000000,0.0000000,316.3444200); //
	CreateDynamicObject(2871,-1219.5572500,1830.5844700,40.7517000,0.0000000,0.0000000,317.2145100); //
	CreateDynamicObject(2871,-1218.1243900,1829.2619600,40.7517000,0.0000000,0.0000000,317.2145100); //
	CreateDynamicObject(2871,-1218.8481400,1829.9137000,40.7517000,0.0000000,0.0000000,317.2145100); //
	CreateDynamicObject(2584,-1220.2843000,1822.4129600,41.5784000,0.0000000,0.0000000,317.2112100); //
	CreateDynamicObject(2543,-1220.2242400,1831.3338600,40.7903000,0.0000000,0.0000000,316.3103900); //
	CreateDynamicObject(2412,-1214.7963900,1822.6518600,40.7649000,0.0000000,0.0000000,316.8129000); //
	CreateDynamicObject(2412,-1213.5585900,1821.4825400,40.7649000,0.0000000,0.0000000,317.2395900); //
	CreateDynamicObject(1885,-1218.2923600,1821.8654800,40.7649000,0.0000000,0.0000000,226.4422000); //
	CreateDynamicObject(1885,-1215.1877400,1825.9278600,40.7649000,0.0000000,0.0000000,317.4190100); //
	CreateDynamicObject(2847,-1215.2955300,1822.1356200,40.7656000,0.0000000,0.0000000,316.5138900); //
	CreateDynamicObject(19388,-1211.7541500,1831.3271500,42.4935000,0.0000000,0.0000000,47.3627000); //
	CreateDynamicObject(1649,-1209.5022000,1829.2873500,42.3988000,0.0000000,0.0000000,135.1998400); //
	CreateDynamicObject(19358,-1218.6508800,1820.1954300,42.4559000,0.0000000,0.0000000,46.9453000); //
	CreateDynamicObject(19358,-1217.4921900,1835.2163100,42.4559000,0.0000000,0.0000000,46.9453000); //
	CreateDynamicObject(19358,-1214.5961900,1832.4928000,42.4559000,0.0000000,0.0000000,46.9453000); //
	CreateDynamicObject(19431,-1213.6983600,1832.4835200,42.4721000,0.0000000,0.0000000,86.2105900); //
	CreateDynamicObject(2010,-1213.1577100,1831.8819600,40.7645000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(19445,-1216.9834000,1838.1335400,42.4632000,0.0000000,0.0000000,316.1594800); //
	CreateDynamicObject(19353,-1215.6217000,1833.5821500,42.4786000,0.0000000,0.0000000,46.6445000); //
	CreateDynamicObject(19353,-1217.4211400,1835.2801500,42.4786000,0.0000000,0.0000000,46.6445000); //
	CreateDynamicObject(19426,-1213.1335400,1841.1916500,42.4459000,0.0000000,0.0000000,46.6657000); //
	CreateDynamicObject(19383,-1211.7459700,1831.3626700,42.4924000,0.0000000,0.0000000,47.2108000); //
	CreateDynamicObject(19426,-1213.6910400,1832.5108600,42.4789000,0.0000000,0.0000000,86.1235000); //
	CreateDynamicObject(19426,-1204.1761500,1832.6700400,42.4129000,0.0000000,0.0000000,45.4342000); //
	CreateDynamicObject(2446,-1212.7037400,1838.0426000,40.7630000,0.0000000,0.0000000,226.5532100); //
	CreateDynamicObject(2446,-1213.3791500,1837.3170200,40.7630000,0.0000000,0.0000000,226.6573000); //
	CreateDynamicObject(2448,-1215.1628400,1835.6549100,40.6991000,0.0000000,0.0000000,46.6504000); //
	CreateDynamicObject(1514,-1213.0531000,1837.8786600,42.0394000,0.0000000,0.0000000,46.1955000); //
	CreateDynamicObject(2422,-1212.6300000,1838.6283000,41.7717000,0.0000000,0.0000000,46.6112000); //
	CreateDynamicObject(2131,-1217.7210700,1836.6732200,40.7318000,0.0000000,0.0000000,46.4866000); //
	CreateDynamicObject(2132,-1216.2740500,1838.1423300,40.7640000,0.0000000,0.0000000,46.5525000); //
	CreateDynamicObject(2133,-1214.9685100,1839.6202400,40.6981000,0.0000000,0.0000000,47.0112000); //
	CreateDynamicObject(2134,-1214.2387700,1840.3040800,40.7641000,0.0000000,0.0000000,47.0708000); //
	CreateDynamicObject(1432,-1210.1549100,1836.3322800,40.8934000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1432,-1206.5555400,1833.1458700,40.8934000,0.0000000,0.0000000,37.6931000); //
	CreateDynamicObject(1432,-1207.9080800,1829.7502400,40.8934000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1432,-1208.9510500,1833.5451700,40.8934000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2100,-1214.6986100,1832.9764400,40.7649000,0.0000000,0.0000000,135.3156000); //
	CreateDynamicObject(2803,-1213.1910400,1840.1561300,41.2838000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2393,-1214.4873000,1825.9273700,40.7655000,0.0000000,0.0000000,46.5297000); //
	CreateDynamicObject(2393,-1212.5493200,1824.0782500,40.7655000,0.0000000,0.0000000,46.1662900); //
	CreateDynamicObject(2395,-1217.7585400,1825.0462600,40.7651000,0.0000000,0.0000000,316.4621900); //
	CreateDynamicObject(2395,-1215.6351300,1823.2840600,40.7650800,0.0000000,0.0000000,136.3177800); //
	CreateDynamicObject(2353,-1210.0136700,1836.2922400,41.5544000,-24.9810000,23.8940000,139.3644000); //
	CreateDynamicObject(2222,-1209.2824700,1833.7622100,41.5735000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2217,-1206.5098900,1833.6611300,41.5544000,-24.9810000,23.8940000,139.3644000); //
	CreateDynamicObject(2838,-1207.9942600,1829.5756800,41.5075000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2840,-1210.1253700,1836.6267100,41.5120000,0.0000000,0.0000000,325.9560900); //
	CreateDynamicObject(2858,-1206.4638700,1832.9686300,41.5074000,0.0000000,0.0000000,335.9960000); //
	CreateDynamicObject(2672,-1209.4752200,1830.9284700,41.0380000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2677,-1216.6589400,1836.2064200,41.0889000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2804,-1214.4394500,1840.2744100,41.8486000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2806,-1215.0394300,1839.7316900,41.8155800,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2863,-1216.3775600,1838.2348600,41.8160900,0.0000000,0.0000000,266.4967300); //
	CreateDynamicObject(2850,-1208.7949200,1833.4871800,41.5076000,0.0000000,0.0000000,287.8918200); //
	CreateDynamicObject(2674,-1222.6508800,1826.7801500,40.7961000,0.0000000,0.0000000,323.2465800); //
	CreateDynamicObject(2670,-1217.8889200,1827.2949200,40.8630000,0.0000000,0.0000000,334.6153300); //
	CreateDynamicObject(19372,-1221.0787400,1821.3657200,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(19372,-1223.5980200,1823.7353500,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(870,-1221.1368400,1820.9157700,40.9724000,0.0000000,0.0000000,253.6475100); //
	CreateDynamicObject(870,-1219.3402100,1819.1940900,40.9724000,0.0000000,0.0000000,253.6475100); //
	CreateDynamicObject(870,-1224.4110100,1823.9215100,40.9724000,0.0000000,0.0000000,253.6475100); //
	CreateDynamicObject(870,-1225.6524700,1825.1904300,40.9724000,0.0000000,0.0000000,253.6475100); //
	CreateDynamicObject(870,-1226.5914300,1826.1499000,40.9724000,0.0000000,0.0000000,253.6475100); //
	CreateDynamicObject(870,-1217.4279800,1817.3983200,40.9724000,0.0000000,0.0000000,265.0973200); //
	CreateDynamicObject(19372,-1218.5440700,1818.9899900,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(870,-1218.5800800,1818.4033200,40.9724000,0.0000000,0.0000000,253.6475100); //
	CreateDynamicObject(870,-1211.8347200,1841.6585700,40.9724000,0.0000000,0.0000000,73.0435700); //
	CreateDynamicObject(2491,-1218.3704800,1825.0839800,40.7653100,0.0000000,0.0000000,46.6428000); //
	CreateDynamicObject(2508,-1217.4469000,1823.5225800,41.8695000,0.0000000,0.0000000,315.8053000); //
	CreateDynamicObject(2507,-1217.0909400,1823.5921600,41.8315000,0.0000000,0.0000000,44.2813000); //
	CreateDynamicObject(2469,-1220.4069800,1822.4072300,42.3883000,0.0000000,0.0000000,87.6326000); //
	CreateDynamicObject(19165,-1216.6999500,1824.2384000,42.2712000,90.0000000,0.0000000,136.8831000); //
	CreateDynamicObject(2942,-1209.7894300,1825.0831300,41.3289000,0.0000000,0.0000000,46.8038000); //
	CreateDynamicObject(1622,-1216.8947800,1819.1623500,43.9575000,0.0000000,0.0000000,226.0751000); //
	CreateDynamicObject(1616,-1226.0224600,1827.8868400,43.9601000,0.0000000,0.0000000,225.7607000); //
	CreateDynamicObject(19388,-1209.0372300,1826.5555400,42.4724000,0.0000000,0.0000000,316.5891100); //
	CreateDynamicObject(19388,-1211.2272900,1824.2225300,42.4724000,0.0000000,0.0000000,316.7562900); //
	CreateDynamicObject(19431,-1216.2111800,1819.0384500,42.4478000,0.0000000,0.0000000,314.9844100); //
	CreateDynamicObject(1523,-1211.6750500,1823.6355000,40.6983000,0.0000000,0.0000000,46.3497000); //
	CreateDynamicObject(1808,-1215.1319600,1827.7232700,40.7647000,0.0000000,0.0000000,137.0092900); //
	CreateDynamicObject(1775,-1204.5771500,1832.2550000,41.8530000,0.0000000,0.0000000,315.8994100); //
	CreateDynamicObject(2684,-1215.1605200,1833.2701400,42.9897000,0.0000000,0.0000000,315.7114900); //
	CreateDynamicObject(2685,-1215.9202900,1839.0777600,42.5790900,0.0000000,0.0000000,46.8974000); //
	CreateDynamicObject(2686,-1216.3774400,1838.5924100,42.5947000,0.0000000,0.0000000,48.1947000); //
	CreateDynamicObject(2687,-1216.3947800,1834.4375000,42.7475000,0.0000000,0.0000000,316.8974900); //
	CreateDynamicObject(2641,-1215.8006600,1833.9449500,43.0473000,0.0000000,0.0000000,134.6763000); //
	CreateDynamicObject(2642,-1214.4367700,1840.6562500,43.0276000,0.0000000,0.0000000,45.5792000); //
	CreateDynamicObject(2645,-1215.0434600,1840.0238000,43.1951000,0.0000000,0.0000000,46.4033800); //
	CreateDynamicObject(2666,-1217.2884500,1835.2570800,43.1534000,0.0000000,0.0000000,316.1998900); //
	CreateDynamicObject(2717,-1213.5734900,1832.5655500,43.0710000,0.0000000,0.0000000,356.2951000); //
	CreateDynamicObject(1620,-1220.9687500,1832.6914100,43.3141000,0.0000000,0.0000000,46.4579000); //
	CreateDynamicObject(1615,-1215.3282500,1827.3221400,43.5802000,0.0000000,0.0000000,46.3138000); //
	CreateDynamicObject(1584,-1219.5938700,1821.5319800,40.7651000,0.0000000,0.0000000,298.5685100); //
	CreateDynamicObject(19175,-1218.3743900,1820.0515100,42.9817000,0.0000000,0.0000000,136.6873000); //
	CreateDynamicObject(19462,-1213.7751500,1834.6739500,44.2561000,0.0000000,90.0000000,226.5285000); //
	CreateDynamicObject(19325,-1205.9189500,1829.6929900,42.1330000,0.0000000,0.0000000,316.0643000); //
	CreateDynamicObject(19454,-1215.6839600,1837.1236600,40.7038000,0.0000000,90.0000000,316.3658100); //
	CreateDynamicObject(19454,-1211.2724600,1837.2168000,44.1147000,0.0000000,90.0000000,226.3282000); //
	CreateDynamicObject(19462,-1208.1065700,1829.9156500,40.6777000,0.0000000,90.0000000,316.4306900); //
	CreateDynamicObject(19462,-1219.2358400,1828.9390900,44.2561000,0.0000000,90.0000000,226.2032900); //
	CreateDynamicObject(19454,-1213.6563700,1834.5629900,44.1807000,0.0000000,90.0000000,226.3282000); //
	CreateDynamicObject(19325,-1206.3007800,1834.8438700,42.1660000,0.0000000,0.0000000,46.4517000); //
	CreateDynamicObject(19325,-1211.0749500,1839.3830600,42.1660000,0.0000000,0.0000000,46.3140000); //
	CreateDynamicObject(19442,-1213.1185300,1841.2268100,42.4479000,0.0000000,0.0000000,46.1684000); //
	CreateDynamicObject(19325,-1210.4975600,1824.9093000,46.2498000,0.0000000,0.0000000,316.4724400); //
	CreateDynamicObject(19462,-1211.3898900,1837.1983600,44.2561000,0.0000000,90.0000000,226.5285000); //
	CreateDynamicObject(19454,-1208.6658900,1830.4801000,44.1147000,0.0000000,90.0000000,316.3992900); //
	CreateDynamicObject(19454,-1219.2301000,1828.8841600,44.1477000,0.0000000,90.0000000,226.3989000); //
	CreateDynamicObject(19442,-1214.3752400,1821.9805900,45.9435000,0.0000000,0.0000000,226.6261000); //
	CreateDynamicObject(19454,-1222.2554900,1825.7397500,44.1477000,0.0000000,90.0000000,46.4516000); //
	CreateDynamicObject(19446,-1220.3836700,1827.7059300,45.9117000,0.0000000,0.0000000,46.3170000); //
	CreateDynamicObject(19462,-1214.1051000,1834.3110400,44.2231000,0.0000000,90.0000000,226.5285000); //
	CreateDynamicObject(19446,-1215.2662400,1833.0979000,45.8787000,0.0000000,0.0000000,46.6261000); //
	CreateDynamicObject(19462,-1211.7110600,1826.1805400,44.1901000,0.0000000,90.0000000,136.3872100); //
	CreateDynamicObject(19462,-1212.2963900,1826.7351100,44.2231000,0.0000000,90.0000000,136.5985000); //
	CreateDynamicObject(19462,-1208.7276600,1830.4692400,44.2561000,0.0000000,90.0000000,136.5985000); //
	CreateDynamicObject(19462,-1208.1423300,1829.9290800,44.2231000,0.0000000,90.0000000,135.8771100); //
	CreateDynamicObject(19454,-1213.9864500,1834.2330300,44.1477000,0.0000000,90.0000000,226.3282000); //
	CreateDynamicObject(19454,-1214.7854000,1822.8465600,44.1477000,0.0000000,90.0000000,316.3882100); //
	CreateDynamicObject(19454,-1211.2724600,1837.1178000,44.1807000,0.0000000,90.0000000,226.3282000); //
	CreateDynamicObject(19325,-1205.9189500,1829.6929900,46.2498000,0.0000000,0.0000000,316.0713500); //
	CreateDynamicObject(19454,-1208.2038600,1829.7541500,44.1477000,0.0000000,90.0000000,316.3881500); //
	CreateDynamicObject(19442,-1204.1394000,1832.6866500,42.4479000,0.0000000,0.0000000,46.1684000); //
	CreateDynamicObject(19442,-1204.0955800,1831.6724900,42.4479000,0.0000000,0.0000000,136.8708000); //
	CreateDynamicObject(19442,-1217.3089600,1818.8487500,42.4479000,0.0000000,0.0000000,46.1684000); //
	CreateDynamicObject(19431,-1217.3048100,1818.9158900,42.4478000,0.0000000,0.0000000,45.4676000); //
	CreateDynamicObject(19435,-1205.2179000,1831.4523900,44.1271000,0.0000000,90.0000000,46.9273000); //
	CreateDynamicObject(19442,-1214.2240000,1841.1135300,45.9435000,0.0000000,0.0000000,136.8708000); //
	CreateDynamicObject(19442,-1204.0955800,1831.6724900,45.9435000,0.0000000,0.0000000,136.8708000); //
	CreateDynamicObject(19454,-1215.4178500,1823.4476300,44.1807000,0.0000000,90.0000000,316.3992900); //
	CreateDynamicObject(19454,-1221.6645500,1826.3631600,44.1807000,0.0000000,90.0000000,46.4516000); //
	CreateDynamicObject(19461,-1222.7082500,1823.9812000,42.4632000,0.0000000,0.0000000,46.4315000); //
	CreateDynamicObject(19461,-1220.4154100,1827.6590600,45.9336000,0.0000000,0.0000000,46.4315000); //
	CreateDynamicObject(19461,-1223.5484600,1831.3269000,42.4302000,0.0000000,0.0000000,136.3132900); //
	CreateDynamicObject(19369,-1218.0986300,1819.5981400,42.4457000,0.0000000,0.0000000,46.6144000); //
	CreateDynamicObject(19354,-1220.4915800,1834.4836400,45.9187000,0.0000000,0.0000000,316.0436100); //
	CreateDynamicObject(19354,-1222.7059300,1832.1850600,45.9187000,0.0000000,0.0000000,316.4577900); //
	CreateDynamicObject(19427,-1218.8509500,1836.2144800,45.8977000,0.0000000,0.0000000,316.3255000); //
	CreateDynamicObject(19427,-1216.7492700,1824.2288800,45.8977000,0.0000000,0.0000000,46.8857000); //
	CreateDynamicObject(19443,-1221.1839600,1831.4511700,44.1788000,0.0000000,90.0000000,46.5661000); //
	CreateDynamicObject(19443,-1218.8033400,1833.9663100,44.1458000,0.0000000,90.0000000,46.5661000); //
	CreateDynamicObject(19443,-1219.4344500,1834.5168500,44.1788000,0.0000000,90.0000000,46.5661000); //
	CreateDynamicObject(19443,-1221.8625500,1832.0091600,44.2118000,0.0000000,90.0000000,46.5661000); //
	CreateDynamicObject(19369,-1219.2271700,1835.8305700,45.9218000,0.0000000,0.0000000,316.2031900); //
	CreateDynamicObject(19369,-1221.4502000,1833.5476100,45.9218000,0.0000000,0.0000000,316.2031900); //
	CreateDynamicObject(19427,-1218.6529500,1836.4124800,45.8977000,0.0000000,0.0000000,316.3255000); //
	CreateDynamicObject(19427,-1214.2130100,1841.0749500,45.9637000,0.0000000,0.0000000,316.3255000); //
	CreateDynamicObject(19427,-1213.1508800,1841.2049600,45.9637000,0.0000000,0.0000000,227.7073100); //
	CreateDynamicObject(19427,-1204.1756600,1832.6755400,45.9637000,0.0000000,0.0000000,226.4054000); //
	CreateDynamicObject(19427,-1204.1615000,1831.6953100,45.9637000,0.0000000,0.0000000,134.9117000); //
	CreateDynamicObject(3850,-1213.1932400,1828.2725800,44.8375000,0.0000000,0.0000000,136.5038000); //
	CreateDynamicObject(3850,-1218.4349400,1830.5782500,44.8375000,0.0000000,0.0000000,46.1742000); //
	CreateDynamicObject(3850,-1215.9185800,1828.1639400,44.8375000,0.0000000,0.0000000,46.1742000); //
	CreateDynamicObject(16151,-1214.3598600,1833.8399700,44.6383000,0.0000000,0.0000000,227.4534000); //
	CreateDynamicObject(16152,-1210.0942400,1837.0440700,44.1091000,0.0000000,0.0000000,226.7171900); //
	CreateDynamicObject(2011,-1213.8220200,1822.1102300,44.3433000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2011,-1213.5979000,1841.0544400,44.3433000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1704,-1222.5739700,1830.5993700,44.3431000,0.0000000,0.0000000,92.8002000); //
	CreateDynamicObject(1703,-1219.6447800,1827.8315400,44.3430000,0.0000000,0.0000000,136.4859900); //
	CreateDynamicObject(1703,-1216.8757300,1825.1687000,44.3430000,0.0000000,0.0000000,135.9855000); //
	CreateDynamicObject(19397,-1211.2059300,1824.2243700,42.4683000,0.0000000,0.0000000,316.6557900); //
	CreateDynamicObject(19397,-1215.6032700,1823.1246300,45.9496000,0.0000000,0.0000000,227.1508000); //
	CreateDynamicObject(19442,-1213.2501200,1822.1217000,45.9435000,0.0000000,0.0000000,136.8708000); //
	CreateDynamicObject(19442,-1216.9056400,1824.3265400,45.9435000,0.0000000,0.0000000,226.6261000); //
	CreateDynamicObject(2818,-1212.6033900,1840.1278100,44.3424000,0.0000000,0.0000000,226.7144900); //
	CreateDynamicObject(2818,-1206.2329100,1834.0642100,44.3424000,0.0000000,0.0000000,226.7145100); //
	CreateDynamicObject(2818,-1207.0207500,1834.8288600,44.3424000,0.0000000,0.0000000,226.7144900); //
	CreateDynamicObject(2818,-1207.8136000,1835.5809300,44.3424000,0.0000000,0.0000000,226.7144900); //
	CreateDynamicObject(2818,-1208.6046100,1836.3252000,44.3424000,0.0000000,0.0000000,226.7144900); //
	CreateDynamicObject(2818,-1209.3944100,1837.0919200,44.3424000,0.0000000,0.0000000,226.7144900); //
	CreateDynamicObject(2818,-1210.1831100,1837.8515600,44.3424000,0.0000000,0.0000000,226.7144900); //
	CreateDynamicObject(2818,-1210.9842500,1838.6053500,44.3424000,0.0000000,0.0000000,226.7144900); //
	CreateDynamicObject(2818,-1211.7780800,1839.3641400,44.3424000,0.0000000,0.0000000,226.7144900); //
	CreateDynamicObject(2847,-1216.4643600,1834.9105200,44.3100000,0.0000000,0.0000000,46.7562000); //
	CreateDynamicObject(2847,-1213.4543500,1821.7724600,44.2700000,0.0000000,0.0000000,46.6521000); //
	CreateDynamicObject(2847,-1213.2003200,1831.9643600,44.3430000,0.0000000,0.0000000,47.7774000); //
	CreateDynamicObject(2847,-1213.9040500,1832.6428200,44.3430000,0.0000000,0.0000000,47.7774000); //
	CreateDynamicObject(2847,-1214.6333000,1833.2954100,44.3430000,0.0000000,0.0000000,47.7774000); //
	CreateDynamicObject(2847,-1215.3366700,1833.9383500,44.3430000,0.0000000,0.0000000,47.7774000); //
	CreateDynamicObject(2847,-1216.0710400,1834.5874000,44.3430000,0.0000000,0.0000000,47.7774000); //
	CreateDynamicObject(19384,-1215.5533400,1823.1159700,45.9145000,0.0000000,0.0000000,46.9686700); //
	CreateDynamicObject(19427,-1213.2539100,1822.1519800,45.9637000,0.0000000,0.0000000,136.9969000); //
	CreateDynamicObject(19427,-1214.3909900,1822.0407700,45.9307000,0.0000000,0.0000000,46.8857000); //
	CreateDynamicObject(2799,-1210.9649700,1825.1224400,44.8257000,0.0000000,0.0000000,350.4538900); //
	CreateDynamicObject(2799,-1207.0268600,1829.2016600,44.8257000,0.0000000,0.0000000,350.4538900); //
	CreateDynamicObject(2799,-1208.9241900,1827.2230200,44.8257000,0.0000000,0.0000000,350.4538900); //
	CreateDynamicObject(2011,-1204.2109400,1832.1604000,44.3433000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1433,-1218.9311500,1827.2257100,44.5407000,0.0000000,0.0000000,46.1352000); //
	CreateDynamicObject(1541,-1216.0762900,1834.1445300,45.8242000,0.0000000,0.0000000,317.8465900); //
	CreateDynamicObject(19355,-1212.9156500,1830.8944100,45.5775000,0.0000000,0.0000000,46.5599000); //
	CreateDynamicObject(2847,-1216.8273900,1835.3725600,44.3100000,0.0000000,0.0000000,46.7562000); //
	CreateDynamicObject(19355,-1216.7821000,1834.5629900,45.5775000,0.0000000,0.0000000,46.5599000); //
	CreateDynamicObject(19355,-1214.4835200,1832.3866000,45.5775000,0.0000000,0.0000000,46.5599000); //
	CreateDynamicObject(19428,-1218.6112100,1836.4552000,45.5887000,0.0000000,0.0000000,135.8474900); //
	CreateDynamicObject(19428,-1218.1336700,1835.8216600,45.5887000,0.0000000,0.0000000,227.0970000); //
	CreateDynamicObject(2395,-1215.5112300,1833.5743400,43.8982000,0.0000000,0.0000000,136.2475000); //
	CreateDynamicObject(2395,-1213.1831100,1831.3532700,43.8982000,0.0000000,0.0000000,136.2475000); //
	CreateDynamicObject(1545,-1216.8344700,1834.8768300,45.8542000,0.0000000,0.0000000,135.9866000); //
	CreateDynamicObject(1548,-1212.5426000,1833.3973400,45.2653000,0.0000000,0.0000000,317.1646100); //
	CreateDynamicObject(2104,-1218.4552000,1836.1601600,44.3105000,0.0000000,0.0000000,136.6116900); //
	CreateDynamicObject(2800,-1210.9611800,1825.1218300,44.8347000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2800,-1207.0523700,1829.1883500,44.8347000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2800,-1208.9300500,1827.2165500,44.8347000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2847,-1212.5244100,1831.2474400,44.3430000,0.0000000,0.0000000,47.7774000); //
	CreateDynamicObject(2847,-1204.6590600,1830.9668000,44.3100000,0.0000000,0.0000000,46.0369000); //
	CreateDynamicObject(2847,-1205.9941400,1829.5865500,44.3100000,0.0000000,0.0000000,46.0369000); //
	CreateDynamicObject(2847,-1207.3525400,1828.1846900,44.3100000,0.0000000,0.0000000,46.0369000); //
	CreateDynamicObject(2847,-1208.6890900,1826.8048100,44.3100000,0.0000000,0.0000000,46.0369000); //
	CreateDynamicObject(2847,-1209.8785400,1825.5336900,44.3069000,0.0000000,0.0000000,46.0369000); //
	CreateDynamicObject(2847,-1211.3171400,1824.0328400,44.2770000,0.0000000,0.0000000,46.0369000); //
	CreateDynamicObject(2847,-1219.9709500,1832.7478000,44.2760000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1210.0293000,1825.3905000,44.3000000,0.0000000,0.0000000,46.0369000); //
	CreateDynamicObject(1486,-1211.9272500,1838.6937300,45.1661000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1510,-1208.2657500,1835.6016800,45.0669000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1520,-1211.3669400,1838.8335000,45.1001000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1543,-1211.6903100,1838.4998800,45.0342000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1510,-1211.7002000,1838.6751700,45.0669000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1665,-1206.4777800,1833.9670400,45.0668000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1544,-1210.3928200,1836.9968300,45.0340000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1664,-1209.8453400,1837.4119900,45.1990000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1546,-1209.9937700,1836.8761000,45.1331000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1666,-1208.1792000,1835.1884800,45.1001000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1667,-1208.5053700,1835.6773700,45.1229000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1668,-1208.4835200,1835.2889400,45.1820000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1669,-1207.9116200,1835.6754200,45.1989000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1665,-1209.9595900,1837.1191400,45.0668000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1950,-1206.8085900,1834.1822500,45.2319000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1951,-1206.6087600,1833.5892300,45.2319000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1548,-1215.1436800,1835.8922100,45.2653000,0.0000000,0.0000000,317.1646100); //
	CreateDynamicObject(1665,-1213.7835700,1834.4216300,45.2983000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1543,-1214.1059600,1835.0728800,45.2654000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1543,-1214.2631800,1834.6973900,45.2654000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1520,-1214.5633500,1835.1190200,45.3315000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1486,-1213.4647200,1834.3133500,45.3974000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2847,-1212.6492900,1822.6084000,44.2770000,0.0000000,0.0000000,46.6521000); //
	CreateDynamicObject(2847,-1213.7530500,1822.8034700,44.3030000,0.0000000,0.0000000,135.7796900); //
	CreateDynamicObject(2847,-1217.9084500,1826.8468000,44.3460000,0.0000000,0.0000000,135.7796900); //
	CreateDynamicObject(2847,-1219.2851600,1828.1872600,44.3460000,0.0000000,0.0000000,135.7796900); //
	CreateDynamicObject(2847,-1220.6942100,1829.5418700,44.3460000,0.0000000,0.0000000,135.7796900); //
	CreateDynamicObject(2847,-1221.9030800,1830.7197300,44.3360000,0.0000000,0.0000000,135.7796900); //
	CreateDynamicObject(2847,-1219.3652300,1832.1763900,44.2370000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1218.0261200,1833.5706800,44.2370000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1220.3122600,1833.1182900,44.2660000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1220.3701200,1831.0695800,44.2660000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1221.4825400,1832.0000000,44.2910000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1218.6106000,1834.1550300,44.2760000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1218.9473900,1834.5057400,44.2660000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1221.0411400,1831.6081500,44.3090000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1222.2503700,1831.0686000,44.3510000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(2847,-1221.6991000,1831.6586900,44.3410000,0.0000000,0.0000000,46.3391000); //
	CreateDynamicObject(19448,-1219.1101100,1822.7782000,44.2670000,0.0000000,90.0000000,46.3965000); //
	CreateDynamicObject(19356,-1223.7142300,1827.1575900,44.2670000,0.0000000,90.0000000,46.4513000); //
	CreateDynamicObject(19429,-1225.1794400,1828.5628700,44.2770000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(19429,-1215.5177000,1820.7417000,44.2110000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(19429,-1224.6513700,1829.1239000,44.2440000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(19429,-1223.4788800,1828.0418700,44.2440000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(19429,-1222.3132300,1826.9290800,44.2440000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(19429,-1221.1578400,1825.8153100,44.2440000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(19429,-1219.9932900,1824.7343800,44.2440000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(19429,-1218.8111600,1823.6460000,44.2440000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(19429,-1217.5308800,1822.6551500,44.2440000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(19429,-1216.3949000,1821.5699500,44.2440000,0.0000000,90.0000000,46.1287000); //
	CreateDynamicObject(1491,-1216.1449000,1823.6314700,44.1992000,0.0000000,0.0000000,316.6323900); //
	CreateDynamicObject(970,-1225.4180900,1826.4215100,44.8914000,0.0000000,0.0000000,316.2500000); //
	CreateDynamicObject(970,-1225.4698500,1829.3938000,44.8254000,0.0000000,0.0000000,46.4534000); //
	CreateDynamicObject(970,-1221.3824500,1822.5727500,44.8914000,0.0000000,0.0000000,316.2500000); //
	CreateDynamicObject(970,-1218.3728000,1819.6694300,44.8914000,0.0000000,0.0000000,315.9469900); //
	CreateDynamicObject(970,-1215.3631600,1819.7884500,44.8254000,0.0000000,0.0000000,46.6605000); //
	CreateDynamicObject(970,-1224.4080800,1825.4538600,44.8914000,0.0000000,0.0000000,316.2500000); //
	CreateDynamicObject(2099,-1216.2919900,1838.9842500,44.3433000,0.0000000,0.0000000,45.5384000); //
	CreateDynamicObject(19372,-1216.4951200,1817.0534700,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(19372,-1214.3111600,1819.3719500,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(870,-1216.5103800,1816.4574000,40.9724000,0.0000000,0.0000000,260.2286100); //
	CreateDynamicObject(870,-1214.7091100,1818.2576900,40.9724000,0.0000000,0.0000000,4.8452000); //
	CreateDynamicObject(870,-1213.6159700,1819.5109900,40.9724000,0.0000000,0.0000000,4.8452000); //
	CreateDynamicObject(870,-1212.5167200,1820.7684300,40.9724000,0.0000000,0.0000000,4.8452000); //
	CreateDynamicObject(870,-1216.0965600,1816.8753700,40.9724000,0.0000000,0.0000000,4.8452000); //
	CreateDynamicObject(1742,-1220.6674800,1834.2459700,44.2746000,0.0000000,0.0000000,45.9168000); //
	CreateDynamicObject(1742,-1219.6538100,1835.2762500,44.2746000,0.0000000,0.0000000,45.9168000); //
	CreateDynamicObject(2855,-1219.0155000,1827.3897700,45.0474900,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2247,-1218.8747600,1826.9091800,45.5098000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2259,-1211.9414100,1830.7524400,45.7848000,0.0000000,0.0000000,138.0379000); //
	CreateDynamicObject(19172,-1222.1894500,1832.5780000,46.1140000,0.0000000,0.0000000,45.8316000); //
	CreateDynamicObject(19174,-1219.3237300,1826.8182400,46.1950000,0.0000000,0.0000000,136.7295100); //
	CreateDynamicObject(19173,-1218.5334500,1830.4116200,43.1872700,0.0000000,0.0000000,316.5619200); //
	CreateDynamicObject(2260,-1213.3383800,1830.4864500,45.7564000,0.0000000,0.0000000,316.7645000); //
	CreateDynamicObject(2261,-1214.7252200,1831.7623300,45.4207000,0.0000000,0.0000000,316.7018100); //
	CreateDynamicObject(2262,-1216.1301300,1833.1350100,45.9253000,0.0000000,0.0000000,316.7554000); //
	CreateDynamicObject(2264,-1217.5376000,1834.4167500,45.5091000,0.0000000,0.0000000,316.6026900); //
	CreateDynamicObject(2270,-1214.3891600,1822.8430200,45.2144000,0.0000000,0.0000000,137.3990900); //
	CreateDynamicObject(2270,-1215.9418900,1824.2686800,45.2144000,0.0000000,0.0000000,137.3990900); //
	CreateDynamicObject(2847,-1216.5117200,1825.4989000,44.3460000,0.0000000,0.0000000,135.7797400); //
	CreateDynamicObject(2847,-1215.1324500,1824.1512500,44.3130000,0.0000000,0.0000000,135.7796900); //
	CreateDynamicObject(19454,-1207.1894500,1835.2978500,47.7791000,0.0000000,90.0000000,46.0792000); //
	CreateDynamicObject(19454,-1211.8342300,1825.9775400,47.9441000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1211.8342300,1825.9775400,48.1091000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1211.8342300,1825.9775400,48.2411000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1211.8342300,1825.9775400,47.7791000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1214.3751200,1828.3741500,47.7791000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1216.9307900,1830.7725800,47.7791000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1214.7074000,1838.2744100,47.7461000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1209.5772700,1832.8332500,47.9441000,0.0000000,90.0000000,46.0792000); //
	CreateDynamicObject(19454,-1209.5772700,1832.8332500,48.1091000,0.0000000,90.0000000,46.0792000); //
	CreateDynamicObject(19454,-1209.5772700,1832.8332500,48.2741000,0.0000000,90.0000000,46.0792000); //
	CreateDynamicObject(19454,-1209.5772700,1832.8332500,47.7791000,0.0000000,90.0000000,46.0792000); //
	CreateDynamicObject(19454,-1207.1894500,1835.2978500,47.9441000,0.0000000,90.0000000,46.0792000); //
	CreateDynamicObject(19454,-1207.1894500,1835.2978500,48.1091000,0.0000000,90.0000000,46.0792000); //
	CreateDynamicObject(19454,-1207.1894500,1835.2978500,48.2741000,0.0000000,90.0000000,46.0792000); //
	CreateDynamicObject(19454,-1219.4758300,1833.1591800,47.7791000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1214.7074000,1838.2744100,47.9111000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1214.7074000,1838.2744100,48.0761000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19454,-1214.7074000,1838.2744100,48.2411000,0.0000000,90.0000000,316.7195100); //
	CreateDynamicObject(19435,-1213.5708000,1836.6352500,47.7691000,0.0000000,90.0000000,46.2207000); //
	CreateDynamicObject(19435,-1211.0234400,1838.9432400,47.9341000,0.0000000,90.0000000,46.2207000); //
	CreateDynamicObject(19435,-1211.0234400,1838.9432400,48.0991000,0.0000000,90.0000000,46.2207000); //
	CreateDynamicObject(19435,-1211.0234400,1838.9432400,48.2641000,0.0000000,90.0000000,46.2207000); //
	CreateDynamicObject(19435,-1211.0234400,1838.9432400,47.7691000,0.0000000,90.0000000,46.2207000); //
	CreateDynamicObject(19435,-1213.5708000,1836.6352500,48.2971000,0.0000000,90.0000000,46.2207000); //
	CreateDynamicObject(1687,-1213.4520300,1833.1533200,48.6878000,0.0000000,0.0000000,315.8960900); //
	CreateDynamicObject(1690,-1214.3325200,1839.3155500,48.8471000,0.0000000,0.0000000,137.1996600); //
	CreateDynamicObject(1691,-1206.3153100,1831.8463100,48.7551000,0.0000000,0.0000000,316.3743000); //
	CreateDynamicObject(1688,-1212.9318800,1828.4852300,48.8665000,0.0000000,0.0000000,46.7451000); //
	CreateDynamicObject(1695,-1210.0119600,1827.7093500,48.7948000,0.0000000,0.0000000,316.5946000); //
	CreateDynamicObject(1695,-1216.4461700,1825.9610600,48.3328000,0.0000000,0.0000000,316.5946000); //
	CreateDynamicObject(1695,-1218.5051300,1827.9064900,48.3328000,0.0000000,0.0000000,316.3793000); //
	CreateDynamicObject(1695,-1220.5269800,1829.8616900,48.3328000,0.0000000,0.0000000,316.3793000); //
	CreateDynamicObject(1695,-1213.8700000,1823.6178000,48.7948000,0.0000000,0.0000000,316.5946000); //
	CreateDynamicObject(1695,-1211.9500700,1825.6600300,48.7948000,0.0000000,0.0000000,316.5946000); //
	CreateDynamicObject(1695,-1222.0589600,1831.3297100,48.3328000,0.0000000,0.0000000,316.3793000); //
	CreateDynamicObject(1695,-1220.0859400,1833.3906300,48.3328000,0.0000000,0.0000000,316.3793000); //
	CreateDynamicObject(19372,-1212.1154800,1821.6947000,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(19372,-1211.6960400,1841.3736600,40.6430000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(19372,-1204.3403300,1830.0765400,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(19372,-1202.1717500,1832.3859900,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(19372,-1204.7121600,1834.7834500,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(19372,-1207.2369400,1837.1767600,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(19372,-1209.7729500,1839.5606700,40.6530000,0.0000000,90.0000000,316.7392900); //
	CreateDynamicObject(870,-1211.5893600,1821.6024200,40.9724000,0.0000000,0.0000000,4.8452000); //
	CreateDynamicObject(870,-1206.2314500,1827.4400600,40.9724000,0.0000000,0.0000000,342.1680600); //
	CreateDynamicObject(870,-1204.7938200,1828.9615500,40.9724000,0.0000000,0.0000000,342.1680600); //
	CreateDynamicObject(870,-1203.2928500,1830.5500500,40.9724000,0.0000000,0.0000000,342.1680600); //
	CreateDynamicObject(870,-1201.9296900,1831.9926800,40.9724000,0.0000000,0.0000000,342.1680600); //
	CreateDynamicObject(870,-1202.8431400,1833.3148200,40.9724000,0.0000000,0.0000000,73.0435700); //
	CreateDynamicObject(870,-1203.9483600,1834.3245800,40.9724000,0.0000000,0.0000000,73.0435700); //
	CreateDynamicObject(870,-1205.2650100,1835.5694600,40.9724000,0.0000000,0.0000000,73.0435700); //
	CreateDynamicObject(870,-1206.7597700,1837.0870400,40.9724000,0.0000000,0.0000000,73.0435700); //
	CreateDynamicObject(870,-1208.1342800,1838.3409400,40.9724000,0.0000000,0.0000000,73.0435700); //
	CreateDynamicObject(870,-1209.5708000,1839.6831100,40.9724000,0.0000000,0.0000000,73.0435700); //
	CreateDynamicObject(870,-1210.5875200,1840.6900600,40.9724000,0.0000000,0.0000000,73.0435700); //
	CreateDynamicObject(1419,-1227.1342800,1827.6197500,41.2301000,0.0000000,0.0000000,47.7589000); //
	CreateDynamicObject(1419,-1210.2410900,1842.2077600,41.2341000,0.0000000,0.0000000,136.7417000); //
	CreateDynamicObject(1419,-1214.9245600,1816.1792000,41.2341000,0.0000000,0.0000000,46.8401000); //
	CreateDynamicObject(1419,-1217.7913800,1816.0964400,41.2341000,0.0000000,0.0000000,136.7738000); //
	CreateDynamicObject(1419,-1220.7749000,1818.9118700,41.2341000,0.0000000,0.0000000,136.7738000); //
	CreateDynamicObject(1419,-1223.7633100,1821.7106900,41.2341000,0.0000000,0.0000000,136.7738000); //
	CreateDynamicObject(1419,-1211.1722400,1820.1402600,41.2341000,0.0000000,0.0000000,46.8401000); //
	CreateDynamicObject(1419,-1204.9576400,1826.8520500,41.2341000,0.0000000,0.0000000,46.8401000); //
	CreateDynamicObject(1419,-1213.2375500,1842.2442600,41.2671000,0.0000000,0.0000000,47.6577400); //
	CreateDynamicObject(1419,-1201.3004200,1833.7569600,41.2341000,0.0000000,0.0000000,136.7417000); //
	CreateDynamicObject(1419,-1204.2607400,1836.5842300,41.2341000,0.0000000,0.0000000,136.3067900); //
	CreateDynamicObject(1419,-1207.2366900,1839.3753700,41.2341000,0.0000000,0.0000000,136.7417000); //
	CreateDynamicObject(1419,-1202.1729700,1829.8349600,41.2341000,0.0000000,0.0000000,46.8401000); //
	CreateDynamicObject(1419,-1213.9620400,1817.1682100,41.2341000,0.0000000,0.0000000,46.8401000); //
	CreateDynamicObject(1419,-1226.7386500,1824.5233200,41.2671000,0.0000000,0.0000000,136.7738000); //
	CreateDynamicObject(1419,-1226.9696000,1824.7214400,41.2341000,0.0000000,0.0000000,136.7738000); //
	CreateDynamicObject(1419,-1201.2207000,1830.8139600,41.2341000,0.0000000,0.0000000,46.8401000); //
	CreateDynamicObject(1419,-1210.3400900,1842.3398400,41.2341000,0.0000000,0.0000000,136.7417000); //
	CreateDynamicObject(1215,-1228.6340300,1826.0147700,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1211.7944300,1843.8829300,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1213.0522500,1817.9377400,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1216.1872600,1814.6208500,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1219.7218000,1817.6613800,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1222.8725600,1820.5998500,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1225.7662400,1823.3540000,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1209.7304700,1821.4748500,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1206.1632100,1825.3721900,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1203.0028100,1828.7574500,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1199.6903100,1832.3387500,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1203.8841600,1836.4056400,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1215,-1207.9920700,1840.3208000,41.2781000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2714,-1210.0523700,1825.2669700,43.2072000,0.0000000,0.0000000,45.8682000); //
	CreateDynamicObject(17969,-1224.8448500,1830.1337900,42.3068000,0.0000000,0.0000000,316.0029000); //
	CreateDynamicObject(18663,-1214.4211400,1841.0166000,42.4893300,0.0000000,0.0000000,316.3291300); //
	CreateDynamicObject(910,-1216.5976600,1839.6164600,41.9586000,0.0000000,0.0000000,227.6418000); //
	CreateDynamicObject(1440,-1218.3840300,1838.0313700,41.2210000,0.0000000,0.0000000,55.9279000); //
	CreateDynamicObject(1372,-1219.9169900,1835.9428700,40.7161000,0.0000000,0.0000000,227.5325900); //
	CreateDynamicObject(1338,-1221.3459500,1834.9805900,41.4076000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1333,-1222.6375700,1833.4078400,41.6174000,0.0000000,0.0000000,226.0824000); //
	CreateDynamicObject(3092,-1216.3485100,1839.3659700,42.0251900,0.0000000,0.0000000,40.2075600); //
	CreateDynamicObject(1280,-1214.4788800,1816.1269500,41.0479000,0.0000000,0.0000000,136.7055100); //
	CreateDynamicObject(1280,-1201.1538100,1830.3811000,41.1139000,0.0000000,0.0000000,137.5507000); //
	CreateDynamicObject(1280,-1211.2358400,1819.5981400,41.0809000,0.0000000,0.0000000,137.5507000); //
	CreateDynamicObject(1280,-1204.3907500,1826.9674100,41.0809000,0.0000000,0.0000000,137.5507000); //
	CreateDynamicObject(1343,-1200.5356400,1838.6146200,41.3953000,0.0000000,0.0000000,40.6272000); //
	CreateDynamicObject(2707,-1208.5058600,1833.7551300,43.9904000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2707,-1211.6253700,1837.1518600,43.9904000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2707,-1213.5106200,1835.3547400,44.0234000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2707,-1210.2706300,1831.9270000,44.0234000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(19454,-1215.2857700,1823.5135500,44.1147000,0.0000000,90.0000000,316.3992900); //
	CreateDynamicObject(16780,-1211.5926500,1826.9488500,44.0239000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1432,-1219.7981000,1823.0316200,44.4615000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1432,-1224.8877000,1828.0369900,44.4615000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1432,-1222.1628400,1825.3573000,44.4615000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2801,-1224.8426500,1828.1158400,44.7445000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2801,-1219.7755100,1823.0793500,44.7445000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(2801,-1222.1558800,1825.4556900,44.7445000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1408,-1191.2072800,1827.3122600,41.2836000,0.0000000,0.0000000,135.0406000); //
	CreateDynamicObject(1408,-1213.5540800,1845.8035900,41.3166000,0.0000000,0.0000000,46.9728000); //
	CreateDynamicObject(1408,-1203.6453900,1809.1615000,41.2836000,0.0000000,0.0000000,44.4312100); //
	CreateDynamicObject(1408,-1199.7280300,1813.0046400,41.2836000,0.0000000,0.0000000,44.4312000); //
	CreateDynamicObject(1408,-1195.8555900,1816.8037100,41.2836000,0.0000000,0.0000000,44.4312000); //
	CreateDynamicObject(1408,-1190.1878700,1822.3686500,41.2836000,0.0000000,0.0000000,44.4312000); //
	CreateDynamicObject(1408,-1191.9757100,1820.6049800,41.2836000,0.0000000,0.0000000,44.4312000); //
	CreateDynamicObject(1408,-1190.2114300,1826.2463400,41.2836000,0.0000000,0.0000000,135.0406000); //
	CreateDynamicObject(1408,-1207.7945600,1808.9082000,41.2836000,0.0000000,0.0000000,324.2597000); //
	CreateDynamicObject(1297,-1205.9781500,1808.1534400,44.0184000,0.0000000,0.0000000,305.8205000); //
	CreateDynamicObject(1297,-1189.2288800,1824.8945300,44.0184000,0.0000000,0.0000000,314.9142200); //
	CreateDynamicObject(1297,-1191.5356400,1822.3781700,44.0184000,0.0000000,0.0000000,314.9142200); //
	CreateDynamicObject(1297,-1193.9597200,1819.9610600,44.0184000,0.0000000,0.0000000,314.9142200); //
	CreateDynamicObject(1297,-1196.3829300,1817.5994900,44.0184000,0.0000000,0.0000000,314.9142200); //
	CreateDynamicObject(1297,-1198.9044200,1815.1904300,44.0184000,0.0000000,0.0000000,314.9142200); //
	CreateDynamicObject(1297,-1201.3144500,1812.7753900,44.0184000,0.0000000,0.0000000,314.9142200); //
	CreateDynamicObject(1297,-1203.8212900,1810.4133300,44.0184000,0.0000000,0.0000000,314.9142200); //
	CreateDynamicObject(1408,-1209.4356700,1810.0987500,41.2836000,0.0000000,0.0000000,324.2597000); //
	CreateDynamicObject(1408,-1223.8963600,1818.6467300,41.2836000,0.0000000,0.0000000,320.3191500); //
	CreateDynamicObject(1408,-1228.0454100,1822.1418500,41.2836000,0.0000000,0.0000000,320.3191500); //
	CreateDynamicObject(1408,-1230.3269000,1824.0284400,41.3166000,0.0000000,0.0000000,320.3192100); //
	CreateDynamicObject(1408,-1230.4364000,1827.6336700,41.3166000,0.0000000,0.0000000,48.3537200); //
	CreateDynamicObject(1408,-1203.2183800,1839.9155300,41.1896000,0.0000000,0.0000000,137.5637100); //
	CreateDynamicObject(1408,-1215.1781000,1844.0524900,41.3166000,0.0000000,0.0000000,46.9727900); //
	CreateDynamicObject(1408,-1209.6932400,1845.8313000,41.1896300,0.0000000,0.0000000,137.5637100); //
	CreateDynamicObject(1408,-1205.6589400,1842.1621100,41.1896000,0.0000000,0.0000000,137.5637100); //
	CreateDynamicObject(808,-1224.5617700,1811.1076700,41.7325000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(672,-1231.3973400,1820.7540300,41.4176900,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(808,-1210.8908700,1808.7485400,41.7325000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1575,-1217.3355700,1821.0404100,41.6652000,0.0000000,0.0000000,316.3698100); //
	CreateDynamicObject(1576,-1217.7290000,1821.4003900,41.6652000,0.0000000,0.0000000,0.0000000); //
	CreateDynamicObject(1649,-1209.5832500,1829.2801500,42.3988000,0.0000000,0.0000000,313.9101900); //
	CreateDynamicObject(19426,-1204.1761500,1832.6700400,42.4129000,0.0000000,0.0000000,45.4342000); //
//-[Часы]-----------------------------------------------------------------------
	Clock = TextDrawCreate(547.000000,24.000000,"00:00");
	TextDrawAlignment(Clock,0);
	TextDrawBackgroundColor(Clock,0x000000ff); // Цвет обводки
	TextDrawFont(Clock,3);
	TextDrawLetterSize(Clock,0.6,1.9);
	TextDrawColor(Clock,0x00F6F6F6); // Цвет TD
	TextDrawSetOutline(Clock,2);
	TextDrawSetProportional(Clock,1);
	TextDrawSetShadow(Clock,1);
	
 	site = TextDrawCreate(530.000000,8.120000,"Pro100Drift.Ru");
	TextDrawAlignment(site,0);
	TextDrawBackgroundColor(site,0x000000ff);
	TextDrawFont(site,2);
	TextDrawLetterSize(site,0.299999,1.200000);
	TextDrawColor(site,0xc6ff00ff);
	TextDrawSetOutline(site,1);
	TextDrawSetProportional(site,1);
	TextDrawSetShadow(site,1);
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnGameModeExit()
{
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerRequestClass(playerid, classid)
{
	KillTimer(StartPTimer[playerid]);
	ShowModelSelectionMenu(playerid, sskinslist, "Ckњ®Ё", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
	SetPVarInt(playerid,"OpenedMMenu",1);
	for(new sc=0; sc<25; sc++) SendClientMessage(playerid,-1,"\t");
	SendClientMessage(playerid,0xFFFFFFFF,"{FFFFFF}Выберите скин и нажмите кнопку {BAA530}Spawn");
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerConnect(playerid)
{
	TextDrawShowForPlayer(playerid,site);

    Initialize(playerid);
    
	hicmd[playerid] = false;
	bbcmd[playerid] = false;
	
	new cnstr[128];
/*	format(cnstr,sizeof(cnstr),"{E3E3E3}%s {C6C6C6}подключился(ась) к серверу",PlayerName(playerid));
	SendClientMessageToAll(-1,cnstr);   */
	
	format(cnstr,sizeof(cnstr),GSYS_PFILEPATH,PlayerName(playerid));
	if(!dini_Exists(cnstr))
	{
	    dini_Create(cnstr);
	    dini_IntSet(cnstr,"GangID",INVALID_GANG_ID);
	    dini_IntSet(cnstr,"Rank",0);
		SetPVarInt(playerid,"PGangID",INVALID_GANG_ID);
	}
	else
	{
		SetPVarInt(playerid,"PGangID",dini_Int(cnstr,"GangID"));
	}
	
	//Initialize(playerid);
	
	stextdrwe[playerid] = TextDrawCreate(300.0,0.0,"Edit To Show");
	TextDrawFont(stextdrwe[playerid],2);
	TextDrawLetterSize(stextdrwe[playerid],0.6,1.5);
	TextDrawColor(stextdrwe[playerid],0xaeff00FF);
	TextDrawSetOutline(stextdrwe[playerid],false);
	TextDrawSetProportional(stextdrwe[playerid],true);
	TextDrawSetShadow(stextdrwe[playerid],1);
	TextDrawHideForPlayer(playerid,stextdrwe[playerid]);
	
	RemoveBuildingForPlayer(playerid, 5400, 1913.1328, -1370.5000, 17.7734, 0.25);
	
	RemoveBuildingForPlayer(playerid, 4028, 1781.47656, -1648.42187, 26.83594, 41.90);
	RemoveBuildingForPlayer(playerid, 700, 1777.85156, -1677.19531, 14.3125, 11.10);
	RemoveBuildingForPlayer(playerid, 700, 1761.46094, -1651.74219, 14.3125, 11.10);
	RemoveBuildingForPlayer(playerid, 700, 1792.80469, -1640.95312, 14.3125, 11.10);
	RemoveBuildingForPlayer(playerid, 713, 1807.51563, -1625.88281, 12.70313, 27.50);
	RemoveBuildingForPlayer(playerid, 1294, 1755.37537, -1632.17322, 16.03539, 8.00);
	RemoveBuildingForPlayer(playerid, 11675, -1220.4609, 1832.4063, 40.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 11674, -1220.4609, 1832.4063, 40.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 1522, -1214.6797, 1830.6016, 40.9141, 0.25);

	SetPVarString(playerid,"PlI_ChatColor","default");
	SetPVarInt(playerid,"Animations",0);
	SetPVarInt(playerid,"PlB_CantOpenMenu",0);
    SetPVarInt(playerid,"LockChat",0);
	SetPVarInt(playerid,"TSelectorEnabled",0);
	SetPVarInt(playerid,"PlayerTime_CurrentToChoose",0);
	SetPVarInt(playerid,"PlayerTime_Hours",1);
	SetPVarInt(playerid,"PlayerTime_Minutes",0);
	SetPVarInt(playerid,"PlayerWeather",801);
	SetPVarInt(playerid,"WSelectorEnabled",0);
	SetPVarInt(playerid,"PlayerCarNeon",18647);
	SetPVarInt(playerid,"NSelectorEnabled",0);
	SetPVarInt(playerid,"PlayerMoney",0);
	SetPVarInt(playerid,"PlayerCarColor1",0);
	SetPVarInt(playerid,"PlayerCarColor2",0);
	SetPVarInt(playerid,"CSelectorEnabled",0);
	SetPVarInt(playerid,"CSelectorCurrentColor",0);
	SetPVarInt(playerid,"PlayerTPID",-1);
	SetPVarInt(playerid,"PlF_FROnCTRL",1);
 	SetPVarInt(playerid,"PlF_ShowNickNames",1);
	SetPVarInt(playerid,"PlF_AutoRepair",1);
	SetPVarInt(playerid,"OpenedMMenu",0);
	SetPVarInt(playerid,"SpawnSkin",-1);
	SetPVarInt(playerid,"canTeleport",1);
	SetPVarInt(playerid,"SpawnedCar",0);
	SetPVarInt(playerid,"inJail",0);
	SetPVarInt(playerid,"PlayerKMWID",-1);
	SetPVarInt(playerid,"TempoGID",-1);
	SetPVarInt(playerid,"LicenseForMakeGang",0);
	
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerDisconnect(playerid, reason)
{
/*    new cnstr[128];
	format(cnstr,sizeof(cnstr),"{E3E3E3}%s {C6C6C6}отключился(ась) от сервера",PlayerName(playerid));
	SendClientMessageToAll(-1,cnstr);   */
	
	KillTimer(PlayerUpdateTimer[playerid]);
	if(GetPVarInt(playerid,"SpawnedCar"))
	{
		DestroyVehicle(car[playerid]);
	}
	
	UpdatePlayerSettings(playerid);
	
	DeInitialize(playerid);
	
	DeletePVar(playerid,"PlI_ChatColor");
	DeletePVar(playerid,"PlayerAttCBone");
	DeletePVar(playerid,"PlayerAttCSlot");
	DeletePVar(playerid,"TempoGGangPID");
	DeletePVar(playerid,"TempoGGang");
	DeletePVar(playerid,"TempoGRank");
	DeletePVar(playerid,"TempoGRSkin");
	DeletePVar(playerid,"TempoGColor");
	DeletePVar(playerid,"TempoGName");
	DeletePVar(playerid,"LicenseForMakeGang");
	DeletePVar(playerid,"TempoGID");
	DeletePVar(playerid,"PGangID");
	DeletePVar(playerid,"TSelectorEnabled");
	DeletePVar(playerid,"PlayerTime_CurrentToChoose");
	DeletePVar(playerid,"PlayerTime_Hours");
	DeletePVar(playerid,"PlayerTime_Minutes");
	DeletePVar(playerid,"PlayerWeather");
	DeletePVar(playerid,"WSelectorEnabled");
	DeletePVar(playerid,"PlayerCarNeon");
	DeletePVar(playerid,"NSelectorEnabled");
	DeletePVar(playerid,"PlayerMoney");
	DeletePVar(playerid,"SpawnedCar");
	DeletePVar(playerid,"canTeleport");
	DeletePVar(playerid,"inJail");
	DeletePVar(playerid,"SpawnSkin");
	DeletePVar(playerid,"OpenedMMenu");
 	DeletePVar(playerid,"PlF_ShowNickNames");
	DeletePVar(playerid,"PlF_AutoRepair");
	DeletePVar(playerid,"PlayerTPID");
	DeletePVar(playerid,"PlayerKMWID");
	DeletePVar(playerid,"PlayerCarColor1");
	DeletePVar(playerid,"PlayerCarColor2");
	DeletePVar(playerid,"CSelectorEnabled");
	DeletePVar(playerid,"CSelectorCurrentColor");
	DeletePVar(playerid,"LockChat");
	DeletePVar(playerid,"PlB_CantOpenMenu");
	DeletePVar(playerid,"Animations");
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerSpawn(playerid)
{
	KillTimer(PlayerUpdateTimer[playerid]);
	PlayerUpdateTimer[playerid] = SetTimerEx("OnPlayerUPD",1000,true,"%i",playerid);
	
	if(GetPVarInt(playerid,"SpawnSkin")!=-1) SetPlayerSkin(playerid,GetPVarInt(playerid,"SpawnSkin"));
	if(GetPlayerGangID(playerid)!=INVALID_GANG_ID && GangExists(GetPlayerGangID(playerid)) && GetPlayerGangRankSkin(playerid,GetPlayerGangRank(playerid))!=0)
	{
	    SetPlayerSkin(playerid,GetPlayerGangRankSkin(playerid,GetPlayerGangRank(playerid)));
	    SetPVarInt(playerid,"SpawnSkin",GetPlayerGangRankSkin(playerid,GetPlayerGangRank(playerid)));
	}
	
	GivePlayerWeapon(playerid,43,9999);

	UpdatePlayerSettings(playerid);
	
	TextDrawShowForPlayer(playerid,site);
	TextDrawShowForPlayer(playerid,Clock);

	if(!GetPVarInt(playerid, "Animations")) PreloadAnimLib(playerid);
	
	if(GetPVarInt(playerid,"PGangID")!=INVALID_GANG_ID)
	{
	    new spawnpos[4];
	    
	    spawnpos = GetPlayerGangSpawn(playerid);
	    if(spawnpos[0]==0.0 && spawnpos[1]==0.0 && spawnpos[2]==0.0)
	    {
	        SetPlayerPos(playerid,1131.4585,-1773.7101,-96.2141);
			SetPlayerFacingAngle(playerid,115.3225);
	    }
	    else
	    {
		    SetPlayerPos(playerid,spawnpos[0],spawnpos[1],spawnpos[2]);
		    SetPlayerFacingAngle(playerid,spawnpos[3]);
		}
	    
	    return 1;
	}
	
	SetPlayerPos(playerid,1131.4585,-1773.7101,-96.2141);
	SetPlayerFacingAngle(playerid,115.3225);
	
	
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerDeath(playerid, killerid, reason)
{
	SendDeathMessage(killerid, playerid, reason);
	
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerText(playerid, text[])
{
	if(!strfind(text,")",true))
	{
		OnPlayerCommandText(playerid, "/me улыбается");
		return 0;
	}
	if(!strfind(text,":)",true))
	{
		OnPlayerCommandText(playerid, "/me улыбается");
		return 0;
	}
	if(!strfind(text,"=)",true))
	{
		OnPlayerCommandText(playerid, "/me улыбается");
		return 0;
	}
	if(!strfind(text,":D",true))
	{
		OnPlayerCommandText(playerid, "/me смеётся");
		return 0;
	}
	if(!strfind(text,"xD",true))
	{
		OnPlayerCommandText(playerid, "/me смеётся");
		return 0;
	}
	if(!strfind(text,"=D",true))
	{
		OnPlayerCommandText(playerid, "/me смеётся");
		return 0;
	}
	
	if(GetPVarInt(playerid,"LockChat"))
	{
	    SendClientMessage(playerid,-1,"{FFFFFF}В чат можно отправлять {BAA530}не более {FFFFFF}одного сообщения один раз в 2 секунды");
	    return 0;
	}
	
	if(GetPVarInt(playerid,"PGangID")!=INVALID_GANG_ID)
	{
	    new msg[1024];
	    if(!GetPVarInt(playerid,"Authorized") || !GetPVarInt(playerid,"Registered"))
		{
			format(msg,sizeof(msg),"{%s}[%s]%s(%i): {EAFF00}*{%s}%s",
			GetPlayerGangColor(playerid),GetPlayerGangName(playerid),PlayerName(playerid),playerid,GetPlayerChatColor(playerid),text);
		}
		else
		{
			format(msg,sizeof(msg),"{%s}[%s]%s(%i): {%s}%s",
			GetPlayerGangColor(playerid),GetPlayerGangName(playerid),PlayerName(playerid),playerid,GetPlayerChatColor(playerid),text);
		}
		SendClientMessageToAll(-1,msg);
		SetPVarInt(playerid,"LockChat",1);
		SetTimerEx("UnlockChat",2*1000,false,"%i",playerid);
	    return 0;
	}
	
	new strtmp[512];
	if(!GetPVarInt(playerid,"Authorized") || !GetPVarInt(playerid,"Registered"))
	{
		format(strtmp,sizeof(strtmp),"%s(%i): {EAFF00}*{%s}%s",PlayerName(playerid),playerid,GetPlayerChatColor(playerid),text);
	}
	else
	{
		format(strtmp,sizeof(strtmp),"%s(%i): {%s}%s",PlayerName(playerid),playerid,GetPlayerChatColor(playerid),text);
	}
	SendClientMessageToAll(GetPlayerColor(playerid),strtmp);
	SetPVarInt(playerid,"LockChat",1);
	SetTimerEx("UnlockChat",2*1000,false,"%i",playerid);
	return 0;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerCommandText(playerid, cmdtext[])
{
	new CMD[512],idx,tmp[512];
	CMD = strtok(cmdtext,idx);
	
	command("/flip")
	{
	    if(!IsPlayerInAnyVehicle(playerid)) return 1;
	    if(GetPlayerState(playerid)!=PLAYER_STATE_DRIVER) return 1;
	    
	    new vehid, Float:x, Float:y, Float:z, Float:angle;
		vehid = GetPlayerVehicleID(playerid);
		GetVehiclePos(vehid, x, y, z);
		GetVehicleZAngle(vehid, angle);
		SetVehiclePos(vehid, x, y, z);
		SetVehicleZAngle(vehid, angle);
		RepairVehicle(vehid);
		
	    return 1;
	}
	command("/acceptgang")
	{
		if(GetPlayerGangID(playerid)!=INVALID_GANG_ID) return 1;
		
		tmp = strtok(cmdtext,idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}/acceptgang [ID игрока]");
		    return 1;
		}
		new tplayerid = strval(tmp);
		if(tplayerid==playerid) return 1;
		if(!IsPlayerConnected(tplayerid))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок не в сети");
			return 1;
		}
		if(!GetPVarInt(playerid,"TempoGGang")) return 1;
		if(GetPVarInt(playerid,"TempoGGangPID")!=tplayerid)
		{
		    SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок не предлагал вам получить лидерство над своей бандой");
		    return 1;
		}
		
		SetPlayerGangID(playerid,GetPlayerGangID(tplayerid));
		SetPlayerGangRank(playerid,GSYS_RANK_MAX);
		SetPlayerGangRank(tplayerid,GSYS_RANK_MAX-1);
		SetPVarInt(tplayerid,"TempoGGang",0);
		SetPVarInt(tplayerid,"TempoGGangPID",-1);
		
		new fmsg[512];
		format(fmsg,sizeof(fmsg),"{00FCFF}[Чат банды] %s передал лидерство над бандой %s",
		PlayerName(tplayerid),PlayerName(playerid));
		for(new p=0; p<MAX_PLAYERS; p++)
	    {
	        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
	        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;

	        SendClientMessage(p,-1,fmsg);
	    }
		
	    return 1;
	}
	command("/givemygang")
	{
	    if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
	    if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return 1;
	    
	    tmp = strtok(cmdtext,idx);
	    if(!strlen(tmp))
	    {
	        SendClientMessage(playerid,-1,"{FFFFFF}/givemygang [ID игрока]");
	        return 1;
	    }
	    new newglid = strval(tmp);
	    if(newglid==playerid) return 1;
	    if(!IsPlayerConnected(newglid))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок не в сети");
			return 1;
		}
		if(GetPlayerGangID(newglid)!=INVALID_GANG_ID)
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок состоит в другой банде");
		    return 1;
		}
		SetPVarInt(newglid,"TempoGGang",1);
		SetPVarInt(newglid,"TempoGGangPID",playerid);
		
		new msg[1024];
		format(msg,sizeof(msg),"{BAA530}%s {FFFFFF}хочет передать вам лидерство над своей бандой. Введите {BAA530}/acceptgang %i{FFFFFF}, чтобы стать лидером банды",
		PlayerName(playerid),playerid);
		SendClientMessage(newglid,-1,msg);
	    
	    return 1;
	}
	command("/setgcolor")
	{
	    if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
	    if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return 1;
	
	    tmp=strtok(cmdtext,idx);
	    if(strlen(tmp)!=6)
		{
			SendClientMessage(playerid,-1,"{FFFFFF}/setgcolor [цвет в формате RRGGBB]");
			return 1;
		}
		
		SetPlayerGangColor(playerid,tmp);
		SendClientMessage(playerid,-1,"{FFFFFF}Цвет изменён");
		return 1;
	}
	command("/setgname")
	{
	    if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
	    if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return 1;

	    tmp=strtok(cmdtext,idx);
	    if(strlen(tmp)<5)
		{
			SendClientMessage(playerid,-1,"{FFFFFF}/setgname [название]");
			return 1;
		}

		SetPlayerGangName(playerid,tmp);
		SendClientMessage(playerid,-1,"{FFFFFF}Название изменено");
	    return 1;
	}
	command("/invite")
	{
	    if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
	    if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX-2) return 1;
	    
	    tmp=strtok(cmdtext,idx);
	    if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}/invite [ID игрока]");
			return 1;
		}
		new tplayerid = strval(tmp);
		if(tplayerid==playerid) return 1;
		if(!IsPlayerConnected(tplayerid))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок не в сети");
			return 1;
		}
		if(GetPlayerGangID(tplayerid)!=INVALID_GANG_ID)
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок уже состоит в банде");
		    return 1;
		}
		
	    new msg[512],fmsg[512];
		format(msg,sizeof(msg),"{FFFFFF}%s {BAA530}%s {FFFFFF}приглашает вас в банду {%s}%s{FFFFFF}",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),GetPlayerGangColor(playerid),GetPlayerGangName(playerid));
		format(fmsg,sizeof(fmsg),"{00FCFF}[Чат банды] %s %s пригласил %s в банду",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),PlayerName(tplayerid));
		for(new p=0; p<MAX_PLAYERS; p++)
	    {
	        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
	        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;
	        
	        SendClientMessage(p,-1,fmsg);
	    }
		ShowPlayerDialog(tplayerid,DIALOG_GANG_INVITE,DIALOG_STYLE_MSGBOX,"Приглашение в банду",msg,"Вступить",DIALOG_BUTTON_CLOSE_TEXT);

		SetPVarInt(tplayerid,"TempoGID",GetPlayerGangID(playerid));
	    return 1;
	}
	command("/uninvite")
	{
		if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
	    if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX-1) return 1;

	    tmp=strtok(cmdtext,idx);
	    if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}/uninvite [ID игрока]");
			return 1;
		}
		new tplayerid = strval(tmp);
		if(tplayerid==playerid) return 1;
		if(!IsPlayerConnected(tplayerid))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок не в сети");
			return 1;
		}
		if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		if(GetPlayerGangID(playerid)!=GetPlayerGangID(playerid)) return 1;
		
		SetPlayerGangID(tplayerid,INVALID_GANG_ID);
		SetPlayerGangRank(tplayerid,GSYS_RANK_MIN-1);

	    new msg[512],fmsg[512];
		format(msg,sizeof(msg),"{FFFFFF}%s {BAA530}%s уволил вас из банды \"%s\"",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),GetPlayerGangName(playerid));
		format(fmsg,sizeof(fmsg),"{00FCFF}[Чат банды] %s %s уволил %s",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),PlayerName(tplayerid));
		for(new p=0; p<MAX_PLAYERS; p++)
	    {
	        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
	        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;

	        SendClientMessage(p,-1,fmsg);
	    }
		ShowPlayerDialog(tplayerid,DIALOG_GANG_UNINVITE,DIALOG_STYLE_MSGBOX,"Увольнение из банды",msg,DIALOG_BUTTON_CLOSE_TEXT,"");
	    return 1;
	}
	command("/giverank")
	{
	    if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
	    if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return 1;
	    
	    tmp=strtok(cmdtext,idx);
	    if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}/giverank [ID игрока] [ранг]");
			return 1;
		}
		new tplayerid = strval(tmp);
		if(tplayerid==playerid) return 1;
		if(!IsPlayerConnected(tplayerid))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок не в сети");
			return 1;
		}
		if(GetPlayerGangID(tplayerid)!=GetPlayerGangID(playerid))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок не в вашей банде");
		    return 1;
		}
		
		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}/giverank [ID игрока] [ранг]");
			return 1;
		}
		
		new rank = strval(tmp);
		NonValid:rank(GSYS_RANK_MIN,GSYS_RANK_MAX-1)
		{
		    SendClientMessage(playerid,-1,"{FFFFFF}Вы ошиблись при вводе ранга");
			return 1;
		}
		
		SetPlayerGangRank(tplayerid,rank);
		new cmdmsg[512];
		format(cmdmsg,sizeof(cmdmsg),"{FFFFFF}Вы выдали игроку {BAA530}%s {FFFFFF}ранг {BAA530}%i",PlayerName(tplayerid),rank);
		SendClientMessage(playerid,-1,cmdmsg);
		format(cmdmsg,sizeof(cmdmsg),"{FFFFFF}%s {BAA530}%s {FFFFFF}выдал вам ранг {BAA530}%i",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),rank);
		SendClientMessage(tplayerid,-1,cmdmsg);
		format(cmdmsg,sizeof(cmdmsg),"{00FCFF}[Чат банды] %s %s выдал %i ранг %s",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),rank,PlayerName(tplayerid));
		for(new p=0; p<MAX_PLAYERS; p++)
	    {
	        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
	        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;

	        SendClientMessage(p,-1,cmdmsg);
	    }
		
	    return 1;
	}
	command("/ganglic")
	{
	    if(!IsPlayerAdmin(playerid)) return 1;
	    
	    tmp=strtok(cmdtext,idx);
	    if(!strlen(tmp))
	    {
	        SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift RCON] {FFFFFF}/ganglic [ID игрока]");
	        return 1;
	    }
	    new gpl = strval(tmp);
	    if(!IsPlayerConnected(gpl))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Этот игрок не в сети");
			return 1;
		}
	    
	    new ptmp[512];
	    switch(GetPVarInt(gpl,"LicenseForMakeGang"))
	    {
	    case 0:
			{
			    format(ptmp,sizeof(ptmp),"{FFFFFF}Администратор {BAA530}%s {FFFFFF}выдал вам разрешение на создание банды",PlayerName(playerid));
				SetPVarInt(gpl,"LicenseForMakeGang",1);
				SendClientMessage(gpl,-1,ptmp);
				format(ptmp,sizeof(ptmp),"{FFFFFF}Вы выдали {BAA530}%s {FFFFFF}разрешение на создание банды",PlayerName(gpl));
				SendClientMessage(playerid,-1,ptmp);
			}
		case 1:
		    {
		        format(ptmp,sizeof(ptmp),"{FFFFFF}Администратор {BAA530}%s {FFFFFF}отнял у вас разрешение на создание банды",PlayerName(playerid));
				SetPVarInt(gpl,"LicenseForMakeGang",0);
				SendClientMessage(gpl,-1,ptmp);
				format(ptmp,sizeof(ptmp),"{FFFFFF}Вы отняли у {BAA530}%s {FFFFFF}разрешение на создание банды",PlayerName(gpl));
				SendClientMessage(playerid,-1,ptmp);
		    }
		default: return 1;
	    }
	    
	    return 1;
	}
	command("/f")
	{
	    if(GetPVarInt(playerid,"PGangID")==INVALID_GANG_ID) return 1;
	    
	    tmp=strrest(cmdtext,idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{FFFFFF}/f [сообщение]");
			return 1;
		}
		if(!strfind(tmp,")")) tmp = "{79FDFF}*улыбается*";
		if(!strfind(tmp,"=)")) tmp = "{79FDFF}*улыбается*";
		if(!strfind(tmp,":)")) tmp = "{79FDFF}*улыбается*";
		if(!strfind(tmp,":D")) tmp = "{79FDFF}*смеётся*";
		if(!strfind(tmp,"xD")) tmp = "{79FDFF}*смеётся*";
		if(!strfind(tmp,"=D")) tmp = "{79FDFF}*смеётся*";
		
		new msg[2048];
	    format(msg,sizeof(msg),"{00FCFF}[Чат банды] %s %s(%i): %s",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),playerid,tmp);
	        
	    for(new p=0; p<MAX_PLAYERS; p++)
	    {
	        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
	        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;

	        SendClientMessage(p,-1,msg);
	    }
	    
	    return 1;
	}
	command("/flowers")
	{
		new givefplayerid,strtmp[512];
		
		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}/flowers [ID игрока]");
		givefplayerid=strval(tmp);
		if(givefplayerid==playerid) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при использовании команды: {BAA530}вы указали свой ID");
		
		format(strtmp,sizeof(strtmp),"{BAA530}%s {FFFFFF}подарил вам букет цветов",PlayerName(playerid));
		GivePlayerWeapon(givefplayerid,14,1);
		SendClientMessage(givefplayerid,-1,strtmp);
		return 1;
	}
	command("/kiss")
	{
		new kissplayerid,strtmp[512];

		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}/kiss [ID игрока]");
		kissplayerid=strval(tmp);
		if(kissplayerid==playerid) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при использовании команды: {BAA530}вы указали свой ID");
		
		format(strtmp,sizeof(strtmp),"{BAA530}%s(%i) {FFFFFF}хочет вас поцеловать. Введите {BAA530}/acceptkiss %i {FFFFFF}для согласия",PlayerName(playerid),playerid,playerid);
		SendClientMessage(kissplayerid,-1,strtmp);
		SendClientMessage(playerid,-1,"{FFFFFF}Запрос отправлен");
		SetPVarInt(kissplayerid,"PlayerKMWID",playerid);
		KissTimer[kissplayerid] = SetTimerEx("CancelKiss",60000,false,"%i",kissplayerid);

		return 1;
	}
	command("/acceptkiss")
	{
		new kissmewantplayerid,strtmp[512];
		
		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}/acceptkiss [ID игрока]");
		kissmewantplayerid=strval(tmp);
		if(kissmewantplayerid==playerid) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при использовании команды: {BAA530}вы указали свой ID");
		if(GetPVarInt(playerid,"PlayerKMWID")!=kissmewantplayerid) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка: {BAA530}запроса на поцелуй к вам от этого игрока не было, либо истекло время ожидания подтверждения (10 секунд)");
		
		format(strtmp,sizeof(strtmp),"{BAA530}%s {FFFFFF}и {BAA530}%s {FFFFFF}поцеловались!",PlayerName(playerid),PlayerName(kissmewantplayerid));
		SendClientMessageToAll(-1,strtmp);
		
		return 1;
	}
	command("/tp")
	{
		new gotoplayerid,strtmp[512];
		
		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}/tp [ID игрока]");
		gotoplayerid=strval(tmp);
		if(GetPVarInt(gotoplayerid,"PlayerTPID")==playerid) return SendClientMessage(playerid,-1,"{FFFFFF}Вы уже отправили запрос на телепорт к этому игроку");
		if(gotoplayerid==playerid) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при использовании команды: {BAA530}вы указали свой ID");
		
		format(strtmp,sizeof(strtmp),"{BAA530}%s(%i) {FFFFFF}хочет телепортироваться к вам. Введите {BAA530}/accepttp %i {FFFFFF}для согласия",PlayerName(playerid),playerid,playerid);
		SendClientMessage(gotoplayerid,-1,strtmp);
		SendClientMessage(playerid,-1,"{FFFFFF}Запрос отправлен");
		SetPVarInt(gotoplayerid,"PlayerTPID",playerid);
		TPTimer[gotoplayerid] = SetTimerEx("CancelTeleport",60000,false,"%i",gotoplayerid);
		
		return 1;
	}
	command("/accepttp")
	{
		new tpplayerid,strtmp[512];
		
		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}/accepttp [ID игрока]");
		tpplayerid=strval(tmp);
		if(tpplayerid==playerid) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при использовании команды: {BAA530}вы указали свой ID");
		if(GetPVarInt(playerid,"PlayerTPID")!=tpplayerid) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка: {BAA530}запроса на телепорт к вам от этого игрока не было, либо истекло время ожидания подтверждения (10 секунд)");
		
		KillTimer(TPTimer[playerid]);
		
		new Float:tmpcrd[5];
		GetPlayerFacingAngle(playerid,tmpcrd[0]);
		GetPlayerPos(playerid,tmpcrd[1],tmpcrd[2],tmpcrd[3]);
		if(!IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerPos(GetPVarInt(playerid,"PlayerTPID"),tmpcrd[1],tmpcrd[2],tmpcrd[3]+1.1);
			SetPlayerFacingAngle(GetPVarInt(playerid,"PlayerTPID"),tmpcrd[0]);
		}
		else
		{
		    SetVehiclePos(GetPlayerVehicleID(GetPVarInt(playerid,"PlayerTPID")),tmpcrd[1],tmpcrd[2],tmpcrd[3]+1.1);
		    SetVehicleZAngle(GetPVarInt(playerid,"PlayerTPID"),tmpcrd[0]);
		}
		
		format(strtmp,sizeof(strtmp),"{FFFFFF}Вы телепортировались к {BAA530}%s(%i)",PlayerName(playerid),playerid);
		SendClientMessage(GetPVarInt(playerid,"PlayerTPID"),-1,strtmp);
		
		SetPVarInt(playerid,"PlayerTPID",-1);
		
		return 1;
	}
	command("/help")
	{
		ShowPlayerDialog(playerid,DIALOG_HELP_MAIN,DIALOG_STYLE_LIST,"Помощь","Важные даты\nГорячие клавиши\nКоманды\nОписание настраиваемых функций",DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_CLOSE_TEXT);
		return 1;
	}
	command("/menu")
	{
		if(	IsPlayerInRangeOfPoint(playerid,50.0,1131.4585,-1773.7101,-96.2141)
			|| GetPVarInt(playerid,"PlB_CantOpenMenu")							)
		return SendClientMessage(playerid,-1,"{FFFFFF}Здесь запрещено открывать меню");
		
		ShowPlayerDialog(playerid,DIALOG_MAINMENU,DIALOG_STYLE_LIST,"Pro100Drift",
		"{00FF8A}Тюнинг\n{B400FF}Транспорт\n{C0FF00}Оружие\n{FF7E00}Телепорты\n{FFEA00}Помощь\n{00A2FF}Радио\n{FFBB00}Моя банда\n{C6C6C6}Настройки\n{C9FF00}Перевернуть авто\n{00759C}Пополнить здоровье и броню"/*\n{00FFC6}Достижения*/,
		DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_CLOSE_TEXT);
		return 1;
	}
	command("/w")
	{
		new strtmp[MAX_STRING],ssWid,msg[512];
		
		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}/w [ID игрока] [сообщение]");
		
		ssWid=strval(tmp);
		if(ssWid==playerid) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при отправке сообщения. Причина: {BAA530}вы указали свой ID");
		
		tmp=strrest(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при отправке сообщения. Причина: {BAA530}неверная длина сообщения");
		msg=tmp;
		
		format(strtmp,sizeof(strtmp),"{FFC125}[Исходящее ЛС]%s(%i): %s",PlayerName(ssWid),ssWid,msg);
		SendClientMessage(playerid,-1,strtmp);
		format(strtmp,sizeof(strtmp),"{FFC125}[Входящее ЛС]%s(%i): %s",PlayerName(playerid),playerid,msg);
		SendClientMessage(ssWid,-1,strtmp);
		
		return 1;
	}
	command("/pay")
	{
		new giveplayerid,summa,strtmp[MAX_STRING];
		
		tmp = strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}/pay [ID игрока] [сумма]");
		
		giveplayerid = strval(tmp);
		if(giveplayerid==playerid) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при переводе денег. Причина: {BAA530}вы указали свой ID");
		
		tmp = strtok(cmdtext,idx);
		summa = strval(tmp);
		if(summa<0) summa = summa * -1;
		
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при переводе денег. Причина: {BAA530}неверный ID игрока-получателя");
		if(GetPlayerMoney(playerid)<summa) return SendClientMessage(playerid,-1,"{FFFFFF}Ошибка при переводе денег. Причина: {BAA530}неверная сумма");
		
		GivePlayerMoney(giveplayerid, summa);
		GivePlayerMoney(playerid,summa * -1);
		
		format(strtmp,sizeof(strtmp),"{FFFFFF}Вы получили денежную сумму в размере {BAA530}%i$ {FFFFFF}от {BAA530}%s",summa,PlayerName(playerid));
		SendClientMessage(giveplayerid,-1,strtmp);
		format(strtmp,sizeof(strtmp),"{FFFFFF}Вы перевели денежную сумму в размере {BAA530}%i$ {FFFFFF}игроку {BAA530}%s",summa,PlayerName(giveplayerid));
		SendClientMessage(playerid,-1,strtmp);
		return 1;
	}
	command("/hi")
	{
		if(hicmd[playerid]) return SendClientMessage(playerid,-1,"{FFFFFF}Вы уже приветствовали игроков");
		
		new strtmp[MAX_STRING];
		format(strtmp,sizeof(strtmp),"{BAA530}%s {FFFFFF}приветствует {BAA530}всех{FFFFFF}!",PlayerName(playerid));
		SendClientMessageToAll(0xFFFFFFFF,strtmp);
		hicmd[playerid]=true;
		return 1;
	}
	command("/bb")
	{
		if(bbcmd[playerid]) return SendClientMessage(playerid,-1,"{FFFFFF}Вы уже прощались с игроками");
		
		new strtmp[MAX_STRING];
		format(strtmp,sizeof(strtmp),"{BAA530}%s {FFFFFF}прощается {BAA530}со всеми{FFFFFF}!",PlayerName(playerid));
		SendClientMessageToAll(0xFFFFFFFF,strtmp);
		bbcmd[playerid]=true;
		return 1;
	}
	command("/me")
	{
		tmp = strrest(cmdtext,idx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}/me [действие]");
		
		new strtmp[MAX_STRING];
		format(strtmp,sizeof(strtmp),"{BAA530}%s {FFFFFF}%s",PlayerName(playerid),tmp);
		SendClientMessageToAll(-1,strtmp);
		return 1;
	}
	
	command_alias("/pay","/givecash");
	command_alias("/pay","/givemoney");
	command_alias("/menu","/mm");
	command_alias("/menu","/меню");
	command_alias("/w","/sms");
	command_alias("/w","/лс");
	command_alias("/w","/pm");
	
	SendClientMessage(playerid,-1,"{FFFFFF}Такой команды не существует. Введите {BAA530}/help {FFFFFF}для просмотра справки");
	
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerPickUpPickup(playerid, pickupid)
{
	pickup(pickup_spawnExit)
	{
		SetPlayerPos(playerid,1333.7190,-1863.4155,13.5469);
		SetPlayerFacingAngle(playerid,330.0076);
	}
	pickup(pickup_militaryVehicles)
	{
		if(!GetPVarInt(playerid,"OpenedMMenu"))
		{
			ShowModelSelectionMenu(playerid, militarylist, "‹oe®®a¬ ¦ex®њka", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
			SetPVarInt(playerid,"OpenedMMenu",1);
		}
		
		return 1;
	}
	pickups(pickup_BMXParkourVelo,pickup_SParkVelo)
	{
		if(!IsPlayerInAnyVehicle(playerid) && !GetPVarInt(playerid,"OpenedMMenu"))
		{
			ShowModelSelectionMenu(playerid, bikeslist1, "‹eћocњЈeљЁ", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
			SetPVarInt(playerid,"OpenedMMenu",1);
			
			return 1;
		}
	}
	pickup(pickup_MTrialBikes)
	{
		if(!IsPlayerInAnyVehicle(playerid) && !GetPVarInt(playerid,"OpenedMMenu"))
		{
			ShowModelSelectionMenu(playerid, bikeslist2, "–o¦o њkћЁ", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
			SetPVarInt(playerid,"OpenedMMenu",1);

			return 1;
		}
	}
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(bodypart == 2)
	{
	    switch(GetPlayerStatLevel(playerid,"HeadshotMaster"))
	    {
	        case 0:
	        {
			    GameTextForPlayer(playerid,"~r~Headshot",1500,5);
			    SendClientMessage(playerid,-1,"{FFFFFF}Новое достижение: {FFE746}мастер стрельбы (уровень 1)");
			    SetPlayerStatLevel(playerid,"HeadshotMaster",1);
			}
			case 1:
			{
			    GameTextForPlayer(playerid,"~r~Headshot",1500,5);
			    SendClientMessage(playerid,-1,"{FFFFFF}Новое достижение: {FFE746}мастер стрельбы (уровень 2)");
			    SetPlayerStatLevel(playerid,"HeadshotMaster",2);
			}
			case 2:
			{
			    GameTextForPlayer(playerid,"~r~Headshot",1500,5);
			    SendClientMessage(playerid,-1,"{FFFFFF}Новое достижение: {FFE746}мастер стрельбы (уровень 3)");
			    SetPlayerStatLevel(playerid,"HeadshotMaster",3);
			}
			case 3:
			{
			    GameTextForPlayer(playerid,"~r~Headshot",1500,5);
			    SendClientMessage(playerid,-1,"{FFFFFF}Новое достижение: {FFE746}мастер стрельбы (уровень 4)");
			    SetPlayerStatLevel(playerid,"HeadshotMaster",4);
			}
			case 4:
			{
			    GameTextForPlayer(playerid,"~r~Headshot",1500,5);
			    SendClientMessage(playerid,-1,"{FFFFFF}Новое достижение: {FFE746}мастер стрельбы (уровень 5)");
			    SetPlayerStatLevel(playerid,"HeadshotMaster",5);
			}
		}
	}
	
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & 128) // Сохранение цветов\неона (пробел\spacebar)
	{
	    if(GetPVarInt(playerid,"TSelectorEnabled"))
		{
   			SetPVarInt(playerid,"TSelectorEnabled",0);
			GameTextForPlayer(playerid,"~w~Time ~y~saved",500,5);
			TextDrawHideForPlayer(playerid,stextdrwe[playerid]);
			return 1;
		}
		
		if(GetPVarInt(playerid,"WSelectorEnabled"))
		{
			SetPVarInt(playerid,"WSelectorEnabled",0);
			GameTextForPlayer(playerid,"~w~Weather ~b~saved",500,5);
			TextDrawHideForPlayer(playerid,stextdrwe[playerid]);
			return 1;
		}
		
		if(GetPVarInt(playerid,"NSelectorEnabled"))
		{
			AddVehicleNeon(GetPlayerVehicleID(playerid),GetPVarInt(playerid,"PlayerCarNeon"));
			SetPVarInt(playerid,"NSelectorEnabled",0);
			GameTextForPlayer(playerid,"~w~Neon ~y~saved",500,5);
			TextDrawHideForPlayer(playerid,stextdrwe[playerid]);
			return 1;
		}
		
		if(GetPVarInt(playerid,"CSelectorEnabled"))
		{
			SetPVarInt(playerid,"CSelectorEnabled",0);
			UpdateVehicleColor(playerid,GetPlayerVehicleID(playerid));
			TextDrawHideForPlayer(playerid,stextdrwe[playerid]);
			return 1;
		}
		
		return 1;
	}
	if(newkeys & 2048) // Листание цветов\неона\погоды + (num 8)
	{
	    new tmp[512];
	    if(GetPVarInt(playerid,"TSelectorEnabled"))
	    {
	        switch(GetPVarInt(playerid,"PlayerTime_CurrentToChoose"))
	        {
	            case 0:
	            {
	                if(GetPVarInt(playerid,"PlayerTime_Hours")==24) SetPVarInt(playerid,"PlayerTime_Hours",0);
	                else SetPVarInt(playerid,"PlayerTime_Hours",GetPVarInt(playerid,"PlayerTime_Hours")+1);
	                format(tmp,sizeof(tmp),"~w~The next ~b~hour");
	            }
	            case 1:
	            {
	                if(GetPVarInt(playerid,"PlayerTime_Minutes")==24) SetPVarInt(playerid,"PlayerTime_Minutes",0);
	                else SetPVarInt(playerid,"PlayerTime_Minutes",GetPVarInt(playerid,"PlayerTime_Minutes")+1);
	                format(tmp,sizeof(tmp),"~w~The next ~b~minute");
	            }
	            default: return 0;
	        }
	        SetPlayerTime(playerid,GetPVarInt(playerid,"PlayerTime_Hours"),GetPVarInt(playerid,"PlayerTime_Minutes"));
	        GameTextForPlayer(playerid,tmp,500,5);
	        return 1;
	    }
	    
		if(GetPVarInt(playerid,"WSelectorEnabled"))
		{
			if(GetPVarInt(playerid,"PlayerWeather")==802)
			{
				SetPVarInt(playerid,"PlayerWeather",0);
				SetWeatherFromPVar(playerid);
			}
			else
			{
				SetPVarInt(playerid,"PlayerWeather",GetPVarInt(playerid,"PlayerWeather") + 1);
				SetWeatherFromPVar(playerid);
			}
			GameTextForPlayer(playerid,"~g~The next ~w~weather",500,5);
			return 1;
		}
		
		if(GetPVarInt(playerid,"NSelectorEnabled"))
		{
			if(GetPVarInt(playerid,"PlayerCarNeon")==18653)
			{
				SetPVarInt(playerid,"PlayerCarNeon",18647);
				AddVehicleNeon(GetPlayerVehicleID(playerid),GetPVarInt(playerid,"PlayerCarNeon"));
			}
			else
			{
				SetPVarInt(playerid,"PlayerCarNeon",GetPVarInt(playerid,"PlayerCarNeon") + 1);
				AddVehicleNeon(GetPlayerVehicleID(playerid),GetPVarInt(playerid,"PlayerCarNeon"));
			}
			GameTextForPlayer(playerid,"~y~The next ~w~neon",500,5);
			return 1;
		}
		
		if(GetPVarInt(playerid,"CSelectorEnabled"))
		{
			switch(GetPVarInt(playerid,"CSelectorCurrentColor"))
			{
			case 0:
				{
					if(GetPVarInt(playerid,"PlayerCarColor1")==255) SetPVarInt(playerid,"PlayerCarColor1",0);
					else SetPVarInt(playerid,"PlayerCarColor1",GetPVarInt(playerid,"PlayerCarColor1") + 1);
				}
			case 1:
				{
					if(GetPVarInt(playerid,"PlayerCarColor2")==255) SetPVarInt(playerid,"PlayerCarColor2",0);
					else SetPVarInt(playerid,"PlayerCarColor2",GetPVarInt(playerid,"PlayerCarColor2") + 1);
				}
			default: return 0;
			}
			UpdateVehicleColor(playerid,GetPlayerVehicleID(playerid));
			return 1;
		}
		
		return 1;
	}
	if(newkeys & 4096) // Листание цветов\неона\погоды\времени - (num 2)
	{
	    if(GetPVarInt(playerid,"TSelectorEnabled"))
	    {
	        new tmp[512];
	        switch(GetPVarInt(playerid,"PlayerTime_CurrentToChoose"))
	        {
	            case 0:
	            {
	                if(GetPVarInt(playerid,"PlayerTime_Hours")==-1) SetPVarInt(playerid,"PlayerTime_Hours",23);
	                else SetPVarInt(playerid,"PlayerTime_Hours",GetPVarInt(playerid,"PlayerTime_Hours")-1);
	                format(tmp,sizeof(tmp),"~w~The prev ~y~hour");
	            }
	            case 1:
	            {
	                if(GetPVarInt(playerid,"PlayerTime_Minutes")==-1) SetPVarInt(playerid,"PlayerTime_Minutes",23);
	                else SetPVarInt(playerid,"PlayerTime_Minutes",GetPVarInt(playerid,"PlayerTime_Minutes")-1);
	                format(tmp,sizeof(tmp),"~w~The prev ~y~minute");
	            }
	            default: return 0;
	        }
	        SetPlayerTime(playerid,GetPVarInt(playerid,"PlayerTime_Hours"),GetPVarInt(playerid,"PlayerTime_Minutes"));
	        GameTextForPlayer(playerid,tmp,500,5);
	        return 1;
	    }
		if(GetPVarInt(playerid,"WSelectorEnabled"))
		{
			if(GetPVarInt(playerid,"PlayerWeather")==-1)
			{
				SetPVarInt(playerid,"PlayerWeather",801);
				SetWeatherFromPVar(playerid);
			}
			else
			{
				SetPVarInt(playerid,"PlayerWeather",GetPVarInt(playerid,"PlayerWeather") - 1);
				SetWeatherFromPVar(playerid);
			}
			GameTextForPlayer(playerid,"~b~Prev ~w~weather",500,5);
			return 1;
		}
		
		if(GetPVarInt(playerid,"NSelectorEnabled"))
		{
			if(GetPVarInt(playerid,"PlayerCarNeon")==18646)
			{
				SetPVarInt(playerid,"PlayerCarNeon",18652);
				AddVehicleNeon(GetPlayerVehicleID(playerid),GetPVarInt(playerid,"PlayerCarNeon"));
			}
			else
			{
				SetPVarInt(playerid,"PlayerCarNeon",GetPVarInt(playerid,"PlayerCarNeon") - 1);
				AddVehicleNeon(GetPlayerVehicleID(playerid),GetPVarInt(playerid,"PlayerCarNeon"));
			}
			GameTextForPlayer(playerid,"~b~Prev ~w~neon",500,5);
			return 1;
		}
		
		if(GetPVarInt(playerid,"CSelectorEnabled"))
		{
			switch(GetPVarInt(playerid,"CSelectorCurrentColor"))
			{
			case 0:
				{
					if(GetPVarInt(playerid,"PlayerCarColor1")==0) SetPVarInt(playerid,"PlayerCarColor1",255);
					else SetPVarInt(playerid,"PlayerCarColor1",GetPVarInt(playerid,"PlayerCarColor1")-1);
				}
			case 1:
				{
					if(GetPVarInt(playerid,"PlayerCarColor2")==0) SetPVarInt(playerid,"PlayerCarColor2",255);
					else SetPVarInt(playerid,"PlayerCarColor2",GetPVarInt(playerid,"PlayerCarColor2")-1);
				}
			default: return 0;
			}
			UpdateVehicleColor(playerid,GetPlayerVehicleID(playerid));
		}
		return 1;
	}
	if(newkeys & KEY_SUBMISSION) // Открытие меню и переключение цветов при выборе (2) + удаление неона + переключение между минутами и секундами при выборе времени
	{
		if(!IsPlayerInAnyVehicle(playerid)) return 0;
		
		if(GetPVarInt(playerid,"TSelectorEnabled"))
		{
			switch(GetPVarInt(playerid,"PlayerTime_CurrentToChoose"))
			{
			case 0:
				{
					SetPVarInt(playerid,"PlayerTime_CurrentToChoose",1);
					GameTextForPlayer(playerid,"~w~Choosed to ~b~minutes",500,5);
				}
			case 1:
				{
					SetPVarInt(playerid,"PlayerTime_CurrentToChoose",0);
					GameTextForPlayer(playerid,"~w~Choosed to ~b~hours",500,5);
				}
			default: return 0;
			}
			return 1;
		}
		
		if(GetPVarInt(playerid,"NSelectorEnabled"))
		{
			DestroyObject(VehicleNeon[GetPlayerVehicleID(playerid)][0]);
			DestroyObject(VehicleNeon[GetPlayerVehicleID(playerid)][1]);
			GameTextForPlayer(playerid,"~w~Neon ~g~deleted",500,5);
			SetPVarInt(playerid,"NSelectorEnabled",0);
			TextDrawHideForPlayer(playerid,stextdrwe[playerid]);
			return 1;
		}
		
		if(GetPVarInt(playerid,"CSelectorEnabled"))
		{
			switch(GetPVarInt(playerid,"CSelectorCurrentColor"))
			{
			case 0:
				{
					SetPVarInt(playerid,"CSelectorCurrentColor",1);
					GameTextForPlayer(playerid,"~w~Current changing color choosed to ~b~2",500,5);
				}
			case 1:
				{
					SetPVarInt(playerid,"CSelectorCurrentColor",0);
					GameTextForPlayer(playerid,"~w~Current changing color choosed to ~b~1",500,5);
				}
			}
			return 1;
		}

		OnPlayerCommandText(playerid,"/menu");
		
		return 1;
	}
	if(newkeys & KEY_WALK) // Открытие меню (ALT)
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			OnPlayerCommandText(playerid,"/menu");
			return 1;
		}
	}
	if(newkeys == 1 || newkeys == 9 || newkeys == 33 && oldkeys != 1 || oldkeys != 9 || oldkeys != 33)
	{
		new Car = GetPlayerVehicleID(playerid), Model = GetVehicleModel(Car);
		switch(Model)
		{
		case 446,432,448,452,424,453,454,461,462,463,468,471,430,472,449,473,481,484,493,495,509,510,521,538,522,523,532,537,570,581,586,590,569,595,604,611: return 0;
		}
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		return 1;
	}
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerUPD(playerid)
{
	if(GetPVarInt(playerid,"PlF_AutoRepair")) AutoRepair(playerid);
	
	AntiWeaponHack(playerid);
	
	if(GetPVarInt(playerid,"PGangID")!=INVALID_GANG_ID)
	{
	    if(!GangExists(GetPVarInt(playerid,"PGangID")))
	    {
	        new tmp[512];
	        format(tmp,sizeof(tmp),GSYS_PFILEPATH,PlayerName(playerid));
	        dini_IntSet(tmp,"GangID",INVALID_GANG_ID);
	        SetPVarInt(playerid,"PGangID",INVALID_GANG_ID);
	    }
	}
	
	if(GetPlayerGangID(playerid)!=INVALID_GANG_ID)
    {
        if(!GangExists(GetPlayerGangID(playerid))) return SetPlayerColor(playerid,PlayerColors[playerid]);
        new tmpc,tmps[128];
        format(tmps,sizeof(tmps),"%sFF",GetPlayerGangColor(playerid));
		tmpc = HexToInt(tmps);
		SetPlayerColor(playerid,tmpc);
	}
	else SetPlayerColor(playerid,PlayerColors[playerid]);
	
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerUpdate(playerid)
{
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	for(new i; i<strlen(inputtext); i++) if(inputtext[i]=='%') inputtext[i]='#';

	if(dialogid==DIALOG_GANG_END || dialogid==DIALOG_GANG_UNINVITE) return 1;
	if(dialogid==DIALOG_GANG_RSKINS)
	{
	    if(!response) return 1;
	    
	    new msg[512],skinid;
	    skinid = GetPlayerGangRankSkin(playerid,listitem+1);
	    if(skinid==0) format(msg,sizeof(msg),"нет");
	    else format(msg,sizeof(msg),"%i",skinid);
	    if(strfind(msg,"нет")==-1)
	    {
		    format(msg,sizeof(msg),"{FFFFFF}ID скина: {FFA200}%s {C6C6C6}(кликните, чтобы просмотреть)\n{96FF00}Изменить\n{96FF00}Удалить",msg);
		}
		else
		{
		    format(msg,sizeof(msg),"{FFFFFF}ID скина: {FFA200}%s\n{96FF00}Изменить\n{020202}Удалить",msg);
		}
	    ShowPlayerDialog(playerid,DIALOG_GANG_RSKIN,DIALOG_STYLE_LIST,"Скин ранга",msg,DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
	    SetPVarInt(playerid,"TempoGRSkin",skinid);
	    SetPVarInt(playerid,"TempoGRank",listitem+1);
	    
	    return 1;
	}
	if(dialogid==DIALOG_GANG_RSKIN)
	{
	    if(!response)
	    {
			new msg[512],grskin[GSYS_RANK_MAX];
			for(new s=1; s<GSYS_RANK_MAX+1; s++)
			{
				grskin[s-1] = GetPlayerGangRankSkin(playerid,s);
				format(msg,sizeof(msg),"%s{FFFFFF}%i ранг: скин %i {C6C6C6}[Просмотреть/Изменить]\n",msg,s,grskin[s-1]);
			}
	        ShowPlayerDialog(playerid,DIALOG_GANG_RSKINS,DIALOG_STYLE_LIST,"Скины банды",msg,
	        DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_CLOSE_TEXT);
	        
	        return 1;
	    }
	    
	    switch(listitem)
	    {
	    case 0:
			{
			    SendClientMessage(playerid,-1,"{FFFFFF}Нажмите {FF0000}X{FFFFFF}, чтобы закрыть окно просмотра");
			    ShowSkinPreviewForPlayer(playerid,GetPVarInt(playerid,"TempoGRSkin"));
			}
		case 1:
		    {
			    SendClientMessage(playerid,-1,"{FFFFFF}Нажмите на скин, чтобы сохранить его");
				SendClientMessage(playerid,-1,"{FFFFFF}Нажмите {FF0000}X{FFFFFF}, чтобы выйти без сохранения скина");
			    ShowModelSelectionMenu(playerid, gskinslist, "Ckњ®Ё", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
			}
		case 2:
			{
			    SetPlayerGangRankSkin(playerid,GetPVarInt(playerid,"TempoGRank"),0);
			    if(!GetPlayerGangRankSkin(playerid,GetPVarInt(playerid,"TempoGRank"))) SendClientMessage(playerid,-1,"{FFFFFF}Скин удалён");
			}
		default: return 1;
		}
	    
	    return 1;
	}
	if(dialogid==DIALOG_GANG_MAINMENU)
	{
	    if(!response) return OnPlayerCommandText(playerid,"/menu");
	    
	    switch(listitem)
	    {
	    case 0:
	        {
	            ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_CONFIRM,DIALOG_STYLE_MSGBOX,"Создание банды",
				"{FFFFFF}Для создания банды вам нужно\n{BAA530}разрешение от администрации {FFFFFF}и {BAA530}1 500 000 $\n\n{FFFFFF}Если всё это у вас есть, то нажмите {BAA530}\"Далее\" ",
				"Далее","");
	        }
		case 1:
		    {
		        if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
				if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX-2) return SendClientMessage(playerid,-1,"{FFFFFF}Ваш ранг недостаточно высок, чтобы приглашать игроков в банду");
				
				SendClientMessage(playerid,-1,"{FFFFFF}Для приглашения игроков в банду используйте команду {BAA530}/invite");
				return 1;
		    }
		case 2:
		    {
		        if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
				if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX-1) return SendClientMessage(playerid,-1,"{FFFFFF}Ваш ранг недостаточно высок, чтобы увольнять членов банды");

				SendClientMessage(playerid,-1,"{FFFFFF}Для увольнения членов банды используйте команду {BAA530}/uninvite");
				return 1;
		    }
		case 3:
		    {
		        if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		        if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{FFFFFF}Ваш ранг недостаточно высок, чтобы повышать/понижать ранг членов банды");
		        
		        SendClientMessage(playerid,-1,"{FFFFFF}Для повышения/понижения ранга членов банды используйте команду {BAA530}/giverank");
				return 1;
		    }
		case 4:
		    {
		    	if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		        if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{FFFFFF}Ваш ранг недостаточно высок, чтобы менять скины членов банды");
		        
		        new msg[512],grskin[GSYS_RANK_MAX];
		        for(new s=1; s<GSYS_RANK_MAX+1; s++)
		        {
		            grskin[s-1] = GetPlayerGangRankSkin(playerid,s);
					format(msg,sizeof(msg),"%s{FFFFFF}%i ранг: скин %i {C6C6C6}[Просмотреть/Изменить]\n",msg,s,grskin[s-1]);
		        }
		        
		        ShowPlayerDialog(playerid,DIALOG_GANG_RSKINS,DIALOG_STYLE_LIST,"Скины банды",msg,
		        DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_CLOSE_TEXT);
		        return 1;
		    }
		case 5:
		    {
		        if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		        if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{FFFFFF}Ваш ранг недостаточно высок, чтобы изменять место спауна членов банды");
				
				SetPlayerGangSpawn(playerid);
				SendClientMessage(playerid,-1,"{FFFFFF}Место спауна успешно изменено");
				
				new msg[512];
			    format(msg,sizeof(msg),"{00FCFF}[Чат банды] %s %s поменял место спауна членов банды",
				GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid));

			    for(new p=0; p<MAX_PLAYERS; p++)
			    {
			        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
			        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;

			        SendClientMessage(p,-1,msg);
			    }
				return 1;
			}
		case 6:
		    {
		        if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		        if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{FFFFFF}Вы не лидер банды");
		        
		        SendClientMessage(playerid,-1,"{FFFFFF}Для передачи лидерства воспользуйтесь командой {BAA530}/givemygang");
		        
		        return 1;
		    }
		case 7:
		    {
		    	if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		    	if(GetPlayerGangRank(playerid)==GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{FFFFFF}Вы лидер банды и не можете просто так уйти из неё. Передайте лидерство другому игроку");
		    	
		    	SendClientMessage(playerid,-1,"{FFFFFF}Вы ушли из банды");
		    	SetPlayerGangID(playerid,INVALID_GANG_ID);
			    
		        return 1;
		    }
		default: return 1;
	    }
	    
		return 1;
	}
	if(dialogid==DIALOG_GANG_CREATE_CONFIRM && response)
	{
	    if(GetPlayerGangID(playerid)!=INVALID_GANG_ID) return SendClientMessage(playerid,-1,"{FFFFFF}Вы уже состоите в банде");
	    if(!GetPVarInt(playerid,"LicenseForMakeGang")) return SendClientMessage(playerid,-1,"{FFFFFF}У вас нет разрешения на создание банды от администрации");
	    if(GetPlayerMoney(playerid)<MONEY_FOR_CREATE_GANG) return SendClientMessage(playerid,-1,"{FFFFFF}У вас нет денег на создание банды (нужно {BAA530}1 500 000 ${FFFFFF})");
		ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_COLOR,DIALOG_STYLE_INPUT,
		"Создание банды: цвет","{FFFFFF}Введите цвет банды в формате {BAA530}RRGGBB{FFFFFF}:\n{C6C6C6}Например: FF0000","Ввод",DIALOG_BUTTON_CLOSE_TEXT);
		
		return 1;
	}
	if(dialogid==DIALOG_GANG_CREATE_COLOR && response)
	{
	    if(	strlen(inputtext)!=strlen("FFF000") || strfind(inputtext,"}")>=0 ||
	        strfind(inputtext,"{")>=0 ) return ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_COLOR,DIALOG_STYLE_INPUT,
		"{FF0000}Неверно введён цвет!\n\nСоздание банды: цвет","{FFFFFF}Введите цвет банды в формате {BAA530}RRGGBB{FFFFFF}:\n{C6C6C6}Например: FF0000","Ввод",DIALOG_BUTTON_CLOSE_TEXT);
		
		SetPVarString(playerid,"TempoGColor",inputtext);
		
		ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_NAME,DIALOG_STYLE_INPUT,"Создание банды: название","{FFFFFF}Введите название банды:\n{C6C6C6}Например: Уличные гонщики","Ввод","");
		
	    return 1;
	}
	if(dialogid==DIALOG_GANG_CREATE_NAME)
	{
	    if(!response) return ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_NAME,DIALOG_STYLE_INPUT,"Создание банды: название","{FFFFFF}Введите название банды:\n{C6C6C6}Например: Уличные гонщики","Ввод","");
	    
	    if( !strlen(inputtext) ) return ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_NAME,DIALOG_STYLE_INPUT,"Создание банды: название","{FF0000}Неверное название!\n\n{FFFFFF}Введите название банды:\n{C6C6C6}Например: Уличные гонщики","Ввод","");
	    
	    new color[128];
	    GetPVarString(playerid,"TempoGColor",color,sizeof(color));
	    new gid = CreateGang(color,inputtext);
	    SetPVarInt(playerid,"PGangID",gid);
	    SetPlayerGangID(playerid,gid);
	    SetPlayerGangRank(playerid,GSYS_RANK_MAX);
	    new msg[512];
	    format(msg,sizeof(msg),"{FFFFFF}Банда создана.\n\nЗапомните, а лучше запишите её ID: {BAA530}%i{FFFFFF}.\nОн, в дальнейшем, может понадобится вам",GetPlayerGangID(playerid));
	    ShowPlayerDialog(playerid,DIALOG_GANG_END,DIALOG_STYLE_MSGBOX,"Банда создана",msg,DIALOG_BUTTON_CLOSE_TEXT,"");
		SetPVarInt(playerid,"LicenseForMakeGang",0);
		GivePlayerMoney(playerid,-MONEY_FOR_CREATE_GANG);
		new tmpc,tmps[128];
        format(tmps,sizeof(tmps),"%sFF",GetPlayerGangColor(playerid));
		tmpc = HexToInt(tmps);
		SetPlayerColor(playerid,tmpc);
	    
	    return 1;
	}
	if(dialogid==DIALOG_GANG_INVITE && response)
	{
	    new tmpmsg[512];
	    SetPlayerGangID(playerid,GetPVarInt(playerid,"TempoGID"));
	    SetPlayerGangRank(playerid,GSYS_RANK_MIN);
	    format(tmpmsg,sizeof(tmpmsg),"{FFFFFF}Вы вступили в банду {BAA530}%s",GetPlayerGangName(playerid));
	    new fmsg[512];
	    format(fmsg,sizeof(fmsg),"{00FCFF}[Чат банды] %s %s вступил в банду",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid));
		for(new p=0; p<MAX_PLAYERS; p++)
	    {
	        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
	        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;

	        SendClientMessage(p,-1,fmsg);
	    }
	    SendClientMessage(playerid,-1,tmpmsg);
	    
	    return 1;
	}
	if(dialogid==DIALOG_TUNING_COLORS)
	{
		if(response)
		{
			SendClientMessage(playerid,-1,"{FFFFFF}Используйте клавиши {BAA530}num 8 {FFFFFF}и {BAA530}num 2 {FFFFFF}для предпросмотра цветов");
			SendClientMessage(playerid,-1,"{FFFFFF}Используйте клавишу {BAA530}2 {FFFFFF}для переключения между основным и дополнительным цветом");
			SendClientMessage(playerid,-1,"{FFFFFF}Нажмите {BAA530}spacebar {FFFFFF}для сохранения цветов");
			SetPVarInt(playerid,"CSelectorEnabled",1);
			UpdateVehicleColor(playerid,GetPlayerVehicleID(playerid));
			TextDrawSetString(stextdrwe[playerid],"…џЇe®e®њe  ўe¦a");
			TextDrawShowForPlayer(playerid,stextdrwe[playerid]);
		}
		else
		{
			ShowPlayerDialog(playerid,DIALOG_TUNING_COLORS_ENTERIDS,DIALOG_STYLE_INPUT,"Ввод ID","{FFFFFF}Введите ID цветов, разделив их пробелом\n\n{C6C6C6}Пример: 241 6","Продолжить",DIALOG_BUTTON_BACK_TEXT);
		}
		return 1;
	}
	if(dialogid==DIALOG_TUNING_COLORS_ENTERIDS && response)
	{
		if(response)
		{
			if(strlen(inputtext)<2) return OnDialogResponse(playerid, DIALOG_TUNING_COLORS, 0, 0, "a");
			new tmp[512],index,color1,color2;
			tmp=strtok(inputtext,index);
			if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}Неверно введён {BAA530}ID первого цвета");
			color1=strval(tmp);
			tmp=strtok(inputtext,index);
			if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{FFFFFF}Неверно введён {BAA530}ID второго цвета");
			color2=strval(tmp);
			
			SetPVarInt(playerid,"PlayerCarColor1",color1);
			SetPVarInt(playerid,"PlayerCarColor2",color2);
			
			ChangeVehicleColor(GetPlayerVehicleID(playerid),color1,color2);
			return 1;
		}
	}
	if(dialogid==DIALOG_TUNING)
	{
		if(response)
		{
			switch(listitem)
			{
			case 0: // Запчасти
				{
				    new playervehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
				    new temp[512]; format(temp,sizeof(temp),"/data/tunlists/veh_%i.txt",playervehiclemodel);
				    if(!fexist(temp)) return ShowPlayerDialog(playerid,9999,DIALOG_STYLE_MSGBOX,"Печалька","{FFFFFF}На эту машину нет запчастей","Закрыть","");
				    list_tmpvcp[playerid] = LoadModelSelectionMenu(temp);
					ShowModelSelectionMenu(playerid, list_tmpvcp[playerid], "€aЈ¤ac¦њ", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
					SetPVarInt(playerid,"OpenedMMenu",1);
					return 1;
				}
			case 1: // Цвет
				{
					return ShowPlayerDialog(playerid,DIALOG_TUNING_COLORS,DIALOG_STYLE_MSGBOX,"Цвет","{FFFFFF}Вы можете пролистать цвета с самого начала, а можете\nпросто ввести нужные цвета, чтобы не искать их","Листать","Ввести ID");
				}
			case 2: // Покрасочные работы
				{
					return GetVehicleAvailablePaintjobs(playerid,GetVehicleModel(GetPlayerVehicleID(playerid)));
				}
			case 3: // Диски
				{
					return ShowModelSelectionMenu(playerid, vwheels, "Koћeca", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
				}
			case 4: // Гидравлика
				{
					if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid),9) != 1087)
					{
						AddVehicleComponent(GetPlayerVehicleID(playerid),1087);
						SendClientMessage(playerid,-1,"{FFFFFF}Гидравлика установлена");
					}
					else
					{
						RemoveVehicleComponent(GetPlayerVehicleID(playerid),1087);
						SendClientMessage(playerid,-1,"{FFFFFF}Гидравлика удалена");
					}
					return OnDialogResponse(playerid,DIALOG_MAINMENU,1,0,"a");
				}
			case 5: // Неон
				{
					SetPVarInt(playerid,"PlayerCarNeon",18647);
					AddVehicleNeon(GetPlayerVehicleID(playerid),GetPVarInt(playerid,"PlayerCarNeon"));
					SendClientMessage(playerid,-1,"{FFFFFF}Используйте клавиши {BAA530}num 8 {FFFFFF}и {BAA530}num 2 {FFFFFF}для предпросмотра неона");
					SendClientMessage(playerid,-1,"{FFFFFF}Нажмите клавишу {BAA530}2 {FFFFFF}для удаления неона");
					SendClientMessage(playerid,-1,"{FFFFFF}Нажмите {BAA530}spacebar {FFFFFF}для сохранения неона");
					TextDrawSetString(stextdrwe[playerid],"…џЇe®e®њe ®eo®a");
					TextDrawShowForPlayer(playerid,stextdrwe[playerid]);
					return SetPVarInt(playerid,"NSelectorEnabled",1);
				}
			}
		}
		else return OnPlayerCommandText(playerid,"/menu");
	}
	if(dialogid==DIALOG_PAINTJOBS_YES)
	{
		if(response) ChangeVehiclePaintjob(GetPlayerVehicleID(playerid),listitem);
		else OnDialogResponse(playerid,DIALOG_MAINMENU,1,0,"a");
		return 1;
	}
	if(dialogid==DIALOG_PAINTJOBS_NON)
	{
		if(response) OnDialogResponse(playerid,DIALOG_MAINMENU,1,0,"a");
		else OnDialogResponse(playerid,DIALOG_MAINMENU,1,0,"a");
		return 1;
	}
	if(dialogid==DIALOG_MAINMENU && response) // Главное меню
	{
		switch(listitem)
		{
		case 0: // Тюнинг
			{
				if(!IsPlayerInAnyVehicle(playerid)) return 1;
				if(GetPlayerState(playerid)!=PLAYER_STATE_DRIVER) return 1;
				
				new dlgstrtmp[1024];
				if(GetVehicleComponentInSlot(GetPlayerVehicleID(playerid),9)==1087) format(dlgstrtmp,sizeof(dlgstrtmp),
				"Запчасти\nЦвет\nПокрасочные работы\nДиски\nУдалить гидравлику\nНеон");
				else format(dlgstrtmp,sizeof(dlgstrtmp),
				"Запчасти\nЦвет\nПокрасочные работы\nДиски\nУстановить гидравлику\nНеон");
				
				ShowPlayerDialog(playerid,DIALOG_TUNING,DIALOG_STYLE_LIST,"Тюнинг",dlgstrtmp,DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
				return 1;
			}
		case 1: // Транспорт
			{
				if(GetPVarInt(playerid,"inJail")) return SendClientMessage(playerid,-1,"{FFFFFF}Вам запрещено пользоваться транспортом");
				
				ShowModelSelectionMenu(playerid, vehlist, "Џpa®cЈop¦", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
				SetPVarInt(playerid,"OpenedMMenu",1);
				return 1;
			}
		case 2: // Оружие
			{
				if(GetPVarInt(playerid,"inJail")) return SendClientMessage(playerid,-1,"{FFFFFF}Вам запрещено брать оружие");
				
				ShowModelSelectionMenu(playerid, weaponslist, "Opy›њe", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
				return 1;
			}
		case 3: // Телепорты
			{
				if(GetPVarInt(playerid,"inJail")) return SendClientMessage(playerid,-1,"{FFFFFF}Вы не можете телепортироваться из тюрьмы");
				if(!GetPVarInt(playerid,"canTeleport")) return SendClientMessage(playerid,-1,"{FFFFFF}Вам запрещено телепортироваться");
				
				ShowPlayerDialog(playerid,DIALOG_TELEPORTS,DIALOG_STYLE_LIST,"{BAA530}Телепорты",
				"Ухо\nХолм Сан-Фиерро\nСкейт-парк\nBMX паркур\nВоенная база\nПляж ЛС\nНебоскрёб ЛС\nБолото\nГроув стрит\nПаркур-зона 1\nПаркур-зона 2\nАлькатрас\nМото-триал\nКарьер\nДраг 1\nДраг 2\nДраг 3\nДМ 1",
				DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
				return 1;
			}
		case 4: // Помощь
			{
				OnPlayerCommandText(playerid,"/help");
				return 1;
			}
		case 5: // Радио
			{
				ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_LIST,
				"Радио","Зайцев FM\nЕвропа+\nРадио Рекорд\nПиратская станция\nТрансмиссия\nRecord Deep\nRecord Trap\nTeodor Hardstyle\nRecord Dancecore\nRecord Breaks\nVip Mix\nRecord Chill-Out\nДискотека 90-х\nYo! FM\n{BAA530}Выключить радио",
				DIALOG_BUTTON_CONFIRM_TEXT, DIALOG_BUTTON_BACK_TEXT);
				return 1;
			}
		case 6: // Моя банда
		    {
		        new msg[512];
		        if(GetPlayerGangID(playerid)!=INVALID_GANG_ID)
				{
					switch(GetPlayerGangRank(playerid))
		        	{
		        	    case GSYS_RANK_MAX:
		        	    {
		            		format(msg,sizeof(msg),"{020202}Создать банду\n{FFFFFF}Пригласить в банду\n{FFFFFF}Уволить из банды\n{FFFFFF}Изменить ранг члена банды\n{FFFFFF}Изменить скины\n{FFFFFF}Изменить место спауна\n{FFFFFF}Передать лидерство\n{020202}Уйти из банды");

							return ShowPlayerDialog(playerid,DIALOG_GANG_MAINMENU,DIALOG_STYLE_LIST,"Моя банда",
							msg,
							DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
						}
		        		case GSYS_RANK_MAX-1:
		        		{
		        	  	  	format(msg,sizeof(msg),"{020202}Создать банду\n{FFFFFF}Пригласить в банду\n{FFFFFF}Уволить из банды\n{020202}Изменить ранг члена банды\n{020202}Изменить скины\n{020202}Изменить место спауна\n{020202}Передать лидерство\n{FFFFFF}Уйти из банды");

							return ShowPlayerDialog(playerid,DIALOG_GANG_MAINMENU,DIALOG_STYLE_LIST,"Моя банда",
							msg,
							DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
		        		}
		        		case GSYS_RANK_MAX-2:
		        		{
		        		    format(msg,sizeof(msg),"{020202}Создать банду\n{FFFFFF}Пригласить в банду\n{020202}Уволить из банды\n{020202}Изменить ранг члена банды\n{020202}Изменить скины\n{020202}Изменить место спауна\n{020202}Передать лидерство\n{FFFFFF}Уйти из банды");

							return ShowPlayerDialog(playerid,DIALOG_GANG_MAINMENU,DIALOG_STYLE_LIST,"Моя банда",
							msg,
							DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
		        		}
		        		case GSYS_RANK_MAX-3,GSYS_RANK_MAX-4,GSYS_RANK_MAX-(GSYS_RANK_MAX-1):
		        		{
		        		    format(msg,sizeof(msg),"{020202}Создать банду\n{020202}Пригласить в банду\n{020202}Уволить из банды\n{020202}Изменить ранг члена банды\n{020202}Изменить скины\n{020202}Изменить место спауна\n{020202}Передать лидерство\n{FFFFFF}Уйти из банды");

							return ShowPlayerDialog(playerid,DIALOG_GANG_MAINMENU,DIALOG_STYLE_LIST,"Моя банда",
							msg,
							DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
		        		}
					}
		        }
		        else
		        {
		            format(msg,sizeof(msg),"Создать банду\n{020202}Пригласить в банду\nУволить из банды\nИзменить ранг члена банды\nИзменить скины\nИзменить место спауна\nПередать лидерство\nУйти из банды");

					return ShowPlayerDialog(playerid,DIALOG_GANG_MAINMENU,DIALOG_STYLE_LIST,"Моя банда",
					msg,
					DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
		        }
				
		        return 1;
		    }
		case 7: // Настройки
			{
				new gsdlgstrtmp[1024],h,m,autor[128],nntshow[128];
				switch(GetPVarInt(playerid,"PlF_AutoRepair"))
				{
				    case 0: format(autor,sizeof(autor),"выключен");
				    case 1: format(autor,sizeof(autor),"включён");
				    default: format(autor,sizeof(autor),"неизвестно");
				}
				switch(GetPVarInt(playerid,"PlF_ShowNickNames"))
				{
				    case 0: format(nntshow,sizeof(nntshow),"не отображаются");
				    case 1: format(nntshow,sizeof(nntshow),"отображаются");
				    default: format(nntshow,sizeof(nntshow),"неизвестно");
				}
				h=GetPVarInt(playerid,"PlayerTime_Hours");
				m=GetPVarInt(playerid,"PlayerTime_Minutes");
				format(gsdlgstrtmp,sizeof(gsdlgstrtmp),"{FFA63C}> Персонаж\n{FFFFFF}Стиль боя\nСкин\nОбъекты\n");
				format(gsdlgstrtmp,sizeof(gsdlgstrtmp),
				"%s{FFA63C}> Игра\n{FFFFFF}Время {C6C6C6}[%i:%i]\n{FFFFFF}Погода\n{FFFFFF}Авторемонт ТС {C6C6C6}[%s]\n{FFFFFF}Ники игроков {C6C6C6}[%s]\n",
				gsdlgstrtmp,h,m,autor,nntshow);
				format(gsdlgstrtmp,sizeof(gsdlgstrtmp),"%s{FFA63C}> Чат\n{FFFFFF}Цвет текста {C6C6C6}[{%s}%s{C6C6C6}]",
				gsdlgstrtmp,GetPlayerChatColor(playerid),GetPlayerChatColor(playerid));
				
				ShowPlayerDialog(playerid,DIALOG_GAMESETTINGS,DIALOG_STYLE_LIST,"Настройки",gsdlgstrtmp,DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
				return 1;
			}
		case 8: // Перевернуть авто
			{
			    if(!IsPlayerInAnyVehicle(playerid)) return 1;
			    if(GetPlayerState(playerid)!=PLAYER_STATE_DRIVER) return 1;

			    new vehid, Float:x, Float:y, Float:z, Float:angle;
				vehid = GetPlayerVehicleID(playerid);
				GetVehiclePos(vehid, x, y, z);
				GetVehicleZAngle(vehid, angle);
				SetVehiclePos(vehid, x, y, z);
				SetVehicleZAngle(vehid, angle);
				RepairVehicle(vehid);
    			return 1;
		    }
		case 9: // HP + ARMOUR
		    {
		        SetPlayerHealth(playerid,100.0);
		        SetPlayerArmour(playerid,100.0);
		    }
		}
	}
	if(dialogid == DIALOG_ATTACHM_MAIN)
	{
	    if(!response) return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
	    
	    new strtmp[128],slotid;
	    format(strtmp,sizeof(strtmp),"Объекты: слот %i",listitem+1);
	    ShowPlayerDialog(playerid,DIALOG_ATTACHM_SLOT,DIALOG_STYLE_LIST,strtmp,"Изменить\nУдалить",DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
	    slotid = listitem;
	    SetPVarInt(playerid,"PlayerAttCSlot",slotid);
	    
	    return 1;
	}
	if(dialogid == DIALOG_ATTACHM_SLOT)
	{
	    if(!response) return OnDialogResponse(playerid,DIALOG_GAMESETTINGS,1,3,"a");

	    new strtmp[1024];
	    switch(listitem)
		{
		    case 0:
		    {
			    for(new c=1; c<18+1; c++) format(strtmp,sizeof(strtmp),"%s{FFFFFF}%s {86C131}[редактировать]\n",strtmp,ObjectsBones[c-1]);
			    ShowPlayerDialog(playerid,DIALOG_ATTACHM_BONES,DIALOG_STYLE_LIST,"Объекты: выбор части тела",strtmp,DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
			}
			case 1:
			{
			    RemovePlayerAttachedObject(playerid,GetPVarInt(playerid,"PlayerAttCSlot"));
			    SendClientMessage(playerid,-1,"{FFFFFF}Объект удалён");
			}
	    }
	    return 1;
	}
	if(dialogid == DIALOG_ATTACHM_BONES)
	{
	    if(!response) return OnDialogResponse(playerid,DIALOG_GAMESETTINGS,1,3,"a");
	    
	    new boneid;
	    boneid = listitem + 1;
	    SetPVarInt(playerid,"PlayerAttCBone",boneid);
		ShowModelSelectionMenu(playerid, attachments, "O—§ek¦Ё", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
	    
	    return 1;
	}
	if(dialogid == DIALOG_GAMESETTINGS_SETCHATCOLOR)
	{
	    if(!response) return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
	    
	    if(strlen(inputtext)!=6) return OnDialogResponse(playerid,DIALOG_GAMESETTINGS,1,9,"a");
	    
	    SetPVarString(playerid,"PlI_ChatColor",inputtext);
	    SetPlayerChatColor(playerid,inputtext);
	    SendClientMessage(playerid,-1,"{FFFFFF}Цвет текста ваших сообщений в чате изменён");
	    
	    return 1;
	}
	if(dialogid == DIALOG_GAMESETTINGS)
	{
		if(!response) return OnPlayerCommandText(playerid,"/menu");
		
		switch(listitem)
		{
		case 0: return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
		case 1: // Стиль боя
			{
				ShowPlayerDialog(playerid,DIALOG_GAMESETTINGS_PFIGHTSTYLE,DIALOG_STYLE_LIST,"Стиль боя",
				"Нормальный\nБоксинг\nКунг-фу\nЗахват\nУдар головой\nУдар локтём",DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
			}
		case 2: // Скин
			{
				ShowModelSelectionMenu(playerid, skinslist, "Ckњ®Ё", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
			}
		case 3: // Объекты
			{
			    new strtmp[512];
			    for(new s; s<10; s++) format(strtmp,sizeof(strtmp),"%s{FFFFFF}Слот %i\n",strtmp,s+1);
				ShowPlayerDialog(playerid,DIALOG_ATTACHM_MAIN,DIALOG_STYLE_LIST,"Объекты",strtmp,DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
				return 1;
			}
		case 4: return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
		case 5: // Время
			{
			    SendClientMessage(playerid,-1,"{FFFFFF}Используйте клавиши {BAA530}num 8 {FFFFFF}и {BAA530}num 2 {FFFFFF}для изменения времени");
				SendClientMessage(playerid,-1,"{FFFFFF}Нажмите {BAA530}spacebar {FFFFFF}для сохранения текущего времени");
				SendClientMessage(playerid,-1,"{FFFFFF}Нажмите {BAA530}2 {FFFFFF}для переключения между {BAA530}часами {FFFFFF}и {BAA530}минутами");
				SendClientMessage(playerid,-1,"{FFFFFF}Изменение времени возможно только {BAA530}в авто {C6C6C6}(так сделано для удобства)");
				TextDrawSetString(stextdrwe[playerid],"…џЇe®e®њe ўpeЇe®њ");
				TextDrawShowForPlayer(playerid,stextdrwe[playerid]);
				return SetPVarInt(playerid,"TSelectorEnabled",1);
			}
		case 6: // Погода
			{
				SendClientMessage(playerid,-1,"{FFFFFF}Используйте клавиши {BAA530}num 8 {FFFFFF}и {BAA530}num 2 {FFFFFF}для просмотра погоды");
				SendClientMessage(playerid,-1,"{FFFFFF}Нажмите {BAA530}spacebar {FFFFFF}для сохранения погоды");
				SendClientMessage(playerid,-1,"{FFFFFF}Просмотр погоды возможен только {BAA530}в авто {C6C6C6}(так сделано для удобства)");
				TextDrawSetString(stextdrwe[playerid],"…џЇe®e®њe Јo™oљЁ");
				TextDrawShowForPlayer(playerid,stextdrwe[playerid]);
				return SetPVarInt(playerid,"WSelectorEnabled",1);
			}
		case 7: // Авторемонт ТС
		    {
		        switch(GetPVarInt(playerid,"PlF_AutoRepair"))
		        {
		            case 0:
		                {
		                    SetPVarInt(playerid,"PlF_AutoRepair",1);
	                     	return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
		                }
					case 1:
					    {
		                    SetPVarInt(playerid,"PlF_AutoRepair",0);
	                     	return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
					    }
					default: return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
		        }
		        return 1;
		    }
		case 8: // Ники игроков
		    {
		        switch(GetPVarInt(playerid,"PlF_ShowNickNames"))
				{
				    case 0:
						{
		                    SetPVarInt(playerid,"PlF_ShowNickNames",1);
		                    ShowAllNicknamesForPlayer(playerid);
	                     	return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
						}
				    case 1:
						{
     						SetPVarInt(playerid,"PlF_ShowNickNames",0);
		                    HideAllNicknamesForPlayer(playerid);
							return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
						}
				    default: return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
				}
		        return 1;
		    }
		case 9: return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
		case 10: // Цвет текста сообщений в чате
		    {
		        new dialogstr[512];
		        format(dialogstr,sizeof(dialogstr),"{FFFFFF}Текущий цвет: {%s}%s\n\n{C6C6C6}Пример цвета: FFEA37",GetPlayerChatColor(playerid),GetPlayerChatColor(playerid));
		        ShowPlayerDialog(playerid,DIALOG_GAMESETTINGS_SETCHATCOLOR,DIALOG_STYLE_INPUT,"Чат: цвет текста сообщений",dialogstr,"Изменить",DIALOG_BUTTON_BACK_TEXT);
		        return 1;
		    }
		}
		return 1;
	}
	if(dialogid == DIALOG_GAMESETTINGS_PFIGHTSTYLE)
	{
		if(!response) return OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
		
		switch(listitem)
		{
		case 0: SetPlayerFightingStyle(playerid,FIGHT_STYLE_NORMAL);
		case 1: SetPlayerFightingStyle(playerid,FIGHT_STYLE_BOXING);
		case 2: SetPlayerFightingStyle(playerid,FIGHT_STYLE_KUNGFU);
		case 3: SetPlayerFightingStyle(playerid,FIGHT_STYLE_KNEEHEAD);
		case 4: SetPlayerFightingStyle(playerid,FIGHT_STYLE_GRABKICK);
		case 5: SetPlayerFightingStyle(playerid,FIGHT_STYLE_ELBOW);
		}
		
		return 1;
	}
	if((dialogid == DIALOG_HELP_DATES || dialogid == DIALOG_HELP_HOTKEYS ||
				dialogid == DIALOG_HELP_COMMANDS || dialogid == DIALOG_HELP_FUNCTSINFO) && response)
	{
		return OnPlayerCommandText(playerid,"/help");
	}
	if(dialogid == DIALOG_HELP_MAIN && response) // Помощь
	{
		switch(listitem)
		{
		case 0:
			{
				ShowPlayerDialog(playerid,DIALOG_HELP_DATES,DIALOG_STYLE_MSGBOX,"Важные даты",
				"{3C9CFF}16.07.2013 {FFFFFF}- запуск проекта\n{3C9CFF}30.09.2013 {FFFFFF}- первый переезд\n{3C9CFF}03.12.2013 {FFFFFF}- второй переезд",
				DIALOG_BUTTON_BACK_TEXT,"");
			}
		case 1:
			{
				new hlpdlgstrtmp[2048];
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"{CDA053}Меню: {FFFFFF}нажмите {BAA530}2{FFFFFF}, если вы в транспорте");
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s или {BAA530}ALT{FFFFFF}, если вы не в транспорте\n",hlpdlgstrtmp);
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s{CDA053}Переворот транспорта: {FFFFFF}команда /flip или последний пункт в меню",hlpdlgstrtmp);

				ShowPlayerDialog(playerid,DIALOG_HELP_HOTKEYS,DIALOG_STYLE_MSGBOX,"Горячие клавиши",hlpdlgstrtmp,DIALOG_BUTTON_BACK_TEXT,"");
			}
		case 2:
			{
				new hlpdlgstrtmp[3096];
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"{98FF3C}> Основные");
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s\n{BAA530}/menu {FFFFFF}- открытие главного меню\n{BAA530}/w {FFFFFF}- отправка личного сообщения\n{BAA530}/pay {FFFFFF}- передача денег\n",hlpdlgstrtmp);
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s\n{98FF3C}> Банда",hlpdlgstrtmp);
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s\n{BAA530}/invite {FFFFFF}- пригласить в банду\n{BAA530}/uninvite {FFFFFF}- уволить из банды\n{BAA530}/f {FFFFFF}- чат банды",hlpdlgstrtmp);
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s\n{BAA530}/setgcolor {FFFFFF}- изменить цвет банды {C6C6C6}(только для лидеров) \n{BAA530}/quitgang {FFFFFF}- уйти из банды",hlpdlgstrtmp);
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s\n\n{98FF3C}> Разное",hlpdlgstrtmp);
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s\n{BAA530}/me {FFFFFF}- имитация какого-либо действия\n{BAA530}/kiss {FFFFFF}- поцелуй\n{BAA530}/flowers {FFFFFF}- подарить цветы\n",hlpdlgstrtmp);
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s{BAA530}/animhelp {FFFFFF}- справка по анимациям сервера",hlpdlgstrtmp);
				
				ShowPlayerDialog(playerid,DIALOG_HELP_COMMANDS,DIALOG_STYLE_MSGBOX,"Команды",hlpdlgstrtmp,DIALOG_BUTTON_BACK_TEXT,"");
			}
		case 3:
			{
				new hlpdlgstrtmp[2048];
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"{2FC790}Авторемонт ТС {FFFFFF}- автоматический ремонт вашего транспортного средства\n");
				format(hlpdlgstrtmp,sizeof(hlpdlgstrtmp),"%s{2FC790}Ники игроков {FFFFFF}- показ ников игроков над головами их персонажей\n",hlpdlgstrtmp);

				ShowPlayerDialog(playerid,DIALOG_HELP_FUNCTSINFO,DIALOG_STYLE_MSGBOX,"Описание настраиваемых функций",hlpdlgstrtmp,DIALOG_BUTTON_BACK_TEXT,"");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_RADIO) // Радио
	{
		if(response)
		{
			switch(listitem)
			{
			case 0: PlayAudioStreamForPlayer(playerid,"http://www.zaycev.fm:9001/rnb/ZaycevFM(128)");
			case 1: PlayAudioStreamForPlayer(playerid,"http://webcast.emg.fm:55655/europaplus128.mp3");
			case 2: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/rr.m3u");
			case 3: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/ps.m3u");
			case 4: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/tm.m3u");
			case 5: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/deep.m3u");
			case 6: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/trap.m3u");
			case 7: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/teo.m3u");
			case 8: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/dc.m3u");
			case 9: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/brks.m3u");
			case 10: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/vip.m3u");
			case 11: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/chil.m3u");
			case 12: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/sd.m3u");
			case 13: PlayAudioStreamForPlayer(playerid,"http://pro100drift.ru/radio/yo.m3u");
			case 14: StopAudioStreamForPlayer(playerid);
			}
			return 1;
		}
		else return OnPlayerCommandText(playerid,"/menu");
	}
	if(dialogid == DIALOG_TELEPORTS) // Телепорты
	{
		if(response)
		{
			switch(listitem)
			{
			case 0: // Ухо
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,-332.4944,1528.8733,75.3594);
						SetPlayerFacingAngle(playerid,244.6888);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),-332.4944,1528.8733,75.3594);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),244.6888);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 1: // Холм Сан-Фиерро
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,-2212.5457,-979.4572,38.5249);
						SetPlayerFacingAngle(playerid,27.7554);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),-2212.5457,-979.4572,38.5249);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),27.7554);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 2: // Скейт-парк
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,1870.4274,-1386.3281,13.5239);
						SetPlayerFacingAngle(playerid,264.1453);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),1870.4274,-1386.3281,13.5239);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),264.1453);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 3: // BMX паркур
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,-1979.7601,411.0576,35.1719);
						SetPlayerFacingAngle(playerid,249.6857);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),-1979.7601,411.0576,35.1719);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),249.6857);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 4: // Военная база
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,285.0772,1919.6530,17.6406);
						SetPlayerFacingAngle(playerid,314.2763);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),285.0772,1919.6530,17.6406);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),314.2763);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 5: // Пляж ЛС
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,321.8886,-1798.3446,4.6964);
						SetPlayerFacingAngle(playerid,250.4897);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),321.8886,-1798.3446,4.6964);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),250.4897);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 6: // Небоскрёб ЛС
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,1544.5514,-1353.2316,329.4745);
						SetPlayerFacingAngle(playerid,62.9806);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),1544.5514,-1353.2316,329.4745);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),62.9806);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 7: // Болото
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,-673.6619,-1858.2572,15.3120);
						SetPlayerFacingAngle(playerid,142.3333);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),-673.6619,-1858.2572,15.3120);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),142.3333);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 8: // Гроув стрит
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,2495.9622,-1668.6489,13.3438);
						SetPlayerFacingAngle(playerid,94.73013);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),2495.9622,-1668.6489,13.3438);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),94.7301);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 9: // Паркур-зона 1
				{
					SetPlayerPos(playerid,-2.6400,-276.3049,1101.1018);
					SetPlayerFacingAngle(playerid,208.0553);
			 		SetCameraBehindPlayer(playerid);

					return 1;
				}
			case 10: // Паркур-зона 2
				{
					SetPlayerPos(playerid,2549.9233,-1680.4445,4131.6470);
					SetPlayerFacingAngle(playerid,267.9307);
			 		SetCameraBehindPlayer(playerid);
					
					return 1;
				}
			case 11: // Алькатрас
				{
					SetPlayerPos(playerid,-429.9577,3865.1135,2.1107);
					SetPlayerFacingAngle(playerid,207.9418);
			 		SetCameraBehindPlayer(playerid);

					return 1;
				}
			case 12: // Мото-триал
				{
					SetPlayerPos(playerid,-2126.3999,664.1779,83.3785);
					SetPlayerFacingAngle(playerid,302.9443);
			 		SetCameraBehindPlayer(playerid);

					return 1;
				}
			case 13: // Карьер
				{
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,909.4449,829.5737,13.3516);
						SetPlayerFacingAngle(playerid,48.4662);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),909.4449,829.5737,13.3516);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),48.4662);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
				}
			case 14: // Драг 1
			    {
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,809.6672,-2777.5999,36.0811);
						SetPlayerFacingAngle(playerid,0.0746);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),809.6672,-2777.5999,36.0811);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),0.0746);
					}
			 		SetCameraBehindPlayer(playerid);
					return 1;
			    }
			case 15: // Драг 2
			    {
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,2856.8469,-2003.5634,10.9373);
						SetPlayerFacingAngle(playerid,268.7372);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),2856.8469,-2003.5634,10.9373);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),268.7372);
					}
			 		SetCameraBehindPlayer(playerid);
			        return 1;
			    }
			case 16: // Драг 3
			    {
					if(!IsPlayerInAnyVehicle(playerid))
					{
						SetPlayerPos(playerid,256.7957,2869.5989,17.6785);
						SetPlayerFacingAngle(playerid,356.6714);
					}
					else
					{
						SetVehiclePos(GetPlayerVehicleID(playerid),256.7957,2869.5989,17.6785);
						SetVehicleZAngle(GetPlayerVehicleID(playerid),356.6714);
					}
			 		SetCameraBehindPlayer(playerid);
			        return 1;
			    }
			case 17: // ДМ 1
			    {
			        new spos = random(4);
					SetPlayerPos(playerid,DM1Spawns[spos][0],DM1Spawns[spos][1],DM1Spawns[spos][2]);
					SetPlayerFacingAngle(playerid,DM1Spawns[spos][3]);
					SetPlayerHealth(playerid,100.0);
					SetPlayerArmour(playerid,100.0);
			 		SetCameraBehindPlayer(playerid);
			        return 1;
			    }
			}
		}
		else return OnPlayerCommandText(playerid,"/menu");
	}
	
	return 0;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == attachments)
	{
	    if(!response) return 1;
	    if(GetPVarInt(playerid,"PlayerAttCBone")==-1 || GetPVarInt(playerid,"PlayerAttCSlot")==-1) return 1;
	    
	    SendClientMessage(playerid,-1,"{FFFFFF}Для перемещения камеры, двигайте мышь, удерживая {BAA530}Spacebar");
	    SendClientMessage(playerid,-1,"{FFFFFF}Для перемещения объекта, используйте {BAA530}соответствующие кнопки");
	    SendClientMessage(playerid,-1,"{FFFFFF}Для закрепления объекта, нажмите на {BAA530}кнопку дискеты");
	    SetPlayerAttachedObject(playerid,GetPVarInt(playerid,"PlayerAttCSlot"),modelid,GetPVarInt(playerid,"PlayerAttCBone"));
	    EditAttachedObject(playerid,GetPVarInt(playerid,"PlayerAttCSlot"));
	    return 1;
	}
	if(listid == gskinslist)
	{
	    if(!response)
		{
			SetPVarInt(playerid,"TempoGRSkin",0);
			SendClientMessage(playerid,-1,"{FFFFFF}Скин удалён");
		}
	    else
	    {
	        SetPlayerGangRankSkin(playerid,GetPVarInt(playerid,"TempoGRank"),modelid);
	        SendClientMessage(playerid,-1,"{FFFFFF}Скин изменён");
	    }

		return 1;
	}
	if(listid == weaponslist)
	{
		if(response)
		{
			SetPVarInt(playerid,"OpenedMMenu",0);
			
			switch(modelid)
			{
			case 321: GivePlayerWeapon(playerid,10,1);
			case 322: GivePlayerWeapon(playerid,11,1);
			case 323: GivePlayerWeapon(playerid,12,1);
			case 324: GivePlayerWeapon(playerid,13,1);
			case 325: GivePlayerWeapon(playerid,14,1);
			case 326: GivePlayerWeapon(playerid,15,1);
			case 331: GivePlayerWeapon(playerid,1,1);
			case 333: GivePlayerWeapon(playerid,2,1);
			case 334: GivePlayerWeapon(playerid,3,1);
			case 335: GivePlayerWeapon(playerid,4,1);
			case 336: GivePlayerWeapon(playerid,5,1);
			case 337: GivePlayerWeapon(playerid,6,1);
			case 338: GivePlayerWeapon(playerid,7,1);
			case 339: GivePlayerWeapon(playerid,8,1);
			case 341: GivePlayerWeapon(playerid,9,1);
			case 342: GivePlayerWeapon(playerid,16,50);
			case 343: GivePlayerWeapon(playerid,17,50);
			case 344: GivePlayerWeapon(playerid,18,50);
			case 346: GivePlayerWeapon(playerid,22,5000);
			case 347: GivePlayerWeapon(playerid,23,5000);
			case 348: GivePlayerWeapon(playerid,24,5000);
			case 349: GivePlayerWeapon(playerid,25,5000);
			case 350: GivePlayerWeapon(playerid,26,5000);
			case 351: GivePlayerWeapon(playerid,27,5000);
			case 352: GivePlayerWeapon(playerid,28,5000);
			case 353: GivePlayerWeapon(playerid,29,5000);
			case 355: GivePlayerWeapon(playerid,30,5000);
			case 356: GivePlayerWeapon(playerid,31,5000);
			case 357: GivePlayerWeapon(playerid,33,5000);
			case 361: GivePlayerWeapon(playerid,37,5000);
			case 363: GivePlayerWeapon(playerid,39,50);
			case 364: GivePlayerWeapon(playerid,40,1);
			case 365: GivePlayerWeapon(playerid,41,5000);
			case 366: GivePlayerWeapon(playerid,42,5000);
			case 367: GivePlayerWeapon(playerid,43,15000);
			case 370: SetPlayerSpecialAction(playerid,2);
			case 371: GivePlayerWeapon(playerid,46,1);
			case 372: GivePlayerWeapon(playerid,32,5000);
			default: return 0;
			}
			SendClientMessage(playerid,-1,"{FFFFFF}Оружие получено");
			
			return 1;
		}
		else SetPVarInt(playerid,"OpenedMMenu",0);
		
		return 1;
	}
	if(listid == vwheels)
	{
		if(response)
		{
			SetPVarInt(playerid,"OpenedMMenu",0);
			
			AddVehicleComponent(GetPlayerVehicleID(playerid),modelid);
			return 1;
		}
		else SetPVarInt(playerid,"OpenedMMenu",0);

		return 1;
	}
	if(listid == list_tmpvcp[playerid])
	{
		if(response)
		{
			SetPVarInt(playerid,"OpenedMMenu",0);
			
			if(!ComponentIsValid(GetPlayerVehicleID(playerid),modelid)) return SendClientMessage(playerid,-1,"{FFFFFF}Данная запчасть не подходит к вашему автомобилю");
			
			AddVehicleComponent(GetPlayerVehicleID(playerid),modelid);
			return 1;
		}
		else SetPVarInt(playerid,"OpenedMMenu",0);

		return 1;
	}
	if(listid == vehlist)
	{
		if(response)
		{
			new Float: tmp[4];
			new color1 = random(255);
			new color2 = random(255);
			SetPVarInt(playerid,"PlayerCarColor1",color1);
			SetPVarInt(playerid,"PlayerCarColor2",color2);
			if(!IsPlayerInAnyVehicle(playerid))
			{
				GetPlayerPos(playerid,tmp[0],tmp[1],tmp[2]);
				GetPlayerFacingAngle(playerid,tmp[3]);
			}
			else
			{
				GetVehiclePos(GetPlayerVehicleID(playerid),tmp[0],tmp[1],tmp[2]);
				GetVehicleZAngle(GetPlayerVehicleID(playerid),tmp[3]);
			}
			if(GetPVarInt(playerid,"SpawnedCar")) DestroyVehicle(car[playerid]);
			car[playerid] = CreateVehicle(modelid,tmp[0],tmp[1],tmp[2],tmp[3],color1,color2,60);
			SetPVarInt(playerid,"SpawnedCar",1);
			PutPlayerInVehicle(playerid,car[playerid],0);
			SetPVarInt(playerid,"OpenedMMenu",0);
		}
		else SetPVarInt(playerid,"OpenedMMenu",0);
		
		return 1;
	}
	if(listid == skinslist)
	{
		if(response)
		{
			SetPlayerSkin(playerid,modelid);
			SetPVarInt(playerid,"SpawnSkin",modelid);
			SetPVarInt(playerid,"OpenedMMenu",0);
		}
		else
		{
			SetPVarInt(playerid,"OpenedMMenu",0);
			OnDialogResponse(playerid,DIALOG_MAINMENU,1,7,"a");
		}
		
		return 1;
	}
	if(listid == sskinslist)
	{
		if(response)
		{
			SetPVarInt(playerid,"SpawnSkin",modelid);
			SetPVarInt(playerid,"OpenedMMenu",0);
			return OnPlayerSpawn(playerid);
		}
		else
		{
			SetPVarInt(playerid,"OpenedMMenu",1);
			ShowModelSelectionMenu(playerid, sskinslist, "Ckњ®Ё", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
		}
		
		return 1;
	}
	if(listid == bikeslist1 || listid == bikeslist2)
	{
		if(response)
		{
			SetPVarInt(playerid,"OpenedMMenu",0);
			OnPlayerModelSelection(playerid, 1, vehlist, modelid);
		}
		else SetPVarInt(playerid,"OpenedMMenu",0);

		return 1;
	}
	if(listid == militarylist)
	{
		if(response)
		{
			SetPVarInt(playerid,"OpenedMMenu",0);
			OnPlayerModelSelection(playerid, 1, vehlist, modelid);
		}
		else SetPVarInt(playerid,"OpenedMMenu",0);
		
		return 1;
	}
	return 0;
}

/* ------------------------------------------------------------------------------- */

public OnVehicleSpawn(vehicleid)
{
    return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(response)
	{
		SetPlayerAttachedObject(playerid,index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
	    SendClientMessage(playerid, -1, "{FFFFFF}Объект прикреплён");
	}
    
	return 1;
}

/* ------------------------------------------------------------------------------- */

public AntiWeaponHack(playerid)
{
	if((GetPlayerWeapon(playerid) == 38 || GetPlayerWeapon(playerid) == 35 ||
				GetPlayerWeapon(playerid) == 36 || GetPlayerWeapon(playerid) == 44 ||
				GetPlayerWeapon(playerid) == 45) && !IsPlayerAdmin(playerid)) ResetPlayerWeapons(playerid);
	return 1;
}

/* ------------------------------------------------------------------------------- */

public CancelTeleport(playerid)
{
	SetPVarInt(playerid,"PlayerTPID",-1);
	return 1;
}

/* ------------------------------------------------------------------------------- */

public CancelKiss(playerid)
{
	SetPVarInt(playerid,"PlayerKMWID",-1);
	return 1;
}

/* ------------------------------------------------------------------------------- */

public AutoRepair(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPVarInt(playerid,"PlF_AutoRepair"))
	{
		new Float:CarHP;
		GetVehicleHealth(GetPlayerVehicleID(playerid), CarHP);
		if(CarHP < 1000) RepairVehicle(GetPlayerVehicleID(playerid));
	}
	return 1;
}

/* ------------------------------------------------------------------------------- */

/*public AutoFlip(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPVarInt(playerid,"PlF_AutoFlip"))
	{
		new Float:tmpa[9];
		GetVehicleRotation(GetPlayerVehicleID(playerid),tmpa[0],tmpa[1],tmpa[2]);
		
		if(tmpa[0] < 0)
		{
		    GetVehiclePos(GetPlayerVehicleID(playerid),tmpa[3],tmpa[4],tmpa[5]);
			GetVehicleVelocity(GetPlayerVehicleID(playerid),tmpa[6],tmpa[7],tmpa[8]);
			SetVehiclePos(GetPlayerVehicleID(playerid),tmpa[3],tmpa[4],tmpa[5]);
			SetVehicleVelocity(GetPlayerVehicleID(playerid),tmpa[6],tmpa[7],tmpa[8]);
		}
		
		new tmp[255]; format(tmp,sizeof(tmp),"X Angle: %f; Y Angle: %f; Z Angle: %f",tmpa[0],tmpa[1],tmpa[2]);
		SendClientMessage(playerid,-1,tmp);
	}
	return 1;
} */

/* ------------------------------------------------------------------------------- */

stock AddVehicleNeon(vehicleid,neonid)
{
	NonValid:neonid(18647,18652) return 0;
	
	DestroyObject(VehicleNeon[vehicleid][0]);
	DestroyObject(VehicleNeon[vehicleid][1]);
	VehicleNeon[vehicleid][0] = CreateObject(neonid,0.0,0.0,0.0,0.0,0.0,0.0);
	VehicleNeon[vehicleid][1] = CreateObject(neonid,0.0,0.0,0.0,0.0,0.0,0.0);
	AttachObjectToVehicle(VehicleNeon[vehicleid][0], vehicleid, -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	AttachObjectToVehicle(VehicleNeon[vehicleid][1], vehicleid, 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
	
	return 1;
}

/* ------------------------------------------------------------------------------- */

public OnPlayerAirbreak(playerid)
{
	printf("Игрок %s (%i) кикнут за Air Break",PlayerName(playerid),playerid);
	new tmp[512]; format(tmp,sizeof(tmp),"%s кикнут за использование Air Break",PlayerName(playerid));
	SendClientMessageToAll(COLOR_LIGHTRED,tmp);
	Kick(playerid);
	return 1;
}

/* ------------------------------------------------------------------------------- */

stock SetPlayerGangColor(playerid,color[])
{
    new tmp[512],gidtmp;
	format(tmp,sizeof(tmp),GSYS_PFILEPATH,PlayerName(playerid));

	gidtmp = dini_Int(tmp,"GangID");
	if(!GangExists(gidtmp)) return 0;

	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gidtmp);
	dini_Set(tmp,"Color",color);

	return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetPlayerGangColor(playerid)
{
    new tmp[512],gidtmp;
	format(tmp,sizeof(tmp),GSYS_PFILEPATH,PlayerName(playerid));

	gidtmp = dini_Int(tmp,"GangID");
	
	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gidtmp);
	
	new ctmp[512];
	ctmp = dini_Get(tmp,"Color");

	return ctmp;
}

/* ------------------------------------------------------------------------------- */

stock GetPlayerGangRank(playerid)
{
	new tmp[512];
	format(tmp,sizeof(tmp),GSYS_PFILEPATH,PlayerName(playerid));

	if(!dini_Exists(tmp)) return 0;
	if(dini_Int(tmp,"GangID")==INVALID_GANG_ID) return 0;
	
	new playerrank = dini_Int(tmp,"Rank");
	
	return playerrank;
}

/* ------------------------------------------------------------------------------- */

stock SetPlayerGangRankSkin(playerid,rankid,skinid)
{
	NonValid:rankid(GSYS_RANK_MIN,GSYS_RANK_MAX) return 0;
	
	new tmp[512],tmp2[512],gangid;
	gangid = GetPlayerGangID(playerid);

	if(!GangExists(gangid)) return 0;

	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gangid);
	format(tmp2,sizeof(tmp2),"Rank%iSkin",rankid);

	if(!dini_IntSet(tmp,tmp2,skinid)) return 0;

	return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetPlayerGangRankSkin(playerid,rankid)
{
    NonValid:rankid(GSYS_RANK_MIN,GSYS_RANK_MAX) return 0;
    
    new tmp[512],tmp2[512],gangid;
	gangid = GetPlayerGangID(playerid);

	if(!GangExists(gangid)) return 0;

	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gangid);
	format(tmp2,sizeof(tmp2),"Rank%iSkin",rankid);
	
	if(!dini_Isset(tmp,tmp2)) return 0;

	return dini_Int(tmp,tmp2);
}

/* ------------------------------------------------------------------------------- */

stock SetPlayerGangSpawn(playerid)
{
	new tmp[512],gangid,coords[1024];
	gangid = GetPlayerGangID(playerid);
	
	new Float:x,Float:y,Float:z,Float:a;
	GetPlayerPos(playerid,x,y,z);
	GetPlayerFacingAngle(playerid,a);
	
	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gangid);
	format(coords,sizeof(coords),"%f %f %f %f",x,y,z+1.0,a);
    dini_Set(tmp,"Spawn",coords);
    
	return 1;
}

/* ------------------------------------------------------------------------------- */

SetPlayerChatColor(playerid,color[])
{
	new tmp[512];
	format(tmp,sizeof(tmp),ACC_PFPATH,PlayerName(playerid));
	dini_Set(tmp,"ChatColor",color);
	return 1;
}

/* ------------------------------------------------------------------------------- */

GetPlayerChatColor(playerid)
{
	new tmp[512];
	format(tmp,sizeof(tmp),ACC_PFPATH,PlayerName(playerid));
	tmp = dini_Get(tmp,"ChatColor");
	if(!strcmp(tmp,"default",true)) tmp = "FFFFFF";
	return tmp;
}

/* ------------------------------------------------------------------------------- */

stock CreateGang(gcolor[],gname[])
{
	new tmp[512],coords[1024],newgangid;
	
	newgangid = GetFreeGangID();
	format(tmp,sizeof(tmp),GSYS_PGANGPATH,newgangid);
	
	dini_Create(tmp);
	if(!dini_Exists(tmp)) return 0;
	
	format(coords,sizeof(coords),"0.0 0.0 0.0 0.0");
	
	dini_Set(tmp,"Color",gcolor);
	dini_Set(tmp,"Name",gname);
	dini_Set(tmp,"Spawn",coords);

	new tmp2[512];
	for(new j=GSYS_RANK_MIN; j<GSYS_RANK_MAX+1; j++)
	{
	    format(tmp2,sizeof(tmp2),"Rank%iSkin",j);
		dini_IntSet(tmp,tmp2,0);
	}
	
	return newgangid;
}

/* ------------------------------------------------------------------------------- */

public UnlockChat(playerid)
{
	return SetPVarInt(playerid,"LockChat",0);
}

/* ------------------------------------------------------------------------------- */

stock UpdatePlayerSettings(playerid)
{
	if(!GetPVarInt(playerid,"Registered")) return 0;
	
    new tmp[512];
	format(tmp,sizeof(tmp),ACC_PFPATH,PlayerName(playerid));
	if(!dini_Exists(tmp))
	{
	    if(!dini_Create(tmp)) return 0;
	    dini_IntSet(tmp,"FROnCTRL",0);
	    dini_IntSet(tmp,"AutoRepair",1);
	    dini_IntSet(tmp,"ShowNickNames",1);
	    dini_Set(tmp,"ChatColor","default");
	    SetPVarInt(playerid,"PlF_FROnCTRL",dini_Int(tmp,"FROnCTRL"));
	    SetPVarInt(playerid,"PlF_AutoRepair",dini_Int(tmp,"AutoRepair"));
	    SetPVarInt(playerid,"PlF_ShowNickNames",dini_Int(tmp,"ShowNickNames"));
	    SetPVarString(playerid,"PlI_ChatColor",dini_Get(tmp,"ChatColor"));
	}
	else
	{
	    SetPVarInt(playerid,"PlF_FROnCTRL",dini_Int(tmp,"FROnCTRL"));
	    SetPVarInt(playerid,"PlF_AutoRepair",dini_Int(tmp,"AutoRepair"));
	    SetPVarInt(playerid,"PlF_ShowNickNames",dini_Int(tmp,"ShowNickNames"));
	    SetPVarString(playerid,"PlI_ChatColor",dini_Get(tmp,"ChatColor"));
	}
	return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetPlayerGangSpawn(playerid)
{
	new gangid;
	gangid = GetPlayerGangID(playerid);
	
	new tmp[1024],tmpc[4],cdx;
	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gangid);
	
	tmp=dini_Get(tmp,"Spawn");
	
	for(new c=0; c<4; c++) tmpc[c] = strval(strtok(tmp,cdx));
	
	return tmpc;
}

/* ------------------------------------------------------------------------------- */

stock GangExists(gangid)
{
    new tmp[512];

	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gangid);

	if(!dini_Exists(tmp)) return 0;
	else return 1;
}

/* ------------------------------------------------------------------------------- */

stock ShowSkinPreviewForPlayer(playerid,skinid)
{
    ShowModelSelectionMenu(playerid, gsys_skinpreview[skinid], "~b~Ckњ®", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
	return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetFreeGangID()
{
	new tmp[512],freegangid=-1;
	
	for(new i=0; i<MAX_GANGS; i++)
	{
		format(tmp,sizeof(tmp),GSYS_PGANGPATH,i);
	    if(!dini_Exists(tmp))
	    {
	        freegangid=i;
	        break;
	    }
	    else continue;
	}
	
	if(freegangid!=-1) return freegangid;
	else return -1;
}

/* ------------------------------------------------------------------------------- */

stock RemoveGang(gangid)
{
	new tmp[512];
	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gangid);
	
	if(!dini_Exists(tmp)) return 0;
	
	dini_Remove(tmp);
	
	if(dini_Exists(tmp)) return 0;
	else return 1;
}

/* ------------------------------------------------------------------------------- */

stock SetPlayerGangName(playerid,name[])
{
	new satt = strlen(name);
	NonValid:satt(1,512) return 0;
	
	new tmp[512],gidtmp;
	format(tmp,sizeof(tmp),GSYS_PFILEPATH,PlayerName(playerid));

	gidtmp = dini_Int(tmp,"GangID");
	if(!GangExists(gidtmp)) return 0;

	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gidtmp);
	dini_Set(tmp,"Name",name);

	return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetPlayerGangName(playerid)
{
	new tmp[512],gidtmp;
	format(tmp,sizeof(tmp),GSYS_PFILEPATH,PlayerName(playerid));
	
	gidtmp = dini_Int(tmp,"GangID");
	
	format(tmp,sizeof(tmp),GSYS_PGANGPATH,gidtmp);
	
	new gntmp[512];
	gntmp = dini_Get(tmp,"Name");
	
	return gntmp;
}

/* ------------------------------------------------------------------------------- */

stock SetPlayerGangRank(playerid,rankid)
{
    new tmp[512];
	format(tmp,sizeof(tmp),GSYS_PFILEPATH,PlayerName(playerid));
	
	if(!dini_Exists(tmp)) return 0;
	
	if(!dini_IntSet(tmp,"Rank",rankid)) return 0;
	else return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetPlayerGangID(playerid)
{
	new tmp[512];
	format(tmp,sizeof(tmp),GSYS_PFILEPATH,PlayerName(playerid));

	if(!dini_Exists(tmp)) return 0;
	if(!dini_Isset(tmp,"GangID")) return 0;
	
	SetPVarInt(playerid,"PGangID",dini_Int(tmp,"GangID"));
	
	return dini_Int(tmp,"GangID");
}

/* ------------------------------------------------------------------------------- */

stock SetPlayerGangID(playerid,gangid)
{
    new tmp[512];
	format(tmp,sizeof(tmp),GSYS_PFILEPATH,PlayerName(playerid));

	if(!dini_Exists(tmp)) return 0;
	
	SetPVarInt(playerid,"PGangID",gangid);
	SetPVarInt(playerid,"TempoGID",INVALID_GANG_ID);
	
	if(!dini_IntSet(tmp,"GangID",gangid)) return 0;
	else return 1;
}

/* ------------------------------------------------------------------------------- */

stock ComponentIsValid(vehicleid,componentid)
{
	if(!dini_Exists("/data/vehicles_components.ini")) return 0;
	
	new tmp[1024],tmp2[1024];
	new vehiclemodel = GetVehicleModel(vehicleid);
	format(tmp,sizeof(tmp),"%i",vehiclemodel);
	if(!dini_Isset("/data/vehicles_components.ini",tmp)) return 0;
	tmp = dini_Get("/data/vehicles_components.ini",tmp);
	format(tmp2,sizeof(tmp2),"%i",componentid);
	if(strfind(tmp,tmp2,false) == -1) return 0;
	else return 1;
}

/* ------------------------------------------------------------------------------- */

public AR_UnFrzPlr(playerid)
{
	TogglePlayerControllable(playerid,1);
	return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetPlayerSavedVehicles(playerid)
{
	new tmp[512],tmp2[MAX_SAVED_VEHICLES][512],tmp3[128];
	format(tmp,sizeof(tmp),ACC_PFPATH,PlayerName(playerid));
	for(new i=0; i<MAX_SAVED_VEHICLES; i++)
	{
		format(tmp3, sizeof(tmp3), "Vehicle%i", i);
		if(!dini_Isset(tmp,tmp3)) tmp2[i] = "empty";
		else tmp2[i] = dini_Get(tmp,tmp3);
	}
	return tmp2;
}

/* ------------------------------------------------------------------------------- */

stock GetPlayerSavedVehicleInSlot(playerid,slotid)
{
    new tmp[512],tmp3[128];
	format(tmp,sizeof(tmp),ACC_PFPATH,PlayerName(playerid));
	format(tmp3, sizeof(tmp3), "Vehicle%i", slotid);
	tmp = dini_Get(tmp,tmp3);
	return tmp;
}

/* ------------------------------------------------------------------------------- */

forward CCFP(playerid,type);
public CCFP(playerid,type)
{
	new tmp[128];
	
	switch(type) // 0 - Kick; 1 - Ban
	{
 	case 0:
 		{
 		    format(tmp,sizeof(tmp),"kick %i",playerid);
			SendRconCommand(tmp);
		}
	case 1:
	    {
 		    format(tmp,sizeof(tmp),"ban %i",playerid);
			SendRconCommand(tmp);
	    }
	default: return 0;
	}
	
	return 1;
}

/* ------------------------------------------------------------------------------- */

stock PreloadAnimLib(playerid)
{
	ApplyAnimation(playerid,"BOMBER","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"RAPPING","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"SHOP","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"BEACH","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"SMOKING","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"FOOD","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"ON_LOOKERS","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"DEALER","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"CRACK","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"CARRY","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"COP_AMBIENT","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"PARK","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"INT_HOUSE","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"FOOD","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"CRIB","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"ROB_BANK","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"JST_BUISNESS","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"PED","null",0.0,0,0,0,0,0);
	ApplyAnimation(playerid,"OTB","null",0.0,0,0,0,0,0);
	SetPVarInt(playerid, "Animations", 1);
}

/* ------------------------------------------------------------------------------- */

stock SavePlayerVehicle(playerid,vehiclemodel,vc[13],slotid)
{
	new tmp[512],tmp2[512],tmp3[128];
	format(tmp,sizeof(tmp),ACC_PFPATH,PlayerName(playerid));
	if(!dini_Exists(tmp)) return 0;
	format(tmp2,sizeof(tmp2),"%i ",vehiclemodel);
	for(new t=0; t<13; t++) format(tmp2,sizeof(tmp2),"%s%i ",tmp2,vc[t]);
	format(tmp3, sizeof(tmp3), "Vehicle%i", slotid);
   	dini_Set(tmp,tmp3,tmp2);

	if(!dini_Isset(tmp,tmp3)) return 0;
	else return 1;
}

/* ------------------------------------------------------------------------------- */

stock UpdateVehicleColor(playerid,vehicleid)
{
	new tmpclrstr[128];
	ChangeVehicleColor(vehicleid,GetPVarInt(playerid,"PlayerCarColor1"),GetPVarInt(playerid,"PlayerCarColor2"));
	format(tmpclrstr,sizeof(tmpclrstr),"~w~Colors:~n~~y~1: ~b~%i ~y~2: ~b~%i",GetPVarInt(playerid,"PlayerCarColor1"),GetPVarInt(playerid,"PlayerCarColor2"));
	GameTextForPlayer(playerid,tmpclrstr,500,5);
	return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetVehicleAvailablePaintjobs(playerid,modelid)
{
	new returndlgstr[512],returndlgcapt[128];
	switch(modelid)
	{
	case 483: // camper
		{
			format(returndlgcapt,sizeof(returndlgcapt),"Доступна 1 покрасочная работа");
			format(returndlgstr,sizeof(returndlgstr),"Покрасочная работа 1");
			ShowPlayerDialog(playerid,DIALOG_PAINTJOBS_YES,DIALOG_STYLE_LIST,returndlgcapt,returndlgstr,DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
		}
	case 534,535,536,558,559,560,561,562,565,567,576: // remington, slamvan, blade, uranus, jester, sultan, stratum, elegy, flash, savanna, tornado
		{
			format(returndlgcapt,sizeof(returndlgcapt),"Доступно 3 покрасочные работы");
			format(returndlgstr,sizeof(returndlgstr),"Покрасочная работа 1\nПокрасочная работа 2\nПокрасочная работа 3");
			ShowPlayerDialog(playerid,DIALOG_PAINTJOBS_YES,DIALOG_STYLE_LIST,returndlgcapt,returndlgstr,DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
		}
	case 575: // broadway
		{
			format(returndlgcapt,sizeof(returndlgcapt),"Доступно 2 покрасочные работы");
			format(returndlgstr,sizeof(returndlgstr),"Покрасочная работа 1\nПокрасочная работа 2");
			ShowPlayerDialog(playerid,DIALOG_PAINTJOBS_YES,DIALOG_STYLE_LIST,returndlgcapt,returndlgstr,DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
		}
	default:
		{
			format(returndlgcapt,sizeof(returndlgcapt),"Нет доступных покрасочных работ");
			format(returndlgstr,sizeof(returndlgstr),"Нет доступных покрасочных работ");
			ShowPlayerDialog(playerid,DIALOG_PAINTJOBS_NON,DIALOG_STYLE_LIST,returndlgcapt,returndlgstr,DIALOG_BUTTON_BACK_TEXT,"");
		}
	}
	return 1;
}

/* -------------------------------------------------------------------------------

public OnPlayerAirbreak(playerid)
{
    new playername[24], string[128];
    GetPlayerName(playerid, playername, sizeof(playername));

	format(string,sizeof(string),"{FF0000}[Античит]: {FFFFFF}Игрок %s кикнут за использование Air-Break",playername);
    SendClientMessageToAll(-1,string);
    Kick(playerid);
}
 */

/* ------------------------------------------------------------------------------- */

public Count(playerid,a)
{
	new tmp[64];
	format(tmp,sizeof(tmp),"~g~%i",a);
	GameTextForPlayer(playerid,tmp,1000,5);
	return 1;
}
//==============================================================================
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
	return 1;
}
//==============================================================================
/* ------------------------------------------------------------------------------- */

stock GetPlayerVehicleSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid)) GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 150.0;
    return floatround(ST[3]);
}

/* ------------------------------------------------------------------------------- */

stock SetWeatherFromPVar(playerid)
{
	SetPlayerWeather(playerid,GetPVarInt(playerid,"PlayerWeather"));
	return 1;
}

/* ------------------------------------------------------------------------------- */

stock ConvertNonNormaQuatToEuler(Float: qw, Float: qx, Float:qy, Float:qz, &Float:heading, &Float:attitude, &Float:bank)
{
    new Float: sqw = qw*qw;
    new Float: sqx = qx*qx;
    new Float: sqy = qy*qy;
    new Float: sqz = qz*qz;
    new Float: unit = sqx + sqy + sqz + sqw;
    new Float: test = qx*qy + qz*qw;
    if (test > 0.499*unit)
    {
        heading = 2*atan2(qx,qw);
        attitude = 3.141592653/2;
        bank = 0;
        return 1;
    }
    if (test < -0.499*unit)
    {
        heading = -2*atan2(qx,qw);
        attitude = -3.141592653/2;
        bank = 0;
        return 1;
    }
    heading = atan2(2*qy*qw - 2*qx*qz, sqx - sqy - sqz + sqw);
    attitude = asin(2*test/unit);
    bank = atan2(2*qx*qw - 2*qy*qz, -sqx + sqy - sqz + sqw);
    return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetPlayerStatLevel(playerid,statname[])
{
	new tmp[512];
	format(tmp,sizeof(tmp),ACC_PFPATH,PlayerName(playerid));
	if(!dini_Exists(tmp)) return 0;
	else return dini_Int(tmp,statname);
}

/* ------------------------------------------------------------------------------- */

stock SetPlayerStatLevel(playerid,statname[],level)
{
	new tmp[512];
	format(tmp,sizeof(tmp),ACC_PFPATH,PlayerName(playerid));
	if(!dini_Exists(tmp))
	{
	    if(!dini_Create(tmp)) return 0;
	    dini_IntSet(tmp,statname,level);
	}
	else dini_IntSet(tmp,statname,level);
	return 1;
}

/* ------------------------------------------------------------------------------- */

stock GetVehicleRotation(vehicleid, &Float:heading, &Float:attitude, &Float:bank)
{
    new Float:quat_w,Float:quat_x,Float:quat_y,Float:quat_z;
    GetVehicleRotationQuat(vehicleid,quat_w,quat_x,quat_y,quat_z);
    ConvertNonNormaQuatToEuler(quat_w,quat_x,quat_z,quat_y, heading, attitude, bank);
    bank = -1*bank;
    return 1;
}

/* ------------------------------------------------------------------------------- */

stock PlayerName(playerid)
{
	new tmppln[MAX_PLAYER_NAME];
	GetPlayerName(playerid, tmppln, sizeof(tmppln));
	return tmppln;
}

/* ------------------------------------------------------------------------------- */

strrest(const string[], &index)
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
