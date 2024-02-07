-- [[ FOG IS COMING]] --








































surface.CreateFont("Profiler_Name", {font = "HelveticaNeueCyr", size = 17, weight = 1000})
surface.CreateFont("Profiler2_Name", {font = "HelveticaNeueCyr", size = 17, weight = 1000})
surface.CreateFont("Smartphone", {font = "HelveticaNeueCyr", size = 15, weight = 1000})
surface.CreateFont("Profiler_Description", {font = "HelveticaNeueCyr-Bold", size = 18, weight = 1000})
surface.CreateFont("Profiler_Description3", {font = "HelveticaNeueCyr", size = 18, weight = 1000})
surface.CreateFont("Profiler_Description2", {font = "HelveticaNeueCyr", size = 18, weight = 1000})
surface.CreateFont("Profiler_Acquired", {font = "HelveticaNeueCyr", size = 18, weight = 1000})
surface.CreateFont("CameraFont", {font = "Calibri", size = 22, weight = 625})
surface.CreateFont("CameraFont2", {font = "Segoe UI Semibold", size = 20, weight = 480})
surface.CreateFont("Time", {font = "Segoe UI Semibold", size = 20, weight = 1000})
surface.CreateFont("KeyFont", {font = "Calibri Bold", size = 24, weight = 250})

surface.CreateFont("Router", {font = "Segoe UI", size = 28})
surface.CreateFont("RouterBig", {font = "Segoe UI", size = 48})
surface.CreateFont("RouterT", {font = "Segoe UI", size = 22})

local blurm = Material("pp/blurscreen")

function surface.DrawBlur(x, y, w, h, bpwr)
	surface.SetMaterial(blurm)
	surface.SetDrawColor(255, 255, 255, 255)
	render.SetScissorRect(x, y, w + x, h + y, true)
	for i = 0.33, 1, 0.33 do
		blurm:SetFloat("$blur", bpwr * i)
		blurm:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())	
	end
	render.SetScissorRect(0, 0, 0, 0, false)
end

function surface.DrawBlurTest(x, y, w, h, bpwr)
	surface.SetMaterial(blurm)
	surface.SetDrawColor(255, 255, 255, 255)
	for i = 0.33, 1, 0.33 do
		blurm:SetFloat("$blur", bpwr * i)
		blurm:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())	
	end
end

function draw.RoundedBox2(x, y, w, h, radius)
	local poly = {}
	table.insert(poly, {x = x+w, y = y-h-radius})
	table.insert(poly, {x = x+w+radius, y = y-h})
	table.insert(poly, {x = x+w+radius, y = y+h})
	table.insert(poly, {x = x+w, y = y+h+radius})
	table.insert(poly, {x = x-w, y = y+h+radius})
	table.insert(poly, {x = x-w-radius, y = y+h})
	table.insert(poly, {x = x-w-radius, y = y-h})
	table.insert(poly, {x = x-w, y = y-h-radius})
	surface.DrawPoly(poly)
	draw.Circle(x - w, y - h, radius, 360)
	draw.Circle(x - w, y + h, radius, 360)
	draw.Circle(x + w, y - h, radius, 360)
	draw.Circle(x + w, y + h, radius, 360)
end

function draw.RhombProgress(rx, ry, prog)
	render.SetStencilEnable(true)
	render.ClearStencil()
	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	cam.Start2D()	
	surface.SetDrawColor(0, 0, 0, 1)
	draw.CircleProgress(rx, ry, 36, 360, prog, 360)
	cam.End2D()
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	cam.Start2D()
	surface.SetDrawColor(200, 50, 0)
	surface.SetMaterial(Material("blank.png"))
	surface.DrawTexturedRectRotated(rx, ry, 38, 38, 45)
	cam.End2D()
	render.SetStencilEnable(false)
end


function draw.CircleProgress(x, y, radius, seg, prog, off)
	draw.NoTexture()
	local cir = {}
	table.insert(cir, {x = x, y = y})
	for i = 0, seg do
		local a = math.rad((i / seg) * -(360 * prog) - off)
		table.insert(cir, {x = x - math.sin(a) * radius, y = y - math.cos(a) * radius})
	end
	surface.DrawPoly(cir)
end

function draw.SimpleCircle(x, y, radius, color)
	draw.RoundedBox(radius*4, x-radius, y-radius, radius*2, radius*2, color)
end

function draw.Circle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {x = x, y = y, u = 0.5, v = 0.5})
	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})

	surface.DrawPoly(cir)
end

function surface.DrawBlurCircle(x, y, r, bpwr)
	render.SetStencilEnable(true)
	render.ClearStencil()
	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	cam.Start2D()
	surface.SetDrawColor(255, 255, 255, 1)
	draw.NoTexture()
	draw.Circle(x, y, r, 30)
	cam.End2D()
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	cam.Start2D()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blurm)
	for i = 1, 2 do
		blurm:SetFloat('$blur', (i / 3) * (bpwr))
		blurm:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
	cam.End2D()
	render.SetStencilEnable(false)
end

function surface.DrawBlurE(x, y, w, h, bpwr)
	render.SetStencilEnable(true)
	render.ClearStencil()
	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	cam.Start2D()
		surface.SetMaterial(Material("hmo.png"), "true")
		surface.SetDrawColor(255, 255, 255, 1)
		surface.DrawTexturedRect(x, y, w, h)
	cam.End2D()
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	cam.Start2D()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blurm)
	for i = 1, 2 do
		blurm:SetFloat('$blur', (i / 3) * (bpwr))
		blurm:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
	cam.End2D()
	render.SetStencilEnable(false)
end

function render.DrawBlur(position, angle, w, h, bpwr, x, y)
	render.SetStencilEnable(true)
	render.ClearStencil()
	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetColorMaterial()
	render.DrawQuadEasy(position, angle, w, h, Color(255, 255, 255, 0), 0)
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	cam.Start2D()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blurm)
	for i = 1, 2 do
		blurm:SetFloat('$blur', (i / 3) * (bpwr))
		blurm:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
	surface.DrawTexturedRect(x, y, w, h)
	cam.End2D()
	render.SetStencilEnable(false)
end

function surface.DrawTexturedRectCenter(x, y, w, h)
	surface.DrawTexturedRectRotated(x, y, w, h, 0)
end