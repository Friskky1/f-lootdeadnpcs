fx_version 'cerulean'
game 'gta5'

author 'Friskky Developments'
description 'Loot Dead NPCs Script'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependencies {
    'qb-core',
    'qb-target',
    'progressbar'
}