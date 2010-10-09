#!/bin/sh
cd $(dirname $0)
_URL_RSYNC="$(cat rsync.urls | grep ^rsync:// | head -1)"
_OPT_RSYNC="$(cat rsync.opts | head -1)"
for d in $(cat rsync.dirs); do
  cmd="rsync $_OPT_RSYNC $_URL_RSYNC/$d/ ./$d/"
  echo "# START  $d / $cmd @ $(date +%Y%m%d %H:%S)"
  $cmd
  echo "# FINISH $d / $mcd @ $(date +%Y%m%d %H:%S)"
done
