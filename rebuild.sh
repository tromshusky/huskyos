#!/bin/sh
1>/dev/null 2>/dev/null nixos-generate-config --show-hardware-config --no-filesystems || { printf "\nroot rights are required! use: \n\n    run0 \n"; exit; }

TMPDIR=$(mktemp -d) || { echo error using mktemp -d; exit; }
DEV_BTRFS=/dev/disk/by-uuid/$(findmnt -n -o UUID /nix/) || { echo error using findmnt; exit; }
DEV_EFI=/dev/disk/by-uuid/$(findmnt -n -o UUID /boot/efi) || { echo error using findmnt; exit; }

[ -f flake.nix ] && [ -f configuration.nix ] || {
  git --version || { printf "\ngit is required! use: \n\n    nix-shell -p git \n"; exit; }
  cd $TMPDIR || exit;
  git clone https://github.com/tromshusky/huskyos || exit;
  cd huskyos || exit;
}
echo "using $DEV_BTRFS as btrfs partiton and $DEV_EFI as efi partition"
echo $DEV_BTRFS > BTR || exit;
echo $DEV_EFI > EFI || exit;
printf "generating hardware configuration file... "
nixos-generate-config --show-hardware-config --no-filesystems > hardware-configuration-no-filesystems.nix || exit;
printf "done.\n"
printf "copying root password... "
touch RPW && chmod 0600 RPW || exit;
grep ^root /etc/shadow | cut -f2 -d: > RPW || exit;
printf "done.\n"
printf "generating system for next boot. After its finished, you'll be prompted to reboot. Use \n    nixos-rebuild --rollback \n to rollback in case you regret ...\n"
nixos-rebuild boot --flake .
printf "done.\n"
