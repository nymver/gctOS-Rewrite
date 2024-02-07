-- Server

local Object = {}
Object.Type = 1
Object.Name = "Server"
Object.Description2 = "Hackable object"
Object.Model = "models/props_lab/servers.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = math.random(-4, -6), Available = true, Used = false, Icon = "hack_botnet.png", Description = "Hack to get botnet"}, 
	{}, 
	{}, 
	{Cost = 3, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to cause overload"}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackStatus(ent, 1, false)
	end
end

Object.Hacks[4].Hack = function(ply, ent)
	if(SERVER) then
		explode(ent:GetPos(), 150)
		gctOS.SetHackUsed(ent, 1, true)
		gctOS.SetHackUsed(ent, 4, true)
	end
end

gctOS.AddObject(Object)