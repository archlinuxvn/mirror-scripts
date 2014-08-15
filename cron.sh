#!/bin/bash

export D_START="$(dirname $0)"

# archlinux

export DISTRO=archlinux
source "$D_START/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

__locking__ cron.sh || exit 1
__sync
__unlock__ cron.sh

# archlinuxarm

cd "$D_START" # it's complex now :D

export DISTRO=archlinuxarm
source "$D_START/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

__locking__ cron.sh || exit 1
__sync
__unlock__ cron.sh
