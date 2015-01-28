#!/bin/bash

source "$(dirname $0)/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

__locking__ sync.sh || exit 1

_URL_RSYNC="$(__random_mirror_select__)"
_OPT_RSYNC="$(cat $D_SRC/rsync.opts | head -1)"

if [[ -n $SYNC_DEBUG ]]; then
  set -f
  _PATTERN=""
  for d in $(cat $D_SRC/rsync.dirs); do
    _PATTERN="$_PATTERN -f \"+ /$d**\""
  done
  cmd="rsync $_OPT_RSYNC $_URL_RSYNC/ $D_MIRROR/ $_PATTERN -f '- *' --dry-run"
  echo "# cmd = $cmd, debug = $SYNC_DEBUG"
else
  echo "# $(__now__): start"
  echo "# cmd = rsync $_OPT_RSYNC $_URL_RSYNC/ $D_MIRROR/"
  echo "# dirs = $(cat $D_SRC/rsync.dirs)"
  rsync $_OPT_RSYNC $_URL_RSYNC/ $D_MIRROR/
  echo "# $(__now__): finish"
fi

__unlock__ sync.sh
