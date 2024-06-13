{
  pkgs,
  config,
  ...
}: {
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

    shellInitLast = ''
      fzf --fish | source
      zoxide init fish | source
      direnv hook fish | source
    '';
  };
}
