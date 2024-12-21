fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'FinalZ Garage'
author 'sikosz, Goshawk1337, Kek_Orbit'
version '1.0.1'


shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'shared/config.lua',
    'shared/labels.lua',
    'shared/locales.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'shared/serverConfig.lua',
    'server/*.lua',
}

ui_page 'ui/index.html'

files {
    'ui/assets/*.png',
    'ui/index.html',
    'ui/script.js'
}

