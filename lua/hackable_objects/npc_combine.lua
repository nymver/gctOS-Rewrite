-- Combine Elite

local Object = {}
Object.Type = 2
Object.Name = "Combine"
Object.Description2 = ""
Object.Info1 = ""
Object.Info2 = ""
Object.Icon = ""
Object.Model = "models/Combine_Super_Soldier.mdl"
Object.Class = "npc_combine_s"
Object.MaxHacks = 2
Object.IconColor = Color(0, 0, 0)
Object.Color = Color(0, 180, 255)
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
		ent.Profiler.Emotion = "bad"..math.random(1, 2)
		ent.Profiler.Color = Color(248, 42, 0)
		ent.Profiler.Description2 = "Botnet recharge"
		ent.Profiler.Name = table.Random(gctOS.CitizensInfo.Lastnames)..", "..table.Random(gctOS.CitizensInfo.MaleFirstnames)
		ent.Profiler.Description = "CAN CALL REINFORCEMENTS"
		ent.Profiler.Info1 = "Combine Elite Soldier"
		local rand = math.random(16000, 32000)
		ent.Profiler.Info2 = "Income  $"..string.SetChar(string.SetChar(string.Comma(rand), #string.Comma(rand), 0), #string.Comma(rand)-1, 0)
		--ent.Profiler.Icon = "citizens/"..table.Random(icons)
		ent.Profiler.Icon = "citizens/newphotos/avatars/combine_"..math.random(1, 6)..".png"
		ent.Profiler.IColor = Color(0, 0, 0, 255)
	end)
end

Object.Hacks[1].Hack = function(ply, ent, self)
	if(SERVER) then
		gctOS.SetHackStatus(ent, 1, false)
		if(ent:GetNWString("PDesc") != "CAN CALL REINFORCEMENTS") then
			gctOS.PFuncs.SetColor2(ent, Color(245, 245, 245))
		end
	end
	ent:SetNWString("PDesc2", "")
end
Object.Hacks[2].Hack = function(ply, ent, self)
	if(SERVER) then
		PrintTable(ent:GetSequenceList())
		local effect = EffectData()
		effect:SetOrigin(ent:GetBonePosition(0))
		util.Effect("StunstickImpact", effect)
		ent:ResetSequence(ent:LookupSequence("deathpose_back"))
		ent:ResetSequenceInfo()
		ent:SetCycle(0)
		ent:SetPlaybackRate(1)
		ent:EmitSound("noise.mp3")
	end	
end
Object.Hacks[3].Hack = function(ply, ent, self)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 3, true)
		timer.Simple(5, function()
			if(IsValid(ent)) then
				for k, e in pairs(ents.FindInSphere(ent:GetPos(), 10000)) do
					if(e:GetClass()=="npc_combine_s" || e:GetClass()=="npc_metropolice") then
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