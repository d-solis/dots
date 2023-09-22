#! /bin/bash
find "$HOME/.config/awesome/walls/walls" -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n 1 -z | xargs -0 feh --bg-fill

#--no-xinerama