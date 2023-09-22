#!/bin/bash

INTERNAL_MONITOR="EDP1"
EXTERNAL_MONITOR="HDMI1"

if [[ $(xrandr -q | grep "${EXTERNAL_MONITOR} connected") ]]; then
			xrandr --output $INTERNAL_MONITOR --off
else
			xrandr --auto
fi
