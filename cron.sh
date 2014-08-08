#!/bin/bash

source "env.sh" || { echo >&2 "env.sh not found"; exit 127; }

__locking__ || exit 1

cd $D_VAR
$D_SRC/sync.sh >> sync.sh.log 2>&1

_flog="$D_LOG/sync.sh.log-$(__now__)"

mv sync.sh.log "$_flog" && gzip "$_flog"

zcat "$_flog" | $D_SRC/report.sh \
> $D_MIRROR/status.json
