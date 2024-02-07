-- [[ FOG IS COMING]] --








































AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "ctOS Control Center"
ENT.Author = "daZate"
ENT.Category = "gctOS"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Editable = true
ENT.Area = 1000
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Ents = {}
ENT.Disconnected = {}
ENT.Current = ""
ENT.Lines = {count = 1, list = {"Press E to interact", 'Type "help" to show available commands.', "Mouse Wheel to scroll."}, show = {}}
ENT.Scroll = 0
ENT.Aliases = {}
if(CLIENT) then ENT.ent_line = NULL end
local Commands = {"exit", "alias", "help", "echo", "whoami", "clear", "list", "execute", "disconnect", "connect", "executealln", "executeallnr", "blackout"}
function continue_cmd(start)
	for k, v in pairs(Commands) do
		if(string.sub(v, 0, #start) == start) then
			return v
		end
	end
	return start
end
ENT.CommandsFuncs = {
	["exit"] = function(self)
		if(SERVER) then
			self:GetNWEntity("gctOS_User"):SetNWEntity("gctOS_Terminal", NULL)
			self:SetNWEntity("gctOS_User", NULL)
		end
	end,
	["alias"] = function(self, arg)
		table.remove(arg, 1)
		local new_command = arg[1]
		table.remove(arg, 1)
		if(isfunction(self.CommandsFuncs[new_command])) then
			self:AddString('There is already command "'..new_command..'"')
		else
			self.Aliases[new_command] = table.concat(arg, " ")
		end
	end,
	["help"] = function(self)
		self:AddString("ctOS Control Center")
		self:AddString("Owner: "..self:GetNWEntity("gctOS_Owner"):Name())
		self:AddString("Property of Blume Corporation")
		self:AddString("")
		self:AddString("1. help - show this message")
		self:AddString("2. echo [text] - show text")
		self:AddString("3. clear - clear terminal")
		self:AddString("4. whoami - show your username")
		self:AddString("5. list - show all objects")
		self:AddString("6. execute [index] [num] - execute object's script")
		self:AddString('7. disconnect [index] - disconnect object from ctOS')
		self:AddString('8. connect [index] - connect object to ctOS')
		self:AddString('9. executealln [name] [num] - execute all objects with specific name')
		self:AddString('10. executeallr [radius] [num] - execute all objects in specific radius')
		self:AddString('11. executeallnr [name] [radius] [num] - execute all objects in specific radius')
		self:AddString('12. blackout - dsconnect everything from ctOS, open doors and turn off lights')
	end,
	["echo"] = function(self, arg)
		self:AddString(arg[2])
	end,
	["whoami"] = function(self)
		self:AddString(self:GetNWEntity("gctOS_User"):Name())
	end,
	["clear"] = function(self)
		self.Lines.list = {"Press E to interact", 'Type "exit" to leave terminal.', 'Type "help" to show available commands.', "Mouse Wheel to scroll."}
	end,
	["list"] = function(self)
		local hents = {}
		local hacks = {}
		for k, v in pairs(self.Ents) do
			if(v.Object && v:GetClass() != "player") then
				table.insert(hents, v)
				table.insert(hacks, v:EntIndex(), v)
				hacks[v:EntIndex()].D = {}
				if(v.Object.Type != 3) then
					for i = 1, 4 do
						if(v.Object.Hacks[i] && !table.IsEmpty(v.Object.Hacks[i])) then
							if(string.StartWith(v.Object.Hacks[i].Description, "Hack to")) then
								local s = string.sub(v.Object.Hacks[i].Description, 9, #v.Object.Hacks[i].Description)
								hacks[v:EntIndex()].D[i] = string.SetChar(s, 1, string.upper(s[1]))
							else
								hacks[v:EntIndex()].D[i] = v.Object.Hacks[i].Description
							end
						else
							hacks[v:EntIndex()].D[i] = "N/A"
						end
					end
				else
				end
			end

		end
		for k, v in pairs(hents) do
			if(v.Object.Type != 3) then
				self:AddString(k..": ")
				self:AddString("Index: "..v:EntIndex())
				self:AddString("Name: "..v:GetNWString("PName"))
				self:AddString("Status: "..(v:GetNWBool("Disconnected") && "Disconnected" || "Connected")..", "..(v:GetNWBool("Blocked") && "Locked" || "Unlocked"))
				self:AddString("Executables:")
				self:AddString("1. "..hacks[v:EntIndex()].D[1])
				self:AddString("2. "..hacks[v:EntIndex()].D[2])
				self:AddString("3. "..hacks[v:EntIndex()].D[3])
				self:AddString("4. "..hacks[v:EntIndex()].D[4])
			else
				self:AddString(k..": ")
				self:AddString("Index: "..v:EntIndex())
				self:AddString("Name: "..v.Object.Name)
			end
		end
	end,
	["execute"] = function(self, arg)
		if(CLIENT) then
			local ent = Entity(tonumber(arg[2]))
			self.ent_line = ent
			for i = 1, 1000 do
				timer.Simple(i/1000, function() ccanim = i/1000 end)
			end
			local h = tonumber(arg[3])
			if(ent.Object) then
				if(ent.Object.Type != 3) then
					if(ent.Object.Hacks[h]) then
						hook.Run("gctOS_Hack", ent, h)
					end
				else
					camhackt(ent)
				end
			end
		end
	end,
	["disconnect"] = function(self, arg)
		local ent = Entity(tonumber(arg[2]))
		if(ent.Object) then
			table.insert(self.Disconnected, tonumber(arg[2]), ent)
			self:AddString(ent.Object.Name.." was disconnected from ctOS.")
		else
			self:AddString("Object #"..arg[2].." was not found.")
		end
	end,
	["connect"] = function(self, arg)
		local ent = Entity(tonumber(arg[2]))
		if(table.HasValue(self.Disconnected, ent)) then
			table.remove(self.Disconnected, tonumber(arg[2]))
			self.Disconnected[tonumber(arg[2])] = nil
			self:AddString(ent.Object.Name.." was connected to ctOS.")
		else
			self:AddString("Object #"..arg[2].." was not found or it it already connected.")
		end
	end,
	["executealln"] = function(self, arg)
		local n = arg[2]
		local h = tonumber(arg[3])
		for k, v in pairs(gctOS.GetByName(self.Ents, n)) do
			if(v.Object) then
				if(v.Object.Hacks[h] != nil && !table.IsEmpty(v.Object.Hacks[h])) then
					v.Object.Hacks[h].Hack(self:GetNWEntity("gctOS_User"), v)
					self:AddString(v.PName.." #"..v:EntIndex().." executed sucessfully!")
				else
					self:AddString("Failed to execute "..v.PName.." #"..v:EntIndex())
				end
			end
		end
	end,
	["executeallr"] = function(self, arg)
		local r = tonumber(arg[2])
		local h = tonumber(arg[3])
		for k, v in pairs(ents.FindInSphere(self:GetPos(), r)) do
			if(v.Object) then
				if(v.Object.Hacks[h] != nil && !table.IsEmpty(v.Object.Hacks[h])) then
					v.Object.Hacks[h].Hack(self:GetNWEntity("gctOS_User"), v)
					self:AddString(v.PName.." #"..v:EntIndex().." executed sucessfully!")
				else
					self:AddString("Failed to execute #"..v:EntIndex())
				end
			end
		end
	end,
	["executeallnr"] = function(self, arg)
	local n = arg[2]
	local r = tonumber(arg[3])
	local h = tonumber(arg[4])
		for k, v in pairs(gctOS.GetByName(ents.FindInSphere(self:GetPos(), r), n)) do
			if(v.Object) then
				if(v.Object.Hacks[h] != nil && !table.IsEmpty(v.Object.Hacks[h])) then
					v.Object.Hacks[h].Hack(self:GetNWEntity("gctOS_User"), v)
					self:AddString(v.PName.." #"..v:EntIndex().." executed sucessfully!")
				else
					self:AddString("Failed to execute #"..v:EntIndex())
				end
			end	
		end
	end,
	["blackout"] = function(self, arg)
		gctOS.Blackout(self:GetPos(), 9999999, 10)
	end
}

function ENT:SetupDataTables()
	self:NetworkVar('Float', 0, 'AreaOfEffect', {KeyName = 'Effect Range', Edit = { type = 'Float', min = 1000, max = 3000, order = 2 } } )
	self:NetworkVar('Bool', 0, 'Enabled', {KeyName = 'Enabled', Edit = { type = 'Boolean', order = 1, value = true }})
end

function ENT:Initialize()
	if(SERVER) then
		self:SetUseType(SIMPLE_USE)
		self:SetNWEntity("gctOS_Owner", self.m_PlayerCreator)
		self:SetEnabled(true)
		self:SetAreaOfEffect(1000)
		self:SetPos(self:GetPos()+Vector(0,0,self:OBBMaxs().z))
		self:SetModel("models/props_lab/workspace002.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetName("ctos_controlcenter")
		util.AddNetworkString("gctOS_RouterEnter_"..self:EntIndex())
		util.AddNetworkString("gctOS_ExitTerminal_"..self:EntIndex())
		net.Receive("gctOS_RouterEnter_"..self:EntIndex(), function(l, p) 
			local c = net.ReadString()
			self:Enter(c)
		end)
		net.Receive("gctOS_ExitTerminal_"..self:EntIndex(), function(l, p) 
			self:GetNWEntity("gctOS_User"):SetNWEntity("gctOS_Terminal", NULL)
			self:SetNWEntity("gctOS_User", NULL)
		end)
	end
	if(CLIENT) then
		hook.Add("gctOS_KeyHandler", "gctOS_KeysTerminal_"..self:EntIndex(), function(key) 
			if(keys_names[key] == "ALT" && IsValid(self:GetNWEntity("gctOS_User"))) then
				net.Start("gctOS_ExitTerminal_"..self:EntIndex())
				net.SendToServer()
			end
			if(keys_names[key] == "TAB") then
				self.Current = continue_cmd(self.Current)
			end
		end)
	end
end

function ENT:Think()
	for i = 1, 25 do
		self.Lines.show[i] = self.Lines.list[i + self.Scroll]
	end

	for k, v in pairs(ents.GetAll()) do
		if(v.Object && v != self && v:GetClass() != "player") then
			table.insert(self.Ents, v:EntIndex(), v)
		end
		if(table.HasValue(self.Disconnected, v)) then
			if(!v:GetNWBool("Disconnected")) then
				v:SetNWBool("Disconnected", true)
				v.PDescription2 = "Disconnected from ctOS"
			end
		else
			if(v:GetNWBool("Disconnected")) then
				v:SetNWBool("Disconnected", false)
				v.PDescription2 = v.Object.Description2
			end
		end
	end
end

function ENT:Draw()
	local xoff = -280
	local yoff = -280
	self:DrawModel()
	cam.Start3D2D(self:LocalToWorld(Vector(-42, -42, 42)), self:LocalToWorldAngles(Angle(0, 135, 60)), 0.25)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(-70, -70, 141, 139)
	cam.End3D2D()	
	cam.Start3D2D(self:LocalToWorld(Vector(-42, -42, 42)), self:LocalToWorldAngles(Angle(0, 135, 60)), 0.06)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(xoff+16, yoff+16, 25, 20)
	draw.SimpleText("CT", "Router", xoff+16, yoff+10, Color(0, 0, 0))
	draw.SimpleText("OS", "RouterBig", xoff+8+36, yoff-3)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(xoff+16, yoff+42, 132, 20)
	draw.SimpleText("Control Center", "Router", xoff+16, yoff+10+26, Color(0, 0, 0))
	surface.DrawRect(xoff+480, yoff+16, 79, 20)
	draw.SimpleText("Terminal", "Router", xoff+480, yoff+10, Color(0, 0, 0))
	surface.DrawRect(xoff+16, yoff+90, 560-16, 474-16)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(xoff+18, yoff+92, 560-20, 474-20)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(xoff+550, yoff+92 + self.Scroll*4, 8, math.Clamp(455 - #self.Lines.list*4, 455, 10))
	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(xoff+18, yoff+522, 540, 24)
	draw.SimpleText('Enter "exit" or press ALT to leave terminal.', "RouterT", xoff+24, yoff+522, Color(0, 0, 0))
	surface.SetDrawColor(32, 32, 32)
	surface.DrawRect(xoff+18, yoff+96 + 16 * (#self.Lines.show), 532, 16)
	for k, v in pairs(self.Lines.show) do
		if(k<=(25 + self.Scroll)) then
			draw.SimpleText(v, "RouterT", xoff+22, yoff+92 + 16 * (k-1))
		end
	end
	if(#self.Lines.show < 27) then
		draw.SimpleText("admin@controlcenter:~".."$ "..self.Current..(math.cos(CurTime()*8) > 0.5 && "|" || ""), "RouterT", xoff+22, yoff+92 + 16 * (#self.Lines.show))
	end
	cam.End3D2D()	
	if(IsValid(self.ent_line)) then
		cam.IgnoreZ(true)
		render.DrawLine(self:GetPos() - self:GetAngles():Forward()*40 + self:GetAngles():Up()*30, self.ent_line:GetPos(),  Color(0, 180, 255, 255 - ccanim*255))
		cam.IgnoreZ(false)
	end
end

function ENT:Use(ply)
	if(SERVER) then
		if(!IsValid(self:GetNWEntity("gctOS_User"))) then
			self:SetNWEntity("gctOS_User", ply)
			ply:SetNWEntity("gctOS_Terminal", self)
		end
	end
end

function ENT:OnRemove()
	hook.Remove("gctOS_KeyHandler", "gctOS_KeysTerminal_"..self:EntIndex())
	for k, v in pairs(self.Ents) do	
		table.remove(self.Ents, k)
		v:SetNWBool("Blocked", false)
		if(v.PDescription2) then
			v.PDescription2 = v.Object.Description2
		end
	end
end

function ENT:AddString(str)
	self.Lines.count = self.Lines.count + 1
	if(#str > 64) then
		table.insert(self.Lines.list, string.sub(str, 1, 64).."-")
		table.insert(self.Lines.list, string.sub(str, 65, #str))
	else
		table.insert(self.Lines.list, str)
	end
end

function ENT:Enter(text)
	self:AddString("admin@controlcenter:~$ "..text)
	local expl = string.Explode(" ", text)
	local cmd = expl[1]
	local arg = expl
	
	if(isfunction(self.CommandsFuncs[cmd])) then
		self.CommandsFuncs[cmd](self, arg)
	elseif(self.Aliases[cmd] == nil) then
		self:AddString("Unknown command: "..cmd)
	end
	
	if(self.Aliases[cmd] != nil) then
		self:Enter(self.Aliases[cmd])
	end
	self.Current = ""
	if(#self.Lines.show > 23) then
		self.Scroll = self.Scroll + 3
	end
end