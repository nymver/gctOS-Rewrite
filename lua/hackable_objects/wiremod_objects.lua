if(WireLib) then
	-- Wire Console Screen

	local Object = {}
	Object.Type = 1
	Object.Name = "Wire Console Screen"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "gmod_wire_consolescreen"
	Object.MaxHacks = 1
	Object.Hacks = {
		{Cost = 2, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to set text"}, 
		{Cost = 1, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"}, 
		{}, 
		{}
	}

	local function getcolor(r, g, b, r1, g1, b1)
		return tonumber((0)..math.floor((r/255)*9)..math.floor((g/255)*9)..math.floor((b/255)*9)..math.floor((r1/255)*9)..math.floor((g1/255)*9)..math.floor((b1/255)*9))
	end

	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			local color = ply:GetNWVector("SS_BGCOLOR")
			local color1 = ply:GetNWVector("SS_FGCOLOR")
			for i = 0, 55 do -- Background
				for k = 0, 55 do
					ent.CharY = i
					ent.CharX = k
					ent.Char = 0
					ent.CharParam = getcolor(color.x, color.y, color.z, color1.x, color1.y, color1.z)
					ent:SendPixel()
				end
			end
			for i = 1, #ply:GetNWString("SS_TEXT") do
				ent.CharY = 1
				ent.CharX = i
				ent.Char = utf8.codepoint(string.GetChar(ply:GetNWString("SS_TEXT"), i))
				ent.CharParam = getcolor(color.x, color.y, color.z, color1.x, color1.y, color1.z)
				ent:SendPixel()	
			end
		end
	end
	Object.Hacks[2].Hack = function(ply, ent)
		if(SERVER) then
			ent:TriggerInput("String", "")
			ent:TriggerInput("FGColor", Vector())
			ent:TriggerInput("BGColor", Vector())	
		end
	end

	gctOS.AddObject(Object)

	-- Wire Expression 2

	local Object = {}
	Object.Type = 1
	Object.Name = "Wire Expression 2"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "gmod_wire_expression2"
	Object.MaxHacks = 1
	Object.Hacks = {
		{Cost = math.random(-2, -4), Available = true, Used = false, Icon = "hack_botnet.png", Description = "Hack to get botnet"}, 
		{Cost = 2, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to overload"}, 
		{},
		{}
	}

	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			ent:SetNWBool("Available1", false)
		end
	end
	Object.Hacks[2].Hack = function(ply, ent)
		if(SERVER) then
			ent:Error("Expression 2 (" .. ent.name .. "): tick quota exceeded", "tick quota exceeded")
		end
	end

	gctOS.AddObject(Object)

	-- Wire Text Screen

	local Object = {}
	Object.Type = 1
	Object.Name = "Wire Text Screen"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "gmod_wire_textscreen"
	Object.MaxHacks = 1
	Object.Hacks = {
		{Cost = 2, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to set text"}, 
		{Cost = 1, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"}, 
		{}, 
		{}
	}

	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			ent:TriggerInput("String", ply:GetNWString("SS_TEXT"))
			ent:TriggerInput("FGColor", ply:GetNWVector("SS_FGCOLOR"))
			ent:TriggerInput("BGColor", ply:GetNWVector("SS_BGCOLOR"))	
		end
	end
	Object.Hacks[2].Hack = function(ply, ent)
		if(SERVER) then
			ent:TriggerInput("String", "")
			ent:TriggerInput("FGColor", Vector())
			ent:TriggerInput("BGColor", Vector())	
		end
	end

	gctOS.AddObject(Object)

	-- Wire Keypad

	local Object = {}
	Object.Type = 1
	Object.Name = "Wire Keypad"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "gmod_wire_keypad"
	Object.MaxHacks = 1
	Object.Hacks = {
		{Cost = 2, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to lock or unlock"}, 
		{Cost = 3, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to disable"}, 
		{}, 
		{}
	}

	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			if(ent:GetNWString("keypad_display") != "y") then
				ent:SetNWString("keypad_display", "y")
				Wire_TriggerOutput(ent, "Valid", 1)
				Wire_TriggerOutput(ent, "Invalid", 0)
				ent:EmitSound("buttons/button9.wav")
			else
				ent:SetNWString("keypad_display", "n")
				Wire_TriggerOutput(ent, "Valid", 0)
				Wire_TriggerOutput(ent, "Invalid", 1)
				ent:EmitSound("buttons/button8.wav")
			end
		end
	end
	Object.Hacks[2].Hack = function(ply, ent)
		if(SERVER) then
			local effectdata = EffectData()
			effectdata:SetOrigin(ent:LocalToWorld(Vector(0, 0, 0)))
			effectdata:SetAngles(ent:LocalToWorldAngles(Angle(0, 90, 90)))
			effectdata:SetScale(0.001)
			util.Effect("stunstickimpact", effectdata, true, true)	
			Wire_TriggerOutput(ent, "Valid", 0)
			Wire_TriggerOutput(ent, "Invalid", 0)
			if(ent:GetNWBool("gctOS_Disabled")==false) then
				ent:SetNWBool("gctOS_Disabled", true)
				gctOS.SetHackUsed(ent, 1, true)
				hook.Add("Think", "gctOS_ObjThink_"..ent:EntIndex(), function()
					ent:SetNWString("keypad_display", "")
				end)
			else
				ent:SetNWBool("gctOS_Disabled", false)
				gctOS.SetHackUsed(ent, 1, false)
				hook.Remove("Think", "gctOS_ObjThink_"..ent:EntIndex())
			end
		end
	end

	gctOS.AddObject(Object)

	-- Wire Turret

	local Object = {}
	Object.Type = 1
	Object.Name = "Wire Turret"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "gmod_wire_turret"
	Object.MaxHacks = 1
	Object.Hacks = {
		{Cost = 2, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to toggle fire"}, 
		{}, 
		{}, 
		{}
	}

	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			ent:TriggerInput("Fire", booltonumber(!ent.Firing))
		end
	end

	gctOS.AddObject(Object)

	-- Wire Sound Emitter

	local Object = {}
	Object.Type = 1
	Object.Name = "Wire Sound Emitter"
	Object.Description2 = "Hackable object"
	Object.Model = "any"
	Object.Class = "gmod_wire_soundemitter"
	Object.MaxHacks = 2
	Object.Hacks = {
		{Cost = 1, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to toggle"}, 
		{Cost = 2, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to play noise"}, 
		{}, 
		{}
	}

	Object.Hacks[1].Hack = function(ply, ent)
		if(SERVER) then
			local active = ent:ReadCell(0)
			if(active!=0) then
				ent:TriggerInput("Play", 0)
				ent:TriggerInput("Stop", 1)
			else
				ent:TriggerInput("Stop", 0)
				ent:TriggerInput("Play", 1)
			end
		end
	end
	Object.Hacks[2].Hack = function(ply, ent)
		if(SERVER) then
			ent:TriggerInput("SampleName", "synth/12_5_pwm_1760.wav")
			ent:TriggerInput("PitchRelative", 1)
			ent:TriggerInput("Volume", 1)
			ent:TriggerInput("Play", 1)
		end
	end
	gctOS.AddObject(Object)
end

