script_name('GRPAdmin')
script_author("Nishikinov")
require "lib.moonloader"
local sampev = require 'lib.samp.events'
local mem = require "memory"
local sha1 = require "sha1"
local basexx = require "basexx"
local band = bit.band
--------------ПАРАМЕТРЫ АВТОЛОГИНА------
-- Пароль от аккаунта
pass = ''
-- Пароль администрирования
apass = ''
-- Секретный код Google Authenticator
asecret = ''
----------------------------------------

adm = {}
gac = {}
punish = {}
help = {}

function tabIns(text)
	print(text)
	chatlog = io.open(getFolderPath(5).."\\GTA San Andreas User Files\\SAMP\\chatlog.txt", "a")
	chatlog:write(os.date("[%H:%M:%S] ")..text.."\n")
	chatlog:close()
end

local sha1 = require "sha1"
local basexx = require "basexx"
local band = bit.band

function sampev.onServerMessage(color, text)
		if string.find(text, "[A] Жалоба", 1, true) then
			tabIns(text)
			table.insert(adm, text)
			return false
		elseif string.find(text, "[A] Вопрос", 1, true) then
				--tabIns(text)
				--table.insert(ask, text)
				return false
		elseif string.find(text, "[G-AC]", 1, true) then
			tabIns(text)
			table.insert(gac, text)
			return false
		elseif string.find(text, "Администратор", 1, true) and string.find(text, "Причина:", 1, true) then
			tabIns(text)
			table.insert(punish, text)
			return false
		elseif string.find(text, "[S] Оператор", 1, true) then
				tabIns(text)
				table.insert(help, text)
				return false
		elseif string.find(text, "[A]", 1, true) and string.find(text, "передал деньги", 1, true) then
			ip1, ip2 = string.match(text, '%[(%d+.%d+.%d+.%d+)%].+%[(%d+.%d+.%d+.%d+)%]')
			if ip1 == ip2 then
				sampAddChatMessage("{3C519A}[GRPAdmin] {A41919}--------------------------------------------------------------", 0xC1C1C1)
				sampAddChatMessage("{3C519A}[GRPAdmin] {A41919}Передача с одинаковыми IP. Подозрение на махинации с деньгами.", 0xC1C1C1)
				sampAddChatMessage("{3C519A}[GRPAdmin] {A41919}--------------------------------------------------------------", 0xC1C1C1)
			end
		end
	end

	function genCode(skey)
	skey = basexx.from_base32(skey)
	value = math.floor(os.time() / 30)
	value = string.char(
	0, 0, 0, 0,
	band(value, 0xFF000000) / 0x1000000,
	band(value, 0xFF0000) / 0x10000,
	band(value, 0xFF00) / 0x100,
	band(value, 0xFF))
	local hash = sha1.hmac_binary(skey, value)
	local offset = band(hash:sub(-1):byte(1, 1), 0xF)
	local function bytesToInt(a,b,c,d)
		return a*0x1000000 + b*0x10000 + c*0x100 + d
	end
	hash = bytesToInt(hash:byte(offset + 1, offset + 4))
	hash = band(hash, 0x7FFFFFFF) % 1000000
	return ("%06d"):format(hash)
end

	function aLogin ()
			if sampIsDialogActive() then
			did = sampGetCurrentDialogId()
				if did == 184 then
					if apass ~= '' then
					sampSendDialogResponse(184, 1, 0, apass)
					sampCloseCurrentDialogWithButton(0)
					wait(5000)
					end
				elseif did == 0 then
					if pass ~= '' then
						sampSendDialogResponse(0, 1, 0, pass)
						wait(5000)
					end
				elseif did == 389 then
					if asecret ~= '' then
						code = genCode(asecret)
								sampAddChatMessage("{3C519A}[GRPAdmin] {FFFFFF}Входим в игру с кодом: "..code, 0xC1C1C1)
								sampSendDialogResponse(389, 1, 0, code)
								sampCloseCurrentDialogWithButton(1)
					end
			  end
	    end
	end

function commandList()
	sampShowDialog(228, "GRPAdmin | Команды", "/acmd - список команд\n/pk - установить игроку Player Kill\n/gh - телепортировать игрока к себе и поднять\n/as - спавн игрока и поднять\n/ah - быстрый /aheal\n/hp - установить игроку 100 HP\n", "Закрыть", "", DIALOG_STYLE_MSGBOX)
