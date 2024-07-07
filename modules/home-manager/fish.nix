{ pkgs, config, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      lst = "eza --tree --color=auto --group-directories-first";
      ls = "eza --color=auto --group-directories-first";
    };
    functions = {
      cde = ''
        function cdl
            cd $argv[1]; es
        end
      '';
    };
    interactiveShellInit = ''
      fish_vi_key_bindings
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_replace underscore
      set fish_cursor_external line
      set fish_cursor_visual block

      bind -M insert -m default jk cancel repaint-mode
      set -g fish_sequence_key_delay_ms 200

      bind -M insert \cn down-or-search
      bind -M insert \cp up-or-search
      bind -M insert \cy accept-autosuggestion

      fish_add_path ~/.dotfiles/scripts/

      set -gx FZF_DEFAULT_COMMAND "fd --type f"
      set -gx FZF_DEFAULT_OPTS "--bind 'ctrl-y:accept'"

      set fish_greeting
    '';

    shellInitLast = ''
      fzf --fish | source
      zoxide init fish | source
      direnv hook fish | source
    '';
  };
}
