{ config, ... }:{
  environment.etc."nixos/backup".source = config.huskyos.flakeUri;
}
