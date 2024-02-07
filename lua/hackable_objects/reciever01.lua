-- Reciever

local Object = {}
Object.Type = 1
Object.Name = "Reciever"
Object.Description2 = "Botnet resources"
Object.Model = "models/props_lab/reciever01a.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{DrawRhomb = true, Cost = -math.random(2, 4), Available = true, Used = false, Icon = "hack_botnet.png", Description = "Hack to get botnet"}, 
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