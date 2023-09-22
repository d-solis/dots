-- Simple music widget
----------------------
-- Copyleft © 2022 Saimoomedits


-- requirements
---------------
local awful     = require("awful")
local helpers   = require("helpers")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi



-- widgets
----------

-- song name
local song_name = wibox.widget{
    widget  = wibox.widget.textbox,
    markup  = helpers.colorize_text("Music is not currently playing...", beautiful.fg_color),
    font    = beautiful.font_var .. " 11",
    align   = "left",
    valign  = "center"
}

-- toggle button
local toggle_button = wibox.widget{
    widget  = wibox.widget.textbox,
    markup  = helpers.colorize_text("󰐊", beautiful.fg_color),
    font    = beautiful.icon_var .. "16",
    align   = "right",
    valign  = "center"
}

-- skip to previous button
local prev_button = wibox.widget{
    widget  = wibox.widget.textbox,
    markup  = helpers.colorize_text("󰒮", beautiful.fg_color),
    font    = beautiful.icon_var .. "16",
    align   = "right",
    valign  = "center"
}

-- skip song button
local skip_button = wibox.widget{
    widget  = wibox.widget.textbox,
    markup  = helpers.colorize_text("󰒭", beautiful.fg_color),
    font    = beautiful.icon_var .. "16",
    align   = "right",
    valign  = "center"
}




-- update widget's info.
-------------------------

-- playerctl module - bling
local playerctl = require("mods.bling").signal.playerctl.lib()

local toggle_command = function() playerctl:play_pause() end  -- toggle command
local prev_command = function() playerctl:previous() end  -- skip to previous command
local skip_command = function() playerctl:next() end  -- skip song command


-- press functions/buttons
toggle_button:buttons(gears.table.join(
    awful.button({}, 1, function() toggle_command() end)))

prev_button:buttons(gears.table.join(
    awful.button({}, 1, function() prev_command() end)))

skip_button:buttons(gears.table.join(
    awful.button({}, 1, function() skip_command() end)))



-- update title widget
playerctl:connect_signal("metadata", function(_, title)
    if title == "" then
        title = "None"
    end

    song_name:set_markup_silently(helpers.colorize_text(title, beautiful.fg_color))
end)


-- update toggle button status
playerctl:connect_signal("playback_status", function(_, playing, __)
    if playing then
        song_name.opacity = 1
        toggle_button.markup = helpers.colorize_text("󰏤", beautiful.fg_color)
    else
        toggle_button.markup = helpers.colorize_text("󰐊", beautiful.fg_color)
        song_name.opacity = .5
    end
end)



-- finalize
-----------
return wibox.widget {
    {
        {
            song_name,
            prev_button,
            toggle_button,
            skip_button,
            layout = wibox.layout.fixed.horizontal,
            spacing = dpi(20)
        },
        widget = wibox.container.margin,
        margins = {left = dpi(10), right = dpi(10)}
    },
    widget = wibox.container.background,
    bg = beautiful.bg_3 .. "cc",
    shape = helpers.rrect(beautiful.rounded - 2)
}


-- eof
------
