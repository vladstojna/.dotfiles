#!/bin/sh

bspc monitor --add-desktops "$(bspwm-scratchpad --name)"
bspc desktop "$(bspwm-scratchpad --name)" --layout monocle
