--UIManager用来接收全局唯一的事件
UIManager = UIManager or {}

--保存格子是否已经被占用的信息
UIManager.m_grid = nil
--保存当前鼠标点击格子的Index
UIManager.m_curCellIndex = nil
--是否在移动英雄
UIManager.m_isMoving  = nil
--保存Actor身上的3DUI
UIManager.m_3DUI = nil
--是否在拖动英雄
UIManager.m_isDrag  = nil

UIManager.DorpHerosPlayer = {};

UIManager.DefendActorInfo = {};

UIManager.selfArea = 0;

UIManager.redRobotDefendPos = {};
UIManager.blueRobotDefendPos = {};

UIManager.redRobotJueDouPos = {};
UIManager.blueRobotJueDouPos = {};

OverGameFormLua = require "LanMode/OverGame.lua"
CreateActorFormLua = require "LanMode/CreateActor.lua"
mainPlayerForm = require "LanMode/PlayerMainUI.lua"

Util = require "Util.lua"


function UIManager:Init()
    self.m_grid = {}
    self.m_isMoving = false
	self.m_isDrag = false;
    self.m_3DUI = {}
	self.DorpHerosPlayer = {};
	self.DefendActorInfo = {};	
end

function  GameOneSecTick()
	
	mainPlayerForm.Tick();
	CreateActorFormLua.Tick();
	
end	
--CleanUp Grid Info
function UIManager.CleanUpGridInfo(CIndex)
    UIManager.m_grid[CIndex] = nil
end


function UIManager.CreateDefendHeroActor(GirdIndex,configID,camp,posInfo,level,area)
	
		  
	local defendInfo = {};
	defendInfo.configID = configID;
	defendInfo.camp = camp;
	defendInfo.posInfo = posInfo;
	defendInfo.level = level;
	defendInfo.area = area
	UIManager.DefendActorInfo[GirdIndex] = defendInfo;
	
end	

function UIManager.RefeshDefendHerolevel(GirdIndex,level)
	
	if UIManager.DefendActorInfo[GirdIndex] ~= nil then
		UIManager.DefendActorInfo[GirdIndex].level = level;
	end
	
	
end	

function UIManager.DestroyDefendHero(GirdIndex)
	
  UIManager.DefendActorInfo[GirdIndex] = nil;

end

function RefeshDefendHero(index,level)

	UIManager.RefeshDefendHerolevel(index,level)
end	


function MoveDefendHero(index)

	local heroInfo = UIManager.DefendActorInfo[UIManager.m_curCellIndex];
	UIManager.CreateDefendHeroActor(index,heroInfo.configID,heroInfo.camp,heroInfo.posInfo,heroInfo.level);
	UIManager.DefendActorInfo[UIManager.m_curCellIndex] = nil;
	
	
end	

function InitAllRobotDefendPos(red,blue,redj,bluej)
	
	
	for i = 1 , #red do
		UIManager.redRobotDefendPos[i] = red[i]
	end
	
	for i = 1 , #blue do
		UIManager.blueRobotDefendPos[i] = blue[i]
	end
	
	for i = 1 , #redj do
		UIManager.redRobotJueDouPos[i] = redj[i]
	end
	
	for i = 1 , #bluej do
		UIManager.blueRobotJueDouPos[i] = bluej[i]
	end

	
end	

