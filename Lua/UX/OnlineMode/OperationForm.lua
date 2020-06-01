local l_self
local l_mapdrop
local l_heroid
local l_heroiddrop
local l_heroidlist

--初始化
function OnStartupOpen(luaUIEvent)
	l_self = luaUIEvent.SrcForm;
	l_mapdrop = l_self:GetWidgetProxyByName("MapNameDropList");
	l_heroiddrop = l_self:GetWidgetProxyByName("HeroID_Drop");
	
	mapname = LuaCallCs_Level.GetAllLevelFiles();--获取project下可用的level名字
	
	l_mapdrop:SetDropTextContents(mapname);
	l_mapdrop:SelectElement(0,true);
	
	heroidlist = LuaCallCs_Data.GetAllHeroInfo();--获取可以选用的英雄ID
	
	heroiddrop = {}
	l_heroidlist = {}
	lastElem = 0
	for index =1,#heroidlist do
		heroiddrop[index] = heroidlist[index].cfgID.."("..heroidlist[index].heroName..")";
		l_heroidlist[index] = heroidlist[index].cfgID;
		lastElem = index
	end
	l_heroid = l_self:GetWidgetProxyByName("HeroID");
	l_heroid:SetInputContent(l_heroidlist[1]);

	l_heroiddrop:SetDropTextContents(heroiddrop);
	l_heroiddrop:SelectElement(0,true);
	

end

--选择英雄后的回调
function OnHeroDropChange(luaUIEvent)	
	l_heroid:SetInputContent(tostring(l_heroidlist[l_heroiddrop:GetSelectedIndex()+1]));
	--选择英雄
	playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
	selfPlayer = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()
	playerArrLenght = #playerArr
	--构造命令
	local operateCmd = {}
	operateCmd.cmdType = 1;
	operateCmd.playerID = selfPlayer.playerID;
	operateCmd.selectHeroID = l_heroid:GetInputContent()
	operatData = json.encode(operateCmd)
	--发送自定义操作命令
	LuaCallCs_UGCStateDriver.SendOperateCmd(operatData)
end

--选择关卡
function OnLevelDropChange(luaUIEvent)
	local nameidx = l_mapdrop:GetSelectedIndex()
	local dropp = l_mapdrop:GetDropListElement(nameidx)
	
	local operateCmd = {}
	operateCmd.cmdType = 2;
	operateCmd.levelName = dropp:GetItemText():GetContent()

	local operatData = json.encode(operateCmd)
	LuaCallCs_UGCStateDriver.SendOperateCmd(operatData)
end

--操作完成，通知服务器操作完成，所有的玩家都确认后服务器下发开局协议
function OnCompleted()
	LuaCallCs_UGCStateDriver.SendCustomOperationCompleted(G_GameData.levelName)
end

--用data刷新界面
function OperationRefreshUI(fulldata)
 
end

