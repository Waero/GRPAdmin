script_name('GRPAdmin')
script_author("Nishikinov")
require "lib.moonloader"
local sampev = require 'lib.samp.events'

adm = {}
gac = {}
help = {}

function tabIns(text)
	print(text)
	chatlog = io.open(getFolderPath(5).."\\GTA San Andreas User Files\\SAMP\\chatlog.txt", "a")
	chatlog:write(os.date("[%H:%M:%S] ")..text.."\n")
	chatlog:close()
end

function sampev.onServerMessage(color, text)
		if string.find(text, "[A] Жалоба", 1, true) then
			tabIns(text)
			table.insert(adm, text)
			return false
		elseif string.find(text, "[G-AC]", 1, true) then
			tabIns(text)
			table.insert(gac, text)
			return false
		elseif string.find(text, "[S] Оператор", 1, true) then
				tabIns(text)
				table.insert(help, text)
				return false
		end
	end

function commandList()
	sampShowDialog(228, "GRPAdmin | Команды", "/acmd - список команд\n/pk - установить игроку Player Kill\n/gh - телепортировать игрока к себе\n/as - спавн игрока", "Закрыть", "", DIALOG_STYLE_MSGBOX)
end

function pk(id)
  local pid = string.match(id, '(%d+)')
  if pid ~= nil then
    sampSendChat('/jail '..pid..' 60 Player Kill')
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

function gacDraw()
if #gac > 3 then
	table.remove(gac, 1)
end
local x = 45
local y = 790
for _, v in ipairs(gac) do
	renderFontDrawText(font, v, x, y, -1)
	y = y + 20
	end
end

function admDraw()
	if #adm > 10 then
			table.remove(adm, 1)
		end
			local x = 45
				local y = 850
				for _, v in ipairs(adm) do
					renderFontDrawText(font, v, x, y, 0xFFFFCC00)
					y = y + 20
				end
end

function helpDraw()
	if #help > 1 then
			table.remove(help, 1)
		end
				local x = 45
				local y = 1050
				for _, v in ipairs(help) do
					renderFontDrawText(font, v, x, y, 0xFFFFCC00)
					y = y + 20
				end
end



function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
	sampAddChatMessage("{3C519A}[GRPAdmin] {FFFFFF}Загружен. Список команд - {3C519A}/acmd", - 1)
	sampRegisterChatCommand("acmd", commandList)
	sampRegisterChatCommand("apos", mouse)
	sampRegisterChatCommand("pk", pk)
	sampRegisterChatCommand("gh", gh)
	sampRegisterChatCommand("as", as)
	posX, posY = getScreenResolution()
	font = renderCreateFont("Arial", 10, 12)
	while true do
		wait(0)
			gacDraw()
			admDraw()
			helpDraw()
	end
end
