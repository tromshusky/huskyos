{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "huskyos-tools";
  version = "1.0";

  src = "${./.}";
  phases = [ "installPhase" ]; # Removes all phases except installPhase

  installPhase = ''
    mkdir -p $out/bin
    cp $src/huskyos.switch.sh $out/bin/huskyos-switch
    cp $src/huskyos.edit.sh $out/bin/huskyos-edit
    cp $src/huskyos.install.sh $out/bin/huskyos-install
    chmod +x $out/bin/*
  '';
}