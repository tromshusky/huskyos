#!/bin/sh
set -e

which >/dev/null 2>/dev/null nixos-rebuild ||
    export PATH=$(nix-shell -p nixos-rebuild --run "echo \$PATH") || {
        echo "error pulling nixos-rebuild binary." >&2
        exit;
    }

cond_root(){ [ $EUID -eq 0 ]; }
cond_etc_nixos_flake_exists(){ [ -f /etc/nixos/flake.nix ]; }

cond_root || echo "please run as root" >&2
cond_etc_nixos_flake_exists || echo "flake not found at /etc/nixos/flake.nix" >&2

cond_root || exit;
cond_etc_nixos_flake_exists || exit;

rm /etc/nixos/flake.lock || true;
nixos-rebuild switch --no-write-lock-file --flake /etc/nixos;