#!/bin/bash

LAPTOP=$(cat /sys/class/drm/card0-eDP-1/status)
EXTERNAL=$(cat /sys/class/drm/card0-DP-2/status)

if [[ ! $(hostname) == "bender" ]]; then
	if [[ $LAPTOP == "connected" ]] && [[ $EXTERNAL == "disconnected" ]]; then
		return 0
	else
		xrandr --output DP-2 --auto --primary
		xrandr --output eDP-1 --off
	fi
else
	return 0	
fi

