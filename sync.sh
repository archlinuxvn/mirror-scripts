#!/bin/bash

source "$(dirname $0)/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

#locking
_PID_FILE="$D_VAR/sync-mirror-archlinux.pid"

if [[ -f "$_PID_FILE" ]]; then
    echo >&2 "$(__now__): PID file does exist $_PID_FILE"
    exit 1
fi
echo $$ > $_PID_FILE

#sync data
_URL_RSYNC="$(__random_mirror_select__)"
_OPT_RSYNC="$(cat rsync.opts | head -1)"
for d in $(cat rsync.dirs); do
  cmd="rsync $_OPT_RSYNC $_URL_RSYNC/$d/ $D_MIRROR/$d/"
  echo "# $(__now__): start -> $d"
  echo "# cmd = $cmd"
  $cmd
  echo "# $(__now__), finish -> $d"
done

#clean up
rm -f $_PID_FILE
