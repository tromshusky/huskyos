{
  config,
  lib,
  pkgs,
  ...
}:
let
  mainServiceName = "nixos-upgrade.service";
  acName = "huskyos-activate";
  guiName = "huskyos-upgrade";

  activationService.enable = true;
  activationService.description = "Activate newest system";
  activationService.serviceConfig.Type = "oneshot";
  activationService.serviceConfig.ExecStart = "/nix/var/nix/profiles/system/activate";

  guiService.description = "GUI wrapper for system upgrade";
  guiService.enable = true;
  guiService.serviceConfig.ExecStart = "${upgradeNotifyScript}";
  guiService.serviceConfig.Type = "simple";
  guiService.serviceConfig.KillMode= "control-group";
  guiService.unitConfig.PartOf = [ mainServiceName ];
  guiService.unitConfig.BindsTo = [ mainServiceName ];
  guiService.unitConfig.Before = [ mainServiceName ];
  guiService.unitConfig.ConditionPathExistsGlob = "/run/user/*";
  guiService.wantedBy = [ mainServiceName ];

  guiUserService.description = "";
  guiUserService.serviceConfig.Type = "simple";
  guiUserService.serviceConfig.ExecStart = "${upgradeNotifyUserScript}";

  upgradeNotifyUserScript = pkgs.writeShellScript "myscript" ''
        export PATH=$PATH:/run/current-system/sw/bin:${pkgs.libnotify}/bin/
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"
        gnAni=/org/gnome/desktop/interface/enable-animations

        ntfBase() { notify-send --urgency=critical "System Update" "$@"; }
        ntf() { ntfBase --replace-id "$ID" "$@"; }
        ID=$(ntfBase -p "Updating the system...")

        activate() {
          systemctl start ${acName}.service && (
            ntf "...Update applied. Done."; exit 0;
          ) || (
            ntf "...Update activation failed. Applying on next boot. Done."; exit 1;
          )
        }
        cleanup() {
           [ "$(dconf read $gnAni-backup)" == "" ] && dconf write $gnAni-backup $(dconf read $gnAni);
           dconf write $gnAni false;
           answ=$(ntf --action=n=No --action=y=Activate "Update completed. Activate immediately?")
           dconf write $gnAni $(dconf read $gnAni-backup);
           case "$answ" in
             y) activate ;;
             n) sleep 1; ntf "Activating system later. Done."; exit 0 ;;
             *) sleep 1; ntf "No choice recognized. Done."; exit 1 ;;
           esac
        }
        trap cleanup EXIT TERM INT
        sleep infinity & wait $!
  '';

  upgradeNotifyScript = pkgs.writeShellScript "myscript" ''
    export PATH=$PATH:/run/current-system/sw/bin
    for i in /run/user/*; do
      iID=$(basename $i)
      systemd-run --uid=$iID -t -q --setenv=XDG_RUNTIME_DIR=$i ${upgradeNotifyUserScript} &
    done
    wait
  '';

  polkitExtraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            action.lookup("unit") == "${acName}.service") {
            return polkit.Result.YES;
        }
    });

    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            action.lookup("unit") == "${guiName}.service") {
            return polkit.Result.YES;
        }
    });
  '';
in
{
  systemd.services.${acName} = activationService;
  systemd.services.${guiName} = guiService;
  security.polkit.extraConfig = polkitExtraConfig;
}