{
  inputs.huskyos.url = "github:tromshusky/huskyos";
  outputs = { huskyos, ... } : huskyos.grub { 
    efi-device = ./EFI;
    btrfs-device = ./BTR;
    hashed-root-password = ./RPW;
    this-flake = "${./.}";
    hardware-configuration-no-filesystems = ./hardware-configuration-no-filesystems.nix;
    nixos-extra-config = {};
  };
}
