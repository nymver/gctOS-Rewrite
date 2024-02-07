-- [[ FOG IS COMING]] --








































--[[
	gctOS Rewrite

	HUD
]]

function FVTVDist(v1, v2)
	return -Vector(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z)
end

function FVTV(v1, v2, c)
	return Vector(v1.x*(1-c) + v2.x*c, v1.y*(1-c) + v2.y*c, v1.z*(1-c) + v2.z*c)
end

function DrawLine(n, pos1, pos2, color)
	--render.SetMaterial(Material("noise/"..1+math.floor(math.random() * 15)..".png"))
	--render.DrawLine(pos1, pos2, color, false)
	--render.DrawBeam(pos1, pos2, 0.4, 0.1, 1, color)
	
	local positions = {}
	for i = 0, n do
		local a = math.abs(math.sin(CurTime()*20+i*20)*255)*((color.a)/255)
		cam.IgnoreZ(true)
		if(i==1) then
			positions[1] = {start = pos1, end1 = pos1-(FVTVDist(pos1, pos2)/n)}
			render.DrawLine(positions[1].start, positions[1].end1, Color(color.r, color.g, color.b, a), false)
		end
		if(i>1) then
		   positions[i] = {start = positions[i-1].end1, end1 = positions[i-1].end1-(FVTVDist(pos1, pos2)/n)}
		   render.DrawLine(positions[i].start+VectorRand(-128, 128)/512, positions[i].end1-VectorRand(-128, 128)/512, Color(color.r, color.g, color.b, a), false)
		   cam.IgnoreZ(false)
		   if(i==n) then
		      render.DrawLine((positions[i].end1), pos2, Color(color.r, color.g, color.b, a), false)
		   end
		end
	end
	if(not nethack) then
		c_ent:DrawModel()
	end
end

function DrawGlitchLine(pos1, pos2, color, power, glitch)
    local positions = {}
    local l = 5
	for i = 1, l do
   		local vr1 = (i%2 == 0 && (rcoff > 0.5 && -1 || 1)  || (rcoff > 0.5 && 1 || -1))*c_ent:EyeAngles():Right()*30*i*power*c_ent:GetPos():Distance(target:GetPos())/250 * (0.25 + linerand)
        if(i==1) then
        	positions[i] = {start = pos1, end1 = pos1-(FVTVDist(pos1, pos2)/l+vr1)}
        	DrawLine(100/l, positions[i].start, positions[i].end1, color, 5)
        end
        if(i>1 && i<l) then
        	positions[i] = {start = positions[i-1].end1, end1 = positions[i-1].end1-(FVTVDist(pos1, pos2)/l+vr1)}
        	DrawLine(100/l, positions[i].start, positions[i].end1, color, 5)
        end
        if(i==l) then
        	positions[i] = {start = positions[i-1].end1, end1 = pos2}
        	DrawLine(100/l, positions[i].start, pos2, color, 5)
        end
    end
end

function DrawGlitchLine_LQ(pos1, pos2, color, power, glitch)
    local positions = {}
    local l = 6
	for i = 1, l do
   		local vr1 = (VectorRand() * Vector(1, 0, 0))*glitch*power*(i - (l/2) < 0 && -1 || 1)
        if(i==1) then
        	positions[i] = {start = pos1, end1 = pos1-(FVTVDist(pos1, pos2)/l+vr1)}
        	render.DrawLine(positions[i].start, positions[i].end1, color)
        end
        if(i>1 && i<l) then
        	positions[i] = {start = positions[i-1].end1, end1 = positions[i-1].end1-(FVTVDist(pos1, pos2)/l+vr1)}
        	render.DrawLine(positions[i].start, positions[i].end1, color)
        end
        if(i==l) then
        	positions[i] = {start = positions[i-1].end1, end1 = pos2}
        	render.DrawLine(positions[i].start, pos2, color)
        end
    end
end

function DrawRhombProgress(ent, x, y)
	if(ent != LocalPlayer()) then
		draw.RhombProgress(x, y, getAnim("RP"..ent:EntIndex()))	
		surface.SetMaterial(Material("blank.png"))
		surface.SetDrawColor(0, 0, 0)
		surface.DrawTexturedRectRotated(x, y, 32, 32, 45)

		surface.SetMaterial(Material("mini/hacks/"..ent.RPIcon))
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(x-12, y-12, 24, 24)
	end
end

local yoff = 0
local mul = 0
hbinds = {
	"Hack1",
	"Hack2",
	"Hack3",
	"Hack4"
}


local lerpo = Vector()
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

local x, y = 0, 0
local off_acq = 0

