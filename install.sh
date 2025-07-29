#!/bin/sh
su -c "echo root ok" || { printf "needs root rights. run\n\n    run0\n"; exit; }
TARGET_DISK=$(zenity --list \
  --title="Disk Information" \
  --column="Disk Name" \
  --column="Size" \
  $(lsblk -d -b -o NAME,SIZE | tail -n +2 | awk '{print "/dev/"$1, $2/1024/1024/1024 "G"}'))
TD="$TARGET_DISK"
parted $TD -- mklabel gpt
parted $TD -- mkpart ESP fat32 1MB 1GB
parted $TD -- set 1 esp on
parted $TD -- mkpart btr btrfs 1GB 100%
mkfs.fat -F 32 "$TD"1
mkfs.btrfs "$TD"2
mkdir /mnt
mount -t tmpfs tmpfs /mnt || exit
mkdir /mnt/btr
mount "$TD"2 /mnt/btr
btrfs subvolume create /mnt/btr/@huskyos
btrfs subvolume create /mnt/btr/@huskyos/@boot /mnt/btr/@huskyos/@nix /mnt/btr/@huskyos/@userdata
mkdir /mnt/btr/@huskyos/@userdata/var /mnt/btr/@huskyos/@userdata/etc /mnt/btr/@huskyos/@boot/efi
btrfs subvolume create /mnt/btr/@huskyos/@userdata/@home /mnt/btr/@huskyos/@userdata/@root /mnt/btr/@huskyos/@userdata/var/@lib /mnt/btr/@huskyos/@userdata/etc/@NetworkManager