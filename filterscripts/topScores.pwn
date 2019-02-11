// Собсно, дефайны, инклуды и т.д. и т.п.
#include <a_samp>
#include <dini>
#include <dutils>
#define arcmd(%0)				if(!strcmp(cmd,%0))
#define arcmd_init				new cmd[512],idx; cmd=strtok(cmdtext,idx)
#define arcmd_lcmd              strlen(cmd)
#define arcmd_scmp(%0)          !strcmp(cmd,%0,true)
#define ShowScoreDialog(%0)		new dlgmsg[1024]; format(dlgmsg,sizeof(dlgmsg),"{FFF000}Топ 10 игроков:{FFFFFF}\n%s",%0);\
								ShowPlayerDialog(playerid,99999,DIALOG_STYLE_MSGBOX,"Топ 10",dlgmsg,"Закрыть","")
#pragma unused					ret_memcpy

// Собсно, скрипт
public OnFilterScriptInit()
{
	print("--------------------------------------");
	print(" This FS was maked by Sanya161RU (aka Sanya_Rostov)");
	print(" Please, don't erase my rights :)");
	print("--------------------------------------");
	print(" Script was loaded successfly!");
	print("--------------------------------------");
	return 1;
}

public OnFilterScriptExit()
{
	print("--------------------------------------");
	print(" This FS was maked by Sanya161RU (aka Sanya_Rostov)");
	print(" Please, don't erase my rights :)");
	print("--------------------------------------");
	print(" Script was unloaded successfly!");
	print("--------------------------------------");
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	arcmd_init;
	arcmd("/top")
	{
	    if(!arcmd_lcmd)
			{ SendClientMessage(playerid,-1,"Используйте: {C6C6C6}({F5F5F5}/top money {C6C6C6} - топ 10 по деньгам | {F5F5F5}/top score {C6C6C6} - топ 10 по очкам)"); return 1; }

		if(arcmd_scmp("money"))
		{
		
		    return 1;
		}

		return 1;
	}
	
	return 1;
}

stock GetFormattedTopList(type,&var)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}
