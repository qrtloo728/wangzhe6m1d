
local Util = require "Util.lua"

CreateActorT = {};

local dragObj 

local l_panel
local l_list
local Select_panel
local LevelUpButton
 
local CoinText
local PowerText

local RandText

local CancelButton

local hirePanel

local hireList

local hireButton

local BackHireButton

local herosActorTable= {};

local ActorTickTable={};

local herosPlayerTable= {};

local ListNum = 0;

local HeroListNum = 0;

local herosGridTable= {};

local ReadyTimeText 

local ReadyTime  = 0;

local HireMonsterID = {};

function OnCreatActorOpen(LuaUIEvent)
	
	heroHead_self = LuaUIEvent.SrcForm;
	
	dragObj = nil;
	
	l_panel = heroHead_self:GetWidgetProxyByName("Panel(1004)")
    l_list = heroHead_self:GetWidgetProxyByName("List(1006)")
	
	Select_panel = heroHead_self:GetWidgetProxyByName("Panel(1051)")
	Select_panel:SetActive (false);
	LevelUpButton = heroHead_self:GetWidgetProxyByName("Button(1052)")
	
	
	hirePanel = heroHead_self:GetWidgetProxyByName("Panel(1042)")
	hireList = heroHead_self:GetWidgetProxyByName("List(1043)")
	hireButton = heroHead_self:GetWidgetProxyByName("Button(1029)")
	BackHireButton = heroHead_self:GetWidgetProxyByName("Button(1049)")

	CoinText = heroHead_self:GetWidgetProxyByName("TextLabel(1010)")
	PowerText = heroHead_self:GetWidgetProxyByName("TextLabel(1055)")
	
	RandText = heroHead_self:GetWidgetProxyByName("TextLabel(1022)")
	
	ReadyTimeText = heroHead_self:GetWidgetProxyByName("TextLabel(1028)")
	
	CancelButton = heroHead_self:GetWidgetProxyByName("Button(1026)")
	
	CancelButton:SetActive (false);

	RefreshButton = heroHead_self:GetWidgetProxyByName("Button(1026)")
	
	ListNum = l_list:GetElementAmount ();
	
	HeroListNum = Util.GetHeroDataMax()

	if next(GameDataMgr.randT) == nil then
		GameDataMgr.randT =  Util.RandomNum(Util.BaseNum,HeroListNum + Util.BaseNum - 1 ,ListNum);
	end
		
	RandText:GetText():SetContent(tostring(GameDataMgr.RandomCoin))
	
	ReadyTime = GameDataMgr.ReadyTime;
	
	ReadyTimeText:GetText():SetContent(tostring(ReadyTime))
	
--[[	for i = 0, ListNum - 1 do
		
		local heroInfo = LuaCallCs_Data.GetHeroInfo(icon_data[i+1])
		local Img_widget = l_list:GetListElement (i);

		local HeroIconPath = "UGUI/Sprite/Dynamic/BustCircle/"..heroInfo.imagePath ; 
		--LuaCallCs_Common.Log(HeroIconPath);
		--LuaCallCs_Common.Log(heroInfo.heroName);
		  
		Img_widget:GetWidgetProxyByName ("Image(1003)"):GetImage():SetRes(HeroIconPath)

		
	end
	--]]

	InitHeroInfo();
	HireMonsterID ={};
	InitHireInfo();

	if GameDataMgr.FightNum  < GameDataMgr.JueDouIndex  then
		InitDefendActorHeroInfo();
	end

	CoinText:GetText():SetContent(tostring(GameDataMgr.PlayerCoinNum))
	PowerText:GetText():SetContent(tostring(GameDataMgr.PlayerPowerNum))
		
--[[	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()
	LuaCallCs_Common.Log("id ========"..selfPlayerInfo.playerID);
	local p = {};
	p.funcname = "InitPlayeID";
	p.playerID = selfPlayerInfo.playerID;
	passp = json.encode(p)
	LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)--]]
	
--[[	local camp = LuaCallCs_Battle.GetHostPlayerCamp()
	
	if camp == 1 then
		
		LuaCallCs_FightUI.SetFreeCameraLocation(CampOneCamerPos);
		
	else
		
		LuaCallCs_Battle.SetCameraRotateByYAxis(180);
		LuaCallCs_FightUI.SetFreeCameraLocation(CampTwoCamerPos);
		
	end--]]

