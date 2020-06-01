
local HeroSkillCTData = {
	{
		-- 名称
		name = "水晶祝福", 
		-- 怪物ID
		id = 60001, 
		-- 冷却时间
		cdtime = 10, 
		-- 增加血量
		addhp = 1000, 
		-- 提升等级
		uplevel = 1, 
		-- 增加物理防守
		addpy = 100, 
		-- 消耗蓝量
		expendmp = 10,
	},
	{
		name = "快速修复", 
		id = 60002, 
		cdtime = 10, 
		addhp = 2000, 
		uplevel = 0, 
		addpy = 0, 
		expendmp = 10,
	},
	{
		name = "专属技能", 
		id = 60003, 
		cdtime = 10, 
		addhp = 0, 
		uplevel = 0, 
		addpy = 0, 
		expendmp = 10,
	},

}
return HeroSkillCTData
