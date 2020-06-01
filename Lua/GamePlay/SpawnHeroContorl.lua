local cjson = require "cjson"



SpawnHeroContorl = SpawnHeroContorl  or rtti.class("SpawnHeroContorl")
SpawnHeroContorl.m_binderObj = nil

local Grid_data = {}
local HeroFOV = 20000;-----视野范围

function SpawnHeroContorl:ctor()

	
end

--监听事件
function SpawnHeroContorl:OnEnable()

    sc.AddEventListener(self,sc.BattleEventID.FightStart)
    sc.AddEventListener(self,sc.BattleEventID.UGCCustomizeFrameCmd)
    sc.AddEventListener(self,sc.BattleEventID.RecvUGCMsg)
	
	--所有的Actor死亡都会被监听
	--sc.AddEventListener(self, sc.BattleEventID.ActorDead)
	
	--给定目标Actor,只监听目标Actor的死亡事件
	--sc.AddEventListener(self, sc.BattleEventID.ActorDead, TargetActor)
	
	--移除事件监听(局部和全局通用)
	--sc.RemoveEventListener(self,sc.BattleEventID.ActorDead)
	
	sc.AddEventListener(self,sc.BattleEventID.UpdateLogic)
		
	self.mHeros ={};
	
	self.mTower = nil;
	
	self.mTowerActorID = 0;
	
	self.mPlayerIDInfo = {};
	
	self.Camp = 0;
	
	self.mAllAreaDefend ={};
	
end

function SpawnHeroContorl:Tick( )

--[[		local eventname = nil
        eventName = StringId.new("Tick")
        sc.CallUILuaFunction({},eventName)--]]

end	


	
function SpawnHeroContorl:OnReceiveUGCCommand(playerId, JasonBuff)

		  
    local myJson = cjson.decode(JasonBuff)
	
	--print("playerId-------------------------",playerId,myJson.funcname,myJson.f )
			
    if myJson.f == "C" then
				
		local temp = sc.StringSplit(myJson.p, '|')
		
		--local ActorArea = self.mPlayerIDInfo[tostring(playerId)];
						
		local ActorPos = VInt3.new(tonumber(temp[1])*1000,100,tonumber(temp[2])*1000);
				
		local actor = sc.SpawnActor(sc.GameObject_Nil ,ActorPos, VInt3.new(0,0,0) , myJson.d, 0, tonumber(myJson.c), false, false,0)
		
		local actorID = sc.GetActorSystemProperty(actor,1004);
		
		Grid_data[myJson.g] = actor 
		
		sc.SetActorSystemProperty(actor,1009,myJson.l); ----等级
		
		local StarKey = StringId.new("Star")
        sc.SetCustomProperty(actor, StarKey, sc.enCustomType.Int, myJson.l)
		
		local eventShowStar3DUIname = nil
        eventShowStar3DUIname = StringId.new("ShowStar3DUI")
        --调用(UIlua)SelectHero.lua里的函数,创建3DUI
        sc.CallUILuaFunction({actorID,sc.GetCustomProperty(actor, StarKey, sc.enCustomType.Int)},eventShowStar3DUIname)
		
		
		local strTag = "hero"..tostring(myJson.c)..tostring(myJson.a); ----------1v1 默认区域1
		
		local strTagID =  StringId.new(strTag)
	
		sc.AddTag(actor,sc.GameObject_Nil,strTagID);
		
		self.mAllAreaDefend[actor] = myJson.a;
		
		local eventname = nil
		eventName = StringId.new("DropDefendHero")
		--调用(UIlua)Create.lua里的函数
		sc.CallUILuaFunction({actorID,playerId},eventName)
		
		
		
		self.mHeros[actor] =  playerId;
		
		--sc.AddEventListener(self, sc.BattleEventID.ActorDead, actor)
		
		local Key = StringId.new("area")
		sc.SetCustomProperty(actor, Key, sc.enCustomType.Int, myJson.a)
		
		local HeroView =  StringId.new("HeroView")
		sc.SetCustomProperty(actor, HeroView, sc.enCustomType.Int, HeroFOV)
		
		--local level = sc.GetActorSystemProperty(actor,1009);
		
		--local playerID = sc.GetActorSystemProperty(actor,1007);
				
		--local playerActor = sc.GetControlActorByPlayerID(playerId);
	
		--sc.AddTag(actor,sc.GetUnityObjectFromActorRoot(actor),"myhero");
		
