{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      husky1 = attrs: {
        "nixos" = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            { huskyos = attrs; }
          ];
        };
      };
    in
    {
      my_config = husky1;
      nixosConfigurations = husky1 { };
    };
}
