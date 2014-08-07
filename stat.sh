#!/bin/bash
_f_log="${1:-sync.sh.log}"
_p_last=""
: ${D_MIRROR:=/home/www/public/archlinux/}
while :; do
  [[ -f "$_f_log" ]] || break
  _p_current="$(grep tar $_f_log | tail -1)"
  if [ ! "$_p_current" = "$_p_last" ]; then
    _wc="$(grep tar $_f_log |wc -l)"
    echo -n "$_wc packages; last: $(printf '%s' $_p_current); "
    echo "disk: $(df -h $D_MIRROR | tail -1 | sed -e 's/[ ]\+/ /g' | awk '{print $(NF-1)}')"
    _p_last="$_p_current"
  fi
  sleep 10
done
