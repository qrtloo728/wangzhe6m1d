local l_self
local textCom
function OnGameEndFormOpen(luaUIEvent)
    l_self = luaUIEvent.SrcForm
    textCom = l_self:GetWidgetProxyByName("TextLabel(1003)"):GetText()
end

function OnGameEndFormClose()
end


function OnCloseBtnClick()
    LuaCallCs_UI.OpenForm("UI/OnlineMode/MainForm.uixml")
    --彻底关闭游戏
    LuaCallCs_GameFinish.CloseBattleScene()
end