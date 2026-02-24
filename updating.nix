{ config, ... }:{
  system.autoUpgrade.flags = [ "--upgrade-all" "--no-write-lock-file" ];
  system.autoUpgrade.flake = "${config.huskyos.flakeFolder}";
  system.autoUpgrade.enable = true;
  systemd.services.nixos-upgrade.serviceConfig.SupplementaryGroups = [ "users" ];
  
  # allow all users to invoke an update
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            action.lookup("unit") == "nixos-upgrade.service") {
            return polkit.Result.YES;
        }
    });
  '';
}