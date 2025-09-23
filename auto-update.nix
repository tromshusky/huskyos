{ config, ... }:{
  system.autoUpgrade.flake = "${config.huskyos.flakeFolder}";
  system.autoUpgrade.enable = true;
}
