OasisRP = OasisRP or {}
OasisRP.Factions = OasisRP.Factions or {}

net.Receive("oasis/factions/sync", function()
	local newJobId = net.ReadString()
	hook.Run("oasis/client/job-updated", newJobId)
end)

function OasisRP.RequestJob(jobId)
	if not jobId or not OasisRP.Jobs[jobId] then return end

	net.Start("oasis/factions/request_job")
	net.WriteString(jobId)
	net.SendToServer()
end
