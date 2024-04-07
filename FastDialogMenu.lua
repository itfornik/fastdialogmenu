script_name("Fast-Dialog-Menu")
script_authors("TFORNIK", "Rubin Mods", "Nearl Maklai")
script_version("1.1")

--=> LIBRARY <=--
local a,b=pcall(require,'json')local c=getWorkingDirectory and getWorkingDirectory()or''local d={encode=encodeJson or(a and b.encode or nil),decode=decodeJson or(a and b.decode or nil)}assert(d.encode and d.decode,'error, cannot use json encode/decode functions. Install JSON cfg: https://github.com/rxi/json.lua')local function e(f)local g=io.open(f,'r')if g~=nil then io.close(g)end;return g~=nil end;function Json(h,i)if not h:find('(.+)%.json$')then h=h..'.json'end;local j,k,l={},false,'UNKNOWN_ERROR'local function m(n,o)local function p(q)local r=type(q)if r~='string'then q=tostring(q)end;local s=q:find('^(%d+)')or q:find('(%p)')or q:find('\\')or q:find('%-')return s==nil and q or('[%s]'):format(r=='string'and"'"..q.."'"or q)end;local t={'{'}local o=o or 0;for q,u in pairs(n)do table.insert(t,('%s%s = %s,'):format(string.rep("    ",o+1),p(q),type(u)=="table"and m(u,o+1)or(type(u)=='string'and"'"..u.."'"or tostring(u))))end;table.insert(t,string.rep('    ',o)..'}')return table.concat(t,'\n')end;local function v(i,w)local x=0;for y,z in pairs(i)do if w[y]==nil then if type(z)=='table'then w[y]={}_,subFilledCount=v(z,w[y])x=x+subFilledCount else w[y]=z;x=x+1 end elseif type(z)=='table'and type(w[y])=='table'then _,subFilledCount=v(z,w[y])x=x+subFilledCount end end;return w,x end;local function A(B)local C=io.open(h,'w')if C then local D,E=pcall(d.encode,B)if D and E then C:write(E)end;C:close()end end;local function F()local C=io.open(h,'r')if C then local G=C:read('*a')C:close()local H,I=pcall(d.decode,G)if H and I then j=I;k=true;local J,x=v(i,j)if x>0 then A(J)return J end;return I else l='JSON_DECODE_FAILED_'..I end else l='JSON_FILE_OPEN_FAILED'end;return{}end;if not e(h)then A(i)end;j=F()return k,setmetatable({},{__call=function(self,K)if type(K)=='table'then j=K;A(j)end end,__index=function(self,y)return y and j[y]or j end,__newindex=function(self,y,L)j[y]=L;A(j)end,__tostring=function(self)return m(j)end,__pairs=function()local y,z=next(j)return function()y,z=next(j,y)return y,z end end,__concat=function()return d.encode(j)end}),k and'ok'or l end
local ffi = require("ffi")
local imgui = require('mimgui')
local MonetLua = require("MoonMonet")
local encoding = require("encoding")
local samp = require("lib.samp.events")
local hotkey = require('mimgui_hotkeys')
local faicons = require("fAwesome6")
local dlstatus = require('lib.moonloader').download_status

local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof
local language = {
    ["English"] = {
        initialize = "The script has been initialized. Menu: /fdm",
        info = "Information",
        text_is_empty = "The text is empty",
        new_dialog = "New dialog",
        new_button = "New button",
        create_dialog = "Create dialog",
        create_button = "Create button",
        delete_dialog = "Delete dialog",
        delete_button = "Delete button",
        title = "Name",
        text = "Text",
        title_dialog = "Dialog name",
        title_button = "Button name",
        alert = "Please enter the correct name for the dialog",
        save = "Save", 
        activate_dialog = "Activating the dialog",
        activate_on_command = "Activation on the command",
        open_dialog_on_command = "Opening a dialog for the command",
        activate_target = "Activation on target",
        open_target_on_command = "Opening a dialog on target",
        write_command = "Write you command",
        binder = {
            wait = "Delay. Specified in seconds",
            target_id = "The ID of the target player",
            target_nick = "The nickname of the target player",
            target_score = "The score of the target player",
            target_rp_nick = "Will return the RP nickname without _",
            local_text = "It will write the text locally, only you can see.",
            var = "Variables",
            vars = "Variables that can be used in the text",
            target_alert = "You have to target the player!",
            player_off_alert = "The player under ID %s is out of the game.",
            you_can_use_in_binder = "Patterns can be used in the binder:\n\n",
            name = "The name of the button/bind"
        },
        choice_language = "Language selection",
        style_theme = "Style",
        script_settings = "Script settings",
        settings = "Settings",
        config_not_deleted = "This config cannot be deleted.",
        config = {
            title = "Config",
            button_load = "Load",
            button_update = "Update",
            button_create = "Create",
            select = "Selected config:",
            button_delete = "Delete",
            loaded = "You have successfully uploaded the config: %s"
        },
        saving = {
            dialog_title = "The name of the dialog has been successfully saved.",
            command = "The command has been successfully saved. Usage: /%s [Player ID]",
            button_title = "The button name has been successfully saved.",
            text = "The text has been saved successfully."
        },
        warnings = {
            command = "Enter the correct command."
        },
        strings = {
            saved = "saved",
            not_saved = "not saved",
            delay_in_seconds = "Delay in seconds",
            on_click = "When clicked, a pop-up window opens where you can select the type of sending",
            saved_text = "Save the text so that you don't lose it",
            create_string = "Create a line",
            delete_string = "Delete a line"
        },
        empty = "Empty",
        waiting_key = "Waiting for the key",
        author_and_version = "Authors: %s | Version: %s",
        script_updated = "%s update found. The script is being updated!",
        script_wait = "The script is waiting for you to send the string.."
    },
    ["Russian"] = {
        initialize = "Скрипт инициализирован. Меню: /fdm",
        info = "Информация",
        text_is_empty = "Текст пустой",
        new_dialog = "Новый диалог",
        new_button = "Новая кнопка",
        create_dialog = "Создать диалог",
        create_button = "Создать кнопку",
        delete_dialog = "Удалить диалог",
        delete_button = "Удалить кнопку",
        title = "Название",
        text = "Текст",
        title_dialog = "Название диалога",
        title_button = "Название кнопки",
        alert = "Пожалуйста, введите корректное название для диалога",
        save = "Сохранить",
        activate_dialog = "Активация диалога",
        activate_on_command = "Активация на команду",
        open_dialog_on_command = "Открытие диалога на команду",
        activate_target = "Активация на таргет",
        open_target_on_command = "Открытие диалога на таргет",
        write_command = "Напишите свою команду",
        binder = {
            wait = "Задержка. Указывается в секундах",
            target_id = "ИД затаргеченного игрока",
            target_nick = "Ник затаргеченного игрока",
            target_score = "ЛВЛ затаргеченного игрока",
            target_rp_nick = "Вернёт РП ник игрока без _",
            local_text = "Напишет текст локально, видите только вы.",
            var = "Переменные",
            vars = "Переменные, которые можно использовать в тексте",
            target_alert = "Вы должны навестись на игрока!",
            player_off_alert = "Игрок под ID %s вышел из сети.",
            you_can_use_in_binder = "В биндере можно использовать паттерны:\n\n",
            name = "Название кнопки/бинда"
        },
        choice_language = "Выбор языка",
        style_theme = "Стиль",
        script_settings = "Настройки скрипта",
        settings = "Настройки",
        config_not_deleted = "Данный конфиг удалить нельзя.",
        config = {
            title = "Конфиг",
            button_load = "Загрузить",
            button_update = "Обновить",
            button_create = "Создать",
            select = "Загруженный конфиг:",
            button_delete = "Удалить",
            loaded = "Вы успешно загрузили конфиг: %s"
        },
        saving = {
            dialog_title = "Название диалога успешно сохранено.",
            command = "Команда успешно сохранена. Использование: /%s [ID игрока]",
            button_title = "Название кнопки успешно сохранено.",
            text = "Текст успешно сохранен."
        },
        warnings = {
            command = "Введите корректную команду."
        },
        strings = {
            saved = "Сохранён",
            not_saved = "Не сохранён",
            delay_in_seconds = "Задержка в секундах",
            on_click = "При нажатии откроется всплывающее окно, где можно выбрать тип отправки",
            saved_text = "Сохраните текст, чтобы его не потерять.",
            create_string = "Создать строку",
            delete_string = "Удалить строку"
        },
        empty = "Пусто",
        waiting_key = "Ожидание клавиши...",
        author_and_version = "Авторы: %s | Версия: %s",
        script_updated = "Найдено обновление %s. Скрипт обновляется!",
        script_wait = "Скрипт ожидает пока вы отправите строку.."
    },
    ["Ukrainian"] = {
        initialize = "Скрипт ініціалізовано. Меню: /fdm",
        info = "Інформація",
        text_is_empty = "Текст порожній",
        new_dialog = "Новий діалог",
        new_button = "Нова кнопка",
        create_dialog = "Створити діалог",
        create_button = "Створити кнопку",
        delete_dialog = "Видалити діалог",
        delete_button = "Видалити кнопку",
        title = "Назва",
        text = "Текст",
        title_dialog = "Назва діалогу",
        title_button = "Назва кнопки",
        alert = "Будь ласка, введіть коректну назву для діалогу",
        save = "Зберегти",
        activate_dialog = "Активація діалогу",
        activate_on_command = "Активація на команду",
        open_dialog_on_command = "Відкриття діалогу на команду",
        activate_target = "Активація на таргет",
        open_target_on_command = "Відкриття діалогу на таргет",
        write_command = "Напишіть свою команду",
        binder = {
            wait = "Затримка. Вказується в секундах",
            target_id = "ІД затаргеченного гравця",
            target_nick = "Нік затаргеченного гравця",
            target_score = "ЛВЛ затаргеченного гравця",
            target_rp_nick = "Поверне нік без _",
            local_text = "Напише текст локально, бачите тільки ви.",
            var = "Змінна",
            vars = "Змінні, які можна використовувати в тексті",
            target_alert = "Ви повинні навестися на гравця!",
            player_off_alert = "Гравець під ID %s вийшов з мережі.",
            you_can_use_in_binder = "У біндері можна використовувати патерни:\n\n",
            name = "Назва кнопки / бінда"
        },
        choice_language = "Вибір мови",
        style_theme = "Стиль",
        script_settings = "Налаштування скрипта",
        settings = "Настройка",
        config_not_deleted = "Даний конфіг видалити не можна",
        config = {
            title = "Конфіг",
            button_load = "Завантаживши",
            button_update = "Оновити",
            button_create = "Утворити",
            select = "Обраний конфіг:",
            button_delete = "Видалити",
            loaded = "Ви успішно завантажили конфігурацію: % s"
        },
        saving = {
            dialog_title = "Назва діалогу успішно збережено.",
            command = "Команда успішно збережена. Використання: / % s [ідентифікатор гравця]",
            button_title = "Назва кнопки успішно збережено.",
            text = "Текст успішно збережено."
        },
        warnings = {
            command = "Введіть коректну команду."
        },
        strings = {
            saved = "Зберігати",
            not_saved = "Не збережено",
            delay_in_seconds = "Затримка в секундах",
            on_click = "При натисканні відкриється спливаюче вікно, де можна вибрати тип відправки",
            saved_text = "Збережіть текст, щоб його не втратити",
            create_string = "Створити рядок",
            delete_string = "Видалити рядок"
        },
        empty = "Порожньо",
        waiting_key = "Очікування клавіші",
        author_and_version = "Авторы: %s | Версія: %s",
        script_updated = "Знайдено оновлення % s. Скрипт оновлюється!",
        script_wait = "Скрипт чекає поки ви відправите рядок.."
    },
    combo = {
        var = {"English", "Russian", "Ukrainian"},
        id = 0,
        uuid = new.int(0)
    }
}


