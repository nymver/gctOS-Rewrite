local App = {
	Name = "Client Settings",
	Description = "Addon Client Settings",
	Icon = "apps/csettings.png",
	Function = function(panel, sp, ocsf)
		panel.Paint = function(panel, w, h)
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, w, h)
		end
		local dh = vgui.Create("DCheckBoxLabel", panel)
		dh:Dock(TOP)
		dh:SetText("Enable addon?")
		dh:DockMargin(8, 8, 0, 0)
		dh:SetValue(enableaddon:GetInt())
		local db = vgui.Create("DCheckBoxLabel", panel)
		db:Dock(TOP)
		db:SetText("Draw blur?")
		db:DockMargin(8, 8, 0, 0)
		db:SetValue(drawblur:GetInt())
		local sz = panel:Add("DNumSlider")
		sz:SetMinMax(0, 128)
		sz:SetText("HUD Safezone")
		sz:Dock(TOP)
		sz:DockMargin(8, 0, 8, 0)
		sz:SetDecimals(0)
		mode = 0
		local d = panel:Add("DListView")
		d:SetSize(150, 185)
		d:Dock(TOP)
		d:AddColumn("Bind")
		d:AddColumn("Key")
		for k, v in pairs(gctOS.Bindings) do
			d:AddLine(k, string.upper(input.GetKeyName(v)))
		end
		d.OnClickLine = function(parent, line, isselected)
			timer.Simple(0.1, function()
				local bind = line:GetValue(1)
				line:SetValue(2, "PRESS ANY KEY")
				hook.Add("gctOS_KeyHandler", "gctOS_KeySet", function(key) 
					line:SetValue(2, string.upper(input.GetKeyName(key)))
					gctOS.Bindings[bind] = key	
					file.Write("gctos_settings.txt", util.TableToJSON(gctOS.Bindings))
					if(bind == "Hack1" || bind == "Hack2" || bind == "Hack3" || bind == "Hack4") then
						keys_n[tonumber(bind[5])] = string.lower(input.GetKeyName(key))
						hack_keys = {}
						table.insert(hack_keys, gctOS.Bindings.Hack1, 1)
						table.insert(hack_keys, gctOS.Bindings.Hack2, 2)
						table.insert(hack_keys, gctOS.Bindings.Hack3, 3)
						table.insert(hack_keys, gctOS.Bindings.Hack4, 4)
					end		
					hook.Remove("gctOS_KeyHandler", "gctOS_KeySet")
				end)
			end)
		end
		local e = panel:Add("DButton")
		e:SetText("Set to default")
		e:Dock(TOP)
		e:DockMargin(8, 8, 8, 0)
		e.DoClick = function()
			gctOS.Bindings["Hackmenu"] = MOUSE_MIDDLE
			gctOS.Bindings["Profiler"] = KEY_T
			gctOS.Bindings["CamHack"] = KEY_B
			gctOS.Bindings["NetHack"] = KEY_H
			gctOS.Bindings["Hack1"] = KEY_SPACE
			gctOS.Bindings["Hack2"] = KEY_C
			gctOS.Bindings["Hack3"] = KEY_F
			gctOS.Bindings["Hack4"] = KEY_R
			gctOS.Bindings["FastApp"] = KEY_G
			file.Write("gctos_settings.txt", util.TableToJSON(gctOS.Bindings))
			keys_binds = {gctOS.Bindings.Hackmenu, gctOS.Bindings.Profiler, gctOS.Bindings.Hack1, gctOS.Bindings.Hack2, gctOS.Bindings.Hack3, gctOS.Bindings.Hack4, gctOS.Bindings.HackCam, gctOS.Bindings.FastApp}
			bindings = {}
			for k, v in pairs(keys_binds) do
				bindings[#bindings+1] = input.LookupKeyBinding(v)
			end
			drawblur:SetInt(1)
			db:SetChecked(numbertobool(drawblur:GetInt()))
			hud_safezone:SetInt(0)
			sz:SetValue(hud_safezone:GetInt())
			openCloseSmartphone:SetPos(20, ScrH()-35-5)
			tempOCSF:SetPos(20, ScrH()-35-5)
			closeSmartphone()
		end
		local e = panel:Add("DButton")
		e:SetText("Apply")
		e:Dock(TOP)
		e:DockMargin(8, 8, 8, 0)
		e.DoClick = function()
			keys_binds = {gctOS.Bindings.Hackmenu, gctOS.Bindings.Profiler, gctOS.Bindings.Hack1, gctOS.Bindings.Hack2, gctOS.Bindings.Hack3, gctOS.Bindings.Hack4, gctOS.Bindings.HackCam, gctOS.Bindings.FastApp}
			bindings = {}
			for k, v in pairs(keys_binds) do
				bindings[#bindings+1] = input.LookupKeyBinding(v)
			end
			drawblur:SetInt(booltonumber(db:GetChecked()))
			enableaddon:SetInt(booltonumber(dh:GetChecked()))
			if(!dh:GetChecked()) then
				closeSmartphone()
				GAMEMODE:AddNotify('You can enable gctOS by "cl_gctos_enableaddon" convar.', NOTIFY_GENERIC, 10)
				print('You can enable gctOS by "cl_gctos_enableaddon" convar.')
			end
			hud_safezone:SetInt(sz:GetValue())
			closeSmartphone()
		end
	end
}

gctOS.AddApp(App)