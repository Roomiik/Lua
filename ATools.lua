require "lib.moonloader"
require "lib.sampfuncs"
local keys = require "vkeys"
local sampev = require 'lib.moonloader'
require "lib.sampfuncs"
local q = require 'lib.samp.events'
local imgui = require "imgui"
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8
local main_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)
local render = require 'lib.render'
local myrender = render.create()
local MyCheck = false
local mod = import 'moonloader\\lib\\lib_imgui_notf.lua'
local text = renderCreateFont('Tahoma', 10, 5)
local sw, sh = getScreenResolution()
local mouseCoordinates = false
local inicfg = require 'inicfg'
local directIni = "moonloader\\setting.ini"
local mainIni = inicfg.load(nil, directIni)
local themes = import "lib/resource/imgui_themes.lua"
local dostup = false
local dowl = false
local imadd = require 'imgui_addons'
local mem = require "memory"
local ffi = require "ffi"
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local activation = mainIni.config.Vehicle
requests = require('requests')

--Auto Update
update_state = false
local dlstatus = require("moonloader").download_status
local script_vers = 2
local script_vers_text = "1.02"
local update_url = "https://raw.githubusercontent.com/Roomiik/Lua/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"
local script_url = "https://raw.githubusercontent.com/Roomiik/Lua/main/atools.luac?raw=true"
local script_patch = thisScript().patch
--Auto Update


imgui.BufferingBar = require('imgui_addons').BufferingBar
imgui.ToggleButton = require('imgui_addons').ToggleButton

toggle_status_nametag = imgui.ImBool(mainIni.config.NameTag)
toggle_status_vehicle = imgui.ImBool(mainIni.config.Vehicle)

