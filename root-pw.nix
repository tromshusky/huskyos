{ config, ... }:{
  users.users.root.hashedPassword = config.huskyos.hashedRootPassword;
}