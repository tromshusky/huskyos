{
  inputs.huskyos.url = "github:tromshusky/huskyos";
  outputs = { huskyos, ... } : huskyos.grub { 
    efi-device = builtins.readFile ./EFI;
    btrfs-device = builtins.readFile ./BTR;
    this-flake = ./flake.nix;
    hardware-configuration-no-filesystems = ./hardware-configuration-no-filesystems.nix;
  };
}
