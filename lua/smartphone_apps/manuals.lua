
local manuals = {}
local addManual = function(man)
	table.insert(manuals, man)
end
addManual({
	title = "ctOS Routers",
	description = "ctOS Routers are used to block players access to\ncertain objects in radius.",
	pic = "manuals/ctos_router.png",
	labs = {
		{Color(0, 0, 0), "You can get password to log in as ", Color(215, 65, 40), "it's admin."},
	}
})
addManual({
	title = "Botnet",
	description = {Color(0, 0, 0), Material("manuals/symbols/hack_botnet.png"), "Botnet resources are used to perform hacks\naround you."},
	pic = "manuals/botnet.png",
	labs = {
		{Color(0, 0, 0), "Botnet resources", Color(215, 65, 40), " regenerate over time."},
		{Color(0, 0, 0), Material("keys/mouse_middle.png"), " + ", Material("keys/space.png"), " to drain certain citizen phone's botnet."}
	}
})
addManual({
	title = "Profiler",
	description = {Color(0, 0, 0), "Profiler shows you information about certain object\nor citizen."},
	pic = "manuals/profiler.png",
	labs = {
		{Color(0, 0, 0), Material("keys/mouse_middle.png"), " to show Profiler"},
	}
})
addManual({
	title = "Hacking",
	description = {Color(0, 0, 0), "Hacking is main gctOS Rewrite feature used to interact\nwith objects."},
	pic = "manuals/hacking.png",
	labs = {
		{Color(0, 0, 0), Material("keys/t.png"), " to toggle ", Color(215, 65, 40), "Hackmode."},
		{Color(0, 0, 0), Material("keys/mouse_middle.png"), " to show", Color(215, 65, 40), " menu of hacks."},
		{Color(0, 0, 0), "Hacks cost ", Material("manuals/symbols/hack_botnet.png"), "Botnet resources."},
	}
})
addManual({
	title = "Cameras",
	description = {Color(0, 0, 0), "Cameras are used to view everything and hack\nobjects on big distances."},
	pic = "manuals/cameras.png",
	labs = {
		{Color(0, 0, 0), Material("keys/b.png"), " to hack", Color(215, 65, 40), " camera."},
		{Color(0, 0, 0), "Hackmode stays enabled while you\nconnected to camera."}
	}
})
addManual({
	title = "NetHack",
	description = {Color(0, 0, 0), "NetHack is gctOS Rewrite feature that allows to see\nhackable objects through walls."},
	pic = "manuals/nethack.png",
	labs = {
		{Color(0, 0, 0), Material("keys/h.png"), " to toggle ", Color(215, 65, 40), "NetHack"},
		{Color(0, 0, 0), "NetHack also can show you ctOS Routers that\nblocks objects."}
	}
})
addManual({
	title = "Perfomance",
	description = {Color(0, 0, 0), "If you have low game fps after gctOS Rewrite installed\ntryto:"},
	pic = "manuals/perfomance.png",
	labs = {
		{Color(0, 0, 0), "Turn off ", Color(215, 65, 40), "blur", Color(0, 0, 0), " in gctOS client settings."},
		{Color(0, 0, 0), "Decrease ", Color(215, 65, 40), "AntiAlias", Color(0, 0, 0), " in Garry's Mod settings."}
	}
})
addManual({
	title = "Credits",
	description = {Color(0, 0, 0), ""},
	pic = "manuals/authors.png",
	labs = {
		{Color(0, 0, 0), "nymver (STEAM_0:0:91425473) - code, textures"},
		{Color(0, 0, 0), "Ubisoft - Watch_Dogs 2"},
		{Color(215, 65, 40), "Thanks for using :)"}
	}
})
addManual({
	title = "Apps"
})

