-- Drones

local Object = {}
Object.Name = "Drone"
Object.Type = 3
Object.Model = "any"
Object.Class = "dronesrewrite_ardrone"
Object.MaxHacks = 1
Object.Hack = function(ply, ent)
	if(SERVER) then
		ent:SetDriver(ply)
	end
end

gctOS.AddObject(Object)