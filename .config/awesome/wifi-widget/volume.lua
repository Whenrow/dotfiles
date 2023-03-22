-------------------------------------------------
-- @author William Henrotin
-- @copyright 2023 William Henrotin
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local spawn = require("awful.spawn")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")


local LIST_NETWORK_CMD = [[sh -c "nmcli device wifi list"]]
local ICON_DIR = os.getenv("HOME") .. '/.config/awesome/wifi-widget/icons/'

function extract_wifi_list(pacmd_output)
    local network = {}
    local properties
    local ports
    local in_device = false
    local in_properties = false
    local in_ports = false
    for line in pacmd_output:gmatch("[^\r\n]+") do

        name = string.match(line, '(%w):')
        signal = string.match(line, ':(%d+):')
        is_default = string.match(line, '*') ~= nil

        table.insert({
            name = name,
            signal = signal,
            is_default = is_default
        })

    end
    return network
end

local widget = {}

function widget.get_widget(widgets_args)
    local args = widgets_args or {}

    local main_color = args.main_color or beautiful.fg_normal
    local mute_color = args.mute_color or beautiful.fg_urgent
    local bg_color = args.bg_color or '#ffffff11'
    local with_icon = args.with_icon == true and true or false

    local bar = wibox.widget {
        {
            {
                id = "icon",
                image = ICON_DIR .. 'wifi-high-symbolic.svg',
                resize = false,
                widget = wibox.widget.imagebox,
            },
            valign = 'center',
            visible = with_icon,
            layout = wibox.container.place,
        },
        {
            id = 'bar',
            max_value = 100,
            forced_width = 50,
            color = main_color,
            margins = { top = 10, bottom = 10 },
            background_color = bg_color,
            shape = gears.shape['bar'],
            widget = wibox.widget.progressbar,
        },
        spacing = 4,
        layout = wibox.layout.fixed.horizontal,
        set_volume_level = function(self, new_value)
            self:get_children_by_id('bar')[1]:set_value(tonumber(new_value))
        end,
        mute = function(self)
            self:get_children_by_id('bar')[1]:set_color(mute_color)
        end,
        unmute = function(self)
            self:get_children_by_id('bar')[1]:set_color(main_color)
        end
    }

    return bar
end

local volume = {}

local rows  = { layout = wibox.layout.fixed.vertical }

local popup = awful.popup{
    bg = beautiful.bg_normal,
    ontop = true,
    visible = false,
    shape = gears.shape.rounded_rect,
    border_width = 1,
    border_color = beautiful.bg_focus,
    maximum_width = 400,
    offset = { y = 5 },
    widget = {}
}

local function build_main_line(device)
    if device.active_port ~= nil and device.ports[device.active_port] ~= nil then
        return device.properties.device_description .. ' · ' .. device.ports[device.active_port]
    else
        return device.properties.device_description
    end
end

local function build_rows(on_checkbox_click)
    local checkbox = wibox.widget {
        checked = device.is_default,
        color = beautiful.bg_normal,
        paddings = 2,
        shape = gears.shape.circle,
        forced_width = 20,
        forced_height = 20,
        check_color = beautiful.fg_urgent,
        widget = wibox.widget.checkbox
    }

    checkbox:connect_signal("button::press", function()
        spawn.easy_async(string.format([[sh -c 'nmcli device wifi connect "%s"']], device.name), function()
            on_checkbox_click()
        end)
    end)

    local row = wibox.widget {
        {
            {
                {
                    checkbox,
                    valign = 'center',
                    layout = wibox.container.place,
                },
                {
                    {
                        text = build_main_line(device),
                        align = 'left',
                        widget = wibox.widget.textbox
                    },
                    left = 10,
                    layout = wibox.container.margin
                },
                spacing = 8,
                layout = wibox.layout.align.horizontal
            },
            margins = 4,
            layout = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        widget = wibox.container.background
    }

    row:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)
    row:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.bg_normal) end)

    local old_cursor, old_wibox
    row:connect_signal("mouse::enter", function()
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand1"
    end)
    row:connect_signal("mouse::leave", function()
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    row:connect_signal("button::press", function()
        spawn.easy_async(string.format([[sh -c 'nmcli device wifi connect "%s"']], device.name), function()
            on_checkbox_click()
        end)
    end)

    table.insert({ layout = wibox.layout.fixed.vertical }, row)

    return { layout = wibox.layout.fixed.vertical }
end

local function build_header_row(text)
    return wibox.widget{
        {
            markup = "<b>" .. text .. "</b>",
            align = 'center',
            widget = wibox.widget.textbox
        },
        bg = beautiful.bg_normal,
        widget = wibox.container.background
    }
end

local function rebuild_popup()
    spawn.easy_async(LIST_NETWORK_CMD, function(stdout)

        local rows = extract_wifi_list(stdout)
        for i = 0, #rows do rows[i]=nil end
        table.insert(rows, build_header_row("Networks"))
        table.insert(rows, build_rows(function() rebuild_popup() end))
        popup:setup(rows)
    end)
end


local function worker(user_args)

    local args = user_args or {}

    local mixer_cmd = args.mixer_cmd or 'pavucontrol'
    local widget_type = args.widget_type
    local refresh_rate = args.refresh_rate or 1
    local step = args.step or 5
    local device = args.device or 'pulse'

    volume.widget = widget.get_widget(args)

    local function update_graphic(widget, stdout)
        local volume_level = string.match(stdout, "(%d?%d?%d)%%") -- (\d?\d?\d)\%)
        volume_level = string.format("% 3d", volume_level)
        widget:set_volume_level(volume_level)
    end

    function volume:mixer()
        if mixer_cmd then
            spawn.easy_async(mixer_cmd)
        end
    end

    volume.widget:buttons(
    awful.util.table.join(
    awful.button({}, 3, function()
        if popup.visible then
            popup.visible = not popup.visible
        else
            rebuild_popup()
            popup:move_next_to(mouse.current_widget_geometry)
        end
    end),
    awful.button({}, 2, function() volume:mixer() end)
    )
    )

    return volume.widget
end

return setmetatable(volume, { __call = function(_, ...) return worker(...) end })
