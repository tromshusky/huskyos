{ config, ... }:{
  environment.etc."nixos/backup/flake.nix" = config.huskyos.flakeUri;
}