colours = {
    -- The existing colours from San Andreas
    "0x080808FF", "0xF5F5F5FF", "0x2A77A1FF", "0x840410FF", "0x263739FF", "0x86446EFF", "0xD78E10FF", "0x4C75B7FF", "0xBDBEC6FF", "0x5E7072FF",
    "0x46597AFF", "0x656A79FF", "0x5D7E8DFF", "0x58595AFF", "0xD6DAD6FF", "0x9CA1A3FF", "0x335F3FFF", "0x730E1AFF", "0x7B0A2AFF", "0x9F9D94FF",
    "0x3B4E78FF", "0x732E3EFF", "0x691E3BFF", "0x96918CFF", "0x515459FF", "0x3F3E45FF", "0xA5A9A7FF", "0x635C5AFF", "0x3D4A68FF", "0x979592FF",
    "0x421F21FF", "0x5F272BFF", "0x8494ABFF", "0x767B7CFF", "0x646464FF", "0x5A5752FF", "0x252527FF", "0x2D3A35FF", "0x93A396FF", "0x6D7A88FF",
    "0x221918FF", "0x6F675FFF", "0x7C1C2AFF", "0x5F0A15FF", "0x193826FF", "0x5D1B20FF", "0x9D9872FF", "0x7A7560FF", "0x989586FF", "0xADB0B0FF",
    "0x848988FF", "0x304F45FF", "0x4D6268FF", "0x162248FF", "0x272F4BFF", "0x7D6256FF", "0x9EA4ABFF", "0x9C8D71FF", "0x6D1822FF", "0x4E6881FF",
    "0x9C9C98FF", "0x917347FF", "0x661C26FF", "0x949D9FFF", "0xA4A7A5FF", "0x8E8C46FF", "0x341A1EFF", "0x6A7A8CFF", "0xAAAD8EFF", "0xAB988FFF",
    "0x851F2EFF", "0x6F8297FF", "0x585853FF", "0x9AA790FF", "0x601A23FF", "0x20202CFF", "0xA4A096FF", "0xAA9D84FF", "0x78222BFF", "0x0E316DFF",
    "0x722A3FFF", "0x7B715EFF", "0x741D28FF", "0x1E2E32FF", "0x4D322FFF", "0x7C1B44FF", "0x2E5B20FF", "0x395A83FF", "0x6D2837FF", "0xA7A28FFF",
    "0xAFB1B1FF", "0x364155FF", "0x6D6C6EFF", "0x0F6A89FF", "0x204B6BFF", "0x2B3E57FF", "0x9B9F9DFF", "0x6C8495FF", "0x4D8495FF", "0xAE9B7FFF",
    "0x406C8FFF", "0x1F253BFF", "0xAB9276FF", "0x134573FF", "0x96816CFF", "0x64686AFF", "0x105082FF", "0xA19983FF", "0x385694FF", "0x525661FF",
    "0x7F6956FF", "0x8C929AFF", "0x596E87FF", "0x473532FF", "0x44624FFF", "0x730A27FF", "0x223457FF", "0x640D1BFF", "0xA3ADC6FF", "0x695853FF",
    "0x9B8B80FF", "0x620B1CFF", "0x5B5D5EFF", "0x624428FF", "0x731827FF", "0x1B376DFF", "0xEC6AAEFF", "0x000000FF",
    -- SA-MP extended colours (0.3x)
    "0x177517FF", "0x210606FF", "0x125478FF", "0x452A0DFF", "0x571E1EFF", "0x010701FF", "0x25225AFF", "0x2C89AAFF", "0x8A4DBDFF", "0x35963AFF",
    "0xB7B7B7FF", "0x464C8DFF", "0x84888CFF", "0x817867FF", "0x817A26FF", "0x6A506FFF", "0x583E6FFF", "0x8CB972FF", "0x824F78FF", "0x6D276AFF",
    "0x1E1D13FF", "0x1E1306FF", "0x1F2518FF", "0x2C4531FF", "0x1E4C99FF", "0x2E5F43FF", "0x1E9948FF", "0x1E9999FF", "0x999976FF", "0x7C8499FF",
    "0x992E1EFF", "0x2C1E08FF", "0x142407FF", "0x993E4DFF", "0x1E4C99FF", "0x198181FF", "0x1A292AFF", "0x16616FFF", "0x1B6687FF", "0x6C3F99FF",
    "0x481A0EFF", "0x7A7399FF", "0x746D99FF", "0x53387EFF", "0x222407FF", "0x3E190CFF", "0x46210EFF", "0x991E1EFF", "0x8D4C8DFF", "0x805B80FF",
    "0x7B3E7EFF", "0x3C1737FF", "0x733517FF", "0x781818FF", "0x83341AFF", "0x8E2F1CFF", "0x7E3E53FF", "0x7C6D7CFF", "0x020C02FF", "0x072407FF",
    "0x163012FF", "0x16301BFF", "0x642B4FFF", "0x368452FF", "0x999590FF", "0x818D96FF", "0x99991EFF", "0x7F994CFF", "0x839292FF", "0x788222FF",
    "0x2B3C99FF", "0x3A3A0BFF", "0x8A794EFF", "0x0E1F49FF", "0x15371CFF", "0x15273AFF", "0x375775FF", "0x060820FF", "0x071326FF", "0x20394BFF",
    "0x2C5089FF", "0x15426CFF", "0x103250FF", "0x241663FF", "0x692015FF", "0x8C8D94FF", "0x516013FF", "0x090F02FF", "0x8C573AFF", "0x52888EFF",
    "0x995C52FF", "0x99581EFF", "0x993A63FF", "0x998F4EFF", "0x99311EFF", "0x0D1842FF", "0x521E1EFF", "0x42420DFF", "0x4C991EFF", "0x082A1DFF",
    "0x96821DFF", "0x197F19FF", "0x3B141FFF", "0x745217FF", "0x893F8DFF", "0x7E1A6CFF", "0x0B370BFF", "0x27450DFF", "0x071F24FF", "0x784573FF",
    "0x8A653AFF", "0x732617FF", "0x319490FF", "0x56941DFF", "0x59163DFF", "0x1B8A2FFF", "0x38160BFF", "0x041804FF", "0x355D8EFF", "0x2E3F5BFF",
    "0x561A28FF", "0x4E0E27FF", "0x706C67FF", "0x3B3E42FF", "0x2E2D33FF", "0x7B7E7DFF", "0x4A4442FF", "0x28344EFF"
    }
    
    function getBodyPartCoordinates(id, handle)
      local pedptr = getCharPointer(handle)
      local vec = ffi.new("float[3]")
      getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
      return vec[0], vec[1], vec[2]
    end
    
    lua_thread.create(function()
        font = renderCreateFont("Roboto", 9, 5)
        font2 = renderCreateFont("Roboto", 11, 5)
        while true do
        wait(0)
        if activation then
    
        for _, handle in ipairs(getAllVehicles()) do
            if handle ~= mycar and doesVehicleExist(handle) and isCarOnScreen(handle) then
                  vehName = getGxtText(getNameOfVehicleModel(getCarModel(handle)))
                      myX, myY, myZ = getBodyPartCoordinates(8, PLAYER_PED)
                      X, Y, Z = getCarCoordinates(handle)
                      result, point = processLineOfSight(myX, myY, myZ, X, Y, Z, true, false, false, true, false, false, false, false)
                      if not result then
                          distance = getDistanceBetweenCoords3d(X, Y, Z, myX, myY, myZ)
                          X, Y = convert3DCoordsToScreen(X, Y, Z)
                  _, id = sampGetVehicleIdByCarHandle(handle)
                                local primaryColor, secondaryColor = getCarColours(handle)
                                local vhp = getCarHealth(handle)
                                color = colours[primaryColor + 1]
                                color = color:gsub("0x(.*)", "%1")
                                color = color:sub(1, -3)
                          renderFontDrawText(font, vehName .. "[".. id .."]\nHP: "..vhp, X, Y, 0xFFFFFFFF)
                      end
              end
            end
    
        end
    
    end
end)