end




function InitHeroInfo()
	
	for i  = 1, #GameDataMgr.randT do
		
		--LuaCallCs_Common.Log("GameDataMgr.randT[i] ====="..GameDataMgr.randT[i]);
		local heroInfo = LuaCallCs_Data.GetHeroInfo(GameDataMgr.randT[i])
		local Img_widget = l_list:GetListElement (i - 1);
		local HeroIconPath = "UGUI/Sprite/Dynamic/BustCircle/"..heroInfo.imagePath ; 
		--LuaCallCs_Common.Log(HeroIconPath);
		--LuaCallCs_Common.Log(heroInfo.heroName);
		Img_widget:GetWidgetProxyByName ("Image(1003)"):GetImage():SetRes(HeroIconPath)
		
		local heroConfig = Util.GetHeroDataByID(GameDataMgr.randT[i])
		
		Img_widget:GetWidgetProxyByName ("TextLabel(1020)"):GetText():SetContent(tostring(heroConfig.coin))	
		
		Img_widget:GetWidgetProxyByName ("TextLabel(1017)"):GetText():SetContent("")
					
		Img_widget:GetWidgetProxyByName ("Image(1003)"):EnableInput(true)
	
		Img_widget:GetWidgetProxyByName ("Image(1003)"):SetAlpha(1)
		
		ActorTickTable={};
		
	end
	
end

