#!/bin/bash

cd $HOME/mirror-scripts/ # this is very important
$HOME/mirror-scripts/sync.sh >> sync.sh.log 2>&1
mkdir -p log/
mv sync.sh.log log/sync.sh.log-$(date +%Y%m%d.%H%M)
exit 0

