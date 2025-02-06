
  rootator.systemd.services.rootate.enable = true;
  rootator.systemd.services.rootate.wantedBy = [ "default.target" ];
  rootator.systemd.services.rootate.script = ''
