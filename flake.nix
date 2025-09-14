{
  inputs.huskyos.url = "github:tromshusky/huskyos";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs, huskyos }:
  {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      modules = [ 
        huskyos.nixosConfigurations."nixos"
        {
          fileSystems."/".device = "/dev/sda2";
          fileSystems."/boot/efi".device = "/dev/sda1";
        }
      ];
    };
  };
}
