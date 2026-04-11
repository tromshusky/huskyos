{
  pkgs,
  config,
  lib,
  ...
}:
let
  initCmdline = [ "init=/nix/var/nix/profiles/system/init" ];
  ukiConfig.imports = [ config.huskyos.hardwareUri ];
  ukiConfig.fileSystems = config.fileSystems;
  ukiConfig.boot.plymouth = config.boot.plymouth;
  ukiConfig.boot.kernelParams = config.boot.kernelParams ++ initCmdline;
  ukiConfig.boot.kernelPackages = pkgs.linuxPackages; # the normal kernel is lts (3 years support), latest is 3 month support, testing 0
  ukiSystemArgs.modules = [ ukiConfig ];
  ukiDir = config.specialisation.ukiboot.configuration.system.build.uki;

  # ukidir=$( nix build ${./possibleSeperateFlake/}#nixosConfigurations.nixos.config.specialisation.ukiboot.configuration.system.build.uki --no-link --print-out-paths) || exit 1;
  ukiInstallHook = pkgs.writeShellScript "uki-install-hook" ''
    PATH=$PATH:/run/current-system/sw/bin;
    echo building uki kernel...;
    #ukidir=... # possible lazy build process
    uki=${ukiDir}/nixos.efi;
    echo atomic swapping existing kernel...;
    tmpdir=$(mktemp -d) &&
    mount ${builtins.readFile ./EFI} $tmpdir &&
    mkdir -p $tmpdir/efi/boot;
    cd $tmpdir/efi/boot &&
    cp $uki BOOTX64-next.EFI &&
    sync &&
    mv BOOTX64-next.EFI BOOTX64.EFI || exit 1;
    echo ...uki bootloader sucessfully installed.;
    cd / &&
    umount $tmpdir;
  '';
in
{
  specialisation.ukiboot.inheritParentConfig = false;
  specialisation.ukiboot.configuration = ukiConfig;

  boot.loader.external.enable = true;
  boot.loader.external.installHook = ukiInstallHook;
}
