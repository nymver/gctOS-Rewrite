-- [[ FOG IS COMING]] --








































apps = {}
Smartphone_Offset = 0
SmartphoneOpen = false
fastapp = {}
app = {}
smartphone = nil
local applist_temp = nil
local utillist_temp = nil
local OpenSButton = {}
function gctOS.AddApp(App)
	apps[#apps + 1] = App
end

for k, v in pairs(file.Find("smartphone_apps/*", "LUA")) do
	AddCSLuaFile("smartphone_apps/"..v)
	include("smartphone_apps/"..v)
end

function openSmartphone()
	SmartphoneOpen = true
	smartphone = vgui.Create("DFrame")
	smartphone:SetPos(20+hud_safezone:GetInt(), ScrH()-35-10-20-360+25-hud_safezone:GetInt())
	smartphone:SetSize(270, 380)
	smartphone:ShowCloseButton(false)
	smartphone:SetDraggable(false)
	smartphone:MakePopup()
	smartphone:SetTitle("")
	createOpenButton(smartphone, 0, 360)
	smartphone.Paint = function(pnl, w, h) 
		surface.SetDrawColor(0, 0, 0, 128*Smartphone_Offset)
		surface.DrawRect(0, 360-360*Smartphone_Offset, 270, 360*Smartphone_Offset)
		surface.SetDrawColor(200, 200, 200, 64*Smartphone_Offset)
		--surface.DrawRect(8, 360-82, w-16, 1)

		--draw.RoundedBox(48, 4, 360-48-16-8, w-8, 64, Color(0, 0, 0, 128*Smartphone_Offset))
		surface.SetDrawColor(6, 171, 255, 200 - 200*Smartphone_Offset)
		surface.DrawRect(0, 360-360*Smartphone_Offset, 270, 360*Smartphone_Offset)
		surface.SetDrawColor(0, 0, 0, 64)
		surface.DrawRect(0, 380-102, 270, 102)
	end
	local apps_list = smartphone:Add("DScrollPanel")
	apps_list:SetSize(270, 360-82)
	apps_list:SetAlpha(255)
	applist_temp = apps_list
	local util_list = smartphone:Add("DScrollPanel")
	util_list:SetSize(270, 82)
	util_list:SetPos(0, 360-82)
	utillist_temp = util_list
	apps_list.Paint = function() end
	apps_list:GetVBar():SetWide(6)
	apps_list:GetVBar().btnGrip.Paint = function(p1, w1, h1) 
		draw.RoundedBox(0, 0, 0, w1, h1, Color(255, 255, 255, 64*Smartphone_Offset))
	end
	util_list.Paint = function() end
	util_list:GetVBar():SetWide(6)
	util_list:GetVBar().btnGrip.Paint = function(p1, w1, h1) 
		draw.RoundedBox(0, 0, 0, w1, h1, Color(255, 255, 255, 64*Smartphone_Offset))
	end
	local x = 0
	local y = 4
	local a1 = 0
	local u1 = 0
	local x2 = 0
	local y2 = 0
	for k, v in pairs(apps) do
		if(v.Util) then
			u1 = u1 + 1
			local button = util_list:Add("DButton")
			button:SetText("")
			button:SetSize(72, 76)
			button:SetPos(4+x2, 4+y2)
			button.Paint = function()
				surface.SetDrawColor(255, 0, 0, 255*Smartphone_Offset) 
				draw.CircleProgress(36, 38, 24, 360, 1 - getAnim("cast_cooldown"), 0)
				draw.RoundedBox(48, 36-18, 38-18, 36, 36, Color(16, 16, 16, 255*Smartphone_Offset))
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material(v.Icon))
				surface.DrawTexturedRectCenter(36, 38, 48, 48)
				if(button:IsHovered()) then
					draw.RoundedBox(4, 72-18, 0, 18, 18, Color(0, 0, 0))
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(Material(GetKeyPic(108)))
					surface.DrawTexturedRect(72-16, 0, 16, 16)
				end	
				if(fastapp == v) then
					draw.RoundedBox(4, 72-18, 0, 18, 18, Color(0, 0, 0))
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(Material(GetKeyPic(gctOS.Bindings.FastApp)))
					surface.DrawTexturedRect(72-16, 0, 16, 16)
				end
			end
			button.OnMousePressed = function(s, code)  
				if(code == 107) then
					if(getAnim("cast_cooldown") == 1) then
						app_panel = vgui.Create("DPanel", smartphone, v.Name.."_Panel")
						app_panel:SetPos(0, 0)
						app_panel:SetSize(270, 360)
						v.Function(app_panel, smartphone, OpenSButton)
						app = {Name = v.Name, Panel = app_panel}
						runAnim("FastApp", 1)
						runAnim("cast_cooldown", GetConVar("sv_gctos_facooldown"):GetInt())
					end
				elseif(code == 108) then
					fastapp = v
				end
			end
			x2 = x2 + 64
			if(u1/4 == math.floor(u1/4)) then
				x2 = 0
				y2 = y2 + 76
			end
		else
			a1 = a1 + 1
			local button = apps_list:Add("DButton")
			button:SetText("")
			button:SetSize(76, 76)
			button:SetPos(4+x, 4+y)
			button.Paint = function() 
				surface.SetDrawColor(255, 255, 255, 255*Smartphone_Offset)
				surface.SetMaterial(Material(v.Icon))
				surface.DrawTexturedRectCenter(36, 38, 48, 48)
				draw.SimpleText(button:IsHovered() && v.Name || "", "Smartphone", 36, 64, Color(255, 255, 255), TEXT_ALIGN_CENTER)
				if(button:IsHovered()) then
					draw.RoundedBox(4, 72-18, 0, 18, 18, Color(0, 0, 0))
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(Material(GetKeyPic(108)))
					surface.DrawTexturedRect(72-16, 0, 16, 16)
				end	
				if(fastapp == v) then
					draw.RoundedBox(4, 72-18, 0, 18, 18, Color(0, 0, 0))
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(Material(GetKeyPic(gctOS.Bindings.FastApp)))
					surface.DrawTexturedRect(72-16, 0, 16, 16)
				end
			end
			button.OnMousePressed = function(s, code) 
				if(code == 107) then
					apps_list:SetAlpha(0)
					util_list:SetAlpha(0)
					app_panel = vgui.Create("DPanel", smartphone, v.Name.."_Panel")
					app_panel:SetPos(0, 0)
					app_panel:SetSize(270, 360)
					v.Function(app_panel, smartphone, OpenSButton)
					app = {Name = v.Name, Panel = app_panel}
				elseif(code == 108) then
					fastapp = v
				end
			end
			x = x + 92
			if(a1/3 == math.floor(a1/3)) then
				x = 0
				y = y + 76
			end
			button.DoClick = function() end
		end
	end