function DrawProfiler_1(ent)
	if(ent.Object.NoProfiler != true) then
	local isblocked = ent:GetNWBool("Blocked")
	local isdisc = ent:GetNWBool("Disconnected")
	if((hackmenu == true|| nethack == true) || getAnim("ProfilerAnim") != 0) then
		if(drawblur:GetInt()==1) then
			surface.DrawBlur(x, y - 41*booltonumber(prog_info.Show), 325, 125+booltonumber(acq_info.Show)*90 + 41*booltonumber(prog_info.Show), 5*getAnim("ProfilerStart3"))
		end
		surface.SetDrawColor(0, 0, 0, 64*getAnim("ProfilerStart3"))
		surface.DrawRect(x, y - 41*booltonumber(prog_info.Show), 325, 125+booltonumber(acq_info.Show)*90 + 41*booltonumber(prog_info.Show))
		surface.DrawRect(x+5, y+5, 315, 115)
		surface.SetDrawColor(57, 57, 57, 255*getAnim("ProfilerStart3"))
		surface.DrawRect(x+5, y+5, 315, 25)
		surface.SetDrawColor(255, 255, 255, 255*getAnim("ProfilerStart3"))
		surface.DrawRect(x+10, y+10, 18, 3)
		surface.DrawRect(x+10, y+15, 18, 3)
		surface.DrawRect(x+10, y+20, 18, 3)
		surface.SetDrawColor((isblocked || isdisc) && Color(225, 37, 0, 255*getAnim("ProfilerStart3")) || (ent.Object.Color || ((Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") && ent.Blackouted != true) && Color(0, 0, 0, 255*getAnim("ProfilerStart3")) || Color(225, 37, 0, 255*getAnim("ProfilerStart3")))))
		surface.SetMaterial(Material("blank.png"))
		surface.DrawTexturedRectRotated(x+50, y+75, 48, 48, 45)
		surface.SetDrawColor(Color(255, 255, 255, 255*getAnim("ProfilerStart3"))) 
		surface.SetMaterial(Material((Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") && ent.Blackouted != true) && "hacks/"..ent.Object.Hacks[1].Icon || "hacks/hack_denied.png"))
		surface.DrawTexturedRectCenter(x+50, y+75, 30, 30)
		draw.SimpleText(Profiler1_Text.Name, "Profiler_Name", x+90, y+40, Color(255, 255, 255, 255*getAnim("ProfilerStart3")))
		draw.SimpleText(Profiler1_Text.D1, "Profiler_Description", x+90, y+55, Color(255, 255, 255, 255*getAnim("ProfilerStart3")))
		draw.SimpleText(Profiler1_Text.D2, "Profiler_Description2", x+315 - surface.GetTextSize(ent:GetNWString("PDesc2")), y+7, ((isblocked || isdisc) && Color(207, 48, 0, 255*getAnim("ProfilerStart3")) || (ent.Object.Color || ((Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") && ent.Blackouted != true) && Color(255, 255, 255, 255*getAnim("ProfilerStart3")) || Color(225, 37, 0, 255*getAnim("ProfilerStart3"))))))
	end
    --if(math.floor(getAnim("ProfilerStart3")*50) < 50) then
	    surface.SetDrawColor(255, 255, 255, 255 - 255*getAnim("ProfilerStart1"))
	    surface.SetMaterial(Material("profiler_noise/"..math.Clamp((math.Round(getAnim("ProfilerStart1")*50)), 0, 50)..".png"))
	    surface.DrawTexturedRectRotated(x+(325/2), y+(125/2), 325, 125, 180*booltonumber(!hackmenu && !nethack))
	--end
	end
end

function DrawProfiler_2(ent)
	local prof = gctOS.PFuncs.GetType2(ent)
	if(hackmenu || nethack == true) then
		if(drawblur:GetInt()==1) then
			surface.DrawBlur(x, y - 41*booltonumber(prog_info.Show), 325, 125+booltonumber(acq_info.Show)*90 + 41*booltonumber(prog_info.Show), 5)
		end
		surface.SetDrawColor(0, 0, 0, 64*getAnim("ProfilerStart3"))
		surface.DrawRect(x, y - 41*booltonumber(prog_info.Show), 325, 125+booltonumber(acq_info.Show)*90 + 41*booltonumber(prog_info.Show))
		surface.DrawRect(x+5, y+5, 315, 115)
		surface.SetDrawColor(57, 57, 57, 255*getAnim("ProfilerStart3"))
		surface.DrawRect(x+5, y+5, 315, 25)
		surface.SetDrawColor(255, 255, 255, 255*getAnim("ProfilerStart3"))
		surface.DrawRect(x+10, y+10, 18, 3)
		surface.DrawRect(x+10, y+15, 18, 3)
		surface.DrawRect(x+10, y+20, 18, 3)
		if(getAnim("ProfilerStart3")==1) then
			surface.SetDrawColor((Botnet==0 || LocalPlayer():GetNWBool("gctOS_Access") == false) && (Color(200, 50, 31, 150*getAnim("ProfilerStart3"))) || (ent:GetNWBool("CustomProfiler") == false && Color(prof.Color.r, prof.Color.g, prof.Color.b, 150*getAnim("ProfilerStart3")) || Color(247, 104, 2, 150*getAnim("ProfilerStart3"))))
			surface.DrawRect(x+5, y+30, 315, 55)
			draw.NoTexture()
			surface.SetDrawColor(0, 0, 0, 255*getAnim("ProfilerStart3"))
			if(ent.Object.Car != true) then
				render.SetStencilEnable(true)
				render.ClearStencil()
				render.SetStencilWriteMask(1)
				render.SetStencilTestMask(1)
				render.SetStencilReferenceValue(1)
				render.SetStencilCompareFunction(STENCIL_ALWAYS)
				render.SetStencilPassOperation(STENCIL_REPLACE)
				render.SetStencilFailOperation(STENCIL_KEEP)
				render.SetStencilZFailOperation(STENCIL_KEEP)
				cam.Start2D()	
					if(prof.Icon != "empty" && !Material(prof.Icon):IsError()) then		
						surface.SetDrawColor(prof.IColor)
					else
						surface.SetDrawColor(Color(0, 0, 0, 1))	
					end
						draw.Circle(x+35, y+57, 24, 360)
				cam.End2D()
				render.SetStencilCompareFunction(STENCIL_EQUAL)
				render.SetStencilPassOperation(STENCIL_KEEP)
				render.SetStencilFailOperation(STENCIL_KEEP)
				render.SetStencilZFailOperation(STENCIL_KEEP)
				cam.Start2D()
					surface.SetDrawColor(255, 255, 255, 255*getAnim("ProfilerStart3"))
					surface.SetMaterial((ent:GetNWBool("CustomProfiler") == false && Botnet > 0 && LocalPlayer():GetNWBool("gctOS_Access")) && ((prof.Icon == "empty" || Material(prof.Icon):IsError()) && Material("loading.png") || Material(prof.Icon)) || Material("citizens/glitch.png"))
					if(ent:GetNWBool("CustomProfiler") || Botnet == 0 || LocalPlayer():GetNWBool("gctOS_Access") == false || (target==LocalPlayer() && game.SinglePlayer())) then
						surface.DrawTexturedRectRotated(x+35, y+57, 50, 50, 0)
						surface.DrawTexturedRectRotated(x+35+math.random(-10, 10), y+57+math.random(-5, 5), 50, 50, 0)
						surface.DrawTexturedRectRotated(x+35+math.random(-10, 10), y+57+math.random(-5, 5), 50, 50, 0)
					else
						if(prof.Icon != "empty" && !Material(prof.Icon):IsError()) then
							surface.DrawTexturedRectCenter(x+35, y+57, 50, 50, 0)
						else
							surface.DrawTexturedRectRotated(x+35, y+57, 25, 25, CurTime()*200)
						end
					end
				cam.End2D()
				render.SetStencilEnable(false)
			else
				surface.SetDrawColor(255, 255, 255, 255*getAnim("ProfilerStart3"))
				surface.SetMaterial((ent:GetNWBool("CustomProfiler") == false && Botnet > 0 && LocalPlayer():GetNWBool("gctOS_Access")) && ((prof.Icon == "empty" || Material(prof.Icon):IsError()) && Material("loading.png") || Material(prof.Icon)) || Material("citizens/glitch.png"))
				if(prof.Icon != "empty" && !Material(prof.Icon):IsError()) then
					surface.DrawTexturedRectCenter(x+35, y+57, 50, 50, 0)
				else
					surface.DrawTexturedRectRotated(x+35, y+57, 25, 25, CurTime()*200)
				end
			end
		    if(prof.Emotion ~= "" && ent:GetNWBool("CustomProfiler") == false && Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access")) then
		    	surface.SetMaterial(Material("citizens/emotions/"..prof.Emotion..".png"))
		    	surface.DrawTexturedRectCenter(x+35+24, y+57-14, 20, 20, 0)
			end
		end
			local textcolor = ((prof.Color.r * 0.299 + prof.Color.g*0.587 + prof.Color.b*0.114)/255)>0.53 && 0 || 245
			if(getAnim("ProfilerStart3") > 0.77) then
		    draw.SimpleText(Profiler2_Text.Name, "Profiler2_Name", x+72, y+33, Color(textcolor, textcolor, textcolor, 255*getAnim("ProfilerStart3")))
		    draw.SimpleText(Profiler2_Text.D1, "Profiler_Description", x+72, y+48-(3*booltonumber(string.len(Profiler2_Text.Name)<=0)), Color(textcolor, textcolor, textcolor, 255*getAnim("ProfilerStart3")))
		    draw.SimpleText(Profiler2_Text.D2, "Profiler_Description2", x+315 - surface.GetTextSize(prof.Description2), y+7, Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") && Color(prof.Color.r, prof.Color.g, prof.Color.b, 255*getAnim("ProfilerStart3")) || Color(200, 50, 31, 255*getAnim("ProfilerStart3")))
		    if(Profiler2_Text.D2 ~= "") then
		    	surface.SetMaterial(Material(prof.MIcon && prof.MIcon || "minimini/"..ent.Object.Hacks[1].Icon))
		    	surface.SetDrawColor(Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") && Color(prof.Color.r, prof.Color.g, prof.Color.b, 255*getAnim("ProfilerStart3")) || Color(200, 50, 31, 255*getAnim("ProfilerStart3")))
		    	surface.DrawTexturedRect(x+315 - surface.GetTextSize(prof.Description2)-22, y+7, 20, 20)
		    end
			
		    draw.SimpleText(Profiler2_Text.I1, "Profiler_Name", x+35-24, y+85)
		    draw.SimpleText(Profiler2_Text.I2, "Profiler_Name", x+35-24, y+100)
			end
	end
   -- if(math.floor(getAnim("ProfilerStart3")*50) < 50) then
	    surface.SetDrawColor(255, 255, 255, 255*(1-getAnim("ProfilerStart1")))
	    surface.SetMaterial(Material("profiler_noise/"..math.Clamp((math.Round(getAnim("ProfilerStart1")*50)), 0, 50)..".png"))
	    surface.DrawTexturedRectRotated(x+(325/2), y+(135/2), 325, 125, 180*booltonumber(!hackmenu && !nethack))
	--end
end

function DrawAcquired()
	if(acq_info.Start == true) then
		if(not hackmenu && not prog_info.Show) then
			if(drawblur:GetInt()==1) then
				surface.DrawBlur(x, y+off_acq, 325, 100, 5)
			end
			surface.SetDrawColor(0, 0, 0, 64)
			surface.DrawRect(x, y+off_acq, 325, 100)
		end
		surface.SetDrawColor(0, 0, 0, 64)
		surface.DrawRect(x+5, y+5+off_acq, 315, 90)
		surface.SetDrawColor(acq_info.Color)
		surface.DrawRect(x+5, y+5+off_acq, 315, 25)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(x+10, y+10+off_acq, 18, 3)
		surface.DrawRect(x+10, y+15+off_acq, 18, 3)
		surface.DrawRect(x+10, y+20+off_acq, 18, 3)
		draw.SimpleText(acq_info.Info1, "Profiler_Name", x+32, y+off_acq+7)
		if(type(acq_info.Icon) == "table") then
			draw.NoTexture()
			surface.SetDrawColor(0, 0, 0)
			render.SetStencilEnable(true)
			render.ClearStencil()
			render.SetStencilWriteMask(1)
			render.SetStencilTestMask(1)
			render.SetStencilReferenceValue(1)
			render.SetStencilCompareFunction(STENCIL_ALWAYS)
			render.SetStencilPassOperation(STENCIL_REPLACE)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			cam.Start2D()			
				surface.SetDrawColor(acq_info.Icon[2])
				draw.Circle(x+50, y+off_acq+63, 24, 360)
			cam.End2D()
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			render.SetStencilPassOperation(STENCIL_KEEP)
			render.SetStencilFailOperation(STENCIL_KEEP)
			render.SetStencilZFailOperation(STENCIL_KEEP)
			cam.Start2D()
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material(acq_info.Icon[1]))
				surface.DrawTexturedRectCenter(x+50, y+off_acq+63, 50, 50, 0)
			cam.End2D()
			render.SetStencilEnable(false)
		else
			surface.SetDrawColor(acq_info.Color)
			surface.SetMaterial(Material("blank.png"))
			surface.DrawTexturedRectRotated(x+50, y+off_acq+63, 40, 40, 45)
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Material(acq_info.Icon))
			surface.DrawTexturedRectCenter(x+50, y+off_acq+63, 30, 30)
		end
		draw.SimpleText(acq_info.Info2, "Profiler_Name", x+90, y+off_acq+40)
		draw.SimpleText(acq_info.Info3, "Profiler_Description", x+90, y+off_acq+55)
	end
   if(math.floor(getAnim("AcquiredGlitch")*50) < 50) then
	    surface.SetDrawColor(255, 255, 255, 255*(1-getAnim("AcquiredGlitch")))
	    surface.SetMaterial(Material("profiler_noise/"..math.Clamp((math.Round(getAnim("AcquiredGlitch")*50)), 0, 50)..".png"))
	    surface.DrawTexturedRectRotated(x+(325/2), y+off_acq+(100/2), 325, 100, 180*booltonumber(not acq_info.Start))
	end
end

function DrawProgress()
	local yoffp = booltonumber(not (hackmenu || nethack))*(122/2)
	if(prog_info.Show == true) then
		if(not hackmenu && not nethack) then
			if(drawblur:GetInt()==1) then
				surface.DrawBlur(x, y-41+yoffp, 325, 51+booltonumber(acq_info.Show)*90, 5)
			end
			surface.SetDrawColor(0, 0, 0, 64)
			surface.DrawRect(x, y-41+yoffp, 325, 51+booltonumber(acq_info.Show)*90, 15)
		end 
		surface.SetDrawColor(0, 0, 0, 64)
		surface.SetDrawColor(57, 57, 57)
		surface.DrawRect(x+5, y-36+yoffp, 315, 25)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(x+5, y-11+yoffp, 315, 16)
		surface.SetDrawColor(0, 180 + 20*math.abs(math.sin(CurTime() * 5)), 255)
		surface.DrawRect(x+5, y-11+yoffp, 315*prog_info.Progress, 16)
		draw.SimpleText(prog_info.Info1, "Profiler_Description", x+10, y-34+yoffp)
		draw.SimpleText(math.ceil((prog_info.Progress*100)).."%", "Profiler_Description", (x+315) - surface.GetTextSize(math.ceil((prog_info.Progress*100)).."%"), y-34+yoffp)
	end
	if(math.floor(getAnim("ProgGlitch")*50) < 50) then
		surface.SetDrawColor(255, 255, 255, 255*(1-getAnim("ProgGlitch")))
		surface.SetMaterial(Material("profiler_noise/"..math.Clamp((math.Round(getAnim("ProgGlitch")*50)), 0, 50)..".png"))
		surface.DrawTexturedRectRotated(x + 325/2, y-40 + 41/2+yoffp, 325, 41, 180*booltonumber(not acq_info.Start))
	end
end


hook.Add("HUDPaint", "gctOS_Botnet_HackMenu_CameraHUD_Profiler", function()
	-- Camera HUD
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		if(cht==true) then
			render.RenderView(transition_camview)
		end
		if(IsValid(LocalPlayer():GetNWEntity("gctOS_Camera")) && (getAnim("CamHack_Transition") == 0 || getAnim("CamHack_Transition") == 1)) then
			surface.SetDrawColor(255, 255, 255, 100)
			surface.SetMaterial(Material("cam_overlay.png"))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("nethack/"..math.random(1, 10).."_2.png"))
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(0, ScrH()-42, ScrW(), 42)
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Material("keys/alt.png"))
			surface.DrawTexturedRectCenter(ScrW()-142, ScrH()-21, 16, 16)
			draw.SimpleText("DISCONNECT", "CameraFont", ScrW()-128, ScrH()-33, Color(255, 255, 255))
			if(game.SinglePlayer()) then
				surface.SetMaterial(Material("keys/mouse_middle.png"))
				surface.DrawTexturedRectCenter(ScrW()-142-100, ScrH()-21, 16, 16)
				draw.SimpleText("ZOOM", "CameraFont", ScrW()-128-100, ScrH()-33, Color(255, 255, 255))
			else
				surface.SetDrawColor(128, 128, 128)
				surface.SetMaterial(Material("keys/mouse_middle.png"))
				surface.DrawTexturedRectCenter(ScrW()-142-100, ScrH()-21, 16, 16)
				draw.SimpleText("ZOOM", "CameraFont", ScrW()-128-100, ScrH()-33, Color(128, 128, 128))	
			end
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(Material("keys/mouse_left.png"))
			surface.DrawTexturedRectCenter(ScrW()-142-200, ScrH()-21, 16, 16)
			draw.SimpleText("SHOOT", "CameraFont", ScrW()-128-200, ScrH()-33, Color(255, 255, 255))
		end
	end


	-- Profiler
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then 
		lerpo = Lerp(0.25, lerpo, LocalPlayer():EyeAngles():Forward())
		local xmotion = c_ent == LocalPlayer() && (LocalPlayer():EyeAngles():Forward().x - lerpo.x)*150 || (LocalPlayer():EyeAngles():Forward().x - lerpo.x)*25
		local ymotion = c_ent == LocalPlayer() && (LocalPlayer():EyeAngles():Forward().z - lerpo.z)*150 || (LocalPlayer():EyeAngles():Forward().z - lerpo.z)*25
		x = xmotion + ScrW()/2 + 120
		y = ymotion + ScrH() - (c_ent == LocalPlayer() && 360 || 480)- off_acq/2
		if(IsValid(target) && target.Object ~= nil) then
			if(target.Object.Type == 1) then
				DrawProfiler_1(target)
			elseif(target.Object.Type == 2) then
				DrawProfiler_2(target)
			end
		end
		if(prog_info.Show == true) then
			DrawProgress("PROGRESS", true)
		end
		if(acq_info.Show == true) then
			if(istable(target.Object) && (hackmenu || nethack)) then
				if(target.Object.Type == 1) then
					off_acq = 115
				elseif(target.Object.Type == 2) then
					off_acq = 115
				end
			else
				off_acq = 122/2
			end
			DrawAcquired()
		else
			off_acq = 0
		end
	end

	-- Botnet & Hackmenu
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		if(LocalPlayer():Alive()) then
			if(getAnim("CamHack_Transition") == 0 || getAnim("CamHack_Transition") == 1) then
				mul = (hackmenu && getAnim("HackMenu") || 1 - getAnim("HackMenu"))
				yoff = Lerp(0.25, yoff, booltonumber(IsValid(LocalPlayer():GetNWEntity("gctOS_Camera")))*50)
				if(drawblur:GetInt()==1) then
					surface.DrawBlurCircle(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 32, 5)
				end
				if(not hackmenu) then
					if(drawblur:GetInt()==1) then
						surface.DrawBlurCircle(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-48-yoff+48*mul-hud_safezone:GetInt(), 40, 5)
					end
				else
					surface.SetDrawColor(0, 0, 0)
					render.SetStencilEnable(true)
					render.ClearStencil()
					render.SetStencilWriteMask(1)
					render.SetStencilTestMask(1)
					render.SetStencilReferenceValue(1)
					render.SetStencilCompareFunction(STENCIL_ALWAYS)
					render.SetStencilPassOperation(STENCIL_REPLACE)
					render.SetStencilFailOperation(STENCIL_KEEP)
					render.SetStencilZFailOperation(STENCIL_KEEP)
					cam.Start2D()			
						surface.SetDrawColor(Color(0, 0, 0, 1))
						draw.NoTexture()
						draw.RoundedBox2(ScrW()-60-46+92/2-hud_safezone:GetInt(), ScrH()-48-36-20-(169*getAnim("HackMenu"))-yoff+22-hud_safezone:GetInt(), 28, 5, 16)
						draw.RoundedBox2(ScrW()-60-46+92/2-hud_safezone:GetInt(), ScrH()-48-36-20-169-yoff*getAnim("HackMenu")+22+16+42+42+14-4-16+32-hud_safezone:GetInt(), 0, 32*getAnim("HackMenu"), 46)
						surface.DrawRect(ScrW()-60-46-hud_safezone:GetInt(), ScrH()-48-36-20-(169*getAnim("HackMenu"))-yoff+16-hud_safezone:GetInt(), 92, 92*getAnim("HackMenu"))
					cam.End2D()
					render.SetStencilCompareFunction(STENCIL_EQUAL)
					render.SetStencilPassOperation(STENCIL_KEEP)
					render.SetStencilFailOperation(STENCIL_KEEP)
					render.SetStencilZFailOperation(STENCIL_KEEP)
					cam.Start2D()
						if(drawblur:GetInt()==1) then
							surface.DrawBlurTest(ScrW()/2-hud_safezone:GetInt(), ScrH()/2-hud_safezone:GetInt(), 92, 218, 5)
						end
					cam.End2D()
					render.SetStencilEnable(false)
				end
				draw.NoTexture()
				surface.SetDrawColor(0, 0, 0, 64)
				draw.Circle(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 32, 360)
				draw.NoTexture()
				surface.SetDrawColor(Color(78, 78, 78)) 
				draw.Circle(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 23, 360)
				surface.SetDrawColor(Color(200, 200, 200)) 
				draw.CircleProgress(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 23, 360, ToRegenerate/20, 0)
				surface.SetDrawColor((not LocalPlayer():GetNWBool("Blocked") && LocalPlayer():GetNWBool("gctOS_Access")) && bcolor1 || Color(133, 50, 31)) 
				draw.CircleProgress(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 23, 360, Botnet/20, 0)
				if(getAnim("BotnetDrain") > 0) then
					surface.SetDrawColor(251, 121, 45)
					draw.CircleProgress(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 23, 360, ToDrain/20 - (ToDrain/20)*getAnim("BotnetDrain"), 18*((Botnet+ToDrain) - ToDrain))
				end
				surface.SetDrawColor(Color(90+90*math.abs(math.cos(CurTime()*3)), 90+90*math.abs(math.cos(CurTime()*3)), 90+90*math.abs(math.cos(CurTime()*3)))) 
				draw.CircleProgress(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 23, 360, math.floor(nethack_botnet)/20, Botnet*18 - math.floor(nethack_botnet)*18)
				surface.SetDrawColor(bcolor2)
				draw.Circle(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 15, 360)
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material('battery.png'))
				surface.DrawTexturedRectCenter(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 48, 48)
				surface.SetDrawColor(bcolor3)
				surface.SetMaterial(Material("botnet_symbol.png"))
				surface.DrawTexturedRectCenter(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-yoff-hud_safezone:GetInt(), 48, 48)
				draw.NoTexture()
					surface.SetDrawColor(0, 0, 0, 64*(hackmenu && (1 - getAnim("HackMenu")) || getAnim("HackMenu")))
					surface.SetMaterial(Material("nfcircle2.png"))
					surface.DrawTexturedRectCenter(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-48-yoff+48*mul-hud_safezone:GetInt(), 80, 80)
					local r = 0
					if(target.Object) then
						if((not gctOS.CheckForHacks(target) || target:GetNWBool("Disconnected") || target:GetNWBool("Blocked")) && (target.Object.Hacks[1] ~= nil && not table.IsEmpty(target.Object.Hacks[1]))) then
							r = 128
						else
							r = 0
						end
					else
						r = 0
					end
					surface.SetDrawColor(r, 0, 0, (88+88*(booltonumber(target.Object)))*(1 - mul))
					surface.SetMaterial(Material("nfcircle.png"))
					surface.DrawTexturedRectCenter(ScrW()-60-hud_safezone:GetInt(), ScrH()-48-48-yoff+48*mul-hud_safezone:GetInt(), 55, 55)
					surface.SetDrawColor(255, 255, 255, 255*(1 - mul))
					if(target.Object && target.Object.Type ~= 3) then
						surface.SetMaterial(Material(GetKeyPic(gctOS.Bindings["Hackmenu"])))
						surface.DrawTexturedRectCenter(ScrW()-59-hud_safezone:GetInt(), ScrH()-48-48-24-yoff+48*mul-hud_safezone:GetInt() - 4, 16, 16)
						surface.SetDrawColor(255, 255, 255, 255*(1 - mul)*getAnim("NT"))
						if(target.Object.Hacks[1] ~= nil && not table.IsEmpty(target.Object.Hacks[1])) then
							surface.SetMaterial(Material("mini/hacks/"..target.Object.Hacks[1].Icon))
							surface.DrawTexturedRectCenter(ScrW()-59-hud_safezone:GetInt(), ScrH()-48-48-yoff+48*mul-hud_safezone:GetInt(), 12*(1-getAnim("NT"))+24*getAnim("NT"), 12*(1-getAnim("NT"))+24*getAnim("NT"))	
						else
							surface.SetDrawColor(176, 176, 176, 255*(getAnim("NT")))	
							surface.SetMaterial(Material("mini/n.png"))
							surface.DrawTexturedRectCenter(ScrW()-59-hud_safezone:GetInt(), ScrH()-48-49-yoff+48*mul-hud_safezone:GetInt(), 12*getAnim("NT"), 12*getAnim("NT"))	
						end
					else
						surface.SetDrawColor(176, 176, 176, 255*(1 - mul))	
						surface.SetMaterial(Material("mini/n.png"))
						surface.DrawTexturedRectCenter(ScrW()-59-hud_safezone:GetInt(), ScrH()-48-49-yoff+48*mul-hud_safezone:GetInt(), 6*(1-getAnim("NT"))+12*getAnim("NT"), 6*(1-getAnim("NT"))+12*getAnim("NT"))	
					end
				if(not hackmenu || target.Object == nil || target.Object.Type == 3) then	
				else

					surface.SetDrawColor(hm_opencolor + ((255 * math.abs(math.cos(CurTime()*2))) * booltonumber((Botnet <= 0 && drain_botnet:GetInt()==1) || target.Blackouted == true)) * booltonumber(not target:GetNWBool("Blocked")) * booltonumber(not target:GetNWBool("Disconnected")), hm_opencolor+180*((math.abs(math.cos(CurTime()*2))*booltonumber(gctOS.CheckForHacks(target)))*booltonumber((Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") || drain_botnet:GetInt()==0) && target.Blackouted!=true)) * booltonumber(not target:GetNWBool("Blocked")) * booltonumber(not target:GetNWBool("Disconnected")), hm_opencolor+((255*math.abs(math.cos(CurTime()*2))*booltonumber(gctOS.CheckForHacks(target))) * booltonumber((Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") || drain_botnet:GetInt()==0) && target.Blackouted!=true)) * booltonumber(not target:GetNWBool("Blocked")) * booltonumber(not target:GetNWBool("Disconnected")), 64+(32 * booltonumber(hm_opencolor > 0)))
					surface.SetMaterial(Material("hackmenu/1.png"))
					surface.DrawTexturedRect(ScrW()-60-46-hud_safezone:GetInt(), ScrH()-48-40-yoff-hud_safezone:GetInt(), 92, 29)
					surface.SetMaterial(Material("hackmenu/2.png"))
					surface.DrawTexturedRect(ScrW()-60-46-hud_safezone:GetInt(), ScrH()-48-36-20-(169*getAnim("HackMenu"))-yoff-hud_safezone:GetInt(), 92, 20)
					surface.DrawRect(ScrW()-60-46-hud_safezone:GetInt(), ScrH()-48-36-(169*getAnim("HackMenu"))-yoff-hud_safezone:GetInt(), 92, 169*getAnim("HackMenu")+(1*booltonumber(not checkAnim("HackMenu")))-4) -- Nice fix :/	
					for i = 1, 4 do
						local h = 5-i
						if(not gctOS.GetHackUsed(target, h) && not target:GetNWBool("Blocked") && not target:GetNWBool("Disconnected")) then
							surface.SetDrawColor(255-127*unavailable[h], 255-127*unavailable[h], 255-127*unavailable[h], 255)
						else
							surface.SetDrawColor(255, 255, 255, 255)
						end
						surface.SetMaterial(Material(GetKeyPic(gctOS.Bindings["Hack"..h])))
						surface.DrawTexturedRectCenter(ScrW()-30-54-hud_safezone:GetInt(), ScrH()-32-36-220+99+((2 - h)*44*getAnim("HackMenu"))+33-yoff-hud_safezone:GetInt(), 16, 16)
						if(target.Object.Hacks[h] ~= nil && not table.IsEmpty(target.Object.Hacks[h]) && target:GetNWBool("Available"..h)) then
							draw.NoTexture()
							if(gctOS.GetHackUsed(target, h) || target:GetNWBool("Blocked") || target:GetNWBool("Disconnected")) then
								surface.SetDrawColor(144+56*unavailable[h], 0, 0, 200+50*unavailable[h])
							else
								surface.SetDrawColor(0, 0, 0, 200-56*unavailable[h])
							end
							draw.Circle(ScrW()-30-15-hud_safezone:GetInt(), ScrH()-32-36-220+99+((2 - h)*44*getAnim("HackMenu"))+33-yoff-hud_safezone:GetInt(), 20, 360)
							if(not gctOS.GetHackUsed(target, h) && not target:GetNWBool("Blocked") && not target:GetNWBool("Disconnected") && not (Botnet <= 0)) then
								surface.SetDrawColor(255-105*unavailable[h], 255-105*unavailable[h], 255-105*unavailable[h], 255 - 105*unavailable[h])
							else
								surface.SetDrawColor(255, 255, 255, 128)
							end
							surface.SetMaterial(Material("mini/hacks/"..target.Object.Hacks[h].Icon))
							surface.DrawTexturedRectCenter(ScrW()-30-15-hud_safezone:GetInt(), ScrH()-32-36-220+99+((2 - h)*44*getAnim("HackMenu"))+33-yoff-hud_safezone:GetInt(), 24, 24)
							draw.NoTexture()	
							surface.SetDrawColor(255, 255, 255, 255*getAnim("HHack"..h))	
							draw.Circle(ScrW()-30-15-hud_safezone:GetInt(), ScrH()-32-36-220+99+((2 - h)*44*getAnim("HackMenu"))+33-yoff-hud_safezone:GetInt(), 20, 360)		
						else
							draw.NoTexture()
							surface.SetDrawColor(0, 0, 0, 64)
							draw.Circle(ScrW()-30-15-hud_safezone:GetInt(), ScrH()-32-36-220+99+((2 - h)*44*getAnim("HackMenu"))+33-yoff-hud_safezone:GetInt(), 20, 360)
							surface.SetDrawColor(176, 176, 176, 255)
							surface.SetMaterial(Material("mini/n.png"))
							surface.DrawTexturedRectCenter(ScrW()-30-15-hud_safezone:GetInt(), ScrH()-32-36-220+99+((2 - h)*44*getAnim("HackMenu"))+33-yoff-hud_safezone:GetInt(), 12, 12)	
							surface.SetDrawColor(255, 255, 255, 255*getAnim("HHack"..h))
							draw.NoTexture()	
							draw.Circle(ScrW()-30-15-hud_safezone:GetInt(), ScrH()-32-36-220+99+((2 - h)*44*getAnim("HackMenu"))+33-yoff-hud_safezone:GetInt(), 20, 360)	
						end
					end
				end
			end
		end
	end
end)

-- Looks good but bugged :(
--[[ 
local LerpAngle = Angle(-c_ent:EyeAngles().roll, c_ent:EyeAngles().yaw-90, -c_ent:EyeAngles().pitch+90)
local IAngle = Angle(-c_ent:EyeAngles().roll, c_ent:EyeAngles().yaw-90, -c_ent:EyeAngles().pitch+90)
local Forw = LocalPlayer():EyeAngles():Forward()*100
hook.Add("PostDrawOpaqueRenderables", "gctOS_3DProfiler", function()
	IAngle = Angle(-c_ent:EyeAngles().roll, c_ent:EyeAngles().yaw-90, -c_ent:EyeAngles().pitch+90)
	LerpAngle = Lerp(0.1, LerpAngle, Angle(-c_ent:EyeAngles().roll, c_ent:EyeAngles().yaw-90, -c_ent:EyeAngles().pitch+90))
	Forw = Lerp(0.1, Forw, LocalPlayer():EyeAngles():Forward()*100)
	render.DrawBlur(LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*5+LocalPlayer():EyeAngles():Right()*2.3-LocalPlayer():EyeAngles():Up()*0.5, -Forw, 2.75, 1.05, 10, 0, 0)
	cam.Start3D2D(LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*5+LocalPlayer():EyeAngles():Right()*2, Angle(IAngle.pitch, LerpAngle.yaw, IAngle.roll), 0.0082)
	cam.IgnoreZ(true)
	--surface.DrawRect(0, 0, 100, 100)
	if(IsValid(target) && target.Object) then
		DrawProfiler_1(target)
	end
	cam.IgnoreZ(false)
	cam.End3D2D()
end)
]]

local phacks = {}
local color = Color(255, 255, 255, 255*getAnim("Lines"))
local color_lerp = Vector(255, 255, 255, 255*getAnim("Lines"))
function Render_Lines()
	if(target.Object) then
		local position = (c_ent == LocalPlayer()) && LocalPlayer():GetBonePosition(0) + Vector(5, 0, 0) || c_ent:GetPos() - Vector(0, 0, 5)
		color = hackmenu && (((gctOS.CheckForHacks(target) || not checkAnim("Lines")) && target.Object.Type == 1) && (((Botnet > 0 && LocalPlayer():GetNWBool("gctOS_Access") || drain_botnet:GetInt()==0) && target.Blackouted != true && not target:GetNWBool("Blocked") && not target:GetNWBool("Disconnected")) && (gctOS.CheckForHacks(target) && (target:GetClass()=="ctos_router1" && Color(247, 104, 2) || Color(6, 171, 240, 255*(1-getAnim("Lines")))) || Color(255, 255, 255, 255*(1-getAnim("Lines")))) || Color(255, 0, 0, 255*(1-getAnim("Lines")))) || (Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") && Color(255, 255, 255, 255*(1-getAnim("Lines"))) || Color(255, 0, 0, 255*(1-getAnim("Lines"))))) || Color(255, 255, 255, 255*(1-getAnim("Lines")))
		color_lerp = Lerp(0.25, color_lerp, Vector(color.r, color.g, color.b))
		if(IsValid(target) && target.Object ~= nil && target.Object.Type ~= 3) then
			--local p1 = c_ent:GetBonePosition(0)+Vector(5, 0, 0)
			--local p2 = tpos
			--line_pos2 = Vector(((p1.x * getAnim("Lines")) + (p2.x * (1 - getAnim("Lines")))), ((p1.y * getAnim("Lines")) + (p2.y * (1 - getAnim("Lines")))), ((p1.z * getAnim("Lines")) + (p2.z * (1 - getAnim("Lines")))))
			if(checkAnim("Lines")) then
				DrawLine(100, position, tpos, Color(color_lerp.x, color_lerp.y, color_lerp.z, 255*(1-getAnim("Lines"))))
			else
				DrawGlitchLine(position, tpos, Color(color_lerp.x, color_lerp.y, color_lerp.z, 255*(1-getAnim("Lines"))), getAnim("Lines"), glitch)
			end
		end
	end
	for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 1000)) do
		if(v:IsPlayer() && v != LocalPlayer() && IsValid(v) && IsValid(v.LastHacked)) then
			DrawGlitchLine_LQ(v:GetBonePosition(0), v.LastHacked:GetBonePosition(0), Color(180, 0, 255, 255 - 255*getAnim("MPH"..v.LastHacked:EntIndex())), 5 - 5*getAnim("MPH"..v.LastHacked:EntIndex()), 5)
		end
	end
end

hook.Add("PostDrawTranslucentRenderables", "gctOS_Lines", function()
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		if(not nethack) then Render_Lines() end
		if(cht == true) then
			DrawTexturize(-1000000000000, Material("nethack/texturize.png"))
			Render_Lines()
			DrawMaterialOverlay("nethack/"..math.random(1, 10).."_2.png", 0)
		end
	end
end)

hook.Add("HUDPaint", "gctOS_TargetPoint", function()
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		if(IsValid(target) && target.Object ~= nil && target.Object.Type ~= 3) then
			if(not hackmenu) then
			    surface.SetMaterial(Material('pointpm.png'))
			    surface.SetDrawColor(0, 0, 0, 180)
			    surface.DrawTexturedRectCenter((tpos || target:GetPos()):ToScreen().x, (tpos || target:GetPos()):ToScreen().y, 15, 15)
			    surface.SetDrawColor(255, 255, 255, 255)
			    surface.DrawTexturedRectCenter((tpos || target:GetPos()):ToScreen().x, (tpos || target:GetPos()):ToScreen().y, 10, 10)
			else
		        surface.SetMaterial(Material('pointp.png'))
		        surface.SetDrawColor(255, 255, 255, 255)
		        surface.DrawTexturedRectRotated((tpos || target:GetPos()):ToScreen().x, (tpos || target:GetPos()):ToScreen().y, 10+5*math.abs(math.cos(CurTime()*4)), 10+5*math.abs(math.cos(CurTime()*4)), CurTime()*150)
		        surface.SetMaterial(Material('pointpm1.png'))
		        surface.SetDrawColor(0, 0, 0, 180)
		        surface.DrawTexturedRectCenter((tpos || target:GetPos()):ToScreen().x, (tpos || target:GetPos()):ToScreen().y, 19, 19)	
		        surface.SetDrawColor(255, 255, 255, 255)
		        surface.DrawTexturedRectCenter((tpos || target:GetPos()):ToScreen().x, (tpos || target:GetPos()):ToScreen().y, 14, 14)	
			end
			if((target:GetNWBool("Blocked") || LocalPlayer():GetNWBool("gctOS_Access")==false) && hackmenu) then
				surface.SetDrawColor(0, 0, 0)
				surface.SetMaterial(Material("blank.png"))
				surface.DrawTexturedRectRotated((tpos || target:GetPos()):ToScreen().x, (tpos || target:GetPos()):ToScreen().y-36, 28*getAnim("NT"), 28*getAnim("NT"), 45)
		        surface.SetMaterial(Material("lock1.png"))
		        surface.SetDrawColor(217, 35, 0)
		        surface.DrawTexturedRectCenter((tpos || target:GetPos()):ToScreen().x, (tpos || target:GetPos()):ToScreen().y-36, 16 * getAnim("NT"), 16 * getAnim("NT"))
			end
		end
		if(IsValid(tcamera)) then
			local inu = booltonumber(IsValid(tcamera:GetNWEntity("gctOS_Hacker")))
			draw.NoTexture()
			surface.SetDrawColor(200, 200-200*inu, 200-200*inu, 32)
			draw.Circle(tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().x, tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().y-36, 18, 360)
			surface.SetDrawColor(255, 255, 255)
			draw.CircleProgress(tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().x, tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().y-36, 18, 360, camhack, 0)
			surface.SetDrawColor(0, 0, 0)
			draw.Circle(tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().x, tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().y-36, 16, 360)
			draw.SimpleText(tcamera.Object.Name..(inu>0 && " [In Use]" || ""), "CameraFont2", tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().x+44+30*inu, tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().y-48, Color(255, 255, 255), TEXT_ALIGN_CENTER)
			surface.SetDrawColor(255 - 128*inu, 255 - 128*inu, 255 - 128*inu)
			surface.SetMaterial(Material(GetKeyPic(gctOS.Bindings.CamHack)))
			surface.DrawTexturedRectCenter(tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().x, tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().y-36, 16, 16)
			if(inu==0) then
				surface.SetMaterial(Material("keys/triangle.png"))
				surface.DrawTexturedRectCenter(tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().x, tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().y-46 + 3 * math.abs(math.sin(CurTime() * 2.5)), 12, 12)
			end
			draw.NoTexture()
			surface.SetDrawColor(255, 255 - 128*inu, 255 - 128*inu, 255 * (1 - getAnim("SelectCamera")))
			draw.Circle(tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().x, tcamera:LocalToWorld(tcamera:OBBCenter()):ToScreen().y-36, 18 * (1 - getAnim("SelectCamera")), 360)
		end
		for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 2000)) do
			if(!string.StartsWith(v:GetClass(), "npc_")) then
			if(IsValid(v) && v.Object && (isfunction(v.GetBonePosition) || isfunction(v.GetPos))) then
				local pos = {x = v:LocalToWorld(v:OBBCenter()):ToScreen().x, y = v:LocalToWorld(v:OBBCenter()):ToScreen().y-(36*booltonumber(target == v))}
				if(v.HackedB == true) then
					local isb = booltonumber(v.Object.Hacks[v.HackedN].Icon=="hack_botnet.png")
					surface.SetMaterial(Material("blank.png"))
					if(v.HackedO) then
						surface.SetDrawColor(171, 6, 240, 255*getAnim("H"..v:EntIndex()))
						surface.DrawTexturedRectRotated(pos.x, pos.y, 24*getAnim("H"..v:EntIndex()), 24*getAnim("H"..v:EntIndex()), 45)
					else
						surface.SetDrawColor(6*isb, 171*isb, 240*isb, 255*getAnim("H"..v:EntIndex()))
						surface.DrawTexturedRectRotated(pos.x, pos.y, 32*getAnim("H"..v:EntIndex()), 32*getAnim("H"..v:EntIndex()), 45)
					end
					surface.SetDrawColor(255, 255, 255, 255*getAnim("H"..v:EntIndex()))
					surface.SetMaterial(Material(isb>0 && "mini/hacks/hack_botnet_b.png" || "mini/hacks/"..v.Object.Hacks[v.HackedN].Icon))
					surface.DrawTexturedRectCenter(pos.x, pos.y, 24*getAnim("H"..v:EntIndex()), 24*getAnim("H"..v:EntIndex()))
				end
				if(v.RP == true) then
					DrawRhombProgress(v, pos.x, pos.y)
				end
			end
			end
		end
	end
end)

hook.Add("PostDrawTranslucentRenderables", "gctOS_LightTarget", function()
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		if(IsValid(target) && not checkAnim("Lines")) then 
			if(target:GetClass() ~= "gmod_wire_consolescreen" && target:GetClass() ~= "gmod_wire_textscreen") then
				cam.Start3D2D(LocalPlayer():EyePos(), LocalPlayer():EyeAngles(), 1)
				render.SetStencilWriteMask(1)
				render.SetStencilTestMask(1)
				render.ClearStencil()
				render.SetStencilEnable(true)
				render.SetStencilFailOperation(STENCIL_REPLACE)
				render.SetStencilPassOperation(STENCIL_REPLACE)
				render.SetStencilZFailOperation(STENCIL_REPLACE)
				render.SetStencilCompareFunction(STENCIL_EQUAL)
				render.SetStencilReferenceValue(1)
				target:DrawModel()
				render.SetStencilCompareFunction(STENCIL_EQUAL)
				render.SetStencilReferenceValue(1)
				cam.Start2D()
				surface.SetDrawColor(255, 255, 255, 32*getAnim("Lines"))
				surface.SetMaterial(Material("blank.png"))
				surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
				render.SetStencilEnable(false)
				cam.End2D()
				cam.End3D2D()
			end
		end
	end
end)


-- Still no minimap :/	
local hp = LocalPlayer():Health() || 0
local cur = LocalPlayer():GetActiveWeapon():Clip1() || 0
local max = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) || 0
local cur2 = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetSecondaryAmmoType()) || 0
local sc = 0
hook.Add("HUDPaint", "gctOS_HUD", function()
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		if(IsValid(LocalPlayer())) then
			if(getAnim("CamHack_Transition") == 0 || getAnim("CamHack_Transition") == 1) then
				surface.SetDrawColor(255, 255, 255)
				draw.NoTexture()
				if(profiler==false) then
					draw.Circle(ScrW()/2, ScrH()/2, 2, 360)
				end
				if(profiler) then
					surface.SetMaterial(Material("circlecursor.png"))
					surface.SetDrawColor(255, 255, 255)
					surface.DrawTexturedRectCenter(ScrW()/2, ScrH()/2, 8, 8)
				end
				if(c_ent == LocalPlayer() && LocalPlayer():Alive()) then
					hp = Lerp(0.25, hp, LocalPlayer():Health()) || 0
					cur = LocalPlayer():GetActiveWeapon().Clip1 && LocalPlayer():GetActiveWeapon():Clip1() || 0
					max = LocalPlayer():GetActiveWeapon().GetPrimaryAmmoType && LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) || 0
					cur2 = LocalPlayer():GetActiveWeapon().GetSecondaryAmmoType && LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetSecondaryAmmoType()) || 0
					if(drawblur:GetInt()==1) then
						surface.DrawBlur(15+hud_safezone:GetInt(), ScrH()-35-15-20-Smartphone_Offset*360-hud_safezone:GetInt(), 280, 55+Smartphone_Offset*360, 5)
					end
					draw.NoTexture()
					surface.SetDrawColor(0, 0, 0, 64)
					surface.DrawRect(15+hud_safezone:GetInt(), ScrH()-35-15-20-Smartphone_Offset*360-hud_safezone:GetInt(), 280, 55+Smartphone_Offset*360)
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(Material(LocalPlayer():GetNWBool("Blocked") && "phonehud2.png"|| "phonehud.png"))
					surface.DrawTexturedRect(20+hud_safezone:GetInt(), ScrH()-35-10-20-Smartphone_Offset*360-hud_safezone:GetInt(), 270, 25)
					surface.SetDrawColor(0, 0, 0)
					surface.DrawRect(259+hud_safezone:GetInt(), ScrH()-35-10+8-20-Smartphone_Offset*360-hud_safezone:GetInt(), math.Clamp(22*(hp/100), 0, 22), 10)
					draw.SimpleText(os.date("%H:%M"), "Time", 259-33+hud_safezone:GetInt(), ScrH()-35-7-20-Smartphone_Offset*360-hud_safezone:GetInt(), Color(0, 0, 0), TEXT_ALIGN_RIGHT)
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(Material("blume_phone.png"))
					surface.DrawTexturedRect(20+hud_safezone:GetInt(), ScrH()-35-5-hud_safezone:GetInt(), 270, 20)
					surface.SetDrawColor(255, 255, 255, 128*(1-getAnim("SmartphoneOpen")))
					surface.DrawRect(20+hud_safezone:GetInt(), ScrH()-35-5-hud_safezone:GetInt(), 270, 20)
					if(drawblur:GetInt()==1) then
						surface.DrawBlur(15+hud_safezone:GetInt(), ScrH()-35-15-10-56-20-Smartphone_Offset*360-hud_safezone:GetInt(), 280, 56, 5)
					end
					surface.SetDrawColor(0, 0, 0, 64)
					draw.NoTexture()
					surface.DrawRect(15+hud_safezone:GetInt(), ScrH()-35-15-10-56-20-Smartphone_Offset*360-hud_safezone:GetInt(), 280, 56)
					for i = 0, 4 do
						if(i==0) then
							if(max > 0) then
								surface.SetMaterial(Material("ammo"..math.Clamp((cur > -1 && cur || max), 0, 3)..".png"))
								surface.SetDrawColor(255, 255, 255)
								surface.DrawTexturedRect(15 + 35+hud_safezone:GetInt(), ScrH()-35-15-35-12-20-Smartphone_Offset*360-hud_safezone:GetInt(), 18, 17)
								draw.SimpleText(cur, "Profiler2_Name", 15 + 30+hud_safezone:GetInt(), ScrH()-35-15-10-46-20-Smartphone_Offset*360-hud_safezone:GetInt(), Color(255, 255, 255, 255 * booltonumber(cur > -1)), TEXT_ALIGN_RIGHT)
								draw.SimpleText(max, "Profiler2_Name", 15 + 30+hud_safezone:GetInt(), ScrH()-35-15-10-30-20 - (8 * booltonumber(cur < 0))-Smartphone_Offset*360-hud_safezone:GetInt(), Color(200+(55 * booltonumber(cur < 0)), 200+(55 * booltonumber(cur < 0)), 200 + (55 * booltonumber(cur < 0))), TEXT_ALIGN_RIGHT)
							else
								surface.SetDrawColor(200, 200, 200)
								surface.SetMaterial(Material("mini/n2.png"))
								surface.DrawTexturedRectCenter(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 24, 24)
							end
						end
						if(i==1) then
							if(cur2 > 0) then
								draw.SimpleText(cur2, "Profiler2_Name", 15 + 30 + 58+hud_safezone:GetInt(), ScrH()-35-15-10-46-20-Smartphone_Offset*360-hud_safezone:GetInt(), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
								draw.SimpleText("ALT", "Profiler2_Name", 15 + 30 + 58+hud_safezone:GetInt(), ScrH()-35-15-10-30-20-Smartphone_Offset*360-hud_safezone:GetInt(), Color(200, 200, 200), TEXT_ALIGN_RIGHT)
							else
								surface.SetDrawColor(200, 200, 200)
								surface.SetMaterial(Material("mini/n2.png"))
								surface.DrawTexturedRectCenter(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 24, 24)
							end
						end
						if(i==2) then
							if(LocalPlayer():Armor() > 0) then
								draw.SimpleText(LocalPlayer():Armor(), "Profiler2_Name", 15 + 30 + 58*i+hud_safezone:GetInt(), ScrH()-35-15-10-46-20-Smartphone_Offset*360-hud_safezone:GetInt(), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
								draw.SimpleText("SUIT", "Profiler2_Name", 15 + 30 + 58*i+hud_safezone:GetInt(), ScrH()-35-15-10-30-20-Smartphone_Offset*360-hud_safezone:GetInt(), Color(200, 200, 200), TEXT_ALIGN_RIGHT)
							else
								surface.SetDrawColor(200, 200, 200)
								surface.SetMaterial(Material("mini/n2.png"))
								surface.DrawTexturedRectCenter(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 24, 24)
							end
						end
						if(i==3) then
							surface.SetDrawColor(200, 200, 200)
							surface.SetMaterial(Material("mini/n2.png"))
							surface.DrawTexturedRectCenter(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 24, 24)
						end
						sc = Lerp(0.5, sc, ((Botnet==20 && getAnim("cast_cooldown") == 1 && c_ent:GetNWBool("Blocked") == false && LocalPlayer():GetNWBool("gctOS_Access") == true) || fastapp.Util == false) && 255 || 0)
						if(i==4) then
							if(not table.IsEmpty(fastapp)) then
								surface.SetDrawColor(255 * (1 - getAnim("FastApp")), 255 * (1 - getAnim("FastApp")), 255 * (1 - getAnim("FastApp")), 72)
								draw.NoTexture()
								--draw.Circle(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 26, 360)
								--draw.RoundedBox(0, 15 + 28 + 56*i+hud_safezone:GetInt() - 28, ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt() - 28, 56, 56, Color(255 * (1 - getAnim("FastApp")), 255 * (1 - getAnim("FastApp")), 255 * (1 - getAnim("FastApp")), 128))
								--draw.RoundedBoxEx(512, 15 + 28 + 56*i+hud_safezone:GetInt() - 26, ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt() - 26, 52, 52, Color(255 * (1 - getAnim("FastApp")), 255 * (1 - getAnim("FastApp")), 255 * (1 - getAnim("FastApp")), 128), true, true, true, true)
								surface.SetDrawColor(Color(255 * (1 - getAnim("FastApp")), 255 * (1 - getAnim("FastApp")), 255 * (1 - getAnim("FastApp")), 128))
								--draw.Circle(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 26, 360)
								surface.SetDrawColor(6, 171, 240, 255 * (1 - getAnim("FastApp")))
								surface.DrawRect(16 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-56-20-Smartphone_Offset*360-hud_safezone:GetInt(), 55, 55)
								surface.SetDrawColor(255, 255, 255, 64 + 191 * (1 - getAnim("FastApp")))
								surface.SetMaterial(Material(fastapp.Icon))
								surface.DrawTexturedRectCenter(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 48, 48)
								surface.SetDrawColor(255, 0, 0)
								if(fastapp.Util) then
									surface.SetDrawColor(255, 0, 0, 32)
									draw.CircleProgress(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 16, 360, 1, 0)
									surface.SetDrawColor(255, sc, sc)
									draw.CircleProgress(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 16, 360, getAnim("cast_cooldown"), 0)
								end
								surface.SetDrawColor(0, 0, 0, 255)
								draw.NoTexture()
								draw.Circle(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 14, 360)
								surface.SetDrawColor(128+sc, 128+sc, 128+sc, 255)
								surface.SetMaterial(Material(GetKeyPic(gctOS.Bindings.FastApp)))
								surface.DrawTexturedRectCenter(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 16, 16)
							else
								surface.SetDrawColor(200, 200, 200)
								surface.SetMaterial(Material("mini/n2.png"))
								surface.DrawTexturedRectCenter(15 + 28 + 56*i+hud_safezone:GetInt(), ScrH()-35-15-10-28-20-Smartphone_Offset*360-hud_safezone:GetInt(), 24, 24)
							end
						end
					end
				end
			end
		end
	end
	if(nethack) then
		for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 2000)) do
			if(v.Object && v.Object.Type == 3 && c_ent != v) then
				local ts = v:LocalToWorld(v:OBBCenter()):ToScreen()
				surface.DrawCircle(ts.x, ts.y, 24+24*math.sin(CurTime()*4.5), 0, 125, 255, 64*math.sin(-30+CurTime()*4.5))
				surface.DrawCircle(ts.x, ts.y, 32+24*math.sin(CurTime()*4.5), 0, 125, 255, 128*math.sin(-30+CurTime()*4.5))
				surface.DrawCircle(ts.x, ts.y, 40+24*math.sin(CurTime()*4.5), 0, 125, 255, 255*math.sin(-30+CurTime()*4.5))
				--surface.DrawCircle(ts.x, ts.y, 24+24*math.sin(CurTime()*2.5), 0, 180, 255, 255*math.sin(-30+CurTime()*2.5))
				--surface.DrawCircle(ts.x, ts.y, 24+24*math.sin(CurTime()*2.5), 0, 180, 255, 255*math.sin(-30+CurTime()*2.5))
			--	surface.DrawCircle(ts.x, ts.y, 24+32*math.abs(math.cos((0 +CurTime())*2.5)), 0, 180, 255, 128 - 128*math.abs(math.cos(90+CurTime()*2.5)))
			--	surface.DrawCircle(ts.x, ts.y, 24+40*math.abs(math.cos((0+CurTime())*2.5)), 0, 180, 255, 64 - 64*math.abs(math.cos(90+CurTime()*2.5)))
			end
		end
	end
	if(getAnim("NetHack") < 1) then
		surface.SetDrawColor(16, 16, 18, (255 - 255*getAnim("NetHack")))
		surface.DrawRect(0, 0, ScrW(), ScrH())
		surface.SetDrawColor(255, 255, 255, (255 - 255*getAnim("NetHack")))
		surface.SetMaterial(Material("nethack/"..math.random(1, 10).."_2.png"))
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
end)

hook.Add("HUDPaint", "gctOS_HUD_Misc", function() 
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		if(not checkAnim("ProfilerOnOff")) then
			surface.SetDrawColor(255, 255, 255, 128 - 128*getAnim("ProfilerOnOff"))
			surface.DrawRect(0, 0, ScrW(), ScrH())
		end	
	end
end)

hook.Add("PostDrawTranslucentRenderables", "gctOS_HUD_3D_Misc", function()
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		-- Face Glitch
		if(IsValid(LocalPlayer():GetNWEntity("gctOS_Camera")) && (getAnim("CamHack_Transition") == 0 || getAnim("CamHack_Transition") == 1)) then
			cam.Start3D2D(LocalPlayer():GetAttachment(LocalPlayer():LookupAttachment("eyes")).Pos - Vector(0, 0, 3), Angle(-c_ent:EyeAngles().roll, c_ent:EyeAngles().yaw-90, -c_ent:EyeAngles().pitch+90), 0.25)
			cam.IgnoreZ(true)
			surface.SetMaterial(Material("profiler_noise/0.png"))
			for i = 1, 4 do
				surface.DrawTexturedRectRotated(0+math.random(-3, 3), -10+math.random(-3, 3), 40+math.random(-5, 5), 40+math.random(-5, 5), math.random(1, 4)*90)
				surface.SetDrawColor(255, 255, 255, 128+math.random(0, 128))
			end
			cam.IgnoreZ(false)
			cam.End3D2D()
		end
		-- Traps
		for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 1500)) do
			if(v.Trap) then
				if(hackmenu || nethack) then
					if(v.Trap.status == true) then
						render.SetMaterial(Material('blank.png'))
						render.DrawSphere(v:GetBonePosition(0), 125, 360, 360, Color(6, 171, 240, 16 * (1 - LocalPlayer():GetPos():Distance(v:GetPos())/1500)))
						cam.IgnoreZ(true)
						local emitter = ParticleEmitter(LocalPlayer():GetPos())
						local line = emitter:Add( 'particle/particle_smoke_dust.vmt', v:GetPos() + VectorRand()*(125/2))
						line:SetDieTime(1)
						line:SetStartAlpha(math.random(8, 16))
						line:SetEndAlpha(0)
						line:SetRollDelta(0)
						line:SetGravity(Vector())
						line:SetCollide(true)
						line:SetColor(0, 127, 180)
						line:SetAirResistance(100)
						line:SetStartSize(125*1)
						line:SetEndSize(0)
						line:SetVelocityScale(true)
						line:SetLighting(false)
						line:SetVelocity(-LocalPlayer():EyeAngles():Forward())
						emitter:Finish()
						cam.IgnoreZ(false)
					else
						render.SetMaterial(Material('blank.png'))
						render.DrawSphere(v:GetPos(), 125, 360, 360, Color(255, 0, 0, 16 * (1 - LocalPlayer():GetPos():Distance(v:GetPos())/500)))
						cam.IgnoreZ(true)
						local emitter = ParticleEmitter(LocalPlayer():GetPos())
						local line = emitter:Add( 'particle/particle_smoke_dust.vmt', v:GetPos() + VectorRand()*(125/2))
						line:SetDieTime(1)
						line:SetStartAlpha(math.random(8, 16))
						line:SetEndAlpha(0)
						line:SetRollDelta(0)
						line:SetGravity(Vector())
						line:SetCollide(true)
						line:SetColor(127, 0, 0)
						line:SetAirResistance(100)
						line:SetStartSize(125*1)
						line:SetEndSize(0)
						line:SetVelocityScale(true)
						line:SetLighting(false)
						line:SetVelocity(-LocalPlayer():EyeAngles():Forward())
						emitter:Finish()
						cam.IgnoreZ(false)
					end
				end
			end
		end

		for k, v in pairs(misc_renderfunctions) do
			v()
		end
	end
end)

local type1 = {available = {}, unavailable = {}, blocked = {}}
local type2 = {}
local type2_friendly = {}
local type2_enemy = {}
local type2_enemy_models = {"models/combine_super_soldier.mdl", "models/police.mdl", "models/combine_soldier.mdl", "models/combine_soldier_prisonguard.mdl"}
local type3 = {}
local routers = {}
local players = {}
local notobjects = {}
local allobjects = {}

hook.Add("Think", "gctOS_NetHack_ObjFilter", function()
	if(nethack) then
		for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 5000)) do
			if(IsValid(v) && v != c_ent && v:GetClass() != "player" && v:GetClass() != "ctos_router1") then
				if(v.Object) then
					if(!table.HasValue(allobjects, v)) then
						table.insert(allobjects, v:EntIndex(), v)
					end
				else
					if(string.StartWith(v:GetClass(), "prop_")) then
						if(!table.HasValue(notobjects, v)) then
							table.insert(notobjects, v:EntIndex(), v)
						end
					end
				end
			end
			if(v:GetClass() == "ctos_router1") then
				if(!table.HasValue(routers, v)) then
					table.insert(routers, v:EntIndex(), v)
				end
			end
		end
		for k, v in pairs(allobjects) do
			if(v.Object) then
				if(v.Object.Type == 1) then
					if(gctOS.CheckForHacks(v) && !v:GetNWBool("Blocked")) then
						table.remove(type1.unavailable, v:EntIndex())
						table.remove(type1.blocked, v:EntIndex())
						table.insert(type1.available, v:EntIndex(), v)
						if(!table.HasValue(type1.available, v)) then
							table.insert(type1.available, v:EntIndex(), v)
						end
					else
						if(v:GetNWBool("Blocked")) then
							table.remove(type1.available, v:EntIndex())
							table.remove(type1.unavailable, v:EntIndex())
							if(!table.HasValue(type1.blocked, v)) then
								table.insert(type1.blocked, v:EntIndex(), v)
							end
						else
							table.remove(type1.available, v:EntIndex())
							table.remove(type1.blocked, v:EntIndex())
							if(!table.HasValue(type1.unavailable, v)) then
								table.insert(type1.unavailable, v:EntIndex(), v)
							end
						end
					end
				end
				if(v.Object.Type == 2) then
					if(v:IsNPC()) then
						if(string.StartWith(v:GetModel(), "models/humans/group03/") || string.StartWith(v:GetModel(), "models/humans/group02/")) then
							table.remove(type2, v:EntIndex())
							table.remove(type2_enemy, v:EntIndex())
							if(!table.HasValue(type2_friendly, v)) then
								table.insert(type2_friendly, v:EntIndex(), v)
							end
						elseif(table.HasValue(type2_enemy_models, v:GetModel())) then
							table.remove(type2, v:EntIndex())
							table.remove(type2_friendly, v:EntIndex())
							if(!table.HasValue(type2_enemy, v)) then
								table.insert(type2_enemy, v:EntIndex(), v)
							end
						else
							if(!table.HasValue(type2, v)) then
								table.insert(type2, v:EntIndex(), v)
							end
						end
					else
						if(!table.HasValue(type2, v)) then
							table.insert(type2, v:EntIndex(), v)
						end
					end
				end
				if(v.Object.Type == 3) then
					if(!table.HasValue(type3, v)) then
						table.insert(type3, v:EntIndex(), v)
					end
				end
			end
		end
	end
--[[
	if(true) then 
		for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 1000)) do
			if(v:IsValid() && IsValid(v) && v.Object && v ~= c_ent && v:GetClass() ~= "player" && v:GetClass() ~= "ctos_router1") then
				if(not table.HasValue(allobjects, v)) then
					table.insert(allobjects, v:EntIndex(), v)
				end
				if(v.Object.Type == 1) then
					if(v:GetNWBool("Blocked") == true) then
						if(table.HasValue(type1.available, v)) then
							table.remove(type1.available, v:EntIndex())
						end
						if(table.HasValue(type1.unavailable, v)) then
							table.remove(type1.unavailable, v:EntIndex())
						end
						if(not table.HasValue(type1.blocked, v)) then
							table.insert(type1.blocked, v:EntIndex(), v)
						end
					else
						if(table.HasValue(type1.blocked, v)) then
							table.remove(type1.blocked, v:EntIndex())
						end
						if(gctOS.CheckForHacks(v)) then
							if(table.HasValue(type1.unavailable, v)) then
								table.remove(type1.unavailable, v:EntIndex())
							end
							if(not table.HasValue(type1.available, v)) then
								table.insert(type1.available, v:EntIndex(), v)
							end
						else
							if(table.HasValue(type1.available, v)) then
								table.remove(type1.available, v:EntIndex())
							end
							if(not table.HasValue(type1.unavailable, v)) then
								table.insert(type1.unavailable, v:EntIndex(), v)
							end
						end
					end
				elseif(v.Object.Type == 2) then
					if(v:IsNPC() &&  table.HasValue(type2_enemy_models, v:GetModel())) then
						if(not table.HasValue(type2_enemy, v)) then
							table.insert(type2_enemy, v:EntIndex(), v)
						end
					elseif(v:IsNPC() && (string.StartWith(v:GetModel(), "models/humans/group03/") || string.StartWith(v:GetModel(), "models/humans/group02/"))) then
						if(not table.HasValue(type2_friendly, v)) then
							table.insert(type2_friendly, v:EntIndex(), v)
						end	
					else
						if(not table.HasValue(type2, v)) then
							table.insert(type2, v:EntIndex(), v)
						end
					end
				elseif(v.Object.Type == 3) then
					if(not table.HasValue(type3, v)) then
						table.insert(type3, v:EntIndex(), v)
					end
				end
			end
		if(v:GetClass() == "ctos_router1") then
			if(not table.HasValue(routers, v)) then
				table.insert(routers, v:EntIndex(), v)
			end
		end
		if(v:GetClass() == "player") then
			if(not table.HasValue(players, v)) then
				table.insert(players, v:EntIndex(), v)
			end
		end
	end
end]]

	for k, v in pairs(allobjects) do
		if(not IsValid(v)) then table.remove(allobjects, k) end
	end
	for k, v in pairs(type1.available) do
		if(not IsValid(v)) then table.remove(type1.available, k) end
	end
	for k, v in pairs(type1.unavailable) do
		if(not IsValid(v)) then table.remove(type1.unavailable, k) end
	end
	for k, v in pairs(type2) do
		if(not IsValid(v)) then table.remove(type2, k) end
	end
	for k, v in pairs(type2_friendly) do
		if(not IsValid(v)) then table.remove(type2_friendly, k) end
	end
	for k, v in pairs(type2_enemy) do
		if(not IsValid(v)) then table.remove(type2_enemy, k) end
	end
	for k, v in pairs(type3) do
		if(not IsValid(v)) then table.remove(type3, k) end
	end
	for k, v in pairs(players) do
		if(not IsValid(v)) then table.remove(players, k) end
	end
