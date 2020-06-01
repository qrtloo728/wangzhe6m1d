
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
	
--���"�ƶ�"��ť
function MoveBtnClick(luaUIEvent)
    HideSelectHeroUI()
    local message = {}
    message.funcname = "MoveHero"
    message.CIndex = UIManager.m_curCellIndex
    local pass = json.encode(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass)
    --���CellΪ����״̬
    UIManager.m_grid[UIManager.m_curCellIndex] = nil 
    --��ǵ�ǰΪ�ƶ�Ӣ��״̬
    UIManager.m_isMoving = true

	--����UI͸����
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
    --���CellΪ����״̬
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
	
	---------------�Ժ����ͨ�������ÿ����λ�������������� ����Ĭ���Ǽ���2
	local message = {}
    message.funcname = "LevelUPHero"
    message.CIndex = UIManager.m_curCellIndex
	message.Slot = 1
    local pass = json.encode(message)
    LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(pass)
	

end
	
	--��ʾ"����"��"�ƶ�"��"����"��ť
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



--����Ӣ���Ǽ���3DUI
function DestroyStar3DUI(actorID)
    --����3DUI
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
	   --��ȡͷ��ͼƬ��ElementList�е����
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
	   --��ȡͷ��ͼƬ��ElementList�е����
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
				

    --������ק����(DragObject)������
    local initParam = LuaCallCs_FightUI.DragFollowObjInitParam()
    --���������Ӧ��CfgID (ͨ��index��icon_data��ȡֵ)
    initParam.cfgId = GameDataMgr.randT[index+1]
    --���������actorType
	initParam.actorType = 0
    --ͨ�����ݴ�����ʽ����ק����
    dragObj = LuaCallCs_FightUI.CreateDragObject(initParam)
    --������ק���嵽��Ļ����λ��
    LuaCallCs_FightUI.SetDragObjectScreenPos(dragObj, luaUIEvent.PointerData.Position)
    --����Start��ɫ
    local color =  BluePrint.UGC.UI.Core.Color(1,0,0,0.5)
    --����End��ɫ
    local colorTo = BluePrint.UGC.UI.Core.Color(1,0,0,1)
    --�����϶�ʱ��Ч
    LuaCallCs_FightUI.StartDragEffect(dragObj,color, colorTo, 1, true)
	
	UIManager.m_isDrag = true;
	
	currentDragWidget = Img_widget;
	
	--����UI͸����
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
		--���CellΪ����״̬
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

		--ͨ����Ļ�����ȡCellIdex
		local CIndex = LuaCallCs_GridComponent.GetCellIndexByScreenPos(luaUIEvent.PointerData.Position)
				
			 --�ж�Grid�Ƿ����
			--�жϸ����Ƿ���õ�flag


		if UIManager.m_grid[CIndex] == nil and LuaCallCs_GridComponent.GetFlagByCellIndex(CIndex) == 1  then
			--��ȡͷ��ͼƬ��ElementList�е����
				
			  --��ֹ�������
			Img_widget:EnableInput(false)
			--����UI��ԴΪX
		   -- Img_widget:GetImage():SetRes("Texture/Sprite/Empty.sprite")
			--���Icon״̬
			Img_widget:SetAlpha(0)
			--icon_state[index+1] = 0
			--���Grid�Ѿ���ռ��
			UIManager.m_grid[CIndex] = {}
			--��������Cell����ɫ
			LuaCallCs_GridComponent.ResetAllCellColor()
			--ͨ��CellIndex��ȡ��������
			local WorldPos = LuaCallCs_GridComponent.GetCellWorldPosByCellIndex(CIndex)
			--��Vector3ת���߼���ʹ�õ�VInt3
			local Vi3 = LuaCallCs_Util.ConvertVector3ToVInt3(WorldPos)
			--��ȡһ�ŵĸ�������
			local widthNum = LuaCallCs_GridComponent.GetGridInfo().CellCount
			--�����¼���HeroDragController(Gameplay lua)��
			
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
	
	   --�ж��Ƿ��Ѿ�����DragObject  
    if dragObj ~= nil then	
        --����Ļ����ʵʱ�����ø�DragObject
		LuaCallCs_FightUI.SetDragObjectScreenPos(dragObj, luaUIEvent.PointerData.Position)	

		 --ͨ����Ļ�����ȡ��Ӧ���ӵ�CellIndex
		local CIndex = LuaCallCs_GridComponent.GetCellIndexByScreenPos(luaUIEvent.PointerData.Position);
		--�������и��ӵ���ɫ��Ϣ
		LuaCallCs_GridComponent.ResetAllCellColor()
			
		--LuaCallCs_Common.Log("CIndex ========"..CIndex);	
		--��ȡUIManger�еı���ĸ����Ƿ�ռ�õ���Ϣ
		if UIManager.m_grid[CIndex] == nil then

			--δ��ռ����ʾ��ɫ
			--LuaCallCs_GridComponent.SetCellColorByCellIndex(CIndex, BluePrint.UGC.UI.Core.Color(0,1,0,0.5))
		
		--�ж�Grid�Ƿ����
		--�жϸ����Ƿ���õ�flag
		elseif UIManager.m_grid[CIndex] ~= nil or LuaCallCs_GridComponent.GetFlagByCellIndex(CIndex) == 0 then
			--��ռ������ʾ��ɫ
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

--��ȡ��λ�״�����λ��
function SelectStartPosActor(clickIndex)
	
	
	local actorID = herosGridTable[clickIndex];
	if actorID ~= nil then
		LuaCallCs_Common.Log("SelectActorStartID ========"..actorID);
	end
	
	
	
end

--��ȡ��λʵʱ����λ��
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
	--��ֹ�����������һ��
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