function InitHireInfo()
	
	local hireMonset = Util.GetMonseterHireData();
	LuaCallCs_Common.Log("hireMonset--------"..#hireMonset);
	for i = 1,#hireMonset do
		LuaCallCs_Common.Log("hireMonset[i].id --------"..hireMonset[i].id);
		HireMonsterID[i] = hireMonset[i].id;
		local Img_widget = hireList:GetListElement (i - 1);
		local monsterConfig = Util.GetMonseterDataByID( hireMonset[i].id)
		
		Img_widget:GetWidgetProxyByName ("TextLabel(1050)"):GetText():SetContent(tostring(monsterConfig.award))	
		
		Img_widget:GetWidgetProxyByName ("TextLabel(1047)"):GetText():SetContent(tostring(monsterConfig.award))	
					
		Img_widget:GetWidgetProxyByName ("Image(1045)"):EnableInput(true)

		
	end
	
	hireButton:SetActive (true);
	BackHireButton:SetActive (false);
	hirePanel:SetActive (false);

	
end	

function HireClick()
	hireButton:SetActive (false);
	BackHireButton:SetActive (true);
	hirePanel:SetActive (true);
	l_panel:SetActive (false);
	
	mainPlayerForm.ClickMyHireFight();
end	

function BackHireClick()
	hireButton:SetActive (true);
	BackHireButton:SetActive (false);
	hirePanel:SetActive (false);
	l_panel:SetActive (true);
	mainPlayerForm.ClickMyFight();
end	


function AddCoin(num)
	GameDataMgr.PlayerCoinNum = GameDataMgr.PlayerCoinNum + num;
	CoinText:GetText():SetContent(tostring(GameDataMgr.PlayerCoinNum))
end

function SubCoin(num)
	GameDataMgr.PlayerCoinNum = GameDataMgr.PlayerCoinNum - num;
	CoinText:GetText():SetContent(tostring(GameDataMgr.PlayerCoinNum))
end

function SubPower(num)
	GameDataMgr.PlayerPowerNum = GameDataMgr.PlayerPowerNum - num;
	PowerText:GetText():SetContent(tostring(GameDataMgr.PlayerPowerNum))
end

function AddPower(num)
	GameDataMgr.PlayerPowerNum = GameDataMgr.PlayerPowerNum + num;
	PowerText:GetText():SetContent(tostring(GameDataMgr.PlayerPowerNum))
end
	
--点击"移动"按钮
function MoveBtnClick(luaUIEvent)
    HideSelectHeroUI()
    local message = {}
    message.funcname = "MoveHero"
    message.CIndex = UIManager.m_curCellIndex
    local pass = json.encode(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass)
    --标记Cell为可用状态
    UIManager.m_grid[UIManager.m_curCellIndex] = nil 
    --标记当前为移动英雄状态
    UIManager.m_isMoving = true

	--设置UI透明度
    l_panel:SetAlpha(0.5)
	CancelButton:SetActive (true);
	LuaCallCs_GridComponent.SetVisible(true);

end
	
function SailBtnClick(luaUIEvent)
	
	HideSelectHeroUI();
		
	local heroConfig = Util.GetHeroDataByID(UIManager.DefendActorInfo[UIManager.m_curCellIndex].configID)
	local sailCoin = heroConfig.sellcoin
	AddCoin(sailCoin);

	UIManager.DestroyDefendHero(UIManager.m_curCellIndex);	
	local message = {}
    message.funcname = "SailHero"
    message.CIndex = UIManager.m_curCellIndex
    local pass = json.encode(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass)
    --标记Cell为可用状态
    UIManager.m_grid[UIManager.m_curCellIndex] = nil 
	
end

function LevelUpBtnClick(luaUIEvent)
	
	HideSelectHeroUI();
	
	local heroConfig = Util.GetHeroDataByID(UIManager.DefendActorInfo[UIManager.m_curCellIndex].configID)
	local UpCoin = heroConfig.upcoin
	if GameDataMgr.PlayerCoinNum < UpCoin then
		return
	end
	
	SubCoin(UpCoin);
	
	---------------以后可以通过读表对每个单位升级技能做处理 这里默认是技能2
	local message = {}
    message.funcname = "LevelUPHero"
    message.CIndex = UIManager.m_curCellIndex
	message.Slot = 1
    local pass = json.encode(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass)
	

end
	
	--显示"升级"和"移动"和"出售"按钮
function ShowSelectHeroUI(cellIndex,ID)
	LuaCallCs_Common.Log("cellIndex--------"..cellIndex);
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
	if ID == selfPlayerInfo.playerID then
		if Select_panel:IsActived () then
			Select_panel:SetActive(false)
		else
			local V3pos = LuaCallCs_GridComponent.GetCellWorldPosByCellIndex(cellIndex)
			local V2ScrPos = LuaCallCs_UI.WorldToScreenPos(V3pos)
			local diffX = 80
			local diffY = 60
			local diffX2 = 80
			local diffY2 = 0
			Select_panel:SetActive(true)
			Select_panel:SetScreenPosition(V2ScrPos.x + diffX, V2ScrPos.y + diffY)
			
			if UIManager.DefendActorInfo[cellIndex] ~= nil then
				if UIManager.DefendActorInfo[cellIndex].level >=2 then
					LevelUpButton:SetActive(false)
				else
					LevelUpButton:SetActive(true)
				end
				
			end
			
		end
	end


end



--销毁英雄星级的3DUI
function DestroyStar3DUI(actorID)
    --销毁3DUI
    LuaCallCs_FightUI.Destroy3DUI(UIManager.m_3DUI[actorID])
    UIManager.m_3DUI[actorID] = nil
end


function HideSelectHeroUI()
	if Select_panel ~= nil then
		Select_panel:SetActive(false)
	end
    
end

function CreateActorT.MoveEnd()

	l_panel:SetAlpha(1)
	CancelButton:SetActive (false);
	LuaCallCs_GridComponent.SetVisible(false);

	
end	
	
function FindActorIamge(configID)
	
	local num = l_list:GetElementAmount ();
	
	local imgW = nil;
	
	for i = 0, num - 1 do
		
		local heroInfo = LuaCallCs_Data.GetHeroInfo(GameDataMgr.randT[i+1])
				
		if configID == heroInfo.cfgID then
			
			imgW = l_list:GetListElement (i);
			
			break;
			
		end
				
	end
	
	return imgW;
		
	
end	

function CreateActorT.Tick()
		
		
	for k  , v in pairs(ActorTickTable) do
		
		if k ~= nil then
			
			local imgw = FindActorIamge(k);
		
			if v > 0  then
				
				ActorTickTable[k] = ActorTickTable[k] - 1;
				
			end
			
			--LuaCallCs_Common.Log("timer ========"..v);
			
			if imgw ~= nil then
								
				imgw:GetWidgetProxyByName ("Image(1003)"):SetAlpha((10 - v)/ 10 )
					
				if v == 0 then
					
					imgw:GetWidgetProxyByName ("TextLabel(1017)"):GetText():SetContent("")
					
					imgw:GetWidgetProxyByName ("Image(1003)"):EnableInput(true)
					
					ActorTickTable[k] = nil;
					
				else
				
					imgw:GetWidgetProxyByName ("TextLabel(1017)"):GetText():SetContent(tostring(v))	
	
				end
				
				
			end
			
		

		end
		
	end
	
	if ReadyTime > 0  then
		
		ReadyTime = ReadyTime - 1;
		ReadyTimeText:GetText():SetContent(tostring(ReadyTime))
			
	end
	
	if PowerText ~= nil then
		PowerText:GetText():SetContent(tostring(GameDataMgr.PlayerPowerNum))
	end
	
	
end

function CreateHireMonster (luaUIEvent)
	
	local Img_widget = luaUIEvent.SrcWidget
	   --获取头像图片在ElementList中的序号
    local index =  Img_widget:GetIndexInBelongedList() 
	LuaCallCs_Common.Log("index ========"..index);  
	local monsterConfig = Util.GetMonseterDataByID(HireMonsterID[index+1])
	
	if GameDataMgr.PlayerPowerNum < tonumber(monsterConfig.award) then
		return
	end
	
	SubPower(monsterConfig.award);
	
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()		
	local camp = LuaCallCs_Battle.GetHostPlayerCamp()
	local message = {}
	message.funcname = "CreateHire"
	message.id = HireMonsterID[index+1]
	message.pd = selfPlayerInfo.playerID
	message.area = UIManager.selfArea
	message.camp = camp;
	passp = json.encode(message); 
	LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp);

	
