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
    ./twm.nix
    ./alacritty.nix
    #./fish.nix
  ];
}
