sc = sc or {}


function sc.CreateInstanceByClassName(classname)
	local class = rtti.get_class(classname)
	if class ~= nil then
		local inst = class.new()
		return inst
	else
		print("Class [" .. classname .. "] is not exist")
	end

	return nil
end

function sc.CreateTable()
	return {}
end

sc.BattleEventID = sc.BattleEventID or {}
sc.BattleEventID.UpdateLogic 				= 113
sc.BattleEventID.FightPrepare 				= 2
sc.BattleEventID.FightStart 				= 3
sc.BattleEventID.FightOver 					= 1 
sc.BattleEventID.ActorStartFight 			= 20
sc.BattleEventID.PlayerQuitBattle 			= 222
sc.BattleEventID.ActorDead 					= 9
sc.BattleEventID.ActorPrepared 				= 19
sc.BattleEventID.ActorRevive 				= 12
sc.BattleEventID.ActorDamage 				= 26
sc.BattleEventID.HeroEquipInBattleChanged 	= 85
sc.BattleEventID.RecvUGCMsg					= 233
sc.BattleEventID.RecvUGCMsgLua				= 234
sc.BattleEventID.StartLevel 				= 232
sc.BattleEventID.ShapeTriggerEvent 			= 116
sc.BattleEventID.DropItemTouch 				= 54
sc.BattleEventID.UGCCustomizeFrameCmd       = 231

sc.GameSkillEvent = sc.GameSkillEvent or {}
sc.GameSkillEvent.UseSkill 					= 243


function mainentry()
	-- package.path=package.path .. ';' .. 'Lua/'
	-- package.path=package.path .. ';' .. 'Lua/GamePlay/'
end

function sc.StringSplit(input, delimiter)
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
