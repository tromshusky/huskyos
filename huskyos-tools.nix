{ pkgs, ... }:
let
    huskyos-tools = (import ./huskyos-tools/package.nix pkgs);
in {
    environment.systemPackages = [ huskyos-tools ];
}