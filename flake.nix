{
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { nixpkgs-unstable, ... }:
    {
      grub =
        {
          nixpkgs ? nixpkgs-unstable,
          nixos-extra-config ? {},
          hashed-root-password,
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
                huskyos.btrfsDevice = builtins.readFile btrfs-device;
                huskyos.efiDevice = builtins.readFile efi-device;
                huskyos.flakeUri = this-flake;
                huskyos.hardwareUri = hardware-configuration-no-filesystems;
                huskyos.hashedRootPassword = if (builtins.pathExists hashed-root-password) && (builtins.readFileType hashed-root-password == "regular") then (builtins.head (builtins.split "\n" (builtins.readFile hashed-root-password))) else null;
  hashed-root-password;
              }
              nixos-extra-config
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
            huskyos.hardwareUri = ./hardware-configuration-no-filesystems.nix;
            huskyos.hashedRootPassword = "rootpw123";
          }
        ];
      };
    };
}
