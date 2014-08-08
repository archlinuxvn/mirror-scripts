#!/bin/bash

source env.sh || { echo >&2 "env.sh not found"; exit 127; }

_ftmp="$D_VAR/report.tmp.log"

cat \
| grep -E '\.[gx]z$' \
| grep -v -- '->' \
| grep -v '^os/' \
| grep -v ' os/' \
> $_ftmp

_n_update="$(grep -v "deleting " $_ftmp | wc -l)"
_n_delete="$(grep "deleting " $_ftmp | wc -l)"
_n_64="$(find $D_MIRROR/pool/ -iname "*.xz" | grep x86_64 |wc -l)"
_n_32="$(find $D_MIRROR/pool/ -iname "*.xz" | grep i686 |wc -l)"
_repo_size_bytes="$(du -bs $D_MIRROR | awk '{print $1}')"
_repo_size_human="$(du -hs $D_MIRROR | awk '{print $1}')"

echo "{
\"repo_total_size_in_bytes\": $_repo_size_bytes,
\"repo_total_size_in_name\": \"$_repo_size_human\",
\"number_of_packages_x86_64\": $_n_64,
\"number_of_packages_i686\": $_n_32,
\"number_of_updated_packages\": $_n_update,
\"number_of_deleted_packages\": $_n_delete,
\"report_time\": \"$(__now__)\"
}"