end)

local function getcolor(ent) 
	if(Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") && ent.Blackouted != true) then
		if(table.HasValue(type2, ent)) then return Color(100, 100, 100) end
		if(table.HasValue(type2_friendly, ent)) then return Color(40, 100, 40) end
		if(table.HasValue(type2_enemy, ent)) then return Color(100, 40, 40) end
		if(table.HasValue(type3, ent)) then return Color(0, 125, 225) end
		if(table.HasValue(type1.available, ent)) then return Color(0, 125, 225) end
		if(table.HasValue(type1.unavailable, ent)) then return Color(50, 50, 50) end
		if(table.HasValue(type1.blocked, ent)) then return Color(125, 0, 0) end
		if(table.HasValue(routers, ent)) then return Color(247, 104, 2) end
		if(table.HasValue(player.GetAll(), ent)) then return Color(85, 30, 180) end
	else
		return Color(125, 0, 0)
	end
end

function glowents(tbl, color)
--[[ 
	if(table.Count(tbl) > 0) then
		local et = false
		cam.IgnoreZ(true)
		cam.Start3D2D(LocalPlayer():EyePos(), LocalPlayer():EyeAngles(), 1)
		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)
		render.ClearStencil()
		render.SetBlend(1)
		render.SetStencilEnable(true)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilZFailOperation(STENCIL_REPLACE)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilReferenceValue(1)
		for k, v in pairs(tbl) do
			if(IsValid(v)) then
				v:DrawModel()
				if(v.Object.Type == 3) then et = true end
			end
		end
		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilReferenceValue(1)
		cam.Start2D()
		surface.SetDrawColor(((Botnet>0 && LocalPlayer():GetNWBool("gctOS_Access") || et) && checkAnim("Blackout")==true) && color || Color(125, 0, 0))
		surface.SetMaterial(Material("blank.png"))
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		render.SetStencilEnable(false)
		cam.End2D()
		cam.End3D2D()
		cam.IgnoreZ(false)
	end
	]]
	
	if(table.Count(tbl) > 0) then
		render.SetLightingMode(1)
		render.SetColorModulation(color.r/255*(0.8+math.abs(math.cos(CurTime()*2)) * 0.2), color.g/255*(0.8+math.abs(math.cos(CurTime()*2))*0.2), color.b/255*(0.8+math.abs(math.cos(CurTime()*2))*0.2))
		local et = false
		for k, v in pairs(tbl) do
			if(IsValid(v)) then
				v:SetMaterial("models/debug/debugwhite")
				v:DrawModel()
				if(v.Object && v.Object.Type == 3) then et = true end
			end
		end
		render.SetLightingMode(0)
	end
