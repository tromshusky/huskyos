{ lib, ...}:
let
  BTR_OPTION.type = lib.types.str;
  BTR_OPTION.description = "";
  BTR_OPTION.example = "/dev/sda2";
  EFI_OPTION.type = lib.types.str;
  EFI_OPTION.description = "";
  EFI_OPTION.example = "/dev/sda1";
  STR_OPTION.type = lib.types.str;
  NULL_OR_STR_OPTION.type = lib.types.nullOr lib.types.str;
  PATH_OPTION.type = lib.types.path;
  STEAM_OPTION.type = lib.mkEnableOption "global steam apps";
  
  # see https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/config/users-groups.nix#L355
  HASHED_PW_OPTION.type = lib.types.nullOr (lib.types.passwdEntry lib.types.str);
in
{
  options.huskyos.btrfsDevice = lib.mkOption BTR_OPTION;
  options.huskyos.efiDevice = lib.mkOption EFI_OPTION;
  options.huskyos.flakeFolder = lib.mkOption PATH_OPTION;
  options.huskyos.hardwareUri = lib.mkOption PATH_OPTION;
  options.huskyos.hashedRootPassword = lib.mkOption HASHED_PW_OPTION;
  options.huskyos.keyboardLayout = lib.mkOption STR_OPTION;
}
