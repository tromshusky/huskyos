{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.gnome-software ];
  services.flatpak.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.startsWith("org.freedesktop.Flatpak.")) return polkit.Result.YES;   
    });
  '';

  systemd.services.flathub-repo.wants = [ "network-online.target" ];
  systemd.services.flathub-repo.after = [ "network-online.target" ];
  systemd.services.flathub-repo.wantedBy = [ "network-online.target" ];
  systemd.services.flathub-repo.enable = true;
  systemd.services.flathub-repo.script = ''
    doneFile=/var/lib/flatpak/INITIALIZED
    [ -e $doneFile ] && exit
    flatpak=${pkgs.flatpak}/bin/flatpak
    notifysend=${pkgs.libnotify}/bin/notify-send
    runuser=/run/current-system/sw/bin/runuser
    sleep 30 &&
    desktop_user_id=$(loginctl show-session $(loginctl show-seat seat0 | grep ActiveSession | sed 's|ActiveSession=||') | grep User | sed 's|User=||')
    export DISPLAY=:0
    export XDG_RUNTIME_DIR=/run/user/$desktop_user_id
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$desktop_user_id/bus
    toast=$runuser -u $desktop_user_id $notifysend
    notification_id=$($toast -p "Installing Flathub" "wait...");
    $flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &&
    $toast -r $notification_id "Downloading Apps" "wait...";
    $flatpak install -y com.brave.Browser org.kde.dolphin com.mattjakeman.ExtensionManager net.mullvad.MullvadBrowser org.mozilla.Thunderbird &&
    touch $doneFile;
    $toast -r $notification_id -e "Apps installed" "...done"
  '';
}
