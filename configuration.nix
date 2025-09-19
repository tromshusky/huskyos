{ ... }:
{
  imports =
    [
      ./auto-timezone.nix
      ./auto-update.nix
      ./bind-mounts.nix
      ./etc-nixos-backup.nix
      ./filesystems.nix
      ./flakes.nix
      ./flathub.nix
      ./gnome.nix
      ./grub.nix
      ./huskyos-options.nix
      ./user.nix
      ./plymouth.nix
      ./steam.nix
    ];
}

