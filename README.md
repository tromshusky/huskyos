# QUICK INSTALL

```sh
sh <(https://raw.githubusercontent.com/tromshusky/huskyos/huskyos-tools/huskyos.install.sh)
```
DONE

# MORE

```sh
BTR=/dev/CHANGEME
EFI=/dev/CHANGEME

mount -t tmpfs tmpfs /mnt
mkdir /mnt/boot /mnt/nix /mnt/userdata

mount $BTR /mnt/nix
btrfs subvolume create /mnt/nix/@huskyos /mnt/nix/@huskyos/@boot /mnt/nix/@huskyos/@nix /mnt/nix/@huskyos/@userdata
umount /mnt/nix

mount $BTR -o subvol=@huskyos/@nix /mnt/nix
mount $BTR -o subvol=@huskyos/@boot /mnt/boot
mount $BTR -o subvol=@huskyos/@userdata /mnt/userdata

mkdir /mnt/boot/efi
mount $EFI /mnt/boot/efi
```
```sh
nixos-generate-config --show-hardware-config --no-filesystems > hardware-configuration-no-filesystems.nix
```
```sh
nixos-install --flake .#nixos
```
```nix
# flake.nix
{
  inputs.huskyos.url = "github:tromshusky/huskyos/refactor";
  outputs = { huskyos, ... } : huskyos.grub { 
    efi-device = "/dev/nvme0n1p1";
    btrfs-device = "/dev/nvme0n1p2";
    this-flake = ./flake.nix;
    hardware-configuration-no-filesystems = ./hardware-configuration-no-filesystems.nix;
    nix-extra-config.users.users.root.password = "secret123";
  };
}
```
