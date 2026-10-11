include("shared.lua")

function GM:Initialize()
	OasisRP.Loader:LoadModules()

	hook.Run("oasis/client/initialized")
end

function GM:InitPostEntity()
	self.BaseClass:InitPostEntity()

	hook.Run("oasis/client/post-entity")
end
