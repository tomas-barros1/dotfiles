#!/usr/bin/env bash
# ashell-brightness.sh — brilho via DDC/CI (ddcutil) para um CustomModule do ashell.
# Uso:
#   ashell-brightness.sh listen   -> listen_cmd: emite JSON do brilho (polling)
#   ashell-brightness.sh set      -> on-click: define valor via walker --dmenu
#   ashell-brightness.sh up       -> on-scroll-up: +10
#   ashell-brightness.sh down     -> on-scroll-down: -10

BUS="${BRIGHTNESS_BUS:-7}"
POLL="${BRIGHTNESS_POLL:-2}"

get() {
  ddcutil -b "$BUS" getvcp 10 -t --sleep-multiplier 0 2>/dev/null | awk '{print $4}'
}

emit() {
  local v
  v="$(get)"
  if [[ "$v" =~ ^[0-9]+$ ]]; then
    printf '{"text": "%s%%", "alt": "brightness"}\n' "$v"
  else
    printf '{"text": "N/A", "alt": "brightness"}\n'
  fi
}

setv() {
  ddcutil -b "$BUS" setvcp 10 -- "$1" 2>/dev/null
}

step() {
  local cur n
  cur="$(get)"
  if [[ "$cur" =~ ^[0-9]+$ ]]; then
    n=$((cur $1))
    (( n > 100 )) && n=100
    (( n < 0 )) && n=0
  else
    n="$2"
  fi
  setv "$n"
}

case "${1:-listen}" in
  listen)
    emit
    while :; do
      sleep "$POLL"
      emit
    done
    ;;
  set)
    v="$(walker --dmenu -p 'Brilho (0-100):')"
    if [[ "$v" =~ ^[0-9]+$ ]] && (( v >= 0 && v <= 100 )); then
      setv "$v"
    fi
    ;;
  up)   step "+10" 100 ;;
  down) step "-10" 0 ;;
  *)
    echo "uso: $(basename "$0") {listen|set|up|down}" >&2
    exit 2
    ;;
esac