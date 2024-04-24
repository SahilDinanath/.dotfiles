{
  pkgs,
  config,
  ...
}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    #
    #    plugins = with pkgs.vimPlugins; [
    #       vim-tmux-navigator
    #        lazygit-nvim
    # vim-sleuth
    #
    # telescope-nvim
    # telescope-fzf-native-nvim
    #
    # nvim-cmp
    # nvim-lspconfig
    #
    # neodev-nvim
    #
    #
    #
    #
    #
    #
    #    ];
    #
    extraPackages = with pkgs; [
      wl-clipboard
      xclip
      lazygit
    ];
  };
}
