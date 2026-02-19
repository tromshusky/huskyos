{ config, ... }:{
  system.autoUpgrade.flags = [ "--upgrade-all" "--no-write-lock-file" ];
  system.autoUpgrade.flake = "${config.huskyos.flakeFolder}";
  system.autoUpgrade.enable = true;
}
