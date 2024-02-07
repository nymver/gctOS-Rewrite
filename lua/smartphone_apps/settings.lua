local App = {
	Name = "Server Settings",
	Description = "Addon Server Settings",
	Icon = "apps/settings.png",
	Function = function(panel)
		panel.Paint = function(panel, w, h)

			surface.DrawRect(0, 0, w, h)
		end
		local ct = CurTime() + GetConVar("sv_gctos_botnetregeneratedelay"):GetInt()
		local botnet_lbl = panel:Add("DLabel")
		botnet_lbl:SetText("Botnet")
		botnet_lbl:Dock(TOP)
		botnet_lbl:DockMargin(16, 4, 0, 0)
		botnet_lbl:SetTextColor(Color(255, 255, 255))
		local botnet = panel:Add("DPanel")
		botnet:SetSize(64, 64)
		botnet:SetPos(270-64, 4)
		botnet.Paint = function(panel, w, h)
			local c1 = Color(0, 180, 255)
			local c2 = Color(255, 255, 255)
			local c3 = Color(0, 0, 0)
			local c = getAnim("BotnetRegenerateDemo")
			if(CurTime() > ct) then
				ct = CurTime() + GetConVar("sv_gctos_botnetregeneratedelay"):GetInt()
				runAnim("BotnetRegenerateDemo", 0.25)
			end
			local r = ((c>0.25 && c<0.5) || (c>0.75 && c<1)) && true || false 
			draw.NoTexture()
			surface.SetDrawColor(78, 78, 78)
			draw.Circle(32, 32, 26, 360)
			surface.SetDrawColor(200, 200, 200)
			draw.CircleProgress(32, 32, 22, 360, GetConVar("sv_gctos_botnetregenerate"):GetInt()/20, 0)
			surface.SetDrawColor(r && c2 || c1)
			draw.CircleProgress(32, 32, 22, 360, GetConVar("sv_gctos_defaultbotnet"):GetInt()/20, 0)
			surface.SetDrawColor(r && c1 || c2)
			draw.Circle(32, 32, 14, 360)
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Material("battery.png"))
			surface.DrawTexturedRect(8, 8, 48, 48)
			surface.SetDrawColor(r && c2 || c3)
			surface.SetMaterial(Material("botnet_symbol.png"))
			surface.DrawTexturedRect(8, 8, 48, 48)
		end
		local defb = panel:Add("DNumSlider")
		defb:SetMinMax(0, 20)
		defb:SetConVar("sv_gctos_defaultbotnet")
		defb:SetText("Default")
		defb:Dock(TOP)
		defb:DockMargin(8, 0, 48, 0)
		defb:SetDecimals(0)
		local defb = panel:Add("DNumSlider")
		defb:SetMinMax(0, 20)
		defb:SetConVar("sv_gctos_botnetregenerate")
		defb:SetText("To-Regenerate")
		defb:Dock(TOP)
		defb:DockMargin(8, 0, 48, 0)
		defb:SetDecimals(0)
		local defb = panel:Add("DNumSlider")
		defb:SetMinMax(0, 20)
		defb:SetConVar("sv_gctos_botnetregeneratedelay")
		defb:SetText("Regenerate Delay")
		defb:Dock(TOP)
		defb:DockMargin(8, 0, 48, 0)
		defb:SetDecimals(0)
		local lbl = panel:Add("DLabel")
		lbl:SetText("Hacking")
		lbl:Dock(TOP)
		lbl:DockMargin(16, 4, 0, 0)
		lbl:SetTextColor(Color(255, 255, 255))
		local defb = panel:Add("DCheckBoxLabel")
		defb:SetConVar("sv_gctos_drainbotnet")
		defb:SetSize(15, 15)
		defb:SetPos(8, 152)
		defb:SetText("Drain Botnet?")
		defb:PerformLayout()
		local defb = panel:Add("DCheckBoxLabel")
		defb:SetConVar("sv_gctos_hacknetdrainbotnet")
		defb:SetSize(15, 15)
		defb:SetPos(120, 152)
		defb:SetText("NetHack drains Botnet?")
		defb:PerformLayout()
		local defb = panel:Add("DCheckBoxLabel")
		defb:SetConVar("sv_gctos_unlimitedhacks")
		defb:SetSize(15, 15)
		defb:SetPos(8, 174)
		defb:SetText("Make hacks unlimited?")
		defb:PerformLayout()
		local defb = panel:Add("DCheckBoxLabel")
		defb:SetConVar("sv_gctos_ofa")
		defb:SetSize(15, 15)
		defb:SetPos(8, 196)
		defb:SetText("Hacking only for Admin?")
		defb:PerformLayout()
		local defb = panel:Add("DNumSlider")
		defb:SetMinMax(1, 30)
		defb:SetConVar("sv_gctos_facooldown")
		defb:SetText("FastApp Cooldown")
		defb:SetPos(8, 220)
		defb:SetSize(250, 16)
		defb:SetDecimals(0)
		local defb = panel:Add("DNumSlider")
		defb:SetMinMax(-1, 20000)
		defb:SetConVar("sv_gctos_blackoutarea")
		defb:SetText("Blackout Area")
		defb:SetPos(8, 244)
		defb:SetSize(250, 16)
		defb:SetDecimals(0)
		local defb = panel:Add("DNumSlider")
		defb:SetMinMax(-1, 20000)
		defb:SetConVar("sv_gctos_jcarea")
		defb:SetText("Jam Comms Area")
		defb:SetPos(8, 268)
		defb:SetSize(250, 16)
		defb:SetDecimals(0)
		local defb = panel:Add("DNumSlider")
		defb:SetMinMax(-1, 20000)
		defb:SetConVar("sv_gctos_mtarea")
		defb:SetText("Mad Tech Area")
		defb:SetPos(8, 292)
		defb:SetSize(250, 16)
		defb:SetDecimals(0)
		local defb = panel:Add("DNumSlider")
		defb:SetMinMax(-1, 20000)
		defb:SetConVar("sv_gctos_mvarea")
		defb:SetText("Mad Vehicles Area")
		defb:SetPos(8, 316)
		defb:SetSize(250, 16)
		defb:SetDecimals(0)
		local ct = panel:Add("DNumSlider")
		ct:SetMinMax(3, 11)
		ct:SetConVar("sv_gctos_cartime")
		ct:SetText("Car Drive-Time")
		ct:SetPos(8, 340)
		ct:SetSize(250, 16)
		ct:SetDecimals(0)
		ct.OnValueChanged = function(panel, value)
			if(tonumber(ct.Scratch:GetTextValue())<11) then
				ct.TextArea:SetValue(ct.Scratch:GetTextValue())
			else
				ct.TextArea:SetValue("Infinity")
			end
		end
	end
}

gctOS.AddApp(App)