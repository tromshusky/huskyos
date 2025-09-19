{
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { nixpkgs-unstable, ... }:
    {
      grub =
        {
          nixpkgs ? nixpkgs-unstable,
          nix-extra-config ? {},
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
                huskyos.hardwareUri = "${hardware-configuration-no-filesystems}";
              }
              nix-extra-config
            ];
          };
        };
      nixosConfigurations."nixos" = nixpkgs-unstable.lib.nixosSystem {
        modules = [
          # ./hardware-configuration-no-filesystems.nix
          ./configuration.nix
          {
            huskyos.btrfsDevice = "editme"; # /dev/sda2 for example
            huskyos.efiDevice = "editme"; # /dev/sda1 for example
            huskyos.flakeUri = ./flake.nix;
            # huskyos.hardwareUri = "${./hardware-configuration-no-filesystems.nix}";
          }
        ];
      };
    };
}
