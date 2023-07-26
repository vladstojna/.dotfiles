#!/bin/sh

bspc rule -a Screenkey manage=off
bspc rule -a Rofi state=floating
bspc rule -a QjackCtl:qjackctl state=floating
bspc rule -a "*:Toolkit:Picture-in-Picture" state=floating sticky=on follow=off \
	focus=on rectangle=1024x576
bspc rule -a Blueman-manager:blueman-manager state=floating
bspc rule -a Pavucontrol:pavucontrol state=floating
bspc rule -a Zathura:org.pwmt.zathura state=tiled
bspc rule -a "zoom:*" state=floating
bspc rule -a "spectacle:spectacle" state=floating

bspc rule -a Ardour:ardour_ardour -o follow=off desktop="$(bspwm-scratchpad --name)"
bspc rule -a thunderbird:Mail -o follow=off desktop="$(bspwm-scratchpad --name)"
bspc rule -a Signal:signal -o follow=off desktop="$(bspwm-scratchpad --name)"
