local App = {
	Name = "gctOS Access",
	Description = "Set which players have access to hacks",
	Icon = "apps/access.png",
	T = false,
	Function = function(panel)
		panel.Paint = function(panel, w, h)
			surface.SetDrawColor(64, 64, 64)
			surface.DrawRect(0, 0, w, h)
		end
		local d = panel:Add("DListView")
		d:SetSize(270, 280)
		d:Dock(TOP)
		d:AddColumn("Access")
		d:AddColumn("No Access")
		d:DockMargin(8, 8, 8, 0)
		for k, v in pairs(player.GetAll()) do
			if(v:GetNWBool("gctOS_Access")) then
				d:AddLine(v:GetName(), "")
			else
				d:AddLine("", v:GetName())
			end
			d:GetLines()[k].SteamID64 = v:SteamID64()
		end
		d.OnClickLine = function(parent, line, isselected)
			T = !T
			local u = line:GetValue(1)..line:GetValue(2)
			line:SetValue(1, T && u || "")
			line:SetValue(2, T && "" || u)
		end
		local db = vgui.Create("DCheckBoxLabel", panel)
		db:Dock(TOP)
		db:SetText("Give access on join?")
		db:DockMargin(8, 8, 0, 0)
		db:SetConVar("sv_gctos_giveaccessonjoin")
		local e = panel:Add("DButton")
		e:SetText("Apply")
		e:Dock(TOP)
		e:DockMargin(8, 8, 8, 0)
		e.DoClick = function()
				for i = 1, #d:GetLines() do
					local p = player.GetBySteamID64(d:GetLines()[i].SteamID64)
					p:SetNWBool("gctOS_Access", d:GetLines()[i]:GetValue(1) == p:GetName())
				end
		end
	end
}

if(!game.SinglePlayer()) then
	gctOS.AddApp(App)
end