#include <a_samp>
#include <streamer>
#include <dini>
#include <dutils>
#include <ARAC_FS>

#define ACC_FILEPATH "/ARHSystem/players/%s.ini"
#define INTERIOR_FILEPATH "/ARHSystem/interiors/%i.ini"
#define HOUSE_FILEPATH "/ARHSystem/houses/%i.ini"

#define INVALID_DIALOG_ID 988725

#define DIALOG_HOUSEINFO 118
#define DIALOG_HOUSEINFO2 120
#define DIALOG_HOUSEMENU 128
#define DIALOG_HOUSEINTERIORS 322
#define DIALOG_HOUSESELL 511

#define MAX_INTERIORS 100
#define MAX_HOUSES 1000

#define HOUSE_MAXPRICE 100000000000
#define HOUSE_MINPRICE 100000

#define PMODEL_GHOUSE 1273
#define PMODEL_BHOUSE 1272

#define arcmd(%0) if(!strcmp(cmd,%0,true))
#define arpickup(%0) if(pickupid == %0)
#define ardialog(%0) if(dialogid == %0)
#define ar_SPD(%0,%1,%2,%3,%4,%5,%6) ShowPlayerDialog(%0,%1,%2,%3,%4,%5,%6)

#pragma unused ret_memcpy
#pragma dynamic 8096

new ARMHPickup[MAX_HOUSES]=-1,ARMHIcon[MAX_HOUSES]=-1,housestatus[MAX_HOUSES];

forward OnPlayerEnterHouse(playerid);
forward OnPlayerExitHouse(playerid);
forward OffPVar(playerid);

