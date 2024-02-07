if(SERVER) then
	util.AddNetworkString("gctOS_Blackout")
	net.Receive("gctOS_Blackout", function(len, p) 
		gctOS.Blackout(p:GetPos())
		timer.Simple(10, function() 
			gctOS.Blackout(p:GetPos(), true)
		end)
	end)
end

if(CLIENT) then
	ents_tob = {}
	hook.Add("PostDrawTranslucentRenderables", "gctOS_Blackout_Render", function() 
		if(checkAnim("BlackoutLines") == false) then
			for k, v in pairs(ents_tob) do
				--render.DrawLine(LocalPlayer():GetBonePosition(0)+Vector(5, 0, 0), v:GetBonePosition(0) || v:GetPos(0), Color(255, 255, 255, 128*(1 - getAnim("BlackoutLines"))), false)
			end
			if(not table.IsEmpty(ents_tob)) then
				for i = 1, math.floor((table.Count(ents_tob) * (1-getAnim("BlackoutLines")))/2) do
					local e1 = table.Random(ents_tob)
					local e2 = table.Random(ents_tob)
					if(IsValid(e1) && IsValid(e2) && e1 != LocalPlayer() && e2 != LocalPlayer()) then
						render.SetMaterial(Material("blank.png"))
						render.DrawLine(e1:GetBonePosition(0) || e1:GetPos(), e2:GetBonePosition(0) || e2:GetPos(),  Color(255, 255, 255, 64*(1-getAnim("BlackoutLines"))))
					end
				end
			end
		end
	end)
	hook.Remove("PreDrawTranslucentRenderables", "gctOS_Blackout_Render")
end

local App = {
	Name = "Blackout",
	Description = "Perform blackout - shutdown of ctOS",
	Icon = "apps/blackout.png",
	Util = true,
	Function = function(panel)
		if(panel) then
			panel:Remove()
			app = nil
		end
		ents_tob = {}
		local clf = {"npc_manhack", "gmod_light", "gmod_lamp", "npc_rollermine", "gmod_wire_consolescreen", "gmod_wire_textscreen", "prop_door_rotating", "func_door_rotating", "npc_turret_floor", "models/props_interiors/furniture_lamp01a.mdl"}
		LocalPlayer():EmitSound("blackout.mp3")
		net.Start("gctOS_Blackout")
		net.SendToServer()
		runAnim("BlackoutLines", 5, false)
		runAnim("Blackout", 10, false)
		for k, v in pairs(GetConVar("sv_gctos_blackoutarea"):GetInt() == -1 && ents.GetAll() || ents.FindInSphere(LocalPlayer():GetPos(), GetConVar("sv_gctos_blackoutarea"):GetInt())) do
			if(v.Object && v != LocalPlayer()) then
				v.Blackouted = true
				ents_tob[#ents_tob + 1] = v
				v.RP = true
				v.RPIcon = "hack_circuit.png"
				runAnim("RP"..v:EntIndex(), 10, true)
				timer.Simple(10, function() 
					v.Blackouted = false 
					v.RP = false
					runAnim("Profiler_Temp", 0.5, false, function(i) 
					if(target.Object) then
						if(target.Object.Type == 1) then  
							updateProfiler1(i)
						elseif(target.Object.Type == 2) then
							updateProfiler2(i)
						end
					end
				end)
				end)
			end
		end
	end
}

gctOS.AddApp(App)