
local CamerPosText = "";

local InputWidget;

local InputCameraY;

local InputCameraD;

local CamerDepthText;

local CameraPos = {};
CameraPos[1] = {[1] = -67.5,[2] = 10,[3] = 0} --x,y,z,
CameraPos[2] = {[1] = -45,[2] = 10,[3] = 0} 
CameraPos[3] = {[1] = -20,[2] = 10,[3] = 0} 
CameraPos[4] = {[1] = 5,[2] = 10,[3] = 0} 
CameraPos[5] = {[1] = 27,[2] = 10,[3] = 0}
CameraPos[6] = {[1] = -67.5,[2] = 10,[3] = -32} 
CameraPos[7] = {[1] = -45,[2] = 10,[3] = -32} 
CameraPos[8] = {[1] = -20,[2] = 10,[3] = -32} 
CameraPos[9] = {[1] = 5,[2] = 10,[3] = -32} 
CameraPos[10] = {[1] = 27,[2] = 10,[3] = -32} 
CameraPos[11] = {[1] = 50,[2] = 10,[3] = 0} 

local Y = 0;--cameraY

local buttonTable ={};



--全局唯一函数 OnTouchDragStart
function OnTouchDragStart(luaUIEvent)
    --获取摄像机当前位置
    curPos = LuaCallCs_FightUI.GetFreeCameraLocation()
	
	RefreshPosShow();
end

--全局唯一函数 OnTouchDrag
function OnTouchDrag(luaUIEvent)
	
	local factor = 0.1
    local delta = BluePrint.UGC.UI.Core.Vector3(luaUIEvent.PointerData.Delta.x * factor, 0, luaUIEvent.PointerData.Delta.y * factor)
    curPos = curPos - delta
    
    --设置摄像机当前位置 (是否要重命名)
    LuaCallCs_FightUI.SetFreeCameraLocation(curPos)
	
	RefreshPosShow();
	
	

end

function GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal);
    local nRet = nTemp / nDecimal;
    return nRet;
end

function StringSplit(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end


function OnCreatCameraSettingOpen(LuaUIEvent)
	
	heroHead_self = LuaUIEvent.SrcForm;
		
	CamerPosText = heroHead_self:GetWidgetProxyByName("TextLabel(1016)")
	
	ChangeButton = heroHead_self:GetWidgetProxyByName("Button(1018)")
	
	InputWidget =  heroHead_self:GetWidgetProxyByName("InputField(1017)")
	
	InputCameraY =  heroHead_self:GetWidgetProxyByName("InputField(1023)")
	
	InputCameraD =  heroHead_self:GetWidgetProxyByName("InputField(1025)")
	
	CamerDepthText = heroHead_self:GetWidgetProxyByName("TextLabel(1027)")
	
--[[	local Button2 = heroHead_self:GetWidgetProxyByName("Button(2)")
	Button2:SetAlpha(0.3);
	
	local str = "Button("..tostring(3)..")"
	local Button3 = heroHead_self:GetWidgetProxyByName(str)
	Button3:SetAlpha(0.4);--]]
	

	--LuaCallCs_Common.Log("Button1 ====="..Button1);
	
	for i = 1, 11 do 
		local str = "Button("..tostring(i)..")"
		local button = heroHead_self:GetWidgetProxyByName(str)
		if button ~= nil then
			table.insert(buttonTable,button)
		end
	end
	
	
	CurIndex = 1;
	
	SetButtonApha(CurIndex,0.5)
	ButtonClick(1);
	
	
	
	ShowCameraDepth();

end

function GetButtonByName(index)
	
	local button = nil;
	local str = "Button("..tostring(index)..")"
	for i = 1, #buttonTable do
		
		if buttonTable[i]:GetName() == str  then
			button = buttonTable[i];
			break;
		end
			
	end

	return button;
end

function SetButtonApha(index,aha)
	
	local button = GetButtonByName(index)
	if button ~= nil then
		button:SetAlpha(aha);
	end

end



function RefreshPosShow()
	
		
	local  cameraPos =  LuaCallCs_FightUI.GetFreeCameraLocation()
	
	local camStr = "x = "..tostring(GetPreciseDecimal(cameraPos.x,2)).."| y = " ..tostring(GetPreciseDecimal(cameraPos.y,2)).."| z = "..tostring(GetPreciseDecimal(cameraPos.z,2))
	
	CamerPosText:GetText():SetContent(camStr)
	
	
end	

function ChangeClick()
		
	
	local inputCon = InputWidget:GetInputContent();
	local arrInfo = StringSplit(inputCon,",");
	if #arrInfo == 3 then
		CameraPos[CurIndex][1] = tonumber(arrInfo[1])
		CameraPos[CurIndex][2] = tonumber(arrInfo[2])
		CameraPos[CurIndex][3] = tonumber(arrInfo[3])
		
	end
	
	ButtonClick(CurIndex);
	
end	

function ButtonClick(Index)
	
	local MyPos = BluePrint.UGC.UI.Core.Vector3(tonumber(CameraPos[Index][1]),tonumber(CameraPos[Index][2]),tonumber(CameraPos[Index][3]));
	
	LuaCallCs_FightUI.SetFreeCameraLocation(MyPos);
	
	RefreshPosShow();
	
end	

function ChangeYClick()
	
	local inputCon = InputCameraY:GetInputContent();
	local MyCamY = tonumber(inputCon)
	LuaCallCs_Battle.SetCameraRotateByYAxis(MyCamY);
	
end	

function ShowCameraDepth()
	
	local deth = 	LuaCallCs_FightUI.GetCameraCurrentLens();
	
	local str = tostring(deth)
	
	CamerDepthText:GetText():SetContent(str)
	
	
end	

function ChangeDClick()
	
	local inputCon = InputCameraD:GetInputContent();
	local lens = tonumber(inputCon)
	LuaCallCs_FightUI.SetCameraLens(lens)
	ShowCameraDepth();
	
end	

function Button1Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 1;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
	
end	

function Button2Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 2;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function Button3Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 3;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function Button4Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 4;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function Button5Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 5;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function Button6Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 6;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function Button7Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 7;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function Button8Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 8;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function Button9Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 9;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function Button10Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 10;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function Button11Click()
	SetButtonApha(CurIndex,1)
	CurIndex = 11;
	SetButtonApha(CurIndex,0.5)
	ButtonClick(CurIndex)
end	

function OnCreatCameraSettingClose(LuaUIEvent)
	
	
	
end

