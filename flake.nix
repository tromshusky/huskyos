{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-untable";
  outputs = { self, nixpkgs, huskyos }:{
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        { lib, ... }:{
          options.huskyos.btrfs_device = lib.mkOption {
                  type = lib.types.str;
                  description = "";
                  example = "/dev/sda2";
          };
          options.huskyos.efi_device = lib.mkOption {
                  type = lib.types.str;
                  description = "";
                  example = "/dev/sda1";
          };
          options.huskyos.efi_device = lib.mkOption {
                  type = lib.types.submodule;
                  default = {};
                  example = "/dev/sda1";
          };
        }
      ];
    }
  };
}
