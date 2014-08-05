#!/bin/sh
_f_log="sync.sh.log"
_p_last=""
: ${D_MIRROR:=/home/www/public/archlinux/}
while :; do
  _p_current="$(grep tar $_f_log | tail -1)"
  if [ ! "$_p_current" = "$_p_last" ]; then
    _wc="$(grep tar $_f_log |wc -l)"
    echo "$_wc packages; last: $(printf '%80s' $_p_current); disk: $(df -h $D_MIRROR | tail -1 | sed -e 's/[ ]\+/ /g')"
    _p_last="$_p_current"
  fi
  sleep 10
done
