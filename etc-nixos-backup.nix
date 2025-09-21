{ config, ... }:{
  environment.etc."nixos/backup/flake.nix".source = config.huskyos.flakeUri;
  environment.etc."nixos/backup/hardware-configuration-no-filesystems.nix".source = config.huskyos.hardwareUri;
  environment.etc."nixos/backup/EFI".text = config.huskyos.efiDevice;
  environment.etc."nixos/backup/BTR".text = config.huskyos.btrfsDevice;
  environment.etc."nixos/backup/RPW".text = config.huskyos.hashedRootPassword;
}
