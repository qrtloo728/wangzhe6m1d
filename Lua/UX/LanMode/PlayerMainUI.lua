
local Util = require "Util.lua"
--local GameDataMgr = require"OnlineMode/G_GameDataMgr.lua"

local PlayerMainUIT = {};
local CoinText
local Friend1Button
local Friend2Button
local Friend3Button
local Friend4Button
local Enemy1Button
local Enemy2Button
local Enemy3Button
local Enemy4Button

local HeadIcon
local FightNum
local FightState
local textTab1
local textTab2
local powerText

local ZhuFuButton
local XiuFuButton
local ZhuanShuButton

local ZhuFuCDText
local XiuFuCDText
local ZhuanShuCDText

local PrepareTime = 0; ------准备时间
local ReadySoonTime = 0 ------即将准备倒计时
local FightTime = 0;

local DefendSuccess = {};
local SkillIDTextT = {};


function OnPlayerMainOpen(LuaUIEvent)
	
	PlayerMain_self = LuaUIEvent.SrcForm;
		
	Friend1Button = PlayerMain_self:GetWidgetProxyByName("Button(1002)")
	Friend2Button = PlayerMain_self:GetWidgetProxyByName("Button(1003)")
	Friend3Button = PlayerMain_self:GetWidgetProxyByName("Button(1004)")
	Friend4Button = PlayerMain_self:GetWidgetProxyByName("Button(1005)")
	
	Enemy1Button = PlayerMain_self:GetWidgetProxyByName("Button(1006)")
	Enemy2Button = PlayerMain_self:GetWidgetProxyByName("Button(1007)")
	Enemy3Button = PlayerMain_self:GetWidgetProxyByName("Button(1008)")
	Enemy4Button = PlayerMain_self:GetWidgetProxyByName("Button(1009)")
	
	HeadIcon =  PlayerMain_self:GetWidgetProxyByName("Image(1010)")
	CoinText = PlayerMain_self:GetWidgetProxyByName("TextLabel(1011)")
	powerText = PlayerMain_self:GetWidgetProxyByName("TextLabel(1025)")
	
	FightNum = PlayerMain_self:GetWidgetProxyByName("TextLabel(1013)")
	FightState = PlayerMain_self:GetWidgetProxyByName("TextLabel(1014)")
	
	textTab1 = PlayerMain_self:GetWidgetProxyByName("TextLabel(1017)")
	textTab2 = PlayerMain_self:GetWidgetProxyByName("TextLabel(1018)")
	textTab1:SetActive (true);
	textTab2:SetActive (false);
	
	
	ZhuFuButton = PlayerMain_self:GetWidgetProxyByName("Button(1027)")
	XiuFuButton = PlayerMain_self:GetWidgetProxyByName("Button(1026)")
	ZhuanShuButton = PlayerMain_self:GetWidgetProxyByName("Button(1028)")
	ZhuFuButton:SetActive (false);
	XiuFuButton:SetActive (false);
	ZhuanShuButton:SetActive (false);
	
	ZhuFuCDText = PlayerMain_self:GetWidgetProxyByName("TextLabel(1029)")
	XiuFuCDText = PlayerMain_self:GetWidgetProxyByName("TextLabel(1030)")
	ZhuanShuCDText = PlayerMain_self:GetWidgetProxyByName("TextLabel(1031)")
	ZhuFuCDText:SetActive (false);
	XiuFuCDText:SetActive (false);
	ZhuanShuCDText:SetActive (false);
	
	
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	

	local actorConfigID = UIManager.GetHostActorConfigID()	
	local heroInfo = LuaCallCs_Data.GetHeroInfo(actorConfigID)
	local HeroIconPath = "UGUI/Sprite/Dynamic/BustCircle/"..heroInfo.imagePath ; 
	HeadIcon:GetImage():SetRes(HeroIconPath)


	RefreshHeroCoin();
	
	InitHeroSkillInfo(GameDataMgr.State == 3);
	--
	
end

function InitHeroSkillInfo(state)
	
	ZhuFuButton:SetActive (state);
	XiuFuButton:SetActive (state);
	ZhuanShuButton:SetActive (state);
	ZhuFuCDText:SetActive (state);
	XiuFuCDText:SetActive (state);
	ZhuanShuCDText:SetActive (state);
	SkillIDTextT = {};
	ZhuFuCDText:GetText():SetContent("")
	XiuFuCDText:GetText():SetContent("")
	ZhuanShuCDText:GetText():SetContent("")
	SkillIDTextT[60001] = ZhuFuCDText;
	SkillIDTextT[60002] = XiuFuCDText;
	SkillIDTextT[60003] = ZhuanShuCDText;
	
end	

function PlayerMainUIT.OnGameStart()
		
		GameDataMgr.FightNum = GameDataMgr.FightNum + 1;	
		ChangeBpGameState(1)
	
