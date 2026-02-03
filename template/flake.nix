{
## the stable nixos branch gets published in the month 05 and 11 every year.
## the rolling release branch is selected by default "github:NixOS/nixpkgs/nixos-unstable";

#  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.huskyos.inputs.nixpkgs.follows = "nixpkgs";
  inputs.huskyos.url = "github:tromshusky/huskyos";
  outputs = { huskyos, self, ... } : huskyos.withSelf self;
}
