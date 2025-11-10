#!/usr/bin/env bash

# Opções do menu
options="Desligar\nReiniciar\nSuspender\nBloquear\nCancelar"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power")

case "$chosen" in
    Desligar)
        systemctl poweroff
        ;;
    Reiniciar)
        systemctl reboot
        ;;
    Suspender)
        systemctl suspend
        ;;
    Bloquear)
        hyprlock    # ou swaylock, se você usa outro locker
        ;;
    *)
        exit 0
        ;;
esac
