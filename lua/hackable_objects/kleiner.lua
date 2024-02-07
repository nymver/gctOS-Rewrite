
local Object = {}
Object.Type = 2
Object.Name = "Kleiner"
Object.Description2 = ""
Object.Model = "any"
Object.Class = "npc_kleiner"
Object.MaxHacks = 0
Object.Hacks = {{}, {}, {}, {}}

Object.Init = function(ent)
	ent.Profiler.IColor = Color(0, 0, 0, 255)
	ent.Profiler.Name = "Kleiner, Isaac"
	ent.Profiler.Description = "NO RECORD"
	ent.Profiler.Description2 = ""
	ent.Profiler.Icon = "citizens/glitch.png"
	ent.Profiler.Info1 = "Resistance Member"
	ent.Profiler.Info2 = "Income: $64,000"
	ent.Profiler.Color = Color(247, 104, 2)
	ent.Profiler.Emotion = ""
end

gctOS.AddObject(Object)
