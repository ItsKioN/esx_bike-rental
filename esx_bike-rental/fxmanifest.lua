--[[                   GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007
 Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
]]

fx_version 'cerulean'

game 'gta5'

version '5.0'

description 'ESX Bike Rental'

shared_script '@es_extended/imports.lua'


client_scripts {
  '@es_extended/locale.lua',
  'translations/en.lua',
  'translations/es.lua',
  'translations/cz.lua',
  'config.lua',
  'client.lua'
}

server_scripts {
	'@es_extended/locale.lua',
  'translations/en.lua',
  'translations/es.lua',
	'translations/cz.lua',
	'config.lua',
	'server.lua'
}	