function CreateRobotDefend(redRobotArea,blueRobotArea,playerID,realNum,juedou)
	
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()		
--[[	LuaCallCs_Common.Log("realNum ================"..realNum);

	LuaCallCs_Common.Log("#redRobotArea ===================="..#redRobotArea);
	
	--]]

	local num = GameDataMgr.FightNum;
	if juedou > 0 then
		num = 999
	end
	local robotData = Util.GetRobotDataByID(num);
	if robotData  == nil then
		return;
	end
	local id = robotData.id
		
	
	if selfPlayerInfo.playerID == playerID then
		if robotData ~= nil then
			local CIndex = 0;
			if realNum == 1 then
				
				for i = 1 , #redRobotArea do
					
					local temp = Util.StringSplit(UIManager.redRobotDefendPos[redRobotArea[i]], '|');
					local posInfo = tostring(math.floor(temp[1])).."|"..tostring(math.floor(temp[3]));
					
					if juedou > 0 then 
						id = robotData.id + i
						temp = Util.StringSplit(UIManager.redRobotJueDouPos[redRobotArea[i]], '|');
						posInfo = tostring(math.floor(temp[1])).."|"..tostring(math.floor(temp[3]));
					end
					
					local vT = BluePrint.UGC.UI.Core.Vector3(tonumber(temp[1]),tonumber(temp[2]),tonumber(temp[3]));
	
					CIndex = LuaCallCs_GridComponent.GetCellIndexByWorldPos(vT)
					
					--LuaCallCs_Common.Log("#CIndex ==============="..CIndex);
										
					CreateActorT.CreatDefendHeroActor(CIndex, id,1,posInfo,robotData.level,redRobotArea[i]);
					
				end
				

				for i = 1 , #blueRobotArea do
					
					local temp = Util.StringSplit(UIManager.blueRobotDefendPos[blueRobotArea[i]], '|');
					local posInfo = tostring(math.floor(temp[1])).."|"..tostring(math.floor(temp[3]));
					if juedou > 0 then 
						id = robotData.id + i
						temp = Util.StringSplit(UIManager.blueRobotJueDouPos[blueRobotArea[i]], '|');
						posInfo = tostring(math.floor(temp[1])).."|"..tostring(math.floor(temp[3]));
					end
		
					local vT = BluePrint.UGC.UI.Core.Vector3(tonumber(temp[1]),tonumber(temp[2]),tonumber(temp[3]));
	
					CIndex = LuaCallCs_GridComponent.GetCellIndexByWorldPos(vT)
				
					CreateActorT.CreatDefendHeroActor(CIndex, id,2,posInfo,robotData.level,blueRobotArea[i]);
					
				end
			else
				
				local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
				if selfCamp == 1 then
					
					for i = 1 , #redRobotArea do
						
						local temp = Util.StringSplit(UIManager.redRobotDefendPos[redRobotArea[i]], '|');
						local posInfo = tostring(math.floor(temp[1])).."|"..tostring(math.floor(temp[3]));
					
						if juedou > 0 then 
							id = robotData.id + i
							temp = Util.StringSplit(UIManager.redRobotJueDouPos[redRobotArea[i]], '|');
							posInfo = tostring(math.floor(temp[1])).."|"..tostring(math.floor(temp[3]));
						end

						local vT = BluePrint.UGC.UI.Core.Vector3(tonumber(temp[1]),tonumber(temp[2]),tonumber(temp[3]));
	
						CIndex = LuaCallCs_GridComponent.GetCellIndexByWorldPos(vT)

						CreateActorT.CreatDefendHeroActor(CIndex,id,1,posInfo,robotData.level,redRobotArea[i]);
						
					end
				
				else
					
					for i = 1 , #blueRobotArea do
						
						local temp = Util.StringSplit(UIManager.blueRobotDefendPos[blueRobotArea[i]], '|');
						local posInfo = tostring(math.floor(temp[1])).."|"..tostring(math.floor(temp[3]));
						if juedou > 0 then 
							id = robotData.id + i
							temp = Util.StringSplit(UIManager.blueRobotJueDouPos[blueRobotArea[i]], '|');
							posInfo = tostring(math.floor(temp[1])).."|"..tostring(math.floor(temp[3]));
						end

						local vT = BluePrint.UGC.UI.Core.Vector3(tonumber(temp[1]),tonumber(temp[2]),tonumber(temp[3]));
						CIndex = LuaCallCs_GridComponent.GetCellIndexByWorldPos(vT)
						CreateActorT.CreatDefendHeroActor(CIndex, id,2,posInfo,robotData.level,blueRobotArea[i]);
						
					end
					
				end
				
			end
		
						
		end
	end
	

--[[	
	--]]

	
end	


--显示英雄星级的3DUI
function ShowStar3DUI(actorID,level)

    local UIObject = nil
    --清空之前的3DUI
    if UIManager.m_3DUI[actorID] ~= nil then
        DestroyStar3DUI(actorID)
    end
    --创建新的3DUI
--[[    if level == 1 then
        UIObject = LuaCallCs_FightUI.Create3DUI("Texture/Sprite3d/star1.sprite3d",0,0)
    elseif level == 2 then 
        UIObject = LuaCallCs_FightUI.Create3DUI("Texture/Sprite3d/star2.sprite3d",0,0)
    end
    --关联actorID和3DUI
    UIManager.m_3DUI[actorID] = UIObject
    --让3DUI跟随Actor
    local offset = BluePrint.UGC.UI.Core.Vector3(0,3,0)
    LuaCallCs_FightUI.SetFollowActor(UIObject,actorID,offset)--]]
end


function DropDefendHero(actorID,playerId,star)
	UIManager.DorpHerosPlayer[actorID] = playerId;	
end	

--全局唯一函数 OnTouchDragStart
function OnTouchDragStart(luaUIEvent)
    --获取摄像机当前位置
    curPos = LuaCallCs_FightUI.GetFreeCameraLocation()
end

--全局唯一函数 OnTouchDrag
function OnTouchDrag(luaUIEvent)
	
	local camp = LuaCallCs_Battle.GetHostPlayerCamp()
	local factor = 0.1
	
	if GameDataMgr.FightNum  == GameDataMgr.JueDouIndex then
		if camp == 2 then
			factor = -0.1;
		end
	end

    local delta = BluePrint.UGC.UI.Core.Vector3(luaUIEvent.PointerData.Delta.x * factor, 0, luaUIEvent.PointerData.Delta.y * factor)
    curPos = curPos - delta
    
    --设置摄像机当前位置 (是否要重命名)
    LuaCallCs_FightUI.SetFreeCameraLocation(curPos)

end

--全局唯一函数 OnTouchDragEnd
function OnTouchDragEnd(luaUIEvent)

end

function OnTouchUp(luaUIEvent)--抬起触发
	
	if UIManager.m_isDrag == true then 
		
		CreateActorT.DragEnd(luaUIEvent);
		
		UIManager.m_isDrag = false;
		
	end
end


--全局唯一函数 OnTouchDown
function OnTouchDown(luaUIEvent)

	if GameDataMgr.State ~= 2 then
		return
	end
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
	
	local CIndex = LuaCallCs_GridComponent.GetCellIndexByScreenPos(luaUIEvent.PointerData.Position)
	
    --当移动Actor的时候
    if UIManager.m_isMoving == true then 
         --通过鼠标点击的屏幕坐标获取CellIndex         
        
         --判断格子是否有效
         if LuaCallCs_GridComponent.GetFlagByCellIndex(CIndex) == 0 then return end
         --通过CellIndex获取Cell的世界坐标
         local WorldPos = LuaCallCs_GridComponent.GetCellWorldPosByCellIndex(CIndex)
         --把Vector3转成游戏逻辑需要的VINT3的数据类型
         local Vi3 = LuaCallCs_Util.ConvertVector3ToVInt3(WorldPos)
         --当前点击的格子的CellIndex
         --UIManager.m_curCellIndex = CIndex
         --发送SelectHero事件到HeroDragController(Gamepaly lua)中
	
         local message = {}
		--ovingEnd
         message.f = "M"
         message.c = CIndex
         message.x = Vi3.x
         --message.Y = Vi3.y
         message.z = Vi3.z
		 message.p = selfPlayerInfo.playerID
         --UI Lua中使用json 未来会和gameplay Lua中的Cjson统一
         pass = json.encode(message)
         LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass); 
         UIManager.m_isMoving = false
		
		CreateActorT.MoveEnd();
    --当正常情况下，选中格子时
    elseif UIManager.m_isMoving ~= true then
         --通过鼠标点击的屏幕坐标获取CellIndex
         --当前点击的格子的CellIndex
			
		if UIManager.DefendActorInfo[CIndex] ~= nil then
			UIManager.m_curCellIndex = CIndex
			 --发送SelectHero事件到HeroDragController(Gamepaly lua)中
			 local message = {}
			 message.funcname = "SelectHero"
			 message.CIndex = CIndex
			 message.playerID = selfPlayerInfo.playerID
			 --UI Lua中使用json 未来会和gameplay Lua中的Cjson统一
			 pass = json.encode(message)
			 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass);
		end

	
      
    end
