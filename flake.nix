{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { nixpkgs, ... }: { os = 
    myFlake:
    let

      base = "${myFlake.outPath}/BASE";
      keyboard-layout = "${myFlake.outPath}/KBD";
      hashed-root-password = "${myFlake.outPath}/RPW";
      btrfs-device = "${myFlake.outPath}/BTR";
      efi-device = "${myFlake.outPath}/EFI";
      hardware-configuration-no-filesystems = "${myFlake.outPath}/hardware-configuration-no-filesystems.nix";
      extra-config = fileThatExistsMapElse "${myFlake.outPath}/config.nix" (_: _) { };

      fileThatExistsMapElse =
        fPath: mapFile: els:
        if (builtins.pathExists fPath) && (builtins.readFileType fPath == "regular") then
          (mapFile fPath)
        else
          els;

      firstLineOfFileElse = fPath: els: (fileThatExistsMapElse fPath firstLine els);

      firstLine = text: (builtins.head (builtins.split "\n" (builtins.readFile text)));

    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        modules = [
          hardware-configuration-no-filesystems
          ./configuration.nix
          {
            huskyos.btrfsDevice = builtins.readFile btrfs-device;
            huskyos.efiDevice = builtins.readFile efi-device;
            huskyos.flakeFolder = myFlake.outPath;
            huskyos.hardwareUri = hardware-configuration-no-filesystems;
            huskyos.keyboardLayout = firstLineOfFileElse keyboard-layout "us";
            huskyos.hashedRootPassword = firstLineOfFileElse hashed-root-password null;
          }
          extra-config
        ];
      };
    };
  };
}
