#!/bin/sh


TMPDIR=$(mktemp -d)
DEV_BTRFS=/dev/disk/by-uuid/$(findmnt -n -o UUID /nix/)
DEV_EFI=/dev/disk/by-uuid/$(findmnt -n -o UUID /boot/efi)

cd $TMPDIR

git clone https://github.com/tromshusky/huskyos
cd huskyos
echo $DEV_BTRFS > BTR
echo $DEV_EFI > EFI