--=> CONFIG <=--
local dir = {
    getWorkingDirectory() .. "\\FastDialogMenu"
}
for k,v in ipairs( dir ) do
    if not doesDirectoryExist(v) then
        createDirectory(v)
    end
end
dir[3] = getWorkingDirectory() .. "\\FastDialogMenu\\settings.json"
local cjson = { } do
    cjson.read = function(filename)
        local f = io.open(filename, 'r')
        local table = decodeJson(f:read('*a'))
        f:close()
        return table
    end
    cjson.write = function(table, filename)
        local file = io.open(filename, 'w')
        file:write(encodeJson(table))
        file:close()
    end
    cjson.load = function(table,filename)
        if not doesFileExist(filename) then
            cjson.write(table, filename)
            return table
        else
            return cjson.read(filename)
        end
    end
end
local listForColorTheme = {}
local cfg = {}
local bind_paused = {}
local config = { } do
    local function getConfigList()
        local files = {}
        local handleFile, nameFile = findFirstFile('moonloader/FastDialogMenu/*.json')
        while nameFile do
            if handleFile then
                if not nameFile then 
                    findClose(handleFile)
                else
                    files[#files+1] = nameFile
                    nameFile = findNextFile(handleFile)
                end
            end
        end
        return files
    end

    config.selectJson = "None"

    config.new = function(filename)
        local file_path = dir[1] .. "\\" .. filename
        cjson.write({
            dialogs = {},
            colors = {0.12351258844137,0.28856787085533,0.85807120800018,1},
            lan = 0
        }, file_path)
    end
    config.load = function(filename)
        local file_path = dir[1] .. "\\" .. filename
        if not doesFileExist(file_path) then
            config.new(filename)
        end
        local js = cjson.read(file_path)
        config.selectJson = filename
        bind_paused = {}

        iSet = {
            dialog = {
                select = -1,
                name = new.char[128](""),
                activate = {
                    commands = {
                        state = new.bool(false),
                        var = new.char[128]("")
                    },
                    target = {
                        state = new.bool(false),
                        var = new.char[128]("[]")
                    }
                },
                menu = {}
            },
            buttons = {
                select = -1,
                name = new.char[128](""),
                text = {}
            }
        }

        listForColorTheme.FLOAT4_COLOR = new.float[4](js["colors"][1], js["colors"][2], js["colors"][3], js["colors"][4]) -- float[4]
        listForColorTheme.OUR_COLOR = imgui.ColorConvertFloat4ToU32(imgui.ImVec4(listForColorTheme.FLOAT4_COLOR[2], listForColorTheme.FLOAT4_COLOR[1], listForColorTheme.FLOAT4_COLOR[0], listForColorTheme.FLOAT4_COLOR[3])) -- BBGGRRAA => AARRGGBB
        listForColorTheme.ret = MonetLua.buildColors(listForColorTheme.OUR_COLOR, 0.8, true)
        
        return js
    end
    config.delete = function(filename)
        local file_path = dir[1] .. "\\" .. filename
        if filename == "defaultconfig.json" then
            -- _chat.info(standart_language.config_not_deleted)
            return 1
        end
        os.remove(file_path)

        if not doesFileExist(dir[1] .. "\\defaultconfig.json") then
            config.new("defaultconfig.json")
        end

        cfg = config.load("defaultconfig.json")
        config.update()

        --=> ПОДГРУЖАЕМ СТИЛЬ ИЗ КОНФИГА
        theme(listForColorTheme.OUR_COLOR, 0.8, false)

        --=> ПОДГРУЖАЕМ ЯЗЫК ИЗ КОНФИГА
        language.combo.uuid = new.int(cfg.lan)
        language.combo.id = imgui.new['const char*'][#language.combo.var](language.combo.var) 

        standart_language = language[language.combo.var[language.combo.uuid[0] + 1]]
        hotkey.Text.NoKey = u8(standart_language.empty)
        hotkey.Text.WaitForKey = u8(standart_language.waiting_key)
        
        if hotkeys then
            for k,v in pairs(hotkeys) do
                v:RemoveHotKey()
            end
            hotkeys = {}
        end
        dialog():load_hotkey(true)

        iSet = {
            dialog = {
                select = -1,
                name = new.char[128](""),
                activate = {
                    commands = {
                        state = new.bool(false),
                        var = new.char[128]("")
                    },
                    target = {
                        state = new.bool(false),
                        var = new.char[128]("[]")
                    }
                },
                menu = {}
            },
            buttons = {
                select = -1,
                name = new.char[128](""),
                text = {}
            }
        }
    end
    config.update = function()
        local testConfig = getConfigList()
        config.list = {}
        if #testConfig > 0 then
            for k,v in pairs(testConfig) do
                config.list[#config.list + 1] = v
            end
            config.ImItems = imgui.new['const char*'][#config.list](config.list)
        end
    end
    config.int = new.int() 
    config.list = {}
    local testConfig = getConfigList()
    if #testConfig > 0 then
        for k,v in pairs(testConfig) do
            config.list[#config.list + 1] = v
        end
    else
        config.load("defaultconfig.json")
        config.list[#config.list + 1] = "defaultconfig.json"
        config.selectJson = "defaultconfig.json"
    end
    config.ImItems = imgui.new['const char*'][#config.list](config.list)
    config.temp_name = new.char[128]("")
end

cfg = config.load("defaultconfig.json")
config.update()


language.combo.uuid = new.int(cfg.lan)
language.combo.id = imgui.new['const char*'][#language.combo.var](language.combo.var) 

local standart_language = language[language.combo.var[language.combo.uuid[0] + 1]]


--=> VARS <=--
local AI_PAGE = {}
ui_meta = {
    __index = function(self, v)
        if v == "switch" then
            local switch = function()
                if self.process and self.process:status() ~= "dead" then
                    return false -- // Предыдущая анимация ещё не завершилась!
                end
                self.timer = os.clock()
                self.state = not self.state

                self.process = lua_thread.create(function()
                    local bringFloatTo = function(from, to, start_time, duration)
                        local timer = os.clock() - start_time
                        if timer >= 0.00 and timer <= duration then
                            local count = timer / (duration / 100)
                            return count * ((to - from) / 100)
                        end
                        return (timer > duration) and to or from
                    end

                    while true do wait(0)
                        local a = bringFloatTo(0.00, 1.00, self.timer, self.duration)
                        self.alpha = self.state and a or 1.00 - a
                        if a == 1.00 then break end
                    end
                end)
                return true -- // Состояние окна изменено!
            end
            return switch
        end
    
        if v == "alpha" then
            return self.state and 1.00 or 0.00
        end
    end
}
local menu = { state = false, duration = 0.2 }
setmetatable(menu, ui_meta)
do
    local bit = require 'bit'

    function join_argb(a, r, g, b)
        local argb = b  -- b
        argb = bit.bor(argb, bit.lshift(g, 8))  -- g
        argb = bit.bor(argb, bit.lshift(r, 16)) -- r
        argb = bit.bor(argb, bit.lshift(a, 24)) -- a
        return argb
    end

    function explode_argb(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end


    local function ARGBtoRGB(color) return bit.band(color, 0xFFFFFF) end

    function ColorAccentsAdapter(color)
        local a, r, g, b = explode_argb(color)
        local ret = {a = a, r = r, g = g, b = b}
        function ret:apply_alpha(alpha) self.a = alpha return self end
        function ret:as_u32() return join_argb(self.a, self.b, self.g, self.r) end
        function ret:as_vec4() return imgui.ImVec4(self.r / 255, self.g / 255, self.b / 255, self.a / 255) end
        function ret:as_vec4_table() return {self.r / 255, self.g / 255, self.b / 255, self.a / 255} end
        function ret:as_argb() return join_argb(self.a, self.r, self.g, self.b) end
        function ret:as_rgba() return join_argb(self.r, self.g, self.b, self.a) end
        function ret:as_chat() return string.format("%06X", ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b))) end
        function ret:argb_to_rgb() return ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b)) end
        return ret
    end
end
function equals(o1, o2, ignore_mt)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if not ignore_mt then
        local mt1 = getmetatable(o1)
        if mt1 and mt1.__eq then
            --compare using built in method
            return o1 == o2
        end
    end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or equals(value1, value2, ignore_mt) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

function decodeCdata(data)
    local temp_data = {}
    for k,v in pairs(data) do
        temp_data[k] = {
            text = u8:decode(str(v[1])),
            method = v[2][0],
            wait = v[3][0]
        }
    end
    return temp_data
end
-- listForColorTheme.FLOAT4_COLOR = new.float[4](cfg["colors"][1], cfg["colors"][2], cfg["colors"][3], cfg["colors"][4]) -- float[4]
-- listForColorTheme.OUR_COLOR = imgui.ColorConvertFloat4ToU32(imgui.ImVec4(listForColorTheme.FLOAT4_COLOR[2], listForColorTheme.FLOAT4_COLOR[1], listForColorTheme.FLOAT4_COLOR[0], listForColorTheme.FLOAT4_COLOR[3])) -- BBGGRRAA => AARRGGBB
-- listForColorTheme.ret = MonetLua.buildColors(listForColorTheme.OUR_COLOR, 0.8, true)
encoding.default = 'CP1251'
u8 = encoding.UTF8
local methods = {
    [1] = "sendChat",
    [2] = "sendLocalChat",
    [3] = "sendInputChat"
}
local mainWindow = new.bool(false)
local script_settings_window = new.bool(false)
local Font = {}
local Icon_Font = {}
local iSet = {
    dialog = {
        select = -1,
        name = new.char[128](""),
        activate = {
            commands = {
                state = new.bool(false),
                var = new.char[128]("")
            },
            target = {
                state = new.bool(false),
                var = new.char[128]("[]")
            }
        },
        menu = {}
    },
    buttons = {
        select = -1,
        name = new.char[128](""),
        text = {}
    }
}


local _chat = {
    info = function(str, ...)
        sampAddChatMessage(string.format("{ffffff}[{%s}  FAST-DIALOG-MENU | %s{FFFFFF}   ] " .. str, string.sub(bit.tohex(ColorAccentsAdapter(listForColorTheme.ret.accent1.color_500):as_argb()), 3, 8), standart_language.info, ...), -1)
    end,
    command = function(command, func)
        sampRegisterChatCommand(command, func)
    end
}






function get_max_dialog()
    local count = 0
    for k,v in pairs(cfg.dialogs) do
        if tonumber(k) > count then
            count = tonumber(k)
        end
    end
    return count
end

function get_max_buttons(dialog_id)
    local count = 0
    if cfg.dialogs[dialog_id] then
        for k,v in pairs(cfg.dialogs[dialog_id]["menu"]) do
            if tonumber(k) > count then
                count = tonumber(k)
            end
        end
    end
    return count
end
function get_table_count(table,except)
    local count = 0
    if type(table) == 'table' then
        for k,v in pairs(table) do
            if except ~= nil then
                if k ~= except then
                    count = count + 1
                end
            else
                count = count + 1
            end
        end
    end
    return count
end



local hotkeys = {}
local dialogs_imgui = {}
local dialogs_buttons_text = {}
function dialog()
    local f = {}
    function f:new()
        local function get_index()
            local count = 0
            for i = 1, 999 do
                if cfg.dialogs[tostring(i)] == nil then
                    count = tostring(i)
                    break
                end
            end
            return count
        end
        local index = get_index()

        cfg.dialogs[index] = {
            name = ("%s #%s"):format(standart_language.new_dialog,index),
            menu = {},
            activate = {
                commands = {
                    state = false,
                    var = ""
                },
                target = {
                    state = false,
                    var = "[]"
                },
                id = -1
            },
            imgui = false
        }
        save()
    end
    function f:load_hotkey()
        for i = 1, get_max_dialog() do
            i = tostring(i)
            if cfg.dialogs[i] then
                local k,v = i, cfg.dialogs[i]
                if v.activate.target.state then
                    if not hotkeys[i] then
                        hotkeys[i] = hotkey.RegisterHotKey('##hotkey_'..i, false, decodeJson(v.activate.target.var), function() handler_hotkeys(i) end)
                    end
                end
            end
        end
    end
    -- function f:load_mimgui_dialogs(load_config)
    --     for i = 1, get_max_dialog() do
    --         i = tostring(i)
    --         if cfg.dialogs[i] then
    --             local k,v = i, cfg.dialogs[i]
    --             if v.activate.target.state or v.activate.commands.state then
    --                 if not dialogs_imgui[k] or load_config then
    --                     if load_config then
    --                         if dialogs_imgui[k] then
    --                             dialogs_imgui[k][2] = nil
    --                         end
    --                     end
    --                     if not dialogs_imgui[k] then dialogs_imgui[k] = {} end
    --                     dialogs_imgui[k][1] = new.bool(v.imgui)
    --                     dialogs_imgui[k][2] = imgui.OnFrame(function()  return dialogs_imgui[k][1][0] end, function(this)
    --                         imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    --                         imgui.Begin(u8(v.name .. " | Target: ID " .. v.activate.id), dialogs_imgui[k][1], imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)

    --                         for button_id = 1, get_max_buttons(k) do
    --                             button_id = tostring(button_id)
    --                             if cfg.dialogs[i].menu[button_id] then
    --                                 local button_param = cfg.dialogs[i].menu[button_id]
    --                                 if imgui.Button(u8(button_param.name), imgui.ImVec2(200, 0)) then
    --                                     if next(button_param.text) ~= nil then
    --                                         sendChat(i, button_id, button_param.text)
    --                                     else
    --                                         _chat.info(standart_language.text_is_empty)
    --                                     end
    --                                 end
    --                             end
    --                         end

    --                         imgui.End()
    --                     end)
    --                 end
    --             end
    --         end
    --     end
    -- end
    function f:new_button(dialog_id)
        local function get_index()
            local count = 0
            for i = 1, 999 do
                if cfg.dialogs[dialog_id]["menu"][tostring(i)] == nil then
                    count = tostring(i)
                    break
                end
            end
            return count
        end
        local index = get_index()

        cfg.dialogs[dialog_id]["menu"][index] = {
            name = ("%s #%s"):format(standart_language.new_button, index),
            text = {}
        }
        save()
    end
    function f:split(text)
        local split = {}
        for line in text:gmatch("[^\n]+") do
            if line ~= '' then
                table.insert(split, line)
            end
        end 
        return split
    end
    function f:setText(dialog_id, button_id, string_table)
        for k,v in ipairs(string_table) do
            cfg.dialogs[dialog_id].menu[button_id].text[k] = {text = u8:decode(str(v[1])), method = v[2][0], wait = v[3][0]}
        end
        save()
    end
    function f:delete(dialog_id)
        cfg.dialogs[dialog_id] = nil
        if dialogs_imgui[dialog_id] then
            dialogs_imgui[dialog_id][2] = nil
            dialogs_imgui[dialog_id][1][0] = false
        end
        if hotkeys[dialog_id] then
            hotkeys[dialog_id]:RemoveHotKey()
            hotkeys[dialog_id] = nil
        end
        save()
    end
    function f:button_delete(dialog_id, button_id)
        cfg.dialogs[dialog_id].menu[button_id] = nil
        save()
    end
    function f:new_string(dialog_id, button_id)
        local index = #cfg.dialogs[dialog_id].menu[button_id].text + 1
        cfg.dialogs[dialog_id].menu[button_id].text[index] = {
            text = "",
            method = 1,
            wait = 1
        }
        
        save()
        iSet.buttons.text[index] = {
            new.char[256](""),
            new.int(1),
            new.int(1)
        }
    end
    function f:set_text_method(dialog_id, button_id, str_id, method)
        cfg.dialogs[dialog_id].menu[button_id].text[str_id].method = method
        save()
    end
    function f:delete_string(dialog_id, button_id, str_id)
        table.remove(cfg.dialogs[dialog_id].menu[button_id].text,str_id)
        save()
        iSet.buttons.text = {}
        if next(cfg.dialogs[dialog_id].menu[button_id].text) ~= nil then
            for _,r in ipairs(cfg.dialogs[dialog_id].menu[button_id].text) do
                iSet.buttons.text[_] = {new.char[256](u8(r.text)), new.int(r.method), new.int(r.wait)}
            end
        end
    end 
    return f
end
dialog():load_hotkey()

function sendChat(dialog_id, button_id, button_text)
    local target_id = cfg.dialogs[dialog_id].activate.id
    lua_thread.create(function()
        for k,v in ipairs(button_text) do
            if sampIsPlayerConnected(target_id) then
                local text = v.text
                local binder_var = {
                    ["{target:id}"] = target_id,
                    ["{target:nick}"] = sampGetPlayerNickname(target_id),
                    ["{target:rp_nick}"] = function()
                        return sampGetPlayerNickname(target_id):gsub("_", " ")
                    end,
                    ["{target:lvl}"] = sampGetPlayerScore(target_id),
                    ["{name}"] = cfg.dialogs[dialog_id].menu[button_id].name
                }
                for _,r in pairs(binder_var) do
                    text = text:gsub(_, r)
                end

                if v.method == 1 then
                    sampSendChat(text)
                elseif v.method == 2 then
                    sampAddChatMessage(text, -1)
                elseif v.method == 3 then
                    sampSetChatInputEnabled(true)
                    sampSetChatInputText(text)
                    if tonumber(k) ~= tonumber(#button_text) then
                        bind_paused[k] = v.text
                        _chat.info(standart_language.script_wait)
                        while bind_paused[k] do wait(100) end
                    end
                end
                if tonumber(k) ~= tonumber(#button_text) then
                    wait(v.wait*1000)
                end
                

                
            else
                _chat.info(standart_language.binder.player_off_alert, cfg.dialogs[dialog_id].activate.id)
            end
        end
    end)
end

function handler_hotkeys(hotkey_id)
    if cfg.dialogs[hotkey_id].activate.target.state then
        local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
        if valid then
            if hotkeys[hotkey_id] then
                cfg.dialogs[hotkey_id].activate.id = select(2, sampGetPlayerIdByCharHandle(ped))
                cfg.dialogs[hotkey_id].imgui = true
            end
        else
            _chat.info(standart_language.binder.target_alert)
        end
    end
end

function handler_commands(dialog_id, player_id)
    cfg.dialogs[dialog_id].activate.id = player_id
    cfg.dialogs[dialog_id].imgui = true
end

function save()
    cjson.write(cfg, dir[1] .. "\\" .. config.selectJson)
    dialog():load_hotkey()
end

function main()
    while not isSampAvailable() do wait(100) end

    local lastVersion = update():getLastVersion()
    print(lastVersion)
    if lastVersion ~= thisScript().version then
        _chat.info(standart_language.script_updated, lastVersion)
        update():download()
    end



    for i = 1, get_max_dialog() do
        i = tostring(i)
        if cfg.dialogs[i] then
            cfg.dialogs[i].imgui = false
            cfg.dialogs[i].activate.id = -1
            save()
        end
    end
    
    hotkey.Text.NoKey = u8(standart_language.empty)
    hotkey.Text.WaitForKey = u8(standart_language.waiting_key)

    _chat.info(standart_language.initialize)
    _chat.info(standart_language.author_and_version, table.concat(thisScript().authors, ", "), thisScript().version)
    _chat.command("fdm", function()
        menu.switch()
    end)

    wait(-1)
end



imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil

    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    Font[15] = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 15.0, nil, glyph_ranges)
    for i = 14, 25 do
        Font[i] = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', i, _, glyph_ranges)
    end

    local builder = imgui.ImFontGlyphRangesBuilder()
    local list = {
        "gear",
        "circle_plus",
        "circle_info",
        "floppy_disk",
        "trash_can",
        "seal_question"
    }
    for _, b in ipairs(list) do
        builder:AddText(faicons(b))
    end
    defaultGlyphRanges1 = imgui.ImVector_ImWchar()
    builder:BuildRanges(defaultGlyphRanges1)

    Icon_Font[16] = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('duotune'), 23, config2, defaultGlyphRanges1[0].Data)
    for i = 17, 23 do 
        Icon_Font[i] = imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('duotune'), i, config2, defaultGlyphRanges1[0].Data)
    end

    theme(listForColorTheme.OUR_COLOR, 0.8, false)
end)



local mainMenu = imgui.OnFrame(function() return menu.alpha > 0.00 end,
    function(this)
        imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(900, 450), imgui.Cond.FirstUseEver)
        imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, menu.alpha)
        imgui.Begin('FAST-DIALOG-MENU', nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
        local textsize = function(text, size) imgui.PushFont(Font[size])    imgui.Text(u8(text))    imgui.PopFont()    end
        local textdisabled = function(text, size) imgui.PushFont(Font[size])    imgui.TextDisabled(u8(text))    imgui.PopFont()    end
        local centertext = function(text, size) imgui.PushFont(Font[size])    imgui.SetCursorPosX((imgui.GetWindowSize().x / 2 - imgui.CalcTextSize(tostring(u8(text))).x / 2) - 5)   imgui.Text(u8(text))    imgui.PopFont()    end
        local textwrap = function(text,size)    imgui.PushFont(Font[size])  imgui.TextWrapped(u8(text))    imgui.PopFont() end
        if imgui.BeginChild('##nav_menu', imgui.ImVec2(195, 410), false, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoCollapse) then
            for i = 1, get_max_dialog() do
                i = tostring(i)
                if cfg.dialogs[i] then
                    if imgui.PageButton(iSet.dialog.select == i, i, u8(cfg.dialogs[i].name)) then
                    -- if imgui.GradientSelectable(u8(cfg.dialogs[i].name), imgui.ImVec2(190, 23), iSet.dialog.select == i) then
                        iSet.dialog.select = i
                        iSet.buttons.select = -1
                        --=> COMMANDS-STATE, COMMANDS-VAR
                        iSet.dialog.activate.commands.state[0] = cfg.dialogs[i].activate.commands.state
                        imgui.StrCopy(iSet.dialog.activate.commands.var, u8(cfg.dialogs[i].activate.commands.var))
                        --=> TARGET-STATE, TARGET-VAR
                        iSet.dialog.activate.target.state[0] = cfg.dialogs[i].activate.target.state
                        imgui.StrCopy(iSet.dialog.activate.target.var, cfg.dialogs[i].activate.target.var)
                        
                        imgui.StrCopy(iSet.dialog.name, u8(cfg.dialogs[i].name))

                        iSet.buttons = {
                            select = -1,
                            name = new.char[128](""),
                            text = {}
                        }
                    end
                end
            end
            imgui.EndChild()
        end
        
        imgui.SameLine()
        
        if imgui.BeginChild('##right_menu', imgui.ImVec2(0,-1), true, imgui.WindowFlags.NoScrollbar) then
            imgui.SetCursorPos(imgui.ImVec2(5,5))
            imgui.BeginGroup() --=> GROUP-MENU
            
            if imgui.BeginChild("##right_right_menu", imgui.ImVec2(195, -1), false, imgui.WindowFlags.AlwaysAutoResize) then
                if iSet.dialog.select ~= -1 then
                    for i = 1, get_max_dialog() do
                        i = tostring(i)
                        if cfg.dialogs[i] then
                            if iSet.dialog.select == i then
                                centertext(cfg.dialogs[i].name, 20)
                                imgui.SameLine()
                                imgui.PushFont(Icon_Font[20])
                                imgui.IconHelpButton(faicons("trash_can"), standart_language.delete_dialog, function()
                                    iSet = {
                                        dialog = {
                                            select = -1,
                                            name = new.char[128](""),
                                            activate = {
                                                commands = {
                                                    state = new.bool(false),
                                                    var = new.char[128]("")
                                                },
                                                target = {
                                                    state = new.bool(false),
                                                    var = new.char[128]("[]")
                                                }
                                            },
                                            menu = {}
                                        },
                                        buttons = {
                                            select = -1,
                                            name = new.char[128](""),
                                            text = {}
                                        }
                                    }
                                    dialog():delete(i)
                                end)
                                imgui.PopFont()
                                imgui.Separator()
                                imgui.SetCursorPosX(3)
                                imgui.PushFont(Icon_Font[23])
                                imgui.IconHelpButton(faicons("gear"), standart_language.settings, function()
                                    imgui.OpenPopup("settings_"..i)
                                end)
                                imgui.SameLine()
                                imgui.IconHelpButton(faicons("circle_plus"), standart_language.create_button, function()
                                    dialog():new_button(i)
                                end)
                                imgui.PopFont()
                                for button_id = 1, get_max_buttons(i) do
                                    button_id = tostring(button_id)
                                    if cfg.dialogs[i]["menu"][button_id] then
                                        local v = cfg.dialogs[i]["menu"][button_id]
                                        if imgui.GradientSelectable(u8(v.name), imgui.ImVec2(190, 23), iSet.buttons.select == button_id) then
                                            iSet.buttons = {
                                                select = -1,
                                                name = new.char[128](""),
                                                text = {}
                                            }
                                            iSet.buttons.select = button_id
                                            imgui.StrCopy(iSet.buttons.name, u8(v.name))

                                            
                                            
                                            if next(v.text) ~= nil then
                                                for _,r in ipairs(v.text) do
                                                    iSet.buttons.text[_] = {new.char[256](u8(r.text)), new.int(r.method), new.int(r.wait)}
                                                end
                                            end
                                        end
                                    end 
                                end


                                if imgui.BeginPopup("settings_"..i) then
                                    do --=> DIALOG-NAME
                                        textdisabled(standart_language.title, 19)
                                        imgui.PushItemWidth(200)
                                        imgui.InputTextWithHint('####dialog_name_'..i, u8(standart_language.title_dialog), iSet.dialog.name, 128)
                                        imgui.PopItemWidth()
                                        imgui.SameLine()
                                        imgui.SetCursorPosY(imgui.GetCursorPos().y - 5)
                                        imgui.PushFont(Icon_Font[23])
                                        imgui.IconHelpButton(faicons("floppy_disk"), standart_language.save, function()
                                            if #str(iSet.dialog.name) ~= 0 then
                                                _chat.info(standart_language.saving.dialog_title)
                                                cfg.dialogs[i].name = u8:decode(str(iSet.dialog.name))
                                                save()
                                            else
                                                _chat.info(standart_language.alert)
                                            end
                                        end)
                                        imgui.PopFont()
                                    end
                                    imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                                    imgui.Separator()
                                    do --=> DIALOG-SETTINGS
                                        textdisabled(standart_language.activate_dialog, 19)
                                        
                                        textdisabled(standart_language.activate_on_command, 17)
                                        imgui.ToggleButton(u8(standart_language.open_dialog_on_command), iSet.dialog.activate.commands.state, imgui.ImVec2(40, 20))
                                        if cfg.dialogs[i].activate.commands.state ~= iSet.dialog.activate.commands.state[0] then
                                            cfg.dialogs[i].activate.commands.state = iSet.dialog.activate.commands.state[0]
                                            save()
                                        end
                                        if iSet.dialog.activate.commands.state[0] then
                                            textsize("/", 17) imgui.SameLine()
                                            imgui.PushItemWidth(195)
                                            imgui.InputTextWithHint('####dialog_active_command_'..i, u8(standart_language.write_command), iSet.dialog.activate.commands.var, 128)
                                            imgui.PopItemWidth()
                                            imgui.SameLine()
                                            imgui.SetCursorPosY(imgui.GetCursorPos().y - 5)
                                            imgui.PushFont(Icon_Font[23])
                                            imgui.IconHelpButton(faicons("floppy_disk"), standart_language.save, function()
                                                if #str(iSet.dialog.activate.commands.var) ~= 0 then
                                                    cfg.dialogs[i].activate.commands.var = u8:decode(str(iSet.dialog.activate.commands.var))
                                                    save()
                                                    _chat.info(standart_language.saving.command, u8:decode(str(iSet.dialog.activate.commands.var)))
                                                else
                                                    _chat.info(standart_language.warnings.command)
                                                end
                                            end)
                                            imgui.PopFont()
                                        end
                                        textdisabled(standart_language.activate_target, 17)
                                        imgui.ToggleButton(u8(standart_language.open_target_on_command), iSet.dialog.activate.target.state, imgui.ImVec2(40, 20))
                                        if cfg.dialogs[i].activate.target.state ~= iSet.dialog.activate.target.state[0] then
                                            cfg.dialogs[i].activate.target.state = iSet.dialog.activate.target.state[0]
                                            save()
                                        end
                                        if iSet.dialog.activate.target.state[0] then
                                            if hotkeys[i] ~= nil then
                                                if hotkeys[i]:ShowHotKey(imgui.ImVec2(-1, 25)) then
                                                    cfg.dialogs[i].activate.target.var = encodeJson(hotkeys[i]:GetHotKey())
                                                    save()
                                                end
                                            end
                                        end
                                    end
                                    

                                    imgui.EndPopup()
                                end
                                
                            end
                        end
                    end
                end

                imgui.EndChild()
            end
            imgui.SameLine()
            if imgui.BeginChild("##right_left_menu", imgui.ImVec2(0, -1), false, imgui.WindowFlags.AlwaysAutoResize) then
                if iSet.buttons.select ~= -1 then
                    for i = 1, get_max_dialog() do
                        i = tostring(i)
                        if cfg.dialogs[i] then
                            if iSet.dialog.select == i then
                                for button_id = 1, get_max_buttons(i) do
                                    button_id = tostring(button_id)
                                    if button_id == iSet.buttons.select then
                                        local v = cfg.dialogs[i].menu[button_id]
                                        textdisabled(standart_language.title, 20)
                                        imgui.SameLine()
                                        imgui.PushFont(Icon_Font[20])
                                        imgui.IconHelpButton(faicons("trash_can"), standart_language.delete_button, function()
                                            iSet.buttons = {
                                                select = -1,
                                                name = new.char[128](""),
                                                text = {}
                                            }
                                            dialog():button_delete(i, button_id)
                                        end)
                                        imgui.PopFont()
                                        imgui.PushItemWidth(150)
                                        imgui.InputTextWithHint('####dialog_button_name_'..i, u8(standart_language.title_button), iSet.buttons.name, 128)
                                        imgui.PopItemWidth()
                                        imgui.SameLine()
                                        imgui.SetCursorPosY(imgui.GetCursorPos().y - 5)
                                        imgui.PushFont(Icon_Font[23])
                                        imgui.IconHelpButton(faicons("floppy_disk"), standart_language.save, function()
                                            if #str(iSet.buttons.name) ~= 0 then
                                                v.name = u8:decode(str(iSet.buttons.name))
                                                save()
                                                _chat.info(standart_language.saving.button_title)
                                            else
                                                _chat.info(standart_language.alert)
                                            end
                                        end)
                                        imgui.PopFont()
                                        imgui.SetCursorPosY(imgui.GetCursorPos().y + 3)
                                        textdisabled(standart_language.text, 20)
                                        imgui.SameLine()
                                        imgui.PushFont(Icon_Font[21])
                                        imgui.IconHelpButton(faicons("floppy_disk"), standart_language.save, function()
                                            dialog():setText(i, button_id, iSet.buttons.text)
                                            _chat.info(standart_language.saving.text)
                                        end)
                                        imgui.PopFont()
                                        
                                        imgui.SameLine()
                                        local binder_var = {
                                            {"{target:id}", standart_language.binder.target_id},
                                            {"{target:nick}", standart_language.binder.target_nick},
                                            {"{target:rp_nick}", standart_language.binder.target_rp_nick},
                                            {"{target:lvl}", standart_language.binder.target_score},
                                            {"{name}", standart_language.binder.name}
                                        }
                                        local binder_text = ""
                                        for k,v in ipairs(binder_var) do
                                            binder_text = binder_text .. ("%s - %s\n"):format(v[1], v[2])
                                        end
                                        imgui.PushFont(Icon_Font[21])
                                        imgui.SetCursorPosY(imgui.GetCursorPos().y)
                                        imgui.IconHelpButton(faicons("circle_info"), standart_language.binder.you_can_use_in_binder .. binder_text, function() end)
                                        imgui.SameLine()
                                        imgui.IconHelpButton(faicons("circle_plus"), standart_language.strings.create_string, function()
                                            dialog():new_string(i, button_id)
                                        end)
                                        imgui.PopFont()
                                        imgui.SameLine()
                                        imgui.SetCursorPosY(imgui.GetCursorPos().y + 2)
                                        imgui.PushFont(Font[17])
                                        local equals_state = equals(v.text, decodeCdata(iSet.buttons.text))
                                        imgui.TextColoredRGB(
                                            u8(standart_language.text..": ".. 
                                            (equals_state and "{00ff00}"..standart_language.strings.saved or "{ff0000}"..standart_language.strings.not_saved )))
                                        imgui.PopFont()
                                        imgui.PushFont(Icon_Font[19])
                                        if not equals_state then
                                            imgui.SameLine()
                                            imgui.IconHelpButton(faicons("seal_question"), standart_language.strings.saved_text, function() end)
                                        end
                                        imgui.PopFont()

                                        imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                                        

                                        if next(iSet.buttons.text) ~= nil then
                                            for str_id,value in ipairs(iSet.buttons.text) do
                                                imgui.PushItemWidth(imgui.GetWindowSize().y - 150)
                                                imgui.InputText("###_input_"..i.."_button_"..button_id.."_"..str_id, value[1], 256)
                                                imgui.PopItemWidth() imgui.SameLine()
                                                imgui.PushItemWidth(73)
                                                imgui.AInputInt(standart_language.strings.delay_in_seconds,"##_input_int_.."..i.."_button_"..button_id.."_"..str_id, value[3], 0, 100, 1)
                                                imgui.PopItemWidth()
                                                imgui.SameLine()
                                                imgui.HelpButton(methods[value[2][0]].."##_"..str_id, 
                                                        standart_language.strings.on_click, imgui.ImVec2(100, 23), function()
                                                    imgui.OpenPopup("Select_Method_"..str_id)
                                                end)
                                                if imgui.BeginPopup("Select_Method_"..str_id) then
                                                    if imgui.RadioButtonIntPtr(methods[1], value[2], 1) then
                                                        dialog():set_text_method(i, button_id, str_id, 1)
                                                        value[2][0] = 1
                                                    end
                                                    if imgui.RadioButtonIntPtr(methods[2], value[2], 2) then
                                                        dialog():set_text_method(i, button_id, str_id, 2)
                                                        value[2][0] = 2
                                                    end
                                                    if imgui.RadioButtonIntPtr(methods[3], value[2], 3) then
                                                        dialog():set_text_method(i, button_id, str_id, 3)
                                                        value[2][0] = 3
                                                    end
                                                    imgui.EndPopup()
                                                end imgui.SameLine()
                                                imgui.PushFont(Icon_Font[21])
                                                imgui.SetCursorPosY(imgui.GetCursorPos().y - 4)
                                                imgui.IconHelpButton(faicons("trash_can"), standart_language.strings.delete_string, function()
                                                    dialog():delete_string(i, button_id, str_id)
                                                    
                                                end)
                                                imgui.SetCursorPosY(imgui.GetCursorPos().y + 4)
                                                imgui.PopFont()
                                            end
                                        end

                                    end
                                end
                            end
                        end
                    end
                end
                do
                    imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowSize().x - 20, 0))
                    imgui.CloseButton('##CloseButton', mainWindow, 20, 12)
                end
                imgui.EndChild()
            end
            imgui.EndGroup()
        
            imgui.EndChild()
        end
        do
            imgui.SetCursorPos(imgui.ImVec2(10, imgui.GetWindowSize().y - 30))
            imgui.PushFont(Icon_Font[23])
            imgui.IconHelpButton(faicons("circle_plus"), standart_language.create_dialog, function()
                dialog():new()
            end)
            imgui.SameLine()
            imgui.IconHelpButton(faicons("gear"), standart_language.script_settings, function()
                script_settings_window[0] = true
                imgui.OpenPopup("ScriptSettings")
            end)
            imgui.PopFont()
            if imgui.BeginPopupModal("ScriptSettings", script_settings_window, imgui.WindowFlags.NoResize) then
                imgui.SetWindowSizeVec2(imgui.ImVec2(220, 265))
                textdisabled(standart_language.choice_language, 19)
                imgui.PushItemWidth(150)
                if imgui.Combo(u8("##"..standart_language.choice_language), language.combo.uuid, language.combo.id, #language.combo.var) then
                    cfg.lan = language.combo.uuid[0]
                    standart_language = language[language.combo.var[language.combo.uuid[0] + 1]]
                    hotkey.Text.NoKey = u8(standart_language.empty)
                    hotkey.Text.WaitForKey = u8(standart_language.waiting_key)
                    save()
                end
                imgui.PopItemWidth()
                textdisabled(standart_language.style_theme, 19) imgui.SameLine()
                if imgui.ColorEdit3('##_custom_theme', listForColorTheme.FLOAT4_COLOR, imgui.ColorEditFlags.NoDragDrop + imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.PickerHueWheel) then
                    listForColorTheme.OUR_COLOR = imgui.ColorConvertFloat4ToU32(imgui.ImVec4(listForColorTheme.FLOAT4_COLOR[2], listForColorTheme.FLOAT4_COLOR[1], listForColorTheme.FLOAT4_COLOR[0], listForColorTheme.FLOAT4_COLOR[3])) -- BBGGRRAA => AARRGGBB
                    listForColorTheme.ret = MonetLua.buildColors(listForColorTheme.OUR_COLOR, 1, false)
                    cfg["colors"][1], cfg["colors"][2], cfg["colors"][3], cfg["colors"][4] = listForColorTheme.FLOAT4_COLOR[0], listForColorTheme.FLOAT4_COLOR[1], listForColorTheme.FLOAT4_COLOR[2], listForColorTheme.FLOAT4_COLOR[3]
                    save()
                    theme(listForColorTheme.OUR_COLOR, 0.8, false)
                end
                textdisabled(standart_language.config.title, 19)
                imgui.PushItemWidth(209)
                imgui.Combo(u8'##Configs',config.int,config.ImItems, #config.list)
                imgui.PopItemWidth()
                textwrap(standart_language.config.select .. " " .. config.selectJson, 14)
                if imgui.Button(u8(standart_language.config.button_load), imgui.ImVec2(103,0)) then
                    cfg = config.load(config.list[config.int[0] + 1])
                    _chat.info(standart_language.config.loaded, config.list[config.int[0] + 1])

                    --=> ПОДГРУЖАЕМ СТИЛЬ ИЗ КОНФИГА
                    theme(listForColorTheme.OUR_COLOR, 0.8, false)

                    --=> ПОДГРУЖАЕМ ЯЗЫК ИЗ КОНФИГА
                    language.combo.uuid = new.int(cfg.lan)
                    language.combo.id = imgui.new['const char*'][#language.combo.var](language.combo.var) 

                    standart_language = language[language.combo.var[language.combo.uuid[0] + 1]]
                    hotkey.Text.NoKey = u8(standart_language.empty)
                    hotkey.Text.WaitForKey = u8(standart_language.waiting_key)
                    
                    for k,v in pairs(hotkeys) do
                        v:RemoveHotKey()
                    end
                    hotkeys = {}
                    dialog():load_hotkey(true)

                    iSet = {
                        dialog = {
                            select = -1,
                            name = new.char[128](""),
                            activate = {
                                commands = {
                                    state = new.bool(false),
                                    var = new.char[128]("")
                                },
                                target = {
                                    state = new.bool(false),
                                    var = new.char[128]("[]")
                                }
                            },
                            menu = {}
                        },
                        buttons = {
                            select = -1,
                            name = new.char[128](""),
                            text = {}
                        }
                    }
                end imgui.SameLine()
                if imgui.Button(u8(standart_language.config.button_update), imgui.ImVec2(103,0)) then
                    config.update()
                end
                if imgui.Button(u8(standart_language.config.button_delete), imgui.ImVec2(210,0)) then
                    config.delete(config.selectJson)
                end
                if imgui.Button(u8(standart_language.config.button_create), imgui.ImVec2(210,0)) then
                    imgui.OpenPopup("MakeConfig")
                end

                if imgui.BeginPopup("MakeConfig") then
                    imgui.InputText('####make_config_name',config.temp_name, 128)
                    imgui.SameLine()
                    textdisabled(".json", 15)

                    if imgui.Button(u8(standart_language.config.button_create), imgui.ImVec2(-1, 0)) then
                        if #str(config.temp_name) ~= 0 then
                            config.new(u8:decode(str(config.temp_name)) .. ".json")
                            imgui.StrCopy(config.temp_name, "")
                            config.update()
                        end
                    end
                end

                imgui.EndPopup()
            end
        end
        
        imgui.End()
        
        imgui.PopStyleVar(1)
    end
)

function theme(our_color, power, show_shades)
    -- listForColorTheme.our_color, 1, false
    local vec2, vec4 = imgui.ImVec2, imgui.ImVec4
    imgui.SwitchContext()
    local st = imgui.GetStyle()
    local cl = st.Colors
    local fl = imgui.Col

    local to_vec4 = function(color)
        return ColorAccentsAdapter(color):as_vec4()
    end

    local palette = MonetLua.buildColors(our_color, power, show_shades)
    -- local dark_palette = MonetLua.buildColors(our_color, power+0.3, show_shades)

    st.WindowPadding = vec2(5, 5)
    st.WindowRounding = 6.0
    st.WindowBorderSize = 0
    -- st.WindowMinSize = ImVec2
    st.WindowTitleAlign = vec2(0.5, 0.5)
    -- st.WindowMenuButtonPosition = imGuiDirs
    st.ChildRounding = 7.0
    st.ChildBorderSize = 2.0
    st.PopupRounding = 5.0
    st.PopupBorderSize = 1.0
    st.FramePadding = vec2(5, 4)
    st.FrameRounding = 3.0
    -- st.FrameBorderSize = float
    st.ItemSpacing = vec2(4, 4)
    -- st.ItemInnerSpacing = vec2(100, 100)
    -- st.TouchExtraPadding = vec2(10, 10)
    -- st.IndentSpacing = float
    -- st.ColumnsMinSpacing = float
    -- st.ScrollbarSize = float
    -- st.ScrollbarRounding = float
    st.GrabMinSize = 9
    st.GrabRounding = 15
    -- st.TabRounding = float
    -- st.TabBorderSize = float
    -- st.ColorButtonPosition = ImGuiDir
    st.ButtonTextAlign = vec2(0.5, 0.5)
    st.SelectableTextAlign = vec2(0.5, 0.5)
    -- st.DisplayWindowPadding = vec2(10, 10)
    -- st.DisplaySafeAreaPadding = vec2(10, 10)
    -- st.AntiAliasedLines = bool;
    -- st.AntiAliasedFill = bool;
    -- st.CurveTessellationTol = float
    cl[fl.Text] =                to_vec4(palette.accent2.color_50)
    cl[fl.TextDisabled] =        to_vec4(palette.accent1.color_600)
    cl[fl.WindowBg] =            to_vec4(palette.accent1.color_900)
    cl[fl.ChildBg] =             to_vec4(palette.accent1.color_900)
    cl[fl.PopupBg] =             to_vec4(palette.accent1.color_900)
    cl[fl.Border] =              to_vec4(palette.accent1.color_700)
    cl[fl.BorderShadow] =        to_vec4(palette.neutral2.color_900)
    cl[fl.FrameBg] =             to_vec4(palette.accent1.color_800)
    cl[fl.FrameBgHovered] =      to_vec4(palette.accent1.color_700)
    cl[fl.FrameBgActive] =       to_vec4(palette.accent1.color_600)
    cl[fl.TitleBg] =             to_vec4(palette.accent1.color_600)
    cl[fl.TitleBgActive] =       to_vec4(palette.accent1.color_600)
    cl[fl.TitleBgCollapsed] =    to_vec4(palette.accent1.color_600)
    cl[fl.MenuBarBg] =           to_vec4(palette.accent2.color_700)
    cl[fl.ScrollbarBg] =         to_vec4(palette.accent1.color_800)
    cl[fl.ScrollbarGrab] =       to_vec4(palette.accent1.color_600)
    cl[fl.ScrollbarGrabHovered] =to_vec4(palette.accent1.color_500)
    cl[fl.ScrollbarGrabActive] = to_vec4(palette.accent1.color_400)
    cl[fl.CheckMark] =           to_vec4(palette.neutral1.color_50)
    cl[fl.SliderGrab] =          to_vec4(palette.accent1.color_500)
    cl[fl.SliderGrabActive] =    to_vec4(palette.accent1.color_500)
    cl[fl.Button] =              to_vec4(palette.accent1.color_500)
    cl[fl.ButtonHovered] =       to_vec4(palette.accent1.color_400)
    cl[fl.ButtonActive] =        to_vec4(palette.accent1.color_300)
    cl[fl.Header] =              to_vec4(palette.accent1.color_800)
    cl[fl.HeaderHovered] =       to_vec4(palette.accent1.color_700)
    cl[fl.HeaderActive] =        to_vec4(palette.accent1.color_600)
    cl[fl.Separator] =           to_vec4(palette.accent1.color_700)
    cl[fl.SeparatorHovered] =    to_vec4(palette.accent2.color_100)
    cl[fl.SeparatorActive] =     to_vec4(palette.accent2.color_50)
    cl[fl.ResizeGrip] =          to_vec4(palette.accent2.color_900)
    cl[fl.ResizeGripHovered] =   to_vec4(palette.accent2.color_800)
    cl[fl.ResizeGripActive] =    to_vec4(palette.accent2.color_700)
    cl[fl.Tab] =                 to_vec4(palette.accent1.color_700)
    cl[fl.TabHovered] =          to_vec4(palette.accent1.color_600)
    cl[fl.TabActive] =           to_vec4(palette.accent1.color_500)
    -- cl[fl.TabUnfocused] = ImVec4
    -- cl[fl.TabUnfocusedActive] = ImVec4
    cl[fl.PlotLines] =           to_vec4(palette.accent3.color_300)
    cl[fl.PlotLinesHovered] =    to_vec4(palette.accent3.color_50)
    cl[fl.PlotHistogram] =       to_vec4(palette.accent3.color_300)
    cl[fl.PlotHistogramHovered] =to_vec4(palette.accent3.color_50)
    -- cl[fl.TextSelectedBg] = ImVec4
    cl[fl.DragDropTarget] =      to_vec4(palette.accent3.color_700)
    -- cl[fl.NavHighlight] = ImVec4
    -- cl[fl.NavWindowingHighlight] = ImVec4
    -- cl[fl.NavWindowingDimBg] = ImVec4
    -- cl[fl.ModalWindowDimBg] = ImVec4
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local col = imgui.Col
    
    local designText = function(text__)
        local pos = imgui.GetCursorPos()
        if sampGetChatDisplayMode() == 2 then
            for i = 1, 1 --[[Степень тени]] do
                imgui.SetCursorPos(imgui.ImVec2(pos.x + i, pos.y))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x - i, pos.y))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y + i))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
                imgui.SetCursorPos(imgui.ImVec2(pos.x, pos.y - i))
                imgui.TextColored(imgui.ImVec4(0, 0, 0, 1), text__) -- shadow
            end
        end
        imgui.SetCursorPos(pos)
    end
    
    
    
    local text = text:gsub('{(%x%x%x%x%x%x)}', '{%1FF}')

    local color = colors[col.Text]
    local start = 1
    local a, b = text:find('{........}', start)   
    
    while a do
        local t = text:sub(start, a - 1)
        if #t > 0 then
            designText(t)
            imgui.TextColored(color, t)
            imgui.SameLine(nil, 0)
        end

        local clr = text:sub(a + 1, b - 1)
        if clr:upper() == 'STANDART' then color = colors[col.Text]
        else
            clr = tonumber(clr, 16)
            if clr then
                local r = bit.band(bit.rshift(clr, 24), 0xFF)
                local g = bit.band(bit.rshift(clr, 16), 0xFF)
                local b = bit.band(bit.rshift(clr, 8), 0xFF)
                local a = bit.band(clr, 0xFF)
                color = imgui.ImVec4(r / 255, g / 255, b / 255, a / 255)
            end
        end

        start = b + 1
        a, b = text:find('{........}', start)
    end
    imgui.NewLine()
    if #text >= start then
        imgui.SameLine(nil, 0)
        designText(text:sub(start))
        imgui.TextColored(color, text:sub(start))
    end
