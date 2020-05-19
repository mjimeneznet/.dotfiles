#!/bin/bash

if [[ ! $(hostname) == "bender" ]]; then
	xrandr --output DP-2 --auto --primary
	xrandr --output eDP-1 --off
else
	echo "Nothing"
fi

