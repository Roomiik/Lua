local memory = require 'memory'
local font_flag = require('moonloader').font_flag
local font = renderCreateFont('Calibri', 12) -- ����������� ����� � ����������� ������
local notify_timeopen = {}
local notify_timeclose = {}
local notify_text = {}

local notify_x_size
local notify_x_pos
local notify_y_pos

function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
	local radar_x_left = memory.getfloat(memory.getuint32(0x58A79B, true), true)
	local radar_y = memory.getfloat(memory.getuint32(0x58A7C7, true), true)
	radar_x_left, radar_y = convertGameScreenCoordsToWindowScreenCoords(radar_x_left, radar_y)
	radar_y = select(2, getScreenResolution()) - radar_y
	local radar_x_right = memory.getfloat(memory.getuint32(0x58A79B, true), true) + memory.getfloat(memory.getuint32(0x5834C2, true), true)
	radar_x_right, _ = convertGameScreenCoordsToWindowScreenCoords(radar_x_right, radar_y)
	notify_x_size = radar_x_right - radar_x_left
	notify_x_pos = radar_x_left
	notify_y_pos = radar_y + 20 - 30 -- 20 � ���������� ����� ��������� �������������; 30 � ������ ����������� ��� �������
  while not isSampAvailable() do wait(0) end
	while true do
		wait(0)
		DrawRender()
	end
end

