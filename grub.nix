{ ... }:{
  boot.loader.grub.configurationLimit = 5;
  boot.loader.timeout = 1;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
}
