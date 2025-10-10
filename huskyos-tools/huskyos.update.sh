#!/bin/sh
echo until proper fixing root will be required
chomd 0755 / || { echo root required; exit; }
systemctl start nixos-upgrade.service | nix-shell -p zenity --run "zenity --progress --pulsate --text='Update'"
