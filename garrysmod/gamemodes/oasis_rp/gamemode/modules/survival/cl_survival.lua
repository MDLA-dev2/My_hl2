OasisRP = OasisRP or {}
OasisRP.Survival = OasisRP.Survival or {}

-- Client dehydration effect
hook.Add("RenderScreenspaceEffects", "oasis/survival/screen-effects", function()
	local ply = LocalPlayer()
	if not IsValid(ply) or not ply:Alive() then return end

	local thirst = ply:GetOasisThirst()
	if thirst < 20.0 then
		local intensity = (20.0 - thirst) / 20.0
		DrawColorModify({
			["$pp_colour_addr"] = 0.05 * intensity,
			["$pp_colour_addg"] = 0.02 * intensity,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 1.0 + (0.15 * intensity),
			["$pp_colour_colour"] = 1.0 - (0.5 * intensity),
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0,
		})
	end
end)
