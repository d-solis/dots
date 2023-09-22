#!/bin/bash

INTERNAL_MONITOR="eDP"
EXTERNAL_MONITOR="HDMI-1-0"

function switch_to_internal_monitor() {
    xrandr --output "$INTERNAL_MONITOR" --auto --output "$EXTERNAL_MONITOR" --off 
}

function switch_to_external_monitor() {
    xrandr --output "$INTERNAL_MONITOR" --mode 1920x1080 --pos 0x360 --rotate normal --output "$EXTERNAL_MONITOR" --primary --auto --pos 1920x0 --set "PRIME Synchronization" 1
} # Change value to "0" if you don't have an Nvidia GPU

# Function to check if the external monitor is connected
function is_external_monitor_connected() {
    xrandr | grep "$EXTERNAL_MONITOR connected" &> /dev/null
}

# Function to check the current display state and perform the appropriate action
function check_display_state() {
    if is_external_monitor_connected; then
        switch_to_external_monitor
    else
        switch_to_internal_monitor
    fi
}

# Execute the function on script start
check_display_state

# Delay
sleep 0.1

# Function to check if a program is running
function is_program_running {
  if pgrep -x "$1" >/dev/null; then
    return 0  # Program is running
  else
    return 1  # Program is not running
  fi
}

# Kill programs if already running

if is_program_running "lxsession"; then
  echo "Killing lxsession..."
  killall lxsession
fi

if is_program_running "picom"; then
  echo "Killing picom..."
  killall picom
fi

# Delay
sleep 0.1

# Run function

function run {
  if ! pgrep -f "$1"; then
    "$@" &
  fi
}

# Launch Picom
picom -b

# Delay
sleep 0.1

# Launch Wallpaper Script
bash "$HOME/.config/awesome/misc/scripts/wall.sh"

# Make tap to click work on my laptop (change if needed) Laptop Model: Hp Pavillion Gaming Laptop 15-ec2021nr | May work for some other hp laptops but idk
xinput set-prop "ELAN0718:00 04F3:30FD Touchpad" "Synaptics Tap Action" 0 0 0 0 1 3 2 

# Force load Xresources
xrdb ~/.Xresources

# Launch Polkit
run lxsession


# Delay | This makes sure the script runs correctly, idk how either lol
sleep 3
