```nix
# example flake.nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-untable";
  inputs.huskyos.url = "github:tromshusky/huskyos";
  outputs = { self, nixpkgs, huskyos }:{
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      modules = [
        huskyos.nixosConfigurations."nixos"
        {
          huskyos.btrfs_device = "/dev/sda2";
          huskyos.efi_device = "/dev/sda1";
          huskyos.hardware-configuration-no-filesystems = "${./hardware-configuration-no-filesystems.nix}";
        }
      ];
    }
  };
}
```
