{
  config,
  lib,
  pkgs,
  ...
}:
let
  acName = "huskyos-activate";

  activationService.enable = true;
  activationService.description = "Activate newest system";
  activationService.serviceConfig.Type = "oneshot";
  activationService.serviceConfig.ExecStart = "/nix/var/nix/profiles/system/activate";

  upgradeNotifyUserScript = pkgs.writeShellScript "myscript" ''
        dconf() { /run/current-system/sw/bin/dconf "$@" || echo; }
        notify-send() { ${pkgs.libnotify}/bin/notify-send "$@"; }

        export XDG_RUNTIME_DIR=/run/user/1000
        gnAni=/org/gnome/desktop/interface/enable-animations

        ID=$(notify-send -p --urgency=critical "System Update" "Updating the system...")

        ntf() {
          notify-send --urgency=critical --expire-time=5000 --replace-id "$ID" "System Update" "$@"
        }
        activate() {
          if /run/current-system/sw/bin/systemctl start ${acName}.service; then
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
#         while sleep 2; do :; done
  '';

  polkitExtraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            action.lookup("unit") == "${acName}.service") {
            return polkit.Result.YES;
        }
    });
  '';

  upgradeNotifyScript = pkgs.writeShellScript "myscript" ''
    for i in /run/user/*; do
      iID=$(/run/current-system/sw/bin/basename $i)
      iUSER=$(/run/current-system/sw/bin/getent passwd $iID | /run/current-system/sw/bin/cut -d: -f1)
      /run/current-system/sw/bin/machinectl shell $iUSER@ "${upgradeNotifyUserScript}" & disown
    done
  '';
in
{
  systemd.services.nixos-upgrade.serviceConfig.ExecStartPre = [ "${upgradeNotifyScript}" ];
  systemd.services.${acName} = activationService;
  security.polkit.extraConfig = polkitExtraConfig;
}