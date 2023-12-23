fx_version 'cerulean'
game 'gta5'
author 'bbv-shellpreview'
lua54 'yes'


client_scripts {
    'client/cl_misc.lua',
    'client/cl_preview.lua',
    'client/cl_orbitcam.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

server_scripts {
    'server/server.lua'
}
