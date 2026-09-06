#!/usr/bin/env bash

if pgrep -x "hyprsunset" >/dev/null; then
  pkill -x "hyprsunset"
else
  hyprsunset &
fi
