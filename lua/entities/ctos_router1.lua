-- [[ FOG IS COMING]] --








































AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "ctOS Router"
ENT.Author = "daZate"
ENT.Category = "gctOS"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Editable = true
ENT.Area = 1000
ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.BlockedEnts = {}
ENT.Current = ""
ENT.Lines = {count = 1, list = {"Press E to interact", 'Type "exit" to leave terminal.', 'Type "help" to show available commands.', "Mouse Wheel to scroll."}, show = {}}
ENT.Scroll = 0
ENT.CommandsFuncs = {
	["exit"] = function(self)
		if(SERVER) then
			self:GetNWEntity("gctOS_User"):SetNWEntity("gctOS_Terminal", NULL)
			self:SetNWEntity("gctOS_User", NULL)

		end
	end,
	["help"] = function(self, arg)
		self:AddString("ctOS Router")
		self:AddString("Owner: "..self:GetNWEntity("gctOS_Owner"):Name())
		self:AddString("Property of Blume Corporation")
		self:AddString("")
		self:AddString("1. help - show this message")
		self:AddString("2. login [passwd] - get root permissions")
		self:AddString("3. logout - become guest")
		self:AddString("4. echo [text] - show text")
		self:AddString("5. lock [obj_index] - lock object (need root permissions)")
		self:AddString("6. unlock [obj_index] - unlock object (need root permissions)")
		self:AddString("7. lockall - lock all objects (need root permissions)")
		self:AddString("8. unlockall - unlock all objects (need root permissions)")
		self:AddString("9. profedit [obj_index] | [name] | [desc] | [info1] | [info2] - edit profiler of object")
		self:AddString("10. list - show list of objects")
		self:AddString("11. changepassword [new passwd] - change password (need root permissions)")
		self:AddString("12. randompassword - set new random password (need root permissions)")
		self:AddString("13. clear - clear terminal")
		self:AddString("14. whoami - show your username")
	end,
	["echo"] = function(self, arg)
		self:AddString(arg)
	end,
	["login"] = function(self, arg)
		if(arg==self:GetNWString("gctOS_Password")) then
			self.User = "root"
		else
			self:AddString("Incorrect password.")
		end
	end,
	["changepassword"] = function(self, arg)
		if(self.User=="root") then
			self.Password = arg
			if(SERVER) then
				self:SetNWString("gctOS_Password", arg)
			end
			self:AddString("Password changed successfully.")
		else
			self:AddString("Restriced for guests.")
		end
	end,
	["logout"] = function(self)
		self.User = "guest"
	end,
	["whoami"] = function(self)
		self:AddString(self:GetNWEntity("gctOS_User"):Name().." ("..self.User..")")
	end,
	["list"] = function(self)
		local hents = {}
		for k, v in pairs(self.BlockedEnts) do
			if(v.Object && v:GetClass() != "player") then
				table.insert(hents, v)
			end
		end
		for k, v in pairs(hents) do
			self:AddString(k..": ")
			self:AddString("Index: "..v:EntIndex())
			self:AddString("Name: "..v.Profiler.Name)
			self:AddString(v:GetNWBool("Blocked") && "Status: Locked" || "Status: Unlocked")
			self:AddString("")
		end
	end,
	["unlock"] = function(self, arg)
		if(self.User == "root") then
			if(table.HasValue(self.BlockedEnts, Entity(arg))) then
				Entity(arg).TLocked = false
				Entity(arg):SetNWBool("Blocked", false)
				self:AddString("Object #"..arg.." unlocked")
			else
				self:AddString("Object #"..arg.." not found.")
			end
		else
			self:AddString("Restriced for guests.")
		end
	end,
	["lock"] = function(self, arg)
		if(self.User == "root") then
			if(table.HasValue(self.BlockedEnts, Entity(arg))) then
				Entity(arg).TLocked = true
				Entity(arg):SetNWBool("Blocked", true)
				self:AddString("Object #"..arg.." locked")
			else
				self:AddString("Object #"..arg.." not found.")
			end
		else
			self:AddString("Restriced for guests.")
		end
	end,
	["unlockall"] = function(self)
		if(self.User == "root") then
			local count = 0
			for k, v in pairs(self.BlockedEnts) do
				count = count + 1
				v.TLocked = false
				v:SetNWBool("Blocked", false)
			end
			self:AddString(count.." objects unlocked.")
		else
			self:AddString("Restriced for guests.")
		end
	end,
	["lockall"] = function(self)
		if(self.User == "root") then
			local count = 0
			for k, v in pairs(self.BlockedEnts) do
				count = count + 1
				v.TLocked = true
				v:SetNWBool("Blocked", true)
			end
			self:AddString(count.." objects locked.")
		else
			self:AddString("Restriced for guests.")
		end
	end,
	["clear"] = function(self)
		self.Lines.list = {"Press E to interact", 'Type "exit" to leave terminal.', 'Type "help" to show available commands.', "Mouse Wheel to scroll."}
	end,
	["randompassword"] = function(self)
		if(self.User == "root") then
			if(SERVER) then
				local newpass = ""
				for i = 1, 8 do
					local b = math.random(1, 2)
					if(b==1) then
						newpass = newpass..string.char(math.random(48, 57))
					else
						newpass = newpass..string.char(math.random(97, 122))
					end
				end
				self:SetNWString("gctOS_Password", newpass)
			end
			timer.Simple(FrameTime(), function()
				self:AddString("New password: "..self:GetNWString("gctOS_Password"))
			end)
		else
			self:AddString("Restriced for guests.")
		end
	end
}
ENT.User = "guest"
ENT.Password = ""

