#include <a_samp>
#include <streamer>

new SpdObj[MAX_PLAYERS][2];
new bool:UpdateSpeed[MAX_PLAYERS] = {false,...};

public OnPlayerConnect(playerid)
{
	UpdateSpeed[playerid] = false;
	SpdObj[playerid][0] = INVALID_OBJECT_ID;
	SpdObj[playerid][1] = INVALID_OBJECT_ID;
	return 0;
}

public OnPlayerDisconnect(playerid,reason)
{
	#pragma unused reason
	if(SpdObj[playerid][0] != INVALID_OBJECT_ID)
	{
		DestroyDynamicObject(SpdObj[playerid][0]);
		DestroyDynamicObject(SpdObj[playerid][1]);
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
	if(UpdateSpeed[playerid])
	{
		new Float:p[3];
		GetVehicleVelocity(GetPlayerVehicleID(playerid),p[0],p[1],p[2]);
		new str[12];
		format(str,12,"%.0f KM/H",150.0*(p[0]*p[0]+p[1]*p[1]));
		SetDynamicObjectMaterialText(SpdObj[playerid][0],0,str,OBJECT_MATERIAL_SIZE_512x256,"Arial",64,true,0xFFFFFFFF,0,OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	}
	return 1;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
	{
		SpdObj[playerid][0] = CreateDynamicObject(19482,0.0,0.0,0.0,0.0,0.0,0.0,-1,-1,playerid,200.0);
		SpdObj[playerid][1] = CreateDynamicObject(19482,0.0,0.0,0.0,0.0,0.0,0.0,-1,-1,playerid,200.0);
		new Float:x,Float:y,Float:z;
		GetVehicleModelInfo(GetVehicleModel(GetPlayerVehicleID(playerid)),VEHICLE_MODEL_INFO_SIZE,x,y,z);
		AttachDynamicObjectToVehicle(SpdObj[playerid][0],GetPlayerVehicleID(playerid),-x-0.5,0.0,z/2-0.3,0.0,0.0,270.0);
		SetDynamicObjectMaterialText(SpdObj[playerid][1],0,"_________",OBJECT_MATERIAL_SIZE_512x256,"Arial",64,true,0xFF4EFD71,0,OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
		AttachDynamicObjectToVehicle(SpdObj[playerid][1],GetPlayerVehicleID(playerid),-x-0.5,0.0,z/2-0.3,0.0,0.0,270.0);
		Streamer_Update(playerid);
		UpdateSpeed[playerid] = true;
		return 1;
	}
	if(oldstate == PLAYER_STATE_DRIVER)
	{
		UpdateSpeed[playerid] = false;
		DestroyDynamicObject(SpdObj[playerid][0]);
		DestroyDynamicObject(SpdObj[playerid][1]);
		SpdObj[playerid][0] = INVALID_OBJECT_ID;
		SpdObj[playerid][1] = INVALID_OBJECT_ID;
		return 1;
	}
	return 0;
}
