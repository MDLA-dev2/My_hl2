GM.Name = "Oasis RP"
GM.Author = "Oasis Development Team"
GM.Email = ""
GM.Website = ""

DeriveGamemode("sandbox")

OasisRP = OasisRP or {}
OasisRP.Version = "1.0.0"
OasisRP.FolderName = GM.FolderName or "oasis_rp"

if SERVER then
	AddCSLuaFile("core/cl_theme.lua")
	AddCSLuaFile("core/sh_loader.lua")
end

include("core/sh_loader.lua")

if CLIENT then
	include("core/cl_theme.lua")
end
