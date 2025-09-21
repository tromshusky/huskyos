{
  inputs.huskyos.url = "github:tromshusky/huskyos";
  outputs = { huskyos, ... } : huskyos.grub { 
    efi-device = builtins.readFile ./EFI;
    btrfs-device = builtins.readFile ./BTR;
    hashed-root-password = if (builtins.pathExists ./RPW) && (builtins.readFileType ./RPW == "regular") then builtins.readFile ./RPW else null;
    this-flake = ./flake.nix;
    hardware-configuration-no-filesystems = ./hardware-configuration-no-filesystems.nix;
  };
}
