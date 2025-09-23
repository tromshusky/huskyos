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
      ./huskyos-options.nix
      ./user.nix
      ./plymouth.nix
      ./root-pw.nix
      ./steam.nix
    ];
}