function getserial()
    local ffi = require("ffi")
    ffi.cdef[[
    int __stdcall GetVolumeInformationA(
    const char* lpRootPathName,
    char* lpVolumeNameBuffer,
    uint32_t nVolumeNameSize,
    uint32_t* lpVolumeSerialNumber,
    uint32_t* lpMaximumComponentLength,
    uint32_t* lpFileSystemFlags,
    char* lpFileSystemNameBuffer,
    uint32_t nFileSystemNameSize
    );
    ]]
    local serial = ffi.new("unsigned long[1]", 0)
    ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
    return serial[0]
end


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand("mouse", cmd_mouse)
    sampRegisterChatCommand("color", cmd_color)
    sampRegisterChatCommand("amenu", cmd_amenu)
    sampRegisterChatCommand("stream", cmd_stream)
    sampRegisterChatCommand("update", cmd_update)

    checkKey()
    
    --Auto Update
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("Åñòü îáíîâëåíèå! Âåðñèÿ: " .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    --The End Auto Update

    _, Myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    MyName = sampGetPlayerNickname(Myid)
    --Imgui
    imgui.Process = false
    imgui.SwitchContext()
    themes.SwitchColorTheme(4)
    --The End imgui

    if mainIni.config.Vehicle == true then
        activation = true
        else
            activation = false
    end

    while true do -- Áåñêîíå÷íûé öûêë.
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Ñêðèïò óñïåøíî îáíîâëåí!", -1)
                    thisScript():reload()
                end
            end)
            break

        --Imgui
        if main_window_state.v == false then
            imgui.Process = false
        end
        --The End ImGui

        for k = 0, sampGetMaxPlayerId(false) do
            local pColors = string.format('%06X', bitAnd(0xFFFFFF, sampGetPlayerColor(pId)))
                renderFontDrawText(text, "Èãðîêè îíëàéí:", 1269, 10, 0xFFFFFFFF)
                renderFontDrawText(text, "{"..pColors.."}"..sampGetPlayerNickname(k).."[".. k .."](LVL: "..sampGetPlayerScore(k)..")\n", 1269, 25+k*17, 0xFFFFFFFF)

            if isKeyJustPressed(VK_F2) then
                sampAddChatMessage("Âû óñïåøíî âûäàëè ñåáå 100 HP", 0xFF0011)
                sampSendChat("/hp "..Myid.." 100")
            end
            if isKeyJustPressed(VK_F3) then
                sampAddChatMessage("Âû óñïåøíî ïî÷åíèëè àâòî", 0xFF0011)
                sampSendChat("/fixcar "..Myid)
            end
        end
    end
end

function bitAnd(a, b)
    local result = 0
    local bitVal = 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
            result = result + bitVal      -- set the current bit
        end
        bitVal = bitVal * 2 -- shift left
        a = math.floor(a / 2) -- shift right
        b = math.floor(b / 2)
    end
    return result
end

function sampev.onPlayerJoin(id, clist, isNPC, nick)
    mod.addNotify("Èãðîê "..nick.."["..id.."] çàø¸ë â èãðó", 3) 
end

function sampev.onPlayerQuit(id, reason)
    nicks = sampGetPlayerNickname(id)
    if reasons == 0 then reas = "/q"end
    if reasons == 1 then reas = "Kick/Ban."end
    if reasons == 2 then reas = "TimedOut."end
    sampAddChatMessage("Èãðîê "..nicks.."["..id.."] âûøåë èç èãðû "..reas, 0xC3C3C3)
    --mod.addNotification("Èãðîê "..nicks.."["..id.."] âûøåë èç èãðû "..reas, 3) 
    