end

--停止拖动状态
function UIManager:StopDragMoving(ID)
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
	if ID == selfPlayerInfo.playerID then
		 UIManager.m_isMoving = false
	end
   
end

function ShowOverGameUI(dieCamp)
	
	LuaCallCs_UI.OpenForm("UI/LanMode/OverGame.uixml");
	
	local camp = LuaCallCs_Battle.GetHostPlayerCamp()
	
	OverGameFormLua.ShowContent(camp == dieCamp);
	
end

function UIManager.SetHostActorPower(num)
	
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
	local camp = LuaCallCs_Battle.GetHostPlayerCamp()
	local message = {}
	message.funcname = "ChangeActorPower"
	message.pn = num
	message.camp = camp
	message.playerID = selfPlayerInfo.playerID
	 --UI Lua中使用json 未来会和gameplay Lua中的Cjson统一
	 pass = json.encode(message)
	 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass);
	
end	

function InitGameInfo(str)
	
	
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
		
	local temp = Util.StringSplit(str, '&')

	for k , v in pairs(temp) do
		
		if  v ~= nil and v ~="" then
			
			local areaInfo = Util.StringSplit(v, '|')
			
	--		LuaCallCs_Common.Log("playerID  ==============================================================="..selfPlayerInfo.playerID );
			
			if selfPlayerInfo.playerID == tonumber(areaInfo[1]) then
				
				UIManager.selfArea = tonumber(areaInfo[2]);
				
			end

		end
	end

	--LuaCallCs_Common.Log("UIManager.selfArea  ==============================================================="..UIManager.selfArea );
	
	local camp = LuaCallCs_Battle.GetHostPlayerCamp()
	
	local camearInfo = Util.CameraDataByCampAreaID(camp,1);
	
	if camearInfo ~= nil then
		
		local curPos = BluePrint.UGC.UI.Core.Vector3(camearInfo.x , camearInfo.y, camearInfo.z)
		
		LuaCallCs_FightUI.SetFreeCameraLocation(curPos)
		
		LuaCallCs_FightUI.SetCameraLens(Util.CameraDepth)
		
	end
	
	mainPlayerForm.OnGameStart();
	

	
	SetGlobalValue();
		
end

function SetGlobalValue()
	
	local message = {}
	message.funcname = "SetGlobalValue"
	message.mpb = GameDataMgr.MaxPowerBasic
	message.mp = GameDataMgr.MaxPower
	 --UI Lua中使用json 未来会和gameplay Lua中的Cjson统一
	 pass = json.encode(message)
	 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass);
	
end	

function UIManager.GetHostActorConfigID()
	local ID = 0;
	local playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
	
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
	
	for i = 1, #playerArr  do
		if selfPlayerInfo.playerID == GameDataMgr.GameData.playerInfos[i].playerID then
			ID  = GameDataMgr.GameData.playerInfos[i].heroID;
			break;
		end
    end
	return tonumber(ID);
	
end	
