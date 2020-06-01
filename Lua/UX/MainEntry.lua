--天工入口文件，请不要改名
--
--

json = require "json.lua"
G_GameData = G_GameData or {}
onlineForm = require "LanMode/Online.lua"
G_GameData.IsOnline = false;

--第一个被呼叫的函数（不能改名字）
function main()
	--LuaCallCs_Common.Log("main");
	LuaCallCs_UI.OpenForm("UI/LanMode/Startup.uixml");
	playerBattleInfoTable = {}
    G_GameData.playerInfos = playerBattleInfoTable
end

--进入自定义操作阶段（不能改名字）
--如果是所有的玩家第一次进入自定义操作阶段则customOperation为nil或者长度为0
--如果是重连进入，则customOperation是当前的自定义操作的数据
function OnStartOperation(customOperation)

    if (customOperation == nil or string.len(customOperation) == 0)
    then
        --打开自定义操作界面
		if G_GameData.IsOnline == true then
			LuaCallCs_UI.CloseForm("UI/LanMode/Online.uixml")
			LuaCallCs_UI.OpenForm("UI/LanMode/OnlineOperation.uixml");
		end
    else
        --刷新自己的操作界面
    end

end

--收到自定义操作命令 cmd是string类型（不能改名字）
function OnReceiveOperateCmd(cmd)

    local playerInfoArrLenght = #G_GameData.playerInfos
    --根据自定义操作命令修改操作数据
	cmdInfo = json.decode(cmd)

    if (cmdInfo.cmdType == 1) then

        for i = 1, playerInfoArrLenght do

            if G_GameData.playerInfos[i].playerID == cmdInfo.playerID
            then
                G_GameData.playerInfos[i].heroID = cmdInfo.selectHeroID
            end
        end
	end

	if (cmdInfo.cmdType == 2) then
		G_GameData.levelName = cmdInfo.levelName 
	end

	local OpData = json.encode(G_GameData)
	LuaCallCs_UGCStateDriver.SendFullDataBuf(OpData)
end

--单次自定义操作命令接收完，需要上传全量结果数据（不能改名字，在线模式调用）
function OnOperateCmdReceiveDone()
	local OpData = json.encode(G_GameData)
	LuaCallCs_UGCStateDriver.SendFullDataBuf(OpData)
end

--收到玩家自己定义的结果数据 fulldata 全量的玩家自定义的操作数据，用该数据刷新界面
function OnReceiveOperateFullData(fulldata)
	G_GameData = json.decode(fulldata)
	--可以用G_GameData数据重新刷新界面
end

--（不能改名字）
function OnCreateRoomSuccess(param)
    if G_GameData.IsOnline == true then
		onlineForm.OnCreateRoomSuc(param)
	end
end

--（不能改名字）
function OnReceiveRoomInfo(param)
    if G_GameData.IsOnline == true then
		onlineForm.OnReceiveRoomInfo(param)
	end
end

--（不能改名字）
function OnJoinRoomRsp(param)
    if G_GameData.IsOnline == true then
		onlineForm.OnJoinRoomRsp(param)
	end
end

--（不能改名字）
function OnPlayerChanged(param)
    if G_GameData.IsOnline == true then
		onlineForm.OnPlayerChanged(param)
	end
end

--（不能改名字）
function OnQuitRoomRsp()

end

--（不能改名字）
function OnRoomBeDestroyed(param)

end

--(不能改名)进入匹配过程中
function OnStartMatching()
    LuaCallCs_TeamMatch.ShowOrUpdateMatchingStateTopTeamFuncForm()
end

--(不能改名)匹配成功，需要玩家确认,需要都确认后才能让所有玩家进入匹配后的流程，如果长时间不确认则会被踢掉
function OnReceiveNeedConfirmMatching(param)
    mainForm.ReceiveNeedConfirmMatching(param)
    LuaCallCs_TeamMatch.ShowMatchingConfirmBox(enUGCMatchingConfirmBoxType.enConfirmBoxType_SingleSide)
end

--开始加载游戏（不能改名字）
function OnStartLoadingGame()
    if G_GameData.IsOnline == true then
		LuaCallCs_UI.CloseForm("UI/LanMode/Online.uixml")
		LuaCallCs_UI.CloseForm("UI/LanMode/OnlineOperation.uixml")
	end
	LuaCallCs_Loading.ShowTemplateLoading(enTemplateLoadingType.en_Loading_Single)
end

--战斗准备（不能改名字）
function OnFightPrepare()

	LuaCallCs_UI.OpenForm("UI/LanMode/CameraSettingUI.uixml");
	
		--隐藏内置BattleMainUI
	LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(0,"",false)
	
	--开启UI响应Drag事件
	 LuaCallCs_FightUI.EnableDragUI(true)
	 --开启自由相机模式
	 LuaCallCs_FightUI.EnableFreeCamera(true)
	
end

--战斗开始（不能改名字）
function OnFightStart()

	LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(4,"",false)
	LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(8,"",false)
	
end

--战斗结束（不能改名字）
function OnFightOver()
    if G_GameData.IsOnline == true then	
		LuaCallCs_UI.OpenForm("UI/LanMode/Online.uixml")
	end
end

--游戏结束（不能改名字）
function OnGameEnd()

end

--收到返还的结算信息
function OnRecvGameOverInfo(param)
end

--收到匹配成功后需要确认是否进入 param玩家输入的匹配参数
function OnReceiveNeedConfirmMatching(param)
end

--匹配队伍被销毁
function MatchTeamDestroyNtf()
end

--玩家匹配成功后，发送了确认信息的玩家
function OnPlayerConfirmMatching(playerUid)
end

--有玩家离开匹配队伍
function OnMatchPlayerLeave(playerUid)
end