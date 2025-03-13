{ pkgs, ... }:

with pkgs;
[
  #apps
  alacritty

  #terminal
  bash
  tldr
  fd
  tmux
  eza
  zoxide
  fzf
  bat
  btop
  starship

  ########
  #neovim#
  ########
  #inputs.neovim-nightly-overlay.packages.${pkgs.system}.default
  neovim
  #lsps
  pyright
  gopls
  rust-analyzer
  clang-tools
  lua-language-server
  nixd
  #debuggers
  # gdb
  #formatters
  nixfmt-rfc-style
  stylua
  rustfmt
  black
  #dev-packages
  go
  gcc
  rustc
  python3
  gnumake
  #tools
  git
  lazygit
  direnv
  docker
  #dependencies
  cargo
  ripgrep
  nodejs_22
  nerdfonts
  wl-clipboard
  xsel
  lua
  luarocks

  #miscellaneous
  # lshw
  man-pages
  man-pages-posix
]