end

function imgui.CustomInputTextWithHint(name, bool, hint, size, width, color, password)
    if not size then size = 1.0 end
    if not hint then hint = '' end
    if not width then width = 100 end
    if password then flags = imgui.InputTextFlags.Password else flags = '' end
    local clr = imgui.Col
    local pos = imgui.GetCursorScreenPos()
    local rounding = imgui.GetStyle().WindowRounding -- or ChildRounding
    local drawList = imgui.GetWindowDrawList()
    imgui.BeginChild("##"..name, imgui.ImVec2(width + 10, 25), false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse) -- 
        imgui.SetCursorPosX(5)
        imgui.SetWindowFontScale(size) -- size
        imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.15, 0.18, 0.27, 0.00)) -- alpha 0.00 or color == WindowBg & ChildBg
        imgui.PushItemWidth(width) -- width
        if password then
            result = imgui.InputTextWithHint(name, u8(hint), bool, sizeof(bool), flags)
        else
            result = imgui.InputTextWithHint(name, u8(hint), bool, sizeof(bool)) -- imgui.InputTextWithHint
        end
        imgui.PopItemWidth()
        imgui.PopStyleColor(1)
        imgui.SetWindowFontScale(1.0) -- defoult size
        drawList:AddLine(imgui.ImVec2(pos.x, pos.y + (25*size)), imgui.ImVec2(pos.x + width + 15, pos.y + (25*size)), color, 3 * size) -- draw line
    imgui.EndChild()
    return result