end


function ChangeBpGameState(state)

	GameDataMgr.State = state;
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	
	if GameDataMgr.FightNum  < GameDataMgr.JueDouIndex then
		setCameraInfo(selfCamp,1)
	end
	
	--LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(4,"",false)
	--LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(8,"",false)

	LuaCallCs_Common.Log("GameDataMgr.FightNum  --------------------------------------"..GameDataMgr.FightNum );

	if state == 1 then
		FightNum:GetText():SetContent(tostring(GameDataMgr.FightNum))
		ReadySoonTime = GameDataMgr.ReadySoonTime 
		textTab1:SetActive (true);
		textTab2:SetActive (false);
		DefendSuccess = {};
		RefreshHeroCoin();
			
		
	elseif 	state == 2 then
		
		PrepareTime = GameDataMgr.ReadyTime;
		textTab1:SetActive (false);
		textTab2:SetActive (false);
		ReadySoonTime = 0;
		LuaCallCs_UI.CloseForm("UI/LanMode/PlayerMainUI.uixml")
		LuaCallCs_UI.OpenForm("UI/LanMode/CreateActorUI.uixml");
		
		----------------------------------------机器人行为
		local juedou = 0;	
		if GameDataMgr.FightNum  == GameDataMgr.JueDouIndex then
			juedou = 1;
		end
		local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
		local k = {};
		k.funcname = "CRDef";
		k.IsJueDou = juedou
		k.playerID = selfPlayerInfo.playerID
		local passp = json.encode(k)
		LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
		


	elseif 	state == 3 then

		LuaCallCs_UI.CloseForm("UI/LanMode/CreateActorUI.uixml");
		LuaCallCs_UI.OpenForm("UI/LanMode/PlayerMainUI.uixml")

		FightTime = GameDataMgr.FightTime;
		FightNum:GetText():SetContent(tostring(GameDataMgr.FightNum))
		textTab1:SetActive (false);
		textTab2:SetActive (true);
		RefreshHeroCoin();
		if GameDataMgr.FightNum  < GameDataMgr.JueDouIndex then
			
			local MonseterInfo = Util.GetMonseterDataByIndex(GameDataMgr.FightNum);
	
			if MonseterInfo ~= nil then
				
				local p = {};
				p.f = "GF";
				p.id = MonseterInfo.id;
				p.n = MonseterInfo.count;
				p.a = MonseterInfo.attack
				p.d = MonseterInfo.def
				local passp = json.encode(p)
				LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
				
			end
		end
		
		local k = {};
		k.funcname = "StartFight";
		local passp = json.encode(k)
		LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
		
	
	end
	
		
--[[	if GameDataMgr.FightNum  < GameDataMgr.JueDouIndex then
		
		local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
		 local p = {};
		 p.funcname = "TeleportControlActor";
		 local passp = json.encode(p)
		 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
		
	end	
	--]]
		
end	



function NextLun()
		
	LuaCallCs_Common.Log("NextLun  --------------------------------------"..GameDataMgr.FightNum );	
	if GameDataMgr.State  == 3 then 
		GameDataMgr.PlayerCoinNum = GameDataMgr.PlayerCoinNum  + 20
		ClickFriendOne()
		GameDataMgr.FightNum = GameDataMgr.FightNum + 1;
		FightNum:GetText():SetContent(tostring(GameDataMgr.FightNum))
		ChangeBpGameState(1)
		if GameDataMgr.FightNum == GameDataMgr.JueDouIndex then
			GoToJueDou();
			setCameraInfo(0,0)
			
			local camp = LuaCallCs_Battle.GetHostPlayerCamp()
			if camp == 2 then
				
				LuaCallCs_Battle.SetCameraRotateByYAxis(180);
				
			end
		end
		
	end
	
	
end	


function clickKuaiSuXiuFu()
	if GameDataMgr.SkillCDTable[60002] ~= nil and GameDataMgr.SkillCDTable[60002] > 0 then
		return
	end
	local skillInfo = Util.GetHeroSkillDataByID(60002) 
	if skillInfo ~= nil then
		if skillInfo.expendmp <= GameDataMgr.PlayerPowerNum then
			
			GameDataMgr.SkillCDTable[60002] = skillInfo.cdtime;
			local camp = LuaCallCs_Battle.GetHostPlayerCamp()
			 local p = {};
			 p.funcname = "KuaiSuXiuFuSkill";
			 p.camp = camp;
			 p.addHp = skillInfo.addhp;
			 local passp = json.encode(p)
			 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
			--todo
			RefreshHeroSkill()
			GameDataMgr.PlayerPowerNum = GameDataMgr.PlayerPowerNum - skillInfo.expendmp;
			RefreshHeroPower()
		end
		
	
	end
	
end	

