if(SERVER) then
	util.AddNetworkString("SS_SetProfiler")

	net.Receive("SS_SetProfiler", function(length, ply) 
		local info = net.ReadTable()
		local e = Entity(info.EntIndex)
		if(e.Object.Type == 1) then
			gctOS.PFuncs.SetType1(Entity(info.EntIndex), info)
		else
			gctOS.PFuncs.SetType2(Entity(info.EntIndex), info)
		end
		Entity(info.EntIndex):SetNWBool("CustomProfiler", true)
	end)
end
local x = 0
local y = 0
local App = {
	Name = "Set Profiler",
	Description = "Customize objects profiler",
	Icon = "apps/profiler.png",
	Function = function(panel)
		local i1, i2, i3, i4 = nil
		if(target.Object.Type == 2) then
			panel.Paint = function(panel, w, h)
				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor(0, 0, 0, 64)
				surface.DrawRect(x, y, 270, 132)
				surface.DrawRect(x+5, y+5, 260, 122)
				surface.SetDrawColor(57, 57, 57, 255)
				surface.DrawRect(x+5, y+5, 260, 25)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawRect(x+10, y+10, 18, 3)
				surface.DrawRect(x+10, y+15, 18, 3)
				surface.DrawRect(x+10, y+20, 18, 3)
				surface.SetDrawColor(Color(247, 104, 2, 150))
				surface.DrawRect(x+5, y+30, 260, 55)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(Material("citizens/glitch.png"))
				surface.DrawTexturedRectRotated(x+35, y+57, 50, 50, 0)
				surface.DrawTexturedRectRotated(x+35+math.random(-2, 2), y+57+math.random(-2, 2), 50, 50, 0)
				surface.DrawTexturedRectRotated(x+35+math.random(-2, 2), y+57+math.random(-2, 2), 50, 50, 0)
			   -- draw.SimpleText("aaaaaaaaaaaaaa", "Profiler2_Name", x+72, y+33, Color(255, 255, 255, 255))
			   -- draw.SimpleText("bla, bla, bla", "Profiler_Description", x+72, y+48, Color(255, 255, 255, 255))
			   -- draw.SimpleText("bla?", "Profiler2_Name", x+35-24, y+87)
			   -- draw.SimpleText("bla!", "Profiler2_Name", x+35-24, y+107)
			end
			i1 = panel:Add("DTextEntry")
			i1:SetSize(270, 20)
			i1:SetPos(x+69, y+31)
			i1:SetValue("Name")
			i1:SetFont("Profiler2_Name")
			i1:SetPaintBackground()
			i1:SetTextColor(Color(255, 255, 255))
			i2 = panel:Add("DTextEntry")
			i2:SetSize(270, 20)
			i2:SetPos(x+69, y+46)
			i2:SetValue("Description")
			i2:SetFont("Profiler_Description")
			i2:SetPaintBackground()
			i2:SetTextColor(Color(255, 255, 255))
			i3 = panel:Add("DTextEntry")
			i3:SetSize(270, 20)
			i3:SetPos(x+32-24, y+85)
			i3:SetValue("Info 1")
			i3:SetFont("Profiler2_Name")
			i3:SetPaintBackground()
			i3:SetTextColor(Color(255, 255, 255))
			i4 = panel:Add("DTextEntry")
			i4:SetSize(270, 20)
			i4:SetPos(x+32-24, y+105)
			i4:SetValue("Info 2")
			i4:SetFont("Profiler2_Name")
			i4:SetPaintBackground()
			i4:SetTextColor(Color(255, 255, 255))
		else
			panel.Paint = function(panel, w, h)
				surface.SetDrawColor(0, 0, 0, 64)
				surface.DrawRect(x, y, 270, 125)
				surface.DrawRect(x+5, y+5, 260, 115)
				surface.SetDrawColor(57, 57, 57, 255)
				surface.DrawRect(x+5, y+5, 260, 25)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawRect(x+10, y+10, 18, 3)
				surface.DrawRect(x+10, y+15, 18, 3)
				surface.DrawRect(x+10, y+20, 18, 3)
				surface.SetDrawColor(Color(0, 0, 0))
				surface.SetMaterial(Material("blank.png"))
				surface.DrawTexturedRectRotated(x+50, y+75, 48, 48, 45)
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(Material("hacks/hack_power.png"))
				surface.DrawTexturedRectCenter(x+50, y+75, 30, 30)
				--draw.SimpleText("hehe", "Profiler_Name", x+90, y+40, Color(255, 255, 255, 255))
				--draw.SimpleText("Hack to get sex", "Profiler_Description", x+90, y+55, Color(255, 255, 255, 255))
			end
			i1 = panel:Add("DTextEntry")
			i1:SetSize(270, 20)
			i1:SetPos(x+87, y+38)
			i1:SetValue("Name")
			i1:SetFont("Profiler_Name")
			i1:SetPaintBackground()
			i1:SetTextColor(Color(255, 255, 255))
			i2 = panel:Add("DTextEntry")
			i2:SetSize(270, 20)
			i2:SetPos(x+87, y+53)
			i2:SetValue("Description")
			i2:SetFont("Profiler_Description")
			i2:SetPaintBackground()
			i2:SetTextColor(Color(255, 255, 255))
		end 
		--[[
		local lbl = panel:Add( "DLabel" )
		lbl:SetText("Name")
		lbl:SetTextColor(Color(255, 255, 255, 255))
		lbl:Dock( TOP )
		lbl:DockMargin( 8, 8, 0, 0 )
		local i1 = panel:Add("DTextEntry")
		i1:Dock(TOP)
		i1:DockMargin(8, 0, 8, 0)
		local lbl = panel:Add( "DLabel" )
		lbl:SetText("Description")
		lbl:SetTextColor(Color(255, 255, 255, 255))
		lbl:Dock( TOP )
		lbl:DockMargin( 8, 8, 0, 0 )
		local i2 = panel:Add("DTextEntry")
		i2:Dock(TOP)
		i2:DockMargin(8, 0, 8, 0)
		local lbl = panel:Add( "DLabel" )
		lbl:SetText("Info1")
		lbl:SetTextColor(Color(255, 255, 255, 255))
		lbl:Dock( TOP )
		lbl:DockMargin( 8, 8, 0, 0 )
		local i3 = panel:Add("DTextEntry")
		i3:Dock(TOP)
		i3:DockMargin(8, 0, 8, 0)
		local lbl = panel:Add( "DLabel" )
		lbl:SetText("Info2")
		lbl:SetTextColor(Color(255, 255, 255, 255))
		lbl:Dock( TOP )
		lbl:DockMargin( 8, 8, 0, 0 )
		local i4 = panel:Add("DTextEntry")
		i4:Dock(TOP)
		i4:DockMargin(8, 0, 8, 0)
		]]
		local apply = panel:Add("DButton")
		apply:SetText("Apply")
		apply:Dock( TOP )
		apply:DockMargin(8, 150, 8, 8)
		apply.DoClick = function()
			if(IsValid(target)) then
				net.Start("SS_SetProfiler")
				local Info = nil
				if(target.Object.Type == 2) then
					Info = {Emotion = "", EntIndex = target:EntIndex(), Name = i1:GetValue(), Description = i2:GetValue(), Description2 = "", Info1 = i3:GetValue(), Info2 = i4:GetValue(), Icon = "citizens/glitch.png", Color = Color(255, 0, 0), IColor = Color(0, 0, 0)}
				else
					Info = {EntIndex = target:EntIndex(), Name = i1:GetValue(), Description = i2:GetValue(), Description2 = "", Icon = "hack_power.png"}
				end
				net.WriteTable(Info)
				net.SendToServer()
			else
			end
		end
	end
}

gctOS.AddApp(App)