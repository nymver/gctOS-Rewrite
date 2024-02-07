-- Lamp

local Object = {}
Object.Type = 1
Object.Name = "Lamp"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "gmod_lamp"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 0, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"}, 
	{}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent:SetOn(!ent:GetOn())
	end
end

gctOS.AddObject(Object)