// ������ ��������

if(iscmd(cmd,"/intr")){ restricted(3);
 tmp = strtok(cmdtext,idx);
 if(!strlen(tmp)){
  format(msg,max_line,"B�� ��������: %i",GetPlayerInterior(playerid));
  Message(playerid,msg,clYellow);
  return 1;
 }
 pint = strval(tmp);
 SetPlayerInterior(playerid,pint);
 if(IsPlayerInAnyVehicle(playerid))
  SetVehicleInterior(GetPlayerVehicleID(playerid),pint);
 return 1;
}

// ���� ���

if(iscmd(cmd,"/vw")){ restricted(3);
 tmp = strtok(cmdtext,idx);
 if(!strlen(tmp)){
  format(msg,max_line,"B�� ����������� ���: %i",GetPlayerVirtualWorld(playerid));
  Message(playerid,msg,clYellow);
  return 1;
 }
 pint = strval(tmp);
 SetPlayerVW(playerid,pint);
 if(IsPlayerInAnyVehicle(playerid))
  SetVehicleVirtualWorld(GetPlayerVehicleID(playerid),pint);
 return 1;
}

// ID �������������

if(iscmd(cmd,"/pinfo")){ restricted(3);
 for(new i=1; i<max_property; i++)
  if(PlayerToPoint(distance_close,playerid,pCPos[i][PosX],pCPos[i][PosY],pCPos[i][PosZ])){
   format(msg,max_line,"Property ID: %i, TYPE: %i",i,pType[i]);
   Message(playerid,msg);
   return 1;
  }
 return 1;
}
