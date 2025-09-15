{
  inputs.nixpkgs1.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs1 }:
    {
      grub =
        {
          nixpkgs ? nixpkgs1,
          btrfs-device,
          efi-device,
          hardware-configuration-no-filesystems,
          this-flake,
        }:
        {
          nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
            modules = [
              hardware-configuration-no-filesystems
              ./configuration.nix
              {
                huskyos.btrfsDevice = btrfs-device;
                huskyos.efiDevice = efi-device;
                huskyos.flakeUri = this-flake;
              }
            ];
          };
        };
      nixosConfigurations."nixos" = nixpkgs1.lib.nixosSystem {
        modules = [
          hardware-configuration-no-filesystems
          ./configuration.nix
          {
            huskyos.btrfsDevice = "editme"; # /dev/sda2 for example
            huskyos.efiDevice = "editme"; # /dev/sda1 for example
            huskyos.flakeUri = ./flake.nix;
          }
        ];
      };
    };
}
