#!/bin/bash

entries="Logout\nSuspend\nReboot\nShutdown"

# Get the screen dimensions
screen_width=$(swaymsg -t get_outputs | jq '.[0].rect.width')
screen_height=$(swaymsg -t get_outputs | jq '.[0].rect.height')

# Calculate position (20 pixels from the right edge, 40 pixels from the top)
pos_x=$((screen_width - 220))

selected=$(echo -e $entries | wofi --dmenu --cache-file /dev/null --width 200 --height 160 --x $pos_x --y $pos_y --prompt "Power Menu" --style ~/.config/wofi/style.css | awk '{print tolower($1)}')

case $selected in
  logout)
    swaymsg exit;;
  suspend)
    systemctl suspend;;
  reboot)
    systemctl reboot;;
  shutdown)
    systemctl poweroff;;
esac
