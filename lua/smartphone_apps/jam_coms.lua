if(SERVER) then
	util.AddNetworkString("gctOS_Noises")
	net.Receive("gctOS_Noises", function(len, p) 
		for k, v in pairs(GetConVar("sv_gctos_jcarea"):GetInt() == -1 && ents.GetAll() || ents.FindInSphere(p:GetPos(), GetConVar("sv_gctos_jcarea"):GetInt())) do
			if(v:GetClass() == "npc_combine_s" || v:GetClass() == "npc_metropolice") then
				v:Ignite(0, 0)
				v:EmitSound("noise.mp3")
			end
		end
	end)
end

if(CLIENT) then
	ents_tob = {}
	hook.Add("PostDrawTranslucentRenderables", "gctOS_JamComs_Render", function()
		if(checkAnim("JCLines")==false) then 
			for k, v in pairs(GetConVar("sv_gctos_jcarea"):GetInt() == -1 && ents.GetAll() || ents.FindInSphere(LocalPlayer():GetPos(), GetConVar("sv_gctos_jcarea"):GetInt())) do
				if(v:GetClass() == "npc_combine_s" || v:GetClass() == "npc_metropolice") then
					render.DrawLine(LocalPlayer():GetBonePosition(0)+Vector(5, 0, 0), v:GetBonePosition(0) || v:GetPos(0), Color(255, 255, 255, 128*(1 - getAnim("JCLines"))), false)
				end
			end
		end
	end)
	hook.Remove("PreDrawTranslucentRenderables", "gctOS_Blackout_Render")
end

local App = {
	Name = "Jam Coms",
	Description = 'Overload radios in your area',
	Icon = "apps/jam_coms.png",
	Util = true,
	Function = function(panel)
		if(panel) then
			panel:Remove()
			app = nil
		end
		runAnim("JCLines", 5, false)
		net.Start("gctOS_Noises")
		net.SendToServer()
	end
}

gctOS.AddApp(App)