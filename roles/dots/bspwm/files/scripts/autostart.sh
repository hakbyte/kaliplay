#!/usr/bin/env bash

# Load variables
source ~/.config/bspwm/scripts/vars.sh

# Check if process is already running before attempting to start it
function run {
  if ! pgrep -f $1 ; then
    $@&
  fi
}

#
# Startup applications
#

# Hotkey daemon
run /usr/bin/sxhkd

# Hide mouse pointer if idle
run /usr/bin/unclutter -idle 1 -root

# Set wallpaper
run /usr/bin/feh --bg-center ${wallpaper}
