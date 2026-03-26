{
  description = "A very basic system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#   crane = {
#      url = "github:ipetkov/crane";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };
    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nvf,
      emacs-overlay,
      ...
    }:
    {

      nixosModules = ./modules/nixos;
      homeManagerModules = ./modules/home-manager;

      nixosConfigurations.ooo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit (self) inputs; };
        modules = [
          ({config, pkgs, ...}: {
            nixpkgs.overlays = [
              emacs-overlay.overlay ];})
          ./nixos/configuration.nix
          nvf.nixosModules.default
        ];
      };

    };
}
