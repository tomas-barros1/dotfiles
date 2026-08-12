#!/bin/bash

pids=$(pidof sunsetr)

if [[ -n "$pids" ]]; then
  kill $pids
else
  exec sunsetr
fi