end

function pk(id)
  local pid = string.match(id, '(%d+)')
  if pid ~= nil then
    sampSendChat('/jail '..pid..' 60 PK`ed')
		sampSendChat('/aheal '..pid)
  else
    sampAddChatMessage("{3C519A}[GRPAdmin] {FFFFFF}/pk ID - установить игроку Player Kill.", 0xC1C1C1)
  end
end

function gh(id)
  local pid = string.match(id, '(%d+)')
  if pid ~= nil then
		sampSendChat('/aheal '..pid)
    sampSendChat('/gethere '..pid)
  else
    sampAddChatMessage("{3C519A}[GRPAdmin] {FFFFFF}/gh ID - телепортировать игрока к себе.", 0xC1C1C1)
  end
end

function as(id)
  local pid = string.match(id, '(%d+)')
  if pid ~= nil then
		sampSendChat('/aheal '..pid)
    sampSendChat('/aspawn '..pid)
  else
    sampAddChatMessage("{3C519A}[GRPAdmin] {FFFFFF}/as ID - заспавнить игрока.", 0xC1C1C1)
  end
end

function ah(id)
  local pid = string.match(id, '(%d+)')
  if pid ~= nil then
		sampSendChat('/aheal '..pid)
  else
    sampAddChatMessage("{3C519A}[GRPAdmin] {FFFFFF}/ah ID - быстрый /aheal.", 0xC1C1C1)
  end
end

function hp(id)
  local pid = string.match(id, '(%d+)')
  if pid ~= nil then
		sampSendChat('/sethp '..pid..' 100')
  else
    sampAddChatMessage("{3C519A}[GRPAdmin] {FFFFFF}/hp ID - установить игроку 100 HP.", 0xC1C1C1)
  end
end

function ak(id)
  local pid = string.match(id, '(%d+)')
  if pid ~= nil then
		sampSendChat('/kick '..pid..' AFK without ESC')
  else
    sampAddChatMessage("{3C519A}[GRPAdmin] {FFFFFF}/ak ID - кикнуть за AFK без паузы.", 0xC1C1C1)
  end
end

function punishDraw()
	if #punish > 2 then
			table.remove(punish, 1)
		end
				local x = 5
				local y = posY/1.53
				for _, v in ipairs(punish) do
					renderFontDrawText(font, v, x, y, 0xFFA1020D)
					y = y + 20
				end
end

function gacDraw()
if #gac > 2 then
	table.remove(gac, 1)
end
local x = 5
local y = posY/1.43
for _, v in ipairs(gac) do
	renderFontDrawText(font, v, x, y, 0xFFB72A31)
	y = y + 20
	end
end

function admDraw()
	if #adm > 10 then
			table.remove(adm, 1)
		end
			local x = 5
				local y = posY/1.34
				for _, v in ipairs(adm) do
					renderFontDrawText(font, v, x, y, 0xFF26922C)
					y = y + 20
				end
end

function imgui.OnDrawFrame()
  imgui.Begin('My window') -- новое окно с заголовком 'My window'
  imgui.Text('Hello world') -- простой текст внутри этого окна
  imgui.End() -- конец окна
end



function main()
	if not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
	--if sname ~= "Gambit Role Play" then return end
	sampAddChatMessage("{3C519A}[GRPAdmin by Nishikinov] {FFFFFF}Загружен. Список команд - {3C519A}/acmd", - 1)
	sampRegisterChatCommand("acmd", commandList)
	sampRegisterChatCommand("apos", mouse)
	sampRegisterChatCommand("pk", pk)
	sampRegisterChatCommand("gh", gh)
	sampRegisterChatCommand("as", as)
	sampRegisterChatCommand("ah", ah)
	sampRegisterChatCommand("hp", hp)
	sampRegisterChatCommand("ak", ak)
	posX, posY = getScreenResolution()
	font = renderCreateFont("Tahoma", 10, 12)
	imgui.Process = true
	while true do
		wait(0)
			aLogin()
			gacDraw()
			punishDraw()
			admDraw()
	end
end
