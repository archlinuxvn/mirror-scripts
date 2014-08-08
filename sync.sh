#!/bin/bash

source "$(dirname $0)/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

__locking__ sync.sh || exit 1

#sync data
_URL_RSYNC="$(__random_mirror_select__)"
_OPT_RSYNC="$(cat $D_SRC/rsync.opts | head -1)"
for d in $(cat $D_SRC/rsync.dirs); do
  cmd="rsync $_OPT_RSYNC $_URL_RSYNC/$d/ $D_MIRROR/$d/"
  echo "# $(__now__): start -> $d"
  echo "# cmd = $cmd, debug = $SYNC_DEBUG"
  [[ -n $SYNC_DEBUG ]] || $cmd
  echo "# $(__now__), finish -> $d"
done

__unlock__ sync.sh
