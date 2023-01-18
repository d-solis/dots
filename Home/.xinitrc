# /$HOME/.xinitrc

# Merge Xresources
xrdb -merge $HOME/.Xresources &

xset -b &

# Launch polkit
exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Launch lib-input-gewstures
exec libinput-gestures-setup desktop start &

# Launch Window Manager
exec awesome
