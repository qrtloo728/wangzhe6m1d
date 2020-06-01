--

local l_self

function OnStartOpenUI(luaUIEvent)	

	--创建默认房间
	LuaCallCs_UGCStateDriver.CreateRoom()

	--局域网下表示进入自定义操作阶段
	LuaCallCs_UGCStateDriver.SendMatchConfirm()
	
	--设置默认开局数据，该数据将在startup.gl中被使用，用于初始化关卡数据
	OfflineSetDefaultCustomOperation()
	
	l_self = luaUIEvent.SrcForm;
	
end

function OnStartClose(luaUIEvent)
	
end


function OnStartClick(luaUIEvent)

	G_GameData.HeroID = 105

	--LuaCallCs_UGCStateDriver.StartGame("main_level");
	
	--LuaCallCs_UGCStateDriver.StartGame("Level1");
	l_self:Hide();
	
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
	--对数据序列化为json格式
	local operatData = json.encode(G_GameData)
	--发送数据到服务器
	LuaCallCs_UGCStateDriver.SendFullDataBuf(operatData)
end