end

function cmd_mouse()
    if mouseCoordinates == false then
        sampToggleCursor(true)
        mouseX, mouseY = getCursorPos()
        sampAddChatMessage("X: "..mouseX.."||Y: "..mouseY, -1)
      end
end

function q.onServerMessage(color,text)
    if text:match("^%[A%]%s*(%S+)%[(%d+)%]:%s*/(.+)") then
        local nick, id, texts = text:match("^%[A%]%s*(%S+)%[(%d+)%]:%s*(.+)")
        mod.addNotify("{0xFF0069}Àäìèí ôîðìà îò: {FFFFFF}"..nick.."["..id.."]\n {FFFFFF}"..texts, 1, 1, 1, 5, 1) 
    else
    end
    
end

function cmd_color(arg) 
    local pColors = string.format('%06X', bitAnd(0xFFFFFF, sampGetPlayerColor(arg)))
    --sampAddChatMessage(pColors, -1)
    sampShowDialog(1317, "HEX Öâåòà îðãàíèçàöèé.", "Íàçâàíèå îðãàíèçàöèè.\tÖâåò\n{CCFF00}Ïðàâèòåëüñòâî\t0xCCFF00\n{996633}ÌÎ\t0x996633\n{FF6666}ÌÇ\t0xFF6666\n{FF6600}ÒÐÊ\t0xFF6600\n{0000FF}ÄÏÑ\t0x0000FF\n{0000FF}ÏÏÑ\t0x0000FF\n{0000FF}ÔÑÁ\t0x0000FF\n{009900}Öåíòðàëüíîå ÎÏÃ\t0x009900\n{6666FF}ÎÏÃ Ãîïîòà\t0x6666FF\n{FFCD00}Çàïàäíîå ÎÏÃ\t0xFFCD00", "Âûáðàòü", "Çàêðûòü", 4)
end

function imgui.OnDrawFrame()
    imgui.SetNextWindowSize(imgui.ImVec2(520, 250))
    imgui.SetNextWindowPos(imgui.ImVec2((sw / 2), sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))

    imgui.Begin("Setting Tools", main_window_state)
    imgui.Text(u8("Çäåñü âû ñìîæåòå íàñòðîèòü Atools"))
    --imgui.BufferingBar(0.2, imgui.ImVec2(200, 10), false)
    if activation_script then
    if imgui.ToggleButton("Name Tag", toggle_status_nametag) then
        mainIni.config.NameTag = toggle_status_nametag
        if toggle_status_nametag.v == true then
            mainIni.config.NameTag = true
            if inicfg.save(mainIni, directIni) then
                nameTagOn()
                sampAddChatMessage("{00ffb3}[A-Tools] {FFFFFF}Âû óñïåøíî âêëþ÷èëè NameTag", 0xFF0033)
            end

            else
                mainIni.config.NameTag = false
                if inicfg.save(mainIni, directIni) then
                    nameTagOff()
                    sampAddChatMessage("{00ffb3}[A-Tools] {FFFFFF}Âû óñïåøíî îòêëþ÷èëè NameTag", 0xFF0033)
                end
        end
    end
    imgui.SameLine()
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450.0)
        imgui.TextUnformatted(u8("Name Tag - Âèäèìîñòü íèêà è àéäè èãðîêà çà òåêñòóðàìè è íà áîëüøîé äèñòàíöèè."))
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end

    if imgui.ToggleButton("Vehicle info", toggle_status_vehicle) then

        if toggle_status_vehicle.v == true then
            mainIni.config.Vehicle = true
            if inicfg.save(mainIni, directIni) then
                activation = true
                sampAddChatMessage("{00ffb3}[A-Tools] {FFFFFF}Âû óñïåøíî âêëþ÷èëè Vehicle Info ", 0xFF0033)
            end

            else
                mainIni.config.Vehicle = false
                if inicfg.save(mainIni, directIni) then
                    activation = false
                    sampAddChatMessage("{00ffb3}[A-Tools] {FFFFFF}Âû óñïåøíî îòêëþ÷èëè Vehicle Info ", 0xFF0033)
                end
        end
     end
    imgui.SameLine()
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450.0)
        imgui.TextUnformatted(u8("Vehicle Info - Èíôîðìàöèÿ î àâòî â ðàäèóñå ñòðèìà, ïîêàçûâàåò ID, Name, HP"))
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end

    if imgui.ToggleButton("Vehicle info", toggle_status_vehicle) then

        if toggle_status_vehicle.v == true then
            mainIni.config.Vehicle = true
            if inicfg.save(mainIni, directIni) then
                activation = true
                sampAddChatMessage("{00ffb3}[A-Tools] {FFFFFF}Âû óñïåøíî âêëþ÷èëè Auto Login ", 0xFF0033)
            end

            else
                mainIni.config.Vehicle = false
                if inicfg.save(mainIni, directIni) then
                    activation = false
                    sampAddChatMessage("{00ffb3}[A-Tools] {FFFFFF}Âû óñïåøíî îòêëþ÷èëè Auto Login ", 0xFF0033)
                end
        end
     end
    imgui.SameLine()
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450.0)
        imgui.TextUnformatted(u8("Vehicle Info - Èíôîðìàöèÿ î àâòî â ðàäèóñå ñòðèìà, ïîêàçûâàåò ID, Name, HP"))
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end

