-- PC Tower

local Object = {}
Object.Type = 1
Object.Name = "PC Tower"
Object.Description2 = "Hackable object"
Object.Model = "models/props_lab/harddrive02.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = math.random(-2, -4), Available = true, Used = false, Icon = "hack_botnet.png", Description = "Hack to get botnet"}, 
	{}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackStatus(ent, 1, false)
	end
end

gctOS.AddObject(Object)