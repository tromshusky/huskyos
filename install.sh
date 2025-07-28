#!/bin/sh
zenity --list \
  --title="Disk Information" \
  --column="Disk Name" \
  --column="Size" \
  $(lsblk -d -b -o NAME,SIZE | tail -n +2 | awk '{print "/dev/"$1, $2/1024/1024/1024 "G"}')
