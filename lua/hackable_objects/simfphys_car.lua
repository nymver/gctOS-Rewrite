-- Simfphys Car

local Object = {}
Object.Type = 2
Object.Name = ""
Object.Description2 = ""
Object.Model = "any"
Object.Class = "gmod_sent_vehicle_fphysics_base"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 2, Available = true, Used = false, Icon = "hack_vforward.png", Description = "Hack to drive forward"}, 
	{Cost = 2, Available = true, Used = false, Icon = "hack_vback.png", Description = "Hack to drive back"}, 
	{Cost = 1, Available = true, Used = false, Icon = "hack_vleft.png", Description = "Hack to drive left"}, 
	{Cost = 1, Available = true, Used = false, Icon = "hack_vright.png", Description = "Hack to drive right"} 
}
Object.Car = true

Object.Init = function(ent)
	local l = string.sub(string.Split(ent:GetModel(), "/")[#string.Split(ent:GetModel(), "/")], 0, #string.Split(ent:GetModel(), "/")[#string.Split(ent:GetModel(), "/")]-4)
	ent.Profiler.IColor = Color(0, 0, 0, 1)
	ent.Profiler.Name = ""
	ent.Profiler.Description2 = ""
	ent.Profiler.Description = l
	ent.Profiler.Icon = "profiler2_icons/simfphys.png"
	ent.Profiler.Info1 = "Simfphys Vehicle"
	ent.Profiler.Info2 = "State: "..math.Round(((ent:GetCurHealth()/ent:GetMaxHealth())*100)).."/100%"
	ent.Profiler.Color = Color(200, 200, 200)
	hook.Add("Think", "gctOS_ObjThink_"..ent:EntIndex(), function() 
		if(!IsValid(ent)) then
			hook.Remove("Think", "gctOS_ObjThink_"..ent:EntIndex())
		end
		if(IsValid(ent) && ent:GetNWString("PInfo2") != "State: "..math.Round(((ent:GetCurHealth()/ent:GetMaxHealth())*100)).."/100%") then
			ent:SetNWString("PInfo2", "State: "..math.Round(((ent:GetCurHealth()/ent:GetMaxHealth())*100)).."/100%")
		end
	end)
end

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		if(ent.PressedKeys["W"]) then
			ent.PressedKeys["Space"] = true
			ent.PressedKeys["W"] = false
			ent.PressedKeys["S"] = false
		else
			ent:SetActive(true)
			ent:StartEngine()
			ent.PressedKeys["Space"] = false
			ent.PressedKeys["W"] = true
			ent.PressedKeys["S"] = false	
			if(car_time:GetInt() != 11) then
				timer.Simple(car_time:GetInt(), function() 
					if(IsValid(ent)) then 
						ent.PressedKeys["Space"] = true
						ent.PressedKeys["W"] = false
						ent.PressedKeys["S"] = false
					end
				end)
			end
		end
	end
end

Object.Hacks[2].Hack = function(ply, ent)
	if(SERVER) then
		if(ent.PressedKeys["S"]) then
			ent.PressedKeys["Space"] = true
			ent.PressedKeys["W"] = false
			ent.PressedKeys["S"] = false
		else
			ent:SetActive(true)
			ent:StartEngine()
			ent.PressedKeys["Space"] = false
			ent.PressedKeys["W"] = false
			ent.PressedKeys["S"] = true	
			if(car_time:GetInt() != 11) then
				timer.Simple(car_time:GetInt(), function() 
					if(IsValid(ent)) then 
						ent.PressedKeys["Space"] = true
						ent.PressedKeys["W"] = false
						ent.PressedKeys["S"] = false
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
			ent:PlayerSteerVehicle(ply, 0, 0)
			ent:PlayerSteerVehicle(ply, 1, 0)
			ent:SetNWBool("Steer1", true)
		else
			ent:PlayerSteerVehicle(ply, 0, 0)
			ent:PlayerSteerVehicle(ply, 0, 0)
			ent:SetNWBool("Steer1", false)
			ent:SetNWBool("Steer2", false)
		end
	end	
end

Object.Hacks[4].Hack = function(ply, ent)
	if(SERVER) then
		if(!ent:GetNWBool("Steer2")) then
			ent:SetNWBool("Steer1", false)		
			ent:PlayerSteerVehicle(ply, 0, 0)
			ent:PlayerSteerVehicle(ply, 0, 1)
			ent:SetNWBool("Steer2", true)
		else
			ent:PlayerSteerVehicle(ply, 0, 0)		
			ent:PlayerSteerVehicle(ply, 0, 0)
			ent:SetNWBool("Steer2", false)
			ent:SetNWBool("Steer1", false)
		end
	end	
end

gctOS.AddObject(Object)