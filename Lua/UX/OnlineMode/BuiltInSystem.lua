function OnFormOpen()
    LuaCallCs_InnerSystem.OpenInnerBattleChatForm()
    local camp = LuaCallCs_Battle.GetHostPlayerCamp()
    LuaCallCs_InnerSystem.SetInnerBattleChatCamp(camp)
end


function OnFormClose()

end


function OnInnerChartBtnClick(UIEvent)
    LuaCallCs_InnerSystem.ShowInnerBattleChatInput()
end

function OnEndGameBtnClick(UIEvent)
    --获取当前玩家PlayerID
    local PID = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo().playerID 
    --发送指定玩家离开游戏申请, 在蓝图startup.gl中会接收事件并处理下一步
    LuaCallCs_UGCStateDriver.RequestQuitBattle(PID)
    -- local message = {}
    -- message.funcname = "BuyEquip"
    -- passp = json.encode(message);
    -- LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
end


function UseItem1()
    LuaCallCs_Item.UseItem(2, 1)
end

