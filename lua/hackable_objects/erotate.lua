-- Server

local Object = {}
Object.Type = 1
Object.Name = "ERotate"
Object.Description2 = "Hackable object"
Object.Model = "any"
Object.Class = "gctos_erotate"
Object.MaxHacks = 1
Object.NoProfiler = true
Object.Hacks = {
	{Cost = 0, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to get"}, 
	{}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		ent:SetNWInt("gctOS_PAngle", ent:GetNWInt("gctOS_PAngle")+90)
		ent:SetNWInt("gctOS_PState", ent:GetNWInt("gctOS_PState")+1)
		if(ent:GetNWInt("gctOS_PState")>4) then ent:SetNWInt("gctOS_PState", 1) end
	end
end


gctOS.AddObject(Object)