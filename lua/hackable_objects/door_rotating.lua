-- Door

local Object = {}
Object.Type = 1
Object.Name = "Electronic Door"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = {"prop_door_rotating", "func_door_rotating", "func_door"}
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 0, Available = true, Icon = "hack_door.png", Description = "Hack to open or close"}, 
	{DrawRhomb = true, Cost = 1, Available = true, Icon = "hack_circuit.png", Description = "Hack to lock or close"}, 
	{}, 
	{}
}

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent:Fire("Toggle")
	end
end

Object.Hacks[2].Hack = function(ply, ent)
	if(SERVER) then
		if(ent:GetSaveTable().m_bLocked == true) then
			ent:Fire("Unlock")
			ent:EmitSound("doors/handle_pushbar_locked1.wav")
		else
			ent:Fire("Lock")	
			ent:EmitSound("doors/handle_pushbar_locked1.wav")
		end
	end
end

gctOS.AddObject(Object)

-- Elevator

local Object = {}
Object.Type = 1
Object.Name = "Elevator"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = {"func_movelinear"}
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 0, Available = true, Icon = "hack_arrows.png", Description = "Hack to open or close"}, 
	{},
	{}, 
	{}
}

Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		local pos_1 = ent:GetSaveTable().m_vecPosition1
		local pos_2 = ent:GetSaveTable().m_vecPosition2
		local pos_now = ent:GetSaveTable().m_vecAbsOrigin
		local velocity = ent:GetSaveTable().m_vecAbsVelocity

		if(pos_now.z > pos_1.z) then
			if(velocity.z == 0) then
				ent:Fire("Close")
			elseif(velocity.z > 0) then
				ent:Fire("Close")
			elseif(velocity.z < 0) then
				ent:Fire("Open")
			end
		else
			ent:Fire("Open")
		end
	end
end

gctOS.AddObject(Object)