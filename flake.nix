{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { nixpkgs, ... }:
    {
      grub =
        {
          nixos-extra-config ? { },
          keyboard-layout ? "us",
          hashed-root-password ? null,
          btrfs-device,
          efi-device,
          hardware-configuration-no-filesystems,
          this-flake,
        }:
        let

          fileThatExistsMapElse =
            fPath: mapFile: els:
            if (builtins.pathExists fPath) && (builtins.readFileType fPath == "regular") then
              (mapFile fPath)
            else
              els;
          firstLineOfFileElse = fPath: els: (fileThatExistsMapElse fPath firstLine els);

          firstLine = text: (builtins.head (builtins.split "\n" (builtins.readFile text)));

          extraConfig = fileThatExistsMapElse nixos-extra-config (_: _) { };
        in
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
                huskyos.keyboardLayout = firstLineOfFileElse keyboard-layout "us";
                huskyos.hashedRootPassword = firstLineOfFileElse hashed-root-password null;
              }
              extraConfig
            ];
          };
        };

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        modules = [
          ## uncomment to use (remove #):
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