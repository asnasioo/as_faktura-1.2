fx_version 'cerulean'
game 'gta5'

description 'Skrypt na fakture By asnasio dla redleaks'
author 'asnasioo'
version '1.0.0'

server_script {
    's.lua',
    'config.lua',
}
client_script {
    'c.lua',
    'config.lua',
}

shared_script 'config.lua'
shared_script '@es_extended/imports.lua'