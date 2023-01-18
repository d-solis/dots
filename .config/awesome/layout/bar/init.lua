-- a minimal bar
-- ~~~~~~~~~~~~~

-- requirements
-- ~~~~~~~~~~~~
local awful         = require("awful")
local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local helpers       = require("helpers")
local dpi           = beautiful.xresources.apply_dpi



-- misc/vars
-- ~~~~~~~~~





-- connect to screen
-- ~~~~~~~~~~~~~~~~~
awful.screen.connect_for_each_screen(function(s)

-- screen width
local screen_height = s.geometry.height




    -- widgets
    -- ~~~~~~~

    -- spacers
    local spacer1 = wibox.widget{
        widget = wibox.widget.textbox,
        forced_height        = dpi(1),
    }

    local spacer15 = wibox.widget{
        widget = wibox.widget.textbox,
        forced_height        = dpi(15),
    }

    local spacer20 = wibox.widget{
        widget = wibox.widget.textbox,
        forced_height        = dpi(20),
    }

    local spacer25 = wibox.widget{
        widget = wibox.widget.textbox,
        forced_height        = dpi(25),
    }
    
    local spacer50 = wibox.widget{
        widget = wibox.widget.textbox,
        forced_height        = dpi(50),
    }

    local spacer75 = wibox.widget{
        widget = wibox.widget.textbox,
        forced_height        = dpi(75),
    }

    local spacer100 = wibox.widget{
        widget = wibox.widget.textbox,
        forced_height        = dpi(100),
    }    

    local spacer200 = wibox.widget{
        widget = wibox.widget.textbox,
        forced_height        = dpi(200),
    }

    -- taglist
    local taglist = require("layout.bar.taglist")(s)

    -- Layoutbox
    layoutboxcentered = wibox.container.place(layoutbox)
    local layoutbox = awful.widget.layoutbox {
        screen  = s,
        --valign = "center",
        --halign = "center",
        forced_width = dpi(25),
        forced_height = dpi(25),
        --halign = "center",
        --valign = "center",
        buttons = {
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc(-1) end),
            awful.button({ }, 5, function () awful.layout.inc( 1) end)
        },
        layoutboxcentered = wibox.container.place(layoutbox),halign = "center",valign = "center",
    }

    -- launcher {{
    local launcher = wibox.widget{
        widget = wibox.widget.textbox,
        forced_height        = dpi(25),
        markup = helpers.colorize_text("", beautiful.fg_color),
        font = beautiful.icon_var .. "21",
        align = "center",
        valign = "center",
    }

    launcher:buttons(gears.table.join({
        awful.button({ }, 1, function ()
            awful.spawn.with_shell("rofi -show drun", false)
        end)

    }))
    -- }}

    -- wallpaper changer \ its set like this bc i want the default wallpaper to be nothing lmao
    local wall = wibox.widget{
        markup = helpers.colorize_text("", beautiful.fg_color),
        font = beautiful.icon_var .. "15",
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox
    }

    wall:buttons(gears.table.join({
        awful.button({ }, 1, function ()
            awful.spawn.with_shell(home_var .. "/.scripts/wall.sh", false)
        end)

    }))
    -- }}

    -- wifi
    local wifi = wibox.widget{
        markup = helpers.colorize_text("", beautiful.fg_color),
        font = beautiful.icon_var .. "15",
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox
    }

    wifi:buttons(gears.table.join({
        awful.button({ }, 1, function ()
            awful.spawn.with_shell(home_var .. "/.scripts/rofi-wifi", false)
        end)

    }))
    -- }}

    -- bluetooth
    local bt = wibox.widget{
        markup = helpers.colorize_text("", beautiful.fg_color),
        font = beautiful.icon_var .. "15",
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox
    }

    bt:buttons(gears.table.join({
        awful.button({ }, 1, function ()
            awful.spawn.with_shell(home_var .. "/.scripts/rofi-bluetooth", false)
        end)

    }))
    -- }}

    -- cc
    local cc_ic = wibox.widget{
        markup = "",
        font = beautiful.icon_var .. "17",
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox
    }


    --------------------
    -- battery widget
    local bat_icon = wibox.widget{
        markup = "<span foreground='" .. beautiful.black_color .. "'></span>",
        font = beautiful.icon_var .. "10",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local battery_progress = wibox.widget{
    	color				= beautiful.green_color,
    	background_color	= beautiful.fg_color .. "00",
        forced_width        = dpi(27),
        border_width        = dpi(0.5),
        border_color        = beautiful.fg_color .. "A6",
        paddings             = dpi(2),
        bar_shape           = helpers.rrect(dpi(2)),
    	shape				= helpers.rrect(dpi(4)),
        value               = 70,
    	max_value 			= 100,
        widget              = wibox.widget.progressbar,
    }

    local battery_border_thing = wibox.widget{
            wibox.widget.textbox,
            widget = wibox.container.background,
            border_width        = dpi(0),
            bg = beautiful.fg_color .. "A6",
            forced_width = dpi(9.4),
            forced_height = dpi(9.4),
            shape = function(cr, width, height)
                gears.shape.pie(cr,width, height, 0, math.pi)
            end
    }

    local battery = wibox.widget{
        {
            {
                {
                    battery_border_thing,
                    direction = "south",
                    widget = wibox.container.rotate
                },
                {
                    battery_progress,
                    direction = "east",
                    widget = wibox.container.rotate()
                },
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(-4)
            },
            {
                bat_icon,
                margins = {top = dpi(3)},
                widget = wibox.container.margin,
            },
            layout = wibox.layout.stack,
        },
        widget = wibox.container.margin,
        margins = {left = dpi(7.47),right = dpi(7.47)}
    }
    -- Eo battery
    -----------------------------------------------------



    cc_ic:buttons{gears.table.join(
        awful.button({ }, 1, function ()
            cc_toggle(s)
        end)
    )}



    -- clock
    ---------------------------
    local clock = wibox.widget{
        {
            widget = wibox.widget.textclock,
            format = "%I",
            font = beautiful.font_var .. "Bold 12",
            valign = "center",
            align = "center"
        },
        {
            widget = wibox.widget.textclock,
            format = "%M",
            font = beautiful.font_var .. "Medium 12",
            valign = "center",
            align = "center"
        },
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(3)
    }
    -- Eo clock
    ------------------------------------------




    -- update widgets accordingly
    -- ~~~~~~~~~~~~~~~~~~~~~~~~~~
    awesome.connect_signal("signal::battery", function(value, state)
        battery_progress.value = value


        if state == 1 then
            bat_icon.visible = true
        else
            bat_icon.visible = false
        end

    end)

    --awesome.connect_signal("signal::wifi", function (value)
    --    if value then
    --        wifi.markup = helpers.colorize_text("", beautiful.fg_color .. "CC")
    --    else
    --        wifi.markup = helpers.colorize_text("", beautiful.fg_color .. "99")
    --    end
    --    
    --end)


    -- wibar
    s.wibar_wid = awful.wibar({
        screen      = s,
        visible     = true,
        ontop       = false,
        type        = "dock",
        width      = dpi(48),
        shape       = helpers.rrect(beautiful.rounded - 5),
        bg          =  beautiful.bg_color,
        height       = screen_height - beautiful.useless_gap * 4
    })


    -- wibar placement
    awful.placement.left(s.wibar_wid, {margins = beautiful.useless_gap * 2})
    s.wibar_wid:struts{left = s.wibar_wid.width + beautiful.useless_gap * 2 }


    -- bar setup
    s.wibar_wid:setup {
        {
            launcher,
            --layoutbox,
            nil,
            taglist,
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(20),
            spacer200,
            spacer100,
            spacer15,
            spacer1,
            {

                {
                    bt,
                    wifi,
                    --wall,
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(20)
                },

                {
                    battery,
                    margins = {left = dpi(8), right = dpi(8)},
                    widget = wibox.container.margin
                },
                {
                    clock,
                    cc_ic,
                    layout = wibox.layout.fixed.vertical,
                    spacing = dpi(20)
                },
                {
                    layoutbox,
                    valign = 'center',
                    halign = 'center',
                    widget = wibox.container.place,
                },
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(20)
            },
            layout = wibox.layout.fixed.vertical,
            expand = "none"
        },
        layout = wibox.container.margin,
        margins = {top = dpi(14), bottom = dpi(14)}
    }

end)