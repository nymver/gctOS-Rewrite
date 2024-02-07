if(SERVER) then
	util.AddNetworkString("SS_SetScreens")

	net.Receive("SS_SetScreens", function(length, ply) 
		local bg = net.ReadTable()
		local fg = net.ReadTable()
		local text = net.ReadString()
		ply:SetNWVector("SS_BGCOLOR", Vector(bg.r, bg.g, bg.b))
		ply:SetNWVector("SS_FGCOLOR", Vector(fg.r, fg.g, fg.b))
		ply:SetNWString("SS_TEXT", text)
	end)
end


local App = {
	Name = "Screens",
	Description = "Configuration of hacked screens",
	Icon = "apps/screen_control.png",
	Function = function(panel)
		panel.Paint = function(panel, w, h)
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, w, h)
		end
		local lbl = panel:Add( "DLabel" )
		lbl:SetText("Background Color")
		lbl:SetTextColor(Color(255, 255, 255, 255))
		lbl:Dock( TOP )
		lbl:DockMargin( 8, 0, 0, 0 )
		local bgcolor = panel:Add("DColorMixer")
		bgcolor:SetAlphaBar(false)
		bgcolor:SetPalette(false)
		bgcolor:Dock(TOP)
		bgcolor:SetSize(270/1, 270/3)
		bgcolor:DockMargin(8, 0, 8, 0)
		local lbl = panel:Add( "DLabel" )
		lbl:SetText("Text Color")
		lbl:SetTextColor(Color(255, 255, 255, 255))
		lbl:Dock( TOP )
		lbl:DockMargin( 8, 8, 0, 0 )
		local fgcolor = panel:Add("DColorMixer")
		fgcolor:SetAlphaBar(false)
		fgcolor:SetPalette(false)
		fgcolor:Dock(TOP)
		fgcolor:SetSize(270/1, 270/3)
		fgcolor:DockMargin(8, 0, 8, 0)
		local lbl = panel:Add( "DLabel" )
		lbl:SetText("Text")
		lbl:SetTextColor(Color(255, 255, 255, 255))
		lbl:Dock( TOP )
		lbl:DockMargin( 8, 8, 0, 0 )
		local text = panel:Add("DTextEntry")
		text:Dock(TOP)
		text:DockMargin(8, 0, 8, 0)
		local apply = panel:Add("DButton")
		apply:SetText("Apply")
		apply:Dock( TOP )
		apply:DockMargin(8, 8, 8, 8)
		apply.DoClick = function()
			if(CLIENT) then
				net.Start("SS_SetScreens")
				net.WriteTable(bgcolor:GetColor())
				net.WriteTable(fgcolor:GetColor())
				net.WriteString(text:GetText())
				net.SendToServer()
			end
		end
	end
}

gctOS.AddApp(App)