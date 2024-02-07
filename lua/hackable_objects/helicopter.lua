-- Helicopter

local Object = {}
Object.Type = 1
Object.Name = "Helicopter"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "npc_helicopter"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 3, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle turret"}, 
	{Cost = 3, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to drop bomb"}, 
	{}, 
	{Cost = 4, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to destroy"}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent:Fire("Gun"..(ent:GetNWBool("TURRET") && "On" || "Off"))
		ent:SetNWBool("TURRET", !ent:GetNWBool("TURRET"))
	end
end
Object.Hacks[2].Hack = function(ply, ent)
	if(SERVER) then
		ent:Fire("DropBomb")
		gctOS.SetHackUsed(ent, 2, true)
		timer.Simple(5, function() 
			gctOS.SetHackUsed(ent, 2, false)
		end)
	end
end
Object.Hacks[4].Hack = function(ply, ent)
	if(SERVER) then
		ent:Fire("SelfDestruct")
	end
end

gctOS.AddObject(Object)