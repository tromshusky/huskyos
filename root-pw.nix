{ config, ... }:{
  users.users.root.hashedPassword = config.huskyos.hashed-root-password;
}