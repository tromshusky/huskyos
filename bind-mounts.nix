{ ... }:
let
  bind-userdata = folder: {
    what = "/userdata${folder}";
    where = folder;
    options = "bind";
    wantedBy = [ "multi-user.target" ];
  };
  folders = [
    "/etc/NetworkManager"
    "/home"
    "/root"
    "/steamapps"
    "/var/lib"
  ];
in
{
  systemd.mounts = map bind-userdata folders;
}
