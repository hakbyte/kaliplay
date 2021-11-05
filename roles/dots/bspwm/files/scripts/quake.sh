#!/usr/bin/bash

window="Quake" # identifier

# Check if process is already running before attempting to start it
exec="/usr/bin/alacritty --class ${window} -e tmux new -As ${USER}"
if ! pgrep -f "$exec"; then
    ${exec}&
    sleep 0.3 # FIXME: ugly hack :P
fi

# Get window id and make it visible/hidden
id=$(xdo id -N "${window}" || xdo id -n "${window}")
if [ ! -z "${id}" ]; then
    bspc node ${id} --flag hidden --focus
fi
