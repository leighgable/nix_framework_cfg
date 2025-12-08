# https://nixos.wiki/wiki/Module
{
  # List your module files here
  options = import ./nixvim/options.nix;
  completions = import ./nixvim/completions.nix;
  keymappings = import ./nixvim/keymappings.nix;
  autocommands = import ./nixvim/autocommands.nix;
  todo = import ./nixvim/todo.nix;
}
