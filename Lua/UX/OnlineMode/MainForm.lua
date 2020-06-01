json = require "json.lua"

local MainForm = {}

local v8State = 0;
local RealNum = 1;

function OnMainFormOpen(luaUIEvent)
	l_self_form = luaUIEvent.SrcForm;
	--创建局外聊天黑盒
	LuaCallCs_InnerSystem.CreateInnerLobbyChatForm()
end

function OnMainFormClose(luaUIEvent)
	--销毁局外聊天黑盒
	LuaCallCs_InnerSystem.DestoryInnerLobbyChatForm()
end


--单人匹配
function OnQuicklyMatchOnePlayer(luaUIEvent)
	--发送匹配申请
	LuaCallCs_UGCStateDriver.StartSingleMatchingWithPlayerNum(1,1)
end

--两人匹配
function OnQuicklyMatchTwoPlayer(luaUIEvent)
	--发送匹配申请
	LuaCallCs_UGCStateDriver.StartSingleMatchingWithPlayerNum(2,1)
end

--四人匹配
function OnQuicklyMatchFourPlayer(luaUIEvent)
	--发送匹配申请
	LuaCallCs_UGCStateDriver.StartSingleMatchingWithPlayerNum(4,1)
end

--六人匹配
function OnQuicklyMatchSixPlayer(luaUIEvent)
	--发送匹配申请
	LuaCallCs_UGCStateDriver.StartSingleMatchingWithPlayerNum(6,1)
end

--八人匹配
function OnQuicklyMatchEightPlayer(luaUIEvent)
	--发送匹配申请
	LuaCallCs_UGCStateDriver.StartSingleMatchingWithPlayerNum(8,1)
end


-- 4v4 匹配，1真人，7机器人
function OnQuicklyMatchOneAndSevenPlayer(luaUIEvent)
	--发送匹配申请
	LuaCallCs_UGCStateDriver.StartSingleMatchingWithPlayerNum(1,1)
	v8State = 1;
	RealNum = 1;
end

-- 4v4 匹配，2真人，6机器人
function OnQuicklyMatchTwoAndSixPlayer(luaUIEvent)
	--发送匹配申请
	LuaCallCs_UGCStateDriver.StartSingleMatchingWithPlayerNum(2,1)
	v8State = 1;
	RealNum = 2;
end

function MainForm.GetV8State()
	return v8State;
end	

function MainForm.GetRealNum()
	return RealNum;
end	

--当开始匹配的时候
function MainForm.OnStartMatching()
	--显示顶部匹配时间UI黑盒
	LuaCallCs_TeamMatch.ShowOrUpdateMatchingStateTopTeamFuncForm()
end

--匹配成功，收到需要点击确认的要求
function MainForm.ReceiveNeedConfirmMatching(param)
	--显示匹配确认界面黑盒
	LuaCallCs_TeamMatch.ShowMatchingConfirmBox(enUGCMatchingConfirmBoxType.enConfirmBoxType_SingleSide)
end



--开启背包界面
function OpenInnerSystemBagUI()
	--开启背包黑盒界面
	LuaCallCs_InnerSystem.OpenInnerBagForm()
end


--添加道具
function AddCustomItem()
	--添加道具(仅在测试服务器有效)
	LuaCallCs_Item.AddItem(2, 1)
end

function OpenChatRoom()
	--显示局外聊天界面
	LuaCallCs_InnerSystem.ShowInnerLobbyChatForm()
end


function OpenFriendRoom()
	--显示好友界面
	LuaCallCs_Friend.OpenFriendForm()
end


function FacetoFaceRoom()
	--显示好友界面
	LuaCallCs_Room.CreateFaceToFaceRoom(20, 3, 10, "main_Level")
end


function CreateTeam()
	--开启组队匹配
	LuaCallCs_TeamMatch.CreateTeam(5, 1, 5, "main_Level")
end

function CreateTask()
	--开启任务面板
	LuaCallCs_InnerSystem.OpenInnerTaskForm()
end

function CreateRank()
	--显示排行榜
	local Ranking = {}
	table.insert(Ranking,{0,"击杀榜","击杀数"})
	table.insert(Ranking,{1,"金钱榜","金币数"})
	LuaCallCs_InnerSystem.OpenInnerRankingForm(Ranking)
end



function GetGameReport()
	--获取历史战绩
	LuaCallCs_History.RequestGameReportHistory() 
	LuaCallCs_Common.Log("GetGameReport")
end

function OnReceivedReportHistoryData()
	LuaCallCs_Common.Log("ReceivedReport")
	local HistArr = LuaCallCs_History.GetGameReportHistory()
	local HistArrLength = #HistArr
	LuaCallCs_Common.Log(HistArrLength)
	for i = 1, HistArrLength do	
		LuaCallCs_Common.Log(HistArr[i])
	end
    if  LuaCallCs_History.HasMoreReport() == true then
        LuaCallCs_History.RequestMoreGameReportHistory()
    end
end


return MainForm