#!/bin/bash

# This script asign touchscreen to the correct screen and not to the main one.

TOUCH=$(xinput | grep G2Touch | cut -d '=' -f 2 | cut -f 1)
SCREEN=$(xrandr | egrep " connected" | grep -v "primary" | cut -d ' ' -f 1)

xinput --map-to-output $TOUCH $SCREEN
