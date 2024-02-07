-- Combine Monitors

local Object = {}
Object.Type = 1
Object.Name = "Monitors"
Object.Description2 = "Hackable object"
Object.Model = "models/props_combine/combine_intmonitor001.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 1, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to show DedSec"}, 
	{}, 
	{}, 
	{}
}

Object.Init = function(ent)
	ent:SetSubMaterial(2, "DedSec_Animation")
end

Object.Hacks[1].Hack = function(ply, ent)
	ent:SetSkin(1)
end

gctOS.AddObject(Object)