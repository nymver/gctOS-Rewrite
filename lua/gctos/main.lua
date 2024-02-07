-- [[ FOG IS COMING]] --








































--[[
	gctOS Rewrite

	Main
]]

gctOS = {}

if(CLIENT) then
	gctOS.Bindings = {
		Profiler = KEY_T,
		Hackmenu = MOUSE_MIDDLE,
		Hack1 = KEY_SPACE,
		Hack2 = KEY_C,
		Hack3 = KEY_F,
		Hack4 = KEY_R,
		CamHack = KEY_B,
		NetHack = KEY_H,
		FastApp = KEY_G
	}
	gctOS.DefaultBindings = {
		Profiler = KEY_T,
		Hackmenu = MOUSE_MIDDLE,
		Hack1 = KEY_SPACE,
		Hack2 = KEY_C,
		Hack3 = KEY_F,
		Hack4 = KEY_R,
		CamHack = KEY_B,
		NetHack = KEY_H,
		FastApp = KEY_G
	}
	
	if(file.Exists("gctos_settings.txt", "DATA")) then
		local r = util.JSONToTable(file.Read("gctos_settings.txt", "DATA"))
		gctOS.Bindings = r
	else
		file.Write("gctos_settings.txt", util.TableToJSON(gctOS.Bindings))
	end
end

gctOS.ObjectsBases = {}
gctOS.Entities = {}
gctOS.Classes = {"any"}
gctOS.Models = {"any"}
gctOS.ObjCount = 0

properties.Add("COPY_CLASS", {
	MenuLabel = "Copy class",
	MenuIcon = "icon16/paste_plain.png",
	Order = 1,
	Filter = function( self, ent, ply )
		return true
	end,
	Action = function( self, ent )
		SetClipboardText(ent:GetClass())
	end,
	Receive = function( self, length, ply )
	end
})

properties.Add("COPY_MODEL", {
	MenuLabel = "Copy model",
	MenuIcon = "icon16/paste_plain.png",
	Order = 1,
	Filter = function( self, ent, ply )
		return true
	end,
	Action = function( self, ent )
		SetClipboardText(ent:GetModel())
	end,
	Receive = function( self, length, ply )
	end
})

properties.Add("COPY_INDEX", {
	MenuLabel = "Copy index",
	MenuIcon = "icon16/paste_plain.png",
	Order = 1,
	Filter = function( self, ent, ply )
		return true
	end,
	Action = function( self, ent )
		SetClipboardText(ent:EntIndex())
	end,
	Receive = function( self, length, ply )
	end
})

function booltonumber(bool)
	return bool && 1 || 0
end

function numbertobool(int)
	return int > 0
end

function distance2D(ent)
	return math.Distance(ScrW()/2, ScrH()/2, ent:GetPos():ToScreen().x, ent:GetPos():ToScreen().y)
end

function explode(pos, power)
	local explode = ents.Create("env_explosion") 
	explode:SetPos(pos)
	explode:Spawn() 
	explode:SetKeyValue("iMagnitude", power)
	explode:Fire("Explode")
end

function inrange(val, min, max)
	return val >= min && val <= max
end

--[[
if(SERVER) then
	local cts = {277}
	local objs = {47, 280, 281}
	function TEST_PLAYER_HACK()
		local r = table.Random(cts)
		local o = Entity(table.Random(objs))
		net.Start("gctOS_PlayerHack")
		net.WriteEntity(Entity(r))
		net.WriteEntity(o)
		net.WriteInt(1, 8)
		net.Broadcast()
	end
	TEST_PLAYER_HACK()
	timer.Simple(2, function()
		TEST_PLAYER_HACK()
	end)
	timer.Simple(4, function()
		TEST_PLAYER_HACK()
	end)
	timer.Simple(6, function()
		TEST_PLAYER_HACK()
	end)
end
]]


function gctOS.IsHackable(ent)
	local obj_base = gctOS.GetObjectBase(ent)
	return (table.HasValue(gctOS.Classes, obj_base.Class) && table.HasValue(gctOS.Models, isstring(obj_base.Model) && string.lower(obj_base.Model) || obj_base.Model)) && true || false
