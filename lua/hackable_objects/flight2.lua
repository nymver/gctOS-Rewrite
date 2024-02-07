-- Lamp

local Object = {}
Object.Type = 1
Object.Name = "Lamp"
Object.Description2 = "Hackable object"
Object.Model = "models/props_lab/desklamp01.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 0, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle light"}, 
	{}, 
	{}, 
	{}
}

Object.Init = function(ent)
	if(CLIENT) then
		hook.Add("Think", "gctOS_ObjThink_"..ent:EntIndex(), function() 
			if(IsValid(ent)) then
				if(ent:GetNWBool("gctOS_LightToggle")) then
			         local light = DynamicLight(ent:EntIndex())
			         if(light) then
			            light.pos = ent:GetPos()
			            light.r = 255
			            light.g = 255
			            light.b = 255
			            light.brightness = 1
			            light.Decay = 1000
			            light.Size = 128
			            light.DieTime = CurTime() + 1
			         end
				end
			else
				hook.Remove("Think", "gctOS_ObjThink_"..ent:EntIndex())
			end
		end)
	end
end

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent:SetNWBool("gctOS_LightToggle", !ent:GetNWBool("gctOS_LightToggle"))
	end
end

gctOS.AddObject(Object)