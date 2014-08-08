#!/bin/bash

source env.sh || { echo >&2 "env.sh not found"; exit 127; }

_ftmp="$D_VAR/report.tmp.log"

grep -E '\.[gx]z$' \
| grep -v -- '->' \
| grep -v '^os/' \
| grep -v ' os/' \
> $_ftmp

_n_update="$(grep -v "deleting " $_ftmp | wc -l)"
_n_delete="$(grep "deleting " $_ftmp | wc -l)"

echo "{
\"number_of_updated_packages\": $_n_update,
\"number_of_deleted_packages\": $_n_delete,
\"report_time\": $(__now__)
}"
