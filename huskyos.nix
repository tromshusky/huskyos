{ lib, ...}:
let
  BTR_OPTION.type = lib.types.str;
  BTR_OPTION.description = "";
  BTR_OPTION.example = "/dev/sda2";
  EFI_OPTION.type = lib.types.str;
  EFI_OPTION.description = "";
  EFI_OPTION.example = "/dev/sda1";
  FLAKE_OPTION.type = lib.types.path;
  HW_OPTION.type = lib.types.submodule {};
  HW_OPTION.default = {};
  STEAM_OPTION.type = lib.mkEnableOption "global steam apps";
in
{
  options.huskyos.btrfsDevice = lib.mkOption BTR_OPTION;
  options.huskyos.efiDevice = lib.mkOption EFI_OPTION;
  options.huskyos.flakeUri = lib.mkOption FLAKE_OPTION;
  options.huskyos.hardware-configuration-no-filesystems = lib.mkOption HW_OPTION;
}
