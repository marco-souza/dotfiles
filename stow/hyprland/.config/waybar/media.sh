#!/bin/bash

# Get the current track title
title=$(playerctl metadata title 2>/dev/null)

# If no title, exit silently (module will be hidden)
[ -z "$title" ] && exit 0

# Get playback status
status=$(playerctl status 2>/dev/null)

# Set icon based on status
case "$status" in
Playing)
  icon="▶"
  ;;
Paused)
  icon="⏸"
  ;;
*)
  icon="■"
  ;;
esac

echo " $icon $title "
