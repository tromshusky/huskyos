#!/bin/sh

USERNAME="$1"
APPNAME="$2"
ARGS="${@:3}"
DIR="/var/lib/flatpak/exports/share/applications"

## FINDING MATCHES

matched_files=""

for f in "$DIR"/*.desktop; do
    if grep -qi -- "--command=${APPNAME}" "$f"; then
        matched_files="$matched_files $f"
    fi
done

## SELCTING MATCH

set -- $matched_files
count=$#

case $count in
  0) echo "No matches found"; exit 1 ;;
  1) chosen="$1" ;;
  *)
    echo "Multiple matches found:"
    i=1
    for f in "$@"; do
        echo "  $i) $f"
        eval "file_$i=\"$f\""
        i=$((i+1))
    done
    printf "Choose one: "
    read choice
    eval "chosen=\$file_$choice"
    ;;
esac

echo "App: $chosen"

## USING EXEC FROM FILE

cmd="$(sed -n '/Desktop Entry/,$s/^Exec=//p' "$chosen" | head -n1)"
clean_cmd="$(printf '%s' "$cmd" \ | sed -e 's/%u//g' -e 's/%U//g' -e 's/%f//g' -e 's/%F//g')"
cmd_with_args="$clean_cmd $ARGS"
PS4='\n' set -x

su - $USERNAME -c "DISPLAY=$DISPLAY dbus-launch $cmd_with_args"
