#include <a_samp>
#include <mSelection>
#include <dini>
#include <dutils>

#pragma dynamic 15000
#pragma unused ret_memcpy

#define command(%0) if(!strcmp(cmd,%0))
#define NonValid:%0(%1,%2) if(%0 < %1 || %0 > %2)

#define DIALOG_GANG_MAINMENU 845
#define DIALOG_GANG_INVITE 793
#define DIALOG_GANG_CREATE_CONFIRM 794
#define DIALOG_GANG_CREATE_COLOR 795
#define DIALOG_GANG_CREATE_NAME 796
#define DIALOG_GANG_END 797
#define DIALOG_GANG_UNINVITE 864
#define DIALOG_GANG_RSKINS 870
#define DIALOG_GANG_RSKIN 877

#define DIALOG_BUTTON_CONFIRM_TEXT "�������"
#define DIALOG_BUTTON_BACK_TEXT "�����"
#define DIALOG_BUTTON_CLOSE_TEXT "�������"

#define MAX_GANGS 1500
#define GSYS_PFILEPATH "/data/gsys/players/%s.ini"
#define GSYS_PGANGPATH "/data/gsys/gangs/%i.ini"
#define GSYS_SKINPRV_PATH "/data/gsys/skins/%i.skin"
#define GSYS_RANK_MIN 1
#define GSYS_RANK_MAX 6
#define INVALID_GANG_ID -1
#define MONEY_FOR_CREATE_GANG 1500000

new	gsys_skinpreview[300], gskinslist,
GRankName[GSYS_RANK_MAX+1][MAX_STRING] =
{
	"#",
	"�������",
	"����",
	"����",
	"������� ����",
	"����-�����",
	"�����"
};

public OnPlayerText(playerid, text[])
{
    if(GetPVarInt(playerid,"PGangID")!=INVALID_GANG_ID)
	{
	    new msg[1024];
	    format(msg,sizeof(msg),"{%s}[%s]%s(%i): %s",
		GetPlayerGangColor(playerid),GetPlayerGangName(playerid),PlayerName(playerid),playerid,text);
		SendClientMessageToAll(-1,msg);
	}
	return 0;
}

