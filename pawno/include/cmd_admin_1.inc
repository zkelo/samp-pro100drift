///////////////////
// SA Mafia Wars //
///////////////////

// �����-���

if(iscmd(cmd,"/a")){ restricted(1);
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 if(!strlen(tmp)){
  Message(playerid,"�������������: /a [�����]");
  return 1;
 }
 format(msg,max_line,"* %i ����� %s: %s",PlayerAdmin[playerid],name,tmp);
 for(new i=0; i<max_players; i++) if(PlayerAdmin[i]) Message(i,msg,clYellow);
 return 1;
}

// ����������� ���������� ������

if(iscmd(cmd,"/check")){ restricted(1);
 getTgt("�������������: /check [�����]");
 ShowStats(tgt,playerid);
 return 1;
}

// �������� ������

if(iscmd(cmd,"/ban")){ restricted(1);
 getTgt("�������������: /ban [�����] [�������]");
 if(PlayerAdmin[playerid]<PlayerAdmin[tgt]){
  Message(playerid,"�� �� ������ �������� ������������ ��������������",clDarkRed);
  return 1;
 }
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 BanFW(tgt,tmp,pint);
 return 1;
}

// �������� �������������� ���������� ������

if(iscmd(cmd,"/warn")){ restricted(1);
 getTgt("�������������: /warn [�����] {�������}");
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 if(!strlen(tmp)){
  Message(playerid,"�������������: /warn [�����] {�������}");
  return 1;
 }
 if(PlayerAdmin[tgt]>=PlayerAdmin[playerid]){
  Message(playerid,"�� �� ������ �������� �������������� ��������������");
  return 1;
 }
 PlayerWarns[tgt]++;
 format(msg,max_line,"%s, �� �������� �������������� �� �������������: \"%s\"",GetName(tgt),tmp);
 Message(tgt,msg,clLightRed);
 if(PlayerWarns[tgt]>2){
  PlayerWarns[tgt] = 0;
  BanFW(tgt,tmp,0);
 } else {
  format(msg,max_line,"H���������, 3 �������������� ������ �� ����� �������������� ��� (�� ������ %i)",PlayerWarns[tgt]);
  Message(tgt,msg,clLightRed);
 }
 format(msg,max_line,"B� ������� �������� �������������� ������ %s (\"%s\")",GetName(tgt),tmp);
 Message(playerid,msg,clYellow);
 return 1;
}

// ������� ���������� ������ � �������

if(iscmd(cmd,"/kick")){ restricted(1);
 getTgt("�������������: /kick [�����] {�������}");
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 KickEx(tgt,tmp,1);
 return 1;
}

// ��������/������� ��� ���������� ������

if(iscmd(cmd,"/mute")){ restricted(1);
 getTgt("�������������: /mute [�����]");
 if(playerid==tgt && PlayerAdmin[playerid]<6) {
  Message(playerid,"��� ������� ������ ������������ �� ����� ����",clDarkRed);
  return 1;
 }
 if(PlayerAdmin[tgt]>=PlayerAdmin[playerid]){
  Message(playerid,"�� �� ������ �������� ��� ��������������");
  return 1;
 }
 if(PlayerMuted[tgt]) {
  format(msg,max_line,"%s ������ ��� %s",name,GetName(tgt));
  PlayerMuted[tgt] = 0;
 } else {
  format(msg,max_line,"%s ������� ��� %s",name,GetName(tgt));
  PlayerMuted[tgt] = 2;
 }
 AdminMessage(msg,clDarkRed);
 return 1;
}

// �������� ������ �� ��������� ����

if(iscmd(cmd,"/banfw")){ restricted(1);
 getTgt("�������������: /ban [�����] [����] [�������]");
 if(PlayerAdmin[playerid]<PlayerAdmin[tgt]){
  Message(playerid,"�� �� ������ �������� ������������ ��������������",clDarkRed);
  return 1;
 }
 getStr("�������������: /ban [�����] [����] [�������]"); scopy(cmd,tmp);
 strmid(tmp,cmdtext,idx,strlen(cmdtext));
 BanFW(tgt,tmp,ptime(cmd),GetName(playerid));
 return 1;
}
