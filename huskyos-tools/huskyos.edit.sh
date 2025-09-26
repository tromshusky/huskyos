#!/bin/sh
set -e

cond_root(){ [ $EUID -eq 0 ]; }
cond_etc_nixos_flake_exists(){ [ -f /etc/nixos/flake.nix ]; }
cond_etc_huskyos_flake_exists(){ [ -f /etc/huskyos/flake.nix ]; }
cond_editor(){ which $EDITOR; }

cond_root || echo "please run as root";
cond_etc_nixos_flake_exists || cond_etc_huskyos_flake_exists || echo "flake neither found at /etc/nixos/flake.nix nor at /etc/huskyos/flake.nix";
cond_editor || echo "no executable found in \$EDITOR";

cond_root || exit;
cond_etc_nixos_flake_exists || cond_etc_huskyos_flake_exists || exit;
cond_editor || exit;

cond_etc_nixos_flake_exists || cp /etc/huskyos/* /etc/nixos/ || {
    echo could not execute \"cp /etc/huskyos/* /etc/nixos/\";
    exit;
}

cond_etc_nixos_flake_exists;

$EDITOR /etc/nixos/flake.nix;