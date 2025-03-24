fx_version 'cerulean'
game 'gta5'

description 'abp_bossmenu'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/css/*.css',
    'html/js/*.js',
    'html/index.html',
    'translation/translation.json'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/functions/init.lua',
    'server/server.lua',
    'server/functions/*.lua',
    'server/events/*.lua',
    'server/svwebhook.lua'
}

shared_script 'config.lua'

lua54 'yes'