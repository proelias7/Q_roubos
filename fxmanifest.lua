fx_version 'adamant'
game "gta5"

author 'proelias7 by QUANTIC STORE'
description 'pack de roubos para fivem'

ui_page 'mhacking/hack.html'

client_scripts {
	"@vrp/lib/utils.lua",
	"utils/lib.lua",
	"config/config.lua",
	"functions/func_client.lua",
	"client/*",
	'mhacking/mhacking.lua',
	'mhacking/sequentialhack.lua',
	'mhacking/client.lua'
}

server_scripts {
	"@vrp/lib/utils.lua",
	"utils/lib.lua",
	"config/config.lua",
	"functions/func_server.lua",
	"server/*"
}

files {
  'mhacking/phone.png',
  'mhacking/snd/*.ogg',
  'mhacking/hack.html'
}


