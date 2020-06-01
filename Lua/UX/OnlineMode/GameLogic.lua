json = require "json.lua"
mainForm = require "OnlineMode/MainForm.lua"

--发送玩家请求退出  玩家自定义接口
function RequestQuitBattle(playerID)
	LuaCallCs_UGCStateDriver.RequestQuitBattle(playerID)
end

--发送玩家退出游戏信息  玩家自定义接口 退出游戏游戏后表示所有的游戏结束
function SendPlayerQuitGameInfo(playerID, info)
	LuaCallCs_UGCStateDriver.SendPlayerQuitInfo(playerID, info, true)
end

--发送玩家退出关卡信息  玩家自定义接口 退出关卡表示
function SendPlayerQuitLevel(playerID, info)
	LuaCallCs_UGCStateDriver.SendPlayerQuitInfo(playerID, info, false)
end
