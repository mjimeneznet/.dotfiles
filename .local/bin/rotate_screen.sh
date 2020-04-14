#!/bin/bash

STATUS=$(xrandr -q | grep DP-2 | awk '{print $4}')

if [[ "$STATUS" == *"left"* ]]; then
	xrandr --output DP-2 --rotate normal
else
	xrandr --output DP-2 --rotate left
fi
