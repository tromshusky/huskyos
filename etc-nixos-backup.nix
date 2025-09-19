{ config, ... }:{
  environment.etc."nixos/backup/flake.nix".source = config.huskyos.flakeUri;
}