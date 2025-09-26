{ ... }:{
  security.pam.mount.createMountPoints = true;
  security.pam.mount.extraVolumes = [
    # the first line is a bit hacky and only to autocreate the folder in case it does not exist (first launch)
    ''
      <volume fstype="none" path="/userdata/home.var/%(USER)/" mountpoint="/userdata/home.var/%(USER)/" options="bind" />
      <volume fstype="none" path="/userdata/home.var/%(USER)/" mountpoint="~/.var" options="bind" />
    ''
  ];
}
