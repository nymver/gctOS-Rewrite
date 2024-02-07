-- Reciever

local Object = {}
Object.Type = 1
Object.Name = "Dog"
Object.Description2 = "Botnet resources"
Object.Model = "any"
Object.Class = "npc_dog"
Object.MaxHacks = 1
Object.Hacks = {
	{DrawRhomb = true, Cost = -math.random(2, 4), Available = true, Used = false, Icon = "hack_botnet.png", Description = "Hack to get botnet units"}, 
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