#!/bin/sh

# assertions
cond_disk="[ -v DISK ]"
cond_root="[ $EUID -eq 0 ]"
cond_parted="command -v parted"

$cond_root || echo "please run as root" >&2
$cond_disk || echo "DISK is not set" >&2
$cond_parted || echo "parted: no such command" >&2

$cond_root && $cond_disk && $cond_parted || exit

# variables
FIRST_PARTITION=$(lsblk -ro NAME $DISK | sed -n 3p)
echo $FIRST_PARTITION

echo NOT READY; exit

# execution

parted $DISK -- mklabel gpt
parted $DISK -- mkpart EFI fat32 1MB 4GB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart BTR btrfs 4GB 100%

FIRST_PARTITION=$(lsblk -ro NAME $DISK | head -n 2)



mkfs.fat -F 32 -n boot /dev/sda3
