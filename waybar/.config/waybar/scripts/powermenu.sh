#!/usr/bin/env bash

choice=$(printf "󰐥 Desligar\n󰜉 Reiniciar\n󰒲 Suspender\n󰗽 Logout\n󰍃 Cancelar" |
  walker --dmenu)

case "$choice" in
*Desligar) systemctl poweroff ;;
*Reiniciar) systemctl reboot ;;
*Suspender) systemctl suspend ;;
*Logout) hyprctl dispatch exit ;;
*) exit 0 ;;
esac