end

function imgui.ToggleButton(name, bool, size)
    local function bringFloatTo(from, to, start_time, duration)
        local timer = os.clock() - start_time
        if timer >= 0.00 and timer <= duration then
            local count = timer / (duration / 100)
            return from + (count * (to - from) / 100), true
        end
        return (timer > duration) and to or from, false
    end

    local rounding = imgui.GetStyle().FrameRounding
    local size = size or imgui.ImVec2(60, 25)
    local dl = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()

    if UI_CUSTOM_TOGGLEBUTTON == nil then UI_CUSTOM_TOGGLEBUTTON = {} end

    if UI_CUSTOM_TOGGLEBUTTON[name] == nil then
        UI_CUSTOM_TOGGLEBUTTON[name] = {
            argument = bool[0],
            bool = false,
            alignment = {bool[0] and size.x / 1.5 - 5 or 0, true},
            clock = 0
        }
    end

    local go_anim = true
    if UI_CUSTOM_TOGGLEBUTTON[name].argument ~= bool[0] then
        UI_CUSTOM_TOGGLEBUTTON[name].argument = bool[0]
        if go_anim then
            UI_CUSTOM_TOGGLEBUTTON[name].bool = true
            UI_CUSTOM_TOGGLEBUTTON[name].clock = os.clock()
        else
            UI_CUSTOM_TOGGLEBUTTON[name].alignment = {bool[0] and size.x / 1.5 - 5 or 0, true}
        end
    end

    local color = {
        constant_color = bool[0] and imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.CheckMark]) or imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.FrameBg]),
        temp_color = bool[0] and imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.CheckMark]) or imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.FrameBg])
    }

    local get_cursor_y = imgui.GetCursorPosY()
    if imgui.InvisibleButton(name, imgui.ImVec2(size)) then UI_CUSTOM_TOGGLEBUTTON[name].bool = true; UI_CUSTOM_TOGGLEBUTTON[name].clock = os.clock(); bool[0] = not bool[0] end
    if imgui.IsItemHovered() then color.temp_color = imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]) end
    if imgui.IsItemActive() then color.temp_color = imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.FrameBgActive]) end
    imgui.SameLine()
    imgui.BeginGroup()
    imgui.SetCursorPosY(get_cursor_y + (size.y - imgui.CalcTextSize(name).y) / 2)
    imgui.PushFont(Font[15])
    imgui.Text(name)
    imgui.PopFont()
    imgui.EndGroup()

    if UI_CUSTOM_TOGGLEBUTTON[name].bool then
        UI_CUSTOM_TOGGLEBUTTON[name].alignment = {bringFloatTo((bool[0] and 0 or size.x / 1.5 - 5), (bool[0] and size.x / 1.5 - 5 or 0), UI_CUSTOM_TOGGLEBUTTON[name].clock, 0.3)}
        if UI_CUSTOM_TOGGLEBUTTON[name].alignment[2] == false then UI_CUSTOM_TOGGLEBUTTON[name].bool = false end
    end

    dl:AddRect(p, imgui.ImVec2(p.x + size.x, p.y + size.y), color.temp_color, rounding, nil, 2)
    dl:AddRectFilled(imgui.ImVec2(p.x + 5 + UI_CUSTOM_TOGGLEBUTTON[name].alignment[1], p.y + 5), imgui.ImVec2(p.x + size.x - size.x / 1.5 + UI_CUSTOM_TOGGLEBUTTON[name].alignment[1], p.y + size.y - 5), color.constant_color, rounding)
