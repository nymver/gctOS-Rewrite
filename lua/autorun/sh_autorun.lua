-- [[ туман приближается ]] --








































hook.Add("InitPostEntity", "gctOS_BootUp", function()

	if(SERVER) then
		regenerate_botnet = CreateConVar("sv_gctos_botnetregenerate", 4, FCVAR_LUA_SERVER, "Regenerating botnet", 0, 20)
		regenerate_botnet_del = CreateConVar("sv_gctos_botnetregeneratedelay", 5, FCVAR_LUA_SERVER, "Delay between botnet regenerating", 0, 20)
		default_botnet = CreateConVar("sv_gctos_defaultbotnet", 4, FCVAR_LUA_SERVER, "Default botnet", 0, 20)
		drain_botnet = CreateConVar("sv_gctos_drainbotnet", 1, FCVAR_LUA_SERVER, "Drain botnet?", 0, 1)
		unlimited_hacks = CreateConVar("sv_gctos_unlimitedhacks", 0, FCVAR_LUA_SERVER, "Make hacks unlimited?", 0, 1)
		ofa = CreateConVar("sv_gctos_ofa", 0, FCVAR_LUA_SERVER, "Hacking only for admin?", 0, 1)
		facooldown = CreateConVar("sv_gctos_facooldown", 10, FCVAR_LUA_SERVER, "Cooldown for FastApp", 1, 30)
		blackoutarea = CreateConVar("sv_gctos_blackoutarea", 4000, FCVAR_LUA_SERVER, "Area of Blackout", -1, 20000)
		jcarea = CreateConVar("sv_gctos_jcarea", 4000, FCVAR_LUA_SERVER, "Area of Jam Comms", -1, 20000)
		mtarea = CreateConVar("sv_gctos_mtarea", 4000, FCVAR_LUA_SERVER, "Area of Mad Tech", -1, 20000)
		mvarea = CreateConVar("sv_gctos_mvarea", 4000, FCVAR_LUA_SERVER, "Area of Mad Vehicles", -1, 20000)
		nethack_drain_botnet = CreateConVar("sv_gctos_hacknetdrainbotnet", 1, FCVAR_LUA_SERVER, "NetHack drains botnet?", 0, 1)
		car_time = CreateConVar("sv_gctos_cartime", 3, FCVAR_LUA_SERVER, "How much time cars go forward?", 3, 11)
		gaoj = CreateConVar("sv_gctos_giveaccessonjoin", 1, FCVAR_LUA_SERVER, "Players have gctOS access on join?", 0, 1)
	end
	
	if(CLIENT) then
		--[[
		regenerate_botnet = CreateConVar("sv_gctos_botnetregenerate", 4, FCVAR_LUA_SERVER, "Regenerating botnet", 0, 20)
		regenerate_botnet_del = CreateConVar("sv_gctos_botnetregeneratedelay", 5, FCVAR_LUA_SERVER, "Delay between botnet regenerating", 0, 20)
		default_botnet = CreateConVar("sv_gctos_defaultbotnet", 4, FCVAR_LUA_SERVER, "Default botnet", 0, 20)
		drain_botnet = CreateConVar("sv_gctos_drainbotnet", 1, FCVAR_LUA_SERVER, "Drain botnet?", 0, 1)
		unlimited_hacks = CreateConVar("sv_gctos_unlimitedhacks", 0, FCVAR_LUA_SERVER, "Make hacks unlimited?", 0, 1)
		ofa = CreateConVar("sv_gctos_ofa", 0, FCVAR_LUA_SERVER, "Hacking only for admin?", 0, 1)
		facooldown = CreateConVar("sv_gctos_facooldown", 10, FCVAR_LUA_SERVER, "Cooldown for FastApp", 1, 30)
		blackoutarea = CreateConVar("sv_gctos_blackoutarea", 4000, FCVAR_LUA_SERVER, "Area of Blackout", -1, 20000)
		jcarea = CreateConVar("sv_gctos_jcarea", 4000, FCVAR_LUA_SERVER, "Area of Jam Comms", -1, 20000)
		mtarea = CreateConVar("sv_gctos_mtarea", 4000, FCVAR_LUA_SERVER, "Area of Mad Tech", -1, 20000)
		mvarea = CreateConVar("sv_gctos_mvarea", 4000, FCVAR_LUA_SERVER, "Area of Mad Vehicles", -1, 20000)
		nethack_drain_botnet = CreateConVar("sv_gctos_hacknetdrainbotnet", 1, FCVAR_LUA_SERVER, "NetHack drains botnet?", 0, 1)
		car_time = CreateConVar("sv_gctos_cartime", 3, FCVAR_LUA_SERVER, "How much time cars go forward?", -1, 10)
		gaoj = CreateConVar("sv_gctos_giveaccessonjoin", 1, FCVAR_LUA_SERVER, "Players have gctOS access on join?", -1, 10)
		]]
		drawblur = CreateClientConVar("cl_gctos_drawblur", "1", true, false, "Draw blur?", 0, 1)
		hud_safezone = CreateClientConVar("cl_gctos_safezone", 0, true, false, "Safezone of HUD", 0, 128)
		enableaddon = CreateClientConVar("cl_gctos_enableaddon", "1", true, false, "Enable addon?", 0, 1)
		regenerate_botnet = GetConVar("sv_gctos_botnetregenerate")
		regenerate_botnet_del = GetConVar("sv_gctos_botnetregeneratedelay")
		default_botnet = GetConVar("sv_gctos_defaultbotnet")
		drain_botnet = GetConVar("sv_gctos_drainbotnet")
		unlimited_hacks = GetConVar("sv_gctos_unlimitedhacks")
		ofa = GetConVar("sv_gctos_ofa")
		facooldown = GetConVar("sv_gctos_facooldown")
		blackoutarea = GetConVar("sv_gctos_blackoutarea")
		jcarea = GetConVar("sv_gctos_jcarea")
		mtarea = GetConVar("sv_gctos_mtarea")
		mvarea = GetConVar("sv_gctos_mvarea")
		nethack_drain_botnet = GetConVar("sv_gctos_hacknetdrainbotnet")
		car_time = GetConVar("sv_gctos_cartime")
		gaoj = GetConVar("sv_gctos_giveaccessonjoin")
	end
	
	if(SERVER) then 
		AddCSLuaFile("gctos/ents_handler.lua")	
		AddCSLuaFile("gctos/main.lua") 
		AddCSLuaFile("gctos/citizens_info.lua")
		local files = file.Find("hackable_objects/*", "LUA")
		for k, v in pairs(files) do
			AddCSLuaFile("hackable_objects/"..v)
		end
		AddCSLuaFile("gctos/hacking.lua")
		AddCSLuaFile("gctos/client/main_client.lua")
		AddCSLuaFile("gctos/client/vgui.lua")
		AddCSLuaFile("gctos/client/animations.lua")
		AddCSLuaFile("gctos/client/keys.lua")
		AddCSLuaFile("gctos/client/surface_adds.lua")
		AddCSLuaFile("gctos/client/hud.lua")
		AddCSLuaFile("gctos/smartphone.lua")
	end
	
	include("gctos/ents_handler.lua")
	include("gctos/main.lua")
	include("gctos/citizens_info.lua")
	
	local files = file.Find("hackable_objects/*", "LUA")
	for k, v in pairs(files) do
		include("hackable_objects/"..v)
	end
	
	include("gctos/hacking.lua")
	if(CLIENT) then
		include("gctos/client/animations.lua")
		include("gctos/client/main_client.lua")
		include("gctos/client/vgui.lua")
		include("gctos/client/keys.lua")
		include("gctos/client/surface_adds.lua")
		include("gctos/client/hud.lua")
	end
	
	include("gctos/smartphone.lua")

	if(CLIENT) then
		chat.AddText(Color(0, 180, 255), "[gctOS Rewrite] ", Color(255, 255, 255), "Loaded "..gctOS.ObjCount.." objects")
	end
end)