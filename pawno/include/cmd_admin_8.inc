// ����� ����

if(iscmd(cmd,"/chnick")){ restricted(8);
 getStr("�������������: /chnick [���]");
 SetPlayerName(playerid,tmp);
 return 1;
}

// ����������/������ ����� �������

if(iscmd(cmd,"/tt")){ restricted(8);
 getInt("�������������: /tt [������� ������] {�����}");
 if(pint<0 || pint>max_weapons-1){
  Message(playerid,"������������ ��������",clDarkRed);
  return 1;
 }
 tmp = strtok(cmdtext,idx);
 if(!strlen(tmp)){
  format(msg,max_line,"B���� ������� ��� ������ %i: %s",pint,tformat(TT[pint]));
  Message(playerid,msg,clYellow);
  return 1;
 }
 new time = strval(tmp);
 if(time<0 || time>3600){
  Message(playerid,"������������ ��������",clDarkRed);
  return 1;
 }
 TT[pint] = time;
 SaveTT();
 return 1;
}

// ���� ����������������� ����������

if(iscmd(cmd,"/mkadmin")){ restricted(8);
 getTgt("�������������: /mkadmin [�����] [�������]");
 getInt("�������������: /mkadmin [�����] [�������]");
 PlayerAdmin[tgt] = pint;
 return 1;
}

if(iscmd(cmd,"/fcrash")){ restricted(8);
 getInt("�������������: /fcrash [propid]");
 Crash(pint);
 return 1;
}

if(iscmd(cmd,"/fpay")){ restricted(8);
 getInt("�������������: /fpay [propid]");
 BizPay(pint);
 return 1;
}

if(iscmd(cmd,"/fwu")){ restricted(8);
 WTIMER = 0;
 UpdateWeather();
 return 1;
}

if(iscmd(cmd,"/sellallproperty")){ restricted(3);
 for(new i=1; i<max_property; i++) if(strlen(pOwner[i])){
  pOwner[i] = "no-one";
  pPrice[i] = GetPropPrice(pLevel[i]);
  SaveProp(i);
 }
 Message(playerid,"�� ��������� �� ������� ��� ������������� �� �������",clYellow);
 return 1;
}