// ��������� ��������� � ����� ���

if(iscmd(cmd,"/mole")){ restricted(2);
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 if(!strlen(tmp)){
  Message(playerid,"�������������: /mole [�����]");
  return 1;
 }
 if(PlayerAdmin[playerid]<6) format(msg,max_line,"*** ���������: %s",tmp);
 else format(msg,max_line,"*** A����: %s",tmp);
 AMessage(msg,clLightBlue);
 return 1;
}

// ��������� ��������� ����������� ������

if(iscmd(cmd,"/molemsg")){ restricted(1);
 getTgt("�������������: /msg [�����] [�����]");
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 if(!strlen(tmp)){
  Message(playerid,"�������������: /molemsg [�����] [�����]");
  return 1;
 }
 format(msg,max_line,"*** ��������� �������������: %s",tmp);
 Message(playerid,msg,clLightBlue);
 return 1;
}

// �����������, ��� � ����� ������ � IP-������ ������ ����� ���� ������

if(iscmd(cmd,"/checkip")){ restricted(2);
 getTgt("�������������: /checkip [�����]");
 CheckIP(tgt,playerid);
 return 1;
}

// ����������������� � ���������� ������

if(iscmd(cmd,"/goto")){ restricted(1);
 getTgt("�������������: /goto [�����]");
 GetPlayerFacingPoint(tgt,x,y,z,-2.0);
 SetPlayerInterior(playerid,GetPlayerInterior(tgt));
 SetPlayerVW(playerid,GetPlayerVirtualWorld(tgt));
 TeleportPlayer(playerid,x,y,z);
 GetPlayerFacingAngle(tgt,x);
 SetPlayerFacingAngle(playerid,x);
 return 1;
}


