if(SERVER) then

end


local App = {
	Util = false, 
	Name = "Cameras",
	Description = "Access cameras that you have hacked",
	Icon = "apps/saved_cams.png",
	Function = function(panel)
		panel.Paint = function(panel, w, h)
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, w, h)
		end
		--[[
		local cam_list = vgui.Create("DListView", panel)
		cam_list:SetPos(0, 0)
		cam_list:SetSize(270, 135)
		cam_list:AddColumn("Index")
		cam_list:AddColumn("Class")
		cam_list:AddColumn("Model")
		for k, v in pairs(saved_cams) do
			if(IsValid(v)) then
				cam_list:AddLine(v:EntIndex(), v:GetClass(), v:GetModel())
			end
		end
		local hbutton = gctOS.VGUI.Button(16, 135+48, 270-32, 32, "Hack", panel)
		hbutton.DoClick = function() 
			if(cam_list:GetSelected()[1] != nil) then
				local ent = Entity(cam_list:GetSelected()[1]:GetColumnText(1))
				net.Start("gctOS_Hack_Type3")
				net.WriteEntity(ent)
				net.SendToServer()
				ent.Object.Hack(c_ent, ent)
				c_ent = tcamera
				camhack = 0
				runAnim("CamHack_Transition", 1, false)
				surface.PlaySound("cam_hack.mp3")
				closeSmartphone()
			end
		end
		]]
	end
}

gctOS.AddApp(App)