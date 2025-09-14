{ config, ... }:{
  system.autoUpgrade.flake = config.huskyos.flakeUri;
  system.autoUpgrade.enable = true;
}
