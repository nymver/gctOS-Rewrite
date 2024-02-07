if(SERVER) then
	util.AddNetworkString("gctOS_MadVehicles")
	net.Receive("gctOS_MadVehicles", function(len, p) 
		for k, v in pairs(ents.FindInSphere(p:GetPos(), GetConVar("sv_gctos_mvarea"):GetInt())) do
			if(v.IsScar || v.IsSimfphyscar || v:GetClass() == "prop_vehicle_jeep") then
				v.Object.Hacks[math.random(1, 2)].Hack(p, v)
				local r = math.random(2, 4)
				if(r!=2) then
					--v.Object.Hacks[r].Hack(p, v)
				end
			end
		end
	end)
end

if(CLIENT) then
	ents_tob_m = {}
	hook.Add("PostDrawOpaqueRenderables", "gctOS_MadVehicles_Render", function() 
		if(checkAnim("MadVehiclesLines") == false) then
			for k, v in pairs(ents_tob_m) do
				render.DrawLine(LocalPlayer():GetBonePosition(0)+Vector(5, 0, 0), v:GetBonePosition(0), Color(255, 255, 255, 255*(1 - getAnim("MadVehiclesLines"))), false)
			end
		end
	end)
end

local App = {
	Name = "Mad Vehicles",
	Description = "Vehicles start drive like chaos",
	Icon = "apps/vehicles.png",
	Util = true,
	Function = function(panel)
		if(panel) then
			panel:Remove()
			app = nil
		end
		ents_tob_m = {}
		net.Start("gctOS_MadVehicles")
		net.SendToServer()
		runAnim("MadVehiclesLines", 5, false)
		for k, v in pairs(GetConVar("sv_gctos_mvarea"):GetInt() == -1 && ents.GetAll() || ents.FindInSphere(LocalPlayer():GetPos(), GetConVar("sv_gctos_mvarea"):GetInt())) do
			if(v.IsScar || v.IsSimfphyscar || v:GetClass() == "prop_vehicle_jeep") then
				ents_tob_m[#ents_tob_m + 1] = v
			end
		end
	end
}

gctOS.AddApp(App)