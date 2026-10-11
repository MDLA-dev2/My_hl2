OasisRP = OasisRP or {}
OasisRP.HUD = OasisRP.HUD or {}

local smoothHealth = 100
local smoothArmor = 0
local smoothThirst = 100

-- Hide default engine HUD
local HIDDEN_ELEMENTS = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudSuitPower"] = true,
}

hook.Add("HUDShouldDraw", "oasis/hud/hide-defaults", function(name)
	if HIDDEN_ELEMENTS[name] then
		return false
	end
end)

hook.Add("HUDPaint", "oasis/hud/render", function()
	local ply = LocalPlayer()
	if not IsValid(ply) or not ply:Alive() then return end

	local scrW = ScrW()
	local scrH = ScrH()
	local frameTime = FrameTime()

	local hudW = math.Round(scrW * 0.22)
	local hudH = math.Round(scrH * 0.12)
	local hudX = math.Round(scrW * 0.02)
	local hudY = scrH - hudH - math.Round(scrH * 0.02)

	-- Interpolate values smoothly
	smoothHealth = Lerp(frameTime * 8, smoothHealth, math.Clamp(ply:Health(), 0, 100))
	smoothArmor = Lerp(frameTime * 8, smoothArmor, math.Clamp(ply:Armor(), 0, 100))
	smoothThirst = Lerp(frameTime * 8, smoothThirst, math.Clamp(ply:GetOasisThirst(), 0, 100))

	-- Main background card
	draw.RoundedBox(6, hudX, hudY, hudW, hudH, OasisRP.Theme.Background)
	draw.RoundedBox(6, hudX, hudY, hudW, math.Round(hudH * 0.35), OasisRP.Theme.Panel)

	-- Job data
	local jobData = ply:GetOasisJob()
	local jobName = jobData and jobData.Name or "Гражданин"
	local jobColor = jobData and jobData.Color or OasisRP.Theme.TextPrimary

	-- Left accent stripe
	surface.SetDrawColor(jobColor)
	surface.DrawRect(hudX, hudY, 3, hudH)

	-- Top header: Job Name and Sun Status
	draw.SimpleText(jobName, "OasisRP.FontMedium", hudX + 12, hudY + 6, jobColor, TEXT_ALIGN_LEFT)

	local isUnderSun = ply:IsUnderSun()
	local sunText = isUnderSun and "Солнце" or "Тень"
	local sunColor = isUnderSun and OasisRP.Theme.AccentAmber or OasisRP.Theme.TextMuted
	draw.SimpleText(sunText, "OasisRP.FontSmall", hudX + hudW - 12, hudY + 8, sunColor, TEXT_ALIGN_RIGHT)

	-- Bar dimensions
	local barX = hudX + 12
	local barW = hudW - 24
	local barH = math.Round(hudH * 0.18)
	local hpY = hudY + math.Round(hudH * 0.42)
	local thirstY = hudY + math.Round(hudH * 0.68)

	-- 1. Health Bar
	draw.RoundedBox(3, barX, hpY, barW, barH, OasisRP.Theme.PanelLight)
	local fillHealthW = math.Round((smoothHealth / 100) * barW)
	if fillHealthW > 0 then
		draw.RoundedBox(3, barX, hpY, fillHealthW, barH, OasisRP.Theme.Health)
	end
	draw.SimpleText("ЗДОРОВЬЕ: " .. tostring(math.max(0, ply:Health())), "OasisRP.FontSmall", barX + 6, hpY + 1, OasisRP.Theme.TextDark)

	-- 2. Thirst Bar
	draw.RoundedBox(3, barX, thirstY, barW, barH, OasisRP.Theme.PanelLight)
	local fillThirstW = math.Round((smoothThirst / 100) * barW)
	if fillThirstW > 0 then
		local thirstCol = smoothThirst > 30 and OasisRP.Theme.AccentWater or Color(220, 70, 70)
		draw.RoundedBox(3, barX, thirstY, fillThirstW, barH, thirstCol)
	end
	local thirstPercent = math.Round(ply:GetOasisThirst())
	draw.SimpleText("ВОДА: " .. tostring(thirstPercent) .. "%", "OasisRP.FontSmall", barX + 6, thirstY + 1, OasisRP.Theme.TextDark)
end)
