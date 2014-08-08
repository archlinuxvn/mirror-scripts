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

echo "updating: $_n_update, delet: $_n_delete"
