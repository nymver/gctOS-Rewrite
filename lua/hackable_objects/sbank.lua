-- Monitor

local Object = {}
Object.Type = 1
Object.Name = "Security Bank"
Object.Description2 = "Hackable object"
Object.Model = "models/props_lab/securitybank.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 1, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to show DedSec"}, 
	{}, 
	{}, 
	{}
}

Object.Init = function(ent)
end

Object.Hacks[1].Hack = function(ply, ent)
	ent:SetSubMaterial(1, "DedSec_Animation")
	ent:SetSubMaterial(2, "DedSec_Animation")
end

gctOS.AddObject(Object)