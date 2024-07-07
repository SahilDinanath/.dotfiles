{ pkgs, config, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
      FZF_DEFAULT_OPTS = "--bind 'ctrl-y:accept'";
      FZF_DEFAULT_COMMAND = "fd --type f";
    };
    shellAliases = {
      lst = "eza --tree --color=auto --group-directories-first";
      ls = "eza --color=auto --group-directories-first";
    };
    initExtra = ''
      #add scripts to path
      export PATH="$PATH:~/.dotfiles/scripts"

      #setup fzf keybinds and fuzzy completion
      eval "$(fzf --bash)"

      #setup zoxide
      eval "$(zoxide init bash)"

      #setup direnv
      eval "$(direnv hook bash)"

      #setup starship
      eval "$(starship init bash)"

      # set tmux to open on start of interactive shell
      # code below checks whether tmux exists on the system
      # we're in an interactive shell
      # that tmux doesn't try to run within itself
      if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
      # Adapted from https://unix.stackexchange.com/a/176885/347104
      # Create session 'main' or attach to 'main' if already exists.
        tmux new-session -A -s main
      fi;

      set -o vi
      bind '"jk":vi-movement-mode'

    '';
  };
  home.file.".inputrc".text = ''
    set show-mode-in-prompt on
    set vi-cmd-mode-string "\1\e[2 q\2"
    set vi-ins-mode-string "\1\e[6 q\2"


    # Use vi key bindings (optional, if you prefer vim-like navigation)
    set editing-mode vi

    # Enable case-insensitive tab completion
    set completion-ignore-case on

    # Show all possible completions immediately, instead of cycling through
    set show-all-if-ambiguous on

    # Display matches for ambiguous patterns immediately
    set completion-query-items 1000

    # Ignore duplicate entries in command history
    set history-ignore-dups on

    # Ignore commands that begin with a space in the history
    set history-ignore-space on

    # Enable colored output for completion listings
    set colored-stats on

    # Enable incremental search (emacs-style)
    set incremental-search-history on

    # Enable menu-complete, which allows cycling through completions with tab
    TAB: menu-complete

    # Enable case-insensitive matching when performing completion
    set completion-ignore-case on 
  '';
}
