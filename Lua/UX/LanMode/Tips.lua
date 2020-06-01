local l_self

local Text


function OnTipsOpenUI(luaUIEvent)	
	
	l_self = luaUIEvent.SrcForm;
	
	Text = l_self:GetWidgetProxyByName("TextLabel(1003)"):GetText();
		
end

function OnTipsGameCloseUI(luaUIEvent)
	
	
end

function ShowTips(content)
		
	Text:SetContent(content);
	
end


function CloseTips()
--LuaCallCs_Common.Log ("CloseTips======")
	l_self:Hide();
	
end