function clickShuiJingZhuFu()
	if GameDataMgr.SkillCDTable[60001] ~= nil and GameDataMgr.SkillCDTable[60001] > 0 then
		return
	end
	local skillInfo = Util.GetHeroSkillDataByID(60001) 
	if skillInfo ~= nil then
		if skillInfo.expendmp <= GameDataMgr.PlayerPowerNum then
			GameDataMgr.SkillCDTable[60001] = skillInfo.cdtime;
			local camp = LuaCallCs_Battle.GetHostPlayerCamp()
			--todo
			 local p = {};
			 p.funcname = "ShuiJinZhuFuSkill";
			 p.camp = camp;
			 p.uplevel = skillInfo.uplevel
			 local passp = json.encode(p)
			 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
			 RefreshHeroSkill()
			GameDataMgr.PlayerPowerNum = GameDataMgr.PlayerPowerNum - skillInfo.expendmp;
			RefreshHeroPower()
		end
		
	end

end	


function clickZhuanShuJiNeng()
	if GameDataMgr.SkillCDTable[60003] ~= nil and GameDataMgr.SkillCDTable[60003] > 0 then
		return
	end
	local skillInfo = Util.GetHeroSkillDataByID(60003) 
	if skillInfo ~= nil then
		if skillInfo.expendmp <= GameDataMgr.PlayerPowerNum then
			GameDataMgr.SkillCDTable[60003] = skillInfo.cdtime;
			local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
			local p = {};
			 p.funcname = "ZhuanShuJiNengSkill";
			 p.camp = camp;
			 p.playerID = selfPlayerInfo.playerID
			 local passp = json.encode(p)
			 LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
			 RefreshHeroSkill()
			GameDataMgr.PlayerPowerNum = GameDataMgr.PlayerPowerNum - skillInfo.expendmp;
			RefreshHeroPower()
		end
	
		--todo
	end

end	


function PlayerMainUIT.Tick()
	
	
		if GameDataMgr.State == 1 then
					
			if ReadySoonTime > 0  then
			
				ReadySoonTime = ReadySoonTime  - 1;
				FightState:GetText():SetContent(tostring(ReadySoonTime))
				if ReadySoonTime == 0 then

					ChangeBpGameState(2)
					
				end
				
			end
			
		elseif  GameDataMgr.State == 2 then
			
			if PrepareTime > 0  then
				
				PrepareTime = PrepareTime - 1;
				if PrepareTime == 0 then
					ChangeBpGameState(3)
				end
				
			end
			
		
		elseif  GameDataMgr.State == 3 then
			
			if FightTime > 0  then
				FightTime = FightTime  - 1;
				FightState:GetText():SetContent(tostring(FightTime))
				if FightTime == 0 then
					CheckDefend();
				end
				
			end
		end
		
		GameDataMgr.PlayerPowerNum = GameDataMgr.PlayerPowerNum  + GameDataMgr.AddPowerNumPerSec;
		UIManager.SetHostActorPower(GameDataMgr.PlayerPowerNum)
		RefreshHeroPower();
		
		RefreshHeroSkill();
		
end

function RefreshHeroSkill()
	
	for k , v  in pairs(GameDataMgr.SkillCDTable) do
		
		if k ~= nil and v > 0 then
			GameDataMgr.SkillCDTable[k] = GameDataMgr.SkillCDTable[k] - 1;
			if GameDataMgr.SkillCDTable[k] > 0 then
				SkillIDTextT[k]:GetText():SetContent(tostring(GameDataMgr.SkillCDTable[k]));
			else
				SkillIDTextT[k]:GetText():SetContent("");
			end
			
		end
		
	end
	
end	

function setCameraInfo(camp,Index)
		
	local camearInfo = Util.CameraDataByCampAreaID(camp,Index);
	
	if camearInfo ~= nil then

		local curPos = BluePrint.UGC.UI.Core.Vector3(camearInfo.x , camearInfo.y, camearInfo.z)
		
		LuaCallCs_FightUI.SetFreeCameraLocation(curPos)
		
		LuaCallCs_FightUI.SetCameraLens(Util.CameraDepth)
		
	end
	
end	



function GoToJueDou()
	
	local p = {};
	p.funcname = "TeleportToJueDou";
	local passp = json.encode(p)
	LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
	
end	


function TeleportMonsterToHome()
	
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
	local p = {};
	p.funcname = "TeleportToHome";
	p.camp = selfCamp;
	p.area = UIManager.selfArea;
	p.playerID = selfPlayerInfo.playerID
	local passp = json.encode(p)
	LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
	LuaCallCs_Common.Log("TeleportMonster --------------------------------------");
	ClickSelfHome();
end	

function CheckDefend()
	
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
	
	LuaCallCs_Common.Log("CheckDefend --------------------------------------");
	
	if not next(UIManager.DefendActorInfo) then
		----没有防守方
		TeleportMonsterToHome()
	end
