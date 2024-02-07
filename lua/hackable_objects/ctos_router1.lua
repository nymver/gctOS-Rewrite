-- Router 1

local Object = {}
Object.Type = 1
Object.Name = "ctOS Router"
Object.Description2 = "Vulnerability found"
Object.Model = "any"
Object.Class = "ctos_router1"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 4, Available = true, Used = false, Icon = "hack_circuit.png", Description = "Hack to perform system crash"}
}
Object.Color = Color(247, 104, 2)

Object.Init = function(ent)
	hook.Add("Think", "gctOS_ObjThink_"..ent:EntIndex(), function() 
		if(!IsValid(ent)) then
			hook.Remove("Think", "gctOS_ObjThink_"..ent:EntIndex())
		end
	end)
end

Object.Hacks[1].Hack = function(ply, ent)
	if(CLIENT) then
		startProgress("loading", "INITIATE SHUTDOWN", 15)
	end
	timer.Simple(15, function()
	LocalPlayer():EmitSound("blackout.mp3")
	gctOS.Blackout(ent:GetPos(), ent:GetAreaOfEffect(), 15)
	gctOS.SetHackUsed(ent, 1, true)
	timer.Simple(10, function() 
		gctOS.SetHackUsed(ent, 1, false)
	end)
	end)
end

gctOS.AddObject(Object)