-- Server

local Object = {}
Object.Type = 1
Object.Name = "EFinal"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "gctos_eend"
Object.MaxHacks = 1
Object.NoProfiler = true
Object.Hacks = {
	{Cost = 0, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to get"}, 
	{}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
	Entity(880):Fire("Unlock")
		Entity(880):Fire("Open")
	end
end


gctOS.AddObject(Object)