end

function gctOS.CheckForHacks(ent)
	local res = false
	for i = 1, 4 do
		if((!gctOS.GetHackUsed(ent, i)) && gctOS.GetHackStatus(ent, i)) then	
			res = true
		end
	end
	return res
end

function gctOS.CheckForHacksObj(obj)
	local res = false
	for i = 1, 4 do
		if(istable(obj.Hacks) && istable(obj.Hacks[i]) && !table.IsEmpty(obj.Hacks[i])) then
			res = true
		end
	end
	return res
end

gctOS.PFuncs = {}

gctOS.PFuncs["SetType2"] = function(ent, tab)
	ent:SetNWString("PIcon", tab.Icon)
	ent:SetNWString("PEmotion", tab.Emotion)
	ent:SetNWString("PName", tab.Name)
	ent:SetNWString("PDesc", tab.Description)
	ent:SetNWString("PDesc2", tab.Description2)
	ent:SetNWString("PInfo1", tab.Info1)
	ent:SetNWString("PInfo2", tab.Info2)
	ent:SetNWVector("PColor", Vector(tab.Color.r, tab.Color.g, tab.Color.b))
	ent:SetNWVector("PIColor", Vector(tab.IColor.r, tab.IColor.g, tab.IColor.b))
end

gctOS.PFuncs["SetType1"] = function(ent, tab)
	ent:SetNWString("PName", tab.Name)
	ent:SetNWString("PDesc", tab.Description)
	ent:SetNWString("PDesc2", tab.Description2)
	ent:SetNWString("PIcon", tab.Icon)
end


gctOS.PFuncs["GetType2"] = function(ent)
	local tab = {}
	tab.Icon = ent:GetNWString("PIcon")
	tab.Emotion = ent:GetNWString("PEmotion")
	tab.Name = ent:GetNWString("PName")
	tab.Description = ent:GetNWString("PDesc")
	tab.Description2 = ent:GetNWString("PDesc2")
	tab.Info1 = ent:GetNWString("PInfo1")
	tab.Info2 = ent:GetNWString("PInfo2")
	tab.Color = Color(ent:GetNWVector("PColor").x, ent:GetNWVector("PColor").y, ent:GetNWVector("PColor").z)
	tab.IColor = Color(ent:GetNWVector("PIColor").x, ent:GetNWVector("PIColor").y, ent:GetNWVector("PIColor").z)
	return tab
end

gctOS.PFuncs["GetType1"] = function(ent)
	local tab = {}
	tab.Name = ent:GetNWString("PName")
	tab.Description = ent:GetNWString("PDesc")
	tab.Description2 = ent:GetNWString("PDesc2")
	tab.Icon = ent:GetNWString("PIcon")
	return tab
end

gctOS.PFuncs["SetColor2"] = function(ent, color)
	for i = 1, 1000 do
		local r = i/1000
		timer.Simple(i/5000, function()
			ent:SetNWVector("PColor", Vector(0*(1-r)+color.r*r, 180*(1-r)+color.g*r, 255*(1-r)+color.b*r))
		end)
	end
end

function gctOS.GetObjectBase(ent)
	if(!IsValid(ent)) then return {} end
	local result = {}
	for k, obj in pairs(gctOS.ObjectsBases) do
		local Model = obj.Model
		local Class = obj.Class
		if(type(Model)=="string" && type(Class)=="string") then
			if((((string.lower(ent:GetModel() || "") || nil) == string.lower(Model)) || Model == "any") && (((string.lower(ent:GetClass() || "") || nil) == string.lower(Class)) || Class == "any")) then
				result = obj
				break
			end
		elseif(type(Model)=="table" && type(Class)=="string") then
			if(table.HasValue(Model, ent:GetModel()) && (((string.lower(ent:GetClass() || "") || nil) == string.lower(Class)) || Class == "any")) then
				result = obj
				break
			end
		elseif(type(Model)=="string" && type(Class)=="table") then 
			if((((string.lower(ent:GetModel() || "") || nil) == string.lower(Model)) || Model == "any") && table.HasValue(Class, ent:GetClass())) then
				result = obj
				break
			end
		end
	end
	return result
