// ������� �����������

if(iscmd(cmd,"/transfercars")){ restricted(6);
 getStr("�������������: /transfercars [������ �������] [����� �������]");
 new old[max_line], count = 0, prop = 0; scopy(old,tmp);
 getStr("�������������: /transfercars [������ �������] [����� �������]");
 for(new i=1; i<max_vehicles; i++) if(!strcmp(Owner[i],tmp)) {
  scopy(Owner[i],tmp);
  count++;
 }
 format(msg,max_line,"B���� ����������: %i",count);
 Message(playerid,msg,clYellow);
 return 1;
}

// ������� ������������

if(iscmd(cmd,"/transferproperty")){ restricted(6);
 getStr("�������������: /transferproperty [������ �������] [����� �������]");
 new old[max_line], count = 0, prop = 0; scopy(old,tmp);
 getStr("�������������: /transferproperty [������ �������] [����� �������]");
 for(new i=1; i<max_property; i++) if(!strcmp(pOwner[i],tmp)) {
  scopy(pOwner[i],tmp);
  count++;
 }
 format(msg,max_line,"B���� ����������: %i",count);
 Message(playerid,msg,clYellow);
 return 1;
}

// �������� ��������

if(iscmd(cmd,"/createaccount")){ restricted(6);
 getStr("�������������: /createaccount [���]");
 format(msg,max_line,"/var/acf/%s.ini",tmp);
 if(!fexist(msg)){
  Message(playerid,"����� ������� ��� ����������",clDarkRed);
  return 1;
 }
 fclose(fopen(msg,io_write));
 return 1;
}

// �������������� �����

if(iscmd(cmd,"/transferstats")){ restricted(6);
 getStr("�������������: /transferstats [������ �������] [����� �������]");
 new old[max_line]; format(old,max_line,"/var/acf/%s.ini",tmp);
 if(!fexist(old)){
  format(msg,max_line,"A������� %s �� ����������",tmp);
  Message(playerid,msg,clDarkRed);
  return 1;
 }
 if(IsPlayerConnected(FindPlayer(tmp))){
  format(msg,max_line,"���������� �������� ������ � �����, ����� ������",tmp);
  Message(playerid,msg,clDarkRed);
 }
 getStr("�������������: /transferstats [������ �������] [����� �������]");
 new newa[max_line]; format(newa,max_line,"/var/acf/%s.ini",tmp);
 if(!strcmp(newa,old)){
  Message(playerid,"������ � ����� �������� ���������",clDarkRed);
  return 1;
 }
 if(!fexist(newa)){
  format(msg,max_line,"A������� %s �� ����������",tmp);
  Message(playerid,msg,clDarkRed);
  return 1;
 }
 fcopy(old,newa);
 if(fexist(newa)) fremove(old); else {
  Message(playerid,"�� ������� ����������� �������, ��������� � ������� ���������������",clDarkRed);
  return 1;
 }
 return 1;
}

// ��������� ������ ������� ��������� �������

if(iscmd(cmd,"/mkld")){ restricted(6);
 getTgt("�������������: /mkld [�����] [�������]");
 checkplayer(tgt);
 getInt("�������������: /mkld [�����] [�������]");
 PlayerLeader[tgt] = pint;
 PlayerRank[tgt] = 6;
 format(msg,max_line,"B� ��������� ������� ������� %i (%s)",pint,fRu_Name[pint]);
 Message(tgt,msg,clYellow);
 if(tgt != playerid){
  format(msg,max_line,"%s �������� ������� ������� %i (%s)",GetName(tgt),pint,fRu_Name[pint]);
  Message(playerid,msg,clYellow);
 }
 PlayerColor[playerid] = fColor[pint];
 ApplyStats(tgt);
 SavePlayer(tgt);
 return 1;
}

// ������� ������ ������ ��������� �������

if(iscmd(cmd,"/mkmb")){ restricted(6);
 getTgt("�������������: /mkmb [�����] [�������]");
 checkplayer(tgt);
 getInt("�������������: /mkmb [�����] [�������]");
 PlayerMember[tgt] = pint;
 PlayerRank[tgt] = 1;
 format(msg,max_line,"B�� ������� ������ ������� %i (%s)",pint,fRu_Name[pint]);
 Message(tgt,msg,clYellow);
 if(tgt != playerid){
  format(msg,max_line,"%s ������ ������ ������� %i (%s)",GetName(tgt),pint,fRu_Name[pint]);
  Message(playerid,msg,clYellow);
 }
 PlayerColor[playerid] = fColor[pint];
 ApplyStats(tgt);
 SavePlayer(tgt);
 return 1;
}

// ���� �������� � ����� ����������� �������

if(iscmd(cmd,"/dm_heal")){ restricted(4);
 new Float: hp, Float: armor;
 hp = floatstr(strtok(cmdtext,idx)); if(hp<1.0) hp = 100.0;
 armor = floatstr(strtok(cmdtext,idx));
 for(new i=0; i<max_players; i++) if(IsPlayerConnected(i))
  if(GetDistancePP(playerid,i)<distance_shout){
   SetPlayerHealthEx(i,hp);
   SetPlayerArmor(i,armor);
  }
 return 1;
}

// ������� ������ ����������� �������
 
if(iscmd(cmd,"/dm_guns")){ restricted(4);
 new w,a;
 w = strval(strtok(cmdtext,idx)); if(!w) w = 24;
 a = strval(strtok(cmdtext,idx)); if(!a) a = 247;
 for(new i=0; i<max_players; i++) if(IsPlayerConnected(i))
  if(GetDistancePP(playerid,i)<distance_shout){
   GivePlayerWeaponEx(i,w,a);
  }
 return 1;
}



if(iscmd(cmd,"/hp")){ restricted(3);
 new Float: hp;
 getTgt("�������������: /hp [�����] {hp}");
 tmp = strtok(cmdtext,idx);
 if(!strlen(tmp)){
  GetPlayerHealth(tgt,hp);
  format(msg,max_line,"%s: %.0fhp",GetName(tgt),hp);
  Message(playerid,msg,clYellow);
  return 1;
 }
 pint = strval(tmp);
 SetPlayerHealthEx(tgt,pint);
 SavePlayer(tgt);
 return 1;
}

// ������/������ ����� ���������� ������

if(iscmd(cmd,"/armor")){ restricted(3);
 new Float: hp;
 getTgt("�������������: /armor [�����] {hp}");
 tmp = strtok(cmdtext,idx);
 if(!strlen(tmp)){
  GetPlayerArmour(tgt,hp);
  format(msg,max_line,"%s's armor: %.0f",GetName(tgt),hp);
  Message(playerid,msg,clYellow);
  return 1;
 }
 pint = strval(tmp);
 SetPlayerArmor(tgt,pint);
 SavePlayer(tgt);
 return 1;
}



