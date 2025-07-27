#!/bin/sh
1>/dev/null 2>/dev/null nixos-generate-config --show-hardware-config --no-filesystems || { printf "\nroot rights are required! use: \n\n    run0 \n"; exit; }
git --version || { printf "\ngit is required! use: \n\n    nix-shell -p git \n"; exit; }


TMPDIR=$(mktemp -d) || { echo error using mktemp -d; exit; }
DEV_BTRFS=/dev/disk/by-uuid/$(findmnt -n -o UUID /nix/) || { echo error using findmnt; exit; }
DEV_EFI=/dev/disk/by-uuid/$(findmnt -n -o UUID /boot/efi) || { echo error using findmnt; exit; }

cd $TMPDIR || exit
git clone https://github.com/tromshusky/huskyos || exit
cd huskyos || exit
echo $DEV_BTRFS > BTR || exit
echo $DEV_EFI > EFI || exit
nixos-generate-config --show-hardware-config --no-filesystems > hardware-configuration-no-filesystems.nix || exit
touch RPW && chmod 0600 RPW || exit
grep ^root /etc/shadow | cut -f2 -d: > RPW || exit
nixos-rebuild boot --flake .