--[[		for i = 1 , 5 do
			local level = sc.GetSkillLevel(actor, i);
			sc.SetSkillLevel(actor,i,3);
			print("level ------",level)
			
			local playerLevel = sc.GetSkillLevel(playerActor, i);
			print("playerLevel ------",playerLevel)
		end--]]	
			
	    --选择英雄（显示杀死和移动按钮）
    elseif myJson.funcname == "SelectHero" then
        local eventName = nil
        --当格Cell中有Actor
        if Grid_data[myJson.CIndex] ~= nil then
            --调用(UIlua)SelectHero.lua里的函数, 展示"杀死"和"移动" UI
            eventName = StringId.new("ShowSelectHeroUI")
            sc.CallUILuaFunction({myJson.CIndex,myJson.playerID},eventName)
        else
             --调用(UIlua)SelectHero.lua里的函数, 隐藏"杀死"和"移动" UI
            eventName = StringId.new("HideSelectHeroUI")
            sc.CallUILuaFunction({},eventName)
        end
	
    elseif myJson.funcname == "LevelUPHero" then
        local eventName = nil
        if Grid_data[myJson.CIndex] ~= nil then
			local StarKey = StringId.new("Star")
			local level = sc.GetCustomProperty(Grid_data[myJson.CIndex] , StarKey, sc.enCustomType.Int)
			if level < 3 then
				sc.SetSkillLevel(Grid_data[myJson.CIndex] ,1,myJson.Slot);--- 开发新技能
				sc.SetCustomProperty(Grid_data[myJson.CIndex] , StarKey, sc.enCustomType.Int, level + 1)
				sc.SetActorSystemProperty(Grid_data[myJson.CIndex] ,1009,level + 1); ----等级
				local eventShowStar3DUIname = nil
				eventShowStar3DUIname = StringId.new("ShowStar3DUI")
				local actorID = sc.GetActorSystemProperty(Grid_data[myJson.CIndex] ,1004);
				--调用(UIlua)SelectHero.lua里的函数,创建3DUI
				sc.CallUILuaFunction({actorID,sc.GetCustomProperty(Grid_data[myJson.CIndex] , StarKey, sc.enCustomType.Int)},eventShowStar3DUIname)

				local eventRefeshDefendHeroname = nil
				eventRefeshDefendHeroname = StringId.new("RefeshDefendHero")
				sc.CallUILuaFunction({myJson.CIndex,sc.GetCustomProperty(Grid_data[myJson.CIndex] , StarKey, sc.enCustomType.Int)},eventRefeshDefendHeroname)
								
			end
			
        end	
	
    elseif myJson.funcname == "SailHero" then
        --发送消息给蓝图，在英雄上挂着的aiCommon.gl接收
        --sc.UGCSendMsg("SailHero",{actorRoot = Grid_data[myJson.CIndex]})
        --获取ActorID
        local actorID = sc.GetActorSystemProperty(Grid_data[myJson.CIndex],1004)
		sc.KillActor(Grid_data[myJson.CIndex],true,true,Grid_data[myJson.CIndex]);
		--sc.RecycleActor(Grid_data[myJson.CIndex] , 1);
        --销毁3DUI
        local eventname = nil
        eventName = StringId.new("DestroyStar3DUI")
        sc.CallUILuaFunction({actorID},eventName)
        --清空Cell内的英雄信息
        Grid_data[myJson.CIndex] = nil	
		
	
   elseif myJson.funcname == "MoveHero" then
        --获取Actor信息
        MovingActor = Grid_data[myJson.CIndex]
        --隐藏Actor
        sc.UGCHideActor(true,MovingActor)
        --获取ActorID
        local actorID = sc.GetActorSystemProperty(Grid_data[myJson.CIndex],1004)
        --销毁3DUI
        local eventname = nil
        eventName = StringId.new("DestroyStar3DUI")
        sc.CallUILuaFunction({actorID},eventName)
        --清空格子信息
        Grid_data[myJson.CIndex] = nil	
		
	elseif myJson.funcname == "MoveFail" then

        --显示Actor
        sc.UGCHideActor(false,MovingActor)
		local actorID = sc.GetActorSystemProperty(MovingActor,1004)
        --Show3DUI
        local eventName = StringId.new("ShowStar3DUI")
        local Key = StringId.new("Star")
        --调用(UIlua)SelectHero.lua里的函数,创建3DUI
        sc.CallUILuaFunction({actorID,sc.GetCustomProperty(MovingActor, Key, sc.enCustomType.Int)},eventName)
        --清空格子信息
        Grid_data[myJson.CIndex] = MovingActor		
	
		elseif myJson.f == "M" then 
        --传送Actor
        sc.TeleportActor(MovingActor,sc.GameObject_Nil,VInt3.new(myJson.x,100,myJson.z),VInt3.new(0,0,1))
        --显示Actor
        sc.UGCHideActor(false,MovingActor)
        --播放特效
        sc.TriggerParticleStart(StringId.new("Prefab_Skill_Effects/Systems_Effects/Choujiang_df_07.prefab"),
                                StringId.new(""),
                                StringId.new(""),
                                MovingActor,
                                false,
                                sc.GameObject_Nil,
                                VInt3.new(myJson.x,100,myJson.z),
                                VInt3.new(0,0,0),
                                VInt3.new(3,3,3),
                                false)
        --关联actor和格子
        Grid_data[myJson.c] = MovingActor
        --关闭UIManger中的拖动状态flag
        local eventname = nil
        eventName = StringId.new("UIManager.StopDragMoving")
        sc.CallUILuaFunction({myJson.p},eventName)
        --获取ActorID
        local actorID = sc.GetActorSystemProperty(MovingActor,1004)
        --Show3DUI
        local eventShowStar3DUIname = StringId.new("ShowStar3DUI")
        local Key = StringId.new("Star")
        --调用(UIlua)SelectHero.lua里的函数,创建3DUI
        sc.CallUILuaFunction({actorID,sc.GetCustomProperty(MovingActor, Key, sc.enCustomType.Int)},eventShowStar3DUIname)
		
		local eventMoveDefendHeroname = nil
		eventMoveDefendHeroname = StringId.new("MoveDefendHero")
		--调用(UIlua)SelectHero.lua里的函数,创建3DUI
		sc.CallUILuaFunction({myJson.c},eventMoveDefendHeroname)
 
		
	end
	
	