else
    imgui.Text(u8("Ó âàñ çàêîí÷èëàñü/íå àêòèâèðîâàí ñêðèïò.\nÂàø ñåðèéíûé êëþ÷ü: "..getserial()))
end
imgui.End()
end

function cmd_amenu(arg)
    main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end

function nameTagOn()
	local pStSet = sampGetServerSettingsPtr()
	NTdist = mem.getfloat(pStSet + 39) -- äàëüíîñòü
	NTwalls = mem.getint8(pStSet + 47) -- âèäèìîñòü ÷åðåç ñòåíû
	NTshow = mem.getint8(pStSet + 56) -- âèäèìîñòü òåãîâ
	mem.setfloat(pStSet + 39, 1488.0)
	mem.setint8(pStSet + 47, 0)
	mem.setint8(pStSet + 56, 1)
end

function nameTagOff()
	local pStSet = sampGetServerSettingsPtr()
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
	mem.setint8(pStSet + 56, NTshow)
end


--- Events
function onExitScript()
	if NTdist then
		nameTagOff()
	end
end

function checkKey()
    response = requests.get('http://profile/script.php?code='..getserial())
    if not response.text:match("<body>(.*)</body>"):find("-1") then -- Åñëè êëþ÷ åñòü â áä
        if not response.text:match("<body>(.*)</body>"):find("The duration of the key has expired.") then -- Åñëè ñåðâåð íå îòâåòèë ÷òî êëþ÷ èñòåê.
            sampAddChatMessage("Äî îêîí÷àíèÿ ëèöåíçèè îñòàëîñü:"..response.text:match("<body>(.*)</body>"), -1) --  Âûâîäèì êîë-âî äíåé äî êîíöà ëèöåíçèè
            mod.addNotify("{0xFF0069}Ïðèâåñòâóþ òåáÿ {FFFFFF}\n {FF0069}Admin Tools Óñïåøíî {00ff77}ðàáîòàåò.", 1, 1, 1, 5, 1) 
            mod.addNotify("Äî îêîí÷àíèÿ ëèöåíçèè îñòàëîñü:"..response.text:match("<body>(.*)</body>"), 1, 1, 1, 5, 1)
            activation_script = true
        else
            activation_script = false
            sampAddChatMessage(response.text:match("Ñðîê äåéñòâèÿ ëèöåíçèè èñòåê."), -1)
        end
    else
        activation_script = false
        sampAddChatMessage("Êëþ÷ íå àêòèâèðîâàí.", -1)
    end
end

function q.onShowDialog(dialogId, style, title, button1, button2, text)
    if title:find("Àâòîðèçàöèÿ") then
        sampAddChatMessage(title, -1)
        sampSendDialogResponse(dialogId, 1, _, "123321")
    end
end

function cmd_stream()
    local data = {}
    for _, pHandle in pairs(getAllChars()) do
        local result, pId = sampGetPlayerIdByCharHandle(pHandle)
        if result then
            local pName = sampGetPlayerNickname(pId)
            local pColor = string.format('%06X', bitAnd(0xFFFFFF, sampGetPlayerColor(pId)))
            table.insert(data, string.format('{%s}%s [%d](LVL: %d)', pColor, pName, pId, sampGetPlayerScore(pId)))
        end
    end
    sampShowDialog(
        1337762,
        string.format('{43C7CF}Stream Info{AAAAAA} - %d player(s)', #data),
        table.concat(data, '\n'),
        'Close',
        '',
        DIALOG_STYLE_LIST
    )
end