end 

function gctOS.GetObject(ent)
	return ent.Object
end

function gctOS.AddObject(obj)
	gctOS.ObjCount = gctOS.ObjCount + 1
	table.insert(gctOS.ObjectsBases, obj)
	if(!table.HasValue(gctOS.Classes, obj.Class)) then
		table.insert(gctOS.Classes, obj.Class)
	end
	if(!table.HasValue(gctOS.Models, obj.Model)) then
		table.insert(gctOS.Models, type(obj.Model) == "string" && string.lower(obj.Model) || obj.Model)
	end
end

function gctOS.GetByName(objs, name)
	local res = {}
	for k, v in pairs(objs) do
		if(string.lower(v.PName || "") == string.lower(name)) then
			table.insert(res, v)
		end
	end
	return res
end

function gctOS.GetByName_Dynamic(objs, name)
	local res = {}
	for k, v in pairs(objs) do
		if(string.StartWith(v.PName, name)) then
			table.insert(res, v)
		end
	end
	return res
end

function gctOS.SetHackStatus(ent, hack, status)
	if(unlimited_hacks:GetInt()==0) then
		ent:SetNWBool("Available"..hack, status)
	end
end

function gctOS.GetHackStatus(ent, hack)
	return ent:GetNWBool("Available"..hack)
end

function gctOS.SetHackUsed(ent, hack, status)
	if(unlimited_hacks:GetInt()==0) then
		ent:SetNWBool("Used"..hack, status)
	end
end

function gctOS.GetHackUsed(ent, hack)
	return ent:GetNWBool("Used"..hack)
end