end	


function BeginHoldHead (luaUIEvent)
	

	local Img_widget = luaUIEvent.SrcWidget
	   --获取头像图片在ElementList中的序号
    local index =  Img_widget:GetIndexInBelongedList()   
	local heroConfig = Util.GetHeroDataByID(GameDataMgr.randT[index+1])

	if GameDataMgr.PlayerCoinNum < tonumber(heroConfig.coin) then
--[[			LuaCallCs_UI.OpenForm("UI/LanMode/TipUI.uixml");
		local p = {};
		p.funcname = "OpenTips";
		p.content = "Lack of gold coins";
		passp = json.encode(p)
		LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
		 LuaCallCs_GridComponent.ResetAllCellColor()--]]
		return;
	end
				

    --创建拖拽物体(DragObject)的数据
    local initParam = LuaCallCs_FightUI.DragFollowObjInitParam()
    --设置物体对应的CfgID (通过index在icon_data中取值)
    initParam.cfgId = GameDataMgr.randT[index+1]
    --设置物体的actorType
	initParam.actorType = 0
    --通过数据创建正式的拖拽物体
    dragObj = LuaCallCs_FightUI.CreateDragObject(initParam)
    --设置拖拽物体到屏幕鼠标的位置
    LuaCallCs_FightUI.SetDragObjectScreenPos(dragObj, luaUIEvent.PointerData.Position)
    --设置Start颜色
    local color =  BluePrint.UGC.UI.Core.Color(1,0,0,0.5)
    --设置End颜色
    local colorTo = BluePrint.UGC.UI.Core.Color(1,0,0,1)
    --开启拖动时特效
    LuaCallCs_FightUI.StartDragEffect(dragObj,color, colorTo, 1, true)
	
	UIManager.m_isDrag = true;
	
	currentDragWidget = Img_widget;
	
	--设置UI透明度
    l_panel:SetAlpha(0.5)
	
	CancelButton:SetActive (true);
	
	LuaCallCs_GridComponent.SetVisible(true);

end	

function CreateActorT.DragEnd(luaUIEvent)
	EndHoldHead(luaUIEvent);
	CancelButton:SetActive (false);
	LuaCallCs_GridComponent.SetVisible(false);
end	


function cancelClick(luaUIEvent)
	
	currentDragWidget = nil;
	
	ResetDragData();

end

function ResetDragData()
	
	UIManager.m_isDrag = false;
	
	if dragObj ~= nil then
		LuaCallCs_FightUI.DestroyDragFollowObject(dragObj)	
	end
	
	dragObj = nil

	l_panel:SetAlpha(1)
	
	CancelButton:SetActive (false);
	
	LuaCallCs_GridComponent.SetVisible(false);
	
	if UIManager.m_isMoving then
		
		local message = {}
		message.funcname = "MoveFail"
		message.CIndex = UIManager.m_curCellIndex
		local pass = json.encode(message)
		LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass)
		--标记Cell为可用状态
		UIManager.m_grid[UIManager.m_curCellIndex] = {} 
		
		UIManager.m_isMoving = false;
	end