local viewManual = function(man, parent)
	if(man.title != "Apps") then
		local panel = parent:Add("DPanel")
		panel:SetPos(0, 0)
		panel:SetSize(270, 360)
		panel.Paint = function(pnl, w, h) 
			surface.SetDrawColor(255, 255, 255)
			surface.DrawRect(0, 0, w, h)
		end
		gctOS.VGUI.Image(Material(man.pic), 0, 0, 270, 151, panel)
		gctOS.VGUI.Label(man.description, 8, 159, panel, Color(0, 0, 0))
		for k, v in pairs(man.labs) do
			gctOS.VGUI.Circle(8, 159 + 48 + 24 * (k-1) + 2, 2, panel, Color(0, 0, 0))
			gctOS.VGUI.Label(v, 18, 159+48 + 24 * (k-1), panel)
		end
	else
		local panel = parent:Add("DScrollPanel")
		panel:SetPos(0, 0)
		panel:SetSize(270, 360)
		panel.Paint = function(pnl, w, h) 
			surface.SetDrawColor(32, 32, 32)
			surface.DrawRect(0, 0, w, h)
		end
		panel:GetVBar():SetWide(2)
		panel:GetVBar().Paint = function() end
		panel:GetVBar().btnGrip.Paint = function(p1, w1, h1) 
			draw.RoundedBox(0, 0, 0, w1, h1, Color(255, 255, 255, 64))
		end
		for k, v in pairs(apps) do
			local appb = panel:Add("DPanel")
			appb:SetPos(0, (k-1)*104)
			appb:SetSize(270, 96)
			appb.Paint = function(p, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(64, 64, 64))
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material(v.Icon))
				surface.DrawTexturedRect(8, 8, 48, 48)
				draw.SimpleText(v.Name, "Profiler2_Name", 64, 24)
			end
			gctOS.VGUI.Label(v.Description, 8, (k-1)*104+8+48+8, panel)
		end
	end
end

local App = {
	Name = "Manuals",
	Description = "Addon Manuals",
	Icon = "apps/manuals.png",
	Function = function(panel)
		pnl = panel:Add("DScrollPanel")
		pnl:Dock(FILL)
		pnl.Paint = function(panel, w, h)
			surface.SetDrawColor(32, 32, 32)
			surface.DrawRect(0, 0, w, h)
		end
		local vbar = pnl:GetVBar()
		vbar:SetWide(2)
		vbar.Paint = function() end
		vbar.btnUp.Paint = function() end
		vbar.btnDown.Paint = function() end
		vbar.btnGrip.Paint = function(pnl, w, h) 
			surface.SetDrawColor(128, 128, 128)
			surface.DrawRect(0, 0, w, h)
		end
		gctOS.VGUI.Image(Material("logo.png"), 270/2 - 145/2, 8, 145, 90, pnl)
		gctOS.VGUI.Label("gctOS is addon that adds Watch Dogs 2 hacking\nexperience to Garry's Mod.", 12, 106, pnl)

		for k, v in pairs(manuals) do
			local mbutton = pnl:Add("DButton")
			mbutton:SetPos(0, 142 + (k-1) * 24)
			mbutton:SetSize(270, 24)
			mbutton:SetText("")
			mbutton.Paint = function(button, w, h)
				draw.RoundedBox(0, 0, 0, 270, 24, Color(32, 32, 32))
				draw.SimpleText(v.title, "DermaDefault", 270/2, 6, Color(255 - 128*booltonumber(mbutton:IsHovered()), 255 - 128*booltonumber(mbutton:IsHovered()), 255 - 128*booltonumber(mbutton:IsHovered())), TEXT_ALIGN_CENTER)
				--draw.SimpleText(">", "DermaDefault", w - 24, 6, Color(255, 255, 255))
				surface.SetDrawColor(64, 64, 64, booltonumber(mbutton:IsHovered())*255)
				surface.DrawRect(0, 23, 270, 1)
				surface.DrawRect(0, 0, 270, 1)
				surface.DrawRect(0, 0, 16, 24)
				surface.DrawRect(254, 0, 16, 24)
			end
			mbutton.DoClick = function() 
				viewManual(v, pnl)
			end
		end
	end
}

gctOS.AddApp(App)
