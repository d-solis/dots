#!/bin/bash
# Place this file in the following location:
# $HOME/.xinit

# Disable bell
xset -b &

# line that fixes things lol

dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY &

# Launch polkit
#exec lxsession &

# Xinput stuff

#xinput set-prop "ELAN0718:00 04F3:30FD Touchpad" "Synaptics Tap Action" 0 0 0 0 1 3 2 &


# Launch awesome
exec awesome -c /home/diego/.config/awesome/rc.lua
