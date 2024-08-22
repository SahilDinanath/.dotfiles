{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = false;
    vimdiffAlias = true;
    defaultEditor = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
