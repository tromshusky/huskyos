{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          { nix.settings.experimental-features = [ "nix-command flakes" ]; }
        ];
      };
    };
}
