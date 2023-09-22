-- A random rice. i guess.
-- source: https://github.com/saimoomedits/dotfiles |-| Copyleft © 2022 Saimoomedits
------------------------------------------------------------------------------------
-- Include necessary libraries
local awful = require("awful")

pcall (require, "luarocks.loader")

-- home variable 🏠
home_var        = os.getenv("HOME")


-- user preferences ⚙️
user_likes      = {

    -- aplications
    term        = "kitty",
    editor      = "geany",
    code        = "geany",
    web         = "firefox-developer-edition",
    music       = "sonixd",
    discord     = "discord",
    steam       = "steam",
    --music    = "alacritty --class 'music' --config-file " .. home_var .. "/.config/alacritty/ncmpcpp.yml -e ncmpcpp ",
    files       =  "thunar",


    -- your profile
    username = os.getenv("USER"):gsub("^%l", string.upper),
    userdesc = "@AwesomeWM"
}

-- theme 🖌️
require("theme")

-- configs ⚙️
require("config")

-- miscallenous ✨
require("misc")

-- signals 📶
require("signal")

-- ui elements 💻
require("layout")

awful.spawn.with_shell("$HOME/.config/awesome/misc/scripts/autorun.sh")
