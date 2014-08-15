#!/bin/bash

source "$(dirname $0)/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

_f_log="${1:-$D_VAR/sync.sh.log}"
_p_last=""

while :; do
  [[ -f "$_f_log" ]] || { echo >&2 "$_f_log: file not found"; break ; }
  _p_current="$(grep -E '\.tar\.[xg]z' $_f_log | tail -1)"
  if [ ! "$_p_current" = "$_p_last" ]; then
    _wc="$(grep -E '\.tar\.[xg]z' $_f_log |wc -l)"
    echo "$_wc packages; last: $_p_current; \
disk: $(df -h $D_MIRROR | tail -1 | sed -e 's/[ ]\+/ /g' | awk '{print $(NF-1)}')"
    _p_last="$_p_current"
  fi
  sleep 10
done
