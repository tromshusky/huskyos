{ pkgs, ... }:
let
    huskyos-tools-source = pkgs.fetchFromGitHub {
        owner = "tromshusky";
        repo = "huskyos";
        rev = "huskyos-tools";
        hash = "sha256-nBQAtzu6Q3IZJV7rgyWqJQAx0Fr+Nz1ayt2EbvO2QJ4=";
    };
    huskyos-tools = (import "${huskyos-tools-source}/package.nix" pkgs);
in {
    environment.systemPackages = [ huskyos-tools ];
}