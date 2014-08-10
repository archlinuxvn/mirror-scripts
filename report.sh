#!/bin/bash

source "$(dirname $0)/env.sh" || { echo >&2 "env.sh not found"; exit 127; }

_ftmp="$D_VAR/report.tmp.log"

cat \
| grep -E '\.[x]z$' \
| grep -v -- '->' \
| grep -v '^os/' \
| grep -v ' os/' \
> $_ftmp

_s_mirror='Server = http://f.archlinuxvn.org/archlinux/$repo/os/$arch'
_s_contact='f_at_archlinuxvn_dot_org'
_s_iso='http://f.archlinuxvn.org/archlinux/iso/'
_n_update="$(grep -v "deleting " $_ftmp | wc -l)"
#_n_delete="$(grep "deleting " $_ftmp | wc -l)"
_n_delete="null"
_n_64="$(find $D_MIRROR/pool/ -iname "*.xz" | grep x86_64 |wc -l)"
_n_32="$(find $D_MIRROR/pool/ -iname "*.xz" | grep i686 |wc -l)"
_n_any="$(find $D_MIRROR/pool/ -iname "*.xz" | grep -- '-any\.' |wc -l)"
_repo_size_bytes="$(du -bs $D_MIRROR | awk '{print $1}')"
_repo_size_human="$(du -hs $D_MIRROR | awk '{print $1}')"
_latest_package_name="$(find $D_MIRROR/pool/ -name "*.tar.xz" -printf "%T@ %p\n" | sort | tail -1|awk '{print $2}')"
_latest_package_time="$(stat -c "%y" $_latest_package_name)"

echo "{
\"mirror_contact\": \"$_s_contact\",
\"mirror_config\": \"$_s_mirror\",
\"mirror_iso_files\": \"$_s_iso\",
\"the_latest_package\": \"$(basename $_latest_package_name)\",
\"the_latest_package_time\": \"$_latest_package_time\",
\"repo_total_size_in_bytes\": \"$_repo_size_bytes\",
\"repo_total_size_in_name\": \"$_repo_size_human\",
\"number_of_packages_x86_64\": \"$_n_64\",
\"number_of_packages_i686\": \"$_n_32\",
\"number_of_packages_any\": \"$_n_any\",
\"number_of_updated_packages\": \"$_n_update\",
\"number_of_deleted_packages\": \"$_n_delete\",
\"report_time\": \"$(__now__)\"
}"
