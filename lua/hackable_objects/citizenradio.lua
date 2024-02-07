-- Citizen Radio

local Object = {}
Object.Type = 1
Object.Name = "Citizen Radio"
Object.Description2 = "Hackable object"
Object.Model = "models/props_lab/citizenradio.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 1, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to play sound"}, 
	{}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		ent:EmitSound("modem_up.mp3")
	end
end

gctOS.AddObject(Object)