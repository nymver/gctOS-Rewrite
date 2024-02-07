-- Elevator Door

local Object = {}
Object.Type = 1
Object.Name = "Elevator Door"
Object.Description2 = "Hackable object"
Object.Model = "models/props_lab/elevatordoor.mdl"
Object.Class = "prop_dynamic"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 0, Available = true, Used = false, Icon = "hack_door.png", Description = "Hack to open or close"}, 
	{}, 
	{}, 
	{}
}

Object.Init = function(ent)
	ent.Closed = false
end

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent.Closed = !ent.Closed	
		ent:Fire("setanimation", ent.Closed && "open" || "close")
	end
end

gctOS.AddObject(Object)