fx_version 'cerulean'
game 'gta5'
author 'UnknownJohn'
description 'Changeable Car Colors'

client_script "@np-lib/client/cl_ui.lua"

client_scripts {
    'client/cl_*.lua'
}

server_scripts {
    'server/sv_*.lua'
}

shared_script 'config.lua'