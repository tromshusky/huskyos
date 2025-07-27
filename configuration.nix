{ config, lib, pkgs, ... }:
let
  BACKUP = "${./.}";
  speci1.specialisation.huskyos.configuration = import ./huskyos.nix;
in
{
  imports =
    [
      ./filesystems.nix
      ./flathub.nix
      ./gnome.nix
      ./hardware-configuration-no-filesystems.nix
      speci1
    ];

  environment.etc."nixos/backup".source = BACKUP;

  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  services.homed.enable = true;
  users.users.guest.uid = 1000;
  users.users.guest.password = "";
  users.users.guest.isNormalUser = true;
  users.users.guest.home = "/guest";
  services.displayManager.autoLogin.user = "guest";  

#  system.stateVersion = "25.05";
}
