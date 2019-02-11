stock ShowColorMenu(playerid,toggle)
	return CallRemoteFunction("src_ShowColorMenu","dd",playerid,toggle);

stock HideColorMenu(playerid)
	return CallRemoteFunction("src_HideColorMenu","d",playerid);

forward SelectedColor(playerid,color);
