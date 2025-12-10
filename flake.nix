{
  description = "A very basic system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, ... }: {

    nixosModules = ./modules/nixos;
    homeManagerModules = ./modules/home-manager;

    nixosConfigurations.ooo = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit (self) inputs; };
      modules = [ 
        ./nixos/configuration.nix
      ];
    };

  };
}
