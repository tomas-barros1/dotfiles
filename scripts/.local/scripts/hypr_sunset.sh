#!/bin/bash

pids=$(pidof hyprsunset)

if [[ -n "$pids" ]]; then
  kill $pids
else
  exec hyprsunset
fi
