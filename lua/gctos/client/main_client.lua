-- [[ FOG IS COMING]] --








































--[[
	gctOS Rewrite

	Main (Client)
]]

Botnet = GetConVar("sv_gctos_defaultbotnet"):GetInt()
hackmenu = false
profiler = false
nethack = false
nethack_hacked = NULL
target = NULL
tcamera = NULL
rcoff = 0
keys_n = {"r", "f", "c", "space"}
hack_keys = {}
symbols = {"!", "@", "#", "$", "%", "^", "&", "*", "?", "/", "\\", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
ToDrain = 0
ToRegenerate = regenerate_botnet:GetInt()
Delay = regenerate_botnet_del:GetInt()
CT = CurTime()+Delay
tpos = Vector()
hcount = 0
unavailable = {0, 0, 0, 0}
bcolor1 = Color(6, 171, 240)
bcolor2 = Color(255, 255, 255)
bcolor3 = Color(0, 0, 0)
hm_opencolor = 0
camhack = 0
nethack_botnet = 0
cht = false
mp_hobjects = {}
linerand = math.random()

c_ent = LocalPlayer()
glitch = 0

acq_info = {Show = false, Info1 = "", Info2 = "", Info3 = "", Color = "", Icon = "", Start = false}
prog_info = {Show = false, Info1 = "", Start = false, Progress = 0}


misc_renderfunctions = {}

cast_cooldown = 10

saved_cams = {}

transition_camview = {
	x = 0,
	y = 0,
	w = ScrW(),
	h = ScrH(),
	drawviewmodel = true,
	drawhud = false,
	znear = 1,
	zfar = 100000,
	fov = 90,
	origin = LocalPlayer():EyePos(),
	angles = LocalPlayer():EyeAngles()
}

showhints = true


table.insert(hack_keys, gctOS.Bindings.Hack1, 1)
table.insert(hack_keys, gctOS.Bindings.Hack2, 2)
table.insert(hack_keys, gctOS.Bindings.Hack3, 3)
table.insert(hack_keys, gctOS.Bindings.Hack4, 4)

function getKeyDown(key)
	return keys[input.GetKeyCode(key)]
end

function updateProfiler1(i)
	local proftab = gctOS.PFuncs.GetType1(target)
	l1 = math.Clamp(math.Round(i*string.len(target.Profiler.Name)), 0, #proftab.Name)
	Profiler1_Text.Name = string.sub(string.SetChar(Profiler1_Text.Name, l1+1, symbols[math.random(1, #symbols)]), 0, #proftab.Name)
	Profiler1_Text.Name = string.sub(string.SetChar(Profiler1_Text.Name, l1, proftab.Name[l1]), 0, l1+1)
	l2 = math.Clamp(math.Round(i*string.len(proftab.Description)), 0, #proftab.Description)
	Profiler1_Text.D1 = string.sub(string.SetChar(Profiler1_Text.D1, l2+1, symbols[math.random(1, #symbols)]), 0, #proftab.Description)
	Profiler1_Text.D1 = string.sub(string.SetChar(Profiler1_Text.D1, l2, proftab.Description[l2]), 0, l2+1)
	l3 = math.Clamp(math.Round(i*string.len(proftab.Description2)), 0, #proftab.Description2)
	Profiler1_Text.D2 = string.sub(string.SetChar(Profiler1_Text.D2, l3+1, symbols[math.random(1, #symbols)]), 0, #proftab.Description2)
	Profiler1_Text.D2 = string.sub(string.SetChar(Profiler1_Text.D2, l3, proftab.Description2[l3]), 0, l3+1)
end

function updateProfiler2(i)
	local proftab = gctOS.PFuncs.GetType2(target)
	l1 = math.Clamp(math.Round(i*string.len(proftab.Name)), 0, #proftab.Name)
	Profiler2_Text.Name = string.sub(string.SetChar(Profiler2_Text.Name, l1+1, symbols[math.random(1, #symbols)]), 0, #proftab.Name)
	Profiler2_Text.Name = string.sub(string.SetChar(Profiler2_Text.Name, l1, proftab.Name[l1]), 0, l1+1)
	l2 = math.Clamp(math.Round(i*string.len(proftab.Description)), 0, #proftab.Description)
	Profiler2_Text.D1 = string.sub(string.SetChar(Profiler2_Text.D1, l2+1, symbols[math.random(1, #symbols)]), 0, #proftab.Description)
	Profiler2_Text.D1 = string.sub(string.SetChar(Profiler2_Text.D1, l2, proftab.Description[l2]), 0, l2+1)
	l3 = math.Clamp(math.Round(i*string.len(proftab.Description2)), 0, #proftab.Description2)
	Profiler2_Text.D2 = string.sub(string.SetChar(Profiler2_Text.D2, l3+1, symbols[math.random(1, #symbols)]), 0, #proftab.Description2)
	Profiler2_Text.D2 = string.sub(string.SetChar(Profiler2_Text.D2, l3, proftab.Description2[l3]), 0, l3+1)
	l4 = math.Clamp(math.Round(i*string.len(proftab.Info1)), 0, #proftab.Info1)
	Profiler2_Text.I1 = string.sub(string.SetChar(Profiler2_Text.I1, l4+1, symbols[math.random(1, #symbols)]), 0, #proftab.Info1)
	Profiler2_Text.I1 = string.sub(string.SetChar(Profiler2_Text.I1, l4, proftab.Info1[l4]), 0, l4+1)
	l5 = math.Clamp(math.Round(i*string.len(proftab.Info2)), 0, #proftab.Info2)
	Profiler2_Text.I2 = string.sub(string.SetChar(Profiler2_Text.I2, l5+1, symbols[math.random(1, #symbols)]), 0, #proftab.Info2)
	Profiler2_Text.I2 = string.sub(string.SetChar(Profiler2_Text.I2, l5, proftab.Info2[l5]), 0, l5+1)	
end

function startAcquired(desc1, desc2, desc3, color, icon)
	acq_info.Show = true
	acq_info.Start = true
	acq_info.Info1 = desc1
	acq_info.Info2 = desc2
	acq_info.Info3 = desc3
	acq_info.Color = color
	acq_info.Icon = icon
	local acount = runAnim("AcquiredGlitch", 1)
	timer.Simple(5, function() 
		if(countAnim("AcquiredGlitch") == acount) then
			runAnim("AcquiredGlitch", 0.25)
			acq_info.Start = false
			timer.Simple(0.25, function() 
				acq_info.Show = false
			end)
		end
	end)
end

function startProgress(animname, desc, delay)
	prog_info.Info1 = desc
	prog_info.Show = true
	prog_info.Start = true
	runAnim("ProgGlitch", 0.25, false, function(i) 
		if(i==1) then
			prog_info.Start = false
		end
	end)
	runAnim(animname, delay, false, function(i) 
		prog_info.Progress = i
	end)
	timer.Simple(delay, function() 
		runAnim("ProgGlitch", 0.25, false, function(i) 
			prog_info.Show = false
		end)
	end)
end

function downloadAvatar(steam64)
	if(!file.Exists("avatars/"..steam64..".jpg", "DATA")) then
		http.Fetch("https://steamcommunity.com/profiles/"..steam64.."?xml=1", function(body, headers) 
			local url = string.match(body, "<avatarMedium>.-(https?://%S+%f[%.]%.)(%w+).-</avatarMedium>").."jpg"
			http.Fetch(url, function(body)
				file.Write("avatars/"..steam64..".jpg", body)
			end)
		end)
	end
end

if(!game.SinglePlayer()) then
	for k, v in pairs(player.GetAll()) do
		if(!v:IsBot()) then downloadAvatar(v:SteamID64()) end
		end
	hook.Add("PlayerInitialSpawn", "gctOS_DownloadAvatar", function()
		if(!ply:IsBot()) then 
			downloadAvatar(ply:SteamID64())
		end
	end)
end

hook.Add("gctOS_Botnet", "gctOS_Botnet", function(botnet)
	if(GetConVar("sv_gctos_drainbotnet"):GetInt() == 1 || botnet<0) then
		ToDrain = botnet
		Botnet = math.Clamp(Botnet - (botnet), 0, 20)
		if(botnet < 0) then
			runAnim("BotnetAdd", 0.175, false, function(i)
				if((i>0.25 && i<0.5) || (i>0.75 && i<1)) then 
					bcolor1 = Color(255, 255, 255)
					bcolor2 = Color(6, 171, 240) 
					bcolor3 = Color(255, 255, 255)  
				else 
					bcolor1 = Color(6, 171, 240)
					bcolor2 = Color(255, 255, 255) 
					bcolor3 = Color(0, 0, 0)  
				end  
				if(i==1) then setAnim("BotnetAdd", 0) end
			end)
			startAcquired("Botnet recharge", "Item(s) acquired:", "Botnet resources", Color(6, 171, 240), "hacks/hack_botnet.png")
		else
			runAnim("BotnetDrain", 1, false, function(i) 
				if(i==1) then setAnim("BotnetDrain", 0) end
			end)
		end
	end
end)

hook.Add("HUDPaint", "gctOS_HUD_Tips", function()
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		draw.NoTexture()
		draw.RoundedBox(12, 12, 12, 220, 54, Color(255, 255, 255, 255*math.abs(math.sin(CurTime()*5))))
		draw.RoundedBox(12, 13, 13, 218, 52, Color(0, 0, 0, 255))
		draw.SimpleText("Press       to toggle Profiler", "Profiler2_Name", 24, 16, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		draw.SimpleText("Press       to toggle NetHack", "Profiler2_Name", 24, 42, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		surface.SetMaterial(Material(GetKeyPic(gctOS.Bindings.Profiler)))
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(70, 16, 16, 16)
		surface.SetMaterial(Material(GetKeyPic(gctOS.Bindings.NetHack)))
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(70, 42, 16, 16)

		draw.NoTexture()
		surface.SetDrawColor(0, 0, 0) 
		--surface.DrawRect(10, ScrH()-35-15-25, 290, 65)
		surface.SetDrawColor(255, 255, 255, 255*math.abs(math.sin(CurTime()*5)))
		surface.DrawRect(10, ScrH()-35-15-25-360*Smartphone_Offset, 1, 65+360*Smartphone_Offset)
		surface.DrawRect(10, ScrH()-35-15-25-360*Smartphone_Offset, 290, 1)
		surface.DrawRect(300, ScrH()-35-15-25-360*Smartphone_Offset, 1, 65+360*Smartphone_Offset)
		surface.DrawRect(10, ScrH()-10, 290, 1)
		draw.RoundedBox(12, 339, ScrH()-42, 314, 24, Color(255, 255, 255, 255*math.abs(math.sin(CurTime()*5))))
		draw.RoundedBox(12, 340, ScrH()-41, 312, 22, Color(0, 0, 0, 255))

		draw.RoundedBox(12, 300 + math.abs(math.sin(CurTime()*5))*10, ScrH()-39, 18, 18, Color(255, 255, 255, 255*math.abs(math.sin(CurTime()*5))))
		draw.RoundedBox(12, 301 + math.abs(math.sin(CurTime()*5))*10, ScrH()-38, 16, 16, Color(0, 0, 0, 255))
		draw.SimpleText("<", "Profiler2_Name", 305 + math.abs(math.sin(CurTime()*5))*10, ScrH()-38)
		draw.SimpleText("Press here to open smartphone (Hold      )", "Profiler2_Name", 352, ScrH()-38, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		surface.SetMaterial(Material("keys/c.png"))
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(620, ScrH()-38, 16, 16)
	end
end)

hook.Add("Think", "gctOS_BotnetHandler", function() 
	ToRegenerate = GetConVar("sv_gctos_botnetregenerate"):GetInt()
	Delay = GetConVar("sv_gctos_botnetregeneratedelay"):GetInt()
	Default = GetConVar("sv_gctos_defaultbotnet"):GetInt()
	if(CT<CurTime() && Botnet<20 && Botnet<ToRegenerate) then
		CT = CurTime() + Delay
		Botnet = Botnet + 1
		if(Botnet == 1 && IsValid(target)) then
			Profiler1_Text = {
				Name = "",
				D1 = "",
				D2 = ""
			}
			Profiler2_Text = {
				Name = "",
				D1 = "",
				D2 = "",
				I1 = "",
				I2 = ""
			}
			runAnim("ProfilerStart1", 1, false)
			runAnim("ProfilerStart2", 0.5, false, function(i)
				if(target.Object) then
					if(target.Object.Type == 1) then  
						updateProfiler1(i)
					elseif(target.Object.Type == 2) then
						updateProfiler2(i)
					end
				end
			end)
		end
		runAnim("BotnetAdd", 0.175, false, function(i)
			if((i>0.25 && i<0.5) || (i>0.75 && i<1)) then 
				bcolor1 = Color(255, 255, 255)
				bcolor2 = Color(6, 171, 240) 
				bcolor3 = Color(255, 255, 255)  
			else 
				bcolor1 = Color(6, 171, 240)
				bcolor2 = Color(255, 255, 255) 
				bcolor3 = Color(0, 0, 0)  
			end  
			if(i==1) then setAnim("BotnetAdd", 0) end
		end)
	end
	if(Botnet>=ToRegenerate) then
		CT = CurTime() + Delay
	end
	if(!LocalPlayer():Alive()) then
		Botnet = Default
	end
end)

hook.Add("gctOS_KeyHandler", "gctOS_KeyHandler", function(key)
	if(!IsValid(LocalPlayer():GetNWEntity("gctOS_Terminal")) && !vgui.CursorVisible()) then
		if(key == gctOS.Bindings.Profiler) then
			rcoff = math.random()
			profiler = !profiler
			runAnim("ProfilerOnOff", 1, false)
			hook.Remove('HUDPaint', "gctOS_HUD_Tips")
		end
		if(key == gctOS.Bindings.Hackmenu && IsValid(target)) then
			if(!nethack) then
			Profiler1_Text = {
				Name = "",
				D1 = "",
				D2 = ""
			}
			Profiler2_Text = {
				Name = "",
				D1 = "",
				D2 = "",
				I1 = "",
				I2 = ""
			}
			end
			hackmenu = !hackmenu
			glitch = 15
			rcoff = math.random()
			linerand = math.random()
			runAnimLerp("LineGlitch", 0.1, 1, 0)
			runAnim("Lines", 0.25, true)
			runAnim("HackMenu", 0.4, false, function(i) 
				if((i>0.25 && i<0.5) || (i>0.75 && i<1)) then 
					hm_opencolor = 255
				else 
					hm_opencolor = 0
				end  
			end)
			if((hackmenu && !nethack) && target.Object) then
				runAnim("ProfilerStart1", 1, false)
				runAnim("ProfilerStart3", 0.15, false, function(r) 
					if(target.Object) then
						if(r==0.25) then
							runAnim("ProfilerStart2", 0.5, false, function(i)
								if(target.Object) then
									if(target.Object.Type == 1) then  
										updateProfiler1(i)
									elseif(target.Object.Type == 2) then
										updateProfiler2(i)
									end
								end
							end)
						end
					end
				end)
			elseif(!nethack) then
				runAnim("ProfilerStart1", 0.25, false)
				runAnim("ProfilerStart3", 0.15, false)
			end
		end
		local hack = (target.Object != nil && target.Object.Type != 3) && target.Object.Hacks[hack_keys[key]] || nil
		if(hackmenu && IsValid(target) && hack != nil) then
			if(LocalPlayer():GetNWBool("gctOS_Access") && target.Blackouted != true && (((Botnet>0) && (drain_botnet:GetInt()==0) || math.ceil(nethack_botnet) < Botnet) || hack.Icon == "hack_botnet.png") && !table.IsEmpty(hack) && !gctOS.GetHackUsed(target, hack_keys[key]) && gctOS.GetHackStatus(target, hack_keys[key]) && table.HasValue(keys_n, string.lower(input.GetKeyName(key))) && (Botnet > hack.Cost - 1 || drain_botnet:GetInt()==0) && !target:GetNWBool("Blocked") && !target:GetNWBool("Disconnected") && (GetConVar("sv_gctos_ofa"):GetInt() == 0 || LocalPlayer():IsAdmin())) then
				Profiler1_Text = {
					Name = "",
					D1 = "",
					D2 = ""
				}
				Profiler2_Text = {
					Name = "",
					D1 = "",
					D2 = "",
					I1 = "",
					I2 = ""
				}
				hcount = hcount + 1
				runAnim("H"..target:EntIndex(), 0.15)
				hook.Run("gctOS_Hack", target, hack_keys[key])
				runAnim("Lines", 0.25, true)
				nethack_hacked = target
				runAnim("NetHack_HLines", 1)
				runAnim("Profiler_Temp", 0.5, false, function(i) 
					if(target.Object) then
						if(target.Object.Type == 1) then  
							updateProfiler1(i)
						elseif(target.Object.Type == 2) then
							updateProfiler2(i)
						end
					end
				end)
				rcoff = math.random()
				linerand = math.random()
				glitch = 50
				if(hack.Icon == "hack_circuit.png") then
					c_ent:EmitSound("wd2_hack.mp3", 100, 130)
				elseif(hack.Icon == "hack_botnet.png" || hack.Icon == "hack_vforward.png" || hack.Icon == "hack_vback.png" || hack.Icon == "hack_vleft.png" || hack.Icon == "hack_vright.png" || hack.Icon == "hack_phonedest.png" || hack.Icon == "hack_combine.png" || hack.Icon == "hack_resistance.png") then
					c_ent:EmitSound("botnet.mp3")
				elseif(hack.Icon == "hack_explode.png") then
					c_ent:EmitSound("wd2_hack.mp3")
				else
					c_ent:EmitSound("wd2_hack.mp3")
				end
			else
				runAnim("Unavailable", 0.5, false, function(i) 
					if((i>0.25 && i<0.5) || (i>0.75 && i<1)) then 
						unavailable[hack_keys[key]] = 1
					else 
						unavailable[hack_keys[key]] = 0
					end  
				end)
			end
		end
		
		if(!table.IsEmpty(fastapp) && Botnet == 20 && ((getAnim("cast_cooldown")==1 && LocalPlayer():GetNWBool("Blocked") == false && LocalPlayer():GetNWBool("gctOS_Access") == true && nethack_botnet == 0) || fastapp.Util == false)) then
			if(key == gctOS.Bindings.FastApp) then
				runAnim("FastApp", 1)
				if(fastapp.Util) then
					runAnim("cast_cooldown", GetConVar("sv_gctos_facooldown"):GetInt())
					hook.Run("gctOS_Botnet", 20)
				end
				if(!fastapp.Util) then
					openSmartphone(OpenSButton)
					timer.Simple(0.51, function() 
						app_panel = vgui.Create("DPanel", smartphone, fastapp.Name.."_Panel")
						app_panel:SetPos(0, 0)
						app_panel:SetSize(270, 360)
						fastapp.Function(app_panel, smartphone, OpenSButton)
						app = {Name = fastapp.Name, Panel = app_panel}
					end)
				else
					fastapp.Function()
				end
			end
		end

		camhack = 0
		function camhackt(ent) 
			runAnim("NetHack", 1)
			net.Start("gctOS_Hack_Type3")
			net.WriteEntity(ent)
			net.SendToServer()
			ent.Object.Hack(c_ent, ent)
			c_ent = ent
			camhack = 0
			cht = true
			runAnim("CamHack_Transition", 1, false)
			timer.Simple(1, function() cht = false runAnim("NetHack", 1) tcamera = NULL end)
			sound.Play("cam_hack.mp3", c_ent:GetPos())
			if(!table.HasValue(saved_cams, ent)) then
				saved_cams[#saved_cams + 1] = ent
			end
			tcamera = NULL
		end
		if(key == gctOS.Bindings.CamHack && IsValid(tcamera) && !IsValid(tcamera:GetNWEntity("gctOS_Hacker"))) then
			runAnim("CameraHack", 0.5, false, function(i)
				if(input.IsKeyDown(gctOS.Bindings.CamHack) && !IsValid(tcamera:GetNWEntity("gctOS_Hacker"))) then
					camhack = camhack + 1/1000
					if(camhack>=1) then
						runAnim("NetHack", 1)
						net.Start("gctOS_Hack_Type3")
						net.WriteEntity(tcamera)
						net.SendToServer()
						tcamera.Object.Hack(c_ent, tcamera)
						c_ent = tcamera
						camhack = 0
						cht = true
						runAnim("CamHack_Transition", 1, false)
						timer.Simple(1, function() cht = false runAnim("NetHack", 1) tcamera = NULL end)
						sound.Play("cam_hack.mp3", c_ent:GetPos())
						if(!table.HasValue(saved_cams, tcamera)) then
							saved_cams[#saved_cams + 1] = tcamera
						end
						tcamera = NULL
					end
				else
					camhack = 0
				end
			end)
		end

		if(key == gctOS.Bindings.NetHack && (Botnet>0 && (nethack_botnet==0 || GetConVar("sv_gctos_hacknetdrainbotnet"):GetInt()==0) || nethack==true)) then
			if(nethack) then
				hook.Run("gctOS_Botnet", math.floor(nethack_botnet))
				nethack_botnet = 0
			end
			nethack = !nethack
			hook.Run("gctOS_ToggleNethack")
			runAnim("NetHack", 0.25)

			Profiler1_Text = {
				Name = "",
				D1 = "",
				D2 = ""
			}
			Profiler2_Text = {
				Name = "",
				D1 = "",
				D2 = "",
				I1 = "",
				I2 = ""
			}
			glitch = 15
			runAnimLerp("LineGlitch", 0.1, 1, 0)
			runAnim("Lines", 0.25, true)
			if(target.Object) then
				runAnim("ProfilerStart1", 1, false)
				runAnim("ProfilerStart3", 0.15, false, function(r) 
					if(target.Object) then
						if(r==0.25) then
							runAnim("ProfilerStart2", 0.5, false, function(i)
								if(target.Object) then
									if(target.Object.Type == 1) then  
										updateProfiler1(i)
									elseif(target.Object.Type == 2) then
										updateProfiler2(i)
									end
								end
							end)
						end
					end
				end)
			else
				runAnim("ProfilerStart1", 0.25, false)
				runAnim("ProfilerStart3", 0.15, false)
			end
		end

		if(IsValid(LocalPlayer():GetNWEntity("gctOS_Camera"))) then
			local camera = LocalPlayer():GetNWEntity("gctOS_Camera")
			if(key == 107) then
				camera:EmitSound("npc/scanner/scanner_photo1.wav")
				RunConsoleCommand("jpeg")
			end
			if(key == KEY_LALT) then
				c_ent = LocalPlayer()
				net.Start("gctOS_CamHack")
				net.WriteEntity(LocalPlayer():GetNWEntity("gctOS_Camera"))
				net.SendToServer()
				cht = true
				runAnim("NetHack", 1)			
				runAnim("CamHack_Transition", 1, false)
				timer.Simple(1, function() cht = false runAnim("NetHack", 1) end)
				LocalPlayer():EmitSound("cam_hack.mp3")
			end
		end
	end

	if(IsValid(LocalPlayer():GetNWEntity("gctOS_Terminal"))) then
		local router = LocalPlayer():GetNWEntity("gctOS_Terminal")
		if(inrange(key, 1, 36) || key == 60) then
			router.Current = router.Current..input.GetKeyName(key)
		else
			if(key==64) then
				local c = router.Current
				lastc = c
				router:Enter(c)
				net.Start("gctOS_RouterEnter_"..router:EntIndex())
				net.WriteString(c)
				net.SendToServer()
			end
			if(key==65) then 
				router.Current = router.Current.." "
			end
			if(key==66) then
				router.Current = string.sub(router.Current, 1, #router.Current-1)
			end
			if(key==88) then
				router.Current = lastc || ""
			end
		end
	end
end)

hook.Add("gctOS_Hack", "gctOS_Hack", function(ent, i) 
	--Server
	net.Start("gctOS_Hack")
	net.WriteEntity(ent)
	net.WriteInt(i, 8)
	net.SendToServer()

	--Client
	local tempHI = {}
	runAnim("HHack"..i, 0.25, true)
	tempHI[ent:EntIndex()] = runAnim("Hack"..ent:EntIndex(), 0.5, true)
	ent.HackedB = true
	ent.HackedN = i
	timer.Simple(5, function()
		if(tempHI[ent:EntIndex()] == countAnim("Hack"..ent:EntIndex())) then
			ent.HackedB = false
		end
	end)
end)

hook.Add("Think", "gctOS_NetHackHandler", function() 
	if(nethack) then
		if(GetConVar("sv_gctos_hacknetdrainbotnet"):GetInt() == 1) then
			nethack_botnet = math.Clamp(nethack_botnet + 0.05, 0, Botnet)
			--hook.Run("gctOS_Botnet", 0.05)
		end
	end
	if(nethack_botnet == Botnet && nethack_botnet > 0) then
		runAnim("NetHack", 0.25)
		hook.Run("gctOS_Botnet", math.floor(nethack_botnet))
		nethack_botnet = 0
		nethack = false
	end
end)

hook.Add("Think", "gctOS_TargetHandler", function()
	transition_camview.origin = Lerp(1/6, transition_camview.origin, c_ent:EyePos() || c_ent:GetPos())
	transition_camview.angles = LerpAngle(1/6, transition_camview.angles, c_ent:EyeAngles() || c_ent:GetAngles())
	if(IsValid(LocalPlayer():GetNWEntity("DronesRewriteDrone"))) then c_ent = LocalPlayer():GetNWEntity("DronesRewriteDrone") else c_ent = IsValid(LocalPlayer():GetNWEntity("gctOS_Camera")) && LocalPlayer():GetNWEntity("gctOS_Camera") || LocalPlayer() end
	if(IsValid(target)) then
		local scrpos = target:GetPos():ToScreen()
		if((!hackmenu || !profiler || nethack) && ((scrpos.x > ScrW()) || (scrpos.x < 0) || (scrpos.y > ScrH()) || (scrpos.y < 0)) || c_ent:GetPos():Distance(tpos) > 1500) then
			runAnimLerp("LineGlitch", 0.1, 1, 0)
			glitch = 15
			target = NULL
			runAnim("NT", 0.1, false)
			hackmenu = false
			Profiler1_Text = {
				Name = "",
				D1 = "",
				D2 = ""
			}
			Profiler2_Text = {
				Name = "",
				D1 = "",
				D2 = "",
				I1 = "",
				I2 = ""
			}
		end
	end
	if(!IsValid(target) || !profiler) then
		runAnimLerp("LineGlitch", 0.1, 1, 0)
		glitch = 15
		target = NULL
		hackmenu = false
	end
	for k, v in pairs(ents.FindInSphere(c_ent:GetPos(), 1500)) do
		if(v.Object != nil && (profiler)) then
			local scrpos = v:GetPos():ToScreen()
			if(scrpos.x > 0 && scrpos.x < ScrW() && scrpos.y > 0 && scrpos.y < ScrH()) then
				if(v != c_ent && v.Object && (!hackmenu) && v.Object.Type != 3 && (!IsValid(target) || distance2D(v) < distance2D(target) --[[trace.HitPos:Distance(v:GetPos()) < trace.HitPos:Distance(target:GetPos())]]) && c_ent:GetPos():Distance(v:GetPos()) <= 1500) then
					glitch = 15
					runAnimLerp("LineGlitch", 0.1, 1, 0)
					runAnim("NT", 0.1, false)
					runAnim("Lines", 0.25, true)
					rcoff = math.random()
					target = v
					linerand = math.random()
					if(nethack==true) then
						runAnim("ProfilerStart1", 1, false)
					end
					Profiler1_Text = {
						Name = "",
						D1 = "",
						D2 = ""
					}
					Profiler2_Text = {
						Name = "",
						D1 = "",
						D2 = "",
						I1 = "",
						I2 = ""
					}
					if(nethack) then
						runAnim("ProfilerStart3", 0.15, false, function(r) 
						end)
						runAnim("ProfilerStart1", 1, false, function(r) 
							if(target.Object) then
								if(target.Object.Type == 1) then  
									updateProfiler1(r)
								elseif(target.Object.Type == 2) then
									updateProfiler2(r)
								end
							end
						end)
					end
				end
			end
		end
	end
	for k, v in pairs(ents.FindInSphere(c_ent:GetPos(), 3000)) do
		if(v.Object != nil) then
			if(v.Object.Type==3) then
				if(distance2D(v)<200 && tcamera != v && v != c_ent) then
					if(v != c_ent) then
						tcamera = v
					end
					runAnim("SelectCamera", 0.35)
				end
			end
		end
	end
	if(IsValid(tcamera)) then
		if(c_ent:GetPos():Distance(tcamera:GetPos())>3000 || profiler == false) then
			tcamera = nil
		end
	end
	tpos = IsValid(target) && target:LocalToWorld(target:OBBCenter()) --[[target:GetBonePosition(0) ]] || Vector(0, 0, 0)
	if((Botnet==0 || target.Blackouted || LocalPlayer():GetNWBool("gctOS_Access")==false) && IsValid(target) && (hackmenu==true || nethack==true)) then
		if(target.Object.Type == 1) then
			updateProfiler1(math.random())
			updateProfiler1(math.random())
			updateProfiler1(math.random())
			updateProfiler1(math.random())
		end
		if(target.Object.Type == 2) then
			updateProfiler2(math.random())
			updateProfiler2(math.random())
			updateProfiler2(math.random())
			updateProfiler2(math.random())
		end
	end
end)

hook.Add("EntityRemoved", "gctOS_CamRemoved", function(ent) 
	if(c_ent == ent) then
		c_ent = LocalPlayer()
		net.Start("gctOS_CamHack")
		net.WriteEntity(LocalPlayer():GetNWEntity("gctOS_Camera"))
		net.SendToServer()
		runAnim("CamHack_Transition", 1, false)
		timer.Simple(1, function() runAnim("NetHack", 1) end)
	end
end)

net.Receive("gctOS_PlayerHack", function() 
	local hacker = net.ReadEntity()
	local hacked = net.ReadEntity()
	local hack = net.ReadInt(8)
	runAnim("MPH"..hacked:EntIndex(), 1)
	if(hacker!=LocalPlayer()) then
		local tempHI = {}
		runAnim("HHack"..hack, 0.25, true)
		tempHI[hacked:EntIndex()] = runAnim("Hack"..hacked:EntIndex(), 0.5, true)
		hacker.LastHacked = hacked
		hacked.HackedB = true
		hacked.HackedN = hack
		hacked.HackedO = true
		runAnim("H"..hacked:EntIndex(), 0.15)
		timer.Simple(5, function()
			if(tempHI[hacked:EntIndex()] == countAnim("Hack"..hacked:EntIndex())) then
				hacked.HackedB = false
			end
		end)
	else
		hacked.HackedO = false
	end
end)