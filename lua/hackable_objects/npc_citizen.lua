-- Citizen

local icons = {
	["female_01.mdl"] = {"newphotos/avatars/female01_1.png", "newphotos/avatars/female01_2.png", "newphotos/avatars/female01_3.png"},
	["female_02.mdl"] = {"newphotos/avatars/female02_1.png", "newphotos/avatars/female02_2.png", "newphotos/avatars/female02_3.png"},
	["female_03.mdl"] = {"newphotos/avatars/female03_1.png", "newphotos/avatars/female03_2.png", "newphotos/avatars/female03_3.png"},
	["female_04.mdl"] = {"newphotos/avatars/female04_1.png", "newphotos/avatars/female04_2.png", "newphotos/avatars/female04_3.png"},
	["female_06.mdl"] = {"newphotos/avatars/female06_1.png", "newphotos/avatars/female06_2.png", "newphotos/avatars/female06_3.png"},
	["female_07.mdl"] = {"newphotos/avatars/female06_1.png", "newphotos/avatars/female06_2.png", "newphotos/avatars/female06_3.png"},
	["male_01.mdl"] = {"newphotos/avatars/male01_1.png", "newphotos/avatars/male01_2.png", "newphotos/avatars/male01_3.png"},
	["male_02.mdl"] = {"newphotos/avatars/male02_1.png", "newphotos/avatars/male02_2.png", "newphotos/avatars/male02_3.png"},
	["male_03.mdl"] = {"newphotos/avatars/male03_1.png", "newphotos/avatars/male03_2.png", "newphotos/avatars/male03_3.png"},
	["male_04.mdl"] = {"newphotos/avatars/male04_1.png", "newphotos/avatars/male04_2.png", "newphotos/avatars/male04_3.png"},
	["male_05.mdl"] = {"newphotos/avatars/male05_1.png", "newphotos/avatars/male05_2.png", "newphotos/avatars/male05_3.png"},
	["male_06.mdl"] = {"newphotos/avatars/male06_1.png", "newphotos/avatars/male06_2.png", "newphotos/avatars/male06_3.png"},
	["male_07.mdl"] = {"newphotos/avatars/male07_1.png", "newphotos/avatars/male07_2.png", "newphotos/avatars/male07_3.png"},
	["male_08.mdl"] = {"newphotos/avatars/male08_1.png", "newphotos/avatars/male08_2.png", "newphotos/avatars/male08_3.png"},
	["male_09.mdl"] = {"newphotos/avatars/male09_1.png", "newphotos/avatars/male09_2.png", "newphotos/avatars/male09_3.png"},
}

