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
        export XDG_RUNTIME_DIR="/run/user/$(id --user)"
        gnAni=/org/gnome/desktop/interface/enable-animations

        ntfBase() { notify-send --urgency critical --icon "folder-download-symbolic" --app-name "System Update" "$@"; }
        ntf() { ntfBase --replace-id "$ID" "$@"; }
        ntfExit() {
          ID=$(ntf --print-id "$1");
          sleep 5;
          gdbus call \
            --session \
            --dest org.freedesktop.Notifications \
            --object-path /org/freedesktop/Notifications \
            --method org.freedesktop.Notifications.CloseNotification \
            "$ID";
          exit $2;
        }
        ID=$(ntfBase --print-id "Updating the system...")
        activate() {
          systemctl start ${acName}.service && (
            ntfExit "...Update applied. Done." 0;
          ) || (
            ntfExit "...Update activation failed. Applying on next boot. Done."  1;
          )
        }
        cleanup() {
           [ "$(dconf read $gnAni-backup)" == "" ] && dconf write $gnAni-backup $(dconf read $gnAni);
           dconf write $gnAni false;
           answ=$(ntf --action n=No --action y=Activate "Update completed. Activate immediately?")
           dconf write $gnAni $(dconf read $gnAni-backup);
           case "$answ" in
             y) activate ;;
             n) sleep 1; ntfExit "Activating system later. Done." 0 ;;
             *) sleep 1; ntfExit "No choice recognized. Done." 1 ;;
           esac
        }
        trap cleanup EXIT TERM INT
        sleep infinity & wait $!
  '';

  upgradeNotifyScript = pkgs.writeShellScript "myscript" ''
    export PATH=$PATH:/run/current-system/sw/bin
    for i in /run/user/*; do
      iID=$(basename $i)
      systemd-run --uid $iID --pty --quiet --setenv XDG_RUNTIME_DIR=$i ${upgradeNotifyUserScript} &
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