end
	


function ChangeLuaGameState(state)
	
	
	LuaCallCs_Common.Log("ChangeLuaGameState --------------------------------------"..state);
	if state == 1 then
	
		ReadySoonTime = GameDataMgr.ReadySoonTime 
		textTab1:SetActive (true);
		textTab2:SetActive (false);
		DefendSuccess = {};
		RefreshHeroCoin();
			
		
	elseif 	state == 2 then
		
		--	PrepareTime = GameDataMgr.ReadyTime;
		local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
		setCameraInfo(selfCamp,1)
		textTab1:SetActive (false);
		textTab2:SetActive (false);
		
		ReadySoonTime = 0;
		setCameraInfo(true,1)

	elseif 	state == 3 then
		
		local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
		setCameraInfo(selfCamp,1)
		FightTime = GameDataMgr.FightTime;
		FightNum:GetText():SetContent(tostring(GameDataMgr.FightNum))
		textTab1:SetActive (false);
		textTab2:SetActive (true);
		RefreshHeroCoin();
	
	end

end	


-------------选手某轮对局结束，state 1 ,成功，0 失败
function OnePlayerOverFightGameState(camp,area,state)
	
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	
	if state == 1 then
		
		DefendSuccess[camp] = area;
		if camp  == selfCamp then
			--DefendButton:SetActive (true);
			--Defend();
		end
			
	end

	--LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(4,"",true)
	--LuaCallCs_UI.EnableUnitInBuiltinBattleUIForm(8,"",true)

	
	
end	

function KillMonster(ActorID,montserID)

	        
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()	
	
	if tonumber(UIManager.DorpHerosPlayer[ActorID]) == tonumber(selfPlayerInfo.playerID) then

		local monsterData = Util.GetMonseterDataByID(montserID)
		GameDataMgr.PlayerCoinNum = GameDataMgr.PlayerCoinNum + monsterData.award;
		RefreshHeroCoin();
		
	end
	
	
end	

function RefreshHeroCoin()
	CoinText:GetText():SetContent(tostring(GameDataMgr.PlayerCoinNum))
end	

function RefreshHeroPower()
	powerText:GetText():SetContent(tostring(GameDataMgr.PlayerPowerNum ))
end	


function PlayerMainUIT.ClickMyFight()
	ClickFriendOne();
end

function PlayerMainUIT.ClickMyHireFight()
	ClickFriendAssitant();
end


function ClickFriendOne()
	
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	setCameraInfo(selfCamp,1)
end	

function ClickFriendTwo()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	setCameraInfo(selfCamp,2)
end	

function ClickFriendThree()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	setCameraInfo(selfCamp,3)
end	

function ClickFriendFour()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	setCameraInfo(selfCamp,4)
end	

function ClickSelfHome()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	setCameraInfo(selfCamp,5)
end	


function ClickFriendAssitant()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	setCameraInfo(selfCamp,6)
end	

function ClickEnemyOne()
	
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	
	if selfCamp == 1 then
		setCameraInfo(2,1)
	else
		setCameraInfo(1,1)
	end

end	

function ClickEnemyTwo()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	if selfCamp == 1 then
		setCameraInfo(2,2)
	else
		setCameraInfo(1,2)
	end
end	

function ClickEnemyThree()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	if selfCamp == 1 then
		setCameraInfo(2,3)
	else
		setCameraInfo(1,3)
	end
end	

function ClickEnemyFour()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	if selfCamp == 1 then
		setCameraInfo(2,4)
	else
		setCameraInfo(1,4)
	end
end	

function ClickEnemyAssitant()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	if selfCamp == 1 then
		setCameraInfo(2,6)
	else
		setCameraInfo(1,6)
	end
end	


function ClickEnemyHome()
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	if selfCamp == 1 then
		setCameraInfo(2,5)
	else
		setCameraInfo(1,5)
	end
end	


function LookSelfHome(playerID,camp,area)
	
	local selfPlayerInfo = LuaCallCs_UGCStateDriver.GetSelfPlayerInfo()		
	if playerID == selfPlayerInfo.playerID then
		ClickSelfHome()
	end
	
end	




function ClickPVPHome()
	setCameraInfo(0,0)
end	

function Defend()
	
	local selfCamp = LuaCallCs_Battle.GetHostPlayerCamp()
	local area =  DefendSuccess[selfCamp] ;
	
	local p = {};
	p.funcname = "GoToDefend";
	p.camp = selfCamp;
	p.area = area;
	local passp = json.encode(p)
	LuaCallCs_UGCStateDriver.SendCustomizeFrameCmd(passp)
	
	
end	

function OnPlayerMainClose(LuaUIEvent)
	
		
	
end




return PlayerMainUIT;