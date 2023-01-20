###### Give a star if you liked it!! Also credit if you used anything from this repo.


# AwesomeWM

No instructions for how to install these will be provided. Also these dots were made in Arch. However you can make these work in other distros.

![image](https://user-images.githubusercontent.com/43517199/213188711-a370e0d1-a2c4-4119-95bc-d51e46d81214.png)

# Hardware

 - Ryzen 5 5600h 
 - gtx 1650 (mobile) 
 - 32gb ram 3600mghz 
 - realtek wireless module 

# GTK Themes
 - extract the themes from $HOME/.themes
 - Set the theme with lxappearance

# Dependencies | Install with your favorite aur helper

``` 
yay -S cronie picom-git awesome-git acpid git mpd ncmpcpp wmctrl \
firefox lxappearance gucharmap thunar alacritty neovim polkit-gnome \
xdotool xclip scrot brightnessctl alsa-utils pulseaudio jq acpi rofi \
inotify-tools zsh mpDris2 bluez bluez-utils bluez-plugins acpi acpi_call \
playerctl redshift cutefish-cursor-themes-git cutefish-icons upower xorg tar \
feh imagemagick maim gpick gcalculator neofetch discord steam heroic-games-launcher-bin \
betterdiscordctl python-mutagen libnotify python ruby-git lua ly rofi lxappearance\
```

# Hardware depencies | Do not install these!! These are for me only!! Or unless you have the same hardware.
```
yay -S rtw89 vulkan-icd-loader lib32-vulkan-icd-loader \
wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader \ 
```
####### [Nvidia Auto install Script](https://github.com/t0xic0der/nvidia-auto-installer-for-fedora-linux)
# Optional stuff

Use cron jobs to set wallpaper | Add(or remove) wallpapers to this folder $HOME/walls
```
crontab -e 
```
and paste this into the new file: 
```
*/1 * * * * (export DISPLAY=:0.0 && /bin/date && /usr/bin/nitrogen --set-zoom-fill --random ~/walls --save) > /tmp/myNitrogen.log 2>&1
```
# Systemd Services 

```
systemctl --user enable mpd
```
```
systemctl --user enable mpDris2
```
```
sudo systemctl enable cronie
```
```
sudo systemctl enable bluetooth
```
# Network stuff | Sometimes I forget to enable this stuff

```
sudo systemctl enable wpa_supplicant
```
# Credit:

  ###### [saimoomedits](https://github.com/saimoomedits)
