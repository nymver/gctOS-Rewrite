-- Traffic Lights

local Object = {}
Object.Type = 1
Object.Name = "Traffic Lights"
Object.Description2 = "Hackable object"
Object.Model = {"models/props_phx/misc/t_light_single_b.mdl", "models/props_phx/misc/t_light_single_a.mdl"}
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 2, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to change color"}, 
	{}, 
	{}, 
	{}
}

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		local isa = string.GetChar(ent:GetModel(), #ent:GetModel() - 4) == "a"
		ent:SetModel("models/props_phx/misc/t_light_single_"..(isa && "b" || "a")..".mdl")
	end
end

gctOS.AddObject(Object)