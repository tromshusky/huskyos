{
  inputs.huskyos.url = "github:tromshusky/huskyos";
  outputs = { huskyos, ... } : huskyos.grub { 
    efi-device = builtins.readFile ./EFI;
    btrfs-device = builtins.readFile ./BTR;
    hashed-root-password = builtins.readFile ./RPW;
    this-flake = ./flake.nix;
    hardware-configuration-no-filesystems = ./hardware-configuration-no-filesystems.nix;
  };
}
