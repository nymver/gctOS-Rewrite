-- Washing Machine

local Object = {}
Object.Type = 1
Object.Name = "Washing Machine"
Object.Description2 = "Hackable object"
Object.Model = "models/props_c17/FurnitureWashingmachine001a.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 1, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to shake"}, 
	{}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		for i = 1, 500 do
			timer.Simple(i/50,function()
				if(ent:IsValid()) then
					ent:GetPhysicsObject():SetVelocity(VectorRand(-50, 50))
				end
			end)
		end
	end
end

gctOS.AddObject(Object)