json = require "json.lua"
mainForm = require "OnlineMode/MainForm.lua"
GameDataMgr = require"OnlineMode/G_GameDataMgr.lua"
G_GameData = GameDataMgr.GameData
require "UIManager.lua"

--(不能改名)
function main()
    LuaCallCs_UI.OpenForm("UI/OnlineMode/MainForm.uixml")
    playerBattleInfoTable = {}
    G_GameData.playerInfos = playerBattleInfoTable
	--初始化UIManager
	UIManager:Init()
end

--(不能改名)当开始匹配的时候
function OnStartMatching()
    LuaCallCs_Common.Log("OnStartMatching")
    mainForm.OnStartMatching()
end


--(不能改名)匹配成功，需要玩家确认,需要都确认后才能让所有玩家进入匹配后的流程，如果长时间不确认则会被踢掉
function OnReceiveNeedConfirmMatching(param)
    LuaCallCs_Common.Log("OnReceiveNeedConfirmMatching")
	GameDataMgr.V8State = mainForm.GetV8State();
	GameDataMgr.RealNum = mainForm.GetRealNum();
    mainForm.ReceiveNeedConfirmMatching(param)
end

--(不能改名)进入自定义操作阶段
--如果是所有的玩家第一次进入自定义操作阶段则customOperation为nil或者长度为0
--如果是重连进入，则customOperation是当前的自定义操作的数据
function OnStartOperation(customOperation)
    --关闭所有除UGC以外的全部Form
    LuaCallCs_UI.CloseAllFormExceptUGC()
    --如果是第一次进入自定义操作
    GameDataMgr.OnStartOperation(customOperation)
end

--(不能改名)收到玩家自己定义的结果数据 fulldata 全量的玩家自定义的操作数据，用该数据刷新界面(断线重连时也会触发)
function OnReceiveOperateFullData(fulldata)
    fulldataTable = json.decode(fulldata)
end

--(不能改名)收到自定义操作命令 cmd是string类型
function OnReceiveOperateCmd(cmd)
    --根据自定义操作命令修改操作数据
	cmdInfo = json.decode(cmd)
    GameDataMgr.OnReceiveOperateCmd(cmd)
end

--(不能改名)单次自定义操作命令接收完，需要上传全量结果数据
function OnOperateCmdReceiveDone()
    GameDataMgr.OnOperateCmdReceiveDone()
end

--(不能改名)开始loading之后会被调用
function OnPersistentDataInBattleIsReady()
    GameDataMgr.OnPersistentDataInBattleIsReady()
end

--(不能改名)开始loading游戏
function OnStartLoadingGame()
		
    LuaCallCs_UI.CloseForm("UI/OnlineMode/MainForm.uixml")
    LuaCallCs_Loading.ShowTemplateLoading(enTemplateLoadingType.en_Loading_Single)
end

--(不能改名)
function OnFightPrepare()
    LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(enBattleUIForLua.BattleMain,"",false);
  --  LuaCallCs_UI.OpenForm("UI/OnlineMode/BuiltInSystem.uixml")
	
	LuaCallCs_UI.OpenForm("UI/LanMode/PlayerMainUI.uixml");			


	
	--隐藏内置BattleMainUI
	--LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(0,"",false)
	

	
	--LuaCallCs_FightUI.EnableUI(4, false)
	
	--开启UI响应Drag事件
	 LuaCallCs_FightUI.EnableDragUI(true)
	 --开启自由相机模式
	 LuaCallCs_FightUI.EnableFreeCamera(true)
	
	
--[[	local camerPos = LuaCallCs_FightUI.GetFreeCameraLocation();
	
	local Len = LuaCallCs_FightUI.GetCameraCurrentLens();
	
	LuaCallCs_FightUI.SetCameraLens(40)
	
	LuaCallCs_FightUI.GetCameraCurrentLens(20)--]]
	
		 --设置网格组件可见
	LuaCallCs_GridComponent.SetVisible(false);
	

	
end

--(不能改名)
function OnFightStart()
	LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(4,"",false)
	LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(8,"",false)
	
	LuaCallCs_FightUI.EnableUI(enFightUI.battleInfoButton , false) ---隐藏击杀信息
end

--发送玩家退出游戏信息,在蓝图startUp.gl中调用
function SendPlayerQuitGameInfo(playerID)
    --发送指定玩家离开游戏信息
    --true:  彻底结束游戏,触发数据上报函数(Saas指标数据,FixedFormatData,CustomIntArr,CustomStringArr,发送和接收GameReport)
    --false: 重新载入下一个Level的流程
    LuaCallCs_UGCStateDriver.SendPlayerQuitInfo(playerID, true)
    
end

--接收到可靠的单局战绩
function OnRecvGameReportInfo(data)

end


--FightOver事件会在数据上传函数被调用之后直接触发
--(不能改名,在收到GameReport之后触发.蓝图和GamePlay Lua停止运行)
function OnFightOver()
    LuaCallCs_UI.OpenForm("UI/OnlineMode/GameEnd.uixml")
end