end	

function EndHoldHead (luaUIEvent)
	
		ResetDragData();
		
		--local Img_widget = luaUIEvent.SrcWidget
		
		local Img_widget = currentDragWidget
		
		local index =  Img_widget:GetIndexInBelongedList()   
		
		--local index = currentDragIndex;

		--通过屏幕坐标获取CellIdex
		local CIndex = LuaCallCs_GridComponent.GetCellIndexByScreenPos(luaUIEvent.PointerData.Position)
				
			 --判断Grid是否可用
			--判断格子是否可用的flag


		if UIManager.m_grid[CIndex] == nil and LuaCallCs_GridComponent.GetFlagByCellIndex(CIndex) == 1  then
			--获取头像图片在ElementList中的序号
				
			  --静止输入监听
			Img_widget:EnableInput(false)
			--设置UI资源为X
		   -- Img_widget:GetImage():SetRes("Texture/Sprite/Empty.sprite")
			--标记Icon状态
			Img_widget:SetAlpha(0)
			--icon_state[index+1] = 0
			--标记Grid已经被占用
			UIManager.m_grid[CIndex] = {}
			--重置所有Cell的颜色
			LuaCallCs_GridComponent.ResetAllCellColor()
			--通过CellIndex获取世界坐标
			local WorldPos = LuaCallCs_GridComponent.GetCellWorldPosByCellIndex(CIndex)
			--把Vector3转成逻辑能使用的VInt3
			local Vi3 = LuaCallCs_Util.ConvertVector3ToVInt3(WorldPos)
			--获取一排的格子数量
			local widthNum = LuaCallCs_GridComponent.GetGridInfo().CellCount
			--发送事件到HeroDragController(Gameplay lua)中
			
			local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()
			--LuaCallCs_Common.Log("id ========"..selfPlayerInfo.playerID);
			local camp = LuaCallCs_Battle.GetHostPlayerCamp()
			--LuaCallCs_Common.Log("camp ========"..camp);
			LuaCallCs_Common.Log("CIndex =============="..CIndex); 
		
	--[[					
			local ActorID = LuaCallCs_Battle.GetHostActorID();
			LuaCallCs_Common.Log("ActorID ========"..ActorID);--]]
			local posInfo = tostring(math.floor(WorldPos.x)).."|"..tostring(math.floor(WorldPos.z));
		
	
			CreateActorT.CreatDefendHeroActor(CIndex, GameDataMgr.randT[index+1],camp,posInfo,1,UIManager.selfArea);
			
			UIManager.CreateDefendHeroActor(CIndex,GameDataMgr.randT[index+1],camp,posInfo,1,UIManager.selfArea);
			
			local heroConfig = Util.GetHeroDataByID(GameDataMgr.randT[index+1])
			SubCoin(tonumber(heroConfig.coin));	
			ActorTickTable[GameDataMgr.randT[index+1]] = 1;
	
		elseif UIManager.m_grid[CIndex] ~= nil then
		
		end
			
	
end	

function InitDefendActorHeroInfo()
	
	for k , v in pairs(UIManager.DefendActorInfo) do		
		if v ~= nil then
			CreateActorT.CreatDefendHeroActor(k,v.configID,v.camp,v.posInfo,v.level,UIManager.selfArea);
		end
	end
	
end	

function CreateActorT.CreatDefendHeroActor (girdIndex,configID,camp,posInfo,level,area)
				
		local m = {}
		m.f = "C"
		m.d = configID
		m.p = posInfo
		m.c = camp;
		m.g = girdIndex;
		m.l = level;
		m.a = area;
		local p = json.encode(m); 
		LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(p);
end	



function BeginDragHead  (luaUIEvent)
	--LuaCallCs_Common.Log("BeginDragHead---------- ========");
	BeginHoldHead(luaUIEvent);
end	


function EndDragHead  (luaUIEvent)
	--LuaCallCs_Common.Log("EndDragHead---------- ========");
end	


