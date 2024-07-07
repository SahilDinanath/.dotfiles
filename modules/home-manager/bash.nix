{ pkgs, config, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
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
    '';
  };
}
