-- Vending Machine

local Object = {}
Object.Type = 1
Object.Name = "Vending Machine"
Object.Description2 = "Hackable object"
Object.Model = "models/props_interiors/VendingMachineSoda01a.mdl"
Object.Class = "prop_physics"
Object.MaxHacks = 1
Object.Hacks = {
	{Cost = 1, Available = true, Used = false, Icon = "hack_power.png", Description = "Hack to drop off soda cans"}, 
	{}, 
	{}, 
	{}
}
Object.Hacks[1].Hack = function(ply, ent)
	if(SERVER) then
		gctOS.SetHackUsed(ent, 1, true)
		for i = 1, math.random(2, 6) do
			timer.Simple(i/2,function()
				local can = ents.Create("prop_physics") 
				can:SetPos(ent:GetPos()+ent:GetAngles():Forward()*17+ent:GetAngles():Up()*-28)
				can:SetModel(Model("models/props_junk/PopCan01a.mdl"))
				can:SetVelocity(ent:GetVelocity())
				can:SetOwner(ply)
				can:SetAngles(Angle(90,ent:GetAngles().yaw+90,0))
				can:Spawn() 
				can:SetSkin(math.random(0, 2))
			end)
		end
	end
end

gctOS.AddObject(Object)