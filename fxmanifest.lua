fx_version "cerulean"
games { "gta5" }
lua54 "yes"
shared_script "@es_extended/imports.lua"

ui_page "ui/ui.html"

client_scripts {
    "client/cl_main.lua",
    "client/cl_functions.lua",
}

shared_scripts {
    "config.lua"
}

files {
    "ui/ui.html",
    "ui/js/app.js",
    "ui/css/app.css",
}


server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/sv_main.lua",
    "sv_config.lua",
}

-- Dependencies
dependencies {
    "es_extended",
    "oxmysql",
}