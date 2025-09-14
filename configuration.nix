{ config, lib, pkgs, ... }:
#  True = lib.mkOverride 900 true;
#  Frue = lib.mkOverride 900 false;
{
  imports =
    [
      ./auto-update.nix
      ./filesystems.nix
      ./flathub.nix
      ./gnome.nix
      ./grub.nix
      ./huskyos.nix
      ./steam.nix
    ];
}

