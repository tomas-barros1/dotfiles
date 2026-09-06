#!/usr/bin/env bash

if pgrep -x "sunsetr" >/dev/null; then
  pkill -x "sunsetr"
else
  sunsetr &
fi
