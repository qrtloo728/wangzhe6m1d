json = require "json.lua"
local G_GameDataMgr = {}
local GameData = {}
local AllPlayerPersistentData = {}
G_GameDataMgr.GameData = GameData
G_GameDataMgr.PersistentData = AllPlayerPersistentData


G_GameDataMgr.PlayerCoinNum = 20;---玩家金币
G_GameDataMgr.PlayerPowerNum = 0;---玩家法力值
G_GameDataMgr.AddPowerNumPerSec = 1;---玩家每秒钟增加的法力值
G_GameDataMgr.MaxPowerBasic = 500;---玩家法力值基值，根据等级翻倍
G_GameDataMgr.MaxPower = 99999;---玩家法力值最大值
G_GameDataMgr.PlayerActorID = 1;---主英雄ID
G_GameDataMgr.PlayerActorLevel = 1;---主英雄等级

G_GameDataMgr.ReadySoonTime = 2;-----准备进入选择时间
G_GameDataMgr.ReadyTime = 20-----选择防守和雇佣兵时间
G_GameDataMgr.FightTime = 2;----------检测防守者时间
G_GameDataMgr.FightNum = 0;-----波次
G_GameDataMgr.HeroFOV = 10000;-----视野范围
G_GameDataMgr.RandomCoin = 4 ;------初始刷新的金币
G_GameDataMgr.AddRandom = 1;------每次刷新增加的数量
G_GameDataMgr.randT = {};----随机英雄的数据 

G_GameDataMgr.State = 1 -----游戏状态
G_GameDataMgr.JueDouIndex = 4------决斗波次

G_GameDataMgr.SkillCDTable={};-------------技能CD时间

G_GameDataMgr.V8State = 0;

G_GameDataMgr.RealNum = 1; -- 实际匹配人数



function G_GameDataMgr.OnStartOperation(customOperation)
    if (customOperation == nil or string.len(customOperation) == 0)
    then
        --发送默认数据到服务器中
        SendDefaultCustomOperation()
		LuaCallCs_UI.CloseForm("UI/OnlineMode/MainForm.uixml")
		LuaCallCs_UI.OpenForm("UI/OnlineMode/OperationForm.uixml")
        --如果是重连进入
    else
		LuaCallCs_UI.CloseForm("UI/OnlineMode/MainForm.uixml")
		LuaCallCs_UI.OpenForm("UI/OnlineMode/OperationForm.uixml")
    end
end

--开始loading之后,开始准备游戏内使用的玩家自定义数据
function G_GameDataMgr.OnPersistentDataInBattleIsReady()
    --获取所有玩家的PlayerInfo
    local playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
    local playerArrLenght = #playerArr
    --循环
    for i = 1,playerArrLenght do
        local PID = playerArr[i].playerID
        local PlayerPersistentData = {}
        PlayerPersistentData.FixedFormatData  = LuaCallCs_PersistentDataInBattle.GetFixedFormatDataInBattle(PID)
        PlayerPersistentData.CustomizeDataIntArr = LuaCallCs_PersistentDataInBattle.GetCustomizeDataIntArrInBattle(PID)
        PlayerPersistentData.CustomizeDataStringArr = LuaCallCs_PersistentDataInBattle.GetCustomizeDataStringArrInBattle(PID)
        PlayerPersistentData.ReportData = "WinGame"
        PlayerPersistentData.SaasData = {}
        PlayerPersistentData.SaasData.IsWin = 1
        PlayerPersistentData.SaasData.killcnt = 2
        AllPlayerPersistentData[PID] = PlayerPersistentData
    end
end

