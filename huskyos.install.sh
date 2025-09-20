#!/bin/sh
[ -v DISK ] ||
DISK=/dev/$(nix-shell -p zenity --command "zenity --list --column 'ASD' --column 'EFE' --column 'ZXZ' --column 'YH' \$(lsblk -o NAME,SIZE,TYPE,TRAN | grep disk)")
sh <(curl https://raw.githubusercontent.com/tromshusky/huskyos/huskyos-tools/huskyos.install.entire.disk.efi.grub.sh)
