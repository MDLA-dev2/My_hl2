AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("core/sv_database.lua")

function GM:Initialize()
	OasisRP.Database:Initialize()
	OasisRP.Loader:LoadModules()

	hook.Run("oasis/gamemode/initialized")
end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass:PlayerInitialSpawn(ply)

	hook.Run("oasis/player/initial-spawn", ply)
end

function GM:PlayerSpawn(ply, transition)
	self.BaseClass:PlayerSpawn(ply, transition)

	hook.Run("oasis/player/spawned", ply, transition)
end
