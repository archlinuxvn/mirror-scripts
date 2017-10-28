#!/usr/bin/env bash

# Author : hacker
# License: MIT

_distro_to_ext() {
  case "$1" in
  "slitaz") echo "*.tazpkg" ;;
  *)        echo "*.xz" ;;
  esac
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
      if n.match(/[0-9]+/)
        found = 1
      else STDERR.puts "input #{$_} not found..."
      end

      pkg = File.basename(pkg);
      hours = ((Time.now - Time.at(n.to_i))/3600).to_i;
      STDOUT.write "{\"the_latest_package\": \"#{pkg}\", \"modified\": \"#{hours} hour(s) ago\", ";
    ' \
   | awk 'BEGIN {found=0} { printf("%s", $0); found+=1 } END { if (found==0) { printf("{\"error\": \"Mirror out-of-date, or No new package in the last 7 days.\", "); }}'

  echo "\"distro\": \"$_distro\"}"
}

set -u

_F_OUTPUT="${_F_OUTPUT:-/home/www/public/config/status.json}"

{
  echo "{\"mirrors\":["
  _distro_last_mod archlinux; echo ","
  _distro_last_mod blackarch; echo ","
  _distro_last_mod slitaz;
  echo "]",
  echo "\"status_updated_at\": \"$(date)\""
  echo "}"
} > "$_F_OUTPUT.tmp"
mv -fv "$_F_OUTPUT.tmp" "$_F_OUTPUT"
