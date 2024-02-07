-- Camera

local Object = {}
Object.Name = "Camera"
Object.Type = 3
Object.Model = "models/props_lab/huladoll.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hack = function(ply, ent)
	if(CLIENT) then 
		net.Start("gctOS_CamHack")
		net.WriteEntity(ent)
		net.SendToServer()
	end
end

gctOS.AddObject(Object)