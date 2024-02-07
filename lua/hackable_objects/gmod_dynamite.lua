-- Dynamite

local Object = {}
Object.Type = 1
Object.Name = "Dynamite"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "gmod_dynamite"
Object.MaxHacks = 3
Object.Hacks = {
	{Cost = 3, Available = true, Icon = "hack_explode.png", Description = "Hack to cause overload"}, 
	{Cost = 4, Available = true, Icon = "hack_trap.png", Description = "Hack to set up trap"},
	{},
	{Cost = 1, Available = true, Icon = "hack_attention.png", Description = "Hack to draw attention"} 
}

Object.Init = function(ent)
	if(SERVER) then
		hook.Add("Think", "gctOS_Trap_"..ent:EntIndex(), function() 
			if(ent.Trap && ent.Trap.status == true) then
				for k, v in pairs(ents.FindInSphere(ent:GetPos(), 125)) do
					if(string.StartWith(v:GetClass(), "npc_") || (v:GetClass()=="player" && v != ent.Trap.hacker)) then
						ent.Trap.status = false
						ent.Trap.hacker:SendLua("Entity("..ent:EntIndex()..").Trap = nil")
						explode(ent:GetPos(), 150)
						gctOS.SetHackUsed(ent, 1, true)
						gctOS.SetHackUsed(ent, 2, true)
						gctOS.SetHackUsed(ent, 4, true)
						hook.Remove("Think", "gctOS_Trap_"..ent:EntIndex())
					end
				end
			end
		end)
	end
end

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		if(ent.Trap) then ent.Trap.status = false end
		explode(ent:GetPos(), 150)
		gctOS.SetHackUsed(ent, 1, true)
		gctOS.SetHackUsed(ent, 2, true)
		gctOS.SetHackUsed(ent, 4, true)
	end
end

Object.Hacks[2].Hack = function(ply, ent)
	ent.Trap = {status = true, hacker = ply}
	gctOS.SetHackUsed(ent, 1, true)
	gctOS.SetHackUsed(ent, 2, true)
end

Object.Hacks[4].Hack = function(ply, ent)
	local effectdata = EffectData()
	effectdata:SetOrigin(ent:LocalToWorld(Vector(0, 25, 55)))
	effectdata:SetAngles(ent:LocalToWorldAngles(Angle(0, 90, 90)))
	effectdata:SetScale(6)
	util.Effect("stunstickimpact", effectdata, true, true)
	ent:EmitSound("weapons/stunstick/spark"..math.random(1, 3)..".wav")
	if(SERVER) then
		for k, e in pairs(ents.FindInSphere(ent:GetPos(), 350)) do
			if(string.StartWith(e:GetClass(), "npc_")) then
				if(isfunction(e.StopMoving)) then
					e:StopMoving()
				end
				e:SetLastPosition(Vector(ent:GetPos().x, ent:GetPos().y, e:GetPos().z))
				e:SetSchedule(SCHED_FORCED_GO)
			end
		end
	end
end


gctOS.AddObject(Object)