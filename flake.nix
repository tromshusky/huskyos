{
  inputs.huskyos.url = "github:tromshusky/huskyos";
  outputs = { huskyos, ... } : huskyos.grub { 
    efi-device = ./EFI;
    btrfs-device = ./BTR;
    hashed-root-password = ./RPW;
    this-flake = ./flake.nix;
    hardware-configuration-no-filesystems = ./hardware-configuration-no-filesystems.nix;
    nix-extra-config = ./config.nix;
  };
}
