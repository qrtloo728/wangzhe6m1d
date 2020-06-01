json = require "json.lua"

local MainForm = {}

function OnMainFormOpen(luaUIEvent)
	l_Online_form = luaUIEvent.SrcForm;
	LuaCallCs_Common.Log("OnMainFormOpen")
end

function OnMainFormClose(luaUIEvent)
end

--快速开始游戏
function OnQuicklyMatch(luaUIEvent)

	inputProxy1 = l_Online_form:GetWidgetProxyByName("InputField(1011)")
	textProxy1 = inputProxy1:GetText()
	str1 = textProxy1:GetContent()

	inputProxy2 = l_Online_form:GetWidgetProxyByName("InputField(1012)")
	textProxy2 = inputProxy2:GetText()
	str2 = textProxy2:GetContent()

	playerNum = tonumber(str1) 

	matchCode = tonumber(str2) 
	
	--StartSingleMatchingWithPlayerNum 将会把相同玩家数量，相同匹配参数的匹配发起者匹配到一起
	LuaCallCs_UGCStateDriver.StartSingleMatchingWithPlayerNum(playerNum, matchCode)
end


function OnStartOperate(luaUIEvent)
	--局域网下 发送SendMatchConfirm 进入自定义操作阶段
	LuaCallCs_UGCStateDriver.SendMatchConfirm()
end


--收到房间信息
function MainForm.OnReceiveRoomInfo(param)
	RoomInfo = json.decode(param)

	textLabelProxy = l_Online_form:GetWidgetProxyByName("TextLabel(1006)")
	local l_textProxy = textLabelProxy:GetText();
	l_textProxy:SetContent("房间信息:" .. param);
	
end

function MainForm.RefreshPlayerInfo()
	playerTextTable = {}
	playerTextTable[1] = l_Online_form:GetWidgetProxyByName("TextLabel(1018)")
	playerTextTable[2] = l_Online_form:GetWidgetProxyByName("TextLabel(1019)")
	playerTextTable[3] = l_Online_form:GetWidgetProxyByName("TextLabel(1020)")
	playerTextTable[4] = l_Online_form:GetWidgetProxyByName("TextLabel(1021)")
	playerTextTable[5] = l_Online_form:GetWidgetProxyByName("TextLabel(1022)")
	playerTextTable[6] = l_Online_form:GetWidgetProxyByName("TextLabel(1024)")
	
	curRoomInfo = LuaCallCs_UGCStateDriver.GetCurRoomDetailInfo()
	playerNum = curRoomInfo.playerInfoList.Count
	
	maxNum = 6
	if(maxNum > playerNum)
	then
	maxNum = playerNum
	end 
	
	--显示已加入房间的玩家名
	for i = 0, maxNum - 1 do
		textLabelProxy = playerTextTable[i + 1]
		textProxy = textLabelProxy:GetText();
		playerName_ = curRoomInfo.playerInfoList[i].plyerName
		textProxy:SetContent(playerName_);
	end
	
	--如果不是自己开的房间，隐藏开始
	buttonProxy = l_Online_form:GetWidgetProxyByName("Button(1008)")
	selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()
	if(selfPlayerInfo.playerID == curRoomInfo.CreatorID)
	then
		buttonProxy:SetActive(true)
	else
		buttonProxy:SetActive(false)
	end
end

--加入房间成功
function MainForm.OnJoinRoomRsp(param)
	
	MainForm.RefreshPlayerInfo()
	
	curRoomInfo = LuaCallCs_UGCStateDriver.GetCurRoomDetailInfo()
	
	--如果不是自己开的房间，隐藏开始
	buttonProxy = l_Online_form:GetWidgetProxyByName("Button(1008)")
	selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()
	if(selfPlayerInfo.playerID == curRoomInfo.CreatorID)
	then
		buttonProxy:SetActive(true)
	else
		buttonProxy:SetActive(false)
	end
end

--创建房间成功
function MainForm.OnCreateRoomSuc(param)
	RoomInfo = json.decode(param)

	--显示房间信息
	textLabelProxy = l_Online_form:GetWidgetProxyByName("TextLabel(1006)")
	textProxy = textLabelProxy:GetText();
	textProxy:SetContent("房间信息:" .. param);
	
	MainForm.RefreshPlayerInfo()
	
	--如果不是自己开的房间，隐藏开始
	buttonProxy = l_Online_form:GetWidgetProxyByName("Button(1008)")
	selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()
	if(selfPlayerInfo.playerID == RoomInfo.CreatorID)
	then
		buttonProxy:SetActive(true)
	else
		buttonProxy:SetActive(false)
	end

	--LuaCallCs_Common.Log(selfPlayerInfo.plyerName)
end

function MainForm.OnPlayerChanged(param)
	MainForm.RefreshPlayerInfo()
end

function OnReturn(luaUIEvent)
	LuaCallCs_UI.OpenForm("UI/LanMode/Startup.uixml");
end

return MainForm