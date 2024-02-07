if(JMod) then 
	-- JMod Sentry

	local Object = {}
	Object.Type = 1
	Object.Name = "JMod Sentry"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "ent_jack_gmod_ezsentry"
	Object.MaxHacks = 3
	Object.Hacks = {
		{Cost = 2, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"}, 
		{Cost = 4, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to make friendly"}, 
		{}, 
		{Cost = 3, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to overheat"}
	}
	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			ent:SetState(numbertobool(ent:GetState()) && 0 || 1)
		end
	end
	Object.Hacks[2].Hack = function(ply, ent)
		if(SERVER) then
			gctOS.SetHackUsed(ent, 2, true)
			JMod.Owner(ent, ply)
		end
	end
	Object.Hacks[4].Hack = function(ply, ent)
		if(SERVER) then
			gctOS.SetHackUsed(ent, 1, true)
			gctOS.SetHackUsed(ent, 2, true)
			gctOS.SetHackUsed(ent, 4, true)
			ent:SetState(-1)
		end
	end
	gctOS.AddObject(Object)

	-- JMod Fumigator

	local Object = {}
	Object.Type = 1
	Object.Name = "JMod Fumigator"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "ent_jack_gmod_ezfumigator"
	Object.MaxHacks = 3
	Object.Hacks = {
		{Cost = 2, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"}, 
		{},
		{},
		{}
	}
	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			ent:SetState(ent:GetState()==0 && 2 || 0)
		end
	end
	gctOS.AddObject(Object)

	-- JMod Time Bomb

	local Object = {}
	Object.Type = 1
	Object.Name = "JMod Time Bomb"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "ent_jack_gmod_eztimebomb"
	Object.MaxHacks = 3
	Object.Hacks = {
		{Cost = 3, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to explode"}, 
		{Cost = 2, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"},
		{},
		{}
	}
	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			ent:Detonate()
		end
	end
	Object.Hacks[2].Hack = function(ply, ent)
		if(SERVER) then
			ent:SetTimer(10)
			ent:SetState(ent:GetState()==0 && 1 || 0)
		end
	end
	gctOS.AddObject(Object)

	-- JMod SLAM

	local Object = {}
	Object.Type = 1
	Object.Name = "JMod SLAM"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "ent_jack_gmod_ezslam"
	Object.MaxHacks = 3
	Object.Hacks = {
		{Cost = 3, Available = true, Used = false, Icon = "hack_explode.png", Description = "Hack to explode"}, 
		{Cost = 2, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"},
		{},
		{}
	}
	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			ent:Detonate()
		end
	end
	Object.Hacks[2].Hack = function(ply, ent)
		if(SERVER) then
			ent:SetState(ent:GetState()==1 && 4 || 1)
		end
	end
	gctOS.AddObject(Object)

	-- JMod MBHG

	local Object = {}
	Object.Type = 1
	Object.Name = "JMod BH Generator"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "ent_jack_gmod_ezmbhg"
	Object.MaxHacks = 3
	Object.Hacks = {
		{Cost = 4, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"}, 
		{},
		{},
		{}
	}
	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			ent:SetState(ent:GetState()==1 && 4 || 1)
		end
	end
	gctOS.AddObject(Object)

	-- JMod AFH

	local Object = {}
	Object.Type = 1
	Object.Name = "JMod Field Hospital"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "ent_jack_gmod_ezfieldhospital"
	Object.MaxHacks = 3
	Object.Hacks = {
		{Cost = 4, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to kill driver"}, 
		{},
		{},
		{}
	}
	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			ent:GetDriver():Kill()
		end
	end
	gctOS.AddObject(Object)
end