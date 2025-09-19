{ config, lib, pkgs, modulesPath, ... }:
let
  BTR_DEV = lib.fileContents ../BTR;
  EFI_DEV = lib.fileContents ../EFI;
in
{
  fileSystems."/" =
    { device = "tmpfs";
      fsType = "tmpfs";
      options = [ "size=16G" ];
    };

  fileSystems."/nix" =
    { device = BTR_DEV;
      fsType = "btrfs";
      options = [ "subvol=@huskyos/@nix" ];
    };

  fileSystems."/boot" =
    { device = BTR_DEV;
      fsType = "btrfs";
      options = [ "subvol=@huskyos/@boot" ];
    };

  fileSystems."/userdata" =
    { device = BTR_DEV;
      fsType = "btrfs";
      options = [ "subvol=@huskyos/@userdata" ];
    };

  fileSystems."/boot/efi" =
    { device = EFI_DEV;
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
}
