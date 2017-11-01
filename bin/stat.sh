#!/usr/bin/env bash

# Author : hacker
# License: MIT

_distro_to_ext() {
  case "$1" in
  "slitaz") echo "*.tazpkg" ;;
  *)        echo "*.xz" ;;
  esac
}

_distro_score_archlinux() {
  curl -sL https://www.archlinux.org/mirrors/status/json/ \
  | ruby -rjson -e 'avn=JSON.parse(STDIN.read)["urls"].select{|m| m["url"].match(/archlinuxvn/)}.first; puts avn ? avn["score"] : -1'
}

_distro_last_mod() {
  local _distro="$1"
  local _ext=

  _ext="$(_distro_to_ext "$_distro")"

  find "/home/www/public/$_distro/" -type f -iname "$_ext" -mtime -7 \
  | xargs -I {}  bash -c 'echo -n "{} " ; stat -c "%Y %y" {}' \
  | sort -k2n \
  | tail -1 \
  | ruby -n -e '
      pkg, n, _ = $_.split;
      pkg = File.basename(pkg);
      hours = ((Time.now - Time.at(n.to_i))/3600).to_i;
      STDOUT.write "{\"the_latest_package\": \"#{pkg}\", \"modified\": \"#{hours} hour(s) ago\", ";
    ' \
   | awk 'BEGIN {found=0} { printf("%s", $0); found+=1 } END { if (found==0) { printf("{\"error\": \"Mirror out-of-date, or No new package in the last 7 days.\", "); }}'

  if [[ "$_distro" == "archlinux" ]]; then
    echo "\"score\": \"$(_distro_score_archlinux)\","
  fi

  echo "\"distro\": \"$_distro\"}"
}

_distro_ubuntu() {
  echo "{\"the_latest_package\": \"pacman\", \"modified\": \"Wed Nov  1 14:03:32 +07 2030\", \"distro\": \"ubuntu\"},"
}

set -u

_F_OUTPUT="${_F_OUTPUT:-/home/www/public/config/status.json}"

{
  echo "{\"mirrors\":["
  _distro_last_mod archlinux; echo ","
  _distro_last_mod blackarch; echo ","
  _distro_last_mod archlinuxarm; echo ","
  _distro_ubuntu
  _distro_last_mod slitaz;
  echo "]",
  echo "\"status_updated_at\": \"$(date)\""
  echo "}"
} > "$_F_OUTPUT.tmp"
mv -fv "$_F_OUTPUT.tmp" "$_F_OUTPUT"