public OnPlayerSpawn(playerid)
{
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
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new tmp[512], cmd[512],idx; cmd = strtok(cmdtext,idx);
	
	command("/f")
	{
	    if(GetPVarInt(playerid,"PGangID")==INVALID_GANG_ID) return 1;

	    tmp=strrest(cmdtext,idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}/f [���������]");
			return 1;
		}
		if(!strfind(tmp,")")) tmp = "{79FDFF}*���������*";
		if(!strfind(tmp,"=)")) tmp = "{79FDFF}*���������*";
		if(!strfind(tmp,":)")) tmp = "{79FDFF}*���������*";
		if(!strfind(tmp,":D")) tmp = "{79FDFF}*������*";
		if(!strfind(tmp,"xD")) tmp = "{79FDFF}*������*";
		if(!strfind(tmp,"=D")) tmp = "{79FDFF}*������*";

		new msg[2048];
	    format(msg,sizeof(msg),"{00FCFF}[��� �����] %s %s(%i): %s",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),playerid,tmp);

	    for(new p=0; p<MAX_PLAYERS; p++)
	    {
	        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
	        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;

	        SendClientMessage(p,-1,msg);
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
	        SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}/givemygang [ID ������]");
	        return 1;
	    }
	    new newglid = strval(tmp);
	    if(newglid==playerid) return 1;
	    if(!IsPlayerConnected(newglid))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� ����� �� � ����");
			return 1;
		}
		if(GetPlayerGangID(newglid)!=INVALID_GANG_ID)
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� ����� ������� � ������ �����");
		    return 1;
		}
		SetPVarInt(newglid,"TempoGGang",1);
		SetPVarInt(newglid,"TempoGGangPID",playerid);

		new msg[1024];
		format(msg,sizeof(msg),"{3494FF}[Pro100Drift] {BAA530}%s {FFFFFF}����� �������� ��� ��������� ��� ����� ������. ������� {BAA530}/acceptgang %i{FFFFFF}, ����� ����� ������� �����",
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
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}/setgcolor [���� � ������� RRGGBB]");
			return 1;
		}

		SetPlayerGangColor(playerid,tmp);
		SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� ������");
		return 1;
	}
	command("/invite")
	{
	    if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
	    if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX-2) return 1;

	    tmp=strtok(cmdtext,idx);
	    if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}/invite [ID ������]");
			return 1;
		}
		new tplayerid = strval(tmp);
		if(tplayerid==playerid) return 1;
		if(!IsPlayerConnected(tplayerid))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� ����� �� � ����");
			return 1;
		}
		if(GetPlayerGangID(tplayerid)!=INVALID_GANG_ID)
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� ����� ��� ������� � �����");
		    return 1;
		}

	    new msg[512],fmsg[512];
		format(msg,sizeof(msg),"{FFFFFF}%s {BAA530}%s {FFFFFF}���������� ��� � ����� {%s}%s{FFFFFF}",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),GetPlayerGangColor(playerid),GetPlayerGangName(playerid));
		format(fmsg,sizeof(fmsg),"{00FCFF}[��� �����] %s %s ��������� %s � �����",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),PlayerName(tplayerid));
		for(new p=0; p<MAX_PLAYERS; p++)
	    {
	        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
	        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;

	        SendClientMessage(p,-1,fmsg);
	    }
		ShowPlayerDialog(tplayerid,DIALOG_GANG_INVITE,DIALOG_STYLE_MSGBOX,"����������� � �����",msg,"��������",DIALOG_BUTTON_CLOSE_TEXT);

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
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}/uninvite [ID ������]");
			return 1;
		}
		new tplayerid = strval(tmp);
		if(tplayerid==playerid) return 1;
		if(!IsPlayerConnected(tplayerid))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� ����� �� � ����");
			return 1;
		}

		SetPlayerGangID(tplayerid,INVALID_GANG_ID);
		SetPlayerGangRank(tplayerid,GSYS_RANK_MIN-1);

	    new msg[512],fmsg[512];
		format(msg,sizeof(msg),"{FFFFFF}%s {BAA530}%s ������ ��� �� ����� \"%s\"",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),GetPlayerGangName(playerid));
		format(fmsg,sizeof(fmsg),"{00FCFF}[��� �����] %s %s ������ %s",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),PlayerName(tplayerid));
		for(new p=0; p<MAX_PLAYERS; p++)
	    {
	        if(GetPVarInt(p,"PGangID")==INVALID_GANG_ID) continue;
	        if(GetPVarInt(p,"PGangID")!=GetPVarInt(playerid,"PGangID")) continue;

	        SendClientMessage(p,-1,fmsg);
	    }
		ShowPlayerDialog(tplayerid,DIALOG_GANG_UNINVITE,DIALOG_STYLE_MSGBOX,"���������� �� �����",msg,DIALOG_BUTTON_CLOSE_TEXT,"");
	    return 1;
	}
	command("/giverank")
	{
	    if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
	    if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return 1;

	    tmp=strtok(cmdtext,idx);
	    if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}/giverank [ID ������] [����]");
			return 1;
		}
		new tplayerid = strval(tmp);
		if(tplayerid==playerid) return 1;
		if(!IsPlayerConnected(tplayerid))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� ����� �� � ����");
			return 1;
		}
		if(GetPlayerGangID(tplayerid)!=GetPlayerGangID(playerid))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� ����� �� � ����� �����");
		    return 1;
		}

		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}/giverank [ID ������] [����]");
			return 1;
		}

		new rank = strval(tmp);
		NonValid:rank(GSYS_RANK_MIN,GSYS_RANK_MAX-1)
		{
		    SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}�� �������� ��� ����� �����");
			return 1;
		}

		SetPlayerGangRank(tplayerid,rank);
		new cmdmsg[512];
		format(cmdmsg,sizeof(cmdmsg),"{3494FF}[Pro100Drift] {FFFFFF}�� ������ ������ {BAA530}%s {FFFFFF}���� {BAA530}%i",PlayerName(tplayerid),rank);
		SendClientMessage(playerid,-1,cmdmsg);
		format(cmdmsg,sizeof(cmdmsg),"{3494FF}[Pro100Drift] {FFFFFF}%s {BAA530}%s {FFFFFF}����� ��� ���� {BAA530}%i",
		GRankName[GetPlayerGangRank(playerid)],PlayerName(playerid),rank);
		SendClientMessage(tplayerid,-1,cmdmsg);
		format(cmdmsg,sizeof(cmdmsg),"{00FCFF}[��� �����] %s %s ����� %i ���� %s",
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
	        SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift RCON] {FFFFFF}/ganglic [ID ������]");
	        return 1;
	    }
	    new gpl = strval(tmp);
	    if(!IsPlayerConnected(gpl))
		{
			SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� ����� �� � ����");
			return 1;
		}

	    new ptmp[512];
	    switch(GetPVarInt(gpl,"LicenseForMakeGang"))
	    {
	    case 0:
			{
			    format(ptmp,sizeof(ptmp),"{3494FF}[Pro100Drift] {FFFFFF}������������� {BAA530}%s {FFFFFF}����� ��� ���������� �� �������� �����",PlayerName(playerid));
				SetPVarInt(gpl,"LicenseForMakeGang",1);
				SendClientMessage(gpl,-1,ptmp);
				format(ptmp,sizeof(ptmp),"{3494FF}[Pro100Drift] {FFFFFF}�� ������ {BAA530}%s {FFFFFF}���������� �� �������� �����",PlayerName(gpl));
				SendClientMessage(playerid,-1,ptmp);
			}
		case 1:
		    {
		        format(ptmp,sizeof(ptmp),"{3494FF}[Pro100Drift] {FFFFFF}������������� {BAA530}%s {FFFFFF}����� � ��� ���������� �� �������� �����",PlayerName(playerid));
				SetPVarInt(gpl,"LicenseForMakeGang",0);
				SendClientMessage(gpl,-1,ptmp);
				format(ptmp,sizeof(ptmp),"{3494FF}[Pro100Drift] {FFFFFF}�� ������ � {BAA530}%s {FFFFFF}���������� �� �������� �����",PlayerName(gpl));
				SendClientMessage(playerid,-1,ptmp);
		    }
		default: return 1;
	    }

	    return 1;
	}

	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid==DIALOG_GANG_END || dialogid==DIALOG_GANG_UNINVITE) return 1;
	if(dialogid==DIALOG_GANG_RSKINS)
	{
	    if(!response) return 1;

	    new msg[512],skinid;
	    skinid = GetPlayerGangRankSkin(playerid,listitem+1);
	    if(skinid==0) format(msg,sizeof(msg),"���");
	    else format(msg,sizeof(msg),"%i",skinid);
	    if(strfind(msg,"���")==-1)
	    {
		    format(msg,sizeof(msg),"{FFFFFF}ID �����: {FFA200}%s {C6C6C6}(��������, ����� �����������)\n{96FF00}��������\n{96FF00}�������",msg);
		}
		else
		{
		    format(msg,sizeof(msg),"{FFFFFF}ID �����: {FFA200}%s\n{96FF00}��������\n{020202}�������",msg);
		}
	    ShowPlayerDialog(playerid,DIALOG_GANG_RSKIN,DIALOG_STYLE_LIST,"���� �����",msg,DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_BACK_TEXT);
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
				format(msg,sizeof(msg),"%s{FFFFFF}%i ����: ���� %i {C6C6C6}[�����������/��������]\n",msg,s,grskin[s-1]);
			}
	        ShowPlayerDialog(playerid,DIALOG_GANG_RSKINS,DIALOG_STYLE_LIST,"����� �����",msg,
	        DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_CLOSE_TEXT);

	        return 1;
	    }

	    switch(listitem)
	    {
	    case 0:
			{
			    SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}������� {FF0000}X{FFFFFF}, ����� ������� ���� ���������");
			    ShowSkinPreviewForPlayer(playerid,GetPVarInt(playerid,"TempoGRSkin"));
			}
		case 1:
		    {
			    SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}������� �� ����, ����� ��������� ���");
				SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}������� {FF0000}X{FFFFFF}, ����� ����� ��� ���������� �����");
			    ShowModelSelectionMenu(playerid, gskinslist, "Ck���", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
			}
		case 2:
			{
			    SetPlayerGangRankSkin(playerid,GetPVarInt(playerid,"TempoGRank"),0);
			    if(!GetPlayerGangRankSkin(playerid,GetPVarInt(playerid,"TempoGRank"))) SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}���� �����");
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
	            ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_CONFIRM,DIALOG_STYLE_MSGBOX,"�������� �����",
				"{FFFFFF}��� �������� ����� ��� �����\n{BAA530}���������� �� ������������� {FFFFFF}� {BAA530}1 500 000 $\n\n{FFFFFF}���� �� ��� � ��� ����, �� ������� {BAA530}\"�����\" ",
				"�����","");
	        }
		case 1:
		    {
		        if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
				if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX-2) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}��� ���� ������������ �����, ����� ���������� ������� � �����");

				SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}��� ����������� ������� � ����� ����������� ������� {BAA530}/invite");
				return 1;
		    }
		case 2:
		    {
		        if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
				if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX-1) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}��� ���� ������������ �����, ����� ��������� ������ �����");

				SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}��� ���������� ������ ����� ����������� ������� {BAA530}/uninvite");
				return 1;
		    }
		case 3:
		    {
		        if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		        if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}��� ���� ������������ �����, ����� ��������/�������� ���� ������ �����");

		        SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}��� ���������/��������� ����� ������ ����� ����������� ������� {BAA530}/giverank");
				return 1;
		    }
		case 4:
		    {
		    	if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		        if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}��� ���� ������������ �����, ����� ������ ����� ������ �����");

		        new msg[512],grskin[GSYS_RANK_MAX];
		        for(new s=1; s<GSYS_RANK_MAX+1; s++)
		        {
		            grskin[s-1] = GetPlayerGangRankSkin(playerid,s);
					format(msg,sizeof(msg),"%s{FFFFFF}%i ����: ���� %i {C6C6C6}[�����������/��������]\n",msg,s,grskin[s-1]);
		        }

		        ShowPlayerDialog(playerid,DIALOG_GANG_RSKINS,DIALOG_STYLE_LIST,"����� �����",msg,
		        DIALOG_BUTTON_CONFIRM_TEXT,DIALOG_BUTTON_CLOSE_TEXT);
		        return 1;
		    }
		case 5:
		    {
		        if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		        if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}��� ���� ������������ �����, ����� �������� ����� ������ ������ �����");

				SetPlayerGangSpawn(playerid);
				SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}����� ������ ������� ��������");

				new msg[512];
			    format(msg,sizeof(msg),"{00FCFF}[��� �����] %s %s ������� ����� ������ ������ �����",
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
		        if(GetPlayerGangRank(playerid)<GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}�� �� ����� �����");

		        SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}��� �������� ��������� �������������� �������� {BAA530}/givemygang");

		        return 1;
		    }
		case 7:
		    {
		    	if(GetPlayerGangID(playerid)==INVALID_GANG_ID) return 1;
		    	if(GetPlayerGangRank(playerid)==GSYS_RANK_MAX) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}�� ����� ����� � �� ������ ������ ��� ���� �� ��. ��������� ��������� ������� ������");

		    	SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}�� ���� �� �����");
		    	SetPlayerGangID(playerid,INVALID_GANG_ID);

		        return 1;
		    }
		default: return 1;
	    }

		return 1;
	}
	if(dialogid==DIALOG_GANG_CREATE_CONFIRM && response)
	{
	    if(GetPlayerGangID(playerid)!=INVALID_GANG_ID) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}�� ��� �������� � �����");
	    if(!GetPVarInt(playerid,"LicenseForMakeGang")) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}� ��� ��� ���������� �� �������� ����� �� �������������");
	    if(GetPlayerMoney(playerid)<MONEY_FOR_CREATE_GANG) return SendClientMessage(playerid,-1,"{3494FF}[Pro100Drift] {FFFFFF}� ��� ��� ����� �� �������� ����� (����� {BAA530}1 500 000 ${FFFFFF})");
		ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_COLOR,DIALOG_STYLE_INPUT,
		"�������� �����: ����","{FFFFFF}������� ���� ����� � ������� {BAA530}RRGGBB{FFFFFF}:\n{C6C6C6}��������: FF0000","����",DIALOG_BUTTON_CLOSE_TEXT);

		return 1;
	}
	if(dialogid==DIALOG_GANG_CREATE_COLOR && response)
	{
	    if(	strlen(inputtext)!=strlen("FFF000") || strfind(inputtext,"}")>=0 ||
	        strfind(inputtext,"{")>=0 ) return ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_COLOR,DIALOG_STYLE_INPUT,
		"{FF0000}������� ����� ����!\n\n�������� �����: ����","{FFFFFF}������� ���� ����� � ������� {BAA530}RRGGBB{FFFFFF}:\n{C6C6C6}��������: FF0000","����",DIALOG_BUTTON_CLOSE_TEXT);

		SetPVarString(playerid,"TempoGColor",inputtext);

		ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_NAME,DIALOG_STYLE_INPUT,"�������� �����: ��������","{FFFFFF}������� �������� �����:\n{C6C6C6}��������: ������� �������","����","");

	    return 1;
	}
	if(dialogid==DIALOG_GANG_CREATE_NAME)
	{
	    if(!response) return ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_NAME,DIALOG_STYLE_INPUT,"�������� �����: ��������","{FFFFFF}������� �������� �����:\n{C6C6C6}��������: ������� �������","����","");

	    if( !strlen(inputtext) ) return ShowPlayerDialog(playerid,DIALOG_GANG_CREATE_NAME,DIALOG_STYLE_INPUT,"�������� �����: ��������","{FF0000}�������� ��������!\n\n{FFFFFF}������� �������� �����:\n{C6C6C6}��������: ������� �������","����","");

	    new color[128];
	    GetPVarString(playerid,"TempoGColor",color,sizeof(color));
	    new gid = CreateGang(color,inputtext);
	    SetPVarInt(playerid,"PGangID",gid);
	    SetPlayerGangID(playerid,gid);
	    SetPlayerGangRank(playerid,GSYS_RANK_MAX);
	    new msg[512];
	    format(msg,sizeof(msg),"{FFFFFF}����� �������.\n\n���������, � ����� �������� � ID: {BAA530}%i{FFFFFF}.\n��, � ����������, ����� ����������� ���",GetPlayerGangID(playerid));
	    ShowPlayerDialog(playerid,DIALOG_GANG_END,DIALOG_STYLE_MSGBOX,"����� �������",msg,DIALOG_BUTTON_CLOSE_TEXT,"");
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
	    format(tmpmsg,sizeof(tmpmsg),"{3494FF}[Pro100Drift] {FFFFFF}�� �������� � ����� {BAA530}%s",GetPlayerGangName(playerid));
	    new fmsg[512];
	    format(fmsg,sizeof(fmsg),"{00FCFF}[��� �����] %s %s ������� � �����",
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
	return 1;
}

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
    ShowModelSelectionMenu(playerid, gsys_skinpreview[skinid], "~b~Ck��", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
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
