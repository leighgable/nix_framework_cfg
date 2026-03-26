# https://nixos.wiki/wiki/Module
{
  # List your module files here
  imports = [ 
   ./zellij.nix 
   ./helix.nix
   ./fonts.nix
  ];
}