end

function SpawnHeroContorl:ActorDead(src,atker,orignalAtker,logicAtker,bImmediateRevive)
	
--[[	local playerID = self.mHeros[src];
	
	if playerID ~= nil then
		
		local ActorCamp = self.mPlayerIDInfo[tostring(playerId)];
		
		sc.UGCSendMsg("DefendActorDied",{ID = playerID,camp = ActorCamp})
		
	end--]]
	
	
end

--接收从蓝图gl发送过来的消息
function SpawnHeroContorl:OnRecvUGCMsg(eventName, data)
	
  --  print("SpawnHeroContorl---------",eventName)
  
	if eventName == "SetTheAllPlayerCamp" then
	
		local Str = data.PlayerIDInfo:ToString():AsCStr()

		local temp = sc.StringSplit(Str, '&')
		
		for k , v in pairs(temp) do
			
			if  v ~= nil and v ~="" then
				
				local areaInfo = sc.StringSplit(v, '|')
				
				self.mPlayerIDInfo[areaInfo[1]] = areaInfo[2];

				
			end
		end
		
		
		local InitGameInfoName = StringId.new("InitGameInfo")
		--调用(UIlua)Create.lua里的函数
		sc.CallUILuaFunction({Str},InitGameInfoName)
		
		--sc.UGCSendMsg("TowerInit",{})
		
	elseif eventName == "clearAllOfActor" then 	
		
--[[			for  k , v in pairs(self.mHeros) do
		
				if  k ~= nil and v ~= nil then
					
					if sc.IsAlive(k) then
						sc.KillActor(k,true,true,k);
						--sc.RecycleActor(k , 1);
					end
					
					--
				end
				
			end--]]
		
		self.mHeros = {};
		Grid_data ={};
		
	end
	
	

	
end



