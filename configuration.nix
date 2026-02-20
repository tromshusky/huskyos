{ ... }:
{
  imports =
    [
      ./auto-timezone.nix
      ./bind-mounts.nix
      ./etc-huskyos.nix
      ./filesystems.nix
      ./flakes.nix
      ./flathub.nix
      ./gnome.nix
      ./grub.nix
      ./home-var-bindmount.nix
      ./huskyos-options.nix
      ./huskyos-tools.nix
      ./keyboard-layout.nix
      ./plymouth.nix
      ./root-pw.nix
      ./steam.nix
      ./update-gui.nix
      ./updating.nix
      ./user.nix
      ./wallpaper.nix
    ];
}

