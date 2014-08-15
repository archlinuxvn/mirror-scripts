#!/bin/bash

source "$(dirname $0)/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

_ftmp="$D_VAR/report.tmp.log"

cat \
| grep -E '\.[x]z$' \
| grep -v -- '->' \
| grep -v '^os/' \
| grep -v ' os/' \
> $_ftmp

_repo_size_bytes="$(du -bs $D_MIRROR | awk '{print $1}')"
_repo_size_human="$(du -hs $D_MIRROR | awk '{print $1}')"
_latest_package_name="$(find $D_MIRROR/ -name "*.tar.xz" -printf "%T@ %p\n" | sort | tail -1|awk '{print $2}')"
_latest_package_time="$(stat -c "%y" $_latest_package_name)"

_s_mirror='Server = http://vn.mirror.archlinuxarm.org/'
_s_contact='f_at_archlinuxvn_dot_org'
_s_img='http://vn.mirror.archlinuxarm.org/os/'

echo "{
\"mirror_contact\": \"$_s_contact\",
\"mirror_config\": \"$_s_mirror\",
\"mirror_img_files\": \"$_s_img\",
\"the_latest_package\": \"$(basename $_latest_package_name)\",
\"the_latest_package_time\": \"$_latest_package_time\",
\"repo_total_size_in_bytes\": \"$_repo_size_bytes\",
\"repo_total_size_in_name\": \"$_repo_size_human\",
\"report_time\": \"$(__now__)\"
}"
