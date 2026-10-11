OasisRP = OasisRP or {}
OasisRP.NPCs = OasisRP.NPCs or {}

util.AddNetworkString("oasis/npcs/open_dialogue")
util.AddNetworkString("oasis/npcs/select_job")

local MAX_USE_DIST_SQR = 16384 -- ~128 units

function OasisRP.NPCs:SpawnRecruiter(npcConfigId, pos, ang)
	local config = OasisRP.NPCConfigs[npcConfigId]
	if not config then return nil end

	local ent = ents.Create("npc_citizen")
	if not IsValid(ent) then return nil end

	ent:SetPos(pos)
	ent:SetAngles(ang or Angle(0, 0, 0))
	ent:SetModel(config.Model or "models/player/police.mdl")
	ent:Spawn()
	ent:Activate()

	ent:SetHullType(HULL_HUMAN)
	ent:SetHullSizeNormal()
	ent:SetNPCState(NPC_STATE_IDLE)
	ent:SetSolid(SOLID_BBOX)
	ent:CapabilitiesAdd(CAP_ANIMATEDFACE)
	ent:CapabilitiesAdd(CAP_TURN_HEAD)
	ent:SetUseType(SIMPLE_USE)

	ent.oasisRecruiterId = npcConfigId
	ent:SetNWString("OasisRP.RecruiterId", npcConfigId)

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	return ent
end

hook.Add("PlayerUse", "oasis/npcs/detect-interaction", function(ply, ent)
	if not IsValid(ply) or not IsValid(ent) then return end

	local recruiterId = ent.oasisRecruiterId
	if not recruiterId then return end

	if ply:GetPos():DistToSqr(ent:GetPos()) > MAX_USE_DIST_SQR then
		return
	end

	net.Start("oasis/npcs/open_dialogue")
	net.WriteString(recruiterId)
	net.WriteEntity(ent)
	net.Send(ply)

	return true
end)

net.Receive("oasis/npcs/select_job", function(_, ply)
	if not IsValid(ply) then return end

	local npcEnt = net.ReadEntity()
	local requestedJobId = net.ReadString()

	if not IsValid(npcEnt) then return end

	local recruiterId = npcEnt.oasisRecruiterId
	if not recruiterId then return end

	local config = OasisRP.NPCConfigs[recruiterId]
	if not config then return end

	-- Distance verification (Server is single source of truth)
	if ply:GetPos():DistToSqr(npcEnt:GetPos()) > MAX_USE_DIST_SQR then
		return
	end

	-- Verify the NPC actually offers this job
	local isAllowed = false
	for _, jobId in ipairs(config.AvailableJobs or {}) do
		if jobId == requestedJobId then
			isAllowed = true
			break
		end
	end

	if not isAllowed then
		ply:ChatPrint("[Сектор 12] Этот представитель не уполномочен назначать данную должность.")
		return
	end

	OasisRP.Factions:SetPlayerJob(ply, requestedJobId, false)
	ply:ChatPrint("[Сектор 12] Вы успешно оформили контракт: " .. OasisRP.Jobs[requestedJobId].Name)
end)