end

function closeSmartphone()
	SmartphoneOpen = false
	app = {}
	OpenSButton:Remove()
	smartphone:Remove()
	createOpenButton(g_ContextMenu, 20+hud_safezone:GetInt(), ScrH()-40-hud_safezone:GetInt())
end

function createOpenButton(parent, x, y)
	OpenSButton = parent:Add("DButton")
	OpenSButton:SetPos(x, y)
	OpenSButton:SetSize(270, 20)
	OpenSButton.Paint = function() end
	OpenSButton:SetText("")
	OpenSButton.DoClick = function() 
		runAnim("SmartphoneOpen", 0.5)
		if(!table.IsEmpty(app)) then
			applist_temp:SetAlpha(255)
			utillist_temp:SetAlpha(255)
			app.Panel:Remove()
			app = {}
		else
			if(SmartphoneOpen) then closeSmartphone(OpenSButton) else openSmartphone(OpenSButton) end
		end
	end
end

if(CLIENT) then
	hook.Add("Think", "gctOS_Smartphone", function() 
		Smartphone_Offset = Lerp(0.25, Smartphone_Offset, SmartphoneOpen && 1 || 0)
	end)
	createOpenButton(g_ContextMenu, 20+hud_safezone:GetInt(), ScrH()-40-hud_safezone:GetInt())
end