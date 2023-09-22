-- tags  / layouts
------------------
-- Copyleft © 2022 Saimoomedits

-- requirements
-- ~~~~~~~~~~~~
local awful     = require("awful")
local lmachi    = require("mods.layout-machi")
local bling     = require("mods.bling")


-- misc/vars
-- ~~~~~~~~~

-- bling layouts
local mstab     = bling.layout.mstab
local equal     = bling.layout.equalarea
local deck      = bling.layout.deck

-- layout machi
lmachi.editor.nested_layouts = {
    ["0"] = deck,
    ["1"] = awful.layout.suit.spiral,
    ["2"] = awful.layout.suit.fair,
    ["3"] = awful.layout.suit.fair.horizontal
}


-- names/numbers of layouts
local names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
local l     = awful.layout.suit


-- Configurations
-- **************


-- default tags
-- tag.connect_signal("request::default_layouts", function()

--     awful.layout.append_default_layouts({
--         l.tile, l.floating})

-- end)

awful.layout.layouts = {
    awful.layout.suit.tile, 
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    
    --awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}


-- set tags
screen.connect_signal("request::desktop_decoration", function(s)
    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}
    awful.tag(names, s, awful.layout.layouts[1])
end)

