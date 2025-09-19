{ config, ... }:{
  environment.etc."nixos/backup/flake.nix".source = config.huskyos.flakeUri;
  environment.etc."nixos/backup/hardware-configuration-no-filesystems.nix".source = config.huskyos.hardwareUri;
}
