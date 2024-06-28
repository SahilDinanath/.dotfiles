{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./git.nix
    ./bash.nix
    ./nvim.nix
    ./tmux.nix
    ./config.nix
    ./fish.nix
  ];
}
