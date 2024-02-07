-- Rollermine

local Object = {}
Object.Type = 1
Object.Name = "Rollermine"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "npc_rollermine"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 3, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to make friendly"}, 
	{Cost = 2, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"}, 
	{}, 
	{Cost = 4, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to destruct"}, 
}
local Friends = {"npc_monk", "npc_alyx", "npc_barney", "npc_citizen", "npc_dog", "npc_vortigaunt", "npc_kleiner", "npc_eli", "npc_mossman", "player"}
local Hostiles = {"npc_turret_ceiling", "npc_combine_s", "npc_combinegunship", "npc_combinedropship","npc_cscanner", "npc_clawscanner", "npc_turret_floor", "npc_helicopter", "npc_manhack", "npc_stalker", "npc_rollermine", "npc_strider", "npc_metropolice", "npc_cscanner",  "npc_combine_camera"}

Object.Init = function(ent)
	ent.Toggle = true
end
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent:Fire("Ally")
		--[[
		for k, v in pairs(Friends) do ent:AddRelationship(v.." D_LI 999") end
		for k, v in pairs(Hostiles) do ent:AddRelationship(v.." D_HT 999") end
		for k, v in pairs(ents.GetAll()) do
			if(v.IsNPC()) then
				if(table.HasValue(Friends, v:GetClass())) then
					v:AddEntityRelationship(ent, D_LI, 999)
				end
				if(table.HasValue(Hostiles, v:GetClass())) then
					v:AddEntityRelationship(ent, D_HT, 999)

				end
			end
		end
		gctOS.SetHackUsed(ent, 1, true)]]
	end
end

Object.Hacks[2].Hack = function(ply, ent)
	if(SERVER) then
		ent:Fire(ent.Toggle && "TurnOff" || "TurnOn")
		ent.Toggle = !ent.Toggle
	end
end

Object.Hacks[4].Hack = function(ply, ent)
	if(SERVER) then
		ent:Fire("InteractivePowerDown")
	end
end

gctOS.AddObject(Object)