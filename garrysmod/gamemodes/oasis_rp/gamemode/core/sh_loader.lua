OasisRP = OasisRP or {}
OasisRP.Loader = OasisRP.Loader or {}
OasisRP.Modules = OasisRP.Modules or {}

local function loadFile(realm, path)
	if realm == "shared" then
		if SERVER then
			AddCSLuaFile(path)
		end
		include(path)
	elseif realm == "client" then
		if SERVER then
			AddCSLuaFile(path)
		else
			include(path)
		end
	elseif realm == "server" and SERVER then
		include(path)
	end
end

function OasisRP.Loader:LoadModules()
	local folderName = OasisRP.FolderName or "oasis_rp"
	local modulesPath = folderName .. "/gamemode/modules/"
	local _, moduleFolders = file.Find(modulesPath .. "*", "LUA")

	if not moduleFolders then return end

	for _, modName in ipairs(moduleFolders) do
		local moduleDir = modulesPath .. modName .. "/"
		local files, _ = file.Find(moduleDir .. "*.lua", "LUA")

		OasisRP.Modules[modName] = OasisRP.Modules[modName] or {
			Name = modName,
			Files = files or {},
		}

		if not files then continue end

		-- 1. Shared files first
		for _, fileName in ipairs(files) do
			if string.StartWith(fileName, "sh_") or fileName == "shared.lua" then
				loadFile("shared", moduleDir .. fileName)
			end
		end

		-- 2. Server files
		for _, fileName in ipairs(files) do
			if string.StartWith(fileName, "sv_") or fileName == "init.lua" then
				loadFile("server", moduleDir .. fileName)
			end
		end

		-- 3. Client files
		for _, fileName in ipairs(files) do
			if string.StartWith(fileName, "cl_") or fileName == "cl_init.lua" then
				loadFile("client", moduleDir .. fileName)
			end
		end
	end

	hook.Run("oasis/modules/loaded")
end
