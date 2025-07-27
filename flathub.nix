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
    iFile=/var/lib/flatpak/INITIALIZED
    [ -e $iFile ] && exit
    flatpak=${pkgs.flatpak}/bin/flatpak
    sleep 30 && 
    $flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &&
    $flatpak install -y com.brave.Browser org.kde.dolphin com.mattjakeman.ExtensionManager net.mullvad.MullvadBrowser org.mozilla.Thunderbird &&
    touch $iFile
  '';
}
