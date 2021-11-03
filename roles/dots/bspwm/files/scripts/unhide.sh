#!/bin/sh

# Get ID of last window that was previously hidden
# Note: with `.!sticky` we exclude the Quake window
hidden=$(bspc query -N -n .hidden.\!sticky -d focused | head -1)

# Reveal window
if [ ! -z "$hidden" ]; then
   bspc node "$hidden" -g hidden=off
fi
