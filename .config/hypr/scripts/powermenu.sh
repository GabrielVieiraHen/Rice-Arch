#!/bin/bash

uptime=$(uptime -p | sed -e 's/up //g')
lastlogin=$(who -m | awk '{print $3" "$4}')

# Options
lock=""
logout="󰍃"
reboot="󰜉"
shutdown="⏻"

# Variable passed to rofi
options="$lock\n$logout\n$reboot\n$shutdown"

# Rofi command
chosen="$(echo -e "$options" | rofi -dmenu -theme ~/.config/rofi/powermenu.rasi -p " $USER" -mesg " Uptime: $uptime")"

case $chosen in
    $lock)
        hyprlock
        ;;
    $logout)
        hyprctl dispatch exit
        ;;
    $reboot)
        systemctl reboot
        ;;
    $shutdown)
        systemctl poweroff
        ;;
esac
