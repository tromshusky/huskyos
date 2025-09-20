#!/bin/sh

# assertions
cond_btrfs(){ which btrfs >/dev/null; }
cond_curl(){ which curl >/dev/null; }
cond_diskexs(){ lsblk $DISK; }
cond_diskpar(){ [ -v DISK ]; }
cond_mkbtr(){ which mkfs.btrfs >/dev/null; }
cond_mkfat(){ which mkfs.fat >/dev/null; }
cond_nixgen(){ which nixos-generate-config >/dev/null; }
cond_nixinst(){ which nixos-install >/dev/null; }
cond_parted(){ which parted >/dev/null; }
cond_root(){ [ $EUID -eq 0 ]; }

cond_btrfs || echo "btrfs: no such command" >&2
cond_curl || echo "curl: no such command" >&2
cond_diskexs || echo "$DISK is not a disk" >&2
cond_diskpar || echo "DISK is not set" >&2
cond_mkbtr || echo "mkfs.btrfs: no such command" >&2
cond_mkfat || echo "mkfs.fat: no such command" >&2
cond_nixgen || echo "nixos-generate-config: no such command" >&2
cond_nixinst || echo "nixos-install: no such command" >&2
cond_parted || echo "parted: no such command" >&2
cond_root || echo "please run as root" >&2

cond_btrfs || exit
cond_curl || exit
cond_diskexs || exit
cond_diskpar || exit
cond_mkbtr || exit
cond_mkfat || exit
cond_nixgen || exit
cond_nixinst || exit
cond_parted || exit
cond_root || exit

# variables


# execution
parted $DISK -- mklabel gpt
parted $DISK -- mkpart EFI fat32 1MB 4GB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart BTR btrfs 4GB 100%

EFI=$(lsblk -ro NAME $DISK | sed -n 3p)
BTR=$(lsblk -ro NAME $DISK | sed -n 4p)

mkfs.fat -F 32 $EFI
mkfs.btrfs $BTR

mount -t tmpfs tmpfs /mnt
mkdir /mnt/btr /mnt/nix /mnt/boot /mnt/userdata

mount -o subvol=/ $BTR /mnt/btr
btrfs subvolume create /mnt/btr/@huskyos
btrfs subvolume create /mnt/btr/@huskyos/@userdata /mnt/btr/@huskyos/@boot /mnt/btr/@huskyos/@nix

mount $BTR -o subvol=@huskyos/@boot /mnt/boot
mount $BTR -o subvol=@huskyos/@nix /mnt/nix
mount $BTR -o subvol=@huskyos/@userdata /mnt/userdata

mkdir /mnt/boot/efi /mnt/etc/nixos
mount $EFI /mnt/boot/efi

nixos-generate-config --show-hardware-config --no-filesystems > /mnt/etc/nixos/hardware-configuration-no-filesystems.nix
curl https://raw.githubusercontent.com/tromshusky/huskyos/huskyos-flake/flake.nix > /mnt/etc/nixos/flake.nix
echo $EFI > /mnt/etc/nixos/EFI
echo $BTR > /mnt/etc/nixos/BTR

nixos-install --no-root-password
