#!/bin/bash

export DISTRO=archlinux

source "$(dirname $0)/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

__locking__ cron.sh || exit 1

__sync

export DISTRO=archlinuxarm

__sync

__unlock__ cron.sh