end



addEventHandler("onSendRpc", function(id, bs)
    if id == 101 then
        local len = raknetBitStreamReadInt8(bs)
        local message = raknetBitStreamReadString(bs, len)

        for k,v in pairs(bind_paused) do
            bind_paused[k] = nil
        end
    end
    if id == 50 then
        local len = raknetBitStreamReadInt32(bs)
        local command = raknetBitStreamReadString(bs, len)
        
        for k,v in pairs(bind_paused) do
            bind_paused[k] = nil
        end
        for i = 1, get_max_dialog() do
            i = tostring(i)
            if cfg.dialogs[i] then
                local k,v = i, cfg.dialogs[i]
                if v.activate.commands.state then
                    if #v.activate.commands.var ~= 0 then
                        local temp_command = "/" .. v.activate.commands.var
                        if command:find("^"..temp_command) then
                            if command:find(temp_command.."%s(%d+)") then
                                local id = tonumber(command:match(temp_command.."%s(%d+)"))
                                if sampIsPlayerConnected(id) then
                                    handler_commands(k, id)
                                else
                                    _chat.info("Игрока под ID %s не сущеcтвует!", id)
                                end
                                return false
                            else
                                _chat.info("Введите: %s [ID игрока]", temp_command)
                                return false
                            end
                        end
                    end
                end
            end
        end
    end
end)


