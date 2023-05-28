#!/bin/sh

readonly mon_top="DP-0"
readonly mon_bottom="DP-2"

bspc monitor "$mon_bottom" -d 1 2 3 4 5 6
bspc monitor "$mon_top" -d X
bspc monitor -f "$mon_bottom"
