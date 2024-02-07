-- Player

if(game.SinglePlayer()) then
	local Object = {}
	Object.Type = 2
	Object.Name = ""
	Object.Description2 = ""
	Object.Model = "any"
	Object.Class = "player"
	Object.MaxHacks = 0
	Object.Hacks = {{}, {}, {}, {}}

	Object.Init = function(ent)
		ent.Profiler.IColor = Color(0, 0, 0, 255)
		ent.Profiler.Name = "Scan Error, Error"
		ent.Profiler.Description = "NO RECORD"
		ent.Profiler.Description2 = ""
		ent.Profiler.Icon = "citizens/glitch.png"
		ent.Profiler.Info1 = "Scan Error"
		ent.Profiler.Info2 = "Scan Error"
		ent.Profiler.Color = Color(200, 200, 200)
		ent.Profiler.Emotion = ""
	end

	gctOS.AddObject(Object)
else
	local Object = {}
	Object.Type = 2
	Object.Name = ""
	Object.Description2 = ""
	Object.Model = "any"
	Object.Class = "player"
	Object.MaxHacks = 0
	Object.Hacks = {{}, {}, {}, {}}

	Object.Init = function(ent)
		ent.Profiler.IColor = Color(0, 0, 0, 255)
		ent.Profiler.Name = ent:GetName()
		ent.Profiler.Description = "DedSec Member"
		ent.Profiler.Description2 = ""
		ent.Profiler.Icon = "data/avatars/"..(ent:SteamID64() && ent:SteamID64() || -1)..".jpg"
		ent.Profiler.Info1 = ""
		ent.Profiler.Info2 = ent:SteamID()
		ent.Profiler.Color = Color(85, 85, 180)
		gctOS.PFuncs.SetType2(ent, ent.Profiler)
	end

	gctOS.AddObject(Object)
end