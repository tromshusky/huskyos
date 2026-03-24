# WHY

Other linux variants are usually aimed at users that constantly use `sudo` and/or have previous experience from Windows or Mac.

HuskyOS aims to be the computer equivalent of a family tablet. Easy to use, interface that reminds of iOS or Android, and "unbreakable" like mobile operating systems.

HuskyOS actively aims to deprecate flawed design decisions from other well known operating systems, for example with the following features:
- background updates of everything, apps as well as core system
- self cleaning: an operating system should not get slower over time. It is possible to have eqch update like a fresh reset while keeping userdata, ao why not do it by default?
- the installation process is as easy as possible 
- all apps are (un)installabe via the App Store, naking it possible to have a very clean system with 0 bloat
- completely managable user data. All user data is compartmentalized and can be deleted within seconds.
- no passwords by default. Passwords usually do not keep anyone out of your system. It is and should be difficult by default to wreck your system but possible to use the system without remembereing one more password.
- indestructible by design. 99.9% of desktop operating systems in use have a vulnerable core protected by many safe guard mechanisms, like AntiVirus, password prompts, backup partitions and repair tools. HuskyOS is built from the core to be indestructible and actually forgets all modifications to the core on a fresh boot. Permanent modifications are still possible but are stored in a short and readable way, allowing it to be backed up easily and/or copied to another system.
- multiple users on one account: multi user accounts are not widely used. HuskyOS allows to have a guest user account but still open apps for a specific user.
# Opinions about other Operating Systems for computers

## NixOS
#### Pros
- Best Immutable Base
- Copy-and-paste configuration
- Easy to widely customize

#### Cons
- Not for new users at all
- Opt in automatic updates

## Fedora Silverblue
#### Pros
- Immutable Base
- Easy to use for new users
- Centered around the most successful linux app ecosystem: flatpak
- Lots of good default configurations:
  - System updates with gui
  - Limited amount of rollback generations, keeping the backend tidy
#### Cons
- Limited hardware support
- No copy-and-paste configuration
- sudo-centered workflow
- permanently installed (gnome) default apps

## Windows
#### Pros
- hurdles to destroy the core system
#### Cons
- Not free
- Needs account
- No freedom to decide what your computer does
- Bloated
- Not configurable
- Slow
- Software obsolecense
- Not for old hardware 


## Debian
#### Pros
- easy to configure
#### Cons
- Not immutable
  - changes to the system are permanent and not reversible
  - Over time, uninstalled packages leave traces in the system that are almost impossible to manage
  - if the system does not boot, you lost everything
  
## GUIX
#### Pros
- Best immutable base
#### Cons
- Software is often outdated
- Limited software catalogue
- opt in nonfree firmware



# QUICK INSTALL (INTERACTIVE)

```sh
sh <(curl -L raw.github.com/tromshusky/huskyos/main/huskyos-tools/huskyos.install.sh)
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
  inputs.huskyos.url = "github:tromshusky/huskyos";
  outputs = { huskyos, ... } : huskyos.grub { 
    efi-device = "/dev/nvme0n1p1";
    btrfs-device = "/dev/nvme0n1p2";
    this-flake = ./flake.nix;
    hardware-configuration-no-filesystems = ./hardware-configuration-no-filesystems.nix;
    nix-extra-config.users.users.root.password = "secret123";
  };
}
```
