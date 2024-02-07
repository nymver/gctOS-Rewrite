-- [[ FOG IS COMING]] --








































gctOS.VGUI = {}

gctOS.VGUI.Label = function(text, x, y, parent, color, font)
	color = color || Color(255, 255, 255)
	font = font || "DermaDefault"
	if(isstring(text)) then
		local expl = string.Explode("\n", text)
		local labels = {}
		for k, v in pairs(expl) do
			local label = parent:Add('DLabel')
			label:SetPos(x, y + (k-1) * 14)
			label:SetText(v)
			label:SetFont(font)
			label:SetTextColor(color)
			label:SizeToContents()
			table.insert(labels, label)
		end
		return labels
	else
		local labels = {}
		local length = 0
		local yoff = 0
		local colors = Color(255, 255, 255)
		for k, v in pairs(text) do
			local typet = type(v)
			if(typet == "string") then
				local expl = string.Explode("\n", v)
				local count = 0
				for k1, v1 in pairs(expl) do
					count = count + 1
					yoff = yoff + (k1 - 1)
					local label = parent:Add('DLabel')
					label:SetPos(x + length, y + yoff * 16)
					label:SetText(v1)
					label:SetFont(font)
					label:SetTextColor(colors)
					label:SizeToContents()
					table.insert(labels, label)
				end
				surface.SetFont("DermaDefault")
				length = length + surface.GetTextSize(v)
				if(count > 1) then length = 0 end
			elseif(typet == "table") then
				colors = v
			elseif(typet == "IMaterial") then
				local img = gctOS.VGUI.Image(v, x+length+2, y-5+yoff*16+3, 16, 16, parent, colors)[1]
				length = length + 21
				table.insert(labels, img)
			end
		end
		return labels
	end
end

gctOS.VGUI.Image = function(mat, x, y, w, h, parent, color)
	color = color || Color(255, 255, 255)
	local img = parent:Add("DPanel")
	img:SetPos(x, y)
	img:SetSize(w, h)
	img.Paint = function(pnl, w, h)
		surface.SetDrawColor(color)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	return {img}
end

gctOS.VGUI.Circle = function(x, y, r, parent, color)
	local pnl = parent:Add("DPanel")
	pnl:SetPos(x, y+r)
	pnl:SetSize(r*2, r*2)
	pnl.Paint = function(p, w, h)
		draw.NoTexture()
		surface.SetDrawColor(color)
		draw.Circle(r, r, r, 360)
	end
end

gctOS.VGUI.Button = function(x, y, w, h, text, parent)
	local button = parent:Add("DButton")
	button:SetPos(x, y)
	button:SetSize(w, h)
	button:SetText("")
	button.Paint = function(p, w, h)
		surface.SetDrawColor(32, 32, 32)
		surface.DrawRect(0, 0, w, h)
		local ish = booltonumber(button:IsHovered())
		surface.SetDrawColor(255-255*ish, 255-75*ish, 255)
		surface.DrawRect(0, 0, 1, h)
		surface.DrawRect(0, h-1, w, 1)
		surface.DrawRect(w-1, 0, 1, h)
		surface.DrawRect(0, 0, w, 1)
		draw.SimpleText(text, "Profiler_Name", w/2, h/2, Color(255-255*ish, 255-75*ish, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	return button
end