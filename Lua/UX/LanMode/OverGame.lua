
local OverGameT ={};
function OnOverGameOpenUI(luaUIEvent)	
	
	l_OverGame = luaUIEvent.SrcForm;
	

	
--[[	local p = {};
	 p.funcname = "OpenOverGame";
	 passp = json.encode(p)
	 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)--]]
	
	

	
	
	
end

function OnOverGameCloseUI(luaUIEvent)
	
	
end

function OverGameT.ShowContent(state)
		
	local Text = l_OverGame:GetWidgetProxyByName("TextLabel(1003)"):GetText();
	
	if state  then
		
		Text:SetContent("defeated!!");
	
	else

		Text:SetContent("Victory!!");
	end
	
end




function OnOverClick(luaUIEvent)

--[[	local p = {};
	 p.funcname = "QuitGame";
	 passp = json.encode(p)
	 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)--]]
	
		
	--
	
	--LuaCallCs_UGCStateDriver.RequestQuitBattle(player_ID)
	
			
	local playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
    playerArrLenght = #playerArr

    --需要准备的数据

    for i = 1, playerArrLenght do
		
		local player_ID = playerArr[i].playerID;
		LuaCallCs_Common.Log("player_ID ==="..player_ID); 
		LuaCallCs_UGCStateDriver.RequestQuitBattle(player_ID)
	--	LuaCallCs_UGCStateDriver.SendPlayerQuitInfo(player_ID,true)

    end
	
	LuaCallCs_GameFinish.CloseBattleScene()
	
	
end

function OnAgainClick(luaUIEvent)

	
	
	local p = {};
	 p.funcname = "AgainGame";
	 passp = json.encode(p)
	 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
	
	l_OverGame:Hide();
	
end

return OverGameT