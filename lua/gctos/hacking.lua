-- [[ FOG IS COMING]] --








































--[[
	gctOS Rewrite

	Hacking
]]

if(SERVER) then
	util.AddNetworkString("gctOS_Hack")
	util.AddNetworkString("gctOS_CamHack")
	util.AddNetworkString("gctOS_Hack_Type3")
	util.AddNetworkString("gctOS_PlayerHack")
	
	net.Receive("gctOS_Hack", function(length, ply) 
		local ent = net.ReadEntity()
		local n = net.ReadInt(8)
		ply:SetNWEntity("gctOS_LastHacked", ent)
		ply:SetNWInt("gctOS_LastHacked_Num", ply:GetNWInt("gctOS_LastHacked_Num")+1)
		ply:SendLua('hook.Run("gctOS_Botnet", '..ent.Object.Hacks[n].Cost..')')
		ent.Object.Hacks[n].Hack(ply, ent, ent.Object.Hacks[n])
		if(IsValid(ent)) then
			ply:SendLua("Entity("..ent:EntIndex()..").Object.Hacks["..n.."]"..".Hack(Entity("..ply:EntIndex().."), Entity("..ent:EntIndex().."))")
		end
		net.Start("gctOS_PlayerHack")
		net.WriteEntity(ply)
		net.WriteEntity(ent)
		net.WriteInt(n, 8)
		net.Broadcast()
	end)
	
	function CamHack(ply, camerar)
		local ent = camerar
		if(ent != ply:GetNWEntity("gctOS_Camera") && !IsValid(ent:GetNWEntity("gctOS_Hacker"))) then
			if(IsValid(ply:GetNWEntity("gctOS_Camera"))) then
				local cam = ply:GetNWEntity("gctOS_Camera")
				cam:SetNWEntity("gctOS_Hacker", NULL)
				hook.Remove("Think", "gctOS_Camera_"..cam:EntIndex())	
				ply:SetFOV(75)
			end
			if(IsValid(ply:GetNWEntity("DronesRewriteDrone"))) then
				ply:GetNWEntity("DronesRewriteDrone"):SetDriver(NULL)
				ply:SetNWEntity("DronesRewriteDrone", NULL)
			end
			ent:SetNWEntity("gctOS_Hacker", ply)
			ply:SetViewEntity(ent)
			ply:SetNWEntity("gctOS_Camera", ent)
			ply.mvtp = ply:GetMoveType()
			ply:SetMoveType(MOVETYPE_VPHYSICS)
			ent:SetAngles(ply:EyeAngles())
			hook.Add("Think", "gctOS_Camera_"..ent:EntIndex(), function()
				if(IsValid(ent)) then 
					ent:SetAngles(ent:GetNWEntity("gctOS_Hacker"):EyeAngles() + Angle(25, 180, 0))
				else
					ply:SetFOV(75)
					hook.Remove("Think", "gctOS_Camera_"..ent:EntIndex())
				end
			end)
		else
			ply:SetViewEntity(ply)
			ply:SetNWEntity("gctOS_Camera", NULL)
			ply:SetMoveType(ply.mvtp)
			ent:SetNWEntity("gctOS_Hacker", NULL)
			hook.Remove("Think", "gctOS_Camera_"..ent:EntIndex())
			ply:SetFOV(75)
		end
	end
	
	net.Receive("gctOS_CamHack", function(length, ply) 
		local ent = net.ReadEntity()
		CamHack(ply, ent)
	end)

	net.Receive("gctOS_Hack_Type3", function(length, ply) 
		local ent = net.ReadEntity()
		ent.Object.Hack(ply, ent)
	end)
end