local Object = {}
Object.Type = 2
Object.Name = "Citizen"
Object.Description2 = ""
Object.Info1 = ""
Object.Info2 = ""
Object.Icon = ""
Object.Model = "any"
Object.Class = "npc_citizen"
Object.MaxHacks = 2
Object.IconColor = Color(0, 0, 0)
Object.Color = Color(6, 171, 240)
Object.Hacks = {
	{Cost = -math.random(2, 4), Available = true, Icon = "hack_botnet.png", Description = "Botnet resources"}, 
	{Cost = 4, Available = true, Icon = "hack_phonedest.png", Description = "Kill"}, 
	{Cost = 3, Available = true, Icon = "hack_combine.png", Description = ""}, 
	{Cost = 3, Available = true, Icon = "hack_resistance.png", Description = ""}
}
Object.Init = function(ent)
	if(SERVER) then
		gctOS.SetHackStatus(ent, 1, true)
	end
	timer.Simple(FrameTime(), function()
		if(string.StartWith(string.Split(ent:GetModel(), "/")[#string.Split(ent:GetModel(), "/")], "male") || string.StartWith(string.Split(ent:GetModel(), "/")[#string.Split(ent:GetModel(), "/")], "female")) then
			ent.Profiler.IColor = Color(math.random(0, 255), math.random(0, 255), math.random(0, 255))
			ent.Profiler.Emotion = "good"..math.random(1, 2)
			ent.Profiler.Color = Color(0, 180, 255)
			ent.Profiler.Description2 = "Botnet recharge"
			if(string.StartWith(string.Split(ent:GetModel(), "/")[#string.Split(ent:GetModel(), "/")], "male")) then
				ent.Profiler.Name = table.Random(gctOS.CitizensInfo.Lastnames)..", "..table.Random(gctOS.CitizensInfo.MaleFirstnames)
			else
				ent.Profiler.Name = table.Random(gctOS.CitizensInfo.Lastnames)..", "..table.Random(gctOS.CitizensInfo.FemaleFirstnames)
			end
			ent.Profiler.Description = table.Random(gctOS.CitizensInfo.Facts)
			local ind = math.random(1, #gctOS.CitizensInfo.Occupations)
			ent.Profiler.Info1 = gctOS.CitizensInfo.Occupations[ind]
			local rand = math.random(gctOS.CitizensInfo.Incomes[ind][1], gctOS.CitizensInfo.Incomes[ind][2])
			ent.Profiler.Info2 = "Income  $"..string.SetChar(string.SetChar(string.Comma(rand), #string.Comma(rand), 0), #string.Comma(rand)-1, 0)
			ent.Profiler.Icon = "citizens/"..table.Random(icons[string.Split(ent:GetModel(), "/")[#string.Split(ent:GetModel(), "/")]])
			--ent.Profiler.Icon = "materials/spawnicons/"..string.Replace(ent:GetModel(), ".mdl", "_64.png")
		else
		ent.Profiler.IColor = Color(0, 0, 0, 255)
		ent.Profiler.Name = "Scan Error, Error"
		ent.Profiler.Description = "NO RECORD"
		ent.Profiler.Description2 = ""
		ent.Profiler.Icon = "citizens/glitch.png"
		ent.Profiler.Info1 = "Scan Error"
		ent.Profiler.Info2 = "Scan Error"
		ent.Profiler.Color = Color(200, 200, 200)
		ent.Profiler.Emotion = ""
		end
	end)
end

Object.Hacks[1].Hack = function(ply, ent, self)
	if(SERVER) then
		gctOS.SetHackStatus(ent, 1, false)
	end
	gctOS.PFuncs.SetColor2(ent, Color(245, 245, 245))
	ent:SetNWString("PDesc2", "")
end
Object.Hacks[2].Hack = function(ply, ent, self)
	if(SERVER) then
		local effect = EffectData()
		effect:SetOrigin(ent:GetBonePosition(0))
		util.Effect("StunstickImpact", effect)
		ent:Ignite(0, 0)
	end	
end
Object.Hacks[3].Hack = function(ply, ent, self)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 3, true)
		timer.Simple(5, function()
			if(IsValid(ent)) then
				for k, e in pairs(ents.FindInSphere(ent:GetPos(), 10000)) do
					if(e:GetClass()=="npc_combine_s" || e:GetClass()=="npc_metropolice") then
						e:StopMoving()
						e:SetLastPosition(ent:GetPos())
						e:SetSchedule(SCHED_FORCED_GO_RUN)
					end
				end
			end
		end)
	end
	if(CLIENT) then
		startAcquired("Information database", "Access granted:", "Sending target location", Color(248, 42, 0), "hacks/hack_combine.png")
		startProgress("Progress", "Forging Evidence", 5)
		timer.Simple(6, function()
			if(IsValid(ent)) then 
				startAcquired("Combine Database", "Criminal profile forged", "Resistance membership", Color(248, 42, 0), {gctOS.PFuncs.GetType2(ent).Icon, gctOS.PFuncs.GetType2(ent).IColor})
			end
		end)
	end
end
Object.Hacks[4].Hack = function(ply, ent, self)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 4, true)
		timer.Simple(5, function()
			if(IsValid(ent)) then
				for k, e in pairs(ents.FindInSphere(ent:GetPos(), 10000)) do
					if(e:GetClass()=="npc_citizen" || e:GetClass()=="npc_alyx" || e:GetClass()=="npc_barney") then
						e:AddEntityRelationship(ent, D_HT, 999)
						e:StopMoving()
						e:SetLastPosition(ent:GetPos())
						e:SetSchedule(SCHED_FORCED_GO_RUN)
					end
				end
			end
		end)
	end
	if(CLIENT) then
		startAcquired("Information database", "Access granted:", "Sending target location", Color(248, 42, 0), "hacks/hack_resistance.png")
		startProgress("Progress", "Providing Evidence", 5)
		timer.Simple(6, function() 
			if(IsValid(ent)) then
				startAcquired("Resistance Network", "Resistance member assigned", "I found your traitor.", Color(248, 42, 0), {gctOS.PFuncs.GetType2(ent).Icon, gctOS.PFuncs.GetType2(ent).IColor})
			end
		end)
	end
end

gctOS.AddObject(Object)