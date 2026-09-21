#!/usr/bin/env bash
if [ -n "$SWAYSOCK" ]; then
	swaymsg output DP-1 enable
	swaymsg output DP-1 mode 1920x1080@144Hz
	swaymsg output HDMI-A-1 disable
elif [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
	wlr-randr --output DP-1 --on --mode 1920x1080@144
	wlr-randr --output HDMI-A-1 --off
else
	wlr-randr --output DP-1 --on --mode 1920x1080@144
	wlr-randr --output HDMI-A-1 --off
fi
