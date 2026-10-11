OasisRP = OasisRP or {}
OasisRP.NPCs = OasisRP.NPCs or {}

local activeDialogueFrame = nil

function OasisRP.NPCs:OpenDialogue(recruiterId, npcEnt)
	if IsValid(activeDialogueFrame) then
		activeDialogueFrame:Remove()
	end

	local config = OasisRP.NPCConfigs[recruiterId]
	if not config then return end

	local scrW = ScrW()
	local scrH = ScrH()
	local frameW = math.Round(scrW * 0.45)
	local frameH = math.Round(scrH * 0.55)

	local frame = vgui.Create("DFrame")
	frame:SetSize(frameW, frameH)
	frame:Center()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:MakePopup()

	frame.Paint = function(pnl, w, h)
		draw.RoundedBox(6, 0, 0, w, h, OasisRP.Theme.Background)
		draw.RoundedBox(6, 0, 0, w, math.Round(h * 0.12), OasisRP.Theme.Panel)

		-- Top border accent
		surface.SetDrawColor(OasisRP.Theme.AccentAmber)
		surface.DrawRect(0, 0, w, 3)

		-- NPC Title and Subtitle
		draw.SimpleText(config.Name, "OasisRP.FontLarge", 20, 12, OasisRP.Theme.TextPrimary, TEXT_ALIGN_LEFT)
		draw.SimpleText(config.Subtitle, "OasisRP.FontSmall", 20, 36, OasisRP.Theme.TextMuted, TEXT_ALIGN_LEFT)
	end

	activeDialogueFrame = frame

	-- Close button
	local closeBtn = vgui.Create("DButton", frame)
	closeBtn:SetSize(32, 32)
	closeBtn:SetPos(frameW - 42, 12)
	closeBtn:SetText("✕")
	closeBtn:SetFont("OasisRP.FontMedium")
	closeBtn:SetTextColor(OasisRP.Theme.TextMuted)
	closeBtn.Paint = function(pnl, w, h)
		if pnl:IsHovered() then
			draw.RoundedBox(4, 0, 0, w, h, Color(180, 50, 50, 200))
		end
	end
	closeBtn.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")
		frame:Close()
	end

	-- NPC Greeting Quote Box
	local quotePnl = vgui.Create("DPanel", frame)
	quotePnl:SetPos(20, math.Round(frameH * 0.15))
	quotePnl:SetSize(frameW - 40, math.Round(frameH * 0.16))
	quotePnl.Paint = function(pnl, w, h)
		draw.RoundedBox(4, 0, 0, w, h, OasisRP.Theme.Panel)
		surface.SetDrawColor(OasisRP.Theme.AccentAmber)
		surface.DrawRect(0, 0, 3, h)
	end

	local quoteLabel = vgui.Create("DLabel", quotePnl)
	quoteLabel:Dock(FILL)
	quoteLabel:DockMargin(16, 8, 16, 8)
	quoteLabel:SetFont("OasisRP.FontMedium")
	quoteLabel:SetTextColor(OasisRP.Theme.TextPrimary)
	quoteLabel:SetWrap(true)
	quoteLabel:SetText(config.Greeting or "")

	-- Scrollable Professions List
	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:SetPos(20, math.Round(frameH * 0.34))
	scroll:SetSize(frameW - 40, math.Round(frameH * 0.62))

	local sbar = scroll:GetVBar()
	sbar:SetWide(6)
	sbar.Paint = function() end
	sbar.btnUp.Paint = function() end
	sbar.btnDown.Paint = function() end
	sbar.btnGrip.Paint = function(pnl, w, h)
		draw.RoundedBox(3, 0, 0, w, h, OasisRP.Theme.Border)
	end

	for _, jobId in ipairs(config.AvailableJobs or {}) do
		local jobData = OasisRP.Jobs[jobId]
		if not jobData then continue end

		local cardH = math.Round(frameH * 0.18)
		local card = scroll:Add("DPanel")
		card:Dock(TOP)
		card:DockMargin(0, 0, 0, 10)
		card:SetTall(cardH)

		local isCurrent = LocalPlayer():GetOasisJobId() == jobId

		card.Paint = function(pnl, w, h)
			draw.RoundedBox(4, 0, 0, w, h, OasisRP.Theme.Panel)

			-- Left side accent indicator
			local accentCol = isCurrent and OasisRP.Theme.AccentWater or OasisRP.Theme.Border
			surface.SetDrawColor(accentCol)
			surface.DrawRect(0, 0, 3, h)

			-- Job title and salary
			draw.SimpleText(jobData.Name, "OasisRP.FontLarge", 16, 12, jobData.Color or OasisRP.Theme.TextPrimary)
			draw.SimpleText("Выплата: " .. tostring(jobData.Salary) .. " жетонов / смену", "OasisRP.FontSmall", 16, 38, OasisRP.Theme.AccentAmber)

			-- Description
			draw.SimpleText(jobData.Description, "OasisRP.FontSmall", 16, 58, OasisRP.Theme.TextMuted)
		end

		local actionBtn = vgui.Create("DButton", card)
		actionBtn:SetSize(math.Round(frameW * 0.28), math.Round(cardH * 0.45))
		actionBtn:SetPos(frameW - 40 - math.Round(frameW * 0.30), math.Round(cardH * 0.28))
		actionBtn:SetFont("OasisRP.FontMedium")

		if isCurrent then
			actionBtn:SetText("Текущая роль")
			actionBtn:SetTextColor(OasisRP.Theme.TextMuted)
			actionBtn:SetEnabled(false)
			actionBtn.Paint = function(pnl, w, h)
				draw.RoundedBox(4, 0, 0, w, h, OasisRP.Theme.PanelLight)
			end
		else
			actionBtn:SetText("Заступить на службу")
			actionBtn:SetTextColor(OasisRP.Theme.TextDark)
			actionBtn.Paint = function(pnl, w, h)
				local col = pnl:IsHovered() and Color(245, 180, 80) or OasisRP.Theme.AccentAmber
				draw.RoundedBox(4, 0, 0, w, h, col)
			end
			actionBtn.DoClick = function()
				surface.PlaySound("ui/buttonclickrelease.wav")
				net.Start("oasis/npcs/select_job")
				net.WriteEntity(npcEnt)
				net.WriteString(jobId)
				net.SendToServer()
				frame:Close()
			end
		end
	end
end

net.Receive("oasis/npcs/open_dialogue", function()
	local recruiterId = net.ReadString()
	local npcEnt = net.ReadEntity()

	OasisRP.NPCs:OpenDialogue(recruiterId, npcEnt)
end)
