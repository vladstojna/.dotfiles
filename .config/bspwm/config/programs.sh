#!/bin/sh

snixembed --fork
"$HOME"/.config/polybar/launch.sh &
pgrep -x sxhkd >/dev/null ||
    sxhkd -c "$HOME"/.config/sxhkd/sxhkdrc "$HOME"/.config/sxhkd/sxhkdrc.* &
(sleep 3 && nitrogen --restore) &