end

local faso = false
hook.Add("gctOS_ToggleNethack", "gctOS_NethackToggle", function() 
	if(!nethack) then
		LocalPlayer():SetMaterial("")
		for k, v in pairs(allobjects) do
			if(IsValid(v)) then
				v:SetMaterial("")
			end
		end
		for k, v in pairs(notobjects) do
			if(IsValid(v)) then
				v:SetMaterial("")
			end
		end
	end
end)
hook.Add("PostDrawTranslucentRenderables", "gctOS_NetHack", function()
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
			--render.DrawSphere(game.StartSpot(), 50, 30, 30, Color( 0, 175, 175, 100 ) )
		if(nethack) then
			DrawTexturize(-100000000000000000000, Material("nethack/texturize.png"))
			glowents(notobjects, Color(75, 75, 75))
			cam.IgnoreZ(true)
			glowents(type2, Color(100, 100, 100))
			glowents(type2_enemy, Color(100, 40, 40))
			glowents(type2_friendly, Color(40, 100, 40))
			glowents(type3, Color(0, 125, 225))
			glowents(type1.available, Color(0, 125, 225))
			glowents(type1.unavailable, Color(50, 50, 50))
			glowents(type1.blocked, Color(125, 0, 0))
			glowents(routers, Color(247, 104, 2))
			--glowents(player.GetAll(), Color(85, 30, 180))
			Render_Lines()
			glowents({LocalPlayer()}, Color(0, 8, 16))
			cam.IgnoreZ(false)
			render.SetMaterial(Material("nethack/"..math.random(1, 10).."_2.png"))
			surface.SetDrawColor(255, 255, 255)
			render.DrawScreenQuadEx(0, 0, ScrW(), ScrH())
			if(not table.IsEmpty(allobjects)) then
				for i = 1, table.Count(allobjects)/2 do
					local e1 = table.Random(allobjects)
					local e2 = table.Random(allobjects)
					if(IsValid(e1) && IsValid(e2)) then
						render.SetMaterial(Material("blank.png"))
						render.DrawLine(e1:LocalToWorld(e1:OBBCenter()), e2:LocalToWorld(e2:OBBCenter()), (IsValid(e1:GetNWEntity("gctOS_Router")) || IsValid(e2:GetNWEntity("gctOS_Router"))) && Color(125, 0, 0, 25) || Color(100, 100, 100, 25))
					end
				end
				for k, v in pairs(allobjects) do
					if(IsValid(v:GetNWEntity("gctOS_Router"))) then
						render.SetMaterial(Material("blank.png"))
						render.DrawLine(v:LocalToWorld(v:OBBCenter()), v:GetNWEntity("gctOS_Router"):LocalToWorld(v:GetNWEntity("gctOS_Router"):OBBCenter()), Color(125, 0, 0, 25))				
					end
				end
				if(IsValid(nethack_hacked)) then
					for i = 1, math.floor(table.Count(allobjects)/12) do
						local e1 = nethack_hacked
						local e2 = table.Random(allobjects)
						if(IsValid(e1) && IsValid(e2)) then
							render.SetMaterial(Material("blank.png"))
							render.DrawLine(e1:LocalToWorld(e1:OBBCenter()), e2:LocalToWorld(e2:OBBCenter()), Color(0, 180, 255, 25 - 25*getAnim("NetHack_HLines")))
						end
					end
				end
			end
		end
	end
end)