{ pkgs, ... }:
let
  cosmicFilesDesktop = pkgs.stdenv.mkDerivation {
    pname = "cosmic-files-only-show-in";
    version = "1.0";
    buildCommand = ''
      mkdir -p $out/share/applications
      sed '/^OnlyShowIn=/d' ${pkgs.cosmic-files}/share/applications/com.system76.CosmicFiles.desktop > $out/share/applications/com.system76.CosmicFiles.desktop
      echo "OnlyShowIn=COSMIC" >> $out/share/applications/com.system76.CosmicFiles.desktop
    '';
  };
in
{
  services.desktopManager.cosmic.enable = true;

  environment.systemPackages = [ cosmicFilesDesktop ];
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-player
    cosmic-reader
    cosmic-screenshot
    cosmic-term
    networkmanagerapplet
    # from services.flatpak.enable
    cosmic-store
  ];
}