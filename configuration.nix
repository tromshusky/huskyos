{ ... }:
{
  imports =
    [
      ./auto-timezone.nix
      ./auto-update.nix
      ./bind-mounts.nix
      ./etc-huskyos.nix
      ./filesystems.nix
      ./flakes.nix
      ./flathub.nix
      ./gnome.nix
      ./grub.nix
      ./huskyos-tools.nix
      ./huskyos-options.nix
      ./keyboard-layout.nix
      ./user.nix
      ./plymouth.nix
      ./root-pw.nix
      ./steam.nix
    ];
}

