-- requirements
local awful = require("awful")

-- update interval
local update_interval = 10

-- import bluetooth status info
local status_cmd = [[
  bash -c "
  bluetoothctl show | grep 'Powered:' | awk '{ print $2 }'
  "
]]

-- import connected devices info
local devices_cmd = [[
  bash -c "
  bluetoothctl devices
  "
]]

awful.widget.watch(status_cmd, update_interval, function(_, stdout)
    local output = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
    local bluetooth_active = true
    local bluetooth_running_service

    -- Check if bluetooth.service is enabled
    awful.spawn.easy_async_with_shell("bash -c 'pgrep bluetooth'", function (lets_see)
        if lets_see == "" then
            bluetooth_running_service = false
        else
            bluetooth_running_service = true
        end

        -- Set output based on the above info
        if output == "no" then 
            bluetooth_active = bluetooth_running_service
        end

        -- Emit the signal (powered on?, is the process running?)
        awesome.emit_signal("signal::bluetooth", bluetooth_active, bluetooth_running_service)
    end)
end)

awful.widget.watch(devices_cmd, update_interval, function(_, stdout)
    local devices = {}
    local lines = {}
    for line in stdout:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    -- Parse the output to get connected devices
    for i, line in ipairs(lines) do
        if i > 1 then -- Skip the first line (header)
            local address, name = line:match("(%S+)%s+(.+)")
            table.insert(devices, {address = address, name = name})
        end
    end

    -- Emit the signal with the connected devices
    awesome.emit_signal("signal::bluetooth_devices", devices)
end)