function imgui.HelpButton(title, text, size, func)
    if size == nil then
        size = imgui.ImVec2(0, 0)
    end
    imgui.Button(u8(title), size)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(u8(text))
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
    if func ~= nil then
        if imgui.IsItemClicked() then
            func()
        end
    end
end
function imgui.CloseButton(str_id, dialog_id, size, rounding, is_cdata)
    local ToU32 = imgui.ColorConvertFloat4ToU32
    size = size or 40
    rounding = rounding or 5
    local DL = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    
    local result = imgui.InvisibleButton(str_id, imgui.ImVec2(size, size))
    if result then
        if not is_cdata then
            menu.switch()
        else
            cfg.dialogs[dialog_id].imgui = false
        end
    end
    local hovered = imgui.IsItemHovered()

    local col = ToU32(imgui.GetStyle().Colors[imgui.Col.Border])
    local col_bg = hovered and 0x50000000 or 0x30000000
    local offs = (size / 4)

    DL:AddRectFilled(p, imgui.ImVec2(p.x + size, p.y + size), col_bg, rounding, 15)
    DL:AddLine(
        imgui.ImVec2(p.x + offs, p.y + offs), 
        imgui.ImVec2(p.x + size - offs, p.y + size - offs), 
        col,
        size / 10
    )
    DL:AddLine(
        imgui.ImVec2(p.x + size - offs, p.y + offs), 
        imgui.ImVec2(p.x + offs, p.y + size - offs),
        col,
        size / 10
    )
    return result