public OnFilterScriptInit()
{
	new ftmp[512],hcl,strinttmp[512],strhtmp[512],stritmp[512],strctmp[512],strcctmp[4],striinfo,strhlinfo,j;
	print("\n--------------------------------------");
	print("           AR Houses System");
	print("--------------------------------------\n");
	print(">>> Проверка папок...");
	print(">> Создание тестового файла в папке для файлов интерьеров...");
	j = (8+random(32))*(random(5)-1);
	format(ftmp,sizeof(ftmp),INTERIOR_FILEPATH,j);
	if(!dini_Create(ftmp)) print("> Создать тестовый файл не удалось");
	else
	{
		print("> Создать тестовый файл удалось");
		dini_Remove(ftmp);
	}
	print(">> Создание тестового файла в папке для файлов домов...");
	j = MAX_HOUSES+random(5);
	format(ftmp,sizeof(ftmp),HOUSE_FILEPATH,j);
	if(!dini_Create(ftmp)) print("> Создать тестовый файл не удалось");
	else
	{
		print("> Создать тестовый файл удалось");
		dini_Remove(ftmp);
	}
	print(">> Создание тестового файла в папке для файлов игроков...");
	format(ftmp,sizeof(ftmp),"_Test-File_");
	format(ftmp,sizeof(ftmp),ACC_FILEPATH,ftmp);
	if(!dini_Create(ftmp)) print("> Создать тестовый файл не удалось");
	else
	{
		print("> Создать тестовый файл удалось");
		dini_Remove(ftmp);
	}
	print("\n");
	print(">>> Загрузка интерьеров...");
	for(new i=1; i<MAX_INTERIORS+1; i++)
	{
		format(strinttmp,sizeof(strinttmp),INTERIOR_FILEPATH,i);
		if(!dini_Exists(strinttmp)) break;

		striinfo=i;
	}
	printf(">> Загружено интерьеров: %i",striinfo);
	print("\n");
	print(">>> Загрузка домов...");
	for(new m=0; m<MAX_HOUSES; m++)
	{
		format(strhtmp,sizeof(strhtmp),HOUSE_FILEPATH,m);
		if(!dini_Exists(strhtmp)) continue;
		
		hcl = dini_Int(strhtmp,"Closed");
		stritmp = dini_Get(strhtmp,"Owner");
		strctmp = dini_Get(strhtmp,"Location");
		strcctmp = ComputeCoordsFromString(strctmp);
		housestatus[m] = hcl;
		if(!strfind(stritmp,"none",false))
		{
			ARMHPickup[m] = CreateDynamicPickup(PMODEL_GHOUSE,23,strcctmp[0],strcctmp[1],strcctmp[2]);
			ARMHIcon[m] = CreateDynamicMapIcon(strcctmp[0],strcctmp[1],strcctmp[2],31,-1);
		}
		else
		{
			ARMHPickup[m] = CreateDynamicPickup(PMODEL_BHOUSE,23,strcctmp[0],strcctmp[1],strcctmp[2]);
			ARMHIcon[m] = CreateDynamicMapIcon(strcctmp[0],strcctmp[1],strcctmp[2],32,-1);
		}
		strhlinfo++;
	}
	printf(">> Загружено домов: %i",strhlinfo);
	print("\n--------------------------------------");
	print("           AR Houses System");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	print("\n--------------------------------------");
	print("           AR Houses System");
	print("--------------------------------------\n");
	print(">>> Выгрузка домов...");
	new strhtmp[512],strhlinfo;
	for(new u=0; u<MAX_HOUSES; u++)
	{
		format(strhtmp,sizeof(strhtmp),HOUSE_FILEPATH,u);
		if(!dini_Exists(strhtmp)) continue;

		DestroyDynamicPickup(ARMHPickup[u]);
		strhlinfo++;
	}
	printf(">> Выгружено домов: %i",strhlinfo);
	print("\n--------------------------------------");
	print("           AR Houses System");
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	new placcfstrtmp[512];
	format(placcfstrtmp,sizeof(placcfstrtmp),ACC_FILEPATH,PlayerName(playerid));
	if(!dini_Exists(placcfstrtmp)) dini_Create(placcfstrtmp);
	
	if(!dini_Isset(placcfstrtmp,"HouseID")) dini_IntSet(placcfstrtmp,"HouseID",-1);
	
	SetPVarInt(playerid,"openedHInfoDialog",0);
	SetPVarInt(playerid,"HousePrice",-1);
	SetPVarInt(playerid,"HouseID",-1);
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	DeletePVar(playerid,"openedHInfoDialog");
	DeletePVar(playerid,"HousePrice");
	DeletePVar(playerid,"HouseID");
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	new placcfstrtmp[MAX_PLAYER_NAME],housepstrtmp[512],tmp[1];
	format(placcfstrtmp,sizeof(placcfstrtmp),ACC_FILEPATH,PlayerName(playerid));

	if(dini_Isset(placcfstrtmp,"House"))
	{
		tmp[0] = dini_Int(placcfstrtmp,"House");
		format(housepstrtmp,sizeof(housepstrtmp),HOUSE_FILEPATH,tmp[0]);
	}
	
	SetPVarInt(playerid,"openedHInfoDialog",0);
	
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[512],aridx;
	cmd=strtok(cmdtext,aridx);
	
	arcmd("/sellhouse")
	{
		if(!GetPlayerInterior(playerid) || GetPlayerInterior(playerid)==980) return 1;

		new strtmp[512],houseid,owner[255],tmp[512],newownerid,cash,dlgmsg[512];
		format(strtmp,sizeof(strtmp),ACC_FILEPATH,PlayerName(playerid));
		houseid = dini_Int(strtmp,"HouseID");
		if(GetPVarInt(playerid,"HouseID")!=houseid) return 1;
		format(strtmp,sizeof(strtmp),HOUSE_FILEPATH,houseid);
		owner = dini_Get(strtmp,"Owner");
		if(strcmp(PlayerName(playerid),owner,false)==-1) return 1;
		
		tmp = strtok(cmdtext,aridx);
		if(!strlen(tmp))
		{
		    SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}/sellhouse [ID игрока] [сумма]");
		    return 1;
		}
		newownerid = strval(tmp);
		tmp = strtok(cmdtext,aridx);
		if(!strlen(tmp))
		{
		    SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}/sellhouse [ID игрока] [сумма]");
		    return 1;
		}
		cash = strval(tmp);
		if(cash < HOUSE_MINPRICE / 2 || cash > HOUSE_MAXPRICE)
		{
		    SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Вы не можете продать дом за эту сумму");
		    return 1;
		}
		if(cash < 0) cash = cash * (-1);
		if(GetPlayerMoney(newownerid)<cash)
		{
		    SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}У этого игрока недостаточно денег для покупки");
		    return 1;
		}
		
		format(dlgmsg,sizeof(dlgmsg),"{FFFFFF}%s предлагает Вам купить его(её) дом за %i$",PlayerName(playerid),cash);
		ShowPlayerDialog(newownerid,DIALOG_HOUSESELL,DIALOG_STYLE_MSGBOX,"Покупка дома",dlgmsg,"Купить","Закрыть");
		SetPVarInt(newownerid,"HouseToBought",houseid);
		SetPVarInt(newownerid,"OldHouseOwner",playerid);
		SetPVarInt(newownerid,"HouseBuyCash",cash);
		
	    return 1;
	}
	arcmd("/exit")
	{
		if(!GetPlayerInterior(playerid) || GetPlayerInterior(playerid)==980) return 1;
		
		new strtmp[512],houseid;
		format(strtmp,sizeof(strtmp),ACC_FILEPATH,PlayerName(playerid));
		houseid = GetPVarInt(playerid,"HouseID");
		format(strtmp,sizeof(strtmp),HOUSE_FILEPATH,houseid);
		new epos[4],eangle[512];
		eangle = dini_Get(strtmp,"ExtA");
		strtmp = dini_Get(strtmp,"Location");
		epos = ComputeCoordsFromString(strtmp);
		
		SetPlayerPos(playerid,epos[0],epos[1],epos[2]);
		SetPlayerFacingAngle(playerid,strval(eangle));
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid,0);
		
		SetPVarInt(playerid,"openedHInfoDialog",1);
		SetTimerEx("OffPVar",1500,false,"i",playerid);
		
	    return 1;
	}
	arcmd("/housemenu")
	{
	    if(!GetPlayerInterior(playerid) || GetPlayerInterior(playerid)==980) return 1;

	    new content[512],houseid,hsale,hint,hstatus[512],hsstatus[512],strtmp[512];
	    
		format(strtmp,sizeof(strtmp),ACC_FILEPATH,PlayerName(playerid));
		houseid = dini_Int(strtmp,"HouseID");
		format(strtmp,sizeof(strtmp),HOUSE_FILEPATH,houseid);
		if(strfind(dini_Get(strtmp,"Owner"),PlayerName(playerid),false)==-1)
		{
		    SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Вы не являетесь владельцем данного дома");
		    return 1;
		}
		hsale = dini_Int(strtmp,"ForSale");
		hint = dini_Int(strtmp,"Int");
		switch(hsale)
		{
			case 0: format(hsstatus,sizeof(hsstatus),"не продаётся");
			case 1: format(hsstatus,sizeof(hsstatus),"продаётся");
			default: format(hsstatus,sizeof(hsstatus),"неизвестно");
		}
		switch(housestatus[houseid])
		{
			case 0: format(hstatus,sizeof(hstatus),"открыт");
			case 1: format(hstatus,sizeof(hstatus),"закрыт");
			default: format(hstatus,sizeof(hstatus),"неизвестно");
		}
	    
	    format(content,sizeof(content),
		"Доступность дома {C6C6C6}[%s]\n{FFFFFF}Выставить на продажу {C6C6C6}[сейчас: %s]\n{FFFFFF}Изменить интерьер {C6C6C6}[текущий: %i]\n{FFFFFF}Продать дом игроку",
		hstatus,hsstatus,hint);
	    
	    ar_SPD(playerid,DIALOG_HOUSEMENU,DIALOG_STYLE_LIST,"Меню дома",content,"Выбрать","Закрыть");
	    return 1;
	}
	arcmd("/makehouse")
	{
		if(!IsPlayerAdmin(playerid)) return 0;
		
		new hprice,cmdtmp[512],Float:tmp[3],tmp2[2],tmp3[512],tmp4[512],tmp5,hint,tmp6[512];
		cmdtmp = strtok(cmdtext,aridx);
		if(!strlen(cmdtmp)) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Создать дом: {FFF000}/makehouse [цена дома] [номер интерьера]");
		hprice = strval(cmdtmp);
		cmdtmp = strtok(cmdtext,aridx);
		if(!strlen(cmdtmp)) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Создать дом: {FFF000}/makehouse [цена дома] [номер интерьера]");
		hint = strval(cmdtmp);
		if(hint < 0 || hint > MAX_INTERIORS) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Неверный номер интерьера");
		format(tmp6,sizeof(tmp6),INTERIOR_FILEPATH,hint);
		if(!dini_Exists(tmp6)) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Интерьер не найден");
		if(hprice < HOUSE_MINPRICE || hprice > HOUSE_MAXPRICE) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Неверная цена дома");
		GetPlayerPos(playerid,tmp[0],tmp[1],tmp[2]);
		tmp5 = GetPlayerVirtualWorld(playerid);
		tmp2[0] = GetFreeHouseID();
		tmp2[1] = GetPlayerInterior(playerid);
		format(tmp3,sizeof(tmp3),HOUSE_FILEPATH,tmp2[0]);
		dini_Create(tmp3);
		format(tmp4,sizeof(tmp4),"%f %f %f",tmp[0],tmp[1],tmp[2]);
		dini_Set(tmp3,"Owner","none");
		dini_Set(tmp3,"Location",tmp4);
		dini_IntSet(tmp3,"ForSale",1);
		new Float:plang;
		GetPlayerFacingAngle(playerid,plang);
		plang = plang * (-1);
		dini_FloatSet(tmp3,"ExtA",plang);
		dini_IntSet(tmp3,"VirtualWorld",tmp5);
		dini_IntSet(tmp3,"Int",hint);
		dini_IntSet(tmp3,"Price",hprice);
		dini_IntSet(tmp3,"Closed",0);
		housestatus[tmp2[0]] = 0;
		
		ARMHPickup[tmp2[0]] = CreateDynamicPickup(PMODEL_GHOUSE,23,tmp[0],tmp[1],tmp[2]);
		ARMHIcon[tmp2[0]] = CreateDynamicMapIcon(tmp[0],tmp[1],tmp[2],31,-1);
		
		if(dini_Exists(tmp3) && dini_Isset(tmp3,"Location") && dini_Isset(tmp3,"Owner") && dini_Isset(tmp3,"Int"))
		{
			format(tmp4,sizeof(tmp4),"{3494FF}[ARHSystem] {FFFFFF}Дом %i успешно создан",tmp2[0]);
			SendClientMessage(playerid,-1,tmp4);
		}
		else
		{
			format(tmp4,sizeof(tmp4),"{3494FF}[ARHSystem] {FFFFFF}Ошибка при создании дома %i",tmp2[0]);
			SendClientMessage(playerid,-1,tmp4);
		}

		return 1;
	}
	arcmd("/gethinfo")
	{
		if(!IsPlayerAdmin(playerid)) return 0;
		
		new houseid,tmp[1024],tmp2[512],tmp3[512],crdstmp[4],owner[512];
		
		tmp = strtok(cmdtext,aridx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Узнать информацию о доме: {FFF000}/gethinfo [ID дома]");
		houseid = strval(tmp);
		
		format(tmp,sizeof(tmp),HOUSE_FILEPATH,houseid);
		if(!dini_Exists(tmp))
		{
			format(tmp,sizeof(tmp),"{3494FF}[ARHSystem] {FFFFFF}Дома %i не существует",houseid);
			return SendClientMessage(playerid,-1,tmp);
		}
		
		format(tmp2,sizeof(tmp2),HOUSE_FILEPATH,houseid);
		tmp3 = dini_Get(tmp2,"Location");
		owner = dini_Get(tmp2,"Owner");
		if(!strfind(owner,"none",false)) format(owner,sizeof(owner),"нет");
		crdstmp = ComputeCoordsFromString(tmp3);
		format(tmp,sizeof(tmp),
		"\t{3494FF}Дом %i:\n{FFFFFF}Владелец: {FFF000}%s\n{FFFFFF}Координаты:\nX: {FFF000}%d\n{FFFFFF}Y: {FFF000}%d\n{FFFFFF}Z: {FFF000}%d\n{FFFFFF}Виртуальный мир: {FFF000}%i",
		houseid,owner,crdstmp[0],crdstmp[1],crdstmp[2],crdstmp[3]);
		ar_SPD(playerid,INVALID_DIALOG_ID,DIALOG_STYLE_MSGBOX,"ARHSystem",tmp,"Закрыть","");
		
		return 1;
	}
	arcmd("/gotohint")
	{
		if(!IsPlayerAdmin(playerid)) return 0;
		
		new intnum,tmp[1024],intpos[3],vw;
		tmp = strtok(cmdtext,aridx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Телепортироваться в интерьер: {FFF000}/gotohint [номер интерьера]");
		intnum = strval(tmp);
		
		if(intnum < 1 || intnum > MAX_INTERIORS) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Неверный номер интерьера");
		
		format(tmp,sizeof(tmp),INTERIOR_FILEPATH,intnum);
		if(!dini_Exists(tmp)) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Интерьер не найден");
		
		intpos = ComputeCoordsFromIntsFile(intnum);
		vw = GetVirtualWorldFromIntsFile(intnum);
		
		SetPlayerInterior(playerid,vw);
		SetPlayerVirtualWorld(playerid,vw);
		SetPlayerPos(playerid,intpos[0],intpos[1],intpos[2]);
		
		return 1;
	}
	arcmd("/deletehouse")
	{
		if(!IsPlayerAdmin(playerid)) return 0;
		
		new houseid,tmp[512];
		tmp=strtok(cmdtext,aridx);
		if(!strlen(tmp)) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Удалить дом: {FFF000}/deletehouse [номер дома]");
		houseid = strval(tmp);
		
		if(houseid < 0 || houseid >= MAX_HOUSES) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Неверный ID дома");
		
		format(tmp,sizeof(tmp),HOUSE_FILEPATH,houseid);
		if(!dini_Exists(tmp))
		{
			format(tmp,sizeof(tmp),"{3494FF}[ARHSystem] {FFFFFF}Дом %i не найден",houseid);
			return SendClientMessage(playerid,-1,tmp);
		}
		
		format(tmp,sizeof(tmp),HOUSE_FILEPATH,houseid);
		DestroyDynamicPickup(ARMHPickup[houseid]);
		dini_Remove(tmp);
		
		format(tmp,sizeof(tmp),"{3494FF}[ARHSystem] {FFFFFF}Дом %i удалён",houseid);
		SendClientMessage(playerid,-1,tmp);
		
		return 1;
	}
	
	return 0;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(GetPlayerState(playerid)!=PLAYER_STATE_ONFOOT) return 0;
	if(ARMHPickup[0]==-1) return 0;
	
    for(new i=0; i<MAX_HOUSES; i++)
	{
		arpickup(ARMHPickup[i])
		{
			if(GetPVarInt(playerid,"openedHInfoDialog"))
			{
				return 1;
			}

			new dlgstrtmp[1024],hfiletmp[512],ownerstatus[512],strtmp[1024],hprice,houseid,owner[1024],hsaleinfo,forsale[512];
			SetPVarInt(playerid,"TempHouseID",i);
			SetPVarInt(playerid,"openedHInfoDialog",1);
			format(hfiletmp,sizeof(hfiletmp),HOUSE_FILEPATH,i);
			strtmp = dini_Get(hfiletmp,"Owner");
			if(!strcmp(strtmp,"none",false)) format(strtmp,sizeof(strtmp),"нет");
			owner = strtmp;
			strtmp = dini_Get(hfiletmp,"Price");
			hprice = strval(strtmp);
			hsaleinfo = dini_Int(hfiletmp,"ForSale");
			if(hsaleinfo) format(forsale,sizeof(forsale),"{00EE16}Продаётся");
			else format(forsale,sizeof(forsale),"{FF0000}Не продаётся");
			houseid=i;
			for(new c=0; c<GetMaxPlayers(); c++)
			{
			    if(!IsPlayerConnected(c)) continue;
				if(!strcmp(owner,PlayerName(c),false))
				{
					format(ownerstatus,sizeof(ownerstatus),"{00FF30}в сети");
				}
				else
				{
					format(ownerstatus,sizeof(ownerstatus),"{FF0000}не в сети");
				}
			}
			format(dlgstrtmp,sizeof(dlgstrtmp),
			"{FFFFFF}Владелец: {FFF000}%s {C6C6C6}[%s{C6C6C6}]\n{FFFFFF}Цена: {FFF000}%i$\n{FFFFFF}ID: {FFF000}%i\n\n\t%s",
			owner,ownerstatus,hprice,houseid,forsale);
			if(!strcmp(owner,"нет",false)) ar_SPD(playerid,DIALOG_HOUSEINFO,DIALOG_STYLE_MSGBOX,"Информация о доме",dlgstrtmp,"Купить","Закрыть");
			else ar_SPD(playerid,DIALOG_HOUSEINFO2,DIALOG_STYLE_MSGBOX,"Информация о доме",dlgstrtmp,"Войти","Закрыть");
			SetPVarInt(playerid,"HousePrice",hprice);
			SetPVarInt(playerid,"HouseID",i);
			return 1;
		}
	}
	return 1;
}

public OnPlayerEnterHouse(playerid)
{
	SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Введите {FFF000}/housemenu {FFFFFF}для открытия меню дома");
	SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Введите {FFF000}/exit{FFFFFF}, чтобы выйти из дома");
	SetCameraBehindPlayer(playerid);
	return 1;
}

public OnPlayerExitHouse(playerid)
{
	SetCameraBehindPlayer(playerid);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	ardialog(DIALOG_HOUSESELL && response)
	{
	    new tmp[512],houseid,cash,oldownerid;
	    houseid = GetPVarInt(playerid,"HouseToBought");
	    oldownerid = GetPVarInt(playerid,"OldHouseOwner");
	    cash = GetPVarInt(playerid,"HouseBuyCash");
	    DeletePVar(playerid,"HouseToBought");
	    DeletePVar(playerid,"OldHouseOwner");
	    DeletePVar(playerid,"HouseBuyCash");
	    
	    if(GetPlayerMoney(playerid)<cash)
	    {
	        SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}У вас недостаточно денег для покупки");
	        return 1;
	    }
	    
	    format(tmp,sizeof(tmp),ACC_FILEPATH,PlayerName(oldownerid));
	    dini_IntSet(ACC_FILEPATH,"HouseID",-1);
	    format(tmp,sizeof(tmp),ACC_FILEPATH,PlayerName(playerid));
	    dini_IntSet(ACC_FILEPATH,"HouseID",houseid);
	    format(tmp,sizeof(tmp),HOUSE_FILEPATH,houseid);
	    dini_Set(HOUSE_FILEPATH,"Owner",PlayerName(playerid));
	    
	    GivePlayerMoney(playerid,cash*(-1));
	    GivePlayerMoney(oldownerid,cash);
	    
	    SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Дом куплен");
	    SendClientMessage(oldownerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Дом продан");
	    
	    OnPlayerSpawn(oldownerid);
	    
	    return 1;
	}
	ardialog(DIALOG_HOUSEINTERIORS && response)
	{
	    new tmp[512],houseid;
	    format(tmp,sizeof(tmp),ACC_FILEPATH,PlayerName(playerid));
		houseid = dini_Int(tmp,"HouseID");
		format(tmp,sizeof(tmp),HOUSE_FILEPATH,houseid);
		dini_IntSet(tmp,"Int",listitem+1);
		new interiorid = GetVirtualWorldFromIntsFile(listitem+1);
		new newintpos[4];
		newintpos = ComputeCoordsFromIntsFile(listitem+1);
		SetPlayerInterior(playerid,interiorid);
		SetPlayerPos(playerid,newintpos[0],newintpos[1],newintpos[2]);
		SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Интерьер успешно изменён");
	    return 1;
	}
	ardialog(DIALOG_HOUSEMENU && response)
	{
		new houseid,tmp[512],tmpd,tmpc[512];
		format(tmp,sizeof(tmp),ACC_FILEPATH,PlayerName(playerid));
		houseid = dini_Int(tmp,"HouseID");
		format(tmp,sizeof(tmp),HOUSE_FILEPATH,houseid);
		
		switch(listitem)
		{
		    case 0:
		        {
		            switch(housestatus[houseid])
		            {
		                case 0:
		                    {
		                        housestatus[houseid] = 1;
								SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Теперь дом закрыт");
		                    }
						case 1:
						    {
		                        housestatus[houseid] = 0;
								SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Теперь дом открыт");
						    }
		            }
		            return 1;
		        }
			case 1:
			    {
		            switch(dini_Int(tmp,"ForSale"))
		            {
		                case 0:
							{
								dini_IntSet(tmp,"ForSale",1);
								SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Дом выставлен на продажу");
							}
		                case 1:
							{
								dini_IntSet(tmp,"ForSale",0);
								SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Дом снят с продажи");
							}
		            }
			        return 1;
			    }
			case 2:
			    {
			        for(new i=1; i<MAX_INTERIORS+1; i++)
			        {
			            format(tmpc,sizeof(tmpc),INTERIOR_FILEPATH,i);
			            if(!dini_Exists(tmpc))
			            {
			                tmpd = i-1;
			                break;
			            }
			        }
			        format(tmpc,sizeof(tmpc),"");
			        for(new i=0; i<tmpd; i++)
					{
					    format(tmpc,sizeof(tmpc),"%sИнтерьер %i\n",tmpc,i+1);
					}
					
					ar_SPD(playerid,DIALOG_HOUSEINTERIORS,DIALOG_STYLE_LIST,"Интерьеры для дома",tmpc,"Выбрать","Заркыть");
					
			        return 1;
			    }
			case 3:
			    {
			        ar_SPD(playerid,INVALID_DIALOG_ID,DIALOG_STYLE_MSGBOX,"","{FFFFFF}Для продажи дома другому игроку используйте команду /sellhouse","Закрыть","");
			        return 1;
			    }
		}
		
	    return 1;
	}
	ardialog(DIALOG_HOUSEINFO)
	{
		if(!response) return SetPVarInt(playerid,"openedHInfoDialog",0);
		
		SetPVarInt(playerid,"openedHInfoDialog",0);
		
		new tmp[512],hfsinfo,hfiletmp[512];
		format(tmp,sizeof(tmp),ACC_FILEPATH,PlayerName(playerid));
		hfsinfo = dini_Int(tmp,"HouseID");
		if(hfsinfo!=-1)
		{
		    return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}У вас уже есть дом");
		}
		format(tmp,sizeof(tmp),HOUSE_FILEPATH,GetPVarInt(playerid,"HouseID"));
		hfsinfo = dini_Int(tmp,"ForSale");
		if(!hfsinfo) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Дом не продаётся");
		
		if(GetPlayerMoney(playerid) < GetPVarInt(playerid,"HousePrice")) return SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Недостаточно денег для покупки дома");
		
		new tmppos[3]/*,vw*/;
		format(tmp,sizeof(tmp),HOUSE_FILEPATH,GetPVarInt(playerid,"HouseID"));
		
		dini_Set(tmp,"Owner",PlayerName(playerid));
		dini_IntSet(tmp,"ForSale",0);
		
		format(tmp,sizeof(tmp),ACC_FILEPATH,PlayerName(playerid));
		dini_IntSet(tmp,"HouseID",GetPVarInt(playerid,"HouseID"));
		
		format(tmp,sizeof(tmp),HOUSE_FILEPATH,GetPVarInt(playerid,"HouseID"));
//		vw = dini_Int(tmp,"Int");
		tmp = dini_Get(tmp,"Location");
		tmppos = ComputeCoordsFromString(tmp);
		
		DestroyDynamicPickup(ARMHPickup[GetPVarInt(playerid,"HouseID")]);
		DestroyDynamicMapIcon(ARMHIcon[GetPVarInt(playerid,"HouseID")]);
		ARMHIcon[GetPVarInt(playerid,"HouseID")] = CreateDynamicMapIcon(tmppos[0],tmppos[1],tmppos[2],32,-1);
		ARMHPickup[GetPVarInt(playerid,"HouseID")] = CreateDynamicPickup(PMODEL_BHOUSE,23,tmppos[0],tmppos[1],tmppos[2]);
		
		SendClientMessage(playerid,-1,"{3494FF}[ARHSystem] {FFFFFF}Дом куплен");
		
		format(hfiletmp,sizeof(hfiletmp),HOUSE_FILEPATH,GetPVarInt(playerid,"TempHouseID"));
		GivePlayerMoney(playerid,strval(dini_Get(hfiletmp,"Price"))*(-1));
		
		OnDialogResponse(playerid,DIALOG_HOUSEINFO2,1,0,"a");

		return 1;
	}
	ardialog(DIALOG_HOUSEINFO2)
	{
	    if(!response) return SetPVarInt(playerid,"openedHInfoDialog",0);
	    
	    SetPVarInt(playerid,"openedHInfoDialog",0);
	    
	    new tmp[512],hintvw,intpostmp[4];
	    format(tmp,sizeof(tmp),HOUSE_FILEPATH,GetPVarInt(playerid,"HouseID"));

		if(housestatus[GetPVarInt(playerid,"HouseID")])
	    {
	        if(!strfind(dini_Get(tmp,"Owner"),PlayerName(playerid),false))
	        {
	            GameTextForPlayer(playerid,"~y~~h~ѓo—po Јo›aћoўa¦©",1000,1);
	        }
	        else
	        {
		        GameTextForPlayer(playerid,"~r~~h~€akpЁ¦o",1000,1);
		        return 1;
			}
	    }
	    hintvw = dini_Int(tmp,"Int");
	    intpostmp = ComputeCoordsFromIntsFile(hintvw);
	    hintvw = GetVirtualWorldFromIntsFile(hintvw);
	    
	    SetPlayerVirtualWorld(playerid,GetPVarInt(playerid,"HouseID"));
	    SetPlayerInterior(playerid,hintvw);
	    SetPlayerPos(playerid,intpostmp[0],intpostmp[1],intpostmp[2]);
	    
	    OnPlayerEnterHouse(playerid);
	    
	    return 1;
	}
	
	return 0;
}

