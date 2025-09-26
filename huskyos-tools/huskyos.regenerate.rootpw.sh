#!/bin/sh
PATH=$(nix-shell -p zenity --run "echo \$PATH")
export HUSKYOS_ROOT_PW=${
  zenity --entry --title='Set Root Password' --text='Enter the new root password:' --hide-text ||
  { zenity --error; exit; };
} && printf "$HUSKYOS_ROOT_PW" | tee /etc/nixos/RPW
