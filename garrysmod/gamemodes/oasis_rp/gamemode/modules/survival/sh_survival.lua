OasisRP = OasisRP or {}
OasisRP.Survival = OasisRP.Survival or {}

local meta = FindMetaTable("Player")

function meta:GetOasisThirst()
	return self:GetNWFloat("OasisRP.Thirst", 100.0)
end

function meta:IsUnderSun()
	local trace = util.TraceLine({
		start = self:EyePos(),
		endpos = self:EyePos() + Vector(0, 0, 16384),
		filter = self,
		mask = MASK_OPAQUE,
	})

	return trace.HitSky
end
