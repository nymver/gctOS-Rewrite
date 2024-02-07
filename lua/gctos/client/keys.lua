-- [[ FOG IS COMING]] --








































--[[
	gctOS Rewrite
	Keys
]]

keys = {}
for i = 1, 113 do
	keys[i] = false
end

keys_names = 
{
[1] = "0",
[2] = "1",
[3] = "2",
[4] = "3",
[5] = "4",
[6] = "5",
[7] = "6",
[8] = "7",
[9] = "8",
[10] = "9",
[11] = "A",
[12] = "B",
[13] = "C",
[14] = "D",
[15] = "E",
[16] = "F",
[17] = "G",
[18] = "H",
[19] = "I",
[20] = "J",
[21] = "K",
[22] = "L",
[23] = "M",
[24] = "N",
[25] = "O",
[26] = "P",
[27] = "Q",
[28] = "R",
[29] = "S",
[30] = "T",
[31] = "U",
[32] = "V",
[33] = "W",
[34] = "X",
[35] = "Y",
[36] = "Z",
[37] = "INSERT",
[38] = "KP_END",
[39] = "KP_DOWNARROW",
[40] = "KP_PGDN",
[41] = "KP_LEFTARROW",
[42] = "KP_5",
[43] = "KP_RIGHTARROW",
[44] = "KP_HOME",
[45] = "KP_UPARROW",
[46] = "KP_PGUP",
[47] = "KP_SLASH",
[48] = "KP_MULTIPLY",
[49] = "KP_MINUS",
[50] = "KP_PLUS",
[51] = "KP_ENTER",
[52] = "DELETE",
[53] = "[",
[54] = "]",
[55] = "SEMICOLON",
[56] = "'",
[57] = "`",
[58] = ",",
[59] = ".",
[60] = "/",
[61] = "\\",
[62] = "-",
[63] = "=",
[64] = "ENTER",
[65] = "SPACE",
[66] = "BACKSPACE",
[67] = "TAB",
[68] = "CAPSLOCK",
[69] = "NUMLOCK",
[70] = "ESCAPE",
[71] = "SCROLLLOCK",
[72] = "INSERT",
[73] = "DELETE",
[74] = "HOME",
[75] = "END",
[76] = "PGUP",
[77] = "PGDN",
[78] = "PAUSE",
[79] = "SHIFT",
[80] = "RSHIFT",
[81] = "ALT",
[82] = "ALT",
[83] = "CTRL",
[84] = "CTRL",
[85] = "LWIN",
[86] = "RWIN",
[87] = "APP",
[88] = "ARROWUP",
[89] = "ARROWLEFT",
[90] = "ARROWDOWN",
[91] = "ARROWRIGHT",
[92] = "F1",
[93] = "F2",
[94] = "F3",
[95] = "F4",
[96] = "F5",
[97] = "F6",
[98] = "F7",
[99] = "F8",
[100] = "F9",
[101] = "F10",
[102] = "F11",
[103] = "F12",
[104] = "CAPSLOCK",
[105] = "NUMLOCK",
[106] = "SCROLLLOCK",
[107] = "MOUSE_LEFT",
[108] = "MOUSE_RIGHT",
[109] = "MOUSE_MIDDLE",
[110] = "MOUSE4",
[111] = "MOUSE5",
[112] = "MWHEELUP",
[113] = "MWHEELDOWN"
}

function GetKeyPic(key)
	return string.lower("keys/"..keys_names[key]..".png")
end

hook.Add("Think", "gctOS_KeyHandler_Press", function() 
	if(GetConVar("cl_gctos_enableaddon"):GetInt() == 1) then
		for i = 0, 113 do
			local temp = keys[i]
			keys[i] = (i >= 107 && input.IsMouseDown(i) || input.IsKeyDown(i))
			if(temp != keys[i] && temp==false) then
				hook.Run("gctOS_KeyHandler", i)
			end
		end
	end
end)