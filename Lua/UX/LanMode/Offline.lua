local l_self
local l_mapdrop
local l_heroid
local l_heroiddrop
local l_heroidlist

--初始化
function OnStartupOpen(luaUIEvent)

	--创建默认房间
	LuaCallCs_UGCStateDriver.CreateRoom()

	--局域网下表示进入自定义操作阶段
	LuaCallCs_UGCStateDriver.SendMatchConfirm()
	
	--设置默认开局数据，该数据将在startup.gl中被使用，用于初始化关卡数据
	OfflineSetDefaultCustomOperation()
	
	l_self = luaUIEvent.SrcForm;
	l_mapdrop = l_self:GetWidgetProxyByName("MapNameDropList");
	l_heroiddrop = l_self:GetWidgetProxyByName("HeroID_Drop");
	
	mapname = LuaCallCs_Level.GetAllLevelFiles();--获取project下可用的level名字
	
	l_mapdrop:SetDropTextContents(mapname);
	l_mapdrop:SelectElement(0,false);
	
	heroidlist = LuaCallCs_Data.GetAllHeroInfo();--获取可以选用的英雄ID
	
	heroiddrop = {};
	l_heroidlist = {};
	for index =1,#heroidlist do
		heroiddrop[index] = heroidlist[index].cfgID.."("..heroidlist[index].heroName..")";
		l_heroidlist[index] = heroidlist[index].cfgID;
	end
	
	l_heroid = l_self:GetWidgetProxyByName("HeroID");
	l_heroid:SetInputContent(l_heroidlist[1]);
	
	l_heroiddrop:SetDropTextContents(heroiddrop);
	l_heroiddrop:SelectElement(0,true);
end

--发生改变
function OnHeroDropChange(luaUIEvent)	
	l_heroid:SetInputContent(l_heroidlist[l_heroiddrop:GetSelectedIndex()+1]);

	--数据改变，发送操作命令
	selfPlayer = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()
	
	local operateCmd = {}
	operateCmd.cmdType = 1;
	operateCmd.playerID = selfPlayer.playerID;
	operateCmd.selectHeroID = l_heroid:GetInputContent()

	operatData = json.encode(operateCmd)
	LuaCallCs_UGCStateDriver.SendOperateCmd(operatData)
end

--开始游戏
function OnPlay()
	G_GameData.HeroID = l_heroid:GetInputContent();

	nameidx = l_mapdrop:GetSelectedIndex();

	if nameidx >= 0 then
		dropp = l_mapdrop:GetDropListElement(nameidx);		

		--LuaCallCs_UGCStateDriver.StartGame 为局域网下的开始接口 参数是关卡名
		LuaCallCs_UGCStateDriver.StartGame(dropp:GetItemText():GetContent());
	end
	
end

--发送默认的自定义操作数据(也是开局数据,局域网下房主发)
function OfflineSetDefaultCustomOperation()

    ----初始化数据
	playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
    playerArrLenght = #playerArr

    --需要准备的数据

    for i = 1, playerArrLenght do

        local playerBattleInfo = {}

        playerBattleInfo.playerID = playerArr[i].playerID

        playerBattleInfo.heroID = 105;

        G_GameData.playerInfos[i] = playerBattleInfo

	end
	
	--初始化地图数据
	G_GameData.levelName = "main_level"

	--对数据序列化为json格式
	local operatData = json.encode(G_GameData)

	--发送数据到服务器
	LuaCallCs_UGCStateDriver.SendFullDataBuf(operatData)
end
