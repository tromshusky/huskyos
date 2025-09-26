{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { nixpkgs, ... }:
    {
      grub =
        {
          nixos-extra-config ? {},
          keyboard-layout ? "us",
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
                huskyos.flakeFolder = this-flake;
                huskyos.hardwareUri = hardware-configuration-no-filesystems;
                huskyos.keyboardLayout = if
                    (builtins.pathExists keyboard-layout) && 
                    (builtins.readFileType keyboard-layout == "regular") then
                    (builtins.head (builtins.split "\n" (builtins.readFile keyboard-layout)))
                  else
                    "us";
                huskyos.hashedRootPassword = if (builtins.pathExists hashed-root-password) && (builtins.readFileType hashed-root-password == "regular") then (builtins.head (builtins.split "\n" (builtins.readFile hashed-root-password))) else null;              }
              nixos-extra-config
            ];
          };
        };

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        modules = [
          # ./hardware-configuration-no-filesystems.nix
          ./configuration.nix
          {
            huskyos.btrfsDevice = "editme"; # /dev/sda2 for example
            huskyos.efiDevice = "editme"; # /dev/sda1 for example
            huskyos.flakeFolder = ./flake.nix;
            huskyos.hardwareUri = ./hardware-configuration-no-filesystems.nix;
            huskyos.hashedRootPassword = "rootpw123";
            huskyos.keyboardLayout = "us";
          }
        ];
      };
      
    };
}
