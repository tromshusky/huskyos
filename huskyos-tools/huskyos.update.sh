#!/bin/sh
systemctl start nixos-upgrade.service | nix-shell -p zenity --run "zenity --progress --pulsate --text='Update'"