-- Alydus Base Controller

local Object = {}
Object.Type = 1
Object.Name = "Alydus Base Controller"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "alydusbasesystems_basecontroller"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 3, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to claim"}, 
	{Cost = 4, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to destroy"}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		ent:SetNWEntity("alydusBaseSystems.Owner", ply)
	end
end
Object.Hacks[2].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		gctOS.SetHackUsed(ent, 2, true)
		ent:TakeDamage(ent:GetNWInt("alydusBaseSystems.Health"))
	end
end

gctOS.AddObject(Object)

-- Alydus Camera

local Object = {}
Object.Type = 1
Object.Name = "Alydus Camera"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "alydusbasesystems_module_camera"
Object.MaxHacks = 3
Object.Hacks = {
	{Cost = 3, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to claim"}, 
	{Cost = 0, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to connect"}, 
	{}, 
	{Cost = 4, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to destroy"}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		ent:SetNWEntity("alydusBaseSystems.Owner", ply)
	end
end
Object.Hacks[2].Hack = function(ply, ent)
	if(CLIENT) then
		net.Start("alydusBaseSystems.joinCameraUplink")
		net.WriteEntity(ents.FindByClass("alydusbasesystems_basecontroller")[1])
		net.SendToServer()
	end
end
Object.Hacks[4].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		gctOS.SetHackUsed(ent, 2, true)
		gctOS.SetHackUsed(ent, 4, true)
		ent:TakeDamage(ent:GetNWInt("alydusBaseSystems.Health"))
	end
end

gctOS.AddObject(Object)

-- Alydus Manual Turret

local Object = {}
Object.Type = 1
Object.Name = "Alydus Manual Turret"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "alydusbasesystems_module_manualgunturret"
Object.MaxHacks = 3
Object.Hacks = {
	{Cost = 3, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to claim"}, 
	{Cost = 1, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to connect"}, 
	{}, 
	{Cost = 4, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to destroy"}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		ent:SetNWEntity("alydusBaseSystems.Owner", ply)
	end
end
Object.Hacks[2].Hack = function(ply, ent)
	if(CLIENT) then
		net.Start("alydusBaseSystems.joinGunTurretUplink")
		net.WriteEntity(ents.FindByClass("alydusbasesystems_basecontroller")[1])
		net.SendToServer()
	end
end
Object.Hacks[4].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		gctOS.SetHackUsed(ent, 2, true)
		gctOS.SetHackUsed(ent, 4, true)
		ent:TakeDamage(ent:GetNWInt("alydusBaseSystems.Health"))
	end
end

gctOS.AddObject(Object)

-- Alydus Gun Turret

local Object = {}
Object.Type = 1
Object.Name = "Alydus Gun Turret"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "alydusbasesystems_module_gunturret"
Object.MaxHacks = 2
Object.Hacks = {
	{Cost = 3, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to claim"}, 
	{Cost = 4, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to destroy"}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		ent:SetNWEntity("alydusBaseSystems.Owner", ply)
	end
end
Object.Hacks[2].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		gctOS.SetHackUsed(ent, 2, true)
		gctOS.SetHackUsed(ent, 4, true)
		ent:TakeDamage(ent:GetNWInt("alydusBaseSystems.Health"))
	end
end

gctOS.AddObject(Object)

-- Alydus Laser Turret

local Object = {}
Object.Type = 1
Object.Name = "Alydus Laser Turret"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "alydusbasesystems_module_laserturret"
Object.MaxHacks = 2
Object.Hacks = {
	{Cost = 3, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to claim"}, 
	{Cost = 4, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to destroy"}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		ent:SetNWEntity("alydusBaseSystems.Owner", ply)
	end
end
Object.Hacks[2].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		gctOS.SetHackUsed(ent, 2, true)
		gctOS.SetHackUsed(ent, 4, true)
		ent:TakeDamage(ent:GetNWInt("alydusBaseSystems.Health"))
	end
end

gctOS.AddObject(Object)
