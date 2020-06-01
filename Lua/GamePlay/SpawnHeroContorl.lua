local cjson = require "cjson"



SpawnHeroContorl = SpawnHeroContorl  or rtti.class("SpawnHeroContorl")
SpawnHeroContorl.m_binderObj = nil

local Grid_data = {}
local HeroFOV = 20000;-----��Ұ��Χ

function SpawnHeroContorl:ctor()

	
end

--�����¼�
function SpawnHeroContorl:OnEnable()

    sc.AddEventListener(self,sc.BattleEventID.FightStart)
    sc.AddEventListener(self,sc.BattleEventID.UGCCustomizeFrameCmd)
    sc.AddEventListener(self,sc.BattleEventID.RecvUGCMsg)
	
	--���е�Actor�������ᱻ����
	--sc.AddEventListener(self, sc.BattleEventID.ActorDead)
	
	--����Ŀ��Actor,ֻ����Ŀ��Actor�������¼�
	--sc.AddEventListener(self, sc.BattleEventID.ActorDead, TargetActor)
	
	--�Ƴ��¼�����(�ֲ���ȫ��ͨ��)
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
		
		sc.SetActorSystemProperty(actor,1009,myJson.l); ----�ȼ�
		
		local StarKey = StringId.new("Star")
        sc.SetCustomProperty(actor, StarKey, sc.enCustomType.Int, myJson.l)
		
		local eventShowStar3DUIname = nil
        eventShowStar3DUIname = StringId.new("ShowStar3DUI")
        --����(UIlua)SelectHero.lua��ĺ���,����3DUI
        sc.CallUILuaFunction({actorID,sc.GetCustomProperty(actor, StarKey, sc.enCustomType.Int)},eventShowStar3DUIname)
		
		
		local strTag = "hero"..tostring(myJson.c)..tostring(myJson.a); ----------1v1 Ĭ������1
		
		local strTagID =  StringId.new(strTag)
	
		sc.AddTag(actor,sc.GameObject_Nil,strTagID);
		
		self.mAllAreaDefend[actor] = myJson.a;
		
		local eventname = nil
		eventName = StringId.new("DropDefendHero")
		--����(UIlua)Create.lua��ĺ���
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
			
	    --ѡ��Ӣ�ۣ���ʾɱ�����ƶ���ť��
    elseif myJson.funcname == "SelectHero" then
        local eventName = nil
        --����Cell����Actor
        if Grid_data[myJson.CIndex] ~= nil then
            --����(UIlua)SelectHero.lua��ĺ���, չʾ"ɱ��"��"�ƶ�" UI
            eventName = StringId.new("ShowSelectHeroUI")
            sc.CallUILuaFunction({myJson.CIndex,myJson.playerID},eventName)
        else
             --����(UIlua)SelectHero.lua��ĺ���, ����"ɱ��"��"�ƶ�" UI
            eventName = StringId.new("HideSelectHeroUI")
            sc.CallUILuaFunction({},eventName)
        end
	
    elseif myJson.funcname == "LevelUPHero" then
        local eventName = nil
        if Grid_data[myJson.CIndex] ~= nil then
			local StarKey = StringId.new("Star")
			local level = sc.GetCustomProperty(Grid_data[myJson.CIndex] , StarKey, sc.enCustomType.Int)
			if level < 3 then
				sc.SetSkillLevel(Grid_data[myJson.CIndex] ,1,myJson.Slot);--- �����¼���
				sc.SetCustomProperty(Grid_data[myJson.CIndex] , StarKey, sc.enCustomType.Int, level + 1)
				sc.SetActorSystemProperty(Grid_data[myJson.CIndex] ,1009,level + 1); ----�ȼ�
				local eventShowStar3DUIname = nil
				eventShowStar3DUIname = StringId.new("ShowStar3DUI")
				local actorID = sc.GetActorSystemProperty(Grid_data[myJson.CIndex] ,1004);
				--����(UIlua)SelectHero.lua��ĺ���,����3DUI
				sc.CallUILuaFunction({actorID,sc.GetCustomProperty(Grid_data[myJson.CIndex] , StarKey, sc.enCustomType.Int)},eventShowStar3DUIname)

				local eventRefeshDefendHeroname = nil
				eventRefeshDefendHeroname = StringId.new("RefeshDefendHero")
				sc.CallUILuaFunction({myJson.CIndex,sc.GetCustomProperty(Grid_data[myJson.CIndex] , StarKey, sc.enCustomType.Int)},eventRefeshDefendHeroname)
								
			end
			
        end	
	
    elseif myJson.funcname == "SailHero" then
        --������Ϣ����ͼ����Ӣ���Ϲ��ŵ�aiCommon.gl����
        --sc.UGCSendMsg("SailHero",{actorRoot = Grid_data[myJson.CIndex]})
        --��ȡActorID
        local actorID = sc.GetActorSystemProperty(Grid_data[myJson.CIndex],1004)
		sc.KillActor(Grid_data[myJson.CIndex],true,true,Grid_data[myJson.CIndex]);
		--sc.RecycleActor(Grid_data[myJson.CIndex] , 1);
        --����3DUI
        local eventname = nil
        eventName = StringId.new("DestroyStar3DUI")
        sc.CallUILuaFunction({actorID},eventName)
        --���Cell�ڵ�Ӣ����Ϣ
        Grid_data[myJson.CIndex] = nil	
		
	
   elseif myJson.funcname == "MoveHero" then
        --��ȡActor��Ϣ
        MovingActor = Grid_data[myJson.CIndex]
        --����Actor
        sc.UGCHideActor(true,MovingActor)
        --��ȡActorID
        local actorID = sc.GetActorSystemProperty(Grid_data[myJson.CIndex],1004)
        --����3DUI
        local eventname = nil
        eventName = StringId.new("DestroyStar3DUI")
        sc.CallUILuaFunction({actorID},eventName)
        --��ո�����Ϣ
        Grid_data[myJson.CIndex] = nil	
		
	elseif myJson.funcname == "MoveFail" then

        --��ʾActor
        sc.UGCHideActor(false,MovingActor)
		local actorID = sc.GetActorSystemProperty(MovingActor,1004)
        --Show3DUI
        local eventName = StringId.new("ShowStar3DUI")
        local Key = StringId.new("Star")
        --����(UIlua)SelectHero.lua��ĺ���,����3DUI
        sc.CallUILuaFunction({actorID,sc.GetCustomProperty(MovingActor, Key, sc.enCustomType.Int)},eventName)
        --��ո�����Ϣ
        Grid_data[myJson.CIndex] = MovingActor		
	
		elseif myJson.f == "M" then 
        --����Actor
        sc.TeleportActor(MovingActor,sc.GameObject_Nil,VInt3.new(myJson.x,100,myJson.z),VInt3.new(0,0,1))
        --��ʾActor
        sc.UGCHideActor(false,MovingActor)
        --������Ч
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
        --����actor�͸���
        Grid_data[myJson.c] = MovingActor
        --�ر�UIManger�е��϶�״̬flag
        local eventname = nil
        eventName = StringId.new("UIManager.StopDragMoving")
        sc.CallUILuaFunction({myJson.p},eventName)
        --��ȡActorID
        local actorID = sc.GetActorSystemProperty(MovingActor,1004)
        --Show3DUI
        local eventShowStar3DUIname = StringId.new("ShowStar3DUI")
        local Key = StringId.new("Star")
        --����(UIlua)SelectHero.lua��ĺ���,����3DUI
        sc.CallUILuaFunction({actorID,sc.GetCustomProperty(MovingActor, Key, sc.enCustomType.Int)},eventShowStar3DUIname)
		
		local eventMoveDefendHeroname = nil
		eventMoveDefendHeroname = StringId.new("MoveDefendHero")
		--����(UIlua)SelectHero.lua��ĺ���,����3DUI
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

--���մ���ͼgl���͹�������Ϣ
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
		--����(UIlua)Create.lua��ĺ���
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



