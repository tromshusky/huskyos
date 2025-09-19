{ lib, ... }:
let
  username = "user";
  user.password = lib.mkDefault "";
  user.isNormalUser = lib.mkDefault true;
  user.uid = lib.mkDefault 1000;
in
{
  users.users."${username}" = user;
  services.displayManager.autoLogin.user = lib.mkDefault username;
}