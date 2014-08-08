: ${D_SRC:=$HOME/mirror-script/}
: ${D_VAR:=$HOME/var/}
: ${D_LOG:=$D_VAR/log/}
: ${D_MIRROR:=/home/www/public/archlinux/}

mkdir -p $D_LOG $D_VAR

# Please do not include any space in the output!
__now__() {
  date +'%Y%m%d-%H%M'
}
