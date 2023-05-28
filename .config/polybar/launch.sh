#!/usr/bin/env bash

readonly bars=(main)
killall -q polybar
for bar in "${bars[@]}"; do
	polybar --reload "$bar" 2>&1 | tee -a "/tmp/polybar-$bar.log" &
	disown
done
echo "Polybar launched..."
