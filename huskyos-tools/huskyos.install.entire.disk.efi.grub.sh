#!/bin/sh
set -e

which >/dev/null 2>/dev/null mkpasswd curl mkfs.fat parted nixos-install nixos-generate-config btrfs mkfs.btrfs ||
  export PATH=$(nix-shell -p mkpasswd curl dosfstools parted nixos-install-tools btrfs-progs --run "echo \$PATH") || {
    echo "couldn't donwload missing programs";
    exit;
  }

# assertions
cond_root(){ [ $EUID -eq 0 ]; }
cond_diskexs(){ lsblk "$HUSKYOS_INSTALL_DISK" >/dev/null; }
cond_diskpar(){ [ -v HUSKYOS_INSTALL_DISK ]; }

cond_root || echo "please run as root" >&2
cond_diskpar || echo "HUSKYOS_INSTALL_DISK is not set" >&2
cond_diskpar && { cond_diskexs || echo "$HUSKYOS_INSTALL_DISK is not a disk" >&2; }

cond_diskpar || exit 1
cond_diskexs || exit 1
cond_root || exit 1

# variables

PART_SUFFIX=$([[ $HUSKYOS_INSTALL_DISK =~ [0-9]$ ]] && echo p)

# execution

parted $HUSKYOS_INSTALL_DISK --script mklabel gpt
parted $HUSKYOS_INSTALL_DISK --script mkpart EFI fat32 0% 4GiB set 1 esp on mkpart BTR btrfs 4GiB 100%

EFI=${HUSKYOS_INSTALL_DISK}${PART_SUFFIX}1
BTR=${HUSKYOS_INSTALL_DISK}${PART_SUFFIX}2

mkfs.fat -F 32 $EFI
mkfs.btrfs -q -f $BTR

mount -t tmpfs tmpfs /mnt
mkdir /mnt/btr /mnt/nix /mnt/boot /mnt/userdata

mount -o subvol=/ $BTR /mnt/btr
btrfs subvolume create /mnt/btr/@huskyos
btrfs subvolume create /mnt/btr/@huskyos/@userdata /mnt/btr/@huskyos/@boot /mnt/btr/@huskyos/@nix

mount $BTR -o subvol=@huskyos/@boot /mnt/boot
mount $BTR -o subvol=@huskyos/@nix /mnt/nix
mount $BTR -o subvol=@huskyos/@userdata /mnt/userdata

mkdir /mnt/boot/efi -p /mnt/etc/nixos
mount $EFI /mnt/boot/efi

nixos-generate-config --show-hardware-config --no-filesystems > /mnt/etc/nixos/hardware-configuration-no-filesystems.nix
curl https://raw.githubusercontent.com/tromshusky/huskyos/huskyos-flake/flake.nix > /mnt/etc/nixos/flake.nix
printf $EFI > /mnt/etc/nixos/EFI
printf $BTR > /mnt/etc/nixos/BTR
[ -v HUSKYOS_ROOT_PW ] && mkpasswd -m SHA-512 "$HUSKYOS_ROOT_PW" > /mnt/etc/nixos/RPW
[ -v HUSKYOS_KBD_LAYOUT ] && printf "$HUSKYOS_KBD_LAYOUT" > /mnt/etc/nixos/KBD

nixos-install --no-root-password --flake /mnt/etc/nixos#nixos
