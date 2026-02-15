{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "huskyos-tools";
  version = "0";

  propagatedBuildInputs = [ pkgs.zenity pkgs.expect ]; 
 

  src = "${./.}";
  phases = [ "installPhase" ]; # Removes all phases except installPhase
  installPhase = ''
    mkdir -p $out/bin
    cp $src/huskyos.switch.sh $out/bin/huskyos-switch
    cp $src/huskyos.edit.sh $out/bin/huskyos-edit
    cp $src/huskyos.install.sh $out/bin/huskyos-install
    cp $src/huskyos.info.sh $out/bin/huskyos-info
    cp $src/huskyos.update.sh $out/bin/huskyos-update
    cp $src/flatas.sh $out/bin/flatas
    cp $src/runas.sh $out/bin/runas
    patchShebangs $out/bin
    chmod +x $out/bin/*
  '';
}
