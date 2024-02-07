-- Companion Doll

local Object = {}
Object.Type = 1
Object.Name = "Companion Doll"
Object.Description2 = "Hackable object"
Object.Model = "models/maxofs2d/companion_doll.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 1, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to play sound"}, 
	{},
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		PrintTable(file.Find("sound/radio/*", "WAV"))
		for i = 1, 4 do
			timer.Simple(i, function()
				ent:SetColor(Color(255, 255 - booltonumber(i%2 > 0)*255, 255 - booltonumber(i%2 > 0)*255))
			end)
		end
	end
end

gctOS.AddObject(Object)