function EXPORTS.addNotification(text, time)
	notify_timeopen[#notify_timeopen + 1] = os.clock()
	notify_timeclose[#notify_timeclose + 1] = os.clock() + time
	notify_text[#notify_text + 1] = text
end

function DrawRender()
	local y_pos = notify_y_pos -- ��������� ������������ ����������
	local i = 1
	while i <= #notify_text do
		local show_notify = true -- ���� �� �������� �����������?
		local x_pos = notify_x_pos -- ���������� �� ������������
		local str = 0 -- ���������� ����� � �����������
		local last_symb = 0
		local prelast_symb = 1
		local text_len = {} -- ������ ����� ������ � ��������
		while last_symb ~= nil do
			last_symb = notify_text[i]:find('\n', last_symb + 1)
			local ourstr = ''
			if last_symb ~= nil then -- ������� ������ �� ���������� �������� ������
				ourstr = notify_text[i]:sub(prelast_symb, last_symb - 1)
				prelast_symb = last_symb + 1
			else
				ourstr = notify_text[i]:sub(prelast_symb, notify_text[i]:len())
			end
			text_len[#text_len + 1] = renderGetFontDrawTextLength(font, ourstr) -- ������� ����� ������
			str = str + 1
		end
		local y_size = 20 + str * renderGetFontDrawHeight(font) + 3 * (str - 1) -- 20 � ������ "��������" (�� ������ + ����� ������), 3 � ���. ������ (������ ����� ��������)
		local timerdur = os.clock() - notify_timeopen[i] -- ����� � ������� ���������� �����������
		if timerdur < 0.3 then -- 0.3 � ����� "�����������" (�������� �������� ������)
			x_pos = timerdur / 0.3 * (notify_x_pos + notify_x_size) - notify_x_size
		else
			timerdur = notify_timeclose[i] - os.clock() -- ����� �� ����������
			if timerdur > 0 and timerdur < 0.3 then -- 0.3 � ����� "���������" (�������� �����)
				x_pos = timerdur / 0.3 * (notify_x_pos + notify_x_size) - notify_x_size
			elseif timerdur > -0.2 and timerdur <= 0 then -- ������� ����������� �������� ����. 0.2 � ����� ���������
				local new_y_pos = y_pos - y_size - 20 -- 20 � ���������� ����� ��������� �������������
				y_pos = new_y_pos - timerdur / 0.2 * (y_pos - new_y_pos)
				show_notify = false -- �������, ��� ����������� ���������� ��� �� ����
			elseif timerdur <= -0.2 then -- ����������� ��������. �������. 0.2 � ����� ���������
				show_notify = false -- �������, ��� ����������� ���������� ��� �� ����
				table.remove(notify_timeopen, i)
				table.remove(notify_timeclose, i)
				table.remove(notify_text, i)
				i = i - 1
			end
		end
		if show_notify then
			y_pos = y_pos - y_size - 20 -- 20 � ���������� ����� ��������� �������������
			renderDrawCircleBox(notify_x_size, y_size, x_pos, y_pos, 8, 0x0D0000000) -- 8 � ������ �����������
			local text_y = y_pos + 10 -- 10 � ������ "�������" �� ������
			last_symb = 1
			local tcolor = 0xFFFFFF -- ������� ����
			local u = 1
			local text_x = x_pos + (notify_x_size - text_len[u]) / 2 -- ������� ������ �� X ����������
			local current_str_st = 1 -- ������ ������� ������ (�� �������� / �� ���������� �����)
			while last_symb <= notify_text[i]:len() do
				if last_symb == notify_text[i]:len() then -- ���� ��������� ������
					local current_str = notify_text[i]:sub(current_str_st, last_symb)
					renderFontDrawText(font, current_str, text_x, text_y, 0xFF000000 + tcolor, true) -- ������ ������ ������ �����������
				elseif notify_text[i]:sub(last_symb, last_symb) == '\n' then
					u = u + 1
					local current_str = notify_text[i]:sub(current_str_st, last_symb - 1)
					renderFontDrawText(font, current_str, text_x, text_y, 0xFF000000 + tcolor, true) -- ������ ������ ������ �����������
					current_str_st = last_symb + 1
					text_x = x_pos + (notify_x_size - text_len[u]) / 2
					text_y = text_y + (renderGetFontDrawHeight(font) + 3) -- 3 � ������ ����� ��������
				else -- ���� ������� ������ (�� ������� � �� ���������)
					local hex_color = true
					local hex_number = 0 -- ��� ����� ����
					if last_symb <= notify_text[i]:len() - 7 and notify_text[i]:sub(last_symb, last_symb) == '{' and notify_text[i]:sub(last_symb + 7, last_symb + 7) == '}' then -- ���� ������: {......}
						local symbs = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' }
						local symbs2 = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' }
						for k = last_symb + 1, last_symb + 6 do -- ������� ��� 6 ���������� (����� ����������) ��������
							local correct_symb = false
							for numb, hex_symb in pairs(symbs) do -- ������� ��� ����� HEX �������
								if notify_text[i]:sub(k, k) == hex_symb or notify_text[i]:sub(k, k) == symbs2[numb] then
									correct_symb = true
									hex_number = hex_number * 0x10 + (numb - 1)
									break
								end
							end
							if not correct_symb then -- ���� ����������� ������, �� ���������� �� ����� � �� �������� ��������
								hex_color = false
								break
							end
						end
					else
						hex_color = false -- �������, ��� ���� ��������� �����
					end
					if hex_color then
						local current_str = notify_text[i]:sub(current_str_st, last_symb - 1) -- ���������� "�������" ������
						renderFontDrawText(font, current_str, text_x, text_y, 0xFF000000 + tcolor, true) -- ������ ������ ������ �����������
						text_x = text_x + renderGetFontDrawTextLength(font, current_str)
						last_symb = last_symb + 7 -- ��� �������� {......} �������
						current_str_st = last_symb + 1
						tcolor = hex_number
					end
				end
				last_symb = last_symb + 1
			end
		end
		i = i + 1
  end
end

function renderDrawCircleBox(sizex, sizey, posx, posy, radius, color)
	sizex = sizex - 2 * radius
	sizey = sizey - 2 * radius
	posx = posx + radius
	posy = posy + radius
	renderDrawBox(posx - radius, posy, radius, sizey, color)
	renderDrawBox(posx + sizex, posy, radius, sizey, color)
	renderDrawBox(posx, posy - radius, sizex, sizey + 2 * radius, color)
	for i = posx + sizex, posx + sizex + radius - 1 do
		local dist = math.sqrt(radius * radius - (i - (posx + sizex)) * (i - (posx + sizex)))
		renderDrawBox(i, posy - dist, 1, dist, color)
	end
	for i = posx - radius, posx - 1 do
		local dist = math.sqrt(radius * radius - (i - (posx - 1)) * (i - (posx - 1)))
		renderDrawBox(i, posy - dist, 1, dist, color)
	end
	for i = posx + sizex, posx + sizex + radius - 1 do
		local dist = math.sqrt(radius * radius - (i - (posx + sizex)) * (i - (posx + sizex)))
		renderDrawBox(i, posy + sizey, 1, dist, color)
	end
	for i = posx - radius, posx - 1 do
		local dist = math.sqrt(radius * radius - (i - (posx - 1)) * (i - (posx - 1)))
		renderDrawBox(i, posy + sizey, 1, dist, color)
	end
end
