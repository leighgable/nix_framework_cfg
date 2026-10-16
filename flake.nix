{
  description = "A very basic system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-amd-ai.url = "github:noamsto/nix-amd-ai";
  };

  outputs =
    {
      self,
      nixpkgs,
      # home-manager,
      emacs-overlay,
      nix-amd-ai,
      ...
    }:
    {

      nixosModules = ./modules/nixos;
      homeManagerModules = ./modules/home-manager;

      nixosConfigurations.ooo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit (self) inputs; };
        modules = [
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                emacs-overlay.overlay
              ];
            }
          )
          nix-amd-ai.nixosModules.default
          ./nixos/configuration.nix
        ];
      };

    };
}
