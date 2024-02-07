-- SCars Car

if(SCarRegister) then
	local Object = {}
	Object.Type = 2
	Object.Name = ""
	Object.Description2 = ""
	Object.Model = "any"
	Object.Class = {}
	Object.MaxHacks = 1
	Object.Hacks = {
		{Cost = 2, Available = true, Used = false, Icon = "hack_vforward.png", Description = "Hack to drive forward"}, 
		{Cost = 2, Available = true, Used = false, Icon = "hack_vback.png", Description = "Hack to drive back"}, 
		{Cost = 1, Available = true, Used = false, Icon = "hack_vleft.png", Description = "Hack to drive left"}, 
		{Cost = 1, Available = true, Used = false, Icon = "hack_vright.png", Description = "Hack to drive right"} 
	}
	Object.Car = true

	for k, v in pairs(SCarRegister.CarInfo) do
		table.insert(Object.Class, v.EntName)
	end

	Object.Init = function(ent)
		if(SERVER) then
			ent.Profiler.IColor = Color(0, 0, 0, 1)
			ent.Profiler.Name = ""
			ent.Profiler.Description2 = ""
			ent.Profiler.Description = ent.PrintName
			ent.Profiler.Icon = "profiler2_icons/scars.png"
			ent.Profiler.Info1 = "SCars Vehicle"
			ent.Profiler.Info2 = "State: "..math.Round(((ent.CarHealth/ent.CarMaxHealth)*100)).."/100%"
			ent.Profiler.Color = Color(200, 200, 200)
			hook.Add("Think", "gctOS_ObjThink_"..ent:EntIndex(), function() 
				if(!IsValid(ent)) then
					hook.Remove("Think", "gctOS_ObjThink_"..ent:EntIndex())
				end
				if(IsValid(ent) && ent:GetNWString("PInfo2") != "State: "..math.Round(((ent.CarHealth/ent.CarMaxHealth)*100)).."/100%") then
					ent:SetNWString("PInfo2", "State: "..math.Round(((ent.CarHealth/ent.CarMaxHealth)*100)).."/100%")
				end
			end)
		end
	end

	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			if(!ent:GetNWBool("Drive1")) then
				ent:SetNWBool("Drive1", true)
				ent:SetNWBool("Drive2", false)
				ent.HasDriver = function() return true end
				ent.SpecialThink = function() end
				ent:HandBrakeOff()
				ent:StartCar()
				ent:GoNeutral()
				ent:GoForward(1)
				if(car_time:GetInt() != 11) then
					timer.Simple(car_time:GetInt(), function() 
						if(IsValid(ent)) then 
							ent:SetNWBool("Drive1", false)
							ent:SetNWBool("Drive2", false)
							ent:GoNeutral()
							ent:HandBrakeOn()
						end
					end)
				end
			else
				ent:SetNWBool("Drive1", false)
				ent:SetNWBool("Drive2", false)
				ent:GoNeutral()
				ent:HandBrakeOn()
			end
		end
	end

	Object.Hacks[2].Hack = function(ply, ent)
		if(SERVER) then
			if(!ent:GetNWBool("Drive2")) then
				ent:SetNWBool("Drive1", false)
				ent:SetNWBool("Drive2", true)
				ent.HasDriver = function() return true end
				ent.SpecialThink = function() end
				ent:HandBrakeOff()
				ent:StartCar()
				ent:GoNeutral()
				ent:GoBack(1)
				if(car_time:GetInt() != 11) then
					timer.Simple(car_time:GetInt(), function() 
						if(IsValid(ent)) then 
							ent:SetNWBool("Drive1", false)
							ent:SetNWBool("Drive2", false)
							ent:GoNeutral()
							ent:HandBrakeOn()
						end
					end)
				end
			else
				ent:SetNWBool("Drive1", false)
				ent:SetNWBool("Drive2", false)
				ent:GoNeutral()
				ent:HandBrakeOn()
			end
		end
	end

	Object.Hacks[3].Hack = function(ply, ent)
		if(SERVER) then
			if(!ent:GetNWBool("Steer1")) then
				ent:SetNWBool("Steer1", true)
				ent:SetNWBool("Steer2", false)
				ent:TurnLeft()
			else
				ent:SetNWBool("Steer1", false)
				ent:SetNWBool("Steer2", false)
				ent:NotTurning()
			end
		end	
	end

	Object.Hacks[4].Hack = function(ply, ent)
		if(SERVER) then
			if(!ent:GetNWBool("Steer2")) then
				ent:SetNWBool("Steer1", false)
				ent:SetNWBool("Steer2", true)
				ent:TurnRight()
			else
				ent:SetNWBool("Steer1", false)
				ent:SetNWBool("Steer2", false)
				ent:NotTurning()
			end
		end	
	end

	gctOS.AddObject(Object)
end