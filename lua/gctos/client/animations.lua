-- [[ FOG IS COMING]] --








































--[[
	gctOS Rewrite
	
	Animations
]]

animations = {["ProfilerOnOff"] = 1, ["cast_cooldown"] = 1, ["FastApp"] = 1, ["LineGlitch"] = 0, ["HackMenu"] = 1, ["Hack1"] = 0, ["Hack2"] = 0, ["Hack3"] = 0, ["Hack4"] = 0, ["Lines"] = 0, ["Hack"] = 0, ["ProfilerStart1"] = 1, ["ProfilerStart2"] = 0, ["ProfilerStart3"] = 0, ["BotnetDrain"] = 0, ["NetHack"] = 1, ["NetHack_HLines"] = 1, ["NT"] = 1, ["HHack1"] = 0, ["HHack2"] = 0, ["HHack3"] = 0, ["HHack4"] = 0}
animations_count = {}

function runAnim(anim, del, m, func)
	if(!m) then m = false end
	if(animations[anim] == nil) then animations[anim] = 0 end
	local isf = isfunction(func)
	animations_count[anim] = animations_count[anim] && animations_count[anim] + 1 || 1
	for i = 1, 1000 do
		timer.Simple(i/(1000/del), function() 
			if(m==false) then animations[anim] = i/1000 else animations[anim] = 1 - i/1000 end
			if(isf) then func(i/1000) end
		end)
	end
	return animations_count[anim]
end

function setAnim(anim, v)
	if(animations[anim] == nil) then animations[anim] = v end
	animations[anim] = v
end

function checkAnim(anim)
	animation = animations[anim]
	return ((animation==0 || animation==1 || animation==nil) && true || false)
end

function getAnim(anim)
	return animations[anim] || 0
end

function countAnim(anim)
	return animations_count[anim]
end

function runAnimLerp(anim, del, sval, eval)
	animations[anim] = sval
	hook.Add("Think", "Animation_"..anim, function() 
		animations[anim] = Lerp(del, animations[anim], eval)
		if(animations[anim] == eval + (eval > 0 && -0.00001 || 0.00001)) then
			hook.Remove("Think", "Animation_"..anim)
		end
	end)
end