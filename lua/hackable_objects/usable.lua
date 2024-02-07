--[[
local Object = {}
Object.Type = 1
Object.Name = "Device"
Object.Description2 = "Hackable object"
Object.MaxHacks = 1
Object.Model = "any"
Object.Class = {"func_button"}
Object.Hacks = {
	{Cost = 1, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to use"}, 
	{}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent:Use(ply)
	end
end

gctOS.AddObject(Object)]]