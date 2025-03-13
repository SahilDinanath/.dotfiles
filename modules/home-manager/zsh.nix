{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
      FZF_DEFAULT_OPTS = "--bind 'ctrl-y:accept'";
      FZF_DEFAULT_COMMAND = "fd --type f";
    };
    shellAliases = {
      lst = "eza --tree --color=auto --group-directories-first";
      ls = "eza --color=auto --group-directories-first";
      exp = "xdg-open";
      ".." = "z ..";
      "..." = "z ../..";
    };
    initExtra = ''
      # Add scripts to path
      export PATH="$PATH:$HOME/.dotfiles/scripts"


      # Sane settings similar to bash-sensible
      setopt AUTO_CD              # Auto-cd into a directory by typing its name
      # setopt EXTENDED_GLOB        # Advanced globbing features
      # setopt NO_CASE_GLOB         # Case-insensitive globbing
      setopt HIST_IGNORE_DUPS     # Ignore duplicate history entries
      setopt HIST_IGNORE_SPACE    # Ignore commands starting with space
      setopt HIST_SAVE_NO_DUPS    # Don't save duplicate commands in history
      setopt SHARE_HISTORY        # Share history between sessions
      setopt INC_APPEND_HISTORY   # Append history immediately
      # setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode

      # History settings
      HISTSIZE=500000
      SAVEHIST=100000
      HISTFILE="$HOME/.zsh_history"
      HISTTIMEFORMAT='%F %T '

      # Prompt trimming
      PROMPT_DIRTRIM=2

      # Set up fzf keybinds and fuzzy completion
      eval "$(fzf --zsh)"

      # Setup zoxide
      eval "$(zoxide init zsh)"

      # Setup direnv
      eval "$(direnv hook zsh)"

      # Setup starship
      # eval "$(starship init zsh)"


      # Start tmux if in an interactive shell and not already in a tmux session
      if [[ -n $PS1 && -z $TMUX ]]; then
        tmux new-session -A -s main
      fi

    '';
  };
}