public OffPVar(playerid)
{
	SetPVarInt(playerid,"openedHInfoDialog",0);
	return 1;
}

stock GetFreeHouseID()
{
	new tmp[512],fhid;
	for(new i=0; i<MAX_HOUSES; i++)
	{
		format(tmp,sizeof(tmp),HOUSE_FILEPATH,i);
		if(!dini_Exists(tmp))
		{
			fhid=i;
			return fhid;
		}
	}
	return -1;
}

stock GetInteriorPrice(intnum)
{
	new keystrtmp[512];
	format(keystrtmp,sizeof(keystrtmp),INTERIOR_FILEPATH,intnum);
	keystrtmp = dini_Get(keystrtmp,"Price");
	return keystrtmp;
}

stock ComputeCoordsFromString(str[])
{
	new tmp[3],indexx;
	for(new i=0; i<3; i++) tmp[i] = strval(strtok(str,indexx));
	return tmp;
}

stock ComputeCoordsFromIntsFile(intnum)
{
	new tmp[3],indexx,keystrtmp[512];
	format(keystrtmp,sizeof(keystrtmp),INTERIOR_FILEPATH,intnum);
	keystrtmp = dini_Get(keystrtmp,"Location");
	for(new i=0; i<3; i++) tmp[i] = strval(strtok(keystrtmp,indexx));
	return tmp;
}

stock GetVirtualWorldFromIntsFile(intnum)
{
	new tmp,keystrtmp[512];
	format(keystrtmp,sizeof(keystrtmp),INTERIOR_FILEPATH,intnum);
	tmp = dini_Int(keystrtmp,"Int");
	return tmp;
}

stock PlayerName(playerid)
{
	new tmppln[MAX_PLAYER_NAME];
	GetPlayerName(playerid, tmppln, sizeof(tmppln));
	return tmppln;
}
