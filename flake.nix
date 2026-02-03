{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { nixpkgs, ... }:
    {
      withSelf =
        { outPath, ... }:
        let
          base = "${outPath}/BASE";
          keyboard-layout = "${outPath}/KBD";
          hashed-root-password = "${outPath}/RPW";
          btrfs-device = "${outPath}/BTR";
          efi-device = "${outPath}/EFI";
          hardware-configuration-no-filesystems = "${outPath}/hardware-configuration-no-filesystems.nix";
          extra-config = fileThatExistsMapElse "${outPath}/config.nix" (_: _) { };

          fileThatExistsMapElse =
            fPath: mapFile: els:
            if (builtins.pathExists fPath) && (builtins.readFileType fPath == "regular") then
              (mapFile fPath)
            else
              els;
          firstLineOfFileElse = fPath: els: (fileThatExistsMapElse fPath firstLine els);
          firstLine = text: (builtins.head (builtins.split "\n" (builtins.readFile text)));

          buildArg = {
            modules = [
              hardware-configuration-no-filesystems
              ./configuration.nix
              {
                huskyos.btrfsDevice = builtins.readFile btrfs-device;
                huskyos.efiDevice = builtins.readFile efi-device;
                huskyos.flakeFolder = outPath;
                huskyos.hardwareUri = hardware-configuration-no-filesystems;
                huskyos.keyboardLayout = firstLineOfFileElse keyboard-layout "us";
                huskyos.hashedRootPassword = firstLineOfFileElse hashed-root-password null;
              }
              extra-config
            ];
          };
        in
        {
          nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem buildArg;
        };
    };
}
