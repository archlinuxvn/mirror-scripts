#!/bin/bash

export WORKDIR="$(dirname $0)"

# archlinux

export DISTRO=archlinux
source "$WORKDIR/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

__locking__ cron.sh || exit 1
__sync
__unlock__ cron.sh

# archlinuxarm

export DISTRO=archlinuxarm
source "$WORKDIR/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

__locking__ cron.sh || exit 1
__sync
__unlock__ cron.sh
