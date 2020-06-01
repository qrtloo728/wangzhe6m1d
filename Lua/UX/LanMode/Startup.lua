--
function OnOffline(luaUIEvent)	
	G_GameData.IsOnline = false;
	LuaCallCs_UI.OpenForm("UI/LanMode/Offline.uixml");
end

function OnOnline(luaUIEvent)
	G_GameData.IsOnline = true;
	LuaCallCs_UI.OpenForm("UI/LanMode/Online.uixml");
end

