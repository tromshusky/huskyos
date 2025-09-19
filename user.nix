{ lib, ... }:
let
  username = "user";
in
{
  users.users."${username}".password = lib.mkDefault "";
  users.users."${username}".isNormalUser = lib.mkDefault true;
  users.users."${username}".uid = lib.mkDefault 1000;
  services.displayManager.autoLogin.user = lib.mkDefault username;
}