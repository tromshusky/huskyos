{ config, lib, pkgs, ... }:
let
  __out.imports = [ debuggy unfree-drivers flakes ] ++ [ desktop.gnome-mini ];

  aAPPS = "/apps";
  myApps = "/apps/$(whoami)";
  aHUSKYOS = "/etc/nixos/huskyos";
  eHUSKYOS = "nixos/huskyos";
  aDEFAULTS = "/etc/nixos/huskyos/defaults";
  eDEFAULTS = "nixos/huskyos/defaults";
  HUS_SUBVOL_ABS = "@huskyos";
  root_subvol = "@root";
  rootPeach = "${root_subvol}-peach";
  rootApple = "${root_subvol}-apple";

#  selectedDE = lib.strings.fileContents "${./huskyos/DE}";

  btrDev = lib.strings.fileContents "${./huskyos/btrfsPart}";
  efiDev = lib.strings.fileContents "${./huskyos/efiPart}";
#  btrDev = builtins.elemAt (lib.splitString "\n" (builtins.readFile ./huskyos/btrfsPart)) 0;

  debuggy.services.openssh.enable = true;
  debuggy.users.users.root.password = "asd";

  desktop.gnome-mini.imports = [ desktop.gnome ];
  desktop.gnome-mini.services.xserver.enable = true;
  desktop.gnome.services.xserver.desktopManager.gnome.enable = true;
  desktop.gnome.services.xserver.enable = true;
  desktop.gnome.imports = [ desktop.graphical-base ];
  desktop.cosmic.imports = [ desktop.graphical-base ];
  desktop.graphical-base.boot.plymouth.enable = true;
  desktop.graphical-base.boot.plymouth.theme = "spinner";

  flakes.nix.settings.experimental-features = [ "nix-command" "flakes" ];

  unfree-drivers.nixpkgs.config.allowUnfree = true;
  unfree-drivers.environment.variables.NIXPKGS_ALLOW_UNFREE = "false";

  huskyos-fs.fileSystems."/".device = "${btrDev}";
  huskyos-fs.fileSystems."/".fsType = "btrfs";
  huskyos-fs.fileSystems."/".options = [ "subvol=${HUS_SUBVOL_ABS}/${root_subvol}" ];

  huskyos-fs.fileSystems."/apps".device = "/userdata/apps";
  huskyos-fs.fileSystems."/apps".fsType = "none";
  huskyos-fs.fileSystems."/apps".options = [ "bind" ];

  huskyos-fs.fileSystems."/boot".device = "${btrDev}";
  huskyos-fs.fileSystems."/boot".fsType = "btrfs";
  huskyos-fs.fileSystems."/boot".options = [ "subvol=${HUS_SUBVOL_ABS}/system/@boot" ];

  huskyos-fs.fileSystems."/boot/efi".device = "${efiDev}";
  huskyos-fs.fileSystems."/boot/efi".fsType = "vfat";
  huskyos-fs.fileSystems."/boot/efi".options = lib.splitString " " "fmask=0022 dmask=0022";

  huskyos-fs.fileSystems."/etc/NetworkManager".device = "/userdata/etc/NetworkManager";
  huskyos-fs.fileSystems."/etc/NetworkManager".fsType = "none";
  huskyos-fs.fileSystems."/etc/NetworkManager".options = [ "bind" ];

  huskyos-fs.fileSystems."/home".device = "/userdata/home";
  huskyos-fs.fileSystems."/home".fsType = "none";
  huskyos-fs.fileSystems."/home".options = [ "bind" ];

  huskyos-fs.fileSystems."/nix".device = "${btrDev}";
  huskyos-fs.fileSystems."/nix".fsType = "btrfs";
  huskyos-fs.fileSystems."/nix".options = [ "subvol=${HUS_SUBVOL_ABS}/system/@nix" ];

  huskyos-fs.fileSystems."/nix/store".device = "${btrDev}";
  huskyos-fs.fileSystems."/nix/store".fsType = "btrfs";
  huskyos-fs.fileSystems."/nix/store".options = [ "subvol=${HUS_SUBVOL_ABS}/@nixStore" ];

  huskyos-fs.fileSystems."/root/.cache/nix".device = "/userdata/root/.cache/nix";
  huskyos-fs.fileSystems."/root/.cache/nix".fsType = "none";
  huskyos-fs.fileSystems."/root/.cache/nix".options = [ "bind" ];

  huskyos-fs.fileSystems."/userdata".device = "${btrDev}";
  huskyos-fs.fileSystems."/userdata".fsType = "btrfs";
  huskyos-fs.fileSystems."/userdata".options = [ "subvol=${HUS_SUBVOL_ABS}/@userdata" ];

  huskyos-nixenv-apps.systemd.services.update-apps.enable = true;
  huskyos-nixenv-apps.systemd.services.update-apps.script = "sleep 30 || exit 19210 && [ $(find /nix/var/nix/profiles/per-user/root/profile -mmin +1440 -print || exit) ] || exit && ${pkgs.cpulimit}/bin/cpulimit -l20 /run/current-system/sw/bin/nix-env --upgrade";
  huskyos-nixenv-apps.systemd.services.update-apps.wantedBy = [ "default.target" ];
  huskyos-nixenv-apps.systemd.tmpfiles.rules = [ "d /apps 1770 root users -" ];
  huskyos-nixenv-apps.systemd.user.services.install-apps.enable = true;
  huskyos-nixenv-apps.systemd.user.services.install-apps.script = "sleep 30 || exit 19210; while true; do ${pkgs.inotify-tools}/bin/inotifywait --timeout 60 -e CLOSE_WRITE ${myApps}; cat /apps/$USER | sed 's|^|nix profile install nixpkgs#|' | sh && rm ~/.local/state/nix/profiles/*; cat /apps/user | sed 's|^|nix profile install nixpkgs#|' | sh; done"; # */
  huskyos-nixenv-apps.systemd.user.services.install-apps.wantedBy = [ "default.target" ];
  huskyos-nixenv-apps.systemd.user.services.update-apps.enable = true;
  huskyos-nixenv-apps.systemd.user.services.update-apps.script = "cp -u ${aDEFAULTS}/apps-user ${myApps} & sleep 40 || exit 19210 && [ $(find ~/.local/state/nix/profiles/profile -mmin +1440 -print) ] || exit && ${pkgs.cpulimit}/bin/cpulimit -l20 /run/current-system/sw/bin/nix-env --upgrade";
  huskyos-nixenv-apps.systemd.user.services.update-apps.wantedBy = [ "default.target" ];

in __out
