
case "$DISTRO" in
  "archlinux") ;;
  "archlinuxarm") ;;
  *)
    echo >&2 "Unknown distro: '$DISTRO'";
    exit 127 ;;
esac

export D_ROOT="/home/www/system/$DISTRO/"
export D_SRC="$D_ROOT/mirror-scripts/$DISTRO/"
export D_VAR="$D_ROOT/var/$DISTRO/"
export D_LOG="$D_VAR/log/"
export D_MIRROR="/home/www/public/$DISTRO/"

mkdir -p $D_LOG $D_VAR

# Please do not include any space in the foutput!
__now__() {
  TZ=Asia/Saigon date +'%Y%m%d-%H%M%S'
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

__sync() {
  if [[ ! -w "$D_MIRROR" ]]; then
    # echo >&2 "$FUNCNAME: $D_MIRROR is not writable"
    return
  fi

  cd $D_VAR
  $D_SRC/sync.sh >> sync.sh.log 2>&1

  _flog="$D_LOG/sync.sh.log-$(__now__)"

  mv sync.sh.log "$_flog" && gzip "$_flog"

  zcat "$_flog.gz" | $D_SRC/report.sh \
  > $D_MIRROR/status.json
}
