{
#  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
#  inputs.huskyos.inputs.nixpkgs.follows = "nixpkgs";
  inputs.huskyos.url = "github:tromshusky/huskyos";
  outputs = { huskyos, ... } : huskyos.grub { 
    efi-device = ./EFI;
    btrfs-device = ./BTR;
    hashed-root-password = ./RPW;
    keyboard-layout = ./KBD;
    this-flake = "${./.}";
    hardware-configuration-no-filesystems = ./hardware-configuration-no-filesystems.nix;
#    nixos-extra-config = ./config.nix;
  };
}
