fx_version 'cerulean'
game 'gta5'

description 'Sistema de Ponto Tablet com Digital'
version '2.0'

shared_script 'config.lua'

ui_page 'ui/index.html'

dependency 'ghost_ui'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/img/fingerprint.png' -- Você precisará de uma imagem de digital png transparente
}

client_scripts {
    '@vrp/Lib/utils.lua',
    'client.lua'
}

server_scripts {
    '@vrp/Lib/utils.lua',
    'server.lua'
}

dependency 'vrp'