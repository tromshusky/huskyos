{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    {
      grub =
        { btrfs-device, efi-device, hardware-configuration-no-filesystems, this-flake }:
        {
          nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
            modules = [
#              hardware-configuration-no-filesystems # lets try importing inside of configuraion.nix first
              ./configuration.nix
              {
                huskyos.btrfsDevice = btrfs-device;
                huskyos.efiDevice = efi-device;
                huskyos.flakeUri = this-flake;
              }
            ];
          };
        };
      # if you want to use this flake to build the system, you have to set all the huskyos options by editing the files first
      # trying to use this flake will lead to an error otherwise
      nixosConfigurations = husky1 ;
    };
}
