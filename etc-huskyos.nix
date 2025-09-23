{ config, ... }:{
  environment.etc."huskyos".source = config.huskyos.flakeFolder;
}