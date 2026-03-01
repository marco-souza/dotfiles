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

max_width=32
jump_size=1
pause_time=2
counter_file="/tmp/waybar_media_scroll"
state_file="/tmp/waybar_media_state"
initial_pause_file="/tmp/waybar_media_initial_pause"

# If title fits, display it
if [ ${#title} -le $max_width ]; then
  echo " $icon $title "
  rm -f "$counter_file" "$state_file" "$initial_pause_file"
  exit 0
fi

# Title is too long, implement scrolling with pause at beginning and end
offset=$(cat "$counter_file" 2>/dev/null || echo 0)
pause_count=$(cat "$state_file" 2>/dev/null || echo 0)
initial_pause_count=$(cat "$initial_pause_file" 2>/dev/null || echo "$pause_time")

# If we're in initial pause state at the beginning
if [ $initial_pause_count -gt 0 ] && [ $offset -eq 0 ]; then
  # Show the beginning text
  display_text="${title:0:$max_width}"
  echo " $icon $display_text "

  # Decrement initial pause counter
  new_initial_pause_count=$((initial_pause_count - 1))
  echo "$new_initial_pause_count" >"$initial_pause_file"
  exit 0
fi

# If we're in pause state at the end
if [ $pause_count -gt 0 ]; then
  # Show the remaining text
  display_text="${title:$offset:$max_width}"
  echo " $icon $display_text "

  # Decrement pause counter
  new_pause_count=$((pause_count - 1))
  echo "$new_pause_count" >"$state_file"

  # If pause is done, reset offset
  if [ $new_pause_count -eq 0 ]; then
    echo "0" >"$counter_file"
  fi
  exit 0
fi

# Normal scrolling
display_text="${title:$offset:$max_width}"

# Check if we've reached the end
remaining_chars=$((${#title} - offset))
if [ $remaining_chars -le $max_width ]; then
  # Start pause state
  echo "$pause_time" >"$state_file"
  echo " $icon $display_text "
else
  # Continue scrolling
  new_offset=$((offset + jump_size))
  echo "$new_offset" >"$counter_file"
  echo " $icon $display_text "
fi
