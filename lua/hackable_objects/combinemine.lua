-- Combine Mine

local Object = {}
Object.Type = 1
Object.Name = "Combine Mine"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "combine_mine"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 2, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to disarm"}, 
	{Cost = 4, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to explode"}, 
	{}, 
	{}
}

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent:Fire("Disarm")
		gctOS.SetHackUsed(ent, 1, true)
		gctOS.SetHackUsed(ent, 2, true)
	end
end

Object.Hacks[2].Hack = function(ply, ent)
	if(SERVER) then
		explode(ent:GetPos(), 15)
		ent:Remove()
	end
end

gctOS.AddObject(Object)