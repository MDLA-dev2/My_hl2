OasisRP = OasisRP or {}
OasisRP.Factions = OasisRP.Factions or {}

util.AddNetworkString("oasis/factions/sync")
util.AddNetworkString("oasis/factions/request_job")

local COOLDOWN_JOB_CHANGE = 5 -- seconds

function OasisRP.Factions:ApplyJobLoadout(ply, jobData)
	if not IsValid(ply) or not jobData then return end

	ply:StripWeapons()

	-- Give default fists/hands if sandbox has hands
	if ply:HasWeapon("weapon_fists") == false then
		ply:Give("weapon_fists")
	end

	for _, wepClass in ipairs(jobData.Weapons or {}) do
		ply:Give(wepClass)
	end

	local models = jobData.Models or {}
	if #models > 0 then
		local chosenModel = models[1]
		ply:SetModel(chosenModel)
	end

	ply:SetHealth(jobData.Health or 100)
	ply:SetMaxHealth(jobData.Health or 100)
	ply:SetArmor(jobData.Armor or 0)
end

function OasisRP.Factions:SetPlayerJob(ply, jobId, suppressSave)
	if not IsValid(ply) then return end

	local jobData = OasisRP.Jobs[jobId]
	if not jobData then return end

	local oldJobId = ply:GetOasisJobId()
	ply:SetNWString("OasisRP.Job", jobId)

	self:ApplyJobLoadout(ply, jobData)

	-- Synchronize to client
	net.Start("oasis/factions/sync")
	net.WriteString(jobId)
	net.Send(ply)

	-- Database persistence
	if not suppressSave then
		local steamId = ply:SteamID()
		local escapedJob = OasisRP.Database:Escape(jobId)
		OasisRP.Database:Query(string.format([[
			UPDATE oasis_players
			SET job = '%s'
			WHERE steamid = '%s';
		]], escapedJob, steamId))
	end

	hook.Run("oasis/player/job-changed", ply, oldJobId, jobId)
end

-- Network receiver for player requesting a job switch
net.Receive("oasis/factions/request_job", function(_, ply)
	if not IsValid(ply) then return end

	-- Rate limiting cooldown check
	local curTime = CurTime()
	ply.oasisNextJobChange = ply.oasisNextJobChange or 0
	if curTime < ply.oasisNextJobChange then
		ply:ChatPrint("[Сектор 12] Подождите перед повторной сменой профессии.")
		return
	end

	local requestedJobId = net.ReadString()
	local jobData = OasisRP.Jobs[requestedJobId]

	if not jobData then
		return
	end

	ply.oasisNextJobChange = curTime + COOLDOWN_JOB_CHANGE
	OasisRP.Factions:SetPlayerJob(ply, requestedJobId, false)
	ply:ChatPrint("[Сектор 12] Ваша профессия изменена: " .. jobData.Name)
end)

-- Re-apply loadout on spawn
hook.Add("PlayerSpawn", "oasis/factions/player-spawn", function(ply)
	local jobData = ply:GetOasisJob()
	if jobData then
		timer.Simple(0.1, function()
			if IsValid(ply) then
				OasisRP.Factions:ApplyJobLoadout(ply, jobData)
			end
		end)
	end
end)

-- Load job on initial spawn from database
hook.Add("oasis/player/initial-spawn", "oasis/factions/load-player", function(ply)
	local steamId = ply:SteamID()
	local escapedName = OasisRP.Database:Escape(ply:Nick())

	OasisRP.Database:QueryRow(string.format([[
		SELECT job, money FROM oasis_players WHERE steamid = '%s';
	]], steamId), function(row)
		if not IsValid(ply) then return end

		if row and row.job and OasisRP.Jobs[row.job] then
			OasisRP.Factions:SetPlayerJob(ply, row.job, true)
		else
			-- New player registration
			OasisRP.Database:Query(string.format([[
				INSERT INTO oasis_players (steamid, name, job, money, first_joined, last_seen)
				VALUES ('%s', '%s', '%s', 100, %d, %d);
			]], steamId, escapedName, OasisRP.DefaultJob, os.time(), os.time()))

			OasisRP.Factions:SetPlayerJob(ply, OasisRP.DefaultJob, true)
		end
	end)
end)
