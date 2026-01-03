#! /bin/bash
WALLPAPER_DIRECTORY=~/Pictures/Wallpapers

WALLPAPER="$WALLPAPER_DIRECTORY/$(ls $WALLPAPER_DIRECTORY | shuf -n 1)"
MONITOR_1=$(hyprctl monitors | grep Monitor | awk '{ print $2 }' | head)

hyprctl hyprpaper preload $WALLPAPER
hyprctl hyprpaper wallpaper $MONITOR_1,$WALLPAPER

sleep 1

hyprctl hyprpaper unload unused

# notify-send "Changing wallpaper to $WALLPAPER"
