OasisRP = OasisRP or {}
OasisRP.Survival = OasisRP.Survival or {}

local TICK_INTERVAL = 5.0
local BASE_DEPLETION = 0.5
local SUN_DEPLETION = 0.6
local SPRINT_DEPLETION = 0.4
local DEHYDRATION_DAMAGE = 3

function OasisRP.Survival:SetThirst(ply, amount)
	if not IsValid(ply) then return end

	local clamped = math.Clamp(amount, 0.0, 100.0)
	ply:SetNWFloat("OasisRP.Thirst", clamped)
end

function OasisRP.Survival:Drink(ply, amount, isClean)
	if not IsValid(ply) then return end

	local current = ply:GetOasisThirst()
	local newThirst = math.min(current + amount, 100.0)
	self:SetThirst(ply, newThirst)

	if isClean == false then
		-- Technical water might cause slight nausea or minor damage
		local dmg = DamageInfo()
		dmg:SetDamage(5)
		dmg:SetDamageType(DMG_POISON)
		dmg:SetAttacker(ply)
		dmg:SetInflictor(ply)
		ply:TakeDamageInfo(dmg)
		ply:ChatPrint("[Сектор 12] Вы выпили техническую воду. Во рту остался химический привкус.")
	else
		ply:ChatPrint("[Сектор 12] Вы утолили жажду чистой водой.")
	end

	ply:EmitSound("ambient/water/drip" .. math.random(1, 4) .. ".wav", 60, 100)
end

-- Periodic thirst simulation
timer.Create("oasis/survival/tick", TICK_INTERVAL, 0, function()
	for _, ply in player.Iterator() do
		if not ply:Alive() then continue end

		local loss = BASE_DEPLETION

		if ply:IsSprinting() then
			loss = loss + SPRINT_DEPLETION
		end

		if ply:IsUnderSun() then
			loss = loss + SUN_DEPLETION
		end

		local currentThirst = ply:GetOasisThirst()
		local updatedThirst = math.max(currentThirst - loss, 0.0)

		OasisRP.Survival:SetThirst(ply, updatedThirst)

		-- Dehydration penalties
		if updatedThirst <= 0.0 then
			local dmg = DamageInfo()
			dmg:SetDamage(DEHYDRATION_DAMAGE)
			dmg:SetDamageType(DMG_DISSOLVE)
			dmg:SetAttacker(game.GetWorld())
			dmg:SetInflictor(game.GetWorld())
			ply:TakeDamageInfo(dmg)

			ply:EmitSound("player/pl_pain5.wav", 55, 100)
			ply:ChatPrint("[Сектор 12] Вы страдаете от критического обезвоживания! Найдите воду.")
		end
	end
end)

-- Reset thirst on spawn
hook.Add("PlayerSpawn", "oasis/survival/player-spawn", function(ply)
	OasisRP.Survival:SetThirst(ply, 100.0)
end)