end

function imgui.IconHelpButton(text, texthint, callback)
    local button = imgui.Text(text)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.PushFont(Font[15])
        imgui.TextUnformatted(u8(texthint))
        imgui.PopFont()
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
    if imgui.IsItemClicked() then
        callback()
    end
    return button
end

function imgui.GradientSelectable(text, size, bool)  
    local p2 = imgui.GetCursorPos()
    local button = imgui.InvisibleButton('##'..text, size)    
    local dl = imgui.GetWindowDrawList()
    local rectMin = imgui.GetItemRectMin()
    local p = imgui.GetCursorScreenPos()
    local ts = imgui.CalcTextSize(text)
    
    if imgui.IsItemHovered() then
        dl:AddRectFilledMultiColor(imgui.ImVec2(rectMin.x, rectMin.y), imgui.ImVec2(rectMin.x + size.x, rectMin.y + size.y), 
            imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.ButtonActive]), imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0,0,0,0)), 
                imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0,0,0,0)), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.ButtonActive]));
    end
    if bool then  
        dl:AddRectFilledMultiColor(imgui.ImVec2(rectMin.x, rectMin.y), imgui.ImVec2(rectMin.x + size.x, rectMin.y + size.y), 
            imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Separator]), imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0,0,0,0)), 
                imgui.ColorConvertFloat4ToU32(imgui.ImVec4(0,0,0,0)), imgui.ColorConvertFloat4ToU32(imgui.GetStyle().Colors[imgui.Col.Separator]));
    end
    imgui.SetCursorPos(imgui.ImVec2(p2.x + 5, p2.y + 2))
    imgui.PushFont(Font[17])
    imgui.Text(text)
    imgui.PopFont()
    
    
    imgui.SetCursorPosY(p2.y + 25)
    return button
