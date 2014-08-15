: ${D_SRC:=$HOME/mirror-scripts/archlinux/}
: ${D_VAR:=$HOME/var/archlinux/}
: ${D_LOG:=$D_VAR/log/}
: ${D_MIRROR:=/home/www/public/archlinux/}

mkdir -p $D_LOG $D_VAR

# Please do not include any space in the foutput!
__now__() {
  date +'%Y%m%d-%H%M%S'
}

__rand__() {
  local _max="${1:-1}"
  awk -vseed="$RANDOM" -vmax=$_max \
    'BEGIN{ srand(seed); print int(max*rand()); }'
}

__random_mirror_select__() {
  local _mirrors=($(cat $D_SRC/rsync.urls | grep ^rsync://))
  local _max="${#_mirrors[@]}"
  _n="$(__rand__ $_max)"
  echo ${_mirrors[$_n]}
}


__locking__() {
  _PID_FILE="$D_VAR/$1.pid"
  if [[ -f "$_PID_FILE" ]]; then
      echo >&2 "$(__now__): PID file does exist $_PID_FILE"
      return 1
  fi
  echo $$ > $_PID_FILE
  return 0
}

__unlock__() {
  _PID_FILE="$D_VAR/$1.pid"
  rm -f $_PID_FILE
}
