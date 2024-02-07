-- Monitor

local Object = {}
Object.Type = 1
Object.Name = "TV"
Object.Description2 = "Hackable object"
Object.Model = "models/props_c17/tv_monitor01.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 1, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to show DedSec"}, 
	{}, 
	{}, 
	{}
}

Object.Init = function(ent)
	if(CLIENT) then
		hook.Add("PostDrawOpaqueRenderables", "gctOS_ObjPostDrawOpaqueRenderables_"..ent:EntIndex(), function() 
			if(IsValid(ent)) then
				if(ent:GetNWBool("gctOS_DedSec_Screen")) then
			         cam.Start3D2D(ent:LocalToWorld(Vector(5, -10.5, 8)), ent:LocalToWorldAngles(Angle(0, 90, 90-4.5)), 1)
			            surface.SetDrawColor(255, 255, 255)
			            surface.SetMaterial(Material("DedSec_Animation"))
			            surface.DrawTexturedRect(0, 0, 18, 15)
			         cam.End3D2D()
				end
			else
				hook.Remove("PostDrawOpaqueRenderables", "gctOS_ObjPostDrawOpaqueRenderables_"..ent:EntIndex())
			end
		end)
	end
end

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent:SetNWBool("gctOS_DedSec_Screen", !ent:GetNWBool("gctOS_DedSec_Screen"))
	end
end

gctOS.AddObject(Object)