function ENT:SetupDataTables()
	self:NetworkVar('Float', 0, 'AreaOfEffect', {KeyName = 'Effect Range', Edit = { type = 'Float', min = 1000, max = 3000, order = 2 } } )
	self:NetworkVar('Bool', 0, 'Enabled', {KeyName = 'Enabled', Edit = { type = 'Boolean', order = 1, value = true }})
end

function ENT:Initialize()
	if(SERVER) then
		self:SetUseType(SIMPLE_USE)
		for i = 1, 8 do
			local b = math.random(1, 2)
			if(b==1) then
				self.Password = self.Password..string.char(math.random(48, 57))
			else
				self.Password = self.Password..string.char(math.random(97, 122))
			end
		end
		self:SetNWEntity("gctOS_Owner", self.m_PlayerCreator)
		self:SetNWString("gctOS_Password", self.Password)
		self.m_PlayerCreator:SendLua("chat.AddText(Color(0, 180, 255), '[ctOS Router] ', Color(255, 255, 255), 'Password: "..self.Password.."')")
		self:SetEnabled(true)
		self:SetAreaOfEffect(1000)
		self:SetPos(self:GetPos()+Vector(0,0,self:OBBMaxs().z))
		self:SetModel("models/props/de_nuke/nuclearcontrolbox.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetName("ctos_router1")

		util.AddNetworkString("gctOS_RouterEnter_"..self:EntIndex())
		net.Receive("gctOS_RouterEnter_"..self:EntIndex(), function(l, p) 
			local c = net.ReadString()
			self:Enter(c)
		end)
	end
end

function ENT:Think()
	for i = 1, 15 do
		self.Lines.show[i] = self.Lines.list[i + self.Scroll]
	end
	for k, v in pairs(ents.FindInSphere(self:GetPos(), self:GetAreaOfEffect())) do
		if(!self.BlockedEnts[v:EntIndex()]) then
			if(v.Object && (v:GetClass() == "player" || v.Object.Type == 1) && v != self && v:GetClass() != "ctos_router1" && !v:GetNWBool("Disconnected")) then
				table.insert(self.BlockedEnts, v:EntIndex(), v)
			end
		end
	end
	for k, v in pairs(self.BlockedEnts) do
		if(IsValid(v)) then
			if(v.TLocked == nil || v.TLocked == true) then
				v:SetNWEntity("gctOS_Router", self)
			else
				v:SetNWEntity("gctOS_Router", NULL)
			end
			v:SetNWBool("Blocked", (v.TLocked == nil || v.TLocked == true) && true || false)
			if(v.Object && v:GetClass() != "player") then
				v:SetNWString("PDesc2", ((v.TLocked == true || v.TLocked == nil) && v:GetPos():Distance(self:GetPos()) < self:GetAreaOfEffect()) && "Locked by ctOS Router" || v.Profiler.Description2)
			end
			if(v:GetPos():Distance(self:GetPos()) > self:GetAreaOfEffect()) then
				v:SetNWBool("Blocked", false)
				table.remove(self.BlockedEnts, v:EntIndex())
			end
		end
	end
end

function ENT:Draw()
	self:DrawModel()
	if(!nethack) then
		cam.Start3D2D(self:LocalToWorld(Vector(3.25, -11, 11.5)), self:LocalToWorldAngles(Angle(0, 90, 90)), 0.25)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, 85, 92)
		cam.End3D2D()	
		cam.Start3D2D(self:LocalToWorld(Vector(3.25, -11, 11.5)), self:LocalToWorldAngles(Angle(0, 90, 90)), 0.06)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(16, 16, 25, 20)
		draw.SimpleText("CT", "Router", 16, 10, Color(0, 0, 0))
		draw.SimpleText("OS", "RouterBig", 8+36, -3)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(16, 42, 72, 20)
		draw.SimpleText("Router", "Router", 16, 10+26, Color(0, 0, 0))
		surface.DrawRect(360-98, 16, 79, 20)
		draw.SimpleText("Terminal", "Router", 360-81-16, 10, Color(0, 0, 0))
		surface.DrawRect(16, 90, 338-16, 293-16)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(18, 92, 338-20, 293-20)
		surface.SetDrawColor(32, 32, 32)
		surface.DrawRect(18, 96 + 16 * (#self.Lines.show), 310, 16)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(328, 92 + self.Scroll*4, 8, 289 - #self.Lines.list*4.5)
		for k, v in pairs(self.Lines.show) do
			if(k<=(15 + self.Scroll)) then
				draw.SimpleText(v, "RouterT", 22, 92 + 16 * (k-1))
			end
		end
		if(#self.Lines.show <= 15) then
			draw.SimpleText(self.User.."@router:"..(self.User == "root" && "/" || "~").."$ "..self.Current..(math.cos(CurTime()*8) > 0.5 && "|" || ""), "RouterT", 22, 92 + 16 * (#self.Lines.show))
		end
		cam.End3D2D()
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
	for k, v in pairs(self.BlockedEnts) do	
		v:SetNWBool("Blocked", false)
		v:SetNWString("PDesc2", v.Object.Description2)
		table.remove(self.BlockedEnts, k)
	end
end

function ENT:AddString(str)
	self.Lines.count = self.Lines.count + 1
	if(#str > 43) then
		table.insert(self.Lines.list, string.sub(str, 1, 40).."-")
		table.insert(self.Lines.list, string.sub(str, 41, #str))
	else
		table.insert(self.Lines.list, str)
	end
end

function ENT:Enter(text)
	self:AddString(self.User.."@router:"..(self.User == "root" && "/" || "~").."$ "..text)
	local expl = string.Explode(" ", text)
	local cmd = expl[1]
	local arg = expl[2] || ""

	if(isfunction(self.CommandsFuncs[cmd])) then
		self.CommandsFuncs[cmd](self, arg)
	else
		self:AddString("Unknown command: "..cmd)
	end
	self.Current = ""
	if(#self.Lines.show > 14) then
		self.Scroll = self.Scroll + 3
	end
end