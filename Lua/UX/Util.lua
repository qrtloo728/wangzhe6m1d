Util = {}

local HeroCTData = require "ConfigData/HeroCTData.lua"
local CameraCTData = require "ConfigData/CameraDataCTData.lua"
local MonsterCTData = require "ConfigData/MonsterCTData.lua"
local HeroSkillCTData = require "ConfigData/HeroSkillCTData.lua"
local RobotCTData = require "ConfigData/RobotCTData.lua"

Util.BaseNum = 20001;
Util.CameraDepth = 30;

function Util.GetHeroDataByID(heroID)
	
	local hdata = nil;
	for _, v in pairs(HeroCTData) do 
		
		if heroID == v.id then
			
			hdata = v;
			break;
		end
		
	end
	
	return hdata;
end

function Util.GetHeroDataMax()
	
	return #HeroCTData;
	
end	

function Util.CameraDataByCampAreaID(camp,ID)
	
	local hdata = nil;
	for _, v in pairs(CameraCTData) do 
		
		if ID == v.AreaID and camp == v.Camp then
			
			hdata = v;
			break;
		end
		
	end
	
	return hdata;
end

function Util.GetHeroSkillDataByID(skillID)
	
	local hdata = nil;
	for _, v in pairs(HeroSkillCTData) do 
		
		if skillID == v.id then
			
			hdata = v;
			break;
		end
		
	end
	
	return hdata;
end


function Util.GetMonseterDataByID(id)
	
	local hdata = nil;
	for _, v in pairs(MonsterCTData) do 
		
		if id == v.id  then
			
			hdata = v;
			break;
		end
		
	end
	
	return hdata;
	
end	

function Util.GetMonseterDataByIndex(index)
	
	local hdata = nil;
	for _, v in pairs(MonsterCTData) do 
		
		if index == v.index  then
			
			hdata = v;
			break;
		end
		
	end
	
	return hdata;
	
end	

function Util.GetMonseterHireData()
	
	local hdata = {};
	for _, v in pairs(MonsterCTData) do 
		
		if v.isHire> 0  then
			table.insert(hdata,v);
		end
		
	end
	
	return hdata;
	
end	


function Util.GetRobotDataByID(index)
	
	local hdata = nil;
	for _, v in pairs(RobotCTData) do 
		
		if index == v.index then
			
			hdata = v;
			break;
		end
		
	end
	
	return hdata;
end

-----随机范围（m,n），个数cnt 去除随机数第一相同的数
function Util.RandomNum(m,n,cnt)
	
	if cnt>n-m+1 then
        return {}
    end
    local t = {}
    local tmp = {}
    math.randomseed(os.time())
	local unUse = math.random(m,n);
    while cnt>0 do
        local x =math.random(m,n)
        if not tmp[x] then
            t[#t+1]=x
            tmp[x]=1
            cnt=cnt-1
        end
    end
    return t
end


function Util.CompairTableEquil(t1,t2)
	
	local state = true;
	if #t1 ~= #t2 then
		return 	false;
	end
	
	for i = 1, #t1 do
		if t1[i] ~= t2[i] then
			state = false;
			break;
		end
	end
	
	return state;
end	

function Util.StringSplit(input, delimiter)
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

function Util.getFloat(num, bit)
    return num - num % bit
end
--random(m, n)


return Util;