fx_version 'cerulean'
games { 'gta5', 'rdr3' }

author "Project Error"
version '1.0.0'

lua54 'yes'
dependency "qb-core"

ui_page 'web/build/index.html'

client_scripts {
  "client/**/*.lua"
}

server_scripts {
  "@oxmysql/lib/MySQL.lua",
  "server/**/*.lua"
}

files {
  'web/build/index.html',
  'web/build/**/*'
}