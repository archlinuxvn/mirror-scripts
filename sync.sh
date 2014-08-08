#!/bin/bash

cd $(dirname $0)

source env.sh || { echo >&2 "env.sh not found"; exit 127; }

#locking
_PID_FILE="$D_VAR/sync-mirror-archlinux.pid"

if [[ -f "$_PID_FILE" ]]; then
    echo "$(date +'%Y%m%d %H:%M:%S') Previous sync process is running, pid: $(cat $_PID_FILE)"
    exit 1
fi
echo $$ > $_PID_FILE

#sync data
_URL_RSYNC="$(cat rsync.urls | grep ^rsync:// | head -1)"
_OPT_RSYNC="$(cat rsync.opts | head -1)"
for d in $(cat rsync.dirs); do
  cmd="rsync $_OPT_RSYNC $_URL_RSYNC/$d/ $D_MIRROR/$d/"
  echo "# START  $d / $cmd @ $(date +'%Y%m%d %H:%M:%S')"
  $cmd
  echo "# FINISH $d / $mcd @ $(date +'%Y%m%d %H:%M:%S')"
done

#clean up
rm -f $_PID_FILE
