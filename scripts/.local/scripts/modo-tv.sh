#!/usr/bin/env bash
if [ -n "$SWAYSOCK" ]; then
	swaymsg output HDMI-A-1 enable
	swaymsg output HDMI-A-1 mode 1920x1080@60Hz
	swaymsg output DP-1 disable
elif [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
	wlr-randr --output HDMI-A-1 --on --mode 1920x1080@60
	wlr-randr --output DP-1 --off
else
	wlr-randr --output HDMI-A-1 --on --mode 1920x1080@60
	wlr-randr --output DP-1 --off
fi