--发送默认的自定义操作数据(也是开局数据)
function SendDefaultCustomOperation()
    --一定要先发送默认数据, 这样玩家不进行任何操作也能开始游戏
    ----初始化数据
	playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
    playerArrLenght = #playerArr
	
	LuaCallCs_Common.Log("playerArrLenght ========"..playerArrLenght);
	
	LuaCallCs_Common.Log("G_GameDataMgr.V8State ====="..G_GameDataMgr.V8State);
	
	if G_GameDataMgr.V8State > 0 then
		
		for i = 1, 8 do
			local playerBattleInfo = {}
			local player_ID = 0;
			local robotID = 0;
			local area = 0;
			if playerArrLenght == 1 then
				player_ID = tonumber(playerArr[1].playerID);
				if i > playerArrLenght then
					player_ID = player_ID + i;
					robotID = 20101
					if i == 2 then
						area = 1;
					elseif i == 3 then
						area = 2;
					elseif i == 4 then
						area = 2;	
					elseif i == 5 then
						area = 3;
					elseif i == 6 then
						area = 3;
					elseif i == 7 then
						area = 4;
					elseif i == 8 then
						area = 4;
					end
				end
			else
				local index = math.mod(i,2)
				if index == 0 then
					player_ID = playerArr[2].playerID
				else
					player_ID = playerArr[1].playerID
				end
				if i > playerArrLenght then
					player_ID = player_ID + i;
					robotID = 20101
				end
				if i == 3 then
					area = 2;
				elseif i == 4 then
					area = 2;	
				elseif i == 5 then
					area = 3;
				elseif i == 6 then
					area = 3;
				elseif i == 7 then
					area = 4;
				elseif i == 8 then
					area = 4;
				end
			end

			playerBattleInfo.playerID = player_ID
			playerBattleInfo.heroID = 105 + i - 1;
			playerBattleInfo.robotID = robotID;
			playerBattleInfo.robotArea = area;
			GameData.playerInfos[i] = playerBattleInfo
		end
		
	else

		--需要准备的数据
		for i = 1, playerArrLenght do
			local playerBattleInfo = {}
			playerBattleInfo.playerID = playerArr[i].playerID
			playerBattleInfo.heroID = 105;
			playerBattleInfo.robotID = 0;
			playerBattleInfo.robotArea = 0;
			GameData.playerInfos[i] = playerBattleInfo
		end
	end

    --初始化地图数据
    GameData.levelName = "hengban"

	--对数据序列化为json格式
	operatData = json.encode(GameData)
	--发送数据到服务器
	LuaCallCs_UGCStateDriver.SendFullDataBuf(operatData)
end


function G_GameDataMgr.OnReceiveOperateCmd(cmd)
    --切换英雄
    if (cmdInfo.cmdType == 1) then
        for i = 1, playerArrLenght do
            if GameData.playerInfos[i].playerID == cmdInfo.playerID
            then
                GameData.playerInfos[i].heroID = cmdInfo.selectHeroID
            end
        end
    --切换地图
    elseif (cmdInfo.cmdType == 2) then 
        GameData.levelName = cmdInfo.levelName
    end
		
	GameData.v8 = G_GameDataMgr.V8State 
	GameData.realNum = G_GameDataMgr.RealNum  
end


function G_GameDataMgr.OnOperateCmdReceiveDone()
    local OpData = json.encode(GameData)
    --上传全量数据
	LuaCallCs_UGCStateDriver.SendFullDataBuf(OpData)
end


--当数据发生变化时(自动调用)
function OnFixedFormatDataChanged()
    --获取用户自身的数据
    local fixedData = LuaCallCs_PersistentData.GetFixedFormatData()
    local DTable = json.decode(fixedData) 
    --获取匹配分数(内置固定数据,用来决定玩家之间的匹配优先级)
    local score = fixedData.MatchScore
end


--当数据发生变化时(自动调用)
function OnCustomizeIntAllDataChanged()
    --获取用户自身的数据 
   local customIntArr = LuaCallCs_PersistentData.GetCustomizeDataIntArr()
   local v = customIntArr[200]
end

--当数据发生变化时(自动调用)
function OnCustomizeStringAllDataChanged()
    --获取用户自身自定义数据
    local StringArr = LuaCallCs_PersistentData.GetCustomizeDataStringArr()
    local s = StringArr[5]
end


--上传单局战绩, 自动保存到战绩历史记录里面(服务器会自动比对,下发可靠数据)
function UploadGameReport(PlayerID)
    return AllPlayerPersistentData[PlayerID].ReportData
end

--上传Saas的指标数据(自动调用)
function UploadSaasString(PlayerID)
    --只需要上传单局的数据, 指标数据会根据在后台配置的规则自动累加
	local SaasString = json.encode(AllPlayerPersistentData[PlayerID].SaasData)
    return SaasString
end


function UploadFixedFormatData(playerID)
    return AllPlayerPersistentData[playerID].FixedFormatData
end

function UploadCustomizeIntArr(playerID)
    return AllPlayerPersistentData[playerID].CustomizeDataIntArr
end

function UploadCustomizeStringArr(playerID)
    return AllPlayerPersistentData[playerID].CustomizeDataStringArr
end


return G_GameDataMgr