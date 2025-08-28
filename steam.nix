{ ... }:
{
  
  security.pam.mount.enable = true;
  security.pam.mount.extraVolumes = [
    ''
      <volume fstype="none" path="/steamapps" mountpoint="~/.local/share/Steam/steamapps" options="bind" /> 
      <volume fstype="none" path="/steamapps" mountpoint="~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps" options="bind" /> 
    ''
  ];
}
