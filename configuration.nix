{ config, lib, pkgs, ... }:
#  True = lib.mkOverride 900 true;
#  Frue = lib.mkOverride 900 false;
{
  imports =
    [
#      config.huskyos.hardware-configuration-no-filesystems # infinite recursion
      ./auto-update.nix
      ./etc-nixos-backup.nix
      ./filesystems.nix
      ./flakes.nix
      ./flathub.nix
      ./gnome.nix
      ./grub.nix
      ./huskyos.nix
      ./user.nix
      ./steam.nix
    ];
}

