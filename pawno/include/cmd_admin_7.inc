// ���������� � �������

if(iscmd(cmd,"/ginfo")){ restricted(7);
 new id = GetNearestGates(playerid,12.0,1);
 if(id<0){
  Message(playerid,"���������� ��� ������� �����",clDarkRed);
  return 1;
 }
 format(msg,max_line,"ID: %i, F: %i",id,gFaction[id]);
 Message(playerid,msg,clYellow);
 return 1;
}

// �������� �����

if(iscmd(cmd,"/gc")){ restricted(7);
 getInt("�������������: /gc [id]");
 gCreate(pint,playerid);
 return 1;
}

// �������� �����

if(iscmd(cmd,"/gcd")){ restricted(7);
 getInt("�������������: /gcd [id]");
 gDestroy(pint,playerid);
 return 1;
}


// ���������� ������� ��� �����

if(iscmd(cmd,"/gcf")){ restricted(7);
 getInt("�������������: /gc [id] [�������]");
 new id = pint;
 getInt("�������������: /gc [id] [�������]");
 gFaction[id] = pint;
 Message(playerid,"���������� ���������");
 gSave();
 return 1;
}

// ��������� ������� �������� �����

if(iscmd(cmd,"/gsc")){ restricted(7);
 getInt("�������������: /gsc [id]");
 GetObjectPos(gID[pint],gClosedPos[pint][0],gClosedPos[pint][1],gClosedPos[pint][2]);
 GetObjectRot(gID[pint],gClosedPos[pint][3],gClosedPos[pint][4],gClosedPos[pint][5]);
 Message(playerid,"������� �������� ����� ���������");
 gSave();
 return 1;
}

// ��������� ������� �������� �����

if(iscmd(cmd,"/gso")){ restricted(7);
 getInt("�������������: /gso [id]");
 GetObjectPos(gID[pint],gOpenPos[pint][0],gOpenPos[pint][1],gOpenPos[pint][2]);
 Message(playerid,"������� �������� ����� ���������");
 gSave();
 return 1;
}

// ����������� ������

if(iscmd(cmd,"/gm")){ restricted(7);
 getInt("�������������: /gm [id] {x} {y} {z}");
 x = floatstr(strtok(cmdtext,idx));
 y = floatstr(strtok(cmdtext,idx));
 z = floatstr(strtok(cmdtext,idx));
 gMove(pint,x,y,z);
 return 1;
}

// ��������� ������

if(iscmd(cmd,"/gr")){ restricted(7);
 getInt("�������������: /gr [id] {x} {y} {z}");
 x = floatstr(strtok(cmdtext,idx));
 y = floatstr(strtok(cmdtext,idx));
 z = floatstr(strtok(cmdtext,idx));
 gRotate(pint,x,y,z);
 return 1;
}

// ������� ��������

if(iscmd(cmd,"/tpc")){ restricted(7);
 tpCreate(playerid);
 return 1;
}

// ��������� �������� �� �������

if(iscmd(cmd,"/tpf")){ restricted(7);
 getInt("�������������: /tpf [id] [�������]");
 new id = pint;
 getInt("�������������: /tpf [id] [�������]");
 tpFaction[id] = pint;
 Message(playerid,"������� ��������");
 return 1;
}

// ��������� �������� � ������������

if(iscmd(cmd,"/tpz")){ restricted(7);
 getInt("�������������: /tpz [id] [������]");
 new id = pint;
 getInt("�������������: /tpz [id] [������]");
 tpBiz[id] = pint;
 Message(playerid,"������ �������");
 return 1;
}

// ������ �������� ����������

if(iscmd(cmd,"/tplist")){ restricted(7);
 Message(playerid,"Active TPs:",clYellow);
 for(new i=0; i<max_tps; i++) if(tpSPos[i][0]!=0.0) {
  format(msg,max_line,"TP #%i: from (%.2f,%.2f,%.2f) to (%.2f,%.2f,%.2f,%.2f in %i), f: %i, biz: %i, puid: %i",i,tpSPos[i][0],tpSPos[i][1],tpSPos[i][2],
   tpDPos[i][0],tpDPos[i][1],tpDPos[i][2],tpDPos[i][3],tpDIntr[i],tpFaction[i],tpBiz[i],tpID[i]);
  Message(playerid,msg);
 }
 return 1;
}

// ����������������� � �������� ������� ���������� ���������

if(iscmd(cmd,"/tpgoto")){ restricted(7);
 getInt("�������������: /tpgoto [id]");
 SetPlayerPosEx(playerid,tpSPos[pint][0],tpSPos[pint][1],tpSPos[pint][2]);
 return 1;
}

// ������ �������� ������� ���������� ���������

if(iscmd(cmd,"/tps")){ restricted(7);
 getInt("�������������: /tps [id]");
 tpSetSPos(pint,playerid);
 return 1;
}

// ������ �������� ������� ���������� ���������

if(iscmd(cmd,"/tpd")){ restricted(7);
 getInt("�������������: /tpd [id]");
 tpSetDPos(pint,playerid);
 return 1;
}

if(iscmd(cmd,"/restart")){ restricted(3);
 getInt("������������: /restart [������]");
 if(pint>120) {
  Message(playerid,"������ �������� ������ ���������� ������, ��� �� 2 ������",clDarkRed);
  return 1;
 }
 if(!pint && gmxTD){
  TextDrawDestroy(gmxTD);
 }
 gmxTD = TextDrawCreate(320.0,100.0," ");
 TextDrawFont(gmxTD,3);
 TextDrawAlignment(gmxTD,2);
 TextDrawLetterSize(gmxTD,0.9,1.2);
 TextDrawSetOutline(gmxTD,1);
 TextDrawShowForAll(gmxTD);
 gmxTimer = pint;
 return 1;
}

