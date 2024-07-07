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
      fish_add_path ~/.dotfiles/scripts/

      set -gx FZF_DEFAULT_COMMAND "fd --type f"

      set fish_greeting
    '';

    shellInitLast = ''
      fzf --fish | source
      zoxide init fish | source
      direnv hook fish | source
    '';
  };
}
