#!/bin/bash

source "env.sh" || { echo >&2 "env.sh not found"; exit 127; }

cd $D_VAR
$D_SRC/sync.sh >> sync.sh.log 2>&1

_time="$(__now__)"
_flog="$D_LOG/sync.sh.log-$time"

mv sync.sh.log "$_flog" && gzip "$_flog"
