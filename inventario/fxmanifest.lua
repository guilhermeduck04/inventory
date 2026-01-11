fx_version "bodacious"
game "gta5" 

ui_page_preload "yes"
ui_page "web-side/index.html"

dependency 'ghost_ui'

client_scripts {
    "@vrp/lib/utils.lua",
    "@vrp/config/Native.lua",
    "client-side/*",
    "config-side/*"
}

server_scripts {
    "@vrp/config/Vehicle.lua",
    "@vrp/lib/utils.lua",
    "config-side/*",
    "server-side/*"
}

files {
   "web-side/*",
   "web-side/**/*",
}                            