{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { nixpkgs, ... }:
    {
      grub =
        {
          nixos-extra-config ? "/dev/null/config.nix",
          keyboard-layout ? "${this-flake}/KBD",
          hashed-root-password ? "${this-flake}/RPW",
          btrfs-device ? "${this-flake}/BTR",
          efi-device ? "${this-flake}/EFI",
          hardware-configuration-no-filesystems ? "${this-flake}/hardware-configuration-no-filesystems.nix",
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

          extraConfigIsAttrs = (builtins.isAttrs nixos-extra-config)

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
              (fileThatExistsMapElse nixos-extra-config (_: _) (if (extraConfigIsAttrs) then nixos-extra-config) else {})
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