function SetOnDragEvent  (luaUIEvent)
	
	   --判断是否已经创建DragObject  
    if dragObj ~= nil then	
        --把屏幕坐标实时的设置给DragObject
		LuaCallCs_FightUI.SetDragObjectScreenPos(dragObj, luaUIEvent.PointerData.Position)	

		 --通过屏幕坐标获取对应格子的CellIndex
		local CIndex = LuaCallCs_GridComponent.GetCellIndexByScreenPos(luaUIEvent.PointerData.Position);
		--重置所有格子的颜色信息
		LuaCallCs_GridComponent.ResetAllCellColor()
			
		--LuaCallCs_Common.Log("CIndex ========"..CIndex);	
		--获取UIManger中的保存的格子是否被占用的信息
		if UIManager.m_grid[CIndex] == nil then

			--未被占用显示绿色
			--LuaCallCs_GridComponent.SetCellColorByCellIndex(CIndex, BluePrint.UGC.UI.Core.Color(0,1,0,0.5))
		
		--判断Grid是否可用
		--判断格子是否可用的flag
		elseif UIManager.m_grid[CIndex] ~= nil or LuaCallCs_GridComponent.GetFlagByCellIndex(CIndex) == 0 then
			--被占用了显示红色
			--LuaCallCs_GridComponent.SetCellColorByCellIndex(CIndex, BluePrint.UGC.UI.Core.Color(1,0,0,0.5))
		end
		
    end
	

	
end


function OnCreatActorClose(LuaUIEvent)
	
		
	
end




function GetHeroGirdIndex(actorID)

--[[	local p = {};
	p.funcname = "GetActorScreenPos";
	p.actorID = actorID;
	passp = json.encode(p)
	LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)--]]

end	


function BPToGetActorScreenPos(x,y,z)
		
		local screenPos =  LuaCallCs_UI.WorldToScreenPos(BluePrint.UGC.UI.Core.Vector3(x,y,z));
		
		local CIndex = LuaCallCs_GridComponent.GetCellIndexByScreenPos( screenPos )

		
end


function BPToGetActorsScreenPos(indexClick,arrayData)
		
	
	local SelectActorID = 0;
	
	for i = 1 ,  #arrayData  do

		local temp = Util.StringSplit(arrayData[i], '|')
		
		local vT = BluePrint.UGC.UI.Core.Vector3(tonumber(temp[1])/1000,tonumber(temp[2])/1000,tonumber(temp[3])/1000);
	
		local index = LuaCallCs_GridComponent.GetCellIndexByWorldPos(vT)
		
		if index == indexClick then
			SelectActorID = tonumber(temp[4]);
			break;
		end
			
	end
	
	if SelectActorID ~= 0 then
		LuaCallCs_Common.Log("SelectActorID ========"..SelectActorID);
	end
	

		
end

--获取单位首次排阵位置
function SelectStartPosActor(clickIndex)
	
	
	local actorID = herosGridTable[clickIndex];
	if actorID ~= nil then
		LuaCallCs_Common.Log("SelectActorStartID ========"..actorID);
	end
	
	
	
end

--获取单位实时排阵位置
function SelectPosActor(clickIndex)
	
	
	local ActorIDT = {};
	for k ,  v in pairs(herosActorTable) do
		table.insert(ActorIDT,k)
	end
	
	--LuaCallCs_Common.Log("ActorIDT ========"..#ActorIDT);
	
	local p = {};
	p.funcname = "CompairActorScreenPos";
	p.CIndex = clickIndex;
	p.Actors = ActorIDT;
	passp = json.encode(p)
	LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
	
	
	
end


function OnOverFight(LuaUIEvent)
	
	
	
end


function OnrandClick(LuaUIEvent)
	
	if GameDataMgr.PlayerCoinNum < GameDataMgr.RandomCoin then
--[[		LuaCallCs_UI.OpenForm("UI/LanMode/TipUI.uixml");
		local p = {};
		p.funcname = "OpenTips";
		p.content = "Lack of gold coins";
		passp = json.encode(p)
		LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)	--]]
		return;
	end
	--防止连续两次随机一样
	for i = 1, 100 do
		local newRandT =  Util.RandomNum(Util.BaseNum,HeroListNum + Util.BaseNum - 1 ,ListNum);
		local state = Util.CompairTableEquil(GameDataMgr.randT,newRandT);
		if not state then
			GameDataMgr.randT = newRandT;
			SubCoin(GameDataMgr.RandomCoin);	
			InitHeroInfo();
			break;
		end
		
	end	
	GameDataMgr.RandomCoin = GameDataMgr.RandomCoin + GameDataMgr.AddRandom;
	RandText:GetText():SetContent(tostring(GameDataMgr.RandomCoin))
	
end





return CreateActorT