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
      ".." = "z ..";
      "..." = "z ../..";
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
      #eval "$(starship init bash)"

      # set tmux to open on start of interactive shell
      # code below checks whether tmux exists on the system
      # we're in an interactive shell
      # that tmux doesn't try to run within itself
      if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
      # Adapted from https://unix.stackexchange.com/a/176885/347104
      # Create session 'main' or attach to 'main' if already exists.
        tmux new-session -A -s main
      fi;

      #sensible settings 
      #https://github.com/mrzool/bash-sensible/blob/master/sensible.bash

      #update window size after every command
      shopt -s checkwinsize

      #Automatically trim long paths in the prompt (requires Bash 4.x)
      PROMPT_DIRTRIM=2

      ##Smart TAB completion
      # Perform file completion in a case insensitive fashion
      bind "set completion-ignore-case on"
      # Treat - and _ the same
      bind "set completion-map-case on"
      # Display matches for ambiguous patterns at first tab press
      bind "set show-all-if-ambiguous on"

      ## BETTER DIRECTORY NAVIGATION ##

      # Correct spelling errors during tab-completion
      shopt -s dirspell 2> /dev/null

      ## SANE HISTORY DEFAULTS ##

      # Append to the history file, don't overwrite it
      shopt -s histappend

      # Save multi-line commands as one command
      shopt -s cmdhist

      # Record each line as it gets issued
      PROMPT_COMMAND='history -a'

      # Huge history. Doesn't appear to slow things down, so why not?
      HISTSIZE=500000
      HISTFILESIZE=100000

      # Avoid duplicate entries
      HISTCONTROL="erasedups:ignoreboth"

      # Don't record some commands
      export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear:vi"

      # Use standard ISO 8601 timestamp
      # %F equivalent to %Y-%m-%d
      # %T equivalent to %H:%M:%S (24-hours format)
      HISTTIMEFORMAT='%F %T '

      ## VIM Settings
      bind "set show-mode-in-prompt on"

      bind 'set vi-cmd-mode-string "\1\e[2 q\2"'
      bind 'set vi-ins-mode-string "\1\e[6 q\2"'

      set -o vi
      bind '"jk":vi-movement-mode'

      PS1='\n\[\e[1;32m\]\u@\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]> '
    '';
  };
}
