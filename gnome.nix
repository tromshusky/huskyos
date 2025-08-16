{ lib, pkgs, ... }:
let

  dconf1.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  dconf1.settings."org/gnome/desktop/interface".enable-hot-corners = false;
#  dconf1.settings."org/gnome/mutter".dynamic-workspaces = true;
#  dconf1.settings."org/gnome/mutter".edge-tiling = true;
  dconf1.settings."org/gnome/shell/extensions/touchup".navigation-bar-always-show-on-monitor = ''{"name":"CMN (0x00000000)","id":"CMN::0x14b1::0x00000000"}'';
  dconf1.settings."org/gnome/mutter".experimental-features = "['scale-monitor-framebuffer']";
  dconf1.settings."org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";
  dconf1.settings."org/gnome/shell".enabled-extensions = [ "dash-to-dock@micxgx.gmail.com" "touchup@mityax" ];
  dconf1.settings."org/gnome/shell".favorite-apps = lib.splitString " " "org.gnome.Nautilus.desktop firefox.desktop brave-browser.desktop";

in
{
  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.mutter]
    experimental-features=['scale-monitor-framebuffer']
  '';
  services.gnome.core-apps.enable = false;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
#  services.xserver.enable = true;
#  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];
  environment.systemPackages = [
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.touchup
  ];
  programs.dconf.profiles.user.databases = [ dconf1 ];
  documentation.nixos.enable = false;


  systemd.user.services.extension-installer.wants = [ "network-online.target" ];
  systemd.user.services.extension-installer.after = [ "network-online.target" ];
  systemd.user.services.extension-installer.wantedBy = [ "network-online.target" ];
  systemd.user.services.extension-installer.enable = true;
  systemd.user.services.extension-installer.script = ''
    doneFile=~/.config/GNOME_EXTENSIONS_INITIALIZED
    [ -e $doneFile ] && exit
    xdgopen=/run/current-system/sw/bin/xdg-open
    gnomeextensions=/run/current-system/sw/bin/gnome-extensions
    notifysend=${pkgs.libnotify}/bin/notify-send
    runuser=/run/current-system/sw/bin/runuser
    sleep 30 &&
    $xdgopen "gnome-extensions://touchup%40ityax?action=install" &&
    $gnomeextensions info "touchup@mityax" 1>/dev/null &&
    touch $doneFile;
  '';

}