end



function imgui.PageButton(bool, icon, name, but_wide)
    
    local ToU32 = imgui.ColorConvertFloat4ToU32
    but_wide = but_wide or 190
    local duration = 0.25
    local DL = imgui.GetWindowDrawList()
    local p1 = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local col = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
    local function bringFloatTo(from, to, start_time, duration)
        local timer = os.clock() - start_time
        if timer >= 0.00 and timer <= duration then
            local count = timer / (duration / 100)
            return from + (count * (to - from) / 100), true
        end
        return (timer > duration) and to or from, false
    end
        
    if not AI_PAGE[name] then
        AI_PAGE[name] = { clock = nil }
    end
    local pool = AI_PAGE[name]

    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.00, 0.00, 0.00, 0.00))
    local result = imgui.InvisibleButton(name, imgui.ImVec2(but_wide, 35))
    if result and not bool then 
        pool.clock = os.clock() 
    end
    local pressed = imgui.IsItemActive()
    imgui.PopStyleColor(3)
    if bool then
        if pool.clock and (os.clock() - pool.clock) < duration then
            local wide = (os.clock() - pool.clock) * (but_wide / duration)
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2((p1.x + 190) - wide, p1.y + 35), 0x10FFFFFF, 0, 10)
            DL:AddRectFilled(imgui.ImVec2(p1.x + 185, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), ToU32(col))
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + wide, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 0, 10)
        else
            DL:AddRectFilled(imgui.ImVec2(p1.x + 185, (pressed and p1.y + 3 or p1.y)), imgui.ImVec2(p1.x + 190, (pressed and p1.y + 32 or p1.y + 35)), ToU32(col))
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), ToU32(imgui.ImVec4(col.x, col.y, col.z, 0.6)), 0, 10)
        end
    else
        if imgui.IsItemHovered() then
            DL:AddRectFilled(imgui.ImVec2(p1.x, p1.y), imgui.ImVec2(p1.x + 190, p1.y + 35), 0x10FFFFFF, 0, 10)
            effect_result = true
        end
    end
    imgui.SameLine(10); imgui.SetCursorPosY(p2.y + 8)
    imgui.PushFont(Font[17])
    if bool then
        imgui.SetCursorPosY(imgui.GetCursorPos().y)
        imgui.Text((' '):rep(3) .. icon)
        imgui.SameLine(50)
        imgui.SetCursorPosY(imgui.GetCursorPos().y)
        imgui.Text(name)
    else
        imgui.SetCursorPosY(imgui.GetCursorPos().y)
        imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), (' '):rep(3) .. icon)
        imgui.SameLine(50)
        imgui.SetCursorPosY(imgui.GetCursorPos().y)
        imgui.TextColored(imgui.ImVec4(0.60, 0.60, 0.60, 1.00), name)
    end
    imgui.PopFont()
    imgui.SetCursorPosY(p2.y + 40)
    return result
end


function imgui.AInputInt(hint, name, value, min, max)
    imgui.InputInt(name, value, 0, 100, 1)
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(u8(hint))
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function isFrameActive()
    for i = 1, get_max_dialog() do
        i = tostring(i)
        if cfg.dialogs[i] then
            if cfg.dialogs[i].imgui then
                return true
            end
        end
    end
end

local dialogFrame = imgui.OnFrame(function()  return isFrameActive() end, function(this)
    for i = 1, get_max_dialog() do
        i = tostring(i)
        if cfg.dialogs[i] then
            local k,v = tostring(i), cfg.dialogs[i]
            if v.imgui then
                imgui.SetNextWindowPos(imgui.ImVec2(imgui.GetIO().DisplaySize.x / 2, imgui.GetIO().DisplaySize.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                imgui.SetNextWindowSize(imgui.ImVec2(210, 0))
                imgui.Begin(u8(v.name .. " | Target: ID " .. v.activate.id), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)

                do
                    imgui.BeginGroup()
                    imgui.PushFont(Font[15])
                    imgui.Text(u8("Dialog: ".. v.name))
                    imgui.Text(u8("Target ID: ".. v.activate.id))
                    imgui.PopFont()
                    imgui.EndGroup()
                    imgui.SameLine(imgui.GetWindowSize().x - 22)
                    imgui.SetCursorPosY(imgui.GetCursorPos().y - 4)
                    imgui.CloseButton('##CloseButton_window_'..i, i, 20, 12, true)
                    imgui.SetCursorPosY(imgui.GetCursorPos().y + 5)
                end

                for button_id = 1, get_max_buttons(k) do
                    button_id = tostring(button_id)
                    if cfg.dialogs[i].menu[button_id] then
                        local button_param = cfg.dialogs[i].menu[button_id]
                        if imgui.Button(u8(button_param.name), imgui.ImVec2(200, 0)) then
                            if next(button_param.text) ~= nil then
                                sendChat(i, button_id, button_param.text)
                            else
                                _chat.info(standart_language.text_is_empty)
                            end
                        end
                    end
                end

                imgui.End()
            end
        end
    end
end)

function onExitScript(quitGame)
    for i = 1, get_max_dialog() do
        i = tostring(i)
        if cfg.dialogs[i] then
            cfg.dialogs[i].imgui = false
            cfg.dialogs[i].activate.id = -1
            save()
        end
    end
end


function update()
    local raw = 'https://raw.githubusercontent.com/itfornik/fastdialogmenu/main/update.json'
    local dlstatus = require('moonloader').download_status
    local requests = require('requests')
    local f = {}
    function f:getLastVersion()
        local response = requests.get(raw)
        if response.status_code == 200 then
            return decodeJson(response.text)['last']
        else
            return 'UNKNOWN'
        end
    end
    function f:download()
        local response = requests.get(raw)
        if response.status_code == 200 then
            downloadUrlToFile(decodeJson(response.text)['url'], thisScript().path, function (id, status, p1, p2)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    thisScript():reload()
                end
            end)
        end
    end
    return f
end