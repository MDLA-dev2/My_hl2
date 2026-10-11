OasisRP = OasisRP or {}
OasisRP.Jobs = OasisRP.Jobs or {}
OasisRP.DefaultJob = "citizen"

local meta = FindMetaTable("Player")

function meta:GetOasisJobId()
	return self:GetNWString("OasisRP.Job", OasisRP.DefaultJob)
end

function meta:GetOasisJob()
	local jobId = self:GetOasisJobId()
	return OasisRP.Jobs[jobId] or OasisRP.Jobs[OasisRP.DefaultJob]
end

function OasisRP.RegisterJob(id, data)
	data.Id = id
	OasisRP.Jobs[id] = data
end

-- 1. Гражданин (Стартовая роль)
OasisRP.RegisterJob("citizen", {
	Name = "Прибывший гражданин",
	Description = "Недавно распределен Альянсом в Сектор 12. Ваша цель — найти кров и воду в оазисе.",
	Color = Color(195, 175, 140, 255),
	Models = {
		"models/player/Group01/male_01.mdl",
		"models/player/Group01/male_02.mdl",
		"models/player/Group01/male_03.mdl",
		"models/player/Group01/male_04.mdl",
		"models/player/Group01/female_01.mdl",
		"models/player/Group01/female_02.mdl",
	},
	Weapons = {},
	Salary = 15,
	Health = 100,
	Armor = 0,
})

-- 2. Работник гидрокомплекса
OasisRP.RegisterJob("water_worker", {
	Name = "Техник водоканала",
	Description = "Обслуживает дренажные насосы и фильтрационные резервуары Альянса.",
	Color = Color(70, 175, 225, 255),
	Models = {
		"models/player/Group02/male_02.mdl",
		"models/player/Group02/male_04.mdl",
		"models/player/Group02/male_06.mdl",
	},
	Weapons = {},
	Salary = 35,
	Health = 100,
	Armor = 0,
})

-- 3. Патрульная милиция
OasisRP.RegisterJob("militia", {
	Name = "Милиционер Альянса",
	Description = "Доброволец-коллаборационист ранней оккупации. Охраняет порядок и периметр тамперов.",
	Color = Color(80, 130, 210, 255),
	Models = {
		"models/player/police.mdl",
	},
	Weapons = {
		"weapon_stunstick",
		"weapon_pistol",
	},
	Salary = 50,
	Health = 100,
	Armor = 50,
})

-- 4. Старатель пустошей
OasisRP.RegisterJob("scavenger", {
	Name = "Старатель пустошей",
	Description = "Выходит за вибрационный периметр тамперов в поисках ценного хабара и артефактов.",
	Color = Color(225, 155, 60, 255),
	Models = {
		"models/player/Group03/male_01.mdl",
		"models/player/Group03/male_03.mdl",
		"models/player/Group03/male_07.mdl",
	},
	Weapons = {
		"weapon_crowbar",
	},
	Salary = 20,
	Health = 100,
	Armor = 15,
})
