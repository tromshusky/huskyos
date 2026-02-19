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
  guiService.unitConfig.PartOf = [ mainServiceName ];
  guiService.unitConfig.BindsTo = [ mainServiceName ];
  guiService.unitConfig.Before = [ mainServiceName ];
  guiService.unitConfig.ConditionPathExistsGlob = "/run/user/*";
  guiService.wantedBy = [ mainServiceName ];

  upgradeNotifyUserScript = pkgs.writeShellScript "myscript" ''
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"
        export PATH=$PATH:/run/current-system/sw/bin:${pkgs.libnotify}/bin/
        gnAni=/org/gnome/desktop/interface/enable-animations

        ID=$(notify-send -p --urgency=critical "System Update" "Updating the system...")

        ntf() {
          notify-send --urgency=critical --expire-time=5 --replace-id "$ID" "System Update" "$@"
        }
        activate() {
          if systemctl start ${acName}.service; then
            ntf "...Update applied. Done."; exit 0;
          else
            ntf "...Update activation failed. Applying on next boot. Done."; exit 1;
          fi
        }
        cleanup() {
           local userSetting=$(dconf read $gnAni)
           dconf write $gnAni false;
           answ=$(notify-send --urgency=critical --replace-id "$ID" --action=n=No --action=y=Acitvate "System Update" "Update completed. Activate immediately?")
           dconf write $gnAni $userSetting;
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
      iUSER=$(getent passwd $iID | cut -d: -f1)
      machinectl shell --quiet $iUSER@ "${upgradeNotifyUserScript}" &
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