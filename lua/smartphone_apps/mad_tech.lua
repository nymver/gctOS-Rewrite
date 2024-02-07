if(SERVER) then
	util.AddNetworkString("MadTech")
	net.Receive("MadTech", function(length, ply) 
		for k, v in pairs(GetConVar("sv_gctos_mtarea"):GetInt() == -1 && ents.GetAll() || ents.FindInSphere(ply:GetPos(), GetConVar("sv_gctos_mtarea"):GetInt())) do
			if(v:GetClass() == "npc_turret_floor" || v:GetClass()=="npc_manhack" || v:GetClass()=="npc_rollermine") then
				ply:SendLua("hook.Run('gctOS_Hack', Entity("..v:EntIndex().."), 1)")
				ply:SendLua("closeSmartphone()")
			end
		end
	end)
end

local hacked = {}

if(CLIENT) then
	ents_tob = {}
	hook.Add("PostDrawTranslucentRenderables", "gctOS_MadTech_Render", function() 
		if(checkAnim("MadTech_Lines") == false) then
			for k, v in pairs(hacked) do
				render.DrawLine(LocalPlayer():GetBonePosition(0)+Vector(5, 0, 0), v:GetBonePosition(0) || v:GetPos(0), Color(255, 255, 255, 128*(1 - getAnim("MadTech_Lines"))), false)
			end
		end
	end)
	hook.Remove("PreDrawTranslucentRenderables", "gctOS_Blackout_Render")
end

local App = {
		Name = "Mad Tech",
		Util = true,
		Description = "Make nearby rollermines, turrets and manhacks\nfriendly to you.",
		Icon = "apps/massive_hack.png",
		Function = function(panel) 
			if(panel) then
				panel:Remove()
				app = nil
			end
			LocalPlayer():EmitSound("npc/scanner/scanner_pain2.wav", 75, 250)
			net.Start("MadTech")
			net.SendToServer()
			runAnim("MadTech_Lines", 5, false, function(r) 
				if(r==1) then
					hacked = {}
				end
			end)
			timer.Simple(2, function() hacked = {} end)
			for k, v in pairs(GetConVar("sv_gctos_mtarea"):GetInt() == -1 && ents.GetAll() || ents.FindInSphere(LocalPlayer():GetPos(), GetConVar("sv_gctos_mtarea"):GetInt())) do
				if(v:GetClass() == "npc_turret_floor" || v:GetClass()=="npc_manhack" || v:GetClass()=="npc_rollermine") then
					table.insert(hacked, v)	
				end
			end
		end,
}

gctOS.AddApp(App)