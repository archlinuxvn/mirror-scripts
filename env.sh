: ${D_SRC:=$HOME/mirror-scripts/}
: ${D_VAR:=$HOME/var/}
: ${D_LOG:=$D_VAR/log/}
: ${D_MIRROR:=/home/www/public/archlinux/}

mkdir -p $D_LOG $D_VAR

# Please do not include any space in the output!
__now__() {
  date +'%Y%m%d-%H%M'
}

__rand__() {
  local _max="${1:-1}"
  awk -vseed="$RANDOM" -vmax=$_max \
    'BEGIN{ srand(seed); print int(max*rand()); }'
}

__random_mirror_select__() {
  local _mirrors="$(cat $D_SRC/rsync.urls | grep ^rsync://)"
  local _max="${}"
}
