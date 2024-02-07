-- [[ FOG IS COMING]] --








































function ent_init(ent)
	timer.Simple(FrameTime(), function()
		if(IsValid(ent) && gctOS.IsHackable(ent)) then
			ent.Profiler = {}
			table.insert(gctOS.Entities, ent:EntIndex(), ent)
			ent.IsHackable = true
			ent.Object = gctOS.GetObjectBase(ent)
			if(ent.Object.Type == 1) then
				ent.Profiler.Name = ent.Object.Name
				ent.Profiler.Description = ent.Object.Hacks[1].Description
				ent.Profiler.Description2 = ent.Object.Description2
			end
			if(SERVER && gctOS.GetObjectBase(ent).Type != 3) then
				for i = 1, 4 do
					if(gctOS.GetObjectBase(ent).Hacks[i].Available == true) then
						ent:SetNWBool("Available"..i, true)
					else
						ent:SetNWBool("Available"..i, false)
					end
				end
			end
			if(isfunction(ent.Object.Init)) then ent.Object.Init(ent) end
			if(SERVER) then
				timer.Simple(FrameTime(), function()
					if(gctOS.GetObjectBase(ent).Type == 2) then
						gctOS.PFuncs.SetType2(ent, {
							Name = ent.Profiler.Name,
							Description = ent.Profiler.Description,
							Description2 = ent.Profiler.Description2,
							Icon = ent.Profiler.Icon,
							Emotion = ent.Profiler.Emotion,
							Color = ent.Profiler.Color,
							IColor = ent.Profiler.IColor,
							Info1 = ent.Profiler.Info1,
							Info2 = ent.Profiler.Info2
						})
					end
					if(gctOS.GetObjectBase(ent).Type == 1) then
						gctOS.PFuncs.SetType1(ent, {
							Name = ent.Profiler.Name,
							Description = ent.Object.Hacks[1].Description,
							Description2 = ent.Object.Description2,
							Icon = ent.Object.Hacks[1].Icon

						})
					end
				end)
			end
			ent.ProfilerDefault = ent.Profiler
		end
	end)
end

hook.Add("OnEntityCreated", "gctOS_AddEntity", ent_init)

hook.Add("EntityRemoved", "gctOS_RemoveEntity", function(ent)
	timer.Simple(FrameTime(), function() 
		if(table.HasValue(gctOS.Entities, ent)) then
			table.remove(gctOS.Entities, ent:EntIndex())
			hook.Remove("Think", "gctOS_ObjThink_"..ent:EntIndex())
		end
	end)
end)

-- Copy Profiler info from NPC to corpse :)

function OnNPCKilled(npc, ragdoll)
	ragdoll.Object = npc.Object
	ragdoll:SetNWBool("Available1", npc:GetNWBool("Available1"))
	ragdoll:SetNWBool("Available2", true)
	ragdoll:SetNWBool("Available3", true)
	ragdoll:SetNWBool("Available4", true)
	ragdoll:SetNWBool("Used2", true)
	ragdoll:SetNWBool("Used3", true)
	ragdoll:SetNWBool("Used4", true)
	gctOS.PFuncs.SetType2(ragdoll, gctOS.PFuncs.GetType2(npc))
	if(npc:GetClass() == "npc_combine_s" || npc:GetClass() == "npc_metropolice") then
		gctOS.PFuncs.SetColor2(ragdoll, npc:GetNWBool("Available1") && Color(6, 171, 240) || Color(245, 245, 245))
		ragdoll:SetNWString("PDesc", table.Random(gctOS.CitizensInfo.Facts))
	end
end

net.Receive("gctOS_OnNPCKilled_Client", function()
	local npc = net.ReadEntity()
	local ragdoll = net.ReadEntity()
	ragdoll.Object = npc.Object
end)

if(SERVER) then
	util.AddNetworkString("gctOS_OnNPCKilled_Client")
	killed = {bool = false, ent = NULL}
	hook.Add("OnNPCKilled", "gctOS_OnNPCKilled1", function(ent)
		if(ent:GetClass() == "npc_citizen" || ent:GetClass() == "npc_combine_s" || ent:GetClass() == "npc_metropolice") then
			killed.ent = ent
			killed.bool = true
		end
	end)
	hook.Add("OnEntityCreated", "gctOS_OnNPCKilled2", function(ent) 
		if(killed.bool == true && ent:GetClass() == "prop_ragdoll") then
			killed.bool = false
			OnNPCKilled(killed.ent, ent)
			net.Start("gctOS_OnNPCKilled_Client")
			net.WriteEntity(killed.ent)
			net.WriteEntity(ent)
			net.Broadcast()
			killed.ent = NULL
		end
	end)
	hook.Add("PlayerDeath", "gctOS_PlayerDeath", function(victim)
		victim:SendLua('if(profiler) then hook.Run("gctOS_KeyHandler", gctOS.Bindings.Profiler) end')
		victim:SendLua('if(nethack) then hook.Run("gctOS_KeyHandler", gctOS.Bindings.NetHack) end')
		if(IsValid(victim:GetNWEntity("gctOS_Camera"))) then
			victim:SendLua("c_ent = LocalPlayer()")
			CamHack(victim, victim:GetNWEntity("gctOS_Camera"))
		end
	end)
end