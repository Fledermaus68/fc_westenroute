fx_version 'adamant'
games { 'gta5' };

name 'fc_westenroute'
version '1.2.0'
author 'fledi.'
description 'Schutzwesten Farming Script'


client_scripts {
    "config.lua",
    "RMenu.lua",
    "menu/RageUI.lua",
    "menu/Menu.lua",
    "menu/MenuController.lua",
    "components/*.lua",
    "menu/elements/*.lua",
    "menu/items/*.lua",
    "menu/panels/*.lua",
    "menu/windows/*.lua",
    "client.lua",
}

server_scripts {
    'config.lua',
    'server.lua'
} 