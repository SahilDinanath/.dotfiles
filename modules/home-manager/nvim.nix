{ pkgs, config, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = false;
    vimdiffAlias = true;
    defaultEditor = true;
  };

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };

  # home.file.".config/eww" = {
  #   source = ./twm/eww;
  #   recursive = true;
  # };
}
