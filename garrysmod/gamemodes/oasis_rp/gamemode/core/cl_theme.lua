OasisRP = OasisRP or {}
OasisRP.Theme = OasisRP.Theme or {}

-- Pre-cached color palette (Slate & Amber)
OasisRP.Theme.Background = Color(24, 25, 28, 245)
OasisRP.Theme.Panel = Color(34, 36, 40, 255)
OasisRP.Theme.PanelLight = Color(44, 47, 52, 255)
OasisRP.Theme.Border = Color(60, 64, 72, 255)
OasisRP.Theme.AccentAmber = Color(230, 160, 60, 255)
OasisRP.Theme.AccentWater = Color(70, 175, 225, 255)
OasisRP.Theme.Health = Color(78, 185, 110, 255)
OasisRP.Theme.TextPrimary = Color(235, 235, 240, 255)
OasisRP.Theme.TextMuted = Color(150, 153, 160, 255)
OasisRP.Theme.TextDark = Color(18, 18, 20, 255)

local function rebuildFonts()
	local screenH = ScrH()
	local scale = math.Clamp(screenH / 1080, 0.7, 1.5)

	surface.CreateFont("OasisRP.FontSmall", {
		font = "Roboto",
		size = math.Round(14 * scale),
		weight = 400,
		antialias = true,
	})

	surface.CreateFont("OasisRP.FontMedium", {
		font = "Roboto",
		size = math.Round(18 * scale),
		weight = 500,
		antialias = true,
	})

	surface.CreateFont("OasisRP.FontLarge", {
		font = "Roboto",
		size = math.Round(24 * scale),
		weight = 600,
		antialias = true,
	})

	surface.CreateFont("OasisRP.FontHeader", {
		font = "Roboto",
		size = math.Round(32 * scale),
		weight = 700,
		antialias = true,
	})
end

rebuildFonts()

hook.Add("OnScreenSizeChanged", "oasis/theme/rebuild-fonts", function()
	rebuildFonts()
end)