if(CLIENT) then
	keys_binds = {gctOS.Bindings.Hackmenu, gctOS.Bindings.Profiler, gctOS.Bindings.Hack1, gctOS.Bindings.Hack2, gctOS.Bindings.Hack3, gctOS.Bindings.Hack4, gctOS.Bindings.HackCam}
	bindings = {}
	for k, v in pairs(keys_binds) do
		bindings[#bindings+1] = input.LookupKeyBinding(v)
	end
	hook.Add("PlayerBindPress", "gctOS_BindsHandler", function(ply, bind, p)
		if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
			for k, v in pairs(bindings) do
				if(bind:find(v) && hackmenu) then
					return true
				end
				if(IsValid(ply:GetNWEntity("gctOS_Camera"))) then
					if(bind:find("invprev")) then
						ply:SetFOV(math.Clamp(ply:GetFOV()-3, 10, 75))
						return true
					end
					if(bind:find("invnext")) then
						ply:SetFOV(math.Clamp(ply:GetFOV()+3, 10, 75))
						return true
					end
					if(bind:find("attack")) then
						return true
					end
				end
				if(IsValid(ply:GetNWEntity("gctOS_Terminal"))) then
					if(bind:find("invprev")) then
						ply:GetNWEntity("gctOS_Terminal").Scroll = math.Clamp(ply:GetNWEntity("gctOS_Terminal").Scroll - 1, 0, #ply:GetNWEntity("gctOS_Terminal").Lines.list)
						return true
					end
					if(bind:find("invnext")) then
						ply:GetNWEntity("gctOS_Terminal").Scroll = math.Clamp(ply:GetNWEntity("gctOS_Terminal").Scroll + 1, 0, #ply:GetNWEntity("gctOS_Terminal").Lines.list)
						return true
					end
					return true
				end
			end
		end
	end)

	local tohide = {["CHudAmmo"] = true, ["CHudSecondaryAmmo"] = true, ["CHudHealth"] = true, ["CHudBattery"] = true, ["CHudDamageIndicator"] = true, ["CHudCrosshair"] = true}
	hook.Add("HUDShouldDraw", "gctOS_NoHUD", function(name)
		if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
	    	if(tohide[name]) then return false end
		end
	end)
end

if(SERVER) then
	hook.Add("PlayerSpawn", "gctOS_CamFix", function(ply)
		ply:SetViewEntity(ply)
		if(game.SinglePlayer() || GetConVar("sv_gctos_giveaccessonjoin"):GetInt() == 1) then
			ply:SetNWBool("gctOS_Access", true)
		end
	end)
end

function gctOS.Blackout(pos, on)
	if(!on) then on = false end
	for k, v in pairs(GetConVar("sv_gctos_blackoutarea"):GetInt() == -1 && ents.GetAll() || ents.FindInSphere(pos, GetConVar("sv_gctos_blackoutarea"):GetInt())) do
		for i = 1, 10 do
			timer.Simple(on && i/10 || i/5, function()
				if(IsValid(v)) then 
					if(v:GetClass()=="gmod_wire_consolescreen") then
						v.CharY = math.random(0, 55)
						v.CharX = math.random(0, 55)
						v.Char = 0
						v.CharParam = math.random(0, 256*256)
						v:SendPixel()
					end
					if(v:GetClass() == "gmod_light") then
						v:SetOn(numbertobool(math.random(0, 1)))
					end
					if(v:GetClass() == "gmod_lamp") then
						v:SetOn(numbertobool(math.random(0, 1)))
					end
					if(v:GetClass()=="gmod_wire_textscreen") then
						local cm = math.random(1, 2)
						v:TriggerInput("String", "SYSTEM ERROR")
						v:TriggerInput("FGColor", (cm==1) && (Vector(255, 255, 255)) || (Vector(0, 0, 255)))
						v:TriggerInput("BGColor", (cm==1) && (Vector(0, 0, 255)) || (Vector(255, 255, 255)))
					end
					if(v:GetClass() == "dronesrewrite_ardrone") then
						v:SetEnabled(numbertobool(math.random(0, 1)))
					end
					v:SetNWBool("gctOS_LightToggle", numbertobool(math.random(0, 1)))
					v:SetNWBool("gctOS_DedSec_Screen", numbertobool(math.random(0, 1)))
				end
			end)
		end
	end
	timer.Simple(on && 1 || 2.5, function()
		local t = GetConVar("sv_gctos_blackoutarea"):GetInt() == -1 && ents.GetAll() || ents.FindInSphere(pos, GetConVar("sv_gctos_blackoutarea"):GetInt())
		local c = 0
		for k, v in pairs(t) do
			if(v.Object) then
				c = c + 1
				timer.Simple((c/(#t))*10, function()
					if(v.Object && IsValid(v)) then
						local class = v:GetClass()
						local model = v:GetModel()
						if(v:GetClass() == "dronesrewrite_ardrone") then
							v:SetEnabled(on)
						end
						if(v:GetClass() == "gmod_light") then
							v:SetOn(on)
						end
						if(v:GetClass() == "gmod_lamp") then
							v:SetOn(on)
						end
						if(isfunction(v.Fire) && v:GetClass() == "prop_door_rotating" || v:GetClass() == "func_door_rotating" || v:GetClass() == "func_door") then
							v:Fire("Unlock")
							v:Fire("Open")
							v:Fire("Lock")
						end
						if(v:GetClass() == "npc_turret_floor") then
							v:Fire("Toggle")
						end
						if(v:GetClass() == "npc_rollermine") then
							v:Fire(on && "TurnOn" || 'TurnOff')
						end
						if(v:GetClass() == "npc_manhack") then
							v:Fire("InteractivePowerDown")
						end
						if(v:GetClass()=="gmod_wire_textscreen") then
							v:TriggerInput("String", "")
							v:TriggerInput("FGColor", Vector(255, 255, 255))
							v:TriggerInput("BGColor", Vector(0, 0, 0))
						end
						if(v:GetClass()=="gmod_wire_consolescreen") then
							for i = 0, 55 do
								for k = 0, 55 do
									v.CharY = i
									v.CharX = k
									v.Char = 0
									v.CharParam = 0
									v:SendPixel()
								end
							end
						end
						v:SetNWBool("gctOS_LightToggle", on)
						v:SetNWBool("gctOS_DedSec_Screen", false)
					end
				end)
			end
		end
	end)
end

for k, ent in pairs(ents.GetAll()) do
	ent_init(ent)
end