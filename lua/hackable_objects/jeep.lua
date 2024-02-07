-- Jeep

local Object = {}
Object.Type = 2
Object.Name = "Jeep"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "prop_vehicle_jeep"
Object.MaxHacks = 3
Object.Hacks = {
	{Cost = 2, Available = true, Used = false, Icon = "hack_vforward.png", Description = "Hack to drive forward"}, 
	{Cost = 2, Available = true, Used = false, Icon = "hack_vback.png", Description = "Hack to drive back"}, 
	{Cost = 1, Available = true, Used = false, Icon = "hack_vleft.png", Description = "Hack to drive left"}, 
	{Cost = 1, Available = true, Used = false, Icon = "hack_vright.png", Description = "Hack to drive right"} 
}
Object.Car = true

Object.Init = function(ent)
	ent.Profiler.IColor = Color(0, 0, 0, 1)
	ent.Profiler.Name = ""
	ent.Profiler.Description2 = ""
	ent.Profiler.Description = "Jeep"
	ent.Profiler.Icon = "profiler2_icons/hl2.png"
	ent.Profiler.Info1 = "Default Vehicle"
	ent.Profiler.Info2 = ""
	ent.Profiler.Color = Color(200, 200, 200)
end

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		if(ent:GetNWBool("Drive1")) then
			timer.Simple(0.25, function()
				ent:SetThrottle(0)
				ent:Fire("handbrakeon", 1, 0)
				ent:Fire("handbrakeoff", 0, 0)
				ent:SetNWBool("Drive1", false)
			end)
		else
			ent:SetNWBool("Drive2", false)
			ent:Fire("turnoff", 0, 0)
			ent:Fire("handbrakeon", 0, 0)
			ent:Fire("handbrakeoff", 1, 0)
			ent:Fire("turnon", 1, 0)
			timer.Simple(0.25, function()
				ent:SetThrottle(1)
			end)
			ent:SetSteering(0, 0)
			ent:SetNWBool("Drive1", true)
			if(car_time:GetInt() != 11) then
				timer.Simple(car_time:GetInt()+0.25, function()
					if(IsValid(ent)) then  
						ent:SetThrottle(0)
						ent:Fire("handbrakeon", 1, 0)
						ent:Fire("handbrakeoff", 0, 0)
						ent:SetNWBool("Drive1", false)
					end
				end)
			end
		end
	end
end

Object.Hacks[2].Hack = function(ply, ent)
	if(SERVER) then
		if(ent:GetNWBool("Drive2")) then
			ent:SetThrottle(0)
			ent:Fire("handbrakeon", 1, 0)
			ent:Fire("handbrakeoff", 0, 0)
			ent:SetNWBool("Drive2", false)
		else
			ent:SetNWBool("Drive1", false)
			ent:Fire("turnoff", 0, 0)
			ent:Fire("handbrakeon", 0, 0)
			ent:Fire("handbrakeoff", 1, 0)
			ent:Fire("turnon", 1, 0)
			timer.Simple(0.25, function()
				ent:SetThrottle(-1)
			end)
			ent:SetSteering(0, 0)
			ent:SetNWBool("Drive2", true)
			if(car_time:GetInt() != 11) then
				timer.Simple(car_time:GetInt()+0.25, function() 
					if(IsValid(ent)) then 
						ent:SetThrottle(0)
						ent:Fire("handbrakeon", 1, 0)
						ent:Fire("handbrakeoff", 0, 0)
						ent:SetNWBool("Drive2", false)
					end
				end)
			end
		end
	end
end

Object.Hacks[3].Hack = function(ply, ent)
	if(SERVER) then
		if(!ent:GetNWBool("Steer1")) then
			ent:SetNWBool("Steer2", false)
			ent:SetSteering(-1, 0)
			ent:SetNWBool("Steer1", true)
		else
			ent:SetSteering(0, 0)
			ent:SetNWBool("Steer1", false)
		end
	end
end

Object.Hacks[4].Hack = function(ply, ent)
	if(SERVER) then
		if(!ent:GetNWBool("Steer2")) then
			ent:SetNWBool("Steer1", false)		
			ent:SetSteering(1, 0)
			ent:SetNWBool("Steer2", true)
		else
			ent:SetSteering(0, 0)
			ent:SetNWBool("Steer2", false)
		end
	end
end


gctOS.AddObject(Object)