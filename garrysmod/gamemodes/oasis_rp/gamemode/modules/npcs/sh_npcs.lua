OasisRP = OasisRP or {}
OasisRP.NPCs = OasisRP.NPCs or {}

OasisRP.NPCConfigs = {
	["combine_recruiter"] = {
		Name = "Сержант вербовки Сектора 12",
		Subtitle = "Комендатура ранней оккупации Альянса",
		Model = "models/player/police.mdl",
		Greeting = "«Сектору нужны крепкие руки. Обеспечь защиту периметра тамперов и водонапорных узлов в обмен на чистую воду и пайки.»",
		AvailableJobs = {"militia"},
	},
	["water_foreman"] = {
		Name = "Бригадир Хасан (Водоканал)",
		Subtitle = "Очистной дренажный сектор",
		Model = "models/player/Group02/male_04.mdl",
		Greeting = "«Песок забивает фильтры каждую бурю. Если умеешь крутить вентили и не боишься испачкаться — у нас всегда есть работа и норма воды.»",
		AvailableJobs = {"water_worker", "citizen"},
	},
	["scavenger_elder"] = {
		Name = "Караванщик Тарик",
		Subtitle = "Торговый базар оазиса",
		Model = "models/player/Group03/male_07.mdl",
		Greeting = "«Пустыня полна остатков прежней цивилизации. Но муравьиные львы не прощают ошибок. Готов рискнуть головой за периметром?»",
		AvailableJobs = {"scavenger", "citizen"},
	},
}
