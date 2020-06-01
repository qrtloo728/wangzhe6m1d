--

local l_self

function OnStartOpenUI(luaUIEvent)	

	--����Ĭ�Ϸ���
	LuaCallCs_UGCStateDriver.CreateRoom()

	--�������±�ʾ�����Զ�������׶�
	LuaCallCs_UGCStateDriver.SendMatchConfirm()
	
	--����Ĭ�Ͽ������ݣ������ݽ���startup.gl�б�ʹ�ã����ڳ�ʼ���ؿ�����
	OfflineSetDefaultCustomOperation()
	
	l_self = luaUIEvent.SrcForm;
	
end

function OnStartClose(luaUIEvent)
	
end


function OnStartClick(luaUIEvent)

	G_GameData.HeroID = 105

	--LuaCallCs_UGCStateDriver.StartGame("main_level");
	
	--LuaCallCs_UGCStateDriver.StartGame("Level1");
	l_self:Hide();
	
end


--����Ĭ�ϵ��Զ����������(Ҳ�ǿ�������,�������·�����)
function OfflineSetDefaultCustomOperation()

    ----��ʼ������
	playerArr = LuaCallCs_UGCStateDriver.GetAllPlayerInfos()
    playerArrLenght = #playerArr

    --��Ҫ׼��������

    for i = 1, playerArrLenght do

        local playerBattleInfo = {}

        playerBattleInfo.playerID = playerArr[i].playerID

        playerBattleInfo.heroID = 105;
		
        G_GameData.playerInfos[i] = playerBattleInfo

    end
	--���������л�Ϊjson��ʽ
	local operatData = json.encode(G_GameData)
	--�������ݵ�������
	LuaCallCs_UGCStateDriver.SendFullDataBuf(operatData)
end



